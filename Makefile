### Environment constants

ARCH ?=
CROSS_COMPILE ?=

LDEF = -DCFG_bdate='"$(shell date -u '+%Y-%m-%d %H:%M:%S')"'
export LDEF += -DCFG_version='"$(shell if [ -f VERSION ]; then cat VERSION; else V1.0.1; fi)"'

### general build targets

.PHONY: all clean install sx1302hal sx1301hal fwd_sx1301 fwd_sx1302 libmqtt station_sx1302 station_sx1301 prepare deb

all: fwd_sx1302 fwd_sx1301 station_sx1302 station_sx1301 deb

prepare: prep.sh
	./prep.sh

sx1301hal: 
	$(MAKE) all -e -C $@

sx1302hal: 
	$(MAKE) all -e -C $@

libmqtt: 
	$(MAKE) all -e -C $@

libmbedtls:
	$(MAKE) all -e -C libmbedtls

fwd_sx1301: sx1301hal libmqtt prepare
	$(MAKE) all -e -C build_fwd_sx1301 SX1301MOD=1

fwd_sx1302: sx1302hal libmqtt prepare
	$(MAKE) all -e -C build_fwd_sx1302 SX1302MOD=1

station_sx1302: sx1302hal prepare
	$(MAKE) all -e -C build_station_sx1302 SX1302MOD=1

station_sx1301: sx1301hal prepare
	$(MAKE) all -e -C build_station_sx1301 SX1301MOD=1

clean:
	$(MAKE) clean -e -C sx1301hal
	$(MAKE) clean -e -C sx1302hal
	$(MAKE) clean -e -C libmqtt
	rm -rf build_*_sx*
	rm -rf draginofwd.deb

deb: fwd_sx1301 fwd_sx1302 station_sx1301 station_sx1302
	rm -rf pi_pkg
	mkdir -p pi_pkg/usr/bin
	mkdir -p pi_pkg/usr/lib
	mkdir -p pi_pkg/lib/systemd/system
	mkdir -p pi_pkg/etc/lora-gateway
	cp -rf DEBIAN pi_pkg
	cp -rf draginofwd.service pi_pkg/lib/systemd/system
	cp -rf config pi_pkg/etc/lora-gateway
	cp -f config/global_conf.json pi_pkg/etc/lora-gateway
	cp -f config/local_conf.json pi_pkg/etc/lora-gateway
	install -m 755 libmqtt/libpahomqtt3c.so pi_pkg/usr/lib
	install -m 755 sx1301hal/libsx1301hal.so pi_pkg/usr/lib
	install -m 755 sx1302hal/libsx1302hal.so pi_pkg/usr/lib
	install -m 755 build_station_sx1301/build-mips-openwrt-dragino/lib/libmbed* pi_pkt/usr/lib
	install -m 755 build_fwd_sx1301/fwd_sx1301 pi_pkg/usr/bin
	install -m 755 build_fwd_sx1302/fwd_sx1302 pi_pkg/usr/bin
	install -m 755 build_station_sx1301/build-mips-openwrt-dragino/bin/station_sx1301 pi_pkg/usr/bin
	install -m 755 build_station_sx1302/build-mips-openwrt-dragino/bin/station_sx1302 pi_pkg/usr/bin
	install -m 755 tools/reset_lgw.sh pi_pkg/usr/bin
	dpkg -b pi_pkg draginofwd.deb
	rm -rf pi_pkg

install: 
	echo "Starting install dragino lora packages forward..."
	install -d /etc/lora
	cp -rf config /etc/lora
	cp -f config/global_conf.json /etc/lora
	cp -f config/local_conf.json /etc/lora
	cp -f draginofwd.service /lib/systemd/system 
	install -m 755 sx1301hal/libsx1301hal.so /usr/lib
	install -m 755 sx1302hal/libsx1302hal.so /usr/lib
	install -m 755 build_fwd_sx1301/fwd_sx1301 /usr/bin
	install -m 755 build_fwd_sx1302/fwd_sx1302 /usr/bin
	install -m 755 build_station_sx1301/build-mips-openwrt-dragino/lib/libmbed* /usr/lib
	install -m 755 build_station_sx1301/build-mips-openwrt-dragino/bin/station_sx1301 /usr/bin
	install -m 755 build_station_sx1302/build-mips-openwrt-dragino/bin/station_sx1302 /usr/bin
	install -m 755 tools/reset_lgw.sh /usr/bin
	ln -sf /usr/bin/fwd_sx1302 /usr/bin/fwd
	echo "Starting dragino forward for sx1302 ..."
	systemctl enable draginofwd
	systemctl start draginofwd
	echo "INSTALL DONE!"

uninstall:
	echo "Starting remove dragino lora packages forward..."
	rm -rf /etc/lora
	rm -rf /usr/lib/libpahomqtt3c.so
	rm -rf /usr/lib/libsx130*.so
	rm -rf /usr/bin/fwd*
	systemctl disable draginofwd
	systemctl stop draginofwd
	echo "UNINSTALL DONE!"

### EOF
