/***************************************************************************

    sidudictlib.cpp - Sidudict, a StarDict clone based on QStarDict
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

#include <QDebug>
#include <QString>
#include <QStringListModel>
#include <QMultiHash>
#include <QModelIndex>
#include <QSettings>
#include <QFile>
#include <QtDBus/QtDBus>

#include <logging.h>

#include "sidudictlib.h"
#include "dictlistmodel.h"
#include "suggestmodel.h"
#include "lib/stardict.h"
#include "entrydictitem.h"
#include "downloadmanager.h"

SiduDictLib::SiduDictLib()
{
    IN;
    QSettings settings("harbour-sidudict","dictionary-settings");
    QMap<QString, QVariant> dictListSettings = settings.value("Sidudict/dictListSettings", QMap<QString, QVariant>()).toMap();

    // handle old settings from 0.1-2
    bool oldSettingsImported = false;
    QSettings oldSettings("harbour-sidudict","harbour-sidudict");
    QFile oldSettingsFile(oldSettings.fileName());
    if (oldSettingsFile.exists()){
        LOG() << "old Settings exists:" << oldSettings.fileName();
        QStringList oldSelectedDictList = oldSettings.value("Sidudict/selectedDictList", QStringList()).toStringList();
        foreach (const QString &dict, oldSelectedDictList) {
            dictListSettings.insert(dict, QVariant(true));
        }
        settings.setValue("Sidudict/dictListSettings", QVariant(dictListSettings));
        settings.sync();
        oldSettingsImported = true;
        if (oldSettingsFile.remove()) {
            LOG() << "removed old settings file";
        } else {
            LOG() << "could not remove old settings file:" << oldSettingsFile.errorString();
        }
    }

    QString oldCachePath = QDir::homePath() + QString("/.cache/sdcv");
    QString newCachePath = QDir::homePath() + QString("/.cache/harbour-sidudict");
    QFile oldCache(oldCachePath);
    if(oldCache.exists()){
        LOG () << oldCachePath << "exists, needs to be renamed to: " << newCachePath;
        oldCache.rename(oldCachePath, newCachePath);
    }

    m_lastTranslation = QString("No lookups yet...");

    m_sd = new StarDict(this);
    m_suggestModel = new SuggestModel();
    QList<EntryDictItem*> emptyWordList;
    emptyWordList.clear();
    m_suggestModel->setSuggestMap(emptyWordList);

    m_availableDicts = new DictListModel();

    connect(m_availableDicts,
            SIGNAL(dataChanged(QModelIndex,QModelIndex)),
            this,
            SLOT(availableDictsChanged(QModelIndex,QModelIndex)));


    QMap<QString, QVariant> map;

    LOG() << "available dicts" << m_sd->availableDicts();
    foreach(QString dict, m_sd->availableDicts()){
        if (dictListSettings.empty()) {
            map.insert(dict, QVariant(true));
        } else {
            if (dictListSettings.contains(dict)) {
                map.insert(dict, dictListSettings.value(dict));
            } else {
                if (oldSettingsImported) {
                    map.insert(dict, QVariant(false));
                } else {
                    map.insert(dict, QVariant(true));
                }
            }
        }
    }
    m_availableDicts->setDictMap(map);

    LOG() << "loaded dicts" << m_sd->loadedDicts();

    foreach (QString dict, m_sd->availableDicts()) {
        LOG() << m_sd->dictInfo(dict).name();
        LOG() << m_sd->dictInfo(dict).author();
        LOG() << m_sd->dictInfo(dict).description();
        LOG() << m_sd->dictInfo(dict).ifoFileName();
        LOG() << m_sd->dictInfo(dict).wordsCount();
    }

    m_downloadManager = new DownloadManager();

    connect(m_downloadManager,
            SIGNAL(done()),
            this,
            SLOT(downloadDone()));

    connect(m_downloadManager,
            SIGNAL(downloadFailed(QByteArray, QString)),
            this,
            SLOT(downloadError(QByteArray, QString)));

    connect(m_downloadManager,
            SIGNAL(downloadEnded(QByteArray)),
            this,
            SLOT(downloadEnded(QByteArray)));
}

SiduDictLib::~SiduDictLib()
{
    IN;
    QSettings settings("harbour-sidudict","dictionary-settings");
    settings.setValue("Sidudict/dictListSettings", QVariant(m_availableDicts->dictListMap()));
    settings.sync();
    delete m_sd;
}

void SiduDictLib::updateList(QString str){
    IN;

    QList<EntryDictItem*> wordList;
    wordList.clear();

    if (str.isEmpty()){
        m_suggestModel->setSuggestMap(wordList);
    } else {

        if (str.size() >= 3){
            foreach (QString dict, m_sd->availableDicts()) {
                QList<EntryDictItem*> tmpWordList;
                foreach(QString entry, m_sd->findSimilarWords(dict, str.simplified())){
                    EntryDictItem *item =  new EntryDictItem(entry, dict);
                    tmpWordList.append(item);
                }
                wordList.append(tmpWordList);
            }
        }

        foreach (QString dict, m_sd->availableDicts()) {
            QList<EntryDictItem*> tmpWordList;
            foreach(QString entry, m_sd->findWords(dict, str.simplified())){
                EntryDictItem *item =  new EntryDictItem(entry, dict);
                tmpWordList.prepend(item);
            }
            wordList.append(tmpWordList);
        }

        m_suggestModel->setSuggestMap(wordList);
    }
}

QString SiduDictLib::getTranslation(QString entry, QString dict)
{
    IN;
    LOG() << "getTranslation for:" << entry;
    LOG() << "getTranslation in:" << dict;

    if (m_sd->isTranslatable(dict, entry.simplified())) {
        m_lastTranslation = m_sd->translate(dict, entry.simplified()).translation();
        return m_lastTranslation;
    }

    return QString();
}

bool SiduDictLib::isFirstListItemTranslatable()
{
    IN;
    return m_sd->isTranslatable(m_suggestModel->firstDict(), m_suggestModel->firstEntry());
}

void SiduDictLib::setSelectDict(int index, bool value)
{
    IN;
    m_availableDicts->setSelectDict(index, value);
}

QString SiduDictLib::firstListItemDict()
{
    IN;
    return m_suggestModel->firstDict();
}

QString SiduDictLib::firstListItemEntry()
{
    IN;
    return m_suggestModel->firstEntry();
}

QString SiduDictLib::lastTranslation()
{
    IN;
    return m_lastTranslation;
}

QString SiduDictLib::dictInfoAuthor(QString dict)
{
    IN;
    return m_sd->dictInfo(dict).author();
}

QString SiduDictLib::dictInfoDescription(QString dict)
{
    IN;
    return m_sd->dictInfo(dict).description();
}

QString SiduDictLib::dictInfoWordsCount(QString dict)
{
    IN;
    return QString::number(m_sd->dictInfo(dict).wordsCount());
}

void SiduDictLib::downloadDict(QString url)
{
    IN;
    m_downloadManager->doDownload(QUrl(url));
}

void SiduDictLib::availableDictsChanged(QModelIndex top, QModelIndex bottom)
{
    IN;
    Q_UNUSED(top);
    Q_UNUSED(bottom);

    LOG() << "selected dicts" << m_availableDicts->selectedDictList();
    m_sd->setLoadedDicts(m_availableDicts->selectedDictList());
}

void SiduDictLib::downloadDone()
{
    IN;
    LOG() << "all downloads finished";

//    showNotification("x-fi.rmz.sidudict.download",
//                     "All Sidudict downloads finished.",
//                     "All queued downloads for Sidudict finished.",
//                     "All downloads finished.",
//                     "All Sidudict downloads finished.",
//                     "icon-s-update");
}

void SiduDictLib::downloadError(QByteArray url, QString errorMsg)
{
    IN;
    LOG() << "Download Error:" << url;
    showNotification("x-fi.rmz.sidudict.download",
                     "Sidudict download failed!",
                     "Failed to download: " + url + " Error: " + errorMsg,
                     "Sidudict download failed!",
                     "A Sidudict file could not be downloaded!",
                     "icon-system-warning");
}

void SiduDictLib::downloadEnded(QByteArray url)
{
    IN;
    LOG() << "Download Ended:" << url;
    showNotification("x-fi.rmz.sidudict.download",
                     "Sidudict download finished!",
                     url,
                     "Sidudict download finished!",
                     url,
                     "icon-s-update");

    updateDictCatalogue();
}

void SiduDictLib::updateDictCatalogue()
{
    IN;
    QMap<QString, QVariant> newMap;
    QMap<QString, QVariant> currentMap = m_availableDicts->dictListMap();

    LOG() << "available dicts" << m_sd->availableDicts();
    foreach(QString dict, m_sd->availableDicts()){
        if (currentMap.contains(dict)) {
            newMap.insert(dict, currentMap.value(dict));
        } else {
            newMap.insert(dict, QVariant(true));
        }
    }
    m_availableDicts->setDictMap(newMap);

    LOG() << "loaded dicts" << m_sd->loadedDicts();

}

bool SiduDictLib::showNotification(const QString category,
                                   const QString summary,
                                   const QString text,
                                   const QString previewSummary,
                                   const QString previewBody,
                                   const QString icon)
{
    IN;
    QVariantMap hints;
    hints.insert("category", category);
    hints.insert("x-nemo-preview-body", previewBody);
    hints.insert("x-nemo-preview-summary", previewSummary);
    QList<QVariant> argumentList;
    argumentList << "Sidudict";    //app_name
    argumentList << (uint)0;       // replace_id
    argumentList << icon;          // app_icon
    argumentList << summary;       // summary
    argumentList << text;          // body
    argumentList << QStringList(); // actions
    argumentList << hints;         // hints
    argumentList << (int)5000;     // timeout in ms

  static QDBusInterface notifyApp("org.freedesktop.Notifications",
                                  "/org/freedesktop/Notifications",
                                  "org.freedesktop.Notifications");
  QDBusMessage reply = notifyApp.callWithArgumentList(QDBus::AutoDetect,
                                                      "Notify", argumentList);

  if(reply.type() == QDBusMessage::ErrorMessage) {
    LOG() << "D-Bus Error:" << reply.errorMessage();
    return false;
  }
  return true;
}

void SiduDictLib::deleteDictionary(QString dict)
{
    IN;
    QFileInfo ifoFile(m_sd->dictInfo(dict).ifoFileName());

    QDir ifoFileDir = ifoFile.absoluteDir();
    QString ifoFileDirName = ifoFileDir.path();
    QString ifoFileName = ifoFile.fileName();

    QString idxFileName = ifoFile.baseName();
    idxFileName.append(".idx");

    QString dictFileName = ifoFile.baseName();
    dictFileName.append(".dict");

    QString dictDzFileName = ifoFile.baseName();
    dictDzFileName.append(".dict.dz");

    QString oftFileName = ifoFile.baseName();
    oftFileName.append(".idx.oft");

    LOG() << "ifoFileName" << ifoFileName;
    LOG() << "idxFileName" << idxFileName;
    LOG() << "dictDzFileName" << dictDzFileName;
    LOG() << "dictFileName" << dictFileName;
    LOG() << "oftFileName" << oftFileName;
    LOG() << "ifoFileDirName" << ifoFileDirName;

    ifoFileDir.remove(ifoFileName);
    ifoFileDir.remove(idxFileName);
    ifoFileDir.remove(dictDzFileName);
    ifoFileDir.remove(dictFileName);
    ifoFileDir.remove(oftFileName);
    ifoFileDir.rmdir(ifoFileDir.absolutePath());

    if (ifoFile.exists()){
        LOG() << "Dictionary removing failed!" << dict;
        showNotification("x-fi.rmz.sidudict.delete",
                         "Dictionary removing failed!",
                         dict,
                         "Dictionary removing failed!",
                         dict,
                         "");
    } else {
        LOG() << "Dictionary removed!" << dict;
        showNotification("x-fi.rmz.sidudict.delete",
                         "Dictionary removed!",
                         dict,
                         "Dictionary removed!",
                         dict,
                         "");
    }
    updateDictCatalogue();
}
