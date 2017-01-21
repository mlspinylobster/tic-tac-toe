require_relative './board.rb'
require_relative './game.rb'

class CLIView
  def initialize(game)
    @game = game
  end

  def msg_start()
    puts "マルバツゲームを始めます"
    puts
  end

  def get_valid_place_loop()
    place = nil
    loop do
      CLIView.show_msg_before_get_place(@game.now_board)
      (place = get_valid_place).nil? ? CLIView.msg_invalid_place : break
    end
    place
  end

  def show_result()
    CLIView.raise_yet_finish unless @game.finish?

    puts
    puts "#{'-' * 10}試合終了#{'-' * 10}"
    puts CLIView.board_to_s(@game.now_board)
    puts CLIView.result_to_s(@game.result)
  end

  def self.board_to_s(board)
    @template.gsub(/\d/) do |place_str|
      row, column = place_str_to_place(place_str)
      state = board[row, column]
      state == Board.STATE[:BLANK] ? place_str : state
    end
  end

  def self.place_str_to_place(place_str)
    raise_range_error unless valid_place_str? place_str
    place = place_str.to_i - 1
    row = (place / 3).to_i
    column = (place % 3).to_i
    [row, column]
  end

  private

  def get_valid_place()
    place_str = gets.chomp
    return nil unless CLIView.valid_place_str? place_str
    row, column = CLIView.place_str_to_place(place_str)
    @game.can_place?(row, column) ? [row, column] : nil
  end

  def self.valid_place_str?(place_str)
    place_str =~ /^[1-9]$/
  end

  def self.show_msg_before_get_place(board)
    puts board_to_s(board)
    msg_please_input
  end

  def self.result_to_s(result)
    case result
    when Game.RESULT[:FIRST]
      "先手の勝ちです"
    when Game.RESULT[:SECOND]
      "後手の勝ちです"
    when Game.RESULT[:DRAW]
      "引き分けです"
    end
  end

  def self.msg_invalid_place()
    puts "正しくない場所を入力しました"
  end

  def self.msg_please_input()
    print "場所を入力してください >"
  end

  def self.raise_range_error()
    raise RangeError, "場所は 1~9 までの数字で入力してください"
  end

  def self.raise_yet_finish()
    raise "ゲームがまだ終わっていません"
  end

  @template = <<~TMP
     1 │ 2 │ 3
    ───┼───┼───
     4 │ 5 │ 6
    ───┼───┼───
     7 │ 8 │ 9
  TMP
end
