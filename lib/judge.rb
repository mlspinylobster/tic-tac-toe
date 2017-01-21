require_relative './board.rb'
require_relative './game.rb'

class Judge
  def self.check(board)
    all_states = get_all_states(board)
    blank_count, circle_count, cross_count = count_by_states(all_states)
    # 正しく進行したゲームなら、○の数は×の数と同じか1つ多い
    return nil unless (cross_count..(cross_count + 1)).include? circle_count

    sames = get_sames(board)
    # 正しく進行したゲームなら○と×が両方揃っていることはない
    return nil if sames.uniq.size > 1

    @result = get_judge(sames.empty? ? nil : sames[0], blank_count.zero?)
  end

  private

  def self.get_judge(same, filled)
    case
    when same.nil? && filled
      Game.RESULT[:DRAW]
    when same == Board.STATE[:CIRCLE]
      Game.RESULT[:FIRST]
    when same == Board.STATE[:CROSS]
      Game.RESULT[:SECOND]
    else
      nil
    end
  end

  def self.get_all_states(board)
    @end2end
      .product(@end2end)
      .map { |(row, column)| board[row, column] }
  end

  def self.count_by_states(all_states)
    [
      all_states.count(Board.STATE[:BLANK]),
      all_states.count(Board.STATE[:CIRCLE]),
      all_states.count(Board.STATE[:CROSS]),
    ]
  end

  def self.get_sames(board)
    [get_straights(board), get_diagonals(board)]
      .flatten(1)
      .map do |states|
        # 端から端までSTATEが同じならそのSTATE、違うならnilを得る
        states.reduce { |a, e| a == e ? a : nil }
      end
      .compact
      .select { |state| state != Board.STATE[:BLANK] }
  end

  def self.get_straights(board)
    @end2end.flat_map do |axis1|
      [
        @end2end.map { |axis2| board[axis1, axis2] },
        @end2end.map { |axis2| board[axis2, axis1] },
      ]
    end
  end

  def self.get_diagonals(board)
    [
      @end2end.map { |inc| board[inc, inc] },
      @end2end.map { |inc| dec = 2 - inc; board[inc, dec] },
    ]
  end

  @end2end = (0..2).to_a.freeze
end