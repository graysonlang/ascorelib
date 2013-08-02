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
//
//	Based upon NanoJPEG: http://keyj.emphy.de/nanojpeg/
//
// ============================================================================
package org.ascorelib.images
{
  // ===========================================================================
  //	Imports
  // ---------------------------------------------------------------------------
  import flash.utils.ByteArray;
  
  // ===========================================================================
  //	Class
  // ---------------------------------------------------------------------------
  /**
   * Note: decodes baseline JPEG only.
   */
  public class JPEGDecoder
  {
    // ======================================================================
    //	Constants
    // ----------------------------------------------------------------------
    // DecodeResult
    public static const DECODE_RESULT_OK:uint					= 0;	// decoding successful
    public static const DECODE_RESULT_NOT_A_JPEG:uint			= 1;	// not a JPEG file
    public static const DECODE_RESULT_UNSUPPORTED:uint			= 2;	// unsupported format
    public static const DECODE_RESULT_OUT_OF_MEMORY:uint		= 3;	// out of memory
    public static const DECODE_RESULT_INTERNAL_ERROR:uint		= 4;	// internal error
    public static const DECODE_RESULT_SYNTAX_ERROR:uint			= 5;	// syntax error
    public static const DECODE_RESULT_INTERNAL_FINISHED:uint	= 6;	// used internally, will never be reported
    
    private static const INDICES:ByteArray						= initIndices();
    
    public function get result():uint { return _context.error; }
    public function get width():uint { return _context.width; }
    public function get height():uint { return _context.height; }
    public function get isColor():Boolean { return _context.ncomp != 1; }
    public function get image():ByteArray { return (_context.ncomp == 1) ? _context.comp[0].pixels : _context.rgb; }
    public function get imageSize():uint { return _context.width * _context.height * _context.ncomp; }
    
    private var _context:JPEGDecoderContext;
    private var _zz:ByteArray; // char[64]
    
    // ======================================================================
    //	Methods
    // ----------------------------------------------------------------------
    public function decode( data:ByteArray ):ByteArray
    {
      var result:ByteArray = new ByteArray();
      
      _zz = new ByteArray();
      INDICES.position = 0;
      
      _zz.writeBytes( INDICES );
      _zz.position = 0;
      
      _context = new JPEGDecoderContext();
      _context.data = data;			
      
      var size:uint = data.bytesAvailable;
      
      if ( size > 0x7FFFFFFF || size < 2 || data.readUnsignedShort() != 0xffd8 )
        throw new Error( "Not a JPEG" );
      
      while( !_context.error )
      {
        if ( data.bytesAvailable < 2 )
          throw new Error( "Syntax Error" );
        
        var byte:uint = data.readUnsignedByte()
        if ( byte != 0xff )
          throw new Error( "Syntax Error" );
        
        
        var command:uint = data.readUnsignedByte();
        switch( command )
        {
          case 0xDB:	readDQT();		break;	// Define Quantization Table
          case 0xC0:	readSOF();		break;	// Start Of Frame
          case 0xC4:	readDHT();		break;	// Define Huffman Table
          case 0xDD:	readDRI();		break;	// Define Restart Interval
          case 0xDA:	readSOS();		break;	// Start Of Scan
          
          case 0xFE:	skipMarker();	break;	// Comment
          
          default:
            // 0xFFE0 through 0xFFEF are reserved for application segments
            if ( ( command & 0xF0 ) == 0xE0 )
              skipMarker();
            else
              throw new Error( "Unsupported" );
        }
      }
      
      if ( _context.error != DECODE_RESULT_INTERNAL_FINISHED )
        throw new Error( _context.error );
      
      _context.error = DECODE_RESULT_OK;
      
      convert();
      //return _context.error;
      
      return result;
    }
    
    // returns unsigned byte
    private static function clip( x:int ):uint 
    {
      return ( x < 0 ) ? 0 : ( ( x > 0xff ) ? 0xff : x );
    }
    
    private static function CF( x:int ):uint
    {
      return clip( ( x + 64 ) >> 7 );
    }
    
    private static function decodeRows( block:Vector.<int> ):void
    {
      var x1:int, x2:int, x3:int, x4:int, x5:int, x6:int, x7:int;
      
      for ( var coef:int = 0; coef < 64; coef += 8 )
      {
        var offset:int = coef;
        
        if (
          !(
            ( x4 = block[ ++offset ] )
            | ( x3 = block[ ++offset ] )
            | ( x7 = block[ ++offset ] )
            | ( x1 = block[ ++offset ] << 11)
            | ( x6 = block[ ++offset ] )
            | ( x2 = block[ ++offset ] )
            | ( x5 = block[ ++offset ] )
          )
        )
        {
          var b:int = block[ coef ] << 3;
          block[ coef ] = block[ coef + 1 ] = block[ coef + 2 ] = block[ coef + 3 ] = block[ coef + 4 ] = block[ coef + 5 ] = block[ coef + 6 ] = block[ coef + 7 ] = b;
          continue;
        }
        
        var x0:int = ( block[ coef ] << 11 ) + 128;
        var x8:int = 565 * (x4 + x5);
        x4 = x8 + 2276 * x4;
        x5 = x8 - 3406 * x5;
        x8 = 2408 * (x6 + x7);
        x6 = x8 - 799 * x6;
        x7 = x8 - 4017 * x7;
        x8 = x0 + x1;
        x0 -= x1;
        x1 = 1108 * (x3 + x2);
        x2 = x1 - 3784 * x2;
        x3 = x1 + 1568 * x3;
        x1 = x4 + x6;
        x4 -= x6;
        x6 = x5 + x7;
        x5 -= x7;
        x7 = x8 + x3;
        x8 -= x3;
        x3 = x0 + x2;
        x0 -= x2;
        x2 = (181 * (x4 + x5) + 128) >> 8;
        x4 = (181 * (x4 - x5) + 128) >> 8;
        
        block[ coef ] = (x7 + x1) >> 8;
        block[ coef + 1 ] = (x3 + x2) >> 8;
        block[ coef + 2 ] = (x0 + x4) >> 8;
        block[ coef + 3 ] = (x8 + x6) >> 8;
        block[ coef + 4 ] = (x8 - x6) >> 8;
        block[ coef + 5 ] = (x0 - x4) >> 8;
        block[ coef + 6 ] = (x3 - x2) >> 8;
        block[ coef + 7 ] = (x7 - x1) >> 8;
      }
    }
    
    private static function decodeColumns( block:Vector.<int>, pixels:ByteArray, stride:uint, outOffset:uint ):void
    {
      var x1:int, x2:int, x3:int, x4:int, x5:int, x6:int, x7:int;
      var offset:int;
      
      for ( var coef:int = 0; coef < 8; ++coef )
      {
        if (
          !(
            ( x4 = block[ coef + 8 * 1 ] )
            | ( x3 = block[ coef + 8 * 2 ] )
            | ( x7 = block[ coef + 8 * 3 ] )
            | ( x1 = block[ coef + 8 * 4 ] << 8 )
            | ( x6 = block[ coef + 8 * 5 ] )
            | ( x2 = block[ coef + 8 * 6 ] )
            | ( x5 = block[ coef + 8 * 7 ] )
          )
        )
        {
          offset = coef + outOffset;
          x1 = clip( ( ( block[ coef ] + 32 ) >> 6 ) + 128 );
          for ( x0 = 8; x0; --x0 )
          {
            pixels[ offset ] = x1;
            offset += stride;
          }
          continue;
        }
        
        var x0:int = (block[ coef] << 8) + 8192;
        var x8:int = 565 * (x4 + x5) + 4;
        x4 = (x8 + (2276) * x4) >> 3;
        x5 = (x8 - (3406) * x5) >> 3;
        x8 = 2408 * (x6 + x7) + 4;
        x6 = (x8 - (799) * x6) >> 3;
        x7 = (x8 - (4017) * x7) >> 3;
        x8 = x0 + x1;
        x0 -= x1;
        x1 = 1108 * (x3 + x2) + 4;
        x2 = (x1 - (3784) * x2) >> 3;
        x3 = (x1 + (1568) * x3) >> 3;
        x1 = x4 + x6;
        x4 -= x6;
        x6 = x5 + x7;
        x5 -= x7;
        x7 = x8 + x3;
        x8 -= x3;
        x3 = x0 + x2;
        x0 -= x2;
        x2 = (181 * (x4 + x5) + 128) >> 8;
        x4 = (181 * (x4 - x5) + 128) >> 8;
        
        offset = coef + outOffset;
        
        var n:int = ((x7 + x1) >> 14) + 128;
        pixels[ offset ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x3 + x2) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x0 + x4) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x8 + x6) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x8 - x6) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x0 - x4) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x3 - x2) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
        n = ((x7 - x1) >> 14) + 128;
        pixels[ offset+= stride ] = ( n < 0 ) ? 0 : ( ( n > 0xff ) ? 0xff : n );
      }
    }
    
    public function showBits( bits:int ):int
    {
      var newbyte:uint;
      if ( !bits )
        return 0;
      
      while ( _context.bufbits < bits )
      {
        if ( _context.size <= 0 )
        {
          _context.buf = ( _context.buf << 8 ) | 0xFF;
          _context.bufbits += 8;
          continue;
        }
        
        newbyte = _context.data.readUnsignedByte();
        
        _context.bufbits += 8;
        _context.buf = ( _context.buf << 8 ) | newbyte;
        
        if ( newbyte == 0xFF )
        {
          if ( _context.size )
          {
            //						unsigned char marker = *_context.pos++;
            var marker:uint = _context.data.readUnsignedByte();
            //_context.size--;
            
            switch ( marker )
            {
              case 0x00:
              case 0xFF:
                break;
              
              case 0xD9:
                //_context.size = 0;
                _context.data.position = _context.data.length - 1;
                break;
              
              default:
                if ( ( marker & 0xF8) != 0xD0 )
                  _context.error = DECODE_RESULT_SYNTAX_ERROR;
                else
                {
                  _context.buf = ( _context.buf << 8 ) | marker;
                  _context.bufbits += 8;
                }
            }
          }
          else
            _context.error = DECODE_RESULT_SYNTAX_ERROR;
        }
      }
      return ( _context.buf >> ( _context.bufbits - bits ) ) & ( ( 1 << bits ) - 1 );
    }
    
    private function skipBits( bits:int ):void
    {
      if ( _context.bufbits < bits )
        showBits( bits );
      _context.bufbits -= bits;
    }
    
    private function getBits( bits:int):int
    {
      var res:int = showBits( bits );
      skipBits( bits );
      return res;
    }
    
    private function byteAlign():void
    {
      _context.bufbits &= 0xF8;
    }
    
    public function skip( count:int ):void
    {
      _context.data.position += count;
      _context.length -= count;
      
      //if ( _context.data.bytesAvailable < 0 )
      //	_context.error = DECODE_RESULT_SYNTAX_ERROR;
    }
    
    private function decode16( pos:ByteArray ):uint
    {
      var position:uint = pos.position;
      return ( pos[ position ] << 8 ) | pos[ position + 1 ];
    }
    
    private function readLength():void
    {
      var bytes:ByteArray = _context.data
      
      if ( bytes.bytesAvailable < 2 )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
      
      //var length:uint = decode16( bytes );
      var length:uint = bytes.readUnsignedShort();
      bytes.position -= 2;
      
      if ( length  > bytes.bytesAvailable + 2 )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
      
      _context.length = length;
      skip( 2 );
    }
    
    private function skipMarker():void
    {
      readLength();
      //trace( "skipping length of: " + length ); 
      skip( _context.length );
    }
    
    // "Start Of Frame"
    private function readSOF():void
    {
      var i:int;
      var ssxmax:int = 0;
      var ssymax:int = 0;
      
      readLength();
      
      if ( _context.length < 9 )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
      
      var byte:uint = _context.data.readUnsignedByte();
      
      if ( byte != 8 )
        JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );
      
      
      var height:uint = _context.data.readUnsignedShort();
      _context.height = height;
      //trace( "Image Height:", _context.height );
      
      var width:uint = _context.data.readUnsignedShort();
      _context.width = width;
      //trace( "Image Width:", _context.width );
      
      var nComponents:uint = _context.data.readUnsignedByte();
      _context.ncomp = nComponents;
      //trace( "Component Count:", _context.ncomp );
      _context.length -= 6;
      
      switch ( nComponents )
      {
        case 1:
        case 3:
          break;
        default:
          JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );
      }
      
      if ( _context.length < ( nComponents * 3 ) )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
      
      _context.comp = new Vector.<Component>( nComponents );
      
      var c:Component;
      for ( i = 0; i < nComponents; ++i )
      {
        c = new Component();
        _context.comp[ i ] = c;
        
        c.cid = _context.data.readUnsignedByte();			
        //trace( "Component ID:", c.cid );
        
        var b1:uint = _context.data.readUnsignedByte();
        var b2:uint = _context.data.readUnsignedByte();
        
        c.ssx = b1 >> 4;
        if ( !c.ssx )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        if ( c.ssx & ( c.ssx - 1 ) )
          JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );  // non-power of two				
        
        c.ssy = b1 & 15;
        if ( !c.ssy )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        if ( c.ssy & ( c.ssy - 1 ) )
          JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );  // non-power of two
        
        if ( ( c.qtsel = b2 ) & 0xFC )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        _context.length -= 3;
        
        _context.qtused |= 1 << c.qtsel;
        
        if ( c.ssx > ssxmax )
          ssxmax = c.ssx;
        
        if ( c.ssy > ssymax )
          ssymax = c.ssy;
      }
      
      if ( nComponents == 1 )
      {
        c.ssx = c.ssy = ssxmax = ssymax = 1;
      }
      
      _context.mbsizex = ssxmax << 3;
      _context.mbsizey = ssymax << 3;
      _context.mbwidth = ( _context.width + _context.mbsizex - 1 ) / _context.mbsizex;
      _context.mbheight = ( _context.height + _context.mbsizey - 1 ) / _context.mbsizey;
      
      //trace( "Block Width:", _context.mbsizex );
      //trace( "Block Height:", _context.mbsizey );
      //trace( "Block Columns:", _context.mbwidth );
      //trace( "Block Rows:", _context.mbheight );
      
      for ( i = 0; i < nComponents; ++i )
      {
        c = _context.comp[ i ];
        c.width = (_context.width * c.ssx + ssxmax - 1) / ssxmax;
        c.stride = (c.width + 7) & 0x7FFFFFF8;
        c.height = (_context.height * c.ssy + ssymax - 1) / ssymax;
        c.stride = _context.mbwidth * _context.mbsizex * c.ssx / ssxmax;
        if (((c.width < 3) && (c.ssx != ssxmax)) || ((c.height < 3) && (c.ssy != ssymax)))
          JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );
        
        //if ( !( c.pixels = (unsigned char*)AllocMem( c.stride * (_context.mbheight * _context.mbsizey * c.ssy / ssymax ) ) ) )
        //JPEG_DECODER_THROW(DECODE_RESULT_OUT_OF_MEMORY);
        c.pixels = new ByteArray();
        c.pixels.length = c.stride * ( _context.mbheight * _context.mbsizey * c.ssy / ssymax );
      }
      
      if ( nComponents == 3 )
      {
        //_context.rgb = (unsigned char*) malloc( _context.width * _context.height * _context.ncomp );
        //if (!_context.rgb) njThrow(DECODE_RESULT_OUT_OF_MEM);
        _context.rgb = new ByteArray();
        _context.rgb.length = _context.width * _context.height * _context.ncomp;
      }
      
      skip( _context.length );
    }
    
    // "Define Huffman Table"
    // VLC = Variable Length Code
    private function readDHT():void
    {
      //unsigned char counts[16];
      var counts:ByteArray = new ByteArray();
      counts.length = 16;
      
      readLength();
      while ( _context.length >= 17 )
      {
        //i = _context.pos[0];
        var i:int = _context.data.readUnsignedByte();				
        
        if ( i & 0xEC )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        if ( i & 0x02 )
          JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );
        
        i = ( i | ( i >> 3 ) ) & 3;  // combined DC/AC + tableid value
        
        _context.data.readBytes( counts, 0, 16 );
        _context.length -= 17;
        
        var remain:int = 65536;
        var spread:int = 65536;
        
        var vlcs:Vector.<VlcCode> = _context.vlctab[ i ];
        var vlcIndex:uint = 0;
        
        for ( var codelen:int = 1; codelen <= 16; ++codelen )
        {
          spread >>= 1;
          var currcnt:int = counts[ codelen - 1 ];
          
          if ( !currcnt )
            continue;
          
          if ( _context.length < currcnt )
            JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
          
          remain -= currcnt << ( 16 - codelen );
          if ( remain < 0 )
            JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
          
          for ( i = 0; i < currcnt; ++i )
          {
            var code:uint = _context.data.readUnsignedByte();
            for ( var j:int = spread; j; --j )
            {
              var vlc:VlcCode = vlcs[ vlcIndex ];
              vlc.bits = codelen;
              vlc.code = code;
              vlcIndex++;
            }
          }
          
          _context.length -= currcnt;
        }
        
        while ( remain-- )
          vlcs[ vlcIndex++ ].bits = 0;
      }
      
      if ( _context.length )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
    }
    
    // "Define Quantization Table"
    private function readDQT():void
    {
      readLength();
      
      while ( _context.length >= 65 )
      {
        var i:uint = _context.data.readUnsignedByte();
        if ( i & 0xFC )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        _context.qtavail |= 1 << i;
        
        var t:ByteArray = _context.qtab[ i ];
        _context.data.readBytes( t, 0, 64 );
        _context.length -= 65;
      }
      
      if ( _context.length )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
    }
    
    // "Define Restart Interval"
    private function readDRI():void
    {
      readLength();
      if ( _context.length < 2 )
        JPEG_DECODER_THROW(DECODE_RESULT_SYNTAX_ERROR);
      
      _context.rstinterval = decode16( _context.data );
      skip( _context.length );
    }
    
    //private function getVLC( VlcCode* vlc, unsigned char* code ):int
    private function getVLC( vlc:Vector.<VlcCode>, code:Vector.<int> = null ):int
    {
      var value:int = showBits( 16 );
      var bits:int = vlc[ value ].bits;
      if ( !bits )
      {
        _context.error = DECODE_RESULT_SYNTAX_ERROR;
        return 0;
      }
      
      skipBits( bits );
      value = vlc[ value ].code;
      
      if ( code != null )
        code[ 0 ] = value;
      
      bits = value & 15;
      
      if ( !bits )
        return 0;
      
      value = getBits( bits );
      
      if ( value < ( 1 << ( bits - 1 ) ) )
        value += ( ( -1 ) << bits ) + 1;
      
      return value;
    }
    
    private function decodeBlock( c:Component, pos:uint ):void
    {
      //unsigned char code;
      var value:int, coef:int = 0;
      
      //memset( _context.block, 0, sizeof( _context.block ) );
      _context.block.length = 0;
      _context.block.length = 64;
      
      var code:Vector.<int> = new <int>[ 0 ];
      
      c.dcpred += getVLC( _context.vlctab[ c.dctabsel ], null );
      _context.block[ 0 ] = c.dcpred * _context.qtab[ c.qtsel ][ 0 ];
      
      do
      {
        value = getVLC( _context.vlctab[ c.actabsel ], code );
        
        if ( code[ 0 ] == 0 )
          break;  // EOB
        
        if ( !( code[ 0 ] & 0x0F ) && ( code[ 0 ] != 0xF0 ) )
          JPEG_DECODER_THROW(DECODE_RESULT_SYNTAX_ERROR);
        
        coef += ( code[ 0 ] >> 4 ) + 1;
        
        if ( coef > 63 )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        var index:uint = _zz[ coef ];
        var val:int = value * _context.qtab[ c.qtsel ][ coef ];
        _context.block[ index ] = val;
      }
      while ( coef < 63 );
      
      decodeRows( _context.block );
      decodeColumns( _context.block, c.pixels, c.stride, pos );
    }
    
    private function readSOS():void		
    {
      var i:int;
      var rstcount:int = _context.rstinterval;
      var nextrst:int = 0;
      
      readLength();
      
      if ( _context.length < ( 4 + 2 * _context.ncomp ) )
        JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
      
      if ( _context.data.readUnsignedByte() != _context.ncomp )
        JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );
      
      _context.length--;
      
      var c:Component;
      for ( i = 0; i < _context.ncomp; ++i )
      {
        c = _context.comp[ i ];
        
        if ( _context.data.readUnsignedByte() != c.cid )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        var b:uint = _context.data.readUnsignedByte();
        
        if ( b & 0xEE )
          JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
        
        c.dctabsel = b >> 4;
        c.actabsel = ( b & 1 ) | 2;
        
        _context.length -= 2;
      }
      
      var flag:uint = _context.data.readUnsignedShort() << 8 | _context.data.readUnsignedByte();
      if ( flag != 0x3f00 )
        JPEG_DECODER_THROW( DECODE_RESULT_UNSUPPORTED );	
      
      _context.length -= 3;
      
      var count:uint = 0;
      
      for ( var mbx:int = 0, mby:int = 0; ; )
      {
        for ( i = 0; i < _context.ncomp; ++i )
        {
          c = _context.comp[ i ];
          
          for ( var sby:int = 0; sby < c.ssy; ++sby )
          {
            for ( var sbx:int = 0; sbx < c.ssx; ++sbx )
            {
              var pos:uint = ( ( mby * c.ssy + sby ) * c.stride + mbx * c.ssx + sbx ) << 3;
              decodeBlock( c, pos );
              
              if( _context.error )
                trace( "ERROR" );
              //njCheckError();
            }
          }
        }
        
        if ( ++mbx >= _context.mbwidth )
        {
          mbx = 0;
          if ( ++mby >= _context.mbheight )
            break;
        }
        
        if ( _context.rstinterval && !( --rstcount ) )
        {
          _context.bufbits &= 0xF8;
          
          i = showBits( 16 );
          if ( _context.bufbits < 16 )
            showBits( 16 );
          _context.bufbits -= 16;
          
          if ( ( ( i & 0xFFF8 ) != 0xFFD0 ) || ( ( i & 7 ) != nextrst ) )
            JPEG_DECODER_THROW( DECODE_RESULT_SYNTAX_ERROR );
          
          nextrst = (nextrst + 1) & 7;
          rstcount = _context.rstinterval;
          for ( i = 0; i < 3; ++i )
            _context.comp[ i ].dcpred = 0;
        }
        
        //dumpPixels();
      }
      
      _context.error = DECODE_RESULT_INTERNAL_FINISHED;
    }
    
    private var done:Boolean;
    
    private function upsampleH( c:Component ):void
    {
      var x:int;
      var y:int;
      var xshift:int = 0;
      var yshift:int = 0;
      
      //			unsigned char* lin;
      //			unsigned char* lout;
      
      while ( c.width < _context.width )
      {
        c.width <<= 1;
        ++xshift;
      }
      
      while ( c.height < _context.height )
      {
        c.height <<= 1;
        ++yshift;
      }
      
      //trace( x, y, xshift, yshift );
      
      //out = (unsigned char*) malloc(c->width * c->height);
      var out:ByteArray = new ByteArray();
      out.length = c.width * c.height;
      
      //if (!out)
      //	njThrow(DECODE_RESULT_OUT_OF_MEM);
      
      var pixels:ByteArray = c.pixels;
      var lin:uint = 0;
      var lout:uint = 0;
      
      for ( y = 0; y < c.height; ++y )
      {
        lin = ( y >> yshift ) * c.stride;
        for ( x = 0;  x < c.width; ++x )
          out[ lout + x ] = pixels[ lin + ( x >> xshift ) ];
        lout += c.width;
      }
      
      c.stride = c.width;
      c.pixels.clear();
      c.pixels = out;
    }
    
    private function convert():void
    {
      var i:int;
      var c:Component;
      
      for ( i = 0; i < _context.ncomp; ++i )
      {
        c = _context.comp[ i ];
        
        while ( ( c.width < _context.width ) || ( c.height < _context.height ) )
          upsampleH( c );
        
        if ( ( c.width < _context.width ) || ( c.height < _context.height ) )
          JPEG_DECODER_THROW( DECODE_RESULT_INTERNAL_ERROR );
      }
      
      var y:int;
      if ( _context.ncomp == 3 )
      {
        var x:int, yy:int;
        var prgb:ByteArray = _context.rgb;
        
        prgb.length = _context.height * _context.width * 4;
        
        var py:ByteArray  = _context.comp[ 0 ].pixels;
        var pcb:ByteArray = _context.comp[ 1 ].pixels;
        var pcr:ByteArray = _context.comp[ 2 ].pixels;
        
        var pyOffset:uint = 0;
        var pcbOffset:uint = 0;
        var pcrOffset:uint = 0;
        
        var pos:uint = 0;
        
        var stride0:uint = _context.comp[ 0 ].stride;
        var stride1:uint = _context.comp[ 1 ].stride;
        var stride2:uint = _context.comp[ 2 ].stride;
        
        for ( yy = _context.height; yy; --yy )
        {
          for ( x = 0; x < _context.width; ++x )
          {
            y = py[ x + pyOffset ] << 8;
            var cb:int = pcb[ x + pcbOffset ] - 128;
            var cr:int = pcr[ x + pcrOffset ] - 128;
            
            var r:Number = ( y            + 359 * cr + 128 ) >> 8;
            var g:Number = ( y -  88 * cb - 183 * cr + 128 ) >> 8;
            var b:Number = ( y + 454 * cb            + 128 ) >> 8;
            
            prgb[ pos++ ] = 0xff;
            prgb[ pos++ ] = ( r < 0 ) ? 0 : ( ( r > 0xff ) ? 0xff : r );
            prgb[ pos++ ] = ( g < 0 ) ? 0 : ( ( g > 0xff ) ? 0xff : g );
            prgb[ pos++ ] = ( b < 0 ) ? 0 : ( ( b > 0xff ) ? 0xff : b );
          }
          
          pyOffset += stride0;
          pcbOffset += stride1;
          pcrOffset += stride2;
        }
      }
      else if ( _context.comp[ 0 ].width != _context.comp[ 0 ].stride )
      {
        c = _context.comp[ 0 ];
        
        var pixels:ByteArray = c.pixels;
        var width:uint = c.width;
        var stride:uint = c.stride;
        
        var inOffset:uint = c.stride;
        var outOffset:uint = width;
        
        // grayscale -> only remove stride
        for ( y = _context.comp[ 0 ].height - 1; y; --y )
        {
          pixels.position = outOffset;
          pixels.writeBytes( pixels, inOffset, width );
          
          inOffset += stride;
          outOffset += width;
        }
        
        c.stride = width;
      }
    }
    
    // --------------------------------------------------
    
    //#define JPEG_DECODER_THROW(e) do { _context.error = e; return; } while (0)
    private function JPEG_DECODER_THROW( e:uint ):void
    {
      //do { _context.error = e; return; } while (0)
      throw new Error( e );
    }
    
    private static function initIndices():ByteArray
    {
      var result:ByteArray = new ByteArray();
      var indices:Vector.<uint> = new <uint>[ 0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63 ];
      for ( var i:uint = 0; i < 64; i++ )
        result.writeByte( indices[ i ] );
      return result;
    }
  }
}

