/*************
 **  Choice_University_FINAL.pde
 **  Wesley Mauder, Saurabh Chapagain, Julian Adams,  Karanjeet Toor, Dylan Mendoza
 **  12/10/2021
 **
 **  Final Version of Choice University 
 */

PFont myFont; // Custom Font
PImage dropOut,player,MainMenu; // Player image and dropout image
int locationIndex; //Variable that determines PImage array location
boolean playerQuit = false; //Boolean responsible for determining if player hit the dropout button
boolean Gameover = false; //Boolean flag responsible for ending the game
boolean gameStart = false;
boolean tutorial = false;

//Varibles to keep track of time
int currentHour=8;
int currentDay=1;
int currentWeek=1;

//Player Stats
int Happiness;
int Wealth;
int Grades;
int Hunger; 

StringList RandomEvents;

//Music setup
import processing.sound.*;
SoundFile file;
SoundFile file2;

int[] BarX = {180, 180, 180, 180};
int[] BarY = {261, 301, 341, 381};
int[] BarWidth = {125, 125, 125, 125};
int[] DisplayAmount = new int[4];
int[] BarHight = {15, 15, 15, 15};

//Variables and arrays in control of W and S movement
int movementIndex = 0;
int movementBoxX;
int movementBoxY;
int[] movementX = {395,680,680,680,435,600,375,375,375,375,375,170,370,640};
int[] movementY = {25,85,195,300,490,100,150,210,270,330,390,250,250,250};

Button button1 = new Button();
Button button2 = new Button();
Button button3 = new Button();
Button Map = new Button();

void setup() {
  size(999, 562);
  dropOut = loadImage("dropout.gif");
  MainMenu = loadImage("Images/Title_Screen.jpg");
  player = loadImage("Player.png");
  //Loads all Images
  locationImages[0] = loadImage("Images/The_Commons.jpg");
  locationImages[1] = loadImage("Images/Library.jpg");
  locationImages[2] = loadImage("Images/Gym.jpg");
  locationImages[3] = loadImage("Images/Dorm.jpg");
  locationImages[4] = loadImage("Images/Class.jpg");
  locationImages[5] = loadImage("Images/Map.jpg");
  randomEventImages[0] = loadImage("Coca_Cola_Ad_8-bit.jpg");
  randomEventImages[1] = loadImage("Caffine_pill_ad.jpg");
  randomEventImages[2] = loadImage("Hot_dogs_in_your_area_ad.jpg");
  randomEventImages[3] = loadImage("scam_ad.jpg");
 
  //Custom font
  myFont = createFont("minecraft_font.ttf", 32);
  textFont(myFont);
  
  //Intialzies all Stats
  Happiness = int(random(25, 124));
  Grades = int(random(25, 124));
  Wealth = int(random(25, 124));
  Hunger = int(124);
  updateBars();
  DisplayAmount[0] = Happiness;
  DisplayAmount[1] = Grades;
  
  //Init Music
  file = new SoundFile(this, "Sample Music.wav");
  file2 = new SoundFile(this, "Day_Music.wav");
  //file2.play();
  
}

void draw() {

if (gameStart == false && tutorial == false) {
  image(MainMenu, 0, 0);
  if (key == ' '){
   tutorial=true;
   
  }
}
if (tutorial == true) {
  fill(55);
  rect(0,0, 999, 562);
  fill(255, 215, 0);
  textSize(25);
  text("    Welcome to Choice University, here at UMBC you’ll be faced with choices you have to make, be them good or bad. Throughout this game you will have free reign to do whatever you want, just be careful, your stats only update at the end of a week so you have to be mindful of what you do during your week.", 20, 20, 999, 552 );
  text("    Simply use w and s to navigate through the menus to select a choice for that moment with the space bar. To change locations simply hover over the current location to access the drop down menu. Be careful how you spend your money, you only get a fixed amount each week", 20, 260, 999, 552 );
  image(player,800,390,180,180);
  if (key == ' '){
   gameStart=true;
  }
}
  
  
if (gameStart == true) {
  
  if (Gameover == true){
    delay(20000);
    exit();
  }

  displaylocation();
  
  updateBars();
  
  drawBars();
  drawTime();

  displayChoices();
  
  dialogue();
  mapPopup();
  changeLocation();
   
  MusicCheck();
  
  randomEvents();
  movement();
  
  if ((currentWeek == 13 && currentDay == 7 && currentHour == 24) || currentWeek > 13 || Hunger == 0) {
    THE_END_OF_TIME();
  }
  
  }
}

void MusicCheck() {
  if (currentHour > 12 && (file2.isPlaying() == true) ) { 
    file.loop();
    file2.stop();
  }
  else if (currentHour < 12 && file.isPlaying() == true) {
    file2.loop();
    file.stop();
  }

}
//Function that draws the in game time
void drawTime(){
  if (currentHour>24){
     currentHour=currentHour-24;
     currentDay++;
    }
  if (currentDay>7){
     currentDay=1;
     currentWeek++;
    }
  textSize(12);
  fill(70);
  rect(664, 388, 100, 30);

  fill(255);
  text("W: "+currentWeek+" D: "+currentDay+" H: "+currentHour,670,408);
}

