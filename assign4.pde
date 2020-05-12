PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

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
final float CABBAGE_W = 80;
final float CABBAGE_H = 80;
final boolean EATEN = false;
boolean cabbageState = true;
final float SOLDIER_W = 80;
final float SOLDIER_H = 80;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
final float PLAYER_W  = 80;
final float PLAYER_H  = 80;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
final int LIFE_X       = 10;
final int LIFE_Y       = 10;
final int LIFE_SPACE   = 20;
final int LIFE_W       = 50;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
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

	// Load soil images used in assign3 if you don't plan to finish requirement #6
	soil0 = loadImage("img/soil0.png");
	soil1 = loadImage("img/soil1.png");
	soil2 = loadImage("img/soil2.png");
	soil3 = loadImage("img/soil3.png");
	soil4 = loadImage("img/soil4.png");
	soil5 = loadImage("img/soil5.png");

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
		}
	}

	// Load PImage[][] stones
	stones = new PImage[2][5];
	for(int i = 0; i < stones.length; i++){
		for(int j = 0; j < stones[i].length; j++){
			stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
		}
	}

	// Initialize player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;

	// Initialize soilHealth
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {
			 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
			soilHealth[i][j] = 15;
      
      // lay 1~8
      if(j>=0 && j<8){
        if(i == j) soilHealth[i][j] = 30;
      }
      
      // lay 9~16
      if(j>=8 && j<16){
        if((j%4==0 || j%4==3) && (i%4==1 || i%4==2))
          soilHealth[i][j] = 30;
        if((j%4==1 || j%4==2) && (i%4==0 || i%4==3))
          soilHealth[i][j] = 30;
      }
      
      // lay 17~24
      if (j>=16 && j<24){
        if(j%3 == 1){
          if(i%3 != 0) soilHealth[i][j] = 30;
          if(i%3 == 2) soilHealth[i][j] = 45;
        }
        if(j%3 == 2){
          if(i%3 != 2) soilHealth[i][j] = 30;
          if(i%3 == 1) soilHealth[i][j] = 45;
        }
          
        if(j%3 == 0){
          if(i%3 != 1) soilHealth[i][j] = 30;
          if(i%3 == 0) soilHealth[i][j] = 45;
        }
      }
		}
	}

  // random empty soil 
  for (int j = 1; j < SOIL_ROW_COUNT; j++) {
    int empty1 = (int)random(SOIL_COL_COUNT);
    int empty2 = (int)random(SOIL_COL_COUNT);
    soilHealth[empty1][j] = 0;
    soilHealth[empty2][j] = 0;
  }

	// Initialize soidiers and their position
  soldierX = new float[6];
  soldierY = new float[6];
  for(int i = 0; i < soldierX.length; i++){
    int x = (int)random(SOIL_COL_COUNT);
    int y = (int)random(4);
    soldierX[i] = x * SOIL_SIZE;
    soldierY[i] = (y + i*4) * SOIL_SIZE;
  }
  
	// Initialize cabbages and their position
  cabbageX = new float[6];
  cabbageY = new float[6];
  for(int i = 0; i < cabbageX.length; i++){
    int x = (int)random(SOIL_COL_COUNT);
    int y = (int)random(4);
    cabbageX[i] = x * SOIL_SIZE;
    cabbageY[i] = (y + i * 4) * SOIL_SIZE;
  }
  
  

}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil

		for(int i = 0; i < soilHealth.length; i++){
			for (int j = 0; j < soilHealth[i].length; j++) {

				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				int areaIndex = floor(j / 4);
        if(soilHealth[i][j] > 0 && soilHealth[i][j] <= 3) 
          image(soils[areaIndex][0], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 3 && soilHealth[i][j] <= 6)
          image(soils[areaIndex][1], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 6 && soilHealth[i][j] <=9)
          image(soils[areaIndex][2], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 9 && soilHealth[i][j] <= 12)
          image(soils[areaIndex][3], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 12 && soilHealth[i][j] <= 45)
          image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
				
        // stones 1
        if(soilHealth[i][j] > 15 && soilHealth[i][j] <= 18) 
          image(stones[0][0], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 18 && soilHealth[i][j] <= 21)
          image(stones[0][1], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 21 && soilHealth[i][j] <= 24)
          image(stones[0][2], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 24 && soilHealth[i][j] <= 27)
          image(stones[0][3], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 27 && soilHealth[i][j] <= 45)
          image(stones[0][4], i * SOIL_SIZE, j * SOIL_SIZE);
                   
        // stones 2
        if(soilHealth[i][j] > 30 && soilHealth[i][j] <= 33) 
          image(stones[1][4], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 33 && soilHealth[i][j] <= 36)
          image(stones[1][1], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 36 && soilHealth[i][j] <= 39)
          image(stones[1][2], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 39 && soilHealth[i][j] <= 42)
          image(stones[1][3], i * SOIL_SIZE, j * SOIL_SIZE);
        else if(soilHealth[i][j] > 42 && soilHealth[i][j] <= 45)
          image(stones[1][4], i * SOIL_SIZE, j * SOIL_SIZE);
        
        // empty 
        if(soilHealth[i][j] == 0) image(soilEmpty, i * SOIL_SIZE, j * SOIL_SIZE);
			}
		}

		// Cabbages
		// > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for(int i = 0; i < cabbageX.length; i++){
      if(playerX+PLAYER_W>cabbageX[i] && playerX<cabbageX[i]+CABBAGE_W &&
         playerY+PLAYER_H>cabbageY[i] && playerY<cabbageY[i]+CABBAGE_H){
           if(playerHealth < PLAYER_MAX_HEALTH){
             cabbageX[i] = width + CABBAGE_W;
             playerHealth ++;
           }
         }else{
           image(cabbage, cabbageX[i], cabbageY[i]);
         }
      
    }

		// Groundhog

		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
		if(playerMoveTimer == 0){      
  
      if(playerRow < SOIL_ROW_COUNT - 1){
        if(soilHealth[playerCol][playerRow+1] == 0){
          groundhogDisplay = groundhogDown;
          playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;
        }
      }
			// HINT:
			// You can use playerCol and playerRow to get which soil player is currently on

			// Check if "player is NOT at the bottom AND the soil under the player is empty"
			// > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
			// > Else then determine player's action based on input state

			if(leftState){

				groundhogDisplay = groundhogLeft;

				// Check left boundary
				if(playerCol > 0){
          
          
          if(soilHealth[playerCol-1][playerRow] !=0){
            soilHealth[playerCol-1][playerRow] --;
          }else{

  					// HINT:
  					// Check if "player is NOT above the ground AND there's soil on the left"
  					// > If so, dig it and decrease its health
  					// > Else then start moving (set playerMoveDirection and playerMoveTimer)
  
  					playerMoveDirection = LEFT;
  					playerMoveTimer = playerMoveDuration;
          }

				}

			}else if(rightState){

				groundhogDisplay = groundhogRight;

				// Check right boundary
				if(playerCol < SOIL_COL_COUNT - 1){
          
          if(soilHealth[playerCol+1][playerRow] != 0){
            soilHealth[playerCol+1][playerRow] --;
          }else{

  					// HINT:
  					// Check if "player is NOT above the ground AND there's soil on the right"
  					// > If so, dig it and decrease its health
  					// > Else then start moving (set playerMoveDirection and playerMoveTimer)
  
  					playerMoveDirection = RIGHT;
  					playerMoveTimer = playerMoveDuration;
          }

				}

			}else if(downState){

				groundhogDisplay = groundhogDown;

				// Check bottom boundary

				// HINT:
				// We have already checked "player is NOT at the bottom AND the soil under the player is empty",
				// and since we can only get here when the above statement is false,
				// we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
				if(playerRow < SOIL_ROW_COUNT - 1){

					// > If so, dig it and decrease its health
          
          if(soilHealth[playerCol][playerRow+1] != 0){
            soilHealth[playerCol][playerRow+1] --;
          }else{
  					// For requirement #3:
  					// Note that player never needs to move down as it will always fall automatically,
  					// so the following 2 lines can be removed once you finish requirement #3
  
  					playerMoveDirection = DOWN;
  					playerMoveTimer = playerMoveDuration;
          }


				}
			}

		}

		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}

		image(groundhogDisplay, playerX, playerY);

		// Soldiers
		// > Remember to stop player's moving! (reset playerMoveTimer)
		// > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
		// > Remember to reset the soil under player's original position!
    for(int i = 0; i < soldierX.length; i++){
      soldierX[i] += soldierSpeed;
      if(soldierX[i] >= width) soldierX[i] = -80;
      image(soldier, soldierX[i], soldierY[i]);
      
      if(playerX+PLAYER_W>soldierX[i] && playerX<soldierX[i]+SOLDIER_W &&
         playerY+PLAYER_H>soldierY[i] && playerY<soldierY[i]+SOLDIER_H){
           playerX = PLAYER_INIT_X;
           playerY = PLAYER_INIT_Y;
           playerHealth --;
           playerCol = (int) (playerX / SOIL_SIZE);
           playerRow = (int) (playerY / SOIL_SIZE);
           playerMoveTimer = 0;
           
           leftState  = false;
           rightState = false;
           downState  = false;
           

           
           for(int a = 0; a < soilHealth.length; a++){
             soilHealth[a][0]=15;
           }
           
           
         }
    }
    

		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI
    for (int i=0; i<playerHealth; i++){    
      if(i<PLAYER_MAX_HEALTH){
        image(life, LIFE_X+(LIFE_W+LIFE_SPACE)*i, LIFE_Y);
      }
    }
      
    // life become zero
      if (playerHealth == 0){
        gameState = GAME_OVER;
      }  

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

				// Initialize soilHealth
				soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
				for(int i = 0; i < soilHealth.length; i++){
					for (int j = 0; j < soilHealth[i].length; j++) {
						 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
						soilHealth[i][j] = 15;
            // lay 1~8
            if(j>=0 && j<8){
              if(i == j) soilHealth[i][j] = 30;
            }            
            // lay 9~16
            if(j>=8 && j<16){
              if((j%4==0 || j%4==3) && (i%4==1 || i%4==2))
                soilHealth[i][j] = 30;
              if((j%4==1 || j%4==2) && (i%4==0 || i%4==3))
                soilHealth[i][j] = 30;
            }            
            // lay 17~24
            if (j>=16 && j<24){
              if(j%3 == 1){
                if(i%3 != 0) soilHealth[i][j] = 30;
                if(i%3 == 2) soilHealth[i][j] = 45;
              }
              if(j%3 == 2){
                if(i%3 != 2) soilHealth[i][j] = 30;
                if(i%3 == 1) soilHealth[i][j] = 45;
              }                
              if(j%3 == 0){
                if(i%3 != 1) soilHealth[i][j] = 30;
                if(i%3 == 0) soilHealth[i][j] = 45;
              }
            }
					}
				}
        // random empty soil 
          for (int j = 1; j < SOIL_ROW_COUNT; j++) {
            int empty1 = (int)random(SOIL_COL_COUNT);
            int empty2 = (int)random(SOIL_COL_COUNT);
            soilHealth[empty1][j] = 0;
            soilHealth[empty2][j] = 0;
          }
				// Initialize soidiers and their position
          for(int i = 0; i < soldierX.length; i++){
            int x = (int)random(SOIL_COL_COUNT);
            int y = (int)random(4);
            soldierX[i] = x * SOIL_SIZE;
            soldierY[i] = (y + i*4) * SOIL_SIZE;
          }

				// Initialize cabbages and their position
				  for(int i = 0; i < cabbageX.length; i++){
          int x = (int)random(SOIL_COL_COUNT);
          int y = (int)random(4);
          cabbageX[i] = x * SOIL_SIZE;
          cabbageY[i] = (y + i * 4) * SOIL_SIZE;
        }
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
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
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
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
