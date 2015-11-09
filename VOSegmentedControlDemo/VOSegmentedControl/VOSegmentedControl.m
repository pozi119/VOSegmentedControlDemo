//
//  VOSegmentedControl.m
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-19.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOSegmentedControl.h"
#import "VOIndicatorAnimation.h"

#define kTextPadding 8

#pragma mark - VOSegmentedControl
@interface VOSegmentedControl ()
@property (nonatomic, strong) NSMutableArray *segmentArray;
@property (nonatomic, strong) NSMutableArray *contentLayerArray;
@property (nonatomic, strong) NSMutableDictionary *showRedPointDic;
@property (nonatomic, strong) NSMutableDictionary *redPointInsetsDic;

@property (nonatomic, strong) CAScrollLayer  *scrollLayer;
@property (nonatomic, strong) CALayer        *indicatorLayer;

@property (nonatomic, assign) CGSize         segSize;

@property (nonatomic, assign) CGPoint        lastPoint;
@property (nonatomic, assign) CGPoint        startPoint;
@property (nonatomic, assign) BOOL		     isClick;

@property (nonatomic, assign) CGPoint        indicatorPos;
@end

@implementation VOSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSegments:(NSArray *)segments{
	if (self = [super initWithFrame:CGRectZero]) {
        [self commonInit];
		// 1. 初始化存放segments各种参数的数组
        [self setSegments:segments];
	}
	return self;
}

- (void)commonInit{
	// array
    self.segmentArray            = [NSMutableArray array];
    self.contentLayerArray       = [NSMutableArray array];
    self.showRedPointDic         = [NSMutableDictionary dictionary];
    self.redPointInsetsDic        = [NSMutableDictionary dictionary];

	// ScrollView

	// 样式
    self.contentStyle            = VOContentStyleTextAlone;
    self.indicatorStyle          = VOSegCtrlIndicatorStyleBox;
    self.animationType           = VOSegCtrlAnimationTypeBounce;
    self.allowNoSelection        = YES;
	self.scrollBounce            = YES;

	// 色彩
    self.textColor               = [UIColor blackColor];
    self.selectedTextColor       = [UIColor redColor];
    self.backgroundColor         = [UIColor whiteColor];
    self.selectedBackgroundColor = [UIColor whiteColor];

	// indicator属性
    self.indicatorThickness      = 0;
    self.indicatorCornerRadius   = 0;
    self.indicatorColor          = [UIColor clearColor];
    self.selectedIndicatorColor  = [UIColor redColor];

	// 分段
    self.textFont                = [UIFont systemFontOfSize:14];
    self.selectedTextFont        = [UIFont systemFontOfSize:14];

	// Layer
    self.scrollLayer             = [CAScrollLayer layer];

	// test
    _selectedSegmentIndex        = 0;
}

- (CALayer *)indicatorLayer{
	if (!_indicatorLayer) {
		CALayer *indicatorLayer = [CALayer layer];
		switch (self.indicatorStyle) {
			case VOSegCtrlIndicatorStyleTopLine:
			case VOSegCtrlIndicatorStyleBottomLine:
                indicatorLayer.cornerRadius    = self.indicatorCornerRadius;
                indicatorLayer.backgroundColor = self.selectedIndicatorColor.CGColor;
				break;
				
			case VOSegCtrlIndicatorStyleBox:
                indicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
                indicatorLayer.borderWidth     = self.indicatorThickness;
                indicatorLayer.cornerRadius    = self.indicatorCornerRadius;
                indicatorLayer.borderColor     = self.selectedIndicatorColor.CGColor;
				break;
				
			default:
				break;
		}
		_indicatorLayer = indicatorLayer;
	}
	return _indicatorLayer;
}

- (void)setIndicatorStyle:(VOSegCtrlIndicatorStyle)indicatorStyle{
	_indicatorStyle = indicatorStyle;
	_indicatorLayer = nil;
	[self setNeedsDisplay];
}

- (NSUInteger)numberOfSegments{
	return self.segmentArray.count;
}

