//
//  VimeoAPIClient.swift
//  picks
//
//  Created by Elaine Herrera on 6/7/22.
//

import Foundation

final class VimeoAPIClient<T: Codable>{
    private lazy var baseURL = {
        return URL(string: "https://api.vimeo.com")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func load(request: VimeoRequest, completionHandler: @escaping (T?, Error?) -> Void){
        
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        urlRequest.addValue("bearer \("96f9ebbb129b026385cf8eb99ee1cfb8")", forHTTPHeaderField: "Authorization")
        
        let encodedURLRequest = urlRequest.encode(with: request.parameters)
        
        session.dataTask(with: encodedURLRequest){data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data
            else {
                completionHandler(nil, nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedData = try decoder.decode(T.self, from: data)
                completionHandler(decodedData, nil)
            }
            catch let parseError {
                completionHandler(nil, parseError)
            }
        }.resume()
    }
}
