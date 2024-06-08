
user/_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	56                   	push   %esi
       8:	53                   	push   %ebx
       9:	8b 5d 08             	mov    0x8(%ebp),%ebx
       c:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
       f:	83 ec 08             	sub    $0x8,%esp
      12:	68 54 10 00 00       	push   $0x1054
      17:	6a 02                	push   $0x2
      19:	e8 1c 0d 00 00       	call   d3a <printf>
  memset(buf, 0, nbuf);
      1e:	83 c4 0c             	add    $0xc,%esp
      21:	56                   	push   %esi
      22:	6a 00                	push   $0x0
      24:	53                   	push   %ebx
      25:	e8 65 0a 00 00       	call   a8f <memset>
  gets(buf, nbuf);
      2a:	83 c4 08             	add    $0x8,%esp
      2d:	56                   	push   %esi
      2e:	53                   	push   %ebx
      2f:	e8 a7 0a 00 00       	call   adb <gets>
  if(buf[0] == 0) // EOF
      34:	83 c4 10             	add    $0x10,%esp
      37:	80 3b 00             	cmpb   $0x0,(%ebx)
      3a:	0f 94 c0             	sete   %al
      3d:	0f b6 c0             	movzbl %al,%eax
      40:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
      42:	8d 65 f8             	lea    -0x8(%ebp),%esp
      45:	5b                   	pop    %ebx
      46:	5e                   	pop    %esi
      47:	5d                   	pop    %ebp
      48:	c3                   	ret    

00000049 <panic>:
  exit();
}

void
panic(char *s)
{
      49:	f3 0f 1e fb          	endbr32 
      4d:	55                   	push   %ebp
      4e:	89 e5                	mov    %esp,%ebp
      50:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
      53:	ff 75 08             	pushl  0x8(%ebp)
      56:	68 f1 10 00 00       	push   $0x10f1
      5b:	6a 02                	push   $0x2
      5d:	e8 d8 0c 00 00       	call   d3a <printf>
  exit();
      62:	e8 8f 0b 00 00       	call   bf6 <exit>

00000067 <fork1>:
}

int
fork1(void)
{
      67:	f3 0f 1e fb          	endbr32 
      6b:	55                   	push   %ebp
      6c:	89 e5                	mov    %esp,%ebp
      6e:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
      71:	e8 78 0b 00 00       	call   bee <fork>
  if(pid == -1)
      76:	83 f8 ff             	cmp    $0xffffffff,%eax
      79:	74 02                	je     7d <fork1+0x16>
    panic("fork");
  return pid;
}
      7b:	c9                   	leave  
      7c:	c3                   	ret    
    panic("fork");
      7d:	83 ec 0c             	sub    $0xc,%esp
      80:	68 57 10 00 00       	push   $0x1057
      85:	e8 bf ff ff ff       	call   49 <panic>

