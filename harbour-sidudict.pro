#QMAKEVERSION = $$[QMAKE_VERSION]
#ISQT4 = $$find(QMAKEVERSION, ^[2-9])
#isEmpty( ISQT4 ) {
#error("Use the qmake include with Qt4.4 or greater, on Debian that is qmake-qt4");
#}

TEMPLATE = subdirs
SUBDIRS = src
CONFIG += ordered

ICONPATH = /usr/share/icons/hicolor

86.png.path = $${ICONPATH}/86x86/apps/
86.png.files += data/86x86/harbour-sidudict.png

sidudict.desktop.path = /usr/share/applications/
sidudict.desktop.files = data/harbour-sidudict.desktop

dictionaries.path = /usr/share/harbour-sidudict/dic
dictionaries.files = data/dictionaries/stardict-wikt-dan-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-deu-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-dan-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-deu-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-fin-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-fra-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-ita-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-nld-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-nob-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-pol-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-por-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-rus-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-spa-2.4.2/* \
                     data/dictionaries/stardict-wikt-eng-swe-2.4.2/* \
                     data/dictionaries/stardict-wikt-fin-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-fra-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-ita-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-nld-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-nob-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-pol-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-por-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-rus-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-spa-eng-2.4.2/* \
                     data/dictionaries/stardict-wikt-swe-eng-2.4.2


INSTALLS += 86.png \
            sidudict.desktop \
            dictionaries

OTHER_FILES += rpm/harbour-sidudict.yaml \
               rpm/harbour-sidudict.spec
