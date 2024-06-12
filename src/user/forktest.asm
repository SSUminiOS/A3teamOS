
user/_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <print>:

#define N  1000

void
print(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 26 01 00 00       	call   136 <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	push   0x8(%ebp)
  18:	e8 b2 02 00 00       	call   2cf <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  print(1, "fork test\n");
  2c:	68 f0 06 00 00       	push   $0x6f0
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <print>
  38:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
  40:	e8 62 02 00 00       	call   2a7 <fork>
    if(pid < 0)
  45:	85 c0                	test   %eax,%eax
  47:	78 2b                	js     74 <forktest+0x4f>
      break;
    if(pid == 0)
  49:	74 24                	je     6f <forktest+0x4a>
  for(n=0; n<N; n++){
  4b:	83 c3 01             	add    $0x1,%ebx
  4e:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  54:	75 ea                	jne    40 <forktest+0x1b>
      exit();
  }

  if(n == N){
    print(1, "fork claimed to work N times!\n", N);
  56:	83 ec 04             	sub    $0x4,%esp
  59:	68 e8 03 00 00       	push   $0x3e8
  5e:	68 30 07 00 00       	push   $0x730
  63:	6a 01                	push   $0x1
  65:	e8 96 ff ff ff       	call   0 <print>
    exit();
  6a:	e8 40 02 00 00       	call   2af <exit>
      exit();
  6f:	e8 3b 02 00 00       	call   2af <exit>
  if(n == N){
  74:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  7a:	74 da                	je     56 <forktest+0x31>
  }

  for(; n > 0; n--){
  7c:	85 db                	test   %ebx,%ebx
  7e:	7e 0e                	jle    8e <forktest+0x69>
    if(wait() < 0){
  80:	e8 32 02 00 00       	call   2b7 <wait>
  85:	85 c0                	test   %eax,%eax
  87:	78 26                	js     af <forktest+0x8a>
  for(; n > 0; n--){
  89:	83 eb 01             	sub    $0x1,%ebx
  8c:	75 f2                	jne    80 <forktest+0x5b>
      print(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  8e:	e8 24 02 00 00       	call   2b7 <wait>
  93:	83 f8 ff             	cmp    $0xffffffff,%eax
  96:	75 2b                	jne    c3 <forktest+0x9e>
    print(1, "wait got too many\n");
    exit();
  }

  print(1, "fork test OK\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 22 07 00 00       	push   $0x722
  a0:	6a 01                	push   $0x1
  a2:	e8 59 ff ff ff       	call   0 <print>
}
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ad:	c9                   	leave  
  ae:	c3                   	ret    
      print(1, "wait stopped early\n");
  af:	83 ec 08             	sub    $0x8,%esp
  b2:	68 fb 06 00 00       	push   $0x6fb
  b7:	6a 01                	push   $0x1
  b9:	e8 42 ff ff ff       	call   0 <print>
      exit();
  be:	e8 ec 01 00 00       	call   2af <exit>
    print(1, "wait got too many\n");
  c3:	83 ec 08             	sub    $0x8,%esp
  c6:	68 0f 07 00 00       	push   $0x70f
  cb:	6a 01                	push   $0x1
  cd:	e8 2e ff ff ff       	call   0 <print>
    exit();
  d2:	e8 d8 01 00 00       	call   2af <exit>

000000d7 <main>:

int
main(void)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
  dd:	e8 43 ff ff ff       	call   25 <forktest>
  exit();
  e2:	e8 c8 01 00 00       	call   2af <exit>

000000e7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	53                   	push   %ebx
  eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f1:	b8 00 00 00 00       	mov    $0x0,%eax
  f6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  fa:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  fd:	83 c0 01             	add    $0x1,%eax
 100:	84 d2                	test   %dl,%dl
 102:	75 f2                	jne    f6 <strcpy+0xf>
    ;
  return os;
}
 104:	89 c8                	mov    %ecx,%eax
 106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 109:	c9                   	leave  
 10a:	c3                   	ret    

0000010b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 111:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 114:	0f b6 01             	movzbl (%ecx),%eax
 117:	84 c0                	test   %al,%al
 119:	74 11                	je     12c <strcmp+0x21>
 11b:	38 02                	cmp    %al,(%edx)
 11d:	75 0d                	jne    12c <strcmp+0x21>
    p++, q++;
 11f:	83 c1 01             	add    $0x1,%ecx
 122:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 125:	0f b6 01             	movzbl (%ecx),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 ef                	jne    11b <strcmp+0x10>
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
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 13c:	80 3a 00             	cmpb   $0x0,(%edx)
 13f:	74 14                	je     155 <strlen+0x1f>
 141:	b8 00 00 00 00       	mov    $0x0,%eax
 146:	83 c0 01             	add    $0x1,%eax
 149:	89 c1                	mov    %eax,%ecx
 14b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 14f:	75 f5                	jne    146 <strlen+0x10>
    ;
  return n;
}
 151:	89 c8                	mov    %ecx,%eax
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    
  for(n = 0; s[n]; n++)
 155:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 15a:	eb f5                	jmp    151 <strlen+0x1b>

0000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	57                   	push   %edi
 160:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 163:	89 d7                	mov    %edx,%edi
 165:	8b 4d 10             	mov    0x10(%ebp),%ecx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	fc                   	cld    
 16c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 16e:	89 d0                	mov    %edx,%eax
 170:	8b 7d fc             	mov    -0x4(%ebp),%edi
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <strchr>:

char*
strchr(const char *s, char c)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	84 d2                	test   %dl,%dl
 184:	74 15                	je     19b <strchr+0x26>
    if(*s == c)
 186:	38 d1                	cmp    %dl,%cl
 188:	74 0f                	je     199 <strchr+0x24>
  for(; *s; s++)
 18a:	83 c0 01             	add    $0x1,%eax
 18d:	0f b6 10             	movzbl (%eax),%edx
 190:	84 d2                	test   %dl,%dl
 192:	75 f2                	jne    186 <strchr+0x11>
      return (char*)s;
  return 0;
 194:	b8 00 00 00 00       	mov    $0x0,%eax
}
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
  return 0;
 19b:	b8 00 00 00 00       	mov    $0x0,%eax
 1a0:	eb f7                	jmp    199 <strchr+0x24>

000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	57                   	push   %edi
 1a6:	56                   	push   %esi
 1a7:	53                   	push   %ebx
 1a8:	83 ec 2c             	sub    $0x2c,%esp
 1ab:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ae:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1b3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1b6:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7d 27                	jge    1e8 <gets+0x46>
    cc = read(0, &c, 1);
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	6a 01                	push   $0x1
 1c6:	57                   	push   %edi
 1c7:	6a 00                	push   $0x0
 1c9:	e8 f9 00 00 00       	call   2c7 <read>
    if(cc < 1)
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	85 c0                	test   %eax,%eax
 1d3:	7e 13                	jle    1e8 <gets+0x46>
      break;
    buf[i++] = c;
 1d5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d9:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 1dd:	3c 0a                	cmp    $0xa,%al
 1df:	74 04                	je     1e5 <gets+0x43>
 1e1:	3c 0d                	cmp    $0xd,%al
 1e3:	75 d1                	jne    1b6 <gets+0x14>
  for(i=0; i+1 < max; ){
 1e5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 1e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1eb:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 1ef:	89 f0                	mov    %esi,%eax
 1f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f4:	5b                   	pop    %ebx
 1f5:	5e                   	pop    %esi
 1f6:	5f                   	pop    %edi
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	56                   	push   %esi
 1fd:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	6a 00                	push   $0x0
 203:	ff 75 08             	push   0x8(%ebp)
 206:	e8 e4 00 00 00       	call   2ef <open>
  if(fd < 0)
 20b:	83 c4 10             	add    $0x10,%esp
 20e:	85 c0                	test   %eax,%eax
 210:	78 24                	js     236 <stat+0x3d>
 212:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	ff 75 0c             	push   0xc(%ebp)
 21a:	50                   	push   %eax
 21b:	e8 e7 00 00 00       	call   307 <fstat>
 220:	89 c6                	mov    %eax,%esi
  close(fd);
 222:	89 1c 24             	mov    %ebx,(%esp)
 225:	e8 ad 00 00 00       	call   2d7 <close>
  return r;
 22a:	83 c4 10             	add    $0x10,%esp
}
 22d:	89 f0                	mov    %esi,%eax
 22f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5d                   	pop    %ebp
 235:	c3                   	ret    
    return -1;
 236:	be ff ff ff ff       	mov    $0xffffffff,%esi
 23b:	eb f0                	jmp    22d <stat+0x34>

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	53                   	push   %ebx
 241:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 244:	0f b6 02             	movzbl (%edx),%eax
 247:	8d 48 d0             	lea    -0x30(%eax),%ecx
 24a:	80 f9 09             	cmp    $0x9,%cl
 24d:	77 24                	ja     273 <atoi+0x36>
  n = 0;
 24f:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 254:	83 c2 01             	add    $0x1,%edx
 257:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 25a:	0f be c0             	movsbl %al,%eax
 25d:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 261:	0f b6 02             	movzbl (%edx),%eax
 264:	8d 58 d0             	lea    -0x30(%eax),%ebx
 267:	80 fb 09             	cmp    $0x9,%bl
 26a:	76 e8                	jbe    254 <atoi+0x17>
  return n;
}
 26c:	89 c8                	mov    %ecx,%eax
 26e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 271:	c9                   	leave  
 272:	c3                   	ret    
  n = 0;
 273:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 278:	eb f2                	jmp    26c <atoi+0x2f>

0000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	56                   	push   %esi
 27e:	53                   	push   %ebx
 27f:	8b 75 08             	mov    0x8(%ebp),%esi
 282:	8b 55 0c             	mov    0xc(%ebp),%edx
 285:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 288:	85 db                	test   %ebx,%ebx
 28a:	7e 15                	jle    2a1 <memmove+0x27>
 28c:	01 f3                	add    %esi,%ebx
  dst = vdst;
 28e:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 290:	83 c2 01             	add    $0x1,%edx
 293:	83 c0 01             	add    $0x1,%eax
 296:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 29a:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 29d:	39 c3                	cmp    %eax,%ebx
 29f:	75 ef                	jne    290 <memmove+0x16>
  return vdst;
}
 2a1:	89 f0                	mov    %esi,%eax
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    

