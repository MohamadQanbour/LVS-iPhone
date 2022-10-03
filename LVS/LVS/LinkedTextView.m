//
//  LinkedTextView.m
//
//  Created by Benjamin Bojko on 10/22/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Benjamin Bojko
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "LinkedTextView.h"

@implementation LinkedTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
	self = [super initWithFrame:frame textContainer:textContainer];
	if (self) {
		[self setupLinkedTextView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupLinkedTextView];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self setupLinkedTextView];
}

- (void)setupLinkedTextView {
	_linkTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLinkTapGestureRecognizer:)];
	_linkTapGestureRecognizer.cancelsTouchesInView = NO;
	_linkTapGestureRecognizer.delaysTouchesBegan = NO;
	_linkTapGestureRecognizer.delaysTouchesEnded = NO;
	[self addGestureRecognizer:_linkTapGestureRecognizer];
}

/**
 *  Since UITextViews only open links on long-press, we want to check
 *  if a user pressed a link in the text view right away. We can do this
 *  by getting the text attributes at the tap location and checking for
 *  a link in the attributed string.
 */
- (void)handleLinkTapGestureRecognizer:(UITapGestureRecognizer *)tapRecognizer {
	UITextView *textView = self;
	CGPoint tapLocation = [tapRecognizer locationInView:textView];
	
	// we need to get two positions since attributed links only apply to ranges with a length > 0
	UITextPosition *textPosition1 = [textView closestPositionToPoint:tapLocation];
	UITextPosition *textPosition2 = [textView positionFromPosition:textPosition1 offset:1];

	// check if we're beyond the max length and go back by one
	if (!textPosition2) {
		textPosition1 = [textView positionFromPosition:textPosition1 offset:-1];
		textPosition2 = [textView positionFromPosition:textPosition1 offset:1];
	}

	// abort if we still don't have a string that's long enough
	if (!textPosition2) {
		return;
	}
	
	// get the offset range of the character we tapped on
	UITextRange *range = [textView textRangeFromPosition:textPosition1 toPosition:textPosition2];
	NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:range.start];
	NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:range.end];
	NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
	
	if (offsetRange.location == NSNotFound || offsetRange.length == 0) {
		return;
	}

	if (NSMaxRange(offsetRange) > textView.attributedText.length) {
		return;
	}
	
	// now grab the link from the string
	NSAttributedString *attributedSubstring = [textView.attributedText attributedSubstringFromRange:offsetRange];
	NSString *link = [attributedSubstring attribute:NSLinkAttributeName atIndex:0 effectiveRange:nil];

	if (!link) {
		return;
	}
	
	NSURL *URL = [NSURL URLWithString:link];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
		// abort if the delegate doesn't allow us to open this URL
		if (![self.delegate textView:self shouldInteractWithURL:URL inRange:offsetRange]) {
			return;
		}
	}
	
    [[UIApplication sharedApplication] openURL:URL];
}

@end
