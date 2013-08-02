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
  import com.adobe.utils.URIUtils;
  
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.HTTPStatusEvent;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.FileReference;
  import flash.net.URLRequest;
  import flash.system.LoaderContext;
  
  // ==========================================================================
  //  Events
  // --------------------------------------------------------------------------
  [ Event( name="imageLoaded", type="ImageLoadedEvent" ) ]
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public class ImageServer extends EventDispatcher
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    public static const IMAGES_ROOT:String = "../../../Assets/Images/";
    private static const IMAGE_URIS:Vector.<String> = new <String>[
      //IMAGES_ROOT + "spectrum.png"
      IMAGES_ROOT + "vic_cropped.png"
      //,IMAGES_ROOT + "cute-baby-with-nice-face.jpg"
      //,IMAGES_ROOT + "couple.jpg"
      //,IMAGES_ROOT + "bez.jpg"
      ,IMAGES_ROOT + "obama.png"
      //,IMAGES_ROOT + "obama_cropped.png"
      ,IMAGES_ROOT + "madeleineStowe.jpg"
      ,IMAGES_ROOT + "emmaWatson.jpg"
      ,IMAGES_ROOT + "Mr. Eko.jpg"
      ,IMAGES_ROOT + "Mr. Eko2.jpg"
      ,IMAGES_ROOT + "Ethiopian Woman.jpg"
      ,IMAGES_ROOT + "starteeth.jpg"
      ,IMAGES_ROOT + "Smiling Chinese Man.jpg"
      ,IMAGES_ROOT + "Native American.jpg"
      ,IMAGES_ROOT + "faces_p55.jpeg"
      ,IMAGES_ROOT + "2face.jpg"
      ,IMAGES_ROOT + "Ilyas Kashmiri.jpg"
      ,IMAGES_ROOT + "goth.jpg" // 13
      ,IMAGES_ROOT + "White Beard.jpg"
      ,IMAGES_ROOT + "Clown Nose.jpg" // 15
      ,IMAGES_ROOT + "sidesmile.jpeg"
      ,IMAGES_ROOT + "smilewithdog.jpeg"
      ,IMAGES_ROOT + "yellowteeth.jpeg" 
      ,IMAGES_ROOT + "Katie Holmes.png" //19
      ,IMAGES_ROOT + "robert powell.jpg"
      ,IMAGES_ROOT + "mr-eko-thor-2-dark-world.jpg"
      ,IMAGES_ROOT + "Joan Darrow (Pale Woman).jpg"
      ,IMAGES_ROOT + "christinaaquilera.jpeg"
      ,IMAGES_ROOT + "Braveheart.jpg"
      //,IMAGES_ROOT + "tiltedsmile.jpeg"
      ,IMAGES_ROOT + "000082.jpg"
      ,IMAGES_ROOT + "face_color_clustering_glasses.jpg"
      ,IMAGES_ROOT + "face_color_clustering_normal.jpg"
      ,IMAGES_ROOT + "face.jpg"
      ,IMAGES_ROOT + "90fb407764d5b646.jpeg"
    ];
    
    public static const IMAGE_SET_1:Vector.<String> = new <String>[
      IMAGES_ROOT + "tinylogo.png"
      ,IMAGES_ROOT + "simple.png"
      ,IMAGES_ROOT + "thinlines.png"
      ,IMAGES_ROOT + "tinystripes.png"
      ,IMAGES_ROOT + "vicsmall.png"
      ,IMAGES_ROOT + "stripes.png"
      ,IMAGES_ROOT + "stripesnoisy.png"
      ,IMAGES_ROOT + "testpattern.png"
      ,IMAGES_ROOT + "poolballs.png"
      ,IMAGES_ROOT + "gnomes.jpg"
      ,IMAGES_ROOT + "flower-droplets.jpg"
      ,IMAGES_ROOT + "vic.png"
      ,IMAGES_ROOT + "plant.jpg"
      ,IMAGES_ROOT + "dessert.jpg"
      ,IMAGES_ROOT + "smiles.jpg"
      ,IMAGES_ROOT + "vic.jpg"
      ,IMAGES_ROOT + "bez.jpg"
      ,IMAGES_ROOT + "aravind.jpg"
      ,IMAGES_ROOT + "love.jpg"
      ,IMAGES_ROOT + "applesandoranges.jpg"
      ,IMAGES_ROOT + "picker.png"
      ,IMAGES_ROOT + "hues.png"
      ,IMAGES_ROOT + "spectrum.png"
      ,IMAGES_ROOT + "gridSpectrum.png"
      ,IMAGES_ROOT + "huecircle.png"
      ,IMAGES_ROOT + "sky.jpg"
    ];
    
    private static const CONTEXT:LoaderContext = new LoaderContext();
    CONTEXT.allowCodeImport = false;
    
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    protected var _fileReference:FileReference;
    protected var _loader:Loader;
    protected var _index:uint;
    protected var _filename:String;
    protected var _imageURIs:Vector.<String>;
    
    // ========================================================================
    //  Getters and Setters
    // ------------------------------------------------------------------------
    public function get count():uint
    {
      return _imageURIs.length;
    }
    
    public function get filename():String
    {
      return _filename;
    }
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function ImageServer( imageURIs:Vector.<String> = null )
    {
      if ( !imageURIs )
        imageURIs = IMAGE_URIS;
      
      _imageURIs = imageURIs;
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function requestImage(index:uint):Boolean
    {
      if (index >= count)
        return false;
      
      cleanup();
      
      var url:String =  _imageURIs[index];
      
      var components:Array = URIUtils.parse(url);
      
      var path:String = components[URIUtils.INDEX_URI_PATH];
      var pathPieces:Array = URIUtils.parsePath(path);
      _filename = decodeURI(pathPieces[URIUtils.INDEX_PATH_FILENAME]);
      
      var scheme:String = components[ URIUtils.INDEX_URI_SCHEME ];
      if ( scheme && scheme.toLowerCase() == "javascript" )
        throw new Error( "JavaScript URI scheme not supported." );
      
      var request:URLRequest = new URLRequest( url );
      _loader = new Loader();
      addEventListeners( _loader.contentLoaderInfo );
      _loader.load( request, CONTEXT );
      
      _index = index;
      
      return true;
    }
    
    // ========================================================================
    // Event Handler Related
    // ------------------------------------------------------------------------
    protected function addEventListeners( dispatcher:EventDispatcher ):void
    {
      if ( dispatcher )
      {
        dispatcher.addEventListener( Event.COMPLETE, completeEventHandler, false, 0, true );
        dispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusEventHandler, false, 0, true );
        dispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler, false, 0, true );
        dispatcher.addEventListener( ProgressEvent.PROGRESS, progressEventHandler, false, 0, true );
        dispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler, false, 0, true );
      }
    }
    
    protected function removeEventListeners( dispatcher:EventDispatcher ):void
    {
      if ( dispatcher )
      {
        dispatcher.removeEventListener( Event.COMPLETE, completeEventHandler );
        dispatcher.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusEventHandler );
        dispatcher.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
        dispatcher.removeEventListener( ProgressEvent.PROGRESS, progressEventHandler );
        dispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler );
      }
    }
    
    protected function completeEventHandler( event:Event ):void
    {
      finish( event );
    }
    
    protected function progressEventHandler( event:ProgressEvent ):void
    {
      //trace( "ProgressEvent:", ( event.bytesLoaded / event.bytesTotal * 100 ) + "% (" + event.bytesLoaded + "/" + event.bytesTotal + " bytes)" );
    }
    
    protected function httpStatusEventHandler( event:HTTPStatusEvent ):void
    {
      //trace( "HTTPStatusEvent:", event );
    }
    
    protected function ioErrorEventHandler( event:IOErrorEvent ):void
    {
      trace( "IOErrorEvent:", event );
      finish( event, false );
    }
    
    protected function securityErrorEventHandler( event:SecurityErrorEvent ):void
    {
      trace( "SecurityErrorEvent:", event );
      finish( event, false );
    }
    
    protected function finish( event:Event, succeeded:Boolean = true ):void
    {
      if ( succeeded )
      {
        var loaderInfo:LoaderInfo = event.target as LoaderInfo;
        var bitmap:Bitmap = ( loaderInfo.content as Bitmap );
        dispatchEvent( new ImageLoadedEvent( _index, _imageURIs[ _index ], bitmap ) );
      }
      else
        dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ) );
      
      cleanup()
    }
    
    protected function cleanup():void
    {
      if ( !_loader )
        return;
        
      removeEventListeners( _loader.loaderInfo );
      try
      {
        _loader.close();
      }
      catch( error:Error ) {}
      _loader = null;
    }
  }
}
