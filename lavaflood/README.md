# Lava flood documentation

## Using lavafl_ctrl

lavafl_ctrl resource is a script which uses functions of lavaflood to provide a simple interface. You can use it to test the Lava flood resource.

## lavafl_ctrl commands:
```
    /lavaspeed some_speed: make lava rise by speed some_speed. The speed is measured in GTA units per millisecond. For example, '/lavaspeed 0.001' makes the lava rise 1 unit per second.
    /lavalevel some_level: set lava level to be some_level above the sea level.
```

## Exported functions

When Lava flood resource is running, other resources can call its functions in this way:
```
exports.lavaflood:functionName(arguments)
```

The list of all functions exported by Lava flood:
```
setLavaLevel (level)

Server-only function

Changes the lava level.

    level: Lava Z coordinate

Return value: returns true if lava level could be set and false if wrong argument was passed.
```

```
setLavaRiseSpeed (speed)

Server-only function

Changes the lava rising speed.

    speed: Lava rising speed in units per milisecond. Use a negative value to make lava go down

Return value: returns true if rising speed could be set and false if wrong argument was passed.
```

```
getLavaLevel ()

Server-only function

Gets the lava level.

Return value: Z coordinate of lava.
```

```
getLavaRiseSpeed ()

Server-only function

Gets the lava rising speed.

Return value: lava rising speed in units per milisecond.
```

*Original page for this resource available via web archive: https://web.archive.org/web/20161127171226/http://crystalmv.net84.net:80/pages/scripts/lavaflood.php*
