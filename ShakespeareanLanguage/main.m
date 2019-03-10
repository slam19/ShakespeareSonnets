//
//  main.m
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 2/28/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Concordance.h"
#import "WordNode.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Concordance *myConcordance = [[Concordance alloc]init];
        myConcordance.hashFunction = 5; //CHANGE THIS FOR DIFFERENT FUNCTIONS (1. djb, 2. sdbm, 3. polyroll, 4. simple)
        myConcordance.probingMethod = 0; //Change to 0 for linear probing, 1 for quadratic probing.
        
        
        [myConcordance loadSonnets];
        printf("Sonnet Word count: %d \n", (int) myConcordance.sonnetWords.count);
        //cant compare with command f because " word " ignores all instances of "word " and " word".
        [myConcordance fillConcordance];
        printf("Unique word count: %d \n", myConcordance.uniqueWordCount);
        printf("Number of collisions: %d \n", myConcordance.collisions);
        
    
        NSString *word = @"equipage"; //CHANGE THIS TO SEARCH FOR OTHER WORDS.
        WordNode *matches = [myConcordance contains: word];
        if(!matches){
            printf("No occurences of %s in Shakespeare's Sonnets.\n", [word UTF8String]);
        }else{
            for( int i = 0; i< matches.locations.count; i++){
                Location *l= [matches.locations objectAtIndex:i];
                printf("%s appears at the position %d on line %d of Sonnet %d.\n", [word UTF8String], l.wordPosition,l.sonnetLine, l.sonnetNumber);
            }
            printf("%s appears a total of %d times in Shakespeare's Sonnets.\n", [word UTF8String], (int) matches.locations.count);
        }

    }
    return 0;
    //    return NSApplicationMain(argc, argv);
}
