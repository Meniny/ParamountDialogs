
Pod::Spec.new do |s|
  s.name             = "ParamountDialogs"
  s.version          = "1.3.0"
  s.summary          = "A delightful dialog view for iOS in Swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        ParamountDialogs is a delightful dialog view for iOS in Swift"
                        DESC

  s.homepage         = "https://github.com/Meniny/ParamountDialogs"
  s.license          = 'MIT'
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/ParamountDialogs.git", :tag => s.version.to_s }
  s.social_media_url = 'http://meniny.cn/'

  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

  s.source_files = 'ParamountDialogs/**/*{.swift}'#, 'ParamountDialogs/ParamountDialogs.h'
  # s.public_header_files = 'ParamountDialogs/ParamountDialogs.h'
  # s.resources = 'ParamountDialogs/Resources/ParamountDialogs.bundle'
  s.frameworks = 'Foundation', 'UIKit'
  # s.dependency "Hue"
  s.dependency "Kingfisher"
  s.dependency "JustLayout"
  s.dependency "SystemSounds"
end
