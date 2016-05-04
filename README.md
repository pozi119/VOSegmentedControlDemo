# VOSegmentedControl
[![License Apache](http://img.shields.io/cocoapods/l/VOSegmentedControlDemo.svg?style=flat)](https://raw.githubusercontent.com/pozi119/VOSegmentedControlDemo/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/VOSegmentedControlDemo.svg?style=flat)](http://cocoapods.org/?q=VOSegmentedControlDemo)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/VOSegmentedControlDemo.svg?style=flat)](http://cocoapods.org/?q=VOSegmentedControlDemo)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/pozi119/VOSegmentedControlDemo.svg?branch=master)](https://travis-ci.org/pozi119/VOSegmentedControlDemo)

#更新
2016.5.4 添加cocoapods支持

#使用说明
1. 支持图片和文字,包含6种简单排版: 只有文字, 只有图片, 图片在上下左右
     只有图片时,图片如果比分段大,则只铺满整个分段,若比分段小,则为图片大小居中
    图片在左,右时,图片层为正方形, 最大边长是分段的高度,
    图片在顶部或者底部时, 图片的最大高度为 分段高度 x 0.618
  
2. 指示器支持3种类型: 顶部线条,底部线条,方框; 可设置indicatorThickness和indicatorCornerRadius 变为圆角指示器, 当indicatorThickness = 0时, 指示器不显示

3. 指示器移动效果: 平滑移动,弹簧效果.

4. 可设置选中/未选中时文字的字体, 颜色

5. 可设置选中时的背景色,如果指示器设置成圆角的,背景也变成圆角

6. 可设置不选择任何分段

7. 指示器移动效果可以自己写: 在VOIndicatorAnimation中加相应的方法

8. 可再Storyboard中添加UIView,更改对应的Class为VOSegmentControl,在storyboard中添加keypath设置对应参数(枚举变量设置对应的NSNumber值).代码中只用设置分段内容如:

    self.segmentControl5.segments = @[@{VOSegmentText: @"A", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"B", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"C", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"D", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"E", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"F", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"G", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"H", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"},
                                      @{VOSegmentText: @"I", VOSegmentImage: @"open", VOSegmentSelectedImage: @"close"}];
                                      
