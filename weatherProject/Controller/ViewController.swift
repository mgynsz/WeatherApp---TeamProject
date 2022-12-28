



import UIKit
import WeatherKit
import CoreLocation
//hi
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // -MARK: iboutlet
    //첫번째 뷰
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    //작년 날씨 뷰
    @IBOutlet weak var LYtempView: UIView!
    @IBOutlet weak var LYWeatherImage: UIImageView!
    @IBOutlet weak var LYWeatherLabel: UILabel!
    //캘린더 뷰
    @IBOutlet weak var calenderView: UIView!
    //기능 뷰
    @IBOutlet weak var otherOptionView: UIView!
    //테이블뷰
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    
    //    // 받아온 데이터를 저장할 프로퍼티
    //    var weather: Weather?
    //    var main: Main?
    //    var name: String?
    
    
    //서울의 좌표
    let seoul = CLLocation(latitude: 37.5666, longitude: 126.9784)
    //날씨 데이터 저장
    var weather: Weather?
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [Int] = []
    var weekWeatherMinTempArray: [Int] = []
    var weekWeatherSymbolArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ui함수
        setupUI()
        
        //view를 클릭 가능하도록 설정
        self.firstview.isUserInteractionEnabled = true
        self.calenderView.isUserInteractionEnabled = true
        self.otherOptionView.isUserInteractionEnabled = true
        //제쳐스 추가
        self.firstview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.firstViewTapped)))
        self.calenderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.calenderViewTapped)))
        self.otherOptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.otherOptionViewTapped)))
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
        
        //weatherkit 사용
        let weatherService = WeatherService.shared
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.weather = try await weatherService.weather(for: self.seoul)
                    //10일간 날씨 받아오기
                    for i in 0...9 {
                        self.weekWeatherMaxTempArray.append(Int(round(self.weather!.dailyForecast[i].highTemperature.value)))
                        self.weekWeatherMinTempArray.append(Int(round(self.weather!.dailyForecast[i].lowTemperature.value)))
                        self.weekWeatherSymbolArray.append(self.weather!.dailyForecast[i].symbolName)
                    }
                    
                    //ui세팅
                    self.weekWeatherTableView.reloadData()
                } catch {
                    print("error")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // data fetch(데이터 요청)
        //        WeatherService().getWeather { result in
        //            switch result {
        //            case .success(let weatherResponse):
        //                DispatchQueue.main.async {
        //                    self.weather = weatherResponse.weather.first
        //                    self.main = weatherResponse.main
        //                    self.name = weatherResponse.name
        //                    self.setWeatherUI()
        //                }
        //            case .failure(_ ):
        //                print("error")
        //            }
        //        }
    }
    
    func setupUI() {
        //view들 모서리 커브
        firstview.layer.cornerRadius = 15
        LYtempView.layer.cornerRadius = 15
        calenderView.layer.cornerRadius = 15
        otherOptionView.layer.cornerRadius = 15
        
        firstview.backgroundColor = UIColor(patternImage: UIImage(named: "earthBackGround")!)
    }
    
    //첫번째 뷰를 눌렀을 때
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: sender)
    }
    //캘린더뷰를 눌렀을 때
    @objc func calenderViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showCalenderView", sender: sender)
    }
    //검색뷰를 눌렀을 때
    @objc func otherOptionViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showSearchView", sender: sender)
    }
}

class WeekWeatherTableViewCell: UITableViewCell {
    //주간 날씨 테이블뷰 ui
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var weekWeatherMinTemp: UILabel!
    @IBOutlet weak var weekWeatherMaxTemp: UILabel!
    @IBOutlet weak var weekWeatherImage: UIImageView!
    @IBOutlet weak var tempProgressView: UIProgressView!
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //테이블뷰 셀의 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: "WeekWeatherTableViewCell", for: indexPath) as! WeekWeatherTableViewCell
        cell.selectionStyle = .none
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
