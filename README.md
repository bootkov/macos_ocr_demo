# ClipboardOCR

A macOS menu bar application that performs OCR (Optical Character Recognition) on images from your clipboard using a global hotkey.

## Features

- **Global Hotkey**: Press `⌘⇧O` (Command + Shift + O) to trigger OCR
- **Clipboard Integration**: Automatically reads images from your clipboard
- **Vision Framework**: Uses Apple's Vision Framework for accurate text recognition
- **Editable Results Window**: OCR results appear in a dedicated window with full text editing
- **Flexible Editing**: Select, modify, and copy any portion of the recognized text
- **Menu Bar App**: Runs unobtrusively in your menu bar

## How to Use

1. **Build the app**:
   ```bash
   ./build.sh
   ```

2. **Run the app**:
   ```bash
   open .build/release/ClipboardOCR.app
   ```

   Or install it to Applications:
   ```bash
   cp -r .build/release/ClipboardOCR.app /Applications/
   ```

3. **Using the app**:
   - Copy an image to your clipboard (screenshot with `⌘⇧4`, copy image file, etc.)
   - Press `⌘⇧O` (Command + Shift + O)
   - A results window will open with the OCR text in an editable text area
   - **Edit the text** directly in the window - fix typos, modify content, etc.
   - **Select and copy** any portion with `⌘C`, or click "Copy All" to copy everything
   - Press **Escape** or click "Close" to close the window
   - If no image is in the clipboard, you'll see a message saying "Content is not an image"

4. **Menu Bar Options**:
   - Click the menu bar icon to access:
     - **Perform OCR (⌘⇧O)**: Manually trigger OCR
     - **Quit**: Exit the application

## Requirements

- macOS 13.0 or later
- Xcode Command Line Tools or Swift toolchain

