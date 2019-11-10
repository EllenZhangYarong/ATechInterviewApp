//
//  DataRequest.swift
//  Celo Tech Interview
//
//  Request data from URL
//
//  Created by Ellen Zhang on 7/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import Foundation

enum DoctorError: Error{
    case noDataAvailable
    case cannotProcessData
}

struct DataRequest {
    let resourceURL: URL
    
    init(numberOfDocs: String){
        let resourceString = "https://randomuser.me/api/?results=\(numberOfDocs)"
        print(resourceString)
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    /// Get data from Rest API
    func getDoctors(completion: @escaping(Result<[DoctorDetail], DoctorError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
//                print(jsonData)
                let decoder = JSONDecoder()
                let doctorsResponse = try decoder.decode(DoctorsResponse.self, from: jsonData)

                let doctorDetail = doctorsResponse.results
//                print(doctorDetail[1])
                completion(.success(doctorDetail))
                
            }catch{
                completion(.failure(.cannotProcessData))
            }
            
        }
        dataTask.resume()
    }
}

