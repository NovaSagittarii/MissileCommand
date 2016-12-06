class Bullet {
  float x;
  float y;
  float r; //rotation
  float v; //velocity
  float s; //?? i SHOULD know what these mean, but... idk... :I
  float t;
  Bullet(int tempX, int tempY, float tempR, int tempV, int tempS, float tempT){
    x = tempX;
    y = tempY;
    r = tempR;
    v = tempV;
    s = tempS;
    t = tempT;
  }
  void work(){
    x += cos(r) * v;
    y += sin(r) * v;
    strokeWeight(1);
    stroke(random(0, 255), random(0, 255), random(0, 255));
    line(x + cos(r) * 2 * t - 5, y + sin(r) * 2 * t - 5, x + cos(r) * 2 * t + 5, y + sin(r) * 2 * t + 5);
    line(x + cos(r) * 2 * t + 5, y + sin(r) * 2 * t - 5, x + cos(r) * 2 * t - 5, y + sin(r) * 2 * t + 5);
    stroke(r + 100, g + 100, b + 100);
    for(int i = 0; i > -5; i --){
        strokeWeight(constrain(s / 2 + i, 0, 5));
        line(x, y, x + cos(r) * v * i * 5, y + sin(r) * v * i * 5);
    }
    t -= 1 * v/2;
  }
}