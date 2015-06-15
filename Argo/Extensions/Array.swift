extension Array {
  func mapThrows<T>(@noescape transform: Generator.Element throws -> T) throws -> [T] {
    var items: [T] = []
    for item in self {
      items += [try transform(item)]
    }
    return items
  }
}
