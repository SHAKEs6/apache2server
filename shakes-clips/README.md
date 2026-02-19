# 🎬 Shakes Clips - Movie Web Application

A modern, responsive video streaming application with dynamic video loading, comments system, and database storage. Perfect for Apache2 hosting!

## Features

✨ **Dynamic Video Loading** - Videos are automatically loaded from the `/videos` folder without code updates
🎨 **Modern UI** - Beautiful dark theme with gradient accents and smooth animations
💬 **Comment System** - Fully functional comment section with persistent database storage
📱 **Fully Responsive** - Works perfectly on desktop, tablet, and mobile devices
🚀 **Apache2 Ready** - Configured and optimized for Apache2 servers
🔒 **Secure** - Built-in security features and validation
⚡ **Fast** - Optimized performance with caching and compression

## Project Structure

```
shakes-clips/
├── index.html           # Main HTML file
├── config.php           # Database configuration
├── .htaccess            # Apache2 configuration
├── api/
│   └── api.php          # Backend API endpoints
├── css/
│   └── style.css        # Responsive styling
├── js/
│   └── script.js        # Frontend logic
└── db/
    └── comments.db      # SQLite database (auto-created)
```

## Installation & Setup

### Prerequisites

- Apache2 with PHP support (PHP 5.3+)
- SQLite3 support in PHP (usually enabled by default)
- Read/write permissions in the application directory

### Step 1: Verify PHP and SQLite Support

```bash
php -m | grep -i sqlite
```

If you see `sqlite3` or `pdo_sqlite`, you're good to go!

### Step 2: Apache2 Configuration

Add a virtual host to your Apache2 configuration:

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

    ErrorLog ${APACHE_LOG_DIR}/shakes-clips-error.log
    CustomLog ${APACHE_LOG_DIR}/shakes-clips-access.log combined
</VirtualHost>
```

Save this to `/etc/apache2/sites-available/shakes-clips.conf`

### Step 3: Enable the Site and Modules

```bash
# Enable the site
sudo a2ensite shakes-clips

# Enable required modules (if not already enabled)
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod deflate
sudo a2enmod expires

# Restart Apache2
sudo systemctl restart apache2
```

### Step 4: Set Permissions

```bash
# Make sure the db directory is writable
chmod 755 /home/shakes/Desktop/apache2server/shakes-clips
chmod 755 /home/shakes/Desktop/apache2server/shakes-clips/db
chmod 755 /home/shakes/Desktop/apache2server/videos

# If running as a specific user/group (e.g., www-data)
sudo chown -R www-data:www-data /home/shakes/Desktop/apache2server/shakes-clips/db
```

### Step 5: Update Your Hosts File (Optional)

Add to `/etc/hosts`:
```
127.0.0.1 shakes-clips.local
```

### Step 6: Access the Application

Open your browser and navigate to:
```
http://localhost/shakes-clips/
```

Or if using a virtual host:
```
http://shakes-clips.local/
```

## Adding Videos

Simply add your video files to the `/videos` folder:
- Supported formats: MP4, MKV, AVI, MOV, WebM
- Videos will automatically appear in the application
- No code changes needed!

Example:
```bash
cp ~/my-video.mp4 /home/shakes/Desktop/apache2server/videos/
```

## How It Works

### Video Discovery
- The application scans the `/videos` folder when it loads
- Videos are sorted alphabetically
- File sizes are displayed with each video

### Comments System
- SQLite database stores all comments
- Comments are linked to videos by unique ID
- Real-time loading and display
- Delete functionality with confirmation

### Frontend
- Vanilla JavaScript (no dependencies)
- Responsive CSS Grid layout
- Modal popup for video player and comments
- Smooth animations and transitions

### Backend
- PHP REST API
- Four main endpoints:
  - `GET /api/api.php?action=getVideos` - List all videos
  - `GET /api/api.php?action=getComments&video_id=ID` - Get video comments
  - `POST /api/api.php` - Add a comment
  - `DELETE /api/api.php` - Delete a comment

## Database Schema

The SQLite database stores comments with the following structure:

```sql
CREATE TABLE comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    video_id TEXT NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Troubleshooting

### Videos Not Showing
1. Verify the `/videos` folder exists and contains video files
2. Check file permissions: `ls -la /path/to/videos`
3. Ensure Apache2 can read the videos folder

### Database Errors
1. Check that `/db` folder is writable: `chmod 755 /db`
2. Ensure SQLite3 support is enabled: `php -m | grep sqlite`
3. Delete `/db/comments.db` to reset the database

### Comments Not Saving
1. Check Apache2 error logs: `tail -f /var/log/apache2/error.log`
2. Verify `/db` folder has write permissions for the www-data user
3. Check browser console for JavaScript errors

### CORS Issues (if accessing from different domain)
The `.htaccess` file already enables CORS headers. If issues persist:
```apache
# Add to .htaccess
Header set Access-Control-Allow-Origin "*"
Header set Access-Control-Allow-Methods "GET, POST, DELETE, OPTIONS"
```

## Performance Optimization

The application includes:
- **Gzip Compression** - Reduces CSS/JS file sizes by ~70%
- **Browser Caching** - Static assets cached for 1 month
- **Lazy Loading** - Comments only load when video is opened
- **Efficient Queries** - Indexed database lookups

## Security Features

✅ Input validation for comments
✅ Email format validation
✅ HTML escaping to prevent XSS
✅ SQLite protection against SQL injection (prepared statements)
✅ Sensitive files (.db, config.php) denied direct access

## Customization

### Change Theme Colors

Edit `css/style.css` - Modify the CSS variables at the top:

```css
:root {
    --primary-color: #ff6b35;
    --secondary-color: #004e89;
    --dark-bg: #0a0e27;
    /* ... more colors */
}
```

### Modify Video Formats

Edit `api/api.php` - Update the `$ext` array in the `getVideos()` function:

```php
if (in_array($ext, ['mp4', 'mkv', 'avi', 'mov', 'webm'])) {
    // ...
}
```

### Change Comment Limit

Edit `api/api.php` - Modify the LIMIT in the SQL query:

```php
// Get last 100 comments (change this number)
'SELECT * FROM comments WHERE video_id = ? ORDER BY created_at DESC LIMIT 100'
```

## File Size Reference

- HTML: ~4 KB
- CSS: ~15 KB (compressed to ~4 KB)
- JavaScript: ~8 KB (compressed to ~3 KB)
- Database: Grows with comments (~1 KB per 100 comments)

## Browser Compatibility

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+
- Mobile browsers (iOS Safari, Chrome Mobile)

## Support & Issues

For issues or questions:
1. Check the troubleshooting section above
2. Review Apache2 error logs
3. Check browser console (F12) for JavaScript errors
4. Verify file permissions and folder structure

## License

This project is provided as-is for personal use.

## Future Enhancements

Potential features to add:
- User authentication and profiles
- Video upload functionality
- Video categorization/tags
- Advanced search
- Like/reaction system
- Nested comment replies
- Video progress tracking

---

Enjoy your Shakes Clips experience! 🎬
