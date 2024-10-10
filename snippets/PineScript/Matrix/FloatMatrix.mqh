// Float matrix
// v1.0
#include <PineScript/Matrix/IFloatMatrix.mqh>

class FloatMatrix : public IFloatMatrix
{
   int rows;
   int columns;
   double initialValue;
   double values[];
public:
   FloatMatrix(int rows, int columns, double initialValue)
   {
      this.rows = rows;
      this.columns = columns;
      this.initialValue = initialValue;
      Clear();
   }
   
   IFloatMatrix* Clear()
   {
      ArrayResize(values, rows * columns);
      for (int row = 0; row < rows; ++row)
      {
         for (int column = 0; column < columns; ++column)
         {
            values[row * columns + column] = initialValue;
         }
      }
      return &this;
   }
   
   double Get(int row, int col)
   {
      return values[row * columns + col];
   }
   
   void Set(int row, int col, double val)
   {
      values[row * columns + col] = val;
   }
};