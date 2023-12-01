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
                @tile_grid[i][j] = {x:(i * @tile_width), y:(j * @tile_height), collision: :empty, sprite: 'sprites/empty.png'}
            end
        end
    end

    def render args
        @tile_grid.each do |x, y|
            y.each do |x, y|
                next if y[:sprite] == 'sprites/empty.png' #don't render empty tiles
                args.outputs.sprites << [y[:x], y[:y], @tile_width, @tile_height, y[:sprite]]
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

end

