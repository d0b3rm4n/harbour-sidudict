QMAKEVERSION = $$[QMAKE_VERSION]
ISQT4 = $$find(QMAKEVERSION, ^[2-9])
isEmpty( ISQT4 ) {
error("Use the qmake include with Qt4.4 or greater, on Debian that is qmake-qt4");
}

TEMPLATE = subdirs
SUBDIRS = src
CONFIG += ordered

ICONPATH = /usr/share/icons/hicolor

48.png.path = $${ICONPATH}/48x48/apps/
48.png.files += data/48x48/apps/sidudict.png

64.png.path = $${ICONPATH}/64x64/apps/
64.png.files += data/64x64/apps/sidudict.png

sidudict.desktop.path = /usr/share/applications/
sidudict.desktop.files = data/sidudict.desktop

INSTALLS += 48.png \
            64.png \
            sidudict.desktop

