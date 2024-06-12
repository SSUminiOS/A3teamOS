
user/_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1e:	bf 00 00 00 00       	mov    $0x0,%edi
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	eb 4d                	jmp    72 <wc+0x72>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
  25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  2c:	83 c3 01             	add    $0x1,%ebx
  2f:	39 de                	cmp    %ebx,%esi
  31:	74 3c                	je     6f <wc+0x6f>
      if(buf[i] == '\n')
  33:	0f b6 83 c0 0a 00 00 	movzbl 0xac0(%ebx),%eax
        l++;
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	0f 94 c2             	sete   %dl
  3f:	0f b6 d2             	movzbl %dl,%edx
  42:	01 d7                	add    %edx,%edi
      if(strchr(" \r\t\n\v", buf[i]))
  44:	83 ec 08             	sub    $0x8,%esp
  47:	0f be c0             	movsbl %al,%eax
  4a:	50                   	push   %eax
  4b:	68 6c 07 00 00       	push   $0x76c
  50:	e8 9e 01 00 00       	call   1f3 <strchr>
  55:	83 c4 10             	add    $0x10,%esp
  58:	85 c0                	test   %eax,%eax
  5a:	75 c9                	jne    25 <wc+0x25>
      else if(!inword){
  5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  60:	75 ca                	jne    2c <wc+0x2c>
        w++;
  62:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
  66:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  6d:	eb bd                	jmp    2c <wc+0x2c>
      c++;
  6f:	01 5d dc             	add    %ebx,-0x24(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	83 ec 04             	sub    $0x4,%esp
  75:	68 00 02 00 00       	push   $0x200
  7a:	68 c0 0a 00 00       	push   $0xac0
  7f:	ff 75 08             	push   0x8(%ebp)
  82:	e8 be 02 00 00       	call   345 <read>
  87:	89 c6                	mov    %eax,%esi
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	7e 07                	jle    97 <wc+0x97>
    for(i=0; i<n; i++){
  90:	bb 00 00 00 00       	mov    $0x0,%ebx
  95:	eb 9c                	jmp    33 <wc+0x33>
      }
    }
  }
  if(n < 0){
  97:	78 24                	js     bd <wc+0xbd>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	ff 75 0c             	push   0xc(%ebp)
  9f:	ff 75 dc             	push   -0x24(%ebp)
  a2:	ff 75 e0             	push   -0x20(%ebp)
  a5:	57                   	push   %edi
  a6:	68 82 07 00 00       	push   $0x782
  ab:	6a 01                	push   $0x1
  ad:	e8 c3 03 00 00       	call   475 <printf>
}
  b2:	83 c4 20             	add    $0x20,%esp
  b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b8:	5b                   	pop    %ebx
  b9:	5e                   	pop    %esi
  ba:	5f                   	pop    %edi
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    
    printf(1, "wc: read error\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 72 07 00 00       	push   $0x772
  c5:	6a 01                	push   $0x1
  c7:	e8 a9 03 00 00       	call   475 <printf>
    exit();
  cc:	e8 5c 02 00 00       	call   32d <exit>

000000d1 <main>:

int
main(int argc, char *argv[])
{
  d1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d5:	83 e4 f0             	and    $0xfffffff0,%esp
  d8:	ff 71 fc             	push   -0x4(%ecx)
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	56                   	push   %esi
  e0:	53                   	push   %ebx
  e1:	51                   	push   %ecx
  e2:	83 ec 18             	sub    $0x18,%esp
  e5:	8b 01                	mov    (%ecx),%eax
  e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ea:	8b 71 04             	mov    0x4(%ecx),%esi
  int fd, i;

  if(argc <= 1){
  ed:	83 c6 04             	add    $0x4,%esi
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f0:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  f5:	83 f8 01             	cmp    $0x1,%eax
  f8:	7e 3e                	jle    138 <main+0x67>
    if((fd = open(argv[i], 0)) < 0){
  fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  fd:	83 ec 08             	sub    $0x8,%esp
 100:	6a 00                	push   $0x0
 102:	ff 36                	push   (%esi)
 104:	e8 64 02 00 00       	call   36d <open>
 109:	89 c3                	mov    %eax,%ebx
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	85 c0                	test   %eax,%eax
 110:	78 3a                	js     14c <main+0x7b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 112:	83 ec 08             	sub    $0x8,%esp
 115:	ff 36                	push   (%esi)
 117:	50                   	push   %eax
 118:	e8 e3 fe ff ff       	call   0 <wc>
    close(fd);
 11d:	89 1c 24             	mov    %ebx,(%esp)
 120:	e8 30 02 00 00       	call   355 <close>
  for(i = 1; i < argc; i++){
 125:	83 c7 01             	add    $0x1,%edi
 128:	83 c6 04             	add    $0x4,%esi
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 131:	75 c7                	jne    fa <main+0x29>
  }
  exit();
 133:	e8 f5 01 00 00       	call   32d <exit>
    wc(0, "");
 138:	83 ec 08             	sub    $0x8,%esp
 13b:	68 81 07 00 00       	push   $0x781
 140:	6a 00                	push   $0x0
 142:	e8 b9 fe ff ff       	call   0 <wc>
    exit();
 147:	e8 e1 01 00 00       	call   32d <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 152:	ff 30                	push   (%eax)
 154:	68 8f 07 00 00       	push   $0x78f
 159:	6a 01                	push   $0x1
 15b:	e8 15 03 00 00       	call   475 <printf>
      exit();
 160:	e8 c8 01 00 00       	call   32d <exit>

00000165 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	53                   	push   %ebx
 169:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16f:	b8 00 00 00 00       	mov    $0x0,%eax
 174:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 178:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 17b:	83 c0 01             	add    $0x1,%eax
 17e:	84 d2                	test   %dl,%dl
 180:	75 f2                	jne    174 <strcpy+0xf>
    ;
  return os;
}
 182:	89 c8                	mov    %ecx,%eax
 184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 187:	c9                   	leave  
 188:	c3                   	ret    

00000189 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 192:	0f b6 01             	movzbl (%ecx),%eax
 195:	84 c0                	test   %al,%al
 197:	74 11                	je     1aa <strcmp+0x21>
 199:	38 02                	cmp    %al,(%edx)
 19b:	75 0d                	jne    1aa <strcmp+0x21>
    p++, q++;
 19d:	83 c1 01             	add    $0x1,%ecx
 1a0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a3:	0f b6 01             	movzbl (%ecx),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 ef                	jne    199 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 1aa:	0f b6 c0             	movzbl %al,%eax
 1ad:	0f b6 12             	movzbl (%edx),%edx
 1b0:	29 d0                	sub    %edx,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <strlen>:

uint
strlen(const char *s)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 3a 00             	cmpb   $0x0,(%edx)
 1bd:	74 14                	je     1d3 <strlen+0x1f>
 1bf:	b8 00 00 00 00       	mov    $0x0,%eax
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	89 c1                	mov    %eax,%ecx
 1c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1cd:	75 f5                	jne    1c4 <strlen+0x10>
    ;
  return n;
}
 1cf:	89 c8                	mov    %ecx,%eax
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 1d8:	eb f5                	jmp    1cf <strlen+0x1b>

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	57                   	push   %edi
 1de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e1:	89 d7                	mov    %edx,%edi
 1e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	fc                   	cld    
 1ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1ec:	89 d0                	mov    %edx,%eax
 1ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <strchr>:

char*
strchr(const char *s, char c)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fd:	0f b6 10             	movzbl (%eax),%edx
 200:	84 d2                	test   %dl,%dl
 202:	74 15                	je     219 <strchr+0x26>
    if(*s == c)
 204:	38 d1                	cmp    %dl,%cl
 206:	74 0f                	je     217 <strchr+0x24>
  for(; *s; s++)
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	75 f2                	jne    204 <strchr+0x11>
      return (char*)s;
  return 0;
 212:	b8 00 00 00 00       	mov    $0x0,%eax
}
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
  return 0;
 219:	b8 00 00 00 00       	mov    $0x0,%eax
 21e:	eb f7                	jmp    217 <strchr+0x24>

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
 226:	83 ec 2c             	sub    $0x2c,%esp
 229:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 231:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 234:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 237:	83 c3 01             	add    $0x1,%ebx
 23a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23d:	7d 27                	jge    266 <gets+0x46>
    cc = read(0, &c, 1);
 23f:	83 ec 04             	sub    $0x4,%esp
 242:	6a 01                	push   $0x1
 244:	57                   	push   %edi
 245:	6a 00                	push   $0x0
 247:	e8 f9 00 00 00       	call   345 <read>
    if(cc < 1)
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	85 c0                	test   %eax,%eax
 251:	7e 13                	jle    266 <gets+0x46>
      break;
    buf[i++] = c;
 253:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 257:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 25b:	3c 0a                	cmp    $0xa,%al
 25d:	74 04                	je     263 <gets+0x43>
 25f:	3c 0d                	cmp    $0xd,%al
 261:	75 d1                	jne    234 <gets+0x14>
  for(i=0; i+1 < max; ){
 263:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 269:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 26d:	89 f0                	mov    %esi,%eax
 26f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 272:	5b                   	pop    %ebx
 273:	5e                   	pop    %esi
 274:	5f                   	pop    %edi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    

00000277 <stat>:

int
stat(const char *n, struct stat *st)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	56                   	push   %esi
 27b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27c:	83 ec 08             	sub    $0x8,%esp
 27f:	6a 00                	push   $0x0
 281:	ff 75 08             	push   0x8(%ebp)
 284:	e8 e4 00 00 00       	call   36d <open>
  if(fd < 0)
 289:	83 c4 10             	add    $0x10,%esp
 28c:	85 c0                	test   %eax,%eax
 28e:	78 24                	js     2b4 <stat+0x3d>
 290:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 292:	83 ec 08             	sub    $0x8,%esp
 295:	ff 75 0c             	push   0xc(%ebp)
 298:	50                   	push   %eax
 299:	e8 e7 00 00 00       	call   385 <fstat>
 29e:	89 c6                	mov    %eax,%esi
  close(fd);
 2a0:	89 1c 24             	mov    %ebx,(%esp)
 2a3:	e8 ad 00 00 00       	call   355 <close>
  return r;
 2a8:	83 c4 10             	add    $0x10,%esp
}
 2ab:	89 f0                	mov    %esi,%eax
 2ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
    return -1;
 2b4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b9:	eb f0                	jmp    2ab <stat+0x34>

000002bb <atoi>:

int
atoi(const char *s)
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	53                   	push   %ebx
 2bf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c2:	0f b6 02             	movzbl (%edx),%eax
 2c5:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2c8:	80 f9 09             	cmp    $0x9,%cl
 2cb:	77 24                	ja     2f1 <atoi+0x36>
  n = 0;
 2cd:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 2d2:	83 c2 01             	add    $0x1,%edx
 2d5:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2d8:	0f be c0             	movsbl %al,%eax
 2db:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2df:	0f b6 02             	movzbl (%edx),%eax
 2e2:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2e5:	80 fb 09             	cmp    $0x9,%bl
 2e8:	76 e8                	jbe    2d2 <atoi+0x17>
  return n;
}
 2ea:	89 c8                	mov    %ecx,%eax
 2ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    
  n = 0;
 2f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 2f6:	eb f2                	jmp    2ea <atoi+0x2f>

