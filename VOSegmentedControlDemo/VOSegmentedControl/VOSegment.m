//
//  VOSegment.m
//  VOSegmentedControlDemo
//
//  Created by Valo Lee on 14-11-27.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOSegment.h"

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
	segment.text                    = segmentdic[@"text"];
	segment.selectedText            = segmentdic[@"selectedText"];
	segment.image                   = [VOSegment imageFormUIImageOrNSString:segmentdic[@"image"]];
	segment.selectedImage           = [VOSegment imageFormUIImageOrNSString:segmentdic[@"selectedImage"]];
	segment.backgroundImage         = [VOSegment imageFormUIImageOrNSString:segmentdic[@"backgroundImage"]];
	segment.selectedBackgroundImage = [VOSegment imageFormUIImageOrNSString:segmentdic[@"selectedBackgroundImage"]];
	
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
