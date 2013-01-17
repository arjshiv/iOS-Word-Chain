//
//  HSUQueue.m
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/14/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

#import "Queue.h"

@implementation Queue

@synthesize count;

- (id)init
{
	if( self=[super init] )
	{
		m_array = [[NSMutableArray alloc] init];
		count = 0;
	}
	return self;
}

//- (void)dealloc {
//	[m_array release];
//	[self dealloc];
//    [super dealloc];
//}

- (void)enqueue:(id)anObject
{
	[m_array addObject:anObject];
	count = m_array.count;
}
- (id)dequeue
{
	id obj = nil;
	if(m_array.count > 0)
	{
//		obj = [[[m_array objectAtIndex:0]retain]autorelease];
        obj = [m_array objectAtIndex:0];
		[m_array removeObjectAtIndex:0];
		count = m_array.count;
	}
	return obj;
}

- (void)clear
{
	[m_array removeAllObjects];
	count = 0;
}

-(void)removeDuplicateElements {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(id element in m_array){
        if (![tempArray containsObject:element]) {
            [tempArray addObject:element];
        }
    }
    m_array = (NSMutableArray *)[NSArray arrayWithArray:tempArray];
}

- (NSMutableArray *)show{
    return m_array;
}

@end
