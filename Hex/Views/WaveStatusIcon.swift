import SwiftUI
import AppKit

/// A soundwave shape that can be animated based on audio levels.
private struct SoundWaveShape: Shape {
    let bars: [WaveBar]
    
    struct WaveBar {
        let x: CGFloat
        let baseHeight: CGFloat
        let animatedHeight: CGFloat
        let width: CGFloat = 3.0
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.midY
        
        for bar in bars {
            let height = bar.animatedHeight
            let barRect = CGRect(
                x: bar.x,
                y: centerY - height/2,
                width: bar.width,
                height: height
            )
            let roundedRect = RoundedRectangle(cornerRadius: bar.width/2)
            path.addPath(roundedRect.path(in: barRect))
        }
        
        return path
    }
}

/// A menu-bar icon view that shows animated soundwaves like the DictaFlow logo.
struct WaveBarIcon: View {
    let averagePower: Double
    let peakPower: Double
    let isRecording: Bool
    @State private var currentImage = NSImage()
    @State private var animationPhase: Double = 0
    
    // Define the wave bars similar to the logo design
    private var waveBars: [SoundWaveShape.WaveBar] {
        let baseHeights: [CGFloat] = [12, 18, 9, 15, 6] // Base heights for 5 bars (增大)
        let spacing: CGFloat = 4.0
        
        return baseHeights.enumerated().map { index, baseHeight in
            // 居中对齐波浪条，让整体更充满空间
            let totalWidth = CGFloat(baseHeights.count - 1) * spacing + 3.0 // 最后一个条的宽度
            let startX = (44 - totalWidth) / 2 // 居中起始位置
            let x = startX + CGFloat(index) * spacing
            
            let animatedHeight = calculateAnimatedHeight(
                baseHeight: baseHeight,
                index: index,
                phase: animationPhase
            )
            
            return SoundWaveShape.WaveBar(
                x: x,
                baseHeight: baseHeight,
                animatedHeight: animatedHeight
            )
        }
    }
    
    private func calculateAnimatedHeight(baseHeight: CGFloat, index: Int, phase: Double) -> CGFloat {
        guard isRecording else {
            // When not recording, show gentle idle animation
            let idlePhase = phase + Double(index) * 0.3
            let idleMultiplier = 1.0 + 0.2 * sin(idlePhase)
            return baseHeight * idleMultiplier
        }
        
        // When recording, respond to audio levels
        let clampedAvg = max(0, min(averagePower, 1))
        let clampedPeak = max(0, min(peakPower, 1))
        
        // Create different response curves for each bar
        let barPhase = phase + Double(index) * 0.4
        let waveEffect = sin(barPhase) * 0.3
        
        // Combine average and peak levels with wave effect
        let effectiveLevel = max(clampedAvg * clampedAvg, clampedPeak * 0.8)
        let levelMultiplier = 1.0 + effectiveLevel * 1.5 + waveEffect
        
        return max(baseHeight * 0.5, baseHeight * levelMultiplier)
    }
    
    var body: some View {
        Image(nsImage: currentImage)
            .resizable()
            .renderingMode(.template)
            .frame(width: 22, height: 22)
            .onAppear {
                startAnimation()
                updateImage()
            }
            .onChange(of: averagePower) { _, _ in updateImage() }
            .onChange(of: peakPower) { _, _ in updateImage() }
            .onChange(of: isRecording) { _, _ in updateImage() }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            animationPhase += 0.15
            updateImage()
        }
    }
    
    private func updateImage() {
        let size = CGSize(width: 44, height: 44)
        
        // Create gradient colors matching the DictaFlow logo
        let gradient = LinearGradient(
            colors: [
                Color(red: 0.23, green: 0.51, blue: 0.96), // #3b82f6
                Color(red: 0.02, green: 0.71, blue: 0.83), // #06b6d4
                Color(red: 0.55, green: 0.36, blue: 0.96)  // #8b5cf6
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        let rootView = ZStack {
            SoundWaveShape(bars: waveBars)
                .fill(gradient)
                .opacity(isRecording ? 1.0 : 0.7)
        }
        .frame(width: size.width, height: size.height)
        
        let hosting = NSHostingView(rootView: rootView)
        hosting.frame = CGRect(origin: .zero, size: size)
        
        guard let rep = hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds) else {
            return
        }
        
        hosting.cacheDisplay(in: hosting.bounds, to: rep)
        // Mark the raster as a 2× representation (44 × 44 px = 22 × 22 pt)
        rep.size = NSSize(width: 22, height: 22)
        
        let img = NSImage(size: CGSize(width: 22, height: 22))
        img.addRepresentation(rep)
        img.isTemplate = true
        
        currentImage = img
    }
}

// MARK: - Alternative Simplified Wave Icon
/// A simpler wave icon that's easier to see at small sizes
struct SimpleWaveIcon: View {
    let isRecording: Bool
    let audioLevel: Double
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 1.5) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.23, green: 0.51, blue: 0.96),
                                Color(red: 0.02, green: 0.71, blue: 0.83),
                                Color(red: 0.55, green: 0.36, blue: 0.96)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2, height: waveHeight(for: index))
                    .opacity(isRecording ? 1.0 : 0.6)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: animationOffset
                    )
            }
        }
        .frame(width: 16, height: 16)
        .onAppear {
            animationOffset = 1.0
        }
    }
    
    private func waveHeight(for index: Int) -> CGFloat {
        let baseHeights: [CGFloat] = [6, 10, 4, 8, 5]
        let baseHeight = baseHeights[index]
        
        if isRecording {
            let levelMultiplier = 1.0 + audioLevel * 0.8
            return baseHeight * levelMultiplier * (1.0 + animationOffset * 0.3)
        } else {
            return baseHeight * (1.0 + animationOffset * 0.2)
        }
    }
}
