#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


void disk_init();
void file_init();
void insert_header(int);
void fix_CHS(int);


char filelist[][20] = {	
			"boot.bin", 
			"kernel.bin"
			};


struct disk_vars {
	uint8_t cur_head, cur_sector, def8;
	uint8_t sector_limit, head_limit;
	uint16_t cur_cylinder, def16, cylinder_limit, sector_size, count;
};


struct file_vars {
	int fileindex, totalfiles;
	FILE *src, *tmp, *dst;
	uint8_t byte;
	void *ptr;
};


struct disk_vars dv1;
struct file_vars fv1;


int main(int argc, char ** argv)
{
	disk_init();
	file_init();
	
	fv1.src = fopen(filelist[fv1.fileindex], "rb");
	
	while (1) {
		if (fread(fv1.ptr, 1, 1, fv1.src) == 1 && fv1.fileindex >= 0) {
			fprintf(stdout, 
				"%d -> ", 
				ftell(fv1.src));
			
			if (ftell(fv1.dst) % 512 == 0) {
				fix_CHS(0);
			}
			
			fprintf(stdout,
				"(%d, %d, %d, %d) : %02x\n", 
				dv1.cur_head, dv1.cur_cylinder, dv1.cur_sector, dv1.count, fv1.byte);
			
			fwrite(&fv1.byte, 1, 1, fv1.dst);
			++dv1.count;
		}
		else {
			if (fv1.fileindex < fv1.totalfiles) {
				fclose(fv1.src);
				++fv1.fileindex;
				fv1.src = fopen(filelist[fv1.fileindex], "rb");
				fix_CHS(1);
			}
			else {
				break;
			}
		}
	}
	return 0;
}


void disk_init()
{
	dv1.cur_head = 0;
	dv1.cur_sector = 0;
	dv1.cur_cylinder = 0;
	dv1.def8 = 0;
	dv1.def16 = 0;
	dv1.head_limit = 2;
	dv1.sector_size = 512 - (28) + 1;
	dv1.sector_limit = 18;
	dv1.cylinder_limit = 80;
	dv1.count = 0;
}


void file_init()
{
	fv1.fileindex = -1;
	fv1.totalfiles = sizeof(filelist) / sizeof(filelist[0]);
	fv1.src = fopen(filelist[fv1.fileindex], "rb");
	fv1.dst = fopen("CrazyOS.bin", "wb+");
	fv1.byte = 0;
	fv1.ptr = &fv1.byte;
}


void fix_CHS(int nfile)
{
	dv1.count = 0;
	if (dv1.cur_sector < dv1.sector_limit) {
		++dv1.cur_sector;
	}
	else {
		dv1.cur_sector = 1;
		if (dv1.cur_cylinder < dv1.cylinder_limit - 1) {
			++dv1.cur_cylinder;
		}
		else {
			dv1.cur_cylinder = 0;
			if (dv1.cur_head < dv1.head_limit - 1) {
				++dv1.cur_head;
			}
			else {
				fprintf(stdout, 
					"\aMax size of disk exceeded\n");
				exit(0);
			}
		}
	}
	insert_header(nfile);
}


void insert_header(int nfile)
{
	printf("\nBINGO!!\n");
	/*
	 * Set jmp
	 * Set magic
	 * Set Head
	 * Set Cylinder
	 * Set Sector
	 */		
	fv1.tmp = fv1.dst;
	uint8_t jmp = 0xeb;
	uint8_t disp = 0x1a;
	fwrite(&jmp, 1, 1, fv1.dst);
	fwrite(&disp, 1, 1, fv1.dst);
	
	if (nfile == 1) {
		uint16_t magic_for_new_file = 0xaa55;
		fwrite(&magic_for_new_file, 2, 1, fv1.dst);
		fwrite(filelist[fv1.fileindex], 1, 20, fv1.dst);
		//fseek(fv1.dst, -3, SEEK_CUR);
		fwrite(&dv1.def8, 1, 1, fv1.dst);
		fwrite(&dv1.def16, 1, 1, fv1.dst);
		fwrite(&dv1.def8, 1, 1, fv1.dst);
	}
	else if (nfile == 0) {
		fseek(fv1.dst, -485, SEEK_END);
		fwrite(&dv1.cur_sector, 1, 1, fv1.dst);
		fseek(fv1.dst, -487, SEEK_END);
		fwrite(&dv1.cur_cylinder, 2, 1, fv1.dst);
		fseek(fv1.dst, -488, SEEK_END);
		fwrite(&dv1.cur_head, 1, 1, fv1.dst);
		fseek(fv1.dst, 0, SEEK_END);
		uint16_t magic_for_new_block = 0x55aa;
		fwrite(&magic_for_new_block, 2, 1, fv1.dst);
		fwrite(filelist[fv1.fileindex], 1, 20, fv1.dst);
		fwrite(&dv1.def8, 1, 1, fv1.dst);
		fwrite(&dv1.def16, 1, 1, fv1.dst);
		fwrite(&dv1.def8, 1, 1, fv1.dst);

	}
	
}
