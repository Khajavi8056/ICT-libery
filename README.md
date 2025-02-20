# ICT-libery

### 1. نصب و آماده‌سازی کتابخانه
#### گام 1: ذخیره فایل
- **فایل کتابخانه**: کد ارائه‌شده را در یک فایل با نام `ict.mqh` ذخیره کنید.
- **محل ذخیره**: فایل را در پوشه `Include` در دایرکتوری MetaTrader خود قرار دهید:
  - برای MQL4: `<MetaTrader 4 Directory>\MQL4\Include`
  - برای MQL5: `<MetaTrader 5 Directory>\MQL5\Include`

#### گام 2: وارد کردن کتابخانه در کد
- در بالای اسکریپت، اندیکاتور یا اکسپرت خود، کتابخانه را با دستور زیر وارد کنید:
  ```cpp
  #include <ict.mqh>
  ```
- این کار به شما امکان دسترسی به تمام ساختارها و توابع کتابخانه را می‌دهد.

#### گام 3: آماده‌سازی داده‌های ورودی
- برای استفاده از توابع، باید آرایه‌های قیمتی و زمانی را از MetaTrader تهیه کنید:
  - `highPrices[]`: آرایه قیمت‌های بالا (High)
  - `lowPrices[]`: آرایه قیمت‌های پایین (Low)
  - `closePrices[]`: آرایه قیمت‌های بسته شدن (Close)
  - `openPrices[]`: آرایه قیمت‌های باز شدن (Open)
  - `volumeData[]`: آرایه حجم معاملات (Volume)
  - `timeStamps[]`: آرایه زمان کندل‌ها (Time)
- مثال آماده‌سازی داده‌ها در MQL:
  ```cpp
  double highPrices[];
  double lowPrices[];
  double closePrices[];
  double openPrices[];
  datetime timeStamps[];
  long volumeData[];

  ArraySetAsSeries(highPrices, true);
  ArraySetAsSeries(lowPrices, true);
  ArraySetAsSeries(closePrices, true);
  ArraySetAsSeries(openPrices, true);
  ArraySetAsSeries(timeStamps, true);
  ArraySetAsSeries(volumeData, true);

  CopyHigh(_Symbol, PERIOD_CURRENT, 0, 100, highPrices);
  CopyLow(_Symbol, PERIOD_CURRENT, 0, 100, lowPrices);
  CopyClose(_Symbol, PERIOD_CURRENT, 0, 100, closePrices);
  CopyOpen(_Symbol, PERIOD_CURRENT, 0, 100, openPrices);
  CopyTime(_Symbol, PERIOD_CURRENT, 0, 100, timeStamps);
  CopyTickVolume(_Symbol, PERIOD_CURRENT, 0, 100, volumeData);
  ```

---

### 2. نحوه استفاده از توابع
کتابخانه شامل توابع متعددی است که هر یک برای تشخیص یا محاسبه یک مفهوم خاص ICT طراحی شده‌اند. در زیر، نحوه استفاده از هر تابع با توضیحات و مثال ارائه شده است.

#### تابع `DetectOrderBlock`
- **کاربرد**: تشخیص نواحی عرضه و تقاضا (Order Block).
- **ورودی‌ها**: اندیس فعلی، دوره نگاه به عقب، آرایه‌های قیمتی و زمانی، پیام خطا.
- **خروجی**: ساختار `OrderBlock`.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     OrderBlock ob = DetectOrderBlock(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                     closePrices, openPrices, timeStamps, volumeData, errorMessage);
     if (ob.isDetected) {
        Print("Order Block تشخیص داده شد: High=", ob.highPrice, ", Low=", ob.lowPrice, 
              ", Bullish=", ob.isBullish);
     } else if (errorMessage != "") {
        Print("خطا: ", errorMessage);
     }
  }
  ```

#### تابع `DetectFVG`
- **کاربرد**: تشخیص گپ‌های ارزش منصفانه (Fair Value Gap).
- **ورودی‌ها**: اندیس فعلی، آرایه‌های قیمتی و زمانی، پیام خطا.
- **خروجی**: ساختار `FairValueGap`.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     FairValueGap fvg = DetectFVG(1, highPrices, lowPrices, closePrices, timeStamps, errorMessage);
     if (fvg.isDetected) {
        Print("FVG تشخیص داده شد: Top=", fvg.topLevel, ", Bottom=", fvg.bottomLevel, 
              ", Filled=", fvg.isGapFilled);
     }
  }
  ```

