s.boot;

(
SynthDef(\sawy,
  {
    arg freq=440, gate=1;
    var saw, mix;
    saw = Saw.ar(freq: [freq, freq*2], mul: Env.perc.kr(gate: gate, doneAction: 2));
    mix = Mix.ar(saw);

    Out.ar([0, 1], FreeVerb.ar(mix, mix: 0.7, room: 0.7, damp: 0.8));
  }
).add;
)

(
SynthDef(\sawylong,
  {
    arg freq=440, gate=1;
    var saw, mix;
    saw = SinOscFB.ar(freq: [freq, freq * 0.99, freq * 1.01], feedback: 0.1, mul: Env.adsr.kr(gate: gate, doneAction: Done.freeSelf));
    mix = Mix.ar(saw);

    Out.ar([0, 1], Compander.ar(mix));
  }
).add;
)

~notes = [0,2,4,5,6,7];

(
Pbind(
  \instrument, \sawy,
  \scale, Scale.minor,
  \degree, Pxrand(~notes, inf),
  \dur, Pseq([0.125], inf),
  \legato, 0.2
).play;

Pbind(
  \instrument, \sawylong,
  \scale, Scale.minor,
  \ctranspose, -12,
  \degree, Pseq([0, 3, 5, 4], inf),
  \dur, 2
).play;
)