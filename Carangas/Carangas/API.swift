//
//  API.swift
//  Carros
//
//  Created by Usuário Convidado on 09/08/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import Foundation

enum RESTOperation: String {
    case save = "POST"
    case delete = "DELETE"
    case update = "PUT"
}

class API {
    
    static let path = "https://carangas.herokuapp.com/cars"
    static let session = URLSession.shared
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void) {
        guard let url = URL(string: path) else {
            print("URL não encontrada")
            return
        }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Erro na conexão:", error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Sem response")
                return
            }
            
            if response.statusCode != 200 {
                print("Status code inválido:", response.statusCode)
                return
            }
            
            guard let data = data else {
                print("Sem data")
                return
            }
            
            do {
                let cars: [Car] = try JSONDecoder().decode([Car].self, from: data)
                
                onComplete(cars)
                
            } catch {
                print("Erro ao decodificar o JSON:", error.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    class func restOperation(car: Car, restOperation: RESTOperation, onComplete: @escaping (Bool) -> Void) {
        let urlString = path + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = restOperation.rawValue
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        do {
            urlRequest.httpBody = try  JSONEncoder().encode(car)
        } catch {
            onComplete(false)
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                onComplete(false)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                onComplete(false)
                return
            }
            
            guard let _ = data else {
                onComplete(false)
                return
            }
            
            onComplete(true)
        }
        
        dataTask.resume()
    }
    
}







