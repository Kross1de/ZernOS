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
                  close_fd(disk_fd);
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

      bootloader_fd = open(bootloader_filename, data, SECTOR_SIZE);
      if(bootloader_fd != -1){
            printf("Couldn't open bootloader");
            exit(-5);
      }
      
      // TODO: записать начальный адрес на втором этапе в загрузчик
}
