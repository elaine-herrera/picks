//
//  DataModel.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

final class DataModel: ObservableObject {
    @Published private(set) var state = ObservableState<VimeoResponseData<Video>>.idle
    @Published private(set) var videos = [Video]()
    @Published private(set) var query = ""
    @Published private(set) var persistenceState = ObservableState<[Video]>.idle
    @Published private(set) var favorites = [Video]()
    @Published private(set) var categoryState = ObservableState<VimeoResponseData<Category>>.idle
    @Published private(set) var categories = [Category]()
    
    var dataSourceCancellables : Set<AnyCancellable> = Set()
    var persistenceCancellables : Set<AnyCancellable> = Set()
    var categoryCancellables : Set<AnyCancellable> = Set()
    
    var page: Int = 1
    var hasMore = true
    var categoryPage: Int = 1
    var hasMoreCategories = true
    
    let dataSorce = VimeoDataSource<VimeoResponseData<Video>>()
    let categoriesDataSorce = VimeoDataSource<VimeoResponseData<Category>>()
    let persistence: Persistence
    
    init(persistence: Persistence){
        self.persistence = persistence
        self.loadData()
        self.loadFavorites()
    }
    
    func loadData(){
        if state == .loading || !hasMore {
            return
        }
        state = .loading
        if query.isEmpty{
            getStaffPicks()
        }
        else{
            search()
        }
    }
    
    func getStaffPicks(){
        let request = StaffPicksRequest(page: page)
        dataSorce.load(request: request)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .loaded(let item):
                    self.videos.append(contentsOf: item.data)
                    self.page += 1
                    if item.total == self.videos.count {
                        self.hasMore = false
                    }
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.state, on: self)
            .store(in: &dataSourceCancellables)
    }
    
    func search(){
        let request = SearchRequest(page: page, query: query)
        dataSorce.load(request: request)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .loaded(let item):
                    self.videos.append(contentsOf: item.data)
                    self.page += 1
                    if item.total == self.videos.count {
                        self.hasMore = false
                    }
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.state, on: self)
            .store(in: &dataSourceCancellables)
    }
    
    func loadDataIfNeeded(currentVideo: Video){
        let thresholdIndex = videos.index(videos.endIndex, offsetBy: -8)
        if videos.firstIndex(where: { $0.id == currentVideo.id }) == thresholdIndex {
            loadData()
        }
    }
    
    func clear(){
        for item in dataSourceCancellables{
            item.cancel()
        }
        self.videos.removeAll()
        self.state = .idle
        self.page = 1
    }
    
    func performSearch(for query: String){
        self.clear()
        self.query = query
        self.loadData()
    }
    
    func getCategories(){
        if categoryState == .loading || !hasMoreCategories{
            return
        }
        categoryState = .loading
        let request = CategoriesRequest(page: categoryPage)
        categoriesDataSorce.load(request: request)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .loaded(let item):
                    self.categories.append(contentsOf: item.data)
                    self.categoryPage += 1
                    if item.total == self.videos.count {
                        self.hasMoreCategories = false
                    }
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.categoryState, on: self)
            .store(in: &categoryCancellables)
    }
    
    func getCurrentError() -> Error? {
        switch state {
        case .idle:
            return nil
        case .loading:
            return nil
        case .failed(let error):
            return error
        case .loaded(_):
            return nil
        case .done:
            return nil
        }
    }
}

extension DataModel {
    func loadFavorites(){
        if persistenceState == .loading{
            return
        }
        persistenceState = .loading
        persistence.load()
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                    case .loaded(let videos):
                        self.favorites = videos
                        return response
                    default:
                        return response
                }
            })
            .assign(to: \.persistenceState, on: self)
            .store(in: &persistenceCancellables)
    }
    
    func save(video: Video){
        if persistenceState == .loading || favorites.contains(where: {$0.id == video.id}){
            return
        }
        persistenceState = .loading
        persistence.save(video: video)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .idle:
                    self.favorites.append(video)
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.persistenceState, on: self)
            .store(in: &persistenceCancellables)
    }
    
    func remove(video: Video){
        if persistenceState == .loading || !favorites.contains(where: {$0.id == video.id}){
            return
        }
        persistenceState = .loading
        persistence.remove(video: video)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .idle:
                    self.favorites.remove(at: self.favorites.firstIndex(where: {$0.id == video.id})!)
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.persistenceState, on: self)
            .store(in: &persistenceCancellables)
    }
    
    func clearFavorites(){
        persistence.clear()
        favorites.removeAll()
    }
}

