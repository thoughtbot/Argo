/**
  Decode a raw JSON value into an optional `Decodable` value

  This function takes the output from `NSJSONSerialization` and attempts to
  decode it into a `Decodable` value, returning an `Optional`. This works based
  on the type you ask for.

  For example, the following code attempts to decode an optional `String`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: String? = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The output from `NSJSONSerialization`
  - returns: An `Optional` value of type `T` where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> T? {
  return decode(object).value
}

/**
  Decode a raw JSON value into an optional array of `Decodable` values

  This function takes the output from `NSJSONSerialization` and attempts to
  decode it into an array of `Decodable` values, returning an `Optional`. This
  works based on the type you ask for.

  For example, the following code attempts to decode an optional array of
  `String`s, because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: [String]? = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The output from `NSJSONSerialization`
  - returns: An `Optional` array of values of type `T` where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> [T]? {
  return decode(object).value
}

/**
  Decode a raw JSON value into a decoded `Decodable` value

  This function takes the output from `NSJSONSerialization` and attempts to
  decode it into a `Decodable` value, returning a `Decoded`. This works based on
  the type you ask for.

  For example, the following code attempts to decode a decoded `String`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<String> = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The output from `NSJSONSerialization`
  - returns: A `Decoded` value of type `T` where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<T> {
  return T.decode(JSON.parse(object))
}

/**
  Decode a raw JSON value into an array of decoded `Decodable` values

  This function takes the output from `NSJSONSerialization` and attempts to
  decode it into an array of `Decodable` values, returning a `Decoded`. This
  works based on the type you ask for.

  For example, the following code attempts to decode a decoded array of
  `String`s, because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<[String]> = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The output from `NSJSONSerialization`
  - returns: A `Decoded` array of values of type `T` where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<[T]> {
  return Array<T>.decode(JSON.parse(object))
}

/**
  Decode a raw JSON value into an optional `Decodable` value by looking in a
  specified root key

  This function takes the output from `NSJSONSerialization`, takes the object
  at a specified root key,  and attempts to decode it into a `Decodable` value,
  returning an `Optional`. This works based on the type you ask for.

  For example, the following code attempts to decode an optional `String`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: String? = decodeWithRootKey("foo", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key for the object to decode
  - parameter object: The output from `NSJSONSerialization`
  - returns: An `Optional` value of type `T` where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> T? {
  return decodeWithRootKey(rootKey, object).value
}

/**
  Decode a raw JSON value into an optional array of `Decodable` values by
  looking in a specified root key

  This function takes the output from `NSJSONSerialization`, takes the object
  at a specified root key, and attempts to decode it into an array of `Decodable`
  values, returning an `Optional`. This works based on the type you ask for.

  For example, the following code attempts to decode an optional array of
  `String`s, because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: [String]? = decodeWithRootKey("foo", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key for the object to decode
  - parameter object: The output from `NSJSONSerialization`
  - returns: An `Optional` array of values of type `T` where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> [T]? {
  return decodeWithRootKey(rootKey, object).value
}

/**
  Decode a raw JSON value into a decoded `Decodable` value by looking in a
  specified root key

  This function takes the output from `NSJSONSerialization`, takes the object
  at a specified root key, and attempts to decode it into a `Decodable` value,
  returning a `Decoded`. This works based on the type you ask for.

  For example, the following code attempts to decode a decoded `String`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<String> = decodeWithRootKey("foo", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key for the object to decode
  - parameter object: The output from `NSJSONSerialization`
  - returns: A `Decoded` value of type `T` where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<T> {
  return JSON.parse(object) <| rootKey
}

/**
  Decode a raw JSON value into an array of decoded `Decodable` values by
  looking in a specified root key

  This function takes the output from `NSJSONSerialization`, takes the object
  at a specified root key, and attempts to decode it into an array of `Decodable`
  values, returning a `Decoded`. This works based on the type you ask for.

  For example, the following code attempts to decode a decoded array of
  `String`s, because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<[String]> = decodeWithRootKey("foo", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key for the object to decode
  - parameter object: The output from `NSJSONSerialization`
  - returns: A `Decoded` array of values of type `T` where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<[T]> {
  return JSON.parse(object) <|| rootKey
}
