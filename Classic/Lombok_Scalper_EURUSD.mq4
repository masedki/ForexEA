
#property copyright "Copyright � 2015, theclai"
extern string GPS_Forex_Robot_EURUSD = " ";
/*
extern string ____Authentication________ = "---------------------------------------------";
extern string EMail = "";
extern string CBReceipt = "";
*/
extern string ____Size_of_lots________ = "---------------------------------------------";
extern bool UseMM = FALSE;
extern double Lots = 0.01;
extern double LotsRiskReductor = 30.0;
extern double MaxLots = 1000.0;
extern string ____General_Options_____ = "---------------------------------------------";
extern bool AutoGMTOffset = TRUE;
extern int GMTOffset = 1;
bool gi_160 = FALSE;
int gi_164 = 2;
bool gi_168 = TRUE;
double gd_172 = 64.0;
double gd_180 = 8.0;
int gi_188 = 11;
int gi_192 = 0;
bool gi_196 = TRUE;
bool gi_200 = FALSE;
bool gi_204 = TRUE;
bool gi_208 = FALSE;
bool gi_212 = TRUE;
int gi_216 = -14;
int gi_220 = 0;
int gi_224 = 20100106;
bool gi_228 = TRUE;
double gd_232 = 53.0;
double gd_240 = 14.0;
double gd_248 = 3.0;
int gi_256 = 20100126;
extern string ____Others______________ = "---------------------------------------------";
extern string ExpertComment = "Lombok Scalper";
extern color ColorBuy = Blue;
extern color ColorSell = Red;
extern bool SendEmail = FALSE;
extern bool SoundAlert = FALSE;
extern string SoundFileAtOpen = "alert.wav";
extern string SoundFileAtClose = "alert.wav";
extern bool WriteLog = FALSE;
extern bool WriteDebugLog = FALSE;
bool gi_316 = TRUE;
int gi_320 = 2;
int gi_324 = 1;
string gs_unused_328 = "New Trade Information";
string gs_336 = "New Trade Information";
int g_bool_344;
int gi_348;
int gi_352;
int g_slippage_356;
double gd_360;
double g_maxlot_368;
double g_minlot_376;
double gd_384;
double gd_392;
double g_lotstep_400;
double gd_408;
string g_symbol_416;
string gs_424;
bool gba_432[1];
double gda_436[1];
double gda_440[1];
int gia_444[1];
int gia_448[1];
bool gba_452[1][5];
int gia_456[1];
int gia_460[1];
int gia_464[1];
bool gba_468[1];
double gda_472[1];
double gda_476[1];
double gda_480[1];
int gia_484[1];
bool gi_488;
bool gi_492;
int gi_496 = 0;
bool gi_500 = FALSE;
int gi_504 = 0;
double gda_508[52] = {0};
string gs_512 = "";
string gs_520 = "";
string gs_528 = "";
bool gi_536 = FALSE;

int init() {
   gi_492 = TRUE;
   if (!IsDllsAllowed()) {
      SetCommentPrint("WARNING: Set Parameter \"AllowDLL Imports\" ON in menu Tools -> Options -> ExpertAdvisors.", "comment");
      gi_492 = FALSE;
      return (0);
   }
   if (StringSubstr(Symbol(), 0, 6) != "EURUSD") {
      SetCommentPrint("WARNING: Use Lombok Scalper EURUSD only on EURUSD pair.", "comment");
      gi_492 = FALSE;
      return (0);
   }
   if (IsTesting()) {
      if (AutoGMTOffset) {
         SetCommentPrint("WARNING: Automatic GMT offset calculation works only on live/demo trading " + "and should be set as FALSE for backtests - strategy testing.", "comment");
         gi_492 = FALSE;
         return (0);
      }
   }
   if (WriteDebugLog) {
      WriteLog = TRUE;
      Print("*************************** Initialization ***************************");
   }
   g_symbol_416 = Symbol();
   g_maxlot_368 = MarketInfo(g_symbol_416, MODE_MAXLOT);
   g_minlot_376 = MarketInfo(g_symbol_416, MODE_MINLOT);
   g_lotstep_400 = MarketInfo(g_symbol_416, MODE_LOTSTEP);
   if (g_lotstep_400 == 0.01) gi_348 = 2;
   else {
      if (g_lotstep_400 == 0.1) gi_348 = 1;
      else {
         if (g_lotstep_400 == 1.0) gi_348 = 0;
         else {
            if (g_lotstep_400 == 0.001) gi_348 = 3;
            else gi_348 = 4;
         }
      }
   }
   double l_leverage_0 = AccountLeverage();
   gd_408 = NormalizeDouble(LotsRiskReductor * (100 / l_leverage_0), 2);
   gs_424 = AccountCurrency();
   g_bool_344 = IsTesting();
   if (Digits < 4) {
      gd_360 = 0.01;
      gi_352 = 2;
   } else {
      gd_360 = 0.0001;
      gi_352 = 4;
   }
   int li_8 = MathPow(10, Digits - gi_352);
   g_slippage_356 = gi_164 * li_8;
   gd_384 = MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - gi_352);
   gd_392 = gd_384;
   if (IsTesting()) {
      Authentication();
      if (gi_496 != 1) {
         PrintInformation();
         gi_492 = FALSE;
         return (0);
      }
   }
   gi_488 = TRUE;
   return (0);
}

int deinit() {
   Comment("");
   if (WriteDebugLog) Print("*************************** Deinitialization ***************************");
   return (0);
}

