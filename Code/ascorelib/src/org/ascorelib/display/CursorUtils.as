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
package org.ascorelib.display
{
  // ==========================================================================
  //  Imports
  // --------------------------------------------------------------------------
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.ui.Mouse;
  import flash.ui.MouseCursorData;
  
  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public final class CursorUtils
  {
    // ========================================================================
    //  Embedded Resources
    // ------------------------------------------------------------------------
    [Embed(source="/../res/precise.png")]
    private static var ResourcePreciseCursor:Class;
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function initCursor(cursor:BitmapData = null,
                                      cx:uint = 7, cy:uint = 7,
                                      cursorName:String = "precise"):void
    {
      var mouseCursorData:MouseCursorData = new MouseCursorData();
      //if (!cursor) {
      //  cursor = createPreciseCursor();
      //}
      //mouseCursorData.data = new <BitmapData>[cursor];
      var bitmap:Bitmap = new ResourcePreciseCursor() as Bitmap;
      mouseCursorData.data = new <BitmapData>[bitmap.bitmapData];
      mouseCursorData.hotSpot = new Point(cx,cy);
      Mouse.registerCursor(cursorName, mouseCursorData);
      Mouse.cursor = cursorName;
    }
    
    public static function createPreciseCursor():BitmapData
    {
      var cursor:BitmapData = new BitmapData(16, 16, true, 0);
      var rect:Rectangle = new Rectangle(7, 0, 1, 4);
      var color:uint = 0xffffffff;
      cursor.fillRect(rect, color);
      rect.y = 11;
      cursor.fillRect(rect, color);
      rect.x = 0;
      rect.y = 7;
      rect.height = 1;
      rect.width = 4;
      cursor.fillRect(rect, color);
      rect.x = 11;
      cursor.fillRect(rect, color);
      cursor.setPixel32(7, 7, color);
      return cursor;
    }
  }
}
