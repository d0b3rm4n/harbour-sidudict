/***************************************************************************

    entrydictitem.h - Sidudict, a StarDict clone based on QStarDict
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

#ifndef ENTRYDICTITEM_H
#define ENTRYDICTITEM_H

#include <QString>
#include <QDebug>
#include <QMetaType>


class EntryDictItem
{
public:
    EntryDictItem();
    EntryDictItem(const QString &entry, const QString &dict);
    EntryDictItem(const EntryDictItem &other);
    ~EntryDictItem();
    QString entry() const;
    QString dict() const;
    void setEntry(const QString &entry);
    void setDict(const QString &dict);

private:
    QString m_entry;
    QString m_dict;
};

Q_DECLARE_METATYPE(EntryDictItem)

QDebug operator<<(QDebug dbg, const EntryDictItem &item);

#endif // ENTRYDICTITEM_H
