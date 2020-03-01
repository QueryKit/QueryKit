<img src="QueryKit.png" width=96 height=120 alt="QueryKit Logo" />

# QueryKit

QueryKit, a simple type-safe Core Data query language.

## Usage

```swift
QuerySet<Person>(context, "Person")
  .orderedBy(.name, ascending: true)
  .filter(\.age >= 18)
```

### QuerySet

A QuerySet represents a collection of objects from your Core Data Store.
It may have zero, one or many filters. Filters narrow down the query
results based on the given parameters.

#### Retrieving all objects

```swift
let queryset = QuerySet<Person>(context, "Person")
```

#### Retrieving specific objects with filters

You may filter a QuerySet using the `filter` and `exclude` methods, which
accept a predicate which can be constructed using KeyPath extensions.

The `filter` and `exclude` methods return new QuerySet's including your filter.

```swift
queryset.filter(\.name == "Kyle")
queryset.exclude(\.age > 25)
```

You may also use standard `NSPredicate` if you want to construct complicated
queries or do not wish to use the type-safe properties.

```swift
queryset.filter(NSPredicate(format: "name == '%@'", "Kyle"))
queryset.exclude(NSPredicate(format: "age > 25"))
```

##### Chaining filters

The result of refining a QuerySet is itself a QuerySet, so it’s possible
to chain refinements together. For example:

```swift
queryset.filter(\.name == "Kyle")
       .exclude(\.age < 25)
```

Each time you refine a QuerySet, you get a new QuerySet instance that is in no
way bound to the previous QuerySet. Each refinement creates a separate and
distinct QuerySet that may be stored, used and reused.

#### QuerySets are lazy

A QuerySet is lazy, creating a QuerySet doesn’t involve querying
Core Data. QueryKit won’t actually execute the query until the
QuerySet is *evaluated*.

#### Ordering

You may order a QuerySet's results by using the `orderBy` function which
accepts a KeyPath.

```swift
queryset.orderBy(\.name, ascending: true)
```

You may also pass in an `NSSortDescriptor` if you would rather.

```swift
queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
```

#### Slicing

Using slicing, a QuerySet's results may be limited to a specified range. For
example, to get the first 5 items in our QuerySet:

```swift
queryset[0...5]
```

**NOTE**: *Remember, QuerySets are lazily evaluated. Slicing doesn’t evaluate the query.*

#### Fetching

##### Multiple objects

You may convert a QuerySet to an array using the `array()` function. For example:

```swift
for person in try! queryset.array() {
  println("Hello \(person.name).")
}
```

##### First object

```swift
let kyle = try? queryset.first()
```

##### Last object

```swift
let kyle = try? queryset.last()
```

##### Object at index

```swift
let katie = try? queryset.object(3)
```

##### Count

```swift
let numberOfPeople = try? queryset.count()
```

##### Deleting

This method immediately deletes the objects in your queryset and returns a
count or an error if the operation failed.

```swift
let deleted = try? queryset.delete()
```

##### Operators

QueryKit provides KeyPath extensions providing operator functions allowing you
to create predicates.

```swift
// Name is equal to Kyle
\Person.name == "Kyle"

// Name is either equal to Kyle or Katie
\.Person.name << ["Kyle", "Katie"]

// Age is equal to 27
\.Person.age == 27

// Age is more than or equal to 25
\Person.age >= 25

// Age is within the range 22 to 30.
\Person.age << (22...30)
```

The following types of comparisons are supported using Attribute:

| Comparison | Meaning |
| ------- |:--------:|
| == | x equals y |
| != | x is not equal to y |
| < | x is less than y |
| <= | x is less than or equal to y |
| > | x is more than y |
| >= | x is more than or equal to y |
| ~= | x is like y |
| ~= | x is like y |
| << | x IN y, where y is an array |
| << | x BETWEEN y, where y is a range |

##### Predicate extensions

QueryKit provides the `!`, `&&` and `||` operators for joining multiple predicates together.

```swift
// Persons name is Kyle or Katie
\Person.name == "Kyle" || \Person.name == "Katie"

// Persons age is more than 25 and their name is Kyle
\Person.age >= 25 && \Person.name == "Kyle"

// Persons name is not Kyle
!(\Person.name == "Kyle")
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add QueryKit to
your project, you may also use Carthage.

```ruby
pod 'QueryKit'
```

## License

QueryKit is released under the BSD license. See [LICENSE](LICENSE).

