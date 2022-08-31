#
# Be sure to run `pod lib lint Core.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'Core'
  spec.version          = '0.1.0'
  spec.summary          = 'A short description of Core.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  spec.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  spec.homepage         = 'https://github.com/thomaszeiter/Core'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'thomaszeiter' => 'thomaszeitertz@gmail.com' }
  spec.source           = { :git => 'https://github.com/thomaszeiter/Core.git', :tag => spec.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  spec.swift_version    = '5.0'
  spec.ios.deployment_target = '14.0'

  spec.source_files = 'Core/Classes/**/*'

  spec.frameworks = 'UIKit'
  spec.ios.dependency 'Alamofire'
  spec.ios.dependency 'Highlightr'
  spec.ios.dependency 'SnapKit'

  # s.resource_bundles = {
  #   'CoreServices' => ['Core/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
end
