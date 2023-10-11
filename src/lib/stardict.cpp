/***************************************************************************

    stardict.cpp - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011, 2014 Reto Zingg <g.d0b3rm4n@gmail.com>
    this file was taken from qstardict-0.13.1 and adapted for Sidudict

 ***************************************************************************/

/*****************************************************************************
 * stardict.cpp - QStarDict, a StarDict clone written using Qt               *
 * Copyright (C) 2008 Alexander Rodin                                        *
 *                                                                           *
 * This program is free software; you can redistribute it and/or modify      *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation; either version 2 of the License, or         *
 * (at your option) any later version.                                       *
 *                                                                           *
 * This program is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License along   *
 * with this program; if not, write to the Free Software Foundation, Inc.,   *
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.               *
 *****************************************************************************/

#include "stardict.h"

#include <list>
#include <map>
#include <string>
#include <utility>
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QStack>
#include <glib.h>
#include "lib.h"
#include "file.hpp"
#include <QDebug>

#include "logging.h"

namespace
{
void xdxf2html(QString &str);
QString whereDict(const QString &name, const QStringList &dictDirs);
const int MaxFuzzy = 24;

class StdList: public std::list<std::string>
{
    public:
        StdList()
            : std::list<std::string>()
        { }

        StdList(const QList<QString> &list)
            : std::list<std::string>()
        {
            for (QList<QString>::const_iterator i = list.begin(); i != list.end(); ++i)
                push_back(i->toUtf8().data());
        }

        StdList(const std::list<std::string> &list)
            : std::list<std::string>(list)
        { }

        QStringList toStringList() const
        {
            QStringList list;
            for (const_iterator i = begin(); i != end(); ++i)
                list << QString::fromUtf8(i->c_str());
            return list;
        }
};

class IfoListSetter
{
    public:
        IfoListSetter(QStringList *list)
            : m_list(list)
        { }

        void operator ()(const std::string &filename, bool)
        {
            DictInfo info;
            if (info.load_from_ifo_file(filename, false))
                m_list->push_back(QString::fromUtf8(info.bookname.c_str()));
        }

    private:
        QStringList *m_list;
};

class IfoFileFinder
{
    public:
        IfoFileFinder(const QString &name, QString *filename)
            : m_name(name.toUtf8().data()),
              m_filename(filename)
        { }

        void operator()(const std::string &filename, bool)
        {
            DictInfo info;
            if (info.load_from_ifo_file(filename, false) && info.bookname == m_name) {
                *m_filename = QString::fromUtf8(filename.c_str());
            }
        }

    private:
        std::string m_name;
        QString *m_filename;
};
}

StarDict::StarDict(QObject *parent)
{
    Q_UNUSED(parent);
    IN;

    m_sdLibs = new Libs;


    m_dictDirs = QStringList();
    m_reformatLists = true;
    m_expandAbbreviations = true;
    if (m_dictDirs.isEmpty())
    {
        m_dictDirs << "/usr/share/harbour-sidudict/dic";
        m_dictDirs << QDir::homePath() + "/Documents/Sidudict";

        QByteArray xdg_data_home = qgetenv("XDG_DATA_HOME");
        if (xdg_data_home.isEmpty()) {
            QString xdgLocation = QDir::homePath() + QString("/.local/share/harbour-sidudict/");
            m_dictDirs << xdgLocation;
        } else {
            QString xdgLocation = QString("%1/harbour-sidudict/").arg(xdg_data_home.constData());
            m_dictDirs << xdgLocation;
        }
        LOG() << "m_dictDirs" << m_dictDirs;
    }
}

StarDict::~StarDict()
{
    delete m_sdLibs;
}

QStringList StarDict::availableDicts() const
{
    QStringList result;
    IfoListSetter setter(&result);
    for_each_file(StdList(m_dictDirs), ".ifo", StdList(), StdList(), setter);

    return result;
}

void StarDict::setLoadedDicts(const QStringList &loadedDicts)
{
    IN;
    QStringList available = availableDicts();
    LOG() << "available: " << available;
    StdList disabledUrl;
    StdList availableUrl;
    for (QStringList::const_iterator i = available.begin(); i != available.end(); ++i)
    {
        availableUrl.push_back(whereDict(*i, m_dictDirs).toUtf8().data());
        if (! loadedDicts.contains(*i))
            disabledUrl.push_back(whereDict(*i, m_dictDirs).toUtf8().data());
    }
    LOG() << "disabledUrl" << disabledUrl.toStringList();
    LOG() << "availableUrl" << availableUrl.toStringList();
    m_sdLibs->reload(StdList(m_dictDirs), availableUrl, disabledUrl);

    m_loadedDicts.clear();
    for (int i = 0; i < m_sdLibs->ndicts(); ++i)
        m_loadedDicts[QString::fromUtf8(m_sdLibs->dict_name(i).c_str())] = i;

    LOG() << "m_loadedDicts" << m_loadedDicts;
}

