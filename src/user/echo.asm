
user/_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 3e                	jle    5c <main+0x5c>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 01             	add    $0x1,%ebx
  26:	39 f3                	cmp    %esi,%ebx
  28:	74 1a                	je     44 <main+0x44>
  2a:	68 68 06 00 00       	push   $0x668
  2f:	ff 74 9f fc          	push   -0x4(%edi,%ebx,4)
  33:	68 6a 06 00 00       	push   $0x66a
  38:	6a 01                	push   $0x1
  3a:	e8 32 03 00 00       	call   371 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb df                	jmp    23 <main+0x23>
  44:	68 6f 06 00 00       	push   $0x66f
  49:	ff 74 b7 fc          	push   -0x4(%edi,%esi,4)
  4d:	68 6a 06 00 00       	push   $0x66a
  52:	6a 01                	push   $0x1
  54:	e8 18 03 00 00       	call   371 <printf>
  59:	83 c4 10             	add    $0x10,%esp
  exit();
  5c:	e8 c8 01 00 00       	call   229 <exit>

00000061 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  61:	55                   	push   %ebp
  62:	89 e5                	mov    %esp,%ebp
  64:	53                   	push   %ebx
  65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6b:	b8 00 00 00 00       	mov    $0x0,%eax
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	83 c0 01             	add    $0x1,%eax
  7a:	84 d2                	test   %dl,%dl
  7c:	75 f2                	jne    70 <strcpy+0xf>
    ;
  return os;
}
  7e:	89 c8                	mov    %ecx,%eax
  80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  83:	c9                   	leave  
  84:	c3                   	ret    

00000085 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8e:	0f b6 01             	movzbl (%ecx),%eax
  91:	84 c0                	test   %al,%al
  93:	74 11                	je     a6 <strcmp+0x21>
  95:	38 02                	cmp    %al,(%edx)
  97:	75 0d                	jne    a6 <strcmp+0x21>
    p++, q++;
  99:	83 c1 01             	add    $0x1,%ecx
  9c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	75 ef                	jne    95 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  a6:	0f b6 c0             	movzbl %al,%eax
  a9:	0f b6 12             	movzbl (%edx),%edx
  ac:	29 d0                	sub    %edx,%eax
}
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b6:	80 3a 00             	cmpb   $0x0,(%edx)
  b9:	74 14                	je     cf <strlen+0x1f>
  bb:	b8 00 00 00 00       	mov    $0x0,%eax
  c0:	83 c0 01             	add    $0x1,%eax
  c3:	89 c1                	mov    %eax,%ecx
  c5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c9:	75 f5                	jne    c0 <strlen+0x10>
    ;
  return n;
}
  cb:	89 c8                	mov    %ecx,%eax
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    
  for(n = 0; s[n]; n++)
  cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  d4:	eb f5                	jmp    cb <strlen+0x1b>

000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	57                   	push   %edi
  da:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  dd:	89 d7                	mov    %edx,%edi
  df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	fc                   	cld    
  e6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e8:	89 d0                	mov    %edx,%eax
  ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <strchr>:

char*
strchr(const char *s, char c)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f9:	0f b6 10             	movzbl (%eax),%edx
  fc:	84 d2                	test   %dl,%dl
  fe:	74 15                	je     115 <strchr+0x26>
    if(*s == c)
 100:	38 d1                	cmp    %dl,%cl
 102:	74 0f                	je     113 <strchr+0x24>
  for(; *s; s++)
 104:	83 c0 01             	add    $0x1,%eax
 107:	0f b6 10             	movzbl (%eax),%edx
 10a:	84 d2                	test   %dl,%dl
 10c:	75 f2                	jne    100 <strchr+0x11>
      return (char*)s;
  return 0;
 10e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
  return 0;
 115:	b8 00 00 00 00       	mov    $0x0,%eax
 11a:	eb f7                	jmp    113 <strchr+0x24>

