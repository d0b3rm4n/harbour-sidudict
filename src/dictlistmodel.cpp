/***************************************************************************

    dictlistmodel.cpp - Sidudict, a StarDict clone based on QStarDict
    Copyright 2013, 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

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

#include <QStringList>

#include "logging.h"
#include "dictlistmodel.h"

DictListModel::DictListModel(QObject *parent) :
    QAbstractListModel(parent)
{
}


void DictListModel::setDictMap(const QMap<QString, QVariant> &map)
{
    IN;
    if (!dictMap.isEmpty()){
        LOG() << "ResetModel";
        beginRemoveRows(QModelIndex(), 0, dictMap.size() - 1);
        dictMap.clear();
        endRemoveRows();
    }

    int counter = 0;
    foreach(QString item, map.keys()){
        beginInsertRows(QModelIndex(), counter, counter);
        dictMap.insert(item, map.value(item));
        endInsertRows();

        QModelIndex index = createIndex(counter, counter);

        emit dataChanged(index, index);
    }
}

int DictListModel::rowCount(const QModelIndex & /* parent */) const
{
    return dictMap.count();
}

QVariant DictListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == DICT_NAME_ROLE) {
        return dictAt(index.row());
    } else if (role == DICT_SELECT_ROLE){
        return dictMap.value(dictAt(index.row()));
    }
    return QVariant();
}

bool DictListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() >= 0 && index.row() < dictMap.count()
            && (role == Qt::EditRole || role == DICT_SELECT_ROLE)) {

        dictMap.insert(dictAt(index.row()), value);

        emit dataChanged(index, index);
        return true;
    }
    return false;
}

QHash<int, QByteArray> DictListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DICT_NAME_ROLE] = "name";
    roles[DICT_SELECT_ROLE] = "selected";
    return roles;
}

Qt::ItemFlags DictListModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags flags = QAbstractItemModel::flags(index);
    flags |= Qt::ItemIsEditable;
    return flags;
}

void DictListModel::setSelectDict(int row, bool value)
{
    IN;
    QModelIndex index = createIndex(row, 0);
    setData(index, QVariant(value), DICT_SELECT_ROLE);
}

QStringList DictListModel::selectedDictList()
{
    IN;
    QStringList selectedDicts;
    foreach(QString dict, dictMap.keys()){
        if (dictMap.value(dict).toBool())
            selectedDicts.append(dict);
    }
    return selectedDicts;
}

QMap<QString, QVariant> DictListModel::dictListMap()
{
    return dictMap;
}

QString DictListModel::dictAt(int offset) const
{
    return (dictMap.begin() + offset).key();
}
