//
//  ProfileHost.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/08/23.
//

import SwiftUI

struct ProfileHost: View {
  @Environment(\.editMode) var editMode
  @EnvironmentObject var modelData: ModelData
  @State private var draftProfile = Profile.default
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        if editMode?.wrappedValue == .active {
          Button("Cancel", role: .cancel) {
            draftProfile = modelData.profile
            editMode?.animation().wrappedValue = .inactive
          }
        }
        Spacer()
        EditButton()
      }
      
      if editMode?.wrappedValue == .inactive {
        ProfileSummary(profile: modelData.profile)
      } else {
        ProfileEditor(profile: $draftProfile)
          .onAppear {
            draftProfile = modelData.profile
          }
          .onDisappear {
            modelData.profile = draftProfile
          }
      }
    }
  }
}

struct ProfileHost_Previews: PreviewProvider {
  static var previews: some View {
    ProfileHost()
      .environmentObject(ModelData())
  }
}
