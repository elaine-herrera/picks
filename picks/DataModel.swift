//
//  DataModel.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

enum ObservableState {
    case idle
    case loading
    case failed(Error)
    case loaded([Video])
}

extension ObservableState: Equatable{
    static func == (lhs: ObservableState, rhs: ObservableState) -> Bool {
        switch (lhs, rhs){
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
}

final class DataModel: ObservableObject {
    @Published private(set) var state = ObservableState.idle
    @Published private(set) var videos = [Video]()
    
    var dataSourceCancellables : Set<AnyCancellable> = Set()
    var page: Int = 1
    
    let dataSource: DataSource
    
    init(dataSource: DataSource){
        self.dataSource = dataSource
        self.loadData()
    }
    
    func loadData(){
        if state == .loading{
            return
        }
        state = .loading
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
    
    func loadDataIfNeeded(currentVideo: Video){
        let thresholdIndex = videos.index(videos.endIndex, offsetBy: -8)
        if videos.firstIndex(where: { $0.id == currentVideo.id }) == thresholdIndex {
            loadData()
        }
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
