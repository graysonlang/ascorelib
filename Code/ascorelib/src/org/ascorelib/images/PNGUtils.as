package org.ascorelib.images
{
  // ==========================================================================
  //  Imports
  // --------------------------------------------------------------------------
  import flash.display.BitmapData;
  import flash.geom.Point;
  import flash.utils.ByteArray;
  import flash.utils.Endian;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class PNGUtils
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const ORIGIN:Point = new Point();
    
    private static const PNG_SIG_1:uint = 0x89504E47; // ".PNG"
    private static const PNG_SIG_2:uint = 0x0D0A1A0A; // 0x0D0A1A0A
    
    // Critical Chunks
    public static const PNG_CHUNK_IHDR:uint = 0x49484452; // "IHDR" - Image header
    public static const PNG_CHUNK_PLTE:uint = 0x504C5445; // "PLTE" - Palette
    public static const PNG_CHUNK_IDAT:uint = 0x49444154; // "IDAT" - Image data
    public static const PNG_CHUNK_IEND:uint = 0x49454e44; // "IEND" - Image trailer
    
    // Ancillary Chunks
    public static const PNG_CHUNK_bKGD:uint = 0x624B4744; // "bKGD" - Background color
    public static const PNG_CHUNK_cHRM:uint = 0x6348524D; // "cHRM" - Primary chromaticities and white point
    public static const PNG_CHUNK_gAMA:uint = 0x67414D41; // "gAMA" - Image gamma
    public static const PNG_CHUNK_hIST:uint = 0x68495354; // "hIST" - Image histogram
    public static const PNG_CHUNK_iCCP:uint = 0x69434350; // "iCCP" - ICC color profile
    public static const PNG_CHUNK_pHYs:uint = 0x70485973; // "pHYs" - Physical pixel dimensions
    public static const PNG_CHUNK_sBIT:uint = 0x73424954; // "sBIT" - Significant bits
    public static const PNG_CHUNK_tEXt:uint = 0x74455874; // "tEXt" - Textual data (i.e. comments)
    public static const PNG_CHUNK_tIME:uint = 0x74494D45; // "tIME" - Image last-modification time
    public static const PNG_CHUNK_tRNS:uint = 0x74524E53; // "tRNS" - Transparency
    public static const PNG_CHUNK_zTXt:uint = 0x7A545874; // "zTXt" - Compressed textual data
    
    private static const IHDR_BIT_DEPTH_1:uint = 1;
    private static const IHDR_BIT_DEPTH_2:uint = 2;
    private static const IHDR_BIT_DEPTH_4:uint = 4;
    private static const IHDR_BIT_DEPTH_8:uint = 8;
    private static const IHDR_BIT_DEPTH_16:uint = 16;
    
    private static const IHDR_COLOR_TYPE_PALETTE_USED:uint = 1;
    private static const IHDR_COLOR_TYPE_COLOR_USED:uint = 2;
    private static const IHDR_COLOR_TYPE_ALPHA_USED:uint = 4;
    
    // deflate/inflate compression with 32K sliding window
    private static const IHDR_COMPRESSION_METHOD_STANDARD:uint = 0;
    
    private static const IHDR_FILTER_METHOD_ADAPTIVE:uint = 0;
    
    private static const IHDR_INTERLACE_METHOD_NONE:uint = 0;
    private static const IHDR_INTERLACE_METHOD_ADAM7:uint = 1;
    
    private static const pHYs_PIXELS_PER_METER_72:uint = 2835;
    
    private static const pHYs_UNIT_SPECIFIER_UNKNOWN:uint = 0;
    private static const pHYs_UNIT_SPECIFIER_METER:uint = 1;
    
    // sRGB chromaticities (with D65 reference white point)
    // White point values are truncated versions of CIR 1931 based on ITU-R Rec. 709
    private static const SRGB_CHROMA_WHITE_POINT_X:Number = .3127; // originally 0.31271
    private static const SRGB_CHROMA_WHITE_POINT_Y:Number = .3290; // originally 0.32902
    private static const SRGB_CHROMA_RED_X:Number = .64;
    private static const SRGB_CHROMA_RED_Y:Number = .33;
    private static const SRGB_CHROMA_GREEN_X:Number = .3;
    private static const SRGB_CHROMA_GREEN_Y:Number = .6;
    private static const SRGB_CHROMA_BLUE_X:Number = .15;
    private static const SRGB_CHROMA_BLUE_Y:Number = .06;
    
    private static const cHRM_WHITE_POINT_X_SRGB:uint = Math.round(100000 * SRGB_CHROMA_WHITE_POINT_X);
    private static const cHRM_WHITE_POINT_Y_SRGB:uint = Math.round(100000 * SRGB_CHROMA_WHITE_POINT_Y);
    private static const cHRM_RED_X_SRGB:uint = Math.round(100000 * SRGB_CHROMA_RED_X);
    private static const cHRM_RED_Y_SRGB:uint = Math.round(100000 * SRGB_CHROMA_RED_Y);
    private static const cHRM_GREEN_X_SRGB:uint = Math.round(100000 * SRGB_CHROMA_GREEN_X);
    private static const cHRM_GREEN_Y_SRGB:uint = Math.round(100000 * SRGB_CHROMA_GREEN_Y);
    private static const cHRM_BLUE_X_SRGB:uint = Math.round(100000 * SRGB_CHROMA_BLUE_X);
    private static const cHRM_BLUE_Y_SRGB:uint = Math.round(100000 * SRGB_CHROMA_BLUE_Y);
    
    private static const CRC_TABLE:Vector.<uint> = initCRCTable();
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function encode(bitmapData:BitmapData):ByteArray
    {
      var bytes:ByteArray
      bytes.endian = Endian.BIG_ENDIAN;
      
      var width:uint = bitmapData.width;
      var height:uint = bitmapData.height;
      
      var alphaTest:BitmapData = new BitmapData(width, height, true, 0x0);
      var pixelCount:uint = alphaTest.threshold(bitmapData, bitmapData.rect, ORIGIN, "<", 0xFF000000, 0x0, 0xFF000000, false);
      var hasAlpha:Boolean = pixelCount > 0;
      
      var colorType:uint = (hasAlpha ? IHDR_COLOR_TYPE_ALPHA_USED : 0) | IHDR_COLOR_TYPE_COLOR_USED;
      
      // Write PNG file signature
      bytes.writeUnsignedInt(PNG_SIG_1);
      bytes.writeUnsignedInt(PNG_SIG_2);
      
      // Write IHDR chunk
      writeChunk_IHDR(bytes, width, height, colorType);
      
      // Write pHYs chunk
      writeChunk_pHYs(bytes);
      
      return bytes;
    }
    
    public static function decode(bytes:ByteArray):BitmapData
    {
      var result:BitmapData;
      
      return result;
    }
    
    private static function writeChunk_IHDR(bytes:ByteArray, width:uint, height:uint, colorType:uint = IHDR_COLOR_TYPE_COLOR_USED, depth:uint = IHDR_BIT_DEPTH_8):void
    {
      var chunk:ByteArray = new ByteArray();
      
      // Width: 4 bytes
      chunk.writeUnsignedInt(width);
      
      // Height: 4 bytes
      chunk.writeUnsignedInt(height);
      
      // Bit depth: 1 byte
      chunk.writeByte(depth);
      
      // Color type: 1 byte
      chunk.writeByte(colorType);
      
      // Compression method: 1 byte
      chunk.writeByte(IHDR_COMPRESSION_METHOD_STANDARD); 
      
      // Filter method - 1 byte
      chunk.writeByte(IHDR_FILTER_METHOD_ADAPTIVE);
      
      // Interlace method - 1 byte
      chunk.writeByte(IHDR_INTERLACE_METHOD_NONE);
      
      writeChunk(PNG_CHUNK_IHDR, chunk, bytes);
    }
    
    private static function writeChunk_pHYs(bytes:ByteArray):void
    {
      var chunk:ByteArray = new ByteArray();
      
      // Pixels per unit, X axis: 4 bytes
      chunk.writeUnsignedInt(pHYs_PIXELS_PER_METER_72);
      
      // Pixels per unit, Y axis: 4 bytes
      chunk.writeUnsignedInt(pHYs_PIXELS_PER_METER_72);
      
      // Unit specifier: 1 byte
      chunk.writeByte(pHYs_UNIT_SPECIFIER_METER);
      
      writeChunk(PNG_CHUNK_pHYs, chunk, bytes);
    }
    
    private static function writeChunk_cHRM(bytes:ByteArray):void
    {
      var chunk:ByteArray = new ByteArray();
      
      // Each value is encoded as a 4-byte unsigned integer,
      // representing the x or y value times 100000.  For example, a
      // value of 0.3127 would be stored as the integer 31270.
      
      // White Point x: 4 bytes
      chunk.writeUnsignedInt(cHRM_WHITE_POINT_X_SRGB);
      
      // White Point y: 4 bytes
      chunk.writeUnsignedInt(cHRM_WHITE_POINT_Y_SRGB);
      
      // Red x: 4 bytes
      chunk.writeUnsignedInt(cHRM_RED_X_SRGB);
      
      // Red y: 4 bytes
      chunk.writeUnsignedInt(cHRM_RED_Y_SRGB);
      
      // Green x: 4 bytes
      chunk.writeUnsignedInt(cHRM_GREEN_X_SRGB);
      
      // Green y: 4 bytes
      chunk.writeUnsignedInt(cHRM_GREEN_Y_SRGB);
      
      // Blue x: 4 bytes
      chunk.writeUnsignedInt(cHRM_BLUE_X_SRGB);
      
      // Blue y: 4 bytes
      chunk.writeUnsignedInt(cHRM_BLUE_Y_SRGB);
      
      writeChunk(PNG_CHUNK_cHRM, chunk, bytes);
    }
    
    private static function writeChunk(chunkType:uint, chunkData:ByteArray, dst:ByteArray):void
    {
      // Length
      dst.writeUnsignedInt(chunkData ? chunkData.length: 0);
      
      var pos:uint = dst.position;
      
      // Chunk Type
      dst.writeUnsignedInt(chunkType);
      
      // Chunk Data
      if (chunkData != null)
        dst.writeBytes(chunkData);
      
      var crc:uint = computeCRC(dst, pos, dst.position);
      dst.writeUnsignedInt(crc);
    }
    
    public static function extractChunk(bytes:ByteArray, chunkID:uint):ByteArray
    {
      return bytes;
    }
    
    private static function initCRCTable():Vector.<uint>
    {
      var table:Vector.<uint> = new Vector.<uint>(256, true);
      for (var i:uint = 0; i < 256; ++i) {
        var crc:uint = i;
        for (var j:uint = 0; j < 8; ++j) {
          crc = (crc & 1) ? (0xedb88320 ^ crc >>> 1) : crc >>> 1;
        }
        table[i] = crc;
      }
      return table;
    }
    
    private static function computeCRC(data:ByteArray, pos:uint, end:uint):uint
    {
      var result:uint = 0xffffffff;
      while (pos < end) {
        result = (CRC_TABLE[result ^ data[pos++] & 0xff]) ^ (result >>> 8);
      }
      return result ^ 0xffffffff;
    }
    
    private static function pngChunkIDToString(id):String
    {
      return String.fromCharCode(
        id >>> 24,
        (id >>> 16) & 0xff,
        (id >>> 8) & 0xff,
        id & 0xff);
    }
  }
}
