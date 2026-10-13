#!/usr/bin/env bash
set -euo pipefail

# Export Go present slides to standalone static HTML/assets
OUTPUT_DIR="${1:-public}"
PORT="3997"

echo "📦 Exporting Vibe Coding Workshop slides to '${OUTPUT_DIR}'..."

# Ensure present binary exists
if ! command -v present >/dev/null 2>&1; then
    if [ -x "$(go env GOPATH 2>/dev/null)/bin/present" ]; then
        PRESENT_BIN="$(go env GOPATH)/bin/present"
    else
        echo "🔧 Installing golang.org/x/tools/cmd/present@latest..."
        go install golang.org/x/tools/cmd/present@latest
        PRESENT_BIN="$(go env GOPATH)/bin/present"
    fi
else
    PRESENT_BIN="present"
fi

# Create target directories
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/static"
mkdir -p "${OUTPUT_DIR}/images"

# Start present in background
"${PRESENT_BIN}" -http="127.0.0.1:${PORT}" -play=false &
PRESENT_PID=$!

cleanup() {
    kill "${PRESENT_PID}" 2>/dev/null || true
}
trap cleanup EXIT

# Wait for server to become responsive
for i in {1..15}; do
    if curl -s "http://127.0.0.1:${PORT}/vibecoding.slide" >/dev/null 2>&1; then
        break
    fi
    sleep 0.5
done

# Fetch slide HTML and fix root-relative asset URLs, unhide body, and link stylesheet
curl -s "http://127.0.0.1:${PORT}/vibecoding.slide" \
    | sed 's|src="/static/slides.js"|src="static/slides.js"|g' \
    | sed "s|src='/static/slides.js'|src='static/slides.js'|g" \
    | sed "s|<body style='display: none'>|<body>|g" \
    | sed "s|</head>|<link rel='stylesheet' href='static/styles.css'></head>|g" \
    > "${OUTPUT_DIR}/index.html"

# Fetch JavaScript and CSS assets, making static asset prefix relative for subpaths
curl -s "http://127.0.0.1:${PORT}/static/slides.js" \
    | sed "s|var PERMANENT_URL_PREFIX = '/static/';|var PERMANENT_URL_PREFIX = 'static/';|g" \
    > "${OUTPUT_DIR}/static/slides.js"

curl -s "http://127.0.0.1:${PORT}/static/styles.css" > "${OUTPUT_DIR}/static/styles.css"

# Copy images
if [ -d "images" ]; then
    cp -r images/* "${OUTPUT_DIR}/images/"
fi

# Add .nojekyll for GitHub Pages
touch "${OUTPUT_DIR}/.nojekyll"

echo "✅ Successfully exported slides to '${OUTPUT_DIR}/index.html'!"
echo "   You can test locally with: python3 -m http.server 8000 -d ${OUTPUT_DIR}"
