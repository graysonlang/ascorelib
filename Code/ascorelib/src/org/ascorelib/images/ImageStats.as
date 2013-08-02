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
  //  Imports
  // --------------------------------------------------------------------------
  import flash.display.BitmapData;
  import flash.utils.ByteArray;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class ImageStats
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    private var _maximum:Number = 0;
    private var _minimum:Number = Number.MAX_VALUE;
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get maximum():Number
    {
      return _maximum;
    }
    
    public function get minimum():Number
    {
      return _minimum;
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function calculate( image:BitmapData ):ImageStats
    {
      var result:ImageStats = new ImageStats();
      
      var bytes:ByteArray = image.getPixels( image.rect );
      bytes.position = 0;
      
      const w:uint = image.width;
      const h:uint = image.height;
      const d:uint = 4; // argb
      
      const stride:uint = w * d;
      for ( var y:uint = 0; y < h; ++y )
      {
        const row_offset:int = y * stride;
        for ( var x:uint = 0; x < w; ++x )
        {
          const pixel_offset:int = row_offset + x * d;
          
          const r:uint = bytes[ pixel_offset + 1 ] / 255;
          const g:uint = bytes[ pixel_offset + 2 ] / 255;
          const b:uint = bytes[ pixel_offset + 3 ] / 255;
          
          var min:Number = Math.min( r, g, b );
          var max:Number = Math.min( r, g, b );
          
          if ( min < result._minimum )
            result._minimum = min;
          if ( max > result._maximum )
            result._maximum = max;
        }
      }
      
      return result;
    }
  }
}