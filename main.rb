require_relative './lib/game.rb'
require_relative './lib/cli_view.rb'

game = Game.new
cli_view = CLIView.new(game)

cli_view.msg_start
game.run_on { cli_view.get_valid_place_loop }
cli_view.show_result()
