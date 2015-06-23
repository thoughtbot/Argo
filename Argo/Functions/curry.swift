public func curry<A, B, C>(f : (A, B) -> C) -> A -> B -> C {
  return { a in { b in f(a, b) } }
}

public func curry<A, B, C, D>(f : (A, B, C) -> D) -> A -> B -> C -> D {
  return { a in { b in { c in f(a, b, c) } } }
}

public func curry<A, B, C, D, E>(f : (A, B, C, D) -> E) -> A -> B -> C -> D -> E {
  return { a in { b in { c in { d in f(a, b, c, d) } } } }
}

public func curry<A, B, C, D, E, F>(f : (A, B, C, D, E) -> F) -> A -> B -> C -> D -> E -> F {
  return { a in { b in { c in { d in { e in f(a, b, c, d, e) } } } } }
}

public func curry<A, B, C, D, E, F, G>(f : (A, B, C, D, E, F) -> G) -> A -> B -> C -> D -> E -> F -> G {
  return { a in { b in { c in { d in { e in { ff in f(a, b, c, d, e, ff) } } } } } }
}

public func curry<A, B, C, D, E, F, G, H>(f : (A, B, C, D, E, F, G) -> H) -> A -> B -> C -> D -> E -> F -> G -> H {
  return { a in { b in { c in { d in { e in { ff in { g in f(a, b, c, d, e, ff, g) } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I>(f : (A, B, C, D, E, F, G, H) -> I) -> A -> B -> C -> D -> E -> F -> G -> H -> I {
  return { a in { b in { c in { d in { e in { ff in { g in { h in f(a, b, c, d, e, ff, g, h) } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J>(f : (A, B, C, D, E, F, G, H, I) -> J) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in f(a, b, c, d, e, ff, g, h, i) } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K>(f : (A, B, C, D, E, F, G, H, I, J) -> K) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in f(a, b, c, d, e, ff, g, h, i, j) } } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L>(f : (A, B, C, D, E, F, G, H, I, J, K) -> L) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in { k in f(a, b, c, d, e, ff, g, h, i, j, k) } } } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M>(f : (A, B, C, D, E, F, G, H, I, J, K, L) -> M) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in { k in { l in f(a, b, c, d, e, ff, g, h, i, j, k, l) } } } } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(f : (A, B, C, D, E, F, G, H, I, J, K, L, M) -> N) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in { k in { l in { m in f(a, b, c, d, e, ff, g, h, i, j, k, l, m) } } } } } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(f : (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> O) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in { k in { l in { m in { n in f(a, b, c, d, e, ff, g, h, i, j, k, l, m, n) } } } } } } } } } } } } } }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(f : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> P) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P {
  return { a in { b in { c in { d in { e in { ff in { g in { h in { i in { j in { k in { l in { m in { n in { o in f(a, b, c, d, e, ff, g, h, i, j, k, l, m, n, o) } } } } } } } } } } } } } } }
}
