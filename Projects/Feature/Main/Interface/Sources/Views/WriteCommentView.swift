//
//  WriteCommentView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/8/24.
//

import FlexLayout
import Shared

import Combine
import UIKit

class WriteCommentView: UIView, UITextViewDelegate {
    
    // MARK: - Subjects & Publishers
    
    var didTapSendPublisher: AnyPublisher<String, Never> {
        return self.didTapSendSubject
            .debounce(for: 0.6, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var didChangeHeightPublisher: AnyPublisher<CGFloat, Never> {
        return self.didChangeHeightSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var didTapSendSubject: PassthroughSubject<String, Never> = .init()
    
    private var didChangeHeightSubject: PassthroughSubject<CGFloat, Never> = .init()
    
    
    // MARK: - UI components
    
    private let flexContainer = UIView()
    
    private (set) var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.backgroundColor = Colors.inputField
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textView.textContainer.lineBreakMode = .byClipping
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textColor = Colors.gray09
        textView.textContainerInset = .init(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )
        
        return textView
    }()
    
    var isEditable: Bool = true {
        didSet {
            self.textView.isEditable = self.isEditable
        }
    }
    
    private var sendCommentButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.replyActive, for: .normal)
        button.setImage(FeelinImages.replyInactive, for: .disabled)
        
        return button
    }()
    
    // Placeholder를 위한 UILabel
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글을 입력하세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04
        return label
    }()
    
    // 최대 줄 수를 계산하기 위한 속성
    private let maxNumberOfLines: Int = 5
    private var maxTextViewHeight: CGFloat = 0
    private var originalTextViewHeight: CGFloat = 0
    private var originalViewHeight: CGFloat
    
    public override init(frame: CGRect) {
        self.originalViewHeight = frame.height
        super.init(frame: frame)
        self.setUpLayout()
        self.setUpButton()
        self.setupTextView()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃을 설정
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpButton() {
        self.sendCommentButton.isEnabled = false
        self.sendCommentButton.addTarget(
            self,
            action: #selector(sendComment),
            for: .touchUpInside
        )
    }
    
    @objc private func sendComment() {
        self.didTapSendSubject.send(self.textView.text)
        
        self.textView.text = ""
        
        self.textView.resignFirstResponder()  // 키보드 닫기
        self.textView.flex.height(originalTextViewHeight).markDirty()
        self.didChangeHeightSubject.send(originalTextViewHeight + 40)
        
        self.sendCommentButton.isEnabled = false
        
        // 레이아웃 다시 계산
        self.flexContainer.flex.height(80).markDirty()
        self.flexContainer.flex.layout(mode: .adjustHeight)
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .backgroundColor(Colors.background)
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                // 텍스트뷰 컨테이너
                flex.addItem()
                    .grow(1)
                    .shrink(1)
                    .define { flex in
                        flex.addItem(textView)
                        
                        flex.addItem(placeholderLabel)
                            .position(.absolute) // placeholder는 텍스트뷰 위에 고정
                            .top(12)
                            .left(15)
                }
                    .marginLeft(20)
                
                flex.addItem(sendCommentButton)
                    .size(40)
                    .marginLeft(10)
                    .marginRight(20)
            }
    }
    
    private func setupTextView() {
        textView.delegate = self
        calculateMaxHeight()
        placeholderLabel.isHidden = !textView.text.isEmpty // 텍스트가 있을 때는 placeholder 숨김
        
        let lineHeight = textView.font?.lineHeight ?? 0
        originalTextViewHeight = lineHeight + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
    
    // 최대 줄 수에 따른 최대 높이 계산
    private func calculateMaxHeight() {
        let lineHeight = textView.font?.lineHeight ?? 0
        let textInsets = textView.textContainerInset
        maxTextViewHeight = (lineHeight * CGFloat(maxNumberOfLines)) + textInsets.top + textInsets.bottom
    }
    
    // UITextView의 내용이 변경될 때 호출
    func textViewDidChange(_ textView: UITextView) {
        // 버튼 활성화 상태 업데이트
        self.sendCommentButton.isEnabled = !textView.text.isEmpty
        
        // Placeholder 레이블을 숨기거나 표시
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // 텍스트 크기 계산
        let size = textView.sizeThatFits(
            CGSize(width: textView.frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        
        // 동적 높이 조정
        if size.height <= maxTextViewHeight {
            textView.isScrollEnabled = false
            textView.flex.height(size.height).markDirty() // FlexLayout이 크기를 다시 계산하도록 표시
            
            let changedContainerHeight: CGFloat = size.height + 40
            self.didChangeHeightSubject.send(changedContainerHeight)
            flexContainer.flex.height(changedContainerHeight).markDirty()
            
        } else {
            textView.isScrollEnabled = true
            textView.flex.height(maxTextViewHeight).markDirty() // 최대 높이로 제한
            self.didChangeHeightSubject.send(maxTextViewHeight + 40)
            flexContainer.flex.height(maxTextViewHeight + 40).markDirty()
        }
        
        // 레이아웃을 다시 정리
        flexContainer.flex.layout(mode: .adjustHeight)
    }
    
    // UITextView의 편집이 시작될 때 호출
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    // UITextView의 편집이 끝날 때 호출
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }
    }
}

//#if canImport(SwiftUI)
//import SwiftUI
//
//struct WriteCommentView_Preview: PreviewProvider {
//    static var previews: some View {
//        WriteCommentView(
//            frame: .init(
//                x: 0,
//                y: 150,
//                width: 390,
//                height: 80)
//        )
//        .showPreview()
//    }
//}
//
//#endif
