class ACustomBarStream : public IBarStream
{
protected:
   int _references;

   datetime _dates[];
   double _open[];
   double _close[];
   double _high[];
   double _low[];
   int _size;

   ACustomBarStream()
   {
      _size = 0;
      _references = 1;
   }
public:
   void AddRef()
   {
      ++_references;
   }

   void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }
   virtual bool GetValue(const int period, double &val)
   {
      if (period >= _size)
         return false;
      val = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetDate(const int period, datetime &dt)
   {
      if (period >= _size)
         return false;
      dt = _dates[_size - 1 - period];
      return true;
   }

   virtual double GetOpen(const int period, double &open)
   {
      if (_size <= period)
         return false;
      open = _open[_size - 1 - period];
      return true;
   }

   virtual double GetHigh(const int period, double &high)
   {
      if (_size <= period)
         return false;
      high = _high[_size - 1 - period];
      return true;
   }

   virtual double GetLow(const int period, double &low)
   {
      if (_size <= period)
         return false;
      low = _low[_size - 1 - period];
      return true;
   }

   virtual double GetClose(const int period, double &close)
   {
      if (_size <= period)
         return false;
      close = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetValues(const int period, double &open, double &high, double &low, double &close)
   {
      if (period >= _size)
         return false;
      high = _high[_size - 1 - period];
      low = _low[_size - 1 - period];
      open = _open[_size - 1 - period];
      close = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetHighLow(const int period, double &high, double &low)
   {
      if (period >= _size)
         return false;
      high = _high[_size - 1 - period];
      low = _low[_size - 1 - period];
      return true;
   }

   virtual bool GetIsAscending(const int period, bool &res)
   {
      if (period >= _size)
         return false;
      res = _open[_size - 1 - period] < _close[_size - 1 - period];
      return true;
   }

   virtual bool GetIsDescending(const int period, bool &res)
   {
      if (period >= _size)
         return false;
      res = _open[_size - 1 - period] > _close[_size - 1 - period];
      return true;
   }

   virtual int Size()
   {
      return _size;
   }
};