- (void)setSegments:(NSArray *)segments{
    [self.segmentArray removeAllObjects];
    for (id segment in segments) {
        if ([segment isKindOfClass:[VOSegment class]]) {
            if ([VOSegment isValidSegment:segment]) {
                [self.segmentArray addObject:segment];
            }
        }
        if ([segment isKindOfClass:[NSDictionary class]]) {
            VOSegment *seg = [VOSegment segmentFromDictionary:segment];
            if ([VOSegment isValidSegment:seg]) {
                [self.segmentArray addObject:[VOSegment segmentFromDictionary:segment]];
            }
        }
    }
    [self setNeedsDisplay];
}

- (NSArray *)segments{
    return _segmentArray;
}

- (void)insertSegment:(id)segment atIndex:(NSUInteger)index animated:(BOOL)animated{
	// 1. 先讲segment插入数组
	VOSegment *willInsertSegment = nil;
	if ([segment isKindOfClass:[VOSegment class]]) {
		willInsertSegment = segment;
	}
	if ([segment isKindOfClass:[NSDictionary class]]) {
		willInsertSegment = [VOSegment segmentFromDictionary:segment];
	}
    if (willInsertSegment) {
        if (![VOSegment isValidSegment:willInsertSegment] || index >= self.segmentArray.count) {
            return;
        }
        [self.segmentArray insertObject:willInsertSegment atIndex:index];
        [self setNeedsDisplay];
    }
}

- (void)removeSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated{
	//TODO 先将segment从屏幕显示移除
	
	// 2. 先讲segment从数组删除
	if (index >= self.segmentArray.count) {
		return;
	}
	[self.segmentArray removeObjectAtIndex:index];
	[self setNeedsDisplay];
}

- (void)removeAllSegments{
	// 1. 将控件从屏幕移除
	[self removeFromSuperview];
	
	// 2. 删除所有segment
	[self.segmentArray removeAllObjects];
	
	[self setNeedsDisplay];
}

- (void)setSegment:(id)segment atIndex:(NSUInteger)index{
	// 1. 替换数组中的元素
	VOSegment *willReplaceSegment = nil;
	if ([segment isKindOfClass:[VOSegment class]]) {
		willReplaceSegment = segment;
	}
	if ([segment isKindOfClass:[NSDictionary class]]) {
		willReplaceSegment = [VOSegment segmentFromDictionary:segment];
	}
    if (willReplaceSegment) {
        if (![VOSegment isValidSegment:willReplaceSegment] || index >= self.segmentArray.count) {
            return;
        }
        [self.segmentArray replaceObjectAtIndex:index withObject:willReplaceSegment];
        
        [self setNeedsDisplay];
    }
}

- (VOSegment *)segmentAtIndex:(NSUInteger)index{
	if (index >= self.segmentArray.count) {
		return nil;
	}
	return self.segmentArray[index];
}

//TODO
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)index{
	// 设置参数
	if (index >= self.segmentArray.count) {
		return;
	}
	VOSegment *segment = self.segmentArray[index];
	segment.enabled = enabled;
}

- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index{
	if (index >= self.segmentArray.count) {
		return NO;
	}
	VOSegment *segment = self.segmentArray[index];
	return segment.enabled;
}

- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds{
	[super setBounds:bounds];
	[self setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
	[super willMoveToSuperview:newSuperview];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.segments.count > 0) {
        self.scrollLayer.frame = rect;
        self.scrollLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        // 1. 填充背景
        [self.backgroundColor setFill];
        UIRectFill(self.bounds);
        
        // 2. 移除所有sublayers
        self.scrollLayer.sublayers = nil;
        self.layer.sublayers = nil;
        
        // 3. 添加scrollLayer
        [self.layer addSublayer:self.scrollLayer];
        
        // 4. 计算segmentSize, contentSize,contentInsets, textLayer和imageLayer在当前segment中的Frame;
        CGSize segSize, contentSize;
        UIEdgeInsets contentInsets;
        [self generateSegmentSize:&segSize andContentSize:&contentSize andContentInsets:&contentInsets];
        self.segSize = segSize;
        
        // 5. 添加contentLayers
        [self.contentLayerArray removeAllObjects];
        for (NSUInteger i = 0; i < self.segmentArray.count; i ++) {
            VOSegment *segment =self.segmentArray[i];
            VOContentLayer *contentLayer = [VOContentLayer contentLayerWithFrame:CGRectMake(segSize.width * i, 0, segSize.width, segSize.height)
                                                                   contentInsets:contentInsets
                                                                         segment:segment
                                                                    contentStyle:self.contentStyle];
            contentLayer.textColor = self.textColor;
            contentLayer.selectedTextColor = self.selectedTextColor;
            contentLayer.normalBackgroundColor = self.backgroundColor;
            contentLayer.selectedbackgroundColor = self.selectedBackgroundColor;
            contentLayer.font = self.textFont;
            contentLayer.selectedFont = self.selectedTextFont;
            if (self.indicatorStyle == VOSegCtrlIndicatorStyleBox) {
                contentLayer.cornerRadius = self.indicatorCornerRadius;
            }
            [self.contentLayerArray addObject:contentLayer];
        }
        
        [self.contentLayerArray enumerateObjectsUsingBlock:^(VOContentLayer *contentLayer, NSUInteger idx, BOOL *stop) {
            [self.scrollLayer addSublayer:contentLayer];
            // 6.设置选中状态
            if (idx == self.selectedSegmentIndex) {
                [contentLayer setSelected:YES];
            }
            if (self.redPointInsetsDic[@(idx).stringValue]) {
                contentLayer.redPointInsets = [self.redPointInsetsDic[@(idx).stringValue] UIEdgeInsetsValue];
            }
            contentLayer.showRedPoint = [self.showRedPointDic[@(idx).stringValue] boolValue];
        }];
        
        self.indicatorLayer.frame = self.scrollLayer.frame;
        self.indicatorLayer.bounds = [self indicatorBounds];
        self.indicatorLayer.position = CGPointMake(self.segSize.width * self.selectedSegmentIndex + self.segSize.width / 2, [self indicatorBoundsY]);
        self.indicatorPos = self.indicatorLayer.position;
        [self.scrollLayer addSublayer:self.indicatorLayer];
        [self scrollToIndex:_selectedSegmentIndex];
    }
}

- (CGFloat)indicatorBoundsY{
	CGFloat y = 0.0;
	switch (self.indicatorStyle) {
		case VOSegCtrlIndicatorStyleTopLine:
			y = self.indicatorThickness / 2;
			break;
			
		case VOSegCtrlIndicatorStyleBottomLine:
			y = self.segSize.height - self.indicatorThickness / 2;
			break;
			
		case VOSegCtrlIndicatorStyleBox:
			y = self.segSize.height / 2;
			break;
		default:
			break;
	}
	return y;
	
}
- (CGRect)indicatorBounds{
	CGRect bounds = CGRectZero;
	switch (self.indicatorStyle) {
		case VOSegCtrlIndicatorStyleTopLine:
			bounds = CGRectMake(0, 0, self.segSize.width, self.indicatorThickness);
			break;
			
		case VOSegCtrlIndicatorStyleBottomLine:
			bounds = CGRectMake(0, self.segSize.height - self.indicatorThickness, self.segSize.width, self.indicatorThickness);
			break;
			
		case VOSegCtrlIndicatorStyleBox:
			bounds = CGRectMake(0, 0, self.segSize.width, self.segSize.height);
			
		default:
			break;
	}
	return bounds;
}

- (CGSize)getTextSize: (id)text andFont: (UIFont *)font{
	if (!text) {
		return CGSizeZero;
	}
	NSString *str = nil;
	NSDictionary *attributes = nil;
	if ([text isKindOfClass: [NSString class]]) {
		str = text;
		attributes = @{NSFontAttributeName: font};
	}
	else if([text isKindOfClass:[NSAttributedString class]])
	{
		NSAttributedString *attrStr = (NSAttributedString *)text;
		str = attrStr.string;
		NSRange range;
		attributes = [attrStr attributesAtIndex:0 effectiveRange:&range];
	}
	if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
		return [str sizeWithAttributes: attributes];
	}
	else {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
		return [str sizeWithFont:font];
#pragma clang diagnostic pop
	}
}

