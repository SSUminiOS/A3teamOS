
user/_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 d8 01 00 00       	call   1ee <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 d7 01 00 00       	call   1f6 <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 5d 02 00 00       	call   286 <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	53                   	push   %ebx
  32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	b8 00 00 00 00       	mov    $0x0,%eax
  3d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  41:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  44:	83 c0 01             	add    $0x1,%eax
  47:	84 d2                	test   %dl,%dl
  49:	75 f2                	jne    3d <strcpy+0xf>
    ;
  return os;
}
  4b:	89 c8                	mov    %ecx,%eax
  4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  50:	c9                   	leave  
  51:	c3                   	ret    

00000052 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  58:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  5b:	0f b6 01             	movzbl (%ecx),%eax
  5e:	84 c0                	test   %al,%al
  60:	74 11                	je     73 <strcmp+0x21>
  62:	38 02                	cmp    %al,(%edx)
  64:	75 0d                	jne    73 <strcmp+0x21>
    p++, q++;
  66:	83 c1 01             	add    $0x1,%ecx
  69:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  6c:	0f b6 01             	movzbl (%ecx),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 ef                	jne    62 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  73:	0f b6 c0             	movzbl %al,%eax
  76:	0f b6 12             	movzbl (%edx),%edx
  79:	29 d0                	sub    %edx,%eax
}
  7b:	5d                   	pop    %ebp
  7c:	c3                   	ret    

0000007d <strlen>:

uint
strlen(const char *s)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  83:	80 3a 00             	cmpb   $0x0,(%edx)
  86:	74 14                	je     9c <strlen+0x1f>
  88:	b8 00 00 00 00       	mov    $0x0,%eax
  8d:	83 c0 01             	add    $0x1,%eax
  90:	89 c1                	mov    %eax,%ecx
  92:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  96:	75 f5                	jne    8d <strlen+0x10>
    ;
  return n;
}
  98:	89 c8                	mov    %ecx,%eax
  9a:	5d                   	pop    %ebp
  9b:	c3                   	ret    
  for(n = 0; s[n]; n++)
  9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  a1:	eb f5                	jmp    98 <strlen+0x1b>

000000a3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	57                   	push   %edi
  a7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  aa:	89 d7                	mov    %edx,%edi
  ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  af:	8b 45 0c             	mov    0xc(%ebp),%eax
  b2:	fc                   	cld    
  b3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b5:	89 d0                	mov    %edx,%eax
  b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strchr>:

char*
strchr(const char *s, char c)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c6:	0f b6 10             	movzbl (%eax),%edx
  c9:	84 d2                	test   %dl,%dl
  cb:	74 15                	je     e2 <strchr+0x26>
    if(*s == c)
  cd:	38 d1                	cmp    %dl,%cl
  cf:	74 0f                	je     e0 <strchr+0x24>
  for(; *s; s++)
  d1:	83 c0 01             	add    $0x1,%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	84 d2                	test   %dl,%dl
  d9:	75 f2                	jne    cd <strchr+0x11>
      return (char*)s;
  return 0;
  db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    
  return 0;
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
  e7:	eb f7                	jmp    e0 <strchr+0x24>

000000e9 <gets>:

char*
gets(char *buf, int max)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	56                   	push   %esi
  ee:	53                   	push   %ebx
  ef:	83 ec 2c             	sub    $0x2c,%esp
  f2:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f5:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
  fa:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 100:	83 c3 01             	add    $0x1,%ebx
 103:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 106:	7d 27                	jge    12f <gets+0x46>
    cc = read(0, &c, 1);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	6a 01                	push   $0x1
 10d:	57                   	push   %edi
 10e:	6a 00                	push   $0x0
 110:	e8 f9 00 00 00       	call   20e <read>
    if(cc < 1)
 115:	83 c4 10             	add    $0x10,%esp
 118:	85 c0                	test   %eax,%eax
 11a:	7e 13                	jle    12f <gets+0x46>
      break;
    buf[i++] = c;
 11c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 120:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 124:	3c 0a                	cmp    $0xa,%al
 126:	74 04                	je     12c <gets+0x43>
 128:	3c 0d                	cmp    $0xd,%al
 12a:	75 d1                	jne    fd <gets+0x14>
  for(i=0; i+1 < max; ){
 12c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 12f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 132:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 136:	89 f0                	mov    %esi,%eax
 138:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13b:	5b                   	pop    %ebx
 13c:	5e                   	pop    %esi
 13d:	5f                   	pop    %edi
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <stat>:

int
stat(const char *n, struct stat *st)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	56                   	push   %esi
 144:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 145:	83 ec 08             	sub    $0x8,%esp
 148:	6a 00                	push   $0x0
 14a:	ff 75 08             	push   0x8(%ebp)
 14d:	e8 e4 00 00 00       	call   236 <open>
  if(fd < 0)
 152:	83 c4 10             	add    $0x10,%esp
 155:	85 c0                	test   %eax,%eax
 157:	78 24                	js     17d <stat+0x3d>
 159:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15b:	83 ec 08             	sub    $0x8,%esp
 15e:	ff 75 0c             	push   0xc(%ebp)
 161:	50                   	push   %eax
 162:	e8 e7 00 00 00       	call   24e <fstat>
 167:	89 c6                	mov    %eax,%esi
  close(fd);
 169:	89 1c 24             	mov    %ebx,(%esp)
 16c:	e8 ad 00 00 00       	call   21e <close>
  return r;
 171:	83 c4 10             	add    $0x10,%esp
}
 174:	89 f0                	mov    %esi,%eax
 176:	8d 65 f8             	lea    -0x8(%ebp),%esp
 179:	5b                   	pop    %ebx
 17a:	5e                   	pop    %esi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
    return -1;
 17d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 182:	eb f0                	jmp    174 <stat+0x34>

00000184 <atoi>:

int
atoi(const char *s)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	53                   	push   %ebx
 188:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18b:	0f b6 02             	movzbl (%edx),%eax
 18e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 191:	80 f9 09             	cmp    $0x9,%cl
 194:	77 24                	ja     1ba <atoi+0x36>
  n = 0;
 196:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 19b:	83 c2 01             	add    $0x1,%edx
 19e:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1a1:	0f be c0             	movsbl %al,%eax
 1a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1a8:	0f b6 02             	movzbl (%edx),%eax
 1ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ae:	80 fb 09             	cmp    $0x9,%bl
 1b1:	76 e8                	jbe    19b <atoi+0x17>
  return n;
}
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    
  n = 0;
 1ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1bf:	eb f2                	jmp    1b3 <atoi+0x2f>

000001c1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	8b 75 08             	mov    0x8(%ebp),%esi
 1c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1cf:	85 db                	test   %ebx,%ebx
 1d1:	7e 15                	jle    1e8 <memmove+0x27>
 1d3:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1d5:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1d7:	83 c2 01             	add    $0x1,%edx
 1da:	83 c0 01             	add    $0x1,%eax
 1dd:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1e1:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 1e4:	39 c3                	cmp    %eax,%ebx
 1e6:	75 ef                	jne    1d7 <memmove+0x16>
  return vdst;
}
 1e8:	89 f0                	mov    %esi,%eax
 1ea:	5b                   	pop    %ebx
 1eb:	5e                   	pop    %esi
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    

000001ee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ee:	b8 01 00 00 00       	mov    $0x1,%eax
 1f3:	cd 40                	int    $0x40
 1f5:	c3                   	ret    

000001f6 <exit>:
SYSCALL(exit)
 1f6:	b8 02 00 00 00       	mov    $0x2,%eax
 1fb:	cd 40                	int    $0x40
 1fd:	c3                   	ret    

000001fe <wait>:
SYSCALL(wait)
 1fe:	b8 03 00 00 00       	mov    $0x3,%eax
 203:	cd 40                	int    $0x40
 205:	c3                   	ret    

00000206 <pipe>:
SYSCALL(pipe)
 206:	b8 04 00 00 00       	mov    $0x4,%eax
 20b:	cd 40                	int    $0x40
 20d:	c3                   	ret    

0000020e <read>:
SYSCALL(read)
 20e:	b8 05 00 00 00       	mov    $0x5,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <write>:
SYSCALL(write)
 216:	b8 10 00 00 00       	mov    $0x10,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <close>:
SYSCALL(close)
 21e:	b8 15 00 00 00       	mov    $0x15,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <kill>:
SYSCALL(kill)
 226:	b8 06 00 00 00       	mov    $0x6,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <exec>:
SYSCALL(exec)
 22e:	b8 07 00 00 00       	mov    $0x7,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <open>:
