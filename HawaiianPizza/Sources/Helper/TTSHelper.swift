//
//  TTSHelper.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 8/2/24.
//

import SwiftUI
import AVFoundation

class TextToSpeechManager: ObservableObject {
    private var speechSynthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}
