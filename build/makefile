image:
	dd if=/dev/zero of=disk.img bs=1048576 count=10 
	./mkboot disk.img bootloader.bin
	mv disk.img ../dist/disk.img

clean:
	rm -f ../dist/disk.img
