
Planet player;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<BackgroundStar> bgStars = new ArrayList<BackgroundStar>();
ExitPortal portal;
int currentLevel = 1;
int restartButtonX, restartButtonY, restartButtonW = 180, restartButtonH = 50;
boolean playEndingAnimation = false;
float shipX, shipY;
ArrayList<PVector> otherPlanets = new ArrayList<PVector>();
int protectionStartTime = 0;
int protectionDuration = 1000; 
boolean endingReady = false;
float endingStartTime = 0;
int replayButtonX, replayButtonY, replayButtonW = 150, replayButtonH = 40;
int exitButtonX, exitButtonY, exitButtonW = 150, exitButtonH = 40;
float playerAngle = HALF_PI; 
PImage sunFace;


boolean gameStarted = false;
boolean gameOver = false;
boolean youWin = false;
boolean portalActive = false;

int buttonX, buttonY, buttonW = 150, buttonH = 50;

int score = 0;
int timeLeft = 60;
int lastTimeCheck;

PFont retroFont;

void setup() {
  sunFace = loadImage("annoyingSun.png");
sunFace.resize(90, 90); 

  fullScreen(P3D);
  player = new Planet(width/2, height/2);

  for (int i = 0; i < 200; i++) {
    bgStars.add(new BackgroundStar());
  }

  portal = new ExitPortal();
  buttonX = width / 2 - buttonW / 2;
  buttonY = height - 150;
  lastTimeCheck = millis();

  try {
    retroFont = createFont("PressStart2P-Regular.ttf", 18);
    textFont(retroFont);
  } catch (Exception e) {
    println("⚠️ Font bulunamadı!");
    retroFont = createFont("Arial", 18);
    textFont(retroFont);
  }

  restartButtonX = width/2 - restartButtonW/2;
  restartButtonY = height/2 + 60;

  setupLevel(1);
  replayButtonX = width / 2 - 160;
replayButtonY = height - 100;

exitButtonX = width / 2 + 10;
exitButtonY = height - 100;

}

void setupLevel(int level) {
  enemies.clear();
  stars.clear();

  int numEnemies = 3;
  float speed = 2;

  if (level == 2) {
    numEnemies = 4;
    speed = 3.5;
  } else if (level == 3) {
    numEnemies = 6;
    speed = 5;
  }

  for (int i = 0; i < numEnemies; i++) {
    enemies.add(new Enemy(speed));
  }

  for (int i = 0; i < 10; i++) {
    float x = random(100, width - 100);
    float y = random(100, height - 200);
    stars.add(new Star(x, y));
  }
  protectionStartTime = millis(); 

}

void draw() {
  background(0);

  for (BackgroundStar bs : bgStars) {
    bs.update();
    bs.display();
  }

  lights();
  cameraControl();

  if (!gameStarted) {
    drawMenu();
  } else if (gameOver) {
    drawGameOver();
  } else if (youWin && !playEndingAnimation) {
    playEndingAnimation = true;
    startEndingAnimation();
  } else if (playEndingAnimation) {
    drawEndingAnimation();
  } else if (youWin) {
    
  } else {
    updateGame();
  }
}


void updateGame() {
  player.update();
  player.display();

 
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star s = stars.get(i);
    s.display();
    if (dist(player.x, player.y, s.x, s.y) < 40) {
      stars.remove(i);
      score++;
    }
  }

  
  for (Enemy e : enemies) {
    e.update();
    e.display();

    
    if (millis() - protectionStartTime > protectionDuration) {
      if (dist(player.x, player.y, e.x, e.y) < 50) {
        gameOver = true;
      }
    }
  }

 
  if (stars.size() == 0) {
    if (currentLevel == 1) {
      currentLevel = 2;
      setupLevel(2);
    } else if (currentLevel == 2) {
      currentLevel = 3;
      setupLevel(3);
    } else if (currentLevel == 3 && !portalActive) {
      portalActive = true;
    }
  }

  
  if (portalActive) {
    portal.display();
    if (portal.isPlayerInside(player.x, player.y)) {
      youWin = true;
    }
  }

 
  displayHUD();

  if (millis() - protectionStartTime < protectionDuration) {
    textFont(retroFont);
    fill(255, 255, 0);
    textAlign(CENTER);
    textSize(14);
    text("🛡️ PROTECTED", width / 2, 40);
  }

  if (millis() - lastTimeCheck >= 1000) {
    timeLeft--;
    lastTimeCheck = millis();
  }

  if (timeLeft <= 0) {
    gameOver = true;
  }
}


void displayHUD() {
  textFont(retroFont);
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Score: " + score, 30, 30);
  text("Time: " + timeLeft, 30, 60);
  text("Level: " + currentLevel, 30, 90);
}

void drawGameOver() {
  textFont(retroFont);
  fill(255, 0, 0);
  textSize(28);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/2 - 30);

  fill(0, 150, 0);
  stroke(255);
  rect(restartButtonX, restartButtonY, restartButtonW, restartButtonH, 10);

  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("RESTART", restartButtonX + restartButtonW/2, restartButtonY + restartButtonH/2);
}

void drawMenu() {
  textFont(retroFont);
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text("Milky Way Rescue", width/2, 100);

  drawRotatingStarsAroundPlayer(); 
  drawStartButton();
}


void drawStartButton() {
  fill(0, 150, 0);
  stroke(255);
  rect(buttonX, buttonY, buttonW, buttonH, 10);

  fill(255);
  textFont(retroFont);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("START", buttonX + buttonW/2, buttonY + buttonH/2);
}

