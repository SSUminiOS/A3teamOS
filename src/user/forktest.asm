
user/_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <print>:

#define N  1000

void
print(int fd, const char *s, ...)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 10             	sub    $0x10,%esp
   b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   e:	53                   	push   %ebx
   f:	e8 34 01 00 00       	call   148 <strlen>
  14:	83 c4 0c             	add    $0xc,%esp
  17:	50                   	push   %eax
  18:	53                   	push   %ebx
  19:	ff 75 08             	pushl  0x8(%ebp)
  1c:	e8 d8 02 00 00       	call   2f9 <write>
}
  21:	83 c4 10             	add    $0x10,%esp
  24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	f3 0f 1e fb          	endbr32 
  2d:	55                   	push   %ebp
  2e:	89 e5                	mov    %esp,%ebp
  30:	53                   	push   %ebx
  31:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  print(1, "fork test\n");
  34:	68 34 07 00 00       	push   $0x734
  39:	6a 01                	push   $0x1
  3b:	e8 c0 ff ff ff       	call   0 <print>
  40:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  43:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
  48:	e8 84 02 00 00       	call   2d1 <fork>
    if(pid < 0)
  4d:	85 c0                	test   %eax,%eax
  4f:	78 2b                	js     7c <forktest+0x53>
      break;
    if(pid == 0)
  51:	74 24                	je     77 <forktest+0x4e>
  for(n=0; n<N; n++){
  53:	83 c3 01             	add    $0x1,%ebx
  56:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  5c:	75 ea                	jne    48 <forktest+0x1f>
      exit();
  }

  if(n == N){
    print(1, "fork claimed to work N times!\n", N);
  5e:	83 ec 04             	sub    $0x4,%esp
  61:	68 e8 03 00 00       	push   $0x3e8
  66:	68 74 07 00 00       	push   $0x774
  6b:	6a 01                	push   $0x1
  6d:	e8 8e ff ff ff       	call   0 <print>
    exit();
  72:	e8 62 02 00 00       	call   2d9 <exit>
      exit();
  77:	e8 5d 02 00 00       	call   2d9 <exit>
  if(n == N){
  7c:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  82:	74 da                	je     5e <forktest+0x35>
  }

  for(; n > 0; n--){
  84:	85 db                	test   %ebx,%ebx
  86:	7e 0e                	jle    96 <forktest+0x6d>
    if(wait() < 0){
  88:	e8 54 02 00 00       	call   2e1 <wait>
  8d:	85 c0                	test   %eax,%eax
  8f:	78 26                	js     b7 <forktest+0x8e>
  for(; n > 0; n--){
  91:	83 eb 01             	sub    $0x1,%ebx
  94:	75 f2                	jne    88 <forktest+0x5f>
      print(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  96:	e8 46 02 00 00       	call   2e1 <wait>
  9b:	83 f8 ff             	cmp    $0xffffffff,%eax
  9e:	75 2b                	jne    cb <forktest+0xa2>
    print(1, "wait got too many\n");
    exit();
  }

  print(1, "fork test OK\n");
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	68 66 07 00 00       	push   $0x766
  a8:	6a 01                	push   $0x1
  aa:	e8 51 ff ff ff       	call   0 <print>
}
  af:	83 c4 10             	add    $0x10,%esp
  b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b5:	c9                   	leave  
  b6:	c3                   	ret    
      print(1, "wait stopped early\n");
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 3f 07 00 00       	push   $0x73f
  bf:	6a 01                	push   $0x1
  c1:	e8 3a ff ff ff       	call   0 <print>
      exit();
  c6:	e8 0e 02 00 00       	call   2d9 <exit>
    print(1, "wait got too many\n");
  cb:	83 ec 08             	sub    $0x8,%esp
  ce:	68 53 07 00 00       	push   $0x753
  d3:	6a 01                	push   $0x1
  d5:	e8 26 ff ff ff       	call   0 <print>
    exit();
  da:	e8 fa 01 00 00       	call   2d9 <exit>

000000df <main>:

int
main(void)
{
  df:	f3 0f 1e fb          	endbr32 
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
  e9:	e8 3b ff ff ff       	call   29 <forktest>
  exit();
  ee:	e8 e6 01 00 00       	call   2d9 <exit>

000000f3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f3:	f3 0f 1e fb          	endbr32 
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	53                   	push   %ebx
  fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 101:	b8 00 00 00 00       	mov    $0x0,%eax
 106:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 10a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 10d:	83 c0 01             	add    $0x1,%eax
 110:	84 d2                	test   %dl,%dl
 112:	75 f2                	jne    106 <strcpy+0x13>
    ;
  return os;
}
 114:	89 c8                	mov    %ecx,%eax
 116:	5b                   	pop    %ebx
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 119:	f3 0f 1e fb          	endbr32 
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	8b 4d 08             	mov    0x8(%ebp),%ecx
 123:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 126:	0f b6 01             	movzbl (%ecx),%eax
 129:	84 c0                	test   %al,%al
 12b:	74 11                	je     13e <strcmp+0x25>
 12d:	38 02                	cmp    %al,(%edx)
 12f:	75 0d                	jne    13e <strcmp+0x25>
    p++, q++;
 131:	83 c1 01             	add    $0x1,%ecx
 134:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	75 ef                	jne    12d <strcmp+0x14>
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
 148:	f3 0f 1e fb          	endbr32 
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 152:	80 3a 00             	cmpb   $0x0,(%edx)
 155:	74 14                	je     16b <strlen+0x23>
 157:	b8 00 00 00 00       	mov    $0x0,%eax
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	89 c1                	mov    %eax,%ecx
 161:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 165:	75 f5                	jne    15c <strlen+0x14>
    ;
  return n;
}
 167:	89 c8                	mov    %ecx,%eax
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    
  for(n = 0; s[n]; n++)
 16b:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 170:	eb f5                	jmp    167 <strlen+0x1f>

00000172 <memset>:

void*
memset(void *dst, int c, uint n)
{
 172:	f3 0f 1e fb          	endbr32 
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	57                   	push   %edi
 17a:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 17d:	89 d7                	mov    %edx,%edi
 17f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	fc                   	cld    
 186:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 188:	89 d0                	mov    %edx,%eax
 18a:	5f                   	pop    %edi
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    

0000018d <strchr>:

char*
strchr(const char *s, char c)
{
 18d:	f3 0f 1e fb          	endbr32 
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	84 d2                	test   %dl,%dl
 1a0:	74 15                	je     1b7 <strchr+0x2a>
    if(*s == c)
 1a2:	38 d1                	cmp    %dl,%cl
 1a4:	74 0f                	je     1b5 <strchr+0x28>
  for(; *s; s++)
 1a6:	83 c0 01             	add    $0x1,%eax
 1a9:	0f b6 10             	movzbl (%eax),%edx
 1ac:	84 d2                	test   %dl,%dl
 1ae:	75 f2                	jne    1a2 <strchr+0x15>
      return (char*)s;
  return 0;
 1b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
  return 0;
 1b7:	b8 00 00 00 00       	mov    $0x0,%eax
 1bc:	eb f7                	jmp    1b5 <strchr+0x28>

000001be <gets>:

char*
gets(char *buf, int max)
{
 1be:	f3 0f 1e fb          	endbr32 
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	57                   	push   %edi
 1c6:	56                   	push   %esi
 1c7:	53                   	push   %ebx
 1c8:	83 ec 2c             	sub    $0x2c,%esp
 1cb:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1d3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1d6:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1d9:	83 c3 01             	add    $0x1,%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7d 27                	jge    208 <gets+0x4a>
    cc = read(0, &c, 1);
 1e1:	83 ec 04             	sub    $0x4,%esp
 1e4:	6a 01                	push   $0x1
 1e6:	57                   	push   %edi
 1e7:	6a 00                	push   $0x0
 1e9:	e8 03 01 00 00       	call   2f1 <read>
    if(cc < 1)
 1ee:	83 c4 10             	add    $0x10,%esp
 1f1:	85 c0                	test   %eax,%eax
 1f3:	7e 13                	jle    208 <gets+0x4a>
      break;
    buf[i++] = c;
 1f5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f9:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 1fd:	3c 0a                	cmp    $0xa,%al
 1ff:	74 04                	je     205 <gets+0x47>
 201:	3c 0d                	cmp    $0xd,%al
 203:	75 d1                	jne    1d6 <gets+0x18>
  for(i=0; i+1 < max; ){
 205:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 20b:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 20f:	89 f0                	mov    %esi,%eax
 211:	8d 65 f4             	lea    -0xc(%ebp),%esp
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    

00000219 <stat>:

int
stat(const char *n, struct stat *st)
{
 219:	f3 0f 1e fb          	endbr32 
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	56                   	push   %esi
 221:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	83 ec 08             	sub    $0x8,%esp
 225:	6a 00                	push   $0x0
 227:	ff 75 08             	pushl  0x8(%ebp)
 22a:	e8 ea 00 00 00       	call   319 <open>
  if(fd < 0)
 22f:	83 c4 10             	add    $0x10,%esp
 232:	85 c0                	test   %eax,%eax
 234:	78 24                	js     25a <stat+0x41>
 236:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 238:	83 ec 08             	sub    $0x8,%esp
 23b:	ff 75 0c             	pushl  0xc(%ebp)
 23e:	50                   	push   %eax
 23f:	e8 ed 00 00 00       	call   331 <fstat>
 244:	89 c6                	mov    %eax,%esi
  close(fd);
 246:	89 1c 24             	mov    %ebx,(%esp)
 249:	e8 b3 00 00 00       	call   301 <close>
  return r;
 24e:	83 c4 10             	add    $0x10,%esp
}
 251:	89 f0                	mov    %esi,%eax
 253:	8d 65 f8             	lea    -0x8(%ebp),%esp
 256:	5b                   	pop    %ebx
 257:	5e                   	pop    %esi
 258:	5d                   	pop    %ebp
 259:	c3                   	ret    
    return -1;
 25a:	be ff ff ff ff       	mov    $0xffffffff,%esi
 25f:	eb f0                	jmp    251 <stat+0x38>

00000261 <atoi>:

int
atoi(const char *s)
{
 261:	f3 0f 1e fb          	endbr32 
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	53                   	push   %ebx
 269:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26c:	0f b6 02             	movzbl (%edx),%eax
 26f:	8d 48 d0             	lea    -0x30(%eax),%ecx
 272:	80 f9 09             	cmp    $0x9,%cl
 275:	77 22                	ja     299 <atoi+0x38>
  n = 0;
 277:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 27c:	83 c2 01             	add    $0x1,%edx
 27f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 282:	0f be c0             	movsbl %al,%eax
 285:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 289:	0f b6 02             	movzbl (%edx),%eax
 28c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 28f:	80 fb 09             	cmp    $0x9,%bl
 292:	76 e8                	jbe    27c <atoi+0x1b>
  return n;
}
 294:	89 c8                	mov    %ecx,%eax
 296:	5b                   	pop    %ebx
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    
  n = 0;
 299:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 29e:	eb f4                	jmp    294 <atoi+0x33>

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	56                   	push   %esi
 2a8:	53                   	push   %ebx
 2a9:	8b 75 08             	mov    0x8(%ebp),%esi
 2ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 2af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	85 db                	test   %ebx,%ebx
 2b4:	7e 15                	jle    2cb <memmove+0x2b>
 2b6:	01 f3                	add    %esi,%ebx
  dst = vdst;
 2b8:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 2ba:	83 c2 01             	add    $0x1,%edx
 2bd:	83 c0 01             	add    $0x1,%eax
 2c0:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2c4:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 2c7:	39 c3                	cmp    %eax,%ebx
 2c9:	75 ef                	jne    2ba <memmove+0x1a>
  return vdst;
}
 2cb:	89 f0                	mov    %esi,%eax
 2cd:	5b                   	pop    %ebx
 2ce:	5e                   	pop    %esi
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    

000002d1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d1:	b8 01 00 00 00       	mov    $0x1,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <exit>:
SYSCALL(exit)
 2d9:	b8 02 00 00 00       	mov    $0x2,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <wait>:
SYSCALL(wait)
 2e1:	b8 03 00 00 00       	mov    $0x3,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <pipe>:
SYSCALL(pipe)
 2e9:	b8 04 00 00 00       	mov    $0x4,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <read>:
SYSCALL(read)
 2f1:	b8 05 00 00 00       	mov    $0x5,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <write>:
SYSCALL(write)
 2f9:	b8 10 00 00 00       	mov    $0x10,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <close>:
SYSCALL(close)
 301:	b8 15 00 00 00       	mov    $0x15,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <kill>:
SYSCALL(kill)
 309:	b8 06 00 00 00       	mov    $0x6,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <exec>:
SYSCALL(exec)
 311:	b8 07 00 00 00       	mov    $0x7,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <open>:
SYSCALL(open)
 319:	b8 0f 00 00 00       	mov    $0xf,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <mknod>:
SYSCALL(mknod)
 321:	b8 11 00 00 00       	mov    $0x11,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <unlink>:
SYSCALL(unlink)
 329:	b8 12 00 00 00       	mov    $0x12,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <fstat>:
SYSCALL(fstat)
 331:	b8 08 00 00 00       	mov    $0x8,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <link>:
SYSCALL(link)
 339:	b8 13 00 00 00       	mov    $0x13,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <mkdir>:
SYSCALL(mkdir)
 341:	b8 14 00 00 00       	mov    $0x14,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <chdir>:
SYSCALL(chdir)
 349:	b8 09 00 00 00       	mov    $0x9,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <dup>:
SYSCALL(dup)
 351:	b8 0a 00 00 00       	mov    $0xa,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <getpid>:
SYSCALL(getpid)
 359:	b8 0b 00 00 00       	mov    $0xb,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <sbrk>:
SYSCALL(sbrk)
 361:	b8 0c 00 00 00       	mov    $0xc,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <sleep>:
SYSCALL(sleep)
 369:	b8 0d 00 00 00       	mov    $0xd,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <uptime>:
SYSCALL(uptime)
 371:	b8 0e 00 00 00       	mov    $0xe,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <slabtest>:
SYSCALL(slabtest)
 379:	b8 16 00 00 00       	mov    $0x16,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <ps>:
SYSCALL(ps)
 381:	b8 17 00 00 00       	mov    $0x17,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	57                   	push   %edi
 38d:	56                   	push   %esi
 38e:	53                   	push   %ebx
 38f:	83 ec 3c             	sub    $0x3c,%esp
 392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 395:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 39b:	74 77                	je     414 <printint+0x8b>
 39d:	85 d2                	test   %edx,%edx
 39f:	79 73                	jns    414 <printint+0x8b>
    neg = 1;
    x = -xx;
 3a1:	f7 db                	neg    %ebx
    neg = 1;
 3a3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3aa:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 3af:	89 f7                	mov    %esi,%edi
 3b1:	83 c6 01             	add    $0x1,%esi
 3b4:	89 d8                	mov    %ebx,%eax
 3b6:	ba 00 00 00 00       	mov    $0x0,%edx
 3bb:	f7 f1                	div    %ecx
 3bd:	0f b6 92 9c 07 00 00 	movzbl 0x79c(%edx),%edx
 3c4:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3c8:	89 da                	mov    %ebx,%edx
 3ca:	89 c3                	mov    %eax,%ebx
 3cc:	39 d1                	cmp    %edx,%ecx
 3ce:	76 df                	jbe    3af <printint+0x26>
  if(neg)
 3d0:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3d4:	74 08                	je     3de <printint+0x55>
    buf[i++] = '-';
 3d6:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 3db:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 3de:	85 f6                	test   %esi,%esi
 3e0:	7e 2a                	jle    40c <printint+0x83>
 3e2:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 3e6:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 3e9:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3ec:	0f b6 03             	movzbl (%ebx),%eax
 3ef:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3f2:	83 ec 04             	sub    $0x4,%esp
 3f5:	6a 01                	push   $0x1
 3f7:	56                   	push   %esi
 3f8:	ff 75 c4             	pushl  -0x3c(%ebp)
 3fb:	e8 f9 fe ff ff       	call   2f9 <write>
  while(--i >= 0)
 400:	89 d8                	mov    %ebx,%eax
 402:	83 eb 01             	sub    $0x1,%ebx
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 f8                	cmp    %edi,%eax
 40a:	75 e0                	jne    3ec <printint+0x63>
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
  neg = 0;
 414:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 41b:	eb 8d                	jmp    3aa <printint+0x21>

0000041d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 41d:	f3 0f 1e fb          	endbr32 
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	57                   	push   %edi
 425:	56                   	push   %esi
 426:	53                   	push   %ebx
 427:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 42a:	8b 75 0c             	mov    0xc(%ebp),%esi
 42d:	0f b6 1e             	movzbl (%esi),%ebx
 430:	84 db                	test   %bl,%bl
 432:	0f 84 ab 01 00 00    	je     5e3 <printf+0x1c6>
 438:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 43b:	8d 45 10             	lea    0x10(%ebp),%eax
 43e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 441:	bf 00 00 00 00       	mov    $0x0,%edi
 446:	eb 2d                	jmp    475 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 448:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	6a 01                	push   $0x1
 450:	8d 45 e7             	lea    -0x19(%ebp),%eax
 453:	50                   	push   %eax
 454:	ff 75 08             	pushl  0x8(%ebp)
 457:	e8 9d fe ff ff       	call   2f9 <write>
        putc(fd, c);
 45c:	83 c4 10             	add    $0x10,%esp
 45f:	eb 05                	jmp    466 <printf+0x49>
      }
    } else if(state == '%'){
 461:	83 ff 25             	cmp    $0x25,%edi
 464:	74 22                	je     488 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 466:	83 c6 01             	add    $0x1,%esi
 469:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46d:	84 db                	test   %bl,%bl
 46f:	0f 84 6e 01 00 00    	je     5e3 <printf+0x1c6>
    c = fmt[i] & 0xff;
 475:	0f be d3             	movsbl %bl,%edx
 478:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 47b:	85 ff                	test   %edi,%edi
 47d:	75 e2                	jne    461 <printf+0x44>
      if(c == '%'){
 47f:	83 f8 25             	cmp    $0x25,%eax
 482:	75 c4                	jne    448 <printf+0x2b>
        state = '%';
 484:	89 c7                	mov    %eax,%edi
 486:	eb de                	jmp    466 <printf+0x49>
      if(c == 'd'){
 488:	83 f8 64             	cmp    $0x64,%eax
 48b:	74 59                	je     4e6 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48d:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 493:	83 fa 70             	cmp    $0x70,%edx
 496:	74 7a                	je     512 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 498:	83 f8 73             	cmp    $0x73,%eax
 49b:	0f 84 9d 00 00 00    	je     53e <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a1:	83 f8 63             	cmp    $0x63,%eax
 4a4:	0f 84 ec 00 00 00    	je     596 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4aa:	83 f8 25             	cmp    $0x25,%eax
 4ad:	0f 84 0f 01 00 00    	je     5c2 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4b3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4b7:	83 ec 04             	sub    $0x4,%esp
 4ba:	6a 01                	push   $0x1
 4bc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4bf:	50                   	push   %eax
 4c0:	ff 75 08             	pushl  0x8(%ebp)
 4c3:	e8 31 fe ff ff       	call   2f9 <write>
        putc(fd, c);
 4c8:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	83 c4 0c             	add    $0xc,%esp
 4ce:	6a 01                	push   $0x1
 4d0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 1d fe ff ff       	call   2f9 <write>
        putc(fd, c);
 4dc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4df:	bf 00 00 00 00       	mov    $0x0,%edi
 4e4:	eb 80                	jmp    466 <printf+0x49>
        printint(fd, *ap, 10, 1);
 4e6:	83 ec 0c             	sub    $0xc,%esp
 4e9:	6a 01                	push   $0x1
 4eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f3:	8b 17                	mov    (%edi),%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 8c fe ff ff       	call   389 <printint>
        ap++;
 4fd:	89 f8                	mov    %edi,%eax
 4ff:	83 c0 04             	add    $0x4,%eax
 502:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 505:	83 c4 10             	add    $0x10,%esp
      state = 0;
 508:	bf 00 00 00 00       	mov    $0x0,%edi
 50d:	e9 54 ff ff ff       	jmp    466 <printf+0x49>
        printint(fd, *ap, 16, 0);
 512:	83 ec 0c             	sub    $0xc,%esp
 515:	6a 00                	push   $0x0
 517:	b9 10 00 00 00       	mov    $0x10,%ecx
 51c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 51f:	8b 17                	mov    (%edi),%edx
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	e8 60 fe ff ff       	call   389 <printint>
        ap++;
 529:	89 f8                	mov    %edi,%eax
 52b:	83 c0 04             	add    $0x4,%eax
 52e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 531:	83 c4 10             	add    $0x10,%esp
      state = 0;
 534:	bf 00 00 00 00       	mov    $0x0,%edi
 539:	e9 28 ff ff ff       	jmp    466 <printf+0x49>
        s = (char*)*ap;
 53e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 541:	8b 01                	mov    (%ecx),%eax
        ap++;
 543:	83 c1 04             	add    $0x4,%ecx
 546:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 549:	85 c0                	test   %eax,%eax
 54b:	74 13                	je     560 <printf+0x143>
        s = (char*)*ap;
 54d:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 54f:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 552:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 557:	84 c0                	test   %al,%al
 559:	75 0f                	jne    56a <printf+0x14d>
 55b:	e9 06 ff ff ff       	jmp    466 <printf+0x49>
          s = "(null)";
 560:	bb 93 07 00 00       	mov    $0x793,%ebx
        while(*s != 0){
 565:	b8 28 00 00 00       	mov    $0x28,%eax
 56a:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 56d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	6a 01                	push   $0x1
 575:	8d 45 e7             	lea    -0x19(%ebp),%eax
 578:	50                   	push   %eax
 579:	57                   	push   %edi
 57a:	e8 7a fd ff ff       	call   2f9 <write>
          s++;
 57f:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 582:	0f b6 03             	movzbl (%ebx),%eax
 585:	83 c4 10             	add    $0x10,%esp
 588:	84 c0                	test   %al,%al
 58a:	75 e1                	jne    56d <printf+0x150>
      state = 0;
 58c:	bf 00 00 00 00       	mov    $0x0,%edi
 591:	e9 d0 fe ff ff       	jmp    466 <printf+0x49>
        putc(fd, *ap);
 596:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 599:	8b 07                	mov    (%edi),%eax
 59b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 59e:	83 ec 04             	sub    $0x4,%esp
 5a1:	6a 01                	push   $0x1
 5a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 4a fd ff ff       	call   2f9 <write>
        ap++;
 5af:	83 c7 04             	add    $0x4,%edi
 5b2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5b5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b8:	bf 00 00 00 00       	mov    $0x0,%edi
 5bd:	e9 a4 fe ff ff       	jmp    466 <printf+0x49>
        putc(fd, c);
 5c2:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5c5:	83 ec 04             	sub    $0x4,%esp
 5c8:	6a 01                	push   $0x1
 5ca:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 23 fd ff ff       	call   2f9 <write>
 5d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d9:	bf 00 00 00 00       	mov    $0x0,%edi
 5de:	e9 83 fe ff ff       	jmp    466 <printf+0x49>
    }
  }
}
 5e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    

000005eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5eb:	f3 0f 1e fb          	endbr32 
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	57                   	push   %edi
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
 5f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	a1 48 0a 00 00       	mov    0xa48,%eax
 600:	eb 0c                	jmp    60e <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 10                	mov    (%eax),%edx
 604:	39 c2                	cmp    %eax,%edx
 606:	77 04                	ja     60c <free+0x21>
 608:	39 ca                	cmp    %ecx,%edx
 60a:	77 10                	ja     61c <free+0x31>
{
 60c:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60e:	39 c8                	cmp    %ecx,%eax
 610:	73 f0                	jae    602 <free+0x17>
 612:	8b 10                	mov    (%eax),%edx
 614:	39 ca                	cmp    %ecx,%edx
 616:	77 04                	ja     61c <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 618:	39 c2                	cmp    %eax,%edx
 61a:	77 f0                	ja     60c <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 61f:	8b 10                	mov    (%eax),%edx
 621:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 624:	39 fa                	cmp    %edi,%edx
 626:	74 19                	je     641 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 628:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 62b:	8b 50 04             	mov    0x4(%eax),%edx
 62e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 631:	39 f1                	cmp    %esi,%ecx
 633:	74 1b                	je     650 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 635:	89 08                	mov    %ecx,(%eax)
  freep = p;
 637:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 641:	03 72 04             	add    0x4(%edx),%esi
 644:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 647:	8b 10                	mov    (%eax),%edx
 649:	8b 12                	mov    (%edx),%edx
 64b:	89 53 f8             	mov    %edx,-0x8(%ebx)
 64e:	eb db                	jmp    62b <free+0x40>
    p->s.size += bp->s.size;
 650:	03 53 fc             	add    -0x4(%ebx),%edx
 653:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 656:	8b 53 f8             	mov    -0x8(%ebx),%edx
 659:	89 10                	mov    %edx,(%eax)
 65b:	eb da                	jmp    637 <free+0x4c>

0000065d <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 65d:	f3 0f 1e fb          	endbr32 
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	57                   	push   %edi
 665:	56                   	push   %esi
 666:	53                   	push   %ebx
 667:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	8d 58 07             	lea    0x7(%eax),%ebx
 670:	c1 eb 03             	shr    $0x3,%ebx
 673:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 676:	8b 15 48 0a 00 00    	mov    0xa48,%edx
 67c:	85 d2                	test   %edx,%edx
 67e:	74 20                	je     6a0 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 48 04             	mov    0x4(%eax),%ecx
 685:	39 cb                	cmp    %ecx,%ebx
 687:	76 3c                	jbe    6c5 <malloc+0x68>
 689:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 68f:	be 00 10 00 00       	mov    $0x1000,%esi
 694:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 697:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 69e:	eb 72                	jmp    712 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 6a0:	c7 05 48 0a 00 00 4c 	movl   $0xa4c,0xa48
 6a7:	0a 00 00 
 6aa:	c7 05 4c 0a 00 00 4c 	movl   $0xa4c,0xa4c
 6b1:	0a 00 00 
    base.s.size = 0;
 6b4:	c7 05 50 0a 00 00 00 	movl   $0x0,0xa50
 6bb:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6be:	b8 4c 0a 00 00       	mov    $0xa4c,%eax
 6c3:	eb c4                	jmp    689 <malloc+0x2c>
      if(p->s.size == nunits)
 6c5:	39 cb                	cmp    %ecx,%ebx
 6c7:	74 1e                	je     6e7 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6c9:	29 d9                	sub    %ebx,%ecx
 6cb:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ce:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6d1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6d4:	89 15 48 0a 00 00    	mov    %edx,0xa48
      return (void*)(p + 1);
 6da:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6dd:	89 d0                	mov    %edx,%eax
 6df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6e7:	8b 08                	mov    (%eax),%ecx
 6e9:	89 0a                	mov    %ecx,(%edx)
 6eb:	eb e7                	jmp    6d4 <malloc+0x77>
  hp->s.size = nu;
 6ed:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	83 c0 08             	add    $0x8,%eax
 6f6:	50                   	push   %eax
 6f7:	e8 ef fe ff ff       	call   5eb <free>
  return freep;
 6fc:	8b 15 48 0a 00 00    	mov    0xa48,%edx
      if((p = morecore(nunits)) == 0)
 702:	83 c4 10             	add    $0x10,%esp
 705:	85 d2                	test   %edx,%edx
 707:	74 d4                	je     6dd <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 709:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 70b:	8b 48 04             	mov    0x4(%eax),%ecx
 70e:	39 d9                	cmp    %ebx,%ecx
 710:	73 b3                	jae    6c5 <malloc+0x68>
    if(p == freep)
 712:	89 c2                	mov    %eax,%edx
 714:	39 05 48 0a 00 00    	cmp    %eax,0xa48
 71a:	75 ed                	jne    709 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	57                   	push   %edi
 720:	e8 3c fc ff ff       	call   361 <sbrk>
  if(p == (char*)-1)
 725:	83 c4 10             	add    $0x10,%esp
 728:	83 f8 ff             	cmp    $0xffffffff,%eax
 72b:	75 c0                	jne    6ed <malloc+0x90>
        return 0;
 72d:	ba 00 00 00 00       	mov    $0x0,%edx
 732:	eb a9                	jmp    6dd <malloc+0x80>