int start() {
   double ld_24;
   if (!gi_492) return (0);
   int l_datetime_0 = TimeCurrent();
   if (!IsTesting()) {
      if (gi_488) {
       
         Authentication();
         gi_500 = TRUE;
         gi_504 = l_datetime_0;
         gi_488 = FALSE;
      }
      if (gi_500 == TRUE && gi_504 < l_datetime_0 - 60) {
         gi_500 = FALSE;
         gi_504 = l_datetime_0 + 60 * (780 - Rand(120));
      }
      if (gi_500 == FALSE && l_datetime_0 >= gi_504) {
         gi_500 = TRUE;
         Authentication();
      }
      PrintInformation();
   }
   if (gi_496 != 1) return (0);
   gd_384 = MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - gi_352);
   if (gd_384 > gd_392) gd_392 = gd_384;
   int l_datetime_4 = TimeCurrent();
   int li_8 = l_datetime_4 - 3600 * GMTOffset;
   int l_day_of_week_12 = TimeDayOfWeek(l_datetime_4);
   int l_datetime_16 = iTime(NULL, PERIOD_D1, 0);
   for (int l_index_20 = 0; l_index_20 < 1; l_index_20++) {
      if (gba_432[l_index_20]) {
         if (!gi_160) SetOrderLevels(gda_440[l_index_20], gda_436[l_index_20], gia_460[l_index_20]);
         WatchOrderLevels(gda_440[l_index_20], gda_436[l_index_20], gia_460[l_index_20]);
         if (gba_468[l_index_20]) {
            if (!gi_160) SetOrderLevels(gda_476[l_index_20], gda_472[l_index_20], gia_484[l_index_20]);
            WatchOrderLevels(gda_476[l_index_20], gda_472[l_index_20], gia_484[l_index_20]);
            if (HaveOrdersInDay(-2, gia_484[l_index_20], l_datetime_16) == 0) WatchReverseAfterSL(l_index_20);
         }
         if (l_day_of_week_12 <= 0 || l_day_of_week_12 > 5) continue;
         if ((gba_452[l_index_20][l_day_of_week_12 - 1])) {
            if (gia_444[l_index_20] != TimeHour(l_datetime_4) || gia_448[l_index_20] != TimeMinute(l_datetime_4)) continue;
            if (HaveOrdersInDay(-2, gia_460[l_index_20], l_datetime_16) <= 0) {
               ld_24 = LotsOptimized(gia_464[l_index_20]);
               if (gia_456[l_index_20] >= 0)
                  if (l_day_of_week_12 == gia_456[l_index_20]) ld_24 = NormalizeDouble(2.0 * ld_24, gi_348);
               OpenOrder(gia_464[l_index_20], gia_460[l_index_20], ExpertComment, ld_24);
            }
         }
      }
   }
   return (0);
}

