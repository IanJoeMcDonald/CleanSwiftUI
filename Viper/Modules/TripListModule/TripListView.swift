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

struct TripListView<Router: TripListRouterProtocol, Presenter: TripListPresenterObservable>: View {
    var router: Router
    var interactor: TripListInteractorActions
    @ObservedObject var presenter: Presenter
    
    
    var body: some View {
        List {
            ForEach (presenter.trips, id: \.id) { item in
                HStack {
                    TripListCell(trip: item)
                        .frame(height: 240)
                    
                    NavigationButton(contentView:
                                        Image(systemName: "chevron.compact.right")
                                        .foregroundColor(Color(UIColor.systemGray4)),
                                     navigationView: { isPresented in
                                        self.router.makeDetailView(for: item, isPresented: isPresented)
                    })
                }
            }
            .onDelete(perform: interactor.deleteTrip)
        }
        .navigationBarTitle("Roadtrips", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: interactor.addNewTrip) {
            Image(systemName: "plus")
        })
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        let router = TripListRouter(model: model)
        let interactor = TripListInteractor(model: model)
        let presenter = TripListPresenter(interactor: interactor)
        
        return NavigationView {
            TripListView(router: router, interactor: interactor, presenter: presenter)
        }
    }
}