#### تابع `DetectBOS`
- **کاربرد**: تشخیص شکست ساختار (Break of Structure).
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     BreakOfStructureInfo bos = DetectBOS(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                         closePrices, timeStamps, errorMessage);
     if (bos.isDetected) {
        Print("BOS تشخیص داده شد: Bullish=", bos.isBullishBreak, ", Level=", bos.breakLevelPrice);
     }
  }
  ```

#### تابع `DetectCHoCH`
- **کاربرد**: تشخیص تغییر رفتار بازار (Change of Character).
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     ChangeOfCharacterInfo choch = DetectCHoCH(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                              closePrices, timeStamps, errorMessage);
     if (choch.isDetected) {
        Print("CHoCH تشخیص داده شد: From Bullish=", choch.isFromBullish, ", Trigger=", choch.triggerLevelPrice);
     }
  }
  ```

#### تابع `DetectLiquidityZone`
- **کاربرد**: تشخیص نواحی نقدینگی.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     LiquidityZone lz = DetectLiquidityZone(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                           volumeData, timeStamps, errorMessage);
     if (lz.highBoundary != 0) {
        Print("Liquidity Zone: High=", lz.highBoundary, ", Low=", lz.lowBoundary, 
              ", Touches=", lz.numberOfTouches);
     }
  }
  ```

#### تابع `DetectMarketStructure`
- **کاربرد**: تشخیص ساختار بازار (صعودی، نزولی، خنثی).
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     ENUM_MARKET_STRUCTURE ms = DetectMarketStructure(1, DEFAULT_LOOKBACK_PERIOD, highPrices, 
                                                     lowPrices, closePrices, errorMessage);
     Print("ساختار بازار: ", EnumToString(ms));
  }
  ```

#### تابع `IsInSession`
- **کاربرد**: بررسی حضور زمان فعلی در یک سشن معاملاتی.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     if (IsInSession(TimeCurrent(), TRADING_SESSION_LONDON, errorMessage)) {
        Print("در سشن لندن هستیم");
     } else {
        Print("خارج از سشن لندن یا خطا: ", errorMessage);
     }
  }
  ```

#### تابع `DetectImbalanceZone`
- **کاربرد**: تشخیص نواحی عدم تعادل قیمتی.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     ImbalanceZone iz = DetectImbalanceZone(1, highPrices, lowPrices, timeStamps, errorMessage);
     if (iz.isDetected) {
        Print("Imbalance Zone: Top=", iz.topBoundary, ", Bottom=", iz.bottomBoundary);
     }
  }
  ```

#### تابع `DetectSwingPoints`
- **کاربرد**: تشخیص نقاط چرخش بالا و پایین.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     SwingPoint sp = DetectSwingPoints(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                      timeStamps, errorMessage);
     if (sp.isValidPoint) {
        Print("Swing Point: High=", sp.swingHighPrice, ", Low=", sp.swingLowPrice);
     }
  }
  ```

#### تابع `IsKillZone`
- **کاربرد**: بررسی حضور در Kill Zone (زمان پرنقدینگی).
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     if (IsKillZone(TimeCurrent(), TRADING_SESSION_NEWYORK, errorMessage)) {
        Print("در Kill Zone نیویورک هستیم");
     }
  }
  ```

#### تابع `CalculateOTE`
- **کاربرد**: محاسبه سطوح ورود بهینه با فیبوناچی.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     OptimalTradeEntryInfo ote = CalculateOTE(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, errorMessage);
     if (ote.isValidCalculation) {
        Print("OTE: 61.8%=", ote.fibonacci618Level, ", 78.6%=", ote.fibonacci786Level);
     }
  }
  ```

#### تابع `DetectMitigationBlock`
- **کاربرد**: تشخیص Order Block تعدیل‌شده.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     OrderBlock mb = DetectMitigationBlock(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                          closePrices, timeStamps, volumeData, errorMessage);
     if (mb.isMitigated) {
        Print("Mitigation Block: High=", mb.highPrice, ", Low=", mb.lowPrice);
     }
  }
  ```

