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
  public class HistogramRGB
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var size:uint = 0;
    
    public var max_r:uint = 0;
    public var max_g:uint = 0;
    public var max_b:uint = 0;
    
    public var counts_r:Vector.<uint> = new Vector.<uint>( 256, true );
    public var counts_g:Vector.<uint> = new Vector.<uint>( 256, true );
    public var counts_b:Vector.<uint> = new Vector.<uint>( 256, true );
    
    public var lookup_r:Vector.<uint> = new Vector.<uint>( 256, true );
    public var lookup_g:Vector.<uint> = new Vector.<uint>( 256, true );
    public var lookup_b:Vector.<uint> = new Vector.<uint>( 256, true );
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function reset():void
    {
      size = 0;
      
      max_r = 0;
      max_g = 0;
      max_b = 0;
      
      for ( var i:uint = 0; i < 256; i++)
      {
        counts_r[ i ] = 0;
        counts_g[ i ] = 0;
        counts_b[ i ] = 0;
        lookup_r[ i ] = 0;
        counts_g[ i ] = 0;
        counts_b[ i ] = 0;
      }
    }
    
    public function calculate( src:ByteArray, w:uint, h:uint, d:uint ):void
    {
      reset();
      
      var i:int;
      
      // Fill histogram
      const stride:uint = w * d;
      for ( var y:uint = 0; y < h; ++y )
      {
        const row_offset:int = y * stride;
        for ( var x:uint = 0; x < w; ++x )
        {
          const pixel_offset:int = row_offset + x * d;
          counts_r[ src[ pixel_offset + 1 ] ]++;
          counts_g[ src[ pixel_offset + 2 ] ]++;
          counts_b[ src[ pixel_offset + 3 ] ]++;
        }
      }
      
      size = w * h;
      
      var count_r:uint
      for ( i = 0; i < 256; ++i )
      {
        count_r = counts_r[ i ];
        if ( count_r > max_r )
          max_r = count_r;
      }
      
      // Generate cumulative frequency histogram
      var cdf_r:Vector.<Number> = new Vector.<Number>( 256, true );
      var cdf_g:Vector.<Number> = new Vector.<Number>( 256, true );
      var cdf_b:Vector.<Number> = new Vector.<Number>( 256, true );
      
      var sum_r:Number = 0;
      var sum_g:Number = 0;
      var sum_b:Number = 0;
      for ( i = 0; i < 256; ++i )
      {
        sum_r += counts_r[ i ];
        sum_g += counts_r[ i ];
        sum_b += counts_r[ i ];
        cdf_r[ i ] = sum_r;// / size;
        cdf_g[ i ] = sum_g;// / size;
        cdf_b[ i ] = sum_b;// / size;
      }
      
      var cdfMin_r:uint = 0;
      for ( i = 0; i < 256; ++i )
      {
        if ( cdf_r[ i ] > 0 )
        {
          cdfMin_r = cdf_r[ i ];
          break;
        }
      }
      
      var cdfMin_g:uint = 0;
      for ( i = 0; i < 256; ++i )
      {
        if ( cdf_g[ i ] > 0 )
        {
          cdfMin_g = cdf_g[ i ];
          break;
        }
      }
      
      var cdfMin_b:uint = 0;
      for ( i = 0; i < 256; ++i )
      {
        if ( cdf_b[ i ] > 0 )
        {
          cdfMin_b = cdf_b[ i ];
          break;
        }
      }
      
      for ( i = 0; i < 256; ++i ) {
        lookup_r[ i ] = Math.round( ( cdf_r[ i ] - cdfMin_r ) / ( size - cdfMin_r ) * 255 );
        lookup_g[ i ] = Math.round( ( cdf_g[ i ] - cdfMin_g ) / ( size - cdfMin_g ) * 255 );
        lookup_b[ i ] = Math.round( ( cdf_b[ i ] - cdfMin_b ) / ( size - cdfMin_b ) * 255 );
      }
    }
  }
}