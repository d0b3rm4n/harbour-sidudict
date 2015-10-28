#include "worker.h"
#include "logging.h"

Worker::Worker(QObject *parent) :
    QObject(parent), m_cancelFlag(false)
{
    m_sd = new StarDict(this);
}

Worker::~Worker()
{
    delete m_sd;
}

void Worker::updateList(const QString &str)
{
    IN;
    m_cancelFlag = false;
    QList<EntryDictItem*> wordList;

    if (str.size() >= 3){
        foreach (QString dict, m_sd->availableDicts()) {
            QList<EntryDictItem*> tmpWordList;
            foreach(QString entry, m_sd->findSimilarWords(dict, str.simplified())){
                EntryDictItem *item =  new EntryDictItem(entry, dict);
                tmpWordList.append(item);
                if (m_cancelFlag) {
                    m_cancelFlag = false;
                    return;
                }
            }
            wordList.append(tmpWordList);
        }
    }

    foreach (QString dict, m_sd->availableDicts()) {
        QList<EntryDictItem*> tmpWordList;
        foreach(QString entry, m_sd->findWords(dict, str.simplified())){
            EntryDictItem *item =  new EntryDictItem(entry, dict);
            tmpWordList.prepend(item);
            if (m_cancelFlag) {
                m_cancelFlag = false;
                return;
            }
        }
        wordList.append(tmpWordList);
    }
    if (m_cancelFlag) {
        m_cancelFlag = false;
        return;
    }
    setSuggestions(wordList);
    emit suggestionsUpdated();
}

void Worker::cancelUpdating()
{
    if (!m_cancelFlag)
        m_cancelFlag = true;
}

void Worker::getSuggestions(QList<EntryDictItem *> &map)
{
    setSuggestions(map);
}

void Worker::setSuggestions(QList<EntryDictItem *> &map)
{
    IN;
    while (!m_suggestionsLock.testAndSetAcquire(0, 1)) {
        usleep(1000);
    }
    m_suggestions.swap(map);
    m_suggestionsLock = 0;
}

bool Worker::isTranslatable(const QString &dict, const QString &entry)
{
    IN;
    return m_sd->isTranslatable(dict, entry);
}

StarDict::Translation Worker::translate(const QString &dict, const QString &entry)
{
    IN;
    return m_sd->translate(dict, entry);
}
