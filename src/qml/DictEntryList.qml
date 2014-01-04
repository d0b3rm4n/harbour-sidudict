import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: dictEntryList

    Component {
        id: dictModelDelegate
        ListItem{
            onClicked: {
//                console.log("Clicked: " + name + " - " + index);
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
//                        console.log("Details clicked");
                        pageStack.push(Qt.resolvedUrl("DictDetails.qml"),{dictionaryName: name})
                    }
                }
            }
        }
    }

    SilicaListView{
        anchors.fill: parent
        model: availableDictListModel
        delegate: dictModelDelegate
        spacing: Theme.paddingSmall
    }
}
