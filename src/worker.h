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

#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <lib/stardict.h>
#include <entrydictitem.h>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = 0);
    virtual ~Worker();

    // these are to be called synchronously
    void cancelUpdating();
    void getSuggestions(QList<EntryDictItem*> &map);
    bool isTranslatable(const QString &dict, const QString &entry);
    StarDict::Translation translate(const QString &dict, const QString &entry);

    StarDict &dictionary() {
        return *m_sd;
    }

signals:
    void suggestionsUpdated();

public slots:
    void updateList(const QString &query);

private:
    void setSuggestions(QList<EntryDictItem*> &map);

    StarDict *m_sd;
    bool m_cancelFlag;
    QAtomicInt m_suggestionsLock;
    QList<EntryDictItem*> m_suggestions;
};

#endif // WORKER_H
