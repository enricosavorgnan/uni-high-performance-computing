	.file	"loop.2.c"
	.intel_syntax noprefix
# GNU C17 (Ubuntu 14.2.0-4ubuntu2~24.04.1) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -march=alderlake -mmmx -mpopcnt -msse -msse2 -msse3 -mssse3 -msse4.1 -msse4.2 -mavx -mavx2 -mno-sse4a -mno-fma4 -mno-xop -mfma -mno-avx512f -mbmi -mbmi2 -maes -mpclmul -mno-avx512vl -mno-avx512bw -mno-avx512dq -mno-avx512cd -mno-avx512vbmi -mno-avx512ifma -mno-avx512vpopcntdq -mno-avx512vbmi2 -mgfni -mvpclmulqdq -mno-avx512vnni -mno-avx512bitalg -mno-avx512bf16 -mno-avx512vp2intersect -mno-3dnow -madx -mabm -mno-cldemote -mclflushopt -mclwb -mno-clzero -mcx16 -mno-enqcmd -mf16c -mfsgsbase -mfxsr -mno-hle -msahf -mno-lwp -mlzcnt -mmovbe -mmovdir64b -mmovdiri -mno-mwaitx -mno-pconfig -mpku -mprfchw -mptwrite -mrdpid -mrdrnd -mrdseed -mno-rtm -mserialize -mno-sgx -msha -mshstk -mno-tbm -mno-tsxldtrk -mvaes -mwaitpkg -mno-wbnoinvd -mxsave -mxsavec -mxsaveopt -mxsaves -mno-amx-tile -mno-amx-int8 -mno-amx-bf16 -mno-uintr -mhreset -mno-kl -mno-widekl -mavxvnni -mno-avx512fp16 -mno-avxifma -mno-avxvnniint8 -mno-avxneconvert -mno-cmpccxadd -mno-amx-fp16 -mno-prefetchi -mno-raoint -mno-amx-complex -mno-avxvnniint16 -mno-sm3 -mno-sha512 -mno-sm4 -mno-apxf -mno-usermsr --param=l1-cache-size=32 --param=l1-cache-line-size=64 --param=l2-cache-size=18432 -mtune=alderlake -masm=intel -O3 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"initialize coordinates.."
.LC3:
	.string	"LOOP 1 :: "
.LC7:
	.string	"\t%g sec [%g]\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB37:
	.cfi_startproc
	endbr64	
	push	r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	edx, 10	#,
# loop.2.c:54: {
	push	r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12d, 30	# nIter,
	push	rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	ebp, edi	# argc, tmp223
	push	rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 104	#,
	.cfi_def_cfa_offset 160
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rdi, QWORD PTR 8[rsi]	# MEM[(char * *)argv_72(D) + 8B], MEM[(char * *)argv_72(D) + 8B]
# loop.2.c:54: {
	mov	r13, QWORD PTR fs:40	# argv, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR 88[rsp], r13	# D.5587, argv
	mov	r13, rsi	# argv, tmp224
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	xor	esi, esi	#
	call	strtol@PLT	#
	xor	esi, esi	#
	mov	edx, 10	#,
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	DWORD PTR 28[rsp], eax	# %sfp, _106
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rbx, rax	# _106, tmp225
	mov	rdi, QWORD PTR 16[r13]	# MEM[(char * *)argv_72(D) + 16B], MEM[(char * *)argv_72(D) + 16B]
	call	strtol@PLT	#
# loop.2.c:69:   if ( argc > 3 )
	cmp	ebp, 3	# argc,
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r14, rax	# _104, tmp226
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r15d, eax	# _105, _104
# loop.2.c:69:   if ( argc > 3 )
	jg	.L36	#,
.L2:
# loop.2.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	lea	edi, 0[0+rbx*4]	# _4,
# loop.2.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	mov	esi, 8	#,
# loop.2.c:77:   y    = x + Np;
	movsx	r13, ebx	# _6, _106
# loop.2.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	movsx	rdi, edi	# _5, _4
# loop.2.c:77:   y    = x + Np;
	sal	r13, 3	# _7,
# loop.2.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	call	calloc@PLT	#
# loop.2.c:82:   half_size = 0.5 / Ng;
	vxorps	xmm3, xmm3, xmm3	# tmp230
