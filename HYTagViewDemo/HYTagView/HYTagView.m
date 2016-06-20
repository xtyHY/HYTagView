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
    
    NSArray *_tagsArray;
}
@end

@implementation HYTagView

- (instancetype)initWithFrame:(CGRect)frame tagsArray:(NSArray *)tagsArray{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _tagsArray = [[NSArray alloc] initWithArray:tagsArray];
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
        
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        if (tagBtn.selected) {
            
            [tagBtn setBackgroundColor:[UIColor orangeColor]];
        }else{
            
            [tagBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [tagBtn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        
        tagBtn.layer.cornerRadius = lineH/2.0f;
        
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
    }
    
    self.frame = (CGRect){self.frame.origin.x, self.frame.origin.y, self.frame.size.width ,vertical+lineH+margin};
}

- (void)clickTag:(UIButton *)tagBtn{
    
    tagBtn.selected = tagBtn.selected ? NO : YES;
    HYTagModel *tagModel = _tagsArray[tagBtn.tag-kTagBtnBaseTag];
    tagModel.isSelected = tagBtn.selected;
    
    if (tagBtn.selected) {
        
        [tagBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        
        [tagBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    
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
        
        HYTagModel *tagModel = _tagsArray[i];
        tagModel.isSelected = YES;
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = NO;
        [self clickTag:tagBtn];
    }
}

- (void)unselectAllTag{
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        
        HYTagModel *tagModel = _tagsArray[i];
        tagModel.isSelected = NO;
        
        UIButton *tagBtn = [self viewWithTag:kTagBtnBaseTag+i];
        tagBtn.selected = YES;
        [self clickTag:tagBtn];
    }
}

@end
