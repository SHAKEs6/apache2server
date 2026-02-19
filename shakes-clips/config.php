<?php
// Configuration file for Shakes Clips
define('DB_PATH', __DIR__ . '/db/comments.db');
define('VIDEOS_PATH', __DIR__ . '/../videos');

// Create database connection
function getDB() {
    try {
        $db = new PDO('sqlite:' . DB_PATH);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $db;
    } catch (PDOException $e) {
        die('Database connection failed: ' . $e->getMessage());
    }
}

// Initialize database if it doesn't exist
function initializeDB() {
    if (!file_exists(DB_PATH)) {
        $db = getDB();
        $db->exec("
            CREATE TABLE IF NOT EXISTS comments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                video_id TEXT NOT NULL,
                name TEXT NOT NULL,
                email TEXT NOT NULL,
                comment TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            );
            
            CREATE INDEX idx_video_id ON comments(video_id);
        ");
    }
}

// Initialize on first load
initializeDB();
?>
