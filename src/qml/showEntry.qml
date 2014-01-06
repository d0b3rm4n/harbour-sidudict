import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property string pageTitleEntry
    property string dictTranslatedEntry

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader { title: pageTitleEntry }
            Label {
                id: translation
                property int minimumPointSize: Theme.fontSizeExtraSmall
                property int maximumPointSize: Theme.fontSizeExtraLarge
                property int currentPointSize: Theme.fontSizeMedium
                text: dictTranslatedEntry
                anchors {left: parent.left; right: parent.right}
                anchors.margins: Theme.paddingMedium
                wrapMode: Text.WordWrap
                font.pointSize: translation.currentPointSize
                color: Theme.primaryColor
                textFormat: Text.RichText

                PinchArea {
                    anchors.fill: parent
                    onPinchUpdated: {
                        var desiredSize = pinch.scale * translation.currentPointSize;
                        if(desiredSize >= translation.minimumPointSize && desiredSize <= translation.maximumPointSize)
                            translation.font.pointSize = desiredSize
                        else if (desiredSize < translation.minimumPointSize)
                            translation.font.pointSize = translation.minimumPointSize
                        else if (desiredSize > translation.maximumPointSize)
                            translation.font.pointSize = translation.maximumPointSize
                    }
                    onPinchFinished: {
                        var desiredSize = pinch.scale * translation.currentPointSize;
                        if(desiredSize >= translation.minimumPointSize && desiredSize <= translation.maximumPointSize)
                            translation.currentPointSize = desiredSize
                        else if (desiredSize < translation.minimumPointSize)
                            translation.currentPointSize = translation.minimumPointSize
                        else if (desiredSize > translation.maximumPointSize)
                            translation.currentPointSize = translation.maximumPointSize

                        translation.font.pointSize = translation.currentPointSize;
                    }
                }
            }
        }
    }
}
