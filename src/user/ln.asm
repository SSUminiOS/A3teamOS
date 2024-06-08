
user/_ln:     file format elf32-i386


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
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  16:	83 39 03             	cmpl   $0x3,(%ecx)
  19:	74 14                	je     2f <main+0x2f>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 a4 06 00 00       	push   $0x6a4
  23:	6a 02                	push   $0x2
  25:	e8 60 03 00 00       	call   38a <printf>
    exit();
  2a:	e8 17 02 00 00       	call   246 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	ff 73 08             	pushl  0x8(%ebx)
  35:	ff 73 04             	pushl  0x4(%ebx)
  38:	e8 69 02 00 00       	call   2a6 <link>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	78 05                	js     49 <main+0x49>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  44:	e8 fd 01 00 00       	call   246 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  49:	ff 73 08             	pushl  0x8(%ebx)
  4c:	ff 73 04             	pushl  0x4(%ebx)
  4f:	68 b7 06 00 00       	push   $0x6b7
  54:	6a 02                	push   $0x2
  56:	e8 2f 03 00 00       	call   38a <printf>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	eb e4                	jmp    44 <main+0x44>

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	f3 0f 1e fb          	endbr32 
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	53                   	push   %ebx
  68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	b8 00 00 00 00       	mov    $0x0,%eax
  73:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  77:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  7a:	83 c0 01             	add    $0x1,%eax
  7d:	84 d2                	test   %dl,%dl
  7f:	75 f2                	jne    73 <strcpy+0x13>
    ;
  return os;
}
  81:	89 c8                	mov    %ecx,%eax
  83:	5b                   	pop    %ebx
  84:	5d                   	pop    %ebp
  85:	c3                   	ret    

00000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	f3 0f 1e fb          	endbr32 
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  90:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  93:	0f b6 01             	movzbl (%ecx),%eax
  96:	84 c0                	test   %al,%al
  98:	74 11                	je     ab <strcmp+0x25>
  9a:	38 02                	cmp    %al,(%edx)
  9c:	75 0d                	jne    ab <strcmp+0x25>
    p++, q++;
  9e:	83 c1 01             	add    $0x1,%ecx
  a1:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a4:	0f b6 01             	movzbl (%ecx),%eax
  a7:	84 c0                	test   %al,%al
  a9:	75 ef                	jne    9a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ab:	0f b6 c0             	movzbl %al,%eax
  ae:	0f b6 12             	movzbl (%edx),%edx
  b1:	29 d0                	sub    %edx,%eax
}
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strlen>:

uint
strlen(const char *s)
{
  b5:	f3 0f 1e fb          	endbr32 
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  bf:	80 3a 00             	cmpb   $0x0,(%edx)
  c2:	74 14                	je     d8 <strlen+0x23>
  c4:	b8 00 00 00 00       	mov    $0x0,%eax
  c9:	83 c0 01             	add    $0x1,%eax
  cc:	89 c1                	mov    %eax,%ecx
  ce:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d2:	75 f5                	jne    c9 <strlen+0x14>
    ;
  return n;
}
  d4:	89 c8                	mov    %ecx,%eax
  d6:	5d                   	pop    %ebp
  d7:	c3                   	ret    
  for(n = 0; s[n]; n++)
  d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  dd:	eb f5                	jmp    d4 <strlen+0x1f>

000000df <memset>:

