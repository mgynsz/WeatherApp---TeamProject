



import UIKit


class CurrentWeatherViewController: UIViewController {
    
    
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
        //searchBar 델리게이트 설정
//        searchBar.delegate = self
        //collectionView 델리게이트 설정
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        //테이블뷰 델리케이트 설정
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        //기본뷰 터치가 가능하도록 설정
        self.backgroundView.isUserInteractionEnabled = true
        //기본뷰 액션 추가
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewTapped)))
        
        //날씨세팅
        setWeatherUI()
    }
    
    //view세팅
    func setupUI() {
        weatherView.layer.cornerRadius = 15
//        searchBar.layer.cornerRadius = 15
        uvIndexView.layer.cornerRadius = 15
        visibilityView.layer.cornerRadius = 15
        windView.layer.cornerRadius = 15
        apparentTemperatureView.layer.cornerRadius = 15
        humidityView.layer.cornerRadius = 15
        precipitationView.layer.cornerRadius = 15
        
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 d일 (E)"
        weatherDateLabel.text = formatter.string(from: Date())
        
        weatherRegionLabel.text = "서울"
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
    
    //back버튼을 눌렀을때
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //기본뷰를 눌렀을때 키보드가 내려가도록 설정
    @objc func backgroundViewTapped() {
//        searchBar.resignFirstResponder()
    }
    
    //서치바 버튼이 눌렸을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //검색시작
        
        //키보드가 올라와 있을 때, 내려가도록 설정
        searchBar.resignFirstResponder()
        
        //검색어가 있는지 확인
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print("검색어: \(searchTerm)")
    }
}

//컬렉션뷰 클래스 설정
class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherCollectionImage: UIImageView!
    @IBOutlet weak var weatherCollectionDate: UILabel!
    @IBOutlet weak var weatherCollectionTemp: UILabel!
}

//컬렉션뷰 설정
extension CurrentWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            //            simbalArray.insert(weather!.dailyForecast[i - 1].symbolName, at: i - 1)
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
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
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
