s.boot;

a = Harmonics.new(16);
a.ramp(1.0, 1.0);    // returns a harmonic series

b = Buffer.alloc(s, 512, 1);
// harmonic series for freqs, ramp down for amps
b.sine2(a.ramp(1.0, 1.0).postln, a.ramp(0.5, -0.025).postln, true, true, true);
(
z = SynthDef("help-Osc",{ arg out=0,bufnum=0;
    Out.ar(out,
        Osc.ar(bufnum, 200, 0, 0.5)
    )
});
)
y = z.play(s,[\out, 0, \bufnum, b]);
y.free;

a.formant(6, 3);

b.sine2(a.formant(12, 3).postln, a.geom(1.2), true, true, true);
y = z.play(s,[\out, [0, 1], \bufnum, b]);
y.free;