# 
# VERSION CHANGES
#

# the ?=  sets a default value if not defined already via ENV
FAKE_SERIAL ?= 0
BV=$(shell (git rev-list HEAD --count))
BD=$(shell (date))

LOCATION=/usr/local
CFLAGS=-O0 -ggdb  -DBUILD_VER="$(BV)"  -DBUILD_DATE=\""$(BD)"\" -DFAKE_SERIAL=$(FAKE_SERIAL)
SDLFLAGS=$(shell (sdl2-config --static-libs --cflags))
LIBS=-lSDL2_ttf
OBJ=duratool
CC=gcc
GCC=g++

WINLIBS=-lgdi32 -lcomdlg32 -lcomctl32 -lmingw32
WINCC=i686-w64-mingw32.static-g++
# -fpermissive is needed to stop the warnings about casting stoppping the build
# -municode eliminates the WinMain@16 link error when we're using wWinMain
#WINFLAGS=-municode -static-libgcc -fpermissive -static-libstdc++
WINFLAGS=-municode -static-libgcc -static-libstdc++

WINOBJ=duratool.exe
OFILES=

default: 
	@echo
	@echo "   To make for Windows, 'make win'
	@echo "   To make for linux, 'make linux'
	@echo


.c.o:
	${CC} ${CFLAGS} $(COMPONENTS) -c $*.c

all: ${OBJ} 

linux:
	@echo Build Release $(BV)
	@echo Build Date $(BD)
	${GCC} ${CFLAGS} $(COMPONENTS) Duratool-D03312-sdl2.cpp $(SDLFLAGS) $(LIBS) ${OFILES} -o ${OBJ} 


win: ${OFILES}
	@echo Build Release $(BV)
	@echo Build Date $(BD)
#	ctags *.[ch]
#	clear
	${WINCC} ${CFLAGS} ${WINFLAGS} $(COMPONENTS) Duratool-D03312-win.cpp ${OFILES} -o ${WINOBJ} ${LIBS} ${WINLIBS}

strip: 
	strip *.exe

install: ${OBJ}
	cp Duratool-D03312 ${LOCATION}/bin/

clean:
	rm -f *.o *core ${OBJ} ${WINOBJ}
