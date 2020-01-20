/**
 URLSession+Synchronous.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }

    func performSynchronously(with url: URL) -> Result<(URLResponse, Data), Error> {
        let semaphore = DispatchSemaphore(value: 0)

        var res: Result<(URLResponse, Data), Error>?

        let task = dataTask(with: url) { result in
            res = result
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        return res!
    }
}