StarDict::DictInfo StarDict::dictInfo(const QString &dict)
{
    ::DictInfo nativeInfo;
    nativeInfo.wordcount = 0;
    if (! nativeInfo.load_from_ifo_file(whereDict(dict, m_dictDirs).toUtf8().data(), false)) {
        return DictInfo();
    }
    DictInfo result(name(), dict);
    result.setAuthor(QString::fromUtf8(nativeInfo.author.c_str()));
    result.setDescription(QString::fromUtf8(nativeInfo.description.c_str()));
    result.setWordsCount(nativeInfo.wordcount ? static_cast<long>(nativeInfo.wordcount) : -1);
    result.setIfoFileName(QString::fromUtf8(nativeInfo.ifo_file_name.c_str()));
    return result;
}

bool StarDict::isTranslatable(const QString &dict, const QString &word)
{
    if (! m_loadedDicts.contains(dict))
        return false;
    long ind;
    return m_sdLibs->SimpleLookupWord(word.toUtf8().data(), ind, m_loadedDicts[dict]);
}

StarDict::Translation StarDict::translate(const QString &dict, const QString &word)
{
    if (! m_loadedDicts.contains(dict))
        return Translation();
    if (word.isEmpty())
        return Translation();
    int dictIndex = m_loadedDicts[dict];
    long ind;
    if (! m_sdLibs->SimpleLookupWord(word.toUtf8().data(), ind, m_loadedDicts[dict]))
        return Translation();
    return Translation(QString::fromUtf8(m_sdLibs->poGetWord(ind, dictIndex)),
            QString::fromUtf8(m_sdLibs->dict_name(dictIndex).c_str()),
            parseData(m_sdLibs->poGetWordData(ind, dictIndex), dictIndex, true,
                m_reformatLists, m_expandAbbreviations));
}

QStringList StarDict::findSimilarWords(const QString &dict, const QString &word)
{
    if (! m_loadedDicts.contains(dict))
        return QStringList();
    gchar *fuzzy_res[MaxFuzzy];
    if (! m_sdLibs->LookupWithFuzzy(word.toUtf8().data(), fuzzy_res, MaxFuzzy, m_loadedDicts.value(dict)))
        return QStringList();
    QStringList result;
    for (gchar **p = fuzzy_res, **end = fuzzy_res + MaxFuzzy; p != end && *p; ++p)
    {
        result << QString::fromUtf8(*p);
        g_free(*p);
    }
    return result;
}

QStringList StarDict::findWords(const QString &dict, const QString &word)
{
    QStringList returnList;

    if (! m_loadedDicts.contains(dict))
        return returnList;

    gchar **ppMatchWord =
            (gchar **) g_malloc(sizeof(gchar *) * (MAX_MATCH_ITEM_PER_LIB) * m_loadedDicts.size());
    QString ruleString = word;
    ruleString.append("*");
//    qDebug() << "ruleString:" << ruleString;

    gint count = m_sdLibs->LookupWithRule(ruleString.toUtf8().data(), ppMatchWord, m_loadedDicts.value(dict));
//    qDebug() << "findWords count:" << count;

    if (count) {
        for (gint i = 0; i < count; i++){
//            qDebug() << "result:" << i << "word:" << ppMatchWord[i];
            returnList.append(QString::fromUtf8(ppMatchWord[i]));
        }
    }

    return returnList;
}

