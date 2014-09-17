/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3
import U1db 1.0 as U1db
import Location 1.0 as UserLocation
import QtPositioning 5.2
import Ubuntu.Components 1.1
import "../components"
import "../upstreamcomponents"
import "../worldclock"

PageWithBottomEdge {
    id: _clockPage
    objectName: "clockPage"

    // Property to keep track of the clock mode
    property alias isDigital: clock.isDigital

    flickable: null

    PositionSource {
        id: geoposition

        // Property to store the time of the last GPS location update
        property var lastUpdate

        readonly property real userLongitude: position.coordinate.longitude.
        toString().slice(0, Math.min(position.coordinate.longitude.toString().length, 7))

        readonly property real userLatitude: position.coordinate.latitude.
        toString().slice(0, Math.min(position.coordinate.longitude.toString().length, 6))

        active: true
        updateInterval: 1000

        onSourceErrorChanged: {
            if(sourceError === PositionSource.AccessError) {
                console.log("[Source Error]: Do not have permissions to access location service")
            } else if(sourceError === PositionSource.ClosedError) {
                console.log("[Source Error]: Location services have been disabled")
            } else if(sourceError === PositionSource.NoError) {
                console.log("[Source Error]: No Error! Everything is fine ;)")
            } else if(sourceError === PositionSource.UnknownSourceError) {
                console.log("[Source Error]: Unknown Error")
            }
        }

        onPositionChanged: {
            if(!position.longitudeValid || !position.latitudeValid) {
                return
            }

            if (userLongitude === userLocationDocument.contents.long ||
                    userLatitude === userLocationDocument.contents.lat) {
                if (geoposition.active) {
                    geoposition.stop()
                }
                return
            }

            else {
                userLocation.source = String("%1%2%3%4%5")
                .arg("http://api.geonames.org/findNearbyPlaceNameJSON?lat=")
                .arg(position.coordinate.latitude)
                .arg("&lng=")
                .arg(position.coordinate.longitude)
                .arg("&username=krnekhelesh&style=full")
            }
        }
    }

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            if(geoposition.sourceError === PositionSource.AccessError) {
                console.log("[Source Error]: Do not have permissions to access location service")
            } else if(geoposition.sourceError === PositionSource.ClosedError) {
                console.log("[Source Error]: Location services have been disabled")
            } else if(geoposition.sourceError === PositionSource.NoError) {
                console.log("[Source Error]: No Error! Everything is fine ;)")
            } else if(geoposition.sourceError === PositionSource.UnknownSourceError) {
                console.log("[Source Error]: Unknown Error")
            }

            if(applicationState
                    && Math.abs(clock.analogTime - geoposition.lastUpdate) > 1800000) {
                if(!geoposition.active)
                    geoposition.start()
            }

            else if (!applicationState) {
                geoposition.lastUpdate = clock.analogTime
            }
        }
    }

    UserLocation.Location {
        id: userLocation
        onLocationChanged: {
            var locationData = JSON.parse
                    (JSON.stringify(userLocationDocument.contents))
            locationData.lat = geoposition.position.coordinate.latitude.toString().slice(0, Math.min(geoposition.position.coordinate.longitude.toString().length, 6))
            locationData.long = geoposition.position.coordinate.longitude.toString().slice(0, Math.min(geoposition.position.coordinate.longitude.toString().length, 7))
            locationData.location = userLocation.location
            userLocationDocument.contents = locationData

            if(geoposition.active) {
                geoposition.stop()
            }

        }
    }

    Flickable {
        id: _flickable

        Component.onCompleted: otherElementsStartUpAnimation.start()

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height
                       + worldCityColumn.height + addWorldCityButton.height
                       + units.gu(16)

        AbstractButton {
            id: settingsIcon
            objectName: "settingsIcon"

            onClicked: {
                mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
            }

            width: units.gu(5)
            height: width
            opacity: 0

            anchors {
                top: parent.top
                topMargin: units.gu(6)
                right: parent.right
                rightMargin: units.gu(2)
            }

            Rectangle {
                visible: settingsIcon.pressed
                anchors.fill: parent
                color: Theme.palette.selected.background
            }

            Icon {
                width: units.gu(3)
                height: width
                anchors.centerIn: parent
                name: "settings"
                color: "Grey"
            }
        }

        MainClock {
            id: clock
            objectName: "clock"

            Component.onCompleted: {
                geoposition.lastUpdate = analogTime
            }

            anchors {
                verticalCenter: parent.top
                verticalCenterOffset: units.gu(20)
                horizontalCenter: parent.horizontalCenter
            }
        }

        Label {
            id: date

            anchors {
                top: parent.top
                topMargin: units.gu(36)
                horizontalCenter: parent.horizontalCenter
            }

            text: clock.analogTime.toLocaleDateString()
            opacity: settingsIcon.opacity
            fontSize: "xx-small"
        }

        Row {
            id: locationRow
            objectName: "locationRow"

            opacity: settingsIcon.opacity
            spacing: units.gu(1)

            anchors {
                top: date.bottom
                topMargin: units.gu(1)
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: locationIcon
                source: "../graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                objectName: "location"
                fontSize: "medium"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine

                text: {
                    if (userLocationDocument.contents.location === "Null") {
                        return i18n.tr("Retrieving location...")
                    }

                    else {
                        return userLocationDocument.contents.location
                    }
                }
            }
        }

        UserWorldCityList {
            id: worldCityColumn
            objectName: "worldCityColumn"

            opacity: settingsIcon.opacity
            anchors {
                top: locationRow.bottom
                topMargin: units.gu(4)
            }
        }

        AddWorldCityButton {
            id: addWorldCityButton

            opacity: settingsIcon.opacity
            anchors {
                top: worldCityColumn.bottom
                topMargin: units.gu(1)
                horizontalCenter: parent.horizontalCenter
            }
        }

        ParallelAnimation {
            id: otherElementsStartUpAnimation

            PropertyAnimation {
                target: settingsIcon
                property: "anchors.topMargin"
                from: units.gu(6)
                to: units.gu(2)
                duration: 900
            }

            PropertyAnimation {
                target: settingsIcon
                property: "opacity"
                from: 0
                to: 1
                duration: 900
            }

            PropertyAnimation {
                target: date
                property: "anchors.topMargin"
                from: units.gu(36)
                to: units.gu(40)
                duration: 900
            }
        }
    }
}
