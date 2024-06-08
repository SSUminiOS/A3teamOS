
user/_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 f6 01 00 00       	call   210 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7f 05                	jg     23 <main+0x23>
    sleep(5);  // Let child exit before parent.
  exit();
  1e:	e8 f5 01 00 00       	call   218 <exit>
    sleep(5);  // Let child exit before parent.
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	6a 05                	push   $0x5
  28:	e8 7b 02 00 00       	call   2a8 <sleep>
  2d:	83 c4 10             	add    $0x10,%esp
  30:	eb ec                	jmp    1e <main+0x1e>

00000032 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  32:	f3 0f 1e fb          	endbr32 
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	53                   	push   %ebx
  3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40:	b8 00 00 00 00       	mov    $0x0,%eax
  45:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  49:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  4c:	83 c0 01             	add    $0x1,%eax
  4f:	84 d2                	test   %dl,%dl
  51:	75 f2                	jne    45 <strcpy+0x13>
    ;
  return os;
}
  53:	89 c8                	mov    %ecx,%eax
  55:	5b                   	pop    %ebx
  56:	5d                   	pop    %ebp
  57:	c3                   	ret    

00000058 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  58:	f3 0f 1e fb          	endbr32 
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  62:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  65:	0f b6 01             	movzbl (%ecx),%eax
  68:	84 c0                	test   %al,%al
  6a:	74 11                	je     7d <strcmp+0x25>
  6c:	38 02                	cmp    %al,(%edx)
  6e:	75 0d                	jne    7d <strcmp+0x25>
    p++, q++;
  70:	83 c1 01             	add    $0x1,%ecx
  73:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  76:	0f b6 01             	movzbl (%ecx),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 ef                	jne    6c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  7d:	0f b6 c0             	movzbl %al,%eax
  80:	0f b6 12             	movzbl (%edx),%edx
  83:	29 d0                	sub    %edx,%eax
}
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    

00000087 <strlen>:

uint
strlen(const char *s)
{
  87:	f3 0f 1e fb          	endbr32 
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  91:	80 3a 00             	cmpb   $0x0,(%edx)
  94:	74 14                	je     aa <strlen+0x23>
  96:	b8 00 00 00 00       	mov    $0x0,%eax
  9b:	83 c0 01             	add    $0x1,%eax
  9e:	89 c1                	mov    %eax,%ecx
  a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a4:	75 f5                	jne    9b <strlen+0x14>
    ;
  return n;
}
  a6:	89 c8                	mov    %ecx,%eax
  a8:	5d                   	pop    %ebp
  a9:	c3                   	ret    
  for(n = 0; s[n]; n++)
  aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  af:	eb f5                	jmp    a6 <strlen+0x1f>

000000b1 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b1:	f3 0f 1e fb          	endbr32 
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bc:	89 d7                	mov    %edx,%edi
  be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	fc                   	cld    
  c5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c7:	89 d0                	mov    %edx,%eax
  c9:	5f                   	pop    %edi
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	f3 0f 1e fb          	endbr32 
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	84 d2                	test   %dl,%dl
  df:	74 15                	je     f6 <strchr+0x2a>
    if(*s == c)
  e1:	38 d1                	cmp    %dl,%cl
  e3:	74 0f                	je     f4 <strchr+0x28>
  for(; *s; s++)
  e5:	83 c0 01             	add    $0x1,%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	84 d2                	test   %dl,%dl
  ed:	75 f2                	jne    e1 <strchr+0x15>
      return (char*)s;
  return 0;
  ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f4:	5d                   	pop    %ebp
  f5:	c3                   	ret    
  return 0;
  f6:	b8 00 00 00 00       	mov    $0x0,%eax
  fb:	eb f7                	jmp    f4 <strchr+0x28>

000000fd <gets>:

