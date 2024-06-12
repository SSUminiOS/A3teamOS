
user/_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 38 3c 00 00       	push   $0x3c38
       b:	ff 35 10 5c 00 00    	push   0x5c10
      11:	e8 95 38 00 00       	call   38ab <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 cb 3b 00 00 	movl   $0x3bcb,(%esp)
      1d:	e8 a9 37 00 00       	call   37cb <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	78 54                	js     7d <iputtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 cb 3b 00 00       	push   $0x3bcb
      31:	e8 9d 37 00 00       	call   37d3 <chdir>
      36:	83 c4 10             	add    $0x10,%esp
      39:	85 c0                	test   %eax,%eax
      3b:	78 58                	js     95 <iputtest+0x95>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      3d:	83 ec 0c             	sub    $0xc,%esp
      40:	68 c8 3b 00 00       	push   $0x3bc8
      45:	e8 69 37 00 00       	call   37b3 <unlink>
      4a:	83 c4 10             	add    $0x10,%esp
      4d:	85 c0                	test   %eax,%eax
      4f:	78 5c                	js     ad <iputtest+0xad>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	68 ed 3b 00 00       	push   $0x3bed
      59:	e8 75 37 00 00       	call   37d3 <chdir>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	78 60                	js     c5 <iputtest+0xc5>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      65:	83 ec 08             	sub    $0x8,%esp
      68:	68 70 3c 00 00       	push   $0x3c70
      6d:	ff 35 10 5c 00 00    	push   0x5c10
      73:	e8 33 38 00 00       	call   38ab <printf>
}
      78:	83 c4 10             	add    $0x10,%esp
      7b:	c9                   	leave  
      7c:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      7d:	83 ec 08             	sub    $0x8,%esp
      80:	68 a4 3b 00 00       	push   $0x3ba4
      85:	ff 35 10 5c 00 00    	push   0x5c10
      8b:	e8 1b 38 00 00       	call   38ab <printf>
    exit();
      90:	e8 ce 36 00 00       	call   3763 <exit>
    printf(stdout, "chdir iputdir failed\n");
      95:	83 ec 08             	sub    $0x8,%esp
      98:	68 b2 3b 00 00       	push   $0x3bb2
      9d:	ff 35 10 5c 00 00    	push   0x5c10
      a3:	e8 03 38 00 00       	call   38ab <printf>
    exit();
      a8:	e8 b6 36 00 00       	call   3763 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      ad:	83 ec 08             	sub    $0x8,%esp
      b0:	68 d3 3b 00 00       	push   $0x3bd3
      b5:	ff 35 10 5c 00 00    	push   0x5c10
      bb:	e8 eb 37 00 00       	call   38ab <printf>
    exit();
      c0:	e8 9e 36 00 00       	call   3763 <exit>
    printf(stdout, "chdir / failed\n");
      c5:	83 ec 08             	sub    $0x8,%esp
      c8:	68 ef 3b 00 00       	push   $0x3bef
      cd:	ff 35 10 5c 00 00    	push   0x5c10
      d3:	e8 d3 37 00 00       	call   38ab <printf>
    exit();
      d8:	e8 86 36 00 00       	call   3763 <exit>

000000dd <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      dd:	55                   	push   %ebp
      de:	89 e5                	mov    %esp,%ebp
      e0:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e3:	68 ff 3b 00 00       	push   $0x3bff
      e8:	ff 35 10 5c 00 00    	push   0x5c10
      ee:	e8 b8 37 00 00       	call   38ab <printf>

  pid = fork();
      f3:	e8 63 36 00 00       	call   375b <fork>
  if(pid < 0){
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	85 c0                	test   %eax,%eax
      fd:	78 47                	js     146 <exitiputtest+0x69>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
      ff:	0f 85 a1 00 00 00    	jne    1a6 <exitiputtest+0xc9>
    if(mkdir("iputdir") < 0){
     105:	83 ec 0c             	sub    $0xc,%esp
     108:	68 cb 3b 00 00       	push   $0x3bcb
     10d:	e8 b9 36 00 00       	call   37cb <mkdir>
     112:	83 c4 10             	add    $0x10,%esp
     115:	85 c0                	test   %eax,%eax
     117:	78 45                	js     15e <exitiputtest+0x81>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     119:	83 ec 0c             	sub    $0xc,%esp
     11c:	68 cb 3b 00 00       	push   $0x3bcb
     121:	e8 ad 36 00 00       	call   37d3 <chdir>
     126:	83 c4 10             	add    $0x10,%esp
     129:	85 c0                	test   %eax,%eax
     12b:	78 49                	js     176 <exitiputtest+0x99>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	68 c8 3b 00 00       	push   $0x3bc8
     135:	e8 79 36 00 00       	call   37b3 <unlink>
     13a:	83 c4 10             	add    $0x10,%esp
     13d:	85 c0                	test   %eax,%eax
     13f:	78 4d                	js     18e <exitiputtest+0xb1>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     141:	e8 1d 36 00 00       	call   3763 <exit>
    printf(stdout, "fork failed\n");
     146:	83 ec 08             	sub    $0x8,%esp
     149:	68 e5 4a 00 00       	push   $0x4ae5
     14e:	ff 35 10 5c 00 00    	push   0x5c10
     154:	e8 52 37 00 00       	call   38ab <printf>
    exit();
     159:	e8 05 36 00 00       	call   3763 <exit>
      printf(stdout, "mkdir failed\n");
     15e:	83 ec 08             	sub    $0x8,%esp
     161:	68 a4 3b 00 00       	push   $0x3ba4
     166:	ff 35 10 5c 00 00    	push   0x5c10
     16c:	e8 3a 37 00 00       	call   38ab <printf>
      exit();
     171:	e8 ed 35 00 00       	call   3763 <exit>
      printf(stdout, "child chdir failed\n");
     176:	83 ec 08             	sub    $0x8,%esp
     179:	68 0e 3c 00 00       	push   $0x3c0e
     17e:	ff 35 10 5c 00 00    	push   0x5c10
     184:	e8 22 37 00 00       	call   38ab <printf>
      exit();
     189:	e8 d5 35 00 00       	call   3763 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     18e:	83 ec 08             	sub    $0x8,%esp
     191:	68 d3 3b 00 00       	push   $0x3bd3
     196:	ff 35 10 5c 00 00    	push   0x5c10
     19c:	e8 0a 37 00 00       	call   38ab <printf>
      exit();
     1a1:	e8 bd 35 00 00       	call   3763 <exit>
  }
  wait();
     1a6:	e8 c0 35 00 00       	call   376b <wait>
  printf(stdout, "exitiput test ok\n");
     1ab:	83 ec 08             	sub    $0x8,%esp
     1ae:	68 22 3c 00 00       	push   $0x3c22
     1b3:	ff 35 10 5c 00 00    	push   0x5c10
     1b9:	e8 ed 36 00 00       	call   38ab <printf>
}
     1be:	83 c4 10             	add    $0x10,%esp
     1c1:	c9                   	leave  
     1c2:	c3                   	ret    

