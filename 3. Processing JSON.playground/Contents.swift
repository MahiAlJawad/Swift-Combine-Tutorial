import UIKit
import Combine

// Basic example of how we fetch data with Combine
/*
struct Post: Codable {
    let title: String
    let body: String
}

func getPosts() -> AnyPublisher<[Post], Error> {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        fatalError("Invalid url")
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: [Post].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

let cancellable = getPosts()
    .sink(
        receiveCompletion: { x in },
        receiveValue: { print($0) }
    )

*/

// Real ViewController based example
/*
struct Post: Codable {
    let title: String
    let body: String
}

class Downloader {
    static func getPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("Invalid url")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

class PostViewController {
    var posts: [Post] = [] {
        didSet {
            print("New value assigned, post count: \(posts.count)")
        }
    }
    private var cancellable: AnyCancellable?
    
    // Do this in the viewDidLoad or where Data should be loaded
    init() {
        cancellable = Downloader.getPosts()
            .catch { error in
                print(error)
                return Just([Post]())
            }
            .assign(to: \.posts, on: self)
    }
}

let postVC = PostViewController()
*/
