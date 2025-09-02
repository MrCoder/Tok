import ComposableArchitecture
import Sparkle
import SwiftUI

@main
struct DictaFlowApp: App {
	static let appStore = Store(initialState: AppFeature.State()) {
		AppFeature()
	}

	@NSApplicationDelegateAdaptor(DictaFlowAppDelegate.self) var appDelegate

	var body: some Scene {
		MenuBarExtra {
			CheckForUpdatesView()

			Button("Settings...") {
				appDelegate.presentSettingsView()
			}.keyboardShortcut(",")

			Divider()

			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}.keyboardShortcut("q")
		} label: {
			Label {
				// no title text
				EmptyView()
			} icon: {
				WithViewStore(DictaFlowApp.appStore, observe: { $0.transcription }) { viewStore in
					WaveBarIcon(
						averagePower: viewStore.meter.averagePower,
						peakPower: viewStore.meter.peakPower,
						isRecording: viewStore.isRecording
					)
				}
			}
			.labelStyle(.iconOnly)
		}

		WindowGroup {}.defaultLaunchBehavior(.suppressed)
			.commands {
				CommandGroup(after: .appInfo) {
					CheckForUpdatesView()

					Button("Settings...") {
						appDelegate.presentSettingsView()
					}.keyboardShortcut(",")
				}
			}
	}
}
