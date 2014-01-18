CONFIG += link_pkgconfig
PKGCONFIG += glib-2.0
LIBS += -lz -lquazip -L../quazip/quazip

QT += dbus

DEPENDPATH += . ../quazip/quazip
INCLUDEPATH += . ../quazip/quazip
QMAKE_LFLAGS += -Wl,-rpath,\\$${LITERAL_DOLLAR}$${LITERAL_DOLLAR}ORIGIN/../share/harbour-sidudict/lib

INSTALLS += target
target.path = /usr/bin/

unix:DEFINES += HAVE_MMAP

CONFIG += sailfishapp

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}

TARGET = harbour-sidudict
TEMPLATE = app

SOURCES += main.cpp\
        lib/dictziplib.cpp \
        lib/distance.cpp \
        lib/lib.cpp \
        lib/stardict.cpp \
        sidudictlib.cpp \
        dictlistmodel.cpp \
        suggestmodel.cpp \
        entrydictitem.cpp \
        downloadmanager.cpp

HEADERS  += logging.h \
         lib/dictziplib.hpp \
         lib/distance.h \
         lib/file.hpp \
         lib/lib.h \
         lib/mapfile.hpp \
         lib/stardict.h \ 
         sidudictlib.h \
         dictlistmodel.h \
         suggestmodel.h \
         entrydictitem.h \
         downloadmanager.h

OTHER_FILES += qml/*.qml qml/*.js
