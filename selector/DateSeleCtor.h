//
//  DateSeleCtor.h
//  DateSelector
//
//  Created by tenghu on 2017/10/10.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSeleCtor : UIView

+ (void)showDateSelectionWithTime:(NSString *)time WithComplete:(void(^)(NSString *timeFirst,NSString *timeLast))results;

@end
