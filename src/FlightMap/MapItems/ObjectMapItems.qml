import QtQuick
import QtLocation
import QtPositioning

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlightMap

Item {
    id: _root

    property var    map                     ///< Map control to show items on
    property var    vehicle                 ///< Vehicle associated with these items

    property var _map: map

    Component.onCompleted: { 
        console.dir(vehicle)
    }

    Repeater {
        model:  vehicle.objectManager.visualItems

        delegate: ObjectItem {
            map: _map
            // vehicle: _vehicle
            
            coordinate: object.coordinate

        }
    }



}
