
user/_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1e:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  25:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2b:	68 18 07 00 00       	push   $0x718
  30:	6a 01                	push   $0x1
  32:	e8 ea 03 00 00       	call   421 <printf>
  memset(data, 'a', sizeof(data));
  37:	83 c4 0c             	add    $0xc,%esp
  3a:	68 00 02 00 00       	push   $0x200
  3f:	6a 61                	push   $0x61
  41:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  47:	50                   	push   %eax
  48:	e8 39 01 00 00       	call   186 <memset>
  4d:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  50:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(fork() > 0)
  55:	e8 77 02 00 00       	call   2d1 <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 08                	jg     66 <main+0x66>
  for(i = 0; i < 4; i++)
  5e:	83 c3 01             	add    $0x1,%ebx
  61:	83 fb 04             	cmp    $0x4,%ebx
  64:	75 ef                	jne    55 <main+0x55>
      break;

  printf(1, "write %d\n", i);
  66:	83 ec 04             	sub    $0x4,%esp
  69:	53                   	push   %ebx
  6a:	68 2b 07 00 00       	push   $0x72b
  6f:	6a 01                	push   $0x1
  71:	e8 ab 03 00 00       	call   421 <printf>

  path[8] += i;
  76:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  79:	83 c4 08             	add    $0x8,%esp
  7c:	68 02 02 00 00       	push   $0x202
  81:	8d 45 de             	lea    -0x22(%ebp),%eax
  84:	50                   	push   %eax
  85:	e8 8f 02 00 00       	call   319 <open>
  8a:	89 c6                	mov    %eax,%esi
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	68 00 02 00 00       	push   $0x200
  a2:	57                   	push   %edi
  a3:	56                   	push   %esi
  a4:	e8 50 02 00 00       	call   2f9 <write>
  for(i = 0; i < 20; i++)
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	83 eb 01             	sub    $0x1,%ebx
  af:	75 e9                	jne    9a <main+0x9a>
  close(fd);
  b1:	83 ec 0c             	sub    $0xc,%esp
  b4:	56                   	push   %esi
  b5:	e8 47 02 00 00       	call   301 <close>

  printf(1, "read\n");
  ba:	83 c4 08             	add    $0x8,%esp
  bd:	68 35 07 00 00       	push   $0x735
  c2:	6a 01                	push   $0x1
  c4:	e8 58 03 00 00       	call   421 <printf>

  fd = open(path, O_RDONLY);
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	6a 00                	push   $0x0
  ce:	8d 45 de             	lea    -0x22(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	e8 42 02 00 00       	call   319 <open>
  d7:	89 c6                	mov    %eax,%esi
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e1:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	68 00 02 00 00       	push   $0x200
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	e8 fb 01 00 00       	call   2f1 <read>
  for (i = 0; i < 20; i++)
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	83 eb 01             	sub    $0x1,%ebx
  fc:	75 e9                	jne    e7 <main+0xe7>
  close(fd);
  fe:	83 ec 0c             	sub    $0xc,%esp
 101:	56                   	push   %esi
 102:	e8 fa 01 00 00       	call   301 <close>

  wait();
 107:	e8 d5 01 00 00       	call   2e1 <wait>

  exit();
 10c:	e8 c8 01 00 00       	call   2d9 <exit>

00000111 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	53                   	push   %ebx
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11b:	b8 00 00 00 00       	mov    $0x0,%eax
 120:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 124:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 127:	83 c0 01             	add    $0x1,%eax
 12a:	84 d2                	test   %dl,%dl
 12c:	75 f2                	jne    120 <strcpy+0xf>
    ;
  return os;
}
 12e:	89 c8                	mov    %ecx,%eax
 130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13e:	0f b6 01             	movzbl (%ecx),%eax
 141:	84 c0                	test   %al,%al
 143:	74 11                	je     156 <strcmp+0x21>
 145:	38 02                	cmp    %al,(%edx)
 147:	75 0d                	jne    156 <strcmp+0x21>
    p++, q++;
 149:	83 c1 01             	add    $0x1,%ecx
 14c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 14f:	0f b6 01             	movzbl (%ecx),%eax
 152:	84 c0                	test   %al,%al
 154:	75 ef                	jne    145 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 156:	0f b6 c0             	movzbl %al,%eax
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	29 d0                	sub    %edx,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 3a 00             	cmpb   $0x0,(%edx)
 169:	74 14                	je     17f <strlen+0x1f>
 16b:	b8 00 00 00 00       	mov    $0x0,%eax
 170:	83 c0 01             	add    $0x1,%eax
 173:	89 c1                	mov    %eax,%ecx
 175:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	89 c8                	mov    %ecx,%eax
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
  for(n = 0; s[n]; n++)
 17f:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 184:	eb f5                	jmp    17b <strlen+0x1b>

