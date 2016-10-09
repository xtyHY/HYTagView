//
//  ViewController.m
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "ViewController.h"
#import "HYTagView.h"

@interface ViewController (){
    
    HYTagView *_tagView;
}

@property (weak, nonatomic) IBOutlet UITextField *selTextField;
@property (weak, nonatomic) IBOutlet UITextField *deSelTextField;

@end

@implementation ViewController

- (IBAction)selectAll:(id)sender {
    
    [_tagView selectAllTag];
}

- (IBAction)deSelectAll:(id)sender {
    
    [_tagView deselectAllTag];
}

- (IBAction)getAllSelected:(id)sender {

    NSLog(@"%@",[_tagView getSelectedTags]);
}


- (IBAction)getAllUNSelected:(id)sender {
    
    NSLog(@"%@",[_tagView getUnselectedTags]);
}

- (IBAction)selectById:(id)sender {
    
    if ([_selTextField.text integerValue]>0) {
        [_tagView selectByTagId:[_selTextField.text integerValue]];
    }
}

- (IBAction)deSelectById:(id)sender {
    
    if ([_selTextField.text integerValue]>0) {
        [_tagView deselectByTagId:[_selTextField.text integerValue]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{@"tagId":@100, @"tagName":@"test1", @"isSelected":@YES},
                       @{@"tagId":@102, @"tagName":@"te2323", @"isSelected":@NO},
                       @{@"tagId":@103, @"tagName":@"t123123123123", @"isSelected":@NO},
                       @{@"tagId":@105, @"tagName":@"tesdfdsfds", @"isSelected":@NO},
                       @{@"tagId":@106, @"tagName":@"test1", @"isSelected":@NO},
                       @{@"tagId":@107, @"tagName":@"test213", @"isSelected":@NO},
                       @{@"tagId":@101, @"tagName":@"test12312314", @"isSelected":@NO}
                       ];
    
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        
        [marray addObject:[[HYTagModel alloc] initWithDict:dict]];
    }
    //---初始化方法1,默认style和默认可点击
//    _tagView = [[HYTagView alloc] initWithFrame:(CGRect){0,50,[UIScreen mainScreen].bounds.size.width, 0}
//                                      tagsArray:marray];
    
    //---初始化方法2,可配置style和是否可点击
    _tagView = [[HYTagView alloc] initWithFrame:(CGRect){10,50,[UIScreen mainScreen].bounds.size.width, 0}
                                      tagsArray:marray
                                       tagStyle:HYTagStyleBorder
                                      clickable:YES];
//    _tagView.backgroundColor = [UIColor orangeColor];
    
    //---在addSubview之前能够配置tag样式和一些模式
    _tagView.allowsSingleSelection = YES;//开启仅单选模式（仅单选模式无法反选）,默认NO
    _tagView.numberOfLines = 2;//最多显示2行，默认0，有多少显示多少
    
    //tag之间间距配置
    _tagView.tagMarginH = 15;   //2个tag在垂直方向间距，默认10
    _tagView.tagMarginW = 20;   //2个tag在水平方向间距，默认10
    
    //单个tag样式，配置
    _tagView.tagCornerRadius = 4; //tag的圆角，默认为高度的一半
    _tagView.tagHeight = 40;    //tag的高度，默认30
    _tagView.tagFontSize = 15;   //tag的字体大小，默认15
    _tagView.tagInnerMarginW = 4; //tag内文字距离 本tag左右边框的总距离,默认=tagHeight
    
    //未选中状态 tag颜色
    _tagView.tagTextColorNormal = [UIColor whiteColor]; //文字
    _tagView.tagBgColorNormal   = [UIColor blueColor];  //背景
    _tagView.tagBorderColorNormal = [UIColor greenColor];//边框（如果需要无边框效果，请设置颜色与背景一致或者透明）
    
    //已选中状态 tag颜色
    _tagView.tagTextColorHighlight = [UIColor redColor]; //文字
    _tagView.tagBgColorHighlight   = [UIColor greenColor];  //背景
    _tagView.tagBorderColorHighlight = [UIColor purpleColor];//边框（如果需要无边框效果，请设置颜色与背景一致或者透明）
    
    //配置结束将tag添加到界面上
    [self.view addSubview:_tagView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selTextfield:(id)sender {
}
@end
