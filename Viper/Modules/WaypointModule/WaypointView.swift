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
import Combine
import CoreLocation
import MapKit

struct WaypointView<Presenter: WaypointPresenterObservable>: View {
    @Environment(\.presentationMode) var mode
    
    var interactor: WaypointInteractorActions
    @ObservedObject var presenter: Presenter
    
    private var query: Binding<String> {
        Binding<String> (
            get: { presenter.query },
            set: { interactor.getLocation(for: $0) }
        )
    }
    
    init(interactor: WaypointInteractorActions, presenter: Presenter) {
        self.interactor = interactor
        self.presenter = presenter
    }
    
    func applySuggestion() {
        interactor.apply(name: presenter.name, location: presenter.location)
        mode.wrappedValue.dismiss()
    }
    
    var body: some View {
        return
            VStack{
                Spacer()
                VStack {
                    TextField("Type an Address", text: query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Text(presenter.info)
                        Spacer()
                        Button(action: applySuggestion) {
                            Text("Use this")
                        }.disabled(!presenter.isValid)
                    }
                    
                }.padding([.horizontal])
                MapView(center: presenter.location)
            }.navigationBarTitle(Text(""), displayMode: .inline)
    }
}

#if DEBUG
struct WaypointView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        let waypoint = model.trips[0].waypoints[0]
        let provider = RealMapDataProvider()
        
        return
            Group {
                NavigationView {
                    let interactor = WaypointInteractor(waypoint: waypoint, mapDataProvider: provider)
                    let presenter =  WaypointPresenter(interactor: interactor)
                    WaypointView(interactor: interactor, presenter: presenter)
                        .previewDisplayName("Detail")
                }
                NavigationView {
                    let interactor = WaypointInteractor(waypoint: Waypoint(), mapDataProvider: provider)
                    let presenter = WaypointPresenter(interactor: interactor)
                    WaypointView(interactor: interactor, presenter: presenter)
                        .previewDisplayName("New")
                }
            }
    }
}
#endif
