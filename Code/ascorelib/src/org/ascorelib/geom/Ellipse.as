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
package org.ascorelib.geom
{
  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public final class Ellipse
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const DEG2RAD:Number = Math.PI / 180;
    
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var radius_x:Number;
    public var radius_y:Number;
    public var center_x:Number;
    public var center_y:Number;
    public var angle:Number;
    public var cos_angle:Number;
    public var sin_angle:Number;
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function Ellipse(rx:Number, ry:Number, cx:Number, cy:Number, a:Number)
    {
      radius_x = rx;
      radius_y = ry;
      center_x = cx;
      center_y = cy
      angle = a;
      
      if (radius_x < .1) {
        radius_x = .1;
      }
      if (radius_y < .1) {
        radius_y = .1;
      }
      
      cos_angle = Math.cos(angle * DEG2RAD);
      sin_angle = Math.sin(angle * DEG2RAD);
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function isInside(x:Number, y:Number):Boolean {
      var dx:Number = x - center_x;
      var dy:Number = y - center_y;
      var nx:Number = dx * cos_angle + dy * sin_angle;
      var ny:Number = dx * -sin_angle + dy * cos_angle;
      return (nx*nx) / (radius_x*radius_x)
        + (ny*ny) / (radius_y*radius_y) <= 1;
    }
  }
}