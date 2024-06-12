
user/_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 11 03 00 00       	call   322 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	01 d8                	add    %ebx,%eax
  16:	72 0c                	jb     24 <fmtname+0x24>
  18:	80 38 2f             	cmpb   $0x2f,(%eax)
  1b:	74 07                	je     24 <fmtname+0x24>
  1d:	83 e8 01             	sub    $0x1,%eax
  20:	39 c3                	cmp    %eax,%ebx
  22:	76 f4                	jbe    18 <fmtname+0x18>
    ;
  p++;
  24:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	53                   	push   %ebx
  2b:	e8 f2 02 00 00       	call   322 <strlen>
  30:	83 c4 10             	add    $0x10,%esp
  33:	83 f8 0d             	cmp    $0xd,%eax
  36:	76 09                	jbe    41 <fmtname+0x41>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  38:	89 d8                	mov    %ebx,%eax
  3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3d:	5b                   	pop    %ebx
  3e:	5e                   	pop    %esi
  3f:	5d                   	pop    %ebp
  40:	c3                   	ret    
  memmove(buf, p, strlen(p));
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	53                   	push   %ebx
  45:	e8 d8 02 00 00       	call   322 <strlen>
  4a:	83 c4 0c             	add    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	53                   	push   %ebx
  4f:	68 58 0c 00 00       	push   $0xc58
  54:	e8 0d 04 00 00       	call   466 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  59:	89 1c 24             	mov    %ebx,(%esp)
  5c:	e8 c1 02 00 00       	call   322 <strlen>
  61:	89 c6                	mov    %eax,%esi
  63:	89 1c 24             	mov    %ebx,(%esp)
  66:	e8 b7 02 00 00       	call   322 <strlen>
  6b:	83 c4 0c             	add    $0xc,%esp
  6e:	ba 0e 00 00 00       	mov    $0xe,%edx
  73:	29 f2                	sub    %esi,%edx
  75:	52                   	push   %edx
  76:	6a 20                	push   $0x20
  78:	05 58 0c 00 00       	add    $0xc58,%eax
  7d:	50                   	push   %eax
  7e:	e8 c5 02 00 00       	call   348 <memset>
  return buf;
  83:	83 c4 10             	add    $0x10,%esp
  86:	bb 58 0c 00 00       	mov    $0xc58,%ebx
  8b:	eb ab                	jmp    38 <fmtname+0x38>

0000008d <ls>:

void
ls(char *path)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	57                   	push   %edi
  91:	56                   	push   %esi
  92:	53                   	push   %ebx
  93:	81 ec 54 02 00 00    	sub    $0x254,%esp
  99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  9c:	6a 00                	push   $0x0
  9e:	53                   	push   %ebx
  9f:	e8 37 04 00 00       	call   4db <open>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	85 c0                	test   %eax,%eax
  a9:	78 7b                	js     126 <ls+0x99>
  ab:	89 c6                	mov    %eax,%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  b6:	50                   	push   %eax
  b7:	56                   	push   %esi
  b8:	e8 36 04 00 00       	call   4f3 <fstat>
  bd:	83 c4 10             	add    $0x10,%esp
  c0:	85 c0                	test   %eax,%eax
  c2:	78 77                	js     13b <ls+0xae>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c4:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
  cb:	66 83 f8 01          	cmp    $0x1,%ax
  cf:	0f 84 83 00 00 00    	je     158 <ls+0xcb>
  d5:	66 83 f8 02          	cmp    $0x2,%ax
  d9:	75 37                	jne    112 <ls+0x85>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  db:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
  e1:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
  e7:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  ed:	83 ec 0c             	sub    $0xc,%esp
  f0:	53                   	push   %ebx
  f1:	e8 0a ff ff ff       	call   0 <fmtname>
  f6:	83 c4 08             	add    $0x8,%esp
  f9:	57                   	push   %edi
  fa:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 100:	6a 02                	push   $0x2
 102:	50                   	push   %eax
 103:	68 04 09 00 00       	push   $0x904
 108:	6a 01                	push   $0x1
 10a:	e8 d4 04 00 00       	call   5e3 <printf>
    break;
 10f:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 112:	83 ec 0c             	sub    $0xc,%esp
 115:	56                   	push   %esi
 116:	e8 a8 03 00 00       	call   4c3 <close>
 11b:	83 c4 10             	add    $0x10,%esp
}
 11e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 121:	5b                   	pop    %ebx
 122:	5e                   	pop    %esi
 123:	5f                   	pop    %edi
 124:	5d                   	pop    %ebp
 125:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 126:	83 ec 04             	sub    $0x4,%esp
 129:	53                   	push   %ebx
 12a:	68 dc 08 00 00       	push   $0x8dc
 12f:	6a 02                	push   $0x2
 131:	e8 ad 04 00 00       	call   5e3 <printf>
    return;
 136:	83 c4 10             	add    $0x10,%esp
 139:	eb e3                	jmp    11e <ls+0x91>
    printf(2, "ls: cannot stat %s\n", path);
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	53                   	push   %ebx
 13f:	68 f0 08 00 00       	push   $0x8f0
 144:	6a 02                	push   $0x2
 146:	e8 98 04 00 00       	call   5e3 <printf>
    close(fd);
 14b:	89 34 24             	mov    %esi,(%esp)
 14e:	e8 70 03 00 00       	call   4c3 <close>
    return;
 153:	83 c4 10             	add    $0x10,%esp
 156:	eb c6                	jmp    11e <ls+0x91>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 158:	83 ec 0c             	sub    $0xc,%esp
 15b:	53                   	push   %ebx
 15c:	e8 c1 01 00 00       	call   322 <strlen>
 161:	83 c0 10             	add    $0x10,%eax
 164:	83 c4 10             	add    $0x10,%esp
 167:	3d 00 02 00 00       	cmp    $0x200,%eax
 16c:	76 14                	jbe    182 <ls+0xf5>
      printf(1, "ls: path too long\n");
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	68 11 09 00 00       	push   $0x911
 176:	6a 01                	push   $0x1
 178:	e8 66 04 00 00       	call   5e3 <printf>
      break;
 17d:	83 c4 10             	add    $0x10,%esp
 180:	eb 90                	jmp    112 <ls+0x85>
    strcpy(buf, path);
 182:	83 ec 08             	sub    $0x8,%esp
 185:	53                   	push   %ebx
 186:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 18c:	57                   	push   %edi
 18d:	e8 41 01 00 00       	call   2d3 <strcpy>
    p = buf+strlen(buf);
 192:	89 3c 24             	mov    %edi,(%esp)
 195:	e8 88 01 00 00       	call   322 <strlen>
 19a:	01 c7                	add    %eax,%edi
    *p++ = '/';
 19c:	8d 47 01             	lea    0x1(%edi),%eax
 19f:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
 1a5:	c6 07 2f             	movb   $0x2f,(%edi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
 1b1:	eb 19                	jmp    1cc <ls+0x13f>
        printf(1, "ls: cannot stat %s\n", buf);
 1b3:	83 ec 04             	sub    $0x4,%esp
 1b6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1bc:	50                   	push   %eax
 1bd:	68 f0 08 00 00       	push   $0x8f0
 1c2:	6a 01                	push   $0x1
 1c4:	e8 1a 04 00 00       	call   5e3 <printf>
        continue;
 1c9:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1cc:	83 ec 04             	sub    $0x4,%esp
 1cf:	6a 10                	push   $0x10
 1d1:	53                   	push   %ebx
 1d2:	56                   	push   %esi
 1d3:	e8 db 02 00 00       	call   4b3 <read>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	83 f8 10             	cmp    $0x10,%eax
 1de:	0f 85 2e ff ff ff    	jne    112 <ls+0x85>
      if(de.inum == 0)
 1e4:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1eb:	00 
 1ec:	74 de                	je     1cc <ls+0x13f>
      memmove(p, de.name, DIRSIZ);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 0e                	push   $0xe
 1f3:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 1f9:	50                   	push   %eax
 1fa:	ff b5 a8 fd ff ff    	push   -0x258(%ebp)
 200:	e8 61 02 00 00       	call   466 <memmove>
      p[DIRSIZ] = 0;
 205:	c6 47 0f 00          	movb   $0x0,0xf(%edi)
      if(stat(buf, &st) < 0){
 209:	83 c4 08             	add    $0x8,%esp
 20c:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 212:	50                   	push   %eax
 213:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 219:	50                   	push   %eax
 21a:	e8 c6 01 00 00       	call   3e5 <stat>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	85 c0                	test   %eax,%eax
 224:	78 8d                	js     1b3 <ls+0x126>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 226:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 22c:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 232:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 238:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 23e:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
 245:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 24b:	83 ec 0c             	sub    $0xc,%esp
 24e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 254:	50                   	push   %eax
 255:	e8 a6 fd ff ff       	call   0 <fmtname>
 25a:	83 c4 08             	add    $0x8,%esp
 25d:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 263:	ff b5 b0 fd ff ff    	push   -0x250(%ebp)
 269:	ff b5 ac fd ff ff    	push   -0x254(%ebp)
 26f:	50                   	push   %eax
 270:	68 04 09 00 00       	push   $0x904
 275:	6a 01                	push   $0x1
 277:	e8 67 03 00 00       	call   5e3 <printf>
 27c:	83 c4 20             	add    $0x20,%esp
 27f:	e9 48 ff ff ff       	jmp    1cc <ls+0x13f>

00000284 <main>:

int
main(int argc, char *argv[])
{
 284:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 288:	83 e4 f0             	and    $0xfffffff0,%esp
 28b:	ff 71 fc             	push   -0x4(%ecx)
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	57                   	push   %edi
 292:	56                   	push   %esi
 293:	53                   	push   %ebx
 294:	51                   	push   %ecx
 295:	83 ec 08             	sub    $0x8,%esp
 298:	8b 31                	mov    (%ecx),%esi
 29a:	8b 79 04             	mov    0x4(%ecx),%edi

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 29d:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(argc < 2){
 2a2:	83 fe 01             	cmp    $0x1,%esi
 2a5:	7e 1a                	jle    2c1 <main+0x3d>
    ls(argv[i]);
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	ff 34 9f             	push   (%edi,%ebx,4)
 2ad:	e8 db fd ff ff       	call   8d <ls>
  for(i=1; i<argc; i++)
 2b2:	83 c3 01             	add    $0x1,%ebx
 2b5:	83 c4 10             	add    $0x10,%esp
 2b8:	39 de                	cmp    %ebx,%esi
 2ba:	75 eb                	jne    2a7 <main+0x23>
  exit();
 2bc:	e8 da 01 00 00       	call   49b <exit>
    ls(".");
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	68 24 09 00 00       	push   $0x924
 2c9:	e8 bf fd ff ff       	call   8d <ls>
    exit();
 2ce:	e8 c8 01 00 00       	call   49b <exit>

000002d3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	53                   	push   %ebx
 2d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2dd:	b8 00 00 00 00       	mov    $0x0,%eax
 2e2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2e6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2e9:	83 c0 01             	add    $0x1,%eax
 2ec:	84 d2                	test   %dl,%dl
 2ee:	75 f2                	jne    2e2 <strcpy+0xf>
    ;
  return os;
}
 2f0:	89 c8                	mov    %ecx,%eax
 2f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f5:	c9                   	leave  
 2f6:	c3                   	ret    

000002f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp
 2fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 300:	0f b6 01             	movzbl (%ecx),%eax
 303:	84 c0                	test   %al,%al
 305:	74 11                	je     318 <strcmp+0x21>
 307:	38 02                	cmp    %al,(%edx)
 309:	75 0d                	jne    318 <strcmp+0x21>
    p++, q++;
 30b:	83 c1 01             	add    $0x1,%ecx
 30e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 311:	0f b6 01             	movzbl (%ecx),%eax
 314:	84 c0                	test   %al,%al
 316:	75 ef                	jne    307 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 318:	0f b6 c0             	movzbl %al,%eax
 31b:	0f b6 12             	movzbl (%edx),%edx
 31e:	29 d0                	sub    %edx,%eax
}
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    

00000322 <strlen>:

uint
strlen(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 328:	80 3a 00             	cmpb   $0x0,(%edx)
 32b:	74 14                	je     341 <strlen+0x1f>
 32d:	b8 00 00 00 00       	mov    $0x0,%eax
 332:	83 c0 01             	add    $0x1,%eax
 335:	89 c1                	mov    %eax,%ecx
 337:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 33b:	75 f5                	jne    332 <strlen+0x10>
    ;
  return n;
}
 33d:	89 c8                	mov    %ecx,%eax
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    
  for(n = 0; s[n]; n++)
 341:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 346:	eb f5                	jmp    33d <strlen+0x1b>

00000348 <memset>:

void*
memset(void *dst, int c, uint n)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 34f:	89 d7                	mov    %edx,%edi
 351:	8b 4d 10             	mov    0x10(%ebp),%ecx
 354:	8b 45 0c             	mov    0xc(%ebp),%eax
 357:	fc                   	cld    
 358:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 35a:	89 d0                	mov    %edx,%eax
 35c:	8b 7d fc             	mov    -0x4(%ebp),%edi
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <strchr>:

char*
strchr(const char *s, char c)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 36b:	0f b6 10             	movzbl (%eax),%edx
 36e:	84 d2                	test   %dl,%dl
 370:	74 15                	je     387 <strchr+0x26>
    if(*s == c)
 372:	38 d1                	cmp    %dl,%cl
 374:	74 0f                	je     385 <strchr+0x24>
  for(; *s; s++)
 376:	83 c0 01             	add    $0x1,%eax
 379:	0f b6 10             	movzbl (%eax),%edx
 37c:	84 d2                	test   %dl,%dl
 37e:	75 f2                	jne    372 <strchr+0x11>
      return (char*)s;
  return 0;
 380:	b8 00 00 00 00       	mov    $0x0,%eax
}
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
  return 0;
 387:	b8 00 00 00 00       	mov    $0x0,%eax
 38c:	eb f7                	jmp    385 <strchr+0x24>

0000038e <gets>:

char*
gets(char *buf, int max)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	57                   	push   %edi
 392:	56                   	push   %esi
 393:	53                   	push   %ebx
 394:	83 ec 2c             	sub    $0x2c,%esp
 397:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39a:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 39f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3a2:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 3a5:	83 c3 01             	add    $0x1,%ebx
 3a8:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ab:	7d 27                	jge    3d4 <gets+0x46>
    cc = read(0, &c, 1);
 3ad:	83 ec 04             	sub    $0x4,%esp
 3b0:	6a 01                	push   $0x1
 3b2:	57                   	push   %edi
 3b3:	6a 00                	push   $0x0
 3b5:	e8 f9 00 00 00       	call   4b3 <read>
    if(cc < 1)
 3ba:	83 c4 10             	add    $0x10,%esp
 3bd:	85 c0                	test   %eax,%eax
 3bf:	7e 13                	jle    3d4 <gets+0x46>
      break;
    buf[i++] = c;
 3c1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3c5:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 3c9:	3c 0a                	cmp    $0xa,%al
 3cb:	74 04                	je     3d1 <gets+0x43>
 3cd:	3c 0d                	cmp    $0xd,%al
 3cf:	75 d1                	jne    3a2 <gets+0x14>
  for(i=0; i+1 < max; ){
 3d1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 3d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3d7:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 3db:	89 f0                	mov    %esi,%eax
 3dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e0:	5b                   	pop    %ebx
 3e1:	5e                   	pop    %esi
 3e2:	5f                   	pop    %edi
 3e3:	5d                   	pop    %ebp
 3e4:	c3                   	ret    

000003e5 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e5:	55                   	push   %ebp
 3e6:	89 e5                	mov    %esp,%ebp
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ea:	83 ec 08             	sub    $0x8,%esp
 3ed:	6a 00                	push   $0x0
 3ef:	ff 75 08             	push   0x8(%ebp)
 3f2:	e8 e4 00 00 00       	call   4db <open>
  if(fd < 0)
 3f7:	83 c4 10             	add    $0x10,%esp
 3fa:	85 c0                	test   %eax,%eax
 3fc:	78 24                	js     422 <stat+0x3d>
 3fe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 400:	83 ec 08             	sub    $0x8,%esp
 403:	ff 75 0c             	push   0xc(%ebp)
 406:	50                   	push   %eax
 407:	e8 e7 00 00 00       	call   4f3 <fstat>
 40c:	89 c6                	mov    %eax,%esi
  close(fd);
 40e:	89 1c 24             	mov    %ebx,(%esp)
 411:	e8 ad 00 00 00       	call   4c3 <close>
  return r;
 416:	83 c4 10             	add    $0x10,%esp
}
 419:	89 f0                	mov    %esi,%eax
 41b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5d                   	pop    %ebp
 421:	c3                   	ret    
    return -1;
 422:	be ff ff ff ff       	mov    $0xffffffff,%esi
 427:	eb f0                	jmp    419 <stat+0x34>

00000429 <atoi>:

int
atoi(const char *s)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	53                   	push   %ebx
 42d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 430:	0f b6 02             	movzbl (%edx),%eax
 433:	8d 48 d0             	lea    -0x30(%eax),%ecx
 436:	80 f9 09             	cmp    $0x9,%cl
 439:	77 24                	ja     45f <atoi+0x36>
  n = 0;
 43b:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 440:	83 c2 01             	add    $0x1,%edx
 443:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 446:	0f be c0             	movsbl %al,%eax
 449:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 44d:	0f b6 02             	movzbl (%edx),%eax
 450:	8d 58 d0             	lea    -0x30(%eax),%ebx
 453:	80 fb 09             	cmp    $0x9,%bl
 456:	76 e8                	jbe    440 <atoi+0x17>
  return n;
}
 458:	89 c8                	mov    %ecx,%eax
 45a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45d:	c9                   	leave  
 45e:	c3                   	ret    
  n = 0;
 45f:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 464:	eb f2                	jmp    458 <atoi+0x2f>

