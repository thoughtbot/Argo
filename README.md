<img src="https://raw.githubusercontent.com/thoughtbot/Argo/gh-pages/Argo.png" width="250" />

# Argo [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The Greek word for _swift_ and the ship used by Jason, son of Aeson, of the
Argonauts. Aeson is the JSON parsing library in Haskell that inspired Argo,
much like Aeson inspired his son Jason.

NOTE: The master branch of Argo is pushing ahead with Swift 1.2 support.
Support for Swift 1.1 can be found on branch [swift-1.1] and in the 0.3.x
versions of tags/releases.

[swift-1.1]: https://github.com/thoughtbot/Argo/tree/swift-1.1

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "thoughtbot/Argo"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

You'll also need to add `Runes.framework` to your project. [Runes] is a
dependency of Argo, so you don't need to specify it in your Cartfile.

[Runes]: https://github.com/thoughtbot/runes

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'Argo'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

### Git Submodules

I guess you could do it this way if that's your thing.

Add this repo as a submodule, and add the project file to your workspace. You
can then link against `Argo.framework` for your application target.

You'll also need to add [Runes] to your project the same way.

## Usage tl;dr:

```swift
struct User {
  let id: Int
  let name: String
  let email: String?
  let role: Role
  let companyName: String
  let friends: [User]
}

extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?)(role: Role)(companyName: String)(friends: [User]) -> User {
    return User(id: id, name: name, email: email, role: role, companyName: companyName, friends: friends)
  }

  static func decode(j: JSONValue) -> User? {
    return User.create
      <^> j <| "id"
      <*> j <| "name"
      <*> j <|? "email" // Use ? for parsing optional values
      <*> j <| "role" // Custom types that also conform to JSONDecodable just work
      <*> j <| ["company", "name"] // Parse nested objects
      <*> j <|| "friends" // parse arrays of objects
  }
}

// Wherever you receive JSON data:

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: .None)

if let j: AnyObject = json {
  let value = JSONValue.parse(j)
  let user = User.decode(value)
}
```

For more information, see the [Documentation](Documentation/)