QString StarDict::parseData(const char *data, int dictIndex, bool htmlSpaces, bool reformatLists, bool expandAbbreviations)
{
    QString result;
    quint32 dataSize = *reinterpret_cast<const quint32*>(data);
    const char *dataEnd = data + dataSize;
    const char *ptr = data + sizeof(quint32);
    while (ptr < dataEnd)
    {
        switch (*ptr++)
        {
            case 'm':
            case 'l':
            case 'g':
            case 'h':
            {
                QString str = QString::fromUtf8(ptr);
                ptr += str.toUtf8().length() + 1;
                result += str;
                break;
            }
            case 'x':
            {
                QString str = QString::fromUtf8(ptr);
                ptr += str.toUtf8().length() + 1;
                xdxf2html(str);
                result += str;
                break;
            }
            case 't':
            {
                QString str = QString::fromUtf8(ptr);
                ptr += str.toUtf8().length() + 1;
                result += "<font class=\"example\">";
                result += str;
                result += "</font>";
                break;
            }
            case 'y':
            {
                ptr += strlen(ptr) + 1;
                break;
            }
            case 'W':
            case 'P':
            {
                ptr += *reinterpret_cast<const quint32*>(ptr) + sizeof(quint32);
                break;
            }
            default:
                ; // nothing
        }
    }

    if (expandAbbreviations)
    {
        QRegExp regExp("_\\S+[\\.:]");
        int pos = 0;
        while ((pos = regExp.indexIn(result, pos)) != -1)
        {
            long ind;
            if (m_sdLibs->SimpleLookupWord(result.mid(pos, regExp.matchedLength()).toUtf8().data(), ind, dictIndex))
            {
                QString expanded = "<font class=\"explanation\">";
                expanded += parseData(m_sdLibs->poGetWordData(ind, dictIndex));
                if (result[pos + regExp.matchedLength() - 1] == ':')
                    expanded += ':';
                expanded += "</font>";
                result.replace(pos, regExp.matchedLength(), expanded);
                pos += expanded.length();
            }
            else
                pos += regExp.matchedLength();
        }
    }
    if (reformatLists)
    {
        int pos = 0;
        QStack<QChar> openedLists;
        while (pos < result.length())
        {
            if (result[pos].isDigit())
            {
                int n = 0;
                while (result[pos + n].isDigit())
                    ++n;
                pos += n;
                if (result[pos] == '&' && result.mid(pos + 1, 3) == "gt;")
                    result.replace(pos, 4, ">");
                QChar marker = result[pos];
                QString replacement;
                if (marker == '>' || marker == '.' || marker == ')')
                {
                    if (n == 1 && result[pos - 1] == '1') // open new list
                    {
                        if (openedLists.contains(marker))
                        {
                            replacement = "</li></ol>";
                            while (openedLists.size() && openedLists.top() != marker)
                            {
                                replacement += "</li></ol>";
                                openedLists.pop();
                            }
                        }
                        openedLists.push(marker);
                        replacement += "<ol>";
                    }
                    else
                    {
                        while (openedLists.size() && openedLists.top() != marker)
                        {
                            replacement += "</li></ol>";
                            openedLists.pop();
                        }
                        replacement += "</li>";
                    }
                    replacement += "<li>";
                    pos -= n;
                    n += pos;
                    while (result[pos - 1].isSpace())
                        --pos;
                    while (result[n + 1].isSpace())
                        ++n;
                    result.replace(pos, n - pos + 1, replacement);
                    pos += replacement.length();
                }
                else
                    ++pos;
            }
            else
                ++pos;
        }
        while (openedLists.size())
        {
            result += "</li></ol>";
            openedLists.pop();
        }
    }
    if (htmlSpaces)
    {
        int n = 0;
        while (result[n].isSpace())
            ++n;
        result.remove(0, n);
        n = 0;
        while (result[result.length() - 1 - n].isSpace())
            ++n;
        result.remove(result.length() - n, n);

        for (int pos = 0; pos < result.length();)
        {
            switch (result[pos].toLatin1())
            {
                case '[':
                    result.insert(pos, "<font class=\"transcription\">");
                    pos += 28 + 1; // sizeof "<font class=\"transcription\">" + 1
                    break;
                case ']':
                    result.insert(pos + 1, "</font>");
                    pos += 7 + 1; // sizeof "</font>" + 1
                    break;
                case '\t':
                    result.insert(pos, "&nbsp;&nbsp;&nbsp;&nbsp;");
                    pos += 24 + 1; // sizeof "&nbsp;&nbsp;&nbsp;&nbsp;" + 1
                    break;
                case '\n':
                {
                    int count = 1;
                    n = 1;
                    while (result[pos + n].isSpace())
                    {
                        if (result[pos + n] == '\n')
                            ++count;
                        ++n;
                    }
                    if (count > 1)
                        result.replace(pos, n, "</p><p>");
                    else
                        result.replace(pos, n, "<br>");
                    break;
                }
                default:
                    ++pos;
            }
        }
    }
    return result;
}

namespace
{
QString whereDict(const QString &name, const QStringList &dictDirs)
{
    QString filename;
    IfoFileFinder finder(name, &filename);
    for_each_file(StdList(dictDirs), ".ifo", StdList(), StdList(), finder);
    return filename;
}

void xdxf2html(QString &str)
{
    str.replace("<abr>", "<font class=\"abbreviature\">");
    str.replace("<tr>", "<font class=\"transcription\">[");
    str.replace("</tr>", "]</font>");
    str.replace("<ex>", "<font class=\"example\">");
    str.replace(QRegExp("<k>.*<\\/k>"), "");
    str.replace(QRegExp("(<\\/abr>)|(<\\ex>)"), "</font");
}

}

// vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab cindent textwidth=120 formatoptions=tc
