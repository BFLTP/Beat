//
//  NSString+Whitespace.m
//  Writer / Beat
//
//  Created by Hendrik Noeller on 01.04.16.
//  Copyright © 2016 Hendrik Noeller. All rights reserved.
//

#import "NSString+Whitespace.h"

@implementation NSString (Whitespace)

- (bool)containsOnlyWhitespace
{
    NSUInteger length = [self length];
    NSCharacterSet* whitespaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (int i = 0; i < length; i++) {
        char c = [self characterAtIndex:i];
        if (![whitespaceSet characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (bool)containsUppercaseLetters
{
    NSUInteger length = [self length];
    NSCharacterSet* characters = [NSCharacterSet uppercaseLetterCharacterSet];
    for (int i = 0; i < length; i++) {
        char c = [self characterAtIndex:i];
        if ([characters characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}


- (bool)containsOnlyUppercase
{
	return [[self uppercaseString] isEqualToString:self] && [self containsUppercaseLetters];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
	NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
															   options:NSBackwardsSearch];
	if (rangeOfLastWantedCharacter.location == NSNotFound) {
		return @"";
	}
	return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
}

@end
