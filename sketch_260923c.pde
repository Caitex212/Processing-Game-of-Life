// --------------------------------------------

PVector screenSize = new PVector(1920,1080);
int alivePercentage = 20; // 100% results in every cell dying because of overpopulation
int cellSize = 10;

// --------------------------------------------
PVector gridSize = new PVector(screenSize.x / cellSize, screenSize.y / cellSize);

int windowW = (int)(gridSize.x * cellSize);
int windowH = (int)(gridSize.y * cellSize);

boolean[][] grid;
boolean[][] newGrid = new boolean[(int)gridSize.x][(int)gridSize.y];

boolean running = true;

void settings() {
  size(windowW, windowH);
}

void setup() {
  frameRate(6);
  background(0);
  grid = randomize();
}

void draw() {
  if (running) {
    nextStep();
  
    renderFrame();
  }
}

boolean[][] randomize() {
  boolean[][] array = new boolean[(int)gridSize.x][(int)gridSize.y];
  for (int x = 0; x < gridSize.x; x++) {
    for (int y = 0; y < gridSize.y; y++) {
      array[x][y] = random(1) < ((float)alivePercentage / 100);
    }
  }
  
  return array;
}

void nextStep() {
  for (int x = 0; x < gridSize.x; x++) {
    for (int y = 0; y < gridSize.y; y++) {
      boolean alive = grid[x][y];
      int counter = countNeighbours(x, y);
      if (alive) {
        newGrid[x][y] = (counter == 2 || counter == 3); // survive
      } else {
        newGrid[x][y] = (counter == 3);                 // birth
      }
    }
  }
  grid = newGrid;
  newGrid = new boolean[(int)gridSize.x][(int)gridSize.y];
}

int countNeighbours(int x, int y) {
  int counter = 0;
  for (int lx = -1; lx <= 1; lx++) {
    for (int ly = -1; ly <= 1; ly++) {
      if (ly == 0 && lx == 0) {
        continue;
      }
      
      int ty = y + ly;
      int tx = x + lx;
      
      if (ty >= 0 && tx >= 0 && ty < gridSize.y && tx < gridSize.x) {
        if (grid[tx][ty]) {
          counter++;
        }
      }
    }
  }
  return counter;
}

void renderFrame() {
  for (int x = 0; x < gridSize.x; x++) {
    for (int y = 0; y < gridSize.y; y++) {
      strokeWeight(1);
      stroke(150);
      if (grid[x][y]) {
        fill(255);
      } else {
        fill(0);
      }
      square(x * cellSize, y * cellSize, cellSize);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    running = !running;
  }
  if (key == CODED) {
    if (keyCode == RIGHT && !running) {
      nextStep();
      renderFrame();
    }
  }
}
