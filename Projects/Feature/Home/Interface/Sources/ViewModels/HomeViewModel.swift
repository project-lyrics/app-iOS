//
//  HomeViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain

import Combine
import Foundation

final public class HomeViewModel {
    typealias NoteFetchResult = Result<[Note], HomeError>
    typealias ArtistFetchResult = Result<[Artist], HomeError>
    
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtists: [Artist] = []
    @Published private (set) var error: HomeError?
    @Published private (set) var refreshState: RefreshState<HomeError> = .idle
    @Published private (set) var hasUncheckedNotification: Bool = false
    @Published private (set) var isFirstVisitor: Bool = false
    @Published private (set) var deleteNoteResult: DeleteNoteResult = .none
    @Published private (set) var blockUserResult: BlockUserResult<HomeError> = .none
    @Published private (set) var feelinEvent: FeelinEvent?
    @Published private (set) var fetchedBanners: [Banner] = []

    private let getNotesUseCase: GetNotesUseCaseInterface
    private let getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface
    private let checkFirstVisitorUseCase: CheckFirstVisitorUseCaseInterface
    private let blockUserUseCase: BlockUserUseCaseInterface
    private let fetchSingleEventUseCase: FetchSingleEventUseCaseInterface
    private let refuseEventUseCase: RefuseEventUseCaseInterface
    private let fetchBannersUseCase: FetchBannersUseCaseInterface

    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getNotesUseCase: GetNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface,
        checkFirstVisitorUseCase: CheckFirstVisitorUseCaseInterface,
        blockUserUseCase: BlockUserUseCaseInterface,
        fetchSingleEventUseCase: FetchSingleEventUseCaseInterface,
        refuseEventUseCase: RefuseEventUseCaseInterface,
        fetchBannersUseCase: FetchBannersUseCaseInterface
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.getFavoriteArtistsUseCase = getFavoriteArtistsUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.getHasUncheckedNotificationUseCase = getHasUncheckedNotificationUseCase
        self.blockUserUseCase = blockUserUseCase
        self.checkFirstVisitorUseCase = checkFirstVisitorUseCase
        self.fetchSingleEventUseCase = fetchSingleEventUseCase
        self.refuseEventUseCase = refuseEventUseCase
        self.fetchBannersUseCase = fetchBannersUseCase
    }
    
    func fetchHomeData(
        notesPerPage: Int = 10,
        artistsPerPage: Int = 30
    ) {
        let getBanners = self.fetchBannersUseCase.execute()
            .mapError(HomeError.init)
            .eraseToAnyPublisher()
        
        let getFavoriteArtists = self.getFavoriteArtistsUseCase.execute(
            isInitial: true,
            perPage: artistsPerPage
        )
        .mapError(HomeError.init)
        .eraseToAnyPublisher()
        
        let getRelatedNotes = self.getNotesUseCase.execute(
            isInitial: true,
            perPage: notesPerPage,
            mustHaveLyrics: false
        )
        .mapError(HomeError.init)
        .eraseToAnyPublisher()
        
        Publishers.Zip3(getBanners, getFavoriteArtists, getRelatedNotes)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let (banners, favoriteArtists, relatedNotes)):
                    self?.fetchedBanners = banners
                    self?.fetchedFavoriteArtists = favoriteArtists
                    self?.fetchedNotes = relatedNotes
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchNotes(
        isInitialFetch: Bool,
        perPage: Int = 10
    ) {
        self.getNotesUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            mustHaveLyrics: false
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let notes):
                if isInitialFetch {
                    self?.fetchedNotes = notes
                } else {
                    self?.fetchedNotes.append(contentsOf: notes)
                }
            case .failure(let error):
                self?.error = .noteError(error)
            }
        }
        .store(in: &cancellables)
       
    }
    
    func fetchFavoriteArtists(isInitialFetch: Bool) {
        self.getFavoriteArtistsUseCase.execute(
            isInitial: isInitialFetch,
            perPage: 30
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let artists):
                if isInitialFetch {
                    self?.fetchedFavoriteArtists = artists
                } else {
                    self?.fetchedFavoriteArtists.append(contentsOf: artists)
                }
            case .failure(let error):
                self?.error = .artistError(error)
            }
        }
        .store(in: &cancellables)
    }
    
    func checkForUnReadNotification() {
        self.getHasUncheckedNotificationUseCase.execute()
            .catch({ notificationError in
                return Just(false)
                    .eraseToAnyPublisher()
            })
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$hasUncheckedNotification)
    }

    func checkFirstVisitor() {
        self.checkFirstVisitorUseCase.execute()
            .catch({ isFirst in
                return Just(false)
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$isFirstVisitor)
    }
}

extension HomeViewModel {
    
    // MARK: - Refresh Data
    
