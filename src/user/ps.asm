
user/_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
	ps();
  15:	e8 a2 02 00 00       	call   2bc <ps>
	printf(1, "ps\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 70 06 00 00       	push   $0x670
  22:	6a 01                	push   $0x1
  24:	e8 2f 03 00 00       	call   358 <printf>
    exit();
  29:	e8 e6 01 00 00       	call   214 <exit>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2e:	f3 0f 1e fb          	endbr32 
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
  41:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  45:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  48:	83 c0 01             	add    $0x1,%eax
  4b:	84 d2                	test   %dl,%dl
  4d:	75 f2                	jne    41 <strcpy+0x13>
    ;
  return os;
}
  4f:	89 c8                	mov    %ecx,%eax
  51:	5b                   	pop    %ebx
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    

00000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	f3 0f 1e fb          	endbr32 
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  61:	0f b6 01             	movzbl (%ecx),%eax
  64:	84 c0                	test   %al,%al
  66:	74 11                	je     79 <strcmp+0x25>
  68:	38 02                	cmp    %al,(%edx)
  6a:	75 0d                	jne    79 <strcmp+0x25>
    p++, q++;
  6c:	83 c1 01             	add    $0x1,%ecx
  6f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  72:	0f b6 01             	movzbl (%ecx),%eax
  75:	84 c0                	test   %al,%al
  77:	75 ef                	jne    68 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  79:	0f b6 c0             	movzbl %al,%eax
  7c:	0f b6 12             	movzbl (%edx),%edx
  7f:	29 d0                	sub    %edx,%eax
}
  81:	5d                   	pop    %ebp
  82:	c3                   	ret    

00000083 <strlen>:

uint
strlen(const char *s)
{
  83:	f3 0f 1e fb          	endbr32 
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  8d:	80 3a 00             	cmpb   $0x0,(%edx)
  90:	74 14                	je     a6 <strlen+0x23>
  92:	b8 00 00 00 00       	mov    $0x0,%eax
  97:	83 c0 01             	add    $0x1,%eax
  9a:	89 c1                	mov    %eax,%ecx
  9c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a0:	75 f5                	jne    97 <strlen+0x14>
    ;
  return n;
}
  a2:	89 c8                	mov    %ecx,%eax
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    
  for(n = 0; s[n]; n++)
  a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  ab:	eb f5                	jmp    a2 <strlen+0x1f>

000000ad <memset>:

void*
memset(void *dst, int c, uint n)
{
  ad:	f3 0f 1e fb          	endbr32 
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	57                   	push   %edi
  b5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b8:	89 d7                	mov    %edx,%edi
  ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  c0:	fc                   	cld    
  c1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c3:	89 d0                	mov    %edx,%eax
  c5:	5f                   	pop    %edi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strchr>:

char*
strchr(const char *s, char c)
{
  c8:	f3 0f 1e fb          	endbr32 
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	84 d2                	test   %dl,%dl
  db:	74 15                	je     f2 <strchr+0x2a>
    if(*s == c)
  dd:	38 d1                	cmp    %dl,%cl
  df:	74 0f                	je     f0 <strchr+0x28>
  for(; *s; s++)
  e1:	83 c0 01             	add    $0x1,%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	84 d2                	test   %dl,%dl
  e9:	75 f2                	jne    dd <strchr+0x15>
      return (char*)s;
  return 0;
  eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f0:	5d                   	pop    %ebp
  f1:	c3                   	ret    
  return 0;
  f2:	b8 00 00 00 00       	mov    $0x0,%eax
  f7:	eb f7                	jmp    f0 <strchr+0x28>

000000f9 <gets>:

char*
gets(char *buf, int max)
{
  f9:	f3 0f 1e fb          	endbr32 
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	57                   	push   %edi
 101:	56                   	push   %esi
 102:	53                   	push   %ebx
 103:	83 ec 2c             	sub    $0x2c,%esp
 106:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 109:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 10e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 111:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 114:	83 c3 01             	add    $0x1,%ebx
 117:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 11a:	7d 27                	jge    143 <gets+0x4a>
    cc = read(0, &c, 1);
 11c:	83 ec 04             	sub    $0x4,%esp
 11f:	6a 01                	push   $0x1
 121:	57                   	push   %edi
 122:	6a 00                	push   $0x0
 124:	e8 03 01 00 00       	call   22c <read>
    if(cc < 1)
 129:	83 c4 10             	add    $0x10,%esp
 12c:	85 c0                	test   %eax,%eax
 12e:	7e 13                	jle    143 <gets+0x4a>
      break;
    buf[i++] = c;
 130:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 134:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 138:	3c 0a                	cmp    $0xa,%al
 13a:	74 04                	je     140 <gets+0x47>
 13c:	3c 0d                	cmp    $0xd,%al
 13e:	75 d1                	jne    111 <gets+0x18>
  for(i=0; i+1 < max; ){
 140:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 143:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 146:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 14a:	89 f0                	mov    %esi,%eax
 14c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14f:	5b                   	pop    %ebx
 150:	5e                   	pop    %esi
 151:	5f                   	pop    %edi
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <stat>:

int
stat(const char *n, struct stat *st)
{
 154:	f3 0f 1e fb          	endbr32 
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	56                   	push   %esi
 15c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15d:	83 ec 08             	sub    $0x8,%esp
 160:	6a 00                	push   $0x0
 162:	ff 75 08             	pushl  0x8(%ebp)
 165:	e8 ea 00 00 00       	call   254 <open>
  if(fd < 0)
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	85 c0                	test   %eax,%eax
 16f:	78 24                	js     195 <stat+0x41>
 171:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	ff 75 0c             	pushl  0xc(%ebp)
 179:	50                   	push   %eax
 17a:	e8 ed 00 00 00       	call   26c <fstat>
 17f:	89 c6                	mov    %eax,%esi
  close(fd);
 181:	89 1c 24             	mov    %ebx,(%esp)
 184:	e8 b3 00 00 00       	call   23c <close>
  return r;
 189:	83 c4 10             	add    $0x10,%esp
}
 18c:	89 f0                	mov    %esi,%eax
 18e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 191:	5b                   	pop    %ebx
 192:	5e                   	pop    %esi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
    return -1;
 195:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19a:	eb f0                	jmp    18c <stat+0x38>

0000019c <atoi>:

int
atoi(const char *s)
{
 19c:	f3 0f 1e fb          	endbr32 
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a7:	0f b6 02             	movzbl (%edx),%eax
 1aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1ad:	80 f9 09             	cmp    $0x9,%cl
 1b0:	77 22                	ja     1d4 <atoi+0x38>
  n = 0;
 1b2:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1bd:	0f be c0             	movsbl %al,%eax
 1c0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1c4:	0f b6 02             	movzbl (%edx),%eax
 1c7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ca:	80 fb 09             	cmp    $0x9,%bl
 1cd:	76 e8                	jbe    1b7 <atoi+0x1b>
  return n;
}
 1cf:	89 c8                	mov    %ecx,%eax
 1d1:	5b                   	pop    %ebx
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
  n = 0;
 1d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1d9:	eb f4                	jmp    1cf <atoi+0x33>

000001db <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1db:	f3 0f 1e fb          	endbr32 
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	56                   	push   %esi
 1e3:	53                   	push   %ebx
 1e4:	8b 75 08             	mov    0x8(%ebp),%esi
 1e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ed:	85 db                	test   %ebx,%ebx
 1ef:	7e 15                	jle    206 <memmove+0x2b>
 1f1:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1f3:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1f5:	83 c2 01             	add    $0x1,%edx
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1ff:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 202:	39 c3                	cmp    %eax,%ebx
 204:	75 ef                	jne    1f5 <memmove+0x1a>
  return vdst;
}
 206:	89 f0                	mov    %esi,%eax
 208:	5b                   	pop    %ebx
 209:	5e                   	pop    %esi
 20a:	5d                   	pop    %ebp
 20b:	c3                   	ret    

0000020c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20c:	b8 01 00 00 00       	mov    $0x1,%eax
 211:	cd 40                	int    $0x40
 213:	c3                   	ret    

00000214 <exit>:
SYSCALL(exit)
 214:	b8 02 00 00 00       	mov    $0x2,%eax
 219:	cd 40                	int    $0x40
 21b:	c3                   	ret    

0000021c <wait>:
SYSCALL(wait)
 21c:	b8 03 00 00 00       	mov    $0x3,%eax
 221:	cd 40                	int    $0x40
 223:	c3                   	ret    

00000224 <pipe>:
SYSCALL(pipe)
 224:	b8 04 00 00 00       	mov    $0x4,%eax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret    

0000022c <read>:
SYSCALL(read)
 22c:	b8 05 00 00 00       	mov    $0x5,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <write>:
SYSCALL(write)
 234:	b8 10 00 00 00       	mov    $0x10,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <close>:
SYSCALL(close)
 23c:	b8 15 00 00 00       	mov    $0x15,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <kill>:
SYSCALL(kill)
 244:	b8 06 00 00 00       	mov    $0x6,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <exec>:
SYSCALL(exec)
 24c:	b8 07 00 00 00       	mov    $0x7,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <open>:
SYSCALL(open)
 254:	b8 0f 00 00 00       	mov    $0xf,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <mknod>:
SYSCALL(mknod)
 25c:	b8 11 00 00 00       	mov    $0x11,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <unlink>:
SYSCALL(unlink)
 264:	b8 12 00 00 00       	mov    $0x12,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <fstat>:
SYSCALL(fstat)
 26c:	b8 08 00 00 00       	mov    $0x8,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <link>:
SYSCALL(link)
 274:	b8 13 00 00 00       	mov    $0x13,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <mkdir>:
SYSCALL(mkdir)
 27c:	b8 14 00 00 00       	mov    $0x14,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <chdir>:
SYSCALL(chdir)
 284:	b8 09 00 00 00       	mov    $0x9,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <dup>:
SYSCALL(dup)
 28c:	b8 0a 00 00 00       	mov    $0xa,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <getpid>:
SYSCALL(getpid)
 294:	b8 0b 00 00 00       	mov    $0xb,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <sbrk>:
SYSCALL(sbrk)
 29c:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <sleep>:
SYSCALL(sleep)
 2a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <uptime>:
SYSCALL(uptime)
 2ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <slabtest>:
SYSCALL(slabtest)
 2b4:	b8 16 00 00 00       	mov    $0x16,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <ps>:
SYSCALL(ps)
 2bc:	b8 17 00 00 00       	mov    $0x17,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	56                   	push   %esi
 2c9:	53                   	push   %ebx
 2ca:	83 ec 3c             	sub    $0x3c,%esp
 2cd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2d0:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d6:	74 77                	je     34f <printint+0x8b>
 2d8:	85 d2                	test   %edx,%edx
 2da:	79 73                	jns    34f <printint+0x8b>
    neg = 1;
    x = -xx;
 2dc:	f7 db                	neg    %ebx
    neg = 1;
 2de:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e5:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 2ea:	89 f7                	mov    %esi,%edi
 2ec:	83 c6 01             	add    $0x1,%esi
 2ef:	89 d8                	mov    %ebx,%eax
 2f1:	ba 00 00 00 00       	mov    $0x0,%edx
 2f6:	f7 f1                	div    %ecx
 2f8:	0f b6 92 7c 06 00 00 	movzbl 0x67c(%edx),%edx
 2ff:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 303:	89 da                	mov    %ebx,%edx
 305:	89 c3                	mov    %eax,%ebx
 307:	39 d1                	cmp    %edx,%ecx
 309:	76 df                	jbe    2ea <printint+0x26>
  if(neg)
 30b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 30f:	74 08                	je     319 <printint+0x55>
    buf[i++] = '-';
 311:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 316:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 319:	85 f6                	test   %esi,%esi
 31b:	7e 2a                	jle    347 <printint+0x83>
 31d:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 321:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 324:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 327:	0f b6 03             	movzbl (%ebx),%eax
 32a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 32d:	83 ec 04             	sub    $0x4,%esp
 330:	6a 01                	push   $0x1
 332:	56                   	push   %esi
 333:	ff 75 c4             	pushl  -0x3c(%ebp)
 336:	e8 f9 fe ff ff       	call   234 <write>
  while(--i >= 0)
 33b:	89 d8                	mov    %ebx,%eax
 33d:	83 eb 01             	sub    $0x1,%ebx
 340:	83 c4 10             	add    $0x10,%esp
 343:	39 f8                	cmp    %edi,%eax
 345:	75 e0                	jne    327 <printint+0x63>
}
 347:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34a:	5b                   	pop    %ebx
 34b:	5e                   	pop    %esi
 34c:	5f                   	pop    %edi
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    
  neg = 0;
 34f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 356:	eb 8d                	jmp    2e5 <printint+0x21>

00000358 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 358:	f3 0f 1e fb          	endbr32 
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 365:	8b 75 0c             	mov    0xc(%ebp),%esi
 368:	0f b6 1e             	movzbl (%esi),%ebx
 36b:	84 db                	test   %bl,%bl
 36d:	0f 84 ab 01 00 00    	je     51e <printf+0x1c6>
 373:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 376:	8d 45 10             	lea    0x10(%ebp),%eax
 379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 37c:	bf 00 00 00 00       	mov    $0x0,%edi
 381:	eb 2d                	jmp    3b0 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 383:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 386:	83 ec 04             	sub    $0x4,%esp
 389:	6a 01                	push   $0x1
 38b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 38e:	50                   	push   %eax
 38f:	ff 75 08             	pushl  0x8(%ebp)
 392:	e8 9d fe ff ff       	call   234 <write>
        putc(fd, c);
 397:	83 c4 10             	add    $0x10,%esp
 39a:	eb 05                	jmp    3a1 <printf+0x49>
      }
    } else if(state == '%'){
 39c:	83 ff 25             	cmp    $0x25,%edi
 39f:	74 22                	je     3c3 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 3a1:	83 c6 01             	add    $0x1,%esi
 3a4:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3a8:	84 db                	test   %bl,%bl
 3aa:	0f 84 6e 01 00 00    	je     51e <printf+0x1c6>
    c = fmt[i] & 0xff;
 3b0:	0f be d3             	movsbl %bl,%edx
 3b3:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3b6:	85 ff                	test   %edi,%edi
 3b8:	75 e2                	jne    39c <printf+0x44>
      if(c == '%'){
 3ba:	83 f8 25             	cmp    $0x25,%eax
 3bd:	75 c4                	jne    383 <printf+0x2b>
        state = '%';
 3bf:	89 c7                	mov    %eax,%edi
 3c1:	eb de                	jmp    3a1 <printf+0x49>
      if(c == 'd'){
 3c3:	83 f8 64             	cmp    $0x64,%eax
 3c6:	74 59                	je     421 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3c8:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3ce:	83 fa 70             	cmp    $0x70,%edx
 3d1:	74 7a                	je     44d <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3d3:	83 f8 73             	cmp    $0x73,%eax
 3d6:	0f 84 9d 00 00 00    	je     479 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3dc:	83 f8 63             	cmp    $0x63,%eax
 3df:	0f 84 ec 00 00 00    	je     4d1 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3e5:	83 f8 25             	cmp    $0x25,%eax
 3e8:	0f 84 0f 01 00 00    	je     4fd <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3ee:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3f2:	83 ec 04             	sub    $0x4,%esp
 3f5:	6a 01                	push   $0x1
 3f7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3fa:	50                   	push   %eax
 3fb:	ff 75 08             	pushl  0x8(%ebp)
 3fe:	e8 31 fe ff ff       	call   234 <write>
        putc(fd, c);
 403:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 406:	83 c4 0c             	add    $0xc,%esp
 409:	6a 01                	push   $0x1
 40b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 40e:	50                   	push   %eax
 40f:	ff 75 08             	pushl  0x8(%ebp)
 412:	e8 1d fe ff ff       	call   234 <write>
        putc(fd, c);
 417:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 41a:	bf 00 00 00 00       	mov    $0x0,%edi
 41f:	eb 80                	jmp    3a1 <printf+0x49>
        printint(fd, *ap, 10, 1);
 421:	83 ec 0c             	sub    $0xc,%esp
 424:	6a 01                	push   $0x1
 426:	b9 0a 00 00 00       	mov    $0xa,%ecx
 42b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 42e:	8b 17                	mov    (%edi),%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	e8 8c fe ff ff       	call   2c4 <printint>
        ap++;
 438:	89 f8                	mov    %edi,%eax
 43a:	83 c0 04             	add    $0x4,%eax
 43d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 440:	83 c4 10             	add    $0x10,%esp
      state = 0;
 443:	bf 00 00 00 00       	mov    $0x0,%edi
 448:	e9 54 ff ff ff       	jmp    3a1 <printf+0x49>
        printint(fd, *ap, 16, 0);
 44d:	83 ec 0c             	sub    $0xc,%esp
 450:	6a 00                	push   $0x0
 452:	b9 10 00 00 00       	mov    $0x10,%ecx
 457:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 45a:	8b 17                	mov    (%edi),%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	e8 60 fe ff ff       	call   2c4 <printint>
        ap++;
 464:	89 f8                	mov    %edi,%eax
 466:	83 c0 04             	add    $0x4,%eax
 469:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 46c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 46f:	bf 00 00 00 00       	mov    $0x0,%edi
 474:	e9 28 ff ff ff       	jmp    3a1 <printf+0x49>
        s = (char*)*ap;
 479:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 47c:	8b 01                	mov    (%ecx),%eax
        ap++;
 47e:	83 c1 04             	add    $0x4,%ecx
 481:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 484:	85 c0                	test   %eax,%eax
 486:	74 13                	je     49b <printf+0x143>
        s = (char*)*ap;
 488:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 48a:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 48d:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 492:	84 c0                	test   %al,%al
 494:	75 0f                	jne    4a5 <printf+0x14d>
 496:	e9 06 ff ff ff       	jmp    3a1 <printf+0x49>
          s = "(null)";
 49b:	bb 74 06 00 00       	mov    $0x674,%ebx
        while(*s != 0){
 4a0:	b8 28 00 00 00       	mov    $0x28,%eax
 4a5:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 4a8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	83 ec 04             	sub    $0x4,%esp
 4ae:	6a 01                	push   $0x1
 4b0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b3:	50                   	push   %eax
 4b4:	57                   	push   %edi
 4b5:	e8 7a fd ff ff       	call   234 <write>
          s++;
 4ba:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4bd:	0f b6 03             	movzbl (%ebx),%eax
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	84 c0                	test   %al,%al
 4c5:	75 e1                	jne    4a8 <printf+0x150>
      state = 0;
 4c7:	bf 00 00 00 00       	mov    $0x0,%edi
 4cc:	e9 d0 fe ff ff       	jmp    3a1 <printf+0x49>
        putc(fd, *ap);
 4d1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d4:	8b 07                	mov    (%edi),%eax
 4d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d9:	83 ec 04             	sub    $0x4,%esp
 4dc:	6a 01                	push   $0x1
 4de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 4a fd ff ff       	call   234 <write>
        ap++;
 4ea:	83 c7 04             	add    $0x4,%edi
 4ed:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f3:	bf 00 00 00 00       	mov    $0x0,%edi
 4f8:	e9 a4 fe ff ff       	jmp    3a1 <printf+0x49>
        putc(fd, c);
 4fd:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 500:	83 ec 04             	sub    $0x4,%esp
 503:	6a 01                	push   $0x1
 505:	8d 45 e7             	lea    -0x19(%ebp),%eax
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 23 fd ff ff       	call   234 <write>
 511:	83 c4 10             	add    $0x10,%esp
      state = 0;
 514:	bf 00 00 00 00       	mov    $0x0,%edi
 519:	e9 83 fe ff ff       	jmp    3a1 <printf+0x49>
    }
  }
}
 51e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 521:	5b                   	pop    %ebx
 522:	5e                   	pop    %esi
 523:	5f                   	pop    %edi
 524:	5d                   	pop    %ebp
 525:	c3                   	ret    

00000526 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 526:	f3 0f 1e fb          	endbr32 
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
 536:	a1 e4 08 00 00       	mov    0x8e4,%eax
 53b:	eb 0c                	jmp    549 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53d:	8b 10                	mov    (%eax),%edx
 53f:	39 c2                	cmp    %eax,%edx
 541:	77 04                	ja     547 <free+0x21>
 543:	39 ca                	cmp    %ecx,%edx
 545:	77 10                	ja     557 <free+0x31>
{
 547:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 549:	39 c8                	cmp    %ecx,%eax
 54b:	73 f0                	jae    53d <free+0x17>
 54d:	8b 10                	mov    (%eax),%edx
 54f:	39 ca                	cmp    %ecx,%edx
 551:	77 04                	ja     557 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 553:	39 c2                	cmp    %eax,%edx
 555:	77 f0                	ja     547 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 557:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55a:	8b 10                	mov    (%eax),%edx
 55c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55f:	39 fa                	cmp    %edi,%edx
 561:	74 19                	je     57c <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 563:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 566:	8b 50 04             	mov    0x4(%eax),%edx
 569:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56c:	39 f1                	cmp    %esi,%ecx
 56e:	74 1b                	je     58b <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 570:	89 08                	mov    %ecx,(%eax)
  freep = p;
 572:	a3 e4 08 00 00       	mov    %eax,0x8e4
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
 586:	89 53 f8             	mov    %edx,-0x8(%ebx)
 589:	eb db                	jmp    566 <free+0x40>
    p->s.size += bp->s.size;
 58b:	03 53 fc             	add    -0x4(%ebx),%edx
 58e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 591:	8b 53 f8             	mov    -0x8(%ebx),%edx
 594:	89 10                	mov    %edx,(%eax)
 596:	eb da                	jmp    572 <free+0x4c>

00000598 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 598:	f3 0f 1e fb          	endbr32 
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	57                   	push   %edi
 5a0:	56                   	push   %esi
 5a1:	53                   	push   %ebx
 5a2:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	8d 58 07             	lea    0x7(%eax),%ebx
 5ab:	c1 eb 03             	shr    $0x3,%ebx
 5ae:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b1:	8b 15 e4 08 00 00    	mov    0x8e4,%edx
 5b7:	85 d2                	test   %edx,%edx
 5b9:	74 20                	je     5db <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5bb:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5bd:	8b 48 04             	mov    0x4(%eax),%ecx
 5c0:	39 cb                	cmp    %ecx,%ebx
 5c2:	76 3c                	jbe    600 <malloc+0x68>
 5c4:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5ca:	be 00 10 00 00       	mov    $0x1000,%esi
 5cf:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5d2:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5d9:	eb 72                	jmp    64d <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 5db:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 5e2:	08 00 00 
 5e5:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 5ec:	08 00 00 
    base.s.size = 0;
 5ef:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 5f6:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f9:	b8 e8 08 00 00       	mov    $0x8e8,%eax
 5fe:	eb c4                	jmp    5c4 <malloc+0x2c>
      if(p->s.size == nunits)
 600:	39 cb                	cmp    %ecx,%ebx
 602:	74 1e                	je     622 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 604:	29 d9                	sub    %ebx,%ecx
 606:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 609:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 60c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 60f:	89 15 e4 08 00 00    	mov    %edx,0x8e4
      return (void*)(p + 1);
 615:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 618:	89 d0                	mov    %edx,%eax
 61a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61d:	5b                   	pop    %ebx
 61e:	5e                   	pop    %esi
 61f:	5f                   	pop    %edi
 620:	5d                   	pop    %ebp
 621:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 622:	8b 08                	mov    (%eax),%ecx
 624:	89 0a                	mov    %ecx,(%edx)
 626:	eb e7                	jmp    60f <malloc+0x77>
  hp->s.size = nu;
 628:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 62b:	83 ec 0c             	sub    $0xc,%esp
 62e:	83 c0 08             	add    $0x8,%eax
 631:	50                   	push   %eax
 632:	e8 ef fe ff ff       	call   526 <free>
  return freep;
 637:	8b 15 e4 08 00 00    	mov    0x8e4,%edx
      if((p = morecore(nunits)) == 0)
 63d:	83 c4 10             	add    $0x10,%esp
 640:	85 d2                	test   %edx,%edx
 642:	74 d4                	je     618 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 644:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 646:	8b 48 04             	mov    0x4(%eax),%ecx
 649:	39 d9                	cmp    %ebx,%ecx
 64b:	73 b3                	jae    600 <malloc+0x68>
    if(p == freep)
 64d:	89 c2                	mov    %eax,%edx
 64f:	39 05 e4 08 00 00    	cmp    %eax,0x8e4
 655:	75 ed                	jne    644 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	57                   	push   %edi
 65b:	e8 3c fc ff ff       	call   29c <sbrk>
  if(p == (char*)-1)
 660:	83 c4 10             	add    $0x10,%esp
 663:	83 f8 ff             	cmp    $0xffffffff,%eax
 666:	75 c0                	jne    628 <malloc+0x90>
        return 0;
 668:	ba 00 00 00 00       	mov    $0x0,%edx
 66d:	eb a9                	jmp    618 <malloc+0x80>
