//
//  BaseController.swift
//  LoginTestApp
//
//  Created by Илья Казначеев on 11.08.2023.
//

import UIKit

class BaseController: UIViewController {
	
	override func loadView() {
		super.loadView()
		
		setupViews()
		constraintViews()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureAppearance()
	}
}

@objc extension BaseController {
	
	func setupViews() { }
	func constraintViews() { }
	func configureAppearance() {
		view.backgroundColor = .background
	}
}
