// constant variables
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;

final int SOURCE_NONE = 0;
final int SOURCE_FIGHTER = 1;
final int SOURCE_BULLET = 2;

final int HIT_NONE = 0;
final int HIT_ENEMY = 1;
final int HIT_TREASURE = 2;

final int HP_POINT_DEFAULT = 20;
final int HP_POINT_MAX = 100;
final int HP_POINT_HIT = 20;
final int HP_POINT_ENERGY = 10;

final int ENEMY_SCORE = 20;

// Fixed Position
final int HP_X = 10;
final int HP_Y = 10;
final int HP_RED_X = HP_X + 5;
final int HP_RED_Y = HP_Y + 2;
final int BUTTON_X = 202;
final int BUTTON_Y = 280;
final int BUTTON_WIDTH = 255;
final int BUTTON_HEIGHT = 123;
final int DEFAULT_FIGHTER_X = 500;
final int DEFAULT_FIGHTER_Y = 240;
final int SCORE_X = 10;
final int SCORE_Y = 470;

// image size
final int FIGHTER_SIZE = 50;
final int ENEMY_SIZE = 60;
final int ENEMY_GAP = (ENEMY_SIZE / 2);
final int TREASURE_SIZE = 40;
final int HP_WIDTH = 202;
final int HP_HEIGHT = 20;
final int BULLET_WIDTH = 32;
final int BULLET_HEIGHT = 27;

// speed
final int BACKGROUND_SPEED = 2;
final int ENEMY_SPEED = 5;
final int FIGHTER_SPEED = 5;
final int BULLET_SPEED = 5;
final int BULLET_TRACE_SPEED = 1;

// level_enemy_num
final int ENEMY_NUM_1 = 5;
final int ENEMY_NUM_2 = 5;
final int ENEMY_NUM_3 = 8;
final int MAX_ENEMY_NUM = 8;

final int BOOM_IMAGE_NONE = -1;
final int MAX_BOOM_IMAGE_NUM = 5;

final int MAX_BULLET_NUM = 5;

int[] arrayBoomX = new int[MAX_ENEMY_NUM];
int[] arrayBoomY = new int[MAX_ENEMY_NUM];
int[] arrayBoomShow = new int[MAX_ENEMY_NUM];
int[] arrayBulletX = new int[MAX_BULLET_NUM];
int[] arrayBulletY = new int[MAX_BULLET_NUM];
boolean[] arrayBulletEnable = new boolean[MAX_BULLET_NUM];

// variables
int gameState;
int enemyTeamType = -1;
boolean changeEnemyTeamType = false;
int slantDirection;
int currentMaxEnemyNum = ENEMY_NUM_1;
// positions
int bgR;
int bg1RX;
int bg2RX;
int fighterX;
int fighterY;
int hpPoint;
int treasureX;
int treasureY;
// keypressed
boolean isLeftPressed;
boolean isRightPressed;
boolean isUpPressed;
boolean isDownPressed;
PImage enemy;
int enemyCount = 8;

int type;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];

int score;
PFont scoreFont;

// images
PImage gameStart1;
PImage gameStart2;
PImage bg1;
PImage bg2;
PImage fighter;
PImage hp;
PImage treasure;
PImage gameLose1;
PImage gameLose2;
PImage bullet;
PImage[] boom = new PImage[5];

void setup () {
	size(640, 480) ;
  bgR = 0;
  bg1RX = 0; // bg1 left side
  bg2RX = -width; // bg2 left side

  // load images
  enemy = loadImage("img/enemy.png");
  gameStart1 = loadImage("img/start2.png");
  gameStart2 = loadImage("img/start1.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  gameLose1 = loadImage("img/end2.png");
  gameLose2 = loadImage("img/end1.png");
  for (int i = 0; i < MAX_BOOM_IMAGE_NUM; i++) {
    boom[i] = loadImage("img/flame" + (i+1) + ".png");
  }
  for (int i = 0; i < MAX_ENEMY_NUM; i++) {
    arrayBoomShow[i] = BOOM_IMAGE_NONE; // not show
  }
  bullet = loadImage("img/shoot.png");

  // default
  gameState = GAME_START;
  isLeftPressed = false;
  isRightPressed = false;
  isUpPressed = false;
  isDownPressed = false;

  score = 0;
  scoreFont = createFont("Arial", 32);

  type = 0;
  addEnemy(type);
  
  // hp
  hpPoint = HP_POINT_DEFAULT;
  
  // fighter
  fighterX = DEFAULT_FIGHTER_X;
  fighterY = DEFAULT_FIGHTER_Y;

  // treasure
  treasureX = floor(random(width-TREASURE_SIZE));
  treasureY = floor(random(height-TREASURE_SIZE));

  frameRate(60);
}

void draw()
{
  background(0);

  switch (gameState) {
  case GAME_START:
    drawGameStart();
    break;
  
  case GAME_RUN:
    drawBackground();
    drawTreasure();
    drawBoom();
    drawFighter();
    drawEnemy();
    drawBullet();

    collisionDetect();
    
    drawScore();
    drawHp();
    break;
  
  case GAME_LOSE:
    drawGameLose();
    break;
  }
}

void drawGameStart() {
  // Mouse in the button rectangle
  if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
    BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
    image(gameStart2, 0, 0);

    // Click
    if (mousePressed) {
      gameState = GAME_RUN;
    }
  } else {
    image(gameStart1, 0, 0);
  }
}

