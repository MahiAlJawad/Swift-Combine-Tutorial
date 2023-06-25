import UIKit


//-------- Example with Notification Center's default publisher --------//

/*
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
*/



//-------- Custom Subscriber Example --------//

/*
import Combine

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
 
 */


//-------- Passthrough Subject --------//
/*
import Combine

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

// Works as Subscriber
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

*/
