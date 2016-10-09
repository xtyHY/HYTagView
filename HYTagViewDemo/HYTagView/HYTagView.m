//
//  HYTagView.m
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "HYTagView.h"

#define HexColor(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

static NSInteger const kTagBtnBaseTag   = 1000;
static NSInteger const kTagBtnFontSize  = 14;
static CGFloat   const kBtnMarginW      = 10;
static CGFloat   const kBtnMarginH      = 10;
static CGFloat   const kTagHeight       = 30;
static CGFloat   const kTagInnerMarginW = 30;

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

- (instancetype)initWithTagId:(NSInteger)tagId tagName:(NSString *)tagName{
    
    return [self initWithTagId:tagId tagName:tagName isSelected:NO];
}

- (instancetype)initWithTagId:(NSInteger)tagId tagName:(NSString *)tagName isSelected:(BOOL)isSelected{
    
    self = [super init];
    if (self) {
        _tagId   = tagId;
        _tagName = tagName;
        _isSelected = isSelected;
    }
    
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"tagId:%li tagName:%@ isSelected:%i",_tagId, _tagName, _isSelected];
}

@end

//============= HYTagView =============
@interface HYTagView(){
    
    NSArray         *_tagsArray;
    HYTagStyle       _tagStyle;
    BOOL             _clickable;
    BOOL             _finishSetupTags;  //是否结束布局
}
@end

@implementation HYTagView

