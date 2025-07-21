//
//  ContentView.swift
//  AEABuddy
//
//  Created by Pietro Gambatesa on 7/20/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @State private var ipswLocationPath: URL?
    @State private var IPSWname: String = ""
    var dmgTypes: [String] = ["app", "sys","fs"]
    @State private var selectedDMGTypes: String = "fs"
    @State private var IPSWkey: String = ""
    @State private var DMGfolder: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 10) {
                    VStack(spacing: 20) {
                      Text("Welcome to AEA Buddy! 👋")
                          .font(.largeTitle)
                      Text("AEA Buddy helps you decrypt iOS 18 or later IPSWs, by removing Apple's new .aea encryption format. AEA Buddy is an application built on top of an amazing command line tool written by Blacktop. So go check it out his amazing work.")
                          .font(.body)
                        Link(destination: URL(string: "https://github.com/blacktop/ipsw.git")!, label: {
                            Text("IPSW tool on GitHub")
                        })
                      
                    }
                    List {
                        Section(header: Text("Install IPSW tool")) {
                            HStack {
                                Text("If you do not not have the IPSW tool installed, install IPSW tool")
                                Spacer()
                                Button {
                                    shellCommand("brew install ipsw")
                                } label: {
                                    Text("Install")
                                }
                            }.padding(20)
                        }
                        
                        Section(header: Text("Remove AEA encryption from local IPSW. Follow every step!")) {
                            
                            HStack {
                                Text("Pick IPSW location folder")
                                Spacer()
                                Button {
                                    pickIPSW()
                                } label: {
                                    Text("Pick IPSW location")
                                }
                            }.padding(20)
                            
                            HStack {
                                TextField("Enter the IPSW name", text: $IPSWname)
                                Spacer()
                                if ipswLocationPath?.path.isEmpty ?? true {
                                    Button {
                                        
                                    } label: {
                                        Text("Extract key")
                                    }.disabled(true)
                                } else {
                                    Button {
                                        shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw extract --fcs-key '\(IPSWname)'")
                                        debugPrint(shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw extract --fcs-key '\(IPSWname)'"))
                                    } label: {
                                        Text("Extract key")
                                    }
                                }
                            }.padding(20)
                            
                            HStack {
                                Picker("Select the type of DMG to extract", selection: $selectedDMGTypes, content: {
                                    ForEach(dmgTypes, id: \.self) { type in
                                        Text(type)
                                    }
                                }).onChange(of: selectedDMGTypes) { newType in
                                    selectedDMGTypes=newType
                                }
                                Spacer()
                                if ipswLocationPath?.path.isEmpty ?? true {
                                    Button {
                                        
                                    } label: {
                                        Text("Extract")
                                    }.disabled(true)
                                } else {
                                    Button {
                                        shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw extract --dmg \(selectedDMGTypes) '\(IPSWname)'")
                                        debugPrint(shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw extract --dmg \(selectedDMGTypes) '\(IPSWname)'"))
                                    } label: {
                                        Text("Extract")
                                    }
                                }
                            }.padding(20)
                            
                            VStack(spacing: 20) {
                                TextField("Enter the IPSW key", text: $IPSWkey)
                                TextField("Enter path to the dmg.aea folder", text: $DMGfolder)
                                Spacer()
                                if ipswLocationPath?.path.isEmpty ?? true {
                                    Button {
                                        
                                    } label: {
                                        Text("Output the decrypted DMG")
                                    }.disabled(true)
                                } else {
                                    Button {
                                        shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw fw aea --key-val 'base64:\(IPSWkey)' '\(DMGfolder)' --output .")
                                        debugPrint(shellCommand("cd '\(ipswLocationPath?.path ?? "")' && /opt/homebrew/bin/ipsw fw aea --key-val 'base64:\(IPSWkey)' '\(DMGfolder)' --output ."))
                                    } label: {
                                        Text("Output the decrypted DMG")
                                    }
                                }
                            }.listRowSeparator(.hidden)
                                .padding(20)
                        
                            
                        }
                        Spacer().listRowSeparator(.hidden)

                       
                        VStack(spacing: 10) {
                            Text("AEA Buddy is developed by **Pietro Gambatesa *(TheiPhoneDev)***")
                            Text("You can reach out to me on: ")
                            Link(destination: URL(string: "https://x.com/pietrogambatesa")!, label: {
                                Text("Twitter: @pietrogambatesa")
                            })
                            Link(destination: URL(string: "https://mastodon.social/@TheiPhone_Dev")!, label: {
                                Text("Mastodon: @TheiPhone_Dev")
                            })
                            Link(destination: URL(string: "https://bsky.app/profile/pietrogambatesa.bsky.social")!, label: {
                                Text("Bluesky: @pietrogambatesa.bsky.social")
                            })
                            Link(destination: URL(string: "https://github.com/TheiPhoneDev")!, label: {
                                Text("GitHub: @TheiPhoneDev")
                            })
                        }.frame(maxWidth: .infinity, alignment: .center)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .listRowSeparator(.hidden)
                        
                        
                    }
                }.frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top,20)
            }.frame(height: 740)
        }.background(Color(colorScheme == .dark ? "Color" : "Color 1"))
    }
    
    func pickIPSW() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Select IPSW location"
        
        if panel.runModal() == .OK {
            ipswLocationPath = panel.url
        }
    }
    
    
}

#Preview {
    ContentView()
}
