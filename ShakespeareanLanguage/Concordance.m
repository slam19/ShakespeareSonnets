//
//  Concordance.m
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 2/28/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Concordance.h"
#import "WordNode.h"
#import "Location.h"

@implementation Concordance

-(id) init{
    self = [super init];
    if (self){
        self.concordance = [[NSMutableArray alloc]init];
        //self.tableSize = 4417;
        self.tableSize = 22807;
        for (int i = 0; i<self.tableSize; i++){
            WordNode *emptyNode = [[WordNode alloc]initEmptyWord];
            [self.concordance addObject:emptyNode];
        }
        self.sonnetWords = [[NSMutableArray alloc] init];
        self.hashFunction =2;
        self.probingMethod = 0;
        self.collisions = 0;
        self.uniqueWordCount=0;
    }
    return self;
}

-(void) loadSonnets{
    NSString *myFilePath = [[NSBundle mainBundle] pathForResource:@"sonnets"ofType:@"txt"];
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:myFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *punctuation = [NSArray arrayWithObjects:@":",@".",@",",@"?",@";",@"--",@"!",@"'",nil];
    NSString *textWithoutPunctuation = fileContent;
    for (int i = 0; i<8; i++){
        textWithoutPunctuation = [textWithoutPunctuation stringByReplacingOccurrencesOfString:[punctuation objectAtIndex:i] withString:@""];
    }
    NSMutableArray* allLineStrings = //array of string lines
    [[textWithoutPunctuation componentsSeparatedByCharactersInSet:
      [NSCharacterSet newlineCharacterSet]]mutableCopy];
    [allLineStrings removeObject:@""];
    
    int sonnetCount = 0;
    int lineCount = 1;
    for (int i = 0; i< allLineStrings.count; i++){
        NSMutableArray *wordsInLine = [[[allLineStrings objectAtIndex:i] componentsSeparatedByString:@" "]mutableCopy]; //array of words in same line
        [wordsInLine removeObject:@""];
        if(wordsInLine.count == 1){ //use roman numerals to keep track of sonnet number.
            lineCount= 0 ;
            sonnetCount++;
        }else{
            for (int i = 0; i<wordsInLine.count; i++){
                NSString *wordStr = [wordsInLine objectAtIndex:i];
                wordStr = [wordStr lowercaseString];
                WordNode *wordNode = [[WordNode alloc] initWithWord:wordStr AtPosition: i+1 onLine: lineCount ofSonnet:sonnetCount ];
                [self.sonnetWords addObject: wordNode];
            }
        }
        lineCount++;
    }
    //    printf("checkpoint");
}

-(void) fillConcordance{
    for (int i = 0; i< self.sonnetWords.count; i++){
        WordNode *wNode =[self.sonnetWords objectAtIndex:i];
        int index;
        
        switch (self.hashFunction){
            case 1:
                index = [self djbHash:wNode.word];
                break;
            case 2:
                index = [self sdbmHash: wNode.word ofLength:(int) wNode.word.length-1];
                index = index & 0x7FFFFFFF;
                index = index % self.tableSize;
                break;
            case 3:
                index = [self polyRollHash:wNode.word ];
                break;
            case 4:
                index = [self simpleHash: wNode.word ];
                break;
            case 5:
                index = [self rsHash:wNode.word];
                break;
            default:
                index = [self djbHash:wNode.word];
                break;
        }
        
        WordNode* nodeAtIndex = [self.concordance objectAtIndex:index];
        if(!nodeAtIndex.locations){
            [self.concordance replaceObjectAtIndex:index withObject:wNode];
            self.uniqueWordCount++;
        }else{
            index = [self resolveCollisionAt:index withString:wNode.word];
            WordNode *temp = [self.concordance objectAtIndex:index];
            if([temp.word isEqualToString:wNode.word]){
                [temp.locations addObject:[wNode.locations objectAtIndex:0]];
            }else{
                [self.concordance replaceObjectAtIndex:index withObject:wNode];
                self.uniqueWordCount++;
            }
        }
    }
}

-(int) djbHash: (NSString *) str{
    int hash = 5381;
    int c;
    for(int i =0; i<str.length; i++){
        c = (int) [str characterAtIndex:i];
        hash = hash*33 + c;
    }
    hash = hash & 0x7FFFFFFF; //removes sign of negative numbers that result from exceeding
    hash = hash % self.tableSize;
    return hash;
}

-(int) sdbmHash: (NSString *)str ofLength: (int) i{
    int hash = 0;
    if(i<0){
        return 0;
    }
    hash = [self sdbmHash:str ofLength:i-1] * 6599 + (int) [str characterAtIndex:i];
    
    return hash;
}

-(int) polyRollHash: (NSString *) str{
    int hash = 0;
    for( int i = 0; i<str.length; i++){
        hash += ((int) [str characterAtIndex:i] ) * pow(31,i);
    }
    hash = hash & 0x7FFFFFFF;
    hash = hash % self.tableSize;
    return hash;
}

-(int) simpleHash: (NSString *) str{
    int hash = 0;
    for( int i = 0; i<str.length; i++){
        hash += (int) [str characterAtIndex:i];
    }
    hash = hash & 0x7FFFFFFF;
    hash = hash % self.tableSize;
    return hash;
}

-(int) rsHash: (NSString *) str{
    int a = 63689;
    int b = 378551;
    int hash = 0;
    for( int i = 0; i<str.length; i++){
        hash = hash * a + (int) [str characterAtIndex:i];
        a *= b;
    }
    hash = hash & 0x7FFFFFFF;
    hash = hash % self.tableSize;
    return hash;
}

-(int) resolveCollisionAt: (int) index withString:(NSString *) str{
    self.collisions++;
    int a = 1;
    WordNode* collidedNode = [self.concordance objectAtIndex:index];
    while(collidedNode.locations){
        if([collidedNode.word isEqualToString:str]){
            return index;
        }else{
            if(self.probingMethod ==0){
                index++;
            }else{
                index = index + (a * a) ;
            }
            index = index%self.tableSize; //wrapping around array
            collidedNode = [self.concordance objectAtIndex:index];
        }
    }
    return index; //return index of node without locations array (empty)
}

-(WordNode *) contains: (NSString *) str{
    int index;
    switch (self.hashFunction){
        case 1:
            index = [self djbHash:str];
            break;
        case 2:
            index = [self sdbmHash: str ofLength:(int) str.length-1];
            index = index & 0x7FFFFFFF;
            index = index % self.tableSize;
            break;
        case 3:
            index = [self polyRollHash:str ];
            break;
        case 4:
            index = [self simpleHash: str ];
            break;
        case 5:
            index = [self rsHash:str];
            break;
        default:
            index = [self djbHash:str];
            break;
    }
    
    int a = 1;
    WordNode *temp = [self.concordance objectAtIndex:index];
    while(temp.locations){
        if([temp.word isEqualToString:str]){
            return temp;
        }else{
            if(self.probingMethod ==0){
                index++;
            }else{
                index = index + (a * a) ;
            }
            temp = [self.concordance objectAtIndex:index];
        }
    }
    return nil;
}


@end
