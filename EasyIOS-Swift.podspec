#
# Be sure to run `pod lib lint EasyIOS-Swift.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EasyIOS-Swift"
  s.version          = "2.0.1"
  s.summary          = "The Swift version of EasyIOS"
  s.description      = <<-DESC
                      EasyIOS is a new generation of development framework based on `Model-View-ViewModel`,`HTML To Native`,`Live Load`,`FlexBox`.
                       DESC
  s.homepage         = "https://github.com/EasyIOS/EasyIOS-Swift"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "zhuchao" => "zhuchao@iosx.me" }
  s.source           = { :git => "https://github.com/EasyIOS/EasyIOS-Swift.git", :tag => s.version.to_s }
  #s.source           = { :git => "/Users/zhuchao/Documents/EasyIOS-Swift"}
  s.social_media_url = 'https://twitter.com/zhuchaowe'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.module_name = "EasyIOS"
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {'EasyIOS-Swift' => ['Pod/Assets/*.png']}
    s.dependency 'HanekeSwift'
    s.dependency 'Bond'
    s.dependency 'Alamofire'
    s.dependency 'SnapKit'
    s.dependency 'Kingfisher'
    s.dependency 'ObjectMapper'
    s.dependency 'ReachabilitySwift'
    s.dependency 'TTTAttributedLabel'
s.public_header_files = 'Pod/Classes/Easy/**/*.h','Pod/Classes/Extend/**/*.h','Pod/Classes/Private/**/*.h'
s.frameworks = 'UIKit','JavaScriptCore'
end
