// Averages stream factory v2.0

#include <enums/MATypes.mqh>
#include <Streams/Interfaces/TIStream.mqh>
#include <Streams/Averages/SMAOnStream.mqh>
#include <Streams/Averages/EmaOnStream.mqh>
#include <Streams/Averages/TemaOnStream.mqh>
#include <Streams/Averages/LwmaOnStream.mqh>
#include <Streams/Averages/VwmaOnStream.mqh>
#include <Streams/Averages/RmaOnStream.mqh>
#include <Streams/Averages/WMAOnStream.mqh>
#include <Streams/Averages/ZeroLagTEMAOnStream.mqh>
#include <Streams/Averages/ZeroLagMAOnStream.mqh>
#include <Streams/Averages/LinearRegressionOnStream.mqh>

#ifndef AveragesStreamFactory_IMP
#define AveragesStreamFactory_IMP

class AveragesStreamFactory
{
public:
   static TIStream<double>* Create(TIStream<double>* source, const int length, const MATypes type, IIntStream* volume = NULL)
   {
      switch (type)
      {
         case ma_sma:
            return new SmaOnStream(source, length);
         case ma_wma:
            return new WMAOnStream(source, length);
         case ma_ema:
            return new EMAOnStream(source, length);
         case ma_linreg:
            return new LinearRegressionOnStream(source, length);
         //case 2  : return(iDsema(price,length,r,instanceNo));
         // case 3  : return(iDema(price,length,r,instanceNo));
         case ma_tema:
            return new TemaOnStream(source, length);
         // case 5  : return(iSmma(price,length,r,instanceNo));
         case ma_lwma:
            return new LwmaOnStream(source, length);
         // case 7  : return(iLwmp(price,length,r,instanceNo));
         // case 8  : return(iAlex(price,length,r,instanceNo));
         case ma_vwma:
            return VwmaOnStreamFactory::Create(source, volume, length);
         // case 10 : return(iHull(price,length,r,instanceNo));
         // case 11 : return(iTma(price,length,r,instanceNo));
         // case 12 : return(iSineWMA(price,(int)length,r,instanceNo));
         // case 13 : return(iLinr(price,length,r,instanceNo));
         // case 14 : return(iIe2(price,length,r,instanceNo));
         // case 15 : return(iNonLagMa(price,length,r,instanceNo));
         case ma_zlma:
            return new ZeroLagMAOnStream(source, length);
         case ma_rma:
            return new RmaOnStream(source, length);
         case ma_zltema:
            return new ZeroLagTEMAOnStream(source, length);
         // case 17 : return(iLeader(price,length,r,instanceNo));
         // case 18 : return(iSsm(price,length,r,instanceNo));
         // case 19 : return(iSmooth(price,(int)length,r,instanceNo));
         // default : return(0);
      }
      return NULL;
   }
};

#endif