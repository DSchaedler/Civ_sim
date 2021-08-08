# Require Zif Library
require 'app/lib/zif/require.rb'
# Require project files
require 'app/require.rb'

# Main tick method called by DragonRuby
def tick args
  if args.tick_count == 2
    $game = Civ_Sim::Civ_Game.new
    $game.scene.prepare_scene # Needed because it references $game
  end
  $game&.perform_tick
end
