var kToneNgang  = 0
var kToneHuyen  = 1
var kToneHoi    = 2
var kToneNga    = 3
var kToneSac    = 4
var kToneNang   = 5

var kGroupD = "DdĐđ"
var kConsonants = "BbCcDdĐđGgHhKkLlMmNnPpQqRrSsTtVvXx"
var kVowels = [
    /* row - all variants, main - number of variations */
    { row: "AaĂăÂâÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫÁáẮắẤấẠạẶặẬậ", main: 3 },
    { row: "EeÊêÈèỀềẺẻỂểẼẽỄễÉéẾếẸẹỆệ", main: 2 },
    { row: "IiÌìỈỉĨĩÍíỊị", main: 1 },
    { row: "OoÔôƠơÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡÓóỐốỚớỌọỘộỢợ", main: 3 },
    { row: "UuƯưÙùỪừỦủỬửŨũỮữÚúỨứỤụỰự", main: 2 },
    { row: "YyỲỳỶỷỸỹÝýỴỵ", main: 1 }
]

var kDirectives = "aeowdfrxsj"

/* param params: hash with mandatory root, consonant and optional caseId, variation, tone */
function compose(params) {
    var pos
    var root = params.root
    if (typeof root === 'undefined') {
        return '?'
    }
    if (params.consonant) {
        var variation = params.variation
        if (typeof variation === 'undefined') {
            return root
        }
        /* D-group */
        return kGroupD[variation * 2 + params.caseId]
    }
    for (var i in kVowels) {
        var group = kVowels[i]
        pos = group.row.indexOf(root)
        if (pos >= 0) {
            var toneLen = group.main * 2
            return group.row[toneLen * params.tone + params.variation * 2 + params.caseId]
        }
    }
    return "?"
}

function decompose(c) {
    var pos
    // check for 'D'-group
    pos = kGroupD.indexOf(c)
    if (pos >= 0) {
        return {
            root: kGroupD[1],
            caseId: pos % 2,
            consonant: true,
            variation: Math.floor(pos / 2)
        }
    }
    // check for other consonants
    if (kConsonants.indexOf(c) >= 0)
        return { root: c, consonant: true }
    // check for vowels
    for (var i in kVowels) {
        var group = kVowels[i]
        pos = group.row.indexOf(c)
        if (pos >= 0) {
            var toneLen = group.main * 2
            var toneId = Math.floor(pos / toneLen)
            return {
                root: group.row[1],
                caseId: pos % 2,
                consonant: false,
                variation: Math.floor((pos - toneId * toneLen) / 2),
                tone: toneId
            }
        }
    }
    return {}
}

function toneDirective(c) {
    switch (c) {
    case "f":
        return kToneHuyen
    case "r":
        return kToneHoi
    case "x":
        return kToneNga
    case "s":
        return kToneSac
    case "j":
        return kToneNang
    }
}

function doubleVariation(c) {
    switch(c) {
    case "a":
        return 2
    case "e":
        return 1
    case "o":
        return 1
    case "d":
        return 1
    }
}

/* variation if 'w' is appended */
function dubVariation(c) {
    switch(c) {
    case "a":
        return 1
    case "o":
        return 2
    case "u":
        return 1
    }
}

function telexAdd(input) {
    var position = input.length - 1
    var added = input[position].toLowerCase()
    if (kDirectives.indexOf(added) < 0) {
        return
    }
    input = input.substr(0, position) + input.substr(position + 1)

    /**** directive to change vowel tone ****/
    var changeTone = toneDirective(added)
    if (typeof changeTone !== 'undefined') {
        for (var i = position - 1; i >= 0; --i) {
            var d = decompose(input[i])
            /* check for word end */
            if (typeof d.root === 'undefined') {
                return
            }
            if (!d.consonant && d.tone !== changeTone) {
                d.tone = changeTone
                return input.substr(0, i) + compose(d) + input.substr(i + 1)
            }
        }
    }
    /**** directive to change variation (like aa, dd, ee, oo) ****/
    var changeVariation = doubleVariation(added)
    if (typeof changeVariation !== 'undefined') {
        for (var i = position - 1; i >= 0; --i) {
            var c = input[i]
            var d = decompose(c)
            /* check for word end */
            if (typeof d.root === 'undefined')
                return
            if (typeof d.variation === 'undefined')
                continue
            if (d.root === added && d.variation !== changeVariation) {
                d.variation = changeVariation
                return input.substr(0, i) + compose(d) + input.substr(i + 1)
            }
        }
    }
    /**** directive to change variation (like aw, uw, ow) ****/
    if (added === "w") {
        for (var i = position - 1; i >= 0; --i) {
            var d = decompose(input[i])
            /* check for word end */
            if (typeof d.root === 'undefined')
                return
            if (typeof d.variation === 'undefined')
                continue
            changeVariation = dubVariation(d.root)
            if (typeof changeVariation !== 'undefined' && d.variation !== changeVariation) {
                d.variation = changeVariation
                return input.substr(0, i) + compose(d) + input.substr(i + 1)
            }
        }
    }
}
