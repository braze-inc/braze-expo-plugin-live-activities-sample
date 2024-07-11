Pod::Spec.new do |s|
  s.name           = 'LiveActivityExample'
  s.version        = '1.0.0'
  s.summary        = 'A sample Braze Live Activities integration'
  s.description    = 'A sample Braze Live Activities integration'
  s.author         = 'Braze, Inc.'
  s.homepage       = 'https://docs.expo.dev/modules/'
  s.platforms      = { :ios => '13.4', :tvos => '13.4' }
  s.source         = { git: '' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  # Required to send Live Activity payloads to the backend
  s.dependency 'BrazeKit'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }

  s.source_files = "**/*.{h,m,mm,swift,hpp,cpp}"
end
