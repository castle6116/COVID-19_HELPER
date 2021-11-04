//
//  VaccineViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/26.
//

import UIKit
import KeychainSwift
import Alamofire
import CoreLocation
import NMapsMap

class VaccineViewController: UIViewController, NMFMapViewDelegate , NMFMapViewTouchDelegate {
    @IBOutlet var gubun: UILabel!
    @IBOutlet var first_inoculation: UILabel!
    @IBOutlet var complete_inoculation: UILabel!
    @IBOutlet var add_inoculation: UILabel!
    @IBOutlet var today_1st: UILabel!
    @IBOutlet var today_ok: UILabel!
    @IBOutlet var today_add: UILabel!
    @IBOutlet var today_sil_1st: UILabel!
    @IBOutlet var today_sil_ok: UILabel!
    @IBOutlet var today_sil_add: UILabel!
    @IBOutlet var yesterday_1st: UILabel!
    @IBOutlet var yesterday_ok: UILabel!
    @IBOutlet var yesterday_add: UILabel!
    @IBOutlet var background_view: UIView!
    @IBOutlet var VaccineCollection: UICollectionView!
    @IBOutlet var NMFMap: NMFNaverMapView!
    @IBOutlet var SwitchButton: SwitchButton!
    
    var locationManager = CLLocationManager() // location1
    var currentLocation: CLLocation! // 내 위치 저장
    var vaccineCenter = [Address]()
    
    var Locationset = CLLocation(latitude: 37.576029, longitude: 126.976920)
    
    var city = "대구광역시"
    
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NMFMap.isHidden = true
        NMFMap.mapView.delegate = self
        NMFMap.mapView.touchDelegate = self
        NMFMap.showLocationButton = true
        NMFMap.showZoomControls = true

        NMFMap.mapView.positionMode = .normal
        
        VaccineCollection.delegate = self
        VaccineCollection.dataSource = self
        
        SwitchButton.delegate = self
        SwitchButton.isOn = true
        
        locationManager.delegate = self // location3
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        textSet()
        if locationManager.authorizationStatus == .notDetermined || locationManager.authorizationStatus == .restricted || locationManager.authorizationStatus == .denied {
            locationManagerDidChangeAuthorization(locationManager)
            print("위치 서비스 Off 상태")
        } else {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() //위치 정보 받아오기 시작
            currentLocation = locationManager.location
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "백신 현황"
    }
    
