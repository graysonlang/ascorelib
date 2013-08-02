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
  import flash.display.Shader;
  import flash.filters.ShaderFilter;
  import flash.geom.Point;
  import flash.utils.ByteArray;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class BoxBlur
  {
    // ========================================================================
    //  Embedded Resources
    // ------------------------------------------------------------------------
    [Embed(source="/../res/kernels/out/BoxBlur1x3.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur1x3:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur3x1.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur3x1:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur1x5.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur1x5:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur5x1.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur5x1:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur1x7.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur1x7:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur7x1.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur7x1:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur1x9.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur1x9:Class;
    
    [Embed(source="/../res/kernels/out/BoxBlur9x1.pbj", mimeType="application/octet-stream")]
    protected static const BoxBlur9x1:Class;
    
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const SHADER_1X3:Shader = new Shader(new BoxBlur1x3() as ByteArray);
    public static const SHADER_3X1:Shader = new Shader(new BoxBlur3x1() as ByteArray);
    public static const SHADER_1X5:Shader = new Shader(new BoxBlur1x5() as ByteArray);
    public static const SHADER_5X1:Shader = new Shader(new BoxBlur5x1() as ByteArray);
    public static const SHADER_1X7:Shader = new Shader(new BoxBlur1x7() as ByteArray);
    public static const SHADER_7X1:Shader = new Shader(new BoxBlur7x1() as ByteArray);
    public static const SHADER_1X9:Shader = new Shader(new BoxBlur1x9() as ByteArray);
    public static const SHADER_9X1:Shader = new Shader(new BoxBlur9x1() as ByteArray);
    private static const ORIGIN:Point = new Point();
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    private static function blur(source:BitmapData, s:Shader):BitmapData
    {
      var w:uint = source.width;
      var h:uint = source.height;
      var result:BitmapData = new BitmapData(w,h,false,0);
      s.data["size"].value=[w,h];
      var shaderFilter:ShaderFilter = new ShaderFilter(s);
      result.applyFilter(source,source.rect,ORIGIN,shaderFilter);
      return result;
    }
    
    public static function boxBlur(source:BitmapData, s0:Shader, s1:Shader, iterations:uint = 1):BitmapData
    {
      
      var w:uint = source.width;
      var h:uint = source.height;
      var result:BitmapData = new BitmapData(w, h, false, 0);
      var shaderFilterH:ShaderFilter = new ShaderFilter(s0);
      s0.data["size"].value = [w, h];
      var shaderFilterV:ShaderFilter = new ShaderFilter(s1);
      s1.data["size"].value = [w, h];

      for (var i:uint = 0; i < iterations; ++i)
      {
        result.applyFilter(source,source.rect,ORIGIN,shaderFilterH);
        result.applyFilter(result,source.rect,ORIGIN,shaderFilterV);
      }
      return result;
    }
    
    public static function boxBlurInPlace(source:BitmapData, s0:Shader, s1:Shader, iterations:uint = 1):void
    {
      var w:uint = source.width;
      var h:uint = source.height;
      var shaderFilterH:ShaderFilter = new ShaderFilter(s0);
      s0.data["size"].value=[w,h];
      var shaderFilterV:ShaderFilter = new ShaderFilter(s1);
      s1.data["size"].value=[w,h];
      
      for (var i:uint = 0; i < iterations; ++i)
      {
        source.applyFilter(source,source.rect,ORIGIN,shaderFilterH);
        source.applyFilter(source,source.rect,ORIGIN,shaderFilterV);
        i++;
      }
    }
    
    public static function blur3x1(source:BitmapData) : BitmapData {
      return blur(source,SHADER_3X1);
    }
    
    public static function blur1x3(source:BitmapData) : BitmapData {
      return blur(source,SHADER_1X3);
    }
    
    public static function blur3x3(source:BitmapData, iterations:uint=1) : BitmapData {
      return boxBlur(source,SHADER_1X3,SHADER_3X1,iterations);
    }
    
    public static function blurInPlace3x3(source:BitmapData) : void {
      boxBlurInPlace(source,SHADER_1X3,SHADER_3X1);
    }
    
    public static function blur5x5(source:BitmapData, iterations:uint=1) : BitmapData {
      return boxBlur(source,SHADER_1X5,SHADER_5X1,iterations);
    }
    
    public static function blur7x7(source:BitmapData, iterations:uint=1) : BitmapData {
      return boxBlur(source,SHADER_1X7,SHADER_7X1,iterations);
    }
    
    public static function blur9x9(source:BitmapData, iterations:uint=1) : BitmapData {
      return boxBlur(source,SHADER_1X9,SHADER_9X1,iterations);
    }
  }
}