void*
memset(void *dst, int c, uint n)
{
  df:	f3 0f 1e fb          	endbr32 
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	57                   	push   %edi
  e7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ea:	89 d7                	mov    %edx,%edi
  ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	fc                   	cld    
  f3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f5:	89 d0                	mov    %edx,%eax
  f7:	5f                   	pop    %edi
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	f3 0f 1e fb          	endbr32 
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 108:	0f b6 10             	movzbl (%eax),%edx
 10b:	84 d2                	test   %dl,%dl
 10d:	74 15                	je     124 <strchr+0x2a>
    if(*s == c)
 10f:	38 d1                	cmp    %dl,%cl
 111:	74 0f                	je     122 <strchr+0x28>
  for(; *s; s++)
 113:	83 c0 01             	add    $0x1,%eax
 116:	0f b6 10             	movzbl (%eax),%edx
 119:	84 d2                	test   %dl,%dl
 11b:	75 f2                	jne    10f <strchr+0x15>
      return (char*)s;
  return 0;
 11d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    
  return 0;
 124:	b8 00 00 00 00       	mov    $0x0,%eax
 129:	eb f7                	jmp    122 <strchr+0x28>

0000012b <gets>:

char*
gets(char *buf, int max)
{
 12b:	f3 0f 1e fb          	endbr32 
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	57                   	push   %edi
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	83 ec 2c             	sub    $0x2c,%esp
 138:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 140:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 143:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 146:	83 c3 01             	add    $0x1,%ebx
 149:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14c:	7d 27                	jge    175 <gets+0x4a>
    cc = read(0, &c, 1);
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	6a 01                	push   $0x1
 153:	57                   	push   %edi
 154:	6a 00                	push   $0x0
 156:	e8 03 01 00 00       	call   25e <read>
    if(cc < 1)
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	7e 13                	jle    175 <gets+0x4a>
      break;
    buf[i++] = c;
 162:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 166:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 16a:	3c 0a                	cmp    $0xa,%al
 16c:	74 04                	je     172 <gets+0x47>
 16e:	3c 0d                	cmp    $0xd,%al
 170:	75 d1                	jne    143 <gets+0x18>
  for(i=0; i+1 < max; ){
 172:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 175:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 178:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 17c:	89 f0                	mov    %esi,%eax
 17e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5f                   	pop    %edi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	f3 0f 1e fb          	endbr32 
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	56                   	push   %esi
 18e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18f:	83 ec 08             	sub    $0x8,%esp
 192:	6a 00                	push   $0x0
 194:	ff 75 08             	pushl  0x8(%ebp)
 197:	e8 ea 00 00 00       	call   286 <open>
  if(fd < 0)
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	85 c0                	test   %eax,%eax
 1a1:	78 24                	js     1c7 <stat+0x41>
 1a3:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	ff 75 0c             	pushl  0xc(%ebp)
 1ab:	50                   	push   %eax
 1ac:	e8 ed 00 00 00       	call   29e <fstat>
 1b1:	89 c6                	mov    %eax,%esi
  close(fd);
 1b3:	89 1c 24             	mov    %ebx,(%esp)
 1b6:	e8 b3 00 00 00       	call   26e <close>
  return r;
 1bb:	83 c4 10             	add    $0x10,%esp
}
 1be:	89 f0                	mov    %esi,%eax
 1c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c3:	5b                   	pop    %ebx
 1c4:	5e                   	pop    %esi
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
    return -1;
 1c7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cc:	eb f0                	jmp    1be <stat+0x38>

000001ce <atoi>:

int
atoi(const char *s)
{
 1ce:	f3 0f 1e fb          	endbr32 
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	53                   	push   %ebx
 1d6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d9:	0f b6 02             	movzbl (%edx),%eax
 1dc:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1df:	80 f9 09             	cmp    $0x9,%cl
 1e2:	77 22                	ja     206 <atoi+0x38>
  n = 0;
 1e4:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1e9:	83 c2 01             	add    $0x1,%edx
 1ec:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1ef:	0f be c0             	movsbl %al,%eax
 1f2:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1f6:	0f b6 02             	movzbl (%edx),%eax
 1f9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1fc:	80 fb 09             	cmp    $0x9,%bl
 1ff:	76 e8                	jbe    1e9 <atoi+0x1b>
  return n;
}
 201:	89 c8                	mov    %ecx,%eax
 203:	5b                   	pop    %ebx
 204:	5d                   	pop    %ebp
 205:	c3                   	ret    
  n = 0;
 206:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 20b:	eb f4                	jmp    201 <atoi+0x33>

0000020d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20d:	f3 0f 1e fb          	endbr32 
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	56                   	push   %esi
 215:	53                   	push   %ebx
 216:	8b 75 08             	mov    0x8(%ebp),%esi
 219:	8b 55 0c             	mov    0xc(%ebp),%edx
 21c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21f:	85 db                	test   %ebx,%ebx
 221:	7e 15                	jle    238 <memmove+0x2b>
 223:	01 f3                	add    %esi,%ebx
  dst = vdst;
 225:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 227:	83 c2 01             	add    $0x1,%edx
 22a:	83 c0 01             	add    $0x1,%eax
 22d:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 231:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 234:	39 c3                	cmp    %eax,%ebx
 236:	75 ef                	jne    227 <memmove+0x1a>
  return vdst;
}
 238:	89 f0                	mov    %esi,%eax
 23a:	5b                   	pop    %ebx
 23b:	5e                   	pop    %esi
 23c:	5d                   	pop    %ebp
 23d:	c3                   	ret    

0000023e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23e:	b8 01 00 00 00       	mov    $0x1,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <exit>:
SYSCALL(exit)
 246:	b8 02 00 00 00       	mov    $0x2,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <wait>:
SYSCALL(wait)
 24e:	b8 03 00 00 00       	mov    $0x3,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <pipe>:
SYSCALL(pipe)
 256:	b8 04 00 00 00       	mov    $0x4,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <read>:
SYSCALL(read)
 25e:	b8 05 00 00 00       	mov    $0x5,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <write>:
SYSCALL(write)
 266:	b8 10 00 00 00       	mov    $0x10,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <close>:
SYSCALL(close)
 26e:	b8 15 00 00 00       	mov    $0x15,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <kill>:
SYSCALL(kill)
 276:	b8 06 00 00 00       	mov    $0x6,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <exec>:
SYSCALL(exec)
 27e:	b8 07 00 00 00       	mov    $0x7,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <open>:
SYSCALL(open)
 286:	b8 0f 00 00 00       	mov    $0xf,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <mknod>:
SYSCALL(mknod)
 28e:	b8 11 00 00 00       	mov    $0x11,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <unlink>:
SYSCALL(unlink)
 296:	b8 12 00 00 00       	mov    $0x12,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <fstat>:
SYSCALL(fstat)
 29e:	b8 08 00 00 00       	mov    $0x8,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <link>:
SYSCALL(link)
 2a6:	b8 13 00 00 00       	mov    $0x13,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <mkdir>:
SYSCALL(mkdir)
 2ae:	b8 14 00 00 00       	mov    $0x14,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <chdir>:
SYSCALL(chdir)
 2b6:	b8 09 00 00 00       	mov    $0x9,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <dup>:
SYSCALL(dup)
 2be:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <getpid>:
SYSCALL(getpid)
 2c6:	b8 0b 00 00 00       	mov    $0xb,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <sbrk>:
SYSCALL(sbrk)
 2ce:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <sleep>:
SYSCALL(sleep)
 2d6:	b8 0d 00 00 00       	mov    $0xd,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <uptime>:
SYSCALL(uptime)
 2de:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <slabtest>:
SYSCALL(slabtest)
 2e6:	b8 16 00 00 00       	mov    $0x16,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <ps>:
SYSCALL(ps)
 2ee:	b8 17 00 00 00       	mov    $0x17,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	57                   	push   %edi
 2fa:	56                   	push   %esi
 2fb:	53                   	push   %ebx
 2fc:	83 ec 3c             	sub    $0x3c,%esp
 2ff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 302:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 308:	74 77                	je     381 <printint+0x8b>
 30a:	85 d2                	test   %edx,%edx
 30c:	79 73                	jns    381 <printint+0x8b>
    neg = 1;
    x = -xx;
 30e:	f7 db                	neg    %ebx
    neg = 1;
 310:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 317:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 31c:	89 f7                	mov    %esi,%edi
 31e:	83 c6 01             	add    $0x1,%esi
 321:	89 d8                	mov    %ebx,%eax
 323:	ba 00 00 00 00       	mov    $0x0,%edx
 328:	f7 f1                	div    %ecx
 32a:	0f b6 92 d4 06 00 00 	movzbl 0x6d4(%edx),%edx
 331:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 335:	89 da                	mov    %ebx,%edx
 337:	89 c3                	mov    %eax,%ebx
 339:	39 d1                	cmp    %edx,%ecx
 33b:	76 df                	jbe    31c <printint+0x26>
  if(neg)
 33d:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 341:	74 08                	je     34b <printint+0x55>
    buf[i++] = '-';
 343:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 348:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 34b:	85 f6                	test   %esi,%esi
 34d:	7e 2a                	jle    379 <printint+0x83>
 34f:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 353:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 356:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 359:	0f b6 03             	movzbl (%ebx),%eax
 35c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 35f:	83 ec 04             	sub    $0x4,%esp
 362:	6a 01                	push   $0x1
 364:	56                   	push   %esi
 365:	ff 75 c4             	pushl  -0x3c(%ebp)
 368:	e8 f9 fe ff ff       	call   266 <write>
  while(--i >= 0)
 36d:	89 d8                	mov    %ebx,%eax
 36f:	83 eb 01             	sub    $0x1,%ebx
 372:	83 c4 10             	add    $0x10,%esp
 375:	39 f8                	cmp    %edi,%eax
 377:	75 e0                	jne    359 <printint+0x63>
}
 379:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37c:	5b                   	pop    %ebx
 37d:	5e                   	pop    %esi
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
  neg = 0;
 381:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 388:	eb 8d                	jmp    317 <printint+0x21>

