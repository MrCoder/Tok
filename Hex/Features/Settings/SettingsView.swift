import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
	@Bindable var store: StoreOf<SettingsFeature>
	
	var body: some View {
		Form {
			// --- Permissions Section ---
			Section {
				// Microphone
				HStack {
					Label("Microphone", systemImage: "mic.fill")
					Spacer()
					switch store.microphonePermission {
					case .granted:
						Label("Granted", systemImage: "checkmark.circle.fill")
							.foregroundColor(.green)
							.labelStyle(.iconOnly)
					case .denied:
						Button("Request Permission") {
							store.send(.requestMicrophonePermission)
						}
						.buttonStyle(.borderedProminent)
						.tint(.blue)
					case .notDetermined:
						Button("Request Permission") {
							store.send(.requestMicrophonePermission)
						}
						.buttonStyle(.bordered)
					}
				}

				// Accessibility
				HStack {
					Label("Accessibility", systemImage: "accessibility")
					Spacer()
					switch store.accessibilityPermission {
					case .granted:
						Label("Granted", systemImage: "checkmark.circle.fill")
							.foregroundColor(.green)
							.labelStyle(.iconOnly)
					case .denied:
						Button("Request Permission") {
							store.send(.requestAccessibilityPermission)
						}
						.buttonStyle(.borderedProminent)
						.tint(.blue)
					case .notDetermined:
						Button("Request Permission") {
							store.send(.requestAccessibilityPermission)
						}
						.buttonStyle(.bordered)
					}
				}

			} header: {
				Text("Permissions")
			}
      
			// --- Input Device Selection Section ---
			if store.microphonePermission == .granted && !store.availableInputDevices.isEmpty {
				Section {
					// Input device picker
					HStack {
						Label {
							Picker("Input Device", selection: $store.dictaFlowSettings.selectedMicrophoneID) {
								Text("System Default").tag(nil as String?)
								ForEach(store.availableInputDevices) { device in
									Text(device.name).tag(device.id as String?)
								}
							}
							.pickerStyle(.menu)
							.id(UUID()) // Force refresh when devices change
						} icon: {
							Image(systemName: "mic.circle")
						}
						
						Button(action: {
							store.send(.loadAvailableInputDevices)
						}) {
							Image(systemName: "arrow.clockwise")
						}
						.buttonStyle(.borderless)
						.help("Refresh available input devices")
					}
					
					// Show fallback note for selected device not connected
					if let selectedID = store.dictaFlowSettings.selectedMicrophoneID, 
					   !store.availableInputDevices.contains(where: { $0.id == selectedID }) {
						Text("Selected device not connected. System default will be used.")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				} header: {
					Text("Microphone Selection")
				}
			}

			// --- Transcription Model Section ---
			Section("Transcription Model") {
				ModelDownloadView(store: store.scope(state: \.modelDownload, action: \.modelDownload)
				)
			}

			Label {
				Picker("Output Language", selection: $store.dictaFlowSettings.outputLanguage) {
					ForEach(store.languages, id: \.id) { language in
						Text(language.name).tag(language.code)
					}
				}
				.pickerStyle(.menu)
			} icon: {
				Image(systemName: "globe")
			}

			// --- Hot Key Section ---
			Section("Hot Key") {
				let hotKey = store.dictaFlowSettings.hotkey
				let key = store.isSettingHotKey ? nil : hotKey.key
				let modifiers = store.isSettingHotKey ? store.currentModifiers : hotKey.modifiers
				
				VStack(spacing: 12) {
					// Info text for full keyboard shortcut support
					if hotKey.key != nil {
						Text("You're using a full keyboard shortcut. Double-tap is recommended.")
							.font(.caption)
							.foregroundColor(.secondary)
							.frame(maxWidth: .infinity, alignment: .center)
					}
					
					// Hot key view
					HStack {
						Spacer()
						HotKeyView(modifiers: modifiers, key: key, isActive: store.isSettingHotKey)
							.animation(.spring(), value: key)
							.animation(.spring(), value: modifiers)
						Spacer()
					}
					.contentShape(Rectangle())
					.onTapGesture {
						store.send(.startSettingHotKey)
					}
				}
				
				// Double-tap toggle (for key+modifier combinations)
				if hotKey.key != nil {
					Label {
						Toggle("Use double-tap only", isOn: $store.dictaFlowSettings.useDoubleTapOnly)
						Text("Recommended for custom hotkeys to avoid interfering with normal usage")
							.font(.caption)
							.foregroundColor(.secondary)
					} icon: {
						Image(systemName: "hand.tap")
					}
				}
				
				// Minimum key time (for modifier-only shortcuts)
                if store.dictaFlowSettings.hotkey.key == nil {
                    Label {
                        Slider(value: $store.dictaFlowSettings.minimumKeyTime, in: 0.0...2.0, step: 0.1) {
                            Text("Ignore below \(store.dictaFlowSettings.minimumKeyTime, specifier: "%.1f")s")
                        }
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
			}

			// --- Sound Section ---
			Section {
				Label {
					Toggle("Sound Effects", isOn: $store.dictaFlowSettings.soundEffectsEnabled)
				} icon: {
					Image(systemName: "speaker.wave.2.fill")
				}
			} header: {
				Text("Sound")
			}

			// --- General Section ---
			Section {
				Label {
					Toggle("Open on Login",
					       isOn: Binding(
					       	get: { store.dictaFlowSettings.openOnLogin },
					       	set: { store.send(.toggleOpenOnLogin($0)) }
					       ))
				} icon: {
					Image(systemName: "arrow.right.circle")
				}

				Label {
					Toggle("Show Dock Icon", isOn: $store.dictaFlowSettings.showDockIcon)
				} icon: {
					Image(systemName: "dock.rectangle")
				}

				Label {
					Toggle("Use clipboard to insert", isOn: $store.dictaFlowSettings.useClipboardPaste)
					Text("Use clipboard to insert text. Fast but may not restore all clipboard content.\nTurn off to use simulated keypresses. Slower, but doesn't need to restore clipboard")
				} icon: {
					Image(systemName: "doc.on.doc.fill")
				}
				
				Label {
					Toggle("Copy to clipboard", isOn: $store.dictaFlowSettings.copyToClipboard)
					Text("Copy transcription text to clipboard in addition to pasting it")
				} icon: {
					Image(systemName: "doc.on.clipboard")
				}
                
                Label {
                    Toggle("Disable auto-capitalization", isOn: $store.dictaFlowSettings.disableAutoCapitalization)
                    Text("Disable automatic capitalization in transcriptions")
                } icon: {
                    Image(systemName: "textformat.abc")
                }

				Label {
					Toggle(
						"Prevent System Sleep while Recording",
						isOn: Binding(
							get: { store.dictaFlowSettings.preventSystemSleep },
							set: { store.send(.togglePreventSystemSleep($0)) }
						))
				} icon: {
					Image(systemName: "zzz")
				}
                
                Label {
                    Toggle(
                        "Pause Media while Recording",
                        isOn: Binding(
                            get: { store.dictaFlowSettings.pauseMediaOnRecord },
                            set: { store.send(.togglePauseMediaOnRecord($0)) }
                        ))
                } icon: {
                    Image(systemName: "pause")
                }
			} header: {
				Text("General")
			}
			
			// --- Updates Section ---
			Section {
				Label {
					Toggle("Enable automatic updates", isOn: $store.dictaFlowSettings.enableAutoUpdates)
					Text("Automatically download and install updates when available")
				} icon: {
					Image(systemName: "arrow.clockwise.circle")
				}
				
				Label {
					Toggle("Check for updates automatically", isOn: $store.dictaFlowSettings.enableAutoUpdateChecks)
					Text("Periodically check for new versions")
				} icon: {
					Image(systemName: "magnifyingglass.circle")
				}
				
				Label {
					Picker("Check interval", selection: $store.dictaFlowSettings.autoUpdateCheckInterval) {
						Text("Every hour").tag(3600)
						Text("Every 6 hours").tag(21600)
						Text("Daily").tag(86400)
						Text("Weekly").tag(604800)
					}
					.pickerStyle(.menu)
					Text("How often to check for updates")
				} icon: {
					Image(systemName: "clock")
				}
				.disabled(!store.dictaFlowSettings.enableAutoUpdateChecks)
				
			} header: {
				Text("Updates")
			}
		}
		.formStyle(.grouped)
		.task {
			await store.send(.task).finish()
		}
	}
}