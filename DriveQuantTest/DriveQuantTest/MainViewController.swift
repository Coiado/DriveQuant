//
//  ViewController.swift
//  DriveQuantTest
//
//  Created by Lucas Coiado Mota on 12/22/23.
//

import UIKit
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import CoreLocation
import DriveKitTripSimulatorModule

class MainViewController: UIViewController {
    private let mainView = MainView()
    private var viewModel = MainViewModel()
    
    override func loadView() {
        view = mainView
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationService()
        DriveKitTripAnalysis.shared.activateActivityRecording(false)
        DriveKitTripAnalysis.shared.activateAutoStart(enable: true)
        mainView.buttonSimulation.addTarget(self, action: #selector(toggleSimulation(_:)), for: .touchUpInside)
    }
    
    private func configureLocationService() {
        let status = DKDiagnosisHelper.shared.getPermissionStatus(.location)
        if status == .valid {
            viewModel.beginLocationUpdates()
        } else {
            DKDiagnosisHelper.shared.requestPermission(.location)
        }
    }
    
    @objc func toggleSimulation(_ sender: UIButton) {
        if viewModel.isSimulating {
            viewModel.stopSimulation()
        } else {
            viewModel.startSimulation()
        }
        mainView.updatedButton(selected: viewModel.isSimulating)
    }
}

extension MainViewController: MainViewModelDelegate {
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        mainView.zoomToLatestLocation(with: coordinate)
    }
    
    func setUserLocation() {
        mainView.setShowUserLocation()
    }
    
    func updateNeeded(updatedSpeed: Double?, updatedDistance: Double?) {
        DriveKitLog.shared.infoLog(tag: "", message: "")
        mainView.setSpeedLabel(speed: "Average Speed: \(String(format: "%.3f", updatedSpeed ?? 0)) km/h")
        mainView.setDistanceLabel(distance: "Distance: \(String(format: "%.3f", updatedDistance ?? 0)) km")
    }
    
}

