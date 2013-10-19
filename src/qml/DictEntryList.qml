import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: dictEntryList

    Component {
        id: dictModelDelegate
        TextSwitch {
            automaticCheck: false
            id: activationSwitch
            text: name
            checked: selected
            onClicked: {
                console.log("Clicked: " + text + " - " + index)
                activationSwitch.checked = activationSwitch.checked ? false : true
                starDictLib.setSelectDict(index, checked);
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
