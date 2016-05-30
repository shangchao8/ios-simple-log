//
//  OptionView.h
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
@interface OptionView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *optionView;
    NSMutableArray *optionArray;
    NSMutableArray *colorArray;
    NSMutableArray *fontsizeArray;
    NSMutableDictionary *data;
    UIView *view;
}

@end
