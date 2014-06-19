QueryKit
========

QueryKit, a simple CoreData query language for Swift.

## Usage

### Querying

```swift
var queryset = Person.queryset(context).filter(Person.name == "Kyle")
                                       .exclude(Person.age < 21)
                                       .orderBy(Person.name.ascending)

var kyle = queryset[0]
println("The first Kyle who is 21 and over is \(kyle.name).")

println("There are \(queryset.count().count - 1) more Kyle's.")

println("The first 5 Kyle's alphabetically are:")
for person in queryset[0...5] {
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

