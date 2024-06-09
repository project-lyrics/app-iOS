//
//  AppleOAuthService.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import AuthenticationServices
import Combine
import CoreNetworkInterface
import Foundation
import DomainOAuthInterface


extension AppleLoginService: OAuthServiceInterface, UserVerifiable {
    public func login() -> AnyPublisher<OAuthResult, AuthError> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

        return appleTokenSubject
            .eraseToAnyPublisher()
            .mapError(AuthError.appleOAuthError)
            .map { ($0, OAuthProvider.apple) }
            .flatMap(verifyUser)
            .eraseToAnyPublisher()
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            appleTokenSubject.send(completion: .failure(.unknown))
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken else {
            appleTokenSubject.send(completion: .failure(.tokenMissing))
            return
        }
        
        let identityToken =  String(
            decoding: identityTokenData,
            as: UTF8.self
        )
        
        self.appleTokenSubject.send(identityToken)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleTokenSubject.send(
            completion: .failure(.init(error: error))
        )
    }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return UIWindow()
        }
        
        return window
    }
}
