
//
//  Concordance.h
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 2/28/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#ifndef Concordance_h
#define Concordance_h
#import "WordNode.h"
@interface Concordance<ObjectType>: NSObject

@property NSMutableArray *concordance;
@property NSMutableArray *sonnetWords;
@property int tableSize;
@property int collisions;
@property int uniqueWordCount;
@property int hashFunction;
@property int probingMethod;

-(void) loadSonnets;
-(int) djbHash: (NSString *) str;
-(int) polyRollHash: (NSString *) str;
-(void) fillConcordance;
-(int) resolveCollisionAt: (int) index withString:(NSString *) str;
-(WordNode *) contains: (NSString *) str;
-(int) sdbmHash: (NSString *)str ofLength: (int) i;

@end
#endif /* Concordance_h */
