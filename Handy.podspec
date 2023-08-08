#
# Be sure to run `pod lib lint Handy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'Handy'
  s.version          = '1.0.16'
  s.summary          = '导航栏, 主题切换 ,自定义的UI以及常用拓展'
  s.swift_version    = ['5.0']
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
  
  s.subspec 'Core' do |core|
      core.source_files   = "Sources/Handy/Core/**/*"
  end
  s.subspec 'Navigation' do |navigation|
      navigation.source_files   = "Sources/Handy/Navigation/**/*"
      navigation.dependency 'Handy/Core'
      navigation.resources = "Sources/Handy/Resources/*.{bundle}"
  end
  s.subspec 'Theme' do |theme|
      theme.source_files   = "Sources/Handy/Theme/**/*"
      theme.dependency 'Handy/Navigation'
      theme.dependency 'Handy/Core'
  end
  
  s.subspec 'Language' do |language|
      language.source_files   = "Sources/Handy/Language/**/*"
      language.dependency 'Handy/Core'
  end
  
  s.pod_target_xcconfig = {
    'CODE_SIGN_IDENTITY' => ''
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
  
end
