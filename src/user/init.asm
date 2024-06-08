
user/_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 24 07 00 00       	push   $0x724
  1d:	e8 e5 02 00 00       	call   307 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 59                	js     82 <main+0x82>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 0c 03 00 00       	call   33f <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 00 03 00 00       	call   33f <dup>
  3f:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  42:	83 ec 08             	sub    $0x8,%esp
  45:	68 2c 07 00 00       	push   $0x72c
  4a:	6a 01                	push   $0x1
  4c:	e8 ba 03 00 00       	call   40b <printf>
    pid = fork();
  51:	e8 69 02 00 00       	call   2bf <fork>
  56:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	78 48                	js     a7 <main+0xa7>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  5f:	74 5a                	je     bb <main+0xbb>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  61:	e8 69 02 00 00       	call   2cf <wait>
  66:	39 c3                	cmp    %eax,%ebx
  68:	74 d8                	je     42 <main+0x42>
  6a:	85 c0                	test   %eax,%eax
  6c:	78 d4                	js     42 <main+0x42>
      printf(1, "zombie!\n");
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 6b 07 00 00       	push   $0x76b
  76:	6a 01                	push   $0x1
  78:	e8 8e 03 00 00       	call   40b <printf>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	eb df                	jmp    61 <main+0x61>
    mknod("console", 1, 1);
  82:	83 ec 04             	sub    $0x4,%esp
  85:	6a 01                	push   $0x1
  87:	6a 01                	push   $0x1
  89:	68 24 07 00 00       	push   $0x724
  8e:	e8 7c 02 00 00       	call   30f <mknod>
    open("console", O_RDWR);
  93:	83 c4 08             	add    $0x8,%esp
  96:	6a 02                	push   $0x2
  98:	68 24 07 00 00       	push   $0x724
  9d:	e8 65 02 00 00       	call   307 <open>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	eb 82                	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 3f 07 00 00       	push   $0x73f
  af:	6a 01                	push   $0x1
  b1:	e8 55 03 00 00       	call   40b <printf>
      exit();
  b6:	e8 0c 02 00 00       	call   2c7 <exit>
      exec("sh", argv);
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	68 e8 09 00 00       	push   $0x9e8
  c3:	68 52 07 00 00       	push   $0x752
  c8:	e8 32 02 00 00       	call   2ff <exec>
      printf(1, "init: exec sh failed\n");
  cd:	83 c4 08             	add    $0x8,%esp
  d0:	68 55 07 00 00       	push   $0x755
  d5:	6a 01                	push   $0x1
  d7:	e8 2f 03 00 00       	call   40b <printf>
      exit();
  dc:	e8 e6 01 00 00       	call   2c7 <exit>

000000e1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e1:	f3 0f 1e fb          	endbr32 
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	53                   	push   %ebx
  e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ef:	b8 00 00 00 00       	mov    $0x0,%eax
  f4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  f8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  fb:	83 c0 01             	add    $0x1,%eax
  fe:	84 d2                	test   %dl,%dl
 100:	75 f2                	jne    f4 <strcpy+0x13>
    ;
  return os;
}
 102:	89 c8                	mov    %ecx,%eax
 104:	5b                   	pop    %ebx
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 107:	f3 0f 1e fb          	endbr32 
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 111:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 114:	0f b6 01             	movzbl (%ecx),%eax
 117:	84 c0                	test   %al,%al
 119:	74 11                	je     12c <strcmp+0x25>
 11b:	38 02                	cmp    %al,(%edx)
 11d:	75 0d                	jne    12c <strcmp+0x25>
    p++, q++;
 11f:	83 c1 01             	add    $0x1,%ecx
 122:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 125:	0f b6 01             	movzbl (%ecx),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 ef                	jne    11b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 12c:	0f b6 c0             	movzbl %al,%eax
 12f:	0f b6 12             	movzbl (%edx),%edx
 132:	29 d0                	sub    %edx,%eax
}
 134:	5d                   	pop    %ebp
 135:	c3                   	ret    

