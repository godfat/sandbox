
// http://games.slashdot.org/comments.pl?sid=1347753&cid=29197927

#include <stdio.h>

void    *f(void)
{
a:
    printf("Here!\n");
    return &&a;
}

int     main(int ac, char **av)
{
    goto *f();
    printf("There\n");
    return 0;
}
