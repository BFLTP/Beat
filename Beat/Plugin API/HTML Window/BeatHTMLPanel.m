//
//  TestPanel.m
//  Beat
//
//  Created by Lauri-Matti Parppei on 11.9.2021.
//  Copyright © 2021 KAPITAN!. All rights reserved.
//

#import "BeatHTMLPanel.h"
#import "BeatScriptParser.h"

@interface BeatHTMLPanel ()
@end

@implementation BeatHTMLPanel

-(instancetype)initWithHTML:(NSString*)html width:(CGFloat)width height:(CGFloat)height host:(BeatScriptParser*)host {
	NSRect frame = NSMakeRect((NSScreen.mainScreen.frame.size.width - width) / 2, (NSScreen.mainScreen.frame.size.height - height) / 2, width, height);
	
	self = [super initWithContentRect:frame styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskUtilityWindow | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
	self.level = NSModalPanelWindowLevel;
	self.delegate = host;
	
	// We can't release the panel on close, because JSContext might hang onto it and cause a crash
	self.releasedWhenClosed = NO;
	
	_host = host;
	self.title = host.pluginName;

	
	WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
	config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
	
	[config.userContentController addScriptMessageHandler:self.host name:@"sendData"];
	[config.userContentController addScriptMessageHandler:self.host name:@"call"];
	[config.userContentController addScriptMessageHandler:self.host name:@"log"];

	_webview = [[WKWebView alloc] initWithFrame:NSMakeRect(0, 0, width, height) configuration:config];
	_webview.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

	[self setHTML:html];
	[self.contentView addSubview:_webview];
	
	return self;
}

- (void)setHTML:(NSString*)html {
	// Load template
	NSURL *templateURL = [NSBundle.mainBundle URLForResource:@"Plugin HTML template" withExtension:@"html"];
	NSString *template = [NSString stringWithContentsOfURL:templateURL encoding:NSUTF8StringEncoding error:nil];
	template = [template stringByReplacingOccurrencesOfString:@"<!-- CONTENT -->" withString:html];
	
	[_webview loadHTMLString:template baseURL:nil];
}

- (void)close {
	[self.host closePluginWindow:self];
}

- (void)closeWindow {
	[super close];
}

- (void)focus {
	[self makeFirstResponder:self.contentView];
}

- (void)setTitle:(NSString *)title {
	[super setTitle:title];
}

- (CGRect)getFrame {
	return self.frame;
}

- (void)runJS:(nonnull NSString *)js callback:(nullable JSValue *)callback {
	if (callback && !callback.isUndefined) {
		[_webview evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
			// Make sure we are on the main thread
			dispatch_async(dispatch_get_main_queue(), ^{
				[callback callWithArguments:data];
			});
		}];
	} else {
		[self.webview evaluateJavaScript:js completionHandler:nil];
	}
}

- (NSSize)screenSize {
	return self.screen.frame.size;
}


- (void)setPositionX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
	NSRect frame = (NSRect){ x, y, width, height };
	[self setFrame:frame display:YES];
}

@end