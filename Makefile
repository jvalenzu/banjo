DOCSDIR=Docs
FINALPNG=$(foreach p,A♭.png A.png B♭.png B.png C.png C♯.png C_major_7.png C_major_7_fingering.png D♭.png D.png D♯.png E♭.png E.png F♯.png F.png G♭.png G.png G♯.png,$(DOCSDIR)/$(p))

test: $(FINALPNG)

%.pdf : %.dvi
	dvipdf $<

$(DOCSDIR)/%.png : %.pdf
	convert -density 300 $< $@

%.dvi : %.tex
	latex $<
clean:
	rm -f A♭.pdf A.pdf B♭.pdf B.pdf C.pdf C♯.pdf C_major_7.pdf C_major_7_fingering.pdf D♭.pdf D.pdf D♯.pdf E♭.pdf E.pdf F♯.pdf F.pdf G♭.pdf G.pdf G♯.pdf A♭.png A.png B♭.png B.png C.png C♯.png C_major_7.png C_major_7_fingering.png D♭.png D.png D♯.png E♭.png E.png F♯.png F.png G♭.png G.png G♯.png A♭.dvi A.dvi B♭.dvi B.dvi C.dvi C♯.dvi C_major_7.dvi C_major_7_fingering.dvi D♭.dvi D.dvi D♯.dvi E♭.dvi E.dvi F♯.dvi F.dvi G♭.dvi G.dvi G♯.dvi A♭.aux A.aux B♭.aux B.aux C.aux C♯.aux C_major_7.aux C_major_7_fingering.aux D♭.aux D.aux D♯.aux E♭.aux E.aux F♯.aux F.aux G♭.aux G.aux G♯.aux A♭.log A.log B♭.log B.log C.log C♯.log C_major_7.log C_major_7_fingering.log D♭.log D.log D♯.log E♭.log E.log F♯.log F.log G♭.log G.log G♯.log A♭.tex A.tex B♭.tex B.tex C.tex C♯.tex C_major_7.tex C_major_7_fingering.tex D♭.tex D.tex D♯.tex E♭.tex E.tex F♯.tex F.tex G♭.tex G.tex G♯.tex

distclean: clean
	rm -f $(FINALPNG)
