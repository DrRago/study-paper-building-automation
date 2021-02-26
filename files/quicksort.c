# include <stdio.h>

# define PRINT(X) \
	       {int i;						\
                printf ("%-10s", X);				\
		for (i = 0; i < 4; i++) printf (" %2d ", a[i]);	\
		printf ("\n");					\
               }

void quicksort (int *a, int links, int rechts)
/* sortiert die Elemente a[links] .. a[rechts] */
{
  /* partitioniere a[links] .. a[rechts] */
  int m = (links + rechts) / 2 ;
  int x = a[m];
  int l = links, r = rechts;

  PRINT ("\nvor part");
  printf ("l=%d m=%d x=%d, r=%d\n", l, m, x, r);
  while (l <= r) {
    while (a[l] < x) l++;
    printf ("von links: l=%d\n", l);
    while (a[r] > x) r--;
    printf ("von rechts: r=%d\n", r);

    if (l <= r) {
      int t = a[l]; a[l] = a[r]; a[r] = t;
                                    /* a[l] <-> a[r] */
      l++; r--;   /* "verschiebe Pfeile" */
      PRINT ("nach swap");
    }
  }

  printf ("l=%d m=%d x=%d, r=%d\n", l, m, x, r);
  PRINT ("nach part");

  /* Sortiere linken und rechten Teilarray */
  if (links < r)      quicksort (a, links, r);
  if (l     < rechts) quicksort (a, l,     rechts);
}


int main (int argc, char *argv[])
{
  int a[5] = {58,91,28,80,54};

  PRINT ("start");
  /*
  int l = 0, r = 1;
  int m = 2;
  int x = a[m];
  int i;

  while (l <= r) {
    while (a[l] < x) l++;
    printf ("von links: l=%d\n", l);
    while (a[r] > x) r--;
    printf ("von rechts: l=%d\n", l);
    if (l <= r) {
      int t = a[l]; a[l] = a[r]; a[r] = t;
      l++; r--;
    }
  }
  */

  quicksort (a, 0, 4);

  PRINT ("res");
  return 0;
}
