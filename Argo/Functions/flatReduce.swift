public func flatReduce<S: SequenceType, U>(sequence: S, initial: U, combine: (U, S.Generator.Element) -> Decoded<U>) -> Decoded<U> {
  return sequence.reduce(pure(initial)) { accum, x in
    accum >>- { combine($0, x) }
  }
}
