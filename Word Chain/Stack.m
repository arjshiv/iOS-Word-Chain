//
//  HSUStack.m
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/14/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

#import "Stack.h"

@implementation Stack

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
//    [m_array release];
//    [self dealloc];
//    [super dealloc];
//}

- (void)push:(id)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
}
- (id)pop
{
    id obj = nil;
    if(m_array.count > 0)
    {
//        obj = [[[m_array lastObject]retain]autorelease]; //Removed to comply with ARC
        obj = [m_array lastObject];
        [m_array removeLastObject];
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
