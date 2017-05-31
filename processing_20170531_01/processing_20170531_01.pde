// 摩擦
Mover movers[] = new Mover[50];

/*
* 初期設定
*/
void setup() {
  frameRate(60);
  size(600, 400);
  for (int i = 0; i < movers.length; i++)
  {
    movers[i] = new Mover(random(0.1, 4), 0, 0, random(0, 255), random(0, 255), random(0, 255), 255);
  }
}

/*
* 随時描写
*/
void draw() {
  // 背景描写
  fill(0, 20);
  rect(0, 0, 200, height);
  fill(0, 255, 0, 30);
  rect(200, 0, 200, height);
  fill(255, 255, 0, 30);
  rect(400, 0, 200, height);

  // オブジェクトの軌跡
  noStroke();
  fill(255, 20);
  rect(0, 0, width, height);

  // 風力
  PVector wind = new PVector(0.001, 0);
  // 重力
  PVector gravity = new PVector(0, 0.1);

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
  
  //// フレームセーブ
  //saveFrame("frames/######.tif");
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
  */
  Mover(float m, float x, float y, float r_, float g_, float b_, float alpha_) {
    // 質量
    mass = m;
    // オブジェクトサイズ
    objSize = mass * 16;
    // 位置
    location = new PVector(x, y);
    // 速度
    velocity = new PVector(0, 0);
    // 加速度
    acceleration = new PVector(0, 0);
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
    noStroke();
    fill(r, g, b);
    //ellipse(location.x, location.y, mass * 16, mass * 16);
    rect(location.x, location.y, mass * 16, mass * 16);
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
    }
  }
  
  /*
  * 力の積算
  */
  void applyForce(PVector force) 
  {
    // 加速度に力を加算
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
}