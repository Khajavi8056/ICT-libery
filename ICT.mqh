#ifndef ICT_LIBRARY_ADVANCED_MQH
#define ICT_LIBRARY_ADVANCED_MQH

//+------------------------------------------------------------------+
//| تنظیمات پیش‌فرض و ثابت‌ها                                        |
//+------------------------------------------------------------------+
#define LIBRARY_VERSION "1.5.0"                  // نسخه کتابخانه برای پیگیری به‌روزرسانی‌ها
#define DEFAULT_LOOKBACK_PERIOD 20               // تعداد کندل‌های پیش‌فرض برای نگاه به عقب در تحلیل
#define MINIMUM_VOLUME_THRESHOLD 10              // حداقل حجم مورد نیاز برای اعتبارسنجی الگوها
#define MINIMUM_PIP_RANGE 20                     // حداقل دامنه قیمتی به پیپ برای تأیید ساختار بازار
#define DEFAULT_FIBONACCI_LEVEL_618 0.618        // سطح پیش‌فرض فیبوناچی 61.8% برای ورود بهینه
#define DEFAULT_FIBONACCI_LEVEL_786 0.786        // سطح پیش‌فرض فیبوناچی 78.6% برای ورود بهینه
#define DEFAULT_FIBONACCI_LEVEL_50 0.50          // سطح پیش‌فرض فیبوناچی 50% برای ورود بهینه
#define DISPLACEMENT_THRESHOLD 50                // حداقل حرکت قیمتی در پیپ برای تشخیص Displacement
#define MINIMUM_ACCOUNT_RISK_PERCENTAGE 1.0      // درصد حداقل ریسک پیش‌فرض حساب برای محاسبه حجم معامله (1%)
#define DEFAULT_ATR_PERIOD 14                    // دوره پیش‌فرض برای محاسبه ATR در مدیریت ریسک پویا
#define TURTLE_SOUP_THRESHOLD 10                 // حداقل پیپ برای تشخیص فریب در الگوی Turtle Soup

//+------------------------------------------------------------------+
//| تعریف نوع داده برای ساختار بازار                                |
//+------------------------------------------------------------------+
enum ENUM_MARKET_STRUCTURE {
   MARKET_STRUCTURE_BULLISH,       // ساختار صعودی بازار
   MARKET_STRUCTURE_BEARISH,       // ساختار نزولی بازار
   MARKET_STRUCTURE_CONSOLIDATION  // ساختار خنثی (تثبیت) بازار
};

//+------------------------------------------------------------------+
//| تعریف نوع داده برای سشن‌های معاملاتی                            |
//+------------------------------------------------------------------+
enum ENUM_TRADING_SESSION {
   TRADING_SESSION_ASIA,      // سشن آسیا: 00:00 - 08:00 UTC
   TRADING_SESSION_LONDON,    // سشن لندن: 08:00 - 16:00 UTC
   TRADING_SESSION_NEWYORK,   // سشن نیویورک: 13:00 - 21:00 UTC
   TRADING_SESSION_OVERLAP    // همپوشانی لندن-نیویورک: 13:00 - 16:00 UTC
};

//+------------------------------------------------------------------+
//| ساختارهای پیشرفته برای ذخیره اطلاعات بازار                     |
//+------------------------------------------------------------------+
struct OrderBlock {
   double highPrice;           // بالاترین قیمت ناحیه Order Block
   double lowPrice;            // پایین‌ترین قیمت ناحیه Order Block
   datetime startTime;         // زمان شروع ناحیه Order Block
   datetime endTime;           // زمان پایان ناحیه Order Block
   bool isBullish;             // آیا ناحیه صعودی است؟ (true) یا نزولی (false)
   double averageVolume;       // میانگین حجم معاملات در ناحیه
   double strengthIndicator;   // شاخص قدرت ناحیه بر اساس حجم و دامنه قیمتی
   bool isMitigated;           // آیا ناحیه تعدیل شده است؟ (true/false)
   int candleCount;            // تعداد کندل‌های موجود در ناحیه
};

struct FairValueGap {
   double topLevel;            // سطح بالای گپ ارزش منصفانه
   double bottomLevel;         // سطح پایین گپ ارزش منصفانه
   datetime occurrenceTime;    // زمان وقوع گپ
   bool isBullishGap;          // آیا گپ صعودی است؟ (true) یا نزولی (false)
   double gapSizeInPips;       // اندازه گپ به پیپ
   bool isGapFilled;           // آیا گپ پر شده است؟ (true/false)
};

struct LiquidityZone {
   double highBoundary;        // مرز بالای ناحیه نقدینگی
   double lowBoundary;         // مرز پایین ناحیه نقدینگی
   datetime identificationTime;// زمان شناسایی ناحیه نقدینگی
   double strengthMetric;      // معیار قدرت ناحیه بر اساس حجم و فعالیت سفارشات
   int numberOfTouches;        // تعداد برخوردها به ناحیه
};

struct BreakOfStructureInfo {
   bool isDetected;            // آیا شکست ساختار تشخیص داده شده است؟ (true/false)
   bool isBullishBreak;        // آیا شکست صعودی است؟ (true) یا نزولی (false)
   double breakLevelPrice;     // سطح قیمتی که ساختار در آن شکسته شده
   datetime breakTime;         // زمان وقوع شکست
};

