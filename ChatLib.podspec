Pod::Spec.new do |spec|
  spec.name = "ChatLib"
  spec.version = "2.0.1"
  spec.summary = "ChatLib iOS Client"
  spec.description = "This is Chat description"

  spec.homepage = "https://github.com/ssagarShinde/ColabChat.git"
  spec.license = { :type => "Apache License", :file => "license" }
  spec.author = { "Sagar" => "s.dshinde13@gmail.com" }
  spec.swift_version = "5"

  spec.ios.deployment_target  = '12.0'

  spec.source           = { :http => 'https://www.dropbox.com/s/7vc5alhrsoer3mu/ChatLib.zip?dl=1' }
  spec.requires_arc = true

  #spec.source_files  = 'ChatLib/ChatLib/Sources/**/*.{h,m,swift}'
  #spec.exclude_files = 'Classes/Exclude'
  #spec.resource_bundles = { "ChatLib" => ["ChatLib/ChatLib/Sources/**/*.xcassets"] }
  #spec.resources = ["ChatLib/ChatLib/Sources/**/*.xcassets"]
  spec.ios.framework = "UIKit"

  spec.dependency 'Socket.IO-Client-Swift', '~> 15.2.0'
end