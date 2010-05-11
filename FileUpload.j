//
// FileUpload.j
// Editor
//
// Created by Francisco Tolmasky on 03/04/08.
// Copyright 2005 - 2008, 280 North, Inc. All rights reserved.
//

@import <Foundation/CPObject.j>
@import <Foundation/CPValue.j>
@import <Foundation/CPException.j>

var UPLOAD_IFRAME_PREFIX = "UPLOAD_IFRAME_",
    UPLOAD_FORM_PREFIX = "UPLOAD_FORM_",
    UPLOAD_INPUT_PREFIX = "UPLOAD_INPUT_";

@implementation UploadButton : CPButton
{
    DOMElement      _DOMIFrameElement;
    DOMElement      _fileUploadElement;
    DOMElement      _uploadForm;
    
    function        _mouseMovedCallback;
    function        _mouseUpCallback;
    
    id              _delegate;
        
    CPDictionary    _parameters;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        var hash = [self hash];
        
        _uploadForm = document.createElement("form");
        
        _uploadForm.method = "POST";
        _uploadForm.action = "#";

        if(document.attachEvent)
            _uploadForm.encoding = "multipart/form-data";
        else
            _uploadForm.enctype = "multipart/form-data";
        
        _fileUploadElement = document.createElement("input");
        
        _fileUploadElement.type = "file";
        _fileUploadElement.name = "file";
        
        _fileUploadElement.onmousedown = function(aDOMEvent)
        {    
            aDOMEvent = aDOMEvent || window.event;
            
            var x = aDOMEvent.clientX,
                y = aDOMEvent.clientY,
                theWindow = [self window];
            
            [CPApp sendEvent:[CPEvent mouseEventWithType:CPLeftMouseDown location:[theWindow convertBridgeToBase:CGPointMake(x, y)]
                modifierFlags:0 timestamp:0 windowNumber:[theWindow windowNumber] context:nil eventNumber:-1 clickCount:1 pressure:0]];
            
            if (document.addEventListener)
            {
                document.addEventListener(CPDOMEventMouseUp, _mouseUpCallback, NO);
                document.addEventListener(CPDOMEventMouseMoved, _mouseMovedCallback, NO);
            }
            else if(document.attachEvent)
            {
                document.attachEvent("on" + CPDOMEventMouseUp, _mouseUpCallback);
                document.attachEvent("on" + CPDOMEventMouseMoved, _mouseMovedCallback);
            }
        }

        _mouseUpCallback = function(aDOMEvent)
        {
            if (document.removeEventListener)
            {
                document.removeEventListener(CPDOMEventMouseUp, _mouseUpCallback, NO);
                document.removeEventListener(CPDOMEventMouseMoved, _mouseMovedCallback, NO);
            }
            else if(document.attachEvent)
            {
                document.detachEvent("on" + CPDOMEventMouseUp, _mouseUpCallback);
                document.detachEvent("on" + CPDOMEventMouseMoved, _mouseMovedCallback);
            }
            
            aDOMEvent = aDOMEvent || window.event;
            
            var x = aDOMEvent.clientX,
                y = aDOMEvent.clientY,
                theWindow = [self window];
            
            [CPApp sendEvent:[CPEvent mouseEventWithType:CPLeftMouseUp location:[theWindow convertBridgeToBase:CGPointMake(x, y)]
               modifierFlags:0 timestamp:0 windowNumber:[theWindow windowNumber] context:nil eventNumber:-1 clickCount:1 pressure:0]];
        }
        
        _mouseMovedCallback = function(aDOMEvent)
        {
            //ASSERT(mouse is down)
            
            aDOMEvent = aDOMEvent || window.event;
            
            var x = aDOMEvent.clientX,
                y = aDOMEvent.clientY,
                theWindow = [self window];
            
            [CPApp sendEvent:[CPEvent mouseEventWithType:CPLeftMouseDragged location:[theWindow convertBridgeToBase:CGPointMake(x, y)]
               modifierFlags:0 timestamp:0 windowNumber:[theWindow windowNumber] context:nil eventNumber:-1 clickCount:1 pressure:0]];
        }
        
        _uploadForm.style.position = "absolute";
        _uploadForm.style.top = "0px";
        _uploadForm.style.left = "0px";
        _uploadForm.style.zIndex = 1000;
        
        _fileUploadElement.style.opacity = "0";
        _fileUploadElement.style.filter = "alpha(opacity=0)";
        
        _uploadForm.style.width = "100%";
        _uploadForm.style.height = "100%";
        
        _fileUploadElement.style.fontSize = "1000px";
        
        if (document.attachEvent)
        {
            _fileUploadElement.style.position = "relative";
            _fileUploadElement.style.top = "-10px";
            _fileUploadElement.style.left = "-10px";
            _fileUploadElement.style.width = "1px";
        }
        else
            _fileUploadElement.style.cssFloat = "right";    
                       
        _fileUploadElement.onchange = function()
        {
            [self uploadSelectionDidChange: _fileUploadElement.value];
        };
        
        _uploadForm.appendChild(_fileUploadElement);
        
        _DOMElement.appendChild(_uploadForm);
        
        _parameters = [CPDictionary dictionary];
        
        [self setBordered:NO];
    }
    
    return self;
}