struct ChangeOfCharacterInfo {
   bool isDetected;            // آیا تغییر رفتار تشخیص داده شده است؟ (true/false)
   bool isFromBullish;         // آیا تغییر از صعودی به نزولی است؟ (true) یا برعکس (false)
   double triggerLevelPrice;   // سطح قیمتی که تغییر را فعال کرده
   datetime changeTime;        // زمان وقوع تغییر
};

struct ImbalanceZone {
   bool isDetected;            // آیا ناحیه عدم تعادل تشخیص داده شده است؟ (true/false)
   double topBoundary;         // مرز بالای ناحیه عدم تعادل
   double bottomBoundary;      // مرز پایین ناحیه عدم تعادل
   datetime detectionTime;     // زمان شناسایی ناحیه
   double zoneSizeInPips;      // اندازه ناحیه به پیپ
};

struct SwingPoint {
   double swingHighPrice;      // قیمت نقطه چرخش بالا
   double swingLowPrice;       // قیمت نقطه چرخش پایین
   datetime occurrenceTime;    // زمان وقوع نقطه چرخش
   bool isValidPoint;          // آیا نقطه چرخش معتبر است؟ (true/false)
};

struct OptimalTradeEntryInfo {
   double fibonacci618Level;   // سطح فیبوناچی 61.8% برای ورود بهینه
   double fibonacci786Level;   // سطح فیبوناچی 78.6% برای ورود بهینه
   double fibonacci50Level;    // سطح فیبوناچی 50% برای ورود بهینه
   bool isValidCalculation;    // آیا محاسبات معتبر هستند؟ (true/false)
};

struct PowerOfThreeInfo {
   bool isDetected;            // آیا الگوی Power of Three تشخیص داده شده است؟ (true/false)
   double accumulationHigh;    // بالاترین قیمت فاز انباشت
   double accumulationLow;     // پایین‌ترین قیمت فاز انباشت
   double manipulationLevel;   // سطح قیمتی فاز دستکاری
   double distributionLevel;   // سطح قیمتی که توزیع آغاز می‌شود
   datetime startTime;         // زمان شروع الگو
   datetime endTime;           // زمان پایان الگو
};

struct JudasSwingInfo {
   bool isDetected;            // آیا Judas Swing تشخیص داده شده است؟ (true/false)
   double swingLevel;          // سطح قیمتی سوئینگ فریبنده
   datetime swingTime;         // زمان وقوع سوئینگ
   bool isBullishSwing;        // آیا سوئینگ صعودی است؟ (true) یا نزولی (false)
};

struct DisplacementInfo {
   bool isDetected;            // آیا Displacement تشخیص داده شده است؟ (true/false)
   double startPrice;          // قیمت شروع حرکت ناگهانی
   double endPrice;            // قیمت پایان حرکت ناگهانی
   double moveSizeInPips;      // اندازه حرکت به پیپ
   datetime startTime;         // زمان شروع حرکت
   datetime endTime;           // زمان پایان حرکت
};

struct RiskManagementInfo {
   double positionSize;        // حجم معامله محاسبه‌شده به لات
   double riskAmount;          // مقدار ریسک به واحد ارزی حساب
   double rewardAmount;        // مقدار سود به واحد ارزی حساب
   double riskRewardRatio;     // نسبت ریسک به سود
   double dynamicStopLoss;     // استاپ‌لاس پویا بر اساس ATR
   bool isValid;               // آیا محاسبات معتبر هستند؟ (true/false)
};

struct StopHuntInfo {
   bool isDetected;            // آیا Stop Hunt تشخیص داده شده است؟ (true/false)
   double huntLevel;           // سطح قیمتی که استاپ‌ها شکار شده‌اند
   datetime huntTime;          // زمان وقوع شکار استاپ‌ها
   bool isBullishHunt;         // آیا شکار صعودی است؟ (true) یا نزولی (false)
};

struct LiquidityGrabInfo {
   bool isDetected;            // آیا Liquidity Grab تشخیص داده شده است؟ (true/false)
   double grabLevel;           // سطح قیمتی که نقدینگی جمع‌آوری شده
   datetime grabTime;          // زمان وقوع جمع‌آوری نقدینگی
   bool isBullishGrab;         // آیا جمع‌آوری صعودی است؟ (true) یا نزولی (false)
};

struct TurtleSoupInfo {
   bool isDetected;            // آیا الگوی Turtle Soup تشخیص داده شده است؟ (true/false)
   double fakeoutLevel;        // سطح قیمتی فریب
   datetime fakeoutTime;       // زمان وقوع فریب
   bool isBullishFakeout;      // آیا فریب صعودی است؟ (true) یا نزولی (false)
};

struct MultiTimeframeAnalysisInfo {
   ENUM_MARKET_STRUCTURE higherTimeframeStructure; // ساختار بازار در تایم‌فریم بالاتر
   OrderBlock higherTimeframeOrderBlock;           // Order Block در تایم‌فریم بالاتر
   LiquidityZone higherTimeframeLiquidityZone;     // ناحیه نقدینگی در تایم‌فریم بالاتر
   bool isAligned;                                 // آیا تایم‌فریم فعلی با تایم‌فریم بالاتر هم‌راستا است؟ (true/false)
};

