//
//  Worker.swift
//  Notes
//
//  Created by Nikita Yakovlev on 18.05.2022.
//

import Foundation

protocol WorkerType {
    func fetchData(_ completion: @escaping (_ fetchedNotes: [Note]) -> Void)
}

enum NetworkError: Error {
    case incorrectURL
}

class Worker: WorkerType {
    var session: URLSession

    init (session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        print("class Worker has been initialized")
    }

    deinit {
        print("class Worker has been deallocated")
    }

    func fetchData(_ completion: @escaping (_ fetchedNotes: [Note]) -> Void) {
        do {
            let task = session.dataTask(with: try createURLRequest()) { data, _, error in
                if let error = error {
                    print(error)
                    return
                }

                if let data = data {
                    do {
                        let fetchedNotes = try JSONDecoder().decode([Note].self, from: data)
                        let onlineNotes = fetchedNotes.map({ $0.getOnlineNote() })
                        DispatchQueue.main.async {
                            completion(onlineNotes)
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
