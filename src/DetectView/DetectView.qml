import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtLocation
import QtPositioning
import QtQuick.Layouts
import QtQuick.Window

import QGroundControl
import QGroundControl.FlightMap
import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.Palette
import QGroundControl.Controllers
import QGroundControl.ShapeFileHelper
import QGroundControl.FlightDisplay
import QGroundControl.UTMSP


Item {
    id: _root

    property var    _planMasterController:              planMasterController
    property var    _missionController:                 _planMasterController.missionController

    readonly property real  _toolsMargin:               ScreenTools.defaultFontPixelWidth * 0.75
    readonly property real  _rightPanelWidth:           Math.min(width / 3, ScreenTools.defaultFontPixelWidth * 30)



    DetectViewToolBar {
        id:                     planToolBar
    }
    
    Item {
        id:             panel
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.top:    planToolBar.bottom
        anchors.bottom: parent.bottom

        

        FlightMap {
            id:                         editorMap
            anchors.fill:               parent
            mapName:                    "MissionEditor"
            allowGCSLocationCenter:     true
            allowVehicleLocationCenter: true
            planView:                   true

            zoomLevel:                  QGroundControl.flightMapZoom
            center:                     QGroundControl.flightMapPosition

            // This is the center rectangle of the map which is not obscured by tools
            property rect centerViewport:   Qt.rect(_leftToolWidth + _margin,  _margin, editorMap.width - _leftToolWidth - _rightToolWidth - (_margin * 2), (terrainStatus.visible ? terrainStatus.y : height - _margin) - _margin)

            property real _leftToolWidth:       toolStrip.x + toolStrip.width
            property real _rightToolWidth:      rightPanel.width + rightPanel.anchors.rightMargin
            property real _nonInteractiveOpacity:  0.5

            // Initial map position duplicates Fly view position
            Component.onCompleted: editorMap.center = QGroundControl.flightMapPosition

            QGCMapPalette { id: mapPal; lightColors: editorMap.isSatelliteMap }

            onZoomLevelChanged: {
                QGroundControl.flightMapZoom = editorMap.zoomLevel
            }
            onCenterChanged: {
                QGroundControl.flightMapPosition = editorMap.center
            }

            onMapClicked: (mouse) => {
                // Take focus to close any previous editing
                editorMap.focus = true
                if (!mainWindow.allowViewSwitch()) {
                    return
                }
                var coordinate = editorMap.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */)
                coordinate.latitude = coordinate.latitude.toFixed(_decimalPlaces)
                coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
                coordinate.altitude = coordinate.altitude.toFixed(_decimalPlaces)
				if(_utmspEnabled){
                	QGroundControl.utmspManager.utmspVehicle.updateLastCoordinates(coordinate.latitude, coordinate.longitude)
                }
                
                // switch (_editingLayer) {
                // case _layerMission:
                //     if (addWaypointRallyPointAction.checked) {
                //         insertSimpleItemAfterCurrent(coordinate)
                //     } else if (_addROIOnClick) {
                //         insertROIAfterCurrent(coordinate)
                //         _addROIOnClick = false
                //     }

                //     break
                // case _layerRallyPoints:
                //     if (_rallyPointController.supported && addWaypointRallyPointAction.checked) {
                //         _rallyPointController.addPoint(coordinate)
                //     }
                //     break

                // case _layerUTMSP:
                //     if (addWaypointRallyPointAction.checked) {
                //     	insertSimpleItemAfterCurrent(coordinate)
                //     } else if (_addROIOnClick) {
                //     	insertROIAfterCurrent(coordinate)
                //         _addROIOnClick = false
                //     }
                //     break
                // }
            }

            // Add the mission item visuals to the map
            // Repeater {
            //     model: _missionController.visualItems
            //     delegate: MissionItemMapVisual {
            //         map:         editorMap
            //         opacity:     _editingLayer == _layerMission || _editingLayer == _layerUTMSP ? 1 : editorMap._nonInteractiveOpacity
            //         interactive: _editingLayer == _layerMission || _editingLayer == _layerUTMSP
            //         vehicle:     _planMasterController.controllerVehicle
            //         onClicked:   (sequenceNumber) => { _missionController.setCurrentPlanViewSeqNum(sequenceNumber, false) }
            //     }
            // }

            Repeater {
                model: _objectManager.visualItems
                delegate: ObjectItemIndicator {
                }
            }


            /// Test item view in map 
            // MapQuickItem {
            //     anchorPoint.x:  sourceItem.width / 2
            //     anchorPoint.y:  sourceItem.height / 2
            //     coordinate:     QtPositioning.coordinate(10.701027,106.721565)

            //     sourceItem: Image {
            //         id:             mapItemImage
            //         source:         "/qmlimages/FireIcon.svg"
            //         mipmap:         true
            //         antialiasing:   true
            //         fillMode:       Image.PreserveAspectFit
            //         height:         ScreenTools.defaultFontPixelHeight * (10)
            //         sourceSize.height: height
            //         transform: Rotation {
            //             origin.x:       mapItemImage.width  / 2
            //             origin.y:       mapItemImage.height / 2
            //             angle:          0
            //         }
            //     }
            // }

          





            // Add the vehicles to the map
            MapItemView {
                model: QGroundControl.multiVehicleManager.vehicles
                delegate: VehicleMapItem {
                    vehicle:        object
                    coordinate:     object.coordinate
                    map:            editorMap
                    size:           ScreenTools.defaultFontPixelHeight * 3
                    z:              QGroundControl.zOrderMapItems - 1
                }
            }
        }

        //-----------------------------------------------------------
        // Right pane for Image view
        Rectangle {
            id:                 rightPanel
            height:             parent.height
            width:              _rightPanelWidth
            color:              qgcPal.window
            opacity:            0.2
            anchors.bottom:     parent.bottom
            anchors.right:      parent.right
            anchors.rightMargin: _toolsMargin
        }

        // Bottom panel
        Rectangle {
            id:         itemContainer
            radius:     ScreenTools.defaultFontPixelWidth * 0.5
            color:      qgcPal.window
            opacity:    0.80
            clip:       true

            anchors.margins:    _toolsMargin
            anchors.leftMargin: 0
            anchors.left:       parent.left
            anchors.right:      rightPanel.left
            anchors.bottom:     parent.bottom

            height:             ScreenTools.defaultFontPixelHeight * 15

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
    }

}