char*
gets(char *buf, int max)
{
  fd:	f3 0f 1e fb          	endbr32 
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	56                   	push   %esi
 106:	53                   	push   %ebx
 107:	83 ec 2c             	sub    $0x2c,%esp
 10a:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10d:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 112:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 115:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 118:	83 c3 01             	add    $0x1,%ebx
 11b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 11e:	7d 27                	jge    147 <gets+0x4a>
    cc = read(0, &c, 1);
 120:	83 ec 04             	sub    $0x4,%esp
 123:	6a 01                	push   $0x1
 125:	57                   	push   %edi
 126:	6a 00                	push   $0x0
 128:	e8 03 01 00 00       	call   230 <read>
    if(cc < 1)
 12d:	83 c4 10             	add    $0x10,%esp
 130:	85 c0                	test   %eax,%eax
 132:	7e 13                	jle    147 <gets+0x4a>
      break;
    buf[i++] = c;
 134:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 138:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 13c:	3c 0a                	cmp    $0xa,%al
 13e:	74 04                	je     144 <gets+0x47>
 140:	3c 0d                	cmp    $0xd,%al
 142:	75 d1                	jne    115 <gets+0x18>
  for(i=0; i+1 < max; ){
 144:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 147:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 14a:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 14e:	89 f0                	mov    %esi,%eax
 150:	8d 65 f4             	lea    -0xc(%ebp),%esp
 153:	5b                   	pop    %ebx
 154:	5e                   	pop    %esi
 155:	5f                   	pop    %edi
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    

00000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	f3 0f 1e fb          	endbr32 
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	56                   	push   %esi
 160:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	6a 00                	push   $0x0
 166:	ff 75 08             	pushl  0x8(%ebp)
 169:	e8 ea 00 00 00       	call   258 <open>
  if(fd < 0)
 16e:	83 c4 10             	add    $0x10,%esp
 171:	85 c0                	test   %eax,%eax
 173:	78 24                	js     199 <stat+0x41>
 175:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 177:	83 ec 08             	sub    $0x8,%esp
 17a:	ff 75 0c             	pushl  0xc(%ebp)
 17d:	50                   	push   %eax
 17e:	e8 ed 00 00 00       	call   270 <fstat>
 183:	89 c6                	mov    %eax,%esi
  close(fd);
 185:	89 1c 24             	mov    %ebx,(%esp)
 188:	e8 b3 00 00 00       	call   240 <close>
  return r;
 18d:	83 c4 10             	add    $0x10,%esp
}
 190:	89 f0                	mov    %esi,%eax
 192:	8d 65 f8             	lea    -0x8(%ebp),%esp
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
    return -1;
 199:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19e:	eb f0                	jmp    190 <stat+0x38>

000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	53                   	push   %ebx
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ab:	0f b6 02             	movzbl (%edx),%eax
 1ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1b1:	80 f9 09             	cmp    $0x9,%cl
 1b4:	77 22                	ja     1d8 <atoi+0x38>
  n = 0;
 1b6:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1bb:	83 c2 01             	add    $0x1,%edx
 1be:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1c1:	0f be c0             	movsbl %al,%eax
 1c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1c8:	0f b6 02             	movzbl (%edx),%eax
 1cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ce:	80 fb 09             	cmp    $0x9,%bl
 1d1:	76 e8                	jbe    1bb <atoi+0x1b>
  return n;
}
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	5b                   	pop    %ebx
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    
  n = 0;
 1d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1dd:	eb f4                	jmp    1d3 <atoi+0x33>

000001df <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1df:	f3 0f 1e fb          	endbr32 
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	56                   	push   %esi
 1e7:	53                   	push   %ebx
 1e8:	8b 75 08             	mov    0x8(%ebp),%esi
 1eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f1:	85 db                	test   %ebx,%ebx
 1f3:	7e 15                	jle    20a <memmove+0x2b>
 1f5:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1f7:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1f9:	83 c2 01             	add    $0x1,%edx
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 203:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 206:	39 c3                	cmp    %eax,%ebx
 208:	75 ef                	jne    1f9 <memmove+0x1a>
  return vdst;
}
 20a:	89 f0                	mov    %esi,%eax
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    

00000210 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 210:	b8 01 00 00 00       	mov    $0x1,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <exit>:
SYSCALL(exit)
 218:	b8 02 00 00 00       	mov    $0x2,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <wait>:
SYSCALL(wait)
 220:	b8 03 00 00 00       	mov    $0x3,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <pipe>:
SYSCALL(pipe)
 228:	b8 04 00 00 00       	mov    $0x4,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <read>:
SYSCALL(read)
 230:	b8 05 00 00 00       	mov    $0x5,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <write>:
SYSCALL(write)
 238:	b8 10 00 00 00       	mov    $0x10,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <close>:
SYSCALL(close)
 240:	b8 15 00 00 00       	mov    $0x15,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <kill>:
SYSCALL(kill)
 248:	b8 06 00 00 00       	mov    $0x6,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <exec>:
SYSCALL(exec)
 250:	b8 07 00 00 00       	mov    $0x7,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <open>:
SYSCALL(open)
 258:	b8 0f 00 00 00       	mov    $0xf,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <mknod>:
SYSCALL(mknod)
 260:	b8 11 00 00 00       	mov    $0x11,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <unlink>:
SYSCALL(unlink)
 268:	b8 12 00 00 00       	mov    $0x12,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <fstat>:
SYSCALL(fstat)
 270:	b8 08 00 00 00       	mov    $0x8,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <link>:
SYSCALL(link)
 278:	b8 13 00 00 00       	mov    $0x13,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <mkdir>:
SYSCALL(mkdir)
 280:	b8 14 00 00 00       	mov    $0x14,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <chdir>:
SYSCALL(chdir)
 288:	b8 09 00 00 00       	mov    $0x9,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <dup>:
SYSCALL(dup)
 290:	b8 0a 00 00 00       	mov    $0xa,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <getpid>:
SYSCALL(getpid)
 298:	b8 0b 00 00 00       	mov    $0xb,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <sbrk>:
SYSCALL(sbrk)
 2a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <sleep>:
SYSCALL(sleep)
 2a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <uptime>:
SYSCALL(uptime)
 2b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <slabtest>:
SYSCALL(slabtest)
 2b8:	b8 16 00 00 00       	mov    $0x16,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <ps>:
SYSCALL(ps)
 2c0:	b8 17 00 00 00       	mov    $0x17,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	53                   	push   %ebx
 2ce:	83 ec 3c             	sub    $0x3c,%esp
 2d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2d4:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2da:	74 77                	je     353 <printint+0x8b>
 2dc:	85 d2                	test   %edx,%edx
 2de:	79 73                	jns    353 <printint+0x8b>
    neg = 1;
    x = -xx;
 2e0:	f7 db                	neg    %ebx
    neg = 1;
 2e2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e9:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 2ee:	89 f7                	mov    %esi,%edi
 2f0:	83 c6 01             	add    $0x1,%esi
 2f3:	89 d8                	mov    %ebx,%eax
 2f5:	ba 00 00 00 00       	mov    $0x0,%edx
 2fa:	f7 f1                	div    %ecx
 2fc:	0f b6 92 7c 06 00 00 	movzbl 0x67c(%edx),%edx
 303:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 307:	89 da                	mov    %ebx,%edx
 309:	89 c3                	mov    %eax,%ebx
 30b:	39 d1                	cmp    %edx,%ecx
 30d:	76 df                	jbe    2ee <printint+0x26>
  if(neg)
 30f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 313:	74 08                	je     31d <printint+0x55>
    buf[i++] = '-';
 315:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 31a:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 31d:	85 f6                	test   %esi,%esi
 31f:	7e 2a                	jle    34b <printint+0x83>
 321:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 325:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 328:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 32b:	0f b6 03             	movzbl (%ebx),%eax
 32e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 331:	83 ec 04             	sub    $0x4,%esp
 334:	6a 01                	push   $0x1
 336:	56                   	push   %esi
 337:	ff 75 c4             	pushl  -0x3c(%ebp)
 33a:	e8 f9 fe ff ff       	call   238 <write>
  while(--i >= 0)
 33f:	89 d8                	mov    %ebx,%eax
 341:	83 eb 01             	sub    $0x1,%ebx
 344:	83 c4 10             	add    $0x10,%esp
 347:	39 f8                	cmp    %edi,%eax
 349:	75 e0                	jne    32b <printint+0x63>
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
  neg = 0;
 353:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 35a:	eb 8d                	jmp    2e9 <printint+0x21>

