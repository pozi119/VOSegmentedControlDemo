//
//  VOContentLayer.m
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-27.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOContentLayer.h"
#define kTextImagePadding 8

@interface VOContentLayer ()

@property (nonatomic, strong) CATextLayer    *textLayer;
@property (nonatomic, strong) CATextLayer    *selectedTextLayer;
@property (nonatomic, strong) CALayer        *imageLayer;
@property (nonatomic, strong) CALayer        *selectedImageLayer;
@property (nonatomic, assign) VOContentStyle contentStyle;
@property (nonatomic, assign) UIEdgeInsets   contentInsets;

@end

@implementation VOContentLayer

+ (instancetype)contentLayerWithFrame:(CGRect)frame
						contentInsets:(UIEdgeInsets)insets
							  segment:(VOSegment *)segment
						 contentStyle:(VOContentStyle)style{
    VOContentLayer *contentLayer            = [VOContentLayer layer];
    contentLayer.frame                      = frame;
	contentLayer.contentInsets              = insets;
    contentLayer.font                       = [UIFont systemFontOfSize:17];
    contentLayer.selectedFont               = contentLayer.font;
    contentLayer.textColor                  = [UIColor darkTextColor];
    contentLayer.selectedTextColor          = contentLayer.textColor;
    contentLayer.normalBackgroundColor      = [UIColor clearColor];
    contentLayer.selectedbackgroundColor    = contentLayer.normalBackgroundColor;
    contentLayer.backgroundColor            = contentLayer.normalBackgroundColor.CGColor;

    contentLayer.contentStyle               = style;
    contentLayer.segment                    = segment;
    contentLayer.clung                      = YES;
	return contentLayer;
}

- (CATextLayer *)textLayer{
	if (!_textLayer) {
		if (self.segment.text) {
			CATextLayer *textLayer    = [CATextLayer layer];
			textLayer.frame           = [self textLayerFrameForSegment:self.segment.text andFont:self.font];
			textLayer.backgroundColor = [UIColor clearColor].CGColor;
			textLayer.font            = (__bridge CFTypeRef)self.font.fontName;
			textLayer.fontSize        = self.font.pointSize;
			textLayer.foregroundColor = self.textColor.CGColor;
			textLayer.string          = self.segment.text;
            textLayer.contentsScale   = [UIScreen mainScreen].scale;
			_textLayer                = textLayer;
			[self addSublayer:_textLayer];
		}
	}
	return _textLayer;
}

- (CATextLayer *)selectedTextLayer{
	if (!_selectedTextLayer) {
		if (self.segment.selectedText) {
			CATextLayer *selectedTextLayer    = [CATextLayer layer];
			selectedTextLayer.frame           = [self textLayerFrameForSegment:self.segment.selectedText andFont:self.selectedFont];
			selectedTextLayer.backgroundColor = [UIColor clearColor].CGColor;
			selectedTextLayer.font            = (__bridge CFTypeRef)self.selectedFont.fontName;
			selectedTextLayer.fontSize        = self.selectedFont.pointSize;
			selectedTextLayer.foregroundColor = self.selectedTextColor.CGColor;
			selectedTextLayer.string          = self.segment.selectedText;
            selectedTextLayer.contentsScale   = [UIScreen mainScreen].scale;
			_selectedTextLayer                = selectedTextLayer;
			[self addSublayer:selectedTextLayer];
		}
	}
	return _selectedTextLayer;
}

- (CALayer *)imageLayer{
	if (!_imageLayer) {
		if (self.segment.image) {
			CALayer *imageLayer = [CALayer layer];
			imageLayer.frame    = [self imageLayerFrameForImage:self.segment.image];
			imageLayer.contents = (id)self.segment.image.CGImage;
			_imageLayer         = imageLayer;
			[self addSublayer:imageLayer];
		}
	}
	return _imageLayer;
}

- (CALayer *)selectedImageLayer{
	if (!_selectedImageLayer) {
		if (self.segment.image) {
			CALayer *selectedImageLayer = [CALayer layer];
			selectedImageLayer.frame    = [self imageLayerFrameForImage:self.segment.selectedImage];
			selectedImageLayer.contents = (id)self.segment.selectedImage.CGImage;
			_selectedImageLayer         = selectedImageLayer;
			[self addSublayer:selectedImageLayer];
		}
	}
	return _selectedImageLayer;
}

- (void)setSegment:(VOSegment *)segment{
	_segment = segment;
	if (!_segment.selectedText) {
		_segment.selectedText = _segment.text;
	}
	if (!_segment.selectedImage) {
		_segment.selectedImage = _segment.image;
	}
}

- (void)layoutSublayers{
	[super layoutSublayers];
	[self setSelected:_selected];
}

