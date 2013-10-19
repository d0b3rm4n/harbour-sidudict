/***************************************************************************

    entrydictitem.cpp - Sidudict, a StarDict clone based on QStarDict
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

#include <QString>
#include <QStringList>
#include <QDebug>

#include "entrydictitem.h"

EntryDictItem::EntryDictItem()
{
}

EntryDictItem::EntryDictItem(const QString &entry, const QString &dict)
{
    m_entry = entry;
    m_dict = dict;
}

EntryDictItem::EntryDictItem(const EntryDictItem &other)
{
    m_entry = other.entry();
    m_dict = other.dict();
}

EntryDictItem::~EntryDictItem()
{
}

QString EntryDictItem::entry() const
{
    return m_entry;
}

QString EntryDictItem::dict() const
{
    return m_dict;
}

void EntryDictItem::setEntry(const QString &entry)
{
    m_entry = entry;
}

void EntryDictItem::setDict(const QString &dict)
{
    m_dict = dict;
}

QDebug operator<<(QDebug dbg, const EntryDictItem &item)
{
    QStringList msg;
    msg << item.dict();
    msg << item.entry();
    dbg.nospace() << msg;

    return dbg.maybeSpace();
}


