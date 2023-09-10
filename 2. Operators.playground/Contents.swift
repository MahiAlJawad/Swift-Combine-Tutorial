import Foundation
import Combine
//-------- Different Operators --------//


// Without collect() operator
/*
["A", "B", "C", "D", "E"].publisher
    .sink { print($0) }

//Output:
//A
//B
//C
//D
//E
 */

/*

// With collect() operator
 
["A", "B", "C", "D", "E"].publisher
    .collect()
    .sink { collectedValues in
        print("Printing after collecting: \(collectedValues)")
    }

//Output:
//Printing after collecting: ["A", "B", "C", "D", "E"]
*/

// Collect(n) example

/*
["A", "B", "C", "D", "E"].publisher
    .collect(3)
    .sink {
        print("Printing after collecting: \($0)")
    }

//Output:
//Printing after collecting: ["A", "B", "C"]
//Printing after collecting: ["D", "E"]
*/


// Map() on publishers
/*
[1, 2, 3, 4, 5].publisher
    .map { $0*$0 } // Making square of the numbers
    .sink { print($0) }

//Output:
//1
//4
//9
//16
//25
*/

// replaceNil operator
/*
[1, 2, nil, 4].publisher
    .replaceNil(with: 0) // Replaces nil with some given default value
    .sink { print($0) }

//Output:
//Optional(1)
//Optional(2)
//Optional(0)
//Optional(4)
*/

// Scan operator
/*
let publisher = [1, 2, 3, 4, 5].publisher

publisher
    .scan([]) { result, value -> [Int] in
        return result + [value]
    }.sink { print($0) }

//Output:
//[1]
//[1, 2]
//[1, 2, 3]
//[1, 2, 3, 4]
//[1, 2, 3, 4, 5]
*/

/*
 // removeDuplicates() basically works as skipRepeats
 [1, 1, 2, 3, 1, 4, 5].publisher
 .removeDuplicates()
 .sink { print($0) }
 
 
 Output:
 //1
 //2
 //3
 //1
 //4
 //5
 */

/*
// ignoreOutput()- ignores outputs, just shows completion

[1, 1, 2, 3, 1, 4, 5].publisher
    .ignoreOutput()
    .sink(
        receiveCompletion: { print("Completed: \($0)")},
        receiveValue: { print($0) }
    )
//Output:
//Completed: finished

*/

/*
// dropFirst
[1, 1, 2, 3, 1, 4, 5].publisher
    .dropFirst(2)
    .sink { print($0) }

//Output:
//2
//3
//1
//4
//5
 
 // Note: dropWhile is a similar operator drops values when condition meets
 */

/*
// drop(untilOutputFrom: Publisher)

let taps = PassthroughSubject<Void, Never>()

let passthroughSubject = PassthroughSubject<Int, Never>()

passthroughSubject
    .drop(untilOutputFrom: taps)
    .sink { print($0) }

passthroughSubject.send(1) // will be dropped

taps.send() // now the passthroughSubject values will be sinked

passthroughSubject.send(2)

//Output:
//2

*/
/*
 
 // prefix()
 
 [1, 1, 2, 3, 1, 4, 5].publisher
 .prefix(3)
 .sink { print($0) }
 
 //Output:
 //1
 //1
 //2
 */

/*
// prefix(while: )
[1, 1, 2, 3, 1, 4, 5].publisher
    .prefix(while: { $0 < 4 }) // it will pass all values until it meets the condition, once condition met, it will not pass any more values
    .sink { print($0) }
//Output:
//1
//1
//2
//3
//1
*/

/*
// prepend(): attaches before the sequence

[1, 1, 2, 3, 1, 4, 5]
    .publisher
    .prepend([10, 11])
    .collect() // just to avoid new lines in the output :p
    .sink { print($0) }

//Output:
//[10, 11, 1, 1, 2, 3, 1, 4, 5]
 
 // Note: Similarly append() operator attaches elements at the end
*/

/*
 // switchToLatest()
 
 let publisher1 = PassthroughSubject<Int, Never>()
 let publisher2 = PassthroughSubject<Int, Never>()
 
 let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
 
 publishers
 .switchToLatest() // Will always sink the vlaues of the latest PassthroughSubject hooked to it
 .sink { print($0) }
 
 publishers.send(publisher1) // Hooked with publisher1
 
 publisher1.send(1) // will be sinked
 
 publishers.send(publisher2) // Now hooked with publisher2
 
 publisher2.send(2) // Will be sinked
 
 publisher1.send(3) // Will be ignored as the `publishers` is now hooked with publisher2
 
 //Output:
 //1
 //2
 
 */

/*
// switchToLatest example with Future<>

var index = 0
func getImageID() -> AnyPublisher<Int, Never> {
    Future<Int, Never> { result in // Future is used for async result production
        // Let's say our task takes 3 second to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            result(.success(index))
        }
    }
    .map { $0 } // Receives the result from Future and makes Publisher
    .eraseToAnyPublisher() // Converts to AnyPublisher
}

let taps = PassthroughSubject<Void, Never>()

let cancellable = taps
    .map { _ in getImageID() } // In each tap we request imageID
    .switchToLatest() // We only care about latest request result
    .sink { print("Recieved imageID: \($0)") }

taps.send() // Immediately gets 1 after 3 sec
// requests again in 4 sec, i.e. 1 sec after the first result
DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
    index += 1
    taps.send()
}

// requests again in 4.5 sec. i.e. 0.5 sec after the second request
// So the second request is ignored in switchToLatest
DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
    index += 1
    taps.send()
}

//Output:
//Recieved imageID: 0
//Recieved imageID: 2

*/

/*
// Merge

let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<Int, Never>()

publisher1.merge(with: publisher2).sink { print($0) }

publisher1.send(1)
publisher2.send(2)

//Output:
//1
//2
*/

/*
// allSatisfy
[1, 2, 3, 4, 5].publisher
    .allSatisfy { $0 % 2 == 0 }
    .sink { isAllEven in
        print(isAllEven)
    }

// Output:
// false

*/
