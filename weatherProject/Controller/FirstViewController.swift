



import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var tempView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var mainView: UIView!
    
    var dates = 1950
    
    var temp = ["1950":"-0.32","1951":"-0.06","1952":"-0.05","1953":"0.20","1954":"-0.13","1955":"-0.12","1956":"-0.40","1957":"-0.04","1958":"0.14","1959":"0.08","1960":"-0.01","1961":"0.12","1962":"0.15","1963":"0.21","1964":"-0.22","1965":"-0.13","1966":"-0.06","1967":"0.01","1968":"-0.12","1969":"-0.09","1970":"0.04","1971":"-0.02","1972":"-0.17","1973":"0.34","1974":"-0.19","1975":"0.14","1976":"-0.24","1977":"0.25","1978":"0.10","1979":"0.17","1980":"0.31","1981":"0.53","1982":"0.12","1983":"0.50","1984":"0.07","1985":"0.10","1986":"0.30","1987":"0.45","1988":"0.58","1989":"0.36","1990":"0.66","1991":"0.53","1992":"0.25","1993":"0.35","1994":"0.48","1995":"0.78","1996":"0.35","1997":"0.64","1998":"0.98","1999":"0.78","2000":"0.63","2001":"0.85","2002":"0.96","2003":"0.95","2004":"0.82","2005":"1.10","2006":"0.98","2007":"1.13","2008":"0.90","2009":"0.91","2010":"1.15","2011":"0.92","2012":"0.97","2013":"1.03","2014":"1.02","2015":"1.41","2016":"1.53","2017":"1.40","2018":"1.20","2019":"1.41","2020":"1.57","2021":"1.34"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        yearLabel.text = "년도를 선택하세요."
        tempLabel.text = "온도"
        
        yearView.layer.cornerRadius = 10
        tempView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 0
        
        slider.value = 0.5
        
        mainView.backgroundColor = UIColor(patternImage: UIImage(named: "earthBackGround.jpeg")!)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
    }
    
    

    @IBAction func sliderChanged(_ sender: UISlider) {
        let year = 1950 + Int(sender.value * 71)
        yearLabel.text = "\(year) 년"
        tempLabel.text = temp["\(year)"]
        dates = year
    }

}
