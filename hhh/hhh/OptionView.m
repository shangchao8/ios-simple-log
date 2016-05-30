//
//  OptionView.m
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import "OptionView.h"

@interface OptionView ()

@end
static NSMutableString *fontIndex;
static NSMutableString *colorIndex;
@implementation OptionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self plistInit];
    [self plistFind];
    optionArray=[[NSMutableArray alloc] initWithObjects:@"界面颜色设置",@"便签字体大小", nil];
    colorArray=[[NSMutableArray alloc] initWithObjects:@"红",@"蓝",@"灰",@"黑",@"橙",@"粉", nil];
    fontsizeArray  =[[NSMutableArray alloc]initWithObjects:@"15",@"20",@"25",@"30",@"40", nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnView)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveReturn)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"设置", @"");
        [label sizeToFit];
    [self optionTableViewInit];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self plistFind];
}
-(void)plistInit{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    // NSLog(@"%@",filePatch);
    if (![fm fileExistsAtPath:filePatch]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"date" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSLog(@"初次运行，在沙箱建立plist");
    }
    else{
        data=[[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        //NSLog(@"%@",timeArray);
        NSLog(@"不是初次运行，直接在沙箱找plist");
    }
}
-(void)plistFind{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePatch]) {
        data=[[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        colorIndex=[data objectForKey:@"color"];
        fontIndex=[data objectForKey:@"fontsize"];
        
    }
}
- ( BOOL )shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{    
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [optionArray count];//返回标题数组中元素的个数来确定分区的个数
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.alpha=0.6;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 30)];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:22];
    label.text = [optionArray objectAtIndex:section];
    [view addSubview:label];
    return view;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
            case 0:
            return  [colorArray count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        case 1:
            return  [fontsizeArray count];
            break;
            
        default:
            return 0;
            break;
            
    }  
    
}
-(void) optionTableViewInit{
    optionView=[[UITableView alloc] initWithFrame:self.view.frame];
    optionView.delegate=self;
    optionView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    optionView.dataSource=self;
    optionView.rowHeight=UITableViewAutomaticDimension;
    optionView.estimatedRowHeight = 44;
    
    [self.view addSubview:optionView];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"is %d",[indexPath row]);
    if(indexPath.section==0){
    switch ([indexPath row]) {
        case 0:
            colorIndex=[NSMutableString stringWithString:@"red"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:252/255.0f green:111/255.0f blue:111/255.0f alpha:0.9];
            break;
        case 1:
            colorIndex=[NSMutableString stringWithString:@"blue"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:105/255.0f green:204/255.0f blue:255/255.0f alpha:0.9];
            break;
        case 2:
            colorIndex=[NSMutableString stringWithString:@"gray"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:0.9];
            break;
        case 3:
            colorIndex=[NSMutableString stringWithString:@"black"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:0.8];
            break;
        case 4:
            colorIndex=[NSMutableString stringWithString:@"yello"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255/255.0f green:141/255.0f blue:20/255.0f alpha:0.9];
            break;
        case 5:
            colorIndex=[NSMutableString stringWithString:@"pink"];
            self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:223/255.0f green:176/255.0f blue:237/255.0f alpha:0.9];
            break;
        default:
            break;
        }
        
    }
    else if(indexPath.section==1){
        switch ([indexPath row]) {
            case 0:
                fontIndex=[NSMutableString stringWithString:@"15"];
                break;
            case 1:
                fontIndex=[NSMutableString stringWithString:@"20"];
                break;
            case 2:
                fontIndex=[NSMutableString stringWithString:@"25"];
                break;
            case 3:
                fontIndex=[NSMutableString stringWithString:@"30"];
                break;
            case 4:
                fontIndex=[NSMutableString stringWithString:@"40"];
                break;
            default:
                break;
        }
    }
   
}
    
    

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    //如果重用池中没有这个标识符对应的cell，则创建一个新的，并且设置标识符
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
             }
    cell.textLabel.font=[UIFont systemFontOfSize:20];
    //对Cell做数据设置
    switch (indexPath.section) {
        case 0:
            
            [[cell textLabel]  setText:[colorArray objectAtIndex:indexPath.row]];
            break;
        case 1:
            [[cell textLabel]  setText:[fontsizeArray objectAtIndex:indexPath.row]];
            break;  
            
        default:  
            [[cell textLabel]  setText:@"Unknown"];
            
    }  
    
    return cell;
    
}

-(void)saveReturn{
    [data setObject:colorIndex forKey:@"color"];
    [data setObject:fontIndex forKey:@"fontsize"];
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    [data writeToFile:filePatch atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnView
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
