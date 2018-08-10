%%AudioPlayer should create a new audioplayer Obj
f = AudioPlayer('../TIMIT MIT/dr1-fvmh0/sa1.wav');
assert(f.Player.SampleRate == 16000, 'Wrong SampleRate')
assert(f.Player.NumberOfChannels == 1, 'Wrong number of channels')
assert(f.Player.TotalSamples == 54681, 'Wrong number of TotalSamples')
assert(f.Player.BitsPerSample == 16, 'Wrong number of BitsPerSample')
assert(f.Player.TimerPeriod == 0.0500, 'Wrong TimerPeriod')