0000008a <runcmd>:
{
      8a:	f3 0f 1e fb          	endbr32 
      8e:	55                   	push   %ebp
      8f:	89 e5                	mov    %esp,%ebp
      91:	53                   	push   %ebx
      92:	83 ec 14             	sub    $0x14,%esp
      95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
      98:	85 db                	test   %ebx,%ebx
      9a:	74 0f                	je     ab <runcmd+0x21>
  switch(cmd->type){
      9c:	83 3b 05             	cmpl   $0x5,(%ebx)
      9f:	77 0f                	ja     b0 <runcmd+0x26>
      a1:	8b 03                	mov    (%ebx),%eax
      a3:	3e ff 24 85 0c 11 00 	notrack jmp *0x110c(,%eax,4)
      aa:	00 
    exit();
      ab:	e8 46 0b 00 00       	call   bf6 <exit>
    panic("runcmd");
      b0:	83 ec 0c             	sub    $0xc,%esp
      b3:	68 5c 10 00 00       	push   $0x105c
      b8:	e8 8c ff ff ff       	call   49 <panic>
    if(ecmd->argv[0] == 0)
      bd:	8b 43 04             	mov    0x4(%ebx),%eax
      c0:	85 c0                	test   %eax,%eax
      c2:	74 27                	je     eb <runcmd+0x61>
    exec(ecmd->argv[0], ecmd->argv);
      c4:	83 ec 08             	sub    $0x8,%esp
      c7:	8d 53 04             	lea    0x4(%ebx),%edx
      ca:	52                   	push   %edx
      cb:	50                   	push   %eax
      cc:	e8 5d 0b 00 00       	call   c2e <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      d1:	83 c4 0c             	add    $0xc,%esp
      d4:	ff 73 04             	pushl  0x4(%ebx)
      d7:	68 63 10 00 00       	push   $0x1063
      dc:	6a 02                	push   $0x2
      de:	e8 57 0c 00 00       	call   d3a <printf>
    break;
      e3:	83 c4 10             	add    $0x10,%esp
  exit();
      e6:	e8 0b 0b 00 00       	call   bf6 <exit>
      exit();
      eb:	e8 06 0b 00 00       	call   bf6 <exit>
    close(rcmd->fd);
      f0:	83 ec 0c             	sub    $0xc,%esp
      f3:	ff 73 14             	pushl  0x14(%ebx)
      f6:	e8 23 0b 00 00       	call   c1e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fb:	83 c4 08             	add    $0x8,%esp
      fe:	ff 73 10             	pushl  0x10(%ebx)
     101:	ff 73 08             	pushl  0x8(%ebx)
     104:	e8 2d 0b 00 00       	call   c36 <open>
     109:	83 c4 10             	add    $0x10,%esp
     10c:	85 c0                	test   %eax,%eax
     10e:	78 0b                	js     11b <runcmd+0x91>
    runcmd(rcmd->cmd);
     110:	83 ec 0c             	sub    $0xc,%esp
     113:	ff 73 04             	pushl  0x4(%ebx)
     116:	e8 6f ff ff ff       	call   8a <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
     11b:	83 ec 04             	sub    $0x4,%esp
     11e:	ff 73 08             	pushl  0x8(%ebx)
     121:	68 73 10 00 00       	push   $0x1073
     126:	6a 02                	push   $0x2
     128:	e8 0d 0c 00 00       	call   d3a <printf>
      exit();
     12d:	e8 c4 0a 00 00       	call   bf6 <exit>
    if(fork1() == 0)
     132:	e8 30 ff ff ff       	call   67 <fork1>
     137:	85 c0                	test   %eax,%eax
     139:	74 10                	je     14b <runcmd+0xc1>
    wait();
     13b:	e8 be 0a 00 00       	call   bfe <wait>
    runcmd(lcmd->right);
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	ff 73 08             	pushl  0x8(%ebx)
     146:	e8 3f ff ff ff       	call   8a <runcmd>
      runcmd(lcmd->left);
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	ff 73 04             	pushl  0x4(%ebx)
     151:	e8 34 ff ff ff       	call   8a <runcmd>
    if(pipe(p) < 0)
     156:	83 ec 0c             	sub    $0xc,%esp
     159:	8d 45 f0             	lea    -0x10(%ebp),%eax
     15c:	50                   	push   %eax
     15d:	e8 a4 0a 00 00       	call   c06 <pipe>
     162:	83 c4 10             	add    $0x10,%esp
     165:	85 c0                	test   %eax,%eax
     167:	78 3a                	js     1a3 <runcmd+0x119>
    if(fork1() == 0){
     169:	e8 f9 fe ff ff       	call   67 <fork1>
     16e:	85 c0                	test   %eax,%eax
     170:	74 3e                	je     1b0 <runcmd+0x126>
    if(fork1() == 0){
     172:	e8 f0 fe ff ff       	call   67 <fork1>
     177:	85 c0                	test   %eax,%eax
     179:	74 6b                	je     1e6 <runcmd+0x15c>
    close(p[0]);
     17b:	83 ec 0c             	sub    $0xc,%esp
     17e:	ff 75 f0             	pushl  -0x10(%ebp)
     181:	e8 98 0a 00 00       	call   c1e <close>
    close(p[1]);
     186:	83 c4 04             	add    $0x4,%esp
     189:	ff 75 f4             	pushl  -0xc(%ebp)
     18c:	e8 8d 0a 00 00       	call   c1e <close>
    wait();
     191:	e8 68 0a 00 00       	call   bfe <wait>
    wait();
     196:	e8 63 0a 00 00       	call   bfe <wait>
    break;
     19b:	83 c4 10             	add    $0x10,%esp
     19e:	e9 43 ff ff ff       	jmp    e6 <runcmd+0x5c>
      panic("pipe");
     1a3:	83 ec 0c             	sub    $0xc,%esp
     1a6:	68 83 10 00 00       	push   $0x1083
     1ab:	e8 99 fe ff ff       	call   49 <panic>
      close(1);
     1b0:	83 ec 0c             	sub    $0xc,%esp
     1b3:	6a 01                	push   $0x1
     1b5:	e8 64 0a 00 00       	call   c1e <close>
      dup(p[1]);
     1ba:	83 c4 04             	add    $0x4,%esp
     1bd:	ff 75 f4             	pushl  -0xc(%ebp)
     1c0:	e8 a9 0a 00 00       	call   c6e <dup>
      close(p[0]);
     1c5:	83 c4 04             	add    $0x4,%esp
     1c8:	ff 75 f0             	pushl  -0x10(%ebp)
     1cb:	e8 4e 0a 00 00       	call   c1e <close>
      close(p[1]);
     1d0:	83 c4 04             	add    $0x4,%esp
     1d3:	ff 75 f4             	pushl  -0xc(%ebp)
     1d6:	e8 43 0a 00 00       	call   c1e <close>
      runcmd(pcmd->left);
     1db:	83 c4 04             	add    $0x4,%esp
     1de:	ff 73 04             	pushl  0x4(%ebx)
     1e1:	e8 a4 fe ff ff       	call   8a <runcmd>
      close(0);
     1e6:	83 ec 0c             	sub    $0xc,%esp
     1e9:	6a 00                	push   $0x0
     1eb:	e8 2e 0a 00 00       	call   c1e <close>
      dup(p[0]);
     1f0:	83 c4 04             	add    $0x4,%esp
     1f3:	ff 75 f0             	pushl  -0x10(%ebp)
     1f6:	e8 73 0a 00 00       	call   c6e <dup>
      close(p[0]);
     1fb:	83 c4 04             	add    $0x4,%esp
     1fe:	ff 75 f0             	pushl  -0x10(%ebp)
     201:	e8 18 0a 00 00       	call   c1e <close>
      close(p[1]);
     206:	83 c4 04             	add    $0x4,%esp
     209:	ff 75 f4             	pushl  -0xc(%ebp)
     20c:	e8 0d 0a 00 00       	call   c1e <close>
      runcmd(pcmd->right);
     211:	83 c4 04             	add    $0x4,%esp
     214:	ff 73 08             	pushl  0x8(%ebx)
     217:	e8 6e fe ff ff       	call   8a <runcmd>
    if(fork1() == 0)
     21c:	e8 46 fe ff ff       	call   67 <fork1>
     221:	85 c0                	test   %eax,%eax
     223:	0f 85 bd fe ff ff    	jne    e6 <runcmd+0x5c>
      runcmd(bcmd->cmd);
     229:	83 ec 0c             	sub    $0xc,%esp
     22c:	ff 73 04             	pushl  0x4(%ebx)
     22f:	e8 56 fe ff ff       	call   8a <runcmd>

00000234 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     234:	f3 0f 1e fb          	endbr32 
     238:	55                   	push   %ebp
     239:	89 e5                	mov    %esp,%ebp
     23b:	53                   	push   %ebx
     23c:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     23f:	6a 54                	push   $0x54
     241:	e8 34 0d 00 00       	call   f7a <malloc>
     246:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     248:	83 c4 0c             	add    $0xc,%esp
     24b:	6a 54                	push   $0x54
     24d:	6a 00                	push   $0x0
     24f:	50                   	push   %eax
     250:	e8 3a 08 00 00       	call   a8f <memset>
  cmd->type = EXEC;
     255:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     25b:	89 d8                	mov    %ebx,%eax
     25d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     260:	c9                   	leave  
     261:	c3                   	ret    

00000262 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     262:	f3 0f 1e fb          	endbr32 
     266:	55                   	push   %ebp
     267:	89 e5                	mov    %esp,%ebp
     269:	53                   	push   %ebx
     26a:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     26d:	6a 18                	push   $0x18
     26f:	e8 06 0d 00 00       	call   f7a <malloc>
     274:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     276:	83 c4 0c             	add    $0xc,%esp
     279:	6a 18                	push   $0x18
     27b:	6a 00                	push   $0x0
     27d:	50                   	push   %eax
     27e:	e8 0c 08 00 00       	call   a8f <memset>
  cmd->type = REDIR;
     283:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     289:	8b 45 08             	mov    0x8(%ebp),%eax
     28c:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     28f:	8b 45 0c             	mov    0xc(%ebp),%eax
     292:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     295:	8b 45 10             	mov    0x10(%ebp),%eax
     298:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     29b:	8b 45 14             	mov    0x14(%ebp),%eax
     29e:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     2a1:	8b 45 18             	mov    0x18(%ebp),%eax
     2a4:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     2a7:	89 d8                	mov    %ebx,%eax
     2a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2ac:	c9                   	leave  
     2ad:	c3                   	ret    

000002ae <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     2ae:	f3 0f 1e fb          	endbr32 
     2b2:	55                   	push   %ebp
     2b3:	89 e5                	mov    %esp,%ebp
     2b5:	53                   	push   %ebx
     2b6:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b9:	6a 0c                	push   $0xc
     2bb:	e8 ba 0c 00 00       	call   f7a <malloc>
     2c0:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2c2:	83 c4 0c             	add    $0xc,%esp
     2c5:	6a 0c                	push   $0xc
     2c7:	6a 00                	push   $0x0
     2c9:	50                   	push   %eax
     2ca:	e8 c0 07 00 00       	call   a8f <memset>
  cmd->type = PIPE;
     2cf:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     2d5:	8b 45 08             	mov    0x8(%ebp),%eax
     2d8:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2db:	8b 45 0c             	mov    0xc(%ebp),%eax
     2de:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2e1:	89 d8                	mov    %ebx,%eax
     2e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2e6:	c9                   	leave  
     2e7:	c3                   	ret    

000002e8 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2e8:	f3 0f 1e fb          	endbr32 
     2ec:	55                   	push   %ebp
     2ed:	89 e5                	mov    %esp,%ebp
     2ef:	53                   	push   %ebx
     2f0:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f3:	6a 0c                	push   $0xc
     2f5:	e8 80 0c 00 00       	call   f7a <malloc>
     2fa:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2fc:	83 c4 0c             	add    $0xc,%esp
     2ff:	6a 0c                	push   $0xc
     301:	6a 00                	push   $0x0
     303:	50                   	push   %eax
     304:	e8 86 07 00 00       	call   a8f <memset>
  cmd->type = LIST;
     309:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     30f:	8b 45 08             	mov    0x8(%ebp),%eax
     312:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     315:	8b 45 0c             	mov    0xc(%ebp),%eax
     318:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     31b:	89 d8                	mov    %ebx,%eax
     31d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     320:	c9                   	leave  
     321:	c3                   	ret    

00000322 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     322:	f3 0f 1e fb          	endbr32 
     326:	55                   	push   %ebp
     327:	89 e5                	mov    %esp,%ebp
     329:	53                   	push   %ebx
     32a:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32d:	6a 08                	push   $0x8
     32f:	e8 46 0c 00 00       	call   f7a <malloc>
     334:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     336:	83 c4 0c             	add    $0xc,%esp
     339:	6a 08                	push   $0x8
     33b:	6a 00                	push   $0x0
     33d:	50                   	push   %eax
     33e:	e8 4c 07 00 00       	call   a8f <memset>
  cmd->type = BACK;
     343:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     349:	8b 45 08             	mov    0x8(%ebp),%eax
     34c:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     34f:	89 d8                	mov    %ebx,%eax
     351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     354:	c9                   	leave  
     355:	c3                   	ret    

00000356 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     356:	f3 0f 1e fb          	endbr32 
     35a:	55                   	push   %ebp
     35b:	89 e5                	mov    %esp,%ebp
     35d:	57                   	push   %edi
     35e:	56                   	push   %esi
     35f:	53                   	push   %ebx
     360:	83 ec 0c             	sub    $0xc,%esp
     363:	8b 75 0c             	mov    0xc(%ebp),%esi
     366:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     369:	8b 45 08             	mov    0x8(%ebp),%eax
     36c:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     36e:	39 f3                	cmp    %esi,%ebx
     370:	73 1f                	jae    391 <gettoken+0x3b>
     372:	83 ec 08             	sub    $0x8,%esp
     375:	0f be 03             	movsbl (%ebx),%eax
     378:	50                   	push   %eax
     379:	68 8c 16 00 00       	push   $0x168c
     37e:	e8 27 07 00 00       	call   aaa <strchr>
     383:	83 c4 10             	add    $0x10,%esp
     386:	85 c0                	test   %eax,%eax
     388:	74 07                	je     391 <gettoken+0x3b>
    s++;
     38a:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     38d:	39 de                	cmp    %ebx,%esi
     38f:	75 e1                	jne    372 <gettoken+0x1c>
  if(q)
     391:	85 ff                	test   %edi,%edi
     393:	74 02                	je     397 <gettoken+0x41>
    *q = s;
     395:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     397:	0f b6 03             	movzbl (%ebx),%eax
     39a:	0f be f8             	movsbl %al,%edi
  switch(*s){
     39d:	3c 3c                	cmp    $0x3c,%al
     39f:	7f 55                	jg     3f6 <gettoken+0xa0>
     3a1:	3c 3a                	cmp    $0x3a,%al
     3a3:	7f 11                	jg     3b6 <gettoken+0x60>
     3a5:	84 c0                	test   %al,%al
     3a7:	74 10                	je     3b9 <gettoken+0x63>
     3a9:	78 65                	js     410 <gettoken+0xba>
     3ab:	3c 26                	cmp    $0x26,%al
     3ad:	74 07                	je     3b6 <gettoken+0x60>
     3af:	83 e8 28             	sub    $0x28,%eax
     3b2:	3c 01                	cmp    $0x1,%al
     3b4:	77 5a                	ja     410 <gettoken+0xba>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     3b6:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     3b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     3bd:	74 05                	je     3c4 <gettoken+0x6e>
    *eq = s;
     3bf:	8b 45 14             	mov    0x14(%ebp),%eax
     3c2:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
     3c4:	39 f3                	cmp    %esi,%ebx
     3c6:	73 1f                	jae    3e7 <gettoken+0x91>
     3c8:	83 ec 08             	sub    $0x8,%esp
     3cb:	0f be 03             	movsbl (%ebx),%eax
     3ce:	50                   	push   %eax
     3cf:	68 8c 16 00 00       	push   $0x168c
     3d4:	e8 d1 06 00 00       	call   aaa <strchr>
     3d9:	83 c4 10             	add    $0x10,%esp
     3dc:	85 c0                	test   %eax,%eax
     3de:	74 07                	je     3e7 <gettoken+0x91>
    s++;
     3e0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     3e3:	39 de                	cmp    %ebx,%esi
     3e5:	75 e1                	jne    3c8 <gettoken+0x72>
  *ps = s;
     3e7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ea:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     3ec:	89 f8                	mov    %edi,%eax
     3ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3f1:	5b                   	pop    %ebx
     3f2:	5e                   	pop    %esi
     3f3:	5f                   	pop    %edi
     3f4:	5d                   	pop    %ebp
     3f5:	c3                   	ret    
  switch(*s){
     3f6:	3c 3e                	cmp    $0x3e,%al
     3f8:	75 12                	jne    40c <gettoken+0xb6>
    s++;
     3fa:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
     3fd:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     401:	74 59                	je     45c <gettoken+0x106>
    s++;
     403:	89 c3                	mov    %eax,%ebx
  ret = *s;
     405:	bf 3e 00 00 00       	mov    $0x3e,%edi
     40a:	eb ad                	jmp    3b9 <gettoken+0x63>
  switch(*s){
     40c:	3c 7c                	cmp    $0x7c,%al
     40e:	74 a6                	je     3b6 <gettoken+0x60>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     410:	39 de                	cmp    %ebx,%esi
     412:	76 37                	jbe    44b <gettoken+0xf5>
     414:	83 ec 08             	sub    $0x8,%esp
     417:	0f be 03             	movsbl (%ebx),%eax
     41a:	50                   	push   %eax
     41b:	68 8c 16 00 00       	push   $0x168c
     420:	e8 85 06 00 00       	call   aaa <strchr>
     425:	83 c4 10             	add    $0x10,%esp
     428:	85 c0                	test   %eax,%eax
     42a:	75 47                	jne    473 <gettoken+0x11d>
     42c:	83 ec 08             	sub    $0x8,%esp
     42f:	0f be 03             	movsbl (%ebx),%eax
     432:	50                   	push   %eax
     433:	68 84 16 00 00       	push   $0x1684
     438:	e8 6d 06 00 00       	call   aaa <strchr>
     43d:	83 c4 10             	add    $0x10,%esp
     440:	85 c0                	test   %eax,%eax
     442:	75 25                	jne    469 <gettoken+0x113>
      s++;
     444:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     447:	39 de                	cmp    %ebx,%esi
     449:	75 c9                	jne    414 <gettoken+0xbe>
  if(eq)
     44b:	bf 61 00 00 00       	mov    $0x61,%edi
     450:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     454:	0f 85 65 ff ff ff    	jne    3bf <gettoken+0x69>
     45a:	eb 8b                	jmp    3e7 <gettoken+0x91>
      s++;
     45c:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
     45f:	bf 2b 00 00 00       	mov    $0x2b,%edi
     464:	e9 50 ff ff ff       	jmp    3b9 <gettoken+0x63>
    ret = 'a';
     469:	bf 61 00 00 00       	mov    $0x61,%edi
     46e:	e9 46 ff ff ff       	jmp    3b9 <gettoken+0x63>
     473:	bf 61 00 00 00       	mov    $0x61,%edi
     478:	e9 3c ff ff ff       	jmp    3b9 <gettoken+0x63>

0000047d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     47d:	f3 0f 1e fb          	endbr32 
     481:	55                   	push   %ebp
     482:	89 e5                	mov    %esp,%ebp
     484:	57                   	push   %edi
     485:	56                   	push   %esi
     486:	53                   	push   %ebx
     487:	83 ec 0c             	sub    $0xc,%esp
     48a:	8b 7d 08             	mov    0x8(%ebp),%edi
     48d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     490:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     492:	39 f3                	cmp    %esi,%ebx
     494:	73 1f                	jae    4b5 <peek+0x38>
     496:	83 ec 08             	sub    $0x8,%esp
     499:	0f be 03             	movsbl (%ebx),%eax
     49c:	50                   	push   %eax
     49d:	68 8c 16 00 00       	push   $0x168c
     4a2:	e8 03 06 00 00       	call   aaa <strchr>
     4a7:	83 c4 10             	add    $0x10,%esp
     4aa:	85 c0                	test   %eax,%eax
     4ac:	74 07                	je     4b5 <peek+0x38>
    s++;
     4ae:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     4b1:	39 de                	cmp    %ebx,%esi
     4b3:	75 e1                	jne    496 <peek+0x19>
  *ps = s;
     4b5:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     4b7:	0f b6 03             	movzbl (%ebx),%eax
     4ba:	ba 00 00 00 00       	mov    $0x0,%edx
     4bf:	84 c0                	test   %al,%al
     4c1:	75 0a                	jne    4cd <peek+0x50>
}
     4c3:	89 d0                	mov    %edx,%eax
     4c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4c8:	5b                   	pop    %ebx
     4c9:	5e                   	pop    %esi
     4ca:	5f                   	pop    %edi
     4cb:	5d                   	pop    %ebp
     4cc:	c3                   	ret    
  return *s && strchr(toks, *s);
     4cd:	83 ec 08             	sub    $0x8,%esp
     4d0:	0f be c0             	movsbl %al,%eax
     4d3:	50                   	push   %eax
     4d4:	ff 75 10             	pushl  0x10(%ebp)
     4d7:	e8 ce 05 00 00       	call   aaa <strchr>
     4dc:	83 c4 10             	add    $0x10,%esp
     4df:	85 c0                	test   %eax,%eax
     4e1:	0f 95 c2             	setne  %dl
     4e4:	0f b6 d2             	movzbl %dl,%edx
     4e7:	eb da                	jmp    4c3 <peek+0x46>

000004e9 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4e9:	f3 0f 1e fb          	endbr32 
     4ed:	55                   	push   %ebp
     4ee:	89 e5                	mov    %esp,%ebp
     4f0:	57                   	push   %edi
     4f1:	56                   	push   %esi
     4f2:	53                   	push   %ebx
     4f3:	83 ec 1c             	sub    $0x1c,%esp
     4f6:	8b 75 0c             	mov    0xc(%ebp),%esi
     4f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4fc:	eb 28                	jmp    526 <parseredirs+0x3d>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     4fe:	83 ec 0c             	sub    $0xc,%esp
     501:	68 88 10 00 00       	push   $0x1088
     506:	e8 3e fb ff ff       	call   49 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     50b:	83 ec 0c             	sub    $0xc,%esp
     50e:	6a 00                	push   $0x0
     510:	6a 00                	push   $0x0
     512:	ff 75 e0             	pushl  -0x20(%ebp)
     515:	ff 75 e4             	pushl  -0x1c(%ebp)
     518:	ff 75 08             	pushl  0x8(%ebp)
     51b:	e8 42 fd ff ff       	call   262 <redircmd>
     520:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     523:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
     526:	83 ec 04             	sub    $0x4,%esp
     529:	68 a5 10 00 00       	push   $0x10a5
     52e:	57                   	push   %edi
     52f:	56                   	push   %esi
     530:	e8 48 ff ff ff       	call   47d <peek>
     535:	83 c4 10             	add    $0x10,%esp
     538:	85 c0                	test   %eax,%eax
     53a:	74 76                	je     5b2 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
     53c:	6a 00                	push   $0x0
     53e:	6a 00                	push   $0x0
     540:	57                   	push   %edi
     541:	56                   	push   %esi
     542:	e8 0f fe ff ff       	call   356 <gettoken>
     547:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     549:	8d 45 e0             	lea    -0x20(%ebp),%eax
     54c:	50                   	push   %eax
     54d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     550:	50                   	push   %eax
     551:	57                   	push   %edi
     552:	56                   	push   %esi
     553:	e8 fe fd ff ff       	call   356 <gettoken>
     558:	83 c4 20             	add    $0x20,%esp
     55b:	83 f8 61             	cmp    $0x61,%eax
     55e:	75 9e                	jne    4fe <parseredirs+0x15>
    switch(tok){
     560:	83 fb 3c             	cmp    $0x3c,%ebx
     563:	74 a6                	je     50b <parseredirs+0x22>
     565:	83 fb 3e             	cmp    $0x3e,%ebx
     568:	74 25                	je     58f <parseredirs+0xa6>
     56a:	83 fb 2b             	cmp    $0x2b,%ebx
     56d:	75 b7                	jne    526 <parseredirs+0x3d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     56f:	83 ec 0c             	sub    $0xc,%esp
     572:	6a 01                	push   $0x1
     574:	68 01 02 00 00       	push   $0x201
     579:	ff 75 e0             	pushl  -0x20(%ebp)
     57c:	ff 75 e4             	pushl  -0x1c(%ebp)
     57f:	ff 75 08             	pushl  0x8(%ebp)
     582:	e8 db fc ff ff       	call   262 <redircmd>
     587:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     58a:	83 c4 20             	add    $0x20,%esp
     58d:	eb 97                	jmp    526 <parseredirs+0x3d>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     58f:	83 ec 0c             	sub    $0xc,%esp
     592:	6a 01                	push   $0x1
     594:	68 01 02 00 00       	push   $0x201
     599:	ff 75 e0             	pushl  -0x20(%ebp)
     59c:	ff 75 e4             	pushl  -0x1c(%ebp)
     59f:	ff 75 08             	pushl  0x8(%ebp)
     5a2:	e8 bb fc ff ff       	call   262 <redircmd>
     5a7:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     5aa:	83 c4 20             	add    $0x20,%esp
     5ad:	e9 74 ff ff ff       	jmp    526 <parseredirs+0x3d>
    }
  }
  return cmd;
}
     5b2:	8b 45 08             	mov    0x8(%ebp),%eax
     5b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5b8:	5b                   	pop    %ebx
     5b9:	5e                   	pop    %esi
     5ba:	5f                   	pop    %edi
     5bb:	5d                   	pop    %ebp
     5bc:	c3                   	ret    

000005bd <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     5bd:	f3 0f 1e fb          	endbr32 
     5c1:	55                   	push   %ebp
     5c2:	89 e5                	mov    %esp,%ebp
     5c4:	57                   	push   %edi
     5c5:	56                   	push   %esi
     5c6:	53                   	push   %ebx
     5c7:	83 ec 30             	sub    $0x30,%esp
     5ca:	8b 75 08             	mov    0x8(%ebp),%esi
     5cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5d0:	68 a8 10 00 00       	push   $0x10a8
     5d5:	57                   	push   %edi
     5d6:	56                   	push   %esi
     5d7:	e8 a1 fe ff ff       	call   47d <peek>
     5dc:	83 c4 10             	add    $0x10,%esp
     5df:	85 c0                	test   %eax,%eax
     5e1:	75 1d                	jne    600 <parseexec+0x43>
     5e3:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     5e5:	e8 4a fc ff ff       	call   234 <execcmd>
     5ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5ed:	83 ec 04             	sub    $0x4,%esp
     5f0:	57                   	push   %edi
     5f1:	56                   	push   %esi
     5f2:	50                   	push   %eax
     5f3:	e8 f1 fe ff ff       	call   4e9 <parseredirs>
     5f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     5fb:	83 c4 10             	add    $0x10,%esp
     5fe:	eb 3b                	jmp    63b <parseexec+0x7e>
    return parseblock(ps, es);
     600:	83 ec 08             	sub    $0x8,%esp
     603:	57                   	push   %edi
     604:	56                   	push   %esi
     605:	e8 98 01 00 00       	call   7a2 <parseblock>
     60a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     60d:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     613:	8d 65 f4             	lea    -0xc(%ebp),%esp
     616:	5b                   	pop    %ebx
     617:	5e                   	pop    %esi
     618:	5f                   	pop    %edi
     619:	5d                   	pop    %ebp
     61a:	c3                   	ret    
      panic("syntax");
     61b:	83 ec 0c             	sub    $0xc,%esp
     61e:	68 aa 10 00 00       	push   $0x10aa
     623:	e8 21 fa ff ff       	call   49 <panic>
    ret = parseredirs(ret, ps, es);
     628:	83 ec 04             	sub    $0x4,%esp
     62b:	57                   	push   %edi
     62c:	56                   	push   %esi
     62d:	ff 75 d4             	pushl  -0x2c(%ebp)
     630:	e8 b4 fe ff ff       	call   4e9 <parseredirs>
     635:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     638:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
     63b:	83 ec 04             	sub    $0x4,%esp
     63e:	68 bf 10 00 00       	push   $0x10bf
     643:	57                   	push   %edi
     644:	56                   	push   %esi
     645:	e8 33 fe ff ff       	call   47d <peek>
     64a:	83 c4 10             	add    $0x10,%esp
     64d:	85 c0                	test   %eax,%eax
     64f:	75 41                	jne    692 <parseexec+0xd5>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     651:	8d 45 e0             	lea    -0x20(%ebp),%eax
     654:	50                   	push   %eax
     655:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     658:	50                   	push   %eax
     659:	57                   	push   %edi
     65a:	56                   	push   %esi
     65b:	e8 f6 fc ff ff       	call   356 <gettoken>
     660:	83 c4 10             	add    $0x10,%esp
     663:	85 c0                	test   %eax,%eax
     665:	74 2b                	je     692 <parseexec+0xd5>
    if(tok != 'a')
     667:	83 f8 61             	cmp    $0x61,%eax
     66a:	75 af                	jne    61b <parseexec+0x5e>
    cmd->argv[argc] = q;
     66c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     66f:	8b 55 d0             	mov    -0x30(%ebp),%edx
     672:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     676:	8b 45 e0             	mov    -0x20(%ebp),%eax
     679:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     67d:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     680:	83 fb 0a             	cmp    $0xa,%ebx
     683:	75 a3                	jne    628 <parseexec+0x6b>
      panic("too many args");
     685:	83 ec 0c             	sub    $0xc,%esp
     688:	68 b1 10 00 00       	push   $0x10b1
     68d:	e8 b7 f9 ff ff       	call   49 <panic>
  cmd->argv[argc] = 0;
     692:	8b 45 d0             	mov    -0x30(%ebp),%eax
     695:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     698:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     69f:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
     6a6:	e9 65 ff ff ff       	jmp    610 <parseexec+0x53>

000006ab <parsepipe>:
{
     6ab:	f3 0f 1e fb          	endbr32 
     6af:	55                   	push   %ebp
     6b0:	89 e5                	mov    %esp,%ebp
     6b2:	57                   	push   %edi
     6b3:	56                   	push   %esi
     6b4:	53                   	push   %ebx
     6b5:	83 ec 14             	sub    $0x14,%esp
     6b8:	8b 75 08             	mov    0x8(%ebp),%esi
     6bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     6be:	57                   	push   %edi
     6bf:	56                   	push   %esi
     6c0:	e8 f8 fe ff ff       	call   5bd <parseexec>
     6c5:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     6c7:	83 c4 0c             	add    $0xc,%esp
     6ca:	68 c4 10 00 00       	push   $0x10c4
     6cf:	57                   	push   %edi
     6d0:	56                   	push   %esi
     6d1:	e8 a7 fd ff ff       	call   47d <peek>
     6d6:	83 c4 10             	add    $0x10,%esp
     6d9:	85 c0                	test   %eax,%eax
     6db:	75 0a                	jne    6e7 <parsepipe+0x3c>
}
     6dd:	89 d8                	mov    %ebx,%eax
     6df:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6e2:	5b                   	pop    %ebx
     6e3:	5e                   	pop    %esi
     6e4:	5f                   	pop    %edi
     6e5:	5d                   	pop    %ebp
     6e6:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     6e7:	6a 00                	push   $0x0
     6e9:	6a 00                	push   $0x0
     6eb:	57                   	push   %edi
     6ec:	56                   	push   %esi
     6ed:	e8 64 fc ff ff       	call   356 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6f2:	83 c4 08             	add    $0x8,%esp
     6f5:	57                   	push   %edi
     6f6:	56                   	push   %esi
     6f7:	e8 af ff ff ff       	call   6ab <parsepipe>
     6fc:	83 c4 08             	add    $0x8,%esp
     6ff:	50                   	push   %eax
     700:	53                   	push   %ebx
     701:	e8 a8 fb ff ff       	call   2ae <pipecmd>
     706:	89 c3                	mov    %eax,%ebx
     708:	83 c4 10             	add    $0x10,%esp
  return cmd;
     70b:	eb d0                	jmp    6dd <parsepipe+0x32>

0000070d <parseline>:
{
     70d:	f3 0f 1e fb          	endbr32 
     711:	55                   	push   %ebp
     712:	89 e5                	mov    %esp,%ebp
     714:	57                   	push   %edi
     715:	56                   	push   %esi
     716:	53                   	push   %ebx
     717:	83 ec 14             	sub    $0x14,%esp
     71a:	8b 75 08             	mov    0x8(%ebp),%esi
     71d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     720:	57                   	push   %edi
     721:	56                   	push   %esi
     722:	e8 84 ff ff ff       	call   6ab <parsepipe>
     727:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     729:	83 c4 10             	add    $0x10,%esp
     72c:	83 ec 04             	sub    $0x4,%esp
     72f:	68 c6 10 00 00       	push   $0x10c6
     734:	57                   	push   %edi
     735:	56                   	push   %esi
     736:	e8 42 fd ff ff       	call   47d <peek>
     73b:	83 c4 10             	add    $0x10,%esp
     73e:	85 c0                	test   %eax,%eax
     740:	74 1a                	je     75c <parseline+0x4f>
    gettoken(ps, es, 0, 0);
     742:	6a 00                	push   $0x0
     744:	6a 00                	push   $0x0
     746:	57                   	push   %edi
     747:	56                   	push   %esi
     748:	e8 09 fc ff ff       	call   356 <gettoken>
    cmd = backcmd(cmd);
     74d:	89 1c 24             	mov    %ebx,(%esp)
     750:	e8 cd fb ff ff       	call   322 <backcmd>
     755:	89 c3                	mov    %eax,%ebx
     757:	83 c4 10             	add    $0x10,%esp
     75a:	eb d0                	jmp    72c <parseline+0x1f>
  if(peek(ps, es, ";")){
     75c:	83 ec 04             	sub    $0x4,%esp
     75f:	68 c2 10 00 00       	push   $0x10c2
     764:	57                   	push   %edi
     765:	56                   	push   %esi
     766:	e8 12 fd ff ff       	call   47d <peek>
     76b:	83 c4 10             	add    $0x10,%esp
     76e:	85 c0                	test   %eax,%eax
     770:	75 0a                	jne    77c <parseline+0x6f>
}
     772:	89 d8                	mov    %ebx,%eax
     774:	8d 65 f4             	lea    -0xc(%ebp),%esp
     777:	5b                   	pop    %ebx
     778:	5e                   	pop    %esi
     779:	5f                   	pop    %edi
     77a:	5d                   	pop    %ebp
     77b:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     77c:	6a 00                	push   $0x0
     77e:	6a 00                	push   $0x0
     780:	57                   	push   %edi
     781:	56                   	push   %esi
     782:	e8 cf fb ff ff       	call   356 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     787:	83 c4 08             	add    $0x8,%esp
     78a:	57                   	push   %edi
     78b:	56                   	push   %esi
     78c:	e8 7c ff ff ff       	call   70d <parseline>
     791:	83 c4 08             	add    $0x8,%esp
     794:	50                   	push   %eax
     795:	53                   	push   %ebx
     796:	e8 4d fb ff ff       	call   2e8 <listcmd>
     79b:	89 c3                	mov    %eax,%ebx
     79d:	83 c4 10             	add    $0x10,%esp
  return cmd;
     7a0:	eb d0                	jmp    772 <parseline+0x65>

000007a2 <parseblock>:
{
     7a2:	f3 0f 1e fb          	endbr32 
     7a6:	55                   	push   %ebp
     7a7:	89 e5                	mov    %esp,%ebp
     7a9:	57                   	push   %edi
     7aa:	56                   	push   %esi
     7ab:	53                   	push   %ebx
     7ac:	83 ec 10             	sub    $0x10,%esp
     7af:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     7b5:	68 a8 10 00 00       	push   $0x10a8
     7ba:	56                   	push   %esi
     7bb:	53                   	push   %ebx
     7bc:	e8 bc fc ff ff       	call   47d <peek>
     7c1:	83 c4 10             	add    $0x10,%esp
     7c4:	85 c0                	test   %eax,%eax
     7c6:	74 4b                	je     813 <parseblock+0x71>
  gettoken(ps, es, 0, 0);
     7c8:	6a 00                	push   $0x0
     7ca:	6a 00                	push   $0x0
     7cc:	56                   	push   %esi
     7cd:	53                   	push   %ebx
     7ce:	e8 83 fb ff ff       	call   356 <gettoken>
  cmd = parseline(ps, es);
     7d3:	83 c4 08             	add    $0x8,%esp
     7d6:	56                   	push   %esi
     7d7:	53                   	push   %ebx
     7d8:	e8 30 ff ff ff       	call   70d <parseline>
     7dd:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7df:	83 c4 0c             	add    $0xc,%esp
     7e2:	68 e4 10 00 00       	push   $0x10e4
     7e7:	56                   	push   %esi
     7e8:	53                   	push   %ebx
     7e9:	e8 8f fc ff ff       	call   47d <peek>
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	85 c0                	test   %eax,%eax
     7f3:	74 2b                	je     820 <parseblock+0x7e>
  gettoken(ps, es, 0, 0);
     7f5:	6a 00                	push   $0x0
     7f7:	6a 00                	push   $0x0
     7f9:	56                   	push   %esi
     7fa:	53                   	push   %ebx
     7fb:	e8 56 fb ff ff       	call   356 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     800:	83 c4 0c             	add    $0xc,%esp
     803:	56                   	push   %esi
     804:	53                   	push   %ebx
     805:	57                   	push   %edi
     806:	e8 de fc ff ff       	call   4e9 <parseredirs>
}
     80b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     80e:	5b                   	pop    %ebx
     80f:	5e                   	pop    %esi
     810:	5f                   	pop    %edi
     811:	5d                   	pop    %ebp
     812:	c3                   	ret    
    panic("parseblock");
     813:	83 ec 0c             	sub    $0xc,%esp
     816:	68 c8 10 00 00       	push   $0x10c8
     81b:	e8 29 f8 ff ff       	call   49 <panic>
    panic("syntax - missing )");
     820:	83 ec 0c             	sub    $0xc,%esp
     823:	68 d3 10 00 00       	push   $0x10d3
     828:	e8 1c f8 ff ff       	call   49 <panic>

0000082d <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     82d:	f3 0f 1e fb          	endbr32 
     831:	55                   	push   %ebp
     832:	89 e5                	mov    %esp,%ebp
     834:	53                   	push   %ebx
     835:	83 ec 04             	sub    $0x4,%esp
     838:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     83b:	85 db                	test   %ebx,%ebx
     83d:	74 3d                	je     87c <nulterminate+0x4f>
    return 0;

  switch(cmd->type){
     83f:	83 3b 05             	cmpl   $0x5,(%ebx)
     842:	77 38                	ja     87c <nulterminate+0x4f>
     844:	8b 03                	mov    (%ebx),%eax
     846:	3e ff 24 85 24 11 00 	notrack jmp *0x1124(,%eax,4)
     84d:	00 
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     84e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
     852:	74 28                	je     87c <nulterminate+0x4f>
     854:	8d 43 08             	lea    0x8(%ebx),%eax
      *ecmd->eargv[i] = 0;
     857:	8b 50 24             	mov    0x24(%eax),%edx
     85a:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     85d:	83 c0 04             	add    $0x4,%eax
     860:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
     864:	75 f1                	jne    857 <nulterminate+0x2a>
     866:	eb 14                	jmp    87c <nulterminate+0x4f>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     868:	83 ec 0c             	sub    $0xc,%esp
     86b:	ff 73 04             	pushl  0x4(%ebx)
     86e:	e8 ba ff ff ff       	call   82d <nulterminate>
    *rcmd->efile = 0;
     873:	8b 43 0c             	mov    0xc(%ebx),%eax
     876:	c6 00 00             	movb   $0x0,(%eax)
    break;
     879:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     87c:	89 d8                	mov    %ebx,%eax
     87e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     881:	c9                   	leave  
     882:	c3                   	ret    
    nulterminate(pcmd->left);
     883:	83 ec 0c             	sub    $0xc,%esp
     886:	ff 73 04             	pushl  0x4(%ebx)
     889:	e8 9f ff ff ff       	call   82d <nulterminate>
    nulterminate(pcmd->right);
     88e:	83 c4 04             	add    $0x4,%esp
     891:	ff 73 08             	pushl  0x8(%ebx)
     894:	e8 94 ff ff ff       	call   82d <nulterminate>
    break;
     899:	83 c4 10             	add    $0x10,%esp
     89c:	eb de                	jmp    87c <nulterminate+0x4f>
    nulterminate(lcmd->left);
     89e:	83 ec 0c             	sub    $0xc,%esp
     8a1:	ff 73 04             	pushl  0x4(%ebx)
     8a4:	e8 84 ff ff ff       	call   82d <nulterminate>
    nulterminate(lcmd->right);
     8a9:	83 c4 04             	add    $0x4,%esp
     8ac:	ff 73 08             	pushl  0x8(%ebx)
     8af:	e8 79 ff ff ff       	call   82d <nulterminate>
    break;
     8b4:	83 c4 10             	add    $0x10,%esp
     8b7:	eb c3                	jmp    87c <nulterminate+0x4f>
    nulterminate(bcmd->cmd);
     8b9:	83 ec 0c             	sub    $0xc,%esp
     8bc:	ff 73 04             	pushl  0x4(%ebx)
     8bf:	e8 69 ff ff ff       	call   82d <nulterminate>
    break;
     8c4:	83 c4 10             	add    $0x10,%esp
     8c7:	eb b3                	jmp    87c <nulterminate+0x4f>

000008c9 <parsecmd>:
{
     8c9:	f3 0f 1e fb          	endbr32 
     8cd:	55                   	push   %ebp
     8ce:	89 e5                	mov    %esp,%ebp
     8d0:	56                   	push   %esi
     8d1:	53                   	push   %ebx
  es = s + strlen(s);
     8d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8d5:	83 ec 0c             	sub    $0xc,%esp
     8d8:	53                   	push   %ebx
     8d9:	e8 87 01 00 00       	call   a65 <strlen>
     8de:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     8e0:	83 c4 08             	add    $0x8,%esp
     8e3:	53                   	push   %ebx
     8e4:	8d 45 08             	lea    0x8(%ebp),%eax
     8e7:	50                   	push   %eax
     8e8:	e8 20 fe ff ff       	call   70d <parseline>
     8ed:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     8ef:	83 c4 0c             	add    $0xc,%esp
     8f2:	68 72 10 00 00       	push   $0x1072
     8f7:	53                   	push   %ebx
     8f8:	8d 45 08             	lea    0x8(%ebp),%eax
     8fb:	50                   	push   %eax
     8fc:	e8 7c fb ff ff       	call   47d <peek>
  if(s != es){
     901:	8b 45 08             	mov    0x8(%ebp),%eax
     904:	83 c4 10             	add    $0x10,%esp
     907:	39 d8                	cmp    %ebx,%eax
     909:	75 12                	jne    91d <parsecmd+0x54>
  nulterminate(cmd);
     90b:	83 ec 0c             	sub    $0xc,%esp
     90e:	56                   	push   %esi
     90f:	e8 19 ff ff ff       	call   82d <nulterminate>
}
     914:	89 f0                	mov    %esi,%eax
     916:	8d 65 f8             	lea    -0x8(%ebp),%esp
     919:	5b                   	pop    %ebx
     91a:	5e                   	pop    %esi
     91b:	5d                   	pop    %ebp
     91c:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     91d:	83 ec 04             	sub    $0x4,%esp
     920:	50                   	push   %eax
     921:	68 e6 10 00 00       	push   $0x10e6
     926:	6a 02                	push   $0x2
     928:	e8 0d 04 00 00       	call   d3a <printf>
    panic("syntax");
     92d:	c7 04 24 aa 10 00 00 	movl   $0x10aa,(%esp)
     934:	e8 10 f7 ff ff       	call   49 <panic>

00000939 <main>:
{
     939:	f3 0f 1e fb          	endbr32 
     93d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     941:	83 e4 f0             	and    $0xfffffff0,%esp
     944:	ff 71 fc             	pushl  -0x4(%ecx)
     947:	55                   	push   %ebp
     948:	89 e5                	mov    %esp,%ebp
     94a:	51                   	push   %ecx
     94b:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
     94e:	83 ec 08             	sub    $0x8,%esp
     951:	6a 02                	push   $0x2
     953:	68 f5 10 00 00       	push   $0x10f5
     958:	e8 d9 02 00 00       	call   c36 <open>
     95d:	83 c4 10             	add    $0x10,%esp
     960:	85 c0                	test   %eax,%eax
     962:	78 21                	js     985 <main+0x4c>
    if(fd >= 3){
     964:	83 f8 02             	cmp    $0x2,%eax
     967:	7e e5                	jle    94e <main+0x15>
      close(fd);
     969:	83 ec 0c             	sub    $0xc,%esp
     96c:	50                   	push   %eax
     96d:	e8 ac 02 00 00       	call   c1e <close>
      break;
     972:	83 c4 10             	add    $0x10,%esp
     975:	eb 0e                	jmp    985 <main+0x4c>
    if(fork1() == 0)
     977:	e8 eb f6 ff ff       	call   67 <fork1>
     97c:	85 c0                	test   %eax,%eax
     97e:	74 76                	je     9f6 <main+0xbd>
    wait();
     980:	e8 79 02 00 00       	call   bfe <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     985:	83 ec 08             	sub    $0x8,%esp
     988:	6a 64                	push   $0x64
     98a:	68 a0 16 00 00       	push   $0x16a0
     98f:	e8 6c f6 ff ff       	call   0 <getcmd>
     994:	83 c4 10             	add    $0x10,%esp
     997:	85 c0                	test   %eax,%eax
     999:	78 70                	js     a0b <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     99b:	80 3d a0 16 00 00 63 	cmpb   $0x63,0x16a0
     9a2:	75 d3                	jne    977 <main+0x3e>
     9a4:	80 3d a1 16 00 00 64 	cmpb   $0x64,0x16a1
     9ab:	75 ca                	jne    977 <main+0x3e>
     9ad:	80 3d a2 16 00 00 20 	cmpb   $0x20,0x16a2
     9b4:	75 c1                	jne    977 <main+0x3e>
      buf[strlen(buf)-1] = 0;  // chop \n
     9b6:	83 ec 0c             	sub    $0xc,%esp
     9b9:	68 a0 16 00 00       	push   $0x16a0
     9be:	e8 a2 00 00 00       	call   a65 <strlen>
     9c3:	c6 80 9f 16 00 00 00 	movb   $0x0,0x169f(%eax)
      if(chdir(buf+3) < 0)
     9ca:	c7 04 24 a3 16 00 00 	movl   $0x16a3,(%esp)
     9d1:	e8 90 02 00 00       	call   c66 <chdir>
     9d6:	83 c4 10             	add    $0x10,%esp
     9d9:	85 c0                	test   %eax,%eax
     9db:	79 a8                	jns    985 <main+0x4c>
        printf(2, "cannot cd %s\n", buf+3);
     9dd:	83 ec 04             	sub    $0x4,%esp
     9e0:	68 a3 16 00 00       	push   $0x16a3
     9e5:	68 fd 10 00 00       	push   $0x10fd
     9ea:	6a 02                	push   $0x2
     9ec:	e8 49 03 00 00       	call   d3a <printf>
     9f1:	83 c4 10             	add    $0x10,%esp
     9f4:	eb 8f                	jmp    985 <main+0x4c>
      runcmd(parsecmd(buf));
     9f6:	83 ec 0c             	sub    $0xc,%esp
     9f9:	68 a0 16 00 00       	push   $0x16a0
     9fe:	e8 c6 fe ff ff       	call   8c9 <parsecmd>
     a03:	89 04 24             	mov    %eax,(%esp)
     a06:	e8 7f f6 ff ff       	call   8a <runcmd>
  exit();
     a0b:	e8 e6 01 00 00       	call   bf6 <exit>

00000a10 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     a10:	f3 0f 1e fb          	endbr32 
     a14:	55                   	push   %ebp
     a15:	89 e5                	mov    %esp,%ebp
     a17:	53                   	push   %ebx
     a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
     a1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a1e:	b8 00 00 00 00       	mov    $0x0,%eax
     a23:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     a27:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     a2a:	83 c0 01             	add    $0x1,%eax
     a2d:	84 d2                	test   %dl,%dl
     a2f:	75 f2                	jne    a23 <strcpy+0x13>
    ;
  return os;
}
     a31:	89 c8                	mov    %ecx,%eax
     a33:	5b                   	pop    %ebx
     a34:	5d                   	pop    %ebp
     a35:	c3                   	ret    

00000a36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a36:	f3 0f 1e fb          	endbr32 
     a3a:	55                   	push   %ebp
     a3b:	89 e5                	mov    %esp,%ebp
     a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     a43:	0f b6 01             	movzbl (%ecx),%eax
     a46:	84 c0                	test   %al,%al
     a48:	74 11                	je     a5b <strcmp+0x25>
     a4a:	38 02                	cmp    %al,(%edx)
     a4c:	75 0d                	jne    a5b <strcmp+0x25>
    p++, q++;
     a4e:	83 c1 01             	add    $0x1,%ecx
     a51:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     a54:	0f b6 01             	movzbl (%ecx),%eax
     a57:	84 c0                	test   %al,%al
     a59:	75 ef                	jne    a4a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     a5b:	0f b6 c0             	movzbl %al,%eax
     a5e:	0f b6 12             	movzbl (%edx),%edx
     a61:	29 d0                	sub    %edx,%eax
}
     a63:	5d                   	pop    %ebp
     a64:	c3                   	ret    

00000a65 <strlen>:

uint
strlen(const char *s)
{
     a65:	f3 0f 1e fb          	endbr32 
     a69:	55                   	push   %ebp
     a6a:	89 e5                	mov    %esp,%ebp
     a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     a6f:	80 3a 00             	cmpb   $0x0,(%edx)
     a72:	74 14                	je     a88 <strlen+0x23>
     a74:	b8 00 00 00 00       	mov    $0x0,%eax
     a79:	83 c0 01             	add    $0x1,%eax
     a7c:	89 c1                	mov    %eax,%ecx
     a7e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     a82:	75 f5                	jne    a79 <strlen+0x14>
    ;
  return n;
}
     a84:	89 c8                	mov    %ecx,%eax
     a86:	5d                   	pop    %ebp
     a87:	c3                   	ret    
  for(n = 0; s[n]; n++)
     a88:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
     a8d:	eb f5                	jmp    a84 <strlen+0x1f>

00000a8f <memset>:

void*
memset(void *dst, int c, uint n)
{
     a8f:	f3 0f 1e fb          	endbr32 
     a93:	55                   	push   %ebp
     a94:	89 e5                	mov    %esp,%ebp
     a96:	57                   	push   %edi
     a97:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a9a:	89 d7                	mov    %edx,%edi
     a9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	fc                   	cld    
     aa3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     aa5:	89 d0                	mov    %edx,%eax
     aa7:	5f                   	pop    %edi
     aa8:	5d                   	pop    %ebp
     aa9:	c3                   	ret    

00000aaa <strchr>:

char*
strchr(const char *s, char c)
{
     aaa:	f3 0f 1e fb          	endbr32 
     aae:	55                   	push   %ebp
     aaf:	89 e5                	mov    %esp,%ebp
     ab1:	8b 45 08             	mov    0x8(%ebp),%eax
     ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     ab8:	0f b6 10             	movzbl (%eax),%edx
     abb:	84 d2                	test   %dl,%dl
     abd:	74 15                	je     ad4 <strchr+0x2a>
    if(*s == c)
     abf:	38 d1                	cmp    %dl,%cl
     ac1:	74 0f                	je     ad2 <strchr+0x28>
  for(; *s; s++)
     ac3:	83 c0 01             	add    $0x1,%eax
     ac6:	0f b6 10             	movzbl (%eax),%edx
     ac9:	84 d2                	test   %dl,%dl
     acb:	75 f2                	jne    abf <strchr+0x15>
      return (char*)s;
  return 0;
     acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ad2:	5d                   	pop    %ebp
     ad3:	c3                   	ret    
  return 0;
     ad4:	b8 00 00 00 00       	mov    $0x0,%eax
     ad9:	eb f7                	jmp    ad2 <strchr+0x28>

00000adb <gets>:

char*
gets(char *buf, int max)
{
     adb:	f3 0f 1e fb          	endbr32 
     adf:	55                   	push   %ebp
     ae0:	89 e5                	mov    %esp,%ebp
     ae2:	57                   	push   %edi
     ae3:	56                   	push   %esi
     ae4:	53                   	push   %ebx
     ae5:	83 ec 2c             	sub    $0x2c,%esp
     ae8:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
     af0:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
     af3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
     af6:	83 c3 01             	add    $0x1,%ebx
     af9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     afc:	7d 27                	jge    b25 <gets+0x4a>
    cc = read(0, &c, 1);
     afe:	83 ec 04             	sub    $0x4,%esp
     b01:	6a 01                	push   $0x1
     b03:	57                   	push   %edi
     b04:	6a 00                	push   $0x0
     b06:	e8 03 01 00 00       	call   c0e <read>
    if(cc < 1)
     b0b:	83 c4 10             	add    $0x10,%esp
     b0e:	85 c0                	test   %eax,%eax
     b10:	7e 13                	jle    b25 <gets+0x4a>
      break;
    buf[i++] = c;
     b12:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     b16:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
     b1a:	3c 0a                	cmp    $0xa,%al
     b1c:	74 04                	je     b22 <gets+0x47>
     b1e:	3c 0d                	cmp    $0xd,%al
     b20:	75 d1                	jne    af3 <gets+0x18>
  for(i=0; i+1 < max; ){
     b22:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
     b25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     b28:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
     b2c:	89 f0                	mov    %esi,%eax
     b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b31:	5b                   	pop    %ebx
     b32:	5e                   	pop    %esi
     b33:	5f                   	pop    %edi
     b34:	5d                   	pop    %ebp
     b35:	c3                   	ret    

00000b36 <stat>:

int
stat(const char *n, struct stat *st)
{
     b36:	f3 0f 1e fb          	endbr32 
     b3a:	55                   	push   %ebp
     b3b:	89 e5                	mov    %esp,%ebp
     b3d:	56                   	push   %esi
     b3e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b3f:	83 ec 08             	sub    $0x8,%esp
     b42:	6a 00                	push   $0x0
     b44:	ff 75 08             	pushl  0x8(%ebp)
     b47:	e8 ea 00 00 00       	call   c36 <open>
  if(fd < 0)
     b4c:	83 c4 10             	add    $0x10,%esp
     b4f:	85 c0                	test   %eax,%eax
     b51:	78 24                	js     b77 <stat+0x41>
     b53:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     b55:	83 ec 08             	sub    $0x8,%esp
     b58:	ff 75 0c             	pushl  0xc(%ebp)
     b5b:	50                   	push   %eax
     b5c:	e8 ed 00 00 00       	call   c4e <fstat>
     b61:	89 c6                	mov    %eax,%esi
  close(fd);
     b63:	89 1c 24             	mov    %ebx,(%esp)
     b66:	e8 b3 00 00 00       	call   c1e <close>
  return r;
     b6b:	83 c4 10             	add    $0x10,%esp
}
     b6e:	89 f0                	mov    %esi,%eax
     b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b73:	5b                   	pop    %ebx
     b74:	5e                   	pop    %esi
     b75:	5d                   	pop    %ebp
     b76:	c3                   	ret    
    return -1;
     b77:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b7c:	eb f0                	jmp    b6e <stat+0x38>

00000b7e <atoi>:

int
atoi(const char *s)
{
     b7e:	f3 0f 1e fb          	endbr32 
     b82:	55                   	push   %ebp
     b83:	89 e5                	mov    %esp,%ebp
     b85:	53                   	push   %ebx
     b86:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b89:	0f b6 02             	movzbl (%edx),%eax
     b8c:	8d 48 d0             	lea    -0x30(%eax),%ecx
     b8f:	80 f9 09             	cmp    $0x9,%cl
     b92:	77 22                	ja     bb6 <atoi+0x38>
  n = 0;
     b94:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
     b99:	83 c2 01             	add    $0x1,%edx
     b9c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     b9f:	0f be c0             	movsbl %al,%eax
     ba2:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     ba6:	0f b6 02             	movzbl (%edx),%eax
     ba9:	8d 58 d0             	lea    -0x30(%eax),%ebx
     bac:	80 fb 09             	cmp    $0x9,%bl
     baf:	76 e8                	jbe    b99 <atoi+0x1b>
  return n;
}
     bb1:	89 c8                	mov    %ecx,%eax
     bb3:	5b                   	pop    %ebx
     bb4:	5d                   	pop    %ebp
     bb5:	c3                   	ret    
  n = 0;
     bb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
     bbb:	eb f4                	jmp    bb1 <atoi+0x33>

00000bbd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     bbd:	f3 0f 1e fb          	endbr32 
     bc1:	55                   	push   %ebp
     bc2:	89 e5                	mov    %esp,%ebp
     bc4:	56                   	push   %esi
     bc5:	53                   	push   %ebx
     bc6:	8b 75 08             	mov    0x8(%ebp),%esi
     bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
     bcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     bcf:	85 db                	test   %ebx,%ebx
     bd1:	7e 15                	jle    be8 <memmove+0x2b>
     bd3:	01 f3                	add    %esi,%ebx
  dst = vdst;
     bd5:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
     bd7:	83 c2 01             	add    $0x1,%edx
     bda:	83 c0 01             	add    $0x1,%eax
     bdd:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
     be1:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
     be4:	39 c3                	cmp    %eax,%ebx
     be6:	75 ef                	jne    bd7 <memmove+0x1a>
  return vdst;
}
     be8:	89 f0                	mov    %esi,%eax
     bea:	5b                   	pop    %ebx
     beb:	5e                   	pop    %esi
     bec:	5d                   	pop    %ebp
     bed:	c3                   	ret    

00000bee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     bee:	b8 01 00 00 00       	mov    $0x1,%eax
     bf3:	cd 40                	int    $0x40
     bf5:	c3                   	ret    

00000bf6 <exit>:
SYSCALL(exit)
     bf6:	b8 02 00 00 00       	mov    $0x2,%eax
     bfb:	cd 40                	int    $0x40
     bfd:	c3                   	ret    

00000bfe <wait>:
SYSCALL(wait)
     bfe:	b8 03 00 00 00       	mov    $0x3,%eax
     c03:	cd 40                	int    $0x40
     c05:	c3                   	ret    

00000c06 <pipe>:
SYSCALL(pipe)
     c06:	b8 04 00 00 00       	mov    $0x4,%eax
     c0b:	cd 40                	int    $0x40
     c0d:	c3                   	ret    

00000c0e <read>:
SYSCALL(read)
     c0e:	b8 05 00 00 00       	mov    $0x5,%eax
     c13:	cd 40                	int    $0x40
     c15:	c3                   	ret    

00000c16 <write>:
SYSCALL(write)
     c16:	b8 10 00 00 00       	mov    $0x10,%eax
     c1b:	cd 40                	int    $0x40
     c1d:	c3                   	ret    

00000c1e <close>:
SYSCALL(close)
     c1e:	b8 15 00 00 00       	mov    $0x15,%eax
     c23:	cd 40                	int    $0x40
     c25:	c3                   	ret    

00000c26 <kill>:
SYSCALL(kill)
     c26:	b8 06 00 00 00       	mov    $0x6,%eax
     c2b:	cd 40                	int    $0x40
     c2d:	c3                   	ret    

00000c2e <exec>:
SYSCALL(exec)
     c2e:	b8 07 00 00 00       	mov    $0x7,%eax
     c33:	cd 40                	int    $0x40
     c35:	c3                   	ret    

00000c36 <open>:
SYSCALL(open)
     c36:	b8 0f 00 00 00       	mov    $0xf,%eax
     c3b:	cd 40                	int    $0x40
     c3d:	c3                   	ret    

00000c3e <mknod>:
SYSCALL(mknod)
     c3e:	b8 11 00 00 00       	mov    $0x11,%eax
     c43:	cd 40                	int    $0x40
     c45:	c3                   	ret    

00000c46 <unlink>:
SYSCALL(unlink)
     c46:	b8 12 00 00 00       	mov    $0x12,%eax
     c4b:	cd 40                	int    $0x40
     c4d:	c3                   	ret    

00000c4e <fstat>:
SYSCALL(fstat)
     c4e:	b8 08 00 00 00       	mov    $0x8,%eax
     c53:	cd 40                	int    $0x40
     c55:	c3                   	ret    

00000c56 <link>:
SYSCALL(link)
     c56:	b8 13 00 00 00       	mov    $0x13,%eax
     c5b:	cd 40                	int    $0x40
     c5d:	c3                   	ret    

00000c5e <mkdir>:
SYSCALL(mkdir)
     c5e:	b8 14 00 00 00       	mov    $0x14,%eax
     c63:	cd 40                	int    $0x40
     c65:	c3                   	ret    

00000c66 <chdir>:
SYSCALL(chdir)
     c66:	b8 09 00 00 00       	mov    $0x9,%eax
     c6b:	cd 40                	int    $0x40
     c6d:	c3                   	ret    

00000c6e <dup>:
SYSCALL(dup)
     c6e:	b8 0a 00 00 00       	mov    $0xa,%eax
     c73:	cd 40                	int    $0x40
     c75:	c3                   	ret    

00000c76 <getpid>:
SYSCALL(getpid)
     c76:	b8 0b 00 00 00       	mov    $0xb,%eax
     c7b:	cd 40                	int    $0x40
     c7d:	c3                   	ret    

00000c7e <sbrk>:
SYSCALL(sbrk)
     c7e:	b8 0c 00 00 00       	mov    $0xc,%eax
     c83:	cd 40                	int    $0x40
     c85:	c3                   	ret    

00000c86 <sleep>:
SYSCALL(sleep)
     c86:	b8 0d 00 00 00       	mov    $0xd,%eax
     c8b:	cd 40                	int    $0x40
     c8d:	c3                   	ret    

00000c8e <uptime>:
SYSCALL(uptime)
     c8e:	b8 0e 00 00 00       	mov    $0xe,%eax
     c93:	cd 40                	int    $0x40
     c95:	c3                   	ret    

00000c96 <slabtest>:
SYSCALL(slabtest)
     c96:	b8 16 00 00 00       	mov    $0x16,%eax
     c9b:	cd 40                	int    $0x40
     c9d:	c3                   	ret    

00000c9e <ps>:
SYSCALL(ps)
     c9e:	b8 17 00 00 00       	mov    $0x17,%eax
     ca3:	cd 40                	int    $0x40
     ca5:	c3                   	ret    

00000ca6 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ca6:	55                   	push   %ebp
     ca7:	89 e5                	mov    %esp,%ebp
     ca9:	57                   	push   %edi
     caa:	56                   	push   %esi
     cab:	53                   	push   %ebx
     cac:	83 ec 3c             	sub    $0x3c,%esp
     caf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     cb2:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cb8:	74 77                	je     d31 <printint+0x8b>
     cba:	85 d2                	test   %edx,%edx
     cbc:	79 73                	jns    d31 <printint+0x8b>
    neg = 1;
    x = -xx;
     cbe:	f7 db                	neg    %ebx
    neg = 1;
     cc0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     cc7:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
     ccc:	89 f7                	mov    %esi,%edi
     cce:	83 c6 01             	add    $0x1,%esi
     cd1:	89 d8                	mov    %ebx,%eax
     cd3:	ba 00 00 00 00       	mov    $0x0,%edx
     cd8:	f7 f1                	div    %ecx
     cda:	0f b6 92 44 11 00 00 	movzbl 0x1144(%edx),%edx
     ce1:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
     ce5:	89 da                	mov    %ebx,%edx
     ce7:	89 c3                	mov    %eax,%ebx
     ce9:	39 d1                	cmp    %edx,%ecx
     ceb:	76 df                	jbe    ccc <printint+0x26>
  if(neg)
     ced:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
     cf1:	74 08                	je     cfb <printint+0x55>
    buf[i++] = '-';
     cf3:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
     cf8:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
     cfb:	85 f6                	test   %esi,%esi
     cfd:	7e 2a                	jle    d29 <printint+0x83>
     cff:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
     d03:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
     d06:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
     d09:	0f b6 03             	movzbl (%ebx),%eax
     d0c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
     d0f:	83 ec 04             	sub    $0x4,%esp
     d12:	6a 01                	push   $0x1
     d14:	56                   	push   %esi
     d15:	ff 75 c4             	pushl  -0x3c(%ebp)
     d18:	e8 f9 fe ff ff       	call   c16 <write>
  while(--i >= 0)
     d1d:	89 d8                	mov    %ebx,%eax
     d1f:	83 eb 01             	sub    $0x1,%ebx
     d22:	83 c4 10             	add    $0x10,%esp
     d25:	39 f8                	cmp    %edi,%eax
     d27:	75 e0                	jne    d09 <printint+0x63>
}
     d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d2c:	5b                   	pop    %ebx
     d2d:	5e                   	pop    %esi
     d2e:	5f                   	pop    %edi
     d2f:	5d                   	pop    %ebp
     d30:	c3                   	ret    
  neg = 0;
     d31:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     d38:	eb 8d                	jmp    cc7 <printint+0x21>

00000d3a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     d3a:	f3 0f 1e fb          	endbr32 
     d3e:	55                   	push   %ebp
     d3f:	89 e5                	mov    %esp,%ebp
     d41:	57                   	push   %edi
     d42:	56                   	push   %esi
     d43:	53                   	push   %ebx
     d44:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d47:	8b 75 0c             	mov    0xc(%ebp),%esi
     d4a:	0f b6 1e             	movzbl (%esi),%ebx
     d4d:	84 db                	test   %bl,%bl
     d4f:	0f 84 ab 01 00 00    	je     f00 <printf+0x1c6>
     d55:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
     d58:	8d 45 10             	lea    0x10(%ebp),%eax
     d5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
     d5e:	bf 00 00 00 00       	mov    $0x0,%edi
     d63:	eb 2d                	jmp    d92 <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     d65:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     d68:	83 ec 04             	sub    $0x4,%esp
     d6b:	6a 01                	push   $0x1
     d6d:	8d 45 e7             	lea    -0x19(%ebp),%eax
     d70:	50                   	push   %eax
     d71:	ff 75 08             	pushl  0x8(%ebp)
     d74:	e8 9d fe ff ff       	call   c16 <write>
        putc(fd, c);
     d79:	83 c4 10             	add    $0x10,%esp
     d7c:	eb 05                	jmp    d83 <printf+0x49>
      }
    } else if(state == '%'){
     d7e:	83 ff 25             	cmp    $0x25,%edi
     d81:	74 22                	je     da5 <printf+0x6b>
  for(i = 0; fmt[i]; i++){
     d83:	83 c6 01             	add    $0x1,%esi
     d86:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     d8a:	84 db                	test   %bl,%bl
     d8c:	0f 84 6e 01 00 00    	je     f00 <printf+0x1c6>
    c = fmt[i] & 0xff;
     d92:	0f be d3             	movsbl %bl,%edx
     d95:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     d98:	85 ff                	test   %edi,%edi
     d9a:	75 e2                	jne    d7e <printf+0x44>
      if(c == '%'){
     d9c:	83 f8 25             	cmp    $0x25,%eax
     d9f:	75 c4                	jne    d65 <printf+0x2b>
        state = '%';
     da1:	89 c7                	mov    %eax,%edi
     da3:	eb de                	jmp    d83 <printf+0x49>
      if(c == 'd'){
     da5:	83 f8 64             	cmp    $0x64,%eax
     da8:	74 59                	je     e03 <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     daa:	81 e2 f7 00 00 00    	and    $0xf7,%edx
     db0:	83 fa 70             	cmp    $0x70,%edx
     db3:	74 7a                	je     e2f <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     db5:	83 f8 73             	cmp    $0x73,%eax
     db8:	0f 84 9d 00 00 00    	je     e5b <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     dbe:	83 f8 63             	cmp    $0x63,%eax
     dc1:	0f 84 ec 00 00 00    	je     eb3 <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     dc7:	83 f8 25             	cmp    $0x25,%eax
     dca:	0f 84 0f 01 00 00    	je     edf <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     dd0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
     dd4:	83 ec 04             	sub    $0x4,%esp
     dd7:	6a 01                	push   $0x1
     dd9:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ddc:	50                   	push   %eax
     ddd:	ff 75 08             	pushl  0x8(%ebp)
     de0:	e8 31 fe ff ff       	call   c16 <write>
        putc(fd, c);
     de5:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     de8:	83 c4 0c             	add    $0xc,%esp
     deb:	6a 01                	push   $0x1
     ded:	8d 45 e7             	lea    -0x19(%ebp),%eax
     df0:	50                   	push   %eax
     df1:	ff 75 08             	pushl  0x8(%ebp)
     df4:	e8 1d fe ff ff       	call   c16 <write>
        putc(fd, c);
     df9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     dfc:	bf 00 00 00 00       	mov    $0x0,%edi
     e01:	eb 80                	jmp    d83 <printf+0x49>
        printint(fd, *ap, 10, 1);
     e03:	83 ec 0c             	sub    $0xc,%esp
     e06:	6a 01                	push   $0x1
     e08:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e0d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e10:	8b 17                	mov    (%edi),%edx
     e12:	8b 45 08             	mov    0x8(%ebp),%eax
     e15:	e8 8c fe ff ff       	call   ca6 <printint>
        ap++;
     e1a:	89 f8                	mov    %edi,%eax
     e1c:	83 c0 04             	add    $0x4,%eax
     e1f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e22:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e25:	bf 00 00 00 00       	mov    $0x0,%edi
     e2a:	e9 54 ff ff ff       	jmp    d83 <printf+0x49>
        printint(fd, *ap, 16, 0);
     e2f:	83 ec 0c             	sub    $0xc,%esp
     e32:	6a 00                	push   $0x0
     e34:	b9 10 00 00 00       	mov    $0x10,%ecx
     e39:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e3c:	8b 17                	mov    (%edi),%edx
     e3e:	8b 45 08             	mov    0x8(%ebp),%eax
     e41:	e8 60 fe ff ff       	call   ca6 <printint>
        ap++;
     e46:	89 f8                	mov    %edi,%eax
     e48:	83 c0 04             	add    $0x4,%eax
     e4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e4e:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e51:	bf 00 00 00 00       	mov    $0x0,%edi
     e56:	e9 28 ff ff ff       	jmp    d83 <printf+0x49>
        s = (char*)*ap;
     e5b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     e5e:	8b 01                	mov    (%ecx),%eax
        ap++;
     e60:	83 c1 04             	add    $0x4,%ecx
     e63:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
     e66:	85 c0                	test   %eax,%eax
     e68:	74 13                	je     e7d <printf+0x143>
        s = (char*)*ap;
     e6a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
     e6c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
     e6f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
     e74:	84 c0                	test   %al,%al
     e76:	75 0f                	jne    e87 <printf+0x14d>
     e78:	e9 06 ff ff ff       	jmp    d83 <printf+0x49>
          s = "(null)";
     e7d:	bb 3c 11 00 00       	mov    $0x113c,%ebx
        while(*s != 0){
     e82:	b8 28 00 00 00       	mov    $0x28,%eax
     e87:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
     e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     e8d:	83 ec 04             	sub    $0x4,%esp
     e90:	6a 01                	push   $0x1
     e92:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e95:	50                   	push   %eax
     e96:	57                   	push   %edi
     e97:	e8 7a fd ff ff       	call   c16 <write>
          s++;
     e9c:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
     e9f:	0f b6 03             	movzbl (%ebx),%eax
     ea2:	83 c4 10             	add    $0x10,%esp
     ea5:	84 c0                	test   %al,%al
     ea7:	75 e1                	jne    e8a <printf+0x150>
      state = 0;
     ea9:	bf 00 00 00 00       	mov    $0x0,%edi
     eae:	e9 d0 fe ff ff       	jmp    d83 <printf+0x49>
        putc(fd, *ap);
     eb3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     eb6:	8b 07                	mov    (%edi),%eax
     eb8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     ebb:	83 ec 04             	sub    $0x4,%esp
     ebe:	6a 01                	push   $0x1
     ec0:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ec3:	50                   	push   %eax
     ec4:	ff 75 08             	pushl  0x8(%ebp)
     ec7:	e8 4a fd ff ff       	call   c16 <write>
        ap++;
     ecc:	83 c7 04             	add    $0x4,%edi
     ecf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
     ed2:	83 c4 10             	add    $0x10,%esp
      state = 0;
     ed5:	bf 00 00 00 00       	mov    $0x0,%edi
     eda:	e9 a4 fe ff ff       	jmp    d83 <printf+0x49>
        putc(fd, c);
     edf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     ee2:	83 ec 04             	sub    $0x4,%esp
     ee5:	6a 01                	push   $0x1
     ee7:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eea:	50                   	push   %eax
     eeb:	ff 75 08             	pushl  0x8(%ebp)
     eee:	e8 23 fd ff ff       	call   c16 <write>
     ef3:	83 c4 10             	add    $0x10,%esp
      state = 0;
     ef6:	bf 00 00 00 00       	mov    $0x0,%edi
     efb:	e9 83 fe ff ff       	jmp    d83 <printf+0x49>
    }
  }
}
     f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f03:	5b                   	pop    %ebx
     f04:	5e                   	pop    %esi
     f05:	5f                   	pop    %edi
     f06:	5d                   	pop    %ebp
     f07:	c3                   	ret    

00000f08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f08:	f3 0f 1e fb          	endbr32 
     f0c:	55                   	push   %ebp
     f0d:	89 e5                	mov    %esp,%ebp
     f0f:	57                   	push   %edi
     f10:	56                   	push   %esi
     f11:	53                   	push   %ebx
     f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f15:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f18:	a1 04 17 00 00       	mov    0x1704,%eax
     f1d:	eb 0c                	jmp    f2b <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f1f:	8b 10                	mov    (%eax),%edx
     f21:	39 c2                	cmp    %eax,%edx
     f23:	77 04                	ja     f29 <free+0x21>
     f25:	39 ca                	cmp    %ecx,%edx
     f27:	77 10                	ja     f39 <free+0x31>
{
     f29:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f2b:	39 c8                	cmp    %ecx,%eax
     f2d:	73 f0                	jae    f1f <free+0x17>
     f2f:	8b 10                	mov    (%eax),%edx
     f31:	39 ca                	cmp    %ecx,%edx
     f33:	77 04                	ja     f39 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f35:	39 c2                	cmp    %eax,%edx
     f37:	77 f0                	ja     f29 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f39:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f3c:	8b 10                	mov    (%eax),%edx
     f3e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f41:	39 fa                	cmp    %edi,%edx
     f43:	74 19                	je     f5e <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f45:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f48:	8b 50 04             	mov    0x4(%eax),%edx
     f4b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f4e:	39 f1                	cmp    %esi,%ecx
     f50:	74 1b                	je     f6d <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f52:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f54:	a3 04 17 00 00       	mov    %eax,0x1704
}
     f59:	5b                   	pop    %ebx
     f5a:	5e                   	pop    %esi
     f5b:	5f                   	pop    %edi
     f5c:	5d                   	pop    %ebp
     f5d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
     f5e:	03 72 04             	add    0x4(%edx),%esi
     f61:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f64:	8b 10                	mov    (%eax),%edx
     f66:	8b 12                	mov    (%edx),%edx
     f68:	89 53 f8             	mov    %edx,-0x8(%ebx)
     f6b:	eb db                	jmp    f48 <free+0x40>
    p->s.size += bp->s.size;
     f6d:	03 53 fc             	add    -0x4(%ebx),%edx
     f70:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f73:	8b 53 f8             	mov    -0x8(%ebx),%edx
     f76:	89 10                	mov    %edx,(%eax)
     f78:	eb da                	jmp    f54 <free+0x4c>

00000f7a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f7a:	f3 0f 1e fb          	endbr32 
     f7e:	55                   	push   %ebp
     f7f:	89 e5                	mov    %esp,%ebp
     f81:	57                   	push   %edi
     f82:	56                   	push   %esi
     f83:	53                   	push   %ebx
     f84:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f87:	8b 45 08             	mov    0x8(%ebp),%eax
     f8a:	8d 58 07             	lea    0x7(%eax),%ebx
     f8d:	c1 eb 03             	shr    $0x3,%ebx
     f90:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
     f93:	8b 15 04 17 00 00    	mov    0x1704,%edx
     f99:	85 d2                	test   %edx,%edx
     f9b:	74 20                	je     fbd <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f9d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     f9f:	8b 48 04             	mov    0x4(%eax),%ecx
     fa2:	39 cb                	cmp    %ecx,%ebx
     fa4:	76 3c                	jbe    fe2 <malloc+0x68>
     fa6:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
     fac:	be 00 10 00 00       	mov    $0x1000,%esi
     fb1:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
     fb4:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
     fbb:	eb 72                	jmp    102f <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
     fbd:	c7 05 04 17 00 00 08 	movl   $0x1708,0x1704
     fc4:	17 00 00 
     fc7:	c7 05 08 17 00 00 08 	movl   $0x1708,0x1708
     fce:	17 00 00 
    base.s.size = 0;
     fd1:	c7 05 0c 17 00 00 00 	movl   $0x0,0x170c
     fd8:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fdb:	b8 08 17 00 00       	mov    $0x1708,%eax
     fe0:	eb c4                	jmp    fa6 <malloc+0x2c>
      if(p->s.size == nunits)
     fe2:	39 cb                	cmp    %ecx,%ebx
     fe4:	74 1e                	je     1004 <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
     fe6:	29 d9                	sub    %ebx,%ecx
     fe8:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     feb:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     fee:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
     ff1:	89 15 04 17 00 00    	mov    %edx,0x1704
      return (void*)(p + 1);
     ff7:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
     ffa:	89 d0                	mov    %edx,%eax
     ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fff:	5b                   	pop    %ebx
    1000:	5e                   	pop    %esi
    1001:	5f                   	pop    %edi
    1002:	5d                   	pop    %ebp
    1003:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1004:	8b 08                	mov    (%eax),%ecx
    1006:	89 0a                	mov    %ecx,(%edx)
    1008:	eb e7                	jmp    ff1 <malloc+0x77>
  hp->s.size = nu;
    100a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    100d:	83 ec 0c             	sub    $0xc,%esp
    1010:	83 c0 08             	add    $0x8,%eax
    1013:	50                   	push   %eax
    1014:	e8 ef fe ff ff       	call   f08 <free>
  return freep;
    1019:	8b 15 04 17 00 00    	mov    0x1704,%edx
      if((p = morecore(nunits)) == 0)
    101f:	83 c4 10             	add    $0x10,%esp
    1022:	85 d2                	test   %edx,%edx
    1024:	74 d4                	je     ffa <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1026:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1028:	8b 48 04             	mov    0x4(%eax),%ecx
    102b:	39 d9                	cmp    %ebx,%ecx
    102d:	73 b3                	jae    fe2 <malloc+0x68>
    if(p == freep)
    102f:	89 c2                	mov    %eax,%edx
    1031:	39 05 04 17 00 00    	cmp    %eax,0x1704
    1037:	75 ed                	jne    1026 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
    1039:	83 ec 0c             	sub    $0xc,%esp
    103c:	57                   	push   %edi
    103d:	e8 3c fc ff ff       	call   c7e <sbrk>
  if(p == (char*)-1)
    1042:	83 c4 10             	add    $0x10,%esp
    1045:	83 f8 ff             	cmp    $0xffffffff,%eax
    1048:	75 c0                	jne    100a <malloc+0x90>
        return 0;
    104a:	ba 00 00 00 00       	mov    $0x0,%edx
    104f:	eb a9                	jmp    ffa <malloc+0x80>