//Deals with Stat bars in Lower Left corrner. -Julian
void updateBars() {
  if (currentDay == 7 && currentHour >= 24) {
    Wealth=+100;
    DisplayAmount[0] = Happiness;
    DisplayAmount[1] = Grades;
  }
    DisplayAmount[2] = Wealth;
    DisplayAmount[3] = Hunger;
  
  
  if (DisplayAmount[0] > 125)
    DisplayAmount[0] = 124;
  if (DisplayAmount[1] > 125)
    DisplayAmount[1] = 124;
  if (DisplayAmount[2] > 125)
    DisplayAmount[2] = 124;
  if (DisplayAmount[3] > 125)
    DisplayAmount[3] = 124;
    
  if (DisplayAmount[0] < 0)
    DisplayAmount[0] = 0;
  if (DisplayAmount[1] < 0)
    DisplayAmount[1] = 0;
  if (DisplayAmount[2] < 0)
    DisplayAmount[2] = 0;
  if (DisplayAmount[3] < 0)
    DisplayAmount[3] = 0;
}
//Function that draws the player's stats
void drawBars(){
  strokeWeight(2);
  fill(205);
  for (int i = 0; i < BarX.length; i++) {
    rect(BarX[i], BarY[i], BarWidth[i], BarHight[i]);
  }
  strokeWeight(1);
  fill(255, 0, 0);
  for (int i = 0; i < BarX.length; i++)
    rect(BarX[i]+1, BarY[i]+1, DisplayAmount[i], BarHight[i]-2);
}
//Function that is responsible for W and S movement
void movement()
{
  //If statements determine action outline size depending on location
  if(movementIndex == 0)
  {
    movementBoxX = 195;
    movementBoxY = 53;
  }
  if(movementIndex <= 3 && movementIndex > 0)
  {
    movementBoxX = 147;
    movementBoxY = 51;
  }
  if(movementIndex == 4)
  {
    movementBoxX = 127;
    movementBoxY = 60;
  }
  if(movementIndex == 5)
  {
      movementBoxX = 50;
      movementBoxY = 50;
  }
  if(movementIndex > 5)
  {
    movementBoxX = 250;
    movementBoxY = 50;
  }
  if(movementIndex == 12)
  {
    movementBoxX = 270;
    movementBoxY = 170;
  }
  if(movementIndex == 11 || movementIndex == 13)
  {
    movementBoxX = 200;
    movementBoxY = 180;
  }
  //Fill and drawing of action outline
  fill(128,128,0,175);
  rect(movementX[movementIndex],movementY[movementIndex],movementBoxX,movementBoxY);
  
}
//Additional function necessary for outline movement
void keyReleased()
{
 if(key == ' ' && movementIndex == 0)
 {
   key = 'm';
   movementIndex = 6;
 }
 if(key == 'w' && movementIndex > 0 && !displayRandomEvent)
   movementIndex --;
 if(key == 's' && movementIndex < 10)
   movementIndex++;
 if(key == ' ' && movementIndex == 5)
   movementIndex = 0;
 if(key == 's' && movementIndex == 5 && !displayMapPopup)
   movementIndex--;
 if(key == 'w' && movementIndex == 4 && displayMapPopup)
   movementIndex++;
 if(key == 's' && movementIndex == 11)
   movementIndex = 13;
 if(key == 'w' && movementIndex == 13)
   movementIndex = 11;
 if(key == 'w' && movementIndex == 12)
   movementIndex = 11;
 if(key == 's' && movementIndex == 12)
   movementIndex = 13;
}

void THE_END_OF_TIME() {
    file.stop();
    file2.stop();
  
  //Starve to death
  if (Hunger == 0) {
    image(dropOut, 330, 0, 330, 465);
    fill(50, 50, 50, 250);
    rect(0, 300, 999, 300);
    textSize(30);
    fill(255, 0, 0);
    text("You starved to death?", 25, 440);
    text("You should have eaten something,", 25, 480);
    text("be more mindful of your health.", 25, 520);
     
    
  }
  else if (Grades < 60) {
    image(dropOut, 330, 0, 330, 465);
    fill(50, 50, 50, 250);
    rect(0, 300, 999, 300);
    textSize(30);
    fill(255, 0, 0);
    text("I am very disappointed in you", 25, 440);
    text("school isn't just about having fun,", 25, 480);
    text("you need to be more mindful of your studies.", 25, 520);
    
    
  }
   else {
    image(dropOut, 330, 0, 330, 465);
    fill(50, 50, 50, 250);
    rect(0, 300, 999, 300);
    textSize(30);
    fill(255, 0, 0);
    text("Congratulations!", 25, 440);
    text("You made it through your first semester,", 25, 480);
    text("I hope to see you for years to come!", 25, 520);
  }
    
    
    Gameover = true;
}

//split later into dettect mouse and run functions based on mouse Pos
