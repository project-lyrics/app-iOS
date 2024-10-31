//
//  BalloonView.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 6/12/24.
//

import UIKit
import SharedDesignSystem

final class BalloonView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.gray06
        label.textAlignment = .center
        label.text = "마지막에 로그인했어요"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        
        return label
    }()

    private let balloonWidth: CGFloat = 156.0
    private let balloonHeight: CGFloat = 30.0
    private let cornerRadius: CGFloat = 16.0
    private let tipWidth: CGFloat
    private let tipHeight: CGFloat

    init(tipWidth: CGFloat = 18.0, tipHeight: CGFloat = 7.0) {
        self.tipWidth = tipWidth
        self.tipHeight = tipHeight
        super.init(frame: .zero)
        setUpDefault()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUpDefault() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        isHidden = true

        addSubview(titleLabel)
        addBalloonShape()
        addTipShape()
        configureLayouts()
    }

    private func addBalloonShape() {
        let balloonPath = UIBezierPath()

        // 상단 경계선
        balloonPath.move(to: CGPoint(x: 0, y: cornerRadius))
        balloonPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        balloonPath.addLine(to: CGPoint(x: balloonWidth - cornerRadius, y: 0))
        balloonPath.addArc(withCenter: CGPoint(x: balloonWidth - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 3 * CGFloat.pi / 2, endAngle: 0, clockwise: true)
        balloonPath.addLine(to: CGPoint(x: balloonWidth, y: balloonHeight - cornerRadius))
        balloonPath.addArc(withCenter: CGPoint(x: balloonWidth - cornerRadius, y: balloonHeight - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)

        // 좌측 경계선
        balloonPath.addLine(to: CGPoint(x: balloonWidth / 2 + tipWidth / 2, y: balloonHeight))
        balloonPath.move(to: CGPoint(x: balloonWidth / 2 - tipWidth / 2, y: balloonHeight))
        balloonPath.addLine(to: CGPoint(x: cornerRadius, y: balloonHeight))
        balloonPath.addArc(withCenter: CGPoint(x: cornerRadius, y: balloonHeight - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
        balloonPath.addLine(to: CGPoint(x: 0, y: cornerRadius))

        let balloonShape = CAShapeLayer()
        balloonShape.path = balloonPath.cgPath
        balloonShape.fillColor = UIColor.white.cgColor
        balloonShape.strokeColor = Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).cgColor
        balloonShape.lineWidth = 1.0

        layer.insertSublayer(balloonShape, at: 0)
    }

    private func addTipShape() {
        let tipStartX = balloonWidth / 2 - tipWidth / 2
        let tipPath = UIBezierPath()
        tipPath.move(to: CGPoint(x: tipStartX, y: balloonHeight))
        tipPath.addLine(to: CGPoint(x: tipStartX + tipWidth / 2, y: balloonHeight + tipHeight))
        tipPath.addLine(to: CGPoint(x: tipStartX + tipWidth, y: balloonHeight))
        tipPath.close()

        // 내부를 채울 ShapeLayer
        let tipFillShape = CAShapeLayer()
        tipFillShape.path = tipPath.cgPath
        tipFillShape.fillColor = UIColor.white.cgColor
        tipFillShape.strokeColor = UIColor.clear.cgColor

        // 경계선을 그릴 ShapeLayer (V형 부분만 그리기)
        let tipBorderShape = CAShapeLayer()
        let tipBorderPath = UIBezierPath()
        tipBorderPath.move(to: CGPoint(x: tipStartX, y: balloonHeight))
        tipBorderPath.addLine(to: CGPoint(x: tipStartX + tipWidth / 2, y: balloonHeight + tipHeight))
        tipBorderPath.addLine(to: CGPoint(x: tipStartX + tipWidth, y: balloonHeight))
        tipBorderShape.path = tipBorderPath.cgPath
        tipBorderShape.fillColor = UIColor.clear.cgColor
        tipBorderShape.strokeColor =  Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).cgColor
        tipBorderShape.lineWidth = 1.0

        layer.insertSublayer(tipFillShape, at: 1)
        layer.insertSublayer(tipBorderShape, at: 2)
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: balloonHeight),
            widthAnchor.constraint(equalToConstant: balloonWidth)
        ])
    }
}
