//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2022/12/31.
//

import SwiftUI
import ComposableArchitecture
import LuomeinSwiftBasicTools
import MultipleTimeSeriesReducer

public struct MultiLayerBezierCurveLastReferenceLineView: View {
    public let bezierTimeSeries : SingleBezierTimeSeriesReducer.State
    public let referenceTimeSeries : MultipleTimeSeriesReducer.State
    public init(bezierTimeSeries: SingleBezierTimeSeriesReducer.State, referenceTimeSeries: MultipleTimeSeriesReducer.State) {
        self.bezierTimeSeries = bezierTimeSeries
        self.referenceTimeSeries = referenceTimeSeries
    }
    public var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine && bezierTimeSeries.referenceLineOption == .lastOne{
                Path{path in
                    path.addLines(referenceTimeSeries.multipleSeries.map({
                        $0.timeSeries.last!.point
                    }))
                }.stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
            }
        }
    }
}
