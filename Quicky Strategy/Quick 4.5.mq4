

#property copyright "GABRIEL"
#property description "$1,000,000.00"

//Constante para facilitar o a validacao das regras para abrir trade.
//a cada nova regra esse numero deve ser incrementado
#define RULES_COUNT 10

extern string EAComment="Quicky 4.5"; //Comentarios que o robo deixa nas trades
extern int MaxOrdersDay=3;            //Numero maximo de ordens abertas por par por dia
extern int MaxOrdersGlobal=30;        //Numero maximo de ordens totais abertas
extern double DrawdownPercent=30;     //Impede que novas ordens sejam abertas quando DD atingir este valor
extern int LimitZone=15;              //Impede que ordens nesta proximidade de pontos (nao pips) seja abertas
extern double AmountToIncreaseLot=200;//Incrementa o lot sempre que o balanco da conta aumentar neste valor 
extern bool FloatingTP = true;        //O TP e ajustado descontando o spread do par
extern double MaxTakeProfit=5;        //TP de cada ordem aberta
extern double StopLoss=0;             //Stop de cada ordem
extern bool AutoStartPairList = false;// auto abarir janelas dos pares de acordo com a corretora

//Definicao dos brokers. Os comentarios dentro da enum e o que aparece na janela do metatrader
enum Broker
  {
   ICMarkets_all=0,     // ICMarkets ALL pairs
   MT4_Default_all=1    // MT4_Default ALL pairs
  };
 
extern Broker broker =ICMarkets_all; //Inicializacao da variavel dos brokers

//extern int TrailingStop=0; //trailing code disabled


int MagicNumber=10001;
int Slippage=30;
double MyPoint=0;

string txt="";
int    txtSize=10;

double rsi=0;

