USBH		= /usr/include/usb.h
TEMPERSRC	= temper/temper.c
TEMPER		= temper/temper

all: $(USBH) $(TEMPER)

$(TEMPER): $(TEMPERSRC)
	make -C temper

$(TEMPERSRC):
	git clone git://github.com/bitplane/temper.git

$(USBH):
	apt-get install libusb-dev

install: all
	make -C temper install

uninstall: all
	make -C temper uninstall

clean:
	rm -rf temper
