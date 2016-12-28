<img src="https://raw.githubusercontent.com/thoughtbot/Argo/master/web/Logo.png" width="250" />

# Argo [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Argo is a library that lets you extract models from JSON or similar structures in
a way that's concise, type-safe, and easy to extend. Using Argo, you won't need
to write validation code to ensure that incoming data is of the right type, or
to make sure required data fields aren't turning up empty. Argo uses Swift's
expressive type system to do that for you, and reports back explicit failure
states in case it doesn't find what you've told it to expect.

_Argo_ is the Greek word for _swift_ and the name of the ship used by Jason, son
of Aeson, of the Argonauts. Aeson is the JSON parsing library in Haskell that
inspired Argo, much like Aeson inspired his son Jason.

## Version Compatibility

Note that we're aggressive about pushing `master` forward along with new
versions of Swift. Therefore, we highly recommend against pointing at `master`,
and instead using [one of the releases we've provided][releases].

Here is the current Swift compatibility breakdown:

| Swift Version | Argo Version |
| ------------- | ------------ |
| 3.X           | 4.X          |
| 2.2, 2.3      | 3.X          |
| 2.0, 2.1      | 2.X          |
| 1.2 - 2.0     | 1.X          |
| 1.1           | 0.3.X        |

[releases]: https://github.com/thoughtbot/Argo/releases

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

Note that if you are using newer versions of Argo, you will need to link both
`Argo.framework` and `Runes.framework` into your app.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

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

You will need to do the same for [Runes] if you are using newer versions of
Argo.

[Runes]: https://github.com/thoughtbot/Runes

## Usage tl;dr:

Please note: the example below requires an additional, external module named
[Curry](https://github.com/thoughtbot/Curry) which lets us use the `curry`
function to curry `User.init`.

It also imports [Runes], which is a dependency of Argo in newer versions. If
you are using an older version of Argo, you might not need that import.

```swift
import Argo
import Curry
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
  let role: Role
  let companyName: String
  let friends: [User]
}

extension User: Decodable {
  static func decode(_ json: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <|? "email" // Use ? for parsing optional values
      <*> json <| "role" // Custom types that also conform to Decodable just work
      <*> json <| ["company", "name"] // Parse nested objects
      <*> json <|| "friends" // parse arrays of objects
  }
}

// Wherever you receive JSON data:

let json: Any? = try? NSJSONSerialization.JSONObjectWithData(data, options: [])

if let j: Any = json {
  let user: User? = decode(j)
}
```

For more information, see the [Documentation](Documentation/)

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/Argo/graphs/contributors

## License

Argo is Copyright (c) 2015 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![thoughtbot](https://thoughtbot.com/logo.png)

Argo is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/work?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github

