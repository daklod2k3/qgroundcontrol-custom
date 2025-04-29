/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtLocation

import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.Vehicle


/// Marker for displaying an object item on the map
MapQuickItem {
    id: _item

    property var objectItem
    property int sequenceNumber

    signal clicked

    anchorPoint.x:  sourceItem.width / 2
    anchorPoint.y:  sourceItem.height / 2

    Component.onCompleted: {
        console.log(_item.coordinate)

    }

    sourceItem:
        Image {
            id:             mapItemImage
            source:         "/qmlimages/FireIcon.svg"
            mipmap:         true
            antialiasing:   true
            fillMode:       Image.PreserveAspectFit
            height:         ScreenTools.defaultFontPixelHeight * 5
            sourceSize.height: height
            transform: Rotation {
                origin.x:       mapItemImage.width  / 2
                origin.y:       mapItemImage.height / 2
                angle:          0
            }
        }
}