000002a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <exit>:
SYSCALL(exit)
 2af:	b8 02 00 00 00       	mov    $0x2,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <wait>:
SYSCALL(wait)
 2b7:	b8 03 00 00 00       	mov    $0x3,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <pipe>:
SYSCALL(pipe)
 2bf:	b8 04 00 00 00       	mov    $0x4,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <read>:
SYSCALL(read)
 2c7:	b8 05 00 00 00       	mov    $0x5,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <write>:
SYSCALL(write)
 2cf:	b8 10 00 00 00       	mov    $0x10,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <close>:
SYSCALL(close)
 2d7:	b8 15 00 00 00       	mov    $0x15,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <kill>:
SYSCALL(kill)
 2df:	b8 06 00 00 00       	mov    $0x6,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exec>:
SYSCALL(exec)
 2e7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <open>:
SYSCALL(open)
 2ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <mknod>:
SYSCALL(mknod)
 2f7:	b8 11 00 00 00       	mov    $0x11,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <unlink>:
SYSCALL(unlink)
 2ff:	b8 12 00 00 00       	mov    $0x12,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <fstat>:
SYSCALL(fstat)
 307:	b8 08 00 00 00       	mov    $0x8,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <link>:
SYSCALL(link)
 30f:	b8 13 00 00 00       	mov    $0x13,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mkdir>:
