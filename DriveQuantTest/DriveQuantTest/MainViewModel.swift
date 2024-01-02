//
//  MainViewModel.swift
//  DriveQuantTest
//
//  Created by Lucas Coiado Mota on 12/22/23.
//

import Foundation
import CoreLocation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitTripSimulatorModule
import SpeedCalculator

protocol MainViewModelDelegate: NSObject {
    func updateNeeded(updatedSpeed: Double?, updatedDistance: Double?)
    func setUserLocation()
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
}

class MainViewModel: NSObject {
    weak var delegate: MainViewModelDelegate?
    private var currentDuration: Double = 0
    private(set) var isSimulating: Bool = false
    private var currentSpeed: Double?
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        DriveKitTripAnalysis.shared.addTripListener(self)
    }
    
    deinit {
        DriveKitTripAnalysis.shared.removeTripListener(self)
    }
    
    func stopSimulation() {
        DriveKitTripSimulator.shared.stop()
        isSimulating = false
        if currentCoordinate != nil {
            self.delegate?.zoomToLatestLocation(with: currentCoordinate!)
        }
        self.delegate?.updateNeeded(updatedSpeed: 0, updatedDistance: 0)
    }
    
    func startSimulation() {
        DriveKitTripSimulator.shared.start(.shortTrip)
        SpeedCalculator.shared.resetCalculation()
        isSimulating = true
    }
    
    func beginLocationUpdates() {
        self.delegate?.setUserLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension MainViewModel: TripListener {
    func tripStarted(startMode: DriveKitTripAnalysisModule.StartMode) {}
    
    func tripFinished(post: DriveKitTripAnalysisModule.PostGeneric, response: DriveKitTripAnalysisModule.PostGenericResponse) {
        let date = Date()
        let speedText = "Average Speed: \(String(format: "%.3f", SpeedCalculator.shared.currentSpeed)) km/h"
        let distanceText = "Distance: \(String(format: "%.3f", SpeedCalculator.shared.currentDistance)) km"
        DriveKitLog.shared.infoLog(tag: date.ISO8601Format(), message: speedText)
        DriveKitLog.shared.infoLog(tag: date.ISO8601Format(), message: distanceText)
    }
    
    func tripCancelled(cancelTrip: DriveKitTripAnalysisModule.CancelTrip) {}
    
    func tripSavedForRepost() {}
    
    func tripPoint(tripPoint: TripPoint) {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(tripPoint.latitude), longitude: CLLocationDegrees(tripPoint.longitude))
        self.delegate?.zoomToLatestLocation(with: coordinate)
        let distance = SpeedCalculator.shared.calculateCrowFliesDistance(with: coordinate)
        let speed = SpeedCalculator.shared.calculateAverageSpeed(with: coordinate, date: Date())
        self.delegate?.updateNeeded(updatedSpeed: speed, updatedDistance: distance)
    }
    
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        if !isSimulating {
            self.delegate?.zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = DKDiagnosisHelper.shared.getPermissionStatus(.location)
        if status == .valid {
            beginLocationUpdates()
        }
    }
}
