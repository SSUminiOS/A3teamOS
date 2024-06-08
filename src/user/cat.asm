
user/_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 60 0a 00 00       	push   $0xa60
  19:	56                   	push   %esi
  1a:	e8 e0 02 00 00       	call   2ff <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 60 0a 00 00       	push   $0xa60
  31:	6a 01                	push   $0x1
  33:	e8 cf 02 00 00       	call   307 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 44 07 00 00       	push   $0x744
  47:	6a 01                	push   $0x1
  49:	e8 dd 03 00 00       	call   42b <printf>
      exit();
  4e:	e8 94 02 00 00       	call   2e7 <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 56 07 00 00       	push   $0x756
  64:	6a 01                	push   $0x1
  66:	e8 c0 03 00 00       	call   42b <printf>
    exit();
  6b:	e8 77 02 00 00       	call   2e7 <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 71 04             	mov    0x4(%ecx),%esi
  int fd, i;

  if(argc <= 1){
  90:	83 c6 04             	add    $0x4,%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  93:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  98:	83 f8 01             	cmp    $0x1,%eax
  9b:	7e 3c                	jle    d9 <main+0x69>
    if((fd = open(argv[i], 0)) < 0){
  9d:	89 75 e0             	mov    %esi,-0x20(%ebp)
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	6a 00                	push   $0x0
  a5:	ff 36                	pushl  (%esi)
  a7:	e8 7b 02 00 00       	call   327 <open>
  ac:	89 c3                	mov    %eax,%ebx
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	78 33                	js     e8 <main+0x78>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	50                   	push   %eax
  b9:	e8 42 ff ff ff       	call   0 <cat>
    close(fd);
  be:	89 1c 24             	mov    %ebx,(%esp)
  c1:	e8 49 02 00 00       	call   30f <close>
  for(i = 1; i < argc; i++){
  c6:	83 c7 01             	add    $0x1,%edi
  c9:	83 c6 04             	add    $0x4,%esi
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  d2:	75 c9                	jne    9d <main+0x2d>
  }
  exit();
  d4:	e8 0e 02 00 00       	call   2e7 <exit>
    cat(0);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	6a 00                	push   $0x0
  de:	e8 1d ff ff ff       	call   0 <cat>
    exit();
  e3:	e8 ff 01 00 00       	call   2e7 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e8:	83 ec 04             	sub    $0x4,%esp
  eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ee:	ff 30                	pushl  (%eax)
  f0:	68 67 07 00 00       	push   $0x767
  f5:	6a 01                	push   $0x1
  f7:	e8 2f 03 00 00       	call   42b <printf>
      exit();
  fc:	e8 e6 01 00 00       	call   2e7 <exit>

00000101 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 101:	f3 0f 1e fb          	endbr32 
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	53                   	push   %ebx
 109:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10f:	b8 00 00 00 00       	mov    $0x0,%eax
 114:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 118:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 11b:	83 c0 01             	add    $0x1,%eax
 11e:	84 d2                	test   %dl,%dl
 120:	75 f2                	jne    114 <strcpy+0x13>
    ;
  return os;
}
 122:	89 c8                	mov    %ecx,%eax
 124:	5b                   	pop    %ebx
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 127:	f3 0f 1e fb          	endbr32 
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 131:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 134:	0f b6 01             	movzbl (%ecx),%eax
 137:	84 c0                	test   %al,%al
 139:	74 11                	je     14c <strcmp+0x25>
 13b:	38 02                	cmp    %al,(%edx)
 13d:	75 0d                	jne    14c <strcmp+0x25>
    p++, q++;
 13f:	83 c1 01             	add    $0x1,%ecx
 142:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 145:	0f b6 01             	movzbl (%ecx),%eax
 148:	84 c0                	test   %al,%al
 14a:	75 ef                	jne    13b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 14c:	0f b6 c0             	movzbl %al,%eax
 14f:	0f b6 12             	movzbl (%edx),%edx
 152:	29 d0                	sub    %edx,%eax
}
 154:	5d                   	pop    %ebp
 155:	c3                   	ret    

