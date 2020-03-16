Pod::Spec.new do |s|
  s.name          = "GamiAppi"
  s.version       = "0.0.1"
  s.summary       = "iOS-Gami-Appi SDK for Hello World"
  s.description   = "iOS-Gami-Appi for Hello World, including example app"
  s.homepage      = "https://github.com/Abdallah4021/GamiAppi.git"
  s.license       = "MIT"
  s.author        = "Abdallah"
  s.platform      = :ios, "9.0"
  s.swift_version = "4.2"
  s.source        = {
    :git => "https://github.com/abdallah4021/GamiAppi.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "GamiAppi/**/*.{h,m,swift}"
  s.public_header_files = "GamiAppi/**/*.h"
  s.resources                 = [
    "GamiAppi/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    ]
end
