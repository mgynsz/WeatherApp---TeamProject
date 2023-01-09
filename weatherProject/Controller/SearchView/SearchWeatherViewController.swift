//
//  SearchWeatherViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2023/01/07.
//

import UIKit
import WeatherKit
import CoreLocation

class SearchWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //가장 기본 뷰
    @IBOutlet weak var backgroundView: UIView!
    
    //현재 날씨
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherRegionLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherDateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherMaxTempLabel: UILabel!
    @IBOutlet weak var weatherMinTempLabel: UILabel!
    //컬렉션뷰
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    //자외선 지수
    @IBOutlet weak var uvIndexView: UIView!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var uvIndexCateLabel: UILabel!
    @IBOutlet weak var uvIndexProgressView: UIProgressView!
    @IBOutlet weak var uvIndexExLabel: UILabel!
    
    //가시거리
    @IBOutlet weak var visibilityView: UIView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var visibilityExLabel: UILabel!
    
    //바람
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windExLabel: UILabel!
    
    //체감온도
    @IBOutlet weak var apparentTemperatureView: UIView!
    @IBOutlet weak var apparentTemperatureLabel: UILabel!
    @IBOutlet weak var apparentTemperatureExLabel: UILabel!
    
    //습도
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityExLabel: UILabel!
    
    //강수확률
    @IBOutlet weak var precipitationView: UIView!
    @IBOutlet weak var precipitationChanceLabel: UILabel!
    @IBOutlet weak var precipitaionChanceExLabel: UILabel!
    
    //테이블뷰
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    //지역정보
    var locality = ""
    var country = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var mapItemArray: [String] = []
    //날씨 데이터 저장
    var weather: Weather?
    //날씨 컨디션 저장
    var currentWeatherCondition = ""
    //시간당 온도
    var hourWeatherTempArray: [String] = []
    var hourWeatherSymbol: [String] = []
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [Int] = []
    var weekWeatherMinTempArray: [Int] = []
    var weekWeatherSymbolArray: [String] = []
    //오늘 온도, 최고 최저 온도, 심볼네임
    var currentWeatherTemp: Int = 0
    var currentWeatherSymbol = ""
    var dailyWeatherMaxTemp: Int = 0
    var dailyWeatherMinTemp: Int = 0
    //가시거리
    var currentWeatherVisibility: Int = 0
    //자외선 지수
    var currentWeatherUvIndex: Int = 0
    //풍속, 풍향
    var currentWeatherWindSpeed: Int = 0
    var currentWeatherWinddirection = ""
    //체감온도
    var currentWeatherApparentTemperature: Int = 0
    //습도
    var currentWeatherHumidity: Int = 0
    //이슬점
    var currentWeatherDewPoint: Int = 0
    //강수량
    var precipitation: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //collectionView 델리게이트 설정
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        //테이블뷰 델리케이트 설정
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        //위치 매니저 생성 및 설정
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //위치 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 업데이트
        locationManager.startUpdatingLocation()
        
        //날씨세팅
        setWeatherUI()
        runWeatherKit(latitude: latitude, longitude: longitude)
        
    }
    
    func runWeatherKit(latitude: Double, longitude: Double) {
        
        //날씨의 좌표
        let seoul = CLLocation(latitude: latitude, longitude: longitude)
        //weatherkit 사용
        let weatherService = WeatherService.shared
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.weather = try await weatherService.weather(for: seoul)
                    //10일간 날씨 받아오기
                    for i in 0...9 {
                        self.weekWeatherMaxTempArray.append(Int(round(self.weather!.dailyForecast[i].highTemperature.value)))
                        self.weekWeatherMinTempArray.append(Int(round(self.weather!.dailyForecast[i].lowTemperature.value)))
                        self.weekWeatherSymbolArray.append(self.weather!.dailyForecast[i].symbolName)
                    }
                    //현재시간 불러오기
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko")
                    formatter.dateFormat = "HH"
                    let currentHour = Int(formatter.string(from: Date()))!
                    //시간당 날씨 받아오기
                    for j in (currentHour + 2)...(currentHour + 25) {
                        self.hourWeatherTempArray.append("\(Int(round(self.weather!.hourlyForecast[j].temperature.value)))º")
                        self.hourWeatherSymbol.append(self.weather!.hourlyForecast[j].symbolName)
                    }
                    
                    //현재 날씨 받아오기
                    self.currentWeatherCondition = self.weather!.currentWeather.condition.rawValue
                    self.dailyWeatherMaxTemp = Int(round(self.weather!.dailyForecast[0].highTemperature.value))
                    self.dailyWeatherMinTemp = Int(round(self.weather!.dailyForecast[0].lowTemperature.value))
                    self.currentWeatherSymbol = self.weather!.currentWeather.symbolName
                    self.currentWeatherTemp = Int(round(self.weather!.currentWeather.temperature.value))
                    self.currentWeatherVisibility = Int(round(self.weather!.currentWeather.visibility.value / 1000))
                    self.currentWeatherUvIndex = self.weather!.currentWeather.uvIndex.value
                    self.currentWeatherWindSpeed = Int(round(self.weather!.currentWeather.wind.speed.value / 3.6))
                    self.currentWeatherWinddirection = "\(self.weather!.currentWeather.wind.compassDirection.rawValue)"
                    print(self.currentWeatherWinddirection)
                    self.currentWeatherApparentTemperature = Int(round(self.weather!.currentWeather.apparentTemperature.value))
                    self.currentWeatherHumidity = Int(round(self.weather!.currentWeather.humidity * 100))
                    self.precipitation = Int(round(self.weather!.dailyForecast[0].precipitationChance * 100))
                    self.currentWeatherDewPoint = Int(round(self.weather!.currentWeather.dewPoint.value))
                    
                    //ui세팅
                    self.currentWeatherConditionKO()
                    self.setWeatherUI()
                    self.weekWeatherTableView.reloadData()
                    self.weatherCollectionView.reloadData()
                } catch {
                    print("error")
                }
            }
        }
    }
    
    //view세팅
    func setupUI() {
        weatherView.layer.cornerRadius = 15
        uvIndexView.layer.cornerRadius = 15
        visibilityView.layer.cornerRadius = 15
        windView.layer.cornerRadius = 15
        apparentTemperatureView.layer.cornerRadius = 15
        humidityView.layer.cornerRadius = 15
        precipitationView.layer.cornerRadius = 15
        
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        weatherDateLabel.text = formatter.string(from: Date())
        
        if locality != " " {
            weatherRegionLabel.text = locality
        } else {
            weatherRegionLabel.text = country
        }
    }
    //현재 온도 세팅
    private func setWeatherUI() {
        //현재 날씨 뷰 세팅
        weatherLabel.text = currentWeatherCondition
        weatherTempLabel.text = "\(self.currentWeatherTemp)º"
        weatherMaxTempLabel.text = "최고:\(self.dailyWeatherMaxTemp)º"
        weatherMinTempLabel.text = "최저:\(self.dailyWeatherMinTemp)º"
        weatherImage.image = UIImage(named: self.currentWeatherSymbol)
        //uvIndex세팅
        uvIndexLabel.text = "\(currentWeatherUvIndex)"
        uvIndexProgressView.progress = 0.08 * Float(currentWeatherUvIndex)
        uvIndexExLabel.numberOfLines = 2
        uvIndexProgressSetup()
        //가시거리 세팅
        visibilityLabel.text = "\(currentWeatherVisibility)km"
        visibilityExLabel.numberOfLines = 2
        visibilityExLabelSetup()
        //바람 세팅
        windSpeedLabel.text = "\(currentWeatherWindSpeed)m/s"
        windExLabel.numberOfLines = 2
        windDirectionLabelSetup()
        //체감온도 세팅
        apparentTemperatureLabel.text = "\(currentWeatherApparentTemperature)º"
        apparentTemperatureExLabel.numberOfLines = 2
        apparentTemperatureExSetup()
        //습도 세팅
        humidityLabel.text = "\(currentWeatherHumidity)%"
        humidityExLabel.numberOfLines = 2
        humidityExLabel.text = "현재 이슬점이 \(currentWeatherDewPoint)º입니다."
        //강수확률 세팅
        precipitationChanceLabel.text = "\(precipitation)%"
        precipitaionChanceExLabel.numberOfLines = 2
        precipitaionChanceExLabel.text = "오늘의 강수확률은 \(precipitation)%입니다."
        
        print("가시거리: \(currentWeatherVisibility)")
        print("자외선지수: \(currentWeatherUvIndex)")
        print("바람세기: \(currentWeatherWindSpeed)")
        print("바람방향: \(currentWeatherWinddirection)")
        print("체감온도: \(currentWeatherApparentTemperature)")
        print("습도: \(currentWeatherHumidity)")
        print("강수확률: \(precipitation)")
    }
    //날씨 컨디션 케이스별 번역
    func currentWeatherConditionKO() {
        switch currentWeatherCondition {
        case "blowingDust":
            currentWeatherCondition = "먼지"
        case "clear":
            currentWeatherCondition = "맑음"
        case "cloudy":
            currentWeatherCondition = "흐림"
        case "foggy":
            currentWeatherCondition = "안개"
        case "haze":
            currentWeatherCondition = "연무"
        case "mostlyClear":
            currentWeatherCondition = "대체로 맑음"
        case "mostlyCloudy":
            currentWeatherCondition = "대체로 흐림"
        case "partlyCloudy":
            currentWeatherCondition = "한때 흐림"
        case "smoky":
            currentWeatherCondition = "연기"
        case "breezy":
            currentWeatherCondition = "미풍"
        case "windy":
            currentWeatherCondition = "바람"
        case "drizzle":
            currentWeatherCondition = "이슬비"
        case "heavyRain":
            currentWeatherCondition = "폭우"
        case "isolatedThunderstorms":
            currentWeatherCondition = "외딴뇌우"
        case "rain":
            currentWeatherCondition = "비"
        case "sunShowers":
            currentWeatherCondition = "소나기"
        case "scatteredThunderstorms":
            currentWeatherCondition = "흩어진뇌우"
        case "strongStorms":
            currentWeatherCondition = "폭풍"
        case "thunderstorms":
            currentWeatherCondition = "뇌우"
        case "frigid":
            currentWeatherCondition = "몹시 추움"
        case "hail":
            currentWeatherCondition = "우박"
        case "hot":
            currentWeatherCondition = "더움"
        case "flurries":
            currentWeatherCondition = "돌풍"
        case "sleet":
            currentWeatherCondition = "진눈깨비"
        case "snow":
            currentWeatherCondition = "눈"
        case "sunFlurries":
            currentWeatherCondition = "소낙눈"
        case "wintryMix":
            currentWeatherCondition = "눈, 비"
        case "blizzard":
            currentWeatherCondition = "눈보라"
        case "blowingSnow":
            currentWeatherCondition = "날린눈"
        case "freezingDrizzle":
            currentWeatherCondition = "언 진눈깨비"
        case "freezingRain":
            currentWeatherCondition = "얼어붙은 비"
        case "heavySnow":
            currentWeatherCondition = "폭설"
        case "hurricane":
            currentWeatherCondition = "허리케인"
        case "tropicalStorm":
            currentWeatherCondition = "열대 폭풍"
        default:
            break
        }
    }
    //가시거리 레이블 세팅
    func visibilityExLabelSetup() {
        switch currentWeatherVisibility {
        case ..<1:
            visibilityExLabel.text = "가시거리가 안개의 영향을 받습니다."
        case 2...10:
            visibilityExLabel.text = "가시거리가 실안개의 영향을 받습니다."
        case 10...20:
            visibilityExLabel.text = "가시거리가 좋은 상태입니다."
        case 20...:
            visibilityExLabel.text = "가시거리가 매우좋은 상태입니다."
        default:
            break
        }
    }
    //uv 프로그레스뷰 세팅
    func uvIndexProgressSetup() {
        switch currentWeatherUvIndex {
        case 0...2:
            uvIndexCateLabel.text = "낮음"
            uvIndexProgressView.tintColor = UIColor.lightGray
            uvIndexExLabel.text = "현재 자외선 지수는 낮음입니다."
        case 3...5:
            uvIndexCateLabel.text = "보통"
            uvIndexProgressView.tintColor = UIColor.yellow
            uvIndexExLabel.text = "현재 자외선 지수는 보통입니다."
        case 6...7:
            uvIndexCateLabel.text = "높음"
            uvIndexProgressView.tintColor = UIColor.orange
            uvIndexExLabel.text = "현재 자외선 지수는 높음입니다."
        case 8...10:
            uvIndexCateLabel.text = "매우높음"
            uvIndexProgressView.tintColor = UIColor.red
            uvIndexExLabel.text = "현재 자외선 지수는 매우높음입니다."
        case 11...:
            uvIndexCateLabel.text = "위험"
            uvIndexProgressView.tintColor = UIColor.purple
            uvIndexExLabel.text = "현재 자외선 지수는 위험입니다."
        default:
            break
        }
    }
    //바람 방향 설정
    func windDirectionLabelSetup() {
        switch currentWeatherWinddirection {
        case "east":
            windDirectionLabel.text = "동풍"
            windExLabel.text = "동쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "eastNortheast":
            windDirectionLabel.text = "동북동풍"
            windExLabel.text = "동쪽과 북동쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "eastSoutheast":
            windDirectionLabel.text = "동남동풍"
            windExLabel.text = "동쪽과 남동쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "north":
            windDirectionLabel.text = "북풍"
            windExLabel.text = "북쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "northNortheast":
            windDirectionLabel.text = "북북동풍"
            windExLabel.text = "북쪽과 북동쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "northNorthwest":
            windDirectionLabel.text = "북북서풍"
            windExLabel.text = "북쪽과 북서쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "northeast":
            windDirectionLabel.text = "북동풍"
            windExLabel.text = "북동쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "northwest":
            windDirectionLabel.text = "북서풍"
            windExLabel.text = "북서쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "south":
            windDirectionLabel.text = "남풍"
            windExLabel.text = "남쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "southSoutheast":
            windDirectionLabel.text = "남남동풍"
            windExLabel.text = "남쪽과 남동쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "southSouthwest":
            windDirectionLabel.text = "남남서풍"
            windExLabel.text = "남쪽과 남서쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "southeast":
            windDirectionLabel.text = "남동풍"
            windExLabel.text = "남동쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "southwest":
            windDirectionLabel.text = "남서풍"
            windExLabel.text = "남서쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "west":
            windDirectionLabel.text = "서풍"
            windExLabel.text = "서쪽에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "westNorthwest":
            windDirectionLabel.text = "서북서풍"
            windExLabel.text = "서쪽과 북서쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        case "westSouthwest":
            windDirectionLabel.text = "서남서풍"
            windExLabel.text = "서쪽과 남서쪽 사이에서 \(currentWeatherWindSpeed)m/s로 바람이 붑니다."
        default:
            break
        }
    }
    //체감온도 ex레이블 세팅
    func apparentTemperatureExSetup() {
        if currentWeatherTemp == currentWeatherApparentTemperature {
            apparentTemperatureExLabel.text = "실제 온도와 비슷하게 느껴집니다."
        } else if currentWeatherTemp < currentWeatherApparentTemperature {
            apparentTemperatureExLabel.text = "실제 온도보다 더 따듯하게 느껴집니다."
        } else if currentWeatherTemp > currentWeatherApparentTemperature {
            apparentTemperatureExLabel.text = "실제 온도보다 더 춥게 느껴집니다."
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("addVC"), object: mapItemArray)
        self.dismiss(animated: true)
    }
}

