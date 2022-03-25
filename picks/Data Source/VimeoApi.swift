//
//  VimeoApi.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Security
import Combine
import Foundation

class VimeoApi {
    static let shared = VimeoApi()
    static var clientId = ""
    static var accessToken = ""
    static var clientSecret = ""
    static var endpoint = ""
    static var currentPage: Int64 = 1
    static var pagination = 20
    static var hasMorePages = true
    
    private init(){
        do {
            let fileName = "VimeoApiList"
            let dict = try read(fileNamed: fileName)
            VimeoApi.clientId = dict["clientId"] ?? ""
            VimeoApi.clientSecret = dict["clientSecret"] ?? ""
            VimeoApi.endpoint = dict["oauthEndpoint"] ?? ""
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    func read(fileNamed: String) throws -> [String: String] {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: "plist"),
            let plistData = FileManager.default.contents(atPath: path) else {
                throw ClientError.missingApiConfig
        }
        var format = PropertyListSerialization.PropertyListFormat.xml
        return try PropertyListSerialization.propertyList(from: plistData,
                                                          options: .mutableContainersAndLeaves,
                                                          format: &format) as! [String: String]
    }
    
    /// Request access token
    func requestAccessToken(completionHandler: @escaping (Bool, Error?) -> Void){
         
        let endpoint = VimeoApi.endpoint
        let params = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "scope", value: "public")
        ]
        guard var request = buildRequest(for: endpoint, params: params, httpMethod: "POST") else {
            completionHandler(false, NSError())
            return
        }
        
        let credentials = "\(VimeoApi.clientId):\(VimeoApi.clientSecret)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentials.base64EncodedString()
        
        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                completionHandler(false, error)
                return
            }
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard status == 200 else {
                completionHandler(false, ClientError.invalidServerResponse)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(VimeoAuthenticationResponse.self, from: data!)
                VimeoApi.accessToken = decodedData.accessToken
            }
            catch let parseError {
                completionHandler(false, parseError)
            }
            completionHandler(true, nil)
        }.resume()
    }
    
    /// Get Staff Picks
    func getStaffPicks(page: Int, completionHandler: @escaping ([Video], Error?) -> Void) {
        
        let endpoint = "https://api.vimeo.com/channels/staffpicks/videos"
        let params = buildPaginatedQuery(for: page)
        guard let request = buildRequest(for: endpoint, params: params) else {
            completionHandler([], NSError())
            return
        }
        
        if VimeoApi.accessToken.isEmpty {
            VimeoApi.shared.requestAccessToken{ result, error in
                if result {
                    self.authenticatedRequest(request: request, page: page, completionHandler: completionHandler)
                }
                else{
                    completionHandler([], ClientError.invalidAccessToken)
                }
            }
        }
        else {
            self.authenticatedRequest(request: request, page: page, completionHandler: completionHandler)
        }
    }
    
    /// Performs a paginated search request
    /// (e.g) https://api.vimeo.com/videos?query=live+music
    func search(query: String, page: Int, completionHandler: @escaping ([Video], Error?) -> Void) {
        
        let endpoint = "https://api.vimeo.com/videos"
        var params = buildPaginatedQuery(for: page)
        params.append(URLQueryItem(name: "query", value: "\(query)"))
        
        guard let request = buildRequest(for: endpoint, params: params) else {
            completionHandler([], NSError())
            return
        }
        
        if VimeoApi.accessToken.isEmpty {
            VimeoApi.shared.requestAccessToken{ result, error in
                if result {
                    self.authenticatedRequest(request: request, page: page, completionHandler: completionHandler)
                }
                else{
                    completionHandler([], ClientError.invalidAccessToken)
                }
            }
        }
        else {
            self.authenticatedRequest(request: request, page: page, completionHandler: completionHandler)
        }
    }
}

extension VimeoApi {
    
    private func buildRequest(for endpoint: String, params: [URLQueryItem], httpMethod: String = "GET") -> URLRequest?{
        var urlBuilder = URLComponents(string: endpoint)
        urlBuilder?.queryItems = params
        
        guard let url = urlBuilder?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request = setHeaders(for: request)
        return request
    }
    
    /// Set common header fields por Vimeo api URLRequest
    private func setHeaders(for request: URLRequest) -> URLRequest{
        var result = request
        result.addValue("application/json", forHTTPHeaderField: "Content-Type")
        result.addValue("application/vnd.vimeo.*+json;version=3.4", forHTTPHeaderField: "Accept")
        return result
    }
    
    ///Get common filters for Vimeo api URLRequest query params
    private func buildPaginatedQuery(for page: Int) -> [URLQueryItem] {
        return [URLQueryItem(name: "filter", value: "content_rating"),
                URLQueryItem(name: "filter_content_rating", value: "safe"),
                URLQueryItem(name: "per_page", value: "\(VimeoApi.pagination)"),
                URLQueryItem(name: "page", value: "\(page)")]
    }
    
    ///Performs an authenticated request that returns a list of videos
    private func authenticatedRequest(request: URLRequest, page: Int, completionHandler: @escaping ([Video], Error?) -> Void){
        var _request = request
        _request.addValue("bearer \(VimeoApi.accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: _request){ data, response, error in
            if let error = error {
                completionHandler([], error)
                return
            }
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard status == 200 else {
                completionHandler([], ClientError.invalidServerResponse)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedData = try decoder.decode(VimeoResponseData.self, from: data!)
                let videos = decodedData.data
                completionHandler(videos, nil)
            }
            catch let parseError {
                completionHandler([], parseError)
            }
        }.resume()
    }
}

