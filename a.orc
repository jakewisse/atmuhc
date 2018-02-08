sr = 44100
kr = 44100
ksmps = 1
nchnls = 2

/* BT Bomb Ass NuKick */
/* 1 VCO, Ramp Oscil through 3 ramping filters and clip*/

instr 101

ivol = p4
ipw = 1.7
ileak = .95 
kamp linseg 32000, .001, 24000, p3*.4, 12000, p3*.599, 0
kampline line 1, p3*.95, 0
kcf linseg 300, p3*.1, 50
kcf2 linseg 3, p3*.5, .1, p3*.4, .01
kcf3 expseg 500, p3*.1, 70, p3*.2, 55
abtkck vco kamp, cpspch(p5), 3, ipw, 1, ileak, .69
ares reson abtkck, kcf, 10
afilt2 lowres ares, kcf2, 0.6
aclip clip afilt2, 1, 18000
aBTkick lowpass2 aclip, kcf3, 1

outs (aBTkick*ivol)*kampline, (aBTkick*ivol)*kampline
endin

instr 102

; BT White Noise through 8 stresons, output thorugh tan distortion 
; mixed with origional output and tuned to p5

ivol = p4
kamp linseg 22000, p3*.01, 15000, p3*.89, 0
kamp2 linseg 39000, p3*.009, 13000, p3*.6, 0
kbetaL line 1, p3*.8, .1
kbetaR line .9, p3*.9, .2
kfrqratio line 3, p3, 1 
kfco linseg 1000, p3*.09, 500, p3*.8, 100
kfreq line 120, p3*.3, 6000
kfreq2 linseg 700, p3*.001, 100, p3*.7, 2000
kcf line 500, p3*.3, 30
kbw linseg 1, p3*.3, 20, p3*.4, 100
klpf line 2000, p3*.9, 500
kpitchenv1 linseg cpspch(p5+3.07), p3*.06, cpspch(p5), p3*.94, cpspch(p5)
kpitchenv2 linseg cpspch(p5+3.07), p3*.06, cpspch(p5+1.07), p3*.94, cpspch(p5+1.07)
kpluckhp line 120, p3*.1, 2300
aL noise kamp, kbetaL
aR noise kamp, kbetaR
astL streson aL, cpspch (p5)-0.2, .3
astR streson aR, cpspch (p5)+.02, .3
astL2 streson astL, cpspch(p5+1.07)+0.3, .3
astR2 streson astR, cpspch(p5+1.00)-0.3, .2
astL3 streson astL2, cpspch(p5+2.00)+0.7, .3
astR3 streson astR2, cpspch(p5+3.07)-0.7, .3
astL4 streson astL3, cpspch(p5+4.07)+0.3, .5
astR4 streson astR3, cpspch(p5+4.00)-0.3, .4
aosc oscil kamp2, kpitchenv1, 2
aosc2 oscil kamp2, kpitchenv2, 2
aosc3 oscil kamp2, cpspch(p5+1.0), 2
a6 pluck 20000, cpspch(p5+1.00), 12, 10, 3, .3
a7 pluck 18000, cpspch(p5+1.07), 12, 11, 3, .9
a8 pluck 10000, cpspch(p5+1.00), 180, 12, 3, .94
a9 pluck 12000, cpspch(p5), 20, 13, 3, .3
a10 pluck 12000, cpspch(p5+2.00), 20, 14, 3, .92
apluck = a6+a7+a8+a9+a10
apluckhp butterhp apluck, kpluckhp
amainL clip astL4+aosc+aosc2+aosc3, 3, 12000
amainR clip astR4+aosc+aosc2+aosc3, 3, 12000
anormalL = amainL/32768
aresonL resonr amainL, kcf, 500
aresonR resonr amainR, kcf, 500
abutterL butterhp aresonL, kfreq
abutterR butterhp aresonR, kfreq
aoutL = abutterL+(astL*.3)
aoutR = abutterR+(astR*.3)
aoutLhp butterhp aoutL, kfreq2
aoutRhp butterhp aoutR, kfreq2
aoutclipL clip aoutLhp, 1, 11000
aoutclipR clip aoutRhp, 1, 11000
aoutnormL = aoutclipL/32768
aoutnormR = aoutclipR/32768
alpfL lpf18 aoutnormL, klpf, .4, 12
alpfR lpf18 aoutnormR, klpf, .4, 12
alHPL butterhp alpfL*12000, 120
alHPR butterhp alpfR*12000, 120
outs (aosc+aoutLhp+alHPL+apluckhp)*ivol,(aosc+aoutRhp+alHPR+apluckhp)*ivol
endin

instr 103
/*a white noise hi-hat for glitch*/

ivol = p4
kbeta linseg 0, p3*.7, .1, p3*.909, .3
khp linseg 500, p3*.001, 10000, p3*.909, 10000
kamp linseg 41000, p3*.001, 14000, p5, 0, p3*.89, 0
a1 noise kamp, kbeta
ahp butterhp a1, khp
ahp1 butterhp ahp, 500
outs ahp1*ivol, ahp1*ivol
endin