//int inttmp = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
  
     if(AutoStartPairList)
      {
      
         string pairs[1] = {""};
         int arr_count = 0;
         
         
         if(broker == ICMarkets_all)
            {
                string a[83] = {"EURUSD", "AUDUSD", "GBPUSD", "USDCAD", "USDCHF", "USDJPY", "AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDSGD", "CADCHF", "CADJPY", "CHFJPY", "CHFSGD", "EURAUD", "EURCAD", "EURCHF", "EURDKK", "EURHKD", "EURGBP", "EURJPY", "EURNOK", "EURNZD", "EURPLN", "EURSEK", "EURSGD", "EURTRY", "EURZAR", "GBPAUD", "GBPCAD", "GBPCHF", "GBPDKK", "GBPJPY", "GBPNOK", "GBPNZD", "GBPSEK", "GBPSGD", "NOKJPY", "NOKSEK", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "SEKJPY", "SGDJPY", "USDCNH", "USDCZK", "USDDKK", "USDHKD", "USDHUF", "USDMXN", "USDNOK", "USDPLN", "USDRUB", "USDSEK", "USDSGD", "USDTRY", "USDZAR", "XAGEUR", "XAGUSD", "XAUEUR", "XAUUSD", "AUS200", "DE30", "ES35", "F40", "HK50", "IT40", "JP225", "STOXX50", "UK100", "US2000", "US30", "US500", "USTEC", "BRENT", "WTI", ".GOLD", ".SILVER", "DXY", "VIX", "NatGas"};
                arr_count =  83;
                ArrayCopy(pairs,a,0,0,WHOLE_ARRAY);
                
           }
         if(broker == MT4_Default_all)
           {
                string b[114] = {"EURUSD" ,"USDCHF" ,"GBPUSD" ,"USDJPY" ,"AUDUSD" ,"USDCAD" ,"EURCHF" ,"EURGBP" ,"EURJPY" ,"EURCAD" ,"EURAUD" ,"GBPCHF" ,"GBPJPY" ,"CHFJPY" ,"CADCHF" ,"GBPCAD" ,"AUDJPY" ,"AUDSGD" ,"CADJPY" ,"CADSGD" ,"CHFSGD" ,"EURHKD" ,"EURSGD" ,"GBPSGD" ,"HKDJPY" ,"MXNJPY" ,"NOKJPY" ,"NZDJPY" ,"NZDSGD" ,"SEKJPY" ,"SGDJPY" ,"EURDKK" ,"EURNOK" ,"EURSEK" ,"GBPNOK" ,"GBPSEK" ,"NOKSEK" ,"USDDKK" ,"USDNOK" ,"USDSEK" ,"AUDCAD" ,"AUDCHF" ,"AUDNZD" ,"EURNZD" ,"GBPAUD" ,"GBPNZD" ,"NZDCAD" ,"NZDCHF" ,"NZDUSD" ,"EURTRY" ,"USDTRY" ,"EURMXN" ,"USDMXN" ,"EURPLN" ,"USDPLN" ,"USDRUB" ,"USDCNH" ,"USDHKD" ,"USDSGD" ,"XAUUSD" ,"XAGUSD" ,"_B" ,"_G" ,"_EUA" ,"EUA.Z4" ,"_CL" ,"_DE30" ,"_EUR50" ,"_FRA40" ,"_UK100" ,"_US500" ,"_NQ100" ,"_US30" ,"_GC" ,"_SI" ,"_HG" ,"_SB" ,"_ZC" ,"_ZS" ,"DE30.U" ,"EUR50.U" ,"EURZAR" ,"FRA40.U" ,"NQ100.U" ,"UK100.U" ,"US30.U" ,"US500.U" ,"USDZAR" ,"ZARJPY" ,"AUDZAR" ,"CHFDKK" ,"CHFHKD" ,"CHFNOK" ,"CHFSEK" ,"DKKJPY" ,"GBPDKK" ,"GBPHKD" ,"GBPZAR" ,"GLDUSD" ,"NZDZAR" ,"USDCZK" ,"SB.V4" ,"GC.Z4" ,"ZS.X4" ,"B.V4" ,"G.U4" ,"ZC.Z4" ,"SI.Z4" ,"HG.V4" ,"CL.V4" ,"HG.Z4" ,"B.X4" ,"G.V4"};
                arr_count =  114;
                ArrayCopy(pairs,b,0,0,WHOLE_ARRAY);
           }
           
         for(int i = 0; i < arr_count; i++)
         {          
            ChartOpen(pairs[i], PERIOD_M15);
         }
      }

   /////////////////////////////////////////////////////////////
      
   int increase=15;

   int y=15;
   ObjectCreate("Label_RSI",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_RSI",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_RSI",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_RSI", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_Candle",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_Candle",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_Candle",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_Candle", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_OrderTakenInThisCandle",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_OrderTakenInThisCandle",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_OrderTakenInThisCandle",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_OrderTakenInThisCandle", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_OrderClosedInThisCandle",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_OrderClosedInThisCandle",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_OrderClosedInThisCandle",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_OrderClosedInThisCandle", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_MinToNewOrder",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_MinToNewOrder",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_MinToNewOrder",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_MinToNewOrder", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_TradeCount",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_TradeCount",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_TradeCount",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_TradeCount", OBJPROP_YDISTANCE, y);// Y coordinate
   
   y+=increase;
   ObjectCreate("Label_dd",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_dd",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_dd",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_dd", OBJPROP_YDISTANCE, y);// Y coordinate
   
   y+=increase;
   ObjectCreate("Label_tp",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_tp",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_tp",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_tp", OBJPROP_YDISTANCE, y);// Y coordinate
   
   y+=increase;
   ObjectCreate("Label_lot",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_lot",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_lot",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_lot", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase*2;
   ObjectCreate("Label_spread",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_spread",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_spread",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_spread", OBJPROP_YDISTANCE, y);// Y coordinate

   y+=increase;
   ObjectCreate("Label_close",OBJ_LABEL,0,0,0);// Creating obj.
   ObjectSet("Label_close",OBJPROP_CORNER,CORNER_LEFT_UPPER);    // Reference corner
   ObjectSet("Label_close",OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_close", OBJPROP_YDISTANCE, y);// Y coordinate
   
   





  }
//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
  {
//define point value
   MyPoint=Point();
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   bool rules[RULES_COUNT];

   rules[0]=true;
   rules[1]=(isRsiInRangeTo(OP_BUY));
   rules[2] = (candle1Color()=="Red");
   rules[3] = ( AnyOrderTakenInThisCandle(OP_BUY,Time[0])==false );
   rules[4] = ( AnyOrderClosedInThisCandle(OP_BUY,Time[0])==false );
   rules[5] = ( CheckMinDifToNewOrder(OP_BUY)==true);
   rules[6] = ( OrdTotalDay() );
   rules[7] = (  ddCheck() );
   rules[8] = (  CheckFloatingTP() );
   rules[9] = (  CalcLots() );

   for(int i=1; i<RULES_COUNT; i++)
      if(!rules[i])
         rules[0]=false;

   if(rules[0])
     {

      int result=OrderSend(Symbol(),OP_BUY,CalcLots(),Ask,Slippage,0,0,EAComment,MagicNumber,0,Blue);
      if(result>0)
        {
         persistOrdModify(result);
         return(0);
        }

     }

//    if(rules[1])
//       return;
   rules[0]=true;
   rules[1]=(isRsiInRangeTo(OP_SELL));
   rules[2] = (candle1Color()=="Green");
   rules[3] = ( AnyOrderTakenInThisCandle(OP_SELL,Time[0])==false );
   rules[4] = ( AnyOrderClosedInThisCandle(OP_SELL,Time[0])==false );
   rules[5] = ( CheckMinDifToNewOrder(OP_SELL)==true);
   rules[6] = ( OrdTotalDay() );
   rules[7] = (  ddCheck() );
   rules[8] = (  CheckFloatingTP() );
   rules[9] = (  CalcLots() );

   for(i=1; i<RULES_COUNT; i++)
      if(!rules[i])
         rules[0]=false;

   if(rules[0])
     {

      result=OrderSend(Symbol(),OP_SELL,CalcLots(),Bid,Slippage,0,0,EAComment,MagicNumber,0,Red);
      if(result>0)
        {
         persistOrdModify(result);
         return(0);
        }

     }

  //PerformTrailing();
  //swapAjust();
  displayData();
   

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void persistOrdModify(int OrdNo)
  {

//define  sl to this order (if oppened )
   double TheStopLoss=0;
//define tp to this order (if oppened )
   double TheTakeProfit=0;



   for(int i=0; i<10; i++)
     {

      if(OrderSelect(OrdNo,SELECT_BY_TICKET))
        {

         TheStopLoss=0;
         TheTakeProfit=0;

         if(OrderType()==OP_BUY)
           {
            if(MaxTakeProfit>0 && !FloatingTP)
            {
               TheTakeProfit=Ask+MaxTakeProfit*MyPoint;
            }
            else
            {
            
                TheTakeProfit=Ask+(MaxTakeProfit-GetSpreadInPips())*MyPoint;
            }
               
            if(StopLoss>0) TheStopLoss=Ask-StopLoss*MyPoint;
           }
         if(OrderType()==OP_SELL)
           {

            if(MaxTakeProfit> 0 && !FloatingTP)
            {
               TheTakeProfit=Bid-MaxTakeProfit*MyPoint;
            }
            else
            {
                TheTakeProfit=Bid-(MaxTakeProfit-GetSpreadInPips())*MyPoint;
            }
            if(StopLoss>0) TheStopLoss=Bid+StopLoss*MyPoint;

           }

         if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green))
            break;
        }

      Sleep(100);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
void PerformTrailing()
  {

   for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL && 
         OrderSymbol()==Symbol() && 
         OrderMagicNumber()==MagicNumber
         )
        {
         if(OrderType()==OP_BUY)
           {
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>MyPoint*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-MyPoint*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                     return;
                    }
                 }
              }
           }
         else
           {
            if(TrailingStop>0)
              {
               if((OrderOpenPrice()-Ask)>(MyPoint*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+MyPoint*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     return;
                    }
                 }
              }
           }
        }
     }

  }
  */
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//check if this order was oppend in a given datetime
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bool AnyOrderTakenInThisCandle(int OrdType,datetime InTime)
  {

   int Total=OrdersTotal();
   if(Total>0)
     {
      //for each order
      for(int Ord=Total-1; Ord>=0; Ord--)
        {
         //select order
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_TRADES)==true)
           {
            //check if order is in the same pair of chart
            if(OrderSymbol()==Symbol())
              {
               //check if order belongs to this robot by Magic number
               if(OrderMagicNumber()==MagicNumber)
                 {
                  //check if the order is in the same way of param
                  if((OrdType==0 && OrderType()==0) || (OrdType==1 && OrderType()==1))
                    {
                     //check if this order was oppend in a given datetime
                     if(iBarShift(NULL,0,InTime)==iBarShift(NULL,0,OrderOpenTime()))
                       {

                        txt="any Order TAKEN in this candle ? = YES";
                        ObjectSetText("Label_OrderTakenInThisCandle",txt,txtSize,"Arial",clrYellow);

                        return(true);
                       }
                    }
                 }
              }
           }

        }//for
     }//if(totalOrd>0)

   txt="any Order TAKEN in this candle ? = NO";
   ObjectSetText("Label_OrderTakenInThisCandle",txt,txtSize,"Arial",clrLime);

   return(false);
  }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bool AnyOrderClosedInThisCandle(int OrdType,datetime InTime)
  {
   bool isOpened = false;
   int TotalHist = OrdersHistoryTotal();
   if(TotalHist>0)
     {
      for(int Ord=TotalHist-1; Ord>=0; Ord--)
        {
         //select order
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true)
            //check if order is in the same pair of chart
            if(OrderSymbol()==Symbol())
               //check if order belongs to this robot by Magic number
               if(OrderMagicNumber()==MagicNumber)
                  //check if the order is in the same way of param
                  if((OrdType==0 && OrderType()==0) || (OrdType==1 && OrderType()==1))
                     //check if this order was oppend in a given datetime
                     if(iBarShift(NULL,0,InTime)==iBarShift(NULL,0,OrderOpenTime()))
                       {

                        txt="any Order CLOSED in this candle ? = YES";
                        ObjectSetText("Label_OrderClosedInThisCandle",txt,txtSize,"Arial",clrYellow);

                        return true;
                       }

        }//for
     }//if(totalOrd>0) 

   txt="any Order CLOSED in this candle ? = NO";
   ObjectSetText("Label_OrderClosedInThisCandle",txt,txtSize,"Arial",clrLime);

   return(false);
  } //bool CheckOrderInHist
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bool OrdTotalDay()
  {

   int OrdTot=0;

   int total=OrdersTotal();
   if(total>0)
     {
      for(int i=0; i<total; i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==MagicNumber)
                  if((OrderType()==0) || (OrderType()==1))
                     if((TimeDayOfYear(OrderOpenTime())==TimeDayOfYear(TimeCurrent())) && (TimeYear(OrderOpenTime())==TimeYear(TimeCurrent())))
                       {
                        OrdTot=OrdTot+1;
                       }
           }
        }
     }

   txt="Order Count = "+OrdTot;

   if(OrdTot<MaxOrdersDay)
     {
      ObjectSetText("Label_TradeCount",txt,txtSize,"Arial",clrLime);
      return(true);
     }
   else
      ObjectSetText("Label_TradeCount",txt,txtSize,"Arial",clrYellow);

   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckMinDifToNewOrder(int OrdType)
  {
//---

   string tmp = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";

   datetime mostRecentDateT = 0;
   int      mostRecentIndex = 999999;

   double diff=0;

   bool ret=false;

   int Ord=0;
   int Total=OrdersTotal();

   if(Total>0)
     {
      for(Ord=Total-1; Ord>=0; Ord--)
        {
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderSymbol()==Symbol())
              {
              // if(OrderMagicNumber()==MagicNumber)
                 {
                  if((OrdType==OP_BUY && OrderType()==OP_BUY) || (OrdType==OP_SELL && OrderType()==OP_SELL))
                    {
                        if(mostRecentDateT < OrderOpenTime())
                          {
                           mostRecentDateT = OrderOpenTime();
                           mostRecentIndex = Ord;
                          // Comment ("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nOrdSelectec: " + mostRecentIndex + " | " + TimeToStr(mostRecentDateT,TIME_DATE|TIME_SECONDS) + " - " + inttmp++ + " \n - " );
                           
                           
                          }
                      }
                 }
              }
           }

        }//for
        
       /* if( mostRecentIndex == 999999)
        {
        
         txt="Diff: Could not select order in "+Symbol();
         ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrLime);
         return(true);
        
        }
        
        */

      //get the most recent order in thi pair
      if(OrderSelect(mostRecentIndex,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY)
           {
            diff=MathAbs(NormalizeDouble(OrderOpenPrice()-Open[0],Digits)/Point);
            txt="Limit Zone (ord: " + OrderTicket() + " ) = " + diff;
            
            
            if(diff>=LimitZone)
              {
               ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrLime);
               return(true);
              }
            else
              {

               ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrYellow);
               return(false);

              }

           }
         if(OrderType()==OP_SELL)
           {
            diff=MathAbs(NormalizeDouble(OrderOpenPrice()-Open[0],Digits)/Point);
           
            txt="Limit Zone (ord: " + OrderTicket() + " ) = " + diff;
            if(diff>=LimitZone)
              {
               ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrLime);
               return(true);
              }
            else
              {

               ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrYellow);
               return(false);

              }
           }

        }
      else
        {
         txt="Limit Zone = No Order in "+Symbol();
         ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrLime);
         return(true);
        }

     }//if(totalOrd>0)
   else
     {

      txt="Limit Zone = No Order in "+Symbol();
      ObjectSetText("Label_MinToNewOrder",txt,txtSize,"Arial",clrLime);
      return(true);

     }
     
     

