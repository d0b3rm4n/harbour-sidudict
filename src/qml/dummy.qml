/***************************************************************************

    dummy.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011 Reto Zingg <g.d0b3rm4n@gmail.com>

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

import QtQuick 1.0

Rectangle {
    width: 400
    height: 800
    color: "white"

    Item {
        id: mainItem
        anchors.fill: parent

        Flickable {
            id: container
            anchors.fill: parent
            contentWidth: col.width
            contentHeight: col.height
            flickableDirection: Flickable.VerticalFlick
            pressDelay: 100


            Column {
                id: col
                spacing: 10
                width: container.width

                Text {
                    id: searchLable
                    text: "Search for:"
                }

                TextInput {
                    id: inputField
                    anchors {left: parent.left; right: parent.right;}
                    maximumLength: 80

                    Keys.onReturnPressed: {
                        translation.text = starDictLib.getTranslation(inputField.text);
                        translation.visible = true;
                        myList.visible = false;
                        parent.focus = true;
                    }
                    Keys.onReleased: {
                        if(event.key >= Qt.Key_A
                           && event.key <= Qt.Key_Z
                           || event.key == Qt.Key_Backspace){
                            translation.text = starDictLib.updateList(inputField.text);
                            translation.visible = false;
                            myList.visible = true;
                        }
                    }
                }

                EntryList{
                    id: myList
                    width: col.width
                }

                Text {
                    id: translation
                    text: "Nothing found yet..."
                    width: col.width
                    wrapMode: Text.WordWrap
                    visible: false
                    font.pointSize: 12
                }
            }
        }
    }
}