0000038a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 38a:	f3 0f 1e fb          	endbr32 
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	57                   	push   %edi
 392:	56                   	push   %esi
 393:	53                   	push   %ebx
 394:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 397:	8b 75 0c             	mov    0xc(%ebp),%esi
 39a:	0f b6 1e             	movzbl (%esi),%ebx
 39d:	84 db                	test   %bl,%bl
 39f:	0f 84 ab 01 00 00    	je     550 <printf+0x1c6>
 3a5:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3a8:	8d 45 10             	lea    0x10(%ebp),%eax
 3ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3ae:	bf 00 00 00 00       	mov    $0x0,%edi
 3b3:	eb 2d                	jmp    3e2 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3b5:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3b8:	83 ec 04             	sub    $0x4,%esp
 3bb:	6a 01                	push   $0x1
 3bd:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3c0:	50                   	push   %eax
 3c1:	ff 75 08             	pushl  0x8(%ebp)
 3c4:	e8 9d fe ff ff       	call   266 <write>
        putc(fd, c);
 3c9:	83 c4 10             	add    $0x10,%esp
 3cc:	eb 05                	jmp    3d3 <printf+0x49>
      }
    } else if(state == '%'){
 3ce:	83 ff 25             	cmp    $0x25,%edi
 3d1:	74 22                	je     3f5 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3d3:	83 c6 01             	add    $0x1,%esi
 3d6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3da:	84 db                	test   %bl,%bl
 3dc:	0f 84 6e 01 00 00    	je     550 <printf+0x1c6>
    c = fmt[i] & 0xff;
 3e2:	0f be d3             	movsbl %bl,%edx
 3e5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3e8:	85 ff                	test   %edi,%edi
 3ea:	75 e2                	jne    3ce <printf+0x44>
      if(c == '%'){
 3ec:	83 f8 25             	cmp    $0x25,%eax
 3ef:	75 c4                	jne    3b5 <printf+0x2b>
        state = '%';
 3f1:	89 c7                	mov    %eax,%edi
 3f3:	eb de                	jmp    3d3 <printf+0x49>
      if(c == 'd'){
 3f5:	83 f8 64             	cmp    $0x64,%eax
 3f8:	74 59                	je     453 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3fa:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 400:	83 fa 70             	cmp    $0x70,%edx
 403:	74 7a                	je     47f <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 405:	83 f8 73             	cmp    $0x73,%eax
 408:	0f 84 9d 00 00 00    	je     4ab <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 40e:	83 f8 63             	cmp    $0x63,%eax
 411:	0f 84 ec 00 00 00    	je     503 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 417:	83 f8 25             	cmp    $0x25,%eax
 41a:	0f 84 0f 01 00 00    	je     52f <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 420:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 424:	83 ec 04             	sub    $0x4,%esp
 427:	6a 01                	push   $0x1
 429:	8d 45 e7             	lea    -0x19(%ebp),%eax
 42c:	50                   	push   %eax
 42d:	ff 75 08             	pushl  0x8(%ebp)
 430:	e8 31 fe ff ff       	call   266 <write>
        putc(fd, c);
 435:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 438:	83 c4 0c             	add    $0xc,%esp
 43b:	6a 01                	push   $0x1
 43d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 440:	50                   	push   %eax
 441:	ff 75 08             	pushl  0x8(%ebp)
 444:	e8 1d fe ff ff       	call   266 <write>
        putc(fd, c);
 449:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 44c:	bf 00 00 00 00       	mov    $0x0,%edi
 451:	eb 80                	jmp    3d3 <printf+0x49>
        printint(fd, *ap, 10, 1);
 453:	83 ec 0c             	sub    $0xc,%esp
 456:	6a 01                	push   $0x1
 458:	b9 0a 00 00 00       	mov    $0xa,%ecx
 45d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 460:	8b 17                	mov    (%edi),%edx
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	e8 8c fe ff ff       	call   2f6 <printint>
        ap++;
 46a:	89 f8                	mov    %edi,%eax
 46c:	83 c0 04             	add    $0x4,%eax
 46f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 472:	83 c4 10             	add    $0x10,%esp
      state = 0;
 475:	bf 00 00 00 00       	mov    $0x0,%edi
 47a:	e9 54 ff ff ff       	jmp    3d3 <printf+0x49>
        printint(fd, *ap, 16, 0);
 47f:	83 ec 0c             	sub    $0xc,%esp
 482:	6a 00                	push   $0x0
 484:	b9 10 00 00 00       	mov    $0x10,%ecx
 489:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48c:	8b 17                	mov    (%edi),%edx
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	e8 60 fe ff ff       	call   2f6 <printint>
        ap++;
 496:	89 f8                	mov    %edi,%eax
 498:	83 c0 04             	add    $0x4,%eax
 49b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 49e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4a1:	bf 00 00 00 00       	mov    $0x0,%edi
 4a6:	e9 28 ff ff ff       	jmp    3d3 <printf+0x49>
        s = (char*)*ap;
 4ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4ae:	8b 01                	mov    (%ecx),%eax
        ap++;
 4b0:	83 c1 04             	add    $0x4,%ecx
 4b3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4b6:	85 c0                	test   %eax,%eax
 4b8:	74 13                	je     4cd <printf+0x143>
        s = (char*)*ap;
 4ba:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4bc:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4bf:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4c4:	84 c0                	test   %al,%al
 4c6:	75 0f                	jne    4d7 <printf+0x14d>
 4c8:	e9 06 ff ff ff       	jmp    3d3 <printf+0x49>
          s = "(null)";
 4cd:	bb cb 06 00 00       	mov    $0x6cb,%ebx
        while(*s != 0){
 4d2:	b8 28 00 00 00       	mov    $0x28,%eax
 4d7:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4da:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4dd:	83 ec 04             	sub    $0x4,%esp
 4e0:	6a 01                	push   $0x1
 4e2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e5:	50                   	push   %eax
 4e6:	57                   	push   %edi
 4e7:	e8 7a fd ff ff       	call   266 <write>
          s++;
 4ec:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4ef:	0f b6 03             	movzbl (%ebx),%eax
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	84 c0                	test   %al,%al
 4f7:	75 e1                	jne    4da <printf+0x150>
      state = 0;
 4f9:	bf 00 00 00 00       	mov    $0x0,%edi
 4fe:	e9 d0 fe ff ff       	jmp    3d3 <printf+0x49>
        putc(fd, *ap);
 503:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 506:	8b 07                	mov    (%edi),%eax
 508:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 50b:	83 ec 04             	sub    $0x4,%esp
 50e:	6a 01                	push   $0x1
 510:	8d 45 e7             	lea    -0x19(%ebp),%eax
 513:	50                   	push   %eax
 514:	ff 75 08             	pushl  0x8(%ebp)
 517:	e8 4a fd ff ff       	call   266 <write>
        ap++;
 51c:	83 c7 04             	add    $0x4,%edi
 51f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 522:	83 c4 10             	add    $0x10,%esp
      state = 0;
 525:	bf 00 00 00 00       	mov    $0x0,%edi
 52a:	e9 a4 fe ff ff       	jmp    3d3 <printf+0x49>
        putc(fd, c);
 52f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 532:	83 ec 04             	sub    $0x4,%esp
 535:	6a 01                	push   $0x1
 537:	8d 45 e7             	lea    -0x19(%ebp),%eax
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 23 fd ff ff       	call   266 <write>
 543:	83 c4 10             	add    $0x10,%esp
      state = 0;
 546:	bf 00 00 00 00       	mov    $0x0,%edi
 54b:	e9 83 fe ff ff       	jmp    3d3 <printf+0x49>
    }
  }
}
 550:	8d 65 f4             	lea    -0xc(%ebp),%esp
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    

00000558 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 558:	f3 0f 1e fb          	endbr32 
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	53                   	push   %ebx
 562:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 565:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 568:	a1 40 09 00 00       	mov    0x940,%eax
 56d:	eb 0c                	jmp    57b <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56f:	8b 10                	mov    (%eax),%edx
 571:	39 c2                	cmp    %eax,%edx
 573:	77 04                	ja     579 <free+0x21>
 575:	39 ca                	cmp    %ecx,%edx
 577:	77 10                	ja     589 <free+0x31>
{
 579:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57b:	39 c8                	cmp    %ecx,%eax
 57d:	73 f0                	jae    56f <free+0x17>
 57f:	8b 10                	mov    (%eax),%edx
 581:	39 ca                	cmp    %ecx,%edx
 583:	77 04                	ja     589 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 585:	39 c2                	cmp    %eax,%edx
 587:	77 f0                	ja     579 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 589:	8b 73 fc             	mov    -0x4(%ebx),%esi
 58c:	8b 10                	mov    (%eax),%edx
 58e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 591:	39 fa                	cmp    %edi,%edx
 593:	74 19                	je     5ae <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 595:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 598:	8b 50 04             	mov    0x4(%eax),%edx
 59b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 59e:	39 f1                	cmp    %esi,%ecx
 5a0:	74 1b                	je     5bd <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a2:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a4:	a3 40 09 00 00       	mov    %eax,0x940
}
 5a9:	5b                   	pop    %ebx
 5aa:	5e                   	pop    %esi
 5ab:	5f                   	pop    %edi
 5ac:	5d                   	pop    %ebp
 5ad:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5ae:	03 72 04             	add    0x4(%edx),%esi
 5b1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b4:	8b 10                	mov    (%eax),%edx
 5b6:	8b 12                	mov    (%edx),%edx
 5b8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5bb:	eb db                	jmp    598 <free+0x40>
    p->s.size += bp->s.size;
 5bd:	03 53 fc             	add    -0x4(%ebx),%edx
 5c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5c3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5c6:	89 10                	mov    %edx,(%eax)
 5c8:	eb da                	jmp    5a4 <free+0x4c>

000005ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5ca:	f3 0f 1e fb          	endbr32 
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	57                   	push   %edi
 5d2:	56                   	push   %esi
 5d3:	53                   	push   %ebx
 5d4:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	8d 58 07             	lea    0x7(%eax),%ebx
 5dd:	c1 eb 03             	shr    $0x3,%ebx
 5e0:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5e3:	8b 15 40 09 00 00    	mov    0x940,%edx
 5e9:	85 d2                	test   %edx,%edx
 5eb:	74 20                	je     60d <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ed:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ef:	8b 48 04             	mov    0x4(%eax),%ecx
 5f2:	39 cb                	cmp    %ecx,%ebx
 5f4:	76 3c                	jbe    632 <malloc+0x68>
 5f6:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5fc:	be 00 10 00 00       	mov    $0x1000,%esi
 601:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 604:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 60b:	eb 72                	jmp    67f <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 60d:	c7 05 40 09 00 00 44 	movl   $0x944,0x940
 614:	09 00 00 
 617:	c7 05 44 09 00 00 44 	movl   $0x944,0x944
 61e:	09 00 00 
    base.s.size = 0;
 621:	c7 05 48 09 00 00 00 	movl   $0x0,0x948
 628:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62b:	b8 44 09 00 00       	mov    $0x944,%eax
 630:	eb c4                	jmp    5f6 <malloc+0x2c>
      if(p->s.size == nunits)
 632:	39 cb                	cmp    %ecx,%ebx
 634:	74 1e                	je     654 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 636:	29 d9                	sub    %ebx,%ecx
 638:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 63b:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 63e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 641:	89 15 40 09 00 00    	mov    %edx,0x940
      return (void*)(p + 1);
 647:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 64a:	89 d0                	mov    %edx,%eax
 64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 654:	8b 08                	mov    (%eax),%ecx
 656:	89 0a                	mov    %ecx,(%edx)
 658:	eb e7                	jmp    641 <malloc+0x77>
  hp->s.size = nu;
 65a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 65d:	83 ec 0c             	sub    $0xc,%esp
 660:	83 c0 08             	add    $0x8,%eax
 663:	50                   	push   %eax
 664:	e8 ef fe ff ff       	call   558 <free>
  return freep;
 669:	8b 15 40 09 00 00    	mov    0x940,%edx
      if((p = morecore(nunits)) == 0)
 66f:	83 c4 10             	add    $0x10,%esp
 672:	85 d2                	test   %edx,%edx
 674:	74 d4                	je     64a <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 676:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 678:	8b 48 04             	mov    0x4(%eax),%ecx
 67b:	39 d9                	cmp    %ebx,%ecx
 67d:	73 b3                	jae    632 <malloc+0x68>
    if(p == freep)
 67f:	89 c2                	mov    %eax,%edx
 681:	39 05 40 09 00 00    	cmp    %eax,0x940
 687:	75 ed                	jne    676 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	57                   	push   %edi
 68d:	e8 3c fc ff ff       	call   2ce <sbrk>
  if(p == (char*)-1)
 692:	83 c4 10             	add    $0x10,%esp
 695:	83 f8 ff             	cmp    $0xffffffff,%eax
 698:	75 c0                	jne    65a <malloc+0x90>
        return 0;
 69a:	ba 00 00 00 00       	mov    $0x0,%edx
 69f:	eb a9                	jmp    64a <malloc+0x80>
