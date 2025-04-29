/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.Palette

Rectangle {
    id: root
    
    property var objectItemListModel
    
    color: qgcPal.window
    border.color: qgcPal.text
    border.width: 1
    radius: ScreenTools.defaultFontPixelHeight / 2
    
    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: ScreenTools.defaultFontPixelHeight / 2
        
        QGCLabel {
            text: qsTr("Object Items")
            font.pointSize: ScreenTools.mediumFontPointSize
            Layout.fillWidth: true
        }
        
        QGCButton {
            text: qsTr("Add Object")
            Layout.fillWidth: true
            onClicked: {
                // Add a new object at the current map center
                var coordinate = QGroundControl.flightMapPosition
                objectItemListModel.appendItem("Object " + (objectItemListModel.count + 1), 
                                              coordinate.latitude, 
                                              coordinate.longitude, 
                                              coordinate.altitude)
            }
        }
        
        ListView {
            id: objectListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: objectItemListModel
            
            delegate: Rectangle {
                width: objectListView.width
                height: ScreenTools.defaultFontPixelHeight * 2.5
                color: model.isCurrentItem ? qgcPal.buttonHighlight : qgcPal.windowShade
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: objectItemListModel.currentIndex = index
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: ScreenTools.defaultFontPixelWidth
                    
                    QGCLabel {
                        text: model.sequenceNumber
                        width: ScreenTools.defaultFontPixelWidth * 3
                    }
                    
                    QGCLabel {
                        text: model.name
                        Layout.fillWidth: true
                    }
                    
                    QGCLabel {
                        text: model.coordinate.latitude.toFixed(6) + ", " + model.coordinate.longitude.toFixed(6)
                        Layout.fillWidth: true
                    }
                    
                    QGCButton {
                        text: qsTr("Delete")
                        onClicked: objectItemListModel.removeItem(index)
                    }
                }
            }
        }
    }
}