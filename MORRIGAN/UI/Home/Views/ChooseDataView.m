//
//  ChooseDataView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/16.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "ChooseDataView.h"

@interface ChooseDataView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic , strong) UIPickerView *pickerView;

@property (nonatomic , strong) UIDatePicker *datePicker;

@property (nonatomic , strong) UIView *bar;

@property (nonatomic , strong) UIButton *cancelButton;

@property (nonatomic , strong) UIButton *sureButton;

@property (nonatomic , strong) NSArray *ageArray;

@property (nonatomic , strong) NSMutableArray *heightArray;

@property (nonatomic , strong) NSMutableArray *weightArray;

@property (nonatomic , strong) NSArray *feelingArray;

@property (nonatomic , strong) NSString *heightStr;

@property (nonatomic , strong) NSString *weightStr;

@property (nonatomic , strong) NSString *feelingStr;

@property (nonatomic , strong) NSString *ageStr;

@property (nonatomic , strong) NSDateFormatter *formatter;

@end

@implementation ChooseDataView

-(NSDateFormatter *)formatter
{
    if (_formatter==nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _pickerType = pickerViewTypeAge;
        
        [self setUpPickerView];
    }
    return self;
}

- (instancetype)initWithType:(pickerViewType)type withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerType = type;
        if (_pickerType == pickerViewTypeAge) {
            
        }else{
            [self initData];
            
        }
        [self setUpPickerView];
    }
    return self;
}

- (void)setPickerType:(pickerViewType)pickerType
{
    _pickerType = pickerType;
    [self setUpPickerView];
    
    if (_pickerType == pickerViewTypeAge) {
       
        
    }else{
    [self initData];
    [_pickerView reloadAllComponents];
    }
    
    
}

- (void)setCurrentAge:(NSString *)age
{
    
}

- (void)initData
{
    _heightStr = [UserInfo share].high;
    _weightStr = [UserInfo share].weight;
    _ageStr = [UserInfo share].age;
    _feelingStr = [UserInfo share].emotion;
    
    switch (_pickerType) {
        case pickerViewTypeHeight:
        {
            _heightArray = [NSMutableArray array];
            for (NSInteger i = 50; i < 300; i++) {
                NSString *count = [NSString stringWithFormat:@"%ld",i];
                [_heightArray addObject:count];
            }
        }
            break;
        case pickerViewTypeWeight:
        {
            _weightArray = [NSMutableArray array];
            for (NSInteger i = 1; i < 200; i++) {
                NSString *count = [NSString stringWithFormat:@"%ld",i];
                [_weightArray addObject:count];
            }
        }
            break;
        case pickerViewTypeFeeling:
        {
            _feelingArray = @[@"恋爱",@"已婚",@"未婚"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setUpPickerView
{
    _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self addSubview:_bar];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 5, 50, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_bar addSubview:sureBtn];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    [_bar addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth - 0.5, kScreenWidth, 0.5)];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    [_bar addSubview:bottomLineView];
    
    CGFloat pickerY = CGRectGetMaxY(_bar.frame);
    CGFloat pickerH = self.height - 50;
    if (_pickerType == pickerViewTypeAge) {
        if (!_datePicker) {
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerY, kScreenWidth, pickerH)];
            _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            [_datePicker addTarget:self action:@selector(seletcedDate:) forControlEvents:UIControlEventValueChanged];
            
            _datePicker.backgroundColor = [UIColor whiteColor];
            [self addSubview:_datePicker];
        }
        
    }else{
        if (!_pickerView) {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pickerY, kScreenWidth, pickerH)];
            _pickerView.delegate = self;
            _pickerView.dataSource = self;
            _pickerView.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:_pickerView];
        }
    }
    
    
}

- (void)seletcedDate:(UIDatePicker *)datePicker
{
    _ageStr = [self.formatter stringFromDate:datePicker.date];
    
}

- (void)cancelSelect
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectData)]) {
        [self.delegate cancelSelectData];
    }
}

- (void)sureSelect
{
    NSString *selectData = @"";
    switch (_pickerType) {
        case pickerViewTypeHeight:
        {
            selectData = _heightStr;
        }
            break;
        case pickerViewTypeWeight:
        {
            selectData = _weightStr;
        }
            break;
        case pickerViewTypeFeeling:
        {
            selectData = _feelingStr;
        }
            break;
        case pickerViewTypeAge:
        {
            selectData = _ageStr;
        }
            break;
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureToSelectData:)]) {
        [self.delegate sureToSelectData:selectData];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerViewTypeHeight:
        {
            return _heightArray.count;
        }
            break;
        case pickerViewTypeWeight:
        {
            return _weightArray.count;
        }
            break;
        case pickerViewTypeFeeling:
        {
            return _feelingArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerViewTypeHeight:
        {
            return _heightArray[row];
        }
            break;
        case pickerViewTypeWeight:
        {
            return _weightArray[row];
        }
            break;
        case pickerViewTypeFeeling:
        {
            return _feelingArray[row];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerViewTypeHeight:
        {
            _heightStr = _heightArray[row];
        }
            break;
        case pickerViewTypeWeight:
        {
            _weightStr = _weightArray[row];
        }
            break;
        case pickerViewTypeFeeling:
        {
            _feelingStr = _feelingArray[row];
        }
            break;
            
        default:
            break;
    }
}


@end