string ErrorDescription(int ai_0) {
   string ls_ret_8;
   switch (ai_0) {
   case 0:
   case 1:
      ls_ret_8 = "no error";
      break;
   case 2:
      ls_ret_8 = "common error";
      break;
   case 3:
      ls_ret_8 = "invalid trade parameters";
      break;
   case 4:
      ls_ret_8 = "trade server is busy";
      break;
   case 5:
      ls_ret_8 = "old version of the client terminal";
      break;
   case 6:
      ls_ret_8 = "no connection with trade server";
      break;
   case 7:
      ls_ret_8 = "not enough rights";
      break;
   case 8:
      ls_ret_8 = "too frequent requests";
      break;
   case 9:
      ls_ret_8 = "malfunctional trade operation (never returned error)";
      break;
   case 64:
      ls_ret_8 = "account disabled";
      break;
   case 65:
      ls_ret_8 = "invalid account";
      break;
   case 128:
      ls_ret_8 = "trade timeout";
      break;
   case 129:
      ls_ret_8 = "invalid price";
      break;
   case 130:
      ls_ret_8 = "invalid stops";
      break;
   case 131:
      ls_ret_8 = "invalid trade volume";
      break;
   case 132:
      ls_ret_8 = "market is closed";
      break;
   case 133:
      ls_ret_8 = "trade is disabled";
      break;
   case 134:
      ls_ret_8 = "not enough money";
      break;
   case 135:
      ls_ret_8 = "price changed";
      break;
   case 136:
      ls_ret_8 = "off quotes";
      break;
   case 137:
      ls_ret_8 = "broker is busy (never returned error)";
      break;
   case 138:
      ls_ret_8 = "requote";
      break;
   case 139:
      ls_ret_8 = "order is locked";
      break;
   case 140:
      ls_ret_8 = "long positions only allowed";
      break;
   case 141:
      ls_ret_8 = "too many requests";
      break;
   case 145:
      ls_ret_8 = "modification denied because order too close to market";
      break;
   case 146:
      ls_ret_8 = "trade context is busy";
      break;
   case 147:
      ls_ret_8 = "expirations are denied by broker";
      break;
   case 148:
      ls_ret_8 = "amount of open and pending orders has reached the limit";
      break;
   case 149:
      ls_ret_8 = "hedging is prohibited";
      break;
   case 150:
      ls_ret_8 = "prohibited by FIFO rules";
      break;
   case 4000:
      ls_ret_8 = "no error (never generated code)";
      break;
   case 4001:
      ls_ret_8 = "wrong function pointer";
      break;
   case 4002:
      ls_ret_8 = "array index is out of range";
      break;
   case 4003:
      ls_ret_8 = "no memory for function call stack";
      break;
   case 4004:
      ls_ret_8 = "recursive stack overflow";
      break;
   case 4005:
      ls_ret_8 = "not enough stack for parameter";
      break;
   case 4006:
      ls_ret_8 = "no memory for parameter string";
      break;
   case 4007:
      ls_ret_8 = "no memory for temp string";
      break;
   case 4008:
      ls_ret_8 = "not initialized string";
      break;
   case 4009:
      ls_ret_8 = "not initialized string in array";
      break;
   case 4010:
      ls_ret_8 = "no memory for array\' string";
      break;
   case 4011:
      ls_ret_8 = "too long string";
      break;
   case 4012:
      ls_ret_8 = "remainder from zero divide";
      break;
   case 4013:
      ls_ret_8 = "zero divide";
      break;
   case 4014:
      ls_ret_8 = "unknown command";
      break;
   case 4015:
      ls_ret_8 = "wrong jump (never generated error)";
      break;
   case 4016:
      ls_ret_8 = "not initialized array";
      break;
   case 4017:
      ls_ret_8 = "dll calls are not allowed";
      break;
   case 4018:
      ls_ret_8 = "cannot load library";
      break;
   case 4019:
      ls_ret_8 = "cannot call function";
      break;
   case 4020:
      ls_ret_8 = "expert function calls are not allowed";
      break;
   case 4021:
      ls_ret_8 = "not enough memory for temp string returned from function";
      break;
   case 4022:
      ls_ret_8 = "system is busy (never generated error)";
      break;
   case 4050:
      ls_ret_8 = "invalid function parameters count";
      break;
   case 4051:
      ls_ret_8 = "invalid function parameter value";
      break;
   case 4052:
      ls_ret_8 = "string function internal error";
      break;
   case 4053:
      ls_ret_8 = "some array error";
      break;
   case 4054:
      ls_ret_8 = "incorrect series array using";
      break;
   case 4055:
      ls_ret_8 = "custom indicator error";
      break;
   case 4056:
      ls_ret_8 = "arrays are incompatible";
      break;
   case 4057:
      ls_ret_8 = "global variables processing error";
      break;
   case 4058:
      ls_ret_8 = "global variable not found";
      break;
   case 4059:
      ls_ret_8 = "function is not allowed in testing mode";
      break;
   case 4060:
      ls_ret_8 = "function is not confirmed";
      break;
   case 4061:
      ls_ret_8 = "send mail error";
      break;
   case 4062:
      ls_ret_8 = "string parameter expected";
      break;
   case 4063:
      ls_ret_8 = "integer parameter expected";
      break;
   case 4064:
      ls_ret_8 = "double parameter expected";
      break;
   case 4065:
      ls_ret_8 = "array as parameter expected";
      break;
   case 4066:
      ls_ret_8 = "requested history data in update state";
      break;
   case 4099:
      ls_ret_8 = "end of file";
      break;
   case 4100:
      ls_ret_8 = "some file error";
      break;
   case 4101:
      ls_ret_8 = "wrong file name";
      break;
   case 4102:
      ls_ret_8 = "too many opened files";
      break;
   case 4103:
      ls_ret_8 = "cannot open file";
      break;
   case 4104:
      ls_ret_8 = "incompatible access to a file";
      break;
   case 4105:
      ls_ret_8 = "no order selected";
      break;
   case 4106:
      ls_ret_8 = "unknown symbol";
      break;
   case 4107:
      ls_ret_8 = "invalid price parameter for trade function";
      break;
   case 4108:
      ls_ret_8 = "invalid ticket";
      break;
   case 4109:
      ls_ret_8 = "trade is not allowed in the expert properties";
      break;
   case 4110:
      ls_ret_8 = "longs are not allowed in the expert properties";
      break;
   case 4111:
      ls_ret_8 = "shorts are not allowed in the expert properties";
      break;
   case 4200:
      ls_ret_8 = "object is already exist";
      break;
   case 4201:
      ls_ret_8 = "unknown object property";
      break;
   case 4202:
      ls_ret_8 = "object is not exist";
      break;
   case 4203:
      ls_ret_8 = "unknown object type";
      break;
   case 4204:
      ls_ret_8 = "no object name";
      break;
   case 4205:
      ls_ret_8 = "object coordinates error";
      break;
   case 4206:
      ls_ret_8 = "no specified subwindow";
      break;
   default:
      ls_ret_8 = "unknown error";
   }
   return (ls_ret_8);
}

string OrderTypeToStr(int ai_0) {
   string ls_ret_8;
   switch (ai_0) {
   case 0:
      ls_ret_8 = "Buy";
      break;
   case 1:
      ls_ret_8 = "Sell";
      break;
   case 2:
      ls_ret_8 = "BuyLimit";
      break;
   case 3:
      ls_ret_8 = "SellLimit";
      break;
   case 4:
      ls_ret_8 = "BuyStop";
      break;
   case 5:
      ls_ret_8 = "SellStop";
      break;
   default:
      ls_ret_8 = "Unknown";
   }
   return (ls_ret_8);
}

int GetGMTCorrection(int ai_0) {
   ai_0 += GMTOffset;
   while (true) {
      if (ai_0 >= 24) {
         ai_0 -= 24;
         continue;
      }
      if (ai_0 >= 0) break;
      ai_0 += 24;
   }
   return (ai_0);
}

