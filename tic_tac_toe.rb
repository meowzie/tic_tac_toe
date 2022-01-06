# frozen_string_literal: true

# creates players
class Player
  attr_accessor :name

  def initialize(player, symbol)
    @player = player
    @symbol = symbol
  end

  def namer
    puts "\nEnter #{@player}'s name:"
    @player = gets.chomp
    puts "\nHello, #{@player.capitalize}. You are playing with #{@symbol}."
  end
end