//+------------------------------------------------------------------+
//| توابع کمکی برای محاسبات پایه                                    |
//+------------------------------------------------------------------+
double FindHighestHigh(int startIndex, int candleCount, const double &highPrices[], string &errorMessage) {
   if (startIndex < 0 || startIndex + candleCount > ArraySize(highPrices)) {
      errorMessage = "بازه مشخص‌شده برای یافتن بالاترین قیمت نامعتبر است";
      return 0;
   }
   int maximumIndex = ArrayMaximum(highPrices, startIndex, candleCount);
   return (maximumIndex >= 0) ? highPrices[maximumIndex] : 0;
}

double FindLowestLow(int startIndex, int candleCount, const double &lowPrices[], string &errorMessage) {
   if (startIndex < 0 || startIndex + candleCount > ArraySize(lowPrices)) {
      errorMessage = "بازه مشخص‌شده برای یافتن پایین‌ترین قیمت نامعتبر است";
      return 0;
   }
   int minimumIndex = ArrayMinimum(lowPrices, startIndex, candleCount);
   return (minimumIndex >= 0) ? lowPrices[minimumIndex] : 0;
}

double CalculateAverageVolume(int startIndex, int candleCount, const long &volumeData[], string &errorMessage) {
   if (startIndex < 0 || startIndex + candleCount > ArraySize(volumeData)) {
      errorMessage = "بازه مشخص‌شده برای محاسبه میانگین حجم نامعتبر است";
      return 0;
   }
   double totalVolume = 0;
   for (int i = startIndex; i < startIndex + candleCount; i++) {
      totalVolume += (double)volumeData[i]; // تبدیل صریح از long به double
   }
   return (candleCount > 0) ? totalVolume / candleCount : 0;
}

double CalculatePipSize(double priceLevel1, double priceLevel2) {
   return MathAbs(priceLevel1 - priceLevel2) / Point();
}

