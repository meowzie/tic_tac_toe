# frozen_string_literal: true

require 'pry-byebug'

# creates players, stores their names and symbols (X vs O) in variables.
class Player
  attr_accessor :player

  def initialize(player, symbol)
    @player = player
    @symbol = symbol
  end

  def namer
    @player = gets.chomp.capitalize
  end
end

# creates positions and updates them when they are chosen by the player
class Position
  attr_accessor :position

  def initialize(position)
    @position = position
  end

  def update_position(symbol)
    @position = symbol
  end
end

def win(array)
  return true if array.any? { |line| line.all? { |square| square == 'X' } || line.all? { |square| square == 'O' } }

  false
end

def find_winner(array)
  winner = ''
  return unless win(array)

  if array.any? { |line| line.all? { |square| square == 'X' }}
    winner = 1
  else
    winner = 2
  end
  winner
end

positions = [Position.new(1), Position.new(2), Position.new(3), Position.new(4), Position.new(5), Position.new(6),
             Position.new(7), Position.new(8), Position.new(9)]
player_one = Player.new('player one', 'X')
player_two = Player.new('player two', 'O')
counter = 0
winner = ''

puts 'What is player one\'s name?'
player_one.namer
puts 'And what is player two\'s name?'
player_two.namer
puts "\nHello #{player_one.player} and hello #{player_two.player}!\
 #{player_one.player} is playing with X and #{player_two.player} is playing with O. Let's start!\n"

wins = []
until win(wins)
  if counter.even?
    puts "\nIt's #{player_one.player}'s turn"
  else
    puts "\nIt's #{player_two.player}'s turn"
  end

  chart = "   #{positions[0].position} | #{positions[1].position} | #{positions[2].position}
  ---+---+---
   #{positions[3].position} | #{positions[4].position} | #{positions[5].position}
  ---+---+---
   #{positions[6].position} | #{positions[7].position} | #{positions[8].position}"
  puts chart

  choice = gets.chomp.to_i

  if counter.even?
    positions[choice - 1].update_position('X')
  else
    positions[choice - 1].update_position('O')
  end
  counter += 1
  wins = [
    [positions[0].position, positions[1].position, positions[2].position],
    [positions[3].position, positions[4].position, positions[5].position],
    [positions[6].position, positions[7].position, positions[8].position],
    [positions[0].position, positions[3].position, positions[6].position],
    [positions[1].position, positions[4].position, positions[7].position],
    [positions[2].position, positions[5].position, positions[8].position],
    [positions[0].position, positions[4].position, positions[8].position],
    [positions[2].position, positions[4].position, positions[6].position]
  ]
end
if find_winner(wins) == 1
  winner = player_one.player
else
  winner = player_two.player
end
puts "Game over. #{winner} is the winner."