    func naverMapSetting(){
        infoWindow.dataSource = dataSource
        for vaccine in vaccineCenter{
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: Double(vaccine.lat)!, lng: Double(vaccine.lng)!)
            marker.mapView = NMFMap.mapView
            
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    // 정보 창이 열린 마커의 tag를 텍스트로 노출하도록 반환
                    self?.dataSource.title = marker.userInfo["tag"] as! String
                    // 마커를 터치할 때 정보창을 엶
                    self?.infoWindow.open(with: marker)
                }
                return true
            };
            marker.touchHandler = handler
            
            marker.captionText = vaccine.centerName
            marker.subCaptionText = vaccine.facilityName
            marker.subCaptionColor = UIColor.blue
            marker.subCaptionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 200.0/255.0, alpha: 1)
            marker.subCaptionTextSize = CGFloat(10)
            
            var centerLocation = CLLocationCoordinate2D()
            centerLocation.latitude = Double(vaccine.lat)!
            centerLocation.longitude = Double(vaccine.lng)!
            
            var Location = CLLocationCoordinate2D()
            Location.latitude = (locationManager.location?.coordinate.latitude) ?? 37.5780117795279
            Location.longitude = (locationManager.location?.coordinate.longitude) ?? 126.97689768711622
            
            marker.userInfo = ["tag": "거리 : \(String(format : "%.3f",centerLocation.distance(from: Location)/1000))km / 전화번호 : \(vaccine.phoneNumber)"]
        }
        naverMapCamera()
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
    }
    
    func naverMapCamera(){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: (locationManager.location?.coordinate.latitude) ?? 37.5780117795279, lng: (locationManager.location?.coordinate.longitude) ?? 126.97689768711622))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 2
        NMFMap.mapView.moveCamera(cameraUpdate)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

            switch manager.authorizationStatus {
                case .authorizedAlways , .authorizedWhenInUse:
                    break
                case .notDetermined , .restricted:
                    break
                case .denied :
                    getLocationUsagePermission()
                    break
                default:
                    break
            }
    }
    
    // 라벨들 동그랗게 만들고 그림자 넣었는데 안뜨고 텍스트 내용 넣어주기
    func textSet(){
        gubun.layer.cornerRadius = 5
        gubun.layer.masksToBounds = true
        first_inoculation.layer.cornerRadius = 5
        first_inoculation.layer.masksToBounds = true
        complete_inoculation.layer.cornerRadius = 5
        complete_inoculation.layer.masksToBounds = true
        add_inoculation.layer.cornerRadius = 5
        add_inoculation.layer.masksToBounds = true
        
        
        background_view.layer.borderWidth = 1
        background_view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        background_view.backgroundColor = .clear
        
        background_view.layer.cornerRadius = 15
        
        background_view.layer.shadowColor = UIColor.black.cgColor
        background_view.layer.masksToBounds = false
        background_view.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        background_view.layer.shadowRadius = 10
        background_view.layer.shadowOpacity = 1
        
        VaccineHttp(day : 0){
            vaccine in
            if let vaccine = vaccine{
                if vaccine.currentCount == 0{
                    VaccineHttp(day: -1){
                        vaccine in
                        if let vaccine = vaccine{
                            self.yesterday_1st.text = self.DecimalWon(value: vaccine.data[0].accumulatedFirstCnt) // 어제 1차 접종
                            self.yesterday_ok.text = self.DecimalWon(value: vaccine.data[0].accumulatedSecondCnt) // 어제 접종완료
                            self.yesterday_add.text = self.DecimalWon(value: vaccine.data[0].accumulatedThirdCnt) // 어제 추가접종
                            self.today_sil_1st.text = "+\(self.DecimalWon(value: vaccine.data[0].firstCnt))" // 오늘 1차접종 인원 추가 수
                            self.today_sil_ok.text = "+\(self.DecimalWon(value: vaccine.data[0].secondCnt))" // 오늘 접종완료 인원 추가 수
                            self.today_sil_add.text = "+\(self.DecimalWon(value: vaccine.data[0].thirdCnt))" // 부스터샷 인원 추가 수
                            self.today_1st.text = self.DecimalWon(value: vaccine.data[0].totalFirstCnt) // 오늘 1차 접종
                            self.today_ok.text = self.DecimalWon(value: vaccine.data[0].totalSecondCnt) // 오늘 2차 접종
                            self.today_add.text = self.DecimalWon(value: vaccine.data[0].totalThirdCnt) // 오늘 3차 접종
                        }
                    }
                }else{
                    self.yesterday_1st.text = self.DecimalWon(value: vaccine.data[0].accumulatedFirstCnt) // 어제 1차 접종
                    self.yesterday_ok.text = self.DecimalWon(value: vaccine.data[0].accumulatedSecondCnt) // 어제 접종완료
                    self.yesterday_add.text = self.DecimalWon(value: vaccine.data[0].accumulatedThirdCnt) // 어제 추가접종
                    self.today_sil_1st.text = "+\(self.DecimalWon(value: vaccine.data[0].firstCnt))" // 오늘 1차접종 인원 추가 수
                    self.today_sil_ok.text = "+\(self.DecimalWon(value: vaccine.data[0].secondCnt))" // 오늘 접종완료 인원 추가 수
                    self.today_sil_add.text = "+\(self.DecimalWon(value: vaccine.data[0].thirdCnt))" // 부스터샷 인원 추가 수
                    self.today_1st.text = self.DecimalWon(value: vaccine.data[0].totalFirstCnt) // 오늘 1차 접종
                    self.today_ok.text = self.DecimalWon(value: vaccine.data[0].totalSecondCnt) // 오늘 2차 접종
                    self.today_add.text = self.DecimalWon(value: vaccine.data[0].totalThirdCnt) // 오늘 3차 접종
                }
                
            }
            
        }
        VaccineCenterHttp(){
            center in
            if let center = center{
                for sido in center.data{
                    let first = CLLocationCoordinate2D(latitude: Double(sido.lat)! , longitude: Double(sido.lng)!)
                    let base = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude) ?? self.Locationset.coordinate.latitude, longitude: (self.locationManager.location?.coordinate.longitude) ?? self.Locationset.coordinate.longitude)
                    let one = first.distance(from: base)
                    
                    if one < 15000{
                        self.vaccineCenter.append(sido)
                    }
                }
                
                self.vaccineCenter.sort{
                    (first , second) -> Bool in
                    let first = CLLocationCoordinate2D(latitude: Double(first.lat)! , longitude: Double(first.lng)!)
                    let second = CLLocationCoordinate2D(latitude: Double(second.lat)!, longitude: Double(second.lng)!)
                    let base = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude) ?? self.Locationset.coordinate.latitude, longitude: (self.locationManager.location?.coordinate.longitude) ?? self.Locationset.coordinate.longitude)
                    let one = first.distance(from: base)
                    let two = second.distance(from: base)
                    return one < two
                }
                DispatchQueue.main.async {
                    self.VaccineCollection.reloadData()
                }
