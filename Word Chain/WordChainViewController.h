//
//  WordChainViewController.h
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/9/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Queue.h"
#import "Stack.h"

@class Queue;
@class Stack;


@interface WordChainViewController : UIViewController<UITextFieldDelegate>{
    
    NSSet           *listOfEnglishWords;
    NSMutableSet    *visitedWords;
    NSMutableArray  *wordsToCheckForChain;

    Stack           *stackToStoreSuccessPath;
    
    NSString        *initialWord; //String to start from
    NSString        *finalWord;   //String we want to reach from initial
    
}

@property (strong, nonatomic) IBOutlet UITextField *startingWordTextField;
@property (strong, nonatomic) IBOutlet UITextField *destinationWordTextField;
@property (strong, nonatomic) IBOutlet UITextView *textViewForResult;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)goButtonPressed:(id)sender;

- (void)initializeSets;

- (BOOL)isTheWordValid:(NSString *)string;

- (Queue *)spawnPossibilitiesForString:(NSString *)candidateWord;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)areTheTextInputsValid;

- (BOOL)forWordChainCheckTheString:(NSString *)theWord;

- (BOOL)findTheWordChain;

@end
