
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 79 11 80       	mov    $0x80117960,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 4b 2a 10 80       	mov    $0x80102a4b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 a0 75 10 80       	push   $0x801075a0
80100040:	68 20 b5 10 80       	push   $0x8010b520
80100045:	e8 6e 3b 00 00       	call   80103bb8 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
80100051:	fc 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
8010005b:	fc 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
    b->next = bcache.head.next;
80100066:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 a7 75 10 80       	push   $0x801075a7
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 28 3a 00 00       	call   80103aae <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000a3:	75 c1                	jne    80100066 <binit+0x32>
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000b9:	68 20 b5 10 80       	push   $0x8010b520
801000be:	e8 3e 3c 00 00       	call   80103d01 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000d2:	75 26                	jne    801000fa <bread+0x50>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000d4:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
801000da:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000e0:	75 4e                	jne    80100130 <bread+0x86>
  panic("bget: no buffers");
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 ae 75 10 80       	push   $0x801075ae
801000ea:	e8 51 02 00 00       	call   80100340 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ef:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	74 da                	je     801000d4 <bread+0x2a>
    if(b->dev == dev && b->blockno == blockno){
801000fa:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fd:	75 f0                	jne    801000ef <bread+0x45>
801000ff:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100102:	75 eb                	jne    801000ef <bread+0x45>
      b->refcnt++;
80100104:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 20 b5 10 80       	push   $0x8010b520
80100110:	e8 53 3c 00 00       	call   80103d68 <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 c1 39 00 00       	call   80103ae1 <acquiresleep>
      return b;
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	eb 44                	jmp    80100169 <bread+0xbf>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100125:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100128:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012e:	74 b2                	je     801000e2 <bread+0x38>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100130:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80100134:	75 ef                	jne    80100125 <bread+0x7b>
80100136:	f6 03 04             	testb  $0x4,(%ebx)
80100139:	75 ea                	jne    80100125 <bread+0x7b>
      b->dev = dev;
8010013b:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010013e:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100147:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	68 20 b5 10 80       	push   $0x8010b520
80100156:	e8 0d 3c 00 00       	call   80103d68 <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 7b 39 00 00       	call   80103ae1 <acquiresleep>
      return b;
80100166:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100169:	f6 03 02             	testb  $0x2,(%ebx)
8010016c:	74 0a                	je     80100178 <bread+0xce>
    iderw(b);
  }
  return b;
}
8010016e:	89 d8                	mov    %ebx,%eax
80100170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100173:	5b                   	pop    %ebx
80100174:	5e                   	pop    %esi
80100175:	5f                   	pop    %edi
80100176:	5d                   	pop    %ebp
80100177:	c3                   	ret    
    iderw(b);
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	53                   	push   %ebx
8010017c:	e8 c3 1c 00 00       	call   80101e44 <iderw>
80100181:	83 c4 10             	add    $0x10,%esp
  return b;
80100184:	eb e8                	jmp    8010016e <bread+0xc4>

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 d5 39 00 00       	call   80103b6e <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	74 14                	je     801001b4 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a3:	83 ec 0c             	sub    $0xc,%esp
801001a6:	53                   	push   %ebx
801001a7:	e8 98 1c 00 00       	call   80101e44 <iderw>
}
801001ac:	83 c4 10             	add    $0x10,%esp
801001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    
    panic("bwrite");
801001b4:	83 ec 0c             	sub    $0xc,%esp
801001b7:	68 bf 75 10 80       	push   $0x801075bf
801001bc:	e8 7f 01 00 00       	call   80100340 <panic>

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 99 39 00 00       	call   80103b6e <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 4e 39 00 00       	call   80103b33 <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801001ec:	e8 10 3b 00 00       	call   80103d01 <acquire>
  b->refcnt--;
801001f1:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f4:	83 e8 01             	sub    $0x1,%eax
801001f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001fa:	83 c4 10             	add    $0x10,%esp
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 2f                	jne    80100230 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100201:	8b 43 54             	mov    0x54(%ebx),%eax
80100204:	8b 53 50             	mov    0x50(%ebx),%edx
80100207:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010020a:	8b 43 50             	mov    0x50(%ebx),%eax
8010020d:	8b 53 54             	mov    0x54(%ebx),%edx
80100210:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100213:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100218:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010021b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100222:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100227:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010022a:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
80100230:	83 ec 0c             	sub    $0xc,%esp
80100233:	68 20 b5 10 80       	push   $0x8010b520
80100238:	e8 2b 3b 00 00       	call   80103d68 <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 c6 75 10 80       	push   $0x801075c6
8010024f:	e8 ec 00 00 00       	call   80100340 <panic>

80100254 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100260:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100263:	ff 75 08             	push   0x8(%ebp)
80100266:	e8 0a 13 00 00       	call   80101575 <iunlock>
  target = n;
8010026b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010026e:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80100275:	e8 87 3a 00 00       	call   80103d01 <acquire>
  while(n > 0){
8010027a:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010027d:	bb 80 fe 10 80       	mov    $0x8010fe80,%ebx
  while(n > 0){
80100282:	85 f6                	test   %esi,%esi
80100284:	7e 64                	jle    801002ea <consoleread+0x96>
    while(input.r == input.w){
80100286:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010028c:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100292:	75 2e                	jne    801002c2 <consoleread+0x6e>
      if(myproc()->killed){
80100294:	e8 17 30 00 00       	call   801032b0 <myproc>
80100299:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010029d:	75 6d                	jne    8010030c <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
8010029f:	83 ec 08             	sub    $0x8,%esp
801002a2:	68 20 ff 10 80       	push   $0x8010ff20
801002a7:	68 00 ff 10 80       	push   $0x8010ff00
801002ac:	e8 a8 34 00 00       	call   80103759 <sleep>
    while(input.r == input.w){
801002b1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801002b7:	83 c4 10             	add    $0x10,%esp
801002ba:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801002c0:	74 d2                	je     80100294 <consoleread+0x40>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002c2:	8d 50 01             	lea    0x1(%eax),%edx
801002c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
801002cb:	89 c2                	mov    %eax,%edx
801002cd:	83 e2 7f             	and    $0x7f,%edx
801002d0:	0f b6 14 13          	movzbl (%ebx,%edx,1),%edx
801002d4:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
801002d7:	80 fa 04             	cmp    $0x4,%dl
801002da:	74 58                	je     80100334 <consoleread+0xe0>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002dc:	83 c7 01             	add    $0x1,%edi
801002df:	88 57 ff             	mov    %dl,-0x1(%edi)
    --n;
801002e2:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002e5:	83 f9 0a             	cmp    $0xa,%ecx
801002e8:	75 98                	jne    80100282 <consoleread+0x2e>
      break;
  }
  release(&cons.lock);
801002ea:	83 ec 0c             	sub    $0xc,%esp
801002ed:	68 20 ff 10 80       	push   $0x8010ff20
801002f2:	e8 71 3a 00 00       	call   80103d68 <release>
  ilock(ip);
801002f7:	83 c4 04             	add    $0x4,%esp
801002fa:	ff 75 08             	push   0x8(%ebp)
801002fd:	e8 b1 11 00 00       	call   801014b3 <ilock>

  return target - n;
80100302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100305:	29 f0                	sub    %esi,%eax
80100307:	83 c4 10             	add    $0x10,%esp
8010030a:	eb 20                	jmp    8010032c <consoleread+0xd8>
        release(&cons.lock);
8010030c:	83 ec 0c             	sub    $0xc,%esp
8010030f:	68 20 ff 10 80       	push   $0x8010ff20
80100314:	e8 4f 3a 00 00       	call   80103d68 <release>
        ilock(ip);
80100319:	83 c4 04             	add    $0x4,%esp
8010031c:	ff 75 08             	push   0x8(%ebp)
8010031f:	e8 8f 11 00 00       	call   801014b3 <ilock>
        return -1;
80100324:	83 c4 10             	add    $0x10,%esp
80100327:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret    
      if(n < target){
80100334:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80100337:	73 b1                	jae    801002ea <consoleread+0x96>
        input.r--;
80100339:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
8010033e:	eb aa                	jmp    801002ea <consoleread+0x96>

80100340 <panic>:
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	56                   	push   %esi
80100344:	53                   	push   %ebx
80100345:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100348:	fa                   	cli    
  cons.locking = 0;
80100349:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100350:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100353:	e8 c2 20 00 00       	call   8010241a <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 cd 75 10 80       	push   $0x801075cd
80100361:	e8 9b 02 00 00       	call   80100601 <cprintf>
  cprintf(s);
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 90 02 00 00       	call   80100601 <cprintf>
  cprintf("\n");
80100371:	c7 04 24 3f 7f 10 80 	movl   $0x80107f3f,(%esp)
80100378:	e8 84 02 00 00       	call   80100601 <cprintf>
  getcallerpcs(&s, pcs);
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100383:	53                   	push   %ebx
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 46 38 00 00       	call   80103bd3 <getcallerpcs>
  for(i=0; i<10; i++)
8010038d:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100390:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100393:	83 ec 08             	sub    $0x8,%esp
80100396:	ff 33                	push   (%ebx)
80100398:	68 97 7b 10 80       	push   $0x80107b97
8010039d:	e8 5f 02 00 00       	call   80100601 <cprintf>
  for(i=0; i<10; i++)
801003a2:	83 c3 04             	add    $0x4,%ebx
801003a5:	83 c4 10             	add    $0x10,%esp
801003a8:	39 f3                	cmp    %esi,%ebx
801003aa:	75 e7                	jne    80100393 <panic+0x53>
  panicked = 1; // freeze other CPU
801003ac:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003b3:	00 00 00 
  for(;;)
801003b6:	eb fe                	jmp    801003b6 <panic+0x76>

801003b8 <consputc>:
  if(panicked){
801003b8:	83 3d 58 ff 10 80 00 	cmpl   $0x0,0x8010ff58
801003bf:	74 03                	je     801003c4 <consputc+0xc>
801003c1:	fa                   	cli    
    for(;;)
801003c2:	eb fe                	jmp    801003c2 <consputc+0xa>
{
801003c4:	55                   	push   %ebp
801003c5:	89 e5                	mov    %esp,%ebp
801003c7:	57                   	push   %edi
801003c8:	56                   	push   %esi
801003c9:	53                   	push   %ebx
801003ca:	83 ec 0c             	sub    $0xc,%esp
801003cd:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801003cf:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d4:	0f 84 ae 00 00 00    	je     80100488 <consputc+0xd0>
    uartputc(c);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 4a 4d 00 00       	call   8010512d <uartputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e6:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f0:	89 fa                	mov    %edi,%edx
801003f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f3:	be d5 03 00 00       	mov    $0x3d5,%esi
801003f8:	89 f2                	mov    %esi,%edx
801003fa:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fb:	0f b6 c8             	movzbl %al,%ecx
801003fe:	c1 e1 08             	shl    $0x8,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100401:	b8 0f 00 00 00       	mov    $0xf,%eax
80100406:	89 fa                	mov    %edi,%edx
80100408:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100409:	89 f2                	mov    %esi,%edx
8010040b:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040c:	0f b6 c0             	movzbl %al,%eax
8010040f:	09 c8                	or     %ecx,%eax
  if(c == '\n')
80100411:	83 fb 0a             	cmp    $0xa,%ebx
80100414:	0f 84 98 00 00 00    	je     801004b2 <consputc+0xfa>
  else if(c == BACKSPACE){
8010041a:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100420:	0f 84 a4 00 00 00    	je     801004ca <consputc+0x112>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100426:	8d 70 01             	lea    0x1(%eax),%esi
80100429:	0f b6 db             	movzbl %bl,%ebx
8010042c:	80 cf 07             	or     $0x7,%bh
8010042f:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100436:	80 
  if(pos < 0 || pos > 25*80)
80100437:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010043d:	0f 87 94 00 00 00    	ja     801004d7 <consputc+0x11f>
  if((pos/80) >= 24){  // Scroll up.
80100443:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100449:	0f 8f 95 00 00 00    	jg     801004e4 <consputc+0x12c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044f:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100454:	b8 0e 00 00 00       	mov    $0xe,%eax
80100459:	89 da                	mov    %ebx,%edx
8010045b:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010045c:	89 f0                	mov    %esi,%eax
8010045e:	c1 f8 08             	sar    $0x8,%eax
80100461:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100466:	89 ca                	mov    %ecx,%edx
80100468:	ee                   	out    %al,(%dx)
80100469:	b8 0f 00 00 00       	mov    $0xf,%eax
8010046e:	89 da                	mov    %ebx,%edx
80100470:	ee                   	out    %al,(%dx)
80100471:	89 f0                	mov    %esi,%eax
80100473:	89 ca                	mov    %ecx,%edx
80100475:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100476:	66 c7 84 36 00 80 0b 	movw   $0x720,-0x7ff48000(%esi,%esi,1)
8010047d:	80 20 07 
}
80100480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100483:	5b                   	pop    %ebx
80100484:	5e                   	pop    %esi
80100485:	5f                   	pop    %edi
80100486:	5d                   	pop    %ebp
80100487:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100488:	83 ec 0c             	sub    $0xc,%esp
8010048b:	6a 08                	push   $0x8
8010048d:	e8 9b 4c 00 00       	call   8010512d <uartputc>
80100492:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100499:	e8 8f 4c 00 00       	call   8010512d <uartputc>
8010049e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004a5:	e8 83 4c 00 00       	call   8010512d <uartputc>
801004aa:	83 c4 10             	add    $0x10,%esp
801004ad:	e9 34 ff ff ff       	jmp    801003e6 <consputc+0x2e>
    pos += 80 - pos%80;
801004b2:	ba 67 66 66 66       	mov    $0x66666667,%edx
801004b7:	f7 ea                	imul   %edx
801004b9:	c1 fa 05             	sar    $0x5,%edx
801004bc:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004bf:	c1 e0 04             	shl    $0x4,%eax
801004c2:	8d 70 50             	lea    0x50(%eax),%esi
801004c5:	e9 6d ff ff ff       	jmp    80100437 <consputc+0x7f>
    if(pos > 0) --pos;
801004ca:	83 f8 01             	cmp    $0x1,%eax
801004cd:	83 d0 ff             	adc    $0xffffffff,%eax
801004d0:	89 c6                	mov    %eax,%esi
801004d2:	e9 60 ff ff ff       	jmp    80100437 <consputc+0x7f>
    panic("pos under/overflow");
801004d7:	83 ec 0c             	sub    $0xc,%esp
801004da:	68 e1 75 10 80       	push   $0x801075e1
801004df:	e8 5c fe ff ff       	call   80100340 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e4:	83 ec 04             	sub    $0x4,%esp
801004e7:	68 60 0e 00 00       	push   $0xe60
801004ec:	68 a0 80 0b 80       	push   $0x800b80a0
801004f1:	68 00 80 0b 80       	push   $0x800b8000
801004f6:	e8 39 39 00 00       	call   80103e34 <memmove>
    pos -= 80;
801004fb:	83 ee 50             	sub    $0x50,%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004fe:	83 c4 0c             	add    $0xc,%esp
80100501:	b8 80 07 00 00       	mov    $0x780,%eax
80100506:	29 f0                	sub    %esi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	50                   	push   %eax
8010050b:	6a 00                	push   $0x0
8010050d:	8d 84 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%eax
80100514:	50                   	push   %eax
80100515:	e8 95 38 00 00       	call   80103daf <memset>
8010051a:	83 c4 10             	add    $0x10,%esp
8010051d:	e9 2d ff ff ff       	jmp    8010044f <consputc+0x97>

80100522 <printint>:
{
80100522:	55                   	push   %ebp
80100523:	89 e5                	mov    %esp,%ebp
80100525:	57                   	push   %edi
80100526:	56                   	push   %esi
80100527:	53                   	push   %ebx
80100528:	83 ec 2c             	sub    $0x2c,%esp
8010052b:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
8010052d:	85 c9                	test   %ecx,%ecx
8010052f:	74 04                	je     80100535 <printint+0x13>
80100531:	85 c0                	test   %eax,%eax
80100533:	78 61                	js     80100596 <printint+0x74>
    x = xx;
80100535:	89 c1                	mov    %eax,%ecx
80100537:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010053e:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100543:	89 df                	mov    %ebx,%edi
80100545:	83 c3 01             	add    $0x1,%ebx
80100548:	89 c8                	mov    %ecx,%eax
8010054a:	ba 00 00 00 00       	mov    $0x0,%edx
8010054f:	f7 f6                	div    %esi
80100551:	0f b6 92 0c 76 10 80 	movzbl -0x7fef89f4(%edx),%edx
80100558:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
8010055c:	89 ca                	mov    %ecx,%edx
8010055e:	89 c1                	mov    %eax,%ecx
80100560:	39 d6                	cmp    %edx,%esi
80100562:	76 df                	jbe    80100543 <printint+0x21>
  if(sign)
80100564:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100568:	74 08                	je     80100572 <printint+0x50>
    buf[i++] = '-';
8010056a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010056f:	8d 5f 02             	lea    0x2(%edi),%ebx
  while(--i >= 0)
80100572:	85 db                	test   %ebx,%ebx
80100574:	7e 18                	jle    8010058e <printint+0x6c>
80100576:	8d 75 d8             	lea    -0x28(%ebp),%esi
80100579:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
    consputc(buf[i]);
8010057d:	0f be 03             	movsbl (%ebx),%eax
80100580:	e8 33 fe ff ff       	call   801003b8 <consputc>
  while(--i >= 0)
80100585:	89 d8                	mov    %ebx,%eax
80100587:	83 eb 01             	sub    $0x1,%ebx
8010058a:	39 f0                	cmp    %esi,%eax
8010058c:	75 ef                	jne    8010057d <printint+0x5b>
}
8010058e:	83 c4 2c             	add    $0x2c,%esp
80100591:	5b                   	pop    %ebx
80100592:	5e                   	pop    %esi
80100593:	5f                   	pop    %edi
80100594:	5d                   	pop    %ebp
80100595:	c3                   	ret    
    x = -xx;
80100596:	f7 d8                	neg    %eax
80100598:	89 c1                	mov    %eax,%ecx
  if(sign && (sign = xx < 0))
8010059a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801005a1:	eb 9b                	jmp    8010053e <printint+0x1c>

801005a3 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005a3:	55                   	push   %ebp
801005a4:	89 e5                	mov    %esp,%ebp
801005a6:	57                   	push   %edi
801005a7:	56                   	push   %esi
801005a8:	53                   	push   %ebx
801005a9:	83 ec 18             	sub    $0x18,%esp
801005ac:	8b 7d 08             	mov    0x8(%ebp),%edi
801005af:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  iunlock(ip);
801005b2:	57                   	push   %edi
801005b3:	e8 bd 0f 00 00       	call   80101575 <iunlock>
  acquire(&cons.lock);
801005b8:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005bf:	e8 3d 37 00 00       	call   80103d01 <acquire>
  for(i = 0; i < n; i++)
801005c4:	83 c4 10             	add    $0x10,%esp
801005c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801005cb:	7e 14                	jle    801005e1 <consolewrite+0x3e>
801005cd:	89 f3                	mov    %esi,%ebx
801005cf:	03 75 10             	add    0x10(%ebp),%esi
    consputc(buf[i] & 0xff);
801005d2:	0f b6 03             	movzbl (%ebx),%eax
801005d5:	e8 de fd ff ff       	call   801003b8 <consputc>
  for(i = 0; i < n; i++)
801005da:	83 c3 01             	add    $0x1,%ebx
801005dd:	39 f3                	cmp    %esi,%ebx
801005df:	75 f1                	jne    801005d2 <consolewrite+0x2f>
  release(&cons.lock);
801005e1:	83 ec 0c             	sub    $0xc,%esp
801005e4:	68 20 ff 10 80       	push   $0x8010ff20
801005e9:	e8 7a 37 00 00       	call   80103d68 <release>
  ilock(ip);
801005ee:	89 3c 24             	mov    %edi,(%esp)
801005f1:	e8 bd 0e 00 00       	call   801014b3 <ilock>

  return n;
}
801005f6:	8b 45 10             	mov    0x10(%ebp),%eax
801005f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005fc:	5b                   	pop    %ebx
801005fd:	5e                   	pop    %esi
801005fe:	5f                   	pop    %edi
801005ff:	5d                   	pop    %ebp
80100600:	c3                   	ret    

80100601 <cprintf>:
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	57                   	push   %edi
80100605:	56                   	push   %esi
80100606:	53                   	push   %ebx
80100607:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010060a:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
8010060f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100612:	85 c0                	test   %eax,%eax
80100614:	75 2b                	jne    80100641 <cprintf+0x40>
  if (fmt == 0)
80100616:	8b 7d 08             	mov    0x8(%ebp),%edi
80100619:	85 ff                	test   %edi,%edi
8010061b:	74 36                	je     80100653 <cprintf+0x52>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010061d:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100620:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100623:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100626:	bb 00 00 00 00       	mov    $0x0,%ebx
8010062b:	85 c0                	test   %eax,%eax
8010062d:	75 41                	jne    80100670 <cprintf+0x6f>
  if(locking)
8010062f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100633:	0f 85 0e 01 00 00    	jne    80100747 <cprintf+0x146>
}
80100639:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010063c:	5b                   	pop    %ebx
8010063d:	5e                   	pop    %esi
8010063e:	5f                   	pop    %edi
8010063f:	5d                   	pop    %ebp
80100640:	c3                   	ret    
    acquire(&cons.lock);
80100641:	83 ec 0c             	sub    $0xc,%esp
80100644:	68 20 ff 10 80       	push   $0x8010ff20
80100649:	e8 b3 36 00 00       	call   80103d01 <acquire>
8010064e:	83 c4 10             	add    $0x10,%esp
80100651:	eb c3                	jmp    80100616 <cprintf+0x15>
    panic("null fmt");
80100653:	83 ec 0c             	sub    $0xc,%esp
80100656:	68 fb 75 10 80       	push   $0x801075fb
8010065b:	e8 e0 fc ff ff       	call   80100340 <panic>
      consputc(c);
80100660:	e8 53 fd ff ff       	call   801003b8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100665:	83 c3 01             	add    $0x1,%ebx
80100668:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	74 bf                	je     8010062f <cprintf+0x2e>
    if(c != '%'){
80100670:	83 f8 25             	cmp    $0x25,%eax
80100673:	75 eb                	jne    80100660 <cprintf+0x5f>
    c = fmt[++i] & 0xff;
80100675:	83 c3 01             	add    $0x1,%ebx
80100678:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
8010067c:	85 f6                	test   %esi,%esi
8010067e:	74 af                	je     8010062f <cprintf+0x2e>
    switch(c){
80100680:	83 fe 70             	cmp    $0x70,%esi
80100683:	74 3a                	je     801006bf <cprintf+0xbe>
80100685:	7f 2e                	jg     801006b5 <cprintf+0xb4>
80100687:	83 fe 25             	cmp    $0x25,%esi
8010068a:	0f 84 92 00 00 00    	je     80100722 <cprintf+0x121>
80100690:	83 fe 64             	cmp    $0x64,%esi
80100693:	0f 85 98 00 00 00    	jne    80100731 <cprintf+0x130>
      printint(*argp++, 10, 1);
80100699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010069c:	8d 70 04             	lea    0x4(%eax),%esi
8010069f:	b9 01 00 00 00       	mov    $0x1,%ecx
801006a4:	ba 0a 00 00 00       	mov    $0xa,%edx
801006a9:	8b 00                	mov    (%eax),%eax
801006ab:	e8 72 fe ff ff       	call   80100522 <printint>
801006b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006b3:	eb b0                	jmp    80100665 <cprintf+0x64>
    switch(c){
801006b5:	83 fe 73             	cmp    $0x73,%esi
801006b8:	74 21                	je     801006db <cprintf+0xda>
801006ba:	83 fe 78             	cmp    $0x78,%esi
801006bd:	75 72                	jne    80100731 <cprintf+0x130>
      printint(*argp++, 16, 0);
801006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006c2:	8d 70 04             	lea    0x4(%eax),%esi
801006c5:	b9 00 00 00 00       	mov    $0x0,%ecx
801006ca:	ba 10 00 00 00       	mov    $0x10,%edx
801006cf:	8b 00                	mov    (%eax),%eax
801006d1:	e8 4c fe ff ff       	call   80100522 <printint>
801006d6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006d9:	eb 8a                	jmp    80100665 <cprintf+0x64>
      if((s = (char*)*argp++) == 0)
801006db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006de:	8d 50 04             	lea    0x4(%eax),%edx
801006e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801006e4:	8b 00                	mov    (%eax),%eax
801006e6:	85 c0                	test   %eax,%eax
801006e8:	74 11                	je     801006fb <cprintf+0xfa>
801006ea:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
801006ec:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
801006ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
801006f2:	84 c0                	test   %al,%al
801006f4:	75 0f                	jne    80100705 <cprintf+0x104>
801006f6:	e9 6a ff ff ff       	jmp    80100665 <cprintf+0x64>
        s = "(null)";
801006fb:	be f4 75 10 80       	mov    $0x801075f4,%esi
      for(; *s; s++)
80100700:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
80100705:	0f be c0             	movsbl %al,%eax
80100708:	e8 ab fc ff ff       	call   801003b8 <consputc>
      for(; *s; s++)
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 06             	movzbl (%esi),%eax
80100713:	84 c0                	test   %al,%al
80100715:	75 ee                	jne    80100705 <cprintf+0x104>
      if((s = (char*)*argp++) == 0)
80100717:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010071d:	e9 43 ff ff ff       	jmp    80100665 <cprintf+0x64>
      consputc('%');
80100722:	b8 25 00 00 00       	mov    $0x25,%eax
80100727:	e8 8c fc ff ff       	call   801003b8 <consputc>
      break;
8010072c:	e9 34 ff ff ff       	jmp    80100665 <cprintf+0x64>
      consputc('%');
80100731:	b8 25 00 00 00       	mov    $0x25,%eax
80100736:	e8 7d fc ff ff       	call   801003b8 <consputc>
      consputc(c);
8010073b:	89 f0                	mov    %esi,%eax
8010073d:	e8 76 fc ff ff       	call   801003b8 <consputc>
      break;
80100742:	e9 1e ff ff ff       	jmp    80100665 <cprintf+0x64>
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 ff 10 80       	push   $0x8010ff20
8010074f:	e8 14 36 00 00       	call   80103d68 <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	e9 dd fe ff ff       	jmp    80100639 <cprintf+0x38>

8010075c <consoleintr>:
{
8010075c:	55                   	push   %ebp
8010075d:	89 e5                	mov    %esp,%ebp
8010075f:	57                   	push   %edi
80100760:	56                   	push   %esi
80100761:	53                   	push   %ebx
80100762:	83 ec 28             	sub    $0x28,%esp
80100765:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100768:	68 20 ff 10 80       	push   $0x8010ff20
8010076d:	e8 8f 35 00 00       	call   80103d01 <acquire>
  while((c = getc()) >= 0){
80100772:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100775:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      while(input.e != input.w &&
8010077c:	bb 80 fe 10 80       	mov    $0x8010fe80,%ebx
  while((c = getc()) >= 0){
80100781:	eb 19                	jmp    8010079c <consoleintr+0x40>
    switch(c){
80100783:	83 fe 08             	cmp    $0x8,%esi
80100786:	0f 84 cf 00 00 00    	je     8010085b <consoleintr+0xff>
8010078c:	83 fe 10             	cmp    $0x10,%esi
8010078f:	0f 85 f0 00 00 00    	jne    80100885 <consoleintr+0x129>
80100795:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
8010079c:	ff d7                	call   *%edi
8010079e:	89 c6                	mov    %eax,%esi
801007a0:	85 c0                	test   %eax,%eax
801007a2:	0f 88 ea 00 00 00    	js     80100892 <consoleintr+0x136>
    switch(c){
801007a8:	83 fe 15             	cmp    $0x15,%esi
801007ab:	74 67                	je     80100814 <consoleintr+0xb8>
801007ad:	7e d4                	jle    80100783 <consoleintr+0x27>
801007af:	83 fe 7f             	cmp    $0x7f,%esi
801007b2:	0f 84 a3 00 00 00    	je     8010085b <consoleintr+0xff>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007b8:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801007be:	89 c2                	mov    %eax,%edx
801007c0:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
801007c6:	83 fa 7f             	cmp    $0x7f,%edx
801007c9:	77 d1                	ja     8010079c <consoleintr+0x40>
        c = (c == '\r') ? '\n' : c;
801007cb:	83 fe 0d             	cmp    $0xd,%esi
801007ce:	0f 84 e3 00 00 00    	je     801008b7 <consoleintr+0x15b>
        input.buf[input.e++ % INPUT_BUF] = c;
801007d4:	8d 50 01             	lea    0x1(%eax),%edx
801007d7:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
801007dd:	83 e0 7f             	and    $0x7f,%eax
801007e0:	89 f1                	mov    %esi,%ecx
801007e2:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        consputc(c);
801007e5:	89 f0                	mov    %esi,%eax
801007e7:	e8 cc fb ff ff       	call   801003b8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ec:	83 fe 0a             	cmp    $0xa,%esi
801007ef:	0f 84 dc 00 00 00    	je     801008d1 <consoleintr+0x175>
801007f5:	83 fe 04             	cmp    $0x4,%esi
801007f8:	0f 84 d3 00 00 00    	je     801008d1 <consoleintr+0x175>
801007fe:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80100804:	83 e8 80             	sub    $0xffffff80,%eax
80100807:	39 83 88 00 00 00    	cmp    %eax,0x88(%ebx)
8010080d:	75 8d                	jne    8010079c <consoleintr+0x40>
8010080f:	e9 bd 00 00 00       	jmp    801008d1 <consoleintr+0x175>
      while(input.e != input.w &&
80100814:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010081a:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100820:	0f 84 76 ff ff ff    	je     8010079c <consoleintr+0x40>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100826:	83 e8 01             	sub    $0x1,%eax
80100829:	89 c2                	mov    %eax,%edx
8010082b:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010082e:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
80100832:	0f 84 64 ff ff ff    	je     8010079c <consoleintr+0x40>
        input.e--;
80100838:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
8010083e:	b8 00 01 00 00       	mov    $0x100,%eax
80100843:	e8 70 fb ff ff       	call   801003b8 <consputc>
      while(input.e != input.w &&
80100848:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010084e:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100854:	75 d0                	jne    80100826 <consoleintr+0xca>
80100856:	e9 41 ff ff ff       	jmp    8010079c <consoleintr+0x40>
      if(input.e != input.w){
8010085b:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100861:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100867:	0f 84 2f ff ff ff    	je     8010079c <consoleintr+0x40>
        input.e--;
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
80100876:	b8 00 01 00 00       	mov    $0x100,%eax
8010087b:	e8 38 fb ff ff       	call   801003b8 <consputc>
80100880:	e9 17 ff ff ff       	jmp    8010079c <consoleintr+0x40>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 f6                	test   %esi,%esi
80100887:	0f 84 0f ff ff ff    	je     8010079c <consoleintr+0x40>
8010088d:	e9 26 ff ff ff       	jmp    801007b8 <consoleintr+0x5c>
  release(&cons.lock);
80100892:	83 ec 0c             	sub    $0xc,%esp
80100895:	68 20 ff 10 80       	push   $0x8010ff20
8010089a:	e8 c9 34 00 00       	call   80103d68 <release>
  if(doprocdump) {
8010089f:	83 c4 10             	add    $0x10,%esp
801008a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801008a6:	75 08                	jne    801008b0 <consoleintr+0x154>
}
801008a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008ab:	5b                   	pop    %ebx
801008ac:	5e                   	pop    %esi
801008ad:	5f                   	pop    %edi
801008ae:	5d                   	pop    %ebp
801008af:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008b0:	e8 bf 30 00 00       	call   80103974 <procdump>
}
801008b5:	eb f1                	jmp    801008a8 <consoleintr+0x14c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b7:	8d 50 01             	lea    0x1(%eax),%edx
801008ba:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
801008c0:	83 e0 7f             	and    $0x7f,%eax
801008c3:	c6 04 03 0a          	movb   $0xa,(%ebx,%eax,1)
        consputc(c);
801008c7:	b8 0a 00 00 00       	mov    $0xa,%eax
801008cc:	e8 e7 fa ff ff       	call   801003b8 <consputc>
          input.w = input.e;
801008d1:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801008d7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
          wakeup(&input.r);
801008dd:	83 ec 0c             	sub    $0xc,%esp
801008e0:	68 00 ff 10 80       	push   $0x8010ff00
801008e5:	e8 ed 2f 00 00       	call   801038d7 <wakeup>
801008ea:	83 c4 10             	add    $0x10,%esp
801008ed:	e9 aa fe ff ff       	jmp    8010079c <consoleintr+0x40>

801008f2 <consoleinit>:

void
consoleinit(void)
{
801008f2:	55                   	push   %ebp
801008f3:	89 e5                	mov    %esp,%ebp
801008f5:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008f8:	68 04 76 10 80       	push   $0x80107604
801008fd:	68 20 ff 10 80       	push   $0x8010ff20
80100902:	e8 b1 32 00 00       	call   80103bb8 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100907:	c7 05 0c 09 11 80 a3 	movl   $0x801005a3,0x8011090c
8010090e:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100911:	c7 05 08 09 11 80 54 	movl   $0x80100254,0x80110908
80100918:	02 10 80 
  cons.locking = 1;
8010091b:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100922:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100925:	83 c4 08             	add    $0x8,%esp
80100928:	6a 00                	push   $0x0
8010092a:	6a 01                	push   $0x1
8010092c:	e8 98 16 00 00       	call   80101fc9 <ioapicenable>
}
80100931:	83 c4 10             	add    $0x10,%esp
80100934:	c9                   	leave  
80100935:	c3                   	ret    

80100936 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100936:	55                   	push   %ebp
80100937:	89 e5                	mov    %esp,%ebp
80100939:	57                   	push   %edi
8010093a:	56                   	push   %esi
8010093b:	53                   	push   %ebx
8010093c:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100942:	e8 69 29 00 00       	call   801032b0 <myproc>
80100947:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010094d:	e8 2c 1e 00 00       	call   8010277e <begin_op>

  if((ip = namei(path)) == 0){
80100952:	83 ec 0c             	sub    $0xc,%esp
80100955:	ff 75 08             	push   0x8(%ebp)
80100958:	e8 e4 12 00 00       	call   80101c41 <namei>
8010095d:	83 c4 10             	add    $0x10,%esp
80100960:	85 c0                	test   %eax,%eax
80100962:	74 4e                	je     801009b2 <exec+0x7c>
80100964:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100966:	83 ec 0c             	sub    $0xc,%esp
80100969:	50                   	push   %eax
8010096a:	e8 44 0b 00 00       	call   801014b3 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010096f:	6a 34                	push   $0x34
80100971:	6a 00                	push   $0x0
80100973:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100979:	50                   	push   %eax
8010097a:	53                   	push   %ebx
8010097b:	e8 c7 0d 00 00       	call   80101747 <readi>
80100980:	83 c4 20             	add    $0x20,%esp
80100983:	83 f8 34             	cmp    $0x34,%eax
80100986:	75 0c                	jne    80100994 <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100988:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010098f:	45 4c 46 
80100992:	74 3a                	je     801009ce <exec+0x98>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100994:	83 ec 0c             	sub    $0xc,%esp
80100997:	53                   	push   %ebx
80100998:	e8 5f 0d 00 00       	call   801016fc <iunlockput>
    end_op();
8010099d:	e8 57 1e 00 00       	call   801027f9 <end_op>
801009a2:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801009a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801009aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ad:	5b                   	pop    %ebx
801009ae:	5e                   	pop    %esi
801009af:	5f                   	pop    %edi
801009b0:	5d                   	pop    %ebp
801009b1:	c3                   	ret    
    end_op();
801009b2:	e8 42 1e 00 00       	call   801027f9 <end_op>
    cprintf("exec: fail\n");
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 1d 76 10 80       	push   $0x8010761d
801009bf:	e8 3d fc ff ff       	call   80100601 <cprintf>
    return -1;
801009c4:	83 c4 10             	add    $0x10,%esp
801009c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009cc:	eb dc                	jmp    801009aa <exec+0x74>
  if((pgdir = setupkvm()) == 0)
801009ce:	e8 be 58 00 00       	call   80106291 <setupkvm>
801009d3:	89 c7                	mov    %eax,%edi
801009d5:	85 c0                	test   %eax,%eax
801009d7:	74 bb                	je     80100994 <exec+0x5e>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009d9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
801009df:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801009e6:	00 
801009e7:	0f 84 c3 00 00 00    	je     80100ab0 <exec+0x17a>
  sz = 0;
801009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801009f4:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009f7:	be 00 00 00 00       	mov    $0x0,%esi
801009fc:	eb 1b                	jmp    80100a19 <exec+0xe3>
801009fe:	83 c6 01             	add    $0x1,%esi
80100a01:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a07:	83 c0 20             	add    $0x20,%eax
80100a0a:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100a11:	39 f2                	cmp    %esi,%edx
80100a13:	0f 8e a1 00 00 00    	jle    80100aba <exec+0x184>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a19:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a1f:	6a 20                	push   $0x20
80100a21:	50                   	push   %eax
80100a22:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a28:	50                   	push   %eax
80100a29:	53                   	push   %ebx
80100a2a:	e8 18 0d 00 00       	call   80101747 <readi>
80100a2f:	83 c4 10             	add    $0x10,%esp
80100a32:	83 f8 20             	cmp    $0x20,%eax
80100a35:	0f 85 c0 00 00 00    	jne    80100afb <exec+0x1c5>
    if(ph.type != ELF_PROG_LOAD)
80100a3b:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a42:	75 ba                	jne    801009fe <exec+0xc8>
    if(ph.memsz < ph.filesz)
80100a44:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a4a:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a50:	0f 82 a5 00 00 00    	jb     80100afb <exec+0x1c5>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a56:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a5c:	0f 82 99 00 00 00    	jb     80100afb <exec+0x1c5>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a62:	83 ec 04             	sub    $0x4,%esp
80100a65:	50                   	push   %eax
80100a66:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a6c:	57                   	push   %edi
80100a6d:	e8 be 56 00 00       	call   80106130 <allocuvm>
80100a72:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a78:	83 c4 10             	add    $0x10,%esp
80100a7b:	85 c0                	test   %eax,%eax
80100a7d:	74 7c                	je     80100afb <exec+0x1c5>
    if(ph.vaddr % PGSIZE != 0)
80100a7f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a85:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a8a:	75 6f                	jne    80100afb <exec+0x1c5>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100a95:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100a9b:	53                   	push   %ebx
80100a9c:	50                   	push   %eax
80100a9d:	57                   	push   %edi
80100a9e:	e8 53 55 00 00       	call   80105ff6 <loaduvm>
80100aa3:	83 c4 20             	add    $0x20,%esp
80100aa6:	85 c0                	test   %eax,%eax
80100aa8:	0f 89 50 ff ff ff    	jns    801009fe <exec+0xc8>
80100aae:	eb 4b                	jmp    80100afb <exec+0x1c5>
  sz = 0;
80100ab0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ab7:	00 00 00 
  iunlockput(ip);
80100aba:	83 ec 0c             	sub    $0xc,%esp
80100abd:	53                   	push   %ebx
80100abe:	e8 39 0c 00 00       	call   801016fc <iunlockput>
  end_op();
80100ac3:	e8 31 1d 00 00       	call   801027f9 <end_op>
  sz = PGROUNDUP(sz);
80100ac8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ace:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ad3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ad8:	83 c4 0c             	add    $0xc,%esp
80100adb:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100ae1:	52                   	push   %edx
80100ae2:	50                   	push   %eax
80100ae3:	57                   	push   %edi
80100ae4:	e8 47 56 00 00       	call   80106130 <allocuvm>
80100ae9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aef:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100af2:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100af7:	85 c0                	test   %eax,%eax
80100af9:	75 1e                	jne    80100b19 <exec+0x1e3>
    freevm(pgdir);
80100afb:	83 ec 0c             	sub    $0xc,%esp
80100afe:	57                   	push   %edi
80100aff:	e8 1a 57 00 00       	call   8010621e <freevm>
  if(ip){
80100b04:	83 c4 10             	add    $0x10,%esp
80100b07:	85 db                	test   %ebx,%ebx
80100b09:	0f 85 85 fe ff ff    	jne    80100994 <exec+0x5e>
  return -1;
80100b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b14:	e9 91 fe ff ff       	jmp    801009aa <exec+0x74>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b19:	83 ec 08             	sub    $0x8,%esp
80100b1c:	89 c3                	mov    %eax,%ebx
80100b1e:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b24:	50                   	push   %eax
80100b25:	57                   	push   %edi
80100b26:	e8 eb 57 00 00       	call   80106316 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b2e:	8b 00                	mov    (%eax),%eax
80100b30:	83 c4 10             	add    $0x10,%esp
80100b33:	be 00 00 00 00       	mov    $0x0,%esi
80100b38:	85 c0                	test   %eax,%eax
80100b3a:	74 5e                	je     80100b9a <exec+0x264>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	50                   	push   %eax
80100b40:	e8 20 34 00 00       	call   80103f65 <strlen>
80100b45:	29 c3                	sub    %eax,%ebx
80100b47:	83 eb 01             	sub    $0x1,%ebx
80100b4a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b4d:	83 c4 04             	add    $0x4,%esp
80100b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b53:	ff 34 b0             	push   (%eax,%esi,4)
80100b56:	e8 0a 34 00 00       	call   80103f65 <strlen>
80100b5b:	83 c0 01             	add    $0x1,%eax
80100b5e:	50                   	push   %eax
80100b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b62:	ff 34 b0             	push   (%eax,%esi,4)
80100b65:	53                   	push   %ebx
80100b66:	57                   	push   %edi
80100b67:	e8 f5 58 00 00       	call   80106461 <copyout>
80100b6c:	83 c4 20             	add    $0x20,%esp
80100b6f:	85 c0                	test   %eax,%eax
80100b71:	0f 88 f0 00 00 00    	js     80100c67 <exec+0x331>
    ustack[3+argc] = sp;
80100b77:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b7e:	83 c6 01             	add    $0x1,%esi
80100b81:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b84:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b87:	85 c0                	test   %eax,%eax
80100b89:	74 15                	je     80100ba0 <exec+0x26a>
    if(argc >= MAXARG)
80100b8b:	83 fe 20             	cmp    $0x20,%esi
80100b8e:	75 ac                	jne    80100b3c <exec+0x206>
  ip = 0;
80100b90:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b95:	e9 61 ff ff ff       	jmp    80100afb <exec+0x1c5>
  sp = sz;
80100b9a:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
  ustack[3+argc] = 0;
80100ba0:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100ba7:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100bab:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100bb2:	ff ff ff 
  ustack[1] = argc;
80100bb5:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bbb:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100bc2:	89 da                	mov    %ebx,%edx
80100bc4:	29 c2                	sub    %eax,%edx
80100bc6:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100bcc:	83 c0 0c             	add    $0xc,%eax
80100bcf:	89 de                	mov    %ebx,%esi
80100bd1:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bd3:	50                   	push   %eax
80100bd4:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100bda:	50                   	push   %eax
80100bdb:	56                   	push   %esi
80100bdc:	57                   	push   %edi
80100bdd:	e8 7f 58 00 00       	call   80106461 <copyout>
80100be2:	83 c4 10             	add    $0x10,%esp
80100be5:	85 c0                	test   %eax,%eax
80100be7:	0f 88 84 00 00 00    	js     80100c71 <exec+0x33b>
  for(last=s=path; *s; s++)
80100bed:	8b 45 08             	mov    0x8(%ebp),%eax
80100bf0:	0f b6 10             	movzbl (%eax),%edx
80100bf3:	84 d2                	test   %dl,%dl
80100bf5:	74 1a                	je     80100c11 <exec+0x2db>
80100bf7:	83 c0 01             	add    $0x1,%eax
80100bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100bfd:	80 fa 2f             	cmp    $0x2f,%dl
80100c00:	0f 44 c8             	cmove  %eax,%ecx
  for(last=s=path; *s; s++)
80100c03:	83 c0 01             	add    $0x1,%eax
80100c06:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100c0a:	84 d2                	test   %dl,%dl
80100c0c:	75 ef                	jne    80100bfd <exec+0x2c7>
80100c0e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c11:	83 ec 04             	sub    $0x4,%esp
80100c14:	6a 10                	push   $0x10
80100c16:	ff 75 08             	push   0x8(%ebp)
80100c19:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100c1f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80100c22:	50                   	push   %eax
80100c23:	e8 07 33 00 00       	call   80103f2f <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c28:	89 d9                	mov    %ebx,%ecx
80100c2a:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c2d:	89 79 04             	mov    %edi,0x4(%ecx)
  curproc->sz = sz;
80100c30:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c36:	89 39                	mov    %edi,(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100c38:	8b 41 18             	mov    0x18(%ecx),%eax
80100c3b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c41:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c44:	8b 41 18             	mov    0x18(%ecx),%eax
80100c47:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c4a:	89 0c 24             	mov    %ecx,(%esp)
80100c4d:	e8 3d 52 00 00       	call   80105e8f <switchuvm>
  freevm(oldpgdir);
80100c52:	89 1c 24             	mov    %ebx,(%esp)
80100c55:	e8 c4 55 00 00       	call   8010621e <freevm>
  return 0;
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
80100c62:	e9 43 fd ff ff       	jmp    801009aa <exec+0x74>
  ip = 0;
80100c67:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c6c:	e9 8a fe ff ff       	jmp    80100afb <exec+0x1c5>
80100c71:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c76:	e9 80 fe ff ff       	jmp    80100afb <exec+0x1c5>

80100c7b <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c7b:	55                   	push   %ebp
80100c7c:	89 e5                	mov    %esp,%ebp
80100c7e:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c81:	68 29 76 10 80       	push   $0x80107629
80100c86:	68 60 ff 10 80       	push   $0x8010ff60
80100c8b:	e8 28 2f 00 00       	call   80103bb8 <initlock>
}
80100c90:	83 c4 10             	add    $0x10,%esp
80100c93:	c9                   	leave  
80100c94:	c3                   	ret    

80100c95 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c95:	55                   	push   %ebp
80100c96:	89 e5                	mov    %esp,%ebp
80100c98:	53                   	push   %ebx
80100c99:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c9c:	68 60 ff 10 80       	push   $0x8010ff60
80100ca1:	e8 5b 30 00 00       	call   80103d01 <acquire>
80100ca6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ca9:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
    if(f->ref == 0){
80100cae:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100cb2:	74 22                	je     80100cd6 <filealloc+0x41>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cb4:	83 c3 18             	add    $0x18,%ebx
80100cb7:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100cbd:	75 ef                	jne    80100cae <filealloc+0x19>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100cbf:	83 ec 0c             	sub    $0xc,%esp
80100cc2:	68 60 ff 10 80       	push   $0x8010ff60
80100cc7:	e8 9c 30 00 00       	call   80103d68 <release>
  return 0;
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cd4:	eb 17                	jmp    80100ced <filealloc+0x58>
      f->ref = 1;
80100cd6:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cdd:	83 ec 0c             	sub    $0xc,%esp
80100ce0:	68 60 ff 10 80       	push   $0x8010ff60
80100ce5:	e8 7e 30 00 00       	call   80103d68 <release>
      return f;
80100cea:	83 c4 10             	add    $0x10,%esp
}
80100ced:	89 d8                	mov    %ebx,%eax
80100cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf2:	c9                   	leave  
80100cf3:	c3                   	ret    

80100cf4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cf4:	55                   	push   %ebp
80100cf5:	89 e5                	mov    %esp,%ebp
80100cf7:	53                   	push   %ebx
80100cf8:	83 ec 10             	sub    $0x10,%esp
80100cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cfe:	68 60 ff 10 80       	push   $0x8010ff60
80100d03:	e8 f9 2f 00 00       	call   80103d01 <acquire>
  if(f->ref < 1)
80100d08:	8b 43 04             	mov    0x4(%ebx),%eax
80100d0b:	83 c4 10             	add    $0x10,%esp
80100d0e:	85 c0                	test   %eax,%eax
80100d10:	7e 1a                	jle    80100d2c <filedup+0x38>
    panic("filedup");
  f->ref++;
80100d12:	83 c0 01             	add    $0x1,%eax
80100d15:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d18:	83 ec 0c             	sub    $0xc,%esp
80100d1b:	68 60 ff 10 80       	push   $0x8010ff60
80100d20:	e8 43 30 00 00       	call   80103d68 <release>
  return f;
}
80100d25:	89 d8                	mov    %ebx,%eax
80100d27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d2a:	c9                   	leave  
80100d2b:	c3                   	ret    
    panic("filedup");
80100d2c:	83 ec 0c             	sub    $0xc,%esp
80100d2f:	68 30 76 10 80       	push   $0x80107630
80100d34:	e8 07 f6 ff ff       	call   80100340 <panic>

80100d39 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d39:	55                   	push   %ebp
80100d3a:	89 e5                	mov    %esp,%ebp
80100d3c:	57                   	push   %edi
80100d3d:	56                   	push   %esi
80100d3e:	53                   	push   %ebx
80100d3f:	83 ec 28             	sub    $0x28,%esp
80100d42:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d45:	68 60 ff 10 80       	push   $0x8010ff60
80100d4a:	e8 b2 2f 00 00       	call   80103d01 <acquire>
  if(f->ref < 1)
80100d4f:	8b 43 04             	mov    0x4(%ebx),%eax
80100d52:	83 c4 10             	add    $0x10,%esp
80100d55:	85 c0                	test   %eax,%eax
80100d57:	7e 5d                	jle    80100db6 <fileclose+0x7d>
    panic("fileclose");
  if(--f->ref > 0){
80100d59:	83 e8 01             	sub    $0x1,%eax
80100d5c:	89 43 04             	mov    %eax,0x4(%ebx)
80100d5f:	85 c0                	test   %eax,%eax
80100d61:	7f 60                	jg     80100dc3 <fileclose+0x8a>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d63:	8b 33                	mov    (%ebx),%esi
80100d65:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100d69:	88 45 e7             	mov    %al,-0x19(%ebp)
80100d6c:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100d6f:	8b 43 10             	mov    0x10(%ebx),%eax
80100d72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100d75:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
80100d85:	68 60 ff 10 80       	push   $0x8010ff60
80100d8a:	e8 d9 2f 00 00       	call   80103d68 <release>

  if(ff.type == FD_PIPE)
80100d8f:	83 c4 10             	add    $0x10,%esp
80100d92:	83 fe 01             	cmp    $0x1,%esi
80100d95:	74 44                	je     80100ddb <fileclose+0xa2>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d97:	83 fe 02             	cmp    $0x2,%esi
80100d9a:	75 37                	jne    80100dd3 <fileclose+0x9a>
    begin_op();
80100d9c:	e8 dd 19 00 00       	call   8010277e <begin_op>
    iput(ff.ip);
80100da1:	83 ec 0c             	sub    $0xc,%esp
80100da4:	ff 75 e0             	push   -0x20(%ebp)
80100da7:	e8 0e 08 00 00       	call   801015ba <iput>
    end_op();
80100dac:	e8 48 1a 00 00       	call   801027f9 <end_op>
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	eb 1d                	jmp    80100dd3 <fileclose+0x9a>
    panic("fileclose");
80100db6:	83 ec 0c             	sub    $0xc,%esp
80100db9:	68 38 76 10 80       	push   $0x80107638
80100dbe:	e8 7d f5 ff ff       	call   80100340 <panic>
    release(&ftable.lock);
80100dc3:	83 ec 0c             	sub    $0xc,%esp
80100dc6:	68 60 ff 10 80       	push   $0x8010ff60
80100dcb:	e8 98 2f 00 00       	call   80103d68 <release>
80100dd0:	83 c4 10             	add    $0x10,%esp
  }
}
80100dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dd6:	5b                   	pop    %ebx
80100dd7:	5e                   	pop    %esi
80100dd8:	5f                   	pop    %edi
80100dd9:	5d                   	pop    %ebp
80100dda:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100ddb:	83 ec 08             	sub    $0x8,%esp
80100dde:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100de2:	50                   	push   %eax
80100de3:	57                   	push   %edi
80100de4:	e8 b4 20 00 00       	call   80102e9d <pipeclose>
80100de9:	83 c4 10             	add    $0x10,%esp
80100dec:	eb e5                	jmp    80100dd3 <fileclose+0x9a>

80100dee <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dee:	55                   	push   %ebp
80100def:	89 e5                	mov    %esp,%ebp
80100df1:	53                   	push   %ebx
80100df2:	83 ec 04             	sub    $0x4,%esp
80100df5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100df8:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dfb:	75 31                	jne    80100e2e <filestat+0x40>
    ilock(f->ip);
80100dfd:	83 ec 0c             	sub    $0xc,%esp
80100e00:	ff 73 10             	push   0x10(%ebx)
80100e03:	e8 ab 06 00 00       	call   801014b3 <ilock>
    stati(f->ip, st);
80100e08:	83 c4 08             	add    $0x8,%esp
80100e0b:	ff 75 0c             	push   0xc(%ebp)
80100e0e:	ff 73 10             	push   0x10(%ebx)
80100e11:	e8 06 09 00 00       	call   8010171c <stati>
    iunlock(f->ip);
80100e16:	83 c4 04             	add    $0x4,%esp
80100e19:	ff 73 10             	push   0x10(%ebx)
80100e1c:	e8 54 07 00 00       	call   80101575 <iunlock>
    return 0;
80100e21:	83 c4 10             	add    $0x10,%esp
80100e24:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e2c:	c9                   	leave  
80100e2d:	c3                   	ret    
  return -1;
80100e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e33:	eb f4                	jmp    80100e29 <filestat+0x3b>

80100e35 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e35:	55                   	push   %ebp
80100e36:	89 e5                	mov    %esp,%ebp
80100e38:	56                   	push   %esi
80100e39:	53                   	push   %ebx
80100e3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e3d:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e41:	74 70                	je     80100eb3 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e43:	8b 03                	mov    (%ebx),%eax
80100e45:	83 f8 01             	cmp    $0x1,%eax
80100e48:	74 44                	je     80100e8e <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e4a:	83 f8 02             	cmp    $0x2,%eax
80100e4d:	75 57                	jne    80100ea6 <fileread+0x71>
    ilock(f->ip);
80100e4f:	83 ec 0c             	sub    $0xc,%esp
80100e52:	ff 73 10             	push   0x10(%ebx)
80100e55:	e8 59 06 00 00       	call   801014b3 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e5a:	ff 75 10             	push   0x10(%ebp)
80100e5d:	ff 73 14             	push   0x14(%ebx)
80100e60:	ff 75 0c             	push   0xc(%ebp)
80100e63:	ff 73 10             	push   0x10(%ebx)
80100e66:	e8 dc 08 00 00       	call   80101747 <readi>
80100e6b:	89 c6                	mov    %eax,%esi
80100e6d:	83 c4 20             	add    $0x20,%esp
80100e70:	85 c0                	test   %eax,%eax
80100e72:	7e 03                	jle    80100e77 <fileread+0x42>
      f->off += r;
80100e74:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e77:	83 ec 0c             	sub    $0xc,%esp
80100e7a:	ff 73 10             	push   0x10(%ebx)
80100e7d:	e8 f3 06 00 00       	call   80101575 <iunlock>
    return r;
80100e82:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e85:	89 f0                	mov    %esi,%eax
80100e87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e8a:	5b                   	pop    %ebx
80100e8b:	5e                   	pop    %esi
80100e8c:	5d                   	pop    %ebp
80100e8d:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e8e:	83 ec 04             	sub    $0x4,%esp
80100e91:	ff 75 10             	push   0x10(%ebp)
80100e94:	ff 75 0c             	push   0xc(%ebp)
80100e97:	ff 73 0c             	push   0xc(%ebx)
80100e9a:	e8 71 21 00 00       	call   80103010 <piperead>
80100e9f:	89 c6                	mov    %eax,%esi
80100ea1:	83 c4 10             	add    $0x10,%esp
80100ea4:	eb df                	jmp    80100e85 <fileread+0x50>
  panic("fileread");
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	68 42 76 10 80       	push   $0x80107642
80100eae:	e8 8d f4 ff ff       	call   80100340 <panic>
    return -1;
80100eb3:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100eb8:	eb cb                	jmp    80100e85 <fileread+0x50>

80100eba <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100eba:	55                   	push   %ebp
80100ebb:	89 e5                	mov    %esp,%ebp
80100ebd:	57                   	push   %edi
80100ebe:	56                   	push   %esi
80100ebf:	53                   	push   %ebx
80100ec0:	83 ec 1c             	sub    $0x1c,%esp
80100ec3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int r;

  if(f->writable == 0)
80100ec6:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100eca:	0f 84 ef 00 00 00    	je     80100fbf <filewrite+0x105>
    return -1;
  if(f->type == FD_PIPE)
80100ed0:	8b 07                	mov    (%edi),%eax
80100ed2:	83 f8 01             	cmp    $0x1,%eax
80100ed5:	74 1c                	je     80100ef3 <filewrite+0x39>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ed7:	83 f8 02             	cmp    $0x2,%eax
80100eda:	0f 85 d2 00 00 00    	jne    80100fb2 <filewrite+0xf8>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ee0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ee4:	0f 8e bf 00 00 00    	jle    80100fa9 <filewrite+0xef>
    int i = 0;
80100eea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ef1:	eb 3e                	jmp    80100f31 <filewrite+0x77>
    return pipewrite(f->pipe, addr, n);
80100ef3:	83 ec 04             	sub    $0x4,%esp
80100ef6:	ff 75 10             	push   0x10(%ebp)
80100ef9:	ff 75 0c             	push   0xc(%ebp)
80100efc:	ff 77 0c             	push   0xc(%edi)
80100eff:	e8 25 20 00 00       	call   80102f29 <pipewrite>
80100f04:	83 c4 10             	add    $0x10,%esp
80100f07:	e9 88 00 00 00       	jmp    80100f94 <filewrite+0xda>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f0c:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 77 10             	push   0x10(%edi)
80100f15:	e8 5b 06 00 00       	call   80101575 <iunlock>
      end_op();
80100f1a:	e8 da 18 00 00       	call   801027f9 <end_op>
80100f1f:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80100f22:	39 de                	cmp    %ebx,%esi
80100f24:	75 76                	jne    80100f9c <filewrite+0xe2>
        panic("short filewrite");
      i += r;
80100f26:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80100f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    while(i < n){
80100f2c:	39 45 10             	cmp    %eax,0x10(%ebp)
80100f2f:	7e 54                	jle    80100f85 <filewrite+0xcb>
      int n1 = n - i;
80100f31:	8b 75 10             	mov    0x10(%ebp),%esi
80100f34:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100f37:	29 de                	sub    %ebx,%esi
80100f39:	b8 00 06 00 00       	mov    $0x600,%eax
80100f3e:	39 c6                	cmp    %eax,%esi
80100f40:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80100f43:	e8 36 18 00 00       	call   8010277e <begin_op>
      ilock(f->ip);
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	ff 77 10             	push   0x10(%edi)
80100f4e:	e8 60 05 00 00       	call   801014b3 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f53:	56                   	push   %esi
80100f54:	ff 77 14             	push   0x14(%edi)
80100f57:	89 d8                	mov    %ebx,%eax
80100f59:	03 45 0c             	add    0xc(%ebp),%eax
80100f5c:	50                   	push   %eax
80100f5d:	ff 77 10             	push   0x10(%edi)
80100f60:	e8 de 08 00 00       	call   80101843 <writei>
80100f65:	89 c3                	mov    %eax,%ebx
80100f67:	83 c4 20             	add    $0x20,%esp
80100f6a:	85 c0                	test   %eax,%eax
80100f6c:	7f 9e                	jg     80100f0c <filewrite+0x52>
      iunlock(f->ip);
80100f6e:	83 ec 0c             	sub    $0xc,%esp
80100f71:	ff 77 10             	push   0x10(%edi)
80100f74:	e8 fc 05 00 00       	call   80101575 <iunlock>
      end_op();
80100f79:	e8 7b 18 00 00       	call   801027f9 <end_op>
      if(r < 0)
80100f7e:	83 c4 10             	add    $0x10,%esp
80100f81:	85 db                	test   %ebx,%ebx
80100f83:	79 9d                	jns    80100f22 <filewrite+0x68>
    }
    return i == n ? n : -1;
80100f85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f88:	39 45 10             	cmp    %eax,0x10(%ebp)
80100f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f90:	0f 44 45 10          	cmove  0x10(%ebp),%eax
  }
  panic("filewrite");
}
80100f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f97:	5b                   	pop    %ebx
80100f98:	5e                   	pop    %esi
80100f99:	5f                   	pop    %edi
80100f9a:	5d                   	pop    %ebp
80100f9b:	c3                   	ret    
        panic("short filewrite");
80100f9c:	83 ec 0c             	sub    $0xc,%esp
80100f9f:	68 4b 76 10 80       	push   $0x8010764b
80100fa4:	e8 97 f3 ff ff       	call   80100340 <panic>
    int i = 0;
80100fa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100fb0:	eb d3                	jmp    80100f85 <filewrite+0xcb>
  panic("filewrite");
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	68 51 76 10 80       	push   $0x80107651
80100fba:	e8 81 f3 ff ff       	call   80100340 <panic>
    return -1;
80100fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc4:	eb ce                	jmp    80100f94 <filewrite+0xda>

80100fc6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80100fc6:	55                   	push   %ebp
80100fc7:	89 e5                	mov    %esp,%ebp
80100fc9:	56                   	push   %esi
80100fca:	53                   	push   %ebx
80100fcb:	89 c1                	mov    %eax,%ecx
80100fcd:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80100fcf:	83 ec 08             	sub    $0x8,%esp
80100fd2:	89 d0                	mov    %edx,%eax
80100fd4:	c1 e8 0c             	shr    $0xc,%eax
80100fd7:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80100fdd:	50                   	push   %eax
80100fde:	51                   	push   %ecx
80100fdf:	e8 c6 f0 ff ff       	call   801000aa <bread>
80100fe4:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
80100fe6:	89 d9                	mov    %ebx,%ecx
80100fe8:	83 e1 07             	and    $0x7,%ecx
80100feb:	b8 01 00 00 00       	mov    $0x1,%eax
80100ff0:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
80100ff2:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
80100ff8:	83 c4 10             	add    $0x10,%esp
80100ffb:	c1 fb 03             	sar    $0x3,%ebx
80100ffe:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
80101003:	0f b6 ca             	movzbl %dl,%ecx
80101006:	85 c1                	test   %eax,%ecx
80101008:	74 23                	je     8010102d <bfree+0x67>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010100a:	f7 d0                	not    %eax
8010100c:	21 d0                	and    %edx,%eax
8010100e:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101012:	83 ec 0c             	sub    $0xc,%esp
80101015:	56                   	push   %esi
80101016:	e8 20 19 00 00       	call   8010293b <log_write>
  brelse(bp);
8010101b:	89 34 24             	mov    %esi,(%esp)
8010101e:	e8 9e f1 ff ff       	call   801001c1 <brelse>
}
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101029:	5b                   	pop    %ebx
8010102a:	5e                   	pop    %esi
8010102b:	5d                   	pop    %ebp
8010102c:	c3                   	ret    
    panic("freeing free block");
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 5b 76 10 80       	push   $0x8010765b
80101035:	e8 06 f3 ff ff       	call   80100340 <panic>

8010103a <balloc>:
{
8010103a:	55                   	push   %ebp
8010103b:	89 e5                	mov    %esp,%ebp
8010103d:	57                   	push   %edi
8010103e:	56                   	push   %esi
8010103f:	53                   	push   %ebx
80101040:	83 ec 1c             	sub    $0x1c,%esp
80101043:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101046:	83 3d b4 25 11 80 00 	cmpl   $0x0,0x801125b4
8010104d:	0f 84 9c 00 00 00    	je     801010ef <balloc+0xb5>
80101053:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010105a:	eb 20                	jmp    8010107c <balloc+0x42>
    brelse(bp);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 75 e4             	push   -0x1c(%ebp)
80101062:	e8 5a f1 ff ff       	call   801001c1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101067:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp
80101074:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010107a:	76 73                	jbe    801010ef <balloc+0xb5>
    bp = bread(dev, BBLOCK(b, sb));
8010107c:	83 ec 08             	sub    $0x8,%esp
8010107f:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101082:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80101088:	85 f6                	test   %esi,%esi
8010108a:	0f 49 c6             	cmovns %esi,%eax
8010108d:	c1 f8 0c             	sar    $0xc,%eax
80101090:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101096:	50                   	push   %eax
80101097:	ff 75 d8             	push   -0x28(%ebp)
8010109a:	e8 0b f0 ff ff       	call   801000aa <bread>
8010109f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010a2:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801010a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010aa:	83 c4 10             	add    $0x10,%esp
801010ad:	b8 00 00 00 00       	mov    $0x0,%eax
801010b2:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801010b5:	76 a5                	jbe    8010105c <balloc+0x22>
      m = 1 << (bi % 8);
801010b7:	89 c1                	mov    %eax,%ecx
801010b9:	83 e1 07             	and    $0x7,%ecx
801010bc:	bb 01 00 00 00       	mov    $0x1,%ebx
801010c1:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010c3:	8d 50 07             	lea    0x7(%eax),%edx
801010c6:	85 c0                	test   %eax,%eax
801010c8:	0f 49 d0             	cmovns %eax,%edx
801010cb:	c1 fa 03             	sar    $0x3,%edx
801010ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010d1:	0f b6 4c 17 5c       	movzbl 0x5c(%edi,%edx,1),%ecx
801010d6:	0f b6 f9             	movzbl %cl,%edi
801010d9:	85 df                	test   %ebx,%edi
801010db:	74 1f                	je     801010fc <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010dd:	83 c0 01             	add    $0x1,%eax
801010e0:	83 c6 01             	add    $0x1,%esi
801010e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801010e8:	75 c8                	jne    801010b2 <balloc+0x78>
801010ea:	e9 6d ff ff ff       	jmp    8010105c <balloc+0x22>
  panic("balloc: out of blocks");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 6e 76 10 80       	push   $0x8010766e
801010f7:	e8 44 f2 ff ff       	call   80100340 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010fc:	09 d9                	or     %ebx,%ecx
801010fe:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101101:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101105:	83 ec 0c             	sub    $0xc,%esp
80101108:	53                   	push   %ebx
80101109:	e8 2d 18 00 00       	call   8010293b <log_write>
        brelse(bp);
8010110e:	89 1c 24             	mov    %ebx,(%esp)
80101111:	e8 ab f0 ff ff       	call   801001c1 <brelse>
  bp = bread(dev, bno);
80101116:	83 c4 08             	add    $0x8,%esp
80101119:	56                   	push   %esi
8010111a:	ff 75 d8             	push   -0x28(%ebp)
8010111d:	e8 88 ef ff ff       	call   801000aa <bread>
80101122:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101124:	83 c4 0c             	add    $0xc,%esp
80101127:	68 00 02 00 00       	push   $0x200
8010112c:	6a 00                	push   $0x0
8010112e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101131:	50                   	push   %eax
80101132:	e8 78 2c 00 00       	call   80103daf <memset>
  log_write(bp);
80101137:	89 1c 24             	mov    %ebx,(%esp)
8010113a:	e8 fc 17 00 00       	call   8010293b <log_write>
  brelse(bp);
8010113f:	89 1c 24             	mov    %ebx,(%esp)
80101142:	e8 7a f0 ff ff       	call   801001c1 <brelse>
}
80101147:	89 f0                	mov    %esi,%eax
80101149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010114c:	5b                   	pop    %ebx
8010114d:	5e                   	pop    %esi
8010114e:	5f                   	pop    %edi
8010114f:	5d                   	pop    %ebp
80101150:	c3                   	ret    

80101151 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101151:	55                   	push   %ebp
80101152:	89 e5                	mov    %esp,%ebp
80101154:	57                   	push   %edi
80101155:	56                   	push   %esi
80101156:	53                   	push   %ebx
80101157:	83 ec 1c             	sub    $0x1c,%esp
8010115a:	89 c3                	mov    %eax,%ebx
8010115c:	89 d7                	mov    %edx,%edi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010115e:	83 fa 0b             	cmp    $0xb,%edx
80101161:	76 45                	jbe    801011a8 <bmap+0x57>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101163:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
80101166:	83 fe 7f             	cmp    $0x7f,%esi
80101169:	77 7f                	ja     801011ea <bmap+0x99>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010116b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	74 4a                	je     801011bf <bmap+0x6e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101175:	83 ec 08             	sub    $0x8,%esp
80101178:	50                   	push   %eax
80101179:	ff 33                	push   (%ebx)
8010117b:	e8 2a ef ff ff       	call   801000aa <bread>
80101180:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101182:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101189:	8b 30                	mov    (%eax),%esi
8010118b:	83 c4 10             	add    $0x10,%esp
8010118e:	85 f6                	test   %esi,%esi
80101190:	74 3c                	je     801011ce <bmap+0x7d>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	57                   	push   %edi
80101196:	e8 26 f0 ff ff       	call   801001c1 <brelse>
    return addr;
8010119b:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
8010119e:	89 f0                	mov    %esi,%eax
801011a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a3:	5b                   	pop    %ebx
801011a4:	5e                   	pop    %esi
801011a5:	5f                   	pop    %edi
801011a6:	5d                   	pop    %ebp
801011a7:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011a8:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011ac:	85 f6                	test   %esi,%esi
801011ae:	75 ee                	jne    8010119e <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011b0:	8b 00                	mov    (%eax),%eax
801011b2:	e8 83 fe ff ff       	call   8010103a <balloc>
801011b7:	89 c6                	mov    %eax,%esi
801011b9:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
801011bd:	eb df                	jmp    8010119e <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011bf:	8b 03                	mov    (%ebx),%eax
801011c1:	e8 74 fe ff ff       	call   8010103a <balloc>
801011c6:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801011cc:	eb a7                	jmp    80101175 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801011ce:	8b 03                	mov    (%ebx),%eax
801011d0:	e8 65 fe ff ff       	call   8010103a <balloc>
801011d5:	89 c6                	mov    %eax,%esi
801011d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011da:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801011dc:	83 ec 0c             	sub    $0xc,%esp
801011df:	57                   	push   %edi
801011e0:	e8 56 17 00 00       	call   8010293b <log_write>
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	eb a8                	jmp    80101192 <bmap+0x41>
  panic("bmap: out of range");
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	68 84 76 10 80       	push   $0x80107684
801011f2:	e8 49 f1 ff ff       	call   80100340 <panic>

801011f7 <iget>:
{
801011f7:	55                   	push   %ebp
801011f8:	89 e5                	mov    %esp,%ebp
801011fa:	57                   	push   %edi
801011fb:	56                   	push   %esi
801011fc:	53                   	push   %ebx
801011fd:	83 ec 28             	sub    $0x28,%esp
80101200:	89 c7                	mov    %eax,%edi
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101205:	68 60 09 11 80       	push   $0x80110960
8010120a:	e8 f2 2a 00 00       	call   80103d01 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101212:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101217:	bb 94 09 11 80       	mov    $0x80110994,%ebx
8010121c:	eb 13                	jmp    80101231 <iget+0x3a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010121e:	09 f0                	or     %esi,%eax
80101220:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101223:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101229:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010122f:	74 2d                	je     8010125e <iget+0x67>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101231:	8b 43 08             	mov    0x8(%ebx),%eax
80101234:	85 c0                	test   %eax,%eax
80101236:	7e e6                	jle    8010121e <iget+0x27>
80101238:	39 3b                	cmp    %edi,(%ebx)
8010123a:	75 e7                	jne    80101223 <iget+0x2c>
8010123c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010123f:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101242:	75 df                	jne    80101223 <iget+0x2c>
      ip->ref++;
80101244:	83 c0 01             	add    $0x1,%eax
80101247:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010124a:	83 ec 0c             	sub    $0xc,%esp
8010124d:	68 60 09 11 80       	push   $0x80110960
80101252:	e8 11 2b 00 00       	call   80103d68 <release>
      return ip;
80101257:	83 c4 10             	add    $0x10,%esp
8010125a:	89 de                	mov    %ebx,%esi
8010125c:	eb 2a                	jmp    80101288 <iget+0x91>
  if(empty == 0)
8010125e:	85 f6                	test   %esi,%esi
80101260:	74 30                	je     80101292 <iget+0x9b>
  ip->dev = dev;
80101262:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101267:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010126a:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101271:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	68 60 09 11 80       	push   $0x80110960
80101280:	e8 e3 2a 00 00       	call   80103d68 <release>
  return ip;
80101285:	83 c4 10             	add    $0x10,%esp
}
80101288:	89 f0                	mov    %esi,%eax
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	5b                   	pop    %ebx
8010128e:	5e                   	pop    %esi
8010128f:	5f                   	pop    %edi
80101290:	5d                   	pop    %ebp
80101291:	c3                   	ret    
    panic("iget: no inodes");
80101292:	83 ec 0c             	sub    $0xc,%esp
80101295:	68 97 76 10 80       	push   $0x80107697
8010129a:	e8 a1 f0 ff ff       	call   80100340 <panic>

8010129f <readsb>:
{
8010129f:	55                   	push   %ebp
801012a0:	89 e5                	mov    %esp,%ebp
801012a2:	53                   	push   %ebx
801012a3:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012a6:	6a 01                	push   $0x1
801012a8:	ff 75 08             	push   0x8(%ebp)
801012ab:	e8 fa ed ff ff       	call   801000aa <bread>
801012b0:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012b2:	83 c4 0c             	add    $0xc,%esp
801012b5:	6a 1c                	push   $0x1c
801012b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ba:	50                   	push   %eax
801012bb:	ff 75 0c             	push   0xc(%ebp)
801012be:	e8 71 2b 00 00       	call   80103e34 <memmove>
  brelse(bp);
801012c3:	89 1c 24             	mov    %ebx,(%esp)
801012c6:	e8 f6 ee ff ff       	call   801001c1 <brelse>
}
801012cb:	83 c4 10             	add    $0x10,%esp
801012ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012d1:	c9                   	leave  
801012d2:	c3                   	ret    

801012d3 <iinit>:
{
801012d3:	55                   	push   %ebp
801012d4:	89 e5                	mov    %esp,%ebp
801012d6:	56                   	push   %esi
801012d7:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
801012d8:	83 ec 08             	sub    $0x8,%esp
801012db:	68 a7 76 10 80       	push   $0x801076a7
801012e0:	68 60 09 11 80       	push   $0x80110960
801012e5:	e8 ce 28 00 00       	call   80103bb8 <initlock>
  for(i = 0; i < NINODE; i++) {
801012ea:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801012ef:	be c0 25 11 80       	mov    $0x801125c0,%esi
801012f4:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
801012f7:	83 ec 08             	sub    $0x8,%esp
801012fa:	68 ae 76 10 80       	push   $0x801076ae
801012ff:	53                   	push   %ebx
80101300:	e8 a9 27 00 00       	call   80103aae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101305:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010130b:	83 c4 10             	add    $0x10,%esp
8010130e:	39 f3                	cmp    %esi,%ebx
80101310:	75 e5                	jne    801012f7 <iinit+0x24>
  readsb(dev, &sb);
80101312:	83 ec 08             	sub    $0x8,%esp
80101315:	68 b4 25 11 80       	push   $0x801125b4
8010131a:	ff 75 08             	push   0x8(%ebp)
8010131d:	e8 7d ff ff ff       	call   8010129f <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101322:	ff 35 cc 25 11 80    	push   0x801125cc
80101328:	ff 35 c8 25 11 80    	push   0x801125c8
8010132e:	ff 35 c4 25 11 80    	push   0x801125c4
80101334:	ff 35 c0 25 11 80    	push   0x801125c0
8010133a:	ff 35 bc 25 11 80    	push   0x801125bc
80101340:	ff 35 b8 25 11 80    	push   0x801125b8
80101346:	ff 35 b4 25 11 80    	push   0x801125b4
8010134c:	68 14 77 10 80       	push   $0x80107714
80101351:	e8 ab f2 ff ff       	call   80100601 <cprintf>
}
80101356:	83 c4 30             	add    $0x30,%esp
80101359:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5d                   	pop    %ebp
8010135f:	c3                   	ret    

80101360 <ialloc>:
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	83 ec 1c             	sub    $0x1c,%esp
80101369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010136c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010136f:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
80101376:	76 4d                	jbe    801013c5 <ialloc+0x65>
80101378:	bb 01 00 00 00       	mov    $0x1,%ebx
8010137d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
80101380:	83 ec 08             	sub    $0x8,%esp
80101383:	89 d8                	mov    %ebx,%eax
80101385:	c1 e8 03             	shr    $0x3,%eax
80101388:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010138e:	50                   	push   %eax
8010138f:	ff 75 08             	push   0x8(%ebp)
80101392:	e8 13 ed ff ff       	call   801000aa <bread>
80101397:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101399:	89 d8                	mov    %ebx,%eax
8010139b:	83 e0 07             	and    $0x7,%eax
8010139e:	c1 e0 06             	shl    $0x6,%eax
801013a1:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013a5:	83 c4 10             	add    $0x10,%esp
801013a8:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013ac:	74 24                	je     801013d2 <ialloc+0x72>
    brelse(bp);
801013ae:	83 ec 0c             	sub    $0xc,%esp
801013b1:	56                   	push   %esi
801013b2:	e8 0a ee ff ff       	call   801001c1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013b7:	83 c3 01             	add    $0x1,%ebx
801013ba:	83 c4 10             	add    $0x10,%esp
801013bd:	39 1d bc 25 11 80    	cmp    %ebx,0x801125bc
801013c3:	77 b8                	ja     8010137d <ialloc+0x1d>
  panic("ialloc: no inodes");
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	68 b4 76 10 80       	push   $0x801076b4
801013cd:	e8 6e ef ff ff       	call   80100340 <panic>
      memset(dip, 0, sizeof(*dip));
801013d2:	83 ec 04             	sub    $0x4,%esp
801013d5:	6a 40                	push   $0x40
801013d7:	6a 00                	push   $0x0
801013d9:	57                   	push   %edi
801013da:	e8 d0 29 00 00       	call   80103daf <memset>
      dip->type = type;
801013df:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801013e3:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013e6:	89 34 24             	mov    %esi,(%esp)
801013e9:	e8 4d 15 00 00       	call   8010293b <log_write>
      brelse(bp);
801013ee:	89 34 24             	mov    %esi,(%esp)
801013f1:	e8 cb ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
801013f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013f9:	8b 45 08             	mov    0x8(%ebp),%eax
801013fc:	e8 f6 fd ff ff       	call   801011f7 <iget>
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret    

80101409 <iupdate>:
{
80101409:	55                   	push   %ebp
8010140a:	89 e5                	mov    %esp,%ebp
8010140c:	56                   	push   %esi
8010140d:	53                   	push   %ebx
8010140e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101411:	83 ec 08             	sub    $0x8,%esp
80101414:	8b 43 04             	mov    0x4(%ebx),%eax
80101417:	c1 e8 03             	shr    $0x3,%eax
8010141a:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101420:	50                   	push   %eax
80101421:	ff 33                	push   (%ebx)
80101423:	e8 82 ec ff ff       	call   801000aa <bread>
80101428:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010142a:	8b 43 04             	mov    0x4(%ebx),%eax
8010142d:	83 e0 07             	and    $0x7,%eax
80101430:	c1 e0 06             	shl    $0x6,%eax
80101433:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101437:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
8010143b:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010143e:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101442:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101446:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
8010144a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010144e:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101452:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101456:	8b 53 58             	mov    0x58(%ebx),%edx
80101459:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010145c:	83 c4 0c             	add    $0xc,%esp
8010145f:	6a 34                	push   $0x34
80101461:	83 c3 5c             	add    $0x5c,%ebx
80101464:	53                   	push   %ebx
80101465:	83 c0 0c             	add    $0xc,%eax
80101468:	50                   	push   %eax
80101469:	e8 c6 29 00 00       	call   80103e34 <memmove>
  log_write(bp);
8010146e:	89 34 24             	mov    %esi,(%esp)
80101471:	e8 c5 14 00 00       	call   8010293b <log_write>
  brelse(bp);
80101476:	89 34 24             	mov    %esi,(%esp)
80101479:	e8 43 ed ff ff       	call   801001c1 <brelse>
}
8010147e:	83 c4 10             	add    $0x10,%esp
80101481:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5d                   	pop    %ebp
80101487:	c3                   	ret    

80101488 <idup>:
{
80101488:	55                   	push   %ebp
80101489:	89 e5                	mov    %esp,%ebp
8010148b:	53                   	push   %ebx
8010148c:	83 ec 10             	sub    $0x10,%esp
8010148f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101492:	68 60 09 11 80       	push   $0x80110960
80101497:	e8 65 28 00 00       	call   80103d01 <acquire>
  ip->ref++;
8010149c:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801014a0:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801014a7:	e8 bc 28 00 00       	call   80103d68 <release>
}
801014ac:	89 d8                	mov    %ebx,%eax
801014ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014b1:	c9                   	leave  
801014b2:	c3                   	ret    

801014b3 <ilock>:
{
801014b3:	55                   	push   %ebp
801014b4:	89 e5                	mov    %esp,%ebp
801014b6:	56                   	push   %esi
801014b7:	53                   	push   %ebx
801014b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801014bb:	85 db                	test   %ebx,%ebx
801014bd:	74 22                	je     801014e1 <ilock+0x2e>
801014bf:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801014c3:	7e 1c                	jle    801014e1 <ilock+0x2e>
  acquiresleep(&ip->lock);
801014c5:	83 ec 0c             	sub    $0xc,%esp
801014c8:	8d 43 0c             	lea    0xc(%ebx),%eax
801014cb:	50                   	push   %eax
801014cc:	e8 10 26 00 00       	call   80103ae1 <acquiresleep>
  if(ip->valid == 0){
801014d1:	83 c4 10             	add    $0x10,%esp
801014d4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801014d8:	74 14                	je     801014ee <ilock+0x3b>
}
801014da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014dd:	5b                   	pop    %ebx
801014de:	5e                   	pop    %esi
801014df:	5d                   	pop    %ebp
801014e0:	c3                   	ret    
    panic("ilock");
801014e1:	83 ec 0c             	sub    $0xc,%esp
801014e4:	68 c6 76 10 80       	push   $0x801076c6
801014e9:	e8 52 ee ff ff       	call   80100340 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014ee:	83 ec 08             	sub    $0x8,%esp
801014f1:	8b 43 04             	mov    0x4(%ebx),%eax
801014f4:	c1 e8 03             	shr    $0x3,%eax
801014f7:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801014fd:	50                   	push   %eax
801014fe:	ff 33                	push   (%ebx)
80101500:	e8 a5 eb ff ff       	call   801000aa <bread>
80101505:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101507:	8b 43 04             	mov    0x4(%ebx),%eax
8010150a:	83 e0 07             	and    $0x7,%eax
8010150d:	c1 e0 06             	shl    $0x6,%eax
80101510:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101514:	0f b7 10             	movzwl (%eax),%edx
80101517:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010151b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010151f:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101523:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101527:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010152b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010152f:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101533:	8b 50 08             	mov    0x8(%eax),%edx
80101536:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101539:	83 c4 0c             	add    $0xc,%esp
8010153c:	6a 34                	push   $0x34
8010153e:	83 c0 0c             	add    $0xc,%eax
80101541:	50                   	push   %eax
80101542:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101545:	50                   	push   %eax
80101546:	e8 e9 28 00 00       	call   80103e34 <memmove>
    brelse(bp);
8010154b:	89 34 24             	mov    %esi,(%esp)
8010154e:	e8 6e ec ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
80101553:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010155a:	83 c4 10             	add    $0x10,%esp
8010155d:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101562:	0f 85 72 ff ff ff    	jne    801014da <ilock+0x27>
      panic("ilock: no type");
80101568:	83 ec 0c             	sub    $0xc,%esp
8010156b:	68 cc 76 10 80       	push   $0x801076cc
80101570:	e8 cb ed ff ff       	call   80100340 <panic>

80101575 <iunlock>:
{
80101575:	55                   	push   %ebp
80101576:	89 e5                	mov    %esp,%ebp
80101578:	56                   	push   %esi
80101579:	53                   	push   %ebx
8010157a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010157d:	85 db                	test   %ebx,%ebx
8010157f:	74 2c                	je     801015ad <iunlock+0x38>
80101581:	8d 73 0c             	lea    0xc(%ebx),%esi
80101584:	83 ec 0c             	sub    $0xc,%esp
80101587:	56                   	push   %esi
80101588:	e8 e1 25 00 00       	call   80103b6e <holdingsleep>
8010158d:	83 c4 10             	add    $0x10,%esp
80101590:	85 c0                	test   %eax,%eax
80101592:	74 19                	je     801015ad <iunlock+0x38>
80101594:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101598:	7e 13                	jle    801015ad <iunlock+0x38>
  releasesleep(&ip->lock);
8010159a:	83 ec 0c             	sub    $0xc,%esp
8010159d:	56                   	push   %esi
8010159e:	e8 90 25 00 00       	call   80103b33 <releasesleep>
}
801015a3:	83 c4 10             	add    $0x10,%esp
801015a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015a9:	5b                   	pop    %ebx
801015aa:	5e                   	pop    %esi
801015ab:	5d                   	pop    %ebp
801015ac:	c3                   	ret    
    panic("iunlock");
801015ad:	83 ec 0c             	sub    $0xc,%esp
801015b0:	68 db 76 10 80       	push   $0x801076db
801015b5:	e8 86 ed ff ff       	call   80100340 <panic>

801015ba <iput>:
{
801015ba:	55                   	push   %ebp
801015bb:	89 e5                	mov    %esp,%ebp
801015bd:	57                   	push   %edi
801015be:	56                   	push   %esi
801015bf:	53                   	push   %ebx
801015c0:	83 ec 28             	sub    $0x28,%esp
801015c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801015c6:	8d 73 0c             	lea    0xc(%ebx),%esi
801015c9:	56                   	push   %esi
801015ca:	e8 12 25 00 00       	call   80103ae1 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801015cf:	83 c4 10             	add    $0x10,%esp
801015d2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015d6:	74 07                	je     801015df <iput+0x25>
801015d8:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801015dd:	74 30                	je     8010160f <iput+0x55>
  releasesleep(&ip->lock);
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	56                   	push   %esi
801015e3:	e8 4b 25 00 00       	call   80103b33 <releasesleep>
  acquire(&icache.lock);
801015e8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801015ef:	e8 0d 27 00 00       	call   80103d01 <acquire>
  ip->ref--;
801015f4:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801015f8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801015ff:	e8 64 27 00 00       	call   80103d68 <release>
}
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010160a:	5b                   	pop    %ebx
8010160b:	5e                   	pop    %esi
8010160c:	5f                   	pop    %edi
8010160d:	5d                   	pop    %ebp
8010160e:	c3                   	ret    
    acquire(&icache.lock);
8010160f:	83 ec 0c             	sub    $0xc,%esp
80101612:	68 60 09 11 80       	push   $0x80110960
80101617:	e8 e5 26 00 00       	call   80103d01 <acquire>
    int r = ip->ref;
8010161c:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
8010161f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101626:	e8 3d 27 00 00       	call   80103d68 <release>
    if(r == 1){
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	83 ff 01             	cmp    $0x1,%edi
80101631:	75 ac                	jne    801015df <iput+0x25>
80101633:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80101636:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
8010163c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8010163f:	89 c6                	mov    %eax,%esi
80101641:	eb 07                	jmp    8010164a <iput+0x90>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101643:	83 c7 04             	add    $0x4,%edi
80101646:	39 f7                	cmp    %esi,%edi
80101648:	74 15                	je     8010165f <iput+0xa5>
    if(ip->addrs[i]){
8010164a:	8b 17                	mov    (%edi),%edx
8010164c:	85 d2                	test   %edx,%edx
8010164e:	74 f3                	je     80101643 <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
80101650:	8b 03                	mov    (%ebx),%eax
80101652:	e8 6f f9 ff ff       	call   80100fc6 <bfree>
      ip->addrs[i] = 0;
80101657:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010165d:	eb e4                	jmp    80101643 <iput+0x89>
    }
  }

  if(ip->addrs[NDIRECT]){
8010165f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101662:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101668:	85 c0                	test   %eax,%eax
8010166a:	75 2d                	jne    80101699 <iput+0xdf>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010166c:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101673:	83 ec 0c             	sub    $0xc,%esp
80101676:	53                   	push   %ebx
80101677:	e8 8d fd ff ff       	call   80101409 <iupdate>
      ip->type = 0;
8010167c:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101682:	89 1c 24             	mov    %ebx,(%esp)
80101685:	e8 7f fd ff ff       	call   80101409 <iupdate>
      ip->valid = 0;
8010168a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101691:	83 c4 10             	add    $0x10,%esp
80101694:	e9 46 ff ff ff       	jmp    801015df <iput+0x25>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101699:	83 ec 08             	sub    $0x8,%esp
8010169c:	50                   	push   %eax
8010169d:	ff 33                	push   (%ebx)
8010169f:	e8 06 ea ff ff       	call   801000aa <bread>
801016a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801016a7:	8d 78 5c             	lea    0x5c(%eax),%edi
801016aa:	05 5c 02 00 00       	add    $0x25c,%eax
801016af:	83 c4 10             	add    $0x10,%esp
801016b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
801016b5:	89 c6                	mov    %eax,%esi
801016b7:	eb 07                	jmp    801016c0 <iput+0x106>
801016b9:	83 c7 04             	add    $0x4,%edi
801016bc:	39 f7                	cmp    %esi,%edi
801016be:	74 0f                	je     801016cf <iput+0x115>
      if(a[j])
801016c0:	8b 17                	mov    (%edi),%edx
801016c2:	85 d2                	test   %edx,%edx
801016c4:	74 f3                	je     801016b9 <iput+0xff>
        bfree(ip->dev, a[j]);
801016c6:	8b 03                	mov    (%ebx),%eax
801016c8:	e8 f9 f8 ff ff       	call   80100fc6 <bfree>
801016cd:	eb ea                	jmp    801016b9 <iput+0xff>
    brelse(bp);
801016cf:	8b 75 e0             	mov    -0x20(%ebp),%esi
801016d2:	83 ec 0c             	sub    $0xc,%esp
801016d5:	ff 75 e4             	push   -0x1c(%ebp)
801016d8:	e8 e4 ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801016dd:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801016e3:	8b 03                	mov    (%ebx),%eax
801016e5:	e8 dc f8 ff ff       	call   80100fc6 <bfree>
    ip->addrs[NDIRECT] = 0;
801016ea:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801016f1:	00 00 00 
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	e9 70 ff ff ff       	jmp    8010166c <iput+0xb2>

801016fc <iunlockput>:
{
801016fc:	55                   	push   %ebp
801016fd:	89 e5                	mov    %esp,%ebp
801016ff:	53                   	push   %ebx
80101700:	83 ec 10             	sub    $0x10,%esp
80101703:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101706:	53                   	push   %ebx
80101707:	e8 69 fe ff ff       	call   80101575 <iunlock>
  iput(ip);
8010170c:	89 1c 24             	mov    %ebx,(%esp)
8010170f:	e8 a6 fe ff ff       	call   801015ba <iput>
}
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010171a:	c9                   	leave  
8010171b:	c3                   	ret    

8010171c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
8010171c:	55                   	push   %ebp
8010171d:	89 e5                	mov    %esp,%ebp
8010171f:	8b 55 08             	mov    0x8(%ebp),%edx
80101722:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101725:	8b 0a                	mov    (%edx),%ecx
80101727:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010172a:	8b 4a 04             	mov    0x4(%edx),%ecx
8010172d:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101730:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101734:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101737:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010173b:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010173f:	8b 52 58             	mov    0x58(%edx),%edx
80101742:	89 50 10             	mov    %edx,0x10(%eax)
}
80101745:	5d                   	pop    %ebp
80101746:	c3                   	ret    

80101747 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101747:	55                   	push   %ebp
80101748:	89 e5                	mov    %esp,%ebp
8010174a:	57                   	push   %edi
8010174b:	56                   	push   %esi
8010174c:	53                   	push   %ebx
8010174d:	83 ec 1c             	sub    $0x1c,%esp
80101750:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101753:	8b 45 08             	mov    0x8(%ebp),%eax
80101756:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010175b:	0f 84 9d 00 00 00    	je     801017fe <readi+0xb7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101761:	8b 45 08             	mov    0x8(%ebp),%eax
80101764:	8b 40 58             	mov    0x58(%eax),%eax
80101767:	39 f8                	cmp    %edi,%eax
80101769:	0f 82 c6 00 00 00    	jb     80101835 <readi+0xee>
8010176f:	89 fa                	mov    %edi,%edx
80101771:	03 55 14             	add    0x14(%ebp),%edx
80101774:	0f 82 c2 00 00 00    	jb     8010183c <readi+0xf5>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010177a:	89 c1                	mov    %eax,%ecx
8010177c:	29 f9                	sub    %edi,%ecx
8010177e:	39 d0                	cmp    %edx,%eax
80101780:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
80101784:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101787:	85 c9                	test   %ecx,%ecx
80101789:	74 68                	je     801017f3 <readi+0xac>
8010178b:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101790:	89 fa                	mov    %edi,%edx
80101792:	c1 ea 09             	shr    $0x9,%edx
80101795:	8b 45 08             	mov    0x8(%ebp),%eax
80101798:	e8 b4 f9 ff ff       	call   80101151 <bmap>
8010179d:	83 ec 08             	sub    $0x8,%esp
801017a0:	50                   	push   %eax
801017a1:	8b 45 08             	mov    0x8(%ebp),%eax
801017a4:	ff 30                	push   (%eax)
801017a6:	e8 ff e8 ff ff       	call   801000aa <bread>
801017ab:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801017ad:	89 f8                	mov    %edi,%eax
801017af:	25 ff 01 00 00       	and    $0x1ff,%eax
801017b4:	bb 00 02 00 00       	mov    $0x200,%ebx
801017b9:	29 c3                	sub    %eax,%ebx
801017bb:	8b 55 14             	mov    0x14(%ebp),%edx
801017be:	29 f2                	sub    %esi,%edx
801017c0:	39 d3                	cmp    %edx,%ebx
801017c2:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801017c5:	83 c4 0c             	add    $0xc,%esp
801017c8:	53                   	push   %ebx
801017c9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801017cc:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
801017d0:	50                   	push   %eax
801017d1:	ff 75 0c             	push   0xc(%ebp)
801017d4:	e8 5b 26 00 00       	call   80103e34 <memmove>
    brelse(bp);
801017d9:	83 c4 04             	add    $0x4,%esp
801017dc:	ff 75 e4             	push   -0x1c(%ebp)
801017df:	e8 dd e9 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017e4:	01 de                	add    %ebx,%esi
801017e6:	01 df                	add    %ebx,%edi
801017e8:	01 5d 0c             	add    %ebx,0xc(%ebp)
801017eb:	83 c4 10             	add    $0x10,%esp
801017ee:	39 75 14             	cmp    %esi,0x14(%ebp)
801017f1:	77 9d                	ja     80101790 <readi+0x49>
  }
  return n;
801017f3:	8b 45 14             	mov    0x14(%ebp),%eax
}
801017f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f9:	5b                   	pop    %ebx
801017fa:	5e                   	pop    %esi
801017fb:	5f                   	pop    %edi
801017fc:	5d                   	pop    %ebp
801017fd:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017fe:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101802:	66 83 f8 09          	cmp    $0x9,%ax
80101806:	77 1f                	ja     80101827 <readi+0xe0>
80101808:	98                   	cwtl   
80101809:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101810:	85 c0                	test   %eax,%eax
80101812:	74 1a                	je     8010182e <readi+0xe7>
    return devsw[ip->major].read(ip, dst, n);
80101814:	83 ec 04             	sub    $0x4,%esp
80101817:	ff 75 14             	push   0x14(%ebp)
8010181a:	ff 75 0c             	push   0xc(%ebp)
8010181d:	ff 75 08             	push   0x8(%ebp)
80101820:	ff d0                	call   *%eax
80101822:	83 c4 10             	add    $0x10,%esp
80101825:	eb cf                	jmp    801017f6 <readi+0xaf>
      return -1;
80101827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010182c:	eb c8                	jmp    801017f6 <readi+0xaf>
8010182e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101833:	eb c1                	jmp    801017f6 <readi+0xaf>
    return -1;
80101835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010183a:	eb ba                	jmp    801017f6 <readi+0xaf>
8010183c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101841:	eb b3                	jmp    801017f6 <readi+0xaf>

80101843 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101843:	55                   	push   %ebp
80101844:	89 e5                	mov    %esp,%ebp
80101846:	57                   	push   %edi
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	83 ec 1c             	sub    $0x1c,%esp
8010184c:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010184f:	8b 45 08             	mov    0x8(%ebp),%eax
80101852:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101857:	0f 84 ae 00 00 00    	je     8010190b <writei+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010185d:	8b 45 08             	mov    0x8(%ebp),%eax
80101860:	39 78 58             	cmp    %edi,0x58(%eax)
80101863:	0f 82 ed 00 00 00    	jb     80101956 <writei+0x113>
80101869:	89 f8                	mov    %edi,%eax
8010186b:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010186e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101873:	0f 87 e4 00 00 00    	ja     8010195d <writei+0x11a>
80101879:	39 f8                	cmp    %edi,%eax
8010187b:	0f 82 dc 00 00 00    	jb     8010195d <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101881:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101885:	74 79                	je     80101900 <writei+0xbd>
80101887:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010188e:	89 fa                	mov    %edi,%edx
80101890:	c1 ea 09             	shr    $0x9,%edx
80101893:	8b 45 08             	mov    0x8(%ebp),%eax
80101896:	e8 b6 f8 ff ff       	call   80101151 <bmap>
8010189b:	83 ec 08             	sub    $0x8,%esp
8010189e:	50                   	push   %eax
8010189f:	8b 45 08             	mov    0x8(%ebp),%eax
801018a2:	ff 30                	push   (%eax)
801018a4:	e8 01 e8 ff ff       	call   801000aa <bread>
801018a9:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801018ab:	89 f8                	mov    %edi,%eax
801018ad:	25 ff 01 00 00       	and    $0x1ff,%eax
801018b2:	bb 00 02 00 00       	mov    $0x200,%ebx
801018b7:	29 c3                	sub    %eax,%ebx
801018b9:	8b 55 14             	mov    0x14(%ebp),%edx
801018bc:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801018bf:	39 d3                	cmp    %edx,%ebx
801018c1:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801018c4:	83 c4 0c             	add    $0xc,%esp
801018c7:	53                   	push   %ebx
801018c8:	ff 75 0c             	push   0xc(%ebp)
801018cb:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
801018cf:	50                   	push   %eax
801018d0:	e8 5f 25 00 00       	call   80103e34 <memmove>
    log_write(bp);
801018d5:	89 34 24             	mov    %esi,(%esp)
801018d8:	e8 5e 10 00 00       	call   8010293b <log_write>
    brelse(bp);
801018dd:	89 34 24             	mov    %esi,(%esp)
801018e0:	e8 dc e8 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018e5:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801018e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018eb:	01 df                	add    %ebx,%edi
801018ed:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018f0:	83 c4 10             	add    $0x10,%esp
801018f3:	39 45 14             	cmp    %eax,0x14(%ebp)
801018f6:	77 96                	ja     8010188e <writei+0x4b>
  }

  if(n > 0 && off > ip->size){
801018f8:	8b 45 08             	mov    0x8(%ebp),%eax
801018fb:	39 78 58             	cmp    %edi,0x58(%eax)
801018fe:	72 34                	jb     80101934 <writei+0xf1>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101900:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101903:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101906:	5b                   	pop    %ebx
80101907:	5e                   	pop    %esi
80101908:	5f                   	pop    %edi
80101909:	5d                   	pop    %ebp
8010190a:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010190b:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010190f:	66 83 f8 09          	cmp    $0x9,%ax
80101913:	77 33                	ja     80101948 <writei+0x105>
80101915:	98                   	cwtl   
80101916:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
8010191d:	85 c0                	test   %eax,%eax
8010191f:	74 2e                	je     8010194f <writei+0x10c>
    return devsw[ip->major].write(ip, src, n);
80101921:	83 ec 04             	sub    $0x4,%esp
80101924:	ff 75 14             	push   0x14(%ebp)
80101927:	ff 75 0c             	push   0xc(%ebp)
8010192a:	ff 75 08             	push   0x8(%ebp)
8010192d:	ff d0                	call   *%eax
8010192f:	83 c4 10             	add    $0x10,%esp
80101932:	eb cf                	jmp    80101903 <writei+0xc0>
    ip->size = off;
80101934:	8b 45 08             	mov    0x8(%ebp),%eax
80101937:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010193a:	83 ec 0c             	sub    $0xc,%esp
8010193d:	50                   	push   %eax
8010193e:	e8 c6 fa ff ff       	call   80101409 <iupdate>
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	eb b8                	jmp    80101900 <writei+0xbd>
      return -1;
80101948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010194d:	eb b4                	jmp    80101903 <writei+0xc0>
8010194f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101954:	eb ad                	jmp    80101903 <writei+0xc0>
    return -1;
80101956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010195b:	eb a6                	jmp    80101903 <writei+0xc0>
    return -1;
8010195d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101962:	eb 9f                	jmp    80101903 <writei+0xc0>

80101964 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101964:	55                   	push   %ebp
80101965:	89 e5                	mov    %esp,%ebp
80101967:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010196a:	6a 0e                	push   $0xe
8010196c:	ff 75 0c             	push   0xc(%ebp)
8010196f:	ff 75 08             	push   0x8(%ebp)
80101972:	e8 24 25 00 00       	call   80103e9b <strncmp>
}
80101977:	c9                   	leave  
80101978:	c3                   	ret    

80101979 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101979:	55                   	push   %ebp
8010197a:	89 e5                	mov    %esp,%ebp
8010197c:	57                   	push   %edi
8010197d:	56                   	push   %esi
8010197e:	53                   	push   %ebx
8010197f:	83 ec 1c             	sub    $0x1c,%esp
80101982:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101985:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010198a:	75 15                	jne    801019a1 <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010198c:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101991:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101994:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
80101999:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
8010199d:	75 24                	jne    801019c3 <dirlookup+0x4a>
8010199f:	eb 6e                	jmp    80101a0f <dirlookup+0x96>
    panic("dirlookup not DIR");
801019a1:	83 ec 0c             	sub    $0xc,%esp
801019a4:	68 e3 76 10 80       	push   $0x801076e3
801019a9:	e8 92 e9 ff ff       	call   80100340 <panic>
      panic("dirlookup read");
801019ae:	83 ec 0c             	sub    $0xc,%esp
801019b1:	68 f5 76 10 80       	push   $0x801076f5
801019b6:	e8 85 e9 ff ff       	call   80100340 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019bb:	83 c3 10             	add    $0x10,%ebx
801019be:	39 5e 58             	cmp    %ebx,0x58(%esi)
801019c1:	76 47                	jbe    80101a0a <dirlookup+0x91>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019c3:	6a 10                	push   $0x10
801019c5:	53                   	push   %ebx
801019c6:	57                   	push   %edi
801019c7:	56                   	push   %esi
801019c8:	e8 7a fd ff ff       	call   80101747 <readi>
801019cd:	83 c4 10             	add    $0x10,%esp
801019d0:	83 f8 10             	cmp    $0x10,%eax
801019d3:	75 d9                	jne    801019ae <dirlookup+0x35>
    if(de.inum == 0)
801019d5:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801019da:	74 df                	je     801019bb <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
801019dc:	83 ec 08             	sub    $0x8,%esp
801019df:	8d 45 da             	lea    -0x26(%ebp),%eax
801019e2:	50                   	push   %eax
801019e3:	ff 75 0c             	push   0xc(%ebp)
801019e6:	e8 79 ff ff ff       	call   80101964 <namecmp>
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	85 c0                	test   %eax,%eax
801019f0:	75 c9                	jne    801019bb <dirlookup+0x42>
      if(poff)
801019f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801019f6:	74 05                	je     801019fd <dirlookup+0x84>
        *poff = off;
801019f8:	8b 45 10             	mov    0x10(%ebp),%eax
801019fb:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
801019fd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a01:	8b 06                	mov    (%esi),%eax
80101a03:	e8 ef f7 ff ff       	call   801011f7 <iget>
80101a08:	eb 05                	jmp    80101a0f <dirlookup+0x96>
  return 0;
80101a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a12:	5b                   	pop    %ebx
80101a13:	5e                   	pop    %esi
80101a14:	5f                   	pop    %edi
80101a15:	5d                   	pop    %ebp
80101a16:	c3                   	ret    

80101a17 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a17:	55                   	push   %ebp
80101a18:	89 e5                	mov    %esp,%ebp
80101a1a:	57                   	push   %edi
80101a1b:	56                   	push   %esi
80101a1c:	53                   	push   %ebx
80101a1d:	83 ec 1c             	sub    $0x1c,%esp
80101a20:	89 c3                	mov    %eax,%ebx
80101a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a25:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a28:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a2b:	74 1a                	je     80101a47 <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a2d:	e8 7e 18 00 00       	call   801032b0 <myproc>
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	ff 70 68             	push   0x68(%eax)
80101a38:	e8 4b fa ff ff       	call   80101488 <idup>
80101a3d:	89 c7                	mov    %eax,%edi
80101a3f:	83 c4 10             	add    $0x10,%esp
80101a42:	e9 c2 00 00 00       	jmp    80101b09 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
80101a47:	ba 01 00 00 00       	mov    $0x1,%edx
80101a4c:	b8 01 00 00 00       	mov    $0x1,%eax
80101a51:	e8 a1 f7 ff ff       	call   801011f7 <iget>
80101a56:	89 c7                	mov    %eax,%edi
80101a58:	e9 ac 00 00 00       	jmp    80101b09 <namex+0xf2>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a5d:	83 ec 0c             	sub    $0xc,%esp
80101a60:	57                   	push   %edi
80101a61:	e8 96 fc ff ff       	call   801016fc <iunlockput>
      return 0;
80101a66:	83 c4 10             	add    $0x10,%esp
80101a69:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a6e:	89 f8                	mov    %edi,%eax
80101a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a73:	5b                   	pop    %ebx
80101a74:	5e                   	pop    %esi
80101a75:	5f                   	pop    %edi
80101a76:	5d                   	pop    %ebp
80101a77:	c3                   	ret    
      iunlock(ip);
80101a78:	83 ec 0c             	sub    $0xc,%esp
80101a7b:	57                   	push   %edi
80101a7c:	e8 f4 fa ff ff       	call   80101575 <iunlock>
      return ip;
80101a81:	83 c4 10             	add    $0x10,%esp
80101a84:	eb e8                	jmp    80101a6e <namex+0x57>
      iunlockput(ip);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	57                   	push   %edi
80101a8a:	e8 6d fc ff ff       	call   801016fc <iunlockput>
      return 0;
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	89 f7                	mov    %esi,%edi
80101a94:	eb d8                	jmp    80101a6e <namex+0x57>
  len = path - s;
80101a96:	89 f0                	mov    %esi,%eax
80101a98:	29 d8                	sub    %ebx,%eax
80101a9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101a9d:	83 f8 0d             	cmp    $0xd,%eax
80101aa0:	0f 8e a5 00 00 00    	jle    80101b4b <namex+0x134>
    memmove(name, s, DIRSIZ);
80101aa6:	83 ec 04             	sub    $0x4,%esp
80101aa9:	6a 0e                	push   $0xe
80101aab:	53                   	push   %ebx
80101aac:	ff 75 e4             	push   -0x1c(%ebp)
80101aaf:	e8 80 23 00 00       	call   80103e34 <memmove>
80101ab4:	83 c4 10             	add    $0x10,%esp
    path++;
80101ab7:	89 f3                	mov    %esi,%ebx
  while(*path == '/')
80101ab9:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101abc:	75 08                	jne    80101ac6 <namex+0xaf>
    path++;
80101abe:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ac1:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ac4:	74 f8                	je     80101abe <namex+0xa7>
    ilock(ip);
80101ac6:	83 ec 0c             	sub    $0xc,%esp
80101ac9:	57                   	push   %edi
80101aca:	e8 e4 f9 ff ff       	call   801014b3 <ilock>
    if(ip->type != T_DIR){
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101ad7:	75 84                	jne    80101a5d <namex+0x46>
    if(nameiparent && *path == '\0'){
80101ad9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101add:	74 05                	je     80101ae4 <namex+0xcd>
80101adf:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ae2:	74 94                	je     80101a78 <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101ae4:	83 ec 04             	sub    $0x4,%esp
80101ae7:	6a 00                	push   $0x0
80101ae9:	ff 75 e4             	push   -0x1c(%ebp)
80101aec:	57                   	push   %edi
80101aed:	e8 87 fe ff ff       	call   80101979 <dirlookup>
80101af2:	89 c6                	mov    %eax,%esi
80101af4:	83 c4 10             	add    $0x10,%esp
80101af7:	85 c0                	test   %eax,%eax
80101af9:	74 8b                	je     80101a86 <namex+0x6f>
    iunlockput(ip);
80101afb:	83 ec 0c             	sub    $0xc,%esp
80101afe:	57                   	push   %edi
80101aff:	e8 f8 fb ff ff       	call   801016fc <iunlockput>
80101b04:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b07:	89 f7                	mov    %esi,%edi
  while(*path == '/')
80101b09:	0f b6 03             	movzbl (%ebx),%eax
80101b0c:	3c 2f                	cmp    $0x2f,%al
80101b0e:	75 0a                	jne    80101b1a <namex+0x103>
    path++;
80101b10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101b13:	0f b6 03             	movzbl (%ebx),%eax
80101b16:	3c 2f                	cmp    $0x2f,%al
80101b18:	74 f6                	je     80101b10 <namex+0xf9>
  if(*path == 0)
80101b1a:	84 c0                	test   %al,%al
80101b1c:	74 4e                	je     80101b6c <namex+0x155>
  while(*path != '/' && *path != 0)
80101b1e:	0f b6 03             	movzbl (%ebx),%eax
80101b21:	3c 2f                	cmp    $0x2f,%al
80101b23:	74 1d                	je     80101b42 <namex+0x12b>
80101b25:	84 c0                	test   %al,%al
80101b27:	74 19                	je     80101b42 <namex+0x12b>
80101b29:	89 de                	mov    %ebx,%esi
    path++;
80101b2b:	83 c6 01             	add    $0x1,%esi
  while(*path != '/' && *path != 0)
80101b2e:	0f b6 06             	movzbl (%esi),%eax
80101b31:	3c 2f                	cmp    $0x2f,%al
80101b33:	0f 84 5d ff ff ff    	je     80101a96 <namex+0x7f>
80101b39:	84 c0                	test   %al,%al
80101b3b:	75 ee                	jne    80101b2b <namex+0x114>
80101b3d:	e9 54 ff ff ff       	jmp    80101a96 <namex+0x7f>
80101b42:	89 de                	mov    %ebx,%esi
  len = path - s;
80101b44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    memmove(name, s, len);
80101b4b:	83 ec 04             	sub    $0x4,%esp
80101b4e:	ff 75 e0             	push   -0x20(%ebp)
80101b51:	53                   	push   %ebx
80101b52:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b55:	53                   	push   %ebx
80101b56:	e8 d9 22 00 00       	call   80103e34 <memmove>
    name[len] = 0;
80101b5b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b5e:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
80101b62:	83 c4 10             	add    $0x10,%esp
80101b65:	89 f3                	mov    %esi,%ebx
80101b67:	e9 4d ff ff ff       	jmp    80101ab9 <namex+0xa2>
  if(nameiparent){
80101b6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101b70:	0f 84 f8 fe ff ff    	je     80101a6e <namex+0x57>
    iput(ip);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	57                   	push   %edi
80101b7a:	e8 3b fa ff ff       	call   801015ba <iput>
    return 0;
80101b7f:	83 c4 10             	add    $0x10,%esp
80101b82:	bf 00 00 00 00       	mov    $0x0,%edi
80101b87:	e9 e2 fe ff ff       	jmp    80101a6e <namex+0x57>

80101b8c <dirlink>:
{
80101b8c:	55                   	push   %ebp
80101b8d:	89 e5                	mov    %esp,%ebp
80101b8f:	57                   	push   %edi
80101b90:	56                   	push   %esi
80101b91:	53                   	push   %ebx
80101b92:	83 ec 20             	sub    $0x20,%esp
80101b95:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b98:	6a 00                	push   $0x0
80101b9a:	ff 75 0c             	push   0xc(%ebp)
80101b9d:	56                   	push   %esi
80101b9e:	e8 d6 fd ff ff       	call   80101979 <dirlookup>
80101ba3:	83 c4 10             	add    $0x10,%esp
80101ba6:	85 c0                	test   %eax,%eax
80101ba8:	75 6a                	jne    80101c14 <dirlink+0x88>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101baa:	8b 5e 58             	mov    0x58(%esi),%ebx
80101bad:	85 db                	test   %ebx,%ebx
80101baf:	74 29                	je     80101bda <dirlink+0x4e>
80101bb1:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb6:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bb9:	6a 10                	push   $0x10
80101bbb:	53                   	push   %ebx
80101bbc:	57                   	push   %edi
80101bbd:	56                   	push   %esi
80101bbe:	e8 84 fb ff ff       	call   80101747 <readi>
80101bc3:	83 c4 10             	add    $0x10,%esp
80101bc6:	83 f8 10             	cmp    $0x10,%eax
80101bc9:	75 5c                	jne    80101c27 <dirlink+0x9b>
    if(de.inum == 0)
80101bcb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd0:	74 08                	je     80101bda <dirlink+0x4e>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd2:	83 c3 10             	add    $0x10,%ebx
80101bd5:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101bd8:	72 df                	jb     80101bb9 <dirlink+0x2d>
  strncpy(de.name, name, DIRSIZ);
80101bda:	83 ec 04             	sub    $0x4,%esp
80101bdd:	6a 0e                	push   $0xe
80101bdf:	ff 75 0c             	push   0xc(%ebp)
80101be2:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101be5:	8d 45 da             	lea    -0x26(%ebp),%eax
80101be8:	50                   	push   %eax
80101be9:	e8 f3 22 00 00       	call   80103ee1 <strncpy>
  de.inum = inum;
80101bee:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf1:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf5:	6a 10                	push   $0x10
80101bf7:	53                   	push   %ebx
80101bf8:	57                   	push   %edi
80101bf9:	56                   	push   %esi
80101bfa:	e8 44 fc ff ff       	call   80101843 <writei>
80101bff:	83 c4 20             	add    $0x20,%esp
80101c02:	83 f8 10             	cmp    $0x10,%eax
80101c05:	75 2d                	jne    80101c34 <dirlink+0xa8>
  return 0;
80101c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0f:	5b                   	pop    %ebx
80101c10:	5e                   	pop    %esi
80101c11:	5f                   	pop    %edi
80101c12:	5d                   	pop    %ebp
80101c13:	c3                   	ret    
    iput(ip);
80101c14:	83 ec 0c             	sub    $0xc,%esp
80101c17:	50                   	push   %eax
80101c18:	e8 9d f9 ff ff       	call   801015ba <iput>
    return -1;
80101c1d:	83 c4 10             	add    $0x10,%esp
80101c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c25:	eb e5                	jmp    80101c0c <dirlink+0x80>
      panic("dirlink read");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 04 77 10 80       	push   $0x80107704
80101c2f:	e8 0c e7 ff ff       	call   80100340 <panic>
    panic("dirlink");
80101c34:	83 ec 0c             	sub    $0xc,%esp
80101c37:	68 26 7d 10 80       	push   $0x80107d26
80101c3c:	e8 ff e6 ff ff       	call   80100340 <panic>

80101c41 <namei>:

struct inode*
namei(char *path)
{
80101c41:	55                   	push   %ebp
80101c42:	89 e5                	mov    %esp,%ebp
80101c44:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c47:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c4a:	ba 00 00 00 00       	mov    $0x0,%edx
80101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c52:	e8 c0 fd ff ff       	call   80101a17 <namex>
}
80101c57:	c9                   	leave  
80101c58:	c3                   	ret    

80101c59 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c59:	55                   	push   %ebp
80101c5a:	89 e5                	mov    %esp,%ebp
80101c5c:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c62:	ba 01 00 00 00       	mov    $0x1,%edx
80101c67:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6a:	e8 a8 fd ff ff       	call   80101a17 <namex>
}
80101c6f:	c9                   	leave  
80101c70:	c3                   	ret    

80101c71 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c71:	55                   	push   %ebp
80101c72:	89 e5                	mov    %esp,%ebp
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
  if(b == 0)
80101c76:	85 c0                	test   %eax,%eax
80101c78:	0f 84 8b 00 00 00    	je     80101d09 <idestart+0x98>
80101c7e:	89 c1                	mov    %eax,%ecx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c80:	8b 58 08             	mov    0x8(%eax),%ebx
80101c83:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c89:	0f 87 87 00 00 00    	ja     80101d16 <idestart+0xa5>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c8f:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c94:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c95:	83 e0 c0             	and    $0xffffffc0,%eax
80101c98:	3c 40                	cmp    $0x40,%al
80101c9a:	75 f8                	jne    80101c94 <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c9c:	be 00 00 00 00       	mov    $0x0,%esi
80101ca1:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ca6:	89 f0                	mov    %esi,%eax
80101ca8:	ee                   	out    %al,(%dx)
80101ca9:	b8 01 00 00 00       	mov    $0x1,%eax
80101cae:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cb3:	ee                   	out    %al,(%dx)
80101cb4:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cb9:	89 d8                	mov    %ebx,%eax
80101cbb:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cbc:	89 d8                	mov    %ebx,%eax
80101cbe:	c1 f8 08             	sar    $0x8,%eax
80101cc1:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101cc6:	ee                   	out    %al,(%dx)
80101cc7:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101ccc:	89 f0                	mov    %esi,%eax
80101cce:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ccf:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101cd3:	c1 e0 04             	shl    $0x4,%eax
80101cd6:	83 e0 10             	and    $0x10,%eax
80101cd9:	83 c8 e0             	or     $0xffffffe0,%eax
80101cdc:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ce1:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ce2:	f6 01 04             	testb  $0x4,(%ecx)
80101ce5:	74 3c                	je     80101d23 <idestart+0xb2>
80101ce7:	b8 30 00 00 00       	mov    $0x30,%eax
80101cec:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cf1:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cf2:	8d 71 5c             	lea    0x5c(%ecx),%esi
  asm volatile("cld; rep outsl" :
80101cf5:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cfa:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cff:	fc                   	cld    
80101d00:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d05:	5b                   	pop    %ebx
80101d06:	5e                   	pop    %esi
80101d07:	5d                   	pop    %ebp
80101d08:	c3                   	ret    
    panic("idestart");
80101d09:	83 ec 0c             	sub    $0xc,%esp
80101d0c:	68 67 77 10 80       	push   $0x80107767
80101d11:	e8 2a e6 ff ff       	call   80100340 <panic>
    panic("incorrect blockno");
80101d16:	83 ec 0c             	sub    $0xc,%esp
80101d19:	68 70 77 10 80       	push   $0x80107770
80101d1e:	e8 1d e6 ff ff       	call   80100340 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d23:	b8 20 00 00 00       	mov    $0x20,%eax
80101d28:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d2d:	ee                   	out    %al,(%dx)
}
80101d2e:	eb d2                	jmp    80101d02 <idestart+0x91>

80101d30 <ideinit>:
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d36:	68 82 77 10 80       	push   $0x80107782
80101d3b:	68 00 26 11 80       	push   $0x80112600
80101d40:	e8 73 1e 00 00       	call   80103bb8 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d45:	83 c4 08             	add    $0x8,%esp
80101d48:	a1 84 27 11 80       	mov    0x80112784,%eax
80101d4d:	83 e8 01             	sub    $0x1,%eax
80101d50:	50                   	push   %eax
80101d51:	6a 0e                	push   $0xe
80101d53:	e8 71 02 00 00       	call   80101fc9 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d58:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d5b:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d60:	ec                   	in     (%dx),%al
80101d61:	83 e0 c0             	and    $0xffffffc0,%eax
80101d64:	3c 40                	cmp    $0x40,%al
80101d66:	75 f8                	jne    80101d60 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d68:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101d6d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d72:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d73:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d78:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d79:	84 c0                	test   %al,%al
80101d7b:	75 11                	jne    80101d8e <ideinit+0x5e>
80101d7d:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101d82:	ec                   	in     (%dx),%al
80101d83:	84 c0                	test   %al,%al
80101d85:	75 07                	jne    80101d8e <ideinit+0x5e>
  for(i=0; i<1000; i++){
80101d87:	83 e9 01             	sub    $0x1,%ecx
80101d8a:	75 f6                	jne    80101d82 <ideinit+0x52>
80101d8c:	eb 0a                	jmp    80101d98 <ideinit+0x68>
      havedisk1 = 1;
80101d8e:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80101d95:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d98:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101d9d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101da2:	ee                   	out    %al,(%dx)
}
80101da3:	c9                   	leave  
80101da4:	c3                   	ret    

80101da5 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101da5:	55                   	push   %ebp
80101da6:	89 e5                	mov    %esp,%ebp
80101da8:	57                   	push   %edi
80101da9:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101daa:	83 ec 0c             	sub    $0xc,%esp
80101dad:	68 00 26 11 80       	push   $0x80112600
80101db2:	e8 4a 1f 00 00       	call   80103d01 <acquire>

  if((b = idequeue) == 0){
80101db7:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80101dbd:	83 c4 10             	add    $0x10,%esp
80101dc0:	85 db                	test   %ebx,%ebx
80101dc2:	74 48                	je     80101e0c <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dc4:	8b 43 58             	mov    0x58(%ebx),%eax
80101dc7:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dcc:	f6 03 04             	testb  $0x4,(%ebx)
80101dcf:	74 4d                	je     80101e1e <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101dd1:	8b 03                	mov    (%ebx),%eax
80101dd3:	83 e0 fb             	and    $0xfffffffb,%eax
80101dd6:	83 c8 02             	or     $0x2,%eax
80101dd9:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	53                   	push   %ebx
80101ddf:	e8 f3 1a 00 00       	call   801038d7 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101de4:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80101de9:	83 c4 10             	add    $0x10,%esp
80101dec:	85 c0                	test   %eax,%eax
80101dee:	74 05                	je     80101df5 <ideintr+0x50>
    idestart(idequeue);
80101df0:	e8 7c fe ff ff       	call   80101c71 <idestart>

  release(&idelock);
80101df5:	83 ec 0c             	sub    $0xc,%esp
80101df8:	68 00 26 11 80       	push   $0x80112600
80101dfd:	e8 66 1f 00 00       	call   80103d68 <release>
80101e02:	83 c4 10             	add    $0x10,%esp
}
80101e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e08:	5b                   	pop    %ebx
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    release(&idelock);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	68 00 26 11 80       	push   $0x80112600
80101e14:	e8 4f 1f 00 00       	call   80103d68 <release>
    return;
80101e19:	83 c4 10             	add    $0x10,%esp
80101e1c:	eb e7                	jmp    80101e05 <ideintr+0x60>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e23:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e24:	89 c1                	mov    %eax,%ecx
80101e26:	83 e1 c0             	and    $0xffffffc0,%ecx
80101e29:	80 f9 40             	cmp    $0x40,%cl
80101e2c:	75 f5                	jne    80101e23 <ideintr+0x7e>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e2e:	a8 21                	test   $0x21,%al
80101e30:	75 9f                	jne    80101dd1 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101e32:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e35:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e3a:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e3f:	fc                   	cld    
80101e40:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e42:	eb 8d                	jmp    80101dd1 <ideintr+0x2c>

80101e44 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e44:	55                   	push   %ebp
80101e45:	89 e5                	mov    %esp,%ebp
80101e47:	53                   	push   %ebx
80101e48:	83 ec 10             	sub    $0x10,%esp
80101e4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e4e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e51:	50                   	push   %eax
80101e52:	e8 17 1d 00 00       	call   80103b6e <holdingsleep>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	0f 84 91 00 00 00    	je     80101ef3 <iderw+0xaf>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e62:	8b 03                	mov    (%ebx),%eax
80101e64:	83 e0 06             	and    $0x6,%eax
80101e67:	83 f8 02             	cmp    $0x2,%eax
80101e6a:	0f 84 90 00 00 00    	je     80101f00 <iderw+0xbc>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e70:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e74:	74 0d                	je     80101e83 <iderw+0x3f>
80101e76:	83 3d e0 25 11 80 00 	cmpl   $0x0,0x801125e0
80101e7d:	0f 84 8a 00 00 00    	je     80101f0d <iderw+0xc9>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e83:	83 ec 0c             	sub    $0xc,%esp
80101e86:	68 00 26 11 80       	push   $0x80112600
80101e8b:	e8 71 1e 00 00       	call   80103d01 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e90:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e97:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	85 c0                	test   %eax,%eax
80101ea1:	74 77                	je     80101f1a <iderw+0xd6>
80101ea3:	89 c2                	mov    %eax,%edx
80101ea5:	8b 40 58             	mov    0x58(%eax),%eax
80101ea8:	85 c0                	test   %eax,%eax
80101eaa:	75 f7                	jne    80101ea3 <iderw+0x5f>
80101eac:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101eaf:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101eb1:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80101eb7:	74 68                	je     80101f21 <iderw+0xdd>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101eb9:	8b 03                	mov    (%ebx),%eax
80101ebb:	83 e0 06             	and    $0x6,%eax
80101ebe:	83 f8 02             	cmp    $0x2,%eax
80101ec1:	74 1b                	je     80101ede <iderw+0x9a>
    sleep(b, &idelock);
80101ec3:	83 ec 08             	sub    $0x8,%esp
80101ec6:	68 00 26 11 80       	push   $0x80112600
80101ecb:	53                   	push   %ebx
80101ecc:	e8 88 18 00 00       	call   80103759 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ed1:	8b 03                	mov    (%ebx),%eax
80101ed3:	83 e0 06             	and    $0x6,%eax
80101ed6:	83 c4 10             	add    $0x10,%esp
80101ed9:	83 f8 02             	cmp    $0x2,%eax
80101edc:	75 e5                	jne    80101ec3 <iderw+0x7f>
  }


  release(&idelock);
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 00 26 11 80       	push   $0x80112600
80101ee6:	e8 7d 1e 00 00       	call   80103d68 <release>
}
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ef1:	c9                   	leave  
80101ef2:	c3                   	ret    
    panic("iderw: buf not locked");
80101ef3:	83 ec 0c             	sub    $0xc,%esp
80101ef6:	68 86 77 10 80       	push   $0x80107786
80101efb:	e8 40 e4 ff ff       	call   80100340 <panic>
    panic("iderw: nothing to do");
80101f00:	83 ec 0c             	sub    $0xc,%esp
80101f03:	68 9c 77 10 80       	push   $0x8010779c
80101f08:	e8 33 e4 ff ff       	call   80100340 <panic>
    panic("iderw: ide disk 1 not present");
80101f0d:	83 ec 0c             	sub    $0xc,%esp
80101f10:	68 b1 77 10 80       	push   $0x801077b1
80101f15:	e8 26 e4 ff ff       	call   80100340 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f1a:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80101f1f:	eb 8e                	jmp    80101eaf <iderw+0x6b>
    idestart(b);
80101f21:	89 d8                	mov    %ebx,%eax
80101f23:	e8 49 fd ff ff       	call   80101c71 <idestart>
80101f28:	eb 8f                	jmp    80101eb9 <iderw+0x75>

80101f2a <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101f2a:	55                   	push   %ebp
80101f2b:	89 e5                	mov    %esp,%ebp
80101f2d:	56                   	push   %esi
80101f2e:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f2f:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f36:	00 c0 fe 
  ioapic->reg = reg;
80101f39:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101f40:	00 00 00 
  return ioapic->data;
80101f43:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f48:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f4b:	c1 eb 10             	shr    $0x10,%ebx
80101f4e:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
80101f51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80101f57:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f5c:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80101f5f:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  id = ioapicread(REG_ID) >> 24;
80101f66:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f69:	39 c2                	cmp    %eax,%edx
80101f6b:	75 4a                	jne    80101fb7 <ioapicinit+0x8d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101f6d:	8d 74 1b 12          	lea    0x12(%ebx,%ebx,1),%esi
{
80101f71:	b8 10 00 00 00       	mov    $0x10,%eax
80101f76:	ba 20 00 00 00       	mov    $0x20,%edx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f7b:	89 d3                	mov    %edx,%ebx
80101f7d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->reg = reg;
80101f83:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f89:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f8b:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f91:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80101f94:	8d 58 01             	lea    0x1(%eax),%ebx
80101f97:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80101f99:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f9f:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80101fa6:	83 c2 01             	add    $0x1,%edx
80101fa9:	83 c0 02             	add    $0x2,%eax
80101fac:	39 f0                	cmp    %esi,%eax
80101fae:	75 cb                	jne    80101f7b <ioapicinit+0x51>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80101fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fb3:	5b                   	pop    %ebx
80101fb4:	5e                   	pop    %esi
80101fb5:	5d                   	pop    %ebp
80101fb6:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101fb7:	83 ec 0c             	sub    $0xc,%esp
80101fba:	68 d0 77 10 80       	push   $0x801077d0
80101fbf:	e8 3d e6 ff ff       	call   80100601 <cprintf>
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	eb a4                	jmp    80101f6d <ioapicinit+0x43>

80101fc9 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fc9:	55                   	push   %ebp
80101fca:	89 e5                	mov    %esp,%ebp
80101fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fcf:	8d 50 20             	lea    0x20(%eax),%edx
80101fd2:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80101fd6:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101fdc:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101fde:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101fe4:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fea:	c1 e2 18             	shl    $0x18,%edx
80101fed:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
80101ff0:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101ff2:	a1 34 26 11 80       	mov    0x80112634,%eax
80101ff7:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ffa:	5d                   	pop    %ebp
80101ffb:	c3                   	ret    

80101ffc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101ffc:	55                   	push   %ebp
80101ffd:	89 e5                	mov    %esp,%ebp
80101fff:	53                   	push   %ebx
80102000:	83 ec 04             	sub    $0x4,%esp
80102003:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102006:	81 fb 60 79 11 80    	cmp    $0x80117960,%ebx
8010200c:	0f 92 c0             	setb   %al
8010200f:	89 d9                	mov    %ebx,%ecx
80102011:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
80102017:	75 49                	jne    80102062 <kfree+0x66>
80102019:	84 c0                	test   %al,%al
8010201b:	75 45                	jne    80102062 <kfree+0x66>
8010201d:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80102023:	81 fa ff ff ff 0d    	cmp    $0xdffffff,%edx
80102029:	77 37                	ja     80102062 <kfree+0x66>
    cprintf("%d %d %d\n",(uint)v%PGSIZE ,v<end,V2P(v)>=PHYSTOP);
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE); // garbage value
8010202b:	83 ec 04             	sub    $0x4,%esp
8010202e:	68 00 10 00 00       	push   $0x1000
80102033:	6a 01                	push   $0x1
80102035:	53                   	push   %ebx
80102036:	e8 74 1d 00 00       	call   80103daf <memset>

  if(kmem.use_lock)
8010203b:	83 c4 10             	add    $0x10,%esp
8010203e:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102045:	75 49                	jne    80102090 <kfree+0x94>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102047:	a1 78 26 11 80       	mov    0x80112678,%eax
8010204c:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
8010204e:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102054:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010205b:	75 45                	jne    801020a2 <kfree+0xa6>
    release(&kmem.lock);
}
8010205d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102060:	c9                   	leave  
80102061:	c3                   	ret    
    cprintf("%d %d %d\n",(uint)v%PGSIZE ,v<end,V2P(v)>=PHYSTOP);
80102062:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80102068:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010206e:	0f 97 c2             	seta   %dl
80102071:	0f b6 d2             	movzbl %dl,%edx
80102074:	52                   	push   %edx
80102075:	0f b6 c0             	movzbl %al,%eax
80102078:	50                   	push   %eax
80102079:	51                   	push   %ecx
8010207a:	68 02 78 10 80       	push   $0x80107802
8010207f:	e8 7d e5 ff ff       	call   80100601 <cprintf>
    panic("kfree");
80102084:	c7 04 24 0c 78 10 80 	movl   $0x8010780c,(%esp)
8010208b:	e8 b0 e2 ff ff       	call   80100340 <panic>
    acquire(&kmem.lock);
80102090:	83 ec 0c             	sub    $0xc,%esp
80102093:	68 40 26 11 80       	push   $0x80112640
80102098:	e8 64 1c 00 00       	call   80103d01 <acquire>
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	eb a5                	jmp    80102047 <kfree+0x4b>
    release(&kmem.lock);
801020a2:	83 ec 0c             	sub    $0xc,%esp
801020a5:	68 40 26 11 80       	push   $0x80112640
801020aa:	e8 b9 1c 00 00       	call   80103d68 <release>
801020af:	83 c4 10             	add    $0x10,%esp
}
801020b2:	eb a9                	jmp    8010205d <kfree+0x61>

801020b4 <freerange>:
{
801020b4:	55                   	push   %ebp
801020b5:	89 e5                	mov    %esp,%ebp
801020b7:	56                   	push   %esi
801020b8:	53                   	push   %ebx
801020b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801020bc:	8b 45 08             	mov    0x8(%ebp),%eax
801020bf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801020c5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020d1:	39 de                	cmp    %ebx,%esi
801020d3:	72 1c                	jb     801020f1 <freerange+0x3d>
    kfree(p);
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801020de:	50                   	push   %eax
801020df:	e8 18 ff ff ff       	call   80101ffc <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020ea:	83 c4 10             	add    $0x10,%esp
801020ed:	39 f3                	cmp    %esi,%ebx
801020ef:	76 e4                	jbe    801020d5 <freerange+0x21>
}
801020f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020f4:	5b                   	pop    %ebx
801020f5:	5e                   	pop    %esi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    

801020f8 <kinit1>:
{
801020f8:	55                   	push   %ebp
801020f9:	89 e5                	mov    %esp,%ebp
801020fb:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020fe:	68 12 78 10 80       	push   $0x80107812
80102103:	68 40 26 11 80       	push   $0x80112640
80102108:	e8 ab 1a 00 00       	call   80103bb8 <initlock>
  kmem.use_lock = 0;
8010210d:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102114:	00 00 00 
  freerange(vstart, vend);
80102117:	83 c4 08             	add    $0x8,%esp
8010211a:	ff 75 0c             	push   0xc(%ebp)
8010211d:	ff 75 08             	push   0x8(%ebp)
80102120:	e8 8f ff ff ff       	call   801020b4 <freerange>
}
80102125:	83 c4 10             	add    $0x10,%esp
80102128:	c9                   	leave  
80102129:	c3                   	ret    

8010212a <kinit2>:
{
8010212a:	55                   	push   %ebp
8010212b:	89 e5                	mov    %esp,%ebp
8010212d:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102130:	ff 75 0c             	push   0xc(%ebp)
80102133:	ff 75 08             	push   0x8(%ebp)
80102136:	e8 79 ff ff ff       	call   801020b4 <freerange>
  kmem.use_lock = 1;
8010213b:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102142:	00 00 00 
}
80102145:	83 c4 10             	add    $0x10,%esp
80102148:	c9                   	leave  
80102149:	c3                   	ret    

8010214a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010214a:	55                   	push   %ebp
8010214b:	89 e5                	mov    %esp,%ebp
8010214d:	53                   	push   %ebx
8010214e:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102151:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102158:	75 21                	jne    8010217b <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010215a:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102160:	85 db                	test   %ebx,%ebx
80102162:	74 10                	je     80102174 <kalloc+0x2a>
    kmem.freelist = r->next; // first element of linked list changed
80102164:	8b 03                	mov    (%ebx),%eax
80102166:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
8010216b:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102172:	75 23                	jne    80102197 <kalloc+0x4d>
    release(&kmem.lock);
  return (char*)r;
}
80102174:	89 d8                	mov    %ebx,%eax
80102176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102179:	c9                   	leave  
8010217a:	c3                   	ret    
    acquire(&kmem.lock);
8010217b:	83 ec 0c             	sub    $0xc,%esp
8010217e:	68 40 26 11 80       	push   $0x80112640
80102183:	e8 79 1b 00 00       	call   80103d01 <acquire>
  r = kmem.freelist;
80102188:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
8010218e:	83 c4 10             	add    $0x10,%esp
80102191:	85 db                	test   %ebx,%ebx
80102193:	75 cf                	jne    80102164 <kalloc+0x1a>
80102195:	eb d4                	jmp    8010216b <kalloc+0x21>
    release(&kmem.lock);
80102197:	83 ec 0c             	sub    $0xc,%esp
8010219a:	68 40 26 11 80       	push   $0x80112640
8010219f:	e8 c4 1b 00 00       	call   80103d68 <release>
801021a4:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021a7:	eb cb                	jmp    80102174 <kalloc+0x2a>

801021a9 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a9:	ba 64 00 00 00       	mov    $0x64,%edx
801021ae:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021af:	a8 01                	test   $0x1,%al
801021b1:	0f 84 ad 00 00 00    	je     80102264 <kbdgetc+0xbb>
801021b7:	ba 60 00 00 00       	mov    $0x60,%edx
801021bc:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021bd:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801021c0:	3c e0                	cmp    $0xe0,%al
801021c2:	74 5b                	je     8010221f <kbdgetc+0x76>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021c4:	84 c0                	test   %al,%al
801021c6:	78 64                	js     8010222c <kbdgetc+0x83>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021c8:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
801021ce:	f6 c2 40             	test   $0x40,%dl
801021d1:	74 0f                	je     801021e2 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021d3:	83 c8 80             	or     $0xffffff80,%eax
801021d6:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
801021d9:	83 e2 bf             	and    $0xffffffbf,%edx
801021dc:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  }

  shift |= shiftcode[data];
801021e2:	0f b6 91 40 79 10 80 	movzbl -0x7fef86c0(%ecx),%edx
801021e9:	0b 15 7c 26 11 80    	or     0x8011267c,%edx
  shift ^= togglecode[data];
801021ef:	0f b6 81 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%eax
801021f6:	31 c2                	xor    %eax,%edx
801021f8:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801021fe:	89 d0                	mov    %edx,%eax
80102200:	83 e0 03             	and    $0x3,%eax
80102203:	8b 04 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%eax
8010220a:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
8010220e:	f6 c2 08             	test   $0x8,%dl
80102211:	74 56                	je     80102269 <kbdgetc+0xc0>
    if('a' <= c && c <= 'z')
80102213:	8d 50 9f             	lea    -0x61(%eax),%edx
80102216:	83 fa 19             	cmp    $0x19,%edx
80102219:	77 3c                	ja     80102257 <kbdgetc+0xae>
      c += 'A' - 'a';
8010221b:	83 e8 20             	sub    $0x20,%eax
8010221e:	c3                   	ret    
    shift |= E0ESC;
8010221f:	83 0d 7c 26 11 80 40 	orl    $0x40,0x8011267c
    return 0;
80102226:	b8 00 00 00 00       	mov    $0x0,%eax
8010222b:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
8010222c:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
80102232:	83 e0 7f             	and    $0x7f,%eax
80102235:	f6 c2 40             	test   $0x40,%dl
80102238:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
8010223b:	0f b6 81 40 79 10 80 	movzbl -0x7fef86c0(%ecx),%eax
80102242:	83 c8 40             	or     $0x40,%eax
80102245:	0f b6 c0             	movzbl %al,%eax
80102248:	f7 d0                	not    %eax
8010224a:	21 d0                	and    %edx,%eax
8010224c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102251:	b8 00 00 00 00       	mov    $0x0,%eax
80102256:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102257:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010225a:	8d 50 20             	lea    0x20(%eax),%edx
8010225d:	83 f9 1a             	cmp    $0x1a,%ecx
80102260:	0f 42 c2             	cmovb  %edx,%eax
  }
  return c;
80102263:	c3                   	ret    
    return -1;
80102264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102269:	c3                   	ret    

8010226a <kbdintr>:

void
kbdintr(void)
{
8010226a:	55                   	push   %ebp
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102270:	68 a9 21 10 80       	push   $0x801021a9
80102275:	e8 e2 e4 ff ff       	call   8010075c <consoleintr>
}
8010227a:	83 c4 10             	add    $0x10,%esp
8010227d:	c9                   	leave  
8010227e:	c3                   	ret    

8010227f <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010227f:	8b 0d 80 26 11 80    	mov    0x80112680,%ecx
80102285:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102288:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010228a:	a1 80 26 11 80       	mov    0x80112680,%eax
8010228f:	8b 40 20             	mov    0x20(%eax),%eax
}
80102292:	c3                   	ret    

80102293 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102293:	55                   	push   %ebp
80102294:	89 e5                	mov    %esp,%ebp
80102296:	56                   	push   %esi
80102297:	53                   	push   %ebx
80102298:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010229a:	be 70 00 00 00       	mov    $0x70,%esi
8010229f:	b8 00 00 00 00       	mov    $0x0,%eax
801022a4:	89 f2                	mov    %esi,%edx
801022a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a7:	bb 71 00 00 00       	mov    $0x71,%ebx
801022ac:	89 da                	mov    %ebx,%edx
801022ae:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801022af:	0f b6 c0             	movzbl %al,%eax
801022b2:	89 01                	mov    %eax,(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b4:	b8 02 00 00 00       	mov    $0x2,%eax
801022b9:	89 f2                	mov    %esi,%edx
801022bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022bc:	89 da                	mov    %ebx,%edx
801022be:	ec                   	in     (%dx),%al
801022bf:	0f b6 c0             	movzbl %al,%eax
801022c2:	89 41 04             	mov    %eax,0x4(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c5:	b8 04 00 00 00       	mov    $0x4,%eax
801022ca:	89 f2                	mov    %esi,%edx
801022cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022cd:	89 da                	mov    %ebx,%edx
801022cf:	ec                   	in     (%dx),%al
801022d0:	0f b6 c0             	movzbl %al,%eax
801022d3:	89 41 08             	mov    %eax,0x8(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d6:	b8 07 00 00 00       	mov    $0x7,%eax
801022db:	89 f2                	mov    %esi,%edx
801022dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022de:	89 da                	mov    %ebx,%edx
801022e0:	ec                   	in     (%dx),%al
801022e1:	0f b6 c0             	movzbl %al,%eax
801022e4:	89 41 0c             	mov    %eax,0xc(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e7:	b8 08 00 00 00       	mov    $0x8,%eax
801022ec:	89 f2                	mov    %esi,%edx
801022ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ef:	89 da                	mov    %ebx,%edx
801022f1:	ec                   	in     (%dx),%al
801022f2:	0f b6 c0             	movzbl %al,%eax
801022f5:	89 41 10             	mov    %eax,0x10(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f8:	b8 09 00 00 00       	mov    $0x9,%eax
801022fd:	89 f2                	mov    %esi,%edx
801022ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102300:	89 da                	mov    %ebx,%edx
80102302:	ec                   	in     (%dx),%al
80102303:	0f b6 c0             	movzbl %al,%eax
80102306:	89 41 14             	mov    %eax,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102309:	5b                   	pop    %ebx
8010230a:	5e                   	pop    %esi
8010230b:	5d                   	pop    %ebp
8010230c:	c3                   	ret    

8010230d <lapicinit>:
  if(!lapic)
8010230d:	83 3d 80 26 11 80 00 	cmpl   $0x0,0x80112680
80102314:	0f 84 ff 00 00 00    	je     80102419 <lapicinit+0x10c>
{
8010231a:	55                   	push   %ebp
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102320:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102325:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010232a:	e8 50 ff ff ff       	call   8010227f <lapicw>
  lapicw(TDCR, X1);
8010232f:	ba 0b 00 00 00       	mov    $0xb,%edx
80102334:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102339:	e8 41 ff ff ff       	call   8010227f <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010233e:	ba 20 00 02 00       	mov    $0x20020,%edx
80102343:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102348:	e8 32 ff ff ff       	call   8010227f <lapicw>
  lapicw(TICR, 10000000);
8010234d:	ba 80 96 98 00       	mov    $0x989680,%edx
80102352:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102357:	e8 23 ff ff ff       	call   8010227f <lapicw>
  lapicw(LINT0, MASKED);
8010235c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102361:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102366:	e8 14 ff ff ff       	call   8010227f <lapicw>
  lapicw(LINT1, MASKED);
8010236b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102370:	b8 d8 00 00 00       	mov    $0xd8,%eax
80102375:	e8 05 ff ff ff       	call   8010227f <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010237a:	a1 80 26 11 80       	mov    0x80112680,%eax
8010237f:	8b 40 30             	mov    0x30(%eax),%eax
80102382:	c1 e8 10             	shr    $0x10,%eax
80102385:	a8 fc                	test   $0xfc,%al
80102387:	75 7c                	jne    80102405 <lapicinit+0xf8>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102389:	ba 33 00 00 00       	mov    $0x33,%edx
8010238e:	b8 dc 00 00 00       	mov    $0xdc,%eax
80102393:	e8 e7 fe ff ff       	call   8010227f <lapicw>
  lapicw(ESR, 0);
80102398:	ba 00 00 00 00       	mov    $0x0,%edx
8010239d:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023a2:	e8 d8 fe ff ff       	call   8010227f <lapicw>
  lapicw(ESR, 0);
801023a7:	ba 00 00 00 00       	mov    $0x0,%edx
801023ac:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023b1:	e8 c9 fe ff ff       	call   8010227f <lapicw>
  lapicw(EOI, 0);
801023b6:	ba 00 00 00 00       	mov    $0x0,%edx
801023bb:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023c0:	e8 ba fe ff ff       	call   8010227f <lapicw>
  lapicw(ICRHI, 0);
801023c5:	ba 00 00 00 00       	mov    $0x0,%edx
801023ca:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023cf:	e8 ab fe ff ff       	call   8010227f <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801023d4:	ba 00 85 08 00       	mov    $0x88500,%edx
801023d9:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023de:	e8 9c fe ff ff       	call   8010227f <lapicw>
  while(lapic[ICRLO] & DELIVS)
801023e3:	8b 15 80 26 11 80    	mov    0x80112680,%edx
801023e9:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
801023ef:	f6 c4 10             	test   $0x10,%ah
801023f2:	75 f5                	jne    801023e9 <lapicinit+0xdc>
  lapicw(TPR, 0);
801023f4:	ba 00 00 00 00       	mov    $0x0,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	e8 7c fe ff ff       	call   8010227f <lapicw>
}
80102403:	c9                   	leave  
80102404:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102405:	ba 00 00 01 00       	mov    $0x10000,%edx
8010240a:	b8 d0 00 00 00       	mov    $0xd0,%eax
8010240f:	e8 6b fe ff ff       	call   8010227f <lapicw>
80102414:	e9 70 ff ff ff       	jmp    80102389 <lapicinit+0x7c>
80102419:	c3                   	ret    

8010241a <lapicid>:
  if (!lapic)
8010241a:	a1 80 26 11 80       	mov    0x80112680,%eax
8010241f:	85 c0                	test   %eax,%eax
80102421:	74 07                	je     8010242a <lapicid+0x10>
  return lapic[ID] >> 24;
80102423:	8b 40 20             	mov    0x20(%eax),%eax
80102426:	c1 e8 18             	shr    $0x18,%eax
80102429:	c3                   	ret    
    return 0;
8010242a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010242f:	c3                   	ret    

80102430 <lapiceoi>:
  if(lapic)
80102430:	83 3d 80 26 11 80 00 	cmpl   $0x0,0x80112680
80102437:	74 17                	je     80102450 <lapiceoi+0x20>
{
80102439:	55                   	push   %ebp
8010243a:	89 e5                	mov    %esp,%ebp
8010243c:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
8010243f:	ba 00 00 00 00       	mov    $0x0,%edx
80102444:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102449:	e8 31 fe ff ff       	call   8010227f <lapicw>
}
8010244e:	c9                   	leave  
8010244f:	c3                   	ret    
80102450:	c3                   	ret    

80102451 <microdelay>:
}
80102451:	c3                   	ret    

80102452 <lapicstartap>:
{
80102452:	55                   	push   %ebp
80102453:	89 e5                	mov    %esp,%ebp
80102455:	56                   	push   %esi
80102456:	53                   	push   %ebx
80102457:	8b 75 08             	mov    0x8(%ebp),%esi
8010245a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010245d:	b8 0f 00 00 00       	mov    $0xf,%eax
80102462:	ba 70 00 00 00       	mov    $0x70,%edx
80102467:	ee                   	out    %al,(%dx)
80102468:	b8 0a 00 00 00       	mov    $0xa,%eax
8010246d:	ba 71 00 00 00       	mov    $0x71,%edx
80102472:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102473:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010247a:	00 00 
  wrv[1] = addr >> 4;
8010247c:	89 d8                	mov    %ebx,%eax
8010247e:	c1 e8 04             	shr    $0x4,%eax
80102481:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
80102487:	c1 e6 18             	shl    $0x18,%esi
8010248a:	89 f2                	mov    %esi,%edx
8010248c:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102491:	e8 e9 fd ff ff       	call   8010227f <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102496:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010249b:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024a0:	e8 da fd ff ff       	call   8010227f <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024a5:	ba 00 85 00 00       	mov    $0x8500,%edx
801024aa:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024af:	e8 cb fd ff ff       	call   8010227f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024b4:	c1 eb 0c             	shr    $0xc,%ebx
801024b7:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
801024ba:	89 f2                	mov    %esi,%edx
801024bc:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024c1:	e8 b9 fd ff ff       	call   8010227f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024c6:	89 da                	mov    %ebx,%edx
801024c8:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024cd:	e8 ad fd ff ff       	call   8010227f <lapicw>
    lapicw(ICRHI, apicid<<24);
801024d2:	89 f2                	mov    %esi,%edx
801024d4:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024d9:	e8 a1 fd ff ff       	call   8010227f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024de:	89 da                	mov    %ebx,%edx
801024e0:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024e5:	e8 95 fd ff ff       	call   8010227f <lapicw>
}
801024ea:	5b                   	pop    %ebx
801024eb:	5e                   	pop    %esi
801024ec:	5d                   	pop    %ebp
801024ed:	c3                   	ret    

801024ee <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801024ee:	55                   	push   %ebp
801024ef:	89 e5                	mov    %esp,%ebp
801024f1:	57                   	push   %edi
801024f2:	56                   	push   %esi
801024f3:	53                   	push   %ebx
801024f4:	83 ec 4c             	sub    $0x4c,%esp
801024f7:	b8 0b 00 00 00       	mov    $0xb,%eax
801024fc:	ba 70 00 00 00       	mov    $0x70,%edx
80102501:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102502:	ba 71 00 00 00       	mov    $0x71,%edx
80102507:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102508:	83 e0 04             	and    $0x4,%eax
8010250b:	88 45 b7             	mov    %al,-0x49(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010250e:	8d 75 d0             	lea    -0x30(%ebp),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102511:	bf 0a 00 00 00       	mov    $0xa,%edi
80102516:	89 f0                	mov    %esi,%eax
80102518:	e8 76 fd ff ff       	call   80102293 <fill_rtcdate>
8010251d:	ba 70 00 00 00       	mov    $0x70,%edx
80102522:	89 f8                	mov    %edi,%eax
80102524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102525:	ba 71 00 00 00       	mov    $0x71,%edx
8010252a:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010252b:	84 c0                	test   %al,%al
8010252d:	78 e7                	js     80102516 <cmostime+0x28>
        continue;
    fill_rtcdate(&t2);
8010252f:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102532:	89 d8                	mov    %ebx,%eax
80102534:	e8 5a fd ff ff       	call   80102293 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102539:	83 ec 04             	sub    $0x4,%esp
8010253c:	6a 18                	push   $0x18
8010253e:	53                   	push   %ebx
8010253f:	56                   	push   %esi
80102540:	e8 ad 18 00 00       	call   80103df2 <memcmp>
80102545:	83 c4 10             	add    $0x10,%esp
80102548:	85 c0                	test   %eax,%eax
8010254a:	75 ca                	jne    80102516 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
8010254c:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102550:	75 78                	jne    801025ca <cmostime+0xdc>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102552:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102555:	89 c2                	mov    %eax,%edx
80102557:	c1 ea 04             	shr    $0x4,%edx
8010255a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010255d:	83 e0 0f             	and    $0xf,%eax
80102560:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102563:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102566:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102569:	89 c2                	mov    %eax,%edx
8010256b:	c1 ea 04             	shr    $0x4,%edx
8010256e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102571:	83 e0 0f             	and    $0xf,%eax
80102574:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102577:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010257a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010257d:	89 c2                	mov    %eax,%edx
8010257f:	c1 ea 04             	shr    $0x4,%edx
80102582:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102585:	83 e0 0f             	and    $0xf,%eax
80102588:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010258b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
8010258e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102591:	89 c2                	mov    %eax,%edx
80102593:	c1 ea 04             	shr    $0x4,%edx
80102596:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102599:	83 e0 0f             	and    $0xf,%eax
8010259c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010259f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025a5:	89 c2                	mov    %eax,%edx
801025a7:	c1 ea 04             	shr    $0x4,%edx
801025aa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ad:	83 e0 0f             	and    $0xf,%eax
801025b0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025b9:	89 c2                	mov    %eax,%edx
801025bb:	c1 ea 04             	shr    $0x4,%edx
801025be:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c1:	83 e0 0f             	and    $0xf,%eax
801025c4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801025d0:	89 01                	mov    %eax,(%ecx)
801025d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025d5:	89 41 04             	mov    %eax,0x4(%ecx)
801025d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025db:	89 41 08             	mov    %eax,0x8(%ecx)
801025de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025e1:	89 41 0c             	mov    %eax,0xc(%ecx)
801025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025e7:	89 41 10             	mov    %eax,0x10(%ecx)
801025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025ed:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801025f0:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801025f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025fa:	5b                   	pop    %ebx
801025fb:	5e                   	pop    %esi
801025fc:	5f                   	pop    %edi
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    

801025ff <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801025ff:	83 3d e8 26 11 80 00 	cmpl   $0x0,0x801126e8
80102606:	0f 8e 84 00 00 00    	jle    80102690 <install_trans+0x91>
{
8010260c:	55                   	push   %ebp
8010260d:	89 e5                	mov    %esp,%ebp
8010260f:	57                   	push   %edi
80102610:	56                   	push   %esi
80102611:	53                   	push   %ebx
80102612:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102615:	be 00 00 00 00       	mov    $0x0,%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010261a:	bf a0 26 11 80       	mov    $0x801126a0,%edi
8010261f:	83 ec 08             	sub    $0x8,%esp
80102622:	89 f0                	mov    %esi,%eax
80102624:	03 47 34             	add    0x34(%edi),%eax
80102627:	83 c0 01             	add    $0x1,%eax
8010262a:	50                   	push   %eax
8010262b:	ff 77 44             	push   0x44(%edi)
8010262e:	e8 77 da ff ff       	call   801000aa <bread>
80102633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102636:	83 c4 08             	add    $0x8,%esp
80102639:	ff 34 b5 ec 26 11 80 	push   -0x7feed914(,%esi,4)
80102640:	ff 77 44             	push   0x44(%edi)
80102643:	e8 62 da ff ff       	call   801000aa <bread>
80102648:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010264a:	83 c4 0c             	add    $0xc,%esp
8010264d:	68 00 02 00 00       	push   $0x200
80102652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102655:	83 c0 5c             	add    $0x5c,%eax
80102658:	50                   	push   %eax
80102659:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010265c:	50                   	push   %eax
8010265d:	e8 d2 17 00 00       	call   80103e34 <memmove>
    bwrite(dbuf);  // write dst to disk
80102662:	89 1c 24             	mov    %ebx,(%esp)
80102665:	e8 1c db ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
8010266a:	83 c4 04             	add    $0x4,%esp
8010266d:	ff 75 e4             	push   -0x1c(%ebp)
80102670:	e8 4c db ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
80102675:	89 1c 24             	mov    %ebx,(%esp)
80102678:	e8 44 db ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010267d:	83 c6 01             	add    $0x1,%esi
80102680:	83 c4 10             	add    $0x10,%esp
80102683:	39 77 48             	cmp    %esi,0x48(%edi)
80102686:	7f 97                	jg     8010261f <install_trans+0x20>
  }
}
80102688:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010268b:	5b                   	pop    %ebx
8010268c:	5e                   	pop    %esi
8010268d:	5f                   	pop    %edi
8010268e:	5d                   	pop    %ebp
8010268f:	c3                   	ret    
80102690:	c3                   	ret    

80102691 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102691:	55                   	push   %ebp
80102692:	89 e5                	mov    %esp,%ebp
80102694:	53                   	push   %ebx
80102695:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102698:	ff 35 d4 26 11 80    	push   0x801126d4
8010269e:	ff 35 e4 26 11 80    	push   0x801126e4
801026a4:	e8 01 da ff ff       	call   801000aa <bread>
801026a9:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026ab:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801026b1:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026b4:	83 c4 10             	add    $0x10,%esp
801026b7:	85 c9                	test   %ecx,%ecx
801026b9:	7e 17                	jle    801026d2 <write_head+0x41>
801026bb:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
801026c0:	8b 14 85 ec 26 11 80 	mov    -0x7feed914(,%eax,4),%edx
801026c7:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801026cb:	83 c0 01             	add    $0x1,%eax
801026ce:	39 c1                	cmp    %eax,%ecx
801026d0:	75 ee                	jne    801026c0 <write_head+0x2f>
  }
  bwrite(buf);
801026d2:	83 ec 0c             	sub    $0xc,%esp
801026d5:	53                   	push   %ebx
801026d6:	e8 ab da ff ff       	call   80100186 <bwrite>
  brelse(buf);
801026db:	89 1c 24             	mov    %ebx,(%esp)
801026de:	e8 de da ff ff       	call   801001c1 <brelse>
}
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026e9:	c9                   	leave  
801026ea:	c3                   	ret    

801026eb <initlog>:
{
801026eb:	55                   	push   %ebp
801026ec:	89 e5                	mov    %esp,%ebp
801026ee:	53                   	push   %ebx
801026ef:	83 ec 2c             	sub    $0x2c,%esp
801026f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801026f5:	68 40 7a 10 80       	push   $0x80107a40
801026fa:	68 a0 26 11 80       	push   $0x801126a0
801026ff:	e8 b4 14 00 00       	call   80103bb8 <initlock>
  readsb(dev, &sb);
80102704:	83 c4 08             	add    $0x8,%esp
80102707:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010270a:	50                   	push   %eax
8010270b:	53                   	push   %ebx
8010270c:	e8 8e eb ff ff       	call   8010129f <readsb>
  log.start = sb.logstart;
80102711:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102714:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102719:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010271c:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.dev = dev;
80102722:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  struct buf *buf = bread(log.dev, log.start);
80102728:	83 c4 08             	add    $0x8,%esp
8010272b:	50                   	push   %eax
8010272c:	53                   	push   %ebx
8010272d:	e8 78 d9 ff ff       	call   801000aa <bread>
  log.lh.n = lh->n;
80102732:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102735:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	85 db                	test   %ebx,%ebx
80102740:	7e 17                	jle    80102759 <initlog+0x6e>
80102742:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
80102747:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
8010274b:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102752:	83 c2 01             	add    $0x1,%edx
80102755:	39 d3                	cmp    %edx,%ebx
80102757:	75 ee                	jne    80102747 <initlog+0x5c>
  brelse(buf);
80102759:	83 ec 0c             	sub    $0xc,%esp
8010275c:	50                   	push   %eax
8010275d:	e8 5f da ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102762:	e8 98 fe ff ff       	call   801025ff <install_trans>
  log.lh.n = 0;
80102767:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010276e:	00 00 00 
  write_head(); // clear the log
80102771:	e8 1b ff ff ff       	call   80102691 <write_head>
}
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277c:	c9                   	leave  
8010277d:	c3                   	ret    

8010277e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
8010277e:	55                   	push   %ebp
8010277f:	89 e5                	mov    %esp,%ebp
80102781:	53                   	push   %ebx
80102782:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80102785:	68 a0 26 11 80       	push   $0x801126a0
8010278a:	e8 72 15 00 00       	call   80103d01 <acquire>
8010278f:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80102792:	bb a0 26 11 80       	mov    $0x801126a0,%ebx
80102797:	eb 15                	jmp    801027ae <begin_op+0x30>
      sleep(&log, &log.lock);
80102799:	83 ec 08             	sub    $0x8,%esp
8010279c:	68 a0 26 11 80       	push   $0x801126a0
801027a1:	68 a0 26 11 80       	push   $0x801126a0
801027a6:	e8 ae 0f 00 00       	call   80103759 <sleep>
801027ab:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027ae:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
801027b2:	75 e5                	jne    80102799 <begin_op+0x1b>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027b4:	8b 43 3c             	mov    0x3c(%ebx),%eax
801027b7:	83 c0 01             	add    $0x1,%eax
801027ba:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027bd:	8b 53 48             	mov    0x48(%ebx),%edx
801027c0:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801027c3:	83 fa 1e             	cmp    $0x1e,%edx
801027c6:	7e 17                	jle    801027df <begin_op+0x61>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801027c8:	83 ec 08             	sub    $0x8,%esp
801027cb:	68 a0 26 11 80       	push   $0x801126a0
801027d0:	68 a0 26 11 80       	push   $0x801126a0
801027d5:	e8 7f 0f 00 00       	call   80103759 <sleep>
801027da:	83 c4 10             	add    $0x10,%esp
801027dd:	eb cf                	jmp    801027ae <begin_op+0x30>
    } else {
      log.outstanding += 1;
801027df:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
801027e4:	83 ec 0c             	sub    $0xc,%esp
801027e7:	68 a0 26 11 80       	push   $0x801126a0
801027ec:	e8 77 15 00 00       	call   80103d68 <release>
      break;
    }
  }
}
801027f1:	83 c4 10             	add    $0x10,%esp
801027f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f7:	c9                   	leave  
801027f8:	c3                   	ret    

801027f9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801027f9:	55                   	push   %ebp
801027fa:	89 e5                	mov    %esp,%ebp
801027fc:	57                   	push   %edi
801027fd:	56                   	push   %esi
801027fe:	53                   	push   %ebx
801027ff:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102802:	68 a0 26 11 80       	push   $0x801126a0
80102807:	e8 f5 14 00 00       	call   80103d01 <acquire>
  log.outstanding -= 1;
8010280c:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102811:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102814:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
8010281a:	83 c4 10             	add    $0x10,%esp
8010281d:	83 3d e0 26 11 80 00 	cmpl   $0x0,0x801126e0
80102824:	75 60                	jne    80102886 <end_op+0x8d>
    panic("log.committing");
  if(log.outstanding == 0){
80102826:	85 db                	test   %ebx,%ebx
80102828:	75 69                	jne    80102893 <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
8010282a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102831:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 a0 26 11 80       	push   $0x801126a0
8010283c:	e8 27 15 00 00       	call   80103d68 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102841:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102844:	bf a0 26 11 80       	mov    $0x801126a0,%edi
  if (log.lh.n > 0) {
80102849:	83 3d e8 26 11 80 00 	cmpl   $0x0,0x801126e8
80102850:	7f 65                	jg     801028b7 <end_op+0xbe>
    acquire(&log.lock);
80102852:	83 ec 0c             	sub    $0xc,%esp
80102855:	68 a0 26 11 80       	push   $0x801126a0
8010285a:	e8 a2 14 00 00       	call   80103d01 <acquire>
    log.committing = 0;
8010285f:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102866:	00 00 00 
    wakeup(&log);
80102869:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102870:	e8 62 10 00 00       	call   801038d7 <wakeup>
    release(&log.lock);
80102875:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010287c:	e8 e7 14 00 00       	call   80103d68 <release>
80102881:	83 c4 10             	add    $0x10,%esp
}
80102884:	eb 29                	jmp    801028af <end_op+0xb6>
    panic("log.committing");
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	68 44 7a 10 80       	push   $0x80107a44
8010288e:	e8 ad da ff ff       	call   80100340 <panic>
    wakeup(&log);
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	68 a0 26 11 80       	push   $0x801126a0
8010289b:	e8 37 10 00 00       	call   801038d7 <wakeup>
  release(&log.lock);
801028a0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801028a7:	e8 bc 14 00 00       	call   80103d68 <release>
801028ac:	83 c4 10             	add    $0x10,%esp
}
801028af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028b2:	5b                   	pop    %ebx
801028b3:	5e                   	pop    %esi
801028b4:	5f                   	pop    %edi
801028b5:	5d                   	pop    %ebp
801028b6:	c3                   	ret    
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801028b7:	83 ec 08             	sub    $0x8,%esp
801028ba:	89 d8                	mov    %ebx,%eax
801028bc:	03 47 34             	add    0x34(%edi),%eax
801028bf:	83 c0 01             	add    $0x1,%eax
801028c2:	50                   	push   %eax
801028c3:	ff 77 44             	push   0x44(%edi)
801028c6:	e8 df d7 ff ff       	call   801000aa <bread>
801028cb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801028cd:	83 c4 08             	add    $0x8,%esp
801028d0:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
801028d7:	ff 77 44             	push   0x44(%edi)
801028da:	e8 cb d7 ff ff       	call   801000aa <bread>
    memmove(to->data, from->data, BSIZE);
801028df:	83 c4 0c             	add    $0xc,%esp
801028e2:	68 00 02 00 00       	push   $0x200
801028e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801028ea:	83 c0 5c             	add    $0x5c,%eax
801028ed:	50                   	push   %eax
801028ee:	8d 46 5c             	lea    0x5c(%esi),%eax
801028f1:	50                   	push   %eax
801028f2:	e8 3d 15 00 00       	call   80103e34 <memmove>
    bwrite(to);  // write the log
801028f7:	89 34 24             	mov    %esi,(%esp)
801028fa:	e8 87 d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
801028ff:	83 c4 04             	add    $0x4,%esp
80102902:	ff 75 e4             	push   -0x1c(%ebp)
80102905:	e8 b7 d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
8010290a:	89 34 24             	mov    %esi,(%esp)
8010290d:	e8 af d8 ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102912:	83 c3 01             	add    $0x1,%ebx
80102915:	83 c4 10             	add    $0x10,%esp
80102918:	3b 5f 48             	cmp    0x48(%edi),%ebx
8010291b:	7c 9a                	jl     801028b7 <end_op+0xbe>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010291d:	e8 6f fd ff ff       	call   80102691 <write_head>
    install_trans(); // Now install writes to home locations
80102922:	e8 d8 fc ff ff       	call   801025ff <install_trans>
    log.lh.n = 0;
80102927:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010292e:	00 00 00 
    write_head();    // Erase the transaction from the log
80102931:	e8 5b fd ff ff       	call   80102691 <write_head>
80102936:	e9 17 ff ff ff       	jmp    80102852 <end_op+0x59>

8010293b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010293b:	55                   	push   %ebp
8010293c:	89 e5                	mov    %esp,%ebp
8010293e:	53                   	push   %ebx
8010293f:	83 ec 04             	sub    $0x4,%esp
80102942:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102945:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
8010294b:	83 fa 1d             	cmp    $0x1d,%edx
8010294e:	7f 5c                	jg     801029ac <log_write+0x71>
80102950:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102955:	83 e8 01             	sub    $0x1,%eax
80102958:	39 c2                	cmp    %eax,%edx
8010295a:	7d 50                	jge    801029ac <log_write+0x71>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010295c:	83 3d dc 26 11 80 00 	cmpl   $0x0,0x801126dc
80102963:	7e 54                	jle    801029b9 <log_write+0x7e>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	68 a0 26 11 80       	push   $0x801126a0
8010296d:	e8 8f 13 00 00       	call   80103d01 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102972:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102978:	83 c4 10             	add    $0x10,%esp
8010297b:	85 d2                	test   %edx,%edx
8010297d:	7e 47                	jle    801029c6 <log_write+0x8b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010297f:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102982:	b8 00 00 00 00       	mov    $0x0,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102987:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010298e:	74 3b                	je     801029cb <log_write+0x90>
  for (i = 0; i < log.lh.n; i++) {
80102990:	83 c0 01             	add    $0x1,%eax
80102993:	39 d0                	cmp    %edx,%eax
80102995:	75 f0                	jne    80102987 <log_write+0x4c>
      break;
  }
  log.lh.block[i] = b->blockno;
80102997:	8b 43 08             	mov    0x8(%ebx),%eax
8010299a:	89 04 95 ec 26 11 80 	mov    %eax,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
801029a1:	83 c2 01             	add    $0x1,%edx
801029a4:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801029aa:	eb 2d                	jmp    801029d9 <log_write+0x9e>
    panic("too big a transaction");
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 53 7a 10 80       	push   $0x80107a53
801029b4:	e8 87 d9 ff ff       	call   80100340 <panic>
    panic("log_write outside of trans");
801029b9:	83 ec 0c             	sub    $0xc,%esp
801029bc:	68 69 7a 10 80       	push   $0x80107a69
801029c1:	e8 7a d9 ff ff       	call   80100340 <panic>
  for (i = 0; i < log.lh.n; i++) {
801029c6:	b8 00 00 00 00       	mov    $0x0,%eax
  log.lh.block[i] = b->blockno;
801029cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029ce:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
801029d5:	39 c2                	cmp    %eax,%edx
801029d7:	74 15                	je     801029ee <log_write+0xb3>
  b->flags |= B_DIRTY; // prevent eviction
801029d9:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801029dc:	83 ec 0c             	sub    $0xc,%esp
801029df:	68 a0 26 11 80       	push   $0x801126a0
801029e4:	e8 7f 13 00 00       	call   80103d68 <release>
}
801029e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ec:	c9                   	leave  
801029ed:	c3                   	ret    
801029ee:	89 c2                	mov    %eax,%edx
801029f0:	eb af                	jmp    801029a1 <log_write+0x66>

801029f2 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801029f2:	55                   	push   %ebp
801029f3:	89 e5                	mov    %esp,%ebp
801029f5:	53                   	push   %ebx
801029f6:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801029f9:	e8 97 08 00 00       	call   80103295 <cpuid>
801029fe:	89 c3                	mov    %eax,%ebx
80102a00:	e8 90 08 00 00       	call   80103295 <cpuid>
80102a05:	83 ec 04             	sub    $0x4,%esp
80102a08:	53                   	push   %ebx
80102a09:	50                   	push   %eax
80102a0a:	68 84 7a 10 80       	push   $0x80107a84
80102a0f:	e8 ed db ff ff       	call   80100601 <cprintf>
  idtinit();       // load idt register
80102a14:	e8 b2 24 00 00       	call   80104ecb <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a19:	e8 18 08 00 00       	call   80103236 <mycpu>
80102a1e:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a20:	b8 01 00 00 00       	mov    $0x1,%eax
80102a25:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a2c:	e8 fb 0a 00 00       	call   8010352c <scheduler>

80102a31 <mpenter>:
{
80102a31:	55                   	push   %ebp
80102a32:	89 e5                	mov    %esp,%ebp
80102a34:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a37:	e8 45 34 00 00       	call   80105e81 <switchkvm>
  seginit();
80102a3c:	e8 59 33 00 00       	call   80105d9a <seginit>
  lapicinit();
80102a41:	e8 c7 f8 ff ff       	call   8010230d <lapicinit>
  mpmain();
80102a46:	e8 a7 ff ff ff       	call   801029f2 <mpmain>

80102a4b <main>:
{
80102a4b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a4f:	83 e4 f0             	and    $0xfffffff0,%esp
80102a52:	ff 71 fc             	push   -0x4(%ecx)
80102a55:	55                   	push   %ebp
80102a56:	89 e5                	mov    %esp,%ebp
80102a58:	53                   	push   %ebx
80102a59:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a5a:	83 ec 08             	sub    $0x8,%esp
80102a5d:	68 00 00 40 80       	push   $0x80400000
80102a62:	68 60 79 11 80       	push   $0x80117960
80102a67:	e8 8c f6 ff ff       	call   801020f8 <kinit1>
  kvmalloc();      // kernel page table
80102a6c:	e8 8e 38 00 00       	call   801062ff <kvmalloc>
  mpinit();        // detect other processors
80102a71:	e8 5d 01 00 00       	call   80102bd3 <mpinit>
  lapicinit();     // interrupt controller
80102a76:	e8 92 f8 ff ff       	call   8010230d <lapicinit>
  seginit();       // segment descriptors
80102a7b:	e8 1a 33 00 00       	call   80105d9a <seginit>
  picinit();       // disable pic
80102a80:	e8 0b 03 00 00       	call   80102d90 <picinit>
  ioapicinit();    // another interrupt controller
80102a85:	e8 a0 f4 ff ff       	call   80101f2a <ioapicinit>
  consoleinit();   // console hardware
80102a8a:	e8 63 de ff ff       	call   801008f2 <consoleinit>
  uartinit();      // serial port
80102a8f:	e8 f2 26 00 00       	call   80105186 <uartinit>
  pinit();         // process table
80102a94:	e8 6f 07 00 00       	call   80103208 <pinit>
  tvinit();        // trap vectors
80102a99:	e8 a2 23 00 00       	call   80104e40 <tvinit>
  binit();         // buffer cache
80102a9e:	e8 91 d5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102aa3:	e8 d3 e1 ff ff       	call   80100c7b <fileinit>
  ideinit();       // disk 
80102aa8:	e8 83 f2 ff ff       	call   80101d30 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102aad:	83 c4 0c             	add    $0xc,%esp
80102ab0:	68 8a 00 00 00       	push   $0x8a
80102ab5:	68 8c b4 10 80       	push   $0x8010b48c
80102aba:	68 00 70 00 80       	push   $0x80007000
80102abf:	e8 70 13 00 00       	call   80103e34 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ac4:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80102acb:	00 00 00 
80102ace:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102ad3:	83 c4 10             	add    $0x10,%esp
80102ad6:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80102adb:	76 6c                	jbe    80102b49 <main+0xfe>
80102add:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80102ae2:	eb 19                	jmp    80102afd <main+0xb2>
80102ae4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102aea:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80102af1:	00 00 00 
80102af4:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102af9:	39 c3                	cmp    %eax,%ebx
80102afb:	73 4c                	jae    80102b49 <main+0xfe>
    if(c == mycpu())  // We've started already.
80102afd:	e8 34 07 00 00       	call   80103236 <mycpu>
80102b02:	39 c3                	cmp    %eax,%ebx
80102b04:	74 de                	je     80102ae4 <main+0x99>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102b06:	e8 3f f6 ff ff       	call   8010214a <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102b0b:	05 00 10 00 00       	add    $0x1000,%eax
80102b10:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102b15:	c7 05 f8 6f 00 80 31 	movl   $0x80102a31,0x80006ff8
80102b1c:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102b1f:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102b26:	a0 10 00 

    lapicstartap(c->apicid, V2P(code));
80102b29:	83 ec 08             	sub    $0x8,%esp
80102b2c:	68 00 70 00 00       	push   $0x7000
80102b31:	0f b6 03             	movzbl (%ebx),%eax
80102b34:	50                   	push   %eax
80102b35:	e8 18 f9 ff ff       	call   80102452 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102b3a:	83 c4 10             	add    $0x10,%esp
80102b3d:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b43:	85 c0                	test   %eax,%eax
80102b45:	74 f6                	je     80102b3d <main+0xf2>
80102b47:	eb 9b                	jmp    80102ae4 <main+0x99>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b49:	83 ec 08             	sub    $0x8,%esp
80102b4c:	68 00 00 00 8e       	push   $0x8e000000
80102b51:	68 00 00 40 80       	push   $0x80400000
80102b56:	e8 cf f5 ff ff       	call   8010212a <kinit2>
  slabinit();
80102b5b:	e8 13 3d 00 00       	call   80106873 <slabinit>
  userinit();      // first user process
80102b60:	e8 6e 07 00 00       	call   801032d3 <userinit>
  mpmain();        // finish this processor's setup
80102b65:	e8 88 fe ff ff       	call   801029f2 <mpmain>

80102b6a <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b6a:	55                   	push   %ebp
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	57                   	push   %edi
80102b6e:	56                   	push   %esi
80102b6f:	53                   	push   %ebx
80102b70:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b73:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102b79:	8d 3c 16             	lea    (%esi,%edx,1),%edi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b7c:	39 fe                	cmp    %edi,%esi
80102b7e:	73 4c                	jae    80102bcc <mpsearch1+0x62>
80102b80:	8d 98 10 00 00 80    	lea    -0x7ffffff0(%eax),%ebx
80102b86:	eb 0e                	jmp    80102b96 <mpsearch1+0x2c>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b88:	84 c0                	test   %al,%al
80102b8a:	74 36                	je     80102bc2 <mpsearch1+0x58>
  for(p = addr; p < e; p += sizeof(struct mp))
80102b8c:	83 c6 10             	add    $0x10,%esi
80102b8f:	83 c3 10             	add    $0x10,%ebx
80102b92:	39 f7                	cmp    %esi,%edi
80102b94:	76 27                	jbe    80102bbd <mpsearch1+0x53>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b96:	83 ec 04             	sub    $0x4,%esp
80102b99:	6a 04                	push   $0x4
80102b9b:	68 98 7a 10 80       	push   $0x80107a98
80102ba0:	56                   	push   %esi
80102ba1:	e8 4c 12 00 00       	call   80103df2 <memcmp>
80102ba6:	83 c4 10             	add    $0x10,%esp
80102ba9:	85 c0                	test   %eax,%eax
80102bab:	75 df                	jne    80102b8c <mpsearch1+0x22>
80102bad:	89 f2                	mov    %esi,%edx
    sum += addr[i];
80102baf:	0f b6 0a             	movzbl (%edx),%ecx
80102bb2:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102bb4:	83 c2 01             	add    $0x1,%edx
80102bb7:	39 da                	cmp    %ebx,%edx
80102bb9:	75 f4                	jne    80102baf <mpsearch1+0x45>
80102bbb:	eb cb                	jmp    80102b88 <mpsearch1+0x1e>
      return (struct mp*)p;
  return 0;
80102bbd:	be 00 00 00 00       	mov    $0x0,%esi
}
80102bc2:	89 f0                	mov    %esi,%eax
80102bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc7:	5b                   	pop    %ebx
80102bc8:	5e                   	pop    %esi
80102bc9:	5f                   	pop    %edi
80102bca:	5d                   	pop    %ebp
80102bcb:	c3                   	ret    
  return 0;
80102bcc:	be 00 00 00 00       	mov    $0x0,%esi
80102bd1:	eb ef                	jmp    80102bc2 <mpsearch1+0x58>

80102bd3 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102bd3:	55                   	push   %ebp
80102bd4:	89 e5                	mov    %esp,%ebp
80102bd6:	57                   	push   %edi
80102bd7:	56                   	push   %esi
80102bd8:	53                   	push   %ebx
80102bd9:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102bdc:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102be3:	c1 e0 08             	shl    $0x8,%eax
80102be6:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102bed:	09 d0                	or     %edx,%eax
80102bef:	c1 e0 04             	shl    $0x4,%eax
80102bf2:	0f 84 c5 00 00 00    	je     80102cbd <mpinit+0xea>
    if((mp = mpsearch1(p, 1024)))
80102bf8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bfd:	e8 68 ff ff ff       	call   80102b6a <mpsearch1>
80102c02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c05:	85 c0                	test   %eax,%eax
80102c07:	75 1a                	jne    80102c23 <mpinit+0x50>
  return mpsearch1(0xF0000, 0x10000);
80102c09:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c0e:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c13:	e8 52 ff ff ff       	call   80102b6a <mpsearch1>
80102c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c1b:	85 c0                	test   %eax,%eax
80102c1d:	0f 84 60 01 00 00    	je     80102d83 <mpinit+0x1b0>
80102c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c26:	8b 70 04             	mov    0x4(%eax),%esi
80102c29:	85 f6                	test   %esi,%esi
80102c2b:	0f 84 52 01 00 00    	je     80102d83 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80102c37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102c3a:	83 ec 04             	sub    $0x4,%esp
80102c3d:	6a 04                	push   $0x4
80102c3f:	68 9d 7a 10 80       	push   $0x80107a9d
80102c44:	50                   	push   %eax
80102c45:	e8 a8 11 00 00       	call   80103df2 <memcmp>
80102c4a:	89 c3                	mov    %eax,%ebx
80102c4c:	83 c4 10             	add    $0x10,%esp
80102c4f:	85 c0                	test   %eax,%eax
80102c51:	0f 85 2c 01 00 00    	jne    80102d83 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80102c57:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102c5e:	3c 01                	cmp    $0x1,%al
80102c60:	74 08                	je     80102c6a <mpinit+0x97>
80102c62:	3c 04                	cmp    $0x4,%al
80102c64:	0f 85 19 01 00 00    	jne    80102d83 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80102c6a:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102c71:	66 85 d2             	test   %dx,%dx
80102c74:	74 22                	je     80102c98 <mpinit+0xc5>
80102c76:	89 f0                	mov    %esi,%eax
80102c78:	0f b7 d2             	movzwl %dx,%edx
80102c7b:	8d 3c 32             	lea    (%edx,%esi,1),%edi
  sum = 0;
80102c7e:	89 da                	mov    %ebx,%edx
    sum += addr[i];
80102c80:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80102c87:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102c89:	83 c0 01             	add    $0x1,%eax
80102c8c:	39 f8                	cmp    %edi,%eax
80102c8e:	75 f0                	jne    80102c80 <mpinit+0xad>
  if(sum((uchar*)conf, conf->length) != 0)
80102c90:	84 d2                	test   %dl,%dl
80102c92:	0f 85 eb 00 00 00    	jne    80102d83 <mpinit+0x1b0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c98:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80102c9e:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ca3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80102ca9:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102cb0:	03 55 e4             	add    -0x1c(%ebp),%edx
  ismp = 1;
80102cb3:	be 01 00 00 00       	mov    $0x1,%esi
80102cb8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cbb:	eb 40                	jmp    80102cfd <mpinit+0x12a>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cbd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102cc4:	c1 e0 08             	shl    $0x8,%eax
80102cc7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cce:	09 d0                	or     %edx,%eax
80102cd0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cd3:	2d 00 04 00 00       	sub    $0x400,%eax
80102cd8:	ba 00 04 00 00       	mov    $0x400,%edx
80102cdd:	e8 88 fe ff ff       	call   80102b6a <mpsearch1>
80102ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ce5:	85 c0                	test   %eax,%eax
80102ce7:	0f 85 36 ff ff ff    	jne    80102c23 <mpinit+0x50>
80102ced:	e9 17 ff ff ff       	jmp    80102c09 <mpinit+0x36>
    switch(*p){
80102cf2:	83 e9 03             	sub    $0x3,%ecx
80102cf5:	80 f9 01             	cmp    $0x1,%cl
80102cf8:	76 15                	jbe    80102d0f <mpinit+0x13c>
80102cfa:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cfd:	39 d0                	cmp    %edx,%eax
80102cff:	73 4b                	jae    80102d4c <mpinit+0x179>
    switch(*p){
80102d01:	0f b6 08             	movzbl (%eax),%ecx
80102d04:	80 f9 02             	cmp    $0x2,%cl
80102d07:	74 34                	je     80102d3d <mpinit+0x16a>
80102d09:	77 e7                	ja     80102cf2 <mpinit+0x11f>
80102d0b:	84 c9                	test   %cl,%cl
80102d0d:	74 05                	je     80102d14 <mpinit+0x141>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d0f:	83 c0 08             	add    $0x8,%eax
      continue;
80102d12:	eb e9                	jmp    80102cfd <mpinit+0x12a>
      if(ncpu < NCPU) {
80102d14:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80102d1a:	83 f9 07             	cmp    $0x7,%ecx
80102d1d:	7f 19                	jg     80102d38 <mpinit+0x165>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d1f:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80102d25:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80102d29:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
80102d2f:	83 c1 01             	add    $0x1,%ecx
80102d32:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
      p += sizeof(struct mpproc);
80102d38:	83 c0 14             	add    $0x14,%eax
      continue;
80102d3b:	eb c0                	jmp    80102cfd <mpinit+0x12a>
      ioapicid = ioapic->apicno;
80102d3d:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80102d41:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      p += sizeof(struct mpioapic);
80102d47:	83 c0 08             	add    $0x8,%eax
      continue;
80102d4a:	eb b1                	jmp    80102cfd <mpinit+0x12a>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d4c:	85 f6                	test   %esi,%esi
80102d4e:	74 26                	je     80102d76 <mpinit+0x1a3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d53:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d57:	74 15                	je     80102d6e <mpinit+0x19b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d59:	b8 70 00 00 00       	mov    $0x70,%eax
80102d5e:	ba 22 00 00 00       	mov    $0x22,%edx
80102d63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d64:	ba 23 00 00 00       	mov    $0x23,%edx
80102d69:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d6a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6d:	ee                   	out    %al,(%dx)
  }
}
80102d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d71:	5b                   	pop    %ebx
80102d72:	5e                   	pop    %esi
80102d73:	5f                   	pop    %edi
80102d74:	5d                   	pop    %ebp
80102d75:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	68 bc 7a 10 80       	push   $0x80107abc
80102d7e:	e8 bd d5 ff ff       	call   80100340 <panic>
    panic("Expect to run on an SMP");
80102d83:	83 ec 0c             	sub    $0xc,%esp
80102d86:	68 a2 7a 10 80       	push   $0x80107aa2
80102d8b:	e8 b0 d5 ff ff       	call   80100340 <panic>

80102d90 <picinit>:
80102d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d95:	ba 21 00 00 00       	mov    $0x21,%edx
80102d9a:	ee                   	out    %al,(%dx)
80102d9b:	ba a1 00 00 00       	mov    $0xa1,%edx
80102da0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102da1:	c3                   	ret    

80102da2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102da2:	55                   	push   %ebp
80102da3:	89 e5                	mov    %esp,%ebp
80102da5:	57                   	push   %edi
80102da6:	56                   	push   %esi
80102da7:	53                   	push   %ebx
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dae:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102db1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102db7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102dbd:	e8 d3 de ff ff       	call   80100c95 <filealloc>
80102dc2:	89 03                	mov    %eax,(%ebx)
80102dc4:	85 c0                	test   %eax,%eax
80102dc6:	0f 84 a6 00 00 00    	je     80102e72 <pipealloc+0xd0>
80102dcc:	e8 c4 de ff ff       	call   80100c95 <filealloc>
80102dd1:	89 06                	mov    %eax,(%esi)
80102dd3:	85 c0                	test   %eax,%eax
80102dd5:	0f 84 85 00 00 00    	je     80102e60 <pipealloc+0xbe>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102ddb:	e8 6a f3 ff ff       	call   8010214a <kalloc>
80102de0:	89 c7                	mov    %eax,%edi
80102de2:	85 c0                	test   %eax,%eax
80102de4:	74 72                	je     80102e58 <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102de6:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102ded:	00 00 00 
  p->writeopen = 1;
80102df0:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102df7:	00 00 00 
  p->nwrite = 0;
80102dfa:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e01:	00 00 00 
  p->nread = 0;
80102e04:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e0b:	00 00 00 
  initlock(&p->lock, "pipe");
80102e0e:	83 ec 08             	sub    $0x8,%esp
80102e11:	68 db 7a 10 80       	push   $0x80107adb
80102e16:	50                   	push   %eax
80102e17:	e8 9c 0d 00 00       	call   80103bb8 <initlock>
  (*f0)->type = FD_PIPE;
80102e1c:	8b 03                	mov    (%ebx),%eax
80102e1e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e24:	8b 03                	mov    (%ebx),%eax
80102e26:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e2a:	8b 03                	mov    (%ebx),%eax
80102e2c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e30:	8b 03                	mov    (%ebx),%eax
80102e32:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e35:	8b 06                	mov    (%esi),%eax
80102e37:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e3d:	8b 06                	mov    (%esi),%eax
80102e3f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e43:	8b 06                	mov    (%esi),%eax
80102e45:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e49:	8b 06                	mov    (%esi),%eax
80102e4b:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e4e:	83 c4 10             	add    $0x10,%esp
80102e51:	b8 00 00 00 00       	mov    $0x0,%eax
80102e56:	eb 36                	jmp    80102e8e <pipealloc+0xec>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e58:	8b 03                	mov    (%ebx),%eax
80102e5a:	85 c0                	test   %eax,%eax
80102e5c:	75 08                	jne    80102e66 <pipealloc+0xc4>
80102e5e:	eb 12                	jmp    80102e72 <pipealloc+0xd0>
80102e60:	8b 03                	mov    (%ebx),%eax
80102e62:	85 c0                	test   %eax,%eax
80102e64:	74 30                	je     80102e96 <pipealloc+0xf4>
    fileclose(*f0);
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	50                   	push   %eax
80102e6a:	e8 ca de ff ff       	call   80100d39 <fileclose>
80102e6f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e72:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102e79:	85 d2                	test   %edx,%edx
80102e7b:	74 11                	je     80102e8e <pipealloc+0xec>
    fileclose(*f1);
80102e7d:	83 ec 0c             	sub    $0xc,%esp
80102e80:	52                   	push   %edx
80102e81:	e8 b3 de ff ff       	call   80100d39 <fileclose>
80102e86:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e91:	5b                   	pop    %ebx
80102e92:	5e                   	pop    %esi
80102e93:	5f                   	pop    %edi
80102e94:	5d                   	pop    %ebp
80102e95:	c3                   	ret    
  return -1;
80102e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e9b:	eb f1                	jmp    80102e8e <pipealloc+0xec>

80102e9d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e9d:	55                   	push   %ebp
80102e9e:	89 e5                	mov    %esp,%ebp
80102ea0:	53                   	push   %ebx
80102ea1:	83 ec 10             	sub    $0x10,%esp
80102ea4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ea7:	53                   	push   %ebx
80102ea8:	e8 54 0e 00 00       	call   80103d01 <acquire>
  if(writable){
80102ead:	83 c4 10             	add    $0x10,%esp
80102eb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102eb4:	74 3f                	je     80102ef5 <pipeclose+0x58>
    p->writeopen = 0;
80102eb6:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102ebd:	00 00 00 
    wakeup(&p->nread);
80102ec0:	83 ec 0c             	sub    $0xc,%esp
80102ec3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ec9:	50                   	push   %eax
80102eca:	e8 08 0a 00 00       	call   801038d7 <wakeup>
80102ecf:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102ed2:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ed9:	75 09                	jne    80102ee4 <pipeclose+0x47>
80102edb:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102ee2:	74 2f                	je     80102f13 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102ee4:	83 ec 0c             	sub    $0xc,%esp
80102ee7:	53                   	push   %ebx
80102ee8:	e8 7b 0e 00 00       	call   80103d68 <release>
80102eed:	83 c4 10             	add    $0x10,%esp
}
80102ef0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ef3:	c9                   	leave  
80102ef4:	c3                   	ret    
    p->readopen = 0;
80102ef5:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102efc:	00 00 00 
    wakeup(&p->nwrite);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f08:	50                   	push   %eax
80102f09:	e8 c9 09 00 00       	call   801038d7 <wakeup>
80102f0e:	83 c4 10             	add    $0x10,%esp
80102f11:	eb bf                	jmp    80102ed2 <pipeclose+0x35>
    release(&p->lock);
80102f13:	83 ec 0c             	sub    $0xc,%esp
80102f16:	53                   	push   %ebx
80102f17:	e8 4c 0e 00 00       	call   80103d68 <release>
    kfree((char*)p);
80102f1c:	89 1c 24             	mov    %ebx,(%esp)
80102f1f:	e8 d8 f0 ff ff       	call   80101ffc <kfree>
80102f24:	83 c4 10             	add    $0x10,%esp
80102f27:	eb c7                	jmp    80102ef0 <pipeclose+0x53>

80102f29 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f29:	55                   	push   %ebp
80102f2a:	89 e5                	mov    %esp,%ebp
80102f2c:	57                   	push   %edi
80102f2d:	56                   	push   %esi
80102f2e:	53                   	push   %ebx
80102f2f:	83 ec 28             	sub    $0x28,%esp
80102f32:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f35:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102f38:	53                   	push   %ebx
80102f39:	e8 c3 0d 00 00       	call   80103d01 <acquire>
  for(i = 0; i < n; i++){
80102f3e:	83 c4 10             	add    $0x10,%esp
80102f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102f45:	0f 8e 8d 00 00 00    	jle    80102fd8 <pipewrite+0xaf>
80102f4b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80102f4e:	03 75 10             	add    0x10(%ebp),%esi
80102f51:	89 75 e0             	mov    %esi,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f54:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f5a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f60:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f66:	05 00 02 00 00       	add    $0x200,%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f6b:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	75 3f                	jne    80102fb4 <pipewrite+0x8b>
      if(p->readopen == 0 || myproc()->killed){
80102f75:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f7c:	74 79                	je     80102ff7 <pipewrite+0xce>
80102f7e:	e8 2d 03 00 00       	call   801032b0 <myproc>
80102f83:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f87:	75 6e                	jne    80102ff7 <pipewrite+0xce>
      wakeup(&p->nread);
80102f89:	83 ec 0c             	sub    $0xc,%esp
80102f8c:	57                   	push   %edi
80102f8d:	e8 45 09 00 00       	call   801038d7 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f92:	83 c4 08             	add    $0x8,%esp
80102f95:	53                   	push   %ebx
80102f96:	56                   	push   %esi
80102f97:	e8 bd 07 00 00       	call   80103759 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f9c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fa2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fa8:	05 00 02 00 00       	add    $0x200,%eax
80102fad:	83 c4 10             	add    $0x10,%esp
80102fb0:	39 c2                	cmp    %eax,%edx
80102fb2:	74 c1                	je     80102f75 <pipewrite+0x4c>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102fb4:	8d 42 01             	lea    0x1(%edx),%eax
80102fb7:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102fbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102fc0:	0f b6 01             	movzbl (%ecx),%eax
80102fc3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102fc9:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102fcd:	83 c1 01             	add    $0x1,%ecx
80102fd0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102fd3:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80102fd6:	75 82                	jne    80102f5a <pipewrite+0x31>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fe1:	50                   	push   %eax
80102fe2:	e8 f0 08 00 00       	call   801038d7 <wakeup>
  release(&p->lock);
80102fe7:	89 1c 24             	mov    %ebx,(%esp)
80102fea:	e8 79 0d 00 00       	call   80103d68 <release>
  return n;
80102fef:	83 c4 10             	add    $0x10,%esp
80102ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80102ff5:	eb 11                	jmp    80103008 <pipewrite+0xdf>
        release(&p->lock);
80102ff7:	83 ec 0c             	sub    $0xc,%esp
80102ffa:	53                   	push   %ebx
80102ffb:	e8 68 0d 00 00       	call   80103d68 <release>
        return -1;
80103000:	83 c4 10             	add    $0x10,%esp
80103003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103008:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010300b:	5b                   	pop    %ebx
8010300c:	5e                   	pop    %esi
8010300d:	5f                   	pop    %edi
8010300e:	5d                   	pop    %ebp
8010300f:	c3                   	ret    

80103010 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 18             	sub    $0x18,%esp
80103019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010301c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010301f:	53                   	push   %ebx
80103020:	e8 dc 0c 00 00       	call   80103d01 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103025:	83 c4 10             	add    $0x10,%esp
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103028:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010302e:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103034:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
8010303a:	75 2f                	jne    8010306b <piperead+0x5b>
8010303c:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80103043:	74 26                	je     8010306b <piperead+0x5b>
    if(myproc()->killed){
80103045:	e8 66 02 00 00       	call   801032b0 <myproc>
8010304a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010304e:	75 79                	jne    801030c9 <piperead+0xb9>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103050:	83 ec 08             	sub    $0x8,%esp
80103053:	53                   	push   %ebx
80103054:	56                   	push   %esi
80103055:	e8 ff 06 00 00       	call   80103759 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010305a:	83 c4 10             	add    $0x10,%esp
8010305d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103063:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103069:	74 d1                	je     8010303c <piperead+0x2c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010306b:	be 00 00 00 00       	mov    $0x0,%esi
80103070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103074:	7e 2f                	jle    801030a5 <piperead+0x95>
    if(p->nread == p->nwrite)
80103076:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010307c:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103082:	74 21                	je     801030a5 <piperead+0x95>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103084:	8d 50 01             	lea    0x1(%eax),%edx
80103087:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
8010308d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103092:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103097:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010309a:	83 c6 01             	add    $0x1,%esi
8010309d:	39 75 10             	cmp    %esi,0x10(%ebp)
801030a0:	75 d4                	jne    80103076 <piperead+0x66>
801030a2:	8b 75 10             	mov    0x10(%ebp),%esi
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030a5:	83 ec 0c             	sub    $0xc,%esp
801030a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801030ae:	50                   	push   %eax
801030af:	e8 23 08 00 00       	call   801038d7 <wakeup>
  release(&p->lock);
801030b4:	89 1c 24             	mov    %ebx,(%esp)
801030b7:	e8 ac 0c 00 00       	call   80103d68 <release>
  return i;
801030bc:	83 c4 10             	add    $0x10,%esp
}
801030bf:	89 f0                	mov    %esi,%eax
801030c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030c4:	5b                   	pop    %ebx
801030c5:	5e                   	pop    %esi
801030c6:	5f                   	pop    %edi
801030c7:	5d                   	pop    %ebp
801030c8:	c3                   	ret    
      release(&p->lock);
801030c9:	83 ec 0c             	sub    $0xc,%esp
801030cc:	53                   	push   %ebx
801030cd:	e8 96 0c 00 00       	call   80103d68 <release>
      return -1;
801030d2:	83 c4 10             	add    $0x10,%esp
801030d5:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030da:	eb e3                	jmp    801030bf <piperead+0xaf>

801030dc <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030dc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801030e1:	eb 0e                	jmp    801030f1 <wakeup1+0x15>
801030e3:	81 c2 84 00 00 00    	add    $0x84,%edx
801030e9:	81 fa 94 35 11 80    	cmp    $0x80113594,%edx
801030ef:	74 14                	je     80103105 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
801030f1:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801030f5:	75 ec                	jne    801030e3 <wakeup1+0x7>
801030f7:	39 42 20             	cmp    %eax,0x20(%edx)
801030fa:	75 e7                	jne    801030e3 <wakeup1+0x7>
      p->state = RUNNABLE;
801030fc:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103103:	eb de                	jmp    801030e3 <wakeup1+0x7>
}
80103105:	c3                   	ret    

80103106 <allocproc>:
{
80103106:	55                   	push   %ebp
80103107:	89 e5                	mov    %esp,%ebp
80103109:	53                   	push   %ebx
8010310a:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010310d:	68 20 2d 11 80       	push   $0x80112d20
80103112:	e8 ea 0b 00 00       	call   80103d01 <acquire>
80103117:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010311a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    if(p->state == UNUSED)
8010311f:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103123:	74 2a                	je     8010314f <allocproc+0x49>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103125:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010312b:	81 fb 94 35 11 80    	cmp    $0x80113594,%ebx
80103131:	75 ec                	jne    8010311f <allocproc+0x19>
  release(&ptable.lock);
80103133:	83 ec 0c             	sub    $0xc,%esp
80103136:	68 20 2d 11 80       	push   $0x80112d20
8010313b:	e8 28 0c 00 00       	call   80103d68 <release>
  return 0;
80103140:	83 c4 10             	add    $0x10,%esp
80103143:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80103148:	89 d8                	mov    %ebx,%eax
8010314a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010314d:	c9                   	leave  
8010314e:	c3                   	ret    
  p->state = EMBRYO;
8010314f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103156:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010315b:	8d 50 01             	lea    0x1(%eax),%edx
8010315e:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103164:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103167:	83 ec 0c             	sub    $0xc,%esp
8010316a:	68 20 2d 11 80       	push   $0x80112d20
8010316f:	e8 f4 0b 00 00       	call   80103d68 <release>
  if((p->kstack = kalloc()) == 0){
80103174:	e8 d1 ef ff ff       	call   8010214a <kalloc>
80103179:	89 43 08             	mov    %eax,0x8(%ebx)
8010317c:	83 c4 10             	add    $0x10,%esp
8010317f:	85 c0                	test   %eax,%eax
80103181:	74 37                	je     801031ba <allocproc+0xb4>
  sp -= sizeof *p->tf;
80103183:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103189:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010318c:	c7 80 b0 0f 00 00 35 	movl   $0x80104e35,0xfb0(%eax)
80103193:	4e 10 80 
  sp -= sizeof *p->context;
80103196:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010319b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010319e:	83 ec 04             	sub    $0x4,%esp
801031a1:	6a 14                	push   $0x14
801031a3:	6a 00                	push   $0x0
801031a5:	50                   	push   %eax
801031a6:	e8 04 0c 00 00       	call   80103daf <memset>
  p->context->eip = (uint)forkret;
801031ab:	8b 43 1c             	mov    0x1c(%ebx),%eax
801031ae:	c7 40 10 c5 31 10 80 	movl   $0x801031c5,0x10(%eax)
  return p;
801031b5:	83 c4 10             	add    $0x10,%esp
801031b8:	eb 8e                	jmp    80103148 <allocproc+0x42>
    p->state = UNUSED;
801031ba:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801031c1:	89 c3                	mov    %eax,%ebx
801031c3:	eb 83                	jmp    80103148 <allocproc+0x42>

801031c5 <forkret>:
{
801031c5:	55                   	push   %ebp
801031c6:	89 e5                	mov    %esp,%ebp
801031c8:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801031cb:	68 20 2d 11 80       	push   $0x80112d20
801031d0:	e8 93 0b 00 00       	call   80103d68 <release>
  if (first) {
801031d5:	83 c4 10             	add    $0x10,%esp
801031d8:	83 3d 00 b0 10 80 00 	cmpl   $0x0,0x8010b000
801031df:	75 02                	jne    801031e3 <forkret+0x1e>
}
801031e1:	c9                   	leave  
801031e2:	c3                   	ret    
    first = 0;
801031e3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801031ea:	00 00 00 
    iinit(ROOTDEV);
801031ed:	83 ec 0c             	sub    $0xc,%esp
801031f0:	6a 01                	push   $0x1
801031f2:	e8 dc e0 ff ff       	call   801012d3 <iinit>
    initlog(ROOTDEV);
801031f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031fe:	e8 e8 f4 ff ff       	call   801026eb <initlog>
80103203:	83 c4 10             	add    $0x10,%esp
}
80103206:	eb d9                	jmp    801031e1 <forkret+0x1c>

80103208 <pinit>:
{
80103208:	55                   	push   %ebp
80103209:	89 e5                	mov    %esp,%ebp
8010320b:	83 ec 0c             	sub    $0xc,%esp
  memset(ptable.proc, 0, sizeof *ptable.proc);
8010320e:	68 84 00 00 00       	push   $0x84
80103213:	6a 00                	push   $0x0
80103215:	68 54 2d 11 80       	push   $0x80112d54
8010321a:	e8 90 0b 00 00       	call   80103daf <memset>
  initlock(&ptable.lock, "ptable");
8010321f:	83 c4 08             	add    $0x8,%esp
80103222:	68 e0 7a 10 80       	push   $0x80107ae0
80103227:	68 20 2d 11 80       	push   $0x80112d20
8010322c:	e8 87 09 00 00       	call   80103bb8 <initlock>
}
80103231:	83 c4 10             	add    $0x10,%esp
80103234:	c9                   	leave  
80103235:	c3                   	ret    

80103236 <mycpu>:
{
80103236:	55                   	push   %ebp
80103237:	89 e5                	mov    %esp,%ebp
80103239:	56                   	push   %esi
8010323a:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010323b:	9c                   	pushf  
8010323c:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010323d:	f6 c4 02             	test   $0x2,%ah
80103240:	75 39                	jne    8010327b <mycpu+0x45>
  apicid = lapicid();
80103242:	e8 d3 f1 ff ff       	call   8010241a <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103247:	8b 35 84 27 11 80    	mov    0x80112784,%esi
8010324d:	85 f6                	test   %esi,%esi
8010324f:	7e 1d                	jle    8010326e <mycpu+0x38>
80103251:	ba 00 00 00 00       	mov    $0x0,%edx
    if (cpus[i].apicid == apicid)
80103256:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010325c:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103263:	39 c3                	cmp    %eax,%ebx
80103265:	74 21                	je     80103288 <mycpu+0x52>
  for (i = 0; i < ncpu; ++i) {
80103267:	83 c2 01             	add    $0x1,%edx
8010326a:	39 f2                	cmp    %esi,%edx
8010326c:	75 e8                	jne    80103256 <mycpu+0x20>
  panic("unknown apicid\n");
8010326e:	83 ec 0c             	sub    $0xc,%esp
80103271:	68 e7 7a 10 80       	push   $0x80107ae7
80103276:	e8 c5 d0 ff ff       	call   80100340 <panic>
    panic("mycpu called with interrupts enabled\n");
8010327b:	83 ec 0c             	sub    $0xc,%esp
8010327e:	68 dc 7b 10 80       	push   $0x80107bdc
80103283:	e8 b8 d0 ff ff       	call   80100340 <panic>
      return &cpus[i];
80103288:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
8010328e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103291:	5b                   	pop    %ebx
80103292:	5e                   	pop    %esi
80103293:	5d                   	pop    %ebp
80103294:	c3                   	ret    

80103295 <cpuid>:
cpuid() {
80103295:	55                   	push   %ebp
80103296:	89 e5                	mov    %esp,%ebp
80103298:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010329b:	e8 96 ff ff ff       	call   80103236 <mycpu>
801032a0:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801032a5:	c1 f8 04             	sar    $0x4,%eax
801032a8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801032ae:	c9                   	leave  
801032af:	c3                   	ret    

801032b0 <myproc>:
myproc(void) {
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	53                   	push   %ebx
801032b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801032b7:	e8 75 09 00 00       	call   80103c31 <pushcli>
  c = mycpu();
801032bc:	e8 75 ff ff ff       	call   80103236 <mycpu>
  p = c->proc;
801032c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032c7:	e8 a1 09 00 00       	call   80103c6d <popcli>
}
801032cc:	89 d8                	mov    %ebx,%eax
801032ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032d1:	c9                   	leave  
801032d2:	c3                   	ret    

801032d3 <userinit>:
{
801032d3:	55                   	push   %ebp
801032d4:	89 e5                	mov    %esp,%ebp
801032d6:	53                   	push   %ebx
801032d7:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032da:	e8 27 fe ff ff       	call   80103106 <allocproc>
801032df:	89 c3                	mov    %eax,%ebx
  initproc = p;
801032e1:	a3 94 35 11 80       	mov    %eax,0x80113594
  if((p->pgdir = setupkvm()) == 0)
801032e6:	e8 a6 2f 00 00       	call   80106291 <setupkvm>
801032eb:	89 43 04             	mov    %eax,0x4(%ebx)
801032ee:	85 c0                	test   %eax,%eax
801032f0:	0f 84 b7 00 00 00    	je     801033ad <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801032f6:	83 ec 04             	sub    $0x4,%esp
801032f9:	68 2c 00 00 00       	push   $0x2c
801032fe:	68 60 b4 10 80       	push   $0x8010b460
80103303:	50                   	push   %eax
80103304:	e8 84 2c 00 00       	call   80105f8d <inituvm>
  p->sz = PGSIZE;
80103309:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010330f:	83 c4 0c             	add    $0xc,%esp
80103312:	6a 4c                	push   $0x4c
80103314:	6a 00                	push   $0x0
80103316:	ff 73 18             	push   0x18(%ebx)
80103319:	e8 91 0a 00 00       	call   80103daf <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010331e:	8b 43 18             	mov    0x18(%ebx),%eax
80103321:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103327:	8b 43 18             	mov    0x18(%ebx),%eax
8010332a:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103330:	8b 43 18             	mov    0x18(%ebx),%eax
80103333:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103337:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010333b:	8b 43 18             	mov    0x18(%ebx),%eax
8010333e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103342:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103346:	8b 43 18             	mov    0x18(%ebx),%eax
80103349:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103350:	8b 43 18             	mov    0x18(%ebx),%eax
80103353:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010335a:	8b 43 18             	mov    0x18(%ebx),%eax
8010335d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103364:	83 c4 0c             	add    $0xc,%esp
80103367:	6a 10                	push   $0x10
80103369:	68 10 7b 10 80       	push   $0x80107b10
8010336e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103371:	50                   	push   %eax
80103372:	e8 b8 0b 00 00       	call   80103f2f <safestrcpy>
  p->cwd = namei("/");
80103377:	c7 04 24 19 7b 10 80 	movl   $0x80107b19,(%esp)
8010337e:	e8 be e8 ff ff       	call   80101c41 <namei>
80103383:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103386:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010338d:	e8 6f 09 00 00       	call   80103d01 <acquire>
  p->state = RUNNABLE;
80103392:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103399:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801033a0:	e8 c3 09 00 00       	call   80103d68 <release>
}
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033ab:	c9                   	leave  
801033ac:	c3                   	ret    
    panic("userinit: out of memory?");
801033ad:	83 ec 0c             	sub    $0xc,%esp
801033b0:	68 f7 7a 10 80       	push   $0x80107af7
801033b5:	e8 86 cf ff ff       	call   80100340 <panic>

801033ba <growproc>:
{
801033ba:	55                   	push   %ebp
801033bb:	89 e5                	mov    %esp,%ebp
801033bd:	56                   	push   %esi
801033be:	53                   	push   %ebx
801033bf:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033c2:	e8 e9 fe ff ff       	call   801032b0 <myproc>
801033c7:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801033c9:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801033cb:	85 f6                	test   %esi,%esi
801033cd:	7f 1c                	jg     801033eb <growproc+0x31>
  } else if(n < 0){
801033cf:	78 37                	js     80103408 <growproc+0x4e>
  curproc->sz = sz;
801033d1:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801033d3:	83 ec 0c             	sub    $0xc,%esp
801033d6:	53                   	push   %ebx
801033d7:	e8 b3 2a 00 00       	call   80105e8f <switchuvm>
  return 0;
801033dc:	83 c4 10             	add    $0x10,%esp
801033df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e7:	5b                   	pop    %ebx
801033e8:	5e                   	pop    %esi
801033e9:	5d                   	pop    %ebp
801033ea:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033eb:	83 ec 04             	sub    $0x4,%esp
801033ee:	01 c6                	add    %eax,%esi
801033f0:	56                   	push   %esi
801033f1:	50                   	push   %eax
801033f2:	ff 73 04             	push   0x4(%ebx)
801033f5:	e8 36 2d 00 00       	call   80106130 <allocuvm>
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	85 c0                	test   %eax,%eax
801033ff:	75 d0                	jne    801033d1 <growproc+0x17>
      return -1;
80103401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103406:	eb dc                	jmp    801033e4 <growproc+0x2a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103408:	83 ec 04             	sub    $0x4,%esp
8010340b:	01 c6                	add    %eax,%esi
8010340d:	56                   	push   %esi
8010340e:	50                   	push   %eax
8010340f:	ff 73 04             	push   0x4(%ebx)
80103412:	e8 8a 2c 00 00       	call   801060a1 <deallocuvm>
80103417:	83 c4 10             	add    $0x10,%esp
8010341a:	85 c0                	test   %eax,%eax
8010341c:	75 b3                	jne    801033d1 <growproc+0x17>
      return -1;
8010341e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103423:	eb bf                	jmp    801033e4 <growproc+0x2a>

80103425 <fork>:
{
80103425:	55                   	push   %ebp
80103426:	89 e5                	mov    %esp,%ebp
80103428:	57                   	push   %edi
80103429:	56                   	push   %esi
8010342a:	53                   	push   %ebx
8010342b:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010342e:	e8 7d fe ff ff       	call   801032b0 <myproc>
80103433:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103435:	e8 cc fc ff ff       	call   80103106 <allocproc>
8010343a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010343d:	85 c0                	test   %eax,%eax
8010343f:	0f 84 e0 00 00 00    	je     80103525 <fork+0x100>
80103445:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103447:	83 ec 08             	sub    $0x8,%esp
8010344a:	ff 33                	push   (%ebx)
8010344c:	ff 73 04             	push   0x4(%ebx)
8010344f:	e8 ee 2e 00 00       	call   80106342 <copyuvm>
80103454:	89 47 04             	mov    %eax,0x4(%edi)
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	85 c0                	test   %eax,%eax
8010345c:	74 2a                	je     80103488 <fork+0x63>
  np->sz = curproc->sz;
8010345e:	8b 03                	mov    (%ebx),%eax
80103460:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103463:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103465:	89 c8                	mov    %ecx,%eax
80103467:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010346a:	8b 73 18             	mov    0x18(%ebx),%esi
8010346d:	8b 79 18             	mov    0x18(%ecx),%edi
80103470:	b9 13 00 00 00       	mov    $0x13,%ecx
80103475:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103477:	8b 40 18             	mov    0x18(%eax),%eax
8010347a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103481:	be 00 00 00 00       	mov    $0x0,%esi
80103486:	eb 2e                	jmp    801034b6 <fork+0x91>
    kfree(np->kstack);
80103488:	83 ec 0c             	sub    $0xc,%esp
8010348b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010348e:	ff 73 08             	push   0x8(%ebx)
80103491:	e8 66 eb ff ff       	call   80101ffc <kfree>
    np->kstack = 0;
80103496:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010349d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801034a4:	83 c4 10             	add    $0x10,%esp
801034a7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034ac:	eb 6d                	jmp    8010351b <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
801034ae:	83 c6 01             	add    $0x1,%esi
801034b1:	83 fe 10             	cmp    $0x10,%esi
801034b4:	74 1d                	je     801034d3 <fork+0xae>
    if(curproc->ofile[i])
801034b6:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 f0                	je     801034ae <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 2d d8 ff ff       	call   80100cf4 <filedup>
801034c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034ca:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801034ce:	83 c4 10             	add    $0x10,%esp
801034d1:	eb db                	jmp    801034ae <fork+0x89>
  np->cwd = idup(curproc->cwd);
801034d3:	83 ec 0c             	sub    $0xc,%esp
801034d6:	ff 73 68             	push   0x68(%ebx)
801034d9:	e8 aa df ff ff       	call   80101488 <idup>
801034de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034e1:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801034e4:	83 c4 0c             	add    $0xc,%esp
801034e7:	6a 10                	push   $0x10
801034e9:	83 c3 6c             	add    $0x6c,%ebx
801034ec:	53                   	push   %ebx
801034ed:	8d 47 6c             	lea    0x6c(%edi),%eax
801034f0:	50                   	push   %eax
801034f1:	e8 39 0a 00 00       	call   80103f2f <safestrcpy>
  pid = np->pid;
801034f6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801034f9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103500:	e8 fc 07 00 00       	call   80103d01 <acquire>
  np->state = RUNNABLE;
80103505:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010350c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103513:	e8 50 08 00 00       	call   80103d68 <release>
  return pid;
80103518:	83 c4 10             	add    $0x10,%esp
}
8010351b:	89 d8                	mov    %ebx,%eax
8010351d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103520:	5b                   	pop    %ebx
80103521:	5e                   	pop    %esi
80103522:	5f                   	pop    %edi
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
    return -1;
80103525:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010352a:	eb ef                	jmp    8010351b <fork+0xf6>

8010352c <scheduler>:
{
8010352c:	55                   	push   %ebp
8010352d:	89 e5                	mov    %esp,%ebp
8010352f:	57                   	push   %edi
80103530:	56                   	push   %esi
80103531:	53                   	push   %ebx
80103532:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103535:	e8 fc fc ff ff       	call   80103236 <mycpu>
8010353a:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010353c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103543:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103546:	8d 78 04             	lea    0x4(%eax),%edi
80103549:	eb 5a                	jmp    801035a5 <scheduler+0x79>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010354b:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103551:	81 fb 94 35 11 80    	cmp    $0x80113594,%ebx
80103557:	74 3c                	je     80103595 <scheduler+0x69>
      if(p->state != RUNNABLE)
80103559:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010355d:	75 ec                	jne    8010354b <scheduler+0x1f>
      c->proc = p;
8010355f:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103565:	83 ec 0c             	sub    $0xc,%esp
80103568:	53                   	push   %ebx
80103569:	e8 21 29 00 00       	call   80105e8f <switchuvm>
      p->state = RUNNING;
8010356e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103575:	83 c4 08             	add    $0x8,%esp
80103578:	ff 73 1c             	push   0x1c(%ebx)
8010357b:	57                   	push   %edi
8010357c:	e8 06 0a 00 00       	call   80103f87 <swtch>
      switchkvm();
80103581:	e8 fb 28 00 00       	call   80105e81 <switchkvm>
      c->proc = 0;
80103586:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010358d:	00 00 00 
80103590:	83 c4 10             	add    $0x10,%esp
80103593:	eb b6                	jmp    8010354b <scheduler+0x1f>
    release(&ptable.lock);
80103595:	83 ec 0c             	sub    $0xc,%esp
80103598:	68 20 2d 11 80       	push   $0x80112d20
8010359d:	e8 c6 07 00 00       	call   80103d68 <release>
    sti();
801035a2:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801035a5:	fb                   	sti    
    acquire(&ptable.lock);
801035a6:	83 ec 0c             	sub    $0xc,%esp
801035a9:	68 20 2d 11 80       	push   $0x80112d20
801035ae:	e8 4e 07 00 00       	call   80103d01 <acquire>
801035b3:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035b6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801035bb:	eb 9c                	jmp    80103559 <scheduler+0x2d>

801035bd <sched>:
{
801035bd:	55                   	push   %ebp
801035be:	89 e5                	mov    %esp,%ebp
801035c0:	56                   	push   %esi
801035c1:	53                   	push   %ebx
  struct proc *p = myproc();
801035c2:	e8 e9 fc ff ff       	call   801032b0 <myproc>
801035c7:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801035c9:	83 ec 0c             	sub    $0xc,%esp
801035cc:	68 20 2d 11 80       	push   $0x80112d20
801035d1:	e8 f7 06 00 00       	call   80103ccd <holding>
801035d6:	83 c4 10             	add    $0x10,%esp
801035d9:	85 c0                	test   %eax,%eax
801035db:	74 4f                	je     8010362c <sched+0x6f>
  if(mycpu()->ncli != 1)
801035dd:	e8 54 fc ff ff       	call   80103236 <mycpu>
801035e2:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801035e9:	75 4e                	jne    80103639 <sched+0x7c>
  if(p->state == RUNNING)
801035eb:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801035ef:	74 55                	je     80103646 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035f1:	9c                   	pushf  
801035f2:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035f3:	f6 c4 02             	test   $0x2,%ah
801035f6:	75 5b                	jne    80103653 <sched+0x96>
  intena = mycpu()->intena;
801035f8:	e8 39 fc ff ff       	call   80103236 <mycpu>
801035fd:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103603:	e8 2e fc ff ff       	call   80103236 <mycpu>
80103608:	83 ec 08             	sub    $0x8,%esp
8010360b:	ff 70 04             	push   0x4(%eax)
8010360e:	83 c3 1c             	add    $0x1c,%ebx
80103611:	53                   	push   %ebx
80103612:	e8 70 09 00 00       	call   80103f87 <swtch>
  mycpu()->intena = intena;
80103617:	e8 1a fc ff ff       	call   80103236 <mycpu>
8010361c:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103628:	5b                   	pop    %ebx
80103629:	5e                   	pop    %esi
8010362a:	5d                   	pop    %ebp
8010362b:	c3                   	ret    
    panic("sched ptable.lock");
8010362c:	83 ec 0c             	sub    $0xc,%esp
8010362f:	68 1b 7b 10 80       	push   $0x80107b1b
80103634:	e8 07 cd ff ff       	call   80100340 <panic>
    panic("sched locks");
80103639:	83 ec 0c             	sub    $0xc,%esp
8010363c:	68 2d 7b 10 80       	push   $0x80107b2d
80103641:	e8 fa cc ff ff       	call   80100340 <panic>
    panic("sched running");
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	68 39 7b 10 80       	push   $0x80107b39
8010364e:	e8 ed cc ff ff       	call   80100340 <panic>
    panic("sched interruptible");
80103653:	83 ec 0c             	sub    $0xc,%esp
80103656:	68 47 7b 10 80       	push   $0x80107b47
8010365b:	e8 e0 cc ff ff       	call   80100340 <panic>

80103660 <exit>:
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103669:	e8 42 fc ff ff       	call   801032b0 <myproc>
8010366e:	89 c6                	mov    %eax,%esi
  if(curproc == initproc)
80103670:	8d 58 28             	lea    0x28(%eax),%ebx
80103673:	8d 78 68             	lea    0x68(%eax),%edi
80103676:	39 05 94 35 11 80    	cmp    %eax,0x80113594
8010367c:	75 14                	jne    80103692 <exit+0x32>
    panic("init exiting");
8010367e:	83 ec 0c             	sub    $0xc,%esp
80103681:	68 5b 7b 10 80       	push   $0x80107b5b
80103686:	e8 b5 cc ff ff       	call   80100340 <panic>
  for(fd = 0; fd < NOFILE; fd++){
8010368b:	83 c3 04             	add    $0x4,%ebx
8010368e:	39 fb                	cmp    %edi,%ebx
80103690:	74 1a                	je     801036ac <exit+0x4c>
    if(curproc->ofile[fd]){
80103692:	8b 03                	mov    (%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	74 f3                	je     8010368b <exit+0x2b>
      fileclose(curproc->ofile[fd]);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	50                   	push   %eax
8010369c:	e8 98 d6 ff ff       	call   80100d39 <fileclose>
      curproc->ofile[fd] = 0;
801036a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801036a7:	83 c4 10             	add    $0x10,%esp
801036aa:	eb df                	jmp    8010368b <exit+0x2b>
  begin_op();
801036ac:	e8 cd f0 ff ff       	call   8010277e <begin_op>
  iput(curproc->cwd);
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	ff 76 68             	push   0x68(%esi)
801036b7:	e8 fe de ff ff       	call   801015ba <iput>
  end_op();
801036bc:	e8 38 f1 ff ff       	call   801027f9 <end_op>
  curproc->cwd = 0;
801036c1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036c8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801036cf:	e8 2d 06 00 00       	call   80103d01 <acquire>
  wakeup1(curproc->parent);
801036d4:	8b 46 14             	mov    0x14(%esi),%eax
801036d7:	e8 00 fa ff ff       	call   801030dc <wakeup1>
801036dc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036df:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801036e4:	eb 0e                	jmp    801036f4 <exit+0x94>
801036e6:	81 c3 84 00 00 00    	add    $0x84,%ebx
801036ec:	81 fb 94 35 11 80    	cmp    $0x80113594,%ebx
801036f2:	74 1a                	je     8010370e <exit+0xae>
    if(p->parent == curproc){
801036f4:	39 73 14             	cmp    %esi,0x14(%ebx)
801036f7:	75 ed                	jne    801036e6 <exit+0x86>
      p->parent = initproc;
801036f9:	a1 94 35 11 80       	mov    0x80113594,%eax
801036fe:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103701:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103705:	75 df                	jne    801036e6 <exit+0x86>
        wakeup1(initproc);
80103707:	e8 d0 f9 ff ff       	call   801030dc <wakeup1>
8010370c:	eb d8                	jmp    801036e6 <exit+0x86>
  curproc->state = ZOMBIE;
8010370e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103715:	e8 a3 fe ff ff       	call   801035bd <sched>
  panic("zombie exit");
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 68 7b 10 80       	push   $0x80107b68
80103722:	e8 19 cc ff ff       	call   80100340 <panic>

80103727 <yield>:
{
80103727:	55                   	push   %ebp
80103728:	89 e5                	mov    %esp,%ebp
8010372a:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010372d:	68 20 2d 11 80       	push   $0x80112d20
80103732:	e8 ca 05 00 00       	call   80103d01 <acquire>
  myproc()->state = RUNNABLE;
80103737:	e8 74 fb ff ff       	call   801032b0 <myproc>
8010373c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103743:	e8 75 fe ff ff       	call   801035bd <sched>
  release(&ptable.lock);
80103748:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010374f:	e8 14 06 00 00       	call   80103d68 <release>
}
80103754:	83 c4 10             	add    $0x10,%esp
80103757:	c9                   	leave  
80103758:	c3                   	ret    

80103759 <sleep>:
{
80103759:	55                   	push   %ebp
8010375a:	89 e5                	mov    %esp,%ebp
8010375c:	56                   	push   %esi
8010375d:	53                   	push   %ebx
8010375e:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103761:	e8 4a fb ff ff       	call   801032b0 <myproc>
  if(p == 0)
80103766:	85 c0                	test   %eax,%eax
80103768:	74 5a                	je     801037c4 <sleep+0x6b>
8010376a:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
8010376c:	85 f6                	test   %esi,%esi
8010376e:	74 61                	je     801037d1 <sleep+0x78>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103770:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103776:	74 66                	je     801037de <sleep+0x85>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	68 20 2d 11 80       	push   $0x80112d20
80103780:	e8 7c 05 00 00       	call   80103d01 <acquire>
    release(lk);
80103785:	89 34 24             	mov    %esi,(%esp)
80103788:	e8 db 05 00 00       	call   80103d68 <release>
  p->chan = chan;
8010378d:	8b 45 08             	mov    0x8(%ebp),%eax
80103790:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103793:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010379a:	e8 1e fe ff ff       	call   801035bd <sched>
  p->chan = 0;
8010379f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801037a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ad:	e8 b6 05 00 00       	call   80103d68 <release>
    acquire(lk);
801037b2:	89 34 24             	mov    %esi,(%esp)
801037b5:	e8 47 05 00 00       	call   80103d01 <acquire>
801037ba:	83 c4 10             	add    $0x10,%esp
}
801037bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c0:	5b                   	pop    %ebx
801037c1:	5e                   	pop    %esi
801037c2:	5d                   	pop    %ebp
801037c3:	c3                   	ret    
    panic("sleep");
801037c4:	83 ec 0c             	sub    $0xc,%esp
801037c7:	68 74 7b 10 80       	push   $0x80107b74
801037cc:	e8 6f cb ff ff       	call   80100340 <panic>
    panic("sleep without lk");
801037d1:	83 ec 0c             	sub    $0xc,%esp
801037d4:	68 7a 7b 10 80       	push   $0x80107b7a
801037d9:	e8 62 cb ff ff       	call   80100340 <panic>
  p->chan = chan;
801037de:	8b 45 08             	mov    0x8(%ebp),%eax
801037e1:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037e4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037eb:	e8 cd fd ff ff       	call   801035bd <sched>
  p->chan = 0;
801037f0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801037f7:	eb c4                	jmp    801037bd <sleep+0x64>

801037f9 <wait>:
{
801037f9:	55                   	push   %ebp
801037fa:	89 e5                	mov    %esp,%ebp
801037fc:	57                   	push   %edi
801037fd:	56                   	push   %esi
801037fe:	53                   	push   %ebx
801037ff:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103802:	e8 a9 fa ff ff       	call   801032b0 <myproc>
80103807:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103809:	83 ec 0c             	sub    $0xc,%esp
8010380c:	68 20 2d 11 80       	push   $0x80112d20
80103811:	e8 eb 04 00 00       	call   80103d01 <acquire>
80103816:	83 c4 10             	add    $0x10,%esp
      havekids = 1;
80103819:	bf 01 00 00 00       	mov    $0x1,%edi
    havekids = 0;
8010381e:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103823:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103828:	eb 5f                	jmp    80103889 <wait+0x90>
        pid = p->pid;
8010382a:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	ff 73 08             	push   0x8(%ebx)
80103833:	e8 c4 e7 ff ff       	call   80101ffc <kfree>
        p->kstack = 0;
80103838:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010383f:	83 c4 04             	add    $0x4,%esp
80103842:	ff 73 04             	push   0x4(%ebx)
80103845:	e8 d4 29 00 00       	call   8010621e <freevm>
        p->pid = 0;
8010384a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103851:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103858:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010385c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103863:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010386a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103871:	e8 f2 04 00 00       	call   80103d68 <release>
        return pid;
80103876:	83 c4 10             	add    $0x10,%esp
80103879:	eb 3c                	jmp    801038b7 <wait+0xbe>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010387b:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103881:	81 fb 94 35 11 80    	cmp    $0x80113594,%ebx
80103887:	74 0f                	je     80103898 <wait+0x9f>
      if(p->parent != curproc)
80103889:	39 73 14             	cmp    %esi,0x14(%ebx)
8010388c:	75 ed                	jne    8010387b <wait+0x82>
      if(p->state == ZOMBIE){
8010388e:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103892:	74 96                	je     8010382a <wait+0x31>
      havekids = 1;
80103894:	89 f8                	mov    %edi,%eax
80103896:	eb e3                	jmp    8010387b <wait+0x82>
    if(!havekids || curproc->killed){
80103898:	85 c0                	test   %eax,%eax
8010389a:	74 06                	je     801038a2 <wait+0xa9>
8010389c:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038a0:	74 1f                	je     801038c1 <wait+0xc8>
      release(&ptable.lock);
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	68 20 2d 11 80       	push   $0x80112d20
801038aa:	e8 b9 04 00 00       	call   80103d68 <release>
      return -1;
801038af:	83 c4 10             	add    $0x10,%esp
801038b2:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
801038b7:	89 f0                	mov    %esi,%eax
801038b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038bc:	5b                   	pop    %ebx
801038bd:	5e                   	pop    %esi
801038be:	5f                   	pop    %edi
801038bf:	5d                   	pop    %ebp
801038c0:	c3                   	ret    
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801038c1:	83 ec 08             	sub    $0x8,%esp
801038c4:	68 20 2d 11 80       	push   $0x80112d20
801038c9:	56                   	push   %esi
801038ca:	e8 8a fe ff ff       	call   80103759 <sleep>
    havekids = 0;
801038cf:	83 c4 10             	add    $0x10,%esp
801038d2:	e9 47 ff ff ff       	jmp    8010381e <wait+0x25>

801038d7 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801038d7:	55                   	push   %ebp
801038d8:	89 e5                	mov    %esp,%ebp
801038da:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038dd:	68 20 2d 11 80       	push   $0x80112d20
801038e2:	e8 1a 04 00 00       	call   80103d01 <acquire>
  wakeup1(chan);
801038e7:	8b 45 08             	mov    0x8(%ebp),%eax
801038ea:	e8 ed f7 ff ff       	call   801030dc <wakeup1>
  release(&ptable.lock);
801038ef:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038f6:	e8 6d 04 00 00       	call   80103d68 <release>
}
801038fb:	83 c4 10             	add    $0x10,%esp
801038fe:	c9                   	leave  
801038ff:	c3                   	ret    

80103900 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 10             	sub    $0x10,%esp
80103907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010390a:	68 20 2d 11 80       	push   $0x80112d20
8010390f:	e8 ed 03 00 00       	call   80103d01 <acquire>
80103914:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103917:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
    if(p->pid == pid){
8010391c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010391f:	74 26                	je     80103947 <kill+0x47>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103921:	05 84 00 00 00       	add    $0x84,%eax
80103926:	3d 94 35 11 80       	cmp    $0x80113594,%eax
8010392b:	75 ef                	jne    8010391c <kill+0x1c>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010392d:	83 ec 0c             	sub    $0xc,%esp
80103930:	68 20 2d 11 80       	push   $0x80112d20
80103935:	e8 2e 04 00 00       	call   80103d68 <release>
  return -1;
8010393a:	83 c4 10             	add    $0x10,%esp
8010393d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103945:	c9                   	leave  
80103946:	c3                   	ret    
      p->killed = 1;
80103947:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010394e:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103952:	74 17                	je     8010396b <kill+0x6b>
      release(&ptable.lock);
80103954:	83 ec 0c             	sub    $0xc,%esp
80103957:	68 20 2d 11 80       	push   $0x80112d20
8010395c:	e8 07 04 00 00       	call   80103d68 <release>
      return 0;
80103961:	83 c4 10             	add    $0x10,%esp
80103964:	b8 00 00 00 00       	mov    $0x0,%eax
80103969:	eb d7                	jmp    80103942 <kill+0x42>
        p->state = RUNNABLE;
8010396b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103972:	eb e0                	jmp    80103954 <kill+0x54>

80103974 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	57                   	push   %edi
80103978:	56                   	push   %esi
80103979:	53                   	push   %ebx
8010397a:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010397d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103982:	bf 00 36 11 80       	mov    $0x80113600,%edi
80103987:	eb 32                	jmp    801039bb <procdump+0x47>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %p", p->pid, state, p->name);
80103989:	56                   	push   %esi
8010398a:	52                   	push   %edx
8010398b:	ff 76 a4             	push   -0x5c(%esi)
8010398e:	68 8f 7b 10 80       	push   $0x80107b8f
80103993:	e8 69 cc ff ff       	call   80100601 <cprintf>
    //cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
80103998:	83 c4 10             	add    $0x10,%esp
8010399b:	83 7e a0 02          	cmpl   $0x2,-0x60(%esi)
8010399f:	74 40                	je     801039e1 <procdump+0x6d>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039a1:	83 ec 0c             	sub    $0xc,%esp
801039a4:	68 3f 7f 10 80       	push   $0x80107f3f
801039a9:	e8 53 cc ff ff       	call   80100601 <cprintf>
801039ae:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b1:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039b7:	39 fb                	cmp    %edi,%ebx
801039b9:	74 65                	je     80103a20 <procdump+0xac>
    if(p->state == UNUSED)
801039bb:	89 de                	mov    %ebx,%esi
801039bd:	8b 43 a0             	mov    -0x60(%ebx),%eax
801039c0:	85 c0                	test   %eax,%eax
801039c2:	74 ed                	je     801039b1 <procdump+0x3d>
      state = "???";
801039c4:	ba 8b 7b 10 80       	mov    $0x80107b8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801039c9:	83 f8 05             	cmp    $0x5,%eax
801039cc:	77 bb                	ja     80103989 <procdump+0x15>
801039ce:	8b 14 85 1c 7c 10 80 	mov    -0x7fef83e4(,%eax,4),%edx
      state = "???";
801039d5:	85 d2                	test   %edx,%edx
801039d7:	b8 8b 7b 10 80       	mov    $0x80107b8b,%eax
801039dc:	0f 44 d0             	cmove  %eax,%edx
801039df:	eb a8                	jmp    80103989 <procdump+0x15>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801039e1:	83 ec 08             	sub    $0x8,%esp
801039e4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801039e7:	50                   	push   %eax
801039e8:	8b 46 b0             	mov    -0x50(%esi),%eax
801039eb:	8b 40 0c             	mov    0xc(%eax),%eax
801039ee:	83 c0 08             	add    $0x8,%eax
801039f1:	50                   	push   %eax
801039f2:	e8 dc 01 00 00       	call   80103bd3 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801039f7:	8d 75 c0             	lea    -0x40(%ebp),%esi
801039fa:	83 c4 10             	add    $0x10,%esp
801039fd:	8b 06                	mov    (%esi),%eax
801039ff:	85 c0                	test   %eax,%eax
80103a01:	74 9e                	je     801039a1 <procdump+0x2d>
        cprintf(" %p", pc[i]);
80103a03:	83 ec 08             	sub    $0x8,%esp
80103a06:	50                   	push   %eax
80103a07:	68 97 7b 10 80       	push   $0x80107b97
80103a0c:	e8 f0 cb ff ff       	call   80100601 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a11:	83 c6 04             	add    $0x4,%esi
80103a14:	83 c4 10             	add    $0x10,%esp
80103a17:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103a1a:	39 c6                	cmp    %eax,%esi
80103a1c:	75 df                	jne    801039fd <procdump+0x89>
80103a1e:	eb 81                	jmp    801039a1 <procdump+0x2d>
  }
}
80103a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a23:	5b                   	pop    %ebx
80103a24:	5e                   	pop    %esi
80103a25:	5f                   	pop    %edi
80103a26:	5d                   	pop    %ebp
80103a27:	c3                   	ret    

80103a28 <ps>:

void
ps(void)
{
80103a28:	55                   	push   %ebp
80103a29:	89 e5                	mov    %esp,%ebp
80103a2b:	57                   	push   %edi
80103a2c:	56                   	push   %esi
80103a2d:	53                   	push   %ebx
80103a2e:	83 ec 18             	sub    $0x18,%esp
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state, *name;

	acquire(&ptable.lock);
80103a31:	68 20 2d 11 80       	push   $0x80112d20
80103a36:	e8 c6 02 00 00       	call   80103d01 <acquire>
80103a3b:	83 c4 10             	add    $0x10,%esp

	for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a3e:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
	{   
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
				state = states[p->state];
			else
				state = "???";
80103a43:	bf 8b 7b 10 80       	mov    $0x80107b8b,%edi
80103a48:	be 9b 7b 10 80       	mov    $0x80107b9b,%esi
80103a4d:	eb 2c                	jmp    80103a7b <ps+0x53>

			if(p->state == UNUSED)
80103a4f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a52:	85 c9                	test   %ecx,%ecx
80103a54:	0f 44 c6             	cmove  %esi,%eax
				name = "unknown";
			else
				name = p->name;

    	cprintf("%d %s %s %p\n", p->pid, state, name, p);
80103a57:	83 ec 0c             	sub    $0xc,%esp
80103a5a:	53                   	push   %ebx
80103a5b:	50                   	push   %eax
80103a5c:	52                   	push   %edx
80103a5d:	ff 73 10             	push   0x10(%ebx)
80103a60:	68 a3 7b 10 80       	push   $0x80107ba3
80103a65:	e8 97 cb ff ff       	call   80100601 <cprintf>
	for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a6a:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103a70:	83 c4 20             	add    $0x20,%esp
80103a73:	81 fb 94 35 11 80    	cmp    $0x80113594,%ebx
80103a79:	74 1b                	je     80103a96 <ps+0x6e>
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a7b:	8b 4b 0c             	mov    0xc(%ebx),%ecx
				state = "???";
80103a7e:	ba 8b 7b 10 80       	mov    $0x80107b8b,%edx
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a83:	83 f9 05             	cmp    $0x5,%ecx
80103a86:	77 c7                	ja     80103a4f <ps+0x27>
80103a88:	8b 14 8d 04 7c 10 80 	mov    -0x7fef83fc(,%ecx,4),%edx
				state = "???";
80103a8f:	85 d2                	test   %edx,%edx
80103a91:	0f 44 d7             	cmove  %edi,%edx
80103a94:	eb b9                	jmp    80103a4f <ps+0x27>

    }   
    release(&ptable.lock);
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	68 20 2d 11 80       	push   $0x80112d20
80103a9e:	e8 c5 02 00 00       	call   80103d68 <release>
    return;
80103aa3:	83 c4 10             	add    $0x10,%esp
}
80103aa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa9:	5b                   	pop    %ebx
80103aaa:	5e                   	pop    %esi
80103aab:	5f                   	pop    %edi
80103aac:	5d                   	pop    %ebp
80103aad:	c3                   	ret    

80103aae <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103aae:	55                   	push   %ebp
80103aaf:	89 e5                	mov    %esp,%ebp
80103ab1:	53                   	push   %ebx
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ab8:	68 34 7c 10 80       	push   $0x80107c34
80103abd:	8d 43 04             	lea    0x4(%ebx),%eax
80103ac0:	50                   	push   %eax
80103ac1:	e8 f2 00 00 00       	call   80103bb8 <initlock>
  lk->name = name;
80103ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ac9:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103acc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ad2:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103ad9:	83 c4 10             	add    $0x10,%esp
80103adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adf:	c9                   	leave  
80103ae0:	c3                   	ret    

80103ae1 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103ae1:	55                   	push   %ebp
80103ae2:	89 e5                	mov    %esp,%ebp
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ae9:	8d 73 04             	lea    0x4(%ebx),%esi
80103aec:	83 ec 0c             	sub    $0xc,%esp
80103aef:	56                   	push   %esi
80103af0:	e8 0c 02 00 00       	call   80103d01 <acquire>
  while (lk->locked) {
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	83 3b 00             	cmpl   $0x0,(%ebx)
80103afb:	74 12                	je     80103b0f <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103afd:	83 ec 08             	sub    $0x8,%esp
80103b00:	56                   	push   %esi
80103b01:	53                   	push   %ebx
80103b02:	e8 52 fc ff ff       	call   80103759 <sleep>
  while (lk->locked) {
80103b07:	83 c4 10             	add    $0x10,%esp
80103b0a:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b0d:	75 ee                	jne    80103afd <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103b0f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b15:	e8 96 f7 ff ff       	call   801032b0 <myproc>
80103b1a:	8b 40 10             	mov    0x10(%eax),%eax
80103b1d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	56                   	push   %esi
80103b24:	e8 3f 02 00 00       	call   80103d68 <release>
}
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b2f:	5b                   	pop    %ebx
80103b30:	5e                   	pop    %esi
80103b31:	5d                   	pop    %ebp
80103b32:	c3                   	ret    

80103b33 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b33:	55                   	push   %ebp
80103b34:	89 e5                	mov    %esp,%ebp
80103b36:	56                   	push   %esi
80103b37:	53                   	push   %ebx
80103b38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b3b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b3e:	83 ec 0c             	sub    $0xc,%esp
80103b41:	56                   	push   %esi
80103b42:	e8 ba 01 00 00       	call   80103d01 <acquire>
  lk->locked = 0;
80103b47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b4d:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b54:	89 1c 24             	mov    %ebx,(%esp)
80103b57:	e8 7b fd ff ff       	call   801038d7 <wakeup>
  release(&lk->lk);
80103b5c:	89 34 24             	mov    %esi,(%esp)
80103b5f:	e8 04 02 00 00       	call   80103d68 <release>
}
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6a:	5b                   	pop    %ebx
80103b6b:	5e                   	pop    %esi
80103b6c:	5d                   	pop    %ebp
80103b6d:	c3                   	ret    

80103b6e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b6e:	55                   	push   %ebp
80103b6f:	89 e5                	mov    %esp,%ebp
80103b71:	57                   	push   %edi
80103b72:	56                   	push   %esi
80103b73:	53                   	push   %ebx
80103b74:	83 ec 18             	sub    $0x18,%esp
80103b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b7a:	8d 73 04             	lea    0x4(%ebx),%esi
80103b7d:	56                   	push   %esi
80103b7e:	e8 7e 01 00 00       	call   80103d01 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b83:	83 c4 10             	add    $0x10,%esp
80103b86:	bf 00 00 00 00       	mov    $0x0,%edi
80103b8b:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b8e:	75 13                	jne    80103ba3 <holdingsleep+0x35>
  release(&lk->lk);
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	56                   	push   %esi
80103b94:	e8 cf 01 00 00       	call   80103d68 <release>
  return r;
}
80103b99:	89 f8                	mov    %edi,%eax
80103b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b9e:	5b                   	pop    %ebx
80103b9f:	5e                   	pop    %esi
80103ba0:	5f                   	pop    %edi
80103ba1:	5d                   	pop    %ebp
80103ba2:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103ba3:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103ba6:	e8 05 f7 ff ff       	call   801032b0 <myproc>
80103bab:	39 58 10             	cmp    %ebx,0x10(%eax)
80103bae:	0f 94 c0             	sete   %al
80103bb1:	0f b6 c0             	movzbl %al,%eax
80103bb4:	89 c7                	mov    %eax,%edi
80103bb6:	eb d8                	jmp    80103b90 <holdingsleep+0x22>

80103bb8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103bb8:	55                   	push   %ebp
80103bb9:	89 e5                	mov    %esp,%ebp
80103bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bc1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103bca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103bd1:	5d                   	pop    %ebp
80103bd2:	c3                   	ret    

80103bd3 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103bd3:	55                   	push   %ebp
80103bd4:	89 e5                	mov    %esp,%ebp
80103bd6:	53                   	push   %ebx
80103bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bdd:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103be3:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103be9:	77 2d                	ja     80103c18 <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103beb:	8b 50 fc             	mov    -0x4(%eax),%edx
80103bee:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bf0:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103bf3:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bf8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bfe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c04:	77 17                	ja     80103c1d <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
80103c06:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c09:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c0c:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c0e:	83 c0 01             	add    $0x1,%eax
80103c11:	83 f8 0a             	cmp    $0xa,%eax
80103c14:	75 e2                	jne    80103bf8 <getcallerpcs+0x25>
80103c16:	eb 14                	jmp    80103c2c <getcallerpcs+0x59>
80103c18:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c1d:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c24:	83 c0 01             	add    $0x1,%eax
80103c27:	83 f8 09             	cmp    $0x9,%eax
80103c2a:	7e f1                	jle    80103c1d <getcallerpcs+0x4a>
}
80103c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c2f:	c9                   	leave  
80103c30:	c3                   	ret    

80103c31 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c31:	55                   	push   %ebp
80103c32:	89 e5                	mov    %esp,%ebp
80103c34:	53                   	push   %ebx
80103c35:	83 ec 04             	sub    $0x4,%esp
80103c38:	9c                   	pushf  
80103c39:	5b                   	pop    %ebx
  asm volatile("cli");
80103c3a:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c3b:	e8 f6 f5 ff ff       	call   80103236 <mycpu>
80103c40:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c47:	74 11                	je     80103c5a <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c49:	e8 e8 f5 ff ff       	call   80103236 <mycpu>
80103c4e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c58:	c9                   	leave  
80103c59:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c5a:	e8 d7 f5 ff ff       	call   80103236 <mycpu>
80103c5f:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c65:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c6b:	eb dc                	jmp    80103c49 <pushcli+0x18>

80103c6d <popcli>:

void
popcli(void)
{
80103c6d:	55                   	push   %ebp
80103c6e:	89 e5                	mov    %esp,%ebp
80103c70:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c73:	9c                   	pushf  
80103c74:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c75:	f6 c4 02             	test   $0x2,%ah
80103c78:	75 28                	jne    80103ca2 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c7a:	e8 b7 f5 ff ff       	call   80103236 <mycpu>
80103c7f:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c85:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c88:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c8e:	85 d2                	test   %edx,%edx
80103c90:	78 1d                	js     80103caf <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c92:	e8 9f f5 ff ff       	call   80103236 <mycpu>
80103c97:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c9e:	74 1c                	je     80103cbc <popcli+0x4f>
    sti();
}
80103ca0:	c9                   	leave  
80103ca1:	c3                   	ret    
    panic("popcli - interruptible");
80103ca2:	83 ec 0c             	sub    $0xc,%esp
80103ca5:	68 3f 7c 10 80       	push   $0x80107c3f
80103caa:	e8 91 c6 ff ff       	call   80100340 <panic>
    panic("popcli");
80103caf:	83 ec 0c             	sub    $0xc,%esp
80103cb2:	68 56 7c 10 80       	push   $0x80107c56
80103cb7:	e8 84 c6 ff ff       	call   80100340 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cbc:	e8 75 f5 ff ff       	call   80103236 <mycpu>
80103cc1:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103cc8:	74 d6                	je     80103ca0 <popcli+0x33>
  asm volatile("sti");
80103cca:	fb                   	sti    
}
80103ccb:	eb d3                	jmp    80103ca0 <popcli+0x33>

80103ccd <holding>:
{
80103ccd:	55                   	push   %ebp
80103cce:	89 e5                	mov    %esp,%ebp
80103cd0:	56                   	push   %esi
80103cd1:	53                   	push   %ebx
80103cd2:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cd5:	e8 57 ff ff ff       	call   80103c31 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103cda:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cdf:	83 3e 00             	cmpl   $0x0,(%esi)
80103ce2:	75 0b                	jne    80103cef <holding+0x22>
  popcli();
80103ce4:	e8 84 ff ff ff       	call   80103c6d <popcli>
}
80103ce9:	89 d8                	mov    %ebx,%eax
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5d                   	pop    %ebp
80103cee:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103cef:	8b 5e 08             	mov    0x8(%esi),%ebx
80103cf2:	e8 3f f5 ff ff       	call   80103236 <mycpu>
80103cf7:	39 c3                	cmp    %eax,%ebx
80103cf9:	0f 94 c3             	sete   %bl
80103cfc:	0f b6 db             	movzbl %bl,%ebx
80103cff:	eb e3                	jmp    80103ce4 <holding+0x17>

80103d01 <acquire>:
{
80103d01:	55                   	push   %ebp
80103d02:	89 e5                	mov    %esp,%ebp
80103d04:	53                   	push   %ebx
80103d05:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d08:	e8 24 ff ff ff       	call   80103c31 <pushcli>
  if(holding(lk))
80103d0d:	83 ec 0c             	sub    $0xc,%esp
80103d10:	ff 75 08             	push   0x8(%ebp)
80103d13:	e8 b5 ff ff ff       	call   80103ccd <holding>
80103d18:	83 c4 10             	add    $0x10,%esp
80103d1b:	85 c0                	test   %eax,%eax
80103d1d:	75 3c                	jne    80103d5b <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
80103d1f:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103d24:	8b 55 08             	mov    0x8(%ebp),%edx
80103d27:	89 c8                	mov    %ecx,%eax
80103d29:	f0 87 02             	lock xchg %eax,(%edx)
80103d2c:	85 c0                	test   %eax,%eax
80103d2e:	75 f4                	jne    80103d24 <acquire+0x23>
  __sync_synchronize();
80103d30:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d38:	e8 f9 f4 ff ff       	call   80103236 <mycpu>
80103d3d:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d40:	83 ec 08             	sub    $0x8,%esp
80103d43:	8b 45 08             	mov    0x8(%ebp),%eax
80103d46:	83 c0 0c             	add    $0xc,%eax
80103d49:	50                   	push   %eax
80103d4a:	8d 45 08             	lea    0x8(%ebp),%eax
80103d4d:	50                   	push   %eax
80103d4e:	e8 80 fe ff ff       	call   80103bd3 <getcallerpcs>
}
80103d53:	83 c4 10             	add    $0x10,%esp
80103d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d59:	c9                   	leave  
80103d5a:	c3                   	ret    
    panic("acquire");
80103d5b:	83 ec 0c             	sub    $0xc,%esp
80103d5e:	68 5d 7c 10 80       	push   $0x80107c5d
80103d63:	e8 d8 c5 ff ff       	call   80100340 <panic>

80103d68 <release>:
{
80103d68:	55                   	push   %ebp
80103d69:	89 e5                	mov    %esp,%ebp
80103d6b:	53                   	push   %ebx
80103d6c:	83 ec 10             	sub    $0x10,%esp
80103d6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d72:	53                   	push   %ebx
80103d73:	e8 55 ff ff ff       	call   80103ccd <holding>
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	85 c0                	test   %eax,%eax
80103d7d:	74 23                	je     80103da2 <release+0x3a>
  lk->pcs[0] = 0;
80103d7f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d86:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d8d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d92:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d98:	e8 d0 fe ff ff       	call   80103c6d <popcli>
}
80103d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da0:	c9                   	leave  
80103da1:	c3                   	ret    
    panic("release");
80103da2:	83 ec 0c             	sub    $0xc,%esp
80103da5:	68 65 7c 10 80       	push   $0x80107c65
80103daa:	e8 91 c5 ff ff       	call   80100340 <panic>

80103daf <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103daf:	55                   	push   %ebp
80103db0:	89 e5                	mov    %esp,%ebp
80103db2:	57                   	push   %edi
80103db3:	53                   	push   %ebx
80103db4:	8b 55 08             	mov    0x8(%ebp),%edx
80103db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103dbd:	89 d7                	mov    %edx,%edi
80103dbf:	09 cf                	or     %ecx,%edi
80103dc1:	f7 c7 03 00 00 00    	test   $0x3,%edi
80103dc7:	75 1e                	jne    80103de7 <memset+0x38>
    c &= 0xFF;
80103dc9:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103dcc:	c1 e9 02             	shr    $0x2,%ecx
80103dcf:	c1 e0 18             	shl    $0x18,%eax
80103dd2:	89 fb                	mov    %edi,%ebx
80103dd4:	c1 e3 10             	shl    $0x10,%ebx
80103dd7:	09 d8                	or     %ebx,%eax
80103dd9:	09 f8                	or     %edi,%eax
80103ddb:	c1 e7 08             	shl    $0x8,%edi
80103dde:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103de0:	89 d7                	mov    %edx,%edi
80103de2:	fc                   	cld    
80103de3:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103de5:	eb 05                	jmp    80103dec <memset+0x3d>
  asm volatile("cld; rep stosb" :
80103de7:	89 d7                	mov    %edx,%edi
80103de9:	fc                   	cld    
80103dea:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103dec:	89 d0                	mov    %edx,%eax
80103dee:	5b                   	pop    %ebx
80103def:	5f                   	pop    %edi
80103df0:	5d                   	pop    %ebp
80103df1:	c3                   	ret    

80103df2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103df2:	55                   	push   %ebp
80103df3:	89 e5                	mov    %esp,%ebp
80103df5:	56                   	push   %esi
80103df6:	53                   	push   %ebx
80103df7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dfd:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103e00:	85 f6                	test   %esi,%esi
80103e02:	74 29                	je     80103e2d <memcmp+0x3b>
80103e04:	01 c6                	add    %eax,%esi
    if(*s1 != *s2)
80103e06:	0f b6 08             	movzbl (%eax),%ecx
80103e09:	0f b6 1a             	movzbl (%edx),%ebx
80103e0c:	38 d9                	cmp    %bl,%cl
80103e0e:	75 11                	jne    80103e21 <memcmp+0x2f>
      return *s1 - *s2;
    s1++, s2++;
80103e10:	83 c0 01             	add    $0x1,%eax
80103e13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103e16:	39 c6                	cmp    %eax,%esi
80103e18:	75 ec                	jne    80103e06 <memcmp+0x14>
  }

  return 0;
80103e1a:	b8 00 00 00 00       	mov    $0x0,%eax
80103e1f:	eb 08                	jmp    80103e29 <memcmp+0x37>
      return *s1 - *s2;
80103e21:	0f b6 c1             	movzbl %cl,%eax
80103e24:	0f b6 db             	movzbl %bl,%ebx
80103e27:	29 d8                	sub    %ebx,%eax
}
80103e29:	5b                   	pop    %ebx
80103e2a:	5e                   	pop    %esi
80103e2b:	5d                   	pop    %ebp
80103e2c:	c3                   	ret    
  return 0;
80103e2d:	b8 00 00 00 00       	mov    $0x0,%eax
80103e32:	eb f5                	jmp    80103e29 <memcmp+0x37>

80103e34 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	56                   	push   %esi
80103e38:	53                   	push   %ebx
80103e39:	8b 75 08             	mov    0x8(%ebp),%esi
80103e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e42:	39 f0                	cmp    %esi,%eax
80103e44:	72 20                	jb     80103e66 <memmove+0x32>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80103e46:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80103e49:	89 f2                	mov    %esi,%edx
80103e4b:	85 c9                	test   %ecx,%ecx
80103e4d:	74 11                	je     80103e60 <memmove+0x2c>
      *d++ = *s++;
80103e4f:	83 c0 01             	add    $0x1,%eax
80103e52:	83 c2 01             	add    $0x1,%edx
80103e55:	0f b6 48 ff          	movzbl -0x1(%eax),%ecx
80103e59:	88 4a ff             	mov    %cl,-0x1(%edx)
    while(n-- > 0)
80103e5c:	39 d8                	cmp    %ebx,%eax
80103e5e:	75 ef                	jne    80103e4f <memmove+0x1b>

  return dst;
}
80103e60:	89 f0                	mov    %esi,%eax
80103e62:	5b                   	pop    %ebx
80103e63:	5e                   	pop    %esi
80103e64:	5d                   	pop    %ebp
80103e65:	c3                   	ret    
  if(s < d && s + n > d){
80103e66:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80103e69:	39 d6                	cmp    %edx,%esi
80103e6b:	73 d9                	jae    80103e46 <memmove+0x12>
    while(n-- > 0)
80103e6d:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103e70:	85 c9                	test   %ecx,%ecx
80103e72:	74 ec                	je     80103e60 <memmove+0x2c>
      *--d = *--s;
80103e74:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80103e78:	88 0c 16             	mov    %cl,(%esi,%edx,1)
    while(n-- > 0)
80103e7b:	83 ea 01             	sub    $0x1,%edx
80103e7e:	83 fa ff             	cmp    $0xffffffff,%edx
80103e81:	75 f1                	jne    80103e74 <memmove+0x40>
80103e83:	eb db                	jmp    80103e60 <memmove+0x2c>

80103e85 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e85:	55                   	push   %ebp
80103e86:	89 e5                	mov    %esp,%ebp
80103e88:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e8b:	ff 75 10             	push   0x10(%ebp)
80103e8e:	ff 75 0c             	push   0xc(%ebp)
80103e91:	ff 75 08             	push   0x8(%ebp)
80103e94:	e8 9b ff ff ff       	call   80103e34 <memmove>
}
80103e99:	c9                   	leave  
80103e9a:	c3                   	ret    

80103e9b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e9b:	55                   	push   %ebp
80103e9c:	89 e5                	mov    %esp,%ebp
80103e9e:	53                   	push   %ebx
80103e9f:	8b 55 08             	mov    0x8(%ebp),%edx
80103ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103ea8:	85 c0                	test   %eax,%eax
80103eaa:	74 29                	je     80103ed5 <strncmp+0x3a>
80103eac:	0f b6 1a             	movzbl (%edx),%ebx
80103eaf:	84 db                	test   %bl,%bl
80103eb1:	74 16                	je     80103ec9 <strncmp+0x2e>
80103eb3:	3a 19                	cmp    (%ecx),%bl
80103eb5:	75 12                	jne    80103ec9 <strncmp+0x2e>
    n--, p++, q++;
80103eb7:	83 c2 01             	add    $0x1,%edx
80103eba:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103ebd:	83 e8 01             	sub    $0x1,%eax
80103ec0:	75 ea                	jne    80103eac <strncmp+0x11>
  if(n == 0)
    return 0;
80103ec2:	b8 00 00 00 00       	mov    $0x0,%eax
80103ec7:	eb 0c                	jmp    80103ed5 <strncmp+0x3a>
  if(n == 0)
80103ec9:	85 c0                	test   %eax,%eax
80103ecb:	74 0d                	je     80103eda <strncmp+0x3f>
  return (uchar)*p - (uchar)*q;
80103ecd:	0f b6 02             	movzbl (%edx),%eax
80103ed0:	0f b6 11             	movzbl (%ecx),%edx
80103ed3:	29 d0                	sub    %edx,%eax
}
80103ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed8:	c9                   	leave  
80103ed9:	c3                   	ret    
    return 0;
80103eda:	b8 00 00 00 00       	mov    $0x0,%eax
80103edf:	eb f4                	jmp    80103ed5 <strncmp+0x3a>

80103ee1 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103ee1:	55                   	push   %ebp
80103ee2:	89 e5                	mov    %esp,%ebp
80103ee4:	57                   	push   %edi
80103ee5:	56                   	push   %esi
80103ee6:	53                   	push   %ebx
80103ee7:	8b 75 08             	mov    0x8(%ebp),%esi
80103eea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103eed:	89 f0                	mov    %esi,%eax
80103eef:	89 cb                	mov    %ecx,%ebx
80103ef1:	83 e9 01             	sub    $0x1,%ecx
80103ef4:	85 db                	test   %ebx,%ebx
80103ef6:	7e 17                	jle    80103f0f <strncpy+0x2e>
80103ef8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80103efc:	83 c0 01             	add    $0x1,%eax
80103eff:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103f02:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80103f06:	89 fa                	mov    %edi,%edx
80103f08:	88 50 ff             	mov    %dl,-0x1(%eax)
80103f0b:	84 d2                	test   %dl,%dl
80103f0d:	75 e0                	jne    80103eef <strncpy+0xe>
    ;
  while(n-- > 0)
80103f0f:	89 c2                	mov    %eax,%edx
80103f11:	85 c9                	test   %ecx,%ecx
80103f13:	7e 13                	jle    80103f28 <strncpy+0x47>
    *s++ = 0;
80103f15:	83 c2 01             	add    $0x1,%edx
80103f18:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80103f1c:	89 d9                	mov    %ebx,%ecx
80103f1e:	29 d1                	sub    %edx,%ecx
80103f20:	8d 4c 08 ff          	lea    -0x1(%eax,%ecx,1),%ecx
80103f24:	85 c9                	test   %ecx,%ecx
80103f26:	7f ed                	jg     80103f15 <strncpy+0x34>
  return os;
}
80103f28:	89 f0                	mov    %esi,%eax
80103f2a:	5b                   	pop    %ebx
80103f2b:	5e                   	pop    %esi
80103f2c:	5f                   	pop    %edi
80103f2d:	5d                   	pop    %ebp
80103f2e:	c3                   	ret    

80103f2f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f2f:	55                   	push   %ebp
80103f30:	89 e5                	mov    %esp,%ebp
80103f32:	56                   	push   %esi
80103f33:	53                   	push   %ebx
80103f34:	8b 75 08             	mov    0x8(%ebp),%esi
80103f37:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f3a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103f3d:	85 d2                	test   %edx,%edx
80103f3f:	7e 1e                	jle    80103f5f <safestrcpy+0x30>
80103f41:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80103f45:	89 f2                	mov    %esi,%edx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f47:	39 d8                	cmp    %ebx,%eax
80103f49:	74 11                	je     80103f5c <safestrcpy+0x2d>
80103f4b:	83 c0 01             	add    $0x1,%eax
80103f4e:	83 c2 01             	add    $0x1,%edx
80103f51:	0f b6 48 ff          	movzbl -0x1(%eax),%ecx
80103f55:	88 4a ff             	mov    %cl,-0x1(%edx)
80103f58:	84 c9                	test   %cl,%cl
80103f5a:	75 eb                	jne    80103f47 <safestrcpy+0x18>
    ;
  *s = 0;
80103f5c:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f5f:	89 f0                	mov    %esi,%eax
80103f61:	5b                   	pop    %ebx
80103f62:	5e                   	pop    %esi
80103f63:	5d                   	pop    %ebp
80103f64:	c3                   	ret    

80103f65 <strlen>:

int
strlen(const char *s)
{
80103f65:	55                   	push   %ebp
80103f66:	89 e5                	mov    %esp,%ebp
80103f68:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f6b:	80 3a 00             	cmpb   $0x0,(%edx)
80103f6e:	74 10                	je     80103f80 <strlen+0x1b>
80103f70:	b8 00 00 00 00       	mov    $0x0,%eax
80103f75:	83 c0 01             	add    $0x1,%eax
80103f78:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f7c:	75 f7                	jne    80103f75 <strlen+0x10>
    ;
  return n;
}
80103f7e:	5d                   	pop    %ebp
80103f7f:	c3                   	ret    
  for(n = 0; s[n]; n++)
80103f80:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80103f85:	eb f7                	jmp    80103f7e <strlen+0x19>

80103f87 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f87:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f8b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f8f:	55                   	push   %ebp
  pushl %ebx
80103f90:	53                   	push   %ebx
  pushl %esi
80103f91:	56                   	push   %esi
  pushl %edi
80103f92:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f93:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f95:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f97:	5f                   	pop    %edi
  popl %esi
80103f98:	5e                   	pop    %esi
  popl %ebx
80103f99:	5b                   	pop    %ebx
  popl %ebp
80103f9a:	5d                   	pop    %ebp
  ret
80103f9b:	c3                   	ret    

80103f9c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f9c:	55                   	push   %ebp
80103f9d:	89 e5                	mov    %esp,%ebp
80103f9f:	53                   	push   %ebx
80103fa0:	83 ec 04             	sub    $0x4,%esp
80103fa3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103fa6:	e8 05 f3 ff ff       	call   801032b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103fab:	8b 00                	mov    (%eax),%eax
80103fad:	39 d8                	cmp    %ebx,%eax
80103faf:	76 18                	jbe    80103fc9 <fetchint+0x2d>
80103fb1:	8d 53 04             	lea    0x4(%ebx),%edx
80103fb4:	39 d0                	cmp    %edx,%eax
80103fb6:	72 18                	jb     80103fd0 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103fb8:	8b 13                	mov    (%ebx),%edx
80103fba:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fbd:	89 10                	mov    %edx,(%eax)
  return 0;
80103fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc7:	c9                   	leave  
80103fc8:	c3                   	ret    
    return -1;
80103fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fce:	eb f4                	jmp    80103fc4 <fetchint+0x28>
80103fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd5:	eb ed                	jmp    80103fc4 <fetchint+0x28>

80103fd7 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fd7:	55                   	push   %ebp
80103fd8:	89 e5                	mov    %esp,%ebp
80103fda:	53                   	push   %ebx
80103fdb:	83 ec 04             	sub    $0x4,%esp
80103fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103fe1:	e8 ca f2 ff ff       	call   801032b0 <myproc>

  if(addr >= curproc->sz)
80103fe6:	39 18                	cmp    %ebx,(%eax)
80103fe8:	76 27                	jbe    80104011 <fetchstr+0x3a>
    return -1;
  *pp = (char*)addr;
80103fea:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fed:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103fef:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103ff1:	39 d3                	cmp    %edx,%ebx
80103ff3:	73 23                	jae    80104018 <fetchstr+0x41>
80103ff5:	89 d8                	mov    %ebx,%eax
    if(*s == 0)
80103ff7:	80 38 00             	cmpb   $0x0,(%eax)
80103ffa:	74 0e                	je     8010400a <fetchstr+0x33>
  for(s = *pp; s < ep; s++){
80103ffc:	83 c0 01             	add    $0x1,%eax
80103fff:	39 c2                	cmp    %eax,%edx
80104001:	77 f4                	ja     80103ff7 <fetchstr+0x20>
      return s - *pp;
  }
  return -1;
80104003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104008:	eb 02                	jmp    8010400c <fetchstr+0x35>
      return s - *pp;
8010400a:	29 d8                	sub    %ebx,%eax
}
8010400c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010400f:	c9                   	leave  
80104010:	c3                   	ret    
    return -1;
80104011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104016:	eb f4                	jmp    8010400c <fetchstr+0x35>
  return -1;
80104018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010401d:	eb ed                	jmp    8010400c <fetchstr+0x35>

8010401f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010401f:	55                   	push   %ebp
80104020:	89 e5                	mov    %esp,%ebp
80104022:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104025:	e8 86 f2 ff ff       	call   801032b0 <myproc>
8010402a:	83 ec 08             	sub    $0x8,%esp
8010402d:	ff 75 0c             	push   0xc(%ebp)
80104030:	8b 40 18             	mov    0x18(%eax),%eax
80104033:	8b 40 44             	mov    0x44(%eax),%eax
80104036:	8b 55 08             	mov    0x8(%ebp),%edx
80104039:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
8010403d:	50                   	push   %eax
8010403e:	e8 59 ff ff ff       	call   80103f9c <fetchint>
}
80104043:	c9                   	leave  
80104044:	c3                   	ret    

80104045 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104045:	55                   	push   %ebp
80104046:	89 e5                	mov    %esp,%ebp
80104048:	56                   	push   %esi
80104049:	53                   	push   %ebx
8010404a:	83 ec 10             	sub    $0x10,%esp
8010404d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104050:	e8 5b f2 ff ff       	call   801032b0 <myproc>
80104055:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104057:	83 ec 08             	sub    $0x8,%esp
8010405a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010405d:	50                   	push   %eax
8010405e:	ff 75 08             	push   0x8(%ebp)
80104061:	e8 b9 ff ff ff       	call   8010401f <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104066:	83 c4 10             	add    $0x10,%esp
80104069:	09 d8                	or     %ebx,%eax
8010406b:	78 20                	js     8010408d <argptr+0x48>
8010406d:	8b 16                	mov    (%esi),%edx
8010406f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104072:	39 c2                	cmp    %eax,%edx
80104074:	76 1e                	jbe    80104094 <argptr+0x4f>
80104076:	01 c3                	add    %eax,%ebx
80104078:	39 da                	cmp    %ebx,%edx
8010407a:	72 1f                	jb     8010409b <argptr+0x56>
    return -1;
  *pp = (char*)i;
8010407c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010407f:	89 02                	mov    %eax,(%edx)
  return 0;
80104081:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
    return -1;
8010408d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104092:	eb f2                	jmp    80104086 <argptr+0x41>
80104094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104099:	eb eb                	jmp    80104086 <argptr+0x41>
8010409b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040a0:	eb e4                	jmp    80104086 <argptr+0x41>

801040a2 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801040a2:	55                   	push   %ebp
801040a3:	89 e5                	mov    %esp,%ebp
801040a5:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801040a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040ab:	50                   	push   %eax
801040ac:	ff 75 08             	push   0x8(%ebp)
801040af:	e8 6b ff ff ff       	call   8010401f <argint>
801040b4:	83 c4 10             	add    $0x10,%esp
801040b7:	85 c0                	test   %eax,%eax
801040b9:	78 13                	js     801040ce <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
801040bb:	83 ec 08             	sub    $0x8,%esp
801040be:	ff 75 0c             	push   0xc(%ebp)
801040c1:	ff 75 f4             	push   -0xc(%ebp)
801040c4:	e8 0e ff ff ff       	call   80103fd7 <fetchstr>
801040c9:	83 c4 10             	add    $0x10,%esp
}
801040cc:	c9                   	leave  
801040cd:	c3                   	ret    
    return -1;
801040ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d3:	eb f7                	jmp    801040cc <argstr+0x2a>

801040d5 <syscall>:
[SYS_ps]		sys_ps,
};

void
syscall(void)
{
801040d5:	55                   	push   %ebp
801040d6:	89 e5                	mov    %esp,%ebp
801040d8:	53                   	push   %ebx
801040d9:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801040dc:	e8 cf f1 ff ff       	call   801032b0 <myproc>
801040e1:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801040e3:	8b 40 18             	mov    0x18(%eax),%eax
801040e6:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040e9:	8d 50 ff             	lea    -0x1(%eax),%edx
801040ec:	83 fa 16             	cmp    $0x16,%edx
801040ef:	77 17                	ja     80104108 <syscall+0x33>
801040f1:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
801040f8:	85 d2                	test   %edx,%edx
801040fa:	74 0c                	je     80104108 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
801040fc:	ff d2                	call   *%edx
801040fe:	89 c2                	mov    %eax,%edx
80104100:	8b 43 18             	mov    0x18(%ebx),%eax
80104103:	89 50 1c             	mov    %edx,0x1c(%eax)
80104106:	eb 1f                	jmp    80104127 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104108:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104109:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010410c:	50                   	push   %eax
8010410d:	ff 73 10             	push   0x10(%ebx)
80104110:	68 6d 7c 10 80       	push   $0x80107c6d
80104115:	e8 e7 c4 ff ff       	call   80100601 <cprintf>
    curproc->tf->eax = -1;
8010411a:	8b 43 18             	mov    0x18(%ebx),%eax
8010411d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104124:	83 c4 10             	add    $0x10,%esp
  }
}
80104127:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010412a:	c9                   	leave  
8010412b:	c3                   	ret    

8010412c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010412c:	55                   	push   %ebp
8010412d:	89 e5                	mov    %esp,%ebp
8010412f:	56                   	push   %esi
80104130:	53                   	push   %ebx
80104131:	83 ec 18             	sub    $0x18,%esp
80104134:	89 d6                	mov    %edx,%esi
80104136:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104138:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010413b:	52                   	push   %edx
8010413c:	50                   	push   %eax
8010413d:	e8 dd fe ff ff       	call   8010401f <argint>
80104142:	83 c4 10             	add    $0x10,%esp
80104145:	85 c0                	test   %eax,%eax
80104147:	78 30                	js     80104179 <argfd+0x4d>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104149:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010414d:	77 31                	ja     80104180 <argfd+0x54>
8010414f:	e8 5c f1 ff ff       	call   801032b0 <myproc>
80104154:	89 c2                	mov    %eax,%edx
80104156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104159:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
8010415d:	85 d2                	test   %edx,%edx
8010415f:	74 26                	je     80104187 <argfd+0x5b>
    return -1;
  if(pfd)
80104161:	85 f6                	test   %esi,%esi
80104163:	74 02                	je     80104167 <argfd+0x3b>
    *pfd = fd;
80104165:	89 06                	mov    %eax,(%esi)
  if(pf)
    *pf = f;
  return 0;
80104167:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
8010416c:	85 db                	test   %ebx,%ebx
8010416e:	74 02                	je     80104172 <argfd+0x46>
    *pf = f;
80104170:	89 13                	mov    %edx,(%ebx)
}
80104172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104175:	5b                   	pop    %ebx
80104176:	5e                   	pop    %esi
80104177:	5d                   	pop    %ebp
80104178:	c3                   	ret    
    return -1;
80104179:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010417e:	eb f2                	jmp    80104172 <argfd+0x46>
    return -1;
80104180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104185:	eb eb                	jmp    80104172 <argfd+0x46>
80104187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010418c:	eb e4                	jmp    80104172 <argfd+0x46>

8010418e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010418e:	55                   	push   %ebp
8010418f:	89 e5                	mov    %esp,%ebp
80104191:	53                   	push   %ebx
80104192:	83 ec 04             	sub    $0x4,%esp
80104195:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104197:	e8 14 f1 ff ff       	call   801032b0 <myproc>
8010419c:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010419e:	b8 00 00 00 00       	mov    $0x0,%eax
    if(curproc->ofile[fd] == 0){
801041a3:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041a8:	74 12                	je     801041bc <fdalloc+0x2e>
  for(fd = 0; fd < NOFILE; fd++){
801041aa:	83 c0 01             	add    $0x1,%eax
801041ad:	83 f8 10             	cmp    $0x10,%eax
801041b0:	75 f1                	jne    801041a3 <fdalloc+0x15>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801041b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041ba:	c9                   	leave  
801041bb:	c3                   	ret    
      curproc->ofile[fd] = f;
801041bc:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
801041c0:	eb f5                	jmp    801041b7 <fdalloc+0x29>

801041c2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801041c2:	55                   	push   %ebp
801041c3:	89 e5                	mov    %esp,%ebp
801041c5:	57                   	push   %edi
801041c6:	56                   	push   %esi
801041c7:	53                   	push   %ebx
801041c8:	83 ec 34             	sub    $0x34,%esp
801041cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801041ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801041d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801041d4:	8d 55 da             	lea    -0x26(%ebp),%edx
801041d7:	52                   	push   %edx
801041d8:	50                   	push   %eax
801041d9:	e8 7b da ff ff       	call   80101c59 <nameiparent>
801041de:	89 c6                	mov    %eax,%esi
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	85 c0                	test   %eax,%eax
801041e5:	0f 84 2d 01 00 00    	je     80104318 <create+0x156>
    return 0;
  ilock(dp);
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 bf d2 ff ff       	call   801014b3 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801041f4:	83 c4 0c             	add    $0xc,%esp
801041f7:	6a 00                	push   $0x0
801041f9:	8d 45 da             	lea    -0x26(%ebp),%eax
801041fc:	50                   	push   %eax
801041fd:	56                   	push   %esi
801041fe:	e8 76 d7 ff ff       	call   80101979 <dirlookup>
80104203:	89 c3                	mov    %eax,%ebx
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	85 c0                	test   %eax,%eax
8010420a:	74 3d                	je     80104249 <create+0x87>
    iunlockput(dp);
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	56                   	push   %esi
80104210:	e8 e7 d4 ff ff       	call   801016fc <iunlockput>
    ilock(ip);
80104215:	89 1c 24             	mov    %ebx,(%esp)
80104218:	e8 96 d2 ff ff       	call   801014b3 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010421d:	83 c4 10             	add    $0x10,%esp
80104220:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104225:	75 07                	jne    8010422e <create+0x6c>
80104227:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010422c:	74 11                	je     8010423f <create+0x7d>
      return ip;
    iunlockput(ip);
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	53                   	push   %ebx
80104232:	e8 c5 d4 ff ff       	call   801016fc <iunlockput>
    return 0;
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010423f:	89 d8                	mov    %ebx,%eax
80104241:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104244:	5b                   	pop    %ebx
80104245:	5e                   	pop    %esi
80104246:	5f                   	pop    %edi
80104247:	5d                   	pop    %ebp
80104248:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104249:	83 ec 08             	sub    $0x8,%esp
8010424c:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104250:	50                   	push   %eax
80104251:	ff 36                	push   (%esi)
80104253:	e8 08 d1 ff ff       	call   80101360 <ialloc>
80104258:	89 c3                	mov    %eax,%ebx
8010425a:	83 c4 10             	add    $0x10,%esp
8010425d:	85 c0                	test   %eax,%eax
8010425f:	74 52                	je     801042b3 <create+0xf1>
  ilock(ip);
80104261:	83 ec 0c             	sub    $0xc,%esp
80104264:	50                   	push   %eax
80104265:	e8 49 d2 ff ff       	call   801014b3 <ilock>
  ip->major = major;
8010426a:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
8010426e:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104272:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104276:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010427c:	89 1c 24             	mov    %ebx,(%esp)
8010427f:	e8 85 d1 ff ff       	call   80101409 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104284:	83 c4 10             	add    $0x10,%esp
80104287:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010428c:	74 32                	je     801042c0 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
8010428e:	83 ec 04             	sub    $0x4,%esp
80104291:	ff 73 04             	push   0x4(%ebx)
80104294:	8d 45 da             	lea    -0x26(%ebp),%eax
80104297:	50                   	push   %eax
80104298:	56                   	push   %esi
80104299:	e8 ee d8 ff ff       	call   80101b8c <dirlink>
8010429e:	83 c4 10             	add    $0x10,%esp
801042a1:	85 c0                	test   %eax,%eax
801042a3:	78 66                	js     8010430b <create+0x149>
  iunlockput(dp);
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	56                   	push   %esi
801042a9:	e8 4e d4 ff ff       	call   801016fc <iunlockput>
  return ip;
801042ae:	83 c4 10             	add    $0x10,%esp
801042b1:	eb 8c                	jmp    8010423f <create+0x7d>
    panic("create: ialloc");
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	68 00 7d 10 80       	push   $0x80107d00
801042bb:	e8 80 c0 ff ff       	call   80100340 <panic>
    dp->nlink++;  // for ".."
801042c0:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
801042c5:	83 ec 0c             	sub    $0xc,%esp
801042c8:	56                   	push   %esi
801042c9:	e8 3b d1 ff ff       	call   80101409 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801042ce:	83 c4 0c             	add    $0xc,%esp
801042d1:	ff 73 04             	push   0x4(%ebx)
801042d4:	68 10 7d 10 80       	push   $0x80107d10
801042d9:	53                   	push   %ebx
801042da:	e8 ad d8 ff ff       	call   80101b8c <dirlink>
801042df:	83 c4 10             	add    $0x10,%esp
801042e2:	85 c0                	test   %eax,%eax
801042e4:	78 18                	js     801042fe <create+0x13c>
801042e6:	83 ec 04             	sub    $0x4,%esp
801042e9:	ff 76 04             	push   0x4(%esi)
801042ec:	68 0f 7d 10 80       	push   $0x80107d0f
801042f1:	53                   	push   %ebx
801042f2:	e8 95 d8 ff ff       	call   80101b8c <dirlink>
801042f7:	83 c4 10             	add    $0x10,%esp
801042fa:	85 c0                	test   %eax,%eax
801042fc:	79 90                	jns    8010428e <create+0xcc>
      panic("create dots");
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	68 12 7d 10 80       	push   $0x80107d12
80104306:	e8 35 c0 ff ff       	call   80100340 <panic>
    panic("create: dirlink");
8010430b:	83 ec 0c             	sub    $0xc,%esp
8010430e:	68 1e 7d 10 80       	push   $0x80107d1e
80104313:	e8 28 c0 ff ff       	call   80100340 <panic>
    return 0;
80104318:	89 c3                	mov    %eax,%ebx
8010431a:	e9 20 ff ff ff       	jmp    8010423f <create+0x7d>

8010431f <sys_dup>:
{
8010431f:	55                   	push   %ebp
80104320:	89 e5                	mov    %esp,%ebp
80104322:	56                   	push   %esi
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104327:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010432a:	ba 00 00 00 00       	mov    $0x0,%edx
8010432f:	b8 00 00 00 00       	mov    $0x0,%eax
80104334:	e8 f3 fd ff ff       	call   8010412c <argfd>
80104339:	85 c0                	test   %eax,%eax
8010433b:	78 25                	js     80104362 <sys_dup+0x43>
  if((fd=fdalloc(f)) < 0)
8010433d:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104340:	89 f0                	mov    %esi,%eax
80104342:	e8 47 fe ff ff       	call   8010418e <fdalloc>
80104347:	89 c3                	mov    %eax,%ebx
80104349:	85 c0                	test   %eax,%eax
8010434b:	78 1c                	js     80104369 <sys_dup+0x4a>
  filedup(f);
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	56                   	push   %esi
80104351:	e8 9e c9 ff ff       	call   80100cf4 <filedup>
  return fd;
80104356:	83 c4 10             	add    $0x10,%esp
}
80104359:	89 d8                	mov    %ebx,%eax
8010435b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010435e:	5b                   	pop    %ebx
8010435f:	5e                   	pop    %esi
80104360:	5d                   	pop    %ebp
80104361:	c3                   	ret    
    return -1;
80104362:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104367:	eb f0                	jmp    80104359 <sys_dup+0x3a>
    return -1;
80104369:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010436e:	eb e9                	jmp    80104359 <sys_dup+0x3a>

80104370 <sys_read>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104376:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104379:	ba 00 00 00 00       	mov    $0x0,%edx
8010437e:	b8 00 00 00 00       	mov    $0x0,%eax
80104383:	e8 a4 fd ff ff       	call   8010412c <argfd>
80104388:	85 c0                	test   %eax,%eax
8010438a:	78 43                	js     801043cf <sys_read+0x5f>
8010438c:	83 ec 08             	sub    $0x8,%esp
8010438f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104392:	50                   	push   %eax
80104393:	6a 02                	push   $0x2
80104395:	e8 85 fc ff ff       	call   8010401f <argint>
8010439a:	83 c4 10             	add    $0x10,%esp
8010439d:	85 c0                	test   %eax,%eax
8010439f:	78 35                	js     801043d6 <sys_read+0x66>
801043a1:	83 ec 04             	sub    $0x4,%esp
801043a4:	ff 75 f0             	push   -0x10(%ebp)
801043a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801043aa:	50                   	push   %eax
801043ab:	6a 01                	push   $0x1
801043ad:	e8 93 fc ff ff       	call   80104045 <argptr>
801043b2:	83 c4 10             	add    $0x10,%esp
801043b5:	85 c0                	test   %eax,%eax
801043b7:	78 24                	js     801043dd <sys_read+0x6d>
  return fileread(f, p, n);
801043b9:	83 ec 04             	sub    $0x4,%esp
801043bc:	ff 75 f0             	push   -0x10(%ebp)
801043bf:	ff 75 ec             	push   -0x14(%ebp)
801043c2:	ff 75 f4             	push   -0xc(%ebp)
801043c5:	e8 6b ca ff ff       	call   80100e35 <fileread>
801043ca:	83 c4 10             	add    $0x10,%esp
}
801043cd:	c9                   	leave  
801043ce:	c3                   	ret    
    return -1;
801043cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d4:	eb f7                	jmp    801043cd <sys_read+0x5d>
801043d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043db:	eb f0                	jmp    801043cd <sys_read+0x5d>
801043dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e2:	eb e9                	jmp    801043cd <sys_read+0x5d>

801043e4 <sys_write>:
{
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043ea:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043ed:	ba 00 00 00 00       	mov    $0x0,%edx
801043f2:	b8 00 00 00 00       	mov    $0x0,%eax
801043f7:	e8 30 fd ff ff       	call   8010412c <argfd>
801043fc:	85 c0                	test   %eax,%eax
801043fe:	78 43                	js     80104443 <sys_write+0x5f>
80104400:	83 ec 08             	sub    $0x8,%esp
80104403:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104406:	50                   	push   %eax
80104407:	6a 02                	push   $0x2
80104409:	e8 11 fc ff ff       	call   8010401f <argint>
8010440e:	83 c4 10             	add    $0x10,%esp
80104411:	85 c0                	test   %eax,%eax
80104413:	78 35                	js     8010444a <sys_write+0x66>
80104415:	83 ec 04             	sub    $0x4,%esp
80104418:	ff 75 f0             	push   -0x10(%ebp)
8010441b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010441e:	50                   	push   %eax
8010441f:	6a 01                	push   $0x1
80104421:	e8 1f fc ff ff       	call   80104045 <argptr>
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	85 c0                	test   %eax,%eax
8010442b:	78 24                	js     80104451 <sys_write+0x6d>
  return filewrite(f, p, n);
8010442d:	83 ec 04             	sub    $0x4,%esp
80104430:	ff 75 f0             	push   -0x10(%ebp)
80104433:	ff 75 ec             	push   -0x14(%ebp)
80104436:	ff 75 f4             	push   -0xc(%ebp)
80104439:	e8 7c ca ff ff       	call   80100eba <filewrite>
8010443e:	83 c4 10             	add    $0x10,%esp
}
80104441:	c9                   	leave  
80104442:	c3                   	ret    
    return -1;
80104443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104448:	eb f7                	jmp    80104441 <sys_write+0x5d>
8010444a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010444f:	eb f0                	jmp    80104441 <sys_write+0x5d>
80104451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104456:	eb e9                	jmp    80104441 <sys_write+0x5d>

80104458 <sys_close>:
{
80104458:	55                   	push   %ebp
80104459:	89 e5                	mov    %esp,%ebp
8010445b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010445e:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104461:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104464:	b8 00 00 00 00       	mov    $0x0,%eax
80104469:	e8 be fc ff ff       	call   8010412c <argfd>
8010446e:	85 c0                	test   %eax,%eax
80104470:	78 25                	js     80104497 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104472:	e8 39 ee ff ff       	call   801032b0 <myproc>
80104477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447a:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104481:	00 
  fileclose(f);
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	ff 75 f0             	push   -0x10(%ebp)
80104488:	e8 ac c8 ff ff       	call   80100d39 <fileclose>
  return 0;
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104495:	c9                   	leave  
80104496:	c3                   	ret    
    return -1;
80104497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449c:	eb f7                	jmp    80104495 <sys_close+0x3d>

8010449e <sys_fstat>:
{
8010449e:	55                   	push   %ebp
8010449f:	89 e5                	mov    %esp,%ebp
801044a1:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801044a4:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044a7:	ba 00 00 00 00       	mov    $0x0,%edx
801044ac:	b8 00 00 00 00       	mov    $0x0,%eax
801044b1:	e8 76 fc ff ff       	call   8010412c <argfd>
801044b6:	85 c0                	test   %eax,%eax
801044b8:	78 2a                	js     801044e4 <sys_fstat+0x46>
801044ba:	83 ec 04             	sub    $0x4,%esp
801044bd:	6a 14                	push   $0x14
801044bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044c2:	50                   	push   %eax
801044c3:	6a 01                	push   $0x1
801044c5:	e8 7b fb ff ff       	call   80104045 <argptr>
801044ca:	83 c4 10             	add    $0x10,%esp
801044cd:	85 c0                	test   %eax,%eax
801044cf:	78 1a                	js     801044eb <sys_fstat+0x4d>
  return filestat(f, st);
801044d1:	83 ec 08             	sub    $0x8,%esp
801044d4:	ff 75 f0             	push   -0x10(%ebp)
801044d7:	ff 75 f4             	push   -0xc(%ebp)
801044da:	e8 0f c9 ff ff       	call   80100dee <filestat>
801044df:	83 c4 10             	add    $0x10,%esp
}
801044e2:	c9                   	leave  
801044e3:	c3                   	ret    
    return -1;
801044e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e9:	eb f7                	jmp    801044e2 <sys_fstat+0x44>
801044eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f0:	eb f0                	jmp    801044e2 <sys_fstat+0x44>

801044f2 <sys_link>:
{
801044f2:	55                   	push   %ebp
801044f3:	89 e5                	mov    %esp,%ebp
801044f5:	56                   	push   %esi
801044f6:	53                   	push   %ebx
801044f7:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801044fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801044fd:	50                   	push   %eax
801044fe:	6a 00                	push   $0x0
80104500:	e8 9d fb ff ff       	call   801040a2 <argstr>
80104505:	83 c4 10             	add    $0x10,%esp
80104508:	85 c0                	test   %eax,%eax
8010450a:	0f 88 26 01 00 00    	js     80104636 <sys_link+0x144>
80104510:	83 ec 08             	sub    $0x8,%esp
80104513:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104516:	50                   	push   %eax
80104517:	6a 01                	push   $0x1
80104519:	e8 84 fb ff ff       	call   801040a2 <argstr>
8010451e:	83 c4 10             	add    $0x10,%esp
80104521:	85 c0                	test   %eax,%eax
80104523:	0f 88 14 01 00 00    	js     8010463d <sys_link+0x14b>
  begin_op();
80104529:	e8 50 e2 ff ff       	call   8010277e <begin_op>
  if((ip = namei(old)) == 0){
8010452e:	83 ec 0c             	sub    $0xc,%esp
80104531:	ff 75 e0             	push   -0x20(%ebp)
80104534:	e8 08 d7 ff ff       	call   80101c41 <namei>
80104539:	89 c3                	mov    %eax,%ebx
8010453b:	83 c4 10             	add    $0x10,%esp
8010453e:	85 c0                	test   %eax,%eax
80104540:	0f 84 93 00 00 00    	je     801045d9 <sys_link+0xe7>
  ilock(ip);
80104546:	83 ec 0c             	sub    $0xc,%esp
80104549:	50                   	push   %eax
8010454a:	e8 64 cf ff ff       	call   801014b3 <ilock>
  if(ip->type == T_DIR){
8010454f:	83 c4 10             	add    $0x10,%esp
80104552:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104557:	0f 84 88 00 00 00    	je     801045e5 <sys_link+0xf3>
  ip->nlink++;
8010455d:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104562:	83 ec 0c             	sub    $0xc,%esp
80104565:	53                   	push   %ebx
80104566:	e8 9e ce ff ff       	call   80101409 <iupdate>
  iunlock(ip);
8010456b:	89 1c 24             	mov    %ebx,(%esp)
8010456e:	e8 02 d0 ff ff       	call   80101575 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104573:	83 c4 08             	add    $0x8,%esp
80104576:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104579:	50                   	push   %eax
8010457a:	ff 75 e4             	push   -0x1c(%ebp)
8010457d:	e8 d7 d6 ff ff       	call   80101c59 <nameiparent>
80104582:	89 c6                	mov    %eax,%esi
80104584:	83 c4 10             	add    $0x10,%esp
80104587:	85 c0                	test   %eax,%eax
80104589:	74 7e                	je     80104609 <sys_link+0x117>
  ilock(dp);
8010458b:	83 ec 0c             	sub    $0xc,%esp
8010458e:	50                   	push   %eax
8010458f:	e8 1f cf ff ff       	call   801014b3 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104594:	83 c4 10             	add    $0x10,%esp
80104597:	8b 03                	mov    (%ebx),%eax
80104599:	39 06                	cmp    %eax,(%esi)
8010459b:	75 60                	jne    801045fd <sys_link+0x10b>
8010459d:	83 ec 04             	sub    $0x4,%esp
801045a0:	ff 73 04             	push   0x4(%ebx)
801045a3:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045a6:	50                   	push   %eax
801045a7:	56                   	push   %esi
801045a8:	e8 df d5 ff ff       	call   80101b8c <dirlink>
801045ad:	83 c4 10             	add    $0x10,%esp
801045b0:	85 c0                	test   %eax,%eax
801045b2:	78 49                	js     801045fd <sys_link+0x10b>
  iunlockput(dp);
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	56                   	push   %esi
801045b8:	e8 3f d1 ff ff       	call   801016fc <iunlockput>
  iput(ip);
801045bd:	89 1c 24             	mov    %ebx,(%esp)
801045c0:	e8 f5 cf ff ff       	call   801015ba <iput>
  end_op();
801045c5:	e8 2f e2 ff ff       	call   801027f9 <end_op>
  return 0;
801045ca:	83 c4 10             	add    $0x10,%esp
801045cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d5:	5b                   	pop    %ebx
801045d6:	5e                   	pop    %esi
801045d7:	5d                   	pop    %ebp
801045d8:	c3                   	ret    
    end_op();
801045d9:	e8 1b e2 ff ff       	call   801027f9 <end_op>
    return -1;
801045de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045e3:	eb ed                	jmp    801045d2 <sys_link+0xe0>
    iunlockput(ip);
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	53                   	push   %ebx
801045e9:	e8 0e d1 ff ff       	call   801016fc <iunlockput>
    end_op();
801045ee:	e8 06 e2 ff ff       	call   801027f9 <end_op>
    return -1;
801045f3:	83 c4 10             	add    $0x10,%esp
801045f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fb:	eb d5                	jmp    801045d2 <sys_link+0xe0>
    iunlockput(dp);
801045fd:	83 ec 0c             	sub    $0xc,%esp
80104600:	56                   	push   %esi
80104601:	e8 f6 d0 ff ff       	call   801016fc <iunlockput>
    goto bad;
80104606:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	53                   	push   %ebx
8010460d:	e8 a1 ce ff ff       	call   801014b3 <ilock>
  ip->nlink--;
80104612:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104617:	89 1c 24             	mov    %ebx,(%esp)
8010461a:	e8 ea cd ff ff       	call   80101409 <iupdate>
  iunlockput(ip);
8010461f:	89 1c 24             	mov    %ebx,(%esp)
80104622:	e8 d5 d0 ff ff       	call   801016fc <iunlockput>
  end_op();
80104627:	e8 cd e1 ff ff       	call   801027f9 <end_op>
  return -1;
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104634:	eb 9c                	jmp    801045d2 <sys_link+0xe0>
    return -1;
80104636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463b:	eb 95                	jmp    801045d2 <sys_link+0xe0>
8010463d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104642:	eb 8e                	jmp    801045d2 <sys_link+0xe0>

80104644 <sys_unlink>:
{
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	57                   	push   %edi
80104648:	56                   	push   %esi
80104649:	53                   	push   %ebx
8010464a:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010464d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104650:	50                   	push   %eax
80104651:	6a 00                	push   $0x0
80104653:	e8 4a fa ff ff       	call   801040a2 <argstr>
80104658:	83 c4 10             	add    $0x10,%esp
8010465b:	85 c0                	test   %eax,%eax
8010465d:	0f 88 81 01 00 00    	js     801047e4 <sys_unlink+0x1a0>
  begin_op();
80104663:	e8 16 e1 ff ff       	call   8010277e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104668:	83 ec 08             	sub    $0x8,%esp
8010466b:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010466e:	50                   	push   %eax
8010466f:	ff 75 c4             	push   -0x3c(%ebp)
80104672:	e8 e2 d5 ff ff       	call   80101c59 <nameiparent>
80104677:	89 c7                	mov    %eax,%edi
80104679:	83 c4 10             	add    $0x10,%esp
8010467c:	85 c0                	test   %eax,%eax
8010467e:	0f 84 df 00 00 00    	je     80104763 <sys_unlink+0x11f>
  ilock(dp);
80104684:	83 ec 0c             	sub    $0xc,%esp
80104687:	50                   	push   %eax
80104688:	e8 26 ce ff ff       	call   801014b3 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010468d:	83 c4 08             	add    $0x8,%esp
80104690:	68 10 7d 10 80       	push   $0x80107d10
80104695:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104698:	50                   	push   %eax
80104699:	e8 c6 d2 ff ff       	call   80101964 <namecmp>
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	85 c0                	test   %eax,%eax
801046a3:	0f 84 51 01 00 00    	je     801047fa <sys_unlink+0x1b6>
801046a9:	83 ec 08             	sub    $0x8,%esp
801046ac:	68 0f 7d 10 80       	push   $0x80107d0f
801046b1:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046b4:	50                   	push   %eax
801046b5:	e8 aa d2 ff ff       	call   80101964 <namecmp>
801046ba:	83 c4 10             	add    $0x10,%esp
801046bd:	85 c0                	test   %eax,%eax
801046bf:	0f 84 35 01 00 00    	je     801047fa <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
801046c5:	83 ec 04             	sub    $0x4,%esp
801046c8:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046cb:	50                   	push   %eax
801046cc:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046cf:	50                   	push   %eax
801046d0:	57                   	push   %edi
801046d1:	e8 a3 d2 ff ff       	call   80101979 <dirlookup>
801046d6:	89 c3                	mov    %eax,%ebx
801046d8:	83 c4 10             	add    $0x10,%esp
801046db:	85 c0                	test   %eax,%eax
801046dd:	0f 84 17 01 00 00    	je     801047fa <sys_unlink+0x1b6>
  ilock(ip);
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	50                   	push   %eax
801046e7:	e8 c7 cd ff ff       	call   801014b3 <ilock>
  if(ip->nlink < 1)
801046ec:	83 c4 10             	add    $0x10,%esp
801046ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801046f4:	7e 79                	jle    8010476f <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
801046f6:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801046fb:	74 7f                	je     8010477c <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
801046fd:	83 ec 04             	sub    $0x4,%esp
80104700:	6a 10                	push   $0x10
80104702:	6a 00                	push   $0x0
80104704:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104707:	56                   	push   %esi
80104708:	e8 a2 f6 ff ff       	call   80103daf <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010470d:	6a 10                	push   $0x10
8010470f:	ff 75 c0             	push   -0x40(%ebp)
80104712:	56                   	push   %esi
80104713:	57                   	push   %edi
80104714:	e8 2a d1 ff ff       	call   80101843 <writei>
80104719:	83 c4 20             	add    $0x20,%esp
8010471c:	83 f8 10             	cmp    $0x10,%eax
8010471f:	0f 85 9c 00 00 00    	jne    801047c1 <sys_unlink+0x17d>
  if(ip->type == T_DIR){
80104725:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010472a:	0f 84 9e 00 00 00    	je     801047ce <sys_unlink+0x18a>
  iunlockput(dp);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	57                   	push   %edi
80104734:	e8 c3 cf ff ff       	call   801016fc <iunlockput>
  ip->nlink--;
80104739:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010473e:	89 1c 24             	mov    %ebx,(%esp)
80104741:	e8 c3 cc ff ff       	call   80101409 <iupdate>
  iunlockput(ip);
80104746:	89 1c 24             	mov    %ebx,(%esp)
80104749:	e8 ae cf ff ff       	call   801016fc <iunlockput>
  end_op();
8010474e:	e8 a6 e0 ff ff       	call   801027f9 <end_op>
  return 0;
80104753:	83 c4 10             	add    $0x10,%esp
80104756:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010475b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475e:	5b                   	pop    %ebx
8010475f:	5e                   	pop    %esi
80104760:	5f                   	pop    %edi
80104761:	5d                   	pop    %ebp
80104762:	c3                   	ret    
    end_op();
80104763:	e8 91 e0 ff ff       	call   801027f9 <end_op>
    return -1;
80104768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476d:	eb ec                	jmp    8010475b <sys_unlink+0x117>
    panic("unlink: nlink < 1");
8010476f:	83 ec 0c             	sub    $0xc,%esp
80104772:	68 2e 7d 10 80       	push   $0x80107d2e
80104777:	e8 c4 bb ff ff       	call   80100340 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010477c:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104780:	0f 86 77 ff ff ff    	jbe    801046fd <sys_unlink+0xb9>
80104786:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010478b:	6a 10                	push   $0x10
8010478d:	56                   	push   %esi
8010478e:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104791:	50                   	push   %eax
80104792:	53                   	push   %ebx
80104793:	e8 af cf ff ff       	call   80101747 <readi>
80104798:	83 c4 10             	add    $0x10,%esp
8010479b:	83 f8 10             	cmp    $0x10,%eax
8010479e:	75 14                	jne    801047b4 <sys_unlink+0x170>
    if(de.inum != 0)
801047a0:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
801047a5:	75 47                	jne    801047ee <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801047a7:	83 c6 10             	add    $0x10,%esi
801047aa:	3b 73 58             	cmp    0x58(%ebx),%esi
801047ad:	72 dc                	jb     8010478b <sys_unlink+0x147>
801047af:	e9 49 ff ff ff       	jmp    801046fd <sys_unlink+0xb9>
      panic("isdirempty: readi");
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 40 7d 10 80       	push   $0x80107d40
801047bc:	e8 7f bb ff ff       	call   80100340 <panic>
    panic("unlink: writei");
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 52 7d 10 80       	push   $0x80107d52
801047c9:	e8 72 bb ff ff       	call   80100340 <panic>
    dp->nlink--;
801047ce:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	57                   	push   %edi
801047d7:	e8 2d cc ff ff       	call   80101409 <iupdate>
801047dc:	83 c4 10             	add    $0x10,%esp
801047df:	e9 4c ff ff ff       	jmp    80104730 <sys_unlink+0xec>
    return -1;
801047e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047e9:	e9 6d ff ff ff       	jmp    8010475b <sys_unlink+0x117>
    iunlockput(ip);
801047ee:	83 ec 0c             	sub    $0xc,%esp
801047f1:	53                   	push   %ebx
801047f2:	e8 05 cf ff ff       	call   801016fc <iunlockput>
    goto bad;
801047f7:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801047fa:	83 ec 0c             	sub    $0xc,%esp
801047fd:	57                   	push   %edi
801047fe:	e8 f9 ce ff ff       	call   801016fc <iunlockput>
  end_op();
80104803:	e8 f1 df ff ff       	call   801027f9 <end_op>
  return -1;
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104810:	e9 46 ff ff ff       	jmp    8010475b <sys_unlink+0x117>

80104815 <sys_open>:

int
sys_open(void)
{
80104815:	55                   	push   %ebp
80104816:	89 e5                	mov    %esp,%ebp
80104818:	57                   	push   %edi
80104819:	56                   	push   %esi
8010481a:	53                   	push   %ebx
8010481b:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010481e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104821:	50                   	push   %eax
80104822:	6a 00                	push   $0x0
80104824:	e8 79 f8 ff ff       	call   801040a2 <argstr>
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	0f 88 0b 01 00 00    	js     8010493f <sys_open+0x12a>
80104834:	83 ec 08             	sub    $0x8,%esp
80104837:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010483a:	50                   	push   %eax
8010483b:	6a 01                	push   $0x1
8010483d:	e8 dd f7 ff ff       	call   8010401f <argint>
80104842:	83 c4 10             	add    $0x10,%esp
80104845:	85 c0                	test   %eax,%eax
80104847:	0f 88 f9 00 00 00    	js     80104946 <sys_open+0x131>
    return -1;

  begin_op();
8010484d:	e8 2c df ff ff       	call   8010277e <begin_op>

  if(omode & O_CREATE){
80104852:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104856:	0f 84 8a 00 00 00    	je     801048e6 <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	6a 00                	push   $0x0
80104861:	b9 00 00 00 00       	mov    $0x0,%ecx
80104866:	ba 02 00 00 00       	mov    $0x2,%edx
8010486b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010486e:	e8 4f f9 ff ff       	call   801041c2 <create>
80104873:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104875:	83 c4 10             	add    $0x10,%esp
80104878:	85 c0                	test   %eax,%eax
8010487a:	74 5e                	je     801048da <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010487c:	e8 14 c4 ff ff       	call   80100c95 <filealloc>
80104881:	89 c3                	mov    %eax,%ebx
80104883:	85 c0                	test   %eax,%eax
80104885:	0f 84 ce 00 00 00    	je     80104959 <sys_open+0x144>
8010488b:	e8 fe f8 ff ff       	call   8010418e <fdalloc>
80104890:	89 c7                	mov    %eax,%edi
80104892:	85 c0                	test   %eax,%eax
80104894:	0f 88 b3 00 00 00    	js     8010494d <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	56                   	push   %esi
8010489e:	e8 d2 cc ff ff       	call   80101575 <iunlock>
  end_op();
801048a3:	e8 51 df ff ff       	call   801027f9 <end_op>

  f->type = FD_INODE;
801048a8:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801048ae:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801048b1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801048b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048bb:	89 d0                	mov    %edx,%eax
801048bd:	83 f0 01             	xor    $0x1,%eax
801048c0:	83 e0 01             	and    $0x1,%eax
801048c3:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801048c6:	83 c4 10             	add    $0x10,%esp
801048c9:	f6 c2 03             	test   $0x3,%dl
801048cc:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801048d0:	89 f8                	mov    %edi,%eax
801048d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048d5:	5b                   	pop    %ebx
801048d6:	5e                   	pop    %esi
801048d7:	5f                   	pop    %edi
801048d8:	5d                   	pop    %ebp
801048d9:	c3                   	ret    
      end_op();
801048da:	e8 1a df ff ff       	call   801027f9 <end_op>
      return -1;
801048df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048e4:	eb ea                	jmp    801048d0 <sys_open+0xbb>
    if((ip = namei(path)) == 0){
801048e6:	83 ec 0c             	sub    $0xc,%esp
801048e9:	ff 75 e4             	push   -0x1c(%ebp)
801048ec:	e8 50 d3 ff ff       	call   80101c41 <namei>
801048f1:	89 c6                	mov    %eax,%esi
801048f3:	83 c4 10             	add    $0x10,%esp
801048f6:	85 c0                	test   %eax,%eax
801048f8:	74 39                	je     80104933 <sys_open+0x11e>
    ilock(ip);
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	50                   	push   %eax
801048fe:	e8 b0 cb ff ff       	call   801014b3 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104903:	83 c4 10             	add    $0x10,%esp
80104906:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010490b:	0f 85 6b ff ff ff    	jne    8010487c <sys_open+0x67>
80104911:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104915:	0f 84 61 ff ff ff    	je     8010487c <sys_open+0x67>
      iunlockput(ip);
8010491b:	83 ec 0c             	sub    $0xc,%esp
8010491e:	56                   	push   %esi
8010491f:	e8 d8 cd ff ff       	call   801016fc <iunlockput>
      end_op();
80104924:	e8 d0 de ff ff       	call   801027f9 <end_op>
      return -1;
80104929:	83 c4 10             	add    $0x10,%esp
8010492c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104931:	eb 9d                	jmp    801048d0 <sys_open+0xbb>
      end_op();
80104933:	e8 c1 de ff ff       	call   801027f9 <end_op>
      return -1;
80104938:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010493d:	eb 91                	jmp    801048d0 <sys_open+0xbb>
    return -1;
8010493f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104944:	eb 8a                	jmp    801048d0 <sys_open+0xbb>
80104946:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010494b:	eb 83                	jmp    801048d0 <sys_open+0xbb>
      fileclose(f);
8010494d:	83 ec 0c             	sub    $0xc,%esp
80104950:	53                   	push   %ebx
80104951:	e8 e3 c3 ff ff       	call   80100d39 <fileclose>
80104956:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104959:	83 ec 0c             	sub    $0xc,%esp
8010495c:	56                   	push   %esi
8010495d:	e8 9a cd ff ff       	call   801016fc <iunlockput>
    end_op();
80104962:	e8 92 de ff ff       	call   801027f9 <end_op>
    return -1;
80104967:	83 c4 10             	add    $0x10,%esp
8010496a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010496f:	e9 5c ff ff ff       	jmp    801048d0 <sys_open+0xbb>

80104974 <sys_mkdir>:

int
sys_mkdir(void)
{
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010497a:	e8 ff dd ff ff       	call   8010277e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010497f:	83 ec 08             	sub    $0x8,%esp
80104982:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104985:	50                   	push   %eax
80104986:	6a 00                	push   $0x0
80104988:	e8 15 f7 ff ff       	call   801040a2 <argstr>
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	85 c0                	test   %eax,%eax
80104992:	78 36                	js     801049ca <sys_mkdir+0x56>
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	6a 00                	push   $0x0
80104999:	b9 00 00 00 00       	mov    $0x0,%ecx
8010499e:	ba 01 00 00 00       	mov    $0x1,%edx
801049a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a6:	e8 17 f8 ff ff       	call   801041c2 <create>
801049ab:	83 c4 10             	add    $0x10,%esp
801049ae:	85 c0                	test   %eax,%eax
801049b0:	74 18                	je     801049ca <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049b2:	83 ec 0c             	sub    $0xc,%esp
801049b5:	50                   	push   %eax
801049b6:	e8 41 cd ff ff       	call   801016fc <iunlockput>
  end_op();
801049bb:	e8 39 de ff ff       	call   801027f9 <end_op>
  return 0;
801049c0:	83 c4 10             	add    $0x10,%esp
801049c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049c8:	c9                   	leave  
801049c9:	c3                   	ret    
    end_op();
801049ca:	e8 2a de ff ff       	call   801027f9 <end_op>
    return -1;
801049cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d4:	eb f2                	jmp    801049c8 <sys_mkdir+0x54>

801049d6 <sys_mknod>:

int
sys_mknod(void)
{
801049d6:	55                   	push   %ebp
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801049dc:	e8 9d dd ff ff       	call   8010277e <begin_op>
  if((argstr(0, &path)) < 0 ||
801049e1:	83 ec 08             	sub    $0x8,%esp
801049e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049e7:	50                   	push   %eax
801049e8:	6a 00                	push   $0x0
801049ea:	e8 b3 f6 ff ff       	call   801040a2 <argstr>
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	85 c0                	test   %eax,%eax
801049f4:	78 62                	js     80104a58 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
801049f6:	83 ec 08             	sub    $0x8,%esp
801049f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049fc:	50                   	push   %eax
801049fd:	6a 01                	push   $0x1
801049ff:	e8 1b f6 ff ff       	call   8010401f <argint>
  if((argstr(0, &path)) < 0 ||
80104a04:	83 c4 10             	add    $0x10,%esp
80104a07:	85 c0                	test   %eax,%eax
80104a09:	78 4d                	js     80104a58 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104a0b:	83 ec 08             	sub    $0x8,%esp
80104a0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a11:	50                   	push   %eax
80104a12:	6a 02                	push   $0x2
80104a14:	e8 06 f6 ff ff       	call   8010401f <argint>
     argint(1, &major) < 0 ||
80104a19:	83 c4 10             	add    $0x10,%esp
80104a1c:	85 c0                	test   %eax,%eax
80104a1e:	78 38                	js     80104a58 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104a20:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a2b:	50                   	push   %eax
80104a2c:	ba 03 00 00 00       	mov    $0x3,%edx
80104a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a34:	e8 89 f7 ff ff       	call   801041c2 <create>
     argint(2, &minor) < 0 ||
80104a39:	83 c4 10             	add    $0x10,%esp
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	74 18                	je     80104a58 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a40:	83 ec 0c             	sub    $0xc,%esp
80104a43:	50                   	push   %eax
80104a44:	e8 b3 cc ff ff       	call   801016fc <iunlockput>
  end_op();
80104a49:	e8 ab dd ff ff       	call   801027f9 <end_op>
  return 0;
80104a4e:	83 c4 10             	add    $0x10,%esp
80104a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a56:	c9                   	leave  
80104a57:	c3                   	ret    
    end_op();
80104a58:	e8 9c dd ff ff       	call   801027f9 <end_op>
    return -1;
80104a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a62:	eb f2                	jmp    80104a56 <sys_mknod+0x80>

80104a64 <sys_chdir>:

int
sys_chdir(void)
{
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	53                   	push   %ebx
80104a69:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104a6c:	e8 3f e8 ff ff       	call   801032b0 <myproc>
80104a71:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104a73:	e8 06 dd ff ff       	call   8010277e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104a78:	83 ec 08             	sub    $0x8,%esp
80104a7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a7e:	50                   	push   %eax
80104a7f:	6a 00                	push   $0x0
80104a81:	e8 1c f6 ff ff       	call   801040a2 <argstr>
80104a86:	83 c4 10             	add    $0x10,%esp
80104a89:	85 c0                	test   %eax,%eax
80104a8b:	78 52                	js     80104adf <sys_chdir+0x7b>
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	ff 75 f4             	push   -0xc(%ebp)
80104a93:	e8 a9 d1 ff ff       	call   80101c41 <namei>
80104a98:	89 c3                	mov    %eax,%ebx
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	85 c0                	test   %eax,%eax
80104a9f:	74 3e                	je     80104adf <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104aa1:	83 ec 0c             	sub    $0xc,%esp
80104aa4:	50                   	push   %eax
80104aa5:	e8 09 ca ff ff       	call   801014b3 <ilock>
  if(ip->type != T_DIR){
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ab2:	75 37                	jne    80104aeb <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ab4:	83 ec 0c             	sub    $0xc,%esp
80104ab7:	53                   	push   %ebx
80104ab8:	e8 b8 ca ff ff       	call   80101575 <iunlock>
  iput(curproc->cwd);
80104abd:	83 c4 04             	add    $0x4,%esp
80104ac0:	ff 76 68             	push   0x68(%esi)
80104ac3:	e8 f2 ca ff ff       	call   801015ba <iput>
  end_op();
80104ac8:	e8 2c dd ff ff       	call   801027f9 <end_op>
  curproc->cwd = ip;
80104acd:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104ad0:	83 c4 10             	add    $0x10,%esp
80104ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104adb:	5b                   	pop    %ebx
80104adc:	5e                   	pop    %esi
80104add:	5d                   	pop    %ebp
80104ade:	c3                   	ret    
    end_op();
80104adf:	e8 15 dd ff ff       	call   801027f9 <end_op>
    return -1;
80104ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae9:	eb ed                	jmp    80104ad8 <sys_chdir+0x74>
    iunlockput(ip);
80104aeb:	83 ec 0c             	sub    $0xc,%esp
80104aee:	53                   	push   %ebx
80104aef:	e8 08 cc ff ff       	call   801016fc <iunlockput>
    end_op();
80104af4:	e8 00 dd ff ff       	call   801027f9 <end_op>
    return -1;
80104af9:	83 c4 10             	add    $0x10,%esp
80104afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b01:	eb d5                	jmp    80104ad8 <sys_chdir+0x74>

80104b03 <sys_exec>:

int
sys_exec(void)
{
80104b03:	55                   	push   %ebp
80104b04:	89 e5                	mov    %esp,%ebp
80104b06:	57                   	push   %edi
80104b07:	56                   	push   %esi
80104b08:	53                   	push   %ebx
80104b09:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b0f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104b12:	50                   	push   %eax
80104b13:	6a 00                	push   $0x0
80104b15:	e8 88 f5 ff ff       	call   801040a2 <argstr>
80104b1a:	83 c4 10             	add    $0x10,%esp
80104b1d:	85 c0                	test   %eax,%eax
80104b1f:	0f 88 ba 00 00 00    	js     80104bdf <sys_exec+0xdc>
80104b25:	83 ec 08             	sub    $0x8,%esp
80104b28:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104b2e:	50                   	push   %eax
80104b2f:	6a 01                	push   $0x1
80104b31:	e8 e9 f4 ff ff       	call   8010401f <argint>
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 c0                	test   %eax,%eax
80104b3b:	0f 88 a5 00 00 00    	js     80104be6 <sys_exec+0xe3>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b41:	83 ec 04             	sub    $0x4,%esp
80104b44:	68 80 00 00 00       	push   $0x80
80104b49:	6a 00                	push   $0x0
80104b4b:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104b51:	50                   	push   %eax
80104b52:	e8 58 f2 ff ff       	call   80103daf <memset>
80104b57:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b5a:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104b5f:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104b65:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80104b6c:	83 ec 08             	sub    $0x8,%esp
80104b6f:	57                   	push   %edi
80104b70:	89 d8                	mov    %ebx,%eax
80104b72:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80104b78:	50                   	push   %eax
80104b79:	e8 1e f4 ff ff       	call   80103f9c <fetchint>
80104b7e:	83 c4 10             	add    $0x10,%esp
80104b81:	85 c0                	test   %eax,%eax
80104b83:	78 68                	js     80104bed <sys_exec+0xea>
      return -1;
    if(uarg == 0){
80104b85:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	74 2e                	je     80104bbd <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104b8f:	83 ec 08             	sub    $0x8,%esp
80104b92:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80104b98:	01 d3                	add    %edx,%ebx
80104b9a:	53                   	push   %ebx
80104b9b:	50                   	push   %eax
80104b9c:	e8 36 f4 ff ff       	call   80103fd7 <fetchstr>
80104ba1:	83 c4 10             	add    $0x10,%esp
80104ba4:	85 c0                	test   %eax,%eax
80104ba6:	78 4c                	js     80104bf4 <sys_exec+0xf1>
  for(i=0;; i++){
80104ba8:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80104bab:	83 fe 20             	cmp    $0x20,%esi
80104bae:	75 b5                	jne    80104b65 <sys_exec+0x62>
      return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb8:	5b                   	pop    %ebx
80104bb9:	5e                   	pop    %esi
80104bba:	5f                   	pop    %edi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
      argv[i] = 0;
80104bbd:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80104bc4:	00 00 00 00 
  return exec(path, argv);
80104bc8:	83 ec 08             	sub    $0x8,%esp
80104bcb:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104bd1:	50                   	push   %eax
80104bd2:	ff 75 e4             	push   -0x1c(%ebp)
80104bd5:	e8 5c bd ff ff       	call   80100936 <exec>
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	eb d6                	jmp    80104bb5 <sys_exec+0xb2>
    return -1;
80104bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be4:	eb cf                	jmp    80104bb5 <sys_exec+0xb2>
80104be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104beb:	eb c8                	jmp    80104bb5 <sys_exec+0xb2>
      return -1;
80104bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf2:	eb c1                	jmp    80104bb5 <sys_exec+0xb2>
      return -1;
80104bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf9:	eb ba                	jmp    80104bb5 <sys_exec+0xb2>

80104bfb <sys_pipe>:

int
sys_pipe(void)
{
80104bfb:	55                   	push   %ebp
80104bfc:	89 e5                	mov    %esp,%ebp
80104bfe:	53                   	push   %ebx
80104bff:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c02:	6a 08                	push   $0x8
80104c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c07:	50                   	push   %eax
80104c08:	6a 00                	push   $0x0
80104c0a:	e8 36 f4 ff ff       	call   80104045 <argptr>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 46                	js     80104c5c <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c16:	83 ec 08             	sub    $0x8,%esp
80104c19:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c1c:	50                   	push   %eax
80104c1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c20:	50                   	push   %eax
80104c21:	e8 7c e1 ff ff       	call   80102da2 <pipealloc>
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	78 36                	js     80104c63 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c30:	e8 59 f5 ff ff       	call   8010418e <fdalloc>
80104c35:	89 c3                	mov    %eax,%ebx
80104c37:	85 c0                	test   %eax,%eax
80104c39:	78 3c                	js     80104c77 <sys_pipe+0x7c>
80104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3e:	e8 4b f5 ff ff       	call   8010418e <fdalloc>
80104c43:	85 c0                	test   %eax,%eax
80104c45:	78 23                	js     80104c6a <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c4f:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
    return -1;
80104c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c61:	eb f4                	jmp    80104c57 <sys_pipe+0x5c>
    return -1;
80104c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c68:	eb ed                	jmp    80104c57 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104c6a:	e8 41 e6 ff ff       	call   801032b0 <myproc>
80104c6f:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104c76:	00 
    fileclose(rf);
80104c77:	83 ec 0c             	sub    $0xc,%esp
80104c7a:	ff 75 f0             	push   -0x10(%ebp)
80104c7d:	e8 b7 c0 ff ff       	call   80100d39 <fileclose>
    fileclose(wf);
80104c82:	83 c4 04             	add    $0x4,%esp
80104c85:	ff 75 ec             	push   -0x14(%ebp)
80104c88:	e8 ac c0 ff ff       	call   80100d39 <fileclose>
    return -1;
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c95:	eb c0                	jmp    80104c57 <sys_pipe+0x5c>

80104c97 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104c97:	55                   	push   %ebp
80104c98:	89 e5                	mov    %esp,%ebp
80104c9a:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104c9d:	e8 83 e7 ff ff       	call   80103425 <fork>
}
80104ca2:	c9                   	leave  
80104ca3:	c3                   	ret    

80104ca4 <sys_exit>:

int
sys_exit(void)
{
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	83 ec 08             	sub    $0x8,%esp
  exit();
80104caa:	e8 b1 e9 ff ff       	call   80103660 <exit>
  return 0;  // not reached
}
80104caf:	b8 00 00 00 00       	mov    $0x0,%eax
80104cb4:	c9                   	leave  
80104cb5:	c3                   	ret    

80104cb6 <sys_wait>:

int
sys_wait(void)
{
80104cb6:	55                   	push   %ebp
80104cb7:	89 e5                	mov    %esp,%ebp
80104cb9:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104cbc:	e8 38 eb ff ff       	call   801037f9 <wait>
}
80104cc1:	c9                   	leave  
80104cc2:	c3                   	ret    

80104cc3 <sys_kill>:

int
sys_kill(void)
{
80104cc3:	55                   	push   %ebp
80104cc4:	89 e5                	mov    %esp,%ebp
80104cc6:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104cc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ccc:	50                   	push   %eax
80104ccd:	6a 00                	push   $0x0
80104ccf:	e8 4b f3 ff ff       	call   8010401f <argint>
80104cd4:	83 c4 10             	add    $0x10,%esp
80104cd7:	85 c0                	test   %eax,%eax
80104cd9:	78 10                	js     80104ceb <sys_kill+0x28>
    return -1;
  return kill(pid);
80104cdb:	83 ec 0c             	sub    $0xc,%esp
80104cde:	ff 75 f4             	push   -0xc(%ebp)
80104ce1:	e8 1a ec ff ff       	call   80103900 <kill>
80104ce6:	83 c4 10             	add    $0x10,%esp
}
80104ce9:	c9                   	leave  
80104cea:	c3                   	ret    
    return -1;
80104ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf0:	eb f7                	jmp    80104ce9 <sys_kill+0x26>

80104cf2 <sys_getpid>:

int
sys_getpid(void)
{
80104cf2:	55                   	push   %ebp
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104cf8:	e8 b3 e5 ff ff       	call   801032b0 <myproc>
80104cfd:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d00:	c9                   	leave  
80104d01:	c3                   	ret    

80104d02 <sys_sbrk>:

int
sys_sbrk(void)
{
80104d02:	55                   	push   %ebp
80104d03:	89 e5                	mov    %esp,%ebp
80104d05:	53                   	push   %ebx
80104d06:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0c:	50                   	push   %eax
80104d0d:	6a 00                	push   $0x0
80104d0f:	e8 0b f3 ff ff       	call   8010401f <argint>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	78 26                	js     80104d41 <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
80104d1b:	e8 90 e5 ff ff       	call   801032b0 <myproc>
80104d20:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	ff 75 f4             	push   -0xc(%ebp)
80104d28:	e8 8d e6 ff ff       	call   801033ba <growproc>
80104d2d:	83 c4 10             	add    $0x10,%esp
    return -1;
80104d30:	85 c0                	test   %eax,%eax
80104d32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d37:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80104d3a:	89 d8                	mov    %ebx,%eax
80104d3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d3f:	c9                   	leave  
80104d40:	c3                   	ret    
    return -1;
80104d41:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d46:	eb f2                	jmp    80104d3a <sys_sbrk+0x38>

80104d48 <sys_sleep>:

int
sys_sleep(void)
{
80104d48:	55                   	push   %ebp
80104d49:	89 e5                	mov    %esp,%ebp
80104d4b:	53                   	push   %ebx
80104d4c:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104d4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d52:	50                   	push   %eax
80104d53:	6a 00                	push   $0x0
80104d55:	e8 c5 f2 ff ff       	call   8010401f <argint>
80104d5a:	83 c4 10             	add    $0x10,%esp
80104d5d:	85 c0                	test   %eax,%eax
80104d5f:	78 79                	js     80104dda <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104d61:	83 ec 0c             	sub    $0xc,%esp
80104d64:	68 c0 35 11 80       	push   $0x801135c0
80104d69:	e8 93 ef ff ff       	call   80103d01 <acquire>
  ticks0 = ticks;
80104d6e:	8b 1d a0 35 11 80    	mov    0x801135a0,%ebx
  while(ticks - ticks0 < n){
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d7b:	74 2c                	je     80104da9 <sys_sleep+0x61>
    if(myproc()->killed){
80104d7d:	e8 2e e5 ff ff       	call   801032b0 <myproc>
80104d82:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104d86:	75 3b                	jne    80104dc3 <sys_sleep+0x7b>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104d88:	83 ec 08             	sub    $0x8,%esp
80104d8b:	68 c0 35 11 80       	push   $0x801135c0
80104d90:	68 a0 35 11 80       	push   $0x801135a0
80104d95:	e8 bf e9 ff ff       	call   80103759 <sleep>
  while(ticks - ticks0 < n){
80104d9a:	a1 a0 35 11 80       	mov    0x801135a0,%eax
80104d9f:	29 d8                	sub    %ebx,%eax
80104da1:	83 c4 10             	add    $0x10,%esp
80104da4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104da7:	72 d4                	jb     80104d7d <sys_sleep+0x35>
  }
  release(&tickslock);
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	68 c0 35 11 80       	push   $0x801135c0
80104db1:	e8 b2 ef ff ff       	call   80103d68 <release>
  return 0;
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc1:	c9                   	leave  
80104dc2:	c3                   	ret    
      release(&tickslock);
80104dc3:	83 ec 0c             	sub    $0xc,%esp
80104dc6:	68 c0 35 11 80       	push   $0x801135c0
80104dcb:	e8 98 ef ff ff       	call   80103d68 <release>
      return -1;
80104dd0:	83 c4 10             	add    $0x10,%esp
80104dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd8:	eb e4                	jmp    80104dbe <sys_sleep+0x76>
    return -1;
80104dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddf:	eb dd                	jmp    80104dbe <sys_sleep+0x76>

80104de1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104de1:	55                   	push   %ebp
80104de2:	89 e5                	mov    %esp,%ebp
80104de4:	53                   	push   %ebx
80104de5:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104de8:	68 c0 35 11 80       	push   $0x801135c0
80104ded:	e8 0f ef ff ff       	call   80103d01 <acquire>
  xticks = ticks;
80104df2:	8b 1d a0 35 11 80    	mov    0x801135a0,%ebx
  release(&tickslock);
80104df8:	c7 04 24 c0 35 11 80 	movl   $0x801135c0,(%esp)
80104dff:	e8 64 ef ff ff       	call   80103d68 <release>
  return xticks;
}
80104e04:	89 d8                	mov    %ebx,%eax
80104e06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e09:	c9                   	leave  
80104e0a:	c3                   	ret    

80104e0b <sys_ps>:

int
sys_ps(void)
{
80104e0b:	55                   	push   %ebp
80104e0c:	89 e5                	mov    %esp,%ebp
80104e0e:	83 ec 08             	sub    $0x8,%esp
  ps();
80104e11:	e8 12 ec ff ff       	call   80103a28 <ps>
  return 0;
}
80104e16:	b8 00 00 00 00       	mov    $0x0,%eax
80104e1b:	c9                   	leave  
80104e1c:	c3                   	ret    

80104e1d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104e1d:	1e                   	push   %ds
  pushl %es
80104e1e:	06                   	push   %es
  pushl %fs
80104e1f:	0f a0                	push   %fs
  pushl %gs
80104e21:	0f a8                	push   %gs
  pushal
80104e23:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104e24:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104e28:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104e2a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104e2c:	54                   	push   %esp
  call trap
80104e2d:	e8 bd 00 00 00       	call   80104eef <trap>
  addl $4, %esp
80104e32:	83 c4 04             	add    $0x4,%esp

80104e35 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104e35:	61                   	popa   
  popl %gs
80104e36:	0f a9                	pop    %gs
  popl %fs
80104e38:	0f a1                	pop    %fs
  popl %es
80104e3a:	07                   	pop    %es
  popl %ds
80104e3b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104e3c:	83 c4 08             	add    $0x8,%esp
  iret
80104e3f:	cf                   	iret   

80104e40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104e46:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104e4b:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80104e52:	66 89 14 c5 00 36 11 	mov    %dx,-0x7feeca00(,%eax,8)
80104e59:	80 
80104e5a:	66 c7 04 c5 02 36 11 	movw   $0x8,-0x7feec9fe(,%eax,8)
80104e61:	80 08 00 
80104e64:	c6 04 c5 04 36 11 80 	movb   $0x0,-0x7feec9fc(,%eax,8)
80104e6b:	00 
80104e6c:	c6 04 c5 05 36 11 80 	movb   $0x8e,-0x7feec9fb(,%eax,8)
80104e73:	8e 
80104e74:	c1 ea 10             	shr    $0x10,%edx
80104e77:	66 89 14 c5 06 36 11 	mov    %dx,-0x7feec9fa(,%eax,8)
80104e7e:	80 
  for(i = 0; i < 256; i++)
80104e7f:	83 c0 01             	add    $0x1,%eax
80104e82:	3d 00 01 00 00       	cmp    $0x100,%eax
80104e87:	75 c2                	jne    80104e4b <tvinit+0xb>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104e89:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80104e8e:	66 a3 00 38 11 80    	mov    %ax,0x80113800
80104e94:	66 c7 05 02 38 11 80 	movw   $0x8,0x80113802
80104e9b:	08 00 
80104e9d:	c6 05 04 38 11 80 00 	movb   $0x0,0x80113804
80104ea4:	c6 05 05 38 11 80 ef 	movb   $0xef,0x80113805
80104eab:	c1 e8 10             	shr    $0x10,%eax
80104eae:	66 a3 06 38 11 80    	mov    %ax,0x80113806

  initlock(&tickslock, "time");
80104eb4:	83 ec 08             	sub    $0x8,%esp
80104eb7:	68 61 7d 10 80       	push   $0x80107d61
80104ebc:	68 c0 35 11 80       	push   $0x801135c0
80104ec1:	e8 f2 ec ff ff       	call   80103bb8 <initlock>
}
80104ec6:	83 c4 10             	add    $0x10,%esp
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    

80104ecb <idtinit>:

void
idtinit(void)
{
80104ecb:	55                   	push   %ebp
80104ecc:	89 e5                	mov    %esp,%ebp
80104ece:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104ed1:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104ed7:	b8 00 36 11 80       	mov    $0x80113600,%eax
80104edc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104ee0:	c1 e8 10             	shr    $0x10,%eax
80104ee3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104ee7:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104eea:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104eed:	c9                   	leave  
80104eee:	c3                   	ret    

80104eef <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104eef:	55                   	push   %ebp
80104ef0:	89 e5                	mov    %esp,%ebp
80104ef2:	57                   	push   %edi
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
80104ef5:	83 ec 1c             	sub    $0x1c,%esp
80104ef8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104efb:	8b 43 30             	mov    0x30(%ebx),%eax
80104efe:	83 f8 40             	cmp    $0x40,%eax
80104f01:	74 13                	je     80104f16 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104f03:	83 e8 20             	sub    $0x20,%eax
80104f06:	83 f8 1f             	cmp    $0x1f,%eax
80104f09:	0f 87 37 01 00 00    	ja     80105046 <trap+0x157>
80104f0f:	ff 24 85 08 7e 10 80 	jmp    *-0x7fef81f8(,%eax,4)
    if(myproc()->killed)
80104f16:	e8 95 e3 ff ff       	call   801032b0 <myproc>
80104f1b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f1f:	75 1f                	jne    80104f40 <trap+0x51>
    myproc()->tf = tf;
80104f21:	e8 8a e3 ff ff       	call   801032b0 <myproc>
80104f26:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104f29:	e8 a7 f1 ff ff       	call   801040d5 <syscall>
    if(myproc()->killed)
80104f2e:	e8 7d e3 ff ff       	call   801032b0 <myproc>
80104f33:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f37:	74 7e                	je     80104fb7 <trap+0xc8>
      exit();
80104f39:	e8 22 e7 ff ff       	call   80103660 <exit>
80104f3e:	eb 77                	jmp    80104fb7 <trap+0xc8>
      exit();
80104f40:	e8 1b e7 ff ff       	call   80103660 <exit>
80104f45:	eb da                	jmp    80104f21 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104f47:	e8 49 e3 ff ff       	call   80103295 <cpuid>
80104f4c:	85 c0                	test   %eax,%eax
80104f4e:	74 6f                	je     80104fbf <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104f50:	e8 db d4 ff ff       	call   80102430 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f55:	e8 56 e3 ff ff       	call   801032b0 <myproc>
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	74 1c                	je     80104f7a <trap+0x8b>
80104f5e:	e8 4d e3 ff ff       	call   801032b0 <myproc>
80104f63:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f67:	74 11                	je     80104f7a <trap+0x8b>
80104f69:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104f6d:	83 e0 03             	and    $0x3,%eax
80104f70:	66 83 f8 03          	cmp    $0x3,%ax
80104f74:	0f 84 62 01 00 00    	je     801050dc <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104f7a:	e8 31 e3 ff ff       	call   801032b0 <myproc>
80104f7f:	85 c0                	test   %eax,%eax
80104f81:	74 0f                	je     80104f92 <trap+0xa3>
80104f83:	e8 28 e3 ff ff       	call   801032b0 <myproc>
80104f88:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104f8c:	0f 84 54 01 00 00    	je     801050e6 <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f92:	e8 19 e3 ff ff       	call   801032b0 <myproc>
80104f97:	85 c0                	test   %eax,%eax
80104f99:	74 1c                	je     80104fb7 <trap+0xc8>
80104f9b:	e8 10 e3 ff ff       	call   801032b0 <myproc>
80104fa0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fa4:	74 11                	je     80104fb7 <trap+0xc8>
80104fa6:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104faa:	83 e0 03             	and    $0x3,%eax
80104fad:	66 83 f8 03          	cmp    $0x3,%ax
80104fb1:	0f 84 43 01 00 00    	je     801050fa <trap+0x20b>
    exit();
}
80104fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5f                   	pop    %edi
80104fbd:	5d                   	pop    %ebp
80104fbe:	c3                   	ret    
      acquire(&tickslock);
80104fbf:	83 ec 0c             	sub    $0xc,%esp
80104fc2:	68 c0 35 11 80       	push   $0x801135c0
80104fc7:	e8 35 ed ff ff       	call   80103d01 <acquire>
      ticks++;
80104fcc:	83 05 a0 35 11 80 01 	addl   $0x1,0x801135a0
      wakeup(&ticks);
80104fd3:	c7 04 24 a0 35 11 80 	movl   $0x801135a0,(%esp)
80104fda:	e8 f8 e8 ff ff       	call   801038d7 <wakeup>
      release(&tickslock);
80104fdf:	c7 04 24 c0 35 11 80 	movl   $0x801135c0,(%esp)
80104fe6:	e8 7d ed ff ff       	call   80103d68 <release>
80104feb:	83 c4 10             	add    $0x10,%esp
80104fee:	e9 5d ff ff ff       	jmp    80104f50 <trap+0x61>
    ideintr();
80104ff3:	e8 ad cd ff ff       	call   80101da5 <ideintr>
    lapiceoi();
80104ff8:	e8 33 d4 ff ff       	call   80102430 <lapiceoi>
    break;
80104ffd:	e9 53 ff ff ff       	jmp    80104f55 <trap+0x66>
    kbdintr();
80105002:	e8 63 d2 ff ff       	call   8010226a <kbdintr>
    lapiceoi();
80105007:	e8 24 d4 ff ff       	call   80102430 <lapiceoi>
    break;
8010500c:	e9 44 ff ff ff       	jmp    80104f55 <trap+0x66>
    uartintr();
80105011:	e8 15 02 00 00       	call   8010522b <uartintr>
    lapiceoi();
80105016:	e8 15 d4 ff ff       	call   80102430 <lapiceoi>
    break;
8010501b:	e9 35 ff ff ff       	jmp    80104f55 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105020:	8b 7b 38             	mov    0x38(%ebx),%edi
80105023:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105027:	e8 69 e2 ff ff       	call   80103295 <cpuid>
8010502c:	57                   	push   %edi
8010502d:	56                   	push   %esi
8010502e:	50                   	push   %eax
8010502f:	68 6c 7d 10 80       	push   $0x80107d6c
80105034:	e8 c8 b5 ff ff       	call   80100601 <cprintf>
    lapiceoi();
80105039:	e8 f2 d3 ff ff       	call   80102430 <lapiceoi>
    break;
8010503e:	83 c4 10             	add    $0x10,%esp
80105041:	e9 0f ff ff ff       	jmp    80104f55 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105046:	e8 65 e2 ff ff       	call   801032b0 <myproc>
8010504b:	85 c0                	test   %eax,%eax
8010504d:	74 62                	je     801050b1 <trap+0x1c2>
8010504f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105053:	74 5c                	je     801050b1 <trap+0x1c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105055:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105058:	8b 73 38             	mov    0x38(%ebx),%esi
8010505b:	e8 35 e2 ff ff       	call   80103295 <cpuid>
80105060:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105063:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105066:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105069:	8b 53 30             	mov    0x30(%ebx),%edx
8010506c:	89 55 dc             	mov    %edx,-0x24(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010506f:	e8 3c e2 ff ff       	call   801032b0 <myproc>
80105074:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105077:	e8 34 e2 ff ff       	call   801032b0 <myproc>
8010507c:	89 c2                	mov    %eax,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010507e:	57                   	push   %edi
8010507f:	56                   	push   %esi
80105080:	ff 75 e4             	push   -0x1c(%ebp)
80105083:	ff 75 e0             	push   -0x20(%ebp)
80105086:	ff 75 dc             	push   -0x24(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105089:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010508c:	83 c0 6c             	add    $0x6c,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010508f:	50                   	push   %eax
80105090:	ff 72 10             	push   0x10(%edx)
80105093:	68 c4 7d 10 80       	push   $0x80107dc4
80105098:	e8 64 b5 ff ff       	call   80100601 <cprintf>
    myproc()->killed = 1;
8010509d:	83 c4 20             	add    $0x20,%esp
801050a0:	e8 0b e2 ff ff       	call   801032b0 <myproc>
801050a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801050ac:	e9 a4 fe ff ff       	jmp    80104f55 <trap+0x66>
801050b1:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801050b4:	8b 73 38             	mov    0x38(%ebx),%esi
801050b7:	e8 d9 e1 ff ff       	call   80103295 <cpuid>
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	57                   	push   %edi
801050c0:	56                   	push   %esi
801050c1:	50                   	push   %eax
801050c2:	ff 73 30             	push   0x30(%ebx)
801050c5:	68 90 7d 10 80       	push   $0x80107d90
801050ca:	e8 32 b5 ff ff       	call   80100601 <cprintf>
      panic("trap");
801050cf:	83 c4 14             	add    $0x14,%esp
801050d2:	68 66 7d 10 80       	push   $0x80107d66
801050d7:	e8 64 b2 ff ff       	call   80100340 <panic>
    exit();
801050dc:	e8 7f e5 ff ff       	call   80103660 <exit>
801050e1:	e9 94 fe ff ff       	jmp    80104f7a <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
801050e6:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801050ea:	0f 85 a2 fe ff ff    	jne    80104f92 <trap+0xa3>
    yield();
801050f0:	e8 32 e6 ff ff       	call   80103727 <yield>
801050f5:	e9 98 fe ff ff       	jmp    80104f92 <trap+0xa3>
    exit();
801050fa:	e8 61 e5 ff ff       	call   80103660 <exit>
801050ff:	e9 b3 fe ff ff       	jmp    80104fb7 <trap+0xc8>

80105104 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105104:	83 3d 00 3e 11 80 00 	cmpl   $0x0,0x80113e00
8010510b:	74 14                	je     80105121 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010510d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105112:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105113:	a8 01                	test   $0x1,%al
80105115:	74 10                	je     80105127 <uartgetc+0x23>
80105117:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010511c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010511d:	0f b6 c0             	movzbl %al,%eax
80105120:	c3                   	ret    
    return -1;
80105121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105126:	c3                   	ret    
    return -1;
80105127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010512c:	c3                   	ret    

8010512d <uartputc>:
  if(!uart)
8010512d:	83 3d 00 3e 11 80 00 	cmpl   $0x0,0x80113e00
80105134:	74 4f                	je     80105185 <uartputc+0x58>
{
80105136:	55                   	push   %ebp
80105137:	89 e5                	mov    %esp,%ebp
80105139:	56                   	push   %esi
8010513a:	53                   	push   %ebx
8010513b:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105140:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105141:	a8 20                	test   $0x20,%al
80105143:	75 30                	jne    80105175 <uartputc+0x48>
    microdelay(10);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	6a 0a                	push   $0xa
8010514a:	e8 02 d3 ff ff       	call   80102451 <microdelay>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	bb 7f 00 00 00       	mov    $0x7f,%ebx
80105157:	be fd 03 00 00       	mov    $0x3fd,%esi
8010515c:	89 f2                	mov    %esi,%edx
8010515e:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010515f:	a8 20                	test   $0x20,%al
80105161:	75 12                	jne    80105175 <uartputc+0x48>
    microdelay(10);
80105163:	83 ec 0c             	sub    $0xc,%esp
80105166:	6a 0a                	push   $0xa
80105168:	e8 e4 d2 ff ff       	call   80102451 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	83 eb 01             	sub    $0x1,%ebx
80105173:	75 e7                	jne    8010515c <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105175:	8b 45 08             	mov    0x8(%ebp),%eax
80105178:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010517d:	ee                   	out    %al,(%dx)
}
8010517e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5d                   	pop    %ebp
80105184:	c3                   	ret    
80105185:	c3                   	ret    

80105186 <uartinit>:
{
80105186:	55                   	push   %ebp
80105187:	89 e5                	mov    %esp,%ebp
80105189:	56                   	push   %esi
8010518a:	53                   	push   %ebx
8010518b:	b9 00 00 00 00       	mov    $0x0,%ecx
80105190:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105195:	89 c8                	mov    %ecx,%eax
80105197:	ee                   	out    %al,(%dx)
80105198:	be fb 03 00 00       	mov    $0x3fb,%esi
8010519d:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801051a2:	89 f2                	mov    %esi,%edx
801051a4:	ee                   	out    %al,(%dx)
801051a5:	b8 0c 00 00 00       	mov    $0xc,%eax
801051aa:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051af:	ee                   	out    %al,(%dx)
801051b0:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801051b5:	89 c8                	mov    %ecx,%eax
801051b7:	89 da                	mov    %ebx,%edx
801051b9:	ee                   	out    %al,(%dx)
801051ba:	b8 03 00 00 00       	mov    $0x3,%eax
801051bf:	89 f2                	mov    %esi,%edx
801051c1:	ee                   	out    %al,(%dx)
801051c2:	ba fc 03 00 00       	mov    $0x3fc,%edx
801051c7:	89 c8                	mov    %ecx,%eax
801051c9:	ee                   	out    %al,(%dx)
801051ca:	b8 01 00 00 00       	mov    $0x1,%eax
801051cf:	89 da                	mov    %ebx,%edx
801051d1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801051d2:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051d7:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801051d8:	3c ff                	cmp    $0xff,%al
801051da:	74 48                	je     80105224 <uartinit+0x9e>
  uart = 1;
801051dc:	c7 05 00 3e 11 80 01 	movl   $0x1,0x80113e00
801051e3:	00 00 00 
801051e6:	ba fa 03 00 00       	mov    $0x3fa,%edx
801051eb:	ec                   	in     (%dx),%al
801051ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051f1:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801051f2:	83 ec 08             	sub    $0x8,%esp
801051f5:	6a 00                	push   $0x0
801051f7:	6a 04                	push   $0x4
801051f9:	e8 cb cd ff ff       	call   80101fc9 <ioapicenable>
801051fe:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105201:	bb 88 7e 10 80       	mov    $0x80107e88,%ebx
80105206:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
8010520b:	83 ec 0c             	sub    $0xc,%esp
8010520e:	0f be c0             	movsbl %al,%eax
80105211:	50                   	push   %eax
80105212:	e8 16 ff ff ff       	call   8010512d <uartputc>
  for(p="xv6...\n"; *p; p++)
80105217:	83 c3 01             	add    $0x1,%ebx
8010521a:	0f b6 03             	movzbl (%ebx),%eax
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	84 c0                	test   %al,%al
80105222:	75 e7                	jne    8010520b <uartinit+0x85>
}
80105224:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105227:	5b                   	pop    %ebx
80105228:	5e                   	pop    %esi
80105229:	5d                   	pop    %ebp
8010522a:	c3                   	ret    

8010522b <uartintr>:

void
uartintr(void)
{
8010522b:	55                   	push   %ebp
8010522c:	89 e5                	mov    %esp,%ebp
8010522e:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105231:	68 04 51 10 80       	push   $0x80105104
80105236:	e8 21 b5 ff ff       	call   8010075c <consoleintr>
}
8010523b:	83 c4 10             	add    $0x10,%esp
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    

80105240 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105240:	6a 00                	push   $0x0
  pushl $0
80105242:	6a 00                	push   $0x0
  jmp alltraps
80105244:	e9 d4 fb ff ff       	jmp    80104e1d <alltraps>

80105249 <vector1>:
.globl vector1
vector1:
  pushl $0
80105249:	6a 00                	push   $0x0
  pushl $1
8010524b:	6a 01                	push   $0x1
  jmp alltraps
8010524d:	e9 cb fb ff ff       	jmp    80104e1d <alltraps>

80105252 <vector2>:
.globl vector2
vector2:
  pushl $0
80105252:	6a 00                	push   $0x0
  pushl $2
80105254:	6a 02                	push   $0x2
  jmp alltraps
80105256:	e9 c2 fb ff ff       	jmp    80104e1d <alltraps>

8010525b <vector3>:
.globl vector3
vector3:
  pushl $0
8010525b:	6a 00                	push   $0x0
  pushl $3
8010525d:	6a 03                	push   $0x3
  jmp alltraps
8010525f:	e9 b9 fb ff ff       	jmp    80104e1d <alltraps>

80105264 <vector4>:
.globl vector4
vector4:
  pushl $0
80105264:	6a 00                	push   $0x0
  pushl $4
80105266:	6a 04                	push   $0x4
  jmp alltraps
80105268:	e9 b0 fb ff ff       	jmp    80104e1d <alltraps>

8010526d <vector5>:
.globl vector5
vector5:
  pushl $0
8010526d:	6a 00                	push   $0x0
  pushl $5
8010526f:	6a 05                	push   $0x5
  jmp alltraps
80105271:	e9 a7 fb ff ff       	jmp    80104e1d <alltraps>

80105276 <vector6>:
.globl vector6
vector6:
  pushl $0
80105276:	6a 00                	push   $0x0
  pushl $6
80105278:	6a 06                	push   $0x6
  jmp alltraps
8010527a:	e9 9e fb ff ff       	jmp    80104e1d <alltraps>

8010527f <vector7>:
.globl vector7
vector7:
  pushl $0
8010527f:	6a 00                	push   $0x0
  pushl $7
80105281:	6a 07                	push   $0x7
  jmp alltraps
80105283:	e9 95 fb ff ff       	jmp    80104e1d <alltraps>

80105288 <vector8>:
.globl vector8
vector8:
  pushl $8
80105288:	6a 08                	push   $0x8
  jmp alltraps
8010528a:	e9 8e fb ff ff       	jmp    80104e1d <alltraps>

8010528f <vector9>:
.globl vector9
vector9:
  pushl $0
8010528f:	6a 00                	push   $0x0
  pushl $9
80105291:	6a 09                	push   $0x9
  jmp alltraps
80105293:	e9 85 fb ff ff       	jmp    80104e1d <alltraps>

80105298 <vector10>:
.globl vector10
vector10:
  pushl $10
80105298:	6a 0a                	push   $0xa
  jmp alltraps
8010529a:	e9 7e fb ff ff       	jmp    80104e1d <alltraps>

8010529f <vector11>:
.globl vector11
vector11:
  pushl $11
8010529f:	6a 0b                	push   $0xb
  jmp alltraps
801052a1:	e9 77 fb ff ff       	jmp    80104e1d <alltraps>

801052a6 <vector12>:
.globl vector12
vector12:
  pushl $12
801052a6:	6a 0c                	push   $0xc
  jmp alltraps
801052a8:	e9 70 fb ff ff       	jmp    80104e1d <alltraps>

801052ad <vector13>:
.globl vector13
vector13:
  pushl $13
801052ad:	6a 0d                	push   $0xd
  jmp alltraps
801052af:	e9 69 fb ff ff       	jmp    80104e1d <alltraps>

801052b4 <vector14>:
.globl vector14
vector14:
  pushl $14
801052b4:	6a 0e                	push   $0xe
  jmp alltraps
801052b6:	e9 62 fb ff ff       	jmp    80104e1d <alltraps>

801052bb <vector15>:
.globl vector15
vector15:
  pushl $0
801052bb:	6a 00                	push   $0x0
  pushl $15
801052bd:	6a 0f                	push   $0xf
  jmp alltraps
801052bf:	e9 59 fb ff ff       	jmp    80104e1d <alltraps>

801052c4 <vector16>:
.globl vector16
vector16:
  pushl $0
801052c4:	6a 00                	push   $0x0
  pushl $16
801052c6:	6a 10                	push   $0x10
  jmp alltraps
801052c8:	e9 50 fb ff ff       	jmp    80104e1d <alltraps>

801052cd <vector17>:
.globl vector17
vector17:
  pushl $17
801052cd:	6a 11                	push   $0x11
  jmp alltraps
801052cf:	e9 49 fb ff ff       	jmp    80104e1d <alltraps>

801052d4 <vector18>:
.globl vector18
vector18:
  pushl $0
801052d4:	6a 00                	push   $0x0
  pushl $18
801052d6:	6a 12                	push   $0x12
  jmp alltraps
801052d8:	e9 40 fb ff ff       	jmp    80104e1d <alltraps>

801052dd <vector19>:
.globl vector19
vector19:
  pushl $0
801052dd:	6a 00                	push   $0x0
  pushl $19
801052df:	6a 13                	push   $0x13
  jmp alltraps
801052e1:	e9 37 fb ff ff       	jmp    80104e1d <alltraps>

801052e6 <vector20>:
.globl vector20
vector20:
  pushl $0
801052e6:	6a 00                	push   $0x0
  pushl $20
801052e8:	6a 14                	push   $0x14
  jmp alltraps
801052ea:	e9 2e fb ff ff       	jmp    80104e1d <alltraps>

801052ef <vector21>:
.globl vector21
vector21:
  pushl $0
801052ef:	6a 00                	push   $0x0
  pushl $21
801052f1:	6a 15                	push   $0x15
  jmp alltraps
801052f3:	e9 25 fb ff ff       	jmp    80104e1d <alltraps>

801052f8 <vector22>:
.globl vector22
vector22:
  pushl $0
801052f8:	6a 00                	push   $0x0
  pushl $22
801052fa:	6a 16                	push   $0x16
  jmp alltraps
801052fc:	e9 1c fb ff ff       	jmp    80104e1d <alltraps>

80105301 <vector23>:
.globl vector23
vector23:
  pushl $0
80105301:	6a 00                	push   $0x0
  pushl $23
80105303:	6a 17                	push   $0x17
  jmp alltraps
80105305:	e9 13 fb ff ff       	jmp    80104e1d <alltraps>

8010530a <vector24>:
.globl vector24
vector24:
  pushl $0
8010530a:	6a 00                	push   $0x0
  pushl $24
8010530c:	6a 18                	push   $0x18
  jmp alltraps
8010530e:	e9 0a fb ff ff       	jmp    80104e1d <alltraps>

80105313 <vector25>:
.globl vector25
vector25:
  pushl $0
80105313:	6a 00                	push   $0x0
  pushl $25
80105315:	6a 19                	push   $0x19
  jmp alltraps
80105317:	e9 01 fb ff ff       	jmp    80104e1d <alltraps>

8010531c <vector26>:
.globl vector26
vector26:
  pushl $0
8010531c:	6a 00                	push   $0x0
  pushl $26
8010531e:	6a 1a                	push   $0x1a
  jmp alltraps
80105320:	e9 f8 fa ff ff       	jmp    80104e1d <alltraps>

80105325 <vector27>:
.globl vector27
vector27:
  pushl $0
80105325:	6a 00                	push   $0x0
  pushl $27
80105327:	6a 1b                	push   $0x1b
  jmp alltraps
80105329:	e9 ef fa ff ff       	jmp    80104e1d <alltraps>

8010532e <vector28>:
.globl vector28
vector28:
  pushl $0
8010532e:	6a 00                	push   $0x0
  pushl $28
80105330:	6a 1c                	push   $0x1c
  jmp alltraps
80105332:	e9 e6 fa ff ff       	jmp    80104e1d <alltraps>

80105337 <vector29>:
.globl vector29
vector29:
  pushl $0
80105337:	6a 00                	push   $0x0
  pushl $29
80105339:	6a 1d                	push   $0x1d
  jmp alltraps
8010533b:	e9 dd fa ff ff       	jmp    80104e1d <alltraps>

80105340 <vector30>:
.globl vector30
vector30:
  pushl $0
80105340:	6a 00                	push   $0x0
  pushl $30
80105342:	6a 1e                	push   $0x1e
  jmp alltraps
80105344:	e9 d4 fa ff ff       	jmp    80104e1d <alltraps>

80105349 <vector31>:
.globl vector31
vector31:
  pushl $0
80105349:	6a 00                	push   $0x0
  pushl $31
8010534b:	6a 1f                	push   $0x1f
  jmp alltraps
8010534d:	e9 cb fa ff ff       	jmp    80104e1d <alltraps>

80105352 <vector32>:
.globl vector32
vector32:
  pushl $0
80105352:	6a 00                	push   $0x0
  pushl $32
80105354:	6a 20                	push   $0x20
  jmp alltraps
80105356:	e9 c2 fa ff ff       	jmp    80104e1d <alltraps>

8010535b <vector33>:
.globl vector33
vector33:
  pushl $0
8010535b:	6a 00                	push   $0x0
  pushl $33
8010535d:	6a 21                	push   $0x21
  jmp alltraps
8010535f:	e9 b9 fa ff ff       	jmp    80104e1d <alltraps>

80105364 <vector34>:
.globl vector34
vector34:
  pushl $0
80105364:	6a 00                	push   $0x0
  pushl $34
80105366:	6a 22                	push   $0x22
  jmp alltraps
80105368:	e9 b0 fa ff ff       	jmp    80104e1d <alltraps>

8010536d <vector35>:
.globl vector35
vector35:
  pushl $0
8010536d:	6a 00                	push   $0x0
  pushl $35
8010536f:	6a 23                	push   $0x23
  jmp alltraps
80105371:	e9 a7 fa ff ff       	jmp    80104e1d <alltraps>

80105376 <vector36>:
.globl vector36
vector36:
  pushl $0
80105376:	6a 00                	push   $0x0
  pushl $36
80105378:	6a 24                	push   $0x24
  jmp alltraps
8010537a:	e9 9e fa ff ff       	jmp    80104e1d <alltraps>

8010537f <vector37>:
.globl vector37
vector37:
  pushl $0
8010537f:	6a 00                	push   $0x0
  pushl $37
80105381:	6a 25                	push   $0x25
  jmp alltraps
80105383:	e9 95 fa ff ff       	jmp    80104e1d <alltraps>

80105388 <vector38>:
.globl vector38
vector38:
  pushl $0
80105388:	6a 00                	push   $0x0
  pushl $38
8010538a:	6a 26                	push   $0x26
  jmp alltraps
8010538c:	e9 8c fa ff ff       	jmp    80104e1d <alltraps>

80105391 <vector39>:
.globl vector39
vector39:
  pushl $0
80105391:	6a 00                	push   $0x0
  pushl $39
80105393:	6a 27                	push   $0x27
  jmp alltraps
80105395:	e9 83 fa ff ff       	jmp    80104e1d <alltraps>

8010539a <vector40>:
.globl vector40
vector40:
  pushl $0
8010539a:	6a 00                	push   $0x0
  pushl $40
8010539c:	6a 28                	push   $0x28
  jmp alltraps
8010539e:	e9 7a fa ff ff       	jmp    80104e1d <alltraps>

801053a3 <vector41>:
.globl vector41
vector41:
  pushl $0
801053a3:	6a 00                	push   $0x0
  pushl $41
801053a5:	6a 29                	push   $0x29
  jmp alltraps
801053a7:	e9 71 fa ff ff       	jmp    80104e1d <alltraps>

801053ac <vector42>:
.globl vector42
vector42:
  pushl $0
801053ac:	6a 00                	push   $0x0
  pushl $42
801053ae:	6a 2a                	push   $0x2a
  jmp alltraps
801053b0:	e9 68 fa ff ff       	jmp    80104e1d <alltraps>

801053b5 <vector43>:
.globl vector43
vector43:
  pushl $0
801053b5:	6a 00                	push   $0x0
  pushl $43
801053b7:	6a 2b                	push   $0x2b
  jmp alltraps
801053b9:	e9 5f fa ff ff       	jmp    80104e1d <alltraps>

801053be <vector44>:
.globl vector44
vector44:
  pushl $0
801053be:	6a 00                	push   $0x0
  pushl $44
801053c0:	6a 2c                	push   $0x2c
  jmp alltraps
801053c2:	e9 56 fa ff ff       	jmp    80104e1d <alltraps>

801053c7 <vector45>:
.globl vector45
vector45:
  pushl $0
801053c7:	6a 00                	push   $0x0
  pushl $45
801053c9:	6a 2d                	push   $0x2d
  jmp alltraps
801053cb:	e9 4d fa ff ff       	jmp    80104e1d <alltraps>

801053d0 <vector46>:
.globl vector46
vector46:
  pushl $0
801053d0:	6a 00                	push   $0x0
  pushl $46
801053d2:	6a 2e                	push   $0x2e
  jmp alltraps
801053d4:	e9 44 fa ff ff       	jmp    80104e1d <alltraps>

801053d9 <vector47>:
.globl vector47
vector47:
  pushl $0
801053d9:	6a 00                	push   $0x0
  pushl $47
801053db:	6a 2f                	push   $0x2f
  jmp alltraps
801053dd:	e9 3b fa ff ff       	jmp    80104e1d <alltraps>

801053e2 <vector48>:
.globl vector48
vector48:
  pushl $0
801053e2:	6a 00                	push   $0x0
  pushl $48
801053e4:	6a 30                	push   $0x30
  jmp alltraps
801053e6:	e9 32 fa ff ff       	jmp    80104e1d <alltraps>

801053eb <vector49>:
.globl vector49
vector49:
  pushl $0
801053eb:	6a 00                	push   $0x0
  pushl $49
801053ed:	6a 31                	push   $0x31
  jmp alltraps
801053ef:	e9 29 fa ff ff       	jmp    80104e1d <alltraps>

801053f4 <vector50>:
.globl vector50
vector50:
  pushl $0
801053f4:	6a 00                	push   $0x0
  pushl $50
801053f6:	6a 32                	push   $0x32
  jmp alltraps
801053f8:	e9 20 fa ff ff       	jmp    80104e1d <alltraps>

801053fd <vector51>:
.globl vector51
vector51:
  pushl $0
801053fd:	6a 00                	push   $0x0
  pushl $51
801053ff:	6a 33                	push   $0x33
  jmp alltraps
80105401:	e9 17 fa ff ff       	jmp    80104e1d <alltraps>

80105406 <vector52>:
.globl vector52
vector52:
  pushl $0
80105406:	6a 00                	push   $0x0
  pushl $52
80105408:	6a 34                	push   $0x34
  jmp alltraps
8010540a:	e9 0e fa ff ff       	jmp    80104e1d <alltraps>

8010540f <vector53>:
.globl vector53
vector53:
  pushl $0
8010540f:	6a 00                	push   $0x0
  pushl $53
80105411:	6a 35                	push   $0x35
  jmp alltraps
80105413:	e9 05 fa ff ff       	jmp    80104e1d <alltraps>

80105418 <vector54>:
.globl vector54
vector54:
  pushl $0
80105418:	6a 00                	push   $0x0
  pushl $54
8010541a:	6a 36                	push   $0x36
  jmp alltraps
8010541c:	e9 fc f9 ff ff       	jmp    80104e1d <alltraps>

80105421 <vector55>:
.globl vector55
vector55:
  pushl $0
80105421:	6a 00                	push   $0x0
  pushl $55
80105423:	6a 37                	push   $0x37
  jmp alltraps
80105425:	e9 f3 f9 ff ff       	jmp    80104e1d <alltraps>

8010542a <vector56>:
.globl vector56
vector56:
  pushl $0
8010542a:	6a 00                	push   $0x0
  pushl $56
8010542c:	6a 38                	push   $0x38
  jmp alltraps
8010542e:	e9 ea f9 ff ff       	jmp    80104e1d <alltraps>

80105433 <vector57>:
.globl vector57
vector57:
  pushl $0
80105433:	6a 00                	push   $0x0
  pushl $57
80105435:	6a 39                	push   $0x39
  jmp alltraps
80105437:	e9 e1 f9 ff ff       	jmp    80104e1d <alltraps>

8010543c <vector58>:
.globl vector58
vector58:
  pushl $0
8010543c:	6a 00                	push   $0x0
  pushl $58
8010543e:	6a 3a                	push   $0x3a
  jmp alltraps
80105440:	e9 d8 f9 ff ff       	jmp    80104e1d <alltraps>

80105445 <vector59>:
.globl vector59
vector59:
  pushl $0
80105445:	6a 00                	push   $0x0
  pushl $59
80105447:	6a 3b                	push   $0x3b
  jmp alltraps
80105449:	e9 cf f9 ff ff       	jmp    80104e1d <alltraps>

8010544e <vector60>:
.globl vector60
vector60:
  pushl $0
8010544e:	6a 00                	push   $0x0
  pushl $60
80105450:	6a 3c                	push   $0x3c
  jmp alltraps
80105452:	e9 c6 f9 ff ff       	jmp    80104e1d <alltraps>

80105457 <vector61>:
.globl vector61
vector61:
  pushl $0
80105457:	6a 00                	push   $0x0
  pushl $61
80105459:	6a 3d                	push   $0x3d
  jmp alltraps
8010545b:	e9 bd f9 ff ff       	jmp    80104e1d <alltraps>

80105460 <vector62>:
.globl vector62
vector62:
  pushl $0
80105460:	6a 00                	push   $0x0
  pushl $62
80105462:	6a 3e                	push   $0x3e
  jmp alltraps
80105464:	e9 b4 f9 ff ff       	jmp    80104e1d <alltraps>

80105469 <vector63>:
.globl vector63
vector63:
  pushl $0
80105469:	6a 00                	push   $0x0
  pushl $63
8010546b:	6a 3f                	push   $0x3f
  jmp alltraps
8010546d:	e9 ab f9 ff ff       	jmp    80104e1d <alltraps>

80105472 <vector64>:
.globl vector64
vector64:
  pushl $0
80105472:	6a 00                	push   $0x0
  pushl $64
80105474:	6a 40                	push   $0x40
  jmp alltraps
80105476:	e9 a2 f9 ff ff       	jmp    80104e1d <alltraps>

8010547b <vector65>:
.globl vector65
vector65:
  pushl $0
8010547b:	6a 00                	push   $0x0
  pushl $65
8010547d:	6a 41                	push   $0x41
  jmp alltraps
8010547f:	e9 99 f9 ff ff       	jmp    80104e1d <alltraps>

80105484 <vector66>:
.globl vector66
vector66:
  pushl $0
80105484:	6a 00                	push   $0x0
  pushl $66
80105486:	6a 42                	push   $0x42
  jmp alltraps
80105488:	e9 90 f9 ff ff       	jmp    80104e1d <alltraps>

8010548d <vector67>:
.globl vector67
vector67:
  pushl $0
8010548d:	6a 00                	push   $0x0
  pushl $67
8010548f:	6a 43                	push   $0x43
  jmp alltraps
80105491:	e9 87 f9 ff ff       	jmp    80104e1d <alltraps>

80105496 <vector68>:
.globl vector68
vector68:
  pushl $0
80105496:	6a 00                	push   $0x0
  pushl $68
80105498:	6a 44                	push   $0x44
  jmp alltraps
8010549a:	e9 7e f9 ff ff       	jmp    80104e1d <alltraps>

8010549f <vector69>:
.globl vector69
vector69:
  pushl $0
8010549f:	6a 00                	push   $0x0
  pushl $69
801054a1:	6a 45                	push   $0x45
  jmp alltraps
801054a3:	e9 75 f9 ff ff       	jmp    80104e1d <alltraps>

801054a8 <vector70>:
.globl vector70
vector70:
  pushl $0
801054a8:	6a 00                	push   $0x0
  pushl $70
801054aa:	6a 46                	push   $0x46
  jmp alltraps
801054ac:	e9 6c f9 ff ff       	jmp    80104e1d <alltraps>

801054b1 <vector71>:
.globl vector71
vector71:
  pushl $0
801054b1:	6a 00                	push   $0x0
  pushl $71
801054b3:	6a 47                	push   $0x47
  jmp alltraps
801054b5:	e9 63 f9 ff ff       	jmp    80104e1d <alltraps>

801054ba <vector72>:
.globl vector72
vector72:
  pushl $0
801054ba:	6a 00                	push   $0x0
  pushl $72
801054bc:	6a 48                	push   $0x48
  jmp alltraps
801054be:	e9 5a f9 ff ff       	jmp    80104e1d <alltraps>

801054c3 <vector73>:
.globl vector73
vector73:
  pushl $0
801054c3:	6a 00                	push   $0x0
  pushl $73
801054c5:	6a 49                	push   $0x49
  jmp alltraps
801054c7:	e9 51 f9 ff ff       	jmp    80104e1d <alltraps>

801054cc <vector74>:
.globl vector74
vector74:
  pushl $0
801054cc:	6a 00                	push   $0x0
  pushl $74
801054ce:	6a 4a                	push   $0x4a
  jmp alltraps
801054d0:	e9 48 f9 ff ff       	jmp    80104e1d <alltraps>

801054d5 <vector75>:
.globl vector75
vector75:
  pushl $0
801054d5:	6a 00                	push   $0x0
  pushl $75
801054d7:	6a 4b                	push   $0x4b
  jmp alltraps
801054d9:	e9 3f f9 ff ff       	jmp    80104e1d <alltraps>

801054de <vector76>:
.globl vector76
vector76:
  pushl $0
801054de:	6a 00                	push   $0x0
  pushl $76
801054e0:	6a 4c                	push   $0x4c
  jmp alltraps
801054e2:	e9 36 f9 ff ff       	jmp    80104e1d <alltraps>

801054e7 <vector77>:
.globl vector77
vector77:
  pushl $0
801054e7:	6a 00                	push   $0x0
  pushl $77
801054e9:	6a 4d                	push   $0x4d
  jmp alltraps
801054eb:	e9 2d f9 ff ff       	jmp    80104e1d <alltraps>

801054f0 <vector78>:
.globl vector78
vector78:
  pushl $0
801054f0:	6a 00                	push   $0x0
  pushl $78
801054f2:	6a 4e                	push   $0x4e
  jmp alltraps
801054f4:	e9 24 f9 ff ff       	jmp    80104e1d <alltraps>

801054f9 <vector79>:
.globl vector79
vector79:
  pushl $0
801054f9:	6a 00                	push   $0x0
  pushl $79
801054fb:	6a 4f                	push   $0x4f
  jmp alltraps
801054fd:	e9 1b f9 ff ff       	jmp    80104e1d <alltraps>

80105502 <vector80>:
.globl vector80
vector80:
  pushl $0
80105502:	6a 00                	push   $0x0
  pushl $80
80105504:	6a 50                	push   $0x50
  jmp alltraps
80105506:	e9 12 f9 ff ff       	jmp    80104e1d <alltraps>

8010550b <vector81>:
.globl vector81
vector81:
  pushl $0
8010550b:	6a 00                	push   $0x0
  pushl $81
8010550d:	6a 51                	push   $0x51
  jmp alltraps
8010550f:	e9 09 f9 ff ff       	jmp    80104e1d <alltraps>

80105514 <vector82>:
.globl vector82
vector82:
  pushl $0
80105514:	6a 00                	push   $0x0
  pushl $82
80105516:	6a 52                	push   $0x52
  jmp alltraps
80105518:	e9 00 f9 ff ff       	jmp    80104e1d <alltraps>

8010551d <vector83>:
.globl vector83
vector83:
  pushl $0
8010551d:	6a 00                	push   $0x0
  pushl $83
8010551f:	6a 53                	push   $0x53
  jmp alltraps
80105521:	e9 f7 f8 ff ff       	jmp    80104e1d <alltraps>

80105526 <vector84>:
.globl vector84
vector84:
  pushl $0
80105526:	6a 00                	push   $0x0
  pushl $84
80105528:	6a 54                	push   $0x54
  jmp alltraps
8010552a:	e9 ee f8 ff ff       	jmp    80104e1d <alltraps>

8010552f <vector85>:
.globl vector85
vector85:
  pushl $0
8010552f:	6a 00                	push   $0x0
  pushl $85
80105531:	6a 55                	push   $0x55
  jmp alltraps
80105533:	e9 e5 f8 ff ff       	jmp    80104e1d <alltraps>

80105538 <vector86>:
.globl vector86
vector86:
  pushl $0
80105538:	6a 00                	push   $0x0
  pushl $86
8010553a:	6a 56                	push   $0x56
  jmp alltraps
8010553c:	e9 dc f8 ff ff       	jmp    80104e1d <alltraps>

80105541 <vector87>:
.globl vector87
vector87:
  pushl $0
80105541:	6a 00                	push   $0x0
  pushl $87
80105543:	6a 57                	push   $0x57
  jmp alltraps
80105545:	e9 d3 f8 ff ff       	jmp    80104e1d <alltraps>

8010554a <vector88>:
.globl vector88
vector88:
  pushl $0
8010554a:	6a 00                	push   $0x0
  pushl $88
8010554c:	6a 58                	push   $0x58
  jmp alltraps
8010554e:	e9 ca f8 ff ff       	jmp    80104e1d <alltraps>

80105553 <vector89>:
.globl vector89
vector89:
  pushl $0
80105553:	6a 00                	push   $0x0
  pushl $89
80105555:	6a 59                	push   $0x59
  jmp alltraps
80105557:	e9 c1 f8 ff ff       	jmp    80104e1d <alltraps>

8010555c <vector90>:
.globl vector90
vector90:
  pushl $0
8010555c:	6a 00                	push   $0x0
  pushl $90
8010555e:	6a 5a                	push   $0x5a
  jmp alltraps
80105560:	e9 b8 f8 ff ff       	jmp    80104e1d <alltraps>

80105565 <vector91>:
.globl vector91
vector91:
  pushl $0
80105565:	6a 00                	push   $0x0
  pushl $91
80105567:	6a 5b                	push   $0x5b
  jmp alltraps
80105569:	e9 af f8 ff ff       	jmp    80104e1d <alltraps>

8010556e <vector92>:
.globl vector92
vector92:
  pushl $0
8010556e:	6a 00                	push   $0x0
  pushl $92
80105570:	6a 5c                	push   $0x5c
  jmp alltraps
80105572:	e9 a6 f8 ff ff       	jmp    80104e1d <alltraps>

80105577 <vector93>:
.globl vector93
vector93:
  pushl $0
80105577:	6a 00                	push   $0x0
  pushl $93
80105579:	6a 5d                	push   $0x5d
  jmp alltraps
8010557b:	e9 9d f8 ff ff       	jmp    80104e1d <alltraps>

80105580 <vector94>:
.globl vector94
vector94:
  pushl $0
80105580:	6a 00                	push   $0x0
  pushl $94
80105582:	6a 5e                	push   $0x5e
  jmp alltraps
80105584:	e9 94 f8 ff ff       	jmp    80104e1d <alltraps>

80105589 <vector95>:
.globl vector95
vector95:
  pushl $0
80105589:	6a 00                	push   $0x0
  pushl $95
8010558b:	6a 5f                	push   $0x5f
  jmp alltraps
8010558d:	e9 8b f8 ff ff       	jmp    80104e1d <alltraps>

80105592 <vector96>:
.globl vector96
vector96:
  pushl $0
80105592:	6a 00                	push   $0x0
  pushl $96
80105594:	6a 60                	push   $0x60
  jmp alltraps
80105596:	e9 82 f8 ff ff       	jmp    80104e1d <alltraps>

8010559b <vector97>:
.globl vector97
vector97:
  pushl $0
8010559b:	6a 00                	push   $0x0
  pushl $97
8010559d:	6a 61                	push   $0x61
  jmp alltraps
8010559f:	e9 79 f8 ff ff       	jmp    80104e1d <alltraps>

801055a4 <vector98>:
.globl vector98
vector98:
  pushl $0
801055a4:	6a 00                	push   $0x0
  pushl $98
801055a6:	6a 62                	push   $0x62
  jmp alltraps
801055a8:	e9 70 f8 ff ff       	jmp    80104e1d <alltraps>

801055ad <vector99>:
.globl vector99
vector99:
  pushl $0
801055ad:	6a 00                	push   $0x0
  pushl $99
801055af:	6a 63                	push   $0x63
  jmp alltraps
801055b1:	e9 67 f8 ff ff       	jmp    80104e1d <alltraps>

801055b6 <vector100>:
.globl vector100
vector100:
  pushl $0
801055b6:	6a 00                	push   $0x0
  pushl $100
801055b8:	6a 64                	push   $0x64
  jmp alltraps
801055ba:	e9 5e f8 ff ff       	jmp    80104e1d <alltraps>

801055bf <vector101>:
.globl vector101
vector101:
  pushl $0
801055bf:	6a 00                	push   $0x0
  pushl $101
801055c1:	6a 65                	push   $0x65
  jmp alltraps
801055c3:	e9 55 f8 ff ff       	jmp    80104e1d <alltraps>

801055c8 <vector102>:
.globl vector102
vector102:
  pushl $0
801055c8:	6a 00                	push   $0x0
  pushl $102
801055ca:	6a 66                	push   $0x66
  jmp alltraps
801055cc:	e9 4c f8 ff ff       	jmp    80104e1d <alltraps>

801055d1 <vector103>:
.globl vector103
vector103:
  pushl $0
801055d1:	6a 00                	push   $0x0
  pushl $103
801055d3:	6a 67                	push   $0x67
  jmp alltraps
801055d5:	e9 43 f8 ff ff       	jmp    80104e1d <alltraps>

801055da <vector104>:
.globl vector104
vector104:
  pushl $0
801055da:	6a 00                	push   $0x0
  pushl $104
801055dc:	6a 68                	push   $0x68
  jmp alltraps
801055de:	e9 3a f8 ff ff       	jmp    80104e1d <alltraps>

801055e3 <vector105>:
.globl vector105
vector105:
  pushl $0
801055e3:	6a 00                	push   $0x0
  pushl $105
801055e5:	6a 69                	push   $0x69
  jmp alltraps
801055e7:	e9 31 f8 ff ff       	jmp    80104e1d <alltraps>

801055ec <vector106>:
.globl vector106
vector106:
  pushl $0
801055ec:	6a 00                	push   $0x0
  pushl $106
801055ee:	6a 6a                	push   $0x6a
  jmp alltraps
801055f0:	e9 28 f8 ff ff       	jmp    80104e1d <alltraps>

801055f5 <vector107>:
.globl vector107
vector107:
  pushl $0
801055f5:	6a 00                	push   $0x0
  pushl $107
801055f7:	6a 6b                	push   $0x6b
  jmp alltraps
801055f9:	e9 1f f8 ff ff       	jmp    80104e1d <alltraps>

801055fe <vector108>:
.globl vector108
vector108:
  pushl $0
801055fe:	6a 00                	push   $0x0
  pushl $108
80105600:	6a 6c                	push   $0x6c
  jmp alltraps
80105602:	e9 16 f8 ff ff       	jmp    80104e1d <alltraps>

80105607 <vector109>:
.globl vector109
vector109:
  pushl $0
80105607:	6a 00                	push   $0x0
  pushl $109
80105609:	6a 6d                	push   $0x6d
  jmp alltraps
8010560b:	e9 0d f8 ff ff       	jmp    80104e1d <alltraps>

80105610 <vector110>:
.globl vector110
vector110:
  pushl $0
80105610:	6a 00                	push   $0x0
  pushl $110
80105612:	6a 6e                	push   $0x6e
  jmp alltraps
80105614:	e9 04 f8 ff ff       	jmp    80104e1d <alltraps>

80105619 <vector111>:
.globl vector111
vector111:
  pushl $0
80105619:	6a 00                	push   $0x0
  pushl $111
8010561b:	6a 6f                	push   $0x6f
  jmp alltraps
8010561d:	e9 fb f7 ff ff       	jmp    80104e1d <alltraps>

80105622 <vector112>:
.globl vector112
vector112:
  pushl $0
80105622:	6a 00                	push   $0x0
  pushl $112
80105624:	6a 70                	push   $0x70
  jmp alltraps
80105626:	e9 f2 f7 ff ff       	jmp    80104e1d <alltraps>

8010562b <vector113>:
.globl vector113
vector113:
  pushl $0
8010562b:	6a 00                	push   $0x0
  pushl $113
8010562d:	6a 71                	push   $0x71
  jmp alltraps
8010562f:	e9 e9 f7 ff ff       	jmp    80104e1d <alltraps>

80105634 <vector114>:
.globl vector114
vector114:
  pushl $0
80105634:	6a 00                	push   $0x0
  pushl $114
80105636:	6a 72                	push   $0x72
  jmp alltraps
80105638:	e9 e0 f7 ff ff       	jmp    80104e1d <alltraps>

8010563d <vector115>:
.globl vector115
vector115:
  pushl $0
8010563d:	6a 00                	push   $0x0
  pushl $115
8010563f:	6a 73                	push   $0x73
  jmp alltraps
80105641:	e9 d7 f7 ff ff       	jmp    80104e1d <alltraps>

80105646 <vector116>:
.globl vector116
vector116:
  pushl $0
80105646:	6a 00                	push   $0x0
  pushl $116
80105648:	6a 74                	push   $0x74
  jmp alltraps
8010564a:	e9 ce f7 ff ff       	jmp    80104e1d <alltraps>

8010564f <vector117>:
.globl vector117
vector117:
  pushl $0
8010564f:	6a 00                	push   $0x0
  pushl $117
80105651:	6a 75                	push   $0x75
  jmp alltraps
80105653:	e9 c5 f7 ff ff       	jmp    80104e1d <alltraps>

80105658 <vector118>:
.globl vector118
vector118:
  pushl $0
80105658:	6a 00                	push   $0x0
  pushl $118
8010565a:	6a 76                	push   $0x76
  jmp alltraps
8010565c:	e9 bc f7 ff ff       	jmp    80104e1d <alltraps>

80105661 <vector119>:
.globl vector119
vector119:
  pushl $0
80105661:	6a 00                	push   $0x0
  pushl $119
80105663:	6a 77                	push   $0x77
  jmp alltraps
80105665:	e9 b3 f7 ff ff       	jmp    80104e1d <alltraps>

8010566a <vector120>:
.globl vector120
vector120:
  pushl $0
8010566a:	6a 00                	push   $0x0
  pushl $120
8010566c:	6a 78                	push   $0x78
  jmp alltraps
8010566e:	e9 aa f7 ff ff       	jmp    80104e1d <alltraps>

80105673 <vector121>:
.globl vector121
vector121:
  pushl $0
80105673:	6a 00                	push   $0x0
  pushl $121
80105675:	6a 79                	push   $0x79
  jmp alltraps
80105677:	e9 a1 f7 ff ff       	jmp    80104e1d <alltraps>

8010567c <vector122>:
.globl vector122
vector122:
  pushl $0
8010567c:	6a 00                	push   $0x0
  pushl $122
8010567e:	6a 7a                	push   $0x7a
  jmp alltraps
80105680:	e9 98 f7 ff ff       	jmp    80104e1d <alltraps>

80105685 <vector123>:
.globl vector123
vector123:
  pushl $0
80105685:	6a 00                	push   $0x0
  pushl $123
80105687:	6a 7b                	push   $0x7b
  jmp alltraps
80105689:	e9 8f f7 ff ff       	jmp    80104e1d <alltraps>

8010568e <vector124>:
.globl vector124
vector124:
  pushl $0
8010568e:	6a 00                	push   $0x0
  pushl $124
80105690:	6a 7c                	push   $0x7c
  jmp alltraps
80105692:	e9 86 f7 ff ff       	jmp    80104e1d <alltraps>

80105697 <vector125>:
.globl vector125
vector125:
  pushl $0
80105697:	6a 00                	push   $0x0
  pushl $125
80105699:	6a 7d                	push   $0x7d
  jmp alltraps
8010569b:	e9 7d f7 ff ff       	jmp    80104e1d <alltraps>

801056a0 <vector126>:
.globl vector126
vector126:
  pushl $0
801056a0:	6a 00                	push   $0x0
  pushl $126
801056a2:	6a 7e                	push   $0x7e
  jmp alltraps
801056a4:	e9 74 f7 ff ff       	jmp    80104e1d <alltraps>

801056a9 <vector127>:
.globl vector127
vector127:
  pushl $0
801056a9:	6a 00                	push   $0x0
  pushl $127
801056ab:	6a 7f                	push   $0x7f
  jmp alltraps
801056ad:	e9 6b f7 ff ff       	jmp    80104e1d <alltraps>

801056b2 <vector128>:
.globl vector128
vector128:
  pushl $0
801056b2:	6a 00                	push   $0x0
  pushl $128
801056b4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801056b9:	e9 5f f7 ff ff       	jmp    80104e1d <alltraps>

801056be <vector129>:
.globl vector129
vector129:
  pushl $0
801056be:	6a 00                	push   $0x0
  pushl $129
801056c0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801056c5:	e9 53 f7 ff ff       	jmp    80104e1d <alltraps>

801056ca <vector130>:
.globl vector130
vector130:
  pushl $0
801056ca:	6a 00                	push   $0x0
  pushl $130
801056cc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801056d1:	e9 47 f7 ff ff       	jmp    80104e1d <alltraps>

801056d6 <vector131>:
.globl vector131
vector131:
  pushl $0
801056d6:	6a 00                	push   $0x0
  pushl $131
801056d8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801056dd:	e9 3b f7 ff ff       	jmp    80104e1d <alltraps>

801056e2 <vector132>:
.globl vector132
vector132:
  pushl $0
801056e2:	6a 00                	push   $0x0
  pushl $132
801056e4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801056e9:	e9 2f f7 ff ff       	jmp    80104e1d <alltraps>

801056ee <vector133>:
.globl vector133
vector133:
  pushl $0
801056ee:	6a 00                	push   $0x0
  pushl $133
801056f0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801056f5:	e9 23 f7 ff ff       	jmp    80104e1d <alltraps>

801056fa <vector134>:
.globl vector134
vector134:
  pushl $0
801056fa:	6a 00                	push   $0x0
  pushl $134
801056fc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105701:	e9 17 f7 ff ff       	jmp    80104e1d <alltraps>

80105706 <vector135>:
.globl vector135
vector135:
  pushl $0
80105706:	6a 00                	push   $0x0
  pushl $135
80105708:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010570d:	e9 0b f7 ff ff       	jmp    80104e1d <alltraps>

80105712 <vector136>:
.globl vector136
vector136:
  pushl $0
80105712:	6a 00                	push   $0x0
  pushl $136
80105714:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105719:	e9 ff f6 ff ff       	jmp    80104e1d <alltraps>

8010571e <vector137>:
.globl vector137
vector137:
  pushl $0
8010571e:	6a 00                	push   $0x0
  pushl $137
80105720:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105725:	e9 f3 f6 ff ff       	jmp    80104e1d <alltraps>

8010572a <vector138>:
.globl vector138
vector138:
  pushl $0
8010572a:	6a 00                	push   $0x0
  pushl $138
8010572c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105731:	e9 e7 f6 ff ff       	jmp    80104e1d <alltraps>

80105736 <vector139>:
.globl vector139
vector139:
  pushl $0
80105736:	6a 00                	push   $0x0
  pushl $139
80105738:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010573d:	e9 db f6 ff ff       	jmp    80104e1d <alltraps>

80105742 <vector140>:
.globl vector140
vector140:
  pushl $0
80105742:	6a 00                	push   $0x0
  pushl $140
80105744:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105749:	e9 cf f6 ff ff       	jmp    80104e1d <alltraps>

8010574e <vector141>:
.globl vector141
vector141:
  pushl $0
8010574e:	6a 00                	push   $0x0
  pushl $141
80105750:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105755:	e9 c3 f6 ff ff       	jmp    80104e1d <alltraps>

8010575a <vector142>:
.globl vector142
vector142:
  pushl $0
8010575a:	6a 00                	push   $0x0
  pushl $142
8010575c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105761:	e9 b7 f6 ff ff       	jmp    80104e1d <alltraps>

80105766 <vector143>:
.globl vector143
vector143:
  pushl $0
80105766:	6a 00                	push   $0x0
  pushl $143
80105768:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010576d:	e9 ab f6 ff ff       	jmp    80104e1d <alltraps>

80105772 <vector144>:
.globl vector144
vector144:
  pushl $0
80105772:	6a 00                	push   $0x0
  pushl $144
80105774:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105779:	e9 9f f6 ff ff       	jmp    80104e1d <alltraps>

8010577e <vector145>:
.globl vector145
vector145:
  pushl $0
8010577e:	6a 00                	push   $0x0
  pushl $145
80105780:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105785:	e9 93 f6 ff ff       	jmp    80104e1d <alltraps>

8010578a <vector146>:
.globl vector146
vector146:
  pushl $0
8010578a:	6a 00                	push   $0x0
  pushl $146
8010578c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105791:	e9 87 f6 ff ff       	jmp    80104e1d <alltraps>

80105796 <vector147>:
.globl vector147
vector147:
  pushl $0
80105796:	6a 00                	push   $0x0
  pushl $147
80105798:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010579d:	e9 7b f6 ff ff       	jmp    80104e1d <alltraps>

801057a2 <vector148>:
.globl vector148
vector148:
  pushl $0
801057a2:	6a 00                	push   $0x0
  pushl $148
801057a4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801057a9:	e9 6f f6 ff ff       	jmp    80104e1d <alltraps>

801057ae <vector149>:
.globl vector149
vector149:
  pushl $0
801057ae:	6a 00                	push   $0x0
  pushl $149
801057b0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801057b5:	e9 63 f6 ff ff       	jmp    80104e1d <alltraps>

801057ba <vector150>:
.globl vector150
vector150:
  pushl $0
801057ba:	6a 00                	push   $0x0
  pushl $150
801057bc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801057c1:	e9 57 f6 ff ff       	jmp    80104e1d <alltraps>

801057c6 <vector151>:
.globl vector151
vector151:
  pushl $0
801057c6:	6a 00                	push   $0x0
  pushl $151
801057c8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801057cd:	e9 4b f6 ff ff       	jmp    80104e1d <alltraps>

801057d2 <vector152>:
.globl vector152
vector152:
  pushl $0
801057d2:	6a 00                	push   $0x0
  pushl $152
801057d4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801057d9:	e9 3f f6 ff ff       	jmp    80104e1d <alltraps>

801057de <vector153>:
.globl vector153
vector153:
  pushl $0
801057de:	6a 00                	push   $0x0
  pushl $153
801057e0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801057e5:	e9 33 f6 ff ff       	jmp    80104e1d <alltraps>

801057ea <vector154>:
.globl vector154
vector154:
  pushl $0
801057ea:	6a 00                	push   $0x0
  pushl $154
801057ec:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801057f1:	e9 27 f6 ff ff       	jmp    80104e1d <alltraps>

801057f6 <vector155>:
.globl vector155
vector155:
  pushl $0
801057f6:	6a 00                	push   $0x0
  pushl $155
801057f8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801057fd:	e9 1b f6 ff ff       	jmp    80104e1d <alltraps>

80105802 <vector156>:
.globl vector156
vector156:
  pushl $0
80105802:	6a 00                	push   $0x0
  pushl $156
80105804:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105809:	e9 0f f6 ff ff       	jmp    80104e1d <alltraps>

8010580e <vector157>:
.globl vector157
vector157:
  pushl $0
8010580e:	6a 00                	push   $0x0
  pushl $157
80105810:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105815:	e9 03 f6 ff ff       	jmp    80104e1d <alltraps>

8010581a <vector158>:
.globl vector158
vector158:
  pushl $0
8010581a:	6a 00                	push   $0x0
  pushl $158
8010581c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105821:	e9 f7 f5 ff ff       	jmp    80104e1d <alltraps>

80105826 <vector159>:
.globl vector159
vector159:
  pushl $0
80105826:	6a 00                	push   $0x0
  pushl $159
80105828:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010582d:	e9 eb f5 ff ff       	jmp    80104e1d <alltraps>

80105832 <vector160>:
.globl vector160
vector160:
  pushl $0
80105832:	6a 00                	push   $0x0
  pushl $160
80105834:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105839:	e9 df f5 ff ff       	jmp    80104e1d <alltraps>

8010583e <vector161>:
.globl vector161
vector161:
  pushl $0
8010583e:	6a 00                	push   $0x0
  pushl $161
80105840:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105845:	e9 d3 f5 ff ff       	jmp    80104e1d <alltraps>

8010584a <vector162>:
.globl vector162
vector162:
  pushl $0
8010584a:	6a 00                	push   $0x0
  pushl $162
8010584c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105851:	e9 c7 f5 ff ff       	jmp    80104e1d <alltraps>

80105856 <vector163>:
.globl vector163
vector163:
  pushl $0
80105856:	6a 00                	push   $0x0
  pushl $163
80105858:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010585d:	e9 bb f5 ff ff       	jmp    80104e1d <alltraps>

80105862 <vector164>:
.globl vector164
vector164:
  pushl $0
80105862:	6a 00                	push   $0x0
  pushl $164
80105864:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105869:	e9 af f5 ff ff       	jmp    80104e1d <alltraps>

8010586e <vector165>:
.globl vector165
vector165:
  pushl $0
8010586e:	6a 00                	push   $0x0
  pushl $165
80105870:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105875:	e9 a3 f5 ff ff       	jmp    80104e1d <alltraps>

8010587a <vector166>:
.globl vector166
vector166:
  pushl $0
8010587a:	6a 00                	push   $0x0
  pushl $166
8010587c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105881:	e9 97 f5 ff ff       	jmp    80104e1d <alltraps>

80105886 <vector167>:
.globl vector167
vector167:
  pushl $0
80105886:	6a 00                	push   $0x0
  pushl $167
80105888:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010588d:	e9 8b f5 ff ff       	jmp    80104e1d <alltraps>

80105892 <vector168>:
.globl vector168
vector168:
  pushl $0
80105892:	6a 00                	push   $0x0
  pushl $168
80105894:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105899:	e9 7f f5 ff ff       	jmp    80104e1d <alltraps>

8010589e <vector169>:
.globl vector169
vector169:
  pushl $0
8010589e:	6a 00                	push   $0x0
  pushl $169
801058a0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801058a5:	e9 73 f5 ff ff       	jmp    80104e1d <alltraps>

801058aa <vector170>:
.globl vector170
vector170:
  pushl $0
801058aa:	6a 00                	push   $0x0
  pushl $170
801058ac:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801058b1:	e9 67 f5 ff ff       	jmp    80104e1d <alltraps>

801058b6 <vector171>:
.globl vector171
vector171:
  pushl $0
801058b6:	6a 00                	push   $0x0
  pushl $171
801058b8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801058bd:	e9 5b f5 ff ff       	jmp    80104e1d <alltraps>

801058c2 <vector172>:
.globl vector172
vector172:
  pushl $0
801058c2:	6a 00                	push   $0x0
  pushl $172
801058c4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801058c9:	e9 4f f5 ff ff       	jmp    80104e1d <alltraps>

801058ce <vector173>:
.globl vector173
vector173:
  pushl $0
801058ce:	6a 00                	push   $0x0
  pushl $173
801058d0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801058d5:	e9 43 f5 ff ff       	jmp    80104e1d <alltraps>

801058da <vector174>:
.globl vector174
vector174:
  pushl $0
801058da:	6a 00                	push   $0x0
  pushl $174
801058dc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801058e1:	e9 37 f5 ff ff       	jmp    80104e1d <alltraps>

801058e6 <vector175>:
.globl vector175
vector175:
  pushl $0
801058e6:	6a 00                	push   $0x0
  pushl $175
801058e8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801058ed:	e9 2b f5 ff ff       	jmp    80104e1d <alltraps>

801058f2 <vector176>:
.globl vector176
vector176:
  pushl $0
801058f2:	6a 00                	push   $0x0
  pushl $176
801058f4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801058f9:	e9 1f f5 ff ff       	jmp    80104e1d <alltraps>

801058fe <vector177>:
.globl vector177
vector177:
  pushl $0
801058fe:	6a 00                	push   $0x0
  pushl $177
80105900:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105905:	e9 13 f5 ff ff       	jmp    80104e1d <alltraps>

8010590a <vector178>:
.globl vector178
vector178:
  pushl $0
8010590a:	6a 00                	push   $0x0
  pushl $178
8010590c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105911:	e9 07 f5 ff ff       	jmp    80104e1d <alltraps>

80105916 <vector179>:
.globl vector179
vector179:
  pushl $0
80105916:	6a 00                	push   $0x0
  pushl $179
80105918:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010591d:	e9 fb f4 ff ff       	jmp    80104e1d <alltraps>

80105922 <vector180>:
.globl vector180
vector180:
  pushl $0
80105922:	6a 00                	push   $0x0
  pushl $180
80105924:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105929:	e9 ef f4 ff ff       	jmp    80104e1d <alltraps>

8010592e <vector181>:
.globl vector181
vector181:
  pushl $0
8010592e:	6a 00                	push   $0x0
  pushl $181
80105930:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105935:	e9 e3 f4 ff ff       	jmp    80104e1d <alltraps>

8010593a <vector182>:
.globl vector182
vector182:
  pushl $0
8010593a:	6a 00                	push   $0x0
  pushl $182
8010593c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105941:	e9 d7 f4 ff ff       	jmp    80104e1d <alltraps>

80105946 <vector183>:
.globl vector183
vector183:
  pushl $0
80105946:	6a 00                	push   $0x0
  pushl $183
80105948:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010594d:	e9 cb f4 ff ff       	jmp    80104e1d <alltraps>

80105952 <vector184>:
.globl vector184
vector184:
  pushl $0
80105952:	6a 00                	push   $0x0
  pushl $184
80105954:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105959:	e9 bf f4 ff ff       	jmp    80104e1d <alltraps>

8010595e <vector185>:
.globl vector185
vector185:
  pushl $0
8010595e:	6a 00                	push   $0x0
  pushl $185
80105960:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105965:	e9 b3 f4 ff ff       	jmp    80104e1d <alltraps>

8010596a <vector186>:
.globl vector186
vector186:
  pushl $0
8010596a:	6a 00                	push   $0x0
  pushl $186
8010596c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105971:	e9 a7 f4 ff ff       	jmp    80104e1d <alltraps>

80105976 <vector187>:
.globl vector187
vector187:
  pushl $0
80105976:	6a 00                	push   $0x0
  pushl $187
80105978:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010597d:	e9 9b f4 ff ff       	jmp    80104e1d <alltraps>

80105982 <vector188>:
.globl vector188
vector188:
  pushl $0
80105982:	6a 00                	push   $0x0
  pushl $188
80105984:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105989:	e9 8f f4 ff ff       	jmp    80104e1d <alltraps>

8010598e <vector189>:
.globl vector189
vector189:
  pushl $0
8010598e:	6a 00                	push   $0x0
  pushl $189
80105990:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105995:	e9 83 f4 ff ff       	jmp    80104e1d <alltraps>

8010599a <vector190>:
.globl vector190
vector190:
  pushl $0
8010599a:	6a 00                	push   $0x0
  pushl $190
8010599c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801059a1:	e9 77 f4 ff ff       	jmp    80104e1d <alltraps>

801059a6 <vector191>:
.globl vector191
vector191:
  pushl $0
801059a6:	6a 00                	push   $0x0
  pushl $191
801059a8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801059ad:	e9 6b f4 ff ff       	jmp    80104e1d <alltraps>

801059b2 <vector192>:
.globl vector192
vector192:
  pushl $0
801059b2:	6a 00                	push   $0x0
  pushl $192
801059b4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801059b9:	e9 5f f4 ff ff       	jmp    80104e1d <alltraps>

801059be <vector193>:
.globl vector193
vector193:
  pushl $0
801059be:	6a 00                	push   $0x0
  pushl $193
801059c0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801059c5:	e9 53 f4 ff ff       	jmp    80104e1d <alltraps>

801059ca <vector194>:
.globl vector194
vector194:
  pushl $0
801059ca:	6a 00                	push   $0x0
  pushl $194
801059cc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801059d1:	e9 47 f4 ff ff       	jmp    80104e1d <alltraps>

801059d6 <vector195>:
.globl vector195
vector195:
  pushl $0
801059d6:	6a 00                	push   $0x0
  pushl $195
801059d8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801059dd:	e9 3b f4 ff ff       	jmp    80104e1d <alltraps>

801059e2 <vector196>:
.globl vector196
vector196:
  pushl $0
801059e2:	6a 00                	push   $0x0
  pushl $196
801059e4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801059e9:	e9 2f f4 ff ff       	jmp    80104e1d <alltraps>

801059ee <vector197>:
.globl vector197
vector197:
  pushl $0
801059ee:	6a 00                	push   $0x0
  pushl $197
801059f0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801059f5:	e9 23 f4 ff ff       	jmp    80104e1d <alltraps>

801059fa <vector198>:
.globl vector198
vector198:
  pushl $0
801059fa:	6a 00                	push   $0x0
  pushl $198
801059fc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105a01:	e9 17 f4 ff ff       	jmp    80104e1d <alltraps>

80105a06 <vector199>:
.globl vector199
vector199:
  pushl $0
80105a06:	6a 00                	push   $0x0
  pushl $199
80105a08:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105a0d:	e9 0b f4 ff ff       	jmp    80104e1d <alltraps>

80105a12 <vector200>:
.globl vector200
vector200:
  pushl $0
80105a12:	6a 00                	push   $0x0
  pushl $200
80105a14:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105a19:	e9 ff f3 ff ff       	jmp    80104e1d <alltraps>

80105a1e <vector201>:
.globl vector201
vector201:
  pushl $0
80105a1e:	6a 00                	push   $0x0
  pushl $201
80105a20:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105a25:	e9 f3 f3 ff ff       	jmp    80104e1d <alltraps>

80105a2a <vector202>:
.globl vector202
vector202:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $202
80105a2c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105a31:	e9 e7 f3 ff ff       	jmp    80104e1d <alltraps>

80105a36 <vector203>:
.globl vector203
vector203:
  pushl $0
80105a36:	6a 00                	push   $0x0
  pushl $203
80105a38:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105a3d:	e9 db f3 ff ff       	jmp    80104e1d <alltraps>

80105a42 <vector204>:
.globl vector204
vector204:
  pushl $0
80105a42:	6a 00                	push   $0x0
  pushl $204
80105a44:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105a49:	e9 cf f3 ff ff       	jmp    80104e1d <alltraps>

80105a4e <vector205>:
.globl vector205
vector205:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $205
80105a50:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105a55:	e9 c3 f3 ff ff       	jmp    80104e1d <alltraps>

80105a5a <vector206>:
.globl vector206
vector206:
  pushl $0
80105a5a:	6a 00                	push   $0x0
  pushl $206
80105a5c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105a61:	e9 b7 f3 ff ff       	jmp    80104e1d <alltraps>

80105a66 <vector207>:
.globl vector207
vector207:
  pushl $0
80105a66:	6a 00                	push   $0x0
  pushl $207
80105a68:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105a6d:	e9 ab f3 ff ff       	jmp    80104e1d <alltraps>

80105a72 <vector208>:
.globl vector208
vector208:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $208
80105a74:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105a79:	e9 9f f3 ff ff       	jmp    80104e1d <alltraps>

80105a7e <vector209>:
.globl vector209
vector209:
  pushl $0
80105a7e:	6a 00                	push   $0x0
  pushl $209
80105a80:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105a85:	e9 93 f3 ff ff       	jmp    80104e1d <alltraps>

80105a8a <vector210>:
.globl vector210
vector210:
  pushl $0
80105a8a:	6a 00                	push   $0x0
  pushl $210
80105a8c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105a91:	e9 87 f3 ff ff       	jmp    80104e1d <alltraps>

80105a96 <vector211>:
.globl vector211
vector211:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $211
80105a98:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105a9d:	e9 7b f3 ff ff       	jmp    80104e1d <alltraps>

80105aa2 <vector212>:
.globl vector212
vector212:
  pushl $0
80105aa2:	6a 00                	push   $0x0
  pushl $212
80105aa4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105aa9:	e9 6f f3 ff ff       	jmp    80104e1d <alltraps>

80105aae <vector213>:
.globl vector213
vector213:
  pushl $0
80105aae:	6a 00                	push   $0x0
  pushl $213
80105ab0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105ab5:	e9 63 f3 ff ff       	jmp    80104e1d <alltraps>

80105aba <vector214>:
.globl vector214
vector214:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $214
80105abc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105ac1:	e9 57 f3 ff ff       	jmp    80104e1d <alltraps>

80105ac6 <vector215>:
.globl vector215
vector215:
  pushl $0
80105ac6:	6a 00                	push   $0x0
  pushl $215
80105ac8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105acd:	e9 4b f3 ff ff       	jmp    80104e1d <alltraps>

80105ad2 <vector216>:
.globl vector216
vector216:
  pushl $0
80105ad2:	6a 00                	push   $0x0
  pushl $216
80105ad4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105ad9:	e9 3f f3 ff ff       	jmp    80104e1d <alltraps>

80105ade <vector217>:
.globl vector217
vector217:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $217
80105ae0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105ae5:	e9 33 f3 ff ff       	jmp    80104e1d <alltraps>

80105aea <vector218>:
.globl vector218
vector218:
  pushl $0
80105aea:	6a 00                	push   $0x0
  pushl $218
80105aec:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105af1:	e9 27 f3 ff ff       	jmp    80104e1d <alltraps>

80105af6 <vector219>:
.globl vector219
vector219:
  pushl $0
80105af6:	6a 00                	push   $0x0
  pushl $219
80105af8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105afd:	e9 1b f3 ff ff       	jmp    80104e1d <alltraps>

80105b02 <vector220>:
.globl vector220
vector220:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $220
80105b04:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105b09:	e9 0f f3 ff ff       	jmp    80104e1d <alltraps>

80105b0e <vector221>:
.globl vector221
vector221:
  pushl $0
80105b0e:	6a 00                	push   $0x0
  pushl $221
80105b10:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105b15:	e9 03 f3 ff ff       	jmp    80104e1d <alltraps>

80105b1a <vector222>:
.globl vector222
vector222:
  pushl $0
80105b1a:	6a 00                	push   $0x0
  pushl $222
80105b1c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105b21:	e9 f7 f2 ff ff       	jmp    80104e1d <alltraps>

80105b26 <vector223>:
.globl vector223
vector223:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $223
80105b28:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105b2d:	e9 eb f2 ff ff       	jmp    80104e1d <alltraps>

80105b32 <vector224>:
.globl vector224
vector224:
  pushl $0
80105b32:	6a 00                	push   $0x0
  pushl $224
80105b34:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105b39:	e9 df f2 ff ff       	jmp    80104e1d <alltraps>

80105b3e <vector225>:
.globl vector225
vector225:
  pushl $0
80105b3e:	6a 00                	push   $0x0
  pushl $225
80105b40:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105b45:	e9 d3 f2 ff ff       	jmp    80104e1d <alltraps>

80105b4a <vector226>:
.globl vector226
vector226:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $226
80105b4c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105b51:	e9 c7 f2 ff ff       	jmp    80104e1d <alltraps>

80105b56 <vector227>:
.globl vector227
vector227:
  pushl $0
80105b56:	6a 00                	push   $0x0
  pushl $227
80105b58:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105b5d:	e9 bb f2 ff ff       	jmp    80104e1d <alltraps>

80105b62 <vector228>:
.globl vector228
vector228:
  pushl $0
80105b62:	6a 00                	push   $0x0
  pushl $228
80105b64:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105b69:	e9 af f2 ff ff       	jmp    80104e1d <alltraps>

80105b6e <vector229>:
.globl vector229
vector229:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $229
80105b70:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105b75:	e9 a3 f2 ff ff       	jmp    80104e1d <alltraps>

80105b7a <vector230>:
.globl vector230
vector230:
  pushl $0
80105b7a:	6a 00                	push   $0x0
  pushl $230
80105b7c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105b81:	e9 97 f2 ff ff       	jmp    80104e1d <alltraps>

80105b86 <vector231>:
.globl vector231
vector231:
  pushl $0
80105b86:	6a 00                	push   $0x0
  pushl $231
80105b88:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105b8d:	e9 8b f2 ff ff       	jmp    80104e1d <alltraps>

80105b92 <vector232>:
.globl vector232
vector232:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $232
80105b94:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105b99:	e9 7f f2 ff ff       	jmp    80104e1d <alltraps>

80105b9e <vector233>:
.globl vector233
vector233:
  pushl $0
80105b9e:	6a 00                	push   $0x0
  pushl $233
80105ba0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105ba5:	e9 73 f2 ff ff       	jmp    80104e1d <alltraps>

80105baa <vector234>:
.globl vector234
vector234:
  pushl $0
80105baa:	6a 00                	push   $0x0
  pushl $234
80105bac:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105bb1:	e9 67 f2 ff ff       	jmp    80104e1d <alltraps>

80105bb6 <vector235>:
.globl vector235
vector235:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $235
80105bb8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105bbd:	e9 5b f2 ff ff       	jmp    80104e1d <alltraps>

80105bc2 <vector236>:
.globl vector236
vector236:
  pushl $0
80105bc2:	6a 00                	push   $0x0
  pushl $236
80105bc4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105bc9:	e9 4f f2 ff ff       	jmp    80104e1d <alltraps>

80105bce <vector237>:
.globl vector237
vector237:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $237
80105bd0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105bd5:	e9 43 f2 ff ff       	jmp    80104e1d <alltraps>

80105bda <vector238>:
.globl vector238
vector238:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $238
80105bdc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105be1:	e9 37 f2 ff ff       	jmp    80104e1d <alltraps>

80105be6 <vector239>:
.globl vector239
vector239:
  pushl $0
80105be6:	6a 00                	push   $0x0
  pushl $239
80105be8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105bed:	e9 2b f2 ff ff       	jmp    80104e1d <alltraps>

80105bf2 <vector240>:
.globl vector240
vector240:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $240
80105bf4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105bf9:	e9 1f f2 ff ff       	jmp    80104e1d <alltraps>

80105bfe <vector241>:
.globl vector241
vector241:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $241
80105c00:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105c05:	e9 13 f2 ff ff       	jmp    80104e1d <alltraps>

80105c0a <vector242>:
.globl vector242
vector242:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $242
80105c0c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105c11:	e9 07 f2 ff ff       	jmp    80104e1d <alltraps>

80105c16 <vector243>:
.globl vector243
vector243:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $243
80105c18:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105c1d:	e9 fb f1 ff ff       	jmp    80104e1d <alltraps>

80105c22 <vector244>:
.globl vector244
vector244:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $244
80105c24:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105c29:	e9 ef f1 ff ff       	jmp    80104e1d <alltraps>

80105c2e <vector245>:
.globl vector245
vector245:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $245
80105c30:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105c35:	e9 e3 f1 ff ff       	jmp    80104e1d <alltraps>

80105c3a <vector246>:
.globl vector246
vector246:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $246
80105c3c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105c41:	e9 d7 f1 ff ff       	jmp    80104e1d <alltraps>

80105c46 <vector247>:
.globl vector247
vector247:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $247
80105c48:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105c4d:	e9 cb f1 ff ff       	jmp    80104e1d <alltraps>

80105c52 <vector248>:
.globl vector248
vector248:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $248
80105c54:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105c59:	e9 bf f1 ff ff       	jmp    80104e1d <alltraps>

80105c5e <vector249>:
.globl vector249
vector249:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $249
80105c60:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105c65:	e9 b3 f1 ff ff       	jmp    80104e1d <alltraps>

80105c6a <vector250>:
.globl vector250
vector250:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $250
80105c6c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105c71:	e9 a7 f1 ff ff       	jmp    80104e1d <alltraps>

80105c76 <vector251>:
.globl vector251
vector251:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $251
80105c78:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105c7d:	e9 9b f1 ff ff       	jmp    80104e1d <alltraps>

80105c82 <vector252>:
.globl vector252
vector252:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $252
80105c84:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105c89:	e9 8f f1 ff ff       	jmp    80104e1d <alltraps>

80105c8e <vector253>:
.globl vector253
vector253:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $253
80105c90:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105c95:	e9 83 f1 ff ff       	jmp    80104e1d <alltraps>

80105c9a <vector254>:
.globl vector254
vector254:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $254
80105c9c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ca1:	e9 77 f1 ff ff       	jmp    80104e1d <alltraps>

80105ca6 <vector255>:
.globl vector255
vector255:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $255
80105ca8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105cad:	e9 6b f1 ff ff       	jmp    80104e1d <alltraps>

80105cb2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105cb2:	55                   	push   %ebp
80105cb3:	89 e5                	mov    %esp,%ebp
80105cb5:	57                   	push   %edi
80105cb6:	56                   	push   %esi
80105cb7:	53                   	push   %ebx
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105cbd:	c1 ea 16             	shr    $0x16,%edx
80105cc0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105cc3:	8b 1f                	mov    (%edi),%ebx
80105cc5:	f6 c3 01             	test   $0x1,%bl
80105cc8:	74 21                	je     80105ceb <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105cca:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105cd0:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105cd6:	c1 ee 0a             	shr    $0xa,%esi
80105cd9:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105cdf:	01 f3                	add    %esi,%ebx
}
80105ce1:	89 d8                	mov    %ebx,%eax
80105ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce6:	5b                   	pop    %ebx
80105ce7:	5e                   	pop    %esi
80105ce8:	5f                   	pop    %edi
80105ce9:	5d                   	pop    %ebp
80105cea:	c3                   	ret    
      return 0;
80105ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105cf0:	85 c9                	test   %ecx,%ecx
80105cf2:	74 ed                	je     80105ce1 <walkpgdir+0x2f>
80105cf4:	e8 51 c4 ff ff       	call   8010214a <kalloc>
80105cf9:	89 c3                	mov    %eax,%ebx
80105cfb:	85 c0                	test   %eax,%eax
80105cfd:	74 e2                	je     80105ce1 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80105cff:	83 ec 04             	sub    $0x4,%esp
80105d02:	68 00 10 00 00       	push   $0x1000
80105d07:	6a 00                	push   $0x0
80105d09:	50                   	push   %eax
80105d0a:	e8 a0 e0 ff ff       	call   80103daf <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105d0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105d15:	83 c8 07             	or     $0x7,%eax
80105d18:	89 07                	mov    %eax,(%edi)
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	eb b7                	jmp    80105cd6 <walkpgdir+0x24>

80105d1f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105d1f:	55                   	push   %ebp
80105d20:	89 e5                	mov    %esp,%ebp
80105d22:	57                   	push   %edi
80105d23:	56                   	push   %esi
80105d24:	53                   	push   %ebx
80105d25:	83 ec 1c             	sub    $0x1c,%esp
80105d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105d2b:	89 d0                	mov    %edx,%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105d2d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105d33:	89 d6                	mov    %edx,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105d35:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
80105d39:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80105d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105d42:	29 d0                	sub    %edx,%eax
80105d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d4a:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105d4d:	b9 01 00 00 00       	mov    $0x1,%ecx
80105d52:	89 f2                	mov    %esi,%edx
80105d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d57:	e8 56 ff ff ff       	call   80105cb2 <walkpgdir>
80105d5c:	85 c0                	test   %eax,%eax
80105d5e:	74 26                	je     80105d86 <mappages+0x67>
      return -1;
    if(*pte & PTE_P)
80105d60:	f6 00 01             	testb  $0x1,(%eax)
80105d63:	75 14                	jne    80105d79 <mappages+0x5a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105d65:	0b 5d 0c             	or     0xc(%ebp),%ebx
80105d68:	83 cb 01             	or     $0x1,%ebx
80105d6b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80105d6d:	39 fe                	cmp    %edi,%esi
80105d6f:	74 22                	je     80105d93 <mappages+0x74>
      break;
    a += PGSIZE;
80105d71:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105d77:	eb ce                	jmp    80105d47 <mappages+0x28>
      panic("remap");
80105d79:	83 ec 0c             	sub    $0xc,%esp
80105d7c:	68 90 7e 10 80       	push   $0x80107e90
80105d81:	e8 ba a5 ff ff       	call   80100340 <panic>
      return -1;
80105d86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d8e:	5b                   	pop    %ebx
80105d8f:	5e                   	pop    %esi
80105d90:	5f                   	pop    %edi
80105d91:	5d                   	pop    %ebp
80105d92:	c3                   	ret    
  return 0;
80105d93:	b8 00 00 00 00       	mov    $0x0,%eax
80105d98:	eb f1                	jmp    80105d8b <mappages+0x6c>

80105d9a <seginit>:
{
80105d9a:	55                   	push   %ebp
80105d9b:	89 e5                	mov    %esp,%ebp
80105d9d:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105da0:	e8 f0 d4 ff ff       	call   80103295 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105da5:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105dab:	66 c7 80 18 28 11 80 	movw   $0xffff,-0x7feed7e8(%eax)
80105db2:	ff ff 
80105db4:	66 c7 80 1a 28 11 80 	movw   $0x0,-0x7feed7e6(%eax)
80105dbb:	00 00 
80105dbd:	c6 80 1c 28 11 80 00 	movb   $0x0,-0x7feed7e4(%eax)
80105dc4:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
80105dcb:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
80105dd2:	c6 80 1f 28 11 80 00 	movb   $0x0,-0x7feed7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105dd9:	66 c7 80 20 28 11 80 	movw   $0xffff,-0x7feed7e0(%eax)
80105de0:	ff ff 
80105de2:	66 c7 80 22 28 11 80 	movw   $0x0,-0x7feed7de(%eax)
80105de9:	00 00 
80105deb:	c6 80 24 28 11 80 00 	movb   $0x0,-0x7feed7dc(%eax)
80105df2:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
80105df9:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
80105e00:	c6 80 27 28 11 80 00 	movb   $0x0,-0x7feed7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105e07:	66 c7 80 28 28 11 80 	movw   $0xffff,-0x7feed7d8(%eax)
80105e0e:	ff ff 
80105e10:	66 c7 80 2a 28 11 80 	movw   $0x0,-0x7feed7d6(%eax)
80105e17:	00 00 
80105e19:	c6 80 2c 28 11 80 00 	movb   $0x0,-0x7feed7d4(%eax)
80105e20:	c6 80 2d 28 11 80 fa 	movb   $0xfa,-0x7feed7d3(%eax)
80105e27:	c6 80 2e 28 11 80 cf 	movb   $0xcf,-0x7feed7d2(%eax)
80105e2e:	c6 80 2f 28 11 80 00 	movb   $0x0,-0x7feed7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105e35:	66 c7 80 30 28 11 80 	movw   $0xffff,-0x7feed7d0(%eax)
80105e3c:	ff ff 
80105e3e:	66 c7 80 32 28 11 80 	movw   $0x0,-0x7feed7ce(%eax)
80105e45:	00 00 
80105e47:	c6 80 34 28 11 80 00 	movb   $0x0,-0x7feed7cc(%eax)
80105e4e:	c6 80 35 28 11 80 f2 	movb   $0xf2,-0x7feed7cb(%eax)
80105e55:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
80105e5c:	c6 80 37 28 11 80 00 	movb   $0x0,-0x7feed7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105e63:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[0] = size-1;
80105e68:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105e6e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105e72:	c1 e8 10             	shr    $0x10,%eax
80105e75:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105e79:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105e7c:	0f 01 10             	lgdtl  (%eax)
}
80105e7f:	c9                   	leave  
80105e80:	c3                   	ret    

80105e81 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105e81:	a1 04 3e 11 80       	mov    0x80113e04,%eax
80105e86:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105e8b:	0f 22 d8             	mov    %eax,%cr3
}
80105e8e:	c3                   	ret    

80105e8f <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105e8f:	55                   	push   %ebp
80105e90:	89 e5                	mov    %esp,%ebp
80105e92:	57                   	push   %edi
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx
80105e95:	83 ec 1c             	sub    $0x1c,%esp
80105e98:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105e9b:	85 f6                	test   %esi,%esi
80105e9d:	0f 84 c3 00 00 00    	je     80105f66 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105ea3:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105ea7:	0f 84 c6 00 00 00    	je     80105f73 <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105ead:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105eb1:	0f 84 c9 00 00 00    	je     80105f80 <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80105eb7:	e8 75 dd ff ff       	call   80103c31 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105ebc:	e8 75 d3 ff ff       	call   80103236 <mycpu>
80105ec1:	89 c3                	mov    %eax,%ebx
80105ec3:	e8 6e d3 ff ff       	call   80103236 <mycpu>
80105ec8:	89 c7                	mov    %eax,%edi
80105eca:	e8 67 d3 ff ff       	call   80103236 <mycpu>
80105ecf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105ed2:	e8 5f d3 ff ff       	call   80103236 <mycpu>
80105ed7:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105ede:	67 00 
80105ee0:	83 c7 08             	add    $0x8,%edi
80105ee3:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105eea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105eed:	83 c2 08             	add    $0x8,%edx
80105ef0:	c1 ea 10             	shr    $0x10,%edx
80105ef3:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80105ef9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80105f00:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105f07:	83 c0 08             	add    $0x8,%eax
80105f0a:	c1 e8 18             	shr    $0x18,%eax
80105f0d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105f13:	e8 1e d3 ff ff       	call   80103236 <mycpu>
80105f18:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105f1f:	e8 12 d3 ff ff       	call   80103236 <mycpu>
80105f24:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105f2a:	8b 5e 08             	mov    0x8(%esi),%ebx
80105f2d:	e8 04 d3 ff ff       	call   80103236 <mycpu>
80105f32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105f38:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80105f3b:	e8 f6 d2 ff ff       	call   80103236 <mycpu>
80105f40:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80105f46:	b8 28 00 00 00       	mov    $0x28,%eax
80105f4b:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80105f4e:	8b 46 04             	mov    0x4(%esi),%eax
80105f51:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f56:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80105f59:	e8 0f dd ff ff       	call   80103c6d <popcli>
}
80105f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f61:	5b                   	pop    %ebx
80105f62:	5e                   	pop    %esi
80105f63:	5f                   	pop    %edi
80105f64:	5d                   	pop    %ebp
80105f65:	c3                   	ret    
    panic("switchuvm: no process");
80105f66:	83 ec 0c             	sub    $0xc,%esp
80105f69:	68 96 7e 10 80       	push   $0x80107e96
80105f6e:	e8 cd a3 ff ff       	call   80100340 <panic>
    panic("switchuvm: no kstack");
80105f73:	83 ec 0c             	sub    $0xc,%esp
80105f76:	68 ac 7e 10 80       	push   $0x80107eac
80105f7b:	e8 c0 a3 ff ff       	call   80100340 <panic>
    panic("switchuvm: no pgdir");
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 c1 7e 10 80       	push   $0x80107ec1
80105f88:	e8 b3 a3 ff ff       	call   80100340 <panic>

80105f8d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80105f8d:	55                   	push   %ebp
80105f8e:	89 e5                	mov    %esp,%ebp
80105f90:	56                   	push   %esi
80105f91:	53                   	push   %ebx
80105f92:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80105f95:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80105f9b:	77 4c                	ja     80105fe9 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80105f9d:	e8 a8 c1 ff ff       	call   8010214a <kalloc>
80105fa2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80105fa4:	83 ec 04             	sub    $0x4,%esp
80105fa7:	68 00 10 00 00       	push   $0x1000
80105fac:	6a 00                	push   $0x0
80105fae:	50                   	push   %eax
80105faf:	e8 fb dd ff ff       	call   80103daf <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80105fb4:	83 c4 08             	add    $0x8,%esp
80105fb7:	6a 06                	push   $0x6
80105fb9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105fbf:	50                   	push   %eax
80105fc0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80105fc5:	ba 00 00 00 00       	mov    $0x0,%edx
80105fca:	8b 45 08             	mov    0x8(%ebp),%eax
80105fcd:	e8 4d fd ff ff       	call   80105d1f <mappages>
  memmove(mem, init, sz);
80105fd2:	83 c4 0c             	add    $0xc,%esp
80105fd5:	56                   	push   %esi
80105fd6:	ff 75 0c             	push   0xc(%ebp)
80105fd9:	53                   	push   %ebx
80105fda:	e8 55 de ff ff       	call   80103e34 <memmove>
}
80105fdf:	83 c4 10             	add    $0x10,%esp
80105fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fe5:	5b                   	pop    %ebx
80105fe6:	5e                   	pop    %esi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret    
    panic("inituvm: more than a page");
80105fe9:	83 ec 0c             	sub    $0xc,%esp
80105fec:	68 d5 7e 10 80       	push   $0x80107ed5
80105ff1:	e8 4a a3 ff ff       	call   80100340 <panic>

80105ff6 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80105ff6:	55                   	push   %ebp
80105ff7:	89 e5                	mov    %esp,%ebp
80105ff9:	57                   	push   %edi
80105ffa:	56                   	push   %esi
80105ffb:	53                   	push   %ebx
80105ffc:	83 ec 1c             	sub    $0x1c,%esp
80105fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106002:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106005:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010600a:	75 6e                	jne    8010607a <loaduvm+0x84>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010600c:	89 f3                	mov    %esi,%ebx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010600e:	01 f0                	add    %esi,%eax
80106010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106013:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106018:	85 f6                	test   %esi,%esi
8010601a:	74 7d                	je     80106099 <loaduvm+0xa3>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010601c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010601f:	29 da                	sub    %ebx,%edx
80106021:	b9 00 00 00 00       	mov    $0x0,%ecx
80106026:	8b 45 08             	mov    0x8(%ebp),%eax
80106029:	e8 84 fc ff ff       	call   80105cb2 <walkpgdir>
8010602e:	85 c0                	test   %eax,%eax
80106030:	74 55                	je     80106087 <loaduvm+0x91>
    pa = PTE_ADDR(*pte);
80106032:	8b 00                	mov    (%eax),%eax
80106034:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
80106039:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010603f:	bf 00 10 00 00       	mov    $0x1000,%edi
80106044:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106047:	57                   	push   %edi
80106048:	89 f2                	mov    %esi,%edx
8010604a:	03 55 14             	add    0x14(%ebp),%edx
8010604d:	29 da                	sub    %ebx,%edx
8010604f:	52                   	push   %edx
80106050:	05 00 00 00 80       	add    $0x80000000,%eax
80106055:	50                   	push   %eax
80106056:	ff 75 10             	push   0x10(%ebp)
80106059:	e8 e9 b6 ff ff       	call   80101747 <readi>
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	39 f8                	cmp    %edi,%eax
80106063:	75 2f                	jne    80106094 <loaduvm+0x9e>
  for(i = 0; i < sz; i += PGSIZE){
80106065:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010606b:	89 f0                	mov    %esi,%eax
8010606d:	29 d8                	sub    %ebx,%eax
8010606f:	39 c6                	cmp    %eax,%esi
80106071:	77 a9                	ja     8010601c <loaduvm+0x26>
  return 0;
80106073:	b8 00 00 00 00       	mov    $0x0,%eax
80106078:	eb 1f                	jmp    80106099 <loaduvm+0xa3>
    panic("loaduvm: addr must be page aligned");
8010607a:	83 ec 0c             	sub    $0xc,%esp
8010607d:	68 90 7f 10 80       	push   $0x80107f90
80106082:	e8 b9 a2 ff ff       	call   80100340 <panic>
      panic("loaduvm: address should exist");
80106087:	83 ec 0c             	sub    $0xc,%esp
8010608a:	68 ef 7e 10 80       	push   $0x80107eef
8010608f:	e8 ac a2 ff ff       	call   80100340 <panic>
      return -1;
80106094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609c:	5b                   	pop    %ebx
8010609d:	5e                   	pop    %esi
8010609e:	5f                   	pop    %edi
8010609f:	5d                   	pop    %ebp
801060a0:	c3                   	ret    

801060a1 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801060a1:	55                   	push   %ebp
801060a2:	89 e5                	mov    %esp,%ebp
801060a4:	57                   	push   %edi
801060a5:	56                   	push   %esi
801060a6:	53                   	push   %ebx
801060a7:	83 ec 0c             	sub    $0xc,%esp
801060aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
801060ad:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
801060af:	39 7d 10             	cmp    %edi,0x10(%ebp)
801060b2:	73 16                	jae    801060ca <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
801060b4:	8b 45 10             	mov    0x10(%ebp),%eax
801060b7:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801060bd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801060c3:	39 df                	cmp    %ebx,%edi
801060c5:	77 21                	ja     801060e8 <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801060c7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801060ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060cd:	5b                   	pop    %ebx
801060ce:	5e                   	pop    %esi
801060cf:	5f                   	pop    %edi
801060d0:	5d                   	pop    %ebp
801060d1:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801060d2:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801060d8:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801060de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801060e4:	39 df                	cmp    %ebx,%edi
801060e6:	76 df                	jbe    801060c7 <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
801060e8:	b9 00 00 00 00       	mov    $0x0,%ecx
801060ed:	89 da                	mov    %ebx,%edx
801060ef:	8b 45 08             	mov    0x8(%ebp),%eax
801060f2:	e8 bb fb ff ff       	call   80105cb2 <walkpgdir>
801060f7:	89 c6                	mov    %eax,%esi
    if(!pte)
801060f9:	85 c0                	test   %eax,%eax
801060fb:	74 d5                	je     801060d2 <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
801060fd:	8b 00                	mov    (%eax),%eax
801060ff:	a8 01                	test   $0x1,%al
80106101:	74 db                	je     801060de <deallocuvm+0x3d>
      if(pa == 0)
80106103:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106108:	74 19                	je     80106123 <deallocuvm+0x82>
      kfree(v);
8010610a:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010610d:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106112:	50                   	push   %eax
80106113:	e8 e4 be ff ff       	call   80101ffc <kfree>
      *pte = 0;
80106118:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	eb bb                	jmp    801060de <deallocuvm+0x3d>
        panic("kfree");
80106123:	83 ec 0c             	sub    $0xc,%esp
80106126:	68 0c 78 10 80       	push   $0x8010780c
8010612b:	e8 10 a2 ff ff       	call   80100340 <panic>

80106130 <allocuvm>:
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	57                   	push   %edi
80106134:	56                   	push   %esi
80106135:	53                   	push   %ebx
80106136:	83 ec 1c             	sub    $0x1c,%esp
80106139:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010613c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010613f:	85 ff                	test   %edi,%edi
80106141:	0f 88 c5 00 00 00    	js     8010620c <allocuvm+0xdc>
  if(newsz < oldsz)
80106147:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010614a:	72 60                	jb     801061ac <allocuvm+0x7c>
  a = PGROUNDUP(oldsz);
8010614c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010614f:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106155:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010615b:	39 f7                	cmp    %esi,%edi
8010615d:	0f 86 b0 00 00 00    	jbe    80106213 <allocuvm+0xe3>
    mem = kalloc();
80106163:	e8 e2 bf ff ff       	call   8010214a <kalloc>
80106168:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010616a:	85 c0                	test   %eax,%eax
8010616c:	74 46                	je     801061b4 <allocuvm+0x84>
    memset(mem, 0, PGSIZE);
8010616e:	83 ec 04             	sub    $0x4,%esp
80106171:	68 00 10 00 00       	push   $0x1000
80106176:	6a 00                	push   $0x0
80106178:	50                   	push   %eax
80106179:	e8 31 dc ff ff       	call   80103daf <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010617e:	83 c4 08             	add    $0x8,%esp
80106181:	6a 06                	push   $0x6
80106183:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106189:	50                   	push   %eax
8010618a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010618f:	89 f2                	mov    %esi,%edx
80106191:	8b 45 08             	mov    0x8(%ebp),%eax
80106194:	e8 86 fb ff ff       	call   80105d1f <mappages>
80106199:	83 c4 10             	add    $0x10,%esp
8010619c:	85 c0                	test   %eax,%eax
8010619e:	78 3c                	js     801061dc <allocuvm+0xac>
  for(; a < newsz; a += PGSIZE){
801061a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801061a6:	39 f7                	cmp    %esi,%edi
801061a8:	77 b9                	ja     80106163 <allocuvm+0x33>
801061aa:	eb 67                	jmp    80106213 <allocuvm+0xe3>
    return oldsz;
801061ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801061af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061b2:	eb 5f                	jmp    80106213 <allocuvm+0xe3>
      cprintf("allocuvm out of memory\n");
801061b4:	83 ec 0c             	sub    $0xc,%esp
801061b7:	68 0d 7f 10 80       	push   $0x80107f0d
801061bc:	e8 40 a4 ff ff       	call   80100601 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801061c1:	83 c4 0c             	add    $0xc,%esp
801061c4:	ff 75 0c             	push   0xc(%ebp)
801061c7:	57                   	push   %edi
801061c8:	ff 75 08             	push   0x8(%ebp)
801061cb:	e8 d1 fe ff ff       	call   801060a1 <deallocuvm>
      return 0;
801061d0:	83 c4 10             	add    $0x10,%esp
801061d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801061da:	eb 37                	jmp    80106213 <allocuvm+0xe3>
      cprintf("allocuvm out of memory (2)\n");
801061dc:	83 ec 0c             	sub    $0xc,%esp
801061df:	68 25 7f 10 80       	push   $0x80107f25
801061e4:	e8 18 a4 ff ff       	call   80100601 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801061e9:	83 c4 0c             	add    $0xc,%esp
801061ec:	ff 75 0c             	push   0xc(%ebp)
801061ef:	57                   	push   %edi
801061f0:	ff 75 08             	push   0x8(%ebp)
801061f3:	e8 a9 fe ff ff       	call   801060a1 <deallocuvm>
      kfree(mem);
801061f8:	89 1c 24             	mov    %ebx,(%esp)
801061fb:	e8 fc bd ff ff       	call   80101ffc <kfree>
      return 0;
80106200:	83 c4 10             	add    $0x10,%esp
80106203:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010620a:	eb 07                	jmp    80106213 <allocuvm+0xe3>
    return 0;
8010620c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106219:	5b                   	pop    %ebx
8010621a:	5e                   	pop    %esi
8010621b:	5f                   	pop    %edi
8010621c:	5d                   	pop    %ebp
8010621d:	c3                   	ret    

8010621e <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010621e:	55                   	push   %ebp
8010621f:	89 e5                	mov    %esp,%ebp
80106221:	57                   	push   %edi
80106222:	56                   	push   %esi
80106223:	53                   	push   %ebx
80106224:	83 ec 0c             	sub    $0xc,%esp
80106227:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
8010622a:	85 ff                	test   %edi,%edi
8010622c:	74 1d                	je     8010624b <freevm+0x2d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010622e:	83 ec 04             	sub    $0x4,%esp
80106231:	6a 00                	push   $0x0
80106233:	68 00 00 00 80       	push   $0x80000000
80106238:	57                   	push   %edi
80106239:	e8 63 fe ff ff       	call   801060a1 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010623e:	89 fb                	mov    %edi,%ebx
80106240:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	eb 14                	jmp    8010625f <freevm+0x41>
    panic("freevm: no pgdir");
8010624b:	83 ec 0c             	sub    $0xc,%esp
8010624e:	68 41 7f 10 80       	push   $0x80107f41
80106253:	e8 e8 a0 ff ff       	call   80100340 <panic>
  for(i = 0; i < NPDENTRIES; i++){
80106258:	83 c3 04             	add    $0x4,%ebx
8010625b:	39 f3                	cmp    %esi,%ebx
8010625d:	74 1e                	je     8010627d <freevm+0x5f>
    if(pgdir[i] & PTE_P){
8010625f:	8b 03                	mov    (%ebx),%eax
80106261:	a8 01                	test   $0x1,%al
80106263:	74 f3                	je     80106258 <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106265:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010626d:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106272:	50                   	push   %eax
80106273:	e8 84 bd ff ff       	call   80101ffc <kfree>
80106278:	83 c4 10             	add    $0x10,%esp
8010627b:	eb db                	jmp    80106258 <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
8010627d:	83 ec 0c             	sub    $0xc,%esp
80106280:	57                   	push   %edi
80106281:	e8 76 bd ff ff       	call   80101ffc <kfree>
}
80106286:	83 c4 10             	add    $0x10,%esp
80106289:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010628c:	5b                   	pop    %ebx
8010628d:	5e                   	pop    %esi
8010628e:	5f                   	pop    %edi
8010628f:	5d                   	pop    %ebp
80106290:	c3                   	ret    

80106291 <setupkvm>:
{
80106291:	55                   	push   %ebp
80106292:	89 e5                	mov    %esp,%ebp
80106294:	56                   	push   %esi
80106295:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106296:	e8 af be ff ff       	call   8010214a <kalloc>
8010629b:	89 c6                	mov    %eax,%esi
8010629d:	85 c0                	test   %eax,%eax
8010629f:	74 42                	je     801062e3 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801062a1:	83 ec 04             	sub    $0x4,%esp
801062a4:	68 00 10 00 00       	push   $0x1000
801062a9:	6a 00                	push   $0x0
801062ab:	50                   	push   %eax
801062ac:	e8 fe da ff ff       	call   80103daf <memset>
801062b1:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801062b4:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
801062b9:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801062bc:	8b 4b 08             	mov    0x8(%ebx),%ecx
801062bf:	29 c1                	sub    %eax,%ecx
801062c1:	83 ec 08             	sub    $0x8,%esp
801062c4:	ff 73 0c             	push   0xc(%ebx)
801062c7:	50                   	push   %eax
801062c8:	8b 13                	mov    (%ebx),%edx
801062ca:	89 f0                	mov    %esi,%eax
801062cc:	e8 4e fa ff ff       	call   80105d1f <mappages>
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	85 c0                	test   %eax,%eax
801062d6:	78 14                	js     801062ec <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801062d8:	83 c3 10             	add    $0x10,%ebx
801062db:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801062e1:	75 d6                	jne    801062b9 <setupkvm+0x28>
}
801062e3:	89 f0                	mov    %esi,%eax
801062e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062e8:	5b                   	pop    %ebx
801062e9:	5e                   	pop    %esi
801062ea:	5d                   	pop    %ebp
801062eb:	c3                   	ret    
      freevm(pgdir);
801062ec:	83 ec 0c             	sub    $0xc,%esp
801062ef:	56                   	push   %esi
801062f0:	e8 29 ff ff ff       	call   8010621e <freevm>
      return 0;
801062f5:	83 c4 10             	add    $0x10,%esp
801062f8:	be 00 00 00 00       	mov    $0x0,%esi
801062fd:	eb e4                	jmp    801062e3 <setupkvm+0x52>

801062ff <kvmalloc>:
{
801062ff:	55                   	push   %ebp
80106300:	89 e5                	mov    %esp,%ebp
80106302:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106305:	e8 87 ff ff ff       	call   80106291 <setupkvm>
8010630a:	a3 04 3e 11 80       	mov    %eax,0x80113e04
  switchkvm();
8010630f:	e8 6d fb ff ff       	call   80105e81 <switchkvm>
}
80106314:	c9                   	leave  
80106315:	c3                   	ret    

80106316 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106316:	55                   	push   %ebp
80106317:	89 e5                	mov    %esp,%ebp
80106319:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010631c:	b9 00 00 00 00       	mov    $0x0,%ecx
80106321:	8b 55 0c             	mov    0xc(%ebp),%edx
80106324:	8b 45 08             	mov    0x8(%ebp),%eax
80106327:	e8 86 f9 ff ff       	call   80105cb2 <walkpgdir>
  if(pte == 0)
8010632c:	85 c0                	test   %eax,%eax
8010632e:	74 05                	je     80106335 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106330:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106333:	c9                   	leave  
80106334:	c3                   	ret    
    panic("clearpteu");
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	68 52 7f 10 80       	push   $0x80107f52
8010633d:	e8 fe 9f ff ff       	call   80100340 <panic>

80106342 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106342:	55                   	push   %ebp
80106343:	89 e5                	mov    %esp,%ebp
80106345:	57                   	push   %edi
80106346:	56                   	push   %esi
80106347:	53                   	push   %ebx
80106348:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010634b:	e8 41 ff ff ff       	call   80106291 <setupkvm>
80106350:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106353:	85 c0                	test   %eax,%eax
80106355:	0f 84 c7 00 00 00    	je     80106422 <copyuvm+0xe0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010635b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010635f:	0f 84 bd 00 00 00    	je     80106422 <copyuvm+0xe0>
80106365:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010636a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010636d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106372:	89 fa                	mov    %edi,%edx
80106374:	8b 45 08             	mov    0x8(%ebp),%eax
80106377:	e8 36 f9 ff ff       	call   80105cb2 <walkpgdir>
8010637c:	85 c0                	test   %eax,%eax
8010637e:	74 67                	je     801063e7 <copyuvm+0xa5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106380:	8b 00                	mov    (%eax),%eax
80106382:	a8 01                	test   $0x1,%al
80106384:	74 6e                	je     801063f4 <copyuvm+0xb2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106386:	89 c6                	mov    %eax,%esi
80106388:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010638e:	25 ff 0f 00 00       	and    $0xfff,%eax
80106393:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106396:	e8 af bd ff ff       	call   8010214a <kalloc>
8010639b:	89 c3                	mov    %eax,%ebx
8010639d:	85 c0                	test   %eax,%eax
8010639f:	74 6c                	je     8010640d <copyuvm+0xcb>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801063a1:	83 ec 04             	sub    $0x4,%esp
801063a4:	68 00 10 00 00       	push   $0x1000
801063a9:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801063af:	56                   	push   %esi
801063b0:	50                   	push   %eax
801063b1:	e8 7e da ff ff       	call   80103e34 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801063b6:	83 c4 08             	add    $0x8,%esp
801063b9:	ff 75 e0             	push   -0x20(%ebp)
801063bc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063c2:	50                   	push   %eax
801063c3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801063c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801063cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063ce:	e8 4c f9 ff ff       	call   80105d1f <mappages>
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	85 c0                	test   %eax,%eax
801063d8:	78 27                	js     80106401 <copyuvm+0xbf>
  for(i = 0; i < sz; i += PGSIZE){
801063da:	81 c7 00 10 00 00    	add    $0x1000,%edi
801063e0:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801063e3:	77 85                	ja     8010636a <copyuvm+0x28>
801063e5:	eb 3b                	jmp    80106422 <copyuvm+0xe0>
      panic("copyuvm: pte should exist");
801063e7:	83 ec 0c             	sub    $0xc,%esp
801063ea:	68 5c 7f 10 80       	push   $0x80107f5c
801063ef:	e8 4c 9f ff ff       	call   80100340 <panic>
      panic("copyuvm: page not present");
801063f4:	83 ec 0c             	sub    $0xc,%esp
801063f7:	68 76 7f 10 80       	push   $0x80107f76
801063fc:	e8 3f 9f ff ff       	call   80100340 <panic>
      kfree(mem);
80106401:	83 ec 0c             	sub    $0xc,%esp
80106404:	53                   	push   %ebx
80106405:	e8 f2 bb ff ff       	call   80101ffc <kfree>
      goto bad;
8010640a:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
8010640d:	83 ec 0c             	sub    $0xc,%esp
80106410:	ff 75 dc             	push   -0x24(%ebp)
80106413:	e8 06 fe ff ff       	call   8010621e <freevm>
  return 0;
80106418:	83 c4 10             	add    $0x10,%esp
8010641b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106422:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106425:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106428:	5b                   	pop    %ebx
80106429:	5e                   	pop    %esi
8010642a:	5f                   	pop    %edi
8010642b:	5d                   	pop    %ebp
8010642c:	c3                   	ret    

8010642d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010642d:	55                   	push   %ebp
8010642e:	89 e5                	mov    %esp,%ebp
80106430:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106433:	b9 00 00 00 00       	mov    $0x0,%ecx
80106438:	8b 55 0c             	mov    0xc(%ebp),%edx
8010643b:	8b 45 08             	mov    0x8(%ebp),%eax
8010643e:	e8 6f f8 ff ff       	call   80105cb2 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106443:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106445:	89 c2                	mov    %eax,%edx
80106447:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010644a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010644f:	05 00 00 00 80       	add    $0x80000000,%eax
80106454:	83 fa 05             	cmp    $0x5,%edx
80106457:	ba 00 00 00 00       	mov    $0x0,%edx
8010645c:	0f 45 c2             	cmovne %edx,%eax
}
8010645f:	c9                   	leave  
80106460:	c3                   	ret    

80106461 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106461:	55                   	push   %ebp
80106462:	89 e5                	mov    %esp,%ebp
80106464:	57                   	push   %edi
80106465:	56                   	push   %esi
80106466:	53                   	push   %ebx
80106467:	83 ec 0c             	sub    $0xc,%esp
8010646a:	8b 75 14             	mov    0x14(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010646d:	85 f6                	test   %esi,%esi
8010646f:	74 5a                	je     801064cb <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
80106471:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106474:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010647a:	83 ec 08             	sub    $0x8,%esp
8010647d:	57                   	push   %edi
8010647e:	ff 75 08             	push   0x8(%ebp)
80106481:	e8 a7 ff ff ff       	call   8010642d <uva2ka>
    if(pa0 == 0)
80106486:	83 c4 10             	add    $0x10,%esp
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 45                	je     801064d2 <copyout+0x71>
      return -1;
    n = PGSIZE - (va - va0);
8010648d:	89 fb                	mov    %edi,%ebx
8010648f:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106492:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106498:	39 f3                	cmp    %esi,%ebx
8010649a:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010649d:	83 ec 04             	sub    $0x4,%esp
801064a0:	53                   	push   %ebx
801064a1:	ff 75 10             	push   0x10(%ebp)
801064a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801064a7:	29 fa                	sub    %edi,%edx
801064a9:	01 d0                	add    %edx,%eax
801064ab:	50                   	push   %eax
801064ac:	e8 83 d9 ff ff       	call   80103e34 <memmove>
    len -= n;
    buf += n;
801064b1:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801064b4:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
801064ba:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801064bd:	83 c4 10             	add    $0x10,%esp
801064c0:	29 de                	sub    %ebx,%esi
801064c2:	75 ad                	jne    80106471 <copyout+0x10>
  }
  return 0;
801064c4:	b8 00 00 00 00       	mov    $0x0,%eax
801064c9:	eb 0c                	jmp    801064d7 <copyout+0x76>
801064cb:	b8 00 00 00 00       	mov    $0x0,%eax
801064d0:	eb 05                	jmp    801064d7 <copyout+0x76>
      return -1;
801064d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064da:	5b                   	pop    %ebx
801064db:	5e                   	pop    %esi
801064dc:	5f                   	pop    %edi
801064dd:	5d                   	pop    %ebp
801064de:	c3                   	ret    

801064df <set_bit>:

#include <stdbool.h>


int set_bit(int num,int i)
{
801064df:	55                   	push   %ebp
801064e0:	89 e5                	mov    %esp,%ebp
	return num | (1<<i);
801064e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801064e5:	b8 01 00 00 00       	mov    $0x1,%eax
801064ea:	d3 e0                	shl    %cl,%eax
801064ec:	0b 45 08             	or     0x8(%ebp),%eax
}
801064ef:	5d                   	pop    %ebp
801064f0:	c3                   	ret    

801064f1 <get_bit>:
int get_bit(int num,int i)
{
801064f1:	55                   	push   %ebp
801064f2:	89 e5                	mov    %esp,%ebp
	return ((num&(1<<i))!=0);
801064f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801064f7:	8b 45 08             	mov    0x8(%ebp),%eax
801064fa:	d3 f8                	sar    %cl,%eax
801064fc:	83 e0 01             	and    $0x1,%eax
}
801064ff:	5d                   	pop    %ebp
80106500:	c3                   	ret    

80106501 <clear_bit>:

int clear_bit(int num,int i)
{
80106501:	55                   	push   %ebp
80106502:	89 e5                	mov    %esp,%ebp
	int mask=~(1<<i);
80106504:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106507:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
8010650c:	d3 c0                	rol    %cl,%eax
	return num&mask;
8010650e:	23 45 08             	and    0x8(%ebp),%eax
}
80106511:	5d                   	pop    %ebp
80106512:	c3                   	ret    

80106513 <getnumofBits>:

unsigned int getnumofBits(unsigned int n)
{
80106513:	55                   	push   %ebp
80106514:	89 e5                	mov    %esp,%ebp
80106516:	8b 45 08             	mov    0x8(%ebp),%eax
	unsigned count=0;
	while(n!=0)
80106519:	85 c0                	test   %eax,%eax
8010651b:	74 10                	je     8010652d <getnumofBits+0x1a>
	unsigned count=0;
8010651d:	ba 00 00 00 00       	mov    $0x0,%edx
	{
		n>>=1;
		count+=1;
80106522:	83 c2 01             	add    $0x1,%edx
	while(n!=0)
80106525:	d1 e8                	shr    %eax
80106527:	75 f9                	jne    80106522 <getnumofBits+0xf>
	}
	return count;
}
80106529:	89 d0                	mov    %edx,%eax
8010652b:	5d                   	pop    %ebp
8010652c:	c3                   	ret    
	unsigned count=0;
8010652d:	89 c2                	mov    %eax,%edx
	return count;
8010652f:	eb f8                	jmp    80106529 <getnumofBits+0x16>

80106531 <nextPowerOf2>:
unsigned int nextPowerOf2(unsigned int n)
{
80106531:	55                   	push   %ebp
80106532:	89 e5                	mov    %esp,%ebp
80106534:	83 ec 08             	sub    $0x8,%esp
80106537:	8b 55 08             	mov    0x8(%ebp),%edx
	if(n>=0 && n<8)
		return 8;
8010653a:	b8 08 00 00 00       	mov    $0x8,%eax
	if(n>=0 && n<8)
8010653f:	83 fa 07             	cmp    $0x7,%edx
80106542:	76 1e                	jbe    80106562 <nextPowerOf2+0x31>
	if(n && !(n&(n-1)))
80106544:	8d 4a ff             	lea    -0x1(%edx),%ecx
		return n;
80106547:	89 d0                	mov    %edx,%eax
	if(n && !(n&(n-1)))
80106549:	85 d1                	test   %edx,%ecx
8010654b:	74 15                	je     80106562 <nextPowerOf2+0x31>
	return 1<<getnumofBits(n);
8010654d:	83 ec 0c             	sub    $0xc,%esp
80106550:	52                   	push   %edx
80106551:	e8 bd ff ff ff       	call   80106513 <getnumofBits>
80106556:	83 c4 10             	add    $0x10,%esp
80106559:	89 c1                	mov    %eax,%ecx
8010655b:	b8 01 00 00 00       	mov    $0x1,%eax
80106560:	d3 e0                	shl    %cl,%eax
}
80106562:	c9                   	leave  
80106563:	c3                   	ret    

80106564 <getslabIdx>:
unsigned int getslabIdx(unsigned int n)
{
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 14             	sub    $0x14,%esp
	unsigned slabIdx=getnumofBits(n)-4;
8010656a:	ff 75 08             	push   0x8(%ebp)
8010656d:	e8 a1 ff ff ff       	call   80106513 <getnumofBits>
80106572:	83 c4 10             	add    $0x10,%esp
80106575:	83 e8 04             	sub    $0x4,%eax
	return slabIdx;
}
80106578:	c9                   	leave  
80106579:	c3                   	ret    

8010657a <returnOffset>:
	struct spinlock lock;
	struct slab slab[NSLAB];
} stable;

int returnOffset(int row,int column)
{
8010657a:	55                   	push   %ebp
8010657b:	89 e5                	mov    %esp,%ebp
	return 8*row + column;
8010657d:	8b 45 08             	mov    0x8(%ebp),%eax
80106580:	c1 e0 03             	shl    $0x3,%eax
80106583:	03 45 0c             	add    0xc(%ebp),%eax
}
80106586:	5d                   	pop    %ebp
80106587:	c3                   	ret    

80106588 <setBitmap>:

int setBitmap(int slabIdx)
{
80106588:	55                   	push   %ebp
80106589:	89 e5                	mov    %esp,%ebp
8010658b:	56                   	push   %esi
8010658c:	53                   	push   %ebx
	{
		if(s->bitmap[j]==0xFF)
			continue;
		for(int k=0;k<=7;k++)
		{
			if(!(s->bitmap[j]&(1<<k)))
8010658d:	69 45 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%eax
80106594:	8b b0 68 3e 11 80    	mov    -0x7feec198(%eax),%esi
	for(int j=0;j<PGSIZE;j++)
8010659a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010659f:	eb 1c                	jmp    801065bd <setBitmap+0x35>
		for(int k=0;k<=7;k++)
801065a1:	b8 00 00 00 00       	mov    $0x0,%eax
	return num | (1<<i);
801065a6:	0f ab c2             	bts    %eax,%edx
			{
				s->bitmap[j]=set_bit(s->bitmap[j],k);
801065a9:	88 13                	mov    %dl,(%ebx)
	return 8*row + column;
801065ab:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				return returnOffset(j,k);
			}
		}
	}
	return 0; //Unable to find empty space of bitmap
}
801065ae:	5b                   	pop    %ebx
801065af:	5e                   	pop    %esi
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
	for(int j=0;j<PGSIZE;j++)
801065b2:	83 c1 01             	add    $0x1,%ecx
801065b5:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
801065bb:	74 22                	je     801065df <setBitmap+0x57>
			if(!(s->bitmap[j]&(1<<k)))
801065bd:	8d 1c 0e             	lea    (%esi,%ecx,1),%ebx
801065c0:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
801065c4:	0f be d0             	movsbl %al,%edx
801065c7:	a8 01                	test   $0x1,%al
801065c9:	74 d6                	je     801065a1 <setBitmap+0x19>
		for(int k=0;k<=7;k++)
801065cb:	b8 01 00 00 00       	mov    $0x1,%eax
			if(!(s->bitmap[j]&(1<<k)))
801065d0:	0f a3 c2             	bt     %eax,%edx
801065d3:	73 d1                	jae    801065a6 <setBitmap+0x1e>
		for(int k=0;k<=7;k++)
801065d5:	83 c0 01             	add    $0x1,%eax
801065d8:	83 f8 08             	cmp    $0x8,%eax
801065db:	75 f3                	jne    801065d0 <setBitmap+0x48>
801065dd:	eb d3                	jmp    801065b2 <setBitmap+0x2a>
	return 0; //Unable to find empty space of bitmap
801065df:	b8 00 00 00 00       	mov    $0x0,%eax
801065e4:	eb c8                	jmp    801065ae <setBitmap+0x26>

801065e6 <getRow>:

int getRow(int offset)
{
801065e6:	55                   	push   %ebp
801065e7:	89 e5                	mov    %esp,%ebp
801065e9:	8b 55 08             	mov    0x8(%ebp),%edx
	return offset/8;
801065ec:	8d 42 07             	lea    0x7(%edx),%eax
801065ef:	85 d2                	test   %edx,%edx
801065f1:	0f 49 c2             	cmovns %edx,%eax
801065f4:	c1 f8 03             	sar    $0x3,%eax
}
801065f7:	5d                   	pop    %ebp
801065f8:	c3                   	ret    

801065f9 <getColumn>:
int getColumn(int offset)
{
801065f9:	55                   	push   %ebp
801065fa:	89 e5                	mov    %esp,%ebp
801065fc:	8b 45 08             	mov    0x8(%ebp),%eax
	return offset%8;
801065ff:	99                   	cltd   
80106600:	c1 ea 1d             	shr    $0x1d,%edx
80106603:	01 d0                	add    %edx,%eax
80106605:	83 e0 07             	and    $0x7,%eax
80106608:	29 d0                	sub    %edx,%eax
}
8010660a:	5d                   	pop    %ebp
8010660b:	c3                   	ret    

8010660c <clearBitmap>:
bool clearBitmap(int slabIdx,int offset)
{
8010660c:	55                   	push   %ebp
8010660d:	89 e5                	mov    %esp,%ebp
8010660f:	53                   	push   %ebx
80106610:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct slab *s;
	s=&stable.slab[slabIdx];
	bool checkbit=true;
	int row=getRow(offset);
	int column=getColumn(offset);
	if(get_bit(s->bitmap[row],column))
80106613:	69 4d 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%ecx
	return offset/8;
8010661a:	8d 42 07             	lea    0x7(%edx),%eax
8010661d:	85 d2                	test   %edx,%edx
8010661f:	0f 49 c2             	cmovns %edx,%eax
80106622:	c1 f8 03             	sar    $0x3,%eax
	if(get_bit(s->bitmap[row],column))
80106625:	03 81 68 3e 11 80    	add    -0x7feec198(%ecx),%eax
8010662b:	0f be 08             	movsbl (%eax),%ecx
	return ((num&(1<<i))!=0);
8010662e:	83 e2 07             	and    $0x7,%edx
		s->bitmap[row]=clear_bit(s->bitmap[row],column);
	else
		checkbit=false;
80106631:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(get_bit(s->bitmap[row],column))
80106636:	0f a3 d1             	bt     %edx,%ecx
80106639:	73 0a                	jae    80106645 <clearBitmap+0x39>
	return num&mask;
8010663b:	0f b3 d1             	btr    %edx,%ecx
		s->bitmap[row]=clear_bit(s->bitmap[row],column);
8010663e:	88 08                	mov    %cl,(%eax)
	bool checkbit=true;
80106640:	bb 01 00 00 00       	mov    $0x1,%ebx
	return checkbit;
}
80106645:	89 d8                	mov    %ebx,%eax
80106647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010664a:	c9                   	leave  
8010664b:	c3                   	ret    

8010664c <checkEmpty>:

bool checkEmpty(int startOffset,int endOffset,int slabIdx)
{
8010664c:	55                   	push   %ebp
8010664d:	89 e5                	mov    %esp,%ebp
8010664f:	57                   	push   %edi
80106650:	56                   	push   %esi
80106651:	53                   	push   %ebx
80106652:	83 ec 08             	sub    $0x8,%esp
80106655:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106658:	8b 45 0c             	mov    0xc(%ebp),%eax
	return offset/8;
8010665b:	8d 51 07             	lea    0x7(%ecx),%edx
8010665e:	85 c9                	test   %ecx,%ecx
80106660:	0f 49 d1             	cmovns %ecx,%edx
80106663:	89 d7                	mov    %edx,%edi
80106665:	c1 ff 03             	sar    $0x3,%edi
	return offset%8;
80106668:	89 ca                	mov    %ecx,%edx
8010666a:	c1 fa 1f             	sar    $0x1f,%edx
8010666d:	c1 ea 1d             	shr    $0x1d,%edx
80106670:	8d 34 11             	lea    (%ecx,%edx,1),%esi
80106673:	83 e6 07             	and    $0x7,%esi
80106676:	29 d6                	sub    %edx,%esi
	return offset/8;
80106678:	8d 50 07             	lea    0x7(%eax),%edx
8010667b:	85 c0                	test   %eax,%eax
8010667d:	0f 49 d0             	cmovns %eax,%edx
80106680:	c1 fa 03             	sar    $0x3,%edx
80106683:	89 55 f0             	mov    %edx,-0x10(%ebp)
	return offset%8;
80106686:	99                   	cltd   
80106687:	c1 ea 1d             	shr    $0x1d,%edx
8010668a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010668d:	01 c2                	add    %eax,%edx
8010668f:	83 e2 07             	and    $0x7,%edx
80106692:	2b 55 ec             	sub    -0x14(%ebp),%edx
	int startColumn=getColumn(startOffset);
	int endRow=getRow(endOffset);
	int endColumn=getColumn(endOffset);
	// cprintf("startOffset: %d, endOffset %d\n",startOffset,endOffset);
	// cprintf("startRow:%d endRow:%d\n",startRow,endRow);
	for(int i=startRow;i<=endRow;i++)
80106695:	39 7d f0             	cmp    %edi,-0x10(%ebp)
80106698:	7c 58                	jl     801066f2 <checkEmpty+0xa6>
8010669a:	89 fb                	mov    %edi,%ebx
8010669c:	83 e1 07             	and    $0x7,%ecx
8010669f:	b8 01 00 00 00       	mov    $0x1,%eax
801066a4:	d3 e0                	shl    %cl,%eax
801066a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	{
		for(int j=startColumn;j<=endColumn;j++)
		{
			if(get_bit(s->bitmap[i],j))
801066a9:	69 7d 10 a8 01 00 00 	imul   $0x1a8,0x10(%ebp),%edi
801066b0:	81 c7 20 3e 11 80    	add    $0x80113e20,%edi
801066b6:	eb 08                	jmp    801066c0 <checkEmpty+0x74>
	for(int i=startRow;i<=endRow;i++)
801066b8:	83 c3 01             	add    $0x1,%ebx
801066bb:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
801066be:	7f 39                	jg     801066f9 <checkEmpty+0xad>
		for(int j=startColumn;j<=endColumn;j++)
801066c0:	39 f2                	cmp    %esi,%edx
801066c2:	7c f4                	jl     801066b8 <checkEmpty+0x6c>
			if(get_bit(s->bitmap[i],j))
801066c4:	8b 47 48             	mov    0x48(%edi),%eax
801066c7:	0f be 0c 18          	movsbl (%eax,%ebx,1),%ecx
801066cb:	85 4d ec             	test   %ecx,-0x14(%ebp)
801066ce:	75 1b                	jne    801066eb <checkEmpty+0x9f>
		for(int j=startColumn;j<=endColumn;j++)
801066d0:	89 f0                	mov    %esi,%eax
801066d2:	83 c0 01             	add    $0x1,%eax
801066d5:	39 d0                	cmp    %edx,%eax
801066d7:	7f df                	jg     801066b8 <checkEmpty+0x6c>
			if(get_bit(s->bitmap[i],j))
801066d9:	0f a3 c1             	bt     %eax,%ecx
801066dc:	73 f4                	jae    801066d2 <checkEmpty+0x86>
801066de:	b8 00 00 00 00       	mov    $0x0,%eax
		}
		if(empty==false)
			break;
	}
	return empty;
}
801066e3:	83 c4 08             	add    $0x8,%esp
801066e6:	5b                   	pop    %ebx
801066e7:	5e                   	pop    %esi
801066e8:	5f                   	pop    %edi
801066e9:	5d                   	pop    %ebp
801066ea:	c3                   	ret    
			if(get_bit(s->bitmap[i],j))
801066eb:	b8 00 00 00 00       	mov    $0x0,%eax
801066f0:	eb f1                	jmp    801066e3 <checkEmpty+0x97>
	bool empty=true;
801066f2:	b8 01 00 00 00       	mov    $0x1,%eax
801066f7:	eb ea                	jmp    801066e3 <checkEmpty+0x97>
801066f9:	b8 01 00 00 00       	mov    $0x1,%eax
	return empty;
801066fe:	eb e3                	jmp    801066e3 <checkEmpty+0x97>

80106700 <checkNewpage>:

int checkNewpage(int slabIdx)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
80106706:	8b 7d 08             	mov    0x8(%ebp),%edi
	bool find0=false;
	for(int i=0;i<PGSIZE;i++)
	{
		for(int j=0;j<=7;j++)
		{
			if(get_bit(s->bitmap[i],j))
80106709:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
8010670f:	8b 88 68 3e 11 80    	mov    -0x7feec198(%eax),%ecx
80106715:	8d b1 00 10 00 00    	lea    0x1000(%ecx),%esi
	int cnt=0;
8010671b:	bb 00 00 00 00       	mov    $0x0,%ebx
80106720:	eb 07                	jmp    80106729 <checkNewpage+0x29>
	for(int i=0;i<PGSIZE;i++)
80106722:	83 c1 01             	add    $0x1,%ecx
80106725:	39 f1                	cmp    %esi,%ecx
80106727:	74 24                	je     8010674d <checkNewpage+0x4d>
			if(get_bit(s->bitmap[i],j))
80106729:	0f b6 01             	movzbl (%ecx),%eax
8010672c:	0f be d0             	movsbl %al,%edx
8010672f:	a8 01                	test   $0x1,%al
80106731:	74 1a                	je     8010674d <checkNewpage+0x4d>
				cnt++;
80106733:	83 c3 01             	add    $0x1,%ebx
		for(int j=0;j<=7;j++)
80106736:	b8 01 00 00 00       	mov    $0x1,%eax
			if(get_bit(s->bitmap[i],j))
8010673b:	0f a3 c2             	bt     %eax,%edx
8010673e:	73 0d                	jae    8010674d <checkNewpage+0x4d>
				cnt++;
80106740:	83 c3 01             	add    $0x1,%ebx
		for(int j=0;j<=7;j++)
80106743:	83 c0 01             	add    $0x1,%eax
80106746:	83 f8 08             	cmp    $0x8,%eax
80106749:	75 f0                	jne    8010673b <checkNewpage+0x3b>
8010674b:	eb d5                	jmp    80106722 <checkNewpage+0x22>
			}
		}
		if(find0)
			break;
	}
	if(cnt%s->num_objects_per_page==0)
8010674d:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106753:	8b 88 64 3e 11 80    	mov    -0x7feec19c(%eax),%ecx
80106759:	89 d8                	mov    %ebx,%eax
8010675b:	99                   	cltd   
8010675c:	f7 f9                	idiv   %ecx
8010675e:	89 d6                	mov    %edx,%esi
80106760:	85 d2                	test   %edx,%edx
80106762:	75 28                	jne    8010678c <checkNewpage+0x8c>
	{
		int startOffset=(cnt/s->num_objects_per_page)*s->num_objects_per_page;
80106764:	89 d8                	mov    %ebx,%eax
80106766:	99                   	cltd   
80106767:	f7 f9                	idiv   %ecx
80106769:	89 c3                	mov    %eax,%ebx
8010676b:	0f af d9             	imul   %ecx,%ebx
		int endOffset=(startOffset+s->num_objects_per_page)-1;
		if(checkEmpty(startOffset,endOffset,slabIdx))
8010676e:	57                   	push   %edi
		int endOffset=(startOffset+s->num_objects_per_page)-1;
8010676f:	8d 44 19 ff          	lea    -0x1(%ecx,%ebx,1),%eax
		if(checkEmpty(startOffset,endOffset,slabIdx))
80106773:	50                   	push   %eax
80106774:	53                   	push   %ebx
80106775:	e8 d2 fe ff ff       	call   8010664c <checkEmpty>
8010677a:	83 c4 0c             	add    $0xc,%esp
		{
			return startOffset;
8010677d:	84 c0                	test   %al,%al
8010677f:	0f 45 f3             	cmovne %ebx,%esi
		}
	}
	return 0;
}
80106782:	89 f0                	mov    %esi,%eax
80106784:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106787:	5b                   	pop    %ebx
80106788:	5e                   	pop    %esi
80106789:	5f                   	pop    %edi
8010678a:	5d                   	pop    %ebp
8010678b:	c3                   	ret    
	return 0;
8010678c:	be 00 00 00 00       	mov    $0x0,%esi
80106791:	eb ef                	jmp    80106782 <checkNewpage+0x82>

80106793 <getpageNum>:


int getpageNum(int slabIdx)
{
80106793:	55                   	push   %ebp
80106794:	89 e5                	mov    %esp,%ebp
80106796:	57                   	push   %edi
80106797:	56                   	push   %esi
80106798:	53                   	push   %ebx
80106799:	83 ec 04             	sub    $0x4,%esp
8010679c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	struct slab *s;
	s=&stable.slab[slabIdx];
	int page=0;
	//size 2048 - 1024
	if(slabIdx>=7)
8010679f:	83 f9 06             	cmp    $0x6,%ecx
801067a2:	7f 2d                	jg     801067d1 <getpageNum+0x3e>
	//size 8 - 512
	else
	{
		for(int i=0;i<PGSIZE;i+=(512/s->size))
		{
			for(int j=i;j<i+(512/s->size);j++)
801067a4:	69 f9 a8 01 00 00    	imul   $0x1a8,%ecx,%edi
801067aa:	b8 00 02 00 00       	mov    $0x200,%eax
801067af:	99                   	cltd   
801067b0:	f7 bf 54 3e 11 80    	idivl  -0x7feec1ac(%edi)
801067b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067b9:	ba 00 00 00 00       	mov    $0x0,%edx
	int page=0;
801067be:	bf 00 00 00 00       	mov    $0x0,%edi
			{
				if(s->bitmap[j]!=0x00)
801067c3:	69 c9 a8 01 00 00    	imul   $0x1a8,%ecx,%ecx
801067c9:	81 c1 20 3e 11 80    	add    $0x80113e20,%ecx
801067cf:	eb 75                	jmp    80106846 <getpageNum+0xb3>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
801067d1:	69 f9 a8 01 00 00    	imul   $0x1a8,%ecx,%edi
801067d7:	b8 00 10 00 00       	mov    $0x1000,%eax
801067dc:	99                   	cltd   
801067dd:	f7 bf 54 3e 11 80    	idivl  -0x7feec1ac(%edi)
801067e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for(int i=0;i<PGSIZE;i++)
801067e6:	bb 00 00 00 00       	mov    $0x0,%ebx
	int page=0;
801067eb:	bf 00 00 00 00       	mov    $0x0,%edi
					if(get_bit(s->bitmap[i],k))
801067f0:	69 c9 a8 01 00 00    	imul   $0x1a8,%ecx,%ecx
801067f6:	8d b1 20 3e 11 80    	lea    -0x7feec1e0(%ecx),%esi
801067fc:	eb 36                	jmp    80106834 <getpageNum+0xa1>
						page++;
801067fe:	83 c7 01             	add    $0x1,%edi
			for(int j=0;j<=7;j+=(PGSIZE/s->size))
80106801:	83 fa 07             	cmp    $0x7,%edx
80106804:	7f 23                	jg     80106829 <getpageNum+0x96>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
80106806:	89 d0                	mov    %edx,%eax
80106808:	03 55 f0             	add    -0x10(%ebp),%edx
8010680b:	39 c2                	cmp    %eax,%edx
8010680d:	7e f2                	jle    80106801 <getpageNum+0x6e>
					if(get_bit(s->bitmap[i],k))
8010680f:	8b 4e 48             	mov    0x48(%esi),%ecx
80106812:	0f be 0c 19          	movsbl (%ecx,%ebx,1),%ecx
80106816:	0f a3 c1             	bt     %eax,%ecx
80106819:	72 e3                	jb     801067fe <getpageNum+0x6b>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
8010681b:	83 c0 01             	add    $0x1,%eax
8010681e:	39 d0                	cmp    %edx,%eax
80106820:	74 df                	je     80106801 <getpageNum+0x6e>
					if(get_bit(s->bitmap[i],k))
80106822:	0f a3 c1             	bt     %eax,%ecx
80106825:	73 f4                	jae    8010681b <getpageNum+0x88>
80106827:	eb d5                	jmp    801067fe <getpageNum+0x6b>
		for(int i=0;i<PGSIZE;i++)
80106829:	83 c3 01             	add    $0x1,%ebx
8010682c:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80106832:	74 35                	je     80106869 <getpageNum+0xd6>
			for(int j=0;j<=7;j+=(PGSIZE/s->size))
80106834:	ba 00 00 00 00       	mov    $0x0,%edx
80106839:	eb cb                	jmp    80106806 <getpageNum+0x73>
				{
					page++;
8010683b:	83 c7 01             	add    $0x1,%edi
		for(int i=0;i<PGSIZE;i+=(512/s->size))
8010683e:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106844:	7f 23                	jg     80106869 <getpageNum+0xd6>
80106846:	89 d6                	mov    %edx,%esi
			for(int j=i;j<i+(512/s->size);j++)
80106848:	89 d0                	mov    %edx,%eax
8010684a:	03 55 f0             	add    -0x10(%ebp),%edx
8010684d:	89 d3                	mov    %edx,%ebx
8010684f:	39 f2                	cmp    %esi,%edx
80106851:	7e eb                	jle    8010683e <getpageNum+0xab>
80106853:	03 41 48             	add    0x48(%ecx),%eax
80106856:	89 d6                	mov    %edx,%esi
80106858:	03 71 48             	add    0x48(%ecx),%esi
				if(s->bitmap[j]!=0x00)
8010685b:	80 38 00             	cmpb   $0x0,(%eax)
8010685e:	75 db                	jne    8010683b <getpageNum+0xa8>
			for(int j=i;j<i+(512/s->size);j++)
80106860:	83 c0 01             	add    $0x1,%eax
80106863:	39 f0                	cmp    %esi,%eax
80106865:	75 f4                	jne    8010685b <getpageNum+0xc8>
80106867:	eb d5                	jmp    8010683e <getpageNum+0xab>
				}
			}
		}
	}
	return page;
}
80106869:	89 f8                	mov    %edi,%eax
8010686b:	83 c4 04             	add    $0x4,%esp
8010686e:	5b                   	pop    %ebx
8010686f:	5e                   	pop    %esi
80106870:	5f                   	pop    %edi
80106871:	5d                   	pop    %ebp
80106872:	c3                   	ret    

80106873 <slabinit>:

void slabinit()
{
80106873:	55                   	push   %ebp
80106874:	89 e5                	mov    %esp,%ebp
80106876:	57                   	push   %edi
80106877:	56                   	push   %esi
80106878:	53                   	push   %ebx
80106879:	83 ec 18             	sub    $0x18,%esp
	acquire(&stable.lock);
8010687c:	68 20 3e 11 80       	push   $0x80113e20
80106881:	e8 7b d4 ff ff       	call   80103d01 <acquire>
	stable.slab[0].size=8;
80106886:	c7 05 54 3e 11 80 08 	movl   $0x8,0x80113e54
8010688d:	00 00 00 
	stable.slab[0].num_objects_per_page=PGSIZE/stable.slab[0].size;
80106890:	c7 05 64 3e 11 80 00 	movl   $0x200,0x80113e64
80106897:	02 00 00 
	stable.slab[0].num_used_objects=0;
8010689a:	c7 05 60 3e 11 80 00 	movl   $0x0,0x80113e60
801068a1:	00 00 00 
	stable.slab[0].num_free_objects=stable.slab[0].num_objects_per_page*64;
801068a4:	c7 05 5c 3e 11 80 00 	movl   $0x8000,0x80113e5c
801068ab:	80 00 00 
	//allocate one page for bitmap, allocate one page for slab cache
	stable.slab[0].bitmap=stable.slab[0].page[0];
801068ae:	a1 6c 3e 11 80       	mov    0x80113e6c,%eax
801068b3:	a3 68 3e 11 80       	mov    %eax,0x80113e68
	stable.slab[0].bitmap=kalloc();
801068b8:	e8 8d b8 ff ff       	call   8010214a <kalloc>
801068bd:	a3 68 3e 11 80       	mov    %eax,0x80113e68
	memset(stable.slab[0].bitmap,0,PGSIZE);
801068c2:	83 c4 0c             	add    $0xc,%esp
801068c5:	68 00 10 00 00       	push   $0x1000
801068ca:	6a 00                	push   $0x0
801068cc:	50                   	push   %eax
801068cd:	e8 dd d4 ff ff       	call   80103daf <memset>
	stable.slab[0].page[1]=kalloc();
801068d2:	e8 73 b8 ff ff       	call   8010214a <kalloc>
801068d7:	a3 70 3e 11 80       	mov    %eax,0x80113e70
	stable.slab[0].num_pages=1;
801068dc:	c7 05 58 3e 11 80 01 	movl   $0x1,0x80113e58
801068e3:	00 00 00 
	release(&stable.lock);
801068e6:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801068ed:	e8 76 d4 ff ff       	call   80103d68 <release>

	acquire(&stable.lock);
801068f2:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801068f9:	e8 03 d4 ff ff       	call   80103d01 <acquire>
	for(int i=1;i<NSLAB;i++)
801068fe:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
80106903:	bf 94 4b 11 80       	mov    $0x80114b94,%edi
80106908:	83 c4 10             	add    $0x10,%esp
	{
		stable.slab[i].size=stable.slab[i-1].size*2;
		stable.slab[i].num_objects_per_page=PGSIZE/stable.slab[i].size;
8010690b:	be 00 10 00 00       	mov    $0x1000,%esi
		stable.slab[i].size=stable.slab[i-1].size*2;
80106910:	8b 03                	mov    (%ebx),%eax
80106912:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80106915:	89 8b a8 01 00 00    	mov    %ecx,0x1a8(%ebx)
		stable.slab[i].num_objects_per_page=PGSIZE/stable.slab[i].size;
8010691b:	89 f0                	mov    %esi,%eax
8010691d:	99                   	cltd   
8010691e:	f7 f9                	idiv   %ecx
80106920:	89 83 b8 01 00 00    	mov    %eax,0x1b8(%ebx)
		stable.slab[i].num_used_objects=0;
80106926:	c7 83 b4 01 00 00 00 	movl   $0x0,0x1b4(%ebx)
8010692d:	00 00 00 
		stable.slab[i].num_free_objects=stable.slab[i].num_objects_per_page*MAX_PAGES_PER_SLAB;
80106930:	6b c0 64             	imul   $0x64,%eax,%eax
80106933:	89 83 b0 01 00 00    	mov    %eax,0x1b0(%ebx)
		//allocate one page for bitmap, allocate one page for slab cache
		stable.slab[i].bitmap=stable.slab[i].page[0];
80106939:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
8010693f:	89 83 bc 01 00 00    	mov    %eax,0x1bc(%ebx)
		stable.slab[i].bitmap=kalloc();
80106945:	e8 00 b8 ff ff       	call   8010214a <kalloc>
8010694a:	89 83 bc 01 00 00    	mov    %eax,0x1bc(%ebx)
		memset(stable.slab[i].bitmap,0,PGSIZE);
80106950:	83 ec 04             	sub    $0x4,%esp
80106953:	68 00 10 00 00       	push   $0x1000
80106958:	6a 00                	push   $0x0
8010695a:	50                   	push   %eax
8010695b:	e8 4f d4 ff ff       	call   80103daf <memset>
		stable.slab[i].page[1]=kalloc();
80106960:	e8 e5 b7 ff ff       	call   8010214a <kalloc>
80106965:	89 83 c4 01 00 00    	mov    %eax,0x1c4(%ebx)
		stable.slab[i].num_pages=1;
8010696b:	c7 83 ac 01 00 00 01 	movl   $0x1,0x1ac(%ebx)
80106972:	00 00 00 
	for(int i=1;i<NSLAB;i++)
80106975:	81 c3 a8 01 00 00    	add    $0x1a8,%ebx
8010697b:	83 c4 10             	add    $0x10,%esp
8010697e:	39 fb                	cmp    %edi,%ebx
80106980:	75 8e                	jne    80106910 <slabinit+0x9d>
	}
	release(&stable.lock);
80106982:	83 ec 0c             	sub    $0xc,%esp
80106985:	68 20 3e 11 80       	push   $0x80113e20
8010698a:	e8 d9 d3 ff ff       	call   80103d68 <release>
}
8010698f:	83 c4 10             	add    $0x10,%esp
80106992:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106995:	5b                   	pop    %ebx
80106996:	5e                   	pop    %esi
80106997:	5f                   	pop    %edi
80106998:	5d                   	pop    %ebp
80106999:	c3                   	ret    

8010699a <kmalloc>:
char *kmalloc(int size){
8010699a:	55                   	push   %ebp
8010699b:	89 e5                	mov    %esp,%ebp
8010699d:	57                   	push   %edi
8010699e:	56                   	push   %esi
8010699f:	53                   	push   %ebx
801069a0:	83 ec 0c             	sub    $0xc,%esp
801069a3:	8b 7d 08             	mov    0x8(%ebp),%edi
	
	//out of range error needs to be handled
	if(size > 2048 || size<=0)
801069a6:	8d 57 ff             	lea    -0x1(%edi),%edx
		return 0;
801069a9:	b8 00 00 00 00       	mov    $0x0,%eax
	if(size > 2048 || size<=0)
801069ae:	81 fa ff 07 00 00    	cmp    $0x7ff,%edx
801069b4:	0f 87 dc 00 00 00    	ja     80106a96 <kmalloc+0xfc>
	//choose the byte 8 or 16 .. etc by getting index of slab
	int slabIdx=getslabIdx(nextPowerOf2(size));
801069ba:	83 ec 0c             	sub    $0xc,%esp
801069bd:	57                   	push   %edi
801069be:	e8 6e fb ff ff       	call   80106531 <nextPowerOf2>
801069c3:	89 04 24             	mov    %eax,(%esp)
801069c6:	e8 99 fb ff ff       	call   80106564 <getslabIdx>
801069cb:	83 c4 10             	add    $0x10,%esp
801069ce:	89 c3                	mov    %eax,%ebx
	struct slab *s;
	s=&stable.slab[slabIdx];
	//can't alloc if num of used object is full
	if(s->num_used_objects==s->num_objects_per_page*MAX_PAGES_PER_SLAB)
801069d0:	69 c0 a8 01 00 00    	imul   $0x1a8,%eax,%eax
801069d6:	6b 90 64 3e 11 80 64 	imul   $0x64,-0x7feec19c(%eax),%edx
801069dd:	39 90 60 3e 11 80    	cmp    %edx,-0x7feec1a0(%eax)
801069e3:	0f 84 db 00 00 00    	je     80106ac4 <kmalloc+0x12a>
		return 0;
	if(stable.slab[0].num_used_objects==stable.slab[0].num_objects_per_page*64)
801069e9:	a1 64 3e 11 80       	mov    0x80113e64,%eax
801069ee:	c1 e0 06             	shl    $0x6,%eax
801069f1:	39 05 60 3e 11 80    	cmp    %eax,0x80113e60
801069f7:	0f 84 ce 00 00 00    	je     80106acb <kmalloc+0x131>
		return 0;
	
	int startOffset=0;
	acquire(&stable.lock);
801069fd:	83 ec 0c             	sub    $0xc,%esp
80106a00:	68 20 3e 11 80       	push   $0x80113e20
80106a05:	e8 f7 d2 ff ff       	call   80103d01 <acquire>
	if((startOffset=checkNewpage(slabIdx)) && s->num_used_objects!=0)
80106a0a:	89 1c 24             	mov    %ebx,(%esp)
80106a0d:	e8 ee fc ff ff       	call   80106700 <checkNewpage>
80106a12:	83 c4 10             	add    $0x10,%esp
80106a15:	85 c0                	test   %eax,%eax
80106a17:	74 0f                	je     80106a28 <kmalloc+0x8e>
80106a19:	69 d3 a8 01 00 00    	imul   $0x1a8,%ebx,%edx
80106a1f:	83 ba 60 3e 11 80 00 	cmpl   $0x0,-0x7feec1a0(%edx)
80106a26:	75 76                	jne    80106a9e <kmalloc+0x104>
	{
		s->page[startOffset/s->num_objects_per_page+1]=kalloc(); //current page +1
	}
	
	int bitOffset=setBitmap(slabIdx);
80106a28:	83 ec 0c             	sub    $0xc,%esp
80106a2b:	53                   	push   %ebx
80106a2c:	e8 57 fb ff ff       	call   80106588 <setBitmap>
80106a31:	89 c6                	mov    %eax,%esi
	//getPageNumfrom bitmap
	s->num_pages=getpageNum(slabIdx);
80106a33:	89 1c 24             	mov    %ebx,(%esp)
80106a36:	e8 58 fd ff ff       	call   80106793 <getpageNum>
80106a3b:	83 c4 0c             	add    $0xc,%esp
80106a3e:	69 d3 a8 01 00 00    	imul   $0x1a8,%ebx,%edx
80106a44:	8d 8a 20 3e 11 80    	lea    -0x7feec1e0(%edx),%ecx
80106a4a:	89 82 58 3e 11 80    	mov    %eax,-0x7feec1a8(%edx)
	s->num_free_objects-=1;
80106a50:	83 69 3c 01          	subl   $0x1,0x3c(%ecx)
	s->num_used_objects+=1;
80106a54:	83 41 40 01          	addl   $0x1,0x40(%ecx)

	int nowpage=bitOffset/s->num_objects_per_page+1;
80106a58:	89 f0                	mov    %esi,%eax
80106a5a:	99                   	cltd   
80106a5b:	f7 79 44             	idivl  0x44(%ecx)
	int pageOffset=(bitOffset%s->num_objects_per_page)*(1<<(slabIdx+3))*sizeof(char);
80106a5e:	8d 4b 03             	lea    0x3(%ebx),%ecx
80106a61:	89 d6                	mov    %edx,%esi
80106a63:	d3 e6                	shl    %cl,%esi
	memset(s->page[nowpage]+pageOffset,0,size*sizeof(char));
80106a65:	57                   	push   %edi
80106a66:	6a 00                	push   $0x0
80106a68:	6b db 6a             	imul   $0x6a,%ebx,%ebx
80106a6b:	8d 5c 18 11          	lea    0x11(%eax,%ebx,1),%ebx
80106a6f:	89 f0                	mov    %esi,%eax
80106a71:	03 04 9d 2c 3e 11 80 	add    -0x7feec1d4(,%ebx,4),%eax
80106a78:	50                   	push   %eax
80106a79:	e8 31 d3 ff ff       	call   80103daf <memset>
	release(&stable.lock);
80106a7e:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80106a85:	e8 de d2 ff ff       	call   80103d68 <release>
	return s->page[nowpage]+pageOffset;
80106a8a:	89 f0                	mov    %esi,%eax
80106a8c:	03 04 9d 2c 3e 11 80 	add    -0x7feec1d4(,%ebx,4),%eax
80106a93:	83 c4 10             	add    $0x10,%esp
}
80106a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a99:	5b                   	pop    %ebx
80106a9a:	5e                   	pop    %esi
80106a9b:	5f                   	pop    %edi
80106a9c:	5d                   	pop    %ebp
80106a9d:	c3                   	ret    
		s->page[startOffset/s->num_objects_per_page+1]=kalloc(); //current page +1
80106a9e:	89 d1                	mov    %edx,%ecx
80106aa0:	99                   	cltd   
80106aa1:	f7 b9 64 3e 11 80    	idivl  -0x7feec19c(%ecx)
80106aa7:	8d 70 01             	lea    0x1(%eax),%esi
80106aaa:	e8 9b b6 ff ff       	call   8010214a <kalloc>
80106aaf:	89 c2                	mov    %eax,%edx
80106ab1:	6b c3 6a             	imul   $0x6a,%ebx,%eax
80106ab4:	8d 44 06 10          	lea    0x10(%esi,%eax,1),%eax
80106ab8:	89 14 85 2c 3e 11 80 	mov    %edx,-0x7feec1d4(,%eax,4)
80106abf:	e9 64 ff ff ff       	jmp    80106a28 <kmalloc+0x8e>
		return 0;
80106ac4:	b8 00 00 00 00       	mov    $0x0,%eax
80106ac9:	eb cb                	jmp    80106a96 <kmalloc+0xfc>
		return 0;
80106acb:	b8 00 00 00 00       	mov    $0x0,%eax
80106ad0:	eb c4                	jmp    80106a96 <kmalloc+0xfc>

80106ad2 <kmfree>:

void kmfree(char *addr, int size){
80106ad2:	55                   	push   %ebp
80106ad3:	89 e5                	mov    %esp,%ebp
80106ad5:	57                   	push   %edi
80106ad6:	56                   	push   %esi
80106ad7:	53                   	push   %ebx
80106ad8:	83 ec 28             	sub    $0x28,%esp
80106adb:	8b 75 08             	mov    0x8(%ebp),%esi
80106ade:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct slab *s;
	int slabIdx=getslabIdx(size);
80106ae1:	53                   	push   %ebx
80106ae2:	e8 7d fa ff ff       	call   80106564 <getslabIdx>
80106ae7:	89 c7                	mov    %eax,%edi
	s=&stable.slab[slabIdx];

	acquire(&stable.lock);
80106ae9:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80106af0:	e8 0c d2 ff ff       	call   80103d01 <acquire>
	if(s->num_used_objects==0)
80106af5:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106afb:	83 c4 10             	add    $0x10,%esp
80106afe:	83 b8 60 3e 11 80 00 	cmpl   $0x0,-0x7feec1a0(%eax)
80106b05:	74 2f                	je     80106b36 <kmfree+0x64>
		release(&stable.lock);
		return;
	}

	//set the garbage in slab;
	memset(addr,1,size); 
80106b07:	83 ec 04             	sub    $0x4,%esp
80106b0a:	53                   	push   %ebx
80106b0b:	6a 01                	push   $0x1
80106b0d:	56                   	push   %esi
80106b0e:	e8 9c d2 ff ff       	call   80103daf <memset>
	//bitmap operation
	//get the adress page Number
	int pageNum=0;
	for(int i=1;i<=100;i++)
80106b13:	69 d7 a8 01 00 00    	imul   $0x1a8,%edi,%edx
80106b19:	83 c4 10             	add    $0x10,%esp
80106b1c:	bb 01 00 00 00       	mov    $0x1,%ebx
	{
		if(addr-s->page[i]>=0 && addr-s->page[i]<PGSIZE)
80106b21:	89 f0                	mov    %esi,%eax
80106b23:	2b 84 9a 6c 3e 11 80 	sub    -0x7feec194(%edx,%ebx,4),%eax
80106b2a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80106b2f:	76 1a                	jbe    80106b4b <kmfree+0x79>
	for(int i=1;i<=100;i++)
80106b31:	83 c3 01             	add    $0x1,%ebx
80106b34:	eb eb                	jmp    80106b21 <kmfree+0x4f>
		release(&stable.lock);
80106b36:	83 ec 0c             	sub    $0xc,%esp
80106b39:	68 20 3e 11 80       	push   $0x80113e20
80106b3e:	e8 25 d2 ff ff       	call   80103d68 <release>
		return;
80106b43:	83 c4 10             	add    $0x10,%esp
80106b46:	e9 91 00 00 00       	jmp    80106bdc <kmfree+0x10a>
			break;
		}
	}
	//get the offset to make 0 appropriate bitmap
	int offset=0;
	offset=((pageNum-1)*s->num_objects_per_page)+(addr-s->page[pageNum])/s->size;
80106b4b:	8d 43 ff             	lea    -0x1(%ebx),%eax
80106b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
	if(clearBitmap(slabIdx,offset))
80106b51:	83 ec 08             	sub    $0x8,%esp
	offset=((pageNum-1)*s->num_objects_per_page)+(addr-s->page[pageNum])/s->size;
80106b54:	6b c7 6a             	imul   $0x6a,%edi,%eax
80106b57:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80106b5b:	2b 34 85 2c 3e 11 80 	sub    -0x7feec1d4(,%eax,4),%esi
80106b62:	89 f0                	mov    %esi,%eax
80106b64:	69 cf a8 01 00 00    	imul   $0x1a8,%edi,%ecx
80106b6a:	99                   	cltd   
80106b6b:	f7 b9 54 3e 11 80    	idivl  -0x7feec1ac(%ecx)
80106b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b74:	0f af 91 64 3e 11 80 	imul   -0x7feec19c(%ecx),%edx
80106b7b:	01 d0                	add    %edx,%eax
	if(clearBitmap(slabIdx,offset))
80106b7d:	50                   	push   %eax
80106b7e:	57                   	push   %edi
80106b7f:	e8 88 fa ff ff       	call   8010660c <clearBitmap>
80106b84:	83 c4 10             	add    $0x10,%esp
80106b87:	84 c0                	test   %al,%al
80106b89:	74 14                	je     80106b9f <kmfree+0xcd>
	{
		stable.slab[slabIdx].num_free_objects+=1;
80106b8b:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106b91:	83 80 5c 3e 11 80 01 	addl   $0x1,-0x7feec1a4(%eax)
		stable.slab[slabIdx].num_used_objects-=1;
80106b98:	83 a8 60 3e 11 80 01 	subl   $0x1,-0x7feec1a0(%eax)
	}

	//page free
	int startOffset=(pageNum-1)*s->num_objects_per_page;
	int endOffset=(startOffset+s->num_objects_per_page)-1;
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106b9f:	83 fb 01             	cmp    $0x1,%ebx
80106ba2:	74 28                	je     80106bcc <kmfree+0xfa>
	int startOffset=(pageNum-1)*s->num_objects_per_page;
80106ba4:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106baa:	8b 90 64 3e 11 80    	mov    -0x7feec19c(%eax),%edx
80106bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bb3:	0f af c2             	imul   %edx,%eax
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106bb6:	83 ec 04             	sub    $0x4,%esp
80106bb9:	57                   	push   %edi
	int endOffset=(startOffset+s->num_objects_per_page)-1;
80106bba:	8d 54 02 ff          	lea    -0x1(%edx,%eax,1),%edx
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106bbe:	52                   	push   %edx
80106bbf:	50                   	push   %eax
80106bc0:	e8 87 fa ff ff       	call   8010664c <checkEmpty>
80106bc5:	83 c4 10             	add    $0x10,%esp
80106bc8:	84 c0                	test   %al,%al
80106bca:	75 18                	jne    80106be4 <kmfree+0x112>
	{
		kfree(s->page[pageNum]);
		s->num_pages-=1;
	}
	release(&stable.lock);
80106bcc:	83 ec 0c             	sub    $0xc,%esp
80106bcf:	68 20 3e 11 80       	push   $0x80113e20
80106bd4:	e8 8f d1 ff ff       	call   80103d68 <release>
80106bd9:	83 c4 10             	add    $0x10,%esp
	// return;
}
80106bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bdf:	5b                   	pop    %ebx
80106be0:	5e                   	pop    %esi
80106be1:	5f                   	pop    %edi
80106be2:	5d                   	pop    %ebp
80106be3:	c3                   	ret    
		kfree(s->page[pageNum]);
80106be4:	83 ec 0c             	sub    $0xc,%esp
80106be7:	6b c7 6a             	imul   $0x6a,%edi,%eax
80106bea:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80106bee:	ff 34 85 2c 3e 11 80 	push   -0x7feec1d4(,%eax,4)
80106bf5:	e8 02 b4 ff ff       	call   80101ffc <kfree>
		s->num_pages-=1;
80106bfa:	69 ff a8 01 00 00    	imul   $0x1a8,%edi,%edi
80106c00:	83 af 58 3e 11 80 01 	subl   $0x1,-0x7feec1a8(%edi)
80106c07:	83 c4 10             	add    $0x10,%esp
80106c0a:	eb c0                	jmp    80106bcc <kmfree+0xfa>

80106c0c <slabdump>:
// 	for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
// 		cprintf("%d\t%d\t\t%d\t\t%d\n", 
// 			s->size, s->num_pages, s->num_used_objects, s->num_free_objects);
// 	}
// }
void slabdump(){
80106c0c:	55                   	push   %ebp
80106c0d:	89 e5                	mov    %esp,%ebp
80106c0f:	57                   	push   %edi
80106c10:	56                   	push   %esi
80106c11:	53                   	push   %ebx
80106c12:	83 ec 18             	sub    $0x18,%esp
    cprintf("__slabdump__\n");
80106c15:	68 b3 7f 10 80       	push   $0x80107fb3
80106c1a:	e8 e2 99 ff ff       	call   80100601 <cprintf>

    struct slab *s;

    cprintf("size\tnum_pages\tused_objects\tfree_objects\n");
80106c1f:	c7 04 24 dc 7f 10 80 	movl   $0x80107fdc,(%esp)
80106c26:	e8 d6 99 ff ff       	call   80100601 <cprintf>
80106c2b:	83 c4 10             	add    $0x10,%esp

    for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
80106c2e:	bf 54 3e 11 80       	mov    $0x80113e54,%edi
80106c33:	eb 64                	jmp    80106c99 <slabdump+0x8d>
		{
			for(int j=7;j>=0;j--)
			{
				cprintf("%d",get_bit(s->bitmap[i],j));
			}
			cprintf(" ");
80106c35:	83 ec 0c             	sub    $0xc,%esp
80106c38:	68 d1 7b 10 80       	push   $0x80107bd1
80106c3d:	e8 bf 99 ff ff       	call   80100601 <cprintf>
		for(int i=0;i<60;i++)
80106c42:	83 c6 01             	add    $0x1,%esi
80106c45:	83 c4 10             	add    $0x10,%esp
80106c48:	83 fe 3c             	cmp    $0x3c,%esi
80106c4b:	74 2e                	je     80106c7b <slabdump+0x6f>
			for(int j=7;j>=0;j--)
80106c4d:	bb 07 00 00 00       	mov    $0x7,%ebx
				cprintf("%d",get_bit(s->bitmap[i],j));
80106c52:	83 ec 08             	sub    $0x8,%esp
80106c55:	8b 47 14             	mov    0x14(%edi),%eax
80106c58:	0f be 04 30          	movsbl (%eax,%esi,1),%eax
	return ((num&(1<<i))!=0);
80106c5c:	89 d9                	mov    %ebx,%ecx
80106c5e:	d3 f8                	sar    %cl,%eax
80106c60:	83 e0 01             	and    $0x1,%eax
				cprintf("%d",get_bit(s->bitmap[i],j));
80106c63:	50                   	push   %eax
80106c64:	68 d9 7f 10 80       	push   $0x80107fd9
80106c69:	e8 93 99 ff ff       	call   80100601 <cprintf>
			for(int j=7;j>=0;j--)
80106c6e:	83 eb 01             	sub    $0x1,%ebx
80106c71:	83 c4 10             	add    $0x10,%esp
80106c74:	83 fb ff             	cmp    $0xffffffff,%ebx
80106c77:	75 d9                	jne    80106c52 <slabdump+0x46>
80106c79:	eb ba                	jmp    80106c35 <slabdump+0x29>
		}
		cprintf("\n");
80106c7b:	83 ec 0c             	sub    $0xc,%esp
80106c7e:	68 3f 7f 10 80       	push   $0x80107f3f
80106c83:	e8 79 99 ff ff       	call   80100601 <cprintf>
    for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
80106c88:	81 c7 a8 01 00 00    	add    $0x1a8,%edi
80106c8e:	83 c4 10             	add    $0x10,%esp
80106c91:	81 ff 3c 4d 11 80    	cmp    $0x80114d3c,%edi
80106c97:	74 2f                	je     80106cc8 <slabdump+0xbc>
        cprintf("%d\t%d\t\t%d\t\t%d\n", 
80106c99:	83 ec 0c             	sub    $0xc,%esp
80106c9c:	ff 77 08             	push   0x8(%edi)
80106c9f:	ff 77 0c             	push   0xc(%edi)
80106ca2:	ff 77 04             	push   0x4(%edi)
80106ca5:	ff 37                	push   (%edi)
80106ca7:	68 c1 7f 10 80       	push   $0x80107fc1
80106cac:	e8 50 99 ff ff       	call   80100601 <cprintf>
        cprintf("Bitmap: ");
80106cb1:	83 c4 14             	add    $0x14,%esp
80106cb4:	68 d0 7f 10 80       	push   $0x80107fd0
80106cb9:	e8 43 99 ff ff       	call   80100601 <cprintf>
80106cbe:	83 c4 10             	add    $0x10,%esp
		for(int i=0;i<60;i++)
80106cc1:	be 00 00 00 00       	mov    $0x0,%esi
80106cc6:	eb 85                	jmp    80106c4d <slabdump+0x41>
    }
}
80106cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ccb:	5b                   	pop    %ebx
80106ccc:	5e                   	pop    %esi
80106ccd:	5f                   	pop    %edi
80106cce:	5d                   	pop    %ebp
80106ccf:	c3                   	ret    

80106cd0 <numobj_slab>:

int numobj_slab(int slabid)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
	return stable.slab[slabid].num_used_objects;
80106cd3:	69 45 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%eax
80106cda:	8b 80 60 3e 11 80    	mov    -0x7feec1a0(%eax),%eax
}
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret    

80106ce2 <slabtest>:
Thereby, you should pass all tests in the slabtest() function as is.
Note that, you can edit the test function only for the debugging purpose. 
*/
int* t[NSLAB][MAXTEST] = {};

void slabtest(){
80106ce2:	55                   	push   %ebp
80106ce3:	89 e5                	mov    %esp,%ebp
80106ce5:	57                   	push   %edi
80106ce6:	56                   	push   %esi
80106ce7:	53                   	push   %ebx
80106ce8:	83 ec 48             	sub    $0x48,%esp
	int counter = 1;
80106ceb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	 * to locate the VMA (virtual memory address) of an multiple of 4 bytes. 
	 * You can check the VMA of .stab by executing 'objdump -h kernel' in your xv6 source dir.
	 * If the VMA is not aligned to the multiple of 4B, then adjust (add/del chars) 
	 * the literal string in the cprintf function
	 */
	cprintf("==== SLAB TEST ====\n");
80106cf2:	68 11 80 10 80       	push   $0x80108011
80106cf7:	e8 05 99 ff ff       	call   80100601 <cprintf>
	 * cprintf();
	 * slabdump();
	 */

	/* TEST1: Single slab alloc */
	cprintf("==== TEST1 =====\n");
80106cfc:	c7 04 24 26 80 10 80 	movl   $0x80108026,(%esp)
80106d03:	e8 f9 98 ff ff       	call   80100601 <cprintf>
	start = counter;
80106d08:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	t[0][0] = (int*) kmalloc (TESTSIZE); 
80106d0b:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
80106d12:	e8 83 fc ff ff       	call   8010699a <kmalloc>
80106d17:	a3 40 4d 11 80       	mov    %eax,0x80114d40
	*(t[0][0]) = counter;
80106d1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d1f:	89 10                	mov    %edx,(%eax)
	counter++;
80106d21:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	slabdump();
80106d25:	e8 e2 fe ff ff       	call   80106c0c <slabdump>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
80106d2a:	83 c4 10             	add    $0x10,%esp
80106d2d:	b8 0a 80 10 80       	mov    $0x8010800a,%eax
80106d32:	8b 15 40 4d 11 80    	mov    0x80114d40,%edx
80106d38:	39 1a                	cmp    %ebx,(%edx)
80106d3a:	0f 84 a7 00 00 00    	je     80106de7 <slabtest+0x105>
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	50                   	push   %eax
80106d44:	e8 b8 98 ff ff       	call   80100601 <cprintf>
	kmfree ((char*) t[0][0], TESTSIZE);
80106d49:	83 c4 08             	add    $0x8,%esp
80106d4c:	68 00 08 00 00       	push   $0x800
80106d51:	ff 35 40 4d 11 80    	push   0x80114d40
80106d57:	e8 76 fd ff ff       	call   80106ad2 <kmfree>
	slabdump();
80106d5c:	e8 ab fe ff ff       	call   80106c0c <slabdump>
	/* TEST1: Single slab alloc: the size not equal to a power of 2. */
	cprintf("==== TEST2 =====\n");
80106d61:	c7 04 24 38 80 10 80 	movl   $0x80108038,(%esp)
80106d68:	e8 94 98 ff ff       	call   80100601 <cprintf>
	start = counter;
80106d6d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	t[0][0] = (int*) kmalloc (TESTSIZE-10); 
80106d70:	c7 04 24 f6 07 00 00 	movl   $0x7f6,(%esp)
80106d77:	e8 1e fc ff ff       	call   8010699a <kmalloc>
80106d7c:	a3 40 4d 11 80       	mov    %eax,0x80114d40
	*(t[0][0]) = counter;
80106d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d84:	89 10                	mov    %edx,(%eax)
	slabdump();
80106d86:	e8 81 fe ff ff       	call   80106c0c <slabdump>
	counter++;
80106d8b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
80106d8f:	83 c4 10             	add    $0x10,%esp
80106d92:	b8 0a 80 10 80       	mov    $0x8010800a,%eax
80106d97:	8b 15 40 4d 11 80    	mov    0x80114d40,%edx
80106d9d:	39 1a                	cmp    %ebx,(%edx)
80106d9f:	74 68                	je     80106e09 <slabtest+0x127>
80106da1:	83 ec 0c             	sub    $0xc,%esp
80106da4:	50                   	push   %eax
80106da5:	e8 57 98 ff ff       	call   80100601 <cprintf>
	kmfree ((char*) t[0][0], TESTSIZE);
80106daa:	83 c4 08             	add    $0x8,%esp
80106dad:	68 00 08 00 00       	push   $0x800
80106db2:	ff 35 40 4d 11 80    	push   0x80114d40
80106db8:	e8 15 fd ff ff       	call   80106ad2 <kmfree>
	slabdump();
80106dbd:	e8 4a fe ff ff       	call   80106c0c <slabdump>
	/* TEST3: Multiple slabs alloc */
	cprintf("==== TEST3 =====\n");
80106dc2:	c7 04 24 4a 80 10 80 	movl   $0x8010804a,(%esp)
80106dc9:	e8 33 98 ff ff       	call   80100601 <cprintf>
	start = counter;
80106dce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	for (int i=0; i<NSLAB; i++)
80106dd1:	83 c4 10             	add    $0x10,%esp
	start = counter;
80106dd4:	c7 45 d4 40 4d 11 80 	movl   $0x80114d40,-0x2c(%ebp)
80106ddb:	c7 45 d0 03 00 00 00 	movl   $0x3,-0x30(%ebp)
	{
		int slabsize = 1 << (i+3); 
		t[i][0]	= (int*) kmalloc (slabsize); 
		for (int j=0; j<slabsize/sizeof(int); j++)
		{
			memmove (t[i][0]+j, &counter, sizeof(int));
80106de2:	89 75 cc             	mov    %esi,-0x34(%ebp)
80106de5:	eb 59                	jmp    80106e40 <slabtest+0x15e>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
80106de7:	83 ec 0c             	sub    $0xc,%esp
80106dea:	6a 08                	push   $0x8
80106dec:	e8 df fe ff ff       	call   80106cd0 <numobj_slab>
80106df1:	83 c4 10             	add    $0x10,%esp
80106df4:	83 f8 01             	cmp    $0x1,%eax
80106df7:	b8 06 80 10 80       	mov    $0x80108006,%eax
80106dfc:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
80106e01:	0f 45 c2             	cmovne %edx,%eax
80106e04:	e9 37 ff ff ff       	jmp    80106d40 <slabtest+0x5e>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
80106e09:	83 ec 0c             	sub    $0xc,%esp
80106e0c:	6a 08                	push   $0x8
80106e0e:	e8 bd fe ff ff       	call   80106cd0 <numobj_slab>
80106e13:	83 c4 10             	add    $0x10,%esp
80106e16:	83 f8 01             	cmp    $0x1,%eax
80106e19:	b8 06 80 10 80       	mov    $0x80108006,%eax
80106e1e:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
80106e23:	0f 45 c2             	cmovne %edx,%eax
80106e26:	e9 76 ff ff ff       	jmp    80106da1 <slabtest+0xbf>
	for (int i=0; i<NSLAB; i++)
80106e2b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80106e2f:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
80106e36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106e39:	3d 60 69 11 80       	cmp    $0x80116960,%eax
80106e3e:	74 51                	je     80106e91 <slabtest+0x1af>
		int slabsize = 1 << (i+3); 
80106e40:	bb 01 00 00 00       	mov    $0x1,%ebx
80106e45:	0f b6 4d d0          	movzbl -0x30(%ebp),%ecx
80106e49:	d3 e3                	shl    %cl,%ebx
		t[i][0]	= (int*) kmalloc (slabsize); 
80106e4b:	83 ec 0c             	sub    $0xc,%esp
80106e4e:	53                   	push   %ebx
80106e4f:	e8 46 fb ff ff       	call   8010699a <kmalloc>
80106e54:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106e57:	89 d7                	mov    %edx,%edi
80106e59:	89 02                	mov    %eax,(%edx)
		for (int j=0; j<slabsize/sizeof(int); j++)
80106e5b:	89 de                	mov    %ebx,%esi
80106e5d:	c1 ee 02             	shr    $0x2,%esi
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	83 fb 03             	cmp    $0x3,%ebx
80106e66:	76 c3                	jbe    80106e2b <slabtest+0x149>
80106e68:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[i][0]+j, &counter, sizeof(int));
80106e6d:	83 ec 04             	sub    $0x4,%esp
80106e70:	6a 04                	push   $0x4
80106e72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e75:	50                   	push   %eax
80106e76:	8b 07                	mov    (%edi),%eax
80106e78:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80106e7b:	50                   	push   %eax
80106e7c:	e8 b3 cf ff ff       	call   80103e34 <memmove>
			counter++;
80106e81:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int j=0; j<slabsize/sizeof(int); j++)
80106e85:	83 c3 01             	add    $0x1,%ebx
80106e88:	83 c4 10             	add    $0x10,%esp
80106e8b:	39 de                	cmp    %ebx,%esi
80106e8d:	77 de                	ja     80106e6d <slabtest+0x18b>
80106e8f:	eb 9a                	jmp    80106e2b <slabtest+0x149>
80106e91:	8b 75 cc             	mov    -0x34(%ebp),%esi
80106e94:	c7 45 d4 40 4d 11 80 	movl   $0x80114d40,-0x2c(%ebp)
80106e9b:	b9 03 00 00 00       	mov    $0x3,%ecx
		}
	}
	
	// CHECK 
	pass = 1;
80106ea0:	bf 01 00 00 00       	mov    $0x1,%edi
80106ea5:	eb 14                	jmp    80106ebb <slabtest+0x1d9>
		for (int j=0; j < slabsize/sizeof(int); j++)
		{
			// cprintf("%d, %d, %d, %d\n", i, j, *(t[i][0]+j), start);		//YOU MAY USE THIS
			if ( *(t[i][0]+j) != start )
			{
				pass = 0;
80106ea7:	bf 00 00 00 00       	mov    $0x0,%edi
	for (int i=0; i<NSLAB; i++)
80106eac:	83 c1 01             	add    $0x1,%ecx
80106eaf:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
80106eb6:	83 f9 0c             	cmp    $0xc,%ecx
80106eb9:	74 2c                	je     80106ee7 <slabtest+0x205>
		int slabsize = 1 << (i+3); 
80106ebb:	b8 01 00 00 00       	mov    $0x1,%eax
80106ec0:	d3 e0                	shl    %cl,%eax
		for (int j=0; j < slabsize/sizeof(int); j++)
80106ec2:	89 c3                	mov    %eax,%ebx
80106ec4:	c1 eb 02             	shr    $0x2,%ebx
80106ec7:	83 f8 03             	cmp    $0x3,%eax
80106eca:	76 e0                	jbe    80106eac <slabtest+0x1ca>
			if ( *(t[i][0]+j) != start )
80106ecc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106ecf:	8b 10                	mov    (%eax),%edx
		for (int j=0; j < slabsize/sizeof(int); j++)
80106ed1:	b8 00 00 00 00       	mov    $0x0,%eax
			if ( *(t[i][0]+j) != start )
80106ed6:	39 34 82             	cmp    %esi,(%edx,%eax,4)
80106ed9:	75 cc                	jne    80106ea7 <slabtest+0x1c5>
				break;
			}
			start++;
80106edb:	83 c6 01             	add    $0x1,%esi
		for (int j=0; j < slabsize/sizeof(int); j++)
80106ede:	83 c0 01             	add    $0x1,%eax
80106ee1:	39 d8                	cmp    %ebx,%eax
80106ee3:	72 f1                	jb     80106ed6 <slabtest+0x1f4>
80106ee5:	eb c5                	jmp    80106eac <slabtest+0x1ca>
		}
	}
	slabdump();
80106ee7:	e8 20 fd ff ff       	call   80106c0c <slabdump>
	cprintf( pass ? "OK\n" : "WRONG\n");	
80106eec:	85 ff                	test   %edi,%edi
80106eee:	b8 06 80 10 80       	mov    $0x80108006,%eax
80106ef3:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
80106ef8:	0f 44 c2             	cmove  %edx,%eax
80106efb:	83 ec 0c             	sub    $0xc,%esp
80106efe:	50                   	push   %eax
80106eff:	e8 fd 96 ff ff       	call   80100601 <cprintf>
80106f04:	83 c4 10             	add    $0x10,%esp
80106f07:	be 40 4d 11 80       	mov    $0x80114d40,%esi
80106f0c:	bb 03 00 00 00       	mov    $0x3,%ebx
	for (int i=0; i<NSLAB; i++)
	{
		int slabsize = 1 << (i+3); 
80106f11:	bf 01 00 00 00       	mov    $0x1,%edi
		kmfree((char*) t[i][0], slabsize);
80106f16:	83 ec 08             	sub    $0x8,%esp
		int slabsize = 1 << (i+3); 
80106f19:	89 f8                	mov    %edi,%eax
80106f1b:	89 d9                	mov    %ebx,%ecx
80106f1d:	d3 e0                	shl    %cl,%eax
		kmfree((char*) t[i][0], slabsize);
80106f1f:	50                   	push   %eax
80106f20:	ff 36                	push   (%esi)
80106f22:	e8 ab fb ff ff       	call   80106ad2 <kmfree>
	for (int i=0; i<NSLAB; i++)
80106f27:	83 c3 01             	add    $0x1,%ebx
80106f2a:	81 c6 20 03 00 00    	add    $0x320,%esi
80106f30:	83 c4 10             	add    $0x10,%esp
80106f33:	83 fb 0c             	cmp    $0xc,%ebx
80106f36:	75 de                	jne    80106f16 <slabtest+0x234>
	}
	slabdump();
80106f38:	e8 cf fc ff ff       	call   80106c0c <slabdump>
	/* TEST4: Multiple slabs alloc2 */
	cprintf("==== TEST4 =====\n");
80106f3d:	83 ec 0c             	sub    $0xc,%esp
80106f40:	68 5c 80 10 80       	push   $0x8010805c
80106f45:	e8 b7 96 ff ff       	call   80100601 <cprintf>
	start = counter;
80106f4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	for (int i=0; i<NSLAB; i++)
80106f4d:	c7 45 c4 60 50 11 80 	movl   $0x80115060,-0x3c(%ebp)
80106f54:	83 c4 10             	add    $0x10,%esp
	start = counter;
80106f57:	c7 45 d0 60 50 11 80 	movl   $0x80115060,-0x30(%ebp)
80106f5e:	c7 45 c8 03 00 00 00 	movl   $0x3,-0x38(%ebp)
			t[i][j]	= (int*) kmalloc (slabsize); 
			// cprintf("adress: %p\n",(int*)t[i][j]);
			for (int k=0; k<slabsize/sizeof(int); k++)
			{
				// slabdump();
				memmove (t[i][j]+k, &counter, sizeof(int));
80106f65:	89 7d c0             	mov    %edi,-0x40(%ebp)
80106f68:	eb 67                	jmp    80106fd1 <slabtest+0x2ef>
		for (int j=0; j<MAXTEST; j++)
80106f6a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
80106f6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106f71:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80106f74:	74 44                	je     80106fba <slabtest+0x2d8>
			t[i][j]	= (int*) kmalloc (slabsize); 
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80106f7c:	53                   	push   %ebx
80106f7d:	e8 18 fa ff ff       	call   8010699a <kmalloc>
80106f82:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80106f85:	89 ce                	mov    %ecx,%esi
80106f87:	89 01                	mov    %eax,(%ecx)
			for (int k=0; k<slabsize/sizeof(int); k++)
80106f89:	83 c4 10             	add    $0x10,%esp
80106f8c:	83 fb 03             	cmp    $0x3,%ebx
80106f8f:	76 d9                	jbe    80106f6a <slabtest+0x288>
80106f91:	bb 00 00 00 00       	mov    $0x0,%ebx
				memmove (t[i][j]+k, &counter, sizeof(int));
80106f96:	83 ec 04             	sub    $0x4,%esp
80106f99:	6a 04                	push   $0x4
80106f9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106f9e:	50                   	push   %eax
80106f9f:	8b 06                	mov    (%esi),%eax
80106fa1:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80106fa4:	50                   	push   %eax
80106fa5:	e8 8a ce ff ff       	call   80103e34 <memmove>
				counter++;
80106faa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
			for (int k=0; k<slabsize/sizeof(int); k++)
80106fae:	83 c3 01             	add    $0x1,%ebx
80106fb1:	83 c4 10             	add    $0x10,%esp
80106fb4:	39 fb                	cmp    %edi,%ebx
80106fb6:	72 de                	jb     80106f96 <slabtest+0x2b4>
80106fb8:	eb b0                	jmp    80106f6a <slabtest+0x288>
	for (int i=0; i<NSLAB; i++)
80106fba:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
80106fbe:	81 45 d0 20 03 00 00 	addl   $0x320,-0x30(%ebp)
80106fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106fc8:	ba 80 6c 11 80       	mov    $0x80116c80,%edx
80106fcd:	39 c2                	cmp    %eax,%edx
80106fcf:	74 20                	je     80106ff1 <slabtest+0x30f>
		int slabsize = 1 << (i+3); 
80106fd1:	b8 01 00 00 00       	mov    $0x1,%eax
80106fd6:	0f b6 4d c8          	movzbl -0x38(%ebp),%ecx
80106fda:	d3 e0                	shl    %cl,%eax
80106fdc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			for (int k=0; k<slabsize/sizeof(int); k++)
80106fdf:	c1 e8 02             	shr    $0x2,%eax
80106fe2:	89 c7                	mov    %eax,%edi
80106fe4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106fe7:	2d 20 03 00 00       	sub    $0x320,%eax
80106fec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106fef:	eb 85                	jmp    80106f76 <slabtest+0x294>
			}
		}
	}
	slabdump();
80106ff1:	8b 7d c0             	mov    -0x40(%ebp),%edi
80106ff4:	e8 13 fc ff ff       	call   80106c0c <slabdump>
80106ff9:	c7 45 d4 60 50 11 80 	movl   $0x80115060,-0x2c(%ebp)
80107000:	c7 45 cc 03 00 00 00 	movl   $0x3,-0x34(%ebp)
	// CHECK
	pass = 1;
80107007:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
8010700e:	eb 43                	jmp    80107053 <slabtest+0x371>
			for (int k=0; k<slabsize/sizeof(int); k++)
			{
				// cprintf("%d, %d, %d, %d, %d\n", i, j,k, *(t[i][j]+k), start);
				if (*(t[i][j]+k) != start)
				{
					pass = 0;
80107010:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (int j=0; j<MAXTEST; j++)
80107017:	83 c3 04             	add    $0x4,%ebx
8010701a:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
8010701d:	74 1d                	je     8010703c <slabtest+0x35a>
			for (int k=0; k<slabsize/sizeof(int); k++)
8010701f:	83 fe 03             	cmp    $0x3,%esi
80107022:	76 f3                	jbe    80107017 <slabtest+0x335>
				if (*(t[i][j]+k) != start)
80107024:	8b 13                	mov    (%ebx),%edx
			for (int k=0; k<slabsize/sizeof(int); k++)
80107026:	b8 00 00 00 00       	mov    $0x0,%eax
				if (*(t[i][j]+k) != start)
8010702b:	39 3c 82             	cmp    %edi,(%edx,%eax,4)
8010702e:	75 e0                	jne    80107010 <slabtest+0x32e>
					break;
				}
				start++;
80107030:	83 c7 01             	add    $0x1,%edi
			for (int k=0; k<slabsize/sizeof(int); k++)
80107033:	83 c0 01             	add    $0x1,%eax
80107036:	39 c8                	cmp    %ecx,%eax
80107038:	72 f1                	jb     8010702b <slabtest+0x349>
8010703a:	eb db                	jmp    80107017 <slabtest+0x335>
	for (int i=0; i<NSLAB; i++)
8010703c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80107040:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
80107047:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010704a:	ba 80 6c 11 80       	mov    $0x80116c80,%edx
8010704f:	39 c2                	cmp    %eax,%edx
80107051:	74 1b                	je     8010706e <slabtest+0x38c>
		int slabsize = 1 << (i+3); 
80107053:	be 01 00 00 00       	mov    $0x1,%esi
80107058:	0f b6 4d cc          	movzbl -0x34(%ebp),%ecx
8010705c:	d3 e6                	shl    %cl,%esi
			for (int k=0; k<slabsize/sizeof(int); k++)
8010705e:	89 f1                	mov    %esi,%ecx
80107060:	c1 e9 02             	shr    $0x2,%ecx
80107063:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107066:	8d 98 e0 fc ff ff    	lea    -0x320(%eax),%ebx
8010706c:	eb b1                	jmp    8010701f <slabtest+0x33d>
			}
		}
	}
	cprintf( pass ? "OK\n" : "WRONG\n");
8010706e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80107072:	b8 06 80 10 80       	mov    $0x80108006,%eax
80107077:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
8010707c:	0f 44 c2             	cmove  %edx,%eax
8010707f:	83 ec 0c             	sub    $0xc,%esp
80107082:	50                   	push   %eax
80107083:	e8 79 95 ff ff       	call   80100601 <cprintf>
80107088:	83 c4 10             	add    $0x10,%esp
8010708b:	bf 03 00 00 00       	mov    $0x3,%edi
	// slabdump();
	for (int i=0; i<NSLAB; i++)
	{
		int slabsize = 1 << (i+3); 
80107090:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80107093:	8b 75 c4             	mov    -0x3c(%ebp),%esi
80107096:	bf 01 00 00 00       	mov    $0x1,%edi
8010709b:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
8010709f:	d3 e7                	shl    %cl,%edi
		// cprintf("slabsize:%d\n", slabsize);
		for (int j=0; j<MAXTEST; j++)
801070a1:	8d 9e e0 fc ff ff    	lea    -0x320(%esi),%ebx
		{
			kmfree((char*) t[i][j], slabsize);
801070a7:	83 ec 08             	sub    $0x8,%esp
801070aa:	57                   	push   %edi
801070ab:	ff 33                	push   (%ebx)
801070ad:	e8 20 fa ff ff       	call   80106ad2 <kmfree>
		for (int j=0; j<MAXTEST; j++)
801070b2:	83 c3 04             	add    $0x4,%ebx
801070b5:	83 c4 10             	add    $0x10,%esp
801070b8:	39 f3                	cmp    %esi,%ebx
801070ba:	75 eb                	jne    801070a7 <slabtest+0x3c5>
	for (int i=0; i<NSLAB; i++)
801070bc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801070c0:	81 c6 20 03 00 00    	add    $0x320,%esi
801070c6:	81 fe 80 6c 11 80    	cmp    $0x80116c80,%esi
801070cc:	75 c8                	jne    80107096 <slabtest+0x3b4>
			// slabdump();
		}
	}
	slabdump();
801070ce:	e8 39 fb ff ff       	call   80106c0c <slabdump>
	/* TEST5: ALLOC MORE THAN 100 PAGES */
	cprintf("==== TEST5 =====\n");
801070d3:	83 ec 0c             	sub    $0xc,%esp
801070d6:	68 6e 80 10 80       	push   $0x8010806e
801070db:	e8 21 95 ff ff       	call   80100601 <cprintf>
801070e0:	83 c4 10             	add    $0x10,%esp
	start = counter;
	for (int j=0; j<MAXTEST; j++)
801070e3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
		// cprintf("adress: %p",(int*)t[0][j]);
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			// slabdump();
			memmove (t[0][j]+k, &counter, sizeof(int));
801070ea:	8d 7d e4             	lea    -0x1c(%ebp),%edi
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
801070ed:	83 ec 0c             	sub    $0xc,%esp
801070f0:	68 00 08 00 00       	push   $0x800
801070f5:	e8 a0 f8 ff ff       	call   8010699a <kmalloc>
801070fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801070fd:	89 d6                	mov    %edx,%esi
801070ff:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
80107106:	83 c4 10             	add    $0x10,%esp
80107109:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
8010710e:	83 ec 04             	sub    $0x4,%esp
80107111:	6a 04                	push   $0x4
80107113:	57                   	push   %edi
80107114:	89 d8                	mov    %ebx,%eax
80107116:	03 04 b5 40 4d 11 80 	add    -0x7feeb2c0(,%esi,4),%eax
8010711d:	50                   	push   %eax
8010711e:	e8 11 cd ff ff       	call   80103e34 <memmove>
			counter++;
80107123:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
80107127:	83 c3 04             	add    $0x4,%ebx
8010712a:	83 c4 10             	add    $0x10,%esp
8010712d:	81 fb 00 08 00 00    	cmp    $0x800,%ebx
80107133:	75 d9                	jne    8010710e <slabtest+0x42c>
	for (int j=0; j<MAXTEST; j++)
80107135:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
80107139:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010713c:	3d c8 00 00 00       	cmp    $0xc8,%eax
80107141:	75 aa                	jne    801070ed <slabtest+0x40b>
		}
	}
	tmp = (int*) kmalloc (TESTSIZE);
80107143:	83 ec 0c             	sub    $0xc,%esp
80107146:	68 00 08 00 00       	push   $0x800
8010714b:	e8 4a f8 ff ff       	call   8010699a <kmalloc>
80107150:	89 c2                	mov    %eax,%edx
	cprintf( (!tmp && numobj_slab (TESTSLABID) == MAXTEST) ? "OK\n" : "WRONG\n");	
80107152:	83 c4 10             	add    $0x10,%esp
80107155:	b8 0a 80 10 80       	mov    $0x8010800a,%eax
8010715a:	85 d2                	test   %edx,%edx
8010715c:	0f 84 cb 00 00 00    	je     8010722d <slabtest+0x54b>
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	50                   	push   %eax
80107166:	e8 96 94 ff ff       	call   80100601 <cprintf>
	slabdump();
8010716b:	e8 9c fa ff ff       	call   80106c0c <slabdump>
	/* TEST6: ALLOC AFTER FREE */
	cprintf("==== TEST6 =====\n");
80107170:	c7 04 24 80 80 10 80 	movl   $0x80108080,(%esp)
80107177:	e8 85 94 ff ff       	call   80100601 <cprintf>
8010717c:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<MAXTEST; j++)
8010717f:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE);
80107184:	83 ec 08             	sub    $0x8,%esp
80107187:	68 00 08 00 00       	push   $0x800
8010718c:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
80107193:	e8 3a f9 ff ff       	call   80106ad2 <kmfree>
	for (int j=0; j<MAXTEST; j++)
80107198:	83 c3 01             	add    $0x1,%ebx
8010719b:	83 c4 10             	add    $0x10,%esp
8010719e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
801071a4:	75 de                	jne    80107184 <slabtest+0x4a2>
	}
	slabdump();
801071a6:	e8 61 fa ff ff       	call   80106c0c <slabdump>
	start = counter;
801071ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (int j=0; j<MAXTEST; j++)
801071b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
801071b8:	8d 7d e4             	lea    -0x1c(%ebp),%edi
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
801071bb:	83 ec 0c             	sub    $0xc,%esp
801071be:	68 00 08 00 00       	push   $0x800
801071c3:	e8 d2 f7 ff ff       	call   8010699a <kmalloc>
801071c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801071cb:	89 d6                	mov    %edx,%esi
801071cd:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
801071d4:	83 c4 10             	add    $0x10,%esp
801071d7:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
801071dc:	83 ec 04             	sub    $0x4,%esp
801071df:	6a 04                	push   $0x4
801071e1:	57                   	push   %edi
801071e2:	89 d8                	mov    %ebx,%eax
801071e4:	03 04 b5 40 4d 11 80 	add    -0x7feeb2c0(,%esi,4),%eax
801071eb:	50                   	push   %eax
801071ec:	e8 43 cc ff ff       	call   80103e34 <memmove>
			counter++;
801071f1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
801071f5:	83 c3 04             	add    $0x4,%ebx
801071f8:	83 c4 10             	add    $0x10,%esp
801071fb:	81 fb 00 08 00 00    	cmp    $0x800,%ebx
80107201:	75 d9                	jne    801071dc <slabtest+0x4fa>
	for (int j=0; j<MAXTEST; j++)
80107203:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
80107207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010720a:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010720f:	75 aa                	jne    801071bb <slabtest+0x4d9>
		}
	}
	slabdump();
80107211:	e8 f6 f9 ff ff       	call   80106c0c <slabdump>
	// CHECK 
	pass = 1;
	for (int j=0; j<MAXTEST; j++)
80107216:	b9 00 00 00 00       	mov    $0x0,%ecx
	pass = 1;
8010721b:	bf 01 00 00 00       	mov    $0x1,%edi
	{
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			if (*(t[0][j]+k) != start)
			{
				pass = 0;
80107220:	be 00 00 00 00       	mov    $0x0,%esi
80107225:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80107228:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010722b:	eb 32                	jmp    8010725f <slabtest+0x57d>
	cprintf( (!tmp && numobj_slab (TESTSLABID) == MAXTEST) ? "OK\n" : "WRONG\n");	
8010722d:	83 ec 0c             	sub    $0xc,%esp
80107230:	6a 08                	push   $0x8
80107232:	e8 99 fa ff ff       	call   80106cd0 <numobj_slab>
80107237:	83 c4 10             	add    $0x10,%esp
8010723a:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010723f:	b8 06 80 10 80       	mov    $0x80108006,%eax
80107244:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
80107249:	0f 45 c2             	cmovne %edx,%eax
8010724c:	e9 11 ff ff ff       	jmp    80107162 <slabtest+0x480>
				pass = 0;
80107251:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	for (int j=0; j<MAXTEST; j++)
80107254:	83 c1 01             	add    $0x1,%ecx
80107257:	81 f9 c8 00 00 00    	cmp    $0xc8,%ecx
8010725d:	74 26                	je     80107285 <slabtest+0x5a3>
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
8010725f:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
80107265:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
8010726c:	8b 14 8d 40 4d 11 80 	mov    -0x7feeb2c0(,%ecx,4),%edx
80107273:	29 fa                	sub    %edi,%edx
			if (*(t[0][j]+k) != start)
80107275:	39 04 82             	cmp    %eax,(%edx,%eax,4)
80107278:	75 d7                	jne    80107251 <slabtest+0x56f>
				break;
			}
			start++;
8010727a:	83 c0 01             	add    $0x1,%eax
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
8010727d:	39 c3                	cmp    %eax,%ebx
8010727f:	75 f4                	jne    80107275 <slabtest+0x593>
			start++;
80107281:	89 d8                	mov    %ebx,%eax
80107283:	eb cf                	jmp    80107254 <slabtest+0x572>
		}
	}
	cprintf( pass ? "OK\n" : "WRONG\n");	
80107285:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80107288:	85 ff                	test   %edi,%edi
8010728a:	b8 06 80 10 80       	mov    $0x80108006,%eax
8010728f:	ba 0a 80 10 80       	mov    $0x8010800a,%edx
80107294:	0f 44 c2             	cmove  %edx,%eax
80107297:	83 ec 0c             	sub    $0xc,%esp
8010729a:	50                   	push   %eax
8010729b:	e8 61 93 ff ff       	call   80100601 <cprintf>
801072a0:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<MAXTEST; j++)
801072a3:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE);
801072a8:	83 ec 08             	sub    $0x8,%esp
801072ab:	68 00 08 00 00       	push   $0x800
801072b0:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
801072b7:	e8 16 f8 ff ff       	call   80106ad2 <kmfree>
	for (int j=0; j<MAXTEST; j++)
801072bc:	83 c3 01             	add    $0x1,%ebx
801072bf:	83 c4 10             	add    $0x10,%esp
801072c2:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
801072c8:	75 de                	jne    801072a8 <slabtest+0x5c6>
		// slabdump();
	}
	slabdump();
801072ca:	e8 3d f9 ff ff       	call   80106c0c <slabdump>
	//alloc and free and alloc
	cprintf("==== TEST7 =====\n");
801072cf:	83 ec 0c             	sub    $0xc,%esp
801072d2:	68 92 80 10 80       	push   $0x80108092
801072d7:	e8 25 93 ff ff       	call   80100601 <cprintf>
801072dc:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<16; j++)
801072df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
801072e6:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	68 00 02 00 00       	push   $0x200
801072f1:	e8 a4 f6 ff ff       	call   8010699a <kmalloc>
801072f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801072f9:	89 d7                	mov    %edx,%edi
801072fb:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
80107302:	83 c4 10             	add    $0x10,%esp
80107305:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
8010730a:	83 ec 04             	sub    $0x4,%esp
8010730d:	6a 04                	push   $0x4
8010730f:	56                   	push   %esi
80107310:	89 d8                	mov    %ebx,%eax
80107312:	03 04 bd 40 4d 11 80 	add    -0x7feeb2c0(,%edi,4),%eax
80107319:	50                   	push   %eax
8010731a:	e8 15 cb ff ff       	call   80103e34 <memmove>
			counter++;
8010731f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
80107323:	83 c3 04             	add    $0x4,%ebx
80107326:	83 c4 10             	add    $0x10,%esp
80107329:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
8010732f:	75 d9                	jne    8010730a <slabtest+0x628>
	for (int j=0; j<16; j++)
80107331:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
80107335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107338:	83 f8 10             	cmp    $0x10,%eax
8010733b:	75 ac                	jne    801072e9 <slabtest+0x607>
		}
	}
	slabdump();
8010733d:	e8 ca f8 ff ff       	call   80106c0c <slabdump>
	for (int j=10; j<12; j++)
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107342:	83 ec 08             	sub    $0x8,%esp
80107345:	68 00 02 00 00       	push   $0x200
8010734a:	ff 35 68 4d 11 80    	push   0x80114d68
80107350:	e8 7d f7 ff ff       	call   80106ad2 <kmfree>
80107355:	83 c4 08             	add    $0x8,%esp
80107358:	68 00 02 00 00       	push   $0x200
8010735d:	ff 35 6c 4d 11 80    	push   0x80114d6c
80107363:	e8 6a f7 ff ff       	call   80106ad2 <kmfree>
	}
	for (int j=13; j<15; j++)
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107368:	83 c4 08             	add    $0x8,%esp
8010736b:	68 00 02 00 00       	push   $0x200
80107370:	ff 35 74 4d 11 80    	push   0x80114d74
80107376:	e8 57 f7 ff ff       	call   80106ad2 <kmfree>
8010737b:	83 c4 08             	add    $0x8,%esp
8010737e:	68 00 02 00 00       	push   $0x200
80107383:	ff 35 78 4d 11 80    	push   0x80114d78
80107389:	e8 44 f7 ff ff       	call   80106ad2 <kmfree>
	}
	slabdump();
8010738e:	e8 79 f8 ff ff       	call   80106c0c <slabdump>
80107393:	83 c4 10             	add    $0x10,%esp
	for (int j=10; j<12; j++)
80107396:	c7 45 d4 0a 00 00 00 	movl   $0xa,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
8010739d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	68 00 02 00 00       	push   $0x200
801073a8:	e8 ed f5 ff ff       	call   8010699a <kmalloc>
801073ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801073b0:	89 d7                	mov    %edx,%edi
801073b2:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
801073b9:	83 c4 10             	add    $0x10,%esp
801073bc:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
801073c1:	83 ec 04             	sub    $0x4,%esp
801073c4:	6a 04                	push   $0x4
801073c6:	56                   	push   %esi
801073c7:	89 d8                	mov    %ebx,%eax
801073c9:	03 04 bd 40 4d 11 80 	add    -0x7feeb2c0(,%edi,4),%eax
801073d0:	50                   	push   %eax
801073d1:	e8 5e ca ff ff       	call   80103e34 <memmove>
			counter++;
801073d6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
801073da:	83 c3 04             	add    $0x4,%ebx
801073dd:	83 c4 10             	add    $0x10,%esp
801073e0:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
801073e6:	75 d9                	jne    801073c1 <slabtest+0x6df>
	for (int j=10; j<12; j++)
801073e8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801073ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801073ef:	83 f8 0c             	cmp    $0xc,%eax
801073f2:	75 ac                	jne    801073a0 <slabtest+0x6be>
		}
	}
	slabdump();
801073f4:	e8 13 f8 ff ff       	call   80106c0c <slabdump>
	for (int j=8; j<16; j++)
801073f9:	bb 08 00 00 00       	mov    $0x8,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
801073fe:	83 ec 08             	sub    $0x8,%esp
80107401:	68 00 02 00 00       	push   $0x200
80107406:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
8010740d:	e8 c0 f6 ff ff       	call   80106ad2 <kmfree>
	for (int j=8; j<16; j++)
80107412:	83 c3 01             	add    $0x1,%ebx
80107415:	83 c4 10             	add    $0x10,%esp
80107418:	83 fb 10             	cmp    $0x10,%ebx
8010741b:	75 e1                	jne    801073fe <slabtest+0x71c>
	}
	for (int j=0; j<8; j++)
8010741d:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107422:	83 ec 08             	sub    $0x8,%esp
80107425:	68 00 02 00 00       	push   $0x200
8010742a:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
80107431:	e8 9c f6 ff ff       	call   80106ad2 <kmfree>
	for (int j=0; j<8; j++)
80107436:	83 c3 01             	add    $0x1,%ebx
80107439:	83 c4 10             	add    $0x10,%esp
8010743c:	83 fb 08             	cmp    $0x8,%ebx
8010743f:	75 e1                	jne    80107422 <slabtest+0x740>
	}
	slabdump();
80107441:	89 5d d0             	mov    %ebx,-0x30(%ebp)
80107444:	e8 c3 f7 ff ff       	call   80106c0c <slabdump>
	cprintf("==== TEST8 =====\n");
80107449:	83 ec 0c             	sub    $0xc,%esp
8010744c:	68 a4 80 10 80       	push   $0x801080a4
80107451:	e8 ab 91 ff ff       	call   80100601 <cprintf>
80107456:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<24; j++)
80107459:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
80107460:	8d 7d e4             	lea    -0x1c(%ebp),%edi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
80107463:	83 ec 0c             	sub    $0xc,%esp
80107466:	68 00 02 00 00       	push   $0x200
8010746b:	e8 2a f5 ff ff       	call   8010699a <kmalloc>
80107470:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80107473:	89 d6                	mov    %edx,%esi
80107475:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
80107484:	83 ec 04             	sub    $0x4,%esp
80107487:	6a 04                	push   $0x4
80107489:	57                   	push   %edi
8010748a:	89 d8                	mov    %ebx,%eax
8010748c:	03 04 b5 40 4d 11 80 	add    -0x7feeb2c0(,%esi,4),%eax
80107493:	50                   	push   %eax
80107494:	e8 9b c9 ff ff       	call   80103e34 <memmove>
			counter++;
80107499:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
8010749d:	83 c3 04             	add    $0x4,%ebx
801074a0:	83 c4 10             	add    $0x10,%esp
801074a3:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
801074a9:	75 d9                	jne    80107484 <slabtest+0x7a2>
	for (int j=0; j<24; j++)
801074ab:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801074af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801074b2:	83 f8 18             	cmp    $0x18,%eax
801074b5:	75 ac                	jne    80107463 <slabtest+0x781>
		}
	}
	slabdump();
801074b7:	e8 50 f7 ff ff       	call   80106c0c <slabdump>
	for (int j=8; j<16; j++)
801074bc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
801074bf:	83 ec 08             	sub    $0x8,%esp
801074c2:	68 00 02 00 00       	push   $0x200
801074c7:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
801074ce:	e8 ff f5 ff ff       	call   80106ad2 <kmfree>
	for (int j=8; j<16; j++)
801074d3:	83 c3 01             	add    $0x1,%ebx
801074d6:	83 c4 10             	add    $0x10,%esp
801074d9:	83 fb 10             	cmp    $0x10,%ebx
801074dc:	75 e1                	jne    801074bf <slabtest+0x7dd>
	}
	slabdump();
801074de:	e8 29 f7 ff ff       	call   80106c0c <slabdump>
	for (int j=8; j<16; j++)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
801074e3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
801074e6:	83 ec 0c             	sub    $0xc,%esp
801074e9:	68 00 02 00 00       	push   $0x200
801074ee:	e8 a7 f4 ff ff       	call   8010699a <kmalloc>
801074f3:	8b 55 d0             	mov    -0x30(%ebp),%edx
801074f6:	89 d7                	mov    %edx,%edi
801074f8:	89 04 95 40 4d 11 80 	mov    %eax,-0x7feeb2c0(,%edx,4)
801074ff:	83 c4 10             	add    $0x10,%esp
80107502:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
80107507:	83 ec 04             	sub    $0x4,%esp
8010750a:	6a 04                	push   $0x4
8010750c:	56                   	push   %esi
8010750d:	89 d8                	mov    %ebx,%eax
8010750f:	03 04 bd 40 4d 11 80 	add    -0x7feeb2c0(,%edi,4),%eax
80107516:	50                   	push   %eax
80107517:	e8 18 c9 ff ff       	call   80103e34 <memmove>
			counter++;
8010751c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
80107520:	83 c3 04             	add    $0x4,%ebx
80107523:	83 c4 10             	add    $0x10,%esp
80107526:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
8010752c:	75 d9                	jne    80107507 <slabtest+0x825>
	for (int j=8; j<16; j++)
8010752e:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80107532:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107535:	83 f8 10             	cmp    $0x10,%eax
80107538:	75 ac                	jne    801074e6 <slabtest+0x804>
		}
	}
	slabdump();
8010753a:	e8 cd f6 ff ff       	call   80106c0c <slabdump>
	for (int j=0; j<24; j++)
8010753f:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107544:	83 ec 08             	sub    $0x8,%esp
80107547:	68 00 02 00 00       	push   $0x200
8010754c:	ff 34 9d 40 4d 11 80 	push   -0x7feeb2c0(,%ebx,4)
80107553:	e8 7a f5 ff ff       	call   80106ad2 <kmfree>
	for (int j=0; j<24; j++)
80107558:	83 c3 01             	add    $0x1,%ebx
8010755b:	83 c4 10             	add    $0x10,%esp
8010755e:	83 fb 18             	cmp    $0x18,%ebx
80107561:	75 e1                	jne    80107544 <slabtest+0x862>
	}
	slabdump();
80107563:	e8 a4 f6 ff ff       	call   80106c0c <slabdump>
}
80107568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756b:	5b                   	pop    %ebx
8010756c:	5e                   	pop    %esi
8010756d:	5f                   	pop    %edi
8010756e:	5d                   	pop    %ebp
8010756f:	c3                   	ret    

80107570 <sys_slabtest>:
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "slab.h"

int sys_slabtest(){
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	83 ec 08             	sub    $0x8,%esp
	slabtest();
80107576:	e8 67 f7 ff ff       	call   80106ce2 <slabtest>
	return 0;
}
8010757b:	b8 00 00 00 00       	mov    $0x0,%eax
80107580:	c9                   	leave  
80107581:	c3                   	ret    