#### تابع `DetectPowerOfThree`
- **کاربرد**: تشخیص الگوی Power of Three.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     PowerOfThreeInfo po3 = DetectPowerOfThree(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                              closePrices, timeStamps, errorMessage);
     if (po3.isDetected) {
        Print("PO3: Manipulation=", po3.manipulationLevel, ", Distribution=", po3.distributionLevel);
     }
  }
  ```

#### تابع `DetectJudasSwing`
- **کاربرد**: تشخیص حرکات فریبنده Judas Swing.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     JudasSwingInfo js = DetectJudasSwing(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                         closePrices, timeStamps, errorMessage);
     if (js.isDetected) {
        Print("Judas Swing: Level=", js.swingLevel, ", Bullish=", js.isBullishSwing);
     }
  }
  ```

#### تابع `DetectDisplacement`
- **کاربرد**: تشخیص حرکات ناگهانی قیمت.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     DisplacementInfo disp = DetectDisplacement(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                               closePrices, timeStamps, errorMessage);
     if (disp.isDetected) {
        Print("Displacement: Size=", disp.moveSizeInPips, ", Start=", disp.startPrice);
     }
  }
  ```

#### تابع `AnalyzeMultiTimeframe`
- **کاربرد**: تحلیل هم‌راستایی تایم‌فریم‌ها.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     MultiTimeframeAnalysisInfo mtf = AnalyzeMultiTimeframe(1, DEFAULT_LOOKBACK_PERIOD, 
                                                           highPrices, lowPrices, closePrices, timeStamps, 
                                                           higherHighPrices, higherLowPrices, higherClosePrices, 
                                                           higherTimeStamps, higherVolumeData, errorMessage);
     if (mtf.isAligned) {
        Print("تایم‌فریم‌ها هم‌راستا هستند: ", EnumToString(mtf.higherTimeframeStructure));
     }
  }
  ```

#### تابع `CalculateRiskManagement`
- **کاربرد**: محاسبه مدیریت ریسک با استاپ‌لاس پویا.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     RiskManagementInfo rm = CalculateRiskManagement(1.2000, 1.1950, 1.2100, 10000, 1.0, DEFAULT_ATR_PERIOD, 
                                                    highPrices, lowPrices, closePrices, errorMessage);
     if (rm.isValid) {
        Print("Risk Management: Position Size=", rm.positionSize, ", Dynamic SL=", rm.dynamicStopLoss);
     }
  }
  ```

#### تابع `DetectStopHunt`
- **کاربرد**: تشخیص شکار استاپ‌ها.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     StopHuntInfo sh = DetectStopHunt(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                     closePrices, timeStamps, errorMessage);
     if (sh.isDetected) {
        Print("Stop Hunt: Level=", sh.huntLevel, ", Bullish=", sh.isBullishHunt);
     }
  }
  ```

#### تابع `DetectLiquidityGrab`
- **کاربرد**: تشخیص جمع‌آوری نقدینگی.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     LiquidityGrabInfo lg = DetectLiquidityGrab(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                               closePrices, timeStamps, errorMessage);
     if (lg.isDetected) {
        Print("Liquidity Grab: Level=", lg.grabLevel, ", Bullish=", lg.isBullishGrab);
     }
  }
  ```

#### تابع `DetectTurtleSoup`
- **کاربرد**: تشخیص الگوی Turtle Soup.
- **مثال**:
  ```cpp
  void OnTick() {
     string errorMessage;
     TurtleSoupInfo ts = DetectTurtleSoup(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                         closePrices, timeStamps, errorMessage);
     if (ts.isDetected) {
        Print("Turtle Soup: Fakeout=", ts.fakeoutLevel, ", Bullish=", ts.isBullishFakeout);
     }
  }
  ```

---

### 3. نکات مهم در استفاده
- **اندیس فعلی**: معمولاً از `1` شروع کنید تا کندل فعلی و قبلی بررسی شوند.
- **پیام خطا**: همیشه `errorMessage` را چک کنید تا از مشکلات احتمالی (مثل کمبود داده) مطلع شوید.
- **دوره نگاه به عقب**: مقدار `DEFAULT_LOOKBACK_PERIOD` (20) قابل تنظیم است؛ بسته به استراتژی خود می‌توانید آن را تغییر دهید.
- **داده‌های تایم‌فریم بالاتر**: برای `AnalyzeMultiTimeframe`، داده‌های تایم‌فریم بالاتر (مثل H4) را جداگانه بارگذاری کنید.

---

### 4. مثال جامع (اکسپرت ساده)
```cpp
#include <ict.mqh>

