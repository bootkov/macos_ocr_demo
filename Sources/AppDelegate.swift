import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var hotkeyManager: HotkeyManager?
    var ocrService: OCRService?
    var resultsWindowController: ResultsWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Setup application menu bar for Edit menu (needed for copy/paste to work)
        setupMenuBar()

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.text.viewfinder", accessibilityDescription: "Clipboard OCR")
        }

        // Initialize OCR service
        ocrService = OCRService()

        // Setup global hotkey (Command + Shift + O)
        hotkeyManager = HotkeyManager { [weak self] in
            self?.performOCR()
        }

        // Create status bar menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Perform OCR (⌘⇧O)", action: #selector(performOCR), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    func setupMenuBar() {
        let mainMenu = NSMenu()

        // App menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenu.addItem(NSMenuItem(title: "Quit ClipboardOCR", action: #selector(quit), keyEquivalent: "q"))
        appMenuItem.submenu = appMenu

        // Edit menu (critical for copy/paste/select all to work)
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"))
        editMenu.addItem(NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"))
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        editMenuItem.submenu = editMenu

        NSApplication.shared.mainMenu = mainMenu
    }

    // MARK: - Actions

    @objc func performOCR() {
        guard let ocrService = ocrService else { return }

        let pasteboard = NSPasteboard.general

        // Check if clipboard contains an image
        guard let image = getImageFromClipboard(pasteboard) else {
            showAlert(message: "Content is not an image")
            return
        }

        // Perform OCR
        ocrService.performOCR(on: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    if text.isEmpty {
                        self.showAlert(message: "No text found in image")
                    } else {
                        self.showAlert(message: text)
                    }
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Helper Methods

    func getImageFromClipboard(_ pasteboard: NSPasteboard) -> NSImage? {
        // Check for various image types
        if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            return image
        }

        // Try reading as TIFF data
        if let tiffData = pasteboard.data(forType: .tiff),
           let image = NSImage(data: tiffData) {
            return image
        }

        // Try reading as PNG data
        if let pngData = pasteboard.data(forType: .png),
           let image = NSImage(data: pngData) {
            return image
        }

        return nil
    }

    func showAlert(message: String) {
        if let existingController = resultsWindowController, existingController.window?.isVisible == true {
            existingController.updateText(message)
            existingController.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            resultsWindowController = ResultsWindowController(text: message)
            resultsWindowController?.show()
        }
    }
}