000001c3 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c3:	55                   	push   %ebp
     1c4:	89 e5                	mov    %esp,%ebp
     1c6:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1c9:	68 34 3c 00 00       	push   $0x3c34
     1ce:	ff 35 10 5c 00 00    	push   0x5c10
     1d4:	e8 d2 36 00 00       	call   38ab <printf>
  if(mkdir("oidir") < 0){
     1d9:	c7 04 24 43 3c 00 00 	movl   $0x3c43,(%esp)
     1e0:	e8 e6 35 00 00       	call   37cb <mkdir>
     1e5:	83 c4 10             	add    $0x10,%esp
     1e8:	85 c0                	test   %eax,%eax
     1ea:	78 39                	js     225 <openiputtest+0x62>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1ec:	e8 6a 35 00 00       	call   375b <fork>
  if(pid < 0){
     1f1:	85 c0                	test   %eax,%eax
     1f3:	78 48                	js     23d <openiputtest+0x7a>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     1f5:	75 63                	jne    25a <openiputtest+0x97>
    int fd = open("oidir", O_RDWR);
     1f7:	83 ec 08             	sub    $0x8,%esp
     1fa:	6a 02                	push   $0x2
     1fc:	68 43 3c 00 00       	push   $0x3c43
     201:	e8 9d 35 00 00       	call   37a3 <open>
    if(fd >= 0){
     206:	83 c4 10             	add    $0x10,%esp
     209:	85 c0                	test   %eax,%eax
     20b:	78 48                	js     255 <openiputtest+0x92>
      printf(stdout, "open directory for write succeeded\n");
     20d:	83 ec 08             	sub    $0x8,%esp
     210:	68 c8 4b 00 00       	push   $0x4bc8
     215:	ff 35 10 5c 00 00    	push   0x5c10
     21b:	e8 8b 36 00 00       	call   38ab <printf>
      exit();
     220:	e8 3e 35 00 00       	call   3763 <exit>
    printf(stdout, "mkdir oidir failed\n");
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 49 3c 00 00       	push   $0x3c49
     22d:	ff 35 10 5c 00 00    	push   0x5c10
     233:	e8 73 36 00 00       	call   38ab <printf>
    exit();
     238:	e8 26 35 00 00       	call   3763 <exit>
    printf(stdout, "fork failed\n");
     23d:	83 ec 08             	sub    $0x8,%esp
     240:	68 e5 4a 00 00       	push   $0x4ae5
     245:	ff 35 10 5c 00 00    	push   0x5c10
     24b:	e8 5b 36 00 00       	call   38ab <printf>
    exit();
     250:	e8 0e 35 00 00       	call   3763 <exit>
    }
    exit();
     255:	e8 09 35 00 00       	call   3763 <exit>
  }
  sleep(1);
     25a:	83 ec 0c             	sub    $0xc,%esp
     25d:	6a 01                	push   $0x1
     25f:	e8 8f 35 00 00       	call   37f3 <sleep>
  if(unlink("oidir") != 0){
     264:	c7 04 24 43 3c 00 00 	movl   $0x3c43,(%esp)
     26b:	e8 43 35 00 00       	call   37b3 <unlink>
     270:	83 c4 10             	add    $0x10,%esp
     273:	85 c0                	test   %eax,%eax
     275:	75 1d                	jne    294 <openiputtest+0xd1>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     277:	e8 ef 34 00 00       	call   376b <wait>
  printf(stdout, "openiput test ok\n");
     27c:	83 ec 08             	sub    $0x8,%esp
     27f:	68 6c 3c 00 00       	push   $0x3c6c
     284:	ff 35 10 5c 00 00    	push   0x5c10
     28a:	e8 1c 36 00 00       	call   38ab <printf>
}
     28f:	83 c4 10             	add    $0x10,%esp
     292:	c9                   	leave  
     293:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     294:	83 ec 08             	sub    $0x8,%esp
     297:	68 5d 3c 00 00       	push   $0x3c5d
     29c:	ff 35 10 5c 00 00    	push   0x5c10
     2a2:	e8 04 36 00 00       	call   38ab <printf>
    exit();
     2a7:	e8 b7 34 00 00       	call   3763 <exit>

000002ac <opentest>:

// simple file system tests

void
opentest(void)
{
     2ac:	55                   	push   %ebp
     2ad:	89 e5                	mov    %esp,%ebp
     2af:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2b2:	68 7e 3c 00 00       	push   $0x3c7e
     2b7:	ff 35 10 5c 00 00    	push   0x5c10
     2bd:	e8 e9 35 00 00       	call   38ab <printf>
  fd = open("echo", 0);
     2c2:	83 c4 08             	add    $0x8,%esp
     2c5:	6a 00                	push   $0x0
     2c7:	68 89 3c 00 00       	push   $0x3c89
     2cc:	e8 d2 34 00 00       	call   37a3 <open>
  if(fd < 0){
     2d1:	83 c4 10             	add    $0x10,%esp
     2d4:	85 c0                	test   %eax,%eax
     2d6:	78 37                	js     30f <opentest+0x63>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2d8:	83 ec 0c             	sub    $0xc,%esp
     2db:	50                   	push   %eax
     2dc:	e8 aa 34 00 00       	call   378b <close>
  fd = open("doesnotexist", 0);
     2e1:	83 c4 08             	add    $0x8,%esp
     2e4:	6a 00                	push   $0x0
     2e6:	68 a1 3c 00 00       	push   $0x3ca1
     2eb:	e8 b3 34 00 00       	call   37a3 <open>
  if(fd >= 0){
     2f0:	83 c4 10             	add    $0x10,%esp
     2f3:	85 c0                	test   %eax,%eax
     2f5:	79 30                	jns    327 <opentest+0x7b>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     2f7:	83 ec 08             	sub    $0x8,%esp
     2fa:	68 cc 3c 00 00       	push   $0x3ccc
     2ff:	ff 35 10 5c 00 00    	push   0x5c10
     305:	e8 a1 35 00 00       	call   38ab <printf>
}
     30a:	83 c4 10             	add    $0x10,%esp
     30d:	c9                   	leave  
     30e:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     30f:	83 ec 08             	sub    $0x8,%esp
     312:	68 8e 3c 00 00       	push   $0x3c8e
     317:	ff 35 10 5c 00 00    	push   0x5c10
     31d:	e8 89 35 00 00       	call   38ab <printf>
    exit();
     322:	e8 3c 34 00 00       	call   3763 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     327:	83 ec 08             	sub    $0x8,%esp
     32a:	68 ae 3c 00 00       	push   $0x3cae
     32f:	ff 35 10 5c 00 00    	push   0x5c10
     335:	e8 71 35 00 00       	call   38ab <printf>
    exit();
     33a:	e8 24 34 00 00       	call   3763 <exit>

0000033f <writetest>:

void
writetest(void)
{
     33f:	55                   	push   %ebp
     340:	89 e5                	mov    %esp,%ebp
     342:	56                   	push   %esi
     343:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     344:	83 ec 08             	sub    $0x8,%esp
     347:	68 da 3c 00 00       	push   $0x3cda
     34c:	ff 35 10 5c 00 00    	push   0x5c10
     352:	e8 54 35 00 00       	call   38ab <printf>
  fd = open("small", O_CREATE|O_RDWR);
     357:	83 c4 08             	add    $0x8,%esp
     35a:	68 02 02 00 00       	push   $0x202
     35f:	68 eb 3c 00 00       	push   $0x3ceb
     364:	e8 3a 34 00 00       	call   37a3 <open>
  if(fd >= 0){
     369:	83 c4 10             	add    $0x10,%esp
     36c:	85 c0                	test   %eax,%eax
     36e:	0f 88 17 01 00 00    	js     48b <writetest+0x14c>
     374:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     376:	83 ec 08             	sub    $0x8,%esp
     379:	68 f1 3c 00 00       	push   $0x3cf1
     37e:	ff 35 10 5c 00 00    	push   0x5c10
     384:	e8 22 35 00 00       	call   38ab <printf>
     389:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     38c:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     391:	83 ec 04             	sub    $0x4,%esp
     394:	6a 0a                	push   $0xa
     396:	68 28 3d 00 00       	push   $0x3d28
     39b:	56                   	push   %esi
     39c:	e8 e2 33 00 00       	call   3783 <write>
     3a1:	83 c4 10             	add    $0x10,%esp
     3a4:	83 f8 0a             	cmp    $0xa,%eax
     3a7:	0f 85 f6 00 00 00    	jne    4a3 <writetest+0x164>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3ad:	83 ec 04             	sub    $0x4,%esp
     3b0:	6a 0a                	push   $0xa
     3b2:	68 33 3d 00 00       	push   $0x3d33
     3b7:	56                   	push   %esi
     3b8:	e8 c6 33 00 00       	call   3783 <write>
     3bd:	83 c4 10             	add    $0x10,%esp
     3c0:	83 f8 0a             	cmp    $0xa,%eax
     3c3:	0f 85 f3 00 00 00    	jne    4bc <writetest+0x17d>
  for(i = 0; i < 100; i++){
     3c9:	83 c3 01             	add    $0x1,%ebx
     3cc:	83 fb 64             	cmp    $0x64,%ebx
     3cf:	75 c0                	jne    391 <writetest+0x52>
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     3d1:	83 ec 08             	sub    $0x8,%esp
     3d4:	68 3e 3d 00 00       	push   $0x3d3e
     3d9:	ff 35 10 5c 00 00    	push   0x5c10
     3df:	e8 c7 34 00 00       	call   38ab <printf>
  close(fd);
     3e4:	89 34 24             	mov    %esi,(%esp)
     3e7:	e8 9f 33 00 00       	call   378b <close>
  fd = open("small", O_RDONLY);
     3ec:	83 c4 08             	add    $0x8,%esp
     3ef:	6a 00                	push   $0x0
     3f1:	68 eb 3c 00 00       	push   $0x3ceb
     3f6:	e8 a8 33 00 00       	call   37a3 <open>
     3fb:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     3fd:	83 c4 10             	add    $0x10,%esp
     400:	85 c0                	test   %eax,%eax
     402:	0f 88 cd 00 00 00    	js     4d5 <writetest+0x196>
    printf(stdout, "open small succeeded ok\n");
     408:	83 ec 08             	sub    $0x8,%esp
     40b:	68 49 3d 00 00       	push   $0x3d49
     410:	ff 35 10 5c 00 00    	push   0x5c10
     416:	e8 90 34 00 00       	call   38ab <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     41b:	83 c4 0c             	add    $0xc,%esp
     41e:	68 d0 07 00 00       	push   $0x7d0
     423:	68 60 83 00 00       	push   $0x8360
     428:	53                   	push   %ebx
     429:	e8 4d 33 00 00       	call   377b <read>
  if(i == 2000){
     42e:	83 c4 10             	add    $0x10,%esp
     431:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     436:	0f 85 b1 00 00 00    	jne    4ed <writetest+0x1ae>
    printf(stdout, "read succeeded ok\n");
     43c:	83 ec 08             	sub    $0x8,%esp
     43f:	68 7d 3d 00 00       	push   $0x3d7d
     444:	ff 35 10 5c 00 00    	push   0x5c10
     44a:	e8 5c 34 00 00       	call   38ab <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     44f:	89 1c 24             	mov    %ebx,(%esp)
     452:	e8 34 33 00 00       	call   378b <close>

  if(unlink("small") < 0){
     457:	c7 04 24 eb 3c 00 00 	movl   $0x3ceb,(%esp)
     45e:	e8 50 33 00 00       	call   37b3 <unlink>
     463:	83 c4 10             	add    $0x10,%esp
     466:	85 c0                	test   %eax,%eax
     468:	0f 88 97 00 00 00    	js     505 <writetest+0x1c6>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     46e:	83 ec 08             	sub    $0x8,%esp
     471:	68 a5 3d 00 00       	push   $0x3da5
     476:	ff 35 10 5c 00 00    	push   0x5c10
     47c:	e8 2a 34 00 00       	call   38ab <printf>
}
     481:	83 c4 10             	add    $0x10,%esp
     484:	8d 65 f8             	lea    -0x8(%ebp),%esp
     487:	5b                   	pop    %ebx
     488:	5e                   	pop    %esi
     489:	5d                   	pop    %ebp
     48a:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
     48b:	83 ec 08             	sub    $0x8,%esp
     48e:	68 0c 3d 00 00       	push   $0x3d0c
     493:	ff 35 10 5c 00 00    	push   0x5c10
     499:	e8 0d 34 00 00       	call   38ab <printf>
    exit();
     49e:	e8 c0 32 00 00       	call   3763 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     4a3:	83 ec 04             	sub    $0x4,%esp
     4a6:	53                   	push   %ebx
     4a7:	68 ec 4b 00 00       	push   $0x4bec
     4ac:	ff 35 10 5c 00 00    	push   0x5c10
     4b2:	e8 f4 33 00 00       	call   38ab <printf>
      exit();
     4b7:	e8 a7 32 00 00       	call   3763 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     4bc:	83 ec 04             	sub    $0x4,%esp
     4bf:	53                   	push   %ebx
     4c0:	68 10 4c 00 00       	push   $0x4c10
     4c5:	ff 35 10 5c 00 00    	push   0x5c10
     4cb:	e8 db 33 00 00       	call   38ab <printf>
      exit();
     4d0:	e8 8e 32 00 00       	call   3763 <exit>
    printf(stdout, "error: open small failed!\n");
     4d5:	83 ec 08             	sub    $0x8,%esp
     4d8:	68 62 3d 00 00       	push   $0x3d62
     4dd:	ff 35 10 5c 00 00    	push   0x5c10
     4e3:	e8 c3 33 00 00       	call   38ab <printf>
    exit();
     4e8:	e8 76 32 00 00       	call   3763 <exit>
    printf(stdout, "read failed\n");
     4ed:	83 ec 08             	sub    $0x8,%esp
     4f0:	68 a9 40 00 00       	push   $0x40a9
     4f5:	ff 35 10 5c 00 00    	push   0x5c10
     4fb:	e8 ab 33 00 00       	call   38ab <printf>
    exit();
     500:	e8 5e 32 00 00       	call   3763 <exit>
    printf(stdout, "unlink small failed\n");
     505:	83 ec 08             	sub    $0x8,%esp
     508:	68 90 3d 00 00       	push   $0x3d90
     50d:	ff 35 10 5c 00 00    	push   0x5c10
     513:	e8 93 33 00 00       	call   38ab <printf>
    exit();
     518:	e8 46 32 00 00       	call   3763 <exit>

0000051d <writetest1>:

void
writetest1(void)
{
     51d:	55                   	push   %ebp
     51e:	89 e5                	mov    %esp,%ebp
     520:	56                   	push   %esi
     521:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     522:	83 ec 08             	sub    $0x8,%esp
     525:	68 b9 3d 00 00       	push   $0x3db9
     52a:	ff 35 10 5c 00 00    	push   0x5c10
     530:	e8 76 33 00 00       	call   38ab <printf>

  fd = open("big", O_CREATE|O_RDWR);
     535:	83 c4 08             	add    $0x8,%esp
     538:	68 02 02 00 00       	push   $0x202
     53d:	68 33 3e 00 00       	push   $0x3e33
     542:	e8 5c 32 00 00       	call   37a3 <open>
  if(fd < 0){
     547:	83 c4 10             	add    $0x10,%esp
     54a:	85 c0                	test   %eax,%eax
     54c:	0f 88 96 00 00 00    	js     5e8 <writetest1+0xcb>
     552:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     554:	bb 00 00 00 00       	mov    $0x0,%ebx
    ((int*)buf)[0] = i;
     559:	89 1d 60 83 00 00    	mov    %ebx,0x8360
    if(write(fd, buf, 512) != 512){
     55f:	83 ec 04             	sub    $0x4,%esp
     562:	68 00 02 00 00       	push   $0x200
     567:	68 60 83 00 00       	push   $0x8360
     56c:	56                   	push   %esi
     56d:	e8 11 32 00 00       	call   3783 <write>
     572:	83 c4 10             	add    $0x10,%esp
     575:	3d 00 02 00 00       	cmp    $0x200,%eax
     57a:	0f 85 80 00 00 00    	jne    600 <writetest1+0xe3>
  for(i = 0; i < MAXFILE; i++){
     580:	83 c3 01             	add    $0x1,%ebx
     583:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     589:	75 ce                	jne    559 <writetest1+0x3c>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     58b:	83 ec 0c             	sub    $0xc,%esp
     58e:	56                   	push   %esi
     58f:	e8 f7 31 00 00       	call   378b <close>

  fd = open("big", O_RDONLY);
     594:	83 c4 08             	add    $0x8,%esp
     597:	6a 00                	push   $0x0
     599:	68 33 3e 00 00       	push   $0x3e33
     59e:	e8 00 32 00 00       	call   37a3 <open>
     5a3:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5a5:	83 c4 10             	add    $0x10,%esp
     5a8:	85 c0                	test   %eax,%eax
     5aa:	78 6d                	js     619 <writetest1+0xfc>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     5ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     5b1:	83 ec 04             	sub    $0x4,%esp
     5b4:	68 00 02 00 00       	push   $0x200
     5b9:	68 60 83 00 00       	push   $0x8360
     5be:	56                   	push   %esi
     5bf:	e8 b7 31 00 00       	call   377b <read>
    if(i == 0){
     5c4:	83 c4 10             	add    $0x10,%esp
     5c7:	85 c0                	test   %eax,%eax
     5c9:	74 66                	je     631 <writetest1+0x114>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     5cb:	3d 00 02 00 00       	cmp    $0x200,%eax
     5d0:	0f 85 b9 00 00 00    	jne    68f <writetest1+0x172>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5d6:	a1 60 83 00 00       	mov    0x8360,%eax
     5db:	39 d8                	cmp    %ebx,%eax
     5dd:	0f 85 c5 00 00 00    	jne    6a8 <writetest1+0x18b>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5e3:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     5e6:	eb c9                	jmp    5b1 <writetest1+0x94>
    printf(stdout, "error: creat big failed!\n");
     5e8:	83 ec 08             	sub    $0x8,%esp
     5eb:	68 c9 3d 00 00       	push   $0x3dc9
     5f0:	ff 35 10 5c 00 00    	push   0x5c10
     5f6:	e8 b0 32 00 00       	call   38ab <printf>
    exit();
     5fb:	e8 63 31 00 00       	call   3763 <exit>
      printf(stdout, "error: write big file failed\n", i);
     600:	83 ec 04             	sub    $0x4,%esp
     603:	53                   	push   %ebx
     604:	68 e3 3d 00 00       	push   $0x3de3
     609:	ff 35 10 5c 00 00    	push   0x5c10
     60f:	e8 97 32 00 00       	call   38ab <printf>
      exit();
     614:	e8 4a 31 00 00       	call   3763 <exit>
    printf(stdout, "error: open big failed!\n");
     619:	83 ec 08             	sub    $0x8,%esp
     61c:	68 01 3e 00 00       	push   $0x3e01
     621:	ff 35 10 5c 00 00    	push   0x5c10
     627:	e8 7f 32 00 00       	call   38ab <printf>
    exit();
     62c:	e8 32 31 00 00       	call   3763 <exit>
      if(n == MAXFILE - 1){
     631:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     637:	74 39                	je     672 <writetest1+0x155>
  }
  close(fd);
     639:	83 ec 0c             	sub    $0xc,%esp
     63c:	56                   	push   %esi
     63d:	e8 49 31 00 00       	call   378b <close>
  if(unlink("big") < 0){
     642:	c7 04 24 33 3e 00 00 	movl   $0x3e33,(%esp)
     649:	e8 65 31 00 00       	call   37b3 <unlink>
     64e:	83 c4 10             	add    $0x10,%esp
     651:	85 c0                	test   %eax,%eax
     653:	78 6a                	js     6bf <writetest1+0x1a2>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     655:	83 ec 08             	sub    $0x8,%esp
     658:	68 5a 3e 00 00       	push   $0x3e5a
     65d:	ff 35 10 5c 00 00    	push   0x5c10
     663:	e8 43 32 00 00       	call   38ab <printf>
}
     668:	83 c4 10             	add    $0x10,%esp
     66b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     66e:	5b                   	pop    %ebx
     66f:	5e                   	pop    %esi
     670:	5d                   	pop    %ebp
     671:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     672:	83 ec 04             	sub    $0x4,%esp
     675:	68 8b 00 00 00       	push   $0x8b
     67a:	68 1a 3e 00 00       	push   $0x3e1a
     67f:	ff 35 10 5c 00 00    	push   0x5c10
     685:	e8 21 32 00 00       	call   38ab <printf>
        exit();
     68a:	e8 d4 30 00 00       	call   3763 <exit>
      printf(stdout, "read failed %d\n", i);
     68f:	83 ec 04             	sub    $0x4,%esp
     692:	50                   	push   %eax
     693:	68 37 3e 00 00       	push   $0x3e37
     698:	ff 35 10 5c 00 00    	push   0x5c10
     69e:	e8 08 32 00 00       	call   38ab <printf>
      exit();
     6a3:	e8 bb 30 00 00       	call   3763 <exit>
      printf(stdout, "read content of block %d is %d\n",
     6a8:	50                   	push   %eax
     6a9:	53                   	push   %ebx
     6aa:	68 34 4c 00 00       	push   $0x4c34
     6af:	ff 35 10 5c 00 00    	push   0x5c10
     6b5:	e8 f1 31 00 00       	call   38ab <printf>
      exit();
     6ba:	e8 a4 30 00 00       	call   3763 <exit>
    printf(stdout, "unlink big failed\n");
     6bf:	83 ec 08             	sub    $0x8,%esp
     6c2:	68 47 3e 00 00       	push   $0x3e47
     6c7:	ff 35 10 5c 00 00    	push   0x5c10
     6cd:	e8 d9 31 00 00       	call   38ab <printf>
    exit();
     6d2:	e8 8c 30 00 00       	call   3763 <exit>

000006d7 <createtest>:

void
createtest(void)
{
     6d7:	55                   	push   %ebp
     6d8:	89 e5                	mov    %esp,%ebp
     6da:	53                   	push   %ebx
     6db:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6de:	68 54 4c 00 00       	push   $0x4c54
     6e3:	ff 35 10 5c 00 00    	push   0x5c10
     6e9:	e8 bd 31 00 00       	call   38ab <printf>

  name[0] = 'a';
     6ee:	c6 05 50 83 00 00 61 	movb   $0x61,0x8350
  name[2] = '\0';
     6f5:	c6 05 52 83 00 00 00 	movb   $0x0,0x8352
     6fc:	83 c4 10             	add    $0x10,%esp
     6ff:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     704:	88 1d 51 83 00 00    	mov    %bl,0x8351
    fd = open(name, O_CREATE|O_RDWR);
     70a:	83 ec 08             	sub    $0x8,%esp
     70d:	68 02 02 00 00       	push   $0x202
     712:	68 50 83 00 00       	push   $0x8350
     717:	e8 87 30 00 00       	call   37a3 <open>
    close(fd);
     71c:	89 04 24             	mov    %eax,(%esp)
     71f:	e8 67 30 00 00       	call   378b <close>
  for(i = 0; i < 52; i++){
     724:	83 c3 01             	add    $0x1,%ebx
     727:	83 c4 10             	add    $0x10,%esp
     72a:	80 fb 64             	cmp    $0x64,%bl
     72d:	75 d5                	jne    704 <createtest+0x2d>
  }
  name[0] = 'a';
     72f:	c6 05 50 83 00 00 61 	movb   $0x61,0x8350
  name[2] = '\0';
     736:	c6 05 52 83 00 00 00 	movb   $0x0,0x8352
     73d:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     742:	88 1d 51 83 00 00    	mov    %bl,0x8351
    unlink(name);
     748:	83 ec 0c             	sub    $0xc,%esp
     74b:	68 50 83 00 00       	push   $0x8350
     750:	e8 5e 30 00 00       	call   37b3 <unlink>
  for(i = 0; i < 52; i++){
     755:	83 c3 01             	add    $0x1,%ebx
     758:	83 c4 10             	add    $0x10,%esp
     75b:	80 fb 64             	cmp    $0x64,%bl
     75e:	75 e2                	jne    742 <createtest+0x6b>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     760:	83 ec 08             	sub    $0x8,%esp
     763:	68 7c 4c 00 00       	push   $0x4c7c
     768:	ff 35 10 5c 00 00    	push   0x5c10
     76e:	e8 38 31 00 00       	call   38ab <printf>
}
     773:	83 c4 10             	add    $0x10,%esp
     776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     779:	c9                   	leave  
     77a:	c3                   	ret    

0000077b <dirtest>:

void dirtest(void)
{
     77b:	55                   	push   %ebp
     77c:	89 e5                	mov    %esp,%ebp
     77e:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     781:	68 68 3e 00 00       	push   $0x3e68
     786:	ff 35 10 5c 00 00    	push   0x5c10
     78c:	e8 1a 31 00 00       	call   38ab <printf>

  if(mkdir("dir0") < 0){
     791:	c7 04 24 74 3e 00 00 	movl   $0x3e74,(%esp)
     798:	e8 2e 30 00 00       	call   37cb <mkdir>
     79d:	83 c4 10             	add    $0x10,%esp
     7a0:	85 c0                	test   %eax,%eax
     7a2:	78 54                	js     7f8 <dirtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7a4:	83 ec 0c             	sub    $0xc,%esp
     7a7:	68 74 3e 00 00       	push   $0x3e74
     7ac:	e8 22 30 00 00       	call   37d3 <chdir>
     7b1:	83 c4 10             	add    $0x10,%esp
     7b4:	85 c0                	test   %eax,%eax
     7b6:	78 58                	js     810 <dirtest+0x95>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7b8:	83 ec 0c             	sub    $0xc,%esp
     7bb:	68 19 44 00 00       	push   $0x4419
     7c0:	e8 0e 30 00 00       	call   37d3 <chdir>
     7c5:	83 c4 10             	add    $0x10,%esp
     7c8:	85 c0                	test   %eax,%eax
     7ca:	78 5c                	js     828 <dirtest+0xad>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7cc:	83 ec 0c             	sub    $0xc,%esp
     7cf:	68 74 3e 00 00       	push   $0x3e74
     7d4:	e8 da 2f 00 00       	call   37b3 <unlink>
     7d9:	83 c4 10             	add    $0x10,%esp
     7dc:	85 c0                	test   %eax,%eax
     7de:	78 60                	js     840 <dirtest+0xc5>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     7e0:	83 ec 08             	sub    $0x8,%esp
     7e3:	68 b1 3e 00 00       	push   $0x3eb1
     7e8:	ff 35 10 5c 00 00    	push   0x5c10
     7ee:	e8 b8 30 00 00       	call   38ab <printf>
}
     7f3:	83 c4 10             	add    $0x10,%esp
     7f6:	c9                   	leave  
     7f7:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 a4 3b 00 00       	push   $0x3ba4
     800:	ff 35 10 5c 00 00    	push   0x5c10
     806:	e8 a0 30 00 00       	call   38ab <printf>
    exit();
     80b:	e8 53 2f 00 00       	call   3763 <exit>
    printf(stdout, "chdir dir0 failed\n");
     810:	83 ec 08             	sub    $0x8,%esp
     813:	68 79 3e 00 00       	push   $0x3e79
     818:	ff 35 10 5c 00 00    	push   0x5c10
     81e:	e8 88 30 00 00       	call   38ab <printf>
    exit();
     823:	e8 3b 2f 00 00       	call   3763 <exit>
    printf(stdout, "chdir .. failed\n");
     828:	83 ec 08             	sub    $0x8,%esp
     82b:	68 8c 3e 00 00       	push   $0x3e8c
     830:	ff 35 10 5c 00 00    	push   0x5c10
     836:	e8 70 30 00 00       	call   38ab <printf>
    exit();
     83b:	e8 23 2f 00 00       	call   3763 <exit>
    printf(stdout, "unlink dir0 failed\n");
     840:	83 ec 08             	sub    $0x8,%esp
     843:	68 9d 3e 00 00       	push   $0x3e9d
     848:	ff 35 10 5c 00 00    	push   0x5c10
     84e:	e8 58 30 00 00       	call   38ab <printf>
    exit();
     853:	e8 0b 2f 00 00       	call   3763 <exit>

00000858 <exectest>:

void
exectest(void)
{
     858:	55                   	push   %ebp
     859:	89 e5                	mov    %esp,%ebp
     85b:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     85e:	68 c0 3e 00 00       	push   $0x3ec0
     863:	ff 35 10 5c 00 00    	push   0x5c10
     869:	e8 3d 30 00 00       	call   38ab <printf>
  if(exec("echo", echoargv) < 0){
     86e:	83 c4 08             	add    $0x8,%esp
     871:	68 14 5c 00 00       	push   $0x5c14
     876:	68 89 3c 00 00       	push   $0x3c89
     87b:	e8 1b 2f 00 00       	call   379b <exec>
     880:	83 c4 10             	add    $0x10,%esp
     883:	85 c0                	test   %eax,%eax
     885:	78 02                	js     889 <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     887:	c9                   	leave  
     888:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     889:	83 ec 08             	sub    $0x8,%esp
     88c:	68 cb 3e 00 00       	push   $0x3ecb
     891:	ff 35 10 5c 00 00    	push   0x5c10
     897:	e8 0f 30 00 00       	call   38ab <printf>
    exit();
     89c:	e8 c2 2e 00 00       	call   3763 <exit>

000008a1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8a1:	55                   	push   %ebp
     8a2:	89 e5                	mov    %esp,%ebp
     8a4:	57                   	push   %edi
     8a5:	56                   	push   %esi
     8a6:	53                   	push   %ebx
     8a7:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     8aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
     8ad:	50                   	push   %eax
     8ae:	e8 c0 2e 00 00       	call   3773 <pipe>
     8b3:	83 c4 10             	add    $0x10,%esp
     8b6:	85 c0                	test   %eax,%eax
     8b8:	0f 85 8c 00 00 00    	jne    94a <pipe1+0xa9>
     8be:	89 c3                	mov    %eax,%ebx
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     8c0:	e8 96 2e 00 00       	call   375b <fork>
     8c5:	89 c6                	mov    %eax,%esi
  seq = 0;
  if(pid == 0){
     8c7:	85 c0                	test   %eax,%eax
     8c9:	0f 84 8f 00 00 00    	je     95e <pipe1+0xbd>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8cf:	0f 8e 4f 01 00 00    	jle    a24 <pipe1+0x183>
    close(fds[1]);
     8d5:	83 ec 0c             	sub    $0xc,%esp
     8d8:	ff 75 e4             	push   -0x1c(%ebp)
     8db:	e8 ab 2e 00 00       	call   378b <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     8e0:	83 c4 10             	add    $0x10,%esp
    total = 0;
     8e3:	89 df                	mov    %ebx,%edi
    cc = 1;
     8e5:	be 01 00 00 00       	mov    $0x1,%esi
    while((n = read(fds[0], buf, cc)) > 0){
     8ea:	83 ec 04             	sub    $0x4,%esp
     8ed:	56                   	push   %esi
     8ee:	68 60 83 00 00       	push   $0x8360
     8f3:	ff 75 e0             	push   -0x20(%ebp)
     8f6:	e8 80 2e 00 00       	call   377b <read>
     8fb:	89 c2                	mov    %eax,%edx
     8fd:	83 c4 10             	add    $0x10,%esp
     900:	85 c0                	test   %eax,%eax
     902:	0f 8e d8 00 00 00    	jle    9e0 <pipe1+0x13f>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     908:	89 d8                	mov    %ebx,%eax
     90a:	32 05 60 83 00 00    	xor    0x8360,%al
     910:	0f b6 c0             	movzbl %al,%eax
     913:	85 c0                	test   %eax,%eax
     915:	75 19                	jne    930 <pipe1+0x8f>
     917:	8d 4b 01             	lea    0x1(%ebx),%ecx
     91a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
      for(i = 0; i < n; i++){
     91d:	83 c0 01             	add    $0x1,%eax
     920:	39 c2                	cmp    %eax,%edx
     922:	0f 84 a1 00 00 00    	je     9c9 <pipe1+0x128>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     928:	38 98 60 83 00 00    	cmp    %bl,0x8360(%eax)
     92e:	74 ea                	je     91a <pipe1+0x79>
          printf(1, "pipe1 oops 2\n");
     930:	83 ec 08             	sub    $0x8,%esp
     933:	68 fa 3e 00 00       	push   $0x3efa
     938:	6a 01                	push   $0x1
     93a:	e8 6c 2f 00 00       	call   38ab <printf>
     93f:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     942:	8d 65 f4             	lea    -0xc(%ebp),%esp
     945:	5b                   	pop    %ebx
     946:	5e                   	pop    %esi
     947:	5f                   	pop    %edi
     948:	5d                   	pop    %ebp
     949:	c3                   	ret    
    printf(1, "pipe() failed\n");
     94a:	83 ec 08             	sub    $0x8,%esp
     94d:	68 dd 3e 00 00       	push   $0x3edd
     952:	6a 01                	push   $0x1
     954:	e8 52 2f 00 00       	call   38ab <printf>
    exit();
     959:	e8 05 2e 00 00       	call   3763 <exit>
    close(fds[0]);
     95e:	83 ec 0c             	sub    $0xc,%esp
     961:	ff 75 e0             	push   -0x20(%ebp)
     964:	e8 22 2e 00 00       	call   378b <close>
     969:	83 c4 10             	add    $0x10,%esp
  seq = 0;
     96c:	89 f3                	mov    %esi,%ebx
      for(i = 0; i < 1033; i++)
     96e:	89 f0                	mov    %esi,%eax
        buf[i] = seq++;
     970:	8d 14 18             	lea    (%eax,%ebx,1),%edx
     973:	88 90 60 83 00 00    	mov    %dl,0x8360(%eax)
      for(i = 0; i < 1033; i++)
     979:	83 c0 01             	add    $0x1,%eax
     97c:	3d 09 04 00 00       	cmp    $0x409,%eax
     981:	75 ed                	jne    970 <pipe1+0xcf>
        buf[i] = seq++;
     983:	81 c3 09 04 00 00    	add    $0x409,%ebx
      if(write(fds[1], buf, 1033) != 1033){
     989:	83 ec 04             	sub    $0x4,%esp
     98c:	68 09 04 00 00       	push   $0x409
     991:	68 60 83 00 00       	push   $0x8360
     996:	ff 75 e4             	push   -0x1c(%ebp)
     999:	e8 e5 2d 00 00       	call   3783 <write>
     99e:	83 c4 10             	add    $0x10,%esp
     9a1:	3d 09 04 00 00       	cmp    $0x409,%eax
     9a6:	75 0d                	jne    9b5 <pipe1+0x114>
    for(n = 0; n < 5; n++){
     9a8:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     9ae:	75 be                	jne    96e <pipe1+0xcd>
    exit();
     9b0:	e8 ae 2d 00 00       	call   3763 <exit>
        printf(1, "pipe1 oops 1\n");
     9b5:	83 ec 08             	sub    $0x8,%esp
     9b8:	68 ec 3e 00 00       	push   $0x3eec
     9bd:	6a 01                	push   $0x1
     9bf:	e8 e7 2e 00 00       	call   38ab <printf>
        exit();
     9c4:	e8 9a 2d 00 00       	call   3763 <exit>
      total += n;
     9c9:	01 c7                	add    %eax,%edi
      cc = cc * 2;
     9cb:	01 f6                	add    %esi,%esi
        cc = sizeof(buf);
     9cd:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
     9d3:	b8 00 20 00 00       	mov    $0x2000,%eax
     9d8:	0f 43 f0             	cmovae %eax,%esi
     9db:	e9 0a ff ff ff       	jmp    8ea <pipe1+0x49>
    if(total != 5 * 1033){
     9e0:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
     9e6:	75 27                	jne    a0f <pipe1+0x16e>
    close(fds[0]);
     9e8:	83 ec 0c             	sub    $0xc,%esp
     9eb:	ff 75 e0             	push   -0x20(%ebp)
     9ee:	e8 98 2d 00 00       	call   378b <close>
    wait();
     9f3:	e8 73 2d 00 00       	call   376b <wait>
  printf(1, "pipe1 ok\n");
     9f8:	83 c4 08             	add    $0x8,%esp
     9fb:	68 1f 3f 00 00       	push   $0x3f1f
     a00:	6a 01                	push   $0x1
     a02:	e8 a4 2e 00 00       	call   38ab <printf>
     a07:	83 c4 10             	add    $0x10,%esp
     a0a:	e9 33 ff ff ff       	jmp    942 <pipe1+0xa1>
      printf(1, "pipe1 oops 3 total %d\n", total);
     a0f:	83 ec 04             	sub    $0x4,%esp
     a12:	57                   	push   %edi
     a13:	68 08 3f 00 00       	push   $0x3f08
     a18:	6a 01                	push   $0x1
     a1a:	e8 8c 2e 00 00       	call   38ab <printf>
      exit();
     a1f:	e8 3f 2d 00 00       	call   3763 <exit>
    printf(1, "fork() failed\n");
     a24:	83 ec 08             	sub    $0x8,%esp
     a27:	68 29 3f 00 00       	push   $0x3f29
     a2c:	6a 01                	push   $0x1
     a2e:	e8 78 2e 00 00       	call   38ab <printf>
    exit();
     a33:	e8 2b 2d 00 00       	call   3763 <exit>

00000a38 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a38:	55                   	push   %ebp
     a39:	89 e5                	mov    %esp,%ebp
     a3b:	57                   	push   %edi
     a3c:	56                   	push   %esi
     a3d:	53                   	push   %ebx
     a3e:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a41:	68 38 3f 00 00       	push   $0x3f38
     a46:	6a 01                	push   $0x1
     a48:	e8 5e 2e 00 00       	call   38ab <printf>
  pid1 = fork();
     a4d:	e8 09 2d 00 00       	call   375b <fork>
  if(pid1 == 0)
     a52:	83 c4 10             	add    $0x10,%esp
     a55:	85 c0                	test   %eax,%eax
     a57:	75 02                	jne    a5b <preempt+0x23>
    for(;;)
     a59:	eb fe                	jmp    a59 <preempt+0x21>
     a5b:	89 c3                	mov    %eax,%ebx
      ;

  pid2 = fork();
     a5d:	e8 f9 2c 00 00       	call   375b <fork>
     a62:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a64:	85 c0                	test   %eax,%eax
     a66:	75 02                	jne    a6a <preempt+0x32>
    for(;;)
     a68:	eb fe                	jmp    a68 <preempt+0x30>
      ;

  pipe(pfds);
     a6a:	83 ec 0c             	sub    $0xc,%esp
     a6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a70:	50                   	push   %eax
     a71:	e8 fd 2c 00 00       	call   3773 <pipe>
  pid3 = fork();
     a76:	e8 e0 2c 00 00       	call   375b <fork>
     a7b:	89 c7                	mov    %eax,%edi
  if(pid3 == 0){
     a7d:	83 c4 10             	add    $0x10,%esp
     a80:	85 c0                	test   %eax,%eax
     a82:	75 49                	jne    acd <preempt+0x95>
    close(pfds[0]);
     a84:	83 ec 0c             	sub    $0xc,%esp
     a87:	ff 75 e0             	push   -0x20(%ebp)
     a8a:	e8 fc 2c 00 00       	call   378b <close>
    if(write(pfds[1], "x", 1) != 1)
     a8f:	83 c4 0c             	add    $0xc,%esp
     a92:	6a 01                	push   $0x1
     a94:	68 fd 44 00 00       	push   $0x44fd
     a99:	ff 75 e4             	push   -0x1c(%ebp)
     a9c:	e8 e2 2c 00 00       	call   3783 <write>
     aa1:	83 c4 10             	add    $0x10,%esp
     aa4:	83 f8 01             	cmp    $0x1,%eax
     aa7:	75 10                	jne    ab9 <preempt+0x81>
      printf(1, "preempt write error");
    close(pfds[1]);
     aa9:	83 ec 0c             	sub    $0xc,%esp
     aac:	ff 75 e4             	push   -0x1c(%ebp)
     aaf:	e8 d7 2c 00 00       	call   378b <close>
     ab4:	83 c4 10             	add    $0x10,%esp
    for(;;)
     ab7:	eb fe                	jmp    ab7 <preempt+0x7f>
      printf(1, "preempt write error");
     ab9:	83 ec 08             	sub    $0x8,%esp
     abc:	68 42 3f 00 00       	push   $0x3f42
     ac1:	6a 01                	push   $0x1
     ac3:	e8 e3 2d 00 00       	call   38ab <printf>
     ac8:	83 c4 10             	add    $0x10,%esp
     acb:	eb dc                	jmp    aa9 <preempt+0x71>
      ;
  }

  close(pfds[1]);
     acd:	83 ec 0c             	sub    $0xc,%esp
     ad0:	ff 75 e4             	push   -0x1c(%ebp)
     ad3:	e8 b3 2c 00 00       	call   378b <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     ad8:	83 c4 0c             	add    $0xc,%esp
     adb:	68 00 20 00 00       	push   $0x2000
     ae0:	68 60 83 00 00       	push   $0x8360
     ae5:	ff 75 e0             	push   -0x20(%ebp)
     ae8:	e8 8e 2c 00 00       	call   377b <read>
     aed:	83 c4 10             	add    $0x10,%esp
     af0:	83 f8 01             	cmp    $0x1,%eax
     af3:	74 1a                	je     b0f <preempt+0xd7>
    printf(1, "preempt read error");
     af5:	83 ec 08             	sub    $0x8,%esp
     af8:	68 56 3f 00 00       	push   $0x3f56
     afd:	6a 01                	push   $0x1
     aff:	e8 a7 2d 00 00       	call   38ab <printf>
     b04:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b0a:	5b                   	pop    %ebx
     b0b:	5e                   	pop    %esi
     b0c:	5f                   	pop    %edi
     b0d:	5d                   	pop    %ebp
     b0e:	c3                   	ret    
  close(pfds[0]);
     b0f:	83 ec 0c             	sub    $0xc,%esp
     b12:	ff 75 e0             	push   -0x20(%ebp)
     b15:	e8 71 2c 00 00       	call   378b <close>
  printf(1, "kill... ");
     b1a:	83 c4 08             	add    $0x8,%esp
     b1d:	68 69 3f 00 00       	push   $0x3f69
     b22:	6a 01                	push   $0x1
     b24:	e8 82 2d 00 00       	call   38ab <printf>
  kill(pid1);
     b29:	89 1c 24             	mov    %ebx,(%esp)
     b2c:	e8 62 2c 00 00       	call   3793 <kill>
  kill(pid2);
     b31:	89 34 24             	mov    %esi,(%esp)
     b34:	e8 5a 2c 00 00       	call   3793 <kill>
  kill(pid3);
     b39:	89 3c 24             	mov    %edi,(%esp)
     b3c:	e8 52 2c 00 00       	call   3793 <kill>
  printf(1, "wait... ");
     b41:	83 c4 08             	add    $0x8,%esp
     b44:	68 72 3f 00 00       	push   $0x3f72
     b49:	6a 01                	push   $0x1
     b4b:	e8 5b 2d 00 00       	call   38ab <printf>
  wait();
     b50:	e8 16 2c 00 00       	call   376b <wait>
  wait();
     b55:	e8 11 2c 00 00       	call   376b <wait>
  wait();
     b5a:	e8 0c 2c 00 00       	call   376b <wait>
  printf(1, "preempt ok\n");
     b5f:	83 c4 08             	add    $0x8,%esp
     b62:	68 7b 3f 00 00       	push   $0x3f7b
     b67:	6a 01                	push   $0x1
     b69:	e8 3d 2d 00 00       	call   38ab <printf>
     b6e:	83 c4 10             	add    $0x10,%esp
     b71:	eb 94                	jmp    b07 <preempt+0xcf>

00000b73 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b73:	55                   	push   %ebp
     b74:	89 e5                	mov    %esp,%ebp
     b76:	56                   	push   %esi
     b77:	53                   	push   %ebx
     b78:	be 64 00 00 00       	mov    $0x64,%esi
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     b7d:	e8 d9 2b 00 00       	call   375b <fork>
     b82:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     b84:	85 c0                	test   %eax,%eax
     b86:	78 24                	js     bac <exitwait+0x39>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     b88:	74 4f                	je     bd9 <exitwait+0x66>
      if(wait() != pid){
     b8a:	e8 dc 2b 00 00       	call   376b <wait>
     b8f:	39 d8                	cmp    %ebx,%eax
     b91:	75 32                	jne    bc5 <exitwait+0x52>
  for(i = 0; i < 100; i++){
     b93:	83 ee 01             	sub    $0x1,%esi
     b96:	75 e5                	jne    b7d <exitwait+0xa>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     b98:	83 ec 08             	sub    $0x8,%esp
     b9b:	68 97 3f 00 00       	push   $0x3f97
     ba0:	6a 01                	push   $0x1
     ba2:	e8 04 2d 00 00       	call   38ab <printf>
     ba7:	83 c4 10             	add    $0x10,%esp
     baa:	eb 12                	jmp    bbe <exitwait+0x4b>
      printf(1, "fork failed\n");
     bac:	83 ec 08             	sub    $0x8,%esp
     baf:	68 e5 4a 00 00       	push   $0x4ae5
     bb4:	6a 01                	push   $0x1
     bb6:	e8 f0 2c 00 00       	call   38ab <printf>
      return;
     bbb:	83 c4 10             	add    $0x10,%esp
}
     bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bc1:	5b                   	pop    %ebx
     bc2:	5e                   	pop    %esi
     bc3:	5d                   	pop    %ebp
     bc4:	c3                   	ret    
        printf(1, "wait wrong pid\n");
     bc5:	83 ec 08             	sub    $0x8,%esp
     bc8:	68 87 3f 00 00       	push   $0x3f87
     bcd:	6a 01                	push   $0x1
     bcf:	e8 d7 2c 00 00       	call   38ab <printf>
        return;
     bd4:	83 c4 10             	add    $0x10,%esp
     bd7:	eb e5                	jmp    bbe <exitwait+0x4b>
      exit();
     bd9:	e8 85 2b 00 00       	call   3763 <exit>

00000bde <mem>:

void
mem(void)
{
     bde:	55                   	push   %ebp
     bdf:	89 e5                	mov    %esp,%ebp
     be1:	56                   	push   %esi
     be2:	53                   	push   %ebx
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     be3:	83 ec 08             	sub    $0x8,%esp
     be6:	68 a4 3f 00 00       	push   $0x3fa4
     beb:	6a 01                	push   $0x1
     bed:	e8 b9 2c 00 00       	call   38ab <printf>
  ppid = getpid();
     bf2:	e8 ec 2b 00 00       	call   37e3 <getpid>
     bf7:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     bf9:	e8 5d 2b 00 00       	call   375b <fork>
     bfe:	83 c4 10             	add    $0x10,%esp
    m1 = 0;
     c01:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((pid = fork()) == 0){
     c06:	85 c0                	test   %eax,%eax
     c08:	74 10                	je     c1a <mem+0x3c>
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
     c0a:	e8 5c 2b 00 00       	call   376b <wait>
  }
}
     c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c12:	5b                   	pop    %ebx
     c13:	5e                   	pop    %esi
     c14:	5d                   	pop    %ebp
     c15:	c3                   	ret    
      *(char**)m2 = m1;
     c16:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     c18:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     c1a:	83 ec 0c             	sub    $0xc,%esp
     c1d:	68 11 27 00 00       	push   $0x2711
     c22:	e8 ab 2e 00 00       	call   3ad2 <malloc>
     c27:	83 c4 10             	add    $0x10,%esp
     c2a:	85 c0                	test   %eax,%eax
     c2c:	75 e8                	jne    c16 <mem+0x38>
    while(m1){
     c2e:	85 db                	test   %ebx,%ebx
     c30:	74 14                	je     c46 <mem+0x68>
      m2 = *(char**)m1;
     c32:	89 d8                	mov    %ebx,%eax
     c34:	8b 1b                	mov    (%ebx),%ebx
      free(m1);
     c36:	83 ec 0c             	sub    $0xc,%esp
     c39:	50                   	push   %eax
     c3a:	e8 2a 2e 00 00       	call   3a69 <free>
    while(m1){
     c3f:	83 c4 10             	add    $0x10,%esp
     c42:	85 db                	test   %ebx,%ebx
     c44:	75 ec                	jne    c32 <mem+0x54>
    m1 = malloc(1024*20);
     c46:	83 ec 0c             	sub    $0xc,%esp
     c49:	68 00 50 00 00       	push   $0x5000
     c4e:	e8 7f 2e 00 00       	call   3ad2 <malloc>
    if(m1 == 0){
     c53:	83 c4 10             	add    $0x10,%esp
     c56:	85 c0                	test   %eax,%eax
     c58:	74 1d                	je     c77 <mem+0x99>
    free(m1);
     c5a:	83 ec 0c             	sub    $0xc,%esp
     c5d:	50                   	push   %eax
     c5e:	e8 06 2e 00 00       	call   3a69 <free>
    printf(1, "mem ok\n");
     c63:	83 c4 08             	add    $0x8,%esp
     c66:	68 c8 3f 00 00       	push   $0x3fc8
     c6b:	6a 01                	push   $0x1
     c6d:	e8 39 2c 00 00       	call   38ab <printf>
    exit();
     c72:	e8 ec 2a 00 00       	call   3763 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     c77:	83 ec 08             	sub    $0x8,%esp
     c7a:	68 ae 3f 00 00       	push   $0x3fae
     c7f:	6a 01                	push   $0x1
     c81:	e8 25 2c 00 00       	call   38ab <printf>
      kill(ppid);
     c86:	89 34 24             	mov    %esi,(%esp)
     c89:	e8 05 2b 00 00       	call   3793 <kill>
      exit();
     c8e:	e8 d0 2a 00 00       	call   3763 <exit>

00000c93 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     c93:	55                   	push   %ebp
     c94:	89 e5                	mov    %esp,%ebp
     c96:	57                   	push   %edi
     c97:	56                   	push   %esi
     c98:	53                   	push   %ebx
     c99:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     c9c:	68 d0 3f 00 00       	push   $0x3fd0
     ca1:	6a 01                	push   $0x1
     ca3:	e8 03 2c 00 00       	call   38ab <printf>

  unlink("sharedfd");
     ca8:	c7 04 24 df 3f 00 00 	movl   $0x3fdf,(%esp)
     caf:	e8 ff 2a 00 00       	call   37b3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     cb4:	83 c4 08             	add    $0x8,%esp
     cb7:	68 02 02 00 00       	push   $0x202
     cbc:	68 df 3f 00 00       	push   $0x3fdf
     cc1:	e8 dd 2a 00 00       	call   37a3 <open>
  if(fd < 0){
     cc6:	83 c4 10             	add    $0x10,%esp
     cc9:	85 c0                	test   %eax,%eax
     ccb:	78 4a                	js     d17 <sharedfd+0x84>
     ccd:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     ccf:	e8 87 2a 00 00       	call   375b <fork>
     cd4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     cd7:	83 f8 01             	cmp    $0x1,%eax
     cda:	19 c0                	sbb    %eax,%eax
     cdc:	83 e0 f3             	and    $0xfffffff3,%eax
     cdf:	83 c0 70             	add    $0x70,%eax
     ce2:	83 ec 04             	sub    $0x4,%esp
     ce5:	6a 0a                	push   $0xa
     ce7:	50                   	push   %eax
     ce8:	8d 45 de             	lea    -0x22(%ebp),%eax
     ceb:	50                   	push   %eax
     cec:	e8 1f 29 00 00       	call   3610 <memset>
     cf1:	83 c4 10             	add    $0x10,%esp
     cf4:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     cf9:	8d 7d de             	lea    -0x22(%ebp),%edi
     cfc:	83 ec 04             	sub    $0x4,%esp
     cff:	6a 0a                	push   $0xa
     d01:	57                   	push   %edi
     d02:	56                   	push   %esi
     d03:	e8 7b 2a 00 00       	call   3783 <write>
     d08:	83 c4 10             	add    $0x10,%esp
     d0b:	83 f8 0a             	cmp    $0xa,%eax
     d0e:	75 1e                	jne    d2e <sharedfd+0x9b>
  for(i = 0; i < 1000; i++){
     d10:	83 eb 01             	sub    $0x1,%ebx
     d13:	75 e7                	jne    cfc <sharedfd+0x69>
     d15:	eb 29                	jmp    d40 <sharedfd+0xad>
    printf(1, "fstests: cannot open sharedfd for writing");
     d17:	83 ec 08             	sub    $0x8,%esp
     d1a:	68 a4 4c 00 00       	push   $0x4ca4
     d1f:	6a 01                	push   $0x1
     d21:	e8 85 2b 00 00       	call   38ab <printf>
    return;
     d26:	83 c4 10             	add    $0x10,%esp
     d29:	e9 dd 00 00 00       	jmp    e0b <sharedfd+0x178>
      printf(1, "fstests: write sharedfd failed\n");
     d2e:	83 ec 08             	sub    $0x8,%esp
     d31:	68 d0 4c 00 00       	push   $0x4cd0
     d36:	6a 01                	push   $0x1
     d38:	e8 6e 2b 00 00       	call   38ab <printf>
      break;
     d3d:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     d40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     d44:	74 51                	je     d97 <sharedfd+0x104>
    exit();
  else
    wait();
     d46:	e8 20 2a 00 00       	call   376b <wait>
  close(fd);
     d4b:	83 ec 0c             	sub    $0xc,%esp
     d4e:	56                   	push   %esi
     d4f:	e8 37 2a 00 00       	call   378b <close>
  fd = open("sharedfd", 0);
     d54:	83 c4 08             	add    $0x8,%esp
     d57:	6a 00                	push   $0x0
     d59:	68 df 3f 00 00       	push   $0x3fdf
     d5e:	e8 40 2a 00 00       	call   37a3 <open>
     d63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     d66:	83 c4 10             	add    $0x10,%esp
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     d69:	bb 00 00 00 00       	mov    $0x0,%ebx
     d6e:	bf 00 00 00 00       	mov    $0x0,%edi
     d73:	8d 75 e8             	lea    -0x18(%ebp),%esi
  if(fd < 0){
     d76:	85 c0                	test   %eax,%eax
     d78:	78 22                	js     d9c <sharedfd+0x109>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     d7a:	83 ec 04             	sub    $0x4,%esp
     d7d:	6a 0a                	push   $0xa
     d7f:	8d 45 de             	lea    -0x22(%ebp),%eax
     d82:	50                   	push   %eax
     d83:	ff 75 d4             	push   -0x2c(%ebp)
     d86:	e8 f0 29 00 00       	call   377b <read>
     d8b:	83 c4 10             	add    $0x10,%esp
     d8e:	85 c0                	test   %eax,%eax
     d90:	7e 3d                	jle    dcf <sharedfd+0x13c>
     d92:	8d 45 de             	lea    -0x22(%ebp),%eax
     d95:	eb 2b                	jmp    dc2 <sharedfd+0x12f>
    exit();
     d97:	e8 c7 29 00 00       	call   3763 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     d9c:	83 ec 08             	sub    $0x8,%esp
     d9f:	68 f0 4c 00 00       	push   $0x4cf0
     da4:	6a 01                	push   $0x1
     da6:	e8 00 2b 00 00       	call   38ab <printf>
    return;
     dab:	83 c4 10             	add    $0x10,%esp
     dae:	eb 5b                	jmp    e0b <sharedfd+0x178>
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
     db0:	80 fa 70             	cmp    $0x70,%dl
     db3:	0f 94 c2             	sete   %dl
     db6:	0f b6 d2             	movzbl %dl,%edx
     db9:	01 d3                	add    %edx,%ebx
    for(i = 0; i < sizeof(buf); i++){
     dbb:	83 c0 01             	add    $0x1,%eax
     dbe:	39 f0                	cmp    %esi,%eax
     dc0:	74 b8                	je     d7a <sharedfd+0xe7>
      if(buf[i] == 'c')
     dc2:	0f b6 10             	movzbl (%eax),%edx
     dc5:	80 fa 63             	cmp    $0x63,%dl
     dc8:	75 e6                	jne    db0 <sharedfd+0x11d>
        nc++;
     dca:	83 c7 01             	add    $0x1,%edi
      if(buf[i] == 'p')
     dcd:	eb ec                	jmp    dbb <sharedfd+0x128>
    }
  }
  close(fd);
     dcf:	83 ec 0c             	sub    $0xc,%esp
     dd2:	ff 75 d4             	push   -0x2c(%ebp)
     dd5:	e8 b1 29 00 00       	call   378b <close>
  unlink("sharedfd");
     dda:	c7 04 24 df 3f 00 00 	movl   $0x3fdf,(%esp)
     de1:	e8 cd 29 00 00       	call   37b3 <unlink>
  if(nc == 10000 && np == 10000){
     de6:	83 c4 10             	add    $0x10,%esp
     de9:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     def:	75 22                	jne    e13 <sharedfd+0x180>
     df1:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     df7:	75 1a                	jne    e13 <sharedfd+0x180>
    printf(1, "sharedfd ok\n");
     df9:	83 ec 08             	sub    $0x8,%esp
     dfc:	68 e8 3f 00 00       	push   $0x3fe8
     e01:	6a 01                	push   $0x1
     e03:	e8 a3 2a 00 00       	call   38ab <printf>
     e08:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e0e:	5b                   	pop    %ebx
     e0f:	5e                   	pop    %esi
     e10:	5f                   	pop    %edi
     e11:	5d                   	pop    %ebp
     e12:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     e13:	53                   	push   %ebx
     e14:	57                   	push   %edi
     e15:	68 f5 3f 00 00       	push   $0x3ff5
     e1a:	6a 01                	push   $0x1
     e1c:	e8 8a 2a 00 00       	call   38ab <printf>
    exit();
     e21:	e8 3d 29 00 00       	call   3763 <exit>

00000e26 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e26:	55                   	push   %ebp
     e27:	89 e5                	mov    %esp,%ebp
     e29:	57                   	push   %edi
     e2a:	56                   	push   %esi
     e2b:	53                   	push   %ebx
     e2c:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e2f:	c7 45 d8 0a 40 00 00 	movl   $0x400a,-0x28(%ebp)
     e36:	c7 45 dc 53 41 00 00 	movl   $0x4153,-0x24(%ebp)
     e3d:	c7 45 e0 57 41 00 00 	movl   $0x4157,-0x20(%ebp)
     e44:	c7 45 e4 0d 40 00 00 	movl   $0x400d,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e4b:	68 10 40 00 00       	push   $0x4010
     e50:	6a 01                	push   $0x1
     e52:	e8 54 2a 00 00       	call   38ab <printf>
     e57:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
     e5a:	bb 00 00 00 00       	mov    $0x0,%ebx
    fname = names[pi];
     e5f:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
     e63:	83 ec 0c             	sub    $0xc,%esp
     e66:	56                   	push   %esi
     e67:	e8 47 29 00 00       	call   37b3 <unlink>

    pid = fork();
     e6c:	e8 ea 28 00 00       	call   375b <fork>
    if(pid < 0){
     e71:	83 c4 10             	add    $0x10,%esp
     e74:	85 c0                	test   %eax,%eax
     e76:	78 28                	js     ea0 <fourfiles+0x7a>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     e78:	74 3a                	je     eb4 <fourfiles+0x8e>
  for(pi = 0; pi < 4; pi++){
     e7a:	83 c3 01             	add    $0x1,%ebx
     e7d:	83 fb 04             	cmp    $0x4,%ebx
     e80:	75 dd                	jne    e5f <fourfiles+0x39>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     e82:	e8 e4 28 00 00       	call   376b <wait>
     e87:	e8 df 28 00 00       	call   376b <wait>
     e8c:	e8 da 28 00 00       	call   376b <wait>
     e91:	e8 d5 28 00 00       	call   376b <wait>
     e96:	bb 30 00 00 00       	mov    $0x30,%ebx
     e9b:	e9 0c 01 00 00       	jmp    fac <fourfiles+0x186>
      printf(1, "fork failed\n");
     ea0:	83 ec 08             	sub    $0x8,%esp
     ea3:	68 e5 4a 00 00       	push   $0x4ae5
     ea8:	6a 01                	push   $0x1
     eaa:	e8 fc 29 00 00       	call   38ab <printf>
      exit();
     eaf:	e8 af 28 00 00       	call   3763 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
     eb4:	83 ec 08             	sub    $0x8,%esp
     eb7:	68 02 02 00 00       	push   $0x202
     ebc:	56                   	push   %esi
     ebd:	e8 e1 28 00 00       	call   37a3 <open>
     ec2:	89 c6                	mov    %eax,%esi
      if(fd < 0){
     ec4:	83 c4 10             	add    $0x10,%esp
     ec7:	85 c0                	test   %eax,%eax
     ec9:	78 45                	js     f10 <fourfiles+0xea>
      memset(buf, '0'+pi, 512);
     ecb:	83 ec 04             	sub    $0x4,%esp
     ece:	68 00 02 00 00       	push   $0x200
     ed3:	83 c3 30             	add    $0x30,%ebx
     ed6:	53                   	push   %ebx
     ed7:	68 60 83 00 00       	push   $0x8360
     edc:	e8 2f 27 00 00       	call   3610 <memset>
     ee1:	83 c4 10             	add    $0x10,%esp
     ee4:	bb 0c 00 00 00       	mov    $0xc,%ebx
        if((n = write(fd, buf, 500)) != 500){
     ee9:	83 ec 04             	sub    $0x4,%esp
     eec:	68 f4 01 00 00       	push   $0x1f4
     ef1:	68 60 83 00 00       	push   $0x8360
     ef6:	56                   	push   %esi
     ef7:	e8 87 28 00 00       	call   3783 <write>
     efc:	83 c4 10             	add    $0x10,%esp
     eff:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     f04:	75 1e                	jne    f24 <fourfiles+0xfe>
      for(i = 0; i < 12; i++){
     f06:	83 eb 01             	sub    $0x1,%ebx
     f09:	75 de                	jne    ee9 <fourfiles+0xc3>
      exit();
     f0b:	e8 53 28 00 00       	call   3763 <exit>
        printf(1, "create failed\n");
     f10:	83 ec 08             	sub    $0x8,%esp
     f13:	68 ab 42 00 00       	push   $0x42ab
     f18:	6a 01                	push   $0x1
     f1a:	e8 8c 29 00 00       	call   38ab <printf>
        exit();
     f1f:	e8 3f 28 00 00       	call   3763 <exit>
          printf(1, "write failed %d\n", n);
     f24:	83 ec 04             	sub    $0x4,%esp
     f27:	50                   	push   %eax
     f28:	68 20 40 00 00       	push   $0x4020
     f2d:	6a 01                	push   $0x1
     f2f:	e8 77 29 00 00       	call   38ab <printf>
          exit();
     f34:	e8 2a 28 00 00       	call   3763 <exit>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
     f39:	83 ec 08             	sub    $0x8,%esp
     f3c:	68 31 40 00 00       	push   $0x4031
     f41:	6a 01                	push   $0x1
     f43:	e8 63 29 00 00       	call   38ab <printf>
          exit();
     f48:	e8 16 28 00 00       	call   3763 <exit>
        }
      }
      total += n;
     f4d:	01 d6                	add    %edx,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f4f:	83 ec 04             	sub    $0x4,%esp
     f52:	68 00 20 00 00       	push   $0x2000
     f57:	68 60 83 00 00       	push   $0x8360
     f5c:	57                   	push   %edi
     f5d:	e8 19 28 00 00       	call   377b <read>
     f62:	83 c4 10             	add    $0x10,%esp
     f65:	85 c0                	test   %eax,%eax
     f67:	7e 19                	jle    f82 <fourfiles+0x15c>
      for(j = 0; j < n; j++){
     f69:	ba 00 00 00 00       	mov    $0x0,%edx
        if(buf[j] != '0'+i){
     f6e:	0f be 8a 60 83 00 00 	movsbl 0x8360(%edx),%ecx
     f75:	39 d9                	cmp    %ebx,%ecx
     f77:	75 c0                	jne    f39 <fourfiles+0x113>
      for(j = 0; j < n; j++){
     f79:	83 c2 01             	add    $0x1,%edx
     f7c:	39 d0                	cmp    %edx,%eax
     f7e:	75 ee                	jne    f6e <fourfiles+0x148>
     f80:	eb cb                	jmp    f4d <fourfiles+0x127>
    }
    close(fd);
     f82:	83 ec 0c             	sub    $0xc,%esp
     f85:	57                   	push   %edi
     f86:	e8 00 28 00 00       	call   378b <close>
    if(total != 12*500){
     f8b:	83 c4 10             	add    $0x10,%esp
     f8e:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
     f94:	75 37                	jne    fcd <fourfiles+0x1a7>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     f96:	83 ec 0c             	sub    $0xc,%esp
     f99:	ff 75 d4             	push   -0x2c(%ebp)
     f9c:	e8 12 28 00 00       	call   37b3 <unlink>
  for(i = 0; i < 2; i++){
     fa1:	83 c3 01             	add    $0x1,%ebx
     fa4:	83 c4 10             	add    $0x10,%esp
     fa7:	83 fb 32             	cmp    $0x32,%ebx
     faa:	74 36                	je     fe2 <fourfiles+0x1bc>
    fname = names[i];
     fac:	8b 84 9d 18 ff ff ff 	mov    -0xe8(%ebp,%ebx,4),%eax
     fb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
     fb6:	83 ec 08             	sub    $0x8,%esp
     fb9:	6a 00                	push   $0x0
     fbb:	50                   	push   %eax
     fbc:	e8 e2 27 00 00       	call   37a3 <open>
     fc1:	89 c7                	mov    %eax,%edi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fc3:	83 c4 10             	add    $0x10,%esp
    total = 0;
     fc6:	be 00 00 00 00       	mov    $0x0,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fcb:	eb 82                	jmp    f4f <fourfiles+0x129>
      printf(1, "wrong length %d\n", total);
     fcd:	83 ec 04             	sub    $0x4,%esp
     fd0:	56                   	push   %esi
     fd1:	68 3d 40 00 00       	push   $0x403d
     fd6:	6a 01                	push   $0x1
     fd8:	e8 ce 28 00 00       	call   38ab <printf>
      exit();
     fdd:	e8 81 27 00 00       	call   3763 <exit>
  }

  printf(1, "fourfiles ok\n");
     fe2:	83 ec 08             	sub    $0x8,%esp
     fe5:	68 4e 40 00 00       	push   $0x404e
     fea:	6a 01                	push   $0x1
     fec:	e8 ba 28 00 00       	call   38ab <printf>
}
     ff1:	83 c4 10             	add    $0x10,%esp
     ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ff7:	5b                   	pop    %ebx
     ff8:	5e                   	pop    %esi
     ff9:	5f                   	pop    %edi
     ffa:	5d                   	pop    %ebp
     ffb:	c3                   	ret    

00000ffc <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
     ffc:	55                   	push   %ebp
     ffd:	89 e5                	mov    %esp,%ebp
     fff:	57                   	push   %edi
    1000:	56                   	push   %esi
    1001:	53                   	push   %ebx
    1002:	83 ec 44             	sub    $0x44,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1005:	68 5c 40 00 00       	push   $0x405c
    100a:	6a 01                	push   $0x1
    100c:	e8 9a 28 00 00       	call   38ab <printf>
    1011:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1014:	be 00 00 00 00       	mov    $0x0,%esi
    pid = fork();
    1019:	e8 3d 27 00 00       	call   375b <fork>
    if(pid < 0){
    101e:	85 c0                	test   %eax,%eax
    1020:	78 38                	js     105a <createdelete+0x5e>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    1022:	74 4a                	je     106e <createdelete+0x72>
  for(pi = 0; pi < 4; pi++){
    1024:	83 c6 01             	add    $0x1,%esi
    1027:	83 fe 04             	cmp    $0x4,%esi
    102a:	75 ed                	jne    1019 <createdelete+0x1d>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    102c:	e8 3a 27 00 00       	call   376b <wait>
    1031:	e8 35 27 00 00       	call   376b <wait>
    1036:	e8 30 27 00 00       	call   376b <wait>
    103b:	e8 2b 27 00 00       	call   376b <wait>
  }

  name[0] = name[1] = name[2] = 0;
    1040:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1044:	bf 30 00 00 00       	mov    $0x30,%edi
    1049:	c7 45 c4 ff ff ff ff 	movl   $0xffffffff,-0x3c(%ebp)
  for(i = 0; i < N; i++){
    1050:	be 00 00 00 00       	mov    $0x0,%esi
    1055:	e9 38 01 00 00       	jmp    1192 <createdelete+0x196>
      printf(1, "fork failed\n");
    105a:	83 ec 08             	sub    $0x8,%esp
    105d:	68 e5 4a 00 00       	push   $0x4ae5
    1062:	6a 01                	push   $0x1
    1064:	e8 42 28 00 00       	call   38ab <printf>
      exit();
    1069:	e8 f5 26 00 00       	call   3763 <exit>
      name[0] = 'p' + pi;
    106e:	89 c3                	mov    %eax,%ebx
    1070:	8d 46 70             	lea    0x70(%esi),%eax
    1073:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1076:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    107a:	8d 75 c8             	lea    -0x38(%ebp),%esi
    107d:	eb 1c                	jmp    109b <createdelete+0x9f>
          printf(1, "create failed\n");
    107f:	83 ec 08             	sub    $0x8,%esp
    1082:	68 ab 42 00 00       	push   $0x42ab
    1087:	6a 01                	push   $0x1
    1089:	e8 1d 28 00 00       	call   38ab <printf>
          exit();
    108e:	e8 d0 26 00 00       	call   3763 <exit>
      for(i = 0; i < N; i++){
    1093:	83 c3 01             	add    $0x1,%ebx
    1096:	83 fb 14             	cmp    $0x14,%ebx
    1099:	74 63                	je     10fe <createdelete+0x102>
        name[1] = '0' + i;
    109b:	8d 43 30             	lea    0x30(%ebx),%eax
    109e:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    10a1:	83 ec 08             	sub    $0x8,%esp
    10a4:	68 02 02 00 00       	push   $0x202
    10a9:	56                   	push   %esi
    10aa:	e8 f4 26 00 00       	call   37a3 <open>
        if(fd < 0){
    10af:	83 c4 10             	add    $0x10,%esp
    10b2:	85 c0                	test   %eax,%eax
    10b4:	78 c9                	js     107f <createdelete+0x83>
        close(fd);
    10b6:	83 ec 0c             	sub    $0xc,%esp
    10b9:	50                   	push   %eax
    10ba:	e8 cc 26 00 00       	call   378b <close>
        if(i > 0 && (i % 2 ) == 0){
    10bf:	83 c4 10             	add    $0x10,%esp
    10c2:	85 db                	test   %ebx,%ebx
    10c4:	7e cd                	jle    1093 <createdelete+0x97>
    10c6:	f6 c3 01             	test   $0x1,%bl
    10c9:	75 c8                	jne    1093 <createdelete+0x97>
          name[1] = '0' + (i / 2);
    10cb:	89 d8                	mov    %ebx,%eax
    10cd:	c1 e8 1f             	shr    $0x1f,%eax
    10d0:	01 d8                	add    %ebx,%eax
    10d2:	d1 f8                	sar    %eax
    10d4:	83 c0 30             	add    $0x30,%eax
    10d7:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    10da:	83 ec 0c             	sub    $0xc,%esp
    10dd:	56                   	push   %esi
    10de:	e8 d0 26 00 00       	call   37b3 <unlink>
    10e3:	83 c4 10             	add    $0x10,%esp
    10e6:	85 c0                	test   %eax,%eax
    10e8:	79 a9                	jns    1093 <createdelete+0x97>
            printf(1, "unlink failed\n");
    10ea:	83 ec 08             	sub    $0x8,%esp
    10ed:	68 5d 3c 00 00       	push   $0x3c5d
    10f2:	6a 01                	push   $0x1
    10f4:	e8 b2 27 00 00       	call   38ab <printf>
            exit();
    10f9:	e8 65 26 00 00       	call   3763 <exit>
      exit();
    10fe:	e8 60 26 00 00       	call   3763 <exit>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
    1103:	83 ec 04             	sub    $0x4,%esp
    1106:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1109:	50                   	push   %eax
    110a:	68 1c 4d 00 00       	push   $0x4d1c
    110f:	6a 01                	push   $0x1
    1111:	e8 95 27 00 00       	call   38ab <printf>
        exit();
    1116:	e8 48 26 00 00       	call   3763 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    111b:	85 c0                	test   %eax,%eax
    111d:	79 56                	jns    1175 <createdelete+0x179>
    for(pi = 0; pi < 4; pi++){
    111f:	83 c3 01             	add    $0x1,%ebx
    1122:	80 fb 74             	cmp    $0x74,%bl
    1125:	74 5c                	je     1183 <createdelete+0x187>
      name[0] = 'p' + pi;
    1127:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    112a:	89 f8                	mov    %edi,%eax
    112c:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    112f:	83 ec 08             	sub    $0x8,%esp
    1132:	6a 00                	push   $0x0
    1134:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1137:	50                   	push   %eax
    1138:	e8 66 26 00 00       	call   37a3 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    113d:	83 c4 10             	add    $0x10,%esp
    1140:	85 f6                	test   %esi,%esi
    1142:	0f 94 c2             	sete   %dl
    1145:	83 fe 09             	cmp    $0x9,%esi
    1148:	0f 9f c1             	setg   %cl
    114b:	08 ca                	or     %cl,%dl
    114d:	74 04                	je     1153 <createdelete+0x157>
    114f:	85 c0                	test   %eax,%eax
    1151:	78 b0                	js     1103 <createdelete+0x107>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1153:	85 c0                	test   %eax,%eax
    1155:	78 c4                	js     111b <createdelete+0x11f>
    1157:	83 7d c4 08          	cmpl   $0x8,-0x3c(%ebp)
    115b:	77 be                	ja     111b <createdelete+0x11f>
        printf(1, "oops createdelete %s did exist\n", name);
    115d:	83 ec 04             	sub    $0x4,%esp
    1160:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1163:	50                   	push   %eax
    1164:	68 40 4d 00 00       	push   $0x4d40
    1169:	6a 01                	push   $0x1
    116b:	e8 3b 27 00 00       	call   38ab <printf>
        exit();
    1170:	e8 ee 25 00 00       	call   3763 <exit>
        close(fd);
    1175:	83 ec 0c             	sub    $0xc,%esp
    1178:	50                   	push   %eax
    1179:	e8 0d 26 00 00       	call   378b <close>
    117e:	83 c4 10             	add    $0x10,%esp
    1181:	eb 9c                	jmp    111f <createdelete+0x123>
  for(i = 0; i < N; i++){
    1183:	83 c6 01             	add    $0x1,%esi
    1186:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
    118a:	83 c7 01             	add    $0x1,%edi
    118d:	83 fe 14             	cmp    $0x14,%esi
    1190:	74 38                	je     11ca <createdelete+0x1ce>
  for(pi = 0; pi < 4; pi++){
    1192:	bb 70 00 00 00       	mov    $0x70,%ebx
    1197:	eb 8e                	jmp    1127 <createdelete+0x12b>
    }
  }

  for(i = 0; i < N; i++){
    1199:	83 c6 01             	add    $0x1,%esi
    119c:	83 c7 01             	add    $0x1,%edi
    119f:	89 f0                	mov    %esi,%eax
    11a1:	3c 84                	cmp    $0x84,%al
    11a3:	74 31                	je     11d6 <createdelete+0x1da>
  for(i = 0; i < N; i++){
    11a5:	bb 04 00 00 00       	mov    $0x4,%ebx
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11aa:	89 f0                	mov    %esi,%eax
    11ac:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    11af:	89 f8                	mov    %edi,%eax
    11b1:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    11b4:	83 ec 0c             	sub    $0xc,%esp
    11b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
    11ba:	50                   	push   %eax
    11bb:	e8 f3 25 00 00       	call   37b3 <unlink>
    for(pi = 0; pi < 4; pi++){
    11c0:	83 c4 10             	add    $0x10,%esp
    11c3:	83 eb 01             	sub    $0x1,%ebx
    11c6:	75 e2                	jne    11aa <createdelete+0x1ae>
    11c8:	eb cf                	jmp    1199 <createdelete+0x19d>
    11ca:	bf 30 00 00 00       	mov    $0x30,%edi
    11cf:	be 70 00 00 00       	mov    $0x70,%esi
    11d4:	eb cf                	jmp    11a5 <createdelete+0x1a9>
    }
  }

  printf(1, "createdelete ok\n");
    11d6:	83 ec 08             	sub    $0x8,%esp
    11d9:	68 6f 40 00 00       	push   $0x406f
    11de:	6a 01                	push   $0x1
    11e0:	e8 c6 26 00 00       	call   38ab <printf>
}
    11e5:	83 c4 10             	add    $0x10,%esp
    11e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11eb:	5b                   	pop    %ebx
    11ec:	5e                   	pop    %esi
    11ed:	5f                   	pop    %edi
    11ee:	5d                   	pop    %ebp
    11ef:	c3                   	ret    

000011f0 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	56                   	push   %esi
    11f4:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    11f5:	83 ec 08             	sub    $0x8,%esp
    11f8:	68 80 40 00 00       	push   $0x4080
    11fd:	6a 01                	push   $0x1
    11ff:	e8 a7 26 00 00       	call   38ab <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1204:	83 c4 08             	add    $0x8,%esp
    1207:	68 02 02 00 00       	push   $0x202
    120c:	68 91 40 00 00       	push   $0x4091
    1211:	e8 8d 25 00 00       	call   37a3 <open>
  if(fd < 0){
    1216:	83 c4 10             	add    $0x10,%esp
    1219:	85 c0                	test   %eax,%eax
    121b:	0f 88 f0 00 00 00    	js     1311 <unlinkread+0x121>
    1221:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1223:	83 ec 04             	sub    $0x4,%esp
    1226:	6a 05                	push   $0x5
    1228:	68 b6 40 00 00       	push   $0x40b6
    122d:	50                   	push   %eax
    122e:	e8 50 25 00 00       	call   3783 <write>
  close(fd);
    1233:	89 1c 24             	mov    %ebx,(%esp)
    1236:	e8 50 25 00 00       	call   378b <close>

  fd = open("unlinkread", O_RDWR);
    123b:	83 c4 08             	add    $0x8,%esp
    123e:	6a 02                	push   $0x2
    1240:	68 91 40 00 00       	push   $0x4091
    1245:	e8 59 25 00 00       	call   37a3 <open>
    124a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    124c:	83 c4 10             	add    $0x10,%esp
    124f:	85 c0                	test   %eax,%eax
    1251:	0f 88 ce 00 00 00    	js     1325 <unlinkread+0x135>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1257:	83 ec 0c             	sub    $0xc,%esp
    125a:	68 91 40 00 00       	push   $0x4091
    125f:	e8 4f 25 00 00       	call   37b3 <unlink>
    1264:	83 c4 10             	add    $0x10,%esp
    1267:	85 c0                	test   %eax,%eax
    1269:	0f 85 ca 00 00 00    	jne    1339 <unlinkread+0x149>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    126f:	83 ec 08             	sub    $0x8,%esp
    1272:	68 02 02 00 00       	push   $0x202
    1277:	68 91 40 00 00       	push   $0x4091
    127c:	e8 22 25 00 00       	call   37a3 <open>
    1281:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    1283:	83 c4 0c             	add    $0xc,%esp
    1286:	6a 03                	push   $0x3
    1288:	68 ee 40 00 00       	push   $0x40ee
    128d:	50                   	push   %eax
    128e:	e8 f0 24 00 00       	call   3783 <write>
  close(fd1);
    1293:	89 34 24             	mov    %esi,(%esp)
    1296:	e8 f0 24 00 00       	call   378b <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    129b:	83 c4 0c             	add    $0xc,%esp
    129e:	68 00 20 00 00       	push   $0x2000
    12a3:	68 60 83 00 00       	push   $0x8360
    12a8:	53                   	push   %ebx
    12a9:	e8 cd 24 00 00       	call   377b <read>
    12ae:	83 c4 10             	add    $0x10,%esp
    12b1:	83 f8 05             	cmp    $0x5,%eax
    12b4:	0f 85 93 00 00 00    	jne    134d <unlinkread+0x15d>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    12ba:	80 3d 60 83 00 00 68 	cmpb   $0x68,0x8360
    12c1:	0f 85 9a 00 00 00    	jne    1361 <unlinkread+0x171>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    12c7:	83 ec 04             	sub    $0x4,%esp
    12ca:	6a 0a                	push   $0xa
    12cc:	68 60 83 00 00       	push   $0x8360
    12d1:	53                   	push   %ebx
    12d2:	e8 ac 24 00 00       	call   3783 <write>
    12d7:	83 c4 10             	add    $0x10,%esp
    12da:	83 f8 0a             	cmp    $0xa,%eax
    12dd:	0f 85 92 00 00 00    	jne    1375 <unlinkread+0x185>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    12e3:	83 ec 0c             	sub    $0xc,%esp
    12e6:	53                   	push   %ebx
    12e7:	e8 9f 24 00 00       	call   378b <close>
  unlink("unlinkread");
    12ec:	c7 04 24 91 40 00 00 	movl   $0x4091,(%esp)
    12f3:	e8 bb 24 00 00       	call   37b3 <unlink>
  printf(1, "unlinkread ok\n");
    12f8:	83 c4 08             	add    $0x8,%esp
    12fb:	68 39 41 00 00       	push   $0x4139
    1300:	6a 01                	push   $0x1
    1302:	e8 a4 25 00 00       	call   38ab <printf>
}
    1307:	83 c4 10             	add    $0x10,%esp
    130a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    130d:	5b                   	pop    %ebx
    130e:	5e                   	pop    %esi
    130f:	5d                   	pop    %ebp
    1310:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1311:	83 ec 08             	sub    $0x8,%esp
    1314:	68 9c 40 00 00       	push   $0x409c
    1319:	6a 01                	push   $0x1
    131b:	e8 8b 25 00 00       	call   38ab <printf>
    exit();
    1320:	e8 3e 24 00 00       	call   3763 <exit>
    printf(1, "open unlinkread failed\n");
    1325:	83 ec 08             	sub    $0x8,%esp
    1328:	68 bc 40 00 00       	push   $0x40bc
    132d:	6a 01                	push   $0x1
    132f:	e8 77 25 00 00       	call   38ab <printf>
    exit();
    1334:	e8 2a 24 00 00       	call   3763 <exit>
    printf(1, "unlink unlinkread failed\n");
    1339:	83 ec 08             	sub    $0x8,%esp
    133c:	68 d4 40 00 00       	push   $0x40d4
    1341:	6a 01                	push   $0x1
    1343:	e8 63 25 00 00       	call   38ab <printf>
    exit();
    1348:	e8 16 24 00 00       	call   3763 <exit>
    printf(1, "unlinkread read failed");
    134d:	83 ec 08             	sub    $0x8,%esp
    1350:	68 f2 40 00 00       	push   $0x40f2
    1355:	6a 01                	push   $0x1
    1357:	e8 4f 25 00 00       	call   38ab <printf>
    exit();
    135c:	e8 02 24 00 00       	call   3763 <exit>
    printf(1, "unlinkread wrong data\n");
    1361:	83 ec 08             	sub    $0x8,%esp
    1364:	68 09 41 00 00       	push   $0x4109
    1369:	6a 01                	push   $0x1
    136b:	e8 3b 25 00 00       	call   38ab <printf>
    exit();
    1370:	e8 ee 23 00 00       	call   3763 <exit>
    printf(1, "unlinkread write failed\n");
    1375:	83 ec 08             	sub    $0x8,%esp
    1378:	68 20 41 00 00       	push   $0x4120
    137d:	6a 01                	push   $0x1
    137f:	e8 27 25 00 00       	call   38ab <printf>
    exit();
    1384:	e8 da 23 00 00       	call   3763 <exit>

00001389 <linktest>:

void
linktest(void)
{
    1389:	55                   	push   %ebp
    138a:	89 e5                	mov    %esp,%ebp
    138c:	53                   	push   %ebx
    138d:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    1390:	68 48 41 00 00       	push   $0x4148
    1395:	6a 01                	push   $0x1
    1397:	e8 0f 25 00 00       	call   38ab <printf>

  unlink("lf1");
    139c:	c7 04 24 52 41 00 00 	movl   $0x4152,(%esp)
    13a3:	e8 0b 24 00 00       	call   37b3 <unlink>
  unlink("lf2");
    13a8:	c7 04 24 56 41 00 00 	movl   $0x4156,(%esp)
    13af:	e8 ff 23 00 00       	call   37b3 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    13b4:	83 c4 08             	add    $0x8,%esp
    13b7:	68 02 02 00 00       	push   $0x202
    13bc:	68 52 41 00 00       	push   $0x4152
    13c1:	e8 dd 23 00 00       	call   37a3 <open>
  if(fd < 0){
    13c6:	83 c4 10             	add    $0x10,%esp
    13c9:	85 c0                	test   %eax,%eax
    13cb:	0f 88 2a 01 00 00    	js     14fb <linktest+0x172>
    13d1:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    13d3:	83 ec 04             	sub    $0x4,%esp
    13d6:	6a 05                	push   $0x5
    13d8:	68 b6 40 00 00       	push   $0x40b6
    13dd:	50                   	push   %eax
    13de:	e8 a0 23 00 00       	call   3783 <write>
    13e3:	83 c4 10             	add    $0x10,%esp
    13e6:	83 f8 05             	cmp    $0x5,%eax
    13e9:	0f 85 20 01 00 00    	jne    150f <linktest+0x186>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    13ef:	83 ec 0c             	sub    $0xc,%esp
    13f2:	53                   	push   %ebx
    13f3:	e8 93 23 00 00       	call   378b <close>

  if(link("lf1", "lf2") < 0){
    13f8:	83 c4 08             	add    $0x8,%esp
    13fb:	68 56 41 00 00       	push   $0x4156
    1400:	68 52 41 00 00       	push   $0x4152
    1405:	e8 b9 23 00 00       	call   37c3 <link>
    140a:	83 c4 10             	add    $0x10,%esp
    140d:	85 c0                	test   %eax,%eax
    140f:	0f 88 0e 01 00 00    	js     1523 <linktest+0x19a>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1415:	83 ec 0c             	sub    $0xc,%esp
    1418:	68 52 41 00 00       	push   $0x4152
    141d:	e8 91 23 00 00       	call   37b3 <unlink>

  if(open("lf1", 0) >= 0){
    1422:	83 c4 08             	add    $0x8,%esp
    1425:	6a 00                	push   $0x0
    1427:	68 52 41 00 00       	push   $0x4152
    142c:	e8 72 23 00 00       	call   37a3 <open>
    1431:	83 c4 10             	add    $0x10,%esp
    1434:	85 c0                	test   %eax,%eax
    1436:	0f 89 fb 00 00 00    	jns    1537 <linktest+0x1ae>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    143c:	83 ec 08             	sub    $0x8,%esp
    143f:	6a 00                	push   $0x0
    1441:	68 56 41 00 00       	push   $0x4156
    1446:	e8 58 23 00 00       	call   37a3 <open>
    144b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    144d:	83 c4 10             	add    $0x10,%esp
    1450:	85 c0                	test   %eax,%eax
    1452:	0f 88 f3 00 00 00    	js     154b <linktest+0x1c2>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1458:	83 ec 04             	sub    $0x4,%esp
    145b:	68 00 20 00 00       	push   $0x2000
    1460:	68 60 83 00 00       	push   $0x8360
    1465:	50                   	push   %eax
    1466:	e8 10 23 00 00       	call   377b <read>
    146b:	83 c4 10             	add    $0x10,%esp
    146e:	83 f8 05             	cmp    $0x5,%eax
    1471:	0f 85 e8 00 00 00    	jne    155f <linktest+0x1d6>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    1477:	83 ec 0c             	sub    $0xc,%esp
    147a:	53                   	push   %ebx
    147b:	e8 0b 23 00 00       	call   378b <close>

  if(link("lf2", "lf2") >= 0){
    1480:	83 c4 08             	add    $0x8,%esp
    1483:	68 56 41 00 00       	push   $0x4156
    1488:	68 56 41 00 00       	push   $0x4156
    148d:	e8 31 23 00 00       	call   37c3 <link>
    1492:	83 c4 10             	add    $0x10,%esp
    1495:	85 c0                	test   %eax,%eax
    1497:	0f 89 d6 00 00 00    	jns    1573 <linktest+0x1ea>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    149d:	83 ec 0c             	sub    $0xc,%esp
    14a0:	68 56 41 00 00       	push   $0x4156
    14a5:	e8 09 23 00 00       	call   37b3 <unlink>
  if(link("lf2", "lf1") >= 0){
    14aa:	83 c4 08             	add    $0x8,%esp
    14ad:	68 52 41 00 00       	push   $0x4152
    14b2:	68 56 41 00 00       	push   $0x4156
    14b7:	e8 07 23 00 00       	call   37c3 <link>
    14bc:	83 c4 10             	add    $0x10,%esp
    14bf:	85 c0                	test   %eax,%eax
    14c1:	0f 89 c0 00 00 00    	jns    1587 <linktest+0x1fe>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    14c7:	83 ec 08             	sub    $0x8,%esp
    14ca:	68 52 41 00 00       	push   $0x4152
    14cf:	68 1a 44 00 00       	push   $0x441a
    14d4:	e8 ea 22 00 00       	call   37c3 <link>
    14d9:	83 c4 10             	add    $0x10,%esp
    14dc:	85 c0                	test   %eax,%eax
    14de:	0f 89 b7 00 00 00    	jns    159b <linktest+0x212>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    14e4:	83 ec 08             	sub    $0x8,%esp
    14e7:	68 f0 41 00 00       	push   $0x41f0
    14ec:	6a 01                	push   $0x1
    14ee:	e8 b8 23 00 00       	call   38ab <printf>
}
    14f3:	83 c4 10             	add    $0x10,%esp
    14f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    14f9:	c9                   	leave  
    14fa:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    14fb:	83 ec 08             	sub    $0x8,%esp
    14fe:	68 5a 41 00 00       	push   $0x415a
    1503:	6a 01                	push   $0x1
    1505:	e8 a1 23 00 00       	call   38ab <printf>
    exit();
    150a:	e8 54 22 00 00       	call   3763 <exit>
    printf(1, "write lf1 failed\n");
    150f:	83 ec 08             	sub    $0x8,%esp
    1512:	68 6d 41 00 00       	push   $0x416d
    1517:	6a 01                	push   $0x1
    1519:	e8 8d 23 00 00       	call   38ab <printf>
    exit();
    151e:	e8 40 22 00 00       	call   3763 <exit>
    printf(1, "link lf1 lf2 failed\n");
    1523:	83 ec 08             	sub    $0x8,%esp
    1526:	68 7f 41 00 00       	push   $0x417f
    152b:	6a 01                	push   $0x1
    152d:	e8 79 23 00 00       	call   38ab <printf>
    exit();
    1532:	e8 2c 22 00 00       	call   3763 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1537:	83 ec 08             	sub    $0x8,%esp
    153a:	68 60 4d 00 00       	push   $0x4d60
    153f:	6a 01                	push   $0x1
    1541:	e8 65 23 00 00       	call   38ab <printf>
    exit();
    1546:	e8 18 22 00 00       	call   3763 <exit>
    printf(1, "open lf2 failed\n");
    154b:	83 ec 08             	sub    $0x8,%esp
    154e:	68 94 41 00 00       	push   $0x4194
    1553:	6a 01                	push   $0x1
    1555:	e8 51 23 00 00       	call   38ab <printf>
    exit();
    155a:	e8 04 22 00 00       	call   3763 <exit>
    printf(1, "read lf2 failed\n");
    155f:	83 ec 08             	sub    $0x8,%esp
    1562:	68 a5 41 00 00       	push   $0x41a5
    1567:	6a 01                	push   $0x1
    1569:	e8 3d 23 00 00       	call   38ab <printf>
    exit();
    156e:	e8 f0 21 00 00       	call   3763 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1573:	83 ec 08             	sub    $0x8,%esp
    1576:	68 b6 41 00 00       	push   $0x41b6
    157b:	6a 01                	push   $0x1
    157d:	e8 29 23 00 00       	call   38ab <printf>
    exit();
    1582:	e8 dc 21 00 00       	call   3763 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    1587:	83 ec 08             	sub    $0x8,%esp
    158a:	68 88 4d 00 00       	push   $0x4d88
    158f:	6a 01                	push   $0x1
    1591:	e8 15 23 00 00       	call   38ab <printf>
    exit();
    1596:	e8 c8 21 00 00       	call   3763 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    159b:	83 ec 08             	sub    $0x8,%esp
    159e:	68 d4 41 00 00       	push   $0x41d4
    15a3:	6a 01                	push   $0x1
    15a5:	e8 01 23 00 00       	call   38ab <printf>
    exit();
    15aa:	e8 b4 21 00 00       	call   3763 <exit>

000015af <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    15af:	55                   	push   %ebp
    15b0:	89 e5                	mov    %esp,%ebp
    15b2:	57                   	push   %edi
    15b3:	56                   	push   %esi
    15b4:	53                   	push   %ebx
    15b5:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    15b8:	68 fd 41 00 00       	push   $0x41fd
    15bd:	6a 01                	push   $0x1
    15bf:	e8 e7 22 00 00       	call   38ab <printf>
  file[0] = 'C';
    15c4:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    15c8:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    15cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    15cf:	bb 00 00 00 00       	mov    $0x0,%ebx
    file[1] = '0' + i;
    unlink(file);
    15d4:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    pid = fork();
    if(pid && (i % 3) == 1){
    15d7:	bf 56 55 55 55       	mov    $0x55555556,%edi
    15dc:	e9 75 02 00 00       	jmp    1856 <concreate+0x2a7>
      link("C0", file);
    15e1:	83 ec 08             	sub    $0x8,%esp
    15e4:	56                   	push   %esi
    15e5:	68 0d 42 00 00       	push   $0x420d
    15ea:	e8 d4 21 00 00       	call   37c3 <link>
    15ef:	83 c4 10             	add    $0x10,%esp
    15f2:	e9 4e 02 00 00       	jmp    1845 <concreate+0x296>
    } else if(pid == 0 && (i % 5) == 1){
    15f7:	ba 67 66 66 66       	mov    $0x66666667,%edx
    15fc:	89 d8                	mov    %ebx,%eax
    15fe:	f7 ea                	imul   %edx
    1600:	d1 fa                	sar    %edx
    1602:	89 d8                	mov    %ebx,%eax
    1604:	c1 f8 1f             	sar    $0x1f,%eax
    1607:	29 c2                	sub    %eax,%edx
    1609:	8d 04 92             	lea    (%edx,%edx,4),%eax
    160c:	29 c3                	sub    %eax,%ebx
    160e:	83 fb 01             	cmp    $0x1,%ebx
    1611:	74 34                	je     1647 <concreate+0x98>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1613:	83 ec 08             	sub    $0x8,%esp
    1616:	68 02 02 00 00       	push   $0x202
    161b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    161e:	50                   	push   %eax
    161f:	e8 7f 21 00 00       	call   37a3 <open>
      if(fd < 0){
    1624:	83 c4 10             	add    $0x10,%esp
    1627:	85 c0                	test   %eax,%eax
    1629:	0f 89 f9 01 00 00    	jns    1828 <concreate+0x279>
        printf(1, "concreate create %s failed\n", file);
    162f:	83 ec 04             	sub    $0x4,%esp
    1632:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1635:	50                   	push   %eax
    1636:	68 10 42 00 00       	push   $0x4210
    163b:	6a 01                	push   $0x1
    163d:	e8 69 22 00 00       	call   38ab <printf>
        exit();
    1642:	e8 1c 21 00 00       	call   3763 <exit>
      link("C0", file);
    1647:	83 ec 08             	sub    $0x8,%esp
    164a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    164d:	50                   	push   %eax
    164e:	68 0d 42 00 00       	push   $0x420d
    1653:	e8 6b 21 00 00       	call   37c3 <link>
    1658:	83 c4 10             	add    $0x10,%esp
      }
      close(fd);
    }
    if(pid == 0)
      exit();
    165b:	e8 03 21 00 00       	call   3763 <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1660:	83 ec 04             	sub    $0x4,%esp
    1663:	6a 28                	push   $0x28
    1665:	6a 00                	push   $0x0
    1667:	8d 45 bd             	lea    -0x43(%ebp),%eax
    166a:	50                   	push   %eax
    166b:	e8 a0 1f 00 00       	call   3610 <memset>
  fd = open(".", 0);
    1670:	83 c4 08             	add    $0x8,%esp
    1673:	6a 00                	push   $0x0
    1675:	68 1a 44 00 00       	push   $0x441a
    167a:	e8 24 21 00 00       	call   37a3 <open>
    167f:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1681:	83 c4 10             	add    $0x10,%esp
  n = 0;
    1684:	bf 00 00 00 00       	mov    $0x0,%edi
  while(read(fd, &de, sizeof(de)) > 0){
    1689:	8d 75 ac             	lea    -0x54(%ebp),%esi
    168c:	83 ec 04             	sub    $0x4,%esp
    168f:	6a 10                	push   $0x10
    1691:	56                   	push   %esi
    1692:	53                   	push   %ebx
    1693:	e8 e3 20 00 00       	call   377b <read>
    1698:	83 c4 10             	add    $0x10,%esp
    169b:	85 c0                	test   %eax,%eax
    169d:	7e 60                	jle    16ff <concreate+0x150>
    if(de.inum == 0)
    169f:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    16a4:	74 e6                	je     168c <concreate+0xdd>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    16a6:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    16aa:	75 e0                	jne    168c <concreate+0xdd>
    16ac:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    16b0:	75 da                	jne    168c <concreate+0xdd>
      i = de.name[1] - '0';
    16b2:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    16b6:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    16b9:	83 f8 27             	cmp    $0x27,%eax
    16bc:	77 11                	ja     16cf <concreate+0x120>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    16be:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    16c3:	75 22                	jne    16e7 <concreate+0x138>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    16c5:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    16ca:	83 c7 01             	add    $0x1,%edi
    16cd:	eb bd                	jmp    168c <concreate+0xdd>
        printf(1, "concreate weird file %s\n", de.name);
    16cf:	83 ec 04             	sub    $0x4,%esp
    16d2:	8d 45 ae             	lea    -0x52(%ebp),%eax
    16d5:	50                   	push   %eax
    16d6:	68 2c 42 00 00       	push   $0x422c
    16db:	6a 01                	push   $0x1
    16dd:	e8 c9 21 00 00       	call   38ab <printf>
        exit();
    16e2:	e8 7c 20 00 00       	call   3763 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    16e7:	83 ec 04             	sub    $0x4,%esp
    16ea:	8d 45 ae             	lea    -0x52(%ebp),%eax
    16ed:	50                   	push   %eax
    16ee:	68 45 42 00 00       	push   $0x4245
    16f3:	6a 01                	push   $0x1
    16f5:	e8 b1 21 00 00       	call   38ab <printf>
        exit();
    16fa:	e8 64 20 00 00       	call   3763 <exit>
    }
  }
  close(fd);
    16ff:	83 ec 0c             	sub    $0xc,%esp
    1702:	53                   	push   %ebx
    1703:	e8 83 20 00 00       	call   378b <close>

  if(n != 40){
    1708:	83 c4 10             	add    $0x10,%esp
    170b:	83 ff 28             	cmp    $0x28,%edi
    170e:	75 0d                	jne    171d <concreate+0x16e>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1710:	bb 00 00 00 00       	mov    $0x0,%ebx
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1715:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1718:	e9 88 00 00 00       	jmp    17a5 <concreate+0x1f6>
    printf(1, "concreate not enough files in directory listing\n");
    171d:	83 ec 08             	sub    $0x8,%esp
    1720:	68 ac 4d 00 00       	push   $0x4dac
    1725:	6a 01                	push   $0x1
    1727:	e8 7f 21 00 00       	call   38ab <printf>
    exit();
    172c:	e8 32 20 00 00       	call   3763 <exit>
      printf(1, "fork failed\n");
    1731:	83 ec 08             	sub    $0x8,%esp
    1734:	68 e5 4a 00 00       	push   $0x4ae5
    1739:	6a 01                	push   $0x1
    173b:	e8 6b 21 00 00       	call   38ab <printf>
      exit();
    1740:	e8 1e 20 00 00       	call   3763 <exit>
      close(open(file, 0));
    1745:	83 ec 08             	sub    $0x8,%esp
    1748:	6a 00                	push   $0x0
    174a:	57                   	push   %edi
    174b:	e8 53 20 00 00       	call   37a3 <open>
    1750:	89 04 24             	mov    %eax,(%esp)
    1753:	e8 33 20 00 00       	call   378b <close>
      close(open(file, 0));
    1758:	83 c4 08             	add    $0x8,%esp
    175b:	6a 00                	push   $0x0
    175d:	57                   	push   %edi
    175e:	e8 40 20 00 00       	call   37a3 <open>
    1763:	89 04 24             	mov    %eax,(%esp)
    1766:	e8 20 20 00 00       	call   378b <close>
      close(open(file, 0));
    176b:	83 c4 08             	add    $0x8,%esp
    176e:	6a 00                	push   $0x0
    1770:	57                   	push   %edi
    1771:	e8 2d 20 00 00       	call   37a3 <open>
    1776:	89 04 24             	mov    %eax,(%esp)
    1779:	e8 0d 20 00 00       	call   378b <close>
      close(open(file, 0));
    177e:	83 c4 08             	add    $0x8,%esp
    1781:	6a 00                	push   $0x0
    1783:	57                   	push   %edi
    1784:	e8 1a 20 00 00       	call   37a3 <open>
    1789:	89 04 24             	mov    %eax,(%esp)
    178c:	e8 fa 1f 00 00       	call   378b <close>
    1791:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1794:	85 f6                	test   %esi,%esi
    1796:	74 74                	je     180c <concreate+0x25d>
      exit();
    else
      wait();
    1798:	e8 ce 1f 00 00       	call   376b <wait>
  for(i = 0; i < 40; i++){
    179d:	83 c3 01             	add    $0x1,%ebx
    17a0:	83 fb 28             	cmp    $0x28,%ebx
    17a3:	74 6c                	je     1811 <concreate+0x262>
    file[1] = '0' + i;
    17a5:	8d 43 30             	lea    0x30(%ebx),%eax
    17a8:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    17ab:	e8 ab 1f 00 00       	call   375b <fork>
    17b0:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    17b2:	85 c0                	test   %eax,%eax
    17b4:	0f 88 77 ff ff ff    	js     1731 <concreate+0x182>
    if(((i % 3) == 0 && pid == 0) ||
    17ba:	b8 56 55 55 55       	mov    $0x55555556,%eax
    17bf:	f7 eb                	imul   %ebx
    17c1:	89 d8                	mov    %ebx,%eax
    17c3:	c1 f8 1f             	sar    $0x1f,%eax
    17c6:	29 c2                	sub    %eax,%edx
    17c8:	8d 04 52             	lea    (%edx,%edx,2),%eax
    17cb:	89 da                	mov    %ebx,%edx
    17cd:	29 c2                	sub    %eax,%edx
    17cf:	89 d0                	mov    %edx,%eax
    17d1:	09 f0                	or     %esi,%eax
    17d3:	0f 84 6c ff ff ff    	je     1745 <concreate+0x196>
       ((i % 3) == 1 && pid != 0)){
    17d9:	85 f6                	test   %esi,%esi
    17db:	74 09                	je     17e6 <concreate+0x237>
    17dd:	83 fa 01             	cmp    $0x1,%edx
    17e0:	0f 84 5f ff ff ff    	je     1745 <concreate+0x196>
      unlink(file);
    17e6:	83 ec 0c             	sub    $0xc,%esp
    17e9:	57                   	push   %edi
    17ea:	e8 c4 1f 00 00       	call   37b3 <unlink>
      unlink(file);
    17ef:	89 3c 24             	mov    %edi,(%esp)
    17f2:	e8 bc 1f 00 00       	call   37b3 <unlink>
      unlink(file);
    17f7:	89 3c 24             	mov    %edi,(%esp)
    17fa:	e8 b4 1f 00 00       	call   37b3 <unlink>
      unlink(file);
    17ff:	89 3c 24             	mov    %edi,(%esp)
    1802:	e8 ac 1f 00 00       	call   37b3 <unlink>
    1807:	83 c4 10             	add    $0x10,%esp
    180a:	eb 88                	jmp    1794 <concreate+0x1e5>
      exit();
    180c:	e8 52 1f 00 00       	call   3763 <exit>
  }

  printf(1, "concreate ok\n");
    1811:	83 ec 08             	sub    $0x8,%esp
    1814:	68 62 42 00 00       	push   $0x4262
    1819:	6a 01                	push   $0x1
    181b:	e8 8b 20 00 00       	call   38ab <printf>
}
    1820:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1823:	5b                   	pop    %ebx
    1824:	5e                   	pop    %esi
    1825:	5f                   	pop    %edi
    1826:	5d                   	pop    %ebp
    1827:	c3                   	ret    
      close(fd);
    1828:	83 ec 0c             	sub    $0xc,%esp
    182b:	50                   	push   %eax
    182c:	e8 5a 1f 00 00       	call   378b <close>
    1831:	83 c4 10             	add    $0x10,%esp
    1834:	e9 22 fe ff ff       	jmp    165b <concreate+0xac>
    1839:	83 ec 0c             	sub    $0xc,%esp
    183c:	50                   	push   %eax
    183d:	e8 49 1f 00 00       	call   378b <close>
    1842:	83 c4 10             	add    $0x10,%esp
      wait();
    1845:	e8 21 1f 00 00       	call   376b <wait>
  for(i = 0; i < 40; i++){
    184a:	83 c3 01             	add    $0x1,%ebx
    184d:	83 fb 28             	cmp    $0x28,%ebx
    1850:	0f 84 0a fe ff ff    	je     1660 <concreate+0xb1>
    file[1] = '0' + i;
    1856:	8d 43 30             	lea    0x30(%ebx),%eax
    1859:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    185c:	83 ec 0c             	sub    $0xc,%esp
    185f:	56                   	push   %esi
    1860:	e8 4e 1f 00 00       	call   37b3 <unlink>
    pid = fork();
    1865:	e8 f1 1e 00 00       	call   375b <fork>
    if(pid && (i % 3) == 1){
    186a:	83 c4 10             	add    $0x10,%esp
    186d:	85 c0                	test   %eax,%eax
    186f:	0f 84 82 fd ff ff    	je     15f7 <concreate+0x48>
    1875:	89 d8                	mov    %ebx,%eax
    1877:	f7 ef                	imul   %edi
    1879:	89 d8                	mov    %ebx,%eax
    187b:	c1 f8 1f             	sar    $0x1f,%eax
    187e:	29 c2                	sub    %eax,%edx
    1880:	8d 14 52             	lea    (%edx,%edx,2),%edx
    1883:	89 d8                	mov    %ebx,%eax
    1885:	29 d0                	sub    %edx,%eax
    1887:	83 f8 01             	cmp    $0x1,%eax
    188a:	0f 84 51 fd ff ff    	je     15e1 <concreate+0x32>
      fd = open(file, O_CREATE | O_RDWR);
    1890:	83 ec 08             	sub    $0x8,%esp
    1893:	68 02 02 00 00       	push   $0x202
    1898:	56                   	push   %esi
    1899:	e8 05 1f 00 00       	call   37a3 <open>
      if(fd < 0){
    189e:	83 c4 10             	add    $0x10,%esp
    18a1:	85 c0                	test   %eax,%eax
    18a3:	79 94                	jns    1839 <concreate+0x28a>
    18a5:	e9 85 fd ff ff       	jmp    162f <concreate+0x80>

000018aa <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    18aa:	55                   	push   %ebp
    18ab:	89 e5                	mov    %esp,%ebp
    18ad:	57                   	push   %edi
    18ae:	56                   	push   %esi
    18af:	53                   	push   %ebx
    18b0:	83 ec 24             	sub    $0x24,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    18b3:	68 70 42 00 00       	push   $0x4270
    18b8:	6a 01                	push   $0x1
    18ba:	e8 ec 1f 00 00       	call   38ab <printf>

  unlink("x");
    18bf:	c7 04 24 fd 44 00 00 	movl   $0x44fd,(%esp)
    18c6:	e8 e8 1e 00 00       	call   37b3 <unlink>
  pid = fork();
    18cb:	e8 8b 1e 00 00       	call   375b <fork>
    18d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    18d3:	83 c4 10             	add    $0x10,%esp
    18d6:	85 c0                	test   %eax,%eax
    18d8:	78 18                	js     18f2 <linkunlink+0x48>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    18da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    18de:	19 db                	sbb    %ebx,%ebx
    18e0:	83 e3 60             	and    $0x60,%ebx
    18e3:	83 c3 01             	add    $0x1,%ebx
    18e6:	be 64 00 00 00       	mov    $0x64,%esi
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    18eb:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
    18f0:	eb 36                	jmp    1928 <linkunlink+0x7e>
    printf(1, "fork failed\n");
    18f2:	83 ec 08             	sub    $0x8,%esp
    18f5:	68 e5 4a 00 00       	push   $0x4ae5
    18fa:	6a 01                	push   $0x1
    18fc:	e8 aa 1f 00 00       	call   38ab <printf>
    exit();
    1901:	e8 5d 1e 00 00       	call   3763 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1906:	83 ec 08             	sub    $0x8,%esp
    1909:	68 02 02 00 00       	push   $0x202
    190e:	68 fd 44 00 00       	push   $0x44fd
    1913:	e8 8b 1e 00 00       	call   37a3 <open>
    1918:	89 04 24             	mov    %eax,(%esp)
    191b:	e8 6b 1e 00 00       	call   378b <close>
    1920:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1923:	83 ee 01             	sub    $0x1,%esi
    1926:	74 4d                	je     1975 <linkunlink+0xcb>
    x = x * 1103515245 + 12345;
    1928:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    192e:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    1934:	89 d8                	mov    %ebx,%eax
    1936:	f7 e7                	mul    %edi
    1938:	89 d0                	mov    %edx,%eax
    193a:	d1 e8                	shr    %eax
    193c:	83 e2 fe             	and    $0xfffffffe,%edx
    193f:	01 c2                	add    %eax,%edx
    1941:	89 d8                	mov    %ebx,%eax
    1943:	29 d0                	sub    %edx,%eax
    1945:	74 bf                	je     1906 <linkunlink+0x5c>
    } else if((x % 3) == 1){
    1947:	83 f8 01             	cmp    $0x1,%eax
    194a:	74 12                	je     195e <linkunlink+0xb4>
      link("cat", "x");
    } else {
      unlink("x");
    194c:	83 ec 0c             	sub    $0xc,%esp
    194f:	68 fd 44 00 00       	push   $0x44fd
    1954:	e8 5a 1e 00 00       	call   37b3 <unlink>
    1959:	83 c4 10             	add    $0x10,%esp
    195c:	eb c5                	jmp    1923 <linkunlink+0x79>
      link("cat", "x");
    195e:	83 ec 08             	sub    $0x8,%esp
    1961:	68 fd 44 00 00       	push   $0x44fd
    1966:	68 81 42 00 00       	push   $0x4281
    196b:	e8 53 1e 00 00       	call   37c3 <link>
    1970:	83 c4 10             	add    $0x10,%esp
    1973:	eb ae                	jmp    1923 <linkunlink+0x79>
    }
  }

  if(pid)
    1975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1979:	74 1c                	je     1997 <linkunlink+0xed>
    wait();
    197b:	e8 eb 1d 00 00       	call   376b <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    1980:	83 ec 08             	sub    $0x8,%esp
    1983:	68 85 42 00 00       	push   $0x4285
    1988:	6a 01                	push   $0x1
    198a:	e8 1c 1f 00 00       	call   38ab <printf>
}
    198f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1992:	5b                   	pop    %ebx
    1993:	5e                   	pop    %esi
    1994:	5f                   	pop    %edi
    1995:	5d                   	pop    %ebp
    1996:	c3                   	ret    
    exit();
    1997:	e8 c7 1d 00 00       	call   3763 <exit>

0000199c <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    199c:	55                   	push   %ebp
    199d:	89 e5                	mov    %esp,%ebp
    199f:	57                   	push   %edi
    19a0:	56                   	push   %esi
    19a1:	53                   	push   %ebx
    19a2:	83 ec 24             	sub    $0x24,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    19a5:	68 94 42 00 00       	push   $0x4294
    19aa:	6a 01                	push   $0x1
    19ac:	e8 fa 1e 00 00       	call   38ab <printf>
  unlink("bd");
    19b1:	c7 04 24 a1 42 00 00 	movl   $0x42a1,(%esp)
    19b8:	e8 f6 1d 00 00       	call   37b3 <unlink>

  fd = open("bd", O_CREATE);
    19bd:	83 c4 08             	add    $0x8,%esp
    19c0:	68 00 02 00 00       	push   $0x200
    19c5:	68 a1 42 00 00       	push   $0x42a1
    19ca:	e8 d4 1d 00 00       	call   37a3 <open>
  if(fd < 0){
    19cf:	83 c4 10             	add    $0x10,%esp
    19d2:	85 c0                	test   %eax,%eax
    19d4:	0f 88 e0 00 00 00    	js     1aba <bigdir+0x11e>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    19da:	83 ec 0c             	sub    $0xc,%esp
    19dd:	50                   	push   %eax
    19de:	e8 a8 1d 00 00       	call   378b <close>
    19e3:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    19e6:	be 00 00 00 00       	mov    $0x0,%esi
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    19eb:	8d 7d de             	lea    -0x22(%ebp),%edi
    name[0] = 'x';
    19ee:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    19f2:	8d 46 3f             	lea    0x3f(%esi),%eax
    19f5:	85 f6                	test   %esi,%esi
    19f7:	0f 49 c6             	cmovns %esi,%eax
    19fa:	c1 f8 06             	sar    $0x6,%eax
    19fd:	83 c0 30             	add    $0x30,%eax
    1a00:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a03:	89 f2                	mov    %esi,%edx
    1a05:	c1 fa 1f             	sar    $0x1f,%edx
    1a08:	c1 ea 1a             	shr    $0x1a,%edx
    1a0b:	8d 04 16             	lea    (%esi,%edx,1),%eax
    1a0e:	83 e0 3f             	and    $0x3f,%eax
    1a11:	29 d0                	sub    %edx,%eax
    1a13:	83 c0 30             	add    $0x30,%eax
    1a16:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1a19:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(link("bd", name) != 0){
    1a1d:	83 ec 08             	sub    $0x8,%esp
    1a20:	57                   	push   %edi
    1a21:	68 a1 42 00 00       	push   $0x42a1
    1a26:	e8 98 1d 00 00       	call   37c3 <link>
    1a2b:	89 c3                	mov    %eax,%ebx
    1a2d:	83 c4 10             	add    $0x10,%esp
    1a30:	85 c0                	test   %eax,%eax
    1a32:	0f 85 96 00 00 00    	jne    1ace <bigdir+0x132>
  for(i = 0; i < 500; i++){
    1a38:	83 c6 01             	add    $0x1,%esi
    1a3b:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1a41:	75 ab                	jne    19ee <bigdir+0x52>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1a43:	83 ec 0c             	sub    $0xc,%esp
    1a46:	68 a1 42 00 00       	push   $0x42a1
    1a4b:	e8 63 1d 00 00       	call   37b3 <unlink>
    1a50:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    1a53:	8d 75 de             	lea    -0x22(%ebp),%esi
    name[0] = 'x';
    1a56:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1a5a:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1a5d:	85 db                	test   %ebx,%ebx
    1a5f:	0f 49 c3             	cmovns %ebx,%eax
    1a62:	c1 f8 06             	sar    $0x6,%eax
    1a65:	83 c0 30             	add    $0x30,%eax
    1a68:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a6b:	89 da                	mov    %ebx,%edx
    1a6d:	c1 fa 1f             	sar    $0x1f,%edx
    1a70:	c1 ea 1a             	shr    $0x1a,%edx
    1a73:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1a76:	83 e0 3f             	and    $0x3f,%eax
    1a79:	29 d0                	sub    %edx,%eax
    1a7b:	83 c0 30             	add    $0x30,%eax
    1a7e:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1a81:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(unlink(name) != 0){
    1a85:	83 ec 0c             	sub    $0xc,%esp
    1a88:	56                   	push   %esi
    1a89:	e8 25 1d 00 00       	call   37b3 <unlink>
    1a8e:	83 c4 10             	add    $0x10,%esp
    1a91:	85 c0                	test   %eax,%eax
    1a93:	75 4d                	jne    1ae2 <bigdir+0x146>
  for(i = 0; i < 500; i++){
    1a95:	83 c3 01             	add    $0x1,%ebx
    1a98:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1a9e:	75 b6                	jne    1a56 <bigdir+0xba>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1aa0:	83 ec 08             	sub    $0x8,%esp
    1aa3:	68 e3 42 00 00       	push   $0x42e3
    1aa8:	6a 01                	push   $0x1
    1aaa:	e8 fc 1d 00 00       	call   38ab <printf>
}
    1aaf:	83 c4 10             	add    $0x10,%esp
    1ab2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ab5:	5b                   	pop    %ebx
    1ab6:	5e                   	pop    %esi
    1ab7:	5f                   	pop    %edi
    1ab8:	5d                   	pop    %ebp
    1ab9:	c3                   	ret    
    printf(1, "bigdir create failed\n");
    1aba:	83 ec 08             	sub    $0x8,%esp
    1abd:	68 a4 42 00 00       	push   $0x42a4
    1ac2:	6a 01                	push   $0x1
    1ac4:	e8 e2 1d 00 00       	call   38ab <printf>
    exit();
    1ac9:	e8 95 1c 00 00       	call   3763 <exit>
      printf(1, "bigdir link failed\n");
    1ace:	83 ec 08             	sub    $0x8,%esp
    1ad1:	68 ba 42 00 00       	push   $0x42ba
    1ad6:	6a 01                	push   $0x1
    1ad8:	e8 ce 1d 00 00       	call   38ab <printf>
      exit();
    1add:	e8 81 1c 00 00       	call   3763 <exit>
      printf(1, "bigdir unlink failed");
    1ae2:	83 ec 08             	sub    $0x8,%esp
    1ae5:	68 ce 42 00 00       	push   $0x42ce
    1aea:	6a 01                	push   $0x1
    1aec:	e8 ba 1d 00 00       	call   38ab <printf>
      exit();
    1af1:	e8 6d 1c 00 00       	call   3763 <exit>

00001af6 <subdir>:

void
subdir(void)
{
    1af6:	55                   	push   %ebp
    1af7:	89 e5                	mov    %esp,%ebp
    1af9:	53                   	push   %ebx
    1afa:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1afd:	68 ee 42 00 00       	push   $0x42ee
    1b02:	6a 01                	push   $0x1
    1b04:	e8 a2 1d 00 00       	call   38ab <printf>

  unlink("ff");
    1b09:	c7 04 24 77 43 00 00 	movl   $0x4377,(%esp)
    1b10:	e8 9e 1c 00 00       	call   37b3 <unlink>
  if(mkdir("dd") != 0){
    1b15:	c7 04 24 14 44 00 00 	movl   $0x4414,(%esp)
    1b1c:	e8 aa 1c 00 00       	call   37cb <mkdir>
    1b21:	83 c4 10             	add    $0x10,%esp
    1b24:	85 c0                	test   %eax,%eax
    1b26:	0f 85 14 04 00 00    	jne    1f40 <subdir+0x44a>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b2c:	83 ec 08             	sub    $0x8,%esp
    1b2f:	68 02 02 00 00       	push   $0x202
    1b34:	68 4d 43 00 00       	push   $0x434d
    1b39:	e8 65 1c 00 00       	call   37a3 <open>
    1b3e:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b40:	83 c4 10             	add    $0x10,%esp
    1b43:	85 c0                	test   %eax,%eax
    1b45:	0f 88 09 04 00 00    	js     1f54 <subdir+0x45e>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1b4b:	83 ec 04             	sub    $0x4,%esp
    1b4e:	6a 02                	push   $0x2
    1b50:	68 77 43 00 00       	push   $0x4377
    1b55:	50                   	push   %eax
    1b56:	e8 28 1c 00 00       	call   3783 <write>
  close(fd);
    1b5b:	89 1c 24             	mov    %ebx,(%esp)
    1b5e:	e8 28 1c 00 00       	call   378b <close>

  if(unlink("dd") >= 0){
    1b63:	c7 04 24 14 44 00 00 	movl   $0x4414,(%esp)
    1b6a:	e8 44 1c 00 00       	call   37b3 <unlink>
    1b6f:	83 c4 10             	add    $0x10,%esp
    1b72:	85 c0                	test   %eax,%eax
    1b74:	0f 89 ee 03 00 00    	jns    1f68 <subdir+0x472>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    1b7a:	83 ec 0c             	sub    $0xc,%esp
    1b7d:	68 28 43 00 00       	push   $0x4328
    1b82:	e8 44 1c 00 00       	call   37cb <mkdir>
    1b87:	83 c4 10             	add    $0x10,%esp
    1b8a:	85 c0                	test   %eax,%eax
    1b8c:	0f 85 ea 03 00 00    	jne    1f7c <subdir+0x486>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1b92:	83 ec 08             	sub    $0x8,%esp
    1b95:	68 02 02 00 00       	push   $0x202
    1b9a:	68 4a 43 00 00       	push   $0x434a
    1b9f:	e8 ff 1b 00 00       	call   37a3 <open>
    1ba4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1ba6:	83 c4 10             	add    $0x10,%esp
    1ba9:	85 c0                	test   %eax,%eax
    1bab:	0f 88 df 03 00 00    	js     1f90 <subdir+0x49a>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    1bb1:	83 ec 04             	sub    $0x4,%esp
    1bb4:	6a 02                	push   $0x2
    1bb6:	68 6b 43 00 00       	push   $0x436b
    1bbb:	50                   	push   %eax
    1bbc:	e8 c2 1b 00 00       	call   3783 <write>
  close(fd);
    1bc1:	89 1c 24             	mov    %ebx,(%esp)
    1bc4:	e8 c2 1b 00 00       	call   378b <close>

  fd = open("dd/dd/../ff", 0);
    1bc9:	83 c4 08             	add    $0x8,%esp
    1bcc:	6a 00                	push   $0x0
    1bce:	68 6e 43 00 00       	push   $0x436e
    1bd3:	e8 cb 1b 00 00       	call   37a3 <open>
    1bd8:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bda:	83 c4 10             	add    $0x10,%esp
    1bdd:	85 c0                	test   %eax,%eax
    1bdf:	0f 88 bf 03 00 00    	js     1fa4 <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1be5:	83 ec 04             	sub    $0x4,%esp
    1be8:	68 00 20 00 00       	push   $0x2000
    1bed:	68 60 83 00 00       	push   $0x8360
    1bf2:	50                   	push   %eax
    1bf3:	e8 83 1b 00 00       	call   377b <read>
  if(cc != 2 || buf[0] != 'f'){
    1bf8:	83 c4 10             	add    $0x10,%esp
    1bfb:	83 f8 02             	cmp    $0x2,%eax
    1bfe:	0f 85 b4 03 00 00    	jne    1fb8 <subdir+0x4c2>
    1c04:	80 3d 60 83 00 00 66 	cmpb   $0x66,0x8360
    1c0b:	0f 85 a7 03 00 00    	jne    1fb8 <subdir+0x4c2>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    1c11:	83 ec 0c             	sub    $0xc,%esp
    1c14:	53                   	push   %ebx
    1c15:	e8 71 1b 00 00       	call   378b <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c1a:	83 c4 08             	add    $0x8,%esp
    1c1d:	68 ae 43 00 00       	push   $0x43ae
    1c22:	68 4a 43 00 00       	push   $0x434a
    1c27:	e8 97 1b 00 00       	call   37c3 <link>
    1c2c:	83 c4 10             	add    $0x10,%esp
    1c2f:	85 c0                	test   %eax,%eax
    1c31:	0f 85 95 03 00 00    	jne    1fcc <subdir+0x4d6>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1c37:	83 ec 0c             	sub    $0xc,%esp
    1c3a:	68 4a 43 00 00       	push   $0x434a
    1c3f:	e8 6f 1b 00 00       	call   37b3 <unlink>
    1c44:	83 c4 10             	add    $0x10,%esp
    1c47:	85 c0                	test   %eax,%eax
    1c49:	0f 85 91 03 00 00    	jne    1fe0 <subdir+0x4ea>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1c4f:	83 ec 08             	sub    $0x8,%esp
    1c52:	6a 00                	push   $0x0
    1c54:	68 4a 43 00 00       	push   $0x434a
    1c59:	e8 45 1b 00 00       	call   37a3 <open>
    1c5e:	83 c4 10             	add    $0x10,%esp
    1c61:	85 c0                	test   %eax,%eax
    1c63:	0f 89 8b 03 00 00    	jns    1ff4 <subdir+0x4fe>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    1c69:	83 ec 0c             	sub    $0xc,%esp
    1c6c:	68 14 44 00 00       	push   $0x4414
    1c71:	e8 5d 1b 00 00       	call   37d3 <chdir>
    1c76:	83 c4 10             	add    $0x10,%esp
    1c79:	85 c0                	test   %eax,%eax
    1c7b:	0f 85 87 03 00 00    	jne    2008 <subdir+0x512>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1c81:	83 ec 0c             	sub    $0xc,%esp
    1c84:	68 e2 43 00 00       	push   $0x43e2
    1c89:	e8 45 1b 00 00       	call   37d3 <chdir>
    1c8e:	83 c4 10             	add    $0x10,%esp
    1c91:	85 c0                	test   %eax,%eax
    1c93:	0f 85 83 03 00 00    	jne    201c <subdir+0x526>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1c99:	83 ec 0c             	sub    $0xc,%esp
    1c9c:	68 08 44 00 00       	push   $0x4408
    1ca1:	e8 2d 1b 00 00       	call   37d3 <chdir>
    1ca6:	83 c4 10             	add    $0x10,%esp
    1ca9:	85 c0                	test   %eax,%eax
    1cab:	0f 85 7f 03 00 00    	jne    2030 <subdir+0x53a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1cb1:	83 ec 0c             	sub    $0xc,%esp
    1cb4:	68 17 44 00 00       	push   $0x4417
    1cb9:	e8 15 1b 00 00       	call   37d3 <chdir>
    1cbe:	83 c4 10             	add    $0x10,%esp
    1cc1:	85 c0                	test   %eax,%eax
    1cc3:	0f 85 7b 03 00 00    	jne    2044 <subdir+0x54e>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1cc9:	83 ec 08             	sub    $0x8,%esp
    1ccc:	6a 00                	push   $0x0
    1cce:	68 ae 43 00 00       	push   $0x43ae
    1cd3:	e8 cb 1a 00 00       	call   37a3 <open>
    1cd8:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1cda:	83 c4 10             	add    $0x10,%esp
    1cdd:	85 c0                	test   %eax,%eax
    1cdf:	0f 88 73 03 00 00    	js     2058 <subdir+0x562>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1ce5:	83 ec 04             	sub    $0x4,%esp
    1ce8:	68 00 20 00 00       	push   $0x2000
    1ced:	68 60 83 00 00       	push   $0x8360
    1cf2:	50                   	push   %eax
    1cf3:	e8 83 1a 00 00       	call   377b <read>
    1cf8:	83 c4 10             	add    $0x10,%esp
    1cfb:	83 f8 02             	cmp    $0x2,%eax
    1cfe:	0f 85 68 03 00 00    	jne    206c <subdir+0x576>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1d04:	83 ec 0c             	sub    $0xc,%esp
    1d07:	53                   	push   %ebx
    1d08:	e8 7e 1a 00 00       	call   378b <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d0d:	83 c4 08             	add    $0x8,%esp
    1d10:	6a 00                	push   $0x0
    1d12:	68 4a 43 00 00       	push   $0x434a
    1d17:	e8 87 1a 00 00       	call   37a3 <open>
    1d1c:	83 c4 10             	add    $0x10,%esp
    1d1f:	85 c0                	test   %eax,%eax
    1d21:	0f 89 59 03 00 00    	jns    2080 <subdir+0x58a>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d27:	83 ec 08             	sub    $0x8,%esp
    1d2a:	68 02 02 00 00       	push   $0x202
    1d2f:	68 62 44 00 00       	push   $0x4462
    1d34:	e8 6a 1a 00 00       	call   37a3 <open>
    1d39:	83 c4 10             	add    $0x10,%esp
    1d3c:	85 c0                	test   %eax,%eax
    1d3e:	0f 89 50 03 00 00    	jns    2094 <subdir+0x59e>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d44:	83 ec 08             	sub    $0x8,%esp
    1d47:	68 02 02 00 00       	push   $0x202
    1d4c:	68 87 44 00 00       	push   $0x4487
    1d51:	e8 4d 1a 00 00       	call   37a3 <open>
    1d56:	83 c4 10             	add    $0x10,%esp
    1d59:	85 c0                	test   %eax,%eax
    1d5b:	0f 89 47 03 00 00    	jns    20a8 <subdir+0x5b2>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    1d61:	83 ec 08             	sub    $0x8,%esp
    1d64:	68 00 02 00 00       	push   $0x200
    1d69:	68 14 44 00 00       	push   $0x4414
    1d6e:	e8 30 1a 00 00       	call   37a3 <open>
    1d73:	83 c4 10             	add    $0x10,%esp
    1d76:	85 c0                	test   %eax,%eax
    1d78:	0f 89 3e 03 00 00    	jns    20bc <subdir+0x5c6>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1d7e:	83 ec 08             	sub    $0x8,%esp
    1d81:	6a 02                	push   $0x2
    1d83:	68 14 44 00 00       	push   $0x4414
    1d88:	e8 16 1a 00 00       	call   37a3 <open>
    1d8d:	83 c4 10             	add    $0x10,%esp
    1d90:	85 c0                	test   %eax,%eax
    1d92:	0f 89 38 03 00 00    	jns    20d0 <subdir+0x5da>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1d98:	83 ec 08             	sub    $0x8,%esp
    1d9b:	6a 01                	push   $0x1
    1d9d:	68 14 44 00 00       	push   $0x4414
    1da2:	e8 fc 19 00 00       	call   37a3 <open>
    1da7:	83 c4 10             	add    $0x10,%esp
    1daa:	85 c0                	test   %eax,%eax
    1dac:	0f 89 32 03 00 00    	jns    20e4 <subdir+0x5ee>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1db2:	83 ec 08             	sub    $0x8,%esp
    1db5:	68 f6 44 00 00       	push   $0x44f6
    1dba:	68 62 44 00 00       	push   $0x4462
    1dbf:	e8 ff 19 00 00       	call   37c3 <link>
    1dc4:	83 c4 10             	add    $0x10,%esp
    1dc7:	85 c0                	test   %eax,%eax
    1dc9:	0f 84 29 03 00 00    	je     20f8 <subdir+0x602>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1dcf:	83 ec 08             	sub    $0x8,%esp
    1dd2:	68 f6 44 00 00       	push   $0x44f6
    1dd7:	68 87 44 00 00       	push   $0x4487
    1ddc:	e8 e2 19 00 00       	call   37c3 <link>
    1de1:	83 c4 10             	add    $0x10,%esp
    1de4:	85 c0                	test   %eax,%eax
    1de6:	0f 84 20 03 00 00    	je     210c <subdir+0x616>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1dec:	83 ec 08             	sub    $0x8,%esp
    1def:	68 ae 43 00 00       	push   $0x43ae
    1df4:	68 4d 43 00 00       	push   $0x434d
    1df9:	e8 c5 19 00 00       	call   37c3 <link>
    1dfe:	83 c4 10             	add    $0x10,%esp
    1e01:	85 c0                	test   %eax,%eax
    1e03:	0f 84 17 03 00 00    	je     2120 <subdir+0x62a>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1e09:	83 ec 0c             	sub    $0xc,%esp
    1e0c:	68 62 44 00 00       	push   $0x4462
    1e11:	e8 b5 19 00 00       	call   37cb <mkdir>
    1e16:	83 c4 10             	add    $0x10,%esp
    1e19:	85 c0                	test   %eax,%eax
    1e1b:	0f 84 13 03 00 00    	je     2134 <subdir+0x63e>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1e21:	83 ec 0c             	sub    $0xc,%esp
    1e24:	68 87 44 00 00       	push   $0x4487
    1e29:	e8 9d 19 00 00       	call   37cb <mkdir>
    1e2e:	83 c4 10             	add    $0x10,%esp
    1e31:	85 c0                	test   %eax,%eax
    1e33:	0f 84 0f 03 00 00    	je     2148 <subdir+0x652>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1e39:	83 ec 0c             	sub    $0xc,%esp
    1e3c:	68 ae 43 00 00       	push   $0x43ae
    1e41:	e8 85 19 00 00       	call   37cb <mkdir>
    1e46:	83 c4 10             	add    $0x10,%esp
    1e49:	85 c0                	test   %eax,%eax
    1e4b:	0f 84 0b 03 00 00    	je     215c <subdir+0x666>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1e51:	83 ec 0c             	sub    $0xc,%esp
    1e54:	68 87 44 00 00       	push   $0x4487
    1e59:	e8 55 19 00 00       	call   37b3 <unlink>
    1e5e:	83 c4 10             	add    $0x10,%esp
    1e61:	85 c0                	test   %eax,%eax
    1e63:	0f 84 07 03 00 00    	je     2170 <subdir+0x67a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1e69:	83 ec 0c             	sub    $0xc,%esp
    1e6c:	68 62 44 00 00       	push   $0x4462
    1e71:	e8 3d 19 00 00       	call   37b3 <unlink>
    1e76:	83 c4 10             	add    $0x10,%esp
    1e79:	85 c0                	test   %eax,%eax
    1e7b:	0f 84 03 03 00 00    	je     2184 <subdir+0x68e>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1e81:	83 ec 0c             	sub    $0xc,%esp
    1e84:	68 4d 43 00 00       	push   $0x434d
    1e89:	e8 45 19 00 00       	call   37d3 <chdir>
    1e8e:	83 c4 10             	add    $0x10,%esp
    1e91:	85 c0                	test   %eax,%eax
    1e93:	0f 84 ff 02 00 00    	je     2198 <subdir+0x6a2>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1e99:	83 ec 0c             	sub    $0xc,%esp
    1e9c:	68 f9 44 00 00       	push   $0x44f9
    1ea1:	e8 2d 19 00 00       	call   37d3 <chdir>
    1ea6:	83 c4 10             	add    $0x10,%esp
    1ea9:	85 c0                	test   %eax,%eax
    1eab:	0f 84 fb 02 00 00    	je     21ac <subdir+0x6b6>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1eb1:	83 ec 0c             	sub    $0xc,%esp
    1eb4:	68 ae 43 00 00       	push   $0x43ae
    1eb9:	e8 f5 18 00 00       	call   37b3 <unlink>
    1ebe:	83 c4 10             	add    $0x10,%esp
    1ec1:	85 c0                	test   %eax,%eax
    1ec3:	0f 85 f7 02 00 00    	jne    21c0 <subdir+0x6ca>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1ec9:	83 ec 0c             	sub    $0xc,%esp
    1ecc:	68 4d 43 00 00       	push   $0x434d
    1ed1:	e8 dd 18 00 00       	call   37b3 <unlink>
    1ed6:	83 c4 10             	add    $0x10,%esp
    1ed9:	85 c0                	test   %eax,%eax
    1edb:	0f 85 f3 02 00 00    	jne    21d4 <subdir+0x6de>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1ee1:	83 ec 0c             	sub    $0xc,%esp
    1ee4:	68 14 44 00 00       	push   $0x4414
    1ee9:	e8 c5 18 00 00       	call   37b3 <unlink>
    1eee:	83 c4 10             	add    $0x10,%esp
    1ef1:	85 c0                	test   %eax,%eax
    1ef3:	0f 84 ef 02 00 00    	je     21e8 <subdir+0x6f2>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1ef9:	83 ec 0c             	sub    $0xc,%esp
    1efc:	68 29 43 00 00       	push   $0x4329
    1f01:	e8 ad 18 00 00       	call   37b3 <unlink>
    1f06:	83 c4 10             	add    $0x10,%esp
    1f09:	85 c0                	test   %eax,%eax
    1f0b:	0f 88 eb 02 00 00    	js     21fc <subdir+0x706>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1f11:	83 ec 0c             	sub    $0xc,%esp
    1f14:	68 14 44 00 00       	push   $0x4414
    1f19:	e8 95 18 00 00       	call   37b3 <unlink>
    1f1e:	83 c4 10             	add    $0x10,%esp
    1f21:	85 c0                	test   %eax,%eax
    1f23:	0f 88 e7 02 00 00    	js     2210 <subdir+0x71a>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1f29:	83 ec 08             	sub    $0x8,%esp
    1f2c:	68 f6 45 00 00       	push   $0x45f6
    1f31:	6a 01                	push   $0x1
    1f33:	e8 73 19 00 00       	call   38ab <printf>
}
    1f38:	83 c4 10             	add    $0x10,%esp
    1f3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f3e:	c9                   	leave  
    1f3f:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    1f40:	83 ec 08             	sub    $0x8,%esp
    1f43:	68 fb 42 00 00       	push   $0x42fb
    1f48:	6a 01                	push   $0x1
    1f4a:	e8 5c 19 00 00       	call   38ab <printf>
    exit();
    1f4f:	e8 0f 18 00 00       	call   3763 <exit>
    printf(1, "create dd/ff failed\n");
    1f54:	83 ec 08             	sub    $0x8,%esp
    1f57:	68 13 43 00 00       	push   $0x4313
    1f5c:	6a 01                	push   $0x1
    1f5e:	e8 48 19 00 00       	call   38ab <printf>
    exit();
    1f63:	e8 fb 17 00 00       	call   3763 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1f68:	83 ec 08             	sub    $0x8,%esp
    1f6b:	68 e0 4d 00 00       	push   $0x4de0
    1f70:	6a 01                	push   $0x1
    1f72:	e8 34 19 00 00       	call   38ab <printf>
    exit();
    1f77:	e8 e7 17 00 00       	call   3763 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    1f7c:	83 ec 08             	sub    $0x8,%esp
    1f7f:	68 2f 43 00 00       	push   $0x432f
    1f84:	6a 01                	push   $0x1
    1f86:	e8 20 19 00 00       	call   38ab <printf>
    exit();
    1f8b:	e8 d3 17 00 00       	call   3763 <exit>
    printf(1, "create dd/dd/ff failed\n");
    1f90:	83 ec 08             	sub    $0x8,%esp
    1f93:	68 53 43 00 00       	push   $0x4353
    1f98:	6a 01                	push   $0x1
    1f9a:	e8 0c 19 00 00       	call   38ab <printf>
    exit();
    1f9f:	e8 bf 17 00 00       	call   3763 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1fa4:	83 ec 08             	sub    $0x8,%esp
    1fa7:	68 7a 43 00 00       	push   $0x437a
    1fac:	6a 01                	push   $0x1
    1fae:	e8 f8 18 00 00       	call   38ab <printf>
    exit();
    1fb3:	e8 ab 17 00 00       	call   3763 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    1fb8:	83 ec 08             	sub    $0x8,%esp
    1fbb:	68 93 43 00 00       	push   $0x4393
    1fc0:	6a 01                	push   $0x1
    1fc2:	e8 e4 18 00 00       	call   38ab <printf>
    exit();
    1fc7:	e8 97 17 00 00       	call   3763 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1fcc:	83 ec 08             	sub    $0x8,%esp
    1fcf:	68 08 4e 00 00       	push   $0x4e08
    1fd4:	6a 01                	push   $0x1
    1fd6:	e8 d0 18 00 00       	call   38ab <printf>
    exit();
    1fdb:	e8 83 17 00 00       	call   3763 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    1fe0:	83 ec 08             	sub    $0x8,%esp
    1fe3:	68 b9 43 00 00       	push   $0x43b9
    1fe8:	6a 01                	push   $0x1
    1fea:	e8 bc 18 00 00       	call   38ab <printf>
    exit();
    1fef:	e8 6f 17 00 00       	call   3763 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1ff4:	83 ec 08             	sub    $0x8,%esp
    1ff7:	68 2c 4e 00 00       	push   $0x4e2c
    1ffc:	6a 01                	push   $0x1
    1ffe:	e8 a8 18 00 00       	call   38ab <printf>
    exit();
    2003:	e8 5b 17 00 00       	call   3763 <exit>
    printf(1, "chdir dd failed\n");
    2008:	83 ec 08             	sub    $0x8,%esp
    200b:	68 d1 43 00 00       	push   $0x43d1
    2010:	6a 01                	push   $0x1
    2012:	e8 94 18 00 00       	call   38ab <printf>
    exit();
    2017:	e8 47 17 00 00       	call   3763 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    201c:	83 ec 08             	sub    $0x8,%esp
    201f:	68 ee 43 00 00       	push   $0x43ee
    2024:	6a 01                	push   $0x1
    2026:	e8 80 18 00 00       	call   38ab <printf>
    exit();
    202b:	e8 33 17 00 00       	call   3763 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2030:	83 ec 08             	sub    $0x8,%esp
    2033:	68 ee 43 00 00       	push   $0x43ee
    2038:	6a 01                	push   $0x1
    203a:	e8 6c 18 00 00       	call   38ab <printf>
    exit();
    203f:	e8 1f 17 00 00       	call   3763 <exit>
    printf(1, "chdir ./.. failed\n");
    2044:	83 ec 08             	sub    $0x8,%esp
    2047:	68 1c 44 00 00       	push   $0x441c
    204c:	6a 01                	push   $0x1
    204e:	e8 58 18 00 00       	call   38ab <printf>
    exit();
    2053:	e8 0b 17 00 00       	call   3763 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2058:	83 ec 08             	sub    $0x8,%esp
    205b:	68 2f 44 00 00       	push   $0x442f
    2060:	6a 01                	push   $0x1
    2062:	e8 44 18 00 00       	call   38ab <printf>
    exit();
    2067:	e8 f7 16 00 00       	call   3763 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    206c:	83 ec 08             	sub    $0x8,%esp
    206f:	68 47 44 00 00       	push   $0x4447
    2074:	6a 01                	push   $0x1
    2076:	e8 30 18 00 00       	call   38ab <printf>
    exit();
    207b:	e8 e3 16 00 00       	call   3763 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2080:	83 ec 08             	sub    $0x8,%esp
    2083:	68 50 4e 00 00       	push   $0x4e50
    2088:	6a 01                	push   $0x1
    208a:	e8 1c 18 00 00       	call   38ab <printf>
    exit();
    208f:	e8 cf 16 00 00       	call   3763 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2094:	83 ec 08             	sub    $0x8,%esp
    2097:	68 6b 44 00 00       	push   $0x446b
    209c:	6a 01                	push   $0x1
    209e:	e8 08 18 00 00       	call   38ab <printf>
    exit();
    20a3:	e8 bb 16 00 00       	call   3763 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    20a8:	83 ec 08             	sub    $0x8,%esp
    20ab:	68 90 44 00 00       	push   $0x4490
    20b0:	6a 01                	push   $0x1
    20b2:	e8 f4 17 00 00       	call   38ab <printf>
    exit();
    20b7:	e8 a7 16 00 00       	call   3763 <exit>
    printf(1, "create dd succeeded!\n");
    20bc:	83 ec 08             	sub    $0x8,%esp
    20bf:	68 ac 44 00 00       	push   $0x44ac
    20c4:	6a 01                	push   $0x1
    20c6:	e8 e0 17 00 00       	call   38ab <printf>
    exit();
    20cb:	e8 93 16 00 00       	call   3763 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    20d0:	83 ec 08             	sub    $0x8,%esp
    20d3:	68 c2 44 00 00       	push   $0x44c2
    20d8:	6a 01                	push   $0x1
    20da:	e8 cc 17 00 00       	call   38ab <printf>
    exit();
    20df:	e8 7f 16 00 00       	call   3763 <exit>
    printf(1, "open dd wronly succeeded!\n");
    20e4:	83 ec 08             	sub    $0x8,%esp
    20e7:	68 db 44 00 00       	push   $0x44db
    20ec:	6a 01                	push   $0x1
    20ee:	e8 b8 17 00 00       	call   38ab <printf>
    exit();
    20f3:	e8 6b 16 00 00       	call   3763 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    20f8:	83 ec 08             	sub    $0x8,%esp
    20fb:	68 78 4e 00 00       	push   $0x4e78
    2100:	6a 01                	push   $0x1
    2102:	e8 a4 17 00 00       	call   38ab <printf>
    exit();
    2107:	e8 57 16 00 00       	call   3763 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    210c:	83 ec 08             	sub    $0x8,%esp
    210f:	68 9c 4e 00 00       	push   $0x4e9c
    2114:	6a 01                	push   $0x1
    2116:	e8 90 17 00 00       	call   38ab <printf>
    exit();
    211b:	e8 43 16 00 00       	call   3763 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2120:	83 ec 08             	sub    $0x8,%esp
    2123:	68 c0 4e 00 00       	push   $0x4ec0
    2128:	6a 01                	push   $0x1
    212a:	e8 7c 17 00 00       	call   38ab <printf>
    exit();
    212f:	e8 2f 16 00 00       	call   3763 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2134:	83 ec 08             	sub    $0x8,%esp
    2137:	68 ff 44 00 00       	push   $0x44ff
    213c:	6a 01                	push   $0x1
    213e:	e8 68 17 00 00       	call   38ab <printf>
    exit();
    2143:	e8 1b 16 00 00       	call   3763 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2148:	83 ec 08             	sub    $0x8,%esp
    214b:	68 1a 45 00 00       	push   $0x451a
    2150:	6a 01                	push   $0x1
    2152:	e8 54 17 00 00       	call   38ab <printf>
    exit();
    2157:	e8 07 16 00 00       	call   3763 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    215c:	83 ec 08             	sub    $0x8,%esp
    215f:	68 35 45 00 00       	push   $0x4535
    2164:	6a 01                	push   $0x1
    2166:	e8 40 17 00 00       	call   38ab <printf>
    exit();
    216b:	e8 f3 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2170:	83 ec 08             	sub    $0x8,%esp
    2173:	68 52 45 00 00       	push   $0x4552
    2178:	6a 01                	push   $0x1
    217a:	e8 2c 17 00 00       	call   38ab <printf>
    exit();
    217f:	e8 df 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2184:	83 ec 08             	sub    $0x8,%esp
    2187:	68 6e 45 00 00       	push   $0x456e
    218c:	6a 01                	push   $0x1
    218e:	e8 18 17 00 00       	call   38ab <printf>
    exit();
    2193:	e8 cb 15 00 00       	call   3763 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    2198:	83 ec 08             	sub    $0x8,%esp
    219b:	68 8a 45 00 00       	push   $0x458a
    21a0:	6a 01                	push   $0x1
    21a2:	e8 04 17 00 00       	call   38ab <printf>
    exit();
    21a7:	e8 b7 15 00 00       	call   3763 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    21ac:	83 ec 08             	sub    $0x8,%esp
    21af:	68 a2 45 00 00       	push   $0x45a2
    21b4:	6a 01                	push   $0x1
    21b6:	e8 f0 16 00 00       	call   38ab <printf>
    exit();
    21bb:	e8 a3 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    21c0:	83 ec 08             	sub    $0x8,%esp
    21c3:	68 b9 43 00 00       	push   $0x43b9
    21c8:	6a 01                	push   $0x1
    21ca:	e8 dc 16 00 00       	call   38ab <printf>
    exit();
    21cf:	e8 8f 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd/ff failed\n");
    21d4:	83 ec 08             	sub    $0x8,%esp
    21d7:	68 ba 45 00 00       	push   $0x45ba
    21dc:	6a 01                	push   $0x1
    21de:	e8 c8 16 00 00       	call   38ab <printf>
    exit();
    21e3:	e8 7b 15 00 00       	call   3763 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    21e8:	83 ec 08             	sub    $0x8,%esp
    21eb:	68 e4 4e 00 00       	push   $0x4ee4
    21f0:	6a 01                	push   $0x1
    21f2:	e8 b4 16 00 00       	call   38ab <printf>
    exit();
    21f7:	e8 67 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd/dd failed\n");
    21fc:	83 ec 08             	sub    $0x8,%esp
    21ff:	68 cf 45 00 00       	push   $0x45cf
    2204:	6a 01                	push   $0x1
    2206:	e8 a0 16 00 00       	call   38ab <printf>
    exit();
    220b:	e8 53 15 00 00       	call   3763 <exit>
    printf(1, "unlink dd failed\n");
    2210:	83 ec 08             	sub    $0x8,%esp
    2213:	68 e4 45 00 00       	push   $0x45e4
    2218:	6a 01                	push   $0x1
    221a:	e8 8c 16 00 00       	call   38ab <printf>
    exit();
    221f:	e8 3f 15 00 00       	call   3763 <exit>

00002224 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2224:	55                   	push   %ebp
    2225:	89 e5                	mov    %esp,%ebp
    2227:	57                   	push   %edi
    2228:	56                   	push   %esi
    2229:	53                   	push   %ebx
    222a:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    222d:	68 01 46 00 00       	push   $0x4601
    2232:	6a 01                	push   $0x1
    2234:	e8 72 16 00 00       	call   38ab <printf>

  unlink("bigwrite");
    2239:	c7 04 24 10 46 00 00 	movl   $0x4610,(%esp)
    2240:	e8 6e 15 00 00       	call   37b3 <unlink>
    2245:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2248:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    224d:	83 ec 08             	sub    $0x8,%esp
    2250:	68 02 02 00 00       	push   $0x202
    2255:	68 10 46 00 00       	push   $0x4610
    225a:	e8 44 15 00 00       	call   37a3 <open>
    225f:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2261:	83 c4 10             	add    $0x10,%esp
    2264:	85 c0                	test   %eax,%eax
    2266:	78 6e                	js     22d6 <bigwrite+0xb2>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    2268:	83 ec 04             	sub    $0x4,%esp
    226b:	53                   	push   %ebx
    226c:	68 60 83 00 00       	push   $0x8360
    2271:	50                   	push   %eax
    2272:	e8 0c 15 00 00       	call   3783 <write>
    2277:	89 c7                	mov    %eax,%edi
      if(cc != sz){
    2279:	83 c4 10             	add    $0x10,%esp
    227c:	39 c3                	cmp    %eax,%ebx
    227e:	75 6a                	jne    22ea <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    2280:	83 ec 04             	sub    $0x4,%esp
    2283:	53                   	push   %ebx
    2284:	68 60 83 00 00       	push   $0x8360
    2289:	56                   	push   %esi
    228a:	e8 f4 14 00 00       	call   3783 <write>
      if(cc != sz){
    228f:	83 c4 10             	add    $0x10,%esp
    2292:	39 d8                	cmp    %ebx,%eax
    2294:	75 56                	jne    22ec <bigwrite+0xc8>
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2296:	83 ec 0c             	sub    $0xc,%esp
    2299:	56                   	push   %esi
    229a:	e8 ec 14 00 00       	call   378b <close>
    unlink("bigwrite");
    229f:	c7 04 24 10 46 00 00 	movl   $0x4610,(%esp)
    22a6:	e8 08 15 00 00       	call   37b3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    22ab:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    22b1:	83 c4 10             	add    $0x10,%esp
    22b4:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    22ba:	75 91                	jne    224d <bigwrite+0x29>
  }

  printf(1, "bigwrite ok\n");
    22bc:	83 ec 08             	sub    $0x8,%esp
    22bf:	68 43 46 00 00       	push   $0x4643
    22c4:	6a 01                	push   $0x1
    22c6:	e8 e0 15 00 00       	call   38ab <printf>
}
    22cb:	83 c4 10             	add    $0x10,%esp
    22ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    22d1:	5b                   	pop    %ebx
    22d2:	5e                   	pop    %esi
    22d3:	5f                   	pop    %edi
    22d4:	5d                   	pop    %ebp
    22d5:	c3                   	ret    
      printf(1, "cannot create bigwrite\n");
    22d6:	83 ec 08             	sub    $0x8,%esp
    22d9:	68 19 46 00 00       	push   $0x4619
    22de:	6a 01                	push   $0x1
    22e0:	e8 c6 15 00 00       	call   38ab <printf>
      exit();
    22e5:	e8 79 14 00 00       	call   3763 <exit>
      if(cc != sz){
    22ea:	89 df                	mov    %ebx,%edi
        printf(1, "write(%d) ret %d\n", sz, cc);
    22ec:	50                   	push   %eax
    22ed:	57                   	push   %edi
    22ee:	68 31 46 00 00       	push   $0x4631
    22f3:	6a 01                	push   $0x1
    22f5:	e8 b1 15 00 00       	call   38ab <printf>
        exit();
    22fa:	e8 64 14 00 00       	call   3763 <exit>

000022ff <bigfile>:

void
bigfile(void)
{
    22ff:	55                   	push   %ebp
    2300:	89 e5                	mov    %esp,%ebp
    2302:	57                   	push   %edi
    2303:	56                   	push   %esi
    2304:	53                   	push   %ebx
    2305:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2308:	68 50 46 00 00       	push   $0x4650
    230d:	6a 01                	push   $0x1
    230f:	e8 97 15 00 00       	call   38ab <printf>

  unlink("bigfile");
    2314:	c7 04 24 6c 46 00 00 	movl   $0x466c,(%esp)
    231b:	e8 93 14 00 00       	call   37b3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2320:	83 c4 08             	add    $0x8,%esp
    2323:	68 02 02 00 00       	push   $0x202
    2328:	68 6c 46 00 00       	push   $0x466c
    232d:	e8 71 14 00 00       	call   37a3 <open>
  if(fd < 0){
    2332:	83 c4 10             	add    $0x10,%esp
    2335:	85 c0                	test   %eax,%eax
    2337:	0f 88 c3 00 00 00    	js     2400 <bigfile+0x101>
    233d:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    233f:	bb 00 00 00 00       	mov    $0x0,%ebx
    memset(buf, i, 600);
    2344:	83 ec 04             	sub    $0x4,%esp
    2347:	68 58 02 00 00       	push   $0x258
    234c:	53                   	push   %ebx
    234d:	68 60 83 00 00       	push   $0x8360
    2352:	e8 b9 12 00 00       	call   3610 <memset>
    if(write(fd, buf, 600) != 600){
    2357:	83 c4 0c             	add    $0xc,%esp
    235a:	68 58 02 00 00       	push   $0x258
    235f:	68 60 83 00 00       	push   $0x8360
    2364:	56                   	push   %esi
    2365:	e8 19 14 00 00       	call   3783 <write>
    236a:	83 c4 10             	add    $0x10,%esp
    236d:	3d 58 02 00 00       	cmp    $0x258,%eax
    2372:	0f 85 9c 00 00 00    	jne    2414 <bigfile+0x115>
  for(i = 0; i < 20; i++){
    2378:	83 c3 01             	add    $0x1,%ebx
    237b:	83 fb 14             	cmp    $0x14,%ebx
    237e:	75 c4                	jne    2344 <bigfile+0x45>
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2380:	83 ec 0c             	sub    $0xc,%esp
    2383:	56                   	push   %esi
    2384:	e8 02 14 00 00       	call   378b <close>

  fd = open("bigfile", 0);
    2389:	83 c4 08             	add    $0x8,%esp
    238c:	6a 00                	push   $0x0
    238e:	68 6c 46 00 00       	push   $0x466c
    2393:	e8 0b 14 00 00       	call   37a3 <open>
    2398:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    239a:	83 c4 10             	add    $0x10,%esp
    239d:	85 c0                	test   %eax,%eax
    239f:	0f 88 83 00 00 00    	js     2428 <bigfile+0x129>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    23a5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    23aa:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    23af:	83 ec 04             	sub    $0x4,%esp
    23b2:	68 2c 01 00 00       	push   $0x12c
    23b7:	68 60 83 00 00       	push   $0x8360
    23bc:	57                   	push   %edi
    23bd:	e8 b9 13 00 00       	call   377b <read>
    if(cc < 0){
    23c2:	83 c4 10             	add    $0x10,%esp
    23c5:	85 c0                	test   %eax,%eax
    23c7:	78 73                	js     243c <bigfile+0x13d>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    23c9:	0f 84 a9 00 00 00    	je     2478 <bigfile+0x179>
      break;
    if(cc != 300){
    23cf:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    23d4:	75 7a                	jne    2450 <bigfile+0x151>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    23d6:	89 d8                	mov    %ebx,%eax
    23d8:	c1 e8 1f             	shr    $0x1f,%eax
    23db:	01 d8                	add    %ebx,%eax
    23dd:	d1 f8                	sar    %eax
    23df:	0f be 15 60 83 00 00 	movsbl 0x8360,%edx
    23e6:	39 c2                	cmp    %eax,%edx
    23e8:	75 7a                	jne    2464 <bigfile+0x165>
    23ea:	0f be 15 8b 84 00 00 	movsbl 0x848b,%edx
    23f1:	39 d0                	cmp    %edx,%eax
    23f3:	75 6f                	jne    2464 <bigfile+0x165>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    23f5:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    23fb:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    23fe:	eb af                	jmp    23af <bigfile+0xb0>
    printf(1, "cannot create bigfile");
    2400:	83 ec 08             	sub    $0x8,%esp
    2403:	68 5e 46 00 00       	push   $0x465e
    2408:	6a 01                	push   $0x1
    240a:	e8 9c 14 00 00       	call   38ab <printf>
    exit();
    240f:	e8 4f 13 00 00       	call   3763 <exit>
      printf(1, "write bigfile failed\n");
    2414:	83 ec 08             	sub    $0x8,%esp
    2417:	68 74 46 00 00       	push   $0x4674
    241c:	6a 01                	push   $0x1
    241e:	e8 88 14 00 00       	call   38ab <printf>
      exit();
    2423:	e8 3b 13 00 00       	call   3763 <exit>
    printf(1, "cannot open bigfile\n");
    2428:	83 ec 08             	sub    $0x8,%esp
    242b:	68 8a 46 00 00       	push   $0x468a
    2430:	6a 01                	push   $0x1
    2432:	e8 74 14 00 00       	call   38ab <printf>
    exit();
    2437:	e8 27 13 00 00       	call   3763 <exit>
      printf(1, "read bigfile failed\n");
    243c:	83 ec 08             	sub    $0x8,%esp
    243f:	68 9f 46 00 00       	push   $0x469f
    2444:	6a 01                	push   $0x1
    2446:	e8 60 14 00 00       	call   38ab <printf>
      exit();
    244b:	e8 13 13 00 00       	call   3763 <exit>
      printf(1, "short read bigfile\n");
    2450:	83 ec 08             	sub    $0x8,%esp
    2453:	68 b4 46 00 00       	push   $0x46b4
    2458:	6a 01                	push   $0x1
    245a:	e8 4c 14 00 00       	call   38ab <printf>
      exit();
    245f:	e8 ff 12 00 00       	call   3763 <exit>
      printf(1, "read bigfile wrong data\n");
    2464:	83 ec 08             	sub    $0x8,%esp
    2467:	68 c8 46 00 00       	push   $0x46c8
    246c:	6a 01                	push   $0x1
    246e:	e8 38 14 00 00       	call   38ab <printf>
      exit();
    2473:	e8 eb 12 00 00       	call   3763 <exit>
  }
  close(fd);
    2478:	83 ec 0c             	sub    $0xc,%esp
    247b:	57                   	push   %edi
    247c:	e8 0a 13 00 00       	call   378b <close>
  if(total != 20*600){
    2481:	83 c4 10             	add    $0x10,%esp
    2484:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    248a:	75 27                	jne    24b3 <bigfile+0x1b4>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    248c:	83 ec 0c             	sub    $0xc,%esp
    248f:	68 6c 46 00 00       	push   $0x466c
    2494:	e8 1a 13 00 00       	call   37b3 <unlink>

  printf(1, "bigfile test ok\n");
    2499:	83 c4 08             	add    $0x8,%esp
    249c:	68 fb 46 00 00       	push   $0x46fb
    24a1:	6a 01                	push   $0x1
    24a3:	e8 03 14 00 00       	call   38ab <printf>
}
    24a8:	83 c4 10             	add    $0x10,%esp
    24ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
    24ae:	5b                   	pop    %ebx
    24af:	5e                   	pop    %esi
    24b0:	5f                   	pop    %edi
    24b1:	5d                   	pop    %ebp
    24b2:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    24b3:	83 ec 08             	sub    $0x8,%esp
    24b6:	68 e1 46 00 00       	push   $0x46e1
    24bb:	6a 01                	push   $0x1
    24bd:	e8 e9 13 00 00       	call   38ab <printf>
    exit();
    24c2:	e8 9c 12 00 00       	call   3763 <exit>

000024c7 <fourteen>:

void
fourteen(void)
{
    24c7:	55                   	push   %ebp
    24c8:	89 e5                	mov    %esp,%ebp
    24ca:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    24cd:	68 0c 47 00 00       	push   $0x470c
    24d2:	6a 01                	push   $0x1
    24d4:	e8 d2 13 00 00       	call   38ab <printf>

  if(mkdir("12345678901234") != 0){
    24d9:	c7 04 24 47 47 00 00 	movl   $0x4747,(%esp)
    24e0:	e8 e6 12 00 00       	call   37cb <mkdir>
    24e5:	83 c4 10             	add    $0x10,%esp
    24e8:	85 c0                	test   %eax,%eax
    24ea:	0f 85 9c 00 00 00    	jne    258c <fourteen+0xc5>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    24f0:	83 ec 0c             	sub    $0xc,%esp
    24f3:	68 04 4f 00 00       	push   $0x4f04
    24f8:	e8 ce 12 00 00       	call   37cb <mkdir>
    24fd:	83 c4 10             	add    $0x10,%esp
    2500:	85 c0                	test   %eax,%eax
    2502:	0f 85 98 00 00 00    	jne    25a0 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2508:	83 ec 08             	sub    $0x8,%esp
    250b:	68 00 02 00 00       	push   $0x200
    2510:	68 54 4f 00 00       	push   $0x4f54
    2515:	e8 89 12 00 00       	call   37a3 <open>
  if(fd < 0){
    251a:	83 c4 10             	add    $0x10,%esp
    251d:	85 c0                	test   %eax,%eax
    251f:	0f 88 8f 00 00 00    	js     25b4 <fourteen+0xed>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    2525:	83 ec 0c             	sub    $0xc,%esp
    2528:	50                   	push   %eax
    2529:	e8 5d 12 00 00       	call   378b <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    252e:	83 c4 08             	add    $0x8,%esp
    2531:	6a 00                	push   $0x0
    2533:	68 c4 4f 00 00       	push   $0x4fc4
    2538:	e8 66 12 00 00       	call   37a3 <open>
  if(fd < 0){
    253d:	83 c4 10             	add    $0x10,%esp
    2540:	85 c0                	test   %eax,%eax
    2542:	0f 88 80 00 00 00    	js     25c8 <fourteen+0x101>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    2548:	83 ec 0c             	sub    $0xc,%esp
    254b:	50                   	push   %eax
    254c:	e8 3a 12 00 00       	call   378b <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2551:	c7 04 24 38 47 00 00 	movl   $0x4738,(%esp)
    2558:	e8 6e 12 00 00       	call   37cb <mkdir>
    255d:	83 c4 10             	add    $0x10,%esp
    2560:	85 c0                	test   %eax,%eax
    2562:	74 78                	je     25dc <fourteen+0x115>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2564:	83 ec 0c             	sub    $0xc,%esp
    2567:	68 60 50 00 00       	push   $0x5060
    256c:	e8 5a 12 00 00       	call   37cb <mkdir>
    2571:	83 c4 10             	add    $0x10,%esp
    2574:	85 c0                	test   %eax,%eax
    2576:	74 78                	je     25f0 <fourteen+0x129>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    2578:	83 ec 08             	sub    $0x8,%esp
    257b:	68 56 47 00 00       	push   $0x4756
    2580:	6a 01                	push   $0x1
    2582:	e8 24 13 00 00       	call   38ab <printf>
}
    2587:	83 c4 10             	add    $0x10,%esp
    258a:	c9                   	leave  
    258b:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    258c:	83 ec 08             	sub    $0x8,%esp
    258f:	68 1b 47 00 00       	push   $0x471b
    2594:	6a 01                	push   $0x1
    2596:	e8 10 13 00 00       	call   38ab <printf>
    exit();
    259b:	e8 c3 11 00 00       	call   3763 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    25a0:	83 ec 08             	sub    $0x8,%esp
    25a3:	68 24 4f 00 00       	push   $0x4f24
    25a8:	6a 01                	push   $0x1
    25aa:	e8 fc 12 00 00       	call   38ab <printf>
    exit();
    25af:	e8 af 11 00 00       	call   3763 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    25b4:	83 ec 08             	sub    $0x8,%esp
    25b7:	68 84 4f 00 00       	push   $0x4f84
    25bc:	6a 01                	push   $0x1
    25be:	e8 e8 12 00 00       	call   38ab <printf>
    exit();
    25c3:	e8 9b 11 00 00       	call   3763 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    25c8:	83 ec 08             	sub    $0x8,%esp
    25cb:	68 f4 4f 00 00       	push   $0x4ff4
    25d0:	6a 01                	push   $0x1
    25d2:	e8 d4 12 00 00       	call   38ab <printf>
    exit();
    25d7:	e8 87 11 00 00       	call   3763 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    25dc:	83 ec 08             	sub    $0x8,%esp
    25df:	68 30 50 00 00       	push   $0x5030
    25e4:	6a 01                	push   $0x1
    25e6:	e8 c0 12 00 00       	call   38ab <printf>
    exit();
    25eb:	e8 73 11 00 00       	call   3763 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    25f0:	83 ec 08             	sub    $0x8,%esp
    25f3:	68 80 50 00 00       	push   $0x5080
    25f8:	6a 01                	push   $0x1
    25fa:	e8 ac 12 00 00       	call   38ab <printf>
    exit();
    25ff:	e8 5f 11 00 00       	call   3763 <exit>

00002604 <rmdot>:

void
rmdot(void)
{
    2604:	55                   	push   %ebp
    2605:	89 e5                	mov    %esp,%ebp
    2607:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    260a:	68 63 47 00 00       	push   $0x4763
    260f:	6a 01                	push   $0x1
    2611:	e8 95 12 00 00       	call   38ab <printf>
  if(mkdir("dots") != 0){
    2616:	c7 04 24 6f 47 00 00 	movl   $0x476f,(%esp)
    261d:	e8 a9 11 00 00       	call   37cb <mkdir>
    2622:	83 c4 10             	add    $0x10,%esp
    2625:	85 c0                	test   %eax,%eax
    2627:	0f 85 bc 00 00 00    	jne    26e9 <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    262d:	83 ec 0c             	sub    $0xc,%esp
    2630:	68 6f 47 00 00       	push   $0x476f
    2635:	e8 99 11 00 00       	call   37d3 <chdir>
    263a:	83 c4 10             	add    $0x10,%esp
    263d:	85 c0                	test   %eax,%eax
    263f:	0f 85 b8 00 00 00    	jne    26fd <rmdot+0xf9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2645:	83 ec 0c             	sub    $0xc,%esp
    2648:	68 1a 44 00 00       	push   $0x441a
    264d:	e8 61 11 00 00       	call   37b3 <unlink>
    2652:	83 c4 10             	add    $0x10,%esp
    2655:	85 c0                	test   %eax,%eax
    2657:	0f 84 b4 00 00 00    	je     2711 <rmdot+0x10d>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    265d:	83 ec 0c             	sub    $0xc,%esp
    2660:	68 19 44 00 00       	push   $0x4419
    2665:	e8 49 11 00 00       	call   37b3 <unlink>
    266a:	83 c4 10             	add    $0x10,%esp
    266d:	85 c0                	test   %eax,%eax
    266f:	0f 84 b0 00 00 00    	je     2725 <rmdot+0x121>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    2675:	83 ec 0c             	sub    $0xc,%esp
    2678:	68 ed 3b 00 00       	push   $0x3bed
    267d:	e8 51 11 00 00       	call   37d3 <chdir>
    2682:	83 c4 10             	add    $0x10,%esp
    2685:	85 c0                	test   %eax,%eax
    2687:	0f 85 ac 00 00 00    	jne    2739 <rmdot+0x135>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    268d:	83 ec 0c             	sub    $0xc,%esp
    2690:	68 b7 47 00 00       	push   $0x47b7
    2695:	e8 19 11 00 00       	call   37b3 <unlink>
    269a:	83 c4 10             	add    $0x10,%esp
    269d:	85 c0                	test   %eax,%eax
    269f:	0f 84 a8 00 00 00    	je     274d <rmdot+0x149>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    26a5:	83 ec 0c             	sub    $0xc,%esp
    26a8:	68 d5 47 00 00       	push   $0x47d5
    26ad:	e8 01 11 00 00       	call   37b3 <unlink>
    26b2:	83 c4 10             	add    $0x10,%esp
    26b5:	85 c0                	test   %eax,%eax
    26b7:	0f 84 a4 00 00 00    	je     2761 <rmdot+0x15d>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    26bd:	83 ec 0c             	sub    $0xc,%esp
    26c0:	68 6f 47 00 00       	push   $0x476f
    26c5:	e8 e9 10 00 00       	call   37b3 <unlink>
    26ca:	83 c4 10             	add    $0x10,%esp
    26cd:	85 c0                	test   %eax,%eax
    26cf:	0f 85 a0 00 00 00    	jne    2775 <rmdot+0x171>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    26d5:	83 ec 08             	sub    $0x8,%esp
    26d8:	68 0a 48 00 00       	push   $0x480a
    26dd:	6a 01                	push   $0x1
    26df:	e8 c7 11 00 00       	call   38ab <printf>
}
    26e4:	83 c4 10             	add    $0x10,%esp
    26e7:	c9                   	leave  
    26e8:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    26e9:	83 ec 08             	sub    $0x8,%esp
    26ec:	68 74 47 00 00       	push   $0x4774
    26f1:	6a 01                	push   $0x1
    26f3:	e8 b3 11 00 00       	call   38ab <printf>
    exit();
    26f8:	e8 66 10 00 00       	call   3763 <exit>
    printf(1, "chdir dots failed\n");
    26fd:	83 ec 08             	sub    $0x8,%esp
    2700:	68 87 47 00 00       	push   $0x4787
    2705:	6a 01                	push   $0x1
    2707:	e8 9f 11 00 00       	call   38ab <printf>
    exit();
    270c:	e8 52 10 00 00       	call   3763 <exit>
    printf(1, "rm . worked!\n");
    2711:	83 ec 08             	sub    $0x8,%esp
    2714:	68 9a 47 00 00       	push   $0x479a
    2719:	6a 01                	push   $0x1
    271b:	e8 8b 11 00 00       	call   38ab <printf>
    exit();
    2720:	e8 3e 10 00 00       	call   3763 <exit>
    printf(1, "rm .. worked!\n");
    2725:	83 ec 08             	sub    $0x8,%esp
    2728:	68 a8 47 00 00       	push   $0x47a8
    272d:	6a 01                	push   $0x1
    272f:	e8 77 11 00 00       	call   38ab <printf>
    exit();
    2734:	e8 2a 10 00 00       	call   3763 <exit>
    printf(1, "chdir / failed\n");
    2739:	83 ec 08             	sub    $0x8,%esp
    273c:	68 ef 3b 00 00       	push   $0x3bef
    2741:	6a 01                	push   $0x1
    2743:	e8 63 11 00 00       	call   38ab <printf>
    exit();
    2748:	e8 16 10 00 00       	call   3763 <exit>
    printf(1, "unlink dots/. worked!\n");
    274d:	83 ec 08             	sub    $0x8,%esp
    2750:	68 be 47 00 00       	push   $0x47be
    2755:	6a 01                	push   $0x1
    2757:	e8 4f 11 00 00       	call   38ab <printf>
    exit();
    275c:	e8 02 10 00 00       	call   3763 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2761:	83 ec 08             	sub    $0x8,%esp
    2764:	68 dd 47 00 00       	push   $0x47dd
    2769:	6a 01                	push   $0x1
    276b:	e8 3b 11 00 00       	call   38ab <printf>
    exit();
    2770:	e8 ee 0f 00 00       	call   3763 <exit>
    printf(1, "unlink dots failed!\n");
    2775:	83 ec 08             	sub    $0x8,%esp
    2778:	68 f5 47 00 00       	push   $0x47f5
    277d:	6a 01                	push   $0x1
    277f:	e8 27 11 00 00       	call   38ab <printf>
    exit();
    2784:	e8 da 0f 00 00       	call   3763 <exit>

00002789 <dirfile>:

void
dirfile(void)
{
    2789:	55                   	push   %ebp
    278a:	89 e5                	mov    %esp,%ebp
    278c:	53                   	push   %ebx
    278d:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2790:	68 14 48 00 00       	push   $0x4814
    2795:	6a 01                	push   $0x1
    2797:	e8 0f 11 00 00       	call   38ab <printf>

  fd = open("dirfile", O_CREATE);
    279c:	83 c4 08             	add    $0x8,%esp
    279f:	68 00 02 00 00       	push   $0x200
    27a4:	68 21 48 00 00       	push   $0x4821
    27a9:	e8 f5 0f 00 00       	call   37a3 <open>
  if(fd < 0){
    27ae:	83 c4 10             	add    $0x10,%esp
    27b1:	85 c0                	test   %eax,%eax
    27b3:	0f 88 22 01 00 00    	js     28db <dirfile+0x152>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    27b9:	83 ec 0c             	sub    $0xc,%esp
    27bc:	50                   	push   %eax
    27bd:	e8 c9 0f 00 00       	call   378b <close>
  if(chdir("dirfile") == 0){
    27c2:	c7 04 24 21 48 00 00 	movl   $0x4821,(%esp)
    27c9:	e8 05 10 00 00       	call   37d3 <chdir>
    27ce:	83 c4 10             	add    $0x10,%esp
    27d1:	85 c0                	test   %eax,%eax
    27d3:	0f 84 16 01 00 00    	je     28ef <dirfile+0x166>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    27d9:	83 ec 08             	sub    $0x8,%esp
    27dc:	6a 00                	push   $0x0
    27de:	68 5a 48 00 00       	push   $0x485a
    27e3:	e8 bb 0f 00 00       	call   37a3 <open>
  if(fd >= 0){
    27e8:	83 c4 10             	add    $0x10,%esp
    27eb:	85 c0                	test   %eax,%eax
    27ed:	0f 89 10 01 00 00    	jns    2903 <dirfile+0x17a>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    27f3:	83 ec 08             	sub    $0x8,%esp
    27f6:	68 00 02 00 00       	push   $0x200
    27fb:	68 5a 48 00 00       	push   $0x485a
    2800:	e8 9e 0f 00 00       	call   37a3 <open>
  if(fd >= 0){
    2805:	83 c4 10             	add    $0x10,%esp
    2808:	85 c0                	test   %eax,%eax
    280a:	0f 89 07 01 00 00    	jns    2917 <dirfile+0x18e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2810:	83 ec 0c             	sub    $0xc,%esp
    2813:	68 5a 48 00 00       	push   $0x485a
    2818:	e8 ae 0f 00 00       	call   37cb <mkdir>
    281d:	83 c4 10             	add    $0x10,%esp
    2820:	85 c0                	test   %eax,%eax
    2822:	0f 84 03 01 00 00    	je     292b <dirfile+0x1a2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    2828:	83 ec 0c             	sub    $0xc,%esp
    282b:	68 5a 48 00 00       	push   $0x485a
    2830:	e8 7e 0f 00 00       	call   37b3 <unlink>
    2835:	83 c4 10             	add    $0x10,%esp
    2838:	85 c0                	test   %eax,%eax
    283a:	0f 84 ff 00 00 00    	je     293f <dirfile+0x1b6>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2840:	83 ec 08             	sub    $0x8,%esp
    2843:	68 5a 48 00 00       	push   $0x485a
    2848:	68 be 48 00 00       	push   $0x48be
    284d:	e8 71 0f 00 00       	call   37c3 <link>
    2852:	83 c4 10             	add    $0x10,%esp
    2855:	85 c0                	test   %eax,%eax
    2857:	0f 84 f6 00 00 00    	je     2953 <dirfile+0x1ca>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    285d:	83 ec 0c             	sub    $0xc,%esp
    2860:	68 21 48 00 00       	push   $0x4821
    2865:	e8 49 0f 00 00       	call   37b3 <unlink>
    286a:	83 c4 10             	add    $0x10,%esp
    286d:	85 c0                	test   %eax,%eax
    286f:	0f 85 f2 00 00 00    	jne    2967 <dirfile+0x1de>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2875:	83 ec 08             	sub    $0x8,%esp
    2878:	6a 02                	push   $0x2
    287a:	68 1a 44 00 00       	push   $0x441a
    287f:	e8 1f 0f 00 00       	call   37a3 <open>
  if(fd >= 0){
    2884:	83 c4 10             	add    $0x10,%esp
    2887:	85 c0                	test   %eax,%eax
    2889:	0f 89 ec 00 00 00    	jns    297b <dirfile+0x1f2>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    288f:	83 ec 08             	sub    $0x8,%esp
    2892:	6a 00                	push   $0x0
    2894:	68 1a 44 00 00       	push   $0x441a
    2899:	e8 05 0f 00 00       	call   37a3 <open>
    289e:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    28a0:	83 c4 0c             	add    $0xc,%esp
    28a3:	6a 01                	push   $0x1
    28a5:	68 fd 44 00 00       	push   $0x44fd
    28aa:	50                   	push   %eax
    28ab:	e8 d3 0e 00 00       	call   3783 <write>
    28b0:	83 c4 10             	add    $0x10,%esp
    28b3:	85 c0                	test   %eax,%eax
    28b5:	0f 8f d4 00 00 00    	jg     298f <dirfile+0x206>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    28bb:	83 ec 0c             	sub    $0xc,%esp
    28be:	53                   	push   %ebx
    28bf:	e8 c7 0e 00 00       	call   378b <close>

  printf(1, "dir vs file OK\n");
    28c4:	83 c4 08             	add    $0x8,%esp
    28c7:	68 f1 48 00 00       	push   $0x48f1
    28cc:	6a 01                	push   $0x1
    28ce:	e8 d8 0f 00 00       	call   38ab <printf>
}
    28d3:	83 c4 10             	add    $0x10,%esp
    28d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    28d9:	c9                   	leave  
    28da:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    28db:	83 ec 08             	sub    $0x8,%esp
    28de:	68 29 48 00 00       	push   $0x4829
    28e3:	6a 01                	push   $0x1
    28e5:	e8 c1 0f 00 00       	call   38ab <printf>
    exit();
    28ea:	e8 74 0e 00 00       	call   3763 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    28ef:	83 ec 08             	sub    $0x8,%esp
    28f2:	68 40 48 00 00       	push   $0x4840
    28f7:	6a 01                	push   $0x1
    28f9:	e8 ad 0f 00 00       	call   38ab <printf>
    exit();
    28fe:	e8 60 0e 00 00       	call   3763 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2903:	83 ec 08             	sub    $0x8,%esp
    2906:	68 65 48 00 00       	push   $0x4865
    290b:	6a 01                	push   $0x1
    290d:	e8 99 0f 00 00       	call   38ab <printf>
    exit();
    2912:	e8 4c 0e 00 00       	call   3763 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2917:	83 ec 08             	sub    $0x8,%esp
    291a:	68 65 48 00 00       	push   $0x4865
    291f:	6a 01                	push   $0x1
    2921:	e8 85 0f 00 00       	call   38ab <printf>
    exit();
    2926:	e8 38 0e 00 00       	call   3763 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    292b:	83 ec 08             	sub    $0x8,%esp
    292e:	68 83 48 00 00       	push   $0x4883
    2933:	6a 01                	push   $0x1
    2935:	e8 71 0f 00 00       	call   38ab <printf>
    exit();
    293a:	e8 24 0e 00 00       	call   3763 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    293f:	83 ec 08             	sub    $0x8,%esp
    2942:	68 a0 48 00 00       	push   $0x48a0
    2947:	6a 01                	push   $0x1
    2949:	e8 5d 0f 00 00       	call   38ab <printf>
    exit();
    294e:	e8 10 0e 00 00       	call   3763 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2953:	83 ec 08             	sub    $0x8,%esp
    2956:	68 b4 50 00 00       	push   $0x50b4
    295b:	6a 01                	push   $0x1
    295d:	e8 49 0f 00 00       	call   38ab <printf>
    exit();
    2962:	e8 fc 0d 00 00       	call   3763 <exit>
    printf(1, "unlink dirfile failed!\n");
    2967:	83 ec 08             	sub    $0x8,%esp
    296a:	68 c5 48 00 00       	push   $0x48c5
    296f:	6a 01                	push   $0x1
    2971:	e8 35 0f 00 00       	call   38ab <printf>
    exit();
    2976:	e8 e8 0d 00 00       	call   3763 <exit>
    printf(1, "open . for writing succeeded!\n");
    297b:	83 ec 08             	sub    $0x8,%esp
    297e:	68 d4 50 00 00       	push   $0x50d4
    2983:	6a 01                	push   $0x1
    2985:	e8 21 0f 00 00       	call   38ab <printf>
    exit();
    298a:	e8 d4 0d 00 00       	call   3763 <exit>
    printf(1, "write . succeeded!\n");
    298f:	83 ec 08             	sub    $0x8,%esp
    2992:	68 dd 48 00 00       	push   $0x48dd
    2997:	6a 01                	push   $0x1
    2999:	e8 0d 0f 00 00       	call   38ab <printf>
    exit();
    299e:	e8 c0 0d 00 00       	call   3763 <exit>

000029a3 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    29a3:	55                   	push   %ebp
    29a4:	89 e5                	mov    %esp,%ebp
    29a6:	53                   	push   %ebx
    29a7:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    29aa:	68 01 49 00 00       	push   $0x4901
    29af:	6a 01                	push   $0x1
    29b1:	e8 f5 0e 00 00       	call   38ab <printf>
    29b6:	83 c4 10             	add    $0x10,%esp
    29b9:	bb 33 00 00 00       	mov    $0x33,%ebx
    29be:	eb 4f                	jmp    2a0f <iref+0x6c>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    29c0:	83 ec 08             	sub    $0x8,%esp
    29c3:	68 18 49 00 00       	push   $0x4918
    29c8:	6a 01                	push   $0x1
    29ca:	e8 dc 0e 00 00       	call   38ab <printf>
      exit();
    29cf:	e8 8f 0d 00 00       	call   3763 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    29d4:	83 ec 08             	sub    $0x8,%esp
    29d7:	68 2c 49 00 00       	push   $0x492c
    29dc:	6a 01                	push   $0x1
    29de:	e8 c8 0e 00 00       	call   38ab <printf>
      exit();
    29e3:	e8 7b 0d 00 00       	call   3763 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    29e8:	83 ec 0c             	sub    $0xc,%esp
    29eb:	50                   	push   %eax
    29ec:	e8 9a 0d 00 00       	call   378b <close>
    29f1:	83 c4 10             	add    $0x10,%esp
    29f4:	eb 7d                	jmp    2a73 <iref+0xd0>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    29f6:	83 ec 0c             	sub    $0xc,%esp
    29f9:	68 fc 44 00 00       	push   $0x44fc
    29fe:	e8 b0 0d 00 00       	call   37b3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2a03:	83 c4 10             	add    $0x10,%esp
    2a06:	83 eb 01             	sub    $0x1,%ebx
    2a09:	0f 84 92 00 00 00    	je     2aa1 <iref+0xfe>
    if(mkdir("irefd") != 0){
    2a0f:	83 ec 0c             	sub    $0xc,%esp
    2a12:	68 12 49 00 00       	push   $0x4912
    2a17:	e8 af 0d 00 00       	call   37cb <mkdir>
    2a1c:	83 c4 10             	add    $0x10,%esp
    2a1f:	85 c0                	test   %eax,%eax
    2a21:	75 9d                	jne    29c0 <iref+0x1d>
    if(chdir("irefd") != 0){
    2a23:	83 ec 0c             	sub    $0xc,%esp
    2a26:	68 12 49 00 00       	push   $0x4912
    2a2b:	e8 a3 0d 00 00       	call   37d3 <chdir>
    2a30:	83 c4 10             	add    $0x10,%esp
    2a33:	85 c0                	test   %eax,%eax
    2a35:	75 9d                	jne    29d4 <iref+0x31>
    mkdir("");
    2a37:	83 ec 0c             	sub    $0xc,%esp
    2a3a:	68 c7 3f 00 00       	push   $0x3fc7
    2a3f:	e8 87 0d 00 00       	call   37cb <mkdir>
    link("README", "");
    2a44:	83 c4 08             	add    $0x8,%esp
    2a47:	68 c7 3f 00 00       	push   $0x3fc7
    2a4c:	68 be 48 00 00       	push   $0x48be
    2a51:	e8 6d 0d 00 00       	call   37c3 <link>
    fd = open("", O_CREATE);
    2a56:	83 c4 08             	add    $0x8,%esp
    2a59:	68 00 02 00 00       	push   $0x200
    2a5e:	68 c7 3f 00 00       	push   $0x3fc7
    2a63:	e8 3b 0d 00 00       	call   37a3 <open>
    if(fd >= 0)
    2a68:	83 c4 10             	add    $0x10,%esp
    2a6b:	85 c0                	test   %eax,%eax
    2a6d:	0f 89 75 ff ff ff    	jns    29e8 <iref+0x45>
    fd = open("xx", O_CREATE);
    2a73:	83 ec 08             	sub    $0x8,%esp
    2a76:	68 00 02 00 00       	push   $0x200
    2a7b:	68 fc 44 00 00       	push   $0x44fc
    2a80:	e8 1e 0d 00 00       	call   37a3 <open>
    if(fd >= 0)
    2a85:	83 c4 10             	add    $0x10,%esp
    2a88:	85 c0                	test   %eax,%eax
    2a8a:	0f 88 66 ff ff ff    	js     29f6 <iref+0x53>
      close(fd);
    2a90:	83 ec 0c             	sub    $0xc,%esp
    2a93:	50                   	push   %eax
    2a94:	e8 f2 0c 00 00       	call   378b <close>
    2a99:	83 c4 10             	add    $0x10,%esp
    2a9c:	e9 55 ff ff ff       	jmp    29f6 <iref+0x53>
  }

  chdir("/");
    2aa1:	83 ec 0c             	sub    $0xc,%esp
    2aa4:	68 ed 3b 00 00       	push   $0x3bed
    2aa9:	e8 25 0d 00 00       	call   37d3 <chdir>
  printf(1, "empty file name OK\n");
    2aae:	83 c4 08             	add    $0x8,%esp
    2ab1:	68 40 49 00 00       	push   $0x4940
    2ab6:	6a 01                	push   $0x1
    2ab8:	e8 ee 0d 00 00       	call   38ab <printf>
}
    2abd:	83 c4 10             	add    $0x10,%esp
    2ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2ac3:	c9                   	leave  
    2ac4:	c3                   	ret    

00002ac5 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2ac5:	55                   	push   %ebp
    2ac6:	89 e5                	mov    %esp,%ebp
    2ac8:	53                   	push   %ebx
    2ac9:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2acc:	68 54 49 00 00       	push   $0x4954
    2ad1:	6a 01                	push   $0x1
    2ad3:	e8 d3 0d 00 00       	call   38ab <printf>
    2ad8:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2adb:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    2ae0:	e8 76 0c 00 00       	call   375b <fork>
    if(pid < 0)
    2ae5:	85 c0                	test   %eax,%eax
    2ae7:	78 26                	js     2b0f <forktest+0x4a>
      break;
    if(pid == 0)
    2ae9:	74 1f                	je     2b0a <forktest+0x45>
  for(n=0; n<1000; n++){
    2aeb:	83 c3 01             	add    $0x1,%ebx
    2aee:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2af4:	75 ea                	jne    2ae0 <forktest+0x1b>
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    2af6:	83 ec 08             	sub    $0x8,%esp
    2af9:	68 f4 50 00 00       	push   $0x50f4
    2afe:	6a 01                	push   $0x1
    2b00:	e8 a6 0d 00 00       	call   38ab <printf>
    exit();
    2b05:	e8 59 0c 00 00       	call   3763 <exit>
      exit();
    2b0a:	e8 54 0c 00 00       	call   3763 <exit>
  if(n == 1000){
    2b0f:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b15:	74 df                	je     2af6 <forktest+0x31>
  }

  for(; n > 0; n--){
    2b17:	85 db                	test   %ebx,%ebx
    2b19:	7e 0e                	jle    2b29 <forktest+0x64>
    if(wait() < 0){
    2b1b:	e8 4b 0c 00 00       	call   376b <wait>
    2b20:	85 c0                	test   %eax,%eax
    2b22:	78 26                	js     2b4a <forktest+0x85>
  for(; n > 0; n--){
    2b24:	83 eb 01             	sub    $0x1,%ebx
    2b27:	75 f2                	jne    2b1b <forktest+0x56>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    2b29:	e8 3d 0c 00 00       	call   376b <wait>
    2b2e:	83 f8 ff             	cmp    $0xffffffff,%eax
    2b31:	75 2b                	jne    2b5e <forktest+0x99>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    2b33:	83 ec 08             	sub    $0x8,%esp
    2b36:	68 86 49 00 00       	push   $0x4986
    2b3b:	6a 01                	push   $0x1
    2b3d:	e8 69 0d 00 00       	call   38ab <printf>
}
    2b42:	83 c4 10             	add    $0x10,%esp
    2b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b48:	c9                   	leave  
    2b49:	c3                   	ret    
      printf(1, "wait stopped early\n");
    2b4a:	83 ec 08             	sub    $0x8,%esp
    2b4d:	68 5f 49 00 00       	push   $0x495f
    2b52:	6a 01                	push   $0x1
    2b54:	e8 52 0d 00 00       	call   38ab <printf>
      exit();
    2b59:	e8 05 0c 00 00       	call   3763 <exit>
    printf(1, "wait got too many\n");
    2b5e:	83 ec 08             	sub    $0x8,%esp
    2b61:	68 73 49 00 00       	push   $0x4973
    2b66:	6a 01                	push   $0x1
    2b68:	e8 3e 0d 00 00       	call   38ab <printf>
    exit();
    2b6d:	e8 f1 0b 00 00       	call   3763 <exit>

00002b72 <sbrktest>:

void
sbrktest(void)
{
    2b72:	55                   	push   %ebp
    2b73:	89 e5                	mov    %esp,%ebp
    2b75:	57                   	push   %edi
    2b76:	56                   	push   %esi
    2b77:	53                   	push   %ebx
    2b78:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2b7b:	68 94 49 00 00       	push   $0x4994
    2b80:	ff 35 10 5c 00 00    	push   0x5c10
    2b86:	e8 20 0d 00 00       	call   38ab <printf>
  oldbrk = sbrk(0);
    2b8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b92:	e8 54 0c 00 00       	call   37eb <sbrk>
    2b97:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2b9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ba1:	e8 45 0c 00 00       	call   37eb <sbrk>
    2ba6:	89 c3                	mov    %eax,%ebx
    2ba8:	83 c4 10             	add    $0x10,%esp
  int i;
  for(i = 0; i < 5000; i++){
    2bab:	be 00 00 00 00       	mov    $0x0,%esi
    2bb0:	eb 02                	jmp    2bb4 <sbrktest+0x42>
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    a = b + 1;
    2bb2:	89 c3                	mov    %eax,%ebx
    b = sbrk(1);
    2bb4:	83 ec 0c             	sub    $0xc,%esp
    2bb7:	6a 01                	push   $0x1
    2bb9:	e8 2d 0c 00 00       	call   37eb <sbrk>
    if(b != a){
    2bbe:	83 c4 10             	add    $0x10,%esp
    2bc1:	39 d8                	cmp    %ebx,%eax
    2bc3:	0f 85 92 01 00 00    	jne    2d5b <sbrktest+0x1e9>
    *b = 1;
    2bc9:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    2bcc:	8d 43 01             	lea    0x1(%ebx),%eax
  for(i = 0; i < 5000; i++){
    2bcf:	83 c6 01             	add    $0x1,%esi
    2bd2:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    2bd8:	75 d8                	jne    2bb2 <sbrktest+0x40>
  }
  pid = fork();
    2bda:	e8 7c 0b 00 00       	call   375b <fork>
    2bdf:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    2be1:	85 c0                	test   %eax,%eax
    2be3:	0f 88 90 01 00 00    	js     2d79 <sbrktest+0x207>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    2be9:	83 ec 0c             	sub    $0xc,%esp
    2bec:	6a 01                	push   $0x1
    2bee:	e8 f8 0b 00 00       	call   37eb <sbrk>
  c = sbrk(1);
    2bf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bfa:	e8 ec 0b 00 00       	call   37eb <sbrk>
  if(c != a + 1){
    2bff:	83 c3 02             	add    $0x2,%ebx
    2c02:	83 c4 10             	add    $0x10,%esp
    2c05:	39 c3                	cmp    %eax,%ebx
    2c07:	0f 85 84 01 00 00    	jne    2d91 <sbrktest+0x21f>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    2c0d:	85 f6                	test   %esi,%esi
    2c0f:	0f 84 94 01 00 00    	je     2da9 <sbrktest+0x237>
    exit();
  wait();
    2c15:	e8 51 0b 00 00       	call   376b <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2c1a:	83 ec 0c             	sub    $0xc,%esp
    2c1d:	6a 00                	push   $0x0
    2c1f:	e8 c7 0b 00 00       	call   37eb <sbrk>
    2c24:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2c26:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2c2b:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    2c2d:	89 04 24             	mov    %eax,(%esp)
    2c30:	e8 b6 0b 00 00       	call   37eb <sbrk>
  if (p != a) {
    2c35:	83 c4 10             	add    $0x10,%esp
    2c38:	39 c3                	cmp    %eax,%ebx
    2c3a:	0f 85 6e 01 00 00    	jne    2dae <sbrktest+0x23c>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2c40:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2c47:	83 ec 0c             	sub    $0xc,%esp
    2c4a:	6a 00                	push   $0x0
    2c4c:	e8 9a 0b 00 00       	call   37eb <sbrk>
    2c51:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2c53:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2c5a:	e8 8c 0b 00 00       	call   37eb <sbrk>
  if(c == (char*)0xffffffff){
    2c5f:	83 c4 10             	add    $0x10,%esp
    2c62:	83 f8 ff             	cmp    $0xffffffff,%eax
    2c65:	0f 84 5b 01 00 00    	je     2dc6 <sbrktest+0x254>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2c6b:	83 ec 0c             	sub    $0xc,%esp
    2c6e:	6a 00                	push   $0x0
    2c70:	e8 76 0b 00 00       	call   37eb <sbrk>
  if(c != a - 4096){
    2c75:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2c7b:	83 c4 10             	add    $0x10,%esp
    2c7e:	39 d0                	cmp    %edx,%eax
    2c80:	0f 85 58 01 00 00    	jne    2dde <sbrktest+0x26c>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2c86:	83 ec 0c             	sub    $0xc,%esp
    2c89:	6a 00                	push   $0x0
    2c8b:	e8 5b 0b 00 00       	call   37eb <sbrk>
    2c90:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2c92:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2c99:	e8 4d 0b 00 00       	call   37eb <sbrk>
    2c9e:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2ca0:	83 c4 10             	add    $0x10,%esp
    2ca3:	39 c3                	cmp    %eax,%ebx
    2ca5:	0f 85 4a 01 00 00    	jne    2df5 <sbrktest+0x283>
    2cab:	83 ec 0c             	sub    $0xc,%esp
    2cae:	6a 00                	push   $0x0
    2cb0:	e8 36 0b 00 00       	call   37eb <sbrk>
    2cb5:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2cbb:	83 c4 10             	add    $0x10,%esp
    2cbe:	39 c2                	cmp    %eax,%edx
    2cc0:	0f 85 2f 01 00 00    	jne    2df5 <sbrktest+0x283>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2cc6:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2ccd:	0f 84 39 01 00 00    	je     2e0c <sbrktest+0x29a>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    2cd3:	83 ec 0c             	sub    $0xc,%esp
    2cd6:	6a 00                	push   $0x0
    2cd8:	e8 0e 0b 00 00       	call   37eb <sbrk>
    2cdd:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2cdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ce6:	e8 00 0b 00 00       	call   37eb <sbrk>
    2ceb:	89 c2                	mov    %eax,%edx
    2ced:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    2cf0:	29 d0                	sub    %edx,%eax
    2cf2:	89 04 24             	mov    %eax,(%esp)
    2cf5:	e8 f1 0a 00 00       	call   37eb <sbrk>
  if(c != a){
    2cfa:	83 c4 10             	add    $0x10,%esp
    2cfd:	39 c3                	cmp    %eax,%ebx
    2cff:	0f 85 1f 01 00 00    	jne    2e24 <sbrktest+0x2b2>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d05:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    ppid = getpid();
    2d0a:	e8 d4 0a 00 00       	call   37e3 <getpid>
    2d0f:	89 c6                	mov    %eax,%esi
    pid = fork();
    2d11:	e8 45 0a 00 00       	call   375b <fork>
    if(pid < 0){
    2d16:	85 c0                	test   %eax,%eax
    2d18:	0f 88 1d 01 00 00    	js     2e3b <sbrktest+0x2c9>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    2d1e:	0f 84 2f 01 00 00    	je     2e53 <sbrktest+0x2e1>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    2d24:	e8 42 0a 00 00       	call   376b <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d29:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2d2f:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    2d35:	75 d3                	jne    2d0a <sbrktest+0x198>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2d37:	83 ec 0c             	sub    $0xc,%esp
    2d3a:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2d3d:	50                   	push   %eax
    2d3e:	e8 30 0a 00 00       	call   3773 <pipe>
    2d43:	83 c4 10             	add    $0x10,%esp
    2d46:	85 c0                	test   %eax,%eax
    2d48:	0f 85 27 01 00 00    	jne    2e75 <sbrktest+0x303>
    2d4e:	8d 5d b8             	lea    -0x48(%ebp),%ebx
    2d51:	8d 7d e0             	lea    -0x20(%ebp),%edi
    2d54:	89 de                	mov    %ebx,%esi
    2d56:	e9 77 01 00 00       	jmp    2ed2 <sbrktest+0x360>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2d5b:	83 ec 0c             	sub    $0xc,%esp
    2d5e:	50                   	push   %eax
    2d5f:	53                   	push   %ebx
    2d60:	56                   	push   %esi
    2d61:	68 9f 49 00 00       	push   $0x499f
    2d66:	ff 35 10 5c 00 00    	push   0x5c10
    2d6c:	e8 3a 0b 00 00       	call   38ab <printf>
      exit();
    2d71:	83 c4 20             	add    $0x20,%esp
    2d74:	e8 ea 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk test fork failed\n");
    2d79:	83 ec 08             	sub    $0x8,%esp
    2d7c:	68 ba 49 00 00       	push   $0x49ba
    2d81:	ff 35 10 5c 00 00    	push   0x5c10
    2d87:	e8 1f 0b 00 00       	call   38ab <printf>
    exit();
    2d8c:	e8 d2 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2d91:	83 ec 08             	sub    $0x8,%esp
    2d94:	68 d1 49 00 00       	push   $0x49d1
    2d99:	ff 35 10 5c 00 00    	push   0x5c10
    2d9f:	e8 07 0b 00 00       	call   38ab <printf>
    exit();
    2da4:	e8 ba 09 00 00       	call   3763 <exit>
    exit();
    2da9:	e8 b5 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2dae:	83 ec 08             	sub    $0x8,%esp
    2db1:	68 18 51 00 00       	push   $0x5118
    2db6:	ff 35 10 5c 00 00    	push   0x5c10
    2dbc:	e8 ea 0a 00 00       	call   38ab <printf>
    exit();
    2dc1:	e8 9d 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2dc6:	83 ec 08             	sub    $0x8,%esp
    2dc9:	68 ed 49 00 00       	push   $0x49ed
    2dce:	ff 35 10 5c 00 00    	push   0x5c10
    2dd4:	e8 d2 0a 00 00       	call   38ab <printf>
    exit();
    2dd9:	e8 85 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2dde:	50                   	push   %eax
    2ddf:	53                   	push   %ebx
    2de0:	68 58 51 00 00       	push   $0x5158
    2de5:	ff 35 10 5c 00 00    	push   0x5c10
    2deb:	e8 bb 0a 00 00       	call   38ab <printf>
    exit();
    2df0:	e8 6e 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2df5:	56                   	push   %esi
    2df6:	53                   	push   %ebx
    2df7:	68 90 51 00 00       	push   $0x5190
    2dfc:	ff 35 10 5c 00 00    	push   0x5c10
    2e02:	e8 a4 0a 00 00       	call   38ab <printf>
    exit();
    2e07:	e8 57 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2e0c:	83 ec 08             	sub    $0x8,%esp
    2e0f:	68 b8 51 00 00       	push   $0x51b8
    2e14:	ff 35 10 5c 00 00    	push   0x5c10
    2e1a:	e8 8c 0a 00 00       	call   38ab <printf>
    exit();
    2e1f:	e8 3f 09 00 00       	call   3763 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e24:	50                   	push   %eax
    2e25:	53                   	push   %ebx
    2e26:	68 e8 51 00 00       	push   $0x51e8
    2e2b:	ff 35 10 5c 00 00    	push   0x5c10
    2e31:	e8 75 0a 00 00       	call   38ab <printf>
    exit();
    2e36:	e8 28 09 00 00       	call   3763 <exit>
      printf(stdout, "fork failed\n");
    2e3b:	83 ec 08             	sub    $0x8,%esp
    2e3e:	68 e5 4a 00 00       	push   $0x4ae5
    2e43:	ff 35 10 5c 00 00    	push   0x5c10
    2e49:	e8 5d 0a 00 00       	call   38ab <printf>
      exit();
    2e4e:	e8 10 09 00 00       	call   3763 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2e53:	0f be 03             	movsbl (%ebx),%eax
    2e56:	50                   	push   %eax
    2e57:	53                   	push   %ebx
    2e58:	68 08 4a 00 00       	push   $0x4a08
    2e5d:	ff 35 10 5c 00 00    	push   0x5c10
    2e63:	e8 43 0a 00 00       	call   38ab <printf>
      kill(ppid);
    2e68:	89 34 24             	mov    %esi,(%esp)
    2e6b:	e8 23 09 00 00       	call   3793 <kill>
      exit();
    2e70:	e8 ee 08 00 00       	call   3763 <exit>
    printf(1, "pipe() failed\n");
    2e75:	83 ec 08             	sub    $0x8,%esp
    2e78:	68 dd 3e 00 00       	push   $0x3edd
    2e7d:	6a 01                	push   $0x1
    2e7f:	e8 27 0a 00 00       	call   38ab <printf>
    exit();
    2e84:	e8 da 08 00 00       	call   3763 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2e89:	83 ec 0c             	sub    $0xc,%esp
    2e8c:	6a 00                	push   $0x0
    2e8e:	e8 58 09 00 00       	call   37eb <sbrk>
    2e93:	89 c2                	mov    %eax,%edx
    2e95:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2e9a:	29 d0                	sub    %edx,%eax
    2e9c:	89 04 24             	mov    %eax,(%esp)
    2e9f:	e8 47 09 00 00       	call   37eb <sbrk>
      write(fds[1], "x", 1);
    2ea4:	83 c4 0c             	add    $0xc,%esp
    2ea7:	6a 01                	push   $0x1
    2ea9:	68 fd 44 00 00       	push   $0x44fd
    2eae:	ff 75 e4             	push   -0x1c(%ebp)
    2eb1:	e8 cd 08 00 00       	call   3783 <write>
    2eb6:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2eb9:	83 ec 0c             	sub    $0xc,%esp
    2ebc:	68 e8 03 00 00       	push   $0x3e8
    2ec1:	e8 2d 09 00 00       	call   37f3 <sleep>
    2ec6:	83 c4 10             	add    $0x10,%esp
    2ec9:	eb ee                	jmp    2eb9 <sbrktest+0x347>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2ecb:	83 c6 04             	add    $0x4,%esi
    2ece:	39 fe                	cmp    %edi,%esi
    2ed0:	74 26                	je     2ef8 <sbrktest+0x386>
    if((pids[i] = fork()) == 0){
    2ed2:	e8 84 08 00 00       	call   375b <fork>
    2ed7:	89 06                	mov    %eax,(%esi)
    2ed9:	85 c0                	test   %eax,%eax
    2edb:	74 ac                	je     2e89 <sbrktest+0x317>
    }
    if(pids[i] != -1)
    2edd:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ee0:	74 e9                	je     2ecb <sbrktest+0x359>
      read(fds[0], &scratch, 1);
    2ee2:	83 ec 04             	sub    $0x4,%esp
    2ee5:	6a 01                	push   $0x1
    2ee7:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2eea:	50                   	push   %eax
    2eeb:	ff 75 e0             	push   -0x20(%ebp)
    2eee:	e8 88 08 00 00       	call   377b <read>
    2ef3:	83 c4 10             	add    $0x10,%esp
    2ef6:	eb d3                	jmp    2ecb <sbrktest+0x359>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2ef8:	83 ec 0c             	sub    $0xc,%esp
    2efb:	68 00 10 00 00       	push   $0x1000
    2f00:	e8 e6 08 00 00       	call   37eb <sbrk>
    2f05:	89 c6                	mov    %eax,%esi
    2f07:	83 c4 10             	add    $0x10,%esp
    2f0a:	eb 07                	jmp    2f13 <sbrktest+0x3a1>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f0c:	83 c3 04             	add    $0x4,%ebx
    2f0f:	39 fb                	cmp    %edi,%ebx
    2f11:	74 1a                	je     2f2d <sbrktest+0x3bb>
    if(pids[i] == -1)
    2f13:	8b 03                	mov    (%ebx),%eax
    2f15:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f18:	74 f2                	je     2f0c <sbrktest+0x39a>
      continue;
    kill(pids[i]);
    2f1a:	83 ec 0c             	sub    $0xc,%esp
    2f1d:	50                   	push   %eax
    2f1e:	e8 70 08 00 00       	call   3793 <kill>
    wait();
    2f23:	e8 43 08 00 00       	call   376b <wait>
    2f28:	83 c4 10             	add    $0x10,%esp
    2f2b:	eb df                	jmp    2f0c <sbrktest+0x39a>
  }
  if(c == (char*)0xffffffff){
    2f2d:	83 fe ff             	cmp    $0xffffffff,%esi
    2f30:	74 30                	je     2f62 <sbrktest+0x3f0>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    2f32:	83 ec 0c             	sub    $0xc,%esp
    2f35:	6a 00                	push   $0x0
    2f37:	e8 af 08 00 00       	call   37eb <sbrk>
    2f3c:	83 c4 10             	add    $0x10,%esp
    2f3f:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    2f42:	72 36                	jb     2f7a <sbrktest+0x408>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    2f44:	83 ec 08             	sub    $0x8,%esp
    2f47:	68 3c 4a 00 00       	push   $0x4a3c
    2f4c:	ff 35 10 5c 00 00    	push   0x5c10
    2f52:	e8 54 09 00 00       	call   38ab <printf>
}
    2f57:	83 c4 10             	add    $0x10,%esp
    2f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2f5d:	5b                   	pop    %ebx
    2f5e:	5e                   	pop    %esi
    2f5f:	5f                   	pop    %edi
    2f60:	5d                   	pop    %ebp
    2f61:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    2f62:	83 ec 08             	sub    $0x8,%esp
    2f65:	68 21 4a 00 00       	push   $0x4a21
    2f6a:	ff 35 10 5c 00 00    	push   0x5c10
    2f70:	e8 36 09 00 00       	call   38ab <printf>
    exit();
    2f75:	e8 e9 07 00 00       	call   3763 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2f7a:	83 ec 0c             	sub    $0xc,%esp
    2f7d:	6a 00                	push   $0x0
    2f7f:	e8 67 08 00 00       	call   37eb <sbrk>
    2f84:	89 c2                	mov    %eax,%edx
    2f86:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    2f89:	29 d0                	sub    %edx,%eax
    2f8b:	89 04 24             	mov    %eax,(%esp)
    2f8e:	e8 58 08 00 00       	call   37eb <sbrk>
    2f93:	83 c4 10             	add    $0x10,%esp
    2f96:	eb ac                	jmp    2f44 <sbrktest+0x3d2>

00002f98 <validateint>:
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    2f98:	c3                   	ret    

00002f99 <validatetest>:

void
validatetest(void)
{
    2f99:	55                   	push   %ebp
    2f9a:	89 e5                	mov    %esp,%ebp
    2f9c:	56                   	push   %esi
    2f9d:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2f9e:	83 ec 08             	sub    $0x8,%esp
    2fa1:	68 4a 4a 00 00       	push   $0x4a4a
    2fa6:	ff 35 10 5c 00 00    	push   0x5c10
    2fac:	e8 fa 08 00 00       	call   38ab <printf>
    2fb1:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    2fb4:	be 00 00 00 00       	mov    $0x0,%esi
    if((pid = fork()) == 0){
    2fb9:	e8 9d 07 00 00       	call   375b <fork>
    2fbe:	89 c3                	mov    %eax,%ebx
    2fc0:	85 c0                	test   %eax,%eax
    2fc2:	74 64                	je     3028 <validatetest+0x8f>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    2fc4:	83 ec 0c             	sub    $0xc,%esp
    2fc7:	6a 00                	push   $0x0
    2fc9:	e8 25 08 00 00       	call   37f3 <sleep>
    sleep(0);
    2fce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fd5:	e8 19 08 00 00       	call   37f3 <sleep>
    kill(pid);
    2fda:	89 1c 24             	mov    %ebx,(%esp)
    2fdd:	e8 b1 07 00 00       	call   3793 <kill>
    wait();
    2fe2:	e8 84 07 00 00       	call   376b <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    2fe7:	83 c4 08             	add    $0x8,%esp
    2fea:	56                   	push   %esi
    2feb:	68 59 4a 00 00       	push   $0x4a59
    2ff0:	e8 ce 07 00 00       	call   37c3 <link>
    2ff5:	83 c4 10             	add    $0x10,%esp
    2ff8:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ffb:	75 30                	jne    302d <validatetest+0x94>
  for(p = 0; p <= (uint)hi; p += 4096){
    2ffd:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3003:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    3009:	75 ae                	jne    2fb9 <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    300b:	83 ec 08             	sub    $0x8,%esp
    300e:	68 7d 4a 00 00       	push   $0x4a7d
    3013:	ff 35 10 5c 00 00    	push   0x5c10
    3019:	e8 8d 08 00 00       	call   38ab <printf>
}
    301e:	83 c4 10             	add    $0x10,%esp
    3021:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3024:	5b                   	pop    %ebx
    3025:	5e                   	pop    %esi
    3026:	5d                   	pop    %ebp
    3027:	c3                   	ret    
      exit();
    3028:	e8 36 07 00 00       	call   3763 <exit>
      printf(stdout, "link should not succeed\n");
    302d:	83 ec 08             	sub    $0x8,%esp
    3030:	68 64 4a 00 00       	push   $0x4a64
    3035:	ff 35 10 5c 00 00    	push   0x5c10
    303b:	e8 6b 08 00 00       	call   38ab <printf>
      exit();
    3040:	e8 1e 07 00 00       	call   3763 <exit>

00003045 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3045:	55                   	push   %ebp
    3046:	89 e5                	mov    %esp,%ebp
    3048:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    304b:	68 8a 4a 00 00       	push   $0x4a8a
    3050:	ff 35 10 5c 00 00    	push   0x5c10
    3056:	e8 50 08 00 00       	call   38ab <printf>
    305b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    305e:	b8 00 00 00 00       	mov    $0x0,%eax
    if(uninit[i] != '\0'){
    3063:	80 b8 40 5c 00 00 00 	cmpb   $0x0,0x5c40(%eax)
    306a:	75 22                	jne    308e <bsstest+0x49>
  for(i = 0; i < sizeof(uninit); i++){
    306c:	83 c0 01             	add    $0x1,%eax
    306f:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3074:	75 ed                	jne    3063 <bsstest+0x1e>
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3076:	83 ec 08             	sub    $0x8,%esp
    3079:	68 a5 4a 00 00       	push   $0x4aa5
    307e:	ff 35 10 5c 00 00    	push   0x5c10
    3084:	e8 22 08 00 00       	call   38ab <printf>
}
    3089:	83 c4 10             	add    $0x10,%esp
    308c:	c9                   	leave  
    308d:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    308e:	83 ec 08             	sub    $0x8,%esp
    3091:	68 94 4a 00 00       	push   $0x4a94
    3096:	ff 35 10 5c 00 00    	push   0x5c10
    309c:	e8 0a 08 00 00       	call   38ab <printf>
      exit();
    30a1:	e8 bd 06 00 00       	call   3763 <exit>

000030a6 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    30a6:	55                   	push   %ebp
    30a7:	89 e5                	mov    %esp,%ebp
    30a9:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    30ac:	68 b2 4a 00 00       	push   $0x4ab2
    30b1:	e8 fd 06 00 00       	call   37b3 <unlink>
  pid = fork();
    30b6:	e8 a0 06 00 00       	call   375b <fork>
  if(pid == 0){
    30bb:	83 c4 10             	add    $0x10,%esp
    30be:	85 c0                	test   %eax,%eax
    30c0:	74 3f                	je     3101 <bigargtest+0x5b>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    30c2:	0f 88 ad 00 00 00    	js     3175 <bigargtest+0xcf>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    30c8:	e8 9e 06 00 00       	call   376b <wait>
  fd = open("bigarg-ok", 0);
    30cd:	83 ec 08             	sub    $0x8,%esp
    30d0:	6a 00                	push   $0x0
    30d2:	68 b2 4a 00 00       	push   $0x4ab2
    30d7:	e8 c7 06 00 00       	call   37a3 <open>
  if(fd < 0){
    30dc:	83 c4 10             	add    $0x10,%esp
    30df:	85 c0                	test   %eax,%eax
    30e1:	0f 88 a6 00 00 00    	js     318d <bigargtest+0xe7>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    30e7:	83 ec 0c             	sub    $0xc,%esp
    30ea:	50                   	push   %eax
    30eb:	e8 9b 06 00 00       	call   378b <close>
  unlink("bigarg-ok");
    30f0:	c7 04 24 b2 4a 00 00 	movl   $0x4ab2,(%esp)
    30f7:	e8 b7 06 00 00       	call   37b3 <unlink>
}
    30fc:	83 c4 10             	add    $0x10,%esp
    30ff:	c9                   	leave  
    3100:	c3                   	ret    
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3101:	c7 04 85 60 a3 00 00 	movl   $0x520c,0xa360(,%eax,4)
    3108:	0c 52 00 00 
    for(i = 0; i < MAXARG-1; i++)
    310c:	83 c0 01             	add    $0x1,%eax
    310f:	83 f8 1f             	cmp    $0x1f,%eax
    3112:	75 ed                	jne    3101 <bigargtest+0x5b>
    args[MAXARG-1] = 0;
    3114:	c7 05 dc a3 00 00 00 	movl   $0x0,0xa3dc
    311b:	00 00 00 
    printf(stdout, "bigarg test\n");
    311e:	83 ec 08             	sub    $0x8,%esp
    3121:	68 bc 4a 00 00       	push   $0x4abc
    3126:	ff 35 10 5c 00 00    	push   0x5c10
    312c:	e8 7a 07 00 00       	call   38ab <printf>
    exec("echo", args);
    3131:	83 c4 08             	add    $0x8,%esp
    3134:	68 60 a3 00 00       	push   $0xa360
    3139:	68 89 3c 00 00       	push   $0x3c89
    313e:	e8 58 06 00 00       	call   379b <exec>
    printf(stdout, "bigarg test ok\n");
    3143:	83 c4 08             	add    $0x8,%esp
    3146:	68 c9 4a 00 00       	push   $0x4ac9
    314b:	ff 35 10 5c 00 00    	push   0x5c10
    3151:	e8 55 07 00 00       	call   38ab <printf>
    fd = open("bigarg-ok", O_CREATE);
    3156:	83 c4 08             	add    $0x8,%esp
    3159:	68 00 02 00 00       	push   $0x200
    315e:	68 b2 4a 00 00       	push   $0x4ab2
    3163:	e8 3b 06 00 00       	call   37a3 <open>
    close(fd);
    3168:	89 04 24             	mov    %eax,(%esp)
    316b:	e8 1b 06 00 00       	call   378b <close>
    exit();
    3170:	e8 ee 05 00 00       	call   3763 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3175:	83 ec 08             	sub    $0x8,%esp
    3178:	68 d9 4a 00 00       	push   $0x4ad9
    317d:	ff 35 10 5c 00 00    	push   0x5c10
    3183:	e8 23 07 00 00       	call   38ab <printf>
    exit();
    3188:	e8 d6 05 00 00       	call   3763 <exit>
    printf(stdout, "bigarg test failed!\n");
    318d:	83 ec 08             	sub    $0x8,%esp
    3190:	68 f2 4a 00 00       	push   $0x4af2
    3195:	ff 35 10 5c 00 00    	push   0x5c10
    319b:	e8 0b 07 00 00       	call   38ab <printf>
    exit();
    31a0:	e8 be 05 00 00       	call   3763 <exit>

000031a5 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    31a5:	55                   	push   %ebp
    31a6:	89 e5                	mov    %esp,%ebp
    31a8:	57                   	push   %edi
    31a9:	56                   	push   %esi
    31aa:	53                   	push   %ebx
    31ab:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    31ae:	68 07 4b 00 00       	push   $0x4b07
    31b3:	6a 01                	push   $0x1
    31b5:	e8 f1 06 00 00       	call   38ab <printf>
    31ba:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    31bd:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    31c2:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    31c6:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    31cb:	f7 eb                	imul   %ebx
    31cd:	c1 fa 06             	sar    $0x6,%edx
    31d0:	89 de                	mov    %ebx,%esi
    31d2:	c1 fe 1f             	sar    $0x1f,%esi
    31d5:	29 f2                	sub    %esi,%edx
    31d7:	8d 42 30             	lea    0x30(%edx),%eax
    31da:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    31dd:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    31e3:	89 d9                	mov    %ebx,%ecx
    31e5:	29 d1                	sub    %edx,%ecx
    31e7:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    31ec:	f7 e9                	imul   %ecx
    31ee:	c1 fa 05             	sar    $0x5,%edx
    31f1:	c1 f9 1f             	sar    $0x1f,%ecx
    31f4:	29 ca                	sub    %ecx,%edx
    31f6:	83 c2 30             	add    $0x30,%edx
    31f9:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    31fc:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3201:	f7 eb                	imul   %ebx
    3203:	c1 fa 05             	sar    $0x5,%edx
    3206:	29 f2                	sub    %esi,%edx
    3208:	6b d2 64             	imul   $0x64,%edx,%edx
    320b:	89 df                	mov    %ebx,%edi
    320d:	29 d7                	sub    %edx,%edi
    320f:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    3214:	89 f8                	mov    %edi,%eax
    3216:	f7 e9                	imul   %ecx
    3218:	c1 fa 02             	sar    $0x2,%edx
    321b:	c1 ff 1f             	sar    $0x1f,%edi
    321e:	29 fa                	sub    %edi,%edx
    3220:	83 c2 30             	add    $0x30,%edx
    3223:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3226:	89 d8                	mov    %ebx,%eax
    3228:	f7 e9                	imul   %ecx
    322a:	c1 fa 02             	sar    $0x2,%edx
    322d:	29 f2                	sub    %esi,%edx
    322f:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3232:	01 d2                	add    %edx,%edx
    3234:	89 d8                	mov    %ebx,%eax
    3236:	29 d0                	sub    %edx,%eax
    3238:	83 c0 30             	add    $0x30,%eax
    323b:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    323e:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    3242:	83 ec 04             	sub    $0x4,%esp
    3245:	8d 75 a8             	lea    -0x58(%ebp),%esi
    3248:	56                   	push   %esi
    3249:	68 14 4b 00 00       	push   $0x4b14
    324e:	6a 01                	push   $0x1
    3250:	e8 56 06 00 00       	call   38ab <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3255:	83 c4 08             	add    $0x8,%esp
    3258:	68 02 02 00 00       	push   $0x202
    325d:	56                   	push   %esi
    325e:	e8 40 05 00 00       	call   37a3 <open>
    3263:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3265:	83 c4 10             	add    $0x10,%esp
    3268:	85 c0                	test   %eax,%eax
    326a:	0f 89 d6 00 00 00    	jns    3346 <fsfull+0x1a1>
      printf(1, "open %s failed\n", name);
    3270:	83 ec 04             	sub    $0x4,%esp
    3273:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3276:	50                   	push   %eax
    3277:	68 20 4b 00 00       	push   $0x4b20
    327c:	6a 01                	push   $0x1
    327e:	e8 28 06 00 00       	call   38ab <printf>
      break;
    3283:	83 c4 10             	add    $0x10,%esp
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3286:	85 db                	test   %ebx,%ebx
    3288:	0f 88 9e 00 00 00    	js     332c <fsfull+0x187>
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    328e:	bf 1f 85 eb 51       	mov    $0x51eb851f,%edi
    name[0] = 'f';
    3293:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3297:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    329c:	f7 eb                	imul   %ebx
    329e:	c1 fa 06             	sar    $0x6,%edx
    32a1:	89 de                	mov    %ebx,%esi
    32a3:	c1 fe 1f             	sar    $0x1f,%esi
    32a6:	29 f2                	sub    %esi,%edx
    32a8:	8d 42 30             	lea    0x30(%edx),%eax
    32ab:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    32ae:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    32b4:	89 d9                	mov    %ebx,%ecx
    32b6:	29 d1                	sub    %edx,%ecx
    32b8:	89 c8                	mov    %ecx,%eax
    32ba:	f7 ef                	imul   %edi
    32bc:	c1 fa 05             	sar    $0x5,%edx
    32bf:	c1 f9 1f             	sar    $0x1f,%ecx
    32c2:	29 ca                	sub    %ecx,%edx
    32c4:	83 c2 30             	add    $0x30,%edx
    32c7:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    32ca:	89 d8                	mov    %ebx,%eax
    32cc:	f7 ef                	imul   %edi
    32ce:	c1 fa 05             	sar    $0x5,%edx
    32d1:	89 75 a4             	mov    %esi,-0x5c(%ebp)
    32d4:	29 f2                	sub    %esi,%edx
    32d6:	6b d2 64             	imul   $0x64,%edx,%edx
    32d9:	89 d8                	mov    %ebx,%eax
    32db:	29 d0                	sub    %edx,%eax
    32dd:	89 c6                	mov    %eax,%esi
    32df:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    32e4:	f7 e9                	imul   %ecx
    32e6:	c1 fa 02             	sar    $0x2,%edx
    32e9:	c1 fe 1f             	sar    $0x1f,%esi
    32ec:	29 f2                	sub    %esi,%edx
    32ee:	83 c2 30             	add    $0x30,%edx
    32f1:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    32f4:	89 d8                	mov    %ebx,%eax
    32f6:	f7 e9                	imul   %ecx
    32f8:	c1 fa 02             	sar    $0x2,%edx
    32fb:	2b 55 a4             	sub    -0x5c(%ebp),%edx
    32fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3301:	01 d2                	add    %edx,%edx
    3303:	89 d8                	mov    %ebx,%eax
    3305:	29 d0                	sub    %edx,%eax
    3307:	83 c0 30             	add    $0x30,%eax
    330a:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    330d:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    3311:	83 ec 0c             	sub    $0xc,%esp
    3314:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3317:	50                   	push   %eax
    3318:	e8 96 04 00 00       	call   37b3 <unlink>
    nfiles--;
    331d:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    3320:	83 c4 10             	add    $0x10,%esp
    3323:	83 fb ff             	cmp    $0xffffffff,%ebx
    3326:	0f 85 67 ff ff ff    	jne    3293 <fsfull+0xee>
  }

  printf(1, "fsfull test finished\n");
    332c:	83 ec 08             	sub    $0x8,%esp
    332f:	68 40 4b 00 00       	push   $0x4b40
    3334:	6a 01                	push   $0x1
    3336:	e8 70 05 00 00       	call   38ab <printf>
}
    333b:	83 c4 10             	add    $0x10,%esp
    333e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3341:	5b                   	pop    %ebx
    3342:	5e                   	pop    %esi
    3343:	5f                   	pop    %edi
    3344:	5d                   	pop    %ebp
    3345:	c3                   	ret    
    int total = 0;
    3346:	bf 00 00 00 00       	mov    $0x0,%edi
      int cc = write(fd, buf, 512);
    334b:	83 ec 04             	sub    $0x4,%esp
    334e:	68 00 02 00 00       	push   $0x200
    3353:	68 60 83 00 00       	push   $0x8360
    3358:	56                   	push   %esi
    3359:	e8 25 04 00 00       	call   3783 <write>
      if(cc < 512)
    335e:	83 c4 10             	add    $0x10,%esp
    3361:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3366:	7e 04                	jle    336c <fsfull+0x1c7>
      total += cc;
    3368:	01 c7                	add    %eax,%edi
    while(1){
    336a:	eb df                	jmp    334b <fsfull+0x1a6>
    printf(1, "wrote %d bytes\n", total);
    336c:	83 ec 04             	sub    $0x4,%esp
    336f:	57                   	push   %edi
    3370:	68 30 4b 00 00       	push   $0x4b30
    3375:	6a 01                	push   $0x1
    3377:	e8 2f 05 00 00       	call   38ab <printf>
    close(fd);
    337c:	89 34 24             	mov    %esi,(%esp)
    337f:	e8 07 04 00 00       	call   378b <close>
    if(total == 0)
    3384:	83 c4 10             	add    $0x10,%esp
    3387:	85 ff                	test   %edi,%edi
    3389:	0f 84 f7 fe ff ff    	je     3286 <fsfull+0xe1>
  for(nfiles = 0; ; nfiles++){
    338f:	83 c3 01             	add    $0x1,%ebx
    3392:	e9 2b fe ff ff       	jmp    31c2 <fsfull+0x1d>

00003397 <uio>:

void
uio()
{
    3397:	55                   	push   %ebp
    3398:	89 e5                	mov    %esp,%ebp
    339a:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    339d:	68 56 4b 00 00       	push   $0x4b56
    33a2:	6a 01                	push   $0x1
    33a4:	e8 02 05 00 00       	call   38ab <printf>
  pid = fork();
    33a9:	e8 ad 03 00 00       	call   375b <fork>
  if(pid == 0){
    33ae:	83 c4 10             	add    $0x10,%esp
    33b1:	85 c0                	test   %eax,%eax
    33b3:	74 1b                	je     33d0 <uio+0x39>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    33b5:	78 3e                	js     33f5 <uio+0x5e>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    33b7:	e8 af 03 00 00       	call   376b <wait>
  printf(1, "uio test done\n");
    33bc:	83 ec 08             	sub    $0x8,%esp
    33bf:	68 60 4b 00 00       	push   $0x4b60
    33c4:	6a 01                	push   $0x1
    33c6:	e8 e0 04 00 00       	call   38ab <printf>
}
    33cb:	83 c4 10             	add    $0x10,%esp
    33ce:	c9                   	leave  
    33cf:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    33d0:	b8 09 00 00 00       	mov    $0x9,%eax
    33d5:	ba 70 00 00 00       	mov    $0x70,%edx
    33da:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    33db:	ba 71 00 00 00       	mov    $0x71,%edx
    33e0:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    33e1:	83 ec 08             	sub    $0x8,%esp
    33e4:	68 ec 52 00 00       	push   $0x52ec
    33e9:	6a 01                	push   $0x1
    33eb:	e8 bb 04 00 00       	call   38ab <printf>
    exit();
    33f0:	e8 6e 03 00 00       	call   3763 <exit>
    printf (1, "fork failed\n");
    33f5:	83 ec 08             	sub    $0x8,%esp
    33f8:	68 e5 4a 00 00       	push   $0x4ae5
    33fd:	6a 01                	push   $0x1
    33ff:	e8 a7 04 00 00       	call   38ab <printf>
    exit();
    3404:	e8 5a 03 00 00       	call   3763 <exit>

00003409 <argptest>:

void argptest()
{
    3409:	55                   	push   %ebp
    340a:	89 e5                	mov    %esp,%ebp
    340c:	53                   	push   %ebx
    340d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3410:	6a 00                	push   $0x0
    3412:	68 6f 4b 00 00       	push   $0x4b6f
    3417:	e8 87 03 00 00       	call   37a3 <open>
  if (fd < 0) {
    341c:	83 c4 10             	add    $0x10,%esp
    341f:	85 c0                	test   %eax,%eax
    3421:	78 3a                	js     345d <argptest+0x54>
    3423:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    3425:	83 ec 0c             	sub    $0xc,%esp
    3428:	6a 00                	push   $0x0
    342a:	e8 bc 03 00 00       	call   37eb <sbrk>
    342f:	83 c4 0c             	add    $0xc,%esp
    3432:	6a ff                	push   $0xffffffff
    3434:	83 e8 01             	sub    $0x1,%eax
    3437:	50                   	push   %eax
    3438:	53                   	push   %ebx
    3439:	e8 3d 03 00 00       	call   377b <read>
  close(fd);
    343e:	89 1c 24             	mov    %ebx,(%esp)
    3441:	e8 45 03 00 00       	call   378b <close>
  printf(1, "arg test passed\n");
    3446:	83 c4 08             	add    $0x8,%esp
    3449:	68 81 4b 00 00       	push   $0x4b81
    344e:	6a 01                	push   $0x1
    3450:	e8 56 04 00 00       	call   38ab <printf>
}
    3455:	83 c4 10             	add    $0x10,%esp
    3458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    345b:	c9                   	leave  
    345c:	c3                   	ret    
    printf(2, "open failed\n");
    345d:	83 ec 08             	sub    $0x8,%esp
    3460:	68 74 4b 00 00       	push   $0x4b74
    3465:	6a 02                	push   $0x2
    3467:	e8 3f 04 00 00       	call   38ab <printf>
    exit();
    346c:	e8 f2 02 00 00       	call   3763 <exit>

00003471 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    3471:	69 05 0c 5c 00 00 0d 	imul   $0x19660d,0x5c0c,%eax
    3478:	66 19 00 
    347b:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3480:	a3 0c 5c 00 00       	mov    %eax,0x5c0c
  return randstate;
}
    3485:	c3                   	ret    

00003486 <main>:

int
main(int argc, char *argv[])
{
    3486:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    348a:	83 e4 f0             	and    $0xfffffff0,%esp
    348d:	ff 71 fc             	push   -0x4(%ecx)
    3490:	55                   	push   %ebp
    3491:	89 e5                	mov    %esp,%ebp
    3493:	51                   	push   %ecx
    3494:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    3497:	68 92 4b 00 00       	push   $0x4b92
    349c:	6a 01                	push   $0x1
    349e:	e8 08 04 00 00       	call   38ab <printf>

  if(open("usertests.ran", 0) >= 0){
    34a3:	83 c4 08             	add    $0x8,%esp
    34a6:	6a 00                	push   $0x0
    34a8:	68 a6 4b 00 00       	push   $0x4ba6
    34ad:	e8 f1 02 00 00       	call   37a3 <open>
    34b2:	83 c4 10             	add    $0x10,%esp
    34b5:	85 c0                	test   %eax,%eax
    34b7:	78 14                	js     34cd <main+0x47>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    34b9:	83 ec 08             	sub    $0x8,%esp
    34bc:	68 10 53 00 00       	push   $0x5310
    34c1:	6a 01                	push   $0x1
    34c3:	e8 e3 03 00 00       	call   38ab <printf>
    exit();
    34c8:	e8 96 02 00 00       	call   3763 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    34cd:	83 ec 08             	sub    $0x8,%esp
    34d0:	68 00 02 00 00       	push   $0x200
    34d5:	68 a6 4b 00 00       	push   $0x4ba6
    34da:	e8 c4 02 00 00       	call   37a3 <open>
    34df:	89 04 24             	mov    %eax,(%esp)
    34e2:	e8 a4 02 00 00       	call   378b <close>

  argptest();
    34e7:	e8 1d ff ff ff       	call   3409 <argptest>
  createdelete();
    34ec:	e8 0b db ff ff       	call   ffc <createdelete>
  linkunlink();
    34f1:	e8 b4 e3 ff ff       	call   18aa <linkunlink>
  concreate();
    34f6:	e8 b4 e0 ff ff       	call   15af <concreate>
  fourfiles();
    34fb:	e8 26 d9 ff ff       	call   e26 <fourfiles>
  sharedfd();
    3500:	e8 8e d7 ff ff       	call   c93 <sharedfd>

  bigargtest();
    3505:	e8 9c fb ff ff       	call   30a6 <bigargtest>
  bigwrite();
    350a:	e8 15 ed ff ff       	call   2224 <bigwrite>
  bigargtest();
    350f:	e8 92 fb ff ff       	call   30a6 <bigargtest>
  bsstest();
    3514:	e8 2c fb ff ff       	call   3045 <bsstest>
  sbrktest();
    3519:	e8 54 f6 ff ff       	call   2b72 <sbrktest>
  validatetest();
    351e:	e8 76 fa ff ff       	call   2f99 <validatetest>

  opentest();
    3523:	e8 84 cd ff ff       	call   2ac <opentest>
  writetest();
    3528:	e8 12 ce ff ff       	call   33f <writetest>
  writetest1();
    352d:	e8 eb cf ff ff       	call   51d <writetest1>
  createtest();
    3532:	e8 a0 d1 ff ff       	call   6d7 <createtest>

  openiputtest();
    3537:	e8 87 cc ff ff       	call   1c3 <openiputtest>
  exitiputtest();
    353c:	e8 9c cb ff ff       	call   dd <exitiputtest>
  iputtest();
    3541:	e8 ba ca ff ff       	call   0 <iputtest>

  mem();
    3546:	e8 93 d6 ff ff       	call   bde <mem>
  pipe1();
    354b:	e8 51 d3 ff ff       	call   8a1 <pipe1>
  preempt();
    3550:	e8 e3 d4 ff ff       	call   a38 <preempt>
  exitwait();
    3555:	e8 19 d6 ff ff       	call   b73 <exitwait>

  rmdot();
    355a:	e8 a5 f0 ff ff       	call   2604 <rmdot>
  fourteen();
    355f:	e8 63 ef ff ff       	call   24c7 <fourteen>
  bigfile();
    3564:	e8 96 ed ff ff       	call   22ff <bigfile>
  subdir();
    3569:	e8 88 e5 ff ff       	call   1af6 <subdir>
  linktest();
    356e:	e8 16 de ff ff       	call   1389 <linktest>
  unlinkread();
    3573:	e8 78 dc ff ff       	call   11f0 <unlinkread>
  dirfile();
    3578:	e8 0c f2 ff ff       	call   2789 <dirfile>
  iref();
    357d:	e8 21 f4 ff ff       	call   29a3 <iref>
  forktest();
    3582:	e8 3e f5 ff ff       	call   2ac5 <forktest>
  bigdir(); // slow
    3587:	e8 10 e4 ff ff       	call   199c <bigdir>

  uio();
    358c:	e8 06 fe ff ff       	call   3397 <uio>

  exectest();
    3591:	e8 c2 d2 ff ff       	call   858 <exectest>

  exit();
    3596:	e8 c8 01 00 00       	call   3763 <exit>

0000359b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    359b:	55                   	push   %ebp
    359c:	89 e5                	mov    %esp,%ebp
    359e:	53                   	push   %ebx
    359f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    35a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    35a5:	b8 00 00 00 00       	mov    $0x0,%eax
    35aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    35ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    35b1:	83 c0 01             	add    $0x1,%eax
    35b4:	84 d2                	test   %dl,%dl
    35b6:	75 f2                	jne    35aa <strcpy+0xf>
    ;
  return os;
}
    35b8:	89 c8                	mov    %ecx,%eax
    35ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    35bd:	c9                   	leave  
    35be:	c3                   	ret    

000035bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
    35bf:	55                   	push   %ebp
    35c0:	89 e5                	mov    %esp,%ebp
    35c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    35c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    35c8:	0f b6 01             	movzbl (%ecx),%eax
    35cb:	84 c0                	test   %al,%al
    35cd:	74 11                	je     35e0 <strcmp+0x21>
    35cf:	38 02                	cmp    %al,(%edx)
    35d1:	75 0d                	jne    35e0 <strcmp+0x21>
    p++, q++;
    35d3:	83 c1 01             	add    $0x1,%ecx
    35d6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    35d9:	0f b6 01             	movzbl (%ecx),%eax
    35dc:	84 c0                	test   %al,%al
    35de:	75 ef                	jne    35cf <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
    35e0:	0f b6 c0             	movzbl %al,%eax
    35e3:	0f b6 12             	movzbl (%edx),%edx
    35e6:	29 d0                	sub    %edx,%eax
}
    35e8:	5d                   	pop    %ebp
    35e9:	c3                   	ret    

000035ea <strlen>:

uint
strlen(const char *s)
{
    35ea:	55                   	push   %ebp
    35eb:	89 e5                	mov    %esp,%ebp
    35ed:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    35f0:	80 3a 00             	cmpb   $0x0,(%edx)
    35f3:	74 14                	je     3609 <strlen+0x1f>
    35f5:	b8 00 00 00 00       	mov    $0x0,%eax
    35fa:	83 c0 01             	add    $0x1,%eax
    35fd:	89 c1                	mov    %eax,%ecx
    35ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    3603:	75 f5                	jne    35fa <strlen+0x10>
    ;
  return n;
}
    3605:	89 c8                	mov    %ecx,%eax
    3607:	5d                   	pop    %ebp
    3608:	c3                   	ret    
  for(n = 0; s[n]; n++)
    3609:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
    360e:	eb f5                	jmp    3605 <strlen+0x1b>

00003610 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3610:	55                   	push   %ebp
    3611:	89 e5                	mov    %esp,%ebp
    3613:	57                   	push   %edi
    3614:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3617:	89 d7                	mov    %edx,%edi
    3619:	8b 4d 10             	mov    0x10(%ebp),%ecx
    361c:	8b 45 0c             	mov    0xc(%ebp),%eax
    361f:	fc                   	cld    
    3620:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3622:	89 d0                	mov    %edx,%eax
    3624:	8b 7d fc             	mov    -0x4(%ebp),%edi
    3627:	c9                   	leave  
    3628:	c3                   	ret    

00003629 <strchr>:

char*
strchr(const char *s, char c)
{
    3629:	55                   	push   %ebp
    362a:	89 e5                	mov    %esp,%ebp
    362c:	8b 45 08             	mov    0x8(%ebp),%eax
    362f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    3633:	0f b6 10             	movzbl (%eax),%edx
    3636:	84 d2                	test   %dl,%dl
    3638:	74 15                	je     364f <strchr+0x26>
    if(*s == c)
    363a:	38 d1                	cmp    %dl,%cl
    363c:	74 0f                	je     364d <strchr+0x24>
  for(; *s; s++)
    363e:	83 c0 01             	add    $0x1,%eax
    3641:	0f b6 10             	movzbl (%eax),%edx
    3644:	84 d2                	test   %dl,%dl
    3646:	75 f2                	jne    363a <strchr+0x11>
      return (char*)s;
  return 0;
    3648:	b8 00 00 00 00       	mov    $0x0,%eax
}
    364d:	5d                   	pop    %ebp
    364e:	c3                   	ret    
  return 0;
    364f:	b8 00 00 00 00       	mov    $0x0,%eax
    3654:	eb f7                	jmp    364d <strchr+0x24>

00003656 <gets>:

char*
gets(char *buf, int max)
{
    3656:	55                   	push   %ebp
    3657:	89 e5                	mov    %esp,%ebp
    3659:	57                   	push   %edi
    365a:	56                   	push   %esi
    365b:	53                   	push   %ebx
    365c:	83 ec 2c             	sub    $0x2c,%esp
    365f:	8b 75 08             	mov    0x8(%ebp),%esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3662:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(0, &c, 1);
    3667:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    366a:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    366d:	83 c3 01             	add    $0x1,%ebx
    3670:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3673:	7d 27                	jge    369c <gets+0x46>
    cc = read(0, &c, 1);
    3675:	83 ec 04             	sub    $0x4,%esp
    3678:	6a 01                	push   $0x1
    367a:	57                   	push   %edi
    367b:	6a 00                	push   $0x0
    367d:	e8 f9 00 00 00       	call   377b <read>
    if(cc < 1)
    3682:	83 c4 10             	add    $0x10,%esp
    3685:	85 c0                	test   %eax,%eax
    3687:	7e 13                	jle    369c <gets+0x46>
      break;
    buf[i++] = c;
    3689:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    368d:	88 44 1e ff          	mov    %al,-0x1(%esi,%ebx,1)
    if(c == '\n' || c == '\r')
    3691:	3c 0a                	cmp    $0xa,%al
    3693:	74 04                	je     3699 <gets+0x43>
    3695:	3c 0d                	cmp    $0xd,%al
    3697:	75 d1                	jne    366a <gets+0x14>
  for(i=0; i+1 < max; ){
    3699:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
      break;
  }
  buf[i] = '\0';
    369c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    369f:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
  return buf;
}
    36a3:	89 f0                	mov    %esi,%eax
    36a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    36a8:	5b                   	pop    %ebx
    36a9:	5e                   	pop    %esi
    36aa:	5f                   	pop    %edi
    36ab:	5d                   	pop    %ebp
    36ac:	c3                   	ret    

000036ad <stat>:

int
stat(const char *n, struct stat *st)
{
    36ad:	55                   	push   %ebp
    36ae:	89 e5                	mov    %esp,%ebp
    36b0:	56                   	push   %esi
    36b1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    36b2:	83 ec 08             	sub    $0x8,%esp
    36b5:	6a 00                	push   $0x0
    36b7:	ff 75 08             	push   0x8(%ebp)
    36ba:	e8 e4 00 00 00       	call   37a3 <open>
  if(fd < 0)
    36bf:	83 c4 10             	add    $0x10,%esp
    36c2:	85 c0                	test   %eax,%eax
    36c4:	78 24                	js     36ea <stat+0x3d>
    36c6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    36c8:	83 ec 08             	sub    $0x8,%esp
    36cb:	ff 75 0c             	push   0xc(%ebp)
    36ce:	50                   	push   %eax
    36cf:	e8 e7 00 00 00       	call   37bb <fstat>
    36d4:	89 c6                	mov    %eax,%esi
  close(fd);
    36d6:	89 1c 24             	mov    %ebx,(%esp)
    36d9:	e8 ad 00 00 00       	call   378b <close>
  return r;
    36de:	83 c4 10             	add    $0x10,%esp
}
    36e1:	89 f0                	mov    %esi,%eax
    36e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    36e6:	5b                   	pop    %ebx
    36e7:	5e                   	pop    %esi
    36e8:	5d                   	pop    %ebp
    36e9:	c3                   	ret    
    return -1;
    36ea:	be ff ff ff ff       	mov    $0xffffffff,%esi
    36ef:	eb f0                	jmp    36e1 <stat+0x34>

000036f1 <atoi>:

int
atoi(const char *s)
{
    36f1:	55                   	push   %ebp
    36f2:	89 e5                	mov    %esp,%ebp
    36f4:	53                   	push   %ebx
    36f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    36f8:	0f b6 02             	movzbl (%edx),%eax
    36fb:	8d 48 d0             	lea    -0x30(%eax),%ecx
    36fe:	80 f9 09             	cmp    $0x9,%cl
    3701:	77 24                	ja     3727 <atoi+0x36>
  n = 0;
    3703:	b9 00 00 00 00       	mov    $0x0,%ecx
    n = n*10 + *s++ - '0';
    3708:	83 c2 01             	add    $0x1,%edx
    370b:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    370e:	0f be c0             	movsbl %al,%eax
    3711:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    3715:	0f b6 02             	movzbl (%edx),%eax
    3718:	8d 58 d0             	lea    -0x30(%eax),%ebx
    371b:	80 fb 09             	cmp    $0x9,%bl
    371e:	76 e8                	jbe    3708 <atoi+0x17>
  return n;
}
    3720:	89 c8                	mov    %ecx,%eax
    3722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3725:	c9                   	leave  
    3726:	c3                   	ret    
  n = 0;
    3727:	b9 00 00 00 00       	mov    $0x0,%ecx
  return n;
    372c:	eb f2                	jmp    3720 <atoi+0x2f>

0000372e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    372e:	55                   	push   %ebp
    372f:	89 e5                	mov    %esp,%ebp
    3731:	56                   	push   %esi
    3732:	53                   	push   %ebx
    3733:	8b 75 08             	mov    0x8(%ebp),%esi
    3736:	8b 55 0c             	mov    0xc(%ebp),%edx
    3739:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    373c:	85 db                	test   %ebx,%ebx
    373e:	7e 15                	jle    3755 <memmove+0x27>
    3740:	01 f3                	add    %esi,%ebx
  dst = vdst;
    3742:	89 f0                	mov    %esi,%eax
    *dst++ = *src++;
    3744:	83 c2 01             	add    $0x1,%edx
    3747:	83 c0 01             	add    $0x1,%eax
    374a:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
    374e:	88 48 ff             	mov    %cl,-0x1(%eax)
  while(n-- > 0)
    3751:	39 c3                	cmp    %eax,%ebx
    3753:	75 ef                	jne    3744 <memmove+0x16>
  return vdst;
}
    3755:	89 f0                	mov    %esi,%eax
    3757:	5b                   	pop    %ebx
    3758:	5e                   	pop    %esi
    3759:	5d                   	pop    %ebp
    375a:	c3                   	ret    

0000375b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    375b:	b8 01 00 00 00       	mov    $0x1,%eax
    3760:	cd 40                	int    $0x40
    3762:	c3                   	ret    

00003763 <exit>:
SYSCALL(exit)
    3763:	b8 02 00 00 00       	mov    $0x2,%eax
    3768:	cd 40                	int    $0x40
    376a:	c3                   	ret    

0000376b <wait>:
SYSCALL(wait)
    376b:	b8 03 00 00 00       	mov    $0x3,%eax
    3770:	cd 40                	int    $0x40
    3772:	c3                   	ret    

00003773 <pipe>:
SYSCALL(pipe)
    3773:	b8 04 00 00 00       	mov    $0x4,%eax
    3778:	cd 40                	int    $0x40
    377a:	c3                   	ret    

0000377b <read>:
SYSCALL(read)
    377b:	b8 05 00 00 00       	mov    $0x5,%eax
    3780:	cd 40                	int    $0x40
    3782:	c3                   	ret    

00003783 <write>:
SYSCALL(write)
    3783:	b8 10 00 00 00       	mov    $0x10,%eax
    3788:	cd 40                	int    $0x40
    378a:	c3                   	ret    

0000378b <close>:
SYSCALL(close)
    378b:	b8 15 00 00 00       	mov    $0x15,%eax
    3790:	cd 40                	int    $0x40
    3792:	c3                   	ret    

00003793 <kill>:
SYSCALL(kill)
    3793:	b8 06 00 00 00       	mov    $0x6,%eax
    3798:	cd 40                	int    $0x40
    379a:	c3                   	ret    

0000379b <exec>:
SYSCALL(exec)
    379b:	b8 07 00 00 00       	mov    $0x7,%eax
    37a0:	cd 40                	int    $0x40
    37a2:	c3                   	ret    

000037a3 <open>:
SYSCALL(open)
    37a3:	b8 0f 00 00 00       	mov    $0xf,%eax
    37a8:	cd 40                	int    $0x40
    37aa:	c3                   	ret    

000037ab <mknod>:
SYSCALL(mknod)
    37ab:	b8 11 00 00 00       	mov    $0x11,%eax
    37b0:	cd 40                	int    $0x40
    37b2:	c3                   	ret    

000037b3 <unlink>:
SYSCALL(unlink)
    37b3:	b8 12 00 00 00       	mov    $0x12,%eax
    37b8:	cd 40                	int    $0x40
    37ba:	c3                   	ret    

000037bb <fstat>:
SYSCALL(fstat)
    37bb:	b8 08 00 00 00       	mov    $0x8,%eax
    37c0:	cd 40                	int    $0x40
    37c2:	c3                   	ret    

000037c3 <link>:
SYSCALL(link)
    37c3:	b8 13 00 00 00       	mov    $0x13,%eax
    37c8:	cd 40                	int    $0x40
    37ca:	c3                   	ret    

000037cb <mkdir>:
SYSCALL(mkdir)
    37cb:	b8 14 00 00 00       	mov    $0x14,%eax
    37d0:	cd 40                	int    $0x40
    37d2:	c3                   	ret    

000037d3 <chdir>:
SYSCALL(chdir)
    37d3:	b8 09 00 00 00       	mov    $0x9,%eax
    37d8:	cd 40                	int    $0x40
    37da:	c3                   	ret    

000037db <dup>:
SYSCALL(dup)
    37db:	b8 0a 00 00 00       	mov    $0xa,%eax
    37e0:	cd 40                	int    $0x40
    37e2:	c3                   	ret    

000037e3 <getpid>:
SYSCALL(getpid)
    37e3:	b8 0b 00 00 00       	mov    $0xb,%eax
    37e8:	cd 40                	int    $0x40
    37ea:	c3                   	ret    

000037eb <sbrk>:
SYSCALL(sbrk)
    37eb:	b8 0c 00 00 00       	mov    $0xc,%eax
    37f0:	cd 40                	int    $0x40
    37f2:	c3                   	ret    

000037f3 <sleep>:
SYSCALL(sleep)
    37f3:	b8 0d 00 00 00       	mov    $0xd,%eax
    37f8:	cd 40                	int    $0x40
    37fa:	c3                   	ret    

000037fb <uptime>:
SYSCALL(uptime)
    37fb:	b8 0e 00 00 00       	mov    $0xe,%eax
    3800:	cd 40                	int    $0x40
    3802:	c3                   	ret    

00003803 <slabtest>:
SYSCALL(slabtest)
    3803:	b8 16 00 00 00       	mov    $0x16,%eax
    3808:	cd 40                	int    $0x40
    380a:	c3                   	ret    

0000380b <ps>:
SYSCALL(ps)
    380b:	b8 17 00 00 00       	mov    $0x17,%eax
    3810:	cd 40                	int    $0x40
    3812:	c3                   	ret    

00003813 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3813:	55                   	push   %ebp
    3814:	89 e5                	mov    %esp,%ebp
    3816:	57                   	push   %edi
    3817:	56                   	push   %esi
    3818:	53                   	push   %ebx
    3819:	83 ec 3c             	sub    $0x3c,%esp
    381c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    381f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3821:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    3825:	74 79                	je     38a0 <printint+0x8d>
    3827:	85 d2                	test   %edx,%edx
    3829:	79 75                	jns    38a0 <printint+0x8d>
    neg = 1;
    x = -xx;
    382b:	89 d1                	mov    %edx,%ecx
    382d:	f7 d9                	neg    %ecx
    neg = 1;
    382f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    3836:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    383b:	89 df                	mov    %ebx,%edi
    383d:	83 c3 01             	add    $0x1,%ebx
    3840:	89 c8                	mov    %ecx,%eax
    3842:	ba 00 00 00 00       	mov    $0x0,%edx
    3847:	f7 f6                	div    %esi
    3849:	0f b6 92 9c 53 00 00 	movzbl 0x539c(%edx),%edx
    3850:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    3854:	89 ca                	mov    %ecx,%edx
    3856:	89 c1                	mov    %eax,%ecx
    3858:	39 d6                	cmp    %edx,%esi
    385a:	76 df                	jbe    383b <printint+0x28>
  if(neg)
    385c:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
    3860:	74 08                	je     386a <printint+0x57>
    buf[i++] = '-';
    3862:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    3867:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    386a:	85 db                	test   %ebx,%ebx
    386c:	7e 2a                	jle    3898 <printint+0x85>
    386e:	8d 7d d8             	lea    -0x28(%ebp),%edi
    3871:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
  write(fd, &c, 1);
    3875:	8d 75 d7             	lea    -0x29(%ebp),%esi
    putc(fd, buf[i]);
    3878:	0f b6 03             	movzbl (%ebx),%eax
    387b:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
    387e:	83 ec 04             	sub    $0x4,%esp
    3881:	6a 01                	push   $0x1
    3883:	56                   	push   %esi
    3884:	ff 75 c4             	push   -0x3c(%ebp)
    3887:	e8 f7 fe ff ff       	call   3783 <write>
  while(--i >= 0)
    388c:	89 d8                	mov    %ebx,%eax
    388e:	83 eb 01             	sub    $0x1,%ebx
    3891:	83 c4 10             	add    $0x10,%esp
    3894:	39 f8                	cmp    %edi,%eax
    3896:	75 e0                	jne    3878 <printint+0x65>
}
    3898:	8d 65 f4             	lea    -0xc(%ebp),%esp
    389b:	5b                   	pop    %ebx
    389c:	5e                   	pop    %esi
    389d:	5f                   	pop    %edi
    389e:	5d                   	pop    %ebp
    389f:	c3                   	ret    
    x = xx;
    38a0:	89 d1                	mov    %edx,%ecx
  neg = 0;
    38a2:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
    38a9:	eb 8b                	jmp    3836 <printint+0x23>

000038ab <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    38ab:	55                   	push   %ebp
    38ac:	89 e5                	mov    %esp,%ebp
    38ae:	57                   	push   %edi
    38af:	56                   	push   %esi
    38b0:	53                   	push   %ebx
    38b1:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    38b4:	8b 75 0c             	mov    0xc(%ebp),%esi
    38b7:	0f b6 1e             	movzbl (%esi),%ebx
    38ba:	84 db                	test   %bl,%bl
    38bc:	0f 84 9f 01 00 00    	je     3a61 <printf+0x1b6>
    38c2:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    38c5:	8d 45 10             	lea    0x10(%ebp),%eax
    38c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    38cb:	bf 00 00 00 00       	mov    $0x0,%edi
    38d0:	eb 2d                	jmp    38ff <printf+0x54>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    38d2:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    38d5:	83 ec 04             	sub    $0x4,%esp
    38d8:	6a 01                	push   $0x1
    38da:	8d 45 e7             	lea    -0x19(%ebp),%eax
    38dd:	50                   	push   %eax
    38de:	ff 75 08             	push   0x8(%ebp)
    38e1:	e8 9d fe ff ff       	call   3783 <write>
        putc(fd, c);
    38e6:	83 c4 10             	add    $0x10,%esp
    38e9:	eb 05                	jmp    38f0 <printf+0x45>
      }
    } else if(state == '%'){
    38eb:	83 ff 25             	cmp    $0x25,%edi
    38ee:	74 1f                	je     390f <printf+0x64>
  for(i = 0; fmt[i]; i++){
    38f0:	83 c6 01             	add    $0x1,%esi
    38f3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    38f7:	84 db                	test   %bl,%bl
    38f9:	0f 84 62 01 00 00    	je     3a61 <printf+0x1b6>
    c = fmt[i] & 0xff;
    38ff:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3902:	85 ff                	test   %edi,%edi
    3904:	75 e5                	jne    38eb <printf+0x40>
      if(c == '%'){
    3906:	83 f8 25             	cmp    $0x25,%eax
    3909:	75 c7                	jne    38d2 <printf+0x27>
        state = '%';
    390b:	89 c7                	mov    %eax,%edi
    390d:	eb e1                	jmp    38f0 <printf+0x45>
      if(c == 'd'){
    390f:	83 f8 25             	cmp    $0x25,%eax
    3912:	0f 84 f2 00 00 00    	je     3a0a <printf+0x15f>
    3918:	8d 50 9d             	lea    -0x63(%eax),%edx
    391b:	83 fa 15             	cmp    $0x15,%edx
    391e:	0f 87 07 01 00 00    	ja     3a2b <printf+0x180>
    3924:	0f 87 01 01 00 00    	ja     3a2b <printf+0x180>
    392a:	ff 24 95 44 53 00 00 	jmp    *0x5344(,%edx,4)
        printint(fd, *ap, 10, 1);
    3931:	83 ec 0c             	sub    $0xc,%esp
    3934:	6a 01                	push   $0x1
    3936:	b9 0a 00 00 00       	mov    $0xa,%ecx
    393b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    393e:	8b 17                	mov    (%edi),%edx
    3940:	8b 45 08             	mov    0x8(%ebp),%eax
    3943:	e8 cb fe ff ff       	call   3813 <printint>
        ap++;
    3948:	89 f8                	mov    %edi,%eax
    394a:	83 c0 04             	add    $0x4,%eax
    394d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3950:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3953:	bf 00 00 00 00       	mov    $0x0,%edi
    3958:	eb 96                	jmp    38f0 <printf+0x45>
        printint(fd, *ap, 16, 0);
    395a:	83 ec 0c             	sub    $0xc,%esp
    395d:	6a 00                	push   $0x0
    395f:	b9 10 00 00 00       	mov    $0x10,%ecx
    3964:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3967:	8b 17                	mov    (%edi),%edx
    3969:	8b 45 08             	mov    0x8(%ebp),%eax
    396c:	e8 a2 fe ff ff       	call   3813 <printint>
        ap++;
    3971:	89 f8                	mov    %edi,%eax
    3973:	83 c0 04             	add    $0x4,%eax
    3976:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3979:	83 c4 10             	add    $0x10,%esp
      state = 0;
    397c:	bf 00 00 00 00       	mov    $0x0,%edi
    3981:	e9 6a ff ff ff       	jmp    38f0 <printf+0x45>
        s = (char*)*ap;
    3986:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    3989:	8b 01                	mov    (%ecx),%eax
        ap++;
    398b:	83 c1 04             	add    $0x4,%ecx
    398e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    3991:	85 c0                	test   %eax,%eax
    3993:	74 13                	je     39a8 <printf+0xfd>
        s = (char*)*ap;
    3995:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    3997:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    399a:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    399f:	84 c0                	test   %al,%al
    39a1:	75 0f                	jne    39b2 <printf+0x107>
    39a3:	e9 48 ff ff ff       	jmp    38f0 <printf+0x45>
          s = "(null)";
    39a8:	bb 3a 53 00 00       	mov    $0x533a,%ebx
        while(*s != 0){
    39ad:	b8 28 00 00 00       	mov    $0x28,%eax
    39b2:	8b 7d 08             	mov    0x8(%ebp),%edi
          putc(fd, *s);
    39b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    39b8:	83 ec 04             	sub    $0x4,%esp
    39bb:	6a 01                	push   $0x1
    39bd:	8d 45 e7             	lea    -0x19(%ebp),%eax
    39c0:	50                   	push   %eax
    39c1:	57                   	push   %edi
    39c2:	e8 bc fd ff ff       	call   3783 <write>
          s++;
    39c7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    39ca:	0f b6 03             	movzbl (%ebx),%eax
    39cd:	83 c4 10             	add    $0x10,%esp
    39d0:	84 c0                	test   %al,%al
    39d2:	75 e1                	jne    39b5 <printf+0x10a>
      state = 0;
    39d4:	bf 00 00 00 00       	mov    $0x0,%edi
    39d9:	e9 12 ff ff ff       	jmp    38f0 <printf+0x45>
        putc(fd, *ap);
    39de:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    39e1:	8b 07                	mov    (%edi),%eax
    39e3:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    39e6:	83 ec 04             	sub    $0x4,%esp
    39e9:	6a 01                	push   $0x1
    39eb:	8d 45 e7             	lea    -0x19(%ebp),%eax
    39ee:	50                   	push   %eax
    39ef:	ff 75 08             	push   0x8(%ebp)
    39f2:	e8 8c fd ff ff       	call   3783 <write>
        ap++;
    39f7:	83 c7 04             	add    $0x4,%edi
    39fa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    39fd:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a00:	bf 00 00 00 00       	mov    $0x0,%edi
    3a05:	e9 e6 fe ff ff       	jmp    38f0 <printf+0x45>
        putc(fd, c);
    3a0a:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3a0d:	83 ec 04             	sub    $0x4,%esp
    3a10:	6a 01                	push   $0x1
    3a12:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a15:	50                   	push   %eax
    3a16:	ff 75 08             	push   0x8(%ebp)
    3a19:	e8 65 fd ff ff       	call   3783 <write>
    3a1e:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a21:	bf 00 00 00 00       	mov    $0x0,%edi
    3a26:	e9 c5 fe ff ff       	jmp    38f0 <printf+0x45>
        putc(fd, '%');
    3a2b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    3a2f:	83 ec 04             	sub    $0x4,%esp
    3a32:	6a 01                	push   $0x1
    3a34:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a37:	50                   	push   %eax
    3a38:	ff 75 08             	push   0x8(%ebp)
    3a3b:	e8 43 fd ff ff       	call   3783 <write>
        putc(fd, c);
    3a40:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3a43:	83 c4 0c             	add    $0xc,%esp
    3a46:	6a 01                	push   $0x1
    3a48:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a4b:	50                   	push   %eax
    3a4c:	ff 75 08             	push   0x8(%ebp)
    3a4f:	e8 2f fd ff ff       	call   3783 <write>
        putc(fd, c);
    3a54:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a57:	bf 00 00 00 00       	mov    $0x0,%edi
    3a5c:	e9 8f fe ff ff       	jmp    38f0 <printf+0x45>
    }
  }
}
    3a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a64:	5b                   	pop    %ebx
    3a65:	5e                   	pop    %esi
    3a66:	5f                   	pop    %edi
    3a67:	5d                   	pop    %ebp
    3a68:	c3                   	ret    

00003a69 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3a69:	55                   	push   %ebp
    3a6a:	89 e5                	mov    %esp,%ebp
    3a6c:	57                   	push   %edi
    3a6d:	56                   	push   %esi
    3a6e:	53                   	push   %ebx
    3a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3a72:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3a75:	a1 e0 a3 00 00       	mov    0xa3e0,%eax
    3a7a:	eb 0c                	jmp    3a88 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3a7c:	8b 10                	mov    (%eax),%edx
    3a7e:	39 c2                	cmp    %eax,%edx
    3a80:	77 04                	ja     3a86 <free+0x1d>
    3a82:	39 ca                	cmp    %ecx,%edx
    3a84:	77 10                	ja     3a96 <free+0x2d>
{
    3a86:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3a88:	39 c8                	cmp    %ecx,%eax
    3a8a:	73 f0                	jae    3a7c <free+0x13>
    3a8c:	8b 10                	mov    (%eax),%edx
    3a8e:	39 ca                	cmp    %ecx,%edx
    3a90:	77 04                	ja     3a96 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3a92:	39 c2                	cmp    %eax,%edx
    3a94:	77 f0                	ja     3a86 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3a96:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3a99:	8b 10                	mov    (%eax),%edx
    3a9b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3a9e:	39 fa                	cmp    %edi,%edx
    3aa0:	74 19                	je     3abb <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    3aa2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    3aa5:	8b 50 04             	mov    0x4(%eax),%edx
    3aa8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3aab:	39 f1                	cmp    %esi,%ecx
    3aad:	74 18                	je     3ac7 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    3aaf:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    3ab1:	a3 e0 a3 00 00       	mov    %eax,0xa3e0
}
    3ab6:	5b                   	pop    %ebx
    3ab7:	5e                   	pop    %esi
    3ab8:	5f                   	pop    %edi
    3ab9:	5d                   	pop    %ebp
    3aba:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3abb:	03 72 04             	add    0x4(%edx),%esi
    3abe:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ac1:	8b 10                	mov    (%eax),%edx
    3ac3:	8b 12                	mov    (%edx),%edx
    3ac5:	eb db                	jmp    3aa2 <free+0x39>
    p->s.size += bp->s.size;
    3ac7:	03 53 fc             	add    -0x4(%ebx),%edx
    3aca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3acd:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    3ad0:	eb dd                	jmp    3aaf <free+0x46>

00003ad2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3ad2:	55                   	push   %ebp
    3ad3:	89 e5                	mov    %esp,%ebp
    3ad5:	57                   	push   %edi
    3ad6:	56                   	push   %esi
    3ad7:	53                   	push   %ebx
    3ad8:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3adb:	8b 45 08             	mov    0x8(%ebp),%eax
    3ade:	8d 58 07             	lea    0x7(%eax),%ebx
    3ae1:	c1 eb 03             	shr    $0x3,%ebx
    3ae4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3ae7:	8b 15 e0 a3 00 00    	mov    0xa3e0,%edx
    3aed:	85 d2                	test   %edx,%edx
    3aef:	74 1c                	je     3b0d <malloc+0x3b>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3af1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3af3:	8b 48 04             	mov    0x4(%eax),%ecx
    3af6:	39 cb                	cmp    %ecx,%ebx
    3af8:	76 38                	jbe    3b32 <malloc+0x60>
    3afa:	be 00 10 00 00       	mov    $0x1000,%esi
    3aff:	39 f3                	cmp    %esi,%ebx
    3b01:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    3b04:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    3b0b:	eb 72                	jmp    3b7f <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    3b0d:	c7 05 e0 a3 00 00 e4 	movl   $0xa3e4,0xa3e0
    3b14:	a3 00 00 
    3b17:	c7 05 e4 a3 00 00 e4 	movl   $0xa3e4,0xa3e4
    3b1e:	a3 00 00 
    base.s.size = 0;
    3b21:	c7 05 e8 a3 00 00 00 	movl   $0x0,0xa3e8
    3b28:	00 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3b2b:	b8 e4 a3 00 00       	mov    $0xa3e4,%eax
    3b30:	eb c8                	jmp    3afa <malloc+0x28>
      if(p->s.size == nunits)
    3b32:	39 cb                	cmp    %ecx,%ebx
    3b34:	74 1e                	je     3b54 <malloc+0x82>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3b36:	29 d9                	sub    %ebx,%ecx
    3b38:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3b3b:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3b3e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3b41:	89 15 e0 a3 00 00    	mov    %edx,0xa3e0
      return (void*)(p + 1);
    3b47:	8d 50 08             	lea    0x8(%eax),%edx
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3b4a:	89 d0                	mov    %edx,%eax
    3b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3b4f:	5b                   	pop    %ebx
    3b50:	5e                   	pop    %esi
    3b51:	5f                   	pop    %edi
    3b52:	5d                   	pop    %ebp
    3b53:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    3b54:	8b 08                	mov    (%eax),%ecx
    3b56:	89 0a                	mov    %ecx,(%edx)
    3b58:	eb e7                	jmp    3b41 <malloc+0x6f>
  hp->s.size = nu;
    3b5a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    3b5d:	83 ec 0c             	sub    $0xc,%esp
    3b60:	83 c0 08             	add    $0x8,%eax
    3b63:	50                   	push   %eax
    3b64:	e8 00 ff ff ff       	call   3a69 <free>
  return freep;
    3b69:	8b 15 e0 a3 00 00    	mov    0xa3e0,%edx
      if((p = morecore(nunits)) == 0)
    3b6f:	83 c4 10             	add    $0x10,%esp
    3b72:	85 d2                	test   %edx,%edx
    3b74:	74 d4                	je     3b4a <malloc+0x78>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3b76:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3b78:	8b 48 04             	mov    0x4(%eax),%ecx
    3b7b:	39 d9                	cmp    %ebx,%ecx
    3b7d:	73 b3                	jae    3b32 <malloc+0x60>
    if(p == freep)
    3b7f:	89 c2                	mov    %eax,%edx
    3b81:	39 05 e0 a3 00 00    	cmp    %eax,0xa3e0
    3b87:	75 ed                	jne    3b76 <malloc+0xa4>
  p = sbrk(nu * sizeof(Header));
    3b89:	83 ec 0c             	sub    $0xc,%esp
    3b8c:	57                   	push   %edi
    3b8d:	e8 59 fc ff ff       	call   37eb <sbrk>
  if(p == (char*)-1)
    3b92:	83 c4 10             	add    $0x10,%esp
    3b95:	83 f8 ff             	cmp    $0xffffffff,%eax
    3b98:	75 c0                	jne    3b5a <malloc+0x88>
        return 0;
    3b9a:	ba 00 00 00 00       	mov    $0x0,%edx
    3b9f:	eb a9                	jmp    3b4a <malloc+0x78>
