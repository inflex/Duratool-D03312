# 
# VERSION CHANGES
#

# the ?=  sets a default value if not defined already via ENV
FAKE_SERIAL ?= 0
BV=$(shell (git rev-list HEAD --count))
BD=$(shell (date))

LOCATION=/usr/local
CFLAGS=-O -DBUILD_VER="$(BV)"  -DBUILD_DATE=\""$(BD)"\" -DFAKE_SERIAL=$(FAKE_SERIAL)
LIBS=
WINLIBS=-lgdi32 -lcomdlg32 -lcomctl32 -lmingw32
WINCC=i686-w64-mingw32.static-g++
# -fpermissive is needed to stop the warnings about casting stoppping the build
# -municode eliminates the WinMain@16 link error when we're using wWinMain
#WINFLAGS=-municode -static-libgcc -fpermissive -static-libstdc++
WINFLAGS=-municode -static-libgcc -static-libstdc++

WINOBJ=Duratool-D03312.exe
OFILES=

default: 
	@echo
	@echo "   To make a GUI; make Duratool-D03312"
	@echo "   To make a GUI test;  export FAKE_SERIAL=1 && make Duratool-D03312"
	@echo

default: Duratool-D03312

.c.o:
	${CC} ${CFLAGS} $(COMPONENTS) -c $*.c

all: ${OBJ} 

Duratool-D03312: ${OFILES} Duratool-D03312.cpp 
	@echo Build Release $(BV)
	@echo Build Date $(BD)
#	ctags *.[ch]
#	clear
	${WINCC} ${CFLAGS} ${WINFLAGS} $(COMPONENTS) Duratool-D03312.cpp ${OFILES} -o Duratool-D03312.exe ${LIBS} ${WINLIBS}

strip: 
	strip *.exe

install: ${OBJ}
	cp Duratool-D03312 ${LOCATION}/bin/

clean:
	rm -f *.o *core ${OBJ} ${WINOBJ}
