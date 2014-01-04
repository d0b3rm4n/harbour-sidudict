/***************************************************************************

    suggestmodel.cpp - Sidudict, a StarDict clone based on QStarDict
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

#include <QMultiHash>
#include <QVector>

#include "suggestmodel.h"
#include "logging.h"
#include "entrydictitem.h"

SuggestModel::SuggestModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

void SuggestModel::setSuggestMap(QList<EntryDictItem*> &map)
{
    IN;
    LOG() << "map.count" << map.size();

    if (!entryDictMap.isEmpty()){
        LOG() << "ResetModel";
        beginRemoveRows(QModelIndex(), 0, entryDictMap.size() - 1);
        entryDictMap.clear();
        endRemoveRows();
    }

    int counter = 0;
    foreach(EntryDictItem* item, map){
        beginInsertRows(QModelIndex(), counter, counter);
        entryDictMap.insert(counter, item);
        endInsertRows();

        QModelIndex index = createIndex(counter, counter);

        emit dataChanged(index, index);
    }
    LOG() << "entryDictMap:" << entryDictMap.count();
}

int SuggestModel::rowCount(const QModelIndex & /*parent */) const
{
    return entryDictMap.count();
}

QVariant SuggestModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == SUGGEST_ENTRY_ROLE) {
        return entryDictMap[index.row()]->entry();
    } else if (role == SUGGEST_DICT_ROLE){
        return entryDictMap[index.row()]->dict();
    }
    return QVariant();
}

bool SuggestModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() >= 0 && index.row() < entryDictMap.count()
            && (role == Qt::EditRole || role == SUGGEST_DICT_ROLE)) {

        entryDictMap[index.row()]->setDict(value.toString());

        emit dataChanged(index, index, QVector<int>(SUGGEST_DICT_ROLE));
        return true;
    } else if (index.row() >= 0 && index.row() < entryDictMap.count()
               && (role == Qt::EditRole || role == SUGGEST_ENTRY_ROLE)) {

        entryDictMap[index.row()]->setEntry(value.toString());

        emit dataChanged(index, index, QVector<int>(SUGGEST_ENTRY_ROLE));
        return true;
    }

    return false;
}

QHash<int, QByteArray> SuggestModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[SUGGEST_ENTRY_ROLE] = "entry";
    roles[SUGGEST_DICT_ROLE] = "dict";
    return roles;
}

Qt::ItemFlags SuggestModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags flags = QAbstractItemModel::flags(index);
    flags |= Qt::ItemIsEditable;
    return flags;
}

QString SuggestModel::firstDict()
{
    if (entryDictMap.empty()) {
        return QString();
    } else {
        return entryDictMap.at(0)->dict();
    }
}

QString SuggestModel::firstEntry()
{
    if (entryDictMap.empty()) {
        return QString();
    } else {
        return entryDictMap.at(0)->entry();
    }
}
