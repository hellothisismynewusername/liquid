Block[] blocks;
int rows;
int sizeMult;
boolean direction;
float totalCounter;
int mode;
int count;
boolean right;
boolean left;
boolean down;
boolean lines;
boolean speedcap;

void setup() {
  noStroke();
  frameRate(9999);
  size(1000,1000);
  textSize(20);
  
  blocks = new Block[10000];
  for (int i = 0; i < blocks.length; i++) {
    blocks[i] = new Block();
  }
  rows = 100;
  sizeMult = 10;
  direction = false;
  mode = 0;
  count = 0;
  right = false;
  left = false;
  down = false;
  lines = true;
  speedcap = false;
}

void keyPressed() {
  if (key == 'y') {    //toggle grid
    lines = !lines;
  }
  if (key == 'u') {    //toggle framerate cap
    if (speedcap) {
      frameRate(60);
      speedcap = !speedcap;
    } else if (speedcap == false) {
      frameRate(9999);
      speedcap = !speedcap;
    }
  }
  if (key == 't') {    //switch right-click functionality
    fill(255);
    if (mode < 3) {
      mode++;
    } else {
      mode = 0;
    }
  }
  if (key == 'c') {    //print how much total liquid there is
    totalCounter = 0;
    frameRate(0);
    for (int i = 0; i < blocks.length; i++) {
      totalCounter += blocks[i].amount;
    }
    println(totalCounter);
    frameRate(9999);
  }
}

