import Foundation

private let queue = OperationQueue()

final class Task<U, T> {
  var array: ArraySlice<U>
  var result: [T]
  let transform: (U) -> T

  init(_ array: ArraySlice<U>, _ transform: (U) -> T) {
    self.array = array
    result = []
    result.reserveCapacity(array.count)
    self.transform = transform
  }

  func perform() {
    result = array.map(transform)
  }
}

private let divider = 100

func divideAndConquer<U, T>(input: [U], transform: (U) -> T) -> [T] {
  let count = Int(ceil(Double(input.count) / Double(divider)))

  var final: [T] = []
  final.reserveCapacity(input.count)

  var tasks: [Task<U, T>] = []
  tasks.reserveCapacity(divider)

  for i in 0..<divider {
    let startIndex = i*count
    let endIndex = min(i*count+count, input.endIndex) - 1
    let slice = input[startIndex...endIndex]

    let task = Task<U, T>(slice, transform)
    tasks.append(task)
  }

  queue.maxConcurrentOperationCount = divider

  tasks.forEach { task in
    queue.addOperation(task.perform)
  }
  queue.waitUntilAllOperationsAreFinished()

  for t in tasks {
    final += t.result
  }

  return final
}
