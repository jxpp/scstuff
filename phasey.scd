s.boot;

{LFPulse.ar(110!2, width: SinOsc.ar(1, mul: 0.4, add: 0.5))}.play;
{LFPulse.ar(110!2, width: SinOsc.ar(0.3, mul: 0.4, add: 0.5))}.play;
{LFPulse.ar(110!2, width: SinOsc.ar(0.7, mul: 0.4, add: 0.5))}.play;

(
SynthDef(\paco,
  {arg freq=440, gate=1; Out.ar([0,1], BPF.ar(FreeVerb.ar(SinOsc.ar((freq * [1])!2, phase: Line.kr(3000, 1000), mul: EnvGen.kr(Env.perc, doneAction:2)), mix: 1), freq: Line.kr(880, 440), rq: MouseX.kr(0, 2)))}).add;
)
Com
Pbindef(\blap, \instrument, \paco, \transpose, 12, \scale, Scale.phrygian, \degree, Pxrand([0,1,3,5,6,7], inf), \dur, 0.25).play;

Pbindef(\blep, \scale, Scale.phrygian, \degree, Pxrand([0,1,3,5,6,7], inf)).play;

((doneAction: 2)
{
  var rand = 880 * ExpRand(0.2, 1.0);
  SinOsc.ar(Line.kr(rand, rand/2, dur: 0.3, doneAction:2), phase: SinOsc.ar(ExpRand(200, 2000)));
}.play;
)