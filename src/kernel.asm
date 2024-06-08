
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
80100028:	bc e0 e1 10 80       	mov    $0x8010e1e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2b 10 80       	mov    $0x80102b60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	53                   	push   %ebx
8010003c:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003f:	68 80 78 10 80       	push   $0x80107880
80100044:	68 e0 e1 10 80       	push   $0x8010e1e0
80100049:	e8 ef 3c 00 00       	call   80103d3d <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 2c 29 11 80 dc 	movl   $0x801128dc,0x8011292c
80100055:	28 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 30 29 11 80 dc 	movl   $0x801128dc,0x80112930
8010005f:	28 11 80 
80100062:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100065:	bb 14 e2 10 80       	mov    $0x8010e214,%ebx
    b->next = bcache.head.next;
8010006a:	a1 30 29 11 80       	mov    0x80112930,%eax
8010006f:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100072:	c7 43 50 dc 28 11 80 	movl   $0x801128dc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100079:	83 ec 08             	sub    $0x8,%esp
8010007c:	68 87 78 10 80       	push   $0x80107887
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	50                   	push   %eax
80100085:	e8 99 3b 00 00       	call   80103c23 <initsleeplock>
    bcache.head.next->prev = b;
8010008a:	a1 30 29 11 80       	mov    0x80112930,%eax
8010008f:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100092:	89 1d 30 29 11 80    	mov    %ebx,0x80112930
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100098:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009e:	83 c4 10             	add    $0x10,%esp
801000a1:	81 fb dc 28 11 80    	cmp    $0x801128dc,%ebx
801000a7:	75 c1                	jne    8010006a <binit+0x36>
  }
}
801000a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000ac:	c9                   	leave  
801000ad:	c3                   	ret    

801000ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000ae:	f3 0f 1e fb          	endbr32 
801000b2:	55                   	push   %ebp
801000b3:	89 e5                	mov    %esp,%ebp
801000b5:	57                   	push   %edi
801000b6:	56                   	push   %esi
801000b7:	53                   	push   %ebx
801000b8:	83 ec 18             	sub    $0x18,%esp
801000bb:	8b 7d 08             	mov    0x8(%ebp),%edi
801000be:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000c1:	68 e0 e1 10 80       	push   $0x8010e1e0
801000c6:	e8 ce 3d 00 00       	call   80103e99 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cb:	8b 1d 30 29 11 80    	mov    0x80112930,%ebx
801000d1:	83 c4 10             	add    $0x10,%esp
801000d4:	81 fb dc 28 11 80    	cmp    $0x801128dc,%ebx
801000da:	75 26                	jne    80100102 <bread+0x54>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000dc:	8b 1d 2c 29 11 80    	mov    0x8011292c,%ebx
801000e2:	81 fb dc 28 11 80    	cmp    $0x801128dc,%ebx
801000e8:	75 4e                	jne    80100138 <bread+0x8a>
  panic("bget: no buffers");
801000ea:	83 ec 0c             	sub    $0xc,%esp
801000ed:	68 8e 78 10 80       	push   $0x8010788e
801000f2:	e8 61 02 00 00       	call   80100358 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000f7:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000fa:	81 fb dc 28 11 80    	cmp    $0x801128dc,%ebx
80100100:	74 da                	je     801000dc <bread+0x2e>
    if(b->dev == dev && b->blockno == blockno){
80100102:	3b 7b 04             	cmp    0x4(%ebx),%edi
80100105:	75 f0                	jne    801000f7 <bread+0x49>
80100107:	3b 73 08             	cmp    0x8(%ebx),%esi
8010010a:	75 eb                	jne    801000f7 <bread+0x49>
      b->refcnt++;
8010010c:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100110:	83 ec 0c             	sub    $0xc,%esp
80100113:	68 e0 e1 10 80       	push   $0x8010e1e0
80100118:	e8 e7 3d 00 00       	call   80103f04 <release>
      acquiresleep(&b->lock);
8010011d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100120:	89 04 24             	mov    %eax,(%esp)
80100123:	e8 32 3b 00 00       	call   80103c5a <acquiresleep>
      return b;
80100128:	83 c4 10             	add    $0x10,%esp
8010012b:	eb 44                	jmp    80100171 <bread+0xc3>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010012d:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100130:	81 fb dc 28 11 80    	cmp    $0x801128dc,%ebx
80100136:	74 b2                	je     801000ea <bread+0x3c>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100138:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010013c:	75 ef                	jne    8010012d <bread+0x7f>
8010013e:	f6 03 04             	testb  $0x4,(%ebx)
80100141:	75 ea                	jne    8010012d <bread+0x7f>
      b->dev = dev;
80100143:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
80100146:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
80100149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010014f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100156:	83 ec 0c             	sub    $0xc,%esp
80100159:	68 e0 e1 10 80       	push   $0x8010e1e0
8010015e:	e8 a1 3d 00 00       	call   80103f04 <release>
      acquiresleep(&b->lock);
80100163:	8d 43 0c             	lea    0xc(%ebx),%eax
80100166:	89 04 24             	mov    %eax,(%esp)
80100169:	e8 ec 3a 00 00       	call   80103c5a <acquiresleep>
      return b;
8010016e:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	74 0a                	je     80100180 <bread+0xd2>
    iderw(b);
  }
  return b;
}
80100176:	89 d8                	mov    %ebx,%eax
80100178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017b:	5b                   	pop    %ebx
8010017c:	5e                   	pop    %esi
8010017d:	5f                   	pop    %edi
8010017e:	5d                   	pop    %ebp
8010017f:	c3                   	ret    
    iderw(b);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	53                   	push   %ebx
80100184:	e8 6e 1d 00 00       	call   80101ef7 <iderw>
80100189:	83 c4 10             	add    $0x10,%esp
  return b;
8010018c:	eb e8                	jmp    80100176 <bread+0xc8>

8010018e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010018e:	f3 0f 1e fb          	endbr32 
80100192:	55                   	push   %ebp
80100193:	89 e5                	mov    %esp,%ebp
80100195:	53                   	push   %ebx
80100196:	83 ec 10             	sub    $0x10,%esp
80100199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010019c:	8d 43 0c             	lea    0xc(%ebx),%eax
8010019f:	50                   	push   %eax
801001a0:	e8 4a 3b 00 00       	call   80103cef <holdingsleep>
801001a5:	83 c4 10             	add    $0x10,%esp
801001a8:	85 c0                	test   %eax,%eax
801001aa:	74 14                	je     801001c0 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ac:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001af:	83 ec 0c             	sub    $0xc,%esp
801001b2:	53                   	push   %ebx
801001b3:	e8 3f 1d 00 00       	call   80101ef7 <iderw>
}
801001b8:	83 c4 10             	add    $0x10,%esp
801001bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001be:	c9                   	leave  
801001bf:	c3                   	ret    
    panic("bwrite");
801001c0:	83 ec 0c             	sub    $0xc,%esp
801001c3:	68 9f 78 10 80       	push   $0x8010789f
801001c8:	e8 8b 01 00 00       	call   80100358 <panic>

801001cd <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001cd:	f3 0f 1e fb          	endbr32 
801001d1:	55                   	push   %ebp
801001d2:	89 e5                	mov    %esp,%ebp
801001d4:	56                   	push   %esi
801001d5:	53                   	push   %ebx
801001d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001d9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 0a 3b 00 00       	call   80103cef <holdingsleep>
801001e5:	83 c4 10             	add    $0x10,%esp
801001e8:	85 c0                	test   %eax,%eax
801001ea:	74 6b                	je     80100257 <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
801001ec:	83 ec 0c             	sub    $0xc,%esp
801001ef:	56                   	push   %esi
801001f0:	e8 bb 3a 00 00       	call   80103cb0 <releasesleep>

  acquire(&bcache.lock);
801001f5:	c7 04 24 e0 e1 10 80 	movl   $0x8010e1e0,(%esp)
801001fc:	e8 98 3c 00 00       	call   80103e99 <acquire>
  b->refcnt--;
80100201:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100204:	83 e8 01             	sub    $0x1,%eax
80100207:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020a:	83 c4 10             	add    $0x10,%esp
8010020d:	85 c0                	test   %eax,%eax
8010020f:	75 2f                	jne    80100240 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100211:	8b 43 54             	mov    0x54(%ebx),%eax
80100214:	8b 53 50             	mov    0x50(%ebx),%edx
80100217:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021a:	8b 43 50             	mov    0x50(%ebx),%eax
8010021d:	8b 53 54             	mov    0x54(%ebx),%edx
80100220:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100223:	a1 30 29 11 80       	mov    0x80112930,%eax
80100228:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc 28 11 80 	movl   $0x801128dc,0x50(%ebx)
    bcache.head.next->prev = b;
80100232:	a1 30 29 11 80       	mov    0x80112930,%eax
80100237:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023a:	89 1d 30 29 11 80    	mov    %ebx,0x80112930
  }
  
  release(&bcache.lock);
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 e0 e1 10 80       	push   $0x8010e1e0
80100248:	e8 b7 3c 00 00       	call   80103f04 <release>
}
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
    panic("brelse");
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 a6 78 10 80       	push   $0x801078a6
8010025f:	e8 f4 00 00 00       	call   80100358 <panic>

80100264 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100264:	f3 0f 1e fb          	endbr32 
80100268:	55                   	push   %ebp
80100269:	89 e5                	mov    %esp,%ebp
8010026b:	57                   	push   %edi
8010026c:	56                   	push   %esi
8010026d:	53                   	push   %ebx
8010026e:	83 ec 28             	sub    $0x28,%esp
80100271:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100274:	ff 75 08             	pushl  0x8(%ebp)
80100277:	e8 76 13 00 00       	call   801015f2 <iunlock>
  target = n;
8010027c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010027f:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100286:	e8 0e 3c 00 00       	call   80103e99 <acquire>
  while(n > 0){
8010028b:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010028e:	bb 40 2b 11 80       	mov    $0x80112b40,%ebx
  while(n > 0){
80100293:	85 f6                	test   %esi,%esi
80100295:	7e 6a                	jle    80100301 <consoleread+0x9d>
    while(input.r == input.w){
80100297:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
8010029d:	3b 8b 84 00 00 00    	cmp    0x84(%ebx),%ecx
801002a3:	75 2e                	jne    801002d3 <consoleread+0x6f>
      if(myproc()->killed){
801002a5:	e8 40 31 00 00       	call   801033ea <myproc>
801002aa:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ae:	75 73                	jne    80100323 <consoleread+0xbf>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 c0 2b 11 80       	push   $0x80112bc0
801002bd:	e8 f2 35 00 00       	call   801038b4 <sleep>
    while(input.r == input.w){
801002c2:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
801002c8:	83 c4 10             	add    $0x10,%esp
801002cb:	3b 8b 84 00 00 00    	cmp    0x84(%ebx),%ecx
801002d1:	74 d2                	je     801002a5 <consoleread+0x41>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d3:	8d 41 01             	lea    0x1(%ecx),%eax
801002d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
801002dc:	89 c8                	mov    %ecx,%eax
801002de:	83 e0 7f             	and    $0x7f,%eax
801002e1:	0f b6 04 03          	movzbl (%ebx,%eax,1),%eax
801002e5:	0f be d0             	movsbl %al,%edx
    if(c == C('D')){  // EOF
801002e8:	3c 04                	cmp    $0x4,%al
801002ea:	74 5f                	je     8010034b <consoleread+0xe7>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801002ef:	03 7d 0c             	add    0xc(%ebp),%edi
801002f2:	89 f1                	mov    %esi,%ecx
801002f4:	f7 d9                	neg    %ecx
801002f6:	88 04 0f             	mov    %al,(%edi,%ecx,1)
    --n;
801002f9:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002fc:	83 fa 0a             	cmp    $0xa,%edx
801002ff:	75 92                	jne    80100293 <consoleread+0x2f>
      break;
  }
  release(&cons.lock);
80100301:	83 ec 0c             	sub    $0xc,%esp
80100304:	68 20 b5 10 80       	push   $0x8010b520
80100309:	e8 f6 3b 00 00       	call   80103f04 <release>
  ilock(ip);
8010030e:	83 c4 04             	add    $0x4,%esp
80100311:	ff 75 08             	pushl  0x8(%ebp)
80100314:	e8 13 12 00 00       	call   8010152c <ilock>

  return target - n;
80100319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010031c:	29 f0                	sub    %esi,%eax
8010031e:	83 c4 10             	add    $0x10,%esp
80100321:	eb 20                	jmp    80100343 <consoleread+0xdf>
        release(&cons.lock);
80100323:	83 ec 0c             	sub    $0xc,%esp
80100326:	68 20 b5 10 80       	push   $0x8010b520
8010032b:	e8 d4 3b 00 00       	call   80103f04 <release>
        ilock(ip);
80100330:	83 c4 04             	add    $0x4,%esp
80100333:	ff 75 08             	pushl  0x8(%ebp)
80100336:	e8 f1 11 00 00       	call   8010152c <ilock>
        return -1;
8010033b:	83 c4 10             	add    $0x10,%esp
8010033e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100346:	5b                   	pop    %ebx
80100347:	5e                   	pop    %esi
80100348:	5f                   	pop    %edi
80100349:	5d                   	pop    %ebp
8010034a:	c3                   	ret    
      if(n < target){
8010034b:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010034e:	73 b1                	jae    80100301 <consoleread+0x9d>
        input.r--;
80100350:	89 0d c0 2b 11 80    	mov    %ecx,0x80112bc0
80100356:	eb a9                	jmp    80100301 <consoleread+0x9d>

80100358 <panic>:
{
80100358:	f3 0f 1e fb          	endbr32 
8010035c:	55                   	push   %ebp
8010035d:	89 e5                	mov    %esp,%ebp
8010035f:	56                   	push   %esi
80100360:	53                   	push   %ebx
80100361:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100364:	fa                   	cli    
  cons.locking = 0;
80100365:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
8010036c:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010036f:	e8 90 21 00 00       	call   80102504 <lapicid>
80100374:	83 ec 08             	sub    $0x8,%esp
80100377:	50                   	push   %eax
80100378:	68 ad 78 10 80       	push   $0x801078ad
8010037d:	e8 aa 02 00 00       	call   8010062c <cprintf>
  cprintf(s);
80100382:	83 c4 04             	add    $0x4,%esp
80100385:	ff 75 08             	pushl  0x8(%ebp)
80100388:	e8 9f 02 00 00       	call   8010062c <cprintf>
  cprintf("\n");
8010038d:	c7 04 24 1f 82 10 80 	movl   $0x8010821f,(%esp)
80100394:	e8 93 02 00 00       	call   8010062c <cprintf>
  getcallerpcs(&s, pcs);
80100399:	83 c4 08             	add    $0x8,%esp
8010039c:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010039f:	53                   	push   %ebx
801003a0:	8d 45 08             	lea    0x8(%ebp),%eax
801003a3:	50                   	push   %eax
801003a4:	e8 b3 39 00 00       	call   80103d5c <getcallerpcs>
  for(i=0; i<10; i++)
801003a9:	8d 75 f8             	lea    -0x8(%ebp),%esi
801003ac:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003af:	83 ec 08             	sub    $0x8,%esp
801003b2:	ff 33                	pushl  (%ebx)
801003b4:	68 77 7e 10 80       	push   $0x80107e77
801003b9:	e8 6e 02 00 00       	call   8010062c <cprintf>
  for(i=0; i<10; i++)
801003be:	83 c3 04             	add    $0x4,%ebx
801003c1:	83 c4 10             	add    $0x10,%esp
801003c4:	39 f3                	cmp    %esi,%ebx
801003c6:	75 e7                	jne    801003af <panic+0x57>
  panicked = 1; // freeze other CPU
801003c8:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003cf:	00 00 00 
  for(;;)
801003d2:	eb fe                	jmp    801003d2 <panic+0x7a>

801003d4 <consputc>:
  if(panicked){
801003d4:	83 3d 58 b5 10 80 00 	cmpl   $0x0,0x8010b558
801003db:	74 03                	je     801003e0 <consputc+0xc>
801003dd:	fa                   	cli    
    for(;;)
801003de:	eb fe                	jmp    801003de <consputc+0xa>
{
801003e0:	55                   	push   %ebp
801003e1:	89 e5                	mov    %esp,%ebp
801003e3:	57                   	push   %edi
801003e4:	56                   	push   %esi
801003e5:	53                   	push   %ebx
801003e6:	83 ec 0c             	sub    $0xc,%esp
801003e9:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003eb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003f0:	0f 84 b2 00 00 00    	je     801004a8 <consputc+0xd4>
    uartputc(c);
801003f6:	83 ec 0c             	sub    $0xc,%esp
801003f9:	50                   	push   %eax
801003fa:	e8 71 4f 00 00       	call   80105370 <uartputc>
801003ff:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100402:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100407:	b8 0e 00 00 00       	mov    $0xe,%eax
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100414:	89 ca                	mov    %ecx,%edx
80100416:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100417:	0f b6 c0             	movzbl %al,%eax
8010041a:	c1 e0 08             	shl    $0x8,%eax
8010041d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100424:	89 da                	mov    %ebx,%edx
80100426:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100427:	89 ca                	mov    %ecx,%edx
80100429:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010042a:	0f b6 d8             	movzbl %al,%ebx
8010042d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010042f:	83 fe 0a             	cmp    $0xa,%esi
80100432:	0f 84 9a 00 00 00    	je     801004d2 <consputc+0xfe>
  else if(c == BACKSPACE){
80100438:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010043e:	0f 84 aa 00 00 00    	je     801004ee <consputc+0x11a>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100444:	89 f0                	mov    %esi,%eax
80100446:	0f b6 c0             	movzbl %al,%eax
80100449:	80 cc 07             	or     $0x7,%ah
8010044c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100453:	80 
80100454:	8d 5b 01             	lea    0x1(%ebx),%ebx
  if(pos < 0 || pos > 25*80)
80100457:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010045d:	0f 87 9a 00 00 00    	ja     801004fd <consputc+0x129>
  if((pos/80) >= 24){  // Scroll up.
80100463:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100469:	0f 8f 9b 00 00 00    	jg     8010050a <consputc+0x136>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046f:	be d4 03 00 00       	mov    $0x3d4,%esi
80100474:	b8 0e 00 00 00       	mov    $0xe,%eax
80100479:	89 f2                	mov    %esi,%edx
8010047b:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010047c:	89 d8                	mov    %ebx,%eax
8010047e:	c1 f8 08             	sar    $0x8,%eax
80100481:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100486:	89 ca                	mov    %ecx,%edx
80100488:	ee                   	out    %al,(%dx)
80100489:	b8 0f 00 00 00       	mov    $0xf,%eax
8010048e:	89 f2                	mov    %esi,%edx
80100490:	ee                   	out    %al,(%dx)
80100491:	89 d8                	mov    %ebx,%eax
80100493:	89 ca                	mov    %ecx,%edx
80100495:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100496:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
8010049d:	80 20 07 
}
801004a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004a3:	5b                   	pop    %ebx
801004a4:	5e                   	pop    %esi
801004a5:	5f                   	pop    %edi
801004a6:	5d                   	pop    %ebp
801004a7:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004a8:	83 ec 0c             	sub    $0xc,%esp
801004ab:	6a 08                	push   $0x8
801004ad:	e8 be 4e 00 00       	call   80105370 <uartputc>
801004b2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004b9:	e8 b2 4e 00 00       	call   80105370 <uartputc>
801004be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004c5:	e8 a6 4e 00 00       	call   80105370 <uartputc>
801004ca:	83 c4 10             	add    $0x10,%esp
801004cd:	e9 30 ff ff ff       	jmp    80100402 <consputc+0x2e>
    pos += 80 - pos%80;
801004d2:	ba 67 66 66 66       	mov    $0x66666667,%edx
801004d7:	89 d8                	mov    %ebx,%eax
801004d9:	f7 ea                	imul   %edx
801004db:	89 d0                	mov    %edx,%eax
801004dd:	c1 f8 05             	sar    $0x5,%eax
801004e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
801004e3:	c1 e0 04             	shl    $0x4,%eax
801004e6:	8d 58 50             	lea    0x50(%eax),%ebx
801004e9:	e9 69 ff ff ff       	jmp    80100457 <consputc+0x83>
    if(pos > 0) --pos;
801004ee:	85 db                	test   %ebx,%ebx
801004f0:	0f 9f c0             	setg   %al
801004f3:	0f b6 c0             	movzbl %al,%eax
801004f6:	29 c3                	sub    %eax,%ebx
801004f8:	e9 5a ff ff ff       	jmp    80100457 <consputc+0x83>
    panic("pos under/overflow");
801004fd:	83 ec 0c             	sub    $0xc,%esp
80100500:	68 c1 78 10 80       	push   $0x801078c1
80100505:	e8 4e fe ff ff       	call   80100358 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010050a:	83 ec 04             	sub    $0x4,%esp
8010050d:	68 60 0e 00 00       	push   $0xe60
80100512:	68 a0 80 0b 80       	push   $0x800b80a0
80100517:	68 00 80 0b 80       	push   $0x800b8000
8010051c:	e8 bb 3a 00 00       	call   80103fdc <memmove>
    pos -= 80;
80100521:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100524:	83 c4 0c             	add    $0xc,%esp
80100527:	b8 80 07 00 00       	mov    $0x780,%eax
8010052c:	29 d8                	sub    %ebx,%eax
8010052e:	01 c0                	add    %eax,%eax
80100530:	50                   	push   %eax
80100531:	6a 00                	push   $0x0
80100533:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
8010053a:	50                   	push   %eax
8010053b:	e8 0f 3a 00 00       	call   80103f4f <memset>
80100540:	83 c4 10             	add    $0x10,%esp
80100543:	e9 27 ff ff ff       	jmp    8010046f <consputc+0x9b>

80100548 <printint>:
{
80100548:	55                   	push   %ebp
80100549:	89 e5                	mov    %esp,%ebp
8010054b:	57                   	push   %edi
8010054c:	56                   	push   %esi
8010054d:	53                   	push   %ebx
8010054e:	83 ec 2c             	sub    $0x2c,%esp
80100551:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
80100553:	85 c9                	test   %ecx,%ecx
80100555:	74 04                	je     8010055b <printint+0x13>
80100557:	85 c0                	test   %eax,%eax
80100559:	78 61                	js     801005bc <printint+0x74>
    x = xx;
8010055b:	89 c1                	mov    %eax,%ecx
8010055d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
80100564:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100569:	89 df                	mov    %ebx,%edi
8010056b:	83 c3 01             	add    $0x1,%ebx
8010056e:	89 c8                	mov    %ecx,%eax
80100570:	ba 00 00 00 00       	mov    $0x0,%edx
80100575:	f7 f6                	div    %esi
80100577:	0f b6 92 ec 78 10 80 	movzbl -0x7fef8714(%edx),%edx
8010057e:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100582:	89 ca                	mov    %ecx,%edx
80100584:	89 c1                	mov    %eax,%ecx
80100586:	39 d6                	cmp    %edx,%esi
80100588:	76 df                	jbe    80100569 <printint+0x21>
  if(sign)
8010058a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010058e:	74 08                	je     80100598 <printint+0x50>
    buf[i++] = '-';
80100590:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100595:	8d 5f 02             	lea    0x2(%edi),%ebx
  while(--i >= 0)
80100598:	85 db                	test   %ebx,%ebx
8010059a:	7e 18                	jle    801005b4 <printint+0x6c>
8010059c:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
801005a0:	8d 75 d8             	lea    -0x28(%ebp),%esi
    consputc(buf[i]);
801005a3:	0f be 03             	movsbl (%ebx),%eax
801005a6:	e8 29 fe ff ff       	call   801003d4 <consputc>
  while(--i >= 0)
801005ab:	89 d8                	mov    %ebx,%eax
801005ad:	83 eb 01             	sub    $0x1,%ebx
801005b0:	39 f0                	cmp    %esi,%eax
801005b2:	75 ef                	jne    801005a3 <printint+0x5b>
}
801005b4:	83 c4 2c             	add    $0x2c,%esp
801005b7:	5b                   	pop    %ebx
801005b8:	5e                   	pop    %esi
801005b9:	5f                   	pop    %edi
801005ba:	5d                   	pop    %ebp
801005bb:	c3                   	ret    
    x = -xx;
801005bc:	f7 d8                	neg    %eax
801005be:	89 c1                	mov    %eax,%ecx
  if(sign && (sign = xx < 0))
801005c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801005c7:	eb 9b                	jmp    80100564 <printint+0x1c>

801005c9 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c9:	f3 0f 1e fb          	endbr32 
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	57                   	push   %edi
801005d1:	56                   	push   %esi
801005d2:	53                   	push   %ebx
801005d3:	83 ec 18             	sub    $0x18,%esp
801005d6:	8b 75 0c             	mov    0xc(%ebp),%esi
801005d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
801005dc:	ff 75 08             	pushl  0x8(%ebp)
801005df:	e8 0e 10 00 00       	call   801015f2 <iunlock>
  acquire(&cons.lock);
801005e4:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801005eb:	e8 a9 38 00 00       	call   80103e99 <acquire>
  for(i = 0; i < n; i++)
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	85 ff                	test   %edi,%edi
801005f5:	7e 13                	jle    8010060a <consolewrite+0x41>
801005f7:	89 f3                	mov    %esi,%ebx
801005f9:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005fb:	0f b6 03             	movzbl (%ebx),%eax
801005fe:	e8 d1 fd ff ff       	call   801003d4 <consputc>
  for(i = 0; i < n; i++)
80100603:	83 c3 01             	add    $0x1,%ebx
80100606:	39 f3                	cmp    %esi,%ebx
80100608:	75 f1                	jne    801005fb <consolewrite+0x32>
  release(&cons.lock);
8010060a:	83 ec 0c             	sub    $0xc,%esp
8010060d:	68 20 b5 10 80       	push   $0x8010b520
80100612:	e8 ed 38 00 00       	call   80103f04 <release>
  ilock(ip);
80100617:	83 c4 04             	add    $0x4,%esp
8010061a:	ff 75 08             	pushl  0x8(%ebp)
8010061d:	e8 0a 0f 00 00       	call   8010152c <ilock>

  return n;
}
80100622:	89 f8                	mov    %edi,%eax
80100624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    

8010062c <cprintf>:
{
8010062c:	f3 0f 1e fb          	endbr32 
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100639:	a1 54 b5 10 80       	mov    0x8010b554,%eax
8010063e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100641:	85 c0                	test   %eax,%eax
80100643:	75 2b                	jne    80100670 <cprintf+0x44>
  if (fmt == 0)
80100645:	8b 7d 08             	mov    0x8(%ebp),%edi
80100648:	85 ff                	test   %edi,%edi
8010064a:	74 36                	je     80100682 <cprintf+0x56>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064c:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
8010064f:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100652:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100655:	bb 00 00 00 00       	mov    $0x0,%ebx
8010065a:	85 c0                	test   %eax,%eax
8010065c:	75 41                	jne    8010069f <cprintf+0x73>
  if(locking)
8010065e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80100662:	0f 85 0e 01 00 00    	jne    80100776 <cprintf+0x14a>
}
80100668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066b:	5b                   	pop    %ebx
8010066c:	5e                   	pop    %esi
8010066d:	5f                   	pop    %edi
8010066e:	5d                   	pop    %ebp
8010066f:	c3                   	ret    
    acquire(&cons.lock);
80100670:	83 ec 0c             	sub    $0xc,%esp
80100673:	68 20 b5 10 80       	push   $0x8010b520
80100678:	e8 1c 38 00 00       	call   80103e99 <acquire>
8010067d:	83 c4 10             	add    $0x10,%esp
80100680:	eb c3                	jmp    80100645 <cprintf+0x19>
    panic("null fmt");
80100682:	83 ec 0c             	sub    $0xc,%esp
80100685:	68 db 78 10 80       	push   $0x801078db
8010068a:	e8 c9 fc ff ff       	call   80100358 <panic>
      consputc(c);
8010068f:	e8 40 fd ff ff       	call   801003d4 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100694:	83 c3 01             	add    $0x1,%ebx
80100697:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010069b:	85 c0                	test   %eax,%eax
8010069d:	74 bf                	je     8010065e <cprintf+0x32>
    if(c != '%'){
8010069f:	83 f8 25             	cmp    $0x25,%eax
801006a2:	75 eb                	jne    8010068f <cprintf+0x63>
    c = fmt[++i] & 0xff;
801006a4:	83 c3 01             	add    $0x1,%ebx
801006a7:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
801006ab:	85 f6                	test   %esi,%esi
801006ad:	74 af                	je     8010065e <cprintf+0x32>
    switch(c){
801006af:	83 fe 70             	cmp    $0x70,%esi
801006b2:	74 3a                	je     801006ee <cprintf+0xc2>
801006b4:	7f 2e                	jg     801006e4 <cprintf+0xb8>
801006b6:	83 fe 25             	cmp    $0x25,%esi
801006b9:	0f 84 92 00 00 00    	je     80100751 <cprintf+0x125>
801006bf:	83 fe 64             	cmp    $0x64,%esi
801006c2:	0f 85 98 00 00 00    	jne    80100760 <cprintf+0x134>
      printint(*argp++, 10, 1);
801006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cb:	8d 70 04             	lea    0x4(%eax),%esi
801006ce:	b9 01 00 00 00       	mov    $0x1,%ecx
801006d3:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d8:	8b 00                	mov    (%eax),%eax
801006da:	e8 69 fe ff ff       	call   80100548 <printint>
801006df:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006e2:	eb b0                	jmp    80100694 <cprintf+0x68>
    switch(c){
801006e4:	83 fe 73             	cmp    $0x73,%esi
801006e7:	74 21                	je     8010070a <cprintf+0xde>
801006e9:	83 fe 78             	cmp    $0x78,%esi
801006ec:	75 72                	jne    80100760 <cprintf+0x134>
      printint(*argp++, 16, 0);
801006ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006f1:	8d 70 04             	lea    0x4(%eax),%esi
801006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006f9:	ba 10 00 00 00       	mov    $0x10,%edx
801006fe:	8b 00                	mov    (%eax),%eax
80100700:	e8 43 fe ff ff       	call   80100548 <printint>
80100705:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
80100708:	eb 8a                	jmp    80100694 <cprintf+0x68>
      if((s = (char*)*argp++) == 0)
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	8d 50 04             	lea    0x4(%eax),%edx
80100710:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100713:	8b 00                	mov    (%eax),%eax
80100715:	85 c0                	test   %eax,%eax
80100717:	74 11                	je     8010072a <cprintf+0xfe>
80100719:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
8010071b:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
8010071e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
80100721:	84 c0                	test   %al,%al
80100723:	75 0f                	jne    80100734 <cprintf+0x108>
80100725:	e9 6a ff ff ff       	jmp    80100694 <cprintf+0x68>
        s = "(null)";
8010072a:	be d4 78 10 80       	mov    $0x801078d4,%esi
      for(; *s; s++)
8010072f:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
80100734:	0f be c0             	movsbl %al,%eax
80100737:	e8 98 fc ff ff       	call   801003d4 <consputc>
      for(; *s; s++)
8010073c:	83 c6 01             	add    $0x1,%esi
8010073f:	0f b6 06             	movzbl (%esi),%eax
80100742:	84 c0                	test   %al,%al
80100744:	75 ee                	jne    80100734 <cprintf+0x108>
      if((s = (char*)*argp++) == 0)
80100746:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010074c:	e9 43 ff ff ff       	jmp    80100694 <cprintf+0x68>
      consputc('%');
80100751:	b8 25 00 00 00       	mov    $0x25,%eax
80100756:	e8 79 fc ff ff       	call   801003d4 <consputc>
      break;
8010075b:	e9 34 ff ff ff       	jmp    80100694 <cprintf+0x68>
      consputc('%');
80100760:	b8 25 00 00 00       	mov    $0x25,%eax
80100765:	e8 6a fc ff ff       	call   801003d4 <consputc>
      consputc(c);
8010076a:	89 f0                	mov    %esi,%eax
8010076c:	e8 63 fc ff ff       	call   801003d4 <consputc>
      break;
80100771:	e9 1e ff ff ff       	jmp    80100694 <cprintf+0x68>
    release(&cons.lock);
80100776:	83 ec 0c             	sub    $0xc,%esp
80100779:	68 20 b5 10 80       	push   $0x8010b520
8010077e:	e8 81 37 00 00       	call   80103f04 <release>
80100783:	83 c4 10             	add    $0x10,%esp
}
80100786:	e9 dd fe ff ff       	jmp    80100668 <cprintf+0x3c>

8010078b <consoleintr>:
{
8010078b:	f3 0f 1e fb          	endbr32 
8010078f:	55                   	push   %ebp
80100790:	89 e5                	mov    %esp,%ebp
80100792:	57                   	push   %edi
80100793:	56                   	push   %esi
80100794:	53                   	push   %ebx
80100795:	83 ec 28             	sub    $0x28,%esp
80100798:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010079b:	68 20 b5 10 80       	push   $0x8010b520
801007a0:	e8 f4 36 00 00       	call   80103e99 <acquire>
  while((c = getc()) >= 0){
801007a5:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801007a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      while(input.e != input.w &&
801007af:	bb 40 2b 11 80       	mov    $0x80112b40,%ebx
  while((c = getc()) >= 0){
801007b4:	eb 19                	jmp    801007cf <consoleintr+0x44>
    switch(c){
801007b6:	83 fe 08             	cmp    $0x8,%esi
801007b9:	0f 84 cf 00 00 00    	je     8010088e <consoleintr+0x103>
801007bf:	83 fe 10             	cmp    $0x10,%esi
801007c2:	0f 85 f0 00 00 00    	jne    801008b8 <consoleintr+0x12d>
801007c8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
801007cf:	ff d7                	call   *%edi
801007d1:	89 c6                	mov    %eax,%esi
801007d3:	85 c0                	test   %eax,%eax
801007d5:	0f 88 ea 00 00 00    	js     801008c5 <consoleintr+0x13a>
    switch(c){
801007db:	83 fe 15             	cmp    $0x15,%esi
801007de:	74 67                	je     80100847 <consoleintr+0xbc>
801007e0:	7e d4                	jle    801007b6 <consoleintr+0x2b>
801007e2:	83 fe 7f             	cmp    $0x7f,%esi
801007e5:	0f 84 a3 00 00 00    	je     8010088e <consoleintr+0x103>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007eb:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801007f1:	89 c2                	mov    %eax,%edx
801007f3:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
801007f9:	83 fa 7f             	cmp    $0x7f,%edx
801007fc:	77 d1                	ja     801007cf <consoleintr+0x44>
        c = (c == '\r') ? '\n' : c;
801007fe:	83 fe 0d             	cmp    $0xd,%esi
80100801:	0f 84 e3 00 00 00    	je     801008ea <consoleintr+0x15f>
        input.buf[input.e++ % INPUT_BUF] = c;
80100807:	8d 50 01             	lea    0x1(%eax),%edx
8010080a:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
80100810:	83 e0 7f             	and    $0x7f,%eax
80100813:	89 f1                	mov    %esi,%ecx
80100815:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        consputc(c);
80100818:	89 f0                	mov    %esi,%eax
8010081a:	e8 b5 fb ff ff       	call   801003d4 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010081f:	83 fe 0a             	cmp    $0xa,%esi
80100822:	0f 84 dc 00 00 00    	je     80100904 <consoleintr+0x179>
80100828:	83 fe 04             	cmp    $0x4,%esi
8010082b:	0f 84 d3 00 00 00    	je     80100904 <consoleintr+0x179>
80100831:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80100837:	83 e8 80             	sub    $0xffffff80,%eax
8010083a:	39 83 88 00 00 00    	cmp    %eax,0x88(%ebx)
80100840:	75 8d                	jne    801007cf <consoleintr+0x44>
80100842:	e9 bd 00 00 00       	jmp    80100904 <consoleintr+0x179>
      while(input.e != input.w &&
80100847:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010084d:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100853:	0f 84 76 ff ff ff    	je     801007cf <consoleintr+0x44>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100859:	83 e8 01             	sub    $0x1,%eax
8010085c:	89 c2                	mov    %eax,%edx
8010085e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100861:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
80100865:	0f 84 64 ff ff ff    	je     801007cf <consoleintr+0x44>
        input.e--;
8010086b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
80100871:	b8 00 01 00 00       	mov    $0x100,%eax
80100876:	e8 59 fb ff ff       	call   801003d4 <consputc>
      while(input.e != input.w &&
8010087b:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100881:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100887:	75 d0                	jne    80100859 <consoleintr+0xce>
80100889:	e9 41 ff ff ff       	jmp    801007cf <consoleintr+0x44>
      if(input.e != input.w){
8010088e:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100894:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
8010089a:	0f 84 2f ff ff ff    	je     801007cf <consoleintr+0x44>
        input.e--;
801008a0:	83 e8 01             	sub    $0x1,%eax
801008a3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
801008a9:	b8 00 01 00 00       	mov    $0x100,%eax
801008ae:	e8 21 fb ff ff       	call   801003d4 <consputc>
801008b3:	e9 17 ff ff ff       	jmp    801007cf <consoleintr+0x44>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	85 f6                	test   %esi,%esi
801008ba:	0f 84 0f ff ff ff    	je     801007cf <consoleintr+0x44>
801008c0:	e9 26 ff ff ff       	jmp    801007eb <consoleintr+0x60>
  release(&cons.lock);
801008c5:	83 ec 0c             	sub    $0xc,%esp
801008c8:	68 20 b5 10 80       	push   $0x8010b520
801008cd:	e8 32 36 00 00       	call   80103f04 <release>
  if(doprocdump) {
801008d2:	83 c4 10             	add    $0x10,%esp
801008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801008d9:	75 08                	jne    801008e3 <consoleintr+0x158>
}
801008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008de:	5b                   	pop    %ebx
801008df:	5e                   	pop    %esi
801008e0:	5f                   	pop    %edi
801008e1:	5d                   	pop    %ebp
801008e2:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008e3:	e8 f7 31 00 00       	call   80103adf <procdump>
}
801008e8:	eb f1                	jmp    801008db <consoleintr+0x150>
        input.buf[input.e++ % INPUT_BUF] = c;
801008ea:	8d 50 01             	lea    0x1(%eax),%edx
801008ed:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
801008f3:	83 e0 7f             	and    $0x7f,%eax
801008f6:	c6 04 03 0a          	movb   $0xa,(%ebx,%eax,1)
        consputc(c);
801008fa:	b8 0a 00 00 00       	mov    $0xa,%eax
801008ff:	e8 d0 fa ff ff       	call   801003d4 <consputc>
          input.w = input.e;
80100904:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010090a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
          wakeup(&input.r);
80100910:	83 ec 0c             	sub    $0xc,%esp
80100913:	68 c0 2b 11 80       	push   $0x80112bc0
80100918:	e8 1d 31 00 00       	call   80103a3a <wakeup>
8010091d:	83 c4 10             	add    $0x10,%esp
80100920:	e9 aa fe ff ff       	jmp    801007cf <consoleintr+0x44>

80100925 <consoleinit>:

void
consoleinit(void)
{
80100925:	f3 0f 1e fb          	endbr32 
80100929:	55                   	push   %ebp
8010092a:	89 e5                	mov    %esp,%ebp
8010092c:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
8010092f:	68 e4 78 10 80       	push   $0x801078e4
80100934:	68 20 b5 10 80       	push   $0x8010b520
80100939:	e8 ff 33 00 00       	call   80103d3d <initlock>

  devsw[CONSOLE].write = consolewrite;
8010093e:	c7 05 8c 35 11 80 c9 	movl   $0x801005c9,0x8011358c
80100945:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100948:	c7 05 88 35 11 80 64 	movl   $0x80100264,0x80113588
8010094f:	02 10 80 
  cons.locking = 1;
80100952:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100959:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
8010095c:	83 c4 08             	add    $0x8,%esp
8010095f:	6a 00                	push   $0x0
80100961:	6a 01                	push   $0x1
80100963:	e8 1c 17 00 00       	call   80102084 <ioapicenable>
}
80100968:	83 c4 10             	add    $0x10,%esp
8010096b:	c9                   	leave  
8010096c:	c3                   	ret    

8010096d <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
8010096d:	f3 0f 1e fb          	endbr32 
80100971:	55                   	push   %ebp
80100972:	89 e5                	mov    %esp,%ebp
80100974:	57                   	push   %edi
80100975:	56                   	push   %esi
80100976:	53                   	push   %ebx
80100977:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010097d:	e8 68 2a 00 00       	call   801033ea <myproc>
80100982:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100988:	e8 f3 1e 00 00       	call   80102880 <begin_op>

  if((ip = namei(path)) == 0){
8010098d:	83 ec 0c             	sub    $0xc,%esp
80100990:	ff 75 08             	pushl  0x8(%ebp)
80100993:	e8 4c 13 00 00       	call   80101ce4 <namei>
80100998:	83 c4 10             	add    $0x10,%esp
8010099b:	85 c0                	test   %eax,%eax
8010099d:	74 4e                	je     801009ed <exec+0x80>
8010099f:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009a1:	83 ec 0c             	sub    $0xc,%esp
801009a4:	50                   	push   %eax
801009a5:	e8 82 0b 00 00       	call   8010152c <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009aa:	6a 34                	push   $0x34
801009ac:	6a 00                	push   $0x0
801009ae:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009b4:	50                   	push   %eax
801009b5:	53                   	push   %ebx
801009b6:	e8 19 0e 00 00       	call   801017d4 <readi>
801009bb:	83 c4 20             	add    $0x20,%esp
801009be:	83 f8 34             	cmp    $0x34,%eax
801009c1:	75 0c                	jne    801009cf <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801009c3:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801009ca:	45 4c 46 
801009cd:	74 3a                	je     80100a09 <exec+0x9c>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801009cf:	83 ec 0c             	sub    $0xc,%esp
801009d2:	53                   	push   %ebx
801009d3:	e8 a9 0d 00 00       	call   80101781 <iunlockput>
    end_op();
801009d8:	e8 22 1f 00 00       	call   801028ff <end_op>
801009dd:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801009e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801009e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009e8:	5b                   	pop    %ebx
801009e9:	5e                   	pop    %esi
801009ea:	5f                   	pop    %edi
801009eb:	5d                   	pop    %ebp
801009ec:	c3                   	ret    
    end_op();
801009ed:	e8 0d 1f 00 00       	call   801028ff <end_op>
    cprintf("exec: fail\n");
801009f2:	83 ec 0c             	sub    $0xc,%esp
801009f5:	68 fd 78 10 80       	push   $0x801078fd
801009fa:	e8 2d fc ff ff       	call   8010062c <cprintf>
    return -1;
801009ff:	83 c4 10             	add    $0x10,%esp
80100a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a07:	eb dc                	jmp    801009e5 <exec+0x78>
  if((pgdir = setupkvm()) == 0)
80100a09:	e8 f0 5a 00 00       	call   801064fe <setupkvm>
80100a0e:	89 c7                	mov    %eax,%edi
80100a10:	85 c0                	test   %eax,%eax
80100a12:	74 bb                	je     801009cf <exec+0x62>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a14:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100a1a:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a21:	00 
80100a22:	0f 84 c3 00 00 00    	je     80100aeb <exec+0x17e>
  sz = 0;
80100a28:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a2f:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a32:	be 00 00 00 00       	mov    $0x0,%esi
80100a37:	eb 1b                	jmp    80100a54 <exec+0xe7>
80100a39:	83 c6 01             	add    $0x1,%esi
80100a3c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a42:	83 c0 20             	add    $0x20,%eax
80100a45:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100a4c:	39 f2                	cmp    %esi,%edx
80100a4e:	0f 8e a1 00 00 00    	jle    80100af5 <exec+0x188>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a54:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a5a:	6a 20                	push   $0x20
80100a5c:	50                   	push   %eax
80100a5d:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a63:	50                   	push   %eax
80100a64:	53                   	push   %ebx
80100a65:	e8 6a 0d 00 00       	call   801017d4 <readi>
80100a6a:	83 c4 10             	add    $0x10,%esp
80100a6d:	83 f8 20             	cmp    $0x20,%eax
80100a70:	0f 85 c0 00 00 00    	jne    80100b36 <exec+0x1c9>
    if(ph.type != ELF_PROG_LOAD)
80100a76:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a7d:	75 ba                	jne    80100a39 <exec+0xcc>
    if(ph.memsz < ph.filesz)
80100a7f:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a85:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a8b:	0f 82 a5 00 00 00    	jb     80100b36 <exec+0x1c9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a91:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a97:	0f 82 99 00 00 00    	jb     80100b36 <exec+0x1c9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a9d:	83 ec 04             	sub    $0x4,%esp
80100aa0:	50                   	push   %eax
80100aa1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100aa7:	57                   	push   %edi
80100aa8:	e8 e8 58 00 00       	call   80106395 <allocuvm>
80100aad:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ab3:	83 c4 10             	add    $0x10,%esp
80100ab6:	85 c0                	test   %eax,%eax
80100ab8:	74 7c                	je     80100b36 <exec+0x1c9>
    if(ph.vaddr % PGSIZE != 0)
80100aba:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ac0:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ac5:	75 6f                	jne    80100b36 <exec+0x1c9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ac7:	83 ec 0c             	sub    $0xc,%esp
80100aca:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ad0:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ad6:	53                   	push   %ebx
80100ad7:	50                   	push   %eax
80100ad8:	57                   	push   %edi
80100ad9:	e8 74 57 00 00       	call   80106252 <loaduvm>
80100ade:	83 c4 20             	add    $0x20,%esp
80100ae1:	85 c0                	test   %eax,%eax
80100ae3:	0f 89 50 ff ff ff    	jns    80100a39 <exec+0xcc>
80100ae9:	eb 4b                	jmp    80100b36 <exec+0x1c9>
  sz = 0;
80100aeb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100af2:	00 00 00 
  iunlockput(ip);
80100af5:	83 ec 0c             	sub    $0xc,%esp
80100af8:	53                   	push   %ebx
80100af9:	e8 83 0c 00 00       	call   80101781 <iunlockput>
  end_op();
80100afe:	e8 fc 1d 00 00       	call   801028ff <end_op>
  sz = PGROUNDUP(sz);
80100b03:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b09:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b13:	83 c4 0c             	add    $0xc,%esp
80100b16:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b1c:	52                   	push   %edx
80100b1d:	50                   	push   %eax
80100b1e:	57                   	push   %edi
80100b1f:	e8 71 58 00 00       	call   80106395 <allocuvm>
80100b24:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b2a:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b32:	85 c0                	test   %eax,%eax
80100b34:	75 1e                	jne    80100b54 <exec+0x1e7>
    freevm(pgdir);
80100b36:	83 ec 0c             	sub    $0xc,%esp
80100b39:	57                   	push   %edi
80100b3a:	e8 48 59 00 00       	call   80106487 <freevm>
  if(ip){
80100b3f:	83 c4 10             	add    $0x10,%esp
80100b42:	85 db                	test   %ebx,%ebx
80100b44:	0f 85 85 fe ff ff    	jne    801009cf <exec+0x62>
  return -1;
80100b4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b4f:	e9 91 fe ff ff       	jmp    801009e5 <exec+0x78>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b54:	83 ec 08             	sub    $0x8,%esp
80100b57:	89 c3                	mov    %eax,%ebx
80100b59:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b5f:	50                   	push   %eax
80100b60:	57                   	push   %edi
80100b61:	e8 25 5a 00 00       	call   8010658b <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b66:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b69:	8b 00                	mov    (%eax),%eax
80100b6b:	83 c4 10             	add    $0x10,%esp
80100b6e:	be 00 00 00 00       	mov    $0x0,%esi
80100b73:	85 c0                	test   %eax,%eax
80100b75:	74 5f                	je     80100bd6 <exec+0x269>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b77:	83 ec 0c             	sub    $0xc,%esp
80100b7a:	50                   	push   %eax
80100b7b:	e8 9f 35 00 00       	call   8010411f <strlen>
80100b80:	f7 d0                	not    %eax
80100b82:	01 d8                	add    %ebx,%eax
80100b84:	83 e0 fc             	and    $0xfffffffc,%eax
80100b87:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b89:	83 c4 04             	add    $0x4,%esp
80100b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b8f:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b92:	e8 88 35 00 00       	call   8010411f <strlen>
80100b97:	83 c0 01             	add    $0x1,%eax
80100b9a:	50                   	push   %eax
80100b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b9e:	ff 34 b0             	pushl  (%eax,%esi,4)
80100ba1:	53                   	push   %ebx
80100ba2:	57                   	push   %edi
80100ba3:	e8 3a 5b 00 00       	call   801066e2 <copyout>
80100ba8:	83 c4 20             	add    $0x20,%esp
80100bab:	85 c0                	test   %eax,%eax
80100bad:	0f 88 f0 00 00 00    	js     80100ca3 <exec+0x336>
    ustack[3+argc] = sp;
80100bb3:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bba:	83 c6 01             	add    $0x1,%esi
80100bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bc0:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100bc3:	85 c0                	test   %eax,%eax
80100bc5:	74 15                	je     80100bdc <exec+0x26f>
    if(argc >= MAXARG)
80100bc7:	83 fe 20             	cmp    $0x20,%esi
80100bca:	75 ab                	jne    80100b77 <exec+0x20a>
  ip = 0;
80100bcc:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bd1:	e9 60 ff ff ff       	jmp    80100b36 <exec+0x1c9>
  sp = sz;
80100bd6:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
  ustack[3+argc] = 0;
80100bdc:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100be3:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100be7:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100bee:	ff ff ff 
  ustack[1] = argc;
80100bf1:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bf7:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100bfe:	89 da                	mov    %ebx,%edx
80100c00:	29 c2                	sub    %eax,%edx
80100c02:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c08:	83 c0 0c             	add    $0xc,%eax
80100c0b:	89 de                	mov    %ebx,%esi
80100c0d:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c0f:	50                   	push   %eax
80100c10:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100c16:	50                   	push   %eax
80100c17:	56                   	push   %esi
80100c18:	57                   	push   %edi
80100c19:	e8 c4 5a 00 00       	call   801066e2 <copyout>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	85 c0                	test   %eax,%eax
80100c23:	0f 88 84 00 00 00    	js     80100cad <exec+0x340>
  for(last=s=path; *s; s++)
80100c29:	8b 45 08             	mov    0x8(%ebp),%eax
80100c2c:	0f b6 10             	movzbl (%eax),%edx
80100c2f:	84 d2                	test   %dl,%dl
80100c31:	74 1a                	je     80100c4d <exec+0x2e0>
80100c33:	83 c0 01             	add    $0x1,%eax
80100c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100c39:	80 fa 2f             	cmp    $0x2f,%dl
80100c3c:	0f 44 c8             	cmove  %eax,%ecx
  for(last=s=path; *s; s++)
80100c3f:	83 c0 01             	add    $0x1,%eax
80100c42:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100c46:	84 d2                	test   %dl,%dl
80100c48:	75 ef                	jne    80100c39 <exec+0x2cc>
80100c4a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c4d:	83 ec 04             	sub    $0x4,%esp
80100c50:	6a 10                	push   $0x10
80100c52:	ff 75 08             	pushl  0x8(%ebp)
80100c55:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100c5b:	8d 43 6c             	lea    0x6c(%ebx),%eax
80100c5e:	50                   	push   %eax
80100c5f:	e8 81 34 00 00       	call   801040e5 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c64:	89 d9                	mov    %ebx,%ecx
80100c66:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c69:	89 79 04             	mov    %edi,0x4(%ecx)
  curproc->sz = sz;
80100c6c:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c72:	89 39                	mov    %edi,(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100c74:	8b 41 18             	mov    0x18(%ecx),%eax
80100c77:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c7d:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c80:	8b 41 18             	mov    0x18(%ecx),%eax
80100c83:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c86:	89 0c 24             	mov    %ecx,(%esp)
80100c89:	e8 55 54 00 00       	call   801060e3 <switchuvm>
  freevm(oldpgdir);
80100c8e:	89 1c 24             	mov    %ebx,(%esp)
80100c91:	e8 f1 57 00 00       	call   80106487 <freevm>
  return 0;
80100c96:	83 c4 10             	add    $0x10,%esp
80100c99:	b8 00 00 00 00       	mov    $0x0,%eax
80100c9e:	e9 42 fd ff ff       	jmp    801009e5 <exec+0x78>
  ip = 0;
80100ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ca8:	e9 89 fe ff ff       	jmp    80100b36 <exec+0x1c9>
80100cad:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cb2:	e9 7f fe ff ff       	jmp    80100b36 <exec+0x1c9>

80100cb7 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100cb7:	f3 0f 1e fb          	endbr32 
80100cbb:	55                   	push   %ebp
80100cbc:	89 e5                	mov    %esp,%ebp
80100cbe:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100cc1:	68 09 79 10 80       	push   $0x80107909
80100cc6:	68 e0 2b 11 80       	push   $0x80112be0
80100ccb:	e8 6d 30 00 00       	call   80103d3d <initlock>
}
80100cd0:	83 c4 10             	add    $0x10,%esp
80100cd3:	c9                   	leave  
80100cd4:	c3                   	ret    

80100cd5 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100cd5:	f3 0f 1e fb          	endbr32 
80100cd9:	55                   	push   %ebp
80100cda:	89 e5                	mov    %esp,%ebp
80100cdc:	53                   	push   %ebx
80100cdd:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ce0:	68 e0 2b 11 80       	push   $0x80112be0
80100ce5:	e8 af 31 00 00       	call   80103e99 <acquire>
80100cea:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ced:	bb 14 2c 11 80       	mov    $0x80112c14,%ebx
    if(f->ref == 0){
80100cf2:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100cf6:	74 22                	je     80100d1a <filealloc+0x45>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cf8:	83 c3 18             	add    $0x18,%ebx
80100cfb:	81 fb 74 35 11 80    	cmp    $0x80113574,%ebx
80100d01:	75 ef                	jne    80100cf2 <filealloc+0x1d>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d03:	83 ec 0c             	sub    $0xc,%esp
80100d06:	68 e0 2b 11 80       	push   $0x80112be0
80100d0b:	e8 f4 31 00 00       	call   80103f04 <release>
  return 0;
80100d10:	83 c4 10             	add    $0x10,%esp
80100d13:	bb 00 00 00 00       	mov    $0x0,%ebx
80100d18:	eb 17                	jmp    80100d31 <filealloc+0x5c>
      f->ref = 1;
80100d1a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d21:	83 ec 0c             	sub    $0xc,%esp
80100d24:	68 e0 2b 11 80       	push   $0x80112be0
80100d29:	e8 d6 31 00 00       	call   80103f04 <release>
      return f;
80100d2e:	83 c4 10             	add    $0x10,%esp
}
80100d31:	89 d8                	mov    %ebx,%eax
80100d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d36:	c9                   	leave  
80100d37:	c3                   	ret    

80100d38 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d38:	f3 0f 1e fb          	endbr32 
80100d3c:	55                   	push   %ebp
80100d3d:	89 e5                	mov    %esp,%ebp
80100d3f:	53                   	push   %ebx
80100d40:	83 ec 10             	sub    $0x10,%esp
80100d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d46:	68 e0 2b 11 80       	push   $0x80112be0
80100d4b:	e8 49 31 00 00       	call   80103e99 <acquire>
  if(f->ref < 1)
80100d50:	8b 43 04             	mov    0x4(%ebx),%eax
80100d53:	83 c4 10             	add    $0x10,%esp
80100d56:	85 c0                	test   %eax,%eax
80100d58:	7e 1a                	jle    80100d74 <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100d5a:	83 c0 01             	add    $0x1,%eax
80100d5d:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d60:	83 ec 0c             	sub    $0xc,%esp
80100d63:	68 e0 2b 11 80       	push   $0x80112be0
80100d68:	e8 97 31 00 00       	call   80103f04 <release>
  return f;
}
80100d6d:	89 d8                	mov    %ebx,%eax
80100d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d72:	c9                   	leave  
80100d73:	c3                   	ret    
    panic("filedup");
80100d74:	83 ec 0c             	sub    $0xc,%esp
80100d77:	68 10 79 10 80       	push   $0x80107910
80100d7c:	e8 d7 f5 ff ff       	call   80100358 <panic>

80100d81 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d81:	f3 0f 1e fb          	endbr32 
80100d85:	55                   	push   %ebp
80100d86:	89 e5                	mov    %esp,%ebp
80100d88:	57                   	push   %edi
80100d89:	56                   	push   %esi
80100d8a:	53                   	push   %ebx
80100d8b:	83 ec 28             	sub    $0x28,%esp
80100d8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d91:	68 e0 2b 11 80       	push   $0x80112be0
80100d96:	e8 fe 30 00 00       	call   80103e99 <acquire>
  if(f->ref < 1)
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	83 c4 10             	add    $0x10,%esp
80100da1:	85 c0                	test   %eax,%eax
80100da3:	7e 5d                	jle    80100e02 <fileclose+0x81>
    panic("fileclose");
  if(--f->ref > 0){
80100da5:	83 e8 01             	sub    $0x1,%eax
80100da8:	89 43 04             	mov    %eax,0x4(%ebx)
80100dab:	85 c0                	test   %eax,%eax
80100dad:	7f 60                	jg     80100e0f <fileclose+0x8e>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100daf:	8b 33                	mov    (%ebx),%esi
80100db1:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100db5:	88 45 e7             	mov    %al,-0x19(%ebp)
80100db8:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100dbb:	8b 43 10             	mov    0x10(%ebx),%eax
80100dbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100dc1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100dc8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100dce:	83 ec 0c             	sub    $0xc,%esp
80100dd1:	68 e0 2b 11 80       	push   $0x80112be0
80100dd6:	e8 29 31 00 00       	call   80103f04 <release>

  if(ff.type == FD_PIPE)
80100ddb:	83 c4 10             	add    $0x10,%esp
80100dde:	83 fe 01             	cmp    $0x1,%esi
80100de1:	74 44                	je     80100e27 <fileclose+0xa6>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100de3:	83 fe 02             	cmp    $0x2,%esi
80100de6:	75 37                	jne    80100e1f <fileclose+0x9e>
    begin_op();
80100de8:	e8 93 1a 00 00       	call   80102880 <begin_op>
    iput(ff.ip);
80100ded:	83 ec 0c             	sub    $0xc,%esp
80100df0:	ff 75 e0             	pushl  -0x20(%ebp)
80100df3:	e8 43 08 00 00       	call   8010163b <iput>
    end_op();
80100df8:	e8 02 1b 00 00       	call   801028ff <end_op>
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	eb 1d                	jmp    80100e1f <fileclose+0x9e>
    panic("fileclose");
80100e02:	83 ec 0c             	sub    $0xc,%esp
80100e05:	68 18 79 10 80       	push   $0x80107918
80100e0a:	e8 49 f5 ff ff       	call   80100358 <panic>
    release(&ftable.lock);
80100e0f:	83 ec 0c             	sub    $0xc,%esp
80100e12:	68 e0 2b 11 80       	push   $0x80112be0
80100e17:	e8 e8 30 00 00       	call   80103f04 <release>
80100e1c:	83 c4 10             	add    $0x10,%esp
  }
}
80100e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e22:	5b                   	pop    %ebx
80100e23:	5e                   	pop    %esi
80100e24:	5f                   	pop    %edi
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100e27:	83 ec 08             	sub    $0x8,%esp
80100e2a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e2e:	50                   	push   %eax
80100e2f:	57                   	push   %edi
80100e30:	e8 80 21 00 00       	call   80102fb5 <pipeclose>
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	eb e5                	jmp    80100e1f <fileclose+0x9e>

80100e3a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e3a:	f3 0f 1e fb          	endbr32 
80100e3e:	55                   	push   %ebp
80100e3f:	89 e5                	mov    %esp,%ebp
80100e41:	53                   	push   %ebx
80100e42:	83 ec 04             	sub    $0x4,%esp
80100e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e48:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e4b:	75 31                	jne    80100e7e <filestat+0x44>
    ilock(f->ip);
80100e4d:	83 ec 0c             	sub    $0xc,%esp
80100e50:	ff 73 10             	pushl  0x10(%ebx)
80100e53:	e8 d4 06 00 00       	call   8010152c <ilock>
    stati(f->ip, st);
80100e58:	83 c4 08             	add    $0x8,%esp
80100e5b:	ff 75 0c             	pushl  0xc(%ebp)
80100e5e:	ff 73 10             	pushl  0x10(%ebx)
80100e61:	e8 3f 09 00 00       	call   801017a5 <stati>
    iunlock(f->ip);
80100e66:	83 c4 04             	add    $0x4,%esp
80100e69:	ff 73 10             	pushl  0x10(%ebx)
80100e6c:	e8 81 07 00 00       	call   801015f2 <iunlock>
    return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
80100e74:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7c:	c9                   	leave  
80100e7d:	c3                   	ret    
  return -1;
80100e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e83:	eb f4                	jmp    80100e79 <filestat+0x3f>

80100e85 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e85:	f3 0f 1e fb          	endbr32 
80100e89:	55                   	push   %ebp
80100e8a:	89 e5                	mov    %esp,%ebp
80100e8c:	56                   	push   %esi
80100e8d:	53                   	push   %ebx
80100e8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e91:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e95:	74 70                	je     80100f07 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100e97:	8b 03                	mov    (%ebx),%eax
80100e99:	83 f8 01             	cmp    $0x1,%eax
80100e9c:	74 44                	je     80100ee2 <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e9e:	83 f8 02             	cmp    $0x2,%eax
80100ea1:	75 57                	jne    80100efa <fileread+0x75>
    ilock(f->ip);
80100ea3:	83 ec 0c             	sub    $0xc,%esp
80100ea6:	ff 73 10             	pushl  0x10(%ebx)
80100ea9:	e8 7e 06 00 00       	call   8010152c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100eae:	ff 75 10             	pushl  0x10(%ebp)
80100eb1:	ff 73 14             	pushl  0x14(%ebx)
80100eb4:	ff 75 0c             	pushl  0xc(%ebp)
80100eb7:	ff 73 10             	pushl  0x10(%ebx)
80100eba:	e8 15 09 00 00       	call   801017d4 <readi>
80100ebf:	89 c6                	mov    %eax,%esi
80100ec1:	83 c4 20             	add    $0x20,%esp
80100ec4:	85 c0                	test   %eax,%eax
80100ec6:	7e 03                	jle    80100ecb <fileread+0x46>
      f->off += r;
80100ec8:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ecb:	83 ec 0c             	sub    $0xc,%esp
80100ece:	ff 73 10             	pushl  0x10(%ebx)
80100ed1:	e8 1c 07 00 00       	call   801015f2 <iunlock>
    return r;
80100ed6:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100ed9:	89 f0                	mov    %esi,%eax
80100edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100ede:	5b                   	pop    %ebx
80100edf:	5e                   	pop    %esi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ee2:	83 ec 04             	sub    $0x4,%esp
80100ee5:	ff 75 10             	pushl  0x10(%ebp)
80100ee8:	ff 75 0c             	pushl  0xc(%ebp)
80100eeb:	ff 73 0c             	pushl  0xc(%ebx)
80100eee:	e8 42 22 00 00       	call   80103135 <piperead>
80100ef3:	89 c6                	mov    %eax,%esi
80100ef5:	83 c4 10             	add    $0x10,%esp
80100ef8:	eb df                	jmp    80100ed9 <fileread+0x54>
  panic("fileread");
80100efa:	83 ec 0c             	sub    $0xc,%esp
80100efd:	68 22 79 10 80       	push   $0x80107922
80100f02:	e8 51 f4 ff ff       	call   80100358 <panic>
    return -1;
80100f07:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f0c:	eb cb                	jmp    80100ed9 <fileread+0x54>

80100f0e <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f0e:	f3 0f 1e fb          	endbr32 
80100f12:	55                   	push   %ebp
80100f13:	89 e5                	mov    %esp,%ebp
80100f15:	57                   	push   %edi
80100f16:	56                   	push   %esi
80100f17:	53                   	push   %ebx
80100f18:	83 ec 1c             	sub    $0x1c,%esp
80100f1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int r;

  if(f->writable == 0)
80100f1e:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100f22:	0f 84 ea 00 00 00    	je     80101012 <filewrite+0x104>
    return -1;
  if(f->type == FD_PIPE)
80100f28:	8b 07                	mov    (%edi),%eax
80100f2a:	83 f8 01             	cmp    $0x1,%eax
80100f2d:	74 1a                	je     80100f49 <filewrite+0x3b>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f2f:	83 f8 02             	cmp    $0x2,%eax
80100f32:	0f 85 cd 00 00 00    	jne    80101005 <filewrite+0xf7>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100f3c:	0f 8e aa 00 00 00    	jle    80100fec <filewrite+0xde>
    int i = 0;
80100f42:	bb 00 00 00 00       	mov    $0x0,%ebx
80100f47:	eb 3c                	jmp    80100f85 <filewrite+0x77>
    return pipewrite(f->pipe, addr, n);
80100f49:	83 ec 04             	sub    $0x4,%esp
80100f4c:	ff 75 10             	pushl  0x10(%ebp)
80100f4f:	ff 75 0c             	pushl  0xc(%ebp)
80100f52:	ff 77 0c             	pushl  0xc(%edi)
80100f55:	e8 eb 20 00 00       	call   80103045 <pipewrite>
80100f5a:	83 c4 10             	add    $0x10,%esp
80100f5d:	e9 9b 00 00 00       	jmp    80100ffd <filewrite+0xef>

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100f62:	83 ec 0c             	sub    $0xc,%esp
80100f65:	ff 77 10             	pushl  0x10(%edi)
80100f68:	e8 85 06 00 00       	call   801015f2 <iunlock>
      end_op();
80100f6d:	e8 8d 19 00 00       	call   801028ff <end_op>

      if(r < 0)
80100f72:	83 c4 10             	add    $0x10,%esp
80100f75:	85 f6                	test   %esi,%esi
80100f77:	78 78                	js     80100ff1 <filewrite+0xe3>
        break;
      if(r != n1)
80100f79:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100f7c:	75 61                	jne    80100fdf <filewrite+0xd1>
        panic("short filewrite");
      i += r;
80100f7e:	01 f3                	add    %esi,%ebx
    while(i < n){
80100f80:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80100f83:	7e 6c                	jle    80100ff1 <filewrite+0xe3>
      int n1 = n - i;
80100f85:	8b 45 10             	mov    0x10(%ebp),%eax
80100f88:	29 d8                	sub    %ebx,%eax
      if(n1 > max)
80100f8a:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f8f:	ba 00 06 00 00       	mov    $0x600,%edx
80100f94:	0f 4f c2             	cmovg  %edx,%eax
80100f97:	89 c6                	mov    %eax,%esi
80100f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      begin_op();
80100f9c:	e8 df 18 00 00       	call   80102880 <begin_op>
      ilock(f->ip);
80100fa1:	83 ec 0c             	sub    $0xc,%esp
80100fa4:	ff 77 10             	pushl  0x10(%edi)
80100fa7:	e8 80 05 00 00       	call   8010152c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100fac:	56                   	push   %esi
80100fad:	ff 77 14             	pushl  0x14(%edi)
80100fb0:	89 d8                	mov    %ebx,%eax
80100fb2:	03 45 0c             	add    0xc(%ebp),%eax
80100fb5:	50                   	push   %eax
80100fb6:	ff 77 10             	pushl  0x10(%edi)
80100fb9:	e8 16 09 00 00       	call   801018d4 <writei>
80100fbe:	89 c6                	mov    %eax,%esi
80100fc0:	83 c4 20             	add    $0x20,%esp
80100fc3:	85 c0                	test   %eax,%eax
80100fc5:	7e 9b                	jle    80100f62 <filewrite+0x54>
        f->off += r;
80100fc7:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
80100fca:	83 ec 0c             	sub    $0xc,%esp
80100fcd:	ff 77 10             	pushl  0x10(%edi)
80100fd0:	e8 1d 06 00 00       	call   801015f2 <iunlock>
      end_op();
80100fd5:	e8 25 19 00 00       	call   801028ff <end_op>
80100fda:	83 c4 10             	add    $0x10,%esp
80100fdd:	eb 9a                	jmp    80100f79 <filewrite+0x6b>
        panic("short filewrite");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 2b 79 10 80       	push   $0x8010792b
80100fe7:	e8 6c f3 ff ff       	call   80100358 <panic>
    int i = 0;
80100fec:	bb 00 00 00 00       	mov    $0x0,%ebx
    }
    return i == n ? n : -1;
80100ff1:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80100ff4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ff9:	0f 44 45 10          	cmove  0x10(%ebp),%eax
  }
  panic("filewrite");
}
80100ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101000:	5b                   	pop    %ebx
80101001:	5e                   	pop    %esi
80101002:	5f                   	pop    %edi
80101003:	5d                   	pop    %ebp
80101004:	c3                   	ret    
  panic("filewrite");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 31 79 10 80       	push   $0x80107931
8010100d:	e8 46 f3 ff ff       	call   80100358 <panic>
    return -1;
80101012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101017:	eb e4                	jmp    80100ffd <filewrite+0xef>

80101019 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101019:	55                   	push   %ebp
8010101a:	89 e5                	mov    %esp,%ebp
8010101c:	56                   	push   %esi
8010101d:	53                   	push   %ebx
8010101e:	89 c1                	mov    %eax,%ecx
80101020:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101022:	83 ec 08             	sub    $0x8,%esp
80101025:	89 d0                	mov    %edx,%eax
80101027:	c1 e8 0c             	shr    $0xc,%eax
8010102a:	03 05 f8 35 11 80    	add    0x801135f8,%eax
80101030:	50                   	push   %eax
80101031:	51                   	push   %ecx
80101032:	e8 77 f0 ff ff       	call   801000ae <bread>
80101037:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
80101039:	89 d9                	mov    %ebx,%ecx
8010103b:	83 e1 07             	and    $0x7,%ecx
8010103e:	b8 01 00 00 00       	mov    $0x1,%eax
80101043:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
80101045:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
8010104b:	83 c4 10             	add    $0x10,%esp
8010104e:	c1 fb 03             	sar    $0x3,%ebx
80101051:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
80101056:	0f b6 ca             	movzbl %dl,%ecx
80101059:	85 c1                	test   %eax,%ecx
8010105b:	74 23                	je     80101080 <bfree+0x67>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010105d:	f7 d0                	not    %eax
8010105f:	21 d0                	and    %edx,%eax
80101061:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	56                   	push   %esi
80101069:	e8 d7 19 00 00       	call   80102a45 <log_write>
  brelse(bp);
8010106e:	89 34 24             	mov    %esi,(%esp)
80101071:	e8 57 f1 ff ff       	call   801001cd <brelse>
}
80101076:	83 c4 10             	add    $0x10,%esp
80101079:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010107c:	5b                   	pop    %ebx
8010107d:	5e                   	pop    %esi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    panic("freeing free block");
80101080:	83 ec 0c             	sub    $0xc,%esp
80101083:	68 3b 79 10 80       	push   $0x8010793b
80101088:	e8 cb f2 ff ff       	call   80100358 <panic>

8010108d <balloc>:
{
8010108d:	55                   	push   %ebp
8010108e:	89 e5                	mov    %esp,%ebp
80101090:	57                   	push   %edi
80101091:	56                   	push   %esi
80101092:	53                   	push   %ebx
80101093:	83 ec 1c             	sub    $0x1c,%esp
80101096:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101099:	83 3d e0 35 11 80 00 	cmpl   $0x0,0x801135e0
801010a0:	0f 84 ab 00 00 00    	je     80101151 <balloc+0xc4>
801010a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801010ad:	eb 22                	jmp    801010d1 <balloc+0x44>
    brelse(bp);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	56                   	push   %esi
801010b3:	e8 15 f1 ff ff       	call   801001cd <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010b8:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801010bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c2:	83 c4 10             	add    $0x10,%esp
801010c5:	39 05 e0 35 11 80    	cmp    %eax,0x801135e0
801010cb:	0f 86 80 00 00 00    	jbe    80101151 <balloc+0xc4>
    bp = bread(dev, BBLOCK(b, sb));
801010d1:	83 ec 08             	sub    $0x8,%esp
801010d4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801010d7:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
801010dd:	85 db                	test   %ebx,%ebx
801010df:	0f 49 c3             	cmovns %ebx,%eax
801010e2:	c1 f8 0c             	sar    $0xc,%eax
801010e5:	03 05 f8 35 11 80    	add    0x801135f8,%eax
801010eb:	50                   	push   %eax
801010ec:	ff 75 d8             	pushl  -0x28(%ebp)
801010ef:	e8 ba ef ff ff       	call   801000ae <bread>
801010f4:	89 c6                	mov    %eax,%esi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010f6:	a1 e0 35 11 80       	mov    0x801135e0,%eax
801010fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010fe:	83 c4 10             	add    $0x10,%esp
80101101:	bf 00 00 00 00       	mov    $0x0,%edi
80101106:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80101109:	76 a4                	jbe    801010af <balloc+0x22>
      m = 1 << (bi % 8);
8010110b:	89 f8                	mov    %edi,%eax
8010110d:	c1 f8 1f             	sar    $0x1f,%eax
80101110:	c1 e8 1d             	shr    $0x1d,%eax
80101113:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
80101116:	83 e1 07             	and    $0x7,%ecx
80101119:	29 c1                	sub    %eax,%ecx
8010111b:	b8 01 00 00 00       	mov    $0x1,%eax
80101120:	d3 e0                	shl    %cl,%eax
80101122:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101124:	8d 47 07             	lea    0x7(%edi),%eax
80101127:	85 ff                	test   %edi,%edi
80101129:	0f 49 c7             	cmovns %edi,%eax
8010112c:	c1 f8 03             	sar    $0x3,%eax
8010112f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101132:	0f b6 54 06 5c       	movzbl 0x5c(%esi,%eax,1),%edx
80101137:	0f b6 c2             	movzbl %dl,%eax
8010113a:	85 c8                	test   %ecx,%eax
8010113c:	74 20                	je     8010115e <balloc+0xd1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010113e:	83 c7 01             	add    $0x1,%edi
80101141:	83 c3 01             	add    $0x1,%ebx
80101144:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
8010114a:	75 ba                	jne    80101106 <balloc+0x79>
8010114c:	e9 5e ff ff ff       	jmp    801010af <balloc+0x22>
  panic("balloc: out of blocks");
80101151:	83 ec 0c             	sub    $0xc,%esp
80101154:	68 4e 79 10 80       	push   $0x8010794e
80101159:	e8 fa f1 ff ff       	call   80100358 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
8010115e:	09 ca                	or     %ecx,%edx
80101160:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101163:	88 54 06 5c          	mov    %dl,0x5c(%esi,%eax,1)
        log_write(bp);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	56                   	push   %esi
8010116b:	e8 d5 18 00 00       	call   80102a45 <log_write>
        brelse(bp);
80101170:	89 34 24             	mov    %esi,(%esp)
80101173:	e8 55 f0 ff ff       	call   801001cd <brelse>
  bp = bread(dev, bno);
80101178:	83 c4 08             	add    $0x8,%esp
8010117b:	53                   	push   %ebx
8010117c:	ff 75 d8             	pushl  -0x28(%ebp)
8010117f:	e8 2a ef ff ff       	call   801000ae <bread>
80101184:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80101186:	83 c4 0c             	add    $0xc,%esp
80101189:	68 00 02 00 00       	push   $0x200
8010118e:	6a 00                	push   $0x0
80101190:	8d 40 5c             	lea    0x5c(%eax),%eax
80101193:	50                   	push   %eax
80101194:	e8 b6 2d 00 00       	call   80103f4f <memset>
  log_write(bp);
80101199:	89 34 24             	mov    %esi,(%esp)
8010119c:	e8 a4 18 00 00       	call   80102a45 <log_write>
  brelse(bp);
801011a1:	89 34 24             	mov    %esi,(%esp)
801011a4:	e8 24 f0 ff ff       	call   801001cd <brelse>
}
801011a9:	89 d8                	mov    %ebx,%eax
801011ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ae:	5b                   	pop    %ebx
801011af:	5e                   	pop    %esi
801011b0:	5f                   	pop    %edi
801011b1:	5d                   	pop    %ebp
801011b2:	c3                   	ret    

801011b3 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801011b3:	55                   	push   %ebp
801011b4:	89 e5                	mov    %esp,%ebp
801011b6:	57                   	push   %edi
801011b7:	56                   	push   %esi
801011b8:	53                   	push   %ebx
801011b9:	83 ec 1c             	sub    $0x1c,%esp
801011bc:	89 c3                	mov    %eax,%ebx
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801011be:	83 fa 0b             	cmp    $0xb,%edx
801011c1:	76 49                	jbe    8010120c <bmap+0x59>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801011c3:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801011c6:	83 fe 7f             	cmp    $0x7f,%esi
801011c9:	0f 87 80 00 00 00    	ja     8010124f <bmap+0x9c>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801011cf:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011d5:	85 c0                	test   %eax,%eax
801011d7:	74 4b                	je     80101224 <bmap+0x71>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801011d9:	83 ec 08             	sub    $0x8,%esp
801011dc:	50                   	push   %eax
801011dd:	ff 33                	pushl  (%ebx)
801011df:	e8 ca ee ff ff       	call   801000ae <bread>
801011e4:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801011e6:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801011ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ed:	8b 30                	mov    (%eax),%esi
801011ef:	83 c4 10             	add    $0x10,%esp
801011f2:	85 f6                	test   %esi,%esi
801011f4:	74 3d                	je     80101233 <bmap+0x80>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801011f6:	83 ec 0c             	sub    $0xc,%esp
801011f9:	57                   	push   %edi
801011fa:	e8 ce ef ff ff       	call   801001cd <brelse>
    return addr;
801011ff:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101202:	89 f0                	mov    %esi,%eax
80101204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101207:	5b                   	pop    %ebx
80101208:	5e                   	pop    %esi
80101209:	5f                   	pop    %edi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
8010120c:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010120f:	8b 77 5c             	mov    0x5c(%edi),%esi
80101212:	85 f6                	test   %esi,%esi
80101214:	75 ec                	jne    80101202 <bmap+0x4f>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101216:	8b 00                	mov    (%eax),%eax
80101218:	e8 70 fe ff ff       	call   8010108d <balloc>
8010121d:	89 c6                	mov    %eax,%esi
8010121f:	89 47 5c             	mov    %eax,0x5c(%edi)
80101222:	eb de                	jmp    80101202 <bmap+0x4f>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101224:	8b 03                	mov    (%ebx),%eax
80101226:	e8 62 fe ff ff       	call   8010108d <balloc>
8010122b:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101231:	eb a6                	jmp    801011d9 <bmap+0x26>
      a[bn] = addr = balloc(ip->dev);
80101233:	8b 03                	mov    (%ebx),%eax
80101235:	e8 53 fe ff ff       	call   8010108d <balloc>
8010123a:	89 c6                	mov    %eax,%esi
8010123c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010123f:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	57                   	push   %edi
80101245:	e8 fb 17 00 00       	call   80102a45 <log_write>
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	eb a7                	jmp    801011f6 <bmap+0x43>
  panic("bmap: out of range");
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	68 64 79 10 80       	push   $0x80107964
80101257:	e8 fc f0 ff ff       	call   80100358 <panic>

8010125c <iget>:
{
8010125c:	55                   	push   %ebp
8010125d:	89 e5                	mov    %esp,%ebp
8010125f:	57                   	push   %edi
80101260:	56                   	push   %esi
80101261:	53                   	push   %ebx
80101262:	83 ec 28             	sub    $0x28,%esp
80101265:	89 c7                	mov    %eax,%edi
80101267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010126a:	68 00 36 11 80       	push   $0x80113600
8010126f:	e8 25 2c 00 00       	call   80103e99 <acquire>
80101274:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101277:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127c:	bb 34 36 11 80       	mov    $0x80113634,%ebx
80101281:	eb 13                	jmp    80101296 <iget+0x3a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101283:	09 f0                	or     %esi,%eax
80101285:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101288:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010128e:	81 fb 54 52 11 80    	cmp    $0x80115254,%ebx
80101294:	74 2d                	je     801012c3 <iget+0x67>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101296:	8b 43 08             	mov    0x8(%ebx),%eax
80101299:	85 c0                	test   %eax,%eax
8010129b:	7e e6                	jle    80101283 <iget+0x27>
8010129d:	39 3b                	cmp    %edi,(%ebx)
8010129f:	75 e7                	jne    80101288 <iget+0x2c>
801012a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801012a4:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801012a7:	75 df                	jne    80101288 <iget+0x2c>
      ip->ref++;
801012a9:	83 c0 01             	add    $0x1,%eax
801012ac:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 00 36 11 80       	push   $0x80113600
801012b7:	e8 48 2c 00 00       	call   80103f04 <release>
      return ip;
801012bc:	83 c4 10             	add    $0x10,%esp
801012bf:	89 de                	mov    %ebx,%esi
801012c1:	eb 2a                	jmp    801012ed <iget+0x91>
  if(empty == 0)
801012c3:	85 f6                	test   %esi,%esi
801012c5:	74 30                	je     801012f7 <iget+0x9b>
  ip->dev = dev;
801012c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012cc:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012cf:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d6:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012dd:	83 ec 0c             	sub    $0xc,%esp
801012e0:	68 00 36 11 80       	push   $0x80113600
801012e5:	e8 1a 2c 00 00       	call   80103f04 <release>
  return ip;
801012ea:	83 c4 10             	add    $0x10,%esp
}
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f2:	5b                   	pop    %ebx
801012f3:	5e                   	pop    %esi
801012f4:	5f                   	pop    %edi
801012f5:	5d                   	pop    %ebp
801012f6:	c3                   	ret    
    panic("iget: no inodes");
801012f7:	83 ec 0c             	sub    $0xc,%esp
801012fa:	68 77 79 10 80       	push   $0x80107977
801012ff:	e8 54 f0 ff ff       	call   80100358 <panic>

80101304 <readsb>:
{
80101304:	f3 0f 1e fb          	endbr32 
80101308:	55                   	push   %ebp
80101309:	89 e5                	mov    %esp,%ebp
8010130b:	53                   	push   %ebx
8010130c:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010130f:	6a 01                	push   $0x1
80101311:	ff 75 08             	pushl  0x8(%ebp)
80101314:	e8 95 ed ff ff       	call   801000ae <bread>
80101319:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010131b:	83 c4 0c             	add    $0xc,%esp
8010131e:	6a 1c                	push   $0x1c
80101320:	8d 40 5c             	lea    0x5c(%eax),%eax
80101323:	50                   	push   %eax
80101324:	ff 75 0c             	pushl  0xc(%ebp)
80101327:	e8 b0 2c 00 00       	call   80103fdc <memmove>
  brelse(bp);
8010132c:	89 1c 24             	mov    %ebx,(%esp)
8010132f:	e8 99 ee ff ff       	call   801001cd <brelse>
}
80101334:	83 c4 10             	add    $0x10,%esp
80101337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133a:	c9                   	leave  
8010133b:	c3                   	ret    

8010133c <iinit>:
{
8010133c:	f3 0f 1e fb          	endbr32 
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	56                   	push   %esi
80101344:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
80101345:	83 ec 08             	sub    $0x8,%esp
80101348:	68 87 79 10 80       	push   $0x80107987
8010134d:	68 00 36 11 80       	push   $0x80113600
80101352:	e8 e6 29 00 00       	call   80103d3d <initlock>
  for(i = 0; i < NINODE; i++) {
80101357:	bb 40 36 11 80       	mov    $0x80113640,%ebx
8010135c:	be 60 52 11 80       	mov    $0x80115260,%esi
80101361:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
80101364:	83 ec 08             	sub    $0x8,%esp
80101367:	68 8e 79 10 80       	push   $0x8010798e
8010136c:	53                   	push   %ebx
8010136d:	e8 b1 28 00 00       	call   80103c23 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101372:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101378:	83 c4 10             	add    $0x10,%esp
8010137b:	39 f3                	cmp    %esi,%ebx
8010137d:	75 e5                	jne    80101364 <iinit+0x28>
  readsb(dev, &sb);
8010137f:	83 ec 08             	sub    $0x8,%esp
80101382:	68 e0 35 11 80       	push   $0x801135e0
80101387:	ff 75 08             	pushl  0x8(%ebp)
8010138a:	e8 75 ff ff ff       	call   80101304 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010138f:	ff 35 f8 35 11 80    	pushl  0x801135f8
80101395:	ff 35 f4 35 11 80    	pushl  0x801135f4
8010139b:	ff 35 f0 35 11 80    	pushl  0x801135f0
801013a1:	ff 35 ec 35 11 80    	pushl  0x801135ec
801013a7:	ff 35 e8 35 11 80    	pushl  0x801135e8
801013ad:	ff 35 e4 35 11 80    	pushl  0x801135e4
801013b3:	ff 35 e0 35 11 80    	pushl  0x801135e0
801013b9:	68 f4 79 10 80       	push   $0x801079f4
801013be:	e8 69 f2 ff ff       	call   8010062c <cprintf>
}
801013c3:	83 c4 30             	add    $0x30,%esp
801013c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013c9:	5b                   	pop    %ebx
801013ca:	5e                   	pop    %esi
801013cb:	5d                   	pop    %ebp
801013cc:	c3                   	ret    

801013cd <ialloc>:
{
801013cd:	f3 0f 1e fb          	endbr32 
801013d1:	55                   	push   %ebp
801013d2:	89 e5                	mov    %esp,%ebp
801013d4:	57                   	push   %edi
801013d5:	56                   	push   %esi
801013d6:	53                   	push   %ebx
801013d7:	83 ec 1c             	sub    $0x1c,%esp
801013da:	8b 45 0c             	mov    0xc(%ebp),%eax
801013dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013e0:	83 3d e8 35 11 80 01 	cmpl   $0x1,0x801135e8
801013e7:	76 4d                	jbe    80101436 <ialloc+0x69>
801013e9:	bb 01 00 00 00       	mov    $0x1,%ebx
801013ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
801013f1:	83 ec 08             	sub    $0x8,%esp
801013f4:	89 d8                	mov    %ebx,%eax
801013f6:	c1 e8 03             	shr    $0x3,%eax
801013f9:	03 05 f4 35 11 80    	add    0x801135f4,%eax
801013ff:	50                   	push   %eax
80101400:	ff 75 08             	pushl  0x8(%ebp)
80101403:	e8 a6 ec ff ff       	call   801000ae <bread>
80101408:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
8010140a:	89 d8                	mov    %ebx,%eax
8010140c:	83 e0 07             	and    $0x7,%eax
8010140f:	c1 e0 06             	shl    $0x6,%eax
80101412:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101416:	83 c4 10             	add    $0x10,%esp
80101419:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010141d:	74 24                	je     80101443 <ialloc+0x76>
    brelse(bp);
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	56                   	push   %esi
80101423:	e8 a5 ed ff ff       	call   801001cd <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101428:	83 c3 01             	add    $0x1,%ebx
8010142b:	83 c4 10             	add    $0x10,%esp
8010142e:	39 1d e8 35 11 80    	cmp    %ebx,0x801135e8
80101434:	77 b8                	ja     801013ee <ialloc+0x21>
  panic("ialloc: no inodes");
80101436:	83 ec 0c             	sub    $0xc,%esp
80101439:	68 94 79 10 80       	push   $0x80107994
8010143e:	e8 15 ef ff ff       	call   80100358 <panic>
      memset(dip, 0, sizeof(*dip));
80101443:	83 ec 04             	sub    $0x4,%esp
80101446:	6a 40                	push   $0x40
80101448:	6a 00                	push   $0x0
8010144a:	57                   	push   %edi
8010144b:	e8 ff 2a 00 00       	call   80103f4f <memset>
      dip->type = type;
80101450:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80101454:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101457:	89 34 24             	mov    %esi,(%esp)
8010145a:	e8 e6 15 00 00       	call   80102a45 <log_write>
      brelse(bp);
8010145f:	89 34 24             	mov    %esi,(%esp)
80101462:	e8 66 ed ff ff       	call   801001cd <brelse>
      return iget(dev, inum);
80101467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010146a:	8b 45 08             	mov    0x8(%ebp),%eax
8010146d:	e8 ea fd ff ff       	call   8010125c <iget>
}
80101472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret    

8010147a <iupdate>:
{
8010147a:	f3 0f 1e fb          	endbr32 
8010147e:	55                   	push   %ebp
8010147f:	89 e5                	mov    %esp,%ebp
80101481:	56                   	push   %esi
80101482:	53                   	push   %ebx
80101483:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101486:	83 ec 08             	sub    $0x8,%esp
80101489:	8b 43 04             	mov    0x4(%ebx),%eax
8010148c:	c1 e8 03             	shr    $0x3,%eax
8010148f:	03 05 f4 35 11 80    	add    0x801135f4,%eax
80101495:	50                   	push   %eax
80101496:	ff 33                	pushl  (%ebx)
80101498:	e8 11 ec ff ff       	call   801000ae <bread>
8010149d:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010149f:	8b 43 04             	mov    0x4(%ebx),%eax
801014a2:	83 e0 07             	and    $0x7,%eax
801014a5:	c1 e0 06             	shl    $0x6,%eax
801014a8:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014ac:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
801014b0:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014b3:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801014b7:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014bb:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014bf:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014c3:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014c7:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014cb:	8b 53 58             	mov    0x58(%ebx),%edx
801014ce:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014d1:	83 c4 0c             	add    $0xc,%esp
801014d4:	6a 34                	push   $0x34
801014d6:	83 c3 5c             	add    $0x5c,%ebx
801014d9:	53                   	push   %ebx
801014da:	83 c0 0c             	add    $0xc,%eax
801014dd:	50                   	push   %eax
801014de:	e8 f9 2a 00 00       	call   80103fdc <memmove>
  log_write(bp);
801014e3:	89 34 24             	mov    %esi,(%esp)
801014e6:	e8 5a 15 00 00       	call   80102a45 <log_write>
  brelse(bp);
801014eb:	89 34 24             	mov    %esi,(%esp)
801014ee:	e8 da ec ff ff       	call   801001cd <brelse>
}
801014f3:	83 c4 10             	add    $0x10,%esp
801014f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014f9:	5b                   	pop    %ebx
801014fa:	5e                   	pop    %esi
801014fb:	5d                   	pop    %ebp
801014fc:	c3                   	ret    

801014fd <idup>:
{
801014fd:	f3 0f 1e fb          	endbr32 
80101501:	55                   	push   %ebp
80101502:	89 e5                	mov    %esp,%ebp
80101504:	53                   	push   %ebx
80101505:	83 ec 10             	sub    $0x10,%esp
80101508:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010150b:	68 00 36 11 80       	push   $0x80113600
80101510:	e8 84 29 00 00       	call   80103e99 <acquire>
  ip->ref++;
80101515:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101519:	c7 04 24 00 36 11 80 	movl   $0x80113600,(%esp)
80101520:	e8 df 29 00 00       	call   80103f04 <release>
}
80101525:	89 d8                	mov    %ebx,%eax
80101527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010152a:	c9                   	leave  
8010152b:	c3                   	ret    

8010152c <ilock>:
{
8010152c:	f3 0f 1e fb          	endbr32 
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101538:	85 db                	test   %ebx,%ebx
8010153a:	74 22                	je     8010155e <ilock+0x32>
8010153c:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101540:	7e 1c                	jle    8010155e <ilock+0x32>
  acquiresleep(&ip->lock);
80101542:	83 ec 0c             	sub    $0xc,%esp
80101545:	8d 43 0c             	lea    0xc(%ebx),%eax
80101548:	50                   	push   %eax
80101549:	e8 0c 27 00 00       	call   80103c5a <acquiresleep>
  if(ip->valid == 0){
8010154e:	83 c4 10             	add    $0x10,%esp
80101551:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101555:	74 14                	je     8010156b <ilock+0x3f>
}
80101557:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155a:	5b                   	pop    %ebx
8010155b:	5e                   	pop    %esi
8010155c:	5d                   	pop    %ebp
8010155d:	c3                   	ret    
    panic("ilock");
8010155e:	83 ec 0c             	sub    $0xc,%esp
80101561:	68 a6 79 10 80       	push   $0x801079a6
80101566:	e8 ed ed ff ff       	call   80100358 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010156b:	83 ec 08             	sub    $0x8,%esp
8010156e:	8b 43 04             	mov    0x4(%ebx),%eax
80101571:	c1 e8 03             	shr    $0x3,%eax
80101574:	03 05 f4 35 11 80    	add    0x801135f4,%eax
8010157a:	50                   	push   %eax
8010157b:	ff 33                	pushl  (%ebx)
8010157d:	e8 2c eb ff ff       	call   801000ae <bread>
80101582:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101584:	8b 43 04             	mov    0x4(%ebx),%eax
80101587:	83 e0 07             	and    $0x7,%eax
8010158a:	c1 e0 06             	shl    $0x6,%eax
8010158d:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101591:	0f b7 10             	movzwl (%eax),%edx
80101594:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101598:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010159c:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015a0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801015a4:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015a8:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801015ac:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015b0:	8b 50 08             	mov    0x8(%eax),%edx
801015b3:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015b6:	83 c4 0c             	add    $0xc,%esp
801015b9:	6a 34                	push   $0x34
801015bb:	83 c0 0c             	add    $0xc,%eax
801015be:	50                   	push   %eax
801015bf:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015c2:	50                   	push   %eax
801015c3:	e8 14 2a 00 00       	call   80103fdc <memmove>
    brelse(bp);
801015c8:	89 34 24             	mov    %esi,(%esp)
801015cb:	e8 fd eb ff ff       	call   801001cd <brelse>
    ip->valid = 1;
801015d0:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015d7:	83 c4 10             	add    $0x10,%esp
801015da:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015df:	0f 85 72 ff ff ff    	jne    80101557 <ilock+0x2b>
      panic("ilock: no type");
801015e5:	83 ec 0c             	sub    $0xc,%esp
801015e8:	68 ac 79 10 80       	push   $0x801079ac
801015ed:	e8 66 ed ff ff       	call   80100358 <panic>

801015f2 <iunlock>:
{
801015f2:	f3 0f 1e fb          	endbr32 
801015f6:	55                   	push   %ebp
801015f7:	89 e5                	mov    %esp,%ebp
801015f9:	56                   	push   %esi
801015fa:	53                   	push   %ebx
801015fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015fe:	85 db                	test   %ebx,%ebx
80101600:	74 2c                	je     8010162e <iunlock+0x3c>
80101602:	8d 73 0c             	lea    0xc(%ebx),%esi
80101605:	83 ec 0c             	sub    $0xc,%esp
80101608:	56                   	push   %esi
80101609:	e8 e1 26 00 00       	call   80103cef <holdingsleep>
8010160e:	83 c4 10             	add    $0x10,%esp
80101611:	85 c0                	test   %eax,%eax
80101613:	74 19                	je     8010162e <iunlock+0x3c>
80101615:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101619:	7e 13                	jle    8010162e <iunlock+0x3c>
  releasesleep(&ip->lock);
8010161b:	83 ec 0c             	sub    $0xc,%esp
8010161e:	56                   	push   %esi
8010161f:	e8 8c 26 00 00       	call   80103cb0 <releasesleep>
}
80101624:	83 c4 10             	add    $0x10,%esp
80101627:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010162a:	5b                   	pop    %ebx
8010162b:	5e                   	pop    %esi
8010162c:	5d                   	pop    %ebp
8010162d:	c3                   	ret    
    panic("iunlock");
8010162e:	83 ec 0c             	sub    $0xc,%esp
80101631:	68 bb 79 10 80       	push   $0x801079bb
80101636:	e8 1d ed ff ff       	call   80100358 <panic>

8010163b <iput>:
{
8010163b:	f3 0f 1e fb          	endbr32 
8010163f:	55                   	push   %ebp
80101640:	89 e5                	mov    %esp,%ebp
80101642:	57                   	push   %edi
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	83 ec 28             	sub    $0x28,%esp
80101648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010164b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010164e:	56                   	push   %esi
8010164f:	e8 06 26 00 00       	call   80103c5a <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101654:	83 c4 10             	add    $0x10,%esp
80101657:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010165b:	74 07                	je     80101664 <iput+0x29>
8010165d:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101662:	74 30                	je     80101694 <iput+0x59>
  releasesleep(&ip->lock);
80101664:	83 ec 0c             	sub    $0xc,%esp
80101667:	56                   	push   %esi
80101668:	e8 43 26 00 00       	call   80103cb0 <releasesleep>
  acquire(&icache.lock);
8010166d:	c7 04 24 00 36 11 80 	movl   $0x80113600,(%esp)
80101674:	e8 20 28 00 00       	call   80103e99 <acquire>
  ip->ref--;
80101679:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010167d:	c7 04 24 00 36 11 80 	movl   $0x80113600,(%esp)
80101684:	e8 7b 28 00 00       	call   80103f04 <release>
}
80101689:	83 c4 10             	add    $0x10,%esp
8010168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010168f:	5b                   	pop    %ebx
80101690:	5e                   	pop    %esi
80101691:	5f                   	pop    %edi
80101692:	5d                   	pop    %ebp
80101693:	c3                   	ret    
    acquire(&icache.lock);
80101694:	83 ec 0c             	sub    $0xc,%esp
80101697:	68 00 36 11 80       	push   $0x80113600
8010169c:	e8 f8 27 00 00       	call   80103e99 <acquire>
    int r = ip->ref;
801016a1:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016a4:	c7 04 24 00 36 11 80 	movl   $0x80113600,(%esp)
801016ab:	e8 54 28 00 00       	call   80103f04 <release>
    if(r == 1){
801016b0:	83 c4 10             	add    $0x10,%esp
801016b3:	83 ff 01             	cmp    $0x1,%edi
801016b6:	75 ac                	jne    80101664 <iput+0x29>
801016b8:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801016bb:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801016c1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801016c4:	89 c6                	mov    %eax,%esi
801016c6:	eb 07                	jmp    801016cf <iput+0x94>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801016c8:	83 c7 04             	add    $0x4,%edi
801016cb:	39 f7                	cmp    %esi,%edi
801016cd:	74 15                	je     801016e4 <iput+0xa9>
    if(ip->addrs[i]){
801016cf:	8b 17                	mov    (%edi),%edx
801016d1:	85 d2                	test   %edx,%edx
801016d3:	74 f3                	je     801016c8 <iput+0x8d>
      bfree(ip->dev, ip->addrs[i]);
801016d5:	8b 03                	mov    (%ebx),%eax
801016d7:	e8 3d f9 ff ff       	call   80101019 <bfree>
      ip->addrs[i] = 0;
801016dc:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801016e2:	eb e4                	jmp    801016c8 <iput+0x8d>
801016e4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801016e7:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801016ed:	85 c0                	test   %eax,%eax
801016ef:	75 2d                	jne    8010171e <iput+0xe3>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801016f1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	53                   	push   %ebx
801016fc:	e8 79 fd ff ff       	call   8010147a <iupdate>
      ip->type = 0;
80101701:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101707:	89 1c 24             	mov    %ebx,(%esp)
8010170a:	e8 6b fd ff ff       	call   8010147a <iupdate>
      ip->valid = 0;
8010170f:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101716:	83 c4 10             	add    $0x10,%esp
80101719:	e9 46 ff ff ff       	jmp    80101664 <iput+0x29>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010171e:	83 ec 08             	sub    $0x8,%esp
80101721:	50                   	push   %eax
80101722:	ff 33                	pushl  (%ebx)
80101724:	e8 85 e9 ff ff       	call   801000ae <bread>
80101729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010172c:	8d 78 5c             	lea    0x5c(%eax),%edi
8010172f:	05 5c 02 00 00       	add    $0x25c,%eax
80101734:	83 c4 10             	add    $0x10,%esp
80101737:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010173a:	89 c6                	mov    %eax,%esi
8010173c:	eb 0e                	jmp    8010174c <iput+0x111>
        bfree(ip->dev, a[j]);
8010173e:	8b 03                	mov    (%ebx),%eax
80101740:	e8 d4 f8 ff ff       	call   80101019 <bfree>
    for(j = 0; j < NINDIRECT; j++){
80101745:	83 c7 04             	add    $0x4,%edi
80101748:	39 f7                	cmp    %esi,%edi
8010174a:	74 08                	je     80101754 <iput+0x119>
      if(a[j])
8010174c:	8b 17                	mov    (%edi),%edx
8010174e:	85 d2                	test   %edx,%edx
80101750:	74 f3                	je     80101745 <iput+0x10a>
80101752:	eb ea                	jmp    8010173e <iput+0x103>
80101754:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010175d:	e8 6b ea ff ff       	call   801001cd <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101762:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101768:	8b 03                	mov    (%ebx),%eax
8010176a:	e8 aa f8 ff ff       	call   80101019 <bfree>
    ip->addrs[NDIRECT] = 0;
8010176f:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101776:	00 00 00 
80101779:	83 c4 10             	add    $0x10,%esp
8010177c:	e9 70 ff ff ff       	jmp    801016f1 <iput+0xb6>

80101781 <iunlockput>:
{
80101781:	f3 0f 1e fb          	endbr32 
80101785:	55                   	push   %ebp
80101786:	89 e5                	mov    %esp,%ebp
80101788:	53                   	push   %ebx
80101789:	83 ec 10             	sub    $0x10,%esp
8010178c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010178f:	53                   	push   %ebx
80101790:	e8 5d fe ff ff       	call   801015f2 <iunlock>
  iput(ip);
80101795:	89 1c 24             	mov    %ebx,(%esp)
80101798:	e8 9e fe ff ff       	call   8010163b <iput>
}
8010179d:	83 c4 10             	add    $0x10,%esp
801017a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a3:	c9                   	leave  
801017a4:	c3                   	ret    

801017a5 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801017a5:	f3 0f 1e fb          	endbr32 
801017a9:	55                   	push   %ebp
801017aa:	89 e5                	mov    %esp,%ebp
801017ac:	8b 55 08             	mov    0x8(%ebp),%edx
801017af:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017b2:	8b 0a                	mov    (%edx),%ecx
801017b4:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017b7:	8b 4a 04             	mov    0x4(%edx),%ecx
801017ba:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017bd:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017c1:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017c4:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017c8:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017cc:	8b 52 58             	mov    0x58(%edx),%edx
801017cf:	89 50 10             	mov    %edx,0x10(%eax)
}
801017d2:	5d                   	pop    %ebp
801017d3:	c3                   	ret    

801017d4 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801017d4:	f3 0f 1e fb          	endbr32 
801017d8:	55                   	push   %ebp
801017d9:	89 e5                	mov    %esp,%ebp
801017db:	57                   	push   %edi
801017dc:	56                   	push   %esi
801017dd:	53                   	push   %ebx
801017de:	83 ec 1c             	sub    $0x1c,%esp
801017e1:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801017e4:	8b 45 08             	mov    0x8(%ebp),%eax
801017e7:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017ec:	0f 84 9d 00 00 00    	je     8010188f <readi+0xbb>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801017f2:	8b 45 08             	mov    0x8(%ebp),%eax
801017f5:	8b 40 58             	mov    0x58(%eax),%eax
801017f8:	39 f0                	cmp    %esi,%eax
801017fa:	0f 82 c6 00 00 00    	jb     801018c6 <readi+0xf2>
80101800:	89 f2                	mov    %esi,%edx
80101802:	03 55 14             	add    0x14(%ebp),%edx
80101805:	0f 82 c2 00 00 00    	jb     801018cd <readi+0xf9>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010180b:	89 c1                	mov    %eax,%ecx
8010180d:	29 f1                	sub    %esi,%ecx
8010180f:	39 d0                	cmp    %edx,%eax
80101811:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
80101815:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101818:	85 c9                	test   %ecx,%ecx
8010181a:	74 68                	je     80101884 <readi+0xb0>
8010181c:	bf 00 00 00 00       	mov    $0x0,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101821:	89 f2                	mov    %esi,%edx
80101823:	c1 ea 09             	shr    $0x9,%edx
80101826:	8b 45 08             	mov    0x8(%ebp),%eax
80101829:	e8 85 f9 ff ff       	call   801011b3 <bmap>
8010182e:	83 ec 08             	sub    $0x8,%esp
80101831:	50                   	push   %eax
80101832:	8b 45 08             	mov    0x8(%ebp),%eax
80101835:	ff 30                	pushl  (%eax)
80101837:	e8 72 e8 ff ff       	call   801000ae <bread>
8010183c:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010183e:	89 f0                	mov    %esi,%eax
80101840:	25 ff 01 00 00       	and    $0x1ff,%eax
80101845:	bb 00 02 00 00       	mov    $0x200,%ebx
8010184a:	29 c3                	sub    %eax,%ebx
8010184c:	8b 55 14             	mov    0x14(%ebp),%edx
8010184f:	29 fa                	sub    %edi,%edx
80101851:	83 c4 0c             	add    $0xc,%esp
80101854:	39 d3                	cmp    %edx,%ebx
80101856:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101859:	53                   	push   %ebx
8010185a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010185d:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101861:	50                   	push   %eax
80101862:	ff 75 0c             	pushl  0xc(%ebp)
80101865:	e8 72 27 00 00       	call   80103fdc <memmove>
    brelse(bp);
8010186a:	83 c4 04             	add    $0x4,%esp
8010186d:	ff 75 e4             	pushl  -0x1c(%ebp)
80101870:	e8 58 e9 ff ff       	call   801001cd <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101875:	01 df                	add    %ebx,%edi
80101877:	01 de                	add    %ebx,%esi
80101879:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010187c:	83 c4 10             	add    $0x10,%esp
8010187f:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101882:	77 9d                	ja     80101821 <readi+0x4d>
  }
  return n;
80101884:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101887:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188a:	5b                   	pop    %ebx
8010188b:	5e                   	pop    %esi
8010188c:	5f                   	pop    %edi
8010188d:	5d                   	pop    %ebp
8010188e:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010188f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101893:	66 83 f8 09          	cmp    $0x9,%ax
80101897:	77 1f                	ja     801018b8 <readi+0xe4>
80101899:	98                   	cwtl   
8010189a:	8b 04 c5 80 35 11 80 	mov    -0x7feeca80(,%eax,8),%eax
801018a1:	85 c0                	test   %eax,%eax
801018a3:	74 1a                	je     801018bf <readi+0xeb>
    return devsw[ip->major].read(ip, dst, n);
801018a5:	83 ec 04             	sub    $0x4,%esp
801018a8:	ff 75 14             	pushl  0x14(%ebp)
801018ab:	ff 75 0c             	pushl  0xc(%ebp)
801018ae:	ff 75 08             	pushl  0x8(%ebp)
801018b1:	ff d0                	call   *%eax
801018b3:	83 c4 10             	add    $0x10,%esp
801018b6:	eb cf                	jmp    80101887 <readi+0xb3>
      return -1;
801018b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018bd:	eb c8                	jmp    80101887 <readi+0xb3>
801018bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c4:	eb c1                	jmp    80101887 <readi+0xb3>
    return -1;
801018c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018cb:	eb ba                	jmp    80101887 <readi+0xb3>
801018cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018d2:	eb b3                	jmp    80101887 <readi+0xb3>

801018d4 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801018d4:	f3 0f 1e fb          	endbr32 
801018d8:	55                   	push   %ebp
801018d9:	89 e5                	mov    %esp,%ebp
801018db:	57                   	push   %edi
801018dc:	56                   	push   %esi
801018dd:	53                   	push   %ebx
801018de:	83 ec 1c             	sub    $0x1c,%esp
801018e1:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801018e4:	8b 45 08             	mov    0x8(%ebp),%eax
801018e7:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018ec:	0f 84 b0 00 00 00    	je     801019a2 <writei+0xce>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801018f2:	8b 45 08             	mov    0x8(%ebp),%eax
801018f5:	39 78 58             	cmp    %edi,0x58(%eax)
801018f8:	0f 82 ef 00 00 00    	jb     801019ed <writei+0x119>
801018fe:	89 f8                	mov    %edi,%eax
80101900:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101903:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101908:	0f 87 e6 00 00 00    	ja     801019f4 <writei+0x120>
8010190e:	39 f8                	cmp    %edi,%eax
80101910:	0f 82 de 00 00 00    	jb     801019f4 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101916:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010191a:	74 7b                	je     80101997 <writei+0xc3>
8010191c:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101921:	89 fa                	mov    %edi,%edx
80101923:	c1 ea 09             	shr    $0x9,%edx
80101926:	8b 45 08             	mov    0x8(%ebp),%eax
80101929:	e8 85 f8 ff ff       	call   801011b3 <bmap>
8010192e:	83 ec 08             	sub    $0x8,%esp
80101931:	50                   	push   %eax
80101932:	8b 45 08             	mov    0x8(%ebp),%eax
80101935:	ff 30                	pushl  (%eax)
80101937:	e8 72 e7 ff ff       	call   801000ae <bread>
8010193c:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010193e:	89 f8                	mov    %edi,%eax
80101940:	25 ff 01 00 00       	and    $0x1ff,%eax
80101945:	bb 00 02 00 00       	mov    $0x200,%ebx
8010194a:	29 c3                	sub    %eax,%ebx
8010194c:	8b 55 14             	mov    0x14(%ebp),%edx
8010194f:	29 f2                	sub    %esi,%edx
80101951:	83 c4 0c             	add    $0xc,%esp
80101954:	39 d3                	cmp    %edx,%ebx
80101956:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101959:	53                   	push   %ebx
8010195a:	ff 75 0c             	pushl  0xc(%ebp)
8010195d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101960:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101964:	50                   	push   %eax
80101965:	e8 72 26 00 00       	call   80103fdc <memmove>
    log_write(bp);
8010196a:	83 c4 04             	add    $0x4,%esp
8010196d:	ff 75 e4             	pushl  -0x1c(%ebp)
80101970:	e8 d0 10 00 00       	call   80102a45 <log_write>
    brelse(bp);
80101975:	83 c4 04             	add    $0x4,%esp
80101978:	ff 75 e4             	pushl  -0x1c(%ebp)
8010197b:	e8 4d e8 ff ff       	call   801001cd <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101980:	01 de                	add    %ebx,%esi
80101982:	01 df                	add    %ebx,%edi
80101984:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101987:	83 c4 10             	add    $0x10,%esp
8010198a:	39 75 14             	cmp    %esi,0x14(%ebp)
8010198d:	77 92                	ja     80101921 <writei+0x4d>
  }

  if(n > 0 && off > ip->size){
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	39 78 58             	cmp    %edi,0x58(%eax)
80101995:	72 34                	jb     801019cb <writei+0xf7>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101997:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010199a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199d:	5b                   	pop    %ebx
8010199e:	5e                   	pop    %esi
8010199f:	5f                   	pop    %edi
801019a0:	5d                   	pop    %ebp
801019a1:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019a2:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801019a6:	66 83 f8 09          	cmp    $0x9,%ax
801019aa:	77 33                	ja     801019df <writei+0x10b>
801019ac:	98                   	cwtl   
801019ad:	8b 04 c5 84 35 11 80 	mov    -0x7feeca7c(,%eax,8),%eax
801019b4:	85 c0                	test   %eax,%eax
801019b6:	74 2e                	je     801019e6 <writei+0x112>
    return devsw[ip->major].write(ip, src, n);
801019b8:	83 ec 04             	sub    $0x4,%esp
801019bb:	ff 75 14             	pushl  0x14(%ebp)
801019be:	ff 75 0c             	pushl  0xc(%ebp)
801019c1:	ff 75 08             	pushl  0x8(%ebp)
801019c4:	ff d0                	call   *%eax
801019c6:	83 c4 10             	add    $0x10,%esp
801019c9:	eb cf                	jmp    8010199a <writei+0xc6>
    ip->size = off;
801019cb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ce:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801019d1:	83 ec 0c             	sub    $0xc,%esp
801019d4:	50                   	push   %eax
801019d5:	e8 a0 fa ff ff       	call   8010147a <iupdate>
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	eb b8                	jmp    80101997 <writei+0xc3>
      return -1;
801019df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e4:	eb b4                	jmp    8010199a <writei+0xc6>
801019e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019eb:	eb ad                	jmp    8010199a <writei+0xc6>
    return -1;
801019ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f2:	eb a6                	jmp    8010199a <writei+0xc6>
    return -1;
801019f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f9:	eb 9f                	jmp    8010199a <writei+0xc6>

801019fb <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801019fb:	f3 0f 1e fb          	endbr32 
801019ff:	55                   	push   %ebp
80101a00:	89 e5                	mov    %esp,%ebp
80101a02:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a05:	6a 0e                	push   $0xe
80101a07:	ff 75 0c             	pushl  0xc(%ebp)
80101a0a:	ff 75 08             	pushl  0x8(%ebp)
80101a0d:	e8 39 26 00 00       	call   8010404b <strncmp>
}
80101a12:	c9                   	leave  
80101a13:	c3                   	ret    

80101a14 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101a14:	f3 0f 1e fb          	endbr32 
80101a18:	55                   	push   %ebp
80101a19:	89 e5                	mov    %esp,%ebp
80101a1b:	57                   	push   %edi
80101a1c:	56                   	push   %esi
80101a1d:	53                   	push   %ebx
80101a1e:	83 ec 1c             	sub    $0x1c,%esp
80101a21:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101a24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a29:	75 15                	jne    80101a40 <dirlookup+0x2c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a2b:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a30:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a33:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a38:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
80101a3c:	75 24                	jne    80101a62 <dirlookup+0x4e>
80101a3e:	eb 6e                	jmp    80101aae <dirlookup+0x9a>
    panic("dirlookup not DIR");
80101a40:	83 ec 0c             	sub    $0xc,%esp
80101a43:	68 c3 79 10 80       	push   $0x801079c3
80101a48:	e8 0b e9 ff ff       	call   80100358 <panic>
      panic("dirlookup read");
80101a4d:	83 ec 0c             	sub    $0xc,%esp
80101a50:	68 d5 79 10 80       	push   $0x801079d5
80101a55:	e8 fe e8 ff ff       	call   80100358 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a5a:	83 c3 10             	add    $0x10,%ebx
80101a5d:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a60:	76 47                	jbe    80101aa9 <dirlookup+0x95>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a62:	6a 10                	push   $0x10
80101a64:	53                   	push   %ebx
80101a65:	57                   	push   %edi
80101a66:	56                   	push   %esi
80101a67:	e8 68 fd ff ff       	call   801017d4 <readi>
80101a6c:	83 c4 10             	add    $0x10,%esp
80101a6f:	83 f8 10             	cmp    $0x10,%eax
80101a72:	75 d9                	jne    80101a4d <dirlookup+0x39>
    if(de.inum == 0)
80101a74:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a79:	74 df                	je     80101a5a <dirlookup+0x46>
    if(namecmp(name, de.name) == 0){
80101a7b:	83 ec 08             	sub    $0x8,%esp
80101a7e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a81:	50                   	push   %eax
80101a82:	ff 75 0c             	pushl  0xc(%ebp)
80101a85:	e8 71 ff ff ff       	call   801019fb <namecmp>
80101a8a:	83 c4 10             	add    $0x10,%esp
80101a8d:	85 c0                	test   %eax,%eax
80101a8f:	75 c9                	jne    80101a5a <dirlookup+0x46>
      if(poff)
80101a91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a95:	74 05                	je     80101a9c <dirlookup+0x88>
        *poff = off;
80101a97:	8b 45 10             	mov    0x10(%ebp),%eax
80101a9a:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101aa0:	8b 06                	mov    (%esi),%eax
80101aa2:	e8 b5 f7 ff ff       	call   8010125c <iget>
80101aa7:	eb 05                	jmp    80101aae <dirlookup+0x9a>
  return 0;
80101aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab1:	5b                   	pop    %ebx
80101ab2:	5e                   	pop    %esi
80101ab3:	5f                   	pop    %edi
80101ab4:	5d                   	pop    %ebp
80101ab5:	c3                   	ret    

80101ab6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ab6:	55                   	push   %ebp
80101ab7:	89 e5                	mov    %esp,%ebp
80101ab9:	57                   	push   %edi
80101aba:	56                   	push   %esi
80101abb:	53                   	push   %ebx
80101abc:	83 ec 1c             	sub    $0x1c,%esp
80101abf:	89 c3                	mov    %eax,%ebx
80101ac1:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ac4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ac7:	80 38 2f             	cmpb   $0x2f,(%eax)
80101aca:	74 1a                	je     80101ae6 <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101acc:	e8 19 19 00 00       	call   801033ea <myproc>
80101ad1:	83 ec 0c             	sub    $0xc,%esp
80101ad4:	ff 70 68             	pushl  0x68(%eax)
80101ad7:	e8 21 fa ff ff       	call   801014fd <idup>
80101adc:	89 c7                	mov    %eax,%edi
80101ade:	83 c4 10             	add    $0x10,%esp
80101ae1:	e9 c2 00 00 00       	jmp    80101ba8 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
80101ae6:	ba 01 00 00 00       	mov    $0x1,%edx
80101aeb:	b8 01 00 00 00       	mov    $0x1,%eax
80101af0:	e8 67 f7 ff ff       	call   8010125c <iget>
80101af5:	89 c7                	mov    %eax,%edi
80101af7:	e9 ac 00 00 00       	jmp    80101ba8 <namex+0xf2>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101afc:	83 ec 0c             	sub    $0xc,%esp
80101aff:	57                   	push   %edi
80101b00:	e8 7c fc ff ff       	call   80101781 <iunlockput>
      return 0;
80101b05:	83 c4 10             	add    $0x10,%esp
80101b08:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b0d:	89 f8                	mov    %edi,%eax
80101b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b12:	5b                   	pop    %ebx
80101b13:	5e                   	pop    %esi
80101b14:	5f                   	pop    %edi
80101b15:	5d                   	pop    %ebp
80101b16:	c3                   	ret    
      iunlock(ip);
80101b17:	83 ec 0c             	sub    $0xc,%esp
80101b1a:	57                   	push   %edi
80101b1b:	e8 d2 fa ff ff       	call   801015f2 <iunlock>
      return ip;
80101b20:	83 c4 10             	add    $0x10,%esp
80101b23:	eb e8                	jmp    80101b0d <namex+0x57>
      iunlockput(ip);
80101b25:	83 ec 0c             	sub    $0xc,%esp
80101b28:	57                   	push   %edi
80101b29:	e8 53 fc ff ff       	call   80101781 <iunlockput>
      return 0;
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	89 f7                	mov    %esi,%edi
80101b33:	eb d8                	jmp    80101b0d <namex+0x57>
  len = path - s;
80101b35:	89 f0                	mov    %esi,%eax
80101b37:	29 d8                	sub    %ebx,%eax
80101b39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101b3c:	83 f8 0d             	cmp    $0xd,%eax
80101b3f:	0f 8e a5 00 00 00    	jle    80101bea <namex+0x134>
    memmove(name, s, DIRSIZ);
80101b45:	83 ec 04             	sub    $0x4,%esp
80101b48:	6a 0e                	push   $0xe
80101b4a:	53                   	push   %ebx
80101b4b:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b4e:	e8 89 24 00 00       	call   80103fdc <memmove>
80101b53:	83 c4 10             	add    $0x10,%esp
    path++;
80101b56:	89 f3                	mov    %esi,%ebx
  while(*path == '/')
80101b58:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b5b:	75 08                	jne    80101b65 <namex+0xaf>
    path++;
80101b5d:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101b60:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b63:	74 f8                	je     80101b5d <namex+0xa7>
    ilock(ip);
80101b65:	83 ec 0c             	sub    $0xc,%esp
80101b68:	57                   	push   %edi
80101b69:	e8 be f9 ff ff       	call   8010152c <ilock>
    if(ip->type != T_DIR){
80101b6e:	83 c4 10             	add    $0x10,%esp
80101b71:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101b76:	75 84                	jne    80101afc <namex+0x46>
    if(nameiparent && *path == '\0'){
80101b78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101b7c:	74 05                	je     80101b83 <namex+0xcd>
80101b7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b81:	74 94                	je     80101b17 <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101b83:	83 ec 04             	sub    $0x4,%esp
80101b86:	6a 00                	push   $0x0
80101b88:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b8b:	57                   	push   %edi
80101b8c:	e8 83 fe ff ff       	call   80101a14 <dirlookup>
80101b91:	89 c6                	mov    %eax,%esi
80101b93:	83 c4 10             	add    $0x10,%esp
80101b96:	85 c0                	test   %eax,%eax
80101b98:	74 8b                	je     80101b25 <namex+0x6f>
    iunlockput(ip);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	57                   	push   %edi
80101b9e:	e8 de fb ff ff       	call   80101781 <iunlockput>
80101ba3:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101ba6:	89 f7                	mov    %esi,%edi
  while(*path == '/')
80101ba8:	0f b6 03             	movzbl (%ebx),%eax
80101bab:	3c 2f                	cmp    $0x2f,%al
80101bad:	75 0a                	jne    80101bb9 <namex+0x103>
    path++;
80101baf:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101bb2:	0f b6 03             	movzbl (%ebx),%eax
80101bb5:	3c 2f                	cmp    $0x2f,%al
80101bb7:	74 f6                	je     80101baf <namex+0xf9>
  if(*path == 0)
80101bb9:	84 c0                	test   %al,%al
80101bbb:	74 4e                	je     80101c0b <namex+0x155>
  while(*path != '/' && *path != 0)
80101bbd:	0f b6 03             	movzbl (%ebx),%eax
80101bc0:	3c 2f                	cmp    $0x2f,%al
80101bc2:	74 1d                	je     80101be1 <namex+0x12b>
80101bc4:	84 c0                	test   %al,%al
80101bc6:	74 19                	je     80101be1 <namex+0x12b>
80101bc8:	89 de                	mov    %ebx,%esi
    path++;
80101bca:	83 c6 01             	add    $0x1,%esi
  while(*path != '/' && *path != 0)
80101bcd:	0f b6 06             	movzbl (%esi),%eax
80101bd0:	3c 2f                	cmp    $0x2f,%al
80101bd2:	0f 84 5d ff ff ff    	je     80101b35 <namex+0x7f>
80101bd8:	84 c0                	test   %al,%al
80101bda:	75 ee                	jne    80101bca <namex+0x114>
80101bdc:	e9 54 ff ff ff       	jmp    80101b35 <namex+0x7f>
80101be1:	89 de                	mov    %ebx,%esi
  len = path - s;
80101be3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    memmove(name, s, len);
80101bea:	83 ec 04             	sub    $0x4,%esp
80101bed:	ff 75 e0             	pushl  -0x20(%ebp)
80101bf0:	53                   	push   %ebx
80101bf1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bf4:	53                   	push   %ebx
80101bf5:	e8 e2 23 00 00       	call   80103fdc <memmove>
    name[len] = 0;
80101bfa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bfd:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
80101c01:	83 c4 10             	add    $0x10,%esp
80101c04:	89 f3                	mov    %esi,%ebx
80101c06:	e9 4d ff ff ff       	jmp    80101b58 <namex+0xa2>
  if(nameiparent){
80101c0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101c0f:	0f 84 f8 fe ff ff    	je     80101b0d <namex+0x57>
    iput(ip);
80101c15:	83 ec 0c             	sub    $0xc,%esp
80101c18:	57                   	push   %edi
80101c19:	e8 1d fa ff ff       	call   8010163b <iput>
    return 0;
80101c1e:	83 c4 10             	add    $0x10,%esp
80101c21:	bf 00 00 00 00       	mov    $0x0,%edi
80101c26:	e9 e2 fe ff ff       	jmp    80101b0d <namex+0x57>

80101c2b <dirlink>:
{
80101c2b:	f3 0f 1e fb          	endbr32 
80101c2f:	55                   	push   %ebp
80101c30:	89 e5                	mov    %esp,%ebp
80101c32:	57                   	push   %edi
80101c33:	56                   	push   %esi
80101c34:	53                   	push   %ebx
80101c35:	83 ec 20             	sub    $0x20,%esp
80101c38:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c3b:	6a 00                	push   $0x0
80101c3d:	ff 75 0c             	pushl  0xc(%ebp)
80101c40:	56                   	push   %esi
80101c41:	e8 ce fd ff ff       	call   80101a14 <dirlookup>
80101c46:	83 c4 10             	add    $0x10,%esp
80101c49:	85 c0                	test   %eax,%eax
80101c4b:	75 6a                	jne    80101cb7 <dirlink+0x8c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c4d:	8b 5e 58             	mov    0x58(%esi),%ebx
80101c50:	85 db                	test   %ebx,%ebx
80101c52:	74 29                	je     80101c7d <dirlink+0x52>
80101c54:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c59:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c5c:	6a 10                	push   $0x10
80101c5e:	53                   	push   %ebx
80101c5f:	57                   	push   %edi
80101c60:	56                   	push   %esi
80101c61:	e8 6e fb ff ff       	call   801017d4 <readi>
80101c66:	83 c4 10             	add    $0x10,%esp
80101c69:	83 f8 10             	cmp    $0x10,%eax
80101c6c:	75 5c                	jne    80101cca <dirlink+0x9f>
    if(de.inum == 0)
80101c6e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c73:	74 08                	je     80101c7d <dirlink+0x52>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c75:	83 c3 10             	add    $0x10,%ebx
80101c78:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101c7b:	72 df                	jb     80101c5c <dirlink+0x31>
  strncpy(de.name, name, DIRSIZ);
80101c7d:	83 ec 04             	sub    $0x4,%esp
80101c80:	6a 0e                	push   $0xe
80101c82:	ff 75 0c             	pushl  0xc(%ebp)
80101c85:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c88:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c8b:	50                   	push   %eax
80101c8c:	e8 02 24 00 00       	call   80104093 <strncpy>
  de.inum = inum;
80101c91:	8b 45 10             	mov    0x10(%ebp),%eax
80101c94:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c98:	6a 10                	push   $0x10
80101c9a:	53                   	push   %ebx
80101c9b:	57                   	push   %edi
80101c9c:	56                   	push   %esi
80101c9d:	e8 32 fc ff ff       	call   801018d4 <writei>
80101ca2:	83 c4 20             	add    $0x20,%esp
80101ca5:	83 f8 10             	cmp    $0x10,%eax
80101ca8:	75 2d                	jne    80101cd7 <dirlink+0xac>
  return 0;
80101caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb2:	5b                   	pop    %ebx
80101cb3:	5e                   	pop    %esi
80101cb4:	5f                   	pop    %edi
80101cb5:	5d                   	pop    %ebp
80101cb6:	c3                   	ret    
    iput(ip);
80101cb7:	83 ec 0c             	sub    $0xc,%esp
80101cba:	50                   	push   %eax
80101cbb:	e8 7b f9 ff ff       	call   8010163b <iput>
    return -1;
80101cc0:	83 c4 10             	add    $0x10,%esp
80101cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc8:	eb e5                	jmp    80101caf <dirlink+0x84>
      panic("dirlink read");
80101cca:	83 ec 0c             	sub    $0xc,%esp
80101ccd:	68 e4 79 10 80       	push   $0x801079e4
80101cd2:	e8 81 e6 ff ff       	call   80100358 <panic>
    panic("dirlink");
80101cd7:	83 ec 0c             	sub    $0xc,%esp
80101cda:	68 06 80 10 80       	push   $0x80108006
80101cdf:	e8 74 e6 ff ff       	call   80100358 <panic>

80101ce4 <namei>:

struct inode*
namei(char *path)
{
80101ce4:	f3 0f 1e fb          	endbr32 
80101ce8:	55                   	push   %ebp
80101ce9:	89 e5                	mov    %esp,%ebp
80101ceb:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101cee:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101cf1:	ba 00 00 00 00       	mov    $0x0,%edx
80101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf9:	e8 b8 fd ff ff       	call   80101ab6 <namex>
}
80101cfe:	c9                   	leave  
80101cff:	c3                   	ret    

80101d00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d00:	f3 0f 1e fb          	endbr32 
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d0d:	ba 01 00 00 00       	mov    $0x1,%edx
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	e8 9c fd ff ff       	call   80101ab6 <namex>
}
80101d1a:	c9                   	leave  
80101d1b:	c3                   	ret    

80101d1c <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d1c:	55                   	push   %ebp
80101d1d:	89 e5                	mov    %esp,%ebp
80101d1f:	56                   	push   %esi
80101d20:	53                   	push   %ebx
  if(b == 0)
80101d21:	85 c0                	test   %eax,%eax
80101d23:	0f 84 8b 00 00 00    	je     80101db4 <idestart+0x98>
80101d29:	89 c1                	mov    %eax,%ecx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d2b:	8b 70 08             	mov    0x8(%eax),%esi
80101d2e:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101d34:	0f 87 87 00 00 00    	ja     80101dc1 <idestart+0xa5>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d3a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3f:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d40:	83 e0 c0             	and    $0xffffffc0,%eax
80101d43:	3c 40                	cmp    $0x40,%al
80101d45:	75 f8                	jne    80101d3f <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d47:	bb 00 00 00 00       	mov    $0x0,%ebx
80101d4c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d51:	89 d8                	mov    %ebx,%eax
80101d53:	ee                   	out    %al,(%dx)
80101d54:	b8 01 00 00 00       	mov    $0x1,%eax
80101d59:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d5e:	ee                   	out    %al,(%dx)
80101d5f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d64:	89 f0                	mov    %esi,%eax
80101d66:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d67:	89 f0                	mov    %esi,%eax
80101d69:	c1 f8 08             	sar    $0x8,%eax
80101d6c:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d71:	ee                   	out    %al,(%dx)
80101d72:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d77:	89 d8                	mov    %ebx,%eax
80101d79:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d7a:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101d7e:	c1 e0 04             	shl    $0x4,%eax
80101d81:	83 e0 10             	and    $0x10,%eax
80101d84:	83 c8 e0             	or     $0xffffffe0,%eax
80101d87:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d8c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d8d:	f6 01 04             	testb  $0x4,(%ecx)
80101d90:	74 3c                	je     80101dce <idestart+0xb2>
80101d92:	b8 30 00 00 00       	mov    $0x30,%eax
80101d97:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d9c:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d9d:	8d 71 5c             	lea    0x5c(%ecx),%esi
  asm volatile("cld; rep outsl" :
80101da0:	b9 80 00 00 00       	mov    $0x80,%ecx
80101da5:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101daa:	fc                   	cld    
80101dab:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101dad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101db0:	5b                   	pop    %ebx
80101db1:	5e                   	pop    %esi
80101db2:	5d                   	pop    %ebp
80101db3:	c3                   	ret    
    panic("idestart");
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	68 47 7a 10 80       	push   $0x80107a47
80101dbc:	e8 97 e5 ff ff       	call   80100358 <panic>
    panic("incorrect blockno");
80101dc1:	83 ec 0c             	sub    $0xc,%esp
80101dc4:	68 50 7a 10 80       	push   $0x80107a50
80101dc9:	e8 8a e5 ff ff       	call   80100358 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101dce:	b8 20 00 00 00       	mov    $0x20,%eax
80101dd3:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dd8:	ee                   	out    %al,(%dx)
}
80101dd9:	eb d2                	jmp    80101dad <idestart+0x91>

80101ddb <ideinit>:
{
80101ddb:	f3 0f 1e fb          	endbr32 
80101ddf:	55                   	push   %ebp
80101de0:	89 e5                	mov    %esp,%ebp
80101de2:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101de5:	68 62 7a 10 80       	push   $0x80107a62
80101dea:	68 80 b5 10 80       	push   $0x8010b580
80101def:	e8 49 1f 00 00       	call   80103d3d <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101df4:	83 c4 08             	add    $0x8,%esp
80101df7:	a1 20 59 11 80       	mov    0x80115920,%eax
80101dfc:	83 e8 01             	sub    $0x1,%eax
80101dff:	50                   	push   %eax
80101e00:	6a 0e                	push   $0xe
80101e02:	e8 7d 02 00 00       	call   80102084 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e07:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e0a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e0f:	ec                   	in     (%dx),%al
80101e10:	83 e0 c0             	and    $0xffffffc0,%eax
80101e13:	3c 40                	cmp    $0x40,%al
80101e15:	75 f8                	jne    80101e0f <ideinit+0x34>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101e1c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e22:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e27:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e28:	84 c0                	test   %al,%al
80101e2a:	75 11                	jne    80101e3d <ideinit+0x62>
80101e2c:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101e31:	ec                   	in     (%dx),%al
80101e32:	84 c0                	test   %al,%al
80101e34:	75 07                	jne    80101e3d <ideinit+0x62>
  for(i=0; i<1000; i++){
80101e36:	83 e9 01             	sub    $0x1,%ecx
80101e39:	75 f6                	jne    80101e31 <ideinit+0x56>
80101e3b:	eb 0a                	jmp    80101e47 <ideinit+0x6c>
      havedisk1 = 1;
80101e3d:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80101e44:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e47:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e4c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e51:	ee                   	out    %al,(%dx)
}
80101e52:	c9                   	leave  
80101e53:	c3                   	ret    

80101e54 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e54:	f3 0f 1e fb          	endbr32 
80101e58:	55                   	push   %ebp
80101e59:	89 e5                	mov    %esp,%ebp
80101e5b:	57                   	push   %edi
80101e5c:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e5d:	83 ec 0c             	sub    $0xc,%esp
80101e60:	68 80 b5 10 80       	push   $0x8010b580
80101e65:	e8 2f 20 00 00       	call   80103e99 <acquire>

  if((b = idequeue) == 0){
80101e6a:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80101e70:	83 c4 10             	add    $0x10,%esp
80101e73:	85 db                	test   %ebx,%ebx
80101e75:	74 48                	je     80101ebf <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e77:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7a:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e7f:	f6 03 04             	testb  $0x4,(%ebx)
80101e82:	74 4d                	je     80101ed1 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101e84:	8b 03                	mov    (%ebx),%eax
80101e86:	83 e0 fb             	and    $0xfffffffb,%eax
80101e89:	83 c8 02             	or     $0x2,%eax
80101e8c:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e8e:	83 ec 0c             	sub    $0xc,%esp
80101e91:	53                   	push   %ebx
80101e92:	e8 a3 1b 00 00       	call   80103a3a <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e97:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	85 c0                	test   %eax,%eax
80101ea1:	74 05                	je     80101ea8 <ideintr+0x54>
    idestart(idequeue);
80101ea3:	e8 74 fe ff ff       	call   80101d1c <idestart>

  release(&idelock);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	68 80 b5 10 80       	push   $0x8010b580
80101eb0:	e8 4f 20 00 00       	call   80103f04 <release>
80101eb5:	83 c4 10             	add    $0x10,%esp
}
80101eb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ebb:	5b                   	pop    %ebx
80101ebc:	5f                   	pop    %edi
80101ebd:	5d                   	pop    %ebp
80101ebe:	c3                   	ret    
    release(&idelock);
80101ebf:	83 ec 0c             	sub    $0xc,%esp
80101ec2:	68 80 b5 10 80       	push   $0x8010b580
80101ec7:	e8 38 20 00 00       	call   80103f04 <release>
    return;
80101ecc:	83 c4 10             	add    $0x10,%esp
80101ecf:	eb e7                	jmp    80101eb8 <ideintr+0x64>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ed1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ed6:	ec                   	in     (%dx),%al
80101ed7:	89 c1                	mov    %eax,%ecx
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ed9:	83 e0 c0             	and    $0xffffffc0,%eax
80101edc:	3c 40                	cmp    $0x40,%al
80101ede:	75 f6                	jne    80101ed6 <ideintr+0x82>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101ee0:	f6 c1 21             	test   $0x21,%cl
80101ee3:	75 9f                	jne    80101e84 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101ee5:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101ee8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101eed:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ef2:	fc                   	cld    
80101ef3:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101ef5:	eb 8d                	jmp    80101e84 <ideintr+0x30>

80101ef7 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101ef7:	f3 0f 1e fb          	endbr32 
80101efb:	55                   	push   %ebp
80101efc:	89 e5                	mov    %esp,%ebp
80101efe:	53                   	push   %ebx
80101eff:	83 ec 10             	sub    $0x10,%esp
80101f02:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101f05:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f08:	50                   	push   %eax
80101f09:	e8 e1 1d 00 00       	call   80103cef <holdingsleep>
80101f0e:	83 c4 10             	add    $0x10,%esp
80101f11:	85 c0                	test   %eax,%eax
80101f13:	0f 84 91 00 00 00    	je     80101faa <iderw+0xb3>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f19:	8b 03                	mov    (%ebx),%eax
80101f1b:	83 e0 06             	and    $0x6,%eax
80101f1e:	83 f8 02             	cmp    $0x2,%eax
80101f21:	0f 84 90 00 00 00    	je     80101fb7 <iderw+0xc0>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f27:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101f2b:	74 0d                	je     80101f3a <iderw+0x43>
80101f2d:	83 3d 60 b5 10 80 00 	cmpl   $0x0,0x8010b560
80101f34:	0f 84 8a 00 00 00    	je     80101fc4 <iderw+0xcd>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f3a:	83 ec 0c             	sub    $0xc,%esp
80101f3d:	68 80 b5 10 80       	push   $0x8010b580
80101f42:	e8 52 1f 00 00       	call   80103e99 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f47:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f4e:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	85 c0                	test   %eax,%eax
80101f58:	74 77                	je     80101fd1 <iderw+0xda>
80101f5a:	89 c2                	mov    %eax,%edx
80101f5c:	8b 40 58             	mov    0x58(%eax),%eax
80101f5f:	85 c0                	test   %eax,%eax
80101f61:	75 f7                	jne    80101f5a <iderw+0x63>
80101f63:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101f66:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f68:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80101f6e:	74 68                	je     80101fd8 <iderw+0xe1>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f70:	8b 03                	mov    (%ebx),%eax
80101f72:	83 e0 06             	and    $0x6,%eax
80101f75:	83 f8 02             	cmp    $0x2,%eax
80101f78:	74 1b                	je     80101f95 <iderw+0x9e>
    sleep(b, &idelock);
80101f7a:	83 ec 08             	sub    $0x8,%esp
80101f7d:	68 80 b5 10 80       	push   $0x8010b580
80101f82:	53                   	push   %ebx
80101f83:	e8 2c 19 00 00       	call   801038b4 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f88:	8b 03                	mov    (%ebx),%eax
80101f8a:	83 e0 06             	and    $0x6,%eax
80101f8d:	83 c4 10             	add    $0x10,%esp
80101f90:	83 f8 02             	cmp    $0x2,%eax
80101f93:	75 e5                	jne    80101f7a <iderw+0x83>
  }


  release(&idelock);
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	68 80 b5 10 80       	push   $0x8010b580
80101f9d:	e8 62 1f 00 00       	call   80103f04 <release>
}
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fa8:	c9                   	leave  
80101fa9:	c3                   	ret    
    panic("iderw: buf not locked");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 66 7a 10 80       	push   $0x80107a66
80101fb2:	e8 a1 e3 ff ff       	call   80100358 <panic>
    panic("iderw: nothing to do");
80101fb7:	83 ec 0c             	sub    $0xc,%esp
80101fba:	68 7c 7a 10 80       	push   $0x80107a7c
80101fbf:	e8 94 e3 ff ff       	call   80100358 <panic>
    panic("iderw: ide disk 1 not present");
80101fc4:	83 ec 0c             	sub    $0xc,%esp
80101fc7:	68 91 7a 10 80       	push   $0x80107a91
80101fcc:	e8 87 e3 ff ff       	call   80100358 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fd1:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80101fd6:	eb 8e                	jmp    80101f66 <iderw+0x6f>
    idestart(b);
80101fd8:	89 d8                	mov    %ebx,%eax
80101fda:	e8 3d fd ff ff       	call   80101d1c <idestart>
80101fdf:	eb 8f                	jmp    80101f70 <iderw+0x79>

80101fe1 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fe1:	f3 0f 1e fb          	endbr32 
80101fe5:	55                   	push   %ebp
80101fe6:	89 e5                	mov    %esp,%ebp
80101fe8:	56                   	push   %esi
80101fe9:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fea:	c7 05 54 52 11 80 00 	movl   $0xfec00000,0x80115254
80101ff1:	00 c0 fe 
  ioapic->reg = reg;
80101ff4:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101ffb:	00 00 00 
  return ioapic->data;
80101ffe:	a1 54 52 11 80       	mov    0x80115254,%eax
80102003:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102006:	c1 eb 10             	shr    $0x10,%ebx
80102009:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
8010200c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102012:	a1 54 52 11 80       	mov    0x80115254,%eax
80102017:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010201a:	0f b6 15 80 53 11 80 	movzbl 0x80115380,%edx
  id = ioapicread(REG_ID) >> 24;
80102021:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102024:	39 c2                	cmp    %eax,%edx
80102026:	75 4a                	jne    80102072 <ioapicinit+0x91>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102028:	8d 74 1b 12          	lea    0x12(%ebx,%ebx,1),%esi
{
8010202c:	b8 10 00 00 00       	mov    $0x10,%eax
80102031:	ba 20 00 00 00       	mov    $0x20,%edx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102036:	89 d3                	mov    %edx,%ebx
80102038:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->reg = reg;
8010203e:	8b 0d 54 52 11 80    	mov    0x80115254,%ecx
80102044:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102046:	8b 0d 54 52 11 80    	mov    0x80115254,%ecx
8010204c:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
8010204f:	8d 58 01             	lea    0x1(%eax),%ebx
80102052:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102054:	8b 0d 54 52 11 80    	mov    0x80115254,%ecx
8010205a:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102061:	83 c2 01             	add    $0x1,%edx
80102064:	83 c0 02             	add    $0x2,%eax
80102067:	39 f0                	cmp    %esi,%eax
80102069:	75 cb                	jne    80102036 <ioapicinit+0x55>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010206b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010206e:	5b                   	pop    %ebx
8010206f:	5e                   	pop    %esi
80102070:	5d                   	pop    %ebp
80102071:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102072:	83 ec 0c             	sub    $0xc,%esp
80102075:	68 b0 7a 10 80       	push   $0x80107ab0
8010207a:	e8 ad e5 ff ff       	call   8010062c <cprintf>
8010207f:	83 c4 10             	add    $0x10,%esp
80102082:	eb a4                	jmp    80102028 <ioapicinit+0x47>

80102084 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102084:	f3 0f 1e fb          	endbr32 
80102088:	55                   	push   %ebp
80102089:	89 e5                	mov    %esp,%ebp
8010208b:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010208e:	8d 50 20             	lea    0x20(%eax),%edx
80102091:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102095:	8b 0d 54 52 11 80    	mov    0x80115254,%ecx
8010209b:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010209d:	8b 0d 54 52 11 80    	mov    0x80115254,%ecx
801020a3:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801020a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801020a9:	c1 e2 18             	shl    $0x18,%edx
801020ac:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
801020af:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801020b1:	a1 54 52 11 80       	mov    0x80115254,%eax
801020b6:	89 50 10             	mov    %edx,0x10(%eax)
}
801020b9:	5d                   	pop    %ebp
801020ba:	c3                   	ret    

801020bb <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020bb:	f3 0f 1e fb          	endbr32 
801020bf:	55                   	push   %ebp
801020c0:	89 e5                	mov    %esp,%ebp
801020c2:	53                   	push   %ebx
801020c3:	83 ec 04             	sub    $0x4,%esp
801020c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020c9:	81 fb 3c 79 11 80    	cmp    $0x8011793c,%ebx
801020cf:	0f 92 c0             	setb   %al
801020d2:	89 d9                	mov    %ebx,%ecx
801020d4:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
801020da:	75 49                	jne    80102125 <kfree+0x6a>
801020dc:	84 c0                	test   %al,%al
801020de:	75 45                	jne    80102125 <kfree+0x6a>
801020e0:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
801020e6:	81 fa ff ff ff 0d    	cmp    $0xdffffff,%edx
801020ec:	77 37                	ja     80102125 <kfree+0x6a>
    cprintf("%d %d %d\n",(uint)v%PGSIZE ,v<end,V2P(v)>=PHYSTOP);
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE); // garbage value
801020ee:	83 ec 04             	sub    $0x4,%esp
801020f1:	68 00 10 00 00       	push   $0x1000
801020f6:	6a 01                	push   $0x1
801020f8:	53                   	push   %ebx
801020f9:	e8 51 1e 00 00       	call   80103f4f <memset>

  if(kmem.use_lock)
801020fe:	83 c4 10             	add    $0x10,%esp
80102101:	83 3d 94 52 11 80 00 	cmpl   $0x0,0x80115294
80102108:	75 49                	jne    80102153 <kfree+0x98>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010210a:	a1 98 52 11 80       	mov    0x80115298,%eax
8010210f:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102111:	89 1d 98 52 11 80    	mov    %ebx,0x80115298
  if(kmem.use_lock)
80102117:	83 3d 94 52 11 80 00 	cmpl   $0x0,0x80115294
8010211e:	75 45                	jne    80102165 <kfree+0xaa>
    release(&kmem.lock);
}
80102120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102123:	c9                   	leave  
80102124:	c3                   	ret    
    cprintf("%d %d %d\n",(uint)v%PGSIZE ,v<end,V2P(v)>=PHYSTOP);
80102125:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010212b:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102131:	0f 97 c2             	seta   %dl
80102134:	0f b6 d2             	movzbl %dl,%edx
80102137:	52                   	push   %edx
80102138:	0f b6 c0             	movzbl %al,%eax
8010213b:	50                   	push   %eax
8010213c:	51                   	push   %ecx
8010213d:	68 e2 7a 10 80       	push   $0x80107ae2
80102142:	e8 e5 e4 ff ff       	call   8010062c <cprintf>
    panic("kfree");
80102147:	c7 04 24 ec 7a 10 80 	movl   $0x80107aec,(%esp)
8010214e:	e8 05 e2 ff ff       	call   80100358 <panic>
    acquire(&kmem.lock);
80102153:	83 ec 0c             	sub    $0xc,%esp
80102156:	68 60 52 11 80       	push   $0x80115260
8010215b:	e8 39 1d 00 00       	call   80103e99 <acquire>
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	eb a5                	jmp    8010210a <kfree+0x4f>
    release(&kmem.lock);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 60 52 11 80       	push   $0x80115260
8010216d:	e8 92 1d 00 00       	call   80103f04 <release>
80102172:	83 c4 10             	add    $0x10,%esp
}
80102175:	eb a9                	jmp    80102120 <kfree+0x65>

80102177 <freerange>:
{
80102177:	f3 0f 1e fb          	endbr32 
8010217b:	55                   	push   %ebp
8010217c:	89 e5                	mov    %esp,%ebp
8010217e:	56                   	push   %esi
8010217f:	53                   	push   %ebx
80102180:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102183:	8b 45 08             	mov    0x8(%ebp),%eax
80102186:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010218c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102192:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102198:	39 de                	cmp    %ebx,%esi
8010219a:	72 1c                	jb     801021b8 <freerange+0x41>
    kfree(p);
8010219c:	83 ec 0c             	sub    $0xc,%esp
8010219f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801021a5:	50                   	push   %eax
801021a6:	e8 10 ff ff ff       	call   801020bb <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021b1:	83 c4 10             	add    $0x10,%esp
801021b4:	39 f3                	cmp    %esi,%ebx
801021b6:	76 e4                	jbe    8010219c <freerange+0x25>
}
801021b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021bb:	5b                   	pop    %ebx
801021bc:	5e                   	pop    %esi
801021bd:	5d                   	pop    %ebp
801021be:	c3                   	ret    

801021bf <kinit1>:
{
801021bf:	f3 0f 1e fb          	endbr32 
801021c3:	55                   	push   %ebp
801021c4:	89 e5                	mov    %esp,%ebp
801021c6:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801021c9:	68 f2 7a 10 80       	push   $0x80107af2
801021ce:	68 60 52 11 80       	push   $0x80115260
801021d3:	e8 65 1b 00 00       	call   80103d3d <initlock>
  kmem.use_lock = 0;
801021d8:	c7 05 94 52 11 80 00 	movl   $0x0,0x80115294
801021df:	00 00 00 
  freerange(vstart, vend);
801021e2:	83 c4 08             	add    $0x8,%esp
801021e5:	ff 75 0c             	pushl  0xc(%ebp)
801021e8:	ff 75 08             	pushl  0x8(%ebp)
801021eb:	e8 87 ff ff ff       	call   80102177 <freerange>
}
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	c9                   	leave  
801021f4:	c3                   	ret    

801021f5 <kinit2>:
{
801021f5:	f3 0f 1e fb          	endbr32 
801021f9:	55                   	push   %ebp
801021fa:	89 e5                	mov    %esp,%ebp
801021fc:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801021ff:	ff 75 0c             	pushl  0xc(%ebp)
80102202:	ff 75 08             	pushl  0x8(%ebp)
80102205:	e8 6d ff ff ff       	call   80102177 <freerange>
  kmem.use_lock = 1;
8010220a:	c7 05 94 52 11 80 01 	movl   $0x1,0x80115294
80102211:	00 00 00 
}
80102214:	83 c4 10             	add    $0x10,%esp
80102217:	c9                   	leave  
80102218:	c3                   	ret    

80102219 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102219:	f3 0f 1e fb          	endbr32 
8010221d:	55                   	push   %ebp
8010221e:	89 e5                	mov    %esp,%ebp
80102220:	53                   	push   %ebx
80102221:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102224:	83 3d 94 52 11 80 00 	cmpl   $0x0,0x80115294
8010222b:	75 21                	jne    8010224e <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010222d:	8b 1d 98 52 11 80    	mov    0x80115298,%ebx
  if(r)
80102233:	85 db                	test   %ebx,%ebx
80102235:	74 10                	je     80102247 <kalloc+0x2e>
    kmem.freelist = r->next; // first element of linked list changed
80102237:	8b 03                	mov    (%ebx),%eax
80102239:	a3 98 52 11 80       	mov    %eax,0x80115298
  if(kmem.use_lock)
8010223e:	83 3d 94 52 11 80 00 	cmpl   $0x0,0x80115294
80102245:	75 23                	jne    8010226a <kalloc+0x51>
    release(&kmem.lock);
  return (char*)r;
}
80102247:	89 d8                	mov    %ebx,%eax
80102249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010224c:	c9                   	leave  
8010224d:	c3                   	ret    
    acquire(&kmem.lock);
8010224e:	83 ec 0c             	sub    $0xc,%esp
80102251:	68 60 52 11 80       	push   $0x80115260
80102256:	e8 3e 1c 00 00       	call   80103e99 <acquire>
  r = kmem.freelist;
8010225b:	8b 1d 98 52 11 80    	mov    0x80115298,%ebx
  if(r)
80102261:	83 c4 10             	add    $0x10,%esp
80102264:	85 db                	test   %ebx,%ebx
80102266:	75 cf                	jne    80102237 <kalloc+0x1e>
80102268:	eb d4                	jmp    8010223e <kalloc+0x25>
    release(&kmem.lock);
8010226a:	83 ec 0c             	sub    $0xc,%esp
8010226d:	68 60 52 11 80       	push   $0x80115260
80102272:	e8 8d 1c 00 00       	call   80103f04 <release>
80102277:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
8010227a:	eb cb                	jmp    80102247 <kalloc+0x2e>

8010227c <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
8010227c:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102280:	ba 64 00 00 00       	mov    $0x64,%edx
80102285:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102286:	a8 01                	test   $0x1,%al
80102288:	0f 84 b7 00 00 00    	je     80102345 <kbdgetc+0xc9>
8010228e:	ba 60 00 00 00       	mov    $0x60,%edx
80102293:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102294:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102297:	3c e0                	cmp    $0xe0,%al
80102299:	74 5b                	je     801022f6 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010229b:	84 c0                	test   %al,%al
8010229d:	78 64                	js     80102303 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010229f:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
801022a5:	f6 c1 40             	test   $0x40,%cl
801022a8:	74 0f                	je     801022b9 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801022aa:	83 c8 80             	or     $0xffffff80,%eax
801022ad:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
801022b0:	83 e1 bf             	and    $0xffffffbf,%ecx
801022b3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  }

  shift |= shiftcode[data];
801022b9:	0f b6 8a 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%ecx
801022c0:	0b 0d b4 b5 10 80    	or     0x8010b5b4,%ecx
  shift ^= togglecode[data];
801022c6:	0f b6 82 20 7b 10 80 	movzbl -0x7fef84e0(%edx),%eax
801022cd:	31 c1                	xor    %eax,%ecx
801022cf:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801022d5:	89 c8                	mov    %ecx,%eax
801022d7:	83 e0 03             	and    $0x3,%eax
801022da:	8b 04 85 00 7b 10 80 	mov    -0x7fef8500(,%eax,4),%eax
801022e1:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801022e5:	f6 c1 08             	test   $0x8,%cl
801022e8:	74 61                	je     8010234b <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
801022ea:	8d 50 9f             	lea    -0x61(%eax),%edx
801022ed:	83 fa 19             	cmp    $0x19,%edx
801022f0:	77 46                	ja     80102338 <kbdgetc+0xbc>
      c += 'A' - 'a';
801022f2:	83 e8 20             	sub    $0x20,%eax
801022f5:	c3                   	ret    
    shift |= E0ESC;
801022f6:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
801022fd:	b8 00 00 00 00       	mov    $0x0,%eax
80102302:	c3                   	ret    
{
80102303:	55                   	push   %ebp
80102304:	89 e5                	mov    %esp,%ebp
80102306:	53                   	push   %ebx
    data = (shift & E0ESC ? data : data & 0x7F);
80102307:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
8010230d:	89 cb                	mov    %ecx,%ebx
8010230f:	83 e3 40             	and    $0x40,%ebx
80102312:	83 e0 7f             	and    $0x7f,%eax
80102315:	85 db                	test   %ebx,%ebx
80102317:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010231a:	0f b6 82 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%eax
80102321:	83 c8 40             	or     $0x40,%eax
80102324:	0f b6 c0             	movzbl %al,%eax
80102327:	f7 d0                	not    %eax
80102329:	21 c8                	and    %ecx,%eax
8010232b:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
80102330:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102335:	5b                   	pop    %ebx
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102338:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010233b:	8d 50 20             	lea    0x20(%eax),%edx
8010233e:	83 f9 1a             	cmp    $0x1a,%ecx
80102341:	0f 42 c2             	cmovb  %edx,%eax
  return c;
80102344:	c3                   	ret    
    return -1;
80102345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010234a:	c3                   	ret    
}
8010234b:	c3                   	ret    

8010234c <kbdintr>:

void
kbdintr(void)
{
8010234c:	f3 0f 1e fb          	endbr32 
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102356:	68 7c 22 10 80       	push   $0x8010227c
8010235b:	e8 2b e4 ff ff       	call   8010078b <consoleintr>
}
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	c9                   	leave  
80102364:	c3                   	ret    

80102365 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102365:	8b 0d 9c 52 11 80    	mov    0x8011529c,%ecx
8010236b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010236e:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102370:	a1 9c 52 11 80       	mov    0x8011529c,%eax
80102375:	8b 40 20             	mov    0x20(%eax),%eax
}
80102378:	c3                   	ret    

80102379 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102379:	55                   	push   %ebp
8010237a:	89 e5                	mov    %esp,%ebp
8010237c:	56                   	push   %esi
8010237d:	53                   	push   %ebx
8010237e:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102380:	be 70 00 00 00       	mov    $0x70,%esi
80102385:	b8 00 00 00 00       	mov    $0x0,%eax
8010238a:	89 f2                	mov    %esi,%edx
8010238c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010238d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102392:	89 ca                	mov    %ecx,%edx
80102394:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102395:	0f b6 c0             	movzbl %al,%eax
80102398:	89 03                	mov    %eax,(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010239a:	b8 02 00 00 00       	mov    $0x2,%eax
8010239f:	89 f2                	mov    %esi,%edx
801023a1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	89 ca                	mov    %ecx,%edx
801023a4:	ec                   	in     (%dx),%al
801023a5:	0f b6 c0             	movzbl %al,%eax
801023a8:	89 43 04             	mov    %eax,0x4(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023ab:	b8 04 00 00 00       	mov    $0x4,%eax
801023b0:	89 f2                	mov    %esi,%edx
801023b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023b3:	89 ca                	mov    %ecx,%edx
801023b5:	ec                   	in     (%dx),%al
801023b6:	0f b6 c0             	movzbl %al,%eax
801023b9:	89 43 08             	mov    %eax,0x8(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023bc:	b8 07 00 00 00       	mov    $0x7,%eax
801023c1:	89 f2                	mov    %esi,%edx
801023c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c4:	89 ca                	mov    %ecx,%edx
801023c6:	ec                   	in     (%dx),%al
801023c7:	0f b6 c0             	movzbl %al,%eax
801023ca:	89 43 0c             	mov    %eax,0xc(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023cd:	b8 08 00 00 00       	mov    $0x8,%eax
801023d2:	89 f2                	mov    %esi,%edx
801023d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023d5:	89 ca                	mov    %ecx,%edx
801023d7:	ec                   	in     (%dx),%al
801023d8:	0f b6 c0             	movzbl %al,%eax
801023db:	89 43 10             	mov    %eax,0x10(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023de:	b8 09 00 00 00       	mov    $0x9,%eax
801023e3:	89 f2                	mov    %esi,%edx
801023e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e6:	89 ca                	mov    %ecx,%edx
801023e8:	ec                   	in     (%dx),%al
801023e9:	0f b6 c0             	movzbl %al,%eax
801023ec:	89 43 14             	mov    %eax,0x14(%ebx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801023ef:	5b                   	pop    %ebx
801023f0:	5e                   	pop    %esi
801023f1:	5d                   	pop    %ebp
801023f2:	c3                   	ret    

801023f3 <lapicinit>:
{
801023f3:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801023f7:	83 3d 9c 52 11 80 00 	cmpl   $0x0,0x8011529c
801023fe:	0f 84 ff 00 00 00    	je     80102503 <lapicinit+0x110>
{
80102404:	55                   	push   %ebp
80102405:	89 e5                	mov    %esp,%ebp
80102407:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010240a:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010240f:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102414:	e8 4c ff ff ff       	call   80102365 <lapicw>
  lapicw(TDCR, X1);
80102419:	ba 0b 00 00 00       	mov    $0xb,%edx
8010241e:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102423:	e8 3d ff ff ff       	call   80102365 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102428:	ba 20 00 02 00       	mov    $0x20020,%edx
8010242d:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102432:	e8 2e ff ff ff       	call   80102365 <lapicw>
  lapicw(TICR, 10000000);
80102437:	ba 80 96 98 00       	mov    $0x989680,%edx
8010243c:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102441:	e8 1f ff ff ff       	call   80102365 <lapicw>
  lapicw(LINT0, MASKED);
80102446:	ba 00 00 01 00       	mov    $0x10000,%edx
8010244b:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102450:	e8 10 ff ff ff       	call   80102365 <lapicw>
  lapicw(LINT1, MASKED);
80102455:	ba 00 00 01 00       	mov    $0x10000,%edx
8010245a:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010245f:	e8 01 ff ff ff       	call   80102365 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102464:	a1 9c 52 11 80       	mov    0x8011529c,%eax
80102469:	8b 40 30             	mov    0x30(%eax),%eax
8010246c:	c1 e8 10             	shr    $0x10,%eax
8010246f:	a8 fc                	test   $0xfc,%al
80102471:	75 7c                	jne    801024ef <lapicinit+0xfc>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102473:	ba 33 00 00 00       	mov    $0x33,%edx
80102478:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010247d:	e8 e3 fe ff ff       	call   80102365 <lapicw>
  lapicw(ESR, 0);
80102482:	ba 00 00 00 00       	mov    $0x0,%edx
80102487:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010248c:	e8 d4 fe ff ff       	call   80102365 <lapicw>
  lapicw(ESR, 0);
80102491:	ba 00 00 00 00       	mov    $0x0,%edx
80102496:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010249b:	e8 c5 fe ff ff       	call   80102365 <lapicw>
  lapicw(EOI, 0);
801024a0:	ba 00 00 00 00       	mov    $0x0,%edx
801024a5:	b8 2c 00 00 00       	mov    $0x2c,%eax
801024aa:	e8 b6 fe ff ff       	call   80102365 <lapicw>
  lapicw(ICRHI, 0);
801024af:	ba 00 00 00 00       	mov    $0x0,%edx
801024b4:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024b9:	e8 a7 fe ff ff       	call   80102365 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801024be:	ba 00 85 08 00       	mov    $0x88500,%edx
801024c3:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024c8:	e8 98 fe ff ff       	call   80102365 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801024cd:	8b 15 9c 52 11 80    	mov    0x8011529c,%edx
801024d3:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
801024d9:	f6 c4 10             	test   $0x10,%ah
801024dc:	75 f5                	jne    801024d3 <lapicinit+0xe0>
  lapicw(TPR, 0);
801024de:	ba 00 00 00 00       	mov    $0x0,%edx
801024e3:	b8 20 00 00 00       	mov    $0x20,%eax
801024e8:	e8 78 fe ff ff       	call   80102365 <lapicw>
}
801024ed:	c9                   	leave  
801024ee:	c3                   	ret    
    lapicw(PCINT, MASKED);
801024ef:	ba 00 00 01 00       	mov    $0x10000,%edx
801024f4:	b8 d0 00 00 00       	mov    $0xd0,%eax
801024f9:	e8 67 fe ff ff       	call   80102365 <lapicw>
801024fe:	e9 70 ff ff ff       	jmp    80102473 <lapicinit+0x80>
80102503:	c3                   	ret    

80102504 <lapicid>:
{
80102504:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102508:	a1 9c 52 11 80       	mov    0x8011529c,%eax
8010250d:	85 c0                	test   %eax,%eax
8010250f:	74 07                	je     80102518 <lapicid+0x14>
  return lapic[ID] >> 24;
80102511:	8b 40 20             	mov    0x20(%eax),%eax
80102514:	c1 e8 18             	shr    $0x18,%eax
80102517:	c3                   	ret    
    return 0;
80102518:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010251d:	c3                   	ret    

8010251e <lapiceoi>:
{
8010251e:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102522:	83 3d 9c 52 11 80 00 	cmpl   $0x0,0x8011529c
80102529:	74 17                	je     80102542 <lapiceoi+0x24>
{
8010252b:	55                   	push   %ebp
8010252c:	89 e5                	mov    %esp,%ebp
8010252e:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102531:	ba 00 00 00 00       	mov    $0x0,%edx
80102536:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010253b:	e8 25 fe ff ff       	call   80102365 <lapicw>
}
80102540:	c9                   	leave  
80102541:	c3                   	ret    
80102542:	c3                   	ret    

80102543 <microdelay>:
{
80102543:	f3 0f 1e fb          	endbr32 
}
80102547:	c3                   	ret    

80102548 <lapicstartap>:
{
80102548:	f3 0f 1e fb          	endbr32 
8010254c:	55                   	push   %ebp
8010254d:	89 e5                	mov    %esp,%ebp
8010254f:	56                   	push   %esi
80102550:	53                   	push   %ebx
80102551:	8b 75 08             	mov    0x8(%ebp),%esi
80102554:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102557:	b8 0f 00 00 00       	mov    $0xf,%eax
8010255c:	ba 70 00 00 00       	mov    $0x70,%edx
80102561:	ee                   	out    %al,(%dx)
80102562:	b8 0a 00 00 00       	mov    $0xa,%eax
80102567:	ba 71 00 00 00       	mov    $0x71,%edx
8010256c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010256d:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102574:	00 00 
  wrv[1] = addr >> 4;
80102576:	89 d8                	mov    %ebx,%eax
80102578:	c1 e8 04             	shr    $0x4,%eax
8010257b:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
80102581:	c1 e6 18             	shl    $0x18,%esi
80102584:	89 f2                	mov    %esi,%edx
80102586:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010258b:	e8 d5 fd ff ff       	call   80102365 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102590:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102595:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010259a:	e8 c6 fd ff ff       	call   80102365 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010259f:	ba 00 85 00 00       	mov    $0x8500,%edx
801025a4:	b8 c0 00 00 00       	mov    $0xc0,%eax
801025a9:	e8 b7 fd ff ff       	call   80102365 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801025ae:	c1 eb 0c             	shr    $0xc,%ebx
801025b1:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
801025b4:	89 f2                	mov    %esi,%edx
801025b6:	b8 c4 00 00 00       	mov    $0xc4,%eax
801025bb:	e8 a5 fd ff ff       	call   80102365 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801025c0:	89 da                	mov    %ebx,%edx
801025c2:	b8 c0 00 00 00       	mov    $0xc0,%eax
801025c7:	e8 99 fd ff ff       	call   80102365 <lapicw>
    lapicw(ICRHI, apicid<<24);
801025cc:	89 f2                	mov    %esi,%edx
801025ce:	b8 c4 00 00 00       	mov    $0xc4,%eax
801025d3:	e8 8d fd ff ff       	call   80102365 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801025d8:	89 da                	mov    %ebx,%edx
801025da:	b8 c0 00 00 00       	mov    $0xc0,%eax
801025df:	e8 81 fd ff ff       	call   80102365 <lapicw>
}
801025e4:	5b                   	pop    %ebx
801025e5:	5e                   	pop    %esi
801025e6:	5d                   	pop    %ebp
801025e7:	c3                   	ret    

801025e8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801025e8:	f3 0f 1e fb          	endbr32 
801025ec:	55                   	push   %ebp
801025ed:	89 e5                	mov    %esp,%ebp
801025ef:	57                   	push   %edi
801025f0:	56                   	push   %esi
801025f1:	53                   	push   %ebx
801025f2:	83 ec 4c             	sub    $0x4c,%esp
801025f5:	b8 0b 00 00 00       	mov    $0xb,%eax
801025fa:	ba 70 00 00 00       	mov    $0x70,%edx
801025ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102600:	ba 71 00 00 00       	mov    $0x71,%edx
80102605:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102606:	83 e0 04             	and    $0x4,%eax
80102609:	88 45 b7             	mov    %al,-0x49(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010260c:	8d 75 d0             	lea    -0x30(%ebp),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010260f:	bf 0a 00 00 00       	mov    $0xa,%edi
80102614:	89 f0                	mov    %esi,%eax
80102616:	e8 5e fd ff ff       	call   80102379 <fill_rtcdate>
8010261b:	ba 70 00 00 00       	mov    $0x70,%edx
80102620:	89 f8                	mov    %edi,%eax
80102622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	ba 71 00 00 00       	mov    $0x71,%edx
80102628:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102629:	84 c0                	test   %al,%al
8010262b:	78 e7                	js     80102614 <cmostime+0x2c>
        continue;
    fill_rtcdate(&t2);
8010262d:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102630:	89 d8                	mov    %ebx,%eax
80102632:	e8 42 fd ff ff       	call   80102379 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102637:	83 ec 04             	sub    $0x4,%esp
8010263a:	6a 18                	push   $0x18
8010263c:	53                   	push   %ebx
8010263d:	56                   	push   %esi
8010263e:	e8 53 19 00 00       	call   80103f96 <memcmp>
80102643:	83 c4 10             	add    $0x10,%esp
80102646:	85 c0                	test   %eax,%eax
80102648:	75 ca                	jne    80102614 <cmostime+0x2c>
      break;
  }

  // convert
  if(bcd) {
8010264a:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
8010264e:	75 78                	jne    801026c8 <cmostime+0xe0>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102650:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102653:	89 c2                	mov    %eax,%edx
80102655:	c1 ea 04             	shr    $0x4,%edx
80102658:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010265b:	83 e0 0f             	and    $0xf,%eax
8010265e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102661:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102664:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102667:	89 c2                	mov    %eax,%edx
80102669:	c1 ea 04             	shr    $0x4,%edx
8010266c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010266f:	83 e0 0f             	and    $0xf,%eax
80102672:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102678:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010267b:	89 c2                	mov    %eax,%edx
8010267d:	c1 ea 04             	shr    $0x4,%edx
80102680:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102683:	83 e0 0f             	and    $0xf,%eax
80102686:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102689:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
8010268c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010268f:	89 c2                	mov    %eax,%edx
80102691:	c1 ea 04             	shr    $0x4,%edx
80102694:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102697:	83 e0 0f             	and    $0xf,%eax
8010269a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010269d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026a3:	89 c2                	mov    %eax,%edx
801026a5:	c1 ea 04             	shr    $0x4,%edx
801026a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801026ab:	83 e0 0f             	and    $0xf,%eax
801026ae:	8d 04 50             	lea    (%eax,%edx,2),%eax
801026b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801026b7:	89 c2                	mov    %eax,%edx
801026b9:	c1 ea 04             	shr    $0x4,%edx
801026bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801026bf:	83 e0 0f             	and    $0xf,%eax
801026c2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801026c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801026c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801026cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801026ce:	89 01                	mov    %eax,(%ecx)
801026d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801026d3:	89 41 04             	mov    %eax,0x4(%ecx)
801026d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801026d9:	89 41 08             	mov    %eax,0x8(%ecx)
801026dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801026df:	89 41 0c             	mov    %eax,0xc(%ecx)
801026e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026e5:	89 41 10             	mov    %eax,0x10(%ecx)
801026e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801026eb:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801026ee:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801026f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026f8:	5b                   	pop    %ebx
801026f9:	5e                   	pop    %esi
801026fa:	5f                   	pop    %edi
801026fb:	5d                   	pop    %ebp
801026fc:	c3                   	ret    

801026fd <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026fd:	83 3d e8 52 11 80 00 	cmpl   $0x0,0x801152e8
80102704:	0f 8e 84 00 00 00    	jle    8010278e <install_trans+0x91>
{
8010270a:	55                   	push   %ebp
8010270b:	89 e5                	mov    %esp,%ebp
8010270d:	57                   	push   %edi
8010270e:	56                   	push   %esi
8010270f:	53                   	push   %ebx
80102710:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102713:	be 00 00 00 00       	mov    $0x0,%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102718:	bf a0 52 11 80       	mov    $0x801152a0,%edi
8010271d:	83 ec 08             	sub    $0x8,%esp
80102720:	89 f0                	mov    %esi,%eax
80102722:	03 47 34             	add    0x34(%edi),%eax
80102725:	83 c0 01             	add    $0x1,%eax
80102728:	50                   	push   %eax
80102729:	ff 77 44             	pushl  0x44(%edi)
8010272c:	e8 7d d9 ff ff       	call   801000ae <bread>
80102731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102734:	83 c4 08             	add    $0x8,%esp
80102737:	ff 34 b5 ec 52 11 80 	pushl  -0x7feead14(,%esi,4)
8010273e:	ff 77 44             	pushl  0x44(%edi)
80102741:	e8 68 d9 ff ff       	call   801000ae <bread>
80102746:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102748:	83 c4 0c             	add    $0xc,%esp
8010274b:	68 00 02 00 00       	push   $0x200
80102750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102753:	83 c0 5c             	add    $0x5c,%eax
80102756:	50                   	push   %eax
80102757:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010275a:	50                   	push   %eax
8010275b:	e8 7c 18 00 00       	call   80103fdc <memmove>
    bwrite(dbuf);  // write dst to disk
80102760:	89 1c 24             	mov    %ebx,(%esp)
80102763:	e8 26 da ff ff       	call   8010018e <bwrite>
    brelse(lbuf);
80102768:	83 c4 04             	add    $0x4,%esp
8010276b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010276e:	e8 5a da ff ff       	call   801001cd <brelse>
    brelse(dbuf);
80102773:	89 1c 24             	mov    %ebx,(%esp)
80102776:	e8 52 da ff ff       	call   801001cd <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010277b:	83 c6 01             	add    $0x1,%esi
8010277e:	83 c4 10             	add    $0x10,%esp
80102781:	39 77 48             	cmp    %esi,0x48(%edi)
80102784:	7f 97                	jg     8010271d <install_trans+0x20>
  }
}
80102786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102789:	5b                   	pop    %ebx
8010278a:	5e                   	pop    %esi
8010278b:	5f                   	pop    %edi
8010278c:	5d                   	pop    %ebp
8010278d:	c3                   	ret    
8010278e:	c3                   	ret    

8010278f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010278f:	55                   	push   %ebp
80102790:	89 e5                	mov    %esp,%ebp
80102792:	53                   	push   %ebx
80102793:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102796:	ff 35 d4 52 11 80    	pushl  0x801152d4
8010279c:	ff 35 e4 52 11 80    	pushl  0x801152e4
801027a2:	e8 07 d9 ff ff       	call   801000ae <bread>
801027a7:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801027a9:	8b 0d e8 52 11 80    	mov    0x801152e8,%ecx
801027af:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801027b2:	83 c4 10             	add    $0x10,%esp
801027b5:	85 c9                	test   %ecx,%ecx
801027b7:	7e 17                	jle    801027d0 <write_head+0x41>
801027b9:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
801027be:	8b 14 85 ec 52 11 80 	mov    -0x7feead14(,%eax,4),%edx
801027c5:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801027c9:	83 c0 01             	add    $0x1,%eax
801027cc:	39 c1                	cmp    %eax,%ecx
801027ce:	75 ee                	jne    801027be <write_head+0x2f>
  }
  bwrite(buf);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	53                   	push   %ebx
801027d4:	e8 b5 d9 ff ff       	call   8010018e <bwrite>
  brelse(buf);
801027d9:	89 1c 24             	mov    %ebx,(%esp)
801027dc:	e8 ec d9 ff ff       	call   801001cd <brelse>
}
801027e1:	83 c4 10             	add    $0x10,%esp
801027e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e7:	c9                   	leave  
801027e8:	c3                   	ret    

801027e9 <initlog>:
{
801027e9:	f3 0f 1e fb          	endbr32 
801027ed:	55                   	push   %ebp
801027ee:	89 e5                	mov    %esp,%ebp
801027f0:	53                   	push   %ebx
801027f1:	83 ec 2c             	sub    $0x2c,%esp
801027f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027f7:	68 20 7d 10 80       	push   $0x80107d20
801027fc:	68 a0 52 11 80       	push   $0x801152a0
80102801:	e8 37 15 00 00       	call   80103d3d <initlock>
  readsb(dev, &sb);
80102806:	83 c4 08             	add    $0x8,%esp
80102809:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010280c:	50                   	push   %eax
8010280d:	53                   	push   %ebx
8010280e:	e8 f1 ea ff ff       	call   80101304 <readsb>
  log.start = sb.logstart;
80102813:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102816:	a3 d4 52 11 80       	mov    %eax,0x801152d4
  log.size = sb.nlog;
8010281b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010281e:	89 15 d8 52 11 80    	mov    %edx,0x801152d8
  log.dev = dev;
80102824:	89 1d e4 52 11 80    	mov    %ebx,0x801152e4
  struct buf *buf = bread(log.dev, log.start);
8010282a:	83 c4 08             	add    $0x8,%esp
8010282d:	50                   	push   %eax
8010282e:	53                   	push   %ebx
8010282f:	e8 7a d8 ff ff       	call   801000ae <bread>
  log.lh.n = lh->n;
80102834:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102837:	89 0d e8 52 11 80    	mov    %ecx,0x801152e8
  for (i = 0; i < log.lh.n; i++) {
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	85 c9                	test   %ecx,%ecx
80102842:	7e 17                	jle    8010285b <initlog+0x72>
80102844:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
80102849:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
8010284d:	89 1c 95 ec 52 11 80 	mov    %ebx,-0x7feead14(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102854:	83 c2 01             	add    $0x1,%edx
80102857:	39 d1                	cmp    %edx,%ecx
80102859:	75 ee                	jne    80102849 <initlog+0x60>
  brelse(buf);
8010285b:	83 ec 0c             	sub    $0xc,%esp
8010285e:	50                   	push   %eax
8010285f:	e8 69 d9 ff ff       	call   801001cd <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102864:	e8 94 fe ff ff       	call   801026fd <install_trans>
  log.lh.n = 0;
80102869:	c7 05 e8 52 11 80 00 	movl   $0x0,0x801152e8
80102870:	00 00 00 
  write_head(); // clear the log
80102873:	e8 17 ff ff ff       	call   8010278f <write_head>
}
80102878:	83 c4 10             	add    $0x10,%esp
8010287b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010287e:	c9                   	leave  
8010287f:	c3                   	ret    

80102880 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102880:	f3 0f 1e fb          	endbr32 
80102884:	55                   	push   %ebp
80102885:	89 e5                	mov    %esp,%ebp
80102887:	53                   	push   %ebx
80102888:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010288b:	68 a0 52 11 80       	push   $0x801152a0
80102890:	e8 04 16 00 00       	call   80103e99 <acquire>
80102895:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80102898:	bb a0 52 11 80       	mov    $0x801152a0,%ebx
8010289d:	eb 15                	jmp    801028b4 <begin_op+0x34>
      sleep(&log, &log.lock);
8010289f:	83 ec 08             	sub    $0x8,%esp
801028a2:	68 a0 52 11 80       	push   $0x801152a0
801028a7:	68 a0 52 11 80       	push   $0x801152a0
801028ac:	e8 03 10 00 00       	call   801038b4 <sleep>
801028b1:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801028b4:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
801028b8:	75 e5                	jne    8010289f <begin_op+0x1f>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801028ba:	8b 43 3c             	mov    0x3c(%ebx),%eax
801028bd:	83 c0 01             	add    $0x1,%eax
801028c0:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801028c3:	8b 53 48             	mov    0x48(%ebx),%edx
801028c6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801028c9:	83 fa 1e             	cmp    $0x1e,%edx
801028cc:	7e 17                	jle    801028e5 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801028ce:	83 ec 08             	sub    $0x8,%esp
801028d1:	68 a0 52 11 80       	push   $0x801152a0
801028d6:	68 a0 52 11 80       	push   $0x801152a0
801028db:	e8 d4 0f 00 00       	call   801038b4 <sleep>
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	eb cf                	jmp    801028b4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
801028e5:	a3 dc 52 11 80       	mov    %eax,0x801152dc
      release(&log.lock);
801028ea:	83 ec 0c             	sub    $0xc,%esp
801028ed:	68 a0 52 11 80       	push   $0x801152a0
801028f2:	e8 0d 16 00 00       	call   80103f04 <release>
      break;
    }
  }
}
801028f7:	83 c4 10             	add    $0x10,%esp
801028fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028fd:	c9                   	leave  
801028fe:	c3                   	ret    

801028ff <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801028ff:	f3 0f 1e fb          	endbr32 
80102903:	55                   	push   %ebp
80102904:	89 e5                	mov    %esp,%ebp
80102906:	57                   	push   %edi
80102907:	56                   	push   %esi
80102908:	53                   	push   %ebx
80102909:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010290c:	68 a0 52 11 80       	push   $0x801152a0
80102911:	e8 83 15 00 00       	call   80103e99 <acquire>
  log.outstanding -= 1;
80102916:	a1 dc 52 11 80       	mov    0x801152dc,%eax
8010291b:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010291e:	89 1d dc 52 11 80    	mov    %ebx,0x801152dc
  if(log.committing)
80102924:	83 c4 10             	add    $0x10,%esp
80102927:	83 3d e0 52 11 80 00 	cmpl   $0x0,0x801152e0
8010292e:	75 66                	jne    80102996 <end_op+0x97>
    panic("log.committing");
  if(log.outstanding == 0){
80102930:	85 db                	test   %ebx,%ebx
80102932:	75 6f                	jne    801029a3 <end_op+0xa4>
    do_commit = 1;
    log.committing = 1;
80102934:	c7 05 e0 52 11 80 01 	movl   $0x1,0x801152e0
8010293b:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	68 a0 52 11 80       	push   $0x801152a0
80102946:	e8 b9 15 00 00       	call   80103f04 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
8010294b:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010294e:	bf a0 52 11 80       	mov    $0x801152a0,%edi
  if (log.lh.n > 0) {
80102953:	83 3d e8 52 11 80 00 	cmpl   $0x0,0x801152e8
8010295a:	7f 65                	jg     801029c1 <end_op+0xc2>
    acquire(&log.lock);
8010295c:	83 ec 0c             	sub    $0xc,%esp
8010295f:	68 a0 52 11 80       	push   $0x801152a0
80102964:	e8 30 15 00 00       	call   80103e99 <acquire>
    log.committing = 0;
80102969:	c7 05 e0 52 11 80 00 	movl   $0x0,0x801152e0
80102970:	00 00 00 
    wakeup(&log);
80102973:	c7 04 24 a0 52 11 80 	movl   $0x801152a0,(%esp)
8010297a:	e8 bb 10 00 00       	call   80103a3a <wakeup>
    release(&log.lock);
8010297f:	c7 04 24 a0 52 11 80 	movl   $0x801152a0,(%esp)
80102986:	e8 79 15 00 00       	call   80103f04 <release>
8010298b:	83 c4 10             	add    $0x10,%esp
}
8010298e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102991:	5b                   	pop    %ebx
80102992:	5e                   	pop    %esi
80102993:	5f                   	pop    %edi
80102994:	5d                   	pop    %ebp
80102995:	c3                   	ret    
    panic("log.committing");
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	68 24 7d 10 80       	push   $0x80107d24
8010299e:	e8 b5 d9 ff ff       	call   80100358 <panic>
    wakeup(&log);
801029a3:	83 ec 0c             	sub    $0xc,%esp
801029a6:	68 a0 52 11 80       	push   $0x801152a0
801029ab:	e8 8a 10 00 00       	call   80103a3a <wakeup>
  release(&log.lock);
801029b0:	c7 04 24 a0 52 11 80 	movl   $0x801152a0,(%esp)
801029b7:	e8 48 15 00 00       	call   80103f04 <release>
801029bc:	83 c4 10             	add    $0x10,%esp
801029bf:	eb cd                	jmp    8010298e <end_op+0x8f>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801029c1:	83 ec 08             	sub    $0x8,%esp
801029c4:	89 d8                	mov    %ebx,%eax
801029c6:	03 47 34             	add    0x34(%edi),%eax
801029c9:	83 c0 01             	add    $0x1,%eax
801029cc:	50                   	push   %eax
801029cd:	ff 77 44             	pushl  0x44(%edi)
801029d0:	e8 d9 d6 ff ff       	call   801000ae <bread>
801029d5:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801029d7:	83 c4 08             	add    $0x8,%esp
801029da:	ff 34 9d ec 52 11 80 	pushl  -0x7feead14(,%ebx,4)
801029e1:	ff 77 44             	pushl  0x44(%edi)
801029e4:	e8 c5 d6 ff ff       	call   801000ae <bread>
    memmove(to->data, from->data, BSIZE);
801029e9:	83 c4 0c             	add    $0xc,%esp
801029ec:	68 00 02 00 00       	push   $0x200
801029f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801029f4:	83 c0 5c             	add    $0x5c,%eax
801029f7:	50                   	push   %eax
801029f8:	8d 46 5c             	lea    0x5c(%esi),%eax
801029fb:	50                   	push   %eax
801029fc:	e8 db 15 00 00       	call   80103fdc <memmove>
    bwrite(to);  // write the log
80102a01:	89 34 24             	mov    %esi,(%esp)
80102a04:	e8 85 d7 ff ff       	call   8010018e <bwrite>
    brelse(from);
80102a09:	83 c4 04             	add    $0x4,%esp
80102a0c:	ff 75 e4             	pushl  -0x1c(%ebp)
80102a0f:	e8 b9 d7 ff ff       	call   801001cd <brelse>
    brelse(to);
80102a14:	89 34 24             	mov    %esi,(%esp)
80102a17:	e8 b1 d7 ff ff       	call   801001cd <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a1c:	83 c3 01             	add    $0x1,%ebx
80102a1f:	83 c4 10             	add    $0x10,%esp
80102a22:	3b 5f 48             	cmp    0x48(%edi),%ebx
80102a25:	7c 9a                	jl     801029c1 <end_op+0xc2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102a27:	e8 63 fd ff ff       	call   8010278f <write_head>
    install_trans(); // Now install writes to home locations
80102a2c:	e8 cc fc ff ff       	call   801026fd <install_trans>
    log.lh.n = 0;
80102a31:	c7 05 e8 52 11 80 00 	movl   $0x0,0x801152e8
80102a38:	00 00 00 
    write_head();    // Erase the transaction from the log
80102a3b:	e8 4f fd ff ff       	call   8010278f <write_head>
80102a40:	e9 17 ff ff ff       	jmp    8010295c <end_op+0x5d>

80102a45 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102a45:	f3 0f 1e fb          	endbr32 
80102a49:	55                   	push   %ebp
80102a4a:	89 e5                	mov    %esp,%ebp
80102a4c:	53                   	push   %ebx
80102a4d:	83 ec 04             	sub    $0x4,%esp
80102a50:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a53:	8b 15 e8 52 11 80    	mov    0x801152e8,%edx
80102a59:	83 fa 1d             	cmp    $0x1d,%edx
80102a5c:	7f 5c                	jg     80102aba <log_write+0x75>
80102a5e:	a1 d8 52 11 80       	mov    0x801152d8,%eax
80102a63:	83 e8 01             	sub    $0x1,%eax
80102a66:	39 c2                	cmp    %eax,%edx
80102a68:	7d 50                	jge    80102aba <log_write+0x75>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a6a:	83 3d dc 52 11 80 00 	cmpl   $0x0,0x801152dc
80102a71:	7e 54                	jle    80102ac7 <log_write+0x82>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a73:	83 ec 0c             	sub    $0xc,%esp
80102a76:	68 a0 52 11 80       	push   $0x801152a0
80102a7b:	e8 19 14 00 00       	call   80103e99 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a80:	8b 15 e8 52 11 80    	mov    0x801152e8,%edx
80102a86:	83 c4 10             	add    $0x10,%esp
80102a89:	85 d2                	test   %edx,%edx
80102a8b:	7e 47                	jle    80102ad4 <log_write+0x8f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a8d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a90:	b8 00 00 00 00       	mov    $0x0,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a95:	39 0c 85 ec 52 11 80 	cmp    %ecx,-0x7feead14(,%eax,4)
80102a9c:	74 3b                	je     80102ad9 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
80102a9e:	83 c0 01             	add    $0x1,%eax
80102aa1:	39 d0                	cmp    %edx,%eax
80102aa3:	75 f0                	jne    80102a95 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102aa5:	8b 43 08             	mov    0x8(%ebx),%eax
80102aa8:	89 04 95 ec 52 11 80 	mov    %eax,-0x7feead14(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102aaf:	83 c2 01             	add    $0x1,%edx
80102ab2:	89 15 e8 52 11 80    	mov    %edx,0x801152e8
80102ab8:	eb 2d                	jmp    80102ae7 <log_write+0xa2>
    panic("too big a transaction");
80102aba:	83 ec 0c             	sub    $0xc,%esp
80102abd:	68 33 7d 10 80       	push   $0x80107d33
80102ac2:	e8 91 d8 ff ff       	call   80100358 <panic>
    panic("log_write outside of trans");
80102ac7:	83 ec 0c             	sub    $0xc,%esp
80102aca:	68 49 7d 10 80       	push   $0x80107d49
80102acf:	e8 84 d8 ff ff       	call   80100358 <panic>
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  log.lh.block[i] = b->blockno;
80102ad9:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102adc:	89 0c 85 ec 52 11 80 	mov    %ecx,-0x7feead14(,%eax,4)
  if (i == log.lh.n)
80102ae3:	39 c2                	cmp    %eax,%edx
80102ae5:	74 18                	je     80102aff <log_write+0xba>
  b->flags |= B_DIRTY; // prevent eviction
80102ae7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102aea:	83 ec 0c             	sub    $0xc,%esp
80102aed:	68 a0 52 11 80       	push   $0x801152a0
80102af2:	e8 0d 14 00 00       	call   80103f04 <release>
}
80102af7:	83 c4 10             	add    $0x10,%esp
80102afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afd:	c9                   	leave  
80102afe:	c3                   	ret    
80102aff:	89 c2                	mov    %eax,%edx
80102b01:	eb ac                	jmp    80102aaf <log_write+0x6a>

80102b03 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102b03:	55                   	push   %ebp
80102b04:	89 e5                	mov    %esp,%ebp
80102b06:	53                   	push   %ebx
80102b07:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102b0a:	e8 bc 08 00 00       	call   801033cb <cpuid>
80102b0f:	89 c3                	mov    %eax,%ebx
80102b11:	e8 b5 08 00 00       	call   801033cb <cpuid>
80102b16:	83 ec 04             	sub    $0x4,%esp
80102b19:	53                   	push   %ebx
80102b1a:	50                   	push   %eax
80102b1b:	68 64 7d 10 80       	push   $0x80107d64
80102b20:	e8 07 db ff ff       	call   8010062c <cprintf>
  idtinit();       // load idt register
80102b25:	e8 d7 25 00 00       	call   80105101 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102b2a:	e8 37 08 00 00       	call   80103366 <mycpu>
80102b2f:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b31:	b8 01 00 00 00       	mov    $0x1,%eax
80102b36:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102b3d:	e8 35 0b 00 00       	call   80103677 <scheduler>

80102b42 <mpenter>:
{
80102b42:	f3 0f 1e fb          	endbr32 
80102b46:	55                   	push   %ebp
80102b47:	89 e5                	mov    %esp,%ebp
80102b49:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b4c:	e8 80 35 00 00       	call   801060d1 <switchkvm>
  seginit();
80102b51:	e8 90 34 00 00       	call   80105fe6 <seginit>
  lapicinit();
80102b56:	e8 98 f8 ff ff       	call   801023f3 <lapicinit>
  mpmain();
80102b5b:	e8 a3 ff ff ff       	call   80102b03 <mpmain>

80102b60 <main>:
{
80102b60:	f3 0f 1e fb          	endbr32 
80102b64:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b68:	83 e4 f0             	and    $0xfffffff0,%esp
80102b6b:	ff 71 fc             	pushl  -0x4(%ecx)
80102b6e:	55                   	push   %ebp
80102b6f:	89 e5                	mov    %esp,%ebp
80102b71:	53                   	push   %ebx
80102b72:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b73:	83 ec 08             	sub    $0x8,%esp
80102b76:	68 00 00 40 80       	push   $0x80400000
80102b7b:	68 3c 79 11 80       	push   $0x8011793c
80102b80:	e8 3a f6 ff ff       	call   801021bf <kinit1>
  kvmalloc();      // kernel page table
80102b85:	e8 e6 39 00 00       	call   80106570 <kvmalloc>
  mpinit();        // detect other processors
80102b8a:	e8 55 01 00 00       	call   80102ce4 <mpinit>
  lapicinit();     // interrupt controller
80102b8f:	e8 5f f8 ff ff       	call   801023f3 <lapicinit>
  seginit();       // segment descriptors
80102b94:	e8 4d 34 00 00       	call   80105fe6 <seginit>
  picinit();       // disable pic
80102b99:	e8 02 03 00 00       	call   80102ea0 <picinit>
  ioapicinit();    // another interrupt controller
80102b9e:	e8 3e f4 ff ff       	call   80101fe1 <ioapicinit>
  consoleinit();   // console hardware
80102ba3:	e8 7d dd ff ff       	call   80100925 <consoleinit>
  uartinit();      // serial port
80102ba8:	e8 20 28 00 00       	call   801053cd <uartinit>
  pinit();         // process table
80102bad:	e8 82 07 00 00       	call   80103334 <pinit>
  tvinit();        // trap vectors
80102bb2:	e8 bb 24 00 00       	call   80105072 <tvinit>
  binit();         // buffer cache
80102bb7:	e8 78 d4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102bbc:	e8 f6 e0 ff ff       	call   80100cb7 <fileinit>
  ideinit();       // disk 
80102bc1:	e8 15 f2 ff ff       	call   80101ddb <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102bc6:	83 c4 0c             	add    $0xc,%esp
80102bc9:	68 8a 00 00 00       	push   $0x8a
80102bce:	68 8c b4 10 80       	push   $0x8010b48c
80102bd3:	68 00 70 00 80       	push   $0x80007000
80102bd8:	e8 ff 13 00 00       	call   80103fdc <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102bdd:	69 05 20 59 11 80 b0 	imul   $0xb0,0x80115920,%eax
80102be4:	00 00 00 
80102be7:	05 a0 53 11 80       	add    $0x801153a0,%eax
80102bec:	83 c4 10             	add    $0x10,%esp
80102bef:	3d a0 53 11 80       	cmp    $0x801153a0,%eax
80102bf4:	76 6c                	jbe    80102c62 <main+0x102>
80102bf6:	bb a0 53 11 80       	mov    $0x801153a0,%ebx
80102bfb:	eb 5a                	jmp    80102c57 <main+0xf7>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102bfd:	e8 17 f6 ff ff       	call   80102219 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102c02:	05 00 10 00 00       	add    $0x1000,%eax
80102c07:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102c0c:	c7 05 f8 6f 00 80 42 	movl   $0x80102b42,0x80006ff8
80102c13:	2b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102c16:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102c1d:	a0 10 00 

    lapicstartap(c->apicid, V2P(code));
80102c20:	83 ec 08             	sub    $0x8,%esp
80102c23:	68 00 70 00 00       	push   $0x7000
80102c28:	0f b6 03             	movzbl (%ebx),%eax
80102c2b:	50                   	push   %eax
80102c2c:	e8 17 f9 ff ff       	call   80102548 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102c3a:	85 c0                	test   %eax,%eax
80102c3c:	74 f6                	je     80102c34 <main+0xd4>
  for(c = cpus; c < cpus+ncpu; c++){
80102c3e:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102c44:	69 05 20 59 11 80 b0 	imul   $0xb0,0x80115920,%eax
80102c4b:	00 00 00 
80102c4e:	05 a0 53 11 80       	add    $0x801153a0,%eax
80102c53:	39 c3                	cmp    %eax,%ebx
80102c55:	73 0b                	jae    80102c62 <main+0x102>
    if(c == mycpu())  // We've started already.
80102c57:	e8 0a 07 00 00       	call   80103366 <mycpu>
80102c5c:	39 c3                	cmp    %eax,%ebx
80102c5e:	74 de                	je     80102c3e <main+0xde>
80102c60:	eb 9b                	jmp    80102bfd <main+0x9d>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102c62:	83 ec 08             	sub    $0x8,%esp
80102c65:	68 00 00 00 8e       	push   $0x8e000000
80102c6a:	68 00 00 40 80       	push   $0x80400000
80102c6f:	e8 81 f5 ff ff       	call   801021f5 <kinit2>
  slabinit();
80102c74:	e8 c3 3e 00 00       	call   80106b3c <slabinit>
  userinit();      // first user process
80102c79:	e8 94 07 00 00       	call   80103412 <userinit>
  mpmain();        // finish this processor's setup
80102c7e:	e8 80 fe ff ff       	call   80102b03 <mpmain>

80102c83 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c83:	55                   	push   %ebp
80102c84:	89 e5                	mov    %esp,%ebp
80102c86:	57                   	push   %edi
80102c87:	56                   	push   %esi
80102c88:	53                   	push   %ebx
80102c89:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c8c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102c92:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102c95:	39 f3                	cmp    %esi,%ebx
80102c97:	72 12                	jb     80102cab <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102c99:	bb 00 00 00 00       	mov    $0x0,%ebx
80102c9e:	eb 3a                	jmp    80102cda <mpsearch1+0x57>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ca0:	84 c0                	test   %al,%al
80102ca2:	74 36                	je     80102cda <mpsearch1+0x57>
  for(p = addr; p < e; p += sizeof(struct mp))
80102ca4:	83 c3 10             	add    $0x10,%ebx
80102ca7:	39 de                	cmp    %ebx,%esi
80102ca9:	76 2a                	jbe    80102cd5 <mpsearch1+0x52>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102cab:	83 ec 04             	sub    $0x4,%esp
80102cae:	6a 04                	push   $0x4
80102cb0:	68 78 7d 10 80       	push   $0x80107d78
80102cb5:	53                   	push   %ebx
80102cb6:	e8 db 12 00 00       	call   80103f96 <memcmp>
80102cbb:	83 c4 10             	add    $0x10,%esp
80102cbe:	85 c0                	test   %eax,%eax
80102cc0:	75 e2                	jne    80102ca4 <mpsearch1+0x21>
80102cc2:	89 da                	mov    %ebx,%edx
  for(i=0; i<len; i++)
80102cc4:	8d 7b 10             	lea    0x10(%ebx),%edi
    sum += addr[i];
80102cc7:	0f b6 0a             	movzbl (%edx),%ecx
80102cca:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102ccc:	83 c2 01             	add    $0x1,%edx
80102ccf:	39 fa                	cmp    %edi,%edx
80102cd1:	75 f4                	jne    80102cc7 <mpsearch1+0x44>
80102cd3:	eb cb                	jmp    80102ca0 <mpsearch1+0x1d>
  return 0;
80102cd5:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102cda:	89 d8                	mov    %ebx,%eax
80102cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdf:	5b                   	pop    %ebx
80102ce0:	5e                   	pop    %esi
80102ce1:	5f                   	pop    %edi
80102ce2:	5d                   	pop    %ebp
80102ce3:	c3                   	ret    

80102ce4 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ce4:	f3 0f 1e fb          	endbr32 
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	57                   	push   %edi
80102cec:	56                   	push   %esi
80102ced:	53                   	push   %ebx
80102cee:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102cf1:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102cf8:	c1 e0 08             	shl    $0x8,%eax
80102cfb:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102d02:	09 d0                	or     %edx,%eax
80102d04:	c1 e0 04             	shl    $0x4,%eax
80102d07:	0f 84 c0 00 00 00    	je     80102dcd <mpinit+0xe9>
    if((mp = mpsearch1(p, 1024)))
80102d0d:	ba 00 04 00 00       	mov    $0x400,%edx
80102d12:	e8 6c ff ff ff       	call   80102c83 <mpsearch1>
80102d17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d1a:	85 c0                	test   %eax,%eax
80102d1c:	75 1a                	jne    80102d38 <mpinit+0x54>
  return mpsearch1(0xF0000, 0x10000);
80102d1e:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d23:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d28:	e8 56 ff ff ff       	call   80102c83 <mpsearch1>
80102d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d30:	85 c0                	test   %eax,%eax
80102d32:	0f 84 5b 01 00 00    	je     80102e93 <mpinit+0x1af>
80102d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d3b:	8b 70 04             	mov    0x4(%eax),%esi
80102d3e:	85 f6                	test   %esi,%esi
80102d40:	0f 84 4d 01 00 00    	je     80102e93 <mpinit+0x1af>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102d46:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102d4c:	83 ec 04             	sub    $0x4,%esp
80102d4f:	6a 04                	push   $0x4
80102d51:	68 7d 7d 10 80       	push   $0x80107d7d
80102d56:	57                   	push   %edi
80102d57:	e8 3a 12 00 00       	call   80103f96 <memcmp>
80102d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102d5f:	83 c4 10             	add    $0x10,%esp
80102d62:	85 c0                	test   %eax,%eax
80102d64:	0f 85 29 01 00 00    	jne    80102e93 <mpinit+0x1af>
  if(conf->version != 1 && conf->version != 4)
80102d6a:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102d71:	3c 01                	cmp    $0x1,%al
80102d73:	74 08                	je     80102d7d <mpinit+0x99>
80102d75:	3c 04                	cmp    $0x4,%al
80102d77:	0f 85 16 01 00 00    	jne    80102e93 <mpinit+0x1af>
  if(sum((uchar*)conf, conf->length) != 0)
80102d7d:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102d84:	66 85 d2             	test   %dx,%dx
80102d87:	74 23                	je     80102dac <mpinit+0xc8>
80102d89:	89 f0                	mov    %esi,%eax
80102d8b:	0f b7 d2             	movzwl %dx,%edx
80102d8e:	8d 1c 32             	lea    (%edx,%esi,1),%ebx
  sum = 0;
80102d91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    sum += addr[i];
80102d94:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80102d9b:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102d9d:	83 c0 01             	add    $0x1,%eax
80102da0:	39 d8                	cmp    %ebx,%eax
80102da2:	75 f0                	jne    80102d94 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80102da4:	84 d2                	test   %dl,%dl
80102da6:	0f 85 e7 00 00 00    	jne    80102e93 <mpinit+0x1af>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102dac:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80102db2:	a3 9c 52 11 80       	mov    %eax,0x8011529c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102db7:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80102dbd:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102dc4:	01 fa                	add    %edi,%edx
  ismp = 1;
80102dc6:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102dcb:	eb 40                	jmp    80102e0d <mpinit+0x129>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102dcd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102dd4:	c1 e0 08             	shl    $0x8,%eax
80102dd7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102dde:	09 d0                	or     %edx,%eax
80102de0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102de3:	2d 00 04 00 00       	sub    $0x400,%eax
80102de8:	ba 00 04 00 00       	mov    $0x400,%edx
80102ded:	e8 91 fe ff ff       	call   80102c83 <mpsearch1>
80102df2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102df5:	85 c0                	test   %eax,%eax
80102df7:	0f 85 3b ff ff ff    	jne    80102d38 <mpinit+0x54>
80102dfd:	e9 1c ff ff ff       	jmp    80102d1e <mpinit+0x3a>
    switch(*p){
80102e02:	83 e9 03             	sub    $0x3,%ecx
80102e05:	80 f9 01             	cmp    $0x1,%cl
80102e08:	76 15                	jbe    80102e1f <mpinit+0x13b>
80102e0a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e0d:	39 d0                	cmp    %edx,%eax
80102e0f:	73 4b                	jae    80102e5c <mpinit+0x178>
    switch(*p){
80102e11:	0f b6 08             	movzbl (%eax),%ecx
80102e14:	80 f9 02             	cmp    $0x2,%cl
80102e17:	74 34                	je     80102e4d <mpinit+0x169>
80102e19:	77 e7                	ja     80102e02 <mpinit+0x11e>
80102e1b:	84 c9                	test   %cl,%cl
80102e1d:	74 05                	je     80102e24 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102e1f:	83 c0 08             	add    $0x8,%eax
      continue;
80102e22:	eb e9                	jmp    80102e0d <mpinit+0x129>
      if(ncpu < NCPU) {
80102e24:	8b 0d 20 59 11 80    	mov    0x80115920,%ecx
80102e2a:	83 f9 07             	cmp    $0x7,%ecx
80102e2d:	7f 19                	jg     80102e48 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102e2f:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80102e35:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80102e39:	88 9f a0 53 11 80    	mov    %bl,-0x7feeac60(%edi)
        ncpu++;
80102e3f:	83 c1 01             	add    $0x1,%ecx
80102e42:	89 0d 20 59 11 80    	mov    %ecx,0x80115920
      p += sizeof(struct mpproc);
80102e48:	83 c0 14             	add    $0x14,%eax
      continue;
80102e4b:	eb c0                	jmp    80102e0d <mpinit+0x129>
      ioapicid = ioapic->apicno;
80102e4d:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80102e51:	88 0d 80 53 11 80    	mov    %cl,0x80115380
      p += sizeof(struct mpioapic);
80102e57:	83 c0 08             	add    $0x8,%eax
      continue;
80102e5a:	eb b1                	jmp    80102e0d <mpinit+0x129>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102e5c:	85 f6                	test   %esi,%esi
80102e5e:	74 26                	je     80102e86 <mpinit+0x1a2>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e63:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102e67:	74 15                	je     80102e7e <mpinit+0x19a>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e69:	b8 70 00 00 00       	mov    $0x70,%eax
80102e6e:	ba 22 00 00 00       	mov    $0x22,%edx
80102e73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e74:	ba 23 00 00 00       	mov    $0x23,%edx
80102e79:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102e7a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e7d:	ee                   	out    %al,(%dx)
  }
}
80102e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e81:	5b                   	pop    %ebx
80102e82:	5e                   	pop    %esi
80102e83:	5f                   	pop    %edi
80102e84:	5d                   	pop    %ebp
80102e85:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102e86:	83 ec 0c             	sub    $0xc,%esp
80102e89:	68 9c 7d 10 80       	push   $0x80107d9c
80102e8e:	e8 c5 d4 ff ff       	call   80100358 <panic>
    panic("Expect to run on an SMP");
80102e93:	83 ec 0c             	sub    $0xc,%esp
80102e96:	68 82 7d 10 80       	push   $0x80107d82
80102e9b:	e8 b8 d4 ff ff       	call   80100358 <panic>

80102ea0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102ea0:	f3 0f 1e fb          	endbr32 
80102ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ea9:	ba 21 00 00 00       	mov    $0x21,%edx
80102eae:	ee                   	out    %al,(%dx)
80102eaf:	ba a1 00 00 00       	mov    $0xa1,%edx
80102eb4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102eb5:	c3                   	ret    

80102eb6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102eb6:	f3 0f 1e fb          	endbr32 
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	57                   	push   %edi
80102ebe:	56                   	push   %esi
80102ebf:	53                   	push   %ebx
80102ec0:	83 ec 0c             	sub    $0xc,%esp
80102ec3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ec6:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102ec9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102ecf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102ed5:	e8 fb dd ff ff       	call   80100cd5 <filealloc>
80102eda:	89 03                	mov    %eax,(%ebx)
80102edc:	85 c0                	test   %eax,%eax
80102ede:	0f 84 a6 00 00 00    	je     80102f8a <pipealloc+0xd4>
80102ee4:	e8 ec dd ff ff       	call   80100cd5 <filealloc>
80102ee9:	89 06                	mov    %eax,(%esi)
80102eeb:	85 c0                	test   %eax,%eax
80102eed:	0f 84 85 00 00 00    	je     80102f78 <pipealloc+0xc2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102ef3:	e8 21 f3 ff ff       	call   80102219 <kalloc>
80102ef8:	89 c7                	mov    %eax,%edi
80102efa:	85 c0                	test   %eax,%eax
80102efc:	74 72                	je     80102f70 <pipealloc+0xba>
    goto bad;
  p->readopen = 1;
80102efe:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102f05:	00 00 00 
  p->writeopen = 1;
80102f08:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102f0f:	00 00 00 
  p->nwrite = 0;
80102f12:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102f19:	00 00 00 
  p->nread = 0;
80102f1c:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102f23:	00 00 00 
  initlock(&p->lock, "pipe");
80102f26:	83 ec 08             	sub    $0x8,%esp
80102f29:	68 bb 7d 10 80       	push   $0x80107dbb
80102f2e:	50                   	push   %eax
80102f2f:	e8 09 0e 00 00       	call   80103d3d <initlock>
  (*f0)->type = FD_PIPE;
80102f34:	8b 03                	mov    (%ebx),%eax
80102f36:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102f3c:	8b 03                	mov    (%ebx),%eax
80102f3e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102f42:	8b 03                	mov    (%ebx),%eax
80102f44:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102f48:	8b 03                	mov    (%ebx),%eax
80102f4a:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102f4d:	8b 06                	mov    (%esi),%eax
80102f4f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102f55:	8b 06                	mov    (%esi),%eax
80102f57:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102f5b:	8b 06                	mov    (%esi),%eax
80102f5d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102f61:	8b 06                	mov    (%esi),%eax
80102f63:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102f66:	83 c4 10             	add    $0x10,%esp
80102f69:	b8 00 00 00 00       	mov    $0x0,%eax
80102f6e:	eb 36                	jmp    80102fa6 <pipealloc+0xf0>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102f70:	8b 03                	mov    (%ebx),%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 08                	jne    80102f7e <pipealloc+0xc8>
80102f76:	eb 12                	jmp    80102f8a <pipealloc+0xd4>
80102f78:	8b 03                	mov    (%ebx),%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	74 30                	je     80102fae <pipealloc+0xf8>
    fileclose(*f0);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	50                   	push   %eax
80102f82:	e8 fa dd ff ff       	call   80100d81 <fileclose>
80102f87:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f8a:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102f91:	85 d2                	test   %edx,%edx
80102f93:	74 11                	je     80102fa6 <pipealloc+0xf0>
    fileclose(*f1);
80102f95:	83 ec 0c             	sub    $0xc,%esp
80102f98:	52                   	push   %edx
80102f99:	e8 e3 dd ff ff       	call   80100d81 <fileclose>
80102f9e:	83 c4 10             	add    $0x10,%esp
  return -1;
80102fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fa9:	5b                   	pop    %ebx
80102faa:	5e                   	pop    %esi
80102fab:	5f                   	pop    %edi
80102fac:	5d                   	pop    %ebp
80102fad:	c3                   	ret    
  return -1;
80102fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fb3:	eb f1                	jmp    80102fa6 <pipealloc+0xf0>

80102fb5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102fb5:	f3 0f 1e fb          	endbr32 
80102fb9:	55                   	push   %ebp
80102fba:	89 e5                	mov    %esp,%ebp
80102fbc:	53                   	push   %ebx
80102fbd:	83 ec 10             	sub    $0x10,%esp
80102fc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102fc3:	53                   	push   %ebx
80102fc4:	e8 d0 0e 00 00       	call   80103e99 <acquire>
  if(writable){
80102fc9:	83 c4 10             	add    $0x10,%esp
80102fcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102fd0:	74 3f                	je     80103011 <pipeclose+0x5c>
    p->writeopen = 0;
80102fd2:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102fd9:	00 00 00 
    wakeup(&p->nread);
80102fdc:	83 ec 0c             	sub    $0xc,%esp
80102fdf:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fe5:	50                   	push   %eax
80102fe6:	e8 4f 0a 00 00       	call   80103a3a <wakeup>
80102feb:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102fee:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ff5:	75 09                	jne    80103000 <pipeclose+0x4b>
80102ff7:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102ffe:	74 2f                	je     8010302f <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103000:	83 ec 0c             	sub    $0xc,%esp
80103003:	53                   	push   %ebx
80103004:	e8 fb 0e 00 00       	call   80103f04 <release>
80103009:	83 c4 10             	add    $0x10,%esp
}
8010300c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010300f:	c9                   	leave  
80103010:	c3                   	ret    
    p->readopen = 0;
80103011:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103018:	00 00 00 
    wakeup(&p->nwrite);
8010301b:	83 ec 0c             	sub    $0xc,%esp
8010301e:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103024:	50                   	push   %eax
80103025:	e8 10 0a 00 00       	call   80103a3a <wakeup>
8010302a:	83 c4 10             	add    $0x10,%esp
8010302d:	eb bf                	jmp    80102fee <pipeclose+0x39>
    release(&p->lock);
8010302f:	83 ec 0c             	sub    $0xc,%esp
80103032:	53                   	push   %ebx
80103033:	e8 cc 0e 00 00       	call   80103f04 <release>
    kfree((char*)p);
80103038:	89 1c 24             	mov    %ebx,(%esp)
8010303b:	e8 7b f0 ff ff       	call   801020bb <kfree>
80103040:	83 c4 10             	add    $0x10,%esp
80103043:	eb c7                	jmp    8010300c <pipeclose+0x57>

80103045 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103045:	f3 0f 1e fb          	endbr32 
80103049:	55                   	push   %ebp
8010304a:	89 e5                	mov    %esp,%ebp
8010304c:	57                   	push   %edi
8010304d:	56                   	push   %esi
8010304e:	53                   	push   %ebx
8010304f:	83 ec 28             	sub    $0x28,%esp
80103052:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103055:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80103058:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010305b:	53                   	push   %ebx
8010305c:	e8 38 0e 00 00       	call   80103e99 <acquire>
  for(i = 0; i < n; i++){
80103061:	83 c4 10             	add    $0x10,%esp
80103064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103068:	0f 8e 8f 00 00 00    	jle    801030fd <pipewrite+0xb8>
8010306e:	89 75 e0             	mov    %esi,-0x20(%ebp)
80103071:	03 75 10             	add    0x10(%ebp),%esi
80103074:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103077:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010307d:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103083:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103089:	05 00 02 00 00       	add    $0x200,%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010308e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103094:	39 c2                	cmp    %eax,%edx
80103096:	75 41                	jne    801030d9 <pipewrite+0x94>
      if(p->readopen == 0 || myproc()->killed){
80103098:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
8010309f:	74 7b                	je     8010311c <pipewrite+0xd7>
801030a1:	e8 44 03 00 00       	call   801033ea <myproc>
801030a6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030aa:	75 70                	jne    8010311c <pipewrite+0xd7>
      wakeup(&p->nread);
801030ac:	83 ec 0c             	sub    $0xc,%esp
801030af:	57                   	push   %edi
801030b0:	e8 85 09 00 00       	call   80103a3a <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801030b5:	83 c4 08             	add    $0x8,%esp
801030b8:	ff 75 e4             	pushl  -0x1c(%ebp)
801030bb:	56                   	push   %esi
801030bc:	e8 f3 07 00 00       	call   801038b4 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801030c1:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801030c7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801030cd:	05 00 02 00 00       	add    $0x200,%eax
801030d2:	83 c4 10             	add    $0x10,%esp
801030d5:	39 c2                	cmp    %eax,%edx
801030d7:	74 bf                	je     80103098 <pipewrite+0x53>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801030d9:	8d 42 01             	lea    0x1(%edx),%eax
801030dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801030e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801030e5:	0f b6 01             	movzbl (%ecx),%eax
801030e8:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801030ee:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801030f2:	83 c1 01             	add    $0x1,%ecx
801030f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801030f8:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
801030fb:	75 80                	jne    8010307d <pipewrite+0x38>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801030fd:	83 ec 0c             	sub    $0xc,%esp
80103100:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103106:	50                   	push   %eax
80103107:	e8 2e 09 00 00       	call   80103a3a <wakeup>
  release(&p->lock);
8010310c:	89 1c 24             	mov    %ebx,(%esp)
8010310f:	e8 f0 0d 00 00       	call   80103f04 <release>
  return n;
80103114:	83 c4 10             	add    $0x10,%esp
80103117:	8b 45 10             	mov    0x10(%ebp),%eax
8010311a:	eb 11                	jmp    8010312d <pipewrite+0xe8>
        release(&p->lock);
8010311c:	83 ec 0c             	sub    $0xc,%esp
8010311f:	53                   	push   %ebx
80103120:	e8 df 0d 00 00       	call   80103f04 <release>
        return -1;
80103125:	83 c4 10             	add    $0x10,%esp
80103128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010312d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103130:	5b                   	pop    %ebx
80103131:	5e                   	pop    %esi
80103132:	5f                   	pop    %edi
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    

80103135 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103135:	f3 0f 1e fb          	endbr32 
80103139:	55                   	push   %ebp
8010313a:	89 e5                	mov    %esp,%ebp
8010313c:	57                   	push   %edi
8010313d:	56                   	push   %esi
8010313e:	53                   	push   %ebx
8010313f:	83 ec 18             	sub    $0x18,%esp
80103142:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103145:	89 df                	mov    %ebx,%edi
80103147:	53                   	push   %ebx
80103148:	e8 4c 0d 00 00       	call   80103e99 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010314d:	83 c4 10             	add    $0x10,%esp
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103150:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103156:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010315c:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103162:	75 2f                	jne    80103193 <piperead+0x5e>
80103164:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
8010316b:	74 26                	je     80103193 <piperead+0x5e>
    if(myproc()->killed){
8010316d:	e8 78 02 00 00       	call   801033ea <myproc>
80103172:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103176:	75 79                	jne    801031f1 <piperead+0xbc>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103178:	83 ec 08             	sub    $0x8,%esp
8010317b:	57                   	push   %edi
8010317c:	56                   	push   %esi
8010317d:	e8 32 07 00 00       	call   801038b4 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103182:	83 c4 10             	add    $0x10,%esp
80103185:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010318b:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103191:	74 d1                	je     80103164 <piperead+0x2f>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103193:	be 00 00 00 00       	mov    $0x0,%esi
80103198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010319c:	7e 2f                	jle    801031cd <piperead+0x98>
    if(p->nread == p->nwrite)
8010319e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801031a4:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801031aa:	74 21                	je     801031cd <piperead+0x98>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801031ac:	8d 50 01             	lea    0x1(%eax),%edx
801031af:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
801031b5:	25 ff 01 00 00       	and    $0x1ff,%eax
801031ba:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801031bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031c2:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801031c5:	83 c6 01             	add    $0x1,%esi
801031c8:	39 75 10             	cmp    %esi,0x10(%ebp)
801031cb:	75 d1                	jne    8010319e <piperead+0x69>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801031cd:	83 ec 0c             	sub    $0xc,%esp
801031d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801031d6:	50                   	push   %eax
801031d7:	e8 5e 08 00 00       	call   80103a3a <wakeup>
  release(&p->lock);
801031dc:	89 1c 24             	mov    %ebx,(%esp)
801031df:	e8 20 0d 00 00       	call   80103f04 <release>
  return i;
801031e4:	83 c4 10             	add    $0x10,%esp
}
801031e7:	89 f0                	mov    %esi,%eax
801031e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031ec:	5b                   	pop    %ebx
801031ed:	5e                   	pop    %esi
801031ee:	5f                   	pop    %edi
801031ef:	5d                   	pop    %ebp
801031f0:	c3                   	ret    
      release(&p->lock);
801031f1:	83 ec 0c             	sub    $0xc,%esp
801031f4:	53                   	push   %ebx
801031f5:	e8 0a 0d 00 00       	call   80103f04 <release>
      return -1;
801031fa:	83 c4 10             	add    $0x10,%esp
801031fd:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103202:	eb e3                	jmp    801031e7 <piperead+0xb2>

80103204 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103204:	ba 74 59 11 80       	mov    $0x80115974,%edx
80103209:	eb 15                	jmp    80103220 <wakeup1+0x1c>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
8010320b:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103212:	81 c2 84 00 00 00    	add    $0x84,%edx
80103218:	81 fa b4 61 11 80    	cmp    $0x801161b4,%edx
8010321e:	74 0d                	je     8010322d <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
80103220:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103224:	75 ec                	jne    80103212 <wakeup1+0xe>
80103226:	39 42 20             	cmp    %eax,0x20(%edx)
80103229:	75 e7                	jne    80103212 <wakeup1+0xe>
8010322b:	eb de                	jmp    8010320b <wakeup1+0x7>
}
8010322d:	c3                   	ret    

8010322e <allocproc>:
{
8010322e:	55                   	push   %ebp
8010322f:	89 e5                	mov    %esp,%ebp
80103231:	53                   	push   %ebx
80103232:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103235:	68 40 59 11 80       	push   $0x80115940
8010323a:	e8 5a 0c 00 00       	call   80103e99 <acquire>
8010323f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103242:	bb 74 59 11 80       	mov    $0x80115974,%ebx
    if(p->state == UNUSED)
80103247:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
8010324b:	74 2a                	je     80103277 <allocproc+0x49>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010324d:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103253:	81 fb b4 61 11 80    	cmp    $0x801161b4,%ebx
80103259:	75 ec                	jne    80103247 <allocproc+0x19>
  release(&ptable.lock);
8010325b:	83 ec 0c             	sub    $0xc,%esp
8010325e:	68 40 59 11 80       	push   $0x80115940
80103263:	e8 9c 0c 00 00       	call   80103f04 <release>
  return 0;
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80103270:	89 d8                	mov    %ebx,%eax
80103272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103275:	c9                   	leave  
80103276:	c3                   	ret    
  p->state = EMBRYO;
80103277:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010327e:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103283:	8d 50 01             	lea    0x1(%eax),%edx
80103286:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010328c:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010328f:	83 ec 0c             	sub    $0xc,%esp
80103292:	68 40 59 11 80       	push   $0x80115940
80103297:	e8 68 0c 00 00       	call   80103f04 <release>
  if((p->kstack = kalloc()) == 0){
8010329c:	e8 78 ef ff ff       	call   80102219 <kalloc>
801032a1:	89 43 08             	mov    %eax,0x8(%ebx)
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	74 37                	je     801032e2 <allocproc+0xb4>
  sp -= sizeof *p->tf;
801032ab:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801032b1:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801032b4:	c7 80 b0 0f 00 00 67 	movl   $0x80105067,0xfb0(%eax)
801032bb:	50 10 80 
  sp -= sizeof *p->context;
801032be:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801032c3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	6a 14                	push   $0x14
801032cb:	6a 00                	push   $0x0
801032cd:	50                   	push   %eax
801032ce:	e8 7c 0c 00 00       	call   80103f4f <memset>
  p->context->eip = (uint)forkret;
801032d3:	8b 43 1c             	mov    0x1c(%ebx),%eax
801032d6:	c7 40 10 ed 32 10 80 	movl   $0x801032ed,0x10(%eax)
  return p;
801032dd:	83 c4 10             	add    $0x10,%esp
801032e0:	eb 8e                	jmp    80103270 <allocproc+0x42>
    p->state = UNUSED;
801032e2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801032e9:	89 c3                	mov    %eax,%ebx
801032eb:	eb 83                	jmp    80103270 <allocproc+0x42>

801032ed <forkret>:
{
801032ed:	f3 0f 1e fb          	endbr32 
801032f1:	55                   	push   %ebp
801032f2:	89 e5                	mov    %esp,%ebp
801032f4:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801032f7:	68 40 59 11 80       	push   $0x80115940
801032fc:	e8 03 0c 00 00       	call   80103f04 <release>
  if (first) {
80103301:	83 c4 10             	add    $0x10,%esp
80103304:	83 3d 00 b0 10 80 00 	cmpl   $0x0,0x8010b000
8010330b:	75 02                	jne    8010330f <forkret+0x22>
}
8010330d:	c9                   	leave  
8010330e:	c3                   	ret    
    first = 0;
8010330f:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103316:	00 00 00 
    iinit(ROOTDEV);
80103319:	83 ec 0c             	sub    $0xc,%esp
8010331c:	6a 01                	push   $0x1
8010331e:	e8 19 e0 ff ff       	call   8010133c <iinit>
    initlog(ROOTDEV);
80103323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010332a:	e8 ba f4 ff ff       	call   801027e9 <initlog>
8010332f:	83 c4 10             	add    $0x10,%esp
}
80103332:	eb d9                	jmp    8010330d <forkret+0x20>

80103334 <pinit>:
{
80103334:	f3 0f 1e fb          	endbr32 
80103338:	55                   	push   %ebp
80103339:	89 e5                	mov    %esp,%ebp
8010333b:	83 ec 0c             	sub    $0xc,%esp
  memset(ptable.proc, 0, sizeof *ptable.proc);
8010333e:	68 84 00 00 00       	push   $0x84
80103343:	6a 00                	push   $0x0
80103345:	68 74 59 11 80       	push   $0x80115974
8010334a:	e8 00 0c 00 00       	call   80103f4f <memset>
  initlock(&ptable.lock, "ptable");
8010334f:	83 c4 08             	add    $0x8,%esp
80103352:	68 c0 7d 10 80       	push   $0x80107dc0
80103357:	68 40 59 11 80       	push   $0x80115940
8010335c:	e8 dc 09 00 00       	call   80103d3d <initlock>
}
80103361:	83 c4 10             	add    $0x10,%esp
80103364:	c9                   	leave  
80103365:	c3                   	ret    

80103366 <mycpu>:
{
80103366:	f3 0f 1e fb          	endbr32 
8010336a:	55                   	push   %ebp
8010336b:	89 e5                	mov    %esp,%ebp
8010336d:	56                   	push   %esi
8010336e:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010336f:	9c                   	pushf  
80103370:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103371:	f6 c4 02             	test   $0x2,%ah
80103374:	75 3b                	jne    801033b1 <mycpu+0x4b>
  apicid = lapicid();
80103376:	e8 89 f1 ff ff       	call   80102504 <lapicid>
8010337b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010337d:	8b 35 20 59 11 80    	mov    0x80115920,%esi
80103383:	85 f6                	test   %esi,%esi
80103385:	7e 1d                	jle    801033a4 <mycpu+0x3e>
80103387:	ba 00 00 00 00       	mov    $0x0,%edx
    if (cpus[i].apicid == apicid)
8010338c:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103392:	0f b6 81 a0 53 11 80 	movzbl -0x7feeac60(%ecx),%eax
80103399:	39 d8                	cmp    %ebx,%eax
8010339b:	74 21                	je     801033be <mycpu+0x58>
  for (i = 0; i < ncpu; ++i) {
8010339d:	83 c2 01             	add    $0x1,%edx
801033a0:	39 f2                	cmp    %esi,%edx
801033a2:	75 e8                	jne    8010338c <mycpu+0x26>
  panic("unknown apicid\n");
801033a4:	83 ec 0c             	sub    $0xc,%esp
801033a7:	68 c7 7d 10 80       	push   $0x80107dc7
801033ac:	e8 a7 cf ff ff       	call   80100358 <panic>
    panic("mycpu called with interrupts enabled\n");
801033b1:	83 ec 0c             	sub    $0xc,%esp
801033b4:	68 bc 7e 10 80       	push   $0x80107ebc
801033b9:	e8 9a cf ff ff       	call   80100358 <panic>
      return &cpus[i];
801033be:	8d 81 a0 53 11 80    	lea    -0x7feeac60(%ecx),%eax
}
801033c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c7:	5b                   	pop    %ebx
801033c8:	5e                   	pop    %esi
801033c9:	5d                   	pop    %ebp
801033ca:	c3                   	ret    

801033cb <cpuid>:
cpuid() {
801033cb:	f3 0f 1e fb          	endbr32 
801033cf:	55                   	push   %ebp
801033d0:	89 e5                	mov    %esp,%ebp
801033d2:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801033d5:	e8 8c ff ff ff       	call   80103366 <mycpu>
801033da:	2d a0 53 11 80       	sub    $0x801153a0,%eax
801033df:	c1 f8 04             	sar    $0x4,%eax
801033e2:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801033e8:	c9                   	leave  
801033e9:	c3                   	ret    

801033ea <myproc>:
myproc(void) {
801033ea:	f3 0f 1e fb          	endbr32 
801033ee:	55                   	push   %ebp
801033ef:	89 e5                	mov    %esp,%ebp
801033f1:	53                   	push   %ebx
801033f2:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801033f5:	e8 c2 09 00 00       	call   80103dbc <pushcli>
  c = mycpu();
801033fa:	e8 67 ff ff ff       	call   80103366 <mycpu>
  p = c->proc;
801033ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103405:	e8 f3 09 00 00       	call   80103dfd <popcli>
}
8010340a:	89 d8                	mov    %ebx,%eax
8010340c:	83 c4 04             	add    $0x4,%esp
8010340f:	5b                   	pop    %ebx
80103410:	5d                   	pop    %ebp
80103411:	c3                   	ret    

80103412 <userinit>:
{
80103412:	f3 0f 1e fb          	endbr32 
80103416:	55                   	push   %ebp
80103417:	89 e5                	mov    %esp,%ebp
80103419:	53                   	push   %ebx
8010341a:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010341d:	e8 0c fe ff ff       	call   8010322e <allocproc>
80103422:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103424:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103429:	e8 d0 30 00 00       	call   801064fe <setupkvm>
8010342e:	89 43 04             	mov    %eax,0x4(%ebx)
80103431:	85 c0                	test   %eax,%eax
80103433:	0f 84 b7 00 00 00    	je     801034f0 <userinit+0xde>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103439:	83 ec 04             	sub    $0x4,%esp
8010343c:	68 2c 00 00 00       	push   $0x2c
80103441:	68 60 b4 10 80       	push   $0x8010b460
80103446:	50                   	push   %eax
80103447:	e8 99 2d 00 00       	call   801061e5 <inituvm>
  p->sz = PGSIZE;
8010344c:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103452:	83 c4 0c             	add    $0xc,%esp
80103455:	6a 4c                	push   $0x4c
80103457:	6a 00                	push   $0x0
80103459:	ff 73 18             	pushl  0x18(%ebx)
8010345c:	e8 ee 0a 00 00       	call   80103f4f <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103461:	8b 43 18             	mov    0x18(%ebx),%eax
80103464:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010346a:	8b 43 18             	mov    0x18(%ebx),%eax
8010346d:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103473:	8b 43 18             	mov    0x18(%ebx),%eax
80103476:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010347a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010347e:	8b 43 18             	mov    0x18(%ebx),%eax
80103481:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103485:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103489:	8b 43 18             	mov    0x18(%ebx),%eax
8010348c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103493:	8b 43 18             	mov    0x18(%ebx),%eax
80103496:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010349d:	8b 43 18             	mov    0x18(%ebx),%eax
801034a0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801034a7:	83 c4 0c             	add    $0xc,%esp
801034aa:	6a 10                	push   $0x10
801034ac:	68 f0 7d 10 80       	push   $0x80107df0
801034b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
801034b4:	50                   	push   %eax
801034b5:	e8 2b 0c 00 00       	call   801040e5 <safestrcpy>
  p->cwd = namei("/");
801034ba:	c7 04 24 f9 7d 10 80 	movl   $0x80107df9,(%esp)
801034c1:	e8 1e e8 ff ff       	call   80101ce4 <namei>
801034c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801034c9:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
801034d0:	e8 c4 09 00 00       	call   80103e99 <acquire>
  p->state = RUNNABLE;
801034d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801034dc:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
801034e3:	e8 1c 0a 00 00       	call   80103f04 <release>
}
801034e8:	83 c4 10             	add    $0x10,%esp
801034eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034ee:	c9                   	leave  
801034ef:	c3                   	ret    
    panic("userinit: out of memory?");
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	68 d7 7d 10 80       	push   $0x80107dd7
801034f8:	e8 5b ce ff ff       	call   80100358 <panic>

801034fd <growproc>:
{
801034fd:	f3 0f 1e fb          	endbr32 
80103501:	55                   	push   %ebp
80103502:	89 e5                	mov    %esp,%ebp
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103509:	e8 dc fe ff ff       	call   801033ea <myproc>
8010350e:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103510:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103512:	85 f6                	test   %esi,%esi
80103514:	7f 1c                	jg     80103532 <growproc+0x35>
  } else if(n < 0){
80103516:	78 37                	js     8010354f <growproc+0x52>
  curproc->sz = sz;
80103518:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010351a:	83 ec 0c             	sub    $0xc,%esp
8010351d:	53                   	push   %ebx
8010351e:	e8 c0 2b 00 00       	call   801060e3 <switchuvm>
  return 0;
80103523:	83 c4 10             	add    $0x10,%esp
80103526:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010352b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010352e:	5b                   	pop    %ebx
8010352f:	5e                   	pop    %esi
80103530:	5d                   	pop    %ebp
80103531:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103532:	83 ec 04             	sub    $0x4,%esp
80103535:	01 c6                	add    %eax,%esi
80103537:	56                   	push   %esi
80103538:	50                   	push   %eax
80103539:	ff 73 04             	pushl  0x4(%ebx)
8010353c:	e8 54 2e 00 00       	call   80106395 <allocuvm>
80103541:	83 c4 10             	add    $0x10,%esp
80103544:	85 c0                	test   %eax,%eax
80103546:	75 d0                	jne    80103518 <growproc+0x1b>
      return -1;
80103548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010354d:	eb dc                	jmp    8010352b <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010354f:	83 ec 04             	sub    $0x4,%esp
80103552:	01 c6                	add    %eax,%esi
80103554:	56                   	push   %esi
80103555:	50                   	push   %eax
80103556:	ff 73 04             	pushl  0x4(%ebx)
80103559:	e8 a4 2d 00 00       	call   80106302 <deallocuvm>
8010355e:	83 c4 10             	add    $0x10,%esp
80103561:	85 c0                	test   %eax,%eax
80103563:	75 b3                	jne    80103518 <growproc+0x1b>
      return -1;
80103565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010356a:	eb bf                	jmp    8010352b <growproc+0x2e>

8010356c <fork>:
{
8010356c:	f3 0f 1e fb          	endbr32 
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103579:	e8 6c fe ff ff       	call   801033ea <myproc>
8010357e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103580:	e8 a9 fc ff ff       	call   8010322e <allocproc>
80103585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103588:	85 c0                	test   %eax,%eax
8010358a:	0f 84 e0 00 00 00    	je     80103670 <fork+0x104>
80103590:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103592:	83 ec 08             	sub    $0x8,%esp
80103595:	ff 33                	pushl  (%ebx)
80103597:	ff 73 04             	pushl  0x4(%ebx)
8010359a:	e8 1c 30 00 00       	call   801065bb <copyuvm>
8010359f:	89 47 04             	mov    %eax,0x4(%edi)
801035a2:	83 c4 10             	add    $0x10,%esp
801035a5:	85 c0                	test   %eax,%eax
801035a7:	74 2a                	je     801035d3 <fork+0x67>
  np->sz = curproc->sz;
801035a9:	8b 03                	mov    (%ebx),%eax
801035ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801035ae:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801035b0:	89 c8                	mov    %ecx,%eax
801035b2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801035b5:	8b 73 18             	mov    0x18(%ebx),%esi
801035b8:	8b 79 18             	mov    0x18(%ecx),%edi
801035bb:	b9 13 00 00 00       	mov    $0x13,%ecx
801035c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801035c2:	8b 40 18             	mov    0x18(%eax),%eax
801035c5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801035cc:	be 00 00 00 00       	mov    $0x0,%esi
801035d1:	eb 41                	jmp    80103614 <fork+0xa8>
    kfree(np->kstack);
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035d9:	ff 73 08             	pushl  0x8(%ebx)
801035dc:	e8 da ea ff ff       	call   801020bb <kfree>
    np->kstack = 0;
801035e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801035e8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035f7:	eb 6d                	jmp    80103666 <fork+0xfa>
      np->ofile[i] = filedup(curproc->ofile[i]);
801035f9:	83 ec 0c             	sub    $0xc,%esp
801035fc:	50                   	push   %eax
801035fd:	e8 36 d7 ff ff       	call   80100d38 <filedup>
80103602:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103605:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103609:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
8010360c:	83 c6 01             	add    $0x1,%esi
8010360f:	83 fe 10             	cmp    $0x10,%esi
80103612:	74 0a                	je     8010361e <fork+0xb2>
    if(curproc->ofile[i])
80103614:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103618:	85 c0                	test   %eax,%eax
8010361a:	75 dd                	jne    801035f9 <fork+0x8d>
8010361c:	eb ee                	jmp    8010360c <fork+0xa0>
  np->cwd = idup(curproc->cwd);
8010361e:	83 ec 0c             	sub    $0xc,%esp
80103621:	ff 73 68             	pushl  0x68(%ebx)
80103624:	e8 d4 de ff ff       	call   801014fd <idup>
80103629:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010362c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010362f:	83 c4 0c             	add    $0xc,%esp
80103632:	6a 10                	push   $0x10
80103634:	83 c3 6c             	add    $0x6c,%ebx
80103637:	53                   	push   %ebx
80103638:	8d 47 6c             	lea    0x6c(%edi),%eax
8010363b:	50                   	push   %eax
8010363c:	e8 a4 0a 00 00       	call   801040e5 <safestrcpy>
  pid = np->pid;
80103641:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103644:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
8010364b:	e8 49 08 00 00       	call   80103e99 <acquire>
  np->state = RUNNABLE;
80103650:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103657:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
8010365e:	e8 a1 08 00 00       	call   80103f04 <release>
  return pid;
80103663:	83 c4 10             	add    $0x10,%esp
}
80103666:	89 d8                	mov    %ebx,%eax
80103668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366b:	5b                   	pop    %ebx
8010366c:	5e                   	pop    %esi
8010366d:	5f                   	pop    %edi
8010366e:	5d                   	pop    %ebp
8010366f:	c3                   	ret    
    return -1;
80103670:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103675:	eb ef                	jmp    80103666 <fork+0xfa>

80103677 <scheduler>:
{
80103677:	f3 0f 1e fb          	endbr32 
8010367b:	55                   	push   %ebp
8010367c:	89 e5                	mov    %esp,%ebp
8010367e:	57                   	push   %edi
8010367f:	56                   	push   %esi
80103680:	53                   	push   %ebx
80103681:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103684:	e8 dd fc ff ff       	call   80103366 <mycpu>
80103689:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010368b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103692:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103695:	8d 78 04             	lea    0x4(%eax),%edi
80103698:	eb 5a                	jmp    801036f4 <scheduler+0x7d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010369a:	81 c3 84 00 00 00    	add    $0x84,%ebx
801036a0:	81 fb b4 61 11 80    	cmp    $0x801161b4,%ebx
801036a6:	74 3c                	je     801036e4 <scheduler+0x6d>
      if(p->state != RUNNABLE)
801036a8:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801036ac:	75 ec                	jne    8010369a <scheduler+0x23>
      c->proc = p;
801036ae:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801036b4:	83 ec 0c             	sub    $0xc,%esp
801036b7:	53                   	push   %ebx
801036b8:	e8 26 2a 00 00       	call   801060e3 <switchuvm>
      p->state = RUNNING;
801036bd:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801036c4:	83 c4 08             	add    $0x8,%esp
801036c7:	ff 73 1c             	pushl  0x1c(%ebx)
801036ca:	57                   	push   %edi
801036cb:	e8 75 0a 00 00       	call   80104145 <swtch>
      switchkvm();
801036d0:	e8 fc 29 00 00       	call   801060d1 <switchkvm>
      c->proc = 0;
801036d5:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801036dc:	00 00 00 
801036df:	83 c4 10             	add    $0x10,%esp
801036e2:	eb b6                	jmp    8010369a <scheduler+0x23>
    release(&ptable.lock);
801036e4:	83 ec 0c             	sub    $0xc,%esp
801036e7:	68 40 59 11 80       	push   $0x80115940
801036ec:	e8 13 08 00 00       	call   80103f04 <release>
    sti();
801036f1:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801036f4:	fb                   	sti    
    acquire(&ptable.lock);
801036f5:	83 ec 0c             	sub    $0xc,%esp
801036f8:	68 40 59 11 80       	push   $0x80115940
801036fd:	e8 97 07 00 00       	call   80103e99 <acquire>
80103702:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103705:	bb 74 59 11 80       	mov    $0x80115974,%ebx
8010370a:	eb 9c                	jmp    801036a8 <scheduler+0x31>

8010370c <sched>:
{
8010370c:	f3 0f 1e fb          	endbr32 
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
  struct proc *p = myproc();
80103715:	e8 d0 fc ff ff       	call   801033ea <myproc>
8010371a:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010371c:	83 ec 0c             	sub    $0xc,%esp
8010371f:	68 40 59 11 80       	push   $0x80115940
80103724:	e8 38 07 00 00       	call   80103e61 <holding>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	85 c0                	test   %eax,%eax
8010372e:	74 4f                	je     8010377f <sched+0x73>
  if(mycpu()->ncli != 1)
80103730:	e8 31 fc ff ff       	call   80103366 <mycpu>
80103735:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010373c:	75 4e                	jne    8010378c <sched+0x80>
  if(p->state == RUNNING)
8010373e:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103742:	74 55                	je     80103799 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103744:	9c                   	pushf  
80103745:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103746:	f6 c4 02             	test   $0x2,%ah
80103749:	75 5b                	jne    801037a6 <sched+0x9a>
  intena = mycpu()->intena;
8010374b:	e8 16 fc ff ff       	call   80103366 <mycpu>
80103750:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103756:	e8 0b fc ff ff       	call   80103366 <mycpu>
8010375b:	83 ec 08             	sub    $0x8,%esp
8010375e:	ff 70 04             	pushl  0x4(%eax)
80103761:	83 c3 1c             	add    $0x1c,%ebx
80103764:	53                   	push   %ebx
80103765:	e8 db 09 00 00       	call   80104145 <swtch>
  mycpu()->intena = intena;
8010376a:	e8 f7 fb ff ff       	call   80103366 <mycpu>
8010376f:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5d                   	pop    %ebp
8010377e:	c3                   	ret    
    panic("sched ptable.lock");
8010377f:	83 ec 0c             	sub    $0xc,%esp
80103782:	68 fb 7d 10 80       	push   $0x80107dfb
80103787:	e8 cc cb ff ff       	call   80100358 <panic>
    panic("sched locks");
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	68 0d 7e 10 80       	push   $0x80107e0d
80103794:	e8 bf cb ff ff       	call   80100358 <panic>
    panic("sched running");
80103799:	83 ec 0c             	sub    $0xc,%esp
8010379c:	68 19 7e 10 80       	push   $0x80107e19
801037a1:	e8 b2 cb ff ff       	call   80100358 <panic>
    panic("sched interruptible");
801037a6:	83 ec 0c             	sub    $0xc,%esp
801037a9:	68 27 7e 10 80       	push   $0x80107e27
801037ae:	e8 a5 cb ff ff       	call   80100358 <panic>

801037b3 <exit>:
{
801037b3:	f3 0f 1e fb          	endbr32 
801037b7:	55                   	push   %ebp
801037b8:	89 e5                	mov    %esp,%ebp
801037ba:	57                   	push   %edi
801037bb:	56                   	push   %esi
801037bc:	53                   	push   %ebx
801037bd:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801037c0:	e8 25 fc ff ff       	call   801033ea <myproc>
801037c5:	89 c6                	mov    %eax,%esi
  if(curproc == initproc)
801037c7:	8d 58 28             	lea    0x28(%eax),%ebx
801037ca:	8d 78 68             	lea    0x68(%eax),%edi
801037cd:	39 05 b8 b5 10 80    	cmp    %eax,0x8010b5b8
801037d3:	75 26                	jne    801037fb <exit+0x48>
    panic("init exiting");
801037d5:	83 ec 0c             	sub    $0xc,%esp
801037d8:	68 3b 7e 10 80       	push   $0x80107e3b
801037dd:	e8 76 cb ff ff       	call   80100358 <panic>
      fileclose(curproc->ofile[fd]);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	50                   	push   %eax
801037e6:	e8 96 d5 ff ff       	call   80100d81 <fileclose>
      curproc->ofile[fd] = 0;
801037eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801037f1:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801037f4:	83 c3 04             	add    $0x4,%ebx
801037f7:	39 fb                	cmp    %edi,%ebx
801037f9:	74 08                	je     80103803 <exit+0x50>
    if(curproc->ofile[fd]){
801037fb:	8b 03                	mov    (%ebx),%eax
801037fd:	85 c0                	test   %eax,%eax
801037ff:	75 e1                	jne    801037e2 <exit+0x2f>
80103801:	eb f1                	jmp    801037f4 <exit+0x41>
  begin_op();
80103803:	e8 78 f0 ff ff       	call   80102880 <begin_op>
  iput(curproc->cwd);
80103808:	83 ec 0c             	sub    $0xc,%esp
8010380b:	ff 76 68             	pushl  0x68(%esi)
8010380e:	e8 28 de ff ff       	call   8010163b <iput>
  end_op();
80103813:	e8 e7 f0 ff ff       	call   801028ff <end_op>
  curproc->cwd = 0;
80103818:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010381f:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
80103826:	e8 6e 06 00 00       	call   80103e99 <acquire>
  wakeup1(curproc->parent);
8010382b:	8b 46 14             	mov    0x14(%esi),%eax
8010382e:	e8 d1 f9 ff ff       	call   80103204 <wakeup1>
80103833:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103836:	bb 74 59 11 80       	mov    $0x80115974,%ebx
8010383b:	eb 13                	jmp    80103850 <exit+0x9d>
        wakeup1(initproc);
8010383d:	e8 c2 f9 ff ff       	call   80103204 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103842:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103848:	81 fb b4 61 11 80    	cmp    $0x801161b4,%ebx
8010384e:	74 15                	je     80103865 <exit+0xb2>
    if(p->parent == curproc){
80103850:	39 73 14             	cmp    %esi,0x14(%ebx)
80103853:	75 ed                	jne    80103842 <exit+0x8f>
      p->parent = initproc;
80103855:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
8010385a:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010385d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103861:	75 df                	jne    80103842 <exit+0x8f>
80103863:	eb d8                	jmp    8010383d <exit+0x8a>
  curproc->state = ZOMBIE;
80103865:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010386c:	e8 9b fe ff ff       	call   8010370c <sched>
  panic("zombie exit");
80103871:	83 ec 0c             	sub    $0xc,%esp
80103874:	68 48 7e 10 80       	push   $0x80107e48
80103879:	e8 da ca ff ff       	call   80100358 <panic>

8010387e <yield>:
{
8010387e:	f3 0f 1e fb          	endbr32 
80103882:	55                   	push   %ebp
80103883:	89 e5                	mov    %esp,%ebp
80103885:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103888:	68 40 59 11 80       	push   $0x80115940
8010388d:	e8 07 06 00 00       	call   80103e99 <acquire>
  myproc()->state = RUNNABLE;
80103892:	e8 53 fb ff ff       	call   801033ea <myproc>
80103897:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010389e:	e8 69 fe ff ff       	call   8010370c <sched>
  release(&ptable.lock);
801038a3:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
801038aa:	e8 55 06 00 00       	call   80103f04 <release>
}
801038af:	83 c4 10             	add    $0x10,%esp
801038b2:	c9                   	leave  
801038b3:	c3                   	ret    

801038b4 <sleep>:
{
801038b4:	f3 0f 1e fb          	endbr32 
801038b8:	55                   	push   %ebp
801038b9:	89 e5                	mov    %esp,%ebp
801038bb:	56                   	push   %esi
801038bc:	53                   	push   %ebx
801038bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801038c0:	e8 25 fb ff ff       	call   801033ea <myproc>
  if(p == 0)
801038c5:	85 c0                	test   %eax,%eax
801038c7:	74 5a                	je     80103923 <sleep+0x6f>
801038c9:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801038cb:	85 f6                	test   %esi,%esi
801038cd:	74 61                	je     80103930 <sleep+0x7c>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801038cf:	81 fe 40 59 11 80    	cmp    $0x80115940,%esi
801038d5:	74 66                	je     8010393d <sleep+0x89>
    acquire(&ptable.lock);  //DOC: sleeplock1
801038d7:	83 ec 0c             	sub    $0xc,%esp
801038da:	68 40 59 11 80       	push   $0x80115940
801038df:	e8 b5 05 00 00       	call   80103e99 <acquire>
    release(lk);
801038e4:	89 34 24             	mov    %esi,(%esp)
801038e7:	e8 18 06 00 00       	call   80103f04 <release>
  p->chan = chan;
801038ec:	8b 45 08             	mov    0x8(%ebp),%eax
801038ef:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801038f2:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801038f9:	e8 0e fe ff ff       	call   8010370c <sched>
  p->chan = 0;
801038fe:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103905:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
8010390c:	e8 f3 05 00 00       	call   80103f04 <release>
    acquire(lk);
80103911:	89 34 24             	mov    %esi,(%esp)
80103914:	e8 80 05 00 00       	call   80103e99 <acquire>
80103919:	83 c4 10             	add    $0x10,%esp
}
8010391c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010391f:	5b                   	pop    %ebx
80103920:	5e                   	pop    %esi
80103921:	5d                   	pop    %ebp
80103922:	c3                   	ret    
    panic("sleep");
80103923:	83 ec 0c             	sub    $0xc,%esp
80103926:	68 54 7e 10 80       	push   $0x80107e54
8010392b:	e8 28 ca ff ff       	call   80100358 <panic>
    panic("sleep without lk");
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	68 5a 7e 10 80       	push   $0x80107e5a
80103938:	e8 1b ca ff ff       	call   80100358 <panic>
  p->chan = chan;
8010393d:	8b 45 08             	mov    0x8(%ebp),%eax
80103940:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103943:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010394a:	e8 bd fd ff ff       	call   8010370c <sched>
  p->chan = 0;
8010394f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103956:	eb c4                	jmp    8010391c <sleep+0x68>

80103958 <wait>:
{
80103958:	f3 0f 1e fb          	endbr32 
8010395c:	55                   	push   %ebp
8010395d:	89 e5                	mov    %esp,%ebp
8010395f:	57                   	push   %edi
80103960:	56                   	push   %esi
80103961:	53                   	push   %ebx
80103962:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103965:	e8 80 fa ff ff       	call   801033ea <myproc>
8010396a:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	68 40 59 11 80       	push   $0x80115940
80103974:	e8 20 05 00 00       	call   80103e99 <acquire>
80103979:	83 c4 10             	add    $0x10,%esp
      havekids = 1;
8010397c:	bf 01 00 00 00       	mov    $0x1,%edi
    havekids = 0;
80103981:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103986:	bb 74 59 11 80       	mov    $0x80115974,%ebx
8010398b:	eb 5f                	jmp    801039ec <wait+0x94>
        pid = p->pid;
8010398d:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	ff 73 08             	pushl  0x8(%ebx)
80103996:	e8 20 e7 ff ff       	call   801020bb <kfree>
        p->kstack = 0;
8010399b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801039a2:	83 c4 04             	add    $0x4,%esp
801039a5:	ff 73 04             	pushl  0x4(%ebx)
801039a8:	e8 da 2a 00 00       	call   80106487 <freevm>
        p->pid = 0;
801039ad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801039b4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801039bb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801039bf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801039c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801039cd:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
801039d4:	e8 2b 05 00 00       	call   80103f04 <release>
        return pid;
801039d9:	83 c4 10             	add    $0x10,%esp
801039dc:	eb 3c                	jmp    80103a1a <wait+0xc2>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039de:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039e4:	81 fb b4 61 11 80    	cmp    $0x801161b4,%ebx
801039ea:	74 0f                	je     801039fb <wait+0xa3>
      if(p->parent != curproc)
801039ec:	39 73 14             	cmp    %esi,0x14(%ebx)
801039ef:	75 ed                	jne    801039de <wait+0x86>
      if(p->state == ZOMBIE){
801039f1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801039f5:	74 96                	je     8010398d <wait+0x35>
      havekids = 1;
801039f7:	89 f8                	mov    %edi,%eax
801039f9:	eb e3                	jmp    801039de <wait+0x86>
    if(!havekids || curproc->killed){
801039fb:	85 c0                	test   %eax,%eax
801039fd:	74 06                	je     80103a05 <wait+0xad>
801039ff:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103a03:	74 1f                	je     80103a24 <wait+0xcc>
      release(&ptable.lock);
80103a05:	83 ec 0c             	sub    $0xc,%esp
80103a08:	68 40 59 11 80       	push   $0x80115940
80103a0d:	e8 f2 04 00 00       	call   80103f04 <release>
      return -1;
80103a12:	83 c4 10             	add    $0x10,%esp
80103a15:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80103a1a:	89 f0                	mov    %esi,%eax
80103a1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a1f:	5b                   	pop    %ebx
80103a20:	5e                   	pop    %esi
80103a21:	5f                   	pop    %edi
80103a22:	5d                   	pop    %ebp
80103a23:	c3                   	ret    
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103a24:	83 ec 08             	sub    $0x8,%esp
80103a27:	68 40 59 11 80       	push   $0x80115940
80103a2c:	56                   	push   %esi
80103a2d:	e8 82 fe ff ff       	call   801038b4 <sleep>
    havekids = 0;
80103a32:	83 c4 10             	add    $0x10,%esp
80103a35:	e9 47 ff ff ff       	jmp    80103981 <wait+0x29>

80103a3a <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103a3a:	f3 0f 1e fb          	endbr32 
80103a3e:	55                   	push   %ebp
80103a3f:	89 e5                	mov    %esp,%ebp
80103a41:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103a44:	68 40 59 11 80       	push   $0x80115940
80103a49:	e8 4b 04 00 00       	call   80103e99 <acquire>
  wakeup1(chan);
80103a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a51:	e8 ae f7 ff ff       	call   80103204 <wakeup1>
  release(&ptable.lock);
80103a56:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
80103a5d:	e8 a2 04 00 00       	call   80103f04 <release>
}
80103a62:	83 c4 10             	add    $0x10,%esp
80103a65:	c9                   	leave  
80103a66:	c3                   	ret    

80103a67 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103a67:	f3 0f 1e fb          	endbr32 
80103a6b:	55                   	push   %ebp
80103a6c:	89 e5                	mov    %esp,%ebp
80103a6e:	53                   	push   %ebx
80103a6f:	83 ec 10             	sub    $0x10,%esp
80103a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103a75:	68 40 59 11 80       	push   $0x80115940
80103a7a:	e8 1a 04 00 00       	call   80103e99 <acquire>
80103a7f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a82:	b8 74 59 11 80       	mov    $0x80115974,%eax
    if(p->pid == pid){
80103a87:	39 58 10             	cmp    %ebx,0x10(%eax)
80103a8a:	74 26                	je     80103ab2 <kill+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a8c:	05 84 00 00 00       	add    $0x84,%eax
80103a91:	3d b4 61 11 80       	cmp    $0x801161b4,%eax
80103a96:	75 ef                	jne    80103a87 <kill+0x20>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103a98:	83 ec 0c             	sub    $0xc,%esp
80103a9b:	68 40 59 11 80       	push   $0x80115940
80103aa0:	e8 5f 04 00 00       	call   80103f04 <release>
  return -1;
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab0:	c9                   	leave  
80103ab1:	c3                   	ret    
      p->killed = 1;
80103ab2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103ab9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103abd:	74 17                	je     80103ad6 <kill+0x6f>
      release(&ptable.lock);
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	68 40 59 11 80       	push   $0x80115940
80103ac7:	e8 38 04 00 00       	call   80103f04 <release>
      return 0;
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	b8 00 00 00 00       	mov    $0x0,%eax
80103ad4:	eb d7                	jmp    80103aad <kill+0x46>
        p->state = RUNNABLE;
80103ad6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103add:	eb e0                	jmp    80103abf <kill+0x58>

80103adf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103adf:	f3 0f 1e fb          	endbr32 
80103ae3:	55                   	push   %ebp
80103ae4:	89 e5                	mov    %esp,%ebp
80103ae6:	57                   	push   %edi
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
80103ae9:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aec:	bb e0 59 11 80       	mov    $0x801159e0,%ebx
80103af1:	bf 20 62 11 80       	mov    $0x80116220,%edi
80103af6:	eb 32                	jmp    80103b2a <procdump+0x4b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %p", p->pid, state, p->name);
80103af8:	56                   	push   %esi
80103af9:	50                   	push   %eax
80103afa:	ff 76 a4             	pushl  -0x5c(%esi)
80103afd:	68 6f 7e 10 80       	push   $0x80107e6f
80103b02:	e8 25 cb ff ff       	call   8010062c <cprintf>
    //cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
80103b07:	83 c4 10             	add    $0x10,%esp
80103b0a:	83 7e a0 02          	cmpl   $0x2,-0x60(%esi)
80103b0e:	74 40                	je     80103b50 <procdump+0x71>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	68 1f 82 10 80       	push   $0x8010821f
80103b18:	e8 0f cb ff ff       	call   8010062c <cprintf>
80103b1d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b20:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103b26:	39 fb                	cmp    %edi,%ebx
80103b28:	74 65                	je     80103b8f <procdump+0xb0>
    if(p->state == UNUSED)
80103b2a:	89 de                	mov    %ebx,%esi
80103b2c:	8b 53 a0             	mov    -0x60(%ebx),%edx
80103b2f:	85 d2                	test   %edx,%edx
80103b31:	74 ed                	je     80103b20 <procdump+0x41>
      state = "???";
80103b33:	b8 6b 7e 10 80       	mov    $0x80107e6b,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b38:	83 fa 05             	cmp    $0x5,%edx
80103b3b:	77 bb                	ja     80103af8 <procdump+0x19>
80103b3d:	8b 04 95 fc 7e 10 80 	mov    -0x7fef8104(,%edx,4),%eax
80103b44:	85 c0                	test   %eax,%eax
      state = "???";
80103b46:	ba 6b 7e 10 80       	mov    $0x80107e6b,%edx
80103b4b:	0f 44 c2             	cmove  %edx,%eax
80103b4e:	eb a8                	jmp    80103af8 <procdump+0x19>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103b50:	83 ec 08             	sub    $0x8,%esp
80103b53:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103b56:	50                   	push   %eax
80103b57:	8b 46 b0             	mov    -0x50(%esi),%eax
80103b5a:	8b 40 0c             	mov    0xc(%eax),%eax
80103b5d:	83 c0 08             	add    $0x8,%eax
80103b60:	50                   	push   %eax
80103b61:	e8 f6 01 00 00       	call   80103d5c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b66:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103b69:	83 c4 10             	add    $0x10,%esp
80103b6c:	8b 06                	mov    (%esi),%eax
80103b6e:	85 c0                	test   %eax,%eax
80103b70:	74 9e                	je     80103b10 <procdump+0x31>
        cprintf(" %p", pc[i]);
80103b72:	83 ec 08             	sub    $0x8,%esp
80103b75:	50                   	push   %eax
80103b76:	68 77 7e 10 80       	push   $0x80107e77
80103b7b:	e8 ac ca ff ff       	call   8010062c <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b80:	83 c6 04             	add    $0x4,%esi
80103b83:	83 c4 10             	add    $0x10,%esp
80103b86:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103b89:	39 c6                	cmp    %eax,%esi
80103b8b:	75 df                	jne    80103b6c <procdump+0x8d>
80103b8d:	eb 81                	jmp    80103b10 <procdump+0x31>
  }
}
80103b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b92:	5b                   	pop    %ebx
80103b93:	5e                   	pop    %esi
80103b94:	5f                   	pop    %edi
80103b95:	5d                   	pop    %ebp
80103b96:	c3                   	ret    

80103b97 <ps>:

void
ps(void)
{
80103b97:	f3 0f 1e fb          	endbr32 
80103b9b:	55                   	push   %ebp
80103b9c:	89 e5                	mov    %esp,%ebp
80103b9e:	57                   	push   %edi
80103b9f:	56                   	push   %esi
80103ba0:	53                   	push   %ebx
80103ba1:	83 ec 18             	sub    $0x18,%esp
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state, *name;

	acquire(&ptable.lock);
80103ba4:	68 40 59 11 80       	push   $0x80115940
80103ba9:	e8 eb 02 00 00       	call   80103e99 <acquire>
80103bae:	83 c4 10             	add    $0x10,%esp

	for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb1:	bb 74 59 11 80       	mov    $0x80115974,%ebx
	{   
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
				state = states[p->state];
			else
				state = "???";
80103bb6:	bf 6b 7e 10 80       	mov    $0x80107e6b,%edi
80103bbb:	be 7b 7e 10 80       	mov    $0x80107e7b,%esi
80103bc0:	eb 2e                	jmp    80103bf0 <ps+0x59>

			if(p->state == UNUSED)
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80103bc7:	89 c8                	mov    %ecx,%eax
80103bc9:	0f 44 c6             	cmove  %esi,%eax
				name = "unknown";
			else
				name = p->name;

    	cprintf("%d %s %s %p\n", p->pid, state, name, p);
80103bcc:	83 ec 0c             	sub    $0xc,%esp
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	52                   	push   %edx
80103bd2:	ff 73 10             	pushl  0x10(%ebx)
80103bd5:	68 83 7e 10 80       	push   $0x80107e83
80103bda:	e8 4d ca ff ff       	call   8010062c <cprintf>
	for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bdf:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103be5:	83 c4 20             	add    $0x20,%esp
80103be8:	81 fb b4 61 11 80    	cmp    $0x801161b4,%ebx
80103bee:	74 1b                	je     80103c0b <ps+0x74>
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103bf0:	8b 43 0c             	mov    0xc(%ebx),%eax
				state = "???";
80103bf3:	ba 6b 7e 10 80       	mov    $0x80107e6b,%edx
    	if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103bf8:	83 f8 05             	cmp    $0x5,%eax
80103bfb:	77 c5                	ja     80103bc2 <ps+0x2b>
80103bfd:	8b 14 85 e4 7e 10 80 	mov    -0x7fef811c(,%eax,4),%edx
80103c04:	85 d2                	test   %edx,%edx
				state = "???";
80103c06:	0f 44 d7             	cmove  %edi,%edx
80103c09:	eb b7                	jmp    80103bc2 <ps+0x2b>

    }   
    release(&ptable.lock);
80103c0b:	83 ec 0c             	sub    $0xc,%esp
80103c0e:	68 40 59 11 80       	push   $0x80115940
80103c13:	e8 ec 02 00 00       	call   80103f04 <release>
    return;
80103c18:	83 c4 10             	add    $0x10,%esp
}
80103c1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c1e:	5b                   	pop    %ebx
80103c1f:	5e                   	pop    %esi
80103c20:	5f                   	pop    %edi
80103c21:	5d                   	pop    %ebp
80103c22:	c3                   	ret    

80103c23 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103c23:	f3 0f 1e fb          	endbr32 
80103c27:	55                   	push   %ebp
80103c28:	89 e5                	mov    %esp,%ebp
80103c2a:	53                   	push   %ebx
80103c2b:	83 ec 0c             	sub    $0xc,%esp
80103c2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103c31:	68 14 7f 10 80       	push   $0x80107f14
80103c36:	8d 43 04             	lea    0x4(%ebx),%eax
80103c39:	50                   	push   %eax
80103c3a:	e8 fe 00 00 00       	call   80103d3d <initlock>
  lk->name = name;
80103c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c42:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103c45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103c4b:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103c52:	83 c4 10             	add    $0x10,%esp
80103c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c58:	c9                   	leave  
80103c59:	c3                   	ret    

80103c5a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103c5a:	f3 0f 1e fb          	endbr32 
80103c5e:	55                   	push   %ebp
80103c5f:	89 e5                	mov    %esp,%ebp
80103c61:	56                   	push   %esi
80103c62:	53                   	push   %ebx
80103c63:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103c66:	8d 73 04             	lea    0x4(%ebx),%esi
80103c69:	83 ec 0c             	sub    $0xc,%esp
80103c6c:	56                   	push   %esi
80103c6d:	e8 27 02 00 00       	call   80103e99 <acquire>
  while (lk->locked) {
80103c72:	83 c4 10             	add    $0x10,%esp
80103c75:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c78:	74 12                	je     80103c8c <acquiresleep+0x32>
    sleep(lk, &lk->lk);
80103c7a:	83 ec 08             	sub    $0x8,%esp
80103c7d:	56                   	push   %esi
80103c7e:	53                   	push   %ebx
80103c7f:	e8 30 fc ff ff       	call   801038b4 <sleep>
  while (lk->locked) {
80103c84:	83 c4 10             	add    $0x10,%esp
80103c87:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c8a:	75 ee                	jne    80103c7a <acquiresleep+0x20>
  }
  lk->locked = 1;
80103c8c:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103c92:	e8 53 f7 ff ff       	call   801033ea <myproc>
80103c97:	8b 40 10             	mov    0x10(%eax),%eax
80103c9a:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103c9d:	83 ec 0c             	sub    $0xc,%esp
80103ca0:	56                   	push   %esi
80103ca1:	e8 5e 02 00 00       	call   80103f04 <release>
}
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cac:	5b                   	pop    %ebx
80103cad:	5e                   	pop    %esi
80103cae:	5d                   	pop    %ebp
80103caf:	c3                   	ret    

80103cb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	56                   	push   %esi
80103cb8:	53                   	push   %ebx
80103cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103cbc:	8d 73 04             	lea    0x4(%ebx),%esi
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	56                   	push   %esi
80103cc3:	e8 d1 01 00 00       	call   80103e99 <acquire>
  lk->locked = 0;
80103cc8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103cce:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103cd5:	89 1c 24             	mov    %ebx,(%esp)
80103cd8:	e8 5d fd ff ff       	call   80103a3a <wakeup>
  release(&lk->lk);
80103cdd:	89 34 24             	mov    %esi,(%esp)
80103ce0:	e8 1f 02 00 00       	call   80103f04 <release>
}
80103ce5:	83 c4 10             	add    $0x10,%esp
80103ce8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5d                   	pop    %ebp
80103cee:	c3                   	ret    

80103cef <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103cef:	f3 0f 1e fb          	endbr32 
80103cf3:	55                   	push   %ebp
80103cf4:	89 e5                	mov    %esp,%ebp
80103cf6:	57                   	push   %edi
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
80103cf9:	83 ec 18             	sub    $0x18,%esp
80103cfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103cff:	8d 73 04             	lea    0x4(%ebx),%esi
80103d02:	56                   	push   %esi
80103d03:	e8 91 01 00 00       	call   80103e99 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	bf 00 00 00 00       	mov    $0x0,%edi
80103d10:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d13:	75 13                	jne    80103d28 <holdingsleep+0x39>
  release(&lk->lk);
80103d15:	83 ec 0c             	sub    $0xc,%esp
80103d18:	56                   	push   %esi
80103d19:	e8 e6 01 00 00       	call   80103f04 <release>
  return r;
}
80103d1e:	89 f8                	mov    %edi,%eax
80103d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d23:	5b                   	pop    %ebx
80103d24:	5e                   	pop    %esi
80103d25:	5f                   	pop    %edi
80103d26:	5d                   	pop    %ebp
80103d27:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103d28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103d2b:	e8 ba f6 ff ff       	call   801033ea <myproc>
80103d30:	39 58 10             	cmp    %ebx,0x10(%eax)
80103d33:	0f 94 c0             	sete   %al
80103d36:	0f b6 c0             	movzbl %al,%eax
80103d39:	89 c7                	mov    %eax,%edi
80103d3b:	eb d8                	jmp    80103d15 <holdingsleep+0x26>

80103d3d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103d3d:	f3 0f 1e fb          	endbr32 
80103d41:	55                   	push   %ebp
80103d42:	89 e5                	mov    %esp,%ebp
80103d44:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103d47:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d4a:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103d53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103d5a:	5d                   	pop    %ebp
80103d5b:	c3                   	ret    

80103d5c <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103d5c:	f3 0f 1e fb          	endbr32 
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	8b 45 08             	mov    0x8(%ebp),%eax
80103d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103d6a:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103d70:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103d76:	77 2d                	ja     80103da5 <getcallerpcs+0x49>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103d78:	8b 50 fc             	mov    -0x4(%eax),%edx
80103d7b:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103d7d:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103d80:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103d85:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103d8b:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103d91:	77 17                	ja     80103daa <getcallerpcs+0x4e>
    pcs[i] = ebp[1];     // saved %eip
80103d93:	8b 5a 04             	mov    0x4(%edx),%ebx
80103d96:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103d99:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103d9b:	83 c0 01             	add    $0x1,%eax
80103d9e:	83 f8 0a             	cmp    $0xa,%eax
80103da1:	75 e2                	jne    80103d85 <getcallerpcs+0x29>
80103da3:	eb 14                	jmp    80103db9 <getcallerpcs+0x5d>
80103da5:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103daa:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103db1:	83 c0 01             	add    $0x1,%eax
80103db4:	83 f8 09             	cmp    $0x9,%eax
80103db7:	7e f1                	jle    80103daa <getcallerpcs+0x4e>
}
80103db9:	5b                   	pop    %ebx
80103dba:	5d                   	pop    %ebp
80103dbb:	c3                   	ret    

80103dbc <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103dbc:	f3 0f 1e fb          	endbr32 
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	53                   	push   %ebx
80103dc4:	83 ec 04             	sub    $0x4,%esp
80103dc7:	9c                   	pushf  
80103dc8:	5b                   	pop    %ebx
  asm volatile("cli");
80103dc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103dca:	e8 97 f5 ff ff       	call   80103366 <mycpu>
80103dcf:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103dd6:	74 12                	je     80103dea <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103dd8:	e8 89 f5 ff ff       	call   80103366 <mycpu>
80103ddd:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103de4:	83 c4 04             	add    $0x4,%esp
80103de7:	5b                   	pop    %ebx
80103de8:	5d                   	pop    %ebp
80103de9:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103dea:	e8 77 f5 ff ff       	call   80103366 <mycpu>
80103def:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103df5:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103dfb:	eb db                	jmp    80103dd8 <pushcli+0x1c>

80103dfd <popcli>:

void
popcli(void)
{
80103dfd:	f3 0f 1e fb          	endbr32 
80103e01:	55                   	push   %ebp
80103e02:	89 e5                	mov    %esp,%ebp
80103e04:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e07:	9c                   	pushf  
80103e08:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e09:	f6 c4 02             	test   $0x2,%ah
80103e0c:	75 28                	jne    80103e36 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103e0e:	e8 53 f5 ff ff       	call   80103366 <mycpu>
80103e13:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103e19:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103e1c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103e22:	85 d2                	test   %edx,%edx
80103e24:	78 1d                	js     80103e43 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103e26:	e8 3b f5 ff ff       	call   80103366 <mycpu>
80103e2b:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103e32:	74 1c                	je     80103e50 <popcli+0x53>
    sti();
}
80103e34:	c9                   	leave  
80103e35:	c3                   	ret    
    panic("popcli - interruptible");
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	68 1f 7f 10 80       	push   $0x80107f1f
80103e3e:	e8 15 c5 ff ff       	call   80100358 <panic>
    panic("popcli");
80103e43:	83 ec 0c             	sub    $0xc,%esp
80103e46:	68 36 7f 10 80       	push   $0x80107f36
80103e4b:	e8 08 c5 ff ff       	call   80100358 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103e50:	e8 11 f5 ff ff       	call   80103366 <mycpu>
80103e55:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103e5c:	74 d6                	je     80103e34 <popcli+0x37>
  asm volatile("sti");
80103e5e:	fb                   	sti    
}
80103e5f:	eb d3                	jmp    80103e34 <popcli+0x37>

80103e61 <holding>:
{
80103e61:	f3 0f 1e fb          	endbr32 
80103e65:	55                   	push   %ebp
80103e66:	89 e5                	mov    %esp,%ebp
80103e68:	56                   	push   %esi
80103e69:	53                   	push   %ebx
80103e6a:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e6d:	e8 4a ff ff ff       	call   80103dbc <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103e72:	bb 00 00 00 00       	mov    $0x0,%ebx
80103e77:	83 3e 00             	cmpl   $0x0,(%esi)
80103e7a:	75 0b                	jne    80103e87 <holding+0x26>
  popcli();
80103e7c:	e8 7c ff ff ff       	call   80103dfd <popcli>
}
80103e81:	89 d8                	mov    %ebx,%eax
80103e83:	5b                   	pop    %ebx
80103e84:	5e                   	pop    %esi
80103e85:	5d                   	pop    %ebp
80103e86:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103e87:	8b 5e 08             	mov    0x8(%esi),%ebx
80103e8a:	e8 d7 f4 ff ff       	call   80103366 <mycpu>
80103e8f:	39 c3                	cmp    %eax,%ebx
80103e91:	0f 94 c3             	sete   %bl
80103e94:	0f b6 db             	movzbl %bl,%ebx
80103e97:	eb e3                	jmp    80103e7c <holding+0x1b>

80103e99 <acquire>:
{
80103e99:	f3 0f 1e fb          	endbr32 
80103e9d:	55                   	push   %ebp
80103e9e:	89 e5                	mov    %esp,%ebp
80103ea0:	53                   	push   %ebx
80103ea1:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103ea4:	e8 13 ff ff ff       	call   80103dbc <pushcli>
  if(holding(lk))
80103ea9:	83 ec 0c             	sub    $0xc,%esp
80103eac:	ff 75 08             	pushl  0x8(%ebp)
80103eaf:	e8 ad ff ff ff       	call   80103e61 <holding>
80103eb4:	83 c4 10             	add    $0x10,%esp
80103eb7:	85 c0                	test   %eax,%eax
80103eb9:	75 3c                	jne    80103ef7 <acquire+0x5e>
  asm volatile("lock; xchgl %0, %1" :
80103ebb:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103ec0:	8b 55 08             	mov    0x8(%ebp),%edx
80103ec3:	89 c8                	mov    %ecx,%eax
80103ec5:	f0 87 02             	lock xchg %eax,(%edx)
80103ec8:	85 c0                	test   %eax,%eax
80103eca:	75 f4                	jne    80103ec0 <acquire+0x27>
  __sync_synchronize();
80103ecc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ed4:	e8 8d f4 ff ff       	call   80103366 <mycpu>
80103ed9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103edc:	83 ec 08             	sub    $0x8,%esp
80103edf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee2:	83 c0 0c             	add    $0xc,%eax
80103ee5:	50                   	push   %eax
80103ee6:	8d 45 08             	lea    0x8(%ebp),%eax
80103ee9:	50                   	push   %eax
80103eea:	e8 6d fe ff ff       	call   80103d5c <getcallerpcs>
}
80103eef:	83 c4 10             	add    $0x10,%esp
80103ef2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef5:	c9                   	leave  
80103ef6:	c3                   	ret    
    panic("acquire");
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	68 3d 7f 10 80       	push   $0x80107f3d
80103eff:	e8 54 c4 ff ff       	call   80100358 <panic>

80103f04 <release>:
{
80103f04:	f3 0f 1e fb          	endbr32 
80103f08:	55                   	push   %ebp
80103f09:	89 e5                	mov    %esp,%ebp
80103f0b:	53                   	push   %ebx
80103f0c:	83 ec 10             	sub    $0x10,%esp
80103f0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103f12:	53                   	push   %ebx
80103f13:	e8 49 ff ff ff       	call   80103e61 <holding>
80103f18:	83 c4 10             	add    $0x10,%esp
80103f1b:	85 c0                	test   %eax,%eax
80103f1d:	74 23                	je     80103f42 <release+0x3e>
  lk->pcs[0] = 0;
80103f1f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103f26:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103f2d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103f32:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103f38:	e8 c0 fe ff ff       	call   80103dfd <popcli>
}
80103f3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f40:	c9                   	leave  
80103f41:	c3                   	ret    
    panic("release");
80103f42:	83 ec 0c             	sub    $0xc,%esp
80103f45:	68 45 7f 10 80       	push   $0x80107f45
80103f4a:	e8 09 c4 ff ff       	call   80100358 <panic>

80103f4f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103f4f:	f3 0f 1e fb          	endbr32 
80103f53:	55                   	push   %ebp
80103f54:	89 e5                	mov    %esp,%ebp
80103f56:	57                   	push   %edi
80103f57:	53                   	push   %ebx
80103f58:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103f61:	89 d7                	mov    %edx,%edi
80103f63:	09 cf                	or     %ecx,%edi
80103f65:	f7 c7 03 00 00 00    	test   $0x3,%edi
80103f6b:	75 1e                	jne    80103f8b <memset+0x3c>
    c &= 0xFF;
80103f6d:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103f70:	c1 e9 02             	shr    $0x2,%ecx
80103f73:	c1 e0 18             	shl    $0x18,%eax
80103f76:	89 fb                	mov    %edi,%ebx
80103f78:	c1 e3 10             	shl    $0x10,%ebx
80103f7b:	09 d8                	or     %ebx,%eax
80103f7d:	09 f8                	or     %edi,%eax
80103f7f:	c1 e7 08             	shl    $0x8,%edi
80103f82:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103f84:	89 d7                	mov    %edx,%edi
80103f86:	fc                   	cld    
80103f87:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103f89:	eb 05                	jmp    80103f90 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103f8b:	89 d7                	mov    %edx,%edi
80103f8d:	fc                   	cld    
80103f8e:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103f90:	89 d0                	mov    %edx,%eax
80103f92:	5b                   	pop    %ebx
80103f93:	5f                   	pop    %edi
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    

80103f96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103f96:	f3 0f 1e fb          	endbr32 
80103f9a:	55                   	push   %ebp
80103f9b:	89 e5                	mov    %esp,%ebp
80103f9d:	56                   	push   %esi
80103f9e:	53                   	push   %ebx
80103f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fa5:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103fa8:	85 f6                	test   %esi,%esi
80103faa:	74 29                	je     80103fd5 <memcmp+0x3f>
80103fac:	01 c6                	add    %eax,%esi
    if(*s1 != *s2)
80103fae:	0f b6 08             	movzbl (%eax),%ecx
80103fb1:	0f b6 1a             	movzbl (%edx),%ebx
80103fb4:	38 d9                	cmp    %bl,%cl
80103fb6:	75 11                	jne    80103fc9 <memcmp+0x33>
      return *s1 - *s2;
    s1++, s2++;
80103fb8:	83 c0 01             	add    $0x1,%eax
80103fbb:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103fbe:	39 c6                	cmp    %eax,%esi
80103fc0:	75 ec                	jne    80103fae <memcmp+0x18>
  }

  return 0;
80103fc2:	b8 00 00 00 00       	mov    $0x0,%eax
80103fc7:	eb 08                	jmp    80103fd1 <memcmp+0x3b>
      return *s1 - *s2;
80103fc9:	0f b6 c1             	movzbl %cl,%eax
80103fcc:	0f b6 db             	movzbl %bl,%ebx
80103fcf:	29 d8                	sub    %ebx,%eax
}
80103fd1:	5b                   	pop    %ebx
80103fd2:	5e                   	pop    %esi
80103fd3:	5d                   	pop    %ebp
80103fd4:	c3                   	ret    
  return 0;
80103fd5:	b8 00 00 00 00       	mov    $0x0,%eax
80103fda:	eb f5                	jmp    80103fd1 <memcmp+0x3b>

80103fdc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103fdc:	f3 0f 1e fb          	endbr32 
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	8b 75 08             	mov    0x8(%ebp),%esi
80103fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103feb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103fee:	39 f0                	cmp    %esi,%eax
80103ff0:	72 20                	jb     80104012 <memmove+0x36>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80103ff2:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80103ff5:	89 f2                	mov    %esi,%edx
80103ff7:	85 c9                	test   %ecx,%ecx
80103ff9:	74 11                	je     8010400c <memmove+0x30>
      *d++ = *s++;
80103ffb:	83 c0 01             	add    $0x1,%eax
80103ffe:	83 c2 01             	add    $0x1,%edx
80104001:	0f b6 48 ff          	movzbl -0x1(%eax),%ecx
80104005:	88 4a ff             	mov    %cl,-0x1(%edx)
    while(n-- > 0)
80104008:	39 d8                	cmp    %ebx,%eax
8010400a:	75 ef                	jne    80103ffb <memmove+0x1f>

  return dst;
}
8010400c:	89 f0                	mov    %esi,%eax
8010400e:	5b                   	pop    %ebx
8010400f:	5e                   	pop    %esi
80104010:	5d                   	pop    %ebp
80104011:	c3                   	ret    
  if(s < d && s + n > d){
80104012:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80104015:	39 d6                	cmp    %edx,%esi
80104017:	73 d9                	jae    80103ff2 <memmove+0x16>
    while(n-- > 0)
80104019:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010401c:	85 c9                	test   %ecx,%ecx
8010401e:	74 ec                	je     8010400c <memmove+0x30>
      *--d = *--s;
80104020:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80104024:	88 0c 16             	mov    %cl,(%esi,%edx,1)
    while(n-- > 0)
80104027:	83 ea 01             	sub    $0x1,%edx
8010402a:	83 fa ff             	cmp    $0xffffffff,%edx
8010402d:	75 f1                	jne    80104020 <memmove+0x44>
8010402f:	eb db                	jmp    8010400c <memmove+0x30>

80104031 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104031:	f3 0f 1e fb          	endbr32 
80104035:	55                   	push   %ebp
80104036:	89 e5                	mov    %esp,%ebp
80104038:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010403b:	ff 75 10             	pushl  0x10(%ebp)
8010403e:	ff 75 0c             	pushl  0xc(%ebp)
80104041:	ff 75 08             	pushl  0x8(%ebp)
80104044:	e8 93 ff ff ff       	call   80103fdc <memmove>
}
80104049:	c9                   	leave  
8010404a:	c3                   	ret    

8010404b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010404b:	f3 0f 1e fb          	endbr32 
8010404f:	55                   	push   %ebp
80104050:	89 e5                	mov    %esp,%ebp
80104052:	53                   	push   %ebx
80104053:	8b 55 08             	mov    0x8(%ebp),%edx
80104056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104059:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010405c:	85 c0                	test   %eax,%eax
8010405e:	74 29                	je     80104089 <strncmp+0x3e>
80104060:	0f b6 1a             	movzbl (%edx),%ebx
80104063:	84 db                	test   %bl,%bl
80104065:	74 16                	je     8010407d <strncmp+0x32>
80104067:	3a 19                	cmp    (%ecx),%bl
80104069:	75 12                	jne    8010407d <strncmp+0x32>
    n--, p++, q++;
8010406b:	83 c2 01             	add    $0x1,%edx
8010406e:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104071:	83 e8 01             	sub    $0x1,%eax
80104074:	75 ea                	jne    80104060 <strncmp+0x15>
  if(n == 0)
    return 0;
80104076:	b8 00 00 00 00       	mov    $0x0,%eax
8010407b:	eb 0c                	jmp    80104089 <strncmp+0x3e>
  if(n == 0)
8010407d:	85 c0                	test   %eax,%eax
8010407f:	74 0b                	je     8010408c <strncmp+0x41>
  return (uchar)*p - (uchar)*q;
80104081:	0f b6 02             	movzbl (%edx),%eax
80104084:	0f b6 11             	movzbl (%ecx),%edx
80104087:	29 d0                	sub    %edx,%eax
}
80104089:	5b                   	pop    %ebx
8010408a:	5d                   	pop    %ebp
8010408b:	c3                   	ret    
    return 0;
8010408c:	b8 00 00 00 00       	mov    $0x0,%eax
80104091:	eb f6                	jmp    80104089 <strncmp+0x3e>

80104093 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104093:	f3 0f 1e fb          	endbr32 
80104097:	55                   	push   %ebp
80104098:	89 e5                	mov    %esp,%ebp
8010409a:	57                   	push   %edi
8010409b:	56                   	push   %esi
8010409c:	53                   	push   %ebx
8010409d:	8b 75 08             	mov    0x8(%ebp),%esi
801040a0:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801040a3:	89 f2                	mov    %esi,%edx
801040a5:	89 c3                	mov    %eax,%ebx
801040a7:	83 e8 01             	sub    $0x1,%eax
801040aa:	85 db                	test   %ebx,%ebx
801040ac:	7e 17                	jle    801040c5 <strncpy+0x32>
801040ae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801040b2:	83 c2 01             	add    $0x1,%edx
801040b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
801040b8:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801040bc:	89 f9                	mov    %edi,%ecx
801040be:	88 4a ff             	mov    %cl,-0x1(%edx)
801040c1:	84 c9                	test   %cl,%cl
801040c3:	75 e0                	jne    801040a5 <strncpy+0x12>
    ;
  while(n-- > 0)
801040c5:	89 d1                	mov    %edx,%ecx
801040c7:	85 c0                	test   %eax,%eax
801040c9:	7e 13                	jle    801040de <strncpy+0x4b>
    *s++ = 0;
801040cb:	83 c1 01             	add    $0x1,%ecx
801040ce:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801040d2:	89 c8                	mov    %ecx,%eax
801040d4:	f7 d0                	not    %eax
801040d6:	01 d8                	add    %ebx,%eax
801040d8:	01 d0                	add    %edx,%eax
801040da:	85 c0                	test   %eax,%eax
801040dc:	7f ed                	jg     801040cb <strncpy+0x38>
  return os;
}
801040de:	89 f0                	mov    %esi,%eax
801040e0:	5b                   	pop    %ebx
801040e1:	5e                   	pop    %esi
801040e2:	5f                   	pop    %edi
801040e3:	5d                   	pop    %ebp
801040e4:	c3                   	ret    

801040e5 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801040e5:	f3 0f 1e fb          	endbr32 
801040e9:	55                   	push   %ebp
801040ea:	89 e5                	mov    %esp,%ebp
801040ec:	56                   	push   %esi
801040ed:	53                   	push   %ebx
801040ee:	8b 75 08             	mov    0x8(%ebp),%esi
801040f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f4:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801040f7:	85 d2                	test   %edx,%edx
801040f9:	7e 1e                	jle    80104119 <safestrcpy+0x34>
801040fb:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801040ff:	89 f2                	mov    %esi,%edx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104101:	39 d8                	cmp    %ebx,%eax
80104103:	74 11                	je     80104116 <safestrcpy+0x31>
80104105:	83 c0 01             	add    $0x1,%eax
80104108:	83 c2 01             	add    $0x1,%edx
8010410b:	0f b6 48 ff          	movzbl -0x1(%eax),%ecx
8010410f:	88 4a ff             	mov    %cl,-0x1(%edx)
80104112:	84 c9                	test   %cl,%cl
80104114:	75 eb                	jne    80104101 <safestrcpy+0x1c>
    ;
  *s = 0;
80104116:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104119:	89 f0                	mov    %esi,%eax
8010411b:	5b                   	pop    %ebx
8010411c:	5e                   	pop    %esi
8010411d:	5d                   	pop    %ebp
8010411e:	c3                   	ret    

8010411f <strlen>:

int
strlen(const char *s)
{
8010411f:	f3 0f 1e fb          	endbr32 
80104123:	55                   	push   %ebp
80104124:	89 e5                	mov    %esp,%ebp
80104126:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104129:	80 3a 00             	cmpb   $0x0,(%edx)
8010412c:	74 10                	je     8010413e <strlen+0x1f>
8010412e:	b8 00 00 00 00       	mov    $0x0,%eax
80104133:	83 c0 01             	add    $0x1,%eax
80104136:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010413a:	75 f7                	jne    80104133 <strlen+0x14>
    ;
  return n;
}
8010413c:	5d                   	pop    %ebp
8010413d:	c3                   	ret    
  for(n = 0; s[n]; n++)
8010413e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80104143:	eb f7                	jmp    8010413c <strlen+0x1d>

80104145 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104145:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104149:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010414d:	55                   	push   %ebp
  pushl %ebx
8010414e:	53                   	push   %ebx
  pushl %esi
8010414f:	56                   	push   %esi
  pushl %edi
80104150:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104151:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104153:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104155:	5f                   	pop    %edi
  popl %esi
80104156:	5e                   	pop    %esi
  popl %ebx
80104157:	5b                   	pop    %ebx
  popl %ebp
80104158:	5d                   	pop    %ebp
  ret
80104159:	c3                   	ret    

8010415a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010415a:	f3 0f 1e fb          	endbr32 
8010415e:	55                   	push   %ebp
8010415f:	89 e5                	mov    %esp,%ebp
80104161:	53                   	push   %ebx
80104162:	83 ec 04             	sub    $0x4,%esp
80104165:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104168:	e8 7d f2 ff ff       	call   801033ea <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010416d:	8b 00                	mov    (%eax),%eax
8010416f:	39 d8                	cmp    %ebx,%eax
80104171:	76 19                	jbe    8010418c <fetchint+0x32>
80104173:	8d 53 04             	lea    0x4(%ebx),%edx
80104176:	39 d0                	cmp    %edx,%eax
80104178:	72 19                	jb     80104193 <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
8010417a:	8b 13                	mov    (%ebx),%edx
8010417c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010417f:	89 10                	mov    %edx,(%eax)
  return 0;
80104181:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104186:	83 c4 04             	add    $0x4,%esp
80104189:	5b                   	pop    %ebx
8010418a:	5d                   	pop    %ebp
8010418b:	c3                   	ret    
    return -1;
8010418c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104191:	eb f3                	jmp    80104186 <fetchint+0x2c>
80104193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104198:	eb ec                	jmp    80104186 <fetchint+0x2c>

8010419a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010419a:	f3 0f 1e fb          	endbr32 
8010419e:	55                   	push   %ebp
8010419f:	89 e5                	mov    %esp,%ebp
801041a1:	53                   	push   %ebx
801041a2:	83 ec 04             	sub    $0x4,%esp
801041a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801041a8:	e8 3d f2 ff ff       	call   801033ea <myproc>

  if(addr >= curproc->sz)
801041ad:	39 18                	cmp    %ebx,(%eax)
801041af:	76 28                	jbe    801041d9 <fetchstr+0x3f>
    return -1;
  *pp = (char*)addr;
801041b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801041b4:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801041b6:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801041b8:	39 d3                	cmp    %edx,%ebx
801041ba:	73 24                	jae    801041e0 <fetchstr+0x46>
801041bc:	89 d8                	mov    %ebx,%eax
    if(*s == 0)
801041be:	80 38 00             	cmpb   $0x0,(%eax)
801041c1:	74 0e                	je     801041d1 <fetchstr+0x37>
  for(s = *pp; s < ep; s++){
801041c3:	83 c0 01             	add    $0x1,%eax
801041c6:	39 c2                	cmp    %eax,%edx
801041c8:	77 f4                	ja     801041be <fetchstr+0x24>
      return s - *pp;
  }
  return -1;
801041ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cf:	eb 02                	jmp    801041d3 <fetchstr+0x39>
      return s - *pp;
801041d1:	29 d8                	sub    %ebx,%eax
}
801041d3:	83 c4 04             	add    $0x4,%esp
801041d6:	5b                   	pop    %ebx
801041d7:	5d                   	pop    %ebp
801041d8:	c3                   	ret    
    return -1;
801041d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041de:	eb f3                	jmp    801041d3 <fetchstr+0x39>
  return -1;
801041e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041e5:	eb ec                	jmp    801041d3 <fetchstr+0x39>

801041e7 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801041e7:	f3 0f 1e fb          	endbr32 
801041eb:	55                   	push   %ebp
801041ec:	89 e5                	mov    %esp,%ebp
801041ee:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801041f1:	e8 f4 f1 ff ff       	call   801033ea <myproc>
801041f6:	83 ec 08             	sub    $0x8,%esp
801041f9:	ff 75 0c             	pushl  0xc(%ebp)
801041fc:	8b 40 18             	mov    0x18(%eax),%eax
801041ff:	8b 40 44             	mov    0x44(%eax),%eax
80104202:	8b 55 08             	mov    0x8(%ebp),%edx
80104205:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
80104209:	50                   	push   %eax
8010420a:	e8 4b ff ff ff       	call   8010415a <fetchint>
}
8010420f:	c9                   	leave  
80104210:	c3                   	ret    

80104211 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104211:	f3 0f 1e fb          	endbr32 
80104215:	55                   	push   %ebp
80104216:	89 e5                	mov    %esp,%ebp
80104218:	56                   	push   %esi
80104219:	53                   	push   %ebx
8010421a:	83 ec 10             	sub    $0x10,%esp
8010421d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104220:	e8 c5 f1 ff ff       	call   801033ea <myproc>
80104225:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104227:	83 ec 08             	sub    $0x8,%esp
8010422a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010422d:	50                   	push   %eax
8010422e:	ff 75 08             	pushl  0x8(%ebp)
80104231:	e8 b1 ff ff ff       	call   801041e7 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104236:	83 c4 10             	add    $0x10,%esp
80104239:	85 db                	test   %ebx,%ebx
8010423b:	78 24                	js     80104261 <argptr+0x50>
8010423d:	85 c0                	test   %eax,%eax
8010423f:	78 20                	js     80104261 <argptr+0x50>
80104241:	8b 16                	mov    (%esi),%edx
80104243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104246:	39 c2                	cmp    %eax,%edx
80104248:	76 1e                	jbe    80104268 <argptr+0x57>
8010424a:	01 c3                	add    %eax,%ebx
8010424c:	39 da                	cmp    %ebx,%edx
8010424e:	72 1f                	jb     8010426f <argptr+0x5e>
    return -1;
  *pp = (char*)i;
80104250:	8b 55 0c             	mov    0xc(%ebp),%edx
80104253:	89 02                	mov    %eax,(%edx)
  return 0;
80104255:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010425a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010425d:	5b                   	pop    %ebx
8010425e:	5e                   	pop    %esi
8010425f:	5d                   	pop    %ebp
80104260:	c3                   	ret    
    return -1;
80104261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104266:	eb f2                	jmp    8010425a <argptr+0x49>
80104268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010426d:	eb eb                	jmp    8010425a <argptr+0x49>
8010426f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104274:	eb e4                	jmp    8010425a <argptr+0x49>

80104276 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104276:	f3 0f 1e fb          	endbr32 
8010427a:	55                   	push   %ebp
8010427b:	89 e5                	mov    %esp,%ebp
8010427d:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104280:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104283:	50                   	push   %eax
80104284:	ff 75 08             	pushl  0x8(%ebp)
80104287:	e8 5b ff ff ff       	call   801041e7 <argint>
8010428c:	83 c4 10             	add    $0x10,%esp
8010428f:	85 c0                	test   %eax,%eax
80104291:	78 13                	js     801042a6 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104293:	83 ec 08             	sub    $0x8,%esp
80104296:	ff 75 0c             	pushl  0xc(%ebp)
80104299:	ff 75 f4             	pushl  -0xc(%ebp)
8010429c:	e8 f9 fe ff ff       	call   8010419a <fetchstr>
801042a1:	83 c4 10             	add    $0x10,%esp
}
801042a4:	c9                   	leave  
801042a5:	c3                   	ret    
    return -1;
801042a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ab:	eb f7                	jmp    801042a4 <argstr+0x2e>

801042ad <syscall>:
[SYS_ps]		sys_ps,
};

void
syscall(void)
{
801042ad:	f3 0f 1e fb          	endbr32 
801042b1:	55                   	push   %ebp
801042b2:	89 e5                	mov    %esp,%ebp
801042b4:	53                   	push   %ebx
801042b5:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801042b8:	e8 2d f1 ff ff       	call   801033ea <myproc>
801042bd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801042bf:	8b 40 18             	mov    0x18(%eax),%eax
801042c2:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801042c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801042c8:	83 fa 16             	cmp    $0x16,%edx
801042cb:	77 17                	ja     801042e4 <syscall+0x37>
801042cd:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
801042d4:	85 d2                	test   %edx,%edx
801042d6:	74 0c                	je     801042e4 <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
801042d8:	ff d2                	call   *%edx
801042da:	89 c2                	mov    %eax,%edx
801042dc:	8b 43 18             	mov    0x18(%ebx),%eax
801042df:	89 50 1c             	mov    %edx,0x1c(%eax)
801042e2:	eb 1f                	jmp    80104303 <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801042e4:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801042e5:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801042e8:	50                   	push   %eax
801042e9:	ff 73 10             	pushl  0x10(%ebx)
801042ec:	68 4d 7f 10 80       	push   $0x80107f4d
801042f1:	e8 36 c3 ff ff       	call   8010062c <cprintf>
    curproc->tf->eax = -1;
801042f6:	8b 43 18             	mov    0x18(%ebx),%eax
801042f9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104300:	83 c4 10             	add    $0x10,%esp
  }
}
80104303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104306:	c9                   	leave  
80104307:	c3                   	ret    

80104308 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104308:	55                   	push   %ebp
80104309:	89 e5                	mov    %esp,%ebp
8010430b:	56                   	push   %esi
8010430c:	53                   	push   %ebx
8010430d:	83 ec 18             	sub    $0x18,%esp
80104310:	89 d6                	mov    %edx,%esi
80104312:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104314:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104317:	52                   	push   %edx
80104318:	50                   	push   %eax
80104319:	e8 c9 fe ff ff       	call   801041e7 <argint>
8010431e:	83 c4 10             	add    $0x10,%esp
80104321:	85 c0                	test   %eax,%eax
80104323:	78 30                	js     80104355 <argfd+0x4d>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104325:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104329:	77 31                	ja     8010435c <argfd+0x54>
8010432b:	e8 ba f0 ff ff       	call   801033ea <myproc>
80104330:	89 c2                	mov    %eax,%edx
80104332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104335:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104339:	85 d2                	test   %edx,%edx
8010433b:	74 26                	je     80104363 <argfd+0x5b>
    return -1;
  if(pfd)
8010433d:	85 f6                	test   %esi,%esi
8010433f:	74 02                	je     80104343 <argfd+0x3b>
    *pfd = fd;
80104341:	89 06                	mov    %eax,(%esi)
  if(pf)
    *pf = f;
  return 0;
80104343:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
80104348:	85 db                	test   %ebx,%ebx
8010434a:	74 02                	je     8010434e <argfd+0x46>
    *pf = f;
8010434c:	89 13                	mov    %edx,(%ebx)
}
8010434e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104351:	5b                   	pop    %ebx
80104352:	5e                   	pop    %esi
80104353:	5d                   	pop    %ebp
80104354:	c3                   	ret    
    return -1;
80104355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435a:	eb f2                	jmp    8010434e <argfd+0x46>
    return -1;
8010435c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104361:	eb eb                	jmp    8010434e <argfd+0x46>
80104363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104368:	eb e4                	jmp    8010434e <argfd+0x46>

8010436a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010436a:	55                   	push   %ebp
8010436b:	89 e5                	mov    %esp,%ebp
8010436d:	53                   	push   %ebx
8010436e:	83 ec 04             	sub    $0x4,%esp
80104371:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104373:	e8 72 f0 ff ff       	call   801033ea <myproc>
80104378:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010437a:	b8 00 00 00 00       	mov    $0x0,%eax
    if(curproc->ofile[fd] == 0){
8010437f:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104384:	74 13                	je     80104399 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104386:	83 c0 01             	add    $0x1,%eax
80104389:	83 f8 10             	cmp    $0x10,%eax
8010438c:	75 f1                	jne    8010437f <fdalloc+0x15>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010438e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104393:	83 c4 04             	add    $0x4,%esp
80104396:	5b                   	pop    %ebx
80104397:	5d                   	pop    %ebp
80104398:	c3                   	ret    
      curproc->ofile[fd] = f;
80104399:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
8010439d:	eb f4                	jmp    80104393 <fdalloc+0x29>

8010439f <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010439f:	55                   	push   %ebp
801043a0:	89 e5                	mov    %esp,%ebp
801043a2:	57                   	push   %edi
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	83 ec 34             	sub    $0x34,%esp
801043a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801043ab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801043ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801043b1:	8d 55 da             	lea    -0x26(%ebp),%edx
801043b4:	52                   	push   %edx
801043b5:	50                   	push   %eax
801043b6:	e8 45 d9 ff ff       	call   80101d00 <nameiparent>
801043bb:	89 c6                	mov    %eax,%esi
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	85 c0                	test   %eax,%eax
801043c2:	0f 84 2d 01 00 00    	je     801044f5 <create+0x156>
    return 0;
  ilock(dp);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	50                   	push   %eax
801043cc:	e8 5b d1 ff ff       	call   8010152c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801043d1:	83 c4 0c             	add    $0xc,%esp
801043d4:	6a 00                	push   $0x0
801043d6:	8d 45 da             	lea    -0x26(%ebp),%eax
801043d9:	50                   	push   %eax
801043da:	56                   	push   %esi
801043db:	e8 34 d6 ff ff       	call   80101a14 <dirlookup>
801043e0:	89 c3                	mov    %eax,%ebx
801043e2:	83 c4 10             	add    $0x10,%esp
801043e5:	85 c0                	test   %eax,%eax
801043e7:	74 3d                	je     80104426 <create+0x87>
    iunlockput(dp);
801043e9:	83 ec 0c             	sub    $0xc,%esp
801043ec:	56                   	push   %esi
801043ed:	e8 8f d3 ff ff       	call   80101781 <iunlockput>
    ilock(ip);
801043f2:	89 1c 24             	mov    %ebx,(%esp)
801043f5:	e8 32 d1 ff ff       	call   8010152c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801043fa:	83 c4 10             	add    $0x10,%esp
801043fd:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104402:	75 07                	jne    8010440b <create+0x6c>
80104404:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104409:	74 11                	je     8010441c <create+0x7d>
      return ip;
    iunlockput(ip);
8010440b:	83 ec 0c             	sub    $0xc,%esp
8010440e:	53                   	push   %ebx
8010440f:	e8 6d d3 ff ff       	call   80101781 <iunlockput>
    return 0;
80104414:	83 c4 10             	add    $0x10,%esp
80104417:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010441c:	89 d8                	mov    %ebx,%eax
8010441e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104421:	5b                   	pop    %ebx
80104422:	5e                   	pop    %esi
80104423:	5f                   	pop    %edi
80104424:	5d                   	pop    %ebp
80104425:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104426:	83 ec 08             	sub    $0x8,%esp
80104429:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010442d:	50                   	push   %eax
8010442e:	ff 36                	pushl  (%esi)
80104430:	e8 98 cf ff ff       	call   801013cd <ialloc>
80104435:	89 c3                	mov    %eax,%ebx
80104437:	83 c4 10             	add    $0x10,%esp
8010443a:	85 c0                	test   %eax,%eax
8010443c:	74 52                	je     80104490 <create+0xf1>
  ilock(ip);
8010443e:	83 ec 0c             	sub    $0xc,%esp
80104441:	50                   	push   %eax
80104442:	e8 e5 d0 ff ff       	call   8010152c <ilock>
  ip->major = major;
80104447:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
8010444b:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010444f:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104453:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104459:	89 1c 24             	mov    %ebx,(%esp)
8010445c:	e8 19 d0 ff ff       	call   8010147a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104461:	83 c4 10             	add    $0x10,%esp
80104464:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104469:	74 32                	je     8010449d <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
8010446b:	83 ec 04             	sub    $0x4,%esp
8010446e:	ff 73 04             	pushl  0x4(%ebx)
80104471:	8d 45 da             	lea    -0x26(%ebp),%eax
80104474:	50                   	push   %eax
80104475:	56                   	push   %esi
80104476:	e8 b0 d7 ff ff       	call   80101c2b <dirlink>
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	85 c0                	test   %eax,%eax
80104480:	78 66                	js     801044e8 <create+0x149>
  iunlockput(dp);
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	56                   	push   %esi
80104486:	e8 f6 d2 ff ff       	call   80101781 <iunlockput>
  return ip;
8010448b:	83 c4 10             	add    $0x10,%esp
8010448e:	eb 8c                	jmp    8010441c <create+0x7d>
    panic("create: ialloc");
80104490:	83 ec 0c             	sub    $0xc,%esp
80104493:	68 e0 7f 10 80       	push   $0x80107fe0
80104498:	e8 bb be ff ff       	call   80100358 <panic>
    dp->nlink++;  // for ".."
8010449d:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	56                   	push   %esi
801044a6:	e8 cf cf ff ff       	call   8010147a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801044ab:	83 c4 0c             	add    $0xc,%esp
801044ae:	ff 73 04             	pushl  0x4(%ebx)
801044b1:	68 f0 7f 10 80       	push   $0x80107ff0
801044b6:	53                   	push   %ebx
801044b7:	e8 6f d7 ff ff       	call   80101c2b <dirlink>
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	85 c0                	test   %eax,%eax
801044c1:	78 18                	js     801044db <create+0x13c>
801044c3:	83 ec 04             	sub    $0x4,%esp
801044c6:	ff 76 04             	pushl  0x4(%esi)
801044c9:	68 ef 7f 10 80       	push   $0x80107fef
801044ce:	53                   	push   %ebx
801044cf:	e8 57 d7 ff ff       	call   80101c2b <dirlink>
801044d4:	83 c4 10             	add    $0x10,%esp
801044d7:	85 c0                	test   %eax,%eax
801044d9:	79 90                	jns    8010446b <create+0xcc>
      panic("create dots");
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	68 f2 7f 10 80       	push   $0x80107ff2
801044e3:	e8 70 be ff ff       	call   80100358 <panic>
    panic("create: dirlink");
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	68 fe 7f 10 80       	push   $0x80107ffe
801044f0:	e8 63 be ff ff       	call   80100358 <panic>
    return 0;
801044f5:	89 c3                	mov    %eax,%ebx
801044f7:	e9 20 ff ff ff       	jmp    8010441c <create+0x7d>

801044fc <sys_dup>:
{
801044fc:	f3 0f 1e fb          	endbr32 
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104507:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010450a:	ba 00 00 00 00       	mov    $0x0,%edx
8010450f:	b8 00 00 00 00       	mov    $0x0,%eax
80104514:	e8 ef fd ff ff       	call   80104308 <argfd>
80104519:	85 c0                	test   %eax,%eax
8010451b:	78 23                	js     80104540 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
8010451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104520:	e8 45 fe ff ff       	call   8010436a <fdalloc>
80104525:	89 c3                	mov    %eax,%ebx
80104527:	85 c0                	test   %eax,%eax
80104529:	78 1c                	js     80104547 <sys_dup+0x4b>
  filedup(f);
8010452b:	83 ec 0c             	sub    $0xc,%esp
8010452e:	ff 75 f4             	pushl  -0xc(%ebp)
80104531:	e8 02 c8 ff ff       	call   80100d38 <filedup>
  return fd;
80104536:	83 c4 10             	add    $0x10,%esp
}
80104539:	89 d8                	mov    %ebx,%eax
8010453b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010453e:	c9                   	leave  
8010453f:	c3                   	ret    
    return -1;
80104540:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104545:	eb f2                	jmp    80104539 <sys_dup+0x3d>
    return -1;
80104547:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010454c:	eb eb                	jmp    80104539 <sys_dup+0x3d>

8010454e <sys_read>:
{
8010454e:	f3 0f 1e fb          	endbr32 
80104552:	55                   	push   %ebp
80104553:	89 e5                	mov    %esp,%ebp
80104555:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104558:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010455b:	ba 00 00 00 00       	mov    $0x0,%edx
80104560:	b8 00 00 00 00       	mov    $0x0,%eax
80104565:	e8 9e fd ff ff       	call   80104308 <argfd>
8010456a:	85 c0                	test   %eax,%eax
8010456c:	78 43                	js     801045b1 <sys_read+0x63>
8010456e:	83 ec 08             	sub    $0x8,%esp
80104571:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104574:	50                   	push   %eax
80104575:	6a 02                	push   $0x2
80104577:	e8 6b fc ff ff       	call   801041e7 <argint>
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	85 c0                	test   %eax,%eax
80104581:	78 35                	js     801045b8 <sys_read+0x6a>
80104583:	83 ec 04             	sub    $0x4,%esp
80104586:	ff 75 f0             	pushl  -0x10(%ebp)
80104589:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010458c:	50                   	push   %eax
8010458d:	6a 01                	push   $0x1
8010458f:	e8 7d fc ff ff       	call   80104211 <argptr>
80104594:	83 c4 10             	add    $0x10,%esp
80104597:	85 c0                	test   %eax,%eax
80104599:	78 24                	js     801045bf <sys_read+0x71>
  return fileread(f, p, n);
8010459b:	83 ec 04             	sub    $0x4,%esp
8010459e:	ff 75 f0             	pushl  -0x10(%ebp)
801045a1:	ff 75 ec             	pushl  -0x14(%ebp)
801045a4:	ff 75 f4             	pushl  -0xc(%ebp)
801045a7:	e8 d9 c8 ff ff       	call   80100e85 <fileread>
801045ac:	83 c4 10             	add    $0x10,%esp
}
801045af:	c9                   	leave  
801045b0:	c3                   	ret    
    return -1;
801045b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b6:	eb f7                	jmp    801045af <sys_read+0x61>
801045b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045bd:	eb f0                	jmp    801045af <sys_read+0x61>
801045bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c4:	eb e9                	jmp    801045af <sys_read+0x61>

801045c6 <sys_write>:
{
801045c6:	f3 0f 1e fb          	endbr32 
801045ca:	55                   	push   %ebp
801045cb:	89 e5                	mov    %esp,%ebp
801045cd:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801045d0:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801045d3:	ba 00 00 00 00       	mov    $0x0,%edx
801045d8:	b8 00 00 00 00       	mov    $0x0,%eax
801045dd:	e8 26 fd ff ff       	call   80104308 <argfd>
801045e2:	85 c0                	test   %eax,%eax
801045e4:	78 43                	js     80104629 <sys_write+0x63>
801045e6:	83 ec 08             	sub    $0x8,%esp
801045e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045ec:	50                   	push   %eax
801045ed:	6a 02                	push   $0x2
801045ef:	e8 f3 fb ff ff       	call   801041e7 <argint>
801045f4:	83 c4 10             	add    $0x10,%esp
801045f7:	85 c0                	test   %eax,%eax
801045f9:	78 35                	js     80104630 <sys_write+0x6a>
801045fb:	83 ec 04             	sub    $0x4,%esp
801045fe:	ff 75 f0             	pushl  -0x10(%ebp)
80104601:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104604:	50                   	push   %eax
80104605:	6a 01                	push   $0x1
80104607:	e8 05 fc ff ff       	call   80104211 <argptr>
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	78 24                	js     80104637 <sys_write+0x71>
  return filewrite(f, p, n);
80104613:	83 ec 04             	sub    $0x4,%esp
80104616:	ff 75 f0             	pushl  -0x10(%ebp)
80104619:	ff 75 ec             	pushl  -0x14(%ebp)
8010461c:	ff 75 f4             	pushl  -0xc(%ebp)
8010461f:	e8 ea c8 ff ff       	call   80100f0e <filewrite>
80104624:	83 c4 10             	add    $0x10,%esp
}
80104627:	c9                   	leave  
80104628:	c3                   	ret    
    return -1;
80104629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010462e:	eb f7                	jmp    80104627 <sys_write+0x61>
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104635:	eb f0                	jmp    80104627 <sys_write+0x61>
80104637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463c:	eb e9                	jmp    80104627 <sys_write+0x61>

8010463e <sys_close>:
{
8010463e:	f3 0f 1e fb          	endbr32 
80104642:	55                   	push   %ebp
80104643:	89 e5                	mov    %esp,%ebp
80104645:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104648:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010464b:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010464e:	b8 00 00 00 00       	mov    $0x0,%eax
80104653:	e8 b0 fc ff ff       	call   80104308 <argfd>
80104658:	85 c0                	test   %eax,%eax
8010465a:	78 25                	js     80104681 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
8010465c:	e8 89 ed ff ff       	call   801033ea <myproc>
80104661:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104664:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010466b:	00 
  fileclose(f);
8010466c:	83 ec 0c             	sub    $0xc,%esp
8010466f:	ff 75 f0             	pushl  -0x10(%ebp)
80104672:	e8 0a c7 ff ff       	call   80100d81 <fileclose>
  return 0;
80104677:	83 c4 10             	add    $0x10,%esp
8010467a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010467f:	c9                   	leave  
80104680:	c3                   	ret    
    return -1;
80104681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104686:	eb f7                	jmp    8010467f <sys_close+0x41>

80104688 <sys_fstat>:
{
80104688:	f3 0f 1e fb          	endbr32 
8010468c:	55                   	push   %ebp
8010468d:	89 e5                	mov    %esp,%ebp
8010468f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104692:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104695:	ba 00 00 00 00       	mov    $0x0,%edx
8010469a:	b8 00 00 00 00       	mov    $0x0,%eax
8010469f:	e8 64 fc ff ff       	call   80104308 <argfd>
801046a4:	85 c0                	test   %eax,%eax
801046a6:	78 2a                	js     801046d2 <sys_fstat+0x4a>
801046a8:	83 ec 04             	sub    $0x4,%esp
801046ab:	6a 14                	push   $0x14
801046ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046b0:	50                   	push   %eax
801046b1:	6a 01                	push   $0x1
801046b3:	e8 59 fb ff ff       	call   80104211 <argptr>
801046b8:	83 c4 10             	add    $0x10,%esp
801046bb:	85 c0                	test   %eax,%eax
801046bd:	78 1a                	js     801046d9 <sys_fstat+0x51>
  return filestat(f, st);
801046bf:	83 ec 08             	sub    $0x8,%esp
801046c2:	ff 75 f0             	pushl  -0x10(%ebp)
801046c5:	ff 75 f4             	pushl  -0xc(%ebp)
801046c8:	e8 6d c7 ff ff       	call   80100e3a <filestat>
801046cd:	83 c4 10             	add    $0x10,%esp
}
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    
    return -1;
801046d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d7:	eb f7                	jmp    801046d0 <sys_fstat+0x48>
801046d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046de:	eb f0                	jmp    801046d0 <sys_fstat+0x48>

801046e0 <sys_link>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	53                   	push   %ebx
801046e9:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801046ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
801046ef:	50                   	push   %eax
801046f0:	6a 00                	push   $0x0
801046f2:	e8 7f fb ff ff       	call   80104276 <argstr>
801046f7:	83 c4 10             	add    $0x10,%esp
801046fa:	85 c0                	test   %eax,%eax
801046fc:	0f 88 26 01 00 00    	js     80104828 <sys_link+0x148>
80104702:	83 ec 08             	sub    $0x8,%esp
80104705:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104708:	50                   	push   %eax
80104709:	6a 01                	push   $0x1
8010470b:	e8 66 fb ff ff       	call   80104276 <argstr>
80104710:	83 c4 10             	add    $0x10,%esp
80104713:	85 c0                	test   %eax,%eax
80104715:	0f 88 14 01 00 00    	js     8010482f <sys_link+0x14f>
  begin_op();
8010471b:	e8 60 e1 ff ff       	call   80102880 <begin_op>
  if((ip = namei(old)) == 0){
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	ff 75 e0             	pushl  -0x20(%ebp)
80104726:	e8 b9 d5 ff ff       	call   80101ce4 <namei>
8010472b:	89 c3                	mov    %eax,%ebx
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	85 c0                	test   %eax,%eax
80104732:	0f 84 93 00 00 00    	je     801047cb <sys_link+0xeb>
  ilock(ip);
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	50                   	push   %eax
8010473c:	e8 eb cd ff ff       	call   8010152c <ilock>
  if(ip->type == T_DIR){
80104741:	83 c4 10             	add    $0x10,%esp
80104744:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104749:	0f 84 88 00 00 00    	je     801047d7 <sys_link+0xf7>
  ip->nlink++;
8010474f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	53                   	push   %ebx
80104758:	e8 1d cd ff ff       	call   8010147a <iupdate>
  iunlock(ip);
8010475d:	89 1c 24             	mov    %ebx,(%esp)
80104760:	e8 8d ce ff ff       	call   801015f2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104765:	83 c4 08             	add    $0x8,%esp
80104768:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010476b:	50                   	push   %eax
8010476c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010476f:	e8 8c d5 ff ff       	call   80101d00 <nameiparent>
80104774:	89 c6                	mov    %eax,%esi
80104776:	83 c4 10             	add    $0x10,%esp
80104779:	85 c0                	test   %eax,%eax
8010477b:	74 7e                	je     801047fb <sys_link+0x11b>
  ilock(dp);
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	50                   	push   %eax
80104781:	e8 a6 cd ff ff       	call   8010152c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	8b 03                	mov    (%ebx),%eax
8010478b:	39 06                	cmp    %eax,(%esi)
8010478d:	75 60                	jne    801047ef <sys_link+0x10f>
8010478f:	83 ec 04             	sub    $0x4,%esp
80104792:	ff 73 04             	pushl  0x4(%ebx)
80104795:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104798:	50                   	push   %eax
80104799:	56                   	push   %esi
8010479a:	e8 8c d4 ff ff       	call   80101c2b <dirlink>
8010479f:	83 c4 10             	add    $0x10,%esp
801047a2:	85 c0                	test   %eax,%eax
801047a4:	78 49                	js     801047ef <sys_link+0x10f>
  iunlockput(dp);
801047a6:	83 ec 0c             	sub    $0xc,%esp
801047a9:	56                   	push   %esi
801047aa:	e8 d2 cf ff ff       	call   80101781 <iunlockput>
  iput(ip);
801047af:	89 1c 24             	mov    %ebx,(%esp)
801047b2:	e8 84 ce ff ff       	call   8010163b <iput>
  end_op();
801047b7:	e8 43 e1 ff ff       	call   801028ff <end_op>
  return 0;
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c7:	5b                   	pop    %ebx
801047c8:	5e                   	pop    %esi
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
    end_op();
801047cb:	e8 2f e1 ff ff       	call   801028ff <end_op>
    return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	eb ed                	jmp    801047c4 <sys_link+0xe4>
    iunlockput(ip);
801047d7:	83 ec 0c             	sub    $0xc,%esp
801047da:	53                   	push   %ebx
801047db:	e8 a1 cf ff ff       	call   80101781 <iunlockput>
    end_op();
801047e0:	e8 1a e1 ff ff       	call   801028ff <end_op>
    return -1;
801047e5:	83 c4 10             	add    $0x10,%esp
801047e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ed:	eb d5                	jmp    801047c4 <sys_link+0xe4>
    iunlockput(dp);
801047ef:	83 ec 0c             	sub    $0xc,%esp
801047f2:	56                   	push   %esi
801047f3:	e8 89 cf ff ff       	call   80101781 <iunlockput>
    goto bad;
801047f8:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	53                   	push   %ebx
801047ff:	e8 28 cd ff ff       	call   8010152c <ilock>
  ip->nlink--;
80104804:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104809:	89 1c 24             	mov    %ebx,(%esp)
8010480c:	e8 69 cc ff ff       	call   8010147a <iupdate>
  iunlockput(ip);
80104811:	89 1c 24             	mov    %ebx,(%esp)
80104814:	e8 68 cf ff ff       	call   80101781 <iunlockput>
  end_op();
80104819:	e8 e1 e0 ff ff       	call   801028ff <end_op>
  return -1;
8010481e:	83 c4 10             	add    $0x10,%esp
80104821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104826:	eb 9c                	jmp    801047c4 <sys_link+0xe4>
    return -1;
80104828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482d:	eb 95                	jmp    801047c4 <sys_link+0xe4>
8010482f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104834:	eb 8e                	jmp    801047c4 <sys_link+0xe4>

80104836 <sys_unlink>:
{
80104836:	f3 0f 1e fb          	endbr32 
8010483a:	55                   	push   %ebp
8010483b:	89 e5                	mov    %esp,%ebp
8010483d:	57                   	push   %edi
8010483e:	56                   	push   %esi
8010483f:	53                   	push   %ebx
80104840:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104843:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104846:	50                   	push   %eax
80104847:	6a 00                	push   $0x0
80104849:	e8 28 fa ff ff       	call   80104276 <argstr>
8010484e:	83 c4 10             	add    $0x10,%esp
80104851:	85 c0                	test   %eax,%eax
80104853:	0f 88 81 01 00 00    	js     801049da <sys_unlink+0x1a4>
  begin_op();
80104859:	e8 22 e0 ff ff       	call   80102880 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010485e:	83 ec 08             	sub    $0x8,%esp
80104861:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104864:	50                   	push   %eax
80104865:	ff 75 c4             	pushl  -0x3c(%ebp)
80104868:	e8 93 d4 ff ff       	call   80101d00 <nameiparent>
8010486d:	89 c6                	mov    %eax,%esi
8010486f:	83 c4 10             	add    $0x10,%esp
80104872:	85 c0                	test   %eax,%eax
80104874:	0f 84 df 00 00 00    	je     80104959 <sys_unlink+0x123>
  ilock(dp);
8010487a:	83 ec 0c             	sub    $0xc,%esp
8010487d:	50                   	push   %eax
8010487e:	e8 a9 cc ff ff       	call   8010152c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104883:	83 c4 08             	add    $0x8,%esp
80104886:	68 f0 7f 10 80       	push   $0x80107ff0
8010488b:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010488e:	50                   	push   %eax
8010488f:	e8 67 d1 ff ff       	call   801019fb <namecmp>
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	85 c0                	test   %eax,%eax
80104899:	0f 84 51 01 00 00    	je     801049f0 <sys_unlink+0x1ba>
8010489f:	83 ec 08             	sub    $0x8,%esp
801048a2:	68 ef 7f 10 80       	push   $0x80107fef
801048a7:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048aa:	50                   	push   %eax
801048ab:	e8 4b d1 ff ff       	call   801019fb <namecmp>
801048b0:	83 c4 10             	add    $0x10,%esp
801048b3:	85 c0                	test   %eax,%eax
801048b5:	0f 84 35 01 00 00    	je     801049f0 <sys_unlink+0x1ba>
  if((ip = dirlookup(dp, name, &off)) == 0)
801048bb:	83 ec 04             	sub    $0x4,%esp
801048be:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048c1:	50                   	push   %eax
801048c2:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048c5:	50                   	push   %eax
801048c6:	56                   	push   %esi
801048c7:	e8 48 d1 ff ff       	call   80101a14 <dirlookup>
801048cc:	89 c3                	mov    %eax,%ebx
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	85 c0                	test   %eax,%eax
801048d3:	0f 84 17 01 00 00    	je     801049f0 <sys_unlink+0x1ba>
  ilock(ip);
801048d9:	83 ec 0c             	sub    $0xc,%esp
801048dc:	50                   	push   %eax
801048dd:	e8 4a cc ff ff       	call   8010152c <ilock>
  if(ip->nlink < 1)
801048e2:	83 c4 10             	add    $0x10,%esp
801048e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801048ea:	7e 79                	jle    80104965 <sys_unlink+0x12f>
  if(ip->type == T_DIR && !isdirempty(ip)){
801048ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801048f1:	74 7f                	je     80104972 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
801048f3:	83 ec 04             	sub    $0x4,%esp
801048f6:	6a 10                	push   $0x10
801048f8:	6a 00                	push   $0x0
801048fa:	8d 7d d8             	lea    -0x28(%ebp),%edi
801048fd:	57                   	push   %edi
801048fe:	e8 4c f6 ff ff       	call   80103f4f <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104903:	6a 10                	push   $0x10
80104905:	ff 75 c0             	pushl  -0x40(%ebp)
80104908:	57                   	push   %edi
80104909:	56                   	push   %esi
8010490a:	e8 c5 cf ff ff       	call   801018d4 <writei>
8010490f:	83 c4 20             	add    $0x20,%esp
80104912:	83 f8 10             	cmp    $0x10,%eax
80104915:	0f 85 9c 00 00 00    	jne    801049b7 <sys_unlink+0x181>
  if(ip->type == T_DIR){
8010491b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104920:	0f 84 9e 00 00 00    	je     801049c4 <sys_unlink+0x18e>
  iunlockput(dp);
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	56                   	push   %esi
8010492a:	e8 52 ce ff ff       	call   80101781 <iunlockput>
  ip->nlink--;
8010492f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104934:	89 1c 24             	mov    %ebx,(%esp)
80104937:	e8 3e cb ff ff       	call   8010147a <iupdate>
  iunlockput(ip);
8010493c:	89 1c 24             	mov    %ebx,(%esp)
8010493f:	e8 3d ce ff ff       	call   80101781 <iunlockput>
  end_op();
80104944:	e8 b6 df ff ff       	call   801028ff <end_op>
  return 0;
80104949:	83 c4 10             	add    $0x10,%esp
8010494c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104954:	5b                   	pop    %ebx
80104955:	5e                   	pop    %esi
80104956:	5f                   	pop    %edi
80104957:	5d                   	pop    %ebp
80104958:	c3                   	ret    
    end_op();
80104959:	e8 a1 df ff ff       	call   801028ff <end_op>
    return -1;
8010495e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104963:	eb ec                	jmp    80104951 <sys_unlink+0x11b>
    panic("unlink: nlink < 1");
80104965:	83 ec 0c             	sub    $0xc,%esp
80104968:	68 0e 80 10 80       	push   $0x8010800e
8010496d:	e8 e6 b9 ff ff       	call   80100358 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104972:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104976:	0f 86 77 ff ff ff    	jbe    801048f3 <sys_unlink+0xbd>
8010497c:	bf 20 00 00 00       	mov    $0x20,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104981:	6a 10                	push   $0x10
80104983:	57                   	push   %edi
80104984:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104987:	50                   	push   %eax
80104988:	53                   	push   %ebx
80104989:	e8 46 ce ff ff       	call   801017d4 <readi>
8010498e:	83 c4 10             	add    $0x10,%esp
80104991:	83 f8 10             	cmp    $0x10,%eax
80104994:	75 14                	jne    801049aa <sys_unlink+0x174>
    if(de.inum != 0)
80104996:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
8010499b:	75 47                	jne    801049e4 <sys_unlink+0x1ae>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010499d:	83 c7 10             	add    $0x10,%edi
801049a0:	3b 7b 58             	cmp    0x58(%ebx),%edi
801049a3:	72 dc                	jb     80104981 <sys_unlink+0x14b>
801049a5:	e9 49 ff ff ff       	jmp    801048f3 <sys_unlink+0xbd>
      panic("isdirempty: readi");
801049aa:	83 ec 0c             	sub    $0xc,%esp
801049ad:	68 20 80 10 80       	push   $0x80108020
801049b2:	e8 a1 b9 ff ff       	call   80100358 <panic>
    panic("unlink: writei");
801049b7:	83 ec 0c             	sub    $0xc,%esp
801049ba:	68 32 80 10 80       	push   $0x80108032
801049bf:	e8 94 b9 ff ff       	call   80100358 <panic>
    dp->nlink--;
801049c4:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	56                   	push   %esi
801049cd:	e8 a8 ca ff ff       	call   8010147a <iupdate>
801049d2:	83 c4 10             	add    $0x10,%esp
801049d5:	e9 4c ff ff ff       	jmp    80104926 <sys_unlink+0xf0>
    return -1;
801049da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049df:	e9 6d ff ff ff       	jmp    80104951 <sys_unlink+0x11b>
    iunlockput(ip);
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	53                   	push   %ebx
801049e8:	e8 94 cd ff ff       	call   80101781 <iunlockput>
    goto bad;
801049ed:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801049f0:	83 ec 0c             	sub    $0xc,%esp
801049f3:	56                   	push   %esi
801049f4:	e8 88 cd ff ff       	call   80101781 <iunlockput>
  end_op();
801049f9:	e8 01 df ff ff       	call   801028ff <end_op>
  return -1;
801049fe:	83 c4 10             	add    $0x10,%esp
80104a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a06:	e9 46 ff ff ff       	jmp    80104951 <sys_unlink+0x11b>

80104a0b <sys_open>:

int
sys_open(void)
{
80104a0b:	f3 0f 1e fb          	endbr32 
80104a0f:	55                   	push   %ebp
80104a10:	89 e5                	mov    %esp,%ebp
80104a12:	57                   	push   %edi
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104a18:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104a1b:	50                   	push   %eax
80104a1c:	6a 00                	push   $0x0
80104a1e:	e8 53 f8 ff ff       	call   80104276 <argstr>
80104a23:	83 c4 10             	add    $0x10,%esp
80104a26:	85 c0                	test   %eax,%eax
80104a28:	0f 88 0b 01 00 00    	js     80104b39 <sys_open+0x12e>
80104a2e:	83 ec 08             	sub    $0x8,%esp
80104a31:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104a34:	50                   	push   %eax
80104a35:	6a 01                	push   $0x1
80104a37:	e8 ab f7 ff ff       	call   801041e7 <argint>
80104a3c:	83 c4 10             	add    $0x10,%esp
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	0f 88 f9 00 00 00    	js     80104b40 <sys_open+0x135>
    return -1;

  begin_op();
80104a47:	e8 34 de ff ff       	call   80102880 <begin_op>

  if(omode & O_CREATE){
80104a4c:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104a50:	0f 84 8a 00 00 00    	je     80104ae0 <sys_open+0xd5>
    ip = create(path, T_FILE, 0, 0);
80104a56:	83 ec 0c             	sub    $0xc,%esp
80104a59:	6a 00                	push   $0x0
80104a5b:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a60:	ba 02 00 00 00       	mov    $0x2,%edx
80104a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a68:	e8 32 f9 ff ff       	call   8010439f <create>
80104a6d:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	74 5e                	je     80104ad4 <sys_open+0xc9>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104a76:	e8 5a c2 ff ff       	call   80100cd5 <filealloc>
80104a7b:	89 c3                	mov    %eax,%ebx
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	0f 84 ce 00 00 00    	je     80104b53 <sys_open+0x148>
80104a85:	e8 e0 f8 ff ff       	call   8010436a <fdalloc>
80104a8a:	89 c7                	mov    %eax,%edi
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	0f 88 b3 00 00 00    	js     80104b47 <sys_open+0x13c>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	56                   	push   %esi
80104a98:	e8 55 cb ff ff       	call   801015f2 <iunlock>
  end_op();
80104a9d:	e8 5d de ff ff       	call   801028ff <end_op>

  f->type = FD_INODE;
80104aa2:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104aa8:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104aab:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104ab2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104ab5:	89 d0                	mov    %edx,%eax
80104ab7:	83 f0 01             	xor    $0x1,%eax
80104aba:	83 e0 01             	and    $0x1,%eax
80104abd:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ac0:	83 c4 10             	add    $0x10,%esp
80104ac3:	f6 c2 03             	test   $0x3,%dl
80104ac6:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104aca:	89 f8                	mov    %edi,%eax
80104acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104acf:	5b                   	pop    %ebx
80104ad0:	5e                   	pop    %esi
80104ad1:	5f                   	pop    %edi
80104ad2:	5d                   	pop    %ebp
80104ad3:	c3                   	ret    
      end_op();
80104ad4:	e8 26 de ff ff       	call   801028ff <end_op>
      return -1;
80104ad9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ade:	eb ea                	jmp    80104aca <sys_open+0xbf>
    if((ip = namei(path)) == 0){
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	ff 75 e4             	pushl  -0x1c(%ebp)
80104ae6:	e8 f9 d1 ff ff       	call   80101ce4 <namei>
80104aeb:	89 c6                	mov    %eax,%esi
80104aed:	83 c4 10             	add    $0x10,%esp
80104af0:	85 c0                	test   %eax,%eax
80104af2:	74 39                	je     80104b2d <sys_open+0x122>
    ilock(ip);
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	50                   	push   %eax
80104af8:	e8 2f ca ff ff       	call   8010152c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104b05:	0f 85 6b ff ff ff    	jne    80104a76 <sys_open+0x6b>
80104b0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104b0f:	0f 84 61 ff ff ff    	je     80104a76 <sys_open+0x6b>
      iunlockput(ip);
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	56                   	push   %esi
80104b19:	e8 63 cc ff ff       	call   80101781 <iunlockput>
      end_op();
80104b1e:	e8 dc dd ff ff       	call   801028ff <end_op>
      return -1;
80104b23:	83 c4 10             	add    $0x10,%esp
80104b26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b2b:	eb 9d                	jmp    80104aca <sys_open+0xbf>
      end_op();
80104b2d:	e8 cd dd ff ff       	call   801028ff <end_op>
      return -1;
80104b32:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b37:	eb 91                	jmp    80104aca <sys_open+0xbf>
    return -1;
80104b39:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b3e:	eb 8a                	jmp    80104aca <sys_open+0xbf>
80104b40:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b45:	eb 83                	jmp    80104aca <sys_open+0xbf>
      fileclose(f);
80104b47:	83 ec 0c             	sub    $0xc,%esp
80104b4a:	53                   	push   %ebx
80104b4b:	e8 31 c2 ff ff       	call   80100d81 <fileclose>
80104b50:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104b53:	83 ec 0c             	sub    $0xc,%esp
80104b56:	56                   	push   %esi
80104b57:	e8 25 cc ff ff       	call   80101781 <iunlockput>
    end_op();
80104b5c:	e8 9e dd ff ff       	call   801028ff <end_op>
    return -1;
80104b61:	83 c4 10             	add    $0x10,%esp
80104b64:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b69:	e9 5c ff ff ff       	jmp    80104aca <sys_open+0xbf>

80104b6e <sys_mkdir>:

int
sys_mkdir(void)
{
80104b6e:	f3 0f 1e fb          	endbr32 
80104b72:	55                   	push   %ebp
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104b78:	e8 03 dd ff ff       	call   80102880 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104b7d:	83 ec 08             	sub    $0x8,%esp
80104b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b83:	50                   	push   %eax
80104b84:	6a 00                	push   $0x0
80104b86:	e8 eb f6 ff ff       	call   80104276 <argstr>
80104b8b:	83 c4 10             	add    $0x10,%esp
80104b8e:	85 c0                	test   %eax,%eax
80104b90:	78 36                	js     80104bc8 <sys_mkdir+0x5a>
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	6a 00                	push   $0x0
80104b97:	b9 00 00 00 00       	mov    $0x0,%ecx
80104b9c:	ba 01 00 00 00       	mov    $0x1,%edx
80104ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba4:	e8 f6 f7 ff ff       	call   8010439f <create>
80104ba9:	83 c4 10             	add    $0x10,%esp
80104bac:	85 c0                	test   %eax,%eax
80104bae:	74 18                	je     80104bc8 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	50                   	push   %eax
80104bb4:	e8 c8 cb ff ff       	call   80101781 <iunlockput>
  end_op();
80104bb9:	e8 41 dd ff ff       	call   801028ff <end_op>
  return 0;
80104bbe:	83 c4 10             	add    $0x10,%esp
80104bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104bc6:	c9                   	leave  
80104bc7:	c3                   	ret    
    end_op();
80104bc8:	e8 32 dd ff ff       	call   801028ff <end_op>
    return -1;
80104bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd2:	eb f2                	jmp    80104bc6 <sys_mkdir+0x58>

80104bd4 <sys_mknod>:

int
sys_mknod(void)
{
80104bd4:	f3 0f 1e fb          	endbr32 
80104bd8:	55                   	push   %ebp
80104bd9:	89 e5                	mov    %esp,%ebp
80104bdb:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104bde:	e8 9d dc ff ff       	call   80102880 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104be3:	83 ec 08             	sub    $0x8,%esp
80104be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104be9:	50                   	push   %eax
80104bea:	6a 00                	push   $0x0
80104bec:	e8 85 f6 ff ff       	call   80104276 <argstr>
80104bf1:	83 c4 10             	add    $0x10,%esp
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	78 62                	js     80104c5a <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104bf8:	83 ec 08             	sub    $0x8,%esp
80104bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bfe:	50                   	push   %eax
80104bff:	6a 01                	push   $0x1
80104c01:	e8 e1 f5 ff ff       	call   801041e7 <argint>
  if((argstr(0, &path)) < 0 ||
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	85 c0                	test   %eax,%eax
80104c0b:	78 4d                	js     80104c5a <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104c0d:	83 ec 08             	sub    $0x8,%esp
80104c10:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c13:	50                   	push   %eax
80104c14:	6a 02                	push   $0x2
80104c16:	e8 cc f5 ff ff       	call   801041e7 <argint>
     argint(1, &major) < 0 ||
80104c1b:	83 c4 10             	add    $0x10,%esp
80104c1e:	85 c0                	test   %eax,%eax
80104c20:	78 38                	js     80104c5a <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104c22:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104c26:	83 ec 0c             	sub    $0xc,%esp
80104c29:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104c2d:	50                   	push   %eax
80104c2e:	ba 03 00 00 00       	mov    $0x3,%edx
80104c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c36:	e8 64 f7 ff ff       	call   8010439f <create>
     argint(2, &minor) < 0 ||
80104c3b:	83 c4 10             	add    $0x10,%esp
80104c3e:	85 c0                	test   %eax,%eax
80104c40:	74 18                	je     80104c5a <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c42:	83 ec 0c             	sub    $0xc,%esp
80104c45:	50                   	push   %eax
80104c46:	e8 36 cb ff ff       	call   80101781 <iunlockput>
  end_op();
80104c4b:	e8 af dc ff ff       	call   801028ff <end_op>
  return 0;
80104c50:	83 c4 10             	add    $0x10,%esp
80104c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    
    end_op();
80104c5a:	e8 a0 dc ff ff       	call   801028ff <end_op>
    return -1;
80104c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c64:	eb f2                	jmp    80104c58 <sys_mknod+0x84>

80104c66 <sys_chdir>:

int
sys_chdir(void)
{
80104c66:	f3 0f 1e fb          	endbr32 
80104c6a:	55                   	push   %ebp
80104c6b:	89 e5                	mov    %esp,%ebp
80104c6d:	56                   	push   %esi
80104c6e:	53                   	push   %ebx
80104c6f:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104c72:	e8 73 e7 ff ff       	call   801033ea <myproc>
80104c77:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104c79:	e8 02 dc ff ff       	call   80102880 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104c7e:	83 ec 08             	sub    $0x8,%esp
80104c81:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c84:	50                   	push   %eax
80104c85:	6a 00                	push   $0x0
80104c87:	e8 ea f5 ff ff       	call   80104276 <argstr>
80104c8c:	83 c4 10             	add    $0x10,%esp
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	78 52                	js     80104ce5 <sys_chdir+0x7f>
80104c93:	83 ec 0c             	sub    $0xc,%esp
80104c96:	ff 75 f4             	pushl  -0xc(%ebp)
80104c99:	e8 46 d0 ff ff       	call   80101ce4 <namei>
80104c9e:	89 c3                	mov    %eax,%ebx
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	85 c0                	test   %eax,%eax
80104ca5:	74 3e                	je     80104ce5 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104ca7:	83 ec 0c             	sub    $0xc,%esp
80104caa:	50                   	push   %eax
80104cab:	e8 7c c8 ff ff       	call   8010152c <ilock>
  if(ip->type != T_DIR){
80104cb0:	83 c4 10             	add    $0x10,%esp
80104cb3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cb8:	75 37                	jne    80104cf1 <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	53                   	push   %ebx
80104cbe:	e8 2f c9 ff ff       	call   801015f2 <iunlock>
  iput(curproc->cwd);
80104cc3:	83 c4 04             	add    $0x4,%esp
80104cc6:	ff 76 68             	pushl  0x68(%esi)
80104cc9:	e8 6d c9 ff ff       	call   8010163b <iput>
  end_op();
80104cce:	e8 2c dc ff ff       	call   801028ff <end_op>
  curproc->cwd = ip;
80104cd3:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5d                   	pop    %ebp
80104ce4:	c3                   	ret    
    end_op();
80104ce5:	e8 15 dc ff ff       	call   801028ff <end_op>
    return -1;
80104cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cef:	eb ed                	jmp    80104cde <sys_chdir+0x78>
    iunlockput(ip);
80104cf1:	83 ec 0c             	sub    $0xc,%esp
80104cf4:	53                   	push   %ebx
80104cf5:	e8 87 ca ff ff       	call   80101781 <iunlockput>
    end_op();
80104cfa:	e8 00 dc ff ff       	call   801028ff <end_op>
    return -1;
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d07:	eb d5                	jmp    80104cde <sys_chdir+0x78>

80104d09 <sys_exec>:

int
sys_exec(void)
{
80104d09:	f3 0f 1e fb          	endbr32 
80104d0d:	55                   	push   %ebp
80104d0e:	89 e5                	mov    %esp,%ebp
80104d10:	57                   	push   %edi
80104d11:	56                   	push   %esi
80104d12:	53                   	push   %ebx
80104d13:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104d19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d1c:	50                   	push   %eax
80104d1d:	6a 00                	push   $0x0
80104d1f:	e8 52 f5 ff ff       	call   80104276 <argstr>
80104d24:	83 c4 10             	add    $0x10,%esp
80104d27:	85 c0                	test   %eax,%eax
80104d29:	0f 88 ba 00 00 00    	js     80104de9 <sys_exec+0xe0>
80104d2f:	83 ec 08             	sub    $0x8,%esp
80104d32:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104d38:	50                   	push   %eax
80104d39:	6a 01                	push   $0x1
80104d3b:	e8 a7 f4 ff ff       	call   801041e7 <argint>
80104d40:	83 c4 10             	add    $0x10,%esp
80104d43:	85 c0                	test   %eax,%eax
80104d45:	0f 88 a5 00 00 00    	js     80104df0 <sys_exec+0xe7>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104d4b:	83 ec 04             	sub    $0x4,%esp
80104d4e:	68 80 00 00 00       	push   $0x80
80104d53:	6a 00                	push   $0x0
80104d55:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104d5b:	50                   	push   %eax
80104d5c:	e8 ee f1 ff ff       	call   80103f4f <memset>
80104d61:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104d64:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104d69:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104d6f:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80104d76:	83 ec 08             	sub    $0x8,%esp
80104d79:	57                   	push   %edi
80104d7a:	89 d8                	mov    %ebx,%eax
80104d7c:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80104d82:	50                   	push   %eax
80104d83:	e8 d2 f3 ff ff       	call   8010415a <fetchint>
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	78 68                	js     80104df7 <sys_exec+0xee>
      return -1;
    if(uarg == 0){
80104d8f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104d95:	85 c0                	test   %eax,%eax
80104d97:	74 2e                	je     80104dc7 <sys_exec+0xbe>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104d99:	83 ec 08             	sub    $0x8,%esp
80104d9c:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80104da2:	01 d3                	add    %edx,%ebx
80104da4:	53                   	push   %ebx
80104da5:	50                   	push   %eax
80104da6:	e8 ef f3 ff ff       	call   8010419a <fetchstr>
80104dab:	83 c4 10             	add    $0x10,%esp
80104dae:	85 c0                	test   %eax,%eax
80104db0:	78 4c                	js     80104dfe <sys_exec+0xf5>
  for(i=0;; i++){
80104db2:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80104db5:	83 fe 20             	cmp    $0x20,%esi
80104db8:	75 b5                	jne    80104d6f <sys_exec+0x66>
      return -1;
80104dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5f                   	pop    %edi
80104dc5:	5d                   	pop    %ebp
80104dc6:	c3                   	ret    
      argv[i] = 0;
80104dc7:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80104dce:	00 00 00 00 
  return exec(path, argv);
80104dd2:	83 ec 08             	sub    $0x8,%esp
80104dd5:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104ddb:	50                   	push   %eax
80104ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80104ddf:	e8 89 bb ff ff       	call   8010096d <exec>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	eb d6                	jmp    80104dbf <sys_exec+0xb6>
    return -1;
80104de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dee:	eb cf                	jmp    80104dbf <sys_exec+0xb6>
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df5:	eb c8                	jmp    80104dbf <sys_exec+0xb6>
      return -1;
80104df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfc:	eb c1                	jmp    80104dbf <sys_exec+0xb6>
      return -1;
80104dfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e03:	eb ba                	jmp    80104dbf <sys_exec+0xb6>

80104e05 <sys_pipe>:

int
sys_pipe(void)
{
80104e05:	f3 0f 1e fb          	endbr32 
80104e09:	55                   	push   %ebp
80104e0a:	89 e5                	mov    %esp,%ebp
80104e0c:	53                   	push   %ebx
80104e0d:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104e10:	6a 08                	push   $0x8
80104e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e15:	50                   	push   %eax
80104e16:	6a 00                	push   $0x0
80104e18:	e8 f4 f3 ff ff       	call   80104211 <argptr>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 46                	js     80104e6a <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e2a:	50                   	push   %eax
80104e2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e2e:	50                   	push   %eax
80104e2f:	e8 82 e0 ff ff       	call   80102eb6 <pipealloc>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	78 36                	js     80104e71 <sys_pipe+0x6c>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e3e:	e8 27 f5 ff ff       	call   8010436a <fdalloc>
80104e43:	89 c3                	mov    %eax,%ebx
80104e45:	85 c0                	test   %eax,%eax
80104e47:	78 3c                	js     80104e85 <sys_pipe+0x80>
80104e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e4c:	e8 19 f5 ff ff       	call   8010436a <fdalloc>
80104e51:	85 c0                	test   %eax,%eax
80104e53:	78 23                	js     80104e78 <sys_pipe+0x73>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e58:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e5d:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e68:	c9                   	leave  
80104e69:	c3                   	ret    
    return -1;
80104e6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6f:	eb f4                	jmp    80104e65 <sys_pipe+0x60>
    return -1;
80104e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e76:	eb ed                	jmp    80104e65 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104e78:	e8 6d e5 ff ff       	call   801033ea <myproc>
80104e7d:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104e84:	00 
    fileclose(rf);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	ff 75 f0             	pushl  -0x10(%ebp)
80104e8b:	e8 f1 be ff ff       	call   80100d81 <fileclose>
    fileclose(wf);
80104e90:	83 c4 04             	add    $0x4,%esp
80104e93:	ff 75 ec             	pushl  -0x14(%ebp)
80104e96:	e8 e6 be ff ff       	call   80100d81 <fileclose>
    return -1;
80104e9b:	83 c4 10             	add    $0x10,%esp
80104e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea3:	eb c0                	jmp    80104e65 <sys_pipe+0x60>

80104ea5 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104ea5:	f3 0f 1e fb          	endbr32 
80104ea9:	55                   	push   %ebp
80104eaa:	89 e5                	mov    %esp,%ebp
80104eac:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104eaf:	e8 b8 e6 ff ff       	call   8010356c <fork>
}
80104eb4:	c9                   	leave  
80104eb5:	c3                   	ret    

80104eb6 <sys_exit>:

int
sys_exit(void)
{
80104eb6:	f3 0f 1e fb          	endbr32 
80104eba:	55                   	push   %ebp
80104ebb:	89 e5                	mov    %esp,%ebp
80104ebd:	83 ec 08             	sub    $0x8,%esp
  exit();
80104ec0:	e8 ee e8 ff ff       	call   801037b3 <exit>
  return 0;  // not reached
}
80104ec5:	b8 00 00 00 00       	mov    $0x0,%eax
80104eca:	c9                   	leave  
80104ecb:	c3                   	ret    

80104ecc <sys_wait>:

int
sys_wait(void)
{
80104ecc:	f3 0f 1e fb          	endbr32 
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104ed6:	e8 7d ea ff ff       	call   80103958 <wait>
}
80104edb:	c9                   	leave  
80104edc:	c3                   	ret    

80104edd <sys_kill>:

int
sys_kill(void)
{
80104edd:	f3 0f 1e fb          	endbr32 
80104ee1:	55                   	push   %ebp
80104ee2:	89 e5                	mov    %esp,%ebp
80104ee4:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eea:	50                   	push   %eax
80104eeb:	6a 00                	push   $0x0
80104eed:	e8 f5 f2 ff ff       	call   801041e7 <argint>
80104ef2:	83 c4 10             	add    $0x10,%esp
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	78 10                	js     80104f09 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104ef9:	83 ec 0c             	sub    $0xc,%esp
80104efc:	ff 75 f4             	pushl  -0xc(%ebp)
80104eff:	e8 63 eb ff ff       	call   80103a67 <kill>
80104f04:	83 c4 10             	add    $0x10,%esp
}
80104f07:	c9                   	leave  
80104f08:	c3                   	ret    
    return -1;
80104f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0e:	eb f7                	jmp    80104f07 <sys_kill+0x2a>

80104f10 <sys_getpid>:

int
sys_getpid(void)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104f1a:	e8 cb e4 ff ff       	call   801033ea <myproc>
80104f1f:	8b 40 10             	mov    0x10(%eax),%eax
}
80104f22:	c9                   	leave  
80104f23:	c3                   	ret    

80104f24 <sys_sbrk>:

int
sys_sbrk(void)
{
80104f24:	f3 0f 1e fb          	endbr32 
80104f28:	55                   	push   %ebp
80104f29:	89 e5                	mov    %esp,%ebp
80104f2b:	53                   	push   %ebx
80104f2c:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f32:	50                   	push   %eax
80104f33:	6a 00                	push   $0x0
80104f35:	e8 ad f2 ff ff       	call   801041e7 <argint>
80104f3a:	83 c4 10             	add    $0x10,%esp
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	78 26                	js     80104f67 <sys_sbrk+0x43>
    return -1;
  addr = myproc()->sz;
80104f41:	e8 a4 e4 ff ff       	call   801033ea <myproc>
80104f46:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104f48:	83 ec 0c             	sub    $0xc,%esp
80104f4b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f4e:	e8 aa e5 ff ff       	call   801034fd <growproc>
80104f53:	83 c4 10             	add    $0x10,%esp
    return -1;
80104f56:	85 c0                	test   %eax,%eax
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5d:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80104f60:	89 d8                	mov    %ebx,%eax
80104f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f65:	c9                   	leave  
80104f66:	c3                   	ret    
    return -1;
80104f67:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f6c:	eb f2                	jmp    80104f60 <sys_sbrk+0x3c>

80104f6e <sys_sleep>:

int
sys_sleep(void)
{
80104f6e:	f3 0f 1e fb          	endbr32 
80104f72:	55                   	push   %ebp
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	53                   	push   %ebx
80104f76:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7c:	50                   	push   %eax
80104f7d:	6a 00                	push   $0x0
80104f7f:	e8 63 f2 ff ff       	call   801041e7 <argint>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	78 79                	js     80105004 <sys_sleep+0x96>
    return -1;
  acquire(&tickslock);
80104f8b:	83 ec 0c             	sub    $0xc,%esp
80104f8e:	68 c0 61 11 80       	push   $0x801161c0
80104f93:	e8 01 ef ff ff       	call   80103e99 <acquire>
  ticks0 = ticks;
80104f98:	8b 1d 00 6a 11 80    	mov    0x80116a00,%ebx
  while(ticks - ticks0 < n){
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fa5:	74 2c                	je     80104fd3 <sys_sleep+0x65>
    if(myproc()->killed){
80104fa7:	e8 3e e4 ff ff       	call   801033ea <myproc>
80104fac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fb0:	75 3b                	jne    80104fed <sys_sleep+0x7f>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104fb2:	83 ec 08             	sub    $0x8,%esp
80104fb5:	68 c0 61 11 80       	push   $0x801161c0
80104fba:	68 00 6a 11 80       	push   $0x80116a00
80104fbf:	e8 f0 e8 ff ff       	call   801038b4 <sleep>
  while(ticks - ticks0 < n){
80104fc4:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80104fc9:	29 d8                	sub    %ebx,%eax
80104fcb:	83 c4 10             	add    $0x10,%esp
80104fce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104fd1:	72 d4                	jb     80104fa7 <sys_sleep+0x39>
  }
  release(&tickslock);
80104fd3:	83 ec 0c             	sub    $0xc,%esp
80104fd6:	68 c0 61 11 80       	push   $0x801161c0
80104fdb:	e8 24 ef ff ff       	call   80103f04 <release>
  return 0;
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104feb:	c9                   	leave  
80104fec:	c3                   	ret    
      release(&tickslock);
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	68 c0 61 11 80       	push   $0x801161c0
80104ff5:	e8 0a ef ff ff       	call   80103f04 <release>
      return -1;
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105002:	eb e4                	jmp    80104fe8 <sys_sleep+0x7a>
    return -1;
80105004:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105009:	eb dd                	jmp    80104fe8 <sys_sleep+0x7a>

8010500b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010500b:	f3 0f 1e fb          	endbr32 
8010500f:	55                   	push   %ebp
80105010:	89 e5                	mov    %esp,%ebp
80105012:	53                   	push   %ebx
80105013:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105016:	68 c0 61 11 80       	push   $0x801161c0
8010501b:	e8 79 ee ff ff       	call   80103e99 <acquire>
  xticks = ticks;
80105020:	8b 1d 00 6a 11 80    	mov    0x80116a00,%ebx
  release(&tickslock);
80105026:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
8010502d:	e8 d2 ee ff ff       	call   80103f04 <release>
  return xticks;
}
80105032:	89 d8                	mov    %ebx,%eax
80105034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105037:	c9                   	leave  
80105038:	c3                   	ret    

80105039 <sys_ps>:

int
sys_ps(void)
{
80105039:	f3 0f 1e fb          	endbr32 
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
80105040:	83 ec 08             	sub    $0x8,%esp
  ps();
80105043:	e8 4f eb ff ff       	call   80103b97 <ps>
  return 0;
}
80105048:	b8 00 00 00 00       	mov    $0x0,%eax
8010504d:	c9                   	leave  
8010504e:	c3                   	ret    

8010504f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010504f:	1e                   	push   %ds
  pushl %es
80105050:	06                   	push   %es
  pushl %fs
80105051:	0f a0                	push   %fs
  pushl %gs
80105053:	0f a8                	push   %gs
  pushal
80105055:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105056:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010505a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010505c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010505e:	54                   	push   %esp
  call trap
8010505f:	e8 c5 00 00 00       	call   80105129 <trap>
  addl $4, %esp
80105064:	83 c4 04             	add    $0x4,%esp

80105067 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105067:	61                   	popa   
  popl %gs
80105068:	0f a9                	pop    %gs
  popl %fs
8010506a:	0f a1                	pop    %fs
  popl %es
8010506c:	07                   	pop    %es
  popl %ds
8010506d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010506e:	83 c4 08             	add    $0x8,%esp
  iret
80105071:	cf                   	iret   

80105072 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105072:	f3 0f 1e fb          	endbr32 
80105076:	55                   	push   %ebp
80105077:	89 e5                	mov    %esp,%ebp
80105079:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010507c:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105081:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105088:	66 89 14 c5 00 62 11 	mov    %dx,-0x7fee9e00(,%eax,8)
8010508f:	80 
80105090:	66 c7 04 c5 02 62 11 	movw   $0x8,-0x7fee9dfe(,%eax,8)
80105097:	80 08 00 
8010509a:	c6 04 c5 04 62 11 80 	movb   $0x0,-0x7fee9dfc(,%eax,8)
801050a1:	00 
801050a2:	c6 04 c5 05 62 11 80 	movb   $0x8e,-0x7fee9dfb(,%eax,8)
801050a9:	8e 
801050aa:	c1 ea 10             	shr    $0x10,%edx
801050ad:	66 89 14 c5 06 62 11 	mov    %dx,-0x7fee9dfa(,%eax,8)
801050b4:	80 
  for(i = 0; i < 256; i++)
801050b5:	83 c0 01             	add    $0x1,%eax
801050b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801050bd:	75 c2                	jne    80105081 <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801050bf:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801050c4:	66 a3 00 64 11 80    	mov    %ax,0x80116400
801050ca:	66 c7 05 02 64 11 80 	movw   $0x8,0x80116402
801050d1:	08 00 
801050d3:	c6 05 04 64 11 80 00 	movb   $0x0,0x80116404
801050da:	c6 05 05 64 11 80 ef 	movb   $0xef,0x80116405
801050e1:	c1 e8 10             	shr    $0x10,%eax
801050e4:	66 a3 06 64 11 80    	mov    %ax,0x80116406

  initlock(&tickslock, "time");
801050ea:	83 ec 08             	sub    $0x8,%esp
801050ed:	68 41 80 10 80       	push   $0x80108041
801050f2:	68 c0 61 11 80       	push   $0x801161c0
801050f7:	e8 41 ec ff ff       	call   80103d3d <initlock>
}
801050fc:	83 c4 10             	add    $0x10,%esp
801050ff:	c9                   	leave  
80105100:	c3                   	ret    

80105101 <idtinit>:

void
idtinit(void)
{
80105101:	f3 0f 1e fb          	endbr32 
80105105:	55                   	push   %ebp
80105106:	89 e5                	mov    %esp,%ebp
80105108:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010510b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105111:	b8 00 62 11 80       	mov    $0x80116200,%eax
80105116:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010511a:	c1 e8 10             	shr    $0x10,%eax
8010511d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105121:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105124:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105127:	c9                   	leave  
80105128:	c3                   	ret    

80105129 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105129:	f3 0f 1e fb          	endbr32 
8010512d:	55                   	push   %ebp
8010512e:	89 e5                	mov    %esp,%ebp
80105130:	57                   	push   %edi
80105131:	56                   	push   %esi
80105132:	53                   	push   %ebx
80105133:	83 ec 1c             	sub    $0x1c,%esp
80105136:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105139:	8b 43 30             	mov    0x30(%ebx),%eax
8010513c:	83 f8 40             	cmp    $0x40,%eax
8010513f:	74 14                	je     80105155 <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105141:	83 e8 20             	sub    $0x20,%eax
80105144:	83 f8 1f             	cmp    $0x1f,%eax
80105147:	0f 87 38 01 00 00    	ja     80105285 <trap+0x15c>
8010514d:	3e ff 24 85 e8 80 10 	notrack jmp *-0x7fef7f18(,%eax,4)
80105154:	80 
    if(myproc()->killed)
80105155:	e8 90 e2 ff ff       	call   801033ea <myproc>
8010515a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010515e:	75 1f                	jne    8010517f <trap+0x56>
    myproc()->tf = tf;
80105160:	e8 85 e2 ff ff       	call   801033ea <myproc>
80105165:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105168:	e8 40 f1 ff ff       	call   801042ad <syscall>
    if(myproc()->killed)
8010516d:	e8 78 e2 ff ff       	call   801033ea <myproc>
80105172:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105176:	74 7e                	je     801051f6 <trap+0xcd>
      exit();
80105178:	e8 36 e6 ff ff       	call   801037b3 <exit>
8010517d:	eb 77                	jmp    801051f6 <trap+0xcd>
      exit();
8010517f:	e8 2f e6 ff ff       	call   801037b3 <exit>
80105184:	eb da                	jmp    80105160 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105186:	e8 40 e2 ff ff       	call   801033cb <cpuid>
8010518b:	85 c0                	test   %eax,%eax
8010518d:	74 6f                	je     801051fe <trap+0xd5>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010518f:	e8 8a d3 ff ff       	call   8010251e <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105194:	e8 51 e2 ff ff       	call   801033ea <myproc>
80105199:	85 c0                	test   %eax,%eax
8010519b:	74 1c                	je     801051b9 <trap+0x90>
8010519d:	e8 48 e2 ff ff       	call   801033ea <myproc>
801051a2:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051a6:	74 11                	je     801051b9 <trap+0x90>
801051a8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801051ac:	83 e0 03             	and    $0x3,%eax
801051af:	66 83 f8 03          	cmp    $0x3,%ax
801051b3:	0f 84 62 01 00 00    	je     8010531b <trap+0x1f2>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801051b9:	e8 2c e2 ff ff       	call   801033ea <myproc>
801051be:	85 c0                	test   %eax,%eax
801051c0:	74 0f                	je     801051d1 <trap+0xa8>
801051c2:	e8 23 e2 ff ff       	call   801033ea <myproc>
801051c7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801051cb:	0f 84 54 01 00 00    	je     80105325 <trap+0x1fc>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801051d1:	e8 14 e2 ff ff       	call   801033ea <myproc>
801051d6:	85 c0                	test   %eax,%eax
801051d8:	74 1c                	je     801051f6 <trap+0xcd>
801051da:	e8 0b e2 ff ff       	call   801033ea <myproc>
801051df:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051e3:	74 11                	je     801051f6 <trap+0xcd>
801051e5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801051e9:	83 e0 03             	and    $0x3,%eax
801051ec:	66 83 f8 03          	cmp    $0x3,%ax
801051f0:	0f 84 43 01 00 00    	je     80105339 <trap+0x210>
    exit();
}
801051f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f9:	5b                   	pop    %ebx
801051fa:	5e                   	pop    %esi
801051fb:	5f                   	pop    %edi
801051fc:	5d                   	pop    %ebp
801051fd:	c3                   	ret    
      acquire(&tickslock);
801051fe:	83 ec 0c             	sub    $0xc,%esp
80105201:	68 c0 61 11 80       	push   $0x801161c0
80105206:	e8 8e ec ff ff       	call   80103e99 <acquire>
      ticks++;
8010520b:	83 05 00 6a 11 80 01 	addl   $0x1,0x80116a00
      wakeup(&ticks);
80105212:	c7 04 24 00 6a 11 80 	movl   $0x80116a00,(%esp)
80105219:	e8 1c e8 ff ff       	call   80103a3a <wakeup>
      release(&tickslock);
8010521e:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80105225:	e8 da ec ff ff       	call   80103f04 <release>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	e9 5d ff ff ff       	jmp    8010518f <trap+0x66>
    ideintr();
80105232:	e8 1d cc ff ff       	call   80101e54 <ideintr>
    lapiceoi();
80105237:	e8 e2 d2 ff ff       	call   8010251e <lapiceoi>
    break;
8010523c:	e9 53 ff ff ff       	jmp    80105194 <trap+0x6b>
    kbdintr();
80105241:	e8 06 d1 ff ff       	call   8010234c <kbdintr>
    lapiceoi();
80105246:	e8 d3 d2 ff ff       	call   8010251e <lapiceoi>
    break;
8010524b:	e9 44 ff ff ff       	jmp    80105194 <trap+0x6b>
    uartintr();
80105250:	e8 21 02 00 00       	call   80105476 <uartintr>
    lapiceoi();
80105255:	e8 c4 d2 ff ff       	call   8010251e <lapiceoi>
    break;
8010525a:	e9 35 ff ff ff       	jmp    80105194 <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010525f:	8b 7b 38             	mov    0x38(%ebx),%edi
80105262:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105266:	e8 60 e1 ff ff       	call   801033cb <cpuid>
8010526b:	57                   	push   %edi
8010526c:	56                   	push   %esi
8010526d:	50                   	push   %eax
8010526e:	68 4c 80 10 80       	push   $0x8010804c
80105273:	e8 b4 b3 ff ff       	call   8010062c <cprintf>
    lapiceoi();
80105278:	e8 a1 d2 ff ff       	call   8010251e <lapiceoi>
    break;
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	e9 0f ff ff ff       	jmp    80105194 <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105285:	e8 60 e1 ff ff       	call   801033ea <myproc>
8010528a:	85 c0                	test   %eax,%eax
8010528c:	74 62                	je     801052f0 <trap+0x1c7>
8010528e:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105292:	74 5c                	je     801052f0 <trap+0x1c7>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105294:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105297:	8b 73 38             	mov    0x38(%ebx),%esi
8010529a:	e8 2c e1 ff ff       	call   801033cb <cpuid>
8010529f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801052a2:	8b 4b 34             	mov    0x34(%ebx),%ecx
801052a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801052a8:	8b 53 30             	mov    0x30(%ebx),%edx
801052ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801052ae:	e8 37 e1 ff ff       	call   801033ea <myproc>
801052b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
801052b6:	e8 2f e1 ff ff       	call   801033ea <myproc>
801052bb:	89 c2                	mov    %eax,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801052bd:	57                   	push   %edi
801052be:	56                   	push   %esi
801052bf:	ff 75 e4             	pushl  -0x1c(%ebp)
801052c2:	ff 75 e0             	pushl  -0x20(%ebp)
801052c5:	ff 75 dc             	pushl  -0x24(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801052c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801052cb:	83 c0 6c             	add    $0x6c,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801052ce:	50                   	push   %eax
801052cf:	ff 72 10             	pushl  0x10(%edx)
801052d2:	68 a4 80 10 80       	push   $0x801080a4
801052d7:	e8 50 b3 ff ff       	call   8010062c <cprintf>
    myproc()->killed = 1;
801052dc:	83 c4 20             	add    $0x20,%esp
801052df:	e8 06 e1 ff ff       	call   801033ea <myproc>
801052e4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801052eb:	e9 a4 fe ff ff       	jmp    80105194 <trap+0x6b>
801052f0:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801052f3:	8b 73 38             	mov    0x38(%ebx),%esi
801052f6:	e8 d0 e0 ff ff       	call   801033cb <cpuid>
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	57                   	push   %edi
801052ff:	56                   	push   %esi
80105300:	50                   	push   %eax
80105301:	ff 73 30             	pushl  0x30(%ebx)
80105304:	68 70 80 10 80       	push   $0x80108070
80105309:	e8 1e b3 ff ff       	call   8010062c <cprintf>
      panic("trap");
8010530e:	83 c4 14             	add    $0x14,%esp
80105311:	68 46 80 10 80       	push   $0x80108046
80105316:	e8 3d b0 ff ff       	call   80100358 <panic>
    exit();
8010531b:	e8 93 e4 ff ff       	call   801037b3 <exit>
80105320:	e9 94 fe ff ff       	jmp    801051b9 <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
80105325:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105329:	0f 85 a2 fe ff ff    	jne    801051d1 <trap+0xa8>
    yield();
8010532f:	e8 4a e5 ff ff       	call   8010387e <yield>
80105334:	e9 98 fe ff ff       	jmp    801051d1 <trap+0xa8>
    exit();
80105339:	e8 75 e4 ff ff       	call   801037b3 <exit>
8010533e:	e9 b3 fe ff ff       	jmp    801051f6 <trap+0xcd>

80105343 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105343:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105347:	83 3d bc b5 10 80 00 	cmpl   $0x0,0x8010b5bc
8010534e:	74 14                	je     80105364 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105350:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105355:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105356:	a8 01                	test   $0x1,%al
80105358:	74 10                	je     8010536a <uartgetc+0x27>
8010535a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010535f:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105360:	0f b6 c0             	movzbl %al,%eax
80105363:	c3                   	ret    
    return -1;
80105364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105369:	c3                   	ret    
    return -1;
8010536a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010536f:	c3                   	ret    

80105370 <uartputc>:
{
80105370:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105374:	83 3d bc b5 10 80 00 	cmpl   $0x0,0x8010b5bc
8010537b:	74 4f                	je     801053cc <uartputc+0x5c>
{
8010537d:	55                   	push   %ebp
8010537e:	89 e5                	mov    %esp,%ebp
80105380:	56                   	push   %esi
80105381:	53                   	push   %ebx
80105382:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105387:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105388:	a8 20                	test   $0x20,%al
8010538a:	75 30                	jne    801053bc <uartputc+0x4c>
    microdelay(10);
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	6a 0a                	push   $0xa
80105391:	e8 ad d1 ff ff       	call   80102543 <microdelay>
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	bb 7f 00 00 00       	mov    $0x7f,%ebx
8010539e:	be fd 03 00 00       	mov    $0x3fd,%esi
801053a3:	89 f2                	mov    %esi,%edx
801053a5:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053a6:	a8 20                	test   $0x20,%al
801053a8:	75 12                	jne    801053bc <uartputc+0x4c>
    microdelay(10);
801053aa:	83 ec 0c             	sub    $0xc,%esp
801053ad:	6a 0a                	push   $0xa
801053af:	e8 8f d1 ff ff       	call   80102543 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	83 eb 01             	sub    $0x1,%ebx
801053ba:	75 e7                	jne    801053a3 <uartputc+0x33>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801053bc:	8b 45 08             	mov    0x8(%ebp),%eax
801053bf:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053c4:	ee                   	out    %al,(%dx)
}
801053c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c8:	5b                   	pop    %ebx
801053c9:	5e                   	pop    %esi
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
801053cc:	c3                   	ret    

801053cd <uartinit>:
{
801053cd:	f3 0f 1e fb          	endbr32 
801053d1:	55                   	push   %ebp
801053d2:	89 e5                	mov    %esp,%ebp
801053d4:	56                   	push   %esi
801053d5:	53                   	push   %ebx
801053d6:	b9 00 00 00 00       	mov    $0x0,%ecx
801053db:	ba fa 03 00 00       	mov    $0x3fa,%edx
801053e0:	89 c8                	mov    %ecx,%eax
801053e2:	ee                   	out    %al,(%dx)
801053e3:	be fb 03 00 00       	mov    $0x3fb,%esi
801053e8:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801053ed:	89 f2                	mov    %esi,%edx
801053ef:	ee                   	out    %al,(%dx)
801053f0:	b8 0c 00 00 00       	mov    $0xc,%eax
801053f5:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053fa:	ee                   	out    %al,(%dx)
801053fb:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105400:	89 c8                	mov    %ecx,%eax
80105402:	89 da                	mov    %ebx,%edx
80105404:	ee                   	out    %al,(%dx)
80105405:	b8 03 00 00 00       	mov    $0x3,%eax
8010540a:	89 f2                	mov    %esi,%edx
8010540c:	ee                   	out    %al,(%dx)
8010540d:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105412:	89 c8                	mov    %ecx,%eax
80105414:	ee                   	out    %al,(%dx)
80105415:	b8 01 00 00 00       	mov    $0x1,%eax
8010541a:	89 da                	mov    %ebx,%edx
8010541c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010541d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105422:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105423:	3c ff                	cmp    $0xff,%al
80105425:	74 48                	je     8010546f <uartinit+0xa2>
  uart = 1;
80105427:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
8010542e:	00 00 00 
80105431:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105436:	ec                   	in     (%dx),%al
80105437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010543c:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010543d:	83 ec 08             	sub    $0x8,%esp
80105440:	6a 00                	push   $0x0
80105442:	6a 04                	push   $0x4
80105444:	e8 3b cc ff ff       	call   80102084 <ioapicenable>
80105449:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010544c:	bb 68 81 10 80       	mov    $0x80108168,%ebx
80105451:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
80105456:	83 ec 0c             	sub    $0xc,%esp
80105459:	0f be c0             	movsbl %al,%eax
8010545c:	50                   	push   %eax
8010545d:	e8 0e ff ff ff       	call   80105370 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105462:	83 c3 01             	add    $0x1,%ebx
80105465:	0f b6 03             	movzbl (%ebx),%eax
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	84 c0                	test   %al,%al
8010546d:	75 e7                	jne    80105456 <uartinit+0x89>
}
8010546f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105472:	5b                   	pop    %ebx
80105473:	5e                   	pop    %esi
80105474:	5d                   	pop    %ebp
80105475:	c3                   	ret    

80105476 <uartintr>:

void
uartintr(void)
{
80105476:	f3 0f 1e fb          	endbr32 
8010547a:	55                   	push   %ebp
8010547b:	89 e5                	mov    %esp,%ebp
8010547d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105480:	68 43 53 10 80       	push   $0x80105343
80105485:	e8 01 b3 ff ff       	call   8010078b <consoleintr>
}
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	c9                   	leave  
8010548e:	c3                   	ret    

8010548f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010548f:	6a 00                	push   $0x0
  pushl $0
80105491:	6a 00                	push   $0x0
  jmp alltraps
80105493:	e9 b7 fb ff ff       	jmp    8010504f <alltraps>

80105498 <vector1>:
.globl vector1
vector1:
  pushl $0
80105498:	6a 00                	push   $0x0
  pushl $1
8010549a:	6a 01                	push   $0x1
  jmp alltraps
8010549c:	e9 ae fb ff ff       	jmp    8010504f <alltraps>

801054a1 <vector2>:
.globl vector2
vector2:
  pushl $0
801054a1:	6a 00                	push   $0x0
  pushl $2
801054a3:	6a 02                	push   $0x2
  jmp alltraps
801054a5:	e9 a5 fb ff ff       	jmp    8010504f <alltraps>

801054aa <vector3>:
.globl vector3
vector3:
  pushl $0
801054aa:	6a 00                	push   $0x0
  pushl $3
801054ac:	6a 03                	push   $0x3
  jmp alltraps
801054ae:	e9 9c fb ff ff       	jmp    8010504f <alltraps>

801054b3 <vector4>:
.globl vector4
vector4:
  pushl $0
801054b3:	6a 00                	push   $0x0
  pushl $4
801054b5:	6a 04                	push   $0x4
  jmp alltraps
801054b7:	e9 93 fb ff ff       	jmp    8010504f <alltraps>

801054bc <vector5>:
.globl vector5
vector5:
  pushl $0
801054bc:	6a 00                	push   $0x0
  pushl $5
801054be:	6a 05                	push   $0x5
  jmp alltraps
801054c0:	e9 8a fb ff ff       	jmp    8010504f <alltraps>

801054c5 <vector6>:
.globl vector6
vector6:
  pushl $0
801054c5:	6a 00                	push   $0x0
  pushl $6
801054c7:	6a 06                	push   $0x6
  jmp alltraps
801054c9:	e9 81 fb ff ff       	jmp    8010504f <alltraps>

801054ce <vector7>:
.globl vector7
vector7:
  pushl $0
801054ce:	6a 00                	push   $0x0
  pushl $7
801054d0:	6a 07                	push   $0x7
  jmp alltraps
801054d2:	e9 78 fb ff ff       	jmp    8010504f <alltraps>

801054d7 <vector8>:
.globl vector8
vector8:
  pushl $8
801054d7:	6a 08                	push   $0x8
  jmp alltraps
801054d9:	e9 71 fb ff ff       	jmp    8010504f <alltraps>

801054de <vector9>:
.globl vector9
vector9:
  pushl $0
801054de:	6a 00                	push   $0x0
  pushl $9
801054e0:	6a 09                	push   $0x9
  jmp alltraps
801054e2:	e9 68 fb ff ff       	jmp    8010504f <alltraps>

801054e7 <vector10>:
.globl vector10
vector10:
  pushl $10
801054e7:	6a 0a                	push   $0xa
  jmp alltraps
801054e9:	e9 61 fb ff ff       	jmp    8010504f <alltraps>

801054ee <vector11>:
.globl vector11
vector11:
  pushl $11
801054ee:	6a 0b                	push   $0xb
  jmp alltraps
801054f0:	e9 5a fb ff ff       	jmp    8010504f <alltraps>

801054f5 <vector12>:
.globl vector12
vector12:
  pushl $12
801054f5:	6a 0c                	push   $0xc
  jmp alltraps
801054f7:	e9 53 fb ff ff       	jmp    8010504f <alltraps>

801054fc <vector13>:
.globl vector13
vector13:
  pushl $13
801054fc:	6a 0d                	push   $0xd
  jmp alltraps
801054fe:	e9 4c fb ff ff       	jmp    8010504f <alltraps>

80105503 <vector14>:
.globl vector14
vector14:
  pushl $14
80105503:	6a 0e                	push   $0xe
  jmp alltraps
80105505:	e9 45 fb ff ff       	jmp    8010504f <alltraps>

8010550a <vector15>:
.globl vector15
vector15:
  pushl $0
8010550a:	6a 00                	push   $0x0
  pushl $15
8010550c:	6a 0f                	push   $0xf
  jmp alltraps
8010550e:	e9 3c fb ff ff       	jmp    8010504f <alltraps>

80105513 <vector16>:
.globl vector16
vector16:
  pushl $0
80105513:	6a 00                	push   $0x0
  pushl $16
80105515:	6a 10                	push   $0x10
  jmp alltraps
80105517:	e9 33 fb ff ff       	jmp    8010504f <alltraps>

8010551c <vector17>:
.globl vector17
vector17:
  pushl $17
8010551c:	6a 11                	push   $0x11
  jmp alltraps
8010551e:	e9 2c fb ff ff       	jmp    8010504f <alltraps>

80105523 <vector18>:
.globl vector18
vector18:
  pushl $0
80105523:	6a 00                	push   $0x0
  pushl $18
80105525:	6a 12                	push   $0x12
  jmp alltraps
80105527:	e9 23 fb ff ff       	jmp    8010504f <alltraps>

8010552c <vector19>:
.globl vector19
vector19:
  pushl $0
8010552c:	6a 00                	push   $0x0
  pushl $19
8010552e:	6a 13                	push   $0x13
  jmp alltraps
80105530:	e9 1a fb ff ff       	jmp    8010504f <alltraps>

80105535 <vector20>:
.globl vector20
vector20:
  pushl $0
80105535:	6a 00                	push   $0x0
  pushl $20
80105537:	6a 14                	push   $0x14
  jmp alltraps
80105539:	e9 11 fb ff ff       	jmp    8010504f <alltraps>

8010553e <vector21>:
.globl vector21
vector21:
  pushl $0
8010553e:	6a 00                	push   $0x0
  pushl $21
80105540:	6a 15                	push   $0x15
  jmp alltraps
80105542:	e9 08 fb ff ff       	jmp    8010504f <alltraps>

80105547 <vector22>:
.globl vector22
vector22:
  pushl $0
80105547:	6a 00                	push   $0x0
  pushl $22
80105549:	6a 16                	push   $0x16
  jmp alltraps
8010554b:	e9 ff fa ff ff       	jmp    8010504f <alltraps>

80105550 <vector23>:
.globl vector23
vector23:
  pushl $0
80105550:	6a 00                	push   $0x0
  pushl $23
80105552:	6a 17                	push   $0x17
  jmp alltraps
80105554:	e9 f6 fa ff ff       	jmp    8010504f <alltraps>

80105559 <vector24>:
.globl vector24
vector24:
  pushl $0
80105559:	6a 00                	push   $0x0
  pushl $24
8010555b:	6a 18                	push   $0x18
  jmp alltraps
8010555d:	e9 ed fa ff ff       	jmp    8010504f <alltraps>

80105562 <vector25>:
.globl vector25
vector25:
  pushl $0
80105562:	6a 00                	push   $0x0
  pushl $25
80105564:	6a 19                	push   $0x19
  jmp alltraps
80105566:	e9 e4 fa ff ff       	jmp    8010504f <alltraps>

8010556b <vector26>:
.globl vector26
vector26:
  pushl $0
8010556b:	6a 00                	push   $0x0
  pushl $26
8010556d:	6a 1a                	push   $0x1a
  jmp alltraps
8010556f:	e9 db fa ff ff       	jmp    8010504f <alltraps>

80105574 <vector27>:
.globl vector27
vector27:
  pushl $0
80105574:	6a 00                	push   $0x0
  pushl $27
80105576:	6a 1b                	push   $0x1b
  jmp alltraps
80105578:	e9 d2 fa ff ff       	jmp    8010504f <alltraps>

8010557d <vector28>:
.globl vector28
vector28:
  pushl $0
8010557d:	6a 00                	push   $0x0
  pushl $28
8010557f:	6a 1c                	push   $0x1c
  jmp alltraps
80105581:	e9 c9 fa ff ff       	jmp    8010504f <alltraps>

80105586 <vector29>:
.globl vector29
vector29:
  pushl $0
80105586:	6a 00                	push   $0x0
  pushl $29
80105588:	6a 1d                	push   $0x1d
  jmp alltraps
8010558a:	e9 c0 fa ff ff       	jmp    8010504f <alltraps>

8010558f <vector30>:
.globl vector30
vector30:
  pushl $0
8010558f:	6a 00                	push   $0x0
  pushl $30
80105591:	6a 1e                	push   $0x1e
  jmp alltraps
80105593:	e9 b7 fa ff ff       	jmp    8010504f <alltraps>

80105598 <vector31>:
.globl vector31
vector31:
  pushl $0
80105598:	6a 00                	push   $0x0
  pushl $31
8010559a:	6a 1f                	push   $0x1f
  jmp alltraps
8010559c:	e9 ae fa ff ff       	jmp    8010504f <alltraps>

801055a1 <vector32>:
.globl vector32
vector32:
  pushl $0
801055a1:	6a 00                	push   $0x0
  pushl $32
801055a3:	6a 20                	push   $0x20
  jmp alltraps
801055a5:	e9 a5 fa ff ff       	jmp    8010504f <alltraps>

801055aa <vector33>:
.globl vector33
vector33:
  pushl $0
801055aa:	6a 00                	push   $0x0
  pushl $33
801055ac:	6a 21                	push   $0x21
  jmp alltraps
801055ae:	e9 9c fa ff ff       	jmp    8010504f <alltraps>

801055b3 <vector34>:
.globl vector34
vector34:
  pushl $0
801055b3:	6a 00                	push   $0x0
  pushl $34
801055b5:	6a 22                	push   $0x22
  jmp alltraps
801055b7:	e9 93 fa ff ff       	jmp    8010504f <alltraps>

801055bc <vector35>:
.globl vector35
vector35:
  pushl $0
801055bc:	6a 00                	push   $0x0
  pushl $35
801055be:	6a 23                	push   $0x23
  jmp alltraps
801055c0:	e9 8a fa ff ff       	jmp    8010504f <alltraps>

801055c5 <vector36>:
.globl vector36
vector36:
  pushl $0
801055c5:	6a 00                	push   $0x0
  pushl $36
801055c7:	6a 24                	push   $0x24
  jmp alltraps
801055c9:	e9 81 fa ff ff       	jmp    8010504f <alltraps>

801055ce <vector37>:
.globl vector37
vector37:
  pushl $0
801055ce:	6a 00                	push   $0x0
  pushl $37
801055d0:	6a 25                	push   $0x25
  jmp alltraps
801055d2:	e9 78 fa ff ff       	jmp    8010504f <alltraps>

801055d7 <vector38>:
.globl vector38
vector38:
  pushl $0
801055d7:	6a 00                	push   $0x0
  pushl $38
801055d9:	6a 26                	push   $0x26
  jmp alltraps
801055db:	e9 6f fa ff ff       	jmp    8010504f <alltraps>

801055e0 <vector39>:
.globl vector39
vector39:
  pushl $0
801055e0:	6a 00                	push   $0x0
  pushl $39
801055e2:	6a 27                	push   $0x27
  jmp alltraps
801055e4:	e9 66 fa ff ff       	jmp    8010504f <alltraps>

801055e9 <vector40>:
.globl vector40
vector40:
  pushl $0
801055e9:	6a 00                	push   $0x0
  pushl $40
801055eb:	6a 28                	push   $0x28
  jmp alltraps
801055ed:	e9 5d fa ff ff       	jmp    8010504f <alltraps>

801055f2 <vector41>:
.globl vector41
vector41:
  pushl $0
801055f2:	6a 00                	push   $0x0
  pushl $41
801055f4:	6a 29                	push   $0x29
  jmp alltraps
801055f6:	e9 54 fa ff ff       	jmp    8010504f <alltraps>

801055fb <vector42>:
.globl vector42
vector42:
  pushl $0
801055fb:	6a 00                	push   $0x0
  pushl $42
801055fd:	6a 2a                	push   $0x2a
  jmp alltraps
801055ff:	e9 4b fa ff ff       	jmp    8010504f <alltraps>

80105604 <vector43>:
.globl vector43
vector43:
  pushl $0
80105604:	6a 00                	push   $0x0
  pushl $43
80105606:	6a 2b                	push   $0x2b
  jmp alltraps
80105608:	e9 42 fa ff ff       	jmp    8010504f <alltraps>

8010560d <vector44>:
.globl vector44
vector44:
  pushl $0
8010560d:	6a 00                	push   $0x0
  pushl $44
8010560f:	6a 2c                	push   $0x2c
  jmp alltraps
80105611:	e9 39 fa ff ff       	jmp    8010504f <alltraps>

80105616 <vector45>:
.globl vector45
vector45:
  pushl $0
80105616:	6a 00                	push   $0x0
  pushl $45
80105618:	6a 2d                	push   $0x2d
  jmp alltraps
8010561a:	e9 30 fa ff ff       	jmp    8010504f <alltraps>

8010561f <vector46>:
.globl vector46
vector46:
  pushl $0
8010561f:	6a 00                	push   $0x0
  pushl $46
80105621:	6a 2e                	push   $0x2e
  jmp alltraps
80105623:	e9 27 fa ff ff       	jmp    8010504f <alltraps>

80105628 <vector47>:
.globl vector47
vector47:
  pushl $0
80105628:	6a 00                	push   $0x0
  pushl $47
8010562a:	6a 2f                	push   $0x2f
  jmp alltraps
8010562c:	e9 1e fa ff ff       	jmp    8010504f <alltraps>

80105631 <vector48>:
.globl vector48
vector48:
  pushl $0
80105631:	6a 00                	push   $0x0
  pushl $48
80105633:	6a 30                	push   $0x30
  jmp alltraps
80105635:	e9 15 fa ff ff       	jmp    8010504f <alltraps>

8010563a <vector49>:
.globl vector49
vector49:
  pushl $0
8010563a:	6a 00                	push   $0x0
  pushl $49
8010563c:	6a 31                	push   $0x31
  jmp alltraps
8010563e:	e9 0c fa ff ff       	jmp    8010504f <alltraps>

80105643 <vector50>:
.globl vector50
vector50:
  pushl $0
80105643:	6a 00                	push   $0x0
  pushl $50
80105645:	6a 32                	push   $0x32
  jmp alltraps
80105647:	e9 03 fa ff ff       	jmp    8010504f <alltraps>

8010564c <vector51>:
.globl vector51
vector51:
  pushl $0
8010564c:	6a 00                	push   $0x0
  pushl $51
8010564e:	6a 33                	push   $0x33
  jmp alltraps
80105650:	e9 fa f9 ff ff       	jmp    8010504f <alltraps>

80105655 <vector52>:
.globl vector52
vector52:
  pushl $0
80105655:	6a 00                	push   $0x0
  pushl $52
80105657:	6a 34                	push   $0x34
  jmp alltraps
80105659:	e9 f1 f9 ff ff       	jmp    8010504f <alltraps>

8010565e <vector53>:
.globl vector53
vector53:
  pushl $0
8010565e:	6a 00                	push   $0x0
  pushl $53
80105660:	6a 35                	push   $0x35
  jmp alltraps
80105662:	e9 e8 f9 ff ff       	jmp    8010504f <alltraps>

80105667 <vector54>:
.globl vector54
vector54:
  pushl $0
80105667:	6a 00                	push   $0x0
  pushl $54
80105669:	6a 36                	push   $0x36
  jmp alltraps
8010566b:	e9 df f9 ff ff       	jmp    8010504f <alltraps>

80105670 <vector55>:
.globl vector55
vector55:
  pushl $0
80105670:	6a 00                	push   $0x0
  pushl $55
80105672:	6a 37                	push   $0x37
  jmp alltraps
80105674:	e9 d6 f9 ff ff       	jmp    8010504f <alltraps>

80105679 <vector56>:
.globl vector56
vector56:
  pushl $0
80105679:	6a 00                	push   $0x0
  pushl $56
8010567b:	6a 38                	push   $0x38
  jmp alltraps
8010567d:	e9 cd f9 ff ff       	jmp    8010504f <alltraps>

80105682 <vector57>:
.globl vector57
vector57:
  pushl $0
80105682:	6a 00                	push   $0x0
  pushl $57
80105684:	6a 39                	push   $0x39
  jmp alltraps
80105686:	e9 c4 f9 ff ff       	jmp    8010504f <alltraps>

8010568b <vector58>:
.globl vector58
vector58:
  pushl $0
8010568b:	6a 00                	push   $0x0
  pushl $58
8010568d:	6a 3a                	push   $0x3a
  jmp alltraps
8010568f:	e9 bb f9 ff ff       	jmp    8010504f <alltraps>

80105694 <vector59>:
.globl vector59
vector59:
  pushl $0
80105694:	6a 00                	push   $0x0
  pushl $59
80105696:	6a 3b                	push   $0x3b
  jmp alltraps
80105698:	e9 b2 f9 ff ff       	jmp    8010504f <alltraps>

8010569d <vector60>:
.globl vector60
vector60:
  pushl $0
8010569d:	6a 00                	push   $0x0
  pushl $60
8010569f:	6a 3c                	push   $0x3c
  jmp alltraps
801056a1:	e9 a9 f9 ff ff       	jmp    8010504f <alltraps>

801056a6 <vector61>:
.globl vector61
vector61:
  pushl $0
801056a6:	6a 00                	push   $0x0
  pushl $61
801056a8:	6a 3d                	push   $0x3d
  jmp alltraps
801056aa:	e9 a0 f9 ff ff       	jmp    8010504f <alltraps>

801056af <vector62>:
.globl vector62
vector62:
  pushl $0
801056af:	6a 00                	push   $0x0
  pushl $62
801056b1:	6a 3e                	push   $0x3e
  jmp alltraps
801056b3:	e9 97 f9 ff ff       	jmp    8010504f <alltraps>

801056b8 <vector63>:
.globl vector63
vector63:
  pushl $0
801056b8:	6a 00                	push   $0x0
  pushl $63
801056ba:	6a 3f                	push   $0x3f
  jmp alltraps
801056bc:	e9 8e f9 ff ff       	jmp    8010504f <alltraps>

801056c1 <vector64>:
.globl vector64
vector64:
  pushl $0
801056c1:	6a 00                	push   $0x0
  pushl $64
801056c3:	6a 40                	push   $0x40
  jmp alltraps
801056c5:	e9 85 f9 ff ff       	jmp    8010504f <alltraps>

801056ca <vector65>:
.globl vector65
vector65:
  pushl $0
801056ca:	6a 00                	push   $0x0
  pushl $65
801056cc:	6a 41                	push   $0x41
  jmp alltraps
801056ce:	e9 7c f9 ff ff       	jmp    8010504f <alltraps>

801056d3 <vector66>:
.globl vector66
vector66:
  pushl $0
801056d3:	6a 00                	push   $0x0
  pushl $66
801056d5:	6a 42                	push   $0x42
  jmp alltraps
801056d7:	e9 73 f9 ff ff       	jmp    8010504f <alltraps>

801056dc <vector67>:
.globl vector67
vector67:
  pushl $0
801056dc:	6a 00                	push   $0x0
  pushl $67
801056de:	6a 43                	push   $0x43
  jmp alltraps
801056e0:	e9 6a f9 ff ff       	jmp    8010504f <alltraps>

801056e5 <vector68>:
.globl vector68
vector68:
  pushl $0
801056e5:	6a 00                	push   $0x0
  pushl $68
801056e7:	6a 44                	push   $0x44
  jmp alltraps
801056e9:	e9 61 f9 ff ff       	jmp    8010504f <alltraps>

801056ee <vector69>:
.globl vector69
vector69:
  pushl $0
801056ee:	6a 00                	push   $0x0
  pushl $69
801056f0:	6a 45                	push   $0x45
  jmp alltraps
801056f2:	e9 58 f9 ff ff       	jmp    8010504f <alltraps>

801056f7 <vector70>:
.globl vector70
vector70:
  pushl $0
801056f7:	6a 00                	push   $0x0
  pushl $70
801056f9:	6a 46                	push   $0x46
  jmp alltraps
801056fb:	e9 4f f9 ff ff       	jmp    8010504f <alltraps>

80105700 <vector71>:
.globl vector71
vector71:
  pushl $0
80105700:	6a 00                	push   $0x0
  pushl $71
80105702:	6a 47                	push   $0x47
  jmp alltraps
80105704:	e9 46 f9 ff ff       	jmp    8010504f <alltraps>

80105709 <vector72>:
.globl vector72
vector72:
  pushl $0
80105709:	6a 00                	push   $0x0
  pushl $72
8010570b:	6a 48                	push   $0x48
  jmp alltraps
8010570d:	e9 3d f9 ff ff       	jmp    8010504f <alltraps>

80105712 <vector73>:
.globl vector73
vector73:
  pushl $0
80105712:	6a 00                	push   $0x0
  pushl $73
80105714:	6a 49                	push   $0x49
  jmp alltraps
80105716:	e9 34 f9 ff ff       	jmp    8010504f <alltraps>

8010571b <vector74>:
.globl vector74
vector74:
  pushl $0
8010571b:	6a 00                	push   $0x0
  pushl $74
8010571d:	6a 4a                	push   $0x4a
  jmp alltraps
8010571f:	e9 2b f9 ff ff       	jmp    8010504f <alltraps>

80105724 <vector75>:
.globl vector75
vector75:
  pushl $0
80105724:	6a 00                	push   $0x0
  pushl $75
80105726:	6a 4b                	push   $0x4b
  jmp alltraps
80105728:	e9 22 f9 ff ff       	jmp    8010504f <alltraps>

8010572d <vector76>:
.globl vector76
vector76:
  pushl $0
8010572d:	6a 00                	push   $0x0
  pushl $76
8010572f:	6a 4c                	push   $0x4c
  jmp alltraps
80105731:	e9 19 f9 ff ff       	jmp    8010504f <alltraps>

80105736 <vector77>:
.globl vector77
vector77:
  pushl $0
80105736:	6a 00                	push   $0x0
  pushl $77
80105738:	6a 4d                	push   $0x4d
  jmp alltraps
8010573a:	e9 10 f9 ff ff       	jmp    8010504f <alltraps>

8010573f <vector78>:
.globl vector78
vector78:
  pushl $0
8010573f:	6a 00                	push   $0x0
  pushl $78
80105741:	6a 4e                	push   $0x4e
  jmp alltraps
80105743:	e9 07 f9 ff ff       	jmp    8010504f <alltraps>

80105748 <vector79>:
.globl vector79
vector79:
  pushl $0
80105748:	6a 00                	push   $0x0
  pushl $79
8010574a:	6a 4f                	push   $0x4f
  jmp alltraps
8010574c:	e9 fe f8 ff ff       	jmp    8010504f <alltraps>

80105751 <vector80>:
.globl vector80
vector80:
  pushl $0
80105751:	6a 00                	push   $0x0
  pushl $80
80105753:	6a 50                	push   $0x50
  jmp alltraps
80105755:	e9 f5 f8 ff ff       	jmp    8010504f <alltraps>

8010575a <vector81>:
.globl vector81
vector81:
  pushl $0
8010575a:	6a 00                	push   $0x0
  pushl $81
8010575c:	6a 51                	push   $0x51
  jmp alltraps
8010575e:	e9 ec f8 ff ff       	jmp    8010504f <alltraps>

80105763 <vector82>:
.globl vector82
vector82:
  pushl $0
80105763:	6a 00                	push   $0x0
  pushl $82
80105765:	6a 52                	push   $0x52
  jmp alltraps
80105767:	e9 e3 f8 ff ff       	jmp    8010504f <alltraps>

8010576c <vector83>:
.globl vector83
vector83:
  pushl $0
8010576c:	6a 00                	push   $0x0
  pushl $83
8010576e:	6a 53                	push   $0x53
  jmp alltraps
80105770:	e9 da f8 ff ff       	jmp    8010504f <alltraps>

80105775 <vector84>:
.globl vector84
vector84:
  pushl $0
80105775:	6a 00                	push   $0x0
  pushl $84
80105777:	6a 54                	push   $0x54
  jmp alltraps
80105779:	e9 d1 f8 ff ff       	jmp    8010504f <alltraps>

8010577e <vector85>:
.globl vector85
vector85:
  pushl $0
8010577e:	6a 00                	push   $0x0
  pushl $85
80105780:	6a 55                	push   $0x55
  jmp alltraps
80105782:	e9 c8 f8 ff ff       	jmp    8010504f <alltraps>

80105787 <vector86>:
.globl vector86
vector86:
  pushl $0
80105787:	6a 00                	push   $0x0
  pushl $86
80105789:	6a 56                	push   $0x56
  jmp alltraps
8010578b:	e9 bf f8 ff ff       	jmp    8010504f <alltraps>

80105790 <vector87>:
.globl vector87
vector87:
  pushl $0
80105790:	6a 00                	push   $0x0
  pushl $87
80105792:	6a 57                	push   $0x57
  jmp alltraps
80105794:	e9 b6 f8 ff ff       	jmp    8010504f <alltraps>

80105799 <vector88>:
.globl vector88
vector88:
  pushl $0
80105799:	6a 00                	push   $0x0
  pushl $88
8010579b:	6a 58                	push   $0x58
  jmp alltraps
8010579d:	e9 ad f8 ff ff       	jmp    8010504f <alltraps>

801057a2 <vector89>:
.globl vector89
vector89:
  pushl $0
801057a2:	6a 00                	push   $0x0
  pushl $89
801057a4:	6a 59                	push   $0x59
  jmp alltraps
801057a6:	e9 a4 f8 ff ff       	jmp    8010504f <alltraps>

801057ab <vector90>:
.globl vector90
vector90:
  pushl $0
801057ab:	6a 00                	push   $0x0
  pushl $90
801057ad:	6a 5a                	push   $0x5a
  jmp alltraps
801057af:	e9 9b f8 ff ff       	jmp    8010504f <alltraps>

801057b4 <vector91>:
.globl vector91
vector91:
  pushl $0
801057b4:	6a 00                	push   $0x0
  pushl $91
801057b6:	6a 5b                	push   $0x5b
  jmp alltraps
801057b8:	e9 92 f8 ff ff       	jmp    8010504f <alltraps>

801057bd <vector92>:
.globl vector92
vector92:
  pushl $0
801057bd:	6a 00                	push   $0x0
  pushl $92
801057bf:	6a 5c                	push   $0x5c
  jmp alltraps
801057c1:	e9 89 f8 ff ff       	jmp    8010504f <alltraps>

801057c6 <vector93>:
.globl vector93
vector93:
  pushl $0
801057c6:	6a 00                	push   $0x0
  pushl $93
801057c8:	6a 5d                	push   $0x5d
  jmp alltraps
801057ca:	e9 80 f8 ff ff       	jmp    8010504f <alltraps>

801057cf <vector94>:
.globl vector94
vector94:
  pushl $0
801057cf:	6a 00                	push   $0x0
  pushl $94
801057d1:	6a 5e                	push   $0x5e
  jmp alltraps
801057d3:	e9 77 f8 ff ff       	jmp    8010504f <alltraps>

801057d8 <vector95>:
.globl vector95
vector95:
  pushl $0
801057d8:	6a 00                	push   $0x0
  pushl $95
801057da:	6a 5f                	push   $0x5f
  jmp alltraps
801057dc:	e9 6e f8 ff ff       	jmp    8010504f <alltraps>

801057e1 <vector96>:
.globl vector96
vector96:
  pushl $0
801057e1:	6a 00                	push   $0x0
  pushl $96
801057e3:	6a 60                	push   $0x60
  jmp alltraps
801057e5:	e9 65 f8 ff ff       	jmp    8010504f <alltraps>

801057ea <vector97>:
.globl vector97
vector97:
  pushl $0
801057ea:	6a 00                	push   $0x0
  pushl $97
801057ec:	6a 61                	push   $0x61
  jmp alltraps
801057ee:	e9 5c f8 ff ff       	jmp    8010504f <alltraps>

801057f3 <vector98>:
.globl vector98
vector98:
  pushl $0
801057f3:	6a 00                	push   $0x0
  pushl $98
801057f5:	6a 62                	push   $0x62
  jmp alltraps
801057f7:	e9 53 f8 ff ff       	jmp    8010504f <alltraps>

801057fc <vector99>:
.globl vector99
vector99:
  pushl $0
801057fc:	6a 00                	push   $0x0
  pushl $99
801057fe:	6a 63                	push   $0x63
  jmp alltraps
80105800:	e9 4a f8 ff ff       	jmp    8010504f <alltraps>

80105805 <vector100>:
.globl vector100
vector100:
  pushl $0
80105805:	6a 00                	push   $0x0
  pushl $100
80105807:	6a 64                	push   $0x64
  jmp alltraps
80105809:	e9 41 f8 ff ff       	jmp    8010504f <alltraps>

8010580e <vector101>:
.globl vector101
vector101:
  pushl $0
8010580e:	6a 00                	push   $0x0
  pushl $101
80105810:	6a 65                	push   $0x65
  jmp alltraps
80105812:	e9 38 f8 ff ff       	jmp    8010504f <alltraps>

80105817 <vector102>:
.globl vector102
vector102:
  pushl $0
80105817:	6a 00                	push   $0x0
  pushl $102
80105819:	6a 66                	push   $0x66
  jmp alltraps
8010581b:	e9 2f f8 ff ff       	jmp    8010504f <alltraps>

80105820 <vector103>:
.globl vector103
vector103:
  pushl $0
80105820:	6a 00                	push   $0x0
  pushl $103
80105822:	6a 67                	push   $0x67
  jmp alltraps
80105824:	e9 26 f8 ff ff       	jmp    8010504f <alltraps>

80105829 <vector104>:
.globl vector104
vector104:
  pushl $0
80105829:	6a 00                	push   $0x0
  pushl $104
8010582b:	6a 68                	push   $0x68
  jmp alltraps
8010582d:	e9 1d f8 ff ff       	jmp    8010504f <alltraps>

80105832 <vector105>:
.globl vector105
vector105:
  pushl $0
80105832:	6a 00                	push   $0x0
  pushl $105
80105834:	6a 69                	push   $0x69
  jmp alltraps
80105836:	e9 14 f8 ff ff       	jmp    8010504f <alltraps>

8010583b <vector106>:
.globl vector106
vector106:
  pushl $0
8010583b:	6a 00                	push   $0x0
  pushl $106
8010583d:	6a 6a                	push   $0x6a
  jmp alltraps
8010583f:	e9 0b f8 ff ff       	jmp    8010504f <alltraps>

80105844 <vector107>:
.globl vector107
vector107:
  pushl $0
80105844:	6a 00                	push   $0x0
  pushl $107
80105846:	6a 6b                	push   $0x6b
  jmp alltraps
80105848:	e9 02 f8 ff ff       	jmp    8010504f <alltraps>

8010584d <vector108>:
.globl vector108
vector108:
  pushl $0
8010584d:	6a 00                	push   $0x0
  pushl $108
8010584f:	6a 6c                	push   $0x6c
  jmp alltraps
80105851:	e9 f9 f7 ff ff       	jmp    8010504f <alltraps>

80105856 <vector109>:
.globl vector109
vector109:
  pushl $0
80105856:	6a 00                	push   $0x0
  pushl $109
80105858:	6a 6d                	push   $0x6d
  jmp alltraps
8010585a:	e9 f0 f7 ff ff       	jmp    8010504f <alltraps>

8010585f <vector110>:
.globl vector110
vector110:
  pushl $0
8010585f:	6a 00                	push   $0x0
  pushl $110
80105861:	6a 6e                	push   $0x6e
  jmp alltraps
80105863:	e9 e7 f7 ff ff       	jmp    8010504f <alltraps>

80105868 <vector111>:
.globl vector111
vector111:
  pushl $0
80105868:	6a 00                	push   $0x0
  pushl $111
8010586a:	6a 6f                	push   $0x6f
  jmp alltraps
8010586c:	e9 de f7 ff ff       	jmp    8010504f <alltraps>

80105871 <vector112>:
.globl vector112
vector112:
  pushl $0
80105871:	6a 00                	push   $0x0
  pushl $112
80105873:	6a 70                	push   $0x70
  jmp alltraps
80105875:	e9 d5 f7 ff ff       	jmp    8010504f <alltraps>

8010587a <vector113>:
.globl vector113
vector113:
  pushl $0
8010587a:	6a 00                	push   $0x0
  pushl $113
8010587c:	6a 71                	push   $0x71
  jmp alltraps
8010587e:	e9 cc f7 ff ff       	jmp    8010504f <alltraps>

80105883 <vector114>:
.globl vector114
vector114:
  pushl $0
80105883:	6a 00                	push   $0x0
  pushl $114
80105885:	6a 72                	push   $0x72
  jmp alltraps
80105887:	e9 c3 f7 ff ff       	jmp    8010504f <alltraps>

8010588c <vector115>:
.globl vector115
vector115:
  pushl $0
8010588c:	6a 00                	push   $0x0
  pushl $115
8010588e:	6a 73                	push   $0x73
  jmp alltraps
80105890:	e9 ba f7 ff ff       	jmp    8010504f <alltraps>

80105895 <vector116>:
.globl vector116
vector116:
  pushl $0
80105895:	6a 00                	push   $0x0
  pushl $116
80105897:	6a 74                	push   $0x74
  jmp alltraps
80105899:	e9 b1 f7 ff ff       	jmp    8010504f <alltraps>

8010589e <vector117>:
.globl vector117
vector117:
  pushl $0
8010589e:	6a 00                	push   $0x0
  pushl $117
801058a0:	6a 75                	push   $0x75
  jmp alltraps
801058a2:	e9 a8 f7 ff ff       	jmp    8010504f <alltraps>

801058a7 <vector118>:
.globl vector118
vector118:
  pushl $0
801058a7:	6a 00                	push   $0x0
  pushl $118
801058a9:	6a 76                	push   $0x76
  jmp alltraps
801058ab:	e9 9f f7 ff ff       	jmp    8010504f <alltraps>

801058b0 <vector119>:
.globl vector119
vector119:
  pushl $0
801058b0:	6a 00                	push   $0x0
  pushl $119
801058b2:	6a 77                	push   $0x77
  jmp alltraps
801058b4:	e9 96 f7 ff ff       	jmp    8010504f <alltraps>

801058b9 <vector120>:
.globl vector120
vector120:
  pushl $0
801058b9:	6a 00                	push   $0x0
  pushl $120
801058bb:	6a 78                	push   $0x78
  jmp alltraps
801058bd:	e9 8d f7 ff ff       	jmp    8010504f <alltraps>

801058c2 <vector121>:
.globl vector121
vector121:
  pushl $0
801058c2:	6a 00                	push   $0x0
  pushl $121
801058c4:	6a 79                	push   $0x79
  jmp alltraps
801058c6:	e9 84 f7 ff ff       	jmp    8010504f <alltraps>

801058cb <vector122>:
.globl vector122
vector122:
  pushl $0
801058cb:	6a 00                	push   $0x0
  pushl $122
801058cd:	6a 7a                	push   $0x7a
  jmp alltraps
801058cf:	e9 7b f7 ff ff       	jmp    8010504f <alltraps>

801058d4 <vector123>:
.globl vector123
vector123:
  pushl $0
801058d4:	6a 00                	push   $0x0
  pushl $123
801058d6:	6a 7b                	push   $0x7b
  jmp alltraps
801058d8:	e9 72 f7 ff ff       	jmp    8010504f <alltraps>

801058dd <vector124>:
.globl vector124
vector124:
  pushl $0
801058dd:	6a 00                	push   $0x0
  pushl $124
801058df:	6a 7c                	push   $0x7c
  jmp alltraps
801058e1:	e9 69 f7 ff ff       	jmp    8010504f <alltraps>

801058e6 <vector125>:
.globl vector125
vector125:
  pushl $0
801058e6:	6a 00                	push   $0x0
  pushl $125
801058e8:	6a 7d                	push   $0x7d
  jmp alltraps
801058ea:	e9 60 f7 ff ff       	jmp    8010504f <alltraps>

801058ef <vector126>:
.globl vector126
vector126:
  pushl $0
801058ef:	6a 00                	push   $0x0
  pushl $126
801058f1:	6a 7e                	push   $0x7e
  jmp alltraps
801058f3:	e9 57 f7 ff ff       	jmp    8010504f <alltraps>

801058f8 <vector127>:
.globl vector127
vector127:
  pushl $0
801058f8:	6a 00                	push   $0x0
  pushl $127
801058fa:	6a 7f                	push   $0x7f
  jmp alltraps
801058fc:	e9 4e f7 ff ff       	jmp    8010504f <alltraps>

80105901 <vector128>:
.globl vector128
vector128:
  pushl $0
80105901:	6a 00                	push   $0x0
  pushl $128
80105903:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105908:	e9 42 f7 ff ff       	jmp    8010504f <alltraps>

8010590d <vector129>:
.globl vector129
vector129:
  pushl $0
8010590d:	6a 00                	push   $0x0
  pushl $129
8010590f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105914:	e9 36 f7 ff ff       	jmp    8010504f <alltraps>

80105919 <vector130>:
.globl vector130
vector130:
  pushl $0
80105919:	6a 00                	push   $0x0
  pushl $130
8010591b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105920:	e9 2a f7 ff ff       	jmp    8010504f <alltraps>

80105925 <vector131>:
.globl vector131
vector131:
  pushl $0
80105925:	6a 00                	push   $0x0
  pushl $131
80105927:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010592c:	e9 1e f7 ff ff       	jmp    8010504f <alltraps>

80105931 <vector132>:
.globl vector132
vector132:
  pushl $0
80105931:	6a 00                	push   $0x0
  pushl $132
80105933:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105938:	e9 12 f7 ff ff       	jmp    8010504f <alltraps>

8010593d <vector133>:
.globl vector133
vector133:
  pushl $0
8010593d:	6a 00                	push   $0x0
  pushl $133
8010593f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105944:	e9 06 f7 ff ff       	jmp    8010504f <alltraps>

80105949 <vector134>:
.globl vector134
vector134:
  pushl $0
80105949:	6a 00                	push   $0x0
  pushl $134
8010594b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105950:	e9 fa f6 ff ff       	jmp    8010504f <alltraps>

80105955 <vector135>:
.globl vector135
vector135:
  pushl $0
80105955:	6a 00                	push   $0x0
  pushl $135
80105957:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010595c:	e9 ee f6 ff ff       	jmp    8010504f <alltraps>

80105961 <vector136>:
.globl vector136
vector136:
  pushl $0
80105961:	6a 00                	push   $0x0
  pushl $136
80105963:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105968:	e9 e2 f6 ff ff       	jmp    8010504f <alltraps>

8010596d <vector137>:
.globl vector137
vector137:
  pushl $0
8010596d:	6a 00                	push   $0x0
  pushl $137
8010596f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105974:	e9 d6 f6 ff ff       	jmp    8010504f <alltraps>

80105979 <vector138>:
.globl vector138
vector138:
  pushl $0
80105979:	6a 00                	push   $0x0
  pushl $138
8010597b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105980:	e9 ca f6 ff ff       	jmp    8010504f <alltraps>

80105985 <vector139>:
.globl vector139
vector139:
  pushl $0
80105985:	6a 00                	push   $0x0
  pushl $139
80105987:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010598c:	e9 be f6 ff ff       	jmp    8010504f <alltraps>

80105991 <vector140>:
.globl vector140
vector140:
  pushl $0
80105991:	6a 00                	push   $0x0
  pushl $140
80105993:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105998:	e9 b2 f6 ff ff       	jmp    8010504f <alltraps>

8010599d <vector141>:
.globl vector141
vector141:
  pushl $0
8010599d:	6a 00                	push   $0x0
  pushl $141
8010599f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801059a4:	e9 a6 f6 ff ff       	jmp    8010504f <alltraps>

801059a9 <vector142>:
.globl vector142
vector142:
  pushl $0
801059a9:	6a 00                	push   $0x0
  pushl $142
801059ab:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801059b0:	e9 9a f6 ff ff       	jmp    8010504f <alltraps>

801059b5 <vector143>:
.globl vector143
vector143:
  pushl $0
801059b5:	6a 00                	push   $0x0
  pushl $143
801059b7:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801059bc:	e9 8e f6 ff ff       	jmp    8010504f <alltraps>

801059c1 <vector144>:
.globl vector144
vector144:
  pushl $0
801059c1:	6a 00                	push   $0x0
  pushl $144
801059c3:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801059c8:	e9 82 f6 ff ff       	jmp    8010504f <alltraps>

801059cd <vector145>:
.globl vector145
vector145:
  pushl $0
801059cd:	6a 00                	push   $0x0
  pushl $145
801059cf:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801059d4:	e9 76 f6 ff ff       	jmp    8010504f <alltraps>

801059d9 <vector146>:
.globl vector146
vector146:
  pushl $0
801059d9:	6a 00                	push   $0x0
  pushl $146
801059db:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801059e0:	e9 6a f6 ff ff       	jmp    8010504f <alltraps>

801059e5 <vector147>:
.globl vector147
vector147:
  pushl $0
801059e5:	6a 00                	push   $0x0
  pushl $147
801059e7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801059ec:	e9 5e f6 ff ff       	jmp    8010504f <alltraps>

801059f1 <vector148>:
.globl vector148
vector148:
  pushl $0
801059f1:	6a 00                	push   $0x0
  pushl $148
801059f3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801059f8:	e9 52 f6 ff ff       	jmp    8010504f <alltraps>

801059fd <vector149>:
.globl vector149
vector149:
  pushl $0
801059fd:	6a 00                	push   $0x0
  pushl $149
801059ff:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105a04:	e9 46 f6 ff ff       	jmp    8010504f <alltraps>

80105a09 <vector150>:
.globl vector150
vector150:
  pushl $0
80105a09:	6a 00                	push   $0x0
  pushl $150
80105a0b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105a10:	e9 3a f6 ff ff       	jmp    8010504f <alltraps>

80105a15 <vector151>:
.globl vector151
vector151:
  pushl $0
80105a15:	6a 00                	push   $0x0
  pushl $151
80105a17:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105a1c:	e9 2e f6 ff ff       	jmp    8010504f <alltraps>

80105a21 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $152
80105a23:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a28:	e9 22 f6 ff ff       	jmp    8010504f <alltraps>

80105a2d <vector153>:
.globl vector153
vector153:
  pushl $0
80105a2d:	6a 00                	push   $0x0
  pushl $153
80105a2f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a34:	e9 16 f6 ff ff       	jmp    8010504f <alltraps>

80105a39 <vector154>:
.globl vector154
vector154:
  pushl $0
80105a39:	6a 00                	push   $0x0
  pushl $154
80105a3b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a40:	e9 0a f6 ff ff       	jmp    8010504f <alltraps>

80105a45 <vector155>:
.globl vector155
vector155:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $155
80105a47:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105a4c:	e9 fe f5 ff ff       	jmp    8010504f <alltraps>

80105a51 <vector156>:
.globl vector156
vector156:
  pushl $0
80105a51:	6a 00                	push   $0x0
  pushl $156
80105a53:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105a58:	e9 f2 f5 ff ff       	jmp    8010504f <alltraps>

80105a5d <vector157>:
.globl vector157
vector157:
  pushl $0
80105a5d:	6a 00                	push   $0x0
  pushl $157
80105a5f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105a64:	e9 e6 f5 ff ff       	jmp    8010504f <alltraps>

80105a69 <vector158>:
.globl vector158
vector158:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $158
80105a6b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105a70:	e9 da f5 ff ff       	jmp    8010504f <alltraps>

80105a75 <vector159>:
.globl vector159
vector159:
  pushl $0
80105a75:	6a 00                	push   $0x0
  pushl $159
80105a77:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105a7c:	e9 ce f5 ff ff       	jmp    8010504f <alltraps>

80105a81 <vector160>:
.globl vector160
vector160:
  pushl $0
80105a81:	6a 00                	push   $0x0
  pushl $160
80105a83:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105a88:	e9 c2 f5 ff ff       	jmp    8010504f <alltraps>

80105a8d <vector161>:
.globl vector161
vector161:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $161
80105a8f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105a94:	e9 b6 f5 ff ff       	jmp    8010504f <alltraps>

80105a99 <vector162>:
.globl vector162
vector162:
  pushl $0
80105a99:	6a 00                	push   $0x0
  pushl $162
80105a9b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105aa0:	e9 aa f5 ff ff       	jmp    8010504f <alltraps>

80105aa5 <vector163>:
.globl vector163
vector163:
  pushl $0
80105aa5:	6a 00                	push   $0x0
  pushl $163
80105aa7:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105aac:	e9 9e f5 ff ff       	jmp    8010504f <alltraps>

80105ab1 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $164
80105ab3:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105ab8:	e9 92 f5 ff ff       	jmp    8010504f <alltraps>

80105abd <vector165>:
.globl vector165
vector165:
  pushl $0
80105abd:	6a 00                	push   $0x0
  pushl $165
80105abf:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ac4:	e9 86 f5 ff ff       	jmp    8010504f <alltraps>

80105ac9 <vector166>:
.globl vector166
vector166:
  pushl $0
80105ac9:	6a 00                	push   $0x0
  pushl $166
80105acb:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ad0:	e9 7a f5 ff ff       	jmp    8010504f <alltraps>

80105ad5 <vector167>:
.globl vector167
vector167:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $167
80105ad7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105adc:	e9 6e f5 ff ff       	jmp    8010504f <alltraps>

80105ae1 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ae1:	6a 00                	push   $0x0
  pushl $168
80105ae3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ae8:	e9 62 f5 ff ff       	jmp    8010504f <alltraps>

80105aed <vector169>:
.globl vector169
vector169:
  pushl $0
80105aed:	6a 00                	push   $0x0
  pushl $169
80105aef:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105af4:	e9 56 f5 ff ff       	jmp    8010504f <alltraps>

80105af9 <vector170>:
.globl vector170
vector170:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $170
80105afb:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105b00:	e9 4a f5 ff ff       	jmp    8010504f <alltraps>

80105b05 <vector171>:
.globl vector171
vector171:
  pushl $0
80105b05:	6a 00                	push   $0x0
  pushl $171
80105b07:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105b0c:	e9 3e f5 ff ff       	jmp    8010504f <alltraps>

80105b11 <vector172>:
.globl vector172
vector172:
  pushl $0
80105b11:	6a 00                	push   $0x0
  pushl $172
80105b13:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105b18:	e9 32 f5 ff ff       	jmp    8010504f <alltraps>

80105b1d <vector173>:
.globl vector173
vector173:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $173
80105b1f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b24:	e9 26 f5 ff ff       	jmp    8010504f <alltraps>

80105b29 <vector174>:
.globl vector174
vector174:
  pushl $0
80105b29:	6a 00                	push   $0x0
  pushl $174
80105b2b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b30:	e9 1a f5 ff ff       	jmp    8010504f <alltraps>

80105b35 <vector175>:
.globl vector175
vector175:
  pushl $0
80105b35:	6a 00                	push   $0x0
  pushl $175
80105b37:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b3c:	e9 0e f5 ff ff       	jmp    8010504f <alltraps>

80105b41 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $176
80105b43:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b48:	e9 02 f5 ff ff       	jmp    8010504f <alltraps>

80105b4d <vector177>:
.globl vector177
vector177:
  pushl $0
80105b4d:	6a 00                	push   $0x0
  pushl $177
80105b4f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105b54:	e9 f6 f4 ff ff       	jmp    8010504f <alltraps>

80105b59 <vector178>:
.globl vector178
vector178:
  pushl $0
80105b59:	6a 00                	push   $0x0
  pushl $178
80105b5b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105b60:	e9 ea f4 ff ff       	jmp    8010504f <alltraps>

80105b65 <vector179>:
.globl vector179
vector179:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $179
80105b67:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105b6c:	e9 de f4 ff ff       	jmp    8010504f <alltraps>

80105b71 <vector180>:
.globl vector180
vector180:
  pushl $0
80105b71:	6a 00                	push   $0x0
  pushl $180
80105b73:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105b78:	e9 d2 f4 ff ff       	jmp    8010504f <alltraps>

80105b7d <vector181>:
.globl vector181
vector181:
  pushl $0
80105b7d:	6a 00                	push   $0x0
  pushl $181
80105b7f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105b84:	e9 c6 f4 ff ff       	jmp    8010504f <alltraps>

80105b89 <vector182>:
.globl vector182
vector182:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $182
80105b8b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105b90:	e9 ba f4 ff ff       	jmp    8010504f <alltraps>

80105b95 <vector183>:
.globl vector183
vector183:
  pushl $0
80105b95:	6a 00                	push   $0x0
  pushl $183
80105b97:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105b9c:	e9 ae f4 ff ff       	jmp    8010504f <alltraps>

80105ba1 <vector184>:
.globl vector184
vector184:
  pushl $0
80105ba1:	6a 00                	push   $0x0
  pushl $184
80105ba3:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105ba8:	e9 a2 f4 ff ff       	jmp    8010504f <alltraps>

80105bad <vector185>:
.globl vector185
vector185:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $185
80105baf:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105bb4:	e9 96 f4 ff ff       	jmp    8010504f <alltraps>

80105bb9 <vector186>:
.globl vector186
vector186:
  pushl $0
80105bb9:	6a 00                	push   $0x0
  pushl $186
80105bbb:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105bc0:	e9 8a f4 ff ff       	jmp    8010504f <alltraps>

80105bc5 <vector187>:
.globl vector187
vector187:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $187
80105bc7:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105bcc:	e9 7e f4 ff ff       	jmp    8010504f <alltraps>

80105bd1 <vector188>:
.globl vector188
vector188:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $188
80105bd3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105bd8:	e9 72 f4 ff ff       	jmp    8010504f <alltraps>

80105bdd <vector189>:
.globl vector189
vector189:
  pushl $0
80105bdd:	6a 00                	push   $0x0
  pushl $189
80105bdf:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105be4:	e9 66 f4 ff ff       	jmp    8010504f <alltraps>

80105be9 <vector190>:
.globl vector190
vector190:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $190
80105beb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105bf0:	e9 5a f4 ff ff       	jmp    8010504f <alltraps>

80105bf5 <vector191>:
.globl vector191
vector191:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $191
80105bf7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105bfc:	e9 4e f4 ff ff       	jmp    8010504f <alltraps>

80105c01 <vector192>:
.globl vector192
vector192:
  pushl $0
80105c01:	6a 00                	push   $0x0
  pushl $192
80105c03:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105c08:	e9 42 f4 ff ff       	jmp    8010504f <alltraps>

80105c0d <vector193>:
.globl vector193
vector193:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $193
80105c0f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105c14:	e9 36 f4 ff ff       	jmp    8010504f <alltraps>

80105c19 <vector194>:
.globl vector194
vector194:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $194
80105c1b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c20:	e9 2a f4 ff ff       	jmp    8010504f <alltraps>

80105c25 <vector195>:
.globl vector195
vector195:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $195
80105c27:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c2c:	e9 1e f4 ff ff       	jmp    8010504f <alltraps>

80105c31 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $196
80105c33:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c38:	e9 12 f4 ff ff       	jmp    8010504f <alltraps>

80105c3d <vector197>:
.globl vector197
vector197:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $197
80105c3f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c44:	e9 06 f4 ff ff       	jmp    8010504f <alltraps>

80105c49 <vector198>:
.globl vector198
vector198:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $198
80105c4b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105c50:	e9 fa f3 ff ff       	jmp    8010504f <alltraps>

80105c55 <vector199>:
.globl vector199
vector199:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $199
80105c57:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105c5c:	e9 ee f3 ff ff       	jmp    8010504f <alltraps>

80105c61 <vector200>:
.globl vector200
vector200:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $200
80105c63:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105c68:	e9 e2 f3 ff ff       	jmp    8010504f <alltraps>

80105c6d <vector201>:
.globl vector201
vector201:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $201
80105c6f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105c74:	e9 d6 f3 ff ff       	jmp    8010504f <alltraps>

80105c79 <vector202>:
.globl vector202
vector202:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $202
80105c7b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105c80:	e9 ca f3 ff ff       	jmp    8010504f <alltraps>

80105c85 <vector203>:
.globl vector203
vector203:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $203
80105c87:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105c8c:	e9 be f3 ff ff       	jmp    8010504f <alltraps>

80105c91 <vector204>:
.globl vector204
vector204:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $204
80105c93:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105c98:	e9 b2 f3 ff ff       	jmp    8010504f <alltraps>

80105c9d <vector205>:
.globl vector205
vector205:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $205
80105c9f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105ca4:	e9 a6 f3 ff ff       	jmp    8010504f <alltraps>

80105ca9 <vector206>:
.globl vector206
vector206:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $206
80105cab:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105cb0:	e9 9a f3 ff ff       	jmp    8010504f <alltraps>

80105cb5 <vector207>:
.globl vector207
vector207:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $207
80105cb7:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105cbc:	e9 8e f3 ff ff       	jmp    8010504f <alltraps>

80105cc1 <vector208>:
.globl vector208
vector208:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $208
80105cc3:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105cc8:	e9 82 f3 ff ff       	jmp    8010504f <alltraps>

80105ccd <vector209>:
.globl vector209
vector209:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $209
80105ccf:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105cd4:	e9 76 f3 ff ff       	jmp    8010504f <alltraps>

80105cd9 <vector210>:
.globl vector210
vector210:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $210
80105cdb:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105ce0:	e9 6a f3 ff ff       	jmp    8010504f <alltraps>

80105ce5 <vector211>:
.globl vector211
vector211:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $211
80105ce7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105cec:	e9 5e f3 ff ff       	jmp    8010504f <alltraps>

80105cf1 <vector212>:
.globl vector212
vector212:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $212
80105cf3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105cf8:	e9 52 f3 ff ff       	jmp    8010504f <alltraps>

80105cfd <vector213>:
.globl vector213
vector213:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $213
80105cff:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105d04:	e9 46 f3 ff ff       	jmp    8010504f <alltraps>

80105d09 <vector214>:
.globl vector214
vector214:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $214
80105d0b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105d10:	e9 3a f3 ff ff       	jmp    8010504f <alltraps>

80105d15 <vector215>:
.globl vector215
vector215:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $215
80105d17:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105d1c:	e9 2e f3 ff ff       	jmp    8010504f <alltraps>

80105d21 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d21:	6a 00                	push   $0x0
  pushl $216
80105d23:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d28:	e9 22 f3 ff ff       	jmp    8010504f <alltraps>

80105d2d <vector217>:
.globl vector217
vector217:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $217
80105d2f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d34:	e9 16 f3 ff ff       	jmp    8010504f <alltraps>

80105d39 <vector218>:
.globl vector218
vector218:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $218
80105d3b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d40:	e9 0a f3 ff ff       	jmp    8010504f <alltraps>

80105d45 <vector219>:
.globl vector219
vector219:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $219
80105d47:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105d4c:	e9 fe f2 ff ff       	jmp    8010504f <alltraps>

80105d51 <vector220>:
.globl vector220
vector220:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $220
80105d53:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105d58:	e9 f2 f2 ff ff       	jmp    8010504f <alltraps>

80105d5d <vector221>:
.globl vector221
vector221:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $221
80105d5f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105d64:	e9 e6 f2 ff ff       	jmp    8010504f <alltraps>

80105d69 <vector222>:
.globl vector222
vector222:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $222
80105d6b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105d70:	e9 da f2 ff ff       	jmp    8010504f <alltraps>

80105d75 <vector223>:
.globl vector223
vector223:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $223
80105d77:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105d7c:	e9 ce f2 ff ff       	jmp    8010504f <alltraps>

80105d81 <vector224>:
.globl vector224
vector224:
  pushl $0
80105d81:	6a 00                	push   $0x0
  pushl $224
80105d83:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105d88:	e9 c2 f2 ff ff       	jmp    8010504f <alltraps>

80105d8d <vector225>:
.globl vector225
vector225:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $225
80105d8f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105d94:	e9 b6 f2 ff ff       	jmp    8010504f <alltraps>

80105d99 <vector226>:
.globl vector226
vector226:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $226
80105d9b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105da0:	e9 aa f2 ff ff       	jmp    8010504f <alltraps>

80105da5 <vector227>:
.globl vector227
vector227:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $227
80105da7:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105dac:	e9 9e f2 ff ff       	jmp    8010504f <alltraps>

80105db1 <vector228>:
.globl vector228
vector228:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $228
80105db3:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105db8:	e9 92 f2 ff ff       	jmp    8010504f <alltraps>

80105dbd <vector229>:
.globl vector229
vector229:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $229
80105dbf:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105dc4:	e9 86 f2 ff ff       	jmp    8010504f <alltraps>

80105dc9 <vector230>:
.globl vector230
vector230:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $230
80105dcb:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105dd0:	e9 7a f2 ff ff       	jmp    8010504f <alltraps>

80105dd5 <vector231>:
.globl vector231
vector231:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $231
80105dd7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105ddc:	e9 6e f2 ff ff       	jmp    8010504f <alltraps>

80105de1 <vector232>:
.globl vector232
vector232:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $232
80105de3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105de8:	e9 62 f2 ff ff       	jmp    8010504f <alltraps>

80105ded <vector233>:
.globl vector233
vector233:
  pushl $0
80105ded:	6a 00                	push   $0x0
  pushl $233
80105def:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105df4:	e9 56 f2 ff ff       	jmp    8010504f <alltraps>

80105df9 <vector234>:
.globl vector234
vector234:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $234
80105dfb:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105e00:	e9 4a f2 ff ff       	jmp    8010504f <alltraps>

80105e05 <vector235>:
.globl vector235
vector235:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $235
80105e07:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105e0c:	e9 3e f2 ff ff       	jmp    8010504f <alltraps>

80105e11 <vector236>:
.globl vector236
vector236:
  pushl $0
80105e11:	6a 00                	push   $0x0
  pushl $236
80105e13:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105e18:	e9 32 f2 ff ff       	jmp    8010504f <alltraps>

80105e1d <vector237>:
.globl vector237
vector237:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $237
80105e1f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e24:	e9 26 f2 ff ff       	jmp    8010504f <alltraps>

80105e29 <vector238>:
.globl vector238
vector238:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $238
80105e2b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e30:	e9 1a f2 ff ff       	jmp    8010504f <alltraps>

80105e35 <vector239>:
.globl vector239
vector239:
  pushl $0
80105e35:	6a 00                	push   $0x0
  pushl $239
80105e37:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e3c:	e9 0e f2 ff ff       	jmp    8010504f <alltraps>

80105e41 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $240
80105e43:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e48:	e9 02 f2 ff ff       	jmp    8010504f <alltraps>

80105e4d <vector241>:
.globl vector241
vector241:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $241
80105e4f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105e54:	e9 f6 f1 ff ff       	jmp    8010504f <alltraps>

80105e59 <vector242>:
.globl vector242
vector242:
  pushl $0
80105e59:	6a 00                	push   $0x0
  pushl $242
80105e5b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105e60:	e9 ea f1 ff ff       	jmp    8010504f <alltraps>

80105e65 <vector243>:
.globl vector243
vector243:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $243
80105e67:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105e6c:	e9 de f1 ff ff       	jmp    8010504f <alltraps>

80105e71 <vector244>:
.globl vector244
vector244:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $244
80105e73:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105e78:	e9 d2 f1 ff ff       	jmp    8010504f <alltraps>

80105e7d <vector245>:
.globl vector245
vector245:
  pushl $0
80105e7d:	6a 00                	push   $0x0
  pushl $245
80105e7f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105e84:	e9 c6 f1 ff ff       	jmp    8010504f <alltraps>

80105e89 <vector246>:
.globl vector246
vector246:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $246
80105e8b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105e90:	e9 ba f1 ff ff       	jmp    8010504f <alltraps>

80105e95 <vector247>:
.globl vector247
vector247:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $247
80105e97:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105e9c:	e9 ae f1 ff ff       	jmp    8010504f <alltraps>

80105ea1 <vector248>:
.globl vector248
vector248:
  pushl $0
80105ea1:	6a 00                	push   $0x0
  pushl $248
80105ea3:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105ea8:	e9 a2 f1 ff ff       	jmp    8010504f <alltraps>

80105ead <vector249>:
.globl vector249
vector249:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $249
80105eaf:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105eb4:	e9 96 f1 ff ff       	jmp    8010504f <alltraps>

80105eb9 <vector250>:
.globl vector250
vector250:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $250
80105ebb:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105ec0:	e9 8a f1 ff ff       	jmp    8010504f <alltraps>

80105ec5 <vector251>:
.globl vector251
vector251:
  pushl $0
80105ec5:	6a 00                	push   $0x0
  pushl $251
80105ec7:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105ecc:	e9 7e f1 ff ff       	jmp    8010504f <alltraps>

80105ed1 <vector252>:
.globl vector252
vector252:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $252
80105ed3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105ed8:	e9 72 f1 ff ff       	jmp    8010504f <alltraps>

80105edd <vector253>:
.globl vector253
vector253:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $253
80105edf:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105ee4:	e9 66 f1 ff ff       	jmp    8010504f <alltraps>

80105ee9 <vector254>:
.globl vector254
vector254:
  pushl $0
80105ee9:	6a 00                	push   $0x0
  pushl $254
80105eeb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ef0:	e9 5a f1 ff ff       	jmp    8010504f <alltraps>

80105ef5 <vector255>:
.globl vector255
vector255:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $255
80105ef7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105efc:	e9 4e f1 ff ff       	jmp    8010504f <alltraps>

80105f01 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105f01:	55                   	push   %ebp
80105f02:	89 e5                	mov    %esp,%ebp
80105f04:	57                   	push   %edi
80105f05:	56                   	push   %esi
80105f06:	53                   	push   %ebx
80105f07:	83 ec 0c             	sub    $0xc,%esp
80105f0a:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105f0c:	c1 ea 16             	shr    $0x16,%edx
80105f0f:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105f12:	8b 1f                	mov    (%edi),%ebx
80105f14:	f6 c3 01             	test   $0x1,%bl
80105f17:	74 21                	je     80105f3a <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105f19:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105f1f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105f25:	c1 ee 0a             	shr    $0xa,%esi
80105f28:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105f2e:	01 f3                	add    %esi,%ebx
}
80105f30:	89 d8                	mov    %ebx,%eax
80105f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f35:	5b                   	pop    %ebx
80105f36:	5e                   	pop    %esi
80105f37:	5f                   	pop    %edi
80105f38:	5d                   	pop    %ebp
80105f39:	c3                   	ret    
      return 0;
80105f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105f3f:	85 c9                	test   %ecx,%ecx
80105f41:	74 ed                	je     80105f30 <walkpgdir+0x2f>
80105f43:	e8 d1 c2 ff ff       	call   80102219 <kalloc>
80105f48:	89 c3                	mov    %eax,%ebx
80105f4a:	85 c0                	test   %eax,%eax
80105f4c:	74 e2                	je     80105f30 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80105f4e:	83 ec 04             	sub    $0x4,%esp
80105f51:	68 00 10 00 00       	push   $0x1000
80105f56:	6a 00                	push   $0x0
80105f58:	50                   	push   %eax
80105f59:	e8 f1 df ff ff       	call   80103f4f <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105f5e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105f64:	83 c8 07             	or     $0x7,%eax
80105f67:	89 07                	mov    %eax,(%edi)
80105f69:	83 c4 10             	add    $0x10,%esp
80105f6c:	eb b7                	jmp    80105f25 <walkpgdir+0x24>

80105f6e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105f6e:	55                   	push   %ebp
80105f6f:	89 e5                	mov    %esp,%ebp
80105f71:	57                   	push   %edi
80105f72:	56                   	push   %esi
80105f73:	53                   	push   %ebx
80105f74:	83 ec 1c             	sub    $0x1c,%esp
80105f77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105f7a:	89 d0                	mov    %edx,%eax
80105f7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105f81:	89 c6                	mov    %eax,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105f83:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80105f87:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105f8d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105f90:	8b 7d 08             	mov    0x8(%ebp),%edi
80105f93:	29 c7                	sub    %eax,%edi
80105f95:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105f98:	b9 01 00 00 00       	mov    $0x1,%ecx
80105f9d:	89 f2                	mov    %esi,%edx
80105f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa2:	e8 5a ff ff ff       	call   80105f01 <walkpgdir>
80105fa7:	85 c0                	test   %eax,%eax
80105fa9:	74 27                	je     80105fd2 <mappages+0x64>
      return -1;
    if(*pte & PTE_P)
80105fab:	f6 00 01             	testb  $0x1,(%eax)
80105fae:	75 15                	jne    80105fc5 <mappages+0x57>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105fb0:	0b 5d 0c             	or     0xc(%ebp),%ebx
80105fb3:	83 cb 01             	or     $0x1,%ebx
80105fb6:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80105fb8:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80105fbb:	74 22                	je     80105fdf <mappages+0x71>
      break;
    a += PGSIZE;
80105fbd:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105fc3:	eb d0                	jmp    80105f95 <mappages+0x27>
      panic("remap");
80105fc5:	83 ec 0c             	sub    $0xc,%esp
80105fc8:	68 70 81 10 80       	push   $0x80108170
80105fcd:	e8 86 a3 ff ff       	call   80100358 <panic>
      return -1;
80105fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fda:	5b                   	pop    %ebx
80105fdb:	5e                   	pop    %esi
80105fdc:	5f                   	pop    %edi
80105fdd:	5d                   	pop    %ebp
80105fde:	c3                   	ret    
  return 0;
80105fdf:	b8 00 00 00 00       	mov    $0x0,%eax
80105fe4:	eb f1                	jmp    80105fd7 <mappages+0x69>

80105fe6 <seginit>:
{
80105fe6:	f3 0f 1e fb          	endbr32 
80105fea:	55                   	push   %ebp
80105feb:	89 e5                	mov    %esp,%ebp
80105fed:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105ff0:	e8 d6 d3 ff ff       	call   801033cb <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105ff5:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105ffb:	66 c7 80 18 54 11 80 	movw   $0xffff,-0x7feeabe8(%eax)
80106002:	ff ff 
80106004:	66 c7 80 1a 54 11 80 	movw   $0x0,-0x7feeabe6(%eax)
8010600b:	00 00 
8010600d:	c6 80 1c 54 11 80 00 	movb   $0x0,-0x7feeabe4(%eax)
80106014:	c6 80 1d 54 11 80 9a 	movb   $0x9a,-0x7feeabe3(%eax)
8010601b:	c6 80 1e 54 11 80 cf 	movb   $0xcf,-0x7feeabe2(%eax)
80106022:	c6 80 1f 54 11 80 00 	movb   $0x0,-0x7feeabe1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106029:	66 c7 80 20 54 11 80 	movw   $0xffff,-0x7feeabe0(%eax)
80106030:	ff ff 
80106032:	66 c7 80 22 54 11 80 	movw   $0x0,-0x7feeabde(%eax)
80106039:	00 00 
8010603b:	c6 80 24 54 11 80 00 	movb   $0x0,-0x7feeabdc(%eax)
80106042:	c6 80 25 54 11 80 92 	movb   $0x92,-0x7feeabdb(%eax)
80106049:	c6 80 26 54 11 80 cf 	movb   $0xcf,-0x7feeabda(%eax)
80106050:	c6 80 27 54 11 80 00 	movb   $0x0,-0x7feeabd9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106057:	66 c7 80 28 54 11 80 	movw   $0xffff,-0x7feeabd8(%eax)
8010605e:	ff ff 
80106060:	66 c7 80 2a 54 11 80 	movw   $0x0,-0x7feeabd6(%eax)
80106067:	00 00 
80106069:	c6 80 2c 54 11 80 00 	movb   $0x0,-0x7feeabd4(%eax)
80106070:	c6 80 2d 54 11 80 fa 	movb   $0xfa,-0x7feeabd3(%eax)
80106077:	c6 80 2e 54 11 80 cf 	movb   $0xcf,-0x7feeabd2(%eax)
8010607e:	c6 80 2f 54 11 80 00 	movb   $0x0,-0x7feeabd1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106085:	66 c7 80 30 54 11 80 	movw   $0xffff,-0x7feeabd0(%eax)
8010608c:	ff ff 
8010608e:	66 c7 80 32 54 11 80 	movw   $0x0,-0x7feeabce(%eax)
80106095:	00 00 
80106097:	c6 80 34 54 11 80 00 	movb   $0x0,-0x7feeabcc(%eax)
8010609e:	c6 80 35 54 11 80 f2 	movb   $0xf2,-0x7feeabcb(%eax)
801060a5:	c6 80 36 54 11 80 cf 	movb   $0xcf,-0x7feeabca(%eax)
801060ac:	c6 80 37 54 11 80 00 	movb   $0x0,-0x7feeabc9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801060b3:	05 10 54 11 80       	add    $0x80115410,%eax
  pd[0] = size-1;
801060b8:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801060be:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801060c2:	c1 e8 10             	shr    $0x10,%eax
801060c5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801060c9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801060cc:	0f 01 10             	lgdtl  (%eax)
}
801060cf:	c9                   	leave  
801060d0:	c3                   	ret    

801060d1 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801060d1:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801060d5:	a1 04 6a 11 80       	mov    0x80116a04,%eax
801060da:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801060df:	0f 22 d8             	mov    %eax,%cr3
}
801060e2:	c3                   	ret    

801060e3 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801060e3:	f3 0f 1e fb          	endbr32 
801060e7:	55                   	push   %ebp
801060e8:	89 e5                	mov    %esp,%ebp
801060ea:	57                   	push   %edi
801060eb:	56                   	push   %esi
801060ec:	53                   	push   %ebx
801060ed:	83 ec 1c             	sub    $0x1c,%esp
801060f0:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801060f3:	85 f6                	test   %esi,%esi
801060f5:	0f 84 c3 00 00 00    	je     801061be <switchuvm+0xdb>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801060fb:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801060ff:	0f 84 c6 00 00 00    	je     801061cb <switchuvm+0xe8>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106105:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106109:	0f 84 c9 00 00 00    	je     801061d8 <switchuvm+0xf5>
    panic("switchuvm: no pgdir");

  pushcli();
8010610f:	e8 a8 dc ff ff       	call   80103dbc <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106114:	e8 4d d2 ff ff       	call   80103366 <mycpu>
80106119:	89 c3                	mov    %eax,%ebx
8010611b:	e8 46 d2 ff ff       	call   80103366 <mycpu>
80106120:	89 c7                	mov    %eax,%edi
80106122:	e8 3f d2 ff ff       	call   80103366 <mycpu>
80106127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010612a:	e8 37 d2 ff ff       	call   80103366 <mycpu>
8010612f:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106136:	67 00 
80106138:	83 c7 08             	add    $0x8,%edi
8010613b:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106142:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106145:	83 c2 08             	add    $0x8,%edx
80106148:	c1 ea 10             	shr    $0x10,%edx
8010614b:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106151:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106158:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
8010615f:	83 c0 08             	add    $0x8,%eax
80106162:	c1 e8 18             	shr    $0x18,%eax
80106165:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010616b:	e8 f6 d1 ff ff       	call   80103366 <mycpu>
80106170:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106177:	e8 ea d1 ff ff       	call   80103366 <mycpu>
8010617c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106182:	8b 5e 08             	mov    0x8(%esi),%ebx
80106185:	e8 dc d1 ff ff       	call   80103366 <mycpu>
8010618a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106190:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106193:	e8 ce d1 ff ff       	call   80103366 <mycpu>
80106198:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010619e:	b8 28 00 00 00       	mov    $0x28,%eax
801061a3:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801061a6:	8b 46 04             	mov    0x4(%esi),%eax
801061a9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801061ae:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801061b1:	e8 47 dc ff ff       	call   80103dfd <popcli>
}
801061b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b9:	5b                   	pop    %ebx
801061ba:	5e                   	pop    %esi
801061bb:	5f                   	pop    %edi
801061bc:	5d                   	pop    %ebp
801061bd:	c3                   	ret    
    panic("switchuvm: no process");
801061be:	83 ec 0c             	sub    $0xc,%esp
801061c1:	68 76 81 10 80       	push   $0x80108176
801061c6:	e8 8d a1 ff ff       	call   80100358 <panic>
    panic("switchuvm: no kstack");
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	68 8c 81 10 80       	push   $0x8010818c
801061d3:	e8 80 a1 ff ff       	call   80100358 <panic>
    panic("switchuvm: no pgdir");
801061d8:	83 ec 0c             	sub    $0xc,%esp
801061db:	68 a1 81 10 80       	push   $0x801081a1
801061e0:	e8 73 a1 ff ff       	call   80100358 <panic>

801061e5 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801061e5:	f3 0f 1e fb          	endbr32 
801061e9:	55                   	push   %ebp
801061ea:	89 e5                	mov    %esp,%ebp
801061ec:	56                   	push   %esi
801061ed:	53                   	push   %ebx
801061ee:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801061f1:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801061f7:	77 4c                	ja     80106245 <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
801061f9:	e8 1b c0 ff ff       	call   80102219 <kalloc>
801061fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106200:	83 ec 04             	sub    $0x4,%esp
80106203:	68 00 10 00 00       	push   $0x1000
80106208:	6a 00                	push   $0x0
8010620a:	50                   	push   %eax
8010620b:	e8 3f dd ff ff       	call   80103f4f <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106210:	83 c4 08             	add    $0x8,%esp
80106213:	6a 06                	push   $0x6
80106215:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010621b:	50                   	push   %eax
8010621c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106221:	ba 00 00 00 00       	mov    $0x0,%edx
80106226:	8b 45 08             	mov    0x8(%ebp),%eax
80106229:	e8 40 fd ff ff       	call   80105f6e <mappages>
  memmove(mem, init, sz);
8010622e:	83 c4 0c             	add    $0xc,%esp
80106231:	56                   	push   %esi
80106232:	ff 75 0c             	pushl  0xc(%ebp)
80106235:	53                   	push   %ebx
80106236:	e8 a1 dd ff ff       	call   80103fdc <memmove>
}
8010623b:	83 c4 10             	add    $0x10,%esp
8010623e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106241:	5b                   	pop    %ebx
80106242:	5e                   	pop    %esi
80106243:	5d                   	pop    %ebp
80106244:	c3                   	ret    
    panic("inituvm: more than a page");
80106245:	83 ec 0c             	sub    $0xc,%esp
80106248:	68 b5 81 10 80       	push   $0x801081b5
8010624d:	e8 06 a1 ff ff       	call   80100358 <panic>

80106252 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106252:	f3 0f 1e fb          	endbr32 
80106256:	55                   	push   %ebp
80106257:	89 e5                	mov    %esp,%ebp
80106259:	57                   	push   %edi
8010625a:	56                   	push   %esi
8010625b:	53                   	push   %ebx
8010625c:	83 ec 1c             	sub    $0x1c,%esp
8010625f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106262:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106265:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010626a:	75 6f                	jne    801062db <loaduvm+0x89>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010626c:	89 f3                	mov    %esi,%ebx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010626e:	8d 04 30             	lea    (%eax,%esi,1),%eax
80106271:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106274:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106279:	85 f6                	test   %esi,%esi
8010627b:	74 7d                	je     801062fa <loaduvm+0xa8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010627d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106280:	29 da                	sub    %ebx,%edx
80106282:	b9 00 00 00 00       	mov    $0x0,%ecx
80106287:	8b 45 08             	mov    0x8(%ebp),%eax
8010628a:	e8 72 fc ff ff       	call   80105f01 <walkpgdir>
8010628f:	85 c0                	test   %eax,%eax
80106291:	74 55                	je     801062e8 <loaduvm+0x96>
    pa = PTE_ADDR(*pte);
80106293:	8b 00                	mov    (%eax),%eax
80106295:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
8010629a:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801062a0:	bf 00 10 00 00       	mov    $0x1000,%edi
801062a5:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801062a8:	57                   	push   %edi
801062a9:	89 f2                	mov    %esi,%edx
801062ab:	03 55 14             	add    0x14(%ebp),%edx
801062ae:	29 da                	sub    %ebx,%edx
801062b0:	52                   	push   %edx
801062b1:	05 00 00 00 80       	add    $0x80000000,%eax
801062b6:	50                   	push   %eax
801062b7:	ff 75 10             	pushl  0x10(%ebp)
801062ba:	e8 15 b5 ff ff       	call   801017d4 <readi>
801062bf:	83 c4 10             	add    $0x10,%esp
801062c2:	39 f8                	cmp    %edi,%eax
801062c4:	75 2f                	jne    801062f5 <loaduvm+0xa3>
  for(i = 0; i < sz; i += PGSIZE){
801062c6:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801062cc:	89 f0                	mov    %esi,%eax
801062ce:	29 d8                	sub    %ebx,%eax
801062d0:	39 c6                	cmp    %eax,%esi
801062d2:	77 a9                	ja     8010627d <loaduvm+0x2b>
  return 0;
801062d4:	b8 00 00 00 00       	mov    $0x0,%eax
801062d9:	eb 1f                	jmp    801062fa <loaduvm+0xa8>
    panic("loaduvm: addr must be page aligned");
801062db:	83 ec 0c             	sub    $0xc,%esp
801062de:	68 70 82 10 80       	push   $0x80108270
801062e3:	e8 70 a0 ff ff       	call   80100358 <panic>
      panic("loaduvm: address should exist");
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	68 cf 81 10 80       	push   $0x801081cf
801062f0:	e8 63 a0 ff ff       	call   80100358 <panic>
      return -1;
801062f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062fd:	5b                   	pop    %ebx
801062fe:	5e                   	pop    %esi
801062ff:	5f                   	pop    %edi
80106300:	5d                   	pop    %ebp
80106301:	c3                   	ret    

80106302 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106302:	f3 0f 1e fb          	endbr32 
80106306:	55                   	push   %ebp
80106307:	89 e5                	mov    %esp,%ebp
80106309:	57                   	push   %edi
8010630a:	56                   	push   %esi
8010630b:	53                   	push   %ebx
8010630c:	83 ec 0c             	sub    $0xc,%esp
8010630f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106312:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80106314:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106317:	73 16                	jae    8010632f <deallocuvm+0x2d>

  a = PGROUNDUP(newsz);
80106319:	8b 45 10             	mov    0x10(%ebp),%eax
8010631c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106322:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106328:	39 df                	cmp    %ebx,%edi
8010632a:	77 21                	ja     8010634d <deallocuvm+0x4b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010632c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010632f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106332:	5b                   	pop    %ebx
80106333:	5e                   	pop    %esi
80106334:	5f                   	pop    %edi
80106335:	5d                   	pop    %ebp
80106336:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106337:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010633d:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106343:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106349:	39 df                	cmp    %ebx,%edi
8010634b:	76 df                	jbe    8010632c <deallocuvm+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010634d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106352:	89 da                	mov    %ebx,%edx
80106354:	8b 45 08             	mov    0x8(%ebp),%eax
80106357:	e8 a5 fb ff ff       	call   80105f01 <walkpgdir>
8010635c:	89 c6                	mov    %eax,%esi
    if(!pte)
8010635e:	85 c0                	test   %eax,%eax
80106360:	74 d5                	je     80106337 <deallocuvm+0x35>
    else if((*pte & PTE_P) != 0){
80106362:	8b 00                	mov    (%eax),%eax
80106364:	a8 01                	test   $0x1,%al
80106366:	74 db                	je     80106343 <deallocuvm+0x41>
      if(pa == 0)
80106368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010636d:	74 19                	je     80106388 <deallocuvm+0x86>
      kfree(v);
8010636f:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106372:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106377:	50                   	push   %eax
80106378:	e8 3e bd ff ff       	call   801020bb <kfree>
      *pte = 0;
8010637d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106383:	83 c4 10             	add    $0x10,%esp
80106386:	eb bb                	jmp    80106343 <deallocuvm+0x41>
        panic("kfree");
80106388:	83 ec 0c             	sub    $0xc,%esp
8010638b:	68 ec 7a 10 80       	push   $0x80107aec
80106390:	e8 c3 9f ff ff       	call   80100358 <panic>

80106395 <allocuvm>:
{
80106395:	f3 0f 1e fb          	endbr32 
80106399:	55                   	push   %ebp
8010639a:	89 e5                	mov    %esp,%ebp
8010639c:	57                   	push   %edi
8010639d:	56                   	push   %esi
8010639e:	53                   	push   %ebx
8010639f:	83 ec 1c             	sub    $0x1c,%esp
801063a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801063a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801063a8:	85 ff                	test   %edi,%edi
801063aa:	0f 88 c5 00 00 00    	js     80106475 <allocuvm+0xe0>
  if(newsz < oldsz)
801063b0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801063b3:	72 60                	jb     80106415 <allocuvm+0x80>
  a = PGROUNDUP(oldsz);
801063b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801063b8:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801063be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801063c4:	39 f7                	cmp    %esi,%edi
801063c6:	0f 86 b0 00 00 00    	jbe    8010647c <allocuvm+0xe7>
    mem = kalloc();
801063cc:	e8 48 be ff ff       	call   80102219 <kalloc>
801063d1:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801063d3:	85 c0                	test   %eax,%eax
801063d5:	74 46                	je     8010641d <allocuvm+0x88>
    memset(mem, 0, PGSIZE);
801063d7:	83 ec 04             	sub    $0x4,%esp
801063da:	68 00 10 00 00       	push   $0x1000
801063df:	6a 00                	push   $0x0
801063e1:	50                   	push   %eax
801063e2:	e8 68 db ff ff       	call   80103f4f <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801063e7:	83 c4 08             	add    $0x8,%esp
801063ea:	6a 06                	push   $0x6
801063ec:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063f2:	50                   	push   %eax
801063f3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801063f8:	89 f2                	mov    %esi,%edx
801063fa:	8b 45 08             	mov    0x8(%ebp),%eax
801063fd:	e8 6c fb ff ff       	call   80105f6e <mappages>
80106402:	83 c4 10             	add    $0x10,%esp
80106405:	85 c0                	test   %eax,%eax
80106407:	78 3c                	js     80106445 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106409:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010640f:	39 f7                	cmp    %esi,%edi
80106411:	77 b9                	ja     801063cc <allocuvm+0x37>
80106413:	eb 67                	jmp    8010647c <allocuvm+0xe7>
    return oldsz;
80106415:	8b 45 0c             	mov    0xc(%ebp),%eax
80106418:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010641b:	eb 5f                	jmp    8010647c <allocuvm+0xe7>
      cprintf("allocuvm out of memory\n");
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	68 ed 81 10 80       	push   $0x801081ed
80106425:	e8 02 a2 ff ff       	call   8010062c <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010642a:	83 c4 0c             	add    $0xc,%esp
8010642d:	ff 75 0c             	pushl  0xc(%ebp)
80106430:	57                   	push   %edi
80106431:	ff 75 08             	pushl  0x8(%ebp)
80106434:	e8 c9 fe ff ff       	call   80106302 <deallocuvm>
      return 0;
80106439:	83 c4 10             	add    $0x10,%esp
8010643c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106443:	eb 37                	jmp    8010647c <allocuvm+0xe7>
      cprintf("allocuvm out of memory (2)\n");
80106445:	83 ec 0c             	sub    $0xc,%esp
80106448:	68 05 82 10 80       	push   $0x80108205
8010644d:	e8 da a1 ff ff       	call   8010062c <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106452:	83 c4 0c             	add    $0xc,%esp
80106455:	ff 75 0c             	pushl  0xc(%ebp)
80106458:	57                   	push   %edi
80106459:	ff 75 08             	pushl  0x8(%ebp)
8010645c:	e8 a1 fe ff ff       	call   80106302 <deallocuvm>
      kfree(mem);
80106461:	89 1c 24             	mov    %ebx,(%esp)
80106464:	e8 52 bc ff ff       	call   801020bb <kfree>
      return 0;
80106469:	83 c4 10             	add    $0x10,%esp
8010646c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106473:	eb 07                	jmp    8010647c <allocuvm+0xe7>
    return 0;
80106475:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010647c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106482:	5b                   	pop    %ebx
80106483:	5e                   	pop    %esi
80106484:	5f                   	pop    %edi
80106485:	5d                   	pop    %ebp
80106486:	c3                   	ret    

80106487 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106487:	f3 0f 1e fb          	endbr32 
8010648b:	55                   	push   %ebp
8010648c:	89 e5                	mov    %esp,%ebp
8010648e:	57                   	push   %edi
8010648f:	56                   	push   %esi
80106490:	53                   	push   %ebx
80106491:	83 ec 0c             	sub    $0xc,%esp
80106494:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80106497:	85 ff                	test   %edi,%edi
80106499:	74 1d                	je     801064b8 <freevm+0x31>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010649b:	83 ec 04             	sub    $0x4,%esp
8010649e:	6a 00                	push   $0x0
801064a0:	68 00 00 00 80       	push   $0x80000000
801064a5:	57                   	push   %edi
801064a6:	e8 57 fe ff ff       	call   80106302 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801064ab:	89 fb                	mov    %edi,%ebx
801064ad:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
801064b3:	83 c4 10             	add    $0x10,%esp
801064b6:	eb 2a                	jmp    801064e2 <freevm+0x5b>
    panic("freevm: no pgdir");
801064b8:	83 ec 0c             	sub    $0xc,%esp
801064bb:	68 21 82 10 80       	push   $0x80108221
801064c0:	e8 93 9e ff ff       	call   80100358 <panic>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801064c5:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801064c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064cd:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801064d2:	50                   	push   %eax
801064d3:	e8 e3 bb ff ff       	call   801020bb <kfree>
801064d8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801064db:	83 c3 04             	add    $0x4,%ebx
801064de:	39 f3                	cmp    %esi,%ebx
801064e0:	74 08                	je     801064ea <freevm+0x63>
    if(pgdir[i] & PTE_P){
801064e2:	8b 03                	mov    (%ebx),%eax
801064e4:	a8 01                	test   $0x1,%al
801064e6:	74 f3                	je     801064db <freevm+0x54>
801064e8:	eb db                	jmp    801064c5 <freevm+0x3e>
    }
  }
  kfree((char*)pgdir);
801064ea:	83 ec 0c             	sub    $0xc,%esp
801064ed:	57                   	push   %edi
801064ee:	e8 c8 bb ff ff       	call   801020bb <kfree>
}
801064f3:	83 c4 10             	add    $0x10,%esp
801064f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f9:	5b                   	pop    %ebx
801064fa:	5e                   	pop    %esi
801064fb:	5f                   	pop    %edi
801064fc:	5d                   	pop    %ebp
801064fd:	c3                   	ret    

801064fe <setupkvm>:
{
801064fe:	f3 0f 1e fb          	endbr32 
80106502:	55                   	push   %ebp
80106503:	89 e5                	mov    %esp,%ebp
80106505:	56                   	push   %esi
80106506:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106507:	e8 0d bd ff ff       	call   80102219 <kalloc>
8010650c:	89 c6                	mov    %eax,%esi
8010650e:	85 c0                	test   %eax,%eax
80106510:	74 42                	je     80106554 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106512:	83 ec 04             	sub    $0x4,%esp
80106515:	68 00 10 00 00       	push   $0x1000
8010651a:	6a 00                	push   $0x0
8010651c:	50                   	push   %eax
8010651d:	e8 2d da ff ff       	call   80103f4f <memset>
80106522:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106525:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010652a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010652d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106530:	29 c1                	sub    %eax,%ecx
80106532:	83 ec 08             	sub    $0x8,%esp
80106535:	ff 73 0c             	pushl  0xc(%ebx)
80106538:	50                   	push   %eax
80106539:	8b 13                	mov    (%ebx),%edx
8010653b:	89 f0                	mov    %esi,%eax
8010653d:	e8 2c fa ff ff       	call   80105f6e <mappages>
80106542:	83 c4 10             	add    $0x10,%esp
80106545:	85 c0                	test   %eax,%eax
80106547:	78 14                	js     8010655d <setupkvm+0x5f>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106549:	83 c3 10             	add    $0x10,%ebx
8010654c:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106552:	75 d6                	jne    8010652a <setupkvm+0x2c>
}
80106554:	89 f0                	mov    %esi,%eax
80106556:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106559:	5b                   	pop    %ebx
8010655a:	5e                   	pop    %esi
8010655b:	5d                   	pop    %ebp
8010655c:	c3                   	ret    
      freevm(pgdir);
8010655d:	83 ec 0c             	sub    $0xc,%esp
80106560:	56                   	push   %esi
80106561:	e8 21 ff ff ff       	call   80106487 <freevm>
      return 0;
80106566:	83 c4 10             	add    $0x10,%esp
80106569:	be 00 00 00 00       	mov    $0x0,%esi
8010656e:	eb e4                	jmp    80106554 <setupkvm+0x56>

80106570 <kvmalloc>:
{
80106570:	f3 0f 1e fb          	endbr32 
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010657a:	e8 7f ff ff ff       	call   801064fe <setupkvm>
8010657f:	a3 04 6a 11 80       	mov    %eax,0x80116a04
  switchkvm();
80106584:	e8 48 fb ff ff       	call   801060d1 <switchkvm>
}
80106589:	c9                   	leave  
8010658a:	c3                   	ret    

8010658b <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010658b:	f3 0f 1e fb          	endbr32 
8010658f:	55                   	push   %ebp
80106590:	89 e5                	mov    %esp,%ebp
80106592:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106595:	b9 00 00 00 00       	mov    $0x0,%ecx
8010659a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010659d:	8b 45 08             	mov    0x8(%ebp),%eax
801065a0:	e8 5c f9 ff ff       	call   80105f01 <walkpgdir>
  if(pte == 0)
801065a5:	85 c0                	test   %eax,%eax
801065a7:	74 05                	je     801065ae <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801065a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801065ac:	c9                   	leave  
801065ad:	c3                   	ret    
    panic("clearpteu");
801065ae:	83 ec 0c             	sub    $0xc,%esp
801065b1:	68 32 82 10 80       	push   $0x80108232
801065b6:	e8 9d 9d ff ff       	call   80100358 <panic>

801065bb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801065bb:	f3 0f 1e fb          	endbr32 
801065bf:	55                   	push   %ebp
801065c0:	89 e5                	mov    %esp,%ebp
801065c2:	57                   	push   %edi
801065c3:	56                   	push   %esi
801065c4:	53                   	push   %ebx
801065c5:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801065c8:	e8 31 ff ff ff       	call   801064fe <setupkvm>
801065cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801065d0:	85 c0                	test   %eax,%eax
801065d2:	0f 84 c7 00 00 00    	je     8010669f <copyuvm+0xe4>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801065d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801065dc:	0f 84 bd 00 00 00    	je     8010669f <copyuvm+0xe4>
801065e2:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801065e7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801065ea:	b9 00 00 00 00       	mov    $0x0,%ecx
801065ef:	89 fa                	mov    %edi,%edx
801065f1:	8b 45 08             	mov    0x8(%ebp),%eax
801065f4:	e8 08 f9 ff ff       	call   80105f01 <walkpgdir>
801065f9:	85 c0                	test   %eax,%eax
801065fb:	74 67                	je     80106664 <copyuvm+0xa9>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801065fd:	8b 00                	mov    (%eax),%eax
801065ff:	a8 01                	test   $0x1,%al
80106601:	74 6e                	je     80106671 <copyuvm+0xb6>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106603:	89 c6                	mov    %eax,%esi
80106605:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010660b:	25 ff 0f 00 00       	and    $0xfff,%eax
80106610:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106613:	e8 01 bc ff ff       	call   80102219 <kalloc>
80106618:	89 c3                	mov    %eax,%ebx
8010661a:	85 c0                	test   %eax,%eax
8010661c:	74 6c                	je     8010668a <copyuvm+0xcf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010661e:	83 ec 04             	sub    $0x4,%esp
80106621:	68 00 10 00 00       	push   $0x1000
80106626:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010662c:	56                   	push   %esi
8010662d:	50                   	push   %eax
8010662e:	e8 a9 d9 ff ff       	call   80103fdc <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106633:	83 c4 08             	add    $0x8,%esp
80106636:	ff 75 e0             	pushl  -0x20(%ebp)
80106639:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010663f:	50                   	push   %eax
80106640:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106648:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010664b:	e8 1e f9 ff ff       	call   80105f6e <mappages>
80106650:	83 c4 10             	add    $0x10,%esp
80106653:	85 c0                	test   %eax,%eax
80106655:	78 27                	js     8010667e <copyuvm+0xc3>
  for(i = 0; i < sz; i += PGSIZE){
80106657:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010665d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106660:	77 85                	ja     801065e7 <copyuvm+0x2c>
80106662:	eb 3b                	jmp    8010669f <copyuvm+0xe4>
      panic("copyuvm: pte should exist");
80106664:	83 ec 0c             	sub    $0xc,%esp
80106667:	68 3c 82 10 80       	push   $0x8010823c
8010666c:	e8 e7 9c ff ff       	call   80100358 <panic>
      panic("copyuvm: page not present");
80106671:	83 ec 0c             	sub    $0xc,%esp
80106674:	68 56 82 10 80       	push   $0x80108256
80106679:	e8 da 9c ff ff       	call   80100358 <panic>
      kfree(mem);
8010667e:	83 ec 0c             	sub    $0xc,%esp
80106681:	53                   	push   %ebx
80106682:	e8 34 ba ff ff       	call   801020bb <kfree>
      goto bad;
80106687:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	ff 75 dc             	pushl  -0x24(%ebp)
80106690:	e8 f2 fd ff ff       	call   80106487 <freevm>
  return 0;
80106695:	83 c4 10             	add    $0x10,%esp
80106698:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010669f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a5:	5b                   	pop    %ebx
801066a6:	5e                   	pop    %esi
801066a7:	5f                   	pop    %edi
801066a8:	5d                   	pop    %ebp
801066a9:	c3                   	ret    

801066aa <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801066aa:	f3 0f 1e fb          	endbr32 
801066ae:	55                   	push   %ebp
801066af:	89 e5                	mov    %esp,%ebp
801066b1:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801066b4:	b9 00 00 00 00       	mov    $0x0,%ecx
801066b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801066bc:	8b 45 08             	mov    0x8(%ebp),%eax
801066bf:	e8 3d f8 ff ff       	call   80105f01 <walkpgdir>
  if((*pte & PTE_P) == 0)
801066c4:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801066c6:	89 c2                	mov    %eax,%edx
801066c8:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801066cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066d0:	05 00 00 00 80       	add    $0x80000000,%eax
801066d5:	83 fa 05             	cmp    $0x5,%edx
801066d8:	ba 00 00 00 00       	mov    $0x0,%edx
801066dd:	0f 45 c2             	cmovne %edx,%eax
}
801066e0:	c9                   	leave  
801066e1:	c3                   	ret    

801066e2 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801066e2:	f3 0f 1e fb          	endbr32 
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
801066e9:	57                   	push   %edi
801066ea:	56                   	push   %esi
801066eb:	53                   	push   %ebx
801066ec:	83 ec 0c             	sub    $0xc,%esp
801066ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801066f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801066f6:	74 55                	je     8010674d <copyout+0x6b>
    va0 = (uint)PGROUNDDOWN(va);
801066f8:	89 f7                	mov    %esi,%edi
801066fa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106700:	83 ec 08             	sub    $0x8,%esp
80106703:	57                   	push   %edi
80106704:	ff 75 08             	pushl  0x8(%ebp)
80106707:	e8 9e ff ff ff       	call   801066aa <uva2ka>
    if(pa0 == 0)
8010670c:	83 c4 10             	add    $0x10,%esp
8010670f:	85 c0                	test   %eax,%eax
80106711:	74 41                	je     80106754 <copyout+0x72>
      return -1;
    n = PGSIZE - (va - va0);
80106713:	89 fb                	mov    %edi,%ebx
80106715:	29 f3                	sub    %esi,%ebx
80106717:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010671d:	3b 5d 14             	cmp    0x14(%ebp),%ebx
80106720:	0f 47 5d 14          	cmova  0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106724:	83 ec 04             	sub    $0x4,%esp
80106727:	53                   	push   %ebx
80106728:	ff 75 10             	pushl  0x10(%ebp)
8010672b:	29 fe                	sub    %edi,%esi
8010672d:	01 f0                	add    %esi,%eax
8010672f:	50                   	push   %eax
80106730:	e8 a7 d8 ff ff       	call   80103fdc <memmove>
    len -= n;
    buf += n;
80106735:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106738:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
  while(len > 0){
8010673e:	83 c4 10             	add    $0x10,%esp
80106741:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106744:	75 b2                	jne    801066f8 <copyout+0x16>
  }
  return 0;
80106746:	b8 00 00 00 00       	mov    $0x0,%eax
8010674b:	eb 0c                	jmp    80106759 <copyout+0x77>
8010674d:	b8 00 00 00 00       	mov    $0x0,%eax
80106752:	eb 05                	jmp    80106759 <copyout+0x77>
      return -1;
80106754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010675c:	5b                   	pop    %ebx
8010675d:	5e                   	pop    %esi
8010675e:	5f                   	pop    %edi
8010675f:	5d                   	pop    %ebp
80106760:	c3                   	ret    

80106761 <set_bit>:

#include <stdbool.h>


int set_bit(int num,int i)
{
80106761:	f3 0f 1e fb          	endbr32 
80106765:	55                   	push   %ebp
80106766:	89 e5                	mov    %esp,%ebp
	return num | (1<<i);
80106768:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010676b:	b8 01 00 00 00       	mov    $0x1,%eax
80106770:	d3 e0                	shl    %cl,%eax
80106772:	0b 45 08             	or     0x8(%ebp),%eax
}
80106775:	5d                   	pop    %ebp
80106776:	c3                   	ret    

80106777 <get_bit>:
int get_bit(int num,int i)
{
80106777:	f3 0f 1e fb          	endbr32 
8010677b:	55                   	push   %ebp
8010677c:	89 e5                	mov    %esp,%ebp
	return ((num&(1<<i))!=0);
8010677e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106781:	8b 45 08             	mov    0x8(%ebp),%eax
80106784:	d3 f8                	sar    %cl,%eax
80106786:	83 e0 01             	and    $0x1,%eax
}
80106789:	5d                   	pop    %ebp
8010678a:	c3                   	ret    

8010678b <clear_bit>:

int clear_bit(int num,int i)
{
8010678b:	f3 0f 1e fb          	endbr32 
8010678f:	55                   	push   %ebp
80106790:	89 e5                	mov    %esp,%ebp
	int mask=~(1<<i);
80106792:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106795:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
8010679a:	d3 c0                	rol    %cl,%eax
	return num&mask;
8010679c:	23 45 08             	and    0x8(%ebp),%eax
}
8010679f:	5d                   	pop    %ebp
801067a0:	c3                   	ret    

801067a1 <getnumofBits>:

unsigned int getnumofBits(unsigned int n)
{
801067a1:	f3 0f 1e fb          	endbr32 
801067a5:	55                   	push   %ebp
801067a6:	89 e5                	mov    %esp,%ebp
801067a8:	8b 45 08             	mov    0x8(%ebp),%eax
	unsigned count=0;
	while(n!=0)
801067ab:	85 c0                	test   %eax,%eax
801067ad:	74 10                	je     801067bf <getnumofBits+0x1e>
	unsigned count=0;
801067af:	ba 00 00 00 00       	mov    $0x0,%edx
	{
		n>>=1;
		count+=1;
801067b4:	83 c2 01             	add    $0x1,%edx
	while(n!=0)
801067b7:	d1 e8                	shr    %eax
801067b9:	75 f9                	jne    801067b4 <getnumofBits+0x13>
	}
	return count;
}
801067bb:	89 d0                	mov    %edx,%eax
801067bd:	5d                   	pop    %ebp
801067be:	c3                   	ret    
	unsigned count=0;
801067bf:	89 c2                	mov    %eax,%edx
	return count;
801067c1:	eb f8                	jmp    801067bb <getnumofBits+0x1a>

801067c3 <nextPowerOf2>:
unsigned int nextPowerOf2(unsigned int n)
{
801067c3:	f3 0f 1e fb          	endbr32 
801067c7:	55                   	push   %ebp
801067c8:	89 e5                	mov    %esp,%ebp
801067ca:	83 ec 08             	sub    $0x8,%esp
801067cd:	8b 55 08             	mov    0x8(%ebp),%edx
	if(n>=0 && n<8)
		return 8;
801067d0:	b8 08 00 00 00       	mov    $0x8,%eax
	if(n>=0 && n<8)
801067d5:	83 fa 07             	cmp    $0x7,%edx
801067d8:	76 1e                	jbe    801067f8 <nextPowerOf2+0x35>
	if(n && !(n&(n-1)))
801067da:	8d 4a ff             	lea    -0x1(%edx),%ecx
		return n;
801067dd:	89 d0                	mov    %edx,%eax
	if(n && !(n&(n-1)))
801067df:	85 d1                	test   %edx,%ecx
801067e1:	74 15                	je     801067f8 <nextPowerOf2+0x35>
	return 1<<getnumofBits(n);
801067e3:	83 ec 0c             	sub    $0xc,%esp
801067e6:	52                   	push   %edx
801067e7:	e8 b5 ff ff ff       	call   801067a1 <getnumofBits>
801067ec:	83 c4 10             	add    $0x10,%esp
801067ef:	89 c1                	mov    %eax,%ecx
801067f1:	b8 01 00 00 00       	mov    $0x1,%eax
801067f6:	d3 e0                	shl    %cl,%eax
}
801067f8:	c9                   	leave  
801067f9:	c3                   	ret    

801067fa <getslabIdx>:
unsigned int getslabIdx(unsigned int n)
{
801067fa:	f3 0f 1e fb          	endbr32 
801067fe:	55                   	push   %ebp
801067ff:	89 e5                	mov    %esp,%ebp
80106801:	83 ec 14             	sub    $0x14,%esp
	unsigned slabIdx=getnumofBits(n)-4;
80106804:	ff 75 08             	pushl  0x8(%ebp)
80106807:	e8 95 ff ff ff       	call   801067a1 <getnumofBits>
8010680c:	83 c4 10             	add    $0x10,%esp
8010680f:	83 e8 04             	sub    $0x4,%eax
	return slabIdx;
}
80106812:	c9                   	leave  
80106813:	c3                   	ret    

80106814 <returnOffset>:
	struct spinlock lock;
	struct slab slab[NSLAB];
} stable;

int returnOffset(int row,int column)
{
80106814:	f3 0f 1e fb          	endbr32 
80106818:	55                   	push   %ebp
80106819:	89 e5                	mov    %esp,%ebp
	return 8*row + column;
8010681b:	8b 45 08             	mov    0x8(%ebp),%eax
8010681e:	c1 e0 03             	shl    $0x3,%eax
80106821:	03 45 0c             	add    0xc(%ebp),%eax
}
80106824:	5d                   	pop    %ebp
80106825:	c3                   	ret    

80106826 <setBitmap>:

int setBitmap(int slabIdx)
{
80106826:	f3 0f 1e fb          	endbr32 
8010682a:	55                   	push   %ebp
8010682b:	89 e5                	mov    %esp,%ebp
8010682d:	56                   	push   %esi
8010682e:	53                   	push   %ebx
	{
		if(s->bitmap[j]==0xFF)
			continue;
		for(int k=0;k<=7;k++)
		{
			if(!(s->bitmap[j]&(1<<k)))
8010682f:	69 45 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%eax
80106836:	8b b0 68 6a 11 80    	mov    -0x7fee9598(%eax),%esi
	for(int j=0;j<PGSIZE;j++)
8010683c:	b9 00 00 00 00       	mov    $0x0,%ecx
80106841:	eb 1c                	jmp    8010685f <setBitmap+0x39>
		for(int k=0;k<=7;k++)
80106843:	b8 00 00 00 00       	mov    $0x0,%eax
	return num | (1<<i);
80106848:	0f ab c2             	bts    %eax,%edx
			{
				s->bitmap[j]=set_bit(s->bitmap[j],k);
8010684b:	88 13                	mov    %dl,(%ebx)
	return 8*row + column;
8010684d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				return returnOffset(j,k);
			}
		}
	}
	return 0; //Unable to find empty space of bitmap
}
80106850:	5b                   	pop    %ebx
80106851:	5e                   	pop    %esi
80106852:	5d                   	pop    %ebp
80106853:	c3                   	ret    
	for(int j=0;j<PGSIZE;j++)
80106854:	83 c1 01             	add    $0x1,%ecx
80106857:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
8010685d:	74 22                	je     80106881 <setBitmap+0x5b>
			if(!(s->bitmap[j]&(1<<k)))
8010685f:	8d 1c 0e             	lea    (%esi,%ecx,1),%ebx
80106862:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
80106866:	0f be d0             	movsbl %al,%edx
80106869:	a8 01                	test   $0x1,%al
8010686b:	74 d6                	je     80106843 <setBitmap+0x1d>
		for(int k=0;k<=7;k++)
8010686d:	b8 01 00 00 00       	mov    $0x1,%eax
			if(!(s->bitmap[j]&(1<<k)))
80106872:	0f a3 c2             	bt     %eax,%edx
80106875:	73 d1                	jae    80106848 <setBitmap+0x22>
		for(int k=0;k<=7;k++)
80106877:	83 c0 01             	add    $0x1,%eax
8010687a:	83 f8 08             	cmp    $0x8,%eax
8010687d:	75 f3                	jne    80106872 <setBitmap+0x4c>
8010687f:	eb d3                	jmp    80106854 <setBitmap+0x2e>
	return 0; //Unable to find empty space of bitmap
80106881:	b8 00 00 00 00       	mov    $0x0,%eax
80106886:	eb c8                	jmp    80106850 <setBitmap+0x2a>

80106888 <getRow>:

int getRow(int offset)
{
80106888:	f3 0f 1e fb          	endbr32 
8010688c:	55                   	push   %ebp
8010688d:	89 e5                	mov    %esp,%ebp
8010688f:	8b 55 08             	mov    0x8(%ebp),%edx
	return offset/8;
80106892:	8d 42 07             	lea    0x7(%edx),%eax
80106895:	85 d2                	test   %edx,%edx
80106897:	0f 49 c2             	cmovns %edx,%eax
8010689a:	c1 f8 03             	sar    $0x3,%eax
}
8010689d:	5d                   	pop    %ebp
8010689e:	c3                   	ret    

8010689f <getColumn>:
int getColumn(int offset)
{
8010689f:	f3 0f 1e fb          	endbr32 
801068a3:	55                   	push   %ebp
801068a4:	89 e5                	mov    %esp,%ebp
801068a6:	8b 45 08             	mov    0x8(%ebp),%eax
	return offset%8;
801068a9:	99                   	cltd   
801068aa:	c1 ea 1d             	shr    $0x1d,%edx
801068ad:	01 d0                	add    %edx,%eax
801068af:	83 e0 07             	and    $0x7,%eax
801068b2:	29 d0                	sub    %edx,%eax
}
801068b4:	5d                   	pop    %ebp
801068b5:	c3                   	ret    

801068b6 <clearBitmap>:
bool clearBitmap(int slabIdx,int offset)
{
801068b6:	f3 0f 1e fb          	endbr32 
801068ba:	55                   	push   %ebp
801068bb:	89 e5                	mov    %esp,%ebp
801068bd:	53                   	push   %ebx
801068be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	return offset%8;
801068c1:	89 d9                	mov    %ebx,%ecx
801068c3:	c1 f9 1f             	sar    $0x1f,%ecx
801068c6:	c1 e9 1d             	shr    $0x1d,%ecx
801068c9:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
801068cc:	83 e2 07             	and    $0x7,%edx
801068cf:	29 ca                	sub    %ecx,%edx
	struct slab *s;
	s=&stable.slab[slabIdx];
	bool checkbit=true;
	int row=getRow(offset);
	int column=getColumn(offset);
	if(get_bit(s->bitmap[row],column))
801068d1:	69 4d 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%ecx
	return offset/8;
801068d8:	8d 43 07             	lea    0x7(%ebx),%eax
801068db:	85 db                	test   %ebx,%ebx
801068dd:	0f 49 c3             	cmovns %ebx,%eax
801068e0:	c1 f8 03             	sar    $0x3,%eax
	if(get_bit(s->bitmap[row],column))
801068e3:	03 81 68 6a 11 80    	add    -0x7fee9598(%ecx),%eax
801068e9:	0f be 08             	movsbl (%eax),%ecx
		s->bitmap[row]=clear_bit(s->bitmap[row],column);
	else
		checkbit=false;
801068ec:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(get_bit(s->bitmap[row],column))
801068f1:	0f a3 d1             	bt     %edx,%ecx
801068f4:	73 0a                	jae    80106900 <clearBitmap+0x4a>
	return num&mask;
801068f6:	0f b3 d1             	btr    %edx,%ecx
		s->bitmap[row]=clear_bit(s->bitmap[row],column);
801068f9:	88 08                	mov    %cl,(%eax)
	bool checkbit=true;
801068fb:	bb 01 00 00 00       	mov    $0x1,%ebx
	return checkbit;
}
80106900:	89 d8                	mov    %ebx,%eax
80106902:	5b                   	pop    %ebx
80106903:	5d                   	pop    %ebp
80106904:	c3                   	ret    

80106905 <checkEmpty>:

bool checkEmpty(int startOffset,int endOffset,int slabIdx)
{
80106905:	f3 0f 1e fb          	endbr32 
80106909:	55                   	push   %ebp
8010690a:	89 e5                	mov    %esp,%ebp
8010690c:	57                   	push   %edi
8010690d:	56                   	push   %esi
8010690e:	53                   	push   %ebx
8010690f:	83 ec 0c             	sub    $0xc,%esp
80106912:	8b 55 08             	mov    0x8(%ebp),%edx
80106915:	8b 45 0c             	mov    0xc(%ebp),%eax
	return offset/8;
80106918:	8d 4a 07             	lea    0x7(%edx),%ecx
8010691b:	85 d2                	test   %edx,%edx
8010691d:	0f 49 ca             	cmovns %edx,%ecx
80106920:	c1 f9 03             	sar    $0x3,%ecx
80106923:	89 4d ec             	mov    %ecx,-0x14(%ebp)
80106926:	89 cb                	mov    %ecx,%ebx
	return offset%8;
80106928:	89 d6                	mov    %edx,%esi
8010692a:	c1 fe 1f             	sar    $0x1f,%esi
8010692d:	c1 ee 1d             	shr    $0x1d,%esi
80106930:	8d 0c 32             	lea    (%edx,%esi,1),%ecx
80106933:	83 e1 07             	and    $0x7,%ecx
80106936:	29 f1                	sub    %esi,%ecx
	return offset/8;
80106938:	8d 50 07             	lea    0x7(%eax),%edx
8010693b:	85 c0                	test   %eax,%eax
8010693d:	0f 49 d0             	cmovns %eax,%edx
80106940:	c1 fa 03             	sar    $0x3,%edx
80106943:	89 55 e8             	mov    %edx,-0x18(%ebp)
80106946:	89 55 f0             	mov    %edx,-0x10(%ebp)
	return offset%8;
80106949:	89 c2                	mov    %eax,%edx
8010694b:	c1 fa 1f             	sar    $0x1f,%edx
8010694e:	89 d7                	mov    %edx,%edi
80106950:	c1 ef 1d             	shr    $0x1d,%edi
80106953:	8d 14 38             	lea    (%eax,%edi,1),%edx
80106956:	83 e2 07             	and    $0x7,%edx
80106959:	29 fa                	sub    %edi,%edx
	int startColumn=getColumn(startOffset);
	int endRow=getRow(endOffset);
	int endColumn=getColumn(endOffset);
	// cprintf("startOffset: %d, endOffset %d\n",startOffset,endOffset);
	// cprintf("startRow:%d endRow:%d\n",startRow,endRow);
	for(int i=startRow;i<=endRow;i++)
8010695b:	8b 7d e8             	mov    -0x18(%ebp),%edi
8010695e:	39 df                	cmp    %ebx,%edi
80106960:	7c 55                	jl     801069b7 <checkEmpty+0xb2>
80106962:	89 ce                	mov    %ecx,%esi
80106964:	b8 01 00 00 00       	mov    $0x1,%eax
80106969:	d3 e0                	shl    %cl,%eax
8010696b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	{
		for(int j=startColumn;j<=endColumn;j++)
		{
			if(get_bit(s->bitmap[i],j))
8010696e:	69 7d 10 a8 01 00 00 	imul   $0x1a8,0x10(%ebp),%edi
80106975:	81 c7 20 6a 11 80    	add    $0x80116a20,%edi
8010697b:	eb 08                	jmp    80106985 <checkEmpty+0x80>
	for(int i=startRow;i<=endRow;i++)
8010697d:	83 c3 01             	add    $0x1,%ebx
80106980:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
80106983:	7f 39                	jg     801069be <checkEmpty+0xb9>
		for(int j=startColumn;j<=endColumn;j++)
80106985:	39 f2                	cmp    %esi,%edx
80106987:	7c f4                	jl     8010697d <checkEmpty+0x78>
			if(get_bit(s->bitmap[i],j))
80106989:	8b 47 48             	mov    0x48(%edi),%eax
8010698c:	0f be 0c 18          	movsbl (%eax,%ebx,1),%ecx
80106990:	85 4d ec             	test   %ecx,-0x14(%ebp)
80106993:	75 1b                	jne    801069b0 <checkEmpty+0xab>
		for(int j=startColumn;j<=endColumn;j++)
80106995:	89 f0                	mov    %esi,%eax
80106997:	83 c0 01             	add    $0x1,%eax
8010699a:	39 d0                	cmp    %edx,%eax
8010699c:	7f df                	jg     8010697d <checkEmpty+0x78>
			if(get_bit(s->bitmap[i],j))
8010699e:	0f a3 c1             	bt     %eax,%ecx
801069a1:	73 f4                	jae    80106997 <checkEmpty+0x92>
801069a3:	b8 00 00 00 00       	mov    $0x0,%eax
		}
		if(empty==false)
			break;
	}
	return empty;
}
801069a8:	83 c4 0c             	add    $0xc,%esp
801069ab:	5b                   	pop    %ebx
801069ac:	5e                   	pop    %esi
801069ad:	5f                   	pop    %edi
801069ae:	5d                   	pop    %ebp
801069af:	c3                   	ret    
			if(get_bit(s->bitmap[i],j))
801069b0:	b8 00 00 00 00       	mov    $0x0,%eax
801069b5:	eb f1                	jmp    801069a8 <checkEmpty+0xa3>
	bool empty=true;
801069b7:	b8 01 00 00 00       	mov    $0x1,%eax
801069bc:	eb ea                	jmp    801069a8 <checkEmpty+0xa3>
801069be:	b8 01 00 00 00       	mov    $0x1,%eax
	return empty;
801069c3:	eb e3                	jmp    801069a8 <checkEmpty+0xa3>

801069c5 <checkNewpage>:

int checkNewpage(int slabIdx)
{
801069c5:	f3 0f 1e fb          	endbr32 
801069c9:	55                   	push   %ebp
801069ca:	89 e5                	mov    %esp,%ebp
801069cc:	57                   	push   %edi
801069cd:	56                   	push   %esi
801069ce:	53                   	push   %ebx
801069cf:	8b 7d 08             	mov    0x8(%ebp),%edi
	bool find0=false;
	for(int i=0;i<PGSIZE;i++)
	{
		for(int j=0;j<=7;j++)
		{
			if(get_bit(s->bitmap[i],j))
801069d2:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
801069d8:	8b 88 68 6a 11 80    	mov    -0x7fee9598(%eax),%ecx
801069de:	8d b1 00 10 00 00    	lea    0x1000(%ecx),%esi
	int cnt=0;
801069e4:	bb 00 00 00 00       	mov    $0x0,%ebx
801069e9:	eb 07                	jmp    801069f2 <checkNewpage+0x2d>
	for(int i=0;i<PGSIZE;i++)
801069eb:	83 c1 01             	add    $0x1,%ecx
801069ee:	39 f1                	cmp    %esi,%ecx
801069f0:	74 24                	je     80106a16 <checkNewpage+0x51>
			if(get_bit(s->bitmap[i],j))
801069f2:	0f b6 01             	movzbl (%ecx),%eax
801069f5:	0f be d0             	movsbl %al,%edx
801069f8:	a8 01                	test   $0x1,%al
801069fa:	74 1a                	je     80106a16 <checkNewpage+0x51>
				cnt++;
801069fc:	83 c3 01             	add    $0x1,%ebx
		for(int j=0;j<=7;j++)
801069ff:	b8 01 00 00 00       	mov    $0x1,%eax
			if(get_bit(s->bitmap[i],j))
80106a04:	0f a3 c2             	bt     %eax,%edx
80106a07:	73 0d                	jae    80106a16 <checkNewpage+0x51>
				cnt++;
80106a09:	83 c3 01             	add    $0x1,%ebx
		for(int j=0;j<=7;j++)
80106a0c:	83 c0 01             	add    $0x1,%eax
80106a0f:	83 f8 08             	cmp    $0x8,%eax
80106a12:	75 f0                	jne    80106a04 <checkNewpage+0x3f>
80106a14:	eb d5                	jmp    801069eb <checkNewpage+0x26>
			}
		}
		if(find0)
			break;
	}
	if(cnt%s->num_objects_per_page==0)
80106a16:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106a1c:	8b 88 64 6a 11 80    	mov    -0x7fee959c(%eax),%ecx
80106a22:	89 d8                	mov    %ebx,%eax
80106a24:	99                   	cltd   
80106a25:	f7 f9                	idiv   %ecx
80106a27:	89 d6                	mov    %edx,%esi
80106a29:	85 d2                	test   %edx,%edx
80106a2b:	75 28                	jne    80106a55 <checkNewpage+0x90>
	{
		int startOffset=(cnt/s->num_objects_per_page)*s->num_objects_per_page;
80106a2d:	89 d8                	mov    %ebx,%eax
80106a2f:	99                   	cltd   
80106a30:	f7 f9                	idiv   %ecx
80106a32:	89 c3                	mov    %eax,%ebx
80106a34:	0f af d9             	imul   %ecx,%ebx
		int endOffset=(startOffset+s->num_objects_per_page)-1;
		if(checkEmpty(startOffset,endOffset,slabIdx))
80106a37:	57                   	push   %edi
		int endOffset=(startOffset+s->num_objects_per_page)-1;
80106a38:	8d 44 19 ff          	lea    -0x1(%ecx,%ebx,1),%eax
		if(checkEmpty(startOffset,endOffset,slabIdx))
80106a3c:	50                   	push   %eax
80106a3d:	53                   	push   %ebx
80106a3e:	e8 c2 fe ff ff       	call   80106905 <checkEmpty>
80106a43:	83 c4 0c             	add    $0xc,%esp
		{
			return startOffset;
80106a46:	84 c0                	test   %al,%al
80106a48:	0f 45 f3             	cmovne %ebx,%esi
		}
	}
	return 0;
}
80106a4b:	89 f0                	mov    %esi,%eax
80106a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a50:	5b                   	pop    %ebx
80106a51:	5e                   	pop    %esi
80106a52:	5f                   	pop    %edi
80106a53:	5d                   	pop    %ebp
80106a54:	c3                   	ret    
	return 0;
80106a55:	be 00 00 00 00       	mov    $0x0,%esi
80106a5a:	eb ef                	jmp    80106a4b <checkNewpage+0x86>

80106a5c <getpageNum>:


int getpageNum(int slabIdx)
{
80106a5c:	f3 0f 1e fb          	endbr32 
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 04             	sub    $0x4,%esp
80106a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
	struct slab *s;
	s=&stable.slab[slabIdx];
	int page=0;
	//size 2048 - 1024
	if(slabIdx>=7)
80106a6c:	83 f9 06             	cmp    $0x6,%ecx
80106a6f:	7f 2e                	jg     80106a9f <getpageNum+0x43>
	//size 8 - 512
	else
	{
		for(int i=0;i<PGSIZE;i+=(512/s->size))
		{
			for(int j=i;j<i+(512/s->size);j++)
80106a71:	69 f9 a8 01 00 00    	imul   $0x1a8,%ecx,%edi
80106a77:	b8 00 02 00 00       	mov    $0x200,%eax
80106a7c:	99                   	cltd   
80106a7d:	f7 bf 54 6a 11 80    	idivl  -0x7fee95ac(%edi)
80106a83:	89 c7                	mov    %eax,%edi
80106a85:	bb 00 00 00 00       	mov    $0x0,%ebx
	int page=0;
80106a8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			{
				if(s->bitmap[j]!=0x00)
80106a91:	69 c9 a8 01 00 00    	imul   $0x1a8,%ecx,%ecx
80106a97:	81 c1 20 6a 11 80    	add    $0x80116a20,%ecx
80106a9d:	eb 71                	jmp    80106b10 <getpageNum+0xb4>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
80106a9f:	69 f9 a8 01 00 00    	imul   $0x1a8,%ecx,%edi
80106aa5:	b8 00 10 00 00       	mov    $0x1000,%eax
80106aaa:	99                   	cltd   
80106aab:	f7 bf 54 6a 11 80    	idivl  -0x7fee95ac(%edi)
80106ab1:	89 c6                	mov    %eax,%esi
		for(int i=0;i<PGSIZE;i++)
80106ab3:	bb 00 00 00 00       	mov    $0x0,%ebx
	int page=0;
80106ab8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
					if(get_bit(s->bitmap[i],k))
80106abf:	8d bf 20 6a 11 80    	lea    -0x7fee95e0(%edi),%edi
80106ac5:	eb 36                	jmp    80106afd <getpageNum+0xa1>
						page++;
80106ac7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			for(int j=0;j<=7;j+=(PGSIZE/s->size))
80106acb:	83 fa 07             	cmp    $0x7,%edx
80106ace:	7f 22                	jg     80106af2 <getpageNum+0x96>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
80106ad0:	89 d0                	mov    %edx,%eax
80106ad2:	01 f2                	add    %esi,%edx
80106ad4:	39 c2                	cmp    %eax,%edx
80106ad6:	7e f3                	jle    80106acb <getpageNum+0x6f>
					if(get_bit(s->bitmap[i],k))
80106ad8:	8b 4f 48             	mov    0x48(%edi),%ecx
80106adb:	0f be 0c 19          	movsbl (%ecx,%ebx,1),%ecx
80106adf:	0f a3 c1             	bt     %eax,%ecx
80106ae2:	72 e3                	jb     80106ac7 <getpageNum+0x6b>
				for(int k=j;k<j+(PGSIZE/s->size);k++)
80106ae4:	83 c0 01             	add    $0x1,%eax
80106ae7:	39 d0                	cmp    %edx,%eax
80106ae9:	74 e0                	je     80106acb <getpageNum+0x6f>
					if(get_bit(s->bitmap[i],k))
80106aeb:	0f a3 c1             	bt     %eax,%ecx
80106aee:	73 f4                	jae    80106ae4 <getpageNum+0x88>
80106af0:	eb d5                	jmp    80106ac7 <getpageNum+0x6b>
		for(int i=0;i<PGSIZE;i++)
80106af2:	83 c3 01             	add    $0x1,%ebx
80106af5:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80106afb:	74 34                	je     80106b31 <getpageNum+0xd5>
			for(int j=0;j<=7;j+=(PGSIZE/s->size))
80106afd:	ba 00 00 00 00       	mov    $0x0,%edx
80106b02:	eb cc                	jmp    80106ad0 <getpageNum+0x74>
				{
					page++;
80106b04:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
		for(int i=0;i<PGSIZE;i+=(512/s->size))
80106b08:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b0e:	7f 21                	jg     80106b31 <getpageNum+0xd5>
80106b10:	89 da                	mov    %ebx,%edx
			for(int j=i;j<i+(512/s->size);j++)
80106b12:	89 d8                	mov    %ebx,%eax
80106b14:	01 fb                	add    %edi,%ebx
80106b16:	89 de                	mov    %ebx,%esi
80106b18:	39 d3                	cmp    %edx,%ebx
80106b1a:	7e ec                	jle    80106b08 <getpageNum+0xac>
				if(s->bitmap[j]!=0x00)
80106b1c:	8b 51 48             	mov    0x48(%ecx),%edx
80106b1f:	01 d0                	add    %edx,%eax
80106b21:	01 da                	add    %ebx,%edx
80106b23:	80 38 00             	cmpb   $0x0,(%eax)
80106b26:	75 dc                	jne    80106b04 <getpageNum+0xa8>
			for(int j=i;j<i+(512/s->size);j++)
80106b28:	83 c0 01             	add    $0x1,%eax
80106b2b:	39 d0                	cmp    %edx,%eax
80106b2d:	75 f4                	jne    80106b23 <getpageNum+0xc7>
80106b2f:	eb d7                	jmp    80106b08 <getpageNum+0xac>
				}
			}
		}
	}
	return page;
}
80106b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b34:	83 c4 04             	add    $0x4,%esp
80106b37:	5b                   	pop    %ebx
80106b38:	5e                   	pop    %esi
80106b39:	5f                   	pop    %edi
80106b3a:	5d                   	pop    %ebp
80106b3b:	c3                   	ret    

80106b3c <slabinit>:

void slabinit()
{
80106b3c:	f3 0f 1e fb          	endbr32 
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 18             	sub    $0x18,%esp
	acquire(&stable.lock);
80106b49:	68 20 6a 11 80       	push   $0x80116a20
80106b4e:	e8 46 d3 ff ff       	call   80103e99 <acquire>
	stable.slab[0].size=8;
80106b53:	c7 05 54 6a 11 80 08 	movl   $0x8,0x80116a54
80106b5a:	00 00 00 
	stable.slab[0].num_objects_per_page=PGSIZE/stable.slab[0].size;
80106b5d:	c7 05 64 6a 11 80 00 	movl   $0x200,0x80116a64
80106b64:	02 00 00 
	stable.slab[0].num_used_objects=0;
80106b67:	c7 05 60 6a 11 80 00 	movl   $0x0,0x80116a60
80106b6e:	00 00 00 
	stable.slab[0].num_free_objects=stable.slab[0].num_objects_per_page*64;
80106b71:	c7 05 5c 6a 11 80 00 	movl   $0x8000,0x80116a5c
80106b78:	80 00 00 
	//allocate one page for bitmap, allocate one page for slab cache
	stable.slab[0].bitmap=stable.slab[0].page[0];
80106b7b:	a1 6c 6a 11 80       	mov    0x80116a6c,%eax
80106b80:	a3 68 6a 11 80       	mov    %eax,0x80116a68
	stable.slab[0].bitmap=kalloc();
80106b85:	e8 8f b6 ff ff       	call   80102219 <kalloc>
80106b8a:	a3 68 6a 11 80       	mov    %eax,0x80116a68
	memset(stable.slab[0].bitmap,0,PGSIZE);
80106b8f:	83 c4 0c             	add    $0xc,%esp
80106b92:	68 00 10 00 00       	push   $0x1000
80106b97:	6a 00                	push   $0x0
80106b99:	50                   	push   %eax
80106b9a:	e8 b0 d3 ff ff       	call   80103f4f <memset>
	stable.slab[0].page[1]=kalloc();
80106b9f:	e8 75 b6 ff ff       	call   80102219 <kalloc>
80106ba4:	a3 70 6a 11 80       	mov    %eax,0x80116a70
	stable.slab[0].num_pages=1;
80106ba9:	c7 05 58 6a 11 80 01 	movl   $0x1,0x80116a58
80106bb0:	00 00 00 
	release(&stable.lock);
80106bb3:	c7 04 24 20 6a 11 80 	movl   $0x80116a20,(%esp)
80106bba:	e8 45 d3 ff ff       	call   80103f04 <release>

	acquire(&stable.lock);
80106bbf:	c7 04 24 20 6a 11 80 	movl   $0x80116a20,(%esp)
80106bc6:	e8 ce d2 ff ff       	call   80103e99 <acquire>
	for(int i=1;i<NSLAB;i++)
80106bcb:	bb 54 6a 11 80       	mov    $0x80116a54,%ebx
80106bd0:	bf 94 77 11 80       	mov    $0x80117794,%edi
80106bd5:	83 c4 10             	add    $0x10,%esp
	{
		stable.slab[i].size=stable.slab[i-1].size*2;
		stable.slab[i].num_objects_per_page=PGSIZE/stable.slab[i].size;
80106bd8:	be 00 10 00 00       	mov    $0x1000,%esi
		stable.slab[i].size=stable.slab[i-1].size*2;
80106bdd:	8b 03                	mov    (%ebx),%eax
80106bdf:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80106be2:	89 8b a8 01 00 00    	mov    %ecx,0x1a8(%ebx)
		stable.slab[i].num_objects_per_page=PGSIZE/stable.slab[i].size;
80106be8:	89 f0                	mov    %esi,%eax
80106bea:	99                   	cltd   
80106beb:	f7 f9                	idiv   %ecx
80106bed:	89 83 b8 01 00 00    	mov    %eax,0x1b8(%ebx)
		stable.slab[i].num_used_objects=0;
80106bf3:	c7 83 b4 01 00 00 00 	movl   $0x0,0x1b4(%ebx)
80106bfa:	00 00 00 
		stable.slab[i].num_free_objects=stable.slab[i].num_objects_per_page*MAX_PAGES_PER_SLAB;
80106bfd:	6b c0 64             	imul   $0x64,%eax,%eax
80106c00:	89 83 b0 01 00 00    	mov    %eax,0x1b0(%ebx)
		//allocate one page for bitmap, allocate one page for slab cache
		stable.slab[i].bitmap=stable.slab[i].page[0];
80106c06:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80106c0c:	89 83 bc 01 00 00    	mov    %eax,0x1bc(%ebx)
		stable.slab[i].bitmap=kalloc();
80106c12:	e8 02 b6 ff ff       	call   80102219 <kalloc>
80106c17:	89 83 bc 01 00 00    	mov    %eax,0x1bc(%ebx)
		memset(stable.slab[i].bitmap,0,PGSIZE);
80106c1d:	83 ec 04             	sub    $0x4,%esp
80106c20:	68 00 10 00 00       	push   $0x1000
80106c25:	6a 00                	push   $0x0
80106c27:	50                   	push   %eax
80106c28:	e8 22 d3 ff ff       	call   80103f4f <memset>
		stable.slab[i].page[1]=kalloc();
80106c2d:	e8 e7 b5 ff ff       	call   80102219 <kalloc>
80106c32:	89 83 c4 01 00 00    	mov    %eax,0x1c4(%ebx)
		stable.slab[i].num_pages=1;
80106c38:	c7 83 ac 01 00 00 01 	movl   $0x1,0x1ac(%ebx)
80106c3f:	00 00 00 
	for(int i=1;i<NSLAB;i++)
80106c42:	81 c3 a8 01 00 00    	add    $0x1a8,%ebx
80106c48:	83 c4 10             	add    $0x10,%esp
80106c4b:	39 fb                	cmp    %edi,%ebx
80106c4d:	75 8e                	jne    80106bdd <slabinit+0xa1>
	}
	release(&stable.lock);
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 20 6a 11 80       	push   $0x80116a20
80106c57:	e8 a8 d2 ff ff       	call   80103f04 <release>
}
80106c5c:	83 c4 10             	add    $0x10,%esp
80106c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c62:	5b                   	pop    %ebx
80106c63:	5e                   	pop    %esi
80106c64:	5f                   	pop    %edi
80106c65:	5d                   	pop    %ebp
80106c66:	c3                   	ret    

80106c67 <kmalloc>:
char *kmalloc(int size){
80106c67:	f3 0f 1e fb          	endbr32 
80106c6b:	55                   	push   %ebp
80106c6c:	89 e5                	mov    %esp,%ebp
80106c6e:	57                   	push   %edi
80106c6f:	56                   	push   %esi
80106c70:	53                   	push   %ebx
80106c71:	83 ec 0c             	sub    $0xc,%esp
80106c74:	8b 7d 08             	mov    0x8(%ebp),%edi
	
	//out of range error needs to be handled
	if(size > 2048 || size<=0)
80106c77:	8d 57 ff             	lea    -0x1(%edi),%edx
		return 0;
80106c7a:	b8 00 00 00 00       	mov    $0x0,%eax
	if(size > 2048 || size<=0)
80106c7f:	81 fa ff 07 00 00    	cmp    $0x7ff,%edx
80106c85:	0f 87 dc 00 00 00    	ja     80106d67 <kmalloc+0x100>
	//choose the byte 8 or 16 .. etc by getting index of slab
	int slabIdx=getslabIdx(nextPowerOf2(size));
80106c8b:	83 ec 0c             	sub    $0xc,%esp
80106c8e:	57                   	push   %edi
80106c8f:	e8 2f fb ff ff       	call   801067c3 <nextPowerOf2>
80106c94:	89 04 24             	mov    %eax,(%esp)
80106c97:	e8 5e fb ff ff       	call   801067fa <getslabIdx>
80106c9c:	83 c4 10             	add    $0x10,%esp
80106c9f:	89 c6                	mov    %eax,%esi
	struct slab *s;
	s=&stable.slab[slabIdx];
	//can't alloc if num of used object is full
	if(s->num_used_objects==s->num_objects_per_page*MAX_PAGES_PER_SLAB)
80106ca1:	69 c0 a8 01 00 00    	imul   $0x1a8,%eax,%eax
80106ca7:	6b 90 64 6a 11 80 64 	imul   $0x64,-0x7fee959c(%eax),%edx
80106cae:	39 90 60 6a 11 80    	cmp    %edx,-0x7fee95a0(%eax)
80106cb4:	0f 84 db 00 00 00    	je     80106d95 <kmalloc+0x12e>
		return 0;
	if(stable.slab[0].num_used_objects==stable.slab[0].num_objects_per_page*64)
80106cba:	a1 64 6a 11 80       	mov    0x80116a64,%eax
80106cbf:	c1 e0 06             	shl    $0x6,%eax
80106cc2:	39 05 60 6a 11 80    	cmp    %eax,0x80116a60
80106cc8:	0f 84 ce 00 00 00    	je     80106d9c <kmalloc+0x135>
		return 0;
	
	int startOffset=0;
	acquire(&stable.lock);
80106cce:	83 ec 0c             	sub    $0xc,%esp
80106cd1:	68 20 6a 11 80       	push   $0x80116a20
80106cd6:	e8 be d1 ff ff       	call   80103e99 <acquire>
	if((startOffset=checkNewpage(slabIdx)) && s->num_used_objects!=0)
80106cdb:	89 34 24             	mov    %esi,(%esp)
80106cde:	e8 e2 fc ff ff       	call   801069c5 <checkNewpage>
80106ce3:	83 c4 10             	add    $0x10,%esp
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	74 0f                	je     80106cf9 <kmalloc+0x92>
80106cea:	69 d6 a8 01 00 00    	imul   $0x1a8,%esi,%edx
80106cf0:	83 ba 60 6a 11 80 00 	cmpl   $0x0,-0x7fee95a0(%edx)
80106cf7:	75 76                	jne    80106d6f <kmalloc+0x108>
	{
		s->page[startOffset/s->num_objects_per_page+1]=kalloc(); //current page +1
	}
	
	int bitOffset=setBitmap(slabIdx);
80106cf9:	83 ec 0c             	sub    $0xc,%esp
80106cfc:	56                   	push   %esi
80106cfd:	e8 24 fb ff ff       	call   80106826 <setBitmap>
80106d02:	89 c3                	mov    %eax,%ebx
	//getPageNumfrom bitmap
	s->num_pages=getpageNum(slabIdx);
80106d04:	89 34 24             	mov    %esi,(%esp)
80106d07:	e8 50 fd ff ff       	call   80106a5c <getpageNum>
80106d0c:	83 c4 0c             	add    $0xc,%esp
80106d0f:	69 d6 a8 01 00 00    	imul   $0x1a8,%esi,%edx
80106d15:	8d 8a 20 6a 11 80    	lea    -0x7fee95e0(%edx),%ecx
80106d1b:	89 82 58 6a 11 80    	mov    %eax,-0x7fee95a8(%edx)
	s->num_free_objects-=1;
80106d21:	83 69 3c 01          	subl   $0x1,0x3c(%ecx)
	s->num_used_objects+=1;
80106d25:	83 41 40 01          	addl   $0x1,0x40(%ecx)

	int nowpage=bitOffset/s->num_objects_per_page+1;
80106d29:	89 d8                	mov    %ebx,%eax
80106d2b:	99                   	cltd   
80106d2c:	f7 79 44             	idivl  0x44(%ecx)
80106d2f:	89 d3                	mov    %edx,%ebx
	int pageOffset=(bitOffset%s->num_objects_per_page)*(1<<(slabIdx+3))*sizeof(char);
80106d31:	8d 4e 03             	lea    0x3(%esi),%ecx
80106d34:	d3 e3                	shl    %cl,%ebx
	memset(s->page[nowpage]+pageOffset,0,size*sizeof(char));
80106d36:	57                   	push   %edi
80106d37:	6a 00                	push   $0x0
80106d39:	6b f6 6a             	imul   $0x6a,%esi,%esi
80106d3c:	8d 74 30 11          	lea    0x11(%eax,%esi,1),%esi
80106d40:	89 d8                	mov    %ebx,%eax
80106d42:	03 04 b5 2c 6a 11 80 	add    -0x7fee95d4(,%esi,4),%eax
80106d49:	50                   	push   %eax
80106d4a:	e8 00 d2 ff ff       	call   80103f4f <memset>
	release(&stable.lock);
80106d4f:	c7 04 24 20 6a 11 80 	movl   $0x80116a20,(%esp)
80106d56:	e8 a9 d1 ff ff       	call   80103f04 <release>
	return s->page[nowpage]+pageOffset;
80106d5b:	89 d8                	mov    %ebx,%eax
80106d5d:	03 04 b5 2c 6a 11 80 	add    -0x7fee95d4(,%esi,4),%eax
80106d64:	83 c4 10             	add    $0x10,%esp
}
80106d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d6a:	5b                   	pop    %ebx
80106d6b:	5e                   	pop    %esi
80106d6c:	5f                   	pop    %edi
80106d6d:	5d                   	pop    %ebp
80106d6e:	c3                   	ret    
		s->page[startOffset/s->num_objects_per_page+1]=kalloc(); //current page +1
80106d6f:	89 d1                	mov    %edx,%ecx
80106d71:	99                   	cltd   
80106d72:	f7 b9 64 6a 11 80    	idivl  -0x7fee959c(%ecx)
80106d78:	8d 58 01             	lea    0x1(%eax),%ebx
80106d7b:	e8 99 b4 ff ff       	call   80102219 <kalloc>
80106d80:	89 c2                	mov    %eax,%edx
80106d82:	6b c6 6a             	imul   $0x6a,%esi,%eax
80106d85:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80106d89:	89 14 85 2c 6a 11 80 	mov    %edx,-0x7fee95d4(,%eax,4)
80106d90:	e9 64 ff ff ff       	jmp    80106cf9 <kmalloc+0x92>
		return 0;
80106d95:	b8 00 00 00 00       	mov    $0x0,%eax
80106d9a:	eb cb                	jmp    80106d67 <kmalloc+0x100>
		return 0;
80106d9c:	b8 00 00 00 00       	mov    $0x0,%eax
80106da1:	eb c4                	jmp    80106d67 <kmalloc+0x100>

80106da3 <kmfree>:

void kmfree(char *addr, int size){
80106da3:	f3 0f 1e fb          	endbr32 
80106da7:	55                   	push   %ebp
80106da8:	89 e5                	mov    %esp,%ebp
80106daa:	57                   	push   %edi
80106dab:	56                   	push   %esi
80106dac:	53                   	push   %ebx
80106dad:	83 ec 28             	sub    $0x28,%esp
80106db0:	8b 75 08             	mov    0x8(%ebp),%esi
80106db3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct slab *s;
	int slabIdx=getslabIdx(size);
80106db6:	53                   	push   %ebx
80106db7:	e8 3e fa ff ff       	call   801067fa <getslabIdx>
80106dbc:	89 c7                	mov    %eax,%edi
	s=&stable.slab[slabIdx];

	acquire(&stable.lock);
80106dbe:	c7 04 24 20 6a 11 80 	movl   $0x80116a20,(%esp)
80106dc5:	e8 cf d0 ff ff       	call   80103e99 <acquire>
	if(s->num_used_objects==0)
80106dca:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106dd0:	83 c4 10             	add    $0x10,%esp
80106dd3:	83 b8 60 6a 11 80 00 	cmpl   $0x0,-0x7fee95a0(%eax)
80106dda:	74 2f                	je     80106e0b <kmfree+0x68>
		release(&stable.lock);
		return;
	}

	//set the garbage in slab;
	memset(addr,1,size); 
80106ddc:	83 ec 04             	sub    $0x4,%esp
80106ddf:	53                   	push   %ebx
80106de0:	6a 01                	push   $0x1
80106de2:	56                   	push   %esi
80106de3:	e8 67 d1 ff ff       	call   80103f4f <memset>
	//bitmap operation
	//get the adress page Number
	int pageNum=0;
	for(int i=1;i<=100;i++)
80106de8:	69 d7 a8 01 00 00    	imul   $0x1a8,%edi,%edx
80106dee:	83 c4 10             	add    $0x10,%esp
80106df1:	bb 01 00 00 00       	mov    $0x1,%ebx
	{
		if(addr-s->page[i]>=0 && addr-s->page[i]<PGSIZE)
80106df6:	89 f0                	mov    %esi,%eax
80106df8:	2b 84 9a 6c 6a 11 80 	sub    -0x7fee9594(%edx,%ebx,4),%eax
80106dff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80106e04:	76 1a                	jbe    80106e20 <kmfree+0x7d>
	for(int i=1;i<=100;i++)
80106e06:	83 c3 01             	add    $0x1,%ebx
80106e09:	eb eb                	jmp    80106df6 <kmfree+0x53>
		release(&stable.lock);
80106e0b:	83 ec 0c             	sub    $0xc,%esp
80106e0e:	68 20 6a 11 80       	push   $0x80116a20
80106e13:	e8 ec d0 ff ff       	call   80103f04 <release>
		return;
80106e18:	83 c4 10             	add    $0x10,%esp
80106e1b:	e9 93 00 00 00       	jmp    80106eb3 <kmfree+0x110>
			break;
		}
	}
	//get the offset to make 0 appropriate bitmap
	int offset=0;
	offset=((pageNum-1)*s->num_objects_per_page)+(addr-s->page[pageNum])/s->size;
80106e20:	8d 43 ff             	lea    -0x1(%ebx),%eax
80106e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
	if(clearBitmap(slabIdx,offset))
80106e26:	83 ec 08             	sub    $0x8,%esp
	offset=((pageNum-1)*s->num_objects_per_page)+(addr-s->page[pageNum])/s->size;
80106e29:	6b c7 6a             	imul   $0x6a,%edi,%eax
80106e2c:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80106e30:	89 f1                	mov    %esi,%ecx
80106e32:	2b 0c 85 2c 6a 11 80 	sub    -0x7fee95d4(,%eax,4),%ecx
80106e39:	89 c8                	mov    %ecx,%eax
80106e3b:	69 cf a8 01 00 00    	imul   $0x1a8,%edi,%ecx
80106e41:	99                   	cltd   
80106e42:	f7 b9 54 6a 11 80    	idivl  -0x7fee95ac(%ecx)
80106e48:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106e4b:	0f af b1 64 6a 11 80 	imul   -0x7fee959c(%ecx),%esi
80106e52:	01 f0                	add    %esi,%eax
	if(clearBitmap(slabIdx,offset))
80106e54:	50                   	push   %eax
80106e55:	57                   	push   %edi
80106e56:	e8 5b fa ff ff       	call   801068b6 <clearBitmap>
80106e5b:	83 c4 10             	add    $0x10,%esp
80106e5e:	84 c0                	test   %al,%al
80106e60:	74 14                	je     80106e76 <kmfree+0xd3>
	{
		stable.slab[slabIdx].num_free_objects+=1;
80106e62:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106e68:	83 80 5c 6a 11 80 01 	addl   $0x1,-0x7fee95a4(%eax)
		stable.slab[slabIdx].num_used_objects-=1;
80106e6f:	83 a8 60 6a 11 80 01 	subl   $0x1,-0x7fee95a0(%eax)
	}

	//page free
	int startOffset=(pageNum-1)*s->num_objects_per_page;
	int endOffset=(startOffset+s->num_objects_per_page)-1;
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106e76:	83 fb 01             	cmp    $0x1,%ebx
80106e79:	74 28                	je     80106ea3 <kmfree+0x100>
	int startOffset=(pageNum-1)*s->num_objects_per_page;
80106e7b:	69 c7 a8 01 00 00    	imul   $0x1a8,%edi,%eax
80106e81:	8b 90 64 6a 11 80    	mov    -0x7fee959c(%eax),%edx
80106e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e8a:	0f af c2             	imul   %edx,%eax
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106e8d:	83 ec 04             	sub    $0x4,%esp
80106e90:	57                   	push   %edi
	int endOffset=(startOffset+s->num_objects_per_page)-1;
80106e91:	8d 54 02 ff          	lea    -0x1(%edx,%eax,1),%edx
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
80106e95:	52                   	push   %edx
80106e96:	50                   	push   %eax
80106e97:	e8 69 fa ff ff       	call   80106905 <checkEmpty>
80106e9c:	83 c4 10             	add    $0x10,%esp
80106e9f:	84 c0                	test   %al,%al
80106ea1:	75 18                	jne    80106ebb <kmfree+0x118>
	{
		kfree(s->page[pageNum]);
		s->num_pages-=1;
	}
	release(&stable.lock);
80106ea3:	83 ec 0c             	sub    $0xc,%esp
80106ea6:	68 20 6a 11 80       	push   $0x80116a20
80106eab:	e8 54 d0 ff ff       	call   80103f04 <release>
80106eb0:	83 c4 10             	add    $0x10,%esp
	// return;
}
80106eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb6:	5b                   	pop    %ebx
80106eb7:	5e                   	pop    %esi
80106eb8:	5f                   	pop    %edi
80106eb9:	5d                   	pop    %ebp
80106eba:	c3                   	ret    
		kfree(s->page[pageNum]);
80106ebb:	83 ec 0c             	sub    $0xc,%esp
80106ebe:	6b c7 6a             	imul   $0x6a,%edi,%eax
80106ec1:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80106ec5:	ff 34 85 2c 6a 11 80 	pushl  -0x7fee95d4(,%eax,4)
80106ecc:	e8 ea b1 ff ff       	call   801020bb <kfree>
		s->num_pages-=1;
80106ed1:	69 ff a8 01 00 00    	imul   $0x1a8,%edi,%edi
80106ed7:	83 af 58 6a 11 80 01 	subl   $0x1,-0x7fee95a8(%edi)
80106ede:	83 c4 10             	add    $0x10,%esp
80106ee1:	eb c0                	jmp    80106ea3 <kmfree+0x100>

80106ee3 <slabdump>:
// 	for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
// 		cprintf("%d\t%d\t\t%d\t\t%d\n", 
// 			s->size, s->num_pages, s->num_used_objects, s->num_free_objects);
// 	}
// }
void slabdump(){
80106ee3:	f3 0f 1e fb          	endbr32 
80106ee7:	55                   	push   %ebp
80106ee8:	89 e5                	mov    %esp,%ebp
80106eea:	57                   	push   %edi
80106eeb:	56                   	push   %esi
80106eec:	53                   	push   %ebx
80106eed:	83 ec 18             	sub    $0x18,%esp
    cprintf("__slabdump__\n");
80106ef0:	68 93 82 10 80       	push   $0x80108293
80106ef5:	e8 32 97 ff ff       	call   8010062c <cprintf>

    struct slab *s;

    cprintf("size\tnum_pages\tused_objects\tfree_objects\n");
80106efa:	c7 04 24 bc 82 10 80 	movl   $0x801082bc,(%esp)
80106f01:	e8 26 97 ff ff       	call   8010062c <cprintf>
80106f06:	83 c4 10             	add    $0x10,%esp

    for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
80106f09:	bf 54 6a 11 80       	mov    $0x80116a54,%edi
80106f0e:	eb 64                	jmp    80106f74 <slabdump+0x91>
		{
			for(int j=7;j>=0;j--)
			{
				cprintf("%d",get_bit(s->bitmap[i],j));
			}
			cprintf(" ");
80106f10:	83 ec 0c             	sub    $0xc,%esp
80106f13:	68 b1 7e 10 80       	push   $0x80107eb1
80106f18:	e8 0f 97 ff ff       	call   8010062c <cprintf>
		for(int i=0;i<60;i++)
80106f1d:	83 c6 01             	add    $0x1,%esi
80106f20:	83 c4 10             	add    $0x10,%esp
80106f23:	83 fe 3c             	cmp    $0x3c,%esi
80106f26:	74 2e                	je     80106f56 <slabdump+0x73>
			for(int j=7;j>=0;j--)
80106f28:	bb 07 00 00 00       	mov    $0x7,%ebx
				cprintf("%d",get_bit(s->bitmap[i],j));
80106f2d:	83 ec 08             	sub    $0x8,%esp
80106f30:	8b 47 14             	mov    0x14(%edi),%eax
80106f33:	0f be 04 30          	movsbl (%eax,%esi,1),%eax
	return ((num&(1<<i))!=0);
80106f37:	89 d9                	mov    %ebx,%ecx
80106f39:	d3 f8                	sar    %cl,%eax
80106f3b:	83 e0 01             	and    $0x1,%eax
				cprintf("%d",get_bit(s->bitmap[i],j));
80106f3e:	50                   	push   %eax
80106f3f:	68 b9 82 10 80       	push   $0x801082b9
80106f44:	e8 e3 96 ff ff       	call   8010062c <cprintf>
			for(int j=7;j>=0;j--)
80106f49:	83 eb 01             	sub    $0x1,%ebx
80106f4c:	83 c4 10             	add    $0x10,%esp
80106f4f:	83 fb ff             	cmp    $0xffffffff,%ebx
80106f52:	75 d9                	jne    80106f2d <slabdump+0x4a>
80106f54:	eb ba                	jmp    80106f10 <slabdump+0x2d>
		}
		cprintf("\n");
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	68 1f 82 10 80       	push   $0x8010821f
80106f5e:	e8 c9 96 ff ff       	call   8010062c <cprintf>
    for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
80106f63:	81 c7 a8 01 00 00    	add    $0x1a8,%edi
80106f69:	83 c4 10             	add    $0x10,%esp
80106f6c:	81 ff 3c 79 11 80    	cmp    $0x8011793c,%edi
80106f72:	74 2f                	je     80106fa3 <slabdump+0xc0>
        cprintf("%d\t%d\t\t%d\t\t%d\n", 
80106f74:	83 ec 0c             	sub    $0xc,%esp
80106f77:	ff 77 08             	pushl  0x8(%edi)
80106f7a:	ff 77 0c             	pushl  0xc(%edi)
80106f7d:	ff 77 04             	pushl  0x4(%edi)
80106f80:	ff 37                	pushl  (%edi)
80106f82:	68 a1 82 10 80       	push   $0x801082a1
80106f87:	e8 a0 96 ff ff       	call   8010062c <cprintf>
        cprintf("Bitmap: ");
80106f8c:	83 c4 14             	add    $0x14,%esp
80106f8f:	68 b0 82 10 80       	push   $0x801082b0
80106f94:	e8 93 96 ff ff       	call   8010062c <cprintf>
80106f99:	83 c4 10             	add    $0x10,%esp
		for(int i=0;i<60;i++)
80106f9c:	be 00 00 00 00       	mov    $0x0,%esi
80106fa1:	eb 85                	jmp    80106f28 <slabdump+0x45>
    }
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
80106faa:	c3                   	ret    

80106fab <numobj_slab>:

int numobj_slab(int slabid)
{
80106fab:	f3 0f 1e fb          	endbr32 
80106faf:	55                   	push   %ebp
80106fb0:	89 e5                	mov    %esp,%ebp
	return stable.slab[slabid].num_used_objects;
80106fb2:	69 45 08 a8 01 00 00 	imul   $0x1a8,0x8(%ebp),%eax
80106fb9:	8b 80 60 6a 11 80    	mov    -0x7fee95a0(%eax),%eax
}
80106fbf:	5d                   	pop    %ebp
80106fc0:	c3                   	ret    

80106fc1 <slabtest>:
Thereby, you should pass all tests in the slabtest() function as is.
Note that, you can edit the test function only for the debugging purpose. 
*/
int* t[NSLAB][MAXTEST] = {};

void slabtest(){
80106fc1:	f3 0f 1e fb          	endbr32 
80106fc5:	55                   	push   %ebp
80106fc6:	89 e5                	mov    %esp,%ebp
80106fc8:	57                   	push   %edi
80106fc9:	56                   	push   %esi
80106fca:	53                   	push   %ebx
80106fcb:	83 ec 48             	sub    $0x48,%esp
	int counter = 1;
80106fce:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	 * to locate the VMA (virtual memory address) of an multiple of 4 bytes. 
	 * You can check the VMA of .stab by executing 'objdump -h kernel' in your xv6 source dir.
	 * If the VMA is not aligned to the multiple of 4B, then adjust (add/del chars) 
	 * the literal string in the cprintf function
	 */
	cprintf("==== SLAB TEST ====\n");
80106fd5:	68 f1 82 10 80       	push   $0x801082f1
80106fda:	e8 4d 96 ff ff       	call   8010062c <cprintf>
	 * cprintf();
	 * slabdump();
	 */

	/* TEST1: Single slab alloc */
	cprintf("==== TEST1 =====\n");
80106fdf:	c7 04 24 06 83 10 80 	movl   $0x80108306,(%esp)
80106fe6:	e8 41 96 ff ff       	call   8010062c <cprintf>
	start = counter;
80106feb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	t[0][0] = (int*) kmalloc (TESTSIZE); 
80106fee:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
80106ff5:	e8 6d fc ff ff       	call   80106c67 <kmalloc>
80106ffa:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
	*(t[0][0]) = counter;
80106fff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107002:	89 10                	mov    %edx,(%eax)
	counter++;
80107004:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	slabdump();
80107008:	e8 d6 fe ff ff       	call   80106ee3 <slabdump>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
8010700d:	83 c4 10             	add    $0x10,%esp
80107010:	b8 ea 82 10 80       	mov    $0x801082ea,%eax
80107015:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
8010701b:	39 1a                	cmp    %ebx,(%edx)
8010701d:	0f 84 a7 00 00 00    	je     801070ca <slabtest+0x109>
80107023:	83 ec 0c             	sub    $0xc,%esp
80107026:	50                   	push   %eax
80107027:	e8 00 96 ff ff       	call   8010062c <cprintf>
	kmfree ((char*) t[0][0], TESTSIZE);
8010702c:	83 c4 08             	add    $0x8,%esp
8010702f:	68 00 08 00 00       	push   $0x800
80107034:	ff 35 c0 b5 10 80    	pushl  0x8010b5c0
8010703a:	e8 64 fd ff ff       	call   80106da3 <kmfree>
	slabdump();
8010703f:	e8 9f fe ff ff       	call   80106ee3 <slabdump>
	/* TEST1: Single slab alloc: the size not equal to a power of 2. */
	cprintf("==== TEST2 =====\n");
80107044:	c7 04 24 18 83 10 80 	movl   $0x80108318,(%esp)
8010704b:	e8 dc 95 ff ff       	call   8010062c <cprintf>
	start = counter;
80107050:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	t[0][0] = (int*) kmalloc (TESTSIZE-10); 
80107053:	c7 04 24 f6 07 00 00 	movl   $0x7f6,(%esp)
8010705a:	e8 08 fc ff ff       	call   80106c67 <kmalloc>
8010705f:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
	*(t[0][0]) = counter;
80107064:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107067:	89 10                	mov    %edx,(%eax)
	slabdump();
80107069:	e8 75 fe ff ff       	call   80106ee3 <slabdump>
	counter++;
8010706e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
80107072:	83 c4 10             	add    $0x10,%esp
80107075:	b8 ea 82 10 80       	mov    $0x801082ea,%eax
8010707a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80107080:	39 1a                	cmp    %ebx,(%edx)
80107082:	74 68                	je     801070ec <slabtest+0x12b>
80107084:	83 ec 0c             	sub    $0xc,%esp
80107087:	50                   	push   %eax
80107088:	e8 9f 95 ff ff       	call   8010062c <cprintf>
	kmfree ((char*) t[0][0], TESTSIZE);
8010708d:	83 c4 08             	add    $0x8,%esp
80107090:	68 00 08 00 00       	push   $0x800
80107095:	ff 35 c0 b5 10 80    	pushl  0x8010b5c0
8010709b:	e8 03 fd ff ff       	call   80106da3 <kmfree>
	slabdump();
801070a0:	e8 3e fe ff ff       	call   80106ee3 <slabdump>
	/* TEST3: Multiple slabs alloc */
	cprintf("==== TEST3 =====\n");
801070a5:	c7 04 24 2a 83 10 80 	movl   $0x8010832a,(%esp)
801070ac:	e8 7b 95 ff ff       	call   8010062c <cprintf>
	start = counter;
801070b1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	for (int i=0; i<NSLAB; i++)
801070b4:	83 c4 10             	add    $0x10,%esp
	start = counter;
801070b7:	c7 45 d4 c0 b5 10 80 	movl   $0x8010b5c0,-0x2c(%ebp)
801070be:	c7 45 d0 03 00 00 00 	movl   $0x3,-0x30(%ebp)
	{
		int slabsize = 1 << (i+3); 
		t[i][0]	= (int*) kmalloc (slabsize); 
		for (int j=0; j<slabsize/sizeof(int); j++)
		{
			memmove (t[i][0]+j, &counter, sizeof(int));
801070c5:	89 75 cc             	mov    %esi,-0x34(%ebp)
801070c8:	eb 7b                	jmp    80107145 <slabtest+0x184>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	6a 08                	push   $0x8
801070cf:	e8 d7 fe ff ff       	call   80106fab <numobj_slab>
801070d4:	83 c4 10             	add    $0x10,%esp
801070d7:	83 f8 01             	cmp    $0x1,%eax
801070da:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
801070df:	ba ea 82 10 80       	mov    $0x801082ea,%edx
801070e4:	0f 45 c2             	cmovne %edx,%eax
801070e7:	e9 37 ff ff ff       	jmp    80107023 <slabtest+0x62>
	cprintf( (*(t[0][0]) == start && numobj_slab(TESTSLABID) == 1) ? "OK\n":"WRONG\n");
801070ec:	83 ec 0c             	sub    $0xc,%esp
801070ef:	6a 08                	push   $0x8
801070f1:	e8 b5 fe ff ff       	call   80106fab <numobj_slab>
801070f6:	83 c4 10             	add    $0x10,%esp
801070f9:	83 f8 01             	cmp    $0x1,%eax
801070fc:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
80107101:	ba ea 82 10 80       	mov    $0x801082ea,%edx
80107106:	0f 45 c2             	cmovne %edx,%eax
80107109:	e9 76 ff ff ff       	jmp    80107084 <slabtest+0xc3>
			memmove (t[i][0]+j, &counter, sizeof(int));
8010710e:	83 ec 04             	sub    $0x4,%esp
80107111:	6a 04                	push   $0x4
80107113:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107116:	50                   	push   %eax
80107117:	8b 07                	mov    (%edi),%eax
80107119:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010711c:	50                   	push   %eax
8010711d:	e8 ba ce ff ff       	call   80103fdc <memmove>
			counter++;
80107122:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int j=0; j<slabsize/sizeof(int); j++)
80107126:	83 c3 01             	add    $0x1,%ebx
80107129:	83 c4 10             	add    $0x10,%esp
8010712c:	39 de                	cmp    %ebx,%esi
8010712e:	77 de                	ja     8010710e <slabtest+0x14d>
	for (int i=0; i<NSLAB; i++)
80107130:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80107134:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
8010713b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010713e:	3d e0 d1 10 80       	cmp    $0x8010d1e0,%eax
80107143:	74 2f                	je     80107174 <slabtest+0x1b3>
		int slabsize = 1 << (i+3); 
80107145:	bb 01 00 00 00       	mov    $0x1,%ebx
8010714a:	0f b6 4d d0          	movzbl -0x30(%ebp),%ecx
8010714e:	d3 e3                	shl    %cl,%ebx
		t[i][0]	= (int*) kmalloc (slabsize); 
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	53                   	push   %ebx
80107154:	e8 0e fb ff ff       	call   80106c67 <kmalloc>
80107159:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010715c:	89 d7                	mov    %edx,%edi
8010715e:	89 02                	mov    %eax,(%edx)
		for (int j=0; j<slabsize/sizeof(int); j++)
80107160:	89 de                	mov    %ebx,%esi
80107162:	c1 ee 02             	shr    $0x2,%esi
80107165:	83 c4 10             	add    $0x10,%esp
80107168:	83 fb 03             	cmp    $0x3,%ebx
8010716b:	76 c3                	jbe    80107130 <slabtest+0x16f>
8010716d:	bb 00 00 00 00       	mov    $0x0,%ebx
80107172:	eb 9a                	jmp    8010710e <slabtest+0x14d>
80107174:	8b 75 cc             	mov    -0x34(%ebp),%esi
80107177:	c7 45 d4 c0 b5 10 80 	movl   $0x8010b5c0,-0x2c(%ebp)
8010717e:	b9 03 00 00 00       	mov    $0x3,%ecx
		}
	}
	
	// CHECK 
	pass = 1;
80107183:	bf 01 00 00 00       	mov    $0x1,%edi
80107188:	eb 14                	jmp    8010719e <slabtest+0x1dd>
		for (int j=0; j < slabsize/sizeof(int); j++)
		{
			// cprintf("%d, %d, %d, %d\n", i, j, *(t[i][0]+j), start);		//YOU MAY USE THIS
			if ( *(t[i][0]+j) != start )
			{
				pass = 0;
8010718a:	bf 00 00 00 00       	mov    $0x0,%edi
	for (int i=0; i<NSLAB; i++)
8010718f:	83 c1 01             	add    $0x1,%ecx
80107192:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
80107199:	83 f9 0c             	cmp    $0xc,%ecx
8010719c:	74 2c                	je     801071ca <slabtest+0x209>
		int slabsize = 1 << (i+3); 
8010719e:	b8 01 00 00 00       	mov    $0x1,%eax
801071a3:	d3 e0                	shl    %cl,%eax
		for (int j=0; j < slabsize/sizeof(int); j++)
801071a5:	89 c3                	mov    %eax,%ebx
801071a7:	c1 eb 02             	shr    $0x2,%ebx
801071aa:	83 f8 03             	cmp    $0x3,%eax
801071ad:	76 e0                	jbe    8010718f <slabtest+0x1ce>
			if ( *(t[i][0]+j) != start )
801071af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801071b2:	8b 10                	mov    (%eax),%edx
		for (int j=0; j < slabsize/sizeof(int); j++)
801071b4:	b8 00 00 00 00       	mov    $0x0,%eax
			if ( *(t[i][0]+j) != start )
801071b9:	39 34 82             	cmp    %esi,(%edx,%eax,4)
801071bc:	75 cc                	jne    8010718a <slabtest+0x1c9>
				break;
			}
			start++;
801071be:	83 c6 01             	add    $0x1,%esi
		for (int j=0; j < slabsize/sizeof(int); j++)
801071c1:	83 c0 01             	add    $0x1,%eax
801071c4:	39 d8                	cmp    %ebx,%eax
801071c6:	72 f1                	jb     801071b9 <slabtest+0x1f8>
801071c8:	eb c5                	jmp    8010718f <slabtest+0x1ce>
		}
	}
	slabdump();
801071ca:	e8 14 fd ff ff       	call   80106ee3 <slabdump>
	cprintf( pass ? "OK\n" : "WRONG\n");	
801071cf:	85 ff                	test   %edi,%edi
801071d1:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
801071d6:	ba ea 82 10 80       	mov    $0x801082ea,%edx
801071db:	0f 44 c2             	cmove  %edx,%eax
801071de:	83 ec 0c             	sub    $0xc,%esp
801071e1:	50                   	push   %eax
801071e2:	e8 45 94 ff ff       	call   8010062c <cprintf>
801071e7:	83 c4 10             	add    $0x10,%esp
801071ea:	be c0 b5 10 80       	mov    $0x8010b5c0,%esi
801071ef:	bb 03 00 00 00       	mov    $0x3,%ebx
	for (int i=0; i<NSLAB; i++)
	{
		int slabsize = 1 << (i+3); 
801071f4:	bf 01 00 00 00       	mov    $0x1,%edi
		kmfree((char*) t[i][0], slabsize);
801071f9:	83 ec 08             	sub    $0x8,%esp
		int slabsize = 1 << (i+3); 
801071fc:	89 f8                	mov    %edi,%eax
801071fe:	89 d9                	mov    %ebx,%ecx
80107200:	d3 e0                	shl    %cl,%eax
		kmfree((char*) t[i][0], slabsize);
80107202:	50                   	push   %eax
80107203:	ff 36                	pushl  (%esi)
80107205:	e8 99 fb ff ff       	call   80106da3 <kmfree>
	for (int i=0; i<NSLAB; i++)
8010720a:	83 c3 01             	add    $0x1,%ebx
8010720d:	81 c6 20 03 00 00    	add    $0x320,%esi
80107213:	83 c4 10             	add    $0x10,%esp
80107216:	83 fb 0c             	cmp    $0xc,%ebx
80107219:	75 de                	jne    801071f9 <slabtest+0x238>
	}
	slabdump();
8010721b:	e8 c3 fc ff ff       	call   80106ee3 <slabdump>
	/* TEST4: Multiple slabs alloc2 */
	cprintf("==== TEST4 =====\n");
80107220:	83 ec 0c             	sub    $0xc,%esp
80107223:	68 3c 83 10 80       	push   $0x8010833c
80107228:	e8 ff 93 ff ff       	call   8010062c <cprintf>
	start = counter;
8010722d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	for (int i=0; i<NSLAB; i++)
80107230:	c7 45 c0 e0 b8 10 80 	movl   $0x8010b8e0,-0x40(%ebp)
80107237:	83 c4 10             	add    $0x10,%esp
	start = counter;
8010723a:	c7 45 d0 e0 b8 10 80 	movl   $0x8010b8e0,-0x30(%ebp)
80107241:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			t[i][j]	= (int*) kmalloc (slabsize); 
			// cprintf("adress: %p\n",(int*)t[i][j]);
			for (int k=0; k<slabsize/sizeof(int); k++)
			{
				// slabdump();
				memmove (t[i][j]+k, &counter, sizeof(int));
80107248:	89 7d bc             	mov    %edi,-0x44(%ebp)
8010724b:	eb 67                	jmp    801072b4 <slabtest+0x2f3>
		for (int j=0; j<MAXTEST; j++)
8010724d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
80107251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107254:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80107257:	74 44                	je     8010729d <slabtest+0x2dc>
			t[i][j]	= (int*) kmalloc (slabsize); 
80107259:	83 ec 0c             	sub    $0xc,%esp
8010725c:	ff 75 cc             	pushl  -0x34(%ebp)
8010725f:	e8 03 fa ff ff       	call   80106c67 <kmalloc>
80107264:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80107267:	89 ce                	mov    %ecx,%esi
80107269:	89 01                	mov    %eax,(%ecx)
			for (int k=0; k<slabsize/sizeof(int); k++)
8010726b:	83 c4 10             	add    $0x10,%esp
8010726e:	83 7d c8 03          	cmpl   $0x3,-0x38(%ebp)
80107272:	76 d9                	jbe    8010724d <slabtest+0x28c>
80107274:	bb 00 00 00 00       	mov    $0x0,%ebx
				memmove (t[i][j]+k, &counter, sizeof(int));
80107279:	83 ec 04             	sub    $0x4,%esp
8010727c:	6a 04                	push   $0x4
8010727e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107281:	50                   	push   %eax
80107282:	8b 06                	mov    (%esi),%eax
80107284:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80107287:	50                   	push   %eax
80107288:	e8 4f cd ff ff       	call   80103fdc <memmove>
				counter++;
8010728d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
			for (int k=0; k<slabsize/sizeof(int); k++)
80107291:	83 c3 01             	add    $0x1,%ebx
80107294:	83 c4 10             	add    $0x10,%esp
80107297:	39 fb                	cmp    %edi,%ebx
80107299:	72 de                	jb     80107279 <slabtest+0x2b8>
8010729b:	eb b0                	jmp    8010724d <slabtest+0x28c>
	for (int i=0; i<NSLAB; i++)
8010729d:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
801072a1:	81 45 d0 20 03 00 00 	addl   $0x320,-0x30(%ebp)
801072a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801072ab:	ba 00 d5 10 80       	mov    $0x8010d500,%edx
801072b0:	39 c2                	cmp    %eax,%edx
801072b2:	74 23                	je     801072d7 <slabtest+0x316>
		int slabsize = 1 << (i+3); 
801072b4:	b8 01 00 00 00       	mov    $0x1,%eax
801072b9:	0f b6 4d c4          	movzbl -0x3c(%ebp),%ecx
801072bd:	d3 e0                	shl    %cl,%eax
801072bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			for (int k=0; k<slabsize/sizeof(int); k++)
801072c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
801072c5:	c1 e8 02             	shr    $0x2,%eax
801072c8:	89 c7                	mov    %eax,%edi
801072ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
801072cd:	2d 20 03 00 00       	sub    $0x320,%eax
801072d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801072d5:	eb 82                	jmp    80107259 <slabtest+0x298>
801072d7:	8b 7d bc             	mov    -0x44(%ebp),%edi
			}
		}
	}
	slabdump();
801072da:	e8 04 fc ff ff       	call   80106ee3 <slabdump>
801072df:	c7 45 d4 e0 b8 10 80 	movl   $0x8010b8e0,-0x2c(%ebp)
801072e6:	c7 45 cc 03 00 00 00 	movl   $0x3,-0x34(%ebp)
	// CHECK
	pass = 1;
801072ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
801072f4:	eb 43                	jmp    80107339 <slabtest+0x378>
			for (int k=0; k<slabsize/sizeof(int); k++)
			{
				// cprintf("%d, %d, %d, %d, %d\n", i, j,k, *(t[i][j]+k), start);
				if (*(t[i][j]+k) != start)
				{
					pass = 0;
801072f6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (int j=0; j<MAXTEST; j++)
801072fd:	83 c3 04             	add    $0x4,%ebx
80107300:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
80107303:	74 1d                	je     80107322 <slabtest+0x361>
			for (int k=0; k<slabsize/sizeof(int); k++)
80107305:	83 fe 03             	cmp    $0x3,%esi
80107308:	76 f3                	jbe    801072fd <slabtest+0x33c>
				if (*(t[i][j]+k) != start)
8010730a:	8b 13                	mov    (%ebx),%edx
			for (int k=0; k<slabsize/sizeof(int); k++)
8010730c:	b8 00 00 00 00       	mov    $0x0,%eax
				if (*(t[i][j]+k) != start)
80107311:	39 3c 82             	cmp    %edi,(%edx,%eax,4)
80107314:	75 e0                	jne    801072f6 <slabtest+0x335>
					break;
				}
				start++;
80107316:	83 c7 01             	add    $0x1,%edi
			for (int k=0; k<slabsize/sizeof(int); k++)
80107319:	83 c0 01             	add    $0x1,%eax
8010731c:	39 c8                	cmp    %ecx,%eax
8010731e:	72 f1                	jb     80107311 <slabtest+0x350>
80107320:	eb db                	jmp    801072fd <slabtest+0x33c>
	for (int i=0; i<NSLAB; i++)
80107322:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80107326:	81 45 d4 20 03 00 00 	addl   $0x320,-0x2c(%ebp)
8010732d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107330:	ba 00 d5 10 80       	mov    $0x8010d500,%edx
80107335:	39 c2                	cmp    %eax,%edx
80107337:	74 1b                	je     80107354 <slabtest+0x393>
		int slabsize = 1 << (i+3); 
80107339:	be 01 00 00 00       	mov    $0x1,%esi
8010733e:	0f b6 4d cc          	movzbl -0x34(%ebp),%ecx
80107342:	d3 e6                	shl    %cl,%esi
			for (int k=0; k<slabsize/sizeof(int); k++)
80107344:	89 f1                	mov    %esi,%ecx
80107346:	c1 e9 02             	shr    $0x2,%ecx
80107349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010734c:	8d 98 e0 fc ff ff    	lea    -0x320(%eax),%ebx
80107352:	eb b1                	jmp    80107305 <slabtest+0x344>
			}
		}
	}
	cprintf( pass ? "OK\n" : "WRONG\n");
80107354:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80107358:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
8010735d:	ba ea 82 10 80       	mov    $0x801082ea,%edx
80107362:	0f 44 c2             	cmove  %edx,%eax
80107365:	83 ec 0c             	sub    $0xc,%esp
80107368:	50                   	push   %eax
80107369:	e8 be 92 ff ff       	call   8010062c <cprintf>
8010736e:	83 c4 10             	add    $0x10,%esp
80107371:	bf 03 00 00 00       	mov    $0x3,%edi
	// slabdump();
	for (int i=0; i<NSLAB; i++)
	{
		int slabsize = 1 << (i+3); 
80107376:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80107379:	8b 75 c0             	mov    -0x40(%ebp),%esi
8010737c:	bf 01 00 00 00       	mov    $0x1,%edi
80107381:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
80107385:	d3 e7                	shl    %cl,%edi
		// cprintf("slabsize:%d\n", slabsize);
		for (int j=0; j<MAXTEST; j++)
80107387:	8d 9e e0 fc ff ff    	lea    -0x320(%esi),%ebx
		{
			kmfree((char*) t[i][j], slabsize);
8010738d:	83 ec 08             	sub    $0x8,%esp
80107390:	57                   	push   %edi
80107391:	ff 33                	pushl  (%ebx)
80107393:	e8 0b fa ff ff       	call   80106da3 <kmfree>
		for (int j=0; j<MAXTEST; j++)
80107398:	83 c3 04             	add    $0x4,%ebx
8010739b:	83 c4 10             	add    $0x10,%esp
8010739e:	39 f3                	cmp    %esi,%ebx
801073a0:	75 eb                	jne    8010738d <slabtest+0x3cc>
	for (int i=0; i<NSLAB; i++)
801073a2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801073a6:	81 c6 20 03 00 00    	add    $0x320,%esi
801073ac:	81 fe 00 d5 10 80    	cmp    $0x8010d500,%esi
801073b2:	75 c8                	jne    8010737c <slabtest+0x3bb>
			// slabdump();
		}
	}
	slabdump();
801073b4:	e8 2a fb ff ff       	call   80106ee3 <slabdump>
	/* TEST5: ALLOC MORE THAN 100 PAGES */
	cprintf("==== TEST5 =====\n");
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	68 4e 83 10 80       	push   $0x8010834e
801073c1:	e8 66 92 ff ff       	call   8010062c <cprintf>
801073c6:	83 c4 10             	add    $0x10,%esp
	start = counter;
	for (int j=0; j<MAXTEST; j++)
801073c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
		// cprintf("adress: %p",(int*)t[0][j]);
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			// slabdump();
			memmove (t[0][j]+k, &counter, sizeof(int));
801073d0:	8d 7d e4             	lea    -0x1c(%ebp),%edi
801073d3:	eb 0e                	jmp    801073e3 <slabtest+0x422>
	for (int j=0; j<MAXTEST; j++)
801073d5:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801073d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801073dc:	3d c8 00 00 00       	cmp    $0xc8,%eax
801073e1:	74 4a                	je     8010742d <slabtest+0x46c>
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
801073e3:	83 ec 0c             	sub    $0xc,%esp
801073e6:	68 00 08 00 00       	push   $0x800
801073eb:	e8 77 f8 ff ff       	call   80106c67 <kmalloc>
801073f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801073f3:	89 d6                	mov    %edx,%esi
801073f5:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
801073fc:	83 c4 10             	add    $0x10,%esp
801073ff:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
80107404:	83 ec 04             	sub    $0x4,%esp
80107407:	6a 04                	push   $0x4
80107409:	57                   	push   %edi
8010740a:	89 d8                	mov    %ebx,%eax
8010740c:	03 04 b5 c0 b5 10 80 	add    -0x7fef4a40(,%esi,4),%eax
80107413:	50                   	push   %eax
80107414:	e8 c3 cb ff ff       	call   80103fdc <memmove>
			counter++;
80107419:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
8010741d:	83 c3 04             	add    $0x4,%ebx
80107420:	83 c4 10             	add    $0x10,%esp
80107423:	81 fb 00 08 00 00    	cmp    $0x800,%ebx
80107429:	75 d9                	jne    80107404 <slabtest+0x443>
8010742b:	eb a8                	jmp    801073d5 <slabtest+0x414>
		}
	}
	tmp = (int*) kmalloc (TESTSIZE);
8010742d:	83 ec 0c             	sub    $0xc,%esp
80107430:	68 00 08 00 00       	push   $0x800
80107435:	e8 2d f8 ff ff       	call   80106c67 <kmalloc>
8010743a:	89 c2                	mov    %eax,%edx
	cprintf( (!tmp && numobj_slab (TESTSLABID) == MAXTEST) ? "OK\n" : "WRONG\n");	
8010743c:	83 c4 10             	add    $0x10,%esp
8010743f:	b8 ea 82 10 80       	mov    $0x801082ea,%eax
80107444:	85 d2                	test   %edx,%edx
80107446:	74 5b                	je     801074a3 <slabtest+0x4e2>
80107448:	83 ec 0c             	sub    $0xc,%esp
8010744b:	50                   	push   %eax
8010744c:	e8 db 91 ff ff       	call   8010062c <cprintf>
	slabdump();
80107451:	e8 8d fa ff ff       	call   80106ee3 <slabdump>
	/* TEST6: ALLOC AFTER FREE */
	cprintf("==== TEST6 =====\n");
80107456:	c7 04 24 60 83 10 80 	movl   $0x80108360,(%esp)
8010745d:	e8 ca 91 ff ff       	call   8010062c <cprintf>
80107462:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<MAXTEST; j++)
80107465:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE);
8010746a:	83 ec 08             	sub    $0x8,%esp
8010746d:	68 00 08 00 00       	push   $0x800
80107472:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
80107479:	e8 25 f9 ff ff       	call   80106da3 <kmfree>
	for (int j=0; j<MAXTEST; j++)
8010747e:	83 c3 01             	add    $0x1,%ebx
80107481:	83 c4 10             	add    $0x10,%esp
80107484:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
8010748a:	75 de                	jne    8010746a <slabtest+0x4a9>
	}
	slabdump();
8010748c:	e8 52 fa ff ff       	call   80106ee3 <slabdump>
	start = counter;
80107491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107494:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (int j=0; j<MAXTEST; j++)
80107497:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
8010749e:	8d 7d e4             	lea    -0x1c(%ebp),%edi
801074a1:	eb 2f                	jmp    801074d2 <slabtest+0x511>
	cprintf( (!tmp && numobj_slab (TESTSLABID) == MAXTEST) ? "OK\n" : "WRONG\n");	
801074a3:	83 ec 0c             	sub    $0xc,%esp
801074a6:	6a 08                	push   $0x8
801074a8:	e8 fe fa ff ff       	call   80106fab <numobj_slab>
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	3d c8 00 00 00       	cmp    $0xc8,%eax
801074b5:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
801074ba:	ba ea 82 10 80       	mov    $0x801082ea,%edx
801074bf:	0f 45 c2             	cmovne %edx,%eax
801074c2:	eb 84                	jmp    80107448 <slabtest+0x487>
	for (int j=0; j<MAXTEST; j++)
801074c4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801074c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801074cb:	3d c8 00 00 00       	cmp    $0xc8,%eax
801074d0:	74 4a                	je     8010751c <slabtest+0x55b>
		t[0][j]	= (int*) kmalloc (TESTSIZE); 
801074d2:	83 ec 0c             	sub    $0xc,%esp
801074d5:	68 00 08 00 00       	push   $0x800
801074da:	e8 88 f7 ff ff       	call   80106c67 <kmalloc>
801074df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801074e2:	89 d6                	mov    %edx,%esi
801074e4:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
801074eb:	83 c4 10             	add    $0x10,%esp
801074ee:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
801074f3:	83 ec 04             	sub    $0x4,%esp
801074f6:	6a 04                	push   $0x4
801074f8:	57                   	push   %edi
801074f9:	89 d8                	mov    %ebx,%eax
801074fb:	03 04 b5 c0 b5 10 80 	add    -0x7fef4a40(,%esi,4),%eax
80107502:	50                   	push   %eax
80107503:	e8 d4 ca ff ff       	call   80103fdc <memmove>
			counter++;
80107508:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
8010750c:	83 c3 04             	add    $0x4,%ebx
8010750f:	83 c4 10             	add    $0x10,%esp
80107512:	81 fb 00 08 00 00    	cmp    $0x800,%ebx
80107518:	75 d9                	jne    801074f3 <slabtest+0x532>
8010751a:	eb a8                	jmp    801074c4 <slabtest+0x503>
		}
	}
	slabdump();
8010751c:	e8 c2 f9 ff ff       	call   80106ee3 <slabdump>
	// CHECK 
	pass = 1;
	for (int j=0; j<MAXTEST; j++)
80107521:	b9 00 00 00 00       	mov    $0x0,%ecx
	pass = 1;
80107526:	bb 01 00 00 00       	mov    $0x1,%ebx
8010752b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010752e:	eb 10                	jmp    80107540 <slabtest+0x57f>
	{
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
		{
			if (*(t[0][j]+k) != start)
			{
				pass = 0;
80107530:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (int j=0; j<MAXTEST; j++)
80107535:	83 c1 01             	add    $0x1,%ecx
80107538:	81 f9 c8 00 00 00    	cmp    $0xc8,%ecx
8010753e:	74 26                	je     80107566 <slabtest+0x5a5>
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
80107540:	8d b8 00 02 00 00    	lea    0x200(%eax),%edi
80107546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010754d:	8b 34 8d c0 b5 10 80 	mov    -0x7fef4a40(,%ecx,4),%esi
80107554:	29 d6                	sub    %edx,%esi
80107556:	89 f2                	mov    %esi,%edx
			if (*(t[0][j]+k) != start)
80107558:	39 04 82             	cmp    %eax,(%edx,%eax,4)
8010755b:	75 d3                	jne    80107530 <slabtest+0x56f>
				break;
			}
			start++;
8010755d:	83 c0 01             	add    $0x1,%eax
		for (int k=0; k<TESTSIZE/sizeof(int); k++)
80107560:	39 c7                	cmp    %eax,%edi
80107562:	75 f4                	jne    80107558 <slabtest+0x597>
80107564:	eb cf                	jmp    80107535 <slabtest+0x574>
		}
	}
	cprintf( pass ? "OK\n" : "WRONG\n");	
80107566:	85 db                	test   %ebx,%ebx
80107568:	b8 e6 82 10 80       	mov    $0x801082e6,%eax
8010756d:	ba ea 82 10 80       	mov    $0x801082ea,%edx
80107572:	0f 44 c2             	cmove  %edx,%eax
80107575:	83 ec 0c             	sub    $0xc,%esp
80107578:	50                   	push   %eax
80107579:	e8 ae 90 ff ff       	call   8010062c <cprintf>
8010757e:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<MAXTEST; j++)
80107581:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE);
80107586:	83 ec 08             	sub    $0x8,%esp
80107589:	68 00 08 00 00       	push   $0x800
8010758e:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
80107595:	e8 09 f8 ff ff       	call   80106da3 <kmfree>
	for (int j=0; j<MAXTEST; j++)
8010759a:	83 c3 01             	add    $0x1,%ebx
8010759d:	83 c4 10             	add    $0x10,%esp
801075a0:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
801075a6:	75 de                	jne    80107586 <slabtest+0x5c5>
		// slabdump();
	}
	slabdump();
801075a8:	e8 36 f9 ff ff       	call   80106ee3 <slabdump>
	//alloc and free and alloc
	cprintf("==== TEST7 =====\n");
801075ad:	83 ec 0c             	sub    $0xc,%esp
801075b0:	68 72 83 10 80       	push   $0x80108372
801075b5:	e8 72 90 ff ff       	call   8010062c <cprintf>
801075ba:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<16; j++)
801075bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
801075c4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
801075c7:	83 ec 0c             	sub    $0xc,%esp
801075ca:	68 00 02 00 00       	push   $0x200
801075cf:	e8 93 f6 ff ff       	call   80106c67 <kmalloc>
801075d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801075d7:	89 d7                	mov    %edx,%edi
801075d9:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
801075e0:	83 c4 10             	add    $0x10,%esp
801075e3:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
801075e8:	83 ec 04             	sub    $0x4,%esp
801075eb:	6a 04                	push   $0x4
801075ed:	56                   	push   %esi
801075ee:	89 d8                	mov    %ebx,%eax
801075f0:	03 04 bd c0 b5 10 80 	add    -0x7fef4a40(,%edi,4),%eax
801075f7:	50                   	push   %eax
801075f8:	e8 df c9 ff ff       	call   80103fdc <memmove>
			counter++;
801075fd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
80107601:	83 c3 04             	add    $0x4,%ebx
80107604:	83 c4 10             	add    $0x10,%esp
80107607:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
8010760d:	75 d9                	jne    801075e8 <slabtest+0x627>
	for (int j=0; j<16; j++)
8010760f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
80107613:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107616:	83 f8 10             	cmp    $0x10,%eax
80107619:	75 ac                	jne    801075c7 <slabtest+0x606>
		}
	}
	slabdump();
8010761b:	e8 c3 f8 ff ff       	call   80106ee3 <slabdump>
	for (int j=10; j<12; j++)
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107620:	83 ec 08             	sub    $0x8,%esp
80107623:	68 00 02 00 00       	push   $0x200
80107628:	ff 35 e8 b5 10 80    	pushl  0x8010b5e8
8010762e:	e8 70 f7 ff ff       	call   80106da3 <kmfree>
80107633:	83 c4 08             	add    $0x8,%esp
80107636:	68 00 02 00 00       	push   $0x200
8010763b:	ff 35 ec b5 10 80    	pushl  0x8010b5ec
80107641:	e8 5d f7 ff ff       	call   80106da3 <kmfree>
	}
	for (int j=13; j<15; j++)
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107646:	83 c4 08             	add    $0x8,%esp
80107649:	68 00 02 00 00       	push   $0x200
8010764e:	ff 35 f4 b5 10 80    	pushl  0x8010b5f4
80107654:	e8 4a f7 ff ff       	call   80106da3 <kmfree>
80107659:	83 c4 08             	add    $0x8,%esp
8010765c:	68 00 02 00 00       	push   $0x200
80107661:	ff 35 f8 b5 10 80    	pushl  0x8010b5f8
80107667:	e8 37 f7 ff ff       	call   80106da3 <kmfree>
	}
	slabdump();
8010766c:	e8 72 f8 ff ff       	call   80106ee3 <slabdump>
80107671:	83 c4 10             	add    $0x10,%esp
	for (int j=10; j<12; j++)
80107674:	c7 45 d4 0a 00 00 00 	movl   $0xa,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
8010767b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
8010767e:	83 ec 0c             	sub    $0xc,%esp
80107681:	68 00 02 00 00       	push   $0x200
80107686:	e8 dc f5 ff ff       	call   80106c67 <kmalloc>
8010768b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010768e:	89 d7                	mov    %edx,%edi
80107690:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
80107697:	83 c4 10             	add    $0x10,%esp
8010769a:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
8010769f:	83 ec 04             	sub    $0x4,%esp
801076a2:	6a 04                	push   $0x4
801076a4:	56                   	push   %esi
801076a5:	89 d8                	mov    %ebx,%eax
801076a7:	03 04 bd c0 b5 10 80 	add    -0x7fef4a40(,%edi,4),%eax
801076ae:	50                   	push   %eax
801076af:	e8 28 c9 ff ff       	call   80103fdc <memmove>
			counter++;
801076b4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
801076b8:	83 c3 04             	add    $0x4,%ebx
801076bb:	83 c4 10             	add    $0x10,%esp
801076be:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
801076c4:	75 d9                	jne    8010769f <slabtest+0x6de>
	for (int j=10; j<12; j++)
801076c6:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801076ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801076cd:	83 f8 0c             	cmp    $0xc,%eax
801076d0:	75 ac                	jne    8010767e <slabtest+0x6bd>
		}
	}
	slabdump();
801076d2:	e8 0c f8 ff ff       	call   80106ee3 <slabdump>
	for (int j=8; j<16; j++)
801076d7:	bb 08 00 00 00       	mov    $0x8,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
801076dc:	83 ec 08             	sub    $0x8,%esp
801076df:	68 00 02 00 00       	push   $0x200
801076e4:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
801076eb:	e8 b3 f6 ff ff       	call   80106da3 <kmfree>
	for (int j=8; j<16; j++)
801076f0:	83 c3 01             	add    $0x1,%ebx
801076f3:	83 c4 10             	add    $0x10,%esp
801076f6:	83 fb 10             	cmp    $0x10,%ebx
801076f9:	75 e1                	jne    801076dc <slabtest+0x71b>
	}
	slabdump();
801076fb:	e8 e3 f7 ff ff       	call   80106ee3 <slabdump>
	for (int j=0; j<8; j++)
80107700:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107705:	83 ec 08             	sub    $0x8,%esp
80107708:	68 00 02 00 00       	push   $0x200
8010770d:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
80107714:	e8 8a f6 ff ff       	call   80106da3 <kmfree>
	for (int j=0; j<8; j++)
80107719:	83 c3 01             	add    $0x1,%ebx
8010771c:	83 c4 10             	add    $0x10,%esp
8010771f:	83 fb 08             	cmp    $0x8,%ebx
80107722:	75 e1                	jne    80107705 <slabtest+0x744>
80107724:	89 5d d0             	mov    %ebx,-0x30(%ebp)
	}
	slabdump();
80107727:	e8 b7 f7 ff ff       	call   80106ee3 <slabdump>
	cprintf("==== TEST8 =====\n");
8010772c:	83 ec 0c             	sub    $0xc,%esp
8010772f:	68 84 83 10 80       	push   $0x80108384
80107734:	e8 f3 8e ff ff       	call   8010062c <cprintf>
80107739:	83 c4 10             	add    $0x10,%esp
	for (int j=0; j<24; j++)
8010773c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
80107743:	8d 7d e4             	lea    -0x1c(%ebp),%edi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	68 00 02 00 00       	push   $0x200
8010774e:	e8 14 f5 ff ff       	call   80106c67 <kmalloc>
80107753:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80107756:	89 d6                	mov    %edx,%esi
80107758:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
8010775f:	83 c4 10             	add    $0x10,%esp
80107762:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
80107767:	83 ec 04             	sub    $0x4,%esp
8010776a:	6a 04                	push   $0x4
8010776c:	57                   	push   %edi
8010776d:	89 d8                	mov    %ebx,%eax
8010776f:	03 04 b5 c0 b5 10 80 	add    -0x7fef4a40(,%esi,4),%eax
80107776:	50                   	push   %eax
80107777:	e8 60 c8 ff ff       	call   80103fdc <memmove>
			counter++;
8010777c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
80107780:	83 c3 04             	add    $0x4,%ebx
80107783:	83 c4 10             	add    $0x10,%esp
80107786:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
8010778c:	75 d9                	jne    80107767 <slabtest+0x7a6>
	for (int j=0; j<24; j++)
8010778e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
80107792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107795:	83 f8 18             	cmp    $0x18,%eax
80107798:	75 ac                	jne    80107746 <slabtest+0x785>
		}
	}
	slabdump();
8010779a:	e8 44 f7 ff ff       	call   80106ee3 <slabdump>
	for (int j=8; j<16; j++)
8010779f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
801077a2:	83 ec 08             	sub    $0x8,%esp
801077a5:	68 00 02 00 00       	push   $0x200
801077aa:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
801077b1:	e8 ed f5 ff ff       	call   80106da3 <kmfree>
	for (int j=8; j<16; j++)
801077b6:	83 c3 01             	add    $0x1,%ebx
801077b9:	83 c4 10             	add    $0x10,%esp
801077bc:	83 fb 10             	cmp    $0x10,%ebx
801077bf:	75 e1                	jne    801077a2 <slabtest+0x7e1>
	}
	slabdump();
801077c1:	e8 1d f7 ff ff       	call   80106ee3 <slabdump>
	for (int j=8; j<16; j++)
	{
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
		{
			memmove (t[0][j]+k, &counter, sizeof(int));
801077c6:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		t[0][j]	= (int*) kmalloc (TESTSIZE2);
801077c9:	83 ec 0c             	sub    $0xc,%esp
801077cc:	68 00 02 00 00       	push   $0x200
801077d1:	e8 91 f4 ff ff       	call   80106c67 <kmalloc>
801077d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
801077d9:	89 d7                	mov    %edx,%edi
801077db:	89 04 95 c0 b5 10 80 	mov    %eax,-0x7fef4a40(,%edx,4)
801077e2:	83 c4 10             	add    $0x10,%esp
801077e5:	bb 00 00 00 00       	mov    $0x0,%ebx
			memmove (t[0][j]+k, &counter, sizeof(int));
801077ea:	83 ec 04             	sub    $0x4,%esp
801077ed:	6a 04                	push   $0x4
801077ef:	56                   	push   %esi
801077f0:	89 d8                	mov    %ebx,%eax
801077f2:	03 04 bd c0 b5 10 80 	add    -0x7fef4a40(,%edi,4),%eax
801077f9:	50                   	push   %eax
801077fa:	e8 dd c7 ff ff       	call   80103fdc <memmove>
			counter++;
801077ff:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
		for (int k=0; k<TESTSIZE2/sizeof(int); k++)
80107803:	83 c3 04             	add    $0x4,%ebx
80107806:	83 c4 10             	add    $0x10,%esp
80107809:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
8010780f:	75 d9                	jne    801077ea <slabtest+0x829>
	for (int j=8; j<16; j++)
80107811:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80107815:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107818:	83 f8 10             	cmp    $0x10,%eax
8010781b:	75 ac                	jne    801077c9 <slabtest+0x808>
		}
	}
	slabdump();
8010781d:	e8 c1 f6 ff ff       	call   80106ee3 <slabdump>
	for (int j=0; j<24; j++)
80107822:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		kmfree((char*) t[0][j], TESTSIZE2);
80107827:	83 ec 08             	sub    $0x8,%esp
8010782a:	68 00 02 00 00       	push   $0x200
8010782f:	ff 34 9d c0 b5 10 80 	pushl  -0x7fef4a40(,%ebx,4)
80107836:	e8 68 f5 ff ff       	call   80106da3 <kmfree>
		slabdump();
8010783b:	e8 a3 f6 ff ff       	call   80106ee3 <slabdump>
	for (int j=0; j<24; j++)
80107840:	83 c3 01             	add    $0x1,%ebx
80107843:	83 c4 10             	add    $0x10,%esp
80107846:	83 fb 18             	cmp    $0x18,%ebx
80107849:	75 dc                	jne    80107827 <slabtest+0x866>
	}
	slabdump();
8010784b:	e8 93 f6 ff ff       	call   80106ee3 <slabdump>
}
80107850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107853:	5b                   	pop    %ebx
80107854:	5e                   	pop    %esi
80107855:	5f                   	pop    %edi
80107856:	5d                   	pop    %ebp
80107857:	c3                   	ret    

80107858 <sys_slabtest>:
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "slab.h"

int sys_slabtest(){
80107858:	f3 0f 1e fb          	endbr32 
8010785c:	55                   	push   %ebp
8010785d:	89 e5                	mov    %esp,%ebp
8010785f:	83 ec 08             	sub    $0x8,%esp
	slabtest();
80107862:	e8 5a f7 ff ff       	call   80106fc1 <slabtest>
	return 0;
}
80107867:	b8 00 00 00 00       	mov    $0x0,%eax
8010786c:	c9                   	leave  
8010786d:	c3                   	ret    
