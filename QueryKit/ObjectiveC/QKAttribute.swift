import Foundation

extension Attribute {
  public func asQKAttribute() -> QKAttribute {
    return QKAttribute(name: name)
  }
}

extension QKAttribute {
  public func asAttribute() -> Attribute<AnyObject> {
    return Attribute<AnyObject>(name)
  }
}
