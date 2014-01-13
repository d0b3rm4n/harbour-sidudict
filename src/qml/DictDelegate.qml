/***************************************************************************

    DictDelegate.qml - Sidudict, a StarDict clone based on QStarDict
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

import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    Label { text: name + " - " + id + " - " + url}
    onClicked: {
        // console.log("Details clicked");
        pageStack.push(Qt.resolvedUrl("DictDownloadDetails.qml"),
                       {
                           dictionaryName: name,
                           dictionaryEntries: entries,
                           dictionarySize: size,
                           dictionaryDate: date,
                           dictionaryDescription: description
                       })
    }
}
