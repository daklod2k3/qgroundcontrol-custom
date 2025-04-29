#include "ObjectManager.h"
#include <QtCore/qlogging.h>
#include <QtCore/qobject.h>
#include <QtQml/qqml.h>
#include "ObjectItem.h"
#include "QGCApplication.h"
#include "QmlObjectListModel.h"
#include "Vehicle.h"
#include "VisualMissionItem.h"

ObjectManager::ObjectManager(Vehicle *vehicle)
:QObject(vehicle)
,_visualItems(new QmlObjectListModel(vehicle))
,_vehicle(vehicle){
    // _visualItems->append(new ObjectItem("Object 1", 37.7749, -122.4194, 0, _vehicle));
}

ObjectManager::~ObjectManager(){
    // Clean up resources if needed
}

void ObjectManager::registerQmlTypes(){
    qmlRegisterUncreatableType<ObjectManager>("QGroundControl.Vehicles", 1, 0, "ObjectManager", "ObjectManager should not be created in QML");
}

void ObjectManager::handleNewObject(QString& messageText){
    messageText = messageText.replace("#forward_cmess,", "");
    QStringList data = messageText.split(",");
    // qgcApp()->showAppMessage("Object detected: " + data[0], "Object Detected");
    QString name = data[0];
    double lat = data[2].toDouble() / 10E6;
    double lon = data[3].toDouble() / 10E6;
    // double alt = data[4].toDouble();
    _visualItems->append(new ObjectItem(name, lat, lon, 0, _vehicle));
    
    emit visualItemsChanged();

    messageText = "Object detected: " + data[0];
    
    qDebug() << "Added new object: " << name << " at " << lat << ", " << lon;

    

}