//
//  Alamofire+Extension.swift
//  MomentsDemo
//
//  Created by Macro on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

extension DataRequest {
    
    private static func ObjectMapperSerializer<T: BaseMappable>(_ keyPath: String?, mapToObject object: T? = nil, context: MapContext? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            
            guard error == nil else { return .failure(error!) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                
                let JSONToMap: Any?
                if let keyPath = keyPath , keyPath.isEmpty == false {
                    JSONToMap = (value as AnyObject?)?.value(forKeyPath: keyPath)
                } else {
                    JSONToMap = value
                }
                
                if let object = object {
                    _ = Mapper<T>().map(JSONObject: JSONToMap, toObject: object)
                    return .success(object)
                } else if let parsedObject = Mapper<T>(context: context).map(JSONObject: JSONToMap){
                    return .success(parsedObject)
                }
                
                let localizedDescription = "ObjectMapper failed to serialize response."
                return .failure(NSError(domain: localizedDescription, code: -1));
            case .failure(let error):
                return .failure(error);
            }
        }
    }
    
    private static func ObjectMapperArraySerializer<T: BaseMappable>(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            
            guard error == nil else { return .failure(error!) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                
                let JSONToMap: Any?
                if let keyPath = keyPath , keyPath.isEmpty == false {
                    JSONToMap = (value as AnyObject?)?.value(forKeyPath: keyPath)
                } else {
                    JSONToMap = value
                }
                
                if let parsedObject = Mapper<T>(context: context).mapArray(JSONObject: JSONToMap){
                    return .success(parsedObject)
                }
                
                let localizedDescription = "ObjectMapper failed to serialize response."
                return .failure(NSError(domain: localizedDescription, code: -1));
            case .failure(let error):
                return .failure(error);
            }
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter object:            An object to perform the mapping on to
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    
    @discardableResult
    public func responseObject<T: BaseMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responseArray<T: BaseMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperArraySerializer(keyPath, context: context), completionHandler: completionHandler)
    }
    
    
     public func validateResponse() -> Self {
            
            var acceptableStatusCodes: [Int] { return Array(200..<300) }
            
            var acceptableContentTypes: [String] {
                if let accept = request?.value(forHTTPHeaderField: "Accept") {
                    return accept.components(separatedBy: ",")
                }
                return ["application/json", "text/xml", "text/plain"];
                //return ["*/*"]
            }
            
            return validate(contentType: acceptableContentTypes).validate { request, response, data in
                
                let statusCode = response.statusCode
                
                if acceptableStatusCodes.contains(statusCode) {
                    return .success;
                }
                
                // TODO: - 自定义处理
                if statusCode == 403 {
                    //                User.Logout();
                }
                let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
                
                var code = -1;
                var localizedDescription = "Server Error";
                
                if let JSON = result.value as? [String: AnyObject] {
                    if let msg = JSON["err"] as? String ?? JSON["error"] as? String {
                        localizedDescription = msg;
                    }
                    if let c = JSON["code"] as? String {
                        code = Int(c)!;
                    }
                }
                return .failure(NSError(code: code, localizedDescription: localizedDescription));
            }
        }
}



extension NSError {
    
    public static var CustomErrorDomain: String {
        return "com.app.error";
    }
    /**
     - parameter code:        错误码
     - parameter description: 错误描述
     
     - returns: NSError
     */
    public convenience init(domain: String = NSError.CustomErrorDomain, code: Int, localizedDescription: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription]);
    }
    
}
