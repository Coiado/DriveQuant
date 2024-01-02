//
//  MainView.swift
//  DriveQuantTest
//
//  Created by Lucas Coiado Mota on 12/22/23.
//

import UIKit
import MapKit
import CoreLocation

class MainView: UIView {

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var averageSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Average Speed: 0 km/h"
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance: 0 km"
        return label
    }()
    
    lazy var buttonSimulation: UIButton = {
        let button = UIButton()
        button.setTitle("Start Simulation", for: .normal)
        button.setTitle("Stop Simulation", for: .selected)
        button.backgroundColor = .blue
        return button
    }()
    
    let annotation = MKPointAnnotation()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(mapView)
        addSubview(averageSpeedLabel)
        addSubview(distanceLabel)
        addSubview(buttonSimulation)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        averageSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonSimulation.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            averageSpeedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            averageSpeedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            distanceLabel.topAnchor.constraint(equalTo: self.averageSpeedLabel.bottomAnchor, constant: 20),
            distanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mapView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonSimulation.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 20),
            buttonSimulation.widthAnchor.constraint(equalToConstant: 170),
            buttonSimulation.heightAnchor.constraint(equalToConstant: 60),
            buttonSimulation.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setDistanceLabel(distance: String) {
        distanceLabel.text = distance
    }
    
    func setSpeedLabel(speed: String) {
        averageSpeedLabel.text = speed
    }
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        annotation.coordinate = coordinate
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func setShowUserLocation() {
        mapView.showsUserLocation = true
        mapView.addAnnotation(annotation)
    }
    
    func updatedButton(selected: Bool) {
        if selected {
            buttonSimulation.isSelected = selected
            buttonSimulation.backgroundColor = .red
        } else {
            buttonSimulation.isSelected = selected
            buttonSimulation.backgroundColor = .blue
        }
    }
    
}
