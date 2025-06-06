// Vwap on stream v3.0

#include <Streams/AOnStream.mqh>
#include <Streams/Interfaces/IIntStream.mqh>
#include <Streams/Interfaces/IBoolStream.mqh>
#include <Streams/Interfaces/IDateTimeStream.mqh>
#include <Streams/VolumeStream.mqh>
#include <Streams/DateTimeStream.mqh>
#include <PineScript/Array/Array.mqh>
#include <PineScript/Array/FloatArray.mqh>

#ifndef VwapOnStream_IMP
#define VwapOnStream_IMP

class VwapStdev : public AOnStream
{
   IIntStream* volume;
   IBoolStream* anchor;
   double stdev;
public:
   VwapStdev(TIStream<double> *source, IIntStream* volume, IBoolStream* anchor, double stdev)
      :AOnStream(source)
   {
      this.volume = volume;
      volume.AddRef();
      this.anchor = anchor;
      anchor.AddRef();
      this.stdev = stdev;
   }
   
   ~VwapStdev()
   {
      volume.Release();
      anchor.Release();
   }

   bool GetValue(const int period, double &val, double &upper, double &lower)
   {
      int totalBars = volume.Size();
      if (period > totalBars)
         return false;
         
      double sum1 = 0;
      double sum2 = 0;
      FloatArray* arr = new FloatArray(0, 0);
      for (int i = period; i < Size(); ++i)
      {
         int current;
         if (!anchor.GetValue(i, current))
         {
            val = EMPTY_VALUE;
            upper = EMPTY_VALUE;
            lower = EMPTY_VALUE;
            return false;
         }
         if (current == 1)
         {
            break;
         }
         double value;
         if (!_source.GetValue(i, value))
         {
            val = EMPTY_VALUE;
            upper = EMPTY_VALUE;
            lower = EMPTY_VALUE;
            return false;
         }
         int volumeValue;
         if (!volume.GetValue(i, volumeValue))
         {
            val = EMPTY_VALUE;
            upper = EMPTY_VALUE;
            lower = EMPTY_VALUE;
            return false;
         }
         sum1 += value * volumeValue;
         sum2 += volumeValue;
         arr.Push(sum2 != 0 ? sum1 / sum2 : 0);
      }
      if (sum2 == 0)
      {
         val = EMPTY_VALUE;
         upper = EMPTY_VALUE;
         lower = EMPTY_VALUE;
         return false;
      }
      val = sum2 != 0 ? sum1 / sum2 : 0;
      double stdevValue = Array::Stdev(arr);
      delete arr;
      upper = val + stdevValue * stdev;
      lower = val - stdevValue * stdev;
      return true;
   }
   bool GetValue(const int period, double &val)
   {
      int totalBars = volume.Size();
      if (period > totalBars)
         return false;
         
      double sum1 = 0;
      double sum2 = 0;
      for (int i = period; i < Size(); ++i)
      {
         int current;
         if (!anchor.GetValue(i, current))
         {
            val = EMPTY_VALUE;
            return false;
         }
         if (current == 1)
         {
            break;
         }
         double value;
         if (!_source.GetValue(i, value))
         {
            val = EMPTY_VALUE;
            return false;
         }
         int volumeValue;
         if (!volume.GetValue(i, volumeValue))
         {
            val = EMPTY_VALUE;
            return false;
         }
         sum1 += value * volumeValue;
         sum2 += volumeValue;
      }
      val = sum2 != 0 ? sum1 / sum2 : 0;
      return true;
   }
};

class VwapOnStream : public AOnStream
{
   IIntStream* _volume;
   IDateTimeStream* _dates;
public:
   VwapOnStream(TIStream<double> *source, IIntStream* volume, IDateTimeStream* dates)
      :AOnStream(source)
   {
      _volume = volume;
      _volume.AddRef();
      _dates = dates;
      _dates.AddRef();
   }
   
   ~VwapOnStream()
   {
      _volume.Release();
      _dates.Release();
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = _volume.Size();
      if (period > totalBars)
         return false;
         
      double sum1 = 0;
      double sum2 = 0;
      datetime startDate;
      if (!_dates.GetValue(period, startDate))
      {
         val = EMPTY_VALUE;
         return false;
      }
      int startDay = TimeDay(startDate);
      for (int i = period; i < Size(); ++i)
      {
         datetime current;
         if (!_dates.GetValue(i, current))
         {
            val = EMPTY_VALUE;
            return false;
         }
         int currentDay = TimeDay(current);
         if (currentDay != startDay)
         {
            break;
         }
         double value;
         if (!_source.GetValue(i, value))
         {
            val = EMPTY_VALUE;
            return false;
         }
         int volume;
         if (!_volume.GetValue(i, volume))
         {
            val = EMPTY_VALUE;
            return false;
         }
         sum1 += value * volume;
         sum2 += volume;
      }
      val = sum2 != 0 ? sum1 / sum2 : 0;
      return true;
   }
};

class VwapOnStreamFactory
{
public:
   static TIStream<double>* Create(const string symbol, ENUM_TIMEFRAMES timeframe, TIStream<double> *source)
   {
      VolumeStream* volume = new VolumeStream(symbol, timeframe);
      DateTimeStream* dates = new DateTimeStream(symbol, timeframe);
      VwapOnStream* stream = new VwapOnStream(source, volume, dates);
      volume.Release();
      dates.Release();
      return stream;
   }
   
   static TIStream<double>* Create(TIStream<double> *source, IIntStream* volume, IDateTimeStream* dates)
   {
      return new VwapOnStream(source, volume, dates);
   }
   
   static VwapStdev* Create(const string symbol, ENUM_TIMEFRAMES timeframe, TIStream<double> *source, IBoolStream* anchor, double stdev)
   {
      VolumeStream* volume = new VolumeStream(symbol, timeframe);
      VwapStdev* stream = new VwapStdev(source, volume, anchor, stdev);
      volume.Release();
      return stream;
   }
};

#endif