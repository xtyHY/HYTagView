//
//  HYTagView.m
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "HYTagView.h"

#define kTagBtnBaseTag 1000

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
    }
    return self;
}

- (void)layoutSubviews{
    
    CGFloat margin = 8;
    CGFloat lineH = 30;
    CGFloat horizontal = 0;
    CGFloat vertical = margin;
    CGFloat lineNum = 0;
    
    for (NSInteger i=0 ; i<_tagsArray.count ;i++) {
        
        HYTagModel *tagModel = _tagsArray[i];
        
        UIButton *tagBtn = [[UIButton alloc] init];
        
        [tagBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
        tagBtn.selected = tagModel.isSelected;
        tagBtn.tag = kTagBtnBaseTag + i;
        
        CGFloat tagBtnW = [tagModel.tagName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width+lineH;
        CGFloat tagBtnH = lineH;
        
        horizontal += margin;
        
        
        CGFloat tagBtnX;
        CGFloat tagBtnY;
        
        if (horizontal + tagBtnW + margin > self.frame.size.width) {
            
            lineNum += 1;
            horizontal = margin;
            vertical += margin + lineH;
        }
        
        tagBtnX = horizontal;
        tagBtnY = vertical;
        
        tagBtn.frame = (CGRect){tagBtnX, tagBtnY, tagBtnW, tagBtnH};
        [self addSubview:tagBtn];
        
        horizontal = tagBtnX + tagBtnW;
        
        [self customAppearanceTagBtn:tagBtn];
    }
    
    self.frame = (CGRect){self.frame.origin.x, self.frame.origin.y, self.frame.size.width ,vertical+lineH+margin};
    
    
}

- (void)customAppearanceTagBtn:(UIButton *)tagBtn{
    
    tagBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    tagBtn.layer.cornerRadius = tagBtn.frame.size.height/2.0f;
    
    if (_tagStyle==HYTagStyleNormal) {
        
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.backgroundColor = tagBtn.selected ? [UIColor orangeColor] : [UIColor lightGrayColor];
        
    }else if(_tagStyle==HYTagStyleBorder){
        
        tagBtn.layer.borderWidth = 1.0f;
        tagBtn.layer.borderColor = tagBtn.selected ? [UIColor orangeColor].CGColor : [UIColor blackColor].CGColor;
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
}

- (void)clickTag:(UIButton *)tagBtn{
    
    if (!_noClickable) {
        
        tagBtn.selected = tagBtn.selected ? NO : YES;
        HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
        tagModel.isSelected = tagBtn.selected;
    }
    
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
    
    if (_noClickable)
        return;
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = NO;
        [self clickTag:tagBtn];
    }
}

- (void)unselectAllTag{
    
    if (_noClickable)
        return;
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = YES;
        [self clickTag:tagBtn];
    }
}

@end
