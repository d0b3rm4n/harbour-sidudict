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
            spacing: Theme.paddingSmall

            PageHeader { title: pageTitleEntry }
            Label {
                id: translation
                property int minimumPointSize: Theme.fontSizeExtraSmall
                property int maximumPointSize: Theme.fontSizeExtraLarge
                property int currentPointSize: Theme.fontSizeMedium
                text: dictTranslatedEntry
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                wrapMode: Text.WordWrap
                font.pointSize: translation.currentPointSize
                color: Theme.primaryColor
                textFormat: Text.RichText

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