0000035c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35c:	f3 0f 1e fb          	endbr32 
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 369:	8b 75 0c             	mov    0xc(%ebp),%esi
 36c:	0f b6 1e             	movzbl (%esi),%ebx
 36f:	84 db                	test   %bl,%bl
 371:	0f 84 ab 01 00 00    	je     522 <printf+0x1c6>
 377:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 37a:	8d 45 10             	lea    0x10(%ebp),%eax
 37d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 380:	bf 00 00 00 00       	mov    $0x0,%edi
 385:	eb 2d                	jmp    3b4 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 387:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	6a 01                	push   $0x1
 38f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 392:	50                   	push   %eax
 393:	ff 75 08             	pushl  0x8(%ebp)
 396:	e8 9d fe ff ff       	call   238 <write>
        putc(fd, c);
 39b:	83 c4 10             	add    $0x10,%esp
 39e:	eb 05                	jmp    3a5 <printf+0x49>
      }
    } else if(state == '%'){
 3a0:	83 ff 25             	cmp    $0x25,%edi
 3a3:	74 22                	je     3c7 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3a5:	83 c6 01             	add    $0x1,%esi
 3a8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3ac:	84 db                	test   %bl,%bl
 3ae:	0f 84 6e 01 00 00    	je     522 <printf+0x1c6>
    c = fmt[i] & 0xff;
 3b4:	0f be d3             	movsbl %bl,%edx
 3b7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3ba:	85 ff                	test   %edi,%edi
 3bc:	75 e2                	jne    3a0 <printf+0x44>
      if(c == '%'){
 3be:	83 f8 25             	cmp    $0x25,%eax
 3c1:	75 c4                	jne    387 <printf+0x2b>
        state = '%';
 3c3:	89 c7                	mov    %eax,%edi
 3c5:	eb de                	jmp    3a5 <printf+0x49>
      if(c == 'd'){
 3c7:	83 f8 64             	cmp    $0x64,%eax
 3ca:	74 59                	je     425 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3cc:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3d2:	83 fa 70             	cmp    $0x70,%edx
 3d5:	74 7a                	je     451 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3d7:	83 f8 73             	cmp    $0x73,%eax
 3da:	0f 84 9d 00 00 00    	je     47d <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e0:	83 f8 63             	cmp    $0x63,%eax
 3e3:	0f 84 ec 00 00 00    	je     4d5 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3e9:	83 f8 25             	cmp    $0x25,%eax
 3ec:	0f 84 0f 01 00 00    	je     501 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3f2:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3f6:	83 ec 04             	sub    $0x4,%esp
 3f9:	6a 01                	push   $0x1
 3fb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3fe:	50                   	push   %eax
 3ff:	ff 75 08             	pushl  0x8(%ebp)
 402:	e8 31 fe ff ff       	call   238 <write>
        putc(fd, c);
 407:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 40a:	83 c4 0c             	add    $0xc,%esp
 40d:	6a 01                	push   $0x1
 40f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 412:	50                   	push   %eax
 413:	ff 75 08             	pushl  0x8(%ebp)
 416:	e8 1d fe ff ff       	call   238 <write>
        putc(fd, c);
 41b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 41e:	bf 00 00 00 00       	mov    $0x0,%edi
 423:	eb 80                	jmp    3a5 <printf+0x49>
        printint(fd, *ap, 10, 1);
 425:	83 ec 0c             	sub    $0xc,%esp
 428:	6a 01                	push   $0x1
 42a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 42f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 432:	8b 17                	mov    (%edi),%edx
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	e8 8c fe ff ff       	call   2c8 <printint>
        ap++;
 43c:	89 f8                	mov    %edi,%eax
 43e:	83 c0 04             	add    $0x4,%eax
 441:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 444:	83 c4 10             	add    $0x10,%esp
      state = 0;
 447:	bf 00 00 00 00       	mov    $0x0,%edi
 44c:	e9 54 ff ff ff       	jmp    3a5 <printf+0x49>
        printint(fd, *ap, 16, 0);
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	6a 00                	push   $0x0
 456:	b9 10 00 00 00       	mov    $0x10,%ecx
 45b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 45e:	8b 17                	mov    (%edi),%edx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	e8 60 fe ff ff       	call   2c8 <printint>
        ap++;
 468:	89 f8                	mov    %edi,%eax
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 470:	83 c4 10             	add    $0x10,%esp
      state = 0;
 473:	bf 00 00 00 00       	mov    $0x0,%edi
 478:	e9 28 ff ff ff       	jmp    3a5 <printf+0x49>
        s = (char*)*ap;
 47d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 480:	8b 01                	mov    (%ecx),%eax
        ap++;
 482:	83 c1 04             	add    $0x4,%ecx
 485:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 488:	85 c0                	test   %eax,%eax
 48a:	74 13                	je     49f <printf+0x143>
        s = (char*)*ap;
 48c:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 48e:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 491:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 496:	84 c0                	test   %al,%al
 498:	75 0f                	jne    4a9 <printf+0x14d>
 49a:	e9 06 ff ff ff       	jmp    3a5 <printf+0x49>
          s = "(null)";
 49f:	bb 74 06 00 00       	mov    $0x674,%ebx
        while(*s != 0){
 4a4:	b8 28 00 00 00       	mov    $0x28,%eax
 4a9:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4af:	83 ec 04             	sub    $0x4,%esp
 4b2:	6a 01                	push   $0x1
 4b4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b7:	50                   	push   %eax
 4b8:	57                   	push   %edi
 4b9:	e8 7a fd ff ff       	call   238 <write>
          s++;
 4be:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4c1:	0f b6 03             	movzbl (%ebx),%eax
 4c4:	83 c4 10             	add    $0x10,%esp
 4c7:	84 c0                	test   %al,%al
 4c9:	75 e1                	jne    4ac <printf+0x150>
      state = 0;
 4cb:	bf 00 00 00 00       	mov    $0x0,%edi
 4d0:	e9 d0 fe ff ff       	jmp    3a5 <printf+0x49>
        putc(fd, *ap);
 4d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d8:	8b 07                	mov    (%edi),%eax
 4da:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4dd:	83 ec 04             	sub    $0x4,%esp
 4e0:	6a 01                	push   $0x1
 4e2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 4a fd ff ff       	call   238 <write>
        ap++;
 4ee:	83 c7 04             	add    $0x4,%edi
 4f1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4f4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f7:	bf 00 00 00 00       	mov    $0x0,%edi
 4fc:	e9 a4 fe ff ff       	jmp    3a5 <printf+0x49>
        putc(fd, c);
 501:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 504:	83 ec 04             	sub    $0x4,%esp
 507:	6a 01                	push   $0x1
 509:	8d 45 e7             	lea    -0x19(%ebp),%eax
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 23 fd ff ff       	call   238 <write>
 515:	83 c4 10             	add    $0x10,%esp
      state = 0;
 518:	bf 00 00 00 00       	mov    $0x0,%edi
 51d:	e9 83 fe ff ff       	jmp    3a5 <printf+0x49>
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
 52a:	f3 0f 1e fb          	endbr32 
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	57                   	push   %edi
 532:	56                   	push   %esi
 533:	53                   	push   %ebx
 534:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 537:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 53a:	a1 e4 08 00 00       	mov    0x8e4,%eax
 53f:	eb 0c                	jmp    54d <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 541:	8b 10                	mov    (%eax),%edx
 543:	39 c2                	cmp    %eax,%edx
 545:	77 04                	ja     54b <free+0x21>
 547:	39 ca                	cmp    %ecx,%edx
 549:	77 10                	ja     55b <free+0x31>
{
 54b:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 54d:	39 c8                	cmp    %ecx,%eax
 54f:	73 f0                	jae    541 <free+0x17>
 551:	8b 10                	mov    (%eax),%edx
 553:	39 ca                	cmp    %ecx,%edx
 555:	77 04                	ja     55b <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 557:	39 c2                	cmp    %eax,%edx
 559:	77 f0                	ja     54b <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 55b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55e:	8b 10                	mov    (%eax),%edx
 560:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 563:	39 fa                	cmp    %edi,%edx
 565:	74 19                	je     580 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 567:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 56a:	8b 50 04             	mov    0x4(%eax),%edx
 56d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 570:	39 f1                	cmp    %esi,%ecx
 572:	74 1b                	je     58f <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 574:	89 08                	mov    %ecx,(%eax)
  freep = p;
 576:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 57b:	5b                   	pop    %ebx
 57c:	5e                   	pop    %esi
 57d:	5f                   	pop    %edi
 57e:	5d                   	pop    %ebp
 57f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 580:	03 72 04             	add    0x4(%edx),%esi
 583:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 586:	8b 10                	mov    (%eax),%edx
 588:	8b 12                	mov    (%edx),%edx
 58a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 58d:	eb db                	jmp    56a <free+0x40>
    p->s.size += bp->s.size;
 58f:	03 53 fc             	add    -0x4(%ebx),%edx
 592:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 595:	8b 53 f8             	mov    -0x8(%ebx),%edx
 598:	89 10                	mov    %edx,(%eax)
 59a:	eb da                	jmp    576 <free+0x4c>

0000059c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 59c:	f3 0f 1e fb          	endbr32 
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	8d 58 07             	lea    0x7(%eax),%ebx
 5af:	c1 eb 03             	shr    $0x3,%ebx
 5b2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b5:	8b 15 e4 08 00 00    	mov    0x8e4,%edx
 5bb:	85 d2                	test   %edx,%edx
 5bd:	74 20                	je     5df <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5bf:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c1:	8b 48 04             	mov    0x4(%eax),%ecx
 5c4:	39 cb                	cmp    %ecx,%ebx
 5c6:	76 3c                	jbe    604 <malloc+0x68>
 5c8:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5ce:	be 00 10 00 00       	mov    $0x1000,%esi
 5d3:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5d6:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5dd:	eb 72                	jmp    651 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 5df:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 5e6:	08 00 00 
 5e9:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 5f0:	08 00 00 
    base.s.size = 0;
 5f3:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 5fa:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fd:	b8 e8 08 00 00       	mov    $0x8e8,%eax
 602:	eb c4                	jmp    5c8 <malloc+0x2c>
      if(p->s.size == nunits)
 604:	39 cb                	cmp    %ecx,%ebx
 606:	74 1e                	je     626 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 608:	29 d9                	sub    %ebx,%ecx
 60a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 60d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 610:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 613:	89 15 e4 08 00 00    	mov    %edx,0x8e4
      return (void*)(p + 1);
 619:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 61c:	89 d0                	mov    %edx,%eax
 61e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 621:	5b                   	pop    %ebx
 622:	5e                   	pop    %esi
 623:	5f                   	pop    %edi
 624:	5d                   	pop    %ebp
 625:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 626:	8b 08                	mov    (%eax),%ecx
 628:	89 0a                	mov    %ecx,(%edx)
 62a:	eb e7                	jmp    613 <malloc+0x77>
  hp->s.size = nu;
 62c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 62f:	83 ec 0c             	sub    $0xc,%esp
 632:	83 c0 08             	add    $0x8,%eax
 635:	50                   	push   %eax
 636:	e8 ef fe ff ff       	call   52a <free>
  return freep;
 63b:	8b 15 e4 08 00 00    	mov    0x8e4,%edx
      if((p = morecore(nunits)) == 0)
 641:	83 c4 10             	add    $0x10,%esp
 644:	85 d2                	test   %edx,%edx
 646:	74 d4                	je     61c <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 648:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 64a:	8b 48 04             	mov    0x4(%eax),%ecx
 64d:	39 d9                	cmp    %ebx,%ecx
 64f:	73 b3                	jae    604 <malloc+0x68>
    if(p == freep)
 651:	89 c2                	mov    %eax,%edx
 653:	39 05 e4 08 00 00    	cmp    %eax,0x8e4
 659:	75 ed                	jne    648 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	57                   	push   %edi
 65f:	e8 3c fc ff ff       	call   2a0 <sbrk>
  if(p == (char*)-1)
 664:	83 c4 10             	add    $0x10,%esp
 667:	83 f8 ff             	cmp    $0xffffffff,%eax
 66a:	75 c0                	jne    62c <malloc+0x90>
        return 0;
 66c:	ba 00 00 00 00       	mov    $0x0,%edx
 671:	eb a9                	jmp    61c <malloc+0x80>
