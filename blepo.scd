s.boot;

{SinOsc.ar(500!2)}.play;
{SinOsc.ar(500!2, phase:SinOsc.ar(0.3, mul:7))}.play;
{SinOsc.ar(110!2, phase:SinOsc.ar(0.3, mul:8))}.play;
{SinOsc.ar(110!2, phase:SinOsc.ar(0.7, mul:3))}.play;
{SinOsc.ar(110!2, phase:SinOsc.ar(1, mul:4))}.play;
{SinOsc.ar(110!2, phase:SinOsc.ar(2, mul:8))}.play;

{RLPF.ar(SinOsc.ar(ExpRand(0.5, 4)*440!2, 0.0, phase:SinOsc.ar(ExpRand()*2000, phase: SinOsc.ar(ExpRand()*2000)), mul: EnvGen.kr(Env.perc(releaseTime: ExpRand(0.2, 5.0)), doneAction:2)), freq: Line.kr(880, 220, 2.0), rq:0.1)}.play;

{LFPulse.ar(110!2, iphase: LFPulse.ar(440*SinOsc.ar(0.1)))}.play;


s.boot

//1/D - Code a list processing IIR & FIR and show the impulse responses for LPF, HPF and Comb

//IIR LPF & HPF
a=[1,0,0,0,0,0,0,0,0,0,0];

g={|cof=0.9| var prev=0;
	{|in|
		prev=prev+in*cof;
	}
}

//Circular Buffer
~circGen={|len=4| var mem, pointer=0;
	mem=Array.fill(len,0);
	{|in| var out;
		mem[pointer%len]=in;
		out=mem[pointer-(len-1)%len];
		pointer=pointer+1;
		out;
	}
}

~circ=~circGen.(3);

//IIR Comb
g={|cof=0.9| var circ,prev=0,out;
	circ=~circGen.(3);
	{|in|
		prev=circ.(prev)+in*cof;
	}
}

f=g.(0.9);
z=a.collect(f);
z.plot

//FIR LPF & HPF
a=[1,0,0,0,0,0,0,0,0,0,0];

g={|cof=0.9| var prev=0,out;
	{|in|
		out=prev+in*cof;
		prev=in;
		out;
	}
}

f=g.(-0.9);

a.collect(f).plot

//FIR Comb
g={|cof= -0.9| var circ,prev=0,out;
	circ=~circGen.(3);
	{|in|
		out=circ.(prev)+in*cof;
		prev=in;
		out;
	}
}

f=g.(-0.9);
z=a.collect(f);
z.plot


//2/D - Code a list processsing Rise-Decay (Attack-Release) filter

a=[0.2,0.4,0.6,0.8,1,0,0,0,1,0.8,0.6,0.4,0.2,0,0,0];

g={|cof1=0.1, cof2=0.9| var prev=0,cof,out;
	{|in|
		(in>prev).if({cof=cof1},{cof=cof2});
		out=prev+in*cof;
		prev=in;
		out;
	}
}

f=g.value();

[a,a.collect(f)].plot;

//3/D - Using one sample delay, code FIR - LPF, HPF Comb and verify the spectral response in relation to the coefficient

//FIR Comb
{
	a=WhiteNoise.ar;
	b=DelayN.ar(a,0.1,0.0002);
	a-b;

}.freqscope

//IIR Comb
Server.killAll
s.options.blockSize_(2048);
s.boot;

{
	a=WhiteNoise.ar;
	a=a+LocalIn.ar*0.97;
	LocalOut.ar(a);
	a;
}.freqscope


//4/D - Experiment with Spring and Ball Ugens, verify the spectral response and make a bouncing ball sound

{
	a=Trig.ar(1);
	Ball.ar(a,10,0.5,0.1)*0.1;
}.freqscope


//5/D - Code the Schroeder reverb

{ var in;
	in=Trig.ar(1);
	in=Array.fill(4,CombN.ar(in,0.2,0.01.rrand(0.2))).sum;
	4.do({ in=AllpassN.ar(in,0.2,0.01.rrand(0.2)) });
	in;
}.play