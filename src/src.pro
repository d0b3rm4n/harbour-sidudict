CONFIG += link_pkgconfig c++11
PKGCONFIG += glib-2.0
LIBS += -lz

QT += dbus

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

# include QuaZIP
!exists(third_party/quazip/quazip/quazip.pri): \
    error("Some git submodules are missing, please run 'git submodule update --init' in toplevel directory")
include(third_party/quazip/quazip/quazip.pri)

SOURCES += main.cpp\
        lib/dictziplib.cpp \
        lib/distance.cpp \
        lib/lib.cpp \
        lib/stardict.cpp \
        sidudictlib.cpp \
        dictlistmodel.cpp \
        suggestmodel.cpp \
        entrydictitem.cpp \
        downloadmanager.cpp \
        worker.cpp

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
         downloadmanager.h \
         worker.h

OTHER_FILES += qml/*.qml qml/*.js