# loop.2.c:89:   srand48(997766);    // same seed to reproduce results
	mov	edi, 997766	#,
# loop.2.c:82:   half_size = 0.5 / Ng;
	vmovsd	xmm4, QWORD PTR .LC1[rip]	# tmp183,
# loop.2.c:82:   half_size = 0.5 / Ng;
	vcvtsi2sd	xmm0, xmm3, r14d	# tmp231, tmp230, _104
# loop.2.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	mov	rbp, rax	# x, tmp228
# loop.2.c:77:   y    = x + Np;
	lea	rax, [rax+r13]	# y,
	mov	QWORD PTR [rsp], rax	# %sfp, y
# loop.2.c:82:   half_size = 0.5 / Ng;
	vdivsd	xmm4, xmm4, xmm0	# half_size, tmp183, _8
# loop.2.c:82:   half_size = 0.5 / Ng;
	vmovsd	QWORD PTR 8[rsp], xmm0	# %sfp, _8
# loop.2.c:82:   half_size = 0.5 / Ng;
	vmovsd	QWORD PTR 16[rsp], xmm4	# %sfp, half_size
# loop.2.c:89:   srand48(997766);    // same seed to reproduce results
	call	srand48@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	lea	rdi, .LC2[rip]	# tmp184,
	call	puts@PLT	#
# loop.2.c:93:   for ( int i = 0; i < 3*Np; i++ )
	test	ebx, ebx	# _106
	vmovsd	xmm4, QWORD PTR 16[rsp]	# half_size, %sfp
	jle	.L7	#,
	lea	edx, -1[rbx+rbx*2]	# _119,
	mov	r14, rbp	# ivtmp.38, x
	lea	rax, 8[rbp+rdx*8]	# _71,
	mov	QWORD PTR 16[rsp], rax	# %sfp, _71
.L6:
	vmovsd	QWORD PTR 32[rsp], xmm4	# %sfp, half_size
	add	r14, 8	# ivtmp.38,
# loop.2.c:94:     x[i] = drand48();
	call	drand48@PLT	#
# loop.2.c:93:   for ( int i = 0; i < 3*Np; i++ )
	vmovsd	xmm4, QWORD PTR 32[rsp]	# half_size, %sfp
# loop.2.c:94:     x[i] = drand48();
	vmovsd	QWORD PTR -8[r14], xmm0	# MEM[(double *)_123], tmp229
# loop.2.c:93:   for ( int i = 0; i < 3*Np; i++ )
	cmp	QWORD PTR 16[rsp], r14	# %sfp, ivtmp.38
	jne	.L6	#,
.L7:
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	lea	rsi, .LC3[rip]	# tmp185,
	mov	edi, 2	#,
	xor	eax, eax	#
	vmovsd	QWORD PTR 16[rsp], xmm4	# %sfp, half_size
	call	__printf_chk@PLT	#
# loop.2.c:104:   printf("LOOP 1 :: "); fflush(stdout);
	mov	rdi, QWORD PTR stdout[rip]	#, stdout
	call	fflush@PLT	#
# loop.2.c:108:   double ctime = 0;
	vxorpd	xmm11, xmm11, xmm11	# ctime
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	test	r12d, r12d	# nIter
	vxorps	xmm3, xmm3, xmm3	# tmp230
# loop.2.c:109:   double Ng_inv = 1.0/(double)Ng;
	vmovsd	xmm5, QWORD PTR .LC4[rip]	# tmp187,
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	vmovsd	xmm4, QWORD PTR 16[rsp]	# half_size, %sfp
# loop.2.c:107:   double dummy = 0;
	vmovapd	xmm1, xmm11	# dummy,
# loop.2.c:109:   double Ng_inv = 1.0/(double)Ng;
	vdivsd	xmm5, xmm5, QWORD PTR 8[rsp]	# Ng_inv, tmp187, %sfp
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	jle	.L5	#,
	mov	rax, QWORD PTR [rsp]	# y, %sfp
# loop.2.c:108:   double ctime = 0;
	vxorpd	xmm11, xmm11, xmm11	# ctime
	lea	r14, 64[rsp]	# tmp215,
# loop.2.c:107:   double dummy = 0;
	vmovapd	xmm1, xmm11	# dummy,
	add	rax, r13	# _127, _7
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	xor	r13d, r13d	# r
	mov	QWORD PTR 16[rsp], rax	# %sfp, _127
