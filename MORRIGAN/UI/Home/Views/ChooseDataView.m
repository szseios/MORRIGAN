//
//  ChooseDataView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/16.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "ChooseDataView.h"
#import "KMDatePickerDateModel.h"
#import "NSDate+CalculateDay.h"
#import "DateHelper.h"

@interface ChooseDataView ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
}

@property (nonatomic , strong) UIPickerView *pickerView;

@property (nonatomic , strong) UIView *bar;

@property (nonatomic , strong) UIButton *cancelButton;

@property (nonatomic , strong) UIButton *sureButton;

@property (nonatomic , strong) NSArray *ageArray;

@property (nonatomic , strong) NSMutableArray *heightArray;

@property (nonatomic , strong) NSMutableArray *yearArray;

@property (nonatomic , strong) NSMutableArray *monthArray;

@property (nonatomic , strong) NSMutableArray *dayArray;

@property (nonatomic , strong) NSMutableArray *weightArray;

@property (nonatomic , strong) NSArray *feelingArray;

@property (nonatomic , strong) NSString *heightStr;

@property (nonatomic , strong) NSString *weightStr;

@property (nonatomic , strong) NSString *feelingStr;

@property (nonatomic , strong) NSString *ageStr;

@property (nonatomic , strong) NSDateFormatter *formatter;

@property (nonatomic , strong) NSDateComponents *comps;

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
        [self setUpPickerView];
        [self initData];
        
    }
    return self;
}

- (void)setPickerType:(pickerViewType)pickerType
{
    _pickerType = pickerType;
    [self setUpPickerView];
    [self initData];
    
    [_pickerView reloadAllComponents];
    
    
    
}

- (void)initData
{
    _heightStr = [UserInfo share].high;
    _weightStr = [UserInfo share].weight;
    switch (_pickerType) {
        case pickerViewTypeAge:
        {
            [self getDateComponents];
            [_pickerView selectRow:_yearArray.count - 19 inComponent:0 animated:NO];
            [_pickerView selectRow:11 inComponent:1 animated:NO];
            [_pickerView selectRow:21 inComponent:2 animated:NO];
            
            NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                                 _yearArray[_yearArray.count - 19],
                                 _monthArray[11],
                                 _dayArray[21]
                                 ];
            _ageStr = dateStr;
        }
            break;
        case pickerViewTypeHeight:
        {
            _heightArray = [NSMutableArray array];
            for (NSInteger i = 100; i < 300; i++) {
                NSString *count = [NSString stringWithFormat:@"%ld",i];
                [_heightArray addObject:count];
            }
            if ([UserInfo share].high.length > 0) {
                NSInteger higtCount = [UserInfo share].high.integerValue;
                if (higtCount < _heightArray.count) {
                    [_pickerView selectRow:higtCount - 100 inComponent:0 animated:NO];
                }
            }else{
                _heightStr = @"168";
                [_pickerView selectRow:68 inComponent:0 animated:NO];
                
            }
        }
            break;
        case pickerViewTypeWeight:
        {
            _weightArray = [NSMutableArray array];
            for (NSInteger i = 20; i < 200; i++) {
                NSString *count = [NSString stringWithFormat:@"%ld",i];
                [_weightArray addObject:count];
            }
        }
            if ([UserInfo share].weight.length > 0) {
                NSInteger weightCount = [UserInfo share].weight.integerValue;
                if (weightCount < _weightArray.count) {
                    [_pickerView selectRow:weightCount-20 inComponent:0 animated:NO];
                }
            }else{
                _weightStr = @"48";
                [_pickerView selectRow:28 inComponent:0 animated:NO];
            }
            break;
        case pickerViewTypeFeeling:
        {
            _feelingArray = @[@"恋爱",@"已婚",@"未婚"];
            NSString *tem = [UserInfo share].emotion;
            if ([[UserInfo share].emotion isEqualToString:@"B"]) {
                _feelingStr = _feelingArray[0];
            }else if ([[UserInfo share].emotion isEqualToString:@"M"])
            {
                _feelingStr = _feelingArray[1];
                [_pickerView selectRow:1 inComponent:0 animated:NO];
            }else if ([[UserInfo share].emotion isEqualToString:@"S"])
            {
                _feelingStr = _feelingArray[2];
                [_pickerView selectRow:2 inComponent:0 animated:NO];
            }else{
                _feelingStr = _feelingArray[2];
                [_pickerView selectRow:2 inComponent:0 animated:NO];
                
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)getDateComponents
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[NSDate date]];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    // 初始化存储时间数据源的数组
    // 年
    _yearArray = [NSMutableArray new];
    for (NSInteger i = 0; i <= comps.year - 1916; i++) {
        NSString *tempStr = [NSString stringWithFormat:@"%ld",(1916+i)];
        [_yearArray addObject:tempStr];
    }
    _yearIndex = comps.year - 1916 - 19;
    _comps = comps;
    [self getCurrentDay];
}

