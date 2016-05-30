//
//  AddView.h
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDCalendarItem.h"
#import <sqlite3.h>
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height

//#define TITLE    @"title"
//#define TIME      @"time"
//#define THING       @"thing"
//#define DBNAME    @"info.sqlite"
//#define TABLENAME @"PERSONINFO"
@interface AddView : UIViewController<UITextFieldDelegate,UIScrollViewDelegate, UITextViewDelegate>{
    UITextField *textTitle;
    UITextView *textThing;
    NSString *titleStr;
    NSString *thingStr;
    UIButton *titleButton;
    UIDatePicker *datePicker;
    UIView *datePickerView;
    UIView *backgroundView;
    NSDate *currentdate;
    UIScrollView *scrollView;
    FDCalendarItem *centerCalendarItem;
    FDCalendarItem *leftCalendarItem;
    FDCalendarItem *rightCalendarItem;
    UIAlertView *alertView;
    NSMutableDictionary *data;
//    sqlite3 *db;
}
+(void)getIndex:(int)selectIndex;
+(void)setIsEdit;
+(void)setIsAdd;
@end
