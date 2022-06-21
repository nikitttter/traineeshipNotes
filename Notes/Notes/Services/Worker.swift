//
//  Worker.swift
//  Notes
//
//  Created by Nikita Yakovlev on 18.05.2022.
//

import Foundation

protocol WorkerType {
    var delegate: WorkerDelegate? { get set }
    func fetchData()
}

protocol WorkerDelegate: AnyObject {
    func updateInterface(notes: [Note])
}

enum NetworkError: Error {
    case incorrectURL
}

class Worker: WorkerType {
    init () {
        print("class Worker has been initialized")
    }

    deinit {
        print("class Worker has been deallocated")
    }
    private lazy var session: URLSession = {
       return  URLSession(configuration: .default)
    }()

    // weak здесь необходим так как в ListViewController есть сильная ссылка на на данный класс
    weak var delegate: WorkerDelegate?

    func fetchData() {
        do {
            let task = session.dataTask(with: try createURLRequest()) { data, _, error in
                if let error = error {
                    print(error)
                    return
                }

                if let data = data {
                    do {
                        let fetchedNotes = try JSONDecoder().decode([Note].self, from: data)

                        DispatchQueue.main.async {
                            self.delegate?.updateInterface(notes: fetchedNotes)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    private func createURLRequest() throws -> URLRequest {
        guard let url = createURLComponents() else {
            throw NetworkError.incorrectURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    private func createURLComponents() -> URL? {
        var urlCoponents = URLComponents()

        urlCoponents.scheme = "https"
        urlCoponents.host = "firebasestorage.googleapis.com"
        urlCoponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        urlCoponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]

        return urlCoponents.url
    }
}
