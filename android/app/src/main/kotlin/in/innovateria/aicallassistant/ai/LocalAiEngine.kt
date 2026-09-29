package `in`.innovateria.aicallassistant.ai

import java.util.Locale

/**
 * On-Device Rule and Intent Engine for Local AI Mode.
 *
 * Provides offline intent classification, urgency detection, and response synthesis
 * in both Hindi and English without sending audio or transcripts to any cloud server.
 */
class LocalAiEngine {

    data class IntentResult(
        val intent: String,
        val urgency: String,
        val callbackRequired: Boolean,
        val suggestedResponse: String,
        val detectedLanguage: String
    )

    fun processMessage(text: String, callerName: String? = null, languageHint: String? = null): IntentResult {
        val lower = text.lowercase(Locale.ROOT).trim()

        val isHindi = containsHindi(text) || languageHint == "hi"

        // Urgency Detection
        val isUrgent = lower.contains("urgent") ||
                lower.contains("emergency") ||
                lower.contains("immediately") ||
                lower.contains("asap") ||
                lower.contains("जरूरी") ||
                lower.contains("आपातकाल") ||
                lower.contains("तुरंत")

        val urgency = if (isUrgent) "urgent" else if (lower.contains("important") || lower.contains("महत्वपूर्ण")) "high" else "medium"

        // Callback Detection
        val callbackRequested = lower.contains("call me back") ||
                lower.contains("call back") ||
                lower.contains("please call") ||
                lower.contains("कॉल बैक") ||
                lower.contains("वापस कॉल") ||
                lower.contains("बात करनी है")

        // Intent Classification
        val intent: String
        val response: String

        if (lower.contains("meeting") || lower.contains("appointment") || lower.contains("मीटिंग")) {
            intent = "SCHEDULE_MEETING"
            response = if (isHindi) {
                "मैंने आपकी मीटिंग का अनुरोध नोट कर लिया है। मैं विवेक को सूचित कर दूँगा।"
            } else {
                "I have noted your request regarding the meeting. I will notify Vivek right away."
            }
        } else if (callbackRequested) {
            intent = "REQUEST_CALLBACK"
            response = if (isHindi) {
                "ज़रूर, मैंने आपका कॉलबैक अनुरोध नोट कर लिया है। विवेक आपको यथाशीघ्र कॉल करेंगे।"
            } else {
                "Certainly, I have registered your callback request. Vivek will get back to you as soon as possible."
            }
        } else if (lower.contains("project") || lower.contains("work") || lower.contains("काम")) {
            intent = "PROJECT_DISCUSSION"
            response = if (isHindi) {
                "प्रोजेक्ट के संबंध में आपकी बात दर्ज कर ली गई है। क्या कोई विशेष समय है जब आप बात करना चाहते हैं?"
            } else {
                "I've noted this regarding the project. Is there a preferred time today for Vivek to reach out?"
            }
        } else if (lower.contains("who are you") || lower.contains("कौन हो") || lower.contains("आप कौन")) {
            intent = "INQUIRE_IDENTITY"
            response = if (isHindi) {
                "मैं विवेक का पर्सनल एआई फोन असिस्टेंट हूँ। मैं उनकी अनुपस्थिति में कॉल्स संभालता हूँ।"
            } else {
                "I am Vivek's personal AI phone assistant. I assist with incoming calls while he is unavailable."
            }
        } else {
            intent = "GENERAL_INQUIRY"
            response = if (isHindi) {
                "धन्यवाद। मैंने आपका संदेश नोट कर लिया है और विवेक तक पहुँचा दूँगा।"
            } else {
                "Thank you. I have recorded your message and will pass it on to Vivek."
            }
        }

        return IntentResult(
            intent = intent,
            urgency = urgency,
            callbackRequired = callbackRequested,
            suggestedResponse = response,
            detectedLanguage = if (isHindi) "hi" else "en"
        )
    }

    private fun containsHindi(text: String): Boolean {
        for (char in text) {
            val block = Character.UnicodeBlock.of(char)
            if (block == Character.UnicodeBlock.DEVANAGARI) {
                return true
            }
        }
        return false
    }
}
