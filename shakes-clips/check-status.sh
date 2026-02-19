#!/bin/bash

# Shakes Clips - Status Check Script
# This script verifies the installation is working correctly

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🔍 Shakes Clips - Status Check"
echo "=============================="
echo ""

# Check PHP
echo "Checking PHP..."
if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -n 1)
    echo "✅ PHP: $PHP_VERSION"
else
    echo "❌ PHP not found"
fi

# Check SQLite support
echo ""
echo "Checking PHP SQLite support..."
if php -m | grep -q sqlite; then
    echo "✅ SQLite support enabled"
else
    echo "❌ SQLite support not found"
fi

# Check folders
echo ""
echo "Checking folder structure..."

for folder in "api" "css" "js" "db"; do
    if [ -d "$SCRIPT_DIR/$folder" ]; then
        echo "✅ /$folder exists"
    else
        echo "❌ /$folder missing"
    fi
done

# Check files
echo ""
echo "Checking required files..."

for file in "index.html" "config.php" "css/style.css" "js/script.js" "api/api.php" ".htaccess"; do
    if [ -f "$SCRIPT_DIR/$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

# Check videos folder
echo ""
echo "Checking videos folder..."
VIDEOS_DIR="$(dirname "$SCRIPT_DIR")/videos"

if [ -d "$VIDEOS_DIR" ]; then
    VIDEO_COUNT=$(find "$VIDEOS_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.webm" \) | wc -l)
    if [ "$VIDEO_COUNT" -gt 0 ]; then
        echo "✅ Videos folder found with $VIDEO_COUNT video(s)"
    else
        echo "⚠️  Videos folder found but is empty"
    fi
else
    echo "❌ Videos folder not found"
fi

# Check database
echo ""
echo "Checking database..."
if [ -f "$SCRIPT_DIR/db/comments.db" ]; then
    DB_SIZE=$(du -h "$SCRIPT_DIR/db/comments.db" | cut -f1)
    echo "✅ Database exists ($DB_SIZE)"
else
    echo "ℹ️  Database will be created on first run"
fi

# Check permissions
echo ""
echo "Checking permissions..."

if [ -w "$SCRIPT_DIR/db" ]; then
    echo "✅ /db directory is writable"
else
    echo "❌ /db directory is not writable (run: chmod 755 $SCRIPT_DIR/db)"
fi

# Check Apache2
echo ""
echo "Checking Apache2..."
if command -v apache2 &> /dev/null; then
    if systemctl is-active --quiet apache2; then
        echo "✅ Apache2 is running"
    else
        echo "⚠️  Apache2 is installed but not running (start with: sudo systemctl start apache2)"
    fi
    
    if a2enmod -q rewrite 2>/dev/null; then
        echo "✅ Rewrite module is enabled"
    else
        echo "⚠️  Rewrite module may not be enabled"
    fi
else
    echo "⚠️  Apache2 not found"
fi

echo ""
echo "=============================="
echo "✅ Status check complete!"
echo ""
echo "Next steps:"
echo "1. If this is first run, access the application: http://localhost/shakes-clips/"
echo "2. The database will be created automatically"
echo "3. Try adding a comment to test the system"
echo ""
