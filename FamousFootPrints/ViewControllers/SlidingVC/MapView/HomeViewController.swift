//
//  HomeViewController.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit
import NavigationDrawer
import CoreLocation
import GoogleMaps
import Alamofire
import SwiftyJSON
import GooglePlaces

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    //MARK: Variables
    var locManager = CLLocationManager()
      var currentLocation: CLLocation!
    private var placesClient: GMSPlacesClient!
    var address = ""
    var latitude = 0.00
    var longitude = 0.00
    //1.
    let interactor = Interactor()
//MARK: Outlets
    @IBOutlet weak var bar: UINavigationItem!
    @IBOutlet weak var contentView: GMSMapView!
    @IBOutlet weak var btnOutletShowCurrentLocation: UIButton!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var txtfieldCurrent: UITextField!
    @IBOutlet weak var txtFieldCurrentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldCurrentHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        locManager.delegate = self
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageChange(str: "ar")
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageChange(str: "en")
        }
                locManager.delegate = self
                locManager.startUpdatingLocation()
                currentLocation = locManager.location
                txtfieldOptions()
        for gesture in contentView.gestureRecognizers! {
            contentView.removeGestureRecognizer(gesture)
        }

    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        currentLocationofPerson()
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Default functions for textfield in didLoad()
    func txtfieldOptions(){
        txtFieldSearch.leftView = UIImageView(image: UIImage(named: "googleMaps"))
        txtFieldSearch.leftViewMode = .always
        txtfieldCurrent.leftView = UIImageView(image: UIImage(named: "circle"))
        txtfieldCurrent.leftViewMode = .always
        txtfieldCurrent.isUserInteractionEnabled = true
        getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")

    }
    //MARK: TextField Action
    
    
    @IBAction func txtFieldPutorCurrentLocation(_ sender: UITextField) {
       
    }
    
    
    
    @IBAction func placeTextFieldTouchDown(_ sender: UITextField) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        //Specify a filter
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.countries = ["IN"]
        autocompleteController.autocompleteFilter = filter
        
        //Specify the place data types to return
        let fields: GMSPlaceField = [.name, .placeID]
        autocompleteController.placeFields = fields
       
        //Display the autocomplete view controller
        present(autocompleteController,animated: true,completion: nil)
        
    }
    //MARK: Button Action
    @IBAction func btnActionCurrentLocation(_ sender: UIButton) {
        print("Button Clicked")
        currentLocation = locManager.location
        getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 23.0)
                contentView.camera = camera
                let mapView = self.contentView
                mapView?.animate(to: camera)
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                marker.title = "Current Location"
               marker.snippet = self.address
        print(marker)
                DispatchQueue.main.async {
                    marker.map = mapView
                }
          }

    //MARK: Bar Button Function
    //2.
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSlidingMenu", sender: nil)
    }
    //MARK: Gesture Function
    
    //3. Add a Pan Gesture to slide the menu from Certain Direction
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)

        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)

        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
        }
    }
    //MARK: Functions
    
    // key - AIzaSyCN9pHA2o5bEBUJqF05gyaDnSnpsgZ1QGM
  
   
    func languageChange(str: String){
        self.bar.title = "Map View".localizableString(loc: str)
    }
    //4. Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
            
            #warning("From iOS 13, you need to make presentationStyle to fullScreen.")
            destinationViewController.modalPresentationStyle = .fullScreen

        }
    }
  
}


//5. Exten BaseVC
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            let animator = PresentMenuAnimator(direction: .Right)
            animator.shadowOpacity = 0.1
            return animator

        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            let animator = PresentMenuAnimator(direction: .Left)
            animator.shadowOpacity = 0.1
            return animator

        }
        let animator = PresentMenuAnimator(direction: .Left)
        animator.shadowOpacity = 0.1
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
 }
