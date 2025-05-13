class Star {
  float x, y;

  Star(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    fill(255, 255, 0);
    noStroke();
    sphere(10);
    popMatrix();
  }
}
