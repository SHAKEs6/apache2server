# 🚀 Shakes Clips - Quick Start Guide

## For the Impatient!

### 1-Minute Setup (if Apache2 is already running)

```bash
# Navigate to the app directory
cd /home/shakes/Desktop/apache2server/shakes-clips

# Check the status
bash check-status.sh

# If everything is green ✅, open in browser:
# http://localhost/shakes-clips/
```

### Full Setup (if Apache2 needs configuration)

```bash
# Step 1: Run the setup script (requires sudo)
sudo bash /home/shakes/Desktop/apache2server/shakes-clips/setup.sh

# Step 2: Verify everything is working
bash /home/shakes/Desktop/apache2server/shakes-clips/check-status.sh

# Step 3: Open in browser
# http://localhost/shakes-clips/
```

## What You Get

✅ **Automatic Video Loading** - Add videos to `/videos`, they appear instantly
✅ **Working Comments** - Real comment system with database storage
✅ **Beautiful UI** - Modern dark theme that works on all devices
✅ **Zero Configuration** - Once setup, it just works!

## Adding Videos

Just copy video files to the videos folder:

```bash
cp ~/my-video.mp4 /home/shakes/Desktop/apache2server/videos/
# OR
cp ~/my-series/*.mkv /home/shakes/Desktop/apache2server/videos/
```

That's it! Refresh your browser and they'll appear.

## File Structure Overview

```
shakes-clips/
├── index.html          ← Open this in your browser (but use the URL!)
├── config.php          ← Database configuration (auto-creates DB)
├── api/api.php         ← Backend that handles videos & comments
├── css/style.css       ← The beautiful styling
├── js/script.js        ← JavaScript magic ✨
├── db/                 ← Where comments are stored
├── setup.sh            ← Run this once to configure Apache2
└── check-status.sh     ← Run this to verify everything works
```

## Browser Access

**Local Machine:**
```
http://localhost/shakes-clips/
```

**From Another Machine (if on same network):**
```
http://<your-ip>/shakes-clips/
```

**With Domain Setup:**
```
http://shakes-clips.local/
```

## First Time Setup Checklist

- [ ] Apache2 is installed and running
- [ ] PHP is installed with SQLite support
- [ ] Run `sudo bash setup.sh`
- [ ] Check status with `bash check-status.sh`
- [ ] Videos are in `/videos` folder
- [ ] Open application in browser
- [ ] Try clicking a video and adding a comment

## Troubleshooting Quick Fixes

### "Can't see videos"
```bash
ls -la /home/shakes/Desktop/apache2server/videos/
# Should show your video files
```

### "Can't post comments"
```bash
chmod 755 /home/shakes/Desktop/apache2server/shakes-clips/db
# Check Apache error log:
tail -f /var/log/apache2/error.log
```

### "Page won't load"
```bash
# Check if Apache is running
sudo systemctl status apache2

# Check if site is enabled
sudo a2ensite shakes-clips

# Restart Apache
sudo systemctl restart apache2
```

### "Database issues"
```bash
# Reset the database
rm /home/shakes/Desktop/apache2server/shakes-clips/db/comments.db

# It will be recreated automatically on next access
```

## Features You Can Use

🎬 **Watch Videos**
- Click any video to open the player
- Press ESC or click close to exit
- Videos play directly in the browser

💬 **Comment System**
- Add your name, email, and comment
- See all comments for each video
- Delete comments (no moderation needed)

📱 **Mobile Ready**
- Works perfectly on phones and tablets
- Touch-friendly interface
- Responsive design adjusts to any screen

🎨 **Customize Colors**
- Edit `css/style.css` to change theme colors
- Look for the `:root` section at the top

## Performance Tips

1. **Large Video Files?** - Consider video quality/format
2. **Many Videos?** - Organize them in folders externally
3. **Slow Database?** - It's SQLite, it's fast! ⚡
4. **Comments Not Loading?** - Check browser console (F12)

## Common Questions

**Q: Can I password protect it?**
Add authentication to Apache2 using .htpasswd

**Q: Can I add categories/folders?**
Yes! Modify `js/script.js` to group videos by folder

**Q: Can I upload videos through the web interface?**
Currently no, but you can add this feature

**Q: Does it work on Windows?**
Yes, if you have Apache2 + PHP running on Windows

**Q: Can multiple people use it at the same time?**
Yes! It's designed for concurrent access

## Getting Help

1. Check [README.md](README.md) for detailed documentation
2. Run `bash check-status.sh` to diagnose issues
3. Check Apache error log: `tail -f /var/log/apache2/error.log`
4. Check browser console: Press F12 in your browser

## Next Steps

- 🎨 Customize the colors in `css/style.css`
- 📹 Add more videos to the `/videos` folder
- 💾 Learn about comment database queries
- 🚀 Deploy to a real server (same setup works!)

---

**Ready? Open your browser to: http://localhost/shakes-clips/**

Enjoy! 🎬🍿
