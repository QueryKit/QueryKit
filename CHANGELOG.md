# QueryKit Changelog

## 0.14.1

### Bug Fixes

* Prevents fatal error when handling operators with optional `Date` types.

## 0.14.0

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
