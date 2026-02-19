#!/bin/bash
# Quick start script - runs Shakes Clips on PHP's built-in server

PORT=8000
APP_PATH="/home/shakes/Desktop/apache2server/shakes-clips"

echo "🎬 Starting Shakes Clips on PHP Built-in Server"
echo "=================================================="
echo ""
echo "✅ Access the application at:"
echo "   http://localhost:$PORT/"
echo ""
echo "Press CTRL+C to stop the server"
echo ""
echo "Opening browser in 2 seconds..."
echo ""

sleep 2

# Try to open in default browser
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:$PORT/" &
elif command -v open &> /dev/null; then
    open "http://localhost:$PORT/" &
fi

cd "$APP_PATH"
php -S localhost:$PORT
