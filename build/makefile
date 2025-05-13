image:
	dd if=/dev/zero of=disk.img bs=1048576 count=10
	printf "g\nn p\n1\n2048\n+8M\nt\n1\nw\n" | fdisk disk.img
	./mkboot disk.img bootloader.bin
	mv disk.img ../dist/disk.img

clean:
	rm -f ../dist/disk.img
