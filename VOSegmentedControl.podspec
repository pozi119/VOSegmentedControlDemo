Pod::Spec.new do |s|
  s.name         = "VOSegmentedControl"
  s.version      = "1.0.0"
  s.summary      = "A segmented control with multi styles"
  s.homepage     = "https://github.com/pozi119/VOSegmentedControlDemo"
  s.license      = "GPL V2.0"
  s.author       = { "pozi119" => "pozi119@163.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/pozi119/VOSegmentedControlDemo.git", :tag => "1.0.0" }
  s.source_files  = "VOSegmentedControlDemo/VOSegmentedControl", "VOSegmentedControlDemo/VOSegmentedControl/*.{h,m}"
end
