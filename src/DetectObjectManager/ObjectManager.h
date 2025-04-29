#pragma once

#include <QtCore/qobject.h>
#include <QtCore/qproperty.h>
#include <QtCore/qtmetamacros.h>
#include "QmlObjectListModel.h"
#include "Vehicle.h"

class ObjectManager: public QObject  {
    Q_OBJECT
    Q_PROPERTY(QmlObjectListModel*  visualItems                     READ visualItems                    NOTIFY visualItemsChanged)

public:
    ObjectManager(Vehicle* vehicle);

    ~ObjectManager();
    
    static void registerQmlTypes();
    
    
    QmlObjectListModel* visualItems() { return _visualItems;}
    
public slots:    
    void handleNewObject(QString& message);

signals: 
    void visualItemsChanged(void);
    
private:
    Vehicle* _vehicle;
    QmlObjectListModel* _visualItems;
};