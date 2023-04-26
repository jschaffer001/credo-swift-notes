// Note.swift
// Notes
// 
// Created by Jonathan Schaffer
// Using Swift 5.0
//
// https://jonathanschaffer.com
// Copyright © 2023 Jonathan Schaffer. All rights reserved.

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
