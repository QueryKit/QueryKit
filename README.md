QueryKit
========

QueryKit, a simple CoreData query language for Swift.

## Usage

### Querying

```swift
var queryset = Person.queryset(context).filter(Person.name == "Kyle")
                                       .exclude(Person.age < 21)
                                       .orderBy(Person.name.ascending)
```

#### Ranges

```swift
queryset[0..5]
```

### Fetching

#### Single item

```swift
var kyle = queryset[0]
println("The first Kyle who is 21 and over is \(kyle.name).")
```

#### Count

```swift
println("There are \(queryset.count() - 1) more Kyle's.")
```

#### Iteration

```swift
for person in queryset {
    println("- \(person.name) (\(person.age))")
}
```

### Predicate extensions

```swift
var predicate = NSPredicate(format:"name == Kyle")
    || NSPredicate(format:"name == Katie")
    && !NSPredicate(format:"age >= 21")
```

## License

QueryKit is released under the BSD license. See [LICENSE](LICENSE).

