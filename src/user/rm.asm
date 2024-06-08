
user/_rm:     file format elf32-i386


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
  18:	8b 39                	mov    (%ecx),%edi
  1a:	8b 59 04             	mov    0x4(%ecx),%ebx
  int i;

  if(argc < 2){
  1d:	83 c3 04             	add    $0x4,%ebx
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  20:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
  25:	83 ff 01             	cmp    $0x1,%edi
  28:	7e 20                	jle    4a <main+0x4a>
    if(unlink(argv[i]) < 0){
  2a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  2d:	83 ec 0c             	sub    $0xc,%esp
  30:	ff 33                	pushl  (%ebx)
  32:	e8 79 02 00 00       	call   2b0 <unlink>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 20                	js     5e <main+0x5e>
  for(i = 1; i < argc; i++){
  3e:	83 c6 01             	add    $0x1,%esi
  41:	83 c3 04             	add    $0x4,%ebx
  44:	39 f7                	cmp    %esi,%edi
  46:	75 e2                	jne    2a <main+0x2a>
  48:	eb 2b                	jmp    75 <main+0x75>
    printf(2, "Usage: rm files...\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 bc 06 00 00       	push   $0x6bc
  52:	6a 02                	push   $0x2
  54:	e8 4b 03 00 00       	call   3a4 <printf>
    exit();
  59:	e8 02 02 00 00       	call   260 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5e:	83 ec 04             	sub    $0x4,%esp
  61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  64:	ff 30                	pushl  (%eax)
  66:	68 d0 06 00 00       	push   $0x6d0
  6b:	6a 02                	push   $0x2
  6d:	e8 32 03 00 00       	call   3a4 <printf>
      break;
  72:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  75:	e8 e6 01 00 00       	call   260 <exit>

0000007a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  7a:	f3 0f 1e fb          	endbr32 
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	53                   	push   %ebx
  82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	b8 00 00 00 00       	mov    $0x0,%eax
  8d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  91:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  94:	83 c0 01             	add    $0x1,%eax
  97:	84 d2                	test   %dl,%dl
  99:	75 f2                	jne    8d <strcpy+0x13>
    ;
  return os;
}
  9b:	89 c8                	mov    %ecx,%eax
  9d:	5b                   	pop    %ebx
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	f3 0f 1e fb          	endbr32 
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ad:	0f b6 01             	movzbl (%ecx),%eax
  b0:	84 c0                	test   %al,%al
  b2:	74 11                	je     c5 <strcmp+0x25>
  b4:	38 02                	cmp    %al,(%edx)
  b6:	75 0d                	jne    c5 <strcmp+0x25>
    p++, q++;
  b8:	83 c1 01             	add    $0x1,%ecx
  bb:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  be:	0f b6 01             	movzbl (%ecx),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 ef                	jne    b4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c5:	0f b6 c0             	movzbl %al,%eax
  c8:	0f b6 12             	movzbl (%edx),%edx
  cb:	29 d0                	sub    %edx,%eax
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <strlen>:

uint
strlen(const char *s)
{
  cf:	f3 0f 1e fb          	endbr32 
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  d9:	80 3a 00             	cmpb   $0x0,(%edx)
  dc:	74 14                	je     f2 <strlen+0x23>
  de:	b8 00 00 00 00       	mov    $0x0,%eax
  e3:	83 c0 01             	add    $0x1,%eax
  e6:	89 c1                	mov    %eax,%ecx
  e8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ec:	75 f5                	jne    e3 <strlen+0x14>
    ;
  return n;
}
  ee:	89 c8                	mov    %ecx,%eax
  f0:	5d                   	pop    %ebp
  f1:	c3                   	ret    
  for(n = 0; s[n]; n++)
  f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  f7:	eb f5                	jmp    ee <strlen+0x1f>

000000f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f9:	f3 0f 1e fb          	endbr32 
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	57                   	push   %edi
 101:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 104:	89 d7                	mov    %edx,%edi
 106:	8b 4d 10             	mov    0x10(%ebp),%ecx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	fc                   	cld    
 10d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 10f:	89 d0                	mov    %edx,%eax
 111:	5f                   	pop    %edi
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	f3 0f 1e fb          	endbr32 
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 122:	0f b6 10             	movzbl (%eax),%edx
 125:	84 d2                	test   %dl,%dl
 127:	74 15                	je     13e <strchr+0x2a>
    if(*s == c)
 129:	38 d1                	cmp    %dl,%cl
 12b:	74 0f                	je     13c <strchr+0x28>
  for(; *s; s++)
 12d:	83 c0 01             	add    $0x1,%eax
 130:	0f b6 10             	movzbl (%eax),%edx
 133:	84 d2                	test   %dl,%dl
 135:	75 f2                	jne    129 <strchr+0x15>
      return (char*)s;
  return 0;
 137:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    
  return 0;
 13e:	b8 00 00 00 00       	mov    $0x0,%eax
 143:	eb f7                	jmp    13c <strchr+0x28>

00000145 <gets>:

char*
gets(char *buf, int max)
{
 145:	f3 0f 1e fb          	endbr32 
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	57                   	push   %edi
 14d:	56                   	push   %esi
 14e:	53                   	push   %ebx
 14f:	83 ec 2c             	sub    $0x2c,%esp
 152:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 155:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 15a:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 15d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 160:	83 c3 01             	add    $0x1,%ebx
 163:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 166:	7d 27                	jge    18f <gets+0x4a>
    cc = read(0, &c, 1);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	6a 01                	push   $0x1
 16d:	57                   	push   %edi
 16e:	6a 00                	push   $0x0
 170:	e8 03 01 00 00       	call   278 <read>
    if(cc < 1)
 175:	83 c4 10             	add    $0x10,%esp
 178:	85 c0                	test   %eax,%eax
 17a:	7e 13                	jle    18f <gets+0x4a>
      break;
    buf[i++] = c;
 17c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 180:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 04                	je     18c <gets+0x47>
 188:	3c 0d                	cmp    $0xd,%al
 18a:	75 d1                	jne    15d <gets+0x18>
  for(i=0; i+1 < max; ){
 18c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 18f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 192:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 196:	89 f0                	mov    %esi,%eax
 198:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19b:	5b                   	pop    %ebx
 19c:	5e                   	pop    %esi
 19d:	5f                   	pop    %edi
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret    

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	56                   	push   %esi
 1a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	6a 00                	push   $0x0
 1ae:	ff 75 08             	pushl  0x8(%ebp)
 1b1:	e8 ea 00 00 00       	call   2a0 <open>
  if(fd < 0)
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	85 c0                	test   %eax,%eax
 1bb:	78 24                	js     1e1 <stat+0x41>
 1bd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	ff 75 0c             	pushl  0xc(%ebp)
 1c5:	50                   	push   %eax
 1c6:	e8 ed 00 00 00       	call   2b8 <fstat>
 1cb:	89 c6                	mov    %eax,%esi
  close(fd);
 1cd:	89 1c 24             	mov    %ebx,(%esp)
 1d0:	e8 b3 00 00 00       	call   288 <close>
  return r;
 1d5:	83 c4 10             	add    $0x10,%esp
}
 1d8:	89 f0                	mov    %esi,%eax
 1da:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1dd:	5b                   	pop    %ebx
 1de:	5e                   	pop    %esi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
    return -1;
 1e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e6:	eb f0                	jmp    1d8 <stat+0x38>

000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	f3 0f 1e fb          	endbr32 
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	53                   	push   %ebx
 1f0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f3:	0f b6 02             	movzbl (%edx),%eax
 1f6:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1f9:	80 f9 09             	cmp    $0x9,%cl
 1fc:	77 22                	ja     220 <atoi+0x38>
  n = 0;
 1fe:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 203:	83 c2 01             	add    $0x1,%edx
 206:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 209:	0f be c0             	movsbl %al,%eax
 20c:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 210:	0f b6 02             	movzbl (%edx),%eax
 213:	8d 58 d0             	lea    -0x30(%eax),%ebx
 216:	80 fb 09             	cmp    $0x9,%bl
 219:	76 e8                	jbe    203 <atoi+0x1b>
  return n;
}
 21b:	89 c8                	mov    %ecx,%eax
 21d:	5b                   	pop    %ebx
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  n = 0;
 220:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 225:	eb f4                	jmp    21b <atoi+0x33>

00000227 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 227:	f3 0f 1e fb          	endbr32 
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	56                   	push   %esi
 22f:	53                   	push   %ebx
 230:	8b 75 08             	mov    0x8(%ebp),%esi
 233:	8b 55 0c             	mov    0xc(%ebp),%edx
 236:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 239:	85 db                	test   %ebx,%ebx
 23b:	7e 15                	jle    252 <memmove+0x2b>
 23d:	01 f3                	add    %esi,%ebx
  dst = vdst;
 23f:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 241:	83 c2 01             	add    $0x1,%edx
 244:	83 c0 01             	add    $0x1,%eax
 247:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 24b:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 24e:	39 c3                	cmp    %eax,%ebx
 250:	75 ef                	jne    241 <memmove+0x1a>
  return vdst;
}
 252:	89 f0                	mov    %esi,%eax
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    

00000258 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <exit>:
SYSCALL(exit)
 260:	b8 02 00 00 00       	mov    $0x2,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <wait>:
SYSCALL(wait)
 268:	b8 03 00 00 00       	mov    $0x3,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <pipe>:
SYSCALL(pipe)
 270:	b8 04 00 00 00       	mov    $0x4,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <read>:
SYSCALL(read)
 278:	b8 05 00 00 00       	mov    $0x5,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <write>:
SYSCALL(write)
 280:	b8 10 00 00 00       	mov    $0x10,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <close>:
SYSCALL(close)
 288:	b8 15 00 00 00       	mov    $0x15,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <kill>:
SYSCALL(kill)
 290:	b8 06 00 00 00       	mov    $0x6,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <exec>:
SYSCALL(exec)
 298:	b8 07 00 00 00       	mov    $0x7,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <open>:
SYSCALL(open)
 2a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <mknod>:
SYSCALL(mknod)
 2a8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <unlink>:
SYSCALL(unlink)
 2b0:	b8 12 00 00 00       	mov    $0x12,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <fstat>:
SYSCALL(fstat)
 2b8:	b8 08 00 00 00       	mov    $0x8,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <link>:
SYSCALL(link)
 2c0:	b8 13 00 00 00       	mov    $0x13,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <mkdir>:
SYSCALL(mkdir)
 2c8:	b8 14 00 00 00       	mov    $0x14,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <chdir>:
SYSCALL(chdir)
 2d0:	b8 09 00 00 00       	mov    $0x9,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <dup>:
SYSCALL(dup)
 2d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <getpid>:
SYSCALL(getpid)
 2e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <sbrk>:
SYSCALL(sbrk)
 2e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <sleep>:
SYSCALL(sleep)
 2f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <uptime>:
SYSCALL(uptime)
 2f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <slabtest>:
SYSCALL(slabtest)
 300:	b8 16 00 00 00       	mov    $0x16,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <ps>:
SYSCALL(ps)
 308:	b8 17 00 00 00       	mov    $0x17,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
 316:	83 ec 3c             	sub    $0x3c,%esp
 319:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 31c:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 31e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 322:	74 77                	je     39b <printint+0x8b>
 324:	85 d2                	test   %edx,%edx
 326:	79 73                	jns    39b <printint+0x8b>
    neg = 1;
    x = -xx;
 328:	f7 db                	neg    %ebx
    neg = 1;
 32a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 331:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 336:	89 f7                	mov    %esi,%edi
 338:	83 c6 01             	add    $0x1,%esi
 33b:	89 d8                	mov    %ebx,%eax
 33d:	ba 00 00 00 00       	mov    $0x0,%edx
 342:	f7 f1                	div    %ecx
 344:	0f b6 92 f0 06 00 00 	movzbl 0x6f0(%edx),%edx
 34b:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 34f:	89 da                	mov    %ebx,%edx
 351:	89 c3                	mov    %eax,%ebx
 353:	39 d1                	cmp    %edx,%ecx
 355:	76 df                	jbe    336 <printint+0x26>
  if(neg)
 357:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 35b:	74 08                	je     365 <printint+0x55>
    buf[i++] = '-';
 35d:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 362:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 365:	85 f6                	test   %esi,%esi
 367:	7e 2a                	jle    393 <printint+0x83>
 369:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 36d:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 370:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 373:	0f b6 03             	movzbl (%ebx),%eax
 376:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 379:	83 ec 04             	sub    $0x4,%esp
 37c:	6a 01                	push   $0x1
 37e:	56                   	push   %esi
 37f:	ff 75 c4             	pushl  -0x3c(%ebp)
 382:	e8 f9 fe ff ff       	call   280 <write>
  while(--i >= 0)
 387:	89 d8                	mov    %ebx,%eax
 389:	83 eb 01             	sub    $0x1,%ebx
 38c:	83 c4 10             	add    $0x10,%esp
 38f:	39 f8                	cmp    %edi,%eax
 391:	75 e0                	jne    373 <printint+0x63>
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
  neg = 0;
 39b:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3a2:	eb 8d                	jmp    331 <printint+0x21>

000003a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a4:	f3 0f 1e fb          	endbr32 
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	57                   	push   %edi
 3ac:	56                   	push   %esi
 3ad:	53                   	push   %ebx
 3ae:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b1:	8b 75 0c             	mov    0xc(%ebp),%esi
 3b4:	0f b6 1e             	movzbl (%esi),%ebx
 3b7:	84 db                	test   %bl,%bl
 3b9:	0f 84 ab 01 00 00    	je     56a <printf+0x1c6>
 3bf:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3c2:	8d 45 10             	lea    0x10(%ebp),%eax
 3c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3c8:	bf 00 00 00 00       	mov    $0x0,%edi
 3cd:	eb 2d                	jmp    3fc <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3cf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3d2:	83 ec 04             	sub    $0x4,%esp
 3d5:	6a 01                	push   $0x1
 3d7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3da:	50                   	push   %eax
 3db:	ff 75 08             	pushl  0x8(%ebp)
 3de:	e8 9d fe ff ff       	call   280 <write>
        putc(fd, c);
 3e3:	83 c4 10             	add    $0x10,%esp
 3e6:	eb 05                	jmp    3ed <printf+0x49>
      }
    } else if(state == '%'){
 3e8:	83 ff 25             	cmp    $0x25,%edi
 3eb:	74 22                	je     40f <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3ed:	83 c6 01             	add    $0x1,%esi
 3f0:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3f4:	84 db                	test   %bl,%bl
 3f6:	0f 84 6e 01 00 00    	je     56a <printf+0x1c6>
    c = fmt[i] & 0xff;
 3fc:	0f be d3             	movsbl %bl,%edx
 3ff:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 402:	85 ff                	test   %edi,%edi
 404:	75 e2                	jne    3e8 <printf+0x44>
      if(c == '%'){
 406:	83 f8 25             	cmp    $0x25,%eax
 409:	75 c4                	jne    3cf <printf+0x2b>
        state = '%';
 40b:	89 c7                	mov    %eax,%edi
 40d:	eb de                	jmp    3ed <printf+0x49>
      if(c == 'd'){
 40f:	83 f8 64             	cmp    $0x64,%eax
 412:	74 59                	je     46d <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 414:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 41a:	83 fa 70             	cmp    $0x70,%edx
 41d:	74 7a                	je     499 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 41f:	83 f8 73             	cmp    $0x73,%eax
 422:	0f 84 9d 00 00 00    	je     4c5 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 428:	83 f8 63             	cmp    $0x63,%eax
 42b:	0f 84 ec 00 00 00    	je     51d <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 431:	83 f8 25             	cmp    $0x25,%eax
 434:	0f 84 0f 01 00 00    	je     549 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 43a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 43e:	83 ec 04             	sub    $0x4,%esp
 441:	6a 01                	push   $0x1
 443:	8d 45 e7             	lea    -0x19(%ebp),%eax
 446:	50                   	push   %eax
 447:	ff 75 08             	pushl  0x8(%ebp)
 44a:	e8 31 fe ff ff       	call   280 <write>
        putc(fd, c);
 44f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 452:	83 c4 0c             	add    $0xc,%esp
 455:	6a 01                	push   $0x1
 457:	8d 45 e7             	lea    -0x19(%ebp),%eax
 45a:	50                   	push   %eax
 45b:	ff 75 08             	pushl  0x8(%ebp)
 45e:	e8 1d fe ff ff       	call   280 <write>
        putc(fd, c);
 463:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 466:	bf 00 00 00 00       	mov    $0x0,%edi
 46b:	eb 80                	jmp    3ed <printf+0x49>
        printint(fd, *ap, 10, 1);
 46d:	83 ec 0c             	sub    $0xc,%esp
 470:	6a 01                	push   $0x1
 472:	b9 0a 00 00 00       	mov    $0xa,%ecx
 477:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 47a:	8b 17                	mov    (%edi),%edx
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	e8 8c fe ff ff       	call   310 <printint>
        ap++;
 484:	89 f8                	mov    %edi,%eax
 486:	83 c0 04             	add    $0x4,%eax
 489:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 48c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48f:	bf 00 00 00 00       	mov    $0x0,%edi
 494:	e9 54 ff ff ff       	jmp    3ed <printf+0x49>
        printint(fd, *ap, 16, 0);
 499:	83 ec 0c             	sub    $0xc,%esp
 49c:	6a 00                	push   $0x0
 49e:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a6:	8b 17                	mov    (%edi),%edx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	e8 60 fe ff ff       	call   310 <printint>
        ap++;
 4b0:	89 f8                	mov    %edi,%eax
 4b2:	83 c0 04             	add    $0x4,%eax
 4b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4bb:	bf 00 00 00 00       	mov    $0x0,%edi
 4c0:	e9 28 ff ff ff       	jmp    3ed <printf+0x49>
        s = (char*)*ap;
 4c5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4c8:	8b 01                	mov    (%ecx),%eax
        ap++;
 4ca:	83 c1 04             	add    $0x4,%ecx
 4cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4d0:	85 c0                	test   %eax,%eax
 4d2:	74 13                	je     4e7 <printf+0x143>
        s = (char*)*ap;
 4d4:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4d6:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4d9:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4de:	84 c0                	test   %al,%al
 4e0:	75 0f                	jne    4f1 <printf+0x14d>
 4e2:	e9 06 ff ff ff       	jmp    3ed <printf+0x49>
          s = "(null)";
 4e7:	bb e9 06 00 00       	mov    $0x6e9,%ebx
        while(*s != 0){
 4ec:	b8 28 00 00 00       	mov    $0x28,%eax
 4f1:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4f4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4f7:	83 ec 04             	sub    $0x4,%esp
 4fa:	6a 01                	push   $0x1
 4fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ff:	50                   	push   %eax
 500:	57                   	push   %edi
 501:	e8 7a fd ff ff       	call   280 <write>
          s++;
 506:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 509:	0f b6 03             	movzbl (%ebx),%eax
 50c:	83 c4 10             	add    $0x10,%esp
 50f:	84 c0                	test   %al,%al
 511:	75 e1                	jne    4f4 <printf+0x150>
      state = 0;
 513:	bf 00 00 00 00       	mov    $0x0,%edi
 518:	e9 d0 fe ff ff       	jmp    3ed <printf+0x49>
        putc(fd, *ap);
 51d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 520:	8b 07                	mov    (%edi),%eax
 522:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 525:	83 ec 04             	sub    $0x4,%esp
 528:	6a 01                	push   $0x1
 52a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 4a fd ff ff       	call   280 <write>
        ap++;
 536:	83 c7 04             	add    $0x4,%edi
 539:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 53c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53f:	bf 00 00 00 00       	mov    $0x0,%edi
 544:	e9 a4 fe ff ff       	jmp    3ed <printf+0x49>
        putc(fd, c);
 549:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 54c:	83 ec 04             	sub    $0x4,%esp
 54f:	6a 01                	push   $0x1
 551:	8d 45 e7             	lea    -0x19(%ebp),%eax
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 23 fd ff ff       	call   280 <write>
 55d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 560:	bf 00 00 00 00       	mov    $0x0,%edi
 565:	e9 83 fe ff ff       	jmp    3ed <printf+0x49>
    }
  }
}
 56a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56d:	5b                   	pop    %ebx
 56e:	5e                   	pop    %esi
 56f:	5f                   	pop    %edi
 570:	5d                   	pop    %ebp
 571:	c3                   	ret    

00000572 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 572:	f3 0f 1e fb          	endbr32 
 576:	55                   	push   %ebp
 577:	89 e5                	mov    %esp,%ebp
 579:	57                   	push   %edi
 57a:	56                   	push   %esi
 57b:	53                   	push   %ebx
 57c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 57f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 582:	a1 64 09 00 00       	mov    0x964,%eax
 587:	eb 0c                	jmp    595 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 589:	8b 10                	mov    (%eax),%edx
 58b:	39 c2                	cmp    %eax,%edx
 58d:	77 04                	ja     593 <free+0x21>
 58f:	39 ca                	cmp    %ecx,%edx
 591:	77 10                	ja     5a3 <free+0x31>
{
 593:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 595:	39 c8                	cmp    %ecx,%eax
 597:	73 f0                	jae    589 <free+0x17>
 599:	8b 10                	mov    (%eax),%edx
 59b:	39 ca                	cmp    %ecx,%edx
 59d:	77 04                	ja     5a3 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59f:	39 c2                	cmp    %eax,%edx
 5a1:	77 f0                	ja     593 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a6:	8b 10                	mov    (%eax),%edx
 5a8:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ab:	39 fa                	cmp    %edi,%edx
 5ad:	74 19                	je     5c8 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5af:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b2:	8b 50 04             	mov    0x4(%eax),%edx
 5b5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b8:	39 f1                	cmp    %esi,%ecx
 5ba:	74 1b                	je     5d7 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5bc:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5be:	a3 64 09 00 00       	mov    %eax,0x964
}
 5c3:	5b                   	pop    %ebx
 5c4:	5e                   	pop    %esi
 5c5:	5f                   	pop    %edi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5c8:	03 72 04             	add    0x4(%edx),%esi
 5cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ce:	8b 10                	mov    (%eax),%edx
 5d0:	8b 12                	mov    (%edx),%edx
 5d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5d5:	eb db                	jmp    5b2 <free+0x40>
    p->s.size += bp->s.size;
 5d7:	03 53 fc             	add    -0x4(%ebx),%edx
 5da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5dd:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5e0:	89 10                	mov    %edx,(%eax)
 5e2:	eb da                	jmp    5be <free+0x4c>

000005e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e4:	f3 0f 1e fb          	endbr32 
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	57                   	push   %edi
 5ec:	56                   	push   %esi
 5ed:	53                   	push   %ebx
 5ee:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	8d 58 07             	lea    0x7(%eax),%ebx
 5f7:	c1 eb 03             	shr    $0x3,%ebx
 5fa:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5fd:	8b 15 64 09 00 00    	mov    0x964,%edx
 603:	85 d2                	test   %edx,%edx
 605:	74 20                	je     627 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 607:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 609:	8b 48 04             	mov    0x4(%eax),%ecx
 60c:	39 cb                	cmp    %ecx,%ebx
 60e:	76 3c                	jbe    64c <malloc+0x68>
 610:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 616:	be 00 10 00 00       	mov    $0x1000,%esi
 61b:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 61e:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 625:	eb 72                	jmp    699 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 627:	c7 05 64 09 00 00 68 	movl   $0x968,0x964
 62e:	09 00 00 
 631:	c7 05 68 09 00 00 68 	movl   $0x968,0x968
 638:	09 00 00 
    base.s.size = 0;
 63b:	c7 05 6c 09 00 00 00 	movl   $0x0,0x96c
 642:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 645:	b8 68 09 00 00       	mov    $0x968,%eax
 64a:	eb c4                	jmp    610 <malloc+0x2c>
      if(p->s.size == nunits)
 64c:	39 cb                	cmp    %ecx,%ebx
 64e:	74 1e                	je     66e <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 650:	29 d9                	sub    %ebx,%ecx
 652:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 655:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 658:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 65b:	89 15 64 09 00 00    	mov    %edx,0x964
      return (void*)(p + 1);
 661:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 664:	89 d0                	mov    %edx,%eax
 666:	8d 65 f4             	lea    -0xc(%ebp),%esp
 669:	5b                   	pop    %ebx
 66a:	5e                   	pop    %esi
 66b:	5f                   	pop    %edi
 66c:	5d                   	pop    %ebp
 66d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 66e:	8b 08                	mov    (%eax),%ecx
 670:	89 0a                	mov    %ecx,(%edx)
 672:	eb e7                	jmp    65b <malloc+0x77>
  hp->s.size = nu;
 674:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 677:	83 ec 0c             	sub    $0xc,%esp
 67a:	83 c0 08             	add    $0x8,%eax
 67d:	50                   	push   %eax
 67e:	e8 ef fe ff ff       	call   572 <free>
  return freep;
 683:	8b 15 64 09 00 00    	mov    0x964,%edx
      if((p = morecore(nunits)) == 0)
 689:	83 c4 10             	add    $0x10,%esp
 68c:	85 d2                	test   %edx,%edx
 68e:	74 d4                	je     664 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 690:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 692:	8b 48 04             	mov    0x4(%eax),%ecx
 695:	39 d9                	cmp    %ebx,%ecx
 697:	73 b3                	jae    64c <malloc+0x68>
    if(p == freep)
 699:	89 c2                	mov    %eax,%edx
 69b:	39 05 64 09 00 00    	cmp    %eax,0x964
 6a1:	75 ed                	jne    690 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 6a3:	83 ec 0c             	sub    $0xc,%esp
 6a6:	57                   	push   %edi
 6a7:	e8 3c fc ff ff       	call   2e8 <sbrk>
  if(p == (char*)-1)
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b2:	75 c0                	jne    674 <malloc+0x90>
        return 0;
 6b4:	ba 00 00 00 00       	mov    $0x0,%edx
 6b9:	eb a9                	jmp    664 <malloc+0x80>