SYSCALL(open)
 236:	b8 0f 00 00 00       	mov    $0xf,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <mknod>:
SYSCALL(mknod)
 23e:	b8 11 00 00 00       	mov    $0x11,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <unlink>:
SYSCALL(unlink)
 246:	b8 12 00 00 00       	mov    $0x12,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <fstat>:
SYSCALL(fstat)
 24e:	b8 08 00 00 00       	mov    $0x8,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <link>:
SYSCALL(link)
 256:	b8 13 00 00 00       	mov    $0x13,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <mkdir>:
SYSCALL(mkdir)
 25e:	b8 14 00 00 00       	mov    $0x14,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <chdir>:
SYSCALL(chdir)
 266:	b8 09 00 00 00       	mov    $0x9,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <dup>:
SYSCALL(dup)
 26e:	b8 0a 00 00 00       	mov    $0xa,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <getpid>:
SYSCALL(getpid)
 276:	b8 0b 00 00 00       	mov    $0xb,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <sbrk>:
SYSCALL(sbrk)
 27e:	b8 0c 00 00 00       	mov    $0xc,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <sleep>:
SYSCALL(sleep)
 286:	b8 0d 00 00 00       	mov    $0xd,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <uptime>:
SYSCALL(uptime)
 28e:	b8 0e 00 00 00       	mov    $0xe,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <slabtest>:
SYSCALL(slabtest)
 296:	b8 16 00 00 00       	mov    $0x16,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <ps>:
SYSCALL(ps)
 29e:	b8 17 00 00 00       	mov    $0x17,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	57                   	push   %edi
 2aa:	56                   	push   %esi
 2ab:	53                   	push   %ebx
 2ac:	83 ec 3c             	sub    $0x3c,%esp
 2af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2b2:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2b8:	74 79                	je     333 <printint+0x8d>
 2ba:	85 d2                	test   %edx,%edx
 2bc:	79 75                	jns    333 <printint+0x8d>
    neg = 1;
    x = -xx;
 2be:	89 d1                	mov    %edx,%ecx
 2c0:	f7 d9                	neg    %ecx
    neg = 1;
 2c2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ce:	89 df                	mov    %ebx,%edi
 2d0:	83 c3 01             	add    $0x1,%ebx
 2d3:	89 c8                	mov    %ecx,%eax
 2d5:	ba 00 00 00 00       	mov    $0x0,%edx
 2da:	f7 f6                	div    %esi
 2dc:	0f b6 92 94 06 00 00 	movzbl 0x694(%edx),%edx
 2e3:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 2e7:	89 ca                	mov    %ecx,%edx
 2e9:	89 c1                	mov    %eax,%ecx
 2eb:	39 d6                	cmp    %edx,%esi
 2ed:	76 df                	jbe    2ce <printint+0x28>
  if(neg)
 2ef:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 2f3:	74 08                	je     2fd <printint+0x57>
    buf[i++] = '-';
 2f5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2fa:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 2fd:	85 db                	test   %ebx,%ebx
 2ff:	7e 2a                	jle    32b <printint+0x85>
 301:	8d 7d d8             	lea    -0x28(%ebp),%edi
 304:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 308:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 30b:	0f b6 03             	movzbl (%ebx),%eax
 30e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 311:	83 ec 04             	sub    $0x4,%esp
 314:	6a 01                	push   $0x1
 316:	56                   	push   %esi
 317:	ff 75 c4             	push   -0x3c(%ebp)
 31a:	e8 f7 fe ff ff       	call   216 <write>
  while(--i >= 0)
 31f:	89 d8                	mov    %ebx,%eax
 321:	83 eb 01             	sub    $0x1,%ebx
 324:	83 c4 10             	add    $0x10,%esp
 327:	39 f8                	cmp    %edi,%eax
 329:	75 e0                	jne    30b <printint+0x65>
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
    x = xx;
 333:	89 d1                	mov    %edx,%ecx
  neg = 0;
 335:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 33c:	eb 8b                	jmp    2c9 <printint+0x23>