00000136 <strlen>:

uint
strlen(const char *s)
{
 136:	f3 0f 1e fb          	endbr32 
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 140:	80 3a 00             	cmpb   $0x0,(%edx)
 143:	74 14                	je     159 <strlen+0x23>
 145:	b8 00 00 00 00       	mov    $0x0,%eax
 14a:	83 c0 01             	add    $0x1,%eax
 14d:	89 c1                	mov    %eax,%ecx
 14f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 153:	75 f5                	jne    14a <strlen+0x14>
    ;
  return n;
}
 155:	89 c8                	mov    %ecx,%eax
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
  for(n = 0; s[n]; n++)
 159:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 15e:	eb f5                	jmp    155 <strlen+0x1f>

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	57                   	push   %edi
 168:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 16b:	89 d7                	mov    %edx,%edi
 16d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	fc                   	cld    
 174:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 176:	89 d0                	mov    %edx,%eax
 178:	5f                   	pop    %edi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    

0000017b <strchr>:

char*
strchr(const char *s, char c)
{
 17b:	f3 0f 1e fb          	endbr32 
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 189:	0f b6 10             	movzbl (%eax),%edx
 18c:	84 d2                	test   %dl,%dl
 18e:	74 15                	je     1a5 <strchr+0x2a>
    if(*s == c)
 190:	38 d1                	cmp    %dl,%cl
 192:	74 0f                	je     1a3 <strchr+0x28>
  for(; *s; s++)
 194:	83 c0 01             	add    $0x1,%eax
 197:	0f b6 10             	movzbl (%eax),%edx
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strchr+0x15>
      return (char*)s;
  return 0;
 19e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
  return 0;
 1a5:	b8 00 00 00 00       	mov    $0x0,%eax
 1aa:	eb f7                	jmp    1a3 <strchr+0x28>

000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	f3 0f 1e fb          	endbr32 
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	83 ec 2c             	sub    $0x2c,%esp
 1b9:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1c1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1c7:	83 c3 01             	add    $0x1,%ebx
 1ca:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cd:	7d 27                	jge    1f6 <gets+0x4a>
    cc = read(0, &c, 1);
 1cf:	83 ec 04             	sub    $0x4,%esp
 1d2:	6a 01                	push   $0x1
 1d4:	57                   	push   %edi
 1d5:	6a 00                	push   $0x0
 1d7:	e8 03 01 00 00       	call   2df <read>
    if(cc < 1)
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	85 c0                	test   %eax,%eax
 1e1:	7e 13                	jle    1f6 <gets+0x4a>
      break;
    buf[i++] = c;
 1e3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e7:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 1eb:	3c 0a                	cmp    $0xa,%al
 1ed:	74 04                	je     1f3 <gets+0x47>
 1ef:	3c 0d                	cmp    $0xd,%al
 1f1:	75 d1                	jne    1c4 <gets+0x18>
  for(i=0; i+1 < max; ){
 1f3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 1f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1f9:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 1fd:	89 f0                	mov    %esi,%eax
 1ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 202:	5b                   	pop    %ebx
 203:	5e                   	pop    %esi
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    

00000207 <stat>:

int
stat(const char *n, struct stat *st)
{
 207:	f3 0f 1e fb          	endbr32 
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	56                   	push   %esi
 20f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 00                	push   $0x0
 215:	ff 75 08             	pushl  0x8(%ebp)
 218:	e8 ea 00 00 00       	call   307 <open>
  if(fd < 0)
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	78 24                	js     248 <stat+0x41>
 224:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 226:	83 ec 08             	sub    $0x8,%esp
 229:	ff 75 0c             	pushl  0xc(%ebp)
 22c:	50                   	push   %eax
 22d:	e8 ed 00 00 00       	call   31f <fstat>
 232:	89 c6                	mov    %eax,%esi
  close(fd);
 234:	89 1c 24             	mov    %ebx,(%esp)
 237:	e8 b3 00 00 00       	call   2ef <close>
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
 24d:	eb f0                	jmp    23f <stat+0x38>

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	f3 0f 1e fb          	endbr32 
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	53                   	push   %ebx
 257:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25a:	0f b6 02             	movzbl (%edx),%eax
 25d:	8d 48 d0             	lea    -0x30(%eax),%ecx
 260:	80 f9 09             	cmp    $0x9,%cl
 263:	77 22                	ja     287 <atoi+0x38>
  n = 0;
 265:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 26a:	83 c2 01             	add    $0x1,%edx
 26d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 270:	0f be c0             	movsbl %al,%eax
 273:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 277:	0f b6 02             	movzbl (%edx),%eax
 27a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 27d:	80 fb 09             	cmp    $0x9,%bl
 280:	76 e8                	jbe    26a <atoi+0x1b>
  return n;
}
 282:	89 c8                	mov    %ecx,%eax
 284:	5b                   	pop    %ebx
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
  n = 0;
 287:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 28c:	eb f4                	jmp    282 <atoi+0x33>

0000028e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28e:	f3 0f 1e fb          	endbr32 
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	56                   	push   %esi
 296:	53                   	push   %ebx
 297:	8b 75 08             	mov    0x8(%ebp),%esi
 29a:	8b 55 0c             	mov    0xc(%ebp),%edx
 29d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a0:	85 db                	test   %ebx,%ebx
 2a2:	7e 15                	jle    2b9 <memmove+0x2b>
 2a4:	01 f3                	add    %esi,%ebx
  dst = vdst;
 2a6:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 2a8:	83 c2 01             	add    $0x1,%edx
 2ab:	83 c0 01             	add    $0x1,%eax
 2ae:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2b2:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 2b5:	39 c3                	cmp    %eax,%ebx
 2b7:	75 ef                	jne    2a8 <memmove+0x1a>
  return vdst;
}
 2b9:	89 f0                	mov    %esi,%eax
 2bb:	5b                   	pop    %ebx
 2bc:	5e                   	pop    %esi
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    

000002bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bf:	b8 01 00 00 00       	mov    $0x1,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <exit>:
SYSCALL(exit)
 2c7:	b8 02 00 00 00       	mov    $0x2,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <wait>:
SYSCALL(wait)
 2cf:	b8 03 00 00 00       	mov    $0x3,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <pipe>:
SYSCALL(pipe)
 2d7:	b8 04 00 00 00       	mov    $0x4,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <read>:
SYSCALL(read)
 2df:	b8 05 00 00 00       	mov    $0x5,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <write>:
SYSCALL(write)
 2e7:	b8 10 00 00 00       	mov    $0x10,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <close>:
SYSCALL(close)
 2ef:	b8 15 00 00 00       	mov    $0x15,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <kill>:
SYSCALL(kill)
 2f7:	b8 06 00 00 00       	mov    $0x6,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exec>:
SYSCALL(exec)
 2ff:	b8 07 00 00 00       	mov    $0x7,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <open>:
SYSCALL(open)
 307:	b8 0f 00 00 00       	mov    $0xf,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mknod>:
SYSCALL(mknod)
 30f:	b8 11 00 00 00       	mov    $0x11,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <unlink>:
SYSCALL(unlink)
 317:	b8 12 00 00 00       	mov    $0x12,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <fstat>:
SYSCALL(fstat)
 31f:	b8 08 00 00 00       	mov    $0x8,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <link>:
SYSCALL(link)
 327:	b8 13 00 00 00       	mov    $0x13,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mkdir>:
SYSCALL(mkdir)
 32f:	b8 14 00 00 00       	mov    $0x14,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <chdir>:
SYSCALL(chdir)
 337:	b8 09 00 00 00       	mov    $0x9,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <dup>:
SYSCALL(dup)
 33f:	b8 0a 00 00 00       	mov    $0xa,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <getpid>:
SYSCALL(getpid)
 347:	b8 0b 00 00 00       	mov    $0xb,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sbrk>:
SYSCALL(sbrk)
 34f:	b8 0c 00 00 00       	mov    $0xc,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sleep>:
SYSCALL(sleep)
 357:	b8 0d 00 00 00       	mov    $0xd,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <uptime>:
SYSCALL(uptime)
 35f:	b8 0e 00 00 00       	mov    $0xe,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <slabtest>:
SYSCALL(slabtest)
 367:	b8 16 00 00 00       	mov    $0x16,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <ps>:
SYSCALL(ps)
 36f:	b8 17 00 00 00       	mov    $0x17,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	57                   	push   %edi
 37b:	56                   	push   %esi
 37c:	53                   	push   %ebx
 37d:	83 ec 3c             	sub    $0x3c,%esp
 380:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 383:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 385:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 389:	74 77                	je     402 <printint+0x8b>
 38b:	85 d2                	test   %edx,%edx
 38d:	79 73                	jns    402 <printint+0x8b>
    neg = 1;
    x = -xx;
 38f:	f7 db                	neg    %ebx
    neg = 1;
 391:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 398:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 39d:	89 f7                	mov    %esi,%edi
 39f:	83 c6 01             	add    $0x1,%esi
 3a2:	89 d8                	mov    %ebx,%eax
 3a4:	ba 00 00 00 00       	mov    $0x0,%edx
 3a9:	f7 f1                	div    %ecx
 3ab:	0f b6 92 7c 07 00 00 	movzbl 0x77c(%edx),%edx
 3b2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3b6:	89 da                	mov    %ebx,%edx
 3b8:	89 c3                	mov    %eax,%ebx
 3ba:	39 d1                	cmp    %edx,%ecx
 3bc:	76 df                	jbe    39d <printint+0x26>
  if(neg)
 3be:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3c2:	74 08                	je     3cc <printint+0x55>
    buf[i++] = '-';
 3c4:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 3c9:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 3cc:	85 f6                	test   %esi,%esi
 3ce:	7e 2a                	jle    3fa <printint+0x83>
 3d0:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 3d4:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 3d7:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3da:	0f b6 03             	movzbl (%ebx),%eax
 3dd:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3e0:	83 ec 04             	sub    $0x4,%esp
 3e3:	6a 01                	push   $0x1
 3e5:	56                   	push   %esi
 3e6:	ff 75 c4             	pushl  -0x3c(%ebp)
 3e9:	e8 f9 fe ff ff       	call   2e7 <write>
  while(--i >= 0)
 3ee:	89 d8                	mov    %ebx,%eax
 3f0:	83 eb 01             	sub    $0x1,%ebx
 3f3:	83 c4 10             	add    $0x10,%esp
 3f6:	39 f8                	cmp    %edi,%eax
 3f8:	75 e0                	jne    3da <printint+0x63>
}
 3fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fd:	5b                   	pop    %ebx
 3fe:	5e                   	pop    %esi
 3ff:	5f                   	pop    %edi
 400:	5d                   	pop    %ebp
 401:	c3                   	ret    
  neg = 0;
 402:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 409:	eb 8d                	jmp    398 <printint+0x21>

