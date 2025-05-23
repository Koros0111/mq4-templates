// Stream factory dummy v2.0

#ifndef StreamFactory_IMP
#define StreamFactory_IMP

#include <IStreamFactory.mqh>

class StreamFactory : public IStreamFactory
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   StreamFactory(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual TIStream<double>* Create(const int order)
   {
      return NULL;
   }
};
#endif