00000156 <strlen>:

uint
strlen(const char *s)
{
 156:	f3 0f 1e fb          	endbr32 
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 160:	80 3a 00             	cmpb   $0x0,(%edx)
 163:	74 14                	je     179 <strlen+0x23>
 165:	b8 00 00 00 00       	mov    $0x0,%eax
 16a:	83 c0 01             	add    $0x1,%eax
 16d:	89 c1                	mov    %eax,%ecx
 16f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 173:	75 f5                	jne    16a <strlen+0x14>
    ;
  return n;
}
 175:	89 c8                	mov    %ecx,%eax
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
  for(n = 0; s[n]; n++)
 179:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 17e:	eb f5                	jmp    175 <strlen+0x1f>

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18b:	89 d7                	mov    %edx,%edi
 18d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	fc                   	cld    
 194:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 196:	89 d0                	mov    %edx,%eax
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strchr>:

char*
strchr(const char *s, char c)
{
 19b:	f3 0f 1e fb          	endbr32 
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1a9:	0f b6 10             	movzbl (%eax),%edx
 1ac:	84 d2                	test   %dl,%dl
 1ae:	74 15                	je     1c5 <strchr+0x2a>
    if(*s == c)
 1b0:	38 d1                	cmp    %dl,%cl
 1b2:	74 0f                	je     1c3 <strchr+0x28>
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x15>
      return (char*)s;
  return 0;
 1be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
  return 0;
 1c5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ca:	eb f7                	jmp    1c3 <strchr+0x28>

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	f3 0f 1e fb          	endbr32 
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
 1d6:	83 ec 2c             	sub    $0x2c,%esp
 1d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dc:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1e1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1e7:	83 c3 01             	add    $0x1,%ebx
 1ea:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ed:	7d 27                	jge    216 <gets+0x4a>
    cc = read(0, &c, 1);
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	6a 01                	push   $0x1
 1f4:	57                   	push   %edi
 1f5:	6a 00                	push   $0x0
 1f7:	e8 03 01 00 00       	call   2ff <read>
    if(cc < 1)
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	85 c0                	test   %eax,%eax
 201:	7e 13                	jle    216 <gets+0x4a>
      break;
    buf[i++] = c;
 203:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 207:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 20b:	3c 0a                	cmp    $0xa,%al
 20d:	74 04                	je     213 <gets+0x47>
 20f:	3c 0d                	cmp    $0xd,%al
 211:	75 d1                	jne    1e4 <gets+0x18>
  for(i=0; i+1 < max; ){
 213:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 216:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 219:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 21d:	89 f0                	mov    %esi,%eax
 21f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 222:	5b                   	pop    %ebx
 223:	5e                   	pop    %esi
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    

00000227 <stat>:

int
stat(const char *n, struct stat *st)
{
 227:	f3 0f 1e fb          	endbr32 
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	56                   	push   %esi
 22f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	83 ec 08             	sub    $0x8,%esp
 233:	6a 00                	push   $0x0
 235:	ff 75 08             	pushl  0x8(%ebp)
 238:	e8 ea 00 00 00       	call   327 <open>
  if(fd < 0)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	78 24                	js     268 <stat+0x41>
 244:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 246:	83 ec 08             	sub    $0x8,%esp
 249:	ff 75 0c             	pushl  0xc(%ebp)
 24c:	50                   	push   %eax
 24d:	e8 ed 00 00 00       	call   33f <fstat>
 252:	89 c6                	mov    %eax,%esi
  close(fd);
 254:	89 1c 24             	mov    %ebx,(%esp)
 257:	e8 b3 00 00 00       	call   30f <close>
  return r;
 25c:	83 c4 10             	add    $0x10,%esp
}
 25f:	89 f0                	mov    %esi,%eax
 261:	8d 65 f8             	lea    -0x8(%ebp),%esp
 264:	5b                   	pop    %ebx
 265:	5e                   	pop    %esi
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
    return -1;
 268:	be ff ff ff ff       	mov    $0xffffffff,%esi
 26d:	eb f0                	jmp    25f <stat+0x38>

0000026f <atoi>:

int
atoi(const char *s)
{
 26f:	f3 0f 1e fb          	endbr32 
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	53                   	push   %ebx
 277:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27a:	0f b6 02             	movzbl (%edx),%eax
 27d:	8d 48 d0             	lea    -0x30(%eax),%ecx
 280:	80 f9 09             	cmp    $0x9,%cl
 283:	77 22                	ja     2a7 <atoi+0x38>
  n = 0;
 285:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 28a:	83 c2 01             	add    $0x1,%edx
 28d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 290:	0f be c0             	movsbl %al,%eax
 293:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 297:	0f b6 02             	movzbl (%edx),%eax
 29a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 29d:	80 fb 09             	cmp    $0x9,%bl
 2a0:	76 e8                	jbe    28a <atoi+0x1b>
  return n;
}
 2a2:	89 c8                	mov    %ecx,%eax
 2a4:	5b                   	pop    %ebx
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
  n = 0;
 2a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 2ac:	eb f4                	jmp    2a2 <atoi+0x33>

000002ae <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ae:	f3 0f 1e fb          	endbr32 
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	56                   	push   %esi
 2b6:	53                   	push   %ebx
 2b7:	8b 75 08             	mov    0x8(%ebp),%esi
 2ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 2bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c0:	85 db                	test   %ebx,%ebx
 2c2:	7e 15                	jle    2d9 <memmove+0x2b>
 2c4:	01 f3                	add    %esi,%ebx
  dst = vdst;
 2c6:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 2c8:	83 c2 01             	add    $0x1,%edx
 2cb:	83 c0 01             	add    $0x1,%eax
 2ce:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2d2:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 2d5:	39 c3                	cmp    %eax,%ebx
 2d7:	75 ef                	jne    2c8 <memmove+0x1a>
  return vdst;
}
 2d9:	89 f0                	mov    %esi,%eax
 2db:	5b                   	pop    %ebx
 2dc:	5e                   	pop    %esi
 2dd:	5d                   	pop    %ebp
 2de:	c3                   	ret    

000002df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2df:	b8 01 00 00 00       	mov    $0x1,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exit>:
SYSCALL(exit)
 2e7:	b8 02 00 00 00       	mov    $0x2,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <wait>:
SYSCALL(wait)
 2ef:	b8 03 00 00 00       	mov    $0x3,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <pipe>:
SYSCALL(pipe)
 2f7:	b8 04 00 00 00       	mov    $0x4,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <read>:
SYSCALL(read)
 2ff:	b8 05 00 00 00       	mov    $0x5,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <write>:
SYSCALL(write)
 307:	b8 10 00 00 00       	mov    $0x10,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <close>:
SYSCALL(close)
 30f:	b8 15 00 00 00       	mov    $0x15,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <kill>:
SYSCALL(kill)
 317:	b8 06 00 00 00       	mov    $0x6,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exec>:
SYSCALL(exec)
 31f:	b8 07 00 00 00       	mov    $0x7,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <open>:
SYSCALL(open)
 327:	b8 0f 00 00 00       	mov    $0xf,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mknod>:
SYSCALL(mknod)
 32f:	b8 11 00 00 00       	mov    $0x11,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <unlink>:
SYSCALL(unlink)
 337:	b8 12 00 00 00       	mov    $0x12,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <fstat>:
SYSCALL(fstat)
 33f:	b8 08 00 00 00       	mov    $0x8,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <link>:
SYSCALL(link)
 347:	b8 13 00 00 00       	mov    $0x13,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <mkdir>:
SYSCALL(mkdir)
 34f:	b8 14 00 00 00       	mov    $0x14,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <chdir>:
SYSCALL(chdir)
 357:	b8 09 00 00 00       	mov    $0x9,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <dup>:
SYSCALL(dup)
 35f:	b8 0a 00 00 00       	mov    $0xa,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getpid>:
SYSCALL(getpid)
 367:	b8 0b 00 00 00       	mov    $0xb,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sbrk>:
SYSCALL(sbrk)
 36f:	b8 0c 00 00 00       	mov    $0xc,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <sleep>:
SYSCALL(sleep)
 377:	b8 0d 00 00 00       	mov    $0xd,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <uptime>:
SYSCALL(uptime)
 37f:	b8 0e 00 00 00       	mov    $0xe,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <slabtest>:
SYSCALL(slabtest)
 387:	b8 16 00 00 00       	mov    $0x16,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <ps>:
SYSCALL(ps)
 38f:	b8 17 00 00 00       	mov    $0x17,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	57                   	push   %edi
 39b:	56                   	push   %esi
 39c:	53                   	push   %ebx
 39d:	83 ec 3c             	sub    $0x3c,%esp
 3a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3a3:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a9:	74 77                	je     422 <printint+0x8b>
 3ab:	85 d2                	test   %edx,%edx
 3ad:	79 73                	jns    422 <printint+0x8b>
    neg = 1;
    x = -xx;
 3af:	f7 db                	neg    %ebx
    neg = 1;
 3b1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b8:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 3bd:	89 f7                	mov    %esi,%edi
 3bf:	83 c6 01             	add    $0x1,%esi
 3c2:	89 d8                	mov    %ebx,%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f1                	div    %ecx
 3cb:	0f b6 92 84 07 00 00 	movzbl 0x784(%edx),%edx
 3d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3d6:	89 da                	mov    %ebx,%edx
 3d8:	89 c3                	mov    %eax,%ebx
 3da:	39 d1                	cmp    %edx,%ecx
 3dc:	76 df                	jbe    3bd <printint+0x26>
  if(neg)
 3de:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3e2:	74 08                	je     3ec <printint+0x55>
    buf[i++] = '-';
 3e4:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 3e9:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 3ec:	85 f6                	test   %esi,%esi
 3ee:	7e 2a                	jle    41a <printint+0x83>
 3f0:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 3f4:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 3f7:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3fa:	0f b6 03             	movzbl (%ebx),%eax
 3fd:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	6a 01                	push   $0x1
 405:	56                   	push   %esi
 406:	ff 75 c4             	pushl  -0x3c(%ebp)
 409:	e8 f9 fe ff ff       	call   307 <write>
  while(--i >= 0)
 40e:	89 d8                	mov    %ebx,%eax
 410:	83 eb 01             	sub    $0x1,%ebx
 413:	83 c4 10             	add    $0x10,%esp
 416:	39 f8                	cmp    %edi,%eax
 418:	75 e0                	jne    3fa <printint+0x63>
}
 41a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41d:	5b                   	pop    %ebx
 41e:	5e                   	pop    %esi
 41f:	5f                   	pop    %edi
 420:	5d                   	pop    %ebp
 421:	c3                   	ret    
  neg = 0;
 422:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 429:	eb 8d                	jmp    3b8 <printint+0x21>

