// This is for Tuist

import CoreLocalStorage
import CoreLocalStorageInterface
import UIKit

private func setDate5월20일19시() -> Date {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
	return dateFormatter.date(from: "2024-05-20 19:00")!
}

private func setDate5월21일19시() -> Date {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
	return dateFormatter.date(from: "2024-05-21 19:00")!
}

private let testAccessToken = AccessToken(
	token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywiZXhwIjoxNjI2NTQ2OTY2fQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
	expiration: setDate5월20일19시()
)

private let testRefreshToken = RefreshToken(
	token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywiZXhwIjoxNzAwMDAwMDAwLCJ0eXBlIjoicmVmcmVzaCJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
	expiration: setDate5월21일19시()
)

final class LocalStorageExampleViewController: UIViewController {
	private var tokenStorage = TokenStorage()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .red
//		accessTokenCRUDTest()
//		refreshTokenCRUDTest()
//		distinguish_accessToken_refreshToken_test()
	}
	
	private func accessToken_CRUDTest() {
		do {
			print("====================")
			let emptyAccessToken: AccessToken? = try tokenStorage.read(key: "testingAccessTokenKey")
			print("empty access token must be nil: \(String(describing: emptyAccessToken))")
			
			let deleteEmptyAccessTokenResult = try tokenStorage.delete(for: "testingAccessTokenKey")
			print("accessToken delete must fail b/c cannot find stored token: \(deleteEmptyAccessTokenResult)")
			
			try tokenStorage.save(token: testAccessToken, for: "testingAccessTokenKey")
			let fetchedAccessToken: AccessToken? = try tokenStorage.read(key: "testingAccessTokenKey")
			print("fetched accessToken: \(String(describing: fetchedAccessToken))")
			print("expected accessToken: \(testAccessToken)")
			
			let deleteResult = try tokenStorage.delete(for: "testingAccessTokenKey")
			print("accessToken delete success: \(deleteResult)")
			print("====================")
			
		} catch let error as KeychainError {
			print("키체인 에러: \(error.localizedDescription)")
		} catch {
			print("unknown error: \(error.localizedDescription)")
		}
	}
	
	private func refreshToken_CRUDTest() {
		do {
			print("====================")
			let emptyRefreshToken: RefreshToken? = try tokenStorage.read(key: "testingRefreshTokenKey")
			print("empty refresh token must be nil: \(String(describing: emptyRefreshToken))")
			
			let deleteEmptyRefreshTokenResult = try tokenStorage.delete(for: "testingRefreshTokenKey")
			print("refreshToken delete must fail b/c cannot find stored token: \(deleteEmptyRefreshTokenResult)")
			
			try tokenStorage.save(token: testRefreshToken, for: "testingRefreshTokenKey")
			let fetchedRefreshToken: RefreshToken? = try tokenStorage.read(key: "testingRefreshTokenKey")
			print("fetched refreshToken: \(String(describing: fetchedRefreshToken))")
			print("expected refreshToken: \(testRefreshToken)")
			
			let deleteResult = try tokenStorage.delete(for: "testingRefreshTokenKey")
			print("refreshToken delete success: \(deleteResult)")
			print("====================")
			
		} catch let error as KeychainError {
			print("키체인 에러: \(error.localizedDescription)")
		} catch {
			print("other error: \(error.localizedDescription)")
		}
	}
	
	private func distinguish_accessToken_refreshToken_test() {
		do {
			print("====================")
			let emptyAccessToken: AccessToken? = try tokenStorage.read(key: "testingAccessTokenKey")
			let emptyRefreshToken: RefreshToken? = try tokenStorage.read(key: "testingRefreshTokenKey")
			print("empty access token must be nil: \(String(describing: emptyAccessToken))")
			print("empty refresh token must be nil: \(String(describing: emptyRefreshToken))")
			
			try tokenStorage.save(token: testAccessToken, for: "testingAccessTokenKey")
			print("saved access token for key: testingAccessTokenKey")
			
			try tokenStorage.save(token: testRefreshToken, for: "testingRefreshTokenKey")
			print("saved refresh token for key: testingRefreshTokenKey")
			
			guard let fetchedAccessToken: AccessToken = try? tokenStorage.read(key: "testingAccessTokenKey") else {
				print("must fetch access token but is nil")
				return
			}
			print("fetched accessToken: \(fetchedAccessToken)")
			
			guard let fetchedRefreshToken: RefreshToken = try? tokenStorage.read(key: "testingRefreshTokenKey") else {
				print("must fetch refresh token but is nil")
				return
			}
			print("fetched refresh: \(fetchedRefreshToken)")
			
			
			let comparedTokenResult = fetchedAccessToken.token == fetchedRefreshToken.token
			let comparedTokenExpDateResult = fetchedAccessToken.expiration == fetchedRefreshToken.expiration
			print("compared token result must be false: \(comparedTokenResult)")
			print("compared token exp date must be false: \(comparedTokenExpDateResult)")
			
			let deleteAccessTokenResult = try tokenStorage.delete(for: "testingAccessTokenKey")
			print("accessToken delete success: \(deleteAccessTokenResult)")
			
			let deleteRefreshTokenResult = try tokenStorage.delete(for: "testingRefreshTokenKey")
			print("refreshToken delete success: \(deleteRefreshTokenResult)")
			print("====================")
			
		} catch let error as KeychainError {
			print("키체인 에러: \(error.localizedDescription)")
		} catch {
			print("other error: \(error.localizedDescription)")
		}
	}
}