0000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	56                   	push   %esi
 121:	53                   	push   %ebx
 122:	83 ec 2c             	sub    $0x2c,%esp
 125:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 12d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 130:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 133:	83 c3 01             	add    $0x1,%ebx
 136:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 139:	7d 27                	jge    162 <gets+0x46>
    cc = read(0, &c, 1);
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	6a 01                	push   $0x1
 140:	57                   	push   %edi
 141:	6a 00                	push   $0x0
 143:	e8 f9 00 00 00       	call   241 <read>
    if(cc < 1)
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	7e 13                	jle    162 <gets+0x46>
      break;
    buf[i++] = c;
 14f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 153:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 157:	3c 0a                	cmp    $0xa,%al
 159:	74 04                	je     15f <gets+0x43>
 15b:	3c 0d                	cmp    $0xd,%al
 15d:	75 d1                	jne    130 <gets+0x14>
  for(i=0; i+1 < max; ){
 15f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 162:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 165:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 169:	89 f0                	mov    %esi,%eax
 16b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16e:	5b                   	pop    %ebx
 16f:	5e                   	pop    %esi
 170:	5f                   	pop    %edi
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    

00000173 <stat>:

int
stat(const char *n, struct stat *st)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	6a 00                	push   $0x0
 17d:	ff 75 08             	push   0x8(%ebp)
 180:	e8 e4 00 00 00       	call   269 <open>
  if(fd < 0)
 185:	83 c4 10             	add    $0x10,%esp
 188:	85 c0                	test   %eax,%eax
 18a:	78 24                	js     1b0 <stat+0x3d>
 18c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	ff 75 0c             	push   0xc(%ebp)
 194:	50                   	push   %eax
 195:	e8 e7 00 00 00       	call   281 <fstat>
 19a:	89 c6                	mov    %eax,%esi
  close(fd);
 19c:	89 1c 24             	mov    %ebx,(%esp)
 19f:	e8 ad 00 00 00       	call   251 <close>
  return r;
 1a4:	83 c4 10             	add    $0x10,%esp
}
 1a7:	89 f0                	mov    %esi,%eax
 1a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    
    return -1;
 1b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b5:	eb f0                	jmp    1a7 <stat+0x34>

000001b7 <atoi>:

int
atoi(const char *s)
{
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	53                   	push   %ebx
 1bb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	0f b6 02             	movzbl (%edx),%eax
 1c1:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1c4:	80 f9 09             	cmp    $0x9,%cl
 1c7:	77 24                	ja     1ed <atoi+0x36>
  n = 0;
 1c9:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1ce:	83 c2 01             	add    $0x1,%edx
 1d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1d4:	0f be c0             	movsbl %al,%eax
 1d7:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1db:	0f b6 02             	movzbl (%edx),%eax
 1de:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e1:	80 fb 09             	cmp    $0x9,%bl
 1e4:	76 e8                	jbe    1ce <atoi+0x17>
  return n;
}
 1e6:	89 c8                	mov    %ecx,%eax
 1e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    
  n = 0;
 1ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1f2:	eb f2                	jmp    1e6 <atoi+0x2f>

000001f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	56                   	push   %esi
 1f8:	53                   	push   %ebx
 1f9:	8b 75 08             	mov    0x8(%ebp),%esi
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	85 db                	test   %ebx,%ebx
 204:	7e 15                	jle    21b <memmove+0x27>
 206:	01 f3                	add    %esi,%ebx
  dst = vdst;
 208:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 20a:	83 c2 01             	add    $0x1,%edx
 20d:	83 c0 01             	add    $0x1,%eax
 210:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 214:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 217:	39 c3                	cmp    %eax,%ebx
 219:	75 ef                	jne    20a <memmove+0x16>
  return vdst;
}
 21b:	89 f0                	mov    %esi,%eax
 21d:	5b                   	pop    %ebx
 21e:	5e                   	pop    %esi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    

00000221 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 221:	b8 01 00 00 00       	mov    $0x1,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <exit>:
SYSCALL(exit)
 229:	b8 02 00 00 00       	mov    $0x2,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <wait>:
SYSCALL(wait)
 231:	b8 03 00 00 00       	mov    $0x3,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <pipe>:
SYSCALL(pipe)
 239:	b8 04 00 00 00       	mov    $0x4,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <read>:
SYSCALL(read)
 241:	b8 05 00 00 00       	mov    $0x5,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <write>:
SYSCALL(write)
 249:	b8 10 00 00 00       	mov    $0x10,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <close>:
SYSCALL(close)
 251:	b8 15 00 00 00       	mov    $0x15,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <kill>:
SYSCALL(kill)
 259:	b8 06 00 00 00       	mov    $0x6,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <exec>:
SYSCALL(exec)
 261:	b8 07 00 00 00       	mov    $0x7,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <open>:
SYSCALL(open)
 269:	b8 0f 00 00 00       	mov    $0xf,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <mknod>:
SYSCALL(mknod)
 271:	b8 11 00 00 00       	mov    $0x11,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <unlink>:
SYSCALL(unlink)
 279:	b8 12 00 00 00       	mov    $0x12,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <fstat>:
SYSCALL(fstat)
 281:	b8 08 00 00 00       	mov    $0x8,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <link>:
SYSCALL(link)
 289:	b8 13 00 00 00       	mov    $0x13,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <mkdir>:
SYSCALL(mkdir)
 291:	b8 14 00 00 00       	mov    $0x14,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <chdir>:
SYSCALL(chdir)
 299:	b8 09 00 00 00       	mov    $0x9,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <dup>:
SYSCALL(dup)
 2a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <getpid>:
SYSCALL(getpid)
 2a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <sbrk>:
SYSCALL(sbrk)
 2b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <sleep>:
SYSCALL(sleep)
 2b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <uptime>:
SYSCALL(uptime)
 2c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <slabtest>:
SYSCALL(slabtest)
 2c9:	b8 16 00 00 00       	mov    $0x16,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <ps>:
SYSCALL(ps)
 2d1:	b8 17 00 00 00       	mov    $0x17,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	57                   	push   %edi
 2dd:	56                   	push   %esi
 2de:	53                   	push   %ebx
 2df:	83 ec 3c             	sub    $0x3c,%esp
 2e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2e5:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2eb:	74 79                	je     366 <printint+0x8d>
 2ed:	85 d2                	test   %edx,%edx
 2ef:	79 75                	jns    366 <printint+0x8d>
    neg = 1;
    x = -xx;
 2f1:	89 d1                	mov    %edx,%ecx
 2f3:	f7 d9                	neg    %ecx
    neg = 1;
 2f5:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 301:	89 df                	mov    %ebx,%edi
 303:	83 c3 01             	add    $0x1,%ebx
 306:	89 c8                	mov    %ecx,%eax
 308:	ba 00 00 00 00       	mov    $0x0,%edx
 30d:	f7 f6                	div    %esi
 30f:	0f b6 92 d0 06 00 00 	movzbl 0x6d0(%edx),%edx
 316:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 31a:	89 ca                	mov    %ecx,%edx
 31c:	89 c1                	mov    %eax,%ecx
 31e:	39 d6                	cmp    %edx,%esi
 320:	76 df                	jbe    301 <printint+0x28>
  if(neg)
 322:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 326:	74 08                	je     330 <printint+0x57>
    buf[i++] = '-';
 328:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32d:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 330:	85 db                	test   %ebx,%ebx
 332:	7e 2a                	jle    35e <printint+0x85>
 334:	8d 7d d8             	lea    -0x28(%ebp),%edi
 337:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 33b:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 33e:	0f b6 03             	movzbl (%ebx),%eax
 341:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 344:	83 ec 04             	sub    $0x4,%esp
 347:	6a 01                	push   $0x1
 349:	56                   	push   %esi
 34a:	ff 75 c4             	push   -0x3c(%ebp)
 34d:	e8 f7 fe ff ff       	call   249 <write>
  while(--i >= 0)
 352:	89 d8                	mov    %ebx,%eax
 354:	83 eb 01             	sub    $0x1,%ebx
 357:	83 c4 10             	add    $0x10,%esp
 35a:	39 f8                	cmp    %edi,%eax
 35c:	75 e0                	jne    33e <printint+0x65>
}
 35e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 361:	5b                   	pop    %ebx
 362:	5e                   	pop    %esi
 363:	5f                   	pop    %edi
 364:	5d                   	pop    %ebp
 365:	c3                   	ret    
    x = xx;
 366:	89 d1                	mov    %edx,%ecx
  neg = 0;
 368:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 36f:	eb 8b                	jmp    2fc <printint+0x23>

