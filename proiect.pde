
String[] card_imgs={"ace.png","2diamond.png","3diamond.png","4diamond.png","5diamond.png","6diamond.png","7diamond.png","8diamond.png", "9diamond.png","3spades.png"};
PImage default_img;
int board_size=20;
int card_size=100;
int time;
boolean locked=false;
int[][] rect_positions=new int[board_size][board_size];
String[] myimages;
ArrayList cards;
color x;
ArrayList pairs;
int incercari=0;
int[] current_time={0,0,0,0};
int[] best_time={0,0,0,0};
int time_trigger=millis()+1000;
boolean win=false;


int totalAnimationFrames = 100;

class Card{
  int x,y,l;
  boolean intors=false;
  PImage img;
  String img_url;
  boolean canFlip=true;
  Card(int _x, int _y, int _l, PImage _img,String _img_url){
    x=_x;
    y=_y;
    l=_l;
    img=_img;
    img_url=_img_url;
  }
  void draw()
  { 



    if (intors){

      image(img,x,y,l,l);
    }
      
    else {
      image(default_img,x,y,l,l);
    }


  }
  boolean checkClick(int _x,int _y)
  {
    
    if(!intors && !locked)
    if (_x>x && _x<x+l && _y>y && _y<y+l){
      intors=true;
      return true;
    }
    return false;
      
  }
}

void setup()
{
  size(800,800,P3D);
  textSize(30);
  default_img=loadImage("blank.png");
  setPosition();
  newGame();
  

}
void draw()
{
   background(255);                        
  for (int i=0;i<cards.size();i++){
    Card x=(Card)cards.get(i);
    x.draw();
  }
  fill(0);
  text("Incercari: "+incercari,200,50);
  text("Timp: "+current_time[0]+current_time[1]+":"+current_time[2]+current_time[3],200,100);
  text("Best time: "+best_time[0]+best_time[1]+":"+best_time[2]+best_time[3],400,50);
   
  if (win){
    text("Ai castigat!",200,150);
    checkBest();
    drawButton();
  }

  else{
  checkPairs();
  updateTime();
  }
  

}

void updateTime()
{
  if (millis()>time_trigger){
    time_trigger=millis()+1000;
    current_time[3]++;
  }
  if (current_time[3]==10){
    current_time[2]++;
    current_time[3]=0;
    if (current_time[2]==6){
      current_time[1]++;
      current_time[2]=0;
      if (current_time[1]==10){
        current_time[0]++;
        current_time[1]=0;
      }
    }
  }


 
}

void mousePressed()
{
  
    if (win)
     checkBtnClick(380,125,200,30);
     
    else{
    for (int i=0;i<cards.size();i++){
    Card x=(Card)cards.get(i);
    if (x.checkClick(mouseX,mouseY)){

      pairs.add(x);
      time=millis()+1000;   
     }
   }
  }

}

void drawButton()
{
  fill(255);
  stroke(0);
  rect(380,125,200,30);
  fill(0);
  text("Joaca din nou",390,150);
 
  
}
void checkBtnClick(int x, int y, int w, int h)
{
  if (mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h)
  newGame();
}

void checkBest()
{

  int current_time_seconds=current_time[3]+current_time[2]*10+(current_time[1]+current_time[0]*10)*60;
  int best_time_seconds=best_time[3]+best_time[2]*10+(best_time[1]+best_time[0]*10)*60;

  if (current_time_seconds<= best_time_seconds || best_time_seconds ==0)
     for (int i=0;i<4;i++)
        best_time[i]=current_time[i];
}

void newGame()
{

  cards=new ArrayList();
  pairs=new ArrayList();
  win=false;
  incercari=0;
  for(int i=0;i<4;i++) current_time[i]=0;
  chooseImages();
  for (int i=0;i<board_size;i++){
   cards.add(new Card(rect_positions[i][0],rect_positions[i][1],card_size,loadImage(myimages[i]),myimages[i]));
  }

  
}

void checkPairs(){

  Card first,second;
  if (pairs.size()==2){  
   locked=true;
   first=(Card)pairs.get(0);
   second=(Card)pairs.get(1);
   
  
    if(first.img_url!=second.img_url){
      if (millis()>time){
         first.intors=second.intors=false;
         incercari++;
         pairs=new ArrayList();
         locked=false;
     }
    }
    else{
     incercari++;
     pairs=new ArrayList();
     locked=false;
    }
   
    if (checkWin())
      win=true;
  
   
  }

}

void chooseImages(){

  String[] images=new String[10];
   myimages=new String[board_size];
   
 for (int i=0;i<card_imgs.length;i++)
   images[i]=card_imgs[i];
 
  for (int i=0;i<board_size;){
    int r_image=(int)random(0,10);
    if (images[r_image]!="")
    for (int j=0;j<2;){
      int r_position=(int)random(0,board_size);
      if (myimages[r_position]==null){        
        myimages[r_position]=images[r_image];
        j++;
        i++;
      }
    
    }
    images[r_image]="";
  
     
  }
}

void setPosition(){
  int x=200,y=200;
  for(int i=0;i<board_size;i++){
     rect_positions[i][0]=x;
     rect_positions[i][1]=y;
     x+=card_size;
     if ((i+1)%4==0 ){
       y+=card_size;
       x=200;
     }    
  }
}

boolean checkWin(){
  for (int i=0;i<cards.size();i++){
    Card x=(Card)cards.get(i);
    if (x.intors==false)
    return false;
  }
  return true;
}
