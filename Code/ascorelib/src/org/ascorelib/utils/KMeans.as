// ============================================================================
//
//  Copyright 2013 The ascorelib Authors. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
// ============================================================================
package org.ascorelib.utils
{
  import com.adobe.utils.MathUtils;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class KMeans
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const MAX_ITERATIONS:uint = 20;
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------    
    public static function calculateMean(values:Vector.<Number>) : Number {
      var mean:* = NaN;
      var total:* = 0;
      var v:Vector.<Number> = values.slice();
      var length:uint = v.length;
      var count:uint = MathUtils.floorToPowerOf2(length);
      var result:Number = calculatePowerOfTwoMean(v,0,count);
      var calculated:* = count;
      while (calculated<length)
      {
        count = MathUtils.floorToPowerOf2(length-calculated);
        mean = calculatePowerOfTwoMean(v,calculated,count);
        total = calculated+count;
        result = result * calculated / total + mean*count / total;
        calculated=total;
      }
      return result;
    }
    
    private static function calculatePowerOfTwoMean(values:Vector.<Number>, start:uint, count:uint) : Number {
      var i:* = 0;
      var index:* = 0;
      var average:* = NaN;
      while(count>1)
      {
        count=count/2;
        i=0;
        while(i<count)
        {
          index=i*2+start;
          average=(values[index]+values[index+1])/2;
          values[i+start]=average;
          i++;
        }
      }
      return values[start];
    }
    
    public static function calculateKMeans3(values:Vector.<Number>, stride:uint=1, maxIterations:uint=20) : Vector.<Number> {
      var j:* = 0;
      var index:* = 0;
      var group:* = 0;
      var i:* = 0;
      var _loc12_:* = 0;
      _loc12_=3;
      var count:* = 0;
      var _loc16_:uint = values.length;
      var _loc7_:uint = _loc16_/stride;
      var _loc9_:uint = 3*stride;
      
      var _loc18_:*;
      var _loc19_:*;
      var _loc20_:*;
      if(_loc16_%3)
      {
        throw new Error("MathUtils.calculatedKMeans: Unexpected values length. Should be equally divisible by stride");
      }
      else
      {
        var centers:Vector.<Number>=new Vector.<Number>(_loc9_,true);
        var groups:Vector.<uint>=new Vector.<uint>(_loc7_,true);
        var totals:Vector.<Number>=new Vector.<Number>(_loc9_,true);
        var counts:Vector.<uint>=new Vector.<uint>(3,true);
        i=0;
        while(i<_loc7_)
        {
          groups[i]=i%3;
          i++;
        }
        i=0;
        while(i<_loc9_)
        {
          totals[i]=0;
          i++;
        }
        i=0;
        while(i<_loc7_)
        {
          index=i*stride;
          group=groups[i];
          j=0;
          while(j<stride)
          {
            _loc18_=group*stride+j;
            _loc19_=totals[_loc18_]+values[index+j];
            totals[_loc18_]=_loc19_;
            j++;
          }
          _loc19_=counts;
          _loc18_=group;
          _loc20_=_loc19_[_loc18_]+1;
          _loc19_[_loc18_]=_loc20_;
          i++;
        }
        i=0;
        while(i<3)
        {
          count=counts[i];
          index=i*stride;
          j=0;
          while(j<stride)
          {
            centers[index+j]=totals[index+j]/count;
            j++;
          }
          i++;
        }
        trace(totals);
        trace(counts);
        trace(centers);
        var iteration:uint=0;
        while(iteration<20)
        {
          iteration++;
        }
        return centers;
      }
    }
    
    //      public static function calculateColorKMeans(colors:Vector.<Number>, k:uint=2, maxIterations:uint=20) : Vector.<Number> {
    //         var j:* = 0;
    //         var index:* = 0;
    //         var count:* = 0;
    //         var group:* = 0;
    //         var base:* = 0;
    //         var i:* = 0;
    //         var _loc10_:* = 0;
    //         _loc10_=3;
    //         var c1:* = NaN;
    //         var c2:* = NaN;
    //         var dMax:* = NaN;
    //         var didChange:* = false;
    //         var r:* = NaN;
    //         var g:* = NaN;
    //         var b:* = NaN;
    //         var centerIndex:* = 0;
    //         var cr:* = NaN;
    //         var cg:* = NaN;
    //         var cb:* = NaN;
    //         var dCurrent:* = NaN;
    //         var dNew:* = NaN;
    //         var delta:* = NaN;
    //         var _loc12_:uint = colors.length;
    //         var _loc8_:uint = _loc12_/3;
    //         var _loc22_:uint = k*3;
    //         if(_loc8_<=3)
    //         {
    //            return colors;
    //         }
    //         if(_loc12_%3)
    //         {
    //            throw new Error("MathUtils.calculatedColorKMeans3: Unexpected values length. Should be equally divisible by stride");
    //         }
    //         else
    //         {
    //            centers=new Vector.<Number>(_loc22_,true);
    //            groups=new Vector.<uint>(_loc8_,true);
    //            totals=new Vector.<Number>(_loc22_,true);
    //            counts=new Vector.<uint>(k,true);
    //            blocks=(_loc8_+k)/k;
    //            i=0;
    //            while(i<_loc8_)
    //            {
    //               groups[i]=~~(i/blocks);
    //               i++;
    //            }
    //            iteration=0;
    //            while(iteration<20)
    //            {
    //               i=0;
    //               while(i<_loc22_)
    //               {
    //                  totals[i]=0;
    //                  i++;
    //               }
    //               i=0;
    //               while(i<k)
    //               {
    //                  counts[i]=0;
    //                  i++;
    //               }
    //               i=0;
    //               while(i<_loc8_)
    //               {
    //                  index=i*3;
    //                  group=groups[i];
    //                  base=group*3;
    //                  _loc34_=base;
    //                  _loc35_=totals[_loc34_]+colors[index];
    //                  totals[_loc34_]=_loc35_;
    //                  _loc35_=base+1;
    //                  _loc34_=totals[_loc35_]+colors[index+1];
    //                  totals[_loc35_]=_loc34_;
    //                  _loc34_=base+2;
    //                  _loc35_=totals[_loc34_]+colors[index+2];
    //                  totals[_loc34_]=_loc35_;
    //                  _loc35_=counts;
    //                  _loc34_=group;
    //                  _loc36_=_loc35_[_loc34_]+1;
    //                  _loc35_[_loc34_]=_loc36_;
    //                  i++;
    //               }
    //               c1=0.25;
    //               c2=1-c1;
    //               if(iteration==0)
    //               {
    //                  i=0;
    //                  while(i<k)
    //                  {
    //                     count=counts[i];
    //                     index=i*3;
    //                     centers[index]=totals[index]/count;
    //                     centers[index+1]=totals[index+1]/count;
    //                     centers[index+2]=totals[index+2]/count;
    //                     i++;
    //                  }
    //               }
    //               else
    //               {
    //                  i=0;
    //                  while(i<k)
    //                  {
    //                     count=counts[i];
    //                     index=i*3;
    //                     centers[index]=centers[index]*c1+totals[index]/count*c2;
    //                     centers[index+1]=centers[index+1]*c1+totals[index+1]/count*c2;
    //                     centers[index+2]=centers[index+2]*c1+totals[index+2]/count*c2;
    //                     i++;
    //                  }
    //               }
    //               dMax=0.0;
    //               didChange=false;
    //               i=0;
    //               while(i<_loc8_)
    //               {
    //                  base=i*3;
    //                  r=colors[base];
    //                  g=colors[base+1];
    //                  b=colors[base+2];
    //                  group=groups[i];
    //                  centerIndex=group*3;
    //                  cr=centers[centerIndex];
    //                  cg=centers[centerIndex+1];
    //                  cb=centers[centerIndex+2];
    //                  dCurrent=GeomUtils.distanceSquared3(r,g,b,cr,cg,cb);
    //                  j=0;
    //                  while(j<k)
    //                  {
    //                     if(j!=group)
    //                     {
    //                        centerIndex=j*3;
    //                        cr=centers[centerIndex];
    //                        cg=centers[centerIndex+1];
    //                        cb=centers[centerIndex+2];
    //                        dNew=GeomUtils.distanceSquared3(r,g,b,cr,cg,cb);
    //                        delta=dCurrent-dNew;
    //                        if(delta<=0)
    //                        {
    //                           dMax=delta>dMax?delta:dMax;
    //                           dCurrent=dNew;
    //                           _loc35_=counts;
    //                           _loc34_=groups[i];
    //                           _loc36_=_loc35_[_loc34_]-1;
    //                           _loc35_[_loc34_]=_loc36_;
    //                           groups[i]=j;
    //                           _loc35_=counts;
    //                           _loc34_=j;
    //                           _loc36_=_loc35_[_loc34_]+1;
    //                           _loc35_[_loc34_]=_loc36_;
    //                           didChange=true;
    //                        }
    //                     }
    //                     j++;
    //                  }
    //                  i++;
    //               }
    //               if(!didChange||dMax>1)
    //               {
    //                  break;
    //               }
    //               i=0;
    //               while(i<k)
    //               {
    //                  if(counts[i]==0)
    //                  {
    //                     j=0;
    //                     while(j<k)
    //                     {
    //                        if(i!=j)
    //                        {
    //                           if(counts[j]>1)
    //                           {
    //                              group=j;
    //                              index=0;
    //                              while(groups[index]!=group)
    //                              {
    //                                 index++;
    //                              }
    //                              _loc35_=counts;
    //                              _loc34_=i;
    //                              _loc36_=_loc35_[_loc34_]+1;
    //                              _loc35_[_loc34_]=_loc36_;
    //                              _loc35_=counts;
    //                              _loc34_=group;
    //                              _loc36_=_loc35_[_loc34_]-1;
    //                              _loc35_[_loc34_]=_loc36_;
    //                              groups[index]=i;
    //                              break;
    //                           }
    //                        }
    //                        j++;
    //                     }
    //                  }
    //                  i++;
    //               }
    //               iteration++;
    //            }
    //            trace("iterations:",iteration);
    //            trace("dmax:",dMax);
    //            trace(centers);
    //            return centers;
    //         }
    //      }
  }
}
