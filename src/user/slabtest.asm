
user/_slabtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	slabtest();
   6:	e8 6d 02 00 00       	call   278 <slabtest>

	exit();
   b:	e8 c8 01 00 00       	call   1d8 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  1a:	b8 00 00 00 00       	mov    $0x0,%eax
  1f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  23:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  26:	83 c0 01             	add    $0x1,%eax
  29:	84 d2                	test   %dl,%dl
  2b:	75 f2                	jne    1f <strcpy+0xf>
    ;
  return os;
}
  2d:	89 c8                	mov    %ecx,%eax
  2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  32:	c9                   	leave  
  33:	c3                   	ret    

00000034 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  3d:	0f b6 01             	movzbl (%ecx),%eax
  40:	84 c0                	test   %al,%al
  42:	74 11                	je     55 <strcmp+0x21>
  44:	38 02                	cmp    %al,(%edx)
  46:	75 0d                	jne    55 <strcmp+0x21>
    p++, q++;
  48:	83 c1 01             	add    $0x1,%ecx
  4b:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  4e:	0f b6 01             	movzbl (%ecx),%eax
  51:	84 c0                	test   %al,%al
  53:	75 ef                	jne    44 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  55:	0f b6 c0             	movzbl %al,%eax
  58:	0f b6 12             	movzbl (%edx),%edx
  5b:	29 d0                	sub    %edx,%eax
}
  5d:	5d                   	pop    %ebp
  5e:	c3                   	ret    

0000005f <strlen>:

uint
strlen(const char *s)
{
  5f:	55                   	push   %ebp
  60:	89 e5                	mov    %esp,%ebp
  62:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  65:	80 3a 00             	cmpb   $0x0,(%edx)
  68:	74 14                	je     7e <strlen+0x1f>
  6a:	b8 00 00 00 00       	mov    $0x0,%eax
  6f:	83 c0 01             	add    $0x1,%eax
  72:	89 c1                	mov    %eax,%ecx
  74:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  78:	75 f5                	jne    6f <strlen+0x10>
    ;
  return n;
}
  7a:	89 c8                	mov    %ecx,%eax
  7c:	5d                   	pop    %ebp
  7d:	c3                   	ret    
  for(n = 0; s[n]; n++)
  7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  83:	eb f5                	jmp    7a <strlen+0x1b>

00000085 <memset>:

void*
memset(void *dst, int c, uint n)
{
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	57                   	push   %edi
  89:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  8c:	89 d7                	mov    %edx,%edi
  8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	fc                   	cld    
  95:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  97:	89 d0                	mov    %edx,%eax
  99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  9c:	c9                   	leave  
  9d:	c3                   	ret    

0000009e <strchr>:

char*
strchr(const char *s, char c)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  a8:	0f b6 10             	movzbl (%eax),%edx
  ab:	84 d2                	test   %dl,%dl
  ad:	74 15                	je     c4 <strchr+0x26>
    if(*s == c)
  af:	38 d1                	cmp    %dl,%cl
  b1:	74 0f                	je     c2 <strchr+0x24>
  for(; *s; s++)
  b3:	83 c0 01             	add    $0x1,%eax
  b6:	0f b6 10             	movzbl (%eax),%edx
  b9:	84 d2                	test   %dl,%dl
  bb:	75 f2                	jne    af <strchr+0x11>
      return (char*)s;
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    
  return 0;
  c4:	b8 00 00 00 00       	mov    $0x0,%eax
  c9:	eb f7                	jmp    c2 <strchr+0x24>

000000cb <gets>:

char*
gets(char *buf, int max)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	57                   	push   %edi
  cf:	56                   	push   %esi
  d0:	53                   	push   %ebx
  d1:	83 ec 2c             	sub    $0x2c,%esp
  d4:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d7:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
  dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  df:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  e2:	83 c3 01             	add    $0x1,%ebx
  e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e8:	7d 27                	jge    111 <gets+0x46>
    cc = read(0, &c, 1);
  ea:	83 ec 04             	sub    $0x4,%esp
  ed:	6a 01                	push   $0x1
  ef:	57                   	push   %edi
  f0:	6a 00                	push   $0x0
  f2:	e8 f9 00 00 00       	call   1f0 <read>
    if(cc < 1)
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	7e 13                	jle    111 <gets+0x46>
      break;
    buf[i++] = c;
  fe:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 102:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 106:	3c 0a                	cmp    $0xa,%al
 108:	74 04                	je     10e <gets+0x43>
 10a:	3c 0d                	cmp    $0xd,%al
 10c:	75 d1                	jne    df <gets+0x14>
  for(i=0; i+1 < max; ){
 10e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 111:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 114:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 118:	89 f0                	mov    %esi,%eax
 11a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 11d:	5b                   	pop    %ebx
 11e:	5e                   	pop    %esi
 11f:	5f                   	pop    %edi
 120:	5d                   	pop    %ebp
 121:	c3                   	ret    

00000122 <stat>:

int
stat(const char *n, struct stat *st)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	56                   	push   %esi
 126:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 127:	83 ec 08             	sub    $0x8,%esp
 12a:	6a 00                	push   $0x0
 12c:	ff 75 08             	push   0x8(%ebp)
 12f:	e8 e4 00 00 00       	call   218 <open>
  if(fd < 0)
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	78 24                	js     15f <stat+0x3d>
 13b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	ff 75 0c             	push   0xc(%ebp)
 143:	50                   	push   %eax
 144:	e8 e7 00 00 00       	call   230 <fstat>
 149:	89 c6                	mov    %eax,%esi
  close(fd);
 14b:	89 1c 24             	mov    %ebx,(%esp)
 14e:	e8 ad 00 00 00       	call   200 <close>
  return r;
 153:	83 c4 10             	add    $0x10,%esp
}
 156:	89 f0                	mov    %esi,%eax
 158:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15b:	5b                   	pop    %ebx
 15c:	5e                   	pop    %esi
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    
    return -1;
 15f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 164:	eb f0                	jmp    156 <stat+0x34>

00000166 <atoi>:

int
atoi(const char *s)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	53                   	push   %ebx
 16a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 16d:	0f b6 02             	movzbl (%edx),%eax
 170:	8d 48 d0             	lea    -0x30(%eax),%ecx
 173:	80 f9 09             	cmp    $0x9,%cl
 176:	77 24                	ja     19c <atoi+0x36>
  n = 0;
 178:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 17d:	83 c2 01             	add    $0x1,%edx
 180:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 183:	0f be c0             	movsbl %al,%eax
 186:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 18a:	0f b6 02             	movzbl (%edx),%eax
 18d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 190:	80 fb 09             	cmp    $0x9,%bl
 193:	76 e8                	jbe    17d <atoi+0x17>
  return n;
}
 195:	89 c8                	mov    %ecx,%eax
 197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19a:	c9                   	leave  
 19b:	c3                   	ret    
  n = 0;
 19c:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1a1:	eb f2                	jmp    195 <atoi+0x2f>

000001a3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	56                   	push   %esi
 1a7:	53                   	push   %ebx
 1a8:	8b 75 08             	mov    0x8(%ebp),%esi
 1ab:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1b1:	85 db                	test   %ebx,%ebx
 1b3:	7e 15                	jle    1ca <memmove+0x27>
 1b5:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1b7:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1b9:	83 c2 01             	add    $0x1,%edx
 1bc:	83 c0 01             	add    $0x1,%eax
 1bf:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1c3:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 1c6:	39 c3                	cmp    %eax,%ebx
 1c8:	75 ef                	jne    1b9 <memmove+0x16>
  return vdst;
}
 1ca:	89 f0                	mov    %esi,%eax
 1cc:	5b                   	pop    %ebx
 1cd:	5e                   	pop    %esi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1d0:	b8 01 00 00 00       	mov    $0x1,%eax
 1d5:	cd 40                	int    $0x40
 1d7:	c3                   	ret    

000001d8 <exit>:
SYSCALL(exit)
 1d8:	b8 02 00 00 00       	mov    $0x2,%eax
 1dd:	cd 40                	int    $0x40
 1df:	c3                   	ret    

000001e0 <wait>:
SYSCALL(wait)
 1e0:	b8 03 00 00 00       	mov    $0x3,%eax
 1e5:	cd 40                	int    $0x40
 1e7:	c3                   	ret    

000001e8 <pipe>:
SYSCALL(pipe)
 1e8:	b8 04 00 00 00       	mov    $0x4,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <read>:
SYSCALL(read)
 1f0:	b8 05 00 00 00       	mov    $0x5,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <write>:
SYSCALL(write)
 1f8:	b8 10 00 00 00       	mov    $0x10,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <close>:
SYSCALL(close)
 200:	b8 15 00 00 00       	mov    $0x15,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <kill>:
SYSCALL(kill)
 208:	b8 06 00 00 00       	mov    $0x6,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <exec>:
SYSCALL(exec)
 210:	b8 07 00 00 00       	mov    $0x7,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <open>:
SYSCALL(open)
 218:	b8 0f 00 00 00       	mov    $0xf,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <mknod>:
SYSCALL(mknod)
 220:	b8 11 00 00 00       	mov    $0x11,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <unlink>:
SYSCALL(unlink)
 228:	b8 12 00 00 00       	mov    $0x12,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <fstat>:
SYSCALL(fstat)
 230:	b8 08 00 00 00       	mov    $0x8,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <link>:
SYSCALL(link)
 238:	b8 13 00 00 00       	mov    $0x13,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <mkdir>:
SYSCALL(mkdir)
 240:	b8 14 00 00 00       	mov    $0x14,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <chdir>:
SYSCALL(chdir)
 248:	b8 09 00 00 00       	mov    $0x9,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <dup>:
SYSCALL(dup)
 250:	b8 0a 00 00 00       	mov    $0xa,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <getpid>:
SYSCALL(getpid)
 258:	b8 0b 00 00 00       	mov    $0xb,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <sbrk>:
SYSCALL(sbrk)
 260:	b8 0c 00 00 00       	mov    $0xc,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <sleep>:
SYSCALL(sleep)
 268:	b8 0d 00 00 00       	mov    $0xd,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <uptime>:
SYSCALL(uptime)
 270:	b8 0e 00 00 00       	mov    $0xe,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <slabtest>:
SYSCALL(slabtest)
 278:	b8 16 00 00 00       	mov    $0x16,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <ps>:
SYSCALL(ps)
 280:	b8 17 00 00 00       	mov    $0x17,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	57                   	push   %edi
 28c:	56                   	push   %esi
 28d:	53                   	push   %ebx
 28e:	83 ec 3c             	sub    $0x3c,%esp
 291:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 294:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 29a:	74 79                	je     315 <printint+0x8d>
 29c:	85 d2                	test   %edx,%edx
 29e:	79 75                	jns    315 <printint+0x8d>
    neg = 1;
    x = -xx;
 2a0:	89 d1                	mov    %edx,%ecx
 2a2:	f7 d9                	neg    %ecx
    neg = 1;
 2a4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2b0:	89 df                	mov    %ebx,%edi
 2b2:	83 c3 01             	add    $0x1,%ebx
 2b5:	89 c8                	mov    %ecx,%eax
 2b7:	ba 00 00 00 00       	mov    $0x0,%edx
 2bc:	f7 f6                	div    %esi
 2be:	0f b6 92 78 06 00 00 	movzbl 0x678(%edx),%edx
 2c5:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 2c9:	89 ca                	mov    %ecx,%edx
 2cb:	89 c1                	mov    %eax,%ecx
 2cd:	39 d6                	cmp    %edx,%esi
 2cf:	76 df                	jbe    2b0 <printint+0x28>
  if(neg)
 2d1:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 2d5:	74 08                	je     2df <printint+0x57>
    buf[i++] = '-';
 2d7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2dc:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 2df:	85 db                	test   %ebx,%ebx
 2e1:	7e 2a                	jle    30d <printint+0x85>
 2e3:	8d 7d d8             	lea    -0x28(%ebp),%edi
 2e6:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 2ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 2ed:	0f b6 03             	movzbl (%ebx),%eax
 2f0:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 2f3:	83 ec 04             	sub    $0x4,%esp
 2f6:	6a 01                	push   $0x1
 2f8:	56                   	push   %esi
 2f9:	ff 75 c4             	push   -0x3c(%ebp)
 2fc:	e8 f7 fe ff ff       	call   1f8 <write>
  while(--i >= 0)
 301:	89 d8                	mov    %ebx,%eax
 303:	83 eb 01             	sub    $0x1,%ebx
 306:	83 c4 10             	add    $0x10,%esp
 309:	39 f8                	cmp    %edi,%eax
 30b:	75 e0                	jne    2ed <printint+0x65>
}
 30d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 310:	5b                   	pop    %ebx
 311:	5e                   	pop    %esi
 312:	5f                   	pop    %edi
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    
    x = xx;
 315:	89 d1                	mov    %edx,%ecx
  neg = 0;
 317:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 31e:	eb 8b                	jmp    2ab <printint+0x23>

