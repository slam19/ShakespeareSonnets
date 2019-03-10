//
//  WordNode.h
//  ShakespeareanLanguage
//
//  Created by Simon Lam on 3/9/19.
//  Copyright © 2019 Simon Lam. All rights reserved.
//

#ifndef WordNode_h
#define WordNode_h
#import "Location.h"
@interface WordNode<ObjectType>: NSObject

@property NSString *word;
@property NSMutableArray * locations;

-(id)initWithWord:(NSString *)w AtPosition: (int)p onLine: (int) l ofSonnet:(int)s;
-(id) initEmptyWord;


@end

#endif /* WordNode_h */
