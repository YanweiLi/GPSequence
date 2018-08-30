Pod::Spec.new do |s|
s.name    = 'GrapeSequence'
s.version = '1.0.0'
s.summary = 'GPFoundation 基础库，提供tuple功能.'
s.license = { :type => "MIT", :file => "LICENSE" }
s.author  = { "一凡" => "code_li_yw@163.com" }
s.homepage = 'https://github.com/YanweiLi/GPSequence'
s.source = { :git => "https://github.com/YanweiLi/GPSequence.git" , :tag => "feature_#{s.version}"}
s.platform = :ios, "8.0"
s.ios.deployment_target = "8.0"
s.vendored_frameworks = '*.framework'
s.requires_arc = true
end