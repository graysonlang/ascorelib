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
  // ==========================================================================
  //  Imports
  // --------------------------------------------------------------------------
  import flash.display.Sprite;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.FontDescription;
  import flash.text.engine.Kerning;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextElement;
  import flash.text.engine.TextLine;
  
  // ==========================================================================
  //	Class
  // --------------------------------------------------------------------------
  public final class OutputDisplay extends Sprite
  {
    // ========================================================================
    //  Constants
    // ------------------------------------------------------------------------
    private static const MARGIN:uint = 8;
    
    // ========================================================================
    //  Properties
    // ------------------------------------------------------------------------
    private var _count:uint;
    private var _fontSize:Number;
    private var _leading:Number;
    private var _marginH:Number;
    private var _marginV:Number;
    private var _fontDescription:FontDescription;
    private var _elementFormat:ElementFormat;
    private var _textElements:Vector.<TextElement>;
    private var _textBlocks:Vector.<TextBlock>;
    private var _textLines:Vector.<TextLine>;
    
    // ========================================================================
    //  Constructor
    // ------------------------------------------------------------------------
    public function OutputDisplay(count:uint = 10, fontColor:uint = 10066329, fontName:String="_sans", fontSize:Number=16, fontAlpha:Number=1, fontWeight:String="normal", fontPosture:String="normal", fontLookup:String="device", renderingMode:String="cff", cffHinting:String="horizontalStem")
    {
      var i:* = 0;
      var textElement:* = null;
      var textBlock:* = null;
      var textLine:* = null;
      super();
      
      _count = count;
      _textElements = new Vector.<TextElement>(_count,true);
      _textBlocks = new Vector.<TextBlock>(_count,true);
      _textLines = new Vector.<TextLine>(_count,true);
      _fontSize = fontSize;
      _leading = _fontSize * 1.25;
      _marginH = _fontSize;
      _marginV = _fontSize;
      _fontDescription = new FontDescription(
        fontName ? fontName : "_sans",
        fontWeight,
        fontPosture,
        fontLookup,
        renderingMode,
        cffHinting
      );
      _fontDescription.locked = true;
      _elementFormat = new ElementFormat(_fontDescription,_fontSize,fontColor);
      _elementFormat.kerning = Kerning.ON;
      i=0;
      while(i<count)
      {
        textElement=new TextElement(" ",_elementFormat);
        _textElements[i]=textElement;
        textBlock=new TextBlock(textElement);
        _textBlocks[i]=textBlock;
        textLine=textBlock.createTextLine();
        textLine.x=_marginH;
        textLine.y=i*_leading+_marginV+_fontSize;
        textLine.mouseEnabled=false;
        addChild(textLine);
        _textLines[i]=textLine;
        i++;
      }
    }
    
    // ========================================================================
    //  Methods
    // ------------------------------------------------------------------------
    public function out(index:uint, ... parameters) : void {
      var i:uint = 0;
      if (index >= _count)
        return;
      
      var textElement:TextElement = _textElements[index];
      var textBlock:TextBlock = _textBlocks[index];
      var textLine:TextLine = _textLines[index];
      var text:String = textElement.text;
      var string:String = parameters.join(" ");
      if(string==null||string=="")
      {
        string=" ";
      }
      textElement.replaceText(0,text.length,string);
      textBlock.recreateTextLine(textLine);
      textLine.x=_marginH;
      textLine.y=index*_leading+_marginV+_fontSize;
      textBlock.releaseLineCreationData();
      var w:* = 0.0;
      var h:* = 0.0;
      var x:* = 1.7976931348623157E308;
      var y:* = 1.7976931348623157E308;
      var bottom:* = 0.0;
      var count:uint = _textLines.length;
      i=0;
      while(i<count)
      {
        if(_textElements[i].text!=" ")
        {
          textLine=_textLines[i];
          x=Math.min(x,textLine.x);
          y=Math.min(y,textLine.y-textLine.ascent);
          w=Math.max(w,textLine.width);
          bottom=Math.max(bottom,textLine.y);
        }
        i++;
      }
      this.graphics.clear();
      this.graphics.beginFill(0,0.25);
      this.graphics.drawRect(x-8,y-8,w+8*2,bottom-y+8*2);
    }
  }
}