.L16:
# loop.2.c:114:       double tstart = TCPU_TIME;
	mov	rsi, r14	#, tmp215
	mov	edi, 2	#,
	vmovsd	QWORD PTR 56[rsp], xmm11	# %sfp, ctime
	vmovsd	QWORD PTR 48[rsp], xmm5	# %sfp, Ng_inv
	vmovsd	QWORD PTR 40[rsp], xmm4	# %sfp, half_size
	vmovsd	QWORD PTR 32[rsp], xmm1	# %sfp, dummy
	call	clock_gettime@PLT	#
# loop.2.c:114:       double tstart = TCPU_TIME;
	vxorps	xmm3, xmm3, xmm3	# tmp230
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	mov	eax, DWORD PTR 28[rsp]	#, %sfp
	vmovsd	xmm1, QWORD PTR 32[rsp]	# dummy, %sfp
# loop.2.c:114:       double tstart = TCPU_TIME;
	vcvtsi2sd	xmm2, xmm3, QWORD PTR 72[rsp]	# tmp232, tmp230, ts.tv_nsec
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	vmovsd	xmm4, QWORD PTR 40[rsp]	# half_size, %sfp
	vmovsd	xmm5, QWORD PTR 48[rsp]	# Ng_inv, %sfp
# loop.2.c:114:       double tstart = TCPU_TIME;
	vcvtsi2sd	xmm0, xmm3, QWORD PTR 64[rsp]	# tmp233, tmp230, ts.tv_sec
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	test	eax, eax	#
	vmovsd	xmm11, QWORD PTR 56[rsp]	# ctime, %sfp
	vmovsd	xmm6, QWORD PTR .LC6[rip]	# tmp218,
# loop.2.c:114:       double tstart = TCPU_TIME;
	vfmadd132sd	xmm2, xmm0, QWORD PTR .LC5[rip]	# _18, _16,
	vmovsd	QWORD PTR 8[rsp], xmm2	# %sfp, _18
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	jle	.L8	#,
# loop.2.c:117: 	for ( int i = 0; i < Ng; i++ ) {
	test	r15d, r15d	# _105
	lea	r8d, -1[rbx]	# _135,
	jle	.L19	#,
	xor	edi, edi	# ivtmp.25
.L15:
# loop.2.c:120: 	    double dy2 = (y[p] - (double)j*Ng_inv + half_size)*(y[p] - (double)j*Ng_inv + half_size);
	mov	rax, QWORD PTR [rsp]	# y, %sfp
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vmovsd	xmm10, QWORD PTR 0[rbp+rdi*8]	# _23, MEM[(double *)x_76 + ivtmp.25_128 * 8]
# loop.2.c:117: 	for ( int i = 0; i < Ng; i++ ) {
	xor	esi, esi	# i
# loop.2.c:120: 	    double dy2 = (y[p] - (double)j*Ng_inv + half_size)*(y[p] - (double)j*Ng_inv + half_size);
	vmovsd	xmm9, QWORD PTR [rax+rdi*8]	# _30, MEM[(double *)y_77 + ivtmp.25_128 * 8]
# loop.2.c:123: 		double dz2 = (z[p] - (double)k*Ng_inv + half_size)*(z[p] - (double)k*Ng_inv + half_size);
	mov	rax, QWORD PTR 16[rsp]	# _127, %sfp
	vmovsd	xmm7, QWORD PTR [rax+rdi*8]	# _36, MEM[(double *)_127 + ivtmp.25_128 * 8]
	.p2align 4,,10
	.p2align 3
.L14:
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vcvtsi2sd	xmm0, xmm3, esi	# tmp234, tmp230, i
# loop.2.c:119: 	  for ( int j = 0; j < Ng; j++ ) {
	xor	edx, edx	# j
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vmovapd	xmm8, xmm0	# _24, tmp234
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vfnmadd132sd	xmm8, xmm10, xmm5	# _26, _23, Ng_inv
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vaddsd	xmm8, xmm8, xmm4	# _27, _26, half_size
# loop.2.c:118: 	  double dx2 = (x[p] - (double)i*Ng_inv + half_size)*(x[p] - (double)i*Ng_inv + half_size);
	vmulsd	xmm8, xmm8, xmm8	# dx2, _27, _27
	.p2align 4,,10
	.p2align 3
