//
//  HYTagView.h
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author HY, 16-06-20
 *
 *  @brief TagView的Tag模型
 */
@interface HYTagModel : NSObject

@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, copy)   NSString *tagName;
@property (nonatomic, assign) BOOL      isSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

/**
 *  @author HY, 16-06-20
 *
 *  @brief TagView的界面
 */
@interface HYTagView : UIView

//用tagsArray初始化TagView
- (instancetype)initWithFrame:(CGRect)frame tagsArray:(NSArray *)tagsArray;

//获取所有选中的Tags
- (NSArray *)getSelectedTags;

//获取所有未选中的Tags
- (NSArray *)getUnselectedTags;

//选中所有Tag
- (void)selectAllTag;

//取消选中所有Tag
- (void)unselectAllTag;


@end
