const board = document.getElementById('game-board');

// Renders the JS array into the HTML grid
function draw() {
    board.innerHTML = '';
    for (let r = 0; r < 4; r++) {
        for (let c = 0; c < 4; c++) {
            let val = grid[r][c];
            let tile = document.createElement('div');
            tile.className = 'tile';
            tile.dataset.val = val;
            tile.innerText = val > 0 ? val : '';
            board.appendChild(tile);
        }
    }
    document.getElementById('score').innerText = score;
}

function addRandomTile() {
    let empty = [];
    for (let r=0; r<4; r++)
        for (let c=0; c<4; c++)
            if (grid[r][c] === 0) empty.push({r, c});
    
    if (empty.length > 0) {
        let pos = empty[Math.floor(Math.random() * empty.length)];
        grid[pos.r][pos.c] = Math.random() < 0.9 ? 2 : 4;
    }
}

// Sends current state back to Python via hidden background request
function saveState() {
    fetch('/api/save', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({username: USERNAME, grid: grid, score: score})
    });
}

// Core sliding logic
function operate(row) {
    row = row.filter(val => val); // strip zeros
    for (let i = 0; i < row.length - 1; i++) {
        if (row[i] === row[i+1]) {
            row[i] *= 2;
            score += row[i];
            row[i+1] = 0;
        }
    }
    row = row.filter(val => val); // strip zeros created by merges
    while (row.length < 4) row.push(0); // pad back to length 4
    return row;
}

function moveLeft() {
    let changed = false;
    for (let r = 0; r < 4; r++) {
        let oldRow = [...grid[r]];
        grid[r] = operate(grid[r]);
        if (oldRow.join(',') !== grid[r].join(',')) changed = true;
    }
    return changed;
}

function moveRight() {
    let changed = false;
    for (let r = 0; r < 4; r++) {
        let oldRow = [...grid[r]];
        grid[r] = operate(grid[r].reverse()).reverse();
        if (oldRow.join(',') !== grid[r].join(',')) changed = true;
    }
    return changed;
}

function moveUp() {
    let changed = false;
    for (let c = 0; c < 4; c++) {
        let col = [grid[0][c], grid[1][c], grid[2][c], grid[3][c]];
        let oldCol = [...col];
        let newCol = operate(col);
        for (let r = 0; r < 4; r++) grid[r][c] = newCol[r];
        if (oldCol.join(',') !== newCol.join(',')) changed = true;
    }
    return changed;
}

function moveDown() {
    let changed = false;
    for (let c = 0; c < 4; c++) {
        let col = [grid[0][c], grid[1][c], grid[2][c], grid[3][c]];
        let oldCol = [...col];
        let newCol = operate(col.reverse()).reverse();
        for (let r = 0; r < 4; r++) grid[r][c] = newCol[r];
        if (oldCol.join(',') !== newCol.join(',')) changed = true;
    }
    return changed;
}

// Key listeners
document.addEventListener('keydown', e => {
    let changed = false;
    if (e.key === 'ArrowLeft') changed = moveLeft();
    else if (e.key === 'ArrowRight') changed = moveRight();
    else if (e.key === 'ArrowUp') changed = moveUp();
    else if (e.key === 'ArrowDown') changed = moveDown();

    if (changed) {
        addRandomTile();
        draw();
        saveState();
    }
});

// Init game on load
if (grid.flat().every(v => v === 0)) {
    addRandomTile();
    addRandomTile();
}
draw();

