//
//  AppDelegate.m
//  watermarker
//
//  Created by FancyZero on 3/16/15.
//  Copyright (c) 2015 f. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation myView

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        // Only a copy operation allowed so just copy the data
    } else if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
    }
    return YES;
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        // Only a copy operation allowed so just copy the data
    } else if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for ( NSString* file in files)
        {
            [self addMask:file];
        }
    }
    
    return;
}
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        if (sourceDragMask & NSDragOperationGeneric) {
            return NSDragOperationGeneric;
        }
    }
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

-(void) addMask: (NSString*) filename
{
    // Insert code here to initialize your application
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *imagePath = [bundle pathForResource:@"uncle tuu" ofType:@"png"];
    
    NSImage * mark =  [[NSImage alloc] initWithContentsOfFile: imagePath ];
    NSImage * picture =  [[NSImage alloc] initWithContentsOfFile: filename ];
    NSImageRep *rep = [[picture representations] objectAtIndex:0];
    NSSize imageSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
    
    int width = imageSize.width;
    int height = imageSize.height;
    NSBitmapImageRep* ImageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bitmapFormat:0 bytesPerRow:0 bitsPerPixel:0];
    NSGraphicsContext* aContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:ImageRep];
    [NSGraphicsContext setCurrentContext:aContext];
    [picture drawInRect:CGRectMake(0, 0, picture.size.width, picture.size.height)];
    
    CGFloat destWidth =mark.size.width/mark.size.height * picture.size.height/3;
    CGFloat destHeight = picture.size.height/3;
    [mark drawInRect:CGRectMake(picture.size.width - destWidth, picture.size.height - destHeight, destWidth, destHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.3];
//    NSImage *resultimage = [[NSImage alloc] initWithCGImage:[ImageRep CGImage] size:NSMakeSize(width,height)];
    
    
    //    NSBitmapImageRep *ImageRep = [[resultimage representations] objectAtIndex: 0];
    NSData *data = [ImageRep representationUsingType: NSPNGFileType properties: nil];
    NSString* destfile = [[filename stringByDeletingPathExtension] stringByAppendingString:@".marked.jpg"] ;
    
    
    [data writeToFile: destfile atomically: NO];
}

@end

@interface AppDelegate ()

@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [_view registerForDraggedTypes:[NSArray arrayWithObjects:
                                   NSColorPboardType, NSFilenamesPboardType, nil]];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application

    
    

}

@end
