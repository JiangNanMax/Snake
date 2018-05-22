int backgroundColor = 244;
int snakeLength = 2;    //Initial length of snake
int snakeHeadX;         //head(x,y)
int snakeHeadY;
char snakeDirection = 'R';  //UP/DOWN/LEFT/RIGHT
char snakeDirectionTemp;
int pause = 0;              //use for pause

int w=20;   //SnakeHead's Food's and oneStep's length(pix)

int maxSnakeLength = 400;
int[] x = new int [maxSnakeLength];
int[] y = new int [maxSnakeLength];

boolean foodKey = true;
int foodX;
int foodY;

int bestScore = snakeLength;
boolean gameOverKey = false;

int savedTime; 
int totalTime;
int passedTime;

void setup(){
    size(500,500);
    frameRate(30);
    noStroke();
    savedTime = millis(); 
}

int speed = 5;  //范围1~20比较好些，每秒移动的步数

void draw(){
    totalTime = 1000/speed; 
    passedTime = millis()- savedTime;

    if ( snakeDirection!='P' && passedTime > totalTime ) {
        if(isGameOver() ){
            speed = 5;  //set the orogin speed
            return;
        }

        background(backgroundColor);

        switch(snakeDirection){
            case 'L':
                snakeHeadX -= w;
                break;
            case 'R':
                snakeHeadX += w;
                break;
            case 'D':
                snakeHeadY += w;
                break;
            case 'U':
                snakeHeadY -= w;
                break;

        }

        //add another food
        drawFood(width,height);

        //eat it
        if( snakeHeadX == foodX && snakeHeadY == foodY){
            snakeLength++;
            //set the speed
            speed ++;
            speed = min(15,speed);  //speed's max value is 15
            foodKey = true;
        }

        //store snake body
        for(int i=snakeLength-1; i>0; i--){
            x[i] = x[i-1];
            y[i] = y[i-1];
        }

        //store snake new head
        y[0] = snakeHeadY;
        x[0] = snakeHeadX;

        stroke(0);  //Black
        strokeWeight(1);    //线宽为1

        //draw snakeHead
        fill(#ED1818);
        rect(x[0],y[0],w,w);

        //draw snakeBody
        fill(#7B6DB7);
        for(int i=1; i<snakeLength; i++){
            rect(x[i],y[i],w,w);
        }

        if(snakeDirection!='P' && isSnakeDie()){
            return;
        }

        savedTime = millis(); //passedTime=millis()-savedTime
    }

}//end draw()

//keyboard interrupt
void keyPressed() {
    if(key == 'p' || key == 'P'){
        pause++;
        if(pause%2==1){
            snakeDirectionTemp = snakeDirection;
            snakeDirection = 'P';
        }else{
            snakeDirection = snakeDirectionTemp;
        }

    }
    if(snakeDirection != 'P' && key == CODED){
        switch(keyCode){
            case LEFT:
                snakeDirection = 'L';
                break;
            case RIGHT:
                snakeDirection = 'R';
                break;
            case DOWN:
                snakeDirection = 'D';
                break;
            case UP:
                snakeDirection = 'U';
                break;
        }
    }else if(snakeDirection != 'P'){
        switch(key){
            case 'A':
            case 'a':
                snakeDirection = 'L';
                break;
            case 'D':
            case 'd':
                snakeDirection = 'R';
                break;
            case 'S':
            case 's':
                snakeDirection = 'D';
                break;
            case 'W':
            case 'w':
                snakeDirection = 'U';
                break;
        }
    }else{
        ;
    }
}   //end keyPressed()

void snakeInit(){
    background(backgroundColor);
    snakeLength = 2;
    gameOverKey = false;
    snakeHeadX = 0;
    snakeHeadY = 0;
    snakeDirection = 'R';
}

void drawFood(int maxWidth, int maxHeight){
    fill(#ED1818);
    if(foodKey){
        foodX = int( random(0, maxWidth)/w ) * w;
        foodY = int( random(0, maxHeight)/w) * w;
    }
    rect(foodX, foodY, w, w);
    foodKey = false;
}

boolean isGameOver(){
    if(gameOverKey && keyPressed && (key=='r'||key=='R') ){
        snakeInit();
    }
    return gameOverKey;
}

boolean isSnakeDie(){
    //hitting the wall
    if(snakeHeadX<0 || snakeHeadX>=width || snakeHeadY<0 || snakeHeadY>=height){
        showGameOver();
        return true;
    }

    //eat itself
    if(snakeLength>2){
        for(int i=1; i<snakeLength; i++){
            if(snakeHeadX==x[i] && snakeHeadY == y[i]){
                showGameOver();
                return true;
            }
        }
    }

    return false;
}

void showGameOver(){
    pushMatrix();
    gameOverKey = true;
    bestScore = bestScore > snakeLength ? bestScore : snakeLength;

    background(0);  //black
    translate(width/2, height/2 - 50);
    fill(255);  //white
    textAlign(CENTER);  //居中对齐
    textSize(84);
    text(snakeLength + "/" + bestScore, 0, 0);

    fill(120);
    textSize(18);
    text("Score / best",0,230);
    text("Game Over, Press 'R' to restart.", 0, 260);

    popMatrix();
}
