import sqlite3
import json
import webbrowser
from threading import Timer
from flask import Flask, render_template, request, redirect, url_for, jsonify

app = Flask(__name__)
DB_FILE = 'database.db'

def get_db():
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with get_db() as conn:
        conn.execute('''CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            best_score INTEGER DEFAULT 0,
            current_grid TEXT,
            current_score INTEGER DEFAULT 0
        )''')
        conn.commit()

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form['username'].strip()
        if username:
            with get_db() as conn:
                # Create the user if they don't exist yet
                conn.execute('INSERT OR IGNORE INTO users (username) VALUES (?)', (username,))
                conn.commit()
            return redirect(url_for('play', username=username))
    return render_template('index.html')

@app.route('/play/<username>')
def play(username):
    with get_db() as conn:
        user = conn.execute('SELECT * FROM users WHERE username = ?', (username,)).fetchone()
        if not user:
            return redirect(url_for('index'))
        
        # Load saved grid or generate a fresh 4x4 array of zeros
        grid = user['current_grid'] if user['current_grid'] else json.dumps([[0]*4 for _ in range(4)])
        return render_template('game.html', username=username, grid=grid, score=user['current_score'])

@app.route('/api/save', methods=['POST'])
def save_game():
    data = request.json
    username = data.get('username')
    grid = json.dumps(data.get('grid'))
    score = data.get('score')

    with get_db() as conn:
        user = conn.execute('SELECT best_score FROM users WHERE username = ?', (username,)).fetchone()
        if user:
            best = max(user['best_score'], score)
            conn.execute('''UPDATE users 
                            SET current_grid = ?, current_score = ?, best_score = ? 
                            WHERE username = ?''', (grid, score, best, username))
            conn.commit()
    return jsonify({"status": "success"})

@app.route('/leaderboard')
def leaderboard():
    with get_db() as conn:
        users = conn.execute('SELECT username, best_score FROM users ORDER BY best_score DESC LIMIT 10').fetchall()
    return render_template('leaderboard.html', users=users)

def open_browser():
    webbrowser.open_new('http://127.0.0.1:5000/')

if __name__ == '__main__':
    init_db()
    # Automatically open the browser 1 second after server starts
    Timer(1, open_browser).start()
    app.run(debug=True, port=5000)

