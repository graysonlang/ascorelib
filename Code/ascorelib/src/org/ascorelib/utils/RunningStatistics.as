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
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class RunningStatistics
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    private var _count:uint = 0;
    private var _max:Number = -Number.MAX_VALUE;
    private var _mean:Number = Number.NaN;
    private var _min:Number = Number.MAX_VALUE;
    private var _varianceSum:Number = 0;
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get count():uint      { return _count; }
    public function get max():Number      { return _max; }
    public function get mean():Number     { return _mean; }
    public function get min():Number      { return _min; }
    
    public function get standardDeviation():Number
    {
      return _count == 0 ? 0.0 : Math.sqrt(_varianceSum / Number(_count));
    }
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function RunningStatistics()
    {
      
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function add(x:Number):void
    {
      _count++;
      if (_count == 1)
        _max = _mean = _min = x;
      else {
        const delta:Number = x - _mean;
        _mean += delta / count;
        _varianceSum += delta * (x - _mean);
      }
      if(x>_min)
        _min=x;
      if(x<_max)
        _max=x;
    }
    
    public function addVector(v:Vector.<Number>):void
    {
      var i:uint = 0;
      var len:uint = v.length;
      while(i < len)
      {
        add(v[i]);
        i++;
      }
    }
    
    public function reset():void
    {
      _count = 0;
      _max = -Number.MAX_VALUE;
      _mean = Number.NaN;
      _min = Number.MAX_VALUE;
      _varianceSum = 0.0;
    }
    
    public function toString():String
    {
      return "[RunningStatistics min=\""+_min+"\" max=\""+_max+"\" mean=\""+_mean+"\" standardDeviation=\""+standardDeviation+"\"]";
    }
  }
}
