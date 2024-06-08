
user/_slabtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
	slabtest();
   a:	e8 8b 02 00 00       	call   29a <slabtest>

	exit();
   f:	e8 e6 01 00 00       	call   1fa <exit>

00000014 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  14:	f3 0f 1e fb          	endbr32 
  18:	55                   	push   %ebp
  19:	89 e5                	mov    %esp,%ebp
  1b:	53                   	push   %ebx
  1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  22:	b8 00 00 00 00       	mov    $0x0,%eax
  27:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  2b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  2e:	83 c0 01             	add    $0x1,%eax
  31:	84 d2                	test   %dl,%dl
  33:	75 f2                	jne    27 <strcpy+0x13>
    ;
  return os;
}
  35:	89 c8                	mov    %ecx,%eax
  37:	5b                   	pop    %ebx
  38:	5d                   	pop    %ebp
  39:	c3                   	ret    

0000003a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3a:	f3 0f 1e fb          	endbr32 
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  44:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  47:	0f b6 01             	movzbl (%ecx),%eax
  4a:	84 c0                	test   %al,%al
  4c:	74 11                	je     5f <strcmp+0x25>
  4e:	38 02                	cmp    %al,(%edx)
  50:	75 0d                	jne    5f <strcmp+0x25>
    p++, q++;
  52:	83 c1 01             	add    $0x1,%ecx
  55:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  58:	0f b6 01             	movzbl (%ecx),%eax
  5b:	84 c0                	test   %al,%al
  5d:	75 ef                	jne    4e <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  5f:	0f b6 c0             	movzbl %al,%eax
  62:	0f b6 12             	movzbl (%edx),%edx
  65:	29 d0                	sub    %edx,%eax
}
  67:	5d                   	pop    %ebp
  68:	c3                   	ret    

00000069 <strlen>:

uint
strlen(const char *s)
{
  69:	f3 0f 1e fb          	endbr32 
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  73:	80 3a 00             	cmpb   $0x0,(%edx)
  76:	74 14                	je     8c <strlen+0x23>
  78:	b8 00 00 00 00       	mov    $0x0,%eax
  7d:	83 c0 01             	add    $0x1,%eax
  80:	89 c1                	mov    %eax,%ecx
  82:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  86:	75 f5                	jne    7d <strlen+0x14>
    ;
  return n;
}
  88:	89 c8                	mov    %ecx,%eax
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    
  for(n = 0; s[n]; n++)
  8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  91:	eb f5                	jmp    88 <strlen+0x1f>

00000093 <memset>:

