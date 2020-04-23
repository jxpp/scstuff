s.boot;

(
SynthDef(\papito, { arg freq=440, gate=1;
    var out;
    out = Saw.ar(freq: freq, mul: EnvGen.ar(Env.adsr, gate: gate, doneAction: 2));
  Out.ar([0, 1], RLPF.ar(out, freq: freq * 3 * EnvGen.ar(Env.perc(0, 0.5), gate: gate, doneAction: 2), rq: 0.4));
  }
).add;
)

(
Pbindef(\blapiti,
  \instrument, \papito,
  \degree, Pseq([0, 0, 0, 3, 0, 4, 6], inf),
  \dur, 0
).play;
)