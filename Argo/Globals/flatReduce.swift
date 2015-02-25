import Runes

func flatReduce<S: SequenceType, U>(sequence: S, initial: U, combine: (U, S.Generator.Element) -> U?) -> U? {
  return reduce(sequence, initial) { accum, x in
    accum >>- { combine($0, x) }
  }
}
