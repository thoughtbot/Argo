extension Dictionary {
  static func appendKey(var dict: [Key: Value], key: Key, value: Value) -> [Key: Value] {
    dict[key] = value
    return dict
  }
}
