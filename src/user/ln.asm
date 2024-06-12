
user/_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 64 06 00 00       	push   $0x664
  1f:	6a 02                	push   $0x2
  21:	e8 46 03 00 00       	call   36c <printf>
    exit();
  26:	e8 f9 01 00 00       	call   224 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	push   0x8(%ebx)
  31:	ff 73 04             	push   0x4(%ebx)
  34:	e8 4b 02 00 00       	call   284 <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 df 01 00 00       	call   224 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	push   0x8(%ebx)
  48:	ff 73 04             	push   0x4(%ebx)
  4b:	68 77 06 00 00       	push   $0x677
  50:	6a 02                	push   $0x2
  52:	e8 15 03 00 00       	call   36c <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	b8 00 00 00 00       	mov    $0x0,%eax
  6b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  6f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  72:	83 c0 01             	add    $0x1,%eax
  75:	84 d2                	test   %dl,%dl
  77:	75 f2                	jne    6b <strcpy+0xf>
    ;
  return os;
}
  79:	89 c8                	mov    %ecx,%eax
  7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7e:	c9                   	leave  
  7f:	c3                   	ret    

00000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  86:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  89:	0f b6 01             	movzbl (%ecx),%eax
  8c:	84 c0                	test   %al,%al
  8e:	74 11                	je     a1 <strcmp+0x21>
  90:	38 02                	cmp    %al,(%edx)
  92:	75 0d                	jne    a1 <strcmp+0x21>
    p++, q++;
  94:	83 c1 01             	add    $0x1,%ecx
  97:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  9a:	0f b6 01             	movzbl (%ecx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 ef                	jne    90 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  a1:	0f b6 c0             	movzbl %al,%eax
  a4:	0f b6 12             	movzbl (%edx),%edx
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strlen>:

uint
strlen(const char *s)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b1:	80 3a 00             	cmpb   $0x0,(%edx)
  b4:	74 14                	je     ca <strlen+0x1f>
  b6:	b8 00 00 00 00       	mov    $0x0,%eax
  bb:	83 c0 01             	add    $0x1,%eax
  be:	89 c1                	mov    %eax,%ecx
  c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c4:	75 f5                	jne    bb <strlen+0x10>
    ;
  return n;
}
  c6:	89 c8                	mov    %ecx,%eax
  c8:	5d                   	pop    %ebp
  c9:	c3                   	ret    
  for(n = 0; s[n]; n++)
  ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  cf:	eb f5                	jmp    c6 <strlen+0x1b>

000000d1 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	57                   	push   %edi
  d5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d8:	89 d7                	mov    %edx,%edi
  da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	fc                   	cld    
  e1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e3:	89 d0                	mov    %edx,%eax
  e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  e8:	c9                   	leave  
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f4:	0f b6 10             	movzbl (%eax),%edx
  f7:	84 d2                	test   %dl,%dl
  f9:	74 15                	je     110 <strchr+0x26>
    if(*s == c)
  fb:	38 d1                	cmp    %dl,%cl
  fd:	74 0f                	je     10e <strchr+0x24>
  for(; *s; s++)
  ff:	83 c0 01             	add    $0x1,%eax
 102:	0f b6 10             	movzbl (%eax),%edx
 105:	84 d2                	test   %dl,%dl
 107:	75 f2                	jne    fb <strchr+0x11>
      return (char*)s;
  return 0;
 109:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10e:	5d                   	pop    %ebp
 10f:	c3                   	ret    
  return 0;
 110:	b8 00 00 00 00       	mov    $0x0,%eax
 115:	eb f7                	jmp    10e <strchr+0x24>

00000117 <gets>:

char*
gets(char *buf, int max)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	56                   	push   %esi
 11c:	53                   	push   %ebx
 11d:	83 ec 2c             	sub    $0x2c,%esp
 120:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 123:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 128:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12b:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 12e:	83 c3 01             	add    $0x1,%ebx
 131:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 134:	7d 27                	jge    15d <gets+0x46>
    cc = read(0, &c, 1);
 136:	83 ec 04             	sub    $0x4,%esp
 139:	6a 01                	push   $0x1
 13b:	57                   	push   %edi
 13c:	6a 00                	push   $0x0
 13e:	e8 f9 00 00 00       	call   23c <read>
    if(cc < 1)
 143:	83 c4 10             	add    $0x10,%esp
 146:	85 c0                	test   %eax,%eax
 148:	7e 13                	jle    15d <gets+0x46>
      break;
    buf[i++] = c;
 14a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14e:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 152:	3c 0a                	cmp    $0xa,%al
 154:	74 04                	je     15a <gets+0x43>
 156:	3c 0d                	cmp    $0xd,%al
 158:	75 d1                	jne    12b <gets+0x14>
  for(i=0; i+1 < max; ){
 15a:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 15d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 160:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 164:	89 f0                	mov    %esi,%eax
 166:	8d 65 f4             	lea    -0xc(%ebp),%esp
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret    

0000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	push   0x8(%ebp)
 17b:	e8 e4 00 00 00       	call   264 <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x3d>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	push   0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 e7 00 00 00       	call   27c <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 ad 00 00 00       	call   24c <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x34>

000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b9:	0f b6 02             	movzbl (%edx),%eax
 1bc:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1bf:	80 f9 09             	cmp    $0x9,%cl
 1c2:	77 24                	ja     1e8 <atoi+0x36>
  n = 0;
 1c4:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1c9:	83 c2 01             	add    $0x1,%edx
 1cc:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1cf:	0f be c0             	movsbl %al,%eax
 1d2:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1d6:	0f b6 02             	movzbl (%edx),%eax
 1d9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1dc:	80 fb 09             	cmp    $0x9,%bl
 1df:	76 e8                	jbe    1c9 <atoi+0x17>
  return n;
}
 1e1:	89 c8                	mov    %ecx,%eax
 1e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    
  n = 0;
 1e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1ed:	eb f2                	jmp    1e1 <atoi+0x2f>

000001ef <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	56                   	push   %esi
 1f3:	53                   	push   %ebx
 1f4:	8b 75 08             	mov    0x8(%ebp),%esi
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fd:	85 db                	test   %ebx,%ebx
 1ff:	7e 15                	jle    216 <memmove+0x27>
 201:	01 f3                	add    %esi,%ebx
  dst = vdst;
 203:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 205:	83 c2 01             	add    $0x1,%edx
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 20f:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 212:	39 c3                	cmp    %eax,%ebx
 214:	75 ef                	jne    205 <memmove+0x16>
  return vdst;
}
 216:	89 f0                	mov    %esi,%eax
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    

0000021c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21c:	b8 01 00 00 00       	mov    $0x1,%eax
 221:	cd 40                	int    $0x40
 223:	c3                   	ret    

00000224 <exit>:
SYSCALL(exit)
 224:	b8 02 00 00 00       	mov    $0x2,%eax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret    

0000022c <wait>:
SYSCALL(wait)
 22c:	b8 03 00 00 00       	mov    $0x3,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <pipe>:
SYSCALL(pipe)
 234:	b8 04 00 00 00       	mov    $0x4,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <read>:
SYSCALL(read)
 23c:	b8 05 00 00 00       	mov    $0x5,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <write>:
SYSCALL(write)
 244:	b8 10 00 00 00       	mov    $0x10,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <close>:
SYSCALL(close)
 24c:	b8 15 00 00 00       	mov    $0x15,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <kill>:
SYSCALL(kill)
 254:	b8 06 00 00 00       	mov    $0x6,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <exec>:
SYSCALL(exec)
 25c:	b8 07 00 00 00       	mov    $0x7,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <open>:
SYSCALL(open)
 264:	b8 0f 00 00 00       	mov    $0xf,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <mknod>:
SYSCALL(mknod)
 26c:	b8 11 00 00 00       	mov    $0x11,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <unlink>:
SYSCALL(unlink)
 274:	b8 12 00 00 00       	mov    $0x12,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <fstat>:
SYSCALL(fstat)
 27c:	b8 08 00 00 00       	mov    $0x8,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <link>:
SYSCALL(link)
 284:	b8 13 00 00 00       	mov    $0x13,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <mkdir>:
SYSCALL(mkdir)
 28c:	b8 14 00 00 00       	mov    $0x14,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <chdir>:
SYSCALL(chdir)
 294:	b8 09 00 00 00       	mov    $0x9,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <dup>:
SYSCALL(dup)
 29c:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <getpid>:
SYSCALL(getpid)
 2a4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <sbrk>:
SYSCALL(sbrk)
 2ac:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <sleep>:
SYSCALL(sleep)
 2b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <uptime>:
SYSCALL(uptime)
 2bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <slabtest>:
SYSCALL(slabtest)
 2c4:	b8 16 00 00 00       	mov    $0x16,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <ps>:
SYSCALL(ps)
 2cc:	b8 17 00 00 00       	mov    $0x17,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	57                   	push   %edi
 2d8:	56                   	push   %esi
 2d9:	53                   	push   %ebx
 2da:	83 ec 3c             	sub    $0x3c,%esp
 2dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2e0:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e6:	74 79                	je     361 <printint+0x8d>
 2e8:	85 d2                	test   %edx,%edx
 2ea:	79 75                	jns    361 <printint+0x8d>
    neg = 1;
    x = -xx;
 2ec:	89 d1                	mov    %edx,%ecx
 2ee:	f7 d9                	neg    %ecx
    neg = 1;
 2f0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2fc:	89 df                	mov    %ebx,%edi
 2fe:	83 c3 01             	add    $0x1,%ebx
 301:	89 c8                	mov    %ecx,%eax
 303:	ba 00 00 00 00       	mov    $0x0,%edx
 308:	f7 f6                	div    %esi
 30a:	0f b6 92 ec 06 00 00 	movzbl 0x6ec(%edx),%edx
 311:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 315:	89 ca                	mov    %ecx,%edx
 317:	89 c1                	mov    %eax,%ecx
 319:	39 d6                	cmp    %edx,%esi
 31b:	76 df                	jbe    2fc <printint+0x28>
  if(neg)
 31d:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 321:	74 08                	je     32b <printint+0x57>
    buf[i++] = '-';
 323:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 328:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 32b:	85 db                	test   %ebx,%ebx
 32d:	7e 2a                	jle    359 <printint+0x85>
 32f:	8d 7d d8             	lea    -0x28(%ebp),%edi
 332:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 336:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 339:	0f b6 03             	movzbl (%ebx),%eax
 33c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 33f:	83 ec 04             	sub    $0x4,%esp
 342:	6a 01                	push   $0x1
 344:	56                   	push   %esi
 345:	ff 75 c4             	push   -0x3c(%ebp)
 348:	e8 f7 fe ff ff       	call   244 <write>
  while(--i >= 0)
 34d:	89 d8                	mov    %ebx,%eax
 34f:	83 eb 01             	sub    $0x1,%ebx
 352:	83 c4 10             	add    $0x10,%esp
 355:	39 f8                	cmp    %edi,%eax
 357:	75 e0                	jne    339 <printint+0x65>
}
 359:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5f                   	pop    %edi
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
    x = xx;
 361:	89 d1                	mov    %edx,%ecx
  neg = 0;
 363:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 36a:	eb 8b                	jmp    2f7 <printint+0x23>

