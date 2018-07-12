#
# Be sure to run `pod lib lint SplitScreenScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SplitScreenScanner'
  s.version          = '4.0.0'
  s.summary          = 'Swift library for scanning barcodes with half the screen devoted to scan history'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/clutter/SplitScreenScanner'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sean Machen' => 'sean.machen@clutter.com' }
  s.source           = { :git => 'https://github.com/clutter/SplitScreenScanner.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.1'

  s.source_files = 'SplitScreenScanner/Classes/**/*'

  s.resource_bundles = {
      'SplitScreenScanner' => ['SplitScreenScanner/Assets/**/*.{xib,storyboard}']
  }

  s.dependency 'Sections'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
