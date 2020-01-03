import QtQuick 2.4
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import verbs.Info 1.0

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

    Connections {
        target: Info

        onSearchVerbsChanged: {
            listView.model = Info.searchVerbs
        }
    }

    ListModel {
        id: thesaurusModel
    }

    function performRequest(word) {
        var request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    var parsed = JSON.parse(request.responseText)
                    for(var i in parsed.response) {
                        if (parsed.response[i].list.category === "(verb)") {
                            thesaurusModel.append({"synonym": parsed.response[i].list.synonyms})
                        }
                    }

                } else {
                    console.log("Error", request.responseText)
                    thesaurusModel.append({"synonym": qsTr("Error: ") + request.responseText})
                }
                panel.open = true
            }
        }
        thesaurusModel.clear()
        var url = "http://thesaurus.altervista.org/thesaurus/v1?word=" + word + "&language=en_US&key=i7YfiTadbI6uQvHmxzmG&output=json"
        request.open("GET", url)
        request.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0')
        request.setRequestHeader('Content-type', 'application/json')
        request.setRequestHeader('Accept-Encoding', 'gzip, deflate, bzip2, compress, sdch')
        request.send()
    }

    SilicaListView {
        id: listView

        anchors.fill: parent
        anchors.bottomMargin: panel.margin

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Check yourself")
                onClicked: pageStack.push(Qt.resolvedUrl("TestPage.qml"))
            }
        }

        header: SearchField {
            width: parent.width

            onTextChanged: {
                if(text == "") {
                    listView.model = Info.verbsModel
                } else {
                    Info.searchData(text)
                }
            }
        }

        model: Info.verbsModel

        delegate: ListItem {
            contentHeight: Theme.itemSizeExtraLarge
            anchors.margins: Theme.horizontalPageMargin

            SectionHeader {
                id: presentVerb

                text: present
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: TextInput.AlignLeft
            }

            Text {
                anchors.top: presentVerb.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                font.bold: true
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: "AlignHCenter"

                text: past + "    " + participles
                color: Theme.secondaryColor
            }

            Separator {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.bottom: parent.bottom
                width: parent.width

                color: Theme.primaryColor
            }

            onClicked: {
                panel.open = false
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Find synonyms")
                    onClicked: performRequest(present)
                }
            }
        }
    }

    DockedPanel {
        id: panel

        width: parent.width
        height: Theme.itemSizeExtraLarge + Theme.itemSizeExtraLarge + Theme.paddingLarge

        opacity: 1.0
        dock: Dock.Bottom

        BackgroundItem {
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                color: Theme.highlightColor
            }
        }

        ListView {
            anchors.fill: parent
            model: thesaurusModel
            clip: true

            delegate: Label {
                width: parent.width
                text: synonym
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.horizontalPageMargin
                horizontalAlignment: "AlignJustify"
                wrapMode: Text.WordWrap
                Separator {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.width

                    color: Theme.primaryColor
                }
            }
        }
    }
}
