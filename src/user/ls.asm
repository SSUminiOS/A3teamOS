
user/_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	83 ec 0c             	sub    $0xc,%esp
   f:	53                   	push   %ebx
  10:	e8 1e 03 00 00       	call   333 <strlen>
  15:	83 c4 10             	add    $0x10,%esp
  18:	01 d8                	add    %ebx,%eax
  1a:	72 0c                	jb     28 <fmtname+0x28>
  1c:	80 38 2f             	cmpb   $0x2f,(%eax)
  1f:	74 07                	je     28 <fmtname+0x28>
  21:	83 e8 01             	sub    $0x1,%eax
  24:	39 c3                	cmp    %eax,%ebx
  26:	76 f4                	jbe    1c <fmtname+0x1c>
    ;
  p++;
  28:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	53                   	push   %ebx
  2f:	e8 ff 02 00 00       	call   333 <strlen>
  34:	83 c4 10             	add    $0x10,%esp
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	76 09                	jbe    45 <fmtname+0x45>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3c:	89 d8                	mov    %ebx,%eax
  3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  41:	5b                   	pop    %ebx
  42:	5e                   	pop    %esi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret    
  memmove(buf, p, strlen(p));
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	53                   	push   %ebx
  49:	e8 e5 02 00 00       	call   333 <strlen>
  4e:	83 c4 0c             	add    $0xc,%esp
  51:	50                   	push   %eax
  52:	53                   	push   %ebx
  53:	68 40 0c 00 00       	push   $0xc40
  58:	e8 2e 04 00 00       	call   48b <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5d:	89 1c 24             	mov    %ebx,(%esp)
  60:	e8 ce 02 00 00       	call   333 <strlen>
  65:	89 c6                	mov    %eax,%esi
  67:	89 1c 24             	mov    %ebx,(%esp)
  6a:	e8 c4 02 00 00       	call   333 <strlen>
  6f:	83 c4 0c             	add    $0xc,%esp
  72:	ba 0e 00 00 00       	mov    $0xe,%edx
  77:	29 f2                	sub    %esi,%edx
  79:	52                   	push   %edx
  7a:	6a 20                	push   $0x20
  7c:	05 40 0c 00 00       	add    $0xc40,%eax
  81:	50                   	push   %eax
  82:	e8 d6 02 00 00       	call   35d <memset>
  return buf;
  87:	83 c4 10             	add    $0x10,%esp
  8a:	bb 40 0c 00 00       	mov    $0xc40,%ebx
  8f:	eb ab                	jmp    3c <fmtname+0x3c>

00000091 <ls>:

