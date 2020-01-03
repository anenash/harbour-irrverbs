#ifndef DATA_H
#define DATA_H

#include <QObject>
#include <QJsonObject>
#include <QQmlListProperty>

class DataModel: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString present READ present NOTIFY presentChanged)
    Q_PROPERTY(QString past READ past NOTIFY pastChanged)
    Q_PROPERTY(QString participles READ participles NOTIFY participlesChanged)

public:
    explicit DataModel(const QString& present, const QString& past, const QString& participles);

    QString present() const { return m_present; }
    QString past() const { return m_past; }
    QString participles() const { return m_participles; }

signals:
    void presentChanged(QString result);
    void pastChanged(QString result);
    void participlesChanged(QString result);

private:
    QString m_present;
    QString m_past;
    QString m_participles;
};

class Data : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<DataModel> verbsModel READ verbsModel NOTIFY verbsModelChanged)
    Q_PROPERTY(QQmlListProperty<DataModel> searchVerbs READ searchVerbs NOTIFY searchVerbsChanged)
    Q_PROPERTY(QQmlListProperty<DataModel> testModel READ testModel NOTIFY testModelChanged)
public:
    explicit Data(QObject *parent = nullptr);

    QQmlListProperty<DataModel> verbsModel() { return QQmlListProperty<DataModel>(this, m_verbs); }
    QQmlListProperty<DataModel> searchVerbs() { return QQmlListProperty<DataModel>(this, m_searchVerbs); }
    QQmlListProperty<DataModel> testModel() { return QQmlListProperty<DataModel>(this, m_testVerbs); }

    Q_INVOKABLE void getTestData(const int count);
    Q_INVOKABLE void searchData(const QString& value);

signals:
    void verbsModelChanged(QList<DataModel *> result);
    void searchVerbsChanged(QList<DataModel *> result);
    void testModelChanged(QList<DataModel *> result);

public slots:
private:
    QList<DataModel *> m_verbs;
    QList<DataModel *> m_searchVerbs;
    QList<DataModel *> m_testVerbs;
};

#endif // DATA_H
