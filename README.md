# Swift-Combine-Tutorial

## 1. Introductory Basics

### Example with Notification Center's default publisher

```swift
// Getting a publisher from Notification center for test purpose
let notification = Notification.Name("Test")
var notificationPublisher = NotificationCenter.default.publisher(for: notification)

// attaching a subscriber to the publisher
let subscription = notificationPublisher.sink { notification in
    print("Notification found: \(notification.name)")
}

// Posting a notification
NotificationCenter.default.post(name: notification, object: nil)

// Cancel the subscription when you want, it's like disposable in ReactiveSwift, its type is AnyCancellable
subscription.cancel()

// As cancelled you don't get any more notification in the subscriber block/closure
NotificationCenter.default.post(name: notification, object: nil)

//Output:
//
//Notification found: NSNotificationName(_rawValue: Test)
//
```

Note: We don't often need this, it is added as Apple's developer documentation shared this example

### Custom Subscriber Example


```swift
class CustomSubscriber: Subscriber {
    typealias Input = Int
    
    typealias Failure = Never
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received: \(input)")
        // Return how many values you want
        // You can modify (add) Demand here also
        // .none refers that you don't want to add to the initial Demand
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
    

    func receive(subscription: Subscription) {
        print("Received subscription")
        
        // Must declare initial number of values you want to observe
        // default is none
        subscription.request(.unlimited)
    }
}

let publisher = [1, 2, 3, 4, 5].publisher

publisher.subscribe(CustomSubscriber())

//Output:
//
//Received: 1
//Received: 2
//Received: 3
//Received: 4
//Received: 5
//Completed
 ```

Note: The difference between Custom subscriber and regular .sink is that .sink has by default .unlimited demand. Mostly we need sink

### Passthrough Subject

```swift
class CustomSubscriber: Subscriber {
    typealias Input = Int
    
    typealias Failure = Never
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received: \(input)")
        // Return how many values you want
        // You can modify (add) Demand here also
        // .none refers that you don't want to add to the initial Demand
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
    

    func receive(subscription: Subscription) {
        print("Received subscription")
        
        // Must declare initial number of values you want to observe
        // default is none
        subscription.request(.unlimited)
    }
}

let passthroughSubject = PassthroughSubject<Int, Never>()

// Works as Publisher
passthroughSubject.subscribe(CustomSubscriber())
 
passthroughSubject.send(1)
passthroughSubject.send(2)

// Also can receive value with default Subscriber i.e. sink

let cancellable = passthroughSubject.sink { value in
    print("Received from Sink: \(value)")
}

passthroughSubject.send(3)

cancellable.cancel()

passthroughSubject.send(4)

//Output:
//
//Received subscription
//Received: 1
//Received: 2
//Received from Sink: 3
//Received: 3
//Received: 4
```

### CurrentValueSubject

```swift
// CurrentValueSubject can just hold a value, its other functionalities are same as PassthroughSubject

let currentValueSubject = CurrentValueSubject<Int, Never>(5)

currentValueSubject.sink { print($0) }

currentValueSubject.send(6)

currentValueSubject.value = 7

//Output:
//5
//6
//7
```

## 2. Basic operators

### Collect() operator examples

```swift
// Without collect() operator

["A", "B", "C", "D", "E"].publisher
    .sink { print($0) }

//Output:
//A
//B
//C
//D
//E


// With collect() operator
 
["A", "B", "C", "D", "E"].publisher
    .collect()
    .sink { collectedValues in
        print("Printing after collecting: \(collectedValues)")
    }

//Output:
//Printing after collecting: ["A", "B", "C", "D", "E"]

// Collect(n) example

["A", "B", "C", "D", "E"].publisher
    .collect(3)
    .sink {
        print("Printing after collecting: \($0)")
    }

//Output:
//Printing after collecting: ["A", "B", "C"]
//Printing after collecting: ["D", "E"]
```

### Map()

```swift
// Map() on publishers
[1, 2, 3, 4, 5].publisher
    .map { $0*$0 } // Making square of the numbers
    .sink { print($0) }

//Output:
//1
//4
//9
//16
//25
```

### ReplaceNil() operator

```swift
[1, 2, nil, 4].publisher
    .replaceNil(with: 0) // Replaces nil with some given default value
    .sink { print($0) }

//Output:
//Optional(1)
//Optional(2)
//Optional(0)
//Optional(4)
```

### Scan() operator

```swift
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
 
 // Scan another example
 let subject = PassthroughSubject<[Int], Never>()

 let cancellable = subject
     .scan([]) { result, value in
         return result + [value]
     }
     .sink { print($0) }

 subject.send([1, 2])

 DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
     subject.send([5, 6])
 }


 //Output:
 //[[1, 2]]
 //[[1, 2], [5, 6]] // Comes after 1 seconds

 // Note: The speciality of scan() operator is you can get all the previous output and the new output together
```

### ReplaceNil() 

```swift
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
```
