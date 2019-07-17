//
//  HTTPMethods.swift
//  SAT
//
//  Created by Akshay Gawade on 11/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import DynamicJSON

class HTTPMethods {
    static let defaultSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?

    class func get(url: String, completion: @escaping (JSON?,Any?)-> Void) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let products = JSON(data)
                    DispatchQueue.main.async {
                        completion(products, nil)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    


}
