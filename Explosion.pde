class Explosion {
  float x;
  float y;
  float i;
  float S;
  float s; //Size?
  float d; //diameter?
  float t; //Time left?
  int state;
  Explosion(float tempX, float tempY, float tempS, float tempD){
    x = tempX;
    y = tempY;
    s = 1;
    i = tempS;
    S = tempD;
    t = 250000;
    state = 1;
  };
  void work(){
    noStroke();
    noFill();
    stroke(r + 50, g + 50, b + 50);
    switch(state){
      case 1:
        s ++;
        if(s > i){
          state ++;
          t = 255;
        }
      break;
      case 2:
        s --;
      break;
    }
    for(int j = 0; j < enemies.size(); j ++){
      Enemy enemy = enemies.get(j);
      if(dist(x, y, enemy.x, enemy.y) < s/2){
        enemy.t = 0;
      }
    }
    if(y >= 449){
      stroke(255, 0, 0); 
    }
    ellipse(x, y, s, s);
    t -= S;
  };
}