void*
memset(void *dst, int c, uint n)
{
  93:	f3 0f 1e fb          	endbr32 
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  9a:	57                   	push   %edi
  9b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  9e:	89 d7                	mov    %edx,%edi
  a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	fc                   	cld    
  a7:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a9:	89 d0                	mov    %edx,%eax
  ab:	5f                   	pop    %edi
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <strchr>:

char*
strchr(const char *s, char c)
{
  ae:	f3 0f 1e fb          	endbr32 
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  bc:	0f b6 10             	movzbl (%eax),%edx
  bf:	84 d2                	test   %dl,%dl
  c1:	74 15                	je     d8 <strchr+0x2a>
    if(*s == c)
  c3:	38 d1                	cmp    %dl,%cl
  c5:	74 0f                	je     d6 <strchr+0x28>
  for(; *s; s++)
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	0f b6 10             	movzbl (%eax),%edx
  cd:	84 d2                	test   %dl,%dl
  cf:	75 f2                	jne    c3 <strchr+0x15>
      return (char*)s;
  return 0;
  d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  d6:	5d                   	pop    %ebp
  d7:	c3                   	ret    
  return 0;
  d8:	b8 00 00 00 00       	mov    $0x0,%eax
  dd:	eb f7                	jmp    d6 <strchr+0x28>

000000df <gets>:

char*
gets(char *buf, int max)
{
  df:	f3 0f 1e fb          	endbr32 
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	57                   	push   %edi
  e7:	56                   	push   %esi
  e8:	53                   	push   %ebx
  e9:	83 ec 2c             	sub    $0x2c,%esp
  ec:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ef:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
  f4:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  f7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  fa:	83 c3 01             	add    $0x1,%ebx
  fd:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 100:	7d 27                	jge    129 <gets+0x4a>
    cc = read(0, &c, 1);
 102:	83 ec 04             	sub    $0x4,%esp
 105:	6a 01                	push   $0x1
 107:	57                   	push   %edi
 108:	6a 00                	push   $0x0
 10a:	e8 03 01 00 00       	call   212 <read>
    if(cc < 1)
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	7e 13                	jle    129 <gets+0x4a>
      break;
    buf[i++] = c;
 116:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11a:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 11e:	3c 0a                	cmp    $0xa,%al
 120:	74 04                	je     126 <gets+0x47>
 122:	3c 0d                	cmp    $0xd,%al
 124:	75 d1                	jne    f7 <gets+0x18>
  for(i=0; i+1 < max; ){
 126:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 12c:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 130:	89 f0                	mov    %esi,%eax
 132:	8d 65 f4             	lea    -0xc(%ebp),%esp
 135:	5b                   	pop    %ebx
 136:	5e                   	pop    %esi
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <stat>:

int
stat(const char *n, struct stat *st)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	ff 75 08             	pushl  0x8(%ebp)
 14b:	e8 ea 00 00 00       	call   23a <open>
  if(fd < 0)
 150:	83 c4 10             	add    $0x10,%esp
 153:	85 c0                	test   %eax,%eax
 155:	78 24                	js     17b <stat+0x41>
 157:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	ff 75 0c             	pushl  0xc(%ebp)
 15f:	50                   	push   %eax
 160:	e8 ed 00 00 00       	call   252 <fstat>
 165:	89 c6                	mov    %eax,%esi
  close(fd);
 167:	89 1c 24             	mov    %ebx,(%esp)
 16a:	e8 b3 00 00 00       	call   222 <close>
  return r;
 16f:	83 c4 10             	add    $0x10,%esp
}
 172:	89 f0                	mov    %esi,%eax
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
    return -1;
 17b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 180:	eb f0                	jmp    172 <stat+0x38>

00000182 <atoi>:

int
atoi(const char *s)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	53                   	push   %ebx
 18a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18d:	0f b6 02             	movzbl (%edx),%eax
 190:	8d 48 d0             	lea    -0x30(%eax),%ecx
 193:	80 f9 09             	cmp    $0x9,%cl
 196:	77 22                	ja     1ba <atoi+0x38>
  n = 0;
 198:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 19d:	83 c2 01             	add    $0x1,%edx
 1a0:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1a3:	0f be c0             	movsbl %al,%eax
 1a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 02             	movzbl (%edx),%eax
 1ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e8                	jbe    19d <atoi+0x1b>
  return n;
}
 1b5:	89 c8                	mov    %ecx,%eax
 1b7:	5b                   	pop    %ebx
 1b8:	5d                   	pop    %ebp
 1b9:	c3                   	ret    
  n = 0;
 1ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1bf:	eb f4                	jmp    1b5 <atoi+0x33>

000001c1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c1:	f3 0f 1e fb          	endbr32 
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	56                   	push   %esi
 1c9:	53                   	push   %ebx
 1ca:	8b 75 08             	mov    0x8(%ebp),%esi
 1cd:	8b 55 0c             	mov    0xc(%ebp),%edx
 1d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1d3:	85 db                	test   %ebx,%ebx
 1d5:	7e 15                	jle    1ec <memmove+0x2b>
 1d7:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1d9:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1db:	83 c2 01             	add    $0x1,%edx
 1de:	83 c0 01             	add    $0x1,%eax
 1e1:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1e5:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 1e8:	39 c3                	cmp    %eax,%ebx
 1ea:	75 ef                	jne    1db <memmove+0x1a>
  return vdst;
}
 1ec:	89 f0                	mov    %esi,%eax
 1ee:	5b                   	pop    %ebx
 1ef:	5e                   	pop    %esi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f2:	b8 01 00 00 00       	mov    $0x1,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <exit>:
SYSCALL(exit)
 1fa:	b8 02 00 00 00       	mov    $0x2,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <wait>:
SYSCALL(wait)
 202:	b8 03 00 00 00       	mov    $0x3,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <pipe>:
SYSCALL(pipe)
 20a:	b8 04 00 00 00       	mov    $0x4,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <read>:
SYSCALL(read)
 212:	b8 05 00 00 00       	mov    $0x5,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <write>:
SYSCALL(write)
 21a:	b8 10 00 00 00       	mov    $0x10,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <close>:
SYSCALL(close)
 222:	b8 15 00 00 00       	mov    $0x15,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <kill>:
SYSCALL(kill)
 22a:	b8 06 00 00 00       	mov    $0x6,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <exec>:
SYSCALL(exec)
 232:	b8 07 00 00 00       	mov    $0x7,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <open>:
SYSCALL(open)
 23a:	b8 0f 00 00 00       	mov    $0xf,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <mknod>:
SYSCALL(mknod)
 242:	b8 11 00 00 00       	mov    $0x11,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <unlink>:
SYSCALL(unlink)
 24a:	b8 12 00 00 00       	mov    $0x12,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <fstat>:
SYSCALL(fstat)
 252:	b8 08 00 00 00       	mov    $0x8,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <link>:
SYSCALL(link)
 25a:	b8 13 00 00 00       	mov    $0x13,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <mkdir>:
SYSCALL(mkdir)
 262:	b8 14 00 00 00       	mov    $0x14,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <chdir>:
SYSCALL(chdir)
 26a:	b8 09 00 00 00       	mov    $0x9,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <dup>:
SYSCALL(dup)
 272:	b8 0a 00 00 00       	mov    $0xa,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <getpid>:
SYSCALL(getpid)
 27a:	b8 0b 00 00 00       	mov    $0xb,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <sbrk>:
SYSCALL(sbrk)
 282:	b8 0c 00 00 00       	mov    $0xc,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <sleep>:
SYSCALL(sleep)
 28a:	b8 0d 00 00 00       	mov    $0xd,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <uptime>:
SYSCALL(uptime)
 292:	b8 0e 00 00 00       	mov    $0xe,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <slabtest>:
SYSCALL(slabtest)
 29a:	b8 16 00 00 00       	mov    $0x16,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <ps>:
SYSCALL(ps)
 2a2:	b8 17 00 00 00       	mov    $0x17,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	57                   	push   %edi
 2ae:	56                   	push   %esi
 2af:	53                   	push   %ebx
 2b0:	83 ec 3c             	sub    $0x3c,%esp
 2b3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2b6:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2bc:	74 77                	je     335 <printint+0x8b>
 2be:	85 d2                	test   %edx,%edx
 2c0:	79 73                	jns    335 <printint+0x8b>
    neg = 1;
    x = -xx;
 2c2:	f7 db                	neg    %ebx
    neg = 1;
 2c4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2cb:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 2d0:	89 f7                	mov    %esi,%edi
 2d2:	83 c6 01             	add    $0x1,%esi
 2d5:	89 d8                	mov    %ebx,%eax
 2d7:	ba 00 00 00 00       	mov    $0x0,%edx
 2dc:	f7 f1                	div    %ecx
 2de:	0f b6 92 60 06 00 00 	movzbl 0x660(%edx),%edx
 2e5:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 2e9:	89 da                	mov    %ebx,%edx
 2eb:	89 c3                	mov    %eax,%ebx
 2ed:	39 d1                	cmp    %edx,%ecx
 2ef:	76 df                	jbe    2d0 <printint+0x26>
  if(neg)
 2f1:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 2f5:	74 08                	je     2ff <printint+0x55>
    buf[i++] = '-';
 2f7:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 2fc:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 2ff:	85 f6                	test   %esi,%esi
 301:	7e 2a                	jle    32d <printint+0x83>
 303:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 307:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 30a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 30d:	0f b6 03             	movzbl (%ebx),%eax
 310:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 313:	83 ec 04             	sub    $0x4,%esp
 316:	6a 01                	push   $0x1
 318:	56                   	push   %esi
 319:	ff 75 c4             	pushl  -0x3c(%ebp)
 31c:	e8 f9 fe ff ff       	call   21a <write>
  while(--i >= 0)
 321:	89 d8                	mov    %ebx,%eax
 323:	83 eb 01             	sub    $0x1,%ebx
 326:	83 c4 10             	add    $0x10,%esp
 329:	39 f8                	cmp    %edi,%eax
 32b:	75 e0                	jne    30d <printint+0x63>
}
 32d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5f                   	pop    %edi
 333:	5d                   	pop    %ebp
 334:	c3                   	ret    
  neg = 0;
 335:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 33c:	eb 8d                	jmp    2cb <printint+0x21>

