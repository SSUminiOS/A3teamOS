
user/_mkdir:     file format elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  int i;

  if(argc < 2){
  19:	83 c3 04             	add    $0x4,%ebx
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  1c:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7e 20                	jle    46 <main+0x46>
    if(mkdir(argv[i]) < 0){
  26:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	ff 33                	push   (%ebx)
  2e:	e8 73 02 00 00       	call   2a6 <mkdir>
  33:	83 c4 10             	add    $0x10,%esp
  36:	85 c0                	test   %eax,%eax
  38:	78 20                	js     5a <main+0x5a>
  for(i = 1; i < argc; i++){
  3a:	83 c6 01             	add    $0x1,%esi
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	39 f7                	cmp    %esi,%edi
  42:	75 e2                	jne    26 <main+0x26>
  44:	eb 2b                	jmp    71 <main+0x71>
    printf(2, "Usage: mkdir files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 7c 06 00 00       	push   $0x67c
  4e:	6a 02                	push   $0x2
  50:	e8 31 03 00 00       	call   386 <printf>
    exit();
  55:	e8 e4 01 00 00       	call   23e <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  60:	ff 30                	push   (%eax)
  62:	68 93 06 00 00       	push   $0x693
  67:	6a 02                	push   $0x2
  69:	e8 18 03 00 00       	call   386 <printf>
      break;
  6e:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  71:	e8 c8 01 00 00       	call   23e <exit>

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	53                   	push   %ebx
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	b8 00 00 00 00       	mov    $0x0,%eax
  85:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  89:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8c:	83 c0 01             	add    $0x1,%eax
  8f:	84 d2                	test   %dl,%dl
  91:	75 f2                	jne    85 <strcpy+0xf>
    ;
  return os;
}
  93:	89 c8                	mov    %ecx,%eax
  95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  98:	c9                   	leave  
  99:	c3                   	ret    

0000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  a3:	0f b6 01             	movzbl (%ecx),%eax
  a6:	84 c0                	test   %al,%al
  a8:	74 11                	je     bb <strcmp+0x21>
  aa:	38 02                	cmp    %al,(%edx)
  ac:	75 0d                	jne    bb <strcmp+0x21>
    p++, q++;
  ae:	83 c1 01             	add    $0x1,%ecx
  b1:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b4:	0f b6 01             	movzbl (%ecx),%eax
  b7:	84 c0                	test   %al,%al
  b9:	75 ef                	jne    aa <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	29 d0                	sub    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(const char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  cb:	80 3a 00             	cmpb   $0x0,(%edx)
  ce:	74 14                	je     e4 <strlen+0x1f>
  d0:	b8 00 00 00 00       	mov    $0x0,%eax
  d5:	83 c0 01             	add    $0x1,%eax
  d8:	89 c1                	mov    %eax,%ecx
  da:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  de:	75 f5                	jne    d5 <strlen+0x10>
    ;
  return n;
}
  e0:	89 c8                	mov    %ecx,%eax
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  e9:	eb f5                	jmp    e0 <strlen+0x1b>

000000eb <memset>:

void*
memset(void *dst, int c, uint n)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	57                   	push   %edi
  ef:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f2:	89 d7                	mov    %edx,%edi
  f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	fc                   	cld    
  fb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fd:	89 d0                	mov    %edx,%eax
  ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10e:	0f b6 10             	movzbl (%eax),%edx
 111:	84 d2                	test   %dl,%dl
 113:	74 15                	je     12a <strchr+0x26>
    if(*s == c)
 115:	38 d1                	cmp    %dl,%cl
 117:	74 0f                	je     128 <strchr+0x24>
  for(; *s; s++)
 119:	83 c0 01             	add    $0x1,%eax
 11c:	0f b6 10             	movzbl (%eax),%edx
 11f:	84 d2                	test   %dl,%dl
 121:	75 f2                	jne    115 <strchr+0x11>
      return (char*)s;
  return 0;
 123:	b8 00 00 00 00       	mov    $0x0,%eax
}
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
 12f:	eb f7                	jmp    128 <strchr+0x24>

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	57                   	push   %edi
 135:	56                   	push   %esi
 136:	53                   	push   %ebx
 137:	83 ec 2c             	sub    $0x2c,%esp
 13a:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13d:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 142:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 145:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 148:	83 c3 01             	add    $0x1,%ebx
 14b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14e:	7d 27                	jge    177 <gets+0x46>
    cc = read(0, &c, 1);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	6a 01                	push   $0x1
 155:	57                   	push   %edi
 156:	6a 00                	push   $0x0
 158:	e8 f9 00 00 00       	call   256 <read>
    if(cc < 1)
 15d:	83 c4 10             	add    $0x10,%esp
 160:	85 c0                	test   %eax,%eax
 162:	7e 13                	jle    177 <gets+0x46>
      break;
    buf[i++] = c;
 164:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 168:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 16c:	3c 0a                	cmp    $0xa,%al
 16e:	74 04                	je     174 <gets+0x43>
 170:	3c 0d                	cmp    $0xd,%al
 172:	75 d1                	jne    145 <gets+0x14>
  for(i=0; i+1 < max; ){
 174:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 177:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 17a:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 17e:	89 f0                	mov    %esi,%eax
 180:	8d 65 f4             	lea    -0xc(%ebp),%esp
 183:	5b                   	pop    %ebx
 184:	5e                   	pop    %esi
 185:	5f                   	pop    %edi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    

00000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	56                   	push   %esi
 18c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	6a 00                	push   $0x0
 192:	ff 75 08             	push   0x8(%ebp)
 195:	e8 e4 00 00 00       	call   27e <open>
  if(fd < 0)
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	85 c0                	test   %eax,%eax
 19f:	78 24                	js     1c5 <stat+0x3d>
 1a1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	ff 75 0c             	push   0xc(%ebp)
 1a9:	50                   	push   %eax
 1aa:	e8 e7 00 00 00       	call   296 <fstat>
 1af:	89 c6                	mov    %eax,%esi
  close(fd);
 1b1:	89 1c 24             	mov    %ebx,(%esp)
 1b4:	e8 ad 00 00 00       	call   266 <close>
  return r;
 1b9:	83 c4 10             	add    $0x10,%esp
}
 1bc:	89 f0                	mov    %esi,%eax
 1be:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
    return -1;
 1c5:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ca:	eb f0                	jmp    1bc <stat+0x34>

000001cc <atoi>:

int
atoi(const char *s)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	53                   	push   %ebx
 1d0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d3:	0f b6 02             	movzbl (%edx),%eax
 1d6:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1d9:	80 f9 09             	cmp    $0x9,%cl
 1dc:	77 24                	ja     202 <atoi+0x36>
  n = 0;
 1de:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1e3:	83 c2 01             	add    $0x1,%edx
 1e6:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1e9:	0f be c0             	movsbl %al,%eax
 1ec:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1f0:	0f b6 02             	movzbl (%edx),%eax
 1f3:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1f6:	80 fb 09             	cmp    $0x9,%bl
 1f9:	76 e8                	jbe    1e3 <atoi+0x17>
  return n;
}
 1fb:	89 c8                	mov    %ecx,%eax
 1fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 200:	c9                   	leave  
 201:	c3                   	ret    
  n = 0;
 202:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 207:	eb f2                	jmp    1fb <atoi+0x2f>

00000209 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	56                   	push   %esi
 20d:	53                   	push   %ebx
 20e:	8b 75 08             	mov    0x8(%ebp),%esi
 211:	8b 55 0c             	mov    0xc(%ebp),%edx
 214:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 217:	85 db                	test   %ebx,%ebx
 219:	7e 15                	jle    230 <memmove+0x27>
 21b:	01 f3                	add    %esi,%ebx
  dst = vdst;
 21d:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 21f:	83 c2 01             	add    $0x1,%edx
 222:	83 c0 01             	add    $0x1,%eax
 225:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 229:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 22c:	39 c3                	cmp    %eax,%ebx
 22e:	75 ef                	jne    21f <memmove+0x16>
  return vdst;
}
 230:	89 f0                	mov    %esi,%eax
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5d                   	pop    %ebp
 235:	c3                   	ret    

