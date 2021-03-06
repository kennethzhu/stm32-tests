#
# example: LED blink
#

## paths

VPATH += $(PRJ_DIR)/common
VPATH += $(PRJ_DIR)/boards/$(PLAT)/bsp
VPATH += $(PRJ_DIR)/boards/$(PLAT)/apps/leds-pwm

## sources

APP_SRCS := \
	main.c \

APP_OBJS := $(APP_SRCS:.c=.o)
APP_OBJS := $(addprefix $(OBJ_DIR)/,$(APP_OBJS))

## deps

LIBS = $(LIBCM3)

## flags

CFLAGS  = $(PFLAGS) -Wall -Werror -Os -DSTM32F0
CFLAGS += -I$(PRJ_DIR)/include $(LIBCM3_INC)

LDSCRIPT = $(PRJ_DIR)/ld/stm32f030r8-nucleo.ld
LDFLAGS =  $(PFLAGS) -nostartfiles -T$(LDSCRIPT) -Wl,--gc-sections

## rules

leds-pwm: $(OBJ_DIR)/leds-pwm.bin
	cp $(OBJ_DIR)/leds-pwm.bin $(OBJ_DIR)/test.bin
	$(OBJSIZE) $(OBJ_DIR)/leds-pwm.elf

%.hex: %.elf
	$(OBJCOPY) -O ihex $^ $@

%.bin: %.elf
	$(OBJCOPY) -O binary $^ $@

$(OBJ_DIR)/leds-pwm.elf: $(APP_OBJS) $(LIBS) $(LDSCRIPT)
	$(CC) $(LDFLAGS) $(APP_OBJS) $(LIBS) -o $@

$(OBJ_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: %.s
	mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) -o $@ $^