void drawGameLose() {
  // Mouse in the button rectangle
  if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
    BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
    image(gameLose2, 0, 0);

    // Click
    if (mousePressed) {
      gameState = GAME_RUN;
      
      // reset hpPoint & score
      hpPoint = HP_POINT_DEFAULT;
	  score = 0;
      // reset fighter
      fighterX = DEFAULT_FIGHTER_X;
      fighterY = DEFAULT_FIGHTER_Y;
      
      enemyTeamType = -1;
      changeEnemyTeamType = true;
      // Clear Boom
      for (int i = 0; i < MAX_ENEMY_NUM; i++) {
        arrayBoomShow[i] = BOOM_IMAGE_NONE;
      }
      // Clear Bullets
      for (int i = 0; i < MAX_BULLET_NUM; i++){
        arrayBulletEnable[i] = false;
      }
      
      // Reset enemy
      type = 0;
      addEnemy(type);
    }
  } else {
    image(gameLose1, 0, 0);
  }
}

void drawBackground() {
  image(bg1, bg1RX, 0);
  image(bg2, bg2RX, 0);
  bg1RX += BACKGROUND_SPEED;
  if (bg1RX >= width)
    bg1RX = -width;
  bg2RX += BACKGROUND_SPEED;
  if (bg2RX >= width)
    bg2RX = -width;
}

void drawTreasure() {
  image(treasure, treasureX, treasureY);
}

void drawFighter() {
  // Fighter Position
  if (isUpPressed) {
    fighterY -= FIGHTER_SPEED;
  }
  if (isDownPressed) {
    fighterY += FIGHTER_SPEED;
  }
  if (isLeftPressed) {
    fighterX -= FIGHTER_SPEED;
  }
  if (isRightPressed) {
    fighterX += FIGHTER_SPEED;
  }
  // Fighter - Screen Edge Boundery Detection
  if (fighterX <= 0) {
    fighterX = 0;
  } else if (fighterX > width - FIGHTER_SIZE) {
    fighterX = width - FIGHTER_SIZE;
  }

  if (fighterY <= 0) {
    fighterY = 0;
  } else if (fighterY > height - FIGHTER_SIZE) {
    fighterY = height - FIGHTER_SIZE;
  }
  // draw fighter
  image(fighter, fighterX, fighterY);
}

void drawBullet(){
  // draw bullet
  for (int i = 0; i < MAX_BULLET_NUM; i++) {
    if (arrayBulletEnable[i] == false) {
      continue;
    }
    image(bullet, arrayBulletX[i], arrayBulletY[i]);
    arrayBulletX[i]-=BULLET_SPEED;

    // out of screen, disable bullet 
    if (arrayBulletX[i] < -BULLET_WIDTH)
      arrayBulletEnable[i] = false;
      
    int enemyNo = closestEnemy(arrayBulletX[i], arrayBulletY[i]);
    if (enemyNo > -1) {
      // find closest enemy
      if (enemyY[enemyNo] < arrayBulletY[i]) {
        // above bullet
        arrayBulletY[i]-=BULLET_TRACE_SPEED;
      } else {
        // below bullet
        arrayBulletY[i]+=BULLET_TRACE_SPEED;
      }
        
    }
  }
}

void drawHp(){
  fill(#FF0000);
  rect(HP_RED_X, HP_RED_Y, hpPoint*HP_WIDTH/HP_POINT_MAX, HP_HEIGHT, 0, 3, 0, 0);
  image(hp, HP_X, HP_Y);
}

void drawEnemy(){
  boolean isAllOutScreen = true;
  for (int i = 0; i < enemyCount; ++i) {
    if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemy, enemyX[i], enemyY[i]);
      enemyX[i]+=5;
      if (enemyX[i] <= width + ENEMY_SIZE) // + SIZE for longer gap between types
        isAllOutScreen = false;
    }
  }

  // change enemy type
  if (isAllOutScreen == true) {
    type++;
    if (type > 2)
      type = 0;
    addEnemy(type);
  }
}

void drawBoom() {
  int switchNextFlame = (frameCount % (60/6) == 0) ? 1 : 0; 
  for (int i = 0; i < MAX_ENEMY_NUM; i++) {
    if (arrayBoomShow[i] != BOOM_IMAGE_NONE) {
      image(boom[arrayBoomShow[i]], arrayBoomX[i], arrayBoomY[i]);
      arrayBoomShow[i]+=switchNextFlame;
      if (arrayBoomShow[i] >= MAX_BOOM_IMAGE_NUM)
        arrayBoomShow[i] = BOOM_IMAGE_NONE;
    }
  }
}

void drawScore(){
  fill(255);
  textFont(scoreFont);
  text("Score: " + score, SCORE_X, SCORE_Y);
}

