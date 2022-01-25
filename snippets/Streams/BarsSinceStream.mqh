#include <Streams/AStream.mqh>
#include <Conditions/ICondition.mqh>
#include <Conditions/StreamValueCondition.mqh>
#include <enums/TwoStreamsConditionType.mqh>

// Counts number of bars since last condition.
// In case of stream check it's value equal to 1

class BarsSinceStream : public AStream
{
   ICondition* _condition;
   int _bars[];
public:
   BarsSinceStream(string symbol, ENUM_TIMEFRAMES timeframe, ICondition* condition)
      :AStream(symbol, timeframe)
   {
      _condition = condition;
      _condition.AddRef();
   }

   BarsSinceStream(string symbol, ENUM_TIMEFRAMES timeframe, IStream* condition)
      :AStream(symbol, timeframe)
   {
      _condition = new StreamValueCondition(symbol, timeframe, FirstEqualsSecond, condition, 1, "Stream");
   }

   ~BarsSinceStream()
   {
      _condition.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      int size = Size();
      if (period >= size)
      {
         return false;
      }
      if (ArraySize(_bars) < size)
      {
         ArrayResize(_bars, size);
      }
      int index = size - period - 1;
      if (_bars[index] == 0)
      {
         FillHistory(period);
      }
      val = _bars[index];
      return true;
   }
private:
   void FillHistory(int period)
   {
      int size = Size();
      for (int periodIndex = period; periodIndex < size; ++periodIndex)
      {
         int index = size - periodIndex - 1;
         if (!_condition.IsPass(periodIndex, 0))
         {
            if (_bars[index] == 0)
            {
               continue;
            }
         }
         else
         {
            _bars[index] = 0;
         }
         for (int ii = index + 1; ii <= size - period - 1; ++ii)
         {
            _bars[ii] = _bars[ii - 1] + 1;
         }
         return;
      }
   }
};