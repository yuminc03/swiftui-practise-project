//
//  ProfileEditor.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/08/23.
//

import SwiftUI

struct ProfileEditor: View {
  
  @Binding var profile: Profile
  
    var body: some View {
      List {
        HStack {
          Text("Username")
            .bold()
          Divider()
          TextField("Username", text: $profile.username)
        }
      }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
      ProfileEditor(profile: .constant(.default))
    }
}
