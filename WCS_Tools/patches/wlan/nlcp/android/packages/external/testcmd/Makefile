CC = $(CROSS_COMPILE)gcc
CFLAGS = -O2
CFLAGS += -DCONFIG_LIBNL20
CFLAGS += -I$(LIBNL_PATH)/include

LDFLAGS += -L$(LIBNL_PATH)/lib/.libs
LIBS += -lnl -lnl-genl -lm

OBJS = commands.o iw.o

%.o: %.c iw.h nl80211.h
	$(CC) $(CFLAGS) -c -o $@ $<

all: testcmd

testcmd: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o testcmd

clean:
	rm -f *.o testcmd	
