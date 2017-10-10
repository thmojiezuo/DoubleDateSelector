//
//  DateSeleCtor.m
//  DateSelector
//
//  Created by tenghu on 2017/10/10.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "DateSeleCtor.h"
#import <JHChainableAnimations.h>
#import "UIColor+Extension.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BACKCOLOR [UIColor clearColor]
#define THEMECOLOR [UIColor colorWithHexString:@"d6b04e" alpha:1]
#define WORDBRIGHT [UIColor colorWithHexString:@"bfbdbd" alpha:1]
#define BLACKCOLOR [UIColor colorWithHexString:@"000000" alpha:0.7]
#define LINECOLOR [UIColor colorWithHexString:@"666666" alpha:0.3]

@interface DateSeleCtor ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_year1;
    NSString *_year2;
    NSString *_month1;
    NSString *_month2;
    NSString *_day1;
    NSString *_day2;
    NSArray *_flagDay;
    //正常的
    NSString * nowyear;
    NSString * nowmonth;
    NSString * nowday;
}

//@property (nonatomic, strong) JHChainableAnimator *animator;

@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIView *blackView;
@property(nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, copy)NSString *seletedDateString;
@property (nonatomic, copy)NSString *seletedDateString2;

@property (strong, nonatomic) void(^determineBlock)(NSString *timeFirst,NSString *timeLast);

@property (strong, nonatomic) NSString *timeStr;
//正常的
@property (nonatomic ,strong)NSMutableArray *monthFit;
@property (nonatomic ,strong)NSMutableArray *yearFit;
@property (nonatomic ,strong)NSMutableArray *dayFit;
//今天判断的
@property (nonatomic ,strong)NSMutableArray *monthNow;
@property (nonatomic ,strong)NSMutableArray *yearNow;
@property (nonatomic ,strong)NSMutableArray *dayNow;


//变化的
@property (nonatomic ,strong)NSMutableArray *month;
@property (nonatomic ,strong)NSMutableArray *year;
@property (nonatomic ,strong)NSMutableArray *day;

@property (nonatomic ,strong)NSMutableArray *monthA;
@property (nonatomic ,strong)NSMutableArray *yearA;
@property (nonatomic ,strong)NSMutableArray *dayA;

@end

@implementation DateSeleCtor

- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.blackView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        [self addSubview:_blackView];
        
        self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
        self.datePickerView.backgroundColor = BLACKCOLOR;
        [self addSubview:_datePickerView];
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *DateTime = [formatter stringFromDate:date];
        NSArray *arr = [DateTime componentsSeparatedByString:@"-"];
        nowyear = arr[0];
        nowmonth = arr[1];
        nowday = arr[2];
        
        [self initData];
        
        
    }
    return self;
}

-  (void)initData{
    
    _flagDay = @[@"1月",@"3月",@"5月",@"7月",@"8月",@"10月",@"12月"];
    
    self.month=[[NSMutableArray alloc] init];
    self.monthA=[[NSMutableArray alloc] init];
    self.monthFit = [[NSMutableArray alloc] init];
    self.monthNow = [[NSMutableArray alloc] init];
    for (int i = 1; i < 13; i ++) {
        NSString *string = [NSString stringWithFormat:@"%d月",i];
        if ( i == [nowmonth intValue] ) {
            [self.monthNow addObject:@"今天"];
        }else{
            [self.monthNow addObject:string];
        }
        
        [self.monthFit addObject:string];
    }
    [self.month addObjectsFromArray:self.monthFit];
    [self.monthA addObjectsFromArray:self.monthFit];
    
    self.year=[[NSMutableArray alloc]init];
    self.yearA=[[NSMutableArray alloc]init];
    self.yearFit=[[NSMutableArray alloc]init];
    self.yearNow=[[NSMutableArray alloc]init];
    for(int i= 2000;i < 2050;i++){
        NSString *string =[NSString stringWithFormat:@"%d",i];
        if (i == [nowyear intValue]) {
            [self.yearNow addObject:@"  "];
        }else{
            [self.yearNow addObject:string];
        }
        [self.yearFit addObject:string];
    }
    
    [self.year addObjectsFromArray:self.yearFit];
    [self.yearA addObjectsFromArray:self.yearFit];
    
    self.day = [[NSMutableArray alloc] init];
    self.dayA = [[NSMutableArray alloc] init];
    self.dayFit = [[NSMutableArray alloc] init];
    self.dayNow = [[NSMutableArray alloc] init];
    for (int i = 1; i < 32; i ++) {
        NSString *string = [NSString stringWithFormat:@"%d日",i];
        if (i == [nowday intValue]) {
            [self.dayNow addObject:@"  "];
        }else{
            [self.dayNow addObject:string];
        }
        [self.dayFit addObject:string];
    }
    [self.day addObjectsFromArray:self.dayFit];
    [self.dayA addObjectsFromArray:self.dayFit];
    
    self.datePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 20, SCREEN_WIDTH, 240)];
    self.datePicker.delegate=self;
    self.datePicker.showsSelectionIndicator=YES;
    
    [_datePickerView addSubview:self.datePicker];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH/2, 20)];
    lab1.text = @"起始时间";
    lab1.textColor = WORDBRIGHT;
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:13];
    [_datePickerView addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,20, SCREEN_WIDTH/2, 20)];
    lab2.text = @"终止时间";
    lab2.textColor = WORDBRIGHT;
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:13];
    [_datePickerView addSubview:lab2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 40);
    [button addTarget:self action:@selector(determineBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.datePickerView addSubview:button];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 20, 1, 240)];
    line1.backgroundColor = LINECOLOR;
    [_datePickerView addSubview:line1];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    if (!CGRectContainsPoint(_datePickerView.frame, p)) {
        [self disappear];
    }
}
#pragma mark -确定
- (void)determineBtn {
    self.determineBlock(self.seletedDateString,self.seletedDateString2);
    [self disappear];
}


