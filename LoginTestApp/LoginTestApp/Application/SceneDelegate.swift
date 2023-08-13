//
//  SceneDelegate.swift
//  LoginTestApp
//
//  Created by Илья Казначеев on 11.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		let loginVC = LoginViewController()
		window.rootViewController = UINavigationController(rootViewController: loginVC)
		window.makeKeyAndVisible()
		self.window = window
	}

}
