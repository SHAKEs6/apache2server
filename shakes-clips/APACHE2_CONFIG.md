# Apache2 Configuration Examples

## Virtual Host Configuration

Copy this to `/etc/apache2/sites-available/shakes-clips.conf`:

```apache
<VirtualHost *:80>
    ServerName shakes-clips.local
    ServerAlias www.shakes-clips.local
    DocumentRoot /home/shakes/Desktop/apache2server/shakes-clips

    <Directory /home/shakes/Desktop/apache2server/shakes-clips>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
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
    </IfModule>

    ErrorLog ${APACHE_LOG_DIR}/shakes-clips-error.log
    CustomLog ${APACHE_LOG_DIR}/shakes-clips-access.log combined
</VirtualHost>
```

## Enable the Configuration

```bash
# Enable the site
sudo a2ensite shakes-clips

# Enable required modules
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod deflate
sudo a2enmod expires

# Test configuration
sudo apache2ctl configtest

# Restart Apache2
sudo systemctl restart apache2
```

## Check Configuration

```bash
# See enabled sites
sudo apache2ctl -S

# View error log
sudo tail -f /var/log/apache2/shakes-clips-error.log

# View access log
sudo tail -f /var/log/apache2/shakes-clips-access.log
```

## SSL/HTTPS Setup (Optional)

```bash
# Using Let's Encrypt (Certbot)
sudo apt-get install certbot python3-certbot-apache

# Get certificate
sudo certbot --apache -d shakes-clips.local

# It will automatically update your config
```

## Alternative: Development Setup

If you just want to test locally without virtual hosts:

```bash
# Make sure Apache2 is running
sudo systemctl start apache2

# Symlink to Apache document root
sudo ln -s /home/shakes/Desktop/apache2server/shakes-clips /var/www/html/shakes-clips

# Access at: http://localhost/shakes-clips/
```

## Enable HTTP/2 (Optional, Performance)

```bash
# Enable HTTP/2 module
sudo a2enmod http2

# Add to your VirtualHost:
# Protocols h2 http/1.1

# Restart Apache
sudo systemctl restart apache2
```

## Security Headers (Optional)

Add to `shakes-clips.conf`:

```apache
<IfModule mod_headers.c>
    Header set X-Content-Type-Options "nosniff"
    Header set X-Frame-Options "SAMEORIGIN"
    Header set X-XSS-Protection "1; mode=block"
    Header set Referrer-Policy "no-referrer-when-downgrade"
</IfModule>
```

## Rate Limiting (Optional)

Add to `shakes-clips.conf`:

```apache
<IfModule mod_ratelimit.c>
    # Limit API requests to prevent spam
    <Location /shakes-clips/api/>
        SetOutputFilter RATE_LIMIT
        SetEnv rate-limit 100
    </Location>
</IfModule>
```

## Troubleshooting Apache

```bash
# Check Apache status
sudo systemctl status apache2

# Restart Apache
sudo systemctl restart apache2

# Check for errors
sudo apache2ctl configtest

# View active connections
sudo netstat -tulnp | grep apache2

# Check which sites are enabled
sudo apache2ctl -S

# Enable debug logging
# Add to apache2.conf: LogLevel debug
```

## Performance Tuning

### In `/etc/apache2/apache2.conf`:

```apache
# Increase server limits for better performance
<IfModule mpm_prefork_module>
    StartServers           10
    MinSpareServers        5
    MaxSpareServers        10
    MaxRequestWorkers      250
    MaxConnectionsPerChild 0
</IfModule>

# Or for threaded version (mpm_worker_module):
<IfModule mpm_worker_module>
    StartServers           2
    MinSpareServers        5
    MaxSpareServers        10
    ThreadsPerChild        25
    MaxRequestWorkers      150
    MaxConnectionsPerChild 0
</IfModule>
```

## Disable Directory Listing (Security)

```apache
<Directory /home/shakes/Desktop/apache2server/shakes-clips>
    Options -Indexes +FollowSymLinks
</Directory>
```

## Block Direct Access to Sensitive Files

```apache
<FilesMatch "\.(php|db|conf)$">
    Deny from all
</FilesMatch>
```

---

All these configurations are already included in:
- `.htaccess` file in the shakes-clips directory
- `setup.sh` automated setup script
- Default Apache configuration files

Choose to add them if you need additional customization!
