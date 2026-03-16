/***************************************************************************

    sidudictlib.cpp - Sidudict, a StarDict clone based on QStarDict
    Copyright 2015 Murat Khairulin

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

.pragma library

function removeStyles(text) {
    while (true) {
        var start = text.indexOf("<style")
        if (start < 0)
            break
        var end = text.indexOf("</style>", start + 6)
        if (end < 0)
            break
        text = text.substr(0, start) + text.substr(end + 8)
    }
    return text
}

function removeHtmlTags(text) {
    text = removeStyles(text)
    var tokens = []
    var inTag = false
    var textStart = 0
    var textLen = 0
    for (var i = 0; i < text.length; ++i) {
        var cur = text[i]
        if (cur === "<") {
            if (textLen > 0)
                tokens.push(text.substr(textStart, textLen))
            inTag = true
            textLen = 0
        } else if (cur === ">") {
            inTag = false
            textStart = i + 1
            textLen = 0
        } else if (!inTag) {
            ++textLen
        }
    }
    if (textLen > 0)
        tokens.push(text.substr(textStart, textLen))
    return tokens.join(" ")
}
