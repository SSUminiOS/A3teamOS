
user/_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 40 0a 00 00       	push   $0xa40
  15:	56                   	push   %esi
  16:	e8 be 02 00 00       	call   2d9 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 40 0a 00 00       	push   $0xa40
  2d:	6a 01                	push   $0x1
  2f:	e8 ad 02 00 00       	call   2e1 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 00 07 00 00       	push   $0x700
  43:	6a 01                	push   $0x1
  45:	e8 bf 03 00 00       	call   409 <printf>
      exit();
  4a:	e8 72 02 00 00       	call   2c1 <exit>
    }
  }
  if(n < 0){
  4f:	78 07                	js     58 <cat+0x58>
    printf(1, "cat: read error\n");
    exit();
  }
}
  51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  54:	5b                   	pop    %ebx
  55:	5e                   	pop    %esi
  56:	5d                   	pop    %ebp
  57:	c3                   	ret    
    printf(1, "cat: read error\n");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 12 07 00 00       	push   $0x712
  60:	6a 01                	push   $0x1
  62:	e8 a2 03 00 00       	call   409 <printf>
    exit();
  67:	e8 55 02 00 00       	call   2c1 <exit>

0000006c <main>:

int
main(int argc, char *argv[])
{
  6c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  70:	83 e4 f0             	and    $0xfffffff0,%esp
  73:	ff 71 fc             	push   -0x4(%ecx)
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	56                   	push   %esi
  7b:	53                   	push   %ebx
  7c:	51                   	push   %ecx
  7d:	83 ec 18             	sub    $0x18,%esp
  80:	8b 01                	mov    (%ecx),%eax
  82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  85:	8b 71 04             	mov    0x4(%ecx),%esi
  int fd, i;

  if(argc <= 1){
  88:	83 c6 04             	add    $0x4,%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  8b:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  90:	83 f8 01             	cmp    $0x1,%eax
  93:	7e 3c                	jle    d1 <main+0x65>
    if((fd = open(argv[i], 0)) < 0){
  95:	89 75 e0             	mov    %esi,-0x20(%ebp)
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	6a 00                	push   $0x0
  9d:	ff 36                	push   (%esi)
  9f:	e8 5d 02 00 00       	call   301 <open>
  a4:	89 c3                	mov    %eax,%ebx
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	85 c0                	test   %eax,%eax
  ab:	78 33                	js     e0 <main+0x74>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	50                   	push   %eax
  b1:	e8 4a ff ff ff       	call   0 <cat>
    close(fd);
  b6:	89 1c 24             	mov    %ebx,(%esp)
  b9:	e8 2b 02 00 00       	call   2e9 <close>
  for(i = 1; i < argc; i++){
  be:	83 c7 01             	add    $0x1,%edi
  c1:	83 c6 04             	add    $0x4,%esi
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  ca:	75 c9                	jne    95 <main+0x29>
  }
  exit();
  cc:	e8 f0 01 00 00       	call   2c1 <exit>
    cat(0);
  d1:	83 ec 0c             	sub    $0xc,%esp
  d4:	6a 00                	push   $0x0
  d6:	e8 25 ff ff ff       	call   0 <cat>
    exit();
  db:	e8 e1 01 00 00       	call   2c1 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e0:	83 ec 04             	sub    $0x4,%esp
  e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e6:	ff 30                	push   (%eax)
  e8:	68 23 07 00 00       	push   $0x723
  ed:	6a 01                	push   $0x1
  ef:	e8 15 03 00 00       	call   409 <printf>
      exit();
  f4:	e8 c8 01 00 00       	call   2c1 <exit>

000000f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	53                   	push   %ebx
  fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 103:	b8 00 00 00 00       	mov    $0x0,%eax
 108:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 10c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 10f:	83 c0 01             	add    $0x1,%eax
 112:	84 d2                	test   %dl,%dl
 114:	75 f2                	jne    108 <strcpy+0xf>
    ;
  return os;
}
 116:	89 c8                	mov    %ecx,%eax
 118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	8b 4d 08             	mov    0x8(%ebp),%ecx
 123:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 126:	0f b6 01             	movzbl (%ecx),%eax
 129:	84 c0                	test   %al,%al
 12b:	74 11                	je     13e <strcmp+0x21>
 12d:	38 02                	cmp    %al,(%edx)
 12f:	75 0d                	jne    13e <strcmp+0x21>
    p++, q++;
 131:	83 c1 01             	add    $0x1,%ecx
 134:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	75 ef                	jne    12d <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 13e:	0f b6 c0             	movzbl %al,%eax
 141:	0f b6 12             	movzbl (%edx),%edx
 144:	29 d0                	sub    %edx,%eax
}
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    

00000148 <strlen>:

uint
strlen(const char *s)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 14e:	80 3a 00             	cmpb   $0x0,(%edx)
 151:	74 14                	je     167 <strlen+0x1f>
 153:	b8 00 00 00 00       	mov    $0x0,%eax
 158:	83 c0 01             	add    $0x1,%eax
 15b:	89 c1                	mov    %eax,%ecx
 15d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 161:	75 f5                	jne    158 <strlen+0x10>
    ;
  return n;
}
 163:	89 c8                	mov    %ecx,%eax
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
  for(n = 0; s[n]; n++)
 167:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 16c:	eb f5                	jmp    163 <strlen+0x1b>

