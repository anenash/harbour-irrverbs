#include <QtQuick>
#include <sailfishapp.h>

#include "data.h"

// Define the singleton type provider function (callback).
static QObject *information_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    Data *info = new Data();
    return info;
}

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-irrverbs.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    qmlRegisterType<DataModel>();
    qmlRegisterSingletonType<Data>("verbs.Info", 1, 0, "Info", information_provider);
    return SailfishApp::main(argc, argv);
}
