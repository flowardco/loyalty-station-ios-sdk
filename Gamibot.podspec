Pod::Spec.new do |s|
  s.name          = "Gamibot"
  s.version       = "2.0.3"
  s.summary       = "Gamibot"
  s.description   = "Gamibot, is the loyality program that provide gamified user journey, with rewarding system, where users can get points by doing certine actions. and they can be rewarded for doing these actions."
  s.homepage      = "https://bitbucket.org/gamiphy/ios-gamiphy-sdk.git"
  s.license       = "MIT"
  s.author        = { "Gamiphy" => "support@gamiphy.co" }
  s.platform      = :ios, "9.0"
  s.swift_version = "4.2"
  s.source        = {
    :git => "https://bitbucket.org/gamiphy/ios-gamiphy-sdk.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "GamiAppi/**/*.{h,m,swift}"
  s.public_header_files = "GamiAppi/**/*.h"
  s.resources                 = [
    "GamiAppi/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    ]

end
