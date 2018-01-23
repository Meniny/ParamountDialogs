Pod::Spec.new do |s|
  s.name             = "ParamountDialogs"
  s.version          = "2.0.0"
  s.summary          = "A delightful dialog view for iOS in Swift"
  s.description      = <<-DESC
                        ParamountDialogs is a delightful dialog view for iOS in Swift"
                        DESC
  s.homepage         = "https://github.com/Meniny/ParamountDialogs"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/ParamountDialogs.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'
  s.swift_version    = "4.0"
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => s.swift_version.to_s }
  s.source_files = 'ParamountDialogs/**/*{.swift}'#, 'ParamountDialogs/ParamountDialogs.h'
  s.frameworks       = 'Foundation', 'UIKit'
  s.dependency          "PresentationSettings"
  s.dependency          "Kingfisher"
  s.dependency          "JustLayout"
  s.dependency          "SystemSounds"
end
