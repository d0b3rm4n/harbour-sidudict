/***************************************************************************

    distlistmodel.h - Sidudict, a StarDict clone based on QStarDict
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

#ifndef DICTLISTMODEL_H
#define DICTLISTMODEL_H

#include <QVariant>
#include <QMap>
#include <QString>
#include <QAbstractListModel>


class DictListModel : public QAbstractListModel
{
public:
    enum dictListModelRoles{
        DICT_NAME_ROLE = Qt::UserRole + 1,
        DICT_SELECT_ROLE
    };

    DictListModel(QObject *parent = 0);

    void setDictMap(const QMap<QString, QVariant> &map);
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    QHash<int, QByteArray> roleNames() const;
    Qt::ItemFlags flags(const QModelIndex & index) const;
    void setSelectDict(int row, bool value);
    QStringList selectedDictList();
    QMap<QString, QVariant> dictListMap();
    
signals:
    
public slots:
    
private:
    QString dictAt(int offset) const;
    QMap<QString, QVariant> dictMap;
};

#endif // DICTLISTMODEL_H