000002f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	56                   	push   %esi
 2fc:	53                   	push   %ebx
 2fd:	8b 75 08             	mov    0x8(%ebp),%esi
 300:	8b 55 0c             	mov    0xc(%ebp),%edx
 303:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 306:	85 db                	test   %ebx,%ebx
 308:	7e 15                	jle    31f <memmove+0x27>
 30a:	01 f3                	add    %esi,%ebx
  dst = vdst;
 30c:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 30e:	83 c2 01             	add    $0x1,%edx
 311:	83 c0 01             	add    $0x1,%eax
 314:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 318:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 31b:	39 c3                	cmp    %eax,%ebx
 31d:	75 ef                	jne    30e <memmove+0x16>
  return vdst;
}
 31f:	89 f0                	mov    %esi,%eax
 321:	5b                   	pop    %ebx
 322:	5e                   	pop    %esi
 323:	5d                   	pop    %ebp
 324:	c3                   	ret    

00000325 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 325:	b8 01 00 00 00       	mov    $0x1,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exit>:
SYSCALL(exit)
 32d:	b8 02 00 00 00       	mov    $0x2,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <wait>:
SYSCALL(wait)
 335:	b8 03 00 00 00       	mov    $0x3,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <pipe>:
SYSCALL(pipe)
 33d:	b8 04 00 00 00       	mov    $0x4,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <read>:
SYSCALL(read)
 345:	b8 05 00 00 00       	mov    $0x5,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <write>:
SYSCALL(write)
 34d:	b8 10 00 00 00       	mov    $0x10,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <close>:
SYSCALL(close)
 355:	b8 15 00 00 00       	mov    $0x15,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <kill>:
SYSCALL(kill)
 35d:	b8 06 00 00 00       	mov    $0x6,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <exec>:
SYSCALL(exec)
 365:	b8 07 00 00 00       	mov    $0x7,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <open>:
SYSCALL(open)
 36d:	b8 0f 00 00 00       	mov    $0xf,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <mknod>:
SYSCALL(mknod)
 375:	b8 11 00 00 00       	mov    $0x11,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <unlink>:
SYSCALL(unlink)
 37d:	b8 12 00 00 00       	mov    $0x12,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <fstat>:
SYSCALL(fstat)
 385:	b8 08 00 00 00       	mov    $0x8,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <link>:
SYSCALL(link)
 38d:	b8 13 00 00 00       	mov    $0x13,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <mkdir>:
SYSCALL(mkdir)
 395:	b8 14 00 00 00       	mov    $0x14,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <chdir>:
SYSCALL(chdir)
 39d:	b8 09 00 00 00       	mov    $0x9,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <dup>:
SYSCALL(dup)
 3a5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getpid>:
SYSCALL(getpid)
 3ad:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <sbrk>:
SYSCALL(sbrk)
 3b5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <sleep>:
SYSCALL(sleep)
 3bd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <uptime>:
SYSCALL(uptime)
 3c5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <slabtest>:
SYSCALL(slabtest)
 3cd:	b8 16 00 00 00       	mov    $0x16,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <ps>:
SYSCALL(ps)
 3d5:	b8 17 00 00 00       	mov    $0x17,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	57                   	push   %edi
 3e1:	56                   	push   %esi
 3e2:	53                   	push   %ebx
 3e3:	83 ec 3c             	sub    $0x3c,%esp
 3e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3e9:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ef:	74 79                	je     46a <printint+0x8d>
 3f1:	85 d2                	test   %edx,%edx
 3f3:	79 75                	jns    46a <printint+0x8d>
    neg = 1;
    x = -xx;
 3f5:	89 d1                	mov    %edx,%ecx
 3f7:	f7 d9                	neg    %ecx
    neg = 1;
 3f9:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 400:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 405:	89 df                	mov    %ebx,%edi
 407:	83 c3 01             	add    $0x1,%ebx
 40a:	89 c8                	mov    %ecx,%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f6                	div    %esi
 413:	0f b6 92 04 08 00 00 	movzbl 0x804(%edx),%edx
 41a:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 41e:	89 ca                	mov    %ecx,%edx
 420:	89 c1                	mov    %eax,%ecx
 422:	39 d6                	cmp    %edx,%esi
 424:	76 df                	jbe    405 <printint+0x28>
  if(neg)
 426:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 42a:	74 08                	je     434 <printint+0x57>
    buf[i++] = '-';
 42c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 431:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 434:	85 db                	test   %ebx,%ebx
 436:	7e 2a                	jle    462 <printint+0x85>
 438:	8d 7d d8             	lea    -0x28(%ebp),%edi
 43b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 43f:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 442:	0f b6 03             	movzbl (%ebx),%eax
 445:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 448:	83 ec 04             	sub    $0x4,%esp
 44b:	6a 01                	push   $0x1
 44d:	56                   	push   %esi
 44e:	ff 75 c4             	push   -0x3c(%ebp)
 451:	e8 f7 fe ff ff       	call   34d <write>
  while(--i >= 0)
 456:	89 d8                	mov    %ebx,%eax
 458:	83 eb 01             	sub    $0x1,%ebx
 45b:	83 c4 10             	add    $0x10,%esp
 45e:	39 f8                	cmp    %edi,%eax
 460:	75 e0                	jne    442 <printint+0x65>
}
 462:	8d 65 f4             	lea    -0xc(%ebp),%esp
 465:	5b                   	pop    %ebx
 466:	5e                   	pop    %esi
 467:	5f                   	pop    %edi
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    
    x = xx;
 46a:	89 d1                	mov    %edx,%ecx
  neg = 0;
 46c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 473:	eb 8b                	jmp    400 <printint+0x23>

