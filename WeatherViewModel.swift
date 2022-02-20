

import Foundation
import Combine
import CoreLocation
import MapKit

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    

    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["2487956","2122265","523920","796597","638242","44418","615702"])
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    private let locationManager: CLLocationManager
    
    @Published var currentLocation: CLLocation?
    @Published var currentLocationName: String
    
    override init(){
        fetcher = MetaWeatherFetcher()
        locationFetcher = MetaWeatherLocationFetcher()
        locationManager = CLLocationManager()
        //print(locationManager.authorizationStatus.rawValue)
        locationManager.requestWhenInUseAuthorization()
        currentLocationName="temp"
        super.init()
              
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
              
        for record in records{
            refresh(record: record, currentParamIndex: 0)
         
        }
        //fetchWeather(forId: "1234")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        let geocoder = CLGeocoder()
        if let location = currentLocation{
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                self.currentLocationName = placemarks![0].locality!
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var fetcher: MetaWeatherFetcher
    private var locationFetcher: MetaWeatherLocationFetcher
    
    func fetchWeather(forId woeId: String, currentParamIndex: Int, record: WeatherModel.WeatherRecord){
        let index = records.firstIndex(where: {$0.id==record.id})
		if index==0{
            locationFetcher.forecast(forId: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 50, longitude: 20))
                .sink(receiveCompletion: {completion in
                    //print(completion)
                    
                }, receiveValue: {
                    locationValue in
                    //print("START")
                    print(String(locationValue[0].woeid))
                    self.fetcher.forecast(forId: String(locationValue[0].woeid))
							.sink(receiveCompletion: {completion in
								//print(completion)
								},
								receiveValue: { [self]value in
								print(value)
                                    
                                    
                                    self.model.refreshRealData(woeId: record.woeId, currentParamIndex: currentParamIndex, value:value, currentLocationName: currentLocationName)                            
								}
                            ).store(in: &self.cancellables)
						}).store(in: &cancellables)
                    } else{
						fetcher.forecast(forId: woeId)
							.sink(receiveCompletion: {completion in},
								receiveValue: { [self]value in
								self.model.refreshRealData(woeId: woeId, currentParamIndex: currentParamIndex, value:value, currentLocationName: "")                    
					
                }).store(in: &cancellables)
                    }
    }
    
    func refresh(record: WeatherModel.WeatherRecord, currentParamIndex: Int){
        fetchWeather(forId: record.woeId, currentParamIndex: currentParamIndex, record: record)

    }
	    
    func refreshDescription(record: WeatherModel.WeatherRecord, currentParamIndex: Int){
        model.refreshDescription(record: record, currentParamIndex: currentParamIndex)
        
        
    }

}
