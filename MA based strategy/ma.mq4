//+------------------------------------------------------------------+
//|                                                   FX4Thought.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

double viMA20 = 0;
double viMA80 = 0;

double vEst = 0;
double vCCI = 0;

int cond1 = 0;
int cond2 = 0;
int cond3 = 0;
int cond4 = 0;
int cond5 = 0;

string comment = "";



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

cond1 = 0;
cond2 = 0;
cond3 = 0;
cond4 = 0;
cond5 = 0;

viMA20 = iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,0);
viMA80 = iMA(Symbol(),Period(),80,0,MODE_EMA,PRICE_CLOSE,0);

comment = "";
comment = comment + "FX4Thought \n";


//-------------COMPRA-------------------------------
// primeira condicao de compra  MA20 > MA80
if(viMA20 > viMA80)
{
   cond1 = 1;
   comment = comment + "C cond1 = viMA20 > viMA80 \n";
   }


//est no clande 2 <20
vEst = iStochastic(Symbol(),Period(),9,3,0,MODE_SMA,1,MODE_MAIN,2);
if(vEst < 20) // segundo condicao de compra ok
{
   cond2 = 1;
   comment = comment + "C cond2 = est candle2 < 20 \n";
}

// est candle 1 >20
vEst = iStochastic(Symbol(),Period(),9,3,0,MODE_SMA,1,MODE_MAIN,1); 
if(vEst > 20) // TERCEIRA condicao de compra ok
{
    cond3 = 1;
     comment = comment + "C cond3 = est candle1 > 20 \n";
}



//cc candle 2 <-100
vCCI = iCCI(Symbol(), Period(), 15, PRICE_CLOSE, 2);
if(vCCI < (-100))// QUARTA condicao de compra ok 
{
   cond4 = 1;
   comment = comment + "C cond3 = cci candle2 <  -100 \n";
   
}

//cci candle 1 > -100
vCCI = iCCI(Symbol(), Period(), 15, PRICE_CLOSE, 1);
if(vCCI > (-100))// QUINTA condicao de compra ok
{
    cond5 = 1;
    comment = comment + "C cond3 = cci candle1 > -100 \n";
}


//------------------VENDA----------------------------------

// primeira condicao de VENDA  MA20 < MA80
if(viMA20 < viMA80)
{
   cond1 = -1;
   comment = comment + "V cond1 = viMA20 < viMA80 \n";
}

//est no clande 2 >80
vEst = iStochastic(Symbol(),Period(),9,3,0,MODE_SMA,1,MODE_MAIN,2);
if(vEst > 80)// segundo condicao de VENDA ok
{
     cond2 = -1;
     comment = comment + "V cond2 = est candle2 > 80 \n";
}

// est candle 1 < 80
vEst = iStochastic(Symbol(),Period(),9,3,0,MODE_SMA,1,MODE_MAIN,1); 
if(vEst < 80)// TERCEIRA condicao de VENDA ok
{
   cond3 = -1;
   comment = comment + "V cond3 = est candle1 < 80 \n";
}

//cc candle 2 > 100
vCCI = iCCI(Symbol(), Period(), 15, PRICE_CLOSE, 2);
if(vCCI > 100)// QUARTA condicao de VENDA ok
{
   cond4 = -1;
   comment = comment + "V cond3 = cci candle2 > 100 \n";
}

//cci candle 1 < 100
vCCI = iCCI(Symbol(), Period(), 15, PRICE_CLOSE, 1);
if(vCCI < 100)// QUINTA condicao de VENDA ok
{
   cond5 = -1;
   comment = comment + "V cond5 = cci candle1 < 100 \n";
}
   
   
   
// analiza e executa compra e venda
   
if(cond1 + cond2 + cond3 + cond4 + cond5 == 5 && OrdersTotal() == 0)
{
    OrderSend(Symbol(), OP_BUY, 0.01, Ask, 0, Point*100, Point*100, 0, 0, 0, Blue);
    comment = comment + "COMPROU \n";

}


if(cond1 + cond2 + cond3 + cond4 + cond5 == (-5) && OrdersTotal() == 0)
{
    OrderSend(Symbol(), OP_SELL, 0.01, Bid, 0, Point*100, Point*100, 0, 0, 0, Red);
    comment = comment + "VENDEU \n";
}

comment = comment + "VENDA TP/SL =" +  Bid+Point*10000000  + "  \n";   
comment = comment + "COMPRA TP/SL =" + Ask+Point*10000000  + "  \n";   
Comment(comment);
   return(0);
  }
//+------------------------------------------------------------------+