s.boot;

SynthDef(\paco,{Out.ar([0, 1], RLPF.ar(PinkNoise.ar(), EnvGen.ar(Env.perc, doneAction:2) * MouseX.kr(0, 10000), 0.4))}).add;

(
SynthDef(\bd, {
  var sin;
  sin = SinOscFB.ar(EnvGen.ar(Env.new([1, 0.2], times: [0.08])) * 200 , mul: EnvGen.ar(Env.perc(releaseTime: 1.2), doneAction: 2), feedback: 0.6);
  Out.ar([0, 1], Compander.ar(sin, mul:2));
}).add;
)

(
SynthDef(\hh, {
  arg gate=1.0;
  var noise;
  noise = PinkNoise.ar(mul: EnvGen.ar(Env.perc, gate: gate, doneAction:2) * 1.5);
  Out.ar([0, 1], noise);
}).add;
)

(
SynthDef(\sd, {
  arg gate=1.0;
  var noise;
  noise = BrownNoise.ar(mul: EnvGen.ar(Env.perc(releaseTime: 1), gate: 4.0, doneAction:2)*1.5);
  Out.ar([0, 1], noise);
}).add;
)

Pbind(\instrument, \paco, \degree, 0, \dur, 0.25).play;

(
SynthDef(\dsaw, {
  arg freq=440, gate=1.0;
  var saw1, saw2;
  saw1 = Saw.ar(freq: [freq*0.99, freq*1.01], mul: EnvGen.ar(Env.perc, gate: gate, doneAction:2));
  saw2 = Saw.ar(freq: freq/2, mul: EnvGen.ar(Env.perc, gate: gate, doneAction:2));
  Out.ar([0, 1], FreeVerb.ar(saw1));
}).add;
)

(
Pbind(\instrument, \dsaw, \scale, Scale.phrygian(\just), \degree, Pxrand([0, 2, 3, 4, 5], inf), \dur, 0.25).play;
Pbind(\instrument, \hh, \dur, 0.125, \releaseTime, Pseq([0.05, 0.05, 0.2, 0.05], inf)).play;
Pbind(\instrument, \sd, \dur, Pseq([Rest(0.5), 0.5], inf)).play;
Pbind(\instrument, \bd, \dur, 0.5).play;
)
(
t = Task({
  Pbind(\instrument, \dsaw, \scale, Scale.phrygian(\just), \degree, Pxrand([0, 2, 3, 4, 5], inf), \dur, 0.25).play;
  4.wait;
  ~hh = Pbind(\instrument, \hh, \dur, 0.125, \gate, Pseq([0.5, 0.5, 1.0, 0.5], inf)).play;
  4.wait;
  ~sd = Pbind(\instrument, \sd, \dur, Pseq([Rest(0.5), 0.5], inf)).play;
  8.wait;
  [~hh, ~sd].stop;
  4.wait;
  ~bd = Pbind(\instrument, \bd, \dur, 0.5).play;
  [~hh, ~sd].play;
  8.wait;
  [~bd, ~hh, ~sd].stop;
  Pbind(\instrument, \dsaw, \ctranspose, -12, \scale, Scale.phrygian(\just), \degree, Pxrand([0, 2, 3, 4, 5], inf), \dur, 0.25).play;
  4.wait;
  [~bd, ~hh, ~sd].play;
  8.wait;
  Pbind(\instrument, \dsaw, \ctranspose, 12, \scale, Scale.phrygian(\just), \degree, Pxrand([0, 2, 3, 4, 5], inf), \dur, 0.25).play;
}).play;
)