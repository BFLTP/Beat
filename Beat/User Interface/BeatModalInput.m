//
//  BeatModalInput.m
//  Beat
//
//  Created by Lauri-Matti Parppei on 21.12.2020.
//  Copyright © 2020 KAPITAN!. All rights reserved.
//
/*
 
 This class can be retained and reused. The completion block WILL NOT RUN if the user canceled
 the operation, but can return an empty string.
 
 BeatModalInput *input = [[BeatModalInput alloc] init];
 [self inputBoxWithMessage:@"Input Prompt" text:@"Some informative text" placeholder:@"Placeholder..." forWindow:(nonnull NSWindow *) completion:^(NSString * _Nonnull result) {
	 NSLog(@"the user typed %@", result);
 }];
 
 */

#import "BeatModalInput.h"
#import <Cocoa/Cocoa.h>

@interface BeatModalInput ()
@property NSAlert *dialog;
@property NSTextField *inputField;
@end
@implementation BeatModalInput



- (void)inputBoxWithMessage:(NSString*)message text:(NSString*)infoText placeholder:(NSString*)placeholder forWindow:(NSWindow*)window completion:(void (^)(NSString *result))completion {
	
	if (!_dialog) {
		_dialog = [[NSAlert alloc] init];
		[_dialog addButtonWithTitle:@"OK"];
		[_dialog addButtonWithTitle:@"Cancel"];
		
		NSRect frame = NSMakeRect(0, 0, 250, 24);
		_inputField = [[NSTextField alloc] initWithFrame:frame];
		[_dialog setAccessoryView:_inputField];
	}
	
	_dialog.messageText = message;
	_dialog.informativeText = infoText;
	_inputField.stringValue = @"";
	_inputField.placeholderString = placeholder;
	
	[_dialog.window setInitialFirstResponder:_inputField];
	
	[_dialog beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
		if (returnCode == NSModalResponseOK || returnCode == NSAlertFirstButtonReturn) {
			completion(self.inputField.stringValue);
		}
	}];
}

@end
