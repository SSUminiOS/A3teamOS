
user/_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       a:	68 10 3d 00 00       	push   $0x3d10
       f:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      15:	e8 48 39 00 00       	call   3962 <printf>

  if(mkdir("iputdir") < 0){
      1a:	c7 04 24 a3 3c 00 00 	movl   $0x3ca3,(%esp)
      21:	e8 60 38 00 00       	call   3886 <mkdir>
      26:	83 c4 10             	add    $0x10,%esp
      29:	85 c0                	test   %eax,%eax
      2b:	78 54                	js     81 <iputtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      2d:	83 ec 0c             	sub    $0xc,%esp
      30:	68 a3 3c 00 00       	push   $0x3ca3
      35:	e8 54 38 00 00       	call   388e <chdir>
      3a:	83 c4 10             	add    $0x10,%esp
      3d:	85 c0                	test   %eax,%eax
      3f:	78 58                	js     99 <iputtest+0x99>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      41:	83 ec 0c             	sub    $0xc,%esp
      44:	68 a0 3c 00 00       	push   $0x3ca0
      49:	e8 20 38 00 00       	call   386e <unlink>
      4e:	83 c4 10             	add    $0x10,%esp
      51:	85 c0                	test   %eax,%eax
      53:	78 5c                	js     b1 <iputtest+0xb1>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      55:	83 ec 0c             	sub    $0xc,%esp
      58:	68 c5 3c 00 00       	push   $0x3cc5
      5d:	e8 2c 38 00 00       	call   388e <chdir>
      62:	83 c4 10             	add    $0x10,%esp
      65:	85 c0                	test   %eax,%eax
      67:	78 60                	js     c9 <iputtest+0xc9>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      69:	83 ec 08             	sub    $0x8,%esp
      6c:	68 48 3d 00 00       	push   $0x3d48
      71:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      77:	e8 e6 38 00 00       	call   3962 <printf>
}
      7c:	83 c4 10             	add    $0x10,%esp
      7f:	c9                   	leave  
      80:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      81:	83 ec 08             	sub    $0x8,%esp
      84:	68 7c 3c 00 00       	push   $0x3c7c
      89:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      8f:	e8 ce 38 00 00       	call   3962 <printf>
    exit();
      94:	e8 85 37 00 00       	call   381e <exit>
    printf(stdout, "chdir iputdir failed\n");
      99:	83 ec 08             	sub    $0x8,%esp
      9c:	68 8a 3c 00 00       	push   $0x3c8a
      a1:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      a7:	e8 b6 38 00 00       	call   3962 <printf>
    exit();
      ac:	e8 6d 37 00 00       	call   381e <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      b1:	83 ec 08             	sub    $0x8,%esp
      b4:	68 ab 3c 00 00       	push   $0x3cab
      b9:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      bf:	e8 9e 38 00 00       	call   3962 <printf>
    exit();
      c4:	e8 55 37 00 00       	call   381e <exit>
    printf(stdout, "chdir / failed\n");
      c9:	83 ec 08             	sub    $0x8,%esp
      cc:	68 c7 3c 00 00       	push   $0x3cc7
      d1:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      d7:	e8 86 38 00 00       	call   3962 <printf>
    exit();
      dc:	e8 3d 37 00 00       	call   381e <exit>

000000e1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e1:	f3 0f 1e fb          	endbr32 
      e5:	55                   	push   %ebp
      e6:	89 e5                	mov    %esp,%ebp
      e8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      eb:	68 d7 3c 00 00       	push   $0x3cd7
      f0:	ff 35 8c 5c 00 00    	pushl  0x5c8c
      f6:	e8 67 38 00 00       	call   3962 <printf>

  pid = fork();
      fb:	e8 16 37 00 00       	call   3816 <fork>
  if(pid < 0){
     100:	83 c4 10             	add    $0x10,%esp
     103:	85 c0                	test   %eax,%eax
     105:	78 47                	js     14e <exitiputtest+0x6d>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     107:	0f 85 a1 00 00 00    	jne    1ae <exitiputtest+0xcd>
    if(mkdir("iputdir") < 0){
     10d:	83 ec 0c             	sub    $0xc,%esp
     110:	68 a3 3c 00 00       	push   $0x3ca3
     115:	e8 6c 37 00 00       	call   3886 <mkdir>
     11a:	83 c4 10             	add    $0x10,%esp
     11d:	85 c0                	test   %eax,%eax
     11f:	78 45                	js     166 <exitiputtest+0x85>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     121:	83 ec 0c             	sub    $0xc,%esp
     124:	68 a3 3c 00 00       	push   $0x3ca3
     129:	e8 60 37 00 00       	call   388e <chdir>
     12e:	83 c4 10             	add    $0x10,%esp
     131:	85 c0                	test   %eax,%eax
     133:	78 49                	js     17e <exitiputtest+0x9d>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	68 a0 3c 00 00       	push   $0x3ca0
     13d:	e8 2c 37 00 00       	call   386e <unlink>
     142:	83 c4 10             	add    $0x10,%esp
     145:	85 c0                	test   %eax,%eax
     147:	78 4d                	js     196 <exitiputtest+0xb5>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     149:	e8 d0 36 00 00       	call   381e <exit>
    printf(stdout, "fork failed\n");
     14e:	83 ec 08             	sub    $0x8,%esp
     151:	68 bd 4b 00 00       	push   $0x4bbd
     156:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     15c:	e8 01 38 00 00       	call   3962 <printf>
    exit();
     161:	e8 b8 36 00 00       	call   381e <exit>
      printf(stdout, "mkdir failed\n");
     166:	83 ec 08             	sub    $0x8,%esp
     169:	68 7c 3c 00 00       	push   $0x3c7c
     16e:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     174:	e8 e9 37 00 00       	call   3962 <printf>
      exit();
     179:	e8 a0 36 00 00       	call   381e <exit>
      printf(stdout, "child chdir failed\n");
     17e:	83 ec 08             	sub    $0x8,%esp
     181:	68 e6 3c 00 00       	push   $0x3ce6
     186:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     18c:	e8 d1 37 00 00       	call   3962 <printf>
      exit();
     191:	e8 88 36 00 00       	call   381e <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     196:	83 ec 08             	sub    $0x8,%esp
     199:	68 ab 3c 00 00       	push   $0x3cab
     19e:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     1a4:	e8 b9 37 00 00       	call   3962 <printf>
      exit();
     1a9:	e8 70 36 00 00       	call   381e <exit>
  }
  wait();
     1ae:	e8 73 36 00 00       	call   3826 <wait>
  printf(stdout, "exitiput test ok\n");
     1b3:	83 ec 08             	sub    $0x8,%esp
     1b6:	68 fa 3c 00 00       	push   $0x3cfa
     1bb:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     1c1:	e8 9c 37 00 00       	call   3962 <printf>
}
     1c6:	83 c4 10             	add    $0x10,%esp
     1c9:	c9                   	leave  
     1ca:	c3                   	ret    

