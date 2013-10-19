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
                function getText() {
                    var msg = "<b>Sidudict,</b> a dictionary program based on QStarDict."
                    + "<br>Copyright © 2011-2013 Reto Zingg &lt;g.d0b3rm4n@gmail.com&gt;"
                    + "<br>"
                    + "<br>Sidudict is open source software licensed under the terms of the GNU General Public License."
                    + "<br>"
                    + "<br>You can find the Sidudict source here:"
                    + "<br>https://gitorious.org/sidudict/sidudict"
                    + "<br>"
                    + "<br>"
                    + "<br>Included dictionaries are based on data from the Wiktionary dumps available from:"
                    + "<br>http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2"
                    + "<br>All content in these dictionaries are under the same license as Wiktionary content."
                    + "<br>"
                    + "<br>Source:"
                    + "<br>https://github.com/tkedwards/wiktionarytodict/blob/master/packaging/wiktionarytodict_20130929.tar.gz"

                    return msg
                }
                text: getText()
            }
        }
    }
}