//---
   return(false);
  }
//+------------------------------------------------------------------+

bool isRsiInRangeTo(int OrdType)
  {

   rsi=iRSI(NULL,0,14,PRICE_CLOSE,1);

   if((rsi<30 && OrdType==OP_BUY) || (rsi>70 && OrdType==OP_SELL))
     {
      txt="RSI(14) = "+NormalizeDouble(rsi,2);
      ObjectSetText("Label_RSI",txt,txtSize,"Arial",clrLime);
      return(true);

     }
   else
     {
      txt="RSI(14) = "+NormalizeDouble(rsi,2);
      ObjectSetText("Label_RSI",txt,txtSize,"Arial",clrYellow);

     }

   return(false);

  }
//+------------------------------------------------------------------+

string candle1Color()
  {

   if(Close[1]<Open[1])
     {

      txt="Candle -1 = Red";
      if(rsi<30)
         ObjectSetText("Label_Candle",txt,txtSize,"Arial",clrLime);
      else
         ObjectSetText("Label_Candle",txt,txtSize,"Arial",clrYellow);

      return( "Red" );
     }
   else if(Close[1]>Open[1])
     {
      txt="Candle -1 = Green";

      if(rsi>70)
         ObjectSetText("Label_Candle",txt,txtSize,"Arial",clrLime);
      else
         ObjectSetText("Label_Candle",txt,txtSize,"Arial",clrYellow);

      return( "Green" );
     }
   else
     {
      txt="Candle -1 = Not valid";
      ObjectSetText("Label_Candle",txt,txtSize,"Arial",clrYellow);

      return( "Not Valid" );
     }

   return("none");

  }
