//
//  SpeedCalculator.swift
//  SpeedCalculator
//
//  Created by Lucas Coiado Mota on 12/22/23.
//

import Foundation
import CoreLocation

public class SpeedCalculator {
    
    public static let shared = SpeedCalculator()
    private var startCoordinate: CLLocationCoordinate2D?
    private var startDate: Date?
    public var currentDistance: Double = 0
    public var currentSpeed: Double = 0
    
    private init() {}
    
    public func calculateCrowFliesDistance(with coordinate: CLLocationCoordinate2D) -> Double {
        if startCoordinate == nil {
            self.startCoordinate = coordinate
            return 0
        } else {
            let distance = calcutateDistance(coordinate1: startCoordinate, coordinate2: coordinate)
            currentDistance = distance
            return distance
        }
    }
    
    public func calculateAverageSpeed(with coordinate: CLLocationCoordinate2D?, date: Date) -> Double {
        if startDate == nil || startCoordinate == nil {
            self.startDate = date
            self.startCoordinate = coordinate
            return 0
        } else {
            let timeDifference = (date.timeIntervalSince(startDate ?? Date()))/3600
            let distance = calcutateDistance(coordinate1: startCoordinate, coordinate2: coordinate)
            let speed = distance/timeDifference
            currentSpeed = speed
            return speed
        }
    }
    
    func calcutateDistance(coordinate1: CLLocationCoordinate2D?, coordinate2: CLLocationCoordinate2D?) -> Double {
        // Convert latitude and longitude from degrees to radians
        let lat1Rad = (coordinate1?.latitude ?? 0) * .pi / 180.0
        let lon1Rad = (coordinate1?.longitude ?? 0) * .pi / 180.0
        let lat2Rad = (coordinate2?.latitude ?? 0) * .pi / 180.0
        let lon2Rad = (coordinate2?.longitude ?? 0) * .pi / 180.0

        // Haversine formula
        let dlat = lat2Rad - lat1Rad
        let dlon = lon2Rad - lon1Rad
        let a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dlon / 2) * sin(dlon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        // Radius of the Earth in kilometers (mean value)
        let radius = 6371.0

        // Calculate the distance
        let distance = radius * c
        
        return distance
    }
    
    public func resetCalculation() {
        self.startCoordinate = nil
        self.startDate = nil
    }
    
}
