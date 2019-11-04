require 'open-uri'

class GamesController < ApplicationController
  def new
    array = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << array[rand(array.length)] }
    # raise
  end

  def score
    @word = params['word']
    # raise
    @letters = params['letters']
    @valid = valid_letters?(@word, @letters)
    @real = real_word?(@word)
    @result_hash = run_game(@word, @letters)
    session[:score] ||= 0
    session[:score] += @result_hash[:score]
    @score = session[:score]
    puts session[:score]
    # raise
    # @score = @result_hash[:score]
  end

  def valid_letters?(word, letters)
    word_array = word.upcase.scan(/\w/)
    try = word_array.all? do |letter|
      word_array.count(letter) <= letters.count(letter)
    end
    try
  end

  def real_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_serialized = open(url).read
    word = JSON.parse(dictionary_serialized)
    word['found']
  end

  def normal_end_hash(word, end_message)
    result_hash = {
      score: word.length,
      message: end_message
    }
    result_hash
  end

  def error_end_hash(end_message)
    result_hash = {
      score: 0,
      message: end_message
    }
    result_hash
  end

  def run_game(word, letters)
    # TODO: runs the game and return detailed hash of result
    # hash of :time :score :message
    if valid_letters?(word, letters) && real_word?(word)
      { message: "Congratulations! #{word} is a valid English word!", score: word.length }
      # normal_end_hash(word, "Congratulations! #{word} is a valid English word!")
    elsif real_word?(word)
      # hash of "Not in the letters"
      { message: "Sorry but #{word} can't be built out of #{letters}", score: 0 }
    else
      # hash of "Not a real English word"
      { message: "Sorry but #{word} can't be built out of #{letters}", score: 0 }
    end
  end
end
