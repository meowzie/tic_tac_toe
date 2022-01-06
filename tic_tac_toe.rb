# frozen_string_literal: true

# creates players, stores their names and symbols (X vs O) in variables.
class Player
  attr_accessor :player

  def initialize(player, symbol)
    @player = player
    @symbol = symbol
  end

  def namer
    @player = gets.chomp
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

positions = [Position.new(1), Position.new(2), Position.new(3), Position.new(4), Position.new(5), Position.new(6),
             Position.new(7), Position.new(8), Position.new(9)]

chart = " #{positions[0].position} | #{positions[1].position} | #{positions[2].position}
---+---+---
 #{positions[3].position} | #{positions[4].position} | #{positions[5].position}
---+---+---
 #{positions[6].position} | #{positions[7].position} | #{positions[8].position}"
