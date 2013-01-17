//
//  HSUStack.h
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/14/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

//Modified from an earlier implementation : Credits for the stack implementation - Cloud Hsu at http://www.codeproject.com/Tips/226892/How-to-implement-Stack-in-Object-C

#import <Foundation/Foundation.h>

@interface Stack : NSObject {
    NSMutableArray* m_array;
    int count;
}

- (void)push:(id)anObject;
- (id)pop;
- (void)clear;
- (NSMutableArray *)show;
- (void)removeDuplicateElements;
@property (nonatomic, readonly) int count;


@end
