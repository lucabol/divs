SHELL := bash
.ONESHELL:
.SILENT:
.SHELLFLAGS := -eu -o pipefail -c

MIXHEADERS  = 'Tik,Name,Sector,M,T,A,Saf,R,U,Yld,Val,GrL,Gr5,G20,GrS,UnS'
MSHEADERS   = 'Tik,Name,Industry,Yld,YldB,M,T,A,R,U,PFV,PEF,PC'
SDSRHEADERS = 'TikS,NameS,Sector,SubSect,MCap,Beta,Time,YldAvg,Val,YldS,PEB,PE5,Saf,GrL,Gr5,G20,GrS,UnS,Dat,Frq,Pay,DtC,DtE,PFCF,RD,RR,Sch,Tax'
SDSHEADERS  = 'TikS,NameS,Sector,Saf,YldS,Val,GrL,Gr5,G20,GrS,UnS'
MSSEL       = 'R,Yld'
SDSSEL      = 'YldS'

COLWIDTH = 20
FMTDISPLAY = body sed 's/Wide/Wd/g;s/Narrow/Nr/g;s/Foreign/F/g;s/Qualified/Q/g;s/Canadian/C/g;s/Stable/=/g;s/Negative/-/g;s/Positive/+/g;s/Standard/=/g;s/Exemplary/+/g;s/Medium/=/g;s/Low/+/g;s/High/-/g' 
.PHONY = all showbest clean

all: best.csv narrowjoined.csv widejoined.csv justwide.csv justverysafe.csv fulljoinded.csv
	$(call show,best.csv,'VERY SAFE - WIDE',$(MIXHEADERS),$(MSSEL))
	$(call show,narrowjoined.csv,'VERY SAFE - NARROW',$(MIXHEADERS),$(MSSEL))
	$(call show,widejoined.csv,'SAFE - WIDE',$(MIXHEADERS),$(MSSEL))
	$(call show,justwide.csv,'JUST WIDE',$(MSHEADERS),$(MSSEL))
	$(call show,justverysafe.csv,'JUST VERY SAFE',$(SDSHEADERS),$(SDSSEL))

define show
	echo
	echo $2
	echo "----------------"
	echo
	<$1 qsv select $3 |
	$(FMTDISPLAY) |
	qsv sort -s $4 -R -N |
	csvlook --max-column-width $(COLWIDTH)
endef

msr.csv: ms.csv
	<$< qsv rename $(MSHEADERS) > $@

sdsr.csv: sds.csv
	<$< qsv rename $(SDSRHEADERS) > $@ 

ms.csv:
	cp "$$(ls -rt /mnt/c/Users/lucabol/Downloads/morn*.csv | tail -n 1)" $@

sds.csv:
	cp "$$(ls -rt /mnt/c/Users/lucabol/Downloads/Screener*.csv | tail -n 1)" $@

fulljoinded.csv: msr.csv sdsr.csv
	qsv join --full 1 $(word 1,$^) 1 $(word 2,$^) > $@
	
joined.csv: msr.csv sdsr.csv
	qsv join 1 $(word 1,$^) 1 $(word 2,$^) > $@

best.csv: joined.csv
	<$< qsv search -s M Wide | qsv search -s Saf '^[9|8].*' > $@

widejoined.csv: joined.csv best.csv
	<joined.csv qsv search -s M Wide | qsv join --left-anti 1 - 1 best.csv > $@

narrowjoined.csv: joined.csv best.csv
	<joined.csv qsv search -s M Narrow | qsv search -s Saf '^[9|8].*' > $@

justwide.csv: joined.csv msr.csv
	<msr.csv qsv search -s M Wide | qsv join --left-anti 1 - 1 joined.csv > $@
	
justverysafe.csv: joined.csv sdsr.csv
	<sdsr.csv qsv search -s Saf '^[9|8].*' | qsv join --left-anti 1 - 1 joined.csv > $@

clean:
	trash *.csv
