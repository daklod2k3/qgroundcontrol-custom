#pragma once

#include <QtCore/qobject.h>
#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QTextStream>
#include <QtCore/QJsonObject>
#include <QtPositioning/QGeoCoordinate>

class ObjectItem: public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString name     READ name     WRITE setName     NOTIFY nameChanged)
    Q_PROPERTY(double  lat      READ lat      WRITE setLat      NOTIFY latChanged)
    Q_PROPERTY(double  lng      READ lng      WRITE setLng      NOTIFY lngChanged)
    Q_PROPERTY(double  alt      READ alt      WRITE setAlt      NOTIFY altChanged)
    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(int sequenceNumber READ sequenceNumber WRITE setSequenceNumber NOTIFY sequenceNumberChanged)
    Q_PROPERTY(bool isCurrentItem READ isCurrentItem WRITE setIsCurrentItem NOTIFY isCurrentItemChanged)

public:
    ObjectItem(QObject* parent = nullptr);
    
    ObjectItem(QString name, double lat, double lng, double alt, QObject *parent = nullptr);

    ~ObjectItem();

    // Getters
    QString name(void) const { return _name; }
    double lat(void) const { return _lat; }
    double lng(void) const { return _lng; }
    double alt(void) const { return _alt; }
    QGeoCoordinate coordinate(void) const;
    int sequenceNumber(void) const { return _sequenceNumber; }
    bool isCurrentItem(void) const { return _isCurrentItem; }
    
    // Setters
    void setName(const QString &name);
    void setLat(double lat);
    void setLng(double lng);
    void setAlt(double alt);
    void setCoordinate(const QGeoCoordinate &coordinate);
    void setSequenceNumber(int sequenceNumber);
    void setIsCurrentItem(bool isCurrentItem);
    
    // For map display
    static const QString abbreviation() { return "OBJ"; }

signals:
    void nameChanged(QString name);
    void latChanged(double lat);
    void lngChanged(double lng);
    void altChanged(double alt);
    void coordinateChanged(QGeoCoordinate coordinate);
    void sequenceNumberChanged(int sequenceNumber);
    void isCurrentItemChanged(bool isCurrentItem);

private:
    QString _name;
    double _lat;
    double _lng;
    double _alt;
    int _sequenceNumber;
    bool _isCurrentItem;
    
}; // Add semicolon here