void draw() {
  background(30);
  
  for (int i = 0 ; i < blocks.length; i++) {
    
    if(mousePressed && mouseButton == LEFT) {
      if(mouseX > sizeMult * (i % rows) && mouseX < sizeMult + (sizeMult * (i % rows))) {
        if (mouseY > sizeMult * (i/rows) && mouseY < sizeMult + (sizeMult * (i/rows))) {
          blocks[i].amount = 255;
        }
      }
    }
    if(mousePressed && mouseButton == RIGHT) {
      if(mouseX > sizeMult * (i % rows) && mouseX < sizeMult + (sizeMult * (i % rows))) {
        if (mouseY > sizeMult * (i/rows) && mouseY < sizeMult + (sizeMult * (i/rows))) {
          switch (mode) {
            case 0:
              blocks[i].amount = 0;
              blocks[i].type = 1;
              break;
            case 1:
              blocks[i].amount = 0;
              blocks[i].type = 0;
              break;
            case 2:
              blocks[i].amount = 0;
              blocks[i].type = 2;
              break;
            case 3:
              blocks[i].type = 3;
              break;
          }
        }
      }
    }
    
    switch (round(random(0,1))) {
      case 0:
        break;
      case 1: 
        direction = !direction;
        break;
      default:
        println("whoops");
        break;
    }
    
    if (blocks[i].type == 2) {
      blocks[i].amount = 0;
    }
    if (blocks[i].type == 3) {
      blocks[i].amount = 127;
    }
    
    switch (blocks[i].type) {
      case 0:
        fill(100,100,255,blocks[i].amount * 5);
        break;
      case 1:
        fill(255,0,0,255);
        break;
      case 2:
        fill(0,255,255,255);
        break;
      case 3:
        fill(0,255,0,255);
        break;
      case 4:
        fill(255,255,255,255);
        break;
    }
    rect(sizeMult * (i % rows), sizeMult * (i/rows),sizeMult,sizeMult); 
    
    fill(255 - blocks[i].amount,255 - blocks[i].amount,255 - blocks[i].amount,255);
    textSize(8);
    //text(i + " " + nf((blocks[i].amount/blocks[i].maxAmount), 0, 2),(sizeMult * (i % rows)) + 1, (sizeMult * (i/rows)) + 10);
    //text(i + " " + blocks[i].falling,(sizeMult * (i % rows)) + 1, (sizeMult * (i/rows)) + 10);
    //text(i,(sizeMult * (i % rows)) + 1, (sizeMult * (i/rows)) + 10);
    
    if (i < (sqrt(blocks.length)) * (rows - 1)) { //if it's on a row higher than the last row
      if (blocks[i + rows].amount < blocks[i + rows].maxAmount && blocks[i].amount > 0 && blocks[i + rows].type != 1) {
        blocks[i].falling = true;
        blocks[i].amount -= blocks[i].amount * 0.1;
        blocks[i + rows].amount += blocks[i].amount * 0.1111111;
      } else {
        blocks[i].falling = false;
      }
    }
    
    //if (blocks[i].amount > blocks[i].maxAmount && blocks[i - rows].amount < blocks[i - rows].maxAmount && i > rows) {
    //  blocks[i].falling = true;
    //  blocks[i].amount -= blocks[i].amount * 0.1;
    //  blocks[i - rows].amount += blocks[i].amount * 0.1111111;
    //} else {
    //  blocks[i].falling = false;
    //}
    if (direction == false && i < blocks.length - 1 && blocks[i + 1].type != 1 && blocks[i + 1].type != 4 && blocks[i].type == 0 && blocks[i + 1].amount < blocks[i + 1].maxAmount && blocks[i].amount > 0 && (i % rows) != rows - 1 && blocks[i].falling == false) {
      blocks[i].amount -= blocks[i].amount * 0.1;
      blocks[i + 1].amount += blocks[i].amount * 0.1111111;
    }
    if (i % rows != 0 && direction == true && i > 1 && blocks[i - 1].type != 1 && blocks[i].type == 0 && blocks[i - 1].type != 4 && blocks[i - 1].amount < blocks[i - 1].maxAmount && blocks[i].amount > 0 && blocks[i].falling == false) {
      blocks[i].amount -= blocks[i].amount * 0.1;
      blocks[i - 1].amount += blocks[i].amount * 0.1111111;
    }
    
    if (direction == false && i < blocks.length - 1 && blocks[i + 1].type != 1 && blocks[i].type == 0 && blocks[i + 1].type != 4 && blocks[i + 1].amount < blocks[i + 1].maxAmount && blocks[i].amount > 0 && (i % rows) != rows - 1 && blocks[i].falling == true) {
      blocks[i].amount -= blocks[i].amount * 0.02;
      blocks[i + 1].amount += blocks[i].amount * 0.02;
    }
    if (direction == true && i > 1 && blocks[i - 1].type != 1 && blocks[i].type == 0 && blocks[i - 1].type != 4 && blocks[i - 1].amount < blocks[i - 1].maxAmount && blocks[i].amount > 0 && i % rows != 0 && blocks[i].falling == true) {
      blocks[i].amount -= blocks[i].amount * 0.02;
      blocks[i - 1].amount += blocks[i].amount * 0.02;
    }
    
    if (i < blocks.length - rows && blocks[i].type == 4 && blocks[i + rows].type == 0 && blocks[i + rows].amount <= 150) {
      blocks[i].type = 0;
      blocks[i].amount = blocks[i + rows].amount;
      blocks[i + rows].type = 4;
      blocks[i + rows].amount = 0;
    }
    if (i < blocks.length - rows && blocks[i].type == 0 && blocks[i].amount > 150 && blocks[i + rows].type == 4) {
      blocks[i + rows].type = 0;
      blocks[i + rows].amount = blocks[i].amount;
      blocks[i].type = 4;
      blocks[i].amount = 0;
    }
    if (i % rows != 49 && right == true && blocks[i].type == 4 && blocks[i + 1].type == 0 && count == 0) {
      blocks[i].type = 0;
      blocks[i + 1].type = 4;
      right = false;
    }
    if (i % rows != 0 && left == true && blocks[i].type == 4 && blocks[i - 1].type == 0 && count == 0) {
      blocks[i].type = 0;
      blocks[i - 1].type = 4;
      left = false;
    }
    if (i < blocks.length - rows && blocks[i].type == 4 && blocks[i + rows].type == 0 && down == true) {
      blocks[i].type = 0;
      blocks[i].amount = blocks[i + rows].amount;
      blocks[i + rows].type = 4;
      blocks[i + rows].amount = 0;
    }
    
    if (count < 10) {
      count++;
    } else {
      count = 0;
    }
  }
  
  if (lines) {
    fill(0,0,0,255);
    for (int i = 0; i < rows; i++) {
      rect((sizeMult * i), 0, 1, 1000);
      rect(0, (sizeMult * i), 1000, 1);
    }
  }
  
  textSize(20);
  fill(255);
  if (mode == 0) {
    text("create",5,20);
  } else if (mode == 1) {
    text("remove",5,20);
  } else if (mode == 2) {
    text("hole",5,20);
  } else if (mode == 3) {
    text("faucet",5,20);
  }
  
  if (speedcap == false) {
    textSize(15);
    text("fps limited", 5, 40);
  }
}
