### get external defined data

LIBLORAGW_VERSION := `cat ../VERSION`
include library.cfg

### constant symbols

ARCH ?=
CROSS_COMPILE ?=
CC := $(CROSS_COMPILE)gcc
AR := $(CROSS_COMPILE)ar

LCFLAGS := $(CFLAGS) $(LDEF) -fPIC -Iinc -I.
CFLAGS_SO := -shared -O2 -Wall -DLINUX_SO

OBJDIR := obj
INCLUDES := $(wildcard inc/*.h)

### linking options

LIBS := -lsx1302hal -L. -lm

### general build targets

all: 	libsx1302hal.so \
		test_loragw_com \
		test_loragw_i2c \
		test_loragw_reg \
		test_loragw_hal_tx \
		test_loragw_hal_rx \
		test_loragw_cal_sx125x \
		test_loragw_capture_ram \
		test_loragw_com_sx1250 \
		test_loragw_com_sx1261 \
		test_loragw_counter \
		test_loragw_gps \
		test_loragw_toa \
		test_loragw_sx1261_rssi

clean:
	rm -f libsx1302hal.so
	rm -f libloragw.so
	rm -f test_loragw_*
	rm -f $(OBJDIR)/*.o
	rm -f inc/config.h

### transpose library.cfg into a C header file : config.h

inc/config.h: ../VERSION library.cfg
	@echo "*** Checking sx1302hal library configuration ***"
	@rm -f $@
	#File initialization
	@echo "#ifndef _LORAGW_CONFIGURATION_H" >> $@
	@echo "#define _LORAGW_CONFIGURATION_H" >> $@
	# Release version
	@echo "Release version   : $(sx1302hal_VERSION)"
	@echo "	#define sx1302hal_VERSION	"\"$(sx1302hal_VERSION)\""" >> $@
	# Debug options
	@echo "	#define DEBUG_AUX		$(DEBUG_AUX)" >> $@
	@echo "	#define DEBUG_COM		$(DEBUG_COM)" >> $@
	@echo "	#define DEBUG_MCU		$(DEBUG_MCU)" >> $@
	@echo "	#define DEBUG_I2C		$(DEBUG_I2C)" >> $@
	@echo "	#define DEBUG_REG		$(DEBUG_REG)" >> $@
	@echo "	#define DEBUG_HAL		$(DEBUG_HAL)" >> $@
	@echo "	#define DEBUG_GPS		$(DEBUG_GPS)" >> $@
	@echo "	#define DEBUG_GPIO		$(DEBUG_GPIO)" >> $@
	@echo "	#define DEBUG_LBT		$(DEBUG_LBT)" >> $@
	@echo "	#define DEBUG_RAD		$(DEBUG_RAD)" >> $@
	@echo "	#define DEBUG_CAL		$(DEBUG_CAL)" >> $@
	@echo "	#define DEBUG_SX1302	$(DEBUG_SX1302)" >> $@
	@echo "	#define DEBUG_FTIME		$(DEBUG_FTIME)" >> $@
	# end of file
	@echo "#endif" >> $@
	@echo "*** Configuration seems ok ***"

### library module target

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: src/%.c $(INCLUDES) inc/config.h | $(OBJDIR)
	$(CC) -c $(LCFLAGS) $< -o $@

OBJS =		 $(OBJDIR)/loragw_spi.o \
			 $(OBJDIR)/tinymt32.o \
			 $(OBJDIR)/loragw_usb.o \
			 $(OBJDIR)/loragw_com.o \
			 $(OBJDIR)/loragw_mcu.o \
			 $(OBJDIR)/loragw_i2c.o \
			 $(OBJDIR)/sx125x_spi.o \
			 $(OBJDIR)/sx125x_com.o \
			 $(OBJDIR)/sx1250_spi.o \
			 $(OBJDIR)/sx1250_usb.o \
			 $(OBJDIR)/sx1250_com.o \
			 $(OBJDIR)/sx1261_spi.o \
			 $(OBJDIR)/sx1261_usb.o \
			 $(OBJDIR)/sx1261_com.o \
			 $(OBJDIR)/loragw_aux.o \
			 $(OBJDIR)/loragw_reg.o \
			 $(OBJDIR)/loragw_sx1250.o \
			 $(OBJDIR)/loragw_sx1261.o \
			 $(OBJDIR)/loragw_sx125x.o \
			 $(OBJDIR)/loragw_sx1302.o \
			 $(OBJDIR)/loragw_cal.o \
			 $(OBJDIR)/loragw_debug.o \
			 $(OBJDIR)/loragw_hal.o \
			 $(OBJDIR)/loragw_lbt.o \
			 $(OBJDIR)/loragw_stts751.o \
			 $(OBJDIR)/loragw_gps.o \
			 $(OBJDIR)/loragw_sx1302_timestamp.o \
			 $(OBJDIR)/loragw_sx1302_rx.o \
			 $(OBJDIR)/loragw_ad5338r.o

### dynimic library

libsx1302hal.so: $(OBJS)
	$(CC) $(CFLAGS_SO) -o $@ $^
	ln -sf $@  libloragw.so

### test programs

test_loragw_com: tst/test_loragw_com.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.  $< -o $@ $(LIBS)

test_loragw_i2c: tst/test_loragw_i2c.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.  $< -o $@ $(LIBS)

test_loragw_reg: tst/test_loragw_reg.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.  $< -o $@ $(LIBS)

test_loragw_hal_tx: tst/test_loragw_hal_tx.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.  $< -o $@ $(LIBS)

test_loragw_hal_rx: tst/test_loragw_hal_rx.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.  $< -o $@ $(LIBS)

test_loragw_capture_ram: tst/test_loragw_capture_ram.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_cal_sx125x: tst/test_loragw_cal_sx125x.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_com_sx1250: tst/test_loragw_com_sx1250.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_com_sx1261: tst/test_loragw_com_sx1261.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_counter: tst/test_loragw_counter.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_gps: tst/test_loragw_gps.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_toa: tst/test_loragw_toa.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

test_loragw_sx1261_rssi: tst/test_loragw_sx1261_rssi.c libsx1302hal.so
	$(CC) $(LCFLAGS) -L.   $< -o $@ $(LIBS)

### EOF
