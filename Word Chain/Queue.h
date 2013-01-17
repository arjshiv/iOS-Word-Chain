//
//  HSUQueue.h
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/14/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

//Modified from an earlier implementation by Cloud Hsu

#import <Foundation/Foundation.h>

@interface Queue : NSObject{

NSMutableArray* m_array;
    
}

- (void)enqueue:(id)anObject;
- (id)dequeue;
- (void)clear;
- (NSMutableArray *)show;
- (void)removeDuplicateElements;


@property (nonatomic, readonly) int count;

@end