double CalculateATR(int startIndex, int period, const double &highPrices[], const double &lowPrices[], 
                    const double &closePrices[], string &errorMessage) {
   if (startIndex < period || ArraySize(highPrices) <= startIndex) {
      errorMessage = "بازه مشخص‌شده برای محاسبه ATR نامعتبر است";
      return 0;
   }
   double sumTR = 0;
   for (int i = startIndex; i > startIndex - period; i--) {
      double highLow = highPrices[i] - lowPrices[i];
      double highClose = MathAbs(highPrices[i] - closePrices[i + 1]);
      double lowClose = MathAbs(lowPrices[i] - closePrices[i + 1]);
      double trueRange = MathMax(highLow, MathMax(highClose, lowClose));
      sumTR += trueRange;
   }
   return sumTR / period;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Order Block                                          |
//+------------------------------------------------------------------+
OrderBlock DetectOrderBlock(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                           const double &lowPrices[], const double &closePrices[], 
                           const double &openPrices[], const datetime &timeStamps[], 
                           const long &volumeData[], string &errorMessage) {
   OrderBlock orderBlock = {0, 0, 0, 0, false, 0, 0, false, 0};
   
   if (currentIndex < lookbackPeriod + 1 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده یا دوره نگاه به عقب ناکافی برای تشخیص Order Block";
      return orderBlock;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);
   if (previousHigh == 0 || previousLow == 0) {
      return orderBlock;
   }

   orderBlock.averageVolume = CalculateAverageVolume(currentIndex - lookbackPeriod, lookbackPeriod, volumeData, errorMessage);
   orderBlock.candleCount = lookbackPeriod;

   if (closePrices[currentIndex] > previousHigh && closePrices[currentIndex - 1] < previousHigh && 
       orderBlock.averageVolume >= MINIMUM_VOLUME_THRESHOLD) {
      orderBlock.highPrice = highPrices[currentIndex - 1];
      orderBlock.lowPrice = lowPrices[currentIndex - 1];
      orderBlock.startTime = timeStamps[currentIndex - 1];
      orderBlock.endTime = timeStamps[currentIndex];
      orderBlock.isBullish = true;
      orderBlock.strengthIndicator = orderBlock.averageVolume * (highPrices[currentIndex - 1] - lowPrices[currentIndex - 1]) / Point();
   }
   else if (closePrices[currentIndex] < previousLow && closePrices[currentIndex - 1] > previousLow && 
            orderBlock.averageVolume >= MINIMUM_VOLUME_THRESHOLD) {
      orderBlock.highPrice = highPrices[currentIndex - 1];
      orderBlock.lowPrice = lowPrices[currentIndex - 1];
      orderBlock.startTime = timeStamps[currentIndex - 1];
      orderBlock.endTime = timeStamps[currentIndex];
      orderBlock.isBullish = false;
      orderBlock.strengthIndicator = orderBlock.averageVolume * (highPrices[currentIndex - 1] - lowPrices[currentIndex - 1]) / Point();
   }

   return orderBlock;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Fair Value Gap                                       |
//+------------------------------------------------------------------+
FairValueGap DetectFVG(int currentIndex, const double &highPrices[], const double &lowPrices[], 
                      const double &closePrices[], const datetime &timeStamps[], string &errorMessage) {
   FairValueGap fairValueGap = {0, 0, 0, false, 0, false};
   
   if (currentIndex < 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Fair Value Gap";
      return fairValueGap;
   }

   double highPrevious2 = highPrices[currentIndex - 2];
   double lowPrevious1 = lowPrices[currentIndex - 1];
   double highPrevious1 = highPrices[currentIndex - 1];
   double lowCurrent = lowPrices[currentIndex];
   double highCurrent = highPrices[currentIndex];

   if (highPrevious2 < lowPrevious1 && lowCurrent > highPrevious1) {
      fairValueGap.topLevel = lowPrevious1;
      fairValueGap.bottomLevel = highPrevious2;
      fairValueGap.occurrenceTime = timeStamps[currentIndex];
      fairValueGap.isBullishGap = true;
      fairValueGap.gapSizeInPips = CalculatePipSize(fairValueGap.topLevel, fairValueGap.bottomLevel);
   }
   else if (lowPrices[currentIndex - 2] > highPrevious1 && highCurrent < lowPrevious1) {
      fairValueGap.topLevel = lowPrices[currentIndex - 2];
      fairValueGap.bottomLevel = highPrevious1;
      fairValueGap.occurrenceTime = timeStamps[currentIndex];
      fairValueGap.isBullishGap = false;
      fairValueGap.gapSizeInPips = CalculatePipSize(fairValueGap.topLevel, fairValueGap.bottomLevel);
   }

   if (fairValueGap.topLevel != 0 && currentIndex + 1 < ArraySize(closePrices)) {
      double nextLow = lowPrices[currentIndex + 1];
      double nextHigh = highPrices[currentIndex + 1];
      fairValueGap.isGapFilled = (nextLow <= fairValueGap.topLevel && nextHigh >= fairValueGap.bottomLevel);
   }

   return fairValueGap;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Break of Structure                                   |
//+------------------------------------------------------------------+
BreakOfStructureInfo DetectBOS(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                              const double &lowPrices[], const double &closePrices[], 
                              const datetime &timeStamps[], string &errorMessage) {
   BreakOfStructureInfo breakOfStructure = {false, false, 0, 0};
   
   if (currentIndex < lookbackPeriod || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Break of Structure";
      return breakOfStructure;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (closePrices[currentIndex] > previousHigh) {
      breakOfStructure.isDetected = true;
      breakOfStructure.isBullishBreak = true;
      breakOfStructure.breakLevelPrice = previousHigh;
      breakOfStructure.breakTime = timeStamps[currentIndex];
   }
   else if (closePrices[currentIndex] < previousLow) {
      breakOfStructure.isDetected = true;
      breakOfStructure.isBullishBreak = false;
      breakOfStructure.breakLevelPrice = previousLow;
      breakOfStructure.breakTime = timeStamps[currentIndex];
   }

   return breakOfStructure;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Change of Character                                  |
//+------------------------------------------------------------------+
ChangeOfCharacterInfo DetectCHoCH(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                 const double &lowPrices[], const double &closePrices[], 
                                 const datetime &timeStamps[], string &errorMessage) {
   ChangeOfCharacterInfo changeOfCharacter = {false, false, 0, 0};
   
   if (currentIndex < lookbackPeriod + 1 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Change of Character";
      return changeOfCharacter;
   }

   double previousHigh1 = FindHighestHigh(currentIndex - lookbackPeriod - 1, lookbackPeriod, highPrices, errorMessage);
   double previousLow1 = FindLowestLow(currentIndex - lookbackPeriod - 1, lookbackPeriod, lowPrices, errorMessage);
   double previousHigh2 = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow2 = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   bool wasBullishTrend = closePrices[currentIndex - 1] > previousHigh2 && previousHigh2 > previousHigh1;
   bool wasBearishTrend = closePrices[currentIndex - 1] < previousLow2 && previousLow2 < previousLow1;

   if (wasBullishTrend && closePrices[currentIndex] < previousLow2) {
      changeOfCharacter.isDetected = true;
      changeOfCharacter.isFromBullish = true;
      changeOfCharacter.triggerLevelPrice = previousLow2;
      changeOfCharacter.changeTime = timeStamps[currentIndex];
   }
   else if (wasBearishTrend && closePrices[currentIndex] > previousHigh2) {
      changeOfCharacter.isDetected = true;
      changeOfCharacter.isFromBullish = false;
      changeOfCharacter.triggerLevelPrice = previousHigh2;
      changeOfCharacter.changeTime = timeStamps[currentIndex];
   }

   return changeOfCharacter;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Liquidity Zone                                       |
//+------------------------------------------------------------------+
LiquidityZone DetectLiquidityZone(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                 const double &lowPrices[], const long &volumeData[], 
                                 const datetime &timeStamps[], string &errorMessage) {
   LiquidityZone liquidityZone = {0, 0, 0, 0, 0};
   
   if (currentIndex < lookbackPeriod || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Liquidity Zone";
      return liquidityZone;
   }

   liquidityZone.highBoundary = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   liquidityZone.lowBoundary = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);
   liquidityZone.identificationTime = timeStamps[currentIndex];
   liquidityZone.strengthMetric = CalculateAverageVolume(currentIndex - lookbackPeriod, lookbackPeriod, volumeData, errorMessage);
   
   for (int i = currentIndex - lookbackPeriod; i < currentIndex; i++) {
      if (highPrices[i] >= liquidityZone.highBoundary || lowPrices[i] <= liquidityZone.lowBoundary) {
         liquidityZone.numberOfTouches++;
      }
   }

   return liquidityZone;
}

//+------------------------------------------------------------------+
//| تابع تشخیص ساختار بازار (Market Structure)                     |
//+------------------------------------------------------------------+
ENUM_MARKET_STRUCTURE DetectMarketStructure(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                           const double &lowPrices[], const double &closePrices[], 
                                           string &errorMessage) {
   if (currentIndex < lookbackPeriod + 1 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص ساختار بازار";
      return MARKET_STRUCTURE_CONSOLIDATION;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);
   double priceRangeInPips = (previousHigh - previousLow) / Point();

   if (closePrices[currentIndex] > previousHigh && closePrices[currentIndex - 1] > previousHigh && 
       priceRangeInPips > MINIMUM_PIP_RANGE) {
      return MARKET_STRUCTURE_BULLISH;
   }
   if (closePrices[currentIndex] < previousLow && closePrices[currentIndex - 1] < previousLow && 
       priceRangeInPips > MINIMUM_PIP_RANGE) {
      return MARKET_STRUCTURE_BEARISH;
   }
   return MARKET_STRUCTURE_CONSOLIDATION;
}

//+------------------------------------------------------------------+
//| تابع فیلتر سشن‌های معاملاتی                                     |
//+------------------------------------------------------------------+
bool IsInSession(datetime timeValue, ENUM_TRADING_SESSION sessionType, string &errorMessage) {
   MqlDateTime dateTimeStructure;
   if (!TimeToStruct(timeValue, dateTimeStructure)) {
      errorMessage = "تبدیل زمان به ساختار برای اعتبارسنجی سشن ناموفق بود";
      return false;
   }
   int hourOfDay = dateTimeStructure.hour;

   switch (sessionType) {
      case TRADING_SESSION_ASIA:
         return (hourOfDay >= 0 && hourOfDay < 8);
      case TRADING_SESSION_LONDON:
         return (hourOfDay >= 8 && hourOfDay < 16);
      case TRADING_SESSION_NEWYORK:
         return (hourOfDay >= 13 && hourOfDay < 21);
      case TRADING_SESSION_OVERLAP:
         return (hourOfDay >= 13 && hourOfDay < 16);
      default:
         errorMessage = "نوع سشن معاملاتی نامعتبر است";
         return false;
   }
}

//+------------------------------------------------------------------+
//| تابع تشخیص Imbalance Zone                                       |
//+------------------------------------------------------------------+
ImbalanceZone DetectImbalanceZone(int currentIndex, const double &highPrices[], 
                                 const double &lowPrices[], const datetime &timeStamps[], 
                                 string &errorMessage) {
   ImbalanceZone imbalanceZone = {false, 0, 0, 0, 0};
   
   if (currentIndex < 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Imbalance Zone";
      return imbalanceZone;
   }

   double priceGap = highPrices[currentIndex - 1] - lowPrices[currentIndex];
   if (priceGap > 0 && highPrices[currentIndex - 2] < lowPrices[currentIndex - 1]) {
      imbalanceZone.isDetected = true;
      imbalanceZone.topBoundary = highPrices[currentIndex - 1];
      imbalanceZone.bottomBoundary = lowPrices[currentIndex];
      imbalanceZone.detectionTime = timeStamps[currentIndex];
      imbalanceZone.zoneSizeInPips = CalculatePipSize(imbalanceZone.topBoundary, imbalanceZone.bottomBoundary);
   }

   return imbalanceZone;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Swing Points                                         |
//+------------------------------------------------------------------+
SwingPoint DetectSwingPoints(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                            const double &lowPrices[], const datetime &timeStamps[], 
                            string &errorMessage) {
   SwingPoint swingPoint = {EMPTY_VALUE, EMPTY_VALUE, 0, false};
   
   if (currentIndex < lookbackPeriod + 1 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Swing Points";
      return swingPoint;
   }

   double currentHighPrice = highPrices[currentIndex];
   double currentLowPrice = lowPrices[currentIndex];
   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (currentHighPrice > previousHigh && highPrices[currentIndex - 1] < currentHighPrice) {
      swingPoint.swingHighPrice = currentHighPrice;
      swingPoint.isValidPoint = true;
   }
   if (currentLowPrice < previousLow && lowPrices[currentIndex - 1] > currentLowPrice) {
      swingPoint.swingLowPrice = currentLowPrice;
      swingPoint.isValidPoint = true;
   }
   if (swingPoint.isValidPoint) {
      swingPoint.occurrenceTime = timeStamps[currentIndex];
   }

   return swingPoint;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Kill Zone                                            |
//+------------------------------------------------------------------+
bool IsKillZone(datetime timeValue, ENUM_TRADING_SESSION sessionType, string &errorMessage) {
   MqlDateTime dateTimeStructure;
   if (!TimeToStruct(timeValue, dateTimeStructure)) {
      errorMessage = "تبدیل زمان به ساختار برای تشخیص Kill Zone ناموفق بود";
      return false;
   }
   int hourOfDay = dateTimeStructure.hour;

   switch (sessionType) {
      case TRADING_SESSION_LONDON:
         return (hourOfDay == 8 || hourOfDay == 9);
      case TRADING_SESSION_NEWYORK:
         return (hourOfDay == 13 || hourOfDay == 14);
      case TRADING_SESSION_OVERLAP:
         return (hourOfDay >= 13 && hourOfDay < 16);
      default:
         return false;
   }
}

//+------------------------------------------------------------------+
//| تابع محاسبه Optimal Trade Entry                                 |
//+------------------------------------------------------------------+
OptimalTradeEntryInfo CalculateOTE(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                  const double &lowPrices[], string &errorMessage) {
   OptimalTradeEntryInfo optimalTradeEntry = {0, 0, 0, false};
   
   if (currentIndex < lookbackPeriod || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای محاسبه Optimal Trade Entry";
      return optimalTradeEntry;
   }

   double highestPriceLevel = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double lowestPriceLevel = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);
   double priceRange = highestPriceLevel - lowestPriceLevel;

   optimalTradeEntry.fibonacci618Level = lowestPriceLevel + priceRange * DEFAULT_FIBONACCI_LEVEL_618;
   optimalTradeEntry.fibonacci786Level = lowestPriceLevel + priceRange * DEFAULT_FIBONACCI_LEVEL_786;
   optimalTradeEntry.fibonacci50Level = lowestPriceLevel + priceRange * DEFAULT_FIBONACCI_LEVEL_50;
   optimalTradeEntry.isValidCalculation = (priceRange > 0);

   return optimalTradeEntry;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Mitigation Block                                     |
//+------------------------------------------------------------------+
OrderBlock DetectMitigationBlock(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                const double &lowPrices[], const double &closePrices[], 
                                const datetime &timeStamps[], const long &volumeData[], 
                                string &errorMessage) {
   OrderBlock mitigationBlock = DetectOrderBlock(currentIndex, lookbackPeriod, highPrices, lowPrices, 
                                                closePrices, highPrices, timeStamps, volumeData, errorMessage);
   
   if (mitigationBlock.highPrice != 0) {
      if (closePrices[currentIndex] >= mitigationBlock.lowPrice && 
          closePrices[currentIndex] <= mitigationBlock.highPrice) {
         mitigationBlock.isMitigated = true;
      }
   }
   
   return mitigationBlock;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Power of Three                                       |
//+------------------------------------------------------------------+
PowerOfThreeInfo DetectPowerOfThree(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                   const double &lowPrices[], const double &closePrices[], 
                                   const datetime &timeStamps[], string &errorMessage) {
   PowerOfThreeInfo powerOfThree = {false, 0, 0, 0, 0, 0, 0};
   
   if (currentIndex < lookbackPeriod + 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Power of Three";
      return powerOfThree;
   }

   double accumulationHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod / 2, highPrices, errorMessage);
   double accumulationLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod / 2, lowPrices, errorMessage);
   double rangeSize = CalculatePipSize(accumulationHigh, accumulationLow);

   int manipulationStart = currentIndex - lookbackPeriod / 2;
   double manipulationHigh = FindHighestHigh(manipulationStart, lookbackPeriod / 4, highPrices, errorMessage);
   double manipulationLow = FindLowestLow(manipulationStart, lookbackPeriod / 4, lowPrices, errorMessage);
   bool manipulationUp = manipulationHigh > accumulationHigh;
   bool manipulationDown = manipulationLow < accumulationLow;

   double distributionHigh = highPrices[currentIndex];
   double distributionLow = lowPrices[currentIndex];

   if (rangeSize < MINIMUM_PIP_RANGE && (manipulationUp || manipulationDown)) {
      if (manipulationUp && distributionLow < accumulationLow) {
         powerOfThree.isDetected = true;
         powerOfThree.accumulationHigh = accumulationHigh;
         powerOfThree.accumulationLow = accumulationLow;
         powerOfThree.manipulationLevel = manipulationHigh;
         powerOfThree.distributionLevel = distributionLow;
         powerOfThree.startTime = timeStamps[currentIndex - lookbackPeriod];
         powerOfThree.endTime = timeStamps[currentIndex];
      }
      else if (manipulationDown && distributionHigh > accumulationHigh) {
         powerOfThree.isDetected = true;
         powerOfThree.accumulationHigh = accumulationHigh;
         powerOfThree.accumulationLow = accumulationLow;
         powerOfThree.manipulationLevel = manipulationLow;
         powerOfThree.distributionLevel = distributionHigh;
         powerOfThree.startTime = timeStamps[currentIndex - lookbackPeriod];
         powerOfThree.endTime = timeStamps[currentIndex];
      }
   }

   return powerOfThree;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Judas Swing                                          |
//+------------------------------------------------------------------+
JudasSwingInfo DetectJudasSwing(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                               const double &lowPrices[], const double &closePrices[], 
                               const datetime &timeStamps[], string &errorMessage) {
   JudasSwingInfo judasSwing = {false, 0, 0, false};
   
   if (currentIndex < lookbackPeriod + 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Judas Swing";
      return judasSwing;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (highPrices[currentIndex - 1] > previousHigh && closePrices[currentIndex] < previousHigh) {
      judasSwing.isDetected = true;
      judasSwing.swingLevel = highPrices[currentIndex - 1];
      judasSwing.swingTime = timeStamps[currentIndex - 1];
      judasSwing.isBullishSwing = true;
   }
   else if (lowPrices[currentIndex - 1] < previousLow && closePrices[currentIndex] > previousLow) {
      judasSwing.isDetected = true;
      judasSwing.swingLevel = lowPrices[currentIndex - 1];
      judasSwing.swingTime = timeStamps[currentIndex - 1];
      judasSwing.isBullishSwing = false;
   }

   return judasSwing;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Displacement                                         |
//+------------------------------------------------------------------+
DisplacementInfo DetectDisplacement(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                   const double &lowPrices[], const double &closePrices[], 
                                   const datetime &timeStamps[], string &errorMessage) {
   DisplacementInfo displacement = {false, 0, 0, 0, 0, 0};
   
   if (currentIndex < 1 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Displacement";
      return displacement;
   }

   double startPrice = closePrices[currentIndex - 1];
   double endPrice = closePrices[currentIndex];
   double moveSizeInPips = CalculatePipSize(startPrice, endPrice);

   if (moveSizeInPips >= DISPLACEMENT_THRESHOLD) {
      displacement.isDetected = true;
      displacement.startPrice = startPrice;
      displacement.endPrice = endPrice;
      displacement.moveSizeInPips = moveSizeInPips;
      displacement.startTime = timeStamps[currentIndex - 1];
      displacement.endTime = timeStamps[currentIndex];
   }

   return displacement;
}

//+------------------------------------------------------------------+
//| تابع تحلیل چند تایم‌فریمی (Multi-Timeframe Analysis)           |
//+------------------------------------------------------------------+
MultiTimeframeAnalysisInfo AnalyzeMultiTimeframe(int currentIndex, int lookbackPeriod, 
                                                const double &currentHighPrices[], 
                                                const double &currentLowPrices[], 
                                                const double &currentClosePrices[], 
                                                const datetime &currentTimeStamps[], 
                                                const double &higherHighPrices[], 
                                                const double &higherLowPrices[], 
                                                const double &higherClosePrices[], 
                                                const datetime &higherTimeStamps[], 
                                                const long &higherVolumeData[], 
                                                string &errorMessage) {
   MultiTimeframeAnalysisInfo mtfAnalysis = {MARKET_STRUCTURE_CONSOLIDATION,
                                            {0, 0, 0, 0, false, 0, 0, false, 0}, 
                                            {0, 0, 0, 0, 0}, 
                                            false};
   
   if (currentIndex < lookbackPeriod + 1 || ArraySize(currentHighPrices) <= currentIndex || 
       ArraySize(higherHighPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تحلیل چند تایم‌فریمی";
      return mtfAnalysis;
   }

   mtfAnalysis.higherTimeframeStructure = DetectMarketStructure(currentIndex, lookbackPeriod, 
                                                               higherHighPrices, higherLowPrices, 
                                                               higherClosePrices, errorMessage);
   mtfAnalysis.higherTimeframeOrderBlock = DetectOrderBlock(currentIndex, lookbackPeriod, 
                                                           higherHighPrices, higherLowPrices, 
                                                           higherClosePrices, higherHighPrices, 
                                                           higherTimeStamps, higherVolumeData, errorMessage);
   mtfAnalysis.higherTimeframeLiquidityZone = DetectLiquidityZone(currentIndex, lookbackPeriod, 
                                                                 higherHighPrices, higherLowPrices, 
                                                                 higherVolumeData, higherTimeStamps, errorMessage);

   ENUM_MARKET_STRUCTURE currentStructure = DetectMarketStructure(currentIndex, lookbackPeriod, 
                                                                 currentHighPrices, currentLowPrices, 
                                                                 currentClosePrices, errorMessage);

   mtfAnalysis.isAligned = (mtfAnalysis.higherTimeframeStructure == currentStructure && 
                           mtfAnalysis.higherTimeframeStructure != MARKET_STRUCTURE_CONSOLIDATION);

   return mtfAnalysis;
}

//+------------------------------------------------------------------+
//| تابع پیشرفته مدیریت ریسک                                        |
//+------------------------------------------------------------------+
RiskManagementInfo CalculateRiskManagement(double entryPrice, double stopLossPrice, double takeProfitPrice, 
                                          double accountBalance, double riskPercentage, int atrPeriod, 
                                          const double &highPrices[], const double &lowPrices[], 
                                          const double &closePrices[], string &errorMessage) {
   RiskManagementInfo riskManagement = {0, 0, 0, 0, 0, false};
   
   if (entryPrice == 0 || stopLossPrice == 0 || takeProfitPrice == 0 || accountBalance <= 0 || riskPercentage <= 0) {
      errorMessage = "پارامترهای ورودی برای محاسبه مدیریت ریسک نامعتبر هستند";
      return riskManagement;
   }

   int currentIndex = ArraySize(highPrices) - 1;
   double atrValue = CalculateATR(currentIndex, atrPeriod, highPrices, lowPrices, closePrices, errorMessage);
   double dynamicStopLoss = entryPrice > stopLossPrice ? entryPrice - (2 * atrValue) : entryPrice + (2 * atrValue);

   double riskAmount = MathAbs(entryPrice - stopLossPrice);
   double rewardAmount = MathAbs(takeProfitPrice - entryPrice);
   double riskInAccountCurrency = (riskPercentage / 100.0) * accountBalance;
   double pipValue = riskInAccountCurrency / CalculatePipSize(entryPrice, stopLossPrice);
   double positionSize = pipValue / 10000;

   riskManagement.positionSize = positionSize;
   riskManagement.riskAmount = riskInAccountCurrency;
   riskManagement.rewardAmount = (rewardAmount / riskAmount) * riskInAccountCurrency;
   riskManagement.riskRewardRatio = (riskAmount > 0) ? rewardAmount / riskAmount : 0;
   riskManagement.dynamicStopLoss = dynamicStopLoss;
   riskManagement.isValid = (positionSize > 0 && riskManagement.riskRewardRatio > 0);

   return riskManagement;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Stop Hunt                                            |
//+------------------------------------------------------------------+
StopHuntInfo DetectStopHunt(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                           const double &lowPrices[], const double &closePrices[], 
                           const datetime &timeStamps[], string &errorMessage) {
   StopHuntInfo stopHunt = {false, 0, 0, false};
   
   if (currentIndex < lookbackPeriod + 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Stop Hunt";
      return stopHunt;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (highPrices[currentIndex - 1] > previousHigh && closePrices[currentIndex] < previousHigh) {
      stopHunt.isDetected = true;
      stopHunt.huntLevel = highPrices[currentIndex - 1];
      stopHunt.huntTime = timeStamps[currentIndex - 1];
      stopHunt.isBullishHunt = true;
   }
   else if (lowPrices[currentIndex - 1] < previousLow && closePrices[currentIndex] > previousLow) {
      stopHunt.isDetected = true;
      stopHunt.huntLevel = lowPrices[currentIndex - 1];
      stopHunt.huntTime = timeStamps[currentIndex - 1];
      stopHunt.isBullishHunt = false;
   }

   return stopHunt;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Liquidity Grab                                       |
//+------------------------------------------------------------------+
LiquidityGrabInfo DetectLiquidityGrab(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                                     const double &lowPrices[], const double &closePrices[], 
                                     const datetime &timeStamps[], string &errorMessage) {
   LiquidityGrabInfo liquidityGrab = {false, 0, 0, false};
   
   if (currentIndex < lookbackPeriod + 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Liquidity Grab";
      return liquidityGrab;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (highPrices[currentIndex - 1] > previousHigh && closePrices[currentIndex] < previousHigh && 
       closePrices[currentIndex - 1] < previousHigh) {
      liquidityGrab.isDetected = true;
      liquidityGrab.grabLevel = highPrices[currentIndex - 1];
      liquidityGrab.grabTime = timeStamps[currentIndex - 1];
      liquidityGrab.isBullishGrab = true;
   }
   else if (lowPrices[currentIndex - 1] < previousLow && closePrices[currentIndex] > previousLow && 
            closePrices[currentIndex - 1] > previousLow) {
      liquidityGrab.isDetected = true;
      liquidityGrab.grabLevel = lowPrices[currentIndex - 1];
      liquidityGrab.grabTime = timeStamps[currentIndex - 1];
      liquidityGrab.isBullishGrab = false;
   }

   return liquidityGrab;
}

//+------------------------------------------------------------------+
//| تابع تشخیص Turtle Soup                                          |
//+------------------------------------------------------------------+
TurtleSoupInfo DetectTurtleSoup(int currentIndex, int lookbackPeriod, const double &highPrices[], 
                               const double &lowPrices[], const double &closePrices[], 
                               const datetime &timeStamps[], string &errorMessage) {
   TurtleSoupInfo turtleSoup = {false, 0, 0, false};
   
   if (currentIndex < lookbackPeriod + 2 || ArraySize(highPrices) <= currentIndex) {
      errorMessage = "اندیس خارج از محدوده برای تشخیص Turtle Soup";
      return turtleSoup;
   }

   double previousHigh = FindHighestHigh(currentIndex - lookbackPeriod, lookbackPeriod, highPrices, errorMessage);
   double previousLow = FindLowestLow(currentIndex - lookbackPeriod, lookbackPeriod, lowPrices, errorMessage);

   if (highPrices[currentIndex - 1] > previousHigh && 
       CalculatePipSize(highPrices[currentIndex - 1], previousHigh) <= TURTLE_SOUP_THRESHOLD && 
       closePrices[currentIndex] < previousHigh) {
      turtleSoup.isDetected = true;
      turtleSoup.fakeoutLevel = highPrices[currentIndex - 1];
      turtleSoup.fakeoutTime = timeStamps[currentIndex - 1];
      turtleSoup.isBullishFakeout = true;
   }
   else if (lowPrices[currentIndex - 1] < previousLow && 
            CalculatePipSize(previousLow, lowPrices[currentIndex - 1]) <= TURTLE_SOUP_THRESHOLD && 
            closePrices[currentIndex] > previousLow) {
      turtleSoup.isDetected = true;
      turtleSoup.fakeoutLevel = lowPrices[currentIndex - 1];
      turtleSoup.fakeoutTime = timeStamps[currentIndex - 1];
      turtleSoup.isBullishFakeout = false;
   }

   return turtleSoup;
}

#endif