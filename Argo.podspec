Pod::Spec.new do |spec|
  spec.name = 'Argo'
  spec.version = '0.2.2'
  spec.summary = 'Functional JSON parsing library for Swift.'
  spec.homepage = 'https://github.com/thoughtbot/Argo'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = {
    'Gordon Fontenot' => 'gordon@thoughtbot.com',
    'Tony DiPasquale' => 'tony@thoughtbot.com',
    'thoughtbot' => nil,
  }
  spec.social_media_url = 'http://twitter.com/thoughtbot'
  spec.source = { :git => 'https://github.com/thoughtbot/Argo.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Argo/**/*.{h,swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
end

