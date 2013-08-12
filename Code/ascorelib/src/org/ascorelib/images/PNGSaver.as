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
  import flash.net.FileReference;
  import flash.utils.ByteArray;
  
  import org.ascorelib.utils.FileSaver;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class PNGSaver
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const DEFAULT_FILENAME:String = "image.png";
    
    // ========================================================================
    //  Statics
    // ------------------------------------------------------------------------
    private static var _pendingReferences:Vector.<FileReference> = new Vector.<FileReference>();
    private static var _pendingFilenames:Vector.<String> = new Vector.<String>();
    private static var _pendingData:Vector.<ByteArray> = new Vector.<ByteArray>();
    private static var _references:Vector.<FileReference> = new Vector.<FileReference>();
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function save(bitmapData:BitmapData, filename:String="image.png") : void {
      var bytes:ByteArray = PNGUtils.encode(bitmapData);
      FileSaver.saveBinary(bytes, filename);
    }
  }
}