// CornerThingy mk2 by SealEgg
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property color color: "#000000"
    property int cornerHeight: 30
    property var cornerType: "cubic" // cubic, rounded or inverted
    property int cornerWidth: cornerHeight // default is square, but you can set a separate width

    property var corners: [0] // 0 is top right, 1 is top left, 2 is bottom left, 3 is bottom right

    anchors.fill: parent

    Repeater {
        model: root.cornerType === "cubic" ? root.corners : 0

        delegate: Shape {
            id: cubicShape

            property int currentCorner: modelData

            anchors.bottom: currentCorner > 1 ? root.bottom : undefined
            anchors.left: currentCorner === 1 || currentCorner === 2 ? root.left : undefined
            anchors.right: currentCorner === 0 || currentCorner === 3 ? root.right : undefined
            anchors.top: currentCorner <= 1 ? root.top : undefined
            asynchronous: true
            implicitHeight: root.cornerHeight
            implicitWidth: root.cornerWidth
            preferredRendererType: Shape.CurveRenderer

            transform: Rotation {
                angle: currentCorner > 1 ? 180 : 0
                origin.x: root.cornerWidth / 2
                origin.y: root.cornerHeight / 2
            }

            ShapePath {
                fillColor: root.color
                startX: cubicShape.currentCorner % 2 === 0 ? 0 : root.cornerWidth
                startY: 0
                strokeWidth: 0

                PathCubic {
                    relativeControl1X: cubicShape.currentCorner % 2 === 0 ? root.cornerWidth / 2 : -root.cornerWidth / 2
                    relativeControl1Y: 0
                    relativeControl2X: cubicShape.currentCorner % 2 === 0 ? root.cornerWidth / 2 : -root.cornerWidth / 2
                    relativeControl2Y: root.cornerHeight
                    x: cubicShape.currentCorner % 2 === 0 ? root.cornerWidth : 0
                    y: root.cornerHeight
                }
                PathLine {
                    x: cubicShape.currentCorner % 2 === 0 ? root.cornerWidth : 0
                    y: 0
                }
            }
        }
    }
    Repeater {
        model: root.cornerType === "rounded" ? root.corners : 0

        delegate: Shape {
            id: roundedShape

            property int currentCorner: modelData

            anchors.bottom: currentCorner > 1 ? root.bottom : undefined
            anchors.left: currentCorner === 1 || currentCorner === 2 ? root.left : undefined
            anchors.right: currentCorner === 0 || currentCorner === 3 ? root.right : undefined
            anchors.top: currentCorner <= 1 ? root.top : undefined
            asynchronous: true
            implicitHeight: root.cornerHeight
            implicitWidth: root.cornerWidth
            preferredRendererType: Shape.CurveRenderer

            transform: Rotation {
                angle: currentCorner * -90
                origin.x: root.cornerWidth / 2
                origin.y: root.cornerHeight / 2
            }

            ShapePath {
                fillColor: root.color
                startX: 0
                startY: 0
                strokeWidth: -1

                PathLine {
                    x: root.cornerWidth
                    y: 0
                }
                PathLine {
                    x: root.cornerWidth
                    y: root.cornerHeight
                }
                PathArc {
                    radiusX: root.cornerWidth
                    radiusY: root.cornerHeight
                    x: 0
                    y: 0
                }
            }
        }
    }
    Repeater {
        model: root.cornerType === "inverted" ? root.corners : 0

        delegate: Shape {
            id: invertedShape

            property int currentCorner: modelData

            anchors.bottom: currentCorner > 1 ? root.bottom : undefined
            anchors.left: currentCorner === 1 || currentCorner === 2 ? root.left : undefined
            anchors.right: currentCorner === 0 || currentCorner === 3 ? root.right : undefined
            anchors.top: currentCorner <= 1 ? root.top : undefined
            asynchronous: true
            implicitHeight: root.cornerHeight
            implicitWidth: root.cornerWidth
            preferredRendererType: Shape.CurveRenderer

            transform: Rotation {
                angle: currentCorner * -90
                origin.x: root.cornerWidth / 2
                origin.y: root.cornerHeight / 2
            }

            ShapePath {
                fillColor: root.color
                startX: 0
                startY: 0
                strokeWidth: -1

                PathArc {
                    radiusX: root.cornerWidth
                    radiusY: root.cornerHeight
                    x: root.cornerWidth
                    y: root.cornerHeight
                }
                PathLine {
                    x: root.cornerWidth
                    y: 0
                }
            }
        }
    }
}
