class Planet {
  float x, y;
  float speed = 5;
  PImage img;

  Planet(float startX, float startY) {
    x = startX;
    y = startY;
    img = loadImage("planetMe.png"); // senin görselin
    img.resize(80, 80); // boyutu ayarlamak istersen değiştir
  }

  void update() {
    if (keyPressed) {
      if (keyCode == LEFT)  x -= speed;
      if (keyCode == RIGHT) x += speed;
      if (keyCode == UP)    y -= speed;
      if (keyCode == DOWN)  y += speed;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
  }
}