void SetOrderLevels(double ad_0, double ad_8, int a_magic_16) {
   int l_cmd_36;
   double ld_40;
   double l_price_48;
   double ld_56;
   double ld_64;
   bool li_72;
   double l_price_76;
   bool li_84;
   double l_price_88;
   bool l_bool_96;
   double ld_20 = NormalizeDouble(MarketInfo(g_symbol_416, MODE_STOPLEVEL) * Point, Digits);
   int li_28 = OrdersTotal() - 1;
   for (int l_pos_32 = li_28; l_pos_32 >= 0; l_pos_32--) {
      if (!OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteLog) Print(StringConcatenate("SetOrderLevels: OrderSelect() error = ", ErrorDescription(GetLastError())));
      } else {
         if (OrderMagicNumber() == a_magic_16) {
            if (OrderSymbol() == g_symbol_416) {
               l_cmd_36 = OrderType();
               ld_40 = NormalizeDouble(OrderClosePrice(), Digits);
               l_price_48 = NormalizeDouble(OrderOpenPrice(), Digits);
               if (l_cmd_36 > OP_SELL)
                  if (NormalizeDouble(MathAbs(l_price_48 - ld_40), Digits) <= ld_20) continue;
               ld_56 = NormalizeDouble(OrderStopLoss(), Digits);
               ld_64 = NormalizeDouble(OrderTakeProfit(), Digits);
               li_72 = FALSE;
               if (ld_56 == 0.0) {
                  if (ad_8 < 0.0) {
                     if (l_cmd_36 % 2 == 0) {
                        l_price_76 = NormalizeDouble(l_price_48 + ad_8, Digits);
                        if (NormalizeDouble(ld_40 - l_price_76, Digits) > ld_20) li_72 = TRUE;
                        else l_price_76 = ld_56;
                     } else {
                        l_price_76 = NormalizeDouble(l_price_48 - ad_8, Digits);
                        if (NormalizeDouble(l_price_76 - ld_40, Digits) > ld_20) li_72 = TRUE;
                        else l_price_76 = ld_56;
                     }
                  } else l_price_76 = ld_56;
               } else l_price_76 = ld_56;
               li_84 = FALSE;
               if (ld_64 == 0.0) {
                  if (ad_0 > 0.0) {
                     if (l_cmd_36 % 2 == 0) {
                        l_price_88 = NormalizeDouble(l_price_48 + ad_0, Digits);
                        if (NormalizeDouble(l_price_88 - ld_40, Digits) > ld_20) li_84 = TRUE;
                        else l_price_88 = ld_64;
                     } else {
                        l_price_88 = NormalizeDouble(l_price_48 - ad_0, Digits);
                        if (NormalizeDouble(ld_40 - l_price_88, Digits) > ld_20) li_84 = TRUE;
                        else l_price_88 = ld_64;
                     }
                  } else l_price_88 = ld_64;
               } else l_price_88 = ld_64;
               if (li_72 || li_84) {
                  while (!IsTradeAllowed()) Sleep(1000);
                  l_bool_96 = OrderModify(OrderTicket(), l_price_48, l_price_76, l_price_88, 0, CLR_NONE);
                  if (!l_bool_96)
                     if (WriteLog) Print(StringConcatenate("SetOrderLevels: OrderModify(", OrderTypeToStr(OrderType()), ") error = ", ErrorDescription(GetLastError())));
               }
            }
         }
      }
   }
}

void WatchOrderLevels(double ad_0, double ad_8, int a_magic_16) {
   double ld_28;
   double ld_36;
   double ld_44;
   if (ad_0 <= 0.0 && ad_8 >= 0.0) return;
   int li_20 = OrdersTotal() - 1;
   for (int l_pos_24 = li_20; l_pos_24 >= 0; l_pos_24--) {
      if (!OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteLog) Print(StringConcatenate("WatchOrderLevels: OrderSelect() error = ", ErrorDescription(GetLastError())));
      } else {
         if (OrderMagicNumber() == a_magic_16) {
            if (OrderType() <= OP_SELL) {
               if (OrderSymbol() == g_symbol_416) {
                  ld_28 = NormalizeDouble(OrderClosePrice(), Digits);
                  ld_36 = NormalizeDouble(OrderOpenPrice(), Digits);
                  if (OrderType() == OP_BUY) {
                     ld_44 = NormalizeDouble(ld_28 - ld_36, Digits);
                     if ((ad_0 > 0.0 && ld_44 >= ad_0) || (ad_8 < 0.0 && ld_44 <= ad_8)) {
                        if (WriteLog) Print("WatchOrderLevels: level for close BUY");
                        CloseOrder(OrderTicket(), OrderLots(), 0, g_slippage_356);
                     }
                  } else {
                     ld_44 = NormalizeDouble(ld_36 - ld_28, Digits);
                     if ((ad_0 > 0.0 && ld_44 >= ad_0) || (ad_8 < 0.0 && ld_44 <= ad_8)) {
                        if (WriteLog) Print("WatchOrderLevels: level for close SELL");
                        CloseOrder(OrderTicket(), OrderLots(), 1, g_slippage_356);
                     }
                  }
               }
            }
         }
      }
   }
}

double LotsOptimized(int ai_unused_0) {
   double ld_ret_4;
   double ld_12;
   double ld_20;
   if (!UseMM) ld_ret_4 = Lots;
   else {
      ld_12 = AccountFreeMargin() * gd_408 / 100.0;
      ld_20 = MarketInfo(g_symbol_416, MODE_MARGINREQUIRED) * g_lotstep_400;
      ld_ret_4 = NormalizeDouble(MathFloor(ld_12 / ld_20) * g_lotstep_400, gi_348);
   }
   if (ld_ret_4 > MaxLots) ld_ret_4 = MaxLots;
   if (ld_ret_4 < g_minlot_376) ld_ret_4 = g_minlot_376;
   if (ld_ret_4 > g_maxlot_368) ld_ret_4 = g_maxlot_368;
   return (ld_ret_4);
}

