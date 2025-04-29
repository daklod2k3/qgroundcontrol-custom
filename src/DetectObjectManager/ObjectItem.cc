#include "ObjectItem.h"
#include <QtCore/qobject.h>
#include <QtPositioning/qgeocoordinate.h>

ObjectItem::ObjectItem(QObject* parent)
    : QObject(parent)
    , _name("")
    , _lat(0)
    , _lng(0)
    , _alt(0)
    , _sequenceNumber(0)
    , _isCurrentItem(false)
{
}

ObjectItem::ObjectItem(QString name, double lat, double lng, double alt, QObject *parent)
    : QObject(parent)
    , _name(name)
    , _lat(lat)
    , _lng(lng)
    , _alt(alt)
    , _sequenceNumber(0)
    , _isCurrentItem(false)
{
}

ObjectItem::~ObjectItem()
{
}

QGeoCoordinate ObjectItem::coordinate(void) const
{
    return QGeoCoordinate(_lat, _lng);
}

void ObjectItem::setName(const QString &name)
{
    if (_name != name) {
        _name = name;
        emit nameChanged(_name);
    }
}

void ObjectItem::setLat(double lat)
{
    if (_lat != lat) {
        _lat = lat;
        emit latChanged(_lat);
        emit coordinateChanged(coordinate());
    }
}

void ObjectItem::setLng(double lng)
{
    if (_lng != lng) {
        _lng = lng;
        emit lngChanged(_lng);
        emit coordinateChanged(coordinate());
    }
}

void ObjectItem::setAlt(double alt)
{
    if (_alt != alt) {
        _alt = alt;
        emit altChanged(_alt);
        emit coordinateChanged(coordinate());
    }
}

void ObjectItem::setCoordinate(const QGeoCoordinate &coordinate)
{
    bool emitCoordinateChanged = false;
    
    if (_lat != coordinate.latitude()) {
        _lat = coordinate.latitude();
        emit latChanged(_lat);
        emitCoordinateChanged = true;
    }
    
    if (_lng != coordinate.longitude()) {
        _lng = coordinate.longitude();
        emit lngChanged(_lng);
        emitCoordinateChanged = true;
    }
    
    if (_alt != coordinate.altitude()) {
        _alt = coordinate.altitude();
        emit altChanged(_alt);
        emitCoordinateChanged = true;
    }
    
    if (emitCoordinateChanged) {
        emit coordinateChanged(this->coordinate());
    }
}

void ObjectItem::setSequenceNumber(int sequenceNumber)
{
    if (_sequenceNumber != sequenceNumber) {
        _sequenceNumber = sequenceNumber;
        emit sequenceNumberChanged(_sequenceNumber);
    }
}

void ObjectItem::setIsCurrentItem(bool isCurrentItem)
{
    if (_isCurrentItem != isCurrentItem) {
        _isCurrentItem = isCurrentItem;
        emit isCurrentItemChanged(_isCurrentItem);
    }
}