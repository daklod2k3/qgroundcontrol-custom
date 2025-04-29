import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Palette
import QGroundControl.Controls
import QGroundControl.FlightMap

/// Object Item visuals
Item {
    id: _root

    property var map        ///< Map control to place item in
    property var vehicle    ///< Vehicle associated with this item
    property bool interactive: true

    property var    _objectItem:       object
    property var    _itemVisual
    property bool   _itemVisualShowing: false

    signal clicked(int sequenceNumber)

    function hideItemVisuals() {
        if (_itemVisualShowing) {
            _itemVisual.destroy()
            _loiterVisual.destroy()
            _itemVisualShowing = false
        }
    }

    function showItemVisuals() {
        if (!_itemVisualShowing) {
            _itemVisual = indicatorComponent.createObject(map)
            map.addMapItem(_itemVisual)
            _loiterVisual = loiterComponent.createObject(map)
            map.addMapItem(_loiterVisual)
            _itemVisualShowing = true
        }
    }

    function hideDragArea() {
        if (_dragAreaShowing) {
            _dragArea.destroy()
            _dragAreaShowing = false
        }
    }

    function showDragArea() {
        if (!_dragAreaShowing) {
            _dragArea = dragAreaComponent.createObject(map)
            _dragAreaShowing = true
        }
    }

    function updateDragArea() {
        if (_objectItem.isCurrentItem && map.planView && _objectItem.specifiesCoordinate) {
            showDragArea()
        } else {
            hideDragArea()
        }
    }

    Component.onCompleted: {
        showItemVisuals()
        updateDragArea()
    }

    Component.onDestruction: {
        hideDragArea()
        hideItemVisuals()
    }


    Connections {
        target: _objectItem

        function onIsCurrentItemChanged() {         updateDragArea() }
        function onSpecifiesCoordinateChanged() {   updateDragArea() }
    }

    Connections {
        target: _objectItem.isSimpleItem ? _objectItem : null

        onLoiterRadiusChanged: {
            _loiterVisual.handleLoiterRadiusChange()
        }

        onCoordinateChanged: {
            _loiterVisual.handleCoordinateChange()
        }
    }

    // Control which is used to drag items
    Component {
        id: dragAreaComponent

        MissionItemIndicatorDrag {
            mapControl:              _root.map
            itemIndicator:           _itemVisual
            itemCoordinate:          _objectItem.coordinate
            visible:                 _root.interactive
            onItemCoordinateChanged: _objectItem.coordinate = itemCoordinate
        }
    }

    Component {
        id: indicatorComponent

        MissionItemIndicator {
            coordinate:     _objectItem.coordinate
            visible:        _objectItem.specifiesCoordinate
            z:              QGroundControl.zOrderMapItems
            missionItem:    _objectItem
            sequenceNumber: _objectItem.sequenceNumber
            onClicked:      if(_root.interactive)  _root.clicked(_objectItem.sequenceNumber)
            opacity:        _root.opacity
        }
    }

    Component  {
        id: loiterComponent

        MapQuickItem {
            id:                               loiterMapQuickItem
            coordinate:                       _root._objectItem.coordinate
            visible:                          _root.interactive && _objectItem.isSimpleItem && _objectItem.showLoiterRadius

            property alias blockSignals:      loiterMapCircleVisuals.blockSignals
            property alias radius:            _mapCircle.radius
            property alias clockwiseRotation: _mapCircle.clockwiseRotation

            function handleLoiterRadiusChange() {
                blockSignals = true
                clockwiseRotation = _objectItem.loiterRadius>= 0
                blockSignals = false
                radius.rawValue = Math.abs(_objectItem.loiterRadius)
            }

            function handleCoordinateChange() {
                coordinate = _objectItem.coordinate
            }

            onCoordinateChanged:              _mapCircle.center = coordinate

            sourceItem: QGCMapCircleVisuals {
                id:                      loiterMapCircleVisuals
                mapControl:              _root.map
                mapCircle:               _mapCircle
                centerDragHandleVisible: false
                borderColor:             _objectItem.terrainCollision ? "red" : QGroundControl.globalPalette.mapMissionTrajectory

                property bool blockSignals: false

                function updateMissionItem() {
                    _objectItem.loiterRadius = _mapCircle.clockwiseRotation ? _mapCircle.radius.rawValue : -_mapCircle.radius.rawValue
                }

                QGCMapCircle {
                    id:                         _mapCircle
                    center:                     loiterMapQuickItem.coordinate
                    interactive:                _root.interactive && _objectItem.isCurrentItem && map.planView
                    showRotation:               true
                    onClockwiseRotationChanged: if(!blockSignals) loiterMapCircleVisuals.updateMissionItem()
                }

                Connections {
                    target:            _mapCircle.radius
                    function onRawValueChanged() {
                        if(!blockSignals) loiterMapCircleVisuals.updateMissionItem()
                    }
                }
            }

            Component.onCompleted: {
                handleLoiterRadiusChange()
                handleCoordinateChange()
            }
        }
    }
}
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
import QtLocation
import QtPositioning

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Palette
import QGroundControl.Controls
import QGroundControl.FlightMap