0000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	57                   	push   %edi
 172:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 175:	89 d7                	mov    %edx,%edi
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	fc                   	cld    
 17e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 180:	89 d0                	mov    %edx,%eax
 182:	8b 7d fc             	mov    -0x4(%ebp),%edi
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <strchr>:

char*
strchr(const char *s, char c)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 191:	0f b6 10             	movzbl (%eax),%edx
 194:	84 d2                	test   %dl,%dl
 196:	74 15                	je     1ad <strchr+0x26>
    if(*s == c)
 198:	38 d1                	cmp    %dl,%cl
 19a:	74 0f                	je     1ab <strchr+0x24>
  for(; *s; s++)
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	0f b6 10             	movzbl (%eax),%edx
 1a2:	84 d2                	test   %dl,%dl
 1a4:	75 f2                	jne    198 <strchr+0x11>
      return (char*)s;
  return 0;
 1a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
  return 0;
 1ad:	b8 00 00 00 00       	mov    $0x0,%eax
 1b2:	eb f7                	jmp    1ab <strchr+0x24>

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 2c             	sub    $0x2c,%esp
 1bd:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1cb:	83 c3 01             	add    $0x1,%ebx
 1ce:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d1:	7d 27                	jge    1fa <gets+0x46>
    cc = read(0, &c, 1);
 1d3:	83 ec 04             	sub    $0x4,%esp
 1d6:	6a 01                	push   $0x1
 1d8:	57                   	push   %edi
 1d9:	6a 00                	push   $0x0
 1db:	e8 f9 00 00 00       	call   2d9 <read>
    if(cc < 1)
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	85 c0                	test   %eax,%eax
 1e5:	7e 13                	jle    1fa <gets+0x46>
      break;
    buf[i++] = c;
 1e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1eb:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 1ef:	3c 0a                	cmp    $0xa,%al
 1f1:	74 04                	je     1f7 <gets+0x43>
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	75 d1                	jne    1c8 <gets+0x14>
  for(i=0; i+1 < max; ){
 1f7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1fd:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 201:	89 f0                	mov    %esi,%eax
 203:	8d 65 f4             	lea    -0xc(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <stat>:

int
stat(const char *n, struct stat *st)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	56                   	push   %esi
 20f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 00                	push   $0x0
 215:	ff 75 08             	push   0x8(%ebp)
 218:	e8 e4 00 00 00       	call   301 <open>
  if(fd < 0)
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	78 24                	js     248 <stat+0x3d>
 224:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 226:	83 ec 08             	sub    $0x8,%esp
 229:	ff 75 0c             	push   0xc(%ebp)
 22c:	50                   	push   %eax
 22d:	e8 e7 00 00 00       	call   319 <fstat>
 232:	89 c6                	mov    %eax,%esi
  close(fd);
 234:	89 1c 24             	mov    %ebx,(%esp)
 237:	e8 ad 00 00 00       	call   2e9 <close>
  return r;
 23c:	83 c4 10             	add    $0x10,%esp
}
 23f:	89 f0                	mov    %esi,%eax
 241:	8d 65 f8             	lea    -0x8(%ebp),%esp
 244:	5b                   	pop    %ebx
 245:	5e                   	pop    %esi
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
    return -1;
 248:	be ff ff ff ff       	mov    $0xffffffff,%esi
 24d:	eb f0                	jmp    23f <stat+0x34>

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	53                   	push   %ebx
 253:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 256:	0f b6 02             	movzbl (%edx),%eax
 259:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25c:	80 f9 09             	cmp    $0x9,%cl
 25f:	77 24                	ja     285 <atoi+0x36>
  n = 0;
 261:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 266:	83 c2 01             	add    $0x1,%edx
 269:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 26c:	0f be c0             	movsbl %al,%eax
 26f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 273:	0f b6 02             	movzbl (%edx),%eax
 276:	8d 58 d0             	lea    -0x30(%eax),%ebx
 279:	80 fb 09             	cmp    $0x9,%bl
 27c:	76 e8                	jbe    266 <atoi+0x17>
  return n;
}
 27e:	89 c8                	mov    %ecx,%eax
 280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 283:	c9                   	leave  
 284:	c3                   	ret    
  n = 0;
 285:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 28a:	eb f2                	jmp    27e <atoi+0x2f>

