
user/_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  19:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 22                	jle    45 <main+0x45>
    kill(atoi(argv[i]));
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	ff 34 9f             	push   (%edi,%ebx,4)
  29:	e8 81 01 00 00       	call   1af <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 1b 02 00 00       	call   251 <kill>
  for(i=1; i<argc; i++)
  36:	83 c3 01             	add    $0x1,%ebx
  39:	83 c4 10             	add    $0x10,%esp
  3c:	39 de                	cmp    %ebx,%esi
  3e:	75 e3                	jne    23 <main+0x23>
  exit();
  40:	e8 dc 01 00 00       	call   221 <exit>
    printf(2, "usage: kill pid...\n");
  45:	83 ec 08             	sub    $0x8,%esp
  48:	68 60 06 00 00       	push   $0x660
  4d:	6a 02                	push   $0x2
  4f:	e8 15 03 00 00       	call   369 <printf>
    exit();
  54:	e8 c8 01 00 00       	call   221 <exit>

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	53                   	push   %ebx
  5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  63:	b8 00 00 00 00       	mov    $0x0,%eax
  68:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  6c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6f:	83 c0 01             	add    $0x1,%eax
  72:	84 d2                	test   %dl,%dl
  74:	75 f2                	jne    68 <strcpy+0xf>
    ;
  return os;
}
  76:	89 c8                	mov    %ecx,%eax
  78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  83:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  86:	0f b6 01             	movzbl (%ecx),%eax
  89:	84 c0                	test   %al,%al
  8b:	74 11                	je     9e <strcmp+0x21>
  8d:	38 02                	cmp    %al,(%edx)
  8f:	75 0d                	jne    9e <strcmp+0x21>
    p++, q++;
  91:	83 c1 01             	add    $0x1,%ecx
  94:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  97:	0f b6 01             	movzbl (%ecx),%eax
  9a:	84 c0                	test   %al,%al
  9c:	75 ef                	jne    8d <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	29 d0                	sub    %edx,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ae:	80 3a 00             	cmpb   $0x0,(%edx)
  b1:	74 14                	je     c7 <strlen+0x1f>
  b3:	b8 00 00 00 00       	mov    $0x0,%eax
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	89 c1                	mov    %eax,%ecx
  bd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c1:	75 f5                	jne    b8 <strlen+0x10>
    ;
  return n;
}
  c3:	89 c8                	mov    %ecx,%eax
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  cc:	eb f5                	jmp    c3 <strlen+0x1b>

000000ce <memset>:

void*
memset(void *dst, int c, uint n)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	57                   	push   %edi
  d2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d5:	89 d7                	mov    %edx,%edi
  d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	fc                   	cld    
  de:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e0:	89 d0                	mov    %edx,%eax
  e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <strchr>:

char*
strchr(const char *s, char c)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f1:	0f b6 10             	movzbl (%eax),%edx
  f4:	84 d2                	test   %dl,%dl
  f6:	74 15                	je     10d <strchr+0x26>
    if(*s == c)
  f8:	38 d1                	cmp    %dl,%cl
  fa:	74 0f                	je     10b <strchr+0x24>
  for(; *s; s++)
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	84 d2                	test   %dl,%dl
 104:	75 f2                	jne    f8 <strchr+0x11>
      return (char*)s;
  return 0;
 106:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
  return 0;
 10d:	b8 00 00 00 00       	mov    $0x0,%eax
 112:	eb f7                	jmp    10b <strchr+0x24>

00000114 <gets>:

char*
gets(char *buf, int max)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 2c             	sub    $0x2c,%esp
 11d:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 125:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 128:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 12b:	83 c3 01             	add    $0x1,%ebx
 12e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 131:	7d 27                	jge    15a <gets+0x46>
    cc = read(0, &c, 1);
 133:	83 ec 04             	sub    $0x4,%esp
 136:	6a 01                	push   $0x1
 138:	57                   	push   %edi
 139:	6a 00                	push   $0x0
 13b:	e8 f9 00 00 00       	call   239 <read>
    if(cc < 1)
 140:	83 c4 10             	add    $0x10,%esp
 143:	85 c0                	test   %eax,%eax
 145:	7e 13                	jle    15a <gets+0x46>
      break;
    buf[i++] = c;
 147:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14b:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 14f:	3c 0a                	cmp    $0xa,%al
 151:	74 04                	je     157 <gets+0x43>
 153:	3c 0d                	cmp    $0xd,%al
 155:	75 d1                	jne    128 <gets+0x14>
  for(i=0; i+1 < max; ){
 157:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 15a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 15d:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 161:	89 f0                	mov    %esi,%eax
 163:	8d 65 f4             	lea    -0xc(%ebp),%esp
 166:	5b                   	pop    %ebx
 167:	5e                   	pop    %esi
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <stat>:

int
stat(const char *n, struct stat *st)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	56                   	push   %esi
 16f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	83 ec 08             	sub    $0x8,%esp
 173:	6a 00                	push   $0x0
 175:	ff 75 08             	push   0x8(%ebp)
 178:	e8 e4 00 00 00       	call   261 <open>
  if(fd < 0)
 17d:	83 c4 10             	add    $0x10,%esp
 180:	85 c0                	test   %eax,%eax
 182:	78 24                	js     1a8 <stat+0x3d>
 184:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 186:	83 ec 08             	sub    $0x8,%esp
 189:	ff 75 0c             	push   0xc(%ebp)
 18c:	50                   	push   %eax
 18d:	e8 e7 00 00 00       	call   279 <fstat>
 192:	89 c6                	mov    %eax,%esi
  close(fd);
 194:	89 1c 24             	mov    %ebx,(%esp)
 197:	e8 ad 00 00 00       	call   249 <close>
  return r;
 19c:	83 c4 10             	add    $0x10,%esp
}
 19f:	89 f0                	mov    %esi,%eax
 1a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a4:	5b                   	pop    %ebx
 1a5:	5e                   	pop    %esi
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret    
    return -1;
 1a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ad:	eb f0                	jmp    19f <stat+0x34>

000001af <atoi>:

int
atoi(const char *s)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	53                   	push   %ebx
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	0f b6 02             	movzbl (%edx),%eax
 1b9:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1bc:	80 f9 09             	cmp    $0x9,%cl
 1bf:	77 24                	ja     1e5 <atoi+0x36>
  n = 0;
 1c1:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1c6:	83 c2 01             	add    $0x1,%edx
 1c9:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1cc:	0f be c0             	movsbl %al,%eax
 1cf:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1d3:	0f b6 02             	movzbl (%edx),%eax
 1d6:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d9:	80 fb 09             	cmp    $0x9,%bl
 1dc:	76 e8                	jbe    1c6 <atoi+0x17>
  return n;
}
 1de:	89 c8                	mov    %ecx,%eax
 1e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    
  n = 0;
 1e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1ea:	eb f2                	jmp    1de <atoi+0x2f>

000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	8b 75 08             	mov    0x8(%ebp),%esi
 1f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fa:	85 db                	test   %ebx,%ebx
 1fc:	7e 15                	jle    213 <memmove+0x27>
 1fe:	01 f3                	add    %esi,%ebx
  dst = vdst;
 200:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 202:	83 c2 01             	add    $0x1,%edx
 205:	83 c0 01             	add    $0x1,%eax
 208:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 20c:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 20f:	39 c3                	cmp    %eax,%ebx
 211:	75 ef                	jne    202 <memmove+0x16>
  return vdst;
}
 213:	89 f0                	mov    %esi,%eax
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    

00000219 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 219:	b8 01 00 00 00       	mov    $0x1,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <exit>:
SYSCALL(exit)
 221:	b8 02 00 00 00       	mov    $0x2,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <wait>:
SYSCALL(wait)
 229:	b8 03 00 00 00       	mov    $0x3,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <pipe>:
SYSCALL(pipe)
 231:	b8 04 00 00 00       	mov    $0x4,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <read>:
SYSCALL(read)
 239:	b8 05 00 00 00       	mov    $0x5,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <write>:
SYSCALL(write)
 241:	b8 10 00 00 00       	mov    $0x10,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <close>:
SYSCALL(close)
 249:	b8 15 00 00 00       	mov    $0x15,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <kill>:
SYSCALL(kill)
 251:	b8 06 00 00 00       	mov    $0x6,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <exec>:
