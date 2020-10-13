Pod::Spec.new do |s|
  s.name          = "LoyaltyStation"
  s.version       = "4.1.1"
  s.summary       = "Loyalty Station"
  s.description   = "Loyalty Station SDK"
  s.homepage      = "https://github.com/gamiphy/loyalty-station-ios-sdk.git"
  s.license       = "MIT"
  s.author        = "Riyad Yahya"
  s.platform      = :ios, "9.0"
  s.swift_version = "4.2"
  s.source        = {
    :git => "https://github.com/gamiphy/loyalty-station-ios-sdk.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "GamiAppi/**/*.{h,m,swift}"
  s.public_header_files = "GamiAppi/**/*.h"
  s.resources                 = [
    "GamiAppi/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    ]
end