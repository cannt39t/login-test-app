//
//  String+PhoneNumberFormatting.swift
//  LoginTestApp
//
//  Created by Илья Казначеев on 12.08.2023.
//

import Foundation

func formatPhoneNumber(number: String) -> String {
	let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	let mask = "(XXX) XXX-XX-XX"
	var result = ""
	var index = cleanPhoneNumber.startIndex
	for ch in mask where index < cleanPhoneNumber.endIndex {
		if ch == "X" {
			result.append(cleanPhoneNumber[index])
			index = cleanPhoneNumber.index(after: index)
		} else {
			result.append(ch)
		}
	}
	return result
}

