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
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.KeyboardEvent;
  
  import org.ascorelib.display.OutputDisplay;

  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public class BaseImageTest extends Sprite
  {
    // ========================================================================
    //  Static Properties
    // ------------------------------------------------------------------------
    protected var _outputDisplay:OutputDisplay = new OutputDisplay(10, 0xffcc00);

    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var _server:ImageServer;
    protected var _index:int = 0;
    protected var _currentBitmap:Bitmap;
    protected var _sprite:Sprite;
    protected var _overlay:Sprite;
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get currentFilename():String
    {
      return _server.filename;
    }
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function BaseImageTest(imageURIs:Vector.<String> = null)
    {
      stage.align = StageAlign.TOP_LEFT
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      super();

      _server = new ImageServer(imageURIs);
      _server.requestImage(_index);
      _server.addEventListener(ImageLoadedEvent.IMAGE_LOADED, imageLoadedListener);
      
      addChild(_sprite = new Sprite());
      _sprite.mouseEnabled = false;
      _sprite.mouseChildren = false;
      addChild(_overlay = new Sprite());
      addChild(_outputDisplay);
      _outputDisplay.mouseEnabled = false;
      _outputDisplay.mouseChildren = false;
      
      stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEventListener);
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    private function imageLoadedListener(event:ImageLoadedEvent):void
    {
      if (!event.bitmap)
        return;
      
      update(event.bitmap);
    }
    
    protected function update(bitmap:Bitmap):void
    {
      if (!bitmap)
        return;
      
      _currentBitmap = bitmap;
      
      while(_sprite.numChildren > 0)
      {
        var old:DisplayObject = _sprite.removeChildAt(0);
        if (old is Bitmap)
        {
          var oldBitmap:Bitmap = old as Bitmap;
          oldBitmap.bitmapData.dispose();
        }
      }
      _sprite.addChild(bitmap);
      
      _overlay.graphics.clear();
      while(_overlay.numChildren > 0)
        _overlay.removeChildAt(0);
      
      process();
    }
    
    protected function process():void
    {
      
    }
    
    protected function keyboardEventListener(event:KeyboardEvent):void
    {
      var count:uint, newIndex:int;
      
      switch(event.type)
      {
        case KeyboardEvent.KEY_DOWN:
        {
          switch(event.keyCode)
          {
//            case 13: // Enter
//              trace("Index:",  _index);
//              break;
            
            case 219: // [
              //case 37:	// Left
              newIndex = _index - (event.shiftKey ? 5 : 1);
              newIndex = Math.max(newIndex, 0);
              if (newIndex != _index)
              {
                _index = newIndex;
                _server.requestImage(_index);
              }
              break;
            
            case 221: // ]
              //case 39:	// Right
              newIndex = _index + (event.shiftKey ? 5 : 1);
              newIndex = Math.min(newIndex, _server.count - 1);
              if (newIndex != _index)
              {
                _index = newIndex;
                _server.requestImage(_index);
              }
              break;
          }
        }
      }
    }
    
    protected function out(index:uint, ...parameters):void
    {
      _outputDisplay.out(index, parameters.join(" ")); 
    }
  }
}