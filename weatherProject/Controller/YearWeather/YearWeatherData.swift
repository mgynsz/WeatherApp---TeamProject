//
//  YearWeather.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/13.
// Weather.swift
import Foundation

// MARK: - WeatherData
struct YearWeatherData: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [[String: String]]
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
