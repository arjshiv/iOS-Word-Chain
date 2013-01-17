//
//  WordChainViewController.m
//  Word Chain
//
//  Created by Arjun Shivanand Kannan on 1/9/13.
//  Copyright (c) 2013 Arjun Shivanand Kannan. All rights reserved.
//

#import "WordChainViewController.h"

@interface WordChainViewController () {

}


@end


@implementation WordChainViewController

@synthesize startingWordTextField;
@synthesize destinationWordTextField;
@synthesize textViewForResult;
@synthesize resultLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    textViewForResult.hidden = YES;
    resultLabel.hidden = YES;
    
    //Load the list of words
    [self initializeSets];
    
}


- (IBAction)goButtonPressed:(id)sender {
    initialWord = [startingWordTextField.text lowercaseString];
    finalWord = [destinationWordTextField.text lowercaseString];
    resultLabel.hidden = YES;
    textViewForResult.hidden = YES;
    
    //Make the simulator keyboard go away
    [startingWordTextField resignFirstResponder];
    [destinationWordTextField resignFirstResponder];

    if ([self areTheTextInputsValid]) {

        if ([self findTheWordChain]) {
            textViewForResult.text = [[stackToStoreSuccessPath show] componentsJoinedByString:@"\n"];
            resultLabel.text = [NSString stringWithFormat:@"Word Chain Exists"];
            resultLabel.hidden = NO;
            textViewForResult.hidden = NO;
            [stackToStoreSuccessPath clear];
        }
        
        else{
            textViewForResult.text = [NSString stringWithFormat:@"Could not find a word chain between '%@' and '%@'", initialWord, finalWord];
            resultLabel.text = [NSString stringWithFormat:@"Result"];
            resultLabel.hidden = NO;
            textViewForResult.hidden = NO;
            [stackToStoreSuccessPath clear];
        }
        
    }
    
    
    //Empty the text fields at the end
    startingWordTextField.text = @"";
    destinationWordTextField.text = @"";
}


-(void)initializeSets {
    
    //Initialize the set with the list of English Words
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Dictionary" ofType:@"txt"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    string = [string lowercaseString];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    listOfEnglishWords = [[[NSSet alloc] init] setByAddingObjectsFromArray:[string componentsSeparatedByString:@"\n"]];
    
    //Initialize the other Sets
    visitedWords = [[NSMutableSet alloc] init];
    
    stackToStoreSuccessPath = [[Stack alloc] init];
    
}

-(BOOL)findTheWordChain{
    
    //Let's see if it exists
    BOOL wordChainExists = [self forWordChainCheckTheString:initialWord];
    if(wordChainExists){ //There is a Word Chain from the initial word to the final word
        //Add the initial word to the stack
        [stackToStoreSuccessPath push:initialWord];
        
        //Clear the set of visited words
        [visitedWords removeAllObjects];
    }
    return wordChainExists;
}


-(BOOL)forWordChainCheckTheString:(NSString *)theWord{
    
    if ([theWord isEqualToString:finalWord]) {
        return YES;
    }
    
    Queue *possibleMutations = [self spawnPossibilitiesForString:theWord];
    NSArray *possibleMutationArray = [NSArray arrayWithArray:[possibleMutations show]];
    
    for (id word in possibleMutationArray) {
        if (![visitedWords containsObject:word]) {
            if ([self forWordChainCheckTheString:word]) {
                //If the check has already returned yes, we can push it into the stack representing the success path
//                NSLog(@"Stack word : %@\n",word);
                [stackToStoreSuccessPath push:word];
                return YES;
            }
            //Otherwise, we simply continue by putting the word into out visited set
            [visitedWords addObject:word];
        }
    }
    //If we reach this point, we haven't found the word chain yet
    return NO;
}

