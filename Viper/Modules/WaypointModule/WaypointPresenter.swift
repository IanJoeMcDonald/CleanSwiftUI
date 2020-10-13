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

import Combine
import SwiftUI
import CoreLocation

protocol WaypointPresenterObservable: ObservableObject {
    var query: String { get set }
    var info: String { get set }
    var name: String { get set }
    var location: CLLocationCoordinate2D { get set }
    var isValid: Bool { get set }
}

protocol WaypointPresenterActions {
    func handleQuery(_ publisher: AnyPublisher<CLPlacemark, Error>)
}

class WaypointPresenter: WaypointPresenterObservable {
  @Published var query: String = ""
  @Published var info: String = "No results"
  @Published var name: String = "unknown"
  @Published var location: CLLocationCoordinate2D
  @Published var isValid: Bool = false

  private var cancellables = Set<AnyCancellable>()

  private let interactor: WaypointInteractorObservalbe

  private func formatInfo(_ placemark: CLPlacemark) -> String {
    var info = placemark.name ?? "unknown"
    if let city = placemark.locality {
      info += ", \(city)"
    }
    if let state = placemark.administrativeArea {
      info += ", \(state)"
    }
    return info
  }

  init(interactor: WaypointInteractorObservalbe) {
    self.interactor = interactor
    location = interactor.waypoint.location
    query = interactor.waypoint.name
  }
}

extension WaypointPresenter: WaypointPresenterActions {
    func handleQuery(_ suggestion: AnyPublisher<CLPlacemark, Error>) {
      suggestion
        .map { self.formatInfo($0) }
        .catch { _ in Empty<String, Never>() }
        .assign(to: \.info, on: self)
        .store(in: &cancellables)

      suggestion
        .map { $0.name }
        .replaceNil(with: "unknown")
        .catch { _ in Empty<String, Never>() }
        .assign(to: \.name, on: self)
        .store(in: &cancellables)

      suggestion
        .map { $0.location }
        .replaceNil(with: CLLocation(latitude: 0, longitude: 0))
        .catch { _ in Empty<CLLocation, Never>() }
        .map { $0.coordinate }
        .assign(to: \.location, on: self)
        .store(in: &cancellables)

      suggestion
        .map { _ in true }
        .catch {_ in Just<Bool>(false) }
        .assign(to: \.isValid, on: self)
        .store(in: &cancellables)
    }
}
