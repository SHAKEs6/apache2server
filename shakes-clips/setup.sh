#!/bin/bash

# Shakes Clips - Quick Setup Script
# This script automates the Apache2 setup process

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_NAME="shakes-clips"
APP_PATH="$SCRIPT_DIR"
APACHE_SITES_DIR="/etc/apache2/sites-available"
APACHE_CONF="$APACHE_SITES_DIR/$APP_NAME.conf"

echo "🎬 Shakes Clips - Setup Script"
echo "=============================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  This script requires root privileges for some operations."
    echo "Please run: sudo bash setup.sh"
    exit 1
fi

# Check Apache2
if ! command -v apache2 &> /dev/null; then
    echo "❌ Apache2 is not installed"
    exit 1
fi
echo "✅ Apache2 found"

# Check PHP
if ! command -v php &> /dev/null; then
    echo "❌ PHP is not installed"
    exit 1
fi
echo "✅ PHP found ($(php -v | head -n 1))"

# Check SQLite support
if ! php -m | grep -q sqlite; then
    echo "❌ PHP SQLite extension not found"
    exit 1
fi
echo "✅ PHP SQLite support found"

# Set permissions
echo ""
echo "Setting folder permissions..."
chmod 755 "$APP_PATH"
chmod 755 "$APP_PATH/db"
chmod 755 "$(dirname "$APP_PATH")/videos"

# Try to change ownership to www-data if it exists
if id "www-data" &>/dev/null 2>&1; then
    chown -R www-data:www-data "$APP_PATH/db"
    echo "✅ Set ownership to www-data"
fi

# Create Apache virtual host configuration
echo ""
echo "Creating Apache2 virtual host configuration..."

cat > "$APACHE_CONF" << 'EOF'
<VirtualHost *:80>
    ServerName shakes-clips.local
    ServerAlias www.shakes-clips.local
    DocumentRoot /home/shakes/Desktop/apache2server/shakes-clips

    # Alias for videos folder
    Alias /videos /home/shakes/Desktop/apache2server/videos

    # Main application directory
    <Directory /home/shakes/Desktop/apache2server/shakes-clips>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Videos directory - allow direct access
    <Directory /home/shakes/Desktop/apache2server/videos>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
        
        # Enable streaming for large video files
        <IfModule mod_headers.c>
            Header set Accept-Ranges bytes
            Header set Cache-Control "public, max-age=2592000"
        </IfModule>
    </Directory>

    # Enable compression
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json
    </IfModule>

    # Set proper cache control
    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresByType text/html "access 1 hour"
        ExpiresByType text/css "access 1 month"
        ExpiresByType application/javascript "access 1 month"
        ExpiresByType video/mp4 "access 1 month"
        ExpiresByType video/x-matroska "access 1 month"
    </IfModule>

    ErrorLog ${APACHE_LOG_DIR}/shakes-clips-error.log
    CustomLog ${APACHE_LOG_DIR}/shakes-clips-access.log combined
</VirtualHost>
EOF

echo "✅ Virtual host configuration created"

# Enable the site
echo "Enabling Apache2 site..."
a2ensite "$APP_NAME" >/dev/null 2>&1 || true
echo "✅ Site enabled"

# Enable required modules
echo "Enabling Apache2 modules..."
for module in rewrite headers deflate expires; do
    a2enmod "$module" >/dev/null 2>&1 || true
done
echo "✅ Modules enabled"

# Test Apache configuration
echo ""
echo "Testing Apache2 configuration..."
if apache2ctl configtest 2>/dev/null | grep -q "Syntax OK"; then
    echo "✅ Configuration is valid"
else
    echo "⚠️  Configuration test returned warnings (this may be normal)"
fi

# Restart Apache2
echo ""
echo "Restarting Apache2..."
systemctl restart apache2
echo "✅ Apache2 restarted"

# Update hosts file (optional)
echo ""
echo "Would you like to add 'shakes-clips.local' to your /etc/hosts file? (y/n)"
read -r -t 10 -n 1 add_hosts || add_hosts="n"
echo ""

if [[ "$add_hosts" == "y" ]] || [[ "$add_hosts" == "Y" ]]; then
    if ! grep -q "shakes-clips.local" /etc/hosts; then
        echo "127.0.0.1 shakes-clips.local" >> /etc/hosts
        echo "✅ Added to /etc/hosts"
    else
        echo "⚠️  Already in /etc/hosts"
    fi
fi

# Summary
echo ""
echo "=============================="
echo "✨ Setup Complete!"
echo "=============================="
echo ""
echo "Access your application at:"
echo "  • http://localhost/shakes-clips/"
echo "  • http://shakes-clips.local/ (if you added it to hosts)"
echo ""
echo "📁 Application path: $APP_PATH"
echo "📹 Videos folder: $(dirname "$APP_PATH")/videos"
echo "💾 Database: $APP_PATH/db/comments.db"
echo ""
echo "📖 For more information, see README.md"
echo ""
