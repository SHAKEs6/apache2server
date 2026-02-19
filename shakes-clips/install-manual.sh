#!/bin/bash
# Manual Installation Steps for Shakes Clips
# Follow these step-by-step if the automated setup doesn't work

APP_PATH="/home/shakes/Desktop/apache2server/shakes-clips"
VIDEOS_PATH="/home/shakes/Desktop/apache2server/videos"

echo "🎬 Shakes Clips - Manual Installation Guide"
echo "==========================================="
echo ""

# Step 1: Check prerequisites
echo "STEP 1: Checking Prerequisites"
echo "-----"

echo "Checking for Apache2..."
if command -v apache2 &> /dev/null; then
    APACHE_VERSION=$(apache2 -v | grep "Apache/" | cut -d' ' -f3)
    echo "✅ Apache2 found: $APACHE_VERSION"
else
    echo "❌ Apache2 not found!"
    echo "   Install with: sudo apt-get install apache2"
    exit 1
fi

echo ""
echo "Checking for PHP..."
if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -n 1)
    echo "✅ $PHP_VERSION"
else
    echo "❌ PHP not found!"
    echo "   Install with: sudo apt-get install php"
    exit 1
fi

echo ""
echo "Checking for SQLite support..."
if php -m | grep -q sqlite; then
    echo "✅ PHP SQLite support is available"
else
    echo "❌ SQLite not available in PHP!"
    echo "   Install with: sudo apt-get install php-sqlite3"
    exit 1
fi

# Step 2: Set permissions
echo ""
echo "STEP 2: Setting File Permissions"
echo "-----"

chmod 755 "$APP_PATH"
echo "✅ Set app directory permissions"

chmod 755 "$APP_PATH/db"
echo "✅ Set db directory permissions"

chmod 755 "$VIDEOS_PATH"
echo "✅ Set videos directory permissions"

# Try to set ownership to www-data
if id "www-data" &>/dev/null 2>&1; then
    sudo chown -R www-data:www-data "$APP_PATH/db"
    echo "✅ Set db ownership to www-data"
fi

# Step 3: Verify files
echo ""
echo "STEP 3: Verifying Project Files"
echo "-----"

FILES=(
    "index.html"
    "config.php"
    "api/api.php"
    "css/style.css"
    "js/script.js"
    ".htaccess"
)

for file in "${FILES[@]}"; do
    if [ -f "$APP_PATH/$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING!"
    fi
done

# Step 4: Create Apache virtual host
echo ""
echo "STEP 4: Creating Apache Virtual Host"
echo "-----"

VHOST_FILE="/etc/apache2/sites-available/shakes-clips.conf"

if [ -f "$VHOST_FILE" ]; then
    echo "ℹ️  Virtual host already exists at $VHOST_FILE"
else
    echo "Creating new virtual host configuration..."
    sudo bash << EOF
cat > $VHOST_FILE << 'VHOST'
<VirtualHost *:80>
    ServerName shakes-clips.local
    ServerAlias www.shakes-clips.local
    DocumentRoot $APP_PATH

    <Directory $APP_PATH>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/shakes-clips-error.log
    CustomLog \${APACHE_LOG_DIR}/shakes-clips-access.log combined
</VirtualHost>
VHOST
EOF
    echo "✅ Virtual host created"
fi

# Step 5: Enable modules
echo ""
echo "STEP 5: Enabling Apache Modules"
echo "-----"

MODULES=("rewrite" "headers" "deflate" "expires")

for module in "${MODULES[@]}"; do
    if sudo a2enmod "$module" 2>/dev/null | grep -q "already enabled"; then
        echo "✅ $module - already enabled"
    elif sudo a2enmod "$module" 2>/dev/null; then
        echo "✅ $module - enabled"
    else
        echo "⚠️  $module - may need manual enabling"
    fi
done

# Step 6: Enable the site
echo ""
echo "STEP 6: Enabling the Site"
echo "-----"

if sudo a2ensite shakes-clips 2>/dev/null | grep -q "already enabled"; then
    echo "✅ Site already enabled"
elif sudo a2ensite shakes-clips 2>/dev/null; then
    echo "✅ Site enabled"
else
    echo "⚠️  Could not enable site"
fi

# Step 7: Test configuration
echo ""
echo "STEP 7: Testing Apache Configuration"
echo "-----"

if sudo apache2ctl configtest 2>/dev/null | grep -q "Syntax OK"; then
    echo "✅ Configuration is valid"
else
    echo "⚠️  Configuration test returned warnings"
    echo "   Run: sudo apache2ctl configtest"
fi

# Step 8: Restart Apache
echo ""
echo "STEP 8: Restarting Apache2"
echo "-----"

if sudo systemctl restart apache2 2>/dev/null; then
    echo "✅ Apache2 restarted successfully"
else
    echo "❌ Failed to restart Apache2"
    echo "   Try manually: sudo systemctl restart apache2"
fi

# Step 9: Verify installation
echo ""
echo "STEP 9: Verifying Installation"
echo "-----"

sleep 2

if sudo systemctl is-active --quiet apache2; then
    echo "✅ Apache2 is running"
else
    echo "❌ Apache2 is not running"
fi

if [ -d "$VIDEOS_PATH" ]; then
    VIDEO_COUNT=$(find "$VIDEOS_PATH" -type f \( -iname "*.mp4" -o -iname "*.mkv" \) | wc -l)
    echo "✅ Found $VIDEO_COUNT videos in $VIDEOS_PATH"
fi

if [ -w "$APP_PATH/db" ]; then
    echo "✅ Database directory is writable"
else
    echo "❌ Database directory is NOT writable"
fi

# Final instructions
echo ""
echo "==========================================="
echo "✨ Installation Complete!"
echo "==========================================="
echo ""
echo "Next Steps:"
echo "1. Add shakes-clips.local to /etc/hosts (optional):"
echo "   sudo nano /etc/hosts"
echo "   Add: 127.0.0.1 shakes-clips.local"
echo ""
echo "2. Access the application:"
echo "   http://localhost/shakes-clips/"
echo "   OR"
echo "   http://shakes-clips.local/"
echo ""
echo "3. Add videos to:"
echo "   $VIDEOS_PATH"
echo ""
echo "4. Test by clicking a video and posting a comment"
echo ""
echo "For troubleshooting, see README.md or run:"
echo "   bash $APP_PATH/check-status.sh"
echo ""
