// Shakes Clips - Main JavaScript
class ShakesClips {
    constructor() {
        this.videos = [];
        this.currentVideoId = null;
        this.apiBase = './api/api.php';
        this.colorSchemes = [
            { gradient1: 'linear-gradient(135deg, #004e89 0%, #ff6b35 100%)', gradient2: 'linear-gradient(135deg, #1a1a2e 0%, #e94560 100%)', gradient3: 'linear-gradient(135deg, #0f3460 0%, #533483 100%)', gradient4: 'linear-gradient(135deg, #2d0a4e 0%, #ff006e 100%)' },
            { gradient1: 'linear-gradient(135deg, #1a472a 0%, #ff006e 100%)', gradient2: 'linear-gradient(135deg, #2d1b4e 0%, #ff6b35 100%)', gradient3: 'linear-gradient(135deg, #003d5c 0%, #ffa502 100%)', gradient4: 'linear-gradient(135deg, #1a0033 0%, #00d4ff 100%)' },
            { gradient1: 'linear-gradient(135deg, #5a0a0a 0%, #ff1744 100%)', gradient2: 'linear-gradient(135deg, #1a1a4d 0%, #00bfff 100%)', gradient3: 'linear-gradient(135deg, #2d5a0a 0%, #76ff03 100%)', gradient4: 'linear-gradient(135deg, #4d0a4d 0%, #ff00ff 100%)' },
            { gradient1: 'linear-gradient(135deg, #0d47a1 0%, #ff6f00 100%)', gradient2: 'linear-gradient(135deg, #1b5e20 0%, #e91e63 100%)', gradient3: 'linear-gradient(135deg, #37474f 0%, #ffeb3b 100%)', gradient4: 'linear-gradient(135deg, #4a148c 0%, #00e5ff 100%)' }
        ];
        this.currentColorScheme = 0;
        this.init();
    }

    async init() {
        await this.loadVideos();
        this.setupEventListeners();
        this.startColorRotation();
    }

    startColorRotation() {
        setInterval(() => {
            this.changeColors();
        }, 30000); // Change colors every 30 seconds
    }

    changeColors() {
        this.currentColorScheme = (this.currentColorScheme + 1) % this.colorSchemes.length;
        const scheme = this.colorSchemes[this.currentColorScheme];
        const root = document.documentElement;
        
        root.style.setProperty('--gradient-1', scheme.gradient1);
        root.style.setProperty('--gradient-2', scheme.gradient2);
        root.style.setProperty('--gradient-3', scheme.gradient3);
        root.style.setProperty('--gradient-4', scheme.gradient4);
    }

    async loadVideos() {
        try {
            const response = await fetch(`${this.apiBase}?action=getVideos`);
            const data = await response.json();
            
            if (Array.isArray(data)) {
                this.videos = data;
                this.renderVideoGrid();
            } else {
                this.showError('Failed to load videos');
            }
        } catch (error) {
            console.error('Error loading videos:', error);
            this.showError('Error loading videos');
        }
    }

    renderVideoGrid() {
        const gridContainer = document.getElementById('videoGrid');
        
        if (this.videos.length === 0) {
            gridContainer.innerHTML = '<p style="grid-column: 1/-1; text-align: center; padding: 40px; color: #b0b0b0;">No videos found</p>';
            return;
        }

        gridContainer.innerHTML = this.videos.map(video => `
            <div class="video-card" onclick="shakesClips.openVideoModal('${video.id}', '${this.escapeHtml(video.title)}', '${video.path}')">
                <div class="video-thumbnail"></div>
                <div class="video-info">
                    <div class="video-title">${this.escapeHtml(video.title)}</div>
                    <div class="video-meta">${this.formatFileSize(video.size)}</div>
                </div>
            </div>
        `).join('');
    }

    async openVideoModal(videoId, title, videoPath) {
        this.currentVideoId = videoId;
        const modal = document.getElementById('videoModal');
        const videoPlayer = document.getElementById('videoPlayer');
        const modalTitle = document.querySelector('.comments-header');

        videoPlayer.src = videoPath;
        modalTitle.textContent = title;

        modal.classList.add('active');
        await this.loadComments();
        this.clearCommentForm();
    }

    closeVideoModal() {
        const modal = document.getElementById('videoModal');
        const videoPlayer = document.getElementById('videoPlayer');
        
        videoPlayer.pause();
        videoPlayer.src = '';
        modal.classList.remove('active');
        this.currentVideoId = null;
    }

    async loadComments() {
        if (!this.currentVideoId) return;

        try {
            const response = await fetch(`${this.apiBase}?action=getComments&video_id=${encodeURIComponent(this.currentVideoId)}`);
            const comments = await response.json();
            this.renderComments(comments);
        } catch (error) {
            console.error('Error loading comments:', error);
        }
    }

