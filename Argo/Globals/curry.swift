func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { a in { b in f(a, b) }}
}
