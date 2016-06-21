//
//  HYTagView.m
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "HYTagView.h"

#define HexColor(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a ]

static NSInteger const kTagBtnBaseTag  = 1000;
static NSInteger const kTagBtnFontSize = 14;

//static NSInteger const kTagBtn

//============= HYTagModel =============
@implementation HYTagModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        
        _tagId      = [dict[@"tagId"] integerValue];
        _tagName    = dict[@"tagName"];
        _isSelected = [dict[@"isSelected"] boolValue];
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"tagId:%li tagName:%@ isSelected:%i",_tagId, _tagName, _isSelected];
}

@end

//============= HYTagView =============
@interface HYTagView(){
    
    NSArray     *_tagsArray;
    HYTagStyle   _tagStyle;
    BOOL         _noClickable;
    
    UIColor     *_tagTextColorNormal;
    UIColor     *_tagTextColorSelected;
    UIColor     *_tagBGColorNormal;
    UIColor     *_tagBGColorSelected;
    UIColor     *_tagBorderColorNormal;
    UIColor     *_tagBorderColorSelected;
}
@end

@implementation HYTagView

- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray *)tagsArray
                     tagStyle:(HYTagStyle)tagStyle
                  noClickable:(BOOL)noClickable{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _tagsArray = [[NSArray alloc] initWithArray:tagsArray];
        _tagStyle = tagStyle;
        _noClickable = noClickable;
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    //NormalStyle Normal    文字0x373737、背景0xF3F4F5、边框无
    //            Selected  文字0xFFFFFF、背景0xFF9933、边框无
    //BorderStyle Normal    文字0x373737、背景无、边框0x373737
    //            Selected  文字0xFF8903、背景无、边框0xFF8903
    
    if (_tagStyle==HYTagStyleNormal) {
        
        _tagTextColorNormal   = HexColor(0x373737,1);
        _tagTextColorSelected = HexColor(0xFFFFFF,1);
        _tagBGColorNormal     = HexColor(0xF3F4F5,1);
        _tagBGColorSelected   = HexColor(0xFF9933,1);
        _tagBorderColorNormal   = HexColor(0xFFFFFF,0);
        _tagBorderColorSelected = HexColor(0xFFFFFF,0);
    }else{
        
        _tagTextColorNormal   = HexColor(0x373737,1);
        _tagTextColorSelected = HexColor(0xFF8903,1);
        _tagBGColorNormal     = HexColor(0xFFFFFF,0);
        _tagBGColorSelected   = HexColor(0xFFFFFF,0);
        _tagBorderColorNormal   = HexColor(0x373737,1);
        _tagBorderColorSelected = HexColor(0xFF8903,1);
    }
    
    for (NSInteger i=0 ; i<_tagsArray.count ;i++) {
        
        UIButton *tagBtn = [[UIButton alloc] init];
        tagBtn.tag = kTagBtnBaseTag + i;
        [self addSubview:tagBtn];
    }
}

- (void)layoutSubviews{
    
    CGFloat marginW = 10;
    CGFloat marginH = 10;
    CGFloat lineH = 30;
    CGFloat horizontal = 0;     //水平宽度
    CGFloat vertical = marginH; //垂直高度
    CGFloat lineNum = 0;
    
    for (NSInteger i=0 ; i<_tagsArray.count ;i++) {
        
        HYTagModel *tagModel = _tagsArray[i];
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        [tagBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
        tagBtn.selected = tagModel.isSelected;
        
        //---开始计算给btn布局
        CGFloat tagBtnX, tagBtnY, tagBtnW, tagBtnH;
        
        tagBtnH = lineH;
        tagBtnW = [tagModel.tagName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTagBtnFontSize]}].width+lineH;
        
        horizontal += marginW;
        
        if (horizontal + tagBtnW + marginW > self.frame.size.width) {
            //一行房不下了，需要从第二行开始放
            lineNum += 1;
            horizontal = marginW;
            vertical += marginH + lineH;
        }
        
        tagBtnX = horizontal;
        tagBtnY = vertical;
        
        horizontal = tagBtnX + tagBtnW;
        tagBtn.frame = (CGRect){tagBtnX, tagBtnY, tagBtnW, tagBtnH};
        //---btn布局结束
        
        //对于不可点击的tagView（仅展示）
        if (_noClickable) {
            
            tagBtn.userInteractionEnabled = NO;
            [tagBtn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            tagBtn.userInteractionEnabled = YES;
            [tagBtn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //---设置外观
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:kTagBtnFontSize];
        tagBtn.layer.cornerRadius = tagBtn.frame.size.height/2.0f;
        tagBtn.layer.borderWidth = 1.0f;
        [tagBtn setTitleColor:_tagTextColorNormal forState:UIControlStateNormal];
        [tagBtn setTitleColor:_tagTextColorSelected forState:UIControlStateSelected];
        
        //---设置各种style下的外观
        [self customAppearanceTagBtn:tagBtn];
    }
    
    //---tagView重新适应
    self.frame = (CGRect){self.frame.origin.x, self.frame.origin.y, self.frame.size.width ,vertical+lineH+marginW};
    
}

- (void)customAppearanceTagBtn:(UIButton *)tagBtn{
    
    tagBtn.backgroundColor = tagBtn.selected ? _tagBGColorSelected : _tagBGColorNormal;
    tagBtn.layer.borderColor = tagBtn.selected ? _tagBorderColorSelected.CGColor : _tagBorderColorNormal.CGColor;
}

- (void)clickTag:(UIButton *)tagBtn{
    
    tagBtn.selected = tagBtn.selected ? NO : YES;
    HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
    tagModel.isSelected = tagBtn.selected;
    
    [self customAppearanceTagBtn:tagBtn];
    //    NSLog(@"==%@",tagModel);
}

- (NSArray *)getSelectedTags{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (HYTagModel * model in _tagsArray) {
        
        if (model.isSelected)
            [resultArray addObject:model];
    }
    
    return resultArray;
}

- (NSArray *)getUnselectedTags{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (HYTagModel * model in _tagsArray) {
        
        if (!model.isSelected)
            [resultArray addObject:model];
    }
    
    return resultArray;
}

- (void)selectAllTag{
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = NO;
        [self clickTag:tagBtn];
    }
}

- (void)unselectAllTag{
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = YES;
        [self clickTag:tagBtn];
    }
}

@end
