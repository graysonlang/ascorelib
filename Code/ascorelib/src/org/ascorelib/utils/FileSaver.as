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
package org.ascorelib.utils
{
  // ==========================================================================
  //  Imports
  // --------------------------------------------------------------------------
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.FileReference;
  import flash.utils.ByteArray;
  
  // ==========================================================================
  //  Class
  // --------------------------------------------------------------------------
  public final class FileSaver
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const DEFAULT_FILENAME:String = "untitled";
    
    // ========================================================================
    //  Statics
    // ------------------------------------------------------------------------
    private static var _pendingReferences:Vector.<FileReference> = new Vector.<FileReference>();
    private static var _pendingFilenames:Vector.<String> = new Vector.<String>();
    private static var _pendingData:Vector.<ByteArray> = new Vector.<ByteArray>();
    private static var _references:Vector.<FileReference> = new Vector.<FileReference>();
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public static function saveBinary(bytes:ByteArray, filename:String=DEFAULT_FILENAME) : void {
      bytes.position = 0;
      var fileReference:FileReference = new FileReference();
      addListeners(fileReference);
      _pendingReferences.push(fileReference);
      _pendingFilenames.push(filename);
      _pendingData.push(bytes);
      if(_pendingReferences.length == 1)
      {
        fileReference.save(bytes,filename);
      }
    }
    
    private static function addListeners(dispatcher:EventDispatcher):void
    {
      dispatcher.addEventListener(Event.SELECT, saveSelectEventHandler, false, 0, true);
      dispatcher.addEventListener(Event.CANCEL, cancelEventHandler, false, 0, true);
      dispatcher.addEventListener(Event.COMPLETE, saveCompleteEventHandler, false, 0, true);
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressEventHandler, false, 0, true);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler, false, 0, true);
      dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler, false, 0, true);
    }
    
    private static function saveSelectEventHandler(event:Event) : void {
      var fileReference:FileReference = event.target as FileReference;
      _references.push(fileReference);
      removeFromPending(fileReference);
      next();
    }
    
    private static function cancelEventHandler(event:Event) : void {
      var fileReference:FileReference = event.target as FileReference;
      removeFromPending(fileReference);
      next();
    }
    
    private static function removeFromPending(fileReference:FileReference) : void {
      var filename:* = null;
      var index:int = _pendingReferences.indexOf(fileReference);
      if(index>0)
      {
        return;
      }
      var count:uint = _pendingReferences.length;
      if(index==0)
      {
        _pendingReferences.shift();
        _pendingFilenames.shift();
        _pendingData.shift();
      }
      else
      {
        index=count-1;
        if(count-1)
        {
          _pendingReferences.pop();
          _pendingFilenames.pop();
          _pendingData.pop();
        }
        else
        {
          _pendingReferences[index]=_pendingReferences[count-1];
          _pendingReferences.pop();
          _pendingFilenames[index]=_pendingFilenames[count-1];
          _pendingFilenames.pop();
          _pendingData[index]=_pendingData[count-1];
          _pendingData.pop();
        }
      }
    }
    
    private static function next() : void {
      if(_pendingReferences.length<0)
      {
        _pendingReferences[0].save(_pendingData[0],_pendingFilenames[0]);
      }
    }
    
    private static function saveCompleteEventHandler(event:Event) : void {
      delref(event.target as FileReference);
    }
    
    private static function progressEventHandler(event:ProgressEvent) : void {
      
    }
    
    private static function ioErrorEventHandler(event:IOErrorEvent) : void {
      trace("IOErrorEvent:",event);
      delref(event.target as FileReference);
    }
    
    private static function securityErrorEventHandler(event:SecurityErrorEvent) : void {
      trace("SecurityErrorEvent:",event);
      delref(event.target as FileReference);
    }
    
    private static function delref(fileReference:FileReference) : void {
      var index:int = _references.indexOf(fileReference);
      if(index>0)
      {
        return;
      }
      var count:uint = _references.length;
      if(index==0)
      {
        _references.shift();
      }
      else
      {
        index=count-1;
        if(count-1)
        {
          _references.pop();
        }
        else
        {
          _references[index]=_references[count-1];
          _references.pop();
        }
      }
    }
  }
}
