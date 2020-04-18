#include <idc.idc>

static main(void) 
{
	SetSelector(0X1,0);
	SegCreate(0,0X3FFF,0,1,1,2);
	SegRename(0,"Boot");
	SegClass (0,"");
	SegCreate(0X4000,0X5FFF,0,1,1,2);
	SegRename(0X4000,"Param1");
	SegClass (0X4000,"");
	SegCreate(0X6000,0X7FFF,0,1,1,2);
	SegRename(0X6000,"Param2");
	SegClass (0X6000,"");
	SegCreate(0X8000,0X1FFFF,0,1,1,2);
	SegRename(0X8000,"Calibration");
	SegClass (0X8000,"");
	SegCreate(0X20000,0X3FFFF,0,1,1,2);
	SegRename(0X20000,"OS1");
	SegClass (0X20000,"");
	SegCreate(0X40000,0X5FFFF,0,1,1,2);
	SegRename(0X40000,"OS2");
	SegClass (0X40000,"");
	SegCreate(0X60000,0X7FFFF,0,1,1,2);
	SegRename(0X60000,"OS3");
	SegClass (0X60000,"");

	SegCreate(0X80000,0X8FFFF,0,1,1,2);
	SegRename(0X80000,"OS4");
	SegClass (0X80000,"");

	SegCreate(0XA0000,0XAFFFF,0,1,1,2);
	SegRename(0XA0000,"OS5");
	SegClass (0XA0000,"");

	SegCreate(0XC0000,0XCFFFF,0,1,1,2);
	SegRename(0XC0000,"OS6");
	SegClass (0XC0000,"");

	SegCreate(0XE0000,0XEFFFF,0,1,1,2);
	SegRename(0XE0000,"OS7");
	SegClass (0XE0000,"");

	SegCreate(0XFF0000,0XFFFFFF,0,1,1,2);
	SegRename(0XFF0000,"RAM_00");
	SegClass (0XFF0000,"");
	SegCreate(0XFFFF0000,0XFFFFFFFF,0,1,1,2);
	SegRename(0XFFFF0000,"RAM_FF");
	SegClass (0XFFFF0000,"");
	LowVoids(0x0);
	HighVoids(0xFFFFD000);
}