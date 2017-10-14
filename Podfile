platform :ios, '9.0'

target 'HNotes-ios' do
  use_frameworks!

  # Pods for HNotes-ios

  #Camera
  pod 'ImagePicker'

  #DB
  pod 'RealmSwift'

  #HTTP request handling
  pod 'Alamofire'

  #Facebook sdk
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  #json parsing
  pod 'SwiftyJSON'
  
  #popup
  pod 'SwiftMessages'
  
  #Google login
  pod 'GoogleSignIn'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'ImagePicker'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.1'
            end
        end
    end
end
