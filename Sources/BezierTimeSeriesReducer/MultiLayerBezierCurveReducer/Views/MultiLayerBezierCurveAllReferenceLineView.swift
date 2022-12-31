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

public struct MultiLayerBezierCurveAllReferenceLineView: View {
    public let bezierTimeSeries : SingleBezierTimeSeriesReducer.State
    public let referenceTimeSeries : MultipleTimeSeriesReducer.State
    public init(bezierTimeSeries: SingleBezierTimeSeriesReducer.State, referenceTimeSeries: MultipleTimeSeriesReducer.State) {
        self.bezierTimeSeries = bezierTimeSeries
        self.referenceTimeSeries = referenceTimeSeries
    }
    public var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine && bezierTimeSeries.referenceLineOption == .all{
                if !referenceTimeSeries.multipleSeries.isEmpty{
                    let zipped : [[CGPoint]] = zipT(
                        referenceTimeSeries.multipleSeries.map({
                            $0.timeSeries.map({
                                $0.point
                            })
                        })
                    )
                    ForEach(zipped, id: \.self){series in
                        Path{path in
                            path.addLines(series)
                        }
                        .stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
                    }
                }
            }
        }
    }
}
