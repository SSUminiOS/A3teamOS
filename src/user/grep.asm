
user/_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 2c 00 00 00       	call   48 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 18                	jne    3b <matchstar+0x3b>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	0f b6 13             	movzbl (%ebx),%edx
  26:	84 d2                	test   %dl,%dl
  28:	74 16                	je     40 <matchstar+0x40>
  2a:	83 c3 01             	add    $0x1,%ebx
  2d:	83 fe 2e             	cmp    $0x2e,%esi
  30:	74 e0                	je     12 <matchstar+0x12>
  32:	0f be d2             	movsbl %dl,%edx
  35:	39 f2                	cmp    %esi,%edx
  37:	74 d9                	je     12 <matchstar+0x12>
  39:	eb 05                	jmp    40 <matchstar+0x40>
      return 1;
  3b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <matchhere>:
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	53                   	push   %ebx
  4c:	83 ec 04             	sub    $0x4,%esp
  4f:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  52:	0f b6 0a             	movzbl (%edx),%ecx
    return 1;
  55:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '\0')
  5a:	84 c9                	test   %cl,%cl
  5c:	74 29                	je     87 <matchhere+0x3f>
  if(re[1] == '*')
  5e:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  62:	3c 2a                	cmp    $0x2a,%al
  64:	74 26                	je     8c <matchhere+0x44>
  if(re[0] == '$' && re[1] == '\0')
  66:	84 c0                	test   %al,%al
  68:	75 05                	jne    6f <matchhere+0x27>
  6a:	80 f9 24             	cmp    $0x24,%cl
  6d:	74 35                	je     a4 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  72:	0f b6 18             	movzbl (%eax),%ebx
  return 0;
  75:	b8 00 00 00 00       	mov    $0x0,%eax
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  7a:	84 db                	test   %bl,%bl
  7c:	74 09                	je     87 <matchhere+0x3f>
  7e:	38 d9                	cmp    %bl,%cl
  80:	74 30                	je     b2 <matchhere+0x6a>
  82:	80 f9 2e             	cmp    $0x2e,%cl
  85:	74 2b                	je     b2 <matchhere+0x6a>
}
  87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8a:	c9                   	leave  
  8b:	c3                   	ret    
    return matchstar(re[0], re+2, text);
  8c:	83 ec 04             	sub    $0x4,%esp
  8f:	ff 75 0c             	push   0xc(%ebp)
  92:	83 c2 02             	add    $0x2,%edx
  95:	52                   	push   %edx
  96:	0f be c9             	movsbl %cl,%ecx
  99:	51                   	push   %ecx
  9a:	e8 61 ff ff ff       	call   0 <matchstar>
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	eb e3                	jmp    87 <matchhere+0x3f>
    return *text == '\0';
  a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  a7:	80 38 00             	cmpb   $0x0,(%eax)
  aa:	0f 94 c0             	sete   %al
  ad:	0f b6 c0             	movzbl %al,%eax
  b0:	eb d5                	jmp    87 <matchhere+0x3f>
    return matchhere(re+1, text+1);
  b2:	83 ec 08             	sub    $0x8,%esp
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	50                   	push   %eax
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	52                   	push   %edx
  c0:	e8 83 ff ff ff       	call   48 <matchhere>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	eb bd                	jmp    87 <matchhere+0x3f>

