#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "slab.h"

#include <stdbool.h>


int set_bit(int num,int i)
{
	return num | (1<<i);
}
int get_bit(int num,int i)
{
	return ((num&(1<<i))!=0);
}

int clear_bit(int num,int i)
{
	int mask=~(1<<i);
	return num&mask;
}

unsigned int getnumofBits(unsigned int n)
{
	unsigned count=0;
	while(n!=0)
	{
		n>>=1;
		count+=1;
	}
	return count;
}
unsigned int nextPowerOf2(unsigned int n)
{
	if(n>=0 && n<8)
		return 8;
	if(n && !(n&(n-1)))
		return n;
	return 1<<getnumofBits(n);
}
unsigned int getslabIdx(unsigned int n)
{
	unsigned slabIdx=getnumofBits(n)-4;
	return slabIdx;
}

struct {
	struct spinlock lock;
	struct slab slab[NSLAB];
} stable;

int returnOffset(int row,int column)
{
	return 8*row + column;
}

int setBitmap(int slabIdx)
{
	struct slab *s;
	s=&stable.slab[slabIdx];
	for(int j=0;j<PGSIZE;j++)
	{
		if(s->bitmap[j]==0xFF)
			continue;
		for(int k=0;k<=7;k++)
		{
			if(!(s->bitmap[j]&(1<<k)))
			{
				s->bitmap[j]=set_bit(s->bitmap[j],k);
				return returnOffset(j,k);
			}
		}
	}
	return 0; //Unable to find empty space of bitmap
}

int getRow(int offset)
{
	return offset/8;
}
int getColumn(int offset)
{
	return offset%8;
}
bool clearBitmap(int slabIdx,int offset)
{
	struct slab *s;
	s=&stable.slab[slabIdx];
	bool checkbit=true;
	int row=getRow(offset);
	int column=getColumn(offset);
	if(get_bit(s->bitmap[row],column))
		s->bitmap[row]=clear_bit(s->bitmap[row],column);
	else
		checkbit=false;
	return checkbit;
}

bool checkEmpty(int startOffset,int endOffset,int slabIdx)
{
	struct slab *s;
	s=&stable.slab[slabIdx];
	bool empty=true;
	int startRow=getRow(startOffset);
	int startColumn=getColumn(startOffset);
	int endRow=getRow(endOffset);
	int endColumn=getColumn(endOffset);
	// cprintf("startOffset: %d, endOffset %d\n",startOffset,endOffset);
	// cprintf("startRow:%d endRow:%d\n",startRow,endRow);
	for(int i=startRow;i<=endRow;i++)
	{
		for(int j=startColumn;j<=endColumn;j++)
		{
			if(get_bit(s->bitmap[i],j))
			{
				empty=false;
				break;
			}
		}
		if(empty==false)
			break;
	}
	return empty;
}

int checkNewpage(int slabIdx)
{
	struct slab *s;
	s=&stable.slab[slabIdx];
	int cnt=0;
	bool find0=false;
	for(int i=0;i<PGSIZE;i++)
	{
		for(int j=0;j<=7;j++)
		{
			if(get_bit(s->bitmap[i],j))
				cnt++;
			else
			{
				find0=true;
				break;
			}
		}
		if(find0)
			break;
	}
	if(cnt%s->num_objects_per_page==0)
	{
		int startOffset=(cnt/s->num_objects_per_page)*s->num_objects_per_page;
		int endOffset=(startOffset+s->num_objects_per_page)-1;
		if(checkEmpty(startOffset,endOffset,slabIdx))
		{
			return startOffset;
		}
	}
	return 0;
}


int getpageNum(int slabIdx)
{
	struct slab *s;
	s=&stable.slab[slabIdx];
	int page=0;
	//size 2048 - 1024
	if(slabIdx>=7)
	{
		for(int i=0;i<PGSIZE;i++)
		{
			for(int j=0;j<=7;j+=(PGSIZE/s->size))
			{
				for(int k=j;k<j+(PGSIZE/s->size);k++)
				{
					if(get_bit(s->bitmap[i],k))
					{
						page++;
						break;
					}
				}
			}
		}
	}
	//size 8 - 512
	else
	{
		for(int i=0;i<PGSIZE;i+=(512/s->size))
		{
			for(int j=i;j<i+(512/s->size);j++)
			{
				if(s->bitmap[j]!=0x00)
				{
					page++;
					break;
				}
			}
		}
	}
	return page;
}

