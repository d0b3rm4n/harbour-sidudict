TEMPLATE = subdirs
SUBDIRS = src

ICONPATH = /usr/share/icons/hicolor

86.png.path = $${ICONPATH}/86x86/apps/
86.png.files += data/86x86/harbour-sidudict.png

108.png.path = $${ICONPATH}/108x108/apps/
108.png.files += data/108x108/harbour-sidudict.png

128.png.path = $${ICONPATH}/128x128/apps/
128.png.files += data/128x128/harbour-sidudict.png

256.png.path = $${ICONPATH}/256x256/apps/
256.png.files += data/256x256/harbour-sidudict.png

sidudict.desktop.path = /usr/share/applications/
sidudict.desktop.files = data/harbour-sidudict.desktop

INSTALLS += 86.png 108.png 128.png 256.png \
            sidudict.desktop

OTHER_FILES += rpm/harbour-sidudict.spec