SYSCALL(mkdir)
 317:	b8 14 00 00 00       	mov    $0x14,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <chdir>:
SYSCALL(chdir)
 31f:	b8 09 00 00 00       	mov    $0x9,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <dup>:
SYSCALL(dup)
 327:	b8 0a 00 00 00       	mov    $0xa,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <getpid>:
SYSCALL(getpid)
 32f:	b8 0b 00 00 00       	mov    $0xb,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sbrk>:
SYSCALL(sbrk)
 337:	b8 0c 00 00 00       	mov    $0xc,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <sleep>:
SYSCALL(sleep)
 33f:	b8 0d 00 00 00       	mov    $0xd,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <uptime>:
SYSCALL(uptime)
 347:	b8 0e 00 00 00       	mov    $0xe,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <slabtest>:
SYSCALL(slabtest)
 34f:	b8 16 00 00 00       	mov    $0x16,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <ps>:
SYSCALL(ps)
 357:	b8 17 00 00 00       	mov    $0x17,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	57                   	push   %edi
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	83 ec 3c             	sub    $0x3c,%esp
 368:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 36b:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 371:	74 79                	je     3ec <printint+0x8d>
 373:	85 d2                	test   %edx,%edx
 375:	79 75                	jns    3ec <printint+0x8d>
    neg = 1;
    x = -xx;
 377:	89 d1                	mov    %edx,%ecx
 379:	f7 d9                	neg    %ecx
    neg = 1;
 37b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 382:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 387:	89 df                	mov    %ebx,%edi
 389:	83 c3 01             	add    $0x1,%ebx
 38c:	89 c8                	mov    %ecx,%eax
 38e:	ba 00 00 00 00       	mov    $0x0,%edx
 393:	f7 f6                	div    %esi
 395:	0f b6 92 b0 07 00 00 	movzbl 0x7b0(%edx),%edx
 39c:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3a0:	89 ca                	mov    %ecx,%edx
 3a2:	89 c1                	mov    %eax,%ecx
 3a4:	39 d6                	cmp    %edx,%esi
 3a6:	76 df                	jbe    387 <printint+0x28>
  if(neg)
 3a8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3ac:	74 08                	je     3b6 <printint+0x57>
    buf[i++] = '-';
 3ae:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b3:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3b6:	85 db                	test   %ebx,%ebx
 3b8:	7e 2a                	jle    3e4 <printint+0x85>
 3ba:	8d 7d d8             	lea    -0x28(%ebp),%edi
 3bd:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 3c1:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3c4:	0f b6 03             	movzbl (%ebx),%eax
 3c7:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3ca:	83 ec 04             	sub    $0x4,%esp
 3cd:	6a 01                	push   $0x1
 3cf:	56                   	push   %esi
 3d0:	ff 75 c4             	push   -0x3c(%ebp)
 3d3:	e8 f7 fe ff ff       	call   2cf <write>
  while(--i >= 0)
 3d8:	89 d8                	mov    %ebx,%eax
 3da:	83 eb 01             	sub    $0x1,%ebx
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	39 f8                	cmp    %edi,%eax
 3e2:	75 e0                	jne    3c4 <printint+0x65>
}
 3e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e7:	5b                   	pop    %ebx
 3e8:	5e                   	pop    %esi
 3e9:	5f                   	pop    %edi
 3ea:	5d                   	pop    %ebp
 3eb:	c3                   	ret    
    x = xx;
 3ec:	89 d1                	mov    %edx,%ecx
  neg = 0;
 3ee:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3f5:	eb 8b                	jmp    382 <printint+0x23>

