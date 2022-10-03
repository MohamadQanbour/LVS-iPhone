//
//  LinkedTextView.h
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

#import <UIKit/UIKit.h>

/**
 *  This is a subclass of @p UITextView that solves the problem of embedded link requiring a long-press
 *  before triggering. It uses a tap gesture recognizer to detect the attributes at the tap location and 
 *  checks for embedded links. If a link is detected, it calls @p -[UITextViewDelegate textView:shouldInteractWithTextAttachment:inRange:]
 *  before calling @p -[UIApplication openURL:].
 */
@interface LinkedTextView : UITextView

@property (nonatomic, strong, readonly) UITapGestureRecognizer *linkTapGestureRecognizer;

@end
