/***************************************************************************

    showEntry.qml - Sidudict, a StarDict clone based on QStarDict
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
import "utils.js" as Utils

Page {
    property string pageTitleEntry
    property string dictTranslatedEntry

    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: pageTitleEntry }

            Row {
                id: buttonRow
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingMedium
                }
                spacing: Theme.paddingSmall

                Rectangle {
                    width: parent.width - copyText.width - smallerText.width - biggerText.width - buttonRow.spacing * 3
                    height: smallerText.height
                    opacity: 0
                }
                Button {
                    id: copyText
                    preferredWidth: Theme.buttonWidthSmall / 3
                    text: dentry.selectedText.length > 0 ? qsTr("Copy") : qsTr("Copy all")
                    onClicked: dentry.copyText()
                }
                Button {
                    id: smallerText
                    preferredWidth: Theme.buttonWidthSmall / 3
                    text: qsTr("-")
                    enabled: dentry.font.pointSize > Theme.fontSizeExtraSmall
                    onClicked: dentry.setFontSize(dentry.font.pointSize - 2)
                }
                Button {
                    id: biggerText
                    preferredWidth: Theme.buttonWidthSmall / 3
                    text: qsTr("+")
                    enabled: dentry.font.pointSize < Theme.fontSizeExtraLarge
                    onClicked: dentry.setFontSize(dentry.font.pointSize + 2)
                }
            }

            TextEdit {
                id: dentry
                anchors {
                    left: parent.left
                    right: parent.right
                    // left margin allows easier text selection
                    leftMargin: Theme.itemSizeSmall / 2
                    // right margin allows scrolling
                    rightMargin: Theme.itemSizeSmall
                }
                text: dictTranslatedEntry
                focus: false
                readOnly: true
                selectByMouse: true
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                property int prevSelectionStart: -1
                property int prevSelectionEnd: -1

                function setFontSize(newSize) {
                    if (newSize < Theme.fontSizeExtraSmall) {
                        newSize = Theme.fontSizeExtraSmall
                    } else if (newSize > Theme.fontSizeExtraLarge) {
                        newSize = Theme.fontSizeExtraLarge
                    }
                    font.pointSize = newSize
                }

                function copyText() {
                    var cleaned = Utils.removeHtmlTags(selectedText.length > 0 ? selectedText : text)
                    if (cleaned.lenght === 0)
                        return
                    Clipboard.text = cleaned
                    //console.log("copied " + cleaned.length)
                }

                onSelectedTextChanged: {
                    //console.log("select " + selectionStart + ":" + selectionEnd + "(prev: " + prevSelectionStart + ":" + prevSelectionEnd + ")")
                    if (prevSelectionStart === -1) {
                        selectWord()
                    } else if (prevSelectionStart >= 0) {
                        if (selectionEnd < prevSelectionStart || selectionStart > prevSelectionEnd) {
                            // click outside of the current selection removes selection
                            deselect()
                            // but this handler will be called again immediately,
                            // and we need to avoid word selection
                            prevSelectionStart = -2
                            prevSelectionEnd = -2
                            return
                        }
                    }
                    if (selectionStart < selectionEnd) {
                        prevSelectionStart = selectionStart
                        prevSelectionEnd = selectionEnd
                    } else {
                        prevSelectionStart = -1
                        prevSelectionEnd = -1
                    }
                }
            }
        }
    }
}
