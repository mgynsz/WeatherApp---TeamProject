//
//  SearchResultDelegate.swift
//  weatherProject
//
//  Created by 표현수 on 2022/12/25.
//

import Foundation
import MapKit

protocol SearchResultDelegate {
    func foundResult(mapItem: MKMapItem)
}