-(Queue *)spawnPossibilitiesForString:(NSString *)candidateWord{
    //Add the current string to the set of visited words
    [visitedWords addObject:candidateWord];
    //Need to make the string mutable so we can insetr characters at a given index
    NSMutableString *mutableCandidateWord = [NSMutableString stringWithString:candidateWord];
    //This is a queue into which we can insert spawned wordw which are valid
    Queue *queueForValidWordsGenerated = [[Queue alloc] init];
    
    int lengthOfWord = [candidateWord length];
    
    
    //Test for possibilities by deleting characters
    for (int i = 0; i < lengthOfWord; i++) {
        [mutableCandidateWord deleteCharactersInRange:NSMakeRange(i, 1)];
        if([self isTheWordValid:mutableCandidateWord]) {
            [queueForValidWordsGenerated enqueue:mutableCandidateWord];
        }
        //Return the word to its original state
        mutableCandidateWord = [NSMutableString stringWithString:candidateWord];
    }//End of deletions
    
    //Test for possibilities by inserting characters
    for (int i = 0; i <= lengthOfWord; i++) {
        char tempCharacter = 97;
        while (tempCharacter <= 122) {
            [mutableCandidateWord insertString:[NSString stringWithFormat:@"%c",tempCharacter] atIndex:i];
            if([self isTheWordValid:mutableCandidateWord]) {
                [queueForValidWordsGenerated enqueue:mutableCandidateWord];
            }
            //Return the word to its original state
            mutableCandidateWord = [NSMutableString stringWithString:candidateWord];
            tempCharacter++;
        }
    }
    //End of insertions
    
    //Test for possibilities by swapping characters out
    for (int i = 0; i < lengthOfWord; i++) {
        char tempCharacter = 97;
        while (tempCharacter <= 122) {
            NSString *tempString  = [NSString stringWithFormat:@"%c",tempCharacter];
            mutableCandidateWord = (NSMutableString *)[mutableCandidateWord stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:tempString];
            
            if([self isTheWordValid:mutableCandidateWord]) {
                [queueForValidWordsGenerated enqueue:mutableCandidateWord];
            }
            tempCharacter++;
        }
        //Return to original state
        mutableCandidateWord = [NSMutableString stringWithString:candidateWord];
    }//End of the swap test
    
    [queueForValidWordsGenerated removeDuplicateElements];
    
    return queueForValidWordsGenerated;
    
}

-(BOOL)isTheWordValid:(NSString *)string{

    BOOL result = NO;
    if (([listOfEnglishWords containsObject:string]) && (![visitedWords containsObject:string])) {
        result = YES;
    }
    
    return result;
}

- (BOOL)areTheTextInputsValid {
    if ([initialWord isEqualToString:@""] || [finalWord isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Empty Text Field(s)!" message:@"One or both of your text fields are empty. Please enter both the initial and destionation words" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [myAlertView show];
        startingWordTextField.text = @"";
        destinationWordTextField.text = @"";
        return NO;
    }
    else if (![listOfEnglishWords containsObject:initialWord] && ![listOfEnglishWords containsObject:finalWord]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Unrecognized Words!" message:[NSString stringWithFormat:@"%@ and %@ are not in the dictionary", initialWord, finalWord] delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [myAlertView show];
        startingWordTextField.text = @"";
        destinationWordTextField.text = @"";
        return NO;
    }
    else if (![listOfEnglishWords containsObject:initialWord] ){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Unrecognized Word!" message:[NSString stringWithFormat:@"%@ is not in the dictionary", initialWord] delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [myAlertView show];
        startingWordTextField.text = @"";
        destinationWordTextField.text = @"";
        return NO;
    }
    else if (![listOfEnglishWords containsObject:finalWord] ){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Unrecognized Word!" message:[NSString stringWithFormat:@"%@ is not in the dictionary", finalWord] delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [myAlertView show];
        startingWordTextField.text = @"";
        destinationWordTextField.text = @"";
        return NO;
    }
    else return YES;
}

- (void)viewDidUnload {
    startingWordTextField = nil;
    destinationWordTextField = nil;
    [self setStartingWordTextField:nil];
    [self setDestinationWordTextField:nil];
    [self setTextViewForResult:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
