/***************************************************************************

    DictionaryStar.qml - Sidudict, a StarDict clone based on QStarDict
    Copyright 2012 Reto Zingg <g.d0b3rm4n@gmail.com>
    this file was taken from DictionaryStar and adapted for Sidudict

 ***************************************************************************/

/**********************************************************************************
 * DictionaryStar.qml - DictionaryStar, stardict dictionary for MeeGo Harmattan   *
 * Copyright (C) 2012 Jari P.T. Alhonen                                           *
 *                                                                                *
 * This program is free software; you can redistribute it and/or modify           *
 * it under the terms of the GNU General Public License as published by           *
 * the Free Software Foundation; either version 3 of the License, or              *
 * (at your option) any later version.                                            *
 *                                                                                *
 * This program is distributed in the hope that it will be useful,                *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of                 *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                  *
 * GNU General Public License for more details.                                   *
 *                                                                                *
 * You should have received a copy of the GNU General Public License along        *
 * with this program; if not, see <http://www.gnu.org/licenses/>.                 *
 **********************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
    id: dictionaryView
    
//    onStatusChanged: {
//        if(status === PageStatus.Active) {
//            commonTools.visible = false
//            if(dictCore.noEnabledDictionaries()) {
//                pageStack.push(Qt.resolvedUrl("Settings.qml"))
//            }
//            else
//                busy.visible = false
//        } else
//            busy.visible = true
//    }

    Rectangle {
        id: mainView
        anchors.fill: parent
        width: parent.width
        height: parent.height - text_input.height
        property bool monitorOrientation: false

        onVisibleChanged: {
            text_input.focus = visible
        }
        
        // This is monitoring orientation changes really
        onWidthChanged: if(monitorOrientation) dictView.updateCopyWidget()



        Flipable {
            id: flipable
            width: parent.width
//            height: parent.height - text_input.height - 15
            height: parent.height - text_input.height - 30
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.bottomMargin: 5

            property bool flipped: false
            
            onFlippedChanged: {
                if(flipped)
                    copyWidget.visible = false
                else {
                    dictView.updateCopyWidget()
                }
            }

            transform: Rotation {
                id: rotation
                origin.x: flipable.width/2
                origin.y: flipable.height/2
                axis.x: 0; axis.y: 1; axis.z: 0 // set axis.x to 1 to rotate around x-axis
                angle: 0    // the default angle
                onAngleChanged: {
                    if(angle == 0)
                        dictView.refresh()
                }
            }

            states: State {
                name: "back"
                PropertyChanges { target: rotation; angle: 180 }
                when: flipable.flipped
            }

            transitions: Transition {
                NumberAnimation { target: rotation; property: "angle"; duration: 200 }
            }
            
            Rectangle {
                id: invisible
                color: "transparent"
                height: 10
                width: 10
            }
            
            front:  Flickable {
                    id: flicker
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    interactive: false
                    contentHeight: dictView.height > height ? dictView.height : height
                    onContentHeightChanged: interactive = (contentHeight > height ? true : false)
                    onMovementStarted: pincher.enabled = false
                    onMovementEnded: pincher.enabled = true
                    PinchArea {
                        id: pincher
                        anchors.fill: parent
                        onPinchUpdated: {
                            var desiredSize = pinch.scale * dictView.currentFontSize
                            if(desiredSize >= dictView.minimumFontSize && desiredSize <= dictView.maximumFontSize)
                                dictView.font.pixelSize = desiredSize
                        }
                        onPinchFinished: {
                            var desiredSize = pinch.scale * dictView.currentFontSize
                            if(desiredSize >= dictView.minimumFontSize && desiredSize <= dictView.maximumFontSize)
                                dictView.font.pixelSize = desiredSize
                            dictView.currentFontSize = dictView.font.pixelSize
                            dictView.updateCopyWidget()
                            // dictCore.setDefaultFontSize(dictView.currentFontSize)
                            flicker.returnToBounds()
                        }
                    }
                    MouseArea {
                        property int startX
                        property int startY
                        anchors.fill: parent
                        onPressed: {
                            startX = mouse.x
                            startY = mouse.y
                        }
                        onClicked: dictView.deselect()
                        onReleased: {
                            if(Math.abs(startX - mouse.x) > 60) {
                                lister.update()
                                if(lister.count > 0)
                                    flipable.flipped = true
                            }
                        }
                    }
                    TextEdit {
                         id: dictView
                         wrapMode: TextEdit.Wrap
                         property string default_text: "<h3><i>"+qsTr("Please type a word or phrase to search for.")+"</i></h3>"
                         property int minimumFontSize: 10
                         property int maximumFontSize: 60
                         // property int currentFontSize: dictCore.defaultFontSize()
                         property int currentFontSize: 32
                         text: default_text
//                         width: parent.width - 90
                         width: parent.width - 50
                         anchors.horizontalCenter: parent.horizontalCenter
                         clip: true
                         readOnly: true
                         // font.pixelSize: dictCore.defaultFontSize()
                         font.pixelSize: 32
                         function refresh() {
                             // Platform bug: must forcing redraw
                             font.pixelSize--
                             font.pixelSize++
                         }
                         function updateCopyWidget() {
                             copyWidget.visible = (selectionStart != selectionEnd)
                             if(copyWidget.visible) {
                                mainView.monitorOrientation = true
                                var myX = dictView.cursorRectangle.x
                                var myY = dictView.cursorRectangle.y
                                if(copyWidget.width<0)
                                    copyWidget.countWidth()
                                myX -= (copyWidget.width / 2) // want it to the center
                                if(myX<0) // just verifying
                                    myX = 0
                                else if(myX + copyWidget.width > mainView.width)
                                    myX = mainView.width - copyWidget.width
                                if(myY - copyWidget.height > flicker.contentY) {
                                    myY -= copyWidget.height + 5
                                } else {
                                    myY += (dictView.font.pixelSize * 2)
                                }
                                copyWidget.x = myX
                                copyWidget.y = myY
                             }
                         }
                         
                         onSelectionChanged: updateCopyWidget()
                         MouseArea {
                             property int startX: -1
                             property int startY
                             property bool held: false
                             anchors.fill: parent
                             drag.target: invisible
                             drag.axis: Drag.XAxis
                             drag.minimumX: 0
                             drag.maximumX: 180
                             onPressAndHold: {
                                 held = true
                             }
                             onDoubleClicked: {
                                 startX = -1
                                 var spot = dictView.positionAt(mouse.x, mouse.y)
                                 dictView.select(spot, spot)
                                 dictView.selectWord()
                                 dictView.updateCopyWidget()
                             }
                             onClicked: dictView.deselect()
                             onPressed: {
                                 startX = mouse.x
                                 startY = mouse.y
                             }
                             onPositionChanged: {
                                 if(held) {
                                     dictView.select(dictView.positionAt(startX, startY), dictView.positionAt(mouse.x, mouse.y))
                                 }
                             }
                             onReleased: {
                                 if(!held && startX >= 0) {
                                     if(Math.abs(startX - mouse.x) > 60) {
                                         lister.update()
                                         if(lister.count > 0)
                                             flipable.flipped = true
                                     }
                                 } else {
                                     dictView.updateCopyWidget()
                                 }
                                 held = false
                             }
                         }
                    }
                    Text {
                        id: widgetWidth
                        property int countedWidth: -1
                        text: qsTrId("Copy")
                        font.pixelSize: 22
                        font.bold: true
                        visible: false
                        function countWidth() {
                            var cpwidth = width
                            text = qsTrId("Search")
                            if(cpwidth > width)
                                countedWidth = cpwidth
                            else
                                countedWidth = width
                        }
                    }
                    ButtonRow {
                        id: copyWidget
                        visible: false
                        width: -1
                        function countWidth() {
                            if(widgetWidth.countedWidth<0)
                                widgetWidth.countWidth()
                                width = (2*widgetWidth.countedWidth) + spacing + 44 // Button margins make up 44 pixels
                        }
                        platformStyle: ButtonStyle {
                            // don't want either to appear checked
                            checkedBackground: background
                            checkedTextColor: textColor
                            fontPixelSize: 22
                        }
                        Button {
                            id: copyButton
                            text: qsTrId("Copy")
                            onClicked: {
                                dictView.copy()
                                dictView.deselect()
                            }
                        }
                        Button {
                            id: searchButton
                            text: qsTrId("Find")
                            onClicked: {
                                text_input.text = dictView.selectedText
                                dictView.deselect()
                                flicker.contentY = 0
                            }
                        }
                    }
            }
            
            ScrollDecorator {
                flickableItem: flicker
            }

            back: Rectangle {
                anchors.fill: parent
                PinchArea {
                    id: listPincher
                    anchors.fill: parent
                    onPinchUpdated: {
                        var desiredSize = pinch.scale * lister.currentFontSize
                        if(desiredSize >= lister.minimumFontSize && desiredSize <= lister.maximumFontSize)
                            lister.fontSize = desiredSize
                    }
                    onPinchFinished: {
                        var desiredSize = pinch.scale * lister.currentFontSize
                        if(desiredSize >= lister.minimumFontSize && desiredSize <= lister.maximumFontSize)
                            lister.fontSize = desiredSize
                        lister.currentFontSize = lister.fontSize
                        // dictCore.setListFontSize(lister.fontSize)
                        lister.returnToBounds()
                    }
                }
                
                Component {
                    id: filler
                    MouseArea {
                        property int startX
                        property int startY
                        width: lister.width
                        height: (lister.interactive ? 0 : lister.height)
                        drag.target: invisible
                        drag.axis: Drag.XAxis
                        drag.minimumX: 0
                        drag.maximumX: 180
                        onPressed: {
                            startX = mouse.x
                            startY = mouse.y
                        }
                        onReleased: {
                            if(lister.count > 0 && Math.abs(startX - mouse.x) > 60)
                                flipable.flipped = false
                        }
                    }
                }

                ListView {
                    id: lister
                    property int minimumFontSize: 12
                    property int maximumFontSize: 64
                    // property int currentFontSize: dictCore.listFontSize()
                    property int currentFontSize: 32
                    // property int fontSize: dictCore.listFontSize()
                    property int fontSize: 32
                    property string currentWord
                    anchors.fill: parent
                    interactive: (visibleArea.heightRatio > 0 && visibleArea.heightRatio < 1 ? true : false)
                    onInteractiveChanged: footer = (interactive ? null : filler)
                    
                    function update() {
                        if(currentWord != text_input.text) {
                            currentWord = text_input.text;
                            // model = dictCore.listSimilarWords(currentWord)
//                            starDictLib.updateList(currentWord);
//                            model = entryListModel;
                            model = starDictLib.listSimilarWords(currentWord)
                        }
                    }
                    
                    delegate: Rectangle {
                        height: myText.height
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Text {
                            id: myText
                            text: modelData
                            clip: true
                            font.pixelSize: lister.fontSize
                            color: "mediumblue"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        MouseArea {
                            anchors.fill: parent
                            property int startX
                            property int startY
                            drag.target: invisible
                            drag.axis: Drag.XAxis
                            drag.minimumX: 0
                            drag.maximumX: 180
                            onClicked: {
                                if((mouse.x >= myText.x && mouse.x <= myText.x + myText.width) &&
                                    (mouse.y >= myText.y && mouse.y <= myText.y + myText.height)) {
//                                    dictView.text = dictCore.translate(myText.text)
                                    dictView.text = starDictLib.getTranslation(myText.text);
//                                    prevWord_img.visible = dictCore.canGoBack()
//                                    nextWord_img.visible = dictCore.canGoForward()
                                    flipable.flipped = false
                                }
                            }
                            onPressed: {
                                startX = mouse.x
                                startY = mouse.y
                            }
                            onReleased: {
                                startX = Math.abs(startX - mouse.x)
                                startY = Math.abs(startY - mouse.y)
                                if((startX > 50) && (startX > (startY * 2)))
                                    flipable.flipped = false
                            }
                        }
                    }
                }
                
                ScrollDecorator {
                    flickableItem: lister
                }
            }
        }


        TextField {
            id: text_input
            // property bool predictEnabled: dictCore.predictiveText()
            property bool predictEnabled: true
//            anchors.left: prediction.right
            anchors.left: parent.left
            anchors.leftMargin: 15
//            anchors.right: prevWord_img.visible? prevWord_img.left : ( nextWord_img.visible ? nextWord_img.left : settings_img.left )
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 1
            anchors.bottomMargin: 15
            // focus: dictCore.noEnabledDictionaries() ? false : true
            focus: true
            inputMethodHints: predictEnabled ?  Qt.ImhNone : Qt.ImhNoPredictiveText

            platformStyle: TextFieldStyle {
                paddingRight: icon.width
            }

            platformSipAttributes: SipAttributes {
                actionKeyLabel: qsTrId("Search")
            }

            onTextChanged: {
                icon.source = (text=="" ? "image://theme/icon-m-common-search" : "image://theme/icon-m-input-clear")
//                if (dictCore.isTranslatable(text)) {
                if (starDictLib.getTranslation(text).length > 0) {
                    // dictView.text = dictCore.translate(text)
                    dictView.text = starDictLib.getTranslation(text);
                    flipable.flipped = false;
                } else {
                    lister.update();
                    flipable.flipped = (lister.count > 0);
                }
//                prevWord_img.visible = dictCore.canGoBack()
//                nextWord_img.visible = dictCore.canGoForward()
            }
            Keys.onReturnPressed: textChanged()

            Image {
                id: icon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: "image://theme/icon-m-common-search"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        text_input.text = ""
                        text_input.focus = true
                        dictView.text = dictView.default_text
                        flipable.flipped = false
                    }
                }
            }
        }


//        Image {
//            id: prediction
//            anchors.left: parent.left
//            anchors.leftMargin: 5
//            anchors.rightMargin: 2
//            anchors.verticalCenter: text_input.verticalCenter
//            source: text_input.predictEnabled ? "qrc:/images/predictive-text.png" : "image://theme/icon-m-toolbar-edit"
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    text_input.predictEnabled = !text_input.predictEnabled
//                    text_input.focus = true
//                    // dictCore.setPredictiveText(text_input.predictEnabled)
//                }
//            }
//        }
              
//        Image {
//            id: prevWord_img
//            anchors.right: nextWord_img.visible ? nextWord_img.left : settings_img.left
//            anchors.verticalCenter: text_input.verticalCenter
//            source: "qrc:/images/icon-previous.png"
////            visible: dictCore.canGoBack()
//            visible: false
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    // text_input.text = dictCore.previousWord()
//                    flicker.contentY = 0
//                }
//            }
//        }
        
//        Image {
//            id: nextWord_img
//            anchors.right: settings_img.left
//            anchors.verticalCenter: text_input.verticalCenter
//            source: "qrc:/images/icon-next.png"
////            visible: dictCore.canGoForward()
//            visible: false
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
////                    text_input.text = dictCore.nextWord()
//                    flicker.contentY = 0
//                }
//            }
//        }
        
//        Image {
//            id: settings_img
//            source: "qrc:/images/configure.png"
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
//            height: 64
//            width: 64
//            MouseArea {
//                anchors.fill: parent
//                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
//            }
//        }
//    }
    
//    BusyIndicator {
//        id: busy
//        running: true
//        visible: true
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
//        platformStyle: BusyIndicatorStyle {
//            period: 800
//            numberOfFrames: 5
//        }
    }
}
