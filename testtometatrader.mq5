//+------------------------------------------------------------------+
//|                                            testtometatrader.mq5 |
//|                                    Copyright 2025, Yousuf Mesalm. |
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Yousuf Mesalm. www.yousufmesalm.com | WhatsApp +201006179048"
#property link      "https://www.yousufmesalm.com"
#property link      "https://www.yousufmesalm.com"
#property link      "https://www.yousufmesalm.com"

#property description      "Developed by Yousuf Mesalm"
#property description      "https://www.Yousuf-mesalm.com"
#property description      "https://www.mql5.com/en/job/new?prefered=20163440"
#property description      "https://www.freelancer.com/u/usofmslam"
#property version   "1.00"
#define Copyright          "Copyright 2022, Yousuf Mesalm."
#define Link               "https://www.freelancer.com/u/usofmslam"
#define Version            "1.00"
#property indicator_chart_window
#property indicator_buffers 31
#property indicator_plots   14

#property indicator_label1  "Upper3"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrYellow
#property indicator_width1  1
#property indicator_label2  "Lower3"
#property indicator_type2  DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_width2  1
#property indicator_label3  "upper4"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGray
#property indicator_width3  1
#property indicator_label4  "lower4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrGray
#property indicator_width4  1
#property indicator_label5  "upper"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrPurple
#property indicator_width5  1
#property indicator_style5  STYLE_DASH
#property indicator_label6  "lower"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrPurple
#property indicator_width6  1
#property indicator_style6  STYLE_DASH
#property indicator_label7  "Basis"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrWhite
#property indicator_width7  1
#property indicator_label8  "EMA"
#property indicator_type8   DRAW_COLOR_LINE
#property indicator_color8  clrYellow,clrGreen,clrRed,clrBlue,clrNONE
#property indicator_width8  1
#property indicator_label9 "cross3a"
#property indicator_type9  DRAW_COLOR_ARROW
#property indicator_color9 clrYellow,clrNONE
#property indicator_width9  1
#property indicator_label10  "cross2a"
#property indicator_type10   DRAW_COLOR_ARROW
#property indicator_color10  clrPurple,clrNONE
#property indicator_width10  1
#property indicator_label11  "cross2b"
#property indicator_type11   DRAW_COLOR_ARROW
#property indicator_color11  clrGreen,clrNONE
#property indicator_width11  1
#property indicator_label12  "cross3b"
#property indicator_type12   DRAW_COLOR_ARROW
#property indicator_color12  clrOrange,clrNONE
#property indicator_width12  1
#property indicator_label13  "ATR TRail"
#property indicator_type13   DRAW_COLOR_LINE
#property indicator_color13  clrRed,clrGreen,clrNavy
#property indicator_width13  1
#property indicator_label14  "background"
#property indicator_type14   DRAW_FILLING
#property indicator_color14  clrLightPink,clrLightGreen
#property indicator_width14  1

enum Bands_Style
  {
   range, true_range,
  };
enum Bands_Style1
  {
   rang,// range
   true_rang,  // true range
   Average_True_Range, //Average True Range
  };
// User Input
input int InpCandlesTotal = 2000;   // Total candles to run the calculation on
input int length =25;
input double mult3 = 3.3 ; // Multiplier 3
input double mult4 = 4.3 ;// Multiplier 4
input ENUM_APPLIED_PRICE src = PRICE_CLOSE ; //Source'
input bool exp = true;// exponential
input Bands_Style BandsStyle = true_range;
input bool emaplot = true;// Show EMA on chart
input int  EMAlen  = 100 ; // ema Length
input string hint= "================ Keltner Channel ================" ;
input int length1     = 20; // KC Length
input double mult        = 1.0; // KC Multiplier
input Bands_Style1 BandsStyle1 = Average_True_Range;//Bands Style
input int atrlength   = 10; // KC ATR Length
input string hint1="====================== Candles Count Short ====================";
input int CountShort =30; // CandlesCoount for short
input int CountLong  =30; // CandlesCoount for long
input int ATRPeriod = 18; // "ATR Period (his is the number of bars back that the script uses to calculate the Average True Range.)
input double ATRMultiplier =3;  // ATR Multiplier (This is the multiple of the ATR average that will function as the trail)
input int up_Plot=108;
input int dn_plot=108;
input bool PLOT_Triangle=true;
input int triangles_width=20;
input double triangle_Distance= 2;
input bool show_backgroung_colors=true; // show background colors