- (void)generateSegmentSize:(CGSize *)segSize
			 andContentSize:(CGSize *)contentSize
		   andContentInsets:(UIEdgeInsets *)contentInsets{
	// 1. 初始化
    *segSize       = CGSizeZero;
    *contentSize   = CGSizeZero;
    *contentInsets = UIEdgeInsetsZero;
	// 2. 获取contentInsets
	switch (self.indicatorStyle) {
		case VOSegCtrlIndicatorStyleBottomLine:
			contentInsets->bottom = self.indicatorThickness;
			break;
		case VOSegCtrlIndicatorStyleTopLine:
			contentInsets->top = self.indicatorThickness;
			break;
		case VOSegCtrlIndicatorStyleBox:
			contentInsets->top = contentInsets->bottom = contentInsets->left = contentInsets->right
							   = (self.indicatorCornerRadius * 0.4142 + self.indicatorThickness / 2) / 1.4142;
			break;
		default:
			break;
	}
	// 3. segment高度
	segSize->height = self.frame.size.height;
	contentSize->height = segSize->height - contentInsets->top - contentInsets->bottom;
	
	// 4. 获取文字和图片最大宽度
	CGFloat maxTextWidth = [self getMaxTextWidth];
	CGFloat maxImageWidth = [self getMaxImageWidthWithContentHeight:contentSize->height];
	// 5. content宽度, textLayerSize
	switch (self.contentStyle) {
		case VOContentStyleTextAlone:
			contentSize->width = maxTextWidth;
			break;
		case VOContentStyleImageAlone:
			contentSize->width = maxImageWidth - contentInsets->left - contentInsets->right;  //仅用于计算segment高度
			break;
		case VOContentStyleImageLeft:
			contentSize->width = maxTextWidth + contentSize->height;
			break;
		case VOContentStyleImageRight:
			contentSize->width = maxTextWidth + contentSize->height;
			break;
		case VOContentStyleImageTop:
			contentSize->width = MAX(maxTextWidth, maxImageWidth);
			break;
		case VOContentStyleImageBottom:
			contentSize->width = MAX(maxTextWidth, maxImageWidth);
			break;
		default:
			break;
	}
	// 7.segment宽度
	segSize->width = contentSize->width + contentInsets->left + contentInsets->right;
	segSize->width = MAX(segSize->width, self.frame.size.width / self.segmentArray.count);
}

- (CGFloat)getMaxTextWidth{
	CGFloat width = 0.0;
	for (VOSegment *segment in self.segmentArray) {
		CGFloat textWidth          = [self getTextSize:segment.text andFont:self.textFont].width;
		CGFloat selectedTextWidth  = [self getTextSize:((segment.selectedText)? segment.selectedText:segment.text) andFont:self.selectedTextFont].width;
		width = MAX(width, textWidth);
		width = MAX(width, selectedTextWidth);
	}
	return width + kTextPadding * 2;
}

- (CGFloat)getMaxImageWidthWithContentHeight: (CGFloat)contentHeight{
	CGFloat width = 0.0;
	CGFloat calcHeight = 0.0;
	switch (self.contentStyle) {
		case VOContentStyleImageAlone:
			calcHeight = self.frame.size.height;
			break;
		case VOContentStyleImageLeft:			// 图片在左或者右时,图片最大高度为contentHeight
		case VOContentStyleImageRight:
			calcHeight = contentHeight;
			break;
		case VOContentStyleImageTop:			// 图片在顶部或底部时,图片最大高度为contentHeight的黄金分割
		case VOContentStyleImageBottom:
			calcHeight = contentHeight * 0.618;
			break;
		default:
			break;
	}
	for (VOSegment *segment in self.segmentArray) {
		if (segment.image) {
			width = MAX(width, segment.image.size.width * calcHeight / segment.image.size.height);
		}
		if (segment.selectedImage) {
			width = MAX(width, segment.selectedImage.size.width * calcHeight / segment.selectedImage.size.height);
		}
	}
	return width;
}

