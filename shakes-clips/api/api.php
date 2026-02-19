<?php
ini_set('pcre.jit', 0);
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once __DIR__ . '/../config.php';

// Check for action in GET params first, then in POST body
$action = $_GET['action'] ?? '';

if (empty($action) && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $action = $input['action'] ?? '';
}

switch ($action) {
    case 'getVideos':
        getVideos();
        break;
    case 'getComments':
        getComments();
        break;
    case 'addComment':
        addComment();
        break;
    case 'deleteComment':
        deleteComment();
        break;
    default:
        echo json_encode(['error' => 'Invalid action']);
}

function getVideos() {
    $videosPath = VIDEOS_PATH;
    $videos = [];
    
    if (is_dir($videosPath)) {
        $files = scandir($videosPath);
        foreach ($files as $file) {
            if ($file === '.' || $file === '..') continue;
            
            $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            if (in_array($ext, ['mp4', 'mkv', 'avi', 'mov', 'webm'])) {
                $filePath = $videosPath . '/' . $file;
                $videos[] = [
                    'id' => md5($file),
                    'title' => pathinfo($file, PATHINFO_FILENAME),
                    'filename' => $file,
                    'size' => filesize($filePath),
                    'path' => '/videos/' . rawurlencode($file)
                ];
            }
        }
    }
    
    // Sort by filename
    usort($videos, function($a, $b) {
        return strcmp($a['filename'], $b['filename']);
    });
    
    echo json_encode($videos);
}

function getComments() {
    $videoId = $_GET['video_id'] ?? '';
    
    if (empty($videoId)) {
        echo json_encode(['error' => 'Video ID required']);
        return;
    }
    
    $db = getDB();
    $stmt = $db->prepare('SELECT id, name, comment, created_at FROM comments WHERE video_id = ? ORDER BY created_at DESC LIMIT 100');
    $stmt->execute([$videoId]);
    $comments = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($comments);
}

function addComment() {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $videoId = $input['video_id'] ?? '';
    $name = $input['name'] ?? '';
    $email = $input['email'] ?? '';
    $comment = $input['comment'] ?? '';
    
    if (empty($videoId) || empty($name) || empty($email) || empty($comment)) {
        echo json_encode(['error' => 'All fields are required']);
        return;
    }
    
    // Basic validation
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(['error' => 'Invalid email']);
        return;
    }
    
    if (strlen($comment) < 2 || strlen($comment) > 1000) {
        echo json_encode(['error' => 'Comment must be between 2 and 1000 characters']);
        return;
    }
    
    $db = getDB();
    $stmt = $db->prepare('INSERT INTO comments (video_id, name, email, comment) VALUES (?, ?, ?, ?)');
    
    try {
        $stmt->execute([$videoId, $name, $email, $comment]);
        echo json_encode(['success' => true, 'message' => 'Comment added']);
    } catch (Exception $e) {
        echo json_encode(['error' => 'Failed to add comment']);
    }
}

function deleteComment() {
    $input = json_decode(file_get_contents('php://input'), true);
    $commentId = $input['comment_id'] ?? '';
    
    if (empty($commentId)) {
        echo json_encode(['error' => 'Comment ID required']);
        return;
    }
    
    $db = getDB();
    $stmt = $db->prepare('DELETE FROM comments WHERE id = ?');
    
    try {
        $stmt->execute([$commentId]);
        echo json_encode(['success' => true, 'message' => 'Comment deleted']);
    } catch (Exception $e) {
        echo json_encode(['error' => 'Failed to delete comment']);
    }
}
?>
