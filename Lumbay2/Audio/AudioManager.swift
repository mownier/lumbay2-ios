import AVFoundation
import UIKit

class AudioManager {
    private var player: AVAudioPlayer?
    
    func play(_ resourceName: String) throws {
        if player != nil {
            throw Errors.currentlyPlaying
        }
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: nil) else {
            throw Errors.resourceNotFound
        }
        player = try AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.prepareToPlay()
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
    
    enum Errors: Error {
        case resourceNotFound
        case currentlyPlaying
    }
}
