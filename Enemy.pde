class Enemy {
  float x;
  float y;
  float r; //rotation
  float v; //velocity
  int t; //type
  float origin_X;
  float origin_Y;
  Enemy(float tempX, float tempY, float tempR, float tempV, String tempT){
    x = tempX;
    y = tempY;
    r = tempR;
    v = tempV;
    origin_X = x;
    origin_Y = y;
    if(tempT == "bomb"){t=1;}else
    if(tempT == "bomb-1"){t=2;}else
    if(tempT == "bomb-2"){t=3;}else
    if(tempT == "bomber"){t=4;}else{
    t=0;}
  };
  boolean removal(){
    if(t == 0 || y > 450 || (x > 700 && t == 4)){
      if(y > 450){
        for(int k = 0; k < cities.length; k ++){
          if(((k < 3 ? 120 : 180) + 60 * k) == round(x)){
            cities[k] = false;
          }
        }
        for(int k = 0; k < silos.length; k ++){
          if((60 + k * 240) == round(x)){
            silos[k] = 0;
          }
        }
      }
      return true;
    }else{
      return false;
    }
  };
  void work(){
    x += cos(r) * v;
    y += sin(r) * v;
    switch(t){
      case 1:
      case 2:
      case 3:
        strokeWeight(1);
        stroke(r, -b, g);
        line(x, y, origin_X, origin_Y);
        noStroke();
        fill(random(r - 40, r + 40), -random(b - 40, b + 40), random(g - 40, g + 40));
        ellipse(x, y, 3, 3);
        if(random(0, 100) < ((t == 2) ? 70 : 0) && round(y % 100) == 0 && y > 50){
          int center = constrain(round(x/60) * 60, 120, 480);
          enemies.add(new Enemy(x, y, atan2(450-y, (center-60)-x), 1, "bomb"));
          enemies.add(new Enemy(x, y, atan2(450-y, (center+60)-x), 1, "bomb"));
          enemies.add(new Enemy(x, y, atan2(450-y, center-x), 1, "bomb"));
          t = 0;
          x = 1000;
        }
        if((t == 3) && (round(y % 50) == 0 && y > 20 && random(0, 100) < 90 || y > 300)){
          int center = constrain(round(x/60) * 60, 180, 420);
          enemies.add(new Enemy(x, y, atan2(450-y, (center-120)-x), 1, "bomb-1"));
          enemies.add(new Enemy(x, y, atan2(450-y, (center+120)-x), 1, "bomb-1"));
          t = 0;
          x = 1000;
        }
        if(t == 2){
          fill(255, 255, 255, 45);
          ellipse(x, y, 10, 10);
        }
        if(t == 3){
          fill(255, 255, 255, 80);
          ellipse(x, y, 15, 15);
        }
      break;
      case 4:
        pushMatrix();
        noStroke();
        fill(r, -b, g);
        translate(x, y);
        rotate(r);
        rect(0, 0, 15, 15);
        popMatrix();
        if(round(frameCount+x-y) % 500 == 0 && x > 10 && x < 550){
          enemies.add(new Enemy(x, y, atan2(450-y, round(x/60) * 60-x), 1, "bomb"));
        }
      break;
    }
  };
}