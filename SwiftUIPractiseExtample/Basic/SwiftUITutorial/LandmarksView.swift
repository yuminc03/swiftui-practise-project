//
//  LandmarksView.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/08/22.
//

import SwiftUI

struct LandmarksView: View {
    var body: some View {
        LandmarkList()
    }
}

struct LandmarksView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarksView()
          .environmentObject(ModelData())
    }
}
