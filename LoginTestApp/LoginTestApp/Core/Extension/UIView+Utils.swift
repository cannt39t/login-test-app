//
//  UIView+Utils.swift
//  LoginTestApp
//
//  Created by Илья Казначеев on 11.08.2023.
//

import UIKit

extension UIView {
	
	func setupView(_ view: UIView) {
		addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
	}
	
}
