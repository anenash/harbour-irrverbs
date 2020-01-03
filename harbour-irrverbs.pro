# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-irrverbs

CONFIG += sailfishapp

SOURCES += src/harbour-irrverbs.cpp \
    src/data.cpp

DISTFILES += qml/harbour-irrverbs.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/TestPage.qml \
    qml/pages/Verbs.json \
    rpm/harbour-irrverbs.changes.in \
    rpm/harbour-irrverbs.changes.run.in \
    rpm/harbour-irrverbs.spec \
    rpm/harbour-irrverbs.yaml \
    translations/*.ts \
    harbour-irrverbs.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-irrverbs-ru.ts

HEADERS += \
    src/data.h

RESOURCES += \
    resource.qrc
