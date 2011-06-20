/***************************************************************************

    sidudictlib.h - Sidudict, a StarDict clone based on QStarDict
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

#ifndef SIDUDICTLIB_H
#define SIDUDICTLIB_H

#include <QStringListModel>

#include "lib/stardict.h"

class SiduDictLib:public QObject
{
    Q_OBJECT

public:
    SiduDictLib();
    Q_INVOKABLE void updateList(QString);
    Q_INVOKABLE QString getTranslation(QString);
    QStringListModel *m_suggestModel;

private:
    StarDict *m_sd;

};

#endif // SIDUDICTLIB_H
