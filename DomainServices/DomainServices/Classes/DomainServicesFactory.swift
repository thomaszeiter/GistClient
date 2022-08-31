//
//  DomainServicesFactory.swift
//  
//
//  Created by Tanya Petrenko on 24.08.2022.
//

import Core

public class DomainServicesFactory {

    private let networkService = NetworkServiceFactory().buildNetworkService()

    public init() { }

    public func buildGistFilesService() -> GistFilesService {
        GistFilesServiceImpl(networkService: networkService)
    }

    public func buildGistsService() -> GistsService {
        GistsServiceImpl(networkService: networkService)
    }
}
