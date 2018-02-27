#BINDIR= ../bin

# ----------------------------------------------------------------------
# Uncomment the proper CFLAGS line for your machine.
# ----------------------------------------------------------------------

# Mac OS X 10.1
#CC= cc
## CFLAGS = -g       for debugging
#CFLAGS= -O3 -DHASISO646
#LDFLAGS=
#LIBS= -lc

# Linux
CC=g++
## CFLAGS = -g       for debugging
#CFLAGS= -O3 -DHASISO646
CFLAGS= -O3 -DHAS
LDFLAGS= -lstdc++


# Solaris
#CC=gcc
## CFLAGS = -g       for debugging
#CFLAGS= -O4
#LDFLAGS=

# IBM
#CC=gcc
# CFLAGS = -g       for debugging
#CFLAGS= -O3 -fsigned-char
#LDFLAGS=
#LIBS= -lC

#CVOBJ= split_CV.o Instances.o 
CVOBJ= create_folds.o Instances.o

#EXECS= split_CV
EXECS= create_folds

# ----------------------------------------------------------------------
# Rules
# ----------------------------------------------------------------------

all: ${EXECS}

install: all
	cp ${EXECS} ${BINDIR}

backup:
	cp *.c *.h Makefile Backups

cv: ${CVOBJ}
	${CC} ${LDFLAGS} -o cv ${CVOBJ} -lm ${LIBS}

#tar:
#	tar -cvf cv.tar Makefile *.h *.cpp
#g++	gzip cv.tar


clean: 
	rm -f *.o
	rm -f ${EXECS}

# ----------------------------------------------------------------------
# Implicit Rules
# ----------------------------------------------------------------------

%.o : %.cpp
	$(CC) -c $(CFLAGS) $< -o $@


