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
  //	Imports
  // --------------------------------------------------------------------------
  import flash.utils.ByteArray;

  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public class Histogram
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var max:uint = 0;
    public var mode:int = -1;
    public var size:uint = 0;
    public var counts:Vector.<uint> = new Vector.<uint>( 256, true );
    public var lookup:Vector.<uint> = new Vector.<uint>( 256, true );
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function reset():void
    {
      max = 0;
      mode = -1;
      size = 0;
      for ( var i:uint = 0; i < 256; i++)
      {
        counts[ i ] = 0;
        lookup[ i ] = 0;
      }
    }
    
    public function calculate( src:ByteArray, w:uint, h:uint, d:uint ):void
    {
      reset();
      
      const stride:uint = w * d;
      for ( var y:uint = 0; y < h; ++y )
      {
        const row_offset:int = y * stride;
        for ( var x:uint = 0; x < w; ++x )
        {
          const pixel_offset:int = row_offset + x * d;
          
          const r:uint = src[ pixel_offset + 1 ];
          const g:uint = src[ pixel_offset + 2 ];
          const b:uint = src[ pixel_offset + 3 ];
          
          const lum:uint = ( r * 0.299 + g * .587 + b * .114 );
          //const lum:uint = ( r + g + b ) / 3;
          counts[ lum ]++;
        }
      }
      
      size = w * h;
      
      var left:int = -1;
      var right:int;
      
      var i:int;
      var count:uint
      
      for ( i = 0; i < 256; ++i )
      {
        count = counts[ i ];
        if ( count > 0 )
        {
          if ( left < 0 )
            left = i;
          right = i;
        }
        
        if ( count > max )
        {
          max = count;
          mode = i;
        }
      }
      
      // Generate cumulative frequency histogram
      var cdf:Vector.<Number> = new Vector.<Number>( 256, true );
      var sum:Number = 0;
      for ( i = 0; i < 256; ++i )
      {
        sum += counts[ i ];
        cdf[ i ] = sum;// / size;
      }
      
      var cdfMin:uint = 0;
      for ( i = 0; i < 256; ++i )
      {
        if ( cdf[ i ] > 0 )
        {
          cdfMin = cdf[ i ];
          break;
        }
      }
      
      for ( i = 0; i < 256; ++i )
        lookup[ i ] = Math.round( ( cdf[ i ] - cdfMin ) / ( size - cdfMin ) * 255 );
    }
  }
}