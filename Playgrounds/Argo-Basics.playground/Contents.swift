/*:
**Note:** For **Argo** to be imported into the Playground, ensure that the **Argo-Mac** *scheme* is selected from the list of schemes.

* * *
*/
/*:
**Note:** For **Argo** to be imported i/*:
**Helper function** – load JSON from a file
*/
nto the Playground, ensure that the **Argo-Mac** *scheme* is selected from the list of schemes.

* * *
*/
import Foundation
import Argo
import Runes
/*:
**Helper function** – load JSON from a file
*/
func JSONFromFile(file: String) -> AnyO/*:
## Decoding JSON into a simple **User** struct

The **User** struct has three properties, one of which is an Optional value.

(The example JSON file can be found in the **Resources** folder.)
*/
bject? {
  return NSBundle.mainBundle().pathForResource(file, ofType: "json")
    >>- { NSData(contentsOfFile: $0) }
    >>- { NSJSONSerialization.JSONObjectWithData($0, options: nil, error: nil) }
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

extension User/*:
* * *
*/
: CustomStringConvertible {
  var description: String {
    return "name: \(n