#pragma mark - 初始化及配置
- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray *)tagsArray{
    
    return [self initWithFrame:frame tagsArray:tagsArray clickable:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray *)tagsArray
                     tagStyle:(HYTagStyle)tagStyle
                    clickable:(BOOL)clickable{
    
    self = [self initWithFrame:frame tagsArray:tagsArray clickable:clickable];
    if (self) {
        
        _tagStyle = tagStyle;
        [self initStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray<HYTagModel *> *)tagsArray
                    clickable:(BOOL)clickable{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _tagsArray = [[NSArray alloc] initWithArray:tagsArray];
        _tagStyle  = HYTagStyleNormal;
        _clickable = clickable;
        _numberOfLines = 0;
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    for (NSInteger i=0 ; i<_tagsArray.count ;i++) {
        
        UIButton *tagBtn = [[UIButton alloc] init];
        tagBtn.tag = kTagBtnBaseTag + i;
        [self addSubview:tagBtn];
    }
    
    _tagMarginW      = -1;
    _tagMarginH      = -1;
    _tagHeight       = -1;
    _tagInnerMarginW = -1;
    _tagFontSize     = -1;
    _tagCornerRadius = -1;
    _numberOfLines   = 0;
    _allowsSingleSelection = NO;
}

- (void)initStyle{
    //NormalStyle Normal    文字0x373737、背景0xF3F4F5、边框无
    //            Selected  文字0xFFFFFF、背景0xFF9933、边框无
    //BorderStyle Normal    文字0x373737、背景无、边框0x373737
    //            Selected  文字0xFF8903、背景无、边框0xFF8903
    switch (_tagStyle) {
        case HYTagStyleNormal: {
            
            _tagTextColorNormal    = HexColor(0x373737,1);
            _tagTextColorHighlight = HexColor(0xFFFFFF,1);
            _tagBgColorNormal      = HexColor(0xF3F4F5,1);
            _tagBgColorHighlight   = HexColor(0xFF9933,1);
            _tagBorderColorNormal    = HexColor(0xFFFFFF,0);
            _tagBorderColorHighlight = HexColor(0xFFFFFF,0);
        }
            break;
        case HYTagStyleBorder: {
            
            _tagTextColorNormal    = HexColor(0x373737,1);
            _tagTextColorHighlight = HexColor(0xFF8903,1);
            _tagBgColorNormal      = HexColor(0xFFFFFF,0);
            _tagBgColorHighlight   = HexColor(0xFFFFFF,0);
            _tagBorderColorNormal    = HexColor(0x373737,1);
            _tagBorderColorHighlight = HexColor(0xFF8903,1);
            _tagHeight = 23;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 配置style
- (void)configStyle{
    
    //处理一下配置对ui不合适的情况
    _tagMarginW      = _tagMarginW      < 0 ? kBtnMarginW : _tagMarginW;
    _tagMarginH      = _tagMarginH      < 0 ? kBtnMarginH : _tagMarginH;
    _tagHeight       = _tagHeight < kTagBtnFontSize ? kTagHeight : _tagHeight;
    _tagInnerMarginW = _tagInnerMarginW < 0 ? kTagInnerMarginW : _tagInnerMarginW;
    _tagFontSize     = _tagFontSize     < 0 ? kTagBtnFontSize : _tagFontSize;
    _tagCornerRadius = _tagCornerRadius < 0 ? _tagHeight/2.f : _tagCornerRadius;
    
    _tagTextColorNormal      = _tagTextColorNormal      ? _tagTextColorNormal       : HexColor(0x373737,1);
    _tagBgColorNormal        = _tagBgColorNormal        ? _tagBgColorNormal         : HexColor(0xF3F4F5,1);
    _tagBorderColorNormal    = _tagBorderColorNormal    ? _tagBorderColorNormal     : HexColor(0xFFFFFF,0);
    
    _tagTextColorHighlight   = _tagTextColorHighlight   ? _tagTextColorHighlight    : HexColor(0xFFFFFF,1);
    _tagBgColorHighlight     = _tagBgColorHighlight     ? _tagBgColorHighlight      : HexColor(0xFF9933,1);
    _tagBorderColorHighlight = _tagBorderColorHighlight ? _tagBorderColorHighlight  : HexColor(0xFFFFFF,0);
}

#pragma mark - Tags布局
- (void)setupTags{
    
    CGFloat currentX   = 0;  //当前x位置
    CGFloat currentY   = 0;  //当前y位置
    CGFloat lineNum    = 0;  //当前行数
    
    for (NSInteger i=0 ; i<_tagsArray.count ;i++) {
        
        HYTagModel *tagModel = _tagsArray[i];
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        [tagBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
        tagBtn.selected = tagModel.isSelected;
        
        //---开始计算给btn布局
        CGFloat tagBtnX, tagBtnY, tagBtnW, tagBtnH;
        
        tagBtnH = _tagHeight;
        tagBtnW = [tagModel.tagName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTagBtnFontSize]}].width+_tagInnerMarginW;
        
        if (currentX + tagBtnW + _tagMarginW > self.frame.size.width) {
            
            //支持限定行数模式，默认多行
            if (_numberOfLines>0 && _numberOfLines<=lineNum+1) {
                break;
            }
            
            //一行房不下了，需要从第二行开始放
            lineNum += 1;
            currentX = 0;
            currentY += _tagMarginH + _tagHeight;
        }
        
        tagBtnX = currentX;
        tagBtnY = currentY;
        
        currentX = tagBtnX + tagBtnW;
        tagBtn.frame = (CGRect){tagBtnX, tagBtnY, tagBtnW, tagBtnH};
        
        //下一个btn先加一下marginW
        currentX += _tagMarginW;
        //---btn布局结束
        
        //---控制事件
        tagBtn.userInteractionEnabled = _clickable ? YES : NO;
        [tagBtn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        
        //---设置外观
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:kTagBtnFontSize];
        tagBtn.layer.cornerRadius = _tagCornerRadius;
        tagBtn.layer.borderWidth = 1.0f;
        [tagBtn setTitleColor:_tagTextColorNormal forState:UIControlStateNormal];
        [tagBtn setTitleColor:_tagTextColorHighlight forState:UIControlStateSelected];
        
        //---设置各种style下的外观
        [self customAppearanceTagBtn:tagBtn];
    }
    
    //---tagView重新适应
    if (_tagsArray.count > 0) {
        //有tag显示才重新修改frame
        self.frame = (CGRect){self.frame.origin.x, self.frame.origin.y, self.frame.size.width ,currentY+_tagHeight};
    }
    
    _finishSetupTags = YES;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self configStyle];
    [self setupTags];
}

#pragma mark - 点击事件
- (void)clickTag:(UIButton *)tagBtn{
    
    HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
    
    if (tagBtn.selected) {
        //已经选中的tagBtn被点击--取消选中
        [self deselectByTagId:tagModel.tagId];
    }else {
        //未被选中的tagBtn被点击--选中
        [self selectByTagId:tagModel.tagId];
    }
    
    if (self.selectAction) {
        self.selectAction(tagModel);
    }
    //    NSLog(@"==%@",tagModel);
}

#pragma mark - 根据是否选中改变外观
- (void)customAppearanceTagBtn:(UIButton *)tagBtn{
    
    tagBtn.backgroundColor   = tagBtn.selected ? _tagBgColorHighlight : _tagBgColorNormal;
    tagBtn.layer.borderColor = tagBtn.selected ? _tagBorderColorHighlight.CGColor : _tagBorderColorNormal.CGColor;
}

#pragma mark - 对外方法
#pragma mark 获取所有选中的Tags
- (NSArray *)getSelectedTags{
    
    return [self getTagsIsSelected:YES];
}

#pragma mark 获取所有未选中的Tags
- (NSArray *)getUnselectedTags{
    
    return [self getTagsIsSelected:NO];
}

#pragma mark 获取TagView的Frame
- (CGRect)getTagViewFrame{
    
    if (_finishSetupTags) {
        return self.frame;
        
    }else{
        [self configStyle];
        [self setupTags];
        
        CGRect tagFrame = self.frame;
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        [self removeFromSuperview];
        
        return tagFrame;
    }
}

#pragma mark 选中所有的Tag
- (void)selectAllTag{
    
    [self changeAllTagStatusToSelected:YES];
}

#pragma mark 反选所有Tag
- (void)deselectAllTag{
    
    [self changeAllTagStatusToSelected:NO];
}

#pragma mark - 私有方法
#pragma mark 获取选中/非选中Tags
- (NSArray *)getTagsIsSelected:(BOOL)isSelected{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (HYTagModel * model in _tagsArray) {
        
        if (model.isSelected==isSelected)
            [resultArray addObject:model];
    }
    
    return resultArray;
}

#pragma mark 选中/反选所有Tag
- (void)changeAllTagStatusToSelected:(BOOL)toSelected{
    
    if (_allowsSingleSelection) {
        NSLog(@"Tagview在开启仅单选模式时，不能主动全选/反选");
        return;
    }
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
        tagModel.isSelected = toSelected;
        tagBtn.selected = toSelected;
        [self customAppearanceTagBtn:tagBtn];
    }
}

#pragma mark 单选
- (void)selectByTagId:(NSInteger)tagId{
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
        
        if (tagId == tagModel.tagId) {
            tagModel.isSelected = YES;
            tagBtn.selected = YES;
        }else{
            
            if (_allowsSingleSelection) {
                //开启仅单选模式
                tagModel.isSelected = NO;
                tagBtn.selected = NO;
            }
        }
        
        [self customAppearanceTagBtn:tagBtn];
    }
}

- (void)deselectByTagId:(NSInteger)tagId{
    
    if (_allowsSingleSelection) {
        //纯单选模式不能反选
        NSLog(@"tagview在仅单选的模式下无法反选");
        return;
    }
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
        
        if (tagId == tagModel.tagId) {
            
            tagModel.isSelected = NO;
            tagBtn.selected = NO;
        }
        
        [self customAppearanceTagBtn:tagBtn];
    }
}

@end
