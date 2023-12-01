# a castlevania style platforming game
# by: Gawain Doell 2023

#include the player script
require 'app/player.rb'

def tick args
  args.outputs.labels  << [640, 540, 'Platformer Castlevania Style Game', 5, 1]

  args.state.player ||= Player.new #initialize the player object
  
  #render the player
  args.state.player.render args

  #update the player
  args.state.player.tick args

end

