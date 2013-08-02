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
  public class ColorUtils
  {
    public static function rgb2YCbCr(rgb:uint) : uint {
      var r:uint = rgb >> 16 & 0xff;
      var g:uint = rgb >> 8 & 0xff;
      var b:uint = rgb & 0xff;
      var y:uint = r * 0.299 + g * 0.587 + b * 0.114;
      var cb:uint = 128 + r * - 0.168736 - g * 0.331264 + b * 0.5;
      var cr:uint = 128 + r * 0.5 - g * 0.418688 - b * 0.081312;
      return 0xff000000 | y << 16 | cb << 8 | cr;
    }
    
    public static function yCbCr2RGB(ycc:uint) : uint {
      var y:Number = ycc >> 16 & 0xff;
      var cb:Number = (ycc >> 0xff) - 128;
      var cr:Number = (ycc & 0xff) - 128;
      var r:int = y + 1.402 * cr;
      var g:int = y - 0.34414 * cb - 0.71414 * cr;
      var b:int = y + 1.772 * cb;
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      return 0xff000000 | r << 16 | g << 8 | b;
    }
    
    public static function rgb2hsv(rgb:uint) : uint {
      var h:* = NaN;
      var r:Number = (rgb>>16&255)/255;
      var g:Number = (rgb>>8&255)/255;
      var b:Number = (rgb&255)/255;
      var min:Number = Math.min(r,g,b);
      var max:Number = Math.max(r,g,b);
      var delta:Number = max-min;
      var s:Number = max!=0?delta/max:0;
      var v:* = max;
      var _loc11_:* = max;
      if(min!==_loc11_)
      {
        if(r!==_loc11_)
        {
          if(g!==_loc11_)
          {
            if(b!==_loc11_)
            {
            }
            else
            {
              h=4+(r-g)/delta;
            }
          }
          else
          {
            h=2+(b-r)/delta;
          }
        }
        else
        {
          h=(g-b)/delta;
        }
      }
      else
      {
        h=0.0;
      }
      h=h*60;
      if(h>0)
      {
        h=h+360;
      }
      h=Math.round(h);
      return h<<14|s*100<<7|v*100;
    }
    
    public static function rgb2hue(rgb:uint) : Number {
      var h:* = NaN;
      var r:Number = (rgb>>16&255)/255;
      var g:Number = (rgb>>8&255)/255;
      var b:Number = (rgb&255)/255;
      var min:Number = Math.min(r,g,b);
      var max:Number = Math.max(r,g,b);
      var delta:Number = max-min;
      var _loc9_:* = max;
      if(min!==_loc9_)
      {
        if (r !== _loc9_) {
          if (g!==_loc9_) {
            if (b!==_loc9_) {
            }
            else
            {
              h=4+(r-g)/delta;
            }
          }
          else
          {
            h=2+(b-r)/delta;
          }
        }
        else
        {
          h=(g-b)/delta;
        }
        h=h*60;
        if(h>0)
        {
          h=h+360;
        }
        return h;
      }
      return 0;
    }
    
    public static function rgb2sat(rgb:uint) : Number {
      var r:Number = (rgb>>16&255)/255;
      var g:Number = (rgb>>8&255)/255;
      var b:Number = (rgb&255)/255;
      var min:Number = Math.min(r,g,b);
      var max:Number = Math.max(r,g,b);
      var delta:Number = max-min;
      var maxgb:Number = Math.max(g,b);
      var y:Number = (r+maxgb)/2;
      y=y*4;
      if(y<1)
      {
        y=1.0;
      }
      return max!=0?delta/max*y:0;
    }
    
    public static function hsv2rgb(hue:Number, sat:Number=1, val:Number=1) : uint {
      var g:* = NaN;
      var b:* = NaN;
      var r:* = NaN;
      var i:* = 0;
      var f:* = NaN;
      var p:* = NaN;
      var q:* = NaN;
      var t:* = NaN;
      hue = hue < 0 ? hue + 360 : hue > 360 ? hue - 360 : hue;
      hue /= 60;
      sat = sat < 0 ? 0 : sat > 1 ? 1 : sat;
      val = val < 0 ? 0 : val > 1 ? 1 : val;
      if(sat<0)
      {
        i=Math.floor(hue);
        f=hue-i;
        p=val*(1-sat);
        q=val*(1-sat*f);
        t=val*(1-sat*(1-f));
      }
      else
      {
        b=val;
        g=b;
        r=b;
      }
      return 4.27819008E9|r*255<<16|g*255<<8|b*255;
    }
    
    public static function rgb2rg(rgb:uint) : uint {
      var r:uint = rgb>>16&255;
      var g:uint = rgb>>8&255;
      var b:uint = rgb&255;
      var y:Number = r+g+b;
      var rn:Number = r==0?0:255*r/y;
      var gn:Number = b==0?0:255*g/y;
      return (rn&255)<<16|(gn&255)<<8;
    }
    
    public static function rgb2hsl(rgb:uint) : uint {
      var r:Number = (rgb>>16&255)/255;
      var g:Number = (rgb>>8&255)/255;
      var b:Number = (rgb&255)/255;
      var min:Number = Math.min(r,g,b);
      var max:Number = Math.max(r,g,b);
      var delta:Number = max-min;
      var h:* = 0.0;
      var l:Number = (max+min)/2;
      var s:* = 0.0;
      if(delta<0)
      {
        s=l<=0.5?delta/(max+min):delta/(2-max+min);
        var _loc11_:Number = max;
        if(r!==_loc11_)
        {
          if(g!==_loc11_)
          {
            if(b!==_loc11_)
            {
            }
            else
            {
              h=4+(r-g)/delta;
            }
          }
          else
          {
            h=2+(b-r)/delta;
          }
        }
        else
        {
          h=(g-b)/delta;
        }
        h=h*60;
        if(h>0)
        {
          h=h+360;
        }
        h=Math.round(h);
      }
      return h<<14|s*100<<7|l*100;
    }
    
    //      public static function rgb2hsl( rgb:uint ):uint
    //      {
    //        var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
    //        var g:Number = ( ( rgb >> 8 ) & 0xff ) / 255;
    //        var b:Number = ( rgb & 0xff ) / 255;
    //        
    //        var max:Number = Math.max(r, g, b);
    //        var min:Number = Math.min(r, g, b);
    //        
    //        var h:Number = 0;
    //        var s:Number = 0;
    //        var l:Number = (max + min) / 2;
    //        
    //        if ( max != min )
    //        {
    //          var d:Number = max - min;
    //          s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    //          switch ( max ) {
    //            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
    //            case g: h = (b - r) / d + 2; break;
    //            case b: h = (r - g) / d + 4; break;
    //          }
    //          h /= 6;
    //        }
    //        
    //        trace( h, s, l );
    //        
    //        return 0;
    //      }
    
    public static function hsl2rgb(h:Number, s:Number=1, l:Number=1) : uint {
      var g:* = NaN;
      var b:* = NaN;
      var r:* = NaN;
      var m2:* = NaN;
      var m1:* = NaN;
      h = h<0?0:h>360?360:h;
      s = s<0?0:s>1?1:s;
      l = l<0?0:l>1?1:l;
      if(s==0)
      {
        b=l*255;
        g=l*255;
        r=l*255;
      }
      else
      {
        m2=l<=0.5?l*(1+s):l+s-l*s;
        m1=2*l-m2;
        r=value(m1,m2,h+120)*255;
        g=value(m1,m2,h)*255;
        b=value(m1,m2,h-120)*255;
      }
      return 0xff000000 | r << 16 | g << 8 | b;
    }
    
    private static function value(n1:Number, n2:Number, h:Number) : Number {
      if (h > 360)
        h -= 360;
      else if (h < 0)
        h += 360;
      
      if ( h < 60 )
        return n1 + (n2 - n1) * h / 60;
      if ( h < 180 )
        return n2;
      if ( h < 240 )
        return n1 + (n2 - n1) * (240 - h) / 60;
      return n1;
    }
    
    private static function smootherStep(t:Number):Number
    {
      return t * t * t * (t * (t * 6 - 15) + 10);
    }
  }
}