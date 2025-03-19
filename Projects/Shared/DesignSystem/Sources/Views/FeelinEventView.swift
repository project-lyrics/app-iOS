//
//  FeelinEventView.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 2/23/25.
//

import UIKit

public final class FeelinEventView: UIView {
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        // 이미지뷰가 스택뷰를 벗어나서 커지지 않는 세팅
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var feedbackButton: FeelinConfirmButton =  {
        let button = FeelinConfirmButton(
            initialEnabled: true,
            title: ""
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private var imageHeightConstraint: NSLayoutConstraint = .init()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // layoutSubviews에서 이미지 크기를 조정한다.
        self.adjustImageHeight()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        
        self.addSubview(activityIndicator)
        self.addSubview(feedbackButton)
        self.stackView.addArrangedSubview(eventImageView)
        self.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 인디케이터 위치
            activityIndicator.centerXAnchor.constraint(equalTo: eventImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.feedbackButton.topAnchor),
            
            feedbackButton.heightAnchor.constraint(equalToConstant: 55),
            feedbackButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            feedbackButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            feedbackButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22)
        ])
    }
    
    public func loadImage(
        from url: URL,
        retryCount: Int = 3
    ) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let image = self.processImageData(data, error: error) {
                    self.eventImageView.image = image
                    self.activityIndicator.stopAnimating()
                } else if retryCount > 0 {
                    self.retryLoadingImage(from: url, retryCount: retryCount - 1)
                }
            }
        }.resume()
    }

    private func processImageData(_ data: Data?, error: Error?) -> UIImage? {
        if let error = error {
            return nil
        }
        guard let data = data, let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    private func retryLoadingImage(from url: URL, retryCount: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.loadImage(from: url, retryCount: retryCount)
        }
    }
    
    private func adjustImageHeight() {
        let imageViewWidth: CGFloat = self.frame.width
        
        let defaultAspectRatio: CGFloat = 1.25
        
        var calculatedHeight = imageViewWidth * defaultAspectRatio
        
        // 새로운 높이로 업데이트
        imageHeightConstraint = eventImageView.heightAnchor.constraint(equalToConstant: calculatedHeight)
        imageHeightConstraint.isActive = true
    }
    
    public func setButton(
        title: String,
        onTap: (() -> Void)?
    ) {
        self.feedbackButton.setupButton(title: title)
        self.feedbackButton.addAction(
            .init(handler: {
                _ in
                onTap?()
            }),
            for: .touchUpInside
        )
    }
}
