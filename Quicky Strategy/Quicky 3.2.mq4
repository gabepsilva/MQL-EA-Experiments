//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
extern int MagicNumber=10001;
extern double Lots=0.02;
extern int MaxOrders=3;
extern double StopLoss=5000;
extern double TakeProfit=3;
extern int TrailingStop=0;
extern int MinDifToNewOrder=5;
extern int Slippage=3;
extern string EAComment="Robo";


double MyPoint = 0;
//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
  {
//define point value
   MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;
      
      
      
//define  sl to this order (if oppened )
   double TheStopLoss=0;
//define tp to this order (if oppened )
   double TheTakeProfit=0;
//output fot OrderSend function
   int result=0;

//if RSI(14) < 30 AND the close price of last candle is < than the open price of the current candle
   if((iRSI(NULL,0,14,PRICE_CLOSE,1)<30) && (Close[1]<Open[1])) // Here is your open buy rule
   //check if this order was oppend in a given datetime
      if(CheckOrder(OP_BUY,Time[0])==false)
         if(CheckOrderInHist(OP_BUY,Time[0])==false)
            if(CheckMinDifToNewOrder(OP_BUY)==true)
               if(OrdTotal()<MaxOrders)
                 {
                  result=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,EAComment,MagicNumber,0,Blue);
                  if(result>0)
                    {
                     TheStopLoss=0;
                     TheTakeProfit=0;
                     if(TakeProfit>0) TheTakeProfit=Ask+TakeProfit*MyPoint;
                     if(StopLoss>0) TheStopLoss=Ask-StopLoss*MyPoint;
                     OrderSelect(result,SELECT_BY_TICKET);
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
                    }
                  return(0);
                 }
   if((iRSI(NULL,0,14,PRICE_CLOSE,1)>70) && (Close[1]>Open[1])) // Here is your open Sell rule
      if(CheckOrder(OP_SELL,Time[0])==false)
         if(CheckOrderInHist(OP_SELL,Time[0])==false)
            if(CheckMinDifToNewOrder(OP_SELL)==true)
               if(OrdTotal()<MaxOrders)
                 {
                  result=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,EAComment,MagicNumber,0,Red);
                  if(result>0)
                    {
                     TheStopLoss=0;
                     TheTakeProfit=0;
                     if(TakeProfit>0) TheTakeProfit=Bid-TakeProfit*MyPoint;
                     if(StopLoss>0) TheStopLoss=Bid+StopLoss*MyPoint;
                     OrderSelect(result,SELECT_BY_TICKET);
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
                    }
                  return(0);
                 }

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
                     return(0);
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
                     return(0);
                    }
                 }
              }
           }
        }
     }
   return(0);
  }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//check if this order was oppend in a given datetime
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bool CheckOrder(int OrdType,datetime InTime)
  {
   bool isOpened=false;
   int Total=OrdersTotal();
   if(Total>0)
     {
      //for each order
      for(int Ord=Total-1; Ord>=0; Ord--)
        {
         //select order
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_TRADES)==true)
            //check if order is in the same pair of chart
            if(OrderSymbol()==Symbol())
               //check if order belongs to this robot by Magic number
               if(OrderMagicNumber()==MagicNumber)
                  //check if the order is in the same way of param
                  if((OrdType==0 && OrderType()==0) || (OrdType==1 && OrderType()==1))
                     //check if this order was oppend in a given datetime
                     if(iBarShift(NULL,0,InTime)==iBarShift(NULL,0,OrderOpenTime()))
                       {
                        isOpened=true;
                        break;
                       }

        }//for
     }//if(totalOrd>0) 
   return(isOpened);
  }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bool CheckOrderInHist(int OrdType,datetime InTime)
  {
   bool isOpened = false;
   int TotalHist = OrdersHistoryTotal();
   if(TotalHist>0)
     {
      for(int Ord=TotalHist-1; Ord>=0; Ord--)
        {
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==MagicNumber)
                  if((OrdType==0 && OrderType()==0) || (OrdType==1 && OrderType()==1))
                     if(iBarShift(NULL,0,InTime)==iBarShift(NULL,0,OrderOpenTime()))
                       {
                        isOpened=true;
                       }

        }//for
     }//if(totalOrd>0) 
   return(isOpened);
  } //bool CheckOrderInHist
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
int OrdTotal()
  {
   int total=OrdersTotal();
   if(total>0)
     {
      int OrdTot=0;
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

   int TotalHist=OrdersHistoryTotal();
   if(TotalHist>0)
     {
      for(int Ord=TotalHist-1; Ord>=0; Ord--)
        {
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==MagicNumber)
                  if((OrderType()==0) || (OrderType()==1))
                     if((TimeDayOfYear(OrderOpenTime())==TimeDayOfYear(TimeCurrent())) && (TimeYear(OrderOpenTime())==TimeYear(TimeCurrent())))
                       {
                        OrdTot=OrdTot+1;
                       }

        }//for
     }//if(totalOrd>0) 
   return(OrdTot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckMinDifToNewOrder(int OrdType)
  {
//---

datetime mostRecentDateT = 0;
int      mostRecentIndex = 0;

double diff = 0;


bool ret=false;

   int Ord = 0;
   int Total=OrdersTotal();
   if(Total>0)
     {
      for(Ord=Total-1; Ord>=0; Ord--)
        {
         if(OrderSelect(Ord,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==MagicNumber)
                  if((OrdType==OP_BUY && OrderType()==OP_BUY) || (OrdType==OP_SELL && OrderType()==OP_SELL))
                     if(mostRecentDateT < OrderOpenTime())
                     {
                        mostRecentDateT = OrderOpenTime();
                        mostRecentIndex = Ord;
                     }


        }//for
        
        //get the most recent order in thi pair
        if(OrderSelect(mostRecentIndex,SELECT_BY_POS,MODE_TRADES)==true)
        {
            if(OrderType()==OP_BUY)
              {
               diff = MathAbs(NormalizeDouble(OrderOpenPrice()-Ask,Digits)/Point);
               if(diff >= MinDifToNewOrder)
                 {
                  return(true);
                 }
              }
              if(OrderType()==OP_SELL)
              {
               diff = MathAbs(NormalizeDouble(OrderOpenPrice()-Bid,Digits)/Point);
               if(diff >= MinDifToNewOrder)
                 {
                  return(true);
                 }
              }
        
        
        
        }
        
        

     }//if(totalOrd>0)


   
//---
   return(false);
  }

//+------------------------------------------------------------------+
