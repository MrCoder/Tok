import ComposableArchitecture
import SwiftUI
import AppKit

@Reducer
struct DeveloperFeature {
    @ObservableState
    struct State {
        @Shared(.dictaFlowSettings) var dictaFlowSettings: DictaFlowSettings
    }

    enum Action {
        case resetOnboarding
        case openLogFile
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .resetOnboarding:
                state.$dictaFlowSettings.withLock { $0.hasCompletedOnboarding = false }
                return .none

            case .openLogFile:
                return .run { _ in
                    DictaFlowLogger.openLogFile()
                }
            }
        }
    }
}

struct DeveloperView: View {
    @Bindable var store: StoreOf<DeveloperFeature>

    var body: some View {
        Form {
            Section("Onboarding") {
                Button("Reset Onboarding") {
                    store.send(.resetOnboarding)
                }
                .buttonStyle(.bordered)
                Text("Onboarding will be shown the next time you open the app.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section("Logs") {
                Button("Open Log File") {
                    store.send(.openLogFile)
                }
                .buttonStyle(.bordered)
                let path = DictaFlowLogger.logFileURL.path
                Text(path)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
        .formStyle(.grouped)
    }
} 