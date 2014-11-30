//
//  VOLayerAnimation.h
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-30.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 *  指示器专用的动画效果
 *  @desc  指示器相关动画不会更改指示器Layer的frame,只更改position, 弹簧效果会对Layer的bounds进行操作.
 */
@interface VOIndicatorAnimation : NSObject
/**
 *  弹簧效果
 *
 *  @param indicator 要进行动画的Layer
 *  @param fromPos   开始移动的位置
 *  @param toPos     移动结束的位置
 *  @param duration  动画执行的时间
 */
+ (void)bounceMoveIndicator: (CALayer *)indicator fromPostion: (CGPoint)fromPos toPosition: (CGPoint)toPos duration: (CGFloat)duration;

/**
 *  平滑效果
 *
 *  @param indicator 要进行动画的Layer
 *  @param fromPos   开始移动的位置
 *  @param toPos     移动结束的位置
 *  @param duration  动画执行的时间
 */
+ (void)smoothMoveIndicator: (CALayer *)indicator fromPostion: (CGPoint)fromPos toPosition: (CGPoint)toPos duration: (CGFloat)duration;

@end
