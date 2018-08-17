#
# Be sure to run `pod lib lint NicooTableListViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NicooTableListViewController'
  s.version          = '0.1.1'
  s.summary          = 'edit + headeRefresh,footerRefresh  tableList'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    table list baseVC, delegate for edit , andRefresh, noDataViewShow.
                       DESC

  s.homepage         = 'https://github.com/yangxina/NicooTableListView.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangxina' => '504672006@qq.com' }
  s.source           = { :git => 'https://github.com/yangxina/NicooTableListView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NicooTableListViewController/Classes/**/*'
  

s.resource_bundles = {
     'NicooTableListViewController' => ['NicooTableListViewController/Assets/*.png']
}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'MJRefresh' , '~> 3.1.0'

s.dependency 'SnapKit'    , '~> 4.0'
end
