/***************************************************************************

    settings.qml - Sidudict, a StarDict clone based on QStarDict
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

    ListModel {
        id: inputMethodNames
        ListElement { name: "none"; token: "none" }
        ListElement { name: "Telex (for Vietnamese)"; token: "telex" }
    }

    function selectedInputMethod() {
        var cur = starDictLib.inputMethod
        for (var i = 0; i < inputMethodNames.count; ++i) {
            if (cur === inputMethodNames.get(i).token) {
                return i
            }
        }
        return 0
    }

    SilicaListView{
        id: listView
        anchors.fill: parent

        VerticalScrollDecorator { flickable: listView }

        header: Column {
            width: parent.width

            PageHeader {
                width: parent.width
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Special input methods")
            }

            ComboBox {
                id: inputMethodBox
                width: parent.width
                label: qsTr("Method: ")
                currentIndex: selectedInputMethod()

                menu: ContextMenu {
                    Repeater {
                        model: inputMethodNames
                        MenuItem {
                            text: model.name
                            onClicked: {
                                starDictLib.inputMethod = token
                            }
                        }
                    }
                }
            }

            SectionHeader {
                text: qsTr("Dictionaries (long tap for details)")
            }
        }

        model: availableDictListModel
        delegate: ListItem {
            id: dictListItem
            onClicked: {
                dictSwitch.checked = dictSwitch.checked ? false : true;
                starDictLib.setSelectDict(index, dictSwitch.checked);
            }
            Row {
                Switch {
                    id: dictSwitch
                    checked: selected
                    automaticCheck: false
                    propagateComposedEvents: true
                    onClicked: {
                        console.log("clicked dictSwitch");
                        mouse.accepted = false;
                    }
                }
                Label {
                    id: dictlabel
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.primaryColor
                }
            }
            menu: ContextMenu {
                MenuItem {
                    text: "Details"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("DictDetails.qml"), { dictionaryName: name })
                    }
                }
            }
        }
    }
}