#pragma mark -代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 6;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(component==0 || component == 3){
        
        return [self.year count];
        
    }else if (component == 1 || component == 4){
        return self.month.count;
    }else{
        
        return self.day.count;
        
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if ((component == 0 || component == 1 || component == 2) && [self.year containsObject:@"  "]) {
        [self.year removeAllObjects];
        [self.year addObjectsFromArray:self.yearFit];
        [_datePicker reloadComponent:0];
        
        [self.month removeAllObjects];
        [self.month addObjectsFromArray:self.monthFit];
        [_datePicker reloadComponent:1];
        
        [self.day removeAllObjects];
        [self.day addObjectsFromArray:self.dayFit];
        [_datePicker reloadComponent:2];
        
        
    }
    
    if ((component == 3 || component == 4 || component == 5) && [self.yearA containsObject:@"  "]) {
        [self.yearA removeAllObjects];
        [self.yearA addObjectsFromArray:self.yearFit];
        [_datePicker reloadComponent:3];
        
        [self.monthA removeAllObjects];
        [self.monthA addObjectsFromArray:self.monthFit];
        [_datePicker reloadComponent:4];
        
        [self.dayA removeAllObjects];
        [self.dayA addObjectsFromArray:self.dayFit];
        [_datePicker reloadComponent:5];
        
        
    }
    
    
    
    if (component == 0) {
        int aa = [_year[row] intValue];
        if (aa > nowyear.integerValue) {
            NSInteger thisyear=[nowyear integerValue]-2000;
            [self.datePicker selectRow:thisyear inComponent:0 animated:YES];
            aa = [nowyear intValue];
            _year1 = nowyear;
        }else{
            /**************************/
            if ([_month1 isEqualToString:@"2月"]) {
                if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:28 inComponent:2 animated:YES];
                        _day1 = _day[28];
                    }
                }else{
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]||[_day1 isEqualToString:@"29日"]) {
                        [self.datePicker selectRow:27 inComponent:2 animated:YES];
                        _day1 = _day[27];
                    }
                }
                
            }else{
                if (![_flagDay containsObject:_month1]) {
                    if ([_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:29 inComponent:2 animated:YES];
                        _day1 = _day[29];
                    }
                }
            }
            _year1  = _year[row];
            /**************************/
        }
    }
    if (component == 1) {
        
        if ([_year1 intValue] == [nowyear intValue] && row >= [nowmonth intValue]) {
            
            NSInteger thismonth=[nowmonth integerValue];
            [self.datePicker selectRow:thismonth-1 inComponent:1 animated:YES];
            if (thismonth-1 == 1) { // 2月
                int aa = [_year1 intValue];
                if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:28 inComponent:2 animated:YES];
                        _day1 = _day[28];
                    }
                }else{
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]||[_day1 isEqualToString:@"29日"]) {
                        [self.datePicker selectRow:27 inComponent:2 animated:YES];
                        _day1 = _day[27];
                    }
                }
            }else{
                if (![_flagDay containsObject:_month[row]]) {
                    if ([_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:29 inComponent:2 animated:YES];
                        _day1 = _day[29];
                    }
                }
            }
            _month1 = _month[thismonth-1];
            
        }else{
            /**************************/
            if (row == 1) { // 2月
                int aa = [_year1 intValue];
                if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:28 inComponent:2 animated:YES];
                        _day1 = _day[28];
                    }
                }else{
                    if ([_day1 isEqualToString:@"30日"]||[_day1 isEqualToString:@"31日"]||[_day1 isEqualToString:@"29日"]) {
                        [self.datePicker selectRow:27 inComponent:2 animated:YES];
                        _day1 = _day[27];
                    }
                }
            }else{
                if (![_flagDay containsObject:_month[row]]) {
                    if ([_day1 isEqualToString:@"31日"]) {
                        [self.datePicker selectRow:29 inComponent:2 animated:YES];
                        _day1 = _day[29];
                    }
                }
            }
            _month1 = _month[row];
            /**************************/
        }
    }
    if (component == 2) {
        
        NSArray *arr = [_month1 componentsSeparatedByString:@"月"];
        if ([_year1 intValue] == [nowyear intValue] && [arr[0] intValue] == [nowmonth intValue] && row >= [nowday intValue]) {
            NSInteger thisday=[nowday integerValue];
            [self.datePicker selectRow:thisday-1 inComponent:2 animated:YES];
            _day1 = _day[thisday-1];
        }else{
            /**************************/
            if (![_month1 isEqualToString:@"2月"]) {
                
                if ([_flagDay containsObject:_month1]) {
                    _day1 = _day[row];
                }else{
                    if (row == 30) {
                        [self.datePicker selectRow:29 inComponent:2 animated:YES];
                        _day1 = _day[29];
                    }else{
                        _day1 = _day[row];
                    }
                }
            }else{
                int aa = [_year1 intValue];
                if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                    if (row > 28) {
                        [self.datePicker selectRow:28 inComponent:2 animated:YES];
                        _day1 = _day[28];
                    }else{
                        _day1 = _day[row];
                    }
                    
                }else{
                    if (row > 27) {
                        [self.datePicker selectRow:27 inComponent:2 animated:YES];
                        _day1 = _day[27];
                    }else{
                        _day1 = _day[row];
                    }
                }
            }
            /**************************/
        }
        
    }
    if (component == 3) {
        int aa = [_yearA[row] intValue];
        if ([_month2 isEqualToString:@"2月"]) {
            if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                if ([_day2 isEqualToString:@"30日"]||[_day2 isEqualToString:@"31日"]) {
                    [self.datePicker selectRow:28 inComponent:5 animated:YES];
                    _day2 = _dayA[28];
                }
            }else{
                if ([_day2 isEqualToString:@"30日"]||[_day2 isEqualToString:@"31日"]||[_day2 isEqualToString:@"29日"]) {
                    [self.datePicker selectRow:27 inComponent:5 animated:YES];
                    _day2 = _dayA[27];
                }
            }
            
        }else{
            if (![_flagDay containsObject:_month2]) {
                if ([_day2 isEqualToString:@"31日"]) {
                    [self.datePicker selectRow:29 inComponent:5 animated:YES];
                    _day2 = _dayA[29];
                }
            }
        }
        _year2 = _yearA[row];
    }
    if (component == 4) {
        
        if (row == 1) { // 2月
            int aa = [_year2 intValue];
            if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                if ([_day2 isEqualToString:@"30日"]||[_day2 isEqualToString:@"31日"]) {
                    [self.datePicker selectRow:28 inComponent:5 animated:YES];
                    _day2 = _dayA[28];
                }
            }else{
                if ([_day2 isEqualToString:@"30日"]||[_day2 isEqualToString:@"31日"]||[_day2 isEqualToString:@"29日"]) {
                    [self.datePicker selectRow:27 inComponent:5 animated:YES];
                    _day2 = _dayA[27];
                }
            }
        }else{
            if (![_flagDay containsObject:_monthA[row]]) {
                if ([_day2 isEqualToString:@"31日"]) {
                    [self.datePicker selectRow:29 inComponent:5 animated:YES];
                    _day2 = _dayA[29];
                }
            }
        }
        _month2 = _monthA[row];
    }
    if (component == 5) {
        if (![_month2 isEqualToString:@"2月"]) {
            
            if ([_flagDay containsObject:_month2]) {
                _day2 = _dayA[row];
            }else{
                if (row == 30) {
                    [self.datePicker selectRow:29 inComponent:5 animated:YES];
                    _day2 = _dayA[29];
                }else{
                    _day2 = _dayA[row];
                }
            }
        }else{
            int aa = [_year2 intValue];
            if ((aa % 100 == 0&& aa % 400 == 0)||(aa % 100!= 0 && aa % 4 == 0)) { //闰年29
                if (row > 28) {
                    [self.datePicker selectRow:28 inComponent:5 animated:YES];
                    _day2 = _dayA[28];
                }else{
                    _day2 = _dayA[row];
                }
                
            }else{
                if (row > 27) {
                    [self.datePicker selectRow:27 inComponent:5 animated:YES];
                    _day2 = _dayA[27];
                }else{
                    _day2 = _dayA[row];
                }
                
            }
            
        }
        
    }
    
    NSArray *arr1 = [_month1 componentsSeparatedByString:@"月"];
    NSString *str1 = arr1[0];
    if (str1.length == 1) {
        str1 = [NSString stringWithFormat:@"0%@",str1];
    }
    NSArray *arr2 = [_day1 componentsSeparatedByString:@"日"];
    NSString *str2 = arr2[0];
    if (str2.length == 1) {
        str2 = [NSString stringWithFormat:@"0%@",str2];
    }
    NSString *ystr1 = [_year1 substringFromIndex:2];
    self.seletedDateString = [NSString stringWithFormat:@"%@.%@.%@",ystr1,str1,str2];
    
    NSArray *arr4 = [_month2 componentsSeparatedByString:@"月"];
    NSString *str4 = arr4[0];
    if (str4.length == 1) {
        str4 = [NSString stringWithFormat:@"0%@",str4];
    }
    NSArray *arr3 = [_day2 componentsSeparatedByString:@"日"];
    NSString *str3 = arr3[0];
    if (str3.length == 1) {
        str3 = [NSString stringWithFormat:@"0%@",str3];
    }
    NSString *ystr2 = [_year2 substringFromIndex:2];
    self.seletedDateString2 = [NSString stringWithFormat:@"%@.%@.%@",ystr2,str4,str3];
    
    
    if ([arr1[0] intValue] == [nowmonth intValue] && [arr2[0] intValue] == [nowday intValue] && [_year1 isEqualToString:nowyear]) {
        
        [self.year removeAllObjects];
        [self.year addObjectsFromArray:self.yearNow];
        [_datePicker reloadComponent:0];
        
        [self.month removeAllObjects];
        [self.month addObjectsFromArray:self.monthNow];
        [_datePicker reloadComponent:1];
        
        [self.day removeAllObjects];
        [self.day addObjectsFromArray:self.dayNow];
        [_datePicker reloadComponent:2];
        
    }
    
    if ([arr4[0] intValue] == [nowmonth intValue] && [arr3[0] intValue] == [nowday intValue] && [_year2 isEqualToString:nowyear]) {
        
        [self.yearA removeAllObjects];
        [self.yearA addObjectsFromArray:self.yearNow];
        [_datePicker reloadComponent:3];
        
        [self.monthA removeAllObjects];
        [self.monthA addObjectsFromArray:self.monthNow];
        [_datePicker reloadComponent:4];
        
        [self.dayA removeAllObjects];
        [self.dayA addObjectsFromArray:self.dayNow];
        [_datePicker reloadComponent:5];
        
    }
    
    
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.year[row] attributes:attrDic];
            return attrString;
            break;
        }
        case 1:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.month[row] attributes:attrDic];
            return attrString;
            
            break;
        }
        case 2:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.day[row] attributes:attrDic];
            return attrString;
            
            break;
        }
        case 3:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.yearA[row] attributes:attrDic];
            return attrString;
            
            break;
        }
        case 4:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.monthA[row] attributes:attrDic];
            return attrString;
            
            break;
        }
        case 5:{
            
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.dayA[row] attributes:attrDic];
            return attrString;
            
            break;
        }
        default:{
            NSDictionary * attrDic = @{NSForegroundColorAttributeName:WORDBRIGHT, NSFontAttributeName:[UIFont systemFontOfSize:18]};
            NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:self.dayA[row] attributes:attrDic];
            return attrString;
            
            break;
        }
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    NSAttributedString * attrString = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    pickerLabel.attributedText = attrString;
    //    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//添加屏蔽罩 可以透过屏蔽罩对下面的view进行操作