000000ca <match>:
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  cd:	56                   	push   %esi
  ce:	53                   	push   %ebx
  cf:	8b 75 08             	mov    0x8(%ebp),%esi
  d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  d5:	80 3e 5e             	cmpb   $0x5e,(%esi)
  d8:	74 1c                	je     f6 <match+0x2c>
    if(matchhere(re, text))
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	53                   	push   %ebx
  de:	56                   	push   %esi
  df:	e8 64 ff ff ff       	call   48 <matchhere>
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	75 1d                	jne    108 <match+0x3e>
  }while(*text++ != '\0');
  eb:	83 c3 01             	add    $0x1,%ebx
  ee:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
  f2:	75 e6                	jne    da <match+0x10>
  f4:	eb 17                	jmp    10d <match+0x43>
    return matchhere(re+1, text);
  f6:	83 ec 08             	sub    $0x8,%esp
  f9:	53                   	push   %ebx
  fa:	83 c6 01             	add    $0x1,%esi
  fd:	56                   	push   %esi
  fe:	e8 45 ff ff ff       	call   48 <matchhere>
 103:	83 c4 10             	add    $0x10,%esp
 106:	eb 05                	jmp    10d <match+0x43>
      return 1;
 108:	b8 01 00 00 00       	mov    $0x1,%eax
}
 10d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 110:	5b                   	pop    %ebx
 111:	5e                   	pop    %esi
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <grep>:
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 1c             	sub    $0x1c,%esp
 11d:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 120:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 127:	eb 53                	jmp    17c <grep+0x68>
      p = q+1;
 129:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 12c:	83 ec 08             	sub    $0x8,%esp
 12f:	6a 0a                	push   $0xa
 131:	56                   	push   %esi
 132:	e8 f0 01 00 00       	call   327 <strchr>
 137:	89 c3                	mov    %eax,%ebx
 139:	83 c4 10             	add    $0x10,%esp
 13c:	85 c0                	test   %eax,%eax
 13e:	74 2d                	je     16d <grep+0x59>
      *q = 0;
 140:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 143:	83 ec 08             	sub    $0x8,%esp
 146:	56                   	push   %esi
 147:	57                   	push   %edi
 148:	e8 7d ff ff ff       	call   ca <match>
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	74 d5                	je     129 <grep+0x15>
        *q = '\n';
 154:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	8d 43 01             	lea    0x1(%ebx),%eax
 15d:	29 f0                	sub    %esi,%eax
 15f:	50                   	push   %eax
 160:	56                   	push   %esi
 161:	6a 01                	push   $0x1
 163:	e8 19 03 00 00       	call   481 <write>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	eb bc                	jmp    129 <grep+0x15>
    if(p == buf)
 16d:	81 fe 60 0c 00 00    	cmp    $0xc60,%esi
 173:	74 62                	je     1d7 <grep+0xc3>
    if(m > 0){
 175:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 178:	85 c9                	test   %ecx,%ecx
 17a:	7f 3b                	jg     1b7 <grep+0xa3>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 17c:	83 ec 04             	sub    $0x4,%esp
 17f:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 184:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 187:	29 c8                	sub    %ecx,%eax
 189:	50                   	push   %eax
 18a:	8d 81 60 0c 00 00    	lea    0xc60(%ecx),%eax
 190:	50                   	push   %eax
 191:	ff 75 0c             	push   0xc(%ebp)
 194:	e8 e0 02 00 00       	call   479 <read>
 199:	83 c4 10             	add    $0x10,%esp
 19c:	85 c0                	test   %eax,%eax
 19e:	7e 40                	jle    1e0 <grep+0xcc>
    m += n;
 1a0:	01 45 e4             	add    %eax,-0x1c(%ebp)
 1a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 1a6:	c6 82 60 0c 00 00 00 	movb   $0x0,0xc60(%edx)
    p = buf;
 1ad:	be 60 0c 00 00       	mov    $0xc60,%esi
    while((q = strchr(p, '\n')) != 0){
 1b2:	e9 75 ff ff ff       	jmp    12c <grep+0x18>
      m -= p - buf;
 1b7:	89 f0                	mov    %esi,%eax
 1b9:	2d 60 0c 00 00       	sub    $0xc60,%eax
 1be:	29 c1                	sub    %eax,%ecx
 1c0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 1c3:	83 ec 04             	sub    $0x4,%esp
 1c6:	51                   	push   %ecx
 1c7:	56                   	push   %esi
 1c8:	68 60 0c 00 00       	push   $0xc60
 1cd:	e8 5a 02 00 00       	call   42c <memmove>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	eb a5                	jmp    17c <grep+0x68>
      m = 0;
 1d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1de:	eb 9c                	jmp    17c <grep+0x68>
}
 1e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e3:	5b                   	pop    %ebx
 1e4:	5e                   	pop    %esi
 1e5:	5f                   	pop    %edi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <main>:
{
 1e8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1ec:	83 e4 f0             	and    $0xfffffff0,%esp
 1ef:	ff 71 fc             	push   -0x4(%ecx)
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	57                   	push   %edi
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	51                   	push   %ecx
 1f9:	83 ec 18             	sub    $0x18,%esp
 1fc:	8b 01                	mov    (%ecx),%eax
 1fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 201:	8b 71 04             	mov    0x4(%ecx),%esi
  if(argc <= 1){
 204:	83 f8 01             	cmp    $0x1,%eax
 207:	7e 53                	jle    25c <main+0x74>
  pattern = argv[1];
 209:	8b 46 04             	mov    0x4(%esi),%eax
 20c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
 20f:	83 c6 08             	add    $0x8,%esi
  for(i = 2; i < argc; i++){
 212:	bf 02 00 00 00       	mov    $0x2,%edi
  if(argc <= 2){
 217:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 21b:	7e 53                	jle    270 <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
 21d:	89 75 dc             	mov    %esi,-0x24(%ebp)
 220:	83 ec 08             	sub    $0x8,%esp
 223:	6a 00                	push   $0x0
 225:	ff 36                	push   (%esi)
 227:	e8 75 02 00 00       	call   4a1 <open>
 22c:	89 c3                	mov    %eax,%ebx
 22e:	83 c4 10             	add    $0x10,%esp
 231:	85 c0                	test   %eax,%eax
 233:	78 4b                	js     280 <main+0x98>
    grep(pattern, fd);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	50                   	push   %eax
 239:	ff 75 e0             	push   -0x20(%ebp)
 23c:	e8 d3 fe ff ff       	call   114 <grep>
    close(fd);
 241:	89 1c 24             	mov    %ebx,(%esp)
 244:	e8 40 02 00 00       	call   489 <close>
  for(i = 2; i < argc; i++){
 249:	83 c7 01             	add    $0x1,%edi
 24c:	83 c6 04             	add    $0x4,%esi
 24f:	83 c4 10             	add    $0x10,%esp
 252:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 255:	75 c6                	jne    21d <main+0x35>
  exit();
 257:	e8 05 02 00 00       	call   461 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 a0 08 00 00       	push   $0x8a0
 264:	6a 02                	push   $0x2
 266:	e8 3e 03 00 00       	call   5a9 <printf>
    exit();
 26b:	e8 f1 01 00 00       	call   461 <exit>
    grep(pattern, 0);
 270:	83 ec 08             	sub    $0x8,%esp
 273:	6a 00                	push   $0x0
 275:	50                   	push   %eax
 276:	e8 99 fe ff ff       	call   114 <grep>
    exit();
 27b:	e8 e1 01 00 00       	call   461 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 280:	83 ec 04             	sub    $0x4,%esp
 283:	8b 45 dc             	mov    -0x24(%ebp),%eax
 286:	ff 30                	push   (%eax)
 288:	68 c0 08 00 00       	push   $0x8c0
 28d:	6a 01                	push   $0x1
 28f:	e8 15 03 00 00       	call   5a9 <printf>
      exit();
 294:	e8 c8 01 00 00       	call   461 <exit>

00000299 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	53                   	push   %ebx
 29d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a3:	b8 00 00 00 00       	mov    $0x0,%eax
 2a8:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2ac:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	84 d2                	test   %dl,%dl
 2b4:	75 f2                	jne    2a8 <strcpy+0xf>
    ;
  return os;
}
 2b6:	89 c8                	mov    %ecx,%eax
 2b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2c6:	0f b6 01             	movzbl (%ecx),%eax
 2c9:	84 c0                	test   %al,%al
 2cb:	74 11                	je     2de <strcmp+0x21>
 2cd:	38 02                	cmp    %al,(%edx)
 2cf:	75 0d                	jne    2de <strcmp+0x21>
    p++, q++;
 2d1:	83 c1 01             	add    $0x1,%ecx
 2d4:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2d7:	0f b6 01             	movzbl (%ecx),%eax
 2da:	84 c0                	test   %al,%al
 2dc:	75 ef                	jne    2cd <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 2de:	0f b6 c0             	movzbl %al,%eax
 2e1:	0f b6 12             	movzbl (%edx),%edx
 2e4:	29 d0                	sub    %edx,%eax
}
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret    

000002e8 <strlen>:

uint
strlen(const char *s)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2ee:	80 3a 00             	cmpb   $0x0,(%edx)
 2f1:	74 14                	je     307 <strlen+0x1f>
 2f3:	b8 00 00 00 00       	mov    $0x0,%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	89 c1                	mov    %eax,%ecx
 2fd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 301:	75 f5                	jne    2f8 <strlen+0x10>
    ;
  return n;
}
 303:	89 c8                	mov    %ecx,%eax
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
  for(n = 0; s[n]; n++)
 307:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 30c:	eb f5                	jmp    303 <strlen+0x1b>

0000030e <memset>:

void*
memset(void *dst, int c, uint n)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	57                   	push   %edi
 312:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 315:	89 d7                	mov    %edx,%edi
 317:	8b 4d 10             	mov    0x10(%ebp),%ecx
 31a:	8b 45 0c             	mov    0xc(%ebp),%eax
 31d:	fc                   	cld    
 31e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 320:	89 d0                	mov    %edx,%eax
 322:	8b 7d fc             	mov    -0x4(%ebp),%edi
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <strchr>:

char*
strchr(const char *s, char c)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 331:	0f b6 10             	movzbl (%eax),%edx
 334:	84 d2                	test   %dl,%dl
 336:	74 15                	je     34d <strchr+0x26>
    if(*s == c)
 338:	38 d1                	cmp    %dl,%cl
 33a:	74 0f                	je     34b <strchr+0x24>
  for(; *s; s++)
 33c:	83 c0 01             	add    $0x1,%eax
 33f:	0f b6 10             	movzbl (%eax),%edx
 342:	84 d2                	test   %dl,%dl
 344:	75 f2                	jne    338 <strchr+0x11>
      return (char*)s;
  return 0;
 346:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
  return 0;
 34d:	b8 00 00 00 00       	mov    $0x0,%eax
 352:	eb f7                	jmp    34b <strchr+0x24>

00000354 <gets>:

char*
gets(char *buf, int max)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 2c             	sub    $0x2c,%esp
 35d:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 360:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 365:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 368:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 36b:	83 c3 01             	add    $0x1,%ebx
 36e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 371:	7d 27                	jge    39a <gets+0x46>
    cc = read(0, &c, 1);
 373:	83 ec 04             	sub    $0x4,%esp
 376:	6a 01                	push   $0x1
 378:	57                   	push   %edi
 379:	6a 00                	push   $0x0
 37b:	e8 f9 00 00 00       	call   479 <read>
    if(cc < 1)
 380:	83 c4 10             	add    $0x10,%esp
 383:	85 c0                	test   %eax,%eax
 385:	7e 13                	jle    39a <gets+0x46>
      break;
    buf[i++] = c;
 387:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 38b:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 38f:	3c 0a                	cmp    $0xa,%al
 391:	74 04                	je     397 <gets+0x43>
 393:	3c 0d                	cmp    $0xd,%al
 395:	75 d1                	jne    368 <gets+0x14>
  for(i=0; i+1 < max; ){
 397:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 39a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 39d:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 3a1:	89 f0                	mov    %esi,%eax
 3a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    

000003ab <stat>:

int
stat(const char *n, struct stat *st)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	56                   	push   %esi
 3af:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	83 ec 08             	sub    $0x8,%esp
 3b3:	6a 00                	push   $0x0
 3b5:	ff 75 08             	push   0x8(%ebp)
 3b8:	e8 e4 00 00 00       	call   4a1 <open>
  if(fd < 0)
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	78 24                	js     3e8 <stat+0x3d>
 3c4:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3c6:	83 ec 08             	sub    $0x8,%esp
 3c9:	ff 75 0c             	push   0xc(%ebp)
 3cc:	50                   	push   %eax
 3cd:	e8 e7 00 00 00       	call   4b9 <fstat>
 3d2:	89 c6                	mov    %eax,%esi
  close(fd);
 3d4:	89 1c 24             	mov    %ebx,(%esp)
 3d7:	e8 ad 00 00 00       	call   489 <close>
  return r;
 3dc:	83 c4 10             	add    $0x10,%esp
}
 3df:	89 f0                	mov    %esi,%eax
 3e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3e4:	5b                   	pop    %ebx
 3e5:	5e                   	pop    %esi
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
    return -1;
 3e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ed:	eb f0                	jmp    3df <stat+0x34>

000003ef <atoi>:

int
atoi(const char *s)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	53                   	push   %ebx
 3f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f6:	0f b6 02             	movzbl (%edx),%eax
 3f9:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3fc:	80 f9 09             	cmp    $0x9,%cl
 3ff:	77 24                	ja     425 <atoi+0x36>
  n = 0;
 401:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 406:	83 c2 01             	add    $0x1,%edx
 409:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 40c:	0f be c0             	movsbl %al,%eax
 40f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 413:	0f b6 02             	movzbl (%edx),%eax
 416:	8d 58 d0             	lea    -0x30(%eax),%ebx
 419:	80 fb 09             	cmp    $0x9,%bl
 41c:	76 e8                	jbe    406 <atoi+0x17>
  return n;
}
 41e:	89 c8                	mov    %ecx,%eax
 420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 423:	c9                   	leave  
 424:	c3                   	ret    
  n = 0;
 425:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 42a:	eb f2                	jmp    41e <atoi+0x2f>

0000042c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	56                   	push   %esi
 430:	53                   	push   %ebx
 431:	8b 75 08             	mov    0x8(%ebp),%esi
 434:	8b 55 0c             	mov    0xc(%ebp),%edx
 437:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43a:	85 db                	test   %ebx,%ebx
 43c:	7e 15                	jle    453 <memmove+0x27>
 43e:	01 f3                	add    %esi,%ebx
  dst = vdst;
 440:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 442:	83 c2 01             	add    $0x1,%edx
 445:	83 c0 01             	add    $0x1,%eax
 448:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 44c:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 44f:	39 c3                	cmp    %eax,%ebx
 451:	75 ef                	jne    442 <memmove+0x16>
  return vdst;
}
 453:	89 f0                	mov    %esi,%eax
 455:	5b                   	pop    %ebx
 456:	5e                   	pop    %esi
 457:	5d                   	pop    %ebp
 458:	c3                   	ret    

00000459 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 459:	b8 01 00 00 00       	mov    $0x1,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <exit>:
SYSCALL(exit)
 461:	b8 02 00 00 00       	mov    $0x2,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <wait>:
SYSCALL(wait)
 469:	b8 03 00 00 00       	mov    $0x3,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <pipe>:
SYSCALL(pipe)
 471:	b8 04 00 00 00       	mov    $0x4,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <read>:
SYSCALL(read)
 479:	b8 05 00 00 00       	mov    $0x5,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <write>:
SYSCALL(write)
 481:	b8 10 00 00 00       	mov    $0x10,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <close>:
SYSCALL(close)
 489:	b8 15 00 00 00       	mov    $0x15,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <kill>:
SYSCALL(kill)
 491:	b8 06 00 00 00       	mov    $0x6,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <exec>:
SYSCALL(exec)
 499:	b8 07 00 00 00       	mov    $0x7,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <open>:
SYSCALL(open)
 4a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <mknod>:
SYSCALL(mknod)
 4a9:	b8 11 00 00 00       	mov    $0x11,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <unlink>:
SYSCALL(unlink)
 4b1:	b8 12 00 00 00       	mov    $0x12,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <fstat>:
SYSCALL(fstat)
 4b9:	b8 08 00 00 00       	mov    $0x8,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <link>:
SYSCALL(link)
 4c1:	b8 13 00 00 00       	mov    $0x13,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <mkdir>:
SYSCALL(mkdir)
 4c9:	b8 14 00 00 00       	mov    $0x14,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <chdir>:
SYSCALL(chdir)
 4d1:	b8 09 00 00 00       	mov    $0x9,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <dup>:
SYSCALL(dup)
 4d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <getpid>:
SYSCALL(getpid)
 4e1:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sbrk>:
SYSCALL(sbrk)
 4e9:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <sleep>:
SYSCALL(sleep)
 4f1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <uptime>:
SYSCALL(uptime)
 4f9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <slabtest>:
SYSCALL(slabtest)
 501:	b8 16 00 00 00       	mov    $0x16,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <ps>:
SYSCALL(ps)
 509:	b8 17 00 00 00       	mov    $0x17,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	57                   	push   %edi
 515:	56                   	push   %esi
 516:	53                   	push   %ebx
 517:	83 ec 3c             	sub    $0x3c,%esp
 51a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 51d:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 523:	74 79                	je     59e <printint+0x8d>
 525:	85 d2                	test   %edx,%edx
 527:	79 75                	jns    59e <printint+0x8d>
    neg = 1;
    x = -xx;
 529:	89 d1                	mov    %edx,%ecx
 52b:	f7 d9                	neg    %ecx
    neg = 1;
 52d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 534:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 539:	89 df                	mov    %ebx,%edi
 53b:	83 c3 01             	add    $0x1,%ebx
 53e:	89 c8                	mov    %ecx,%eax
 540:	ba 00 00 00 00       	mov    $0x0,%edx
 545:	f7 f6                	div    %esi
 547:	0f b6 92 38 09 00 00 	movzbl 0x938(%edx),%edx
 54e:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 552:	89 ca                	mov    %ecx,%edx
 554:	89 c1                	mov    %eax,%ecx
 556:	39 d6                	cmp    %edx,%esi
 558:	76 df                	jbe    539 <printint+0x28>
  if(neg)
 55a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 55e:	74 08                	je     568 <printint+0x57>
    buf[i++] = '-';
 560:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 565:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 568:	85 db                	test   %ebx,%ebx
 56a:	7e 2a                	jle    596 <printint+0x85>
 56c:	8d 7d d8             	lea    -0x28(%ebp),%edi
 56f:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 573:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 576:	0f b6 03             	movzbl (%ebx),%eax
 579:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 57c:	83 ec 04             	sub    $0x4,%esp
 57f:	6a 01                	push   $0x1
 581:	56                   	push   %esi
 582:	ff 75 c4             	push   -0x3c(%ebp)
 585:	e8 f7 fe ff ff       	call   481 <write>
  while(--i >= 0)
 58a:	89 d8                	mov    %ebx,%eax
 58c:	83 eb 01             	sub    $0x1,%ebx
 58f:	83 c4 10             	add    $0x10,%esp
 592:	39 f8                	cmp    %edi,%eax
 594:	75 e0                	jne    576 <printint+0x65>
}
 596:	8d 65 f4             	lea    -0xc(%ebp),%esp
 599:	5b                   	pop    %ebx
 59a:	5e                   	pop    %esi
 59b:	5f                   	pop    %edi
 59c:	5d                   	pop    %ebp
 59d:	c3                   	ret    
    x = xx;
 59e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 5a0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 5a7:	eb 8b                	jmp    534 <printint+0x23>