#pragma mark - Index change

- (void)setSelectedSegmentIndex:(NSInteger)index {
	[self setSelectedSegmentIndex:index animated:NO notify:YES];
}

- (void)setSelectedSegmentIndex:(NSInteger)index animated:(BOOL)animated {
	[self setSelectedSegmentIndex:index animated:animated notify:YES];
}

- (void)setSelectedSegmentIndex:(NSInteger)index animated:(BOOL)animated notify:(BOOL)notify {
	if (!self.allowNoSelection && index < 0) {
		return;
	}
	if (index == VOSegmentedControlNoSegment) {
		[self.indicatorLayer removeFromSuperlayer];
	}
	else{
		[self scrollToIndex: index];
	}
	NSInteger oldIndex = _selectedSegmentIndex;
	_selectedSegmentIndex = index;
	if (notify) {
		[self notifyForSegmentChangeToIndex:index];
	}
    void(^moveIndicatorBlock)() = ^() {
        [self indicatorChangeFromIndex:oldIndex ToIndex:index animated:animated];
    };
	if (animated) {
		[CATransaction begin];
		[CATransaction setAnimationDuration:kDefaultDuration];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:moveIndicatorBlock];
	}
	VOContentLayer *oldSelectedLayer = nil;
	VOContentLayer *willSelectedLayer = nil;
    if (oldIndex == VOSegmentedControlNoSegment) {
        [self.scrollLayer addSublayer:self.indicatorLayer];
    }
	if (oldIndex != VOSegmentedControlNoSegment && self.contentLayerArray.count > oldIndex) {
		oldSelectedLayer = self.contentLayerArray[oldIndex];
		[oldSelectedLayer setSelected:NO animated:animated completion:nil];
	}
	if (index != VOSegmentedControlNoSegment && self.contentLayerArray.count > index) {
		willSelectedLayer = self.contentLayerArray[index];
		[willSelectedLayer setSelected:YES animated:animated completion:moveIndicatorBlock];
	}

    if (animated) {
        [CATransaction commit];
    }
}

- (void)scrollToIndex: (NSInteger)index {
	if (index == VOSegmentedControlNoSegment) {
		return;
	}
	CGFloat contentWidth = self.segSize.width * self.segmentArray.count;
	if (contentWidth <= self.frame.size.width) {
		return;
	}
	CGPoint scrollToOffset = CGPointZero;
	CGFloat segmentCenterX = index * self.segSize.width + self.segSize.width / 2;
	CGFloat frameHalfWidth = self.frame.size.width / 2;
	if (segmentCenterX > frameHalfWidth && segmentCenterX < contentWidth - frameHalfWidth) {
		scrollToOffset.x = segmentCenterX - frameHalfWidth;
	}
	else if(segmentCenterX >= contentWidth - frameHalfWidth){
		scrollToOffset.x = contentWidth - self.frame.size.width;
	}
	[self.scrollLayer scrollToPoint:scrollToOffset];
	self.lastPoint = scrollToOffset;
}

