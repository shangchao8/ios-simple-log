//
//  AddView.m
//  hhh
//
//  Created by OurEDA on 16/4/29.
//  Copyright (c) 2016年 Chaos. All rights reserved.
//

#import "AddView.h"
#import <QuartzCore/QuartzCore.h>
#import "FDCalendarItem.h"

static NSMutableArray *titleArray;
static NSMutableArray *thingArray;
static NSDateFormatter *dateFormattor;
static NSMutableArray *timeArray;
static int index1;
static BOOL isAdd;
@interface AddView () <UIScrollViewDelegate>

@end

@implementation AddView

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
//    
//    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库打开失败");
//    }
//    
//    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, time NCHAR, thing TEXT)";
//    [self execSql:sqlCreateTable];
//    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
//    sqlite3_stmt * statement;
//    
//    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *name = (char*)sqlite3_column_text(statement, 1);
//            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
//            
//            int age = sqlite3_column_int(statement, 2);
//            
//            char *address = (char*)sqlite3_column_text(statement, 3);
//            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
//            
//            NSLog(@"title:%@  time:%d  thing:%@",nsNameStr,age, nsAddressStr);
//        }
//    }
//    sqlite3_close(db);
    
   
    titleArray=[[NSMutableArray alloc] init];
    thingArray =[[NSMutableArray alloc] init];
    timeArray =[[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnView)];
    if (isAdd) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(saveReturn)];
    //self.navigationItem.title=@"添加新便签";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"添加新便签", @"");
    [label sizeToFit];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveEdit)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"编辑便签", @"");
        [label sizeToFit];
    }
    NSDate *cudate=[NSDate date];
    currentdate=cudate;//获取当前时间
    [self dateInit];
    [self textFiledInit];
    [self setCurrentDate:currentdate];
    [self scrollViewInit];
    [self plistInit];
    alertView=[[UIAlertView alloc] initWithTitle:@"标题不能为空" message:@"请输入标题" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    
   // NSLog(@"%@",cudate);
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (isAdd) {
        [self viewDidLoad];
    }
    else{
        [self plistInit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveEdit)];
        //self.navigationItem.title=@"添加新便签";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"编辑便签", @"");
        [label sizeToFit];
        NSLog(@"%d",index1);
        textTitle.text=titleArray[index1];
        textThing.text=thingArray[index1];
        [titleButton setTitle:timeArray[index1] forState:UIControlStateNormal];

    }

}
//-(void)execSql:(NSString *)sql
//{
//    char *err;
//    if (sqlite3_exec(db, [sql UTF8String] , NULL, NULL, &err) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库操作数据失败!");
//    }
//}
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
        
        titleArray=[data objectForKey:@"title"];
        thingArray=[data objectForKey:@"thing"];
        timeArray =[data objectForKey:@"time"];
        //NSLog(@"%@",timeArray);
        NSLog(@"不是初次运行，直接在沙箱找plist");
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textThing resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textTitle resignFirstResponder];
    titleStr=textTitle.text;
    return YES;
}
-(void)textFiledInit{
    textTitle=[[UITextField alloc] initWithFrame:CGRectMake(DeviceWidth/20, DeviceHeight/8, 18*DeviceWidth/20, DeviceHeight/15)];
    [textTitle setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    textTitle.placeholder = @"标题(必填)"; //默认显示的字
    textTitle.autocorrectionType = UITextAutocorrectionTypeNo;
    textTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textTitle.returnKeyType = UIReturnKeyDone;
    textTitle.delegate=self;
    textTitle.font=[UIFont boldSystemFontOfSize:20];
    textTitle.keyboardType=UIKeyboardAppearanceDefault;
    textTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textTitle];

    UILabel *zhengwen=[[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/20, DeviceHeight/3.5, DeviceWidth/2, DeviceHeight/20)];
    zhengwen.font=[UIFont boldSystemFontOfSize:15];
    zhengwen.text=@"正文内容:";
    zhengwen.alpha=0.5;
    [self.view addSubview:zhengwen];
    textThing=[[UITextView alloc] initWithFrame:CGRectMake(DeviceWidth/20, DeviceHeight/3, 18*DeviceWidth/20, DeviceHeight/1.6)];
    textThing.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    textThing.autocorrectionType=UITextAutocorrectionTypeNo;
    textThing.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textThing.returnKeyType = UIReturnKeyDone;
    textThing.delegate=self;
    textThing.font=[UIFont systemFontOfSize:20];
    textThing.alpha=0.5;
    textThing.keyboardType=UIKeyboardTypeDefault;
    textThing.layer.borderColor=[UIColor grayColor].CGColor;
    textThing.layer.borderWidth=1.0;
    textThing.layer.cornerRadius=5.0f;
    [self.view addSubview:textThing];

}
-(void)scrollViewInit{
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.canCancelContentTouches  =NO;
    
    [scrollView setFrame:CGRectMake(0, 75, DeviceWidth, centerCalendarItem.frame.size.height)];
    scrollView.contentSize = CGSizeMake(3* scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    [self.view addSubview:scrollView];
}
- (void)setupCalendarItems {
    scrollView = [[UIScrollView alloc] init];
    
    leftCalendarItem = [[FDCalendarItem alloc] init];
    [scrollView addSubview:leftCalendarItem];
    
    CGRect itemFrame = leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    centerCalendarItem = [[FDCalendarItem alloc] init];
    centerCalendarItem.frame = itemFrame;
   
    [scrollView addSubview:centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    rightCalendarItem = [[FDCalendarItem alloc] init];
    rightCalendarItem.frame = itemFrame;
    [scrollView addSubview:rightCalendarItem];
}
-(void)dateInit{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(DeviceWidth/30, DeviceHeight/4.6, 28*DeviceWidth/30, DeviceHeight/15)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 32, 24)];
    
    [leftButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 37, 10, 32, 24)];
    [rightButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, titleView.frame.size.width/2, titleView.frame.size.height*0.9)];
    //titleButton.backgroundColor=[UIColor redColor];
    [titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleButton.center = titleView.center;
    [titleButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];
    
}

