//
//  BezierTimerSeriesTraceView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import SwiftUI
import ComposableArchitecture


public struct SingleBezierTimerSeriesTraceView: View {
    public let store: StoreOf<SingleBezierTimeSeriesReducer>
    public init(store: StoreOf<SingleBezierTimeSeriesReducer>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                if viewStore.plot && viewStore.showTrace && viewStore.traceOption == .all{
                    ForEach(viewStore.trace.multipleSeries) { singleSeries in
                        Path{path in
                            path.addLines(singleSeries.timeSeries.map({
                                $0.point
                            }))
                        }.stroke(viewStore.traceColor,lineWidth: viewStore.traceWidth)
                    }
                }
            }
        }
    }
}
public struct SingleBezierTimerSeriesLastPointsView: View {
    public let store: StoreOf<SingleBezierTimeSeriesReducer>
    public init(store: StoreOf<SingleBezierTimeSeriesReducer>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                if viewStore.plot && viewStore.showTrace && viewStore.traceOption == .lastOne{
                    ForEach(viewStore.trace.multipleSeries) { singleSeries in
                        Circle()
                            .fill(viewStore.traceColor)
                            .frame(width: viewStore.traceWidth, height: viewStore.traceWidth)
                            .position(singleSeries.timeSeries.last!.point)
                        
                    }
                }
            }
        }
    }
}

//struct BezierTimerSeriesTraceView_Previews: PreviewProvider {
//    static var previews: some View {
//        BezierTimerSeriesTraceView()
//    }
//}
