# NPC task sequencer documentation

NPC task sequencer is a resource made for direct usage of NPC high-level control via GUI. You can make sequences of tasks and create peds which perform the tasks. You can save the sequences, so that you could load them the next time you start the server. Four sequences are included in this resource.

## Commands
```
    /positions: toggle the visibility of position markers window
    /tasks: toggle the visibility of sequences window
    /npcs: toggle the visibility of NPCs window
    /showposmarkers: toggle the visibility of position markers
    /showsequence: toggle the visibility of the sequence being edited
    /savents: save the sequences and position markers
    /loadnts: load the sequences and position markers
```

## Position markers

Position markers are points with fixed position which are diplayed as green squares with a black outline. Usually they are needed when you want to make multiple tasks have the same position in their parameters. `/positions` command opens the position markers window. While this window is visible, you can use right mouse button to toggle cursor visibility, switching between camera rotating and marker editing modes. The window has four buttons:
* 'Create' button toggles the marker creation mode.
* 'Move' button toggles the marker moving mode.
* 'Remove' button toggles the marker removal mode.
* 'Close' button closes the window.

## Sequence editing

`/tasks` command opens the task sequences list window. You can use it to add, modify and remove the sequences. While the window is visible, you can toggle mouse cursor visibility with the right mouse button.
* 'Create' button creates a new sequence with the specified name.
* 'Rename' button renames the selected sequence to the name specified.
* 'Edit' button opens the sequence editing window to edit the selected sequence.
* 'Remove' button removes the selected sequence.
* 'Close' button closes the window.

When you click 'Edit' in the task sequences list window, two windows appear: 'Task sequence editor' which has a list of all tasks in the sequence, and 'Task editor' which is used to set tasks and their parameters.

'Task sequence editor' window:
* 'Seq. ID' label shows the ID of the sequence being edited.
* 'Add' button creates a new task above the selected task (or at the end, if no task is selected) in the sequence.
* 'Modify' button copies the task parameters from 'Task editor' window to the selected task in the sequence.
* 'Get' button copies the task parameters from the selected task to the 'Task editor' window.
* 'Move up' button swaps the selected task with the task above it.
* 'Move down' button swaps the selected task with the task below it.
* 'Remove' button removes the task from the sequence.
* 'Close' button closes the 'Task sequence editor' and 'Task editor' windows.

'Task editor' window has parameter fields which you can modify. Some tasks are visible in the world.

* Most fields can be modified directly by writing the values.
* 'Get' buttons allow you to get coordinates and elements by clicking in the world. Clicking a position marker sets the field values to its coordinates.
* 'NS', 'WE' and 'ped' buttons set the traffic light direction field to their own values.

You can find more info about tasks in NPC HLC documentation page.

## NPCs creation

`/npcs` command opens two windows: 'NPCs' and 'NPC parameters'. You can use them to create peds and assign task sequences to them. Right mouse button toggles the visibility of the cursor.

'NPCs' has NPCs list on the left, sequences list on the right and a few buttons:
* 'Close' button closes the windows.
* 'Create' button toggles the ped creation mode. Press the left mouse button in the world where the ped should be created, drag the mouse in the direction where the ped should be rotated and then release the button. The ped will be created with parameters specified in 'NPC parameters' window.
* 'Modify' button sets the parameters of the selected ped to the ones specified in 'NPC parameters' window.
* 'Get' button retrieves the parameters of the selected ped to the 'NPC parameters' window.
* 'Assign' button assigns the selected task sequence to the selected ped.
* 'Start' button starts the task sequence for the selected ped.
* 'Destroy' button destroys the selected ped.

'NPC parameters' window has fields for modifying the behavior of the ped.
* 'Name' is the string which appears in the row of the ped, 'Name' column of the NPCs list.
* 'Skin' is the model ID of the ped.
* 'Vehicle' is the model ID of the vehicle. Empty string for peds on foot.
* 'Walking speed' is the on-foot movement speed.
* 'Weapon accuracy' is the number describing how accurately the ped will shoot. Ranges from 0 (worst accuracy) to 1 (best accuracy)
* 'Driving speed' is the speed limit of the ped in vehicle. Measured in kilometers per hour.
* 'Weapon' is the weapon ID of the ped.
* 'Repeat sequence' is the setting which makes the ped restart the sequence from the beginning after performing all tasks.

*Original page for this resource available via web archive: https://web.archive.org/web/20170123100149/http://crystalmv.net84.net:80/pages/scripts/npc_tseq.php*
