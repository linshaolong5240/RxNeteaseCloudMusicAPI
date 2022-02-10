//
//  RxNeteaseCloudMusicAPI.swift
//  RxNeteaseCloudMusicAPI
//
//  Created by teenloong on 2022/2/10.
//  Copyright © 2022 com.teenloong. All rights reserved.
//
import Foundation
import RxSwift
import NeteaseCloudMusicAPI

extension NeteaseCloudMusicAPI {
    public func requestObserver<Action: NCMAction>(action: Action) -> Single<Action.Response?> {
        let request = makeRequest(action: action)

        return Single.create { single in
            let task = URLSession.shared.dataTask(with: request) { responseData, response, error in
                guard error == nil else {
                    single(.failure(error!))
                    return
                }
                
                guard let data = responseData, !data.isEmpty else {
                    single(.success(nil))
                    return
                }

                do {
                    let model = try JSONDecoder().decode(action.responseType, from: data)
                    single(.success(model))
                } catch let error {
                    single(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    public func uploadObserver(action: NCMCloudUploadAction) -> Single<NCMCloudUploadResponse?> {
        let url: String =  action.host + action.uri
        if let headers = action.headers {
            requestHttpHeader.merge(headers) { current, new in
                new
            }
        }
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = action.method.rawValue
        request.allHTTPHeaderFields = action.headers
        request.httpBody = action.data
        
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: request) { responseData, response, error in
                guard error == nil else {
                    single(.failure(error!))
                    return
                }
                
                guard let data = responseData, !data.isEmpty else {
                    single(.success(nil))
                    return
                }

                do {
                    let model = try JSONDecoder().decode(action.responseType, from: data)
                    single(.success(model))
                } catch let error {
                    single(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
