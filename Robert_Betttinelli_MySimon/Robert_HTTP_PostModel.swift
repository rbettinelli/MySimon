//
//  Robert_HTTP_PostModel.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-04-08.
//

import Foundation

class Robert_HTTP_PostModel {

    func Post(_ urlString: String, _ paramName: [String], _ paramValue : [String] ) {
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        var stringP : String = ""
        for p in (0 ... paramName.count-1) {
            stringP += paramName[p] + "=" + paramValue[p]
            if p < paramName.count {
                stringP += "&"
            }
            
        }

        urlRequest.httpBody = stringP.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
    
}
