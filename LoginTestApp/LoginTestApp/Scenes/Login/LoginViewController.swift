//
//  LoginViewController.swift
//  LoginTestApp
//
//  Created by Илья Казначеев on 11.08.2023.
//

import UIKit

final class LoginViewController: BaseController {

	private let smileLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 36)
		label.text = R.Strings.loginSmile
		label.textAlignment = .center
		return label
	}()
	
	private let enterNumberLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15)
		label.text = R.Strings.enterPhoneNumber
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private let maskNumberLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 34)
		label.text = R.Strings.maskNumber
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private let phoneNumberTextField: UITextField = {
		let textField = UITextField()
		textField.keyboardType = .asciiCapableNumberPad
		textField.textContentType = .telephoneNumber
		textField.textColor = .label
		textField.font = .systemFont(ofSize: 34)
		let placeHolder = NSAttributedString(
			string: R.Strings.numberPlaceHolder,
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray2]
		)
		textField.attributedPlaceholder = placeHolder
		return textField
	}()
	
	private let agreementLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12)
		label.text = R.Strings.agreementOnPersonalDataProcessing
		label.textColor = .gray1
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()
	
	private let enterNumberStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()
	
	private let inputNumberStack: UIStackView = {
		let stack = UIStackView()
		stack.distribution = .equalCentering
		return stack
	}()
	
	private let fullNumberStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 4
		return stack
	}()
	
	private let mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 16
		stack.alignment = .center
		return stack
	}()
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

extension LoginViewController {
	
	override func setupViews() {
		super.setupViews()
		
		[
			smileLabel,
			enterNumberLabel
		].forEach {
			enterNumberStack.addArrangedSubview($0)
		}
		
		[
			maskNumberLabel,
			phoneNumberTextField
		].forEach {
			inputNumberStack.addArrangedSubview($0)
		}
		
		[
			enterNumberStack,
			inputNumberStack
		].forEach {
			fullNumberStack.addArrangedSubview($0)
		}
		
		[
			fullNumberStack,
			agreementLabel
		].forEach {
			mainStack.addArrangedSubview($0)
		}
		
		view.setupView(mainStack)
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		enterNumberStack.setContentHuggingPriority(.defaultLow, for: .vertical)
		phoneNumberTextField.delegate = self
		setupGestureRecognizer()
		setupNavBar()
		setupNotifications()
	}
}

extension LoginViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let previousText = textField.text ?? ""
		
		defer {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
				self?.updateNextButtonState()
			}
		}
		
		if string.isEmpty {
			let deletionIndex = range.location
			switch deletionIndex {
			case 0:
				return false
			case 1, 2, 3, 6, 7, 8, 10, 13:
				handleDelete(with: 0)
				return false
			case 4, 9, 12:
				handleDelete(with: 1)
				return false
			case 5:
				handleDelete(with: 2)
				return false
			default:
				return true
			}
			
			func handleDelete(with offset: Int) {
				let newCursorPosition = deletionIndex - offset
				textField.text?.removeSubrange(Range(NSRange(location: newCursorPosition, length: 1), in: previousText)!)
				let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition)!
				textField.text = formatPhoneNumber(number: textField.text!)
				textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
			}
		}
		
		if string.count == 12 && string.starts(with: "+7") {
			let withoutMask = String(string.suffix(string.count - 2))
			textField.text = formatPhoneNumber(number: withoutMask)
			textField.resignFirstResponder()
			return false
		} else {
			let newText = (previousText as NSString).replacingCharacters(in: range, with: string)
			let formattedNumber = formatPhoneNumber(number: newText)
			textField.text = formattedNumber
			
			let insertionIndex = range.location
			switch insertionIndex {
			case 1, 2, 6, 7, 8, 10, 11:
				handleInsert(with: 1)
			case 0, 9:
				handleInsert(with: 2)
			case 3:
				if newText.count > 4 {
					handleInsert(with: 1)
				}
			case 4:
				handleInsert(with: 3)
			default:
				break
			}
			
			func handleInsert(with offset: Int) {
				let newCursorPosition = insertionIndex + offset
				let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition)!
				textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
			}
			
			if formattedNumber.count == 15 {
				textField.resignFirstResponder()
			}
			return false
		}
	}
}

extension LoginViewController {
	
	private func setupGestureRecognizer() {
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	private func setupNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func setupNavBar() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее", style: .plain, target: self, action: #selector(nextButtonPressed))
		navigationItem.rightBarButtonItem?.tintColor = .label
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray2], for: .disabled)
	}
	
	private func updateNextButtonState() {
		let phoneNumber = phoneNumberTextField.text ?? ""
		navigationItem.rightBarButtonItem?.isEnabled = phoneNumber.count == 15
	}
}

@objc extension LoginViewController {
	
	func keyboardWillShow(sender: NSNotification) {
		self.view.frame.origin.y = -125
	}
	
	func keyboardWillHide(sender: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	func nextButtonPressed() {
		let phoneNumber = "+7 " + phoneNumberTextField.text!
		print(phoneNumber)
	}
}
