PImage enemy;
int enemyCount = 8;

int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];

void setup () {
	size(640, 480) ;
	enemy = loadImage("img/enemy.png");
}

void draw()
{

}

// 0 - straight, 1-slope, 2-dimond
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

	println("addStraightEnemy");
}
void addSlopeEnemy()
{
	float t = random(height - 40 * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
	println("addSlopeEnemy");
}
void addDiamondEnemy()
{
	float t = random( 40 * 3 ,height - 40 * 3);
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
	println("addDiamondEnemy");
}