int OpenOrder(int a_cmd_0, int a_magic_4, string a_comment_8, double ad_16, double a_price_24 = 0.0) {
   color l_color_36;
   int l_ticket_72;
   int l_error_76;
   double ld_80;
   if (a_cmd_0 > OP_SELL && a_price_24 == 0.0) return (-1);
   int l_cmd_32 = a_cmd_0 % 2;
   if (ad_16 < g_minlot_376) ad_16 = g_minlot_376;
   else
      if (ad_16 > g_maxlot_368) ad_16 = g_maxlot_368;
   if (AccountFreeMarginCheck(g_symbol_416, l_cmd_32, ad_16) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
      if (WriteLog) Print("OpenOrder: you don\'t have free margin.");
      return (-1);
   }
   if (l_cmd_32 == OP_BUY) l_color_36 = ColorBuy;
   else l_color_36 = ColorSell;
   RefreshRates();
   double ld_40 = NormalizeDouble(MarketInfo(g_symbol_416, MODE_STOPLEVEL) * Point, Digits);
   double ld_48 = NormalizeDouble(Ask, Digits);
   double ld_56 = NormalizeDouble(Bid, Digits);
   switch (a_cmd_0) {
   case OP_BUY:
      a_price_24 = ld_48;
      break;
   case OP_SELL:
      a_price_24 = ld_56;
      break;
   case OP_BUYLIMIT:
      if (a_price_24 >= ld_48) {
         a_price_24 = ld_48;
         a_cmd_0 = 0;
      } else
         if (NormalizeDouble(ld_48 - a_price_24, Digits) < ld_40) return (-1);
      break;
   case OP_SELLLIMIT:
      if (a_price_24 <= ld_56) {
         a_price_24 = ld_56;
         a_cmd_0 = 1;
      } else
         if (NormalizeDouble(a_price_24 - ld_56, Digits) < ld_40) return (-1);
      break;
   case OP_BUYSTOP:
      if (a_price_24 <= ld_48) {
         a_price_24 = ld_48;
         a_cmd_0 = 0;
      } else
         if (NormalizeDouble(a_price_24 - ld_48, Digits) < ld_40) return (-1);
      break;
   case OP_SELLSTOP:
      if (a_price_24 >= ld_56) {
         a_price_24 = ld_56;
         a_cmd_0 = 1;
      } else
         if (NormalizeDouble(ld_56 - a_price_24, Digits) < ld_40) return (-1);
      break;
   default:
      return (-1);
   }
   int li_68 = gi_320;
   while (li_68 > 0) {
      while (!IsTradeAllowed()) Sleep(1000);
      l_ticket_72 = OrderSend(g_symbol_416, a_cmd_0, ad_16, a_price_24, g_slippage_356, 0, 0, a_comment_8, a_magic_4, 0, l_color_36);
      Sleep(MathRand() / 1000);
      if (l_ticket_72 < 0) {
         l_error_76 = GetLastError();
         if (WriteLog) {
            Print("OpenOrder: OrderSend(", OrderTypeToStr(a_cmd_0), ") error = ", ErrorDescription(l_error_76));
            Print("OpenOrder: order ", g_symbol_416, " ", OrderTypeToStr(a_cmd_0), " lot = ", DoubleToStr(ad_16, 8), " op = ", DoubleToStr(a_price_24, 8), " slippage = ", g_slippage_356);
         }
         if (l_error_76 != 136/* OFF_QUOTES */) break;
         if (!(gi_316)) break;
         Sleep(6000);
         RefreshRates();
         if (a_cmd_0 == OP_BUY) ld_80 = NormalizeDouble(Ask, Digits);
         else ld_80 = NormalizeDouble(Bid, Digits);
         if (NormalizeDouble(MathAbs((ld_80 - a_price_24) / gd_360), 0) > gi_324) break;
         a_price_24 = ld_80;
         li_68--;
         if (li_68 > 0)
            if (WriteLog) Print("... Possible to open order.");
         ad_16 = NormalizeDouble(ad_16 / 2.0, gi_348);
         if (ad_16 < g_minlot_376) ad_16 = g_minlot_376;
      } else {
         if (OrderSelect(l_ticket_72, SELECT_BY_TICKET)) a_price_24 = OrderOpenPrice();
         if (SendEmail) {
            SendMail(gs_336, StringConcatenate("Lombok Scalper trade Information\nCurrency Pair: ", StringSubstr(g_symbol_416, 0, 6), 
               "\nTime: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), 
               "\nOrder Type: ", OrderTypeToStr(a_cmd_0), 
               "\nPrice: ", DoubleToStr(a_price_24, Digits), 
               "\nLot size: ", DoubleToStr(ad_16, gi_348), 
               "\nEvent: Trade Opened", 
               "\n\nCurrent Balance: ", DoubleToStr(AccountBalance(), 2), " ", gs_424, 
            "\nCurrent Equity: ", DoubleToStr(AccountEquity(), 2), " ", gs_424));
         }
         if (!(SoundAlert)) break;
         PlaySound(SoundFileAtOpen);
         break;
      }
   }
   return (l_ticket_72);
}

