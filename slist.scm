(module slist *
  (import scheme chicken foreign)

#>

/*w: C_word, hdr: C_word*, typ: C_*_TYPE */
#define FOR_EACH_NON_IMMEDIATE_CAR_OF_TYPE(w, hdr, typ)   \
    for ((hdr) = (C_word*)(w);                            \
        ((w) & C_IMMEDIATE_MARK_BITS) == 0 &&             \
        (*(hdr) & C_HEADER_BITS_MASK) == C_PAIR_TYPE &&   \
        ((hdr)[1] & C_IMMEDIATE_MARK_BITS) == 0 &&        \
        (*(C_word*)hdr[1] & C_HEADER_BITS_MASK) == typ;   \
        (w) = (hdr)[2], (hdr) = (C_word*)(hdr)[2])

#define LOAD_NON_IMMEDIATE_CAR(pairptr) \
    (C_word*)pairptr[1];

/* NB: No type check, assumed to be done earlier */
#define LOAD_STRING_LENGTH(ptr) \
    (ptr[0] & ~(C_HEADER_BITS_MASK))

/* NB: No type check, assumed to be done earlier */
#define LOAD_STRING(ptr) \
    (char*)(&ptr[1])

/* counts the number of leading 'typ' elements of car in a cons'd list */
static int l_slistlen(C_word w, C_word typ) {
  int len = 0;
  C_word *hdr;

  FOR_EACH_NON_IMMEDIATE_CAR_OF_TYPE(w, hdr, typ) {
    C_word *str;
    str = LOAD_NON_IMMEDIATE_CAR(hdr);
    fwrite(LOAD_STRING(str), (size_t)LOAD_STRING_LENGTH(str), 1, stdout);
    putchar(' ');
    len++;
  }
  printf("\n");

  return(len);
}

<#

  (define slist-length
    (foreign-lambda* int ((scheme-object x))
      "C_return(l_slistlen(x, C_STRING_TYPE));"))
  (print (slist-length '()))
  (print (slist-length #f))
  (print (slist-length '("a" . "b")))
  (print (slist-length '("a" . #f)))
  (print (slist-length '("a" #f)))
  (print (slist-length '("a" "b")))
  (print (slist-length '("a" "b" "c")))
  (print (slist-length '("a" 2 "c"))))
