require_relative './board.rb'
require_relative './judge.rb'

class Game
  attr_reader :result
  def initialize
    @board = Board.new
    @result = nil
  end

  def finish?
    @result != nil
  end

  def placed?(row, column)
    now_state = @board[row, column]
    now_state != Board.STATE[:BLANK]
  end

  def can_place?(row, column)
    valid_place = Board.valid_place?(row, column)
    not_placed = !placed?(row, column)

    valid_place && not_placed
  end

  def now_board()
    @board.dup
  end

  # ゲームを最初から最後まで実行する
  def run_on
    move_count = 0
    player = Game.PLAYER[:FIRST]

    until finish?
      row, column = yield(player, move_count)
      raise ArgumentError, Game.placed_err_msg if placed?(row, column)

      @board[row, column] = get_state_from_player(player)
      @result = Judge.check(@board)

      move_count += 1
      player = reverse_player(player)
    end

    [@result, move_count]
  end

  private

  def get_state_from_player(player)
    case player
    when Game.PLAYER[:FIRST] then
      Board.STATE[:CIRCLE]
    when Game.PLAYER[:SECOND] then
      Board.STATE[:CROSS]
    end
  end

  def get_player_from_state(state)
    case state
    when Board.STATE[:CIRCLE] then
      Game.RESULT[:FIRST]
    when Board.STATE[:CROSS] then
      Game.RESULT[:SECOND]
    else
      nil
    end
  end

  def reverse_player(player)
    case player
    when Game.PLAYER[:FIRST] then
        Game.PLAYER[:SECOND]
    when Game.PLAYER[:SECOND] then
        Game.PLAYER[:FIRST]
    end
  end

  @PLAYER = {
    FIRST: 0,
    SECOND: 1,
  }.freeze

  @RESULT = {
    FIRST: @PLAYER[:FIRST],
    SECOND: @PLAYER[:SECOND],
    DRAW: 2,
  }.freeze

  @placed_err_msg = "already placed".freeze

  class << self
    def PLAYER
      @PLAYER
    end

    def RESULT
      @RESULT
    end

    private

    def placed_err_msg
      @placed_err_msg
    end
  end
end
