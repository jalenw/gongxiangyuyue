//
//  NSError+Helper.h
//  Ekeo2
//
//  Created by Roger on 13-8-29.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Helper)
- (NSString*)localizedRecoverySuggestionInfo;
- (NSDictionary*)localizedRecoverySuggestionInfoData;
@end
