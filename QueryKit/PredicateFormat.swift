import Foundation

public enum PredicateFormat : CustomStringConvertible, Equatable, StringInterpolationConvertible, StringLiteralConvertible {
  case Tree([PredicateFormat])
  case FormatSegment(String) // string
  case KeyPath(String) // %K
  case ObjectExpression(AnyObject) // %@

  public var description: String {
    switch self {
    case .Tree(let formatSegments):
      return formatSegments.reduce("") { $0 + String($1) }
    case .FormatSegment(let segment):
      return segment
    case .KeyPath(let keyPath):
      return keyPath
    case .ObjectExpression(let expression):
      return String(expression)
    }
  }

  public init(stringInterpolation elements: PredicateFormat...) {
    self = .Tree(elements)
  }

  public init<T>(stringInterpolationSegment expression: T) {
    if let predicateFormat = expression as? PredicateFormat {
      self = predicateFormat
    } else if let value = expression as? PredicateFormatConvertible {
      self = value.predicateFormatValue
    } else if let string = expression as? String {
      self = .FormatSegment(string)
    } else if let object = expression as? AnyObject {
      self = .ObjectExpression(object)
    } else {
      self = .ObjectExpression(String(expression))
    }
  }

  public init(stringLiteral value: String) {
    self = .FormatSegment(value)
  }

  public init(extendedGraphemeClusterLiteral value: Character) {
    self = .FormatSegment(String(value))
  }

  public init(unicodeScalarLiteral value: UnicodeScalar) {
    self = .FormatSegment(String(value))
  }
}

public func ==(lhs: PredicateFormat, rhs: PredicateFormat) -> Bool {
  return lhs.description == rhs.description
}


// MARK: - Functions

extension Predicate {
  init(_ predicateFormat: PredicateFormat) {
    let (format, arguments) = predicateFormat.formatSegments
    let predicate = NSPredicate(format: format, argumentArray: arguments)
    self.init(predicate: predicate)
  }
}

public func key(keyPath: String) -> PredicateFormat {
  return .KeyPath(keyPath)
}

public func quoted(string: String) -> PredicateFormat {
  return .ObjectExpression(string)
}

public protocol PredicateFormatConvertible {
  var predicateFormatValue: PredicateFormat { get }
}

// MARK: - Private

private typealias PredicateFormatSegment = (String, [AnyObject])

private func +(lhs: PredicateFormatSegment, rhs: PredicateFormatSegment) -> PredicateFormatSegment{
  return (lhs.0 + rhs.0, lhs.1 + rhs.1)
}

private func +(lhs: PredicateFormatSegment, rhs: PredicateFormat) -> PredicateFormatSegment {
  return lhs + rhs.formatSegments
}

private extension PredicateFormat {
  private var formatSegments: PredicateFormatSegment {
    switch self {
    case .Tree(let segments):
      return segments.reduce(("", []), combine: +)
    case .FormatSegment(let element):
      return (element, [])
    case .KeyPath(let keyPath):
      return ("%K", [keyPath])
    case .ObjectExpression(let value):
      return ("%@", [value])
    }
  }
}
