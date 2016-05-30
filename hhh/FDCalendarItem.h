//
//  FDCalendarItem.h
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.

//

#import <UIKit/UIKit.h>

#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@protocol FDCalendarItemDelegate;

@interface FDCalendarItem : UIView

@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) id<FDCalendarItemDelegate> delegate;

- (NSDate *)nextMonthDate;
- (NSDate *)previousMonthDate;

@end

@protocol FDCalendarItemDelegate <NSObject>

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date;

@end
