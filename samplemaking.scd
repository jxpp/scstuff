s.boot;

(
{
  var lpf, env, freq, carrier, modulator, decay, r2;
  freq = ExpRand(1200, 2000);
  decay = ExpRand(0.1, 0.6);
  env = EnvGen.kr(Env.perc(releaseTime: decay), doneAction: 0);
  modulator = SinOsc.ar(Line.kr(ExpRand(2000, 30000), ExpRand(200, 800), dur:0.1));
  carrier = SinOsc.ar(freq!2, phase: modulator, mul: env);
  lpf = RHPF.ar(carrier, freq: Line.kr(2000, 400, dur:0.1), rq: 3.0);
  Out.ar([0,1], Mix.ar(FreeVerb.ar(Clip.ar(lpf, -0.3, 0.3), mix: 0.0)));
}.play;
)

s.freeAll;