//                let geocoder = CLGeocoder()
//                let locale = Locale(identifier: "Ko-kr")
//                //원하는 언어의 나라 코드를 넣어주시면 됩니다.
//                geocoder.reverseGeocodeLocation(self.currentLocation ?? self.Locationset, preferredLocale: locale, completionHandler:{
//                    (placemarks, error) in
//                    if let address: [CLPlacemark] = placemarks {
//                        if let name: String = address.last?.administrativeArea {
//                            self.city = name
//                            print(name)
//                        } //도시 확인
//                    }
//                  도시명 필요시 여기에 삽입
//                })
                self.naverMapSetting()
            }
        }
        
    }
    
    // , 찍어주는 함수
    func DecimalWon(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
            
        return result
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

func VaccineHttp(day: Int ,complation : ((Vaccine?) -> ())?){
    let url = "https://api.odcloud.kr/api/15077756/v1/vaccine-stat"
    let headers : HTTPHeaders = ["Content-Type":"application/json; charset=UTF-8"]
    let key = "2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz/1j863w=="
    let today_nomal = Date()
    let fomat_today_days = DateFormatter()
    fomat_today_days.dateFormat = "yyyy-MM-dd"
//    let today = fomat_today_days.string(from: today_nomal)
    let test = Calendar.current.date(byAdding: .day, value: day, to: today_nomal)!
    let today = fomat_today_days.string(from: test)
    
    
    print("오늘날짜 : ",today)
    AF.request(url,
               method: .get,
               parameters: ["perPage" : 1, "serviceKey" : key, "cond[baseDate::GTE]" : today],
               encoding: URLEncoding.default,
               headers: headers)
        .responseJSON{
            (response) in
//            let statusCode = response.response?.statusCode
        switch response.result{
        case .success(let obj):
//                obj = String(data: response.data!, encoding: .utf8)
            print("GET 성공")
            if obj is NSDictionary{
                do{
                    //obj를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    // JSON Decoder 사용
                    let getInstanceData = try JSONDecoder().decode(Vaccine.self, from: dataJSON)
//                        print("예방 접종 현황 : ",getInstanceData)
                    complation!(getInstanceData)
                    
                }catch{
                    print(obj)
                    print("예방 접종 현황 에러 : ",error)
                }
            }
        case.failure(let error):
            print("예방 접종 현황 에러 : ",error.localizedDescription)
        }
    }
}

func VaccineCenterHttp(complation : ((Center?) -> ())?){
    let url = "https://api.odcloud.kr/api/15077586/v1/centers"
    let headers : HTTPHeaders = ["Content-Type":"application/json; charset=UTF-8"]
    let key = "2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz/1j863w=="
    AF.request(url,
               method: .get,
               parameters: ["perPage" : 284, "serviceKey" : key],
               encoding: URLEncoding.default,
               headers: headers)
        .responseJSON{
            (response) in
//            let statusCode = response.response?.statusCode
        switch response.result{
        case .success(let obj):
//                obj = String(data: response.data!, encoding: .utf8)
            print("GET 성공")
            if obj is NSDictionary{
                do{
                    //obj를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    // JSON Decoder 사용
                    let getInstanceData = try JSONDecoder().decode(Center.self, from: dataJSON)
//                        print("예방 접종 현황 : ",getInstanceData)
                    complation!(getInstanceData)
                    
                }catch{
                    print(obj)
                    print("예방 접종 센터 에러 : ",error)
                }
            }
        case.failure(let error):
            print("예방 접종 센터 에러 : ",error.localizedDescription)
        }
    }
}

extension VaccineViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vaccineCenter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineCollectionCell", for: indexPath) as? HospitalCollection else {
                    return UICollectionViewCell()
                }
        var centerLocation = CLLocationCoordinate2D()
        centerLocation.latitude = Double(vaccineCenter[indexPath.row].lat)!
        centerLocation.longitude = Double(vaccineCenter[indexPath.row].lng)!
