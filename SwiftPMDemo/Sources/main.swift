import Argo
import Runes
import Curry

struct Foo: Decodable {
    let id: String
    let name: String

    static func decode(_ j: JSON) -> Decoded<Foo> {
        return curry(self.init)
            <^> j <| "id"
            <*> j <| "name"
    }
}

let foo: Decoded<Foo> = decode([ "id": "123", "name": "foo bar" ])
print(foo)
