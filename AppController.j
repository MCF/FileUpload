/*
 * AppController.j
 * FileUpload Test application.
 *
 * Created by Mike Fellows on April 28, 2010.
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPWebView.j>
@import "FileUpload.j"


@implementation AppController : CPObject
{
    TextDisplay statusDisplay;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
                                                styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];

    var urlString = "http://192.168.0.102:2345/file_upload/";

    var fileUploadButton = [[UploadButton alloc] initWithFrame:CGRectMake(10, 15, 100, 24)];
    [fileUploadButton setTitle:"Upload File"];
    [fileUploadButton setBordered:YES];
    [fileUploadButton allowsMultipleFiles:YES];
    [fileUploadButton setURL:urlString];
    [fileUploadButton setDelegate:self];
    [contentView addSubview:fileUploadButton];

    var urlLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 55, 500, 40)];
    [urlLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
    [urlLabel setStringValue:"The Upload POST URL is: " + urlString];
    [urlLabel sizeToFit];
    [urlLabel setSelectable:YES];
    [contentView addSubview:urlLabel];

    statusDisplay = [[TextDisplay alloc] initWithFrame:CGRectMake(10, 90, 500, 300)];
    [contentView addSubview:statusDisplay];

    [theWindow orderFront:self];
}

-(void) uploadButton:(UploadButton)button didChangeSelection:(CPArray)selection
{
    [statusDisplay clearDisplay];
    [statusDisplay appendString:"Selection has been made: " + selection];

    [button submit];
}

-(void) uploadButton:(UploadButton)button didFailWithError:(CPString)anError
{
    [statusDisplay appendString:"Upload failed with this error: " + anError];
}

-(void) uploadButton:(UploadButton)button didFinishUploadWithData:(CPString)response
{
    [statusDisplay appendString:"Upload finished with this response: " + response];

    [button resetSelection];
}

-(void) uploadButtonDidBeginUpload:(UploadButton)button
{
    [statusDisplay appendString:"Upload has begun with selection: " + [button selection]];
}

@end

@implementation TextDisplay: CPWebView
{
    CPString currentString;
}

- (id)initWithFrame:(CPRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        currentString = "";
    }
    
    return self;
}

- (void)appendString:(CPString)aString
{
    currentString = currentString + "<pre>" + aString + "</pre>";
    [self loadHTMLString: currentString];
}


-(void)clearDisplay
{
    currentString = "";
    [self loadHTMLString:""];
}

@end
