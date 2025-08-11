Pod::Spec.new do |spec|
  spec.name         = "KlikIDM_DS"
  spec.version      = "0.1.6"
  spec.summary      = "UI Components and Animation"
  spec.description  = "UI Components and Animation of Klik Indomaret Apps"
  
  spec.homepage     = "https://github.com/rghinnaa-edts/KlikIDM_DS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rizka Ghinna" => "rizka.ghinna@sg-dsa.com" }
  
  spec.platform     = :ios, "12.0"
  spec.swift_version = "5.0"
  
  spec.source       = { :git => "https://github.com/rghinnaa-edts/KlikIDM_DS.git", :tag => spec.version.to_s }
  spec.source_files = "KlikIDM_DS/**/*.{h,m,swift}"
  spec.resources    = "KlikIDM_DS/**/*.{xib,storyboard,xcassets,png,jpg,jpeg}"
  
  spec.framework    = "UIKit"
end