//---
double fill1[],fill2[];
double MA[];
double MA1[];
double EMAout[];
double rangema[];
double rangema1[];
double range_1[];
double upper3 [];
double lower3 [];
double upper4 [];
double lower4 [];
double upper [];
double lower [];
double ATR[];
double ATRTrail[];
double tr_arr[];
double buffer_color_line[];
double trail_color[];
double cross1a[],cross2a[],cross3a[];
double cross1b[],cross2b[],cross3b[];
double ATRTrailingStop[];
double clr1[],clr2[],clr3[],clr4[];
color colors[]= {clrYellow,clrGreen,clrRed,clrBlue,clrNONE};
color Tailcolors[]= {clrRed,clrGreen,clrNavy};

int ma,ma1,sma,atr,maout,atrTrail;
datetime date0  = D'2022.06.15 21:00';

//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if(exp)
      ma =iMA(Symbol(),PERIOD_CURRENT,length,0,MODE_EMA,src);
   else
      ma =iMA(Symbol(),PERIOD_CURRENT,length,0,MODE_SMA,src);
   if(true)
      ma1 =iMA(Symbol(),PERIOD_CURRENT,length1,0,MODE_EMA,PRICE_CLOSE);
   else
      ma1 =iMA(Symbol(),PERIOD_CURRENT,length1,0,MODE_SMA,PRICE_CLOSE);

   atr=iATR(Symbol(),PERIOD_CURRENT,atrlength);
   atrTrail=iATR(Symbol(),PERIOD_CURRENT,ATRPeriod);

   maout=iMA(Symbol(),PERIOD_CURRENT,EMAlen,0,MODE_EMA,PRICE_CLOSE);
   int K=0;
   SetIndexBuffer(K,upper3,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,lower3,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,upper4,INDICATOR_DATA);

   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,lower4,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,upper,INDICATOR_DATA);

   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,lower,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,MA1,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,EMAout,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;

   SetIndexBuffer(K,buffer_color_line,INDICATOR_COLOR_INDEX);
   K++;
   SetIndexBuffer(K,cross3a,INDICATOR_DATA);
   PlotIndexSetInteger(K,PLOT_ARROW,dn_plot);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,clr1,INDICATOR_COLOR_INDEX);

   K++;
   SetIndexBuffer(K,cross2a,INDICATOR_DATA);
   PlotIndexSetInteger(K,PLOT_ARROW,up_Plot);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,clr2,INDICATOR_COLOR_INDEX);

   K++;
   SetIndexBuffer(K,cross2b,INDICATOR_DATA);
   PlotIndexSetInteger(K,PLOT_ARROW,up_Plot);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,clr3,INDICATOR_COLOR_INDEX);

   K++;
   SetIndexBuffer(K,cross3b,INDICATOR_DATA);
   PlotIndexSetInteger(K,PLOT_ARROW,dn_plot);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,clr4,INDICATOR_COLOR_INDEX);

   K++;
   SetIndexBuffer(K,ATRTrailingStop,INDICATOR_DATA);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,trail_color,INDICATOR_COLOR_INDEX);
   K++;
   SetIndexBuffer(K,fill1,INDICATOR_DATA);
   K++;
   SetIndexBuffer(K,fill2,INDICATOR_DATA);
   K++;
   SetIndexBuffer(K,ATRTrail,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,cross1a,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,cross1b,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);

   K++;
   SetIndexBuffer(K,MA,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,range_1,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,rangema,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,rangema1,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,ATR,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);
   K++;
   SetIndexBuffer(K,tr_arr,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(K,PLOT_EMPTY_VALUE,0);

//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,-1,-1);
  }