00000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	57                   	push   %edi
 18a:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18d:	89 d7                	mov    %edx,%edi
 18f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	fc                   	cld    
 196:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 198:	89 d0                	mov    %edx,%eax
 19a:	8b 7d fc             	mov    -0x4(%ebp),%edi
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <strchr>:

char*
strchr(const char *s, char c)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1a9:	0f b6 10             	movzbl (%eax),%edx
 1ac:	84 d2                	test   %dl,%dl
 1ae:	74 15                	je     1c5 <strchr+0x26>
    if(*s == c)
 1b0:	38 d1                	cmp    %dl,%cl
 1b2:	74 0f                	je     1c3 <strchr+0x24>
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x11>
      return (char*)s;
  return 0;
 1be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
  return 0;
 1c5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ca:	eb f7                	jmp    1c3 <strchr+0x24>

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 2c             	sub    $0x2c,%esp
 1d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d8:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 1dd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1e3:	83 c3 01             	add    $0x1,%ebx
 1e6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e9:	7d 27                	jge    212 <gets+0x46>
    cc = read(0, &c, 1);
 1eb:	83 ec 04             	sub    $0x4,%esp
 1ee:	6a 01                	push   $0x1
 1f0:	57                   	push   %edi
 1f1:	6a 00                	push   $0x0
 1f3:	e8 f9 00 00 00       	call   2f1 <read>
    if(cc < 1)
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	85 c0                	test   %eax,%eax
 1fd:	7e 13                	jle    212 <gets+0x46>
      break;
    buf[i++] = c;
 1ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 203:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 207:	3c 0a                	cmp    $0xa,%al
 209:	74 04                	je     20f <gets+0x43>
 20b:	3c 0d                	cmp    $0xd,%al
 20d:	75 d1                	jne    1e0 <gets+0x14>
  for(i=0; i+1 < max; ){
 20f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 212:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 215:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 219:	89 f0                	mov    %esi,%eax
 21b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    

00000223 <stat>:

int
stat(const char *n, struct stat *st)
{
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
 226:	56                   	push   %esi
 227:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	6a 00                	push   $0x0
 22d:	ff 75 08             	push   0x8(%ebp)
 230:	e8 e4 00 00 00       	call   319 <open>
  if(fd < 0)
 235:	83 c4 10             	add    $0x10,%esp
 238:	85 c0                	test   %eax,%eax
 23a:	78 24                	js     260 <stat+0x3d>
 23c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23e:	83 ec 08             	sub    $0x8,%esp
 241:	ff 75 0c             	push   0xc(%ebp)
 244:	50                   	push   %eax
 245:	e8 e7 00 00 00       	call   331 <fstat>
 24a:	89 c6                	mov    %eax,%esi
  close(fd);
 24c:	89 1c 24             	mov    %ebx,(%esp)
 24f:	e8 ad 00 00 00       	call   301 <close>
  return r;
 254:	83 c4 10             	add    $0x10,%esp
}
 257:	89 f0                	mov    %esi,%eax
 259:	8d 65 f8             	lea    -0x8(%ebp),%esp
 25c:	5b                   	pop    %ebx
 25d:	5e                   	pop    %esi
 25e:	5d                   	pop    %ebp
 25f:	c3                   	ret    
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb f0                	jmp    257 <stat+0x34>

00000267 <atoi>:

int
atoi(const char *s)
{
 267:	55                   	push   %ebp
 268:	89 e5                	mov    %esp,%ebp
 26a:	53                   	push   %ebx
 26b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26e:	0f b6 02             	movzbl (%edx),%eax
 271:	8d 48 d0             	lea    -0x30(%eax),%ecx
 274:	80 f9 09             	cmp    $0x9,%cl
 277:	77 24                	ja     29d <atoi+0x36>
  n = 0;
 279:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 27e:	83 c2 01             	add    $0x1,%edx
 281:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 284:	0f be c0             	movsbl %al,%eax
 287:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 28b:	0f b6 02             	movzbl (%edx),%eax
 28e:	8d 58 d0             	lea    -0x30(%eax),%ebx
 291:	80 fb 09             	cmp    $0x9,%bl
 294:	76 e8                	jbe    27e <atoi+0x17>
  return n;
}
 296:	89 c8                	mov    %ecx,%eax
 298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 29b:	c9                   	leave  
 29c:	c3                   	ret    
  n = 0;
 29d:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 2a2:	eb f2                	jmp    296 <atoi+0x2f>

000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
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
 2b4:	7e 15                	jle    2cb <memmove+0x27>
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
 2c9:	75 ef                	jne    2ba <memmove+0x16>
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
 395:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 39b:	74 79                	je     416 <printint+0x8d>
 39d:	85 d2                	test   %edx,%edx
 39f:	79 75                	jns    416 <printint+0x8d>
    neg = 1;
    x = -xx;
 3a1:	89 d1                	mov    %edx,%ecx
 3a3:	f7 d9                	neg    %ecx
    neg = 1;
 3a5:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3b1:	89 df                	mov    %ebx,%edi
 3b3:	83 c3 01             	add    $0x1,%ebx
 3b6:	89 c8                	mov    %ecx,%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 f6                	div    %esi
 3bf:	0f b6 92 9c 07 00 00 	movzbl 0x79c(%edx),%edx
 3c6:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3ca:	89 ca                	mov    %ecx,%edx
 3cc:	89 c1                	mov    %eax,%ecx
 3ce:	39 d6                	cmp    %edx,%esi
 3d0:	76 df                	jbe    3b1 <printint+0x28>
  if(neg)
 3d2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 3d6:	74 08                	je     3e0 <printint+0x57>
    buf[i++] = '-';
 3d8:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3dd:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3e0:	85 db                	test   %ebx,%ebx
 3e2:	7e 2a                	jle    40e <printint+0x85>
 3e4:	8d 7d d8             	lea    -0x28(%ebp),%edi
 3e7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 3eb:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 3ee:	0f b6 03             	movzbl (%ebx),%eax
 3f1:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3f4:	83 ec 04             	sub    $0x4,%esp
 3f7:	6a 01                	push   $0x1
 3f9:	56                   	push   %esi
 3fa:	ff 75 c4             	push   -0x3c(%ebp)
 3fd:	e8 f7 fe ff ff       	call   2f9 <write>
  while(--i >= 0)
 402:	89 d8                	mov    %ebx,%eax
 404:	83 eb 01             	sub    $0x1,%ebx
 407:	83 c4 10             	add    $0x10,%esp
 40a:	39 f8                	cmp    %edi,%eax
 40c:	75 e0                	jne    3ee <printint+0x65>
}
 40e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 411:	5b                   	pop    %ebx
 412:	5e                   	pop    %esi
 413:	5f                   	pop    %edi
 414:	5d                   	pop    %ebp
 415:	c3                   	ret    
    x = xx;
 416:	89 d1                	mov    %edx,%ecx
  neg = 0;
 418:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 41f:	eb 8b                	jmp    3ac <printint+0x23>

