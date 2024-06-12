
user/_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	ps();
  11:	e8 84 02 00 00       	call   29a <ps>
	printf(1, "ps\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 30 06 00 00       	push   $0x630
  1e:	6a 01                	push   $0x1
  20:	e8 15 03 00 00       	call   33a <printf>
    exit();
  25:	e8 c8 01 00 00       	call   1f2 <exit>

0000002a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	53                   	push   %ebx
  2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	b8 00 00 00 00       	mov    $0x0,%eax
  39:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  3d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  40:	83 c0 01             	add    $0x1,%eax
  43:	84 d2                	test   %dl,%dl
  45:	75 f2                	jne    39 <strcpy+0xf>
    ;
  return os;
}
  47:	89 c8                	mov    %ecx,%eax
  49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4c:	c9                   	leave  
  4d:	c3                   	ret    

0000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  54:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  57:	0f b6 01             	movzbl (%ecx),%eax
  5a:	84 c0                	test   %al,%al
  5c:	74 11                	je     6f <strcmp+0x21>
  5e:	38 02                	cmp    %al,(%edx)
  60:	75 0d                	jne    6f <strcmp+0x21>
    p++, q++;
  62:	83 c1 01             	add    $0x1,%ecx
  65:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  68:	0f b6 01             	movzbl (%ecx),%eax
  6b:	84 c0                	test   %al,%al
  6d:	75 ef                	jne    5e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  6f:	0f b6 c0             	movzbl %al,%eax
  72:	0f b6 12             	movzbl (%edx),%edx
  75:	29 d0                	sub    %edx,%eax
}
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <strlen>:

uint
strlen(const char *s)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  7f:	80 3a 00             	cmpb   $0x0,(%edx)
  82:	74 14                	je     98 <strlen+0x1f>
  84:	b8 00 00 00 00       	mov    $0x0,%eax
  89:	83 c0 01             	add    $0x1,%eax
  8c:	89 c1                	mov    %eax,%ecx
  8e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  92:	75 f5                	jne    89 <strlen+0x10>
    ;
  return n;
}
  94:	89 c8                	mov    %ecx,%eax
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    
  for(n = 0; s[n]; n++)
  98:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
  9d:	eb f5                	jmp    94 <strlen+0x1b>

0000009f <memset>:

void*
memset(void *dst, int c, uint n)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	57                   	push   %edi
  a3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a6:	89 d7                	mov    %edx,%edi
  a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	fc                   	cld    
  af:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b1:	89 d0                	mov    %edx,%eax
  b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <strchr>:

char*
strchr(const char *s, char c)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c2:	0f b6 10             	movzbl (%eax),%edx
  c5:	84 d2                	test   %dl,%dl
  c7:	74 15                	je     de <strchr+0x26>
    if(*s == c)
  c9:	38 d1                	cmp    %dl,%cl
  cb:	74 0f                	je     dc <strchr+0x24>
  for(; *s; s++)
  cd:	83 c0 01             	add    $0x1,%eax
  d0:	0f b6 10             	movzbl (%eax),%edx
  d3:	84 d2                	test   %dl,%dl
  d5:	75 f2                	jne    c9 <strchr+0x11>
      return (char*)s;
  return 0;
  d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  dc:	5d                   	pop    %ebp
  dd:	c3                   	ret    
  return 0;
  de:	b8 00 00 00 00       	mov    $0x0,%eax
  e3:	eb f7                	jmp    dc <strchr+0x24>

000000e5 <gets>:

char*
gets(char *buf, int max)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	57                   	push   %edi
  e9:	56                   	push   %esi
  ea:	53                   	push   %ebx
  eb:	83 ec 2c             	sub    $0x2c,%esp
  ee:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f1:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
  f6:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  f9:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  fc:	83 c3 01             	add    $0x1,%ebx
  ff:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 102:	7d 27                	jge    12b <gets+0x46>
    cc = read(0, &c, 1);
 104:	83 ec 04             	sub    $0x4,%esp
 107:	6a 01                	push   $0x1
 109:	57                   	push   %edi
 10a:	6a 00                	push   $0x0
 10c:	e8 f9 00 00 00       	call   20a <read>
    if(cc < 1)
 111:	83 c4 10             	add    $0x10,%esp
 114:	85 c0                	test   %eax,%eax
 116:	7e 13                	jle    12b <gets+0x46>
      break;
    buf[i++] = c;
 118:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11c:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 120:	3c 0a                	cmp    $0xa,%al
 122:	74 04                	je     128 <gets+0x43>
 124:	3c 0d                	cmp    $0xd,%al
 126:	75 d1                	jne    f9 <gets+0x14>
  for(i=0; i+1 < max; ){
 128:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 12b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 12e:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 132:	89 f0                	mov    %esi,%eax
 134:	8d 65 f4             	lea    -0xc(%ebp),%esp
 137:	5b                   	pop    %ebx
 138:	5e                   	pop    %esi
 139:	5f                   	pop    %edi
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <stat>:

int
stat(const char *n, struct stat *st)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	56                   	push   %esi
 140:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 141:	83 ec 08             	sub    $0x8,%esp
 144:	6a 00                	push   $0x0
 146:	ff 75 08             	push   0x8(%ebp)
 149:	e8 e4 00 00 00       	call   232 <open>
  if(fd < 0)
 14e:	83 c4 10             	add    $0x10,%esp
 151:	85 c0                	test   %eax,%eax
 153:	78 24                	js     179 <stat+0x3d>
 155:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	ff 75 0c             	push   0xc(%ebp)
 15d:	50                   	push   %eax
 15e:	e8 e7 00 00 00       	call   24a <fstat>
 163:	89 c6                	mov    %eax,%esi
  close(fd);
 165:	89 1c 24             	mov    %ebx,(%esp)
 168:	e8 ad 00 00 00       	call   21a <close>
  return r;
 16d:	83 c4 10             	add    $0x10,%esp
}
 170:	89 f0                	mov    %esi,%eax
 172:	8d 65 f8             	lea    -0x8(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
    return -1;
 179:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17e:	eb f0                	jmp    170 <stat+0x34>

00000180 <atoi>:

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 187:	0f b6 02             	movzbl (%edx),%eax
 18a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 18d:	80 f9 09             	cmp    $0x9,%cl
 190:	77 24                	ja     1b6 <atoi+0x36>
  n = 0;
 192:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 197:	83 c2 01             	add    $0x1,%edx
 19a:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 19d:	0f be c0             	movsbl %al,%eax
 1a0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1a4:	0f b6 02             	movzbl (%edx),%eax
 1a7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1aa:	80 fb 09             	cmp    $0x9,%bl
 1ad:	76 e8                	jbe    197 <atoi+0x17>
  return n;
}
 1af:	89 c8                	mov    %ecx,%eax
 1b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    
  n = 0;
 1b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1bb:	eb f2                	jmp    1af <atoi+0x2f>

000001bd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	8b 75 08             	mov    0x8(%ebp),%esi
 1c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 1c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1cb:	85 db                	test   %ebx,%ebx
 1cd:	7e 15                	jle    1e4 <memmove+0x27>
 1cf:	01 f3                	add    %esi,%ebx
  dst = vdst;
 1d1:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 1d3:	83 c2 01             	add    $0x1,%edx
 1d6:	83 c0 01             	add    $0x1,%eax
 1d9:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1dd:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 1e0:	39 c3                	cmp    %eax,%ebx
 1e2:	75 ef                	jne    1d3 <memmove+0x16>
  return vdst;
}
 1e4:	89 f0                	mov    %esi,%eax
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    

000001ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ea:	b8 01 00 00 00       	mov    $0x1,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <exit>:
SYSCALL(exit)
 1f2:	b8 02 00 00 00       	mov    $0x2,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <wait>:
SYSCALL(wait)
 1fa:	b8 03 00 00 00       	mov    $0x3,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <pipe>:
SYSCALL(pipe)
 202:	b8 04 00 00 00       	mov    $0x4,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <read>:
SYSCALL(read)
 20a:	b8 05 00 00 00       	mov    $0x5,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <write>:
SYSCALL(write)
 212:	b8 10 00 00 00       	mov    $0x10,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <close>:
SYSCALL(close)
 21a:	b8 15 00 00 00       	mov    $0x15,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <kill>:
SYSCALL(kill)
 222:	b8 06 00 00 00       	mov    $0x6,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <exec>:
SYSCALL(exec)
 22a:	b8 07 00 00 00       	mov    $0x7,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <open>:
SYSCALL(open)
 232:	b8 0f 00 00 00       	mov    $0xf,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <mknod>:
SYSCALL(mknod)
 23a:	b8 11 00 00 00       	mov    $0x11,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <unlink>:
SYSCALL(unlink)
 242:	b8 12 00 00 00       	mov    $0x12,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <fstat>:
SYSCALL(fstat)
 24a:	b8 08 00 00 00       	mov    $0x8,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <link>:
SYSCALL(link)
 252:	b8 13 00 00 00       	mov    $0x13,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mkdir>:
SYSCALL(mkdir)
 25a:	b8 14 00 00 00       	mov    $0x14,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <chdir>:
SYSCALL(chdir)
 262:	b8 09 00 00 00       	mov    $0x9,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <dup>:
SYSCALL(dup)
 26a:	b8 0a 00 00 00       	mov    $0xa,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <getpid>:
SYSCALL(getpid)
 272:	b8 0b 00 00 00       	mov    $0xb,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <sbrk>:
SYSCALL(sbrk)
 27a:	b8 0c 00 00 00       	mov    $0xc,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <sleep>:
SYSCALL(sleep)
 282:	b8 0d 00 00 00       	mov    $0xd,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <uptime>:
SYSCALL(uptime)
 28a:	b8 0e 00 00 00       	mov    $0xe,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <slabtest>:
SYSCALL(slabtest)
 292:	b8 16 00 00 00       	mov    $0x16,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <ps>:
SYSCALL(ps)
 29a:	b8 17 00 00 00       	mov    $0x17,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	57                   	push   %edi
 2a6:	56                   	push   %esi
 2a7:	53                   	push   %ebx
 2a8:	83 ec 3c             	sub    $0x3c,%esp
 2ab:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2ae:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2b4:	74 79                	je     32f <printint+0x8d>
 2b6:	85 d2                	test   %edx,%edx
 2b8:	79 75                	jns    32f <printint+0x8d>
    neg = 1;
    x = -xx;
 2ba:	89 d1                	mov    %edx,%ecx
 2bc:	f7 d9                	neg    %ecx
    neg = 1;
 2be:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ca:	89 df                	mov    %ebx,%edi
 2cc:	83 c3 01             	add    $0x1,%ebx
 2cf:	89 c8                	mov    %ecx,%eax
 2d1:	ba 00 00 00 00       	mov    $0x0,%edx
 2d6:	f7 f6                	div    %esi
 2d8:	0f b6 92 94 06 00 00 	movzbl 0x694(%edx),%edx
 2df:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 2e3:	89 ca                	mov    %ecx,%edx
 2e5:	89 c1                	mov    %eax,%ecx
 2e7:	39 d6                	cmp    %edx,%esi
 2e9:	76 df                	jbe    2ca <printint+0x28>
  if(neg)
 2eb:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 2ef:	74 08                	je     2f9 <printint+0x57>
    buf[i++] = '-';
 2f1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2f6:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 2f9:	85 db                	test   %ebx,%ebx
 2fb:	7e 2a                	jle    327 <printint+0x85>
 2fd:	8d 7d d8             	lea    -0x28(%ebp),%edi
 300:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 304:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 307:	0f b6 03             	movzbl (%ebx),%eax
 30a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 30d:	83 ec 04             	sub    $0x4,%esp
 310:	6a 01                	push   $0x1
 312:	56                   	push   %esi
 313:	ff 75 c4             	push   -0x3c(%ebp)
 316:	e8 f7 fe ff ff       	call   212 <write>
  while(--i >= 0)
 31b:	89 d8                	mov    %ebx,%eax
 31d:	83 eb 01             	sub    $0x1,%ebx
 320:	83 c4 10             	add    $0x10,%esp
 323:	39 f8                	cmp    %edi,%eax
 325:	75 e0                	jne    307 <printint+0x65>
}
 327:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32a:	5b                   	pop    %ebx
 32b:	5e                   	pop    %esi
 32c:	5f                   	pop    %edi
 32d:	5d                   	pop    %ebp
 32e:	c3                   	ret    
    x = xx;
 32f:	89 d1                	mov    %edx,%ecx
  neg = 0;
 331:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 338:	eb 8b                	jmp    2c5 <printint+0x23>