void mousePressed() {

  if (!gameStarted &&
      mouseX > buttonX && mouseX < buttonX + buttonW &&
      mouseY > buttonY && mouseY < buttonY + buttonH) {
    gameStarted = true;
  }

  if (gameOver &&
      mouseX > restartButtonX && mouseX < restartButtonX + restartButtonW &&
      mouseY > restartButtonY && mouseY < restartButtonY + restartButtonH) {
    restartGame();
  }


if (playEndingAnimation) {
  if (mouseX > replayButtonX && mouseX < replayButtonX + replayButtonW &&
      mouseY > replayButtonY && mouseY < replayButtonY + replayButtonH) {
    restartGame();
    playEndingAnimation = false;
    youWin = false;
    gameStarted = true;
  }

  if (mouseX > exitButtonX && mouseX < exitButtonX + exitButtonW &&
      mouseY > exitButtonY && mouseY < exitButtonY + exitButtonH) {
    exit(); 
  }
}


}

void cameraControl() {
  float camX = width / 2.0;
  float camY = height / 2.0;
  float camZ = (height / 2.0) / tan(PI * 30.0 / 180.0);
  camera(camX, camY, camZ, camX, camY, 0, 0, 1, 0);
}

void restartGame() {
  playEndingAnimation = false;
  score = 0;
  timeLeft = 60;
  currentLevel = 1;
  stars.clear();
  enemies.clear();
  portalActive = false;
  youWin = false;
  gameOver = false;
  setupLevel(1);
}

void startEndingAnimation() {
  shipX = width / 2;
  shipY = height + 100;
  endingReady = false;
  endingStartTime = 0;

  otherPlanets.clear();
  int planetCount = 8;
  int skipIndex = 2; 

  for (int i = 0; i < planetCount + 1; i++) {
    if (i == skipIndex) continue;
    float angle = i * TWO_PI / (planetCount + 1);
    otherPlanets.add(new PVector(angle, i)); 
  }
}





void drawEndingAnimation() {
  background(0);
  for (BackgroundStar bs : bgStars) {
    bs.update();
    bs.display();
  }

  float centerX = width / 2;
  float centerY = height / 2;
  float sunRadius = 45;
  float orbitRadius = 180;

pushMatrix();
translate(centerX, centerY, 0);
imageMode(CENTER);
image(sunFace, 0, 0);
popMatrix();



  PImage myPlanet = loadImage("planetMe.png");
  myPlanet.resize(60, 60);

  float targetY = centerY + orbitRadius;
  boolean playerHasArrived = false;

  if (shipY > targetY) {
    shipY -= 1.5;
  } else if (!endingReady) {
    endingReady = true;
    endingStartTime = millis();
    playerHasArrived = true;
  } else {
    playerHasArrived = true;
  }

  float t = (millis() - endingStartTime) * 0.001;

  
  if (!playerHasArrived) {
    pushMatrix();
    translate(centerX, shipY, 0);
    imageMode(CENTER);
    image(myPlanet, 0, 0);
    popMatrix();
  } else {
    float myAngle = playerAngle + t;
    float x = centerX + cos(myAngle) * orbitRadius;
    float y = centerY + sin(myAngle) * orbitRadius;

    pushMatrix();
    translate(x, y, 0);
    imageMode(CENTER);
    image(myPlanet, 0, 0);
    popMatrix();
  }

 
  int totalPlanets = 8;
  float angleStep = TWO_PI / totalPlanets;

  int index = 0;
  for (int i = 0; i < totalPlanets; i++) {
    float angle = i * angleStep;
    if (abs(angle - playerAngle) < 0.01) continue;

    float rotatingAngle = endingReady ? angle + t : angle;
    float x = centerX + cos(rotatingAngle) * orbitRadius;
    float y = centerY + sin(rotatingAngle) * orbitRadius;

    pushMatrix();
    translate(x, y, 0);
    fill(100 + index * 15, 150 + index * 10, 255);
    sphere(30);
    popMatrix();

    index++;
  }

  if (endingReady && millis() - endingStartTime > 2000) {
    textFont(retroFont);
    textAlign(CENTER);
    textSize(16);
    fill(255);
    text("You saved the Milky Way!", width / 2, height - 150);
    text("Have fun rotating around the sun until you forget who you are.", width / 2, height - 125);

    replayButtonX = width - 340;
    replayButtonY = height - 60;
    exitButtonX = width - 170;
    exitButtonY = height - 60;

    fill(0, 150, 0);
    stroke(255);
    rect(replayButtonX, replayButtonY, replayButtonW, replayButtonH, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    text("REPLAY", replayButtonX + replayButtonW / 2, replayButtonY + replayButtonH / 2);

    fill(150, 0, 0);
    stroke(255);
    rect(exitButtonX, exitButtonY, exitButtonW, exitButtonH, 10);
    fill(255);
    text("EXIT", exitButtonX + exitButtonW / 2, exitButtonY + exitButtonH / 2);
  }
}



void drawRotatingStarsAroundPlayer() {
  pushMatrix();
  translate(width/2, height/2, 0);

 
  PImage img = loadImage("planetMe.png");
  img.resize(80, 80);
  imageMode(CENTER);
  image(img, 0, 0);

 
  float radius = 100;
  int starCount = 10;
  float angleStep = TWO_PI / starCount;
  float t = millis() * 0.002;

  fill(255, 255, 0);
  for (int i = 0; i < starCount; i++) {
    float angle = t + i * angleStep;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    pushMatrix();
    translate(x, y, 0);
    sphere(8);
    popMatrix();
  }
  popMatrix();
}
