# Drake 2 engine, a platformer game starring Drake
# by: Gawain Doell 2023

#some global stuff anything in game can use
$gravity = 4.0; #gravity constant


#include the player script
require 'app/player.rb'
require 'app/tilegrid.rb'

def tick args
  args.outputs.labels  << [640, 540, 'Drake 2 Game collision testing', 5, 1]
  args.outputs.labels  << [640, 500, 'by Gawain Doell', 5, 1]
  args.outputs.labels  << [640, 460, 'left and right to walk, up to jump(can be held), and click to place a tile.', 5, 1]
  args.outputs.labels  << [640, 420, 'yellow tiles have been checked for raytrace solid check.  Red squares indicate found tiles.', 1, 1]
  args.outputs.labels  << [640, 380, 'gray square is the player collider', 1, 1]
  args.outputs.labels  << [640, 340, 'raycasts are called based on state of player movement', 1, 1]

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
    args.state.tilegrid.tile_grid[i][0][:path] = 'sprites/tile/wall-1111.png'
    args.state.tilegrid.tile_grid[i][0][:collision] = :solid
  end

  #test code, just allow click to set a tile to be a wall-1111.png with collision flag of :solid
  if args.inputs.mouse.click
    x = (args.inputs.mouse.x / 32).floor
    y = (args.inputs.mouse.y / 32).floor
    #if tile is passable make a wall, otherwise make it empty again
    if args.state.tilegrid.tile_grid[x][y][:collision] == :empty
      args.state.tilegrid.tile_grid[x][y][:path] = 'sprites/tile/wall-1111.png'
      args.state.tilegrid.tile_grid[x][y][:collision] = :solid
    else
      args.state.tilegrid.tile_grid[x][y][:path] = 'sprites/empty.png'
      args.state.tilegrid.tile_grid[x][y][:collision] = :empty
    end
  end

  # render fps in upper left corner
  args.outputs.labels  << [0, 720, "fps: #{args.gtk.current_framerate.to_i}"]
end

