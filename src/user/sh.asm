
user/_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
   8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   b:	83 ec 08             	sub    $0x8,%esp
   e:	68 cc 0f 00 00       	push   $0xfcc
  13:	6a 02                	push   $0x2
  15:	e8 b9 0c 00 00       	call   cd3 <printf>
  memset(buf, 0, nbuf);
  1a:	83 c4 0c             	add    $0xc,%esp
  1d:	56                   	push   %esi
  1e:	6a 00                	push   $0x0
  20:	53                   	push   %ebx
  21:	e8 12 0a 00 00       	call   a38 <memset>
  gets(buf, nbuf);
  26:	83 c4 08             	add    $0x8,%esp
  29:	56                   	push   %esi
  2a:	53                   	push   %ebx
  2b:	e8 4e 0a 00 00       	call   a7e <gets>
  if(buf[0] == 0) // EOF
  30:	83 c4 10             	add    $0x10,%esp
  33:	80 3b 01             	cmpb   $0x1,(%ebx)
  36:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
  38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3b:	5b                   	pop    %ebx
  3c:	5e                   	pop    %esi
  3d:	5d                   	pop    %ebp
  3e:	c3                   	ret    

0000003f <panic>:
  exit();
}

void
panic(char *s)
{
  3f:	55                   	push   %ebp
  40:	89 e5                	mov    %esp,%ebp
  42:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  45:	ff 75 08             	push   0x8(%ebp)
  48:	68 69 10 00 00       	push   $0x1069
  4d:	6a 02                	push   $0x2
  4f:	e8 7f 0c 00 00       	call   cd3 <printf>
  exit();
  54:	e8 32 0b 00 00       	call   b8b <exit>

00000059 <fork1>:
}

int
fork1(void)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  5f:	e8 1f 0b 00 00       	call   b83 <fork>
  if(pid == -1)
  64:	83 f8 ff             	cmp    $0xffffffff,%eax
  67:	74 02                	je     6b <fork1+0x12>
    panic("fork");
  return pid;
}
  69:	c9                   	leave  
  6a:	c3                   	ret    
    panic("fork");
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	68 cf 0f 00 00       	push   $0xfcf
  73:	e8 c7 ff ff ff       	call   3f <panic>

