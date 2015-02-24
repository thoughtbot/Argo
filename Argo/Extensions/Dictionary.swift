// pure merge for Dictionaries
func +<T, V>(var lhs: [T: V], rhs: [T: V]) -> [T: V] {
  var dict = lhs

  for (key, val) in rhs {
    dict[key] = val
  }

  return dict
}
