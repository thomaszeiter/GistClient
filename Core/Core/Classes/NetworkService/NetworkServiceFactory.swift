//
//  NetworkServiceFactory.swift
//  CoreServices
//
//  Created by Tanya Petrenko on 23.08.2022.
//

public class NetworkServiceFactory {

    public init() { }

    public func buildNetworkService() -> NetworkService {
        NetworkServiceImpl()
    }
}
