import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "carlosbaraza.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var workspace = values[i]
      var name = String(workspace.name)
      if (name === "special" || name.indexOf("special:") === 0) continue
      if (workspace.toplevels.values.length > 0) ids.push(workspace.id)
    }

    ids.sort(function(left, right) {
      if (left > 0 && right > 0) return left - right
      if (left > 0) return -1
      if (right > 0) return 1
      return String(workspaceById(left).name).localeCompare(String(workspaceById(right).name))
    })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    var workspace = workspaceById(id)
    if (!workspace) return
    var selector = id > 0 ? String(id) : "name:" + workspace.name
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = " + JSON.stringify(selector) + " })"))
  }

  readonly property var visibleWorkspaceIds: workspaceIds()
  visible: visibleWorkspaceIds.length > 0
  readonly property real trailingGap: root.vertical || visibleWorkspaceIds.length === 0 ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : Math.max(1, root.visibleWorkspaceIds.length)
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.visibleWorkspaceIds

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : (workspace ? workspace.name : String(modelData))
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
