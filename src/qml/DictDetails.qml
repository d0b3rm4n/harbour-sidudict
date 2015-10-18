/***************************************************************************

    dictDetails.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

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
    property string dictionaryName

    allowedOrientations: defaultAllowedOrientations

    RemorsePopup { id: remorse }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        PullDownMenu{
            MenuItem {
                text: "Delete"
                onClicked: {
//                    console.log("Delete clicked for: " + dictionaryName);
                    remorse.execute("Delete: " + dictionaryName,
                        function() {
                            starDictLib.deleteDictionary(dictionaryName);
                            pageStack.navigateBack(PageStackAction.Animated);
                        } )
                }
            }
        }
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader { title: dictionaryName }

            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                font.bold: true
                font.underline: true
                text: "Name:"
            }
            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                text: dictionaryName
            }

            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                font.bold: true
                font.underline: true
                text: "Entries:"
            }
            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                text: starDictLib.dictInfoWordsCount(dictionaryName)
            }

            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                font.bold: true
                font.underline: true
                text: "Author:"
            }
            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                text: starDictLib.dictInfoAuthor(dictionaryName)
            }

            Label {
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                font.bold: true
                font.underline: true
                text: "Description:"
            }
            Label {
                wrapMode: Text.WordWrap
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                text: starDictLib.dictInfoDescription(dictionaryName)
            }
        }
    }
}
