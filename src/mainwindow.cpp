/***************************************************************************

    mainwindow.cpp - Sidudict, a StarDict clone based on QStarDict
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

#include <QDebug>
#include <QLineEdit>

#include "mainwindow.h"
#include "lib/stardict.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    m_sd = new StarDict(this);
    qDebug() << m_sd->name();
    qDebug() << m_sd->availableDicts();
    qDebug() << m_sd->loadedDicts();
    m_sd->setLoadedDicts(m_sd->availableDicts());
    qDebug() << m_sd->loadedDicts();
    qDebug() << m_sd->translate(m_sd->availableDicts().at(1),"kissa").translation();
    qDebug() << m_sd->translate(m_sd->availableDicts().at(1),"kissa").title();
    qDebug() << m_sd->translate(m_sd->availableDicts().at(1),"kissa").dictName();
    qDebug() << m_sd->findSimilarWords(m_sd->availableDicts().at(1),"kiss");

    m_input = new QLineEdit();

    connect(m_input,
            SIGNAL(textChanged(QString)),
            this,
            SLOT(updateList(QString)));

    setCentralWidget(m_input);
}

MainWindow::~MainWindow()
{

}

void MainWindow::updateList(QString str){
    qDebug() << "updateList:" << str;

    QStringList results;

    foreach (QString dict, m_sd->availableDicts()) {
        qDebug() << m_sd->findSimilarWords(dict, str.simplified());
        results.append(m_sd->findSimilarWords(dict, str.simplified()));
        qDebug() << m_sd->isTranslatable(dict, str.simplified());
        if (m_sd->isTranslatable(dict, str.simplified())) {
            qDebug() << m_sd->translate(dict,str.simplified()).translation();
        }
    }

    results.sort();
    qDebug() << "results:" << results;
}