-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}
- (void)disappear {
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:self.blackView];
    animator.makeOpacity(0.1).animate(0.3);
    JHChainableAnimator *animator2 = [[JHChainableAnimator alloc] initWithView:self.datePickerView];
    animator2.moveY(260).easeOutBack.animate(0.3);
    
    __weak typeof(self)weakSelf = self;
    animator2.animateWithCompletion(1.1,^{
        [weakSelf removeFromSuperview];
    });
    
    
}

#pragma mark 出现视图
- (void)show {
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:self.blackView];
    animator.transformIdentity.makeOpacity(0.6).animate(0.5);
    JHChainableAnimator *animator2 = [[JHChainableAnimator alloc] initWithView:self.datePickerView];
    animator2.moveY(-260).easeOutBack.animate(0.5);
    
    NSArray *timeArr = [_timeStr componentsSeparatedByString:@"-"];
    NSArray *one = [timeArr[0] componentsSeparatedByString:@"."];
    NSArray *two = [timeArr[1] componentsSeparatedByString:@"."];
    
    NSInteger thisyear=[one[0] integerValue]-2000;
    NSInteger thismonth=[one[1] integerValue];
    NSInteger thisday=[one[2] integerValue];
    
    [self.datePicker selectRow:thisyear inComponent:0 animated:YES];
    [self.datePicker selectRow:thismonth-1 inComponent:1 animated:YES];
    [self.datePicker selectRow:thisday-1 inComponent:2 animated:YES];
    
    NSString *ystr = [one[0] substringFromIndex:2];
    self.seletedDateString = [NSString stringWithFormat:@"%@.%@.%@",ystr,one[1],one[2]];
    
    NSInteger thatyear=[two[0] integerValue]-2000;
    NSInteger thatmonth=[two[1] integerValue];
    NSInteger thatday=[two[2] integerValue];
    
    [self.datePicker selectRow:thatyear inComponent:3 animated:YES];
    [self.datePicker selectRow:thatmonth-1 inComponent:4 animated:YES];
    [self.datePicker selectRow:thatday-1 inComponent:5 animated:YES];
    
    NSString *ystr2 = [two[0] substringFromIndex:2];
    self.seletedDateString2 = [NSString stringWithFormat:@"%@.%@.%@",ystr2,two[1],two[2]];
    
    
    _year1 = _year[thisyear];
    _year2 = _yearA[thatyear];
    
    _month1 = _month[thismonth -1];
    _month2 = _monthA[thatmonth -1];
    
    _day1 = _day[thisday -1];
    _day2 = _dayA[thatday -1];
    
    if ([one[1] intValue] == [nowmonth intValue] && [one[2] intValue] == [nowday intValue] && [one[0] isEqualToString:nowyear]) {
        
        [self.year removeAllObjects];
        [self.year addObjectsFromArray:self.yearNow];
        [_datePicker reloadComponent:0];
        
        [self.month removeAllObjects];
        [self.month addObjectsFromArray:self.monthNow];
        [_datePicker reloadComponent:1];
        
        [self.day removeAllObjects];
        [self.day addObjectsFromArray:self.dayNow];
        [_datePicker reloadComponent:2];
        
    }
    
    if ([two[1] intValue] == [nowmonth intValue] && [two[2] intValue] == [nowday intValue] && [two[0] isEqualToString:nowyear]) {
        
        [self.yearA removeAllObjects];
        [self.yearA addObjectsFromArray:self.yearNow];
        [_datePicker reloadComponent:3];
        
        [self.monthA removeAllObjects];
        [self.monthA addObjectsFromArray:self.monthNow];
        [_datePicker reloadComponent:4];
        
        [self.dayA removeAllObjects];
        [self.dayA addObjectsFromArray:self.dayNow];
        [_datePicker reloadComponent:5];
        
    }
    
}


+ (void)showDateSelectionWithTime:(NSString *)time WithComplete:(void(^)(NSString *timeFirst,NSString *timeLast))results{
    DateSeleCtor *dateView = [[self alloc] init];
    dateView.tag = 600;
    dateView.timeStr = time;
    dateView.determineBlock = results;
    [dateView show];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:dateView];
    
}


@end
