/***************************************************************************

    downloadmanager.h - Sidudict, a StarDict clone based on QStarDict
    Copyright 2010, 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

    the following methods are based on the examples of the Qt Toolkit see
    the follwing licence...

 ***************************************************************************/

/****************************************************************************
**
** Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial Usage
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Nokia.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QStringList>
#include <QTimer>
#include <QUrl>
#include <QDebug>
#include <QDir>

#include <stdio.h>

#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

class DownloadManager: public QObject
{
    Q_OBJECT
    QNetworkAccessManager manager;
    QList<QNetworkReply *> currentDownloads;

public:
    DownloadManager();
    void doDownload(const QUrl &url);
    QString saveFileName(const QUrl &url);
    QString savePathName();
    bool saveToDisk(const QString &filename, QIODevice *data);

public slots:
    void downloadFinished(QNetworkReply *reply);

signals:
    void done();
    void downloadFailed(QByteArray, QString);
    void downloadEnded(QByteArray);

};


#endif // DOWNLOADMANAGER_H
