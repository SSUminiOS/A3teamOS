
user/_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 27                	jle    48 <main+0x48>
  21:	8d 5a 04             	lea    0x4(%edx),%ebx
  24:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	ff 33                	pushl  (%ebx)
  2c:	e8 99 01 00 00       	call   1ca <atoi>
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 39 02 00 00       	call   272 <kill>
  for(i=1; i<argc; i++)
  39:	83 c3 04             	add    $0x4,%ebx
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	39 f3                	cmp    %esi,%ebx
  41:	75 e4                	jne    27 <main+0x27>
  exit();
  43:	e8 fa 01 00 00       	call   242 <exit>
    printf(2, "usage: kill pid...\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 a0 06 00 00       	push   $0x6a0
  50:	6a 02                	push   $0x2
  52:	e8 2f 03 00 00       	call   386 <printf>
    exit();
  57:	e8 e6 01 00 00       	call   242 <exit>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	f3 0f 1e fb          	endbr32 
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	b8 00 00 00 00       	mov    $0x0,%eax
  6f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  73:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  76:	83 c0 01             	add    $0x1,%eax
  79:	84 d2                	test   %dl,%dl
  7b:	75 f2                	jne    6f <strcpy+0x13>
    ;
  return os;
}
  7d:	89 c8                	mov    %ecx,%eax
  7f:	5b                   	pop    %ebx
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	f3 0f 1e fb          	endbr32 
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8f:	0f b6 01             	movzbl (%ecx),%eax
  92:	84 c0                	test   %al,%al
  94:	74 11                	je     a7 <strcmp+0x25>
  96:	38 02                	cmp    %al,(%edx)
  98:	75 0d                	jne    a7 <strcmp+0x25>
    p++, q++;
  9a:	83 c1 01             	add    $0x1,%ecx
  9d:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a0:	0f b6 01             	movzbl (%ecx),%eax
  a3:	84 c0                	test   %al,%al
  a5:	75 ef                	jne    96 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	29 d0                	sub    %edx,%eax
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <strlen>:

uint
strlen(const char *s)
{
  b1:	f3 0f 1e fb          	endbr32 
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  bb:	80 3a 00             	cmpb   $0x0,(%edx)
  be:	74 14                	je     d4 <strlen+0x23>
  c0:	b8 00 00 00 00       	mov    $0x0,%eax
  c5:	83 c0 01             	add    $0x1,%eax
  c8:	89 c1                	mov    %eax,%ecx
  ca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ce:	75 f5                	jne    c5 <strlen+0x14>
    ;
  return n;
}
  d0:	89 c8                	mov    %ecx,%eax
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  for(n = 0; s[n]; n++)
  d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  d9:	eb f5                	jmp    d0 <strlen+0x1f>

000000db <memset>:

void*
memset(void *dst, int c, uint n)
{
  db:	f3 0f 1e fb          	endbr32 
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	57                   	push   %edi
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e6:	89 d7                	mov    %edx,%edi
  e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	fc                   	cld    
  ef:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f1:	89 d0                	mov    %edx,%eax
  f3:	5f                   	pop    %edi
  f4:	5d                   	pop    %ebp
  f5:	c3                   	ret    

000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	f3 0f 1e fb          	endbr32 
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 104:	0f b6 10             	movzbl (%eax),%edx
 107:	84 d2                	test   %dl,%dl
 109:	74 15                	je     120 <strchr+0x2a>
    if(*s == c)
 10b:	38 d1                	cmp    %dl,%cl
 10d:	74 0f                	je     11e <strchr+0x28>
  for(; *s; s++)
 10f:	83 c0 01             	add    $0x1,%eax
 112:	0f b6 10             	movzbl (%eax),%edx
 115:	84 d2                	test   %dl,%dl
 117:	75 f2                	jne    10b <strchr+0x15>
      return (char*)s;
  return 0;
 119:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
 125:	eb f7                	jmp    11e <strchr+0x28>

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	f3 0f 1e fb          	endbr32 
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	56                   	push   %esi
 130:	53                   	push   %ebx
 131:	83 ec 2c             	sub    $0x2c,%esp
 134:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 13c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 13f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 142:	83 c3 01             	add    $0x1,%ebx
 145:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 148:	7d 27                	jge    171 <gets+0x4a>
    cc = read(0, &c, 1);
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	6a 01                	push   $0x1
 14f:	57                   	push   %edi
 150:	6a 00                	push   $0x0
 152:	e8 03 01 00 00       	call   25a <read>
    if(cc < 1)
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	7e 13                	jle    171 <gets+0x4a>
      break;
    buf[i++] = c;
 15e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 162:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 166:	3c 0a                	cmp    $0xa,%al
 168:	74 04                	je     16e <gets+0x47>
 16a:	3c 0d                	cmp    $0xd,%al
 16c:	75 d1                	jne    13f <gets+0x18>
  for(i=0; i+1 < max; ){
 16e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 171:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 174:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 178:	89 f0                	mov    %esi,%eax
 17a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17d:	5b                   	pop    %ebx
 17e:	5e                   	pop    %esi
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <stat>:

int
stat(const char *n, struct stat *st)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	56                   	push   %esi
 18a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	6a 00                	push   $0x0
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 ea 00 00 00       	call   282 <open>
  if(fd < 0)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	78 24                	js     1c3 <stat+0x41>
 19f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	ff 75 0c             	pushl  0xc(%ebp)
 1a7:	50                   	push   %eax
 1a8:	e8 ed 00 00 00       	call   29a <fstat>
 1ad:	89 c6                	mov    %eax,%esi
  close(fd);
 1af:	89 1c 24             	mov    %ebx,(%esp)
 1b2:	e8 b3 00 00 00       	call   26a <close>
  return r;
 1b7:	83 c4 10             	add    $0x10,%esp
}
 1ba:	89 f0                	mov    %esi,%eax
 1bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
    return -1;
 1c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c8:	eb f0                	jmp    1ba <stat+0x38>

000001ca <atoi>:

int
atoi(const char *s)
{
 1ca:	f3 0f 1e fb          	endbr32 
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	53                   	push   %ebx
 1d2:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d5:	0f b6 02             	movzbl (%edx),%eax
 1d8:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1db:	80 f9 09             	cmp    $0x9,%cl
 1de:	77 22                	ja     202 <atoi+0x38>
  n = 0;
 1e0:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1e5:	83 c2 01             	add    $0x1,%edx
 1e8:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1eb:	0f be c0             	movsbl %al,%eax
 1ee:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1f2:	0f b6 02             	movzbl (%edx),%eax
 1f5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1f8:	80 fb 09             	cmp    $0x9,%bl
 1fb:	76 e8                	jbe    1e5 <atoi+0x1b>
  return n;
}
 1fd:	89 c8                	mov    %ecx,%eax
 1ff:	5b                   	pop    %ebx
 200:	5d                   	pop    %ebp
 201:	c3                   	ret    
  n = 0;
 202:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 207:	eb f4                	jmp    1fd <atoi+0x33>

00000209 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 209:	f3 0f 1e fb          	endbr32 
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	56                   	push   %esi
 211:	53                   	push   %ebx
 212:	8b 75 08             	mov    0x8(%ebp),%esi
 215:	8b 55 0c             	mov    0xc(%ebp),%edx
 218:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21b:	85 db                	test   %ebx,%ebx
 21d:	7e 15                	jle    234 <memmove+0x2b>
 21f:	01 f3                	add    %esi,%ebx
  dst = vdst;
 221:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 223:	83 c2 01             	add    $0x1,%edx
 226:	83 c0 01             	add    $0x1,%eax
 229:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 22d:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 230:	39 c3                	cmp    %eax,%ebx
 232:	75 ef                	jne    223 <memmove+0x1a>
  return vdst;
}
 234:	89 f0                	mov    %esi,%eax
 236:	5b                   	pop    %ebx
 237:	5e                   	pop    %esi
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    

0000023a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23a:	b8 01 00 00 00       	mov    $0x1,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <exit>:
SYSCALL(exit)
 242:	b8 02 00 00 00       	mov    $0x2,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <wait>:
SYSCALL(wait)
 24a:	b8 03 00 00 00       	mov    $0x3,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <pipe>:
SYSCALL(pipe)
 252:	b8 04 00 00 00       	mov    $0x4,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <read>:
SYSCALL(read)
 25a:	b8 05 00 00 00       	mov    $0x5,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <write>:
SYSCALL(write)
 262:	b8 10 00 00 00       	mov    $0x10,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <close>:
SYSCALL(close)
 26a:	b8 15 00 00 00       	mov    $0x15,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <kill>:
SYSCALL(kill)
 272:	b8 06 00 00 00       	mov    $0x6,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <exec>:
SYSCALL(exec)
 27a:	b8 07 00 00 00       	mov    $0x7,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <open>:
SYSCALL(open)
 282:	b8 0f 00 00 00       	mov    $0xf,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <mknod>:
SYSCALL(mknod)
 28a:	b8 11 00 00 00       	mov    $0x11,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <unlink>:
SYSCALL(unlink)
 292:	b8 12 00 00 00       	mov    $0x12,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <fstat>:
SYSCALL(fstat)
 29a:	b8 08 00 00 00       	mov    $0x8,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <link>:
SYSCALL(link)
 2a2:	b8 13 00 00 00       	mov    $0x13,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <mkdir>:
SYSCALL(mkdir)
 2aa:	b8 14 00 00 00       	mov    $0x14,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <chdir>:
SYSCALL(chdir)
 2b2:	b8 09 00 00 00       	mov    $0x9,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <dup>:
SYSCALL(dup)
 2ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <getpid>:
SYSCALL(getpid)
 2c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <sbrk>:
SYSCALL(sbrk)
 2ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <sleep>:
SYSCALL(sleep)
 2d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <uptime>:
SYSCALL(uptime)
 2da:	b8 0e 00 00 00       	mov    $0xe,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <slabtest>:
SYSCALL(slabtest)
 2e2:	b8 16 00 00 00       	mov    $0x16,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <ps>:
SYSCALL(ps)
 2ea:	b8 17 00 00 00       	mov    $0x17,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	57                   	push   %edi
 2f6:	56                   	push   %esi
 2f7:	53                   	push   %ebx
 2f8:	83 ec 3c             	sub    $0x3c,%esp
 2fb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2fe:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 304:	74 77                	je     37d <printint+0x8b>
 306:	85 d2                	test   %edx,%edx
 308:	79 73                	jns    37d <printint+0x8b>
    neg = 1;
    x = -xx;
 30a:	f7 db                	neg    %ebx
    neg = 1;
 30c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 313:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 318:	89 f7                	mov    %esi,%edi
 31a:	83 c6 01             	add    $0x1,%esi
 31d:	89 d8                	mov    %ebx,%eax
 31f:	ba 00 00 00 00       	mov    $0x0,%edx
 324:	f7 f1                	div    %ecx
 326:	0f b6 92 bc 06 00 00 	movzbl 0x6bc(%edx),%edx
 32d:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 331:	89 da                	mov    %ebx,%edx
 333:	89 c3                	mov    %eax,%ebx
 335:	39 d1                	cmp    %edx,%ecx
 337:	76 df                	jbe    318 <printint+0x26>
  if(neg)
 339:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 33d:	74 08                	je     347 <printint+0x55>
    buf[i++] = '-';
 33f:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 344:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 347:	85 f6                	test   %esi,%esi
 349:	7e 2a                	jle    375 <printint+0x83>
 34b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 34f:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 352:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 355:	0f b6 03             	movzbl (%ebx),%eax
 358:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 35b:	83 ec 04             	sub    $0x4,%esp
 35e:	6a 01                	push   $0x1
 360:	56                   	push   %esi
 361:	ff 75 c4             	pushl  -0x3c(%ebp)
 364:	e8 f9 fe ff ff       	call   262 <write>
  while(--i >= 0)
 369:	89 d8                	mov    %ebx,%eax
 36b:	83 eb 01             	sub    $0x1,%ebx
 36e:	83 c4 10             	add    $0x10,%esp
 371:	39 f8                	cmp    %edi,%eax
 373:	75 e0                	jne    355 <printint+0x63>
}
 375:	8d 65 f4             	lea    -0xc(%ebp),%esp
 378:	5b                   	pop    %ebx
 379:	5e                   	pop    %esi
 37a:	5f                   	pop    %edi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
  neg = 0;
 37d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 384:	eb 8d                	jmp    313 <printint+0x21>

