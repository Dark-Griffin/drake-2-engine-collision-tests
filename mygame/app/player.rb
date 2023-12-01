# this is a player object hash used to store the state of the player character during the game.

#define a player object
class Player
    attr_accessor :x, :y, :xmove, :ymove, :state, :direction
    def initialize
        @x = 640
        @y = 540
        @xmove = 0
        @ymove = 0
        @state = :idle
        @direction = :right
    end

    def render args
        #render the player collision box
        args.outputs.sprites << [x, y, 64, 64, 'sprites/square/gray.png']
    end

    def tick args
        
        #handle inputs
        handle_inputs args

        ##########
        # x movement stuff
        #check for x movement collisions
        if @xmove < 0
            #moving left, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x + @xmove, @y
                #we hit a solid tile, snap to the nearest solid tile right surface
                @x = ((@x + @xmove) / 32).floor * 32 + 32
                @xmove = 0
            end
        else
            #moving right, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x + @xmove + 64, @y
                #we hit a solid tile, snap to the nearest solid tile left surface
                @x = ((@x + @xmove) / 32).floor * 32
                @xmove = 0
            end
        end

        #update x position
        @x += @xmove

        ##########
        # y movement stuff
        #handle gravity
        if @ymove > -10
            @ymove -= $gravity
        end
        #trace the Y movement down, and snap to the nearest solid tile top surface
        if @ymove < 0
            #moving up, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x, @y + @ymove
                #we hit a solid tile, snap to the nearest solid tile bottom surface
                @y = ((@y + @ymove) / 32).floor * 32 + 32
                @ymove = 0
            end
        else
            #moving down, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x, @y + @ymove
                #we hit a solid tile, snap to the nearest solid tile top surface
                @y = ((@y + @ymove) / 32).floor * 32
                @ymove = 0
            end
        end
        #update y position
        @y += @ymove

    end

    def handle_inputs args
        if args.inputs.left
            @xmove = -6
            @direction = :left
        elsif args.inputs.right
            @xmove = 6
            @direction = :right
        else
            @xmove = 0
        end
    end

end

