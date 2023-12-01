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
        #possible states: idle, walking, jumping, falling
        @direction = :right
        #settings for the player that don't need accessors
        @jumpInitialSpeed = 10 #how fast the player jumps up when pressing jump, this is applied once immediately
        @jumpspeed = 0.5 #how fast the player jumps up when holding a jump action, this is applied over time as the player holds the jump button
        @jumptime = 0 #how long the player held this current jump, to force stop jump if maxjumptime is reached
        @maxjumptime = 20 #how long the player can hold a jump
        @walkspeed = 6 #how fast the player walks
        @maxfallingspeed = -10 #how fast the player can fall due to gravity
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
        if @ymove > -10 && @state != :jumping #don't apply gravity if we are jumping
            @ymove -= $gravity
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
        if @ymove < 0
            #moving up, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x, @y + @ymove
                #we hit a solid tile, snap to the nearest solid tile bottom surface
                @y = ((@y + @ymove) / 32).floor * 32 + 32
                @ymove = 0
                @state = :idle
            end
        else
            #moving down, check if we hit a solid tile
            if args.state.tilegrid.collides_pixel? @x, @y + @ymove
                #we hit a solid tile, snap to the nearest solid tile top surface
                @y = ((@y + @ymove) / 32).floor * 32
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
        if @state == :idle || @state == :walking
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