0000033a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	57                   	push   %edi
 33e:	56                   	push   %esi
 33f:	53                   	push   %ebx
 340:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 343:	8b 75 0c             	mov    0xc(%ebp),%esi
 346:	0f b6 1e             	movzbl (%esi),%ebx
 349:	84 db                	test   %bl,%bl
 34b:	0f 84 9f 01 00 00    	je     4f0 <printf+0x1b6>
 351:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 354:	8d 45 10             	lea    0x10(%ebp),%eax
 357:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 35a:	bf 00 00 00 00       	mov    $0x0,%edi
 35f:	eb 2d                	jmp    38e <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 361:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 364:	83 ec 04             	sub    $0x4,%esp
 367:	6a 01                	push   $0x1
 369:	8d 45 e7             	lea    -0x19(%ebp),%eax
 36c:	50                   	push   %eax
 36d:	ff 75 08             	push   0x8(%ebp)
 370:	e8 9d fe ff ff       	call   212 <write>
        putc(fd, c);
 375:	83 c4 10             	add    $0x10,%esp
 378:	eb 05                	jmp    37f <printf+0x45>
      }
    } else if(state == '%'){
 37a:	83 ff 25             	cmp    $0x25,%edi
 37d:	74 1f                	je     39e <printf+0x64>
  for(i = 0; fmt[i]; i++){
 37f:	83 c6 01             	add    $0x1,%esi
 382:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 386:	84 db                	test   %bl,%bl
 388:	0f 84 62 01 00 00    	je     4f0 <printf+0x1b6>
    c = fmt[i] & 0xff;
 38e:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 391:	85 ff                	test   %edi,%edi
 393:	75 e5                	jne    37a <printf+0x40>
      if(c == '%'){
 395:	83 f8 25             	cmp    $0x25,%eax
 398:	75 c7                	jne    361 <printf+0x27>
        state = '%';
 39a:	89 c7                	mov    %eax,%edi
 39c:	eb e1                	jmp    37f <printf+0x45>
      if(c == 'd'){
 39e:	83 f8 25             	cmp    $0x25,%eax
 3a1:	0f 84 f2 00 00 00    	je     499 <printf+0x15f>
 3a7:	8d 50 9d             	lea    -0x63(%eax),%edx
 3aa:	83 fa 15             	cmp    $0x15,%edx
 3ad:	0f 87 07 01 00 00    	ja     4ba <printf+0x180>
 3b3:	0f 87 01 01 00 00    	ja     4ba <printf+0x180>
 3b9:	ff 24 95 3c 06 00 00 	jmp    *0x63c(,%edx,4)
        printint(fd, *ap, 10, 1);
 3c0:	83 ec 0c             	sub    $0xc,%esp
 3c3:	6a 01                	push   $0x1
 3c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3cd:	8b 17                	mov    (%edi),%edx
 3cf:	8b 45 08             	mov    0x8(%ebp),%eax
 3d2:	e8 cb fe ff ff       	call   2a2 <printint>
        ap++;
 3d7:	89 f8                	mov    %edi,%eax
 3d9:	83 c0 04             	add    $0x4,%eax
 3dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3df:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3e2:	bf 00 00 00 00       	mov    $0x0,%edi
 3e7:	eb 96                	jmp    37f <printf+0x45>
        printint(fd, *ap, 16, 0);
 3e9:	83 ec 0c             	sub    $0xc,%esp
 3ec:	6a 00                	push   $0x0
 3ee:	b9 10 00 00 00       	mov    $0x10,%ecx
 3f3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3f6:	8b 17                	mov    (%edi),%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	e8 a2 fe ff ff       	call   2a2 <printint>
        ap++;
 400:	89 f8                	mov    %edi,%eax
 402:	83 c0 04             	add    $0x4,%eax
 405:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 408:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40b:	bf 00 00 00 00       	mov    $0x0,%edi
 410:	e9 6a ff ff ff       	jmp    37f <printf+0x45>
        s = (char*)*ap;
 415:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 418:	8b 01                	mov    (%ecx),%eax
        ap++;
 41a:	83 c1 04             	add    $0x4,%ecx
 41d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 420:	85 c0                	test   %eax,%eax
 422:	74 13                	je     437 <printf+0xfd>
        s = (char*)*ap;
 424:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 426:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 429:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 42e:	84 c0                	test   %al,%al
 430:	75 0f                	jne    441 <printf+0x107>
 432:	e9 48 ff ff ff       	jmp    37f <printf+0x45>
          s = "(null)";
 437:	bb 34 06 00 00       	mov    $0x634,%ebx
        while(*s != 0){
 43c:	b8 28 00 00 00       	mov    $0x28,%eax
 441:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 444:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 447:	83 ec 04             	sub    $0x4,%esp
 44a:	6a 01                	push   $0x1
 44c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 44f:	50                   	push   %eax
 450:	57                   	push   %edi
 451:	e8 bc fd ff ff       	call   212 <write>
          s++;
 456:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 459:	0f b6 03             	movzbl (%ebx),%eax
 45c:	83 c4 10             	add    $0x10,%esp
 45f:	84 c0                	test   %al,%al
 461:	75 e1                	jne    444 <printf+0x10a>
      state = 0;
 463:	bf 00 00 00 00       	mov    $0x0,%edi
 468:	e9 12 ff ff ff       	jmp    37f <printf+0x45>
        putc(fd, *ap);
 46d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 470:	8b 07                	mov    (%edi),%eax
 472:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 475:	83 ec 04             	sub    $0x4,%esp
 478:	6a 01                	push   $0x1
 47a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 47d:	50                   	push   %eax
 47e:	ff 75 08             	push   0x8(%ebp)
 481:	e8 8c fd ff ff       	call   212 <write>
        ap++;
 486:	83 c7 04             	add    $0x4,%edi
 489:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 48c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48f:	bf 00 00 00 00       	mov    $0x0,%edi
 494:	e9 e6 fe ff ff       	jmp    37f <printf+0x45>
        putc(fd, c);
 499:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 49c:	83 ec 04             	sub    $0x4,%esp
 49f:	6a 01                	push   $0x1
 4a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	push   0x8(%ebp)
 4a8:	e8 65 fd ff ff       	call   212 <write>
 4ad:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b0:	bf 00 00 00 00       	mov    $0x0,%edi
 4b5:	e9 c5 fe ff ff       	jmp    37f <printf+0x45>
        putc(fd, '%');
 4ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4be:	83 ec 04             	sub    $0x4,%esp
 4c1:	6a 01                	push   $0x1
 4c3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c6:	50                   	push   %eax
 4c7:	ff 75 08             	push   0x8(%ebp)
 4ca:	e8 43 fd ff ff       	call   212 <write>
        putc(fd, c);
 4cf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4d2:	83 c4 0c             	add    $0xc,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4da:	50                   	push   %eax
 4db:	ff 75 08             	push   0x8(%ebp)
 4de:	e8 2f fd ff ff       	call   212 <write>
        putc(fd, c);
 4e3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e6:	bf 00 00 00 00       	mov    $0x0,%edi
 4eb:	e9 8f fe ff ff       	jmp    37f <printf+0x45>
    }
  }
}
 4f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    

000004f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	57                   	push   %edi
 4fc:	56                   	push   %esi
 4fd:	53                   	push   %ebx
 4fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 501:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 504:	a1 fc 08 00 00       	mov    0x8fc,%eax
 509:	eb 0c                	jmp    517 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50b:	8b 10                	mov    (%eax),%edx
 50d:	39 c2                	cmp    %eax,%edx
 50f:	77 04                	ja     515 <free+0x1d>
 511:	39 ca                	cmp    %ecx,%edx
 513:	77 10                	ja     525 <free+0x2d>
{
 515:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 517:	39 c8                	cmp    %ecx,%eax
 519:	73 f0                	jae    50b <free+0x13>
 51b:	8b 10                	mov    (%eax),%edx
 51d:	39 ca                	cmp    %ecx,%edx
 51f:	77 04                	ja     525 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 521:	39 c2                	cmp    %eax,%edx
 523:	77 f0                	ja     515 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 525:	8b 73 fc             	mov    -0x4(%ebx),%esi
 528:	8b 10                	mov    (%eax),%edx
 52a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52d:	39 fa                	cmp    %edi,%edx
 52f:	74 19                	je     54a <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 531:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 534:	8b 50 04             	mov    0x4(%eax),%edx
 537:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 53a:	39 f1                	cmp    %esi,%ecx
 53c:	74 18                	je     556 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 53e:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 540:	a3 fc 08 00 00       	mov    %eax,0x8fc
}
 545:	5b                   	pop    %ebx
 546:	5e                   	pop    %esi
 547:	5f                   	pop    %edi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 54a:	03 72 04             	add    0x4(%edx),%esi
 54d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 550:	8b 10                	mov    (%eax),%edx
 552:	8b 12                	mov    (%edx),%edx
 554:	eb db                	jmp    531 <free+0x39>
    p->s.size += bp->s.size;
 556:	03 53 fc             	add    -0x4(%ebx),%edx
 559:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55c:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 55f:	eb dd                	jmp    53e <free+0x46>

00000561 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	57                   	push   %edi
 565:	56                   	push   %esi
 566:	53                   	push   %ebx
 567:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	8d 58 07             	lea    0x7(%eax),%ebx
 570:	c1 eb 03             	shr    $0x3,%ebx
 573:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 576:	8b 15 fc 08 00 00    	mov    0x8fc,%edx
 57c:	85 d2                	test   %edx,%edx
 57e:	74 1c                	je     59c <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 580:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 582:	8b 48 04             	mov    0x4(%eax),%ecx
 585:	39 cb                	cmp    %ecx,%ebx
 587:	76 38                	jbe    5c1 <malloc+0x60>
 589:	be 00 10 00 00       	mov    $0x1000,%esi
 58e:	39 f3                	cmp    %esi,%ebx
 590:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 593:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 59a:	eb 72                	jmp    60e <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 59c:	c7 05 fc 08 00 00 00 	movl   $0x900,0x8fc
 5a3:	09 00 00 
 5a6:	c7 05 00 09 00 00 00 	movl   $0x900,0x900
 5ad:	09 00 00 
    base.s.size = 0;
 5b0:	c7 05 04 09 00 00 00 	movl   $0x0,0x904
 5b7:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ba:	b8 00 09 00 00       	mov    $0x900,%eax
 5bf:	eb c8                	jmp    589 <malloc+0x28>
      if(p->s.size == nunits)
 5c1:	39 cb                	cmp    %ecx,%ebx
 5c3:	74 1e                	je     5e3 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c5:	29 d9                	sub    %ebx,%ecx
 5c7:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5ca:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5cd:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d0:	89 15 fc 08 00 00    	mov    %edx,0x8fc
      return (void*)(p + 1);
 5d6:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d9:	89 d0                	mov    %edx,%eax
 5db:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5de:	5b                   	pop    %ebx
 5df:	5e                   	pop    %esi
 5e0:	5f                   	pop    %edi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e3:	8b 08                	mov    (%eax),%ecx
 5e5:	89 0a                	mov    %ecx,(%edx)
 5e7:	eb e7                	jmp    5d0 <malloc+0x6f>
  hp->s.size = nu;
 5e9:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 5ec:	83 ec 0c             	sub    $0xc,%esp
 5ef:	83 c0 08             	add    $0x8,%eax
 5f2:	50                   	push   %eax
 5f3:	e8 00 ff ff ff       	call   4f8 <free>
  return freep;
 5f8:	8b 15 fc 08 00 00    	mov    0x8fc,%edx
      if((p = morecore(nunits)) == 0)
 5fe:	83 c4 10             	add    $0x10,%esp
 601:	85 d2                	test   %edx,%edx
 603:	74 d4                	je     5d9 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 605:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 607:	8b 48 04             	mov    0x4(%eax),%ecx
 60a:	39 d9                	cmp    %ebx,%ecx
 60c:	73 b3                	jae    5c1 <malloc+0x60>
    if(p == freep)
 60e:	89 c2                	mov    %eax,%edx
 610:	39 05 fc 08 00 00    	cmp    %eax,0x8fc
 616:	75 ed                	jne    605 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 618:	83 ec 0c             	sub    $0xc,%esp
 61b:	57                   	push   %edi
 61c:	e8 59 fc ff ff       	call   27a <sbrk>
  if(p == (char*)-1)
 621:	83 c4 10             	add    $0x10,%esp
 624:	83 f8 ff             	cmp    $0xffffffff,%eax
 627:	75 c0                	jne    5e9 <malloc+0x88>
        return 0;
 629:	ba 00 00 00 00       	mov    $0x0,%edx
 62e:	eb a9                	jmp    5d9 <malloc+0x78>
