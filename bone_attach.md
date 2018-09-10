# Bone attachments documentation

## Exported functions

When Bone attachments resource is running, other resources can call its functions in this way:
```
exports.bone_attach:functionName(arguments)
```

The following example creates a ped in the center of the map and attaches a burger to the hand:
```
ped = createPed(105,0,0,3)
burger = createObject(2880,0,0,0)
exports.bone_attach:attachElementToBone(burger,ped,12,0,0,0,0,-90,0)
```

The list of all functions exported by Bone attachments:
```
attachElementToBone (element, ped, bone, x, y, z, rx, ry, rz)

Server and client function

Attaches an element to the bone of the ped.

    element: Element which you want to attach
    ped: Ped or player you want to attach the element to
    bone: Bone which you want to attach the element to
    x, y, z: Position offset from the bone
    rx, ry, rz: Rotation offset from the bone

Returns true if element was successfully attached, false otherwise.
```

```
detachElementFromBone (element)

Server and client function

Detaches the element from the bone of the ped.

    element: Element which you want to detach

Returns true if element was successfully detached, false otherwise.
```

```
isElementAttachedToBone (element)

Server and client function

Checks if element is attached to a bone.

    element: Element which you want to check

Returns true if element is attached to a bone, false otherwise.
```

```
getElementBoneAttachmentDetails (element)

Server and client function

Gets ped, bone and offset of attached element.

    element: Element which you want to get attachment details of

Returns ped, bone, x, y, z, rx, ry, rz used in attachElementToBone if element is attached, false otherwise.
```

```
setElementBonePositionOffset (element, x, y, z)

Server and client function

Changes position offset of attached element.

    element: Element which you want to change the offset for
    x, y, z: New position offset

Returns true if position was set successfully, false otherwise.
```

```
setElementBoneRotationOffset (element, rx, ry, rz)

Server and client function

Changes rotation offset of attached element.

    element: Element which you want to change the offset for
    rx, ry, rz: New rotation offset

Returns true if rotation was set successfully, false otherwise.
```

```
getBonePositionAndRotation (ped, bone)

Client-only function

Gets position and rotation of the ped bone.

    ped: Ped whose bone position and rotation you want to get
    bone: Bone whose position and rotation you want to get

Returns x, y, z, rx, ry, rz of the bone if ped is streamed in and bone number is valid, false otherwise.
```

## Bone IDs
1: head
2: neck
3: spine
4: pelvis
5: left clavicle
6: right clavicle
7: left shoulder
8: right shoulder
9: left elbow
10: right elbow
11: left hand
12: right hand
13: left hip
14: right hip
15: left knee
16: right knee
17: left ankle
18: right ankle
19: left foot
20: right foot

*Original page for this resource available via web archive: https://web.archive.org/web/20170114161100/http://crystalmv.net84.net:80/pages/scripts/bone_attach.php*
