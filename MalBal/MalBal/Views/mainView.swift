import Charts
import SwiftUI

struct mainView: View {
    @StateObject var audioProcessing = mainViewModel.shared
    let timer = Timer.publish(
        every: Constants.updateInterval,
        on: .main,
        in: .common
    ).autoconnect()
    @State private var isRecording = false

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Chart(Array(audioProcessing.data.enumerated()), id: \.0) { index, magnitude in
                        BarMark(
                            x: .value("Frequency", String(index)),
                            y: .value("Magnitude", magnitude)
                        )
                        .foregroundStyle(
                            Color(
                                hue: 0.3 - Double((magnitude / Constants.magnitudeLimit) / 5),
                                saturation: 1,
                                brightness: 1,
                                opacity: 0.7
                            )
                        )
                    }
                    .onReceive(timer, perform: audioProcessing.updateData)
                    .chartYScale(domain: 0 ... Constants.magnitudeLimit)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .frame(height: 100)
                    .padding()
                    .background(
                        .black
                            .opacity(0.3)
                            .shadow(.inner(radius: 20))
                    )
                    .cornerRadius(10)
                    
                    HStack {
                        
                        Spacer()
                    
                        Button(action: audioProcessing.playButtonTapped) {
                            Image(systemName: "\(audioProcessing.isPlaying ? "pause" : "play").circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }

                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 40)
            .navigationTitle("MalPal")
                
                HStack {
                    Button(action: {print("ee")}) {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    VStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)
                                    .opacity(isRecording ? 1.0 : 0.6)
                            )
                            .onTapGesture {
                                isRecording.toggle()
                                // Add your recording logic here
                            }
                    }
                    Button(action: {print("ee")}) {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
