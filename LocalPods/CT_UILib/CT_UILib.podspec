Pod::Spec.new do |spec|
  spec.name         = 'CT_UILib'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'BSD' }  
  spec.authors      = { 'Canh Tran' => 'hoangcanhsek6@gmail.com' }
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "8.0"
  spec.summary      = 'Common files'  
  spec.source_files = '**/*.{swift}'
  spec.homepage     = 'bitbucket.org/hoangcanhsek6'
  spec.source       = { :path => 'LocalPods/CT_UILib' }

  spec.requires_arc = true
  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  
  spec.dependency 'SnapKit', '~> 3.2.0'
  spec.dependency 'RxSwift'
  spec.dependency 'CocoaLumberjack/Swift'
  spec.ios.frameworks = 'CoreGraphics', 'UIKit'
end