0000036c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	57                   	push   %edi
 370:	56                   	push   %esi
 371:	53                   	push   %ebx
 372:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 375:	8b 75 0c             	mov    0xc(%ebp),%esi
 378:	0f b6 1e             	movzbl (%esi),%ebx
 37b:	84 db                	test   %bl,%bl
 37d:	0f 84 9f 01 00 00    	je     522 <printf+0x1b6>
 383:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 386:	8d 45 10             	lea    0x10(%ebp),%eax
 389:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 38c:	bf 00 00 00 00       	mov    $0x0,%edi
 391:	eb 2d                	jmp    3c0 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 393:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 396:	83 ec 04             	sub    $0x4,%esp
 399:	6a 01                	push   $0x1
 39b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39e:	50                   	push   %eax
 39f:	ff 75 08             	push   0x8(%ebp)
 3a2:	e8 9d fe ff ff       	call   244 <write>
        putc(fd, c);
 3a7:	83 c4 10             	add    $0x10,%esp
 3aa:	eb 05                	jmp    3b1 <printf+0x45>
      }
    } else if(state == '%'){
 3ac:	83 ff 25             	cmp    $0x25,%edi
 3af:	74 1f                	je     3d0 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 3b1:	83 c6 01             	add    $0x1,%esi
 3b4:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3b8:	84 db                	test   %bl,%bl
 3ba:	0f 84 62 01 00 00    	je     522 <printf+0x1b6>
    c = fmt[i] & 0xff;
 3c0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c3:	85 ff                	test   %edi,%edi
 3c5:	75 e5                	jne    3ac <printf+0x40>
      if(c == '%'){
 3c7:	83 f8 25             	cmp    $0x25,%eax
 3ca:	75 c7                	jne    393 <printf+0x27>
        state = '%';
 3cc:	89 c7                	mov    %eax,%edi
 3ce:	eb e1                	jmp    3b1 <printf+0x45>
      if(c == 'd'){
 3d0:	83 f8 25             	cmp    $0x25,%eax
 3d3:	0f 84 f2 00 00 00    	je     4cb <printf+0x15f>
 3d9:	8d 50 9d             	lea    -0x63(%eax),%edx
 3dc:	83 fa 15             	cmp    $0x15,%edx
 3df:	0f 87 07 01 00 00    	ja     4ec <printf+0x180>
 3e5:	0f 87 01 01 00 00    	ja     4ec <printf+0x180>
 3eb:	ff 24 95 94 06 00 00 	jmp    *0x694(,%edx,4)
        printint(fd, *ap, 10, 1);
 3f2:	83 ec 0c             	sub    $0xc,%esp
 3f5:	6a 01                	push   $0x1
 3f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3fc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3ff:	8b 17                	mov    (%edi),%edx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	e8 cb fe ff ff       	call   2d4 <printint>
        ap++;
 409:	89 f8                	mov    %edi,%eax
 40b:	83 c0 04             	add    $0x4,%eax
 40e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 411:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 414:	bf 00 00 00 00       	mov    $0x0,%edi
 419:	eb 96                	jmp    3b1 <printf+0x45>
        printint(fd, *ap, 16, 0);
 41b:	83 ec 0c             	sub    $0xc,%esp
 41e:	6a 00                	push   $0x0
 420:	b9 10 00 00 00       	mov    $0x10,%ecx
 425:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 428:	8b 17                	mov    (%edi),%edx
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	e8 a2 fe ff ff       	call   2d4 <printint>
        ap++;
 432:	89 f8                	mov    %edi,%eax
 434:	83 c0 04             	add    $0x4,%eax
 437:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 43a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 43d:	bf 00 00 00 00       	mov    $0x0,%edi
 442:	e9 6a ff ff ff       	jmp    3b1 <printf+0x45>
        s = (char*)*ap;
 447:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 44a:	8b 01                	mov    (%ecx),%eax
        ap++;
 44c:	83 c1 04             	add    $0x4,%ecx
 44f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 452:	85 c0                	test   %eax,%eax
 454:	74 13                	je     469 <printf+0xfd>
        s = (char*)*ap;
 456:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 458:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 45b:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 460:	84 c0                	test   %al,%al
 462:	75 0f                	jne    473 <printf+0x107>
 464:	e9 48 ff ff ff       	jmp    3b1 <printf+0x45>
          s = "(null)";
 469:	bb 8b 06 00 00       	mov    $0x68b,%ebx
        while(*s != 0){
 46e:	b8 28 00 00 00       	mov    $0x28,%eax
 473:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 476:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 479:	83 ec 04             	sub    $0x4,%esp
 47c:	6a 01                	push   $0x1
 47e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 481:	50                   	push   %eax
 482:	57                   	push   %edi
 483:	e8 bc fd ff ff       	call   244 <write>
          s++;
 488:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 48b:	0f b6 03             	movzbl (%ebx),%eax
 48e:	83 c4 10             	add    $0x10,%esp
 491:	84 c0                	test   %al,%al
 493:	75 e1                	jne    476 <printf+0x10a>
      state = 0;
 495:	bf 00 00 00 00       	mov    $0x0,%edi
 49a:	e9 12 ff ff ff       	jmp    3b1 <printf+0x45>
        putc(fd, *ap);
 49f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a2:	8b 07                	mov    (%edi),%eax
 4a4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a7:	83 ec 04             	sub    $0x4,%esp
 4aa:	6a 01                	push   $0x1
 4ac:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4af:	50                   	push   %eax
 4b0:	ff 75 08             	push   0x8(%ebp)
 4b3:	e8 8c fd ff ff       	call   244 <write>
        ap++;
 4b8:	83 c7 04             	add    $0x4,%edi
 4bb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c1:	bf 00 00 00 00       	mov    $0x0,%edi
 4c6:	e9 e6 fe ff ff       	jmp    3b1 <printf+0x45>
        putc(fd, c);
 4cb:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4ce:	83 ec 04             	sub    $0x4,%esp
 4d1:	6a 01                	push   $0x1
 4d3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d6:	50                   	push   %eax
 4d7:	ff 75 08             	push   0x8(%ebp)
 4da:	e8 65 fd ff ff       	call   244 <write>
 4df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e2:	bf 00 00 00 00       	mov    $0x0,%edi
 4e7:	e9 c5 fe ff ff       	jmp    3b1 <printf+0x45>
        putc(fd, '%');
 4ec:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	6a 01                	push   $0x1
 4f5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f8:	50                   	push   %eax
 4f9:	ff 75 08             	push   0x8(%ebp)
 4fc:	e8 43 fd ff ff       	call   244 <write>
        putc(fd, c);
 501:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 504:	83 c4 0c             	add    $0xc,%esp
 507:	6a 01                	push   $0x1
 509:	8d 45 e7             	lea    -0x19(%ebp),%eax
 50c:	50                   	push   %eax
 50d:	ff 75 08             	push   0x8(%ebp)
 510:	e8 2f fd ff ff       	call   244 <write>
        putc(fd, c);
 515:	83 c4 10             	add    $0x10,%esp
      state = 0;
 518:	bf 00 00 00 00       	mov    $0x0,%edi
 51d:	e9 8f fe ff ff       	jmp    3b1 <printf+0x45>
    }
  }
}
 522:	8d 65 f4             	lea    -0xc(%ebp),%esp
 525:	5b                   	pop    %ebx
 526:	5e                   	pop    %esi
 527:	5f                   	pop    %edi
 528:	5d                   	pop    %ebp
 529:	c3                   	ret    

0000052a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 52a:	55                   	push   %ebp
 52b:	89 e5                	mov    %esp,%ebp
 52d:	57                   	push   %edi
 52e:	56                   	push   %esi
 52f:	53                   	push   %ebx
 530:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 533:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 536:	a1 58 09 00 00       	mov    0x958,%eax
 53b:	eb 0c                	jmp    549 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53d:	8b 10                	mov    (%eax),%edx
 53f:	39 c2                	cmp    %eax,%edx
 541:	77 04                	ja     547 <free+0x1d>
 543:	39 ca                	cmp    %ecx,%edx
 545:	77 10                	ja     557 <free+0x2d>
{
 547:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 549:	39 c8                	cmp    %ecx,%eax
 54b:	73 f0                	jae    53d <free+0x13>
 54d:	8b 10                	mov    (%eax),%edx
 54f:	39 ca                	cmp    %ecx,%edx
 551:	77 04                	ja     557 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 553:	39 c2                	cmp    %eax,%edx
 555:	77 f0                	ja     547 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 557:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55a:	8b 10                	mov    (%eax),%edx
 55c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55f:	39 fa                	cmp    %edi,%edx
 561:	74 19                	je     57c <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 563:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 566:	8b 50 04             	mov    0x4(%eax),%edx
 569:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56c:	39 f1                	cmp    %esi,%ecx
 56e:	74 18                	je     588 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 570:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 572:	a3 58 09 00 00       	mov    %eax,0x958
}
 577:	5b                   	pop    %ebx
 578:	5e                   	pop    %esi
 579:	5f                   	pop    %edi
 57a:	5d                   	pop    %ebp
 57b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 57c:	03 72 04             	add    0x4(%edx),%esi
 57f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 582:	8b 10                	mov    (%eax),%edx
 584:	8b 12                	mov    (%edx),%edx
 586:	eb db                	jmp    563 <free+0x39>
    p->s.size += bp->s.size;
 588:	03 53 fc             	add    -0x4(%ebx),%edx
 58b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 58e:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 591:	eb dd                	jmp    570 <free+0x46>

00000593 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 593:	55                   	push   %ebp
 594:	89 e5                	mov    %esp,%ebp
 596:	57                   	push   %edi
 597:	56                   	push   %esi
 598:	53                   	push   %ebx
 599:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	8d 58 07             	lea    0x7(%eax),%ebx
 5a2:	c1 eb 03             	shr    $0x3,%ebx
 5a5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a8:	8b 15 58 09 00 00    	mov    0x958,%edx
 5ae:	85 d2                	test   %edx,%edx
 5b0:	74 1c                	je     5ce <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b4:	8b 48 04             	mov    0x4(%eax),%ecx
 5b7:	39 cb                	cmp    %ecx,%ebx
 5b9:	76 38                	jbe    5f3 <malloc+0x60>
 5bb:	be 00 10 00 00       	mov    $0x1000,%esi
 5c0:	39 f3                	cmp    %esi,%ebx
 5c2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5c5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5cc:	eb 72                	jmp    640 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 5ce:	c7 05 58 09 00 00 5c 	movl   $0x95c,0x958
 5d5:	09 00 00 
 5d8:	c7 05 5c 09 00 00 5c 	movl   $0x95c,0x95c
 5df:	09 00 00 
    base.s.size = 0;
 5e2:	c7 05 60 09 00 00 00 	movl   $0x0,0x960
 5e9:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ec:	b8 5c 09 00 00       	mov    $0x95c,%eax
 5f1:	eb c8                	jmp    5bb <malloc+0x28>
      if(p->s.size == nunits)
 5f3:	39 cb                	cmp    %ecx,%ebx
 5f5:	74 1e                	je     615 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5f7:	29 d9                	sub    %ebx,%ecx
 5f9:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5fc:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5ff:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 602:	89 15 58 09 00 00    	mov    %edx,0x958
      return (void*)(p + 1);
 608:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 60b:	89 d0                	mov    %edx,%eax
 60d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 610:	5b                   	pop    %ebx
 611:	5e                   	pop    %esi
 612:	5f                   	pop    %edi
 613:	5d                   	pop    %ebp
 614:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 615:	8b 08                	mov    (%eax),%ecx
 617:	89 0a                	mov    %ecx,(%edx)
 619:	eb e7                	jmp    602 <malloc+0x6f>
  hp->s.size = nu;
 61b:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 61e:	83 ec 0c             	sub    $0xc,%esp
 621:	83 c0 08             	add    $0x8,%eax
 624:	50                   	push   %eax
 625:	e8 00 ff ff ff       	call   52a <free>
  return freep;
 62a:	8b 15 58 09 00 00    	mov    0x958,%edx
      if((p = morecore(nunits)) == 0)
 630:	83 c4 10             	add    $0x10,%esp
 633:	85 d2                	test   %edx,%edx
 635:	74 d4                	je     60b <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 637:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 639:	8b 48 04             	mov    0x4(%eax),%ecx
 63c:	39 d9                	cmp    %ebx,%ecx
 63e:	73 b3                	jae    5f3 <malloc+0x60>
    if(p == freep)
 640:	89 c2                	mov    %eax,%edx
 642:	39 05 58 09 00 00    	cmp    %eax,0x958
 648:	75 ed                	jne    637 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 64a:	83 ec 0c             	sub    $0xc,%esp
 64d:	57                   	push   %edi
 64e:	e8 59 fc ff ff       	call   2ac <sbrk>
  if(p == (char*)-1)
 653:	83 c4 10             	add    $0x10,%esp
 656:	83 f8 ff             	cmp    $0xffffffff,%eax
 659:	75 c0                	jne    61b <malloc+0x88>
        return 0;
 65b:	ba 00 00 00 00       	mov    $0x0,%edx
 660:	eb a9                	jmp    60b <malloc+0x78>
