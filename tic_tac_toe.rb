# frozen_string_literal: true

# creates positions and updates them when they are chosen by the player
class Position
  attr_accessor :label, :occupied, :occupier

  def initialize(label)
    @label = label
    @occupied = false
    @occupier = nil
  end

  def update_position(player)
    @label = player.symbol
    @occupied = true
    @occupier = player.name
  end
end

# creates players, stores their names and symbols (X vs O) in variables.
class Player
  attr_accessor :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# contains the positions
class Board
  attr_accessor :positions, :wins

  def initialize
    @positions = []
    9.times { |counter| @positions << Position.new(counter) }
    @wins = [[positions[0], positions[1], positions[2]],
             [positions[3], positions[4], positions[5]],
             [positions[6], positions[7], positions[8]],
             [positions[0], positions[3], positions[6]],
             [positions[1], positions[4], positions[7]],
             [positions[2], positions[5], positions[8]],
             [positions[0], positions[4], positions[8]],
             [positions[2], positions[4], positions[6]]]
  end

  def won?
    @wins.any? do |line|
      line.all? { |position| position.label == 'X' } || line.all? do |position|
        position.label == 'O'
      end
    end
  end

  def x_won?
    @wins.any? { |line| line.all? { |position| position.label == 'X' } }
  end

  def put
    puts <<~HEREDOC

       #{@positions[0].label} | #{@positions[1].label} | #{@positions[2].label}
      ---+---+---
       #{@positions[3].label} | #{@positions[4].label} | #{@positions[5].label}
      ---+---+---
       #{@positions[6].label} | #{@positions[7].label} | #{@positions[8].label}

    HEREDOC
  end
end

# contains top level methods for the entire game
class Game
  def initialize
    @player1 = nil
    @player2 = nil
    @board = Board.new
    @counter = 0
    @is_up = @player1
    @winner = nil
  end

  def namer
    puts "What is player one's name?"
    @player1 = Player.new(gets.chomp.capitalize, 'X')
    puts "What is player two's name?"
    @player2 = Player.new(gets.chomp.capitalize, 'O')
    puts "\nGreat! #{@player1.name} is playing with #{@player1.symbol}, and #{@player2.name} is playing with #{@player2.symbol}"
    puts "Let's go!"
  end

  def game_over?
    @counter >= 9 || @board.won?
  end

  def looper
    until game_over?
      player = @counter.even? ? @player1 : @player2
      puts "\n#{player.name}'s turn"
      @board.put
      choice = choose(gets.chomp)
      @board.positions[choice].update_position(player)
      @counter += 1
    end
  end

  def valid?(choice)
    return false unless choice.to_i.to_s == choice

    choice = choice.to_i
    return false if choice.negative?
    return false if choice > 8

    occupied = %w[O X]
    return false if occupied.include?(@board.positions[choice].label)

    true
  end

  def choose(choice)
    until valid?(choice)
      puts 'Invalid input. Please enter the number of a free square.'
      choice = gets.chomp
    end
    choice.to_i
  end

  def conclude
    winner = @board.x_won? ? @player1 : @player2 if @board.won?
    @board.put
    return puts "#{winner.name} won!" if winner

    puts "It's a draw"
  end

  def play
    namer
    looper
    conclude
  end
end
