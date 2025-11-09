#!/bin/bash

set -e

# Kill the process if it's running
echo "Checking for running ClipboardOCR process..."
if pgrep -x "ClipboardOCR" > /dev/null; then
    echo "Killing running ClipboardOCR process..."
    killall ClipboardOCR
    sleep 0.5
fi

echo "Building ClipboardOCR..."

# Build the Swift package
swift build -c release

# Create app bundle structure
APP_NAME="ClipboardOCR.app"
BUILD_DIR=".build/release"
APP_DIR="$BUILD_DIR/$APP_NAME"

echo "Creating app bundle..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy executable
cp "$BUILD_DIR/ClipboardOCR" "$APP_DIR/Contents/MacOS/"

# Copy Info.plist
cp Info.plist "$APP_DIR/Contents/"

echo "App bundle created at: $APP_DIR"
echo ""
echo "To run the app:"
echo "  open $APP_DIR"
echo ""
echo "To install to Applications folder:"
echo "  cp -r $APP_DIR /Applications/"
