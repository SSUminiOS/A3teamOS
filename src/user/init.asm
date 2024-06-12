
user/_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 e4 06 00 00       	push   $0x6e4
  19:	e8 c7 02 00 00       	call   2e5 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 59                	js     7e <main+0x7e>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 ee 02 00 00       	call   31d <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 e2 02 00 00       	call   31d <dup>
  3b:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	68 ec 06 00 00       	push   $0x6ec
  46:	6a 01                	push   $0x1
  48:	e8 a0 03 00 00       	call   3ed <printf>
    pid = fork();
  4d:	e8 4b 02 00 00       	call   29d <fork>
  52:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  54:	83 c4 10             	add    $0x10,%esp
  57:	85 c0                	test   %eax,%eax
  59:	78 48                	js     a3 <main+0xa3>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  5b:	74 5a                	je     b7 <main+0xb7>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  5d:	e8 4b 02 00 00       	call   2ad <wait>
  62:	39 c3                	cmp    %eax,%ebx
  64:	74 d8                	je     3e <main+0x3e>
  66:	85 c0                	test   %eax,%eax
  68:	78 d4                	js     3e <main+0x3e>
      printf(1, "zombie!\n");
  6a:	83 ec 08             	sub    $0x8,%esp
  6d:	68 2b 07 00 00       	push   $0x72b
  72:	6a 01                	push   $0x1
  74:	e8 74 03 00 00       	call   3ed <printf>
  79:	83 c4 10             	add    $0x10,%esp
  7c:	eb df                	jmp    5d <main+0x5d>
    mknod("console", 1, 1);
  7e:	83 ec 04             	sub    $0x4,%esp
  81:	6a 01                	push   $0x1
  83:	6a 01                	push   $0x1
  85:	68 e4 06 00 00       	push   $0x6e4
  8a:	e8 5e 02 00 00       	call   2ed <mknod>
    open("console", O_RDWR);
  8f:	83 c4 08             	add    $0x8,%esp
  92:	6a 02                	push   $0x2
  94:	68 e4 06 00 00       	push   $0x6e4
  99:	e8 47 02 00 00       	call   2e5 <open>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	eb 82                	jmp    25 <main+0x25>
      printf(1, "init: fork failed\n");
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	68 ff 06 00 00       	push   $0x6ff
  ab:	6a 01                	push   $0x1
  ad:	e8 3b 03 00 00       	call   3ed <printf>
      exit();
  b2:	e8 ee 01 00 00       	call   2a5 <exit>
      exec("sh", argv);
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 00 0a 00 00       	push   $0xa00
  bf:	68 12 07 00 00       	push   $0x712
  c4:	e8 14 02 00 00       	call   2dd <exec>
      printf(1, "init: exec sh failed\n");
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	68 15 07 00 00       	push   $0x715
  d1:	6a 01                	push   $0x1
  d3:	e8 15 03 00 00       	call   3ed <printf>
      exit();
  d8:	e8 c8 01 00 00       	call   2a5 <exit>

000000dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	53                   	push   %ebx
  e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
  ec:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  f0:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f3:	83 c0 01             	add    $0x1,%eax
  f6:	84 d2                	test   %dl,%dl
  f8:	75 f2                	jne    ec <strcpy+0xf>
    ;
  return os;
}
  fa:	89 c8                	mov    %ecx,%eax
  fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10a:	0f b6 01             	movzbl (%ecx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	74 11                	je     122 <strcmp+0x21>
 111:	38 02                	cmp    %al,(%edx)
 113:	75 0d                	jne    122 <strcmp+0x21>
    p++, q++;
 115:	83 c1 01             	add    $0x1,%ecx
 118:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 11b:	0f b6 01             	movzbl (%ecx),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ef                	jne    111 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 122:	0f b6 c0             	movzbl %al,%eax
 125:	0f b6 12             	movzbl (%edx),%edx
 128:	29 d0                	sub    %edx,%eax
}
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <strlen>:

uint
strlen(const char *s)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 132:	80 3a 00             	cmpb   $0x0,(%edx)
 135:	74 14                	je     14b <strlen+0x1f>
 137:	b8 00 00 00 00       	mov    $0x0,%eax
 13c:	83 c0 01             	add    $0x1,%eax
 13f:	89 c1                	mov    %eax,%ecx
 141:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 145:	75 f5                	jne    13c <strlen+0x10>
    ;
  return n;
}
 147:	89 c8                	mov    %ecx,%eax
 149:	5d                   	pop    %ebp
 14a:	c3                   	ret    
  for(n = 0; s[n]; n++)
 14b:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 150:	eb f5                	jmp    147 <strlen+0x1b>

00000152 <memset>:

void*
memset(void *dst, int c, uint n)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 159:	89 d7                	mov    %edx,%edi
 15b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	fc                   	cld    
 162:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 164:	89 d0                	mov    %edx,%eax
 166:	8b 7d fc             	mov    -0x4(%ebp),%edi
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <strchr>:

char*
strchr(const char *s, char c)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 175:	0f b6 10             	movzbl (%eax),%edx
 178:	84 d2                	test   %dl,%dl
 17a:	74 15                	je     191 <strchr+0x26>
    if(*s == c)
 17c:	38 d1                	cmp    %dl,%cl
 17e:	74 0f                	je     18f <strchr+0x24>
  for(; *s; s++)
 180:	83 c0 01             	add    $0x1,%eax
 183:	0f b6 10             	movzbl (%eax),%edx
 186:	84 d2                	test   %dl,%dl
 188:	75 f2                	jne    17c <strchr+0x11>
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
 196:	eb f7                	jmp    18f <strchr+0x24>

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	57                   	push   %edi
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	83 ec 2c             	sub    $0x2c,%esp
 1a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1a9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1ac:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1af:	83 c3 01             	add    $0x1,%ebx
 1b2:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b5:	7d 27                	jge    1de <gets+0x46>
    cc = read(0, &c, 1);
 1b7:	83 ec 04             	sub    $0x4,%esp
 1ba:	6a 01                	push   $0x1
 1bc:	57                   	push   %edi
 1bd:	6a 00                	push   $0x0
 1bf:	e8 f9 00 00 00       	call   2bd <read>
    if(cc < 1)
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	85 c0                	test   %eax,%eax
 1c9:	7e 13                	jle    1de <gets+0x46>
      break;
    buf[i++] = c;
 1cb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1cf:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 1d3:	3c 0a                	cmp    $0xa,%al
 1d5:	74 04                	je     1db <gets+0x43>
 1d7:	3c 0d                	cmp    $0xd,%al
 1d9:	75 d1                	jne    1ac <gets+0x14>
  for(i=0; i+1 < max; ){
 1db:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 1de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1e1:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 1e5:	89 f0                	mov    %esi,%eax
 1e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ea:	5b                   	pop    %ebx
 1eb:	5e                   	pop    %esi
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(const char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	56                   	push   %esi
 1f3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	83 ec 08             	sub    $0x8,%esp
 1f7:	6a 00                	push   $0x0
 1f9:	ff 75 08             	push   0x8(%ebp)
 1fc:	e8 e4 00 00 00       	call   2e5 <open>
  if(fd < 0)
 201:	83 c4 10             	add    $0x10,%esp
 204:	85 c0                	test   %eax,%eax
 206:	78 24                	js     22c <stat+0x3d>
 208:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20a:	83 ec 08             	sub    $0x8,%esp
 20d:	ff 75 0c             	push   0xc(%ebp)
 210:	50                   	push   %eax
 211:	e8 e7 00 00 00       	call   2fd <fstat>
 216:	89 c6                	mov    %eax,%esi
  close(fd);
 218:	89 1c 24             	mov    %ebx,(%esp)
 21b:	e8 ad 00 00 00       	call   2cd <close>
  return r;
 220:	83 c4 10             	add    $0x10,%esp
}
 223:	89 f0                	mov    %esi,%eax
 225:	8d 65 f8             	lea    -0x8(%ebp),%esp
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    
    return -1;
 22c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 231:	eb f0                	jmp    223 <stat+0x34>

00000233 <atoi>:

int
atoi(const char *s)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	53                   	push   %ebx
 237:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23a:	0f b6 02             	movzbl (%edx),%eax
 23d:	8d 48 d0             	lea    -0x30(%eax),%ecx
 240:	80 f9 09             	cmp    $0x9,%cl
 243:	77 24                	ja     269 <atoi+0x36>
  n = 0;
 245:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 24a:	83 c2 01             	add    $0x1,%edx
 24d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 250:	0f be c0             	movsbl %al,%eax
 253:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 257:	0f b6 02             	movzbl (%edx),%eax
 25a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 25d:	80 fb 09             	cmp    $0x9,%bl
 260:	76 e8                	jbe    24a <atoi+0x17>
  return n;
}
 262:	89 c8                	mov    %ecx,%eax
 264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 267:	c9                   	leave  
 268:	c3                   	ret    
  n = 0;
 269:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 26e:	eb f2                	jmp    262 <atoi+0x2f>

