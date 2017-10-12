#
# Be sure to run `pod lib lint TwoLevelCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TwoLevelCache'
  s.version          = '0.1.0'
  s.summary          = 'Customizable two-level cache for iOS (Swift).'
  s.description      = <<-DESC
Customizable two-level cache for iOS (Swift). Level 1 is memory powered by NSCache and level 2 is filesystem which uses NSCachesDirectory.
All cache data are managed by OS level. Then you don't have to consider the number of objects and the usage of memory or storage.
                       DESC

  s.homepage         = 'https://github.com/ysawa/TwoLevelCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yoshihiro Sawa' => 'yoshihirosawa@gmail.com' }
  s.source           = { :git => 'https://github.com/ysawa/TwoLevelCache.git', :tag => s.version.to_s }
  s.social_media_url      = "https://twitter.com/yoshiiiine"

  s.ios.deployment_target = '8.0'

  s.source_files = 'TwoLevelCache/Classes/**/*'
  # s.resource_bundles = {
  #   'TwoLevelCache' => ['TwoLevelCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
