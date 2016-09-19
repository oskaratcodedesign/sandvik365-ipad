# Uncomment this line to define a global platform for your project
platform :ios, '8.1'
use_frameworks!

target 'Sandvik 365' do
  pod 'NibDesignable'
  pod 'AHEasing'
  pod 'CryptoSwift'
  pod 'AsyncSwift'
  pod 'Fuzi', '~> 0.2.0'
end

target 'Sandvik 365Tests' do
    pod 'NibDesignable'
    pod 'AHEasing'
    pod 'CryptoSwift'
    pod 'AsyncSwift'
    pod 'Fuzi', '~> 0.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