//        var EPSG3857result = getCoordinatesInEPSG3857(longitudeInEPSG4326: Double(vaccineCenter[indexPath.row].lng)!,latitudeInEPSG4326: Double(vaccineCenter[indexPath.row].lat)!)
//        print(EPSG3857result , "이거야")
        
        var Location = CLLocationCoordinate2D()
        Location.latitude = (locationManager.location?.coordinate.latitude) ?? 37.5780117795279
        Location.longitude = (locationManager.location?.coordinate.longitude) ?? 126.97689768711622
        cell.backgroundColor = UIColor.init(red: 0.945, green: 0.961, blue: 0.965, alpha: 1)
        cell.HospitalCenter.text = vaccineCenter[indexPath.row].centerName
        cell.HospitalName.text = vaccineCenter[indexPath.row].facilityName
        cell.HospitalNum.text = vaccineCenter[indexPath.row].phoneNumber
        cell.HospitalAddress.text = vaccineCenter[indexPath.row].address
        cell.HospitalDistance.text = "\(String(format : "%.3f",centerLocation.distance(from: Location)/1000))km"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    // 4326 to 3857
    func getCoordinatesInEPSG3857(longitudeInEPSG4326: Double, latitudeInEPSG4326: Double) -> (Double, Double) {
        let longitudeInEPSG3857 = (longitudeInEPSG4326 * 20037508.34 / 180)
        let latitudeInEPSG3857 = (log(tan((90 + latitudeInEPSG4326) * Double.pi / 360)) / (Double.pi / 180)) * (20037508.34 / 180)

        return (longitudeInEPSG3857, latitudeInEPSG3857)
    }
}

extension VaccineViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
        //location4
        let alter = UIAlertController(title: "위치권한 설정이 '허용안함' 혹은 \n'한번만 사용'으로 되어있습니다.", message: "'아니오'를 선택하시면 정확한 정보를 표출할 수 없습니다.\n앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
            (action: UIAlertAction) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
        }
        let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
            (action: UIAlertAction) in
            
        }
        alter.addAction(logNoAction)
        alter.addAction(logOkAction)
        self.present(alter, animated: true, completion: nil)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locationManager.location
        
        DispatchQueue.main.async {
            self.VaccineCollection.reloadData()
        }
    }
        
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CLLocationCoordinate2D {
    ///   Returns distance from coordianate in meters.
    /// - Parameter from: coordinate which will be used as end point.
    /// - Returns: Returns distance in meters.
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}

extension VaccineViewController: SwitchButtonDelegate {
  func isOnValueChange(isOn: Bool) {
      if isOn == true{
          NMFMap.isHidden = false
      }else{
          NMFMap.isHidden = true
      }
      
  }
}


class HospitalCollection: UICollectionViewCell{
    @IBOutlet var HospitalName: UILabel!
    @IBOutlet var HospitalAddress: UILabel!
    @IBOutlet var HospitalNum: UILabel!
    @IBOutlet var HospitalDistance: UILabel!
    @IBOutlet var HospitalCenter: UILabel!
}