int CloseOrder(int a_ticket_0, double a_lots_4, int ai_12, int a_slippage_16) {
   color l_color_20;
   double l_price_40;
   bool l_ord_close_48;
   int l_error_52;
   bool li_56;
   if (ai_12 == 0) l_color_20 = ColorBuy;
   else l_color_20 = ColorSell;
   int l_count_24 = 0;
   int l_count_28 = 0;
   int l_count_32 = 0;
   int l_count_36 = 0;
   while (true) {
      while (!IsTradeAllowed()) Sleep(1000);
      RefreshRates();
      if (ai_12 == 0) l_price_40 = NormalizeDouble(Bid, Digits);
      else l_price_40 = NormalizeDouble(Ask, Digits);
      l_ord_close_48 = OrderClose(a_ticket_0, a_lots_4, l_price_40, a_slippage_16, l_color_20);
      if (!l_ord_close_48) {
         l_error_52 = GetLastError();
         if (WriteLog) Print(StringConcatenate("OrderClose(", OrderTypeToStr(ai_12), ",", DoubleToStr(a_ticket_0, 0), ") error = ", ErrorDescription(l_error_52)));
         li_56 = FALSE;
         switch (l_error_52) {
         case 0/* NO_ERROR */:
            Sleep(10000);
            if (OrderSelect(a_ticket_0, SELECT_BY_TICKET))
               if (OrderCloseTime() == 0) li_56 = TRUE;
            break;
         case 1/* NO_RESULT */: break;
         case 2/* COMMON_ERROR */: break;
         case 3/* INVALID_TRADE_PARAMETERS */: break;
         case 4/* SERVER_BUSY */: break;
         case 5/* OLD_VERSION */: break;
         case 6/* NO_CONNECTION */:
            Sleep(10000);
            if (IsConnected()) li_56 = TRUE;
            break;
         case 7/* NOT_ENOUGH_RIGHTS */: break;
         case 8/* TOO_FREQUENT_REQUESTS */: break;
         case 9/* MALFUNCTIONAL_TRADE */: break;
         case 64/* ACCOUNT_DISABLED */: break;
         case 65/* INVALID_ACCOUNT */: break;
         case 128/* TRADE_TIMEOUT */:
            Sleep(70000);
            if (OrderSelect(a_ticket_0, SELECT_BY_TICKET))
               if (OrderCloseTime() == 0) li_56 = TRUE;
            break;
         case 129/* INVALID_PRICE */:
            Sleep(6000);
            l_count_24++;
            if (l_count_24 <= 3) li_56 = TRUE;
            break;
         case 130/* INVALID_STOPS */:
            Sleep(6000);
            l_count_28++;
            if (l_count_28 <= 3) li_56 = TRUE;
            break;
         case 131/* INVALID_TRADE_VOLUME */: break;
         case 132/* MARKET_CLOSED */: break;
         case 133/* TRADE_DISABLED */: break;
         case 134/* NOT_ENOUGH_MONEY */: break;
         case 135/* PRICE_CHANGED */:
            li_56 = TRUE;
            break;
         case 136/* OFF_QUOTES */:
            Sleep(6000);
            li_56 = TRUE;
            break;
         case 137/* BROKER_BUSY */:
            Sleep(20000);
            l_count_32++;
            if (l_count_32 <= 3) li_56 = TRUE;
            break;
         case 138/* REQUOTE */:
            l_count_36++;
            if (l_count_36 <= 3) li_56 = TRUE;
            break;
         case 139/* ORDER_LOCKED */: break;
         case 140/* LONG_POSITIONS_ONLY_ALLOWED */: break;
         case 141/* TOO_MANY_REQUESTS */: break;
         case 142:
            Sleep(70000);
            if (OrderSelect(a_ticket_0, SELECT_BY_TICKET))
               if (OrderCloseTime() == 0) li_56 = TRUE;
            break;
         case 143:
            Sleep(70000);
            if (OrderSelect(a_ticket_0, SELECT_BY_TICKET))
               if (OrderCloseTime() == 0) li_56 = TRUE;
            break;
         case 144: break;
         case 145/* TRADE_MODIFY_DENIED */:
            Sleep(20000);
            li_56 = TRUE;
            break;
         case 146/* TRADE_CONTEXT_BUSY */:
            while (IsTradeContextBusy()) Sleep(1000);
            li_56 = TRUE;
            break;
         case 147/* ERR_TRADE_EXPIRATION_DENIED */: break;
         case 148/* ERR_TRADE_TOO_MANY_ORDERS */: break;
         case 149/* ? */: break;
         case 150: break;
         case 4000/* NO_MQLERROR */:
            Sleep(10000);
            if (OrderSelect(a_ticket_0, SELECT_BY_TICKET))
               if (OrderCloseTime() == 0) li_56 = TRUE;
         case 4051/* INVALID_FUNCTION_PARAMETER_VALUE */: break;
         case 4062/* STRING_PARAMETER_EXPECTED */: break;
         case 4063/* INTEGER_PARAMETER_EXPECTED */: break;
         case 4064/* DOUBLE_PARAMETER_EXPECTED */: break;
         case 4105/* NO_ORDER_SELECTED */: break;
         case 4106/* UNKNOWN_SYMBOL */: break;
         case 4107/* INVALID_PRICE_PARAM */: break;
         case 4108/* INVALID_TICKET */: break;
         case 4109/* TRADE_NOT_ALLOWED */: break;
         case 4110/* LONGS__NOT_ALLOWED */: break;
         case 4111/* SHORTS_NOT_ALLOWED */: break;
         }
         if (!(li_56)) break;
         continue;
      }
      if (OrderSelect(a_ticket_0, SELECT_BY_TICKET)) l_price_40 = OrderClosePrice();
      if (SendEmail) {
         SendMail(gs_336, StringConcatenate("Lombok Scalper trade Information\nCurrency Pair: ", StringSubstr(g_symbol_416, 0, 6), 
            "\nTime: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), 
            "\nOrder Type: ", OrderTypeToStr(ai_12), 
            "\nPrice: ", DoubleToStr(l_price_40, Digits), 
            "\nLot size: ", DoubleToStr(a_lots_4, gi_348), 
            "\nEvent: Trade Closed", 
            "\n\nCurrent Balance: ", DoubleToStr(AccountBalance(), 2), " ", gs_424, 
         "\nCurrent Equity: ", DoubleToStr(AccountEquity(), 2), " ", gs_424));
      }
      if (!(SoundAlert)) break;
      PlaySound(SoundFileAtClose);
      break;
   }
   return (l_ord_close_48);
}

