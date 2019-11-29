# Gravity gun documentation

Gravity gun script is a resource for MTA San Andreas. It allows you to lift and push other players, peds and vehicles.

This file comes with two resources: gravity_gun and ggun_toggle

* `gravity_gun` is the main resource which controls the way the gravity gun works. It provides you with scripting functions for enabling and disabling the gravity gun mode for players.
* `ggun_toggle` is a script which lets you simply toggle the gravity gun mode for players. You need it if you're not going to make your own script for enabling and disabling gravity gun mode.

## How to use the gravity gun in a simple way:
1. Install gravity_gun and ggun_toggle (put them into server/mods/deathmatch/resources)
2. Start them in your server (the easiest way is to type 'start ggun_toggle' into server console)
3. Join the server
4. Get any weapon which you can use to aim
5. Write '/ggun'
6. Aim at player/ped/vehicle and press fire button to lift/release them
7. Press fire button while aiming and holding key 1 to push the element away from yourself.

##Gravity gun functions
Below there's a list of functions exported by gravity_gun. When it is running, other resources can call them in this way:
```
exports.gravity_gun:functionName(arguments)
```

```
togglePlayerGravityGun(player, on)
(server-only function)
Toggles gravity gun mode for player.
player: the player element you want to change the gravity gun mode for.
on: a boolean value. Enables gravity gun when the value is true and disables it when it's false.
Return value: returns true if gravity gun mode was changed successfully and false otherwise.
```

```
isGravityGunEnabled(player)
(server-only function)
Returns specified player's gravity gun mode.
player: the player element you want to check the gravity gun mode for.
Return value: returns true if gravity gun is enabled for player, false otherwise.
```

*Original page for this resource available via web archive: https://web.archive.org/web/20161127171221/http://crystalmv.net84.net:80/pages/scripts/ggun.php*
