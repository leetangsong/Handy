#
# Be sure to run `pod lib lint Handy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

class MyCode
def recursionDirCreateSubSpace(path1,space)
    ignore = ['.','..','.DS_Store']
 
    Dir.foreach(path1) do |file|
        
        # p file  # 打印所有的file，需要忽略掉你不需要的
        if ignore.include?(file) && file.length > 0
            next
        end
        
        tmpPath = "#{path1}/#{file}"
        # p tmpPath # 打印合理的路径，检测是否有不合理的记得过滤
        if File::ftype(tmpPath) == "directory"
            space.subspec file do |tmpS|
                tmpS.source_files = "#{tmpPath}/*"
                recursionDirCreateSubSpace(tmpPath,tmpS)
            end
        end
    end
end

Pod::Spec.new do |s|
  s.name             = 'Handy'
  s.version          = '1.0.4'
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
  
  s.resource_bundles = {
    'Handy' => ['Handy/Assets/*']
  }
  s.pod_target_xcconfig = {
    'CODE_SIGN_IDENTITY' => ''
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
  MyCode.new.recursionDirCreateSubSpace("Handy/Classes",s)
  end
end
