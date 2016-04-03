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
  return T.decode(JSON.parse(object))
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
  return Array<T>.decode(JSON.parse(object))
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
  Attempt to transform `AnyObject` into a `Decodable` value using a specified root key.

  This function expects the object to be a dictionary of the type `[String: JSON]`.

  This function attpemts to extract the embedded JSON object from the
  dictionary at the specified key and transform it into a `Decodable` value.
  This works based on the type you ask for.

  For example, the following code attempts to decode to `Decoded<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<String> = decodeWithRootKey("value", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key that contains the object to decode
  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<T>` value where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<T> {
  return JSON.parse(object) <| rootKey
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` value using a
  specified root key.

  This function expects the object to be a dictionary of the type `[String: JSON]`.

  This function attpemts to extract the embedded JSON object from the
  dictionary at the specified key and transform it into an `Array` of
  `Decodable` values. This works based on the type you ask for.

  For example, the following code attempts to decode to `Decoded<[String]>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: Decoded<[String]> = decodeWithRootKey("value", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key that contains the object to decode
  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<[T]>` value where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<[T]> {
  return JSON.parse(object) <|| rootKey
}

/**
  Attempt to transform `AnyObject` into a `Decodable` value using a specified
  root key and return an `Optional`.

  This function expects the object to be a dictionary of the type `[String: JSON]`.

  This function attpemts to extract the embedded JSON object from the
  dictionary at the specified key and transform it into a `Decodable` value,
  returning an `Optional`. This works based on the type you ask for.

  For example, the following code attempts to decode to `Optional<String>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: String? = decodeWithRootKey("value", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key that contains the object to decode
  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<T>` value where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> T? {
  return decodeWithRootKey(rootKey, object).value
}

/**
  Attempt to transform `AnyObject` into an `Array` of `Decodable` value using a
  specified root key and return an `Optional`

  This function expects the object to be a dictionary of the type `[String: JSON]`.

  This function attpemts to extract the embedded JSON object from the
  dictionary at the specified key and transform it into an `Array` of
  `Decodable` values, returninh an `Optional`. This works based on the type you
  ask for.

  For example, the following code attempts to decode to `Optional<[String]>`,
  because that's what we have explicitly stated is the return type:

  ```
  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: nil)
    let str: [String]? = decodeWithRootKey("value", object)
  } catch {
    // handle error
  }
  ```

  - parameter rootKey: The root key that contains the object to decode
  - parameter object: The `AnyObject` instance to attempt to decode

  - returns: A `Decoded<[T]>` value where `T` is `Decodable`
*/
public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> [T]? {
  return decodeWithRootKey(rootKey, object).value
}

