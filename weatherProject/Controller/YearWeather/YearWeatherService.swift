//
//  YearWeatherService.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/13.
// WeatherService.swift
import Foundation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class YearWeatherService {
    
    // .plist에서 API Key 가져오기
    private var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: "keyList", ofType: "plist") else {
                fatalError("Couldn't find file 'KeyList.plist'.")
            }
            
            // .plist를 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "YEARWEATHER_KEY") as? String else {
                fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
            }
            return value
        }
    }
    
    func getWeather(regionCode: Int, date: Int, completion: @escaping (Result<YearWeatherData, NetworkError>) -> Void) {
        // API 호출을 위한 URL
        let url = URL(string: "http://apis.data.go.kr/1360000/AsosDalyInfoService/getWthrDataList?serviceKey=\(apiKey)&numOfRows=1&pageNo=1&dataType=JSON&dataCd=ASOS&dateCd=DAY&startDt=\(date)&endDt=\(date)&stnIds=\(regionCode)")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            // Data 타입으로 받은 리턴을 디코드
            let weatherResponse = try? JSONDecoder().decode(YearWeatherData.self, from: data)
            
            // 성공
            if let weatherResponse = weatherResponse {
                completion(.success(weatherResponse)) // 성공한 데이터 저장
            } else {
                completion(.failure(.decodingError))
            }
        }.resume() // 이 dataTask 시작
    }
}