00000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
 275:	8b 75 08             	mov    0x8(%ebp),%esi
 278:	8b 55 0c             	mov    0xc(%ebp),%edx
 27b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 15                	jle    297 <memmove+0x27>
 282:	01 f3                	add    %esi,%ebx
  dst = vdst;
 284:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 286:	83 c2 01             	add    $0x1,%edx
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 290:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 293:	39 c3                	cmp    %eax,%ebx
 295:	75 ef                	jne    286 <memmove+0x16>
  return vdst;
}
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    

0000029d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29d:	b8 01 00 00 00       	mov    $0x1,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <exit>:
SYSCALL(exit)
 2a5:	b8 02 00 00 00       	mov    $0x2,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <wait>:
SYSCALL(wait)
 2ad:	b8 03 00 00 00       	mov    $0x3,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <pipe>:
SYSCALL(pipe)
 2b5:	b8 04 00 00 00       	mov    $0x4,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <read>:
SYSCALL(read)
 2bd:	b8 05 00 00 00       	mov    $0x5,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <write>:
SYSCALL(write)
 2c5:	b8 10 00 00 00       	mov    $0x10,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <close>:
SYSCALL(close)
 2cd:	b8 15 00 00 00       	mov    $0x15,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <kill>:
SYSCALL(kill)
 2d5:	b8 06 00 00 00       	mov    $0x6,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exec>:
SYSCALL(exec)
 2dd:	b8 07 00 00 00       	mov    $0x7,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <open>:
SYSCALL(open)
 2e5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <mknod>:
SYSCALL(mknod)
 2ed:	b8 11 00 00 00       	mov    $0x11,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <unlink>:
SYSCALL(unlink)
 2f5:	b8 12 00 00 00       	mov    $0x12,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <fstat>:
SYSCALL(fstat)
 2fd:	b8 08 00 00 00       	mov    $0x8,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <link>:
SYSCALL(link)
 305:	b8 13 00 00 00       	mov    $0x13,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <mkdir>:
SYSCALL(mkdir)
 30d:	b8 14 00 00 00       	mov    $0x14,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <chdir>:
SYSCALL(chdir)
 315:	b8 09 00 00 00       	mov    $0x9,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <dup>:
SYSCALL(dup)
 31d:	b8 0a 00 00 00       	mov    $0xa,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <getpid>:
SYSCALL(getpid)
 325:	b8 0b 00 00 00       	mov    $0xb,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <sbrk>:
SYSCALL(sbrk)
 32d:	b8 0c 00 00 00       	mov    $0xc,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <sleep>:
SYSCALL(sleep)
 335:	b8 0d 00 00 00       	mov    $0xd,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <uptime>:
SYSCALL(uptime)
 33d:	b8 0e 00 00 00       	mov    $0xe,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <slabtest>:
SYSCALL(slabtest)
 345:	b8 16 00 00 00       	mov    $0x16,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <ps>:
SYSCALL(ps)
 34d:	b8 17 00 00 00       	mov    $0x17,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	56                   	push   %esi
 35a:	53                   	push   %ebx
 35b:	83 ec 3c             	sub    $0x3c,%esp
 35e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 361:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 367:	74 79                	je     3e2 <printint+0x8d>
 369:	85 d2                	test   %edx,%edx
 36b:	79 75                	jns    3e2 <printint+0x8d>
    neg = 1;
    x = -xx;
 36d:	89 d1                	mov    %edx,%ecx
 36f:	f7 d9                	neg    %ecx
    neg = 1;
 371:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 378:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 37d:	89 df                	mov    %ebx,%edi
 37f:	83 c3 01             	add    $0x1,%ebx
 382:	89 c8                	mov    %ecx,%eax
 384:	ba 00 00 00 00       	mov    $0x0,%edx
 389:	f7 f6                	div    %esi
 38b:	0f b6 92 94 07 00 00 	movzbl 0x794(%edx),%edx
 392:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 396:	89 ca                	mov    %ecx,%edx
 398:	89 c1                	mov    %eax,%ecx
 39a:	39 d6                	cmp    %edx,%esi
 39c:	76 df                	jbe    37d <printint+0x28>
  if(neg)
 39e:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3a2:	74 08                	je     3ac <printint+0x57>
    buf[i++] = '-';
 3a4:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3a9:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3ac:	85 db                	test   %ebx,%ebx
 3ae:	7e 2a                	jle    3da <printint+0x85>
 3b0:	8d 7d d8             	lea    -0x28(%ebp),%edi
 3b3:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 3b7:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3ba:	0f b6 03             	movzbl (%ebx),%eax
 3bd:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3c0:	83 ec 04             	sub    $0x4,%esp
 3c3:	6a 01                	push   $0x1
 3c5:	56                   	push   %esi
 3c6:	ff 75 c4             	push   -0x3c(%ebp)
 3c9:	e8 f7 fe ff ff       	call   2c5 <write>
  while(--i >= 0)
 3ce:	89 d8                	mov    %ebx,%eax
 3d0:	83 eb 01             	sub    $0x1,%ebx
 3d3:	83 c4 10             	add    $0x10,%esp
 3d6:	39 f8                	cmp    %edi,%eax
 3d8:	75 e0                	jne    3ba <printint+0x65>
}
 3da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5f                   	pop    %edi
 3e0:	5d                   	pop    %ebp
 3e1:	c3                   	ret    
    x = xx;
 3e2:	89 d1                	mov    %edx,%ecx
  neg = 0;
 3e4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3eb:	eb 8b                	jmp    378 <printint+0x23>

