/*
  Universidade Federal de Goiás
  Tópicos 2 - Programação Criativa
  Aluno: Carlos Henrique Rorato Souza
  Tema: Cidade Noturna
  Título: Minha cidade. Meu céu.
*/


int altura = 400; //altura do chão dos prédios
int qtd_estrelas = 200;
float luaX = 900.0,luaY=100.0;
PImage img_nuvem;
PImage img_bg, img_luz, img_luz2, img_estrutura, img_torre, img_arvores;

//luzes coloridas
int qtdLuzes = 10;
float[] luzesY = new float[qtdLuzes];

//angulo de rotação dos dois holofotes
float angulo = 0;
float velocidade = 0.5;

//nuvens
float nuvem1X = 1000, nuvem2X = 600;

//Estrelas cadentes
boolean estrela_cadente = false;
float mouseEstrelaX = 0.0, mouseEstrelaY = 0.0;
int estrela_contador = 0;

void setup(){
  size(1280,720);
  smooth();
  
  color color1 = color(255,140,00);
  color color2 = color(0,0,50);
  
  background(color2);
  
  //Colocando cor do céu no fundo (gradiente)
  int y;
  float n = 0;
  
  for(y=0; y<altura; y++){
    stroke(lerpColor(color2,color1,n));
    line(0,y, width, y);
    if(height-y>altura) line(0,height-y, width, height-y);
    n+=0.0006;
  }
  
  // Silhueta - prédios
  fill(5);
  stroke(5);
  
  int i = 0;
  int j = 0;
  int largura_janela = 1;
  int distancia_janela = 6;
  int k = 0;
  int tamanho = 40;
  int largura = 50;
  int intervalo = 0;
  int sorteio = 0;
  int antena = 0;
  
  //cria estruturas, estátuas, e torres antes dos prédios
  img_estrutura = loadImage("estrutura.png");
  img_torre = loadImage("torre.png");
  
  image(img_estrutura,900,270,90,130);
  image(img_torre,500,270,60,130);
  
  while(k<1280){
    fill(5);
    stroke(5);
  
    rect(k,altura-tamanho,largura,tamanho);
    
    fill(255,200,0);
    stroke(255,200,0);
          
    //adiocionar as janelas
    for(i = (altura - tamanho) + 8; i < altura; i += (largura_janela + distancia_janela)){ 
      for(j = k + 5; j < k + largura - 5; j+= (largura_janela + distancia_janela)){
        //criar o retângulo para a janela
          rect(j,i,largura_janela,largura_janela,3);
      }
    }
    
    //sorteio para inserir uma antena no prédio
    fill(5);
    stroke(5);
  
    sorteio = round(random(0,3));
    antena = round(random(15,35));
    if(sorteio == 3){
      rect(k+(largura/2),(altura-tamanho)-antena,1,antena);
    }
    
    
    
    //inicialização do vetor das luzes
    for(int w = 0; w < qtdLuzes; w++) luzesY[w] = random(0,1080);
    
    //incrementos
    tamanho = round(random(30,100));
    largura = round(random(15,30));
    intervalo = round(random(0,1));
    k = k + largura + intervalo;
  }
  
  
  //estrelas
  int contador_estrelas=0;
  
  while(contador_estrelas <= qtd_estrelas){
    fill(255);
    stroke(255,0.6);
    circle(random(0,width),random(0,altura-150),random(1,2));
    contador_estrelas ++;
  }
  
  //Salvar a imagem gerada para ser carregada como fundo
  saveFrame("fundo.png");

  //load nas imagens
  img_nuvem = loadImage("nuvem.png");
  img_bg = loadImage("fundo.png");
  img_luz = loadImage("luz.png");
  img_luz2 = loadImage("luz.png");
  img_arvores = loadImage("arvores.png");
  
  imageMode(CENTER);
  
  
}
  
