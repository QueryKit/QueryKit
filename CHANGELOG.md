# QueryKit Changelog

## Master

### Breaking

* Drops support for Swift 3 and Swift 4. Swift 5 or newer must be used.

### Enhancements

* Added support for ordering by Swift KeyPath, for example:

    ```swift
    queryset.orderBy(\.createdAt, ascending: true)
    ```

* Added support for filtering and excluding by Swift KeyPath, for example:

    ```swift
    queryset.exclude(\.name == "Kyle")
    queryset.filter(\.createdAt > Date())
    ```
