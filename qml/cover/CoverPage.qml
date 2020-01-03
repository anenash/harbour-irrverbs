import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        width: parent.width
        wrapMode: "WordWrap"
        horizontalAlignment: "AlignHCenter"
        text: qsTr("Irregular verbs")
    }

//    CoverActionList {
//        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-next"
//        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-pause"
//        }
//    }
}
