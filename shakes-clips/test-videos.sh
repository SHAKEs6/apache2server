#!/bin/bash
# Test Videos Setup

echo "🎬 Testing Shakes Clips Video Setup"
echo "===================================="
echo ""

# Test 1: Check videos exist
echo "Test 1: Checking videos folder..."
VIDEO_COUNT=$(find /home/shakes/Desktop/apache2server/videos -type f | wc -l)
if [ "$VIDEO_COUNT" -gt 0 ]; then
    echo "✅ Found $VIDEO_COUNT video files"
else
    echo "❌ No videos found"
    exit 1
fi

# Test 2: Check permissions
echo ""
echo "Test 2: Checking folder permissions..."
if [ -r /home/shakes/Desktop/apache2server/videos ]; then
    echo "✅ Videos folder is readable"
else
    echo "❌ Videos folder is not readable"
    echo "   Run: chmod 755 /home/shakes/Desktop/apache2server/videos"
fi

# Test 3: Test API if Apache is running
echo ""
echo "Test 3: Testing API endpoint..."
if command -v curl &> /dev/null; then
    if curl -s http://localhost/shakes-clips/api/api.php?action=getVideos | grep -q "title"; then
        echo "✅ API is returning videos"
        echo "   Sample response:"
        curl -s http://localhost/shakes-clips/api/api.php?action=getVideos | head -c 300
        echo ""
    else
        echo "⚠️  API not responding or videos not found"
        echo "   Make sure Apache2 is running and setup.sh has been run"
        echo "   Try: sudo systemctl restart apache2"
    fi
else
    echo "⚠️  curl not available, skipping API test"
fi

# Test 4: Check Apache configuration
echo ""
echo "Test 4: Checking Apache configuration..."
if sudo apache2ctl -S 2>/dev/null | grep -q "shakes-clips"; then
    echo "✅ Shakes Clips site is configured"
    if sudo apache2ctl -S 2>/dev/null | grep -q "/videos"; then
        echo "✅ Videos alias is configured"
    else
        echo "⚠️  Videos alias not found in config"
    fi
else
    echo "⚠️  Shakes Clips site not enabled"
    echo "   Run: sudo bash setup.sh"
fi

# Test 5: Check if Apache is running
echo ""
echo "Test 5: Checking Apache2 status..."
if sudo systemctl is-active --quiet apache2; then
    echo "✅ Apache2 is running"
else
    echo "❌ Apache2 is not running"
    echo "   Start it with: sudo systemctl start apache2"
fi

echo ""
echo "===================================="
echo "✅ Video setup test complete!"
echo ""
echo "If all tests passed, you should be able to:"
echo "1. Open: http://localhost/shakes-clips/"
echo "2. See videos in the grid"
echo "3. Click a video to play it"
echo ""
