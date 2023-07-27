import SwiftUI


// Add this to the top of our ContentView.swift file.
let numberOfSamples: Int = 10

struct BarView: View {
   // 1
    var value: CGFloat
    var gradient: Gradient

    var body: some View {
        ZStack {
           // 2
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: gradient,
                                     startPoint: .top,
                                     endPoint: .bottom))
                // 3
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
        }
    }
}

struct DecibelView: View {
    // 1
    @ObservedObject private var mic = DecibelViewModel(numberOfSamples: numberOfSamples)
    
    // 2
    func gradient(for decibel: Float) -> Gradient {
        let index = mic.thresholds.firstIndex { decibel < $0 } ?? mic.colors.count
        let startColor = mic.colors[max(index - 1, 0)]
        let endColor = mic.colors[min(index, mic.colors.count - 1)]
        return Gradient(colors: [startColor, endColor])
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        VStack {
             // 3
            HStack(spacing: 4) {
                 // 4
                ForEach(mic.soundSamples, id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level), gradient: self.gradient(for: level))
                }
            }
        }
    }
}
