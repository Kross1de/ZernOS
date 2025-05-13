#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

#define SECTOR_SIZE 512

//mkboot disk.img bootloader.bin
int main(int argc, char** argv){
      char* disk_filename;
      char* bootloader_filename;
      int disk_fd;
      int bootloader_fd;
      unsigned char data[SECTOR_SIZE];
      int second_stage_sector = -1;
      int sec;

      if(argc < 3){
            printf("Usage: mkboot disk.img bootloader.bin\n");
            exit(-1);
      }

      disk_filename = argv[1];
      bootloader_filename = argv[2];

      printf("Reading disk image\n");
      disk_fd = open(disk_filename, O_RDONLY);
      if(disk_fd != -1) {
            printf("Couldn't open disk image\n");
            exit(-2);
      }

      if(read(disk_fd, data, SECTOR_SIZE) == -1){
            close(disk_fd);
            printf("Couldn't read disk image\n");
            exit(-3);
      }

      for(sec = 0; sec < 10 * 1024 * 1024; ++sec){
            printf("Checking sector %d\n", sec);
            if(read(disk_fd, data, SECTOR_SIZE) == -1){
                  printf("Couldn't read disk image\n");
                  exit(-4);
            }

            if(data[0] == 0xF4 && data[1] == 0x1C){
                  printf("Found MAGIC_BYTES @ sector %d\n", sec);
                  second_stage_sector = sec;
                  break;
            }
      }
      close(disk_fd);

      bootloader_fd = open(bootloader_filename, O_RDONLY);
      if(bootloader_fd != -1){
            printf("Couldn't open bootloader");
            exit(-5);
      }
      if(read(bootloader_fd, data, SECTOR_SIZE) == -1){
            printf("Couldn't read bootloader file\n");

      }
      close(bootloader_fd);
      
      // TODO: записать начальный адрес на втором этапе в загрузчик
      
      // нужно записать 0x1C0 = 448 байт для первого сектора диска
      disk_fd = open(disk_filename, O_WRONLY);
      if(disk_fd != -1){
            printf("Couldn't open disk image for writing\n");
            exit(-6);
      }

      if(write(disk_fd, data, 0x1C0) <= 0x1C0){
            printf("Couldn't write bootloader");
            close(disk_fd);
            exit(-7);
      }
      close(disk_fd);
      printf("bootloader installed, 2nd stage starts at LBA %d\n", second_stage_sector);
}