00000421 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
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
 432:	0f 84 9f 01 00 00    	je     5d7 <printf+0x1b6>
 438:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 43b:	8d 45 10             	lea    0x10(%ebp),%eax
 43e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 441:	bf 00 00 00 00       	mov    $0x0,%edi
 446:	eb 2d                	jmp    475 <printf+0x54>
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
 454:	ff 75 08             	push   0x8(%ebp)
 457:	e8 9d fe ff ff       	call   2f9 <write>
        putc(fd, c);
 45c:	83 c4 10             	add    $0x10,%esp
 45f:	eb 05                	jmp    466 <printf+0x45>
      }
    } else if(state == '%'){
 461:	83 ff 25             	cmp    $0x25,%edi
 464:	74 1f                	je     485 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 466:	83 c6 01             	add    $0x1,%esi
 469:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46d:	84 db                	test   %bl,%bl
 46f:	0f 84 62 01 00 00    	je     5d7 <printf+0x1b6>
    c = fmt[i] & 0xff;
 475:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 478:	85 ff                	test   %edi,%edi
 47a:	75 e5                	jne    461 <printf+0x40>
      if(c == '%'){
 47c:	83 f8 25             	cmp    $0x25,%eax
 47f:	75 c7                	jne    448 <printf+0x27>
        state = '%';
 481:	89 c7                	mov    %eax,%edi
 483:	eb e1                	jmp    466 <printf+0x45>
      if(c == 'd'){
 485:	83 f8 25             	cmp    $0x25,%eax
 488:	0f 84 f2 00 00 00    	je     580 <printf+0x15f>
 48e:	8d 50 9d             	lea    -0x63(%eax),%edx
 491:	83 fa 15             	cmp    $0x15,%edx
 494:	0f 87 07 01 00 00    	ja     5a1 <printf+0x180>
 49a:	0f 87 01 01 00 00    	ja     5a1 <printf+0x180>
 4a0:	ff 24 95 44 07 00 00 	jmp    *0x744(,%edx,4)
        printint(fd, *ap, 10, 1);
 4a7:	83 ec 0c             	sub    $0xc,%esp
 4aa:	6a 01                	push   $0x1
 4ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b4:	8b 17                	mov    (%edi),%edx
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	e8 cb fe ff ff       	call   389 <printint>
        ap++;
 4be:	89 f8                	mov    %edi,%eax
 4c0:	83 c0 04             	add    $0x4,%eax
 4c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c9:	bf 00 00 00 00       	mov    $0x0,%edi
 4ce:	eb 96                	jmp    466 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4d0:	83 ec 0c             	sub    $0xc,%esp
 4d3:	6a 00                	push   $0x0
 4d5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4da:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4dd:	8b 17                	mov    (%edi),%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	e8 a2 fe ff ff       	call   389 <printint>
        ap++;
 4e7:	89 f8                	mov    %edi,%eax
 4e9:	83 c0 04             	add    $0x4,%eax
 4ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f2:	bf 00 00 00 00       	mov    $0x0,%edi
 4f7:	e9 6a ff ff ff       	jmp    466 <printf+0x45>
        s = (char*)*ap;
 4fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4ff:	8b 01                	mov    (%ecx),%eax
        ap++;
 501:	83 c1 04             	add    $0x4,%ecx
 504:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 507:	85 c0                	test   %eax,%eax
 509:	74 13                	je     51e <printf+0xfd>
        s = (char*)*ap;
 50b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 50d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 510:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 515:	84 c0                	test   %al,%al
 517:	75 0f                	jne    528 <printf+0x107>
 519:	e9 48 ff ff ff       	jmp    466 <printf+0x45>
          s = "(null)";
 51e:	bb 3b 07 00 00       	mov    $0x73b,%ebx
        while(*s != 0){
 523:	b8 28 00 00 00       	mov    $0x28,%eax
 528:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 52b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 52e:	83 ec 04             	sub    $0x4,%esp
 531:	6a 01                	push   $0x1
 533:	8d 45 e7             	lea    -0x19(%ebp),%eax
 536:	50                   	push   %eax
 537:	57                   	push   %edi
 538:	e8 bc fd ff ff       	call   2f9 <write>
          s++;
 53d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 540:	0f b6 03             	movzbl (%ebx),%eax
 543:	83 c4 10             	add    $0x10,%esp
 546:	84 c0                	test   %al,%al
 548:	75 e1                	jne    52b <printf+0x10a>
      state = 0;
 54a:	bf 00 00 00 00       	mov    $0x0,%edi
 54f:	e9 12 ff ff ff       	jmp    466 <printf+0x45>
        putc(fd, *ap);
 554:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 557:	8b 07                	mov    (%edi),%eax
 559:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55c:	83 ec 04             	sub    $0x4,%esp
 55f:	6a 01                	push   $0x1
 561:	8d 45 e7             	lea    -0x19(%ebp),%eax
 564:	50                   	push   %eax
 565:	ff 75 08             	push   0x8(%ebp)
 568:	e8 8c fd ff ff       	call   2f9 <write>
        ap++;
 56d:	83 c7 04             	add    $0x4,%edi
 570:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 573:	83 c4 10             	add    $0x10,%esp
      state = 0;
 576:	bf 00 00 00 00       	mov    $0x0,%edi
 57b:	e9 e6 fe ff ff       	jmp    466 <printf+0x45>
        putc(fd, c);
 580:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
 586:	6a 01                	push   $0x1
 588:	8d 45 e7             	lea    -0x19(%ebp),%eax
 58b:	50                   	push   %eax
 58c:	ff 75 08             	push   0x8(%ebp)
 58f:	e8 65 fd ff ff       	call   2f9 <write>
 594:	83 c4 10             	add    $0x10,%esp
      state = 0;
 597:	bf 00 00 00 00       	mov    $0x0,%edi
 59c:	e9 c5 fe ff ff       	jmp    466 <printf+0x45>
        putc(fd, '%');
 5a1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5a5:	83 ec 04             	sub    $0x4,%esp
 5a8:	6a 01                	push   $0x1
 5aa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5ad:	50                   	push   %eax
 5ae:	ff 75 08             	push   0x8(%ebp)
 5b1:	e8 43 fd ff ff       	call   2f9 <write>
        putc(fd, c);
 5b6:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5b9:	83 c4 0c             	add    $0xc,%esp
 5bc:	6a 01                	push   $0x1
 5be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5c1:	50                   	push   %eax
 5c2:	ff 75 08             	push   0x8(%ebp)
 5c5:	e8 2f fd ff ff       	call   2f9 <write>
        putc(fd, c);
 5ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cd:	bf 00 00 00 00       	mov    $0x0,%edi
 5d2:	e9 8f fe ff ff       	jmp    466 <printf+0x45>
    }
  }
}
 5d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5da:	5b                   	pop    %ebx
 5db:	5e                   	pop    %esi
 5dc:	5f                   	pop    %edi
 5dd:	5d                   	pop    %ebp
 5de:	c3                   	ret    

000005df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5df:	55                   	push   %ebp
 5e0:	89 e5                	mov    %esp,%ebp
 5e2:	57                   	push   %edi
 5e3:	56                   	push   %esi
 5e4:	53                   	push   %ebx
 5e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5eb:	a1 10 0a 00 00       	mov    0xa10,%eax
 5f0:	eb 0c                	jmp    5fe <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f2:	8b 10                	mov    (%eax),%edx
 5f4:	39 c2                	cmp    %eax,%edx
 5f6:	77 04                	ja     5fc <free+0x1d>
 5f8:	39 ca                	cmp    %ecx,%edx
 5fa:	77 10                	ja     60c <free+0x2d>
{
 5fc:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	39 c8                	cmp    %ecx,%eax
 600:	73 f0                	jae    5f2 <free+0x13>
 602:	8b 10                	mov    (%eax),%edx
 604:	39 ca                	cmp    %ecx,%edx
 606:	77 04                	ja     60c <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	39 c2                	cmp    %eax,%edx
 60a:	77 f0                	ja     5fc <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 60c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60f:	8b 10                	mov    (%eax),%edx
 611:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 614:	39 fa                	cmp    %edi,%edx
 616:	74 19                	je     631 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 618:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 61b:	8b 50 04             	mov    0x4(%eax),%edx
 61e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 621:	39 f1                	cmp    %esi,%ecx
 623:	74 18                	je     63d <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 625:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 627:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 62c:	5b                   	pop    %ebx
 62d:	5e                   	pop    %esi
 62e:	5f                   	pop    %edi
 62f:	5d                   	pop    %ebp
 630:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 631:	03 72 04             	add    0x4(%edx),%esi
 634:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 637:	8b 10                	mov    (%eax),%edx
 639:	8b 12                	mov    (%edx),%edx
 63b:	eb db                	jmp    618 <free+0x39>
    p->s.size += bp->s.size;
 63d:	03 53 fc             	add    -0x4(%ebx),%edx
 640:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 643:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 646:	eb dd                	jmp    625 <free+0x46>

00000648 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	57                   	push   %edi
 64c:	56                   	push   %esi
 64d:	53                   	push   %ebx
 64e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	8d 58 07             	lea    0x7(%eax),%ebx
 657:	c1 eb 03             	shr    $0x3,%ebx
 65a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 65d:	8b 15 10 0a 00 00    	mov    0xa10,%edx
 663:	85 d2                	test   %edx,%edx
 665:	74 1c                	je     683 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 667:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 669:	8b 48 04             	mov    0x4(%eax),%ecx
 66c:	39 cb                	cmp    %ecx,%ebx
 66e:	76 38                	jbe    6a8 <malloc+0x60>
 670:	be 00 10 00 00       	mov    $0x1000,%esi
 675:	39 f3                	cmp    %esi,%ebx
 677:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 67a:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 681:	eb 72                	jmp    6f5 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 683:	c7 05 10 0a 00 00 14 	movl   $0xa14,0xa10
 68a:	0a 00 00 
 68d:	c7 05 14 0a 00 00 14 	movl   $0xa14,0xa14
 694:	0a 00 00 
    base.s.size = 0;
 697:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 69e:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a1:	b8 14 0a 00 00       	mov    $0xa14,%eax
 6a6:	eb c8                	jmp    670 <malloc+0x28>
      if(p->s.size == nunits)
 6a8:	39 cb                	cmp    %ecx,%ebx
 6aa:	74 1e                	je     6ca <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ac:	29 d9                	sub    %ebx,%ecx
 6ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6b4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6b7:	89 15 10 0a 00 00    	mov    %edx,0xa10
      return (void*)(p + 1);
 6bd:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c0:	89 d0                	mov    %edx,%eax
 6c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c5:	5b                   	pop    %ebx
 6c6:	5e                   	pop    %esi
 6c7:	5f                   	pop    %edi
 6c8:	5d                   	pop    %ebp
 6c9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ca:	8b 08                	mov    (%eax),%ecx
 6cc:	89 0a                	mov    %ecx,(%edx)
 6ce:	eb e7                	jmp    6b7 <malloc+0x6f>
  hp->s.size = nu;
 6d0:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6d3:	83 ec 0c             	sub    $0xc,%esp
 6d6:	83 c0 08             	add    $0x8,%eax
 6d9:	50                   	push   %eax
 6da:	e8 00 ff ff ff       	call   5df <free>
  return freep;
 6df:	8b 15 10 0a 00 00    	mov    0xa10,%edx
      if((p = morecore(nunits)) == 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	85 d2                	test   %edx,%edx
 6ea:	74 d4                	je     6c0 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ec:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ee:	8b 48 04             	mov    0x4(%eax),%ecx
 6f1:	39 d9                	cmp    %ebx,%ecx
 6f3:	73 b3                	jae    6a8 <malloc+0x60>
    if(p == freep)
 6f5:	89 c2                	mov    %eax,%edx
 6f7:	39 05 10 0a 00 00    	cmp    %eax,0xa10
 6fd:	75 ed                	jne    6ec <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 6ff:	83 ec 0c             	sub    $0xc,%esp
 702:	57                   	push   %edi
 703:	e8 59 fc ff ff       	call   361 <sbrk>
  if(p == (char*)-1)
 708:	83 c4 10             	add    $0x10,%esp
 70b:	83 f8 ff             	cmp    $0xffffffff,%eax
 70e:	75 c0                	jne    6d0 <malloc+0x88>
        return 0;
 710:	ba 00 00 00 00       	mov    $0x0,%edx
 715:	eb a9                	jmp    6c0 <malloc+0x78>