void
ls(char *path)
{
  91:	f3 0f 1e fb          	endbr32 
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	57                   	push   %edi
  99:	56                   	push   %esi
  9a:	53                   	push   %ebx
  9b:	81 ec 54 02 00 00    	sub    $0x254,%esp
  a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a4:	6a 00                	push   $0x0
  a6:	53                   	push   %ebx
  a7:	e8 58 04 00 00       	call   504 <open>
  ac:	83 c4 10             	add    $0x10,%esp
  af:	85 c0                	test   %eax,%eax
  b1:	78 7b                	js     12e <ls+0x9d>
  b3:	89 c6                	mov    %eax,%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b5:	83 ec 08             	sub    $0x8,%esp
  b8:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  be:	50                   	push   %eax
  bf:	56                   	push   %esi
  c0:	e8 57 04 00 00       	call   51c <fstat>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	85 c0                	test   %eax,%eax
  ca:	78 77                	js     143 <ls+0xb2>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  cc:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
  d3:	66 83 f8 01          	cmp    $0x1,%ax
  d7:	0f 84 83 00 00 00    	je     160 <ls+0xcf>
  dd:	66 83 f8 02          	cmp    $0x2,%ax
  e1:	75 37                	jne    11a <ls+0x89>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  e3:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
  e9:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
  ef:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  f5:	83 ec 0c             	sub    $0xc,%esp
  f8:	53                   	push   %ebx
  f9:	e8 02 ff ff ff       	call   0 <fmtname>
  fe:	83 c4 08             	add    $0x8,%esp
 101:	57                   	push   %edi
 102:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 108:	6a 02                	push   $0x2
 10a:	50                   	push   %eax
 10b:	68 48 09 00 00       	push   $0x948
 110:	6a 01                	push   $0x1
 112:	e8 f1 04 00 00       	call   608 <printf>
    break;
 117:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 11a:	83 ec 0c             	sub    $0xc,%esp
 11d:	56                   	push   %esi
 11e:	e8 c9 03 00 00       	call   4ec <close>
 123:	83 c4 10             	add    $0x10,%esp
}
 126:	8d 65 f4             	lea    -0xc(%ebp),%esp
 129:	5b                   	pop    %ebx
 12a:	5e                   	pop    %esi
 12b:	5f                   	pop    %edi
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	53                   	push   %ebx
 132:	68 20 09 00 00       	push   $0x920
 137:	6a 02                	push   $0x2
 139:	e8 ca 04 00 00       	call   608 <printf>
    return;
 13e:	83 c4 10             	add    $0x10,%esp
 141:	eb e3                	jmp    126 <ls+0x95>
    printf(2, "ls: cannot stat %s\n", path);
 143:	83 ec 04             	sub    $0x4,%esp
 146:	53                   	push   %ebx
 147:	68 34 09 00 00       	push   $0x934
 14c:	6a 02                	push   $0x2
 14e:	e8 b5 04 00 00       	call   608 <printf>
    close(fd);
 153:	89 34 24             	mov    %esi,(%esp)
 156:	e8 91 03 00 00       	call   4ec <close>
    return;
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	eb c6                	jmp    126 <ls+0x95>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	53                   	push   %ebx
 164:	e8 ca 01 00 00       	call   333 <strlen>
 169:	83 c0 10             	add    $0x10,%eax
 16c:	83 c4 10             	add    $0x10,%esp
 16f:	3d 00 02 00 00       	cmp    $0x200,%eax
 174:	76 14                	jbe    18a <ls+0xf9>
      printf(1, "ls: path too long\n");
 176:	83 ec 08             	sub    $0x8,%esp
 179:	68 55 09 00 00       	push   $0x955
 17e:	6a 01                	push   $0x1
 180:	e8 83 04 00 00       	call   608 <printf>
      break;
 185:	83 c4 10             	add    $0x10,%esp
 188:	eb 90                	jmp    11a <ls+0x89>
    strcpy(buf, path);
 18a:	83 ec 08             	sub    $0x8,%esp
 18d:	53                   	push   %ebx
 18e:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 194:	57                   	push   %edi
 195:	e8 44 01 00 00       	call   2de <strcpy>
    p = buf+strlen(buf);
 19a:	89 3c 24             	mov    %edi,(%esp)
 19d:	e8 91 01 00 00       	call   333 <strlen>
 1a2:	01 c7                	add    %eax,%edi
    *p++ = '/';
 1a4:	8d 47 01             	lea    0x1(%edi),%eax
 1a7:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
 1ad:	c6 07 2f             	movb   $0x2f,(%edi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
 1b9:	eb 19                	jmp    1d4 <ls+0x143>
        printf(1, "ls: cannot stat %s\n", buf);
 1bb:	83 ec 04             	sub    $0x4,%esp
 1be:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1c4:	50                   	push   %eax
 1c5:	68 34 09 00 00       	push   $0x934
 1ca:	6a 01                	push   $0x1
 1cc:	e8 37 04 00 00       	call   608 <printf>
        continue;
 1d1:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d4:	83 ec 04             	sub    $0x4,%esp
 1d7:	6a 10                	push   $0x10
 1d9:	53                   	push   %ebx
 1da:	56                   	push   %esi
 1db:	e8 fc 02 00 00       	call   4dc <read>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	83 f8 10             	cmp    $0x10,%eax
 1e6:	0f 85 2e ff ff ff    	jne    11a <ls+0x89>
      if(de.inum == 0)
 1ec:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1f3:	00 
 1f4:	74 de                	je     1d4 <ls+0x143>
      memmove(p, de.name, DIRSIZ);
 1f6:	83 ec 04             	sub    $0x4,%esp
 1f9:	6a 0e                	push   $0xe
 1fb:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 201:	50                   	push   %eax
 202:	ff b5 a8 fd ff ff    	pushl  -0x258(%ebp)
 208:	e8 7e 02 00 00       	call   48b <memmove>
      p[DIRSIZ] = 0;
 20d:	c6 47 0f 00          	movb   $0x0,0xf(%edi)
      if(stat(buf, &st) < 0){
 211:	83 c4 08             	add    $0x8,%esp
 214:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 21a:	50                   	push   %eax
 21b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 221:	50                   	push   %eax
 222:	e8 dd 01 00 00       	call   404 <stat>
 227:	83 c4 10             	add    $0x10,%esp
 22a:	85 c0                	test   %eax,%eax
 22c:	78 8d                	js     1bb <ls+0x12a>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 22e:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 234:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 23a:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 240:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 246:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
 24d:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 253:	83 ec 0c             	sub    $0xc,%esp
 256:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 25c:	50                   	push   %eax
 25d:	e8 9e fd ff ff       	call   0 <fmtname>
 262:	83 c4 08             	add    $0x8,%esp
 265:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 26b:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 271:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 277:	50                   	push   %eax
 278:	68 48 09 00 00       	push   $0x948
 27d:	6a 01                	push   $0x1
 27f:	e8 84 03 00 00       	call   608 <printf>
 284:	83 c4 20             	add    $0x20,%esp
 287:	e9 48 ff ff ff       	jmp    1d4 <ls+0x143>

0000028c <main>:

int
main(int argc, char *argv[])
{
 28c:	f3 0f 1e fb          	endbr32 
 290:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 294:	83 e4 f0             	and    $0xfffffff0,%esp
 297:	ff 71 fc             	pushl  -0x4(%ecx)
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	56                   	push   %esi
 29e:	53                   	push   %ebx
 29f:	51                   	push   %ecx
 2a0:	83 ec 0c             	sub    $0xc,%esp
 2a3:	8b 01                	mov    (%ecx),%eax
 2a5:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
 2a8:	83 f8 01             	cmp    $0x1,%eax
 2ab:	7e 1f                	jle    2cc <main+0x40>
 2ad:	8d 5a 04             	lea    0x4(%edx),%ebx
 2b0:	8d 34 82             	lea    (%edx,%eax,4),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 33                	pushl  (%ebx)
 2b8:	e8 d4 fd ff ff       	call   91 <ls>
  for(i=1; i<argc; i++)
 2bd:	83 c3 04             	add    $0x4,%ebx
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	39 f3                	cmp    %esi,%ebx
 2c5:	75 ec                	jne    2b3 <main+0x27>
  exit();
 2c7:	e8 f8 01 00 00       	call   4c4 <exit>
    ls(".");
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	68 68 09 00 00       	push   $0x968
 2d4:	e8 b8 fd ff ff       	call   91 <ls>
    exit();
 2d9:	e8 e6 01 00 00       	call   4c4 <exit>

000002de <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2de:	f3 0f 1e fb          	endbr32 
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	53                   	push   %ebx
 2e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ec:	b8 00 00 00 00       	mov    $0x0,%eax
 2f1:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2f5:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	84 d2                	test   %dl,%dl
 2fd:	75 f2                	jne    2f1 <strcpy+0x13>
    ;
  return os;
}
 2ff:	89 c8                	mov    %ecx,%eax
 301:	5b                   	pop    %ebx
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 304:	f3 0f 1e fb          	endbr32 
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 311:	0f b6 01             	movzbl (%ecx),%eax
 314:	84 c0                	test   %al,%al
 316:	74 11                	je     329 <strcmp+0x25>
 318:	38 02                	cmp    %al,(%edx)
 31a:	75 0d                	jne    329 <strcmp+0x25>
    p++, q++;
 31c:	83 c1 01             	add    $0x1,%ecx
 31f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 322:	0f b6 01             	movzbl (%ecx),%eax
 325:	84 c0                	test   %al,%al
 327:	75 ef                	jne    318 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 329:	0f b6 c0             	movzbl %al,%eax
 32c:	0f b6 12             	movzbl (%edx),%edx
 32f:	29 d0                	sub    %edx,%eax
}
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    

00000333 <strlen>:

uint
strlen(const char *s)
{
 333:	f3 0f 1e fb          	endbr32 
 337:	55                   	push   %ebp
 338:	89 e5                	mov    %esp,%ebp
 33a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 33d:	80 3a 00             	cmpb   $0x0,(%edx)
 340:	74 14                	je     356 <strlen+0x23>
 342:	b8 00 00 00 00       	mov    $0x0,%eax
 347:	83 c0 01             	add    $0x1,%eax
 34a:	89 c1                	mov    %eax,%ecx
 34c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 350:	75 f5                	jne    347 <strlen+0x14>
    ;
  return n;
}
 352:	89 c8                	mov    %ecx,%eax
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    
  for(n = 0; s[n]; n++)
 356:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 35b:	eb f5                	jmp    352 <strlen+0x1f>

0000035d <memset>:

void*
memset(void *dst, int c, uint n)
{
 35d:	f3 0f 1e fb          	endbr32 
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	57                   	push   %edi
 365:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 368:	89 d7                	mov    %edx,%edi
 36a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36d:	8b 45 0c             	mov    0xc(%ebp),%eax
 370:	fc                   	cld    
 371:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 373:	89 d0                	mov    %edx,%eax
 375:	5f                   	pop    %edi
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    

00000378 <strchr>:

char*
strchr(const char *s, char c)
{
 378:	f3 0f 1e fb          	endbr32 
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 386:	0f b6 10             	movzbl (%eax),%edx
 389:	84 d2                	test   %dl,%dl
 38b:	74 15                	je     3a2 <strchr+0x2a>
    if(*s == c)
 38d:	38 d1                	cmp    %dl,%cl
 38f:	74 0f                	je     3a0 <strchr+0x28>
  for(; *s; s++)
 391:	83 c0 01             	add    $0x1,%eax
 394:	0f b6 10             	movzbl (%eax),%edx
 397:	84 d2                	test   %dl,%dl
 399:	75 f2                	jne    38d <strchr+0x15>
      return (char*)s;
  return 0;
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a0:	5d                   	pop    %ebp
 3a1:	c3                   	ret    
  return 0;
 3a2:	b8 00 00 00 00       	mov    $0x0,%eax
 3a7:	eb f7                	jmp    3a0 <strchr+0x28>

000003a9 <gets>:

char*
gets(char *buf, int max)
{
 3a9:	f3 0f 1e fb          	endbr32 
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	57                   	push   %edi
 3b1:	56                   	push   %esi
 3b2:	53                   	push   %ebx
 3b3:	83 ec 2c             	sub    $0x2c,%esp
 3b6:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b9:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 3be:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 3c4:	83 c3 01             	add    $0x1,%ebx
 3c7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ca:	7d 27                	jge    3f3 <gets+0x4a>
    cc = read(0, &c, 1);
 3cc:	83 ec 04             	sub    $0x4,%esp
 3cf:	6a 01                	push   $0x1
 3d1:	57                   	push   %edi
 3d2:	6a 00                	push   $0x0
 3d4:	e8 03 01 00 00       	call   4dc <read>
    if(cc < 1)
 3d9:	83 c4 10             	add    $0x10,%esp
 3dc:	85 c0                	test   %eax,%eax
 3de:	7e 13                	jle    3f3 <gets+0x4a>
      break;
    buf[i++] = c;
 3e0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e4:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 3e8:	3c 0a                	cmp    $0xa,%al
 3ea:	74 04                	je     3f0 <gets+0x47>
 3ec:	3c 0d                	cmp    $0xd,%al
 3ee:	75 d1                	jne    3c1 <gets+0x18>
  for(i=0; i+1 < max; ){
 3f0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 3f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3f6:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 3fa:	89 f0                	mov    %esi,%eax
 3fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ff:	5b                   	pop    %ebx
 400:	5e                   	pop    %esi
 401:	5f                   	pop    %edi
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    

00000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	f3 0f 1e fb          	endbr32 
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	56                   	push   %esi
 40c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	6a 00                	push   $0x0
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 ea 00 00 00       	call   504 <open>
  if(fd < 0)
 41a:	83 c4 10             	add    $0x10,%esp
 41d:	85 c0                	test   %eax,%eax
 41f:	78 24                	js     445 <stat+0x41>
 421:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 423:	83 ec 08             	sub    $0x8,%esp
 426:	ff 75 0c             	pushl  0xc(%ebp)
 429:	50                   	push   %eax
 42a:	e8 ed 00 00 00       	call   51c <fstat>
 42f:	89 c6                	mov    %eax,%esi
  close(fd);
 431:	89 1c 24             	mov    %ebx,(%esp)
 434:	e8 b3 00 00 00       	call   4ec <close>
  return r;
 439:	83 c4 10             	add    $0x10,%esp
}
 43c:	89 f0                	mov    %esi,%eax
 43e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 441:	5b                   	pop    %ebx
 442:	5e                   	pop    %esi
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    
    return -1;
 445:	be ff ff ff ff       	mov    $0xffffffff,%esi
 44a:	eb f0                	jmp    43c <stat+0x38>

0000044c <atoi>:

int
atoi(const char *s)
{
 44c:	f3 0f 1e fb          	endbr32 
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f b6 02             	movzbl (%edx),%eax
 45a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 45d:	80 f9 09             	cmp    $0x9,%cl
 460:	77 22                	ja     484 <atoi+0x38>
  n = 0;
 462:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 467:	83 c2 01             	add    $0x1,%edx
 46a:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 46d:	0f be c0             	movsbl %al,%eax
 470:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 474:	0f b6 02             	movzbl (%edx),%eax
 477:	8d 58 d0             	lea    -0x30(%eax),%ebx
 47a:	80 fb 09             	cmp    $0x9,%bl
 47d:	76 e8                	jbe    467 <atoi+0x1b>
  return n;
}
 47f:	89 c8                	mov    %ecx,%eax
 481:	5b                   	pop    %ebx
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    
  n = 0;
 484:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 489:	eb f4                	jmp    47f <atoi+0x33>

0000048b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48b:	f3 0f 1e fb          	endbr32 
 48f:	55                   	push   %ebp
 490:	89 e5                	mov    %esp,%ebp
 492:	56                   	push   %esi
 493:	53                   	push   %ebx
 494:	8b 75 08             	mov    0x8(%ebp),%esi
 497:	8b 55 0c             	mov    0xc(%ebp),%edx
 49a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49d:	85 db                	test   %ebx,%ebx
 49f:	7e 15                	jle    4b6 <memmove+0x2b>
 4a1:	01 f3                	add    %esi,%ebx
  dst = vdst;
 4a3:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 4a5:	83 c2 01             	add    $0x1,%edx
 4a8:	83 c0 01             	add    $0x1,%eax
 4ab:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 4af:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 4b2:	39 c3                	cmp    %eax,%ebx
 4b4:	75 ef                	jne    4a5 <memmove+0x1a>
  return vdst;
}
 4b6:	89 f0                	mov    %esi,%eax
 4b8:	5b                   	pop    %ebx
 4b9:	5e                   	pop    %esi
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    

000004bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4bc:	b8 01 00 00 00       	mov    $0x1,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <exit>:
SYSCALL(exit)
 4c4:	b8 02 00 00 00       	mov    $0x2,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <wait>:
SYSCALL(wait)
 4cc:	b8 03 00 00 00       	mov    $0x3,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <pipe>:
SYSCALL(pipe)
 4d4:	b8 04 00 00 00       	mov    $0x4,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <read>:
SYSCALL(read)
 4dc:	b8 05 00 00 00       	mov    $0x5,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <write>:
SYSCALL(write)
 4e4:	b8 10 00 00 00       	mov    $0x10,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <close>:
SYSCALL(close)
 4ec:	b8 15 00 00 00       	mov    $0x15,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <kill>:
SYSCALL(kill)
 4f4:	b8 06 00 00 00       	mov    $0x6,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <exec>:
SYSCALL(exec)
 4fc:	b8 07 00 00 00       	mov    $0x7,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <open>:
SYSCALL(open)
 504:	b8 0f 00 00 00       	mov    $0xf,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <mknod>:
SYSCALL(mknod)
 50c:	b8 11 00 00 00       	mov    $0x11,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <unlink>:
SYSCALL(unlink)
 514:	b8 12 00 00 00       	mov    $0x12,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <fstat>:
SYSCALL(fstat)
 51c:	b8 08 00 00 00       	mov    $0x8,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <link>:
SYSCALL(link)
 524:	b8 13 00 00 00       	mov    $0x13,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <mkdir>:
SYSCALL(mkdir)
 52c:	b8 14 00 00 00       	mov    $0x14,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <chdir>:
SYSCALL(chdir)
 534:	b8 09 00 00 00       	mov    $0x9,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <dup>:
SYSCALL(dup)
 53c:	b8 0a 00 00 00       	mov    $0xa,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <getpid>:
SYSCALL(getpid)
 544:	b8 0b 00 00 00       	mov    $0xb,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <sbrk>:
SYSCALL(sbrk)
 54c:	b8 0c 00 00 00       	mov    $0xc,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <sleep>:
SYSCALL(sleep)
 554:	b8 0d 00 00 00       	mov    $0xd,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <uptime>:
SYSCALL(uptime)
 55c:	b8 0e 00 00 00       	mov    $0xe,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <slabtest>:
SYSCALL(slabtest)
 564:	b8 16 00 00 00       	mov    $0x16,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <ps>:
SYSCALL(ps)
 56c:	b8 17 00 00 00       	mov    $0x17,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	57                   	push   %edi
 578:	56                   	push   %esi
 579:	53                   	push   %ebx
 57a:	83 ec 3c             	sub    $0x3c,%esp
 57d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 580:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 586:	74 77                	je     5ff <printint+0x8b>
 588:	85 d2                	test   %edx,%edx
 58a:	79 73                	jns    5ff <printint+0x8b>
    neg = 1;
    x = -xx;
 58c:	f7 db                	neg    %ebx
    neg = 1;
 58e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 595:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 59a:	89 f7                	mov    %esi,%edi
 59c:	83 c6 01             	add    $0x1,%esi
 59f:	89 d8                	mov    %ebx,%eax
 5a1:	ba 00 00 00 00       	mov    $0x0,%edx
 5a6:	f7 f1                	div    %ecx
 5a8:	0f b6 92 74 09 00 00 	movzbl 0x974(%edx),%edx
 5af:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5b3:	89 da                	mov    %ebx,%edx
 5b5:	89 c3                	mov    %eax,%ebx
 5b7:	39 d1                	cmp    %edx,%ecx
 5b9:	76 df                	jbe    59a <printint+0x26>
  if(neg)
 5bb:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 5bf:	74 08                	je     5c9 <printint+0x55>
    buf[i++] = '-';
 5c1:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 5c6:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
 5c9:	85 f6                	test   %esi,%esi
 5cb:	7e 2a                	jle    5f7 <printint+0x83>
 5cd:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
 5d1:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
 5d4:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 5d7:	0f b6 03             	movzbl (%ebx),%eax
 5da:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 5dd:	83 ec 04             	sub    $0x4,%esp
 5e0:	6a 01                	push   $0x1
 5e2:	56                   	push   %esi
 5e3:	ff 75 c4             	pushl  -0x3c(%ebp)
 5e6:	e8 f9 fe ff ff       	call   4e4 <write>
  while(--i >= 0)
 5eb:	89 d8                	mov    %ebx,%eax
 5ed:	83 eb 01             	sub    $0x1,%ebx
 5f0:	83 c4 10             	add    $0x10,%esp
 5f3:	39 f8                	cmp    %edi,%eax
 5f5:	75 e0                	jne    5d7 <printint+0x63>
}
 5f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5fa:	5b                   	pop    %ebx
 5fb:	5e                   	pop    %esi
 5fc:	5f                   	pop    %edi
 5fd:	5d                   	pop    %ebp
 5fe:	c3                   	ret    
  neg = 0;
 5ff:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 606:	eb 8d                	jmp    595 <printint+0x21>

00000608 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 608:	f3 0f 1e fb          	endbr32 
 60c:	55                   	push   %ebp
 60d:	89 e5                	mov    %esp,%ebp
 60f:	57                   	push   %edi
 610:	56                   	push   %esi
 611:	53                   	push   %ebx
 612:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 615:	8b 75 0c             	mov    0xc(%ebp),%esi
 618:	0f b6 1e             	movzbl (%esi),%ebx
 61b:	84 db                	test   %bl,%bl
 61d:	0f 84 ab 01 00 00    	je     7ce <printf+0x1c6>
 623:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 626:	8d 45 10             	lea    0x10(%ebp),%eax
 629:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 62c:	bf 00 00 00 00       	mov    $0x0,%edi
 631:	eb 2d                	jmp    660 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 633:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 636:	83 ec 04             	sub    $0x4,%esp
 639:	6a 01                	push   $0x1
 63b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 9d fe ff ff       	call   4e4 <write>
        putc(fd, c);
 647:	83 c4 10             	add    $0x10,%esp
 64a:	eb 05                	jmp    651 <printf+0x49>
      }
    } else if(state == '%'){
 64c:	83 ff 25             	cmp    $0x25,%edi
 64f:	74 22                	je     673 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
 651:	83 c6 01             	add    $0x1,%esi
 654:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 658:	84 db                	test   %bl,%bl
 65a:	0f 84 6e 01 00 00    	je     7ce <printf+0x1c6>
    c = fmt[i] & 0xff;
 660:	0f be d3             	movsbl %bl,%edx
 663:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 666:	85 ff                	test   %edi,%edi
 668:	75 e2                	jne    64c <printf+0x44>
      if(c == '%'){
 66a:	83 f8 25             	cmp    $0x25,%eax
 66d:	75 c4                	jne    633 <printf+0x2b>
        state = '%';
 66f:	89 c7                	mov    %eax,%edi
 671:	eb de                	jmp    651 <printf+0x49>
      if(c == 'd'){
 673:	83 f8 64             	cmp    $0x64,%eax
 676:	74 59                	je     6d1 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 678:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 67e:	83 fa 70             	cmp    $0x70,%edx
 681:	74 7a                	je     6fd <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 683:	83 f8 73             	cmp    $0x73,%eax
 686:	0f 84 9d 00 00 00    	je     729 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68c:	83 f8 63             	cmp    $0x63,%eax
 68f:	0f 84 ec 00 00 00    	je     781 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 695:	83 f8 25             	cmp    $0x25,%eax
 698:	0f 84 0f 01 00 00    	je     7ad <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 6a2:	83 ec 04             	sub    $0x4,%esp
 6a5:	6a 01                	push   $0x1
 6a7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 31 fe ff ff       	call   4e4 <write>
        putc(fd, c);
 6b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6b6:	83 c4 0c             	add    $0xc,%esp
 6b9:	6a 01                	push   $0x1
 6bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 1d fe ff ff       	call   4e4 <write>
        putc(fd, c);
 6c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ca:	bf 00 00 00 00       	mov    $0x0,%edi
 6cf:	eb 80                	jmp    651 <printf+0x49>
        printint(fd, *ap, 10, 1);
 6d1:	83 ec 0c             	sub    $0xc,%esp
 6d4:	6a 01                	push   $0x1
 6d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6db:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6de:	8b 17                	mov    (%edi),%edx
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	e8 8c fe ff ff       	call   574 <printint>
        ap++;
 6e8:	89 f8                	mov    %edi,%eax
 6ea:	83 c0 04             	add    $0x4,%eax
 6ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f3:	bf 00 00 00 00       	mov    $0x0,%edi
 6f8:	e9 54 ff ff ff       	jmp    651 <printf+0x49>
        printint(fd, *ap, 16, 0);
 6fd:	83 ec 0c             	sub    $0xc,%esp
 700:	6a 00                	push   $0x0
 702:	b9 10 00 00 00       	mov    $0x10,%ecx
 707:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 70a:	8b 17                	mov    (%edi),%edx
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	e8 60 fe ff ff       	call   574 <printint>
        ap++;
 714:	89 f8                	mov    %edi,%eax
 716:	83 c0 04             	add    $0x4,%eax
 719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	bf 00 00 00 00       	mov    $0x0,%edi
 724:	e9 28 ff ff ff       	jmp    651 <printf+0x49>
        s = (char*)*ap;
 729:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 72c:	8b 01                	mov    (%ecx),%eax
        ap++;
 72e:	83 c1 04             	add    $0x4,%ecx
 731:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 734:	85 c0                	test   %eax,%eax
 736:	74 13                	je     74b <printf+0x143>
        s = (char*)*ap;
 738:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 73a:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 73d:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 742:	84 c0                	test   %al,%al
 744:	75 0f                	jne    755 <printf+0x14d>
 746:	e9 06 ff ff ff       	jmp    651 <printf+0x49>
          s = "(null)";
 74b:	bb 6a 09 00 00       	mov    $0x96a,%ebx
        while(*s != 0){
 750:	b8 28 00 00 00       	mov    $0x28,%eax
 755:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 758:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 75b:	83 ec 04             	sub    $0x4,%esp
 75e:	6a 01                	push   $0x1
 760:	8d 45 e7             	lea    -0x19(%ebp),%eax
 763:	50                   	push   %eax
 764:	57                   	push   %edi
 765:	e8 7a fd ff ff       	call   4e4 <write>
          s++;
 76a:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 76d:	0f b6 03             	movzbl (%ebx),%eax
 770:	83 c4 10             	add    $0x10,%esp
 773:	84 c0                	test   %al,%al
 775:	75 e1                	jne    758 <printf+0x150>
      state = 0;
 777:	bf 00 00 00 00       	mov    $0x0,%edi
 77c:	e9 d0 fe ff ff       	jmp    651 <printf+0x49>
        putc(fd, *ap);
 781:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 784:	8b 07                	mov    (%edi),%eax
 786:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 789:	83 ec 04             	sub    $0x4,%esp
 78c:	6a 01                	push   $0x1
 78e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 791:	50                   	push   %eax
 792:	ff 75 08             	pushl  0x8(%ebp)
 795:	e8 4a fd ff ff       	call   4e4 <write>
        ap++;
 79a:	83 c7 04             	add    $0x4,%edi
 79d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7a0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a3:	bf 00 00 00 00       	mov    $0x0,%edi
 7a8:	e9 a4 fe ff ff       	jmp    651 <printf+0x49>
        putc(fd, c);
 7ad:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	6a 01                	push   $0x1
 7b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7b8:	50                   	push   %eax
 7b9:	ff 75 08             	pushl  0x8(%ebp)
 7bc:	e8 23 fd ff ff       	call   4e4 <write>
 7c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c4:	bf 00 00 00 00       	mov    $0x0,%edi
 7c9:	e9 83 fe ff ff       	jmp    651 <printf+0x49>
    }
  }
}
 7ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7d1:	5b                   	pop    %ebx
 7d2:	5e                   	pop    %esi
 7d3:	5f                   	pop    %edi
 7d4:	5d                   	pop    %ebp
 7d5:	c3                   	ret    

000007d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d6:	f3 0f 1e fb          	endbr32 
 7da:	55                   	push   %ebp
 7db:	89 e5                	mov    %esp,%ebp
 7dd:	57                   	push   %edi
 7de:	56                   	push   %esi
 7df:	53                   	push   %ebx
 7e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e3:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	a1 50 0c 00 00       	mov    0xc50,%eax
 7eb:	eb 0c                	jmp    7f9 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	39 c2                	cmp    %eax,%edx
 7f1:	77 04                	ja     7f7 <free+0x21>
 7f3:	39 ca                	cmp    %ecx,%edx
 7f5:	77 10                	ja     807 <free+0x31>
{
 7f7:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f9:	39 c8                	cmp    %ecx,%eax
 7fb:	73 f0                	jae    7ed <free+0x17>
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	39 ca                	cmp    %ecx,%edx
 801:	77 04                	ja     807 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 803:	39 c2                	cmp    %eax,%edx
 805:	77 f0                	ja     7f7 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
 807:	8b 73 fc             	mov    -0x4(%ebx),%esi
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80f:	39 fa                	cmp    %edi,%edx
 811:	74 19                	je     82c <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 813:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 816:	8b 50 04             	mov    0x4(%eax),%edx
 819:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 81c:	39 f1                	cmp    %esi,%ecx
 81e:	74 1b                	je     83b <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 820:	89 08                	mov    %ecx,(%eax)
  freep = p;
 822:	a3 50 0c 00 00       	mov    %eax,0xc50
}
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 82c:	03 72 04             	add    0x4(%edx),%esi
 82f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	8b 10                	mov    (%eax),%edx
 834:	8b 12                	mov    (%edx),%edx
 836:	89 53 f8             	mov    %edx,-0x8(%ebx)
 839:	eb db                	jmp    816 <free+0x40>
    p->s.size += bp->s.size;
 83b:	03 53 fc             	add    -0x4(%ebx),%edx
 83e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 841:	8b 53 f8             	mov    -0x8(%ebx),%edx
 844:	89 10                	mov    %edx,(%eax)
 846:	eb da                	jmp    822 <free+0x4c>

00000848 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 848:	f3 0f 1e fb          	endbr32 
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	57                   	push   %edi
 850:	56                   	push   %esi
 851:	53                   	push   %ebx
 852:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	8d 58 07             	lea    0x7(%eax),%ebx
 85b:	c1 eb 03             	shr    $0x3,%ebx
 85e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 861:	8b 15 50 0c 00 00    	mov    0xc50,%edx
 867:	85 d2                	test   %edx,%edx
 869:	74 20                	je     88b <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 86d:	8b 48 04             	mov    0x4(%eax),%ecx
 870:	39 cb                	cmp    %ecx,%ebx
 872:	76 3c                	jbe    8b0 <malloc+0x68>
 874:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 87a:	be 00 10 00 00       	mov    $0x1000,%esi
 87f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 882:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 889:	eb 72                	jmp    8fd <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
 88b:	c7 05 50 0c 00 00 54 	movl   $0xc54,0xc50
 892:	0c 00 00 
 895:	c7 05 54 0c 00 00 54 	movl   $0xc54,0xc54
 89c:	0c 00 00 
    base.s.size = 0;
 89f:	c7 05 58 0c 00 00 00 	movl   $0x0,0xc58
 8a6:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a9:	b8 54 0c 00 00       	mov    $0xc54,%eax
 8ae:	eb c4                	jmp    874 <malloc+0x2c>
      if(p->s.size == nunits)
 8b0:	39 cb                	cmp    %ecx,%ebx
 8b2:	74 1e                	je     8d2 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8b4:	29 d9                	sub    %ebx,%ecx
 8b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8bc:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 8bf:	89 15 50 0c 00 00    	mov    %edx,0xc50
      return (void*)(p + 1);
 8c5:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c8:	89 d0                	mov    %edx,%eax
 8ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8cd:	5b                   	pop    %ebx
 8ce:	5e                   	pop    %esi
 8cf:	5f                   	pop    %edi
 8d0:	5d                   	pop    %ebp
 8d1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 8d2:	8b 08                	mov    (%eax),%ecx
 8d4:	89 0a                	mov    %ecx,(%edx)
 8d6:	eb e7                	jmp    8bf <malloc+0x77>
  hp->s.size = nu;
 8d8:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8db:	83 ec 0c             	sub    $0xc,%esp
 8de:	83 c0 08             	add    $0x8,%eax
 8e1:	50                   	push   %eax
 8e2:	e8 ef fe ff ff       	call   7d6 <free>
  return freep;
 8e7:	8b 15 50 0c 00 00    	mov    0xc50,%edx
      if((p = morecore(nunits)) == 0)
 8ed:	83 c4 10             	add    $0x10,%esp
 8f0:	85 d2                	test   %edx,%edx
 8f2:	74 d4                	je     8c8 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8f6:	8b 48 04             	mov    0x4(%eax),%ecx
 8f9:	39 d9                	cmp    %ebx,%ecx
 8fb:	73 b3                	jae    8b0 <malloc+0x68>
    if(p == freep)
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	39 05 50 0c 00 00    	cmp    %eax,0xc50
 905:	75 ed                	jne    8f4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	57                   	push   %edi
 90b:	e8 3c fc ff ff       	call   54c <sbrk>
  if(p == (char*)-1)
 910:	83 c4 10             	add    $0x10,%esp
 913:	83 f8 ff             	cmp    $0xffffffff,%eax
 916:	75 c0                	jne    8d8 <malloc+0x90>
        return 0;
 918:	ba 00 00 00 00       	mov    $0x0,%edx
 91d:	eb a9                	jmp    8c8 <malloc+0x80>
