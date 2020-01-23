//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "25daa653111cda6ea58bab897cb0ace3"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getRequestToken
        case getWatchlist
        case createSessionId
        case login
        case webAuth
        case logout
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
                
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
                
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
                
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"

            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = logoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        
            let httpResponse = response as! HTTPURLResponse
            print(data ?? [])
            Auth.requestToken = ""
            Auth.sessionId = ""
            print("logout response: \(httpResponse.statusCode)")
            completion()
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: TMDBClient.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false,error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completion(true, nil)
                
            }catch let err {
                print(err.localizedDescription)
                completion(false, err)
            }
        }
        task.resume()
        
        
    }
    
    class func getSessionId(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postSession = PostSession(requestToken: Auth.requestToken)
        let encoder = JSONEncoder()
        let json = try! encoder.encode(postSession)
        request.httpBody = json
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let urlResponse = response as? HTTPURLResponse
            print("Response code \(String(describing: urlResponse?.statusCode))")
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(SessionResponse.self, from: data)
                Auth.sessionId = responseObject.sessionId
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        
        task.resume()
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { response, error in
            if let response = response, error == nil {
                completion(response.results, nil)
            } else {
                completion([], nil)
            }
            
        }
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        let requestTokenGetTask = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) {(data, response, error) in
            guard let data = data, error == nil else {
                completion(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let requestTokenResponse = try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = requestTokenResponse.requestToken
                completion(true, nil)
            }catch {
                completion(false, error)
            }
            
        }
        
        requestTokenGetTask.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDbResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
