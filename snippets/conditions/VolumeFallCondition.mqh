// Volume fall condition v1.0
class VolumeFallCondition : public ACondition
{
public:
   VolumeFallCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      long volume0 = iVolume(_symbol, _timeframe, period);
      long volume1 = iVolume(_symbol, _timeframe, period + 1);
      return volume0 < volume1;
   }
};