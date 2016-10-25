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
 *  @brief TagView的Tag模型
 */
@interface HYTagModel : NSObject

@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, copy)   NSString *tagName;
@property (nonatomic, assign) BOOL      isSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithTagId:(NSInteger)tagId tagName:(NSString *)tagName;
- (instancetype)initWithTagId:(NSInteger)tagId tagName:(NSString *)tagName isSelected:(BOOL)isSelected;

@end

/**
 *  @brief TagView的界面
 */
@interface HYTagView : UIView

@property (nonatomic, assign) BOOL allowsSingleSelection; //!< 开启单选模式，默认NO，注意目前单选模式不能反选已选中的
@property (nonatomic, assign) NSUInteger numberOfLines;  //!< 默认是0，任意行显示，
@property (nonatomic, copy) void(^selectAction)(HYTagModel *model); //!< Tag点击回调

@property (nonatomic, assign) CGFloat tagMarginW;   //!< 2个tag之间的水平距离，默认为10
@property (nonatomic, assign) CGFloat tagMarginH;   //!< 2个tag之间的垂直距离，默认为10
@property (nonatomic, assign) CGFloat tagCornerRadius;  //!<默认为tag高度的一半

@property (nonatomic, assign) CGFloat tagFontSize;     //!<tag的font大小，默认为14，
@property (nonatomic, assign) CGFloat tagHeight;       //!<tag的高度，默认为30，为保证显示，最小=tagFontSize + 2
@property (nonatomic, assign) CGFloat tagInnerMarginW; //!<tag内部宽度marigin，默认=tagHight，最小=0

@property (nonatomic, strong) UIColor *tagTextColorNormal;     //!< tag文字普通颜色
@property (nonatomic, strong) UIColor *tagBgColorNormal;       //!< tag文字普通颜色
@property (nonatomic, strong) UIColor *tagBorderColorNormal;   //!< tag文字普通颜色

@property (nonatomic, strong) UIColor *tagTextColorHighlight;  //!< tag文字高亮颜色
@property (nonatomic, strong) UIColor *tagBgColorHighlight;    //!< tag背景高亮颜色
@property (nonatomic, strong) UIColor *tagBorderColorHighlight;//!< tag边框高亮颜色

/**
 *  @brief 简单的初始化一个TagView（样式为默认/可点击）
 *
 *  @param frame     TagView尺寸
 *  @param tagsArray 需要显示的TagModel数据
 *
 *  @return TagView对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    tagsArray:(NSArray<HYTagModel *> *)tagsArray;

/**
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
                    tagsArray:(NSArray<HYTagModel *> *)tagsArray
                     tagStyle:(HYTagStyle)tagStyle
                    clickable:(BOOL)clickable;

#pragma mark - 获取操作
/**
 *  @brief 获取所有选中的TagModel
 *
 *  @return 所有选中的TagModel的数组
 */
- (NSArray *)getSelectedTags;

/**
 *  @brief 获取所有未选中的TagModel
 *
 *  @return 所有未选中的TagModel的数组
 */
- (NSArray *)getUnselectedTags;

/**
 *  @brief 获取TagView的Frame。<br/>
 *         若是单纯要获取高度，如动态计算cell高度时，需先用数据创建tagView后调用本方法，返回frame时会销毁掉这个对象。<br/>
 *         若是tagview已经被添加到界面上了，再获取高度，则不会销毁对象，和tagView.frame无异
 *
 *  @return tagView的Frame
 */
- (CGRect)getTagViewFrame;

#pragma mark - 主动操作
/**
 *  @brief 主动选中所有Tag，单选模式下无效
 */
- (void)selectAllTag;

/**
 *  @brief 主动反选所有Tag，单选模式下无效
 */
- (void)deselectAllTag;

/**
 *  @brief 主动选中某个Tag（根据tagId）
 */
- (void)selectByTagId:(NSInteger)tagId;

/**
 *  @brief 主动反选某个Tag（根据tagId），单选模式下不无效（待完善是否支持）
 */
- (void)deselectByTagId:(NSInteger)tagId;

@end
