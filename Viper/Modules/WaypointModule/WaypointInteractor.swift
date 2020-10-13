/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Combine
import CoreLocation

protocol WaypointInteractorObservalbe {
    var waypoint: Waypoint { get }
    var mapDataProvider: MapDataProvider { get }
    var suggestion: AnyPublisher<CLPlacemark, Error> { get }
}

protocol WaypointInteractorActions {
    func getLocation(for address: String)
    func apply(name: String, location: CLLocationCoordinate2D)
}

class WaypointInteractor: WaypointInteractorObservalbe {
    var waypoint: Waypoint
    var mapDataProvider: MapDataProvider
    var suggestion: AnyPublisher<CLPlacemark, Error>
    
    private var debounceTimer: Timer?
    
    init(waypoint: Waypoint, mapDataProvider: MapDataProvider) {
        self.waypoint = waypoint
        self.mapDataProvider = mapDataProvider
        self.suggestion = mapDataProvider.getLocation(for: "unknown")
    }
}

extension WaypointInteractor: WaypointInteractorActions {
    func getLocation(for address: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.suggestion = self.mapDataProvider.getLocation(for: address)
        }
    }
    
    func apply(name: String, location: CLLocationCoordinate2D) {
        waypoint.name = name
        waypoint.location = location
    }
}