// 0 - straight, 1-slope, 2-diamond
void addEnemy(int type)
{	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void addStraightEnemy()
{
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}
}
void addSlopeEnemy()
{
	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
}
void addDiamondEnemy()
{
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}
void scoreChange(int value){
  score += value;
}

boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh) {
  if (ax < bx + bw &&
      ax + aw > bx &&
      ay < by + bh &&
      ah + ay > by) {
    // collision detected!
    return true;
  }
  
  return false;
}

void collisionDetect() {
  boolean hit = false;
  // Enemy hit Detection
  int detectSource = SOURCE_NONE;
  int detectHit = HIT_NONE;
  for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
    if (enemyX[enemyNo] == -1 && enemyY[enemyNo] == -1) {
      continue;
    }

    // fighter hit enemy detect
    hit = isHit(enemyX[enemyNo], enemyY[enemyNo], ENEMY_SIZE, ENEMY_SIZE,
          fighterX, fighterY, FIGHTER_SIZE, FIGHTER_SIZE);
    if (hit == true) {
      detectSource = SOURCE_FIGHTER;
      detectHit = HIT_ENEMY;
    } else {
      // bullet hit detect
      for (int j = 0; j < MAX_BULLET_NUM; j++) {
        if (arrayBulletEnable[j] == false)
          continue;
  
        hit = isHit(enemyX[enemyNo], enemyY[enemyNo], ENEMY_SIZE, ENEMY_SIZE,
            arrayBulletX[j], arrayBulletY[j], BULLET_WIDTH, BULLET_HEIGHT);
        if (hit == true) {
          detectSource = SOURCE_BULLET;
          detectHit = HIT_ENEMY;
          arrayBulletEnable[j] = false;
          break;
        }
      }
    }

    // hit enemy => disable enemy
    if (detectHit == HIT_ENEMY) {
      // Get enemy position as boom position
      for (int j = 0; j < MAX_ENEMY_NUM; j++) {
        // Find space to show boom
        if (arrayBoomShow[j] == BOOM_IMAGE_NONE) {
          arrayBoomX[j] = enemyX[enemyNo];
          arrayBoomY[j] = enemyY[enemyNo];
          arrayBoomShow[j] = 0;
          break;
        }
      }
      
      // clear this enemy
      enemyX[enemyNo] = -1;
      enemyY[enemyNo] = -1;
      break;
    }
  }
  if (hit == false) {
    // Treasure hit Detection
    hit = isHit (treasureX, treasureY, TREASURE_SIZE, TREASURE_SIZE,
                 fighterX, fighterY, FIGHTER_SIZE, FIGHTER_SIZE);
    if (hit == true) {
      detectHit = HIT_TREASURE;
    }
  }

  // Check fighter hit enemy
  if (detectHit == HIT_ENEMY){
    if (detectSource == SOURCE_FIGHTER) {
      hpPoint -= HP_POINT_HIT;
      if (hpPoint <= 0) {
        hpPoint = 0;
        gameState = GAME_LOSE;
      }
    } else if (detectSource == SOURCE_BULLET) {
      scoreChange(ENEMY_SCORE);
    }
  } else if (detectHit == HIT_TREASURE) {
    hpPoint += HP_POINT_ENERGY;
    if (hpPoint >= HP_POINT_MAX) {
      hpPoint = HP_POINT_MAX;
    }

    // reset treasure position
    treasureX = floor(random(width-TREASURE_SIZE));
    treasureY = floor(random(height-TREASURE_SIZE));
  }
    
}

// return enemyNo, if no enemy, return -1 
int closestEnemy(int x, int y){
  int enemyNo = -1;
  int enemyDistance = 999999;
  for (int index=0; index < enemyCount; index++) {
    if (enemyX[index] == -1 && enemyY[index] == -1) {
      continue;
    }

    // enemy not on the left side of bullet
    if (enemyX[index] >= x) {
      continue;
    }
    
    int distance = ((x- enemyX[index])*abs(y-enemyY[index]))/2;
    
    // find nearest enemy
    if (distance < enemyDistance)
    {
      enemyDistance = distance;
      enemyNo = index;
    }
  }

  return enemyNo;
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode)
    {
    case UP:
      isUpPressed = true;
      break;
    case DOWN:
      isDownPressed = true;
      break;
    case LEFT:
      isLeftPressed = true;
      break;
    case RIGHT:
      isRightPressed = true;
      break;
    }
  } else if (key == ' ') {
    // space to shoot bullet
    for (int i = 0; i < MAX_BULLET_NUM; i++) {
      if (arrayBulletEnable[i] == false) {
        arrayBulletEnable[i] = true;
        arrayBulletX[i] = fighterX;
        arrayBulletY[i] = fighterY + (FIGHTER_SIZE / 2) - (BULLET_HEIGHT/2);
        break;
      }
    }
  }
}

void keyReleased() {

  if (key == CODED) {
    switch(keyCode)
    {
    case UP:
      isUpPressed = false;
      break;
    case DOWN:
      isDownPressed = false;
      break;
    case LEFT:
      isLeftPressed = false;
      break;
    case RIGHT:
      isRightPressed = false;
      break;
    }
  }
}