00000466 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	56                   	push   %esi
 46a:	53                   	push   %ebx
 46b:	8b 75 08             	mov    0x8(%ebp),%esi
 46e:	8b 55 0c             	mov    0xc(%ebp),%edx
 471:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 474:	85 db                	test   %ebx,%ebx
 476:	7e 15                	jle    48d <memmove+0x27>
 478:	01 f3                	add    %esi,%ebx
  dst = vdst;
 47a:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 47c:	83 c2 01             	add    $0x1,%edx
 47f:	83 c0 01             	add    $0x1,%eax
 482:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 486:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 489:	39 c3                	cmp    %eax,%ebx
 48b:	75 ef                	jne    47c <memmove+0x16>
  return vdst;
}
 48d:	89 f0                	mov    %esi,%eax
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    

00000493 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 493:	b8 01 00 00 00       	mov    $0x1,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <exit>:
SYSCALL(exit)
 49b:	b8 02 00 00 00       	mov    $0x2,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <wait>:
SYSCALL(wait)
 4a3:	b8 03 00 00 00       	mov    $0x3,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <pipe>:
SYSCALL(pipe)
 4ab:	b8 04 00 00 00       	mov    $0x4,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <read>:
SYSCALL(read)
 4b3:	b8 05 00 00 00       	mov    $0x5,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <write>:
SYSCALL(write)
 4bb:	b8 10 00 00 00       	mov    $0x10,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <close>:
SYSCALL(close)
 4c3:	b8 15 00 00 00       	mov    $0x15,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <kill>:
SYSCALL(kill)
 4cb:	b8 06 00 00 00       	mov    $0x6,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <exec>:
SYSCALL(exec)
 4d3:	b8 07 00 00 00       	mov    $0x7,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <open>:
SYSCALL(open)
 4db:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <mknod>:
SYSCALL(mknod)
 4e3:	b8 11 00 00 00       	mov    $0x11,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <unlink>:
SYSCALL(unlink)
 4eb:	b8 12 00 00 00       	mov    $0x12,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <fstat>:
SYSCALL(fstat)
 4f3:	b8 08 00 00 00       	mov    $0x8,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <link>:
SYSCALL(link)
 4fb:	b8 13 00 00 00       	mov    $0x13,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <mkdir>:
SYSCALL(mkdir)
 503:	b8 14 00 00 00       	mov    $0x14,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <chdir>:
SYSCALL(chdir)
 50b:	b8 09 00 00 00       	mov    $0x9,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <dup>:
SYSCALL(dup)
 513:	b8 0a 00 00 00       	mov    $0xa,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <getpid>:
SYSCALL(getpid)
 51b:	b8 0b 00 00 00       	mov    $0xb,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <sbrk>:
SYSCALL(sbrk)
 523:	b8 0c 00 00 00       	mov    $0xc,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <sleep>:
SYSCALL(sleep)
 52b:	b8 0d 00 00 00       	mov    $0xd,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <uptime>:
SYSCALL(uptime)
 533:	b8 0e 00 00 00       	mov    $0xe,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <slabtest>:
SYSCALL(slabtest)
 53b:	b8 16 00 00 00       	mov    $0x16,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <ps>:
SYSCALL(ps)
 543:	b8 17 00 00 00       	mov    $0x17,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 54b:	55                   	push   %ebp
 54c:	89 e5                	mov    %esp,%ebp
 54e:	57                   	push   %edi
 54f:	56                   	push   %esi
 550:	53                   	push   %ebx
 551:	83 ec 3c             	sub    $0x3c,%esp
 554:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 557:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 559:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 55d:	74 79                	je     5d8 <printint+0x8d>
 55f:	85 d2                	test   %edx,%edx
 561:	79 75                	jns    5d8 <printint+0x8d>
    neg = 1;
    x = -xx;
 563:	89 d1                	mov    %edx,%ecx
 565:	f7 d9                	neg    %ecx
    neg = 1;
 567:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 56e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 573:	89 df                	mov    %ebx,%edi
 575:	83 c3 01             	add    $0x1,%ebx
 578:	89 c8                	mov    %ecx,%eax
 57a:	ba 00 00 00 00       	mov    $0x0,%edx
 57f:	f7 f6                	div    %esi
 581:	0f b6 92 88 09 00 00 	movzbl 0x988(%edx),%edx
 588:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 58c:	89 ca                	mov    %ecx,%edx
 58e:	89 c1                	mov    %eax,%ecx
 590:	39 d6                	cmp    %edx,%esi
 592:	76 df                	jbe    573 <printint+0x28>
  if(neg)
 594:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 598:	74 08                	je     5a2 <printint+0x57>
    buf[i++] = '-';
 59a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 59f:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 5a2:	85 db                	test   %ebx,%ebx
 5a4:	7e 2a                	jle    5d0 <printint+0x85>
 5a6:	8d 7d d8             	lea    -0x28(%ebp),%edi
 5a9:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 5ad:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 5b0:	0f b6 03             	movzbl (%ebx),%eax
 5b3:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 5b6:	83 ec 04             	sub    $0x4,%esp
 5b9:	6a 01                	push   $0x1
 5bb:	56                   	push   %esi
 5bc:	ff 75 c4             	push   -0x3c(%ebp)
 5bf:	e8 f7 fe ff ff       	call   4bb <write>
  while(--i >= 0)
 5c4:	89 d8                	mov    %ebx,%eax
 5c6:	83 eb 01             	sub    $0x1,%ebx
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	39 f8                	cmp    %edi,%eax
 5ce:	75 e0                	jne    5b0 <printint+0x65>
}
 5d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    
    x = xx;
 5d8:	89 d1                	mov    %edx,%ecx
  neg = 0;
 5da:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 5e1:	eb 8b                	jmp    56e <printint+0x23>