//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int Highest=iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,WHOLE_ARRAY,0);
   int lowest=iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,WHOLE_ARRAY,0);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(MA,true);
   ArraySetAsSeries(MA1,true);
   ArraySetAsSeries(range_1,true);
   ArraySetAsSeries(rangema,true);
   ArraySetAsSeries(upper3,true);
   ArraySetAsSeries(lower3,true);
   ArraySetAsSeries(upper4,true);
   ArraySetAsSeries(lower4,true);
   ArraySetAsSeries(rangema1,true);
   ArraySetAsSeries(ATR,true);
   ArraySetAsSeries(tr_arr,true);
   ArraySetAsSeries(upper,true);
   ArraySetAsSeries(lower,true);
   ArraySetAsSeries(EMAout,true);
   ArraySetAsSeries(buffer_color_line,true);
   ArraySetAsSeries(cross1a,true);
   ArraySetAsSeries(cross2a,true);
   ArraySetAsSeries(cross3a,true);
   ArraySetAsSeries(cross1b,true);
   ArraySetAsSeries(cross2b,true);
   ArraySetAsSeries(cross3b,true);
   ArraySetAsSeries(ATRTrail,true);
   ArraySetAsSeries(ATRTrailingStop,true);
   ArraySetAsSeries(trail_color,true);
   ArraySetAsSeries(clr1,true);
   ArraySetAsSeries(clr2,true);
   ArraySetAsSeries(clr3,true);
   ArraySetAsSeries(clr4,true);
   ArraySetAsSeries(fill1,true);
   ArraySetAsSeries(fill2,true);
   int limit = 0;
   if(prev_calculated == 0)
     {
      limit = rates_total-1;
     }
   for(int i=limit; i>=0; i--)
     {
      if(i>InpCandlesTotal)
         continue;
      double ma_temp[1];
      double ma_temp1[1];
      double ma_temp2[1];
      double atr_temp[1];
      double atr_temp2[1];
      CopyBuffer(ma,0,i,1,ma_temp);
      MA[i]=ma_temp[0];
      CopyBuffer(ma1,0,i,1,ma_temp1);
      MA1[i]=ma_temp1[0];
      CopyBuffer(atr,0,i,1,atr_temp);
      ATR[i]=atr_temp[0];
      CopyBuffer(atrTrail,0,i,1,atr_temp2);
      ATRTrail[i]=atr_temp2[0];
      CopyBuffer(maout,0,i,1,ma_temp2);
      EMAout[i]=ma_temp2[0];
      double tr=MathMax(MathMax(high[i]-low[i],MathAbs(high[i]-close[i+1])),MathAbs(low[i]-close[i+1]));
      range_1[i] = BandsStyle == true_range ? tr : high[i] - low[i];
      int alpha = 1/length;
      double last_RMA=MathIsValidNumber(rangema[i+1])?rangema[i+1]:0;
      rangema[i] = MathIsValidNumber(rangema[i+1])? pine_sma(range_1, length,i) : alpha * range_1[i] + (1 - alpha) * last_RMA;

      upper3[i] = MA[i] + rangema[i] * mult3;
      lower3[i] = MA[i] - rangema[i]* mult3;
      upper4[i] = MA[i] + rangema[i] * mult4;
      lower4[i] = MA[i] - rangema[i] * mult4;

      double mid3 = (upper3[i] + upper4[i]) / 2;
      double mid4 = (lower3[i] + lower4[i]) / 2;
      tr_arr[i]=high[i]-low[i];
      double last_RMA1=MathIsValidNumber(rangema1[i+1])?rangema1[i+1]:0;
      double rma1= MathIsValidNumber(rangema1[i+1])? pine_sma(tr_arr, length1,i) : alpha * tr_arr[i] + (1 - alpha) * last_RMA1;
      rangema1[i] = BandsStyle1 == true_rang ? tr : BandsStyle1 == Average_True_Range ? ATR[i] : rma1;


      upper[i]= MA1[i] + rangema1[i] * mult;
      lower[i] = MA1[i] - rangema1[i] * mult;



      bool in_range1 = EMAout[i] < upper[i] && EMAout[i] > lower[i];
      bool EMAup  = EMAout[i] > EMAout[i+1];
      bool EMAdown    = EMAout[i] < EMAout[i+1];
      int colorIndex = in_range1 ? 0 : EMAup ? 1: EMAdown ? 2 : 3;
      if(emaplot)
         buffer_color_line[i]=colorIndex;
      else
         buffer_color_line[i]=4;
      if(EMAout[i+1]<upper[i+1] && EMAout[i]>upper[i])
         cross1a[i] = 1;
      else
         cross1a[i]=0;
      bool CondOne = CountCodition(cross1a, CountShort,i);
      if(CondOne)
        {
         fill1[i]=high[Highest];
         fill2[i]=low[lowest];
        }
      cross2a[i] = CondOne && EMAout[i] < EMAout[i+1] && EMAout[i] > upper[i] && high[i] > upper[i]?high[i]:0;
      if(cross2a[i] >0&&PLOT_Triangle)
         TextCreate(0,"cross2a"+TimeToString(time[i]),0,time[i],cross2a[i]+triangle_Distance*_Point*10,"6","Webdings",triangles_width,clrPurple);
      //plotshape(cross2a, style=shape.circle, color=color.new(#9C27B0, 0), size=size.small, location=location.abovebar);

      cross3a[i] = CondOne != EMAout[i] < EMAout[i+1] && EMAout[i] > upper[i] && high[i] > upper3[i]?high[i]:0;
      //plotshape(cross3a, style=shape.circle, color=color.new(#FFEB3B, 0), size=size.small, location=location.abovebar);
      if(cross3a[i] >0&&PLOT_Triangle)
         TextCreate(0,"cross2a"+TimeToString(time[i]),0,time[i],cross3a[i]+triangle_Distance*_Point*10,"6","Webdings",triangles_width,clrYellow);
      if(EMAout[i+1]>lower[i+1] && EMAout[i]<lower[i])
         cross1b[i] = 1;
      else
         cross1b[i]=0;

      bool CondTwo = CountCodition(cross1b, CountLong,i);
      if(CondTwo)
        {
         fill2[i]=high[Highest];
         fill1[i]=low[lowest];
        }
      cross2b[i] = CondTwo && EMAout[i] > EMAout[i+1] && EMAout[i] < lower[i] && low[i] < lower[i]?low[i]:0;
      //plotshape(cross2b, style=shape.circle, color=color.new(#4CAF50, 0), size=size.small, location=location.belowbar)

      cross3b[i] = CondTwo != EMAout[i] > EMAout[i+1] && EMAout[i] < lower[i] && low[i] < lower3[i]?low[i]:0;
      //plotshape(cross3b, style=shape.circle, color=color.new(#ff9800, 0), size=size.small, location=location.belowbar)
      if(cross3b[i] >0&&PLOT_Triangle)
         TextCreate(0,"cross2a"+TimeToString(time[i]),0,time[i],cross3b[i]-triangle_Distance*_Point*10,"5","Webdings",triangles_width,clrOrange);
      if(cross2b[i] >0&&PLOT_Triangle)
         TextCreate(0,"cross2a"+TimeToString(time[i]),0,time[i],cross2b[i]-triangle_Distance*_Point*10,"5","Webdings",triangles_width,clrGreen);
      if(PLOT_Triangle)
        {
         clr1[i]=1;
         clr2[i]=1;
         clr3[i]=1;
         clr4[i]=1;
        }
      else
        {
         clr1[i]=0;
         clr2[i]=0;
         clr3[i]=0;
         clr4[i]=0;
        }
       
       if(!show_backgroung_colors){
       fill1[i]=0;
       fill2[i]=0;
       }
      //ATR Trilinig

      double Stop = ATRMultiplier*ATR[i];
      if(close[i]>ATRTrailingStop[i+1]
         && close[i+1]>ATRTrailingStop[i+1])
        {
         ATRTrailingStop[i]=MathMax(ATRTrailingStop[i+1], close[i]-Stop);
        }
      else
         if(close[i]<ATRTrailingStop[i+1]
            && close[i+1]<ATRTrailingStop[i+1])
           {
            ATRTrailingStop[i]=MathMin(ATRTrailingStop[i+1], close[i]+Stop);
           }
         else
            if(close[i]>ATRTrailingStop[i+1])
               ATRTrailingStop[i]= close[i]-Stop;
            else
               ATRTrailingStop[i]=close[i]+Stop;

      if(close[i+1]<ATRTrailingStop[i+1] && close[i]>ATRTrailingStop[i+1])
         trail_color[i]=1;
      else
         if(close[i+1]>ATRTrailingStop[i+1] && close[i]<ATRTrailingStop[i+1])
            trail_color[i]=0;
         else
            trail_color[i]=trail_color[i+1];

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
// same on pine, but much less efficient
double pine_sma(double & x[],int y,int z)
  {
   double sum = 0.0;
   for(int i = z; i<z+y; i++)
     {
      sum = sum + x[i] / y;
     }
   return sum;
  }
//+------------------------------------------------------------------+
bool CountCodition(double & _cond[],int _lookback,int z)
  {
   bool _crossed = false;
   for(int i = z+1 ; i<z+_lookback; i++)
     {
      if(_cond[i] ==1)
         _crossed = true;
     }
   return _crossed;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // chart's ID
                const string            name="Text",              // object name
                const int               sub_window=0,             // subwindow index
                datetime                time=0,                   // anchor point time
                double                  price=0,                  // anchor point price
                const string            text="Text",              // the text itself
                const string            font="Webdings",             // font
                const int               font_size=10,             // font size
                const color             clr=clrRed,               // color
                const double            angle=0.0,                // text slope
                const ENUM_ANCHOR_POINT anchor=ANCHOR_CENTER, // anchor type
                const bool              back=false,               // in the background
                const bool              selection=false,          // highlight to move
                const bool              hidden=true,              // hidden in the object list
                const long              z_order=0)                // priority for mouse click
  {
//--- set anchor point coordinates if they are not set
   ChangeTextEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the object by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
bool TextMove(const long   chart_ID=0,  // chart's ID
              const string name="Text", // object name
              datetime     time=0,      // anchor point time coordinate
              double       price=0)     // anchor point price coordinate
  {
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,0,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
bool TextChange(const long   chart_ID=0,  // chart's ID
                const string name="Text", // object name
                const string text="Text") // text
  {
//--- reset the error value
   ResetLastError();
//--- change object text
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
bool TextDelete(const long   chart_ID=0,  // chart's ID
                const string name="Text") // object name
  {
//--- reset the error value
   ResetLastError();
//--- delete the object
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                                            testtometatrader.mq5 |
//|                                    Copyright 2025, Yousuf Mesalm. |
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+
