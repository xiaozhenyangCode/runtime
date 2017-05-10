//
//  MyObject.h
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObject : NSObject

@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, copy) NSString    *   status;
+ (void)load;
@end
