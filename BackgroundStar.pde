class BackgroundStar {
  float x, y, speed, size;

  BackgroundStar() {
    x = random(width);
    y = random(height);
    speed = random(0.5, 2);
    size = random(1, 3);
  }

  void update() {
    y += speed;
    if (y > height) {
      y = 0;
      x = random(width);
    }
  }

  void display() {
    noStroke();
    fill(255, 255, 255, 200);
    ellipse(x, y, size, size);
  }
}
