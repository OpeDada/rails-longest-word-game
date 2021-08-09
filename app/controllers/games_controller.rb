require 'json'
require 'open-uri'

class GamesController < ApplicationController
  before_action :includes, only: [:score]
  before_action :valid, only: [:score]

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def includes
    @word = params[:new].downcase
    @letters = params[:letters].downcase
    @is_included = @word.chars.all? do |letter|
      @letters.count(letter) >= @word.chars.count(letter)
    end
  end

  def valid
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    json_word = URI.open(url).read
    @validity = JSON.parse(json_word)['found']
  end

  def score
    @message =
      if @validity == false
        "Sorry but #{@word} does not seem to be a valid English word..."
      elsif !@is_included
        "Sorry but #{@word} can't be built out of #{@letters}"
      else
        'You win!'
      end
  end
end
# is_included = word.chars.all? { |letter| letters.count(letter) >= word.chars.count(letter) }