.L13:
# loop.2.c:120: 	    double dy2 = (y[p] - (double)j*Ng_inv + half_size)*(y[p] - (double)j*Ng_inv + half_size);
	vcvtsi2sd	xmm2, xmm3, edx	# tmp235, tmp230, j
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	xor	eax, eax	# k
# loop.2.c:120: 	    double dy2 = (y[p] - (double)j*Ng_inv + half_size)*(y[p] - (double)j*Ng_inv + half_size);
	vfnmadd132sd	xmm2, xmm9, xmm5	# _33, _30, Ng_inv
# loop.2.c:120: 	    double dy2 = (y[p] - (double)j*Ng_inv + half_size)*(y[p] - (double)j*Ng_inv + half_size);
	vaddsd	xmm2, xmm2, xmm4	# _34, _33, half_size
# loop.2.c:124: 		double dist2 = dx2 + dy2 + dz2 ;
	vfmadd132sd	xmm2, xmm8, xmm2	# _176, dx2, _34
	jmp	.L12	#
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L10:
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	add	eax, 1	# k,
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	cmp	eax, r15d	# k, _105
	je	.L37	#,
.L12:
# loop.2.c:123: 		double dz2 = (z[p] - (double)k*Ng_inv + half_size)*(z[p] - (double)k*Ng_inv + half_size);
	vcvtsi2sd	xmm0, xmm3, eax	# tmp236, tmp230, k
# loop.2.c:123: 		double dz2 = (z[p] - (double)k*Ng_inv + half_size)*(z[p] - (double)k*Ng_inv + half_size);
	vfnmadd132sd	xmm0, xmm7, xmm5	# _39, _36, Ng_inv
# loop.2.c:123: 		double dz2 = (z[p] - (double)k*Ng_inv + half_size)*(z[p] - (double)k*Ng_inv + half_size);
	vaddsd	xmm0, xmm0, xmm4	# _40, _39, half_size
# loop.2.c:124: 		double dist2 = dx2 + dy2 + dz2 ;
	vfmadd132sd	xmm0, xmm2, xmm0	# dist2, _176, _40
# loop.2.c:126: 		if(dist2 < Rmax2)
	vcomisd	xmm6, xmm0	# tmp218, dist2
	jbe	.L10	#,
# loop.2.c:127: 		  dummy += sqrt(dist2);
	vsqrtsd	xmm0, xmm0, xmm0	# _98, dist2
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	add	eax, 1	# k,
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	cmp	eax, r15d	# k, _105
# loop.2.c:127: 		  dummy += sqrt(dist2);
	vaddsd	xmm1, xmm1, xmm0	# dummy, dummy, _98
# loop.2.c:121: 	    for ( int k = 0; k < Ng; k++ )
	jne	.L12	#,
.L37:
# loop.2.c:119: 	  for ( int j = 0; j < Ng; j++ ) {
	add	edx, 1	# j,
# loop.2.c:119: 	  for ( int j = 0; j < Ng; j++ ) {
	cmp	edx, r15d	# j, _105
	jne	.L13	#,
# loop.2.c:117: 	for ( int i = 0; i < Ng; i++ ) {
	add	esi, 1	# i,
# loop.2.c:117: 	for ( int i = 0; i < Ng; i++ ) {
	cmp	esi, r15d	# i, _105
	jne	.L14	#,
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	cmp	rdi, r8	# ivtmp.25, _135
	lea	rax, 1[rdi]	# ivtmp.25,
	je	.L8	#,
	mov	rdi, rax	# ivtmp.25, ivtmp.25
	jmp	.L15	#
.L19:
# loop.2.c:117: 	for ( int i = 0; i < Ng; i++ ) {
	xor	eax, eax	# ivtmp.25
	test	r8b, 1	# _135,
	je	.L32	#,
.L9:
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	lea	rdx, 1[rax]	# tmp222,
	add	rax, 2	# ivtmp.25,
	cmp	r8, rdx	# _135, tmp222
	jne	.L9	#,
