Pod::Spec.new do |spec|
  spec.name = 'QueryKit'
  spec.version = '0.8.2'
  spec.summary = 'A simple CoreData query language for Swift.'
  spec.homepage = 'http://querykit.org/'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/QueryKit/QueryKit.git', :tag => "#{spec.version}" }
  spec.source_files = 'QueryKit/*.{h}', 'QueryKit/ObjectiveC/*.{h,m}'
  spec.requires_arc = true
end

