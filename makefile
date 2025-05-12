bootloader:
	mkdir build
	make -C bootloader all

all: bootloader 

clean:
	rm -r build
