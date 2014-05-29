/***************************************************************************

    downloadmanager.cpp - Sidudict, a StarDict clone based on QStarDict
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

#include "downloadmanager.h"
#include "logging.h"
#include "JlCompress.h"

DownloadManager::DownloadManager()
{
    IN;
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            SLOT(downloadFinished(QNetworkReply*)));
}

void DownloadManager::doDownload(const QUrl &url)
{
    IN;
    QNetworkRequest request(url);
    QNetworkReply *reply = manager.get(request);

    currentDownloads.append(reply);
}

QString DownloadManager::saveFileName(const QUrl &url)
{
    IN;
    const QString pathName = savePathName();
    QString savePathName;
    savePathName.append(pathName);
    QString path = url.path();
    QString basename = QFileInfo(path).fileName();

    if (basename.isEmpty())
        basename = "download";

    savePathName.append(basename);

    LOG() << "save Path Name:" << savePathName;

    return savePathName;
}

QString DownloadManager::savePathName()
{
    QByteArray xdg_data_home = qgetenv("XDG_DATA_HOME");
    QString saveLocation;
    if (xdg_data_home.isEmpty()) {
        saveLocation = QDir::homePath() + QString("/.local/share/harbour-sidudict/");
    } else {
        saveLocation = QString("%1/harbour-sidudict/").arg(xdg_data_home.constData());
    }

    QDir savePathNameDir(saveLocation);
    if (!savePathNameDir.exists()){
        LOG() << "path does not exist:" << saveLocation;
        if (savePathNameDir.mkpath(saveLocation)){
                LOG() << "created path:" << saveLocation;
        } else {
            LOG() << "path creation failed:" << saveLocation;
        }
    }

    return saveLocation;
}

bool DownloadManager::saveToDisk(const QString &filename, QIODevice *data)
{
    IN;

    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly)) {
        LOG() << "Could not open" << qPrintable(filename) << "for writing:" << qPrintable(file.errorString());
        return false;
    }

    if (file.write(data->readAll()) > 0) {
        file.close();
        QStringList extractedList = JlCompress::extractDir(filename, savePathName());
        file.remove();
        LOG() << "Extracted:" << extractedList;
        if (extractedList.size() > 0) {
            return true;
        } else {
            return false;
        }
    } else {
        file.close();
        return false;
    }
}

void DownloadManager::downloadFinished(QNetworkReply *reply)
{
    IN;
    QUrl url = reply->url();

    if (reply->error()) {
        LOG() << "Download of" << url.toEncoded().constData() << "failed:" << qPrintable(reply->errorString());
        emit downloadFailed(url.toEncoded(), reply->errorString());
    } else {
        int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (httpStatusCode == 200) {
            QString filename = saveFileName(url);
            if (saveToDisk(filename, reply)){
                LOG() << "Download of" << url.toEncoded().constData() << "succeded saved to:"  << qPrintable(filename);
                emit downloadEnded(url.toEncoded());
            } else {
                emit downloadFailed(url.toEncoded(), "Could not save file!");
            }
        } else if (httpStatusCode == 301) {
            QUrl redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
            LOG() << url << ": 301 Moved Permanently to:";
            LOG() << redirectUrl;
            doDownload(redirectUrl);
        } else {
            emit downloadFailed(url.toEncoded(), QString("Could not handle HTTP status Code: %f").arg(httpStatusCode));
        }
    }

    currentDownloads.removeAll(reply);
    reply->deleteLater();

    if (currentDownloads.isEmpty()){
        // all downloads finished
        emit done();
    }

}
