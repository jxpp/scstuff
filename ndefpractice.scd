s.boot;

(
Ndef(\blap,
{Out.ar([0,1], Mix.ar([
  //BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(freq: 0.4, add: 2)), freq: SinOsc.ar(freq:0.7, mul: 0.5, add: 660.0), rq: Saw.ar(8, add:2)),
  //BPF.ar(BrownNoise.ar(mul: SinOsc.ar(freq: 0.3, add: 2)), freq: SinOsc.ar(freq:0.7, mul: 0.5, add: 440.0), rq: Saw.ar(6, add:2)),
  //SinOscFB.ar([110], feedback: 1),
    LFTri.ar(freq: Line.kr(440, 200, 0.2, doneAction:1), width: SinOsc.kr(0.4,0,0.4,0.5)),
  WhiteNoise.ar(LFPulse.kr(8,0,0.1,0.5)),
  //Saw.ar(freq: 220, mul: 2),
  //BrownNoise.ar(0.5),
]))});
)

Ndef(\blap).play;

(
{Out.ar([0,1], Mix.ar([
  BPF.ar(BrownNoise.ar, 440*LFPulse.ar(4,width:0.3,add:1), 10)
]))}.play;
)

e = Env([0.0,0.0,1.0,0.0],[0.5,1.0,2.0],0,2,0); //releaseNode at 2, loopNode at 0


a= {arg gate=1; EnvGen.ar(e,gate,doneAction:2)*SinOsc.ar(550,0,0.1)}.play


a.set(\gate, 0); //takes 2.0 seconds to fade out


If you set the envelope looping fast enough, you can get interesting control signals and even head towards audio rate waveforms.


e = Env([0.0,1.0,-1.0,0.0],[0.01,0.01,2.0],0,2,0); //releaseNode at 2, loopNode at 0


e.plot


a= {arg gate=1; EnvGen.ar(e,gate,timeScale:MouseX.kr(0.1,2.0),doneAction:2)}.play


a.set(\gate, 0); //stops immediately since release transition to 0.0 occurs over 2 seconds, too slow to be a pitched oscillation






