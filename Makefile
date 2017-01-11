USBH		= /usr/include/usb.h
TEMPERSRC	= temper/temper.c
TEMPER		= temper/temper
DAEMON		= /usr/local/sbin/temperd
SERVICE		= /etc/systemd/system/temperd.service

all: $(USBH) $(TEMPER)

$(TEMPER): $(TEMPERSRC)
	sh -c 'cd temper;patch -p1 < ../temper.diff'
	make -C temper

$(TEMPERSRC):
	git clone git://github.com/bitplane/temper.git

$(USBH):
	apt-get install libusb-dev

install: all
	make -C temper install
	install daemon/temperd $(DAEMON)
	install daemon/temperd.service $(SERVICE)
	tools/modify_rsyslog.conf
	systemctl daemon-reload
	systemctl enable temperd.service
	systemctl restart temperd.service
	systemctl restart syslog.service

uninstall: all
	make -C temper uninstall
	systemctl stop temperd.service
	systemctl disable temperd.service
	rm -f $(DAEMON) $(SERVICE)

clean:
	rm -rf temper
