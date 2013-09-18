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

#include "sidudictlib.h"
#include "lib/stardict.h"

SiduDictLib::SiduDictLib()
{
    m_sd = new StarDict(this);
    m_suggestModel = new QStringListModel();

    qDebug() << "available dicts" << m_sd->availableDicts();
    m_sd->setLoadedDicts(m_sd->availableDicts());
    qDebug() << "loaded dicts" << m_sd->loadedDicts();
}

void SiduDictLib::updateList(QString str){

    QStringList wordList;

    wordList.clear();

    // qDebug() << m_sd->findWords(str.simplified());
    wordList.append(m_sd->findWords(str.simplified()));

    foreach (QString dict, m_sd->availableDicts()) {
        // qDebug() << m_sd->findSimilarWords(dict, str.simplified());
        wordList.append(m_sd->findSimilarWords(dict, str.simplified()));
    }

    m_suggestModel->setStringList(wordList);
}

QString SiduDictLib::getTranslation(QString str){
    // qDebug() << "getTranslation for:" << str;
    foreach (QString dict, m_sd->availableDicts()) {
        if (m_sd->isTranslatable(dict, str.simplified())) {
            return m_sd->translate(dict,str.simplified()).translation();
        }
    }
    return QString();
}

QStringList SiduDictLib::listSimilarWords(QString str){
    updateList(str);
    return m_suggestModel->stringList();
}
