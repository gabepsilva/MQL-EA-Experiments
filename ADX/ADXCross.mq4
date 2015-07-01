//+------------------------------------------------------------------+
//|                                                    ADX CROSS.mq4 |
//|                                                          Gabriel |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Gabriel"
#property link      ""

//--- input parameters
extern double    LOTS=0.01;
extern int       ADXPERIOD=13;
extern int       SL=200;


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
      // VARIAVEIS
   double PDICandle1 = iADX(Symbol(), 0, ADXPERIOD, PRICE_CLOSE, MODE_PLUSDI, 1);
   double PDICandle0 = iADX(Symbol(), 0, ADXPERIOD, PRICE_CLOSE, MODE_PLUSDI, 0);
   double NDICandle1 = iADX(Symbol(), 0, ADXPERIOD, PRICE_CLOSE, MODE_MINUSDI, 1);
   double NDICandle0 = iADX(Symbol(), 0, ADXPERIOD, PRICE_CLOSE, MODE_MINUSDI, 0);
  
  
      // SE TIVER UMA OU NENHUMA ORDEM ABERTA (para abrir só uma ordem de cada vez) E, POSITIVE DI (PDICandle1) DE CANDLE 1 FOR MENOR QUE NEGATIVE DI DE CANDLE 1 E OUVER CRUZAMENTO EM CANDLE 0, ENTRA COMPRANDO.
   if(OrdersTotal() <= 1 && PDICandle1 < NDICandle1 && PDICandle0 > NDICandle0)
   //Aqui deveria ter um comando para FECHAR todas as ordens abertas quando isso acontecer. Ou seja, ele pode estar vendido
   //e quando bater chegar a hora de comprar, ele deve fechar a posisao vendida e entrar comprado, saca?
   OrderSend(Symbol(), OP_BUY, LOTS, Ask, 0, 0, 0, "Robo do caio arregaçando", 222, 0, DarkGreen);
  
      // SE TIVER UMA OU NENHUMA ORDEM ABERTA E, NEGATIVE DI DE CANDLE 1 FOR MENOR QUE POSITIVE DI EM CANDLE 1 E OUVER CRUZAMENTO NA ABERTURA DE CANDLE 0, ENTRAR VENDIDO.
  
   if(OrdersTotal() <= 1 && NDICandle1 < PDICandle1 && NDICandle0 > PDICandle0)
   //Aqui deveria ter um comando para FECHAR todas as ordens abertas quando isso acontecer. Ou seja, ele pode estar comprado
   //e quando bater chegar a hora de vender, ele deve fechar a posisao comprada e entrar vendido, saca?
   OrderSend(Symbol(), OP_SELL, LOTS, Bid, 0, 0, 0, "Robo do caio arregaçando", 222, 0, Red);

  
//----
   return(0);
  }
//+------------------------------------------------------------------+
