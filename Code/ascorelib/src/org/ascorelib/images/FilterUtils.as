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
  //	Imports
  // --------------------------------------------------------------------------
  import flash.display.BitmapData;
  import flash.display.Shader;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.BlurFilter;
  import flash.filters.ConvolutionFilter;
  import flash.filters.ShaderFilter;
  import flash.geom.Point;
  import flash.utils.ByteArray;
  
  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public final class FilterUtils
  {
    // ========================================================================
    //  Embedded Resources
    // ------------------------------------------------------------------------
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH03.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH3:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV03.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV3:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH05.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH5:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV05.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV5:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH07.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH7:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV07.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV7:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH09.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH9:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV09.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV9:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH11.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH11:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV11.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV11:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH13.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH13:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV13.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV13:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH15.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH15:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV15.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV15:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH17.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH17:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV17.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV17:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH19.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH19:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV19.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV19:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH21.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH21:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV21.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV21:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH23.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH23:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV23.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV23:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH25.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH25:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV25.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV25:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH27.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH27:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV27.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV27:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH29.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH29:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV29.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV29:Class;
    
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricH31.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionH31:Class;
    [Embed(source="/../res/kernels/out/ConvolutionSymmetricV31.pbj", mimeType="application/octet-stream")]
    protected static const SymmetricConvolutionV31:Class;
    
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const SHADER_H_3:Shader = new Shader(new SymmetricConvolutionH3() as ByteArray);
    public static const SHADER_V_3:Shader = new Shader(new SymmetricConvolutionV3() as ByteArray);
    
    public static const SHADER_H_5:Shader = new Shader(new SymmetricConvolutionH5() as ByteArray);
    public static const SHADER_V_5:Shader = new Shader(new SymmetricConvolutionV5() as ByteArray);
    
    public static const SHADER_H_7:Shader = new Shader(new SymmetricConvolutionH7() as ByteArray);
    public static const SHADER_V_7:Shader = new Shader(new SymmetricConvolutionV7() as ByteArray);
    
    public static const SHADER_H_9:Shader = new Shader(new SymmetricConvolutionH9() as ByteArray);
    public static const SHADER_V_9:Shader = new Shader(new SymmetricConvolutionV9() as ByteArray);
    
    public static const SHADER_H_11:Shader = new Shader(new SymmetricConvolutionH11() as ByteArray);
    public static const SHADER_V_11:Shader = new Shader(new SymmetricConvolutionV11() as ByteArray);
    
    public static const SHADER_H_13:Shader = new Shader(new SymmetricConvolutionH13() as ByteArray);
    public static const SHADER_V_13:Shader = new Shader(new SymmetricConvolutionV13() as ByteArray);
    
    public static const SHADER_H_15:Shader = new Shader(new SymmetricConvolutionH15() as ByteArray);
    public static const SHADER_V_15:Shader = new Shader(new SymmetricConvolutionV15() as ByteArray);
    
    public static const SHADER_H_17:Shader = new Shader(new SymmetricConvolutionH17() as ByteArray);
    public static const SHADER_V_17:Shader = new Shader(new SymmetricConvolutionV17() as ByteArray);
    
    public static const SHADER_H_19:Shader = new Shader(new SymmetricConvolutionH19() as ByteArray);
    public static const SHADER_V_19:Shader = new Shader(new SymmetricConvolutionV19() as ByteArray);
    
    public static const SHADER_H_21:Shader = new Shader(new SymmetricConvolutionH21() as ByteArray);
    public static const SHADER_V_21:Shader = new Shader(new SymmetricConvolutionV21() as ByteArray);
    
    public static const SHADER_H_23:Shader = new Shader(new SymmetricConvolutionH23() as ByteArray);
    public static const SHADER_V_23:Shader = new Shader(new SymmetricConvolutionV23() as ByteArray);
    
    public static const SHADER_H_25:Shader = new Shader(new SymmetricConvolutionH25() as ByteArray);
    public static const SHADER_V_25:Shader = new Shader(new SymmetricConvolutionV25() as ByteArray);
    
    public static const SHADER_H_27:Shader = new Shader(new SymmetricConvolutionH27() as ByteArray);
    public static const SHADER_V_27:Shader = new Shader(new SymmetricConvolutionV27() as ByteArray);
    
    public static const SHADER_H_29:Shader = new Shader(new SymmetricConvolutionH29() as ByteArray);
    public static const SHADER_V_29:Shader = new Shader(new SymmetricConvolutionV29() as ByteArray);
    
    public static const SHADER_H_31:Shader = new Shader(new SymmetricConvolutionH31() as ByteArray);
    public static const SHADER_V_31:Shader = new Shader(new SymmetricConvolutionV31() as ByteArray);
    
    private static const ORIGIN:Point = new Point();
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function gaussianBlur(src:BitmapData, dst:BitmapData, sigma:Number):void
    {
      var kernel:Vector.<Number> = createNormalizedHalf1DGaussianKernel(sigma);
      convolve2DSymmetric(src, dst, kernel);
    }
    
    public static function magicBlur(src:BitmapData, dst:BitmapData, scale:Number):void
    {
      var kernel:Vector.<Number> = createNormalizedHalfMagicKernel(scale);
      convolve2DSymmetric(src, dst, kernel);
    }
    
    public static function convolve2DSymmetric(src:BitmapData, dst:BitmapData, halfKernel:Vector.<Number>):void
    {
      var length:uint = halfKernel.length;
      var size:uint = (halfKernel.length - 1) * 2 + 1;
      
      var weights1:Array = [];
      var weights2:Array = [];
      var weights3:Array = [];
      var weights4:Array = [];
      
      var start:uint = 0;
      var end:uint = start + 4;
      for (var i:uint = start; i < length && i < end; ++i) {
        weights1[i] = halfKernel[i];
      }
      start = end;
      end += 4;
      for (i = start; i < length && i < end; ++i) {
        weights2[i - start] = halfKernel[i];
      }
      start = end;
      end += 4;      
      for (i = start; i < length && i < end; ++i) {
        weights3[i - start] = halfKernel[i];
      }
      start = end;
      end += 4;      
      for (i = start; i < length && i < end; ++i) {
        weights4[i - start] = halfKernel[i];
      } 
      
      var s0:Shader;
      var s1:Shader;
      switch(size) {
        case 1:
        default:
          return;
          
        case 3: s0 = SHADER_H_3; s1 = SHADER_V_3; break;
        case 5: s0 = SHADER_H_5; s1 = SHADER_V_5; break;
        case 7: s0 = SHADER_H_7; s1 = SHADER_V_7; break;
        case 9: s0 = SHADER_H_9; s1 = SHADER_V_9; break;
        case 11: s0 = SHADER_H_11; s1 = SHADER_V_11; break;
        case 13: s0 = SHADER_H_13; s1 = SHADER_V_13; break;
        case 15: s0 = SHADER_H_15; s1 = SHADER_V_15; break;
        case 17: s0 = SHADER_H_17; s1 = SHADER_V_17; break;
        case 19: s0 = SHADER_H_19; s1 = SHADER_V_19; break;
        case 21: s0 = SHADER_H_21; s1 = SHADER_V_21; break;
        case 23: s0 = SHADER_H_23; s1 = SHADER_V_23; break;
        case 25: s0 = SHADER_H_25; s1 = SHADER_V_25; break;
        case 27: s0 = SHADER_H_27; s1 = SHADER_V_27; break;
        case 29: s0 = SHADER_H_29; s1 = SHADER_V_29; break;
        case 31: s0 = SHADER_H_31; s1 = SHADER_V_31; break;
      }
      
      switch(size) {
        case 31:
        case 29:
        case 27:
        case 25:
          s0.data["weights4"].value = weights4;
          s1.data["weights4"].value = weights4;
          
        case 23:
        case 21:
        case 19:
        case 17:
          s0.data["weights3"].value = weights3;
          s1.data["weights3"].value = weights3;
          
        case 15:
        case 13:
        case 11:
        case 9:
          s0.data["weights2"].value = weights2;
          s1.data["weights2"].value = weights2;
          
        case 7:
        case 5:
        case 3:
        case 1:
          s0.data["weights"].value = weights1;
          s1.data["weights"].value = weights1;
      }
      
      applyFilters(src, dst, s0, s1);
    }
    
    private static function applyFilters(src:BitmapData, dst:BitmapData, s0:Shader, s1:Shader):void {
      var w:uint = src.width;
      var h:uint = src.height;
      var shaderFilterH:ShaderFilter = new ShaderFilter(s0);
      s0.data["size"].value = [w, h];
      var shaderFilterV:ShaderFilter = new ShaderFilter(s1);
      s1.data["size"].value = [w, h];
      dst.applyFilter(src, src.rect, ORIGIN, shaderFilterH);
      dst.applyFilter(dst, dst.rect, ORIGIN, shaderFilterV);
    }
    
    public static function create1DGaussianKernel( sigma:Number ):Vector.<Number>
    {
      var x:int;
      
      const sigmaSquared:Number = sigma * sigma;
      const denom1:Number = 2 * sigmaSquared;
      const scale:Number = 1 / Math.sqrt(2 * Math.PI) * sigma;
      
      const kernelHalfWidth:uint = Math.round(3 * sigma);
      const kernelSize:uint = kernelHalfWidth + kernelHalfWidth + 1;
      
      var kernel:Vector.<Number> = new Vector.<Number>(kernelSize + 1, true);
      var sum:Number = 0;
      for (x = -kernelHalfWidth; x <= kernelHalfWidth; ++x) {
        var value:Number = scale * Math.exp(-(x * x) / denom1);
        sum += value;
        kernel[ x + kernelHalfWidth ] = value;
      }
      
      kernel[ kernelSize ] = sum
      return kernel;
    }
    
    public static function createHalf1DGaussianKernel( sigma:Number ):Vector.<Number>
    {
      var x:uint;
      
      const sigmaSquared:Number = sigma * sigma;
      const denom1:Number = 2 * sigmaSquared;
      const scale:Number = 1 / Math.sqrt(2 * Math.PI) * sigma;
      
      const kernelHalfWidth:uint = Math.round(3 * sigma);
      const kernelSize:uint = kernelHalfWidth + 1;
      
      var kernel:Vector.<Number> = new Vector.<Number>(kernelSize, true);
      var sum:Number = scale;
      kernel[0] = scale;
      for (x = 1; x <= kernelHalfWidth; ++x) {
        var value:Number = scale * Math.exp(-(x * x) / denom1);
        sum += 2 * value;
        kernel[ x ] = value;
      }
      
      for (x = 0; x < kernelHalfWidth; ++x) {
        kernel[x] /= sum;
      }
      
      return kernel;
    }
    
    public static function createNormalized1DGaussianKernel( sigma:Number ):Vector.<Number>
    {
      var x:int;
      
      const sigmaSquared:Number = sigma * sigma;
      const denom1:Number = 2 * sigmaSquared;
      const scale:Number = 1 / Math.sqrt(2 * Math.PI) * sigma;
      
      const kernelHalfWidth:uint = Math.round(3 * sigma);
      const kernelSize:uint = 2 * kernelHalfWidth + 1;
      
      var kernel:Vector.<Number> = new Vector.<Number>(kernelSize, true);
      var sum:Number = 0;
      for (x = -kernelHalfWidth; x <= kernelHalfWidth; ++x) {
        var value:Number = scale * Math.exp(-(x * x) / denom1);
        sum += value;
        kernel[ x + kernelHalfWidth ] = value;
      }
      
      for (x = 0; x < kernelSize; ++x) {
        kernel[x] /= sum;
      }
      
      return kernel;
    }
    
    public static function createNormalizedHalfMagicKernel(sigma:Number):Vector.<Number>
    {
      var x:int;
      
      const sigmaSquared:Number = sigma * sigma;
      const denom1:Number = 2 * sigmaSquared;
      const scale:Number = 1 / Math.sqrt(2 * Math.PI) * sigma;
      
      const kernelHalfWidth:uint = Math.round(3 * sigma);
      const kernelSize:uint = kernelHalfWidth + 1;  
      
      var kernel:Vector.<Number> = new Vector.<Number>(kernelSize, true);
      kernel[0] = scale;
      var sum:Number = scale;
      for (x = 1; x <= kernelHalfWidth; ++x) {
        var value:Number = scale * Math.exp(-(x * x) / denom1);
        sum += 2 * value;
        kernel[x] = value;
      }
      
      for (x = 0; x < kernelSize; ++x) {
        kernel[x] /= sum;
      }
      
      return kernel;
    }
    
    public static function createNormalizedHalf1DGaussianKernel( sigma:Number ):Vector.<Number>
    {
      var x:int;
      
      const sigmaSquared:Number = sigma * sigma;
      const denom1:Number = 2 * sigmaSquared;
      const scale:Number = 1 / Math.sqrt(2 * Math.PI) * sigma;
      
      const kernelHalfWidth:uint = Math.round(3 * sigma);
      const kernelSize:uint = kernelHalfWidth + 1;  
      
      var kernel:Vector.<Number> = new Vector.<Number>(kernelSize, true);
      kernel[0] = scale;
      var sum:Number = scale;
      for (x = 1; x <= kernelHalfWidth; ++x) {
        var value:Number = scale * Math.exp(-(x * x) / denom1);
        sum += 2 * value;
        kernel[x] = value;
      }
      
      for (x = 0; x < kernelSize; ++x) {
        kernel[x] /= sum;
      }
      
      return kernel;
    }
    
    public static function blur(src:BitmapData, dst:BitmapData, sigma:Number):void
    {
      if (sigma < 1) {
        // Works in range (1, 2.49]
        var kernel:Vector.<Number> = create1DGaussianKernel(sigma);
        var size:uint = kernel.length - 1;
        var sum:Number = kernel[size];
        var matrix:Array = [];
        matrix.length = size;
        for (var x:int = 0; x < size; ++x) {
          matrix[x] = kernel[x];
        }
        
        var hConvolution:ConvolutionFilter = new ConvolutionFilter(
          1, size, matrix, sum, 0, true, true, 0x0, 0);
        dst.applyFilter(src, src.rect, ORIGIN, hConvolution);
        
        var vConvolution:ConvolutionFilter = new ConvolutionFilter(
          1, size, matrix, sum, 0, true, true, 0x0, 0);
        dst.applyFilter(dst, dst.rect, ORIGIN, vConvolution);
      } else {
        // Flash BlurFilter doesn't work with radii less than 1.1
        var blurFilter:BlurFilter = new BlurFilter(
          sigma * 2, sigma * 2, BitmapFilterQuality.HIGH);
        dst.applyFilter(src, src.rect, ORIGIN, blurFilter);
      }
    }
    
    public static function boxBlur(src:BitmapData, dst:BitmapData, size:uint):void
    {
      var matrix:Array = [];
      matrix.length = size;
      for (var x:int = 0; x < size; ++x) {
        matrix[x] = 1;
      }
      
      var hConvolution:ConvolutionFilter = new ConvolutionFilter(
        1, size, matrix, size, 0, true, true, 0x0, 0);
      dst.applyFilter(src, src.rect, ORIGIN, hConvolution);
      
      var vConvolution:ConvolutionFilter = new ConvolutionFilter(
        1, size, matrix, size, 0, true, true, 0x0, 0);
      dst.applyFilter(dst, dst.rect, ORIGIN, vConvolution);
    }
    
    public static function boxFilter(src:ByteArray, width:uint, height:uint, kernel_size:uint, iterations:uint, dst:ByteArray):void
    {
      var temp:ByteArray = new ByteArray();
      temp.length = src.length;
      
      for (var i:uint = 0; i < iterations; ++i) {
        boxFilterConvolution(true, (i == 0) ? src : dst, width, height, kernel_size, temp);
        boxFilterConvolution(false, temp, width, height, kernel_size, dst);
      }
    }
    
    private static function boxFilterConvolution(is_horizontal:Boolean, src:ByteArray, width:uint, height:uint, kernel_size:uint, dst:ByteArray):void
    {
      var channels:uint = 4;
      const radius:uint = (kernel_size - 1) / 2;
      
      const bounds_u:uint = is_horizontal ? width : height;
      const bounds_v:uint = is_horizontal ? height : width;
      const stride_u:uint = is_horizontal ? channels : width * channels;
      const stride_v:uint = is_horizontal ? width * channels : channels;
      
      const scale:Number = 1.0 / kernel_size;
      
      var offset:int = 0;
      for (var v:int = 0; v < bounds_v; ++v) {
        var total_r:uint = 0;
        var total_g:uint = 0;
        var total_b:uint = 0;
        var count:uint = 0;
        
        // Initialize the offsets to the offset of the first pixel in v.
        var src_offset:uint = offset;
        var dst_offset:uint = offset;
        var out_offset:uint = offset;
        
        var u:uint = 0;
        for (; u < radius; ++u) {
          count++;
          total_r += src[src_offset + 1];
          total_g += src[src_offset + 2];
          total_b += src[src_offset + 3];
          src_offset += stride_u;
        }
        for (; u < kernel_size; ++u)
        {
          count++;
          total_r += src[src_offset + 1];
          total_g += src[src_offset + 2];
          total_b += src[src_offset + 3];
          src_offset += stride_u;
          
          dst[dst_offset + 1] = total_r / count;
          dst[dst_offset + 2] = total_g / count;
          dst[dst_offset + 3] = total_b / count;
          dst_offset += stride_u;
        }
        for (; u < bounds_u; ++u)
        {
          total_r += src[src_offset + 1];
          total_g += src[src_offset + 2];
          total_b += src[src_offset + 3];
          src_offset += stride_u;
          
          total_r -= src[out_offset + 1];
          total_g -= src[out_offset + 2];
          total_b -= src[out_offset + 3];
          out_offset += stride_u;
          
          dst[dst_offset + 1] = total_r * scale;
          dst[dst_offset + 2] = total_g * scale;
          dst[dst_offset + 3] = total_b * scale;
          dst_offset += stride_u;
        }
        for (; u < bounds_u + radius; ++u)
        {
          count--;
          total_r -= src[out_offset + 1];
          total_g -= src[out_offset + 2];
          total_b -= src[out_offset + 3];
          out_offset += stride_u;
          
          dst[dst_offset + 1] = total_r / count;
          dst[dst_offset + 2] = total_g / count;
          dst[dst_offset + 3] = total_b / count;
          dst_offset += stride_u;
        }
        
        offset += stride_v;
      }
    }
  }
}