- (void)setDelegate:(id)aDelegate
{
    _delegate = aDelegate;
}

- (id)delegate
{
    return _delegate;
}

- (void)setURL:(CPString)aURL
{
    _uploadForm.action = aURL;
}

- (void)uploadSelectionDidChange:(CPString)selection
{
    if ([_delegate respondsToSelector:@selector(uploadButton:didChangeSelection:)])
        [_delegate uploadButton: self didChangeSelection: selection];
}

- (CPString)selection
{
    return _fileUploadElement.value;
}

- (void)resetSelection
{
    _fileUploadElement.value = "";
}

- (void)uploadDidFinishWithResponse:(CPString)response
{    
    if ([_delegate respondsToSelector:@selector(uploadButton:didFinishUploadWithData:)])
        [_delegate uploadButton: self didFinishUploadWithData: response];
    
}

- (void)uploadDidFailWithError:(CPString)anError
{
    if ([_delegate respondsToSelector:@selector(uploadButton:didFailWithError:)])
        [_delegate uploadButton: self didFailWithError: anError];
}

- (BOOL)setValue:(CPString)aValue forParameter:(CPString)aParam
{
    if(aParam == "file")
        return NO;
        
    [_parameters setObject:aValue forKey:aParam];
    
    return YES;
}

- (void)parameters
{
    return _parameters;
}

- (void)submit
{        
    _uploadForm.target = "FRAME_"+(new Date());

    //remove existing parameters
    var index = _uploadForm.childNodes.length;
    while(index--)
        _uploadForm.removeChild(_uploadForm.childNodes[index]);    
    
    //append the parameters to the form
    var keys = [_parameters allKeys];
    for(var i = 0, count = keys.length; i<count; i++)
    {
        var element = document.createElement("input");
        
        element.type = "hidden";
        element.name = keys[i];
        element.value = [_parameters objectForKey:keys[i]];
        
        _uploadForm.appendChild(element);
    }
    
    _uploadForm.appendChild(_fileUploadElement);

    if(_DOMIFrameElement)
    {
        document.body.removeChild(_DOMIFrameElement);
        _DOMIFrameElement.onload = nil;
        _DOMIFrameElement = nil;   
    }
    
    if(window.attachEvent)
    {
        _DOMIFrameElement = document.createElement("<iframe id=\"" + _uploadForm.target + "\" name=\"" + _uploadForm.target + "\" />");    
        
        if(window.location.href.toLowerCase().indexOf("https") === 0)
            _DOMIFrameElement.src = "javascript:false";
    }
    else
    {
        _DOMIFrameElement = document.createElement("iframe");
        _DOMIFrameElement.name = _uploadForm.target;    
    }
        
    _DOMIFrameElement.style.width = "1px";
    _DOMIFrameElement.style.height = "1px";
    _DOMIFrameElement.style.zIndex = -1000;
    _DOMIFrameElement.style.opacity = "0";
    _DOMIFrameElement.style.filter = "alpha(opacity=0)";
    
    document.body.appendChild(_DOMIFrameElement);

    _onloadHandler = function()
    {
        try 
        {
            var responseText = _DOMIFrameElement.contentWindow.document.body ? _DOMIFrameElement.contentWindow.document.body.innerHTML : 
                                                                               _DOMIFrameElement.contentWindow.document.documentElement.textContent;

            [self uploadDidFinishWithResponse: responseText];
            
            window.setTimeout(function(){
                document.body.removeChild(_DOMIFrameElement);
                _DOMIFrameElement.onload = nil;
                _DOMIFrameElement = nil;
            }, 100);
        }
        catch (e)
        {
            [self uploadDidFailWithError:e];
        }
    }    
        
    if (window.attachEvent)
    {
        _DOMIFrameElement.onreadystatechange = function() 
        {
            if (this.readyState == "loaded" || this.readyState == "complete")
                _onloadHandler();
        }
    }

    _DOMIFrameElement.onload = _onloadHandler;

    _uploadForm.submit();
    
    if ([_delegate respondsToSelector:@selector(uploadButtonDidBeginUpload:)])
        [_delegate uploadButtonDidBeginUpload:self];
}

- (void)disposeOfEvent:(CPEvent)anEvent
{
    if ([anEvent type] == CPLeftMouseDown)
        [CPApp setTarget:self selector:@selector(disposeOfEvent:) forNextEventMatchingMask:CPLeftMouseUpMask untilDate:nil inMode:nil dequeue:YES];
}

- (void)mouseDown:(CPEvent)anEvent
{
    [CPApp setTarget:self selector:@selector(disposeOfEvent:) forNextEventMatchingMask:CPLeftMouseDownMask untilDate:nil inMode:nil dequeue:YES];

    [super mouseDown:anEvent];
}

@end

function _CPGUID()
{
    var g = "";
    
    for(var i = 0; i < 32; i++)
        g += Math.floor(Math.random() * 0xF).toString(0xF);
        
    return g;
}


