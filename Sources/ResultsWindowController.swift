import Cocoa

class ResultsWindowController: NSWindowController {
    private var textView: NSTextView!

    convenience init(text: String) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "OCR Result"
        window.center()
        window.isReleasedWhenClosed = false

        self.init(window: window)
        setupUI(text: text)
    }

    private func setupUI(text: String) {
        guard let window = window else { return }

        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.autoresizingMask = [.width, .height]

        // Text view setup with proper text container
        let scrollView = NSScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder

        // Create text storage, layout manager, and text container
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(containerSize: NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)

        // Create text view with the text system components
        textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.textColor = .labelColor
        textView.backgroundColor = .textBackgroundColor
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false
        textView.isGrammarCheckingEnabled = false
        textView.isRichText = false
        textView.usesFontPanel = false
        textView.usesRuler = false
        textView.autoresizingMask = [.width, .height]
        textView.textContainerInset = NSSize(width: 5, height: 5)
        textView.drawsBackground = true

        // Set the text after configuration
        textView.string = text

        scrollView.documentView = textView
        contentView.addSubview(scrollView)

        // Buttons
        let copyButton = NSButton(title: "Copy All", target: self, action: #selector(copyAll))
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.bezelStyle = .rounded
        copyButton.keyEquivalent = "\r" // Make it the default button
        contentView.addSubview(copyButton)

        let closeButton = NSButton(title: "Close", target: self, action: #selector(closeWindow))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.bezelStyle = .rounded
        closeButton.keyEquivalent = "\u{1b}" // Escape key
        contentView.addSubview(closeButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: copyButton.topAnchor, constant: -20),

            copyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            copyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            copyButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),

            closeButton.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -12),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        window.contentView = contentView
    }

    @objc private func copyAll() {
        guard let text = textView?.string else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    @objc private func closeWindow() {
        close()
    }

    func updateText(_ newText: String) {
        textView?.string = newText
    }

    func show() {
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        // Make text view first responder after window is shown
        window?.makeFirstResponder(textView)
    }
}
