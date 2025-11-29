from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor
import torch
import soundfile as sf

# Load model and processor
processor = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-large-960h-lv60-self")
model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-large-960h-lv60-self")

# Load audio
speech, sr = sf.read("audio.wav")
input_values = processor(speech, sampling_rate=sr, return_tensors="pt").input_values

# Get logits and decode
with torch.no_grad():
    logits = model(input_values).logits

pred_ids = torch.argmax(logits, dim=-1)
transcription = processor.decode(pred_ids[0])

print("🔊 TRANSCRIPTION RESULT:\n", transcription)

