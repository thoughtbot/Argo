func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { a in { b in f(a, b) }}
}

func curry<A, B, C, D>(f: (A, B, C) -> D) -> A -> B -> C -> D {
  return { a in { b in { c in f(a, b, c) }}}
}

func curry<A, B, C, D, E>(f: (A, B, C, D) -> E) -> A -> B -> C -> D -> E {
  return { a in { b in { c in { d in f(a, b, c, d) }}}}
}
