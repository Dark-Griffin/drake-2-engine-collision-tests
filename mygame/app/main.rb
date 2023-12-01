# Drake 2 engine, a platformer game starring Drake
# by: Gawain Doell 2023

#some global stuff anything in game can use
$gravity = 4.0; #gravity constant


#include the player script
require 'app/player.rb'
require 'app/tilegrid.rb'

def tick args
  args.outputs.labels  << [640, 540, 'Drake 2 Game', 5, 1]

  args.state.player ||= Player.new #initialize the player object
  args.state.tilegrid ||= TileGrid.new #initialize the tilegrid object
    
  #render the tilegrid
  args.state.tilegrid.render args
  
  #render the player
  args.state.player.render args

  #update the player
  args.state.player.tick args

  #update the tilegrid
  args.state.tilegrid.tick args

  #test code, make a floor so we don't fall into empty space
  for i in 0..args.state.tilegrid.grid_width
    args.state.tilegrid.tile_grid[i][0][:sprite] = 'sprites/tile/wall-1111.png'
    args.state.tilegrid.tile_grid[i][0][:collision] = :solid
  end

  #test code, just allow click to set a tile to be a wall-1111.png with collision flag of :solid
  if args.inputs.mouse.click
    x = (args.inputs.mouse.x / 32).floor
    y = (args.inputs.mouse.y / 32).floor
    args.state.tilegrid.tile_grid[x][y][:sprite] = 'sprites/tile/wall-1111.png'
    args.state.tilegrid.tile_grid[x][y][:collision] = :solid
  end

end

