/***************************************************************************

    stardict.h - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011, 2014 Reto Zingg <g.d0b3rm4n@gmail.com>
    this file was taken from qstardict-0.13.1 and adapted for Sidudict

 ***************************************************************************/

/*****************************************************************************
 * stardict.h - QStarDict, a StarDict clone written using Qt                 *
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

#ifndef STARDICT_H
#define STARDICT_H

#include "lib.h"

#include <string>
#include <QObject>
#include <QVector>
#include <QHash>
#include <QStringList>

class StarDict
{

public:
    StarDict(QObject *parent = 0);
    ~StarDict();

    /**
    * This class represents information about dictionary.
    */
    class DictInfo
    {
    public:
        /**
         * Construct empty DictInfo object.
         */
        DictInfo()
            : m_wordsCount(-1L)
        { }
        /**
         * Construct DictInfo object from data.
         * @param plugin A plugin name
         * @param name A dictionary name
         * @param author A dictionary author
         * @param desription A dictionary description
         * @param ifoFileName The IFO file name
         * @param wordsCount A count of words that available in dictionary
         */
        DictInfo(const QString &plugin,
                 const QString &name,
                 const QString &author = QString(),
                 const QString &description = QString(),
                 const QString &ifoFileName = QString(),
                 long wordsCount = -1L)
                     : m_plugin(plugin),
                     m_name(name),
                     m_author(author),
                     m_description(description),
                     m_ifo_file_name(ifoFileName),
                     m_wordsCount(wordsCount)
        { }

        const QString &plugin() const
        { return m_plugin; }
        const QString &name() const
        { return m_name; }
        const QString &author() const
        { return m_author; }
        const QString &description() const
        { return m_description; }
        const QString &ifoFileName() const
        { return m_ifo_file_name; }
        long wordsCount() const
        { return m_wordsCount; }

        void setPlugin(const QString &plugin)
        { m_plugin = plugin; }
        void setName(const QString &name)
        { m_name = name; }
        void setAuthor(const QString &author)
        { m_author = author; }
        void setDescription(const QString &description)
        { m_description = description; }
        void setIfoFileName(const QString &ifoFileName)
        { m_ifo_file_name = ifoFileName; }
        void setWordsCount(long wordsCount)
        { m_wordsCount = wordsCount; }

    private:
        QString m_plugin;
        QString m_name;
        QString m_author;
        QString m_description;
        QString m_ifo_file_name;
        long m_wordsCount;
    };

    /**
     * This class represent a translation.
     */
    class Translation
    {
    public:
        /**
         * Construct an empty translation.
         */
        Translation()
        { }

        /**
         * Construct a translation from data.
         * @param title A translation title
         * @param dictName A full dictionary name
         * @param translation A translation
         */
        Translation(const QString &title,
                    const QString &dictName,
                    const QString &translation)
                        : m_title(title),
                        m_dictName(dictName),
                        m_translation(translation)
        { }

        /**
         * Return the translation title.
         */
        const QString &title() const
        { return m_title; }

        /**
         * Return the dictionary name.
         */
        const QString &dictName() const
        { return m_dictName; }

        /**
         * Return the translation.
         */
        const QString &translation() const
        { return m_translation; }

        /**
         * Set a translation title.
         */
        void setTitle(const QString &title)
        { m_title = title; }

        /**
         * Set a dictionary name.
         */
        void setDictName(const QString &dictName)
        { m_dictName = dictName; }

        /**
         * Set a translation.
         */
        void setTranslation(const QString &translation)
        { m_translation = translation; }

                private:
        QString m_title;
        QString m_dictName;
        QString m_translation;
    };

    QString name() const
            { return "stardict"; }

    QStringList availableDicts() const;
    QStringList loadedDicts() const
        { return m_loadedDicts.keys(); }
    void setLoadedDicts(const QStringList &loadedDicts);
    DictInfo dictInfo(const QString &dict);

    bool isTranslatable(const QString &dict, const QString &word);
    Translation translate(const QString &dict, const QString &word);
    virtual QStringList findSimilarWords(const QString &dict, const QString &word);
    virtual QStringList findWords(const QString &dict, const QString &word);

private:
    QString parseData(const char *data, int dictIndex = -1,
            bool htmlSpaces = false, bool reformatLists = false, bool expandAbbreviations = false);

    Libs *m_sdLibs;
    QStringList m_dictDirs;
    QHash<QString, int> m_loadedDicts;
    bool m_reformatLists;
    bool m_expandAbbreviations;
};

#endif // STARDICT_H

// vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab cindent

