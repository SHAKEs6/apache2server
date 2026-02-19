# 🎬 Shakes Clips - Quick Reference Card

## 🚀 Setup (Copy & Paste)

```bash
# First time setup
sudo bash /home/shakes/Desktop/apache2server/shakes-clips/setup.sh

# Verify it works
bash /home/shakes/Desktop/apache2server/shakes-clips/check-status.sh

# Open in browser
# http://localhost/shakes-clips/
```

## 📁 Locations

| Item | Path |
|------|------|
| **Application** | `/home/shakes/Desktop/apache2server/shakes-clips/` |
| **Videos Folder** | `/home/shakes/Desktop/apache2server/videos/` |
| **Database** | `/shakes-clips/db/comments.db` |
| **Error Log** | `/var/log/apache2/shakes-clips-error.log` |

## 🎥 Add Videos

```bash
# Copy single video
cp ~/video.mp4 /home/shakes/Desktop/apache2server/videos/

# Copy multiple videos
cp ~/Videos/*.mp4 /home/shakes/Desktop/apache2server/videos/

# That's it! Refresh browser
```

## 🔧 Common Commands

```bash
# Check status
bash /home/shakes/Desktop/apache2server/shakes-clips/check-status.sh

# View Apache error log
tail -f /var/log/apache2/shakes-clips-error.log

# Check Apache is running
sudo systemctl status apache2

# Restart Apache
sudo systemctl restart apache2

# Enable the site
sudo a2ensite shakes-clips

# Check Apache config
sudo apache2ctl configtest

# Fix permissions
chmod 755 /home/shakes/Desktop/apache2server/shakes-clips/db

# Reset database
rm /home/shakes/Desktop/apache2server/shakes-clips/db/comments.db
```

## 🌐 Access URLs

```
Local:        http://localhost/shakes-clips/
Domain:       http://shakes-clips.local/
Other PC:     http://[YOUR_IP]/shakes-clips/
```

## 🎨 Quick Customization

### Change Colors
File: `css/style.css` (lines 8-15)
```css
:root {
    --primary-color: #ff6b35;    /* Orange */
    --secondary-color: #004e89;  /* Blue */
    --dark-bg: #0a0e27;          /* Dark */
}
```

### Change Header Text
File: `index.html` (lines 45-46)
```html
<h1>🎬 Shakes Clips</h1>
<p>Watch, Comment, Enjoy!</p>
```

## 🐛 Troubleshooting Quick Fixes

### Videos Not Showing?
```bash
ls -la /home/shakes/Desktop/apache2server/videos/
```

### Comments Not Working?
```bash
# Fix permissions
chmod 755 /home/shakes/Desktop/apache2server/shakes-clips/db

# Check log
tail -f /var/log/apache2/shakes-clips-error.log
```

### Page Won't Load?
```bash
# Start Apache
sudo systemctl start apache2

# Enable site
sudo a2ensite shakes-clips

# Restart
sudo systemctl restart apache2
```

### Database Corrupted?
```bash
# Delete and recreate
rm /home/shakes/Desktop/apache2server/shakes-clips/db/comments.db
# Auto-recreates on next page load
```

## 📊 File Structure

```
shakes-clips/
├── index.html          Main page
├── config.php          Database config
├── .htaccess           Apache rules
├── api/
│   └── api.php         Backend API
├── css/
│   └── style.css       Styling
├── js/
│   └── script.js       JavaScript
├── db/                 Comments storage
└── [Documentation files]
```

## 💻 Required PHP Modules

```bash
# Check PHP has SQLite
php -m | grep sqlite

# Check PHP info
php -i | grep -i sqlite
```

## 🎯 Features Quick Summary

| Feature | Status | How It Works |
|---------|--------|-------------|
| Dynamic Videos | ✅ | Scan folder, auto-load |
| Comments | ✅ | Database storage |
| Responsive | ✅ | Mobile/tablet/desktop |
| Animations | ✅ | CSS transitions |
| Dark Theme | ✅ | Professional UI |
| CORS Ready | ✅ | API enabled |
| Secure | ✅ | Input validation |
| Fast | ✅ | Indexed database |

## 🔐 Security Checklist

- ✅ Input validation on forms
- ✅ Email format checking
- ✅ HTML escaping for XSS prevention
- ✅ SQL injection prevention (prepared statements)
- ✅ Sensitive files blocked from access
- ✅ CORS headers configured

## 📱 Responsive Breakpoints

- **Mobile:** < 480px (2-3 columns)
- **Tablet:** 480-1024px (3-4 columns)
- **Desktop:** > 1024px (5-6 columns)

## 🎮 User Guide

1. **Watch Video:** Click thumbnail → video opens in modal
2. **Add Comment:** Fill form → click "Post Comment"
3. **View Comments:** Scroll in comment section
4. **Delete Comment:** Click "Delete" → confirm
5. **Add Videos:** Copy files to `/videos` → refresh browser

## 🔄 API Endpoints

```
GET /api/api.php?action=getVideos
GET /api/api.php?action=getComments&video_id=ID
POST /api/api.php (add comment)
DELETE /api/api.php (delete comment)
```

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| README.md | Complete guide |
| QUICKSTART.md | Fast setup |
| INSTALLATION.md | Detailed steps |
| APACHE2_CONFIG.md | Advanced config |
| PROJECT_SUMMARY.md | Full overview |

## 🚨 Emergency Commands

```bash
# Emergency restart
sudo systemctl restart apache2

# Emergency reset
sudo systemctl restart apache2 && \
rm /home/shakes/Desktop/apache2server/shakes-clips/db/comments.db

# Emergency site enable
sudo a2ensite shakes-clips && \
sudo systemctl restart apache2

# Emergency permission fix
chmod -R 755 /home/shakes/Desktop/apache2server/shakes-clips
```

## ✨ What's Included

- ✅ Full-stack video streaming app
- ✅ Comment system with database
- ✅ Responsive mobile design
- ✅ Apache2 configuration
- ✅ Setup automation
- ✅ Complete documentation
- ✅ Quick reference guides

## 🎓 Learning Points

- REST API design with PHP
- SQLite database usage
- CSS Grid responsive layout
- JavaScript class architecture
- Apache2 virtual hosting
- Security best practices

## 🌟 Pro Tips

1. **Backup Database:** Copy comments.db before updates
2. **Test First:** Try on localhost before production
3. **Compress Videos:** Large files = slow streaming
4. **Monitor Logs:** Check errors in Apache log
5. **Cache Clearing:** Ctrl+F5 in browser for fresh load
6. **Mobile Testing:** Use Chrome DevTools (F12)

## 📞 Support

- Run: `bash check-status.sh`
- Read: README.md
- Check: Error logs
- Browse: Browser console (F12)

---

**Remember:** 
- Application path: `/home/shakes/Desktop/apache2server/shakes-clips/`
- Videos path: `/home/shakes/Desktop/apache2server/videos/`
- Browser: `http://localhost/shakes-clips/`

**Get started:**
```bash
sudo bash /home/shakes/Desktop/apache2server/shakes-clips/setup.sh
```

🎬 Enjoy Shakes Clips! 🍿
