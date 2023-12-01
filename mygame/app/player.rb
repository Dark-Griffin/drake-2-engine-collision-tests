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
        args.outputs.sprites << [x, y, 64, 64, 'sprites/player.png']
    end

    def tick args
        #move the player
        @x += @xmove
        @y += @ymove
        #handle inputs
        handle_inputs args
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