000005a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	57                   	push   %edi
 5ad:	56                   	push   %esi
 5ae:	53                   	push   %ebx
 5af:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b2:	8b 75 0c             	mov    0xc(%ebp),%esi
 5b5:	0f b6 1e             	movzbl (%esi),%ebx
 5b8:	84 db                	test   %bl,%bl
 5ba:	0f 84 9f 01 00 00    	je     75f <printf+0x1b6>
 5c0:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 5c3:	8d 45 10             	lea    0x10(%ebp),%eax
 5c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 5c9:	bf 00 00 00 00       	mov    $0x0,%edi
 5ce:	eb 2d                	jmp    5fd <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	6a 01                	push   $0x1
 5d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	push   0x8(%ebp)
 5df:	e8 9d fe ff ff       	call   481 <write>
        putc(fd, c);
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	eb 05                	jmp    5ee <printf+0x45>
      }
    } else if(state == '%'){
 5e9:	83 ff 25             	cmp    $0x25,%edi
 5ec:	74 1f                	je     60d <printf+0x64>
  for(i = 0; fmt[i]; i++){
 5ee:	83 c6 01             	add    $0x1,%esi
 5f1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5f5:	84 db                	test   %bl,%bl
 5f7:	0f 84 62 01 00 00    	je     75f <printf+0x1b6>
    c = fmt[i] & 0xff;
 5fd:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 600:	85 ff                	test   %edi,%edi
 602:	75 e5                	jne    5e9 <printf+0x40>
      if(c == '%'){
 604:	83 f8 25             	cmp    $0x25,%eax
 607:	75 c7                	jne    5d0 <printf+0x27>
        state = '%';
 609:	89 c7                	mov    %eax,%edi
 60b:	eb e1                	jmp    5ee <printf+0x45>
      if(c == 'd'){
 60d:	83 f8 25             	cmp    $0x25,%eax
 610:	0f 84 f2 00 00 00    	je     708 <printf+0x15f>
 616:	8d 50 9d             	lea    -0x63(%eax),%edx
 619:	83 fa 15             	cmp    $0x15,%edx
 61c:	0f 87 07 01 00 00    	ja     729 <printf+0x180>
 622:	0f 87 01 01 00 00    	ja     729 <printf+0x180>
 628:	ff 24 95 e0 08 00 00 	jmp    *0x8e0(,%edx,4)
        printint(fd, *ap, 10, 1);
 62f:	83 ec 0c             	sub    $0xc,%esp
 632:	6a 01                	push   $0x1
 634:	b9 0a 00 00 00       	mov    $0xa,%ecx
 639:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 63c:	8b 17                	mov    (%edi),%edx
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	e8 cb fe ff ff       	call   511 <printint>
        ap++;
 646:	89 f8                	mov    %edi,%eax
 648:	83 c0 04             	add    $0x4,%eax
 64b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 64e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 651:	bf 00 00 00 00       	mov    $0x0,%edi
 656:	eb 96                	jmp    5ee <printf+0x45>
        printint(fd, *ap, 16, 0);
 658:	83 ec 0c             	sub    $0xc,%esp
 65b:	6a 00                	push   $0x0
 65d:	b9 10 00 00 00       	mov    $0x10,%ecx
 662:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 665:	8b 17                	mov    (%edi),%edx
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	e8 a2 fe ff ff       	call   511 <printint>
        ap++;
 66f:	89 f8                	mov    %edi,%eax
 671:	83 c0 04             	add    $0x4,%eax
 674:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 677:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67a:	bf 00 00 00 00       	mov    $0x0,%edi
 67f:	e9 6a ff ff ff       	jmp    5ee <printf+0x45>
        s = (char*)*ap;
 684:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 687:	8b 01                	mov    (%ecx),%eax
        ap++;
 689:	83 c1 04             	add    $0x4,%ecx
 68c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 68f:	85 c0                	test   %eax,%eax
 691:	74 13                	je     6a6 <printf+0xfd>
        s = (char*)*ap;
 693:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 695:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 698:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 69d:	84 c0                	test   %al,%al
 69f:	75 0f                	jne    6b0 <printf+0x107>
 6a1:	e9 48 ff ff ff       	jmp    5ee <printf+0x45>
          s = "(null)";
 6a6:	bb d6 08 00 00       	mov    $0x8d6,%ebx
        while(*s != 0){
 6ab:	b8 28 00 00 00       	mov    $0x28,%eax
 6b0:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 6b3:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6b6:	83 ec 04             	sub    $0x4,%esp
 6b9:	6a 01                	push   $0x1
 6bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6be:	50                   	push   %eax
 6bf:	57                   	push   %edi
 6c0:	e8 bc fd ff ff       	call   481 <write>
          s++;
 6c5:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 6c8:	0f b6 03             	movzbl (%ebx),%eax
 6cb:	83 c4 10             	add    $0x10,%esp
 6ce:	84 c0                	test   %al,%al
 6d0:	75 e1                	jne    6b3 <printf+0x10a>
      state = 0;
 6d2:	bf 00 00 00 00       	mov    $0x0,%edi
 6d7:	e9 12 ff ff ff       	jmp    5ee <printf+0x45>
        putc(fd, *ap);
 6dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6df:	8b 07                	mov    (%edi),%eax
 6e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e4:	83 ec 04             	sub    $0x4,%esp
 6e7:	6a 01                	push   $0x1
 6e9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6ec:	50                   	push   %eax
 6ed:	ff 75 08             	push   0x8(%ebp)
 6f0:	e8 8c fd ff ff       	call   481 <write>
        ap++;
 6f5:	83 c7 04             	add    $0x4,%edi
 6f8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6fb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fe:	bf 00 00 00 00       	mov    $0x0,%edi
 703:	e9 e6 fe ff ff       	jmp    5ee <printf+0x45>
        putc(fd, c);
 708:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 70b:	83 ec 04             	sub    $0x4,%esp
 70e:	6a 01                	push   $0x1
 710:	8d 45 e7             	lea    -0x19(%ebp),%eax
 713:	50                   	push   %eax
 714:	ff 75 08             	push   0x8(%ebp)
 717:	e8 65 fd ff ff       	call   481 <write>
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	bf 00 00 00 00       	mov    $0x0,%edi
 724:	e9 c5 fe ff ff       	jmp    5ee <printf+0x45>
        putc(fd, '%');
 729:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 72d:	83 ec 04             	sub    $0x4,%esp
 730:	6a 01                	push   $0x1
 732:	8d 45 e7             	lea    -0x19(%ebp),%eax
 735:	50                   	push   %eax
 736:	ff 75 08             	push   0x8(%ebp)
 739:	e8 43 fd ff ff       	call   481 <write>
        putc(fd, c);
 73e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 741:	83 c4 0c             	add    $0xc,%esp
 744:	6a 01                	push   $0x1
 746:	8d 45 e7             	lea    -0x19(%ebp),%eax
 749:	50                   	push   %eax
 74a:	ff 75 08             	push   0x8(%ebp)
 74d:	e8 2f fd ff ff       	call   481 <write>
        putc(fd, c);
 752:	83 c4 10             	add    $0x10,%esp
      state = 0;
 755:	bf 00 00 00 00       	mov    $0x0,%edi
 75a:	e9 8f fe ff ff       	jmp    5ee <printf+0x45>
    }
  }
}
 75f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5f                   	pop    %edi
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    

00000767 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 767:	55                   	push   %ebp
 768:	89 e5                	mov    %esp,%ebp
 76a:	57                   	push   %edi
 76b:	56                   	push   %esi
 76c:	53                   	push   %ebx
 76d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 770:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 773:	a1 60 10 00 00       	mov    0x1060,%eax
 778:	eb 0c                	jmp    786 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	8b 10                	mov    (%eax),%edx
 77c:	39 c2                	cmp    %eax,%edx
 77e:	77 04                	ja     784 <free+0x1d>
 780:	39 ca                	cmp    %ecx,%edx
 782:	77 10                	ja     794 <free+0x2d>
{
 784:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	39 c8                	cmp    %ecx,%eax
 788:	73 f0                	jae    77a <free+0x13>
 78a:	8b 10                	mov    (%eax),%edx
 78c:	39 ca                	cmp    %ecx,%edx
 78e:	77 04                	ja     794 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 c2                	cmp    %eax,%edx
 792:	77 f0                	ja     784 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 794:	8b 73 fc             	mov    -0x4(%ebx),%esi
 797:	8b 10                	mov    (%eax),%edx
 799:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 79c:	39 fa                	cmp    %edi,%edx
 79e:	74 19                	je     7b9 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a3:	8b 50 04             	mov    0x4(%eax),%edx
 7a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a9:	39 f1                	cmp    %esi,%ecx
 7ab:	74 18                	je     7c5 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ad:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 7af:	a3 60 10 00 00       	mov    %eax,0x1060
}
 7b4:	5b                   	pop    %ebx
 7b5:	5e                   	pop    %esi
 7b6:	5f                   	pop    %edi
 7b7:	5d                   	pop    %ebp
 7b8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7b9:	03 72 04             	add    0x4(%edx),%esi
 7bc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7bf:	8b 10                	mov    (%eax),%edx
 7c1:	8b 12                	mov    (%edx),%edx
 7c3:	eb db                	jmp    7a0 <free+0x39>
    p->s.size += bp->s.size;
 7c5:	03 53 fc             	add    -0x4(%ebx),%edx
 7c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7cb:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7ce:	eb dd                	jmp    7ad <free+0x46>

000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	8d 58 07             	lea    0x7(%eax),%ebx
 7df:	c1 eb 03             	shr    $0x3,%ebx
 7e2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7e5:	8b 15 60 10 00 00    	mov    0x1060,%edx
 7eb:	85 d2                	test   %edx,%edx
 7ed:	74 1c                	je     80b <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f1:	8b 48 04             	mov    0x4(%eax),%ecx
 7f4:	39 cb                	cmp    %ecx,%ebx
 7f6:	76 38                	jbe    830 <malloc+0x60>
 7f8:	be 00 10 00 00       	mov    $0x1000,%esi
 7fd:	39 f3                	cmp    %esi,%ebx
 7ff:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 802:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 809:	eb 72                	jmp    87d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 80b:	c7 05 60 10 00 00 64 	movl   $0x1064,0x1060
 812:	10 00 00 
 815:	c7 05 64 10 00 00 64 	movl   $0x1064,0x1064
 81c:	10 00 00 
    base.s.size = 0;
 81f:	c7 05 68 10 00 00 00 	movl   $0x0,0x1068
 826:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	b8 64 10 00 00       	mov    $0x1064,%eax
 82e:	eb c8                	jmp    7f8 <malloc+0x28>
      if(p->s.size == nunits)
 830:	39 cb                	cmp    %ecx,%ebx
 832:	74 1e                	je     852 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 834:	29 d9                	sub    %ebx,%ecx
 836:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 839:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 83c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 83f:	89 15 60 10 00 00    	mov    %edx,0x1060
      return (void*)(p + 1);
 845:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 848:	89 d0                	mov    %edx,%eax
 84a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5f                   	pop    %edi
 850:	5d                   	pop    %ebp
 851:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 852:	8b 08                	mov    (%eax),%ecx
 854:	89 0a                	mov    %ecx,(%edx)
 856:	eb e7                	jmp    83f <malloc+0x6f>
  hp->s.size = nu;
 858:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 85b:	83 ec 0c             	sub    $0xc,%esp
 85e:	83 c0 08             	add    $0x8,%eax
 861:	50                   	push   %eax
 862:	e8 00 ff ff ff       	call   767 <free>
  return freep;
 867:	8b 15 60 10 00 00    	mov    0x1060,%edx
      if((p = morecore(nunits)) == 0)
 86d:	83 c4 10             	add    $0x10,%esp
 870:	85 d2                	test   %edx,%edx
 872:	74 d4                	je     848 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 876:	8b 48 04             	mov    0x4(%eax),%ecx
 879:	39 d9                	cmp    %ebx,%ecx
 87b:	73 b3                	jae    830 <malloc+0x60>
    if(p == freep)
 87d:	89 c2                	mov    %eax,%edx
 87f:	39 05 60 10 00 00    	cmp    %eax,0x1060
 885:	75 ed                	jne    874 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 887:	83 ec 0c             	sub    $0xc,%esp
 88a:	57                   	push   %edi
 88b:	e8 59 fc ff ff       	call   4e9 <sbrk>
  if(p == (char*)-1)
 890:	83 c4 10             	add    $0x10,%esp
 893:	83 f8 ff             	cmp    $0xffffffff,%eax
 896:	75 c0                	jne    858 <malloc+0x88>
        return 0;
 898:	ba 00 00 00 00       	mov    $0x0,%edx
 89d:	eb a9                	jmp    848 <malloc+0x78>
