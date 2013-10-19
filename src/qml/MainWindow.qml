/***************************************************************************

    MainWindow.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011 - 2013 Reto Zingg <g.d0b3rm4n@gmail.com>

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

Page{
    id: mainWindow
    Component.onCompleted: {
        inputField.forceActiveFocus();
    }

    //    SilicaListView {
    //        anchors.fill: parent
    //        model: entryListModel
    //        spacing: Theme.paddingSmall
    //        // prevent newly added list delegates from stealing focus away from the search field
    ////        currentIndex: 0

    //        PullDownMenu {
    //            MenuItem {
    //                text: "About"
    //                onClicked: {
    //                    console.log("Clicked option About")
    //                    pageStack.push(Qt.resolvedUrl("about.qml"))
    //                }
    //            }
    //            MenuItem {
    //                text: "Help"
    //                onClicked: {
    //                    console.log("Clicked option Help")
    //                    pageStack.push(Qt.resolvedUrl("help.qml"))
    //                }
    //            }
    //            MenuItem {
    //                text: "Settings"
    //                onClicked: {
    //                    console.log("Clicked option Settings")
    //                    pageStack.push(Qt.resolvedUrl("settings.qml"))
    //                }
    //            }
    //        }

    //        header: SearchField {
    //            id: inputField
    //            width: parent.width
    //            focus: true
    //            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
    //            placeholderText: "Search..."

    //            onTextChanged: {
    //                starDictLib.updateList(inputField.text);
    //            }
    //        }

    //        delegate: ListItem{
    //            contentHeight: Theme.itemSizeMedium // two line delegate
    //            onClicked:{
    //                var translation = starDictLib.getTranslation(entry, dict)
    //                pageStack.push(Qt.resolvedUrl("showEntry.qml"),{pageTitleEntry: entry, dictTranslatedEntry: translation})
    //            }
    //            Label {
    //                id: label
    //                text: entry
    //                color: Theme.primaryColor
    //            }
    //            Label {
    //                anchors.top: label.bottom
    //                text: dict
    //                font.pixelSize: Theme.fontSizeSmall
    //                color: Theme.secondaryColor
    //            }
    //        }


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: col.height
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: {
                    console.log("Clicked option About")
                    pageStack.push(Qt.resolvedUrl("about.qml"))
                }
            }
            MenuItem {
                text: "Help"
                onClicked: {
                    console.log("Clicked option Help")
                    pageStack.push(Qt.resolvedUrl("help.qml"))
                }
            }
            MenuItem {
                text: "Settings"
                onClicked: {
                    console.log("Clicked option Settings")
                    pageStack.push(Qt.resolvedUrl("settings.qml"))
                }
            }
        }


        Column {
            id: col
            width: parent.width
            anchors.margins: Theme.paddingMedium
            spacing: Theme.paddingSmall

            function fillUpSpace() {
                var hight = Screen.height - inputField.height - (1 * col.spacing);
                return hight;
            }

            SearchField {
                id: inputField
                anchors {left: parent.left; right: parent.right}
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: "Search..."
                onTextChanged: {
                    starDictLib.updateList(inputField.text);
                }
            }

            EntryList{
                id: myList
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                height: col.fillUpSpace()
                clip: true

                onEntryClicked:{
                    inputField.text = entry
                    var translation = starDictLib.getTranslation(inputField.text, dict)
                    pageStack.push(Qt.resolvedUrl("showEntry.qml"),{pageTitleEntry: entry, dictTranslatedEntry: translation})
                }
            }
        }
    }
}
