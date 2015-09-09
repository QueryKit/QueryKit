<img src="QueryKit.png" width=128 height=160 alt="QueryKit Logo" />

# QueryKit

[![Build Status](http://img.shields.io/travis/QueryKit/QueryKit/master.svg?style=flat)](https://travis-ci.org/QueryKit/QueryKit)

QueryKit, a simple type-safe Core Data query language.

## Usage

### QuerySet

A QuerySet represents a collection of objects from your Core Data Store. It can have zero, one or many filters. Filters narrow down the query results based on the given parameters.

#### Retrieving all objects

```swift
let queryset = QuerySet(context, "Person")
```

**NOTE**: *It’s recommend to implement a type type-safe `queryset` method on your model.*

```swift
let queryset = Person.queryset(context)
```

#### Retrieving specific objects with filters

You can filter a QuerySet using the `filter` and `exclude` methods, which
accept a predicate and return a new QuerySet.

```swift
queryset.filter(NSPredicate(format: "name == %@", "Kyle"))
queryset.exclude(NSPredicate(format: "age > 21"))
```

**NOTE**: *You can define [type-safe methods](https://github.com/QueryKit/TodoExample/blob/master/Todo/Model/Generated/_Task.swift#L14-26) on your models, or use the [mogenerator template](https://github.com/QueryKit/mogenerator-template) to generate these.*

```swift
queryset.filter(Person.attributes.name == "Kyle")
queryset.exclude(Person.attributes.age > 21)
```

##### Chaining filters

The result of refining a QuerySet is itself a QuerySet, so it’s possible to chain refinements together. For example:

```swift
queryset.filter(Person.attributes.name == "Kyle")
    .exclude(Person.attributes.age > 21)
    .filter(Person.attributes.isEmployed)
```

Each time you refine a QuerySet, you get a brand-new QuerySet that is in no way bound to the previous QuerySet. Each refinement creates a separate and distinct QuerySet that can be stored, used and reused.

#### QuerySets are lazy

A QuerySet is lazy, creating a QuerySet doesn’t involve querying Core Data. QueryKit won’t actually execute the query until the QuerySet is *evaluated*.

#### Slicing

Using slicing, you can limit your QuerySet to a certain number of results.

```swift
Person.queryset(context)[0..<10]
```

**NOTE**: *Remember, QuerySets are lazily evaluated. Slicing doesn’t evaluate the query.*

#### Ordering

You can order a QuerySet's results by using the `orderBy` method which accepts
a collection of sort descriptors:

```swift
queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
queryset.orderBy(Person.name.ascending)
queryset.orderBy([Person.name.ascending, Person.age.descending])
```

#### Slicing

You can use slicing to limit a queryset to a range. For example, to get the
first 5 items:

```swift
queryset[0..5]
```

#### Fetching

##### Multiple objects

You can convert a QuerySet to an array using the `array()` function. For example:

```swift
for person in try! queryset.array() {
  println("Hello \(person.name).")
}
```

##### First object

```swift
var kyle = Person.queryset(context).filter(Person.name == "Kyle").first()
```

##### Last object

```swift
var kyle = Person.queryset(context).filter(Person.name == "Kyle").last()
```

##### Object at index

```swift
var orta = queryset.object(3)
```

##### Count

```swift
queryset.count()
```

##### Deleting

This method immediately deletes the objects in your queryset and returns a
count and an error if the operation failed.

```swift
queryset.delete()
```

#### Attribute

The `Attribute` is a generic structure for creating predicates in a type-safe manner.

```swift
let name = Attribute<String>("name")
let age = Attribute<Int>("age")

name == "Kyle"
name << ["Kyle", "Katie"]

age == 27
age >= 25
age << (22...30)
```

##### Operators

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

#### Predicate extensions

We've also extended NSPredicate to add support for the `!`, `&&` and `||` operators for joining predicates together.

```swift
NSPredicate(format:"name == Kyle") || NSPredicate(format:"name == Katie")
NSPredicate(format:"age >= 21") && !NSPredicate(format:"name == Kyle")
```

```swift
Person.name == "Kyle" || Person.name == "Katie"
Person.age >= 21 || Person.name != "Kyle"
```

## Installation

```ruby
pod 'QueryKit'
```

## License

QueryKit is released under the BSD license. See [LICENSE](LICENSE).

