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

LIBS := -L. -lsx1301hal -lrt -lmpsse -lm -lusb-1.0 -lftdi1

### general build targets

all: libsx1301hal.so test_loragw_hal 

clean:
	rm -f libloragw.so
	rm -f libsx1301hal.so
	rm -f test_loragw_*
	rm -f $(OBJDIR)/*.o
	rm -f inc/config.h

### transpose library.cfg into a C header file : config.h

inc/config.h: ../VERSION library.cfg
	@echo "*** Checking libloragw library configuration ***"
	@rm -f $@
	#File initialization
	@echo "#ifndef _LORAGW_CONFIGURATION_H" >> $@
	@echo "#define _LORAGW_CONFIGURATION_H" >> $@
	# Release version
	@echo "Release version   : $(LIBLORAGW_VERSION)"
	@echo "	#define LIBLORAGW_VERSION	"\"$(LIBLORAGW_VERSION)\""" >> $@
	# Debug options
	@echo "	#define DEBUG_AUX	$(DEBUG_AUX)" >> $@
	@echo "	#define DEBUG_SPI	$(DEBUG_SPI)" >> $@
	@echo "	#define DEBUG_REG	$(DEBUG_REG)" >> $@
	@echo "	#define DEBUG_HAL	$(DEBUG_HAL)" >> $@
	@echo "	#define DEBUG_GPS	$(DEBUG_GPS)" >> $@
	@echo "	#define DEBUG_GPIO	$(DEBUG_GPIO)" >> $@
	@echo "	#define DEBUG_LBT	$(DEBUG_LBT)" >> $@
	# end of file
	@echo "#endif" >> $@
	@echo "*** Configuration seems ok ***"

### library module target

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: src/%.c $(INCLUDES) inc/config.h | $(OBJDIR)
	$(CC) -c $(LCFLAGS) $< -o $@

$(OBJDIR)/loragw_hal.o: src/loragw_hal.c $(INCLUDES) src/arb_fw.var src/agc_fw.var src/cal_fw.var inc/config.h | $(OBJDIR)
	$(CC) -c $(LCFLAGS) $< -o $@

### static library

libsx1301hal.so: $(OBJDIR)/loragw_hal.o $(OBJDIR)/loragw_gps.o $(OBJDIR)/loragw_reg.o $(OBJDIR)/loragw_spi.native.o $(OBJDIR)/loragw_spi.ftdi.o $(OBJDIR)/loragw_aux.o $(OBJDIR)/loragw_radio.o $(OBJDIR)/loragw_fpga.o $(OBJDIR)/loragw_lbt.o $(OBJDIR)/loragw_hal_sx127x.o $(OBJDIR)/gpio.o
	$(CC) $(CFLAGS_SO) -o $@ $^
	ln -sf libsx1301hal.so libloragw.so

### test programs

test_loragw_hal: tst/test_loragw_hal.c libsx1301hal.so
	$(CC) $(LCFLAGS) $< -o $@ $(LIBS)

### EOF