double highPrices[], lowPrices[], closePrices[], openPrices[], higherHighPrices[], higherLowPrices[], higherClosePrices[];
datetime timeStamps[], higherTimeStamps[];
long volumeData[], higherVolumeData[];

void OnInit() {
   ArraySetAsSeries(highPrices, true);
   ArraySetAsSeries(lowPrices, true);
   ArraySetAsSeries(closePrices, true);
   ArraySetAsSeries(openPrices, true);
   ArraySetAsSeries(timeStamps, true);
   ArraySetAsSeries(volumeData, true);
   ArraySetAsSeries(higherHighPrices, true);
   ArraySetAsSeries(higherLowPrices, true);
   ArraySetAsSeries(higherClosePrices, true);
   ArraySetAsSeries(higherTimeStamps, true);
   ArraySetAsSeries(higherVolumeData, true);
}

void OnTick() {
   CopyHigh(_Symbol, PERIOD_M15, 0, 100, highPrices);
   CopyLow(_Symbol, PERIOD_M15, 0, 100, lowPrices);
   CopyClose(_Symbol, PERIOD_M15, 0, 100, closePrices);
   CopyOpen(_Symbol, PERIOD_M15, 0, 100, openPrices);
   CopyTime(_Symbol, PERIOD_M15, 0, 100, timeStamps);
   CopyTickVolume(_Symbol, PERIOD_M15, 0, 100, volumeData);

   CopyHigh(_Symbol, PERIOD_H4, 0, 100, higherHighPrices);
   CopyLow(_Symbol, PERIOD_H4, 0, 100, higherLowPrices);
   CopyClose(_Symbol, PERIOD_H4, 0, 100, higherClosePrices);
   CopyTime(_Symbol, PERIOD_H4, 0, 100, higherTimeStamps);
   CopyTickVolume(_Symbol, PERIOD_H4, 0, 100, higherVolumeData);

   string errorMessage;
   OrderBlock ob = DetectOrderBlock(1, DEFAULT_LOOKBACK_PERIOD, highPrices, lowPrices, 
                                   closePrices, openPrices, timeStamps, volumeData, errorMessage);
   if (ob.isDetected) {
      Print("Order Block: High=", ob.highPrice, ", Low=", ob.lowPrice);
   }

   MultiTimeframeAnalysisInfo mtf = AnalyzeMultiTimeframe(1, DEFAULT_LOOKBACK_PERIOD, 
                                                         highPrices, lowPrices, closePrices, timeStamps, 
                                                         higherHighPrices, higherLowPrices, higherClosePrices, 
                                                         higherTimeStamps, higherVolumeData, errorMessage);
   if (mtf.isAligned) {
      Print("هم‌راستایی تایم‌فریم‌ها: ", EnumToString(mtf.higherTimeframeStructure));
   }
}
```

---

### 5. توصیه‌ها
- **تست در استراتژی تستر**: قبل از استفاده واقعی، توابع را در تستر MetaTrader آزمایش کنید.
- **تنظیم پارامترها**: ثابت‌هایی مثل `MINIMUM_PIP_RANGE` یا `DISPLACEMENT_THRESHOLD` را بر اساس جفت‌ارز و تایم‌فریم تنظیم کنید.
- **مدیریت خطا**: همیشه پیام‌های خطا را چاپ کنید تا مشکلات احتمالی را شناسایی کنید.

این کتابخانه اکنون آماده استفاده است و تمام مفاهیم ICT را به‌صورت جامع پوشش می‌دهد. 
