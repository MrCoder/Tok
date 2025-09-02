import ComposableArchitecture
import SwiftUI
import Sparkle

struct AboutView: View {
    @Bindable var store: StoreOf<SettingsFeature>
    @State var viewModel = CheckForUpdatesViewModel.shared
    @State private var versionTapCount = 0

    var body: some View {
        Form {
            Section {
                HStack {
                    Label("Version", systemImage: "info.circle")
                        .onTapGesture {
                            versionTapCount += 1
                            if versionTapCount >= 8 {
                                // Enable developer mode
                                store.send(.binding(.set(\.dictaFlowSettings.developerModeEnabled, true)))
                                versionTapCount = 0
                            }
                        }
                    Spacer()
                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown")
                    Button("Check for Updates") {
                        viewModel.checkForUpdates()
                    }
                    .buttonStyle(.bordered)
                }
                HStack {
                    Label("DictaFlow is open source", systemImage: "apple.terminal.on.rectangle")
                    Spacer()
                    Link("Visit our GitHub", destination: URL(string: "https://github.com/untsop/Hex")!)
                }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            // Sync Sparkle settings with app settings
            viewModel.updateSettings(
                enableAutoUpdates: store.dictaFlowSettings.enableAutoUpdates,
                enableAutoUpdateChecks: store.dictaFlowSettings.enableAutoUpdateChecks,
                checkInterval: store.dictaFlowSettings.autoUpdateCheckInterval
            )
        }
        .onChange(of: store.dictaFlowSettings.enableAutoUpdates) { _, newValue in
            viewModel.updateSettings(
                enableAutoUpdates: newValue,
                enableAutoUpdateChecks: store.dictaFlowSettings.enableAutoUpdateChecks,
                checkInterval: store.dictaFlowSettings.autoUpdateCheckInterval
            )
        }
        .onChange(of: store.dictaFlowSettings.enableAutoUpdateChecks) { _, newValue in
            viewModel.updateSettings(
                enableAutoUpdates: store.dictaFlowSettings.enableAutoUpdates,
                enableAutoUpdateChecks: newValue,
                checkInterval: store.dictaFlowSettings.autoUpdateCheckInterval
            )
        }
        .onChange(of: store.dictaFlowSettings.autoUpdateCheckInterval) { _, newValue in
            viewModel.updateSettings(
                enableAutoUpdates: store.dictaFlowSettings.enableAutoUpdates,
                enableAutoUpdateChecks: store.dictaFlowSettings.enableAutoUpdateChecks,
                checkInterval: newValue
            )
        }
    }
}