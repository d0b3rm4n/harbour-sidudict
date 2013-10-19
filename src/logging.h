/***************************************************************************

    Copyright 2012 Reto Zingg <g.d0b3rm4n@gmail.com>

 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
#ifndef LOGGING_H
#define LOGGING_H

#include <QDebug>
#include <QDateTime>

#define STRINGIFY(z) STRINGIFY2(z)
#define STRINGIFY2(z) #z

#define LOG_HEADER() \
    QDateTime::currentDateTime().toString("hh:mm:ss.zzz ").append(__PRETTY_FUNCTION__).append(":" STRINGIFY(__LINE__))

#define LOG() \
    qDebug() << LOG_HEADER()

#define LOGF(fmt, ...) \
    qDebug("%s:%d " fmt, \
        __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define IN LOG() << "IN"
#define OUT LOG() << "OUT"

#endif // LOGGING_H
