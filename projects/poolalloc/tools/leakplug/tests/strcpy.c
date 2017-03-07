char *strcpy1(char dest[], const char source[]) {
int i = 0;
   while (1) {
      dest[i] = source[i];
      if (dest[i] == '\0') break;
      i++;
}
return dest;
}

char *mystrcpy(char *s1, const char *s2) {
  return strcpy(s1, s2);
}


