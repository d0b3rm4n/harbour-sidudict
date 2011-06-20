/***************************************************************************

    MainWindow.qml - Sidudict, a StarDict clone based on QStarDict
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

import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: mainWindow
    anchors.margins: rootWindow.pageMargin
    Component.onCompleted: {
        inputField.forceActiveFocus();
        inputField.openSoftwareInputPanel();
    }

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

                Label {
                    text: "Search for:"
                }

                TextField {
                    id: inputField
                    anchors {left: parent.left; right: parent.right;}
                    placeholderText: "Search..."
                    maximumLength: 80

                    Keys.onReturnPressed: {
                        var tmpTranslation = starDictLib.getTranslation(inputField.text);
                        if (tmpTranslation.length > 0){
                            translation.text = tmpTranslation
                            parent.focus = true;
                            myList.visible = false;
                            translation.visible = true;
                        }
                        else {
                            suggestButton.clicked();
                        }
                    }

//                    // does not work in meego !?
//                    Keys.onPressed: {
//                        console.log('onPressed');
//                        if(event.key >= Qt.Key_A
//                           && event.key <= Qt.Key_Z
//                           || event.key == Qt.Key_Backspace){
//                            translation.text = starDictLib.updateList(inputField.text);
//                        }
//                    }
                }

                Button {
                    id: deleteButton
                    text: "new search"
                    anchors {left: parent.left; right: parent.right;}

                    onClicked: {
                        inputField.text = "";
                        inputField.forceActiveFocus();
                        inputField.openSoftwareInputPanel();
                    }

                }

                Button {
                    id: suggestButton
                    text: "suggestions"
                    anchors {left: parent.left; right: parent.right;}

                    onClicked: {
                        translation.visible = false;
                        myList.visible = true;
                        translation.text = starDictLib.updateList(inputField.text);
                    }

                }

                EntryList{
                    id: myList
                    width: col.width

                    onEntryClicked:{
                        inputField.text = entry;
                        translation.text = starDictLib.getTranslation(inputField.text);
                        myList.visible = false;
                        translation.visible = true;
                    }
                }

                Text {
                    id: translation
                    text: "Nothing found yet..."
                    width: col.width
                    wrapMode: Text.WordWrap
                    visible: false
                    font.pointSize: 24
                }
            }
        }
        ScrollDecorator {
            flickableItem: container
        }
    }
}
