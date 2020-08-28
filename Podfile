platform :ios, '10.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/chat21/ios-sdk-podspecs.git'

target 'tiledesk' do
  pod 'Chat21', :path => '~/Projects/Chat/Chat21' # , '~> 0.8.26'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'Firebase/Analytics'
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