int HaveOrdersInDay(int a_cmd_0, int a_magic_4, int ai_8) {
   int l_cmd_24;
   int l_count_12 = 0;
   int li_16 = OrdersTotal() - 1;
   for (int l_pos_20 = li_16; l_pos_20 >= 0; l_pos_20--) {
      if (!OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteLog) Print(StringConcatenate("HaveOrdersInDay: OrderSelect() error = ", ErrorDescription(GetLastError())));
      } else {
         if (OrderMagicNumber() == a_magic_4) {
            if (OrderSymbol() == g_symbol_416) {
               l_cmd_24 = OrderType();
               if (a_cmd_0 == -4) {
                  if (l_cmd_24 % 2 != 0) continue;
               } else {
                  if (a_cmd_0 == -5) {
                     if (l_cmd_24 % 2 != 1) continue;
                  } else {
                     if (a_cmd_0 == -3) {
                        if (l_cmd_24 <= OP_SELL) continue;
                     } else {
                        if (a_cmd_0 == -2) {
                           if (l_cmd_24 > OP_SELL) continue;
                        } else {
                           if (a_cmd_0 >= OP_BUY)
                              if (l_cmd_24 != a_cmd_0) continue;
                        }
                     }
                  }
               }
               if (OrderOpenTime() >= ai_8) l_count_12++;
            }
         }
      }
   }
   if (l_count_12 == 0) {
      li_16 = OrdersHistoryTotal() - 1;
      for (l_pos_20 = li_16; l_pos_20 >= 0; l_pos_20--) {
         if (!OrderSelect(l_pos_20, SELECT_BY_POS, MODE_HISTORY)) {
            if (WriteLog) Print(StringConcatenate("HaveOrdersInDay: OrderSelect_2() error = ", ErrorDescription(GetLastError())));
         } else {
            if (OrderMagicNumber() == a_magic_4) {
               if (OrderSymbol() == g_symbol_416) {
                  l_cmd_24 = OrderType();
                  if (a_cmd_0 == -4) {
                     if (l_cmd_24 % 2 != 0) continue;
                  } else {
                     if (a_cmd_0 == -5) {
                        if (l_cmd_24 % 2 != 1) continue;
                     } else {
                        if (a_cmd_0 == -3) {
                           if (l_cmd_24 <= OP_SELL) continue;
                        } else {
                           if (a_cmd_0 == -2) {
                              if (l_cmd_24 > OP_SELL) continue;
                           } else {
                              if (a_cmd_0 >= OP_BUY)
                                 if (l_cmd_24 != a_cmd_0) continue;
                           }
                        }
                     }
                  }
                  if (OrderOpenTime() < ai_8) break;
                  l_count_12++;
               }
            }
         }
      }
   }
   return (l_count_12);
}

void WatchReverseAfterSL(int ai_0) {
   int l_magic_12;
   int l_datetime_16;
   double ld_20;
   int li_4 = OrdersHistoryTotal() - 1;
   for (int l_pos_8 = li_4; l_pos_8 >= 0; l_pos_8--) {
      if (!OrderSelect(l_pos_8, SELECT_BY_POS, MODE_HISTORY)) {
         if (WriteLog) Print(StringConcatenate("WatchReverseAfterSL: OrderSelect() error = ", ErrorDescription(GetLastError())));
      } else {
         l_magic_12 = OrderMagicNumber();
         if (l_magic_12 == gia_484[ai_0]) break;
         if (l_magic_12 == gia_460[ai_0]) {
            if (OrderSymbol() == g_symbol_416) {
               if (OrderProfit() >= 0.0) break;
               l_datetime_16 = OrderCloseTime();
               if (TimeHour(l_datetime_16) != Hour()) break;
               if (TimeMinute(l_datetime_16) != Minute()) break;
               if (TimeDay(l_datetime_16) != Day()) break;
               if (TimeMonth(l_datetime_16) != Month()) break;
               ld_20 = NormalizeDouble(OrderLots() * gda_480[ai_0], gi_348);
               if (ld_20 > MaxLots) ld_20 = MaxLots;
               if (ld_20 < g_minlot_376) ld_20 = g_minlot_376;
               if (ld_20 > g_maxlot_368) ld_20 = g_maxlot_368;
               OpenOrder(MathAbs(gia_464[ai_0] - 1), gia_484[ai_0], ExpertComment, ld_20);
               return;
            }
         }
      }
   }
}

int SetCommentPrint(string as_0, string as_8 = "") {
   Comment("\n\n" + "Lombok Scalper" 
      + "\n" 
      + "www.gpsforexrobot.com" 
   + "\n\n" + as_0);
   if (as_8 != "") {
      if (as_8 == "comment") Print(as_0);
      else Print(as_8);
   }
   return (1);
}

