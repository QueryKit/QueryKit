Pod::Spec.new do |spec|
  spec.name = 'QueryKit'
  spec.version = '0.8.3'
  spec.summary = 'A simple CoreData query language for Swift.'
  spec.homepage = 'http://querykit.org/'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/QueryKit/QueryKit.git', :tag => "#{spec.version}" }
  spec.source_files = 'QueryKit/*.{h}', 'QueryKit/ObjectiveC/*.{h,m}'
  spec.requires_arc = true

  spec.subspec 'ObjectiveC' do |objc_spec|
    objc_spec.dependency 'QueryKit/Attribute/ObjectiveC'
    objc_spec.dependency 'QueryKit/QuerySet/ObjectiveC'
  end

  spec.subspec 'Swift' do |swift_spec|
    swift_spec.dependency 'QueryKit/Attribute/Swift'
    swift_spec.dependency 'QueryKit/QuerySet/Swift'
  end

  spec.subspec 'Attribute' do |attribute_spec|
    attribute_spec.subspec 'ObjectiveC' do |objc_spec|
      objc_spec.source_files = 'QueryKit/ObjectiveC/QKAttribute.{h,m}'
    end

    attribute_spec.subspec 'Swift' do |swift_spec|
      swift_spec.source_files = 'QueryKit/{Attribute,Expression,Predicate}.swift'
    end

    attribute_spec.subspec 'Bridge' do |bridge_spec|
      bridge_spec.dependency 'QueryKit/Attribute/Swift'
      bridge_spec.dependency 'QueryKit/Attribute/ObjectiveC'
      bridge_spec.source_files = 'QueryKit/ObjectiveC/QKAttribute.swift'
    end
  end

  spec.subspec 'QuerySet' do |queryset_spec|
    queryset_spec.subspec 'ObjectiveC' do |objc_spec|
      objc_spec.source_files = 'QueryKit/ObjectiveC/QKQuerySet.{h,m}'
    end

    queryset_spec.subspec 'Swift' do |swift_spec|
      swift_spec.source_files = 'QueryKit/QuerySet.swift'
    end

    queryset_spec.subspec 'Bridge' do |bridge_spec|
      bridge_spec.dependency 'QueryKit/QuerySet/Swift'
      bridge_spec.dependency 'QueryKit/QuerySet/ObjectiveC'
      bridge_spec.source_files = 'QueryKit/ObjectiveC/QKQuerySet.swift'
    end
  end
end