00000236 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 236:	b8 01 00 00 00       	mov    $0x1,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <exit>:
SYSCALL(exit)
 23e:	b8 02 00 00 00       	mov    $0x2,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <wait>:
SYSCALL(wait)
 246:	b8 03 00 00 00       	mov    $0x3,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <pipe>:
SYSCALL(pipe)
 24e:	b8 04 00 00 00       	mov    $0x4,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <read>:
SYSCALL(read)
 256:	b8 05 00 00 00       	mov    $0x5,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <write>:
SYSCALL(write)
 25e:	b8 10 00 00 00       	mov    $0x10,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <close>:
SYSCALL(close)
 266:	b8 15 00 00 00       	mov    $0x15,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <kill>:
SYSCALL(kill)
 26e:	b8 06 00 00 00       	mov    $0x6,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <exec>:
SYSCALL(exec)
 276:	b8 07 00 00 00       	mov    $0x7,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <open>:
SYSCALL(open)
 27e:	b8 0f 00 00 00       	mov    $0xf,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <mknod>:
SYSCALL(mknod)
 286:	b8 11 00 00 00       	mov    $0x11,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <unlink>:
SYSCALL(unlink)
 28e:	b8 12 00 00 00       	mov    $0x12,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <fstat>:
SYSCALL(fstat)
 296:	b8 08 00 00 00       	mov    $0x8,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <link>:
SYSCALL(link)
 29e:	b8 13 00 00 00       	mov    $0x13,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <mkdir>:
SYSCALL(mkdir)
 2a6:	b8 14 00 00 00       	mov    $0x14,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <chdir>:
SYSCALL(chdir)
 2ae:	b8 09 00 00 00       	mov    $0x9,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <dup>:
SYSCALL(dup)
 2b6:	b8 0a 00 00 00       	mov    $0xa,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <getpid>:
SYSCALL(getpid)
 2be:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <sbrk>:
SYSCALL(sbrk)
 2c6:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <sleep>:
SYSCALL(sleep)
 2ce:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <uptime>:
SYSCALL(uptime)
 2d6:	b8 0e 00 00 00       	mov    $0xe,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <slabtest>:
SYSCALL(slabtest)
 2de:	b8 16 00 00 00       	mov    $0x16,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <ps>:
SYSCALL(ps)
 2e6:	b8 17 00 00 00       	mov    $0x17,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	57                   	push   %edi
 2f2:	56                   	push   %esi
 2f3:	53                   	push   %ebx
 2f4:	83 ec 3c             	sub    $0x3c,%esp
 2f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2fa:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 300:	74 79                	je     37b <printint+0x8d>
 302:	85 d2                	test   %edx,%edx
 304:	79 75                	jns    37b <printint+0x8d>
    neg = 1;
    x = -xx;
 306:	89 d1                	mov    %edx,%ecx
 308:	f7 d9                	neg    %ecx
    neg = 1;
 30a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 311:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 316:	89 df                	mov    %ebx,%edi
 318:	83 c3 01             	add    $0x1,%ebx
 31b:	89 c8                	mov    %ecx,%eax
 31d:	ba 00 00 00 00       	mov    $0x0,%edx
 322:	f7 f6                	div    %esi
 324:	0f b6 92 10 07 00 00 	movzbl 0x710(%edx),%edx
 32b:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 32f:	89 ca                	mov    %ecx,%edx
 331:	89 c1                	mov    %eax,%ecx
 333:	39 d6                	cmp    %edx,%esi
 335:	76 df                	jbe    316 <printint+0x28>
  if(neg)
 337:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 33b:	74 08                	je     345 <printint+0x57>
    buf[i++] = '-';
 33d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 342:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 345:	85 db                	test   %ebx,%ebx
 347:	7e 2a                	jle    373 <printint+0x85>
 349:	8d 7d d8             	lea    -0x28(%ebp),%edi
 34c:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 350:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 353:	0f b6 03             	movzbl (%ebx),%eax
 356:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 359:	83 ec 04             	sub    $0x4,%esp
 35c:	6a 01                	push   $0x1
 35e:	56                   	push   %esi
 35f:	ff 75 c4             	push   -0x3c(%ebp)
 362:	e8 f7 fe ff ff       	call   25e <write>
  while(--i >= 0)
 367:	89 d8                	mov    %ebx,%eax
 369:	83 eb 01             	sub    $0x1,%ebx
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	39 f8                	cmp    %edi,%eax
 371:	75 e0                	jne    353 <printint+0x65>
}
 373:	8d 65 f4             	lea    -0xc(%ebp),%esp
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
    x = xx;
 37b:	89 d1                	mov    %edx,%ecx
  neg = 0;
 37d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 384:	eb 8b                	jmp    311 <printint+0x23>

