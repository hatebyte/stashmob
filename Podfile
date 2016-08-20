source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'GooglePlacePicker', '= 2.0.1'
    pod 'GooglePlaces', '= 2.0.1'
    pod 'GoogleMaps', '= 2.0.1'
    pod 'CryptoSwift'

end

target 'StashMob' do
  shared_pods
end


target 'StashMobTests' do
  shared_pods
  
end



post_install do |installer|
    ignore_overriding_contains_swift(installer, 'StashMob')
end

def ignore_overriding_contains_swift(installer, framework_target)
    target = installer.aggregate_targets.find{|t| t.name == "Pods-#{framework_target}"}
    raise "failed to find #{framework_target} among: #{installer.aggregate_targets}" unless target
    target.xcconfigs.each_value do |config|
        config.attributes.delete('EMBEDDED_CONTENT_CONTAINS_SWIFT')
    end
end