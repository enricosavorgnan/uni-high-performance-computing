	.file	"loop.1.c"
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
.LC6:
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
# loop.1.c:54: {
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
	mov	ebp, edi	# argc, tmp230
	push	rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 104	#,
	.cfi_def_cfa_offset 160
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rdi, QWORD PTR 8[rsi]	# MEM[(char * *)argv_74(D) + 8B], MEM[(char * *)argv_74(D) + 8B]
# loop.1.c:54: {
	mov	r13, QWORD PTR fs:40	# argv, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR 88[rsp], r13	# D.5583, argv
	mov	r13, rsi	# argv, tmp231
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	xor	esi, esi	#
	call	strtol@PLT	#
	xor	esi, esi	#
	mov	edx, 10	#,
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	DWORD PTR 28[rsp], eax	# %sfp, _107
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rbx, rax	# _107, tmp232
	mov	rdi, QWORD PTR 16[r13]	# MEM[(char * *)argv_74(D) + 16B], MEM[(char * *)argv_74(D) + 16B]
	call	strtol@PLT	#
# loop.1.c:69:   if ( argc > 3 )
	cmp	ebp, 3	# argc,
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r14, rax	# _105, tmp233
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r15d, eax	# _106, _105
# loop.1.c:69:   if ( argc > 3 )
	jg	.L40	#,
.L2:
# loop.1.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	lea	edi, 0[0+rbx*4]	# _4,
# loop.1.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	mov	esi, 8	#,
# loop.1.c:77:   y    = x + Np;
	movsx	r13, ebx	# _6, _107
# loop.1.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	movsx	rdi, edi	# _5, _4
# loop.1.c:77:   y    = x + Np;
	sal	r13, 3	# _7,
# loop.1.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	call	calloc@PLT	#
# loop.1.c:82:   half_size = 0.5 / Ng;
	vxorps	xmm3, xmm3, xmm3	# tmp237
# loop.1.c:89:   srand48(997766);    // same seed to reproduce results
	mov	edi, 997766	#,
# loop.1.c:82:   half_size = 0.5 / Ng;
	vmovsd	xmm5, QWORD PTR .LC1[rip]	# tmp185,
# loop.1.c:82:   half_size = 0.5 / Ng;
	vcvtsi2sd	xmm4, xmm3, r14d	# tmp238, tmp237, _105
# loop.1.c:76:   x    = (double*)calloc(Np * 4, sizeof(double));
	mov	rbp, rax	# x, tmp235
# loop.1.c:77:   y    = x + Np;
	lea	rax, [rax+r13]	# y,
	mov	QWORD PTR 8[rsp], rax	# %sfp, y
# loop.1.c:82:   half_size = 0.5 / Ng;
	vdivsd	xmm5, xmm5, xmm4	# half_size, tmp185, _8
	vmovsd	QWORD PTR 16[rsp], xmm4	# %sfp, _8
	vmovsd	QWORD PTR [rsp], xmm5	# %sfp, half_size
# loop.1.c:89:   srand48(997766);    // same seed to reproduce results
	call	srand48@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	lea	rdi, .LC2[rip]	# tmp186,
	call	puts@PLT	#
# loop.1.c:93:   for ( int i = 0; i < 3*Np; i++ )
	test	ebx, ebx	# _107
	vmovsd	xmm5, QWORD PTR [rsp]	# half_size, %sfp
	vmovsd	xmm4, QWORD PTR 16[rsp]	# _8, %sfp
	jle	.L7	#,
	lea	edx, -1[rbx+rbx*2]	# _120,
	mov	r14, rbp	# ivtmp.38, x
	lea	rax, 8[rbp+rdx*8]	# _94,
	mov	QWORD PTR [rsp], rax	# %sfp, _94
.L6:
	vmovsd	QWORD PTR 32[rsp], xmm5	# %sfp, half_size
	add	r14, 8	# ivtmp.38,
	vmovsd	QWORD PTR 16[rsp], xmm4	# %sfp, _8
# loop.1.c:94:     x[i] = drand48();
	call	drand48@PLT	#
# loop.1.c:93:   for ( int i = 0; i < 3*Np; i++ )
	vmovsd	xmm4, QWORD PTR 16[rsp]	# _8, %sfp
	vmovsd	xmm5, QWORD PTR 32[rsp]	# half_size, %sfp