0000028c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	56                   	push   %esi
 290:	53                   	push   %ebx
 291:	8b 75 08             	mov    0x8(%ebp),%esi
 294:	8b 55 0c             	mov    0xc(%ebp),%edx
 297:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29a:	85 db                	test   %ebx,%ebx
 29c:	7e 15                	jle    2b3 <memmove+0x27>
 29e:	01 f3                	add    %esi,%ebx
  dst = vdst;
 2a0:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 2a2:	83 c2 01             	add    $0x1,%edx
 2a5:	83 c0 01             	add    $0x1,%eax
 2a8:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2ac:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 2af:	39 c3                	cmp    %eax,%ebx
 2b1:	75 ef                	jne    2a2 <memmove+0x16>
  return vdst;
}
 2b3:	89 f0                	mov    %esi,%eax
 2b5:	5b                   	pop    %ebx
 2b6:	5e                   	pop    %esi
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    

000002b9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b9:	b8 01 00 00 00       	mov    $0x1,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <exit>:
SYSCALL(exit)
 2c1:	b8 02 00 00 00       	mov    $0x2,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <wait>:
SYSCALL(wait)
 2c9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <pipe>:
SYSCALL(pipe)
 2d1:	b8 04 00 00 00       	mov    $0x4,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <read>:
SYSCALL(read)
 2d9:	b8 05 00 00 00       	mov    $0x5,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <write>:
SYSCALL(write)
 2e1:	b8 10 00 00 00       	mov    $0x10,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <close>:
SYSCALL(close)
 2e9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <kill>:
SYSCALL(kill)
 2f1:	b8 06 00 00 00       	mov    $0x6,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exec>:
SYSCALL(exec)
 2f9:	b8 07 00 00 00       	mov    $0x7,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <open>:
SYSCALL(open)
 301:	b8 0f 00 00 00       	mov    $0xf,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <mknod>:
SYSCALL(mknod)
 309:	b8 11 00 00 00       	mov    $0x11,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <unlink>:
SYSCALL(unlink)
 311:	b8 12 00 00 00       	mov    $0x12,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <fstat>:
SYSCALL(fstat)
 319:	b8 08 00 00 00       	mov    $0x8,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <link>:
SYSCALL(link)
 321:	b8 13 00 00 00       	mov    $0x13,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <mkdir>:
SYSCALL(mkdir)
 329:	b8 14 00 00 00       	mov    $0x14,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <chdir>:
SYSCALL(chdir)
 331:	b8 09 00 00 00       	mov    $0x9,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <dup>:
SYSCALL(dup)
 339:	b8 0a 00 00 00       	mov    $0xa,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <getpid>:
SYSCALL(getpid)
 341:	b8 0b 00 00 00       	mov    $0xb,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <sbrk>:
SYSCALL(sbrk)
 349:	b8 0c 00 00 00       	mov    $0xc,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sleep>:
SYSCALL(sleep)
 351:	b8 0d 00 00 00       	mov    $0xd,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <uptime>:
SYSCALL(uptime)
 359:	b8 0e 00 00 00       	mov    $0xe,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <slabtest>:
SYSCALL(slabtest)
 361:	b8 16 00 00 00       	mov    $0x16,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <ps>:
SYSCALL(ps)
 369:	b8 17 00 00 00       	mov    $0x17,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	56                   	push   %esi
 376:	53                   	push   %ebx
 377:	83 ec 3c             	sub    $0x3c,%esp
 37a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 37d:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 383:	74 79                	je     3fe <printint+0x8d>
 385:	85 d2                	test   %edx,%edx
 387:	79 75                	jns    3fe <printint+0x8d>
    neg = 1;
    x = -xx;
 389:	89 d1                	mov    %edx,%ecx
 38b:	f7 d9                	neg    %ecx
    neg = 1;
 38d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 394:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 399:	89 df                	mov    %ebx,%edi
 39b:	83 c3 01             	add    $0x1,%ebx
 39e:	89 c8                	mov    %ecx,%eax
 3a0:	ba 00 00 00 00       	mov    $0x0,%edx
 3a5:	f7 f6                	div    %esi
 3a7:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
 3ae:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3b2:	89 ca                	mov    %ecx,%edx
 3b4:	89 c1                	mov    %eax,%ecx
 3b6:	39 d6                	cmp    %edx,%esi
 3b8:	76 df                	jbe    399 <printint+0x28>
  if(neg)
 3ba:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3be:	74 08                	je     3c8 <printint+0x57>
    buf[i++] = '-';
 3c0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c5:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3c8:	85 db                	test   %ebx,%ebx
 3ca:	7e 2a                	jle    3f6 <printint+0x85>
 3cc:	8d 7d d8             	lea    -0x28(%ebp),%edi
 3cf:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 3d3:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3d6:	0f b6 03             	movzbl (%ebx),%eax
 3d9:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	6a 01                	push   $0x1
 3e1:	56                   	push   %esi
 3e2:	ff 75 c4             	push   -0x3c(%ebp)
 3e5:	e8 f7 fe ff ff       	call   2e1 <write>
  while(--i >= 0)
 3ea:	89 d8                	mov    %ebx,%eax
 3ec:	83 eb 01             	sub    $0x1,%ebx
 3ef:	83 c4 10             	add    $0x10,%esp
 3f2:	39 f8                	cmp    %edi,%eax
 3f4:	75 e0                	jne    3d6 <printint+0x65>
}
 3f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5f                   	pop    %edi
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    
    x = xx;
 3fe:	89 d1                	mov    %edx,%ecx
  neg = 0;
 400:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 407:	eb 8b                	jmp    394 <printint+0x23>

