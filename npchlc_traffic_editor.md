# NPC HLC traffic editor documentation

NPC HLC traffic editor is a tool used to create paths for NPC HLC traffic editor.

## Path description

Paths are made of path elements: nodes and connections and forbidden turns.

* Node is the coordinate data. It is a white (or red, if highlighted) square with a black outline and a line of direction vector.
* Connection is a link between two nodes which contains traffic type, density, lane count and speed parameters. It is a group of arrows for every lane, or a line if there is a single two-way line. Their color depends on the traffic type and transparency depends on density. A number indicating the speed limit is drawn on the connection. Starting and ending points of the arrows are on the lines of direction vectors of nodes. End points of the connection may have traffic light markers which switch their color between green and orange depending on traffic light state. These markers are lines which go in the direction dependent on which traffic lights they are for. For ped traffic lights they are vertical.
* Forbidden turn is a link between two connections which disallows peds going along the first connection to turn to go along the second. Forbidden turn is displayed as two lines above the node. They go to the directions where the connections of the forbidden turn go. The line of the second connection has a cross on the ending point.

## Commands
```
    /edittraffic: toggle the visibility of traffic editor window
    /trafficname some_name: change the file name of the path map which is being edited
    /trafficclear: remove all path elements from the map
    /trafficsave: save paths into the file specified using /trafficname
    /trafficload: load paths from the file specified using /trafficname
    /rendernodes: toggle visibility of nodes
    /renderconns: toggle visibility of connections
    /renderarea some_size: set the node visibility range to some_size*32 GTA units. Made to prevent large numbers of elements from slowing down the rendering.
```

## Editing paths
### 1. Editor window

`/edittraffic` command opens the traffic editor window. When it is visible, you can use right mouse button to toggle the visibility of the cursor, therefore switching between camera rotation and editing modes. There are three tabs in this window: Nodes, Connections and Forbidden turns.

### 2. Nodes

Nodes tab has buttons related to node creation, removal and modification.
* 'Create' button toggles the node creation mode. Press the left mouse button to set the position of the node, drag the mouse to set its direction vector and then release it. Then the node gets created.
* 'Destroy' button toggles the node removal mode. Click the node to destroy it.
* 'Move' button toggles the node moving mode. Click the node and drag the mouse to move the node.
* 'Rotate' button toggles the node rotating mode. Click the node and drag the mouse to change the direction vector of the node.

### 3. Connections

Connections tab has buttons related to connection creation, removal and modification.
* 'Create' button toggles the connection creation mode. Click a node to select it, then click another one to create a connection which goes from the first node to the second. The new connection will have parameters which are set in the editor window.
* 'Destroy' button toggles the connection removal mode. Click the connection to destroy it.
* 'Bend' button toggles the connection bending mode. Click the connection to select it, then click a node to bend the connection around it.
* 'Unbend' button toggles the connection unbending mode. Click the bent connection to make it straight.
* 'Lights' button toggles the traffic light point creation mode. Click the mouse when connection and one of its nodes are highlighted to make a traffic light.
* 'Set' button toggles the connection parameter modifying mode. Click a connection to set its parameters to the ones in editor window.
* 'Get' button toggles the connection parameter retrieving mode. Click a connection to store its parameters to the fields in editor window.

The tab also has connection parameters:
* 'Type' button determines the type of the traffic which is generated on the connection. Only ped and car paths work in the current version of the traffic script.
* 'Lanes' parameter is made of two values: left and right lane counts. The left lanes are the ones which go from the second node to the first, while the right lanes go from first node to the second. Two additional lanes for bicycles are created at both sides. If both parameters are 0, the connection is a single two-way line.
* 'Speed' parameter is the speed limit in kilometres per hour for vehicles that go through the connection.
* 'Density' parameter is multiplier for amount of the traffic that goes through the connection.

### 4. Forbidden turns

Forbidden turns tab has buttons for forbidden turn creation and removal.
* 'Create' button toggles the forbidden turn creation mode. Click a connection to select it, then click another one to create a forbidden turn which disallows peds to go from the first connection to the second.
* 'Destroy' button toggles the forbidden turn removal mode. Click a node to destroy all its forbidden turns.

*Original page for this resource available via web archive: https://web.archive.org/web/20161128104638/http://crystalmv.net84.net:80/pages/scripts/npchlc_traffic_editor.php*
