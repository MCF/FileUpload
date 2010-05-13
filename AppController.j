/*
 * AppController.j
 * FileUpload Test application.
 *
 * Created by Mike Fellows on April 28, 2010.
 */

@import <Foundation/CPObject.j>
@import "FileUpload.j"


@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
                                                styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];

    var fileUploadButton = [[UploadButton alloc] initWithFrame:CGRectMake(10, 10, 100, 24)];
    [fileUploadButton setTitle:"Upload File"];
    [fileUploadButton setBordered:YES];
    [fileUploadButton allowsMultipleFiles:YES];
    [fileUploadButton setURL:"http://localhost:2345/file_upload/"];
    [fileUploadButton setDelegate:self];
    [contentView addSubview:fileUploadButton];

    [theWindow orderFront:self];
}

-(void) uploadButton:(UploadButton)button didChangeSelection:(CPArray)selection
{
    console.log("Selection has been made: " + selection);

    [button submit];
}

-(void) uploadButton:(UploadButton)button didFailWithError:(CPString)anError
{
    console.log("Upload failed with this error: " + anError);
}

-(void) uploadButton:(UploadButton)button didFinishUploadWithData:(CPString)response
{
    console.log("Upload finished with this response: " + response);

    [button resetSelection];
}

-(void) uploadButtonDidBeginUpload:(UploadButton)button
{
    console.log("Upload has begun with selection: " + [button selection]);
}

@end
