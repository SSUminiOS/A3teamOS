
user/_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 01                	mov    (%ecx),%eax
  1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1d:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	7e 41                	jle    66 <main+0x66>
  25:	8d 5f 04             	lea    0x4(%edi),%ebx
  28:	8d 74 87 fc          	lea    -0x4(%edi,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  2c:	39 f3                	cmp    %esi,%ebx
  2e:	74 1b                	je     4b <main+0x4b>
  30:	68 ac 06 00 00       	push   $0x6ac
  35:	ff 33                	pushl  (%ebx)
  37:	68 ae 06 00 00       	push   $0x6ae
  3c:	6a 01                	push   $0x1
  3e:	e8 52 03 00 00       	call   395 <printf>
  for(i = 1; i < argc; i++)
  43:	83 c3 04             	add    $0x4,%ebx
  46:	83 c4 10             	add    $0x10,%esp
  49:	eb e1                	jmp    2c <main+0x2c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  4b:	68 b3 06 00 00       	push   $0x6b3
  50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  53:	ff 74 87 fc          	pushl  -0x4(%edi,%eax,4)
  57:	68 ae 06 00 00       	push   $0x6ae
  5c:	6a 01                	push   $0x1
  5e:	e8 32 03 00 00       	call   395 <printf>
  63:	83 c4 10             	add    $0x10,%esp
  exit();
  66:	e8 e6 01 00 00       	call   251 <exit>

0000006b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  6b:	f3 0f 1e fb          	endbr32 
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	53                   	push   %ebx
  73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  79:	b8 00 00 00 00       	mov    $0x0,%eax
  7e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  82:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  85:	83 c0 01             	add    $0x1,%eax
  88:	84 d2                	test   %dl,%dl
  8a:	75 f2                	jne    7e <strcpy+0x13>
    ;
  return os;
}
  8c:	89 c8                	mov    %ecx,%eax
  8e:	5b                   	pop    %ebx
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  91:	f3 0f 1e fb          	endbr32 
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9e:	0f b6 01             	movzbl (%ecx),%eax
  a1:	84 c0                	test   %al,%al
  a3:	74 11                	je     b6 <strcmp+0x25>
  a5:	38 02                	cmp    %al,(%edx)
  a7:	75 0d                	jne    b6 <strcmp+0x25>
    p++, q++;
  a9:	83 c1 01             	add    $0x1,%ecx
  ac:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  af:	0f b6 01             	movzbl (%ecx),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 ef                	jne    a5 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  b6:	0f b6 c0             	movzbl %al,%eax
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	29 d0                	sub    %edx,%eax
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	f3 0f 1e fb          	endbr32 
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ca:	80 3a 00             	cmpb   $0x0,(%edx)
  cd:	74 14                	je     e3 <strlen+0x23>
  cf:	b8 00 00 00 00       	mov    $0x0,%eax
  d4:	83 c0 01             	add    $0x1,%eax
  d7:	89 c1                	mov    %eax,%ecx
  d9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  dd:	75 f5                	jne    d4 <strlen+0x14>
    ;
  return n;
}
  df:	89 c8                	mov    %ecx,%eax
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  e8:	eb f5                	jmp    df <strlen+0x1f>

000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f5:	89 d7                	mov    %edx,%edi
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	fc                   	cld    
  fe:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 100:	89 d0                	mov    %edx,%eax
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strchr>:

