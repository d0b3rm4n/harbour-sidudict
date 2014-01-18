#!/bin/bash
# vim:set softtabstop=4 shiftwidth=4 tabstop=4 expandtab:

##############################################################################
#
#    generate_dict_packages.sh - Sidudict, a StarDict clone based on QStarDict
#    Copyright 2013 Reto Zingg <g.d0b3rm4n@gmail.com>
#
##############################################################################

##############################################################################
#                                                                            #
#   This program is free software; you can redistribute it and/or modify     #
#   it under the terms of the GNU General Public License as published by     #
#   the Free Software Foundation; either version 2 of the License, or        #
#   (at your option) any later version.                                      #
#                                                                            #
#   This program is distributed in the hope that it will be useful,          #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#   GNU General Public License for more details.                             #
#                                                                            #
#   You should have received a copy of the GNU General Public License        #
#   along with this program; if not, write to the Free Software              #
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,               #
#   MA 02110-1301, USA.                                                      #
#                                                                            #
##############################################################################

DICT_XML="dictionaries.xml"
GITHUB="https://raw.github.com/d0b3rm4n/harbour-sidudict/master/data/dictionaries"

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > ${DICT_XML}
echo "<dictionaries>" >> ${DICT_XML}
COUNTER=1
for IFO_FILE in $(ls -1 */*.ifo) ; do
    echo "Process: ${IFO_FILE}"

    DIR_NAME=$(dirname ${IFO_FILE})

    zip -r ${DIR_NAME}.zip ${DIR_NAME}
    URL="${GITHUB}/${DIR_NAME}.zip"

    SIZE=$(du -h ${DIR_NAME}  |cut -f 1)
    WORDCOUNT=$(grep 'wordcount=' ${IFO_FILE} | sed -e 's/wordcount=//')
    DATE=$(grep 'date=' ${IFO_FILE} | sed -e 's/date=//')
    BOOKNAME=$(grep 'bookname=' ${IFO_FILE} | sed -e 's/bookname=//')
    DESCRIPTION=$(grep 'description=' ${IFO_FILE} | sed -e 's/description=//' | xmlstarlet esc )

    echo "    <dictionary>" >> ${DICT_XML}
    echo "        <id>${COUNTER}</id>" >> ${DICT_XML}
    echo "        <name>${BOOKNAME}</name>" >> ${DICT_XML}
    echo "        <entries>${WORDCOUNT}</entries>" >> ${DICT_XML}
    echo "        <size>${SIZE}</size>" >> ${DICT_XML}
    echo "        <date>${DATE}</date>" >> ${DICT_XML}
    echo "        <url>${URL}</url>" >> ${DICT_XML}
    echo "        <description>${DESCRIPTION}</description>" >> ${DICT_XML}
    echo "    </dictionary>" >> ${DICT_XML}

    COUNTER=$((COUNTER + 1))
done

echo "</dictionaries>" >> ${DICT_XML}

xmlstarlet val ${DICT_XML}

