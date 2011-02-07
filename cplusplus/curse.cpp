
#include <ncurses/curses.h>
#include <signal.h>
#include <iostream>

static void finish(int sig){
  endwin();
  std::cout << "Interrupted" << std::endl;
  exit(0);
}

int main(){

  /* initialize your non-curses data structures here */

  signal(SIGINT, finish);      /* arrange interrupts to terminate */

  initscr();      /* initialize the curses library */
  keypad(stdscr, TRUE);  /* enable keyboard mapping */
  nonl();         /* tell curses not to do NL->CR/NL on output */
  cbreak();       /* take input chars one at a time, no wait for \n */
  noecho();       /* don't echo input */

  if (has_colors())
  {
      start_color();
      /*
       * Simple color assignment, often all we need.
       */
      init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK);
      init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK);
      init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK);
      init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK);
      init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK);
      init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
      init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK);
      init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK);
  }

  while(true){
    std::cout << "key code: " << getch() << "\r" << std::endl;
  }
}
