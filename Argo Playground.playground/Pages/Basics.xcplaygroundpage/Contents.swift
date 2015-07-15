/*:
**Note:** For **Argo** to be imported into the Playground, ensure that the **Argo-Mac** *scheme* is selected from the list of schemes.

* * *
*/
import Foundation
import Argo
import Curry
/*:
**Helper function** – load JSON from a file
*/
func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle.mainBundle().pathForResource(file, ofType: "json")
    .flatMap { NSData(contentsOfFile: $0) }
    .flatMap(JSONObjectWithData)
}

func JSONObjectWithData(data: NSData) -> AnyObject? {
  do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
  catch { return .None }
}
/*:
## Decoding JSON into a simple **User** struct

The **User** struct has three properties, one of which is an Optional value.

(The example JSON file can be found in the **Resources** folder.)
*/
struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: CustomStringConvertible {
  var description: String {
    return "name: \(name), id: \(id), email: \(email)"
  }
}

extension User: Decodable  {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(self.init)
      <^> j <| "id"
      <*> j <| "name"
      <*> j <|? "email"
  }
}
/*:
* * *
*/
let user: User? = JSONFromFile("user_with_email").flatMap(decode)
print(user!)

