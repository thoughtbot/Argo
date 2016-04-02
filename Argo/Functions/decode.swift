/**
  Attempt to transform `AnyObject` into a `Decodable` value.

  This function takes `AnyObject` (usually the output from
  `NSJSONSerialization`) and attempts to transform it into a `Decodable` value.
  This works based on the type you ask for.

  For example, the following code attempts to decode to `Decoded<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<String> = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<T>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<T> {
  return T.decode(JSON(object))
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` values.

  This function takes `AnyObject` (usually the output from
  `NSJSONSerialization`) and attempts to transform it into an `Array` of
  `Decodable` values. This works based on the type you ask for.

  For example, the following code attempts to decode to
  `Decoded<[String]>`, because that's what we have explicitly stated is
  the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<[String]> = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<[T]>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<[T]> {
  return Array<T>.decode(JSON(object))
}

/**
  Attempt to transform `AnyObject` into a `Decodable` value and return an `Optional`.

  This function takes `AnyObject` (usually the output from
  `NSJSONSerialization`) and attempts to transform it into a `Decodable` value,
  returning an `Optional`. This works based on the type you ask for.

  For example, the following code attempts to decode to `Optional<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: String? = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: An `Optional<T>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> T? {
  return decode(object).value
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` values and
  return an `Optional`.

  This function takes `AnyObject` (usually the output from
  `NSJSONSerialization`) and attempts to transform it into an `Array` of
  `Decodable` values, returning an `Optional`. This works based on the type you
  ask for.

  For example, the following code attempts to decode to
  `Optional<[String]>`, because that's what we have explicitly stated is
  the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: [String]? = decode(object)
  } catch {
    // handle error
  }
  ```

  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: An `Optional<[T]>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> [T]? {
  return decode(object).value
}

/**
  Attempt to transform `AnyObject` into a `Decodable` value using a specified
  root key.

  This function attempts to extract the embedded `JSON` object from the
  dictionary at the specified key and transform it into a `Decodable` value.
  This works based on the type you ask for.

  For example, the following code attempts to decode to `Decoded<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: nil) as? [String: AnyObject] ?? [:]
    let str: Decoded<String> = decode(dict, rootKey: "value")
  } catch {
    // handle error
  }
  ```

  - parameter dict: The dictionary containing the `AnyObject` instance to
                    attempt to decode
  - parameter rootKey: The root key that contains the object to decode

  - returns: A `Decoded<T>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(dict: [String: AnyObject], rootKey: String) -> Decoded<T> {
  return JSON(dict) <| rootKey
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` value using a
  specified root key.

  This function attempts to extract the embedded `JSON` object from the
  dictionary at the specified key and transform it into an `Array` of
  `Decodable` values. This works based on the type you ask for.

  For example, the following code attempts to decode to `Decoded<[String]>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: nil) as? [String: AnyObject] ?? [:]
    let str: Decoded<[String]> = decode(dict, rootKey: "value")
  } catch {
    // handle error
  }
  ```

  - parameter dict: The dictionary containing the `AnyObject` instance to
                    attempt to decode
  - parameter rootKey: The root key that contains the object to decode

  - returns: A `Decoded<[T]>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(dict: [String: AnyObject], rootKey: String) -> Decoded<[T]> {
  return JSON(dict) <|| rootKey
}

/**
  Attempt to transform `AnyObject` into a `Decodable` value using a specified
  root key and return an `Optional`.

  This function attempts to extract the embedded `JSON` object from the
  dictionary at the specified key and transform it into a `Decodable` value,
  returning an `Optional`. This works based on the type you ask for.

  For example, the following code attempts to decode to `Optional<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: nil) as? [String: AnyObject] ?? [:]
    let str: String? = decode(dict, rootKey: "value")
  } catch {
    // handle error
  }
  ```

  - parameter dict: The dictionary containing the `AnyObject` instance to
                    attempt to decode
  - parameter rootKey: The root key that contains the object to decode

  - returns: A `Decoded<T>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(dict: [String: AnyObject], rootKey: String) -> T? {
  return decode(dict, rootKey: rootKey).value
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` value using a
  specified root key and return an `Optional`

  This function attempts to extract the embedded `JSON` object from the
  dictionary at the specified key and transform it into an `Array` of
  `Decodable` values, returning an `Optional`. This works based on the type you
  ask for.

  For example, the following code attempts to decode to `Optional<[String]>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let dict = try NSJSONSerialization.JSONObjectWithData(data, options: nil) as? [String: AnyObject] ?? [:]
    let str: [String]? = decode(dict, rootKey: "value")
  } catch {
    // handle error
  }
  ```

  - parameter dict: The dictionary containing the `AnyObject` instance to
                    attempt to decode
  - parameter rootKey: The root key that contains the object to decode

  - returns: A `Decoded<[T]>` value where `T` is `Decodable`
*/
public func decode<T: Decodable where T == T.DecodedType>(dict: [String: AnyObject], rootKey: String) -> [T]? {
  return decode(dict, rootKey: rootKey).value
}
