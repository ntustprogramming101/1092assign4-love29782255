PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered; //<>// //<>// //<>//
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][]  stones;
PImage[][] soils = new PImage[6][5];

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;
int ranFloor, ranPos;
int lifeX = 10;

int[] holeNum = new int [24];
int[][] ranHolePos ; 

float block = 80;
float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
  size(640, 480, P2D);
  bg= loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");

  //Load soil images used in assign3 if you don't plan to finish requirement #6
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");

  //Load PImage[][] soils
  soils = new PImage[6][5];
  for (int i = 0; i < soils.length; i++) {
    for (int j = 0; j < soils[i].length; j++) {
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  //Load PImage[][] stones
  stones = new PImage[2][5];
  for (int i = 0; i < stones.length; i++) {
    for (int j = 0; j < stones[i].length; j++) {
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  //Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int)(playerX / SOIL_SIZE);
  playerRow = (int)(playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  //Initialize soilHealth
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for (int i = 0; i < soilHealth.length; i++) {
    for (int j = 0; j < soilHealth[i].length; j++) {
      // NOTE:To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
      int areaIndex = floor(j / 4);
      soilHealth[i][j] = 15;

      //stones
      if (soilHealth[i][j] != 0) {
        //stones row1
        if (areaIndex == 0 || areaIndex == 1 ) {
          if (i==j) soilHealth[i][j] = 30;
        }
        //stones row2
        if (areaIndex == 2 || areaIndex == 3) {
          if (i%4 == 0 || i%4 == 3) {
            if (j%4 == 1 || j%4 == 2 ) soilHealth[i][j] = 30;
          }
          if (i%4 == 1 || i%4 == 2) {
            if (j%4 == 0 || j%4 == 3 ) soilHealth[i][j] = 30;
          }
        }
        //stones row3
        if (areaIndex == 4 || areaIndex == 5) {
          for (int k = 1; k <= 13; k+=3) {
            int J = j-16;
            if (i+J == k) {
              soilHealth[i][(J+16)] = 30;
            } else if (i+J == (k+1)) soilHealth[i][(J+16)] = 45;
          }
        }
      }
    }
  }
  // random Hole
  for (int j = 1; j < 24; j++) {
    int lastHoleX = -1;
    holeNum[j] = floor(random(1, 3));
    for (int k = 0; k< holeNum[j]; k ++) {
      ranHolePos = new int [holeNum[j]][24];
      ranHolePos[k][j] = floor(random(8));
      if (ranHolePos[k][j]  == lastHoleX) k--;
      else {
        soilHealth[ranHolePos[k][j]][j] = 0 ;
        lastHoleX = ranHolePos[k][j] ;
      }
    }
  }

  //Soldier
  soldierX = new float [6];
  soldierY = new float [6];
  for (int j = 0; j < 6; j++) {
    ranFloor = floor(random(4));
    ranPos = floor(random(9));
    soldierY[j] = (j*4 + ranFloor)*block;
    soldierX[j] = ranPos* block;
  }
  //Vege
  cabbageX = new float [6];
  cabbageY = new float [6];
  for (int j = 0; j < 6; j++) {
    ranFloor = floor(random(4));
    ranPos = floor(random(9));
    cabbageY[j] = (j*4 + ranFloor)*block;
    cabbageX[j] = ranPos* block;
  }
}


void draw() {

  switch(gameState) {

  case GAME_START : // Start Screen
    image(title, 0, 0);
    if (START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    break;

  case GAME_RUN : // In-Game
    // Background
    image(bg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);

    // CAREFUL!
    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
    pushMatrix();
    translate(0, max(SOIL_SIZE * - 18, SOIL_SIZE * 1 - playerY));

    // Ground
    fill(124, 204, 25);
    noStroke();
    rect(0, - GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil
    for (int i = 0; i < soilHealth.length; i++) {
      for (int j = 0; j < soilHealth[i].length; j++) {
        // NOTE:To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
        int areaIndex = floor(j / 4);

        /*for ( int k = 0; k<4; k++) {
         for ( int l = 1; l<4; l+=3) {
         if (soilHealth[i][areaIndex*4 + k] >= l  &&  soilHealth[i][areaIndex*4 + k] <= (l+2)) {
         image(soils[areaIndex][(l-1)/3], i * SOIL_SIZE, j * SOIL_SIZE);
         } else image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
         }
         }*/

        if (soilHealth[i][j] >= 1 && soilHealth[i][j] <= 3) {
          image(soils[areaIndex][0], i * SOIL_SIZE, j * SOIL_SIZE);
        } else if (soilHealth[i][j] >= 4 && soilHealth[i][j] <= 6) {
          image(soils[areaIndex][1], i * SOIL_SIZE, j * SOIL_SIZE);
        } else if (soilHealth[i][j] >= 7 && soilHealth[i][j] <= 9) {
          image(soils[areaIndex][2], i * SOIL_SIZE, j * SOIL_SIZE);
        } else if (soilHealth[i][j] >= 10 && soilHealth[i][j] <= 12) {
          image(soils[areaIndex][3], i * SOIL_SIZE, j * SOIL_SIZE);
        } else if (soilHealth[i][j] >= 13 && soilHealth[i][j] <= 45) {
          image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
        } else {
          image(soilEmpty, i * SOIL_SIZE, j * SOIL_SIZE);
        }   

        //stones
        drawStone(soilHealth[i][j], 0, i, j);
        drawStone(soilHealth[i][j], 1, i, j);
      }
    }


    /////////////////life, vege, soldier
    for (int j = 0; j < 6; j++) {
      //Soldier
      image(soldier, soldierX[j] - block, soldierY[j]);
      soldierX[j] += 2.0;
      soldierX[j] %= block*9 ;

      //life
      //if touch soldier
      if (playerX < soldierX[j] && playerX + block > soldierX[j] - block &&
        playerY < soldierY[j] + block && playerY + block > soldierY[j]) {
        playerHealth = playerHealth - 1;
        lifeMove(playerHealth);
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        soilHealth[4][0] = 15;
        playerCol = (int)(playerX / SOIL_SIZE);
        playerRow = (int)(playerY / SOIL_SIZE);
        downState = false;
        leftState = false;
        rightState = false;
      } 
      // Cabbages
      // >Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
      if (playerHealth < PLAYER_MAX_HEALTH) {
        if (playerX < cabbageX[j] + block && playerX + block > cabbageX[j] &&
          playerY < cabbageY[j] + block && playerY + block > cabbageY[j]) {
          playerHealth = playerHealth + 1;
          cabbageX[j] = width;
          cabbageY[j] = height;
          lifeMove(playerHealth);
        }
      }
      lifeMove(playerHealth);
      image(cabbage, cabbageX[j], cabbageY[j] );
    }



    // Groundhog
    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if (playerMoveTimer == 0) {

      // HINT:
      // Youcan use playerCol and playerRow to get which soil player is currently on
      if (playerRow != SOIL_ROW_COUNT - 1 && soilHealth[playerCol][playerRow+1] == 0) {
        //groundhogDisplay = groundhogDown;
        playerMoveDirection = DOWN;
        playerMoveTimer = playerMoveDuration;
        // Check if "player is NOT at the bottom AND the soil under the player is empty"
        // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)

        //playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        //if (1f - float(playerMoveTimer) / playerMoveDuration >= 1)playerRow++;
      }
    }

    // > Else then determine player's action based on input state
    if (leftState) {
      groundhogDisplay = groundhogLeft;
      // Checkleft boundary
      if (playerCol > 0) {
        // HINT:
        // Check if "player is NOT above the ground AND there's soil on the left"
        if (playerRow >= 0  &&  soilHealth[playerCol-1][playerRow] > 0 ) { 
          // > If so, dig it and decrease its health
          constrain( soilHealth[playerCol-1][playerRow], 0, 45);
          soilHealth[playerCol-1][playerRow] --;
        } else {
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)
          playerMoveDirection = LEFT;
          playerMoveTimer = playerMoveDuration;
        }
      }
    } else if (rightState) {

      groundhogDisplay = groundhogRight;

      // Checkright boundary
      if (playerCol < SOIL_COL_COUNT - 1) {

        // HINT:
        // Check if "player is NOT above the ground AND there's soil on the right"
        if (playerRow >= 0  &&  soilHealth[playerCol+1][playerRow] > 0 ) { 
          // > If so, dig it and decrease its health
          constrain( soilHealth[playerCol+1][playerRow], 0, 45);
          soilHealth[playerCol+1][playerRow] --;
        } else {
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)
          playerMoveDirection = RIGHT;
          playerMoveTimer = playerMoveDuration;
        }
      }
    } else if (downState) {

      groundhogDisplay = groundhogDown;

      // Checkbottom boundary

      // HINT:
      // We have already checked "player is NOT at the bottom AND the soil under the player is empty",
      if (playerRow != SOIL_ROW_COUNT  &&  soilHealth[playerCol][playerRow+1] > 0 ) { 
        // > If so, dig it and decrease its health
        constrain( soilHealth[playerCol][playerRow + 1], 0, 45);
        soilHealth[playerCol][playerRow + 1] --;
      }
      // and since we can only get here when the above statement is false,
      // we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
      // > If so, dig it and decrease its health
      // For requirement #3:
      // Note that player never needs to move down as it will always fall automatically,
      // so the following 2 lines can be removed once you finish requirement #3
      //playerMoveDirection = DOWN;
      //playerMoveTimer = playerMoveDuration;
    }

    // If player is now moving?
    // (Separated if-else so player can actually move as soon as an action starts)
    // (I don't think you have to change any of these)
    if (playerMoveTimer > 0) {

      playerMoveTimer --;
      switch(playerMoveDirection) {

      case LEFT:
        groundhogDisplay = groundhogLeft;
        if (playerMoveTimer == 0) {
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        } else {
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }
        break;

      case RIGHT:
        groundhogDisplay = groundhogRight;
        if (playerMoveTimer == 0) {
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        } else {
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

      case DOWN:
        groundhogDisplay = groundhogDown;
        if (playerMoveTimer == 0) {
          playerRow++;
          playerY = SOIL_SIZE * playerRow;
        } else {
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }
    }

    image(groundhogDisplay, playerX, playerY);

    // Soldiers
    // >Remember to stop player's moving! (reset playerMoveTimer)
    // >Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
    // >Remember to reset the soil under player's original position!

    // Demo mode: Show the value of soilHealth on each soil
    // (DO NOT CHANGE THE CODE HERE!)

    if (demoMode) {	

      fill(255);
      textSize(26);
      textAlign(LEFT, TOP);

      for (int i = 0; i < soilHealth.length; i++) {
        for (int j = 0; j < soilHealth[i].length; j++) {
          text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }
    }

    popMatrix();

    if (playerHealth<=0) gameState = GAME_OVER;

    // Health UI

    break;

  case GAME_OVER : // Gameover Screen
    image(gameover, 0, 0);

    if (START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {

        // Initialize player
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int)(playerX / SOIL_SIZE);
        playerRow = (int)(playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth = 2;


        // Initialize soilHealth
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for (int i = 0; i < soilHealth.length; i++) {
          for (int j= 0; j < soilHealth[i].length; j++) {
            // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
            soilHealth[i][j] = 15;
          }
        }

        // Initialize soidiers and their position
        // Initialize cabbages and their position
        // random Hole
        for (int j = 1; j < 24; j++) {
          int lastHoleX = -1;
          holeNum[j] = floor(random(1, 3));
          for (int k = 0; k< holeNum[j]; k ++) {
            ranHolePos = new int [holeNum[j]][24];
            ranHolePos[k][j] = floor(random(8));
            if (ranHolePos[k][j]  == lastHoleX) k--;
            else {
              soilHealth[ranHolePos[k][j]][j] = 0 ;
              lastHoleX = ranHolePos[k][j] ;
            }
          }
        }

        //Soldier
        soldierX = new float [6];
        soldierY = new float [6];
        for (int j = 0; j < 6; j++) {
          ranFloor = floor(random(4));
          ranPos = floor(random(9));
          soldierY[j] = (j*4 + ranFloor)*block;
          soldierX[j] = ranPos* block;
        }
        //Vege
        cabbageX = new float [6];
        cabbageY = new float [6];
        for (int j = 0; j < 6; j++) {
          ranFloor = floor(random(4));
          ranPos = floor(random(9));
          cabbageY[j] = (j*4 + ranFloor)*block;
          cabbageX[j] = ranPos* block;
        }
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }
}

void drawStone(int sH, int stone, int i, int j) {
  if (stone ==0) {
    if (sH >= 16 && sH <= 18) {
      image(stones[0][0], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 19 && sH <= 21) {
      image(stones[0][1], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 22 && sH <= 24) {
      image(stones[0][2], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 25 && sH <= 27) {
      image(stones[0][3], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 28 && sH <= 45) {
      image(stones[0][4], i * SOIL_SIZE, j * SOIL_SIZE);
    }
  } else if (stone == 1) {
    if (sH >= 31 && sH <= 33) {
      image(stones[1][0], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 34 && sH <= 36) {
      image(stones[1][1], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 37 && sH <= 39) {
      image(stones[1][2], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 40 && sH <= 42) {
      image(stones[1][3], i * SOIL_SIZE, j * SOIL_SIZE);
    } else if (sH >= 43 && sH <= 45) {
      image(stones[1][4], i * SOIL_SIZE, j * SOIL_SIZE);
    }
  }
}

void lifeMove(int playerHealth) {
  for (int A = 0; A <= playerHealth-1; A+=1) {
    if (playerMoveTimer > 0) {
      if (playerMoveTimer == 0) {
        if (playerRow <= 18) image(life, lifeX + 70*A, 10 + block*(playerRow-1));
        else image(life, lifeX + 70*A, 10 + block*18);
      } else {
        if (playerRow <= 18) image(life, lifeX + 70*A, 10 + playerY- block);
        else image(life, lifeX + 70*A, 10 + block*18);
      }
    }
    if (playerMoveTimer == 0) {
      if (playerRow <= 18) image(life, lifeX + 70*A, 10 + block*(playerRow-1));
      else image(life, lifeX + 70*A, 10 + block*18);
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT:
      leftState = true;
      break;
    case RIGHT:
      rightState = true;
      break;
    case DOWN:
      downState = true;
      break;
    }
  } else {
    if (key == 'b') {
      // Press B to toggle demo mode
      demoMode = !demoMode;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT:
      leftState = false;
      break;
    case RIGHT:
      rightState = false;
      break;
    case DOWN:
      downState = false;
      break;
    }
  }
}
