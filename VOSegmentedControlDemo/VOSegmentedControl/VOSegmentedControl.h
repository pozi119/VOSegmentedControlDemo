//
//  VOSegmentedControl.h
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-19.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOContentLayer.h"

#pragma mark - 防止[self performSelector:sel]警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef NS_ENUM(NSUInteger, VOSegCtrlIndicatorStyle) {
	VOSegCtrlIndicatorStyleBottomLine,		// 底部横线
	VOSegCtrlIndicatorStyleTopLine,			// 顶部横线
	VOSegCtrlIndicatorStyleBox,				// 方框,泡泡
};

typedef NS_ENUM(NSUInteger, VOSegCtrlAnimationType) {
	VOSegCtrlAnimationTypeSmooth,			// 平滑
	VOSegCtrlAnimationTypeBounce,			// 跳动
};

enum {
	VOSegmentedControlNoSegment = -1		// 未选择Segment
};

#define kDefaultDuration 0.3


@interface VOSegmentedControl : UIControl <NSCoding>

#pragma mark 样式
@property (nonatomic, assign) VOContentStyle          contentStyle;
@property (nonatomic, assign) VOSegCtrlIndicatorStyle indicatorStyle;
@property (nonatomic, assign) VOSegCtrlAnimationType  animationType;
@property (nonatomic, assign) BOOL					  allowNoSelection;
@property (nonatomic, assign) BOOL					  scrollBounce;

#pragma mark 色彩
@property (nonatomic, strong ) UIColor         *textColor;
@property (nonatomic, strong ) UIColor         *selectedTextColor;
@property (nonatomic, strong ) UIColor         *selectedBackgroundColor;

#pragma mark Indicator属性
@property (nonatomic, assign ) CGFloat         indicatorThickness;
@property (nonatomic, assign ) CGFloat         indicatorCornerRadius;
@property (nonatomic, strong ) UIColor         *indicatorColor;
@property (nonatomic, strong ) UIColor         *selectedIndicatorColor;

#pragma mark 分段
@property (nonatomic,readonly) NSUInteger      numberOfSegments;
@property (nonatomic, assign ) NSInteger       selectedSegmentIndex;
@property (nonatomic, strong ) UIFont          *textFont;
@property (nonatomic, strong ) UIFont          *selectedTextFont;

#pragma mark 内容
@property (nonatomic, strong ) NSArray         *segments;

#pragma mark indexchange
@property (nonatomic, weak  ) void  (^indexChangeBlock)(NSInteger index);

/**
 *  使用NSDictionary类型的Item数组初始化控件
 *
 *  @param segments VOSegment或者NSDictionary
 *  @return VOSegmentedControl
 */
- (instancetype)initWithSegments:(NSArray *)segments;

/**
 *  插入一个segment
 *
 *  @param segment  VOSegment或NSDictionary
 *  @param index    插入的位置
 *  @param animated 是否有动画效果
 */
- (void)insertSegment:(id)segment atIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 *  删除一个segment
 *
 *  @param index    要删除的segment的位置
 *  @param animated 是否有动画效果
 */
- (void)removeSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 *  删除所有segment
 */
- (void)removeAllSegments;

/**
 *  设置指定位置的segment
 *
 *  @param segment VOSegment或NSDictionary
 *  @param index   设置的位置
 */
- (void)setSegment:(id)segment atIndex:(NSUInteger)index;

/**
 *  获取指定位置的segment内容
 *
 *  @param index segment的位置
 *
 *  @return segment,字典类型, image和selectedimage为UIImage或nil
 */
- (VOSegment *)segmentAtIndex: (NSUInteger)index;

/**
 *  启用/禁用某个segment
 *
 *  @param enabled YES-启用, NO-禁用
 *  @param index   segment的位置
 */
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)index;

/**
 *  获取segment的启用/禁用状态
 *
 *  @param segment segment的位置
 *
 *  @return YES-启用,NO-禁用
 */
- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index;

#pragma mark - 小红点
/**
 *  设置小红点的位置(左上角为基准,inset的top和right有效)
 *
 *  @param inset 位置
 *  @param index 所在分段
 */
- (void)setInset:(UIEdgeInsets)inset forSegmentRedPointAtIndex:(NSUInteger)index;

/**
 *  设置小红点是否显示
 *
 *  @param show  是否显示
 *  @param index 所在的分段
 */
- (void)setShow:(BOOL)show forSegmentRedPointAtIndex:(NSUInteger)index;

/**
 *  小红点的显示状态
 *
 *  @param index 所在的分段
 *
 *  @return 是否显示
 */
- (BOOL)isSegmentRedPointShowAtIndex:(NSUInteger)index;

@end