- (void)setSelected:(BOOL)selected{
	[self setSelected:selected animated:NO completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated completion: (void (^)())completion{
	_selected = selected;

	if (animated) {
		[CATransaction begin];
		[CATransaction setDisableActions:NO];
		[CATransaction setAnimationDuration: kContentAnimationDuration];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		if (completion) {
			[CATransaction setCompletionBlock:completion];
		}
	}
	
	if (selected) {
		self.backgroundColor = self.selectedbackgroundColor.CGColor;
		if(self.textLayer)			self.textLayer.opacity          = 0.0;
		if(self.selectedTextLayer)	self.selectedTextLayer.opacity  = 1.0;
		if(self.imageLayer)			self.imageLayer.opacity         = 0.0;
		if(self.selectedImageLayer) self.selectedImageLayer.opacity = 1.0;
	}
	else{
		self.backgroundColor = self.normalBackgroundColor.CGColor;
		if(self.textLayer)			self.textLayer.opacity          = 1.0;
		if(self.selectedTextLayer)	self.selectedTextLayer.opacity  = 0.0;
		if(self.imageLayer)			self.imageLayer.opacity         = 1.0;
		if(self.selectedImageLayer) self.selectedImageLayer.opacity = 0.0;
	}
	if (animated) {
		[CATransaction commit];
	}
	else{
		if (completion) {
			completion();
		}
	}
}

// 计算textLayer显示时的frame
- (CGRect)textLayerFrameForSegment: (id)text andFont: (UIFont *)font{
	CGSize textSize = [self getTextSize:text andFont: font];
	CGRect contentRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
	CGSize size = contentRect.size;
	CGRect frame = CGRectZero;
    if (self.clung) {
        switch (self.contentStyle) {
            case VOContentStyleTextAlone:
                frame = CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageLeft:
                frame = CGRectMake(size.height + kTextImagePadding, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageRight:
                frame = CGRectMake(size.width - size.height - textSize.width - kTextImagePadding, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageTop:
                frame = CGRectMake((size.width - textSize.width) / 2, size.height * 0.618 + kTextImagePadding, textSize.width, textSize.height);
                break;
            case VOContentStyleImageBottom:
                frame = CGRectMake((size.width - textSize.width) / 2, size.height * 0.382 - textSize.height - kTextImagePadding, textSize.width, textSize.height);
                break;
            default:
                break;
        }
    }
    else{
        switch (self.contentStyle) {
            case VOContentStyleTextAlone:
                frame = CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageLeft:
                frame = CGRectMake(size.height + (size.width - size.height - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageRight:
                frame = CGRectMake((size.width - size.height - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageTop:
                frame = CGRectMake((size.width - textSize.width) / 2, size.height * 0.618 + (size.height * 0.382 - textSize.height) / 2, textSize.width, textSize.height);
                break;
            case VOContentStyleImageBottom:
                frame = CGRectMake((size.width - textSize.width) / 2, (size.height * 0.382 - textSize.height) / 2, textSize.width, textSize.height);
                break;
            default:
                break;
        }
    }
	frame = CGRectOffset(frame, self.contentInsets.left, self.contentInsets.top);
	return frame;
}

//计算imageLayer显示的frame
- (CGRect)imageLayerFrameForImage: (UIImage *)image{
	if (!image) {
		return CGRectZero;
	}
    CGSize maxImageSize = CGSizeZero;
    CGSize size         = self.bounds.size;
    CGSize imageSize    = image.size;
    CGRect frame        = CGRectZero;

	switch (self.contentStyle) {
		case VOContentStyleImageLeft:
		case VOContentStyleImageRight:
			maxImageSize = CGSizeMake(size.height, size.height);
			break;
		case VOContentStyleImageTop:
		case VOContentStyleImageBottom:
			maxImageSize = CGSizeMake(size.width, size.height * 0.618);
			break;
			
		case VOContentStyleImageAlone:
			maxImageSize = self.bounds.size;
			break;
			
		default:
			return CGRectZero;
	}
	
    CGSize showSize      = CGSizeZero;
    CGFloat imageRatio   = imageSize.width / imageSize.height;
    CGFloat maxSizeRatio = maxImageSize.width / maxImageSize.height;
	if (imageRatio >= maxSizeRatio && imageSize.width >= maxImageSize.width) {
        showSize.width  = maxImageSize.width;
        showSize.height = imageSize.height * maxImageSize.width/imageSize.width;
	}
	else if(imageRatio < maxSizeRatio && imageSize.height >= maxImageSize.height){
        showSize.width  = imageSize.width * maxImageSize.height/imageSize.height;
        showSize.height = maxImageSize.height;
	}
	else{
        showSize.width  = imageSize.width;
        showSize.height = imageSize.height;
	}
    if (self.clung && showSize.width >= imageSize.width && showSize.height >= imageSize.height) {
        showSize = imageSize;
        switch (self.contentStyle) {
            case VOContentStyleImageRight:
                frame.origin.x = self.bounds.size.width - maxImageSize.width;
                frame.origin.y = (maxImageSize.height - showSize.height) / 2.0;
                break;
                
            case VOContentStyleImageTop:
                frame.origin.x = (maxImageSize.width - showSize.width) / 2.0;
                frame.origin.y = maxImageSize.height - showSize.height;
                break;
                
            case VOContentStyleImageBottom:
                frame.origin.x = (maxImageSize.width - showSize.width) / 2.0;
                frame.origin.y = self.bounds.size.height - maxImageSize.height;
                break;
                
            default:
                frame.origin.x = maxImageSize.width - showSize.width;
                frame.origin.y = (maxImageSize.height - showSize.height) / 2.0;
                break;
        }
        frame.size = showSize;
    }
    else{
        frame.origin.x = (maxImageSize.width - showSize.width) / 2.0;
        frame.origin.y = (maxImageSize.height - showSize.height) / 2.0;
        frame.size = showSize;
        if (self.contentStyle == VOContentStyleImageRight) {
            frame.origin.x += self.bounds.size.width - maxImageSize.width;
        }
        if (self.contentStyle == VOContentStyleImageBottom) {
            frame.origin.y += self.bounds.size.height - maxImageSize.height;
        }
    }
	return frame;
}

- (CGSize)getTextSize: (id)text andFont: (UIFont *)font{
	if (!text) {
		return CGSizeZero;
	}
    NSString *str            = nil;
    NSDictionary *attributes = nil;
	if ([text isKindOfClass: [NSString class]]) {
        str        = text;
        attributes = @{NSFontAttributeName: font};
	}
	else if([text isKindOfClass:[NSAttributedString class]])
	{
		NSRange range;
        NSAttributedString *attrStr = (NSAttributedString *)text;
        str                         = attrStr.string;
        attributes                  = [attrStr attributesAtIndex:0 effectiveRange:&range];
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


@end