00000409 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	57                   	push   %edi
 40d:	56                   	push   %esi
 40e:	53                   	push   %ebx
 40f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 412:	8b 75 0c             	mov    0xc(%ebp),%esi
 415:	0f b6 1e             	movzbl (%esi),%ebx
 418:	84 db                	test   %bl,%bl
 41a:	0f 84 9f 01 00 00    	je     5bf <printf+0x1b6>
 420:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 423:	8d 45 10             	lea    0x10(%ebp),%eax
 426:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 429:	bf 00 00 00 00       	mov    $0x0,%edi
 42e:	eb 2d                	jmp    45d <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 430:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 433:	83 ec 04             	sub    $0x4,%esp
 436:	6a 01                	push   $0x1
 438:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43b:	50                   	push   %eax
 43c:	ff 75 08             	push   0x8(%ebp)
 43f:	e8 9d fe ff ff       	call   2e1 <write>
        putc(fd, c);
 444:	83 c4 10             	add    $0x10,%esp
 447:	eb 05                	jmp    44e <printf+0x45>
      }
    } else if(state == '%'){
 449:	83 ff 25             	cmp    $0x25,%edi
 44c:	74 1f                	je     46d <printf+0x64>
  for(i = 0; fmt[i]; i++){
 44e:	83 c6 01             	add    $0x1,%esi
 451:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 455:	84 db                	test   %bl,%bl
 457:	0f 84 62 01 00 00    	je     5bf <printf+0x1b6>
    c = fmt[i] & 0xff;
 45d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 460:	85 ff                	test   %edi,%edi
 462:	75 e5                	jne    449 <printf+0x40>
      if(c == '%'){
 464:	83 f8 25             	cmp    $0x25,%eax
 467:	75 c7                	jne    430 <printf+0x27>
        state = '%';
 469:	89 c7                	mov    %eax,%edi
 46b:	eb e1                	jmp    44e <printf+0x45>
      if(c == 'd'){
 46d:	83 f8 25             	cmp    $0x25,%eax
 470:	0f 84 f2 00 00 00    	je     568 <printf+0x15f>
 476:	8d 50 9d             	lea    -0x63(%eax),%edx
 479:	83 fa 15             	cmp    $0x15,%edx
 47c:	0f 87 07 01 00 00    	ja     589 <printf+0x180>
 482:	0f 87 01 01 00 00    	ja     589 <printf+0x180>
 488:	ff 24 95 40 07 00 00 	jmp    *0x740(,%edx,4)
        printint(fd, *ap, 10, 1);
 48f:	83 ec 0c             	sub    $0xc,%esp
 492:	6a 01                	push   $0x1
 494:	b9 0a 00 00 00       	mov    $0xa,%ecx
 499:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49c:	8b 17                	mov    (%edi),%edx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 cb fe ff ff       	call   371 <printint>
        ap++;
 4a6:	89 f8                	mov    %edi,%eax
 4a8:	83 c0 04             	add    $0x4,%eax
 4ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ae:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b1:	bf 00 00 00 00       	mov    $0x0,%edi
 4b6:	eb 96                	jmp    44e <printf+0x45>
        printint(fd, *ap, 16, 0);
 4b8:	83 ec 0c             	sub    $0xc,%esp
 4bb:	6a 00                	push   $0x0
 4bd:	b9 10 00 00 00       	mov    $0x10,%ecx
 4c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c5:	8b 17                	mov    (%edi),%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 a2 fe ff ff       	call   371 <printint>
        ap++;
 4cf:	89 f8                	mov    %edi,%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4da:	bf 00 00 00 00       	mov    $0x0,%edi
 4df:	e9 6a ff ff ff       	jmp    44e <printf+0x45>
        s = (char*)*ap;
 4e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4e7:	8b 01                	mov    (%ecx),%eax
        ap++;
 4e9:	83 c1 04             	add    $0x4,%ecx
 4ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4ef:	85 c0                	test   %eax,%eax
 4f1:	74 13                	je     506 <printf+0xfd>
        s = (char*)*ap;
 4f3:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4f5:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4f8:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4fd:	84 c0                	test   %al,%al
 4ff:	75 0f                	jne    510 <printf+0x107>
 501:	e9 48 ff ff ff       	jmp    44e <printf+0x45>
          s = "(null)";
 506:	bb 38 07 00 00       	mov    $0x738,%ebx
        while(*s != 0){
 50b:	b8 28 00 00 00       	mov    $0x28,%eax
 510:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 513:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 516:	83 ec 04             	sub    $0x4,%esp
 519:	6a 01                	push   $0x1
 51b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 51e:	50                   	push   %eax
 51f:	57                   	push   %edi
 520:	e8 bc fd ff ff       	call   2e1 <write>
          s++;
 525:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 528:	0f b6 03             	movzbl (%ebx),%eax
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	84 c0                	test   %al,%al
 530:	75 e1                	jne    513 <printf+0x10a>
      state = 0;
 532:	bf 00 00 00 00       	mov    $0x0,%edi
 537:	e9 12 ff ff ff       	jmp    44e <printf+0x45>
        putc(fd, *ap);
 53c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 53f:	8b 07                	mov    (%edi),%eax
 541:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 544:	83 ec 04             	sub    $0x4,%esp
 547:	6a 01                	push   $0x1
 549:	8d 45 e7             	lea    -0x19(%ebp),%eax
 54c:	50                   	push   %eax
 54d:	ff 75 08             	push   0x8(%ebp)
 550:	e8 8c fd ff ff       	call   2e1 <write>
        ap++;
 555:	83 c7 04             	add    $0x4,%edi
 558:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 55b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55e:	bf 00 00 00 00       	mov    $0x0,%edi
 563:	e9 e6 fe ff ff       	jmp    44e <printf+0x45>
        putc(fd, c);
 568:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 56b:	83 ec 04             	sub    $0x4,%esp
 56e:	6a 01                	push   $0x1
 570:	8d 45 e7             	lea    -0x19(%ebp),%eax
 573:	50                   	push   %eax
 574:	ff 75 08             	push   0x8(%ebp)
 577:	e8 65 fd ff ff       	call   2e1 <write>
 57c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 57f:	bf 00 00 00 00       	mov    $0x0,%edi
 584:	e9 c5 fe ff ff       	jmp    44e <printf+0x45>
        putc(fd, '%');
 589:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 58d:	83 ec 04             	sub    $0x4,%esp
 590:	6a 01                	push   $0x1
 592:	8d 45 e7             	lea    -0x19(%ebp),%eax
 595:	50                   	push   %eax
 596:	ff 75 08             	push   0x8(%ebp)
 599:	e8 43 fd ff ff       	call   2e1 <write>
        putc(fd, c);
 59e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5a1:	83 c4 0c             	add    $0xc,%esp
 5a4:	6a 01                	push   $0x1
 5a6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	push   0x8(%ebp)
 5ad:	e8 2f fd ff ff       	call   2e1 <write>
        putc(fd, c);
 5b2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b5:	bf 00 00 00 00       	mov    $0x0,%edi
 5ba:	e9 8f fe ff ff       	jmp    44e <printf+0x45>
    }
  }
}
 5bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    

000005c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	57                   	push   %edi
 5cb:	56                   	push   %esi
 5cc:	53                   	push   %ebx
 5cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d3:	a1 40 0c 00 00       	mov    0xc40,%eax
 5d8:	eb 0c                	jmp    5e6 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5da:	8b 10                	mov    (%eax),%edx
 5dc:	39 c2                	cmp    %eax,%edx
 5de:	77 04                	ja     5e4 <free+0x1d>
 5e0:	39 ca                	cmp    %ecx,%edx
 5e2:	77 10                	ja     5f4 <free+0x2d>
{
 5e4:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e6:	39 c8                	cmp    %ecx,%eax
 5e8:	73 f0                	jae    5da <free+0x13>
 5ea:	8b 10                	mov    (%eax),%edx
 5ec:	39 ca                	cmp    %ecx,%edx
 5ee:	77 04                	ja     5f4 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	39 c2                	cmp    %eax,%edx
 5f2:	77 f0                	ja     5e4 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f7:	8b 10                	mov    (%eax),%edx
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	39 fa                	cmp    %edi,%edx
 5fe:	74 19                	je     619 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 600:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 603:	8b 50 04             	mov    0x4(%eax),%edx
 606:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 609:	39 f1                	cmp    %esi,%ecx
 60b:	74 18                	je     625 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 60d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 60f:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 614:	5b                   	pop    %ebx
 615:	5e                   	pop    %esi
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 619:	03 72 04             	add    0x4(%edx),%esi
 61c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61f:	8b 10                	mov    (%eax),%edx
 621:	8b 12                	mov    (%edx),%edx
 623:	eb db                	jmp    600 <free+0x39>
    p->s.size += bp->s.size;
 625:	03 53 fc             	add    -0x4(%ebx),%edx
 628:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62b:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 62e:	eb dd                	jmp    60d <free+0x46>

00000630 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	8d 58 07             	lea    0x7(%eax),%ebx
 63f:	c1 eb 03             	shr    $0x3,%ebx
 642:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 645:	8b 15 40 0c 00 00    	mov    0xc40,%edx
 64b:	85 d2                	test   %edx,%edx
 64d:	74 1c                	je     66b <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64f:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 651:	8b 48 04             	mov    0x4(%eax),%ecx
 654:	39 cb                	cmp    %ecx,%ebx
 656:	76 38                	jbe    690 <malloc+0x60>
 658:	be 00 10 00 00       	mov    $0x1000,%esi
 65d:	39 f3                	cmp    %esi,%ebx
 65f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 662:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 669:	eb 72                	jmp    6dd <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 66b:	c7 05 40 0c 00 00 44 	movl   $0xc44,0xc40
 672:	0c 00 00 
 675:	c7 05 44 0c 00 00 44 	movl   $0xc44,0xc44
 67c:	0c 00 00 
    base.s.size = 0;
 67f:	c7 05 48 0c 00 00 00 	movl   $0x0,0xc48
 686:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 689:	b8 44 0c 00 00       	mov    $0xc44,%eax
 68e:	eb c8                	jmp    658 <malloc+0x28>
      if(p->s.size == nunits)
 690:	39 cb                	cmp    %ecx,%ebx
 692:	74 1e                	je     6b2 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 694:	29 d9                	sub    %ebx,%ecx
 696:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 699:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 69c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 69f:	89 15 40 0c 00 00    	mov    %edx,0xc40
      return (void*)(p + 1);
 6a5:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a8:	89 d0                	mov    %edx,%eax
 6aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ad:	5b                   	pop    %ebx
 6ae:	5e                   	pop    %esi
 6af:	5f                   	pop    %edi
 6b0:	5d                   	pop    %ebp
 6b1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b2:	8b 08                	mov    (%eax),%ecx
 6b4:	89 0a                	mov    %ecx,(%edx)
 6b6:	eb e7                	jmp    69f <malloc+0x6f>
  hp->s.size = nu;
 6b8:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	83 c0 08             	add    $0x8,%eax
 6c1:	50                   	push   %eax
 6c2:	e8 00 ff ff ff       	call   5c7 <free>
  return freep;
 6c7:	8b 15 40 0c 00 00    	mov    0xc40,%edx
      if((p = morecore(nunits)) == 0)
 6cd:	83 c4 10             	add    $0x10,%esp
 6d0:	85 d2                	test   %edx,%edx
 6d2:	74 d4                	je     6a8 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d4:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d6:	8b 48 04             	mov    0x4(%eax),%ecx
 6d9:	39 d9                	cmp    %ebx,%ecx
 6db:	73 b3                	jae    690 <malloc+0x60>
    if(p == freep)
 6dd:	89 c2                	mov    %eax,%edx
 6df:	39 05 40 0c 00 00    	cmp    %eax,0xc40
 6e5:	75 ed                	jne    6d4 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	57                   	push   %edi
 6eb:	e8 59 fc ff ff       	call   349 <sbrk>
  if(p == (char*)-1)
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f6:	75 c0                	jne    6b8 <malloc+0x88>
        return 0;
 6f8:	ba 00 00 00 00       	mov    $0x0,%edx
 6fd:	eb a9                	jmp    6a8 <malloc+0x78>