# loop.1.c:94:     x[i] = drand48();
	vmovsd	QWORD PTR -8[r14], xmm0	# MEM[(double *)_124], tmp236
# loop.1.c:93:   for ( int i = 0; i < 3*Np; i++ )
	cmp	QWORD PTR [rsp], r14	# %sfp, ivtmp.38
	jne	.L6	#,
.L7:
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	lea	rsi, .LC3[rip]	# tmp187,
	mov	edi, 2	#,
	xor	eax, eax	#
	vmovsd	QWORD PTR 16[rsp], xmm5	# %sfp, half_size
	vmovsd	QWORD PTR [rsp], xmm4	# %sfp, _8
	call	__printf_chk@PLT	#
# loop.1.c:104:   printf("LOOP 1 :: "); fflush(stdout);
	mov	rdi, QWORD PTR stdout[rip]	#, stdout
	call	fflush@PLT	#
# loop.1.c:108:   double ctime = 0;
	vxorpd	xmm0, xmm0, xmm0	# ctime
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	test	r12d, r12d	# nIter
	vxorps	xmm3, xmm3, xmm3	# tmp237
	vmovsd	xmm4, QWORD PTR [rsp]	# _8, %sfp
	vmovsd	xmm5, QWORD PTR 16[rsp]	# half_size, %sfp
# loop.1.c:107:   double dummy = 0;
	vmovapd	xmm1, xmm0	# dummy,
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	jle	.L5	#,
	mov	rax, QWORD PTR 8[rsp]	# y, %sfp
# loop.1.c:108:   double ctime = 0;
	vxorpd	xmm0, xmm0, xmm0	# ctime
	lea	r14, 64[rsp]	# tmp222,
# loop.1.c:107:   double dummy = 0;
	vmovapd	xmm1, xmm0	# dummy,
	vmovsd	QWORD PTR [rsp], xmm0	# %sfp, ctime
	add	rax, r13	# _128, _7
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	xor	r13d, r13d	# r
	mov	QWORD PTR 32[rsp], rax	# %sfp, _128
.L18:
# loop.1.c:113:       double tstart = TCPU_TIME;
	mov	rsi, r14	#, tmp222
	mov	edi, 2	#,
	vmovsd	QWORD PTR 56[rsp], xmm5	# %sfp, half_size
	vmovsd	QWORD PTR 48[rsp], xmm1	# %sfp, dummy
	vmovsd	QWORD PTR 40[rsp], xmm4	# %sfp, _8
	call	clock_gettime@PLT	#
# loop.1.c:113:       double tstart = TCPU_TIME;
	vxorps	xmm3, xmm3, xmm3	# tmp237
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	mov	eax, DWORD PTR 28[rsp]	#, %sfp
	vmovsd	xmm4, QWORD PTR 40[rsp]	# _8, %sfp
# loop.1.c:113:       double tstart = TCPU_TIME;
	vcvtsi2sd	xmm7, xmm3, QWORD PTR 72[rsp]	# tmp239, tmp237, ts.tv_nsec
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	vmovsd	xmm1, QWORD PTR 48[rsp]	# dummy, %sfp
	vmovsd	xmm5, QWORD PTR 56[rsp]	# half_size, %sfp
# loop.1.c:113:       double tstart = TCPU_TIME;
	vcvtsi2sd	xmm2, xmm3, QWORD PTR 64[rsp]	# tmp240, tmp237, ts.tv_sec
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	test	eax, eax	#
	vmovsd	xmm6, QWORD PTR .LC5[rip]	# tmp225,
# loop.1.c:113:       double tstart = TCPU_TIME;
	vfmadd132sd	xmm7, xmm2, QWORD PTR .LC4[rip]	# _18, _16,
	vmovsd	QWORD PTR 16[rsp], xmm7	# %sfp, _18
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	jle	.L8	#,
# loop.1.c:116: 	for ( int i = 0; i < Ng; i++ )
	xor	eax, eax	# ivtmp.25
	test	r15d, r15d	# _106
	lea	esi, -1[rbx]	# _136,
	jle	.L41	#,
