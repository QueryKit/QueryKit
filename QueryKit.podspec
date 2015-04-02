Pod::Spec.new do |spec|
  spec.name = 'QueryKit'
  spec.version = '0.9.2'
  spec.summary = 'A simple type-safe Core Data query language.'
  spec.homepage = 'http://querykit.org/'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'kyle@fuller.li' }
  spec.social_media_url = 'http://twitter.com/QueryKit'
  spec.source = { :git => 'https://github.com/QueryKit/QueryKit.git', :tag => "#{spec.version}" }
  spec.source_files = 'QueryKit/QueryKit.h'
  spec.requires_arc = true
  spec.ios.deployment_target = '5.0'
  spec.osx.deployment_target = '10.7'

  spec.subspec 'ObjectiveC' do |objc_spec|
    objc_spec.dependency 'QueryKit/Attribute/ObjectiveC'
    objc_spec.dependency 'QueryKit/QuerySet/ObjectiveC'
  end

  spec.subspec 'Swift' do |swift_spec|
    swift_spec.dependency 'QueryKit/Attribute/Swift'
    swift_spec.dependency 'QueryKit/QuerySet/Swift'

    swift_spec.ios.deployment_target = '8.0'
    swift_spec.osx.deployment_target = '10.9'
  end

  spec.subspec 'Attribute' do |attribute_spec|
    attribute_spec.subspec 'ObjectiveC' do |objc_spec|
      objc_spec.source_files = 'QueryKit/ObjectiveC/QKAttribute.{h,m}'
    end

    attribute_spec.subspec 'Swift' do |swift_spec|
      swift_spec.dependency 'QueryKit/QuerySet/Swift'
      swift_spec.source_files = 'QueryKit/{Attribute,Expression,Predicate}.swift'

      swift_spec.ios.deployment_target = '8.0'
      swift_spec.osx.deployment_target = '10.9'
    end

    attribute_spec.subspec 'Bridge' do |bridge_spec|
      bridge_spec.dependency 'QueryKit/Attribute/Swift'
      bridge_spec.dependency 'QueryKit/Attribute/ObjectiveC'
      bridge_spec.source_files = 'QueryKit/ObjectiveC/QKAttribute.swift'

      bridge_spec.ios.deployment_target = '8.0'
      bridge_spec.osx.deployment_target = '10.9'
    end
  end

  spec.subspec 'QuerySet' do |queryset_spec|
    queryset_spec.subspec 'ObjectiveC' do |objc_spec|
      objc_spec.source_files = 'QueryKit/ObjectiveC/QKQuerySet.{h,m}'
    end

    queryset_spec.subspec 'Swift' do |swift_spec|
      swift_spec.source_files = 'QueryKit/QuerySet.swift'

      swift_spec.ios.deployment_target = '8.0'
      swift_spec.osx.deployment_target = '10.9'
    end

    queryset_spec.subspec 'Bridge' do |bridge_spec|
      bridge_spec.dependency 'QueryKit/QuerySet/Swift'
      bridge_spec.dependency 'QueryKit/QuerySet/ObjectiveC'
      bridge_spec.source_files = 'QueryKit/ObjectiveC/QKQuerySet.swift'

      bridge_spec.ios.deployment_target = '8.0'
      bridge_spec.osx.deployment_target = '10.9'
    end
  end
end