- (void)getCurrentDay
{
    // 月
    _monthArray = [NSMutableArray array];
    if (_yearIndex < _comps.year - 1916) {
        for (NSInteger i=1; i<=12; i++) {
            [_monthArray addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        [self reloadDayArray];
    }
    else{
        for (NSInteger i=1; i<=_comps.month; i++) {
            [_monthArray addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        if (_monthIndex == _comps.month-1) {
            _dayArray = [NSMutableArray new];
            for (NSInteger j = 1; j <= _comps.day; j++) {
                [_dayArray addObject:[NSString stringWithFormat:@"%02ld", (long)j]];
            }
            
        }else{
            [self reloadDayArray];
        }
        
    }
    if (_monthIndex == 0 || !_monthIndex || _monthIndex > 11 ) {
        _monthIndex = 11;
    }
    if (_dayIndex == 0 || !_dayIndex || _dayIndex > 30) {
        _dayIndex = 21;
    }
    
    
    if (_dayIndex >= _dayArray.count) {
        _dayIndex = _dayArray.count - 1;
    }
    if (_monthIndex >= _monthArray.count) {
        _monthIndex = _monthArray.count - 1;
    }

}

- (NSUInteger)daysOfMonth {
    if (_yearIndex == _comps.year - 1916 && _monthIndex == _comps.month) {
        return _comps.day;
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01 00:00", _yearArray[_yearIndex], _monthArray[_monthIndex]];
    return [[DateHelper dateFromString:dateStr withFormat:@"yyyy-MM-dd HH:mm"] daysOfMonth];
}

- (void)reloadDayArray {
    _dayArray = [NSMutableArray new];
    for (NSUInteger i=1, len=[self daysOfMonth]; i<=len; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
}

- (void)setUpPickerView
{
    _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    [self addSubview:_bar];
    _bar.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 55)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 50, 55)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureBtn setTitleColor:[Utils stringTOColor:@"#8c39e5"] forState:UIControlStateNormal];
    [_bar addSubview:sureBtn];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topLineView.backgroundColor = [UIColor colorWithRed:00 green:00 blue:00 alpha:0.26];
    [_bar addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _bar.height - 1, kScreenWidth, 1)];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.26];
    [_bar addSubview:bottomLineView];
    
    CGFloat pickerY = CGRectGetMaxY(_bar.frame);
    CGFloat pickerH = self.height - 55;
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pickerY, kScreenWidth, pickerH)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    
    
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_pickerType == pickerViewTypeAge) {
        return 3;
    }else{
        return 1;
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (_pickerType) {
            
        case pickerViewTypeAge:
        {
            NSInteger numberOfRows = 0;
            switch (component) {
                case 0:
                    numberOfRows = _yearArray.count;
                    break;
                case 1:
                    numberOfRows = _monthArray.count;
                    break;
                case 2:
                    numberOfRows = _dayArray.count;
                    break;
            }
            return numberOfRows;

        }
            break;
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
            return 3;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_pickerType == pickerViewTypeAge) {
        CGFloat width = 50.0;
        CGFloat widthOfAverage;
        widthOfAverage = (kScreenWidth -30) / 3;
        switch (component) {
            case 0:
                width = widthOfAverage;
                break;
            case 1:
                width = widthOfAverage;
                break;
            case 2:
                width = widthOfAverage;
                break;
            default:
                break;
        }
        
        return width;
    }else{
        return kScreenWidth;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (_pickerType) {
//        case pickerViewTypeHeight:
//        {
//            return _heightArray[row];
//        }
//            break;
//        case pickerViewTypeWeight:
//        {
//            return _weightArray[row];
//        }
//            break;
//        case pickerViewTypeFeeling:
//        {
//            return _feelingArray[row];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return nil;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lblCustom = (UILabel *)view;
    if (!lblCustom) {
        lblCustom = [UILabel new];
        lblCustom.textAlignment = NSTextAlignmentCenter;
        lblCustom.font = [UIFont systemFontOfSize:18.0];
    }
    NSString *text;
    switch (_pickerType) {
        case pickerViewTypeAge:
        {
            switch (component) {
                case 0:
                    text = _yearArray[row];
                    break;
                case 1:
                    text = _monthArray[row];
                    break;
                case 2:
                    text = _dayArray[row];
                    break;
            }
        }
            break;
        case pickerViewTypeHeight:
        {
            text = _heightArray[row];
        }
            break;
        case pickerViewTypeWeight:
        {
            text = _weightArray[row];
        }
            break;
        case pickerViewTypeFeeling:
        {
            text = _feelingArray[row];
        }
            break;
            
        default:
            break;
    }
    lblCustom.text = text;
    return lblCustom;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerViewTypeAge:
        {
            switch (component) {
                case 0:
                    _yearIndex = row;
                    [self getCurrentDay];
                    break;
                case 1:
                    _monthIndex = row;
                    [self getCurrentDay];
                    break;
                case 2:
                    _dayIndex = row;
                    break;
            }
            if (component == 0 || component == 1) {
                if (_monthArray.count-1 < _monthIndex) {
                    _monthIndex = _monthArray.count-1;
                }
                if (_dayArray.count-1 < _dayIndex) {
                    _dayIndex = _dayArray.count-1;
                }
            }
            NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                                 _yearArray[_yearIndex],
                                 _monthArray[_monthIndex],
                                 _dayArray[_dayIndex]
                                 ];
            _ageStr = dateStr;
            [pickerView reloadAllComponents];
        }
            break;
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

- (void)addUnitLabel:(NSString *)text withPointX:(CGFloat)pointX {
    CGFloat pointY = _pickerView.frame.size.height/2 - 10.0 + 50;
    UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, 20.0, 20.0)];
    lblUnit.text = text;
    lblUnit.textAlignment = NSTextAlignmentCenter;
    lblUnit.textColor = [UIColor blackColor];
    lblUnit.backgroundColor = [UIColor clearColor];
    lblUnit.font = [UIFont systemFontOfSize:18.0];
    lblUnit.layer.shadowColor = [[UIColor whiteColor] CGColor];
    lblUnit.layer.shadowOpacity = 0.5;
    lblUnit.layer.shadowRadius = 5.0;
    [self addSubview:lblUnit];
}


@end
