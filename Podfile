
# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'
target 'Elken' do
    
    pod 'RxAlamofire'
    pod 'ObjectMapper'
    pod 'SwiftyJSON'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'CocoaLumberjack/Swift'
    
    pod 'ReachabilitySwift'
    pod 'AlamofireImage'
    pod 'SwiftyJSON'
    pod 'RealmSwift'
    pod 'IQKeyboardManagerSwift'
    pod 'NSDate+TimeAgo'
    pod 'SnapKit', '~> 3.2.0'
    
    pod 'CT_RESTAPI', :path => 'LocalPods/CT_RESTAPI/'
    pod 'CT_UILib', :path => 'LocalPods/CT_UILib/'
    
end



post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
        
        # -------------------------------------------
        # Update swift flags for development pods: DEBUG, STAGING, RELEASE
        
        target.build_configurations.each do |config|
            if config.name.start_with?("Debug") then
                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-DDEBUG']
                elsif config.name.start_with?("Staging") then
                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-DSTAGING']
                elsif config.name.start_with?("Release") then
                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-DRELEASE']
            end
        end
        # -------------------------------------------
        
    end
    
end
