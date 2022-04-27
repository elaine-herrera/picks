//
//  DataModel.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

final class DataModel: ObservableObject {
    @Published private(set) var state = ObservableState.idle
    @Published private(set) var videos = [Video]()
    @Published private(set) var persistenceState = ObservableState.idle
    @Published private(set) var favorites = [Video]()
    @Published private(set) var query = ""
    @Published private(set) var categoryState = ObservableCategoryState.idle
    @Published private(set) var categories = [Category]()
    
    var dataSourceCancellables : Set<AnyCancellable> = Set()
    var persistenceCancellables : Set<AnyCancellable> = Set()
    var categoryCancellables : Set<AnyCancellable> = Set()
    var page: Int = 1
    var categoryPage: Int = 1
    
    let dataSource: DataSource
    let persistence: Persistence
    
    init(dataSource: DataSource, persistence: Persistence){
        self.dataSource = dataSource
        self.persistence = persistence
        self.loadData()
        self.loadFavorites()
    }
    
    func loadData(){
        if state == .loading{
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
        dataSource.load(page: page)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .loaded(let videos):
                    self.videos.append(contentsOf: videos)
                    self.page += 1
                    return response
                default:
                    return response
                }
            })
            .assign(to: \.state, on: self)
            .store(in: &dataSourceCancellables)
    }
    
    func search(){
        dataSource.search(query: query, page: page)
            .receive(on: DispatchQueue.main)
            .map({ response in
                switch response {
                case .loaded(let videos):
                    self.videos.append(contentsOf: videos)
                    self.page += 1
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
        if categoryState == .loading {
            return
        }
        categoryState = .loading
        dataSource.getCategories(page: categoryPage)
            .receive(on: DispatchQueue.main)
            .map({ response -> ObservableCategoryState in
                switch response {
                case .loaded(let items):
                    self.categories.append(contentsOf: items)
                    self.categoryPage += 1
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

