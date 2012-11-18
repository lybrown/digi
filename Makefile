# $Id: Makefile 36 2008-06-29 23:46:07Z lybrown $

pwm.run:
pcm.run:
pwm.asm: voyage.audf
pcm.asm: voyage.audc

ntsc := 0
atari = /c/Documents\ and\ Settings/lybrown/Documents/Altirra.exe

%.audf: %.wav Makefile
	sox -v 0.45 $< -u -b 8 -r15600 -D -t raw $@ dcshift -0.6 remix -

%.raw: %.wav Makefile
	sox -v 0.08 $< -u -b 8 -r15600 -D $@ remix -

%.audc: %.raw raw2audc
	./raw2audc $< > $@

%.run: %.xex
	$(atari) $<

%.boot: %.atr
	$(atari) $<

%.xex: %.obx
	cp $< $@

%.asm.pl: %.asm.pp
	perl -pe 's/^\s*>>>// or s/(.*)/print <<'\''EOF'\'';\n$$1\nEOF/' $< > $@

%.asm: %.asm.pl
	perl $< > $@
	
%.obx: %.asm
	xasm /l /d:ntsc=$(ntsc) $<

%.atr: %.obx
	./obx2atr $< > $@

zip: pcm.xex pwm.xex
	zip -9 pcm.zip pcm.xex
	zip -9 pwm.zip pwm.xex

clean:
	rm -f *.{obx,atr,lst,asm.pl} *~

.PRECIOUS: %.xex %.ppm %.asm %.asm.pl %.atr
