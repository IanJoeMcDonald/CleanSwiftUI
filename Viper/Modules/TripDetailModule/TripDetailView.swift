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

struct TripDetailView: View {
    var interactor: TripDetailInteractor
    var router: TripDetailRouter
    @ObservedObject var presenter: TripDetailPresenter
    
    private var tripName: Binding<String> {
        Binding<String> (
            get: { presenter.tripName },
            set: { interactor.setTripName($0) }
        )
    }

    var body: some View {
        VStack{
            Spacer()
            TextField("TripName", text: tripName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal])
            TripMapView(presenter: TripMapPresenter(interactor: TripMapInteractor(trip: interactor.trip,
                                                                                      mapDataProvider: interactor.mapDataProvider)))
            Text(presenter.distanceLabel)
            HStack {
                Spacer()
                EditButton()
                Button(action: interactor.addWaypoint) {
                    Text("Add")
                }
            }
            .padding([.horizontal])
            List {
                ForEach(presenter.waypoints, id: \.id) { waypoint in
                    NavigationButton(contentView:
                                        HStack {
                                            Text("\(waypoint.name)")
                                            Spacer()
                                            Image(systemName: "chevron.compact.right")
                                                .foregroundColor(Color(UIColor.systemGray4))
                                        },
                                     navigationView: { isPresented in
                                        self.router.makeWaypointView(for: waypoint, isPresented: isPresented)
                                     })
                }
                .onMove(perform: interactor.moveWaypoint(fromOffsets:toOffset:))
                .onDelete(perform: interactor.deleteWaypoint(atOffsets:))
            }
        }
        .navigationBarTitle(Text(presenter.tripName), displayMode: .inline)
        .navigationBarItems(trailing: Button("Save", action: interactor.save))
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        let trip = model.trips[1]
        let mapProvider = RealMapDataProvider()
        let interactor = TripDetailInteractor(trip: trip, model: model, mapDataProvider: mapProvider)
        let presenter = TripDetailPresenter(interactor: interactor)
        let router = TripDetailRouter(mapProvider: mapProvider)
        return NavigationView {
            TripDetailView(interactor: interactor, router: router, presenter: presenter)
        }
    }
}
