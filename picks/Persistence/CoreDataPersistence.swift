//
//  CoreDataPersistence.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import CoreData
import Combine

enum CoreDataError: Error {
    case invalidData
}

struct CoreDataPersistence {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "picks")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension CoreDataPersistence: Persistence {
    func load() -> AnyPublisher<ObservableState<[Video]>, Never> {
        return Future<ObservableState, Never>{ promise in
            load(){ result, error in
                if error == nil {
                    promise(.success((.loaded(result))))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }
    
    func save(video: Video) -> AnyPublisher<ObservableState<[Video]>, Never> {
        return Future<ObservableState, Never>{ promise in
            save(video: video){ result, error in
                if error == nil {
                    promise(.success(.idle))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }
    
    func remove(video: Video) -> AnyPublisher<ObservableState<[Video]>, Never> {
        return Future<ObservableState, Never>{ promise in
            remove(video: video){ result, error in
                if error == nil {
                    promise(.success(.idle))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }

    func clear() {
        do {
            let deleteVideosRequest = NSBatchDeleteRequest(fetchRequest: VideoEntity.fetchRequest())
            let deleteUsersRequest = NSBatchDeleteRequest(fetchRequest: UserEntity.fetchRequest())
            try container.viewContext.execute(deleteVideosRequest)
            try container.viewContext.execute(deleteUsersRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}

extension CoreDataPersistence {
    private func load(completionHandler: @escaping ([Video], Error?) -> Void){
        let viewContext = container.viewContext
        var result = [Video]()
        
        do {
            let objects = try viewContext.fetch(VideoEntity.fetchRequest())
            for videoEntity in objects {
                let fetchRequest = UserEntity.fetchRequest()
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == %@", "\(videoEntity.userId!)")
                
                let object = try viewContext.fetch(fetchRequest)
            
                guard let userEntity = object.first else { continue }
                let video = loadVideo(videoEntity: videoEntity, userEntity: userEntity)
                result.append(video)
            }
        }
        catch {
            completionHandler([], error)
            return
        }
        completionHandler(result, nil)
    }
    
    func loadUser(userEntity: UserEntity) -> User {
        var userSizes = [Picture.Image]()
        let usersPictures = userEntity.pictures?.allObjects as? [PictureEntity]
        for size in usersPictures ?? []{
            let newElement = Picture.Image(height: Int(size.height), width: Int(size.width), linkWithPlayButton: nil, link: size.link ?? "")
            userSizes.append(newElement)
        }
        
        let user = User(id: userEntity.id!, name: userEntity.name, pictures: Picture(sizes: userSizes), location: userEntity.location, shortBio: userEntity.bio, link: userEntity.link)
        
        return user
    }
    
    func loadVideo(videoEntity: VideoEntity, userEntity: UserEntity) -> Video {
        let user = loadUser(userEntity: userEntity)
        
        var sizes = [Picture.Image]()
        let set = videoEntity.pictures?.allObjects as? [PictureEntity]
        for size in set ?? []{
            let newElement = Picture.Image(height: Int(size.height), width: Int(size.width), linkWithPlayButton: size.linkWithPlayButton ?? "", link: size.link ?? "")
            sizes.append(newElement)
        }
        let pictures = Picture(sizes: sizes)
        let meta = Metadata(connections: Metadata.Connections(likes: Metadata.Connections.Likes(total: Int(videoEntity.likes))))
        
        let video = Video(id: videoEntity.id!, name: videoEntity.name, releaseTime: videoEntity.releaseTime, description: videoEntity.descriptionInfo, status: videoEntity.status, metadata: meta, pictures: pictures, link: videoEntity.link, uri: videoEntity.uri, duration: Int(videoEntity.duration), language: videoEntity.language, user: user)
        
        return video
    }
    
    func save(video: Video, completionHandler: @escaping (Bool, Error?) -> Void) {
        print("Saving video ID: \(video.id)")
        let viewContext = container.viewContext
        var videoEntity = VideoEntity(context: viewContext)
        videoEntity = saveData(video: video, entity: videoEntity)
        
        guard let user = video.user else {
            completionHandler(false, CoreDataError.invalidData)
            return
        }
        
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(user.id)")
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            var userEntity: UserEntity!
            
            if objects.isEmpty {
                userEntity = UserEntity(context: viewContext)
                userEntity = saveData(user: user, entity: userEntity)
            }
            else{
                userEntity = objects.first
            }
            
            videoEntity.user = userEntity
            videoEntity.userId = userEntity.id
            
            if objects.isEmpty {
                userEntity = savePictures(user: user, entity: userEntity)
            }
            videoEntity = savePictures(video: video, entity: videoEntity)
    
            try viewContext.save()
        }
        catch {
            completionHandler(false, error)
            return
        }
        completionHandler(true, nil)
    }
    
    func saveData(video: Video, entity: VideoEntity) -> VideoEntity {
        entity.id = video.id
        entity.name = video.name
        entity.releaseTime = video.releaseTime
        entity.descriptionInfo = video.description
        entity.status = video.status
        entity.link = video.link
        entity.uri = video.uri
        entity.duration = Int32(video.duration ?? 0)
        entity.language = video.language
        entity.likes = Int32(video.metadata.connections.likes.total ?? 0)
        return entity
    }
    
    func saveData(user: User, entity: UserEntity) -> UserEntity {
        entity.id = user.id
        entity.name = user.name
        entity.location = user.location
        entity.bio = user.shortBio
        entity.link = user.link
        return entity
    }
    
    func savePictures(video: Video, entity: VideoEntity) -> VideoEntity {
        guard let sizes = video.pictures?.sizes else {
            return entity
        }
        let viewContext = container.viewContext
        for size in sizes {
            let picture = PictureEntity(context: viewContext)
            picture.id = UUID()
            picture.width = Int32(size.width)
            picture.height = Int32(size.height)
            picture.link = size.link
            picture.linkWithPlayButton = size.linkWithPlayButton
            entity.addToPictures(picture)
        }
        return entity
    }
    
    func savePictures(user: User, entity: UserEntity) -> UserEntity {
        guard let sizes = user.pictures?.sizes else {
            return entity
        }
        let viewContext = container.viewContext
        for size in sizes {
            let picture = PictureEntity(context: viewContext)
            picture.id = UUID()
            picture.width = Int32(size.width)
            picture.height = Int32(size.height)
            picture.link = size.link
            entity.addToPictures(picture)
        }
        return entity
    }
    
    //Video relationship with pictures delete rule is Cascade
    //User relationship with pictures delete rule is Cascade
    //Deletes user if this is the only video refering the entity
    func remove(video: Video, completionHandler: @escaping (Bool, Error?) -> Void) {
        print("Removing video ID: \(video.id)")
        let fetchRequest = VideoEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(video.id)")
        do {
            let context = container.viewContext
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if object.user?.videos?.count == 1 {
                    if let userId = object.user?.id {
                        remove(userId: userId)
                    }
                }
                context.delete(object)
            }
            try context.save()
        } catch {
            completionHandler(false, error)
            return
        }
        completionHandler(true, nil)
    }
    
    func remove(userId: String){
        print("Removing user ID: \(userId)")
        let fetchRequest = UserEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(userId)")
        do {
            let context = container.viewContext
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
        }catch {
            return
        }
    }
}



