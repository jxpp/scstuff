s.boot;
s.scope;
FreqScope.new;
(
SynthDef.new(\fm, {
  arg freq=500, modFreq=100, modAmp=200, atk=0.01, rel=1, amp=0.2, pan=0;
  var car, mod, env;
  env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
  mod = SinOsc.ar(modFreq, mul: modAmp);
  car = SinOsc.ar(freq + mod) * env * amp;
  car = Pan2.ar(car, pan);
  Out.ar([0, 1], car);
}).add;
)

Pbindef(\testing, \instrument, \fm, \carFreq, Pexprand(20, 10000),  \modFreq, Pexprand(20, 10000), \modAmp, Pwhite(0, 1000, inf), \rel, Pwhite(0, 10, inf), \atk, Pwhite(0, 10)).play;

Synth(\fm, [\carFreq, exprand(20, 10000).postln,  \modFreq, exprand(20, 10000).postln]);//, \modAmp, Pwhite(0, 1000, inf), \rel, Pwhite(0, 10, inf), \atk, Pwhite(0, 10)]);

Pbind(\instrument, \fm, \degree, Pxrand([0,2,3,4,5], inf), \ctranspose, -12, \dur, 0.125, \modFreq, 5226).play;

s.quit;