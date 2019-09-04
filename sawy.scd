s.boot;



(
    SynthDef(
        \sawy,
        {
            arg freq=440, gate=1;
            var saw, sawDetunedLo, sawDetunedHi, mix, lpf;

            saw = LPF.ar(Saw.ar(freq: freq, mul: Env.adsr.kr(gate: gate, doneAction:2)), 500);
            sawDetunedHi = LPF.ar(Saw.ar(freq: freq * 0.99, mul: EnvGen.kr(Env.perc, gate: gate, doneAction: 2)), 500);
            sawDetunedLo = LPF.ar(Saw.ar(freq: freq * 1.01, mul: EnvGen.kr(Env.perc, gate: gate, doneAction: 2)), 500);

            mix = Mix([saw, sawDetunedHi, sawDetunedLo]);

            Out.ar([0, 1], mix);
        }
    ).add;
)

(
SynthDef("moogBass", {
	arg out = 0, pan = 0, freq = 440, amp = 0.1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, att = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

	var osc, filter, env, filterenv, snd, chorusfx;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.asr(0.2, 1, 0.2),
		gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	env = EnvGen.ar(
		envelope: Env.adsr(0.001, 0.3, 0.9, 0.2, amp),
		gate: gate,
		doneAction: 2);

	snd = (0.7 * filter + (0.3 * filter.distort)) * env;

	chorusfx = Mix.fill(7, {

		var maxdelaytime = rrand(0.005, 0.02);
		DelayC.ar(
			in: snd,
			maxdelaytime: maxdelaytime,
			delaytime: LFNoise1.kr(
				freq: Rand(4.5, 10.5),
				mul: 0.25 * maxdelaytime,
				add: 0.75 * maxdelaytime)
		)
	});

	snd = snd + (chorusfx * chorus);

	Out.ar(out, Pan2.ar(snd, pan));

}).add;
)

playScale = Scale.phrygian(\pythagorean);

s.boot;

notes = [-4, -2, 0, 3, 4, 5];

(
    Pbind(
        \instrument, "sawy",
        \scale, Prand([Scale.phrygian, Scale.phrygian(\just)], inf),
        \degree, Pxrand([-4, -6, -8;], inf),
        \dur, Prand([0.125], inf),
	    \amp, 0.5
    ).play;
)

(
a =   Pbind(
        \instrument, "sawy",
        \scale, Prand([Scale.phrygian, Scale.phrygian(\just)], inf),
        \degree, Pxrand([-4, -2, 0, 3, 4, 5], inf),
        \dur, Prand([0.125], inf),
	    \amp, 0.5
    );
)

a.play;

(

b =     Pbind(
	\instrument, \moogBass,
	    \scale, Scale.phrygian,
	    \degree, Pseq([0, -12, -14, -13, -8], inf),
	\dur, Pseq([4], inf),
	\amp, 1, \gain, 1
);
)

b.play;

(
    Pbind(
        \instrument, "sawy",
        \scale, Scale.dorian(\just),
        \degree, Pxrand([0, 2, 4, 6, 8], inf),
        \dur, Prand([0.25, 0.375], inf)
    ).play;

    Pbind(
        \instrument, "sawy",
        \scale, Scale.dorian(\just),
        \degree, Pxrand([-1, -3, -5, -7, -9], inf),
        \dur, Prand([0.125, 0.25], inf)
    ).play;


    Pbind(
        \instrument, "sawy",
        \scale, Scale.dorian(\just),
        \degree, Pxrand([-12, -14, -16, -18], inf),
        \dur, Prand([0.5], inf)
    ).play;
)


(
    var notes, on, off;

    MIDIClient.init;
    MIDIIn.connectAll;

    notes = Array.newClear(128);    // array has one slot per possible MIDI note

    on = MIDIFunc.noteOn({ |veloc, num, chan, src|
        notes[num] = Synth(\sawy, [\freq, num.midicps,
            \gate, veloc * 0.00315]);
        });

    off = MIDIFunc.noteOff({ |veloc, num, chan, src|
        notes[num].release;
    });

    q = { on.free; off.free; };
)
