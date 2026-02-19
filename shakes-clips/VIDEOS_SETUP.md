# 🎬 Shakes Clips - Videos Setup Guide

## ✅ What Was Fixed

The application now properly serves videos from the `/videos` folder. Here's what's configured:

### 1. **API Path Fix**
- Updated `/api/api.php` to use `/videos/` as the web-accessible path
- Videos are now referenced correctly as `/videos/filename.mp4`

### 2. **Apache Alias Configuration**
- Added `Alias /videos /home/shakes/Desktop/apache2server/videos` to vhost config
- This makes the videos folder accessible via the web at `/videos/`
- Works from any URL that accesses the shakes-clips application

### 3. **Folder Permissions**
- Fixed permissions on `/home/shakes/Desktop/apache2server/videos/` to 755
- Now Apache (www-data) can read the video files

## 🚀 Setup Instructions

### Option 1: Automated Setup (Recommended)

```bash
# Run the updated setup script
sudo bash /home/shakes/Desktop/apache2server/shakes-clips/setup.sh

# This will:
# ✅ Create the virtual host configuration with video alias
# ✅ Enable Apache modules
# ✅ Enable the site
# ✅ Restart Apache2
```

### Option 2: Manual Apache Configuration

1. **Copy the vhost configuration:**
   ```bash
   sudo cp /home/shakes/Desktop/apache2server/shakes-clips/apache2-vhost.conf /etc/apache2/sites-available/shakes-clips.conf
   ```

2. **Enable the site:**
   ```bash
   sudo a2ensite shakes-clips
   ```

3. **Enable required modules:**
   ```bash
   sudo a2enmod rewrite
   sudo a2enmod headers
   sudo a2enmod deflate
   sudo a2enmod expires
   ```

4. **Test and restart:**
   ```bash
   sudo apache2ctl configtest
   sudo systemctl restart apache2
   ```

## 📁 File Locations

```
Apache Web Root:
/home/shakes/Desktop/apache2server/shakes-clips/    ← Main application

Video Files (aliased to /videos/):
/home/shakes/Desktop/apache2server/videos/          ← All videos stored here

Access from browser:
http://localhost/shakes-clips/                      ← Main app
http://localhost/videos/                            ← Videos folder
```

## 🎥 How Videos Are Served

1. **Browser requests video:**
   - User clicks a video in Shakes Clips
   - JavaScript sends: `/videos/filename.mp4`

2. **Apache processes request:**
   - Apache sees `/videos/...` request
   - Uses `Alias` directive to map to `/home/shakes/Desktop/apache2server/videos/`
   - Serves the file directly

3. **Video plays:**
   - Browser receives video stream
   - HTML5 video player displays it

## ✅ Verification

### Check Videos Are Listed

Access the API directly to see if videos are discovered:

```
http://localhost/shakes-clips/api/api.php?action=getVideos
```

You should see JSON with all videos listed.

### Check Video Files Are Readable

```bash
# List videos
ls -l /home/shakes/Desktop/apache2server/videos/ | head -5

# Test permissions
sudo -u www-data ls /home/shakes/Desktop/apache2server/videos/ | head -1
```

### Check Apache Configuration

```bash
# View enabled sites
sudo apache2ctl -S | grep shakes

# Test configuration
sudo apache2ctl configtest
```

## 🐛 Troubleshooting

### Videos Not Appearing in List

1. **Check API response:**
   ```bash
   curl "http://localhost/shakes-clips/api/api.php?action=getVideos"
   ```

2. **Check video folder permissions:**
   ```bash
   ls -ld /home/shakes/Desktop/apache2server/videos/
   chmod -R 755 /home/shakes/Desktop/apache2server/videos/
   ```

3. **Check Apache error log:**
   ```bash
   tail -f /var/log/apache2/shakes-clips-error.log
   ```

### Videos Listed But Won't Play

1. **Check Alias is configured:**
   ```bash
   sudo apache2ctl -S | grep Alias
   ```

2. **Test direct access:**
   ```
   http://localhost/videos/
   ```
   Should show directory listing of videos.

3. **Restart Apache:**
   ```bash
   sudo systemctl restart apache2
   ```

### Permission Denied Errors

1. **Fix video folder permissions:**
   ```bash
   chmod -R 755 /home/shakes/Desktop/apache2server/videos
   ```

2. **Check ownership (if using www-data):**
   ```bash
   ls -l /home/shakes/Desktop/apache2server/videos/ | head -1
   ```

## 📊 Architecture

```
┌─ Browser (http://localhost/shakes-clips/)
│
├─ API Request: /api/api.php?action=getVideos
│  └─ Returns: JSON list with /videos/ paths
│
├─ Video Request: GET /videos/video1.mp4
│  ├─ Apache Alias detects /videos/ path
│  ├─ Maps to /home/shakes/Desktop/apache2server/videos/
│  └─ Serves video file
│
└─ Video Player: Plays stream in HTML5 video tag
```

## 🔧 Configuration Files

### Apache Virtual Host
File: `/etc/apache2/sites-available/shakes-clips.conf`
```apache
Alias /videos /home/shakes/Desktop/apache2server/videos

<Directory /home/shakes/Desktop/apache2server/videos>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```

### Application Config
File: `/home/shakes/Desktop/apache2server/shakes-clips/config.php`
```php
define('VIDEOS_PATH', __DIR__ . '/../videos');
```

### API Response
File: `/home/shakes/Desktop/apache2server/shakes-clips/api/api.php`
```php
'path' => '/videos/' . urlencode($file)
```

## 🎯 Quick Commands

```bash
# Setup everything
sudo bash /home/shakes/Desktop/apache2server/shakes-clips/setup.sh

# Verify videos are accessible
curl "http://localhost/shakes-clips/api/api.php?action=getVideos" | head -c 200

# Check Apache is running
sudo systemctl status apache2

# View Apache logs
tail -f /var/log/apache2/shakes-clips-error.log

# Restart Apache after config changes
sudo systemctl restart apache2
```

## 🎬 Now Videos Should Work!

After setup:

1. ✅ Open: `http://localhost/shakes-clips/`
2. ✅ Videos appear in grid
3. ✅ Click any video to open player
4. ✅ Video plays directly in the browser
5. ✅ Add/view comments below player

## 📝 Notes

- Videos are served directly from the filesystem
- Apache handles all streaming (no PHP overhead)
- Supports range requests for seeking in videos
- Compression enabled for faster loading
- Browser caching configured (30 days)

---

If you still have issues, run:
```bash
bash /home/shakes/Desktop/apache2server/shakes-clips/check-status.sh
```

This will verify all configuration is correct!
