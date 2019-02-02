#if defined(__CYGWIN__) || defined(_WIN32)

unsigned int __stdcall
fill_my_string(unsigned int size, char *buffer)
{
  static const char *my_string = "The quick brown fox jumps over the lazy dog.";
  int i;

  while(i < size-1 && my_string[i] != '\0')
  {
    buffer[i] = my_string[i];
    i++;
  }

  buffer[i] = '\0';

  return i+1;
}


#endif