.L8:
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	mov	rsi, r14	#, tmp215
	mov	edi, 2	#,
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	add	r13d, 1	# r,
	vmovsd	QWORD PTR 56[rsp], xmm11	# %sfp, ctime
	vmovsd	QWORD PTR 48[rsp], xmm5	# %sfp, Ng_inv
	vmovsd	QWORD PTR 40[rsp], xmm4	# %sfp, half_size
	vmovsd	QWORD PTR 32[rsp], xmm1	# %sfp, dummy
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	call	clock_gettime@PLT	#
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vxorps	xmm3, xmm3, xmm3	# tmp230
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	cmp	r12d, r13d	# nIter, r
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vmovsd	xmm11, QWORD PTR 56[rsp]	# ctime, %sfp
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vcvtsi2sd	xmm0, xmm3, QWORD PTR 72[rsp]	# tmp237, tmp230, ts.tv_nsec
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	vmovsd	xmm1, QWORD PTR 32[rsp]	# dummy, %sfp
	vmovsd	xmm4, QWORD PTR 40[rsp]	# half_size, %sfp
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vcvtsi2sd	xmm2, xmm3, QWORD PTR 64[rsp]	# tmp238, tmp230, ts.tv_sec
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	vmovsd	xmm5, QWORD PTR 48[rsp]	# Ng_inv, %sfp
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vfmadd132sd	xmm0, xmm2, QWORD PTR .LC5[rip]	# _47, _43,
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vsubsd	xmm0, xmm0, QWORD PTR 8[rsp]	# _87, _47, %sfp
# loop.2.c:132:       ctime += TCPU_TIME - tstart;
	vaddsd	xmm11, xmm11, xmm0	# ctime, ctime, _87
# loop.2.c:111:   for ( int r = 0; r < nIter; r++ )
	jne	.L16	#,
.L5:
# loop.2.c:135:   printf("\t%g sec [%g]\n", ctime/nIter, dummy/nIter);
	vcvtsi2sd	xmm0, xmm3, r12d	# tmp239, tmp230, nIter
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	mov	edi, 2	#,
	mov	eax, 2	#,
	lea	rsi, .LC7[rip]	# tmp212,
# loop.2.c:135:   printf("\t%g sec [%g]\n", ctime/nIter, dummy/nIter);
	vdivsd	xmm11, xmm11, xmm0	# _50, ctime, _48
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	vdivsd	xmm1, xmm1, xmm0	#, dummy, _48
	vmovapd	xmm0, xmm11	#, _50
	call	__printf_chk@PLT	#
# loop.2.c:137:   free(x);
	mov	rdi, rbp	#, x
	call	free@PLT	#
# loop.2.c:140: }
	mov	rax, QWORD PTR 88[rsp]	# tmp240, D.5587
	sub	rax, QWORD PTR fs:40	# tmp240, MEM[(<address-space-1> long unsigned int *)40B]
	jne	.L38	#,
	add	rsp, 104	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xor	eax, eax	#
	pop	rbx	#
	.cfi_def_cfa_offset 48
	pop	rbp	#
	.cfi_def_cfa_offset 40
	pop	r12	#
	.cfi_def_cfa_offset 32
	pop	r13	#
	.cfi_def_cfa_offset 24
	pop	r14	#
	.cfi_def_cfa_offset 16
	pop	r15	#
	.cfi_def_cfa_offset 8
	ret	
.L36:
	.cfi_restore_state
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rdi, QWORD PTR 24[r13]	# MEM[(char * *)argv_72(D) + 24B], MEM[(char * *)argv_72(D) + 24B]
	mov	edx, 10	#,
	xor	esi, esi	#
	call	strtol@PLT	#
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r12d, eax	# nIter, tmp227
	jmp	.L2	#
.L32:
# loop.2.c:116:       for ( int p = 0; p < Np; p++ )
	test	r8, r8	# _135
	mov	eax, 1	# ivtmp.25,
	jne	.L9	#,
	jmp	.L8	#
.L38:
# loop.2.c:140: }
	call	__stack_chk_fail@PLT	#
	.cfi_endproc
.LFE37:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1071644672
	.align 8
.LC4:
	.long	0
	.long	1072693248
	.align 8
.LC5:
	.long	-400107883
	.long	1041313291
	.align 8
.LC6:
	.long	1202590844
	.long	1067743969
	.ident	"GCC: (Ubuntu 14.2.0-4ubuntu2~24.04.1) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
