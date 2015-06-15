func flatReduce<S: SequenceType, U>(sequence: S, initial: U, combine: (U, S.Generator.Element) throws -> U) throws -> U {
  var accum = initial
  for element in sequence {
    try accum = combine(accum, element)
  }
  return accum
}