//MARK: Extensions
extension HomeViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "none")")
           print("Place ID: \(place.placeID ?? "none")")
        print("Place attributions: \(place.attributions?.string ?? "none")")
        print(place.addressComponents as Any)
        
        
        if let name = place.name{
            txtFieldSearch.text = name
        }
        dismiss(animated: true, completion: nil)
        contentView.clear()
        getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")
        let key : String = "AIzaSyDgZnsbYL3VqU1Xdw8sM9-V8F0cwR4sr4I"
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        let parameters = ["address":place.name ?? "nil"
                          ,"key":key]
            AF.request(url, parameters: parameters).response{
                response in debugPrint(response.data as Any)
                let data = JSON(response.data as Any)
                print(data)
                let long = data["results"][0]["geometry"]["location"]["lng"].double
                let lat = data["results"][0]["geometry"]["location"]["lat"].double
                print(lat as Any)
                print(long as Any)
                self.latitude = lat ?? 0.00
                self.longitude = long ?? 0.00
                let cor2D = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                print(cor2D)
                let marker = GMSMarker()
                marker.position = cor2D
                marker.title = "Location"
                let mapView = self.contentView
                marker.snippet = place.name
                marker.map = mapView
                self.currentLocationofPerson()
            }
    }
    func currentLocationofPerson(){
        let orilatitude = currentLocation.coordinate.latitude
        let orilongitude = currentLocation.coordinate.longitude
        let startLocation = CLLocation(latitude: orilatitude, longitude: orilongitude)
        
        
        let destLat = self.latitude
        let destLong = self.longitude
        let endLocation = CLLocation(latitude: destLat, longitude: destLong)
        
        let origin = "\(orilatitude),\(orilongitude)"
        let destination = "\(destLat),\(destLong)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDgZnsbYL3VqU1Xdw8sM9-V8F0cwR4sr4I"
        
       
        AF.request(url).response { response in
            guard let data = response.data else{
                return
            }
            do{
                let jsonData = try JSON(data: data)
                print(jsonData)
               
                let routes = jsonData["routes"].arrayValue
                print(routes)
               
                for route in routes{
                    let overViewPolyLine = route["overview_polyline"].dictionary
                    print(overViewPolyLine)
                    let points = overViewPolyLine?["points"]?.string
                    print(points as Any)
                    if points != nil{
                        let path = GMSPath.init(fromEncodedPath: points ?? "")
                        let polyLine = GMSPolyline.init(path: path)
                        polyLine.strokeColor = .blue
                        polyLine.strokeWidth = 4
                        let mapView = self.contentView
                        polyLine.map = mapView!
                        print(polyLine.description)
                        var bounds = GMSCoordinateBounds()

                        for index in 1...(path?.count())! {
                            bounds = bounds.includingCoordinate((path?.coordinate(at: index))!)
                          }

                        mapView?.animate(with: GMSCameraUpdate.fit(bounds))
                       
                        
                    }
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
        let oriMarker = GMSMarker()
        oriMarker.position = CLLocationCoordinate2D(latitude: orilatitude, longitude: orilongitude)
        oriMarker.map = self.contentView
        
        
        let destMarker = GMSMarker()
        destMarker.position = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
        destMarker.map = self.contentView
        
        let distance = startLocation.distance(from: endLocation)
        print(distance)
        
        let kilometres = distance / 1000
        print(kilometres)
        if kilometres <= 10{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 15)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
           
        }else if kilometres <= 50{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 12)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
            
        }else if kilometres <= 100{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 10)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
           
        }else if kilometres <= 200{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 9)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
           
        }else if kilometres <= 400{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 8)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
            
        }else{
            let camera = GMSCameraPosition(target: oriMarker.position, zoom: 7)
            contentView.camera = camera
            let mapView = self.contentView
            mapView?.animate(to: camera)
            
        }
        contentView.bringSubviewToFront(txtFieldSearch)
        contentView.bringSubviewToFront(btnOutletShowCurrentLocation)
        contentView.bringSubviewToFront(txtfieldCurrent)
       
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
        print(lat,lon)
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        { [self](placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country as Any)
                        print(pm.locality as Any)
                        print(pm.subLocality as Any)
                        print(pm.thoroughfare as Any)
                        print(pm.postalCode as Any)
                        print(pm.subThoroughfare as Any)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        print(addressString)
                        self.address = addressString
                        txtfieldCurrent.text = addressString
                  }
            })
        }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ",error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
