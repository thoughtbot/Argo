## Ideology

Argo's core concept is that in order to maintain type safety, you should only
be able to successfully decode an object if all parameters are satisfied
properly. So if you have a model that looks like this:

```swift
struct User {
  let id: Int
  let name: String
}
```

but the JSON you receive from the server looks like this:

```json
{
  "user": {
    "id": "this isn't a number",
    "name": "Gob Bluth"
  }
}
```

then ideally, JSON parsing would fail, and you'd get an error state instead of
a `User` object. In Argo, if JSON parsing succeeds you'll receive the `User`
object and you can be sure that it is full and valid. If it fails, you will
instead be given the reason why the `User` couldn't be constructed.

If you're interested in learning more about the concepts and ideology that
went into building Argo, we recommend reading the series of articles that were
written alongside its development:

- [Efficient JSON in Swift with Functional Concepts and Generics](http://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics)
- [Real World JSON Parsing with Swift](http://robots.thoughtbot.com/real-world-json-parsing-with-swift)
- [Parsing Embedded JSON and Arrays in Swift](http://robots.thoughtbot.com/parsing-embedded-json-and-arrays-in-swift)

