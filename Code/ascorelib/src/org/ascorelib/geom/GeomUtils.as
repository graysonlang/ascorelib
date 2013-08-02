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
  //  Class
  // --------------------------------------------------------------------------
  public final class GeomUtils
  {
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------    
    public static function distanceSquared3(r1:Number, g1:Number, b1:Number, r2:Number, g2:Number, b2:Number) : Number {
      var dr:Number = r2 - r1;
      var dg:Number = g2 - g1;
      var db:Number = b2 - b1;
      return dr * dr + dg * dg + db * db;
    }
    
    public static function distancePointLine(x:Number, y:Number, l0x:Number, l0y:Number, l1x:Number, l1y:Number):Number
    {
      var a:Number = l0y - l1y;
      var b:Number = l1x - l0x;
      var c:Number = l0x * l1y - l0y * l1x;
      return Math.abs(a * x + b * y + c) / Math.sqrt(a * a + b * b);
    };
    
    public static function intersectLineLine(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number):Vector.<Number>
    {
      var dx1:Number = (x1 - x2);
      var dx2:Number = (x3 - x4);
      var dy1:Number = (y1 - y2);
      var dy2:Number = (y3 - y4);
      var dxy1:Number = (x1 * y2 - y1 * x2);
      var dxy2:Number = (x3 * y4 - y3 * x4);
      
      var determinant_numerator_1:Number = dxy1 * dx2 - dx1 * dxy2;
      var determinant_numerator_2:Number = dxy1 * dy2 - dy1 * dxy2;
      var determinant_denominator:Number = dx1 * dy2 - dy1 * dx2;
      
      if (determinant_denominator != 0)
      {
        return new <Number>[
          determinant_numerator_1 / determinant_denominator,
          determinant_numerator_2 / determinant_denominator
        ];
      }
      return new <Number>[Number.NaN, Number.NaN];
    }
    
    public static function boundEllipse(center_x:Number, center_y:Number, radius_x:Number, radius_y:Number, angle:Number, w:Number, h:Number, result:Vector.<Number>):void {
      // flip angle since this is in screen-coordinates (i.e. y=0 at top)
      //angle = -angle;
      //trace( "angle:", angle * RAD2DEG );
      
      var ca:Number = Math.cos(angle);
      var sa:Number = Math.sin(angle);
      
      // If ry is larger than rx, swap radii and rotate.
      if (radius_x < radius_y) {
        var temp:Number = radius_x;
        radius_x = radius_y;
        radius_y = temp;
        angle += Math.PI / 2;
        //            temp = ca;
        //            ca = sa;
        //            sa = -temp;
      }
      
      // Calculate distance from center to focus.
      var cfd:Number = Math.sqrt(radius_x * radius_x - radius_y * radius_y);
      
      // Calculate position of rightmost focus.
      //          var focus_x:Number = cfd * ca;//Math.cos(angle);
      //          var focus_y:Number = cfd * sa;//Math.sin(angle);
      
      var focus_x:Number = cfd * Math.cos(angle);
      var focus_y:Number = cfd * Math.sin(angle);
      
      //      trace( "cfd:", cfd );
      //      trace( "angle:", angle * RAD2DEG );
      
      // Coefficients.
      var coefficient_a:Number = radius_x * radius_x - focus_x * focus_x;
      var coefficient_b:Number = radius_x * radius_x - focus_y * focus_y;
      
      // Critical points.
      var top:Number = Math.ceil(Math.sqrt(coefficient_a));
      var right:Number = Math.ceil(Math.sqrt(coefficient_b));
      
      //      trace( "radius_x:", radius_x, "radius_y:", radius_y );
      //      trace( "focus_x:", focus_x, "focus_y:", focus_y );
      //      trace( "a:", coefficient_a, "b:", coefficient_b );
      //      trace( "right:", right, "top:", top );
      
      var bounds_l:int = center_x - right - 1;
      var bounds_r:int = center_x + right + 1;
      
      var bounds_t:int = center_y - top - 1;
      var bounds_b:int = center_y + top + 1;
      
      //      trace( "x_min:", bounds_l, "x_max:", bounds_r );
      //      trace( "y_min:", bounds_t, "y_max:", bounds_b );
      
      //          var bounds_w:int = center_x + right - bounds_l + 2;
      //          var bounds_h:int = bounds_b - bounds_t;
      
      // Clamp bounds to image;
      result[0] = Math.min(w, Math.max(0, bounds_l));
      result[1] = Math.min(w, Math.max(0, bounds_r));
      result[2] = Math.min(h, Math.max(0, bounds_t));
      result[3] = Math.min(h, Math.max(0, bounds_b));
      
      //      bounds_l;
      //      bounds_r;
      //      bounds_t;
      //      bounds_b;
    }
  }
}