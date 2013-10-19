/***************************************************************************

    help.qml - Sidudict, a StarDict clone based on QStarDict
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

            PageHeader { title: "Help" }
            Label {
                wrapMode: Text.WordWrap
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                function getText() {
                    var msg = "In the Settings you can enable resp. disable dictionaries."
                    + "<br>"
                    + "<br>Additionally to the pre installed dictionaries, you can add your own"
                    + " stardict dictionaries, copy the <b>.ifo,</b> <b>.dict</b> and <b>.idx</b>"
                    + " files to a subfolder in Documents/Sidudict folder on your phone. You might"
                    + " need to create the Sidudict folder first. Then restart Sidudict and enable the"
                    + " new dictionary in the Settings."
                    + "<br>"
                    + "<br>You can download dictionaries from e.g. here:"
                    + "<br>http://abloz.com/huzheng/stardict-dic/"
                    + "<br><b>NOTICE</b> these dictionaries are packaged in a tar ball, you need to unpack and"
                    + " unzip the tar ball first!"

                    return msg
                }

                text: getText()
            }
        }
    }
}
