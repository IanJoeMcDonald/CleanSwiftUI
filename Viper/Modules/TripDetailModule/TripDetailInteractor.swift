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

import SwiftUI

protocol TripDetailInteractorObservable {
    var trip: Trip { get }
    var mapDataProvider: MapDataProvider { get }
}

protocol TripDetailInteractorActions {
    func setTripName(_ name: String)
    func save()
    func addWaypoint()
    func moveWaypoint(fromOffsets: IndexSet, toOffset: Int)
    func deleteWaypoint(atOffsets: IndexSet)
    func updateWaypoints()
}

class TripDetailInteractor: TripDetailInteractorObservable {
    var trip: Trip
    var model: DataModel
    var mapDataProvider: MapDataProvider
    
    
    init(trip: Trip, model: DataModel, mapDataProvider: MapDataProvider) {
        self.trip = trip
        self.model = model
        self.mapDataProvider = mapDataProvider
    }
}

extension TripDetailInteractor: TripDetailInteractorActions {
    func setTripName(_ name: String) {
        trip.name = name
    }
    
    func save() {
        model.save()
    }
    
    func addWaypoint() {
        trip.addWaypoint()
    }
    
    func moveWaypoint(fromOffsets: IndexSet, toOffset: Int) {
        trip.waypoints.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func deleteWaypoint(atOffsets: IndexSet) {
        trip.waypoints.remove(atOffsets: atOffsets)
    }
    
    func updateWaypoints() {
        trip.waypoints = trip.waypoints
    }
}
