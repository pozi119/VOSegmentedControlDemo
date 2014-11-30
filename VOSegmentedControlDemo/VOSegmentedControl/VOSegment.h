//
//  VOSegment.h
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-27.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  描述Segment的数据模型
 */
@interface VOSegment : NSObject
@property (nonatomic, strong) id      text;						// 文字,NSString或NSAttributedString, 与图像二者必选其一
@property (nonatomic, strong) id      selectedText;				// 选中状态的文字, 默认与非选中状态一样
@property (nonatomic, strong) UIImage *image;					// 图像, 与文字二者必选其一
@property (nonatomic, strong) UIImage *selectedImage;			// 选中状态的图像, 默认与非选中状态一样
@property (nonatomic, strong) UIImage *backgroundImage;			// 背景图像
@property (nonatomic, strong) UIImage *selectedBackgroundImage;	// 选中状态的背景图像
@property (nonatomic, assign) BOOL    enabled;					// 启用/禁用

/**
 *  从NSDictionary生成VOSegment
 *
 *  @param segmentdic NSDictionary,包含segment的各种参数
 *
 *  @return VOSegment对象
 */
+ (instancetype)segmentFromDictionary:(NSDictionary *)segmentdic;
+ (BOOL)isValidSegment: (VOSegment *)segment;

@end