    func refreshAllData() {
        let getNotesPublisher = self.getNotesUseCase.execute(
            isInitial: true,
            perPage: 10,
            mustHaveLyrics: false
        )
        .catch { [weak self] noteError in
            self?.refreshState = .failed(.noteError(noteError))
            
            return Just<[Note]>([])
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        let getFavoriteArtistsPublisher = self.getFavoriteArtistsUseCase.execute(
            isInitial: true,
            perPage: 30
        )
        .catch { [weak self] artistError in
            self?.refreshState = .failed(.artistError(artistError))
            
            return Just<[Artist]>([])
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        self.refreshState = .refreshing
        
        Publishers.Zip(
            getNotesPublisher,
            getFavoriteArtistsPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (refreshedNotes, refreshedFavoriteArtists) in
            self?.fetchedNotes = refreshedNotes
            self?.fetchedFavoriteArtists = refreshedFavoriteArtists
            
            self?.refreshState = .completed
        }
        .store(in: &cancellables)
        
    }
}

// MARK: - Like/Dislike note

extension HomeViewModel {
    func setNoteLikeState(
        noteID: Int,
        isLiked: Bool
    ) {
        guard let indexToUpdate = self.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
            return
        }
        
        self.fetchedNotes[indexToUpdate].isLiked = isLiked
        
        let originalLikesCount = self.fetchedNotes[indexToUpdate].likesCount
        
        if isLiked {
            self.fetchedNotes[indexToUpdate].likesCount = originalLikesCount + 1
        } else {
            self.fetchedNotes[indexToUpdate].likesCount = max(0, originalLikesCount - 1)
        }
        
        Just<(isLiked: Bool, noteID: Int)>((isLiked, noteID))
            .setFailureType(to: NoteError.self)
            .map { [unowned self] isLiked, noteID in
                return self.setNoteLikeUseCase.execute(
                    isLiked: isLiked,
                    noteID: noteID
                )
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let updatedNoteLike):
                    self?.fetchedNotes[indexToUpdate].likesCount = updatedNoteLike.likesCount

                case .failure(let error):
                    self?.fetchedNotes[indexToUpdate].isLiked = !isLiked
                    self?.fetchedNotes[indexToUpdate].likesCount = originalLikesCount
                    self?.error = .noteError(error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension HomeViewModel {
    func setNoteBookmarkState(
        noteID: Int,
        isBookmarked: Bool
    ) {
        guard let indexToUpdate = self.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
            return
        }
        
        self.fetchedNotes[indexToUpdate].isBookmarked = isBookmarked
        
        Just<Bool>(isBookmarked)
            .setFailureType(to: NoteError.self)
            .map { [unowned self] isBookmarked in
                return self.setBookmarkUseCase.execute(
                    isBookmarked: isBookmarked,
                    noteID: noteID
                )
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    return
                    
                case .failure(let error):
                    guard let updatedIndexToUpdate = self?.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
                        return
                    }
                    
                    self?.fetchedNotes[updatedIndexToUpdate].isBookmarked = !isBookmarked
                    self?.error = .noteError(error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Edit, Delete, Report Note

extension HomeViewModel {
    func deleteNote(id: Int) {
        self.deleteNoteUseCase.execute(noteID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedNotes.removeAll(where: { $0.id == id })

                    self?.deleteNoteResult = .success

                case .failure(let noteError):
                    self?.deleteNoteResult = .failure(noteError)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Block user

extension HomeViewModel {
    func blockUser(id: Int) {
        self.blockUserUseCase.execute(
            shouldBlock: true,
            userID: id
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success:
                self?.fetchedNotes.removeAll(where: { $0.publisher.id == id })
                self?.blockUserResult = .success
                
            case .failure(let error):
                self?.blockUserResult = .failure(.userProfileError(error))
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Event

extension HomeViewModel {
    func fetchFeelinEvent() {
        self.fetchSingleEventUseCase.execute()
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let event):
                    self?.feelinEvent = event
                    
                case .failure(let error):
                    self?.error = .eventError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func refuseEvent(eventId: Int) {
        if let feelinEvent = feelinEvent {
            self.refuseEventUseCase.execute(eventID: feelinEvent.id)
                .mapToResult()
                .sink { [weak self] result in
                    switch result {
                    case .success(let didRefuse):
                        if !didRefuse {
                            self?.error = .eventError(.unknown(errorDescription: "이벤트 거부 실패."))
                        }
                        
                        
                    case .failure(let error):
                        self?.error = .eventError(error)
                    }
                }
                .store(in: &cancellables)
            
        } else {
            self.error = .eventError(.unknown(errorDescription: "이벤트 id를 찾을 수 없습니다."))
        }
    }
    
    func fetchBanners() {
        self.fetchBannersUseCase.execute()
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let banners):
                    self?.fetchedBanners = banners
                    
                case .failure(let error):
                    self?.error = .eventError(error)
                }
            }
            .store(in: &cancellables)
    }
}
