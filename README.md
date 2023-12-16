This is a demonstration of how to use tile "raytracing" to quickly find if a wall is below, above, or to the left and right of an object.  I needed something fast and general for a prototype game.  It works really well, so I am sharing with the Dragon Ruby community as some inspiration.

There is some platforming code but it would take some tweaking and expanding to feel good.  I wouldn't recommend building a game for this movement out of the box, it's only the first part of a much larger state machine.  The platforming code is not part of the demo, I just needed something moving to test with.

Note how each collision check can only go UP, DOWN, LEFT, or RIGHT.  This means we can quickly convert the pixel into a tile coordinate, and then step through the grid until either the edge is met or we hit a obsticle tile.

This does not return the exact position of a hit in grapical space, but for a lot of retro games you will just want the tile space that was hit.  It should be easy to modify or write up new "raycast checks" if you need something else for your game.

As you can see, this check is very fast, compared to checking each pixel along a line.  So it's possible to use this to generalize across a large tilemap or for lots of enemies/objects at once.

Have fun!

If you make something cool with it, hit me up at darkgrif@gmail.com  I'd love to see what you made!