//+------------------------------------------------------------------+

void displayData()
  {

   int ttc,d,h,m,s,rest;

   ttc=Time[0]+Period()*60-TimeCurrent();

   rest=ttc%86400;
   d=(ttc-rest)/86400;
   ttc=rest;
   rest=ttc%3600;
   h=(ttc-rest)/3600;
   ttc=rest;
   rest=ttc%60;
   m=(ttc-rest)/60;
   s=rest;


   if(d>0) txt=("Close in "+d+"d "+h+"h "+m+"m "+s+"s");
   else if(h>0) txt = ( "Close candle in " + h + "h " + m + "m " + s + "s" );
   else if(m>0) txt = ( "Close candle in " + m + "m " + s + "s" );
   else         txt = ( "Close candle in " + s + "s" );

   ObjectSetText("Label_close",txt,txtSize,"Arial",clrWhite);
   
   ObjectSetText("Label_spread","Spread: " + GetSpreadInPips() + " PIPS",txtSize,"Arial",clrWhite);



  }
//+------------------------------------------------------------------+

double GetSpreadInPips()
{

   if(MarketInfo("EURUSD",MODE_DIGITS)==5)
    { 
      return 0.1*MarketInfo(Symbol(),MODE_SPREAD); 
    }
   else 
   { 
      return MarketInfo(Symbol(),MODE_SPREAD); 
   }

}

