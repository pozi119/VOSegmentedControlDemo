//
//  VOContentLayer.h
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-27.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VOSegment.h"

#define kContentAnimationDuration 0.5

typedef NS_ENUM(NSUInteger, VOContentStyle) {
	VOContentStyleTextAlone,				// 只有文字
	VOContentStyleImageAlone,				// 只有图片, imageLayer.size = self.bounds.size
	VOContentStyleImageLeft,				// 图片在左侧, imageLayer为正方形, 最大边长为self.bounds.size.height
	VOContentStyleImageRight,				// 图片在右侧, imageLayer为正方形, 最大边长为self.bounds.size.height
	VOContentStyleImageTop,					// 图片在顶部, imageLayer高度为self.bounds.size.height * 0.618
	VOContentStyleImageBottom,				// 图片在底部, imageLayer高度为self.bounds.size.height * 0.618
};

@interface VOContentLayer : CALayer

@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, strong) UIFont  *selectedFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectedbackgroundColor;

@property (nonatomic, strong) VOSegment *segment;
@property (nonatomic, assign) BOOL		selected;
@property (nonatomic, assign) BOOL      clung;  // 当图片较小时,是否紧贴文字

- (void)setSelected:(BOOL)selected animated:(BOOL)animated completion: (void (^)())completion;

+ (instancetype)contentLayerWithFrame:(CGRect)frame
						contentInsets:(UIEdgeInsets)insets
							  segment:(VOSegment *)segment
						 contentStyle:(VOContentStyle)style;

@end