0000033e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	57                   	push   %edi
 342:	56                   	push   %esi
 343:	53                   	push   %ebx
 344:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 347:	8b 75 0c             	mov    0xc(%ebp),%esi
 34a:	0f b6 1e             	movzbl (%esi),%ebx
 34d:	84 db                	test   %bl,%bl
 34f:	0f 84 9f 01 00 00    	je     4f4 <printf+0x1b6>
 355:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 358:	8d 45 10             	lea    0x10(%ebp),%eax
 35b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 35e:	bf 00 00 00 00       	mov    $0x0,%edi
 363:	eb 2d                	jmp    392 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 365:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 368:	83 ec 04             	sub    $0x4,%esp
 36b:	6a 01                	push   $0x1
 36d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 370:	50                   	push   %eax
 371:	ff 75 08             	push   0x8(%ebp)
 374:	e8 9d fe ff ff       	call   216 <write>
        putc(fd, c);
 379:	83 c4 10             	add    $0x10,%esp
 37c:	eb 05                	jmp    383 <printf+0x45>
      }
    } else if(state == '%'){
 37e:	83 ff 25             	cmp    $0x25,%edi
 381:	74 1f                	je     3a2 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 383:	83 c6 01             	add    $0x1,%esi
 386:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 38a:	84 db                	test   %bl,%bl
 38c:	0f 84 62 01 00 00    	je     4f4 <printf+0x1b6>
    c = fmt[i] & 0xff;
 392:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 395:	85 ff                	test   %edi,%edi
 397:	75 e5                	jne    37e <printf+0x40>
      if(c == '%'){
 399:	83 f8 25             	cmp    $0x25,%eax
 39c:	75 c7                	jne    365 <printf+0x27>
        state = '%';
 39e:	89 c7                	mov    %eax,%edi
 3a0:	eb e1                	jmp    383 <printf+0x45>
      if(c == 'd'){
 3a2:	83 f8 25             	cmp    $0x25,%eax
 3a5:	0f 84 f2 00 00 00    	je     49d <printf+0x15f>
 3ab:	8d 50 9d             	lea    -0x63(%eax),%edx
 3ae:	83 fa 15             	cmp    $0x15,%edx
 3b1:	0f 87 07 01 00 00    	ja     4be <printf+0x180>
 3b7:	0f 87 01 01 00 00    	ja     4be <printf+0x180>
 3bd:	ff 24 95 3c 06 00 00 	jmp    *0x63c(,%edx,4)
        printint(fd, *ap, 10, 1);
 3c4:	83 ec 0c             	sub    $0xc,%esp
 3c7:	6a 01                	push   $0x1
 3c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3d1:	8b 17                	mov    (%edi),%edx
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	e8 cb fe ff ff       	call   2a6 <printint>
        ap++;
 3db:	89 f8                	mov    %edi,%eax
 3dd:	83 c0 04             	add    $0x4,%eax
 3e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3e3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3e6:	bf 00 00 00 00       	mov    $0x0,%edi
 3eb:	eb 96                	jmp    383 <printf+0x45>
        printint(fd, *ap, 16, 0);
 3ed:	83 ec 0c             	sub    $0xc,%esp
 3f0:	6a 00                	push   $0x0
 3f2:	b9 10 00 00 00       	mov    $0x10,%ecx
 3f7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3fa:	8b 17                	mov    (%edi),%edx
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	e8 a2 fe ff ff       	call   2a6 <printint>
        ap++;
 404:	89 f8                	mov    %edi,%eax
 406:	83 c0 04             	add    $0x4,%eax
 409:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 40c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40f:	bf 00 00 00 00       	mov    $0x0,%edi
 414:	e9 6a ff ff ff       	jmp    383 <printf+0x45>
        s = (char*)*ap;
 419:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 41c:	8b 01                	mov    (%ecx),%eax
        ap++;
 41e:	83 c1 04             	add    $0x4,%ecx
 421:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 424:	85 c0                	test   %eax,%eax
 426:	74 13                	je     43b <printf+0xfd>
        s = (char*)*ap;
 428:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 42a:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 42d:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 432:	84 c0                	test   %al,%al
 434:	75 0f                	jne    445 <printf+0x107>
 436:	e9 48 ff ff ff       	jmp    383 <printf+0x45>
          s = "(null)";
 43b:	bb 34 06 00 00       	mov    $0x634,%ebx
        while(*s != 0){
 440:	b8 28 00 00 00       	mov    $0x28,%eax
 445:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 448:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	6a 01                	push   $0x1
 450:	8d 45 e7             	lea    -0x19(%ebp),%eax
 453:	50                   	push   %eax
 454:	57                   	push   %edi
 455:	e8 bc fd ff ff       	call   216 <write>
          s++;
 45a:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 45d:	0f b6 03             	movzbl (%ebx),%eax
 460:	83 c4 10             	add    $0x10,%esp
 463:	84 c0                	test   %al,%al
 465:	75 e1                	jne    448 <printf+0x10a>
      state = 0;
 467:	bf 00 00 00 00       	mov    $0x0,%edi
 46c:	e9 12 ff ff ff       	jmp    383 <printf+0x45>
        putc(fd, *ap);
 471:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 474:	8b 07                	mov    (%edi),%eax
 476:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 479:	83 ec 04             	sub    $0x4,%esp
 47c:	6a 01                	push   $0x1
 47e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 481:	50                   	push   %eax
 482:	ff 75 08             	push   0x8(%ebp)
 485:	e8 8c fd ff ff       	call   216 <write>
        ap++;
 48a:	83 c7 04             	add    $0x4,%edi
 48d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 490:	83 c4 10             	add    $0x10,%esp
      state = 0;
 493:	bf 00 00 00 00       	mov    $0x0,%edi
 498:	e9 e6 fe ff ff       	jmp    383 <printf+0x45>
        putc(fd, c);
 49d:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	6a 01                	push   $0x1
 4a5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a8:	50                   	push   %eax
 4a9:	ff 75 08             	push   0x8(%ebp)
 4ac:	e8 65 fd ff ff       	call   216 <write>
 4b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b4:	bf 00 00 00 00       	mov    $0x0,%edi
 4b9:	e9 c5 fe ff ff       	jmp    383 <printf+0x45>
        putc(fd, '%');
 4be:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4c2:	83 ec 04             	sub    $0x4,%esp
 4c5:	6a 01                	push   $0x1
 4c7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ca:	50                   	push   %eax
 4cb:	ff 75 08             	push   0x8(%ebp)
 4ce:	e8 43 fd ff ff       	call   216 <write>
        putc(fd, c);
 4d3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4d6:	83 c4 0c             	add    $0xc,%esp
 4d9:	6a 01                	push   $0x1
 4db:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4de:	50                   	push   %eax
 4df:	ff 75 08             	push   0x8(%ebp)
 4e2:	e8 2f fd ff ff       	call   216 <write>
        putc(fd, c);
 4e7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ea:	bf 00 00 00 00       	mov    $0x0,%edi
 4ef:	e9 8f fe ff ff       	jmp    383 <printf+0x45>
    }
  }
}
 4f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f7:	5b                   	pop    %ebx
 4f8:	5e                   	pop    %esi
 4f9:	5f                   	pop    %edi
 4fa:	5d                   	pop    %ebp
 4fb:	c3                   	ret    

000004fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	57                   	push   %edi
 500:	56                   	push   %esi
 501:	53                   	push   %ebx
 502:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 505:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 508:	a1 fc 08 00 00       	mov    0x8fc,%eax
 50d:	eb 0c                	jmp    51b <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50f:	8b 10                	mov    (%eax),%edx
 511:	39 c2                	cmp    %eax,%edx
 513:	77 04                	ja     519 <free+0x1d>
 515:	39 ca                	cmp    %ecx,%edx
 517:	77 10                	ja     529 <free+0x2d>
{
 519:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 51b:	39 c8                	cmp    %ecx,%eax
 51d:	73 f0                	jae    50f <free+0x13>
 51f:	8b 10                	mov    (%eax),%edx
 521:	39 ca                	cmp    %ecx,%edx
 523:	77 04                	ja     529 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 525:	39 c2                	cmp    %eax,%edx
 527:	77 f0                	ja     519 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 529:	8b 73 fc             	mov    -0x4(%ebx),%esi
 52c:	8b 10                	mov    (%eax),%edx
 52e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 531:	39 fa                	cmp    %edi,%edx
 533:	74 19                	je     54e <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 535:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 538:	8b 50 04             	mov    0x4(%eax),%edx
 53b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 53e:	39 f1                	cmp    %esi,%ecx
 540:	74 18                	je     55a <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 542:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 544:	a3 fc 08 00 00       	mov    %eax,0x8fc
}
 549:	5b                   	pop    %ebx
 54a:	5e                   	pop    %esi
 54b:	5f                   	pop    %edi
 54c:	5d                   	pop    %ebp
 54d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 54e:	03 72 04             	add    0x4(%edx),%esi
 551:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 554:	8b 10                	mov    (%eax),%edx
 556:	8b 12                	mov    (%edx),%edx
 558:	eb db                	jmp    535 <free+0x39>
    p->s.size += bp->s.size;
 55a:	03 53 fc             	add    -0x4(%ebx),%edx
 55d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 560:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 563:	eb dd                	jmp    542 <free+0x46>

00000565 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	57                   	push   %edi
 569:	56                   	push   %esi
 56a:	53                   	push   %ebx
 56b:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56e:	8b 45 08             	mov    0x8(%ebp),%eax
 571:	8d 58 07             	lea    0x7(%eax),%ebx
 574:	c1 eb 03             	shr    $0x3,%ebx
 577:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 57a:	8b 15 fc 08 00 00    	mov    0x8fc,%edx
 580:	85 d2                	test   %edx,%edx
 582:	74 1c                	je     5a0 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 584:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 586:	8b 48 04             	mov    0x4(%eax),%ecx
 589:	39 cb                	cmp    %ecx,%ebx
 58b:	76 38                	jbe    5c5 <malloc+0x60>
 58d:	be 00 10 00 00       	mov    $0x1000,%esi
 592:	39 f3                	cmp    %esi,%ebx
 594:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 597:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 59e:	eb 72                	jmp    612 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 5a0:	c7 05 fc 08 00 00 00 	movl   $0x900,0x8fc
 5a7:	09 00 00 
 5aa:	c7 05 00 09 00 00 00 	movl   $0x900,0x900
 5b1:	09 00 00 
    base.s.size = 0;
 5b4:	c7 05 04 09 00 00 00 	movl   $0x0,0x904
 5bb:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5be:	b8 00 09 00 00       	mov    $0x900,%eax
 5c3:	eb c8                	jmp    58d <malloc+0x28>
      if(p->s.size == nunits)
 5c5:	39 cb                	cmp    %ecx,%ebx
 5c7:	74 1e                	je     5e7 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c9:	29 d9                	sub    %ebx,%ecx
 5cb:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5ce:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5d1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d4:	89 15 fc 08 00 00    	mov    %edx,0x8fc
      return (void*)(p + 1);
 5da:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5dd:	89 d0                	mov    %edx,%eax
 5df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e2:	5b                   	pop    %ebx
 5e3:	5e                   	pop    %esi
 5e4:	5f                   	pop    %edi
 5e5:	5d                   	pop    %ebp
 5e6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e7:	8b 08                	mov    (%eax),%ecx
 5e9:	89 0a                	mov    %ecx,(%edx)
 5eb:	eb e7                	jmp    5d4 <malloc+0x6f>
  hp->s.size = nu;
 5ed:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	83 c0 08             	add    $0x8,%eax
 5f6:	50                   	push   %eax
 5f7:	e8 00 ff ff ff       	call   4fc <free>
  return freep;
 5fc:	8b 15 fc 08 00 00    	mov    0x8fc,%edx
      if((p = morecore(nunits)) == 0)
 602:	83 c4 10             	add    $0x10,%esp
 605:	85 d2                	test   %edx,%edx
 607:	74 d4                	je     5dd <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 609:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 60b:	8b 48 04             	mov    0x4(%eax),%ecx
 60e:	39 d9                	cmp    %ebx,%ecx
 610:	73 b3                	jae    5c5 <malloc+0x60>
    if(p == freep)
 612:	89 c2                	mov    %eax,%edx
 614:	39 05 fc 08 00 00    	cmp    %eax,0x8fc
 61a:	75 ed                	jne    609 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 61c:	83 ec 0c             	sub    $0xc,%esp
 61f:	57                   	push   %edi
 620:	e8 59 fc ff ff       	call   27e <sbrk>
  if(p == (char*)-1)
 625:	83 c4 10             	add    $0x10,%esp
 628:	83 f8 ff             	cmp    $0xffffffff,%eax
 62b:	75 c0                	jne    5ed <malloc+0x88>
        return 0;
 62d:	ba 00 00 00 00       	mov    $0x0,%edx
 632:	eb a9                	jmp    5dd <malloc+0x78>
