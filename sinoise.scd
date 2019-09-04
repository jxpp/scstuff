(
{
	var sin, noise;
	noise = BrownNoise.ar(mul: 0.5);
	sin = SinOscFB.ar(freq: MouseX.kr(330, 550) + LinExp.ar(LinCongC.ar, -0.5, 0.5, -100, 100), mul: 0.8);
	Out.ar([0, 1], sin);
}.play;
)

(
{
	var sin, noise;
	noise = BrownNoise.ar(mul: 0.5);
	sin = SinOsc.ar(freq: MouseY.kr(120, 440) + LinLin.kr(noise, 0, 2, -50, 50),);
	Out.ar([0, 1], sin);
}.play;
)


(
{
	var sin, noise;
	noise = PinkNoise.ar(mul: 0.5); Pink
	sin = SinOsc.ar(freq: MouseY.kr(660, 1200) + LinExp.ar(noise, -0.1, 1, -100, 100), mul: 0.6);
	Out.ar([0, 1], sin);
}.play;
)

(
SynthDef(\pruebita, {
	|out|
	var mouseX1 = MouseX.kr(100, 660, warp: 0.3, lag: 1);
	var mouseX2 = MouseX.kr(100, 660, warp: 0.3, lag: 2);
	var mouseX3 = MouseX.kr(100, 660, warp: 0.3, lag: 3);
	var mouseX4 = MouseX.kr(100, 660, warp: 0.3, lag: 4);
	Out.ar([0,1], SinOsc.ar(mouseX1) + SinOsc.ar(mouseX2 * 2, mul: 1/2) + SinOsc.ar(mouseX3 * 3, mul: 1/3) + SinOsc.ar(mouseX4 * 4, mul: 1/4))
}).add;
)

a = Synth(\pruebita);

	// Out.ar([0,1], SinOsc.ar(440) + SinOsc.ar(440 * 2, mul: 1/2) + SinOsc.ar(440 * 3, mul: 1/3) + SinOsc.ar(440 * 4, mul: 1/4))}.play;

(
SynthDef(\javito, {
	|freq=440, gate=0, out|
	var env = Env.adsr(sustainLevel: 0);
	Out.ar([0, 1], SinOsc.ar(freq: freq, mul: EnvGen.ar(env, gate: gate, doneAction: Done.freeSelf)));
    }
).add;
)


(
a = Synth(\javito, [\freq, 440, \gate, 1]);
b = Synth(\javito, [\freq, 330, \gate, 1]);
c = Synth(\javito, [\freq, 576, \gate, 1]);
)
//a.play;
a.set(\freq, 330);