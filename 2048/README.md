# 🎮 2048 Python Web App

An interactive, full-stack **2048 Game** built with Python (Flask), SQLite, and Vanilla JavaScript. Developed as the hands-on reference project for the **Vibe Coding Workshop** to illustrate how AI prompts translate into production-ready web software with zero boilerplate friction.

---

## ✨ Features

- **Classic 2048 Mechanics**: Smooth tile merging, sliding animations, score accumulation, and game-over detection.
- **Player Accounts & Session Tracking**: Enter any username to create an isolated game session.
- **Automatic State Persistence**: Every move automatically saves current score and board layout to SQLite via `/api/save`.
- **Resume Anytime**: Returning players pick up right where they left off.
- **High Scores & Leaderboard**: Real-time top 10 leaderboard ranking players by highest achieved score (`/leaderboard`).
- **Zero-Friction Startup**: Automatically opens the browser on `http://127.0.0.1:5000/` when launched.

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Backend** | [Python](https://www.python.org/) (>= 3.10) & [Flask](https://flask.palletsprojects.com/) | REST API, template routing, database controller |
| **Database** | [SQLite3](https://www.sqlite.org/) | Lightweight local persistence (`database.db`) |
| **Frontend** | Vanilla JavaScript (ES6+), HTML5, CSS3 | Grid mechanics, keyboard input, async state sync |
| **Tooling** | [uv](https://docs.astral.sh/uv/) & [Make](https://www.gnu.org/software/make/) | Blazingly fast dependency management and task automation |

---

## ⚡ Quickstart with `uv` (Recommended)

[`uv`](https://docs.astral.sh/uv/) is a fast, modern Python package and project manager developed by Astral. It eliminates manual virtual environment activation and dependency bottlenecks.

### 1. Install `uv` (if not already installed)

- **macOS / Linux**:
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```
  *Or via Homebrew on macOS:*
  ```bash
  brew install uv
  ```

- **Windows**:
  ```powershell
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

### 2. Run the App in One Command

Navigate into the `2048` directory and execute:

```bash
cd 2048
uv run python app.py
```

`uv` will automatically:
1. Detect Python and create an isolated environment (`.venv/`).
2. Install all required dependencies specified in `pyproject.toml`.
3. Launch the Flask web server.
4. Open your default web browser to `http://127.0.0.1:5000/`.

You can also run the packaged CLI entrypoint:
```bash
uv run 2048
```

---

## 🚀 Alternative Launch Methods

### Option A: Using `make` (Smart Detection)

The provided [`Makefile`](file:///Users/erolrecep/Developer/codebase/apps/VibeCoding-Workshop/2048/Makefile) automatically detects whether `uv` is installed and uses it; otherwise, it falls back to Python's standard `venv`:

```bash
cd 2048
make run
```

Other available Make targets:
```bash
make run-uv     # Force launch with uv
make run-venv   # Force launch with classic python3 -m venv
make clean      # Clean virtual environments, cache files, and SQLite database
make help       # Display available Make targets
```

### Option B: Standard Python Virtualenv & Pip

If you prefer classic Python virtual environment tooling:

```bash
cd 2048

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate       # On macOS/Linux
# .\venv\Scripts\activate      # On Windows

# Install dependencies
pip install -r requirements.txt

# Start application
python app.py
```

---

## 📂 Project Architecture

```
2048/
├── app.py              # Flask server, route controllers, SQLite database models
├── pyproject.toml      # Modern uv/Python project metadata & dependencies
├── requirements.txt    # Fallback pip dependency list
├── Makefile            # Automated lifecycle commands (run, clean)
├── README.md           # This documentation
├── src/
│   └── 2048/
│       └── __init__.py # CLI package entrypoint
├── templates/
│   ├── layout.html     # Base HTML layout template
│   ├── index.html      # Landing page (username prompt)
│   ├── game.html       # 2048 Game board canvas and controls
│   └── leaderboard.html# Top-10 player scoreboard
└── static/
    ├── style.css       # Board styling, tile colors, responsive layout
    └── game.js         # Client-side 2048 physics, key listeners, async autosave
```

---

## 🗄️ Database & API Schema

The application uses an SQLite database (`database.db`) initialized automatically on startup:

### Database Table: `users`

| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | `INTEGER PRIMARY KEY` | Auto-incrementing unique user ID |
| `username` | `TEXT UNIQUE` | Player username |
| `best_score` | `INTEGER DEFAULT 0` | All-time highest score achieved by player |
| `current_grid` | `TEXT` | JSON serialized 4x4 matrix of current tile values |
| `current_score`| `INTEGER DEFAULT 0` | In-progress game score |

### API Endpoints

- `GET /` — Login and user selection page.
- `POST /` — Authenticate or register a username and redirect to gameplay.
- `GET /play/<username>` — Main game view; populates existing score and saved board.
- `POST /api/save` — JSON payload (`{username, grid, score}`) invoked after every valid turn.
- `GET /leaderboard` — Leaderboard displaying the top 10 players ranked by `best_score`.

---

## 💡 Vibe Coding Workshop Challenges

Try extending this application using AI coding assistants (Gemini, Claude, ChatGPT, Cursor, Copilot). Here are prompt challenges to try:

1. **Undo Move Feature**:
   > *"Add an 'Undo' button that reverts the board to the previous state. Keep track of the last 3 states in the client-side session."*
2. **Audio & Sound Effects**:
   > *"Add subtle sound effects using HTML5 Web Audio API: a swoosh when tiles slide, and a chime when tiles merge into a higher power of 2."*
3. **Dark / Neon Theme Switcher**:
   > *"Add a theme switcher with Light, Dark, and Cyberpunk Neon presets. Save the user's theme preference in localStorage."*
4. **AI Autoplayer / Hint System**:
   > *"Implement an AI hint button using the Expectimax algorithm in JavaScript to suggest the optimal next swipe direction."*
