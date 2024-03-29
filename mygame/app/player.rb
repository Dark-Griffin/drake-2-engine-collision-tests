# this is a player object hash used to store the state of the player character during the game.

#define a player object
class Player
    attr_accessor :x, :y, :xmove, :ymove, :state, :direction
    def initialize
        @x = 640
        @y = 540
        @xmove = 0
        @ymove = 0
        @state = :falling
        #possible states: idle, walking, jumping, falling
        @direction = :right
        #settings for the player that don't need accessors
        @w = 32 #width of the player collision box
        @h = 64 #height of the player collision box
        @jumpInitialSpeed = 8 #how fast the player jumps up when pressing jump, this is applied once immediately
        @jumpspeed = 1 #how fast the player jumps up when holding a jump action, this is applied over time as the player holds the jump button
        @jumptime = 0 #how long the player held this current jump, to force stop jump if maxjumptime is reached
        @maxjumptime = 8 #how long the player can hold a jump
        @walkspeed = 4 #how fast the player walks
        @maxfallingspeed = -16 #how fast the player can fall due to gravity
    end

    def render args
        #render the player collision box
        args.outputs.sprites << [@x, @y, @w, @h, 'sprites/square/gray.png']
    end

    def tick args
        
        #handle inputs
        handle_inputs args

        ##########
        # x movement stuff
        #check for x movement collisions
        if @xmove < 0
            #moving left, check if we hit a solid tile
            hit_tile = args.state.tilegrid.raytrace @x+32, @y+32, :left
            #also check the bottom tile of player square
            hit_tile2 = args.state.tilegrid.raytrace @x+32, @y+1, :left
            #if tile 2 is a closer hit, pass that in instead
            if hit_tile2 != nil
                if hit_tile != nil
                    if hit_tile2.x > hit_tile.x
                        hit_tile = hit_tile2
                    end
                else
                    hit_tile = hit_tile2
                end
            end

            #putz "tile hit result is #{hit_tile}"
            if hit_tile != nil && hit_tile.x > @x + @xmove - 32 #moving this distance would hit a solid tile
                putz "hit a solid tile"
                #we hit a solid tile, snap to the tile
                @x = hit_tile.x + 32
                @xmove = 0
            end
        elsif @xmove > 0
            #moving right, check if we hit a solid tile
            hit_tile = args.state.tilegrid.raytrace @x, @y+32, :right
            #also check the bottom tile of player square
            hit_tile2 = args.state.tilegrid.raytrace @x, @y+1, :right
            #if tile 2 is a closer hit, pass that in instead
            if hit_tile2 != nil
                if hit_tile != nil
                    if hit_tile2.x < hit_tile.x
                        hit_tile = hit_tile2
                    end
                else
                    hit_tile = hit_tile2
                end
            end

            if hit_tile != nil && hit_tile.x < @x + @xmove + 32 #moving this distance would hit a solid tile
                putz "hit a solid tile"
                #we hit a solid tile, snap to the nearest solid tile left surface
                @x = hit_tile.x - 32
                @xmove = 0
            end
        end

        #update x position
        @x += @xmove

        ##########
        # y movement stuff
        #handle gravity
        if @ymove > @maxfallingspeed && @state != :jumping #don't apply gravity if we are jumping
            @ymove -= $gravity
            if @ymove < @maxfallingspeed
                @ymove = @maxfallingspeed
            end
        end

        #if jumping, move up
        if @state == :jumping
            @ymove += @jumpspeed
            @jumptime += 1
            if @jumptime > @maxjumptime
                @state = :falling
            end
        end

        #trace the Y movement down, and snap to the nearest solid tile top surface
        if @ymove > 0
            #moving up, check if we hit a solid tile
            hit_tile = args.state.tilegrid.raytrace @x+1, @y+32, :up
            hit_tile2 = args.state.tilegrid.raytrace @x+31, @y+32, :up
            #if tile 2 is a closer hit, pass that in instead
            if hit_tile2 != nil
                if hit_tile != nil
                    if hit_tile2.y < hit_tile.y
                        hit_tile = hit_tile2
                    end
                else
                    hit_tile = hit_tile2
                end
            end

            if hit_tile != nil && hit_tile.y < @y + @ymove + 64 #moving this distance would hit a solid tile
                #we hit a solid tile, snap to the nearest solid tile bottom surface
                @y = hit_tile.y - 64
                @ymove = 0
                @state = :falling
            end
        elsif @ymove < 0
            #moving down, check if we hit a solid tile
            hit_tile = args.state.tilegrid.raytrace @x+1, @y, :down
            hit_tile2 = args.state.tilegrid.raytrace @x+31, @y, :down
            #if tile 2 is a closer hit, pass that in instead
            if hit_tile2 != nil
                if hit_tile != nil
                    if hit_tile2.y > hit_tile.y
                        hit_tile = hit_tile2
                    end
                else
                    hit_tile = hit_tile2
                end
            end

            if hit_tile != nil && hit_tile.y > @y + @ymove - 64 #moving this distance would hit a solid tile
                putz "vertical hit"
                #we hit a solid tile, snap to the nearest solid tile top surface
                @y = hit_tile.y + 32
                @ymove = 0
                @state = :idle
            end
        end

        #update y position
        @y += @ymove

        #if we fell out the bottom of the screen area, respawn at center
        if @y < -64
            @x = 640
            @y = 540
        end

    end

    def handle_inputs args
        
        #if state is idle or walking, allow left and right walking movement
        if @state == :idle || @state == :walking || @state == :falling || @state == :jumping
            if args.inputs.left
                @xmove = -@walkspeed
                @direction = :left
            elsif args.inputs.right
                @xmove = @walkspeed
                @direction = :right
            else
                @xmove = 0
            end
        end

        #if state is not falling, allow jumping
        if @state != :falling && @state != :jumping
            if args.inputs.up
                @ymove = @jumpInitialSpeed
                @state = :jumping
                @jumptime = 0
            end
        end

        #if state is jumping, check if we let go of input
        if @state == :jumping
            if !args.inputs.up
                @state = :falling
            end
        end

    end

end

