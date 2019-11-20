/*Universidade Federal de Goiás
 *Tópicos 2 - Programação Criativa
 *Trabalho 2 - O mar das emoções
 */

JSONObject json;

int numWaves = 4;
float k = 120.0;
float velocidade = 0.00025;
float altura = 0.5;
float humor = 0.5;
float sadness = 0.5;
float hapiness = 0.5;
float transpTexto = 0.2;
int state;
float valorTexto = 0.005;
String palavra = "palavra";
String sentiment = "sentiment";
String newPalavra = "palavra";
int count = 0;
float r = humor;
float g = humor;
float b = humor;

void setup(){
  size(720,480);
  noStroke();
  
  ExplorarJSON();
}

void draw(){
  json = loadJSONObject("../log.json");
  newPalavra = json.getString("last_msg");
  if(!newPalavra.equals(palavra)){ 
    ExplorarJSON();
  }
  
    background(255);
    if(sentiment.equals("neg") && k < height-50){ 
      humor = 0.25*humor + 0.75*(1 - sadness);
      k += 0.2;  
    }
    else if(sentiment.equals("pos") && k > 100){
      humor = 0.25*humor + 0.75*hapiness;
      k -= 0.2;
    }
   for(int i = 0 ; i < numWaves; i++){
     fill(humor*60,humor*240,humor*360,map(i,0,numWaves-1,192,32));
     drawSineWave(HALF_PI,velocidade * (i+1),50 + (10 * i), 8, width, k);
   }
}

void drawSineWave(float radians,float speed,float amplitude,int detail,float size,float y){
  //Para desenhar a onda, utiliza-se um shape
  beginShape();
  
  //Fixar a base da onda no 'chão'
  vertex(0,height);
  
  float xoffset = size / detail;
  float angleIncrement = radians / detail;
  
  // para cada ponto, desenhar seguindo a função seno
  for(int i = 0 ; i <= detail; i++){
    float px = xoffset * i;
    float py = y + (sin((millis() * speed) + angleIncrement * i) * amplitude);
    vertex(px,py);
  }
  vertex(size,height);
  endShape();
}

void SetJSON(){
  palavra = newPalavra;
}

void ExplorarJSON(){
  //Carregando o arquivo jason e extraindo informações
  json = loadJSONObject("../log.json");
  sadness = json.getFloat("sadness_degree");
  println("Leu sadness: ", sadness);
  hapiness = json.getFloat("happiness_degree");
  println("Leu hapiness", hapiness);
  palavra = json.getString("last_msg");
  sentiment = json.getString("last_sentiment");
  int s = json.getInt("state");
  state = s;
  println("Valor de k", k);
  println("humor ", humor);
  
}
