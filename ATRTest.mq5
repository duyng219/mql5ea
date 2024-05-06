#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <trade/trade.mqh>

input double Lots = 0.1;
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1;
input int AtrPeriods = 14;
input double TriggerFator = 2.5;

int handleAtr;
int barsTotal;
CTrade trade;

// func duoc goi khi start EA
int OnInit(){
   //Print("this is OnInit Function");

   handleAtr = iATR(NULL,Timeframe,AtrPeriods);
   barsTotal = iBars(NULL,Timeframe);
   
      
   return(INIT_SUCCEEDED);
 }
 
 // func duoc goi khi end EA
void OnDeinit(const int reason){
   //Print("This is OnDeinit Function..........",reason,"......");
 }
 
 // func chay lien tuc tren moi tick chart
void OnTick(){

      int bars = iBars(NULL,Timeframe);
      if(barsTotal != bars){
         barsTotal = bars;
         
         double atr[];
         CopyBuffer(handleAtr,0,1,1,atr);
           
         double open = iOpen(NULL,Timeframe,1);
         double close = iClose(NULL,Timeframe,1);
           
         if(open < close && close - open > atr[0]*TriggerFator) {
            //buy signal
            Print("buy signal");
            
            double entry = SymbolInfoDouble(NULL,SYMBOL_ASK);
            entry = NormalizeDouble(entry,_Digits);
            
            double entry1 = SymbolInfoDouble(NULL,SYMBOL_ASK);
            entry1 = NormalizeDouble(entry1,4);
            
            Print("Digits: ",entry);
            Print("Digits: ",entry1);
            
            trade.Buy(Lots);
         }else if(open > close && open - close > atr[0]*TriggerFator) {
            //sell signal
            Print("sell signal");
            trade.Sell(Lots);
         }
      }
 }