00000371 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	56                   	push   %esi
 376:	53                   	push   %ebx
 377:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 37a:	8b 75 0c             	mov    0xc(%ebp),%esi
 37d:	0f b6 1e             	movzbl (%esi),%ebx
 380:	84 db                	test   %bl,%bl
 382:	0f 84 9f 01 00 00    	je     527 <printf+0x1b6>
 388:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 38b:	8d 45 10             	lea    0x10(%ebp),%eax
 38e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 391:	bf 00 00 00 00       	mov    $0x0,%edi
 396:	eb 2d                	jmp    3c5 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 398:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 39b:	83 ec 04             	sub    $0x4,%esp
 39e:	6a 01                	push   $0x1
 3a0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a3:	50                   	push   %eax
 3a4:	ff 75 08             	push   0x8(%ebp)
 3a7:	e8 9d fe ff ff       	call   249 <write>
        putc(fd, c);
 3ac:	83 c4 10             	add    $0x10,%esp
 3af:	eb 05                	jmp    3b6 <printf+0x45>
      }
    } else if(state == '%'){
 3b1:	83 ff 25             	cmp    $0x25,%edi
 3b4:	74 1f                	je     3d5 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 3b6:	83 c6 01             	add    $0x1,%esi
 3b9:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3bd:	84 db                	test   %bl,%bl
 3bf:	0f 84 62 01 00 00    	je     527 <printf+0x1b6>
    c = fmt[i] & 0xff;
 3c5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c8:	85 ff                	test   %edi,%edi
 3ca:	75 e5                	jne    3b1 <printf+0x40>
      if(c == '%'){
 3cc:	83 f8 25             	cmp    $0x25,%eax
 3cf:	75 c7                	jne    398 <printf+0x27>
        state = '%';
 3d1:	89 c7                	mov    %eax,%edi
 3d3:	eb e1                	jmp    3b6 <printf+0x45>
      if(c == 'd'){
 3d5:	83 f8 25             	cmp    $0x25,%eax
 3d8:	0f 84 f2 00 00 00    	je     4d0 <printf+0x15f>
 3de:	8d 50 9d             	lea    -0x63(%eax),%edx
 3e1:	83 fa 15             	cmp    $0x15,%edx
 3e4:	0f 87 07 01 00 00    	ja     4f1 <printf+0x180>
 3ea:	0f 87 01 01 00 00    	ja     4f1 <printf+0x180>
 3f0:	ff 24 95 78 06 00 00 	jmp    *0x678(,%edx,4)
        printint(fd, *ap, 10, 1);
 3f7:	83 ec 0c             	sub    $0xc,%esp
 3fa:	6a 01                	push   $0x1
 3fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 401:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 404:	8b 17                	mov    (%edi),%edx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	e8 cb fe ff ff       	call   2d9 <printint>
        ap++;
 40e:	89 f8                	mov    %edi,%eax
 410:	83 c0 04             	add    $0x4,%eax
 413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 416:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 419:	bf 00 00 00 00       	mov    $0x0,%edi
 41e:	eb 96                	jmp    3b6 <printf+0x45>
        printint(fd, *ap, 16, 0);
 420:	83 ec 0c             	sub    $0xc,%esp
 423:	6a 00                	push   $0x0
 425:	b9 10 00 00 00       	mov    $0x10,%ecx
 42a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 42d:	8b 17                	mov    (%edi),%edx
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	e8 a2 fe ff ff       	call   2d9 <printint>
        ap++;
 437:	89 f8                	mov    %edi,%eax
 439:	83 c0 04             	add    $0x4,%eax
 43c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 43f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 442:	bf 00 00 00 00       	mov    $0x0,%edi
 447:	e9 6a ff ff ff       	jmp    3b6 <printf+0x45>
        s = (char*)*ap;
 44c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 44f:	8b 01                	mov    (%ecx),%eax
        ap++;
 451:	83 c1 04             	add    $0x4,%ecx
 454:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 457:	85 c0                	test   %eax,%eax
 459:	74 13                	je     46e <printf+0xfd>
        s = (char*)*ap;
 45b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 45d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 460:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 465:	84 c0                	test   %al,%al
 467:	75 0f                	jne    478 <printf+0x107>
 469:	e9 48 ff ff ff       	jmp    3b6 <printf+0x45>
          s = "(null)";
 46e:	bb 71 06 00 00       	mov    $0x671,%ebx
        while(*s != 0){
 473:	b8 28 00 00 00       	mov    $0x28,%eax
 478:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 47b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 47e:	83 ec 04             	sub    $0x4,%esp
 481:	6a 01                	push   $0x1
 483:	8d 45 e7             	lea    -0x19(%ebp),%eax
 486:	50                   	push   %eax
 487:	57                   	push   %edi
 488:	e8 bc fd ff ff       	call   249 <write>
          s++;
 48d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 490:	0f b6 03             	movzbl (%ebx),%eax
 493:	83 c4 10             	add    $0x10,%esp
 496:	84 c0                	test   %al,%al
 498:	75 e1                	jne    47b <printf+0x10a>
      state = 0;
 49a:	bf 00 00 00 00       	mov    $0x0,%edi
 49f:	e9 12 ff ff ff       	jmp    3b6 <printf+0x45>
        putc(fd, *ap);
 4a4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a7:	8b 07                	mov    (%edi),%eax
 4a9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ac:	83 ec 04             	sub    $0x4,%esp
 4af:	6a 01                	push   $0x1
 4b1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b4:	50                   	push   %eax
 4b5:	ff 75 08             	push   0x8(%ebp)
 4b8:	e8 8c fd ff ff       	call   249 <write>
        ap++;
 4bd:	83 c7 04             	add    $0x4,%edi
 4c0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4c3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c6:	bf 00 00 00 00       	mov    $0x0,%edi
 4cb:	e9 e6 fe ff ff       	jmp    3b6 <printf+0x45>
        putc(fd, c);
 4d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4d3:	83 ec 04             	sub    $0x4,%esp
 4d6:	6a 01                	push   $0x1
 4d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	push   0x8(%ebp)
 4df:	e8 65 fd ff ff       	call   249 <write>
 4e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e7:	bf 00 00 00 00       	mov    $0x0,%edi
 4ec:	e9 c5 fe ff ff       	jmp    3b6 <printf+0x45>
        putc(fd, '%');
 4f1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4f5:	83 ec 04             	sub    $0x4,%esp
 4f8:	6a 01                	push   $0x1
 4fa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	push   0x8(%ebp)
 501:	e8 43 fd ff ff       	call   249 <write>
        putc(fd, c);
 506:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 509:	83 c4 0c             	add    $0xc,%esp
 50c:	6a 01                	push   $0x1
 50e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 511:	50                   	push   %eax
 512:	ff 75 08             	push   0x8(%ebp)
 515:	e8 2f fd ff ff       	call   249 <write>
        putc(fd, c);
 51a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51d:	bf 00 00 00 00       	mov    $0x0,%edi
 522:	e9 8f fe ff ff       	jmp    3b6 <printf+0x45>
    }
  }
}
 527:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52a:	5b                   	pop    %ebx
 52b:	5e                   	pop    %esi
 52c:	5f                   	pop    %edi
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    

0000052f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	57                   	push   %edi
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
 535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 538:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 53b:	a1 44 09 00 00       	mov    0x944,%eax
 540:	eb 0c                	jmp    54e <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 542:	8b 10                	mov    (%eax),%edx
 544:	39 c2                	cmp    %eax,%edx
 546:	77 04                	ja     54c <free+0x1d>
 548:	39 ca                	cmp    %ecx,%edx
 54a:	77 10                	ja     55c <free+0x2d>
{
 54c:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 54e:	39 c8                	cmp    %ecx,%eax
 550:	73 f0                	jae    542 <free+0x13>
 552:	8b 10                	mov    (%eax),%edx
 554:	39 ca                	cmp    %ecx,%edx
 556:	77 04                	ja     55c <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 558:	39 c2                	cmp    %eax,%edx
 55a:	77 f0                	ja     54c <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 55c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55f:	8b 10                	mov    (%eax),%edx
 561:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 564:	39 fa                	cmp    %edi,%edx
 566:	74 19                	je     581 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 568:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 56b:	8b 50 04             	mov    0x4(%eax),%edx
 56e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 571:	39 f1                	cmp    %esi,%ecx
 573:	74 18                	je     58d <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 575:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 577:	a3 44 09 00 00       	mov    %eax,0x944
}
 57c:	5b                   	pop    %ebx
 57d:	5e                   	pop    %esi
 57e:	5f                   	pop    %edi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 581:	03 72 04             	add    0x4(%edx),%esi
 584:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 587:	8b 10                	mov    (%eax),%edx
 589:	8b 12                	mov    (%edx),%edx
 58b:	eb db                	jmp    568 <free+0x39>
    p->s.size += bp->s.size;
 58d:	03 53 fc             	add    -0x4(%ebx),%edx
 590:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 593:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 596:	eb dd                	jmp    575 <free+0x46>

00000598 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	57                   	push   %edi
 59c:	56                   	push   %esi
 59d:	53                   	push   %ebx
 59e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	8d 58 07             	lea    0x7(%eax),%ebx
 5a7:	c1 eb 03             	shr    $0x3,%ebx
 5aa:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ad:	8b 15 44 09 00 00    	mov    0x944,%edx
 5b3:	85 d2                	test   %edx,%edx
 5b5:	74 1c                	je     5d3 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b9:	8b 48 04             	mov    0x4(%eax),%ecx
 5bc:	39 cb                	cmp    %ecx,%ebx
 5be:	76 38                	jbe    5f8 <malloc+0x60>
 5c0:	be 00 10 00 00       	mov    $0x1000,%esi
 5c5:	39 f3                	cmp    %esi,%ebx
 5c7:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5ca:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5d1:	eb 72                	jmp    645 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 5d3:	c7 05 44 09 00 00 48 	movl   $0x948,0x944
 5da:	09 00 00 
 5dd:	c7 05 48 09 00 00 48 	movl   $0x948,0x948
 5e4:	09 00 00 
    base.s.size = 0;
 5e7:	c7 05 4c 09 00 00 00 	movl   $0x0,0x94c
 5ee:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	b8 48 09 00 00       	mov    $0x948,%eax
 5f6:	eb c8                	jmp    5c0 <malloc+0x28>
      if(p->s.size == nunits)
 5f8:	39 cb                	cmp    %ecx,%ebx
 5fa:	74 1e                	je     61a <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5fc:	29 d9                	sub    %ebx,%ecx
 5fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 601:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 604:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 607:	89 15 44 09 00 00    	mov    %edx,0x944
      return (void*)(p + 1);
 60d:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 610:	89 d0                	mov    %edx,%eax
 612:	8d 65 f4             	lea    -0xc(%ebp),%esp
 615:	5b                   	pop    %ebx
 616:	5e                   	pop    %esi
 617:	5f                   	pop    %edi
 618:	5d                   	pop    %ebp
 619:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 61a:	8b 08                	mov    (%eax),%ecx
 61c:	89 0a                	mov    %ecx,(%edx)
 61e:	eb e7                	jmp    607 <malloc+0x6f>
  hp->s.size = nu;
 620:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	83 c0 08             	add    $0x8,%eax
 629:	50                   	push   %eax
 62a:	e8 00 ff ff ff       	call   52f <free>
  return freep;
 62f:	8b 15 44 09 00 00    	mov    0x944,%edx
      if((p = morecore(nunits)) == 0)
 635:	83 c4 10             	add    $0x10,%esp
 638:	85 d2                	test   %edx,%edx
 63a:	74 d4                	je     610 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63e:	8b 48 04             	mov    0x4(%eax),%ecx
 641:	39 d9                	cmp    %ebx,%ecx
 643:	73 b3                	jae    5f8 <malloc+0x60>
    if(p == freep)
 645:	89 c2                	mov    %eax,%edx
 647:	39 05 44 09 00 00    	cmp    %eax,0x944
 64d:	75 ed                	jne    63c <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 64f:	83 ec 0c             	sub    $0xc,%esp
 652:	57                   	push   %edi
 653:	e8 59 fc ff ff       	call   2b1 <sbrk>
  if(p == (char*)-1)
 658:	83 c4 10             	add    $0x10,%esp
 65b:	83 f8 ff             	cmp    $0xffffffff,%eax
 65e:	75 c0                	jne    620 <malloc+0x88>
        return 0;
 660:	ba 00 00 00 00       	mov    $0x0,%edx
 665:	eb a9                	jmp    610 <malloc+0x78>
