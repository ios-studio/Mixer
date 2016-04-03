Pod::Spec.new do |s|
  s.name         = "Mixer"
  s.version      = "0.1.1"
  s.summary      = "A tiny library helping to centralize color definitions"
  s.homepage     = "https://github.com/ios-studio/Mixer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Beat Richartz" => "beat.richartz@gmail.com" }
  s.source       = { :git => "https://github.com/ios-studio/Mixer.git", :tag => s.version }

  s.ios.deployment_target = "8.0"

  s.source_files = "Mixer/**/*.swift"
  s.requires_arc = true
end