void draw(){
  clear();
  
  //carregando o fundo
  background(img_bg);
  
  //Lua
  fill(255,20);
  circle(luaX,luaY,90);
  
  fill(255,20);
  circle(luaX,luaY,70);

  fill(250);
  circle(luaX,luaY,50);
  fill(225);
  circle(luaX+12,luaY,13);
  circle(luaX-8,luaY+6,18);
  circle(luaX-2,luaY-15,10);
  
  
  //luzes e objetos na cidade
  for(int j = 0; j < qtdLuzes; j++){
      //luz 1 -> vermelha
      fill(180,0,0,60);
      circle(luzesY[j],altura,50);
      circle(luzesY[j],altura,20);
      fill(255,0,0);
      circle(luzesY[j],altura,5); 
     
      //luz 2 -> amarela
      fill(255,200,0,60);
      circle(luzesY[j]+200,altura,50);
      circle(luzesY[j]+200,altura,20);
      fill(255,200,0);
      circle(luzesY[j]+200,altura,5); 
      
      //luz 3 -> azul
      fill(0,0,180,60);
      circle(luzesY[j]-200,altura,50);
      circle(luzesY[j]-200,altura,20);
      fill(0,0,255);
      circle(luzesY[j]-200,altura,5);
      
      //luz 1 -> vermelha
      fill(180,0,0,60);
      circle((-1)*luzesY[j]+200,altura,50);
      circle((-1)*luzesY[j]+200,altura,20);
      fill(255,0,0);
      circle((-1)*luzesY[j]+200,altura,5); 
     
      //luz 2 -> amarela
      fill(255,200,0,60);
      circle((-1)*luzesY[j]+800,altura,50);
      circle((-1)*luzesY[j]+800,altura,20);
      fill(255,200,0);
      circle((-1)*luzesY[j]+800,altura,5); 
      
      //luz 3 -> azul
      fill(0,0,180,60);
      circle((-1)*luzesY[j]+1000,altura,50);
      circle((-1)*luzesY[j]+1000,altura,20);
      fill(0,0,255);
      circle((-1)*luzesY[j]+1000,altura,5);
      
      if(luzesY[j] < 1080) luzesY[j]++;
      else luzesY[j] = 0;
  }
  
  //Nuvens
  image(img_nuvem,nuvem1X,200,200,140);
  image(img_nuvem,nuvem2X,200,220,160);
  
  nuvem1X = nuvem1X + 0.3;
  nuvem2X = nuvem2X + 0.2;
  
  if(nuvem1X > width+100) nuvem1X = -100;
  if(nuvem2X > width+100) nuvem2X = -100;
  
  //duas luzes que rotacionam  
  pushMatrix();
  pushMatrix();

  translate(250,340);
  rotate(radians(angulo));
  image(img_luz,0,-60,30,100);
  if(angulo > 45) velocidade = -0.5;
  if(angulo < -45) velocidade = 0.5;
  popMatrix();
  
  translate(300,340);
  rotate(radians(-angulo));
  image(img_luz2,0,-60,30,100);
  angulo += velocidade;
  popMatrix();
  
  //retângulo
  fill(5);
  rect(0,altura,width,50);
  
  //Estrelas cadentes
  if(estrela_cadente == true){
    if(estrela_contador < 20){
      fill(255,120);
      circle(mouseEstrelaX,mouseEstrelaY,2);
      circle(mouseEstrelaX+3,mouseEstrelaY+1,2);
      circle(mouseEstrelaX+9,mouseEstrelaY+3,3);
      circle(mouseEstrelaX+15,mouseEstrelaY+5,4);
      circle(mouseEstrelaX+24,mouseEstrelaY+8,4);
      circle(mouseEstrelaX+27,mouseEstrelaY+9,5);
      circle(mouseEstrelaX+30,mouseEstrelaY+10,8);
      fill(255,200);
      circle(mouseEstrelaX+30,mouseEstrelaY+10,3);
      estrela_contador++;
      mouseEstrelaX+= 12;
      mouseEstrelaY+= 4;
    }
    else{
      estrela_cadente = false;
    }
  } 
  
  //em primeiro plano, as árvores
  image(img_arvores,-300,450,1200,600);
  image(img_arvores,1720,450,1200,600);
  
  //teclado
  if(keyPressed){
    if(key == 'w') luaY -= 1;
    if(key == 's') luaY += 1;
    if(key == 'a') luaX -= 1;
    if(key == 'd') luaX += 1;
  }
}

//Se o usuário clicar, vê se não existe uma estrela cadente na tela,
// para criar uma.
void mouseClicked(){
  if(estrela_cadente == false && mouseY < altura-200){
    estrela_cadente = true;
    mouseEstrelaX = mouseX;
    mouseEstrelaY = mouseY;
    estrela_contador = 0;
  }
}
