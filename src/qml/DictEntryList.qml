import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: dictEntryList

    Component {
        id: dictModelDelegate
        ListItem{
//            contentHeight: Theme.itemSizeMedium // two line delegate
            onClicked: {
                console.log("Clicked: " + name + " - " + index);
                dictSwitch.checked = dictSwitch.checked ? false : true;
                starDictLib.setSelectDict(index, dictSwitch.checked);
            }
            Row {
                Switch {
                    id: dictSwitch
                    checked: selected
                }
                Label {
                    id: dictlabel
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.primaryColor
                }
            }
            menu: ContextMenu {
                MenuItem {
                    text: "Details"
                    onClicked: {
                        console.log("Details clicked");
                        pageStack.push(Qt.resolvedUrl("DictDetails.qml"),{dictionaryName: name})
                    }
                }
            }
        }
//        TextSwitch {
//            automaticCheck: false
//            id: activationSwitch
//            text: name
//            checked: selected
//            onClicked: {
//                console.log("Clicked: " + text + " - " + index)
//                activationSwitch.checked = activationSwitch.checked ? false : true
//                starDictLib.setSelectDict(index, checked);
//            }
//        }
    }

    SilicaListView{
        anchors.fill: parent
        model: availableDictListModel
        delegate: dictModelDelegate
        spacing: Theme.paddingSmall
    }
}
