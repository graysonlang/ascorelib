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
  //	Imports
  // --------------------------------------------------------------------------
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  
  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public class Handle extends Sprite
  {
    // ========================================================================
    //	Properties
    // ------------------------------------------------------------------------
    protected var _color:uint;
    protected var _radius:Number;
    
    // ========================================================================
    //	Constructor
    // ------------------------------------------------------------------------
    public function Handle(container:DisplayObjectContainer, x:Number = 0, y:Number = 0, color:uint = 0x336699, radius:Number = 4)
    {
      super();
      this.x = x;
      this.y = y;
      this._radius = radius;
      this._color = color;
      draw();
    }
    
    // ========================================================================
    //	Methods
    // ------------------------------------------------------------------------
    protected function draw():void
    {
      graphics.clear();
      graphics.beginFill(this._color);
      graphics.drawCircle(0, 0, this._radius);
      graphics.endFill();
    }
  }
}
