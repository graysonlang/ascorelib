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
package
{
  // ==========================================================================
  //	Imports
  // --------------------------------------------------------------------------
  import com.adobe.display.MouseHandler;
  
  import flash.display.BitmapData;
  import flash.display.InteractiveObject;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Vector3D;
  
  import org.ascorelib.display.CursorUtils;
  import org.ascorelib.display.Handle;
  import org.ascorelib.display.OutputDisplay;
  
  // ==========================================================================
  //	Metadata Tag
  // --------------------------------------------------------------------------
  [SWF(width="1024", height="1024", backgroundColor="0x333333", frameRate="60")]
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class TestIntersectionLinePlane extends Sprite
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const INVERT_Y:Boolean = true;
    
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    private var _bitmapData:BitmapData;
    private var _output:OutputDisplay;
    
    private var _shape:Shape;
    
    protected var _q0:Handle, _q1:Handle, _p:Handle, _n:Handle;
    protected var _moveHandler:MouseHandler;
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function TestIntersectionLinePlane()
    {
      super();
      
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      CursorUtils.initCursor();      
      
      _shape = new Shape();
      addChild( _shape );
      
      _q0 = new Handle( this, 0, 0, 0x3366cc, 4 );
      _q1 = new Handle( this, 0, 0, 0x3366cc, 4 );
      _p = new Handle( this, 0, 0, 0x3366cc, 4 ); 
      _n = new Handle( this, 0, 0, 0xff9900, 4 ); 
      
      addChild( _q0 );
      addChild( _q1 );
      addChild( _p );
      addChild( _n );
      
      _moveHandler = new MouseHandler( stage );
      _moveHandler.register( _q0, moveCallback );
      _moveHandler.register( _q1, moveCallback );
      _moveHandler.register( _p, moveCallback, _n );
      _moveHandler.register( _n, moveCallback );
      
      positionHandles();
      
      stage.addEventListener( KeyboardEvent.KEY_DOWN, keyboardEventHandler );
      
      update();
    }
    
    // ========================================================================
    //	Methods
    // ------------------------------------------------------------------------
    protected function keyboardEventHandler( event:KeyboardEvent ):void
    {
      switch( event.type )
      {
        case KeyboardEvent.KEY_DOWN:
        {
          switch( event.keyCode )
          {
            case 32:	// spacebar
              positionHandles();
              break;
          }	
        }
      }
    }
    
    protected function positionHandles( set:uint = 0 ):void
    {
      switch( set )
      {
        case 0:
          _q0.x = 500, _q0.y = 600;
          _q1.x = 500, _q1.y = 200;
          
          _p.x = 400, _p.y = 400;
          _n.x = 400, _n.y = 200;
          break;
        
        default:
          return;
      }
      
      update();
    }
    
    protected function moveCallback( event:MouseEvent, target:InteractiveObject, dx:Number, dy:Number, data:* = undefined ):void
    {
      target.x += dx;
      target.y += dy
      
      if ( data )
      {
        data.x += dx;
        data.y += dy
      }
      
      update();
    }
    
    // p = point on the plane
    // n = plane normal
    // d = q1 - q0
    // t = ( dot( n, ( p - q0 ) ) / ( dot( n, d )		(solve for t)
    // if 0 <= t <= 1, then the plane intersects the line segment
    // if dot( n, d ) == 0, then the line is perdendicular to the plane (possibly lying on it)
    
    protected function update():void
    {
      var p:Vector3D	= new Vector3D( _p.x, _p.y, 0 );				// point on the plane
      var n:Vector3D = new Vector3D( _n.x, _n.y, 0 ).subtract( p );	// plane normal
      n.normalize();
      var q0:Vector3D	= new Vector3D( _q0.x, _q0.y );					// point 0
      var q1:Vector3D	= new Vector3D( _q1.x, _q1.y );					// point 1
      var d:Vector3D	= q1.subtract( q0 );							// distance between the points
      
      // ------------------------------
      
      var top:Vector3D = new Vector3D( 0, 0, 1 );
      var side:Vector3D = n.crossProduct( top ); 
      side.normalize();
      side.scaleBy( 300 )
      var s0:Vector3D = side.clone().add( p );
      side.negate();
      var s1:Vector3D = side.add( p );
      
      // ------------------------------
      
      var pq:Vector3D = p.subtract( q0 );
      var npq:Number = n.dotProduct( pq );
      var nd:Number = n.dotProduct( d );
      var t:Number = -1;
      var i:Point;
      
      if ( nd != 0 )
      {
        t = npq / nd;
        i = new Point( q0.x + t * d.x, q0.y + t * d.y );
      }
      
      // ------------------------------
      //	draw
      // ------------------------------
      _shape.graphics.clear()
      _shape.graphics.lineStyle( 1, 0xcccccc );		// draw line
      _shape.graphics.moveTo( _q0.x, _q0.y );
      _shape.graphics.lineTo( _q1.x, _q1.y );
      _shape.graphics.lineStyle( 1, 0x3366cc );		// draw plane
      _shape.graphics.moveTo( s0.x, s0.y );
      _shape.graphics.lineTo( s1.x, s1.y );
      _shape.graphics.lineStyle( 1, 0xff9900 );		// draw plane normal
      _shape.graphics.moveTo( _p.x, _p.y );
      _shape.graphics.lineTo( _n.x, _n.y );
      
      if ( t <= 1 && t >= 0 )
      {
        _shape.graphics.lineStyle( 1.5, 0xff0000 );
        _shape.graphics.drawCircle( i.x, i.y, 8 );
        _shape.graphics.lineStyle();
        _shape.graphics.beginFill( 0xff0000 );
        _shape.graphics.drawCircle( i.x, i.y, 1.5 );
        _shape.graphics.endFill();
      }
    }
  }
}
