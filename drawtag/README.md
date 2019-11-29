# Drawtag documentation

## Using drawtag_bc

`drawtag_bc` is a script which uses functions of `drawtag` to provide simple interface. It has a few commands and it also saves/loads tags when it stops/starts. You can use it to test the Drawtag script.

### drawtag_bc commands:
```
    /draw: toggles the visibility of drawing window
    /drawtag: enables drawing mode
    /erasetag: enables erasing mode
    /tagsize new_tag_size: changes the size of the tag to new_tag_size
    /copytag: copies the texture of a nearby existing tag to the next tag you will draw
    /edittag: copies the texture of a nearby existing tag to the drawing window
```

### Using drawtag in game

* In the drawing window, the big checkered square is the drawing area which you can draw on by pressing the left mouse button.
* To select another color, click one in the palette under the drawing area.
* To modify palette color or brush size, use horizontal bars on the right of the drawing window. Left mouse button changes them accurately, while right mouse button snaps them to a rounded value.
* To clear everything from the drawing square, press 'Clear' button.
 To copy the texture from drawing area to your next tag, press 'Done' button.
* To close the drawing window, press 'Close' button.
* To draw the tag on the surface, spray on it using the spray can while the drawing mode is enabled.
* To erase the tag, spray on it using the spray can while the erasing mode is enabled.

## Exported functions

When Drawtag resource is running, other resources can call its functions in this way:
```
exports.drawtag:functionName(arguments)
```

The list of all functions exported by Drawtag:
```
createTagFromExistingData (attached, x, y, z, x1, y1, z1, x2, y2, z2, nx, ny, nz, size, visibility, pngdata)

Server-only function

Creates a tag from the data passed as arguments.

    attached: the element which you want to attach the tag to (nil if none)
    x, y, z: Center position of the tag. Relative to the element if attached
    x1, y1, z1: The middle point of the top edge of the tag. Relative to the element if attached
    x2, y2, z2: The middle point of the bottom edge of the tag. Relative to the element if attached
    nx, ny, nz: Vector pointing at the direction the tag is facing (surface normal). Relative to the element if attached
    size: size of the tag
    visibility: part of the tag drawn. Ranges from 1 (just created) to 90 (fully drawn)
    pngdata: a string containing tag texture data in PNG format

Return value: tag element.
```

```
getAllTags ()

Server and client function

Gets all tags drawn in the server.

Return value: table containing all tags.
```

```
getTagAttachedElement (tag)

Server and client function

Gets element which the tag is attached to.

    tag: The tag which you want to get the attached element of

Return value: element which the tag is attached to
```

```
getTagPosition (tag)

Server and client function

Gets the position of the tag.

    tag: The tag which you want to get the position of

Return values: coordinates of the tag. Relative to the attached element if it exists.
```

```
getTagNormal (tag)

Server and client function

Gets the direction which the tag is facing.

    tag: The tag which you want to get the normal of

Return values: coordinates of the tag normal vector. Relative to the attached element if it exists.
```

```
getTagSize (tag)

Server and client function

Gets the size of the tag.

    tag: The tag which you want to get the size of

Return value: size of the tag.
```

```
getTagTexture (tag)

Server and client function

Gets the texture of the tag.

    tag: The tag which you want to get the texture of

Return value: string containing the texture in PNG format.
```

```
getTagData (tag)

Server-only function

Gets all data of the tag.

    tag: The tag which you want to get the data of

Return values: element which the tag is attached to, tag center position, middle point of top edge, middle point of bottom edge, tag normal vector, tag size, part of the tag drawn and tag texture data. In short, it returns the same values which you can pass to createTagFromExistingData.
```

```
setPlayerSprayMode (player, mode)

Server-only function

Changes the way the spray can works for the specified player.

    player: The player element you want to change the spraying mode for
    mode: A string describing how spray can works. "draw" makes it draw the tag on the surface which is being sprayed on, "erase" makes it erase the tag and "none" disables all effects

Return value: returns true if spraying mode was changed successfully and false otherwise.
```

```
getPlayerSprayMode (player)

Server and client function

Returns the spraying mode of the specified player.

    player: The player element you want to check the spraying mode of

Return value: returns "none" if spray can does not have any effect, "draw" if drawing is enabled and "erase" if erasing is enabled.
```

```
setPlayerTagSize (player, size)

Server-only function

Changes the size of the next tag the player will spray.

    player: The player element you want to change the tag size for
    size: Size of the tag

Return value: returns true if tag size was changed successfully and false otherwise.
```

```
getPlayerTagSize (player)

Server and client function

Returns the size of next tag the player will spray.

    player: The player element you want to get the tag size of

Return value: tag size.
```

```
setPlayerTagTexture (player, texture)

Server-only function

Changes the texture of the next tag the player will spray.

    player: The player element you want to change the tag texture for
    texture: A string containing the texture data in PNG format

Return value: returns true if tag texture was changed successfully and false otherwise.
```

```
setEditorTexture (texture)

Client-only function

Changes the image in the drawing window.

    texture: A string containing the texture data in PNG format

Return value: returns true if image was changed successfully and false otherwise.
```

```
showDrawingWindow (show)

Client-only function

Shows or hides drawing window for local player.

    show: A boolean value determining if window should be shown (true) or hidden (false)

Return value: returns true if visibility could be set and false if wrong argument was passed.
```

```
isDrawingWindowVisible ()

Client-only function

Checks if drawing window is visible for local player.

Return value: returns true if drawing window is visible, false otherwise.
```

## Events list
```
"drawtag:onTagStartSpray" (player)

Server-side event

Gets triggered when a player starts spraying a new tag.

    source: The tag which was created
    player: Player who started spraying the tag
```

```
"drawtag:onTagFinishSpray" (player)

Server-side event

Gets triggered when a player fully draws the tag.

    source: The tag which was drawn
    player: Player who finished drawing the tag
```

```
"drawtag:onTagStartErase" (player)

Server-side event

Gets triggered when a player starts erasing a fully drawn tag.

    source: The tag which is being erased
    player: Player who started erasing the tag
```

```
"drawtag:onTagFinishErase" (player)

Server-side event

Gets triggered when a player erases the tag and before tag element gets destroyed.

    source: The tag which was erased
    player: Player who erased the tag
```

*Original page for this resource available via web archive: https://web.archive.org/web/20161219194005/http://crystalmv.net84.net:80/pages/scripts/drawtag.php*