int PrintInformation() {
   string ls_0;
   if (gi_496 == 1) {
      if (IsDemo()) ls_0 = "Demo";
      else ls_0 = "Real";
      SetCommentPrint("AUTHENTICATION STATUS: " 
         + "\n" 
         + gs_520 
         + "\n" 
         + "---------------------------------------------------" 
         + "\n" 
         + "GENERAL INFORMATION:" 
         + "\n" 
         + "Broker Company:            " + AccountCompany() 
         + "\n" 
         + "Terminal Company:         " + TerminalCompany() 
         + "\n" 
         + "Server Name:                 " + AccountServer() 
         + "\n" 
         + "Current Server Time:       " + TimeToStr(TimeCurrent(), TIME_SECONDS) 
         + "\n" 
         + "---------------------------------------------------" 
         + "\n" 
         + "ACCOUNT INFORMATION:" 
         + "\n" 
         + "Account Name:               " + AccountName() 
         + "\n" 
         + "Account Number:             " + AccountNumber() 
         + "\n" 
         + "Account Type:                " + ls_0 
         + "\n" 
         + "Account Leverage:           1:" + DoubleToStr(AccountLeverage(), 0) 
         + "\n" 
         + "Account Balance:             " + DoubleToStr(AccountBalance(), 2) 
         + "\n" 
         + "Account Equity:               " + DoubleToStr(AccountEquity(), 2) 
         + "\n" 
         + "Account Floating P/L:        " + DoubleToStr(AccountProfit(), 2) 
         + "\n" 
         + "Account Currency:           " + AccountCurrency() 
         + "\n" 
         + "---------------------------------------------------" 
         + "\n" 
         + "ADDITIONAL INFORMATION:" 
         + "\n" 
         + "Current Spread:               " + DoubleToStr(gd_384, Digits - gi_352) 
         + "\n" 
         + "Maximum Spread:            " + DoubleToStr(gd_392, Digits - gi_352) 
         + "\n" 
         + "Free Margin:                   " + DoubleToStr(AccountFreeMargin(), 2) 
         + "\n" 
         + "Used Margin:                   " + DoubleToStr(AccountMargin(), 2) 
         + "\n" 
         + "---------------------------------------------------" 
         + "\n" 
         + "GMT SETTINGS:" 
         + "\n" 
      + "GMT Offset:                   " + gs_512);
   } else {
      if (!gi_536) {
         SetCommentPrint("AUTHENTICATION STATUS: " 
            + "\n" 
         + gs_520, gs_528);
         gi_536 = TRUE;
      }
   }
   return (0);
}

int SetVariables() {
   gda_508[0] = 1.00000000;
   gda_508[1] = 2.00000000;
   gda_508[2] = 88.00000000;
   gda_508[3] = 5.00000000;
   gda_508[4] = 23.00000000;
   gda_508[5] = 0.00000000;
   gda_508[6] = 1.00000000;
   gda_508[7] = 1.00000000;
   gda_508[8] = 1.00000000;
   gda_508[9] = 1.00000000;
   gda_508[10] = 1.00000000;
   gda_508[11] = -2.00000000;
   gda_508[12] = 0.00000000;
   gda_508[13] = 220.00000000;
   gda_508[14] = 18.00000000;
   gda_508[15] = 5.30000000;
               
   if (gda_508[0] == 1.0) gi_160 = TRUE;
   else gi_160 = FALSE;
   gi_164 = gda_508[1];
   gd_172 = gda_508[2];
   gd_180 = gda_508[3];
   gi_188 = gda_508[4];
   gi_192 = gda_508[5];
   if (gda_508[6] == 1.0) gi_196 = TRUE;
   else gi_196 = FALSE;
   if (gda_508[7] == 1.0) gi_200 = TRUE;
   else gi_200 = FALSE;
   if (gda_508[8] == 1.0) gi_204 = TRUE;
   else gi_204 = FALSE;
   if (gda_508[9] == 1.0) gi_208 = TRUE;
   else gi_208 = FALSE;
   if (gda_508[10] == 1.0) gi_212 = TRUE;
   else gi_212 = FALSE;
   gi_216 = gda_508[11];
   if (gda_508[12] == 1.0) gi_220 = TRUE;
   else gi_220 = FALSE;
   gd_232 = gda_508[13];
   gd_240 = gda_508[14];
   gd_248 = gda_508[15];
   gba_432[0] = gi_168;
   gda_436[0] = NormalizeDouble((-1.0 * gd_172) * gd_360, Digits);
   gda_440[0] = NormalizeDouble(gd_180 * gd_360, Digits);
   gia_444[0] = GetGMTCorrection(gi_188);
   gia_448[0] = gi_192;
   gba_452[0][0] = gi_196;
   gba_452[0][1] = gi_200;
   gba_452[0][2] = gi_204;
   gba_452[0][3] = gi_208;
   gba_452[0][4] = gi_212;
   gia_456[0] = gi_216;
   gia_464[0] = gi_220;
   gia_460[0] = gi_224;
   gba_468[0] = gi_228;
   gda_472[0] = NormalizeDouble((-1.0 * gd_232) * gd_360, Digits);
   gda_476[0] = NormalizeDouble(gd_240 * gd_360, Digits);
   gda_480[0] = gd_248;
   gia_484[0] = gi_256;
   return (1);
}

int Authentication() {
/*
   gi_496 = GPSForexRobot(gda_508, EMail, CBReceipt, IsDemo(), AccountNumber());
   if (gi_496 == -1) {
      gs_520 = "Authentication Failed [Invalid Internet Connection]\n[Trades are not available]";
      gs_528 = "Authentication Failed: [Invalid Internet Connection] [Trades are not available]";
      return (-1);
   }
   if (gi_496 == -2) {
      gs_520 = "Authentication Failed [Invalid Internet Connection]\n[Trades are not available]";
      gs_528 = "Authentication Failed: [Invalid Internet Connection] [Trades are not available]";
      return (-2);
   }
   if (gi_496 == -3) {
      gs_520 = "Authentication Failed [Wrong E-Mail or CBReceipt]\n[Trades are not available]";
      gs_528 = "Authentication Failed: [Wrong E-Mail or CBReceipt] [Trades are not available]";
      return (-2);
   }
   if (gi_496 == -4) {
      gs_520 = "Authentication Failed [Invalid Real Money Account Number]\n[Trades are not available]";
      gs_528 = "Authentication Failed: [Invalid Real Money Account Number] [Trades are not available]";
      return (-2);
   }
   if (*/gi_496 = 1;/*) {*/
      SetVariables();
      gs_520 = "Authenticated [Trades are available]\nThank you for joining the GPS Robot Team!";
      gs_528 = "Authenticatd: [Trades are available]";
      return (1);
/*      
   }
   return (0);
*/
}

int Rand(int ai_0) {
   MathSrand(TimeLocal());
   return (MathRand() % ai_0);
}