Mover[] m;
Attractor[] a;

int moverCount = 2000;
int attractorCount = 1;
String runInstanceName = timeStamp();
boolean zoomed = false;
boolean trail=false;
boolean started = false;
float offsetX  = 0;
float zoom = 1;
float offsetY = 0;
int[] masses;
float G = 1;
PFont mono;
boolean bigOne=true;
int swallowedObjectsSolar = 0;
int swallowedObjectsPlanet = 0;

float originalSolarMass = 0.0;

void setup() {
  //size(1200, 800);
  fullScreen();
  start();
}

void start() {
  mono = loadFont("AnonymousPro-11.vlw");
  textFont(mono);
  textSize(11);
  masses = new int[5];

  m = new Mover[moverCount];
  a = new Attractor[attractorCount];
  for (int i=0; i<moverCount; i++)
  {
    m[i] = new Mover((random(0, 1000)<1));
  }
  for (int i=0; i< attractorCount; i++)
  {
    a[i] = new Attractor();
  }
  a[0].location = new PVector(width/2, height/2);
 
  started=true;
}

void draw() {
  if (started)
  {    
    background(0);
    started=false;
  }

  if (!trail)
    background(0);

  for (int i=0; i<moverCount; i++)
  {
    if (!m[i].swallowed)
    {
      for (int t=0; t<moverCount; t++)
      {
        if (!m[t].swallowed)
        {
          if (t != i)
          {
            PVector subForce = m[i].attract(m[t]);
            m[i].applyForce(subForce);
          }
        }
      }

      for (int j=0; j<attractorCount; j++)
      {   
        PVector force = a[j].attract(m[i]);
        m[i].applyForce(force);
      }
      m[i].update();
      m[i].display();
    }
  }

  for (int j=0; j<attractorCount; j++)
    a[j].display();

  fill(215, 216, 237);
  text("current frame  : " + frameCount, 10, 10);
  //text("framerate      : " + nfc(frameRate, 1) + "fps", 10, 22);
  //text("planet crashes : " + swallowedObjectsPlanet, 10, 34);
  //text("solar crashes  : " + swallowedObjectsSolar, 10, 46);
  //text("solar mass     : " + nfc(a[0].mass, 1) + "(+" + nfc(a[0].mass - originalSolarMass, 1) + ")", 10, 58);

  //saveImage(frameCount);
}

void saveImage(int fc)
{
  save(runInstanceName + "\\" + nf(fc, 6) + ".png" );
}

String timeStamp()
{
  return nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + nf(millis(), 2);
}

void keyPressed()
{
  if (key=='z')
    zoomed = !zoomed;

  if (key=='-')
    zoom*=1.5;

  if (key=='+')
    zoom/=1.5;

  if (key=='t')
    trail=!trail;

  if (key=='s')
    start();

  if (keyCode==LEFT)
    offsetX -=100;

  if (keyCode==RIGHT)
    offsetX += 100;

  if (keyCode==UP)
    offsetY -= 100;

  if (keyCode==DOWN)
    offsetY += 100;
}