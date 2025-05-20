#include "kernel_io/stdio.cpp"
#include "kernel_io/stdtimers.cpp"

extern "C" void kernel_main() {
  print("Starting kernel...")      ;
  endl();
  sleep(1);
  clear();
  print("ZernOS | 0.1", Color::DarkCyan);
  // Бесконечный цикл, чтобы остановить выполнение ядра
  while (1) {}
}
