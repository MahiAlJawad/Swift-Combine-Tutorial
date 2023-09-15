import Foundation
import Combine

struct News: Codable {
    let id: Int
    let title: String
}

func getNews(by newsID: Int) -> AnyPublisher<News, Error> {
    guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json?print=pretty") else {
        return Fail(error: NSError(domain: "Wrong url", code: 401)).eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .receive(on: RunLoop.main)
        .map(\.data)
        .decode(type: News.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

func getAllNewsPublisher(with newsIDs: [Int]) -> AnyPublisher<News, Error> {
    let initialPublisher = getNews(by: newsIDs[0])
    
    return newsIDs.dropFirst() // as we took the first publisher already
        .reduce(initialPublisher) { partialResult, newsID in
            let newsPublisher = getNews(by: newsID)
            return partialResult
                .merge(with: newsPublisher)
                .eraseToAnyPublisher()
        }
}

func getNewsListPublisher(with newsIDs: [Int]) -> AnyPublisher<[News], Error> {
    getAllNewsPublisher(with: newsIDs)
        .scan([]) { result, news in
            return result + [news]
        }
        .eraseToAnyPublisher()
}

let newsIDsToFetch = [9129911, 9129199, 9127761, 9128141, 9128264, 9127792, 9129248, 9127092, 9128367]


let cancellable = getNewsListPublisher(with: newsIDsToFetch)
    .catch { _ in Empty() }
    .sink { print("News count: \($0.count)") }
