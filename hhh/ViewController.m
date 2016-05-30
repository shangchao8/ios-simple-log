//
//  ViewController.m
//
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
static NSMutableString *fontIndex;
static NSMutableString *colorIndex;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    title=[[NSMutableArray alloc]init];
    time=[[NSMutableArray alloc]init];
    [self plistFind];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:105/255.0f green:204/255.0f blue:255/255.0f alpha:0.9];
    float height=self.view.bounds.size.height;
     float width=self.view.bounds.size.width;
    optionView=[[OptionView alloc] init];
    [self initNavigation];
    addView=[[AddView alloc] init];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"便签", @"");
    [label sizeToFit];
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [timer fire];
    [self tableViewInit];//初始化便签列表
    
    //初始化设置按钮
    UIButton *setButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width/15, width/15)];
    [setButton setImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *setItem=[[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:setButton ];
    //NSLog(@"%lf",width);
    
    //初始化添加按键
    addButton=[[UIButton alloc] initWithFrame:CGRectMake(width/2-width/10, height*0.85, width/5, width/5)];
    [addButton setImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
    addButton.alpha=0.3;
    [addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initNavigation{
    colorArray=[[NSMutableArray alloc] initWithObjects:@"red",@"blue",@"gray",@"black",@"yello",@"pink", nil];
    fontsizeArray  =[[NSMutableArray alloc]initWithObjects:@"20",@"23",@"25",@"28",@"30", nil];
    int colorindex=(int)[colorArray indexOfObject:colorIndex];
    switch (colorindex) {
        case 0:
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:252/255.0f green:111/255.0f blue:111/255.0f alpha:0.9];
            break;
        case 1:
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:105/255.0f green:204/255.0f blue:255/255.0f alpha:0.9];
            break;
        case 2:
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:0.9];
            break;
        case 3:
            
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:0.8];
            break;
        case 4:
            
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255/255.0f green:141/255.0f blue:20/255.0f alpha:0.9];
            break;
        case 5:
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:223/255.0f green:176/255.0f blue:237/255.0f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)plistFind{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePatch]) {
        data=[[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        title=[data objectForKey:@"title"];
        time=[data objectForKey:@"time"];
        colorIndex=[data objectForKey:@"color"];
        fontIndex=[data objectForKey:@"fontsize"];
        //NSLog(@"%@",title);
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self tableViewInit];
    [self plistFind];
    [self initNavigation];
    [self.view addSubview:addButton];
}
- (void)changeTime {
    
}
//初始化tableview
-(void)tableViewInit{
    thingList=[[UITableView alloc] initWithFrame:CGRectMake(DeviceWidth/20, DeviceHeight/9, 18*DeviceWidth/20, DeviceHeight)];
    thingList.delegate=self;
    thingList.separatorStyle=UITableViewCellSeparatorStyleNone;
    thingList.dataSource=self;
    thingList.rowHeight=UITableViewAutomaticDimension;
    thingList.estimatedRowHeight = 44;
    
    [self.view addSubview:thingList];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    
    //NSLog(@"%lu",(unsigned long)[[AddView passTitleStr] count]);
    return [title count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"is %@",indexPath);
    
    [AddView getIndex:(int)[indexPath row]];
    [AddView setIsEdit];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(-DeviceWidth, 0, DeviceWidth, DeviceHeight);
    }];
    [self.navigationController pushViewController:addView animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //如果重用池中没有这个标识符对应的cell，则创建一个新的，并且设置标识符
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    //对Cell做数据,图片设置
    int fontSize=[fontIndex intValue];
    cell.textLabel.font=[UIFont systemFontOfSize:fontSize];
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:10];
    cell.textLabel.numberOfLines=0;
    cell.imageView.image=[UIImage imageNamed:@"bianqian"];
    cell.imageView.frame=cell.textLabel.frame;
    cell.imageView.alpha=0.8;
    [cell.textLabel setText:[title objectAtIndex:[indexPath row]]];
    [cell.detailTextLabel setText:[time objectAtIndex:[indexPath row]]];
    return cell;
}

-(void)setClick:(id)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 2*DeviceHeight, DeviceWidth, DeviceHeight);
    }];
    [self.navigationController pushViewController:optionView animated:YES];
}
-(void)addClick:(id)sender{
    
    [AddView setIsAdd];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(-DeviceWidth, 0, DeviceWidth, DeviceHeight);
    }];
    [self.navigationController pushViewController:addView animated:YES];
  

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
