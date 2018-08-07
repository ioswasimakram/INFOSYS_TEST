//
//  WebServiceHandler.swift
//  INFOSYS_TEST
//
//  Created by wasim akram on 05/08/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import Foundation
import Alamofire

enum WebApiCallServiceNumber {
    case CountryData
}

class WebServiceHandler {
    
    fileprivate let http = "http"
    fileprivate let https = "https"
    fileprivate let base = "://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/"
    fileprivate let urlCountryData = "facts.json"
    
    // GET API CALL
    func hitApiWithGetMethod(webApicallServiceNumber: WebApiCallServiceNumber, anyObject: Any?, completionHandler: @escaping (_ statusCode: Int, _ receivedData: Data?, _ parsedData: Any?) -> Void) {
        
        let urlString: String = self.getUrl(webApicallServiceNumber: webApicallServiceNumber, anyObject: anyObject)
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint("debug mode")
                debugPrint(response)
                
                if let receivedData = response.data {
                    let responseStrInISOLatin = String(data: receivedData, encoding: String.Encoding.isoLatin1)
                    guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                        print("could not convert data to UTF-8 format")
                        return
                    }
                    do {
                        let parsedData = self.parseReceivedData(receivedData: modifiedDataInUTF8Format, webApicallServiceNumber: webApicallServiceNumber)
                        completionHandler((response.response?.statusCode)!, receivedData, parsedData)
                        
                        let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                        print("responseJSONDict \(responseJSONDict)")
                    } catch {
                        print(error)
                    }
                    
                    
                }
        }
        
        
    }
    
    // Get URL
    func getUrl(webApicallServiceNumber: WebApiCallServiceNumber, anyObject: Any?) -> String {
        var url = "\(self.https)\(self.base)"
        
        if(webApicallServiceNumber == WebApiCallServiceNumber.CountryData) {
            url = url + self.urlCountryData
        }
        
        return url
    }
    
    // Parse
    func parseReceivedData(receivedData: Data?, webApicallServiceNumber: WebApiCallServiceNumber) -> Any? {
        let parserHandler = ParserHandler()
        var parsedData: Any? = nil
        
        if(webApicallServiceNumber == WebApiCallServiceNumber.CountryData) {
            parsedData = parserHandler.parseCountry(receivedData: receivedData)
        }
        
        return parsedData
    }
    
}