-(UIView *)datePickerView{
    if (!datePickerView) {
        datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceHeight/4.6, DeviceWidth, 0)];
        datePickerView.backgroundColor = [UIColor whiteColor];
        datePickerView.clipsToBounds = YES;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 32, 20)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:105/255.0f green:204/255.0f blue:255/255.0f alpha:0.9] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(DeviceWidth - 52, 10, 32, 20)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor colorWithRed:105/255.0f green:204/255.0f blue:255/255.0f alpha:0.9] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(selectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView addSubview:okButton];
        
        [datePickerView addSubview:self.datePicker];
    }
    
    [self.view addSubview:datePickerView];
    
    return datePickerView;

}
- (UIDatePicker *)datePicker {
    if (!datePicker) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date=currentdate;
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        CGRect frame = datePicker.frame;
        frame.origin = CGPointMake(0, 32);
        datePicker.frame = frame;
        
    }
    return datePicker;
}
- (NSString *)stringFromDate:(NSDate *)date1 {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormattor stringFromDate:date1];
}
- (void)setCurrentDate:(NSDate *)date1 {
    centerCalendarItem.date = date1;
    currentdate=date1;
    //NSLog(@"%@",date1);
    leftCalendarItem.date = [centerCalendarItem previousMonthDate];
    rightCalendarItem.date = [centerCalendarItem nextMonthDate];
    [titleButton setTitle:[self stringFromDate:date1] forState:UIControlStateNormal];
    
}
- (UIView *)backgroundView {
    if (!backgroundView) {
        backgroundView = [[UIView alloc] initWithFrame: self.view.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerView)];
        [backgroundView addGestureRecognizer:tapGesture];
    }
    
    [self.view addSubview:backgroundView];
    
    return backgroundView;
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.datePickerView.frame = CGRectMake(0, DeviceHeight/4.6, DeviceWidth, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}
-(void)showDatePicker{
    NSLog(@"showDatepicker");
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.4;
        self.datePickerView.frame = CGRectMake(0, DeviceHeight/4.6+(titleButton.bounds.size.height), DeviceWidth, 1.5*DeviceHeight/4);
    }];

}
// 跳到上一个月
- (void)setPreviousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    currentdate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentdate options:NSCalendarMatchStrictly];
    
    [self setCurrentDate:currentdate];}

// 跳到下一个月
- (void)setNextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    currentdate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentdate options:NSCalendarMatchStrictly];
    
    [self setCurrentDate:currentdate];
    
}

- (void)returnView
{
    textTitle.text=NULL;
    textThing.text=NULL;
    NSDate *cudate=[NSDate date];
    [self setCurrentDate:cudate];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)selectCurrentDate{
    NSLog(@"selectCurrentDate");
    [self setCurrentDate:self.datePicker.date];
    [self hideDatePickerView];
}
-(void)cancelSelectCurrentDate{
    NSLog(@"cancelselectCurrentDate");
    [self hideDatePickerView];
}
- (void)saveEdit{
    if (![textTitle.text isEqualToString:@""]){
    titleArray[index1]=textTitle.text;
    thingArray[index1]=textThing.text;
    timeArray[index1]=titleButton.titleLabel.text;
    [data setObject:titleArray forKey:@"title"];
    [data setObject:thingArray forKey:@"thing"];
    [data setObject:timeArray forKey:@"time"];
        NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
        // NSLog(@"%@",filePatch);
        //输入写入
        [data writeToFile:filePatch atomically:YES];
        textTitle.text=NULL;
        textThing.text=NULL;
        [titleButton setTitle:@"" forState:UIControlStateNormal];
        NSDate *cudate=[NSDate date];
        [self setCurrentDate:cudate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [alertView show];
        // NSLog(@"no!");
    }
}
//保存事件
- (void)saveReturn
{
    if (![textTitle.text isEqualToString:@""]) {
    [titleArray addObject:textTitle.text];
    [thingArray addObject:textThing.text];
    [timeArray addObject:[self stringFromDate:currentdate]];
        //NSLog(@"%@",timeArray);
    [data setObject:titleArray forKey:@"title"];
    [data setObject:thingArray forKey:@"thing"];
    [data setObject:timeArray forKey:@"time"];
    //获取应用程序沙盒的Documents目录
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
       // NSLog(@"%@",filePatch);
    //输入写入
    [data writeToFile:filePatch atomically:YES];
//    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        //NSLog(@"---plist一开始保存时候的内容---%@",dataDictionary);
//    NSString *sql3 = [NSString stringWithFormat:
//                          @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//                          TABLENAME, TITLE,TIME,THING, textTitle.text, date, textThing.text];
//    [self execSql:sql3];
    //清空文本框及还原时间
    textTitle.text=NULL;
    textThing.text=NULL;
    [titleButton setTitle:@"" forState:UIControlStateNormal];
    NSDate *cudate=[NSDate date];
    [self setCurrentDate:cudate];
    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [alertView show];
       // NSLog(@"no!");
    }
}
+(void)getIndex:(int)selectIndex{
    index1=selectIndex;
}
+(void)setIsEdit{
    isAdd=false;
}
+(void)setIsAdd{
    isAdd=true;
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
