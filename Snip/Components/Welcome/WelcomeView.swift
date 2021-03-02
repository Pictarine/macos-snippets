//
//  WelcomeView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/8/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themeSecondaryColor) var themeSecondaryColor
  @Environment(\.themePrimaryColor) var themePrimaryColor
  @Environment(\.themeTextColor) var themeTextColor
  @Environment(\.themeShadowColor) var themeShadowColor
  
  @ObservedObject var viewModel: WelcomeViewModel
  
  var body: some View {
    firstView
      .background(themeSecondaryColor)
      .cornerRadius(4.0)
  }
  
  var firstView: some View {
    VStack {
      HStack {
        Spacer()
        Text(NSLocalizedString("Welcome", comment: ""))
          .foregroundColor(themeTextColor)
          .font(.title)
        Spacer()
      }
      Text("Changelog Ver. \(Bundle.main.releaseVersionNumber)")
        .font(.subheadline)
        .foregroundColor(themeTextColor)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
      HStack {
        Text("- Update for Big Sur compatibility\n- Fix code editor issue\n- Open folder when we add a new element\n- Add toolbar item\n- Sidebar can be expanded/collapsed\n PHP now has syntax highlighting without tags\n- Improve UI and clickable areas")
          .font(Font.custom("CourierNewPSMT", size: 12))
          .foregroundColor(themeTextColor)
        Spacer()
      }
      .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
      .background(themePrimaryColor)
      Text(NSLocalizedString("Need_You", comment: ""))
        .font(.subheadline)
        .foregroundColor(themeTextColor)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
      CodeView(code: .constant(NSLocalizedString("Need_You_Desc", comment: "")),
               mode: .constant(CodeMode.text.mode()),
               isReadOnly: true)
        .frame(maxWidth: .infinity)
      Spacer()
      HStack {
        Spacer()
        Button(action: self.viewModel.close) {
          Text(NSLocalizedString("Close", comment: ""))
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .foregroundColor(themeTextColor)
            .background(Color.transparent)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        Button(action: self.viewModel.openSnipWebsite) {
          Text(NSLocalizedString("Join", comment: "").uppercased())
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .foregroundColor(.white)
            .background(Color.accentDark)
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
    }
    .padding()
  }
  
}

final class WelcomeViewModel: ObservableObject {
  
  @Binding var isVisible: Bool
  
  init(isVisible: Binding<Bool>) {
    self._isVisible = isVisible
  }
  
  func close() {
    self.isVisible = false
  }
  
  func openSnipWebsite() {
    guard let url = URL(string: "https://snip.picta-hub.io") else { return }
    NSWorkspace.shared.open(url)
    
    self.close()
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(viewModel: WelcomeViewModel(isVisible: .constant(true)))
  }
}