0000033e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33e:	f3 0f 1e fb          	endbr32 
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
 345:	57                   	push   %edi
 346:	56                   	push   %esi
 347:	53                   	push   %ebx
 348:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 34b:	8b 75 0c             	mov    0xc(%ebp),%esi
 34e:	0f b6 1e             	movzbl (%esi),%ebx
 351:	84 db                	test   %bl,%bl
 353:	0f 84 ab 01 00 00    	je     504 <printf+0x1c6>
 359:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 35c:	8d 45 10             	lea    0x10(%ebp),%eax
 35f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 362:	bf 00 00 00 00       	mov    $0x0,%edi
 367:	eb 2d                	jmp    396 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 369:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 36c:	83 ec 04             	sub    $0x4,%esp
 36f:	6a 01                	push   $0x1
 371:	8d 45 e7             	lea    -0x19(%ebp),%eax
 374:	50                   	push   %eax
 375:	ff 75 08             	pushl  0x8(%ebp)
 378:	e8 9d fe ff ff       	call   21a <write>
        putc(fd, c);
 37d:	83 c4 10             	add    $0x10,%esp
 380:	eb 05                	jmp    387 <printf+0x49>
      }
    } else if(state == '%'){
 382:	83 ff 25             	cmp    $0x25,%edi
 385:	74 22                	je     3a9 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 387:	83 c6 01             	add    $0x1,%esi
 38a:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 38e:	84 db                	test   %bl,%bl
 390:	0f 84 6e 01 00 00    	je     504 <printf+0x1c6>
    c = fmt[i] & 0xff;
 396:	0f be d3             	movsbl %bl,%edx
 399:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 39c:	85 ff                	test   %edi,%edi
 39e:	75 e2                	jne    382 <printf+0x44>
      if(c == '%'){
 3a0:	83 f8 25             	cmp    $0x25,%eax
 3a3:	75 c4                	jne    369 <printf+0x2b>
        state = '%';
 3a5:	89 c7                	mov    %eax,%edi
 3a7:	eb de                	jmp    387 <printf+0x49>
      if(c == 'd'){
 3a9:	83 f8 64             	cmp    $0x64,%eax
 3ac:	74 59                	je     407 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ae:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3b4:	83 fa 70             	cmp    $0x70,%edx
 3b7:	74 7a                	je     433 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3b9:	83 f8 73             	cmp    $0x73,%eax
 3bc:	0f 84 9d 00 00 00    	je     45f <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3c2:	83 f8 63             	cmp    $0x63,%eax
 3c5:	0f 84 ec 00 00 00    	je     4b7 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3cb:	83 f8 25             	cmp    $0x25,%eax
 3ce:	0f 84 0f 01 00 00    	je     4e3 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3d4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3d8:	83 ec 04             	sub    $0x4,%esp
 3db:	6a 01                	push   $0x1
 3dd:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e0:	50                   	push   %eax
 3e1:	ff 75 08             	pushl  0x8(%ebp)
 3e4:	e8 31 fe ff ff       	call   21a <write>
        putc(fd, c);
 3e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3ec:	83 c4 0c             	add    $0xc,%esp
 3ef:	6a 01                	push   $0x1
 3f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3f4:	50                   	push   %eax
 3f5:	ff 75 08             	pushl  0x8(%ebp)
 3f8:	e8 1d fe ff ff       	call   21a <write>
        putc(fd, c);
 3fd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 400:	bf 00 00 00 00       	mov    $0x0,%edi
 405:	eb 80                	jmp    387 <printf+0x49>
        printint(fd, *ap, 10, 1);
 407:	83 ec 0c             	sub    $0xc,%esp
 40a:	6a 01                	push   $0x1
 40c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 411:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 414:	8b 17                	mov    (%edi),%edx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 8c fe ff ff       	call   2aa <printint>
        ap++;
 41e:	89 f8                	mov    %edi,%eax
 420:	83 c0 04             	add    $0x4,%eax
 423:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 426:	83 c4 10             	add    $0x10,%esp
      state = 0;
 429:	bf 00 00 00 00       	mov    $0x0,%edi
 42e:	e9 54 ff ff ff       	jmp    387 <printf+0x49>
        printint(fd, *ap, 16, 0);
 433:	83 ec 0c             	sub    $0xc,%esp
 436:	6a 00                	push   $0x0
 438:	b9 10 00 00 00       	mov    $0x10,%ecx
 43d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 440:	8b 17                	mov    (%edi),%edx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	e8 60 fe ff ff       	call   2aa <printint>
        ap++;
 44a:	89 f8                	mov    %edi,%eax
 44c:	83 c0 04             	add    $0x4,%eax
 44f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 452:	83 c4 10             	add    $0x10,%esp
      state = 0;
 455:	bf 00 00 00 00       	mov    $0x0,%edi
 45a:	e9 28 ff ff ff       	jmp    387 <printf+0x49>
        s = (char*)*ap;
 45f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 462:	8b 01                	mov    (%ecx),%eax
        ap++;
 464:	83 c1 04             	add    $0x4,%ecx
 467:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 46a:	85 c0                	test   %eax,%eax
 46c:	74 13                	je     481 <printf+0x143>
        s = (char*)*ap;
 46e:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 470:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 473:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 478:	84 c0                	test   %al,%al
 47a:	75 0f                	jne    48b <printf+0x14d>
 47c:	e9 06 ff ff ff       	jmp    387 <printf+0x49>
          s = "(null)";
 481:	bb 58 06 00 00       	mov    $0x658,%ebx
        while(*s != 0){
 486:	b8 28 00 00 00       	mov    $0x28,%eax
 48b:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 48e:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 491:	83 ec 04             	sub    $0x4,%esp
 494:	6a 01                	push   $0x1
 496:	8d 45 e7             	lea    -0x19(%ebp),%eax
 499:	50                   	push   %eax
 49a:	57                   	push   %edi
 49b:	e8 7a fd ff ff       	call   21a <write>
          s++;
 4a0:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4a3:	0f b6 03             	movzbl (%ebx),%eax
 4a6:	83 c4 10             	add    $0x10,%esp
 4a9:	84 c0                	test   %al,%al
 4ab:	75 e1                	jne    48e <printf+0x150>
      state = 0;
 4ad:	bf 00 00 00 00       	mov    $0x0,%edi
 4b2:	e9 d0 fe ff ff       	jmp    387 <printf+0x49>
        putc(fd, *ap);
 4b7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4ba:	8b 07                	mov    (%edi),%eax
 4bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4bf:	83 ec 04             	sub    $0x4,%esp
 4c2:	6a 01                	push   $0x1
 4c4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 4a fd ff ff       	call   21a <write>
        ap++;
 4d0:	83 c7 04             	add    $0x4,%edi
 4d3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d9:	bf 00 00 00 00       	mov    $0x0,%edi
 4de:	e9 a4 fe ff ff       	jmp    387 <printf+0x49>
        putc(fd, c);
 4e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4e6:	83 ec 04             	sub    $0x4,%esp
 4e9:	6a 01                	push   $0x1
 4eb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ee:	50                   	push   %eax
 4ef:	ff 75 08             	pushl  0x8(%ebp)
 4f2:	e8 23 fd ff ff       	call   21a <write>
 4f7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fa:	bf 00 00 00 00       	mov    $0x0,%edi
 4ff:	e9 83 fe ff ff       	jmp    387 <printf+0x49>
    }
  }
}
 504:	8d 65 f4             	lea    -0xc(%ebp),%esp
 507:	5b                   	pop    %ebx
 508:	5e                   	pop    %esi
 509:	5f                   	pop    %edi
 50a:	5d                   	pop    %ebp
 50b:	c3                   	ret    

0000050c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 50c:	f3 0f 1e fb          	endbr32 
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 519:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 51c:	a1 c0 08 00 00       	mov    0x8c0,%eax
 521:	eb 0c                	jmp    52f <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 523:	8b 10                	mov    (%eax),%edx
 525:	39 c2                	cmp    %eax,%edx
 527:	77 04                	ja     52d <free+0x21>
 529:	39 ca                	cmp    %ecx,%edx
 52b:	77 10                	ja     53d <free+0x31>
{
 52d:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 52f:	39 c8                	cmp    %ecx,%eax
 531:	73 f0                	jae    523 <free+0x17>
 533:	8b 10                	mov    (%eax),%edx
 535:	39 ca                	cmp    %ecx,%edx
 537:	77 04                	ja     53d <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 539:	39 c2                	cmp    %eax,%edx
 53b:	77 f0                	ja     52d <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 53d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 540:	8b 10                	mov    (%eax),%edx
 542:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 545:	39 fa                	cmp    %edi,%edx
 547:	74 19                	je     562 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 549:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 54c:	8b 50 04             	mov    0x4(%eax),%edx
 54f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 552:	39 f1                	cmp    %esi,%ecx
 554:	74 1b                	je     571 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 556:	89 08                	mov    %ecx,(%eax)
  freep = p;
 558:	a3 c0 08 00 00       	mov    %eax,0x8c0
}
 55d:	5b                   	pop    %ebx
 55e:	5e                   	pop    %esi
 55f:	5f                   	pop    %edi
 560:	5d                   	pop    %ebp
 561:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 562:	03 72 04             	add    0x4(%edx),%esi
 565:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 568:	8b 10                	mov    (%eax),%edx
 56a:	8b 12                	mov    (%edx),%edx
 56c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 56f:	eb db                	jmp    54c <free+0x40>
    p->s.size += bp->s.size;
 571:	03 53 fc             	add    -0x4(%ebx),%edx
 574:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 577:	8b 53 f8             	mov    -0x8(%ebx),%edx
 57a:	89 10                	mov    %edx,(%eax)
 57c:	eb da                	jmp    558 <free+0x4c>

0000057e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 57e:	f3 0f 1e fb          	endbr32 
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	57                   	push   %edi
 586:	56                   	push   %esi
 587:	53                   	push   %ebx
 588:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	8d 58 07             	lea    0x7(%eax),%ebx
 591:	c1 eb 03             	shr    $0x3,%ebx
 594:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 597:	8b 15 c0 08 00 00    	mov    0x8c0,%edx
 59d:	85 d2                	test   %edx,%edx
 59f:	74 20                	je     5c1 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5a3:	8b 48 04             	mov    0x4(%eax),%ecx
 5a6:	39 cb                	cmp    %ecx,%ebx
 5a8:	76 3c                	jbe    5e6 <malloc+0x68>
 5aa:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5b0:	be 00 10 00 00       	mov    $0x1000,%esi
 5b5:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5b8:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5bf:	eb 72                	jmp    633 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 5c1:	c7 05 c0 08 00 00 c4 	movl   $0x8c4,0x8c0
 5c8:	08 00 00 
 5cb:	c7 05 c4 08 00 00 c4 	movl   $0x8c4,0x8c4
 5d2:	08 00 00 
    base.s.size = 0;
 5d5:	c7 05 c8 08 00 00 00 	movl   $0x0,0x8c8
 5dc:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5df:	b8 c4 08 00 00       	mov    $0x8c4,%eax
 5e4:	eb c4                	jmp    5aa <malloc+0x2c>
      if(p->s.size == nunits)
 5e6:	39 cb                	cmp    %ecx,%ebx
 5e8:	74 1e                	je     608 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ea:	29 d9                	sub    %ebx,%ecx
 5ec:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5ef:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5f2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f5:	89 15 c0 08 00 00    	mov    %edx,0x8c0
      return (void*)(p + 1);
 5fb:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5fe:	89 d0                	mov    %edx,%eax
 600:	8d 65 f4             	lea    -0xc(%ebp),%esp
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 608:	8b 08                	mov    (%eax),%ecx
 60a:	89 0a                	mov    %ecx,(%edx)
 60c:	eb e7                	jmp    5f5 <malloc+0x77>
  hp->s.size = nu;
 60e:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 611:	83 ec 0c             	sub    $0xc,%esp
 614:	83 c0 08             	add    $0x8,%eax
 617:	50                   	push   %eax
 618:	e8 ef fe ff ff       	call   50c <free>
  return freep;
 61d:	8b 15 c0 08 00 00    	mov    0x8c0,%edx
      if((p = morecore(nunits)) == 0)
 623:	83 c4 10             	add    $0x10,%esp
 626:	85 d2                	test   %edx,%edx
 628:	74 d4                	je     5fe <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 62c:	8b 48 04             	mov    0x4(%eax),%ecx
 62f:	39 d9                	cmp    %ebx,%ecx
 631:	73 b3                	jae    5e6 <malloc+0x68>
    if(p == freep)
 633:	89 c2                	mov    %eax,%edx
 635:	39 05 c0 08 00 00    	cmp    %eax,0x8c0
 63b:	75 ed                	jne    62a <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 63d:	83 ec 0c             	sub    $0xc,%esp
 640:	57                   	push   %edi
 641:	e8 3c fc ff ff       	call   282 <sbrk>
  if(p == (char*)-1)
 646:	83 c4 10             	add    $0x10,%esp
 649:	83 f8 ff             	cmp    $0xffffffff,%eax
 64c:	75 c0                	jne    60e <malloc+0x90>
        return 0;
 64e:	ba 00 00 00 00       	mov    $0x0,%edx
 653:	eb a9                	jmp    5fe <malloc+0x80>
