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