// ============================================================================
//	Helper imports
// ============================================================================
import flash.utils.ByteArray;

// ============================================================================
//	Helper Classes
// ============================================================================
{
  class JPEGDecoderContext
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var error:uint;	// DecodeResult
    public var pos:ByteArray; // const unsigned char*
    public var data:ByteArray;
    //	int size;	
    public var length:int;
    public var width:int;
    public var height:int;
    public var mbwidth:int;
    public var mbheight:int;
    public var mbsizex:int;
    public var mbsizey:int;
    public var ncomp:int;
    public var comp:Vector.<Component>;		// Component comp[3];
    public var qtused:int;
    public var qtavail:int;
    public var qtab:Vector.<ByteArray>;				//unsigned char [4][64];
    public var vlctab:Vector.<Vector.<VlcCode>>	// VlcCode[4][65536];
    public var buf:int;
    public var bufbits:int;
    public var block:Vector.<int>;		// int[64]
    public var rstinterval:int;
    public var rgb:ByteArray;	// unsigned char*
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get size():uint
    {
      return data.bytesAvailable;
    }
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function JPEGDecoderContext():void
    {
      comp = new Vector.<Component>( 3, true );
      block = new Vector.<int>( 64, false );
      qtab = new Vector.<ByteArray>( 4, true );
      
      var i:uint;
      for ( i = 0; i < 4; i++ )
      {
        qtab[ i ] = new ByteArray();
        qtab[ i ].length = 64;
      }
      
      vlctab = new Vector.<Vector.<VlcCode>>(4);
      
      for ( i = 0; i < 4; i++ )
      {
        var vlcs:Vector.<VlcCode> = new Vector.<VlcCode>( 65536 );
        vlctab[ i ] = vlcs;
        for ( var j:uint = 0; j < 65536; j++ )
          vlcs[ j ] = new VlcCode();
      }
    }
  };
  
  class VlcCode
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var bits:uint;	// unsigned char
    public var code:uint;	// unsigned char
  };
  
  class Component
  {
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    public var cid:int;
    public var ssx:int;
    public var ssy:int;
    public var width:int;
    public var height:int;
    public var stride:int;
    public var qtsel:int;
    public var actabsel:int;
    public var dctabsel:int;
    public var dcpred:int;
    public var pixels:ByteArray;	// unsigned char*
  };
}