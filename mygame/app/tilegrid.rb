# a level screen for the game, as a grid of tile data that can be rendered to screen and stores passability lookup information for collision checking.


# a tilegrid object that stores the state of the tile grid, including its size, tile size, and tile data.
class TileGrid
    attr_accessor :tile_width, :tile_height, :grid_width, :grid_height, :tile_grid
    def initialize
        @tile_width = 32
        @tile_height = 32
        @grid_width =  40
        @grid_height = 23
        @tile_grid = {}
        for i in 0..@grid_width
            @tile_grid[i] = {}
            for j in 0..@grid_height
                @tile_grid[i][j] = {x:(i * @tile_width), y:(j * @tile_height), collision: :empty, path: 'sprites/empty.png'}
            end
        end
    end

    def render args
        @tile_grid.each do |x, y|
            y.each do |x, y|
                next if y[:path] == 'sprites/empty.png' #don't render empty tiles
                args.outputs.sprites << [y[:x], y[:y], @tile_width, @tile_height, y[:path]]
            end
        end
    end

    def tick args
        #can do tile updates if needed here
    end

    def collides? x, y
        #if out of index, return false
        if x < 0 || x > @grid_width || y < 0 || y > @grid_height
            return false
        end
        #check if the tile at x, y is solid
        if @tile_grid[x][y][:collision] == :solid
            return true
        else
            return false
        end
    end

    def collides_pixel? screenx, screeny
        #check if the pixel at screenx, screeny is solid
        x = (screenx / @tile_width).floor
        y = (screeny / @tile_height).floor
        #if out of range, return false
        if x < 0 || x > @grid_width || y < 0 || y > @grid_height
            return false
        end
        if @tile_grid[x][y][:collision] == :solid
            return true
        else
            return false
        end
    end

    #raytrace from an x, y position in a direction, and return the first solid tile hit
    def raytrace x, y, direction
        #direction is :up, :down, :left, :right
        #x and y are the starting position
        #returns the x, y of the first solid tile hit, or nil if no solid tile hit

        #convert x y from pixel to tile corrdinates
        x = (x / @tile_width).floor
        y = (y / @tile_height).floor

        #putz("raytrace called with x:#{x}, y:#{y}, direction:#{direction}")
        #debug, draw a line along our raytrace check
        if direction == :left
            $gtk.args.outputs.lines << [x, y, x-100, y, 255, 0, 0]
        end

        #if out of index, return nil
        if x < 0 || x > @grid_width || y < 0 || y > @grid_height
            return nil
        end
        #set the starting tile
        tilex = x
        tiley = y
        #set the raytrace direction
        if direction == :up
            tiley += 1
        elsif direction == :down
            tiley -= 1
        elsif direction == :left
            tilex -= 1
        elsif direction == :right
            tilex += 1
        end
        #trace the ray
        while tilex >= 0 && tilex <= @grid_width && tiley >= 0 && tiley <= @grid_height
            #debug, draw the tile being checked as a yellow outline
            $gtk.args.outputs.solids << [tilex * @tile_width, tiley * @tile_height, @tile_width, @tile_height, 255, 255, 0]
            #putz("checking tile #{tilex}, #{tiley}")

            if @tile_grid[tilex][tiley][:collision] == :solid
                return @tile_grid[tilex][tiley]
            end
            if direction == :up
                tiley += 1
            elsif direction == :down
                tiley -= 1
            elsif direction == :left
                tilex -= 1
            elsif direction == :right
                tilex += 1
            end
        end
        #if we got here, we didn't hit a solid tile
        return nil
    end


end