- (void)indicatorChangeFromIndex: (NSInteger)fromIndex ToIndex: (NSInteger)toIndex animated: (BOOL)animated{
	CGSize size = self.indicatorLayer.bounds.size;
	CGPoint fromPos = self.indicatorPos;
	CGPoint toPos = CGPointMake(size.width * toIndex + size.width / 2, [self indicatorBoundsY]);
	if (fromIndex == VOSegmentedControlNoSegment) {
		fromPos = toPos;
	}
	
	if (animated) {
		switch (self.animationType) {
			case VOSegCtrlAnimationTypeSmooth:
				[VOIndicatorAnimation smoothMoveIndicator:self.indicatorLayer fromPostion:fromPos toPosition:toPos duration:kDefaultDuration];
				break;
			case VOSegCtrlAnimationTypeBounce:
				[VOIndicatorAnimation bounceMoveIndicator:self.indicatorLayer fromPostion:fromPos toPosition:toPos duration:kDefaultDuration];
				break;
				
			default:
                [VOIndicatorAnimation smoothMoveIndicator:self.indicatorLayer fromPostion:fromPos toPosition:toPos duration:kDefaultDuration];
				break;
		}
	}
	else{
        [VOIndicatorAnimation smoothMoveIndicator:self.indicatorLayer fromPostion:fromPos toPosition:toPos duration:kDefaultDuration];
	}
	self.indicatorPos = toPos;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch  = [[event touchesForView:self] anyObject];
	self.startPoint = [touch locationInView:self];
	self.isClick    = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [[event touchesForView:self] anyObject];
	CGPoint point = [touch locationInView:self];
    CGFloat moveX = ABS(point.x - self.startPoint.x);
    CGFloat moveY = ABS(point.y - self.startPoint.y);
	if (sqrt(moveX * moveX + moveY * moveY) > 10){
		self.isClick = NO;
	}
	CGFloat leftX = 0;
	CGFloat rightX = self.segSize.width * self.segmentArray.count - self.bounds.size.width;
	CGFloat curX = self.lastPoint.x - point.x + self.startPoint.x;
	CGFloat lastX = MIN(MAX(leftX, curX), rightX);
	if (self.scrollBounce) {
		[self.scrollLayer scrollToPoint:CGPointMake(curX, 0)];
	}
	else{
		[self.scrollLayer scrollToPoint:CGPointMake(lastX, 0)];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [[event touchesForView:self] anyObject];
	CGPoint point = [touch locationInView:self];
	CGFloat leftX = 0;
	CGFloat rightX = self.segSize.width * self.segmentArray.count - self.bounds.size.width;
	CGFloat curX = self.lastPoint.x - point.x + self.startPoint.x;
	CGFloat lastX = MIN(MAX(leftX, curX), rightX);
	if (curX < leftX || curX > rightX) {
		CGFloat edgeX = (curX < leftX)? 0: rightX;
		[self.scrollLayer scrollToPoint:CGPointMake(edgeX, 0)];
	}
	self.lastPoint  = CGPointMake(lastX, 0);
	if (self.isClick ) {
		if (CGRectContainsPoint(self.bounds, point)) {
			NSInteger index = (curX + point.x) / self.segSize.width;
			if (index != self.selectedSegmentIndex) {
				[self setSelectedSegmentIndex:index animated:YES notify:YES];
			}
			else{
				[self setSelectedSegmentIndex:VOSegmentedControlNoSegment animated:YES notify:YES];
			}
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesEnded:touches withEvent:event];
}


- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
	if (self.superview)	{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		if (self.indexChangeBlock) {
			self.indexChangeBlock(index);
		}
	}
}

#pragma mark - redPoint
- (void)setInset:(UIEdgeInsets)inset forSegmentRedPointAtIndex:(NSUInteger)index{
    self.redPointInsetsDic[@(index).stringValue] = [NSValue valueWithUIEdgeInsets:inset];
    if (index < self.contentLayerArray.count) {
        VOContentLayer *contentLayer = self.contentLayerArray[index];
        contentLayer.redPointInsets = inset;
    }
}

-(void)setShow:(BOOL)show forSegmentRedPointAtIndex:(NSUInteger)index{
    self.showRedPointDic[@(index).stringValue] = @(show);
    if (index < self.contentLayerArray.count) {
        VOContentLayer *contentLayer = self.contentLayerArray[index];
        contentLayer.showRedPoint = show;
    }
}

- (BOOL)isSegmentRedPointShowAtIndex:(NSUInteger)index{
    if (index < self.contentLayerArray.count) {
        VOContentLayer *contentLayer = self.contentLayerArray[index];
        return contentLayer.showRedPoint;
    }
    return NO;
}

@end
