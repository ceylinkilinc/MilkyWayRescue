class ExitPortal {
  float x, y;

  ExitPortal() {
    x = random(100, width - 100);
    y = random(100, height - 200);
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    noFill();
    stroke(0, 255, 255);
    strokeWeight(3);
    ellipse(0, 0, 60, 60); // Halka gibi
    popMatrix();
  }

  boolean isPlayerInside(float px, float py) {
    return dist(px, py, x, y) < 40;
  }
}