.L9:
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	mov	rdi, QWORD PTR 8[rsp]	# y, %sfp
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vmovsd	xmm10, QWORD PTR 0[rbp+rax*8]	# _23, MEM[(double *)x_78 + ivtmp.25_129 * 8]
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	vmovsd	xmm9, QWORD PTR [rdi+rax*8]	# _30, MEM[(double *)y_79 + ivtmp.25_129 * 8]
# loop.1.c:122: 		  pow(z[p]  - (double)k/Ng + half_size, 2);
	mov	rdi, QWORD PTR 32[rsp]	# _128, %sfp
	vmovsd	xmm8, QWORD PTR [rdi+rax*8]	# _38, MEM[(double *)_128 + ivtmp.25_129 * 8]
# loop.1.c:116: 	for ( int i = 0; i < Ng; i++ )
	xor	edi, edi	# i
	.p2align 4,,10
	.p2align 3
.L17:
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vcvtsi2sd	xmm2, xmm3, edi	# tmp243, tmp237, i
# loop.1.c:117: 	  for ( int j = 0; j < Ng; j++ )
	xor	ecx, ecx	# j
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vdivsd	xmm7, xmm2, xmm4	# _25, _24, _8
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vsubsd	xmm7, xmm10, xmm7	# _26, _23, _25
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vaddsd	xmm7, xmm7, xmm5	# _27, _26, half_size
	vmulsd	xmm7, xmm7, xmm7	# powmult_139, _27, _27
	.p2align 4,,10
	.p2align 3
.L16:
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	vcvtsi2sd	xmm2, xmm3, ecx	# tmp242, tmp237, j
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	xor	edx, edx	# k
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	vdivsd	xmm2, xmm2, xmm4	# _32, _31, _8
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	vsubsd	xmm2, xmm9, xmm2	# _33, _30, _32
# loop.1.c:121: 		  pow(y[p] - (double)j/Ng + half_size, 2) +
	vaddsd	xmm2, xmm2, xmm5	# _34, _33, half_size
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vfmadd132sd	xmm2, xmm7, xmm2	# _36, powmult_139, _34
	jmp	.L13	#
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L11:
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	add	edx, 1	# k,
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	cmp	edx, r15d	# k, _106
	je	.L42	#,
.L13:
# loop.1.c:122: 		  pow(z[p]  - (double)k/Ng + half_size, 2);
	vcvtsi2sd	xmm0, xmm3, edx	# tmp241, tmp237, k
# loop.1.c:122: 		  pow(z[p]  - (double)k/Ng + half_size, 2);
	vdivsd	xmm0, xmm0, xmm4	# _40, _39, _8
# loop.1.c:122: 		  pow(z[p]  - (double)k/Ng + half_size, 2);
	vsubsd	xmm0, xmm8, xmm0	# _41, _38, _40
# loop.1.c:122: 		  pow(z[p]  - (double)k/Ng + half_size, 2);
	vaddsd	xmm0, xmm0, xmm5	# _42, _41, half_size
# loop.1.c:120: 		dist = pow(x[p] - (double)i/Ng + half_size, 2.0) +
	vfmadd132sd	xmm0, xmm2, xmm0	# dist, _36, _42
# loop.1.c:124: 		if(dist < Rmax2)
	vcomisd	xmm6, xmm0	# tmp225, dist
	jbe	.L11	#,
# loop.1.c:125: 		  dummy += sqrt(dist);
	vsqrtsd	xmm0, xmm0, xmm0	# _99, dist
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	add	edx, 1	# k,
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	cmp	edx, r15d	# k, _106
# loop.1.c:125: 		  dummy += sqrt(dist);
	vaddsd	xmm1, xmm1, xmm0	# dummy, dummy, _99
# loop.1.c:118: 	    for ( int k = 0; k < Ng; k++ )
	jne	.L13	#,
.L42:
# loop.1.c:117: 	  for ( int j = 0; j < Ng; j++ )
	add	ecx, 1	# j,
# loop.1.c:117: 	  for ( int j = 0; j < Ng; j++ )
	cmp	ecx, r15d	# j, _106
	jne	.L16	#,
# loop.1.c:116: 	for ( int i = 0; i < Ng; i++ )
	add	edi, 1	# i,
