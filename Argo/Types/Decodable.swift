/// An object that is able to be decoded
public protocol Decodable {

  /**
    The type of object that will be decoded.

    In order to work with the rest of Argo, this needs to be the same as `Self`.

    You should rarely need to set this value yourself. The only time you might
    need to set it is if you allow `Self` to be subclassed and don't mark
    `decode` as `final`. In that case, you will need to explicitly set
    `DecodedType` to the type you are returning in order for the compiler to be
    able to guarantee that this protocol is being fully conformed to.

    Ideally the need for this will be removed in later versions of Swift.
  */
  typealias DecodedType = Self

  /**
    Decode an object from JSON

    This is the main entry point for Argo. This function declares how the
    conforming type should be decoded from JSON. Since this is a failable
    operation, we need to return a `Decoded` type from this function.

    - parameter json: The `JSON` representation of this object

    - returns: A decoded instance of the `DecodedType`.
  */
  static func decode(json: JSON) -> Decoded<DecodedType>
}
