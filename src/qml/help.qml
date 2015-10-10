/***************************************************************************

    help.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2013 - 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

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

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader { title: "Help" }
            Label {
                wrapMode: Text.WordWrap
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                onLinkActivated: {
//                    console.log("clicked: " + link);
                    Qt.openUrlExternally(link);
                }
                function getText() {
                    var msg = "Sidudict does not contain pre installed dictionaries any longer"
                    + " (the package would just grow too much, and not all users want all"
                    + " dictionaries installed)."
                    + "<br>"
                    + "<br>But you can easily download dictionaries for offline use from the"
                    + " Download view. Either you long press on the name to open the context menu"
                    + " or you tap on the name to see first some details about the dictionary."
                    + " There you can use the pull-down menu."
                    + "<br>"
                    + "<br>In the Settings you can enable resp. disable dictionaries."
                    + " If you long press on a dictionary name in Settings, a context menu opens."
                    + " Details provides info about the particular dictionary. The Details view"
                    + " has a pull-down menu to delete that particular dictionary."
                    + "<br>"
                    + "<br>Additionally to the downloadable dictionaries, you can add your own"
                    + " stardict dictionaries, copy the <b>.ifo,</b> <b>.dict/dict.dz</b> and <b>.idx</b>"
                    + " files to a subfolder in Documents/Sidudict folder on your phone. You might"
                    + " need to create the Sidudict folder first. Then restart Sidudict, new found dictionaries"
                    + " are enabled by default."
                    + "<br>"
                    + "<br>You can download dictionaries from e.g. here:"
                    + "<br><a href='http://abloz.com/huzheng/stardict-dic/'>"
                    + "http://abloz.com/huzheng/stardict-dic/</a>"
                    + "<br><b>NOTICE</b> these dictionaries are packaged in a tar ball, you need to unpack and"
                    + " unzip the tar ball first!"
                    + "<br>"
                    + "<br>If you want to create your own dictionaries here some links which migh help you:"
                    + "<br><a href='http://www.stardict.org/HowToCreateDictionary'>"
                    + "http://www.stardict.org/HowToCreateDictionary</a>"
                    + "<br><a href='https://github.com/tkedwards/wiktionarytodict/'>"
                    + "https://github.com/tkedwards/wiktionarytodict/</a>"
                    + "<br><a href='https://github.com/soshial/xdxf_makedict'>"
                    + "https://github.com/soshial/xdxf_makedict</a>"

                    return msg
                }

                text: getText()
            }
        }
    }
}
