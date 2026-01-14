import Foundation
import AppKit
import KeyboardShortcuts

extension AppState {
    /// Sets up global keyboard shortcuts.
    func setupKeyboardShortcuts() {
        KeyboardShortcuts.onKeyUp(for: .toggleMainWindow) { [weak self] in
            // KeyboardShortcuts callbacks run on the main thread, so we can use assumeIsolated
            // This avoids creating a detached Task that outlives the callback context
            MainActor.assumeIsolated {
                self?.toggleMainWindow()
            }
        }
    }

    /// Toggles the main window visibility.
    func toggleMainWindow() {
        if let window = NSApp.windows.first(where: { $0.title == "PortKiller" || $0.identifier?.rawValue == "main" }) {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                NSApp.setActivationPolicy(.regular)
                NSApp.activate(ignoringOtherApps: true)
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
            }
        } else {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
