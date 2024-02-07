#ifndef ConditionStreamV2_IMPL
#define ConditionStreamV2_IMPL
#include <Streams/Abstract/ABoolStream.mqh>
#include <Conditions/ICondition.mqh>

//ConditionStreamV2 v1.0

class ConditionStreamV2 : public ABoolStream
{
protected:
   ICondition* _condition;
public:
   ConditionStreamV2(ICondition* condition)
   {
      _condition = condition;
      _condition.AddRef();
   }

   ~ConditionStreamV2()
   {
      _condition.Release();
   }

   virtual int Size()
   {
      return iBars(_Symbol, (ENUM_TIMEFRAMES)_Period);
   }

   bool GetValue(const int period, bool &val)
   {
      val = _condition.IsPass(period, 0);
      return true;
   }
};
#endif