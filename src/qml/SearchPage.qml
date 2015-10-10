/***************************************************************************

    SearchPage.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2013 - 2014 Reto Zingg <g.d0b3rm4n@gmail.com>
    This file is based on the silicacomponentgallery-qt5 SearchPage.qml
    see copyright note below.

 ***************************************************************************/

/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Joona Petrell <joona.petrell@jollamobile.com>
** All rights reserved.
** 
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: searchPage
    property string searchString
    property bool keepSearchFieldFocus: true
    property int curIndex

    allowedOrientations: defaultAllowedOrientations

    Keys.onReturnPressed: {
        if (starDictLib.isFirstListItemTranslatable()) {
            var entry = starDictLib.firstListItemEntry();
            var translation = starDictLib.getTranslation(entry, starDictLib.firstListItemDict());
            pageStack.push(Qt.resolvedUrl("showEntry.qml"),{pageTitleEntry: entry, dictTranslatedEntry: translation});
        }
    }

    onSearchStringChanged: {
        starDictLib.updateList(searchString)
    }

    Component.onCompleted: {
        starDictLib.updateList(searchString)
    }

    Loader {
        anchors.fill: parent
        sourceComponent: listViewComponent
    }

    Column {
        id: headerContainer

        width: searchPage.width

        SearchField {
            id: searchField
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase
            placeholderText: "Search for..."

            Binding {
                target: searchPage
                property: "searchString"
                value: searchField.text
            }
        }
    }

    Component {
        id: listViewComponent
        SilicaListView {
            id: listView
            model: entryListModel
            anchors.fill: parent
            currentIndex: -1 // otherwise currentItem will steal focus

            Binding {
                target: searchPage
                property: "curIndex"
                value: listView.currentIndex
            }

            header:  Item {
                id: header
                width: headerContainer.width
                height: headerContainer.height
                Component.onCompleted: headerContainer.parent = header
            }

            PullDownMenu {
                MenuItem {
                    text: "About"
                    onClicked: {
//                        console.log("Clicked option About")
                        pageStack.push(Qt.resolvedUrl("about.qml"))
                    }
                }
                MenuItem {
                    text: "Help"
                    onClicked: {
//                        console.log("Clicked option Help")
                        pageStack.push(Qt.resolvedUrl("help.qml"))
                    }
                }
                MenuItem {
                    text: "Download"
                    onClicked: {
//                        console.log("Clicked option Download")
                        pageStack.push(Qt.resolvedUrl("DictDownload.qml"))
                    }
                }
                MenuItem {
                    text: "Settings"
                    onClicked: {
//                        console.log("Clicked option Settings")
                        pageStack.push(Qt.resolvedUrl("settings.qml"))
                    }
                }
            }

            delegate: ListItem{
                contentHeight: Theme.itemSizeMedium // two line delegate
                anchors.margins: Theme.paddingMedium
                onClicked: {
                    var translation = starDictLib.getTranslation(entry, dict)
                    pageStack.push(Qt.resolvedUrl("showEntry.qml"),{pageTitleEntry: entry, dictTranslatedEntry: translation})
                }

                Label {
                    id: label
                    text: entry
                    anchors {left: parent.left; right: parent.right}
                    anchors.margins: Theme.paddingMedium
                    color: Theme.primaryColor
                }
                Label {
                    anchors.top: label.bottom
                    text: dict
                    anchors {left: parent.left; right: parent.right}
                    anchors.margins: Theme.paddingMedium
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
            }

            VerticalScrollDecorator {}

            Component.onCompleted: {
                if (keepSearchFieldFocus) {
                    searchField.forceActiveFocus()
                }
                keepSearchFieldFocus = false
            }
        }
    }
}