char*
strchr(const char *s, char c)
{
 105:	f3 0f 1e fb          	endbr32 
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 113:	0f b6 10             	movzbl (%eax),%edx
 116:	84 d2                	test   %dl,%dl
 118:	74 15                	je     12f <strchr+0x2a>
    if(*s == c)
 11a:	38 d1                	cmp    %dl,%cl
 11c:	74 0f                	je     12d <strchr+0x28>
  for(; *s; s++)
 11e:	83 c0 01             	add    $0x1,%eax
 121:	0f b6 10             	movzbl (%eax),%edx
 124:	84 d2                	test   %dl,%dl
 126:	75 f2                	jne    11a <strchr+0x15>
      return (char*)s;
  return 0;
 128:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
  return 0;
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb f7                	jmp    12d <strchr+0x28>

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	f3 0f 1e fb          	endbr32 
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	57                   	push   %edi
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
 140:	83 ec 2c             	sub    $0x2c,%esp
 143:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 14b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 14e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 151:	83 c3 01             	add    $0x1,%ebx
 154:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 157:	7d 27                	jge    180 <gets+0x4a>
    cc = read(0, &c, 1);
 159:	83 ec 04             	sub    $0x4,%esp
 15c:	6a 01                	push   $0x1
 15e:	57                   	push   %edi
 15f:	6a 00                	push   $0x0
 161:	e8 03 01 00 00       	call   269 <read>
    if(cc < 1)
 166:	83 c4 10             	add    $0x10,%esp
 169:	85 c0                	test   %eax,%eax
 16b:	7e 13                	jle    180 <gets+0x4a>
      break;
    buf[i++] = c;
 16d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 171:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 175:	3c 0a                	cmp    $0xa,%al
 177:	74 04                	je     17d <gets+0x47>
 179:	3c 0d                	cmp    $0xd,%al
 17b:	75 d1                	jne    14e <gets+0x18>
  for(i=0; i+1 < max; ){
 17d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 180:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 183:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 187:	89 f0                	mov    %esi,%eax
 189:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5f                   	pop    %edi
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    

00000191 <stat>:

int
stat(const char *n, struct stat *st)
{
 191:	f3 0f 1e fb          	endbr32 
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	83 ec 08             	sub    $0x8,%esp
 19d:	6a 00                	push   $0x0
 19f:	ff 75 08             	pushl  0x8(%ebp)
 1a2:	e8 ea 00 00 00       	call   291 <open>
  if(fd < 0)
 1a7:	83 c4 10             	add    $0x10,%esp
 1aa:	85 c0                	test   %eax,%eax
 1ac:	78 24                	js     1d2 <stat+0x41>
 1ae:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	ff 75 0c             	pushl  0xc(%ebp)
 1b6:	50                   	push   %eax
 1b7:	e8 ed 00 00 00       	call   2a9 <fstat>
 1bc:	89 c6                	mov    %eax,%esi
  close(fd);
 1be:	89 1c 24             	mov    %ebx,(%esp)
 1c1:	e8 b3 00 00 00       	call   279 <close>
  return r;
 1c6:	83 c4 10             	add    $0x10,%esp
}
 1c9:	89 f0                	mov    %esi,%eax
 1cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ce:	5b                   	pop    %ebx
 1cf:	5e                   	pop    %esi
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    
    return -1;
 1d2:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d7:	eb f0                	jmp    1c9 <stat+0x38>

000001d9 <atoi>:

int
atoi(const char *s)
{
 1d9:	f3 0f 1e fb          	endbr32 
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	53                   	push   %ebx
 1e1:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e4:	0f b6 02             	movzbl (%edx),%eax
 1e7:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1ea:	80 f9 09             	cmp    $0x9,%cl
 1ed:	77 22                	ja     211 <atoi+0x38>
  n = 0;
 1ef:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1f4:	83 c2 01             	add    $0x1,%edx
 1f7:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1fa:	0f be c0             	movsbl %al,%eax
 1fd:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 201:	0f b6 02             	movzbl (%edx),%eax
 204:	8d 58 d0             	lea    -0x30(%eax),%ebx
 207:	80 fb 09             	cmp    $0x9,%bl
 20a:	76 e8                	jbe    1f4 <atoi+0x1b>
  return n;
}
 20c:	89 c8                	mov    %ecx,%eax
 20e:	5b                   	pop    %ebx
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
  n = 0;
 211:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 216:	eb f4                	jmp    20c <atoi+0x33>

00000218 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 218:	f3 0f 1e fb          	endbr32 
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	56                   	push   %esi
 220:	53                   	push   %ebx
 221:	8b 75 08             	mov    0x8(%ebp),%esi
 224:	8b 55 0c             	mov    0xc(%ebp),%edx
 227:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22a:	85 db                	test   %ebx,%ebx
 22c:	7e 15                	jle    243 <memmove+0x2b>
 22e:	01 f3                	add    %esi,%ebx
  dst = vdst;
 230:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 232:	83 c2 01             	add    $0x1,%edx
 235:	83 c0 01             	add    $0x1,%eax
 238:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 23c:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 23f:	39 c3                	cmp    %eax,%ebx
 241:	75 ef                	jne    232 <memmove+0x1a>
  return vdst;
}
 243:	89 f0                	mov    %esi,%eax
 245:	5b                   	pop    %ebx
 246:	5e                   	pop    %esi
 247:	5d                   	pop    %ebp
 248:	c3                   	ret    

00000249 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 249:	b8 01 00 00 00       	mov    $0x1,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <exit>:
SYSCALL(exit)
 251:	b8 02 00 00 00       	mov    $0x2,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <wait>:
SYSCALL(wait)
 259:	b8 03 00 00 00       	mov    $0x3,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <pipe>:
SYSCALL(pipe)
 261:	b8 04 00 00 00       	mov    $0x4,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <read>:
SYSCALL(read)
 269:	b8 05 00 00 00       	mov    $0x5,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <write>:
SYSCALL(write)
 271:	b8 10 00 00 00       	mov    $0x10,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <close>:
SYSCALL(close)
 279:	b8 15 00 00 00       	mov    $0x15,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <kill>:
SYSCALL(kill)
 281:	b8 06 00 00 00       	mov    $0x6,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <exec>:
SYSCALL(exec)
 289:	b8 07 00 00 00       	mov    $0x7,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <open>:
SYSCALL(open)
 291:	b8 0f 00 00 00       	mov    $0xf,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <mknod>:
SYSCALL(mknod)
 299:	b8 11 00 00 00       	mov    $0x11,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <unlink>:
SYSCALL(unlink)
 2a1:	b8 12 00 00 00       	mov    $0x12,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <fstat>:
SYSCALL(fstat)
 2a9:	b8 08 00 00 00       	mov    $0x8,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <link>:
SYSCALL(link)
 2b1:	b8 13 00 00 00       	mov    $0x13,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <mkdir>:
SYSCALL(mkdir)
 2b9:	b8 14 00 00 00       	mov    $0x14,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <chdir>:
SYSCALL(chdir)
 2c1:	b8 09 00 00 00       	mov    $0x9,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <dup>:
SYSCALL(dup)
 2c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <getpid>:
SYSCALL(getpid)
 2d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <sbrk>:
SYSCALL(sbrk)
 2d9:	b8 0c 00 00 00       	mov    $0xc,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <sleep>:
SYSCALL(sleep)
 2e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <uptime>:
SYSCALL(uptime)
 2e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <slabtest>:
SYSCALL(slabtest)
 2f1:	b8 16 00 00 00       	mov    $0x16,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <ps>:
SYSCALL(ps)
 2f9:	b8 17 00 00 00       	mov    $0x17,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	57                   	push   %edi
 305:	56                   	push   %esi
 306:	53                   	push   %ebx
 307:	83 ec 3c             	sub    $0x3c,%esp
 30a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 30d:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 313:	74 77                	je     38c <printint+0x8b>
 315:	85 d2                	test   %edx,%edx
 317:	79 73                	jns    38c <printint+0x8b>
    neg = 1;
    x = -xx;
 319:	f7 db                	neg    %ebx
    neg = 1;
 31b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 322:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 327:	89 f7                	mov    %esi,%edi
 329:	83 c6 01             	add    $0x1,%esi
 32c:	89 d8                	mov    %ebx,%eax
 32e:	ba 00 00 00 00       	mov    $0x0,%edx
 333:	f7 f1                	div    %ecx
 335:	0f b6 92 bc 06 00 00 	movzbl 0x6bc(%edx),%edx
 33c:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 340:	89 da                	mov    %ebx,%edx
 342:	89 c3                	mov    %eax,%ebx
 344:	39 d1                	cmp    %edx,%ecx
 346:	76 df                	jbe    327 <printint+0x26>
  if(neg)
 348:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 34c:	74 08                	je     356 <printint+0x55>
    buf[i++] = '-';
 34e:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 353:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 356:	85 f6                	test   %esi,%esi
 358:	7e 2a                	jle    384 <printint+0x83>
 35a:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 35e:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 361:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 364:	0f b6 03             	movzbl (%ebx),%eax
 367:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 36a:	83 ec 04             	sub    $0x4,%esp
 36d:	6a 01                	push   $0x1
 36f:	56                   	push   %esi
 370:	ff 75 c4             	pushl  -0x3c(%ebp)
 373:	e8 f9 fe ff ff       	call   271 <write>
  while(--i >= 0)
 378:	89 d8                	mov    %ebx,%eax
 37a:	83 eb 01             	sub    $0x1,%ebx
 37d:	83 c4 10             	add    $0x10,%esp
 380:	39 f8                	cmp    %edi,%eax
 382:	75 e0                	jne    364 <printint+0x63>
}
 384:	8d 65 f4             	lea    -0xc(%ebp),%esp
 387:	5b                   	pop    %ebx
 388:	5e                   	pop    %esi
 389:	5f                   	pop    %edi
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    
  neg = 0;
 38c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 393:	eb 8d                	jmp    322 <printint+0x21>

