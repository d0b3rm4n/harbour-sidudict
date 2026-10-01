#!/bin/bash
# vim:set softtabstop=4 shiftwidth=4 tabstop=4 expandtab:

##############################################################################
#
#    generate_dict_packages.sh - Sidudict, a StarDict clone based on QStarDict
#    Copyright 2014 Reto Zingg <g.d0b3rm4n@gmail.com>
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
BASE_URL="https://download.wikdict.com/dictionaries/stardict"
INDEX_URL="${BASE_URL}/"
TMP_DIR=$(mktemp -d /tmp/stardict_gen.XXXXXX)
TMP_ENTRIES=$(mktemp /tmp/stardict_entries.XXXXXX)

cleanup() {
    rm -rf "${TMP_DIR}" "${TMP_ENTRIES}"
}
trap cleanup EXIT

echo "Fetching dictionary list from ${INDEX_URL}..."
curl -sL "${INDEX_URL}" -o "${TMP_DIR}/index.html"

if [ ! -s "${TMP_DIR}/index.html" ]; then
    echo "ERROR: Failed to fetch index page"
    exit 1
fi

# Extract filenames and sizes from the Apache directory listing
# Lines are: <a href="wikdict-XX-YY.zip">wikdict-XX-YY.zip</a>  DATE  TIME  SIZE
grep -oP '<a href="wikdict-[a-z]{2}-[a-z]{2,3}\.zip">([^<]+)</a>\s+[^"]+\s+[0-9.]+[KM]?' \
    "${TMP_DIR}/index.html" > "${TMP_DIR}/zips.txt"

COUNTER=1
TOTAL=$(wc -l < "${TMP_DIR}/zips.txt")

while IFS= read -r line; do
    ZIPFILE=$(echo "$line" | sed -n 's/.*<a href="\(wikdict-[^"]*\.zip\)">.*/\1/p')
    ZIPSIZE=$(echo "$line" | awk '{print $NF}')

    if [ -z "$ZIPFILE" ]; then
        continue
    fi

    echo "[${COUNTER}/${TOTAL}] Processing: ${ZIPFILE} (${ZIPSIZE})"

    # Download zip to temp dir
    curl -sL "${BASE_URL}/${ZIPFILE}" -o "${TMP_DIR}/${ZIPFILE}"

    if [ ! -s "${TMP_DIR}/${ZIPFILE}" ]; then
        echo "  WARNING: Failed to download, skipping"
        continue
    fi

    # Extract and parse the IFO file
    IFO_CONTENT=$(unzip -p "${TMP_DIR}/${ZIPFILE}" '*.ifo' 2>/dev/null)

    if [ -z "$IFO_CONTENT" ]; then
        echo "  WARNING: Could not read IFO, skipping"
        rm -f "${TMP_DIR}/${ZIPFILE}"
        continue
    fi

    BOOKNAME=$(echo "$IFO_CONTENT" | grep 'bookname=' | sed 's/bookname=//' | head -1)
    WORDCOUNT=$(echo "$IFO_CONTENT" | grep 'wordcount=' | sed 's/wordcount=//' | head -1)
    DATE=$(echo "$IFO_CONTENT" | grep 'date=' | sed 's/date=//' | head -1)

    # XML escape the description
    DESCRIPTION=$(echo "$IFO_CONTENT" | grep 'description=' | sed 's/description=//' | head -1)
    if command -v xmlstarlet &>/dev/null && [ -n "$DESCRIPTION" ]; then
        DESCRIPTION=$(echo "$DESCRIPTION" | xmlstarlet esc)
    fi

    URL="${BASE_URL}/${ZIPFILE}"

    rm -f "${TMP_DIR}/${ZIPFILE}"

    if [ -z "$BOOKNAME" ]; then
        echo "  WARNING: No bookname, skipping"
        continue
    fi

    echo "  Name: ${BOOKNAME}"
    echo "  Entries: ${WORDCOUNT}"

    # Write entry to temp file (avoids subshell COUNTER issue)
    cat >> "${TMP_ENTRIES}" <<XMLENTRY
    <dictionary>
        <id>${COUNTER}</id>
        <name>${BOOKNAME}</name>
        <entries>${WORDCOUNT}</entries>
        <size>${ZIPSIZE}</size>
        <date>${DATE}</date>
        <url>${URL}</url>
        <description>${DESCRIPTION}</description>
    </dictionary>
XMLENTRY

    COUNTER=$((COUNTER + 1))
done < "${TMP_DIR}/zips.txt"

# Assemble final XML
echo '<?xml version="1.0" encoding="utf-8"?>' > "${DICT_XML}"
echo '<dictionaries>' >> "${DICT_XML}"
cat "${TMP_ENTRIES}" >> "${DICT_XML}"
echo '</dictionaries>' >> "${DICT_XML}"
