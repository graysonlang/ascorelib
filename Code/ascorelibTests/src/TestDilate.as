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
package
{
  // ==========================================================================
  //  Imports
  // --------------------------------------------------------------------------
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  
  // ==========================================================================
  //	Metadata Tag
  // --------------------------------------------------------------------------
  [SWF(width="1024", height="512", backgroundColor="0x333333", frameRate="60")]
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class TestDilate extends Sprite
  {
    // ========================================================================
    //  Embedded Resources
    // ------------------------------------------------------------------------
    //[Embed(source="/../res/dilate.png")]
    //[Embed(source="/../res/dilate2.png")]
    [Embed(source="/../res/dilate3.png")]
    private static var SourceImage:Class;
    
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const KERNEL_BLOCK:Vector.<Vector.<uint>> = new <Vector.<uint>>[
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 1, 1, 1, 1, 1 ]
    ];
    
    public static const KERNEL_DIAMOND:Vector.<Vector.<uint>> = new <Vector.<uint>>[
      new <uint>[ 0, 0, 1, 0, 0 ],
      new <uint>[ 0, 1, 1, 1, 0 ],
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 0, 1, 1, 1, 0 ],
      new <uint>[ 0, 0, 1, 0, 0 ]
    ];
    
    public static const KERNEL_CROSS:Vector.<Vector.<uint>> = new <Vector.<uint>>[
      new <uint>[ 0, 0, 1, 0, 0 ],
      new <uint>[ 0, 0, 1, 0, 0 ],
      new <uint>[ 1, 1, 1, 1, 1 ],
      new <uint>[ 0, 0, 1, 0, 0 ],
      new <uint>[ 0, 0, 1, 0, 0 ]
    ];
    
    public static const KERNEL_DISC:Vector.<Vector.<uint>> = new <Vector.<uint>>[
      new <uint>[ 0, 0, 0, 0, 1, 0, 0, 0, 0 ],
      new <uint>[ 0, 0, 1, 1, 1, 1, 0, 0, 0 ],
      new <uint>[ 0, 0, 1, 1, 1, 1, 1, 0, 0 ],
      new <uint>[ 0, 1, 1, 1, 1, 1, 1, 1, 0 ],
      new <uint>[ 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
      new <uint>[ 0, 1, 1, 1, 1, 1, 1, 1, 0 ],
      new <uint>[ 0, 1, 1, 1, 1, 1, 1, 0, 0 ],
      new <uint>[ 0, 0, 1, 1, 1, 1, 0, 0, 0 ],
      new <uint>[ 0, 0, 0, 0, 1, 0, 0, 0, 0 ],
    ];
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function TestDilate()
    {
      stage.align = StageAlign.TOP_LEFT
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      var sourceBitmap:Bitmap = new SourceImage();
      var source:BitmapData = sourceBitmap.bitmapData;
      addChild( sourceBitmap );
      
      var dest:BitmapData = new BitmapData( source.width, source.height, false, 0x0 ); 
      var destBitmap:Bitmap = new Bitmap( dest );
      addChild( destBitmap );
      destBitmap.x = source.width;
      
      //      var kernel:Kernel = new Kernel( 9, 9, 4, 4 );
      //      kernel.data = KERNEL_DISC;
      
      var kernel:Kernel = new Kernel( 5, 5, 2, 2 );
      kernel.data = KERNEL_DIAMOND;
      dilate( source, dest, kernel );
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    private static function dilate( source:BitmapData, dest:BitmapData, kernel:Kernel ):void
    {
      var w:uint = source.width;
      var h:uint = source.height;
      
      var sx:uint = kernel.sx;
      var sy:uint = kernel.sy;
      var cx:uint = kernel.cx;
      var cy:uint = kernel.cy;
      var data:Vector.<Vector.<uint>> = kernel.data;
      
      for ( var i:uint = 0; i < sy; ++i )
        for ( var j:uint = 0; j < sx; ++j )
          if ( data[i][j] == 1 )
            combine( source, dest, j - cx, i - cy, w, h );
    }
    
    private static function combine( source:BitmapData, dest:BitmapData, dx:int, dy:int, w:int, h:int ):void
    {
      var i:int, j:int;
      var startx:uint = dx < 0 ? -dx : 0;
      var endx:uint = dx < 0 ? w : w - dx;
      var starty:uint = dy < 0 ? -dy : 0;
      var endy:uint = dy < 0 ? h : h - dy;
      
      var ox:int = dx;
      var oy:int = dy;
      
      for ( var y:uint = starty; y < endy; ++y )
      {
        for ( var x:uint = startx; x < endx; ++x )
        {
          var sourcePixel:uint = source.getPixel32( x + ox, y + oy );
          var destPixel:uint = dest.getPixel32( x, y );
          dest.setPixel32( x, y, Math.max( destPixel, sourcePixel ) );
        }
      }
    }
  }
}

// ============================================================================
//  Helper Classes
// ----------------------------------------------------------------------------
{
  class Kernel
  {
    public var sx:uint;
    public var sy:uint;
    public var cx:uint;
    public var cy:uint;
    public var data:Vector.<Vector.<uint>>;
    
    public function Kernel( sx:Number, sy:Number, cx:Number, cy:Number )
    {
      this.data = new Vector.<Vector.<uint>>( sx, true );
      
      this.sx = sx;
      this.sy = sy;
      this.cx = cx;
      this.cy = cy;
      
      for ( var x:uint = 0; x < sx; ++x )
      {
        data[ x ] = new Vector.<uint>( sy, true );
        for ( var y:uint = 0; y < sy; ++y )
          data[ x ][ y ] = 1;
      }
    }
  }
}