0000042b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 42b:	f3 0f 1e fb          	endbr32 
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	57                   	push   %edi
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
 435:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 438:	8b 75 0c             	mov    0xc(%ebp),%esi
 43b:	0f b6 1e             	movzbl (%esi),%ebx
 43e:	84 db                	test   %bl,%bl
 440:	0f 84 ab 01 00 00    	je     5f1 <printf+0x1c6>
 446:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 449:	8d 45 10             	lea    0x10(%ebp),%eax
 44c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 44f:	bf 00 00 00 00       	mov    $0x0,%edi
 454:	eb 2d                	jmp    483 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 456:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 459:	83 ec 04             	sub    $0x4,%esp
 45c:	6a 01                	push   $0x1
 45e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 461:	50                   	push   %eax
 462:	ff 75 08             	pushl  0x8(%ebp)
 465:	e8 9d fe ff ff       	call   307 <write>
        putc(fd, c);
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	eb 05                	jmp    474 <printf+0x49>
      }
    } else if(state == '%'){
 46f:	83 ff 25             	cmp    $0x25,%edi
 472:	74 22                	je     496 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 474:	83 c6 01             	add    $0x1,%esi
 477:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 47b:	84 db                	test   %bl,%bl
 47d:	0f 84 6e 01 00 00    	je     5f1 <printf+0x1c6>
    c = fmt[i] & 0xff;
 483:	0f be d3             	movsbl %bl,%edx
 486:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 489:	85 ff                	test   %edi,%edi
 48b:	75 e2                	jne    46f <printf+0x44>
      if(c == '%'){
 48d:	83 f8 25             	cmp    $0x25,%eax
 490:	75 c4                	jne    456 <printf+0x2b>
        state = '%';
 492:	89 c7                	mov    %eax,%edi
 494:	eb de                	jmp    474 <printf+0x49>
      if(c == 'd'){
 496:	83 f8 64             	cmp    $0x64,%eax
 499:	74 59                	je     4f4 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 49b:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4a1:	83 fa 70             	cmp    $0x70,%edx
 4a4:	74 7a                	je     520 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a6:	83 f8 73             	cmp    $0x73,%eax
 4a9:	0f 84 9d 00 00 00    	je     54c <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4af:	83 f8 63             	cmp    $0x63,%eax
 4b2:	0f 84 ec 00 00 00    	je     5a4 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	0f 84 0f 01 00 00    	je     5d0 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4c1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4c5:	83 ec 04             	sub    $0x4,%esp
 4c8:	6a 01                	push   $0x1
 4ca:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 31 fe ff ff       	call   307 <write>
        putc(fd, c);
 4d6:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4d9:	83 c4 0c             	add    $0xc,%esp
 4dc:	6a 01                	push   $0x1
 4de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 1d fe ff ff       	call   307 <write>
        putc(fd, c);
 4ea:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4ed:	bf 00 00 00 00       	mov    $0x0,%edi
 4f2:	eb 80                	jmp    474 <printf+0x49>
        printint(fd, *ap, 10, 1);
 4f4:	83 ec 0c             	sub    $0xc,%esp
 4f7:	6a 01                	push   $0x1
 4f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4fe:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 501:	8b 17                	mov    (%edi),%edx
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	e8 8c fe ff ff       	call   397 <printint>
        ap++;
 50b:	89 f8                	mov    %edi,%eax
 50d:	83 c0 04             	add    $0x4,%eax
 510:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 513:	83 c4 10             	add    $0x10,%esp
      state = 0;
 516:	bf 00 00 00 00       	mov    $0x0,%edi
 51b:	e9 54 ff ff ff       	jmp    474 <printf+0x49>
        printint(fd, *ap, 16, 0);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	6a 00                	push   $0x0
 525:	b9 10 00 00 00       	mov    $0x10,%ecx
 52a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52d:	8b 17                	mov    (%edi),%edx
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	e8 60 fe ff ff       	call   397 <printint>
        ap++;
 537:	89 f8                	mov    %edi,%eax
 539:	83 c0 04             	add    $0x4,%eax
 53c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 542:	bf 00 00 00 00       	mov    $0x0,%edi
 547:	e9 28 ff ff ff       	jmp    474 <printf+0x49>
        s = (char*)*ap;
 54c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 54f:	8b 01                	mov    (%ecx),%eax
        ap++;
 551:	83 c1 04             	add    $0x4,%ecx
 554:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 557:	85 c0                	test   %eax,%eax
 559:	74 13                	je     56e <printf+0x143>
        s = (char*)*ap;
 55b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 55d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 560:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 565:	84 c0                	test   %al,%al
 567:	75 0f                	jne    578 <printf+0x14d>
 569:	e9 06 ff ff ff       	jmp    474 <printf+0x49>
          s = "(null)";
 56e:	bb 7c 07 00 00       	mov    $0x77c,%ebx
        while(*s != 0){
 573:	b8 28 00 00 00       	mov    $0x28,%eax
 578:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 57b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 57e:	83 ec 04             	sub    $0x4,%esp
 581:	6a 01                	push   $0x1
 583:	8d 45 e7             	lea    -0x19(%ebp),%eax
 586:	50                   	push   %eax
 587:	57                   	push   %edi
 588:	e8 7a fd ff ff       	call   307 <write>
          s++;
 58d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 590:	0f b6 03             	movzbl (%ebx),%eax
 593:	83 c4 10             	add    $0x10,%esp
 596:	84 c0                	test   %al,%al
 598:	75 e1                	jne    57b <printf+0x150>
      state = 0;
 59a:	bf 00 00 00 00       	mov    $0x0,%edi
 59f:	e9 d0 fe ff ff       	jmp    474 <printf+0x49>
        putc(fd, *ap);
 5a4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5a7:	8b 07                	mov    (%edi),%eax
 5a9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5ac:	83 ec 04             	sub    $0x4,%esp
 5af:	6a 01                	push   $0x1
 5b1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5b4:	50                   	push   %eax
 5b5:	ff 75 08             	pushl  0x8(%ebp)
 5b8:	e8 4a fd ff ff       	call   307 <write>
        ap++;
 5bd:	83 c7 04             	add    $0x4,%edi
 5c0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5c3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c6:	bf 00 00 00 00       	mov    $0x0,%edi
 5cb:	e9 a4 fe ff ff       	jmp    474 <printf+0x49>
        putc(fd, c);
 5d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	6a 01                	push   $0x1
 5d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 23 fd ff ff       	call   307 <write>
 5e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e7:	bf 00 00 00 00       	mov    $0x0,%edi
 5ec:	e9 83 fe ff ff       	jmp    474 <printf+0x49>
    }
  }
}
 5f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f4:	5b                   	pop    %ebx
 5f5:	5e                   	pop    %esi
 5f6:	5f                   	pop    %edi
 5f7:	5d                   	pop    %ebp
 5f8:	c3                   	ret    

000005f9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f9:	f3 0f 1e fb          	endbr32 
 5fd:	55                   	push   %ebp
 5fe:	89 e5                	mov    %esp,%ebp
 600:	57                   	push   %edi
 601:	56                   	push   %esi
 602:	53                   	push   %ebx
 603:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 606:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 609:	a1 40 0a 00 00       	mov    0xa40,%eax
 60e:	eb 0c                	jmp    61c <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 610:	8b 10                	mov    (%eax),%edx
 612:	39 c2                	cmp    %eax,%edx
 614:	77 04                	ja     61a <free+0x21>
 616:	39 ca                	cmp    %ecx,%edx
 618:	77 10                	ja     62a <free+0x31>
{
 61a:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	39 c8                	cmp    %ecx,%eax
 61e:	73 f0                	jae    610 <free+0x17>
 620:	8b 10                	mov    (%eax),%edx
 622:	39 ca                	cmp    %ecx,%edx
 624:	77 04                	ja     62a <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 626:	39 c2                	cmp    %eax,%edx
 628:	77 f0                	ja     61a <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 62a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62d:	8b 10                	mov    (%eax),%edx
 62f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 632:	39 fa                	cmp    %edi,%edx
 634:	74 19                	je     64f <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 636:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 639:	8b 50 04             	mov    0x4(%eax),%edx
 63c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63f:	39 f1                	cmp    %esi,%ecx
 641:	74 1b                	je     65e <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 643:	89 08                	mov    %ecx,(%eax)
  freep = p;
 645:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 64a:	5b                   	pop    %ebx
 64b:	5e                   	pop    %esi
 64c:	5f                   	pop    %edi
 64d:	5d                   	pop    %ebp
 64e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 64f:	03 72 04             	add    0x4(%edx),%esi
 652:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 655:	8b 10                	mov    (%eax),%edx
 657:	8b 12                	mov    (%edx),%edx
 659:	89 53 f8             	mov    %edx,-0x8(%ebx)
 65c:	eb db                	jmp    639 <free+0x40>
    p->s.size += bp->s.size;
 65e:	03 53 fc             	add    -0x4(%ebx),%edx
 661:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 664:	8b 53 f8             	mov    -0x8(%ebx),%edx
 667:	89 10                	mov    %edx,(%eax)
 669:	eb da                	jmp    645 <free+0x4c>

0000066b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 66b:	f3 0f 1e fb          	endbr32 
 66f:	55                   	push   %ebp
 670:	89 e5                	mov    %esp,%ebp
 672:	57                   	push   %edi
 673:	56                   	push   %esi
 674:	53                   	push   %ebx
 675:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	8d 58 07             	lea    0x7(%eax),%ebx
 67e:	c1 eb 03             	shr    $0x3,%ebx
 681:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 684:	8b 15 40 0a 00 00    	mov    0xa40,%edx
 68a:	85 d2                	test   %edx,%edx
 68c:	74 20                	je     6ae <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 690:	8b 48 04             	mov    0x4(%eax),%ecx
 693:	39 cb                	cmp    %ecx,%ebx
 695:	76 3c                	jbe    6d3 <malloc+0x68>
 697:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 69d:	be 00 10 00 00       	mov    $0x1000,%esi
 6a2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6a5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6ac:	eb 72                	jmp    720 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 6ae:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 6b5:	0a 00 00 
 6b8:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 6bf:	0a 00 00 
    base.s.size = 0;
 6c2:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 6c9:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6cc:	b8 44 0a 00 00       	mov    $0xa44,%eax
 6d1:	eb c4                	jmp    697 <malloc+0x2c>
      if(p->s.size == nunits)
 6d3:	39 cb                	cmp    %ecx,%ebx
 6d5:	74 1e                	je     6f5 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d7:	29 d9                	sub    %ebx,%ecx
 6d9:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6dc:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6df:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6e2:	89 15 40 0a 00 00    	mov    %edx,0xa40
      return (void*)(p + 1);
 6e8:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6eb:	89 d0                	mov    %edx,%eax
 6ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f0:	5b                   	pop    %ebx
 6f1:	5e                   	pop    %esi
 6f2:	5f                   	pop    %edi
 6f3:	5d                   	pop    %ebp
 6f4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f5:	8b 08                	mov    (%eax),%ecx
 6f7:	89 0a                	mov    %ecx,(%edx)
 6f9:	eb e7                	jmp    6e2 <malloc+0x77>
  hp->s.size = nu;
 6fb:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6fe:	83 ec 0c             	sub    $0xc,%esp
 701:	83 c0 08             	add    $0x8,%eax
 704:	50                   	push   %eax
 705:	e8 ef fe ff ff       	call   5f9 <free>
  return freep;
 70a:	8b 15 40 0a 00 00    	mov    0xa40,%edx
      if((p = morecore(nunits)) == 0)
 710:	83 c4 10             	add    $0x10,%esp
 713:	85 d2                	test   %edx,%edx
 715:	74 d4                	je     6eb <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 717:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 719:	8b 48 04             	mov    0x4(%eax),%ecx
 71c:	39 d9                	cmp    %ebx,%ecx
 71e:	73 b3                	jae    6d3 <malloc+0x68>
    if(p == freep)
 720:	89 c2                	mov    %eax,%edx
 722:	39 05 40 0a 00 00    	cmp    %eax,0xa40
 728:	75 ed                	jne    717 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 72a:	83 ec 0c             	sub    $0xc,%esp
 72d:	57                   	push   %edi
 72e:	e8 3c fc ff ff       	call   36f <sbrk>
  if(p == (char*)-1)
 733:	83 c4 10             	add    $0x10,%esp
 736:	83 f8 ff             	cmp    $0xffffffff,%eax
 739:	75 c0                	jne    6fb <malloc+0x90>
        return 0;
 73b:	ba 00 00 00 00       	mov    $0x0,%edx
 740:	eb a9                	jmp    6eb <malloc+0x80>