void slabinit()
{
	acquire(&stable.lock);
	stable.slab[0].size=8;
	stable.slab[0].num_objects_per_page=PGSIZE/stable.slab[0].size;
	stable.slab[0].num_used_objects=0;
	stable.slab[0].num_free_objects=stable.slab[0].num_objects_per_page*64;
	//allocate one page for bitmap, allocate one page for slab cache
	stable.slab[0].bitmap=stable.slab[0].page[0];
	stable.slab[0].bitmap=kalloc();
	memset(stable.slab[0].bitmap,0,PGSIZE);
	stable.slab[0].page[1]=kalloc();
	stable.slab[0].num_pages=1;
	release(&stable.lock);

	acquire(&stable.lock);
	for(int i=1;i<NSLAB;i++)
	{
		stable.slab[i].size=stable.slab[i-1].size*2;
		stable.slab[i].num_objects_per_page=PGSIZE/stable.slab[i].size;
		stable.slab[i].num_used_objects=0;
		stable.slab[i].num_free_objects=stable.slab[i].num_objects_per_page*MAX_PAGES_PER_SLAB;
		//allocate one page for bitmap, allocate one page for slab cache
		stable.slab[i].bitmap=stable.slab[i].page[0];
		stable.slab[i].bitmap=kalloc();
		memset(stable.slab[i].bitmap,0,PGSIZE);
		stable.slab[i].page[1]=kalloc();
		stable.slab[i].num_pages=1;
	}
	release(&stable.lock);
}
char *kmalloc(int size){
	
	//out of range error needs to be handled
	if(size > 2048 || size<=0)
		return 0;
	//choose the byte 8 or 16 .. etc by getting index of slab
	int slabIdx=getslabIdx(nextPowerOf2(size));
	struct slab *s;
	s=&stable.slab[slabIdx];
	//can't alloc if num of used object is full
	if(s->num_used_objects==s->num_objects_per_page*MAX_PAGES_PER_SLAB)
		return 0;
	if(stable.slab[0].num_used_objects==stable.slab[0].num_objects_per_page*64)
		return 0;
	
	int startOffset=0;
	acquire(&stable.lock);
	if((startOffset=checkNewpage(slabIdx)) && s->num_used_objects!=0)
	{
		s->page[startOffset/s->num_objects_per_page+1]=kalloc(); //current page +1
	}
	
	int bitOffset=setBitmap(slabIdx);
	//getPageNumfrom bitmap
	s->num_pages=getpageNum(slabIdx);
	s->num_free_objects-=1;
	s->num_used_objects+=1;

	int nowpage=bitOffset/s->num_objects_per_page+1;
	int pageOffset=(bitOffset%s->num_objects_per_page)*(1<<(slabIdx+3))*sizeof(char);
	memset(s->page[nowpage]+pageOffset,0,size*sizeof(char));
	release(&stable.lock);
	return s->page[nowpage]+pageOffset;
}

void kmfree(char *addr, int size){
	struct slab *s;
	int slabIdx=getslabIdx(size);
	s=&stable.slab[slabIdx];

	acquire(&stable.lock);
	if(s->num_used_objects==0)
	{
		release(&stable.lock);
		return;
	}

	//set the garbage in slab;
	memset(addr,1,size); 
	//bitmap operation
	//get the adress page Number
	int pageNum=0;
	for(int i=1;i<=100;i++)
	{
		if(addr-s->page[i]>=0 && addr-s->page[i]<PGSIZE)
		{
			pageNum=i;
			break;
		}
	}
	//get the offset to make 0 appropriate bitmap
	int offset=0;
	offset=((pageNum-1)*s->num_objects_per_page)+(addr-s->page[pageNum])/s->size;
	
	if(clearBitmap(slabIdx,offset))
	{
		stable.slab[slabIdx].num_free_objects+=1;
		stable.slab[slabIdx].num_used_objects-=1;
	}

	//page free
	int startOffset=(pageNum-1)*s->num_objects_per_page;
	int endOffset=(startOffset+s->num_objects_per_page)-1;
	if(pageNum!=1 && checkEmpty(startOffset,endOffset,slabIdx))
	{
		kfree(s->page[pageNum]);
		s->num_pages-=1;
	}
	release(&stable.lock);
	// return;
}

// void slabdump(){
	
// 	cprintf("__slabdump__\n");

// 	struct slab *s;

// 	cprintf("size\tnum_pages\tused_objects\tfree_objects\n");

// 	for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
// 		cprintf("%d\t%d\t\t%d\t\t%d\n", 
// 			s->size, s->num_pages, s->num_used_objects, s->num_free_objects);
// 	}
// }
void slabdump(){
    cprintf("__slabdump__\n");

    struct slab *s;

    cprintf("size\tnum_pages\tused_objects\tfree_objects\n");

    for(s = stable.slab; s < &stable.slab[NSLAB]; s++){
        cprintf("%d\t%d\t\t%d\t\t%d\n", 
            s->size, s->num_pages, s->num_used_objects, s->num_free_objects);

        // Print the bitmap for each slab
        cprintf("Bitmap: ");
		for(int i=0;i<60;i++)
		{
			for(int j=7;j>=0;j--)
			{
				cprintf("%d",get_bit(s->bitmap[i],j));
			}
			cprintf(" ");
		}
		cprintf("\n");
    }
}

int numobj_slab(int slabid)
{
	return stable.slab[slabid].num_used_objects;
}