bool ddCheck()
{

   float dd = (1-AccountEquity()/AccountBalance())*100;
   
   if( dd < NormalizeDouble(DrawdownPercent,2)){
 //  if( dd < DrawdownPercent)){
      
      txt="DD( max " + DrawdownPercent + "% ) = " + NormalizeDouble(dd,2) + "%";
      ObjectSetText("Label_dd",txt,txtSize,"Arial",clrLime);
      return (true); 
      
   }
   else
   {
       txt="DD( max " + DrawdownPercent + "% ) = " + NormalizeDouble(dd,2) + "%";
      ObjectSetText("Label_dd",txt,txtSize,"Arial",clrYellow);
   }
  
   return(false);
}

bool CheckFloatingTP()
{

   double profit = MaxTakeProfit - GetSpreadInPips();

   if(FloatingTP)
   {
      if(profit <= 0.5)
      {
         txt = "Spread is too high";
         ObjectSetText("Label_tp",txt,txtSize,"Arial",clrYellow);
         return false;
      }
      else
      {
         txt = "Take profit at: " + profit + " PIPS";
         ObjectSetText("Label_tp",txt,txtSize,"Arial",clrLime);
         return true;
      }
   }

   txt = "Take profit at: " + MaxTakeProfit + " PIPS";
   ObjectSetText("Label_tp",txt,txtSize,"Arial",clrLime);
   return true;

}