00000320 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
 326:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 329:	8b 75 0c             	mov    0xc(%ebp),%esi
 32c:	0f b6 1e             	movzbl (%esi),%ebx
 32f:	84 db                	test   %bl,%bl
 331:	0f 84 9f 01 00 00    	je     4d6 <printf+0x1b6>
 337:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 33a:	8d 45 10             	lea    0x10(%ebp),%eax
 33d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 340:	bf 00 00 00 00       	mov    $0x0,%edi
 345:	eb 2d                	jmp    374 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 347:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 34a:	83 ec 04             	sub    $0x4,%esp
 34d:	6a 01                	push   $0x1
 34f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 352:	50                   	push   %eax
 353:	ff 75 08             	push   0x8(%ebp)
 356:	e8 9d fe ff ff       	call   1f8 <write>
        putc(fd, c);
 35b:	83 c4 10             	add    $0x10,%esp
 35e:	eb 05                	jmp    365 <printf+0x45>
      }
    } else if(state == '%'){
 360:	83 ff 25             	cmp    $0x25,%edi
 363:	74 1f                	je     384 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 365:	83 c6 01             	add    $0x1,%esi
 368:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 36c:	84 db                	test   %bl,%bl
 36e:	0f 84 62 01 00 00    	je     4d6 <printf+0x1b6>
    c = fmt[i] & 0xff;
 374:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 377:	85 ff                	test   %edi,%edi
 379:	75 e5                	jne    360 <printf+0x40>
      if(c == '%'){
 37b:	83 f8 25             	cmp    $0x25,%eax
 37e:	75 c7                	jne    347 <printf+0x27>
        state = '%';
 380:	89 c7                	mov    %eax,%edi
 382:	eb e1                	jmp    365 <printf+0x45>
      if(c == 'd'){
 384:	83 f8 25             	cmp    $0x25,%eax
 387:	0f 84 f2 00 00 00    	je     47f <printf+0x15f>
 38d:	8d 50 9d             	lea    -0x63(%eax),%edx
 390:	83 fa 15             	cmp    $0x15,%edx
 393:	0f 87 07 01 00 00    	ja     4a0 <printf+0x180>
 399:	0f 87 01 01 00 00    	ja     4a0 <printf+0x180>
 39f:	ff 24 95 20 06 00 00 	jmp    *0x620(,%edx,4)
        printint(fd, *ap, 10, 1);
 3a6:	83 ec 0c             	sub    $0xc,%esp
 3a9:	6a 01                	push   $0x1
 3ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3b3:	8b 17                	mov    (%edi),%edx
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	e8 cb fe ff ff       	call   288 <printint>
        ap++;
 3bd:	89 f8                	mov    %edi,%eax
 3bf:	83 c0 04             	add    $0x4,%eax
 3c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3c5:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3c8:	bf 00 00 00 00       	mov    $0x0,%edi
 3cd:	eb 96                	jmp    365 <printf+0x45>
        printint(fd, *ap, 16, 0);
 3cf:	83 ec 0c             	sub    $0xc,%esp
 3d2:	6a 00                	push   $0x0
 3d4:	b9 10 00 00 00       	mov    $0x10,%ecx
 3d9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3dc:	8b 17                	mov    (%edi),%edx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	e8 a2 fe ff ff       	call   288 <printint>
        ap++;
 3e6:	89 f8                	mov    %edi,%eax
 3e8:	83 c0 04             	add    $0x4,%eax
 3eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3ee:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f1:	bf 00 00 00 00       	mov    $0x0,%edi
 3f6:	e9 6a ff ff ff       	jmp    365 <printf+0x45>
        s = (char*)*ap;
 3fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 3fe:	8b 01                	mov    (%ecx),%eax
        ap++;
 400:	83 c1 04             	add    $0x4,%ecx
 403:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 406:	85 c0                	test   %eax,%eax
 408:	74 13                	je     41d <printf+0xfd>
        s = (char*)*ap;
 40a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 40c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 40f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 414:	84 c0                	test   %al,%al
 416:	75 0f                	jne    427 <printf+0x107>
 418:	e9 48 ff ff ff       	jmp    365 <printf+0x45>
          s = "(null)";
 41d:	bb 18 06 00 00       	mov    $0x618,%ebx
        while(*s != 0){
 422:	b8 28 00 00 00       	mov    $0x28,%eax
 427:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 42a:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 42d:	83 ec 04             	sub    $0x4,%esp
 430:	6a 01                	push   $0x1
 432:	8d 45 e7             	lea    -0x19(%ebp),%eax
 435:	50                   	push   %eax
 436:	57                   	push   %edi
 437:	e8 bc fd ff ff       	call   1f8 <write>
          s++;
 43c:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 43f:	0f b6 03             	movzbl (%ebx),%eax
 442:	83 c4 10             	add    $0x10,%esp
 445:	84 c0                	test   %al,%al
 447:	75 e1                	jne    42a <printf+0x10a>
      state = 0;
 449:	bf 00 00 00 00       	mov    $0x0,%edi
 44e:	e9 12 ff ff ff       	jmp    365 <printf+0x45>
        putc(fd, *ap);
 453:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 456:	8b 07                	mov    (%edi),%eax
 458:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	6a 01                	push   $0x1
 460:	8d 45 e7             	lea    -0x19(%ebp),%eax
 463:	50                   	push   %eax
 464:	ff 75 08             	push   0x8(%ebp)
 467:	e8 8c fd ff ff       	call   1f8 <write>
        ap++;
 46c:	83 c7 04             	add    $0x4,%edi
 46f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 472:	83 c4 10             	add    $0x10,%esp
      state = 0;
 475:	bf 00 00 00 00       	mov    $0x0,%edi
 47a:	e9 e6 fe ff ff       	jmp    365 <printf+0x45>
        putc(fd, c);
 47f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 482:	83 ec 04             	sub    $0x4,%esp
 485:	6a 01                	push   $0x1
 487:	8d 45 e7             	lea    -0x19(%ebp),%eax
 48a:	50                   	push   %eax
 48b:	ff 75 08             	push   0x8(%ebp)
 48e:	e8 65 fd ff ff       	call   1f8 <write>
 493:	83 c4 10             	add    $0x10,%esp
      state = 0;
 496:	bf 00 00 00 00       	mov    $0x0,%edi
 49b:	e9 c5 fe ff ff       	jmp    365 <printf+0x45>
        putc(fd, '%');
 4a0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	6a 01                	push   $0x1
 4a9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	push   0x8(%ebp)
 4b0:	e8 43 fd ff ff       	call   1f8 <write>
        putc(fd, c);
 4b5:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4b8:	83 c4 0c             	add    $0xc,%esp
 4bb:	6a 01                	push   $0x1
 4bd:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	push   0x8(%ebp)
 4c4:	e8 2f fd ff ff       	call   1f8 <write>
        putc(fd, c);
 4c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cc:	bf 00 00 00 00       	mov    $0x0,%edi
 4d1:	e9 8f fe ff ff       	jmp    365 <printf+0x45>
    }
  }
}
 4d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5f                   	pop    %edi
 4dc:	5d                   	pop    %ebp
 4dd:	c3                   	ret    

000004de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	57                   	push   %edi
 4e2:	56                   	push   %esi
 4e3:	53                   	push   %ebx
 4e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ea:	a1 d8 08 00 00       	mov    0x8d8,%eax
 4ef:	eb 0c                	jmp    4fd <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f1:	8b 10                	mov    (%eax),%edx
 4f3:	39 c2                	cmp    %eax,%edx
 4f5:	77 04                	ja     4fb <free+0x1d>
 4f7:	39 ca                	cmp    %ecx,%edx
 4f9:	77 10                	ja     50b <free+0x2d>
{
 4fb:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fd:	39 c8                	cmp    %ecx,%eax
 4ff:	73 f0                	jae    4f1 <free+0x13>
 501:	8b 10                	mov    (%eax),%edx
 503:	39 ca                	cmp    %ecx,%edx
 505:	77 04                	ja     50b <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 507:	39 c2                	cmp    %eax,%edx
 509:	77 f0                	ja     4fb <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 50b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 50e:	8b 10                	mov    (%eax),%edx
 510:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 513:	39 fa                	cmp    %edi,%edx
 515:	74 19                	je     530 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 517:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 51a:	8b 50 04             	mov    0x4(%eax),%edx
 51d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 520:	39 f1                	cmp    %esi,%ecx
 522:	74 18                	je     53c <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 524:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 526:	a3 d8 08 00 00       	mov    %eax,0x8d8
}
 52b:	5b                   	pop    %ebx
 52c:	5e                   	pop    %esi
 52d:	5f                   	pop    %edi
 52e:	5d                   	pop    %ebp
 52f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 530:	03 72 04             	add    0x4(%edx),%esi
 533:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 536:	8b 10                	mov    (%eax),%edx
 538:	8b 12                	mov    (%edx),%edx
 53a:	eb db                	jmp    517 <free+0x39>
    p->s.size += bp->s.size;
 53c:	03 53 fc             	add    -0x4(%ebx),%edx
 53f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 542:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 545:	eb dd                	jmp    524 <free+0x46>

00000547 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	57                   	push   %edi
 54b:	56                   	push   %esi
 54c:	53                   	push   %ebx
 54d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	8d 58 07             	lea    0x7(%eax),%ebx
 556:	c1 eb 03             	shr    $0x3,%ebx
 559:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 55c:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
 562:	85 d2                	test   %edx,%edx
 564:	74 1c                	je     582 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 566:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 568:	8b 48 04             	mov    0x4(%eax),%ecx
 56b:	39 cb                	cmp    %ecx,%ebx
 56d:	76 38                	jbe    5a7 <malloc+0x60>
 56f:	be 00 10 00 00       	mov    $0x1000,%esi
 574:	39 f3                	cmp    %esi,%ebx
 576:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 579:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 580:	eb 72                	jmp    5f4 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 582:	c7 05 d8 08 00 00 dc 	movl   $0x8dc,0x8d8
 589:	08 00 00 
 58c:	c7 05 dc 08 00 00 dc 	movl   $0x8dc,0x8dc
 593:	08 00 00 
    base.s.size = 0;
 596:	c7 05 e0 08 00 00 00 	movl   $0x0,0x8e0
 59d:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a0:	b8 dc 08 00 00       	mov    $0x8dc,%eax
 5a5:	eb c8                	jmp    56f <malloc+0x28>
      if(p->s.size == nunits)
 5a7:	39 cb                	cmp    %ecx,%ebx
 5a9:	74 1e                	je     5c9 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ab:	29 d9                	sub    %ebx,%ecx
 5ad:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5b0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5b3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5b6:	89 15 d8 08 00 00    	mov    %edx,0x8d8
      return (void*)(p + 1);
 5bc:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5bf:	89 d0                	mov    %edx,%eax
 5c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c4:	5b                   	pop    %ebx
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5c9:	8b 08                	mov    (%eax),%ecx
 5cb:	89 0a                	mov    %ecx,(%edx)
 5cd:	eb e7                	jmp    5b6 <malloc+0x6f>
  hp->s.size = nu;
 5cf:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 5d2:	83 ec 0c             	sub    $0xc,%esp
 5d5:	83 c0 08             	add    $0x8,%eax
 5d8:	50                   	push   %eax
 5d9:	e8 00 ff ff ff       	call   4de <free>
  return freep;
 5de:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
      if((p = morecore(nunits)) == 0)
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	85 d2                	test   %edx,%edx
 5e9:	74 d4                	je     5bf <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5eb:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ed:	8b 48 04             	mov    0x4(%eax),%ecx
 5f0:	39 d9                	cmp    %ebx,%ecx
 5f2:	73 b3                	jae    5a7 <malloc+0x60>
    if(p == freep)
 5f4:	89 c2                	mov    %eax,%edx
 5f6:	39 05 d8 08 00 00    	cmp    %eax,0x8d8
 5fc:	75 ed                	jne    5eb <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 5fe:	83 ec 0c             	sub    $0xc,%esp
 601:	57                   	push   %edi
 602:	e8 59 fc ff ff       	call   260 <sbrk>
  if(p == (char*)-1)
 607:	83 c4 10             	add    $0x10,%esp
 60a:	83 f8 ff             	cmp    $0xffffffff,%eax
 60d:	75 c0                	jne    5cf <malloc+0x88>
        return 0;
 60f:	ba 00 00 00 00       	mov    $0x0,%edx
 614:	eb a9                	jmp    5bf <malloc+0x78>
