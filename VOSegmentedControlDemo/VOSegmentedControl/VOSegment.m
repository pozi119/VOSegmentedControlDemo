//
//  VOSegment.m
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-27.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOSegment.h"

NSString const *VOSegmentText = @"text";
NSString const *VOSegmentSelectedText = @"selectedText";
NSString const *VOSegmentImage = @"image";
NSString const *VOSegmentSelectedImage = @"selectedImage";
NSString const *VOSegmentBackgroundImage = @"backgroundImage";
NSString const *VOSegmentSelectedBackgroundImage = @"selectedBackgroundImage";


@implementation VOSegment

+ (UIImage *)imageFormUIImageOrNSString: (id)image{
	if ([image isKindOfClass:[UIImage class]]) {
		return image;
	}
	else if([image isKindOfClass:[NSString class]]){
		return [UIImage imageNamed:image];
	}
	else{
		return nil;
	}
}

+ (instancetype)segmentFromDictionary:(NSDictionary *)segmentdic{
	VOSegment *segment = [[VOSegment alloc] init];
	segment.text                    = segmentdic[VOSegmentText];
	segment.selectedText            = segmentdic[VOSegmentSelectedText];
	segment.image                   = [VOSegment imageFormUIImageOrNSString:segmentdic[VOSegmentImage]];
	segment.selectedImage           = [VOSegment imageFormUIImageOrNSString:segmentdic[VOSegmentSelectedImage]];
	segment.backgroundImage         = [VOSegment imageFormUIImageOrNSString:segmentdic[VOSegmentBackgroundImage]];
	segment.selectedBackgroundImage = [VOSegment imageFormUIImageOrNSString:segmentdic[VOSegmentSelectedBackgroundImage]];
	
	if (segmentdic[@"enabled"]) {
		segment.enabled             = [segmentdic[@"enabled"] boolValue];
	}
	else{
		segment.enabled             = YES;    //默认启用
	}
	return segment;
}

+ (BOOL)isValidSegment: (VOSegment *)segment{
	return (segment.text || segment.image);
}

@end
