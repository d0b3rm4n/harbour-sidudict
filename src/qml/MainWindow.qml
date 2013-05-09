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
import Sailfish.Silica 1.0

Page{
    id: mainWindow
    Component.onCompleted: {
        inputField.forceActiveFocus();
        inputField.openSoftwareInputPanel()
    }

    Column {
        id: col
        anchors.fill: parent
        anchors.margins: theme.paddingMedium
        spacing: theme.paddingMedium


        Label {
            id: searchLabel
            anchors {left: parent.left; right: parent.right}
            text: "Search for:"
        }

        TextField {
            id: inputField
            anchors {left: parent.left; right: parent.right}
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
            placeholderText: "Search..."

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

            // does not work in!?
            Keys.onPressed: {
                console.log('onPressed');
                if(event.key >= Qt.Key_A
                        && event.key <= Qt.Key_Z
                        || event.key === Qt.Key_Backspace){
                    translation.text = starDictLib.updateList(inputField.text);
                }
            }
        }

        Button {
            id: deleteButton
            anchors {left: parent.left; right: parent.right}
            text: "new search"

            onClicked: {
                inputField.text = "";
                inputField.forceActiveFocus();
                inputField.openSoftwareInputPanel();
            }

        }

        Button {
            id: suggestButton
            anchors {left: parent.left; right: parent.right}
            text: "suggestions"

            onClicked: {
                translation.visible = false;
                myList.visible = true;
                starDictLib.updateList(inputField.text);
            }
        }


        EntryList{
            id: myList
            width: col.width - (2 * col.spacing)
            height: col.height - searchLabel.height - inputField.height - deleteButton.height - suggestButton.height

            onEntryClicked:{
                inputField.text = entry;
                translation.text = starDictLib.getTranslation(inputField.text);
                myList.visible = false;
                translation.visible = true;
            }
        }

        Item{
            // anchors {left: parent.left; right: parent.right}
            width: col.width - (2 * col.spacing)
            height: col.height - searchLabel.height - inputField.height - deleteButton.height - suggestButton.height

            SilicaFlickable {
                anchors.fill: parent
                pressDelay: 100
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.DragAndOvershootBounds
                contentHeight: 1.02 * translation.height + (2 * theme.paddingMedium)

                Text {
                    id: translation
                    property int minimumPointSize: theme.fontSizeExtraSmall
                    property int maximumPointSize: theme.fontSizeExtraLarge
                    property int currentPointSize: theme.fontSizeMedium
                    text: "Nothing found yet..."
                    anchors {left: parent.left; right: parent.right;}

                    wrapMode: Text.WordWrap
                    visible: false
                    font.pointSize: translation.currentPointSize
                    color: theme.primaryColor

                    PinchArea {
                        anchors.fill: parent
                        onPinchUpdated: {
                            var desiredSize = pinch.scale * translation.currentPointSize;
                            if(desiredSize >= translation.minimumPointSize && desiredSize <= translation.maximumPointSize)
                                translation.font.pointSize = desiredSize
                            else if (desiredSize < translation.minimumPointSize)
                                translation.font.pointSize = translation.minimumPointSize
                            else if (desiredSize > translation.maximumPointSize)
                                translation.font.pointSize = translation.maximumPointSize
                        }
                        onPinchFinished: {
                            var desiredSize = pinch.scale * translation.currentPointSize;
                            if(desiredSize >= translation.minimumPointSize && desiredSize <= translation.maximumPointSize)
                                translation.currentPointSize = desiredSize
                            else if (desiredSize < translation.minimumPointSize)
                                translation.currentPointSize = translation.minimumPointSize
                            else if (desiredSize > translation.maximumPointSize)
                                translation.currentPointSize = translation.maximumPointSize

                            translation.font.pointSize = translation.currentPointSize;
                        }
                    }
                }
            }
        }
    }
}