00000386 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	57                   	push   %edi
 38a:	56                   	push   %esi
 38b:	53                   	push   %ebx
 38c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 38f:	8b 75 0c             	mov    0xc(%ebp),%esi
 392:	0f b6 1e             	movzbl (%esi),%ebx
 395:	84 db                	test   %bl,%bl
 397:	0f 84 9f 01 00 00    	je     53c <printf+0x1b6>
 39d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3a0:	8d 45 10             	lea    0x10(%ebp),%eax
 3a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3a6:	bf 00 00 00 00       	mov    $0x0,%edi
 3ab:	eb 2d                	jmp    3da <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3ad:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	6a 01                	push   $0x1
 3b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3b8:	50                   	push   %eax
 3b9:	ff 75 08             	push   0x8(%ebp)
 3bc:	e8 9d fe ff ff       	call   25e <write>
        putc(fd, c);
 3c1:	83 c4 10             	add    $0x10,%esp
 3c4:	eb 05                	jmp    3cb <printf+0x45>
      }
    } else if(state == '%'){
 3c6:	83 ff 25             	cmp    $0x25,%edi
 3c9:	74 1f                	je     3ea <printf+0x64>
  for(i = 0; fmt[i]; i++){
 3cb:	83 c6 01             	add    $0x1,%esi
 3ce:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3d2:	84 db                	test   %bl,%bl
 3d4:	0f 84 62 01 00 00    	je     53c <printf+0x1b6>
    c = fmt[i] & 0xff;
 3da:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3dd:	85 ff                	test   %edi,%edi
 3df:	75 e5                	jne    3c6 <printf+0x40>
      if(c == '%'){
 3e1:	83 f8 25             	cmp    $0x25,%eax
 3e4:	75 c7                	jne    3ad <printf+0x27>
        state = '%';
 3e6:	89 c7                	mov    %eax,%edi
 3e8:	eb e1                	jmp    3cb <printf+0x45>
      if(c == 'd'){
 3ea:	83 f8 25             	cmp    $0x25,%eax
 3ed:	0f 84 f2 00 00 00    	je     4e5 <printf+0x15f>
 3f3:	8d 50 9d             	lea    -0x63(%eax),%edx
 3f6:	83 fa 15             	cmp    $0x15,%edx
 3f9:	0f 87 07 01 00 00    	ja     506 <printf+0x180>
 3ff:	0f 87 01 01 00 00    	ja     506 <printf+0x180>
 405:	ff 24 95 b8 06 00 00 	jmp    *0x6b8(,%edx,4)
        printint(fd, *ap, 10, 1);
 40c:	83 ec 0c             	sub    $0xc,%esp
 40f:	6a 01                	push   $0x1
 411:	b9 0a 00 00 00       	mov    $0xa,%ecx
 416:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 419:	8b 17                	mov    (%edi),%edx
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	e8 cb fe ff ff       	call   2ee <printint>
        ap++;
 423:	89 f8                	mov    %edi,%eax
 425:	83 c0 04             	add    $0x4,%eax
 428:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 42b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 42e:	bf 00 00 00 00       	mov    $0x0,%edi
 433:	eb 96                	jmp    3cb <printf+0x45>
        printint(fd, *ap, 16, 0);
 435:	83 ec 0c             	sub    $0xc,%esp
 438:	6a 00                	push   $0x0
 43a:	b9 10 00 00 00       	mov    $0x10,%ecx
 43f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 442:	8b 17                	mov    (%edi),%edx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	e8 a2 fe ff ff       	call   2ee <printint>
        ap++;
 44c:	89 f8                	mov    %edi,%eax
 44e:	83 c0 04             	add    $0x4,%eax
 451:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 454:	83 c4 10             	add    $0x10,%esp
      state = 0;
 457:	bf 00 00 00 00       	mov    $0x0,%edi
 45c:	e9 6a ff ff ff       	jmp    3cb <printf+0x45>
        s = (char*)*ap;
 461:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 464:	8b 01                	mov    (%ecx),%eax
        ap++;
 466:	83 c1 04             	add    $0x4,%ecx
 469:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 46c:	85 c0                	test   %eax,%eax
 46e:	74 13                	je     483 <printf+0xfd>
        s = (char*)*ap;
 470:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 472:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 475:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 47a:	84 c0                	test   %al,%al
 47c:	75 0f                	jne    48d <printf+0x107>
 47e:	e9 48 ff ff ff       	jmp    3cb <printf+0x45>
          s = "(null)";
 483:	bb af 06 00 00       	mov    $0x6af,%ebx
        while(*s != 0){
 488:	b8 28 00 00 00       	mov    $0x28,%eax
 48d:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 490:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 493:	83 ec 04             	sub    $0x4,%esp
 496:	6a 01                	push   $0x1
 498:	8d 45 e7             	lea    -0x19(%ebp),%eax
 49b:	50                   	push   %eax
 49c:	57                   	push   %edi
 49d:	e8 bc fd ff ff       	call   25e <write>
          s++;
 4a2:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4a5:	0f b6 03             	movzbl (%ebx),%eax
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	84 c0                	test   %al,%al
 4ad:	75 e1                	jne    490 <printf+0x10a>
      state = 0;
 4af:	bf 00 00 00 00       	mov    $0x0,%edi
 4b4:	e9 12 ff ff ff       	jmp    3cb <printf+0x45>
        putc(fd, *ap);
 4b9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4bc:	8b 07                	mov    (%edi),%eax
 4be:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4c1:	83 ec 04             	sub    $0x4,%esp
 4c4:	6a 01                	push   $0x1
 4c6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c9:	50                   	push   %eax
 4ca:	ff 75 08             	push   0x8(%ebp)
 4cd:	e8 8c fd ff ff       	call   25e <write>
        ap++;
 4d2:	83 c7 04             	add    $0x4,%edi
 4d5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4db:	bf 00 00 00 00       	mov    $0x0,%edi
 4e0:	e9 e6 fe ff ff       	jmp    3cb <printf+0x45>
        putc(fd, c);
 4e5:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4e8:	83 ec 04             	sub    $0x4,%esp
 4eb:	6a 01                	push   $0x1
 4ed:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f0:	50                   	push   %eax
 4f1:	ff 75 08             	push   0x8(%ebp)
 4f4:	e8 65 fd ff ff       	call   25e <write>
 4f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fc:	bf 00 00 00 00       	mov    $0x0,%edi
 501:	e9 c5 fe ff ff       	jmp    3cb <printf+0x45>
        putc(fd, '%');
 506:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 50a:	83 ec 04             	sub    $0x4,%esp
 50d:	6a 01                	push   $0x1
 50f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 512:	50                   	push   %eax
 513:	ff 75 08             	push   0x8(%ebp)
 516:	e8 43 fd ff ff       	call   25e <write>
        putc(fd, c);
 51b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 51e:	83 c4 0c             	add    $0xc,%esp
 521:	6a 01                	push   $0x1
 523:	8d 45 e7             	lea    -0x19(%ebp),%eax
 526:	50                   	push   %eax
 527:	ff 75 08             	push   0x8(%ebp)
 52a:	e8 2f fd ff ff       	call   25e <write>
        putc(fd, c);
 52f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 532:	bf 00 00 00 00       	mov    $0x0,%edi
 537:	e9 8f fe ff ff       	jmp    3cb <printf+0x45>
    }
  }
}
 53c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    

00000544 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	57                   	push   %edi
 548:	56                   	push   %esi
 549:	53                   	push   %ebx
 54a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 550:	a1 84 09 00 00       	mov    0x984,%eax
 555:	eb 0c                	jmp    563 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 557:	8b 10                	mov    (%eax),%edx
 559:	39 c2                	cmp    %eax,%edx
 55b:	77 04                	ja     561 <free+0x1d>
 55d:	39 ca                	cmp    %ecx,%edx
 55f:	77 10                	ja     571 <free+0x2d>
{
 561:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 563:	39 c8                	cmp    %ecx,%eax
 565:	73 f0                	jae    557 <free+0x13>
 567:	8b 10                	mov    (%eax),%edx
 569:	39 ca                	cmp    %ecx,%edx
 56b:	77 04                	ja     571 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56d:	39 c2                	cmp    %eax,%edx
 56f:	77 f0                	ja     561 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 571:	8b 73 fc             	mov    -0x4(%ebx),%esi
 574:	8b 10                	mov    (%eax),%edx
 576:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 579:	39 fa                	cmp    %edi,%edx
 57b:	74 19                	je     596 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 57d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 580:	8b 50 04             	mov    0x4(%eax),%edx
 583:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 586:	39 f1                	cmp    %esi,%ecx
 588:	74 18                	je     5a2 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 58a:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 58c:	a3 84 09 00 00       	mov    %eax,0x984
}
 591:	5b                   	pop    %ebx
 592:	5e                   	pop    %esi
 593:	5f                   	pop    %edi
 594:	5d                   	pop    %ebp
 595:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 596:	03 72 04             	add    0x4(%edx),%esi
 599:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 59c:	8b 10                	mov    (%eax),%edx
 59e:	8b 12                	mov    (%edx),%edx
 5a0:	eb db                	jmp    57d <free+0x39>
    p->s.size += bp->s.size;
 5a2:	03 53 fc             	add    -0x4(%ebx),%edx
 5a5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5a8:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5ab:	eb dd                	jmp    58a <free+0x46>

000005ad <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5ad:	55                   	push   %ebp
 5ae:	89 e5                	mov    %esp,%ebp
 5b0:	57                   	push   %edi
 5b1:	56                   	push   %esi
 5b2:	53                   	push   %ebx
 5b3:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	8d 58 07             	lea    0x7(%eax),%ebx
 5bc:	c1 eb 03             	shr    $0x3,%ebx
 5bf:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c2:	8b 15 84 09 00 00    	mov    0x984,%edx
 5c8:	85 d2                	test   %edx,%edx
 5ca:	74 1c                	je     5e8 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5cc:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ce:	8b 48 04             	mov    0x4(%eax),%ecx
 5d1:	39 cb                	cmp    %ecx,%ebx
 5d3:	76 38                	jbe    60d <malloc+0x60>
 5d5:	be 00 10 00 00       	mov    $0x1000,%esi
 5da:	39 f3                	cmp    %esi,%ebx
 5dc:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5df:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5e6:	eb 72                	jmp    65a <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 5e8:	c7 05 84 09 00 00 88 	movl   $0x988,0x984
 5ef:	09 00 00 
 5f2:	c7 05 88 09 00 00 88 	movl   $0x988,0x988
 5f9:	09 00 00 
    base.s.size = 0;
 5fc:	c7 05 8c 09 00 00 00 	movl   $0x0,0x98c
 603:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 606:	b8 88 09 00 00       	mov    $0x988,%eax
 60b:	eb c8                	jmp    5d5 <malloc+0x28>
      if(p->s.size == nunits)
 60d:	39 cb                	cmp    %ecx,%ebx
 60f:	74 1e                	je     62f <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 611:	29 d9                	sub    %ebx,%ecx
 613:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 616:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 619:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 61c:	89 15 84 09 00 00    	mov    %edx,0x984
      return (void*)(p + 1);
 622:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 625:	89 d0                	mov    %edx,%eax
 627:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 62f:	8b 08                	mov    (%eax),%ecx
 631:	89 0a                	mov    %ecx,(%edx)
 633:	eb e7                	jmp    61c <malloc+0x6f>
  hp->s.size = nu;
 635:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 638:	83 ec 0c             	sub    $0xc,%esp
 63b:	83 c0 08             	add    $0x8,%eax
 63e:	50                   	push   %eax
 63f:	e8 00 ff ff ff       	call   544 <free>
  return freep;
 644:	8b 15 84 09 00 00    	mov    0x984,%edx
      if((p = morecore(nunits)) == 0)
 64a:	83 c4 10             	add    $0x10,%esp
 64d:	85 d2                	test   %edx,%edx
 64f:	74 d4                	je     625 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 651:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 653:	8b 48 04             	mov    0x4(%eax),%ecx
 656:	39 d9                	cmp    %ebx,%ecx
 658:	73 b3                	jae    60d <malloc+0x60>
    if(p == freep)
 65a:	89 c2                	mov    %eax,%edx
 65c:	39 05 84 09 00 00    	cmp    %eax,0x984
 662:	75 ed                	jne    651 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 664:	83 ec 0c             	sub    $0xc,%esp
 667:	57                   	push   %edi
 668:	e8 59 fc ff ff       	call   2c6 <sbrk>
  if(p == (char*)-1)
 66d:	83 c4 10             	add    $0x10,%esp
 670:	83 f8 ff             	cmp    $0xffffffff,%eax
 673:	75 c0                	jne    635 <malloc+0x88>
        return 0;
 675:	ba 00 00 00 00       	mov    $0x0,%edx
 67a:	eb a9                	jmp    625 <malloc+0x78>
