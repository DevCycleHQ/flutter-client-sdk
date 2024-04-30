#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint devcycle_flutter_client_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'devcycle_flutter_client_sdk'
  s.version          = '1.8.3'
  s.summary          = 'DevCycle Flutter Client SDK plugin project.'
  s.description      = <<-DESC
A Flutter plugin to integrate with DevCycle Feature Flags.
                       DESC
  s.homepage         = 'https://devcycle.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DevCycle' => 'support@devcycle.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'DevCycle', '1.17.1'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
