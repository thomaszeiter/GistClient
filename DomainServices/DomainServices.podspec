#
# Be sure to run `pod lib lint DomainServices.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'DomainServices'
  spec.version          = '0.1.0'
  spec.summary          = 'A short description of DomainServices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  spec.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  spec.homepage         = 'https://github.com/thomaszeiter/DomainServices'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'thomaszeiter' => 'thomaszeitertz@gmail.com' }
  spec.source           = { :git => 'https://github.com/thomaszeiter/DomainServices.git', :tag => spec.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  spec.swift_version    = '5.0'
  spec.ios.deployment_target = '14.0'

  spec.source_files = 'DomainServices/Classes/**/*'
  spec.dependency 'Core'
  spec.frameworks = 'UIKit'
  
  # s.resource_bundles = {
  #   'DomainServices' => ['DomainServices/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
