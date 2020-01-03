#include "data.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QMap>

#include <random>
#include <iostream>

#include <QDebug>

Data::Data(QObject *parent) : QObject(parent)
{
    QFile file(":/qml/pages/Verbs.json");
    file.open(QIODevice::ReadOnly);
    QJsonDocument d = QJsonDocument::fromJson(file.readAll());
    QStringList keys = d.object().keys();
    for (auto key : keys)
    {
        QJsonArray arr = d.object().value(key).toArray();
        m_verbs.append(new DataModel(arr.at(0).toString(), arr.at(1).toString(), arr.at(2).toString()));
    }
    emit verbsModelChanged(m_verbs);
}

void Data::getTestData(const int count/*, const int searchType*/)
{
    m_testVerbs.clear();

    std::random_device rd;  //Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
    std::uniform_int_distribution<> dis(0, m_verbs.count());

    QVector<int> keys;

    int key = dis(gen);
    for (int var = 0; var < count; ++var)
    {
        while( 1 )
        {
            if(!keys.contains(key))
            {
                keys.push_back(key);
                m_testVerbs.append(m_verbs.at(key));
                break;
            }
            key = dis(gen);
        }
    }
    emit testModelChanged(m_testVerbs);
}

void Data::searchData(const QString &value)
{
    m_searchVerbs.clear();
    for(auto item : m_verbs)
    {
        if(item->present().startsWith(value, Qt::CaseInsensitive))
        {
            m_searchVerbs.append(item);
        }
    }
    emit searchVerbsChanged(m_searchVerbs);
}

DataModel::DataModel(const QString &present, const QString &past, const QString &participles):
    m_present(present), m_past(past), m_participles(participles)
{
}