    renderComments(comments) {
        const commentsList = document.getElementById('commentsList');

        if (!Array.isArray(comments) || comments.length === 0) {
            commentsList.innerHTML = '<div class="no-comments">No comments yet. Be the first to comment!</div>';
            return;
        }

        commentsList.innerHTML = comments.map(comment => `
            <div class="comment">
                <div class="comment-author">${this.escapeHtml(comment.name)}</div>
                <div class="comment-text">${this.escapeHtml(comment.comment)}</div>
                <div class="comment-meta">
                    <span>${this.formatDate(comment.created_at)}</span>
                    <button class="delete-comment-btn" onclick="shakesClips.deleteComment(${comment.id})">Delete</button>
                </div>
            </div>
        `).join('');
    }

    async submitComment(e) {
        e.preventDefault();

        const nameInput = document.getElementById('commentName');
        const emailInput = document.getElementById('commentEmail');
        const commentInput = document.getElementById('commentText');
        const submitBtn = e.target.querySelector('.submit-btn');

        const name = nameInput.value.trim();
        const email = emailInput.value.trim();
        const comment = commentInput.value.trim();

        // Validation
        if (!name || !email || !comment) {
            this.showAlert('All fields are required', 'error');
            return;
        }

        if (name.length < 2 || name.length > 100) {
            this.showAlert('Name must be between 2 and 100 characters', 'error');
            return;
        }

        if (!this.validateEmail(email)) {
            this.showAlert('Please enter a valid email', 'error');
            return;
        }

        submitBtn.disabled = true;
        submitBtn.textContent = 'Posting...';

        try {
            const response = await fetch(this.apiBase, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    action: 'addComment',
                    video_id: this.currentVideoId,
                    name: name,
                    email: email,
                    comment: comment
                })
            });

            const result = await response.json();

            if (result.success) {
                this.showAlert('Comment posted successfully!', 'success');
                this.clearCommentForm();
                await this.loadComments();
            } else {
                this.showAlert(result.error || 'Failed to post comment', 'error');
            }
        } catch (error) {
            console.error('Error posting comment:', error);
            this.showAlert('Error posting comment', 'error');
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Post Comment';
        }
    }

    async deleteComment(commentId) {
        if (!confirm('Are you sure you want to delete this comment?')) {
            return;
        }

        try {
            const response = await fetch(this.apiBase, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    action: 'deleteComment',
                    comment_id: commentId
                })
            });

            const result = await response.json();

            if (result.success) {
                this.showAlert('Comment deleted', 'success');
                await this.loadComments();
            } else {
                this.showAlert(result.error || 'Failed to delete comment', 'error');
            }
        } catch (error) {
            console.error('Error deleting comment:', error);
            this.showAlert('Error deleting comment', 'error');
        }
    }

    clearCommentForm() {
        document.getElementById('commentForm').reset();
    }

    setupEventListeners() {
        const closeBtn = document.querySelector('.close-btn');
        const modal = document.getElementById('videoModal');
        const commentForm = document.getElementById('commentForm');

        closeBtn.addEventListener('click', () => this.closeVideoModal());

        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                this.closeVideoModal();
            }
        });

        commentForm.addEventListener('submit', (e) => this.submitComment(e));

        // Keyboard shortcut to close modal
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && modal.classList.contains('active')) {
                this.closeVideoModal();
            }
        });
    }

    validateEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }

    formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        const now = new Date();
        const diff = now - date;

        const seconds = Math.floor(diff / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);

        if (seconds < 60) return 'just now';
        if (minutes < 60) return `${minutes}m ago`;
        if (hours < 24) return `${hours}h ago`;
        if (days < 7) return `${days}d ago`;

        return date.toLocaleDateString('en-US', { 
            month: 'short', 
            day: 'numeric',
            year: date.getFullYear() !== now.getFullYear() ? 'numeric' : undefined
        });
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    showAlert(message, type = 'success') {
        const alertContainer = document.getElementById('alertContainer');
        const alertClass = type === 'success' ? 'alert-success' : 'alert-error';
        
        const alertEl = document.createElement('div');
        alertEl.className = `alert ${alertClass}`;
        alertEl.textContent = message;
        
        alertContainer.appendChild(alertEl);

        setTimeout(() => {
            alertEl.remove();
        }, 3000);
    }

    showError(message) {
        const gridContainer = document.getElementById('videoGrid');
        gridContainer.innerHTML = `<p style="grid-column: 1/-1; text-align: center; padding: 40px; color: #f44336;">${this.escapeHtml(message)}</p>`;
    }
}

// Initialize when DOM is ready
let shakesClips;
document.addEventListener('DOMContentLoaded', () => {
    shakesClips = new ShakesClips();
});