SYSCALL(exec)
 259:	b8 07 00 00 00       	mov    $0x7,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <open>:
SYSCALL(open)
 261:	b8 0f 00 00 00       	mov    $0xf,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <mknod>:
SYSCALL(mknod)
 269:	b8 11 00 00 00       	mov    $0x11,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <unlink>:
SYSCALL(unlink)
 271:	b8 12 00 00 00       	mov    $0x12,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <fstat>:
SYSCALL(fstat)
 279:	b8 08 00 00 00       	mov    $0x8,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <link>:
SYSCALL(link)
 281:	b8 13 00 00 00       	mov    $0x13,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <mkdir>:
SYSCALL(mkdir)
 289:	b8 14 00 00 00       	mov    $0x14,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <chdir>:
SYSCALL(chdir)
 291:	b8 09 00 00 00       	mov    $0x9,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <dup>:
SYSCALL(dup)
 299:	b8 0a 00 00 00       	mov    $0xa,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <getpid>:
SYSCALL(getpid)
 2a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <sbrk>:
SYSCALL(sbrk)
 2a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <sleep>:
SYSCALL(sleep)
 2b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <uptime>:
SYSCALL(uptime)
 2b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <slabtest>:
SYSCALL(slabtest)
 2c1:	b8 16 00 00 00       	mov    $0x16,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <ps>:
SYSCALL(ps)
 2c9:	b8 17 00 00 00       	mov    $0x17,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	57                   	push   %edi
 2d5:	56                   	push   %esi
 2d6:	53                   	push   %ebx
 2d7:	83 ec 3c             	sub    $0x3c,%esp
 2da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2dd:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e3:	74 79                	je     35e <printint+0x8d>
 2e5:	85 d2                	test   %edx,%edx
 2e7:	79 75                	jns    35e <printint+0x8d>
    neg = 1;
    x = -xx;
 2e9:	89 d1                	mov    %edx,%ecx
 2eb:	f7 d9                	neg    %ecx
    neg = 1;
 2ed:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f9:	89 df                	mov    %ebx,%edi
 2fb:	83 c3 01             	add    $0x1,%ebx
 2fe:	89 c8                	mov    %ecx,%eax
 300:	ba 00 00 00 00       	mov    $0x0,%edx
 305:	f7 f6                	div    %esi
 307:	0f b6 92 d4 06 00 00 	movzbl 0x6d4(%edx),%edx
 30e:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 312:	89 ca                	mov    %ecx,%edx
 314:	89 c1                	mov    %eax,%ecx
 316:	39 d6                	cmp    %edx,%esi
 318:	76 df                	jbe    2f9 <printint+0x28>
  if(neg)
 31a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 31e:	74 08                	je     328 <printint+0x57>
    buf[i++] = '-';
 320:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 325:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 328:	85 db                	test   %ebx,%ebx
 32a:	7e 2a                	jle    356 <printint+0x85>
 32c:	8d 7d d8             	lea    -0x28(%ebp),%edi
 32f:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 333:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 336:	0f b6 03             	movzbl (%ebx),%eax
 339:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 33c:	83 ec 04             	sub    $0x4,%esp
 33f:	6a 01                	push   $0x1
 341:	56                   	push   %esi
 342:	ff 75 c4             	push   -0x3c(%ebp)
 345:	e8 f7 fe ff ff       	call   241 <write>
  while(--i >= 0)
 34a:	89 d8                	mov    %ebx,%eax
 34c:	83 eb 01             	sub    $0x1,%ebx
 34f:	83 c4 10             	add    $0x10,%esp
 352:	39 f8                	cmp    %edi,%eax
 354:	75 e0                	jne    336 <printint+0x65>
}
 356:	8d 65 f4             	lea    -0xc(%ebp),%esp
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5f                   	pop    %edi
 35c:	5d                   	pop    %ebp
 35d:	c3                   	ret    
    x = xx;
 35e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 360:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 367:	eb 8b                	jmp    2f4 <printint+0x23>

