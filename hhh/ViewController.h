//
//  ViewController.h
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionView.h"
#import "AddView.h"


#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UIButton *addButton;
    OptionView *optionView;
    AddView *addView;
    NSMutableArray *colorArray;
    NSMutableArray *fontsizeArray;
    UITableView *thingList;
    NSTimer *timer;
    NSMutableDictionary *data;
    NSMutableArray *title;
    NSMutableArray *time;
}


@end

