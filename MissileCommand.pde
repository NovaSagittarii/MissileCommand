import ddf.minim.*;

//Made by Thomas Li (Please don't plagarize.)
//khanacademy.org/profile/NoviceProgramming

boolean mouseControls = true;
//WASD/IJKL control speed equivalent.

/**Objective:
 * 
 * Protect your cities.
 * Bombs will destroy cities.
 * Bombs will deplete a silo's ammo if it hits.
 * Use explosions to detonate bombs.
 */

int r2 = round(random(0, 200));
int g2 = round(random(0, 200));
int b2 = round(random(0, 200));
int r = 50, g = 50, b = 50;
boolean[] cities = {true, true, true, true, true, true};
int[] silos = {10, 10, 10};
int quip_silo = 1;
ArrayList<Bullet> bullets;
ArrayList<Explosion> explosions;
ArrayList<Enemy> enemies;
float aimX = 300;
float aimY = 250;
int aimSpeed = 5;
boolean reload = true;
boolean change = true;
int wave = 1;
boolean done = true;
int summaryProgress = 1;
int missiles = 0;
int multiplier = 1;
int waves_to_go = 2;
int score = 0;
int enemiesInWave = 0;
Minim minim;
boolean keys[] = new boolean[200];
void keyPressed(){
  keys[keyCode] = true;
}
void keyReleased(){
  keys[keyCode] = false;
  if(keyCode == "Z".hashCode() || keyCode == " ".hashCode()){
    reload = true;
  }
  if(keyCode == "X".hashCode() || keyCode == "E".hashCode()){
    change = true;  
  }
}
void setup(){
  bullets = new ArrayList<Bullet>();
  explosions = new ArrayList<Explosion>();
  enemies = new ArrayList<Enemy>();
  minim = new Minim(this);
  sound.coin = minim.loadFile("coin-jingle.mp3");
  sound.hit1 = minim.loadFile("hit1.mp3");
  sound.hit2 = minim.loadFile("hit2.mp3");
  sound.clink = minim.loadFile("metal-clink.mp3");
  sound.rumble = minim.loadFile("rumble.mp3");
  sound.step = minim.loadFile("step-heavy.mp3");
  rectMode(CENTER);
  textFont(createFont("zx7.ttf", 1));
  textAlign(CENTER, CENTER);
  size(600, 500);
  background(random(0, 200), random(0, 200), random(0, 200));
}
void draw() {
  fill(r, g, b, 10);
  rect(0, 0, 1337, 9001);
  for(int i = bullets.size()-1; i >= 0; i--){
    Bullet bullet = bullets.get(i);
    bullet.work();
    if(bullet.t < 0){
      explosions.add(new Explosion(bullet.x, bullet.y, 80, 3));
      bullets.remove(i);
       sound.hit1.play();
    }
  }
  for(int i = explosions.size()-1; i >= 0; i--){
    Explosion explosion = explosions.get(i);
    explosion.work();
    if(explosion.state == 2 && explosion.s < 0){
      explosions.remove(i);
    }
  }
  for(int i = enemies.size()-1; i >= 0; i--){
    Enemy enemy = enemies.get(i);
    enemy.work();
    if(enemy.removal()){
      explosions.add(new Explosion(enemy.x, enemy.y, random(70, 120), 3));
      if(enemy.y >= 449){
         sound.hit2.play();
      }else{
         sound.hit1.play();
      }
      enemies.remove(i);
    }
  }
  strokeWeight(1);
  stroke(r + 75, g + 75, b + 75);
  line(aimX - 5, aimY, aimX + 5, aimY);
  line(aimX, aimY - 5, aimX, aimY + 5);
  stroke(r, g, b);
  fill(r + 50, g + 50, b + 50);
  boolean surviving = false;
  for(int i = 0; i < cities.length; i ++){
    if(cities[i]){
      pushMatrix();
      translate((i < 3 ? 120 : 180) + 60 * i, 450);
      rect(0, -7.5, 10, 15);
      rect(5, -5, 8, 10);
      rect(1, -2.5, 6, 5);
      popMatrix();
      surviving = true;
    }
  }
  noStroke();
  for(int i = 0; i < silos.length; i ++){
    pushMatrix();
    fill(r - 75, g - 75, b - 75);
    translate(60 + i * 240, 450);
    ellipse(0, 0, 10, 10);
    if(round(i) == quip_silo){
      fill(255, 255, 255, 15);
      ellipse(0, 0, 25, 25);
    }
    popMatrix();
  }
  fill(r-50, g-50, b-50);
  rect(300, 500, 700, 100);
  for(int i = 0; i < silos.length; i ++){
    pushMatrix();
    translate(60 + i * 240, 450);
    float stack = 1, totals = 0;
    for(int j = 0; j < silos[i]; j ++){
      pushMatrix();
      translate(stack*10 - (j-totals)/stack*stack*15 + 5, stack*10);
      if(j-totals >= stack+1){
        stack += 1;
        totals = j;
      }
      stroke(r + 50, g + 50, b + 50);
      line(0, -4, 0, 4);
      line(-1, -2, -1, 4);
      line(1, -2, 1, 4);
      line(-2, 2, -2, 5);
      line(2, 2, 2, 5);
      popMatrix();
    }
    textSize(24);
    fill(r, g, b);
    if(silos[i] == 0){
      text("OUT", 0, 15);
      text("OUT", 1, 16);
    }else if(silos[i] < 4){
      text("LOW", 0, 25);
      text("LOW", 1, 26);
    }
    popMatrix();
  }
  for(int i = 0; i < keys.length; i ++){
    if(keys[i]){
      switch(i){
        case 32:
          if(reload && summaryProgress == 1){
            if(silos[quip_silo] > 0){
              if(quip_silo == 1){
                //Central silo has faster rockets
                bullets.add(new Bullet((60 + quip_silo * 240), 450, atan2(aimY-450, aimX-(60 + quip_silo * 240)), 20, 5, dist(aimX, aimY, (60 + quip_silo * 240), 450) / 2.05));
              }else{
                bullets.add(new Bullet((60 + quip_silo * 240), 450, atan2(aimY-450, aimX-(60 + quip_silo * 240)), 10, 5, dist(aimX, aimY, (60 + quip_silo * 240), 450) / 2.05));
              }
              silos[quip_silo] --;
            }else{
              sound.clink.play();
              quip_silo ++;
              if(quip_silo > 2){
                quip_silo = 0;
              }
            }
          }
          reload = false;
        break;
        case 69:
          if(change){
            quip_silo ++;
            if(quip_silo > 2){
              quip_silo = 0;
            }
          }
          change = false;
        break;
      }
    }
  }
  if(waves_to_go < 1){
    multiplier ++;
    waves_to_go = multiplier;
  }
  if(!surviving){
    enemies = new ArrayList<Enemy>();
    enemies.add(new Enemy(-100, -100, 0, 0, "bomb"));
    fill(255, 0, 0, 50);
    r = 155;
    g = 155;
    b = 155;
    textSize(140);
    text("GAME", 300, 175);
    text("OVER", 300, 225);
    textSize(70);
    fill(255, 255, 255, 20);
    text("score", 300, 285);
    text(score, 300, 315);
    if(explosions.size() >= 180){
      explosions = new ArrayList<Explosion>();
    }
  }
  if(enemies.size() == 0){
    if(done){
      wave ++;
      int enemyAmt = ceil(random(wave*1.1, wave*(1.1 + wave/20) + 4));
      enemiesInWave = enemyAmt;
      silos[0] = 10;
      silos[1] = 10;
      silos[2] = 10;
      r2 = round(random(-50, 200));
      g2 = r2 + round(random(-50, 200));
      b2 = g2 - round(random(-50, 200));
      sound.rumble.play();
      waves_to_go --;
      while(enemyAmt > 0){
        String toSpawn = "bomb";
        if(wave > 3 && random(0, 100) < constrain(wave*1.2, 0, 15)){
        toSpawn = "bomber";
        }
        if(wave > 10 && random(0, 100) < constrain(wave-10, 0, 17)){
          toSpawn = "bomb-1";
        }
        if(wave > 15 && random(0, 100) < constrain(wave-15, 0, 10)){
          toSpawn = "bomb-2";
        }
        switch(toSpawn){
          case "bomb":
          case "bomb-1":
          case "bomb-2":
            float x = random(-200, 800);
            float y = random(-100 - 200 * wave, -10);
            enemies.add(new Enemy(x, y, atan2(450-y, round(random(1, 8)) * 60-x), 1, toSpawn));
          break;
          case "bomber":
            enemies.add(new Enemy(random(-400, -10), random(50, 250), 0, 0.5, "bomber"));
          break;
        }
        enemyAmt --;
      }
      done = false;
    }else{
      fill(255, 0, 0, 100);
      textSize(constrain(summaryProgress*0.9, 10, 40));
      text("WAVE COMPLETE", 300, 150);
      int citiesLeft = 0;
      if(summaryProgress > 65){
        for(int i = 0; i < cities.length; i ++){
          if(cities[i]){
            citiesLeft ++;
          }
        }
        stroke(r, g, b);
        fill(r + 50, g + 50, b + 50);
        if(summaryProgress < (65 + citiesLeft * 30) && (summaryProgress - 6) % 30 == 0){
          sound.step.play();
          score += 100 * multiplier;
        }
        
        for(int i = 0; i < constrain((summaryProgress-65) / 30, 0, citiesLeft); i ++){
          pushMatrix();
          translate(125 + i * 50, 250);
          scale(2);
          rect(0, -7.5, 10, 15);
          rect(5, -5, 8, 10);
          rect(1, -2.5, 6, 5);
          popMatrix();
        }
        fill(255, 255, 255, 100);
        text(ceil(constrain((summaryProgress-65) / 30, 0, citiesLeft)) * 100 * multiplier, 450, 235);
      }
      if(summaryProgress > (65 + citiesLeft * 30)){
        if(summaryProgress % 10 == 0){
          int i = 0;
          boolean findingMissile = true;
          while(findingMissile){
            if(silos[i] > 0){
              silos[i] --;
              missiles ++;
              findingMissile = false;
              sound.coin.play();
              score += multiplier * 10;
            }else{
              i ++;
            }
            if(i > 2){
              findingMissile = false;
              if(summaryProgress > (missiles * 10 + citiesLeft * 30 + 65 + 75)){
                summaryProgress = 0;
                //Add pts
                done = true;
                missiles = 0;
                background(r, g, b);
              }
            }
          }
        }
        for(int i = 0; i < missiles; i ++){
          pushMatrix();
          translate(120 + i * 20 - + ((i >= 15) ? 300 : 0), 300 + ((i >= 15) ? 25 : 0));
          scale(2);
          stroke(r + 50, g + 50, b + 50);
          line(0, -4, 0, 4);
          line(-1, -2, -1, 4);
          line(1, -2, 1, 4);
          line(-2, 2, -2, 5);
          line(2, 2, 2, 5);
          popMatrix();
        }
        fill(255, 255, 255, 100);
        text(missiles * 10 * multiplier, 450, 315);
      }
      summaryProgress ++;
    }
  }
  if(mouseControls){
    aimX -= constrain((aimX - mouseX) / 5, -aimSpeed, aimSpeed);
    aimY -= constrain((aimY - constrain(mouseY, 0, 450)) / 5, -aimSpeed, aimSpeed);
  }
  fill(255, 255, 255, 50);
  textSize(30);
  text("SCORE " + score, 500, 40);
  textSize(20);
  text(multiplier + " X MULTIPLIER", 500, 60);
  r += (r2 - r) / 15;
  g += (g2 - g) / 15;
  b += (b2 - b) / 15;
};