000003ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	57                   	push   %edi
 3f1:	56                   	push   %esi
 3f2:	53                   	push   %ebx
 3f3:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f6:	8b 75 0c             	mov    0xc(%ebp),%esi
 3f9:	0f b6 1e             	movzbl (%esi),%ebx
 3fc:	84 db                	test   %bl,%bl
 3fe:	0f 84 9f 01 00 00    	je     5a3 <printf+0x1b6>
 404:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 45 10             	lea    0x10(%ebp),%eax
 40a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 40d:	bf 00 00 00 00       	mov    $0x0,%edi
 412:	eb 2d                	jmp    441 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 414:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 417:	83 ec 04             	sub    $0x4,%esp
 41a:	6a 01                	push   $0x1
 41c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 41f:	50                   	push   %eax
 420:	ff 75 08             	push   0x8(%ebp)
 423:	e8 9d fe ff ff       	call   2c5 <write>
        putc(fd, c);
 428:	83 c4 10             	add    $0x10,%esp
 42b:	eb 05                	jmp    432 <printf+0x45>
      }
    } else if(state == '%'){
 42d:	83 ff 25             	cmp    $0x25,%edi
 430:	74 1f                	je     451 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 432:	83 c6 01             	add    $0x1,%esi
 435:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 439:	84 db                	test   %bl,%bl
 43b:	0f 84 62 01 00 00    	je     5a3 <printf+0x1b6>
    c = fmt[i] & 0xff;
 441:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 444:	85 ff                	test   %edi,%edi
 446:	75 e5                	jne    42d <printf+0x40>
      if(c == '%'){
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	75 c7                	jne    414 <printf+0x27>
        state = '%';
 44d:	89 c7                	mov    %eax,%edi
 44f:	eb e1                	jmp    432 <printf+0x45>
      if(c == 'd'){
 451:	83 f8 25             	cmp    $0x25,%eax
 454:	0f 84 f2 00 00 00    	je     54c <printf+0x15f>
 45a:	8d 50 9d             	lea    -0x63(%eax),%edx
 45d:	83 fa 15             	cmp    $0x15,%edx
 460:	0f 87 07 01 00 00    	ja     56d <printf+0x180>
 466:	0f 87 01 01 00 00    	ja     56d <printf+0x180>
 46c:	ff 24 95 3c 07 00 00 	jmp    *0x73c(,%edx,4)
        printint(fd, *ap, 10, 1);
 473:	83 ec 0c             	sub    $0xc,%esp
 476:	6a 01                	push   $0x1
 478:	b9 0a 00 00 00       	mov    $0xa,%ecx
 47d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 480:	8b 17                	mov    (%edi),%edx
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	e8 cb fe ff ff       	call   355 <printint>
        ap++;
 48a:	89 f8                	mov    %edi,%eax
 48c:	83 c0 04             	add    $0x4,%eax
 48f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 492:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 495:	bf 00 00 00 00       	mov    $0x0,%edi
 49a:	eb 96                	jmp    432 <printf+0x45>
        printint(fd, *ap, 16, 0);
 49c:	83 ec 0c             	sub    $0xc,%esp
 49f:	6a 00                	push   $0x0
 4a1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a9:	8b 17                	mov    (%edi),%edx
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	e8 a2 fe ff ff       	call   355 <printint>
        ap++;
 4b3:	89 f8                	mov    %edi,%eax
 4b5:	83 c0 04             	add    $0x4,%eax
 4b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4bb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4be:	bf 00 00 00 00       	mov    $0x0,%edi
 4c3:	e9 6a ff ff ff       	jmp    432 <printf+0x45>
        s = (char*)*ap;
 4c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4cb:	8b 01                	mov    (%ecx),%eax
        ap++;
 4cd:	83 c1 04             	add    $0x4,%ecx
 4d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4d3:	85 c0                	test   %eax,%eax
 4d5:	74 13                	je     4ea <printf+0xfd>
        s = (char*)*ap;
 4d7:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4d9:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4dc:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4e1:	84 c0                	test   %al,%al
 4e3:	75 0f                	jne    4f4 <printf+0x107>
 4e5:	e9 48 ff ff ff       	jmp    432 <printf+0x45>
          s = "(null)";
 4ea:	bb 34 07 00 00       	mov    $0x734,%ebx
        while(*s != 0){
 4ef:	b8 28 00 00 00       	mov    $0x28,%eax
 4f4:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4f7:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4fa:	83 ec 04             	sub    $0x4,%esp
 4fd:	6a 01                	push   $0x1
 4ff:	8d 45 e7             	lea    -0x19(%ebp),%eax
 502:	50                   	push   %eax
 503:	57                   	push   %edi
 504:	e8 bc fd ff ff       	call   2c5 <write>
          s++;
 509:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 50c:	0f b6 03             	movzbl (%ebx),%eax
 50f:	83 c4 10             	add    $0x10,%esp
 512:	84 c0                	test   %al,%al
 514:	75 e1                	jne    4f7 <printf+0x10a>
      state = 0;
 516:	bf 00 00 00 00       	mov    $0x0,%edi
 51b:	e9 12 ff ff ff       	jmp    432 <printf+0x45>
        putc(fd, *ap);
 520:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 523:	8b 07                	mov    (%edi),%eax
 525:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	6a 01                	push   $0x1
 52d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 530:	50                   	push   %eax
 531:	ff 75 08             	push   0x8(%ebp)
 534:	e8 8c fd ff ff       	call   2c5 <write>
        ap++;
 539:	83 c7 04             	add    $0x4,%edi
 53c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 53f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 542:	bf 00 00 00 00       	mov    $0x0,%edi
 547:	e9 e6 fe ff ff       	jmp    432 <printf+0x45>
        putc(fd, c);
 54c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 54f:	83 ec 04             	sub    $0x4,%esp
 552:	6a 01                	push   $0x1
 554:	8d 45 e7             	lea    -0x19(%ebp),%eax
 557:	50                   	push   %eax
 558:	ff 75 08             	push   0x8(%ebp)
 55b:	e8 65 fd ff ff       	call   2c5 <write>
 560:	83 c4 10             	add    $0x10,%esp
      state = 0;
 563:	bf 00 00 00 00       	mov    $0x0,%edi
 568:	e9 c5 fe ff ff       	jmp    432 <printf+0x45>
        putc(fd, '%');
 56d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 571:	83 ec 04             	sub    $0x4,%esp
 574:	6a 01                	push   $0x1
 576:	8d 45 e7             	lea    -0x19(%ebp),%eax
 579:	50                   	push   %eax
 57a:	ff 75 08             	push   0x8(%ebp)
 57d:	e8 43 fd ff ff       	call   2c5 <write>
        putc(fd, c);
 582:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 585:	83 c4 0c             	add    $0xc,%esp
 588:	6a 01                	push   $0x1
 58a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 58d:	50                   	push   %eax
 58e:	ff 75 08             	push   0x8(%ebp)
 591:	e8 2f fd ff ff       	call   2c5 <write>
        putc(fd, c);
 596:	83 c4 10             	add    $0x10,%esp
      state = 0;
 599:	bf 00 00 00 00       	mov    $0x0,%edi
 59e:	e9 8f fe ff ff       	jmp    432 <printf+0x45>
    }
  }
}
 5a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a6:	5b                   	pop    %ebx
 5a7:	5e                   	pop    %esi
 5a8:	5f                   	pop    %edi
 5a9:	5d                   	pop    %ebp
 5aa:	c3                   	ret    

000005ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ab:	55                   	push   %ebp
 5ac:	89 e5                	mov    %esp,%ebp
 5ae:	57                   	push   %edi
 5af:	56                   	push   %esi
 5b0:	53                   	push   %ebx
 5b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b7:	a1 08 0a 00 00       	mov    0xa08,%eax
 5bc:	eb 0c                	jmp    5ca <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5be:	8b 10                	mov    (%eax),%edx
 5c0:	39 c2                	cmp    %eax,%edx
 5c2:	77 04                	ja     5c8 <free+0x1d>
 5c4:	39 ca                	cmp    %ecx,%edx
 5c6:	77 10                	ja     5d8 <free+0x2d>
{
 5c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	39 c8                	cmp    %ecx,%eax
 5cc:	73 f0                	jae    5be <free+0x13>
 5ce:	8b 10                	mov    (%eax),%edx
 5d0:	39 ca                	cmp    %ecx,%edx
 5d2:	77 04                	ja     5d8 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	39 c2                	cmp    %eax,%edx
 5d6:	77 f0                	ja     5c8 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5db:	8b 10                	mov    (%eax),%edx
 5dd:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5e0:	39 fa                	cmp    %edi,%edx
 5e2:	74 19                	je     5fd <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5e4:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5e7:	8b 50 04             	mov    0x4(%eax),%edx
 5ea:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5ed:	39 f1                	cmp    %esi,%ecx
 5ef:	74 18                	je     609 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5f1:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 5f3:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 5f8:	5b                   	pop    %ebx
 5f9:	5e                   	pop    %esi
 5fa:	5f                   	pop    %edi
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5fd:	03 72 04             	add    0x4(%edx),%esi
 600:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 603:	8b 10                	mov    (%eax),%edx
 605:	8b 12                	mov    (%edx),%edx
 607:	eb db                	jmp    5e4 <free+0x39>
    p->s.size += bp->s.size;
 609:	03 53 fc             	add    -0x4(%ebx),%edx
 60c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 60f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 612:	eb dd                	jmp    5f1 <free+0x46>

00000614 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	57                   	push   %edi
 618:	56                   	push   %esi
 619:	53                   	push   %ebx
 61a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	8d 58 07             	lea    0x7(%eax),%ebx
 623:	c1 eb 03             	shr    $0x3,%ebx
 626:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 629:	8b 15 08 0a 00 00    	mov    0xa08,%edx
 62f:	85 d2                	test   %edx,%edx
 631:	74 1c                	je     64f <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 633:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 635:	8b 48 04             	mov    0x4(%eax),%ecx
 638:	39 cb                	cmp    %ecx,%ebx
 63a:	76 38                	jbe    674 <malloc+0x60>
 63c:	be 00 10 00 00       	mov    $0x1000,%esi
 641:	39 f3                	cmp    %esi,%ebx
 643:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 646:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 64d:	eb 72                	jmp    6c1 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 64f:	c7 05 08 0a 00 00 0c 	movl   $0xa0c,0xa08
 656:	0a 00 00 
 659:	c7 05 0c 0a 00 00 0c 	movl   $0xa0c,0xa0c
 660:	0a 00 00 
    base.s.size = 0;
 663:	c7 05 10 0a 00 00 00 	movl   $0x0,0xa10
 66a:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66d:	b8 0c 0a 00 00       	mov    $0xa0c,%eax
 672:	eb c8                	jmp    63c <malloc+0x28>
      if(p->s.size == nunits)
 674:	39 cb                	cmp    %ecx,%ebx
 676:	74 1e                	je     696 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 678:	29 d9                	sub    %ebx,%ecx
 67a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 67d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 680:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 683:	89 15 08 0a 00 00    	mov    %edx,0xa08
      return (void*)(p + 1);
 689:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 68c:	89 d0                	mov    %edx,%eax
 68e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 691:	5b                   	pop    %ebx
 692:	5e                   	pop    %esi
 693:	5f                   	pop    %edi
 694:	5d                   	pop    %ebp
 695:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 696:	8b 08                	mov    (%eax),%ecx
 698:	89 0a                	mov    %ecx,(%edx)
 69a:	eb e7                	jmp    683 <malloc+0x6f>
  hp->s.size = nu;
 69c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 69f:	83 ec 0c             	sub    $0xc,%esp
 6a2:	83 c0 08             	add    $0x8,%eax
 6a5:	50                   	push   %eax
 6a6:	e8 00 ff ff ff       	call   5ab <free>
  return freep;
 6ab:	8b 15 08 0a 00 00    	mov    0xa08,%edx
      if((p = morecore(nunits)) == 0)
 6b1:	83 c4 10             	add    $0x10,%esp
 6b4:	85 d2                	test   %edx,%edx
 6b6:	74 d4                	je     68c <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ba:	8b 48 04             	mov    0x4(%eax),%ecx
 6bd:	39 d9                	cmp    %ebx,%ecx
 6bf:	73 b3                	jae    674 <malloc+0x60>
    if(p == freep)
 6c1:	89 c2                	mov    %eax,%edx
 6c3:	39 05 08 0a 00 00    	cmp    %eax,0xa08
 6c9:	75 ed                	jne    6b8 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 6cb:	83 ec 0c             	sub    $0xc,%esp
 6ce:	57                   	push   %edi
 6cf:	e8 59 fc ff ff       	call   32d <sbrk>
  if(p == (char*)-1)
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6da:	75 c0                	jne    69c <malloc+0x88>
        return 0;
 6dc:	ba 00 00 00 00       	mov    $0x0,%edx
 6e1:	eb a9                	jmp    68c <malloc+0x78>
