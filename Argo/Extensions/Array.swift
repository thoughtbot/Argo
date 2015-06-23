extension Array {
  func map<T>(@noescape transform: Generator.Element throws -> T) rethrows -> [T] {
    var items: [T] = []
    for item in self {
      items += [try transform(item)]
    }
    return items
  }
}
