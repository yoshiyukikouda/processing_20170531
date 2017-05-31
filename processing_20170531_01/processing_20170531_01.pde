// 摩擦
import processing.opengl.*;

Mover movers[] = new Mover[50];

/*
* 初期設定
*/
void setup() {
  size(600, 500, OPENGL);
  for (int i = 0; i < movers.length; i++)
  {
    movers[i] = new Mover(random(0.1, 4), random(0, width), random(0, height), random(-300, -50), random(0, 255), random(0, 255), random(0, 255), 255);
  }
}

/*
* 随時描写
*/
void draw() { 
  // 背景描写
  background(255);
  drawBackground(  0, 0, 0, 255, 255, 255,   0);
  drawBackground(200, 0, 0,   0,   0,   0, 100);
  drawBackground(400, 0, 0, 255, 255,   0, 100);
  
  // 風力
  PVector wind = new PVector(0.001, 0, 0);
  // 重力
  PVector gravity = new PVector(0, 0.1, 0);

  // 表示更新
  for (int i = 0; i < movers.length; i++) {
    // 摩擦力
    if (movers[i].location.x > 200 && movers[i].location.x < 400) {
      // 移動に対する摩擦（風力、重力の逆値 * 0.01）
      float c = 0.01;
      PVector friction = movers[i].velocity.get();
      friction.mult(-1);
      friction.normalize();
      friction.mult(c); 
      movers[i].applyForce(friction);
    } else if (movers[i].location.x > 400 && movers[i].location.x < 600) {
      // 移動に対する摩擦の反転値
      float c = 0.01;       
      PVector friction = movers[i].velocity.get();
      friction.mult(1);
      friction.normalize();
      friction.mult(c); 
      movers[i].applyForce(friction);
    }
    
    // 風力、重力の積算
    movers[i].applyForce(wind);
    movers[i].applyForce(gravity);

    // 移動オブジェクト描写
    movers[i].update();
    movers[i].checkEdges();
    movers[i].display();
  }
}

/*
* 背景描写
* @param : x      X座標
* @param : y      Y座標
* @param : z      Z座標
* @param : r      Red
* @param : g      Green
* @param : b      Blue
* @param : alpha  透過度
*/
void drawBackground(int x, int y, int z, int r, int g, int b, int alpha) {
  // 図形の色、線
  stroke(r-50, g-50, b-50);
  strokeWeight(1);
  fill(r, g, b, alpha);

  // 描写開始
  pushMatrix();
  translate(x, y, z);
  beginShape(QUADS);
  
  // 後ろ
  vertex(200, height, -300);
  vertex(0, height, -300);
  vertex(0, 0, -300);
  vertex(200, 0, -300);
  // 下
  vertex(0, height, -300);
  vertex(200, height, -300);
  vertex(200, height, 0);
  vertex(0, height, 0);
  // 上
  vertex(0, 0, -300);
  vertex(200, 0, -300);
  vertex(200, 0, 0);
  vertex(0, 0, 0);
  
  // 描写終了
  endShape();
  popMatrix();
}

/*
* 移動オブジェクトクラス
*/
class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r, g, b, alpha;
  float objSize;
  
  /*
  * コンストラクタ
  * @param : m      質量
  * @param : x      X座標
  * @param : y      Y座標
  * @param : z      Z座標
  * @param : r_     Red
  * @param : g_     Green
  * @param : b_     Blue
  * @param : alpha  透過度
  */
  Mover(float m, float x, float y, float z, float r_, float g_, float b_, float alpha_) {
    // 質量
    mass = m;
    // オブジェクトサイズ
    objSize = mass * 16;
    // 位置
    location = new PVector(x + objSize, y + objSize, z + objSize);
    // 速度
    velocity = new PVector(0, 0, 0);
    // 加速度
    acceleration = new PVector(0, 0, 0);
    // カラー
    r = r_;
    g = g_;
    b = b_;
    alpha = alpha_;
  }
  
  /*
  * 位置、速度の更新
  */
  void update() {
    // 速度に加速度を加算
    velocity.add(acceleration);
    // 現在位置に速度分の移動を加算
    location.add(velocity);
    // 加速度の初期化
    acceleration.mult(0);
  }
  
  /*
  * 画面表示
  */
  void display() {
    // 図形の色・線
    stroke(r - 10, g - 10, b - 10);
    strokeWeight(1);
    fill(r, g, b, alpha);
    
    // 描写
    pushMatrix();
    translate(location.x, location.y, location.z);
    box(mass * 16);
    popMatrix();
  } 

  /*
  * ウィンドウ端に到達した場合の処理
  */
  void checkEdges() {
    // X軸方向で壁に到達した場合
    if (location.x > width- objSize) {
      location.x = width- objSize;
      velocity.x *= -1;
    } else if (location.x < 0 + objSize) {
      velocity.x *= -1;
      location.x = 0 + objSize;
    } 

    // Y軸方向で壁に到達した場合
    if (location.y > height - objSize) {
      velocity.y *= -1;
      location.y = height - objSize;
    } else if (location.y < 0 + objSize) {
      velocity.y *= -1;
      location.y = 0 + objSize;
    }

    // Z軸方向で壁に到達した場合
    if (location.z > -50 - objSize) {
      velocity.z *= -1;
      location.z = -50 - objSize;
    } else if (location.z < -300 + objSize) {
      velocity.z *= -1;
      location.z = -300 + objSize;
    } 
  }
  
  /*
  * 力の積算
  * @param : force      加算する力
  */
  void applyForce(PVector force) 
  {
    // 加速度に力を加算
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
}