00000386 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 386:	f3 0f 1e fb          	endbr32 
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	57                   	push   %edi
 38e:	56                   	push   %esi
 38f:	53                   	push   %ebx
 390:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 393:	8b 75 0c             	mov    0xc(%ebp),%esi
 396:	0f b6 1e             	movzbl (%esi),%ebx
 399:	84 db                	test   %bl,%bl
 39b:	0f 84 ab 01 00 00    	je     54c <printf+0x1c6>
 3a1:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3a4:	8d 45 10             	lea    0x10(%ebp),%eax
 3a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3aa:	bf 00 00 00 00       	mov    $0x0,%edi
 3af:	eb 2d                	jmp    3de <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3b1:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3b4:	83 ec 04             	sub    $0x4,%esp
 3b7:	6a 01                	push   $0x1
 3b9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3bc:	50                   	push   %eax
 3bd:	ff 75 08             	pushl  0x8(%ebp)
 3c0:	e8 9d fe ff ff       	call   262 <write>
        putc(fd, c);
 3c5:	83 c4 10             	add    $0x10,%esp
 3c8:	eb 05                	jmp    3cf <printf+0x49>
      }
    } else if(state == '%'){
 3ca:	83 ff 25             	cmp    $0x25,%edi
 3cd:	74 22                	je     3f1 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3cf:	83 c6 01             	add    $0x1,%esi
 3d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3d6:	84 db                	test   %bl,%bl
 3d8:	0f 84 6e 01 00 00    	je     54c <printf+0x1c6>
    c = fmt[i] & 0xff;
 3de:	0f be d3             	movsbl %bl,%edx
 3e1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3e4:	85 ff                	test   %edi,%edi
 3e6:	75 e2                	jne    3ca <printf+0x44>
      if(c == '%'){
 3e8:	83 f8 25             	cmp    $0x25,%eax
 3eb:	75 c4                	jne    3b1 <printf+0x2b>
        state = '%';
 3ed:	89 c7                	mov    %eax,%edi
 3ef:	eb de                	jmp    3cf <printf+0x49>
      if(c == 'd'){
 3f1:	83 f8 64             	cmp    $0x64,%eax
 3f4:	74 59                	je     44f <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3f6:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3fc:	83 fa 70             	cmp    $0x70,%edx
 3ff:	74 7a                	je     47b <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 401:	83 f8 73             	cmp    $0x73,%eax
 404:	0f 84 9d 00 00 00    	je     4a7 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 40a:	83 f8 63             	cmp    $0x63,%eax
 40d:	0f 84 ec 00 00 00    	je     4ff <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 413:	83 f8 25             	cmp    $0x25,%eax
 416:	0f 84 0f 01 00 00    	je     52b <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 41c:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	8d 45 e7             	lea    -0x19(%ebp),%eax
 428:	50                   	push   %eax
 429:	ff 75 08             	pushl  0x8(%ebp)
 42c:	e8 31 fe ff ff       	call   262 <write>
        putc(fd, c);
 431:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 434:	83 c4 0c             	add    $0xc,%esp
 437:	6a 01                	push   $0x1
 439:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43c:	50                   	push   %eax
 43d:	ff 75 08             	pushl  0x8(%ebp)
 440:	e8 1d fe ff ff       	call   262 <write>
        putc(fd, c);
 445:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 448:	bf 00 00 00 00       	mov    $0x0,%edi
 44d:	eb 80                	jmp    3cf <printf+0x49>
        printint(fd, *ap, 10, 1);
 44f:	83 ec 0c             	sub    $0xc,%esp
 452:	6a 01                	push   $0x1
 454:	b9 0a 00 00 00       	mov    $0xa,%ecx
 459:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 45c:	8b 17                	mov    (%edi),%edx
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	e8 8c fe ff ff       	call   2f2 <printint>
        ap++;
 466:	89 f8                	mov    %edi,%eax
 468:	83 c0 04             	add    $0x4,%eax
 46b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 46e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 471:	bf 00 00 00 00       	mov    $0x0,%edi
 476:	e9 54 ff ff ff       	jmp    3cf <printf+0x49>
        printint(fd, *ap, 16, 0);
 47b:	83 ec 0c             	sub    $0xc,%esp
 47e:	6a 00                	push   $0x0
 480:	b9 10 00 00 00       	mov    $0x10,%ecx
 485:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 488:	8b 17                	mov    (%edi),%edx
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	e8 60 fe ff ff       	call   2f2 <printint>
        ap++;
 492:	89 f8                	mov    %edi,%eax
 494:	83 c0 04             	add    $0x4,%eax
 497:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 49a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 49d:	bf 00 00 00 00       	mov    $0x0,%edi
 4a2:	e9 28 ff ff ff       	jmp    3cf <printf+0x49>
        s = (char*)*ap;
 4a7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4aa:	8b 01                	mov    (%ecx),%eax
        ap++;
 4ac:	83 c1 04             	add    $0x4,%ecx
 4af:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4b2:	85 c0                	test   %eax,%eax
 4b4:	74 13                	je     4c9 <printf+0x143>
        s = (char*)*ap;
 4b6:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4b8:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4bb:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4c0:	84 c0                	test   %al,%al
 4c2:	75 0f                	jne    4d3 <printf+0x14d>
 4c4:	e9 06 ff ff ff       	jmp    3cf <printf+0x49>
          s = "(null)";
 4c9:	bb b4 06 00 00       	mov    $0x6b4,%ebx
        while(*s != 0){
 4ce:	b8 28 00 00 00       	mov    $0x28,%eax
 4d3:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d9:	83 ec 04             	sub    $0x4,%esp
 4dc:	6a 01                	push   $0x1
 4de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e1:	50                   	push   %eax
 4e2:	57                   	push   %edi
 4e3:	e8 7a fd ff ff       	call   262 <write>
          s++;
 4e8:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4eb:	0f b6 03             	movzbl (%ebx),%eax
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	84 c0                	test   %al,%al
 4f3:	75 e1                	jne    4d6 <printf+0x150>
      state = 0;
 4f5:	bf 00 00 00 00       	mov    $0x0,%edi
 4fa:	e9 d0 fe ff ff       	jmp    3cf <printf+0x49>
        putc(fd, *ap);
 4ff:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 502:	8b 07                	mov    (%edi),%eax
 504:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 507:	83 ec 04             	sub    $0x4,%esp
 50a:	6a 01                	push   $0x1
 50c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 50f:	50                   	push   %eax
 510:	ff 75 08             	pushl  0x8(%ebp)
 513:	e8 4a fd ff ff       	call   262 <write>
        ap++;
 518:	83 c7 04             	add    $0x4,%edi
 51b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 51e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 521:	bf 00 00 00 00       	mov    $0x0,%edi
 526:	e9 a4 fe ff ff       	jmp    3cf <printf+0x49>
        putc(fd, c);
 52b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 52e:	83 ec 04             	sub    $0x4,%esp
 531:	6a 01                	push   $0x1
 533:	8d 45 e7             	lea    -0x19(%ebp),%eax
 536:	50                   	push   %eax
 537:	ff 75 08             	pushl  0x8(%ebp)
 53a:	e8 23 fd ff ff       	call   262 <write>
 53f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 542:	bf 00 00 00 00       	mov    $0x0,%edi
 547:	e9 83 fe ff ff       	jmp    3cf <printf+0x49>
    }
  }
}
 54c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54f:	5b                   	pop    %ebx
 550:	5e                   	pop    %esi
 551:	5f                   	pop    %edi
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    

00000554 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 554:	f3 0f 1e fb          	endbr32 
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 561:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 564:	a1 2c 09 00 00       	mov    0x92c,%eax
 569:	eb 0c                	jmp    577 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56b:	8b 10                	mov    (%eax),%edx
 56d:	39 c2                	cmp    %eax,%edx
 56f:	77 04                	ja     575 <free+0x21>
 571:	39 ca                	cmp    %ecx,%edx
 573:	77 10                	ja     585 <free+0x31>
{
 575:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 577:	39 c8                	cmp    %ecx,%eax
 579:	73 f0                	jae    56b <free+0x17>
 57b:	8b 10                	mov    (%eax),%edx
 57d:	39 ca                	cmp    %ecx,%edx
 57f:	77 04                	ja     585 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 581:	39 c2                	cmp    %eax,%edx
 583:	77 f0                	ja     575 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 585:	8b 73 fc             	mov    -0x4(%ebx),%esi
 588:	8b 10                	mov    (%eax),%edx
 58a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 58d:	39 fa                	cmp    %edi,%edx
 58f:	74 19                	je     5aa <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 591:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 594:	8b 50 04             	mov    0x4(%eax),%edx
 597:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 59a:	39 f1                	cmp    %esi,%ecx
 59c:	74 1b                	je     5b9 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 59e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a0:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 5a5:	5b                   	pop    %ebx
 5a6:	5e                   	pop    %esi
 5a7:	5f                   	pop    %edi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5aa:	03 72 04             	add    0x4(%edx),%esi
 5ad:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b0:	8b 10                	mov    (%eax),%edx
 5b2:	8b 12                	mov    (%edx),%edx
 5b4:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5b7:	eb db                	jmp    594 <free+0x40>
    p->s.size += bp->s.size;
 5b9:	03 53 fc             	add    -0x4(%ebx),%edx
 5bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5bf:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5c2:	89 10                	mov    %edx,(%eax)
 5c4:	eb da                	jmp    5a0 <free+0x4c>

000005c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5c6:	f3 0f 1e fb          	endbr32 
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	57                   	push   %edi
 5ce:	56                   	push   %esi
 5cf:	53                   	push   %ebx
 5d0:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	8d 58 07             	lea    0x7(%eax),%ebx
 5d9:	c1 eb 03             	shr    $0x3,%ebx
 5dc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5df:	8b 15 2c 09 00 00    	mov    0x92c,%edx
 5e5:	85 d2                	test   %edx,%edx
 5e7:	74 20                	je     609 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5eb:	8b 48 04             	mov    0x4(%eax),%ecx
 5ee:	39 cb                	cmp    %ecx,%ebx
 5f0:	76 3c                	jbe    62e <malloc+0x68>
 5f2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5f8:	be 00 10 00 00       	mov    $0x1000,%esi
 5fd:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 600:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 607:	eb 72                	jmp    67b <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 609:	c7 05 2c 09 00 00 30 	movl   $0x930,0x92c
 610:	09 00 00 
 613:	c7 05 30 09 00 00 30 	movl   $0x930,0x930
 61a:	09 00 00 
    base.s.size = 0;
 61d:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 624:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 627:	b8 30 09 00 00       	mov    $0x930,%eax
 62c:	eb c4                	jmp    5f2 <malloc+0x2c>
      if(p->s.size == nunits)
 62e:	39 cb                	cmp    %ecx,%ebx
 630:	74 1e                	je     650 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 632:	29 d9                	sub    %ebx,%ecx
 634:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 637:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 63a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 63d:	89 15 2c 09 00 00    	mov    %edx,0x92c
      return (void*)(p + 1);
 643:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 646:	89 d0                	mov    %edx,%eax
 648:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 650:	8b 08                	mov    (%eax),%ecx
 652:	89 0a                	mov    %ecx,(%edx)
 654:	eb e7                	jmp    63d <malloc+0x77>
  hp->s.size = nu;
 656:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 659:	83 ec 0c             	sub    $0xc,%esp
 65c:	83 c0 08             	add    $0x8,%eax
 65f:	50                   	push   %eax
 660:	e8 ef fe ff ff       	call   554 <free>
  return freep;
 665:	8b 15 2c 09 00 00    	mov    0x92c,%edx
      if((p = morecore(nunits)) == 0)
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	85 d2                	test   %edx,%edx
 670:	74 d4                	je     646 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 672:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 674:	8b 48 04             	mov    0x4(%eax),%ecx
 677:	39 d9                	cmp    %ebx,%ecx
 679:	73 b3                	jae    62e <malloc+0x68>
    if(p == freep)
 67b:	89 c2                	mov    %eax,%edx
 67d:	39 05 2c 09 00 00    	cmp    %eax,0x92c
 683:	75 ed                	jne    672 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 685:	83 ec 0c             	sub    $0xc,%esp
 688:	57                   	push   %edi
 689:	e8 3c fc ff ff       	call   2ca <sbrk>
  if(p == (char*)-1)
 68e:	83 c4 10             	add    $0x10,%esp
 691:	83 f8 ff             	cmp    $0xffffffff,%eax
 694:	75 c0                	jne    656 <malloc+0x90>
        return 0;
 696:	ba 00 00 00 00       	mov    $0x0,%edx
 69b:	eb a9                	jmp    646 <malloc+0x80>
