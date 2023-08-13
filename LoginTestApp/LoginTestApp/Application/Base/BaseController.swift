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

extension BaseController {
	
	func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(BaseController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
