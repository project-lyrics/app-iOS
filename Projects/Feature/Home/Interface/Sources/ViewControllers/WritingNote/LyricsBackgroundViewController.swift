//
//  LyricsBackgroundViewController.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/24/24.
//

import Combine
import UIKit

import Domain
import Shared

public final class LyricsBackgroundViewController: BottomSheetViewController<LyricsBackgroundView> {
    private var selectedBackgroundIndex: Int = 0
    public let backgroundPublisher = CurrentValueSubject<LyricsBackground?, Never>(.default)

    private var cancellables = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        // 외부에서 전달된 backgroundPublisher 값을 기반으로 초기 설정
          backgroundPublisher
              .receive(on: DispatchQueue.main)
              .sink { [weak self] selectedBackground in
                  guard let self = self, let selectedBackground = selectedBackground else { return }

                  if let selectedIndex = LyricsBackground.allCases.firstIndex(of: selectedBackground) {
                      self.selectedBackgroundIndex = selectedIndex
                      let indexPath = IndexPath(item: selectedIndex, section: 0)

                      // 선택된 항목을 collectionView에서 미리 선택 상태로 설정
                      self.lyricsBackgroundCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)

                      if let cell = self.lyricsBackgroundCollectionView.cellForItem(at: indexPath) as? LyricsBackgroundCollectionViewCell {
                          cell.setSelected(true)
                      }
                  }
              }
              .store(in: &cancellables)

        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        confirmButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                backgroundPublisher.send(LyricsBackground.allCases[selectedBackgroundIndex])
                dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        lyricsBackgroundCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                if let cell = lyricsBackgroundCollectionView.cellForItem(at: indexPath) as? LyricsBackgroundCollectionViewCell {
                    let isSelected = lyricsBackgroundCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
                    cell.setSelected(isSelected)
                    confirmButton.isEnabled = isSelected
                    selectedBackgroundIndex = indexPath.row
                }
            }
            .store(in: &cancellables)
    }
}

private extension LyricsBackgroundViewController {
    var cancelButton: UIButton {
        return bottomSheetView.cancelButton
    }

    var lyricsBackgroundCollectionView: UICollectionView {
        return bottomSheetView.backgroundCollectionView
    }

    var confirmButton: UIButton {
        return bottomSheetView.confirmButton
    }
}
