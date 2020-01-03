import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait

    ConfigurationValue {
        id: numberOfWords

        key: "/numberOfWords"
        defaultValue: 10
    }

    ConfigurationValue {
        id: typeOfTest

        key: "/typeOfTest"
        defaultValue: 0
    }

    ConfigurationValue {
        id: timerForTest

        key: "/timerForTest"
        defaultValue: false
    }

    ConfigurationValue {
        id: secondsForTest

        key: "/secondsForTest"
        defaultValue: 60
    }

    Column {
        anchors.fill: parent
        spacing: Theme.paddingSmall

        PageHeader {
            title: qsTr("Settings")
        }


        Slider {
            width: parent.width
            minimumValue: 5
            maximumValue: 20
            stepSize: 1
            handleVisible: true
            label: qsTr("Words count for test")
            value: numberOfWords.value
            valueText: value

            onValueTextChanged:  {
                numberOfWords.value = valueText
            }
        }

        ComboBox {
            width: parent.width
            label: qsTr("Test level")

            currentIndex: typeOfTest.value

            menu: ContextMenu {
                MenuItem { text: qsTr("Easy") }
                MenuItem { text: qsTr("Normal") }
                MenuItem { text: qsTr("Hard"); enabled: false }
            }

            onCurrentIndexChanged: {
                typeOfTest.value = currentIndex
            }
        }

        TextSwitch {
            id: timer

            text: qsTr("Switch on timer")
            checked: timerForTest.value

            onCheckedChanged: {
                timerForTest.value = checked
            }
        }

        Slider {
            width: parent.width
            enabled: timer.checked
            minimumValue: 30
            maximumValue: 300
            stepSize: 1
            handleVisible: true
            value: secondsForTest.value
            valueText: timer.checked ? value + qsTr(" sec") : ""

            onValueChanged: {
                secondsForTest.value = value
            }
        }
    }
}