000005e3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e3:	55                   	push   %ebp
 5e4:	89 e5                	mov    %esp,%ebp
 5e6:	57                   	push   %edi
 5e7:	56                   	push   %esi
 5e8:	53                   	push   %ebx
 5e9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ec:	8b 75 0c             	mov    0xc(%ebp),%esi
 5ef:	0f b6 1e             	movzbl (%esi),%ebx
 5f2:	84 db                	test   %bl,%bl
 5f4:	0f 84 9f 01 00 00    	je     799 <printf+0x1b6>
 5fa:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 5fd:	8d 45 10             	lea    0x10(%ebp),%eax
 600:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 603:	bf 00 00 00 00       	mov    $0x0,%edi
 608:	eb 2d                	jmp    637 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 60a:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 60d:	83 ec 04             	sub    $0x4,%esp
 610:	6a 01                	push   $0x1
 612:	8d 45 e7             	lea    -0x19(%ebp),%eax
 615:	50                   	push   %eax
 616:	ff 75 08             	push   0x8(%ebp)
 619:	e8 9d fe ff ff       	call   4bb <write>
        putc(fd, c);
 61e:	83 c4 10             	add    $0x10,%esp
 621:	eb 05                	jmp    628 <printf+0x45>
      }
    } else if(state == '%'){
 623:	83 ff 25             	cmp    $0x25,%edi
 626:	74 1f                	je     647 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 628:	83 c6 01             	add    $0x1,%esi
 62b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 62f:	84 db                	test   %bl,%bl
 631:	0f 84 62 01 00 00    	je     799 <printf+0x1b6>
    c = fmt[i] & 0xff;
 637:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 63a:	85 ff                	test   %edi,%edi
 63c:	75 e5                	jne    623 <printf+0x40>
      if(c == '%'){
 63e:	83 f8 25             	cmp    $0x25,%eax
 641:	75 c7                	jne    60a <printf+0x27>
        state = '%';
 643:	89 c7                	mov    %eax,%edi
 645:	eb e1                	jmp    628 <printf+0x45>
      if(c == 'd'){
 647:	83 f8 25             	cmp    $0x25,%eax
 64a:	0f 84 f2 00 00 00    	je     742 <printf+0x15f>
 650:	8d 50 9d             	lea    -0x63(%eax),%edx
 653:	83 fa 15             	cmp    $0x15,%edx
 656:	0f 87 07 01 00 00    	ja     763 <printf+0x180>
 65c:	0f 87 01 01 00 00    	ja     763 <printf+0x180>
 662:	ff 24 95 30 09 00 00 	jmp    *0x930(,%edx,4)
        printint(fd, *ap, 10, 1);
 669:	83 ec 0c             	sub    $0xc,%esp
 66c:	6a 01                	push   $0x1
 66e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 673:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 676:	8b 17                	mov    (%edi),%edx
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	e8 cb fe ff ff       	call   54b <printint>
        ap++;
 680:	89 f8                	mov    %edi,%eax
 682:	83 c0 04             	add    $0x4,%eax
 685:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 688:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68b:	bf 00 00 00 00       	mov    $0x0,%edi
 690:	eb 96                	jmp    628 <printf+0x45>
        printint(fd, *ap, 16, 0);
 692:	83 ec 0c             	sub    $0xc,%esp
 695:	6a 00                	push   $0x0
 697:	b9 10 00 00 00       	mov    $0x10,%ecx
 69c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 69f:	8b 17                	mov    (%edi),%edx
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	e8 a2 fe ff ff       	call   54b <printint>
        ap++;
 6a9:	89 f8                	mov    %edi,%eax
 6ab:	83 c0 04             	add    $0x4,%eax
 6ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b4:	bf 00 00 00 00       	mov    $0x0,%edi
 6b9:	e9 6a ff ff ff       	jmp    628 <printf+0x45>
        s = (char*)*ap;
 6be:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 6c1:	8b 01                	mov    (%ecx),%eax
        ap++;
 6c3:	83 c1 04             	add    $0x4,%ecx
 6c6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 6c9:	85 c0                	test   %eax,%eax
 6cb:	74 13                	je     6e0 <printf+0xfd>
        s = (char*)*ap;
 6cd:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 6cf:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 6d2:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 6d7:	84 c0                	test   %al,%al
 6d9:	75 0f                	jne    6ea <printf+0x107>
 6db:	e9 48 ff ff ff       	jmp    628 <printf+0x45>
          s = "(null)";
 6e0:	bb 26 09 00 00       	mov    $0x926,%ebx
        while(*s != 0){
 6e5:	b8 28 00 00 00       	mov    $0x28,%eax
 6ea:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 6ed:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	6a 01                	push   $0x1
 6f5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6f8:	50                   	push   %eax
 6f9:	57                   	push   %edi
 6fa:	e8 bc fd ff ff       	call   4bb <write>
          s++;
 6ff:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 702:	0f b6 03             	movzbl (%ebx),%eax
 705:	83 c4 10             	add    $0x10,%esp
 708:	84 c0                	test   %al,%al
 70a:	75 e1                	jne    6ed <printf+0x10a>
      state = 0;
 70c:	bf 00 00 00 00       	mov    $0x0,%edi
 711:	e9 12 ff ff ff       	jmp    628 <printf+0x45>
        putc(fd, *ap);
 716:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 719:	8b 07                	mov    (%edi),%eax
 71b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 71e:	83 ec 04             	sub    $0x4,%esp
 721:	6a 01                	push   $0x1
 723:	8d 45 e7             	lea    -0x19(%ebp),%eax
 726:	50                   	push   %eax
 727:	ff 75 08             	push   0x8(%ebp)
 72a:	e8 8c fd ff ff       	call   4bb <write>
        ap++;
 72f:	83 c7 04             	add    $0x4,%edi
 732:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 735:	83 c4 10             	add    $0x10,%esp
      state = 0;
 738:	bf 00 00 00 00       	mov    $0x0,%edi
 73d:	e9 e6 fe ff ff       	jmp    628 <printf+0x45>
        putc(fd, c);
 742:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 745:	83 ec 04             	sub    $0x4,%esp
 748:	6a 01                	push   $0x1
 74a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 74d:	50                   	push   %eax
 74e:	ff 75 08             	push   0x8(%ebp)
 751:	e8 65 fd ff ff       	call   4bb <write>
 756:	83 c4 10             	add    $0x10,%esp
      state = 0;
 759:	bf 00 00 00 00       	mov    $0x0,%edi
 75e:	e9 c5 fe ff ff       	jmp    628 <printf+0x45>
        putc(fd, '%');
 763:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 767:	83 ec 04             	sub    $0x4,%esp
 76a:	6a 01                	push   $0x1
 76c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 76f:	50                   	push   %eax
 770:	ff 75 08             	push   0x8(%ebp)
 773:	e8 43 fd ff ff       	call   4bb <write>
        putc(fd, c);
 778:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 77b:	83 c4 0c             	add    $0xc,%esp
 77e:	6a 01                	push   $0x1
 780:	8d 45 e7             	lea    -0x19(%ebp),%eax
 783:	50                   	push   %eax
 784:	ff 75 08             	push   0x8(%ebp)
 787:	e8 2f fd ff ff       	call   4bb <write>
        putc(fd, c);
 78c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 78f:	bf 00 00 00 00       	mov    $0x0,%edi
 794:	e9 8f fe ff ff       	jmp    628 <printf+0x45>
    }
  }
}
 799:	8d 65 f4             	lea    -0xc(%ebp),%esp
 79c:	5b                   	pop    %ebx
 79d:	5e                   	pop    %esi
 79e:	5f                   	pop    %edi
 79f:	5d                   	pop    %ebp
 7a0:	c3                   	ret    

000007a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	57                   	push   %edi
 7a5:	56                   	push   %esi
 7a6:	53                   	push   %ebx
 7a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7aa:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ad:	a1 68 0c 00 00       	mov    0xc68,%eax
 7b2:	eb 0c                	jmp    7c0 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	39 c2                	cmp    %eax,%edx
 7b8:	77 04                	ja     7be <free+0x1d>
 7ba:	39 ca                	cmp    %ecx,%edx
 7bc:	77 10                	ja     7ce <free+0x2d>
{
 7be:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	39 c8                	cmp    %ecx,%eax
 7c2:	73 f0                	jae    7b4 <free+0x13>
 7c4:	8b 10                	mov    (%eax),%edx
 7c6:	39 ca                	cmp    %ecx,%edx
 7c8:	77 04                	ja     7ce <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	39 c2                	cmp    %eax,%edx
 7cc:	77 f0                	ja     7be <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ce:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7d1:	8b 10                	mov    (%eax),%edx
 7d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7d6:	39 fa                	cmp    %edi,%edx
 7d8:	74 19                	je     7f3 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e3:	39 f1                	cmp    %esi,%ecx
 7e5:	74 18                	je     7ff <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e7:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 7e9:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 7ee:	5b                   	pop    %ebx
 7ef:	5e                   	pop    %esi
 7f0:	5f                   	pop    %edi
 7f1:	5d                   	pop    %ebp
 7f2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7f3:	03 72 04             	add    0x4(%edx),%esi
 7f6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 12                	mov    (%edx),%edx
 7fd:	eb db                	jmp    7da <free+0x39>
    p->s.size += bp->s.size;
 7ff:	03 53 fc             	add    -0x4(%ebx),%edx
 802:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 805:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 808:	eb dd                	jmp    7e7 <free+0x46>

0000080a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80a:	55                   	push   %ebp
 80b:	89 e5                	mov    %esp,%ebp
 80d:	57                   	push   %edi
 80e:	56                   	push   %esi
 80f:	53                   	push   %ebx
 810:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	8d 58 07             	lea    0x7(%eax),%ebx
 819:	c1 eb 03             	shr    $0x3,%ebx
 81c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 81f:	8b 15 68 0c 00 00    	mov    0xc68,%edx
 825:	85 d2                	test   %edx,%edx
 827:	74 1c                	je     845 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 82b:	8b 48 04             	mov    0x4(%eax),%ecx
 82e:	39 cb                	cmp    %ecx,%ebx
 830:	76 38                	jbe    86a <malloc+0x60>
 832:	be 00 10 00 00       	mov    $0x1000,%esi
 837:	39 f3                	cmp    %esi,%ebx
 839:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 83c:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 843:	eb 72                	jmp    8b7 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 845:	c7 05 68 0c 00 00 6c 	movl   $0xc6c,0xc68
 84c:	0c 00 00 
 84f:	c7 05 6c 0c 00 00 6c 	movl   $0xc6c,0xc6c
 856:	0c 00 00 
    base.s.size = 0;
 859:	c7 05 70 0c 00 00 00 	movl   $0x0,0xc70
 860:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 863:	b8 6c 0c 00 00       	mov    $0xc6c,%eax
 868:	eb c8                	jmp    832 <malloc+0x28>
      if(p->s.size == nunits)
 86a:	39 cb                	cmp    %ecx,%ebx
 86c:	74 1e                	je     88c <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 86e:	29 d9                	sub    %ebx,%ecx
 870:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 873:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 876:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 879:	89 15 68 0c 00 00    	mov    %edx,0xc68
      return (void*)(p + 1);
 87f:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 882:	89 d0                	mov    %edx,%eax
 884:	8d 65 f4             	lea    -0xc(%ebp),%esp
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 88c:	8b 08                	mov    (%eax),%ecx
 88e:	89 0a                	mov    %ecx,(%edx)
 890:	eb e7                	jmp    879 <malloc+0x6f>
  hp->s.size = nu;
 892:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 895:	83 ec 0c             	sub    $0xc,%esp
 898:	83 c0 08             	add    $0x8,%eax
 89b:	50                   	push   %eax
 89c:	e8 00 ff ff ff       	call   7a1 <free>
  return freep;
 8a1:	8b 15 68 0c 00 00    	mov    0xc68,%edx
      if((p = morecore(nunits)) == 0)
 8a7:	83 c4 10             	add    $0x10,%esp
 8aa:	85 d2                	test   %edx,%edx
 8ac:	74 d4                	je     882 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b0:	8b 48 04             	mov    0x4(%eax),%ecx
 8b3:	39 d9                	cmp    %ebx,%ecx
 8b5:	73 b3                	jae    86a <malloc+0x60>
    if(p == freep)
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	39 05 68 0c 00 00    	cmp    %eax,0xc68
 8bf:	75 ed                	jne    8ae <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 8c1:	83 ec 0c             	sub    $0xc,%esp
 8c4:	57                   	push   %edi
 8c5:	e8 59 fc ff ff       	call   523 <sbrk>
  if(p == (char*)-1)
 8ca:	83 c4 10             	add    $0x10,%esp
 8cd:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d0:	75 c0                	jne    892 <malloc+0x88>
        return 0;
 8d2:	ba 00 00 00 00       	mov    $0x0,%edx
 8d7:	eb a9                	jmp    882 <malloc+0x78>
