import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root
    property var desktopEntries: DesktopEntries.applications.values
    property var apps: []
    property int selected: 0
    property int pendingSteps: 0
    property bool loading: false
    property bool cancelled: false
    property bool commitPending: false
    property bool opened: false

    function advance(step) {
        if (opened) {
            selected = (selected + step + apps.length) % apps.length;
        } else if (loading) {
            pendingSteps += step;
        } else {
            pendingSteps = step;
            cancelled = false;
            commitPending = false;
            loading = true;
            query.running = true;
        }
    }
    function resetKeyboard() {
        Quickshell.execDetached(["hyprctl", "eval", 'if hl.get_current_submap() == "mac-switcher" then hl.dispatch(hl.dsp.submap("reset")) end']);
    }
    Component.onDestruction: { if (opened || loading) resetKeyboard(); }
    function commit() {
        if (loading) { commitPending = true; return; }
        if (!opened) return;
        var address = apps[selected].address;
        opened = false;
        resetKeyboard();
        Quickshell.execDetached(["hyprctl", "eval", 'hl.dispatch(hl.dsp.focus({window="address:' + address + '"}))']);
    }
    function closeSelected() {
        if (!opened || !apps.length) return;
        var address = apps[selected].address;
        // Request a normal close so the application can ask to save changes.
        Quickshell.execDetached(["hyprctl", "eval", 'hl.dispatch(hl.dsp.window.close({window="address:' + address + '"}))']);
    }
    function cancel() { resetKeyboard(); cancelled = true; opened = false; commitPending = false; pendingSteps = 0; }
    function entryFor(cls) {
        var entries = root.desktopEntries;
        var key = cls.toLowerCase();
        for (var i = 0; i < entries.length; i++) {
            var e = entries[i];
            if (String(e.id).toLowerCase().replace(/\.desktop$/, "") === key
                || String(e.startupClass || "").toLowerCase() === key) return e;
        }
        if (key.indexOf("chrome-app.slack.com") === 0) return DesktopEntries.byId("Slack");
        return null;
    }
    Process {
        id: query
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (root.cancelled) { root.loading = false; return; }
                var windows;
                try { windows = JSON.parse(text); } catch (e) { root.loading = false; root.resetKeyboard(); return; }
                windows = windows.filter(w => w.mapped && !w.hidden && w.focusHistoryID >= 0
                    && !w.workspace.name.startsWith("special:"));
                windows.sort((a,b) => a.focusHistoryID - b.focusHistoryID);
                var items = [];
                for (var w of windows) {
                    var entry = root.entryFor(w.class);
                    items.push({address: w.address, name: entry ? entry.name : w.class,
                        title: w.title || w.class, workspace: w.workspace.name,
                        icon: entry && entry.icon ? entry.icon : "application-x-executable"});
                }
                root.apps = items;
                root.loading = false;
                if (!items.length) { root.resetKeyboard(); return; }
                root.selected = ((root.pendingSteps % items.length) + items.length) % items.length;
                root.opened = true;
                if (root.commitPending) root.commit();
            }
        }
    }
    // Keep rows until the compositor confirms closure (save prompts may delay it).
    Timer {
        interval: 250
        running: root.opened
        repeat: true
        onTriggered: { if (!refresh.running) refresh.running = true; }
    }
    Process {
        id: refresh
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!root.opened) return;
                var clients;
                try { clients = JSON.parse(text); } catch (e) { return; }
                clients = clients.filter(w => w.mapped && !w.hidden && w.focusHistoryID >= 0
                    && !w.workspace.name.startsWith("special:"));
                var byAddress = {};
                for (var w of clients) byAddress[w.address] = w;
                var oldAddress = root.apps[root.selected].address;
                var items = [];
                for (var item of root.apps) {
                    var live = byAddress[item.address];
                    if (!live) continue;
                    items.push({address: item.address, name: item.name, icon: item.icon,
                        title: live.title || live.class, workspace: live.workspace.name});
                }
                if (!items.length) { root.cancel(); return; }
                var newIndex = items.findIndex(w => w.address === oldAddress);
                root.selected = newIndex >= 0 ? newIndex : Math.min(root.selected, items.length - 1);
                root.apps = items;
            }
        }
    }
    IpcHandler {
        target: "switcher"
        function next(): void { root.advance(1); }
        function previous(): void { root.advance(-1); }
        function commit(): void { root.commit(); }
        function closeSelected(): void { root.closeSelected(); }
        function cancel(): void { root.cancel(); }
        function state(): string { return JSON.stringify({opened: root.opened, selected: root.selected, apps: root.apps}); }
    }
    PanelWindow {
        visible: root.opened
        implicitWidth: Math.min(1200, screen.width - 48)
        implicitHeight: Math.min(root.apps.length * 52 + 16, screen.height - 96)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "mac-app-switcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        Rectangle {
            anchors.fill: parent
            radius: 24
            color: "#f01e1e2e"
            border.color: "#a6adc8"
            border.width: 2
            ListView {
                anchors.fill: parent
                anchors.margins: 8
                id: windowList
                orientation: ListView.Vertical
                model: root.apps
                currentIndex: root.selected
                clip: true
                highlightRangeMode: ListView.ApplyRange
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: windowList.width; height: 52
                    radius: 12
                    color: index === root.selected ? "#45475a" : "transparent"
                    Image {
                        x: 10; anchors.verticalCenter: parent.verticalCenter
                        width: 28; height: 28
                        source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                    }
                    Text {
                        x: 48; y: 6; width: parent.width - 160
                        text: modelData.name
                        color: "#cdd6f4"; font.pixelSize: 14; font.bold: true
                        elide: Text.ElideRight
                    }
                    Text {
                        x: 48; y: 28; width: parent.width - 160
                        text: modelData.title
                        color: "#bac2de"; font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        anchors.right: parent.right; anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: 94; height: 28; radius: 8
                        color: "#313244"
                        Text {
                            anchors.centerIn: parent
                            text: "Desktop " + modelData.workspace
                            color: "#cdd6f4"; font.pixelSize: 12
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton) root.cancel();
                            else { root.selected = index; root.commit(); }
                        }
                    }
                }
            }
        }
    }
}
