/***************************************************************************

    sidudictlib.h - Sidudict, a StarDict clone based on QStarDict
    Copyright 2011 - 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

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
#include <QModelIndex>

#include "dictlistmodel.h"
#include "suggestmodel.h"
#include "downloadmanager.h"
#include "worker.h"

class SiduDictLib:public QObject
{
    Q_OBJECT

public:
    SiduDictLib();
    ~SiduDictLib();
    Q_INVOKABLE void updateList(QString);
    Q_INVOKABLE QString getTranslation(QString entry, QString dict);
//    Q_INVOKABLE QStringList listSimilarWords(QString);
    Q_INVOKABLE void setSelectDict(int index, bool value);
    Q_INVOKABLE bool isFirstListItemTranslatable();
    Q_INVOKABLE QString firstListItemDict();
    Q_INVOKABLE QString firstListItemEntry();
    Q_INVOKABLE QString lastTranslation();
    Q_INVOKABLE QString dictInfoAuthor(QString dict);
    Q_INVOKABLE QString dictInfoDescription(QString dict);
    Q_INVOKABLE QString dictInfoWordsCount(QString dict);
    Q_INVOKABLE void downloadDict(QString url);
    Q_INVOKABLE bool showNotification(QString category, const QString summary, const QString text, QString previewBody, QString previewSummary, QString icon);
    Q_INVOKABLE void deleteDictionary(QString dict);
    Q_PROPERTY(QString inputMethod READ getInputMethod WRITE setInputMethod NOTIFY inputMethodChanged)

    QString getInputMethod() const;
    void setInputMethod(const QString &method);

    SuggestModel *m_suggestModel;
    DictListModel *m_availableDicts;

public slots:
    void availableDictsChanged(QModelIndex top, QModelIndex bottom);
    void downloadDone();
    void downloadError(QByteArray url, QString errorMsg);
    void downloadEnded(QByteArray url);
    void updateSuggestions();

signals:
    void inputMethodChanged(const QString &method);
    void queryChanged(const QString &query);

private:
    QThread *m_thread;
    Worker *m_worker;
    QString m_lastTranslation;
    DownloadManager *m_downloadManager;
    QString m_inputMethod;

    void updateDictCatalogue();
};

#endif // SIDUDICTLIB_H
