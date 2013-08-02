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
  import flash.display.Bitmap;
  import flash.events.Event;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class ImageLoadedEvent extends Event
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const IMAGE_LOADED:String = "imageLoaded";
    
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    protected var _bitmap:Bitmap;
    protected var _index:uint;
    protected var _url:String;
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get bitmap():Bitmap
    {
      return _bitmap;
    }
    
    public function get index():uint
    {
      return _index;
    }
    
    public function get url():String
    {
      return _url;
    }
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function ImageLoadedEvent( index:uint, url:String, bitmap:Bitmap, type:String = IMAGE_LOADED, bubbles:Boolean = false, cancelable:Boolean = false )
    {
      super( type, bubbles, cancelable );
      _index = index;
      _url = url;
      _bitmap = bitmap;
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    override public function toString():String
    {
      return "[Event type=" + type
        + " index=" + _index
        + " url=" + _url
        + " bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
    }
  }
}