double CalcLots()
{

   double lot = MathFloor(AccountBalance() / AmountToIncreaseLot);
   lot = lot / 100;
   
   if( lot >= 0.01 )
   {
     // lot = NormalizeDouble(AccountBalance() / AmountToIncreaseLot, 0) / 100;
      txt = "Using Lot: " + lot;
      ObjectSetText("Label_lot",txt,txtSize,"Arial",clrLime);
      return lot;
   }
   
    txt = "ERROR on calculating lot: " + lot;
    ObjectSetText("Label_lot",txt,txtSize,"Arial",clrYellow);

    return false;
}

/*
void swapAjust()
{
   int OrdTot=0;

   int total=OrdersTotal();
   if(total>0)
     {
      for(int i=0; i<total; i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol()==Symbol())
                  if((OrderType()==0) || (OrderType()==1))
                       {
                        
                          txt="Swap gain: $" + OrderSwap() + " | " + NormalizeDouble((OrderSwap()/MarketInfo(Symbol(),MODE_TICKVALUE)),2)  + " pips\n\n lala";
                        
                         ObjectSetText("Label_swap_stats",txt,txtSize,"Arial",clrLime);
                         
                         if(OrderSwap() > 0)
                         {
                         
                         if(OrderType()==OP_BUY)
                             {
                              if(TakeProfit>0) TheTakeProfit=Ask+TakeProfit*MyPoint;
                              if(StopLoss>0) TheStopLoss=Ask-StopLoss*MyPoint;
                             }
                           if(OrderType()==OP_SELL)
                             {
                  
                              if(TakeProfit>0) TheTakeProfit=Bid-TakeProfit*MyPoint;
                              if(StopLoss>0) TheStopLoss=Bid+StopLoss*MyPoint;
                  
                             }
                  
                           if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green))
                              break;
                         
                           OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                           
                           
                         
                         }
                         
                         return
                        

                       }
           }
        }
     }

    ObjectSetText("Label_swap_stats","",txtSize,"Arial",clrLime);
}

*/