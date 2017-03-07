#include <string.h>
#include <stdlib.h>

extern char* xmalloc (unsigned);

char*
concat (s1, s2)
     char* s1;
     char* s2;
{
  int size1, size2;
  char* ret_val;

  if (!s1)
    s1 = "";
  if (!s2)
    s2 = "";

  size1 = strlen (s1);
  size2 = strlen (s2);
  ret_val = malloc (size1 + size2 + 1);
  strcpy (ret_val, s1);
  strcpy (&ret_val[size1], s2);
  return ret_val;
}
