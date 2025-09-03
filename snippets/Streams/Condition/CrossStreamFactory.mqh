#ifndef CrossStreamFactory_IMPL
#define CrossStreamFactory_IMPL
#include <Streams/Condition/ConditionStreamV2.mqh>
#include <Conditions/StreamStreamCondition.mqh>
#include <Conditions/OrCondition.mqh>
#include <enums/TwoStreamsConditionType.mqh>
#include <Streams/Custom/IntToFloatStreamWrapper.mqh>

//CrossStreamFactory v2.1

class CrossStreamFactory
{
public:
   static IBoolStream* CreateCross(TIStream<double> *left, TIStream<double>* right)
   {
      OrCondition* or = new OrCondition();
      or.Add(new StreamStreamCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, FirstCrossOverSecond, left, right, "", ""), false);
      or.Add(new StreamStreamCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, FirstCrossOverSecond, right, left, "", ""), false);
      ConditionStreamV2* result = new ConditionStreamV2(or);
      or.Release();
      return result;
   }

   static IBoolStream* CreateCrossunder(TIStream<double> *left, TIStream<double>* right)
   {
      StreamStreamCondition* condition = new StreamStreamCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, FirstCrossUnderSecond, left, right, "", "");
      ConditionStreamV2* result = new ConditionStreamV2(condition);
      condition.Release();
      return result;
   }
   static IBoolStream* CreateCrossunder(TIStream<double> *left, TIStream<int>* right)
   {
      IntToFloatStreamWrapper* rightWrapper = new IntToFloatStreamWrapper(right);
      IBoolStream* condition = CreateCrossunder(left, rightWrapper);
      rightWrapper.Release();
      return condition;
   }

   static IBoolStream* CreateCrossover(TIStream<double> *left, TIStream<double>* right)
   {
      StreamStreamCondition* condition = new StreamStreamCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, FirstCrossOverSecond, left, right, "", "");
      ConditionStreamV2* result = new ConditionStreamV2(condition);
      condition.Release();
      return result;
   }
   static IBoolStream* CreateCrossover(TIStream<int> *left, TIStream<int>* right)
   {
      IntToFloatStreamWrapper* leftWrapper = new IntToFloatStreamWrapper(left);
      IntToFloatStreamWrapper* rightWrapper = new IntToFloatStreamWrapper(right);
      IBoolStream* condition = CreateCrossover(leftWrapper, rightWrapper);
      leftWrapper.Release();
      rightWrapper.Release();
      return condition;
   }
   static IBoolStream* CreateCrossover(TIStream<double> *left, TIStream<int>* right)
   {
      IntToFloatStreamWrapper* rightWrapper = new IntToFloatStreamWrapper(right);
      IBoolStream* condition = CreateCrossover(left, rightWrapper);
      rightWrapper.Release();
      return condition;
   }
};
#endif