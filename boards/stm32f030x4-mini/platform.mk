#
# arch: arm cortex-m0
# chip: stm32f030f4p6
# platform: stm32f030f4p6 bare metal
# description: minimal stm32f030f4p6 board
#

## toolchain

CROSS_COMPILE = arm-none-eabi

CC		= $(CROSS_COMPILE)-gcc
LD		= $(CROSS_COMPILE)-ld
OBJCOPY = $(CROSS_COMPILE)-objcopy
OBJSIZE = $(CROSS_COMPILE)-size

## platform identifiers

CHIP = stm32f0

## platform dependencies

LIBCM3_TARGET	= stm32/f0
LIBCM3_FPFLAGS	= -msoft-float

deps: libopencm3

## platform-specific compile flags

PFLAGS = \
	-mthumb			\
	-mcpu=cortex-m0		\
	-msoft-float		\

## projects

TARGETS = "leds-mini leds-systick"

ifeq ($(MAKECMDGOALS), leds-mini)
include $(PRJ_DIR)/boards/$(PLAT)/apps/leds-mini/build.mk
endif

ifeq ($(MAKECMDGOALS), leds-systick)
include $(PRJ_DIR)/boards/$(PLAT)/apps/leds-systick/build.mk
endif

## platform-specific flash rules

upload:
	openocd -f $(PRJ_DIR)/boards/$(PLAT)/scripts/openocd-jlink-swd.cfg -c 'program ()'

debug:
	openocd -f $(PRJ_DIR)/boards/$(PLAT)/scripts/openocd-jlink-swd.cfg -c 'attach ()'