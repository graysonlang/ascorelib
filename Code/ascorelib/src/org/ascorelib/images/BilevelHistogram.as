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
package org.ascorelib.images
{
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class BilevelHistogram
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var _coarse:Vector.<uint>;
    public var _fine:Vector.<uint>;
    public var size:uint;
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function BilevelHistogram() {
      _coarse = new Vector.<uint>( 16 );
      _fine = new Vector.<uint>( 256 );
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function add( x:uint ):void
    {
      _coarse[ ( x >> 4 ) & 0xf ]++;
      _fine[ x ]++;
      size++;
    }
    
    public function remove( x:uint ):void
    {
      if ( _fine[ x ] > 0 )
      {
        _coarse[ ( x >> 4 ) & 0xf ]--;
        _fine[ x ]--;
        size--;
      }
    }
    
    public function get median():uint
    {
      var i:uint, j:uint;
      var middle:uint = size / 2;
      var sum:uint = 0;
      
      var start:uint, end:uint;
      
      if ( size % 2 == 1 )
      {
        // odd
        for ( i = 0; i < 16; ++i )
        {
          sum += _coarse[ i ];
          if ( sum > middle )
          {
            sum -= _coarse[ i ];
            
            start = i << 4;
            end = start + 16;
            
            for ( j = start; j < end; ++j )
            {
              sum += _fine[ j ];
              if ( sum > middle ) {
                return j;
              }
            }
          }
        }
      }
      else
      {
        // even
        for ( i = 0; i < 16; ++i )
        {
          sum += _coarse[i];
          if ( sum >= middle )
          {
            sum -= _coarse[ i ];
            
            start = i << 4;
            end = start + 16;
            
            for ( j = start; j < end; ++j )
            {
              sum += _fine[ j ];
              if ( sum >= middle ) {
                return j;
              }
            }
          }
        }
      }
      
      return uint.MAX_VALUE;
    }
    
    public function toString():String
    {
      return size + "\n" + _fine.toString(); 
    }
  }
}