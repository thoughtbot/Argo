public func flatten<A>(array: [A?]) -> [A] {
  var list: [A] = []
  for item in array {
    if let i = item {
      list.append(i)
    }
  }
  return list
}