0000040b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 40b:	f3 0f 1e fb          	endbr32 
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	57                   	push   %edi
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
 415:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 418:	8b 75 0c             	mov    0xc(%ebp),%esi
 41b:	0f b6 1e             	movzbl (%esi),%ebx
 41e:	84 db                	test   %bl,%bl
 420:	0f 84 ab 01 00 00    	je     5d1 <printf+0x1c6>
 426:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 429:	8d 45 10             	lea    0x10(%ebp),%eax
 42c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 42f:	bf 00 00 00 00       	mov    $0x0,%edi
 434:	eb 2d                	jmp    463 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 436:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 439:	83 ec 04             	sub    $0x4,%esp
 43c:	6a 01                	push   $0x1
 43e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 441:	50                   	push   %eax
 442:	ff 75 08             	pushl  0x8(%ebp)
 445:	e8 9d fe ff ff       	call   2e7 <write>
        putc(fd, c);
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	eb 05                	jmp    454 <printf+0x49>
      }
    } else if(state == '%'){
 44f:	83 ff 25             	cmp    $0x25,%edi
 452:	74 22                	je     476 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 454:	83 c6 01             	add    $0x1,%esi
 457:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 45b:	84 db                	test   %bl,%bl
 45d:	0f 84 6e 01 00 00    	je     5d1 <printf+0x1c6>
    c = fmt[i] & 0xff;
 463:	0f be d3             	movsbl %bl,%edx
 466:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 469:	85 ff                	test   %edi,%edi
 46b:	75 e2                	jne    44f <printf+0x44>
      if(c == '%'){
 46d:	83 f8 25             	cmp    $0x25,%eax
 470:	75 c4                	jne    436 <printf+0x2b>
        state = '%';
 472:	89 c7                	mov    %eax,%edi
 474:	eb de                	jmp    454 <printf+0x49>
      if(c == 'd'){
 476:	83 f8 64             	cmp    $0x64,%eax
 479:	74 59                	je     4d4 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 47b:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 481:	83 fa 70             	cmp    $0x70,%edx
 484:	74 7a                	je     500 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 486:	83 f8 73             	cmp    $0x73,%eax
 489:	0f 84 9d 00 00 00    	je     52c <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48f:	83 f8 63             	cmp    $0x63,%eax
 492:	0f 84 ec 00 00 00    	je     584 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 0f 01 00 00    	je     5b0 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4a1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4a5:	83 ec 04             	sub    $0x4,%esp
 4a8:	6a 01                	push   $0x1
 4aa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ad:	50                   	push   %eax
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 31 fe ff ff       	call   2e7 <write>
        putc(fd, c);
 4b6:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4b9:	83 c4 0c             	add    $0xc,%esp
 4bc:	6a 01                	push   $0x1
 4be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 1d fe ff ff       	call   2e7 <write>
        putc(fd, c);
 4ca:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4cd:	bf 00 00 00 00       	mov    $0x0,%edi
 4d2:	eb 80                	jmp    454 <printf+0x49>
        printint(fd, *ap, 10, 1);
 4d4:	83 ec 0c             	sub    $0xc,%esp
 4d7:	6a 01                	push   $0x1
 4d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4de:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4e1:	8b 17                	mov    (%edi),%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 8c fe ff ff       	call   377 <printint>
        ap++;
 4eb:	89 f8                	mov    %edi,%eax
 4ed:	83 c0 04             	add    $0x4,%eax
 4f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f6:	bf 00 00 00 00       	mov    $0x0,%edi
 4fb:	e9 54 ff ff ff       	jmp    454 <printf+0x49>
        printint(fd, *ap, 16, 0);
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	6a 00                	push   $0x0
 505:	b9 10 00 00 00       	mov    $0x10,%ecx
 50a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 50d:	8b 17                	mov    (%edi),%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 60 fe ff ff       	call   377 <printint>
        ap++;
 517:	89 f8                	mov    %edi,%eax
 519:	83 c0 04             	add    $0x4,%eax
 51c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 51f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 522:	bf 00 00 00 00       	mov    $0x0,%edi
 527:	e9 28 ff ff ff       	jmp    454 <printf+0x49>
        s = (char*)*ap;
 52c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 52f:	8b 01                	mov    (%ecx),%eax
        ap++;
 531:	83 c1 04             	add    $0x4,%ecx
 534:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 537:	85 c0                	test   %eax,%eax
 539:	74 13                	je     54e <printf+0x143>
        s = (char*)*ap;
 53b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 53d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 540:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 545:	84 c0                	test   %al,%al
 547:	75 0f                	jne    558 <printf+0x14d>
 549:	e9 06 ff ff ff       	jmp    454 <printf+0x49>
          s = "(null)";
 54e:	bb 74 07 00 00       	mov    $0x774,%ebx
        while(*s != 0){
 553:	b8 28 00 00 00       	mov    $0x28,%eax
 558:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 55b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55e:	83 ec 04             	sub    $0x4,%esp
 561:	6a 01                	push   $0x1
 563:	8d 45 e7             	lea    -0x19(%ebp),%eax
 566:	50                   	push   %eax
 567:	57                   	push   %edi
 568:	e8 7a fd ff ff       	call   2e7 <write>
          s++;
 56d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 570:	0f b6 03             	movzbl (%ebx),%eax
 573:	83 c4 10             	add    $0x10,%esp
 576:	84 c0                	test   %al,%al
 578:	75 e1                	jne    55b <printf+0x150>
      state = 0;
 57a:	bf 00 00 00 00       	mov    $0x0,%edi
 57f:	e9 d0 fe ff ff       	jmp    454 <printf+0x49>
        putc(fd, *ap);
 584:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 587:	8b 07                	mov    (%edi),%eax
 589:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58c:	83 ec 04             	sub    $0x4,%esp
 58f:	6a 01                	push   $0x1
 591:	8d 45 e7             	lea    -0x19(%ebp),%eax
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 4a fd ff ff       	call   2e7 <write>
        ap++;
 59d:	83 c7 04             	add    $0x4,%edi
 5a0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5a3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a6:	bf 00 00 00 00       	mov    $0x0,%edi
 5ab:	e9 a4 fe ff ff       	jmp    454 <printf+0x49>
        putc(fd, c);
 5b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
 5b6:	6a 01                	push   $0x1
 5b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 23 fd ff ff       	call   2e7 <write>
 5c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c7:	bf 00 00 00 00       	mov    $0x0,%edi
 5cc:	e9 83 fe ff ff       	jmp    454 <printf+0x49>
    }
  }
}
 5d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d4:	5b                   	pop    %ebx
 5d5:	5e                   	pop    %esi
 5d6:	5f                   	pop    %edi
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret    

000005d9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d9:	f3 0f 1e fb          	endbr32 
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	57                   	push   %edi
 5e1:	56                   	push   %esi
 5e2:	53                   	push   %ebx
 5e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e6:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e9:	a1 f0 09 00 00       	mov    0x9f0,%eax
 5ee:	eb 0c                	jmp    5fc <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	8b 10                	mov    (%eax),%edx
 5f2:	39 c2                	cmp    %eax,%edx
 5f4:	77 04                	ja     5fa <free+0x21>
 5f6:	39 ca                	cmp    %ecx,%edx
 5f8:	77 10                	ja     60a <free+0x31>
{
 5fa:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	73 f0                	jae    5f0 <free+0x17>
 600:	8b 10                	mov    (%eax),%edx
 602:	39 ca                	cmp    %ecx,%edx
 604:	77 04                	ja     60a <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 606:	39 c2                	cmp    %eax,%edx
 608:	77 f0                	ja     5fa <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 60a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60d:	8b 10                	mov    (%eax),%edx
 60f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 612:	39 fa                	cmp    %edi,%edx
 614:	74 19                	je     62f <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 616:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 619:	8b 50 04             	mov    0x4(%eax),%edx
 61c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61f:	39 f1                	cmp    %esi,%ecx
 621:	74 1b                	je     63e <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 623:	89 08                	mov    %ecx,(%eax)
  freep = p;
 625:	a3 f0 09 00 00       	mov    %eax,0x9f0
}
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 62f:	03 72 04             	add    0x4(%edx),%esi
 632:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 12                	mov    (%edx),%edx
 639:	89 53 f8             	mov    %edx,-0x8(%ebx)
 63c:	eb db                	jmp    619 <free+0x40>
    p->s.size += bp->s.size;
 63e:	03 53 fc             	add    -0x4(%ebx),%edx
 641:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 644:	8b 53 f8             	mov    -0x8(%ebx),%edx
 647:	89 10                	mov    %edx,(%eax)
 649:	eb da                	jmp    625 <free+0x4c>

0000064b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 64b:	f3 0f 1e fb          	endbr32 
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	57                   	push   %edi
 653:	56                   	push   %esi
 654:	53                   	push   %ebx
 655:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	8d 58 07             	lea    0x7(%eax),%ebx
 65e:	c1 eb 03             	shr    $0x3,%ebx
 661:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 664:	8b 15 f0 09 00 00    	mov    0x9f0,%edx
 66a:	85 d2                	test   %edx,%edx
 66c:	74 20                	je     68e <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 670:	8b 48 04             	mov    0x4(%eax),%ecx
 673:	39 cb                	cmp    %ecx,%ebx
 675:	76 3c                	jbe    6b3 <malloc+0x68>
 677:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 67d:	be 00 10 00 00       	mov    $0x1000,%esi
 682:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 685:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 68c:	eb 72                	jmp    700 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 68e:	c7 05 f0 09 00 00 f4 	movl   $0x9f4,0x9f0
 695:	09 00 00 
 698:	c7 05 f4 09 00 00 f4 	movl   $0x9f4,0x9f4
 69f:	09 00 00 
    base.s.size = 0;
 6a2:	c7 05 f8 09 00 00 00 	movl   $0x0,0x9f8
 6a9:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ac:	b8 f4 09 00 00       	mov    $0x9f4,%eax
 6b1:	eb c4                	jmp    677 <malloc+0x2c>
      if(p->s.size == nunits)
 6b3:	39 cb                	cmp    %ecx,%ebx
 6b5:	74 1e                	je     6d5 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b7:	29 d9                	sub    %ebx,%ecx
 6b9:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6bc:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6bf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6c2:	89 15 f0 09 00 00    	mov    %edx,0x9f0
      return (void*)(p + 1);
 6c8:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6cb:	89 d0                	mov    %edx,%eax
 6cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d0:	5b                   	pop    %ebx
 6d1:	5e                   	pop    %esi
 6d2:	5f                   	pop    %edi
 6d3:	5d                   	pop    %ebp
 6d4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6d5:	8b 08                	mov    (%eax),%ecx
 6d7:	89 0a                	mov    %ecx,(%edx)
 6d9:	eb e7                	jmp    6c2 <malloc+0x77>
  hp->s.size = nu;
 6db:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6de:	83 ec 0c             	sub    $0xc,%esp
 6e1:	83 c0 08             	add    $0x8,%eax
 6e4:	50                   	push   %eax
 6e5:	e8 ef fe ff ff       	call   5d9 <free>
  return freep;
 6ea:	8b 15 f0 09 00 00    	mov    0x9f0,%edx
      if((p = morecore(nunits)) == 0)
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	85 d2                	test   %edx,%edx
 6f5:	74 d4                	je     6cb <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6f9:	8b 48 04             	mov    0x4(%eax),%ecx
 6fc:	39 d9                	cmp    %ebx,%ecx
 6fe:	73 b3                	jae    6b3 <malloc+0x68>
    if(p == freep)
 700:	89 c2                	mov    %eax,%edx
 702:	39 05 f0 09 00 00    	cmp    %eax,0x9f0
 708:	75 ed                	jne    6f7 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 70a:	83 ec 0c             	sub    $0xc,%esp
 70d:	57                   	push   %edi
 70e:	e8 3c fc ff ff       	call   34f <sbrk>
  if(p == (char*)-1)
 713:	83 c4 10             	add    $0x10,%esp
 716:	83 f8 ff             	cmp    $0xffffffff,%eax
 719:	75 c0                	jne    6db <malloc+0x90>
        return 0;
 71b:	ba 00 00 00 00       	mov    $0x0,%edx
 720:	eb a9                	jmp    6cb <malloc+0x80>
