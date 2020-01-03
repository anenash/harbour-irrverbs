import QtQuick 2.4
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import verbs.Info 1.0

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    ConfigurationValue {
        id: numberOfWords

        key: "/numberOfWords"
    }

    ConfigurationValue {
        id: timerForTest

        key: "/timerForTest"
    }

    ConfigurationValue {
        id: secondsForTest

        key: "/secondsForTest"
    }

    ConfigurationValue {
        id: typeOfTest

        key: "/typeOfTest"
        defaultValue: 0
    }

    ListModel {
        id: resultsModel
    }

    Component.onCompleted: {
        Info.getTestData(numberOfWords.value)
    }

    Connections {
        target: Info

        onTestModelChanged: {
            view.model = Info.testModel
        }
    }

    QtObject {
        id: internal

        property bool testIsActive: true
        property int rigthAnswers: 0
        property int timerInterval: secondsForTest.value
    }

    function check() {
        var ind = view.currentIndex
        switch(typeOfTest.value) {
        case 0:
            var tempText = resultsModel.get(ind).answerParticiples
            if(tempText.length < 1) {
                return
            } else {
                var p = resultsModel.get(ind).participles
                if(tempText === p) {
                    internal.rigthAnswers += 1
                }
            }

            break
        case 1:
            var answerParticiples = resultsModel.get(ind).answerParticiples
            var answerPast = resultsModel.get(ind).answerPast
            if(answerParticiples.length < 1 || answerPast.length < 1) {
                return
            } else {
                var participles = resultsModel.get(ind).participles
                var past = resultsModel.get(ind).past
                if(answerParticiples === participles && past === answerPast) {
                    internal.rigthAnswers += 1
                }
            }

            break
        case 2:
            return
        }

        if((ind + 1) === view.count) {
            internal.testIsActive = false
        }
        console.log("incrementCurrentIndex")
        view.incrementCurrentIndex()
    }

    Timer {
        id: timer

        running: timerForTest.value && internal.testIsActive
        interval:  1000
        repeat: true

        onTriggered: {
            internal.timerInterval -= 1
            if(internal.timerInterval <= 0) {
                internal.testIsActive = false
            }
        }
    }

    Column {
        anchors.fill: parent

        spacing: Theme.paddingMedium
        visible: internal.testIsActive

        PageHeader {
            title: qsTr("Score ") + internal.rigthAnswers + "/" + view.count
        }

        Slider {
            width: parent.width
            enabled: timer.running
            minimumValue: 0
            maximumValue: secondsForTest.value
            stepSize: 1
            value: internal.timerInterval
            visible: timerForTest.value
            valueText: value + qsTr(" sec")
        }

        SilicaListView {
            id: view

            width: page.width
            height: Theme.itemSizeHuge + Theme.itemSizeLarge
            clip: true
            interactive: false
            currentIndex: -1
            orientation: "Horizontal"

            visible: internal.testIsActive

            delegate: Column {
                width: page.width

                Component.onCompleted: {
                    console.log("index", index)
                    if(resultsModel.count >= index) {
                        console.log("add item", index)
                        resultsModel.set(index, {"present": present, "past": past, "participles": participles, "answerPast": "", "answerParticiples": ""})
                    }
                }

                TextField {
                    id: presentText

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: page.width
                    readOnly: true
                    font.bold: true
                    text: present
                }
                TextField {
                    id: pastText

                    property bool textIsSet: false

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: page.width
                    readOnly: typeOfTest.value !== 1
                    font.bold: true
                    placeholderText: qsTr("Put your answer here")
                    text: typeOfTest.value !== 1 ? past : ""


                    onTextChanged: {
                        if(internal.testIsActive && typeOfTest.value === 1 && text.length > 0) {
                            resultsModel.set(index, {"answerPast": text.toLocaleLowerCase().trim()})
                        }
                    }

                    EnterKey.onClicked: {
                        check()
                    }

                }
                TextField {
                    id: participlesText

                    property bool textIsSet: false

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: page.width
                    font.bold: true
                    placeholderText: qsTr("Put your answer here")

                    onTextChanged: {
                        if(internal.testIsActive) {
                            resultsModel.set(index, {"answerParticiples": text.toLocaleLowerCase().trim()})
                        }
                    }

                    EnterKey.onClicked: {
                        check()
                    }
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: internal.testIsActive
            visible: internal.testIsActive
            text: qsTr("Check")

            onClicked: {
                check()
            }
        }
    }

    ListView {
//        width: page.width
//        height: page.height
        anchors.fill: parent
        clip: true
        spacing: Theme.paddingSmall
        visible: !internal.testIsActive

        model: resultsModel
        delegate: ListItem {
            contentHeight: Theme.itemSizeLarge

            Text {
                id: presentItem

                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                font.bold: true
                color: Theme.primaryColor
                text: present
            }
            Text {
                id: pastItem

                anchors.top: presentItem.bottom
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                font.bold: true
                text: typeOfTest.value !== 1 ? past : past + " -> " + answerPast
                color: typeOfTest.value !== 1 ? Theme.primaryColor : past === answerPast ? "green" : "red"
            }
            Text {
                id: participlesItem

                anchors.top: pastItem.bottom
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                font.bold: true
                text: participles + "  ->  " + answerParticiples
                color: participles === answerParticiples ? "green" : "red"
            }

            Separator {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.bottom: parent.bottom
                width: parent.width
            }
        }
    }
}
