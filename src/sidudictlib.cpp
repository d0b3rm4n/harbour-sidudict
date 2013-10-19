/***************************************************************************

    sidudictlib.cpp - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011 Reto Zingg <g.d0b3rm4n@gmail.com>

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

#include <QDebug>
#include <QString>
#include <QStringListModel>
#include <QMultiHash>
#include <QModelIndex>
#include <QSettings>

#include <logging.h>

#include "sidudictlib.h"
#include "dictlistmodel.h"
#include "suggestmodel.h"
#include "lib/stardict.h"
#include "entrydictitem.h"

SiduDictLib::SiduDictLib()
{
    QSettings settings("harbour-sidudict","harbour-sidudict");
    QStringList selectedDictList = settings.value("Sidudict/selectedDictList", QStringList()).toStringList();

    m_sd = new StarDict(this);
    m_suggestModel = new SuggestModel();
    QList<EntryDictItem*> emptyWordList;
    emptyWordList.clear();
    m_suggestModel->setSuggestMap(emptyWordList);

    m_availableDicts = new DictListModel();

    connect(m_availableDicts,
            SIGNAL(dataChanged(QModelIndex,QModelIndex)),
            this,
            SLOT(availableDictsChanged(QModelIndex,QModelIndex)));

    QMap<QString, bool> map;

    LOG() << "available dicts" << m_sd->availableDicts();
    foreach(QString dict, m_sd->availableDicts()){
        if (selectedDictList.empty()) {
            map.insert(dict, true);
        } else {
            if (selectedDictList.contains(dict)) {
                map.insert(dict, true);
            } else {
                map.insert(dict, false);
            }
        }
    }
    m_availableDicts->setDictMap(map);

    LOG() << "loaded dicts" << m_sd->loadedDicts();

    foreach (QString dict, m_sd->availableDicts()) {
        LOG() << m_sd->dictInfo(dict).name();
        LOG() << m_sd->dictInfo(dict).author();
        LOG() << m_sd->dictInfo(dict).description();
        LOG() << m_sd->dictInfo(dict).wordsCount();
    }
}

SiduDictLib::~SiduDictLib()
{
    IN;
    QSettings settings("harbour-sidudict","harbour-sidudict");
    settings.setValue("Sidudict/selectedDictList", m_availableDicts->selectedDictList());
    settings.sync();
    delete m_sd;
}

void SiduDictLib::updateList(QString str){
    IN;

    QList<EntryDictItem*> wordList;
    wordList.clear();

    if (str.isEmpty()){
        m_suggestModel->setSuggestMap(wordList);
    } else {

        if (str.size() >= 3){
            foreach (QString dict, m_sd->availableDicts()) {
                QList<EntryDictItem*> tmpWordList;
                foreach(QString entry, m_sd->findSimilarWords(dict, str.simplified())){
                    EntryDictItem *item =  new EntryDictItem(entry, dict);
                    tmpWordList.append(item);
                }
                wordList.append(tmpWordList);
            }
        }

        foreach (QString dict, m_sd->availableDicts()) {
            QList<EntryDictItem*> tmpWordList;
            foreach(QString entry, m_sd->findWords(dict, str.simplified())){
                EntryDictItem *item =  new EntryDictItem(entry, dict);
                tmpWordList.prepend(item);
            }
            wordList.append(tmpWordList);
        }

        m_suggestModel->setSuggestMap(wordList);
    }
}

QString SiduDictLib::getTranslation(QString entry, QString dict)
{
    IN;
    LOG() << "getTranslation for:" << entry;
    LOG() << "getTranslation in:" << dict;

    if (m_sd->isTranslatable(dict, entry.simplified())) {
        return m_sd->translate(dict, entry.simplified()).translation();
    }

    return QString();
}

void SiduDictLib::setSelectDict(int index, bool value)
{
    IN;
    m_availableDicts->setSelectDict(index, value);
}

void SiduDictLib::availableDictsChanged(QModelIndex top, QModelIndex bottom)
{
    IN;
    Q_UNUSED(top);
    Q_UNUSED(bottom);

    LOG() << "selected dicts" << m_availableDicts->selectedDictList();
    m_sd->setLoadedDicts(m_availableDicts->selectedDictList());
}
