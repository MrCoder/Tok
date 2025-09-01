import ComposableArchitecture
import SwiftUI

class DictaFlowAppDelegate: NSObject, NSApplicationDelegate {
	var invisibleWindow: InvisibleWindow?
	var settingsWindow: NSWindow?
	var statusItem: NSStatusItem!

	@Dependency(\.soundEffects) var soundEffect
	@Dependency(\.recording) var recording
	@Shared(.dictaFlowSettings) var dictaFlowSettings: DictaFlowSettings

	func applicationDidFinishLaunching(_: Notification) {
		if isTesting {
			print("TESTING")
			return
		}

		// Reset model warm status to cold since models are unloaded when app closes
		$dictaFlowSettings.withLock { $0.transcriptionModelWarmStatus = .cold }

		Task {
			await soundEffect.preloadSounds()
		}
		print("DictaFlowAppDelegate did finish launching")

		// Set activation policy first
		updateAppMode()

		// Add notification observer
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleAppModeUpdate),
			name: NSNotification.Name("UpdateAppMode"),
			object: nil
		)

		// Then present main views
		presentMainView()
		presentSettingsView()
		NSApp.activate(ignoringOtherApps: true)
	}

	func presentMainView() {
		guard invisibleWindow == nil else {
			return
		}
		let transcriptionStore = DictaFlowApp.appStore.scope(state: \.transcription, action: \.transcription)
		let transcriptionView = TranscriptionView(store: transcriptionStore)
			// Removed extra top padding so status bar sticks to very top edge
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		invisibleWindow = InvisibleWindow.fromView(transcriptionView)
		invisibleWindow?.makeKeyAndOrderFront(nil)
	}

	func presentSettingsView() {
		if let settingsWindow = settingsWindow {
			settingsWindow.makeKeyAndOrderFront(nil)
			NSApp.activate(ignoringOtherApps: true)
			return
		}

		let settingsView = AppView(store: DictaFlowApp.appStore)
		let settingsWindow = NSWindow(
			contentRect: .init(x: 0, y: 0, width: 700, height: 700),
			styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable],
			backing: .buffered,
			defer: false
		)
		settingsWindow.titleVisibility = .visible
		settingsWindow.contentView = NSHostingView(rootView: settingsView)
		settingsWindow.makeKeyAndOrderFront(nil)
		settingsWindow.isReleasedWhenClosed = false
		settingsWindow.center()
        settingsWindow.toolbarStyle = NSWindow.ToolbarStyle.unified
		NSApp.activate(ignoringOtherApps: true)
		self.settingsWindow = settingsWindow
	}

	@objc private func handleAppModeUpdate() {
		Task {
			await updateAppMode()
		}
	}

	@MainActor
	private func updateAppMode() {
		print("dictaFlowSettings.showDockIcon: \(dictaFlowSettings.showDockIcon)")
		if dictaFlowSettings.showDockIcon {
			NSApp.setActivationPolicy(.regular)
		} else {
			NSApp.setActivationPolicy(.accessory)
		}
	}

	func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
		presentSettingsView()
		return true
	}
}
