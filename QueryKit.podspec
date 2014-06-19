Pod::Spec.new do |spec|
  spec.name = 'QueryKit'
  spec.version = '0.8.0'
  spec.summary = 'A simple CoreData query language for Swift.'
  spec.homepage = 'https://github.com/kylef/QueryKit'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/kylef/QueryKit.git', :tag => "#{spec.version}" }
  spec.source_files = 'QueryKit/QueryKit.{h,swift}'
  spec.requires_arc = true
end

