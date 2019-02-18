require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid_size = rand(2..15)
    @letters = generate_grid(grid_size)
    @time_start = Time.now
  end

  def score
    end_time = Time.now
    start_time = params[:start_time].to_time
    @result = run_game(params[:word], params[:letters].split, start_time, end_time)
    session[:score] = 0 if session[:score].nil?
    session[:score] += @result[:score]
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    # Output a random grid of letters
    alphabet_array = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
    grid_result = []
    grid_size.times { grid_result << alphabet_array.sample }
    grid_result
  end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  # use the API
  bolean = false
  base_url = "https://wagon-dictionary.herokuapp.com/"
  url = base_url + attempt
  serialized_word = open(url).read
  word_api = JSON.parse(serialized_word)
  grid_array = grid.sort
  attempt_array = attempt.upcase.split("").sort
  attempt_array.each do |letter|
    bolean = false
    index = 0
    grid_array.each do |element|
      if letter == element
        bolean = true
        grid_array.delete_at(index)
      end
      index = index + 1
      break if bolean
    end
    bolean ? next : break
  end
  if word_api["found"] && bolean
    score = attempt.length * (1 / (end_time - start_time))
    result_hash = {
      time: end_time - start_time,
      score: score,
      message: "Well Done!"
    }
  elsif word_api["found"]
    result_hash = {
      time: end_time - start_time,
      score: 0,
      message: "Sorry, \"#{attempt}\", is not in the grid"
    }
  elsif bolean
    result_hash = {
      time: end_time - start_time,
      score: 0,
      message: "Sorry, \"#{attempt}\", it's not an English word"
    }
  else
    result_hash = {
      time: end_time - start_time,
      score: 0,
      message: "Sorry, \"#{attempt}\", it's not an English word"
    }
  end
  result_hash
  end
end
