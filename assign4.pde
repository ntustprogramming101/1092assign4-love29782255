final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2; //<>// //<>// //<>//
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int LIFE_AMOUNT = 5;

float block = 80;
float[] soilX = new float[8];
float[] soilY = new float[4];
float[] stoneX = new float[10];
float[] stoneY = new float[8];
float[] bluestoneX = new float[10];
float[] bluestoneY = new float[8];

float iniSoil;
float hogX = block * 4;
float hogY = block;
float hogSpeed = 16 / 3;
float moveX = 0;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered, 
  bg, soil0, soil1, soil2, soil3, soil4, soil5, life, stone1, stone2, 
  groundhogDown, groundhogIdle, groundhogLeft, groundhogRight;

// For debug function; DO NOT edit or remove this!
int playerHealth = 2;
float cameraOffsetY = 0;
boolean debugMode = false;
boolean upPressed = false;
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;
boolean getCabbage = false;


void setup() {
  size(640, 480, P2D);
  //Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  life = loadImage("img/life.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  iniSoil = block * 2;
}

void draw() {
  /*------ Debug Function ------ 
   Please DO NOT edit the code here.
   It's for reviewing other requirements when you fail to complete the camera moving requirement.
   */
  if (debugMode) {
    pushMatrix();
    translate(0, cameraOffsetY);
  }
  /*------ End of Debug Function ------ */


  switch (gameState) {

  case GAME_START: // Start Screen
    image(title, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {
      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {
      image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;

  case GAME_RUN: // In-Game
    // Background
    image(bg, 0, 0);
    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);
   
    //////////////////////////////////////////////////////////////////////////////
    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!s
    if (downPressed) {
      if (iniSoil > -18*block) {
        iniSoil -= hogSpeed;
      }
    }
    if (keyPressed != true) iniSoil =  floor(iniSoil/block)*block;

    for (int i = 0; i<8; i++) {
      for (int j = 0; j<4; j++) {
        soilX[i] = block*i;
        soilY[j] = iniSoil + block*j;
        image(soil0, soilX[i], soilY[j]);
        image(soil1, soilX[i], soilY[j] + 4*block);
        image(soil2, soilX[i], soilY[j] + 8*block);
        image(soil3, soilX[i], soilY[j] + 12*block);
        image(soil4, soilX[i], soilY[j] + 16*block);
        image(soil5, soilX[i], soilY[j] + 20*block);
      }
    }
     // Grass
    fill(124, 204, 25);
    noStroke();
    rect(0, iniSoil  - GRASS_HEIGHT, width, GRASS_HEIGHT);

    //stoneX1 stoneY1  stoneX2 stoneY2 stoneX3 stoneY3 bluestoneX3 bluestoneY3
    //row1
    for (int i = 0; i<8; i++) {
      stoneX[i] = block*i;
      stoneY[i] =  iniSoil + block*i;
      image(stone1, stoneX[i], stoneY[i]);
    }
    //row2
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<8; j++) {
        if (j%4 == 0 || j%4 == 3) {
          if ((2*i+1)%8 == 3) {
            stoneX[i] = block*i;
            stoneY[j] = iniSoil + block*j + 8*block;
            image(stone1, stoneX[i], stoneY[j]);
            image(stone1, stoneX[i+1], stoneY[j]);
          }
        }
      }
    }
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<8; j++) {
        if (j%4 == 1 || j%4 == 2) {
          if ((2*i+1)%8 == 7) {
            stoneX[i] = block*i;  
            stoneY[j] = iniSoil + block*j + 8*block;
            image(stone1, stoneX[i], stoneY[j]);
            image(stone1, stoneX[i+1], stoneY[j]);
          }
        }
      }
    }
    //row3
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<8; j++) {
        for (int k = 1; k <= 13; k+=3) {
          if (i+j == k || i+j == (k+1)) {
            stoneX[i] = block*i;
            stoneY[j] = iniSoil + block*j + 16*block;
            image(stone1, stoneX[i], stoneY[j]);
          }
          if (i+j == (k+1)) {
            bluestoneX[i] = block*i;
            bluestoneY[j] = iniSoil + block*j + 16*block;
            image(stone2, bluestoneX[i], bluestoneY[j]);
          }
        }
      }
    }

    //////////////////////////////////////////////////////////////////////////////
    // Player
    if (downPressed == true) {
      if (iniSoil == -18*block ) {
        hogY += hogSpeed;
        image(groundhogDown, hogX, hogY);
      } else image(groundhogDown, hogX, hogY);
      upPressed = false;
      rightPressed = false;
      leftPressed = false;
    }

    if (rightPressed) {
      hogX += hogSpeed;
      moveX += hogSpeed;
      image(groundhogRight, hogX, hogY);
      downPressed = false;
      upPressed = false;
      leftPressed = false;
    }

    if (leftPressed) {
      hogX -= hogSpeed;
      image(groundhogLeft, hogX, hogY);
      downPressed = false;
      rightPressed = false;
      upPressed = false;
    }

    if (keyPressed != true) {
      if (moveX > 0) {
        hogX = ceil(hogX/block)*block;
        moveX = 0;
      } else hogX = floor(hogX / block)*block;
      hogY = ceil(hogY / block)*block;
      image(groundhogIdle, hogX, hogY);
    }
    //boundary detection
    if (hogX < 0)hogX =0;
    if (hogX > width-block)hogX = width-block;
    if (hogY < 0)hogY =0;
    if (hogY > height-block)hogY = height-block;

    // Health UI
    for (int i = 0; i < playerHealth; i++) {
      image(life, 10+70*i, 10);
    }   
    break;

  case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY&& START_BUTTON_Y < mouseY) {
      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
        // Remember to initialize the game here!
      }
    } else {
      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }   
  // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
  if (debugMode) {
    popMatrix();
  }
}

void keyPressed() {
  // Add your moving input code here

  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
  switch(key) {
  case 'w':
    debugMode = true;
    cameraOffsetY += 25;
    break;

  case 's':
    debugMode = true;
    cameraOffsetY -= 25;
    break;

  case 'a':
    if (playerHealth > 0) playerHealth --;
    break;

  case 'd':
    if (playerHealth < 5) playerHealth ++;
    break;
  }

  switch(keyCode) {
  case UP:
    upPressed = true;
    break;
  case DOWN:

    downPressed = true;

    break;
  case RIGHT:
    rightPressed = true;
    break;
  case LEFT:
    leftPressed = true;
    break;
  }
}
void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    }
  }
}
