(
SynthDef(\fm, {
		arg freq=500, mRatio=1, cRatio=1,
		index=1, iScale=5, cAtk=4, cRel=(-4),
		amp=0.2, atk=0.01, rel=3, pan=0,
		out=0, fx=0, fxsend=(-25), modFb=0.15;
		var car, mod, env, iEnv;

		//index of modulation
		iEnv = EnvGen.kr(
			Env(
				[index, index*iScale, index],
				[atk, rel],
				[cAtk, cRel]
			)
		);

		//amplitude envelope
		env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);

		//modulator/carrier
    mod = SinOscFB.ar(freq * mRatio, mul:freq * mRatio * iEnv, feedback: modFb);
    car = SinOsc.ar(freq * cRatio + mod) * env * (amp / 10);

    car = Mix.ar([car/2, car/2.01, car/1.99]);



		car = Pan2.ar(car, pan);

		//direct out/reverb send
		Out.ar(out, car);
		Out.ar(fx, car * fxsend.dbamp);
	}).add;
)
(
SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500;
		var sig;
		sig = In.ar(in, 2).sum;
		sig = DelayN.ar(sig, 0.03, 0.03);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = SplayAz.ar(2, sig);
		sig = LPF.ar(sig, lpf);
		5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;
)

s.sync;

~vbus = Bus.audio(s, 2);
Synth(\reverb, [\in, ~vbus]);


s.boot;
s.quit;

(
Pbind(
  \instrument, \fm,
  \scale, Scale.phrygian,
  \degree, Pxrand([0,2,3,4,5,7], inf),
  \ctranspose, -12,
  \modFb, 0.1,
  \cRatio, 2,
  \mRatio, 1,
  \index, 1.2,
  \iScale, 4,
  \cRel, -4,
  \cAtk, 1,
  \dur, 0.125,
  \fx, ~vbus,
  \fxsend, -5
).play(quant: 0);
)
Pbind(
  \instrument, \fm,
  \ctranspose, -12,
  \scale, Scale.minor,
  \rel, 10,
  \atk, 0.3,
  \cRatio, 2,
  \mRatio, 1,
  \index, 1.5,
  \iScale, 2.5,
  \modFb, 0,
  \cAtk, 1,
  \cRel, -1,
  \degree, Pseq([[0, 2, 4, 6], [3, 5, 7, 9], [2, 5, 7, 9], [4, 6, 8, 2]], inf),
  \dur, 4,
  \amp, 0.15,
  \fx, ~vbus,
  \fxsend, 0
).play(quant: 16);
Pbind(
  \instrument, \fm,
  \ctranspose, -36,
  \scale, Scale.minor,
  \modFb, 0.1,
  \rel, 2,
  \mRatio, 1,
  \cRatio, 1,
  \index, 1,
  \iScale, 10,
  \degree, Pseq([0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,4,4,4,4,4,4,2,2], inf),
  \dur, 0.5,
  \amp, 0.2,
).play(quant:32);
)
Pbindef(\bass, pairs: []);
(
Pbindef(\melody).play(quant: 0);
Pbindef(\pad).play(quant: 16);
Pbindef(\bass).play(quant: 0);
)

(Pbindef(\bass2,
  \instrument, \fm,
  \ctranspose, -36,
  \scale, Scale.minor,
  \modFb, 0.1,
  \rel, 2,
  \mRatio, 1,
  \cRatio, 1,
  \index, 1,
  \iScale, 10,
  \degree, Pseq([0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,4,4,4,4,4,4,2,2], inf),
  \dur, 0.5,
  \amp, 0.5,
).play;)

s.quit;