00000475 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	57                   	push   %edi
 479:	56                   	push   %esi
 47a:	53                   	push   %ebx
 47b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 47e:	8b 75 0c             	mov    0xc(%ebp),%esi
 481:	0f b6 1e             	movzbl (%esi),%ebx
 484:	84 db                	test   %bl,%bl
 486:	0f 84 9f 01 00 00    	je     62b <printf+0x1b6>
 48c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 48f:	8d 45 10             	lea    0x10(%ebp),%eax
 492:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 495:	bf 00 00 00 00       	mov    $0x0,%edi
 49a:	eb 2d                	jmp    4c9 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 49c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 49f:	83 ec 04             	sub    $0x4,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	push   0x8(%ebp)
 4ab:	e8 9d fe ff ff       	call   34d <write>
        putc(fd, c);
 4b0:	83 c4 10             	add    $0x10,%esp
 4b3:	eb 05                	jmp    4ba <printf+0x45>
      }
    } else if(state == '%'){
 4b5:	83 ff 25             	cmp    $0x25,%edi
 4b8:	74 1f                	je     4d9 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 4ba:	83 c6 01             	add    $0x1,%esi
 4bd:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4c1:	84 db                	test   %bl,%bl
 4c3:	0f 84 62 01 00 00    	je     62b <printf+0x1b6>
    c = fmt[i] & 0xff;
 4c9:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4cc:	85 ff                	test   %edi,%edi
 4ce:	75 e5                	jne    4b5 <printf+0x40>
      if(c == '%'){
 4d0:	83 f8 25             	cmp    $0x25,%eax
 4d3:	75 c7                	jne    49c <printf+0x27>
        state = '%';
 4d5:	89 c7                	mov    %eax,%edi
 4d7:	eb e1                	jmp    4ba <printf+0x45>
      if(c == 'd'){
 4d9:	83 f8 25             	cmp    $0x25,%eax
 4dc:	0f 84 f2 00 00 00    	je     5d4 <printf+0x15f>
 4e2:	8d 50 9d             	lea    -0x63(%eax),%edx
 4e5:	83 fa 15             	cmp    $0x15,%edx
 4e8:	0f 87 07 01 00 00    	ja     5f5 <printf+0x180>
 4ee:	0f 87 01 01 00 00    	ja     5f5 <printf+0x180>
 4f4:	ff 24 95 ac 07 00 00 	jmp    *0x7ac(,%edx,4)
        printint(fd, *ap, 10, 1);
 4fb:	83 ec 0c             	sub    $0xc,%esp
 4fe:	6a 01                	push   $0x1
 500:	b9 0a 00 00 00       	mov    $0xa,%ecx
 505:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 508:	8b 17                	mov    (%edi),%edx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	e8 cb fe ff ff       	call   3dd <printint>
        ap++;
 512:	89 f8                	mov    %edi,%eax
 514:	83 c0 04             	add    $0x4,%eax
 517:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 51a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51d:	bf 00 00 00 00       	mov    $0x0,%edi
 522:	eb 96                	jmp    4ba <printf+0x45>
        printint(fd, *ap, 16, 0);
 524:	83 ec 0c             	sub    $0xc,%esp
 527:	6a 00                	push   $0x0
 529:	b9 10 00 00 00       	mov    $0x10,%ecx
 52e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 531:	8b 17                	mov    (%edi),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 a2 fe ff ff       	call   3dd <printint>
        ap++;
 53b:	89 f8                	mov    %edi,%eax
 53d:	83 c0 04             	add    $0x4,%eax
 540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 543:	83 c4 10             	add    $0x10,%esp
      state = 0;
 546:	bf 00 00 00 00       	mov    $0x0,%edi
 54b:	e9 6a ff ff ff       	jmp    4ba <printf+0x45>
        s = (char*)*ap;
 550:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 553:	8b 01                	mov    (%ecx),%eax
        ap++;
 555:	83 c1 04             	add    $0x4,%ecx
 558:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 55b:	85 c0                	test   %eax,%eax
 55d:	74 13                	je     572 <printf+0xfd>
        s = (char*)*ap;
 55f:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 561:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 564:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 569:	84 c0                	test   %al,%al
 56b:	75 0f                	jne    57c <printf+0x107>
 56d:	e9 48 ff ff ff       	jmp    4ba <printf+0x45>
          s = "(null)";
 572:	bb a3 07 00 00       	mov    $0x7a3,%ebx
        while(*s != 0){
 577:	b8 28 00 00 00       	mov    $0x28,%eax
 57c:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 57f:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 582:	83 ec 04             	sub    $0x4,%esp
 585:	6a 01                	push   $0x1
 587:	8d 45 e7             	lea    -0x19(%ebp),%eax
 58a:	50                   	push   %eax
 58b:	57                   	push   %edi
 58c:	e8 bc fd ff ff       	call   34d <write>
          s++;
 591:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 594:	0f b6 03             	movzbl (%ebx),%eax
 597:	83 c4 10             	add    $0x10,%esp
 59a:	84 c0                	test   %al,%al
 59c:	75 e1                	jne    57f <printf+0x10a>
      state = 0;
 59e:	bf 00 00 00 00       	mov    $0x0,%edi
 5a3:	e9 12 ff ff ff       	jmp    4ba <printf+0x45>
        putc(fd, *ap);
 5a8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5ab:	8b 07                	mov    (%edi),%eax
 5ad:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	6a 01                	push   $0x1
 5b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	push   0x8(%ebp)
 5bc:	e8 8c fd ff ff       	call   34d <write>
        ap++;
 5c1:	83 c7 04             	add    $0x4,%edi
 5c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5c7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ca:	bf 00 00 00 00       	mov    $0x0,%edi
 5cf:	e9 e6 fe ff ff       	jmp    4ba <printf+0x45>
        putc(fd, c);
 5d4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d7:	83 ec 04             	sub    $0x4,%esp
 5da:	6a 01                	push   $0x1
 5dc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	push   0x8(%ebp)
 5e3:	e8 65 fd ff ff       	call   34d <write>
 5e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5eb:	bf 00 00 00 00       	mov    $0x0,%edi
 5f0:	e9 c5 fe ff ff       	jmp    4ba <printf+0x45>
        putc(fd, '%');
 5f5:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5f9:	83 ec 04             	sub    $0x4,%esp
 5fc:	6a 01                	push   $0x1
 5fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 601:	50                   	push   %eax
 602:	ff 75 08             	push   0x8(%ebp)
 605:	e8 43 fd ff ff       	call   34d <write>
        putc(fd, c);
 60a:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 60d:	83 c4 0c             	add    $0xc,%esp
 610:	6a 01                	push   $0x1
 612:	8d 45 e7             	lea    -0x19(%ebp),%eax
 615:	50                   	push   %eax
 616:	ff 75 08             	push   0x8(%ebp)
 619:	e8 2f fd ff ff       	call   34d <write>
        putc(fd, c);
 61e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 621:	bf 00 00 00 00       	mov    $0x0,%edi
 626:	e9 8f fe ff ff       	jmp    4ba <printf+0x45>
    }
  }
}
 62b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    

00000633 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	57                   	push   %edi
 637:	56                   	push   %esi
 638:	53                   	push   %ebx
 639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63c:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63f:	a1 c0 0c 00 00       	mov    0xcc0,%eax
 644:	eb 0c                	jmp    652 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 646:	8b 10                	mov    (%eax),%edx
 648:	39 c2                	cmp    %eax,%edx
 64a:	77 04                	ja     650 <free+0x1d>
 64c:	39 ca                	cmp    %ecx,%edx
 64e:	77 10                	ja     660 <free+0x2d>
{
 650:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	39 c8                	cmp    %ecx,%eax
 654:	73 f0                	jae    646 <free+0x13>
 656:	8b 10                	mov    (%eax),%edx
 658:	39 ca                	cmp    %ecx,%edx
 65a:	77 04                	ja     660 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	39 c2                	cmp    %eax,%edx
 65e:	77 f0                	ja     650 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 660:	8b 73 fc             	mov    -0x4(%ebx),%esi
 663:	8b 10                	mov    (%eax),%edx
 665:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 668:	39 fa                	cmp    %edi,%edx
 66a:	74 19                	je     685 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 66c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 66f:	8b 50 04             	mov    0x4(%eax),%edx
 672:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 675:	39 f1                	cmp    %esi,%ecx
 677:	74 18                	je     691 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 679:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 67b:	a3 c0 0c 00 00       	mov    %eax,0xcc0
}
 680:	5b                   	pop    %ebx
 681:	5e                   	pop    %esi
 682:	5f                   	pop    %edi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 685:	03 72 04             	add    0x4(%edx),%esi
 688:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 68b:	8b 10                	mov    (%eax),%edx
 68d:	8b 12                	mov    (%edx),%edx
 68f:	eb db                	jmp    66c <free+0x39>
    p->s.size += bp->s.size;
 691:	03 53 fc             	add    -0x4(%ebx),%edx
 694:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 697:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 69a:	eb dd                	jmp    679 <free+0x46>

0000069c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	57                   	push   %edi
 6a0:	56                   	push   %esi
 6a1:	53                   	push   %ebx
 6a2:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	8d 58 07             	lea    0x7(%eax),%ebx
 6ab:	c1 eb 03             	shr    $0x3,%ebx
 6ae:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6b1:	8b 15 c0 0c 00 00    	mov    0xcc0,%edx
 6b7:	85 d2                	test   %edx,%edx
 6b9:	74 1c                	je     6d7 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6bb:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6bd:	8b 48 04             	mov    0x4(%eax),%ecx
 6c0:	39 cb                	cmp    %ecx,%ebx
 6c2:	76 38                	jbe    6fc <malloc+0x60>
 6c4:	be 00 10 00 00       	mov    $0x1000,%esi
 6c9:	39 f3                	cmp    %esi,%ebx
 6cb:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6ce:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6d5:	eb 72                	jmp    749 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 6d7:	c7 05 c0 0c 00 00 c4 	movl   $0xcc4,0xcc0
 6de:	0c 00 00 
 6e1:	c7 05 c4 0c 00 00 c4 	movl   $0xcc4,0xcc4
 6e8:	0c 00 00 
    base.s.size = 0;
 6eb:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
 6f2:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f5:	b8 c4 0c 00 00       	mov    $0xcc4,%eax
 6fa:	eb c8                	jmp    6c4 <malloc+0x28>
      if(p->s.size == nunits)
 6fc:	39 cb                	cmp    %ecx,%ebx
 6fe:	74 1e                	je     71e <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 700:	29 d9                	sub    %ebx,%ecx
 702:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 705:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 708:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 70b:	89 15 c0 0c 00 00    	mov    %edx,0xcc0
      return (void*)(p + 1);
 711:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 714:	89 d0                	mov    %edx,%eax
 716:	8d 65 f4             	lea    -0xc(%ebp),%esp
 719:	5b                   	pop    %ebx
 71a:	5e                   	pop    %esi
 71b:	5f                   	pop    %edi
 71c:	5d                   	pop    %ebp
 71d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 71e:	8b 08                	mov    (%eax),%ecx
 720:	89 0a                	mov    %ecx,(%edx)
 722:	eb e7                	jmp    70b <malloc+0x6f>
  hp->s.size = nu;
 724:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 727:	83 ec 0c             	sub    $0xc,%esp
 72a:	83 c0 08             	add    $0x8,%eax
 72d:	50                   	push   %eax
 72e:	e8 00 ff ff ff       	call   633 <free>
  return freep;
 733:	8b 15 c0 0c 00 00    	mov    0xcc0,%edx
      if((p = morecore(nunits)) == 0)
 739:	83 c4 10             	add    $0x10,%esp
 73c:	85 d2                	test   %edx,%edx
 73e:	74 d4                	je     714 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 740:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 742:	8b 48 04             	mov    0x4(%eax),%ecx
 745:	39 d9                	cmp    %ebx,%ecx
 747:	73 b3                	jae    6fc <malloc+0x60>
    if(p == freep)
 749:	89 c2                	mov    %eax,%edx
 74b:	39 05 c0 0c 00 00    	cmp    %eax,0xcc0
 751:	75 ed                	jne    740 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 753:	83 ec 0c             	sub    $0xc,%esp
 756:	57                   	push   %edi
 757:	e8 59 fc ff ff       	call   3b5 <sbrk>
  if(p == (char*)-1)
 75c:	83 c4 10             	add    $0x10,%esp
 75f:	83 f8 ff             	cmp    $0xffffffff,%eax
 762:	75 c0                	jne    724 <malloc+0x88>
        return 0;
 764:	ba 00 00 00 00       	mov    $0x0,%edx
 769:	eb a9                	jmp    714 <malloc+0x78>
