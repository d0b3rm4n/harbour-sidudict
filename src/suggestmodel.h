/***************************************************************************

    suggestmodel.h - Sidudict, a StarDict clone based on QStarDict
    Copyright 2013 Reto Zingg <g.d0b3rm4n@gmail.com>

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

#ifndef SUGGESTMODEL_H
#define SUGGESTMODEL_H

#include <QVariant>
#include <QMultiHash>
#include <QString>
#include <QAbstractListModel>

#include "entrydictitem.h"

class SuggestModel : public QAbstractListModel
{
public:
    enum dictListModelRoles{
        SUGGEST_ENTRY_ROLE = Qt::UserRole + 10,
        SUGGEST_DICT_ROLE
    };

    SuggestModel(QObject *parent = 0);

    void setSuggestMap(QList<EntryDictItem*> &map);
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    QHash<int, QByteArray> roleNames() const;
    Qt::ItemFlags flags(const QModelIndex & index) const;
    QString firstDict();
    QString firstEntry();

signals:

public slots:

private:
    QList<EntryDictItem*> entryDictMap;
};

#endif // SUGGESTMODEL_H
