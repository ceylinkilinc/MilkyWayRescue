class Enemy {
  float x, y;
  float dx, dy;
  float speed;
  PImage img;
  float angle = 0;

  Enemy(float s) {
    x = random(100, width - 100);
    y = random(100, height - 200);
    dx = random(-1, 1);
    dy = random(-1, 1);
    speed = s;
    img = loadImage("enemyPlanet.png");
    img.resize(60, 60);
  }

  void update() {
    x += dx * speed;
    y += dy * speed;

    if (x < 50 || x > width - 50) dx *= -1;
    if (y < 50 || y > height - 50) dy *= -1;

    angle += 0.05;
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    fill(255, 50, 50);
    noStroke();
    cone(20, 50);

    pushMatrix();
    translate(0, -40, 0);
    rotateY(angle);
    rotateZ(sin(angle) * 0.2);
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();

    popMatrix();
  }

  void cone(float r, float h) {
    int sides = 24;
    beginShape(TRIANGLE_FAN);
    vertex(0, 0, 0);
    for (int i = 0; i <= sides; i++) {
      float angle = TWO_PI / sides * i;
      float x = cos(angle) * r;
      float y = sin(angle) * r;
      vertex(x, y, h);
    }
    endShape();
  }
}
