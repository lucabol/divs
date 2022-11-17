SHELL := bash
.ONESHELL:
.SILENT:
.SHELLFLAGS := -eu -o pipefail -c

HEADERS = 'Tik,Name,Sector,M,T,A,Saf,R,U,Yld,Val,GrL,Gr5,G20,GrS,UnS'
COLWIDTH = 20
FMTDISPLAY = body sed 's/Wide/Wd/g;s/Narrow/Nr/g;s/Foreign/F/g;s/Qualified/Q/g;s/Canadian/C/g;s/Stable/=/g;s/Negative/-/g;s/Positive/+/g;s/Standard/=/g;s/Exemplary/+/g;s/Medium/=/g;s/Low/+/g;s/High/-/g' 
.PHONY = all showbest clean

all: best.csv narrowjoined.csv widejoined.csv
	$(call show,best.csv,'VERY SAFE - WIDE')
	$(call show,narrowjoined.csv,'VERY SAFE - NARROW')
	$(call show,widejoined.csv, 'SAFE - WIDE')

define show
	echo
	echo $2
	echo "----------------"
	echo
	<$1 qsv select $(HEADERS) |
	$(FMTDISPLAY) |
	qsv sort -s R,Yld -R -N |
	tee $1.tmp |
	csvlook --max-column-width $(COLWIDTH)
endef

msr.csv: ms.csv
	<$< qsv rename Tik,Name,Industry,YldF,YldB,M,T,A,R,U,PFV,PEF,PC > $@

sdsr.csv: sds.csv
	<$< qsv rename Tik,Name,Sector,SubSect,MCap,Beta,Time,YldAvg,Val,Yld,PEB,PE5,Saf,GrL,Gr5,G20,GrS,UnS,Dat,Frq,Pay,DtC,DtE,PFCF,RD,RR,Sch,Tax > $@ 

ms.csv:
	cp "$$(ls -rt /mnt/c/Users/lucabol/Downloads/morn*.csv | tail -n 1)" $@

sds.csv:
	cp "$$(ls -rt /mnt/c/Users/lucabol/Downloads/Screener*.csv | tail -n 1)" $@

joined.csv: msr.csv sdsr.csv
	qsv join 1 $(word 1,$^) 1 $(word 2,$^) > $@

best.csv: joined.csv
	<$< qsv search -s M Wide | qsv search -s Saf '^[9|8].*' > $@

widejoined.csv: joined.csv best.csv
	<joined.csv qsv search -s M Wide | qsv join --left-anti 1 - 1 best.csv > $@

narrowjoined.csv: joined.csv best.csv
	<joined.csv qsv search -s M Narrow | qsv search -s Saf '^[9|8].*' > $@

clean:
	trash *.csv
