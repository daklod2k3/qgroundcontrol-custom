
import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning

import QGroundControl.ScreenTools
import QGroundControl.Palette
import QGroundControl.Controls


/// Object item map visual
Item {
    id: _root

    property var map        ///< Map control to place item in
    property var vehicle    ///< Vehicle associated with this item
    property var interactive: true    ///< Vehicle associated with this item

    property var coordinate

    signal clicked(int sequenceNumber)

    property var _visualItem

    Component.onCompleted: {
        var component = Qt.createComponent("ObjectItemIndicator.qml")
        var item = component.createObject(map, { coordinate: coordinate })
        map.addMapItem(item)
        console.log("Add map item")
    }

    Component.onDestruction: {
        if (_visualItem) {
            _visualItem.destroy()
        }
    }
}
