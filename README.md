This is a demonstration of how to use tile "raytracing" to quickly find if a wall is below, above, or to the left and right of an object.  I needed something fast and general for a prototype game.  It works really well, so I am sharing with the Dragon Ruby community as some inspiration.

![Cheap Screenshot showing a square, yellow bars along the tiles representing a trace, and red cubes showing the tiles that are being contacted by the checks](screenshots/Screenshot.png?raw=true "A Cheap Screenshot")

The magic happens in mygame/app/Tilemap.rb  In particular, have a look at the raytrace function there at line 65.  This gets used in the player.rb tick functions to check as movement updates.  Notice how instead of checking a whole box, the player script is free to use starting pixel points relative to the player position, and just ask the Tilemap if something or nil was hit from that location + direction.

There is some platforming code here, but it would take some tweaking and expanding to feel good.  I wouldn't recommend building a game for this movement out of the box, it's only the first part of a much larger state machine.  The platforming code is not part of the demo, I just needed something moving to show how you don't need to check every frame if not moving that way.

Note how each collision check can only go UP, DOWN, LEFT, or RIGHT.  This means we can quickly convert the pixel into a tile coordinate, and then step through the grid until either the edge is met or we hit a obsticle tile.

This does not return the exact position of a hit in grapical space, but for a lot of retro games you will just want the tile space that was hit.  It should be easy to modify or write up new "raycast checks" if you need something else for your game.

As you can see, this check is very fast, compared to checking each pixel along a line.  So it's possible to use this to generalize across a large tilemap or for lots of enemies/objects at once.

Have fun!

If you make something cool with it, hit me up at darkgrif@gmail.com  I'd love to see what you made!

I apologise for the distinct lack of actual Drake in this project.  We are working on the movement before adding graphics, so there is just the grey squares and no actual drake movement code.  The actual platformer will be done in a different project branch to keep this one as simple demo of raycasting over tiles.

LICENSE OF USE

Use for anything you like.  Credit is appreciated but not needed.  If you credit me, use the handle Dark-Griffin or the name Gawain Doell in your credit entry, either one is fine.  Don't forget to let me know you got some use out of it!
