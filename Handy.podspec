#
# Be sure to run `pod lib lint Handy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Handy'
  s.version          = '1.0.2'
  s.summary          = '导航栏, 主题切换 ,自定义的UI以及常用拓展'
  s.swift_version    = ['5.0']
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  自定义导航栏(那内含微信样式)，主题切换（可设置跟随系统）以及一些自定义的UI以及常用拓展
                       DESC

  s.homepage         = 'https://github.com/leetangsong/Handy'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leetangsong' => 'leetangsong@icloud.com' }
  s.source           = { :git => 'https://github.com/leetangsong/Handy.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Handy/Classes/**/*'
  
  s.resource_bundles = {
    'Handy' => ['Handy/Assets/*']
  }
  s.pod_target_xcconfig = {
    'CODE_SIGN_IDENTITY' => ''
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
end
