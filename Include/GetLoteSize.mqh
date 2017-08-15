//+------------------------------------------------------------------+
//|                                                  GetLoteSize.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ilya Saniukevich"
#property link      "https://www.mql5.com"

double GetLotSize(const string symbol,double RiskPercentage)
  {
  
  double lot_size;
   double ActBal;
   double PipVal;
   
   MqlTick latest_price;
   SymbolInfoTick(_Symbol,latest_price);

   ActBal = AccountInfoDouble(ACCOUNT_BALANCE);
   PipVal = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
 
      lot_size = (ActBal*(RiskPercentage/100000));    
      lot_size= NormalizeDouble(lot_size,2);
      Print("LotSize: ",lot_size);
      return(lot_size);
  
  }

    
    double last_deal()
  {
  double deal_price;  
  double deal_profit=0;
// --- time interval of the trade history needed
   datetime end=TimeCurrent();                 // current server time
   datetime start=end-PeriodSeconds(PERIOD_MN1);// decrease 1 
//--- request of trade history needed into the cache of MQL5 program
   HistorySelect(start,end);
//--- get total number of deals in the history
   int deals=HistoryDealsTotal();
//--- get ticket of the deal with the last index in the list
   ulong deal_ticket=HistoryDealGetTicket(deals-1);
   if(deal_ticket>0) // deal has been selected, let's proceed ot
     {
      //--- ticket of the order, opened the deal
      ulong order=HistoryDealGetInteger(deal_ticket,DEAL_ORDER);
      long order_magic=HistoryDealGetInteger(deal_ticket,DEAL_MAGIC);
      long pos_ID=HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
           deal_price=HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
           deal_profit=HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
           double deal_volume=HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
      PrintFormat("Deal: #%d opened by order: #%d with ORDER_MAGIC: %d was in position: #%d price: #%d volume:",
                  deals-1,order,order_magic,pos_ID,deal_price,deal_volume);

     }
   else              // error in selecting of the deal
     {
      PrintFormat("Total number of deals %d, error in selection of the deal"+
                  " with index %d. Error %d",deals,deals-1,GetLastError());
     }
     Print("Last profit ",deal_profit);
     if (deal_profit<0) {return 2;}else{return 0;};
     
  }
//+------------------------------------------------------------------+