00000395 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 395:	f3 0f 1e fb          	endbr32 
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	57                   	push   %edi
 39d:	56                   	push   %esi
 39e:	53                   	push   %ebx
 39f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3a2:	8b 75 0c             	mov    0xc(%ebp),%esi
 3a5:	0f b6 1e             	movzbl (%esi),%ebx
 3a8:	84 db                	test   %bl,%bl
 3aa:	0f 84 ab 01 00 00    	je     55b <printf+0x1c6>
 3b0:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3b3:	8d 45 10             	lea    0x10(%ebp),%eax
 3b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3b9:	bf 00 00 00 00       	mov    $0x0,%edi
 3be:	eb 2d                	jmp    3ed <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3c3:	83 ec 04             	sub    $0x4,%esp
 3c6:	6a 01                	push   $0x1
 3c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3cb:	50                   	push   %eax
 3cc:	ff 75 08             	pushl  0x8(%ebp)
 3cf:	e8 9d fe ff ff       	call   271 <write>
        putc(fd, c);
 3d4:	83 c4 10             	add    $0x10,%esp
 3d7:	eb 05                	jmp    3de <printf+0x49>
      }
    } else if(state == '%'){
 3d9:	83 ff 25             	cmp    $0x25,%edi
 3dc:	74 22                	je     400 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3de:	83 c6 01             	add    $0x1,%esi
 3e1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3e5:	84 db                	test   %bl,%bl
 3e7:	0f 84 6e 01 00 00    	je     55b <printf+0x1c6>
    c = fmt[i] & 0xff;
 3ed:	0f be d3             	movsbl %bl,%edx
 3f0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3f3:	85 ff                	test   %edi,%edi
 3f5:	75 e2                	jne    3d9 <printf+0x44>
      if(c == '%'){
 3f7:	83 f8 25             	cmp    $0x25,%eax
 3fa:	75 c4                	jne    3c0 <printf+0x2b>
        state = '%';
 3fc:	89 c7                	mov    %eax,%edi
 3fe:	eb de                	jmp    3de <printf+0x49>
      if(c == 'd'){
 400:	83 f8 64             	cmp    $0x64,%eax
 403:	74 59                	je     45e <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 405:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 40b:	83 fa 70             	cmp    $0x70,%edx
 40e:	74 7a                	je     48a <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 410:	83 f8 73             	cmp    $0x73,%eax
 413:	0f 84 9d 00 00 00    	je     4b6 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 419:	83 f8 63             	cmp    $0x63,%eax
 41c:	0f 84 ec 00 00 00    	je     50e <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 422:	83 f8 25             	cmp    $0x25,%eax
 425:	0f 84 0f 01 00 00    	je     53a <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 42b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 42f:	83 ec 04             	sub    $0x4,%esp
 432:	6a 01                	push   $0x1
 434:	8d 45 e7             	lea    -0x19(%ebp),%eax
 437:	50                   	push   %eax
 438:	ff 75 08             	pushl  0x8(%ebp)
 43b:	e8 31 fe ff ff       	call   271 <write>
        putc(fd, c);
 440:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 443:	83 c4 0c             	add    $0xc,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 e7             	lea    -0x19(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	ff 75 08             	pushl  0x8(%ebp)
 44f:	e8 1d fe ff ff       	call   271 <write>
        putc(fd, c);
 454:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 457:	bf 00 00 00 00       	mov    $0x0,%edi
 45c:	eb 80                	jmp    3de <printf+0x49>
        printint(fd, *ap, 10, 1);
 45e:	83 ec 0c             	sub    $0xc,%esp
 461:	6a 01                	push   $0x1
 463:	b9 0a 00 00 00       	mov    $0xa,%ecx
 468:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 46b:	8b 17                	mov    (%edi),%edx
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	e8 8c fe ff ff       	call   301 <printint>
        ap++;
 475:	89 f8                	mov    %edi,%eax
 477:	83 c0 04             	add    $0x4,%eax
 47a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 47d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 480:	bf 00 00 00 00       	mov    $0x0,%edi
 485:	e9 54 ff ff ff       	jmp    3de <printf+0x49>
        printint(fd, *ap, 16, 0);
 48a:	83 ec 0c             	sub    $0xc,%esp
 48d:	6a 00                	push   $0x0
 48f:	b9 10 00 00 00       	mov    $0x10,%ecx
 494:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 497:	8b 17                	mov    (%edi),%edx
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	e8 60 fe ff ff       	call   301 <printint>
        ap++;
 4a1:	89 f8                	mov    %edi,%eax
 4a3:	83 c0 04             	add    $0x4,%eax
 4a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ac:	bf 00 00 00 00       	mov    $0x0,%edi
 4b1:	e9 28 ff ff ff       	jmp    3de <printf+0x49>
        s = (char*)*ap;
 4b6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4b9:	8b 01                	mov    (%ecx),%eax
        ap++;
 4bb:	83 c1 04             	add    $0x4,%ecx
 4be:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4c1:	85 c0                	test   %eax,%eax
 4c3:	74 13                	je     4d8 <printf+0x143>
        s = (char*)*ap;
 4c5:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4c7:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4ca:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4cf:	84 c0                	test   %al,%al
 4d1:	75 0f                	jne    4e2 <printf+0x14d>
 4d3:	e9 06 ff ff ff       	jmp    3de <printf+0x49>
          s = "(null)";
 4d8:	bb b5 06 00 00       	mov    $0x6b5,%ebx
        while(*s != 0){
 4dd:	b8 28 00 00 00       	mov    $0x28,%eax
 4e2:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4e5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e8:	83 ec 04             	sub    $0x4,%esp
 4eb:	6a 01                	push   $0x1
 4ed:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f0:	50                   	push   %eax
 4f1:	57                   	push   %edi
 4f2:	e8 7a fd ff ff       	call   271 <write>
          s++;
 4f7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4fa:	0f b6 03             	movzbl (%ebx),%eax
 4fd:	83 c4 10             	add    $0x10,%esp
 500:	84 c0                	test   %al,%al
 502:	75 e1                	jne    4e5 <printf+0x150>
      state = 0;
 504:	bf 00 00 00 00       	mov    $0x0,%edi
 509:	e9 d0 fe ff ff       	jmp    3de <printf+0x49>
        putc(fd, *ap);
 50e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 511:	8b 07                	mov    (%edi),%eax
 513:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 516:	83 ec 04             	sub    $0x4,%esp
 519:	6a 01                	push   $0x1
 51b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 51e:	50                   	push   %eax
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 4a fd ff ff       	call   271 <write>
        ap++;
 527:	83 c7 04             	add    $0x4,%edi
 52a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 52d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 530:	bf 00 00 00 00       	mov    $0x0,%edi
 535:	e9 a4 fe ff ff       	jmp    3de <printf+0x49>
        putc(fd, c);
 53a:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 53d:	83 ec 04             	sub    $0x4,%esp
 540:	6a 01                	push   $0x1
 542:	8d 45 e7             	lea    -0x19(%ebp),%eax
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 23 fd ff ff       	call   271 <write>
 54e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 551:	bf 00 00 00 00       	mov    $0x0,%edi
 556:	e9 83 fe ff ff       	jmp    3de <printf+0x49>
    }
  }
}
 55b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55e:	5b                   	pop    %ebx
 55f:	5e                   	pop    %esi
 560:	5f                   	pop    %edi
 561:	5d                   	pop    %ebp
 562:	c3                   	ret    

00000563 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 563:	f3 0f 1e fb          	endbr32 
 567:	55                   	push   %ebp
 568:	89 e5                	mov    %esp,%ebp
 56a:	57                   	push   %edi
 56b:	56                   	push   %esi
 56c:	53                   	push   %ebx
 56d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 570:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 573:	a1 30 09 00 00       	mov    0x930,%eax
 578:	eb 0c                	jmp    586 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57a:	8b 10                	mov    (%eax),%edx
 57c:	39 c2                	cmp    %eax,%edx
 57e:	77 04                	ja     584 <free+0x21>
 580:	39 ca                	cmp    %ecx,%edx
 582:	77 10                	ja     594 <free+0x31>
{
 584:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 586:	39 c8                	cmp    %ecx,%eax
 588:	73 f0                	jae    57a <free+0x17>
 58a:	8b 10                	mov    (%eax),%edx
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	77 04                	ja     594 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 c2                	cmp    %eax,%edx
 592:	77 f0                	ja     584 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 594:	8b 73 fc             	mov    -0x4(%ebx),%esi
 597:	8b 10                	mov    (%eax),%edx
 599:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59c:	39 fa                	cmp    %edi,%edx
 59e:	74 19                	je     5b9 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a3:	8b 50 04             	mov    0x4(%eax),%edx
 5a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a9:	39 f1                	cmp    %esi,%ecx
 5ab:	74 1b                	je     5c8 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ad:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5af:	a3 30 09 00 00       	mov    %eax,0x930
}
 5b4:	5b                   	pop    %ebx
 5b5:	5e                   	pop    %esi
 5b6:	5f                   	pop    %edi
 5b7:	5d                   	pop    %ebp
 5b8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b9:	03 72 04             	add    0x4(%edx),%esi
 5bc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5bf:	8b 10                	mov    (%eax),%edx
 5c1:	8b 12                	mov    (%edx),%edx
 5c3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c6:	eb db                	jmp    5a3 <free+0x40>
    p->s.size += bp->s.size;
 5c8:	03 53 fc             	add    -0x4(%ebx),%edx
 5cb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ce:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d1:	89 10                	mov    %edx,(%eax)
 5d3:	eb da                	jmp    5af <free+0x4c>

000005d5 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d5:	f3 0f 1e fb          	endbr32 
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
 5dc:	57                   	push   %edi
 5dd:	56                   	push   %esi
 5de:	53                   	push   %ebx
 5df:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	8d 58 07             	lea    0x7(%eax),%ebx
 5e8:	c1 eb 03             	shr    $0x3,%ebx
 5eb:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ee:	8b 15 30 09 00 00    	mov    0x930,%edx
 5f4:	85 d2                	test   %edx,%edx
 5f6:	74 20                	je     618 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5fa:	8b 48 04             	mov    0x4(%eax),%ecx
 5fd:	39 cb                	cmp    %ecx,%ebx
 5ff:	76 3c                	jbe    63d <malloc+0x68>
 601:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 607:	be 00 10 00 00       	mov    $0x1000,%esi
 60c:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 60f:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 616:	eb 72                	jmp    68a <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 618:	c7 05 30 09 00 00 34 	movl   $0x934,0x930
 61f:	09 00 00 
 622:	c7 05 34 09 00 00 34 	movl   $0x934,0x934
 629:	09 00 00 
    base.s.size = 0;
 62c:	c7 05 38 09 00 00 00 	movl   $0x0,0x938
 633:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 636:	b8 34 09 00 00       	mov    $0x934,%eax
 63b:	eb c4                	jmp    601 <malloc+0x2c>
      if(p->s.size == nunits)
 63d:	39 cb                	cmp    %ecx,%ebx
 63f:	74 1e                	je     65f <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 641:	29 d9                	sub    %ebx,%ecx
 643:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 646:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 649:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 64c:	89 15 30 09 00 00    	mov    %edx,0x930
      return (void*)(p + 1);
 652:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 655:	89 d0                	mov    %edx,%eax
 657:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65a:	5b                   	pop    %ebx
 65b:	5e                   	pop    %esi
 65c:	5f                   	pop    %edi
 65d:	5d                   	pop    %ebp
 65e:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 65f:	8b 08                	mov    (%eax),%ecx
 661:	89 0a                	mov    %ecx,(%edx)
 663:	eb e7                	jmp    64c <malloc+0x77>
  hp->s.size = nu;
 665:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 668:	83 ec 0c             	sub    $0xc,%esp
 66b:	83 c0 08             	add    $0x8,%eax
 66e:	50                   	push   %eax
 66f:	e8 ef fe ff ff       	call   563 <free>
  return freep;
 674:	8b 15 30 09 00 00    	mov    0x930,%edx
      if((p = morecore(nunits)) == 0)
 67a:	83 c4 10             	add    $0x10,%esp
 67d:	85 d2                	test   %edx,%edx
 67f:	74 d4                	je     655 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 681:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 683:	8b 48 04             	mov    0x4(%eax),%ecx
 686:	39 d9                	cmp    %ebx,%ecx
 688:	73 b3                	jae    63d <malloc+0x68>
    if(p == freep)
 68a:	89 c2                	mov    %eax,%edx
 68c:	39 05 30 09 00 00    	cmp    %eax,0x930
 692:	75 ed                	jne    681 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 694:	83 ec 0c             	sub    $0xc,%esp
 697:	57                   	push   %edi
 698:	e8 3c fc ff ff       	call   2d9 <sbrk>
  if(p == (char*)-1)
 69d:	83 c4 10             	add    $0x10,%esp
 6a0:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a3:	75 c0                	jne    665 <malloc+0x90>
        return 0;
 6a5:	ba 00 00 00 00       	mov    $0x0,%edx
 6aa:	eb a9                	jmp    655 <malloc+0x80>
