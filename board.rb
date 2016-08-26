class Board
  def initialize
    @array = board = 3.times.map do
      3.times.map { Board.STATE[:BLANK] }
    end.freeze
  end

  def self.valid_place?(row, column)
    [row, column].any? { |value| (0..2).include? value }
  end

  def valid_state?(state)
    Board.STATE.values.include? state
  end

  def full?
    @array.all? { |row| row.all? { |state| state != Board.STATE[:BLANK] } }
  end

  def [](row, column)
    unless Board.valid_place?(row, column)
      raise IndexError, Board.range_err_msg
    end

    @array[row][column]
  end

  def []=(row, column, state)
    unless Board.valid_place?(row, column)
      raise ArgumentError, Board.range_err_msg
    end
    raise ArgumentError, Board.state_err_msg unless valid_state? state

    @array[row][column] = state
  end

  @STATE = {
    BLANK: ' ',
    CIRCLE: '○',
    CROSS: '×',
  }.freeze

  @range_err_msg = "row and column should be from 0 to 2.".freeze
  @state_err_msg = "the state should be one of Blank, Circle, Cross".freeze

  class << self
    def STATE
      @STATE
    end

    private

    def range_err_msg
      @range_err_msg
    end

    def state_err_msg
      @range_err_msg
    end
  end

  def initialize_copy(obj)
    @array = 3.times.map do |row|
      3.times.map { |column| obj[row, column] }
    end.freeze
  end
end
