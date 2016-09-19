# Uncomment this line to define a global platform for your project
platform :ios, '8.1'
use_frameworks!

target 'Sandvik 365' do
    # Use specific PR until merged to master to support Swift 3
    pod 'NibDesignable', git: 'https://github.com/sstadelman/NibDesignable.git', branch: 'master', :submodules => true
  pod 'AHEasing'
  pod 'CryptoSwift'
  pod 'Fuzi', '~> 1.0.0'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end

target 'Sandvik 365Tests' do
    # Use specific PR until merged to master to support Swift 3
    pod 'NibDesignable', git: 'https://github.com/sstadelman/NibDesignable.git', branch: 'master', :submodules => true
    pod 'AHEasing'
    pod 'CryptoSwift'
    pod 'Fuzi', '~> 1.0.0'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end

end

