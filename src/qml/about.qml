/***************************************************************************

    about.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2013 Reto Zingg <g.d0b3rm4n@gmail.com>

 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the Free Software           *
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,            *
 *   MA 02110-1301, USA.                                                   *
 *                                                                         *
 ***************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property string _RICHTEXT_STYLESHEET_PREAMBLE: "<html><style>a { text-decoration: underline; color: '"
                                                   + Theme.highlightColor
                                                   + "' } </style><body>";

    property string _RICHTEXT_STYLESHEET_APPENDIX: "</body></html>";

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader { title: "About" }

            PullDownMenu {
                MenuItem {
                    text: "View Sidudict license"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("LicensePage.qml"))
                    }
                }
            }
            Label {
                wrapMode: Text.WordWrap
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                textFormat: Text.RichText
                function getText() {
                    var msg = _RICHTEXT_STYLESHEET_PREAMBLE
                    + "<b>Sidudict,</b> a dictionary program based on QStarDict."
                    + "<br>Copyright © 2011-2014 Reto Zingg "
                    + "&lt;<a href='mailto:g.d0b3rm4n@gmail.com'>g.d0b3rm4n@gmail.com</a>&gt;"
                    + "<br>"
                    + "<br>Sidudict is open source software licensed under the terms of the GNU General Public License."
                    + "<br>"
                    + "<br>You can find the Sidudict source here (pull requests are very welcome!):"
                    + "<br><a href='https://github.com/d0b3rm4n/harbour-sidudict'>"
                    + "https://github.com/d0b3rm4n/harbour-sidudict</a>"
                    + "<br>"
                    + "<br>Please report bugs and issues here:"
                    + "<br><a href='https://github.com/d0b3rm4n/harbour-sidudict/issues'>"
                    + "https://github.com/d0b3rm4n/harbour-sidudict/issues</a>"
                    + "<br>"
                    + "<br>Downloadable dictionaries are based on data from the Wiktionary dumps available from:"
                    + "<br><a href='http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2'>"
                    + "http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2</a>"
                    + "<br>All content in these dictionaries are under the same license as Wiktionary content."
                    + "<br>"
                    + "<br>Source:"
                    + "<br><a href='https://github.com/tkedwards/wiktionarytodict/blob/master/packaging/wiktionarytodict_20130929.tar.gz'>"
                    + "https://github.com/tkedwards/wiktionarytodict/blob/master/packaging/wiktionarytodict_20130929.tar.gz</a>"
                    + "<br>"
                    + "<br> Icon provided by: Copyright © by Alain Molteni &lt;alain_m@bluewin.ch&gt;"
                    + _RICHTEXT_STYLESHEET_APPENDIX

                    return msg
                }
                text: getText()
            }
        }
    }
}
