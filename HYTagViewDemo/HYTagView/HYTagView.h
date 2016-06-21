//
//  HYTagView.h
//  HYTagViewDemo
//
//  Created by 徐天宇 on 16/6/20.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HYTagStyle) {
    HYTagStyleNormal    =   0,
    HYTagStyleBorder
};

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

/**
 *  @author HY, 16-06-21
 *
 *  @brief 简单的初始化一个TagView（样式为默认/可点击）
 *
 *  @param frame     TagView尺寸
 *  @param tagsArray 需要显示的TagModel数据
 *
 *  @return TagView对象
 */
- (instancetype)initWithFrame:(CGRect)frame tagsArray:(NSArray *)tagsArray;

/**
 *  @author HY, 16-06-21
 *
 *  @brief 初始化一个TagView
 *
 *  @param frame       TagView尺寸
 *  @param tagsArray   需要显示的TagModel数组
 *  @param tagStyle    tag的样式（HYTagStyle枚举）
 *  @param clickable   能否点击
 *
 *  @return TagView对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray *)tagsArray
                     tagStyle:(HYTagStyle)tagStyle
                    clickable:(BOOL)clickable;

/**
 *  @author HY, 16-06-21
 *
 *  @brief 获取所有选中的TagModel
 *
 *  @return 所有选中的TagModel的数组
 */
- (NSArray *)getSelectedTags;

/**
 *  @author HY, 16-06-21
 *
 *  @brief 获取所有未选中的TagModel
 *
 *  @return 所有未选中的TagModel的数组
 */
- (NSArray *)getUnselectedTags;

/**
 *  @author HY, 16-06-21
 *
 *  @brief 主动选中所有Tag
 */
- (void)selectAllTag;

/**
 *  @author HY, 16-06-21
 *
 *  @brief 主动取消选中所有Tag
 */
- (void)unselectAllTag;


@end