00000078 <runcmd>:
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	83 ec 14             	sub    $0x14,%esp
  7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  82:	85 db                	test   %ebx,%ebx
  84:	74 0e                	je     94 <runcmd+0x1c>
  switch(cmd->type){
  86:	83 3b 05             	cmpl   $0x5,(%ebx)
  89:	77 0e                	ja     99 <runcmd+0x21>
  8b:	8b 03                	mov    (%ebx),%eax
  8d:	ff 24 85 84 10 00 00 	jmp    *0x1084(,%eax,4)
    exit();
  94:	e8 f2 0a 00 00       	call   b8b <exit>
    panic("runcmd");
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	68 d4 0f 00 00       	push   $0xfd4
  a1:	e8 99 ff ff ff       	call   3f <panic>
    if(ecmd->argv[0] == 0)
  a6:	8b 43 04             	mov    0x4(%ebx),%eax
  a9:	85 c0                	test   %eax,%eax
  ab:	74 27                	je     d4 <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	8d 53 04             	lea    0x4(%ebx),%edx
  b3:	52                   	push   %edx
  b4:	50                   	push   %eax
  b5:	e8 09 0b 00 00       	call   bc3 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  ba:	83 c4 0c             	add    $0xc,%esp
  bd:	ff 73 04             	push   0x4(%ebx)
  c0:	68 db 0f 00 00       	push   $0xfdb
  c5:	6a 02                	push   $0x2
  c7:	e8 07 0c 00 00       	call   cd3 <printf>
    break;
  cc:	83 c4 10             	add    $0x10,%esp
  exit();
  cf:	e8 b7 0a 00 00       	call   b8b <exit>
      exit();
  d4:	e8 b2 0a 00 00       	call   b8b <exit>
    close(rcmd->fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 73 14             	push   0x14(%ebx)
  df:	e8 cf 0a 00 00       	call   bb3 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
  e4:	83 c4 08             	add    $0x8,%esp
  e7:	ff 73 10             	push   0x10(%ebx)
  ea:	ff 73 08             	push   0x8(%ebx)
  ed:	e8 d9 0a 00 00       	call   bcb <open>
  f2:	83 c4 10             	add    $0x10,%esp
  f5:	85 c0                	test   %eax,%eax
  f7:	78 0b                	js     104 <runcmd+0x8c>
    runcmd(rcmd->cmd);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 73 04             	push   0x4(%ebx)
  ff:	e8 74 ff ff ff       	call   78 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 104:	83 ec 04             	sub    $0x4,%esp
 107:	ff 73 08             	push   0x8(%ebx)
 10a:	68 eb 0f 00 00       	push   $0xfeb
 10f:	6a 02                	push   $0x2
 111:	e8 bd 0b 00 00       	call   cd3 <printf>
      exit();
 116:	e8 70 0a 00 00       	call   b8b <exit>
    if(fork1() == 0)
 11b:	e8 39 ff ff ff       	call   59 <fork1>
 120:	85 c0                	test   %eax,%eax
 122:	74 10                	je     134 <runcmd+0xbc>
    wait();
 124:	e8 6a 0a 00 00       	call   b93 <wait>
    runcmd(lcmd->right);
 129:	83 ec 0c             	sub    $0xc,%esp
 12c:	ff 73 08             	push   0x8(%ebx)
 12f:	e8 44 ff ff ff       	call   78 <runcmd>
      runcmd(lcmd->left);
 134:	83 ec 0c             	sub    $0xc,%esp
 137:	ff 73 04             	push   0x4(%ebx)
 13a:	e8 39 ff ff ff       	call   78 <runcmd>
    if(pipe(p) < 0)
 13f:	83 ec 0c             	sub    $0xc,%esp
 142:	8d 45 f0             	lea    -0x10(%ebp),%eax
 145:	50                   	push   %eax
 146:	e8 50 0a 00 00       	call   b9b <pipe>
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	78 3a                	js     18c <runcmd+0x114>
    if(fork1() == 0){
 152:	e8 02 ff ff ff       	call   59 <fork1>
 157:	85 c0                	test   %eax,%eax
 159:	74 3e                	je     199 <runcmd+0x121>
    if(fork1() == 0){
 15b:	e8 f9 fe ff ff       	call   59 <fork1>
 160:	85 c0                	test   %eax,%eax
 162:	74 6b                	je     1cf <runcmd+0x157>
    close(p[0]);
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 f0             	push   -0x10(%ebp)
 16a:	e8 44 0a 00 00       	call   bb3 <close>
    close(p[1]);
 16f:	83 c4 04             	add    $0x4,%esp
 172:	ff 75 f4             	push   -0xc(%ebp)
 175:	e8 39 0a 00 00       	call   bb3 <close>
    wait();
 17a:	e8 14 0a 00 00       	call   b93 <wait>
    wait();
 17f:	e8 0f 0a 00 00       	call   b93 <wait>
    break;
 184:	83 c4 10             	add    $0x10,%esp
 187:	e9 43 ff ff ff       	jmp    cf <runcmd+0x57>
      panic("pipe");
 18c:	83 ec 0c             	sub    $0xc,%esp
 18f:	68 fb 0f 00 00       	push   $0xffb
 194:	e8 a6 fe ff ff       	call   3f <panic>
      close(1);
 199:	83 ec 0c             	sub    $0xc,%esp
 19c:	6a 01                	push   $0x1
 19e:	e8 10 0a 00 00       	call   bb3 <close>
      dup(p[1]);
 1a3:	83 c4 04             	add    $0x4,%esp
 1a6:	ff 75 f4             	push   -0xc(%ebp)
 1a9:	e8 55 0a 00 00       	call   c03 <dup>
      close(p[0]);
 1ae:	83 c4 04             	add    $0x4,%esp
 1b1:	ff 75 f0             	push   -0x10(%ebp)
 1b4:	e8 fa 09 00 00       	call   bb3 <close>
      close(p[1]);
 1b9:	83 c4 04             	add    $0x4,%esp
 1bc:	ff 75 f4             	push   -0xc(%ebp)
 1bf:	e8 ef 09 00 00       	call   bb3 <close>
      runcmd(pcmd->left);
 1c4:	83 c4 04             	add    $0x4,%esp
 1c7:	ff 73 04             	push   0x4(%ebx)
 1ca:	e8 a9 fe ff ff       	call   78 <runcmd>
      close(0);
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	6a 00                	push   $0x0
 1d4:	e8 da 09 00 00       	call   bb3 <close>
      dup(p[0]);
 1d9:	83 c4 04             	add    $0x4,%esp
 1dc:	ff 75 f0             	push   -0x10(%ebp)
 1df:	e8 1f 0a 00 00       	call   c03 <dup>
      close(p[0]);
 1e4:	83 c4 04             	add    $0x4,%esp
 1e7:	ff 75 f0             	push   -0x10(%ebp)
 1ea:	e8 c4 09 00 00       	call   bb3 <close>
      close(p[1]);
 1ef:	83 c4 04             	add    $0x4,%esp
 1f2:	ff 75 f4             	push   -0xc(%ebp)
 1f5:	e8 b9 09 00 00       	call   bb3 <close>
      runcmd(pcmd->right);
 1fa:	83 c4 04             	add    $0x4,%esp
 1fd:	ff 73 08             	push   0x8(%ebx)
 200:	e8 73 fe ff ff       	call   78 <runcmd>
    if(fork1() == 0)
 205:	e8 4f fe ff ff       	call   59 <fork1>
 20a:	85 c0                	test   %eax,%eax
 20c:	0f 85 bd fe ff ff    	jne    cf <runcmd+0x57>
      runcmd(bcmd->cmd);
 212:	83 ec 0c             	sub    $0xc,%esp
 215:	ff 73 04             	push   0x4(%ebx)
 218:	e8 5b fe ff ff       	call   78 <runcmd>

0000021d <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	53                   	push   %ebx
 221:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 224:	6a 54                	push   $0x54
 226:	e8 cf 0c 00 00       	call   efa <malloc>
 22b:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 22d:	83 c4 0c             	add    $0xc,%esp
 230:	6a 54                	push   $0x54
 232:	6a 00                	push   $0x0
 234:	50                   	push   %eax
 235:	e8 fe 07 00 00       	call   a38 <memset>
  cmd->type = EXEC;
 23a:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 240:	89 d8                	mov    %ebx,%eax
 242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 245:	c9                   	leave  
 246:	c3                   	ret    

00000247 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	53                   	push   %ebx
 24b:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 24e:	6a 18                	push   $0x18
 250:	e8 a5 0c 00 00       	call   efa <malloc>
 255:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 257:	83 c4 0c             	add    $0xc,%esp
 25a:	6a 18                	push   $0x18
 25c:	6a 00                	push   $0x0
 25e:	50                   	push   %eax
 25f:	e8 d4 07 00 00       	call   a38 <memset>
  cmd->type = REDIR;
 264:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 270:	8b 45 0c             	mov    0xc(%ebp),%eax
 273:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 276:	8b 45 10             	mov    0x10(%ebp),%eax
 279:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 27c:	8b 45 14             	mov    0x14(%ebp),%eax
 27f:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 282:	8b 45 18             	mov    0x18(%ebp),%eax
 285:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 288:	89 d8                	mov    %ebx,%eax
 28a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	53                   	push   %ebx
 293:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 296:	6a 0c                	push   $0xc
 298:	e8 5d 0c 00 00       	call   efa <malloc>
 29d:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 29f:	83 c4 0c             	add    $0xc,%esp
 2a2:	6a 0c                	push   $0xc
 2a4:	6a 00                	push   $0x0
 2a6:	50                   	push   %eax
 2a7:	e8 8c 07 00 00       	call   a38 <memset>
  cmd->type = PIPE;
 2ac:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 2be:	89 d8                	mov    %ebx,%eax
 2c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	53                   	push   %ebx
 2c9:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2cc:	6a 0c                	push   $0xc
 2ce:	e8 27 0c 00 00       	call   efa <malloc>
 2d3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2d5:	83 c4 0c             	add    $0xc,%esp
 2d8:	6a 0c                	push   $0xc
 2da:	6a 00                	push   $0x0
 2dc:	50                   	push   %eax
 2dd:	e8 56 07 00 00       	call   a38 <memset>
  cmd->type = LIST;
 2e2:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 2f4:	89 d8                	mov    %ebx,%eax
 2f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f9:	c9                   	leave  
 2fa:	c3                   	ret    

000002fb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 2fb:	55                   	push   %ebp
 2fc:	89 e5                	mov    %esp,%ebp
 2fe:	53                   	push   %ebx
 2ff:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 302:	6a 08                	push   $0x8
 304:	e8 f1 0b 00 00       	call   efa <malloc>
 309:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 30b:	83 c4 0c             	add    $0xc,%esp
 30e:	6a 08                	push   $0x8
 310:	6a 00                	push   $0x0
 312:	50                   	push   %eax
 313:	e8 20 07 00 00       	call   a38 <memset>
  cmd->type = BACK;
 318:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 324:	89 d8                	mov    %ebx,%eax
 326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 329:	c9                   	leave  
 32a:	c3                   	ret    

0000032b <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	57                   	push   %edi
 32f:	56                   	push   %esi
 330:	53                   	push   %ebx
 331:	83 ec 0c             	sub    $0xc,%esp
 334:	8b 75 0c             	mov    0xc(%ebp),%esi
 337:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 33f:	39 f3                	cmp    %esi,%ebx
 341:	73 21                	jae    364 <gettoken+0x39>
 343:	83 ec 08             	sub    $0x8,%esp
 346:	0f be 03             	movsbl (%ebx),%eax
 349:	50                   	push   %eax
 34a:	68 5c 16 00 00       	push   $0x165c
 34f:	e8 fd 06 00 00       	call   a51 <strchr>
 354:	83 c4 10             	add    $0x10,%esp
 357:	85 c0                	test   %eax,%eax
 359:	74 09                	je     364 <gettoken+0x39>
    s++;
 35b:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 35e:	39 de                	cmp    %ebx,%esi
 360:	75 e1                	jne    343 <gettoken+0x18>
    s++;
 362:	89 f3                	mov    %esi,%ebx
  if(q)
 364:	85 ff                	test   %edi,%edi
 366:	74 02                	je     36a <gettoken+0x3f>
    *q = s;
 368:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 36a:	0f b6 03             	movzbl (%ebx),%eax
 36d:	0f be f8             	movsbl %al,%edi
  switch(*s){
 370:	3c 3c                	cmp    $0x3c,%al
 372:	7f 57                	jg     3cb <gettoken+0xa0>
 374:	3c 3a                	cmp    $0x3a,%al
 376:	7f 11                	jg     389 <gettoken+0x5e>
 378:	84 c0                	test   %al,%al
 37a:	74 10                	je     38c <gettoken+0x61>
 37c:	78 67                	js     3e5 <gettoken+0xba>
 37e:	3c 26                	cmp    $0x26,%al
 380:	74 07                	je     389 <gettoken+0x5e>
 382:	83 e8 28             	sub    $0x28,%eax
 385:	3c 01                	cmp    $0x1,%al
 387:	77 5c                	ja     3e5 <gettoken+0xba>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 389:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 38c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 390:	74 05                	je     397 <gettoken+0x6c>
    *eq = s;
 392:	8b 45 14             	mov    0x14(%ebp),%eax
 395:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
 397:	39 f3                	cmp    %esi,%ebx
 399:	73 21                	jae    3bc <gettoken+0x91>
 39b:	83 ec 08             	sub    $0x8,%esp
 39e:	0f be 03             	movsbl (%ebx),%eax
 3a1:	50                   	push   %eax
 3a2:	68 5c 16 00 00       	push   $0x165c
 3a7:	e8 a5 06 00 00       	call   a51 <strchr>
 3ac:	83 c4 10             	add    $0x10,%esp
 3af:	85 c0                	test   %eax,%eax
 3b1:	74 09                	je     3bc <gettoken+0x91>
    s++;
 3b3:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 3b6:	39 de                	cmp    %ebx,%esi
 3b8:	75 e1                	jne    39b <gettoken+0x70>
    s++;
 3ba:	89 f3                	mov    %esi,%ebx
  *ps = s;
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 3c1:	89 f8                	mov    %edi,%eax
 3c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c6:	5b                   	pop    %ebx
 3c7:	5e                   	pop    %esi
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    
  switch(*s){
 3cb:	3c 3e                	cmp    $0x3e,%al
 3cd:	75 12                	jne    3e1 <gettoken+0xb6>
    s++;
 3cf:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 3d2:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 3d6:	74 5b                	je     433 <gettoken+0x108>
    s++;
 3d8:	89 c3                	mov    %eax,%ebx
  ret = *s;
 3da:	bf 3e 00 00 00       	mov    $0x3e,%edi
 3df:	eb ab                	jmp    38c <gettoken+0x61>
  switch(*s){
 3e1:	3c 7c                	cmp    $0x7c,%al
 3e3:	74 a4                	je     389 <gettoken+0x5e>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 3e5:	39 de                	cmp    %ebx,%esi
 3e7:	76 39                	jbe    422 <gettoken+0xf7>
 3e9:	83 ec 08             	sub    $0x8,%esp
 3ec:	0f be 03             	movsbl (%ebx),%eax
 3ef:	50                   	push   %eax
 3f0:	68 5c 16 00 00       	push   $0x165c
 3f5:	e8 57 06 00 00       	call   a51 <strchr>
 3fa:	83 c4 10             	add    $0x10,%esp
 3fd:	85 c0                	test   %eax,%eax
 3ff:	75 49                	jne    44a <gettoken+0x11f>
 401:	83 ec 08             	sub    $0x8,%esp
 404:	0f be 03             	movsbl (%ebx),%eax
 407:	50                   	push   %eax
 408:	68 54 16 00 00       	push   $0x1654
 40d:	e8 3f 06 00 00       	call   a51 <strchr>
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	75 27                	jne    440 <gettoken+0x115>
      s++;
 419:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 41c:	39 de                	cmp    %ebx,%esi
 41e:	75 c9                	jne    3e9 <gettoken+0xbe>
      s++;
 420:	89 f3                	mov    %esi,%ebx
  if(eq)
 422:	bf 61 00 00 00       	mov    $0x61,%edi
 427:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42b:	0f 85 61 ff ff ff    	jne    392 <gettoken+0x67>
 431:	eb 89                	jmp    3bc <gettoken+0x91>
      s++;
 433:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 436:	bf 2b 00 00 00       	mov    $0x2b,%edi
 43b:	e9 4c ff ff ff       	jmp    38c <gettoken+0x61>
    ret = 'a';
 440:	bf 61 00 00 00       	mov    $0x61,%edi
 445:	e9 42 ff ff ff       	jmp    38c <gettoken+0x61>
 44a:	bf 61 00 00 00       	mov    $0x61,%edi
 44f:	e9 38 ff ff ff       	jmp    38c <gettoken+0x61>

00000454 <peek>:

int
peek(char **ps, char *es, char *toks)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	57                   	push   %edi
 458:	56                   	push   %esi
 459:	53                   	push   %ebx
 45a:	83 ec 0c             	sub    $0xc,%esp
 45d:	8b 7d 08             	mov    0x8(%ebp),%edi
 460:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 463:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 465:	39 f3                	cmp    %esi,%ebx
 467:	73 21                	jae    48a <peek+0x36>
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	0f be 03             	movsbl (%ebx),%eax
 46f:	50                   	push   %eax
 470:	68 5c 16 00 00       	push   $0x165c
 475:	e8 d7 05 00 00       	call   a51 <strchr>
 47a:	83 c4 10             	add    $0x10,%esp
 47d:	85 c0                	test   %eax,%eax
 47f:	74 09                	je     48a <peek+0x36>
    s++;
 481:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 484:	39 de                	cmp    %ebx,%esi
 486:	75 e1                	jne    469 <peek+0x15>
    s++;
 488:	89 f3                	mov    %esi,%ebx
  *ps = s;
 48a:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 48c:	0f b6 03             	movzbl (%ebx),%eax
 48f:	ba 00 00 00 00       	mov    $0x0,%edx
 494:	84 c0                	test   %al,%al
 496:	75 0a                	jne    4a2 <peek+0x4e>
}
 498:	89 d0                	mov    %edx,%eax
 49a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49d:	5b                   	pop    %ebx
 49e:	5e                   	pop    %esi
 49f:	5f                   	pop    %edi
 4a0:	5d                   	pop    %ebp
 4a1:	c3                   	ret    
  return *s && strchr(toks, *s);
 4a2:	83 ec 08             	sub    $0x8,%esp
 4a5:	0f be c0             	movsbl %al,%eax
 4a8:	50                   	push   %eax
 4a9:	ff 75 10             	push   0x10(%ebp)
 4ac:	e8 a0 05 00 00       	call   a51 <strchr>
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	85 c0                	test   %eax,%eax
 4b6:	0f 95 c2             	setne  %dl
 4b9:	0f b6 d2             	movzbl %dl,%edx
 4bc:	eb da                	jmp    498 <peek+0x44>

000004be <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	57                   	push   %edi
 4c2:	56                   	push   %esi
 4c3:	53                   	push   %ebx
 4c4:	83 ec 1c             	sub    $0x1c,%esp
 4c7:	8b 75 0c             	mov    0xc(%ebp),%esi
 4ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 4cd:	eb 28                	jmp    4f7 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 4cf:	83 ec 0c             	sub    $0xc,%esp
 4d2:	68 00 10 00 00       	push   $0x1000
 4d7:	e8 63 fb ff ff       	call   3f <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 4dc:	83 ec 0c             	sub    $0xc,%esp
 4df:	6a 00                	push   $0x0
 4e1:	6a 00                	push   $0x0
 4e3:	ff 75 e0             	push   -0x20(%ebp)
 4e6:	ff 75 e4             	push   -0x1c(%ebp)
 4e9:	ff 75 08             	push   0x8(%ebp)
 4ec:	e8 56 fd ff ff       	call   247 <redircmd>
 4f1:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 4f4:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 4f7:	83 ec 04             	sub    $0x4,%esp
 4fa:	68 1d 10 00 00       	push   $0x101d
 4ff:	57                   	push   %edi
 500:	56                   	push   %esi
 501:	e8 4e ff ff ff       	call   454 <peek>
 506:	83 c4 10             	add    $0x10,%esp
 509:	85 c0                	test   %eax,%eax
 50b:	74 76                	je     583 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
 50d:	6a 00                	push   $0x0
 50f:	6a 00                	push   $0x0
 511:	57                   	push   %edi
 512:	56                   	push   %esi
 513:	e8 13 fe ff ff       	call   32b <gettoken>
 518:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 51a:	8d 45 e0             	lea    -0x20(%ebp),%eax
 51d:	50                   	push   %eax
 51e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 521:	50                   	push   %eax
 522:	57                   	push   %edi
 523:	56                   	push   %esi
 524:	e8 02 fe ff ff       	call   32b <gettoken>
 529:	83 c4 20             	add    $0x20,%esp
 52c:	83 f8 61             	cmp    $0x61,%eax
 52f:	75 9e                	jne    4cf <parseredirs+0x11>
    switch(tok){
 531:	83 fb 3c             	cmp    $0x3c,%ebx
 534:	74 a6                	je     4dc <parseredirs+0x1e>
 536:	83 fb 3e             	cmp    $0x3e,%ebx
 539:	74 25                	je     560 <parseredirs+0xa2>
 53b:	83 fb 2b             	cmp    $0x2b,%ebx
 53e:	75 b7                	jne    4f7 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	6a 01                	push   $0x1
 545:	68 01 02 00 00       	push   $0x201
 54a:	ff 75 e0             	push   -0x20(%ebp)
 54d:	ff 75 e4             	push   -0x1c(%ebp)
 550:	ff 75 08             	push   0x8(%ebp)
 553:	e8 ef fc ff ff       	call   247 <redircmd>
 558:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 55b:	83 c4 20             	add    $0x20,%esp
 55e:	eb 97                	jmp    4f7 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 560:	83 ec 0c             	sub    $0xc,%esp
 563:	6a 01                	push   $0x1
 565:	68 01 02 00 00       	push   $0x201
 56a:	ff 75 e0             	push   -0x20(%ebp)
 56d:	ff 75 e4             	push   -0x1c(%ebp)
 570:	ff 75 08             	push   0x8(%ebp)
 573:	e8 cf fc ff ff       	call   247 <redircmd>
 578:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 57b:	83 c4 20             	add    $0x20,%esp
 57e:	e9 74 ff ff ff       	jmp    4f7 <parseredirs+0x39>
    }
  }
  return cmd;
}
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	8d 65 f4             	lea    -0xc(%ebp),%esp
 589:	5b                   	pop    %ebx
 58a:	5e                   	pop    %esi
 58b:	5f                   	pop    %edi
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	57                   	push   %edi
 592:	56                   	push   %esi
 593:	53                   	push   %ebx
 594:	83 ec 30             	sub    $0x30,%esp
 597:	8b 75 08             	mov    0x8(%ebp),%esi
 59a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 59d:	68 20 10 00 00       	push   $0x1020
 5a2:	57                   	push   %edi
 5a3:	56                   	push   %esi
 5a4:	e8 ab fe ff ff       	call   454 <peek>
 5a9:	83 c4 10             	add    $0x10,%esp
 5ac:	85 c0                	test   %eax,%eax
 5ae:	75 1d                	jne    5cd <parseexec+0x3f>
 5b0:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5b2:	e8 66 fc ff ff       	call   21d <execcmd>
 5b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	57                   	push   %edi
 5be:	56                   	push   %esi
 5bf:	50                   	push   %eax
 5c0:	e8 f9 fe ff ff       	call   4be <parseredirs>
 5c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	eb 3b                	jmp    608 <parseexec+0x7a>
    return parseblock(ps, es);
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	57                   	push   %edi
 5d1:	56                   	push   %esi
 5d2:	e8 8f 01 00 00       	call   766 <parseblock>
 5d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5da:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 5dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e3:	5b                   	pop    %ebx
 5e4:	5e                   	pop    %esi
 5e5:	5f                   	pop    %edi
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    
      panic("syntax");
 5e8:	83 ec 0c             	sub    $0xc,%esp
 5eb:	68 22 10 00 00       	push   $0x1022
 5f0:	e8 4a fa ff ff       	call   3f <panic>
    ret = parseredirs(ret, ps, es);
 5f5:	83 ec 04             	sub    $0x4,%esp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	ff 75 d4             	push   -0x2c(%ebp)
 5fd:	e8 bc fe ff ff       	call   4be <parseredirs>
 602:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 605:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
 608:	83 ec 04             	sub    $0x4,%esp
 60b:	68 37 10 00 00       	push   $0x1037
 610:	57                   	push   %edi
 611:	56                   	push   %esi
 612:	e8 3d fe ff ff       	call   454 <peek>
 617:	83 c4 10             	add    $0x10,%esp
 61a:	85 c0                	test   %eax,%eax
 61c:	75 41                	jne    65f <parseexec+0xd1>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 61e:	8d 45 e0             	lea    -0x20(%ebp),%eax
 621:	50                   	push   %eax
 622:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 625:	50                   	push   %eax
 626:	57                   	push   %edi
 627:	56                   	push   %esi
 628:	e8 fe fc ff ff       	call   32b <gettoken>
 62d:	83 c4 10             	add    $0x10,%esp
 630:	85 c0                	test   %eax,%eax
 632:	74 2b                	je     65f <parseexec+0xd1>
    if(tok != 'a')
 634:	83 f8 61             	cmp    $0x61,%eax
 637:	75 af                	jne    5e8 <parseexec+0x5a>
    cmd->argv[argc] = q;
 639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63c:	8b 55 d0             	mov    -0x30(%ebp),%edx
 63f:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 643:	8b 45 e0             	mov    -0x20(%ebp),%eax
 646:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
 64a:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
 64d:	83 fb 0a             	cmp    $0xa,%ebx
 650:	75 a3                	jne    5f5 <parseexec+0x67>
      panic("too many args");
 652:	83 ec 0c             	sub    $0xc,%esp
 655:	68 29 10 00 00       	push   $0x1029
 65a:	e8 e0 f9 ff ff       	call   3f <panic>
  cmd->argv[argc] = 0;
 65f:	8b 45 d0             	mov    -0x30(%ebp),%eax
 662:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 669:	00 
  cmd->eargv[argc] = 0;
 66a:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
 671:	00 
  return ret;
 672:	e9 66 ff ff ff       	jmp    5dd <parseexec+0x4f>

00000677 <parsepipe>:
{
 677:	55                   	push   %ebp
 678:	89 e5                	mov    %esp,%ebp
 67a:	57                   	push   %edi
 67b:	56                   	push   %esi
 67c:	53                   	push   %ebx
 67d:	83 ec 14             	sub    $0x14,%esp
 680:	8b 75 08             	mov    0x8(%ebp),%esi
 683:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 686:	57                   	push   %edi
 687:	56                   	push   %esi
 688:	e8 01 ff ff ff       	call   58e <parseexec>
 68d:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 68f:	83 c4 0c             	add    $0xc,%esp
 692:	68 3c 10 00 00       	push   $0x103c
 697:	57                   	push   %edi
 698:	56                   	push   %esi
 699:	e8 b6 fd ff ff       	call   454 <peek>
 69e:	83 c4 10             	add    $0x10,%esp
 6a1:	85 c0                	test   %eax,%eax
 6a3:	75 0a                	jne    6af <parsepipe+0x38>
}
 6a5:	89 d8                	mov    %ebx,%eax
 6a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6aa:	5b                   	pop    %ebx
 6ab:	5e                   	pop    %esi
 6ac:	5f                   	pop    %edi
 6ad:	5d                   	pop    %ebp
 6ae:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6af:	6a 00                	push   $0x0
 6b1:	6a 00                	push   $0x0
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	e8 71 fc ff ff       	call   32b <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 6ba:	83 c4 08             	add    $0x8,%esp
 6bd:	57                   	push   %edi
 6be:	56                   	push   %esi
 6bf:	e8 b3 ff ff ff       	call   677 <parsepipe>
 6c4:	83 c4 08             	add    $0x8,%esp
 6c7:	50                   	push   %eax
 6c8:	53                   	push   %ebx
 6c9:	e8 c1 fb ff ff       	call   28f <pipecmd>
 6ce:	89 c3                	mov    %eax,%ebx
 6d0:	83 c4 10             	add    $0x10,%esp
  return cmd;
 6d3:	eb d0                	jmp    6a5 <parsepipe+0x2e>

000006d5 <parseline>:
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	83 ec 14             	sub    $0x14,%esp
 6de:	8b 75 08             	mov    0x8(%ebp),%esi
 6e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 6e4:	57                   	push   %edi
 6e5:	56                   	push   %esi
 6e6:	e8 8c ff ff ff       	call   677 <parsepipe>
 6eb:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	eb 18                	jmp    70a <parseline+0x35>
    gettoken(ps, es, 0, 0);
 6f2:	6a 00                	push   $0x0
 6f4:	6a 00                	push   $0x0
 6f6:	57                   	push   %edi
 6f7:	56                   	push   %esi
 6f8:	e8 2e fc ff ff       	call   32b <gettoken>
    cmd = backcmd(cmd);
 6fd:	89 1c 24             	mov    %ebx,(%esp)
 700:	e8 f6 fb ff ff       	call   2fb <backcmd>
 705:	89 c3                	mov    %eax,%ebx
 707:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
 70a:	83 ec 04             	sub    $0x4,%esp
 70d:	68 3e 10 00 00       	push   $0x103e
 712:	57                   	push   %edi
 713:	56                   	push   %esi
 714:	e8 3b fd ff ff       	call   454 <peek>
 719:	83 c4 10             	add    $0x10,%esp
 71c:	85 c0                	test   %eax,%eax
 71e:	75 d2                	jne    6f2 <parseline+0x1d>
  if(peek(ps, es, ";")){
 720:	83 ec 04             	sub    $0x4,%esp
 723:	68 3a 10 00 00       	push   $0x103a
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	e8 25 fd ff ff       	call   454 <peek>
 72f:	83 c4 10             	add    $0x10,%esp
 732:	85 c0                	test   %eax,%eax
 734:	75 0a                	jne    740 <parseline+0x6b>
}
 736:	89 d8                	mov    %ebx,%eax
 738:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 740:	6a 00                	push   $0x0
 742:	6a 00                	push   $0x0
 744:	57                   	push   %edi
 745:	56                   	push   %esi
 746:	e8 e0 fb ff ff       	call   32b <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 74b:	83 c4 08             	add    $0x8,%esp
 74e:	57                   	push   %edi
 74f:	56                   	push   %esi
 750:	e8 80 ff ff ff       	call   6d5 <parseline>
 755:	83 c4 08             	add    $0x8,%esp
 758:	50                   	push   %eax
 759:	53                   	push   %ebx
 75a:	e8 66 fb ff ff       	call   2c5 <listcmd>
 75f:	89 c3                	mov    %eax,%ebx
 761:	83 c4 10             	add    $0x10,%esp
  return cmd;
 764:	eb d0                	jmp    736 <parseline+0x61>

00000766 <parseblock>:
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	57                   	push   %edi
 76a:	56                   	push   %esi
 76b:	53                   	push   %ebx
 76c:	83 ec 10             	sub    $0x10,%esp
 76f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 772:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 775:	68 20 10 00 00       	push   $0x1020
 77a:	56                   	push   %esi
 77b:	53                   	push   %ebx
 77c:	e8 d3 fc ff ff       	call   454 <peek>
 781:	83 c4 10             	add    $0x10,%esp
 784:	85 c0                	test   %eax,%eax
 786:	74 4b                	je     7d3 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
 788:	6a 00                	push   $0x0
 78a:	6a 00                	push   $0x0
 78c:	56                   	push   %esi
 78d:	53                   	push   %ebx
 78e:	e8 98 fb ff ff       	call   32b <gettoken>
  cmd = parseline(ps, es);
 793:	83 c4 08             	add    $0x8,%esp
 796:	56                   	push   %esi
 797:	53                   	push   %ebx
 798:	e8 38 ff ff ff       	call   6d5 <parseline>
 79d:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 79f:	83 c4 0c             	add    $0xc,%esp
 7a2:	68 5c 10 00 00       	push   $0x105c
 7a7:	56                   	push   %esi
 7a8:	53                   	push   %ebx
 7a9:	e8 a6 fc ff ff       	call   454 <peek>
 7ae:	83 c4 10             	add    $0x10,%esp
 7b1:	85 c0                	test   %eax,%eax
 7b3:	74 2b                	je     7e0 <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
 7b5:	6a 00                	push   $0x0
 7b7:	6a 00                	push   $0x0
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	e8 6b fb ff ff       	call   32b <gettoken>
  cmd = parseredirs(cmd, ps, es);
 7c0:	83 c4 0c             	add    $0xc,%esp
 7c3:	56                   	push   %esi
 7c4:	53                   	push   %ebx
 7c5:	57                   	push   %edi
 7c6:	e8 f3 fc ff ff       	call   4be <parseredirs>
}
 7cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ce:	5b                   	pop    %ebx
 7cf:	5e                   	pop    %esi
 7d0:	5f                   	pop    %edi
 7d1:	5d                   	pop    %ebp
 7d2:	c3                   	ret    
    panic("parseblock");
 7d3:	83 ec 0c             	sub    $0xc,%esp
 7d6:	68 40 10 00 00       	push   $0x1040
 7db:	e8 5f f8 ff ff       	call   3f <panic>
    panic("syntax - missing )");
 7e0:	83 ec 0c             	sub    $0xc,%esp
 7e3:	68 4b 10 00 00       	push   $0x104b
 7e8:	e8 52 f8 ff ff       	call   3f <panic>

000007ed <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	53                   	push   %ebx
 7f1:	83 ec 04             	sub    $0x4,%esp
 7f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 7f7:	85 db                	test   %ebx,%ebx
 7f9:	74 3c                	je     837 <nulterminate+0x4a>
    return 0;

  switch(cmd->type){
 7fb:	83 3b 05             	cmpl   $0x5,(%ebx)
 7fe:	77 37                	ja     837 <nulterminate+0x4a>
 800:	8b 03                	mov    (%ebx),%eax
 802:	ff 24 85 9c 10 00 00 	jmp    *0x109c(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 809:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
 80d:	74 28                	je     837 <nulterminate+0x4a>
 80f:	8d 43 08             	lea    0x8(%ebx),%eax
      *ecmd->eargv[i] = 0;
 812:	8b 50 24             	mov    0x24(%eax),%edx
 815:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 818:	83 c0 04             	add    $0x4,%eax
 81b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
 81f:	75 f1                	jne    812 <nulterminate+0x25>
 821:	eb 14                	jmp    837 <nulterminate+0x4a>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	ff 73 04             	push   0x4(%ebx)
 829:	e8 bf ff ff ff       	call   7ed <nulterminate>
    *rcmd->efile = 0;
 82e:	8b 43 0c             	mov    0xc(%ebx),%eax
 831:	c6 00 00             	movb   $0x0,(%eax)
    break;
 834:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 837:	89 d8                	mov    %ebx,%eax
 839:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 83c:	c9                   	leave  
 83d:	c3                   	ret    
    nulterminate(pcmd->left);
 83e:	83 ec 0c             	sub    $0xc,%esp
 841:	ff 73 04             	push   0x4(%ebx)
 844:	e8 a4 ff ff ff       	call   7ed <nulterminate>
    nulterminate(pcmd->right);
 849:	83 c4 04             	add    $0x4,%esp
 84c:	ff 73 08             	push   0x8(%ebx)
 84f:	e8 99 ff ff ff       	call   7ed <nulterminate>
    break;
 854:	83 c4 10             	add    $0x10,%esp
 857:	eb de                	jmp    837 <nulterminate+0x4a>
    nulterminate(lcmd->left);
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	ff 73 04             	push   0x4(%ebx)
 85f:	e8 89 ff ff ff       	call   7ed <nulterminate>
    nulterminate(lcmd->right);
 864:	83 c4 04             	add    $0x4,%esp
 867:	ff 73 08             	push   0x8(%ebx)
 86a:	e8 7e ff ff ff       	call   7ed <nulterminate>
    break;
 86f:	83 c4 10             	add    $0x10,%esp
 872:	eb c3                	jmp    837 <nulterminate+0x4a>
    nulterminate(bcmd->cmd);
 874:	83 ec 0c             	sub    $0xc,%esp
 877:	ff 73 04             	push   0x4(%ebx)
 87a:	e8 6e ff ff ff       	call   7ed <nulterminate>
    break;
 87f:	83 c4 10             	add    $0x10,%esp
 882:	eb b3                	jmp    837 <nulterminate+0x4a>

00000884 <parsecmd>:
{
 884:	55                   	push   %ebp
 885:	89 e5                	mov    %esp,%ebp
 887:	56                   	push   %esi
 888:	53                   	push   %ebx
  es = s + strlen(s);
 889:	8b 5d 08             	mov    0x8(%ebp),%ebx
 88c:	83 ec 0c             	sub    $0xc,%esp
 88f:	53                   	push   %ebx
 890:	e8 7d 01 00 00       	call   a12 <strlen>
 895:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 897:	83 c4 08             	add    $0x8,%esp
 89a:	53                   	push   %ebx
 89b:	8d 45 08             	lea    0x8(%ebp),%eax
 89e:	50                   	push   %eax
 89f:	e8 31 fe ff ff       	call   6d5 <parseline>
 8a4:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8a6:	83 c4 0c             	add    $0xc,%esp
 8a9:	68 ea 0f 00 00       	push   $0xfea
 8ae:	53                   	push   %ebx
 8af:	8d 45 08             	lea    0x8(%ebp),%eax
 8b2:	50                   	push   %eax
 8b3:	e8 9c fb ff ff       	call   454 <peek>
  if(s != es){
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	83 c4 10             	add    $0x10,%esp
 8be:	39 d8                	cmp    %ebx,%eax
 8c0:	75 12                	jne    8d4 <parsecmd+0x50>
  nulterminate(cmd);
 8c2:	83 ec 0c             	sub    $0xc,%esp
 8c5:	56                   	push   %esi
 8c6:	e8 22 ff ff ff       	call   7ed <nulterminate>
}
 8cb:	89 f0                	mov    %esi,%eax
 8cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8d0:	5b                   	pop    %ebx
 8d1:	5e                   	pop    %esi
 8d2:	5d                   	pop    %ebp
 8d3:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 8d4:	83 ec 04             	sub    $0x4,%esp
 8d7:	50                   	push   %eax
 8d8:	68 5e 10 00 00       	push   $0x105e
 8dd:	6a 02                	push   $0x2
 8df:	e8 ef 03 00 00       	call   cd3 <printf>
    panic("syntax");
 8e4:	c7 04 24 22 10 00 00 	movl   $0x1022,(%esp)
 8eb:	e8 4f f7 ff ff       	call   3f <panic>

000008f0 <main>:
{
 8f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8f4:	83 e4 f0             	and    $0xfffffff0,%esp
 8f7:	ff 71 fc             	push   -0x4(%ecx)
 8fa:	55                   	push   %ebp
 8fb:	89 e5                	mov    %esp,%ebp
 8fd:	51                   	push   %ecx
 8fe:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 901:	83 ec 08             	sub    $0x8,%esp
 904:	6a 02                	push   $0x2
 906:	68 6d 10 00 00       	push   $0x106d
 90b:	e8 bb 02 00 00       	call   bcb <open>
 910:	83 c4 10             	add    $0x10,%esp
 913:	85 c0                	test   %eax,%eax
 915:	78 21                	js     938 <main+0x48>
    if(fd >= 3){
 917:	83 f8 02             	cmp    $0x2,%eax
 91a:	7e e5                	jle    901 <main+0x11>
      close(fd);
 91c:	83 ec 0c             	sub    $0xc,%esp
 91f:	50                   	push   %eax
 920:	e8 8e 02 00 00       	call   bb3 <close>
      break;
 925:	83 c4 10             	add    $0x10,%esp
 928:	eb 0e                	jmp    938 <main+0x48>
    if(fork1() == 0)
 92a:	e8 2a f7 ff ff       	call   59 <fork1>
 92f:	85 c0                	test   %eax,%eax
 931:	74 76                	je     9a9 <main+0xb9>
    wait();
 933:	e8 5b 02 00 00       	call   b93 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
 938:	83 ec 08             	sub    $0x8,%esp
 93b:	6a 64                	push   $0x64
 93d:	68 80 16 00 00       	push   $0x1680
 942:	e8 b9 f6 ff ff       	call   0 <getcmd>
 947:	83 c4 10             	add    $0x10,%esp
 94a:	85 c0                	test   %eax,%eax
 94c:	78 70                	js     9be <main+0xce>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 94e:	80 3d 80 16 00 00 63 	cmpb   $0x63,0x1680
 955:	75 d3                	jne    92a <main+0x3a>
 957:	80 3d 81 16 00 00 64 	cmpb   $0x64,0x1681
 95e:	75 ca                	jne    92a <main+0x3a>
 960:	80 3d 82 16 00 00 20 	cmpb   $0x20,0x1682
 967:	75 c1                	jne    92a <main+0x3a>
      buf[strlen(buf)-1] = 0;  // chop \n
 969:	83 ec 0c             	sub    $0xc,%esp
 96c:	68 80 16 00 00       	push   $0x1680
 971:	e8 9c 00 00 00       	call   a12 <strlen>
 976:	c6 80 7f 16 00 00 00 	movb   $0x0,0x167f(%eax)
      if(chdir(buf+3) < 0)
 97d:	c7 04 24 83 16 00 00 	movl   $0x1683,(%esp)
 984:	e8 72 02 00 00       	call   bfb <chdir>
 989:	83 c4 10             	add    $0x10,%esp
 98c:	85 c0                	test   %eax,%eax
 98e:	79 a8                	jns    938 <main+0x48>
        printf(2, "cannot cd %s\n", buf+3);
 990:	83 ec 04             	sub    $0x4,%esp
 993:	68 83 16 00 00       	push   $0x1683
 998:	68 75 10 00 00       	push   $0x1075
 99d:	6a 02                	push   $0x2
 99f:	e8 2f 03 00 00       	call   cd3 <printf>
 9a4:	83 c4 10             	add    $0x10,%esp
 9a7:	eb 8f                	jmp    938 <main+0x48>
      runcmd(parsecmd(buf));
 9a9:	83 ec 0c             	sub    $0xc,%esp
 9ac:	68 80 16 00 00       	push   $0x1680
 9b1:	e8 ce fe ff ff       	call   884 <parsecmd>
 9b6:	89 04 24             	mov    %eax,(%esp)
 9b9:	e8 ba f6 ff ff       	call   78 <runcmd>
  exit();
 9be:	e8 c8 01 00 00       	call   b8b <exit>

000009c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 9c3:	55                   	push   %ebp
 9c4:	89 e5                	mov    %esp,%ebp
 9c6:	53                   	push   %ebx
 9c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 9cd:	b8 00 00 00 00       	mov    $0x0,%eax
 9d2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 9d6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 9d9:	83 c0 01             	add    $0x1,%eax
 9dc:	84 d2                	test   %dl,%dl
 9de:	75 f2                	jne    9d2 <strcpy+0xf>
    ;
  return os;
}
 9e0:	89 c8                	mov    %ecx,%eax
 9e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9e5:	c9                   	leave  
 9e6:	c3                   	ret    

000009e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 9e7:	55                   	push   %ebp
 9e8:	89 e5                	mov    %esp,%ebp
 9ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 9f0:	0f b6 01             	movzbl (%ecx),%eax
 9f3:	84 c0                	test   %al,%al
 9f5:	74 11                	je     a08 <strcmp+0x21>
 9f7:	38 02                	cmp    %al,(%edx)
 9f9:	75 0d                	jne    a08 <strcmp+0x21>
    p++, q++;
 9fb:	83 c1 01             	add    $0x1,%ecx
 9fe:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 a01:	0f b6 01             	movzbl (%ecx),%eax
 a04:	84 c0                	test   %al,%al
 a06:	75 ef                	jne    9f7 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 a08:	0f b6 c0             	movzbl %al,%eax
 a0b:	0f b6 12             	movzbl (%edx),%edx
 a0e:	29 d0                	sub    %edx,%eax
}
 a10:	5d                   	pop    %ebp
 a11:	c3                   	ret    

00000a12 <strlen>:

uint
strlen(const char *s)
{
 a12:	55                   	push   %ebp
 a13:	89 e5                	mov    %esp,%ebp
 a15:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 a18:	80 3a 00             	cmpb   $0x0,(%edx)
 a1b:	74 14                	je     a31 <strlen+0x1f>
 a1d:	b8 00 00 00 00       	mov    $0x0,%eax
 a22:	83 c0 01             	add    $0x1,%eax
 a25:	89 c1                	mov    %eax,%ecx
 a27:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 a2b:	75 f5                	jne    a22 <strlen+0x10>
    ;
  return n;
}
 a2d:	89 c8                	mov    %ecx,%eax
 a2f:	5d                   	pop    %ebp
 a30:	c3                   	ret    
  for(n = 0; s[n]; n++)
 a31:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 a36:	eb f5                	jmp    a2d <strlen+0x1b>

00000a38 <memset>:

void*
memset(void *dst, int c, uint n)
{
 a38:	55                   	push   %ebp
 a39:	89 e5                	mov    %esp,%ebp
 a3b:	57                   	push   %edi
 a3c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 a3f:	89 d7                	mov    %edx,%edi
 a41:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a44:	8b 45 0c             	mov    0xc(%ebp),%eax
 a47:	fc                   	cld    
 a48:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 a4a:	89 d0                	mov    %edx,%eax
 a4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
 a4f:	c9                   	leave  
 a50:	c3                   	ret    

00000a51 <strchr>:

char*
strchr(const char *s, char c)
{
 a51:	55                   	push   %ebp
 a52:	89 e5                	mov    %esp,%ebp
 a54:	8b 45 08             	mov    0x8(%ebp),%eax
 a57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 a5b:	0f b6 10             	movzbl (%eax),%edx
 a5e:	84 d2                	test   %dl,%dl
 a60:	74 15                	je     a77 <strchr+0x26>
    if(*s == c)
 a62:	38 d1                	cmp    %dl,%cl
 a64:	74 0f                	je     a75 <strchr+0x24>
  for(; *s; s++)
 a66:	83 c0 01             	add    $0x1,%eax
 a69:	0f b6 10             	movzbl (%eax),%edx
 a6c:	84 d2                	test   %dl,%dl
 a6e:	75 f2                	jne    a62 <strchr+0x11>
      return (char*)s;
  return 0;
 a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a75:	5d                   	pop    %ebp
 a76:	c3                   	ret    
  return 0;
 a77:	b8 00 00 00 00       	mov    $0x0,%eax
 a7c:	eb f7                	jmp    a75 <strchr+0x24>

00000a7e <gets>:

char*
gets(char *buf, int max)
{
 a7e:	55                   	push   %ebp
 a7f:	89 e5                	mov    %esp,%ebp
 a81:	57                   	push   %edi
 a82:	56                   	push   %esi
 a83:	53                   	push   %ebx
 a84:	83 ec 2c             	sub    $0x2c,%esp
 a87:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a8a:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
 a8f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 a92:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a95:	83 c3 01             	add    $0x1,%ebx
 a98:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a9b:	7d 27                	jge    ac4 <gets+0x46>
    cc = read(0, &c, 1);
 a9d:	83 ec 04             	sub    $0x4,%esp
 aa0:	6a 01                	push   $0x1
 aa2:	57                   	push   %edi
 aa3:	6a 00                	push   $0x0
 aa5:	e8 f9 00 00 00       	call   ba3 <read>
    if(cc < 1)
 aaa:	83 c4 10             	add    $0x10,%esp
 aad:	85 c0                	test   %eax,%eax
 aaf:	7e 13                	jle    ac4 <gets+0x46>
      break;
    buf[i++] = c;
 ab1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 ab5:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
 ab9:	3c 0a                	cmp    $0xa,%al
 abb:	74 04                	je     ac1 <gets+0x43>
 abd:	3c 0d                	cmp    $0xd,%al
 abf:	75 d1                	jne    a92 <gets+0x14>
  for(i=0; i+1 < max; ){
 ac1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
 ac4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 ac7:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
 acb:	89 f0                	mov    %esi,%eax
 acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 ad0:	5b                   	pop    %ebx
 ad1:	5e                   	pop    %esi
 ad2:	5f                   	pop    %edi
 ad3:	5d                   	pop    %ebp
 ad4:	c3                   	ret    

00000ad5 <stat>:

int
stat(const char *n, struct stat *st)
{
 ad5:	55                   	push   %ebp
 ad6:	89 e5                	mov    %esp,%ebp
 ad8:	56                   	push   %esi
 ad9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 ada:	83 ec 08             	sub    $0x8,%esp
 add:	6a 00                	push   $0x0
 adf:	ff 75 08             	push   0x8(%ebp)
 ae2:	e8 e4 00 00 00       	call   bcb <open>
  if(fd < 0)
 ae7:	83 c4 10             	add    $0x10,%esp
 aea:	85 c0                	test   %eax,%eax
 aec:	78 24                	js     b12 <stat+0x3d>
 aee:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 af0:	83 ec 08             	sub    $0x8,%esp
 af3:	ff 75 0c             	push   0xc(%ebp)
 af6:	50                   	push   %eax
 af7:	e8 e7 00 00 00       	call   be3 <fstat>
 afc:	89 c6                	mov    %eax,%esi
  close(fd);
 afe:	89 1c 24             	mov    %ebx,(%esp)
 b01:	e8 ad 00 00 00       	call   bb3 <close>
  return r;
 b06:	83 c4 10             	add    $0x10,%esp
}
 b09:	89 f0                	mov    %esi,%eax
 b0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b0e:	5b                   	pop    %ebx
 b0f:	5e                   	pop    %esi
 b10:	5d                   	pop    %ebp
 b11:	c3                   	ret    
    return -1;
 b12:	be ff ff ff ff       	mov    $0xffffffff,%esi
 b17:	eb f0                	jmp    b09 <stat+0x34>

00000b19 <atoi>:

int
atoi(const char *s)
{
 b19:	55                   	push   %ebp
 b1a:	89 e5                	mov    %esp,%ebp
 b1c:	53                   	push   %ebx
 b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 b20:	0f b6 02             	movzbl (%edx),%eax
 b23:	8d 48 d0             	lea    -0x30(%eax),%ecx
 b26:	80 f9 09             	cmp    $0x9,%cl
 b29:	77 24                	ja     b4f <atoi+0x36>
  n = 0;
 b2b:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
 b30:	83 c2 01             	add    $0x1,%edx
 b33:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 b36:	0f be c0             	movsbl %al,%eax
 b39:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 b3d:	0f b6 02             	movzbl (%edx),%eax
 b40:	8d 58 d0             	lea    -0x30(%eax),%ebx
 b43:	80 fb 09             	cmp    $0x9,%bl
 b46:	76 e8                	jbe    b30 <atoi+0x17>
  return n;
}
 b48:	89 c8                	mov    %ecx,%eax
 b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b4d:	c9                   	leave  
 b4e:	c3                   	ret    
  n = 0;
 b4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
 b54:	eb f2                	jmp    b48 <atoi+0x2f>

00000b56 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 b56:	55                   	push   %ebp
 b57:	89 e5                	mov    %esp,%ebp
 b59:	56                   	push   %esi
 b5a:	53                   	push   %ebx
 b5b:	8b 75 08             	mov    0x8(%ebp),%esi
 b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
 b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 b64:	85 db                	test   %ebx,%ebx
 b66:	7e 15                	jle    b7d <memmove+0x27>
 b68:	01 f3                	add    %esi,%ebx
  dst = vdst;
 b6a:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
 b6c:	83 c2 01             	add    $0x1,%edx
 b6f:	83 c0 01             	add    $0x1,%eax
 b72:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 b76:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
 b79:	39 c3                	cmp    %eax,%ebx
 b7b:	75 ef                	jne    b6c <memmove+0x16>
  return vdst;
}
 b7d:	89 f0                	mov    %esi,%eax
 b7f:	5b                   	pop    %ebx
 b80:	5e                   	pop    %esi
 b81:	5d                   	pop    %ebp
 b82:	c3                   	ret    

00000b83 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 b83:	b8 01 00 00 00       	mov    $0x1,%eax
 b88:	cd 40                	int    $0x40
 b8a:	c3                   	ret    

00000b8b <exit>:
SYSCALL(exit)
 b8b:	b8 02 00 00 00       	mov    $0x2,%eax
 b90:	cd 40                	int    $0x40
 b92:	c3                   	ret    

00000b93 <wait>:
SYSCALL(wait)
 b93:	b8 03 00 00 00       	mov    $0x3,%eax
 b98:	cd 40                	int    $0x40
 b9a:	c3                   	ret    

00000b9b <pipe>:
SYSCALL(pipe)
 b9b:	b8 04 00 00 00       	mov    $0x4,%eax
 ba0:	cd 40                	int    $0x40
 ba2:	c3                   	ret    

00000ba3 <read>:
SYSCALL(read)
 ba3:	b8 05 00 00 00       	mov    $0x5,%eax
 ba8:	cd 40                	int    $0x40
 baa:	c3                   	ret    

00000bab <write>:
SYSCALL(write)
 bab:	b8 10 00 00 00       	mov    $0x10,%eax
 bb0:	cd 40                	int    $0x40
 bb2:	c3                   	ret    

00000bb3 <close>:
SYSCALL(close)
 bb3:	b8 15 00 00 00       	mov    $0x15,%eax
 bb8:	cd 40                	int    $0x40
 bba:	c3                   	ret    

00000bbb <kill>:
SYSCALL(kill)
 bbb:	b8 06 00 00 00       	mov    $0x6,%eax
 bc0:	cd 40                	int    $0x40
 bc2:	c3                   	ret    

00000bc3 <exec>:
SYSCALL(exec)
 bc3:	b8 07 00 00 00       	mov    $0x7,%eax
 bc8:	cd 40                	int    $0x40
 bca:	c3                   	ret    

00000bcb <open>:
SYSCALL(open)
 bcb:	b8 0f 00 00 00       	mov    $0xf,%eax
 bd0:	cd 40                	int    $0x40
 bd2:	c3                   	ret    

00000bd3 <mknod>:
SYSCALL(mknod)
 bd3:	b8 11 00 00 00       	mov    $0x11,%eax
 bd8:	cd 40                	int    $0x40
 bda:	c3                   	ret    

00000bdb <unlink>:
SYSCALL(unlink)
 bdb:	b8 12 00 00 00       	mov    $0x12,%eax
 be0:	cd 40                	int    $0x40
 be2:	c3                   	ret    

00000be3 <fstat>:
SYSCALL(fstat)
 be3:	b8 08 00 00 00       	mov    $0x8,%eax
 be8:	cd 40                	int    $0x40
 bea:	c3                   	ret    

00000beb <link>:
SYSCALL(link)
 beb:	b8 13 00 00 00       	mov    $0x13,%eax
 bf0:	cd 40                	int    $0x40
 bf2:	c3                   	ret    

00000bf3 <mkdir>:
SYSCALL(mkdir)
 bf3:	b8 14 00 00 00       	mov    $0x14,%eax
 bf8:	cd 40                	int    $0x40
 bfa:	c3                   	ret    

00000bfb <chdir>:
SYSCALL(chdir)
 bfb:	b8 09 00 00 00       	mov    $0x9,%eax
 c00:	cd 40                	int    $0x40
 c02:	c3                   	ret    

00000c03 <dup>:
SYSCALL(dup)
 c03:	b8 0a 00 00 00       	mov    $0xa,%eax
 c08:	cd 40                	int    $0x40
 c0a:	c3                   	ret    

00000c0b <getpid>:
SYSCALL(getpid)
 c0b:	b8 0b 00 00 00       	mov    $0xb,%eax
 c10:	cd 40                	int    $0x40
 c12:	c3                   	ret    

00000c13 <sbrk>:
SYSCALL(sbrk)
 c13:	b8 0c 00 00 00       	mov    $0xc,%eax
 c18:	cd 40                	int    $0x40
 c1a:	c3                   	ret    

00000c1b <sleep>:
SYSCALL(sleep)
 c1b:	b8 0d 00 00 00       	mov    $0xd,%eax
 c20:	cd 40                	int    $0x40
 c22:	c3                   	ret    

00000c23 <uptime>:
SYSCALL(uptime)
 c23:	b8 0e 00 00 00       	mov    $0xe,%eax
 c28:	cd 40                	int    $0x40
 c2a:	c3                   	ret    

00000c2b <slabtest>:
SYSCALL(slabtest)
 c2b:	b8 16 00 00 00       	mov    $0x16,%eax
 c30:	cd 40                	int    $0x40
 c32:	c3                   	ret    

00000c33 <ps>:
SYSCALL(ps)
 c33:	b8 17 00 00 00       	mov    $0x17,%eax
 c38:	cd 40                	int    $0x40
 c3a:	c3                   	ret    

00000c3b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 c3b:	55                   	push   %ebp
 c3c:	89 e5                	mov    %esp,%ebp
 c3e:	57                   	push   %edi
 c3f:	56                   	push   %esi
 c40:	53                   	push   %ebx
 c41:	83 ec 3c             	sub    $0x3c,%esp
 c44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 c47:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 c49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c4d:	74 79                	je     cc8 <printint+0x8d>
 c4f:	85 d2                	test   %edx,%edx
 c51:	79 75                	jns    cc8 <printint+0x8d>
    neg = 1;
    x = -xx;
 c53:	89 d1                	mov    %edx,%ecx
 c55:	f7 d9                	neg    %ecx
    neg = 1;
 c57:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 c5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 c63:	89 df                	mov    %ebx,%edi
 c65:	83 c3 01             	add    $0x1,%ebx
 c68:	89 c8                	mov    %ecx,%eax
 c6a:	ba 00 00 00 00       	mov    $0x0,%edx
 c6f:	f7 f6                	div    %esi
 c71:	0f b6 92 14 11 00 00 	movzbl 0x1114(%edx),%edx
 c78:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 c7c:	89 ca                	mov    %ecx,%edx
 c7e:	89 c1                	mov    %eax,%ecx
 c80:	39 d6                	cmp    %edx,%esi
 c82:	76 df                	jbe    c63 <printint+0x28>
  if(neg)
 c84:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
 c88:	74 08                	je     c92 <printint+0x57>
    buf[i++] = '-';
 c8a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 c8f:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 c92:	85 db                	test   %ebx,%ebx
 c94:	7e 2a                	jle    cc0 <printint+0x85>
 c96:	8d 7d d8             	lea    -0x28(%ebp),%edi
 c99:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
 c9d:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
 ca0:	0f b6 03             	movzbl (%ebx),%eax
 ca3:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 ca6:	83 ec 04             	sub    $0x4,%esp
 ca9:	6a 01                	push   $0x1
 cab:	56                   	push   %esi
 cac:	ff 75 c4             	push   -0x3c(%ebp)
 caf:	e8 f7 fe ff ff       	call   bab <write>
  while(--i >= 0)
 cb4:	89 d8                	mov    %ebx,%eax
 cb6:	83 eb 01             	sub    $0x1,%ebx
 cb9:	83 c4 10             	add    $0x10,%esp
 cbc:	39 f8                	cmp    %edi,%eax
 cbe:	75 e0                	jne    ca0 <printint+0x65>
}
 cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 cc3:	5b                   	pop    %ebx
 cc4:	5e                   	pop    %esi
 cc5:	5f                   	pop    %edi
 cc6:	5d                   	pop    %ebp
 cc7:	c3                   	ret    
    x = xx;
 cc8:	89 d1                	mov    %edx,%ecx
  neg = 0;
 cca:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 cd1:	eb 8b                	jmp    c5e <printint+0x23>

00000cd3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 cd3:	55                   	push   %ebp
 cd4:	89 e5                	mov    %esp,%ebp
 cd6:	57                   	push   %edi
 cd7:	56                   	push   %esi
 cd8:	53                   	push   %ebx
 cd9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
 cdf:	0f b6 1e             	movzbl (%esi),%ebx
 ce2:	84 db                	test   %bl,%bl
 ce4:	0f 84 9f 01 00 00    	je     e89 <printf+0x1b6>
 cea:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 ced:	8d 45 10             	lea    0x10(%ebp),%eax
 cf0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 cf3:	bf 00 00 00 00       	mov    $0x0,%edi
 cf8:	eb 2d                	jmp    d27 <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 cfa:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 cfd:	83 ec 04             	sub    $0x4,%esp
 d00:	6a 01                	push   $0x1
 d02:	8d 45 e7             	lea    -0x19(%ebp),%eax
 d05:	50                   	push   %eax
 d06:	ff 75 08             	push   0x8(%ebp)
 d09:	e8 9d fe ff ff       	call   bab <write>
        putc(fd, c);
 d0e:	83 c4 10             	add    $0x10,%esp
 d11:	eb 05                	jmp    d18 <printf+0x45>
      }
    } else if(state == '%'){
 d13:	83 ff 25             	cmp    $0x25,%edi
 d16:	74 1f                	je     d37 <printf+0x64>
  for(i = 0; fmt[i]; i++){
 d18:	83 c6 01             	add    $0x1,%esi
 d1b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 d1f:	84 db                	test   %bl,%bl
 d21:	0f 84 62 01 00 00    	je     e89 <printf+0x1b6>
    c = fmt[i] & 0xff;
 d27:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 d2a:	85 ff                	test   %edi,%edi
 d2c:	75 e5                	jne    d13 <printf+0x40>
      if(c == '%'){
 d2e:	83 f8 25             	cmp    $0x25,%eax
 d31:	75 c7                	jne    cfa <printf+0x27>
        state = '%';
 d33:	89 c7                	mov    %eax,%edi
 d35:	eb e1                	jmp    d18 <printf+0x45>
      if(c == 'd'){
 d37:	83 f8 25             	cmp    $0x25,%eax
 d3a:	0f 84 f2 00 00 00    	je     e32 <printf+0x15f>
 d40:	8d 50 9d             	lea    -0x63(%eax),%edx
 d43:	83 fa 15             	cmp    $0x15,%edx
 d46:	0f 87 07 01 00 00    	ja     e53 <printf+0x180>
 d4c:	0f 87 01 01 00 00    	ja     e53 <printf+0x180>
 d52:	ff 24 95 bc 10 00 00 	jmp    *0x10bc(,%edx,4)
        printint(fd, *ap, 10, 1);
 d59:	83 ec 0c             	sub    $0xc,%esp
 d5c:	6a 01                	push   $0x1
 d5e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 d63:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 d66:	8b 17                	mov    (%edi),%edx
 d68:	8b 45 08             	mov    0x8(%ebp),%eax
 d6b:	e8 cb fe ff ff       	call   c3b <printint>
        ap++;
 d70:	89 f8                	mov    %edi,%eax
 d72:	83 c0 04             	add    $0x4,%eax
 d75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 d78:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d7b:	bf 00 00 00 00       	mov    $0x0,%edi
 d80:	eb 96                	jmp    d18 <printf+0x45>
        printint(fd, *ap, 16, 0);
 d82:	83 ec 0c             	sub    $0xc,%esp
 d85:	6a 00                	push   $0x0
 d87:	b9 10 00 00 00       	mov    $0x10,%ecx
 d8c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 d8f:	8b 17                	mov    (%edi),%edx
 d91:	8b 45 08             	mov    0x8(%ebp),%eax
 d94:	e8 a2 fe ff ff       	call   c3b <printint>
        ap++;
 d99:	89 f8                	mov    %edi,%eax
 d9b:	83 c0 04             	add    $0x4,%eax
 d9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 da1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 da4:	bf 00 00 00 00       	mov    $0x0,%edi
 da9:	e9 6a ff ff ff       	jmp    d18 <printf+0x45>
        s = (char*)*ap;
 dae:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 db1:	8b 01                	mov    (%ecx),%eax
        ap++;
 db3:	83 c1 04             	add    $0x4,%ecx
 db6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 db9:	85 c0                	test   %eax,%eax
 dbb:	74 13                	je     dd0 <printf+0xfd>
        s = (char*)*ap;
 dbd:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 dbf:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 dc2:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 dc7:	84 c0                	test   %al,%al
 dc9:	75 0f                	jne    dda <printf+0x107>
 dcb:	e9 48 ff ff ff       	jmp    d18 <printf+0x45>
          s = "(null)";
 dd0:	bb b4 10 00 00       	mov    $0x10b4,%ebx
        while(*s != 0){
 dd5:	b8 28 00 00 00       	mov    $0x28,%eax
 dda:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
 ddd:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 de0:	83 ec 04             	sub    $0x4,%esp
 de3:	6a 01                	push   $0x1
 de5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 de8:	50                   	push   %eax
 de9:	57                   	push   %edi
 dea:	e8 bc fd ff ff       	call   bab <write>
          s++;
 def:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 df2:	0f b6 03             	movzbl (%ebx),%eax
 df5:	83 c4 10             	add    $0x10,%esp
 df8:	84 c0                	test   %al,%al
 dfa:	75 e1                	jne    ddd <printf+0x10a>
      state = 0;
 dfc:	bf 00 00 00 00       	mov    $0x0,%edi
 e01:	e9 12 ff ff ff       	jmp    d18 <printf+0x45>
        putc(fd, *ap);
 e06:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 e09:	8b 07                	mov    (%edi),%eax
 e0b:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 e0e:	83 ec 04             	sub    $0x4,%esp
 e11:	6a 01                	push   $0x1
 e13:	8d 45 e7             	lea    -0x19(%ebp),%eax
 e16:	50                   	push   %eax
 e17:	ff 75 08             	push   0x8(%ebp)
 e1a:	e8 8c fd ff ff       	call   bab <write>
        ap++;
 e1f:	83 c7 04             	add    $0x4,%edi
 e22:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 e25:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e28:	bf 00 00 00 00       	mov    $0x0,%edi
 e2d:	e9 e6 fe ff ff       	jmp    d18 <printf+0x45>
        putc(fd, c);
 e32:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 e35:	83 ec 04             	sub    $0x4,%esp
 e38:	6a 01                	push   $0x1
 e3a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 e3d:	50                   	push   %eax
 e3e:	ff 75 08             	push   0x8(%ebp)
 e41:	e8 65 fd ff ff       	call   bab <write>
 e46:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e49:	bf 00 00 00 00       	mov    $0x0,%edi
 e4e:	e9 c5 fe ff ff       	jmp    d18 <printf+0x45>
        putc(fd, '%');
 e53:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 e57:	83 ec 04             	sub    $0x4,%esp
 e5a:	6a 01                	push   $0x1
 e5c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 e5f:	50                   	push   %eax
 e60:	ff 75 08             	push   0x8(%ebp)
 e63:	e8 43 fd ff ff       	call   bab <write>
        putc(fd, c);
 e68:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 e6b:	83 c4 0c             	add    $0xc,%esp
 e6e:	6a 01                	push   $0x1
 e70:	8d 45 e7             	lea    -0x19(%ebp),%eax
 e73:	50                   	push   %eax
 e74:	ff 75 08             	push   0x8(%ebp)
 e77:	e8 2f fd ff ff       	call   bab <write>
        putc(fd, c);
 e7c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e7f:	bf 00 00 00 00       	mov    $0x0,%edi
 e84:	e9 8f fe ff ff       	jmp    d18 <printf+0x45>
    }
  }
}
 e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
 e8c:	5b                   	pop    %ebx
 e8d:	5e                   	pop    %esi
 e8e:	5f                   	pop    %edi
 e8f:	5d                   	pop    %ebp
 e90:	c3                   	ret    

00000e91 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e91:	55                   	push   %ebp
 e92:	89 e5                	mov    %esp,%ebp
 e94:	57                   	push   %edi
 e95:	56                   	push   %esi
 e96:	53                   	push   %ebx
 e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e9a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e9d:	a1 e4 16 00 00       	mov    0x16e4,%eax
 ea2:	eb 0c                	jmp    eb0 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ea4:	8b 10                	mov    (%eax),%edx
 ea6:	39 c2                	cmp    %eax,%edx
 ea8:	77 04                	ja     eae <free+0x1d>
 eaa:	39 ca                	cmp    %ecx,%edx
 eac:	77 10                	ja     ebe <free+0x2d>
{
 eae:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 eb0:	39 c8                	cmp    %ecx,%eax
 eb2:	73 f0                	jae    ea4 <free+0x13>
 eb4:	8b 10                	mov    (%eax),%edx
 eb6:	39 ca                	cmp    %ecx,%edx
 eb8:	77 04                	ja     ebe <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 eba:	39 c2                	cmp    %eax,%edx
 ebc:	77 f0                	ja     eae <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ebe:	8b 73 fc             	mov    -0x4(%ebx),%esi
 ec1:	8b 10                	mov    (%eax),%edx
 ec3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ec6:	39 fa                	cmp    %edi,%edx
 ec8:	74 19                	je     ee3 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 eca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 ecd:	8b 50 04             	mov    0x4(%eax),%edx
 ed0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ed3:	39 f1                	cmp    %esi,%ecx
 ed5:	74 18                	je     eef <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 ed7:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 ed9:	a3 e4 16 00 00       	mov    %eax,0x16e4
}
 ede:	5b                   	pop    %ebx
 edf:	5e                   	pop    %esi
 ee0:	5f                   	pop    %edi
 ee1:	5d                   	pop    %ebp
 ee2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 ee3:	03 72 04             	add    0x4(%edx),%esi
 ee6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ee9:	8b 10                	mov    (%eax),%edx
 eeb:	8b 12                	mov    (%edx),%edx
 eed:	eb db                	jmp    eca <free+0x39>
    p->s.size += bp->s.size;
 eef:	03 53 fc             	add    -0x4(%ebx),%edx
 ef2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ef5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 ef8:	eb dd                	jmp    ed7 <free+0x46>

00000efa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 efa:	55                   	push   %ebp
 efb:	89 e5                	mov    %esp,%ebp
 efd:	57                   	push   %edi
 efe:	56                   	push   %esi
 eff:	53                   	push   %ebx
 f00:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 f03:	8b 45 08             	mov    0x8(%ebp),%eax
 f06:	8d 58 07             	lea    0x7(%eax),%ebx
 f09:	c1 eb 03             	shr    $0x3,%ebx
 f0c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 f0f:	8b 15 e4 16 00 00    	mov    0x16e4,%edx
 f15:	85 d2                	test   %edx,%edx
 f17:	74 1c                	je     f35 <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f19:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 f1b:	8b 48 04             	mov    0x4(%eax),%ecx
 f1e:	39 cb                	cmp    %ecx,%ebx
 f20:	76 38                	jbe    f5a <malloc+0x60>
 f22:	be 00 10 00 00       	mov    $0x1000,%esi
 f27:	39 f3                	cmp    %esi,%ebx
 f29:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 f2c:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 f33:	eb 72                	jmp    fa7 <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
 f35:	c7 05 e4 16 00 00 e8 	movl   $0x16e8,0x16e4
 f3c:	16 00 00 
 f3f:	c7 05 e8 16 00 00 e8 	movl   $0x16e8,0x16e8
 f46:	16 00 00 
    base.s.size = 0;
 f49:	c7 05 ec 16 00 00 00 	movl   $0x0,0x16ec
 f50:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f53:	b8 e8 16 00 00       	mov    $0x16e8,%eax
 f58:	eb c8                	jmp    f22 <malloc+0x28>
      if(p->s.size == nunits)
 f5a:	39 cb                	cmp    %ecx,%ebx
 f5c:	74 1e                	je     f7c <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f5e:	29 d9                	sub    %ebx,%ecx
 f60:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 f63:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 f66:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 f69:	89 15 e4 16 00 00    	mov    %edx,0x16e4
      return (void*)(p + 1);
 f6f:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f72:	89 d0                	mov    %edx,%eax
 f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
 f77:	5b                   	pop    %ebx
 f78:	5e                   	pop    %esi
 f79:	5f                   	pop    %edi
 f7a:	5d                   	pop    %ebp
 f7b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 f7c:	8b 08                	mov    (%eax),%ecx
 f7e:	89 0a                	mov    %ecx,(%edx)
 f80:	eb e7                	jmp    f69 <malloc+0x6f>
  hp->s.size = nu;
 f82:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 f85:	83 ec 0c             	sub    $0xc,%esp
 f88:	83 c0 08             	add    $0x8,%eax
 f8b:	50                   	push   %eax
 f8c:	e8 00 ff ff ff       	call   e91 <free>
  return freep;
 f91:	8b 15 e4 16 00 00    	mov    0x16e4,%edx
      if((p = morecore(nunits)) == 0)
 f97:	83 c4 10             	add    $0x10,%esp
 f9a:	85 d2                	test   %edx,%edx
 f9c:	74 d4                	je     f72 <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f9e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 fa0:	8b 48 04             	mov    0x4(%eax),%ecx
 fa3:	39 d9                	cmp    %ebx,%ecx
 fa5:	73 b3                	jae    f5a <malloc+0x60>
    if(p == freep)
 fa7:	89 c2                	mov    %eax,%edx
 fa9:	39 05 e4 16 00 00    	cmp    %eax,0x16e4
 faf:	75 ed                	jne    f9e <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
 fb1:	83 ec 0c             	sub    $0xc,%esp
 fb4:	57                   	push   %edi
 fb5:	e8 59 fc ff ff       	call   c13 <sbrk>
  if(p == (char*)-1)
 fba:	83 c4 10             	add    $0x10,%esp
 fbd:	83 f8 ff             	cmp    $0xffffffff,%eax
 fc0:	75 c0                	jne    f82 <malloc+0x88>
        return 0;
 fc2:	ba 00 00 00 00       	mov    $0x0,%edx
 fc7:	eb a9                	jmp    f72 <malloc+0x78>