000001cb <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1cb:	f3 0f 1e fb          	endbr32 
     1cf:	55                   	push   %ebp
     1d0:	89 e5                	mov    %esp,%ebp
     1d2:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1d5:	68 0c 3d 00 00       	push   $0x3d0c
     1da:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     1e0:	e8 7d 37 00 00       	call   3962 <printf>
  if(mkdir("oidir") < 0){
     1e5:	c7 04 24 1b 3d 00 00 	movl   $0x3d1b,(%esp)
     1ec:	e8 95 36 00 00       	call   3886 <mkdir>
     1f1:	83 c4 10             	add    $0x10,%esp
     1f4:	85 c0                	test   %eax,%eax
     1f6:	78 39                	js     231 <openiputtest+0x66>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1f8:	e8 19 36 00 00       	call   3816 <fork>
  if(pid < 0){
     1fd:	85 c0                	test   %eax,%eax
     1ff:	78 48                	js     249 <openiputtest+0x7e>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     201:	75 63                	jne    266 <openiputtest+0x9b>
    int fd = open("oidir", O_RDWR);
     203:	83 ec 08             	sub    $0x8,%esp
     206:	6a 02                	push   $0x2
     208:	68 1b 3d 00 00       	push   $0x3d1b
     20d:	e8 4c 36 00 00       	call   385e <open>
    if(fd >= 0){
     212:	83 c4 10             	add    $0x10,%esp
     215:	85 c0                	test   %eax,%eax
     217:	78 48                	js     261 <openiputtest+0x96>
      printf(stdout, "open directory for write succeeded\n");
     219:	83 ec 08             	sub    $0x8,%esp
     21c:	68 a0 4c 00 00       	push   $0x4ca0
     221:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     227:	e8 36 37 00 00       	call   3962 <printf>
      exit();
     22c:	e8 ed 35 00 00       	call   381e <exit>
    printf(stdout, "mkdir oidir failed\n");
     231:	83 ec 08             	sub    $0x8,%esp
     234:	68 21 3d 00 00       	push   $0x3d21
     239:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     23f:	e8 1e 37 00 00       	call   3962 <printf>
    exit();
     244:	e8 d5 35 00 00       	call   381e <exit>
    printf(stdout, "fork failed\n");
     249:	83 ec 08             	sub    $0x8,%esp
     24c:	68 bd 4b 00 00       	push   $0x4bbd
     251:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     257:	e8 06 37 00 00       	call   3962 <printf>
    exit();
     25c:	e8 bd 35 00 00       	call   381e <exit>
    }
    exit();
     261:	e8 b8 35 00 00       	call   381e <exit>
  }
  sleep(1);
     266:	83 ec 0c             	sub    $0xc,%esp
     269:	6a 01                	push   $0x1
     26b:	e8 3e 36 00 00       	call   38ae <sleep>
  if(unlink("oidir") != 0){
     270:	c7 04 24 1b 3d 00 00 	movl   $0x3d1b,(%esp)
     277:	e8 f2 35 00 00       	call   386e <unlink>
     27c:	83 c4 10             	add    $0x10,%esp
     27f:	85 c0                	test   %eax,%eax
     281:	75 1d                	jne    2a0 <openiputtest+0xd5>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     283:	e8 9e 35 00 00       	call   3826 <wait>
  printf(stdout, "openiput test ok\n");
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 44 3d 00 00       	push   $0x3d44
     290:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     296:	e8 c7 36 00 00       	call   3962 <printf>
}
     29b:	83 c4 10             	add    $0x10,%esp
     29e:	c9                   	leave  
     29f:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     2a0:	83 ec 08             	sub    $0x8,%esp
     2a3:	68 35 3d 00 00       	push   $0x3d35
     2a8:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     2ae:	e8 af 36 00 00       	call   3962 <printf>
    exit();
     2b3:	e8 66 35 00 00       	call   381e <exit>

000002b8 <opentest>:

// simple file system tests

void
opentest(void)
{
     2b8:	f3 0f 1e fb          	endbr32 
     2bc:	55                   	push   %ebp
     2bd:	89 e5                	mov    %esp,%ebp
     2bf:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2c2:	68 56 3d 00 00       	push   $0x3d56
     2c7:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     2cd:	e8 90 36 00 00       	call   3962 <printf>
  fd = open("echo", 0);
     2d2:	83 c4 08             	add    $0x8,%esp
     2d5:	6a 00                	push   $0x0
     2d7:	68 61 3d 00 00       	push   $0x3d61
     2dc:	e8 7d 35 00 00       	call   385e <open>
  if(fd < 0){
     2e1:	83 c4 10             	add    $0x10,%esp
     2e4:	85 c0                	test   %eax,%eax
     2e6:	78 37                	js     31f <opentest+0x67>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2e8:	83 ec 0c             	sub    $0xc,%esp
     2eb:	50                   	push   %eax
     2ec:	e8 55 35 00 00       	call   3846 <close>
  fd = open("doesnotexist", 0);
     2f1:	83 c4 08             	add    $0x8,%esp
     2f4:	6a 00                	push   $0x0
     2f6:	68 79 3d 00 00       	push   $0x3d79
     2fb:	e8 5e 35 00 00       	call   385e <open>
  if(fd >= 0){
     300:	83 c4 10             	add    $0x10,%esp
     303:	85 c0                	test   %eax,%eax
     305:	79 30                	jns    337 <opentest+0x7f>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     307:	83 ec 08             	sub    $0x8,%esp
     30a:	68 a4 3d 00 00       	push   $0x3da4
     30f:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     315:	e8 48 36 00 00       	call   3962 <printf>
}
     31a:	83 c4 10             	add    $0x10,%esp
     31d:	c9                   	leave  
     31e:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     31f:	83 ec 08             	sub    $0x8,%esp
     322:	68 66 3d 00 00       	push   $0x3d66
     327:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     32d:	e8 30 36 00 00       	call   3962 <printf>
    exit();
     332:	e8 e7 34 00 00       	call   381e <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     337:	83 ec 08             	sub    $0x8,%esp
     33a:	68 86 3d 00 00       	push   $0x3d86
     33f:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     345:	e8 18 36 00 00       	call   3962 <printf>
    exit();
     34a:	e8 cf 34 00 00       	call   381e <exit>

0000034f <writetest>:

void
writetest(void)
{
     34f:	f3 0f 1e fb          	endbr32 
     353:	55                   	push   %ebp
     354:	89 e5                	mov    %esp,%ebp
     356:	56                   	push   %esi
     357:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     358:	83 ec 08             	sub    $0x8,%esp
     35b:	68 b2 3d 00 00       	push   $0x3db2
     360:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     366:	e8 f7 35 00 00       	call   3962 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     36b:	83 c4 08             	add    $0x8,%esp
     36e:	68 02 02 00 00       	push   $0x202
     373:	68 c3 3d 00 00       	push   $0x3dc3
     378:	e8 e1 34 00 00       	call   385e <open>
  if(fd >= 0){
     37d:	83 c4 10             	add    $0x10,%esp
     380:	85 c0                	test   %eax,%eax
     382:	0f 88 17 01 00 00    	js     49f <writetest+0x150>
     388:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     38a:	83 ec 08             	sub    $0x8,%esp
     38d:	68 c9 3d 00 00       	push   $0x3dc9
     392:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     398:	e8 c5 35 00 00       	call   3962 <printf>
     39d:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3a0:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3a5:	83 ec 04             	sub    $0x4,%esp
     3a8:	6a 0a                	push   $0xa
     3aa:	68 00 3e 00 00       	push   $0x3e00
     3af:	56                   	push   %esi
     3b0:	e8 89 34 00 00       	call   383e <write>
     3b5:	83 c4 10             	add    $0x10,%esp
     3b8:	83 f8 0a             	cmp    $0xa,%eax
     3bb:	0f 85 f6 00 00 00    	jne    4b7 <writetest+0x168>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3c1:	83 ec 04             	sub    $0x4,%esp
     3c4:	6a 0a                	push   $0xa
     3c6:	68 0b 3e 00 00       	push   $0x3e0b
     3cb:	56                   	push   %esi
     3cc:	e8 6d 34 00 00       	call   383e <write>
     3d1:	83 c4 10             	add    $0x10,%esp
     3d4:	83 f8 0a             	cmp    $0xa,%eax
     3d7:	0f 85 f3 00 00 00    	jne    4d0 <writetest+0x181>
  for(i = 0; i < 100; i++){
     3dd:	83 c3 01             	add    $0x1,%ebx
     3e0:	83 fb 64             	cmp    $0x64,%ebx
     3e3:	75 c0                	jne    3a5 <writetest+0x56>
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     3e5:	83 ec 08             	sub    $0x8,%esp
     3e8:	68 16 3e 00 00       	push   $0x3e16
     3ed:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     3f3:	e8 6a 35 00 00       	call   3962 <printf>
  close(fd);
     3f8:	89 34 24             	mov    %esi,(%esp)
     3fb:	e8 46 34 00 00       	call   3846 <close>
  fd = open("small", O_RDONLY);
     400:	83 c4 08             	add    $0x8,%esp
     403:	6a 00                	push   $0x0
     405:	68 c3 3d 00 00       	push   $0x3dc3
     40a:	e8 4f 34 00 00       	call   385e <open>
     40f:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     411:	83 c4 10             	add    $0x10,%esp
     414:	85 c0                	test   %eax,%eax
     416:	0f 88 cd 00 00 00    	js     4e9 <writetest+0x19a>
    printf(stdout, "open small succeeded ok\n");
     41c:	83 ec 08             	sub    $0x8,%esp
     41f:	68 21 3e 00 00       	push   $0x3e21
     424:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     42a:	e8 33 35 00 00       	call   3962 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     42f:	83 c4 0c             	add    $0xc,%esp
     432:	68 d0 07 00 00       	push   $0x7d0
     437:	68 80 84 00 00       	push   $0x8480
     43c:	53                   	push   %ebx
     43d:	e8 f4 33 00 00       	call   3836 <read>
  if(i == 2000){
     442:	83 c4 10             	add    $0x10,%esp
     445:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     44a:	0f 85 b1 00 00 00    	jne    501 <writetest+0x1b2>
    printf(stdout, "read succeeded ok\n");
     450:	83 ec 08             	sub    $0x8,%esp
     453:	68 55 3e 00 00       	push   $0x3e55
     458:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     45e:	e8 ff 34 00 00       	call   3962 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     463:	89 1c 24             	mov    %ebx,(%esp)
     466:	e8 db 33 00 00       	call   3846 <close>

  if(unlink("small") < 0){
     46b:	c7 04 24 c3 3d 00 00 	movl   $0x3dc3,(%esp)
     472:	e8 f7 33 00 00       	call   386e <unlink>
     477:	83 c4 10             	add    $0x10,%esp
     47a:	85 c0                	test   %eax,%eax
     47c:	0f 88 97 00 00 00    	js     519 <writetest+0x1ca>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     482:	83 ec 08             	sub    $0x8,%esp
     485:	68 7d 3e 00 00       	push   $0x3e7d
     48a:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     490:	e8 cd 34 00 00       	call   3962 <printf>
}
     495:	83 c4 10             	add    $0x10,%esp
     498:	8d 65 f8             	lea    -0x8(%ebp),%esp
     49b:	5b                   	pop    %ebx
     49c:	5e                   	pop    %esi
     49d:	5d                   	pop    %ebp
     49e:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
     49f:	83 ec 08             	sub    $0x8,%esp
     4a2:	68 e4 3d 00 00       	push   $0x3de4
     4a7:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     4ad:	e8 b0 34 00 00       	call   3962 <printf>
    exit();
     4b2:	e8 67 33 00 00       	call   381e <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     4b7:	83 ec 04             	sub    $0x4,%esp
     4ba:	53                   	push   %ebx
     4bb:	68 c4 4c 00 00       	push   $0x4cc4
     4c0:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     4c6:	e8 97 34 00 00       	call   3962 <printf>
      exit();
     4cb:	e8 4e 33 00 00       	call   381e <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     4d0:	83 ec 04             	sub    $0x4,%esp
     4d3:	53                   	push   %ebx
     4d4:	68 e8 4c 00 00       	push   $0x4ce8
     4d9:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     4df:	e8 7e 34 00 00       	call   3962 <printf>
      exit();
     4e4:	e8 35 33 00 00       	call   381e <exit>
    printf(stdout, "error: open small failed!\n");
     4e9:	83 ec 08             	sub    $0x8,%esp
     4ec:	68 3a 3e 00 00       	push   $0x3e3a
     4f1:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     4f7:	e8 66 34 00 00       	call   3962 <printf>
    exit();
     4fc:	e8 1d 33 00 00       	call   381e <exit>
    printf(stdout, "read failed\n");
     501:	83 ec 08             	sub    $0x8,%esp
     504:	68 81 41 00 00       	push   $0x4181
     509:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     50f:	e8 4e 34 00 00       	call   3962 <printf>
    exit();
     514:	e8 05 33 00 00       	call   381e <exit>
    printf(stdout, "unlink small failed\n");
     519:	83 ec 08             	sub    $0x8,%esp
     51c:	68 68 3e 00 00       	push   $0x3e68
     521:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     527:	e8 36 34 00 00       	call   3962 <printf>
    exit();
     52c:	e8 ed 32 00 00       	call   381e <exit>

00000531 <writetest1>:

void
writetest1(void)
{
     531:	f3 0f 1e fb          	endbr32 
     535:	55                   	push   %ebp
     536:	89 e5                	mov    %esp,%ebp
     538:	56                   	push   %esi
     539:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 91 3e 00 00       	push   $0x3e91
     542:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     548:	e8 15 34 00 00       	call   3962 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     54d:	83 c4 08             	add    $0x8,%esp
     550:	68 02 02 00 00       	push   $0x202
     555:	68 0b 3f 00 00       	push   $0x3f0b
     55a:	e8 ff 32 00 00       	call   385e <open>
  if(fd < 0){
     55f:	83 c4 10             	add    $0x10,%esp
     562:	85 c0                	test   %eax,%eax
     564:	0f 88 96 00 00 00    	js     600 <writetest1+0xcf>
     56a:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     56c:	bb 00 00 00 00       	mov    $0x0,%ebx
    ((int*)buf)[0] = i;
     571:	89 1d 80 84 00 00    	mov    %ebx,0x8480
    if(write(fd, buf, 512) != 512){
     577:	83 ec 04             	sub    $0x4,%esp
     57a:	68 00 02 00 00       	push   $0x200
     57f:	68 80 84 00 00       	push   $0x8480
     584:	56                   	push   %esi
     585:	e8 b4 32 00 00       	call   383e <write>
     58a:	83 c4 10             	add    $0x10,%esp
     58d:	3d 00 02 00 00       	cmp    $0x200,%eax
     592:	0f 85 80 00 00 00    	jne    618 <writetest1+0xe7>
  for(i = 0; i < MAXFILE; i++){
     598:	83 c3 01             	add    $0x1,%ebx
     59b:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     5a1:	75 ce                	jne    571 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     5a3:	83 ec 0c             	sub    $0xc,%esp
     5a6:	56                   	push   %esi
     5a7:	e8 9a 32 00 00       	call   3846 <close>

  fd = open("big", O_RDONLY);
     5ac:	83 c4 08             	add    $0x8,%esp
     5af:	6a 00                	push   $0x0
     5b1:	68 0b 3f 00 00       	push   $0x3f0b
     5b6:	e8 a3 32 00 00       	call   385e <open>
     5bb:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5bd:	83 c4 10             	add    $0x10,%esp
     5c0:	85 c0                	test   %eax,%eax
     5c2:	78 6d                	js     631 <writetest1+0x100>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     5c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     5c9:	83 ec 04             	sub    $0x4,%esp
     5cc:	68 00 02 00 00       	push   $0x200
     5d1:	68 80 84 00 00       	push   $0x8480
     5d6:	56                   	push   %esi
     5d7:	e8 5a 32 00 00       	call   3836 <read>
    if(i == 0){
     5dc:	83 c4 10             	add    $0x10,%esp
     5df:	85 c0                	test   %eax,%eax
     5e1:	74 66                	je     649 <writetest1+0x118>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     5e3:	3d 00 02 00 00       	cmp    $0x200,%eax
     5e8:	0f 85 b9 00 00 00    	jne    6a7 <writetest1+0x176>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5ee:	a1 80 84 00 00       	mov    0x8480,%eax
     5f3:	39 d8                	cmp    %ebx,%eax
     5f5:	0f 85 c5 00 00 00    	jne    6c0 <writetest1+0x18f>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5fb:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     5fe:	eb c9                	jmp    5c9 <writetest1+0x98>
    printf(stdout, "error: creat big failed!\n");
     600:	83 ec 08             	sub    $0x8,%esp
     603:	68 a1 3e 00 00       	push   $0x3ea1
     608:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     60e:	e8 4f 33 00 00       	call   3962 <printf>
    exit();
     613:	e8 06 32 00 00       	call   381e <exit>
      printf(stdout, "error: write big file failed\n", i);
     618:	83 ec 04             	sub    $0x4,%esp
     61b:	53                   	push   %ebx
     61c:	68 bb 3e 00 00       	push   $0x3ebb
     621:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     627:	e8 36 33 00 00       	call   3962 <printf>
      exit();
     62c:	e8 ed 31 00 00       	call   381e <exit>
    printf(stdout, "error: open big failed!\n");
     631:	83 ec 08             	sub    $0x8,%esp
     634:	68 d9 3e 00 00       	push   $0x3ed9
     639:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     63f:	e8 1e 33 00 00       	call   3962 <printf>
    exit();
     644:	e8 d5 31 00 00       	call   381e <exit>
      if(n == MAXFILE - 1){
     649:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     64f:	74 39                	je     68a <writetest1+0x159>
  }
  close(fd);
     651:	83 ec 0c             	sub    $0xc,%esp
     654:	56                   	push   %esi
     655:	e8 ec 31 00 00       	call   3846 <close>
  if(unlink("big") < 0){
     65a:	c7 04 24 0b 3f 00 00 	movl   $0x3f0b,(%esp)
     661:	e8 08 32 00 00       	call   386e <unlink>
     666:	83 c4 10             	add    $0x10,%esp
     669:	85 c0                	test   %eax,%eax
     66b:	78 6a                	js     6d7 <writetest1+0x1a6>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     66d:	83 ec 08             	sub    $0x8,%esp
     670:	68 32 3f 00 00       	push   $0x3f32
     675:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     67b:	e8 e2 32 00 00       	call   3962 <printf>
}
     680:	83 c4 10             	add    $0x10,%esp
     683:	8d 65 f8             	lea    -0x8(%ebp),%esp
     686:	5b                   	pop    %ebx
     687:	5e                   	pop    %esi
     688:	5d                   	pop    %ebp
     689:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     68a:	83 ec 04             	sub    $0x4,%esp
     68d:	68 8b 00 00 00       	push   $0x8b
     692:	68 f2 3e 00 00       	push   $0x3ef2
     697:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     69d:	e8 c0 32 00 00       	call   3962 <printf>
        exit();
     6a2:	e8 77 31 00 00       	call   381e <exit>
      printf(stdout, "read failed %d\n", i);
     6a7:	83 ec 04             	sub    $0x4,%esp
     6aa:	50                   	push   %eax
     6ab:	68 0f 3f 00 00       	push   $0x3f0f
     6b0:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     6b6:	e8 a7 32 00 00       	call   3962 <printf>
      exit();
     6bb:	e8 5e 31 00 00       	call   381e <exit>
      printf(stdout, "read content of block %d is %d\n",
     6c0:	50                   	push   %eax
     6c1:	53                   	push   %ebx
     6c2:	68 0c 4d 00 00       	push   $0x4d0c
     6c7:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     6cd:	e8 90 32 00 00       	call   3962 <printf>
      exit();
     6d2:	e8 47 31 00 00       	call   381e <exit>
    printf(stdout, "unlink big failed\n");
     6d7:	83 ec 08             	sub    $0x8,%esp
     6da:	68 1f 3f 00 00       	push   $0x3f1f
     6df:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     6e5:	e8 78 32 00 00       	call   3962 <printf>
    exit();
     6ea:	e8 2f 31 00 00       	call   381e <exit>

000006ef <createtest>:

void
createtest(void)
{
     6ef:	f3 0f 1e fb          	endbr32 
     6f3:	55                   	push   %ebp
     6f4:	89 e5                	mov    %esp,%ebp
     6f6:	53                   	push   %ebx
     6f7:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6fa:	68 2c 4d 00 00       	push   $0x4d2c
     6ff:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     705:	e8 58 32 00 00       	call   3962 <printf>

  name[0] = 'a';
     70a:	c6 05 80 a4 00 00 61 	movb   $0x61,0xa480
  name[2] = '\0';
     711:	c6 05 82 a4 00 00 00 	movb   $0x0,0xa482
     718:	83 c4 10             	add    $0x10,%esp
     71b:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     720:	88 1d 81 a4 00 00    	mov    %bl,0xa481
    fd = open(name, O_CREATE|O_RDWR);
     726:	83 ec 08             	sub    $0x8,%esp
     729:	68 02 02 00 00       	push   $0x202
     72e:	68 80 a4 00 00       	push   $0xa480
     733:	e8 26 31 00 00       	call   385e <open>
    close(fd);
     738:	89 04 24             	mov    %eax,(%esp)
     73b:	e8 06 31 00 00       	call   3846 <close>
  for(i = 0; i < 52; i++){
     740:	83 c3 01             	add    $0x1,%ebx
     743:	83 c4 10             	add    $0x10,%esp
     746:	80 fb 64             	cmp    $0x64,%bl
     749:	75 d5                	jne    720 <createtest+0x31>
  }
  name[0] = 'a';
     74b:	c6 05 80 a4 00 00 61 	movb   $0x61,0xa480
  name[2] = '\0';
     752:	c6 05 82 a4 00 00 00 	movb   $0x0,0xa482
     759:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     75e:	88 1d 81 a4 00 00    	mov    %bl,0xa481
    unlink(name);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	68 80 a4 00 00       	push   $0xa480
     76c:	e8 fd 30 00 00       	call   386e <unlink>
  for(i = 0; i < 52; i++){
     771:	83 c3 01             	add    $0x1,%ebx
     774:	83 c4 10             	add    $0x10,%esp
     777:	80 fb 64             	cmp    $0x64,%bl
     77a:	75 e2                	jne    75e <createtest+0x6f>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     77c:	83 ec 08             	sub    $0x8,%esp
     77f:	68 54 4d 00 00       	push   $0x4d54
     784:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     78a:	e8 d3 31 00 00       	call   3962 <printf>
}
     78f:	83 c4 10             	add    $0x10,%esp
     792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     795:	c9                   	leave  
     796:	c3                   	ret    

00000797 <dirtest>:

void dirtest(void)
{
     797:	f3 0f 1e fb          	endbr32 
     79b:	55                   	push   %ebp
     79c:	89 e5                	mov    %esp,%ebp
     79e:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     7a1:	68 40 3f 00 00       	push   $0x3f40
     7a6:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     7ac:	e8 b1 31 00 00       	call   3962 <printf>

  if(mkdir("dir0") < 0){
     7b1:	c7 04 24 4c 3f 00 00 	movl   $0x3f4c,(%esp)
     7b8:	e8 c9 30 00 00       	call   3886 <mkdir>
     7bd:	83 c4 10             	add    $0x10,%esp
     7c0:	85 c0                	test   %eax,%eax
     7c2:	78 54                	js     818 <dirtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7c4:	83 ec 0c             	sub    $0xc,%esp
     7c7:	68 4c 3f 00 00       	push   $0x3f4c
     7cc:	e8 bd 30 00 00       	call   388e <chdir>
     7d1:	83 c4 10             	add    $0x10,%esp
     7d4:	85 c0                	test   %eax,%eax
     7d6:	78 58                	js     830 <dirtest+0x99>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7d8:	83 ec 0c             	sub    $0xc,%esp
     7db:	68 f1 44 00 00       	push   $0x44f1
     7e0:	e8 a9 30 00 00       	call   388e <chdir>
     7e5:	83 c4 10             	add    $0x10,%esp
     7e8:	85 c0                	test   %eax,%eax
     7ea:	78 5c                	js     848 <dirtest+0xb1>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7ec:	83 ec 0c             	sub    $0xc,%esp
     7ef:	68 4c 3f 00 00       	push   $0x3f4c
     7f4:	e8 75 30 00 00       	call   386e <unlink>
     7f9:	83 c4 10             	add    $0x10,%esp
     7fc:	85 c0                	test   %eax,%eax
     7fe:	78 60                	js     860 <dirtest+0xc9>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     800:	83 ec 08             	sub    $0x8,%esp
     803:	68 89 3f 00 00       	push   $0x3f89
     808:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     80e:	e8 4f 31 00 00       	call   3962 <printf>
}
     813:	83 c4 10             	add    $0x10,%esp
     816:	c9                   	leave  
     817:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     818:	83 ec 08             	sub    $0x8,%esp
     81b:	68 7c 3c 00 00       	push   $0x3c7c
     820:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     826:	e8 37 31 00 00       	call   3962 <printf>
    exit();
     82b:	e8 ee 2f 00 00       	call   381e <exit>
    printf(stdout, "chdir dir0 failed\n");
     830:	83 ec 08             	sub    $0x8,%esp
     833:	68 51 3f 00 00       	push   $0x3f51
     838:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     83e:	e8 1f 31 00 00       	call   3962 <printf>
    exit();
     843:	e8 d6 2f 00 00       	call   381e <exit>
    printf(stdout, "chdir .. failed\n");
     848:	83 ec 08             	sub    $0x8,%esp
     84b:	68 64 3f 00 00       	push   $0x3f64
     850:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     856:	e8 07 31 00 00       	call   3962 <printf>
    exit();
     85b:	e8 be 2f 00 00       	call   381e <exit>
    printf(stdout, "unlink dir0 failed\n");
     860:	83 ec 08             	sub    $0x8,%esp
     863:	68 75 3f 00 00       	push   $0x3f75
     868:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     86e:	e8 ef 30 00 00       	call   3962 <printf>
    exit();
     873:	e8 a6 2f 00 00       	call   381e <exit>

00000878 <exectest>:

void
exectest(void)
{
     878:	f3 0f 1e fb          	endbr32 
     87c:	55                   	push   %ebp
     87d:	89 e5                	mov    %esp,%ebp
     87f:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     882:	68 98 3f 00 00       	push   $0x3f98
     887:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     88d:	e8 d0 30 00 00       	call   3962 <printf>
  if(exec("echo", echoargv) < 0){
     892:	83 c4 08             	add    $0x8,%esp
     895:	68 90 5c 00 00       	push   $0x5c90
     89a:	68 61 3d 00 00       	push   $0x3d61
     89f:	e8 b2 2f 00 00       	call   3856 <exec>
     8a4:	83 c4 10             	add    $0x10,%esp
     8a7:	85 c0                	test   %eax,%eax
     8a9:	78 02                	js     8ad <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     8ab:	c9                   	leave  
     8ac:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     8ad:	83 ec 08             	sub    $0x8,%esp
     8b0:	68 a3 3f 00 00       	push   $0x3fa3
     8b5:	ff 35 8c 5c 00 00    	pushl  0x5c8c
     8bb:	e8 a2 30 00 00       	call   3962 <printf>
    exit();
     8c0:	e8 59 2f 00 00       	call   381e <exit>

000008c5 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8c5:	f3 0f 1e fb          	endbr32 
     8c9:	55                   	push   %ebp
     8ca:	89 e5                	mov    %esp,%ebp
     8cc:	57                   	push   %edi
     8cd:	56                   	push   %esi
     8ce:	53                   	push   %ebx
     8cf:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     8d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
     8d5:	50                   	push   %eax
     8d6:	e8 53 2f 00 00       	call   382e <pipe>
     8db:	83 c4 10             	add    $0x10,%esp
     8de:	85 c0                	test   %eax,%eax
     8e0:	0f 85 8c 00 00 00    	jne    972 <pipe1+0xad>
     8e6:	89 c3                	mov    %eax,%ebx
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     8e8:	e8 29 2f 00 00       	call   3816 <fork>
     8ed:	89 c6                	mov    %eax,%esi
  seq = 0;
  if(pid == 0){
     8ef:	85 c0                	test   %eax,%eax
     8f1:	0f 84 8f 00 00 00    	je     986 <pipe1+0xc1>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8f7:	0f 8e 4f 01 00 00    	jle    a4c <pipe1+0x187>
    close(fds[1]);
     8fd:	83 ec 0c             	sub    $0xc,%esp
     900:	ff 75 e4             	pushl  -0x1c(%ebp)
     903:	e8 3e 2f 00 00       	call   3846 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     908:	83 c4 10             	add    $0x10,%esp
    total = 0;
     90b:	89 df                	mov    %ebx,%edi
    cc = 1;
     90d:	be 01 00 00 00       	mov    $0x1,%esi
    while((n = read(fds[0], buf, cc)) > 0){
     912:	83 ec 04             	sub    $0x4,%esp
     915:	56                   	push   %esi
     916:	68 80 84 00 00       	push   $0x8480
     91b:	ff 75 e0             	pushl  -0x20(%ebp)
     91e:	e8 13 2f 00 00       	call   3836 <read>
     923:	89 c2                	mov    %eax,%edx
     925:	83 c4 10             	add    $0x10,%esp
     928:	85 c0                	test   %eax,%eax
     92a:	0f 8e d8 00 00 00    	jle    a08 <pipe1+0x143>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     930:	89 d8                	mov    %ebx,%eax
     932:	32 05 80 84 00 00    	xor    0x8480,%al
     938:	0f b6 c0             	movzbl %al,%eax
     93b:	85 c0                	test   %eax,%eax
     93d:	75 19                	jne    958 <pipe1+0x93>
     93f:	8d 4b 01             	lea    0x1(%ebx),%ecx
     942:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
      for(i = 0; i < n; i++){
     945:	83 c0 01             	add    $0x1,%eax
     948:	39 c2                	cmp    %eax,%edx
     94a:	0f 84 a1 00 00 00    	je     9f1 <pipe1+0x12c>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     950:	38 98 80 84 00 00    	cmp    %bl,0x8480(%eax)
     956:	74 ea                	je     942 <pipe1+0x7d>
          printf(1, "pipe1 oops 2\n");
     958:	83 ec 08             	sub    $0x8,%esp
     95b:	68 d2 3f 00 00       	push   $0x3fd2
     960:	6a 01                	push   $0x1
     962:	e8 fb 2f 00 00       	call   3962 <printf>
          return;
     967:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     96a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     96d:	5b                   	pop    %ebx
     96e:	5e                   	pop    %esi
     96f:	5f                   	pop    %edi
     970:	5d                   	pop    %ebp
     971:	c3                   	ret    
    printf(1, "pipe() failed\n");
     972:	83 ec 08             	sub    $0x8,%esp
     975:	68 b5 3f 00 00       	push   $0x3fb5
     97a:	6a 01                	push   $0x1
     97c:	e8 e1 2f 00 00       	call   3962 <printf>
    exit();
     981:	e8 98 2e 00 00       	call   381e <exit>
    close(fds[0]);
     986:	83 ec 0c             	sub    $0xc,%esp
     989:	ff 75 e0             	pushl  -0x20(%ebp)
     98c:	e8 b5 2e 00 00       	call   3846 <close>
     991:	83 c4 10             	add    $0x10,%esp
  seq = 0;
     994:	89 f3                	mov    %esi,%ebx
      for(i = 0; i < 1033; i++)
     996:	89 f0                	mov    %esi,%eax
        buf[i] = seq++;
     998:	8d 14 03             	lea    (%ebx,%eax,1),%edx
     99b:	88 90 80 84 00 00    	mov    %dl,0x8480(%eax)
      for(i = 0; i < 1033; i++)
     9a1:	83 c0 01             	add    $0x1,%eax
     9a4:	3d 09 04 00 00       	cmp    $0x409,%eax
     9a9:	75 ed                	jne    998 <pipe1+0xd3>
     9ab:	81 c3 09 04 00 00    	add    $0x409,%ebx
      if(write(fds[1], buf, 1033) != 1033){
     9b1:	83 ec 04             	sub    $0x4,%esp
     9b4:	68 09 04 00 00       	push   $0x409
     9b9:	68 80 84 00 00       	push   $0x8480
     9be:	ff 75 e4             	pushl  -0x1c(%ebp)
     9c1:	e8 78 2e 00 00       	call   383e <write>
     9c6:	83 c4 10             	add    $0x10,%esp
     9c9:	3d 09 04 00 00       	cmp    $0x409,%eax
     9ce:	75 0d                	jne    9dd <pipe1+0x118>
    for(n = 0; n < 5; n++){
     9d0:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     9d6:	75 be                	jne    996 <pipe1+0xd1>
    exit();
     9d8:	e8 41 2e 00 00       	call   381e <exit>
        printf(1, "pipe1 oops 1\n");
     9dd:	83 ec 08             	sub    $0x8,%esp
     9e0:	68 c4 3f 00 00       	push   $0x3fc4
     9e5:	6a 01                	push   $0x1
     9e7:	e8 76 2f 00 00       	call   3962 <printf>
        exit();
     9ec:	e8 2d 2e 00 00       	call   381e <exit>
      total += n;
     9f1:	01 c7                	add    %eax,%edi
      cc = cc * 2;
     9f3:	01 f6                	add    %esi,%esi
        cc = sizeof(buf);
     9f5:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
     9fb:	b8 00 20 00 00       	mov    $0x2000,%eax
     a00:	0f 43 f0             	cmovae %eax,%esi
     a03:	e9 0a ff ff ff       	jmp    912 <pipe1+0x4d>
    if(total != 5 * 1033){
     a08:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
     a0e:	75 27                	jne    a37 <pipe1+0x172>
    close(fds[0]);
     a10:	83 ec 0c             	sub    $0xc,%esp
     a13:	ff 75 e0             	pushl  -0x20(%ebp)
     a16:	e8 2b 2e 00 00       	call   3846 <close>
    wait();
     a1b:	e8 06 2e 00 00       	call   3826 <wait>
  printf(1, "pipe1 ok\n");
     a20:	83 c4 08             	add    $0x8,%esp
     a23:	68 f7 3f 00 00       	push   $0x3ff7
     a28:	6a 01                	push   $0x1
     a2a:	e8 33 2f 00 00       	call   3962 <printf>
     a2f:	83 c4 10             	add    $0x10,%esp
     a32:	e9 33 ff ff ff       	jmp    96a <pipe1+0xa5>
      printf(1, "pipe1 oops 3 total %d\n", total);
     a37:	83 ec 04             	sub    $0x4,%esp
     a3a:	57                   	push   %edi
     a3b:	68 e0 3f 00 00       	push   $0x3fe0
     a40:	6a 01                	push   $0x1
     a42:	e8 1b 2f 00 00       	call   3962 <printf>
      exit();
     a47:	e8 d2 2d 00 00       	call   381e <exit>
    printf(1, "fork() failed\n");
     a4c:	83 ec 08             	sub    $0x8,%esp
     a4f:	68 01 40 00 00       	push   $0x4001
     a54:	6a 01                	push   $0x1
     a56:	e8 07 2f 00 00       	call   3962 <printf>
    exit();
     a5b:	e8 be 2d 00 00       	call   381e <exit>

00000a60 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a60:	f3 0f 1e fb          	endbr32 
     a64:	55                   	push   %ebp
     a65:	89 e5                	mov    %esp,%ebp
     a67:	57                   	push   %edi
     a68:	56                   	push   %esi
     a69:	53                   	push   %ebx
     a6a:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a6d:	68 10 40 00 00       	push   $0x4010
     a72:	6a 01                	push   $0x1
     a74:	e8 e9 2e 00 00       	call   3962 <printf>
  pid1 = fork();
     a79:	e8 98 2d 00 00       	call   3816 <fork>
  if(pid1 == 0)
     a7e:	83 c4 10             	add    $0x10,%esp
     a81:	85 c0                	test   %eax,%eax
     a83:	75 02                	jne    a87 <preempt+0x27>
    for(;;)
     a85:	eb fe                	jmp    a85 <preempt+0x25>
     a87:	89 c7                	mov    %eax,%edi
      ;

  pid2 = fork();
     a89:	e8 88 2d 00 00       	call   3816 <fork>
     a8e:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a90:	85 c0                	test   %eax,%eax
     a92:	75 02                	jne    a96 <preempt+0x36>
    for(;;)
     a94:	eb fe                	jmp    a94 <preempt+0x34>
      ;

  pipe(pfds);
     a96:	83 ec 0c             	sub    $0xc,%esp
     a99:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a9c:	50                   	push   %eax
     a9d:	e8 8c 2d 00 00       	call   382e <pipe>
  pid3 = fork();
     aa2:	e8 6f 2d 00 00       	call   3816 <fork>
     aa7:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     aa9:	83 c4 10             	add    $0x10,%esp
     aac:	85 c0                	test   %eax,%eax
     aae:	75 49                	jne    af9 <preempt+0x99>
    close(pfds[0]);
     ab0:	83 ec 0c             	sub    $0xc,%esp
     ab3:	ff 75 e0             	pushl  -0x20(%ebp)
     ab6:	e8 8b 2d 00 00       	call   3846 <close>
    if(write(pfds[1], "x", 1) != 1)
     abb:	83 c4 0c             	add    $0xc,%esp
     abe:	6a 01                	push   $0x1
     ac0:	68 d5 45 00 00       	push   $0x45d5
     ac5:	ff 75 e4             	pushl  -0x1c(%ebp)
     ac8:	e8 71 2d 00 00       	call   383e <write>
     acd:	83 c4 10             	add    $0x10,%esp
     ad0:	83 f8 01             	cmp    $0x1,%eax
     ad3:	75 10                	jne    ae5 <preempt+0x85>
      printf(1, "preempt write error");
    close(pfds[1]);
     ad5:	83 ec 0c             	sub    $0xc,%esp
     ad8:	ff 75 e4             	pushl  -0x1c(%ebp)
     adb:	e8 66 2d 00 00       	call   3846 <close>
     ae0:	83 c4 10             	add    $0x10,%esp
    for(;;)
     ae3:	eb fe                	jmp    ae3 <preempt+0x83>
      printf(1, "preempt write error");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 1a 40 00 00       	push   $0x401a
     aed:	6a 01                	push   $0x1
     aef:	e8 6e 2e 00 00       	call   3962 <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	eb dc                	jmp    ad5 <preempt+0x75>
      ;
  }

  close(pfds[1]);
     af9:	83 ec 0c             	sub    $0xc,%esp
     afc:	ff 75 e4             	pushl  -0x1c(%ebp)
     aff:	e8 42 2d 00 00       	call   3846 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     b04:	83 c4 0c             	add    $0xc,%esp
     b07:	68 00 20 00 00       	push   $0x2000
     b0c:	68 80 84 00 00       	push   $0x8480
     b11:	ff 75 e0             	pushl  -0x20(%ebp)
     b14:	e8 1d 2d 00 00       	call   3836 <read>
     b19:	83 c4 10             	add    $0x10,%esp
     b1c:	83 f8 01             	cmp    $0x1,%eax
     b1f:	74 1a                	je     b3b <preempt+0xdb>
    printf(1, "preempt read error");
     b21:	83 ec 08             	sub    $0x8,%esp
     b24:	68 2e 40 00 00       	push   $0x402e
     b29:	6a 01                	push   $0x1
     b2b:	e8 32 2e 00 00       	call   3962 <printf>
    return;
     b30:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b36:	5b                   	pop    %ebx
     b37:	5e                   	pop    %esi
     b38:	5f                   	pop    %edi
     b39:	5d                   	pop    %ebp
     b3a:	c3                   	ret    
  close(pfds[0]);
     b3b:	83 ec 0c             	sub    $0xc,%esp
     b3e:	ff 75 e0             	pushl  -0x20(%ebp)
     b41:	e8 00 2d 00 00       	call   3846 <close>
  printf(1, "kill... ");
     b46:	83 c4 08             	add    $0x8,%esp
     b49:	68 41 40 00 00       	push   $0x4041
     b4e:	6a 01                	push   $0x1
     b50:	e8 0d 2e 00 00       	call   3962 <printf>
  kill(pid1);
     b55:	89 3c 24             	mov    %edi,(%esp)
     b58:	e8 f1 2c 00 00       	call   384e <kill>
  kill(pid2);
     b5d:	89 34 24             	mov    %esi,(%esp)
     b60:	e8 e9 2c 00 00       	call   384e <kill>
  kill(pid3);
     b65:	89 1c 24             	mov    %ebx,(%esp)
     b68:	e8 e1 2c 00 00       	call   384e <kill>
  printf(1, "wait... ");
     b6d:	83 c4 08             	add    $0x8,%esp
     b70:	68 4a 40 00 00       	push   $0x404a
     b75:	6a 01                	push   $0x1
     b77:	e8 e6 2d 00 00       	call   3962 <printf>
  wait();
     b7c:	e8 a5 2c 00 00       	call   3826 <wait>
  wait();
     b81:	e8 a0 2c 00 00       	call   3826 <wait>
  wait();
     b86:	e8 9b 2c 00 00       	call   3826 <wait>
  printf(1, "preempt ok\n");
     b8b:	83 c4 08             	add    $0x8,%esp
     b8e:	68 53 40 00 00       	push   $0x4053
     b93:	6a 01                	push   $0x1
     b95:	e8 c8 2d 00 00       	call   3962 <printf>
     b9a:	83 c4 10             	add    $0x10,%esp
     b9d:	eb 94                	jmp    b33 <preempt+0xd3>

00000b9f <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b9f:	f3 0f 1e fb          	endbr32 
     ba3:	55                   	push   %ebp
     ba4:	89 e5                	mov    %esp,%ebp
     ba6:	56                   	push   %esi
     ba7:	53                   	push   %ebx
     ba8:	be 64 00 00 00       	mov    $0x64,%esi
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     bad:	e8 64 2c 00 00       	call   3816 <fork>
     bb2:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     bb4:	85 c0                	test   %eax,%eax
     bb6:	78 24                	js     bdc <exitwait+0x3d>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     bb8:	74 4f                	je     c09 <exitwait+0x6a>
      if(wait() != pid){
     bba:	e8 67 2c 00 00       	call   3826 <wait>
     bbf:	39 d8                	cmp    %ebx,%eax
     bc1:	75 32                	jne    bf5 <exitwait+0x56>
  for(i = 0; i < 100; i++){
     bc3:	83 ee 01             	sub    $0x1,%esi
     bc6:	75 e5                	jne    bad <exitwait+0xe>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     bc8:	83 ec 08             	sub    $0x8,%esp
     bcb:	68 6f 40 00 00       	push   $0x406f
     bd0:	6a 01                	push   $0x1
     bd2:	e8 8b 2d 00 00       	call   3962 <printf>
     bd7:	83 c4 10             	add    $0x10,%esp
     bda:	eb 12                	jmp    bee <exitwait+0x4f>
      printf(1, "fork failed\n");
     bdc:	83 ec 08             	sub    $0x8,%esp
     bdf:	68 bd 4b 00 00       	push   $0x4bbd
     be4:	6a 01                	push   $0x1
     be6:	e8 77 2d 00 00       	call   3962 <printf>
      return;
     beb:	83 c4 10             	add    $0x10,%esp
}
     bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bf1:	5b                   	pop    %ebx
     bf2:	5e                   	pop    %esi
     bf3:	5d                   	pop    %ebp
     bf4:	c3                   	ret    
        printf(1, "wait wrong pid\n");
     bf5:	83 ec 08             	sub    $0x8,%esp
     bf8:	68 5f 40 00 00       	push   $0x405f
     bfd:	6a 01                	push   $0x1
     bff:	e8 5e 2d 00 00       	call   3962 <printf>
        return;
     c04:	83 c4 10             	add    $0x10,%esp
     c07:	eb e5                	jmp    bee <exitwait+0x4f>
      exit();
     c09:	e8 10 2c 00 00       	call   381e <exit>

00000c0e <mem>:

void
mem(void)
{
     c0e:	f3 0f 1e fb          	endbr32 
     c12:	55                   	push   %ebp
     c13:	89 e5                	mov    %esp,%ebp
     c15:	56                   	push   %esi
     c16:	53                   	push   %ebx
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     c17:	83 ec 08             	sub    $0x8,%esp
     c1a:	68 7c 40 00 00       	push   $0x407c
     c1f:	6a 01                	push   $0x1
     c21:	e8 3c 2d 00 00       	call   3962 <printf>
  ppid = getpid();
     c26:	e8 73 2c 00 00       	call   389e <getpid>
     c2b:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     c2d:	e8 e4 2b 00 00       	call   3816 <fork>
     c32:	83 c4 10             	add    $0x10,%esp
    m1 = 0;
     c35:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((pid = fork()) == 0){
     c3a:	85 c0                	test   %eax,%eax
     c3c:	75 7f                	jne    cbd <mem+0xaf>
    while((m2 = malloc(10001)) != 0){
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	68 11 27 00 00       	push   $0x2711
     c46:	e8 57 2f 00 00       	call   3ba2 <malloc>
     c4b:	83 c4 10             	add    $0x10,%esp
     c4e:	85 c0                	test   %eax,%eax
     c50:	74 06                	je     c58 <mem+0x4a>
      *(char**)m2 = m1;
     c52:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     c54:	89 c3                	mov    %eax,%ebx
     c56:	eb e6                	jmp    c3e <mem+0x30>
    }
    while(m1){
     c58:	85 db                	test   %ebx,%ebx
     c5a:	74 14                	je     c70 <mem+0x62>
      m2 = *(char**)m1;
     c5c:	89 d8                	mov    %ebx,%eax
     c5e:	8b 1b                	mov    (%ebx),%ebx
      free(m1);
     c60:	83 ec 0c             	sub    $0xc,%esp
     c63:	50                   	push   %eax
     c64:	e8 c7 2e 00 00       	call   3b30 <free>
    while(m1){
     c69:	83 c4 10             	add    $0x10,%esp
     c6c:	85 db                	test   %ebx,%ebx
     c6e:	75 ec                	jne    c5c <mem+0x4e>
      m1 = m2;
    }
    m1 = malloc(1024*20);
     c70:	83 ec 0c             	sub    $0xc,%esp
     c73:	68 00 50 00 00       	push   $0x5000
     c78:	e8 25 2f 00 00       	call   3ba2 <malloc>
    if(m1 == 0){
     c7d:	83 c4 10             	add    $0x10,%esp
     c80:	85 c0                	test   %eax,%eax
     c82:	74 1d                	je     ca1 <mem+0x93>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
     c84:	83 ec 0c             	sub    $0xc,%esp
     c87:	50                   	push   %eax
     c88:	e8 a3 2e 00 00       	call   3b30 <free>
    printf(1, "mem ok\n");
     c8d:	83 c4 08             	add    $0x8,%esp
     c90:	68 a0 40 00 00       	push   $0x40a0
     c95:	6a 01                	push   $0x1
     c97:	e8 c6 2c 00 00       	call   3962 <printf>
    exit();
     c9c:	e8 7d 2b 00 00       	call   381e <exit>
      printf(1, "couldn't allocate mem?!!\n");
     ca1:	83 ec 08             	sub    $0x8,%esp
     ca4:	68 86 40 00 00       	push   $0x4086
     ca9:	6a 01                	push   $0x1
     cab:	e8 b2 2c 00 00       	call   3962 <printf>
      kill(ppid);
     cb0:	89 34 24             	mov    %esi,(%esp)
     cb3:	e8 96 2b 00 00       	call   384e <kill>
      exit();
     cb8:	e8 61 2b 00 00       	call   381e <exit>
  } else {
    wait();
     cbd:	e8 64 2b 00 00       	call   3826 <wait>
  }
}
     cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cc5:	5b                   	pop    %ebx
     cc6:	5e                   	pop    %esi
     cc7:	5d                   	pop    %ebp
     cc8:	c3                   	ret    

00000cc9 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     cc9:	f3 0f 1e fb          	endbr32 
     ccd:	55                   	push   %ebp
     cce:	89 e5                	mov    %esp,%ebp
     cd0:	57                   	push   %edi
     cd1:	56                   	push   %esi
     cd2:	53                   	push   %ebx
     cd3:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     cd6:	68 a8 40 00 00       	push   $0x40a8
     cdb:	6a 01                	push   $0x1
     cdd:	e8 80 2c 00 00       	call   3962 <printf>

  unlink("sharedfd");
     ce2:	c7 04 24 b7 40 00 00 	movl   $0x40b7,(%esp)
     ce9:	e8 80 2b 00 00       	call   386e <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     cee:	83 c4 08             	add    $0x8,%esp
     cf1:	68 02 02 00 00       	push   $0x202
     cf6:	68 b7 40 00 00       	push   $0x40b7
     cfb:	e8 5e 2b 00 00       	call   385e <open>
  if(fd < 0){
     d00:	83 c4 10             	add    $0x10,%esp
     d03:	85 c0                	test   %eax,%eax
     d05:	78 4a                	js     d51 <sharedfd+0x88>
     d07:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     d09:	e8 08 2b 00 00       	call   3816 <fork>
     d0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     d11:	83 f8 01             	cmp    $0x1,%eax
     d14:	19 c0                	sbb    %eax,%eax
     d16:	83 e0 f3             	and    $0xfffffff3,%eax
     d19:	83 c0 70             	add    $0x70,%eax
     d1c:	83 ec 04             	sub    $0x4,%esp
     d1f:	6a 0a                	push   $0xa
     d21:	50                   	push   %eax
     d22:	8d 45 de             	lea    -0x22(%ebp),%eax
     d25:	50                   	push   %eax
     d26:	e8 8c 29 00 00       	call   36b7 <memset>
     d2b:	83 c4 10             	add    $0x10,%esp
     d2e:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     d33:	8d 7d de             	lea    -0x22(%ebp),%edi
     d36:	83 ec 04             	sub    $0x4,%esp
     d39:	6a 0a                	push   $0xa
     d3b:	57                   	push   %edi
     d3c:	56                   	push   %esi
     d3d:	e8 fc 2a 00 00       	call   383e <write>
     d42:	83 c4 10             	add    $0x10,%esp
     d45:	83 f8 0a             	cmp    $0xa,%eax
     d48:	75 1e                	jne    d68 <sharedfd+0x9f>
  for(i = 0; i < 1000; i++){
     d4a:	83 eb 01             	sub    $0x1,%ebx
     d4d:	75 e7                	jne    d36 <sharedfd+0x6d>
     d4f:	eb 29                	jmp    d7a <sharedfd+0xb1>
    printf(1, "fstests: cannot open sharedfd for writing");
     d51:	83 ec 08             	sub    $0x8,%esp
     d54:	68 7c 4d 00 00       	push   $0x4d7c
     d59:	6a 01                	push   $0x1
     d5b:	e8 02 2c 00 00       	call   3962 <printf>
    return;
     d60:	83 c4 10             	add    $0x10,%esp
     d63:	e9 dd 00 00 00       	jmp    e45 <sharedfd+0x17c>
      printf(1, "fstests: write sharedfd failed\n");
     d68:	83 ec 08             	sub    $0x8,%esp
     d6b:	68 a8 4d 00 00       	push   $0x4da8
     d70:	6a 01                	push   $0x1
     d72:	e8 eb 2b 00 00       	call   3962 <printf>
      break;
     d77:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     d7a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     d7e:	74 51                	je     dd1 <sharedfd+0x108>
    exit();
  else
    wait();
     d80:	e8 a1 2a 00 00       	call   3826 <wait>
  close(fd);
     d85:	83 ec 0c             	sub    $0xc,%esp
     d88:	56                   	push   %esi
     d89:	e8 b8 2a 00 00       	call   3846 <close>
  fd = open("sharedfd", 0);
     d8e:	83 c4 08             	add    $0x8,%esp
     d91:	6a 00                	push   $0x0
     d93:	68 b7 40 00 00       	push   $0x40b7
     d98:	e8 c1 2a 00 00       	call   385e <open>
     d9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     da0:	83 c4 10             	add    $0x10,%esp
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     da3:	bb 00 00 00 00       	mov    $0x0,%ebx
     da8:	bf 00 00 00 00       	mov    $0x0,%edi
     dad:	8d 75 e8             	lea    -0x18(%ebp),%esi
  if(fd < 0){
     db0:	85 c0                	test   %eax,%eax
     db2:	78 22                	js     dd6 <sharedfd+0x10d>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     db4:	83 ec 04             	sub    $0x4,%esp
     db7:	6a 0a                	push   $0xa
     db9:	8d 45 de             	lea    -0x22(%ebp),%eax
     dbc:	50                   	push   %eax
     dbd:	ff 75 d4             	pushl  -0x2c(%ebp)
     dc0:	e8 71 2a 00 00       	call   3836 <read>
     dc5:	83 c4 10             	add    $0x10,%esp
     dc8:	85 c0                	test   %eax,%eax
     dca:	7e 3d                	jle    e09 <sharedfd+0x140>
     dcc:	8d 45 de             	lea    -0x22(%ebp),%eax
     dcf:	eb 2b                	jmp    dfc <sharedfd+0x133>
    exit();
     dd1:	e8 48 2a 00 00       	call   381e <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     dd6:	83 ec 08             	sub    $0x8,%esp
     dd9:	68 c8 4d 00 00       	push   $0x4dc8
     dde:	6a 01                	push   $0x1
     de0:	e8 7d 2b 00 00       	call   3962 <printf>
    return;
     de5:	83 c4 10             	add    $0x10,%esp
     de8:	eb 5b                	jmp    e45 <sharedfd+0x17c>
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
     dea:	80 fa 70             	cmp    $0x70,%dl
     ded:	0f 94 c2             	sete   %dl
     df0:	0f b6 d2             	movzbl %dl,%edx
     df3:	01 d3                	add    %edx,%ebx
    for(i = 0; i < sizeof(buf); i++){
     df5:	83 c0 01             	add    $0x1,%eax
     df8:	39 f0                	cmp    %esi,%eax
     dfa:	74 b8                	je     db4 <sharedfd+0xeb>
      if(buf[i] == 'c')
     dfc:	0f b6 10             	movzbl (%eax),%edx
     dff:	80 fa 63             	cmp    $0x63,%dl
     e02:	75 e6                	jne    dea <sharedfd+0x121>
        nc++;
     e04:	83 c7 01             	add    $0x1,%edi
      if(buf[i] == 'p')
     e07:	eb ec                	jmp    df5 <sharedfd+0x12c>
    }
  }
  close(fd);
     e09:	83 ec 0c             	sub    $0xc,%esp
     e0c:	ff 75 d4             	pushl  -0x2c(%ebp)
     e0f:	e8 32 2a 00 00       	call   3846 <close>
  unlink("sharedfd");
     e14:	c7 04 24 b7 40 00 00 	movl   $0x40b7,(%esp)
     e1b:	e8 4e 2a 00 00       	call   386e <unlink>
  if(nc == 10000 && np == 10000){
     e20:	83 c4 10             	add    $0x10,%esp
     e23:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     e29:	75 22                	jne    e4d <sharedfd+0x184>
     e2b:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     e31:	75 1a                	jne    e4d <sharedfd+0x184>
    printf(1, "sharedfd ok\n");
     e33:	83 ec 08             	sub    $0x8,%esp
     e36:	68 c0 40 00 00       	push   $0x40c0
     e3b:	6a 01                	push   $0x1
     e3d:	e8 20 2b 00 00       	call   3962 <printf>
     e42:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e48:	5b                   	pop    %ebx
     e49:	5e                   	pop    %esi
     e4a:	5f                   	pop    %edi
     e4b:	5d                   	pop    %ebp
     e4c:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     e4d:	53                   	push   %ebx
     e4e:	57                   	push   %edi
     e4f:	68 cd 40 00 00       	push   $0x40cd
     e54:	6a 01                	push   $0x1
     e56:	e8 07 2b 00 00       	call   3962 <printf>
    exit();
     e5b:	e8 be 29 00 00       	call   381e <exit>

00000e60 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e60:	f3 0f 1e fb          	endbr32 
     e64:	55                   	push   %ebp
     e65:	89 e5                	mov    %esp,%ebp
     e67:	57                   	push   %edi
     e68:	56                   	push   %esi
     e69:	53                   	push   %ebx
     e6a:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e6d:	c7 45 d8 e2 40 00 00 	movl   $0x40e2,-0x28(%ebp)
     e74:	c7 45 dc 2b 42 00 00 	movl   $0x422b,-0x24(%ebp)
     e7b:	c7 45 e0 2f 42 00 00 	movl   $0x422f,-0x20(%ebp)
     e82:	c7 45 e4 e5 40 00 00 	movl   $0x40e5,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e89:	68 e8 40 00 00       	push   $0x40e8
     e8e:	6a 01                	push   $0x1
     e90:	e8 cd 2a 00 00       	call   3962 <printf>
     e95:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
     e98:	bb 00 00 00 00       	mov    $0x0,%ebx
    fname = names[pi];
     e9d:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
     ea1:	83 ec 0c             	sub    $0xc,%esp
     ea4:	56                   	push   %esi
     ea5:	e8 c4 29 00 00       	call   386e <unlink>

    pid = fork();
     eaa:	e8 67 29 00 00       	call   3816 <fork>
    if(pid < 0){
     eaf:	83 c4 10             	add    $0x10,%esp
     eb2:	85 c0                	test   %eax,%eax
     eb4:	78 28                	js     ede <fourfiles+0x7e>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     eb6:	74 3a                	je     ef2 <fourfiles+0x92>
  for(pi = 0; pi < 4; pi++){
     eb8:	83 c3 01             	add    $0x1,%ebx
     ebb:	83 fb 04             	cmp    $0x4,%ebx
     ebe:	75 dd                	jne    e9d <fourfiles+0x3d>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     ec0:	e8 61 29 00 00       	call   3826 <wait>
     ec5:	e8 5c 29 00 00       	call   3826 <wait>
     eca:	e8 57 29 00 00       	call   3826 <wait>
     ecf:	e8 52 29 00 00       	call   3826 <wait>
     ed4:	bb 30 00 00 00       	mov    $0x30,%ebx
     ed9:	e9 0c 01 00 00       	jmp    fea <fourfiles+0x18a>
      printf(1, "fork failed\n");
     ede:	83 ec 08             	sub    $0x8,%esp
     ee1:	68 bd 4b 00 00       	push   $0x4bbd
     ee6:	6a 01                	push   $0x1
     ee8:	e8 75 2a 00 00       	call   3962 <printf>
      exit();
     eed:	e8 2c 29 00 00       	call   381e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
     ef2:	83 ec 08             	sub    $0x8,%esp
     ef5:	68 02 02 00 00       	push   $0x202
     efa:	56                   	push   %esi
     efb:	e8 5e 29 00 00       	call   385e <open>
     f00:	89 c6                	mov    %eax,%esi
      if(fd < 0){
     f02:	83 c4 10             	add    $0x10,%esp
     f05:	85 c0                	test   %eax,%eax
     f07:	78 45                	js     f4e <fourfiles+0xee>
      memset(buf, '0'+pi, 512);
     f09:	83 ec 04             	sub    $0x4,%esp
     f0c:	68 00 02 00 00       	push   $0x200
     f11:	83 c3 30             	add    $0x30,%ebx
     f14:	53                   	push   %ebx
     f15:	68 80 84 00 00       	push   $0x8480
     f1a:	e8 98 27 00 00       	call   36b7 <memset>
     f1f:	83 c4 10             	add    $0x10,%esp
     f22:	bb 0c 00 00 00       	mov    $0xc,%ebx
        if((n = write(fd, buf, 500)) != 500){
     f27:	83 ec 04             	sub    $0x4,%esp
     f2a:	68 f4 01 00 00       	push   $0x1f4
     f2f:	68 80 84 00 00       	push   $0x8480
     f34:	56                   	push   %esi
     f35:	e8 04 29 00 00       	call   383e <write>
     f3a:	83 c4 10             	add    $0x10,%esp
     f3d:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     f42:	75 1e                	jne    f62 <fourfiles+0x102>
      for(i = 0; i < 12; i++){
     f44:	83 eb 01             	sub    $0x1,%ebx
     f47:	75 de                	jne    f27 <fourfiles+0xc7>
      exit();
     f49:	e8 d0 28 00 00       	call   381e <exit>
        printf(1, "create failed\n");
     f4e:	83 ec 08             	sub    $0x8,%esp
     f51:	68 83 43 00 00       	push   $0x4383
     f56:	6a 01                	push   $0x1
     f58:	e8 05 2a 00 00       	call   3962 <printf>
        exit();
     f5d:	e8 bc 28 00 00       	call   381e <exit>
          printf(1, "write failed %d\n", n);
     f62:	83 ec 04             	sub    $0x4,%esp
     f65:	50                   	push   %eax
     f66:	68 f8 40 00 00       	push   $0x40f8
     f6b:	6a 01                	push   $0x1
     f6d:	e8 f0 29 00 00       	call   3962 <printf>
          exit();
     f72:	e8 a7 28 00 00       	call   381e <exit>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
     f77:	83 ec 08             	sub    $0x8,%esp
     f7a:	68 09 41 00 00       	push   $0x4109
     f7f:	6a 01                	push   $0x1
     f81:	e8 dc 29 00 00       	call   3962 <printf>
          exit();
     f86:	e8 93 28 00 00       	call   381e <exit>
        }
      }
      total += n;
     f8b:	01 d6                	add    %edx,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f8d:	83 ec 04             	sub    $0x4,%esp
     f90:	68 00 20 00 00       	push   $0x2000
     f95:	68 80 84 00 00       	push   $0x8480
     f9a:	57                   	push   %edi
     f9b:	e8 96 28 00 00       	call   3836 <read>
     fa0:	83 c4 10             	add    $0x10,%esp
     fa3:	85 c0                	test   %eax,%eax
     fa5:	7e 19                	jle    fc0 <fourfiles+0x160>
      for(j = 0; j < n; j++){
     fa7:	ba 00 00 00 00       	mov    $0x0,%edx
        if(buf[j] != '0'+i){
     fac:	0f be 8a 80 84 00 00 	movsbl 0x8480(%edx),%ecx
     fb3:	39 d9                	cmp    %ebx,%ecx
     fb5:	75 c0                	jne    f77 <fourfiles+0x117>
      for(j = 0; j < n; j++){
     fb7:	83 c2 01             	add    $0x1,%edx
     fba:	39 d0                	cmp    %edx,%eax
     fbc:	75 ee                	jne    fac <fourfiles+0x14c>
     fbe:	eb cb                	jmp    f8b <fourfiles+0x12b>
    }
    close(fd);
     fc0:	83 ec 0c             	sub    $0xc,%esp
     fc3:	57                   	push   %edi
     fc4:	e8 7d 28 00 00       	call   3846 <close>
    if(total != 12*500){
     fc9:	83 c4 10             	add    $0x10,%esp
     fcc:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
     fd2:	75 37                	jne    100b <fourfiles+0x1ab>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     fd4:	83 ec 0c             	sub    $0xc,%esp
     fd7:	ff 75 d4             	pushl  -0x2c(%ebp)
     fda:	e8 8f 28 00 00       	call   386e <unlink>
  for(i = 0; i < 2; i++){
     fdf:	83 c3 01             	add    $0x1,%ebx
     fe2:	83 c4 10             	add    $0x10,%esp
     fe5:	83 fb 32             	cmp    $0x32,%ebx
     fe8:	74 36                	je     1020 <fourfiles+0x1c0>
    fname = names[i];
     fea:	8b 84 9d 18 ff ff ff 	mov    -0xe8(%ebp,%ebx,4),%eax
     ff1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
     ff4:	83 ec 08             	sub    $0x8,%esp
     ff7:	6a 00                	push   $0x0
     ff9:	50                   	push   %eax
     ffa:	e8 5f 28 00 00       	call   385e <open>
     fff:	89 c7                	mov    %eax,%edi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1001:	83 c4 10             	add    $0x10,%esp
    total = 0;
    1004:	be 00 00 00 00       	mov    $0x0,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1009:	eb 82                	jmp    f8d <fourfiles+0x12d>
      printf(1, "wrong length %d\n", total);
    100b:	83 ec 04             	sub    $0x4,%esp
    100e:	56                   	push   %esi
    100f:	68 15 41 00 00       	push   $0x4115
    1014:	6a 01                	push   $0x1
    1016:	e8 47 29 00 00       	call   3962 <printf>
      exit();
    101b:	e8 fe 27 00 00       	call   381e <exit>
  }

  printf(1, "fourfiles ok\n");
    1020:	83 ec 08             	sub    $0x8,%esp
    1023:	68 26 41 00 00       	push   $0x4126
    1028:	6a 01                	push   $0x1
    102a:	e8 33 29 00 00       	call   3962 <printf>
}
    102f:	83 c4 10             	add    $0x10,%esp
    1032:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1035:	5b                   	pop    %ebx
    1036:	5e                   	pop    %esi
    1037:	5f                   	pop    %edi
    1038:	5d                   	pop    %ebp
    1039:	c3                   	ret    

0000103a <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    103a:	f3 0f 1e fb          	endbr32 
    103e:	55                   	push   %ebp
    103f:	89 e5                	mov    %esp,%ebp
    1041:	57                   	push   %edi
    1042:	56                   	push   %esi
    1043:	53                   	push   %ebx
    1044:	83 ec 44             	sub    $0x44,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1047:	68 34 41 00 00       	push   $0x4134
    104c:	6a 01                	push   $0x1
    104e:	e8 0f 29 00 00       	call   3962 <printf>
    1053:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1056:	be 00 00 00 00       	mov    $0x0,%esi
    pid = fork();
    105b:	e8 b6 27 00 00       	call   3816 <fork>
    if(pid < 0){
    1060:	85 c0                	test   %eax,%eax
    1062:	78 38                	js     109c <createdelete+0x62>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    1064:	74 4a                	je     10b0 <createdelete+0x76>
  for(pi = 0; pi < 4; pi++){
    1066:	83 c6 01             	add    $0x1,%esi
    1069:	83 fe 04             	cmp    $0x4,%esi
    106c:	75 ed                	jne    105b <createdelete+0x21>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    106e:	e8 b3 27 00 00       	call   3826 <wait>
    1073:	e8 ae 27 00 00       	call   3826 <wait>
    1078:	e8 a9 27 00 00       	call   3826 <wait>
    107d:	e8 a4 27 00 00       	call   3826 <wait>
  }

  name[0] = name[1] = name[2] = 0;
    1082:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1086:	bf 30 00 00 00       	mov    $0x30,%edi
    108b:	c7 45 c4 ff ff ff ff 	movl   $0xffffffff,-0x3c(%ebp)
  for(i = 0; i < N; i++){
    1092:	be 00 00 00 00       	mov    $0x0,%esi
    1097:	e9 38 01 00 00       	jmp    11d4 <createdelete+0x19a>
      printf(1, "fork failed\n");
    109c:	83 ec 08             	sub    $0x8,%esp
    109f:	68 bd 4b 00 00       	push   $0x4bbd
    10a4:	6a 01                	push   $0x1
    10a6:	e8 b7 28 00 00       	call   3962 <printf>
      exit();
    10ab:	e8 6e 27 00 00       	call   381e <exit>
    10b0:	89 c3                	mov    %eax,%ebx
      name[0] = 'p' + pi;
    10b2:	8d 46 70             	lea    0x70(%esi),%eax
    10b5:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    10b8:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    10bc:	8d 75 c8             	lea    -0x38(%ebp),%esi
    10bf:	eb 1c                	jmp    10dd <createdelete+0xa3>
          printf(1, "create failed\n");
    10c1:	83 ec 08             	sub    $0x8,%esp
    10c4:	68 83 43 00 00       	push   $0x4383
    10c9:	6a 01                	push   $0x1
    10cb:	e8 92 28 00 00       	call   3962 <printf>
          exit();
    10d0:	e8 49 27 00 00       	call   381e <exit>
      for(i = 0; i < N; i++){
    10d5:	83 c3 01             	add    $0x1,%ebx
    10d8:	83 fb 14             	cmp    $0x14,%ebx
    10db:	74 63                	je     1140 <createdelete+0x106>
        name[1] = '0' + i;
    10dd:	8d 43 30             	lea    0x30(%ebx),%eax
    10e0:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    10e3:	83 ec 08             	sub    $0x8,%esp
    10e6:	68 02 02 00 00       	push   $0x202
    10eb:	56                   	push   %esi
    10ec:	e8 6d 27 00 00       	call   385e <open>
        if(fd < 0){
    10f1:	83 c4 10             	add    $0x10,%esp
    10f4:	85 c0                	test   %eax,%eax
    10f6:	78 c9                	js     10c1 <createdelete+0x87>
        close(fd);
    10f8:	83 ec 0c             	sub    $0xc,%esp
    10fb:	50                   	push   %eax
    10fc:	e8 45 27 00 00       	call   3846 <close>
        if(i > 0 && (i % 2 ) == 0){
    1101:	83 c4 10             	add    $0x10,%esp
    1104:	85 db                	test   %ebx,%ebx
    1106:	7e cd                	jle    10d5 <createdelete+0x9b>
    1108:	f6 c3 01             	test   $0x1,%bl
    110b:	75 c8                	jne    10d5 <createdelete+0x9b>
          name[1] = '0' + (i / 2);
    110d:	89 d8                	mov    %ebx,%eax
    110f:	c1 e8 1f             	shr    $0x1f,%eax
    1112:	01 d8                	add    %ebx,%eax
    1114:	d1 f8                	sar    %eax
    1116:	83 c0 30             	add    $0x30,%eax
    1119:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    111c:	83 ec 0c             	sub    $0xc,%esp
    111f:	56                   	push   %esi
    1120:	e8 49 27 00 00       	call   386e <unlink>
    1125:	83 c4 10             	add    $0x10,%esp
    1128:	85 c0                	test   %eax,%eax
    112a:	79 a9                	jns    10d5 <createdelete+0x9b>
            printf(1, "unlink failed\n");
    112c:	83 ec 08             	sub    $0x8,%esp
    112f:	68 35 3d 00 00       	push   $0x3d35
    1134:	6a 01                	push   $0x1
    1136:	e8 27 28 00 00       	call   3962 <printf>
            exit();
    113b:	e8 de 26 00 00       	call   381e <exit>
      exit();
    1140:	e8 d9 26 00 00       	call   381e <exit>
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1145:	85 c0                	test   %eax,%eax
    1147:	78 06                	js     114f <createdelete+0x115>
    1149:	83 7d c4 08          	cmpl   $0x8,-0x3c(%ebp)
    114d:	76 50                	jbe    119f <createdelete+0x165>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    114f:	85 c0                	test   %eax,%eax
    1151:	79 64                	jns    11b7 <createdelete+0x17d>
    for(pi = 0; pi < 4; pi++){
    1153:	83 c3 01             	add    $0x1,%ebx
    1156:	80 fb 74             	cmp    $0x74,%bl
    1159:	74 6a                	je     11c5 <createdelete+0x18b>
      name[0] = 'p' + pi;
    115b:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    115e:	89 f8                	mov    %edi,%eax
    1160:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1163:	83 ec 08             	sub    $0x8,%esp
    1166:	6a 00                	push   $0x0
    1168:	8d 45 c8             	lea    -0x38(%ebp),%eax
    116b:	50                   	push   %eax
    116c:	e8 ed 26 00 00       	call   385e <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1171:	83 c4 10             	add    $0x10,%esp
    1174:	85 f6                	test   %esi,%esi
    1176:	0f 94 c1             	sete   %cl
    1179:	83 fe 09             	cmp    $0x9,%esi
    117c:	0f 9f c2             	setg   %dl
    117f:	08 d1                	or     %dl,%cl
    1181:	74 c2                	je     1145 <createdelete+0x10b>
    1183:	85 c0                	test   %eax,%eax
    1185:	79 be                	jns    1145 <createdelete+0x10b>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1187:	83 ec 04             	sub    $0x4,%esp
    118a:	8d 45 c8             	lea    -0x38(%ebp),%eax
    118d:	50                   	push   %eax
    118e:	68 f4 4d 00 00       	push   $0x4df4
    1193:	6a 01                	push   $0x1
    1195:	e8 c8 27 00 00       	call   3962 <printf>
        exit();
    119a:	e8 7f 26 00 00       	call   381e <exit>
        printf(1, "oops createdelete %s did exist\n", name);
    119f:	83 ec 04             	sub    $0x4,%esp
    11a2:	8d 45 c8             	lea    -0x38(%ebp),%eax
    11a5:	50                   	push   %eax
    11a6:	68 18 4e 00 00       	push   $0x4e18
    11ab:	6a 01                	push   $0x1
    11ad:	e8 b0 27 00 00       	call   3962 <printf>
        exit();
    11b2:	e8 67 26 00 00       	call   381e <exit>
        close(fd);
    11b7:	83 ec 0c             	sub    $0xc,%esp
    11ba:	50                   	push   %eax
    11bb:	e8 86 26 00 00       	call   3846 <close>
    11c0:	83 c4 10             	add    $0x10,%esp
    11c3:	eb 8e                	jmp    1153 <createdelete+0x119>
  for(i = 0; i < N; i++){
    11c5:	83 c6 01             	add    $0x1,%esi
    11c8:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
    11cc:	83 c7 01             	add    $0x1,%edi
    11cf:	83 fe 14             	cmp    $0x14,%esi
    11d2:	74 38                	je     120c <createdelete+0x1d2>
  for(pi = 0; pi < 4; pi++){
    11d4:	bb 70 00 00 00       	mov    $0x70,%ebx
    11d9:	eb 80                	jmp    115b <createdelete+0x121>
    }
  }

  for(i = 0; i < N; i++){
    11db:	83 c6 01             	add    $0x1,%esi
    11de:	83 c7 01             	add    $0x1,%edi
    11e1:	89 f0                	mov    %esi,%eax
    11e3:	3c 84                	cmp    $0x84,%al
    11e5:	74 31                	je     1218 <createdelete+0x1de>
  for(i = 0; i < N; i++){
    11e7:	bb 04 00 00 00       	mov    $0x4,%ebx
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11ec:	89 f0                	mov    %esi,%eax
    11ee:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    11f1:	89 f8                	mov    %edi,%eax
    11f3:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    11f6:	83 ec 0c             	sub    $0xc,%esp
    11f9:	8d 45 c8             	lea    -0x38(%ebp),%eax
    11fc:	50                   	push   %eax
    11fd:	e8 6c 26 00 00       	call   386e <unlink>
    for(pi = 0; pi < 4; pi++){
    1202:	83 c4 10             	add    $0x10,%esp
    1205:	83 eb 01             	sub    $0x1,%ebx
    1208:	75 e2                	jne    11ec <createdelete+0x1b2>
    120a:	eb cf                	jmp    11db <createdelete+0x1a1>
    120c:	bf 30 00 00 00       	mov    $0x30,%edi
    1211:	be 70 00 00 00       	mov    $0x70,%esi
    1216:	eb cf                	jmp    11e7 <createdelete+0x1ad>
    }
  }

  printf(1, "createdelete ok\n");
    1218:	83 ec 08             	sub    $0x8,%esp
    121b:	68 47 41 00 00       	push   $0x4147
    1220:	6a 01                	push   $0x1
    1222:	e8 3b 27 00 00       	call   3962 <printf>
}
    1227:	83 c4 10             	add    $0x10,%esp
    122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    122d:	5b                   	pop    %ebx
    122e:	5e                   	pop    %esi
    122f:	5f                   	pop    %edi
    1230:	5d                   	pop    %ebp
    1231:	c3                   	ret    

00001232 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1232:	f3 0f 1e fb          	endbr32 
    1236:	55                   	push   %ebp
    1237:	89 e5                	mov    %esp,%ebp
    1239:	56                   	push   %esi
    123a:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    123b:	83 ec 08             	sub    $0x8,%esp
    123e:	68 58 41 00 00       	push   $0x4158
    1243:	6a 01                	push   $0x1
    1245:	e8 18 27 00 00       	call   3962 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    124a:	83 c4 08             	add    $0x8,%esp
    124d:	68 02 02 00 00       	push   $0x202
    1252:	68 69 41 00 00       	push   $0x4169
    1257:	e8 02 26 00 00       	call   385e <open>
  if(fd < 0){
    125c:	83 c4 10             	add    $0x10,%esp
    125f:	85 c0                	test   %eax,%eax
    1261:	0f 88 f0 00 00 00    	js     1357 <unlinkread+0x125>
    1267:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1269:	83 ec 04             	sub    $0x4,%esp
    126c:	6a 05                	push   $0x5
    126e:	68 8e 41 00 00       	push   $0x418e
    1273:	50                   	push   %eax
    1274:	e8 c5 25 00 00       	call   383e <write>
  close(fd);
    1279:	89 1c 24             	mov    %ebx,(%esp)
    127c:	e8 c5 25 00 00       	call   3846 <close>

  fd = open("unlinkread", O_RDWR);
    1281:	83 c4 08             	add    $0x8,%esp
    1284:	6a 02                	push   $0x2
    1286:	68 69 41 00 00       	push   $0x4169
    128b:	e8 ce 25 00 00       	call   385e <open>
    1290:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1292:	83 c4 10             	add    $0x10,%esp
    1295:	85 c0                	test   %eax,%eax
    1297:	0f 88 ce 00 00 00    	js     136b <unlinkread+0x139>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    129d:	83 ec 0c             	sub    $0xc,%esp
    12a0:	68 69 41 00 00       	push   $0x4169
    12a5:	e8 c4 25 00 00       	call   386e <unlink>
    12aa:	83 c4 10             	add    $0x10,%esp
    12ad:	85 c0                	test   %eax,%eax
    12af:	0f 85 ca 00 00 00    	jne    137f <unlinkread+0x14d>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12b5:	83 ec 08             	sub    $0x8,%esp
    12b8:	68 02 02 00 00       	push   $0x202
    12bd:	68 69 41 00 00       	push   $0x4169
    12c2:	e8 97 25 00 00       	call   385e <open>
    12c7:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    12c9:	83 c4 0c             	add    $0xc,%esp
    12cc:	6a 03                	push   $0x3
    12ce:	68 c6 41 00 00       	push   $0x41c6
    12d3:	50                   	push   %eax
    12d4:	e8 65 25 00 00       	call   383e <write>
  close(fd1);
    12d9:	89 34 24             	mov    %esi,(%esp)
    12dc:	e8 65 25 00 00       	call   3846 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    12e1:	83 c4 0c             	add    $0xc,%esp
    12e4:	68 00 20 00 00       	push   $0x2000
    12e9:	68 80 84 00 00       	push   $0x8480
    12ee:	53                   	push   %ebx
    12ef:	e8 42 25 00 00       	call   3836 <read>
    12f4:	83 c4 10             	add    $0x10,%esp
    12f7:	83 f8 05             	cmp    $0x5,%eax
    12fa:	0f 85 93 00 00 00    	jne    1393 <unlinkread+0x161>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    1300:	80 3d 80 84 00 00 68 	cmpb   $0x68,0x8480
    1307:	0f 85 9a 00 00 00    	jne    13a7 <unlinkread+0x175>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    130d:	83 ec 04             	sub    $0x4,%esp
    1310:	6a 0a                	push   $0xa
    1312:	68 80 84 00 00       	push   $0x8480
    1317:	53                   	push   %ebx
    1318:	e8 21 25 00 00       	call   383e <write>
    131d:	83 c4 10             	add    $0x10,%esp
    1320:	83 f8 0a             	cmp    $0xa,%eax
    1323:	0f 85 92 00 00 00    	jne    13bb <unlinkread+0x189>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1329:	83 ec 0c             	sub    $0xc,%esp
    132c:	53                   	push   %ebx
    132d:	e8 14 25 00 00       	call   3846 <close>
  unlink("unlinkread");
    1332:	c7 04 24 69 41 00 00 	movl   $0x4169,(%esp)
    1339:	e8 30 25 00 00       	call   386e <unlink>
  printf(1, "unlinkread ok\n");
    133e:	83 c4 08             	add    $0x8,%esp
    1341:	68 11 42 00 00       	push   $0x4211
    1346:	6a 01                	push   $0x1
    1348:	e8 15 26 00 00       	call   3962 <printf>
}
    134d:	83 c4 10             	add    $0x10,%esp
    1350:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1353:	5b                   	pop    %ebx
    1354:	5e                   	pop    %esi
    1355:	5d                   	pop    %ebp
    1356:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1357:	83 ec 08             	sub    $0x8,%esp
    135a:	68 74 41 00 00       	push   $0x4174
    135f:	6a 01                	push   $0x1
    1361:	e8 fc 25 00 00       	call   3962 <printf>
    exit();
    1366:	e8 b3 24 00 00       	call   381e <exit>
    printf(1, "open unlinkread failed\n");
    136b:	83 ec 08             	sub    $0x8,%esp
    136e:	68 94 41 00 00       	push   $0x4194
    1373:	6a 01                	push   $0x1
    1375:	e8 e8 25 00 00       	call   3962 <printf>
    exit();
    137a:	e8 9f 24 00 00       	call   381e <exit>
    printf(1, "unlink unlinkread failed\n");
    137f:	83 ec 08             	sub    $0x8,%esp
    1382:	68 ac 41 00 00       	push   $0x41ac
    1387:	6a 01                	push   $0x1
    1389:	e8 d4 25 00 00       	call   3962 <printf>
    exit();
    138e:	e8 8b 24 00 00       	call   381e <exit>
    printf(1, "unlinkread read failed");
    1393:	83 ec 08             	sub    $0x8,%esp
    1396:	68 ca 41 00 00       	push   $0x41ca
    139b:	6a 01                	push   $0x1
    139d:	e8 c0 25 00 00       	call   3962 <printf>
    exit();
    13a2:	e8 77 24 00 00       	call   381e <exit>
    printf(1, "unlinkread wrong data\n");
    13a7:	83 ec 08             	sub    $0x8,%esp
    13aa:	68 e1 41 00 00       	push   $0x41e1
    13af:	6a 01                	push   $0x1
    13b1:	e8 ac 25 00 00       	call   3962 <printf>
    exit();
    13b6:	e8 63 24 00 00       	call   381e <exit>
    printf(1, "unlinkread write failed\n");
    13bb:	83 ec 08             	sub    $0x8,%esp
    13be:	68 f8 41 00 00       	push   $0x41f8
    13c3:	6a 01                	push   $0x1
    13c5:	e8 98 25 00 00       	call   3962 <printf>
    exit();
    13ca:	e8 4f 24 00 00       	call   381e <exit>

000013cf <linktest>:

void
linktest(void)
{
    13cf:	f3 0f 1e fb          	endbr32 
    13d3:	55                   	push   %ebp
    13d4:	89 e5                	mov    %esp,%ebp
    13d6:	53                   	push   %ebx
    13d7:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    13da:	68 20 42 00 00       	push   $0x4220
    13df:	6a 01                	push   $0x1
    13e1:	e8 7c 25 00 00       	call   3962 <printf>

  unlink("lf1");
    13e6:	c7 04 24 2a 42 00 00 	movl   $0x422a,(%esp)
    13ed:	e8 7c 24 00 00       	call   386e <unlink>
  unlink("lf2");
    13f2:	c7 04 24 2e 42 00 00 	movl   $0x422e,(%esp)
    13f9:	e8 70 24 00 00       	call   386e <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    13fe:	83 c4 08             	add    $0x8,%esp
    1401:	68 02 02 00 00       	push   $0x202
    1406:	68 2a 42 00 00       	push   $0x422a
    140b:	e8 4e 24 00 00       	call   385e <open>
  if(fd < 0){
    1410:	83 c4 10             	add    $0x10,%esp
    1413:	85 c0                	test   %eax,%eax
    1415:	0f 88 2a 01 00 00    	js     1545 <linktest+0x176>
    141b:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    141d:	83 ec 04             	sub    $0x4,%esp
    1420:	6a 05                	push   $0x5
    1422:	68 8e 41 00 00       	push   $0x418e
    1427:	50                   	push   %eax
    1428:	e8 11 24 00 00       	call   383e <write>
    142d:	83 c4 10             	add    $0x10,%esp
    1430:	83 f8 05             	cmp    $0x5,%eax
    1433:	0f 85 20 01 00 00    	jne    1559 <linktest+0x18a>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1439:	83 ec 0c             	sub    $0xc,%esp
    143c:	53                   	push   %ebx
    143d:	e8 04 24 00 00       	call   3846 <close>

  if(link("lf1", "lf2") < 0){
    1442:	83 c4 08             	add    $0x8,%esp
    1445:	68 2e 42 00 00       	push   $0x422e
    144a:	68 2a 42 00 00       	push   $0x422a
    144f:	e8 2a 24 00 00       	call   387e <link>
    1454:	83 c4 10             	add    $0x10,%esp
    1457:	85 c0                	test   %eax,%eax
    1459:	0f 88 0e 01 00 00    	js     156d <linktest+0x19e>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    145f:	83 ec 0c             	sub    $0xc,%esp
    1462:	68 2a 42 00 00       	push   $0x422a
    1467:	e8 02 24 00 00       	call   386e <unlink>

  if(open("lf1", 0) >= 0){
    146c:	83 c4 08             	add    $0x8,%esp
    146f:	6a 00                	push   $0x0
    1471:	68 2a 42 00 00       	push   $0x422a
    1476:	e8 e3 23 00 00       	call   385e <open>
    147b:	83 c4 10             	add    $0x10,%esp
    147e:	85 c0                	test   %eax,%eax
    1480:	0f 89 fb 00 00 00    	jns    1581 <linktest+0x1b2>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1486:	83 ec 08             	sub    $0x8,%esp
    1489:	6a 00                	push   $0x0
    148b:	68 2e 42 00 00       	push   $0x422e
    1490:	e8 c9 23 00 00       	call   385e <open>
    1495:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1497:	83 c4 10             	add    $0x10,%esp
    149a:	85 c0                	test   %eax,%eax
    149c:	0f 88 f3 00 00 00    	js     1595 <linktest+0x1c6>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    14a2:	83 ec 04             	sub    $0x4,%esp
    14a5:	68 00 20 00 00       	push   $0x2000
    14aa:	68 80 84 00 00       	push   $0x8480
    14af:	50                   	push   %eax
    14b0:	e8 81 23 00 00       	call   3836 <read>
    14b5:	83 c4 10             	add    $0x10,%esp
    14b8:	83 f8 05             	cmp    $0x5,%eax
    14bb:	0f 85 e8 00 00 00    	jne    15a9 <linktest+0x1da>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    14c1:	83 ec 0c             	sub    $0xc,%esp
    14c4:	53                   	push   %ebx
    14c5:	e8 7c 23 00 00       	call   3846 <close>

  if(link("lf2", "lf2") >= 0){
    14ca:	83 c4 08             	add    $0x8,%esp
    14cd:	68 2e 42 00 00       	push   $0x422e
    14d2:	68 2e 42 00 00       	push   $0x422e
    14d7:	e8 a2 23 00 00       	call   387e <link>
    14dc:	83 c4 10             	add    $0x10,%esp
    14df:	85 c0                	test   %eax,%eax
    14e1:	0f 89 d6 00 00 00    	jns    15bd <linktest+0x1ee>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    14e7:	83 ec 0c             	sub    $0xc,%esp
    14ea:	68 2e 42 00 00       	push   $0x422e
    14ef:	e8 7a 23 00 00       	call   386e <unlink>
  if(link("lf2", "lf1") >= 0){
    14f4:	83 c4 08             	add    $0x8,%esp
    14f7:	68 2a 42 00 00       	push   $0x422a
    14fc:	68 2e 42 00 00       	push   $0x422e
    1501:	e8 78 23 00 00       	call   387e <link>
    1506:	83 c4 10             	add    $0x10,%esp
    1509:	85 c0                	test   %eax,%eax
    150b:	0f 89 c0 00 00 00    	jns    15d1 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1511:	83 ec 08             	sub    $0x8,%esp
    1514:	68 2a 42 00 00       	push   $0x422a
    1519:	68 f2 44 00 00       	push   $0x44f2
    151e:	e8 5b 23 00 00       	call   387e <link>
    1523:	83 c4 10             	add    $0x10,%esp
    1526:	85 c0                	test   %eax,%eax
    1528:	0f 89 b7 00 00 00    	jns    15e5 <linktest+0x216>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    152e:	83 ec 08             	sub    $0x8,%esp
    1531:	68 c8 42 00 00       	push   $0x42c8
    1536:	6a 01                	push   $0x1
    1538:	e8 25 24 00 00       	call   3962 <printf>
}
    153d:	83 c4 10             	add    $0x10,%esp
    1540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1543:	c9                   	leave  
    1544:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1545:	83 ec 08             	sub    $0x8,%esp
    1548:	68 32 42 00 00       	push   $0x4232
    154d:	6a 01                	push   $0x1
    154f:	e8 0e 24 00 00       	call   3962 <printf>
    exit();
    1554:	e8 c5 22 00 00       	call   381e <exit>
    printf(1, "write lf1 failed\n");
    1559:	83 ec 08             	sub    $0x8,%esp
    155c:	68 45 42 00 00       	push   $0x4245
    1561:	6a 01                	push   $0x1
    1563:	e8 fa 23 00 00       	call   3962 <printf>
    exit();
    1568:	e8 b1 22 00 00       	call   381e <exit>
    printf(1, "link lf1 lf2 failed\n");
    156d:	83 ec 08             	sub    $0x8,%esp
    1570:	68 57 42 00 00       	push   $0x4257
    1575:	6a 01                	push   $0x1
    1577:	e8 e6 23 00 00       	call   3962 <printf>
    exit();
    157c:	e8 9d 22 00 00       	call   381e <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1581:	83 ec 08             	sub    $0x8,%esp
    1584:	68 38 4e 00 00       	push   $0x4e38
    1589:	6a 01                	push   $0x1
    158b:	e8 d2 23 00 00       	call   3962 <printf>
    exit();
    1590:	e8 89 22 00 00       	call   381e <exit>
    printf(1, "open lf2 failed\n");
    1595:	83 ec 08             	sub    $0x8,%esp
    1598:	68 6c 42 00 00       	push   $0x426c
    159d:	6a 01                	push   $0x1
    159f:	e8 be 23 00 00       	call   3962 <printf>
    exit();
    15a4:	e8 75 22 00 00       	call   381e <exit>
    printf(1, "read lf2 failed\n");
    15a9:	83 ec 08             	sub    $0x8,%esp
    15ac:	68 7d 42 00 00       	push   $0x427d
    15b1:	6a 01                	push   $0x1
    15b3:	e8 aa 23 00 00       	call   3962 <printf>
    exit();
    15b8:	e8 61 22 00 00       	call   381e <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15bd:	83 ec 08             	sub    $0x8,%esp
    15c0:	68 8e 42 00 00       	push   $0x428e
    15c5:	6a 01                	push   $0x1
    15c7:	e8 96 23 00 00       	call   3962 <printf>
    exit();
    15cc:	e8 4d 22 00 00       	call   381e <exit>
    printf(1, "link non-existant succeeded! oops\n");
    15d1:	83 ec 08             	sub    $0x8,%esp
    15d4:	68 60 4e 00 00       	push   $0x4e60
    15d9:	6a 01                	push   $0x1
    15db:	e8 82 23 00 00       	call   3962 <printf>
    exit();
    15e0:	e8 39 22 00 00       	call   381e <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    15e5:	83 ec 08             	sub    $0x8,%esp
    15e8:	68 ac 42 00 00       	push   $0x42ac
    15ed:	6a 01                	push   $0x1
    15ef:	e8 6e 23 00 00       	call   3962 <printf>
    exit();
    15f4:	e8 25 22 00 00       	call   381e <exit>

000015f9 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    15f9:	f3 0f 1e fb          	endbr32 
    15fd:	55                   	push   %ebp
    15fe:	89 e5                	mov    %esp,%ebp
    1600:	57                   	push   %edi
    1601:	56                   	push   %esi
    1602:	53                   	push   %ebx
    1603:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1606:	68 d5 42 00 00       	push   $0x42d5
    160b:	6a 01                	push   $0x1
    160d:	e8 50 23 00 00       	call   3962 <printf>
  file[0] = 'C';
    1612:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1616:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    161a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    161d:	bb 00 00 00 00       	mov    $0x0,%ebx
    file[1] = '0' + i;
    unlink(file);
    1622:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    pid = fork();
    if(pid && (i % 3) == 1){
    1625:	bf 56 55 55 55       	mov    $0x55555556,%edi
    162a:	e9 75 02 00 00       	jmp    18a4 <concreate+0x2ab>
      link("C0", file);
    162f:	83 ec 08             	sub    $0x8,%esp
    1632:	56                   	push   %esi
    1633:	68 e5 42 00 00       	push   $0x42e5
    1638:	e8 41 22 00 00       	call   387e <link>
    163d:	83 c4 10             	add    $0x10,%esp
    1640:	e9 4e 02 00 00       	jmp    1893 <concreate+0x29a>
    } else if(pid == 0 && (i % 5) == 1){
    1645:	ba 67 66 66 66       	mov    $0x66666667,%edx
    164a:	89 d8                	mov    %ebx,%eax
    164c:	f7 ea                	imul   %edx
    164e:	d1 fa                	sar    %edx
    1650:	89 d8                	mov    %ebx,%eax
    1652:	c1 f8 1f             	sar    $0x1f,%eax
    1655:	29 c2                	sub    %eax,%edx
    1657:	8d 04 92             	lea    (%edx,%edx,4),%eax
    165a:	29 c3                	sub    %eax,%ebx
    165c:	83 fb 01             	cmp    $0x1,%ebx
    165f:	74 34                	je     1695 <concreate+0x9c>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1661:	83 ec 08             	sub    $0x8,%esp
    1664:	68 02 02 00 00       	push   $0x202
    1669:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    166c:	50                   	push   %eax
    166d:	e8 ec 21 00 00       	call   385e <open>
      if(fd < 0){
    1672:	83 c4 10             	add    $0x10,%esp
    1675:	85 c0                	test   %eax,%eax
    1677:	0f 89 f9 01 00 00    	jns    1876 <concreate+0x27d>
        printf(1, "concreate create %s failed\n", file);
    167d:	83 ec 04             	sub    $0x4,%esp
    1680:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1683:	50                   	push   %eax
    1684:	68 e8 42 00 00       	push   $0x42e8
    1689:	6a 01                	push   $0x1
    168b:	e8 d2 22 00 00       	call   3962 <printf>
        exit();
    1690:	e8 89 21 00 00       	call   381e <exit>
      link("C0", file);
    1695:	83 ec 08             	sub    $0x8,%esp
    1698:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    169b:	50                   	push   %eax
    169c:	68 e5 42 00 00       	push   $0x42e5
    16a1:	e8 d8 21 00 00       	call   387e <link>
    16a6:	83 c4 10             	add    $0x10,%esp
      }
      close(fd);
    }
    if(pid == 0)
      exit();
    16a9:	e8 70 21 00 00       	call   381e <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    16ae:	83 ec 04             	sub    $0x4,%esp
    16b1:	6a 28                	push   $0x28
    16b3:	6a 00                	push   $0x0
    16b5:	8d 45 bd             	lea    -0x43(%ebp),%eax
    16b8:	50                   	push   %eax
    16b9:	e8 f9 1f 00 00       	call   36b7 <memset>
  fd = open(".", 0);
    16be:	83 c4 08             	add    $0x8,%esp
    16c1:	6a 00                	push   $0x0
    16c3:	68 f2 44 00 00       	push   $0x44f2
    16c8:	e8 91 21 00 00       	call   385e <open>
    16cd:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    16cf:	83 c4 10             	add    $0x10,%esp
  n = 0;
    16d2:	bf 00 00 00 00       	mov    $0x0,%edi
  while(read(fd, &de, sizeof(de)) > 0){
    16d7:	8d 75 ac             	lea    -0x54(%ebp),%esi
    16da:	83 ec 04             	sub    $0x4,%esp
    16dd:	6a 10                	push   $0x10
    16df:	56                   	push   %esi
    16e0:	53                   	push   %ebx
    16e1:	e8 50 21 00 00       	call   3836 <read>
    16e6:	83 c4 10             	add    $0x10,%esp
    16e9:	85 c0                	test   %eax,%eax
    16eb:	7e 60                	jle    174d <concreate+0x154>
    if(de.inum == 0)
    16ed:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    16f2:	74 e6                	je     16da <concreate+0xe1>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    16f4:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    16f8:	75 e0                	jne    16da <concreate+0xe1>
    16fa:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    16fe:	75 da                	jne    16da <concreate+0xe1>
      i = de.name[1] - '0';
    1700:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    1704:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1707:	83 f8 27             	cmp    $0x27,%eax
    170a:	77 11                	ja     171d <concreate+0x124>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    170c:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    1711:	75 22                	jne    1735 <concreate+0x13c>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    1713:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    1718:	83 c7 01             	add    $0x1,%edi
    171b:	eb bd                	jmp    16da <concreate+0xe1>
        printf(1, "concreate weird file %s\n", de.name);
    171d:	83 ec 04             	sub    $0x4,%esp
    1720:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1723:	50                   	push   %eax
    1724:	68 04 43 00 00       	push   $0x4304
    1729:	6a 01                	push   $0x1
    172b:	e8 32 22 00 00       	call   3962 <printf>
        exit();
    1730:	e8 e9 20 00 00       	call   381e <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1735:	83 ec 04             	sub    $0x4,%esp
    1738:	8d 45 ae             	lea    -0x52(%ebp),%eax
    173b:	50                   	push   %eax
    173c:	68 1d 43 00 00       	push   $0x431d
    1741:	6a 01                	push   $0x1
    1743:	e8 1a 22 00 00       	call   3962 <printf>
        exit();
    1748:	e8 d1 20 00 00       	call   381e <exit>
    }
  }
  close(fd);
    174d:	83 ec 0c             	sub    $0xc,%esp
    1750:	53                   	push   %ebx
    1751:	e8 f0 20 00 00       	call   3846 <close>

  if(n != 40){
    1756:	83 c4 10             	add    $0x10,%esp
    1759:	83 ff 28             	cmp    $0x28,%edi
    175c:	75 0d                	jne    176b <concreate+0x172>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    175e:	bb 00 00 00 00       	mov    $0x0,%ebx
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1763:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1766:	e9 88 00 00 00       	jmp    17f3 <concreate+0x1fa>
    printf(1, "concreate not enough files in directory listing\n");
    176b:	83 ec 08             	sub    $0x8,%esp
    176e:	68 84 4e 00 00       	push   $0x4e84
    1773:	6a 01                	push   $0x1
    1775:	e8 e8 21 00 00       	call   3962 <printf>
    exit();
    177a:	e8 9f 20 00 00       	call   381e <exit>
      printf(1, "fork failed\n");
    177f:	83 ec 08             	sub    $0x8,%esp
    1782:	68 bd 4b 00 00       	push   $0x4bbd
    1787:	6a 01                	push   $0x1
    1789:	e8 d4 21 00 00       	call   3962 <printf>
      exit();
    178e:	e8 8b 20 00 00       	call   381e <exit>
      close(open(file, 0));
    1793:	83 ec 08             	sub    $0x8,%esp
    1796:	6a 00                	push   $0x0
    1798:	57                   	push   %edi
    1799:	e8 c0 20 00 00       	call   385e <open>
    179e:	89 04 24             	mov    %eax,(%esp)
    17a1:	e8 a0 20 00 00       	call   3846 <close>
      close(open(file, 0));
    17a6:	83 c4 08             	add    $0x8,%esp
    17a9:	6a 00                	push   $0x0
    17ab:	57                   	push   %edi
    17ac:	e8 ad 20 00 00       	call   385e <open>
    17b1:	89 04 24             	mov    %eax,(%esp)
    17b4:	e8 8d 20 00 00       	call   3846 <close>
      close(open(file, 0));
    17b9:	83 c4 08             	add    $0x8,%esp
    17bc:	6a 00                	push   $0x0
    17be:	57                   	push   %edi
    17bf:	e8 9a 20 00 00       	call   385e <open>
    17c4:	89 04 24             	mov    %eax,(%esp)
    17c7:	e8 7a 20 00 00       	call   3846 <close>
      close(open(file, 0));
    17cc:	83 c4 08             	add    $0x8,%esp
    17cf:	6a 00                	push   $0x0
    17d1:	57                   	push   %edi
    17d2:	e8 87 20 00 00       	call   385e <open>
    17d7:	89 04 24             	mov    %eax,(%esp)
    17da:	e8 67 20 00 00       	call   3846 <close>
    17df:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    17e2:	85 f6                	test   %esi,%esi
    17e4:	74 74                	je     185a <concreate+0x261>
      exit();
    else
      wait();
    17e6:	e8 3b 20 00 00       	call   3826 <wait>
  for(i = 0; i < 40; i++){
    17eb:	83 c3 01             	add    $0x1,%ebx
    17ee:	83 fb 28             	cmp    $0x28,%ebx
    17f1:	74 6c                	je     185f <concreate+0x266>
    file[1] = '0' + i;
    17f3:	8d 43 30             	lea    0x30(%ebx),%eax
    17f6:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    17f9:	e8 18 20 00 00       	call   3816 <fork>
    17fe:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1800:	85 c0                	test   %eax,%eax
    1802:	0f 88 77 ff ff ff    	js     177f <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    1808:	b8 56 55 55 55       	mov    $0x55555556,%eax
    180d:	f7 eb                	imul   %ebx
    180f:	89 d8                	mov    %ebx,%eax
    1811:	c1 f8 1f             	sar    $0x1f,%eax
    1814:	29 c2                	sub    %eax,%edx
    1816:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1819:	89 da                	mov    %ebx,%edx
    181b:	29 c2                	sub    %eax,%edx
    181d:	89 d0                	mov    %edx,%eax
    181f:	09 f0                	or     %esi,%eax
    1821:	0f 84 6c ff ff ff    	je     1793 <concreate+0x19a>
       ((i % 3) == 1 && pid != 0)){
    1827:	85 f6                	test   %esi,%esi
    1829:	74 09                	je     1834 <concreate+0x23b>
    182b:	83 fa 01             	cmp    $0x1,%edx
    182e:	0f 84 5f ff ff ff    	je     1793 <concreate+0x19a>
      unlink(file);
    1834:	83 ec 0c             	sub    $0xc,%esp
    1837:	57                   	push   %edi
    1838:	e8 31 20 00 00       	call   386e <unlink>
      unlink(file);
    183d:	89 3c 24             	mov    %edi,(%esp)
    1840:	e8 29 20 00 00       	call   386e <unlink>
      unlink(file);
    1845:	89 3c 24             	mov    %edi,(%esp)
    1848:	e8 21 20 00 00       	call   386e <unlink>
      unlink(file);
    184d:	89 3c 24             	mov    %edi,(%esp)
    1850:	e8 19 20 00 00       	call   386e <unlink>
    1855:	83 c4 10             	add    $0x10,%esp
    1858:	eb 88                	jmp    17e2 <concreate+0x1e9>
      exit();
    185a:	e8 bf 1f 00 00       	call   381e <exit>
  }

  printf(1, "concreate ok\n");
    185f:	83 ec 08             	sub    $0x8,%esp
    1862:	68 3a 43 00 00       	push   $0x433a
    1867:	6a 01                	push   $0x1
    1869:	e8 f4 20 00 00       	call   3962 <printf>
}
    186e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1871:	5b                   	pop    %ebx
    1872:	5e                   	pop    %esi
    1873:	5f                   	pop    %edi
    1874:	5d                   	pop    %ebp
    1875:	c3                   	ret    
      close(fd);
    1876:	83 ec 0c             	sub    $0xc,%esp
    1879:	50                   	push   %eax
    187a:	e8 c7 1f 00 00       	call   3846 <close>
    187f:	83 c4 10             	add    $0x10,%esp
    1882:	e9 22 fe ff ff       	jmp    16a9 <concreate+0xb0>
    1887:	83 ec 0c             	sub    $0xc,%esp
    188a:	50                   	push   %eax
    188b:	e8 b6 1f 00 00       	call   3846 <close>
    1890:	83 c4 10             	add    $0x10,%esp
      wait();
    1893:	e8 8e 1f 00 00       	call   3826 <wait>
  for(i = 0; i < 40; i++){
    1898:	83 c3 01             	add    $0x1,%ebx
    189b:	83 fb 28             	cmp    $0x28,%ebx
    189e:	0f 84 0a fe ff ff    	je     16ae <concreate+0xb5>
    file[1] = '0' + i;
    18a4:	8d 43 30             	lea    0x30(%ebx),%eax
    18a7:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    18aa:	83 ec 0c             	sub    $0xc,%esp
    18ad:	56                   	push   %esi
    18ae:	e8 bb 1f 00 00       	call   386e <unlink>
    pid = fork();
    18b3:	e8 5e 1f 00 00       	call   3816 <fork>
    if(pid && (i % 3) == 1){
    18b8:	83 c4 10             	add    $0x10,%esp
    18bb:	85 c0                	test   %eax,%eax
    18bd:	0f 84 82 fd ff ff    	je     1645 <concreate+0x4c>
    18c3:	89 d8                	mov    %ebx,%eax
    18c5:	f7 ef                	imul   %edi
    18c7:	89 d8                	mov    %ebx,%eax
    18c9:	c1 f8 1f             	sar    $0x1f,%eax
    18cc:	29 c2                	sub    %eax,%edx
    18ce:	8d 04 52             	lea    (%edx,%edx,2),%eax
    18d1:	89 d9                	mov    %ebx,%ecx
    18d3:	29 c1                	sub    %eax,%ecx
    18d5:	83 f9 01             	cmp    $0x1,%ecx
    18d8:	0f 84 51 fd ff ff    	je     162f <concreate+0x36>
      fd = open(file, O_CREATE | O_RDWR);
    18de:	83 ec 08             	sub    $0x8,%esp
    18e1:	68 02 02 00 00       	push   $0x202
    18e6:	56                   	push   %esi
    18e7:	e8 72 1f 00 00       	call   385e <open>
      if(fd < 0){
    18ec:	83 c4 10             	add    $0x10,%esp
    18ef:	85 c0                	test   %eax,%eax
    18f1:	79 94                	jns    1887 <concreate+0x28e>
    18f3:	e9 85 fd ff ff       	jmp    167d <concreate+0x84>

000018f8 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    18f8:	f3 0f 1e fb          	endbr32 
    18fc:	55                   	push   %ebp
    18fd:	89 e5                	mov    %esp,%ebp
    18ff:	57                   	push   %edi
    1900:	56                   	push   %esi
    1901:	53                   	push   %ebx
    1902:	83 ec 24             	sub    $0x24,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1905:	68 48 43 00 00       	push   $0x4348
    190a:	6a 01                	push   $0x1
    190c:	e8 51 20 00 00       	call   3962 <printf>

  unlink("x");
    1911:	c7 04 24 d5 45 00 00 	movl   $0x45d5,(%esp)
    1918:	e8 51 1f 00 00       	call   386e <unlink>
  pid = fork();
    191d:	e8 f4 1e 00 00       	call   3816 <fork>
    1922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1925:	83 c4 10             	add    $0x10,%esp
    1928:	85 c0                	test   %eax,%eax
    192a:	78 18                	js     1944 <linkunlink+0x4c>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    192c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1930:	19 db                	sbb    %ebx,%ebx
    1932:	83 e3 60             	and    $0x60,%ebx
    1935:	83 c3 01             	add    $0x1,%ebx
    1938:	be 64 00 00 00       	mov    $0x64,%esi
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    193d:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
    1942:	eb 48                	jmp    198c <linkunlink+0x94>
    printf(1, "fork failed\n");
    1944:	83 ec 08             	sub    $0x8,%esp
    1947:	68 bd 4b 00 00       	push   $0x4bbd
    194c:	6a 01                	push   $0x1
    194e:	e8 0f 20 00 00       	call   3962 <printf>
    exit();
    1953:	e8 c6 1e 00 00       	call   381e <exit>
      close(open("x", O_RDWR | O_CREATE));
    1958:	83 ec 08             	sub    $0x8,%esp
    195b:	68 02 02 00 00       	push   $0x202
    1960:	68 d5 45 00 00       	push   $0x45d5
    1965:	e8 f4 1e 00 00       	call   385e <open>
    196a:	89 04 24             	mov    %eax,(%esp)
    196d:	e8 d4 1e 00 00       	call   3846 <close>
    1972:	83 c4 10             	add    $0x10,%esp
    1975:	eb 10                	jmp    1987 <linkunlink+0x8f>
    } else if((x % 3) == 1){
      link("cat", "x");
    } else {
      unlink("x");
    1977:	83 ec 0c             	sub    $0xc,%esp
    197a:	68 d5 45 00 00       	push   $0x45d5
    197f:	e8 ea 1e 00 00       	call   386e <unlink>
    1984:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1987:	83 ee 01             	sub    $0x1,%esi
    198a:	74 3b                	je     19c7 <linkunlink+0xcf>
    x = x * 1103515245 + 12345;
    198c:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    1992:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    1998:	89 d8                	mov    %ebx,%eax
    199a:	f7 e7                	mul    %edi
    199c:	89 d0                	mov    %edx,%eax
    199e:	d1 e8                	shr    %eax
    19a0:	83 e2 fe             	and    $0xfffffffe,%edx
    19a3:	01 c2                	add    %eax,%edx
    19a5:	89 d8                	mov    %ebx,%eax
    19a7:	29 d0                	sub    %edx,%eax
    19a9:	74 ad                	je     1958 <linkunlink+0x60>
    } else if((x % 3) == 1){
    19ab:	83 f8 01             	cmp    $0x1,%eax
    19ae:	75 c7                	jne    1977 <linkunlink+0x7f>
      link("cat", "x");
    19b0:	83 ec 08             	sub    $0x8,%esp
    19b3:	68 d5 45 00 00       	push   $0x45d5
    19b8:	68 59 43 00 00       	push   $0x4359
    19bd:	e8 bc 1e 00 00       	call   387e <link>
    19c2:	83 c4 10             	add    $0x10,%esp
    19c5:	eb c0                	jmp    1987 <linkunlink+0x8f>
    }
  }

  if(pid)
    19c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    19cb:	74 1c                	je     19e9 <linkunlink+0xf1>
    wait();
    19cd:	e8 54 1e 00 00       	call   3826 <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    19d2:	83 ec 08             	sub    $0x8,%esp
    19d5:	68 5d 43 00 00       	push   $0x435d
    19da:	6a 01                	push   $0x1
    19dc:	e8 81 1f 00 00       	call   3962 <printf>
}
    19e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19e4:	5b                   	pop    %ebx
    19e5:	5e                   	pop    %esi
    19e6:	5f                   	pop    %edi
    19e7:	5d                   	pop    %ebp
    19e8:	c3                   	ret    
    exit();
    19e9:	e8 30 1e 00 00       	call   381e <exit>

000019ee <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    19ee:	f3 0f 1e fb          	endbr32 
    19f2:	55                   	push   %ebp
    19f3:	89 e5                	mov    %esp,%ebp
    19f5:	57                   	push   %edi
    19f6:	56                   	push   %esi
    19f7:	53                   	push   %ebx
    19f8:	83 ec 24             	sub    $0x24,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    19fb:	68 6c 43 00 00       	push   $0x436c
    1a00:	6a 01                	push   $0x1
    1a02:	e8 5b 1f 00 00       	call   3962 <printf>
  unlink("bd");
    1a07:	c7 04 24 79 43 00 00 	movl   $0x4379,(%esp)
    1a0e:	e8 5b 1e 00 00       	call   386e <unlink>

  fd = open("bd", O_CREATE);
    1a13:	83 c4 08             	add    $0x8,%esp
    1a16:	68 00 02 00 00       	push   $0x200
    1a1b:	68 79 43 00 00       	push   $0x4379
    1a20:	e8 39 1e 00 00       	call   385e <open>
  if(fd < 0){
    1a25:	83 c4 10             	add    $0x10,%esp
    1a28:	85 c0                	test   %eax,%eax
    1a2a:	0f 88 e0 00 00 00    	js     1b10 <bigdir+0x122>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    1a30:	83 ec 0c             	sub    $0xc,%esp
    1a33:	50                   	push   %eax
    1a34:	e8 0d 1e 00 00       	call   3846 <close>
    1a39:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1a3c:	be 00 00 00 00       	mov    $0x0,%esi
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    1a41:	8d 7d de             	lea    -0x22(%ebp),%edi
    name[0] = 'x';
    1a44:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1a48:	8d 46 3f             	lea    0x3f(%esi),%eax
    1a4b:	85 f6                	test   %esi,%esi
    1a4d:	0f 49 c6             	cmovns %esi,%eax
    1a50:	c1 f8 06             	sar    $0x6,%eax
    1a53:	83 c0 30             	add    $0x30,%eax
    1a56:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a59:	89 f2                	mov    %esi,%edx
    1a5b:	c1 fa 1f             	sar    $0x1f,%edx
    1a5e:	c1 ea 1a             	shr    $0x1a,%edx
    1a61:	8d 04 16             	lea    (%esi,%edx,1),%eax
    1a64:	83 e0 3f             	and    $0x3f,%eax
    1a67:	29 d0                	sub    %edx,%eax
    1a69:	83 c0 30             	add    $0x30,%eax
    1a6c:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1a6f:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(link("bd", name) != 0){
    1a73:	83 ec 08             	sub    $0x8,%esp
    1a76:	57                   	push   %edi
    1a77:	68 79 43 00 00       	push   $0x4379
    1a7c:	e8 fd 1d 00 00       	call   387e <link>
    1a81:	89 c3                	mov    %eax,%ebx
    1a83:	83 c4 10             	add    $0x10,%esp
    1a86:	85 c0                	test   %eax,%eax
    1a88:	0f 85 96 00 00 00    	jne    1b24 <bigdir+0x136>
  for(i = 0; i < 500; i++){
    1a8e:	83 c6 01             	add    $0x1,%esi
    1a91:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1a97:	75 ab                	jne    1a44 <bigdir+0x56>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1a99:	83 ec 0c             	sub    $0xc,%esp
    1a9c:	68 79 43 00 00       	push   $0x4379
    1aa1:	e8 c8 1d 00 00       	call   386e <unlink>
    1aa6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    1aa9:	8d 75 de             	lea    -0x22(%ebp),%esi
    name[0] = 'x';
    1aac:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1ab0:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1ab3:	85 db                	test   %ebx,%ebx
    1ab5:	0f 49 c3             	cmovns %ebx,%eax
    1ab8:	c1 f8 06             	sar    $0x6,%eax
    1abb:	83 c0 30             	add    $0x30,%eax
    1abe:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1ac1:	89 da                	mov    %ebx,%edx
    1ac3:	c1 fa 1f             	sar    $0x1f,%edx
    1ac6:	c1 ea 1a             	shr    $0x1a,%edx
    1ac9:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1acc:	83 e0 3f             	and    $0x3f,%eax
    1acf:	29 d0                	sub    %edx,%eax
    1ad1:	83 c0 30             	add    $0x30,%eax
    1ad4:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1ad7:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(unlink(name) != 0){
    1adb:	83 ec 0c             	sub    $0xc,%esp
    1ade:	56                   	push   %esi
    1adf:	e8 8a 1d 00 00       	call   386e <unlink>
    1ae4:	83 c4 10             	add    $0x10,%esp
    1ae7:	85 c0                	test   %eax,%eax
    1ae9:	75 4d                	jne    1b38 <bigdir+0x14a>
  for(i = 0; i < 500; i++){
    1aeb:	83 c3 01             	add    $0x1,%ebx
    1aee:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1af4:	75 b6                	jne    1aac <bigdir+0xbe>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1af6:	83 ec 08             	sub    $0x8,%esp
    1af9:	68 bb 43 00 00       	push   $0x43bb
    1afe:	6a 01                	push   $0x1
    1b00:	e8 5d 1e 00 00       	call   3962 <printf>
}
    1b05:	83 c4 10             	add    $0x10,%esp
    1b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b0b:	5b                   	pop    %ebx
    1b0c:	5e                   	pop    %esi
    1b0d:	5f                   	pop    %edi
    1b0e:	5d                   	pop    %ebp
    1b0f:	c3                   	ret    
    printf(1, "bigdir create failed\n");
    1b10:	83 ec 08             	sub    $0x8,%esp
    1b13:	68 7c 43 00 00       	push   $0x437c
    1b18:	6a 01                	push   $0x1
    1b1a:	e8 43 1e 00 00       	call   3962 <printf>
    exit();
    1b1f:	e8 fa 1c 00 00       	call   381e <exit>
      printf(1, "bigdir link failed\n");
    1b24:	83 ec 08             	sub    $0x8,%esp
    1b27:	68 92 43 00 00       	push   $0x4392
    1b2c:	6a 01                	push   $0x1
    1b2e:	e8 2f 1e 00 00       	call   3962 <printf>
      exit();
    1b33:	e8 e6 1c 00 00       	call   381e <exit>
      printf(1, "bigdir unlink failed");
    1b38:	83 ec 08             	sub    $0x8,%esp
    1b3b:	68 a6 43 00 00       	push   $0x43a6
    1b40:	6a 01                	push   $0x1
    1b42:	e8 1b 1e 00 00       	call   3962 <printf>
      exit();
    1b47:	e8 d2 1c 00 00       	call   381e <exit>

00001b4c <subdir>:

void
subdir(void)
{
    1b4c:	f3 0f 1e fb          	endbr32 
    1b50:	55                   	push   %ebp
    1b51:	89 e5                	mov    %esp,%ebp
    1b53:	53                   	push   %ebx
    1b54:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1b57:	68 c6 43 00 00       	push   $0x43c6
    1b5c:	6a 01                	push   $0x1
    1b5e:	e8 ff 1d 00 00       	call   3962 <printf>

  unlink("ff");
    1b63:	c7 04 24 4f 44 00 00 	movl   $0x444f,(%esp)
    1b6a:	e8 ff 1c 00 00       	call   386e <unlink>
  if(mkdir("dd") != 0){
    1b6f:	c7 04 24 ec 44 00 00 	movl   $0x44ec,(%esp)
    1b76:	e8 0b 1d 00 00       	call   3886 <mkdir>
    1b7b:	83 c4 10             	add    $0x10,%esp
    1b7e:	85 c0                	test   %eax,%eax
    1b80:	0f 85 14 04 00 00    	jne    1f9a <subdir+0x44e>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b86:	83 ec 08             	sub    $0x8,%esp
    1b89:	68 02 02 00 00       	push   $0x202
    1b8e:	68 25 44 00 00       	push   $0x4425
    1b93:	e8 c6 1c 00 00       	call   385e <open>
    1b98:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b9a:	83 c4 10             	add    $0x10,%esp
    1b9d:	85 c0                	test   %eax,%eax
    1b9f:	0f 88 09 04 00 00    	js     1fae <subdir+0x462>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1ba5:	83 ec 04             	sub    $0x4,%esp
    1ba8:	6a 02                	push   $0x2
    1baa:	68 4f 44 00 00       	push   $0x444f
    1baf:	50                   	push   %eax
    1bb0:	e8 89 1c 00 00       	call   383e <write>
  close(fd);
    1bb5:	89 1c 24             	mov    %ebx,(%esp)
    1bb8:	e8 89 1c 00 00       	call   3846 <close>

  if(unlink("dd") >= 0){
    1bbd:	c7 04 24 ec 44 00 00 	movl   $0x44ec,(%esp)
    1bc4:	e8 a5 1c 00 00       	call   386e <unlink>
    1bc9:	83 c4 10             	add    $0x10,%esp
    1bcc:	85 c0                	test   %eax,%eax
    1bce:	0f 89 ee 03 00 00    	jns    1fc2 <subdir+0x476>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    1bd4:	83 ec 0c             	sub    $0xc,%esp
    1bd7:	68 00 44 00 00       	push   $0x4400
    1bdc:	e8 a5 1c 00 00       	call   3886 <mkdir>
    1be1:	83 c4 10             	add    $0x10,%esp
    1be4:	85 c0                	test   %eax,%eax
    1be6:	0f 85 ea 03 00 00    	jne    1fd6 <subdir+0x48a>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1bec:	83 ec 08             	sub    $0x8,%esp
    1bef:	68 02 02 00 00       	push   $0x202
    1bf4:	68 22 44 00 00       	push   $0x4422
    1bf9:	e8 60 1c 00 00       	call   385e <open>
    1bfe:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1c00:	83 c4 10             	add    $0x10,%esp
    1c03:	85 c0                	test   %eax,%eax
    1c05:	0f 88 df 03 00 00    	js     1fea <subdir+0x49e>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    1c0b:	83 ec 04             	sub    $0x4,%esp
    1c0e:	6a 02                	push   $0x2
    1c10:	68 43 44 00 00       	push   $0x4443
    1c15:	50                   	push   %eax
    1c16:	e8 23 1c 00 00       	call   383e <write>
  close(fd);
    1c1b:	89 1c 24             	mov    %ebx,(%esp)
    1c1e:	e8 23 1c 00 00       	call   3846 <close>

  fd = open("dd/dd/../ff", 0);
    1c23:	83 c4 08             	add    $0x8,%esp
    1c26:	6a 00                	push   $0x0
    1c28:	68 46 44 00 00       	push   $0x4446
    1c2d:	e8 2c 1c 00 00       	call   385e <open>
    1c32:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1c34:	83 c4 10             	add    $0x10,%esp
    1c37:	85 c0                	test   %eax,%eax
    1c39:	0f 88 bf 03 00 00    	js     1ffe <subdir+0x4b2>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1c3f:	83 ec 04             	sub    $0x4,%esp
    1c42:	68 00 20 00 00       	push   $0x2000
    1c47:	68 80 84 00 00       	push   $0x8480
    1c4c:	50                   	push   %eax
    1c4d:	e8 e4 1b 00 00       	call   3836 <read>
  if(cc != 2 || buf[0] != 'f'){
    1c52:	83 c4 10             	add    $0x10,%esp
    1c55:	83 f8 02             	cmp    $0x2,%eax
    1c58:	0f 85 b4 03 00 00    	jne    2012 <subdir+0x4c6>
    1c5e:	80 3d 80 84 00 00 66 	cmpb   $0x66,0x8480
    1c65:	0f 85 a7 03 00 00    	jne    2012 <subdir+0x4c6>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    1c6b:	83 ec 0c             	sub    $0xc,%esp
    1c6e:	53                   	push   %ebx
    1c6f:	e8 d2 1b 00 00       	call   3846 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c74:	83 c4 08             	add    $0x8,%esp
    1c77:	68 86 44 00 00       	push   $0x4486
    1c7c:	68 22 44 00 00       	push   $0x4422
    1c81:	e8 f8 1b 00 00       	call   387e <link>
    1c86:	83 c4 10             	add    $0x10,%esp
    1c89:	85 c0                	test   %eax,%eax
    1c8b:	0f 85 95 03 00 00    	jne    2026 <subdir+0x4da>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1c91:	83 ec 0c             	sub    $0xc,%esp
    1c94:	68 22 44 00 00       	push   $0x4422
    1c99:	e8 d0 1b 00 00       	call   386e <unlink>
    1c9e:	83 c4 10             	add    $0x10,%esp
    1ca1:	85 c0                	test   %eax,%eax
    1ca3:	0f 85 91 03 00 00    	jne    203a <subdir+0x4ee>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ca9:	83 ec 08             	sub    $0x8,%esp
    1cac:	6a 00                	push   $0x0
    1cae:	68 22 44 00 00       	push   $0x4422
    1cb3:	e8 a6 1b 00 00       	call   385e <open>
    1cb8:	83 c4 10             	add    $0x10,%esp
    1cbb:	85 c0                	test   %eax,%eax
    1cbd:	0f 89 8b 03 00 00    	jns    204e <subdir+0x502>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    1cc3:	83 ec 0c             	sub    $0xc,%esp
    1cc6:	68 ec 44 00 00       	push   $0x44ec
    1ccb:	e8 be 1b 00 00       	call   388e <chdir>
    1cd0:	83 c4 10             	add    $0x10,%esp
    1cd3:	85 c0                	test   %eax,%eax
    1cd5:	0f 85 87 03 00 00    	jne    2062 <subdir+0x516>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1cdb:	83 ec 0c             	sub    $0xc,%esp
    1cde:	68 ba 44 00 00       	push   $0x44ba
    1ce3:	e8 a6 1b 00 00       	call   388e <chdir>
    1ce8:	83 c4 10             	add    $0x10,%esp
    1ceb:	85 c0                	test   %eax,%eax
    1ced:	0f 85 83 03 00 00    	jne    2076 <subdir+0x52a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1cf3:	83 ec 0c             	sub    $0xc,%esp
    1cf6:	68 e0 44 00 00       	push   $0x44e0
    1cfb:	e8 8e 1b 00 00       	call   388e <chdir>
    1d00:	83 c4 10             	add    $0x10,%esp
    1d03:	85 c0                	test   %eax,%eax
    1d05:	0f 85 7f 03 00 00    	jne    208a <subdir+0x53e>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1d0b:	83 ec 0c             	sub    $0xc,%esp
    1d0e:	68 ef 44 00 00       	push   $0x44ef
    1d13:	e8 76 1b 00 00       	call   388e <chdir>
    1d18:	83 c4 10             	add    $0x10,%esp
    1d1b:	85 c0                	test   %eax,%eax
    1d1d:	0f 85 7b 03 00 00    	jne    209e <subdir+0x552>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1d23:	83 ec 08             	sub    $0x8,%esp
    1d26:	6a 00                	push   $0x0
    1d28:	68 86 44 00 00       	push   $0x4486
    1d2d:	e8 2c 1b 00 00       	call   385e <open>
    1d32:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d34:	83 c4 10             	add    $0x10,%esp
    1d37:	85 c0                	test   %eax,%eax
    1d39:	0f 88 73 03 00 00    	js     20b2 <subdir+0x566>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1d3f:	83 ec 04             	sub    $0x4,%esp
    1d42:	68 00 20 00 00       	push   $0x2000
    1d47:	68 80 84 00 00       	push   $0x8480
    1d4c:	50                   	push   %eax
    1d4d:	e8 e4 1a 00 00       	call   3836 <read>
    1d52:	83 c4 10             	add    $0x10,%esp
    1d55:	83 f8 02             	cmp    $0x2,%eax
    1d58:	0f 85 68 03 00 00    	jne    20c6 <subdir+0x57a>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1d5e:	83 ec 0c             	sub    $0xc,%esp
    1d61:	53                   	push   %ebx
    1d62:	e8 df 1a 00 00       	call   3846 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d67:	83 c4 08             	add    $0x8,%esp
    1d6a:	6a 00                	push   $0x0
    1d6c:	68 22 44 00 00       	push   $0x4422
    1d71:	e8 e8 1a 00 00       	call   385e <open>
    1d76:	83 c4 10             	add    $0x10,%esp
    1d79:	85 c0                	test   %eax,%eax
    1d7b:	0f 89 59 03 00 00    	jns    20da <subdir+0x58e>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d81:	83 ec 08             	sub    $0x8,%esp
    1d84:	68 02 02 00 00       	push   $0x202
    1d89:	68 3a 45 00 00       	push   $0x453a
    1d8e:	e8 cb 1a 00 00       	call   385e <open>
    1d93:	83 c4 10             	add    $0x10,%esp
    1d96:	85 c0                	test   %eax,%eax
    1d98:	0f 89 50 03 00 00    	jns    20ee <subdir+0x5a2>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d9e:	83 ec 08             	sub    $0x8,%esp
    1da1:	68 02 02 00 00       	push   $0x202
    1da6:	68 5f 45 00 00       	push   $0x455f
    1dab:	e8 ae 1a 00 00       	call   385e <open>
    1db0:	83 c4 10             	add    $0x10,%esp
    1db3:	85 c0                	test   %eax,%eax
    1db5:	0f 89 47 03 00 00    	jns    2102 <subdir+0x5b6>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    1dbb:	83 ec 08             	sub    $0x8,%esp
    1dbe:	68 00 02 00 00       	push   $0x200
    1dc3:	68 ec 44 00 00       	push   $0x44ec
    1dc8:	e8 91 1a 00 00       	call   385e <open>
    1dcd:	83 c4 10             	add    $0x10,%esp
    1dd0:	85 c0                	test   %eax,%eax
    1dd2:	0f 89 3e 03 00 00    	jns    2116 <subdir+0x5ca>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1dd8:	83 ec 08             	sub    $0x8,%esp
    1ddb:	6a 02                	push   $0x2
    1ddd:	68 ec 44 00 00       	push   $0x44ec
    1de2:	e8 77 1a 00 00       	call   385e <open>
    1de7:	83 c4 10             	add    $0x10,%esp
    1dea:	85 c0                	test   %eax,%eax
    1dec:	0f 89 38 03 00 00    	jns    212a <subdir+0x5de>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1df2:	83 ec 08             	sub    $0x8,%esp
    1df5:	6a 01                	push   $0x1
    1df7:	68 ec 44 00 00       	push   $0x44ec
    1dfc:	e8 5d 1a 00 00       	call   385e <open>
    1e01:	83 c4 10             	add    $0x10,%esp
    1e04:	85 c0                	test   %eax,%eax
    1e06:	0f 89 32 03 00 00    	jns    213e <subdir+0x5f2>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1e0c:	83 ec 08             	sub    $0x8,%esp
    1e0f:	68 ce 45 00 00       	push   $0x45ce
    1e14:	68 3a 45 00 00       	push   $0x453a
    1e19:	e8 60 1a 00 00       	call   387e <link>
    1e1e:	83 c4 10             	add    $0x10,%esp
    1e21:	85 c0                	test   %eax,%eax
    1e23:	0f 84 29 03 00 00    	je     2152 <subdir+0x606>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1e29:	83 ec 08             	sub    $0x8,%esp
    1e2c:	68 ce 45 00 00       	push   $0x45ce
    1e31:	68 5f 45 00 00       	push   $0x455f
    1e36:	e8 43 1a 00 00       	call   387e <link>
    1e3b:	83 c4 10             	add    $0x10,%esp
    1e3e:	85 c0                	test   %eax,%eax
    1e40:	0f 84 20 03 00 00    	je     2166 <subdir+0x61a>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1e46:	83 ec 08             	sub    $0x8,%esp
    1e49:	68 86 44 00 00       	push   $0x4486
    1e4e:	68 25 44 00 00       	push   $0x4425
    1e53:	e8 26 1a 00 00       	call   387e <link>
    1e58:	83 c4 10             	add    $0x10,%esp
    1e5b:	85 c0                	test   %eax,%eax
    1e5d:	0f 84 17 03 00 00    	je     217a <subdir+0x62e>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1e63:	83 ec 0c             	sub    $0xc,%esp
    1e66:	68 3a 45 00 00       	push   $0x453a
    1e6b:	e8 16 1a 00 00       	call   3886 <mkdir>
    1e70:	83 c4 10             	add    $0x10,%esp
    1e73:	85 c0                	test   %eax,%eax
    1e75:	0f 84 13 03 00 00    	je     218e <subdir+0x642>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1e7b:	83 ec 0c             	sub    $0xc,%esp
    1e7e:	68 5f 45 00 00       	push   $0x455f
    1e83:	e8 fe 19 00 00       	call   3886 <mkdir>
    1e88:	83 c4 10             	add    $0x10,%esp
    1e8b:	85 c0                	test   %eax,%eax
    1e8d:	0f 84 0f 03 00 00    	je     21a2 <subdir+0x656>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1e93:	83 ec 0c             	sub    $0xc,%esp
    1e96:	68 86 44 00 00       	push   $0x4486
    1e9b:	e8 e6 19 00 00       	call   3886 <mkdir>
    1ea0:	83 c4 10             	add    $0x10,%esp
    1ea3:	85 c0                	test   %eax,%eax
    1ea5:	0f 84 0b 03 00 00    	je     21b6 <subdir+0x66a>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1eab:	83 ec 0c             	sub    $0xc,%esp
    1eae:	68 5f 45 00 00       	push   $0x455f
    1eb3:	e8 b6 19 00 00       	call   386e <unlink>
    1eb8:	83 c4 10             	add    $0x10,%esp
    1ebb:	85 c0                	test   %eax,%eax
    1ebd:	0f 84 07 03 00 00    	je     21ca <subdir+0x67e>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1ec3:	83 ec 0c             	sub    $0xc,%esp
    1ec6:	68 3a 45 00 00       	push   $0x453a
    1ecb:	e8 9e 19 00 00       	call   386e <unlink>
    1ed0:	83 c4 10             	add    $0x10,%esp
    1ed3:	85 c0                	test   %eax,%eax
    1ed5:	0f 84 03 03 00 00    	je     21de <subdir+0x692>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1edb:	83 ec 0c             	sub    $0xc,%esp
    1ede:	68 25 44 00 00       	push   $0x4425
    1ee3:	e8 a6 19 00 00       	call   388e <chdir>
    1ee8:	83 c4 10             	add    $0x10,%esp
    1eeb:	85 c0                	test   %eax,%eax
    1eed:	0f 84 ff 02 00 00    	je     21f2 <subdir+0x6a6>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1ef3:	83 ec 0c             	sub    $0xc,%esp
    1ef6:	68 d1 45 00 00       	push   $0x45d1
    1efb:	e8 8e 19 00 00       	call   388e <chdir>
    1f00:	83 c4 10             	add    $0x10,%esp
    1f03:	85 c0                	test   %eax,%eax
    1f05:	0f 84 fb 02 00 00    	je     2206 <subdir+0x6ba>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1f0b:	83 ec 0c             	sub    $0xc,%esp
    1f0e:	68 86 44 00 00       	push   $0x4486
    1f13:	e8 56 19 00 00       	call   386e <unlink>
    1f18:	83 c4 10             	add    $0x10,%esp
    1f1b:	85 c0                	test   %eax,%eax
    1f1d:	0f 85 f7 02 00 00    	jne    221a <subdir+0x6ce>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1f23:	83 ec 0c             	sub    $0xc,%esp
    1f26:	68 25 44 00 00       	push   $0x4425
    1f2b:	e8 3e 19 00 00       	call   386e <unlink>
    1f30:	83 c4 10             	add    $0x10,%esp
    1f33:	85 c0                	test   %eax,%eax
    1f35:	0f 85 f3 02 00 00    	jne    222e <subdir+0x6e2>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1f3b:	83 ec 0c             	sub    $0xc,%esp
    1f3e:	68 ec 44 00 00       	push   $0x44ec
    1f43:	e8 26 19 00 00       	call   386e <unlink>
    1f48:	83 c4 10             	add    $0x10,%esp
    1f4b:	85 c0                	test   %eax,%eax
    1f4d:	0f 84 ef 02 00 00    	je     2242 <subdir+0x6f6>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1f53:	83 ec 0c             	sub    $0xc,%esp
    1f56:	68 01 44 00 00       	push   $0x4401
    1f5b:	e8 0e 19 00 00       	call   386e <unlink>
    1f60:	83 c4 10             	add    $0x10,%esp
    1f63:	85 c0                	test   %eax,%eax
    1f65:	0f 88 eb 02 00 00    	js     2256 <subdir+0x70a>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1f6b:	83 ec 0c             	sub    $0xc,%esp
    1f6e:	68 ec 44 00 00       	push   $0x44ec
    1f73:	e8 f6 18 00 00       	call   386e <unlink>
    1f78:	83 c4 10             	add    $0x10,%esp
    1f7b:	85 c0                	test   %eax,%eax
    1f7d:	0f 88 e7 02 00 00    	js     226a <subdir+0x71e>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1f83:	83 ec 08             	sub    $0x8,%esp
    1f86:	68 ce 46 00 00       	push   $0x46ce
    1f8b:	6a 01                	push   $0x1
    1f8d:	e8 d0 19 00 00       	call   3962 <printf>
}
    1f92:	83 c4 10             	add    $0x10,%esp
    1f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f98:	c9                   	leave  
    1f99:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    1f9a:	83 ec 08             	sub    $0x8,%esp
    1f9d:	68 d3 43 00 00       	push   $0x43d3
    1fa2:	6a 01                	push   $0x1
    1fa4:	e8 b9 19 00 00       	call   3962 <printf>
    exit();
    1fa9:	e8 70 18 00 00       	call   381e <exit>
    printf(1, "create dd/ff failed\n");
    1fae:	83 ec 08             	sub    $0x8,%esp
    1fb1:	68 eb 43 00 00       	push   $0x43eb
    1fb6:	6a 01                	push   $0x1
    1fb8:	e8 a5 19 00 00       	call   3962 <printf>
    exit();
    1fbd:	e8 5c 18 00 00       	call   381e <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1fc2:	83 ec 08             	sub    $0x8,%esp
    1fc5:	68 b8 4e 00 00       	push   $0x4eb8
    1fca:	6a 01                	push   $0x1
    1fcc:	e8 91 19 00 00       	call   3962 <printf>
    exit();
    1fd1:	e8 48 18 00 00       	call   381e <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    1fd6:	83 ec 08             	sub    $0x8,%esp
    1fd9:	68 07 44 00 00       	push   $0x4407
    1fde:	6a 01                	push   $0x1
    1fe0:	e8 7d 19 00 00       	call   3962 <printf>
    exit();
    1fe5:	e8 34 18 00 00       	call   381e <exit>
    printf(1, "create dd/dd/ff failed\n");
    1fea:	83 ec 08             	sub    $0x8,%esp
    1fed:	68 2b 44 00 00       	push   $0x442b
    1ff2:	6a 01                	push   $0x1
    1ff4:	e8 69 19 00 00       	call   3962 <printf>
    exit();
    1ff9:	e8 20 18 00 00       	call   381e <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1ffe:	83 ec 08             	sub    $0x8,%esp
    2001:	68 52 44 00 00       	push   $0x4452
    2006:	6a 01                	push   $0x1
    2008:	e8 55 19 00 00       	call   3962 <printf>
    exit();
    200d:	e8 0c 18 00 00       	call   381e <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    2012:	83 ec 08             	sub    $0x8,%esp
    2015:	68 6b 44 00 00       	push   $0x446b
    201a:	6a 01                	push   $0x1
    201c:	e8 41 19 00 00       	call   3962 <printf>
    exit();
    2021:	e8 f8 17 00 00       	call   381e <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2026:	83 ec 08             	sub    $0x8,%esp
    2029:	68 e0 4e 00 00       	push   $0x4ee0
    202e:	6a 01                	push   $0x1
    2030:	e8 2d 19 00 00       	call   3962 <printf>
    exit();
    2035:	e8 e4 17 00 00       	call   381e <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    203a:	83 ec 08             	sub    $0x8,%esp
    203d:	68 91 44 00 00       	push   $0x4491
    2042:	6a 01                	push   $0x1
    2044:	e8 19 19 00 00       	call   3962 <printf>
    exit();
    2049:	e8 d0 17 00 00       	call   381e <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    204e:	83 ec 08             	sub    $0x8,%esp
    2051:	68 04 4f 00 00       	push   $0x4f04
    2056:	6a 01                	push   $0x1
    2058:	e8 05 19 00 00       	call   3962 <printf>
    exit();
    205d:	e8 bc 17 00 00       	call   381e <exit>
    printf(1, "chdir dd failed\n");
    2062:	83 ec 08             	sub    $0x8,%esp
    2065:	68 a9 44 00 00       	push   $0x44a9
    206a:	6a 01                	push   $0x1
    206c:	e8 f1 18 00 00       	call   3962 <printf>
    exit();
    2071:	e8 a8 17 00 00       	call   381e <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2076:	83 ec 08             	sub    $0x8,%esp
    2079:	68 c6 44 00 00       	push   $0x44c6
    207e:	6a 01                	push   $0x1
    2080:	e8 dd 18 00 00       	call   3962 <printf>
    exit();
    2085:	e8 94 17 00 00       	call   381e <exit>
    printf(1, "chdir dd/../../dd failed\n");
    208a:	83 ec 08             	sub    $0x8,%esp
    208d:	68 c6 44 00 00       	push   $0x44c6
    2092:	6a 01                	push   $0x1
    2094:	e8 c9 18 00 00       	call   3962 <printf>
    exit();
    2099:	e8 80 17 00 00       	call   381e <exit>
    printf(1, "chdir ./.. failed\n");
    209e:	83 ec 08             	sub    $0x8,%esp
    20a1:	68 f4 44 00 00       	push   $0x44f4
    20a6:	6a 01                	push   $0x1
    20a8:	e8 b5 18 00 00       	call   3962 <printf>
    exit();
    20ad:	e8 6c 17 00 00       	call   381e <exit>
    printf(1, "open dd/dd/ffff failed\n");
    20b2:	83 ec 08             	sub    $0x8,%esp
    20b5:	68 07 45 00 00       	push   $0x4507
    20ba:	6a 01                	push   $0x1
    20bc:	e8 a1 18 00 00       	call   3962 <printf>
    exit();
    20c1:	e8 58 17 00 00       	call   381e <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    20c6:	83 ec 08             	sub    $0x8,%esp
    20c9:	68 1f 45 00 00       	push   $0x451f
    20ce:	6a 01                	push   $0x1
    20d0:	e8 8d 18 00 00       	call   3962 <printf>
    exit();
    20d5:	e8 44 17 00 00       	call   381e <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    20da:	83 ec 08             	sub    $0x8,%esp
    20dd:	68 28 4f 00 00       	push   $0x4f28
    20e2:	6a 01                	push   $0x1
    20e4:	e8 79 18 00 00       	call   3962 <printf>
    exit();
    20e9:	e8 30 17 00 00       	call   381e <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    20ee:	83 ec 08             	sub    $0x8,%esp
    20f1:	68 43 45 00 00       	push   $0x4543
    20f6:	6a 01                	push   $0x1
    20f8:	e8 65 18 00 00       	call   3962 <printf>
    exit();
    20fd:	e8 1c 17 00 00       	call   381e <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2102:	83 ec 08             	sub    $0x8,%esp
    2105:	68 68 45 00 00       	push   $0x4568
    210a:	6a 01                	push   $0x1
    210c:	e8 51 18 00 00       	call   3962 <printf>
    exit();
    2111:	e8 08 17 00 00       	call   381e <exit>
    printf(1, "create dd succeeded!\n");
    2116:	83 ec 08             	sub    $0x8,%esp
    2119:	68 84 45 00 00       	push   $0x4584
    211e:	6a 01                	push   $0x1
    2120:	e8 3d 18 00 00       	call   3962 <printf>
    exit();
    2125:	e8 f4 16 00 00       	call   381e <exit>
    printf(1, "open dd rdwr succeeded!\n");
    212a:	83 ec 08             	sub    $0x8,%esp
    212d:	68 9a 45 00 00       	push   $0x459a
    2132:	6a 01                	push   $0x1
    2134:	e8 29 18 00 00       	call   3962 <printf>
    exit();
    2139:	e8 e0 16 00 00       	call   381e <exit>
    printf(1, "open dd wronly succeeded!\n");
    213e:	83 ec 08             	sub    $0x8,%esp
    2141:	68 b3 45 00 00       	push   $0x45b3
    2146:	6a 01                	push   $0x1
    2148:	e8 15 18 00 00       	call   3962 <printf>
    exit();
    214d:	e8 cc 16 00 00       	call   381e <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2152:	83 ec 08             	sub    $0x8,%esp
    2155:	68 50 4f 00 00       	push   $0x4f50
    215a:	6a 01                	push   $0x1
    215c:	e8 01 18 00 00       	call   3962 <printf>
    exit();
    2161:	e8 b8 16 00 00       	call   381e <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2166:	83 ec 08             	sub    $0x8,%esp
    2169:	68 74 4f 00 00       	push   $0x4f74
    216e:	6a 01                	push   $0x1
    2170:	e8 ed 17 00 00       	call   3962 <printf>
    exit();
    2175:	e8 a4 16 00 00       	call   381e <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    217a:	83 ec 08             	sub    $0x8,%esp
    217d:	68 98 4f 00 00       	push   $0x4f98
    2182:	6a 01                	push   $0x1
    2184:	e8 d9 17 00 00       	call   3962 <printf>
    exit();
    2189:	e8 90 16 00 00       	call   381e <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    218e:	83 ec 08             	sub    $0x8,%esp
    2191:	68 d7 45 00 00       	push   $0x45d7
    2196:	6a 01                	push   $0x1
    2198:	e8 c5 17 00 00       	call   3962 <printf>
    exit();
    219d:	e8 7c 16 00 00       	call   381e <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    21a2:	83 ec 08             	sub    $0x8,%esp
    21a5:	68 f2 45 00 00       	push   $0x45f2
    21aa:	6a 01                	push   $0x1
    21ac:	e8 b1 17 00 00       	call   3962 <printf>
    exit();
    21b1:	e8 68 16 00 00       	call   381e <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    21b6:	83 ec 08             	sub    $0x8,%esp
    21b9:	68 0d 46 00 00       	push   $0x460d
    21be:	6a 01                	push   $0x1
    21c0:	e8 9d 17 00 00       	call   3962 <printf>
    exit();
    21c5:	e8 54 16 00 00       	call   381e <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    21ca:	83 ec 08             	sub    $0x8,%esp
    21cd:	68 2a 46 00 00       	push   $0x462a
    21d2:	6a 01                	push   $0x1
    21d4:	e8 89 17 00 00       	call   3962 <printf>
    exit();
    21d9:	e8 40 16 00 00       	call   381e <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    21de:	83 ec 08             	sub    $0x8,%esp
    21e1:	68 46 46 00 00       	push   $0x4646
    21e6:	6a 01                	push   $0x1
    21e8:	e8 75 17 00 00       	call   3962 <printf>
    exit();
    21ed:	e8 2c 16 00 00       	call   381e <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    21f2:	83 ec 08             	sub    $0x8,%esp
    21f5:	68 62 46 00 00       	push   $0x4662
    21fa:	6a 01                	push   $0x1
    21fc:	e8 61 17 00 00       	call   3962 <printf>
    exit();
    2201:	e8 18 16 00 00       	call   381e <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2206:	83 ec 08             	sub    $0x8,%esp
    2209:	68 7a 46 00 00       	push   $0x467a
    220e:	6a 01                	push   $0x1
    2210:	e8 4d 17 00 00       	call   3962 <printf>
    exit();
    2215:	e8 04 16 00 00       	call   381e <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    221a:	83 ec 08             	sub    $0x8,%esp
    221d:	68 91 44 00 00       	push   $0x4491
    2222:	6a 01                	push   $0x1
    2224:	e8 39 17 00 00       	call   3962 <printf>
    exit();
    2229:	e8 f0 15 00 00       	call   381e <exit>
    printf(1, "unlink dd/ff failed\n");
    222e:	83 ec 08             	sub    $0x8,%esp
    2231:	68 92 46 00 00       	push   $0x4692
    2236:	6a 01                	push   $0x1
    2238:	e8 25 17 00 00       	call   3962 <printf>
    exit();
    223d:	e8 dc 15 00 00       	call   381e <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2242:	83 ec 08             	sub    $0x8,%esp
    2245:	68 bc 4f 00 00       	push   $0x4fbc
    224a:	6a 01                	push   $0x1
    224c:	e8 11 17 00 00       	call   3962 <printf>
    exit();
    2251:	e8 c8 15 00 00       	call   381e <exit>
    printf(1, "unlink dd/dd failed\n");
    2256:	83 ec 08             	sub    $0x8,%esp
    2259:	68 a7 46 00 00       	push   $0x46a7
    225e:	6a 01                	push   $0x1
    2260:	e8 fd 16 00 00       	call   3962 <printf>
    exit();
    2265:	e8 b4 15 00 00       	call   381e <exit>
    printf(1, "unlink dd failed\n");
    226a:	83 ec 08             	sub    $0x8,%esp
    226d:	68 bc 46 00 00       	push   $0x46bc
    2272:	6a 01                	push   $0x1
    2274:	e8 e9 16 00 00       	call   3962 <printf>
    exit();
    2279:	e8 a0 15 00 00       	call   381e <exit>

0000227e <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    227e:	f3 0f 1e fb          	endbr32 
    2282:	55                   	push   %ebp
    2283:	89 e5                	mov    %esp,%ebp
    2285:	57                   	push   %edi
    2286:	56                   	push   %esi
    2287:	53                   	push   %ebx
    2288:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    228b:	68 d9 46 00 00       	push   $0x46d9
    2290:	6a 01                	push   $0x1
    2292:	e8 cb 16 00 00       	call   3962 <printf>

  unlink("bigwrite");
    2297:	c7 04 24 e8 46 00 00 	movl   $0x46e8,(%esp)
    229e:	e8 cb 15 00 00       	call   386e <unlink>
    22a3:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    22a6:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    22ab:	83 ec 08             	sub    $0x8,%esp
    22ae:	68 02 02 00 00       	push   $0x202
    22b3:	68 e8 46 00 00       	push   $0x46e8
    22b8:	e8 a1 15 00 00       	call   385e <open>
    22bd:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    22bf:	83 c4 10             	add    $0x10,%esp
    22c2:	85 c0                	test   %eax,%eax
    22c4:	78 6e                	js     2334 <bigwrite+0xb6>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    22c6:	83 ec 04             	sub    $0x4,%esp
    22c9:	53                   	push   %ebx
    22ca:	68 80 84 00 00       	push   $0x8480
    22cf:	50                   	push   %eax
    22d0:	e8 69 15 00 00       	call   383e <write>
    22d5:	89 c7                	mov    %eax,%edi
      if(cc != sz){
    22d7:	83 c4 10             	add    $0x10,%esp
    22da:	39 c3                	cmp    %eax,%ebx
    22dc:	75 6e                	jne    234c <bigwrite+0xce>
      int cc = write(fd, buf, sz);
    22de:	83 ec 04             	sub    $0x4,%esp
    22e1:	53                   	push   %ebx
    22e2:	68 80 84 00 00       	push   $0x8480
    22e7:	56                   	push   %esi
    22e8:	e8 51 15 00 00       	call   383e <write>
      if(cc != sz){
    22ed:	83 c4 10             	add    $0x10,%esp
    22f0:	39 d8                	cmp    %ebx,%eax
    22f2:	75 54                	jne    2348 <bigwrite+0xca>
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    22f4:	83 ec 0c             	sub    $0xc,%esp
    22f7:	56                   	push   %esi
    22f8:	e8 49 15 00 00       	call   3846 <close>
    unlink("bigwrite");
    22fd:	c7 04 24 e8 46 00 00 	movl   $0x46e8,(%esp)
    2304:	e8 65 15 00 00       	call   386e <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2309:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    230f:	83 c4 10             	add    $0x10,%esp
    2312:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    2318:	75 91                	jne    22ab <bigwrite+0x2d>
  }

  printf(1, "bigwrite ok\n");
    231a:	83 ec 08             	sub    $0x8,%esp
    231d:	68 1b 47 00 00       	push   $0x471b
    2322:	6a 01                	push   $0x1
    2324:	e8 39 16 00 00       	call   3962 <printf>
}
    2329:	83 c4 10             	add    $0x10,%esp
    232c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    232f:	5b                   	pop    %ebx
    2330:	5e                   	pop    %esi
    2331:	5f                   	pop    %edi
    2332:	5d                   	pop    %ebp
    2333:	c3                   	ret    
      printf(1, "cannot create bigwrite\n");
    2334:	83 ec 08             	sub    $0x8,%esp
    2337:	68 f1 46 00 00       	push   $0x46f1
    233c:	6a 01                	push   $0x1
    233e:	e8 1f 16 00 00       	call   3962 <printf>
      exit();
    2343:	e8 d6 14 00 00       	call   381e <exit>
    2348:	89 fb                	mov    %edi,%ebx
      int cc = write(fd, buf, sz);
    234a:	89 c7                	mov    %eax,%edi
        printf(1, "write(%d) ret %d\n", sz, cc);
    234c:	57                   	push   %edi
    234d:	53                   	push   %ebx
    234e:	68 09 47 00 00       	push   $0x4709
    2353:	6a 01                	push   $0x1
    2355:	e8 08 16 00 00       	call   3962 <printf>
        exit();
    235a:	e8 bf 14 00 00       	call   381e <exit>

0000235f <bigfile>:

void
bigfile(void)
{
    235f:	f3 0f 1e fb          	endbr32 
    2363:	55                   	push   %ebp
    2364:	89 e5                	mov    %esp,%ebp
    2366:	57                   	push   %edi
    2367:	56                   	push   %esi
    2368:	53                   	push   %ebx
    2369:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    236c:	68 28 47 00 00       	push   $0x4728
    2371:	6a 01                	push   $0x1
    2373:	e8 ea 15 00 00       	call   3962 <printf>

  unlink("bigfile");
    2378:	c7 04 24 44 47 00 00 	movl   $0x4744,(%esp)
    237f:	e8 ea 14 00 00       	call   386e <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2384:	83 c4 08             	add    $0x8,%esp
    2387:	68 02 02 00 00       	push   $0x202
    238c:	68 44 47 00 00       	push   $0x4744
    2391:	e8 c8 14 00 00       	call   385e <open>
  if(fd < 0){
    2396:	83 c4 10             	add    $0x10,%esp
    2399:	85 c0                	test   %eax,%eax
    239b:	0f 88 c3 00 00 00    	js     2464 <bigfile+0x105>
    23a1:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    23a3:	bb 00 00 00 00       	mov    $0x0,%ebx
    memset(buf, i, 600);
    23a8:	83 ec 04             	sub    $0x4,%esp
    23ab:	68 58 02 00 00       	push   $0x258
    23b0:	53                   	push   %ebx
    23b1:	68 80 84 00 00       	push   $0x8480
    23b6:	e8 fc 12 00 00       	call   36b7 <memset>
    if(write(fd, buf, 600) != 600){
    23bb:	83 c4 0c             	add    $0xc,%esp
    23be:	68 58 02 00 00       	push   $0x258
    23c3:	68 80 84 00 00       	push   $0x8480
    23c8:	56                   	push   %esi
    23c9:	e8 70 14 00 00       	call   383e <write>
    23ce:	83 c4 10             	add    $0x10,%esp
    23d1:	3d 58 02 00 00       	cmp    $0x258,%eax
    23d6:	0f 85 9c 00 00 00    	jne    2478 <bigfile+0x119>
  for(i = 0; i < 20; i++){
    23dc:	83 c3 01             	add    $0x1,%ebx
    23df:	83 fb 14             	cmp    $0x14,%ebx
    23e2:	75 c4                	jne    23a8 <bigfile+0x49>
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    23e4:	83 ec 0c             	sub    $0xc,%esp
    23e7:	56                   	push   %esi
    23e8:	e8 59 14 00 00       	call   3846 <close>

  fd = open("bigfile", 0);
    23ed:	83 c4 08             	add    $0x8,%esp
    23f0:	6a 00                	push   $0x0
    23f2:	68 44 47 00 00       	push   $0x4744
    23f7:	e8 62 14 00 00       	call   385e <open>
    23fc:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    23fe:	83 c4 10             	add    $0x10,%esp
    2401:	85 c0                	test   %eax,%eax
    2403:	0f 88 83 00 00 00    	js     248c <bigfile+0x12d>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    2409:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    240e:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    2413:	83 ec 04             	sub    $0x4,%esp
    2416:	68 2c 01 00 00       	push   $0x12c
    241b:	68 80 84 00 00       	push   $0x8480
    2420:	57                   	push   %edi
    2421:	e8 10 14 00 00       	call   3836 <read>
    if(cc < 0){
    2426:	83 c4 10             	add    $0x10,%esp
    2429:	85 c0                	test   %eax,%eax
    242b:	78 73                	js     24a0 <bigfile+0x141>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    242d:	0f 84 a9 00 00 00    	je     24dc <bigfile+0x17d>
      break;
    if(cc != 300){
    2433:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2438:	75 7a                	jne    24b4 <bigfile+0x155>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    243a:	89 d8                	mov    %ebx,%eax
    243c:	c1 e8 1f             	shr    $0x1f,%eax
    243f:	01 d8                	add    %ebx,%eax
    2441:	d1 f8                	sar    %eax
    2443:	0f be 15 80 84 00 00 	movsbl 0x8480,%edx
    244a:	39 c2                	cmp    %eax,%edx
    244c:	75 7a                	jne    24c8 <bigfile+0x169>
    244e:	0f be 15 ab 85 00 00 	movsbl 0x85ab,%edx
    2455:	39 d0                	cmp    %edx,%eax
    2457:	75 6f                	jne    24c8 <bigfile+0x169>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2459:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    245f:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    2462:	eb af                	jmp    2413 <bigfile+0xb4>
    printf(1, "cannot create bigfile");
    2464:	83 ec 08             	sub    $0x8,%esp
    2467:	68 36 47 00 00       	push   $0x4736
    246c:	6a 01                	push   $0x1
    246e:	e8 ef 14 00 00       	call   3962 <printf>
    exit();
    2473:	e8 a6 13 00 00       	call   381e <exit>
      printf(1, "write bigfile failed\n");
    2478:	83 ec 08             	sub    $0x8,%esp
    247b:	68 4c 47 00 00       	push   $0x474c
    2480:	6a 01                	push   $0x1
    2482:	e8 db 14 00 00       	call   3962 <printf>
      exit();
    2487:	e8 92 13 00 00       	call   381e <exit>
    printf(1, "cannot open bigfile\n");
    248c:	83 ec 08             	sub    $0x8,%esp
    248f:	68 62 47 00 00       	push   $0x4762
    2494:	6a 01                	push   $0x1
    2496:	e8 c7 14 00 00       	call   3962 <printf>
    exit();
    249b:	e8 7e 13 00 00       	call   381e <exit>
      printf(1, "read bigfile failed\n");
    24a0:	83 ec 08             	sub    $0x8,%esp
    24a3:	68 77 47 00 00       	push   $0x4777
    24a8:	6a 01                	push   $0x1
    24aa:	e8 b3 14 00 00       	call   3962 <printf>
      exit();
    24af:	e8 6a 13 00 00       	call   381e <exit>
      printf(1, "short read bigfile\n");
    24b4:	83 ec 08             	sub    $0x8,%esp
    24b7:	68 8c 47 00 00       	push   $0x478c
    24bc:	6a 01                	push   $0x1
    24be:	e8 9f 14 00 00       	call   3962 <printf>
      exit();
    24c3:	e8 56 13 00 00       	call   381e <exit>
      printf(1, "read bigfile wrong data\n");
    24c8:	83 ec 08             	sub    $0x8,%esp
    24cb:	68 a0 47 00 00       	push   $0x47a0
    24d0:	6a 01                	push   $0x1
    24d2:	e8 8b 14 00 00       	call   3962 <printf>
      exit();
    24d7:	e8 42 13 00 00       	call   381e <exit>
  }
  close(fd);
    24dc:	83 ec 0c             	sub    $0xc,%esp
    24df:	57                   	push   %edi
    24e0:	e8 61 13 00 00       	call   3846 <close>
  if(total != 20*600){
    24e5:	83 c4 10             	add    $0x10,%esp
    24e8:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    24ee:	75 27                	jne    2517 <bigfile+0x1b8>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    24f0:	83 ec 0c             	sub    $0xc,%esp
    24f3:	68 44 47 00 00       	push   $0x4744
    24f8:	e8 71 13 00 00       	call   386e <unlink>

  printf(1, "bigfile test ok\n");
    24fd:	83 c4 08             	add    $0x8,%esp
    2500:	68 d3 47 00 00       	push   $0x47d3
    2505:	6a 01                	push   $0x1
    2507:	e8 56 14 00 00       	call   3962 <printf>
}
    250c:	83 c4 10             	add    $0x10,%esp
    250f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2512:	5b                   	pop    %ebx
    2513:	5e                   	pop    %esi
    2514:	5f                   	pop    %edi
    2515:	5d                   	pop    %ebp
    2516:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    2517:	83 ec 08             	sub    $0x8,%esp
    251a:	68 b9 47 00 00       	push   $0x47b9
    251f:	6a 01                	push   $0x1
    2521:	e8 3c 14 00 00       	call   3962 <printf>
    exit();
    2526:	e8 f3 12 00 00       	call   381e <exit>

0000252b <fourteen>:

void
fourteen(void)
{
    252b:	f3 0f 1e fb          	endbr32 
    252f:	55                   	push   %ebp
    2530:	89 e5                	mov    %esp,%ebp
    2532:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2535:	68 e4 47 00 00       	push   $0x47e4
    253a:	6a 01                	push   $0x1
    253c:	e8 21 14 00 00       	call   3962 <printf>

  if(mkdir("12345678901234") != 0){
    2541:	c7 04 24 1f 48 00 00 	movl   $0x481f,(%esp)
    2548:	e8 39 13 00 00       	call   3886 <mkdir>
    254d:	83 c4 10             	add    $0x10,%esp
    2550:	85 c0                	test   %eax,%eax
    2552:	0f 85 9c 00 00 00    	jne    25f4 <fourteen+0xc9>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2558:	83 ec 0c             	sub    $0xc,%esp
    255b:	68 dc 4f 00 00       	push   $0x4fdc
    2560:	e8 21 13 00 00       	call   3886 <mkdir>
    2565:	83 c4 10             	add    $0x10,%esp
    2568:	85 c0                	test   %eax,%eax
    256a:	0f 85 98 00 00 00    	jne    2608 <fourteen+0xdd>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2570:	83 ec 08             	sub    $0x8,%esp
    2573:	68 00 02 00 00       	push   $0x200
    2578:	68 2c 50 00 00       	push   $0x502c
    257d:	e8 dc 12 00 00       	call   385e <open>
  if(fd < 0){
    2582:	83 c4 10             	add    $0x10,%esp
    2585:	85 c0                	test   %eax,%eax
    2587:	0f 88 8f 00 00 00    	js     261c <fourteen+0xf1>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    258d:	83 ec 0c             	sub    $0xc,%esp
    2590:	50                   	push   %eax
    2591:	e8 b0 12 00 00       	call   3846 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2596:	83 c4 08             	add    $0x8,%esp
    2599:	6a 00                	push   $0x0
    259b:	68 9c 50 00 00       	push   $0x509c
    25a0:	e8 b9 12 00 00       	call   385e <open>
  if(fd < 0){
    25a5:	83 c4 10             	add    $0x10,%esp
    25a8:	85 c0                	test   %eax,%eax
    25aa:	0f 88 80 00 00 00    	js     2630 <fourteen+0x105>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    25b0:	83 ec 0c             	sub    $0xc,%esp
    25b3:	50                   	push   %eax
    25b4:	e8 8d 12 00 00       	call   3846 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    25b9:	c7 04 24 10 48 00 00 	movl   $0x4810,(%esp)
    25c0:	e8 c1 12 00 00       	call   3886 <mkdir>
    25c5:	83 c4 10             	add    $0x10,%esp
    25c8:	85 c0                	test   %eax,%eax
    25ca:	74 78                	je     2644 <fourteen+0x119>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    25cc:	83 ec 0c             	sub    $0xc,%esp
    25cf:	68 38 51 00 00       	push   $0x5138
    25d4:	e8 ad 12 00 00       	call   3886 <mkdir>
    25d9:	83 c4 10             	add    $0x10,%esp
    25dc:	85 c0                	test   %eax,%eax
    25de:	74 78                	je     2658 <fourteen+0x12d>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    25e0:	83 ec 08             	sub    $0x8,%esp
    25e3:	68 2e 48 00 00       	push   $0x482e
    25e8:	6a 01                	push   $0x1
    25ea:	e8 73 13 00 00       	call   3962 <printf>
}
    25ef:	83 c4 10             	add    $0x10,%esp
    25f2:	c9                   	leave  
    25f3:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    25f4:	83 ec 08             	sub    $0x8,%esp
    25f7:	68 f3 47 00 00       	push   $0x47f3
    25fc:	6a 01                	push   $0x1
    25fe:	e8 5f 13 00 00       	call   3962 <printf>
    exit();
    2603:	e8 16 12 00 00       	call   381e <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2608:	83 ec 08             	sub    $0x8,%esp
    260b:	68 fc 4f 00 00       	push   $0x4ffc
    2610:	6a 01                	push   $0x1
    2612:	e8 4b 13 00 00       	call   3962 <printf>
    exit();
    2617:	e8 02 12 00 00       	call   381e <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    261c:	83 ec 08             	sub    $0x8,%esp
    261f:	68 5c 50 00 00       	push   $0x505c
    2624:	6a 01                	push   $0x1
    2626:	e8 37 13 00 00       	call   3962 <printf>
    exit();
    262b:	e8 ee 11 00 00       	call   381e <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2630:	83 ec 08             	sub    $0x8,%esp
    2633:	68 cc 50 00 00       	push   $0x50cc
    2638:	6a 01                	push   $0x1
    263a:	e8 23 13 00 00       	call   3962 <printf>
    exit();
    263f:	e8 da 11 00 00       	call   381e <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2644:	83 ec 08             	sub    $0x8,%esp
    2647:	68 08 51 00 00       	push   $0x5108
    264c:	6a 01                	push   $0x1
    264e:	e8 0f 13 00 00       	call   3962 <printf>
    exit();
    2653:	e8 c6 11 00 00       	call   381e <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2658:	83 ec 08             	sub    $0x8,%esp
    265b:	68 58 51 00 00       	push   $0x5158
    2660:	6a 01                	push   $0x1
    2662:	e8 fb 12 00 00       	call   3962 <printf>
    exit();
    2667:	e8 b2 11 00 00       	call   381e <exit>

0000266c <rmdot>:

void
rmdot(void)
{
    266c:	f3 0f 1e fb          	endbr32 
    2670:	55                   	push   %ebp
    2671:	89 e5                	mov    %esp,%ebp
    2673:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2676:	68 3b 48 00 00       	push   $0x483b
    267b:	6a 01                	push   $0x1
    267d:	e8 e0 12 00 00       	call   3962 <printf>
  if(mkdir("dots") != 0){
    2682:	c7 04 24 47 48 00 00 	movl   $0x4847,(%esp)
    2689:	e8 f8 11 00 00       	call   3886 <mkdir>
    268e:	83 c4 10             	add    $0x10,%esp
    2691:	85 c0                	test   %eax,%eax
    2693:	0f 85 bc 00 00 00    	jne    2755 <rmdot+0xe9>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    2699:	83 ec 0c             	sub    $0xc,%esp
    269c:	68 47 48 00 00       	push   $0x4847
    26a1:	e8 e8 11 00 00       	call   388e <chdir>
    26a6:	83 c4 10             	add    $0x10,%esp
    26a9:	85 c0                	test   %eax,%eax
    26ab:	0f 85 b8 00 00 00    	jne    2769 <rmdot+0xfd>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    26b1:	83 ec 0c             	sub    $0xc,%esp
    26b4:	68 f2 44 00 00       	push   $0x44f2
    26b9:	e8 b0 11 00 00       	call   386e <unlink>
    26be:	83 c4 10             	add    $0x10,%esp
    26c1:	85 c0                	test   %eax,%eax
    26c3:	0f 84 b4 00 00 00    	je     277d <rmdot+0x111>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    26c9:	83 ec 0c             	sub    $0xc,%esp
    26cc:	68 f1 44 00 00       	push   $0x44f1
    26d1:	e8 98 11 00 00       	call   386e <unlink>
    26d6:	83 c4 10             	add    $0x10,%esp
    26d9:	85 c0                	test   %eax,%eax
    26db:	0f 84 b0 00 00 00    	je     2791 <rmdot+0x125>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    26e1:	83 ec 0c             	sub    $0xc,%esp
    26e4:	68 c5 3c 00 00       	push   $0x3cc5
    26e9:	e8 a0 11 00 00       	call   388e <chdir>
    26ee:	83 c4 10             	add    $0x10,%esp
    26f1:	85 c0                	test   %eax,%eax
    26f3:	0f 85 ac 00 00 00    	jne    27a5 <rmdot+0x139>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    26f9:	83 ec 0c             	sub    $0xc,%esp
    26fc:	68 8f 48 00 00       	push   $0x488f
    2701:	e8 68 11 00 00       	call   386e <unlink>
    2706:	83 c4 10             	add    $0x10,%esp
    2709:	85 c0                	test   %eax,%eax
    270b:	0f 84 a8 00 00 00    	je     27b9 <rmdot+0x14d>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    2711:	83 ec 0c             	sub    $0xc,%esp
    2714:	68 ad 48 00 00       	push   $0x48ad
    2719:	e8 50 11 00 00       	call   386e <unlink>
    271e:	83 c4 10             	add    $0x10,%esp
    2721:	85 c0                	test   %eax,%eax
    2723:	0f 84 a4 00 00 00    	je     27cd <rmdot+0x161>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    2729:	83 ec 0c             	sub    $0xc,%esp
    272c:	68 47 48 00 00       	push   $0x4847
    2731:	e8 38 11 00 00       	call   386e <unlink>
    2736:	83 c4 10             	add    $0x10,%esp
    2739:	85 c0                	test   %eax,%eax
    273b:	0f 85 a0 00 00 00    	jne    27e1 <rmdot+0x175>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    2741:	83 ec 08             	sub    $0x8,%esp
    2744:	68 e2 48 00 00       	push   $0x48e2
    2749:	6a 01                	push   $0x1
    274b:	e8 12 12 00 00       	call   3962 <printf>
}
    2750:	83 c4 10             	add    $0x10,%esp
    2753:	c9                   	leave  
    2754:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2755:	83 ec 08             	sub    $0x8,%esp
    2758:	68 4c 48 00 00       	push   $0x484c
    275d:	6a 01                	push   $0x1
    275f:	e8 fe 11 00 00       	call   3962 <printf>
    exit();
    2764:	e8 b5 10 00 00       	call   381e <exit>
    printf(1, "chdir dots failed\n");
    2769:	83 ec 08             	sub    $0x8,%esp
    276c:	68 5f 48 00 00       	push   $0x485f
    2771:	6a 01                	push   $0x1
    2773:	e8 ea 11 00 00       	call   3962 <printf>
    exit();
    2778:	e8 a1 10 00 00       	call   381e <exit>
    printf(1, "rm . worked!\n");
    277d:	83 ec 08             	sub    $0x8,%esp
    2780:	68 72 48 00 00       	push   $0x4872
    2785:	6a 01                	push   $0x1
    2787:	e8 d6 11 00 00       	call   3962 <printf>
    exit();
    278c:	e8 8d 10 00 00       	call   381e <exit>
    printf(1, "rm .. worked!\n");
    2791:	83 ec 08             	sub    $0x8,%esp
    2794:	68 80 48 00 00       	push   $0x4880
    2799:	6a 01                	push   $0x1
    279b:	e8 c2 11 00 00       	call   3962 <printf>
    exit();
    27a0:	e8 79 10 00 00       	call   381e <exit>
    printf(1, "chdir / failed\n");
    27a5:	83 ec 08             	sub    $0x8,%esp
    27a8:	68 c7 3c 00 00       	push   $0x3cc7
    27ad:	6a 01                	push   $0x1
    27af:	e8 ae 11 00 00       	call   3962 <printf>
    exit();
    27b4:	e8 65 10 00 00       	call   381e <exit>
    printf(1, "unlink dots/. worked!\n");
    27b9:	83 ec 08             	sub    $0x8,%esp
    27bc:	68 96 48 00 00       	push   $0x4896
    27c1:	6a 01                	push   $0x1
    27c3:	e8 9a 11 00 00       	call   3962 <printf>
    exit();
    27c8:	e8 51 10 00 00       	call   381e <exit>
    printf(1, "unlink dots/.. worked!\n");
    27cd:	83 ec 08             	sub    $0x8,%esp
    27d0:	68 b5 48 00 00       	push   $0x48b5
    27d5:	6a 01                	push   $0x1
    27d7:	e8 86 11 00 00       	call   3962 <printf>
    exit();
    27dc:	e8 3d 10 00 00       	call   381e <exit>
    printf(1, "unlink dots failed!\n");
    27e1:	83 ec 08             	sub    $0x8,%esp
    27e4:	68 cd 48 00 00       	push   $0x48cd
    27e9:	6a 01                	push   $0x1
    27eb:	e8 72 11 00 00       	call   3962 <printf>
    exit();
    27f0:	e8 29 10 00 00       	call   381e <exit>

000027f5 <dirfile>:

void
dirfile(void)
{
    27f5:	f3 0f 1e fb          	endbr32 
    27f9:	55                   	push   %ebp
    27fa:	89 e5                	mov    %esp,%ebp
    27fc:	53                   	push   %ebx
    27fd:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2800:	68 ec 48 00 00       	push   $0x48ec
    2805:	6a 01                	push   $0x1
    2807:	e8 56 11 00 00       	call   3962 <printf>

  fd = open("dirfile", O_CREATE);
    280c:	83 c4 08             	add    $0x8,%esp
    280f:	68 00 02 00 00       	push   $0x200
    2814:	68 f9 48 00 00       	push   $0x48f9
    2819:	e8 40 10 00 00       	call   385e <open>
  if(fd < 0){
    281e:	83 c4 10             	add    $0x10,%esp
    2821:	85 c0                	test   %eax,%eax
    2823:	0f 88 22 01 00 00    	js     294b <dirfile+0x156>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    2829:	83 ec 0c             	sub    $0xc,%esp
    282c:	50                   	push   %eax
    282d:	e8 14 10 00 00       	call   3846 <close>
  if(chdir("dirfile") == 0){
    2832:	c7 04 24 f9 48 00 00 	movl   $0x48f9,(%esp)
    2839:	e8 50 10 00 00       	call   388e <chdir>
    283e:	83 c4 10             	add    $0x10,%esp
    2841:	85 c0                	test   %eax,%eax
    2843:	0f 84 16 01 00 00    	je     295f <dirfile+0x16a>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    2849:	83 ec 08             	sub    $0x8,%esp
    284c:	6a 00                	push   $0x0
    284e:	68 32 49 00 00       	push   $0x4932
    2853:	e8 06 10 00 00       	call   385e <open>
  if(fd >= 0){
    2858:	83 c4 10             	add    $0x10,%esp
    285b:	85 c0                	test   %eax,%eax
    285d:	0f 89 10 01 00 00    	jns    2973 <dirfile+0x17e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2863:	83 ec 08             	sub    $0x8,%esp
    2866:	68 00 02 00 00       	push   $0x200
    286b:	68 32 49 00 00       	push   $0x4932
    2870:	e8 e9 0f 00 00       	call   385e <open>
  if(fd >= 0){
    2875:	83 c4 10             	add    $0x10,%esp
    2878:	85 c0                	test   %eax,%eax
    287a:	0f 89 07 01 00 00    	jns    2987 <dirfile+0x192>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2880:	83 ec 0c             	sub    $0xc,%esp
    2883:	68 32 49 00 00       	push   $0x4932
    2888:	e8 f9 0f 00 00       	call   3886 <mkdir>
    288d:	83 c4 10             	add    $0x10,%esp
    2890:	85 c0                	test   %eax,%eax
    2892:	0f 84 03 01 00 00    	je     299b <dirfile+0x1a6>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    2898:	83 ec 0c             	sub    $0xc,%esp
    289b:	68 32 49 00 00       	push   $0x4932
    28a0:	e8 c9 0f 00 00       	call   386e <unlink>
    28a5:	83 c4 10             	add    $0x10,%esp
    28a8:	85 c0                	test   %eax,%eax
    28aa:	0f 84 ff 00 00 00    	je     29af <dirfile+0x1ba>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    28b0:	83 ec 08             	sub    $0x8,%esp
    28b3:	68 32 49 00 00       	push   $0x4932
    28b8:	68 96 49 00 00       	push   $0x4996
    28bd:	e8 bc 0f 00 00       	call   387e <link>
    28c2:	83 c4 10             	add    $0x10,%esp
    28c5:	85 c0                	test   %eax,%eax
    28c7:	0f 84 f6 00 00 00    	je     29c3 <dirfile+0x1ce>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    28cd:	83 ec 0c             	sub    $0xc,%esp
    28d0:	68 f9 48 00 00       	push   $0x48f9
    28d5:	e8 94 0f 00 00       	call   386e <unlink>
    28da:	83 c4 10             	add    $0x10,%esp
    28dd:	85 c0                	test   %eax,%eax
    28df:	0f 85 f2 00 00 00    	jne    29d7 <dirfile+0x1e2>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    28e5:	83 ec 08             	sub    $0x8,%esp
    28e8:	6a 02                	push   $0x2
    28ea:	68 f2 44 00 00       	push   $0x44f2
    28ef:	e8 6a 0f 00 00       	call   385e <open>
  if(fd >= 0){
    28f4:	83 c4 10             	add    $0x10,%esp
    28f7:	85 c0                	test   %eax,%eax
    28f9:	0f 89 ec 00 00 00    	jns    29eb <dirfile+0x1f6>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    28ff:	83 ec 08             	sub    $0x8,%esp
    2902:	6a 00                	push   $0x0
    2904:	68 f2 44 00 00       	push   $0x44f2
    2909:	e8 50 0f 00 00       	call   385e <open>
    290e:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2910:	83 c4 0c             	add    $0xc,%esp
    2913:	6a 01                	push   $0x1
    2915:	68 d5 45 00 00       	push   $0x45d5
    291a:	50                   	push   %eax
    291b:	e8 1e 0f 00 00       	call   383e <write>
    2920:	83 c4 10             	add    $0x10,%esp
    2923:	85 c0                	test   %eax,%eax
    2925:	0f 8f d4 00 00 00    	jg     29ff <dirfile+0x20a>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    292b:	83 ec 0c             	sub    $0xc,%esp
    292e:	53                   	push   %ebx
    292f:	e8 12 0f 00 00       	call   3846 <close>

  printf(1, "dir vs file OK\n");
    2934:	83 c4 08             	add    $0x8,%esp
    2937:	68 c9 49 00 00       	push   $0x49c9
    293c:	6a 01                	push   $0x1
    293e:	e8 1f 10 00 00       	call   3962 <printf>
}
    2943:	83 c4 10             	add    $0x10,%esp
    2946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2949:	c9                   	leave  
    294a:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    294b:	83 ec 08             	sub    $0x8,%esp
    294e:	68 01 49 00 00       	push   $0x4901
    2953:	6a 01                	push   $0x1
    2955:	e8 08 10 00 00       	call   3962 <printf>
    exit();
    295a:	e8 bf 0e 00 00       	call   381e <exit>
    printf(1, "chdir dirfile succeeded!\n");
    295f:	83 ec 08             	sub    $0x8,%esp
    2962:	68 18 49 00 00       	push   $0x4918
    2967:	6a 01                	push   $0x1
    2969:	e8 f4 0f 00 00       	call   3962 <printf>
    exit();
    296e:	e8 ab 0e 00 00       	call   381e <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2973:	83 ec 08             	sub    $0x8,%esp
    2976:	68 3d 49 00 00       	push   $0x493d
    297b:	6a 01                	push   $0x1
    297d:	e8 e0 0f 00 00       	call   3962 <printf>
    exit();
    2982:	e8 97 0e 00 00       	call   381e <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2987:	83 ec 08             	sub    $0x8,%esp
    298a:	68 3d 49 00 00       	push   $0x493d
    298f:	6a 01                	push   $0x1
    2991:	e8 cc 0f 00 00       	call   3962 <printf>
    exit();
    2996:	e8 83 0e 00 00       	call   381e <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    299b:	83 ec 08             	sub    $0x8,%esp
    299e:	68 5b 49 00 00       	push   $0x495b
    29a3:	6a 01                	push   $0x1
    29a5:	e8 b8 0f 00 00       	call   3962 <printf>
    exit();
    29aa:	e8 6f 0e 00 00       	call   381e <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    29af:	83 ec 08             	sub    $0x8,%esp
    29b2:	68 78 49 00 00       	push   $0x4978
    29b7:	6a 01                	push   $0x1
    29b9:	e8 a4 0f 00 00       	call   3962 <printf>
    exit();
    29be:	e8 5b 0e 00 00       	call   381e <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    29c3:	83 ec 08             	sub    $0x8,%esp
    29c6:	68 8c 51 00 00       	push   $0x518c
    29cb:	6a 01                	push   $0x1
    29cd:	e8 90 0f 00 00       	call   3962 <printf>
    exit();
    29d2:	e8 47 0e 00 00       	call   381e <exit>
    printf(1, "unlink dirfile failed!\n");
    29d7:	83 ec 08             	sub    $0x8,%esp
    29da:	68 9d 49 00 00       	push   $0x499d
    29df:	6a 01                	push   $0x1
    29e1:	e8 7c 0f 00 00       	call   3962 <printf>
    exit();
    29e6:	e8 33 0e 00 00       	call   381e <exit>
    printf(1, "open . for writing succeeded!\n");
    29eb:	83 ec 08             	sub    $0x8,%esp
    29ee:	68 ac 51 00 00       	push   $0x51ac
    29f3:	6a 01                	push   $0x1
    29f5:	e8 68 0f 00 00       	call   3962 <printf>
    exit();
    29fa:	e8 1f 0e 00 00       	call   381e <exit>
    printf(1, "write . succeeded!\n");
    29ff:	83 ec 08             	sub    $0x8,%esp
    2a02:	68 b5 49 00 00       	push   $0x49b5
    2a07:	6a 01                	push   $0x1
    2a09:	e8 54 0f 00 00       	call   3962 <printf>
    exit();
    2a0e:	e8 0b 0e 00 00       	call   381e <exit>

00002a13 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2a13:	f3 0f 1e fb          	endbr32 
    2a17:	55                   	push   %ebp
    2a18:	89 e5                	mov    %esp,%ebp
    2a1a:	53                   	push   %ebx
    2a1b:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2a1e:	68 d9 49 00 00       	push   $0x49d9
    2a23:	6a 01                	push   $0x1
    2a25:	e8 38 0f 00 00       	call   3962 <printf>
    2a2a:	83 c4 10             	add    $0x10,%esp
    2a2d:	bb 33 00 00 00       	mov    $0x33,%ebx
    2a32:	eb 4f                	jmp    2a83 <iref+0x70>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    2a34:	83 ec 08             	sub    $0x8,%esp
    2a37:	68 f0 49 00 00       	push   $0x49f0
    2a3c:	6a 01                	push   $0x1
    2a3e:	e8 1f 0f 00 00       	call   3962 <printf>
      exit();
    2a43:	e8 d6 0d 00 00       	call   381e <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    2a48:	83 ec 08             	sub    $0x8,%esp
    2a4b:	68 04 4a 00 00       	push   $0x4a04
    2a50:	6a 01                	push   $0x1
    2a52:	e8 0b 0f 00 00       	call   3962 <printf>
      exit();
    2a57:	e8 c2 0d 00 00       	call   381e <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    2a5c:	83 ec 0c             	sub    $0xc,%esp
    2a5f:	50                   	push   %eax
    2a60:	e8 e1 0d 00 00       	call   3846 <close>
    2a65:	83 c4 10             	add    $0x10,%esp
    2a68:	eb 7d                	jmp    2ae7 <iref+0xd4>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2a6a:	83 ec 0c             	sub    $0xc,%esp
    2a6d:	68 d4 45 00 00       	push   $0x45d4
    2a72:	e8 f7 0d 00 00       	call   386e <unlink>
  for(i = 0; i < 50 + 1; i++){
    2a77:	83 c4 10             	add    $0x10,%esp
    2a7a:	83 eb 01             	sub    $0x1,%ebx
    2a7d:	0f 84 92 00 00 00    	je     2b15 <iref+0x102>
    if(mkdir("irefd") != 0){
    2a83:	83 ec 0c             	sub    $0xc,%esp
    2a86:	68 ea 49 00 00       	push   $0x49ea
    2a8b:	e8 f6 0d 00 00       	call   3886 <mkdir>
    2a90:	83 c4 10             	add    $0x10,%esp
    2a93:	85 c0                	test   %eax,%eax
    2a95:	75 9d                	jne    2a34 <iref+0x21>
    if(chdir("irefd") != 0){
    2a97:	83 ec 0c             	sub    $0xc,%esp
    2a9a:	68 ea 49 00 00       	push   $0x49ea
    2a9f:	e8 ea 0d 00 00       	call   388e <chdir>
    2aa4:	83 c4 10             	add    $0x10,%esp
    2aa7:	85 c0                	test   %eax,%eax
    2aa9:	75 9d                	jne    2a48 <iref+0x35>
    mkdir("");
    2aab:	83 ec 0c             	sub    $0xc,%esp
    2aae:	68 9f 40 00 00       	push   $0x409f
    2ab3:	e8 ce 0d 00 00       	call   3886 <mkdir>
    link("README", "");
    2ab8:	83 c4 08             	add    $0x8,%esp
    2abb:	68 9f 40 00 00       	push   $0x409f
    2ac0:	68 96 49 00 00       	push   $0x4996
    2ac5:	e8 b4 0d 00 00       	call   387e <link>
    fd = open("", O_CREATE);
    2aca:	83 c4 08             	add    $0x8,%esp
    2acd:	68 00 02 00 00       	push   $0x200
    2ad2:	68 9f 40 00 00       	push   $0x409f
    2ad7:	e8 82 0d 00 00       	call   385e <open>
    if(fd >= 0)
    2adc:	83 c4 10             	add    $0x10,%esp
    2adf:	85 c0                	test   %eax,%eax
    2ae1:	0f 89 75 ff ff ff    	jns    2a5c <iref+0x49>
    fd = open("xx", O_CREATE);
    2ae7:	83 ec 08             	sub    $0x8,%esp
    2aea:	68 00 02 00 00       	push   $0x200
    2aef:	68 d4 45 00 00       	push   $0x45d4
    2af4:	e8 65 0d 00 00       	call   385e <open>
    if(fd >= 0)
    2af9:	83 c4 10             	add    $0x10,%esp
    2afc:	85 c0                	test   %eax,%eax
    2afe:	0f 88 66 ff ff ff    	js     2a6a <iref+0x57>
      close(fd);
    2b04:	83 ec 0c             	sub    $0xc,%esp
    2b07:	50                   	push   %eax
    2b08:	e8 39 0d 00 00       	call   3846 <close>
    2b0d:	83 c4 10             	add    $0x10,%esp
    2b10:	e9 55 ff ff ff       	jmp    2a6a <iref+0x57>
  }

  chdir("/");
    2b15:	83 ec 0c             	sub    $0xc,%esp
    2b18:	68 c5 3c 00 00       	push   $0x3cc5
    2b1d:	e8 6c 0d 00 00       	call   388e <chdir>
  printf(1, "empty file name OK\n");
    2b22:	83 c4 08             	add    $0x8,%esp
    2b25:	68 18 4a 00 00       	push   $0x4a18
    2b2a:	6a 01                	push   $0x1
    2b2c:	e8 31 0e 00 00       	call   3962 <printf>
}
    2b31:	83 c4 10             	add    $0x10,%esp
    2b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b37:	c9                   	leave  
    2b38:	c3                   	ret    

00002b39 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2b39:	f3 0f 1e fb          	endbr32 
    2b3d:	55                   	push   %ebp
    2b3e:	89 e5                	mov    %esp,%ebp
    2b40:	53                   	push   %ebx
    2b41:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2b44:	68 2c 4a 00 00       	push   $0x4a2c
    2b49:	6a 01                	push   $0x1
    2b4b:	e8 12 0e 00 00       	call   3962 <printf>
    2b50:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2b53:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    2b58:	e8 b9 0c 00 00       	call   3816 <fork>
    if(pid < 0)
    2b5d:	85 c0                	test   %eax,%eax
    2b5f:	78 26                	js     2b87 <forktest+0x4e>
      break;
    if(pid == 0)
    2b61:	74 1f                	je     2b82 <forktest+0x49>
  for(n=0; n<1000; n++){
    2b63:	83 c3 01             	add    $0x1,%ebx
    2b66:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b6c:	75 ea                	jne    2b58 <forktest+0x1f>
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    2b6e:	83 ec 08             	sub    $0x8,%esp
    2b71:	68 cc 51 00 00       	push   $0x51cc
    2b76:	6a 01                	push   $0x1
    2b78:	e8 e5 0d 00 00       	call   3962 <printf>
    exit();
    2b7d:	e8 9c 0c 00 00       	call   381e <exit>
      exit();
    2b82:	e8 97 0c 00 00       	call   381e <exit>
  if(n == 1000){
    2b87:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b8d:	74 df                	je     2b6e <forktest+0x35>
  }

  for(; n > 0; n--){
    2b8f:	85 db                	test   %ebx,%ebx
    2b91:	7e 0e                	jle    2ba1 <forktest+0x68>
    if(wait() < 0){
    2b93:	e8 8e 0c 00 00       	call   3826 <wait>
    2b98:	85 c0                	test   %eax,%eax
    2b9a:	78 26                	js     2bc2 <forktest+0x89>
  for(; n > 0; n--){
    2b9c:	83 eb 01             	sub    $0x1,%ebx
    2b9f:	75 f2                	jne    2b93 <forktest+0x5a>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    2ba1:	e8 80 0c 00 00       	call   3826 <wait>
    2ba6:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ba9:	75 2b                	jne    2bd6 <forktest+0x9d>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    2bab:	83 ec 08             	sub    $0x8,%esp
    2bae:	68 5e 4a 00 00       	push   $0x4a5e
    2bb3:	6a 01                	push   $0x1
    2bb5:	e8 a8 0d 00 00       	call   3962 <printf>
}
    2bba:	83 c4 10             	add    $0x10,%esp
    2bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2bc0:	c9                   	leave  
    2bc1:	c3                   	ret    
      printf(1, "wait stopped early\n");
    2bc2:	83 ec 08             	sub    $0x8,%esp
    2bc5:	68 37 4a 00 00       	push   $0x4a37
    2bca:	6a 01                	push   $0x1
    2bcc:	e8 91 0d 00 00       	call   3962 <printf>
      exit();
    2bd1:	e8 48 0c 00 00       	call   381e <exit>
    printf(1, "wait got too many\n");
    2bd6:	83 ec 08             	sub    $0x8,%esp
    2bd9:	68 4b 4a 00 00       	push   $0x4a4b
    2bde:	6a 01                	push   $0x1
    2be0:	e8 7d 0d 00 00       	call   3962 <printf>
    exit();
    2be5:	e8 34 0c 00 00       	call   381e <exit>

00002bea <sbrktest>:

void
sbrktest(void)
{
    2bea:	f3 0f 1e fb          	endbr32 
    2bee:	55                   	push   %ebp
    2bef:	89 e5                	mov    %esp,%ebp
    2bf1:	57                   	push   %edi
    2bf2:	56                   	push   %esi
    2bf3:	53                   	push   %ebx
    2bf4:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2bf7:	68 6c 4a 00 00       	push   $0x4a6c
    2bfc:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2c02:	e8 5b 0d 00 00       	call   3962 <printf>
  oldbrk = sbrk(0);
    2c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2c0e:	e8 93 0c 00 00       	call   38a6 <sbrk>
    2c13:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2c16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2c1d:	e8 84 0c 00 00       	call   38a6 <sbrk>
    2c22:	89 c3                	mov    %eax,%ebx
    2c24:	83 c4 10             	add    $0x10,%esp
  int i;
  for(i = 0; i < 5000; i++){
    2c27:	be 00 00 00 00       	mov    $0x0,%esi
    2c2c:	eb 02                	jmp    2c30 <sbrktest+0x46>
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    a = b + 1;
    2c2e:	89 c3                	mov    %eax,%ebx
    b = sbrk(1);
    2c30:	83 ec 0c             	sub    $0xc,%esp
    2c33:	6a 01                	push   $0x1
    2c35:	e8 6c 0c 00 00       	call   38a6 <sbrk>
    if(b != a){
    2c3a:	83 c4 10             	add    $0x10,%esp
    2c3d:	39 d8                	cmp    %ebx,%eax
    2c3f:	0f 85 90 01 00 00    	jne    2dd5 <sbrktest+0x1eb>
    *b = 1;
    2c45:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    2c48:	8d 43 01             	lea    0x1(%ebx),%eax
  for(i = 0; i < 5000; i++){
    2c4b:	83 c6 01             	add    $0x1,%esi
    2c4e:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    2c54:	75 d8                	jne    2c2e <sbrktest+0x44>
  }
  pid = fork();
    2c56:	e8 bb 0b 00 00       	call   3816 <fork>
    2c5b:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    2c5d:	85 c0                	test   %eax,%eax
    2c5f:	0f 88 8e 01 00 00    	js     2df3 <sbrktest+0x209>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    2c65:	83 ec 0c             	sub    $0xc,%esp
    2c68:	6a 01                	push   $0x1
    2c6a:	e8 37 0c 00 00       	call   38a6 <sbrk>
  c = sbrk(1);
    2c6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c76:	e8 2b 0c 00 00       	call   38a6 <sbrk>
  if(c != a + 1){
    2c7b:	83 c3 02             	add    $0x2,%ebx
    2c7e:	83 c4 10             	add    $0x10,%esp
    2c81:	39 c3                	cmp    %eax,%ebx
    2c83:	0f 85 82 01 00 00    	jne    2e0b <sbrktest+0x221>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    2c89:	85 f6                	test   %esi,%esi
    2c8b:	0f 84 92 01 00 00    	je     2e23 <sbrktest+0x239>
    exit();
  wait();
    2c91:	e8 90 0b 00 00       	call   3826 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2c96:	83 ec 0c             	sub    $0xc,%esp
    2c99:	6a 00                	push   $0x0
    2c9b:	e8 06 0c 00 00       	call   38a6 <sbrk>
    2ca0:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2ca2:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2ca7:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    2ca9:	89 04 24             	mov    %eax,(%esp)
    2cac:	e8 f5 0b 00 00       	call   38a6 <sbrk>
  if (p != a) {
    2cb1:	83 c4 10             	add    $0x10,%esp
    2cb4:	39 c3                	cmp    %eax,%ebx
    2cb6:	0f 85 6c 01 00 00    	jne    2e28 <sbrktest+0x23e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2cbc:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2cc3:	83 ec 0c             	sub    $0xc,%esp
    2cc6:	6a 00                	push   $0x0
    2cc8:	e8 d9 0b 00 00       	call   38a6 <sbrk>
    2ccd:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2ccf:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2cd6:	e8 cb 0b 00 00       	call   38a6 <sbrk>
  if(c == (char*)0xffffffff){
    2cdb:	83 c4 10             	add    $0x10,%esp
    2cde:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ce1:	0f 84 59 01 00 00    	je     2e40 <sbrktest+0x256>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2ce7:	83 ec 0c             	sub    $0xc,%esp
    2cea:	6a 00                	push   $0x0
    2cec:	e8 b5 0b 00 00       	call   38a6 <sbrk>
  if(c != a - 4096){
    2cf1:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2cf7:	83 c4 10             	add    $0x10,%esp
    2cfa:	39 d0                	cmp    %edx,%eax
    2cfc:	0f 85 56 01 00 00    	jne    2e58 <sbrktest+0x26e>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2d02:	83 ec 0c             	sub    $0xc,%esp
    2d05:	6a 00                	push   $0x0
    2d07:	e8 9a 0b 00 00       	call   38a6 <sbrk>
    2d0c:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2d0e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2d15:	e8 8c 0b 00 00       	call   38a6 <sbrk>
    2d1a:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2d1c:	83 c4 10             	add    $0x10,%esp
    2d1f:	39 c3                	cmp    %eax,%ebx
    2d21:	0f 85 48 01 00 00    	jne    2e6f <sbrktest+0x285>
    2d27:	83 ec 0c             	sub    $0xc,%esp
    2d2a:	6a 00                	push   $0x0
    2d2c:	e8 75 0b 00 00       	call   38a6 <sbrk>
    2d31:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2d37:	83 c4 10             	add    $0x10,%esp
    2d3a:	39 c2                	cmp    %eax,%edx
    2d3c:	0f 85 2d 01 00 00    	jne    2e6f <sbrktest+0x285>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2d42:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2d49:	0f 84 37 01 00 00    	je     2e86 <sbrktest+0x29c>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    2d4f:	83 ec 0c             	sub    $0xc,%esp
    2d52:	6a 00                	push   $0x0
    2d54:	e8 4d 0b 00 00       	call   38a6 <sbrk>
    2d59:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2d5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d62:	e8 3f 0b 00 00       	call   38a6 <sbrk>
    2d67:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
    2d6a:	29 c1                	sub    %eax,%ecx
    2d6c:	89 0c 24             	mov    %ecx,(%esp)
    2d6f:	e8 32 0b 00 00       	call   38a6 <sbrk>
  if(c != a){
    2d74:	83 c4 10             	add    $0x10,%esp
    2d77:	39 c3                	cmp    %eax,%ebx
    2d79:	0f 85 1f 01 00 00    	jne    2e9e <sbrktest+0x2b4>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d7f:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    ppid = getpid();
    2d84:	e8 15 0b 00 00       	call   389e <getpid>
    2d89:	89 c6                	mov    %eax,%esi
    pid = fork();
    2d8b:	e8 86 0a 00 00       	call   3816 <fork>
    if(pid < 0){
    2d90:	85 c0                	test   %eax,%eax
    2d92:	0f 88 1d 01 00 00    	js     2eb5 <sbrktest+0x2cb>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    2d98:	0f 84 2f 01 00 00    	je     2ecd <sbrktest+0x2e3>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    2d9e:	e8 83 0a 00 00       	call   3826 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2da3:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2da9:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    2daf:	75 d3                	jne    2d84 <sbrktest+0x19a>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2db1:	83 ec 0c             	sub    $0xc,%esp
    2db4:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2db7:	50                   	push   %eax
    2db8:	e8 71 0a 00 00       	call   382e <pipe>
    2dbd:	83 c4 10             	add    $0x10,%esp
    2dc0:	85 c0                	test   %eax,%eax
    2dc2:	0f 85 27 01 00 00    	jne    2eef <sbrktest+0x305>
    2dc8:	8d 5d b8             	lea    -0x48(%ebp),%ebx
    2dcb:	8d 7d e0             	lea    -0x20(%ebp),%edi
    2dce:	89 de                	mov    %ebx,%esi
    2dd0:	e9 77 01 00 00       	jmp    2f4c <sbrktest+0x362>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2dd5:	83 ec 0c             	sub    $0xc,%esp
    2dd8:	50                   	push   %eax
    2dd9:	53                   	push   %ebx
    2dda:	56                   	push   %esi
    2ddb:	68 77 4a 00 00       	push   $0x4a77
    2de0:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2de6:	e8 77 0b 00 00       	call   3962 <printf>
      exit();
    2deb:	83 c4 20             	add    $0x20,%esp
    2dee:	e8 2b 0a 00 00       	call   381e <exit>
    printf(stdout, "sbrk test fork failed\n");
    2df3:	83 ec 08             	sub    $0x8,%esp
    2df6:	68 92 4a 00 00       	push   $0x4a92
    2dfb:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e01:	e8 5c 0b 00 00       	call   3962 <printf>
    exit();
    2e06:	e8 13 0a 00 00       	call   381e <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2e0b:	83 ec 08             	sub    $0x8,%esp
    2e0e:	68 a9 4a 00 00       	push   $0x4aa9
    2e13:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e19:	e8 44 0b 00 00       	call   3962 <printf>
    exit();
    2e1e:	e8 fb 09 00 00       	call   381e <exit>
    exit();
    2e23:	e8 f6 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2e28:	83 ec 08             	sub    $0x8,%esp
    2e2b:	68 f0 51 00 00       	push   $0x51f0
    2e30:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e36:	e8 27 0b 00 00       	call   3962 <printf>
    exit();
    2e3b:	e8 de 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2e40:	83 ec 08             	sub    $0x8,%esp
    2e43:	68 c5 4a 00 00       	push   $0x4ac5
    2e48:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e4e:	e8 0f 0b 00 00       	call   3962 <printf>
    exit();
    2e53:	e8 c6 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2e58:	50                   	push   %eax
    2e59:	53                   	push   %ebx
    2e5a:	68 30 52 00 00       	push   $0x5230
    2e5f:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e65:	e8 f8 0a 00 00       	call   3962 <printf>
    exit();
    2e6a:	e8 af 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2e6f:	56                   	push   %esi
    2e70:	53                   	push   %ebx
    2e71:	68 68 52 00 00       	push   $0x5268
    2e76:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e7c:	e8 e1 0a 00 00       	call   3962 <printf>
    exit();
    2e81:	e8 98 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2e86:	83 ec 08             	sub    $0x8,%esp
    2e89:	68 90 52 00 00       	push   $0x5290
    2e8e:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2e94:	e8 c9 0a 00 00       	call   3962 <printf>
    exit();
    2e99:	e8 80 09 00 00       	call   381e <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e9e:	50                   	push   %eax
    2e9f:	53                   	push   %ebx
    2ea0:	68 c0 52 00 00       	push   $0x52c0
    2ea5:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2eab:	e8 b2 0a 00 00       	call   3962 <printf>
    exit();
    2eb0:	e8 69 09 00 00       	call   381e <exit>
      printf(stdout, "fork failed\n");
    2eb5:	83 ec 08             	sub    $0x8,%esp
    2eb8:	68 bd 4b 00 00       	push   $0x4bbd
    2ebd:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2ec3:	e8 9a 0a 00 00       	call   3962 <printf>
      exit();
    2ec8:	e8 51 09 00 00       	call   381e <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2ecd:	0f be 03             	movsbl (%ebx),%eax
    2ed0:	50                   	push   %eax
    2ed1:	53                   	push   %ebx
    2ed2:	68 e0 4a 00 00       	push   $0x4ae0
    2ed7:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2edd:	e8 80 0a 00 00       	call   3962 <printf>
      kill(ppid);
    2ee2:	89 34 24             	mov    %esi,(%esp)
    2ee5:	e8 64 09 00 00       	call   384e <kill>
      exit();
    2eea:	e8 2f 09 00 00       	call   381e <exit>
    printf(1, "pipe() failed\n");
    2eef:	83 ec 08             	sub    $0x8,%esp
    2ef2:	68 b5 3f 00 00       	push   $0x3fb5
    2ef7:	6a 01                	push   $0x1
    2ef9:	e8 64 0a 00 00       	call   3962 <printf>
    exit();
    2efe:	e8 1b 09 00 00       	call   381e <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2f03:	83 ec 0c             	sub    $0xc,%esp
    2f06:	6a 00                	push   $0x0
    2f08:	e8 99 09 00 00       	call   38a6 <sbrk>
    2f0d:	89 c2                	mov    %eax,%edx
    2f0f:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2f14:	29 d0                	sub    %edx,%eax
    2f16:	89 04 24             	mov    %eax,(%esp)
    2f19:	e8 88 09 00 00       	call   38a6 <sbrk>
      write(fds[1], "x", 1);
    2f1e:	83 c4 0c             	add    $0xc,%esp
    2f21:	6a 01                	push   $0x1
    2f23:	68 d5 45 00 00       	push   $0x45d5
    2f28:	ff 75 e4             	pushl  -0x1c(%ebp)
    2f2b:	e8 0e 09 00 00       	call   383e <write>
    2f30:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2f33:	83 ec 0c             	sub    $0xc,%esp
    2f36:	68 e8 03 00 00       	push   $0x3e8
    2f3b:	e8 6e 09 00 00       	call   38ae <sleep>
    2f40:	83 c4 10             	add    $0x10,%esp
    2f43:	eb ee                	jmp    2f33 <sbrktest+0x349>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f45:	83 c6 04             	add    $0x4,%esi
    2f48:	39 fe                	cmp    %edi,%esi
    2f4a:	74 26                	je     2f72 <sbrktest+0x388>
    if((pids[i] = fork()) == 0){
    2f4c:	e8 c5 08 00 00       	call   3816 <fork>
    2f51:	89 06                	mov    %eax,(%esi)
    2f53:	85 c0                	test   %eax,%eax
    2f55:	74 ac                	je     2f03 <sbrktest+0x319>
    }
    if(pids[i] != -1)
    2f57:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f5a:	74 e9                	je     2f45 <sbrktest+0x35b>
      read(fds[0], &scratch, 1);
    2f5c:	83 ec 04             	sub    $0x4,%esp
    2f5f:	6a 01                	push   $0x1
    2f61:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f64:	50                   	push   %eax
    2f65:	ff 75 e0             	pushl  -0x20(%ebp)
    2f68:	e8 c9 08 00 00       	call   3836 <read>
    2f6d:	83 c4 10             	add    $0x10,%esp
    2f70:	eb d3                	jmp    2f45 <sbrktest+0x35b>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2f72:	83 ec 0c             	sub    $0xc,%esp
    2f75:	68 00 10 00 00       	push   $0x1000
    2f7a:	e8 27 09 00 00       	call   38a6 <sbrk>
    2f7f:	89 c6                	mov    %eax,%esi
    2f81:	83 c4 10             	add    $0x10,%esp
    2f84:	eb 07                	jmp    2f8d <sbrktest+0x3a3>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f86:	83 c3 04             	add    $0x4,%ebx
    2f89:	39 fb                	cmp    %edi,%ebx
    2f8b:	74 1a                	je     2fa7 <sbrktest+0x3bd>
    if(pids[i] == -1)
    2f8d:	8b 03                	mov    (%ebx),%eax
    2f8f:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f92:	74 f2                	je     2f86 <sbrktest+0x39c>
      continue;
    kill(pids[i]);
    2f94:	83 ec 0c             	sub    $0xc,%esp
    2f97:	50                   	push   %eax
    2f98:	e8 b1 08 00 00       	call   384e <kill>
    wait();
    2f9d:	e8 84 08 00 00       	call   3826 <wait>
    2fa2:	83 c4 10             	add    $0x10,%esp
    2fa5:	eb df                	jmp    2f86 <sbrktest+0x39c>
  }
  if(c == (char*)0xffffffff){
    2fa7:	83 fe ff             	cmp    $0xffffffff,%esi
    2faa:	74 30                	je     2fdc <sbrktest+0x3f2>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    2fac:	83 ec 0c             	sub    $0xc,%esp
    2faf:	6a 00                	push   $0x0
    2fb1:	e8 f0 08 00 00       	call   38a6 <sbrk>
    2fb6:	83 c4 10             	add    $0x10,%esp
    2fb9:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    2fbc:	72 36                	jb     2ff4 <sbrktest+0x40a>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    2fbe:	83 ec 08             	sub    $0x8,%esp
    2fc1:	68 14 4b 00 00       	push   $0x4b14
    2fc6:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2fcc:	e8 91 09 00 00       	call   3962 <printf>
}
    2fd1:	83 c4 10             	add    $0x10,%esp
    2fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2fd7:	5b                   	pop    %ebx
    2fd8:	5e                   	pop    %esi
    2fd9:	5f                   	pop    %edi
    2fda:	5d                   	pop    %ebp
    2fdb:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    2fdc:	83 ec 08             	sub    $0x8,%esp
    2fdf:	68 f9 4a 00 00       	push   $0x4af9
    2fe4:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    2fea:	e8 73 09 00 00       	call   3962 <printf>
    exit();
    2fef:	e8 2a 08 00 00       	call   381e <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2ff4:	83 ec 0c             	sub    $0xc,%esp
    2ff7:	6a 00                	push   $0x0
    2ff9:	e8 a8 08 00 00       	call   38a6 <sbrk>
    2ffe:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
    3001:	29 c1                	sub    %eax,%ecx
    3003:	89 0c 24             	mov    %ecx,(%esp)
    3006:	e8 9b 08 00 00       	call   38a6 <sbrk>
    300b:	83 c4 10             	add    $0x10,%esp
    300e:	eb ae                	jmp    2fbe <sbrktest+0x3d4>

00003010 <validateint>:

void
validateint(int *p)
{
    3010:	f3 0f 1e fb          	endbr32 
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3014:	c3                   	ret    

00003015 <validatetest>:

void
validatetest(void)
{
    3015:	f3 0f 1e fb          	endbr32 
    3019:	55                   	push   %ebp
    301a:	89 e5                	mov    %esp,%ebp
    301c:	56                   	push   %esi
    301d:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    301e:	83 ec 08             	sub    $0x8,%esp
    3021:	68 22 4b 00 00       	push   $0x4b22
    3026:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    302c:	e8 31 09 00 00       	call   3962 <printf>
    3031:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    3034:	be 00 00 00 00       	mov    $0x0,%esi
    if((pid = fork()) == 0){
    3039:	e8 d8 07 00 00       	call   3816 <fork>
    303e:	89 c3                	mov    %eax,%ebx
    3040:	85 c0                	test   %eax,%eax
    3042:	74 64                	je     30a8 <validatetest+0x93>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    3044:	83 ec 0c             	sub    $0xc,%esp
    3047:	6a 00                	push   $0x0
    3049:	e8 60 08 00 00       	call   38ae <sleep>
    sleep(0);
    304e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3055:	e8 54 08 00 00       	call   38ae <sleep>
    kill(pid);
    305a:	89 1c 24             	mov    %ebx,(%esp)
    305d:	e8 ec 07 00 00       	call   384e <kill>
    wait();
    3062:	e8 bf 07 00 00       	call   3826 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3067:	83 c4 08             	add    $0x8,%esp
    306a:	56                   	push   %esi
    306b:	68 31 4b 00 00       	push   $0x4b31
    3070:	e8 09 08 00 00       	call   387e <link>
    3075:	83 c4 10             	add    $0x10,%esp
    3078:	83 f8 ff             	cmp    $0xffffffff,%eax
    307b:	75 30                	jne    30ad <validatetest+0x98>
  for(p = 0; p <= (uint)hi; p += 4096){
    307d:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3083:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    3089:	75 ae                	jne    3039 <validatetest+0x24>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    308b:	83 ec 08             	sub    $0x8,%esp
    308e:	68 55 4b 00 00       	push   $0x4b55
    3093:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    3099:	e8 c4 08 00 00       	call   3962 <printf>
}
    309e:	83 c4 10             	add    $0x10,%esp
    30a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
    30a4:	5b                   	pop    %ebx
    30a5:	5e                   	pop    %esi
    30a6:	5d                   	pop    %ebp
    30a7:	c3                   	ret    
      exit();
    30a8:	e8 71 07 00 00       	call   381e <exit>
      printf(stdout, "link should not succeed\n");
    30ad:	83 ec 08             	sub    $0x8,%esp
    30b0:	68 3c 4b 00 00       	push   $0x4b3c
    30b5:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    30bb:	e8 a2 08 00 00       	call   3962 <printf>
      exit();
    30c0:	e8 59 07 00 00       	call   381e <exit>

000030c5 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    30c5:	f3 0f 1e fb          	endbr32 
    30c9:	55                   	push   %ebp
    30ca:	89 e5                	mov    %esp,%ebp
    30cc:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    30cf:	68 62 4b 00 00       	push   $0x4b62
    30d4:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    30da:	e8 83 08 00 00       	call   3962 <printf>
    30df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    30e2:	b8 00 00 00 00       	mov    $0x0,%eax
    if(uninit[i] != '\0'){
    30e7:	80 b8 60 5d 00 00 00 	cmpb   $0x0,0x5d60(%eax)
    30ee:	75 22                	jne    3112 <bsstest+0x4d>
  for(i = 0; i < sizeof(uninit); i++){
    30f0:	83 c0 01             	add    $0x1,%eax
    30f3:	3d 10 27 00 00       	cmp    $0x2710,%eax
    30f8:	75 ed                	jne    30e7 <bsstest+0x22>
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    30fa:	83 ec 08             	sub    $0x8,%esp
    30fd:	68 7d 4b 00 00       	push   $0x4b7d
    3102:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    3108:	e8 55 08 00 00       	call   3962 <printf>
}
    310d:	83 c4 10             	add    $0x10,%esp
    3110:	c9                   	leave  
    3111:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    3112:	83 ec 08             	sub    $0x8,%esp
    3115:	68 6c 4b 00 00       	push   $0x4b6c
    311a:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    3120:	e8 3d 08 00 00       	call   3962 <printf>
      exit();
    3125:	e8 f4 06 00 00       	call   381e <exit>

0000312a <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    312a:	f3 0f 1e fb          	endbr32 
    312e:	55                   	push   %ebp
    312f:	89 e5                	mov    %esp,%ebp
    3131:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3134:	68 8a 4b 00 00       	push   $0x4b8a
    3139:	e8 30 07 00 00       	call   386e <unlink>
  pid = fork();
    313e:	e8 d3 06 00 00       	call   3816 <fork>
  if(pid == 0){
    3143:	83 c4 10             	add    $0x10,%esp
    3146:	85 c0                	test   %eax,%eax
    3148:	74 3f                	je     3189 <bigargtest+0x5f>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    314a:	0f 88 ad 00 00 00    	js     31fd <bigargtest+0xd3>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    3150:	e8 d1 06 00 00       	call   3826 <wait>
  fd = open("bigarg-ok", 0);
    3155:	83 ec 08             	sub    $0x8,%esp
    3158:	6a 00                	push   $0x0
    315a:	68 8a 4b 00 00       	push   $0x4b8a
    315f:	e8 fa 06 00 00       	call   385e <open>
  if(fd < 0){
    3164:	83 c4 10             	add    $0x10,%esp
    3167:	85 c0                	test   %eax,%eax
    3169:	0f 88 a6 00 00 00    	js     3215 <bigargtest+0xeb>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    316f:	83 ec 0c             	sub    $0xc,%esp
    3172:	50                   	push   %eax
    3173:	e8 ce 06 00 00       	call   3846 <close>
  unlink("bigarg-ok");
    3178:	c7 04 24 8a 4b 00 00 	movl   $0x4b8a,(%esp)
    317f:	e8 ea 06 00 00       	call   386e <unlink>
}
    3184:	83 c4 10             	add    $0x10,%esp
    3187:	c9                   	leave  
    3188:	c3                   	ret    
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3189:	c7 04 85 c0 5c 00 00 	movl   $0x52e4,0x5cc0(,%eax,4)
    3190:	e4 52 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3194:	83 c0 01             	add    $0x1,%eax
    3197:	83 f8 1f             	cmp    $0x1f,%eax
    319a:	75 ed                	jne    3189 <bigargtest+0x5f>
    args[MAXARG-1] = 0;
    319c:	c7 05 3c 5d 00 00 00 	movl   $0x0,0x5d3c
    31a3:	00 00 00 
    printf(stdout, "bigarg test\n");
    31a6:	83 ec 08             	sub    $0x8,%esp
    31a9:	68 94 4b 00 00       	push   $0x4b94
    31ae:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    31b4:	e8 a9 07 00 00       	call   3962 <printf>
    exec("echo", args);
    31b9:	83 c4 08             	add    $0x8,%esp
    31bc:	68 c0 5c 00 00       	push   $0x5cc0
    31c1:	68 61 3d 00 00       	push   $0x3d61
    31c6:	e8 8b 06 00 00       	call   3856 <exec>
    printf(stdout, "bigarg test ok\n");
    31cb:	83 c4 08             	add    $0x8,%esp
    31ce:	68 a1 4b 00 00       	push   $0x4ba1
    31d3:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    31d9:	e8 84 07 00 00       	call   3962 <printf>
    fd = open("bigarg-ok", O_CREATE);
    31de:	83 c4 08             	add    $0x8,%esp
    31e1:	68 00 02 00 00       	push   $0x200
    31e6:	68 8a 4b 00 00       	push   $0x4b8a
    31eb:	e8 6e 06 00 00       	call   385e <open>
    close(fd);
    31f0:	89 04 24             	mov    %eax,(%esp)
    31f3:	e8 4e 06 00 00       	call   3846 <close>
    exit();
    31f8:	e8 21 06 00 00       	call   381e <exit>
    printf(stdout, "bigargtest: fork failed\n");
    31fd:	83 ec 08             	sub    $0x8,%esp
    3200:	68 b1 4b 00 00       	push   $0x4bb1
    3205:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    320b:	e8 52 07 00 00       	call   3962 <printf>
    exit();
    3210:	e8 09 06 00 00       	call   381e <exit>
    printf(stdout, "bigarg test failed!\n");
    3215:	83 ec 08             	sub    $0x8,%esp
    3218:	68 ca 4b 00 00       	push   $0x4bca
    321d:	ff 35 8c 5c 00 00    	pushl  0x5c8c
    3223:	e8 3a 07 00 00       	call   3962 <printf>
    exit();
    3228:	e8 f1 05 00 00       	call   381e <exit>

0000322d <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    322d:	f3 0f 1e fb          	endbr32 
    3231:	55                   	push   %ebp
    3232:	89 e5                	mov    %esp,%ebp
    3234:	57                   	push   %edi
    3235:	56                   	push   %esi
    3236:	53                   	push   %ebx
    3237:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    323a:	68 df 4b 00 00       	push   $0x4bdf
    323f:	6a 01                	push   $0x1
    3241:	e8 1c 07 00 00       	call   3962 <printf>
    3246:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3249:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    324e:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3252:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3257:	f7 eb                	imul   %ebx
    3259:	c1 fa 06             	sar    $0x6,%edx
    325c:	89 de                	mov    %ebx,%esi
    325e:	c1 fe 1f             	sar    $0x1f,%esi
    3261:	29 f2                	sub    %esi,%edx
    3263:	8d 42 30             	lea    0x30(%edx),%eax
    3266:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3269:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    326f:	89 d9                	mov    %ebx,%ecx
    3271:	29 d1                	sub    %edx,%ecx
    3273:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3278:	f7 e9                	imul   %ecx
    327a:	c1 fa 05             	sar    $0x5,%edx
    327d:	c1 f9 1f             	sar    $0x1f,%ecx
    3280:	29 ca                	sub    %ecx,%edx
    3282:	83 c2 30             	add    $0x30,%edx
    3285:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3288:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    328d:	f7 eb                	imul   %ebx
    328f:	c1 fa 05             	sar    $0x5,%edx
    3292:	29 f2                	sub    %esi,%edx
    3294:	6b d2 64             	imul   $0x64,%edx,%edx
    3297:	89 df                	mov    %ebx,%edi
    3299:	29 d7                	sub    %edx,%edi
    329b:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    32a0:	89 f8                	mov    %edi,%eax
    32a2:	f7 e9                	imul   %ecx
    32a4:	c1 fa 02             	sar    $0x2,%edx
    32a7:	c1 ff 1f             	sar    $0x1f,%edi
    32aa:	29 fa                	sub    %edi,%edx
    32ac:	83 c2 30             	add    $0x30,%edx
    32af:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    32b2:	89 d8                	mov    %ebx,%eax
    32b4:	f7 e9                	imul   %ecx
    32b6:	c1 fa 02             	sar    $0x2,%edx
    32b9:	29 f2                	sub    %esi,%edx
    32bb:	8d 04 92             	lea    (%edx,%edx,4),%eax
    32be:	01 c0                	add    %eax,%eax
    32c0:	89 df                	mov    %ebx,%edi
    32c2:	29 c7                	sub    %eax,%edi
    32c4:	89 f8                	mov    %edi,%eax
    32c6:	83 c0 30             	add    $0x30,%eax
    32c9:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    32cc:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    32d0:	83 ec 04             	sub    $0x4,%esp
    32d3:	8d 75 a8             	lea    -0x58(%ebp),%esi
    32d6:	56                   	push   %esi
    32d7:	68 ec 4b 00 00       	push   $0x4bec
    32dc:	6a 01                	push   $0x1
    32de:	e8 7f 06 00 00       	call   3962 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    32e3:	83 c4 08             	add    $0x8,%esp
    32e6:	68 02 02 00 00       	push   $0x202
    32eb:	56                   	push   %esi
    32ec:	e8 6d 05 00 00       	call   385e <open>
    32f1:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    32f3:	83 c4 10             	add    $0x10,%esp
    32f6:	85 c0                	test   %eax,%eax
    32f8:	0f 89 d5 00 00 00    	jns    33d3 <fsfull+0x1a6>
      printf(1, "open %s failed\n", name);
    32fe:	83 ec 04             	sub    $0x4,%esp
    3301:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3304:	50                   	push   %eax
    3305:	68 f8 4b 00 00       	push   $0x4bf8
    330a:	6a 01                	push   $0x1
    330c:	e8 51 06 00 00       	call   3962 <printf>
      break;
    3311:	83 c4 10             	add    $0x10,%esp
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3314:	85 db                	test   %ebx,%ebx
    3316:	0f 88 9d 00 00 00    	js     33b9 <fsfull+0x18c>
    char name[64];
    name[0] = 'f';
    331c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3320:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3325:	f7 eb                	imul   %ebx
    3327:	c1 fa 06             	sar    $0x6,%edx
    332a:	89 de                	mov    %ebx,%esi
    332c:	c1 fe 1f             	sar    $0x1f,%esi
    332f:	29 f2                	sub    %esi,%edx
    3331:	8d 42 30             	lea    0x30(%edx),%eax
    3334:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3337:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    333d:	89 d9                	mov    %ebx,%ecx
    333f:	29 d1                	sub    %edx,%ecx
    3341:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3346:	f7 e9                	imul   %ecx
    3348:	c1 fa 05             	sar    $0x5,%edx
    334b:	c1 f9 1f             	sar    $0x1f,%ecx
    334e:	29 ca                	sub    %ecx,%edx
    3350:	83 c2 30             	add    $0x30,%edx
    3353:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3356:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    335b:	f7 eb                	imul   %ebx
    335d:	c1 fa 05             	sar    $0x5,%edx
    3360:	29 f2                	sub    %esi,%edx
    3362:	6b d2 64             	imul   $0x64,%edx,%edx
    3365:	89 df                	mov    %ebx,%edi
    3367:	29 d7                	sub    %edx,%edi
    3369:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    336e:	89 f8                	mov    %edi,%eax
    3370:	f7 e9                	imul   %ecx
    3372:	c1 fa 02             	sar    $0x2,%edx
    3375:	c1 ff 1f             	sar    $0x1f,%edi
    3378:	29 fa                	sub    %edi,%edx
    337a:	83 c2 30             	add    $0x30,%edx
    337d:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3380:	89 d8                	mov    %ebx,%eax
    3382:	f7 e9                	imul   %ecx
    3384:	c1 fa 02             	sar    $0x2,%edx
    3387:	29 f2                	sub    %esi,%edx
    3389:	8d 04 92             	lea    (%edx,%edx,4),%eax
    338c:	01 c0                	add    %eax,%eax
    338e:	89 de                	mov    %ebx,%esi
    3390:	29 c6                	sub    %eax,%esi
    3392:	89 f0                	mov    %esi,%eax
    3394:	83 c0 30             	add    $0x30,%eax
    3397:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    339a:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    339e:	83 ec 0c             	sub    $0xc,%esp
    33a1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    33a4:	50                   	push   %eax
    33a5:	e8 c4 04 00 00       	call   386e <unlink>
    nfiles--;
    33aa:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    33ad:	83 c4 10             	add    $0x10,%esp
    33b0:	83 fb ff             	cmp    $0xffffffff,%ebx
    33b3:	0f 85 63 ff ff ff    	jne    331c <fsfull+0xef>
  }

  printf(1, "fsfull test finished\n");
    33b9:	83 ec 08             	sub    $0x8,%esp
    33bc:	68 18 4c 00 00       	push   $0x4c18
    33c1:	6a 01                	push   $0x1
    33c3:	e8 9a 05 00 00       	call   3962 <printf>
}
    33c8:	83 c4 10             	add    $0x10,%esp
    33cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    33ce:	5b                   	pop    %ebx
    33cf:	5e                   	pop    %esi
    33d0:	5f                   	pop    %edi
    33d1:	5d                   	pop    %ebp
    33d2:	c3                   	ret    
    int total = 0;
    33d3:	bf 00 00 00 00       	mov    $0x0,%edi
      int cc = write(fd, buf, 512);
    33d8:	83 ec 04             	sub    $0x4,%esp
    33db:	68 00 02 00 00       	push   $0x200
    33e0:	68 80 84 00 00       	push   $0x8480
    33e5:	56                   	push   %esi
    33e6:	e8 53 04 00 00       	call   383e <write>
      if(cc < 512)
    33eb:	83 c4 10             	add    $0x10,%esp
    33ee:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    33f3:	7e 04                	jle    33f9 <fsfull+0x1cc>
      total += cc;
    33f5:	01 c7                	add    %eax,%edi
    while(1){
    33f7:	eb df                	jmp    33d8 <fsfull+0x1ab>
    printf(1, "wrote %d bytes\n", total);
    33f9:	83 ec 04             	sub    $0x4,%esp
    33fc:	57                   	push   %edi
    33fd:	68 08 4c 00 00       	push   $0x4c08
    3402:	6a 01                	push   $0x1
    3404:	e8 59 05 00 00       	call   3962 <printf>
    close(fd);
    3409:	89 34 24             	mov    %esi,(%esp)
    340c:	e8 35 04 00 00       	call   3846 <close>
    if(total == 0)
    3411:	83 c4 10             	add    $0x10,%esp
    3414:	85 ff                	test   %edi,%edi
    3416:	0f 84 f8 fe ff ff    	je     3314 <fsfull+0xe7>
  for(nfiles = 0; ; nfiles++){
    341c:	83 c3 01             	add    $0x1,%ebx
    341f:	e9 2a fe ff ff       	jmp    324e <fsfull+0x21>

00003424 <uio>:

void
uio()
{
    3424:	f3 0f 1e fb          	endbr32 
    3428:	55                   	push   %ebp
    3429:	89 e5                	mov    %esp,%ebp
    342b:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    342e:	68 2e 4c 00 00       	push   $0x4c2e
    3433:	6a 01                	push   $0x1
    3435:	e8 28 05 00 00       	call   3962 <printf>
  pid = fork();
    343a:	e8 d7 03 00 00       	call   3816 <fork>
  if(pid == 0){
    343f:	83 c4 10             	add    $0x10,%esp
    3442:	85 c0                	test   %eax,%eax
    3444:	74 1b                	je     3461 <uio+0x3d>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    3446:	78 3e                	js     3486 <uio+0x62>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    3448:	e8 d9 03 00 00       	call   3826 <wait>
  printf(1, "uio test done\n");
    344d:	83 ec 08             	sub    $0x8,%esp
    3450:	68 38 4c 00 00       	push   $0x4c38
    3455:	6a 01                	push   $0x1
    3457:	e8 06 05 00 00       	call   3962 <printf>
}
    345c:	83 c4 10             	add    $0x10,%esp
    345f:	c9                   	leave  
    3460:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3461:	b8 09 00 00 00       	mov    $0x9,%eax
    3466:	ba 70 00 00 00       	mov    $0x70,%edx
    346b:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    346c:	ba 71 00 00 00       	mov    $0x71,%edx
    3471:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3472:	83 ec 08             	sub    $0x8,%esp
    3475:	68 c4 53 00 00       	push   $0x53c4
    347a:	6a 01                	push   $0x1
    347c:	e8 e1 04 00 00       	call   3962 <printf>
    exit();
    3481:	e8 98 03 00 00       	call   381e <exit>
    printf (1, "fork failed\n");
    3486:	83 ec 08             	sub    $0x8,%esp
    3489:	68 bd 4b 00 00       	push   $0x4bbd
    348e:	6a 01                	push   $0x1
    3490:	e8 cd 04 00 00       	call   3962 <printf>
    exit();
    3495:	e8 84 03 00 00       	call   381e <exit>

0000349a <argptest>:

void argptest()
{
    349a:	f3 0f 1e fb          	endbr32 
    349e:	55                   	push   %ebp
    349f:	89 e5                	mov    %esp,%ebp
    34a1:	53                   	push   %ebx
    34a2:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    34a5:	6a 00                	push   $0x0
    34a7:	68 47 4c 00 00       	push   $0x4c47
    34ac:	e8 ad 03 00 00       	call   385e <open>
  if (fd < 0) {
    34b1:	83 c4 10             	add    $0x10,%esp
    34b4:	85 c0                	test   %eax,%eax
    34b6:	78 3a                	js     34f2 <argptest+0x58>
    34b8:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    34ba:	83 ec 0c             	sub    $0xc,%esp
    34bd:	6a 00                	push   $0x0
    34bf:	e8 e2 03 00 00       	call   38a6 <sbrk>
    34c4:	83 c4 0c             	add    $0xc,%esp
    34c7:	6a ff                	push   $0xffffffff
    34c9:	83 e8 01             	sub    $0x1,%eax
    34cc:	50                   	push   %eax
    34cd:	53                   	push   %ebx
    34ce:	e8 63 03 00 00       	call   3836 <read>
  close(fd);
    34d3:	89 1c 24             	mov    %ebx,(%esp)
    34d6:	e8 6b 03 00 00       	call   3846 <close>
  printf(1, "arg test passed\n");
    34db:	83 c4 08             	add    $0x8,%esp
    34de:	68 59 4c 00 00       	push   $0x4c59
    34e3:	6a 01                	push   $0x1
    34e5:	e8 78 04 00 00       	call   3962 <printf>
}
    34ea:	83 c4 10             	add    $0x10,%esp
    34ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    34f0:	c9                   	leave  
    34f1:	c3                   	ret    
    printf(2, "open failed\n");
    34f2:	83 ec 08             	sub    $0x8,%esp
    34f5:	68 4c 4c 00 00       	push   $0x4c4c
    34fa:	6a 02                	push   $0x2
    34fc:	e8 61 04 00 00       	call   3962 <printf>
    exit();
    3501:	e8 18 03 00 00       	call   381e <exit>

00003506 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3506:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    350a:	69 05 88 5c 00 00 0d 	imul   $0x19660d,0x5c88,%eax
    3511:	66 19 00 
    3514:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3519:	a3 88 5c 00 00       	mov    %eax,0x5c88
  return randstate;
}
    351e:	c3                   	ret    

0000351f <main>:

int
main(int argc, char *argv[])
{
    351f:	f3 0f 1e fb          	endbr32 
    3523:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3527:	83 e4 f0             	and    $0xfffffff0,%esp
    352a:	ff 71 fc             	pushl  -0x4(%ecx)
    352d:	55                   	push   %ebp
    352e:	89 e5                	mov    %esp,%ebp
    3530:	51                   	push   %ecx
    3531:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    3534:	68 6a 4c 00 00       	push   $0x4c6a
    3539:	6a 01                	push   $0x1
    353b:	e8 22 04 00 00       	call   3962 <printf>

  if(open("usertests.ran", 0) >= 0){
    3540:	83 c4 08             	add    $0x8,%esp
    3543:	6a 00                	push   $0x0
    3545:	68 7e 4c 00 00       	push   $0x4c7e
    354a:	e8 0f 03 00 00       	call   385e <open>
    354f:	83 c4 10             	add    $0x10,%esp
    3552:	85 c0                	test   %eax,%eax
    3554:	78 14                	js     356a <main+0x4b>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3556:	83 ec 08             	sub    $0x8,%esp
    3559:	68 e8 53 00 00       	push   $0x53e8
    355e:	6a 01                	push   $0x1
    3560:	e8 fd 03 00 00       	call   3962 <printf>
    exit();
    3565:	e8 b4 02 00 00       	call   381e <exit>
  }
  close(open("usertests.ran", O_CREATE));
    356a:	83 ec 08             	sub    $0x8,%esp
    356d:	68 00 02 00 00       	push   $0x200
    3572:	68 7e 4c 00 00       	push   $0x4c7e
    3577:	e8 e2 02 00 00       	call   385e <open>
    357c:	89 04 24             	mov    %eax,(%esp)
    357f:	e8 c2 02 00 00       	call   3846 <close>

  argptest();
    3584:	e8 11 ff ff ff       	call   349a <argptest>
  createdelete();
    3589:	e8 ac da ff ff       	call   103a <createdelete>
  linkunlink();
    358e:	e8 65 e3 ff ff       	call   18f8 <linkunlink>
  concreate();
    3593:	e8 61 e0 ff ff       	call   15f9 <concreate>
  fourfiles();
    3598:	e8 c3 d8 ff ff       	call   e60 <fourfiles>
  sharedfd();
    359d:	e8 27 d7 ff ff       	call   cc9 <sharedfd>

  bigargtest();
    35a2:	e8 83 fb ff ff       	call   312a <bigargtest>
  bigwrite();
    35a7:	e8 d2 ec ff ff       	call   227e <bigwrite>
  bigargtest();
    35ac:	e8 79 fb ff ff       	call   312a <bigargtest>
  bsstest();
    35b1:	e8 0f fb ff ff       	call   30c5 <bsstest>
  sbrktest();
    35b6:	e8 2f f6 ff ff       	call   2bea <sbrktest>
  validatetest();
    35bb:	e8 55 fa ff ff       	call   3015 <validatetest>

  opentest();
    35c0:	e8 f3 cc ff ff       	call   2b8 <opentest>
  writetest();
    35c5:	e8 85 cd ff ff       	call   34f <writetest>
  writetest1();
    35ca:	e8 62 cf ff ff       	call   531 <writetest1>
  createtest();
    35cf:	e8 1b d1 ff ff       	call   6ef <createtest>

  openiputtest();
    35d4:	e8 f2 cb ff ff       	call   1cb <openiputtest>
  exitiputtest();
    35d9:	e8 03 cb ff ff       	call   e1 <exitiputtest>
  iputtest();
    35de:	e8 1d ca ff ff       	call   0 <iputtest>

  mem();
    35e3:	e8 26 d6 ff ff       	call   c0e <mem>
  pipe1();
    35e8:	e8 d8 d2 ff ff       	call   8c5 <pipe1>
  preempt();
    35ed:	e8 6e d4 ff ff       	call   a60 <preempt>
  exitwait();
    35f2:	e8 a8 d5 ff ff       	call   b9f <exitwait>

  rmdot();
    35f7:	e8 70 f0 ff ff       	call   266c <rmdot>
  fourteen();
    35fc:	e8 2a ef ff ff       	call   252b <fourteen>
  bigfile();
    3601:	e8 59 ed ff ff       	call   235f <bigfile>
  subdir();
    3606:	e8 41 e5 ff ff       	call   1b4c <subdir>
  linktest();
    360b:	e8 bf dd ff ff       	call   13cf <linktest>
  unlinkread();
    3610:	e8 1d dc ff ff       	call   1232 <unlinkread>
  dirfile();
    3615:	e8 db f1 ff ff       	call   27f5 <dirfile>
  iref();
    361a:	e8 f4 f3 ff ff       	call   2a13 <iref>
  forktest();
    361f:	e8 15 f5 ff ff       	call   2b39 <forktest>
  bigdir(); // slow
    3624:	e8 c5 e3 ff ff       	call   19ee <bigdir>

  uio();
    3629:	e8 f6 fd ff ff       	call   3424 <uio>

  exectest();
    362e:	e8 45 d2 ff ff       	call   878 <exectest>

  exit();
    3633:	e8 e6 01 00 00       	call   381e <exit>

00003638 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3638:	f3 0f 1e fb          	endbr32 
    363c:	55                   	push   %ebp
    363d:	89 e5                	mov    %esp,%ebp
    363f:	53                   	push   %ebx
    3640:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3643:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3646:	b8 00 00 00 00       	mov    $0x0,%eax
    364b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    364f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    3652:	83 c0 01             	add    $0x1,%eax
    3655:	84 d2                	test   %dl,%dl
    3657:	75 f2                	jne    364b <strcpy+0x13>
    ;
  return os;
}
    3659:	89 c8                	mov    %ecx,%eax
    365b:	5b                   	pop    %ebx
    365c:	5d                   	pop    %ebp
    365d:	c3                   	ret    

0000365e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    365e:	f3 0f 1e fb          	endbr32 
    3662:	55                   	push   %ebp
    3663:	89 e5                	mov    %esp,%ebp
    3665:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3668:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    366b:	0f b6 01             	movzbl (%ecx),%eax
    366e:	84 c0                	test   %al,%al
    3670:	74 11                	je     3683 <strcmp+0x25>
    3672:	38 02                	cmp    %al,(%edx)
    3674:	75 0d                	jne    3683 <strcmp+0x25>
    p++, q++;
    3676:	83 c1 01             	add    $0x1,%ecx
    3679:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    367c:	0f b6 01             	movzbl (%ecx),%eax
    367f:	84 c0                	test   %al,%al
    3681:	75 ef                	jne    3672 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    3683:	0f b6 c0             	movzbl %al,%eax
    3686:	0f b6 12             	movzbl (%edx),%edx
    3689:	29 d0                	sub    %edx,%eax
}
    368b:	5d                   	pop    %ebp
    368c:	c3                   	ret    

0000368d <strlen>:

uint
strlen(const char *s)
{
    368d:	f3 0f 1e fb          	endbr32 
    3691:	55                   	push   %ebp
    3692:	89 e5                	mov    %esp,%ebp
    3694:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    3697:	80 3a 00             	cmpb   $0x0,(%edx)
    369a:	74 14                	je     36b0 <strlen+0x23>
    369c:	b8 00 00 00 00       	mov    $0x0,%eax
    36a1:	83 c0 01             	add    $0x1,%eax
    36a4:	89 c1                	mov    %eax,%ecx
    36a6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    36aa:	75 f5                	jne    36a1 <strlen+0x14>
    ;
  return n;
}
    36ac:	89 c8                	mov    %ecx,%eax
    36ae:	5d                   	pop    %ebp
    36af:	c3                   	ret    
  for(n = 0; s[n]; n++)
    36b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
    36b5:	eb f5                	jmp    36ac <strlen+0x1f>

000036b7 <memset>:

void*
memset(void *dst, int c, uint n)
{
    36b7:	f3 0f 1e fb          	endbr32 
    36bb:	55                   	push   %ebp
    36bc:	89 e5                	mov    %esp,%ebp
    36be:	57                   	push   %edi
    36bf:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    36c2:	89 d7                	mov    %edx,%edi
    36c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
    36c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    36ca:	fc                   	cld    
    36cb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    36cd:	89 d0                	mov    %edx,%eax
    36cf:	5f                   	pop    %edi
    36d0:	5d                   	pop    %ebp
    36d1:	c3                   	ret    

000036d2 <strchr>:

char*
strchr(const char *s, char c)
{
    36d2:	f3 0f 1e fb          	endbr32 
    36d6:	55                   	push   %ebp
    36d7:	89 e5                	mov    %esp,%ebp
    36d9:	8b 45 08             	mov    0x8(%ebp),%eax
    36dc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    36e0:	0f b6 10             	movzbl (%eax),%edx
    36e3:	84 d2                	test   %dl,%dl
    36e5:	74 15                	je     36fc <strchr+0x2a>
    if(*s == c)
    36e7:	38 d1                	cmp    %dl,%cl
    36e9:	74 0f                	je     36fa <strchr+0x28>
  for(; *s; s++)
    36eb:	83 c0 01             	add    $0x1,%eax
    36ee:	0f b6 10             	movzbl (%eax),%edx
    36f1:	84 d2                	test   %dl,%dl
    36f3:	75 f2                	jne    36e7 <strchr+0x15>
      return (char*)s;
  return 0;
    36f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    36fa:	5d                   	pop    %ebp
    36fb:	c3                   	ret    
  return 0;
    36fc:	b8 00 00 00 00       	mov    $0x0,%eax
    3701:	eb f7                	jmp    36fa <strchr+0x28>

00003703 <gets>:

char*
gets(char *buf, int max)
{
    3703:	f3 0f 1e fb          	endbr32 
    3707:	55                   	push   %ebp
    3708:	89 e5                	mov    %esp,%ebp
    370a:	57                   	push   %edi
    370b:	56                   	push   %esi
    370c:	53                   	push   %ebx
    370d:	83 ec 2c             	sub    $0x2c,%esp
    3710:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3713:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
    3718:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    371b:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    371e:	83 c3 01             	add    $0x1,%ebx
    3721:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3724:	7d 27                	jge    374d <gets+0x4a>
    cc = read(0, &c, 1);
    3726:	83 ec 04             	sub    $0x4,%esp
    3729:	6a 01                	push   $0x1
    372b:	57                   	push   %edi
    372c:	6a 00                	push   $0x0
    372e:	e8 03 01 00 00       	call   3836 <read>
    if(cc < 1)
    3733:	83 c4 10             	add    $0x10,%esp
    3736:	85 c0                	test   %eax,%eax
    3738:	7e 13                	jle    374d <gets+0x4a>
      break;
    buf[i++] = c;
    373a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    373e:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
    3742:	3c 0a                	cmp    $0xa,%al
    3744:	74 04                	je     374a <gets+0x47>
    3746:	3c 0d                	cmp    $0xd,%al
    3748:	75 d1                	jne    371b <gets+0x18>
  for(i=0; i+1 < max; ){
    374a:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
    374d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3750:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
    3754:	89 f0                	mov    %esi,%eax
    3756:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3759:	5b                   	pop    %ebx
    375a:	5e                   	pop    %esi
    375b:	5f                   	pop    %edi
    375c:	5d                   	pop    %ebp
    375d:	c3                   	ret    

0000375e <stat>:

int
stat(const char *n, struct stat *st)
{
    375e:	f3 0f 1e fb          	endbr32 
    3762:	55                   	push   %ebp
    3763:	89 e5                	mov    %esp,%ebp
    3765:	56                   	push   %esi
    3766:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3767:	83 ec 08             	sub    $0x8,%esp
    376a:	6a 00                	push   $0x0
    376c:	ff 75 08             	pushl  0x8(%ebp)
    376f:	e8 ea 00 00 00       	call   385e <open>
  if(fd < 0)
    3774:	83 c4 10             	add    $0x10,%esp
    3777:	85 c0                	test   %eax,%eax
    3779:	78 24                	js     379f <stat+0x41>
    377b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    377d:	83 ec 08             	sub    $0x8,%esp
    3780:	ff 75 0c             	pushl  0xc(%ebp)
    3783:	50                   	push   %eax
    3784:	e8 ed 00 00 00       	call   3876 <fstat>
    3789:	89 c6                	mov    %eax,%esi
  close(fd);
    378b:	89 1c 24             	mov    %ebx,(%esp)
    378e:	e8 b3 00 00 00       	call   3846 <close>
  return r;
    3793:	83 c4 10             	add    $0x10,%esp
}
    3796:	89 f0                	mov    %esi,%eax
    3798:	8d 65 f8             	lea    -0x8(%ebp),%esp
    379b:	5b                   	pop    %ebx
    379c:	5e                   	pop    %esi
    379d:	5d                   	pop    %ebp
    379e:	c3                   	ret    
    return -1;
    379f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    37a4:	eb f0                	jmp    3796 <stat+0x38>

000037a6 <atoi>:

int
atoi(const char *s)
{
    37a6:	f3 0f 1e fb          	endbr32 
    37aa:	55                   	push   %ebp
    37ab:	89 e5                	mov    %esp,%ebp
    37ad:	53                   	push   %ebx
    37ae:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37b1:	0f b6 02             	movzbl (%edx),%eax
    37b4:	8d 48 d0             	lea    -0x30(%eax),%ecx
    37b7:	80 f9 09             	cmp    $0x9,%cl
    37ba:	77 22                	ja     37de <atoi+0x38>
  n = 0;
    37bc:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
    37c1:	83 c2 01             	add    $0x1,%edx
    37c4:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    37c7:	0f be c0             	movsbl %al,%eax
    37ca:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    37ce:	0f b6 02             	movzbl (%edx),%eax
    37d1:	8d 58 d0             	lea    -0x30(%eax),%ebx
    37d4:	80 fb 09             	cmp    $0x9,%bl
    37d7:	76 e8                	jbe    37c1 <atoi+0x1b>
  return n;
}
    37d9:	89 c8                	mov    %ecx,%eax
    37db:	5b                   	pop    %ebx
    37dc:	5d                   	pop    %ebp
    37dd:	c3                   	ret    
  n = 0;
    37de:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
    37e3:	eb f4                	jmp    37d9 <atoi+0x33>

000037e5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    37e5:	f3 0f 1e fb          	endbr32 
    37e9:	55                   	push   %ebp
    37ea:	89 e5                	mov    %esp,%ebp
    37ec:	56                   	push   %esi
    37ed:	53                   	push   %ebx
    37ee:	8b 75 08             	mov    0x8(%ebp),%esi
    37f1:	8b 55 0c             	mov    0xc(%ebp),%edx
    37f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    37f7:	85 db                	test   %ebx,%ebx
    37f9:	7e 15                	jle    3810 <memmove+0x2b>
    37fb:	01 f3                	add    %esi,%ebx
  dst = vdst;
    37fd:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
    37ff:	83 c2 01             	add    $0x1,%edx
    3802:	83 c0 01             	add    $0x1,%eax
    3805:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
    3809:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
    380c:	39 c3                	cmp    %eax,%ebx
    380e:	75 ef                	jne    37ff <memmove+0x1a>
  return vdst;
}
    3810:	89 f0                	mov    %esi,%eax
    3812:	5b                   	pop    %ebx
    3813:	5e                   	pop    %esi
    3814:	5d                   	pop    %ebp
    3815:	c3                   	ret    

00003816 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3816:	b8 01 00 00 00       	mov    $0x1,%eax
    381b:	cd 40                	int    $0x40
    381d:	c3                   	ret    

0000381e <exit>:
SYSCALL(exit)
    381e:	b8 02 00 00 00       	mov    $0x2,%eax
    3823:	cd 40                	int    $0x40
    3825:	c3                   	ret    

00003826 <wait>:
SYSCALL(wait)
    3826:	b8 03 00 00 00       	mov    $0x3,%eax
    382b:	cd 40                	int    $0x40
    382d:	c3                   	ret    

0000382e <pipe>:
SYSCALL(pipe)
    382e:	b8 04 00 00 00       	mov    $0x4,%eax
    3833:	cd 40                	int    $0x40
    3835:	c3                   	ret    

00003836 <read>:
SYSCALL(read)
    3836:	b8 05 00 00 00       	mov    $0x5,%eax
    383b:	cd 40                	int    $0x40
    383d:	c3                   	ret    

0000383e <write>:
SYSCALL(write)
    383e:	b8 10 00 00 00       	mov    $0x10,%eax
    3843:	cd 40                	int    $0x40
    3845:	c3                   	ret    

00003846 <close>:
SYSCALL(close)
    3846:	b8 15 00 00 00       	mov    $0x15,%eax
    384b:	cd 40                	int    $0x40
    384d:	c3                   	ret    

0000384e <kill>:
SYSCALL(kill)
    384e:	b8 06 00 00 00       	mov    $0x6,%eax
    3853:	cd 40                	int    $0x40
    3855:	c3                   	ret    

00003856 <exec>:
SYSCALL(exec)
    3856:	b8 07 00 00 00       	mov    $0x7,%eax
    385b:	cd 40                	int    $0x40
    385d:	c3                   	ret    

0000385e <open>:
SYSCALL(open)
    385e:	b8 0f 00 00 00       	mov    $0xf,%eax
    3863:	cd 40                	int    $0x40
    3865:	c3                   	ret    

00003866 <mknod>:
SYSCALL(mknod)
    3866:	b8 11 00 00 00       	mov    $0x11,%eax
    386b:	cd 40                	int    $0x40
    386d:	c3                   	ret    

0000386e <unlink>:
SYSCALL(unlink)
    386e:	b8 12 00 00 00       	mov    $0x12,%eax
    3873:	cd 40                	int    $0x40
    3875:	c3                   	ret    

00003876 <fstat>:
SYSCALL(fstat)
    3876:	b8 08 00 00 00       	mov    $0x8,%eax
    387b:	cd 40                	int    $0x40
    387d:	c3                   	ret    

0000387e <link>:
SYSCALL(link)
    387e:	b8 13 00 00 00       	mov    $0x13,%eax
    3883:	cd 40                	int    $0x40
    3885:	c3                   	ret    

00003886 <mkdir>:
SYSCALL(mkdir)
    3886:	b8 14 00 00 00       	mov    $0x14,%eax
    388b:	cd 40                	int    $0x40
    388d:	c3                   	ret    

0000388e <chdir>:
SYSCALL(chdir)
    388e:	b8 09 00 00 00       	mov    $0x9,%eax
    3893:	cd 40                	int    $0x40
    3895:	c3                   	ret    

00003896 <dup>:
SYSCALL(dup)
    3896:	b8 0a 00 00 00       	mov    $0xa,%eax
    389b:	cd 40                	int    $0x40
    389d:	c3                   	ret    

0000389e <getpid>:
SYSCALL(getpid)
    389e:	b8 0b 00 00 00       	mov    $0xb,%eax
    38a3:	cd 40                	int    $0x40
    38a5:	c3                   	ret    

000038a6 <sbrk>:
SYSCALL(sbrk)
    38a6:	b8 0c 00 00 00       	mov    $0xc,%eax
    38ab:	cd 40                	int    $0x40
    38ad:	c3                   	ret    

000038ae <sleep>:
SYSCALL(sleep)
    38ae:	b8 0d 00 00 00       	mov    $0xd,%eax
    38b3:	cd 40                	int    $0x40
    38b5:	c3                   	ret    

000038b6 <uptime>:
SYSCALL(uptime)
    38b6:	b8 0e 00 00 00       	mov    $0xe,%eax
    38bb:	cd 40                	int    $0x40
    38bd:	c3                   	ret    

000038be <slabtest>:
SYSCALL(slabtest)
    38be:	b8 16 00 00 00       	mov    $0x16,%eax
    38c3:	cd 40                	int    $0x40
    38c5:	c3                   	ret    

000038c6 <ps>:
SYSCALL(ps)
    38c6:	b8 17 00 00 00       	mov    $0x17,%eax
    38cb:	cd 40                	int    $0x40
    38cd:	c3                   	ret    

000038ce <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    38ce:	55                   	push   %ebp
    38cf:	89 e5                	mov    %esp,%ebp
    38d1:	57                   	push   %edi
    38d2:	56                   	push   %esi
    38d3:	53                   	push   %ebx
    38d4:	83 ec 3c             	sub    $0x3c,%esp
    38d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    38da:	89 d3                	mov    %edx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    38dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    38e0:	74 77                	je     3959 <printint+0x8b>
    38e2:	85 d2                	test   %edx,%edx
    38e4:	79 73                	jns    3959 <printint+0x8b>
    neg = 1;
    x = -xx;
    38e6:	f7 db                	neg    %ebx
    neg = 1;
    38e8:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    38ef:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
    38f4:	89 f7                	mov    %esi,%edi
    38f6:	83 c6 01             	add    $0x1,%esi
    38f9:	89 d8                	mov    %ebx,%eax
    38fb:	ba 00 00 00 00       	mov    $0x0,%edx
    3900:	f7 f1                	div    %ecx
    3902:	0f b6 92 1c 54 00 00 	movzbl 0x541c(%edx),%edx
    3909:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
    390d:	89 da                	mov    %ebx,%edx
    390f:	89 c3                	mov    %eax,%ebx
    3911:	39 d1                	cmp    %edx,%ecx
    3913:	76 df                	jbe    38f4 <printint+0x26>
  if(neg)
    3915:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
    3919:	74 08                	je     3923 <printint+0x55>
    buf[i++] = '-';
    391b:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    3920:	8d 77 02             	lea    0x2(%edi),%esi

  while(--i >= 0)
    3923:	85 f6                	test   %esi,%esi
    3925:	7e 2a                	jle    3951 <printint+0x83>
    3927:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
    392b:	8d 7d d8             	lea    -0x28(%ebp),%edi
  write(fd, &c, 1);
    392e:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
    3931:	0f b6 03             	movzbl (%ebx),%eax
    3934:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
    3937:	83 ec 04             	sub    $0x4,%esp
    393a:	6a 01                	push   $0x1
    393c:	56                   	push   %esi
    393d:	ff 75 c4             	pushl  -0x3c(%ebp)
    3940:	e8 f9 fe ff ff       	call   383e <write>
  while(--i >= 0)
    3945:	89 d8                	mov    %ebx,%eax
    3947:	83 eb 01             	sub    $0x1,%ebx
    394a:	83 c4 10             	add    $0x10,%esp
    394d:	39 f8                	cmp    %edi,%eax
    394f:	75 e0                	jne    3931 <printint+0x63>
}
    3951:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3954:	5b                   	pop    %ebx
    3955:	5e                   	pop    %esi
    3956:	5f                   	pop    %edi
    3957:	5d                   	pop    %ebp
    3958:	c3                   	ret    
  neg = 0;
    3959:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
    3960:	eb 8d                	jmp    38ef <printint+0x21>

00003962 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3962:	f3 0f 1e fb          	endbr32 
    3966:	55                   	push   %ebp
    3967:	89 e5                	mov    %esp,%ebp
    3969:	57                   	push   %edi
    396a:	56                   	push   %esi
    396b:	53                   	push   %ebx
    396c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    396f:	8b 75 0c             	mov    0xc(%ebp),%esi
    3972:	0f b6 1e             	movzbl (%esi),%ebx
    3975:	84 db                	test   %bl,%bl
    3977:	0f 84 ab 01 00 00    	je     3b28 <printf+0x1c6>
    397d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    3980:	8d 45 10             	lea    0x10(%ebp),%eax
    3983:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    3986:	bf 00 00 00 00       	mov    $0x0,%edi
    398b:	eb 2d                	jmp    39ba <printf+0x58>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    398d:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3990:	83 ec 04             	sub    $0x4,%esp
    3993:	6a 01                	push   $0x1
    3995:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3998:	50                   	push   %eax
    3999:	ff 75 08             	pushl  0x8(%ebp)
    399c:	e8 9d fe ff ff       	call   383e <write>
        putc(fd, c);
    39a1:	83 c4 10             	add    $0x10,%esp
    39a4:	eb 05                	jmp    39ab <printf+0x49>
      }
    } else if(state == '%'){
    39a6:	83 ff 25             	cmp    $0x25,%edi
    39a9:	74 22                	je     39cd <printf+0x6b>
  for(i = 0; fmt[i]; i++){
    39ab:	83 c6 01             	add    $0x1,%esi
    39ae:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    39b2:	84 db                	test   %bl,%bl
    39b4:	0f 84 6e 01 00 00    	je     3b28 <printf+0x1c6>
    c = fmt[i] & 0xff;
    39ba:	0f be d3             	movsbl %bl,%edx
    39bd:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    39c0:	85 ff                	test   %edi,%edi
    39c2:	75 e2                	jne    39a6 <printf+0x44>
      if(c == '%'){
    39c4:	83 f8 25             	cmp    $0x25,%eax
    39c7:	75 c4                	jne    398d <printf+0x2b>
        state = '%';
    39c9:	89 c7                	mov    %eax,%edi
    39cb:	eb de                	jmp    39ab <printf+0x49>
      if(c == 'd'){
    39cd:	83 f8 64             	cmp    $0x64,%eax
    39d0:	74 59                	je     3a2b <printf+0xc9>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    39d2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    39d8:	83 fa 70             	cmp    $0x70,%edx
    39db:	74 7a                	je     3a57 <printf+0xf5>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    39dd:	83 f8 73             	cmp    $0x73,%eax
    39e0:	0f 84 9d 00 00 00    	je     3a83 <printf+0x121>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    39e6:	83 f8 63             	cmp    $0x63,%eax
    39e9:	0f 84 ec 00 00 00    	je     3adb <printf+0x179>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    39ef:	83 f8 25             	cmp    $0x25,%eax
    39f2:	0f 84 0f 01 00 00    	je     3b07 <printf+0x1a5>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    39f8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    39fc:	83 ec 04             	sub    $0x4,%esp
    39ff:	6a 01                	push   $0x1
    3a01:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a04:	50                   	push   %eax
    3a05:	ff 75 08             	pushl  0x8(%ebp)
    3a08:	e8 31 fe ff ff       	call   383e <write>
        putc(fd, c);
    3a0d:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3a10:	83 c4 0c             	add    $0xc,%esp
    3a13:	6a 01                	push   $0x1
    3a15:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a18:	50                   	push   %eax
    3a19:	ff 75 08             	pushl  0x8(%ebp)
    3a1c:	e8 1d fe ff ff       	call   383e <write>
        putc(fd, c);
    3a21:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3a24:	bf 00 00 00 00       	mov    $0x0,%edi
    3a29:	eb 80                	jmp    39ab <printf+0x49>
        printint(fd, *ap, 10, 1);
    3a2b:	83 ec 0c             	sub    $0xc,%esp
    3a2e:	6a 01                	push   $0x1
    3a30:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3a35:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3a38:	8b 17                	mov    (%edi),%edx
    3a3a:	8b 45 08             	mov    0x8(%ebp),%eax
    3a3d:	e8 8c fe ff ff       	call   38ce <printint>
        ap++;
    3a42:	89 f8                	mov    %edi,%eax
    3a44:	83 c0 04             	add    $0x4,%eax
    3a47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a4a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a4d:	bf 00 00 00 00       	mov    $0x0,%edi
    3a52:	e9 54 ff ff ff       	jmp    39ab <printf+0x49>
        printint(fd, *ap, 16, 0);
    3a57:	83 ec 0c             	sub    $0xc,%esp
    3a5a:	6a 00                	push   $0x0
    3a5c:	b9 10 00 00 00       	mov    $0x10,%ecx
    3a61:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3a64:	8b 17                	mov    (%edi),%edx
    3a66:	8b 45 08             	mov    0x8(%ebp),%eax
    3a69:	e8 60 fe ff ff       	call   38ce <printint>
        ap++;
    3a6e:	89 f8                	mov    %edi,%eax
    3a70:	83 c0 04             	add    $0x4,%eax
    3a73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a76:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a79:	bf 00 00 00 00       	mov    $0x0,%edi
    3a7e:	e9 28 ff ff ff       	jmp    39ab <printf+0x49>
        s = (char*)*ap;
    3a83:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    3a86:	8b 01                	mov    (%ecx),%eax
        ap++;
    3a88:	83 c1 04             	add    $0x4,%ecx
    3a8b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    3a8e:	85 c0                	test   %eax,%eax
    3a90:	74 13                	je     3aa5 <printf+0x143>
        s = (char*)*ap;
    3a92:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    3a94:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    3a97:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    3a9c:	84 c0                	test   %al,%al
    3a9e:	75 0f                	jne    3aaf <printf+0x14d>
    3aa0:	e9 06 ff ff ff       	jmp    39ab <printf+0x49>
          s = "(null)";
    3aa5:	bb 12 54 00 00       	mov    $0x5412,%ebx
        while(*s != 0){
    3aaa:	b8 28 00 00 00       	mov    $0x28,%eax
    3aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
    3ab2:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3ab5:	83 ec 04             	sub    $0x4,%esp
    3ab8:	6a 01                	push   $0x1
    3aba:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3abd:	50                   	push   %eax
    3abe:	57                   	push   %edi
    3abf:	e8 7a fd ff ff       	call   383e <write>
          s++;
    3ac4:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    3ac7:	0f b6 03             	movzbl (%ebx),%eax
    3aca:	83 c4 10             	add    $0x10,%esp
    3acd:	84 c0                	test   %al,%al
    3acf:	75 e1                	jne    3ab2 <printf+0x150>
      state = 0;
    3ad1:	bf 00 00 00 00       	mov    $0x0,%edi
    3ad6:	e9 d0 fe ff ff       	jmp    39ab <printf+0x49>
        putc(fd, *ap);
    3adb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3ade:	8b 07                	mov    (%edi),%eax
    3ae0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3ae3:	83 ec 04             	sub    $0x4,%esp
    3ae6:	6a 01                	push   $0x1
    3ae8:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3aeb:	50                   	push   %eax
    3aec:	ff 75 08             	pushl  0x8(%ebp)
    3aef:	e8 4a fd ff ff       	call   383e <write>
        ap++;
    3af4:	83 c7 04             	add    $0x4,%edi
    3af7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    3afa:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3afd:	bf 00 00 00 00       	mov    $0x0,%edi
    3b02:	e9 a4 fe ff ff       	jmp    39ab <printf+0x49>
        putc(fd, c);
    3b07:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3b0a:	83 ec 04             	sub    $0x4,%esp
    3b0d:	6a 01                	push   $0x1
    3b0f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3b12:	50                   	push   %eax
    3b13:	ff 75 08             	pushl  0x8(%ebp)
    3b16:	e8 23 fd ff ff       	call   383e <write>
    3b1b:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b1e:	bf 00 00 00 00       	mov    $0x0,%edi
    3b23:	e9 83 fe ff ff       	jmp    39ab <printf+0x49>
    }
  }
}
    3b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3b2b:	5b                   	pop    %ebx
    3b2c:	5e                   	pop    %esi
    3b2d:	5f                   	pop    %edi
    3b2e:	5d                   	pop    %ebp
    3b2f:	c3                   	ret    

00003b30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3b30:	f3 0f 1e fb          	endbr32 
    3b34:	55                   	push   %ebp
    3b35:	89 e5                	mov    %esp,%ebp
    3b37:	57                   	push   %edi
    3b38:	56                   	push   %esi
    3b39:	53                   	push   %ebx
    3b3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3b3d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b40:	a1 40 5d 00 00       	mov    0x5d40,%eax
    3b45:	eb 0c                	jmp    3b53 <free+0x23>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b47:	8b 10                	mov    (%eax),%edx
    3b49:	39 c2                	cmp    %eax,%edx
    3b4b:	77 04                	ja     3b51 <free+0x21>
    3b4d:	39 ca                	cmp    %ecx,%edx
    3b4f:	77 10                	ja     3b61 <free+0x31>
{
    3b51:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b53:	39 c8                	cmp    %ecx,%eax
    3b55:	73 f0                	jae    3b47 <free+0x17>
    3b57:	8b 10                	mov    (%eax),%edx
    3b59:	39 ca                	cmp    %ecx,%edx
    3b5b:	77 04                	ja     3b61 <free+0x31>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b5d:	39 c2                	cmp    %eax,%edx
    3b5f:	77 f0                	ja     3b51 <free+0x21>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3b61:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3b64:	8b 10                	mov    (%eax),%edx
    3b66:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3b69:	39 fa                	cmp    %edi,%edx
    3b6b:	74 19                	je     3b86 <free+0x56>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3b6d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3b70:	8b 50 04             	mov    0x4(%eax),%edx
    3b73:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3b76:	39 f1                	cmp    %esi,%ecx
    3b78:	74 1b                	je     3b95 <free+0x65>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3b7a:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3b7c:	a3 40 5d 00 00       	mov    %eax,0x5d40
}
    3b81:	5b                   	pop    %ebx
    3b82:	5e                   	pop    %esi
    3b83:	5f                   	pop    %edi
    3b84:	5d                   	pop    %ebp
    3b85:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3b86:	03 72 04             	add    0x4(%edx),%esi
    3b89:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3b8c:	8b 10                	mov    (%eax),%edx
    3b8e:	8b 12                	mov    (%edx),%edx
    3b90:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3b93:	eb db                	jmp    3b70 <free+0x40>
    p->s.size += bp->s.size;
    3b95:	03 53 fc             	add    -0x4(%ebx),%edx
    3b98:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3b9b:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3b9e:	89 10                	mov    %edx,(%eax)
    3ba0:	eb da                	jmp    3b7c <free+0x4c>

00003ba2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3ba2:	f3 0f 1e fb          	endbr32 
    3ba6:	55                   	push   %ebp
    3ba7:	89 e5                	mov    %esp,%ebp
    3ba9:	57                   	push   %edi
    3baa:	56                   	push   %esi
    3bab:	53                   	push   %ebx
    3bac:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3baf:	8b 45 08             	mov    0x8(%ebp),%eax
    3bb2:	8d 58 07             	lea    0x7(%eax),%ebx
    3bb5:	c1 eb 03             	shr    $0x3,%ebx
    3bb8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3bbb:	8b 15 40 5d 00 00    	mov    0x5d40,%edx
    3bc1:	85 d2                	test   %edx,%edx
    3bc3:	74 20                	je     3be5 <malloc+0x43>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3bc5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3bc7:	8b 48 04             	mov    0x4(%eax),%ecx
    3bca:	39 cb                	cmp    %ecx,%ebx
    3bcc:	76 3c                	jbe    3c0a <malloc+0x68>
    3bce:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    3bd4:	be 00 10 00 00       	mov    $0x1000,%esi
    3bd9:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    3bdc:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    3be3:	eb 72                	jmp    3c57 <malloc+0xb5>
    base.s.ptr = freep = prevp = &base;
    3be5:	c7 05 40 5d 00 00 44 	movl   $0x5d44,0x5d40
    3bec:	5d 00 00 
    3bef:	c7 05 44 5d 00 00 44 	movl   $0x5d44,0x5d44
    3bf6:	5d 00 00 
    base.s.size = 0;
    3bf9:	c7 05 48 5d 00 00 00 	movl   $0x0,0x5d48
    3c00:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c03:	b8 44 5d 00 00       	mov    $0x5d44,%eax
    3c08:	eb c4                	jmp    3bce <malloc+0x2c>
      if(p->s.size == nunits)
    3c0a:	39 cb                	cmp    %ecx,%ebx
    3c0c:	74 1e                	je     3c2c <malloc+0x8a>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3c0e:	29 d9                	sub    %ebx,%ecx
    3c10:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3c13:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3c16:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3c19:	89 15 40 5d 00 00    	mov    %edx,0x5d40
      return (void*)(p + 1);
    3c1f:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3c22:	89 d0                	mov    %edx,%eax
    3c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3c27:	5b                   	pop    %ebx
    3c28:	5e                   	pop    %esi
    3c29:	5f                   	pop    %edi
    3c2a:	5d                   	pop    %ebp
    3c2b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    3c2c:	8b 08                	mov    (%eax),%ecx
    3c2e:	89 0a                	mov    %ecx,(%edx)
    3c30:	eb e7                	jmp    3c19 <malloc+0x77>
  hp->s.size = nu;
    3c32:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    3c35:	83 ec 0c             	sub    $0xc,%esp
    3c38:	83 c0 08             	add    $0x8,%eax
    3c3b:	50                   	push   %eax
    3c3c:	e8 ef fe ff ff       	call   3b30 <free>
  return freep;
    3c41:	8b 15 40 5d 00 00    	mov    0x5d40,%edx
      if((p = morecore(nunits)) == 0)
    3c47:	83 c4 10             	add    $0x10,%esp
    3c4a:	85 d2                	test   %edx,%edx
    3c4c:	74 d4                	je     3c22 <malloc+0x80>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c4e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3c50:	8b 48 04             	mov    0x4(%eax),%ecx
    3c53:	39 d9                	cmp    %ebx,%ecx
    3c55:	73 b3                	jae    3c0a <malloc+0x68>
    if(p == freep)
    3c57:	89 c2                	mov    %eax,%edx
    3c59:	39 05 40 5d 00 00    	cmp    %eax,0x5d40
    3c5f:	75 ed                	jne    3c4e <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
    3c61:	83 ec 0c             	sub    $0xc,%esp
    3c64:	57                   	push   %edi
    3c65:	e8 3c fc ff ff       	call   38a6 <sbrk>
  if(p == (char*)-1)
    3c6a:	83 c4 10             	add    $0x10,%esp
    3c6d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c70:	75 c0                	jne    3c32 <malloc+0x90>
        return 0;
    3c72:	ba 00 00 00 00       	mov    $0x0,%edx
    3c77:	eb a9                	jmp    3c22 <malloc+0x80>