/// Simple Mission Item visuals
Item {
    id: _root

    property var map        ///< Map control to place item in
    property var vehicle    ///< Vehicle associated with this item
    property bool interactive: true

    property var    _objectItem:       object
    property var    _itemVisual
    property var    _loiterVisual
    property var    _dragArea
    property bool   _itemVisualShowing: false
    property bool   _dragAreaShowing:   false

    signal clicked(int sequenceNumber)

    function hideItemVisuals() {
        if (_itemVisualShowing) {
            _itemVisual.destroy()
            _loiterVisual.destroy()
            _itemVisualShowing = false
        }
    }

    function showItemVisuals() {
        if (!_itemVisualShowing) {
            _itemVisual = indicatorComponent.createObject(map)
            map.addMapItem(_itemVisual)
            _loiterVisual = loiterComponent.createObject(map)
            map.addMapItem(_loiterVisual)
            _itemVisualShowing = true
        }
    }

    function hideDragArea() {
        if (_dragAreaShowing) {
            _dragArea.destroy()
            _dragAreaShowing = false
        }
    }

    function showDragArea() {
        if (!_dragAreaShowing) {
            _dragArea = dragAreaComponent.createObject(map)
            _dragAreaShowing = true
        }
    }

    function updateDragArea() {
        if (_objectItem.isCurrentItem && map.planView && _objectItem.specifiesCoordinate) {
            showDragArea()
        } else {
            hideDragArea()
        }
    }

    Component.onCompleted: {
        showItemVisuals()
        updateDragArea()
    }

    Component.onDestruction: {
        hideDragArea()
        hideItemVisuals()
    }


    Connections {
        target: _objectItem

        function onIsCurrentItemChanged() {         updateDragArea() }
        function onSpecifiesCoordinateChanged() {   updateDragArea() }
    }

    Connections {
        target: _objectItem.isSimpleItem ? _objectItem : null

        onLoiterRadiusChanged: {
            _loiterVisual.handleLoiterRadiusChange()
        }

        onCoordinateChanged: {
            _loiterVisual.handleCoordinateChange()
        }
    }

    // Control which is used to drag items
    Component {
        id: dragAreaComponent

        MissionItemIndicatorDrag {
            mapControl:              _root.map
            itemIndicator:           _itemVisual
            itemCoordinate:          _objectItem.coordinate
            visible:                 _root.interactive
            onItemCoordinateChanged: _objectItem.coordinate = itemCoordinate
        }
    }

    Component {
        id: indicatorComponent

        MissionItemIndicator {
            coordinate:     _objectItem.coordinate
            visible:        _objectItem.specifiesCoordinate
            z:              QGroundControl.zOrderMapItems
            missionItem:    _objectItem
            sequenceNumber: _objectItem.sequenceNumber
            onClicked:      if(_root.interactive)  _root.clicked(_objectItem.sequenceNumber)
            opacity:        _root.opacity
        }
    }

    Component  {
        id: loiterComponent

        MapQuickItem {
            id:                               loiterMapQuickItem
            coordinate:                       _root._objectItem.coordinate
            visible:                          _root.interactive && _objectItem.isSimpleItem && _objectItem.showLoiterRadius

            property alias blockSignals:      loiterMapCircleVisuals.blockSignals
            property alias radius:            _mapCircle.radius
            property alias clockwiseRotation: _mapCircle.clockwiseRotation

            function handleLoiterRadiusChange() {
                blockSignals = true
                clockwiseRotation = _objectItem.loiterRadius>= 0
                blockSignals = false
                radius.rawValue = Math.abs(_objectItem.loiterRadius)
            }

            function handleCoordinateChange() {
                coordinate = _objectItem.coordinate
            }

            onCoordinateChanged:              _mapCircle.center = coordinate

            sourceItem: QGCMapCircleVisuals {
                id:                      loiterMapCircleVisuals
                mapControl:              _root.map
                mapCircle:               _mapCircle
                centerDragHandleVisible: false
                borderColor:             _objectItem.terrainCollision ? "red" : QGroundControl.globalPalette.mapMissionTrajectory

                property bool blockSignals: false

                function updateMissionItem() {
                    _objectItem.loiterRadius = _mapCircle.clockwiseRotation ? _mapCircle.radius.rawValue : -_mapCircle.radius.rawValue
                }

                QGCMapCircle {
                    id:                         _mapCircle
                    center:                     loiterMapQuickItem.coordinate
                    interactive:                _root.interactive && _objectItem.isCurrentItem && map.planView
                    showRotation:               true
                    onClockwiseRotationChanged: if(!blockSignals) loiterMapCircleVisuals.updateMissionItem()
                }

                Connections {
                    target:            _mapCircle.radius
                    function onRawValueChanged() {
                        if(!blockSignals) loiterMapCircleVisuals.updateMissionItem()
                    }
                }
            }

            Component.onCompleted: {
                handleLoiterRadiusChange()
                handleCoordinateChange()
            }
        }
    }
}
