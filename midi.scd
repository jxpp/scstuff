s.boot;
(
var notes, on, off;
MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
notes[num] = Synth(\sawy, [\freq, num.midicps,
\gate, veloc * 0.00315]);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
notes[num].release;
  [veloc, num, chan, src].postln;
});

q = { on.free; off.free; };
)

(
    SynthDef(
        \sawy,
        {
            arg freq=440, gate=1;
            var saw, sawDetunedLo, sawDetunedHi, mix, lpf;

            saw = LPF.ar(Saw.ar(freq: [freq, freq*1.01, freq*0.99], mul: Env.adsr.kr(gate: gate, doneAction:2)), 500);

            mix = FreeVerb.ar(Mix(saw), 0.75);

            Out.ar([0, 1], mix);
        }
    ).add;
)