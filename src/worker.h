#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <lib/stardict.h>
#include <entrydictitem.h>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = 0);
    virtual ~Worker();

    // these are to be called synchronously
    void cancelUpdating();
    void getSuggestions(QList<EntryDictItem*> &map);
    bool isTranslatable(const QString &dict, const QString &entry);
    StarDict::Translation translate(const QString &dict, const QString &entry);

    StarDict &dictionary() {
        return *m_sd;
    }

signals:
    void suggestionsUpdated();

public slots:
    void updateList(const QString &query);

private:
    void setSuggestions(QList<EntryDictItem*> &map);

    StarDict *m_sd;
    bool m_cancelFlag;
    QAtomicInt m_suggestionsLock;
    QList<EntryDictItem*> m_suggestions;
};

#endif // WORKER_H
