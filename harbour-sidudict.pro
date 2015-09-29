TEMPLATE = subdirs
SUBDIRS = src

ICONPATH = /usr/share/icons/hicolor

86.png.path = $${ICONPATH}/86x86/apps/
86.png.files += data/86x86/harbour-sidudict.png

sidudict.desktop.path = /usr/share/applications/
sidudict.desktop.files = data/harbour-sidudict.desktop

INSTALLS += 86.png \
            sidudict.desktop

OTHER_FILES += rpm/harbour-sidudict.spec
