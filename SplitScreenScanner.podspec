#
# Be sure to run `pod lib lint SplitScreenScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SplitScreenScanner'
  s.version          = '10.0.3'
  s.summary          = 'Swift library for scanning barcodes with half the screen devoted to scan history'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Framework for scanning and verifying multiple barcodes, for example, in logistics applications.
                       DESC

  s.homepage         = 'https://github.com/clutter/SplitScreenScanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sean Machen' => 'sean.machen@clutter.com' }
  s.source           = { :git => 'https://github.com/clutter/SplitScreenScanner.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_versions = ['5.0']

  s.source_files = 'Sources/SplitScreenScanner/Classes/**/*'

  s.resource_bundles = {
      'SplitScreenScanner_SplitScreenScanner' => ['Sources/SplitScreenScanner/Assets/**/*.{xib,storyboard}']
  }

  s.dependency 'Sections'
end
