s.boot;

(
SynthDef(\test,
  {
    arg gate=1, freq=440;
    var buffer1, buffer2, oscillator, harm;
    buffer1 = Buffer.alloc(s, 512, 1);
    buffer2 = Buffer.alloc(s, 512, 1);
    harm = Harmonics.new(32);
    buffer1.sine2(harm.formant(6, 5), harm.geom(1.2), true, true, true);
    buffer2.sine2(harm.formant(6, 3.4), harm.geom(1.2), true, true, true);
    oscillator = Osc.ar([buffer1, buffer2], freq: freq, mul: Env.adsr.ar(gate:gate, doneAction: 2));
    Out.ar([0, 1], LPF.ar(Mix.ar([oscillator, Saw.ar([freq*0.25, freq*0.251, freq*0.249])])));
  }
).add;
)

a = Synth(\test);

(
Pbindef(\melody,
  \type, \set,
  \degree, Pxrand([0,2,3,4,5, 7], inf),
  \instrument, \test,
  \dur, 0.125
);
)

(Pbindef(\melody, \ctranspose, -12).play;)