00000369 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	56                   	push   %esi
 36e:	53                   	push   %ebx
 36f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 372:	8b 75 0c             	mov    0xc(%ebp),%esi
 375:	0f b6 1e             	movzbl (%esi),%ebx
 378:	84 db                	test   %bl,%bl
 37a:	0f 84 9f 01 00 00    	je     51f <printf+0x1b6>
 380:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 383:	8d 45 10             	lea    0x10(%ebp),%eax
 386:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 389:	bf 00 00 00 00       	mov    $0x0,%edi
 38e:	eb 2d                	jmp    3bd <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 390:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 393:	83 ec 04             	sub    $0x4,%esp
 396:	6a 01                	push   $0x1
 398:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39b:	50                   	push   %eax
 39c:	ff 75 08             	push   0x8(%ebp)
 39f:	e8 9d fe ff ff       	call   241 <write>
        putc(fd, c);
 3a4:	83 c4 10             	add    $0x10,%esp
 3a7:	eb 05                	jmp    3ae <printf+0x45>
      }
    } else if(state == '%'){
 3a9:	83 ff 25             	cmp    $0x25,%edi
 3ac:	74 1f                	je     3cd <printf+0x64>
  for(i = 0; fmt[i]; i++){
 3ae:	83 c6 01             	add    $0x1,%esi
 3b1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3b5:	84 db                	test   %bl,%bl
 3b7:	0f 84 62 01 00 00    	je     51f <printf+0x1b6>
    c = fmt[i] & 0xff;
 3bd:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c0:	85 ff                	test   %edi,%edi
 3c2:	75 e5                	jne    3a9 <printf+0x40>
      if(c == '%'){
 3c4:	83 f8 25             	cmp    $0x25,%eax
 3c7:	75 c7                	jne    390 <printf+0x27>
        state = '%';
 3c9:	89 c7                	mov    %eax,%edi
 3cb:	eb e1                	jmp    3ae <printf+0x45>
      if(c == 'd'){
 3cd:	83 f8 25             	cmp    $0x25,%eax
 3d0:	0f 84 f2 00 00 00    	je     4c8 <printf+0x15f>
 3d6:	8d 50 9d             	lea    -0x63(%eax),%edx
 3d9:	83 fa 15             	cmp    $0x15,%edx
 3dc:	0f 87 07 01 00 00    	ja     4e9 <printf+0x180>
 3e2:	0f 87 01 01 00 00    	ja     4e9 <printf+0x180>
 3e8:	ff 24 95 7c 06 00 00 	jmp    *0x67c(,%edx,4)
        printint(fd, *ap, 10, 1);
 3ef:	83 ec 0c             	sub    $0xc,%esp
 3f2:	6a 01                	push   $0x1
 3f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3fc:	8b 17                	mov    (%edi),%edx
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	e8 cb fe ff ff       	call   2d1 <printint>
        ap++;
 406:	89 f8                	mov    %edi,%eax
 408:	83 c0 04             	add    $0x4,%eax
 40b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 40e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 411:	bf 00 00 00 00       	mov    $0x0,%edi
 416:	eb 96                	jmp    3ae <printf+0x45>
        printint(fd, *ap, 16, 0);
 418:	83 ec 0c             	sub    $0xc,%esp
 41b:	6a 00                	push   $0x0
 41d:	b9 10 00 00 00       	mov    $0x10,%ecx
 422:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 425:	8b 17                	mov    (%edi),%edx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	e8 a2 fe ff ff       	call   2d1 <printint>
        ap++;
 42f:	89 f8                	mov    %edi,%eax
 431:	83 c0 04             	add    $0x4,%eax
 434:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 437:	83 c4 10             	add    $0x10,%esp
      state = 0;
 43a:	bf 00 00 00 00       	mov    $0x0,%edi
 43f:	e9 6a ff ff ff       	jmp    3ae <printf+0x45>
        s = (char*)*ap;
 444:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 447:	8b 01                	mov    (%ecx),%eax
        ap++;
 449:	83 c1 04             	add    $0x4,%ecx
 44c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 44f:	85 c0                	test   %eax,%eax
 451:	74 13                	je     466 <printf+0xfd>
        s = (char*)*ap;
 453:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 455:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 458:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 45d:	84 c0                	test   %al,%al
 45f:	75 0f                	jne    470 <printf+0x107>
 461:	e9 48 ff ff ff       	jmp    3ae <printf+0x45>
          s = "(null)";
 466:	bb 74 06 00 00       	mov    $0x674,%ebx
        while(*s != 0){
 46b:	b8 28 00 00 00       	mov    $0x28,%eax
 470:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 473:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 476:	83 ec 04             	sub    $0x4,%esp
 479:	6a 01                	push   $0x1
 47b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 47e:	50                   	push   %eax
 47f:	57                   	push   %edi
 480:	e8 bc fd ff ff       	call   241 <write>
          s++;
 485:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 488:	0f b6 03             	movzbl (%ebx),%eax
 48b:	83 c4 10             	add    $0x10,%esp
 48e:	84 c0                	test   %al,%al
 490:	75 e1                	jne    473 <printf+0x10a>
      state = 0;
 492:	bf 00 00 00 00       	mov    $0x0,%edi
 497:	e9 12 ff ff ff       	jmp    3ae <printf+0x45>
        putc(fd, *ap);
 49c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49f:	8b 07                	mov    (%edi),%eax
 4a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	6a 01                	push   $0x1
 4a9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	push   0x8(%ebp)
 4b0:	e8 8c fd ff ff       	call   241 <write>
        ap++;
 4b5:	83 c7 04             	add    $0x4,%edi
 4b8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4bb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4be:	bf 00 00 00 00       	mov    $0x0,%edi
 4c3:	e9 e6 fe ff ff       	jmp    3ae <printf+0x45>
        putc(fd, c);
 4c8:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	6a 01                	push   $0x1
 4d0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	push   0x8(%ebp)
 4d7:	e8 65 fd ff ff       	call   241 <write>
 4dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4df:	bf 00 00 00 00       	mov    $0x0,%edi
 4e4:	e9 c5 fe ff ff       	jmp    3ae <printf+0x45>
        putc(fd, '%');
 4e9:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	6a 01                	push   $0x1
 4f2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f5:	50                   	push   %eax
 4f6:	ff 75 08             	push   0x8(%ebp)
 4f9:	e8 43 fd ff ff       	call   241 <write>
        putc(fd, c);
 4fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 501:	83 c4 0c             	add    $0xc,%esp
 504:	6a 01                	push   $0x1
 506:	8d 45 e7             	lea    -0x19(%ebp),%eax
 509:	50                   	push   %eax
 50a:	ff 75 08             	push   0x8(%ebp)
 50d:	e8 2f fd ff ff       	call   241 <write>
        putc(fd, c);
 512:	83 c4 10             	add    $0x10,%esp
      state = 0;
 515:	bf 00 00 00 00       	mov    $0x0,%edi
 51a:	e9 8f fe ff ff       	jmp    3ae <printf+0x45>
    }
  }
}
 51f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5f                   	pop    %edi
 525:	5d                   	pop    %ebp
 526:	c3                   	ret    

00000527 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 527:	55                   	push   %ebp
 528:	89 e5                	mov    %esp,%ebp
 52a:	57                   	push   %edi
 52b:	56                   	push   %esi
 52c:	53                   	push   %ebx
 52d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 530:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 533:	a1 48 09 00 00       	mov    0x948,%eax
 538:	eb 0c                	jmp    546 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53a:	8b 10                	mov    (%eax),%edx
 53c:	39 c2                	cmp    %eax,%edx
 53e:	77 04                	ja     544 <free+0x1d>
 540:	39 ca                	cmp    %ecx,%edx
 542:	77 10                	ja     554 <free+0x2d>
{
 544:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 546:	39 c8                	cmp    %ecx,%eax
 548:	73 f0                	jae    53a <free+0x13>
 54a:	8b 10                	mov    (%eax),%edx
 54c:	39 ca                	cmp    %ecx,%edx
 54e:	77 04                	ja     554 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 550:	39 c2                	cmp    %eax,%edx
 552:	77 f0                	ja     544 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 554:	8b 73 fc             	mov    -0x4(%ebx),%esi
 557:	8b 10                	mov    (%eax),%edx
 559:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55c:	39 fa                	cmp    %edi,%edx
 55e:	74 19                	je     579 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 560:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 563:	8b 50 04             	mov    0x4(%eax),%edx
 566:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 569:	39 f1                	cmp    %esi,%ecx
 56b:	74 18                	je     585 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 56d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 56f:	a3 48 09 00 00       	mov    %eax,0x948
}
 574:	5b                   	pop    %ebx
 575:	5e                   	pop    %esi
 576:	5f                   	pop    %edi
 577:	5d                   	pop    %ebp
 578:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 579:	03 72 04             	add    0x4(%edx),%esi
 57c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 57f:	8b 10                	mov    (%eax),%edx
 581:	8b 12                	mov    (%edx),%edx
 583:	eb db                	jmp    560 <free+0x39>
    p->s.size += bp->s.size;
 585:	03 53 fc             	add    -0x4(%ebx),%edx
 588:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 58b:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 58e:	eb dd                	jmp    56d <free+0x46>

00000590 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	8d 58 07             	lea    0x7(%eax),%ebx
 59f:	c1 eb 03             	shr    $0x3,%ebx
 5a2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a5:	8b 15 48 09 00 00    	mov    0x948,%edx
 5ab:	85 d2                	test   %edx,%edx
 5ad:	74 1c                	je     5cb <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5af:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b1:	8b 48 04             	mov    0x4(%eax),%ecx
 5b4:	39 cb                	cmp    %ecx,%ebx
 5b6:	76 38                	jbe    5f0 <malloc+0x60>
 5b8:	be 00 10 00 00       	mov    $0x1000,%esi
 5bd:	39 f3                	cmp    %esi,%ebx
 5bf:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5c2:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5c9:	eb 72                	jmp    63d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 5cb:	c7 05 48 09 00 00 4c 	movl   $0x94c,0x948
 5d2:	09 00 00 
 5d5:	c7 05 4c 09 00 00 4c 	movl   $0x94c,0x94c
 5dc:	09 00 00 
    base.s.size = 0;
 5df:	c7 05 50 09 00 00 00 	movl   $0x0,0x950
 5e6:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e9:	b8 4c 09 00 00       	mov    $0x94c,%eax
 5ee:	eb c8                	jmp    5b8 <malloc+0x28>
      if(p->s.size == nunits)
 5f0:	39 cb                	cmp    %ecx,%ebx
 5f2:	74 1e                	je     612 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5f4:	29 d9                	sub    %ebx,%ecx
 5f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5fc:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5ff:	89 15 48 09 00 00    	mov    %edx,0x948
      return (void*)(p + 1);
 605:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 608:	89 d0                	mov    %edx,%eax
 60a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60d:	5b                   	pop    %ebx
 60e:	5e                   	pop    %esi
 60f:	5f                   	pop    %edi
 610:	5d                   	pop    %ebp
 611:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 612:	8b 08                	mov    (%eax),%ecx
 614:	89 0a                	mov    %ecx,(%edx)
 616:	eb e7                	jmp    5ff <malloc+0x6f>
  hp->s.size = nu;
 618:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 61b:	83 ec 0c             	sub    $0xc,%esp
 61e:	83 c0 08             	add    $0x8,%eax
 621:	50                   	push   %eax
 622:	e8 00 ff ff ff       	call   527 <free>
  return freep;
 627:	8b 15 48 09 00 00    	mov    0x948,%edx
      if((p = morecore(nunits)) == 0)
 62d:	83 c4 10             	add    $0x10,%esp
 630:	85 d2                	test   %edx,%edx
 632:	74 d4                	je     608 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 634:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 636:	8b 48 04             	mov    0x4(%eax),%ecx
 639:	39 d9                	cmp    %ebx,%ecx
 63b:	73 b3                	jae    5f0 <malloc+0x60>
    if(p == freep)
 63d:	89 c2                	mov    %eax,%edx
 63f:	39 05 48 09 00 00    	cmp    %eax,0x948
 645:	75 ed                	jne    634 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 647:	83 ec 0c             	sub    $0xc,%esp
 64a:	57                   	push   %edi
 64b:	e8 59 fc ff ff       	call   2a9 <sbrk>
  if(p == (char*)-1)
 650:	83 c4 10             	add    $0x10,%esp
 653:	83 f8 ff             	cmp    $0xffffffff,%eax
 656:	75 c0                	jne    618 <malloc+0x88>
        return 0;
 658:	ba 00 00 00 00       	mov    $0x0,%edx
 65d:	eb a9                	jmp    608 <malloc+0x78>
