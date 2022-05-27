# frozen_string_literal: true

require '../tic_tac_toe'

describe Position do
  subject(:position) { described_class.new(1) }
  let(:player) { double(Player, name: 'Carol', symbol: 'X') }

  context 'when it is empty' do
    it 'is unoccupied' do
      expect(position.occupied).to eq(false)
    end

    it 'has no occupier' do
      expect(position.occupier).to eq(nil)
    end
  end

  context 'when it is updated' do
    it 'displays X as the label' do
      position.update_position(player)
      expect(position.label).to eq('X')
    end

    it 'is occupied' do
      position.update_position(player)
      expect(position.occupied).to eq(true)
    end

    it 'has an occupier' do
      position.update_position(player)
      expect(position.occupier).to eq(player.name)
    end
  end
end

describe Board do
  subject(:board) { described_class.new }
  let(:carol) { double(Player, name: 'Carol', symbol: 'X') }
  let(:celeste) { double(Player, name: 'Celeste', symbol: 'O') }

  context 'when it is empty' do
    it 'has 9 positions' do
      positions = board.positions
      expect(positions.length).to eq(9)
    end

    it 'has 8 win cases' do
      wins = board.wins
      expect(wins.length).to eq(8)
    end

    it 'is not won' do
      expect(board.won?).to eq(false)
    end
  end

  context 'when there is a straight line of one symbol' do
    it 'is won' do
      line = board.positions.slice(0..2)
      line.each { |position| position.update_position(carol) }
      expect(board.won?).to eq(true)
    end

    context 'when X wins' do
      it 'returns true for X being the winner' do
        line = board.positions.slice(0..2)
        line.each { |position| position.update_position(carol) }
        expect(board.x_won?).to eq(true)
      end
    end

    context 'when O wins' do
      it 'returns false for X being the winner' do
        line = board.positions.slice(0..2)
        line.each { |position| position.update_position(celeste) }
        expect(board.x_won?).to eq(false)
      end
    end
  end

  context 'when there is no straight line of one symbol' do
    it 'is not won' do
      positions = board.positions
      x = [0, 1, 5, 6, 8]
      o = [2, 3, 4, 7]
      x.each { |label| positions[label].update_position(carol) }
      o.each { |label| positions[label].update_position(celeste) }
      expect(board.won?).to eq(false)
    end
  end
end

describe Game do
  subject(:game) { described_class.new }
  let(:board) { game.instance_variable_get(:@board) }
  let(:carol) { double(Player, name: 'Carol', symbol: 'X') }

  context 'when game is won' do
    it 'returns true' do
      board.wins[1].each { |position| position.update_position(carol) }
      expect(game.game_over?).to be(true)
    end
  end

  describe '#choose' do
    message = 'Invalid input. Please enter the number of a free square.'

    before do
      allow(game).to receive(:gets).and_return('3')
    end

    it 'ends when valid' do
      expect(game).not_to receive(:puts).with(message)
      game.choose('3')
    end

    it 'continues when invalid' do
      expect(game).to receive(:puts).with(message)
      game.choose('10')
    end
  end

  describe '#valid?' do
    context 'when it is unoccupied' do
      it 'returns true when number is between 0-8' do
        expect(game.valid?('3')).to be(true)
      end

      it 'returns false when choice < 0' do
        expect(game.valid?((rand * -10).to_i.to_s)).to be(false)
      end

      it 'returns false when choice > 8' do
        expect(game.valid?((rand * 10 + 9).to_i.to_s)).to be(false)
      end

      it 'returns false when choice is not an integar' do
        expect(game.valid?('3.5')).to be(false)
      end
    end

    context 'when it is occupied' do
      it 'returns false for values from 0-8' do
        board.positions[3].update_position(carol)
        expect(game.valid?(3)).to be(false)
      end
    end
  end
end
