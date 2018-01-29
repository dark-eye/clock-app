/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

import QtQuick 2.4
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0

/*
  Clock Circle with the shadows and background color set depending on the
  position of the circle.
 */
Circle {
    id: _innerCircle

    property bool isFoldVisible: true
    property bool useNightColors: false

    color: useNightColors ? nightColors.color : dayColors.color;
    borderWidth: units.dp(1)
    borderColorTop: useNightColors ? nightColors.borderColorTop : dayColors.borderColorTop;
    borderColorBottom: useNightColors ? nightColors.borderColorBottom : dayColors.borderColorBottom;
    borderOpacity: 0.65
    borderGradientPosition: 0.2

    Rectangle {
        visible: isFoldVisible
        anchors.fill: parent
        anchors.margins: borderWidth
        radius: height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: useNightColors ? nightColors.color : dayColors.color; }
            GradientStop { position: 0.5; color: useNightColors ? nightColors.color : dayColors.color; }
            GradientStop { position: 0.5; color: useNightColors ? nightColors.foldColor : dayColors.foldColor; }
            GradientStop { position: 1.0; color:  useNightColors ? nightColors.foldColor : dayColors.foldColor; }
        }
    }

    QtObject {
        id:nightColors
        property var color:UbuntuColors.ash
        property var borderColorTop:"#00000000"
        property var  borderColorBottom: "#6E6E6E"
        property var  foldColor: "#FDFDFD"
    }

    QtObject {
        id:dayColors
        property var color:UbuntuColors.porcelain
        property var borderColorTop:"#00000000"
        property var  borderColorBottom: "#6E6E6E"
        property var  foldColor: "#FDFDFD"
    }
}
