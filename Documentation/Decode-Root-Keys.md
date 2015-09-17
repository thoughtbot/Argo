The easiest way to decode models from json is to use the global `decode`
function. You can pass the `AnyObject` variable returned from
`NSJSONSerialization` directly to `decode` and get the model back. However,
many times the model json is embedded within a root key:

```
{
  "user": {
    "id": 1881372911,
    "name": "George Sr"
  }
}
```

In this case, you can't use the global `decode` function. The easiest way
is to first parse the `AnyObject` into a `JSON` type then use the `<|` operator
like so:

```swift
let json = JSON.parse(anyObject)

let user: Decoded<User> = json <| "user"
// or
let user: User? = json <| "user"
```

