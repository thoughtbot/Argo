# Decoding with Root Keys

The easiest way to decode models from JSON is to use the global `decode`
function: pass the `AnyObject` variable returned from `NSJSONSerialization`
directly to `decode`, and you'll get the model back. However, many times the
JSON for the model is embedded within a root key:

```
{
  "user": {
    "id": 1881372911,
    "name": "George Senior"
  }
}
```

In this case, you can't use the global `decode` function because it assumes
the object you're trying to decode is at the root level. To get around this,
first transform the `AnyObject` into a `JSON` type, then use the `<|` operator
to pull out the object and decode it into its model.

```swift
let json = JSON(anyObject)

let user: Decoded<User> = json <| "user"
// or
let user: User? = json <| "user"
```