000003f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	57                   	push   %edi
 3fb:	56                   	push   %esi
 3fc:	53                   	push   %ebx
 3fd:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 400:	8b 75 0c             	mov    0xc(%ebp),%esi
 403:	0f b6 1e             	movzbl (%esi),%ebx
 406:	84 db                	test   %bl,%bl
 408:	0f 84 9f 01 00 00    	je     5ad <printf+0x1b6>
 40e:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 411:	8d 45 10             	lea    0x10(%ebp),%eax
 414:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 417:	bf 00 00 00 00       	mov    $0x0,%edi
 41c:	eb 2d                	jmp    44b <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 41e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 421:	83 ec 04             	sub    $0x4,%esp
 424:	6a 01                	push   $0x1
 426:	8d 45 e7             	lea    -0x19(%ebp),%eax
 429:	50                   	push   %eax
 42a:	ff 75 08             	push   0x8(%ebp)
 42d:	e8 9d fe ff ff       	call   2cf <write>
        putc(fd, c);
 432:	83 c4 10             	add    $0x10,%esp
 435:	eb 05                	jmp    43c <printf+0x45>
      }
    } else if(state == '%'){
 437:	83 ff 25             	cmp    $0x25,%edi
 43a:	74 1f                	je     45b <printf+0x64>
  for(i = 0; fmt[i]; i++){
 43c:	83 c6 01             	add    $0x1,%esi
 43f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 443:	84 db                	test   %bl,%bl
 445:	0f 84 62 01 00 00    	je     5ad <printf+0x1b6>
    c = fmt[i] & 0xff;
 44b:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44e:	85 ff                	test   %edi,%edi
 450:	75 e5                	jne    437 <printf+0x40>
      if(c == '%'){
 452:	83 f8 25             	cmp    $0x25,%eax
 455:	75 c7                	jne    41e <printf+0x27>
        state = '%';
 457:	89 c7                	mov    %eax,%edi
 459:	eb e1                	jmp    43c <printf+0x45>
      if(c == 'd'){
 45b:	83 f8 25             	cmp    $0x25,%eax
 45e:	0f 84 f2 00 00 00    	je     556 <printf+0x15f>
 464:	8d 50 9d             	lea    -0x63(%eax),%edx
 467:	83 fa 15             	cmp    $0x15,%edx
 46a:	0f 87 07 01 00 00    	ja     577 <printf+0x180>
 470:	0f 87 01 01 00 00    	ja     577 <printf+0x180>
 476:	ff 24 95 58 07 00 00 	jmp    *0x758(,%edx,4)
        printint(fd, *ap, 10, 1);
 47d:	83 ec 0c             	sub    $0xc,%esp
 480:	6a 01                	push   $0x1
 482:	b9 0a 00 00 00       	mov    $0xa,%ecx
 487:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48a:	8b 17                	mov    (%edi),%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 cb fe ff ff       	call   35f <printint>
        ap++;
 494:	89 f8                	mov    %edi,%eax
 496:	83 c0 04             	add    $0x4,%eax
 499:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 49c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 49f:	bf 00 00 00 00       	mov    $0x0,%edi
 4a4:	eb 96                	jmp    43c <printf+0x45>
        printint(fd, *ap, 16, 0);
 4a6:	83 ec 0c             	sub    $0xc,%esp
 4a9:	6a 00                	push   $0x0
 4ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b3:	8b 17                	mov    (%edi),%edx
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	e8 a2 fe ff ff       	call   35f <printint>
        ap++;
 4bd:	89 f8                	mov    %edi,%eax
 4bf:	83 c0 04             	add    $0x4,%eax
 4c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c8:	bf 00 00 00 00       	mov    $0x0,%edi
 4cd:	e9 6a ff ff ff       	jmp    43c <printf+0x45>
        s = (char*)*ap;
 4d2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4d5:	8b 01                	mov    (%ecx),%eax
        ap++;
 4d7:	83 c1 04             	add    $0x4,%ecx
 4da:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4dd:	85 c0                	test   %eax,%eax
 4df:	74 13                	je     4f4 <printf+0xfd>
        s = (char*)*ap;
 4e1:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4e3:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4e6:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4eb:	84 c0                	test   %al,%al
 4ed:	75 0f                	jne    4fe <printf+0x107>
 4ef:	e9 48 ff ff ff       	jmp    43c <printf+0x45>
          s = "(null)";
 4f4:	bb 4f 07 00 00       	mov    $0x74f,%ebx
        while(*s != 0){
 4f9:	b8 28 00 00 00       	mov    $0x28,%eax
 4fe:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 501:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 504:	83 ec 04             	sub    $0x4,%esp
 507:	6a 01                	push   $0x1
 509:	8d 45 e7             	lea    -0x19(%ebp),%eax
 50c:	50                   	push   %eax
 50d:	57                   	push   %edi
 50e:	e8 bc fd ff ff       	call   2cf <write>
          s++;
 513:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 516:	0f b6 03             	movzbl (%ebx),%eax
 519:	83 c4 10             	add    $0x10,%esp
 51c:	84 c0                	test   %al,%al
 51e:	75 e1                	jne    501 <printf+0x10a>
      state = 0;
 520:	bf 00 00 00 00       	mov    $0x0,%edi
 525:	e9 12 ff ff ff       	jmp    43c <printf+0x45>
        putc(fd, *ap);
 52a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52d:	8b 07                	mov    (%edi),%eax
 52f:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 532:	83 ec 04             	sub    $0x4,%esp
 535:	6a 01                	push   $0x1
 537:	8d 45 e7             	lea    -0x19(%ebp),%eax
 53a:	50                   	push   %eax
 53b:	ff 75 08             	push   0x8(%ebp)
 53e:	e8 8c fd ff ff       	call   2cf <write>
        ap++;
 543:	83 c7 04             	add    $0x4,%edi
 546:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 549:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54c:	bf 00 00 00 00       	mov    $0x0,%edi
 551:	e9 e6 fe ff ff       	jmp    43c <printf+0x45>
        putc(fd, c);
 556:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	6a 01                	push   $0x1
 55e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 561:	50                   	push   %eax
 562:	ff 75 08             	push   0x8(%ebp)
 565:	e8 65 fd ff ff       	call   2cf <write>
 56a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56d:	bf 00 00 00 00       	mov    $0x0,%edi
 572:	e9 c5 fe ff ff       	jmp    43c <printf+0x45>
        putc(fd, '%');
 577:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	6a 01                	push   $0x1
 580:	8d 45 e7             	lea    -0x19(%ebp),%eax
 583:	50                   	push   %eax
 584:	ff 75 08             	push   0x8(%ebp)
 587:	e8 43 fd ff ff       	call   2cf <write>
        putc(fd, c);
 58c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 58f:	83 c4 0c             	add    $0xc,%esp
 592:	6a 01                	push   $0x1
 594:	8d 45 e7             	lea    -0x19(%ebp),%eax
 597:	50                   	push   %eax
 598:	ff 75 08             	push   0x8(%ebp)
 59b:	e8 2f fd ff ff       	call   2cf <write>
        putc(fd, c);
 5a0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a3:	bf 00 00 00 00       	mov    $0x0,%edi
 5a8:	e9 8f fe ff ff       	jmp    43c <printf+0x45>
    }
  }
}
 5ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5f                   	pop    %edi
 5b3:	5d                   	pop    %ebp
 5b4:	c3                   	ret    

000005b5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 5c6:	eb 0c                	jmp    5d4 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c8:	8b 10                	mov    (%eax),%edx
 5ca:	39 c2                	cmp    %eax,%edx
 5cc:	77 04                	ja     5d2 <free+0x1d>
 5ce:	39 ca                	cmp    %ecx,%edx
 5d0:	77 10                	ja     5e2 <free+0x2d>
{
 5d2:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d4:	39 c8                	cmp    %ecx,%eax
 5d6:	73 f0                	jae    5c8 <free+0x13>
 5d8:	8b 10                	mov    (%eax),%edx
 5da:	39 ca                	cmp    %ecx,%edx
 5dc:	77 04                	ja     5e2 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5de:	39 c2                	cmp    %eax,%edx
 5e0:	77 f0                	ja     5d2 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e2:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e5:	8b 10                	mov    (%eax),%edx
 5e7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ea:	39 fa                	cmp    %edi,%edx
 5ec:	74 19                	je     607 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5ee:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5f1:	8b 50 04             	mov    0x4(%eax),%edx
 5f4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f7:	39 f1                	cmp    %esi,%ecx
 5f9:	74 18                	je     613 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5fb:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 5fd:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 602:	5b                   	pop    %ebx
 603:	5e                   	pop    %esi
 604:	5f                   	pop    %edi
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 607:	03 72 04             	add    0x4(%edx),%esi
 60a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60d:	8b 10                	mov    (%eax),%edx
 60f:	8b 12                	mov    (%edx),%edx
 611:	eb db                	jmp    5ee <free+0x39>
    p->s.size += bp->s.size;
 613:	03 53 fc             	add    -0x4(%ebx),%edx
 616:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 619:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 61c:	eb dd                	jmp    5fb <free+0x46>

0000061e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 61e:	55                   	push   %ebp
 61f:	89 e5                	mov    %esp,%ebp
 621:	57                   	push   %edi
 622:	56                   	push   %esi
 623:	53                   	push   %ebx
 624:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	8d 58 07             	lea    0x7(%eax),%ebx
 62d:	c1 eb 03             	shr    $0x3,%ebx
 630:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 633:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
 639:	85 d2                	test   %edx,%edx
 63b:	74 1c                	je     659 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63f:	8b 48 04             	mov    0x4(%eax),%ecx
 642:	39 cb                	cmp    %ecx,%ebx
 644:	76 38                	jbe    67e <malloc+0x60>
 646:	be 00 10 00 00       	mov    $0x1000,%esi
 64b:	39 f3                	cmp    %esi,%ebx
 64d:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 650:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 657:	eb 72                	jmp    6cb <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 659:	c7 05 5c 0a 00 00 60 	movl   $0xa60,0xa5c
 660:	0a 00 00 
 663:	c7 05 60 0a 00 00 60 	movl   $0xa60,0xa60
 66a:	0a 00 00 
    base.s.size = 0;
 66d:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 674:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 677:	b8 60 0a 00 00       	mov    $0xa60,%eax
 67c:	eb c8                	jmp    646 <malloc+0x28>
      if(p->s.size == nunits)
 67e:	39 cb                	cmp    %ecx,%ebx
 680:	74 1e                	je     6a0 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 682:	29 d9                	sub    %ebx,%ecx
 684:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 687:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 68a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 68d:	89 15 5c 0a 00 00    	mov    %edx,0xa5c
      return (void*)(p + 1);
 693:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 696:	89 d0                	mov    %edx,%eax
 698:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	5f                   	pop    %edi
 69e:	5d                   	pop    %ebp
 69f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6a0:	8b 08                	mov    (%eax),%ecx
 6a2:	89 0a                	mov    %ecx,(%edx)
 6a4:	eb e7                	jmp    68d <malloc+0x6f>
  hp->s.size = nu;
 6a6:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6a9:	83 ec 0c             	sub    $0xc,%esp
 6ac:	83 c0 08             	add    $0x8,%eax
 6af:	50                   	push   %eax
 6b0:	e8 00 ff ff ff       	call   5b5 <free>
  return freep;
 6b5:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
      if((p = morecore(nunits)) == 0)
 6bb:	83 c4 10             	add    $0x10,%esp
 6be:	85 d2                	test   %edx,%edx
 6c0:	74 d4                	je     696 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c4:	8b 48 04             	mov    0x4(%eax),%ecx
 6c7:	39 d9                	cmp    %ebx,%ecx
 6c9:	73 b3                	jae    67e <malloc+0x60>
    if(p == freep)
 6cb:	89 c2                	mov    %eax,%edx
 6cd:	39 05 5c 0a 00 00    	cmp    %eax,0xa5c
 6d3:	75 ed                	jne    6c2 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	57                   	push   %edi
 6d9:	e8 59 fc ff ff       	call   337 <sbrk>
  if(p == (char*)-1)
 6de:	83 c4 10             	add    $0x10,%esp
 6e1:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e4:	75 c0                	jne    6a6 <malloc+0x88>
        return 0;
 6e6:	ba 00 00 00 00       	mov    $0x0,%edx
 6eb:	eb a9                	jmp    696 <malloc+0x78>