//컬렉션뷰 설정
extension SearchWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //컬랙션뷰 셀 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    //컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        
        let currentHour = Calendar.current
        var hourArray: [String] = ["지금"]
        
        for i in 1...23 {
            hourArray.insert(String(currentHour.component(.hour, from: Date(timeIntervalSinceNow: 3600 * Double(i)))) + "시", at: i)
        }
        
        cell.weatherCollectionDate.text = hourArray[indexPath.row]
        
        
        if self.hourWeatherTempArray.count == 24, self.hourWeatherSymbol.count == 24 {
            cell.weatherCollectionTemp.text = self.hourWeatherTempArray[indexPath.row]
            cell.weatherCollectionImage.image = UIImage(named: self.hourWeatherSymbol[indexPath.row])
        }
        
        return cell
    }
}

//테이블뷰 설정
extension SearchWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    //테이블뷰 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: "WeekWeatherTableViewCell", for: indexPath) as! WeekWeatherTableViewCell
        //DateFormatter 생성
        let formatter = DateFormatter()
        //요일만 나오도록 설정
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "ko_KR")
        //오늘은 오늘이라고 설정하고 나머지는 요일로 나타내는 배열
        var weekDayArray: [String] = ["오늘"]
        for i in 1...9 {
            weekDayArray.insert(formatter.string(from: Date(timeIntervalSinceNow: 86400 * Double(i))), at: i)
        }
        //셀에 요일 넣기
        cell.weekDay.text = weekDayArray[indexPath.row]
        //최고, 최저 온도 및
        if self.weekWeatherMaxTempArray.count == 10, self.weekWeatherSymbolArray.count == 10 {
            cell.weekWeatherMaxTemp.text = "\(self.weekWeatherMaxTempArray[indexPath.row])º"
            cell.weekWeatherMinTemp.text = "\(self.weekWeatherMinTempArray[indexPath.row])º"
            cell.weekWeatherImage.image = UIImage(named: self.weekWeatherSymbolArray[indexPath.row])
            cell.tempProgressView.progress = 0.5 + Float((self.weekWeatherMaxTempArray[indexPath.row] + self.weekWeatherMinTempArray[indexPath.row])) / 100.0
        }
        return cell
    }
}