# loop.1.c:116: 	for ( int i = 0; i < Ng; i++ )
	cmp	edi, r15d	# i, _106
	jne	.L17	#,
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	cmp	rax, rsi	# ivtmp.25, _136
	lea	rdx, 1[rax]	# ivtmp.25,
	je	.L8	#,
	mov	rax, rdx	# ivtmp.25, ivtmp.25
	jmp	.L9	#
.L41:
	test	sil, 1	# _136,
	je	.L43	#,
.L10:
	lea	rdx, 1[rax]	# tmp229,
	add	rax, 2	# ivtmp.25,
	cmp	rsi, rdx	# _136, tmp229
	jne	.L10	#,
.L8:
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	mov	rsi, r14	#, tmp222
	mov	edi, 2	#,
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	add	r13d, 1	# r,
	vmovsd	QWORD PTR 56[rsp], xmm5	# %sfp, half_size
	vmovsd	QWORD PTR 48[rsp], xmm1	# %sfp, dummy
	vmovsd	QWORD PTR 40[rsp], xmm4	# %sfp, _8
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	call	clock_gettime@PLT	#
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	vxorps	xmm3, xmm3, xmm3	# tmp237
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	cmp	r12d, r13d	# nIter, r
	vmovsd	xmm4, QWORD PTR 40[rsp]	# _8, %sfp
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	vcvtsi2sd	xmm7, xmm3, QWORD PTR 64[rsp]	# tmp245, tmp237, ts.tv_sec
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	vmovsd	xmm1, QWORD PTR 48[rsp]	# dummy, %sfp
	vmovsd	xmm5, QWORD PTR 56[rsp]	# half_size, %sfp
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	vcvtsi2sd	xmm2, xmm3, QWORD PTR 72[rsp]	# tmp244, tmp237, ts.tv_nsec
	vfmadd132sd	xmm2, xmm7, QWORD PTR .LC4[rip]	# _49, _45,
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	vsubsd	xmm2, xmm2, QWORD PTR 16[rsp]	# _88, _49, %sfp
# loop.1.c:128:       ctime += TCPU_TIME - tstart;
	vaddsd	xmm7, xmm2, QWORD PTR [rsp]	# ctime, _88, %sfp
	vmovsd	QWORD PTR [rsp], xmm7	# %sfp, ctime
# loop.1.c:110:   for ( int r = 0; r < nIter; r++ )
	jne	.L18	#,
	vmovapd	xmm0, xmm7	# ctime, ctime
.L5:
# loop.1.c:131:   printf("\t%g sec [%g]\n", ctime/nIter, dummy/nIter);
	vcvtsi2sd	xmm2, xmm3, r12d	# tmp246, tmp237, nIter
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	mov	edi, 2	#,
	mov	eax, 2	#,
	lea	rsi, .LC6[rip]	# tmp219,
# loop.1.c:131:   printf("\t%g sec [%g]\n", ctime/nIter, dummy/nIter);
	vdivsd	xmm0, xmm0, xmm2	# _52, ctime, _50
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:86:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	vdivsd	xmm1, xmm1, xmm2	#, dummy, _50
	call	__printf_chk@PLT	#
# loop.1.c:133:   free(x);
	mov	rdi, rbp	#, x
	call	free@PLT	#
# loop.1.c:136: }
	mov	rax, QWORD PTR 88[rsp]	# tmp247, D.5583
	sub	rax, QWORD PTR fs:40	# tmp247, MEM[(<address-space-1> long unsigned int *)40B]
	jne	.L44	#,
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
.L40:
	.cfi_restore_state
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	rdi, QWORD PTR 24[r13]	# MEM[(char * *)argv_74(D) + 24B], MEM[(char * *)argv_74(D) + 24B]
	mov	edx, 10	#,
	xor	esi, esi	#
	call	strtol@PLT	#
# /usr/include/stdlib.h:483:   return (int) strtol (__nptr, (char **) NULL, 10);
	mov	r12d, eax	# nIter, tmp234
	jmp	.L2	#
.L43:
# loop.1.c:115:       for ( int p = 0; p < Np; p++ )
	test	rsi, rsi	# _136
	mov	eax, 1	# ivtmp.25,
	jne	.L10	#,
	jmp	.L8	#
.L44:
# loop.1.c:136: }
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
	.long	-400107883
	.long	1041313291
	.align 8
.LC5:
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
