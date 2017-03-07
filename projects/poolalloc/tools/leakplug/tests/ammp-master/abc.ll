; ModuleID = 'ammp-master/abc.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

%struct.ABC = type { %struct.ATOM*, %struct.ATOM*, %struct.ATOM*, float, float, float, float, float, i8*, i8*, i8* }
%struct.ATOM = type { float, float, float, float, double, double, double, double, i32, float, float, float, float, float, float, i8*, i8, [9 x i8], float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, [400 x i8*], [64 x i8*], [64 x i8], i32 }
%struct.BOND = type { %struct.ATOM*, %struct.ATOM*, float, float, float, float, i32, i8* }
%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sFILEX = type opaque
%struct.__sbuf = type { i8*, i32 }

@abc_first = global %struct.ABC* null, align 8
@abc_last = global %struct.ABC* null, align 8
@.str = private unnamed_addr constant [33 x i8] c"undefined atom in abc %d %d %d \00\00", align 1
@bond_first = external global %struct.BOND*
@.str1 = private unnamed_addr constant [31 x i8] c"abc %d %d %d %f %f %f %f %f ;\0A\00", align 1
@.str2 = private unnamed_addr constant [30 x i8] c"abc %d %d %d %f %f %f %f %f;\0A\00", align 1
@.str3 = private unnamed_addr constant [41 x i8] c"abc bond %d %d  E %f r %f k %f error %f\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define i32 @abc(i32 %p1, i32 %p2, i32 %p3, double, double, double, double, double) #0 {
entry:
  %retval = alloca i32, align 4
  %p1.addr = alloca i32, align 4
  %p2.addr = alloca i32, align 4
  %p3.addr = alloca i32, align 4
  %theta.addr = alloca float, align 4
  %thetazero.addr = alloca float, align 4
  %dr.addr = alloca float, align 4
  %dk1.addr = alloca float, align 4
  %dk2.addr = alloca float, align 4
  %new = alloca %struct.ABC*, align 8
  %ap1 = alloca %struct.ATOM*, align 8
  %ap2 = alloca %struct.ATOM*, align 8
  %ap3 = alloca %struct.ATOM*, align 8
  %line = alloca [80 x i8], align 16
  %i = alloca i32, align 4
  %theta = fptrunc double %0 to float
  %thetazero = fptrunc double %1 to float
  %dr = fptrunc double %2 to float
  %dk1 = fptrunc double %3 to float
  %dk2 = fptrunc double %4 to float
  store i32 %p1, i32* %p1.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %p1.addr, metadata !185, metadata !186), !dbg !187
  store i32 %p2, i32* %p2.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %p2.addr, metadata !188, metadata !186), !dbg !189
  store i32 %p3, i32* %p3.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %p3.addr, metadata !190, metadata !186), !dbg !191
  store float %theta, float* %theta.addr, align 4
  call void @llvm.dbg.declare(metadata float* %theta.addr, metadata !192, metadata !186), !dbg !193
  store float %thetazero, float* %thetazero.addr, align 4
  call void @llvm.dbg.declare(metadata float* %thetazero.addr, metadata !194, metadata !186), !dbg !195
  store float %dr, float* %dr.addr, align 4
  call void @llvm.dbg.declare(metadata float* %dr.addr, metadata !196, metadata !186), !dbg !197
  store float %dk1, float* %dk1.addr, align 4
  call void @llvm.dbg.declare(metadata float* %dk1.addr, metadata !198, metadata !186), !dbg !199
  store float %dk2, float* %dk2.addr, align 4
  call void @llvm.dbg.declare(metadata float* %dk2.addr, metadata !200, metadata !186), !dbg !201
  call void @llvm.dbg.declare(metadata %struct.ABC** %new, metadata !202, metadata !186), !dbg !203
  call void @llvm.dbg.declare(metadata %struct.ATOM** %ap1, metadata !204, metadata !186), !dbg !205
  call void @llvm.dbg.declare(metadata %struct.ATOM** %ap2, metadata !206, metadata !186), !dbg !207
  call void @llvm.dbg.declare(metadata %struct.ATOM** %ap3, metadata !208, metadata !186), !dbg !209
  call void @llvm.dbg.declare(metadata [80 x i8]* %line, metadata !210, metadata !186), !dbg !214
  call void @llvm.dbg.declare(metadata i32* %i, metadata !215, metadata !186), !dbg !216
  %5 = load i32, i32* %p1.addr, align 4, !dbg !217
  %call = call %struct.ATOM* (i32, ...) bitcast (%struct.ATOM* (...)* @a_m_serial to %struct.ATOM* (i32, ...)*)(i32 %5), !dbg !218
  store %struct.ATOM* %call, %struct.ATOM** %ap1, align 8, !dbg !219
  %6 = load i32, i32* %p2.addr, align 4, !dbg !220
  %call5 = call %struct.ATOM* (i32, ...) bitcast (%struct.ATOM* (...)* @a_m_serial to %struct.ATOM* (i32, ...)*)(i32 %6), !dbg !221
  store %struct.ATOM* %call5, %struct.ATOM** %ap2, align 8, !dbg !222
  %7 = load i32, i32* %p3.addr, align 4, !dbg !223
  %call6 = call %struct.ATOM* (i32, ...) bitcast (%struct.ATOM* (...)* @a_m_serial to %struct.ATOM* (i32, ...)*)(i32 %7), !dbg !224
  store %struct.ATOM* %call6, %struct.ATOM** %ap3, align 8, !dbg !225
  %8 = load %struct.ATOM*, %struct.ATOM** %ap1, align 8, !dbg !226
  %cmp = icmp eq %struct.ATOM* %8, null, !dbg !228
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !229

lor.lhs.false:                                    ; preds = %entry
  %9 = load %struct.ATOM*, %struct.ATOM** %ap2, align 8, !dbg !230
  %cmp7 = icmp eq %struct.ATOM* %9, null, !dbg !231
  br i1 %cmp7, label %if.then, label %lor.lhs.false8, !dbg !232

lor.lhs.false8:                                   ; preds = %lor.lhs.false
  %10 = load %struct.ATOM*, %struct.ATOM** %ap3, align 8, !dbg !233
  %cmp9 = icmp eq %struct.ATOM* %10, null, !dbg !234
  br i1 %cmp9, label %if.then, label %if.end, !dbg !235

if.then:                                          ; preds = %lor.lhs.false8, %lor.lhs.false, %entry
  %arraydecay = getelementptr inbounds [80 x i8], [80 x i8]* %line, i32 0, i32 0, !dbg !236
  %11 = load i32, i32* %p1.addr, align 4, !dbg !236
  %12 = load i32, i32* %p2.addr, align 4, !dbg !236
  %13 = load i32, i32* %p3.addr, align 4, !dbg !236
  %call10 = call i32 (i8*, i32, i64, i8*, ...) @__sprintf_chk(i8* %arraydecay, i32 0, i64 80, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str, i32 0, i32 0), i32 %11, i32 %12, i32 %13), !dbg !236
  %arraydecay11 = getelementptr inbounds [80 x i8], [80 x i8]* %line, i32 0, i32 0, !dbg !238
  %call12 = call i32 @aaerror(i8* %arraydecay11), !dbg !239
  store i32 0, i32* %retval, !dbg !240
  br label %return, !dbg !240

if.end:                                           ; preds = %lor.lhs.false8
  %call13 = call i8* @malloc(i64 72), !dbg !241
  %14 = bitcast i8* %call13 to %struct.ABC*, !dbg !241
  store %struct.ABC* %14, %struct.ABC** %new, align 8, !dbg !243
  %cmp14 = icmp eq %struct.ABC* %14, null, !dbg !244
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !245

if.then15:                                        ; preds = %if.end
  store i32 0, i32* %retval, !dbg !246
  br label %return, !dbg !246

if.end16:                                         ; preds = %if.end
  %15 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !248
  %cmp17 = icmp eq %struct.ABC* %15, null, !dbg !250
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !251

if.then18:                                        ; preds = %if.end16
  %16 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !252
  store %struct.ABC* %16, %struct.ABC** @abc_first, align 8, !dbg !253
  br label %if.end19, !dbg !254

if.end19:                                         ; preds = %if.then18, %if.end16
  %17 = load %struct.ABC*, %struct.ABC** @abc_last, align 8, !dbg !255
  %cmp20 = icmp eq %struct.ABC* %17, null, !dbg !257
  br i1 %cmp20, label %if.then21, label %if.end22, !dbg !258

if.then21:                                        ; preds = %if.end19
  %18 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !259
  store %struct.ABC* %18, %struct.ABC** @abc_last, align 8, !dbg !260
  br label %if.end22, !dbg !261

if.end22:                                         ; preds = %if.then21, %if.end19
  %19 = load %struct.ATOM*, %struct.ATOM** %ap1, align 8, !dbg !262
  %20 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !263
  %atom1 = getelementptr inbounds %struct.ABC, %struct.ABC* %20, i32 0, i32 0, !dbg !264
  store %struct.ATOM* %19, %struct.ATOM** %atom1, align 8, !dbg !265
  %21 = load %struct.ATOM*, %struct.ATOM** %ap2, align 8, !dbg !266
  %22 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !267
  %atom2 = getelementptr inbounds %struct.ABC, %struct.ABC* %22, i32 0, i32 1, !dbg !268
  store %struct.ATOM* %21, %struct.ATOM** %atom2, align 8, !dbg !269
  %23 = load %struct.ATOM*, %struct.ATOM** %ap3, align 8, !dbg !270
  %24 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !271
  %atom3 = getelementptr inbounds %struct.ABC, %struct.ABC* %24, i32 0, i32 2, !dbg !272
  store %struct.ATOM* %23, %struct.ATOM** %atom3, align 8, !dbg !273
  %25 = load float, float* %dr.addr, align 4, !dbg !274
  %26 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !275
  %dr23 = getelementptr inbounds %struct.ABC, %struct.ABC* %26, i32 0, i32 5, !dbg !276
  store float %25, float* %dr23, align 4, !dbg !277
  %27 = load float, float* %theta.addr, align 4, !dbg !278
  %28 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !279
  %theta24 = getelementptr inbounds %struct.ABC, %struct.ABC* %28, i32 0, i32 3, !dbg !280
  store float %27, float* %theta24, align 4, !dbg !281
  %29 = load float, float* %thetazero.addr, align 4, !dbg !282
  %30 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !283
  %thetazero25 = getelementptr inbounds %struct.ABC, %struct.ABC* %30, i32 0, i32 4, !dbg !284
  store float %29, float* %thetazero25, align 4, !dbg !285
  %31 = load float, float* %dk1.addr, align 4, !dbg !286
  %32 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !287
  %dk126 = getelementptr inbounds %struct.ABC, %struct.ABC* %32, i32 0, i32 6, !dbg !288
  store float %31, float* %dk126, align 4, !dbg !289
  %33 = load float, float* %dk2.addr, align 4, !dbg !290
  %34 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !291
  %dk227 = getelementptr inbounds %struct.ABC, %struct.ABC* %34, i32 0, i32 7, !dbg !292
  store float %33, float* %dk227, align 4, !dbg !293
  %35 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !294
  %b1 = getelementptr inbounds %struct.ABC, %struct.ABC* %35, i32 0, i32 8, !dbg !295
  store i8* null, i8** %b1, align 8, !dbg !296
  %36 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !297
  %b2 = getelementptr inbounds %struct.ABC, %struct.ABC* %36, i32 0, i32 9, !dbg !298
  store i8* null, i8** %b2, align 8, !dbg !299
  %37 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !300
  %38 = bitcast %struct.ABC* %37 to i8*, !dbg !300
  %39 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !301
  %next = getelementptr inbounds %struct.ABC, %struct.ABC* %39, i32 0, i32 10, !dbg !302
  store i8* %38, i8** %next, align 8, !dbg !303
  %40 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !304
  %41 = bitcast %struct.ABC* %40 to i8*, !dbg !304
  %42 = load %struct.ABC*, %struct.ABC** @abc_last, align 8, !dbg !305
  %next28 = getelementptr inbounds %struct.ABC, %struct.ABC* %42, i32 0, i32 10, !dbg !306
  store i8* %41, i8** %next28, align 8, !dbg !307
  %43 = load %struct.ABC*, %struct.ABC** %new, align 8, !dbg !308
  store %struct.ABC* %43, %struct.ABC** @abc_last, align 8, !dbg !309
  store i32 1, i32* %retval, !dbg !310
  br label %return, !dbg !310

return:                                           ; preds = %if.end22, %if.then15, %if.then
  %44 = load i32, i32* %retval, !dbg !311
  ret i32 %44, !dbg !311
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare %struct.ATOM* @a_m_serial(...) #2

declare i32 @__sprintf_chk(i8*, i32, i64, i8*, ...) #2

declare i32 @aaerror(i8*) #2

declare i8* @malloc(i64) #2

; Function Attrs: nounwind ssp uwtable
define i32 @v_abc(float* %V, double) #0 {
entry:
  %retval = alloca i32, align 4
  %V.addr = alloca float*, align 8
  %lambda.addr = alloca float, align 4
  %abcp = alloca %struct.ABC*, align 8
  %bp = alloca %struct.BOND*, align 8
  %r = alloca float, align 4
  %x1 = alloca float, align 4
  %y1 = alloca float, align 4
  %z1 = alloca float, align 4
  %keff = alloca float, align 4
  %length_eff = alloca float, align 4
  %a1 = alloca %struct.ATOM*, align 8
  %a2 = alloca %struct.ATOM*, align 8
  %a3 = alloca %struct.ATOM*, align 8
  %lambda = fptrunc double %0 to float
  store float* %V, float** %V.addr, align 8
  call void @llvm.dbg.declare(metadata float** %V.addr, metadata !312, metadata !186), !dbg !313
  store float %lambda, float* %lambda.addr, align 4
  call void @llvm.dbg.declare(metadata float* %lambda.addr, metadata !314, metadata !186), !dbg !315
  call void @llvm.dbg.declare(metadata %struct.ABC** %abcp, metadata !316, metadata !186), !dbg !317
  call void @llvm.dbg.declare(metadata %struct.BOND** %bp, metadata !318, metadata !186), !dbg !331
  call void @llvm.dbg.declare(metadata float* %r, metadata !332, metadata !186), !dbg !333
  call void @llvm.dbg.declare(metadata float* %x1, metadata !334, metadata !186), !dbg !335
  call void @llvm.dbg.declare(metadata float* %y1, metadata !336, metadata !186), !dbg !337
  call void @llvm.dbg.declare(metadata float* %z1, metadata !338, metadata !186), !dbg !339
  call void @llvm.dbg.declare(metadata float* %keff, metadata !340, metadata !186), !dbg !341
  call void @llvm.dbg.declare(metadata float* %length_eff, metadata !342, metadata !186), !dbg !343
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1, metadata !344, metadata !186), !dbg !345
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a2, metadata !346, metadata !186), !dbg !347
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a3, metadata !348, metadata !186), !dbg !349
  %1 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !350
  store %struct.ABC* %1, %struct.ABC** %abcp, align 8, !dbg !351
  %2 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !352
  %cmp = icmp eq %struct.ABC* %2, null, !dbg !354
  br i1 %cmp, label %if.then, label %if.end, !dbg !355

if.then:                                          ; preds = %entry
  %3 = load float*, float** %V.addr, align 8, !dbg !356
  %4 = load float, float* %lambda.addr, align 4, !dbg !358
  %conv = fpext float %4 to double, !dbg !358
  %call = call i32 (float*, double, ...) bitcast (i32 (...)* @v_bond to i32 (float*, double, ...)*)(float* %3, double %conv), !dbg !359
  store i32 %call, i32* %retval, !dbg !360
  br label %return, !dbg !360

if.end:                                           ; preds = %entry
  %5 = load %struct.BOND*, %struct.BOND** @bond_first, align 8, !dbg !361
  store %struct.BOND* %5, %struct.BOND** %bp, align 8, !dbg !362
  %6 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !363
  %cmp1 = icmp eq %struct.BOND* %6, null, !dbg !365
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !366

if.then3:                                         ; preds = %if.end
  store i32 1, i32* %retval, !dbg !367
  br label %return, !dbg !367

if.end4:                                          ; preds = %if.end
  %7 = load float, float* %lambda.addr, align 4, !dbg !368
  %conv5 = fpext float %7 to double, !dbg !368
  %call6 = call i32 @do_abc(double %conv5), !dbg !369
  br label %while.body, !dbg !370

while.body:                                       ; preds = %if.end4, %if.end60
  %8 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !371
  %cmp7 = icmp eq %struct.BOND* %8, null, !dbg !374
  br i1 %cmp7, label %if.then9, label %if.end10, !dbg !375

if.then9:                                         ; preds = %while.body
  store i32 0, i32* %retval, !dbg !376
  br label %return, !dbg !376

if.end10:                                         ; preds = %while.body
  %9 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !377
  %atom1 = getelementptr inbounds %struct.BOND, %struct.BOND* %9, i32 0, i32 0, !dbg !378
  %10 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !378
  store %struct.ATOM* %10, %struct.ATOM** %a1, align 8, !dbg !379
  %11 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !380
  %atom2 = getelementptr inbounds %struct.BOND, %struct.BOND* %11, i32 0, i32 1, !dbg !381
  %12 = load %struct.ATOM*, %struct.ATOM** %atom2, align 8, !dbg !381
  store %struct.ATOM* %12, %struct.ATOM** %a2, align 8, !dbg !382
  %13 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !383
  %active = getelementptr inbounds %struct.ATOM, %struct.ATOM* %13, i32 0, i32 16, !dbg !385
  %14 = load i8, i8* %active, align 1, !dbg !385
  %conv11 = sext i8 %14 to i32, !dbg !383
  %tobool = icmp ne i32 %conv11, 0, !dbg !383
  br i1 %tobool, label %if.then15, label %lor.lhs.false, !dbg !386

lor.lhs.false:                                    ; preds = %if.end10
  %15 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !387
  %active12 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %15, i32 0, i32 16, !dbg !388
  %16 = load i8, i8* %active12, align 1, !dbg !388
  %conv13 = sext i8 %16 to i32, !dbg !387
  %tobool14 = icmp ne i32 %conv13, 0, !dbg !387
  br i1 %tobool14, label %if.then15, label %if.end56, !dbg !389

if.then15:                                        ; preds = %lor.lhs.false, %if.end10
  %17 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !390
  %x = getelementptr inbounds %struct.ATOM, %struct.ATOM* %17, i32 0, i32 0, !dbg !392
  %18 = load float, float* %x, align 4, !dbg !392
  %19 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !393
  %x16 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %19, i32 0, i32 0, !dbg !394
  %20 = load float, float* %x16, align 4, !dbg !394
  %sub = fsub float %18, %20, !dbg !395
  %21 = load float, float* %lambda.addr, align 4, !dbg !396
  %22 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !397
  %dx = getelementptr inbounds %struct.ATOM, %struct.ATOM* %22, i32 0, i32 24, !dbg !398
  %23 = load float, float* %dx, align 4, !dbg !398
  %24 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !399
  %dx17 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %24, i32 0, i32 24, !dbg !400
  %25 = load float, float* %dx17, align 4, !dbg !400
  %sub18 = fsub float %23, %25, !dbg !401
  %mul = fmul float %21, %sub18, !dbg !402
  %add = fadd float %sub, %mul, !dbg !403
  store float %add, float* %x1, align 4, !dbg !404
  %26 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !405
  %y = getelementptr inbounds %struct.ATOM, %struct.ATOM* %26, i32 0, i32 1, !dbg !406
  %27 = load float, float* %y, align 4, !dbg !406
  %28 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !407
  %y19 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %28, i32 0, i32 1, !dbg !408
  %29 = load float, float* %y19, align 4, !dbg !408
  %sub20 = fsub float %27, %29, !dbg !409
  %30 = load float, float* %lambda.addr, align 4, !dbg !410
  %31 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !411
  %dy = getelementptr inbounds %struct.ATOM, %struct.ATOM* %31, i32 0, i32 25, !dbg !412
  %32 = load float, float* %dy, align 4, !dbg !412
  %33 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !413
  %dy21 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %33, i32 0, i32 25, !dbg !414
  %34 = load float, float* %dy21, align 4, !dbg !414
  %sub22 = fsub float %32, %34, !dbg !415
  %mul23 = fmul float %30, %sub22, !dbg !416
  %add24 = fadd float %sub20, %mul23, !dbg !417
  store float %add24, float* %y1, align 4, !dbg !418
  %35 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !419
  %z = getelementptr inbounds %struct.ATOM, %struct.ATOM* %35, i32 0, i32 2, !dbg !420
  %36 = load float, float* %z, align 4, !dbg !420
  %37 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !421
  %z25 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %37, i32 0, i32 2, !dbg !422
  %38 = load float, float* %z25, align 4, !dbg !422
  %sub26 = fsub float %36, %38, !dbg !423
  %39 = load float, float* %lambda.addr, align 4, !dbg !424
  %40 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !425
  %dz = getelementptr inbounds %struct.ATOM, %struct.ATOM* %40, i32 0, i32 26, !dbg !426
  %41 = load float, float* %dz, align 4, !dbg !426
  %42 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !427
  %dz27 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %42, i32 0, i32 26, !dbg !428
  %43 = load float, float* %dz27, align 4, !dbg !428
  %sub28 = fsub float %41, %43, !dbg !429
  %mul29 = fmul float %39, %sub28, !dbg !430
  %add30 = fadd float %sub26, %mul29, !dbg !431
  store float %add30, float* %z1, align 4, !dbg !432
  %44 = load float, float* %x1, align 4, !dbg !433
  %45 = load float, float* %x1, align 4, !dbg !434
  %mul31 = fmul float %44, %45, !dbg !435
  %46 = load float, float* %y1, align 4, !dbg !436
  %47 = load float, float* %y1, align 4, !dbg !437
  %mul32 = fmul float %46, %47, !dbg !438
  %add33 = fadd float %mul31, %mul32, !dbg !439
  %48 = load float, float* %z1, align 4, !dbg !440
  %49 = load float, float* %z1, align 4, !dbg !441
  %mul34 = fmul float %48, %49, !dbg !442
  %add35 = fadd float %add33, %mul34, !dbg !443
  store float %add35, float* %r, align 4, !dbg !444
  %50 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !445
  %ndiff = getelementptr inbounds %struct.BOND, %struct.BOND* %50, i32 0, i32 6, !dbg !447
  %51 = load i32, i32* %ndiff, align 4, !dbg !447
  %cmp36 = icmp sgt i32 %51, 0, !dbg !448
  br i1 %cmp36, label %if.then38, label %if.else, !dbg !449

if.then38:                                        ; preds = %if.then15
  %52 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !450
  %k = getelementptr inbounds %struct.BOND, %struct.BOND* %52, i32 0, i32 3, !dbg !452
  %53 = load float, float* %k, align 4, !dbg !452
  %54 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !453
  %dk = getelementptr inbounds %struct.BOND, %struct.BOND* %54, i32 0, i32 5, !dbg !454
  %55 = load float, float* %dk, align 4, !dbg !454
  %56 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !455
  %ndiff39 = getelementptr inbounds %struct.BOND, %struct.BOND* %56, i32 0, i32 6, !dbg !456
  %57 = load i32, i32* %ndiff39, align 4, !dbg !456
  %conv40 = sitofp i32 %57 to float, !dbg !455
  %div = fdiv float %55, %conv40, !dbg !457
  %add41 = fadd float %53, %div, !dbg !458
  store float %add41, float* %keff, align 4, !dbg !459
  %58 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !460
  %length = getelementptr inbounds %struct.BOND, %struct.BOND* %58, i32 0, i32 2, !dbg !461
  %59 = load float, float* %length, align 4, !dbg !461
  %60 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !462
  %dlength = getelementptr inbounds %struct.BOND, %struct.BOND* %60, i32 0, i32 4, !dbg !463
  %61 = load float, float* %dlength, align 4, !dbg !463
  %62 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !464
  %ndiff42 = getelementptr inbounds %struct.BOND, %struct.BOND* %62, i32 0, i32 6, !dbg !465
  %63 = load i32, i32* %ndiff42, align 4, !dbg !465
  %conv43 = sitofp i32 %63 to float, !dbg !464
  %div44 = fdiv float %61, %conv43, !dbg !466
  %add45 = fadd float %59, %div44, !dbg !467
  store float %add45, float* %length_eff, align 4, !dbg !468
  br label %if.end48, !dbg !469

if.else:                                          ; preds = %if.then15
  %64 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !470
  %k46 = getelementptr inbounds %struct.BOND, %struct.BOND* %64, i32 0, i32 3, !dbg !472
  %65 = load float, float* %k46, align 4, !dbg !472
  store float %65, float* %keff, align 4, !dbg !473
  %66 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !474
  %length47 = getelementptr inbounds %struct.BOND, %struct.BOND* %66, i32 0, i32 2, !dbg !475
  %67 = load float, float* %length47, align 4, !dbg !475
  store float %67, float* %length_eff, align 4, !dbg !476
  br label %if.end48

if.end48:                                         ; preds = %if.else, %if.then38
  %68 = load float, float* %r, align 4, !dbg !477
  %conv49 = fpext float %68 to double, !dbg !477
  %call50 = call double @sqrt(double %conv49) #1, !dbg !478
  %conv51 = fptrunc double %call50 to float, !dbg !478
  store float %conv51, float* %r, align 4, !dbg !479
  %69 = load float, float* %r, align 4, !dbg !480
  %70 = load float, float* %length_eff, align 4, !dbg !481
  %sub52 = fsub float %69, %70, !dbg !482
  store float %sub52, float* %r, align 4, !dbg !483
  %71 = load float, float* %keff, align 4, !dbg !484
  %72 = load float, float* %r, align 4, !dbg !485
  %mul53 = fmul float %71, %72, !dbg !486
  %73 = load float, float* %r, align 4, !dbg !487
  %mul54 = fmul float %mul53, %73, !dbg !488
  %74 = load float*, float** %V.addr, align 8, !dbg !489
  %75 = load float, float* %74, align 4, !dbg !490
  %add55 = fadd float %75, %mul54, !dbg !490
  store float %add55, float* %74, align 4, !dbg !490
  br label %if.end56, !dbg !491

if.end56:                                         ; preds = %if.end48, %lor.lhs.false
  %76 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !492
  %77 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !494
  %next = getelementptr inbounds %struct.BOND, %struct.BOND* %77, i32 0, i32 7, !dbg !495
  %78 = load i8*, i8** %next, align 8, !dbg !495
  %79 = bitcast i8* %78 to %struct.BOND*, !dbg !494
  %cmp57 = icmp eq %struct.BOND* %76, %79, !dbg !496
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !497

if.then59:                                        ; preds = %if.end56
  store i32 1, i32* %retval, !dbg !498
  br label %return, !dbg !498

if.end60:                                         ; preds = %if.end56
  %80 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !499
  %next61 = getelementptr inbounds %struct.BOND, %struct.BOND* %80, i32 0, i32 7, !dbg !500
  %81 = load i8*, i8** %next61, align 8, !dbg !500
  %82 = bitcast i8* %81 to %struct.BOND*, !dbg !499
  store %struct.BOND* %82, %struct.BOND** %bp, align 8, !dbg !501
  br label %while.body, !dbg !370

return:                                           ; preds = %if.then59, %if.then9, %if.then3, %if.then
  %83 = load i32, i32* %retval, !dbg !502
  ret i32 %83, !dbg !502
}

declare i32 @v_bond(...) #2

; Function Attrs: nounwind readnone
declare double @sqrt(double) #3

; Function Attrs: nounwind ssp uwtable
define i32 @do_abc(double) #0 {
entry:
  %retval = alloca i32, align 4
  %lambda.addr = alloca float, align 4
  %abcp = alloca %struct.ABC*, align 8
  %bp = alloca %struct.BOND*, align 8
  %r = alloca float, align 4
  %x1 = alloca float, align 4
  %y1 = alloca float, align 4
  %z1 = alloca float, align 4
  %x2 = alloca float, align 4
  %y2 = alloca float, align 4
  %z2 = alloca float, align 4
  %dp = alloca float, align 4
  %a1 = alloca %struct.ATOM*, align 8
  %a2 = alloca %struct.ATOM*, align 8
  %a3 = alloca %struct.ATOM*, align 8
  %lambda = fptrunc double %0 to float
  store float %lambda, float* %lambda.addr, align 4
  call void @llvm.dbg.declare(metadata float* %lambda.addr, metadata !503, metadata !186), !dbg !504
  call void @llvm.dbg.declare(metadata %struct.ABC** %abcp, metadata !505, metadata !186), !dbg !506
  call void @llvm.dbg.declare(metadata %struct.BOND** %bp, metadata !507, metadata !186), !dbg !508
  call void @llvm.dbg.declare(metadata float* %r, metadata !509, metadata !186), !dbg !510
  call void @llvm.dbg.declare(metadata float* %x1, metadata !511, metadata !186), !dbg !512
  call void @llvm.dbg.declare(metadata float* %y1, metadata !513, metadata !186), !dbg !514
  call void @llvm.dbg.declare(metadata float* %z1, metadata !515, metadata !186), !dbg !516
  call void @llvm.dbg.declare(metadata float* %x2, metadata !517, metadata !186), !dbg !518
  call void @llvm.dbg.declare(metadata float* %y2, metadata !519, metadata !186), !dbg !520
  call void @llvm.dbg.declare(metadata float* %z2, metadata !521, metadata !186), !dbg !522
  call void @llvm.dbg.declare(metadata float* %dp, metadata !523, metadata !186), !dbg !524
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1, metadata !525, metadata !186), !dbg !526
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a2, metadata !527, metadata !186), !dbg !528
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a3, metadata !529, metadata !186), !dbg !530
  %1 = load %struct.BOND*, %struct.BOND** @bond_first, align 8, !dbg !531
  store %struct.BOND* %1, %struct.BOND** %bp, align 8, !dbg !532
  br label %while.body, !dbg !533

while.body:                                       ; preds = %entry, %if.end3
  %2 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !534
  %cmp = icmp eq %struct.BOND* %2, null, !dbg !537
  br i1 %cmp, label %if.then, label %if.end, !dbg !538

if.then:                                          ; preds = %while.body
  br label %while.end, !dbg !539

if.end:                                           ; preds = %while.body
  %3 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !540
  %ndiff = getelementptr inbounds %struct.BOND, %struct.BOND* %3, i32 0, i32 6, !dbg !541
  store i32 0, i32* %ndiff, align 4, !dbg !542
  %4 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !543
  %dlength = getelementptr inbounds %struct.BOND, %struct.BOND* %4, i32 0, i32 4, !dbg !544
  store float 0.000000e+00, float* %dlength, align 4, !dbg !545
  %5 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !546
  %dk = getelementptr inbounds %struct.BOND, %struct.BOND* %5, i32 0, i32 5, !dbg !547
  store float 0.000000e+00, float* %dk, align 4, !dbg !548
  %6 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !549
  %7 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !551
  %next = getelementptr inbounds %struct.BOND, %struct.BOND* %7, i32 0, i32 7, !dbg !552
  %8 = load i8*, i8** %next, align 8, !dbg !552
  %9 = bitcast i8* %8 to %struct.BOND*, !dbg !551
  %cmp1 = icmp eq %struct.BOND* %6, %9, !dbg !553
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !554

if.then2:                                         ; preds = %if.end
  br label %while.end, !dbg !555

if.end3:                                          ; preds = %if.end
  %10 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !556
  %next4 = getelementptr inbounds %struct.BOND, %struct.BOND* %10, i32 0, i32 7, !dbg !557
  %11 = load i8*, i8** %next4, align 8, !dbg !557
  %12 = bitcast i8* %11 to %struct.BOND*, !dbg !556
  store %struct.BOND* %12, %struct.BOND** %bp, align 8, !dbg !558
  br label %while.body, !dbg !533

while.end:                                        ; preds = %if.then2, %if.then
  %13 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !559
  store %struct.ABC* %13, %struct.ABC** %abcp, align 8, !dbg !560
  br label %while.body5, !dbg !561

while.body5:                                      ; preds = %while.end, %if.end126
  %14 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !562
  %cmp6 = icmp eq %struct.ABC* %14, null, !dbg !565
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !566

if.then7:                                         ; preds = %while.body5
  br label %while.end128, !dbg !567

if.end8:                                          ; preds = %while.body5
  %15 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !568
  %b1 = getelementptr inbounds %struct.ABC, %struct.ABC* %15, i32 0, i32 8, !dbg !570
  %16 = load i8*, i8** %b1, align 8, !dbg !570
  %cmp9 = icmp eq i8* %16, null, !dbg !571
  br i1 %cmp9, label %if.then10, label %if.end16, !dbg !572

if.then10:                                        ; preds = %if.end8
  %17 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !573
  %atom1 = getelementptr inbounds %struct.ABC, %struct.ABC* %17, i32 0, i32 0, !dbg !575
  %18 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !575
  %19 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !576
  %atom2 = getelementptr inbounds %struct.ABC, %struct.ABC* %19, i32 0, i32 1, !dbg !577
  %20 = load %struct.ATOM*, %struct.ATOM** %atom2, align 8, !dbg !577
  %call = call %struct.BOND* (%struct.ATOM*, %struct.ATOM*, ...) bitcast (%struct.BOND* (...)* @get_bond_pointer to %struct.BOND* (%struct.ATOM*, %struct.ATOM*, ...)*)(%struct.ATOM* %18, %struct.ATOM* %20), !dbg !578
  %21 = bitcast %struct.BOND* %call to i8*, !dbg !578
  %22 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !579
  %b111 = getelementptr inbounds %struct.ABC, %struct.ABC* %22, i32 0, i32 8, !dbg !580
  store i8* %21, i8** %b111, align 8, !dbg !581
  %23 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !582
  %b112 = getelementptr inbounds %struct.ABC, %struct.ABC* %23, i32 0, i32 8, !dbg !584
  %24 = load i8*, i8** %b112, align 8, !dbg !584
  %cmp13 = icmp eq i8* %24, null, !dbg !585
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !586

if.then14:                                        ; preds = %if.then10
  br label %SKIP, !dbg !587

if.end15:                                         ; preds = %if.then10
  br label %if.end16, !dbg !588

if.end16:                                         ; preds = %if.end15, %if.end8
  %25 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !589
  %b2 = getelementptr inbounds %struct.ABC, %struct.ABC* %25, i32 0, i32 9, !dbg !591
  %26 = load i8*, i8** %b2, align 8, !dbg !591
  %cmp17 = icmp eq i8* %26, null, !dbg !592
  br i1 %cmp17, label %if.then18, label %if.end26, !dbg !593

if.then18:                                        ; preds = %if.end16
  %27 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !594
  %atom3 = getelementptr inbounds %struct.ABC, %struct.ABC* %27, i32 0, i32 2, !dbg !596
  %28 = load %struct.ATOM*, %struct.ATOM** %atom3, align 8, !dbg !596
  %29 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !597
  %atom219 = getelementptr inbounds %struct.ABC, %struct.ABC* %29, i32 0, i32 1, !dbg !598
  %30 = load %struct.ATOM*, %struct.ATOM** %atom219, align 8, !dbg !598
  %call20 = call %struct.BOND* (%struct.ATOM*, %struct.ATOM*, ...) bitcast (%struct.BOND* (...)* @get_bond_pointer to %struct.BOND* (%struct.ATOM*, %struct.ATOM*, ...)*)(%struct.ATOM* %28, %struct.ATOM* %30), !dbg !599
  %31 = bitcast %struct.BOND* %call20 to i8*, !dbg !599
  %32 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !600
  %b221 = getelementptr inbounds %struct.ABC, %struct.ABC* %32, i32 0, i32 9, !dbg !601
  store i8* %31, i8** %b221, align 8, !dbg !602
  %33 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !603
  %b222 = getelementptr inbounds %struct.ABC, %struct.ABC* %33, i32 0, i32 9, !dbg !605
  %34 = load i8*, i8** %b222, align 8, !dbg !605
  %cmp23 = icmp eq i8* %34, null, !dbg !606
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !607

if.then24:                                        ; preds = %if.then18
  br label %SKIP, !dbg !608

if.end25:                                         ; preds = %if.then18
  br label %if.end26, !dbg !609

if.end26:                                         ; preds = %if.end25, %if.end16
  %35 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !610
  %atom127 = getelementptr inbounds %struct.ABC, %struct.ABC* %35, i32 0, i32 0, !dbg !611
  %36 = load %struct.ATOM*, %struct.ATOM** %atom127, align 8, !dbg !611
  store %struct.ATOM* %36, %struct.ATOM** %a1, align 8, !dbg !612
  %37 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !613
  %atom228 = getelementptr inbounds %struct.ABC, %struct.ABC* %37, i32 0, i32 1, !dbg !614
  %38 = load %struct.ATOM*, %struct.ATOM** %atom228, align 8, !dbg !614
  store %struct.ATOM* %38, %struct.ATOM** %a2, align 8, !dbg !615
  %39 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !616
  %atom329 = getelementptr inbounds %struct.ABC, %struct.ABC* %39, i32 0, i32 2, !dbg !617
  %40 = load %struct.ATOM*, %struct.ATOM** %atom329, align 8, !dbg !617
  store %struct.ATOM* %40, %struct.ATOM** %a3, align 8, !dbg !618
  %41 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !619
  %x = getelementptr inbounds %struct.ATOM, %struct.ATOM* %41, i32 0, i32 0, !dbg !620
  %42 = load float, float* %x, align 4, !dbg !620
  %43 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !621
  %x30 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %43, i32 0, i32 0, !dbg !622
  %44 = load float, float* %x30, align 4, !dbg !622
  %sub = fsub float %42, %44, !dbg !623
  %45 = load float, float* %lambda.addr, align 4, !dbg !624
  %46 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !625
  %dx = getelementptr inbounds %struct.ATOM, %struct.ATOM* %46, i32 0, i32 24, !dbg !626
  %47 = load float, float* %dx, align 4, !dbg !626
  %48 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !627
  %dx31 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %48, i32 0, i32 24, !dbg !628
  %49 = load float, float* %dx31, align 4, !dbg !628
  %sub32 = fsub float %47, %49, !dbg !629
  %mul = fmul float %45, %sub32, !dbg !630
  %add = fadd float %sub, %mul, !dbg !631
  store float %add, float* %x1, align 4, !dbg !632
  %50 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !633
  %y = getelementptr inbounds %struct.ATOM, %struct.ATOM* %50, i32 0, i32 1, !dbg !634
  %51 = load float, float* %y, align 4, !dbg !634
  %52 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !635
  %y33 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %52, i32 0, i32 1, !dbg !636
  %53 = load float, float* %y33, align 4, !dbg !636
  %sub34 = fsub float %51, %53, !dbg !637
  %54 = load float, float* %lambda.addr, align 4, !dbg !638
  %55 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !639
  %dy = getelementptr inbounds %struct.ATOM, %struct.ATOM* %55, i32 0, i32 25, !dbg !640
  %56 = load float, float* %dy, align 4, !dbg !640
  %57 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !641
  %dy35 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %57, i32 0, i32 25, !dbg !642
  %58 = load float, float* %dy35, align 4, !dbg !642
  %sub36 = fsub float %56, %58, !dbg !643
  %mul37 = fmul float %54, %sub36, !dbg !644
  %add38 = fadd float %sub34, %mul37, !dbg !645
  store float %add38, float* %y1, align 4, !dbg !646
  %59 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !647
  %z = getelementptr inbounds %struct.ATOM, %struct.ATOM* %59, i32 0, i32 2, !dbg !648
  %60 = load float, float* %z, align 4, !dbg !648
  %61 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !649
  %z39 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %61, i32 0, i32 2, !dbg !650
  %62 = load float, float* %z39, align 4, !dbg !650
  %sub40 = fsub float %60, %62, !dbg !651
  %63 = load float, float* %lambda.addr, align 4, !dbg !652
  %64 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !653
  %dz = getelementptr inbounds %struct.ATOM, %struct.ATOM* %64, i32 0, i32 26, !dbg !654
  %65 = load float, float* %dz, align 4, !dbg !654
  %66 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !655
  %dz41 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %66, i32 0, i32 26, !dbg !656
  %67 = load float, float* %dz41, align 4, !dbg !656
  %sub42 = fsub float %65, %67, !dbg !657
  %mul43 = fmul float %63, %sub42, !dbg !658
  %add44 = fadd float %sub40, %mul43, !dbg !659
  store float %add44, float* %z1, align 4, !dbg !660
  %68 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !661
  %x45 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %68, i32 0, i32 0, !dbg !662
  %69 = load float, float* %x45, align 4, !dbg !662
  %70 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !663
  %x46 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %70, i32 0, i32 0, !dbg !664
  %71 = load float, float* %x46, align 4, !dbg !664
  %sub47 = fsub float %69, %71, !dbg !665
  %72 = load float, float* %lambda.addr, align 4, !dbg !666
  %73 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !667
  %dx48 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %73, i32 0, i32 24, !dbg !668
  %74 = load float, float* %dx48, align 4, !dbg !668
  %75 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !669
  %dx49 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %75, i32 0, i32 24, !dbg !670
  %76 = load float, float* %dx49, align 4, !dbg !670
  %sub50 = fsub float %74, %76, !dbg !671
  %mul51 = fmul float %72, %sub50, !dbg !672
  %add52 = fadd float %sub47, %mul51, !dbg !673
  store float %add52, float* %x2, align 4, !dbg !674
  %77 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !675
  %y53 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %77, i32 0, i32 1, !dbg !676
  %78 = load float, float* %y53, align 4, !dbg !676
  %79 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !677
  %y54 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %79, i32 0, i32 1, !dbg !678
  %80 = load float, float* %y54, align 4, !dbg !678
  %sub55 = fsub float %78, %80, !dbg !679
  %81 = load float, float* %lambda.addr, align 4, !dbg !680
  %82 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !681
  %dy56 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %82, i32 0, i32 25, !dbg !682
  %83 = load float, float* %dy56, align 4, !dbg !682
  %84 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !683
  %dy57 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %84, i32 0, i32 25, !dbg !684
  %85 = load float, float* %dy57, align 4, !dbg !684
  %sub58 = fsub float %83, %85, !dbg !685
  %mul59 = fmul float %81, %sub58, !dbg !686
  %add60 = fadd float %sub55, %mul59, !dbg !687
  store float %add60, float* %y2, align 4, !dbg !688
  %86 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !689
  %z61 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %86, i32 0, i32 2, !dbg !690
  %87 = load float, float* %z61, align 4, !dbg !690
  %88 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !691
  %z62 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %88, i32 0, i32 2, !dbg !692
  %89 = load float, float* %z62, align 4, !dbg !692
  %sub63 = fsub float %87, %89, !dbg !693
  %90 = load float, float* %lambda.addr, align 4, !dbg !694
  %91 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !695
  %dz64 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %91, i32 0, i32 26, !dbg !696
  %92 = load float, float* %dz64, align 4, !dbg !696
  %93 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !697
  %dz65 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %93, i32 0, i32 26, !dbg !698
  %94 = load float, float* %dz65, align 4, !dbg !698
  %sub66 = fsub float %92, %94, !dbg !699
  %mul67 = fmul float %90, %sub66, !dbg !700
  %add68 = fadd float %sub63, %mul67, !dbg !701
  store float %add68, float* %z2, align 4, !dbg !702
  %95 = load float, float* %x1, align 4, !dbg !703
  %96 = load float, float* %x2, align 4, !dbg !704
  %mul69 = fmul float %95, %96, !dbg !705
  %97 = load float, float* %y1, align 4, !dbg !706
  %98 = load float, float* %y2, align 4, !dbg !707
  %mul70 = fmul float %97, %98, !dbg !708
  %add71 = fadd float %mul69, %mul70, !dbg !709
  %99 = load float, float* %z1, align 4, !dbg !710
  %100 = load float, float* %z2, align 4, !dbg !711
  %mul72 = fmul float %99, %100, !dbg !712
  %add73 = fadd float %add71, %mul72, !dbg !713
  store float %add73, float* %dp, align 4, !dbg !714
  %101 = load float, float* %x1, align 4, !dbg !715
  %102 = load float, float* %x1, align 4, !dbg !716
  %mul74 = fmul float %101, %102, !dbg !717
  %103 = load float, float* %y1, align 4, !dbg !718
  %104 = load float, float* %y1, align 4, !dbg !719
  %mul75 = fmul float %103, %104, !dbg !720
  %add76 = fadd float %mul74, %mul75, !dbg !721
  %105 = load float, float* %z1, align 4, !dbg !722
  %106 = load float, float* %z1, align 4, !dbg !723
  %mul77 = fmul float %105, %106, !dbg !724
  %add78 = fadd float %add76, %mul77, !dbg !725
  %107 = load float, float* %x2, align 4, !dbg !726
  %108 = load float, float* %x2, align 4, !dbg !727
  %mul79 = fmul float %107, %108, !dbg !728
  %109 = load float, float* %y2, align 4, !dbg !729
  %110 = load float, float* %y2, align 4, !dbg !730
  %mul80 = fmul float %109, %110, !dbg !731
  %add81 = fadd float %mul79, %mul80, !dbg !732
  %111 = load float, float* %z2, align 4, !dbg !733
  %112 = load float, float* %z2, align 4, !dbg !734
  %mul82 = fmul float %111, %112, !dbg !735
  %add83 = fadd float %add81, %mul82, !dbg !736
  %mul84 = fmul float %add78, %add83, !dbg !737
  store float %mul84, float* %r, align 4, !dbg !738
  %113 = load float, float* %r, align 4, !dbg !739
  %conv = fpext float %113 to double, !dbg !739
  %call85 = call double @sqrt(double %conv) #1, !dbg !740
  %conv86 = fptrunc double %call85 to float, !dbg !740
  store float %conv86, float* %r, align 4, !dbg !741
  %114 = load float, float* %dp, align 4, !dbg !742
  %115 = load float, float* %r, align 4, !dbg !743
  %div = fdiv float %114, %115, !dbg !744
  store float %div, float* %dp, align 4, !dbg !745
  %116 = load float, float* %dp, align 4, !dbg !746
  %conv87 = fpext float %116 to double, !dbg !746
  %cmp88 = fcmp ogt double %conv87, 1.000000e+00, !dbg !748
  br i1 %cmp88, label %if.then90, label %if.end91, !dbg !749

if.then90:                                        ; preds = %if.end26
  store float 1.000000e+00, float* %dp, align 4, !dbg !750
  br label %if.end91, !dbg !751

if.end91:                                         ; preds = %if.then90, %if.end26
  %117 = load float, float* %dp, align 4, !dbg !752
  %conv92 = fpext float %117 to double, !dbg !752
  %cmp93 = fcmp olt double %conv92, -1.000000e+00, !dbg !754
  br i1 %cmp93, label %if.then95, label %if.end96, !dbg !755

if.then95:                                        ; preds = %if.end91
  store float -1.000000e+00, float* %dp, align 4, !dbg !756
  br label %if.end96, !dbg !757

if.end96:                                         ; preds = %if.then95, %if.end91
  %118 = load float, float* %dp, align 4, !dbg !758
  %conv97 = fpext float %118 to double, !dbg !758
  %call98 = call double @acos(double %conv97) #1, !dbg !759
  %conv99 = fptrunc double %call98 to float, !dbg !759
  store float %conv99, float* %dp, align 4, !dbg !760
  %119 = load float, float* %dp, align 4, !dbg !761
  %120 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !762
  %theta = getelementptr inbounds %struct.ABC, %struct.ABC* %120, i32 0, i32 3, !dbg !763
  %121 = load float, float* %theta, align 4, !dbg !763
  %sub100 = fsub float %119, %121, !dbg !764
  store float %sub100, float* %r, align 4, !dbg !765
  %122 = load float, float* %r, align 4, !dbg !766
  %123 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !767
  %thetazero = getelementptr inbounds %struct.ABC, %struct.ABC* %123, i32 0, i32 4, !dbg !768
  %124 = load float, float* %thetazero, align 4, !dbg !768
  %125 = load float, float* %r, align 4, !dbg !769
  %sub101 = fsub float %124, %125, !dbg !770
  %mul102 = fmul float %122, %sub101, !dbg !771
  store float %mul102, float* %r, align 4, !dbg !772
  %126 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !773
  %b1103 = getelementptr inbounds %struct.ABC, %struct.ABC* %126, i32 0, i32 8, !dbg !774
  %127 = load i8*, i8** %b1103, align 8, !dbg !774
  %128 = bitcast i8* %127 to %struct.BOND*, !dbg !773
  store %struct.BOND* %128, %struct.BOND** %bp, align 8, !dbg !775
  %129 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !776
  %ndiff104 = getelementptr inbounds %struct.BOND, %struct.BOND* %129, i32 0, i32 6, !dbg !777
  %130 = load i32, i32* %ndiff104, align 4, !dbg !778
  %add105 = add nsw i32 %130, 1, !dbg !778
  store i32 %add105, i32* %ndiff104, align 4, !dbg !778
  %131 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !779
  %dr = getelementptr inbounds %struct.ABC, %struct.ABC* %131, i32 0, i32 5, !dbg !780
  %132 = load float, float* %dr, align 4, !dbg !780
  %133 = load float, float* %r, align 4, !dbg !781
  %mul106 = fmul float %132, %133, !dbg !782
  %134 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !783
  %dlength107 = getelementptr inbounds %struct.BOND, %struct.BOND* %134, i32 0, i32 4, !dbg !784
  %135 = load float, float* %dlength107, align 4, !dbg !785
  %add108 = fadd float %135, %mul106, !dbg !785
  store float %add108, float* %dlength107, align 4, !dbg !785
  %136 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !786
  %dk1 = getelementptr inbounds %struct.ABC, %struct.ABC* %136, i32 0, i32 6, !dbg !787
  %137 = load float, float* %dk1, align 4, !dbg !787
  %138 = load float, float* %r, align 4, !dbg !788
  %mul109 = fmul float %137, %138, !dbg !789
  %139 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !790
  %dk110 = getelementptr inbounds %struct.BOND, %struct.BOND* %139, i32 0, i32 5, !dbg !791
  %140 = load float, float* %dk110, align 4, !dbg !792
  %add111 = fadd float %140, %mul109, !dbg !792
  store float %add111, float* %dk110, align 4, !dbg !792
  %141 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !793
  %b2112 = getelementptr inbounds %struct.ABC, %struct.ABC* %141, i32 0, i32 9, !dbg !794
  %142 = load i8*, i8** %b2112, align 8, !dbg !794
  %143 = bitcast i8* %142 to %struct.BOND*, !dbg !793
  store %struct.BOND* %143, %struct.BOND** %bp, align 8, !dbg !795
  %144 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !796
  %ndiff113 = getelementptr inbounds %struct.BOND, %struct.BOND* %144, i32 0, i32 6, !dbg !797
  %145 = load i32, i32* %ndiff113, align 4, !dbg !798
  %add114 = add nsw i32 %145, 1, !dbg !798
  store i32 %add114, i32* %ndiff113, align 4, !dbg !798
  %146 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !799
  %dr115 = getelementptr inbounds %struct.ABC, %struct.ABC* %146, i32 0, i32 5, !dbg !800
  %147 = load float, float* %dr115, align 4, !dbg !800
  %148 = load float, float* %r, align 4, !dbg !801
  %mul116 = fmul float %147, %148, !dbg !802
  %149 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !803
  %dlength117 = getelementptr inbounds %struct.BOND, %struct.BOND* %149, i32 0, i32 4, !dbg !804
  %150 = load float, float* %dlength117, align 4, !dbg !805
  %add118 = fadd float %150, %mul116, !dbg !805
  store float %add118, float* %dlength117, align 4, !dbg !805
  %151 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !806
  %dk2 = getelementptr inbounds %struct.ABC, %struct.ABC* %151, i32 0, i32 7, !dbg !807
  %152 = load float, float* %dk2, align 4, !dbg !807
  %153 = load float, float* %r, align 4, !dbg !808
  %mul119 = fmul float %152, %153, !dbg !809
  %154 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !810
  %dk120 = getelementptr inbounds %struct.BOND, %struct.BOND* %154, i32 0, i32 5, !dbg !811
  %155 = load float, float* %dk120, align 4, !dbg !812
  %add121 = fadd float %155, %mul119, !dbg !812
  store float %add121, float* %dk120, align 4, !dbg !812
  br label %SKIP, !dbg !810

SKIP:                                             ; preds = %if.end96, %if.then24, %if.then14
  %156 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !813
  %157 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !815
  %next122 = getelementptr inbounds %struct.ABC, %struct.ABC* %157, i32 0, i32 10, !dbg !816
  %158 = load i8*, i8** %next122, align 8, !dbg !816
  %159 = bitcast i8* %158 to %struct.ABC*, !dbg !815
  %cmp123 = icmp eq %struct.ABC* %156, %159, !dbg !817
  br i1 %cmp123, label %if.then125, label %if.end126, !dbg !818

if.then125:                                       ; preds = %SKIP
  br label %while.end128, !dbg !819

if.end126:                                        ; preds = %SKIP
  %160 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !820
  %next127 = getelementptr inbounds %struct.ABC, %struct.ABC* %160, i32 0, i32 10, !dbg !821
  %161 = load i8*, i8** %next127, align 8, !dbg !821
  %162 = bitcast i8* %161 to %struct.ABC*, !dbg !820
  store %struct.ABC* %162, %struct.ABC** %abcp, align 8, !dbg !822
  br label %while.body5, !dbg !561

while.end128:                                     ; preds = %if.then125, %if.then7
  %163 = load i32, i32* %retval, !dbg !823
  ret i32 %163, !dbg !823
}

declare %struct.BOND* @get_bond_pointer(...) #2

; Function Attrs: nounwind readnone
declare double @acos(double) #3

; Function Attrs: nounwind ssp uwtable
define i32 @f_abc(double) #0 {
entry:
  %retval = alloca i32, align 4
  %lambda.addr = alloca float, align 4
  %abcp = alloca %struct.ABC*, align 8
  %bp = alloca %struct.BOND*, align 8
  %r = alloca float, align 4
  %k = alloca float, align 4
  %ux1 = alloca float, align 4
  %uy1 = alloca float, align 4
  %uz1 = alloca float, align 4
  %ux2 = alloca float, align 4
  %uy2 = alloca float, align 4
  %uz2 = alloca float, align 4
  %rb = alloca float, align 4
  %ubx = alloca float, align 4
  %uby = alloca float, align 4
  %ubz = alloca float, align 4
  %a1 = alloca %struct.ATOM*, align 8
  %a2 = alloca %struct.ATOM*, align 8
  %a3 = alloca %struct.ATOM*, align 8
  %x1 = alloca float, align 4
  %y1 = alloca float, align 4
  %z1 = alloca float, align 4
  %x2 = alloca float, align 4
  %y2 = alloca float, align 4
  %z2 = alloca float, align 4
  %r1 = alloca float, align 4
  %r2 = alloca float, align 4
  %dtheta = alloca float, align 4
  %dp = alloca float, align 4
  %drb = alloca float, align 4
  %r11 = alloca float, align 4
  %r22 = alloca float, align 4
  %sdth = alloca float, align 4
  %length_eff = alloca float, align 4
  %ddtheta = alloca float, align 4
  %lambda = fptrunc double %0 to float
  store float %lambda, float* %lambda.addr, align 4
  call void @llvm.dbg.declare(metadata float* %lambda.addr, metadata !824, metadata !186), !dbg !825
  call void @llvm.dbg.declare(metadata %struct.ABC** %abcp, metadata !826, metadata !186), !dbg !827
  call void @llvm.dbg.declare(metadata %struct.BOND** %bp, metadata !828, metadata !186), !dbg !829
  call void @llvm.dbg.declare(metadata float* %r, metadata !830, metadata !186), !dbg !831
  call void @llvm.dbg.declare(metadata float* %k, metadata !832, metadata !186), !dbg !833
  call void @llvm.dbg.declare(metadata float* %ux1, metadata !834, metadata !186), !dbg !835
  call void @llvm.dbg.declare(metadata float* %uy1, metadata !836, metadata !186), !dbg !837
  call void @llvm.dbg.declare(metadata float* %uz1, metadata !838, metadata !186), !dbg !839
  call void @llvm.dbg.declare(metadata float* %ux2, metadata !840, metadata !186), !dbg !841
  call void @llvm.dbg.declare(metadata float* %uy2, metadata !842, metadata !186), !dbg !843
  call void @llvm.dbg.declare(metadata float* %uz2, metadata !844, metadata !186), !dbg !845
  call void @llvm.dbg.declare(metadata float* %rb, metadata !846, metadata !186), !dbg !847
  call void @llvm.dbg.declare(metadata float* %ubx, metadata !848, metadata !186), !dbg !849
  call void @llvm.dbg.declare(metadata float* %uby, metadata !850, metadata !186), !dbg !851
  call void @llvm.dbg.declare(metadata float* %ubz, metadata !852, metadata !186), !dbg !853
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1, metadata !854, metadata !186), !dbg !855
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a2, metadata !856, metadata !186), !dbg !857
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a3, metadata !858, metadata !186), !dbg !859
  call void @llvm.dbg.declare(metadata float* %x1, metadata !860, metadata !186), !dbg !861
  call void @llvm.dbg.declare(metadata float* %y1, metadata !862, metadata !186), !dbg !863
  call void @llvm.dbg.declare(metadata float* %z1, metadata !864, metadata !186), !dbg !865
  call void @llvm.dbg.declare(metadata float* %x2, metadata !866, metadata !186), !dbg !867
  call void @llvm.dbg.declare(metadata float* %y2, metadata !868, metadata !186), !dbg !869
  call void @llvm.dbg.declare(metadata float* %z2, metadata !870, metadata !186), !dbg !871
  call void @llvm.dbg.declare(metadata float* %r1, metadata !872, metadata !186), !dbg !873
  call void @llvm.dbg.declare(metadata float* %r2, metadata !874, metadata !186), !dbg !875
  call void @llvm.dbg.declare(metadata float* %dtheta, metadata !876, metadata !186), !dbg !877
  call void @llvm.dbg.declare(metadata float* %dp, metadata !878, metadata !186), !dbg !879
  call void @llvm.dbg.declare(metadata float* %drb, metadata !880, metadata !186), !dbg !881
  call void @llvm.dbg.declare(metadata float* %r11, metadata !882, metadata !186), !dbg !883
  call void @llvm.dbg.declare(metadata float* %r22, metadata !884, metadata !186), !dbg !885
  call void @llvm.dbg.declare(metadata float* %sdth, metadata !886, metadata !186), !dbg !887
  call void @llvm.dbg.declare(metadata float* %length_eff, metadata !888, metadata !186), !dbg !889
  call void @llvm.dbg.declare(metadata float* %ddtheta, metadata !890, metadata !186), !dbg !891
  %1 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !892
  store %struct.ABC* %1, %struct.ABC** %abcp, align 8, !dbg !893
  %2 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !894
  %cmp = icmp eq %struct.ABC* %2, null, !dbg !896
  br i1 %cmp, label %if.then, label %if.end, !dbg !897

if.then:                                          ; preds = %entry
  %3 = load float, float* %lambda.addr, align 4, !dbg !898
  %conv = fpext float %3 to double, !dbg !898
  %call = call i32 (double, ...) bitcast (i32 (...)* @f_bond to i32 (double, ...)*)(double %conv), !dbg !900
  store i32 %call, i32* %retval, !dbg !901
  br label %while.end393, !dbg !901

if.end:                                           ; preds = %entry
  %4 = load %struct.BOND*, %struct.BOND** @bond_first, align 8, !dbg !902
  store %struct.BOND* %4, %struct.BOND** %bp, align 8, !dbg !903
  %5 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !904
  %cmp1 = icmp eq %struct.BOND* %5, null, !dbg !906
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !907

if.then3:                                         ; preds = %if.end
  store i32 1, i32* %retval, !dbg !908
  br label %while.end393, !dbg !908

if.end4:                                          ; preds = %if.end
  %6 = load float, float* %lambda.addr, align 4, !dbg !909
  %conv5 = fpext float %6 to double, !dbg !909
  %call6 = call i32 @do_abc(double %conv5), !dbg !910
  br label %while.body, !dbg !911

while.body:                                       ; preds = %if.end4, %if.end101
  %7 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !912
  %cmp7 = icmp eq %struct.BOND* %7, null, !dbg !915
  br i1 %cmp7, label %if.then9, label %if.end10, !dbg !916

if.then9:                                         ; preds = %while.body
  br label %while.end, !dbg !917

if.end10:                                         ; preds = %while.body
  %8 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !918
  %ndiff = getelementptr inbounds %struct.BOND, %struct.BOND* %8, i32 0, i32 6, !dbg !920
  %9 = load i32, i32* %ndiff, align 4, !dbg !920
  %cmp11 = icmp eq i32 %9, 0, !dbg !921
  br i1 %cmp11, label %if.then13, label %if.else, !dbg !922

if.then13:                                        ; preds = %if.end10
  %10 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !923
  %k14 = getelementptr inbounds %struct.BOND, %struct.BOND* %10, i32 0, i32 3, !dbg !925
  %11 = load float, float* %k14, align 4, !dbg !925
  store float %11, float* %k, align 4, !dbg !926
  %12 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !927
  %length = getelementptr inbounds %struct.BOND, %struct.BOND* %12, i32 0, i32 2, !dbg !928
  %13 = load float, float* %length, align 4, !dbg !928
  store float %13, float* %length_eff, align 4, !dbg !929
  br label %if.end23, !dbg !930

if.else:                                          ; preds = %if.end10
  %14 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !931
  %k15 = getelementptr inbounds %struct.BOND, %struct.BOND* %14, i32 0, i32 3, !dbg !933
  %15 = load float, float* %k15, align 4, !dbg !933
  %16 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !934
  %dk = getelementptr inbounds %struct.BOND, %struct.BOND* %16, i32 0, i32 5, !dbg !935
  %17 = load float, float* %dk, align 4, !dbg !935
  %18 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !936
  %ndiff16 = getelementptr inbounds %struct.BOND, %struct.BOND* %18, i32 0, i32 6, !dbg !937
  %19 = load i32, i32* %ndiff16, align 4, !dbg !937
  %conv17 = sitofp i32 %19 to float, !dbg !936
  %div = fdiv float %17, %conv17, !dbg !938
  %add = fadd float %15, %div, !dbg !939
  store float %add, float* %k, align 4, !dbg !940
  %20 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !941
  %length18 = getelementptr inbounds %struct.BOND, %struct.BOND* %20, i32 0, i32 2, !dbg !942
  %21 = load float, float* %length18, align 4, !dbg !942
  %22 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !943
  %dlength = getelementptr inbounds %struct.BOND, %struct.BOND* %22, i32 0, i32 4, !dbg !944
  %23 = load float, float* %dlength, align 4, !dbg !944
  %24 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !945
  %ndiff19 = getelementptr inbounds %struct.BOND, %struct.BOND* %24, i32 0, i32 6, !dbg !946
  %25 = load i32, i32* %ndiff19, align 4, !dbg !946
  %conv20 = sitofp i32 %25 to float, !dbg !945
  %div21 = fdiv float %23, %conv20, !dbg !947
  %add22 = fadd float %21, %div21, !dbg !948
  store float %add22, float* %length_eff, align 4, !dbg !949
  br label %if.end23

if.end23:                                         ; preds = %if.else, %if.then13
  %26 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !950
  %atom1 = getelementptr inbounds %struct.BOND, %struct.BOND* %26, i32 0, i32 0, !dbg !951
  %27 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !951
  store %struct.ATOM* %27, %struct.ATOM** %a1, align 8, !dbg !952
  %28 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !953
  %atom2 = getelementptr inbounds %struct.BOND, %struct.BOND* %28, i32 0, i32 1, !dbg !954
  %29 = load %struct.ATOM*, %struct.ATOM** %atom2, align 8, !dbg !954
  store %struct.ATOM* %29, %struct.ATOM** %a2, align 8, !dbg !955
  %30 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !956
  %active = getelementptr inbounds %struct.ATOM, %struct.ATOM* %30, i32 0, i32 16, !dbg !958
  %31 = load i8, i8* %active, align 1, !dbg !958
  %conv24 = sext i8 %31 to i32, !dbg !956
  %tobool = icmp ne i32 %conv24, 0, !dbg !956
  br i1 %tobool, label %if.then28, label %lor.lhs.false, !dbg !959

lor.lhs.false:                                    ; preds = %if.end23
  %32 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !960
  %active25 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %32, i32 0, i32 16, !dbg !961
  %33 = load i8, i8* %active25, align 1, !dbg !961
  %conv26 = sext i8 %33 to i32, !dbg !960
  %tobool27 = icmp ne i32 %conv26, 0, !dbg !960
  br i1 %tobool27, label %if.then28, label %if.end74, !dbg !962

if.then28:                                        ; preds = %lor.lhs.false, %if.end23
  %34 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !963
  %x = getelementptr inbounds %struct.ATOM, %struct.ATOM* %34, i32 0, i32 0, !dbg !965
  %35 = load float, float* %x, align 4, !dbg !965
  %36 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !966
  %x29 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %36, i32 0, i32 0, !dbg !967
  %37 = load float, float* %x29, align 4, !dbg !967
  %sub = fsub float %35, %37, !dbg !968
  %38 = load float, float* %lambda.addr, align 4, !dbg !969
  %39 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !970
  %dx = getelementptr inbounds %struct.ATOM, %struct.ATOM* %39, i32 0, i32 24, !dbg !971
  %40 = load float, float* %dx, align 4, !dbg !971
  %41 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !972
  %dx30 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %41, i32 0, i32 24, !dbg !973
  %42 = load float, float* %dx30, align 4, !dbg !973
  %sub31 = fsub float %40, %42, !dbg !974
  %mul = fmul float %38, %sub31, !dbg !975
  %add32 = fadd float %sub, %mul, !dbg !976
  store float %add32, float* %x1, align 4, !dbg !977
  %43 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !978
  %y = getelementptr inbounds %struct.ATOM, %struct.ATOM* %43, i32 0, i32 1, !dbg !979
  %44 = load float, float* %y, align 4, !dbg !979
  %45 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !980
  %y33 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %45, i32 0, i32 1, !dbg !981
  %46 = load float, float* %y33, align 4, !dbg !981
  %sub34 = fsub float %44, %46, !dbg !982
  %47 = load float, float* %lambda.addr, align 4, !dbg !983
  %48 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !984
  %dy = getelementptr inbounds %struct.ATOM, %struct.ATOM* %48, i32 0, i32 25, !dbg !985
  %49 = load float, float* %dy, align 4, !dbg !985
  %50 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !986
  %dy35 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %50, i32 0, i32 25, !dbg !987
  %51 = load float, float* %dy35, align 4, !dbg !987
  %sub36 = fsub float %49, %51, !dbg !988
  %mul37 = fmul float %47, %sub36, !dbg !989
  %add38 = fadd float %sub34, %mul37, !dbg !990
  store float %add38, float* %y1, align 4, !dbg !991
  %52 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !992
  %z = getelementptr inbounds %struct.ATOM, %struct.ATOM* %52, i32 0, i32 2, !dbg !993
  %53 = load float, float* %z, align 4, !dbg !993
  %54 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !994
  %z39 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %54, i32 0, i32 2, !dbg !995
  %55 = load float, float* %z39, align 4, !dbg !995
  %sub40 = fsub float %53, %55, !dbg !996
  %56 = load float, float* %lambda.addr, align 4, !dbg !997
  %57 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !998
  %dz = getelementptr inbounds %struct.ATOM, %struct.ATOM* %57, i32 0, i32 26, !dbg !999
  %58 = load float, float* %dz, align 4, !dbg !999
  %59 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1000
  %dz41 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %59, i32 0, i32 26, !dbg !1001
  %60 = load float, float* %dz41, align 4, !dbg !1001
  %sub42 = fsub float %58, %60, !dbg !1002
  %mul43 = fmul float %56, %sub42, !dbg !1003
  %add44 = fadd float %sub40, %mul43, !dbg !1004
  store float %add44, float* %z1, align 4, !dbg !1005
  %61 = load float, float* %x1, align 4, !dbg !1006
  %62 = load float, float* %x1, align 4, !dbg !1007
  %mul45 = fmul float %61, %62, !dbg !1008
  %63 = load float, float* %y1, align 4, !dbg !1009
  %64 = load float, float* %y1, align 4, !dbg !1010
  %mul46 = fmul float %63, %64, !dbg !1011
  %add47 = fadd float %mul45, %mul46, !dbg !1012
  %65 = load float, float* %z1, align 4, !dbg !1013
  %66 = load float, float* %z1, align 4, !dbg !1014
  %mul48 = fmul float %65, %66, !dbg !1015
  %add49 = fadd float %add47, %mul48, !dbg !1016
  store float %add49, float* %dp, align 4, !dbg !1017
  %67 = load float, float* %dp, align 4, !dbg !1018
  %conv50 = fpext float %67 to double, !dbg !1018
  %cmp51 = fcmp olt double %conv50, 1.000000e-15, !dbg !1020
  br i1 %cmp51, label %if.then53, label %if.else54, !dbg !1021

if.then53:                                        ; preds = %if.then28
  store float 0.000000e+00, float* %rb, align 4, !dbg !1022
  store float 1.000000e+00, float* %ubx, align 4, !dbg !1024
  store float 0.000000e+00, float* %uby, align 4, !dbg !1025
  store float 0.000000e+00, float* %ubz, align 4, !dbg !1026
  br label %if.end61, !dbg !1027

if.else54:                                        ; preds = %if.then28
  %68 = load float, float* %dp, align 4, !dbg !1028
  %conv55 = fpext float %68 to double, !dbg !1028
  %call56 = call double @sqrt(double %conv55) #1, !dbg !1030
  %conv57 = fptrunc double %call56 to float, !dbg !1030
  store float %conv57, float* %rb, align 4, !dbg !1031
  %69 = load float, float* %x1, align 4, !dbg !1032
  %70 = load float, float* %rb, align 4, !dbg !1033
  %div58 = fdiv float %69, %70, !dbg !1034
  store float %div58, float* %ubx, align 4, !dbg !1035
  %71 = load float, float* %y1, align 4, !dbg !1036
  %72 = load float, float* %rb, align 4, !dbg !1037
  %div59 = fdiv float %71, %72, !dbg !1038
  store float %div59, float* %uby, align 4, !dbg !1039
  %73 = load float, float* %z1, align 4, !dbg !1040
  %74 = load float, float* %rb, align 4, !dbg !1041
  %div60 = fdiv float %73, %74, !dbg !1042
  store float %div60, float* %ubz, align 4, !dbg !1043
  br label %if.end61

if.end61:                                         ; preds = %if.else54, %if.then53
  %75 = load float, float* %k, align 4, !dbg !1044
  %mul62 = fmul float 2.000000e+00, %75, !dbg !1045
  %76 = load float, float* %rb, align 4, !dbg !1046
  %77 = load float, float* %length_eff, align 4, !dbg !1047
  %sub63 = fsub float %76, %77, !dbg !1048
  %mul64 = fmul float %mul62, %sub63, !dbg !1049
  %78 = load float, float* %ubx, align 4, !dbg !1050
  %mul65 = fmul float %mul64, %78, !dbg !1051
  store float %mul65, float* %ubx, align 4, !dbg !1052
  %79 = load float, float* %k, align 4, !dbg !1053
  %mul66 = fmul float 2.000000e+00, %79, !dbg !1054
  %80 = load float, float* %rb, align 4, !dbg !1055
  %81 = load float, float* %length_eff, align 4, !dbg !1056
  %sub67 = fsub float %80, %81, !dbg !1057
  %mul68 = fmul float %mul66, %sub67, !dbg !1058
  %82 = load float, float* %uby, align 4, !dbg !1059
  %mul69 = fmul float %mul68, %82, !dbg !1060
  store float %mul69, float* %uby, align 4, !dbg !1061
  %83 = load float, float* %k, align 4, !dbg !1062
  %mul70 = fmul float 2.000000e+00, %83, !dbg !1063
  %84 = load float, float* %rb, align 4, !dbg !1064
  %85 = load float, float* %length_eff, align 4, !dbg !1065
  %sub71 = fsub float %84, %85, !dbg !1066
  %mul72 = fmul float %mul70, %sub71, !dbg !1067
  %86 = load float, float* %ubz, align 4, !dbg !1068
  %mul73 = fmul float %mul72, %86, !dbg !1069
  store float %mul73, float* %ubz, align 4, !dbg !1070
  br label %if.end74, !dbg !1071

if.end74:                                         ; preds = %if.end61, %lor.lhs.false
  %87 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1072
  %active75 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %87, i32 0, i32 16, !dbg !1074
  %88 = load i8, i8* %active75, align 1, !dbg !1074
  %tobool76 = icmp ne i8 %88, 0, !dbg !1072
  br i1 %tobool76, label %if.then77, label %if.end84, !dbg !1075

if.then77:                                        ; preds = %if.end74
  %89 = load float, float* %ubx, align 4, !dbg !1076
  %conv78 = fpext float %89 to double, !dbg !1076
  %90 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1078
  %fx = getelementptr inbounds %struct.ATOM, %struct.ATOM* %90, i32 0, i32 4, !dbg !1079
  %91 = load double, double* %fx, align 8, !dbg !1080
  %sub79 = fsub double %91, %conv78, !dbg !1080
  store double %sub79, double* %fx, align 8, !dbg !1080
  %92 = load float, float* %uby, align 4, !dbg !1081
  %conv80 = fpext float %92 to double, !dbg !1081
  %93 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1082
  %fy = getelementptr inbounds %struct.ATOM, %struct.ATOM* %93, i32 0, i32 5, !dbg !1083
  %94 = load double, double* %fy, align 8, !dbg !1084
  %sub81 = fsub double %94, %conv80, !dbg !1084
  store double %sub81, double* %fy, align 8, !dbg !1084
  %95 = load float, float* %ubz, align 4, !dbg !1085
  %conv82 = fpext float %95 to double, !dbg !1085
  %96 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1086
  %fz = getelementptr inbounds %struct.ATOM, %struct.ATOM* %96, i32 0, i32 6, !dbg !1087
  %97 = load double, double* %fz, align 8, !dbg !1088
  %sub83 = fsub double %97, %conv82, !dbg !1088
  store double %sub83, double* %fz, align 8, !dbg !1088
  br label %if.end84, !dbg !1089

if.end84:                                         ; preds = %if.then77, %if.end74
  %98 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1090
  %active85 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %98, i32 0, i32 16, !dbg !1092
  %99 = load i8, i8* %active85, align 1, !dbg !1092
  %tobool86 = icmp ne i8 %99, 0, !dbg !1090
  br i1 %tobool86, label %if.then87, label %if.end97, !dbg !1093

if.then87:                                        ; preds = %if.end84
  %100 = load float, float* %ubx, align 4, !dbg !1094
  %conv88 = fpext float %100 to double, !dbg !1094
  %101 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1096
  %fx89 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %101, i32 0, i32 4, !dbg !1097
  %102 = load double, double* %fx89, align 8, !dbg !1098
  %add90 = fadd double %102, %conv88, !dbg !1098
  store double %add90, double* %fx89, align 8, !dbg !1098
  %103 = load float, float* %uby, align 4, !dbg !1099
  %conv91 = fpext float %103 to double, !dbg !1099
  %104 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1100
  %fy92 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %104, i32 0, i32 5, !dbg !1101
  %105 = load double, double* %fy92, align 8, !dbg !1102
  %add93 = fadd double %105, %conv91, !dbg !1102
  store double %add93, double* %fy92, align 8, !dbg !1102
  %106 = load float, float* %ubz, align 4, !dbg !1103
  %conv94 = fpext float %106 to double, !dbg !1103
  %107 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1104
  %fz95 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %107, i32 0, i32 6, !dbg !1105
  %108 = load double, double* %fz95, align 8, !dbg !1106
  %add96 = fadd double %108, %conv94, !dbg !1106
  store double %add96, double* %fz95, align 8, !dbg !1106
  br label %if.end97, !dbg !1107

if.end97:                                         ; preds = %if.then87, %if.end84
  br label %SKIP, !dbg !1092

SKIP:                                             ; preds = %if.end97
  %109 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1108
  %110 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1110
  %next = getelementptr inbounds %struct.BOND, %struct.BOND* %110, i32 0, i32 7, !dbg !1111
  %111 = load i8*, i8** %next, align 8, !dbg !1111
  %112 = bitcast i8* %111 to %struct.BOND*, !dbg !1110
  %cmp98 = icmp eq %struct.BOND* %109, %112, !dbg !1112
  br i1 %cmp98, label %if.then100, label %if.end101, !dbg !1113

if.then100:                                       ; preds = %SKIP
  br label %while.end, !dbg !1114

if.end101:                                        ; preds = %SKIP
  %113 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1115
  %next102 = getelementptr inbounds %struct.BOND, %struct.BOND* %113, i32 0, i32 7, !dbg !1116
  %114 = load i8*, i8** %next102, align 8, !dbg !1116
  %115 = bitcast i8* %114 to %struct.BOND*, !dbg !1115
  store %struct.BOND* %115, %struct.BOND** %bp, align 8, !dbg !1117
  br label %while.body, !dbg !911

while.end:                                        ; preds = %if.then100, %if.then9
  %116 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !1118
  store %struct.ABC* %116, %struct.ABC** %abcp, align 8, !dbg !1119
  br label %while.body103, !dbg !1120

while.body103:                                    ; preds = %while.end, %if.end391
  %117 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1121
  %cmp104 = icmp eq %struct.ABC* %117, null, !dbg !1124
  br i1 %cmp104, label %if.then106, label %if.end107, !dbg !1125

if.then106:                                       ; preds = %while.body103
  br label %while.end393, !dbg !1126

if.end107:                                        ; preds = %while.body103
  %118 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1127
  %atom1108 = getelementptr inbounds %struct.ABC, %struct.ABC* %118, i32 0, i32 0, !dbg !1128
  %119 = load %struct.ATOM*, %struct.ATOM** %atom1108, align 8, !dbg !1128
  store %struct.ATOM* %119, %struct.ATOM** %a1, align 8, !dbg !1129
  %120 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1130
  %atom2109 = getelementptr inbounds %struct.ABC, %struct.ABC* %120, i32 0, i32 1, !dbg !1131
  %121 = load %struct.ATOM*, %struct.ATOM** %atom2109, align 8, !dbg !1131
  store %struct.ATOM* %121, %struct.ATOM** %a2, align 8, !dbg !1132
  %122 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1133
  %atom3 = getelementptr inbounds %struct.ABC, %struct.ABC* %122, i32 0, i32 2, !dbg !1134
  %123 = load %struct.ATOM*, %struct.ATOM** %atom3, align 8, !dbg !1134
  store %struct.ATOM* %123, %struct.ATOM** %a3, align 8, !dbg !1135
  %124 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1136
  %active110 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %124, i32 0, i32 16, !dbg !1138
  %125 = load i8, i8* %active110, align 1, !dbg !1138
  %conv111 = sext i8 %125 to i32, !dbg !1136
  %tobool112 = icmp ne i32 %conv111, 0, !dbg !1136
  br i1 %tobool112, label %if.then121, label %lor.lhs.false113, !dbg !1139

lor.lhs.false113:                                 ; preds = %if.end107
  %126 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1140
  %active114 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %126, i32 0, i32 16, !dbg !1141
  %127 = load i8, i8* %active114, align 1, !dbg !1141
  %conv115 = sext i8 %127 to i32, !dbg !1140
  %tobool116 = icmp ne i32 %conv115, 0, !dbg !1140
  br i1 %tobool116, label %if.then121, label %lor.lhs.false117, !dbg !1142

lor.lhs.false117:                                 ; preds = %lor.lhs.false113
  %128 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1143
  %active118 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %128, i32 0, i32 16, !dbg !1144
  %129 = load i8, i8* %active118, align 1, !dbg !1144
  %conv119 = sext i8 %129 to i32, !dbg !1143
  %tobool120 = icmp ne i32 %conv119, 0, !dbg !1143
  br i1 %tobool120, label %if.then121, label %if.end386, !dbg !1145

if.then121:                                       ; preds = %lor.lhs.false117, %lor.lhs.false113, %if.end107
  %130 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1146
  %x122 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %130, i32 0, i32 0, !dbg !1148
  %131 = load float, float* %x122, align 4, !dbg !1148
  %132 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1149
  %x123 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %132, i32 0, i32 0, !dbg !1150
  %133 = load float, float* %x123, align 4, !dbg !1150
  %sub124 = fsub float %131, %133, !dbg !1151
  %134 = load float, float* %lambda.addr, align 4, !dbg !1152
  %135 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1153
  %dx125 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %135, i32 0, i32 24, !dbg !1154
  %136 = load float, float* %dx125, align 4, !dbg !1154
  %137 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1155
  %dx126 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %137, i32 0, i32 24, !dbg !1156
  %138 = load float, float* %dx126, align 4, !dbg !1156
  %sub127 = fsub float %136, %138, !dbg !1157
  %mul128 = fmul float %134, %sub127, !dbg !1158
  %add129 = fadd float %sub124, %mul128, !dbg !1159
  store float %add129, float* %x1, align 4, !dbg !1160
  %139 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1161
  %y130 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %139, i32 0, i32 1, !dbg !1162
  %140 = load float, float* %y130, align 4, !dbg !1162
  %141 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1163
  %y131 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %141, i32 0, i32 1, !dbg !1164
  %142 = load float, float* %y131, align 4, !dbg !1164
  %sub132 = fsub float %140, %142, !dbg !1165
  %143 = load float, float* %lambda.addr, align 4, !dbg !1166
  %144 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1167
  %dy133 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %144, i32 0, i32 25, !dbg !1168
  %145 = load float, float* %dy133, align 4, !dbg !1168
  %146 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1169
  %dy134 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %146, i32 0, i32 25, !dbg !1170
  %147 = load float, float* %dy134, align 4, !dbg !1170
  %sub135 = fsub float %145, %147, !dbg !1171
  %mul136 = fmul float %143, %sub135, !dbg !1172
  %add137 = fadd float %sub132, %mul136, !dbg !1173
  store float %add137, float* %y1, align 4, !dbg !1174
  %148 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1175
  %z138 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %148, i32 0, i32 2, !dbg !1176
  %149 = load float, float* %z138, align 4, !dbg !1176
  %150 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1177
  %z139 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %150, i32 0, i32 2, !dbg !1178
  %151 = load float, float* %z139, align 4, !dbg !1178
  %sub140 = fsub float %149, %151, !dbg !1179
  %152 = load float, float* %lambda.addr, align 4, !dbg !1180
  %153 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1181
  %dz141 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %153, i32 0, i32 26, !dbg !1182
  %154 = load float, float* %dz141, align 4, !dbg !1182
  %155 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1183
  %dz142 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %155, i32 0, i32 26, !dbg !1184
  %156 = load float, float* %dz142, align 4, !dbg !1184
  %sub143 = fsub float %154, %156, !dbg !1185
  %mul144 = fmul float %152, %sub143, !dbg !1186
  %add145 = fadd float %sub140, %mul144, !dbg !1187
  store float %add145, float* %z1, align 4, !dbg !1188
  %157 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1189
  %x146 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %157, i32 0, i32 0, !dbg !1190
  %158 = load float, float* %x146, align 4, !dbg !1190
  %159 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1191
  %x147 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %159, i32 0, i32 0, !dbg !1192
  %160 = load float, float* %x147, align 4, !dbg !1192
  %sub148 = fsub float %158, %160, !dbg !1193
  %161 = load float, float* %lambda.addr, align 4, !dbg !1194
  %162 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1195
  %dx149 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %162, i32 0, i32 24, !dbg !1196
  %163 = load float, float* %dx149, align 4, !dbg !1196
  %164 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1197
  %dx150 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %164, i32 0, i32 24, !dbg !1198
  %165 = load float, float* %dx150, align 4, !dbg !1198
  %sub151 = fsub float %163, %165, !dbg !1199
  %mul152 = fmul float %161, %sub151, !dbg !1200
  %add153 = fadd float %sub148, %mul152, !dbg !1201
  store float %add153, float* %x2, align 4, !dbg !1202
  %166 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1203
  %y154 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %166, i32 0, i32 1, !dbg !1204
  %167 = load float, float* %y154, align 4, !dbg !1204
  %168 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1205
  %y155 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %168, i32 0, i32 1, !dbg !1206
  %169 = load float, float* %y155, align 4, !dbg !1206
  %sub156 = fsub float %167, %169, !dbg !1207
  %170 = load float, float* %lambda.addr, align 4, !dbg !1208
  %171 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1209
  %dy157 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %171, i32 0, i32 25, !dbg !1210
  %172 = load float, float* %dy157, align 4, !dbg !1210
  %173 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1211
  %dy158 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %173, i32 0, i32 25, !dbg !1212
  %174 = load float, float* %dy158, align 4, !dbg !1212
  %sub159 = fsub float %172, %174, !dbg !1213
  %mul160 = fmul float %170, %sub159, !dbg !1214
  %add161 = fadd float %sub156, %mul160, !dbg !1215
  store float %add161, float* %y2, align 4, !dbg !1216
  %175 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1217
  %z162 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %175, i32 0, i32 2, !dbg !1218
  %176 = load float, float* %z162, align 4, !dbg !1218
  %177 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1219
  %z163 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %177, i32 0, i32 2, !dbg !1220
  %178 = load float, float* %z163, align 4, !dbg !1220
  %sub164 = fsub float %176, %178, !dbg !1221
  %179 = load float, float* %lambda.addr, align 4, !dbg !1222
  %180 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1223
  %dz165 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %180, i32 0, i32 26, !dbg !1224
  %181 = load float, float* %dz165, align 4, !dbg !1224
  %182 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1225
  %dz166 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %182, i32 0, i32 26, !dbg !1226
  %183 = load float, float* %dz166, align 4, !dbg !1226
  %sub167 = fsub float %181, %183, !dbg !1227
  %mul168 = fmul float %179, %sub167, !dbg !1228
  %add169 = fadd float %sub164, %mul168, !dbg !1229
  store float %add169, float* %z2, align 4, !dbg !1230
  %184 = load float, float* %x1, align 4, !dbg !1231
  %185 = load float, float* %x2, align 4, !dbg !1232
  %mul170 = fmul float %184, %185, !dbg !1233
  %186 = load float, float* %y1, align 4, !dbg !1234
  %187 = load float, float* %y2, align 4, !dbg !1235
  %mul171 = fmul float %186, %187, !dbg !1236
  %add172 = fadd float %mul170, %mul171, !dbg !1237
  %188 = load float, float* %z1, align 4, !dbg !1238
  %189 = load float, float* %z2, align 4, !dbg !1239
  %mul173 = fmul float %188, %189, !dbg !1240
  %add174 = fadd float %add172, %mul173, !dbg !1241
  store float %add174, float* %dp, align 4, !dbg !1242
  %190 = load float, float* %x1, align 4, !dbg !1243
  %191 = load float, float* %x1, align 4, !dbg !1244
  %mul175 = fmul float %190, %191, !dbg !1245
  %192 = load float, float* %y1, align 4, !dbg !1246
  %193 = load float, float* %y1, align 4, !dbg !1247
  %mul176 = fmul float %192, %193, !dbg !1248
  %add177 = fadd float %mul175, %mul176, !dbg !1249
  %194 = load float, float* %z1, align 4, !dbg !1250
  %195 = load float, float* %z1, align 4, !dbg !1251
  %mul178 = fmul float %194, %195, !dbg !1252
  %add179 = fadd float %add177, %mul178, !dbg !1253
  %conv180 = fpext float %add179 to double, !dbg !1243
  %call181 = call double @sqrt(double %conv180) #1, !dbg !1254
  %conv182 = fptrunc double %call181 to float, !dbg !1254
  store float %conv182, float* %r1, align 4, !dbg !1255
  %196 = load float, float* %x2, align 4, !dbg !1256
  %197 = load float, float* %x2, align 4, !dbg !1257
  %mul183 = fmul float %196, %197, !dbg !1258
  %198 = load float, float* %y2, align 4, !dbg !1259
  %199 = load float, float* %y2, align 4, !dbg !1260
  %mul184 = fmul float %198, %199, !dbg !1261
  %add185 = fadd float %mul183, %mul184, !dbg !1262
  %200 = load float, float* %z2, align 4, !dbg !1263
  %201 = load float, float* %z2, align 4, !dbg !1264
  %mul186 = fmul float %200, %201, !dbg !1265
  %add187 = fadd float %add185, %mul186, !dbg !1266
  %conv188 = fpext float %add187 to double, !dbg !1256
  %call189 = call double @sqrt(double %conv188) #1, !dbg !1267
  %conv190 = fptrunc double %call189 to float, !dbg !1267
  store float %conv190, float* %r2, align 4, !dbg !1268
  %202 = load float, float* %r1, align 4, !dbg !1269
  %conv191 = fpext float %202 to double, !dbg !1269
  %cmp192 = fcmp olt double %conv191, 1.000000e-05, !dbg !1271
  br i1 %cmp192, label %if.then198, label %lor.lhs.false194, !dbg !1272

lor.lhs.false194:                                 ; preds = %if.then121
  %203 = load float, float* %r2, align 4, !dbg !1273
  %conv195 = fpext float %203 to double, !dbg !1273
  %cmp196 = fcmp olt double %conv195, 1.000000e-05, !dbg !1274
  br i1 %cmp196, label %if.then198, label %if.end199, !dbg !1275

if.then198:                                       ; preds = %lor.lhs.false194, %if.then121
  br label %SKIP_ANGLE, !dbg !1276

if.end199:                                        ; preds = %lor.lhs.false194
  %204 = load float, float* %r1, align 4, !dbg !1277
  %205 = load float, float* %r2, align 4, !dbg !1278
  %mul200 = fmul float %204, %205, !dbg !1279
  store float %mul200, float* %r, align 4, !dbg !1280
  %206 = load float, float* %r, align 4, !dbg !1281
  %conv201 = fpext float %206 to double, !dbg !1281
  %cmp202 = fcmp ogt double %conv201, 1.000000e-08, !dbg !1283
  br i1 %cmp202, label %if.then204, label %if.end385, !dbg !1284

if.then204:                                       ; preds = %if.end199
  %207 = load float, float* %dp, align 4, !dbg !1285
  %208 = load float, float* %r, align 4, !dbg !1287
  %div205 = fdiv float %207, %208, !dbg !1288
  store float %div205, float* %dp, align 4, !dbg !1289
  %209 = load float, float* %dp, align 4, !dbg !1290
  %conv206 = fpext float %209 to double, !dbg !1290
  %cmp207 = fcmp ogt double %conv206, 1.000000e+00, !dbg !1292
  br i1 %cmp207, label %if.then209, label %if.end210, !dbg !1293

if.then209:                                       ; preds = %if.then204
  store float 1.000000e+00, float* %dp, align 4, !dbg !1294
  br label %if.end210, !dbg !1295

if.end210:                                        ; preds = %if.then209, %if.then204
  %210 = load float, float* %dp, align 4, !dbg !1296
  %conv211 = fpext float %210 to double, !dbg !1296
  %cmp212 = fcmp olt double %conv211, -1.000000e+00, !dbg !1298
  br i1 %cmp212, label %if.then214, label %if.end215, !dbg !1299

if.then214:                                       ; preds = %if.end210
  store float -1.000000e+00, float* %dp, align 4, !dbg !1300
  br label %if.end215, !dbg !1301

if.end215:                                        ; preds = %if.then214, %if.end210
  %211 = load float, float* %dp, align 4, !dbg !1302
  %conv216 = fpext float %211 to double, !dbg !1302
  %call217 = call double @acos(double %conv216) #1, !dbg !1303
  %conv218 = fptrunc double %call217 to float, !dbg !1303
  store float %conv218, float* %dtheta, align 4, !dbg !1304
  %212 = load float, float* %dtheta, align 4, !dbg !1305
  %213 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1306
  %theta = getelementptr inbounds %struct.ABC, %struct.ABC* %213, i32 0, i32 3, !dbg !1307
  %214 = load float, float* %theta, align 4, !dbg !1307
  %sub219 = fsub float %212, %214, !dbg !1308
  store float %sub219, float* %ddtheta, align 4, !dbg !1309
  %215 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1310
  %thetazero = getelementptr inbounds %struct.ABC, %struct.ABC* %215, i32 0, i32 4, !dbg !1311
  %216 = load float, float* %thetazero, align 4, !dbg !1311
  %217 = load float, float* %ddtheta, align 4, !dbg !1312
  %sub220 = fsub float %216, %217, !dbg !1313
  %218 = load float, float* %ddtheta, align 4, !dbg !1314
  %sub221 = fsub float %sub220, %218, !dbg !1315
  store float %sub221, float* %ddtheta, align 4, !dbg !1316
  %219 = load float, float* %dtheta, align 4, !dbg !1317
  %conv222 = fpext float %219 to double, !dbg !1317
  %call223 = call double @sin(double %conv222) #1, !dbg !1318
  %conv224 = fptrunc double %call223 to float, !dbg !1318
  store float %conv224, float* %sdth, align 4, !dbg !1319
  %220 = load float, float* %sdth, align 4, !dbg !1320
  %conv225 = fpext float %220 to double, !dbg !1320
  %cmp226 = fcmp olt double %conv225, 1.000000e-03, !dbg !1322
  br i1 %cmp226, label %if.then228, label %if.end229, !dbg !1323

if.then228:                                       ; preds = %if.end215
  store float 0x3F50624DE0000000, float* %sdth, align 4, !dbg !1324
  br label %if.end229, !dbg !1325

if.end229:                                        ; preds = %if.then228, %if.end215
  %221 = load float, float* %r1, align 4, !dbg !1326
  %222 = load float, float* %sdth, align 4, !dbg !1327
  %mul230 = fmul float %221, %222, !dbg !1328
  store float %mul230, float* %r11, align 4, !dbg !1329
  %223 = load float, float* %r2, align 4, !dbg !1330
  %224 = load float, float* %sdth, align 4, !dbg !1331
  %mul231 = fmul float %223, %224, !dbg !1332
  store float %mul231, float* %r22, align 4, !dbg !1333
  store float 0.000000e+00, float* %dtheta, align 4, !dbg !1334
  %225 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1335
  %b1 = getelementptr inbounds %struct.ABC, %struct.ABC* %225, i32 0, i32 8, !dbg !1336
  %226 = load i8*, i8** %b1, align 8, !dbg !1336
  %227 = bitcast i8* %226 to %struct.BOND*, !dbg !1335
  store %struct.BOND* %227, %struct.BOND** %bp, align 8, !dbg !1337
  %228 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1338
  %ndiff232 = getelementptr inbounds %struct.BOND, %struct.BOND* %228, i32 0, i32 6, !dbg !1340
  %229 = load i32, i32* %ndiff232, align 4, !dbg !1340
  %cmp233 = icmp sgt i32 %229, 0, !dbg !1341
  br i1 %cmp233, label %if.then235, label %if.end263, !dbg !1342

if.then235:                                       ; preds = %if.end229
  %230 = load float, float* %r1, align 4, !dbg !1343
  %231 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1345
  %length236 = getelementptr inbounds %struct.BOND, %struct.BOND* %231, i32 0, i32 2, !dbg !1346
  %232 = load float, float* %length236, align 4, !dbg !1346
  %sub237 = fsub float %230, %232, !dbg !1347
  %233 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1348
  %dlength238 = getelementptr inbounds %struct.BOND, %struct.BOND* %233, i32 0, i32 4, !dbg !1349
  %234 = load float, float* %dlength238, align 4, !dbg !1349
  %235 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1350
  %ndiff239 = getelementptr inbounds %struct.BOND, %struct.BOND* %235, i32 0, i32 6, !dbg !1351
  %236 = load i32, i32* %ndiff239, align 4, !dbg !1351
  %conv240 = sitofp i32 %236 to float, !dbg !1350
  %div241 = fdiv float %234, %conv240, !dbg !1352
  %sub242 = fsub float %sub237, %div241, !dbg !1353
  store float %sub242, float* %rb, align 4, !dbg !1354
  %237 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1355
  %dk1 = getelementptr inbounds %struct.ABC, %struct.ABC* %237, i32 0, i32 6, !dbg !1356
  %238 = load float, float* %dk1, align 4, !dbg !1356
  %239 = load float, float* %ddtheta, align 4, !dbg !1357
  %mul243 = fmul float %238, %239, !dbg !1358
  %240 = load float, float* %rb, align 4, !dbg !1359
  %mul244 = fmul float %mul243, %240, !dbg !1360
  %241 = load float, float* %rb, align 4, !dbg !1361
  %mul245 = fmul float %mul244, %241, !dbg !1362
  %242 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1363
  %ndiff246 = getelementptr inbounds %struct.BOND, %struct.BOND* %242, i32 0, i32 6, !dbg !1364
  %243 = load i32, i32* %ndiff246, align 4, !dbg !1364
  %conv247 = sitofp i32 %243 to float, !dbg !1363
  %div248 = fdiv float %mul245, %conv247, !dbg !1365
  store float %div248, float* %dtheta, align 4, !dbg !1366
  %244 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1367
  %dr = getelementptr inbounds %struct.ABC, %struct.ABC* %244, i32 0, i32 5, !dbg !1368
  %245 = load float, float* %dr, align 4, !dbg !1368
  %mul249 = fmul float 2.000000e+00, %245, !dbg !1369
  %246 = load float, float* %ddtheta, align 4, !dbg !1370
  %mul250 = fmul float %mul249, %246, !dbg !1371
  %247 = load float, float* %rb, align 4, !dbg !1372
  %mul251 = fmul float %mul250, %247, !dbg !1373
  %248 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1374
  %k252 = getelementptr inbounds %struct.BOND, %struct.BOND* %248, i32 0, i32 3, !dbg !1375
  %249 = load float, float* %k252, align 4, !dbg !1375
  %250 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1376
  %dk253 = getelementptr inbounds %struct.BOND, %struct.BOND* %250, i32 0, i32 5, !dbg !1377
  %251 = load float, float* %dk253, align 4, !dbg !1377
  %252 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1378
  %ndiff254 = getelementptr inbounds %struct.BOND, %struct.BOND* %252, i32 0, i32 6, !dbg !1379
  %253 = load i32, i32* %ndiff254, align 4, !dbg !1379
  %conv255 = sitofp i32 %253 to float, !dbg !1378
  %div256 = fdiv float %251, %conv255, !dbg !1380
  %add257 = fadd float %249, %div256, !dbg !1381
  %mul258 = fmul float %mul251, %add257, !dbg !1382
  %254 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1383
  %ndiff259 = getelementptr inbounds %struct.BOND, %struct.BOND* %254, i32 0, i32 6, !dbg !1384
  %255 = load i32, i32* %ndiff259, align 4, !dbg !1384
  %conv260 = sitofp i32 %255 to float, !dbg !1383
  %div261 = fdiv float %mul258, %conv260, !dbg !1385
  %256 = load float, float* %dtheta, align 4, !dbg !1386
  %add262 = fadd float %256, %div261, !dbg !1386
  store float %add262, float* %dtheta, align 4, !dbg !1386
  br label %if.end263, !dbg !1387

if.end263:                                        ; preds = %if.then235, %if.end229
  %257 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1388
  %b2 = getelementptr inbounds %struct.ABC, %struct.ABC* %257, i32 0, i32 9, !dbg !1389
  %258 = load i8*, i8** %b2, align 8, !dbg !1389
  %259 = bitcast i8* %258 to %struct.BOND*, !dbg !1388
  store %struct.BOND* %259, %struct.BOND** %bp, align 8, !dbg !1390
  %260 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1391
  %ndiff264 = getelementptr inbounds %struct.BOND, %struct.BOND* %260, i32 0, i32 6, !dbg !1393
  %261 = load i32, i32* %ndiff264, align 4, !dbg !1393
  %cmp265 = icmp sgt i32 %261, 0, !dbg !1394
  br i1 %cmp265, label %if.then267, label %if.end297, !dbg !1395

if.then267:                                       ; preds = %if.end263
  %262 = load float, float* %r2, align 4, !dbg !1396
  %263 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1398
  %length268 = getelementptr inbounds %struct.BOND, %struct.BOND* %263, i32 0, i32 2, !dbg !1399
  %264 = load float, float* %length268, align 4, !dbg !1399
  %sub269 = fsub float %262, %264, !dbg !1400
  %265 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1401
  %dlength270 = getelementptr inbounds %struct.BOND, %struct.BOND* %265, i32 0, i32 4, !dbg !1402
  %266 = load float, float* %dlength270, align 4, !dbg !1402
  %267 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1403
  %ndiff271 = getelementptr inbounds %struct.BOND, %struct.BOND* %267, i32 0, i32 6, !dbg !1404
  %268 = load i32, i32* %ndiff271, align 4, !dbg !1404
  %conv272 = sitofp i32 %268 to float, !dbg !1403
  %div273 = fdiv float %266, %conv272, !dbg !1405
  %sub274 = fsub float %sub269, %div273, !dbg !1406
  store float %sub274, float* %rb, align 4, !dbg !1407
  %269 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1408
  %dk2 = getelementptr inbounds %struct.ABC, %struct.ABC* %269, i32 0, i32 7, !dbg !1409
  %270 = load float, float* %dk2, align 4, !dbg !1409
  %271 = load float, float* %ddtheta, align 4, !dbg !1410
  %mul275 = fmul float %270, %271, !dbg !1411
  %272 = load float, float* %rb, align 4, !dbg !1412
  %mul276 = fmul float %mul275, %272, !dbg !1413
  %273 = load float, float* %rb, align 4, !dbg !1414
  %mul277 = fmul float %mul276, %273, !dbg !1415
  %274 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1416
  %ndiff278 = getelementptr inbounds %struct.BOND, %struct.BOND* %274, i32 0, i32 6, !dbg !1417
  %275 = load i32, i32* %ndiff278, align 4, !dbg !1417
  %conv279 = sitofp i32 %275 to float, !dbg !1416
  %div280 = fdiv float %mul277, %conv279, !dbg !1418
  %276 = load float, float* %dtheta, align 4, !dbg !1419
  %add281 = fadd float %276, %div280, !dbg !1419
  store float %add281, float* %dtheta, align 4, !dbg !1419
  %277 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1420
  %dr282 = getelementptr inbounds %struct.ABC, %struct.ABC* %277, i32 0, i32 5, !dbg !1421
  %278 = load float, float* %dr282, align 4, !dbg !1421
  %mul283 = fmul float 2.000000e+00, %278, !dbg !1422
  %279 = load float, float* %ddtheta, align 4, !dbg !1423
  %mul284 = fmul float %mul283, %279, !dbg !1424
  %280 = load float, float* %rb, align 4, !dbg !1425
  %mul285 = fmul float %mul284, %280, !dbg !1426
  %281 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1427
  %k286 = getelementptr inbounds %struct.BOND, %struct.BOND* %281, i32 0, i32 3, !dbg !1428
  %282 = load float, float* %k286, align 4, !dbg !1428
  %283 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1429
  %dk287 = getelementptr inbounds %struct.BOND, %struct.BOND* %283, i32 0, i32 5, !dbg !1430
  %284 = load float, float* %dk287, align 4, !dbg !1430
  %285 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1431
  %ndiff288 = getelementptr inbounds %struct.BOND, %struct.BOND* %285, i32 0, i32 6, !dbg !1432
  %286 = load i32, i32* %ndiff288, align 4, !dbg !1432
  %conv289 = sitofp i32 %286 to float, !dbg !1431
  %div290 = fdiv float %284, %conv289, !dbg !1433
  %add291 = fadd float %282, %div290, !dbg !1434
  %mul292 = fmul float %mul285, %add291, !dbg !1435
  %287 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1436
  %ndiff293 = getelementptr inbounds %struct.BOND, %struct.BOND* %287, i32 0, i32 6, !dbg !1437
  %288 = load i32, i32* %ndiff293, align 4, !dbg !1437
  %conv294 = sitofp i32 %288 to float, !dbg !1436
  %div295 = fdiv float %mul292, %conv294, !dbg !1438
  %289 = load float, float* %dtheta, align 4, !dbg !1439
  %add296 = fadd float %289, %div295, !dbg !1439
  store float %add296, float* %dtheta, align 4, !dbg !1439
  br label %if.end297, !dbg !1440

if.end297:                                        ; preds = %if.then267, %if.end263
  %290 = load float, float* %x1, align 4, !dbg !1441
  %291 = load float, float* %r1, align 4, !dbg !1442
  %div298 = fdiv float %290, %291, !dbg !1443
  %292 = load float, float* %dp, align 4, !dbg !1444
  %293 = load float, float* %x2, align 4, !dbg !1445
  %mul299 = fmul float %292, %293, !dbg !1446
  %294 = load float, float* %r2, align 4, !dbg !1447
  %div300 = fdiv float %mul299, %294, !dbg !1448
  %sub301 = fsub float %div298, %div300, !dbg !1449
  %sub302 = fsub float -0.000000e+00, %sub301, !dbg !1450
  %295 = load float, float* %r22, align 4, !dbg !1451
  %div303 = fdiv float %sub302, %295, !dbg !1452
  %296 = load float, float* %dtheta, align 4, !dbg !1453
  %mul304 = fmul float %div303, %296, !dbg !1454
  store float %mul304, float* %ux2, align 4, !dbg !1455
  %297 = load float, float* %y1, align 4, !dbg !1456
  %298 = load float, float* %r1, align 4, !dbg !1457
  %div305 = fdiv float %297, %298, !dbg !1458
  %299 = load float, float* %dp, align 4, !dbg !1459
  %300 = load float, float* %y2, align 4, !dbg !1460
  %mul306 = fmul float %299, %300, !dbg !1461
  %301 = load float, float* %r2, align 4, !dbg !1462
  %div307 = fdiv float %mul306, %301, !dbg !1463
  %sub308 = fsub float %div305, %div307, !dbg !1464
  %sub309 = fsub float -0.000000e+00, %sub308, !dbg !1465
  %302 = load float, float* %r22, align 4, !dbg !1466
  %div310 = fdiv float %sub309, %302, !dbg !1467
  %303 = load float, float* %dtheta, align 4, !dbg !1468
  %mul311 = fmul float %div310, %303, !dbg !1469
  store float %mul311, float* %uy2, align 4, !dbg !1470
  %304 = load float, float* %z1, align 4, !dbg !1471
  %305 = load float, float* %r1, align 4, !dbg !1472
  %div312 = fdiv float %304, %305, !dbg !1473
  %306 = load float, float* %dp, align 4, !dbg !1474
  %307 = load float, float* %z2, align 4, !dbg !1475
  %mul313 = fmul float %306, %307, !dbg !1476
  %308 = load float, float* %r2, align 4, !dbg !1477
  %div314 = fdiv float %mul313, %308, !dbg !1478
  %sub315 = fsub float %div312, %div314, !dbg !1479
  %sub316 = fsub float -0.000000e+00, %sub315, !dbg !1480
  %309 = load float, float* %r22, align 4, !dbg !1481
  %div317 = fdiv float %sub316, %309, !dbg !1482
  %310 = load float, float* %dtheta, align 4, !dbg !1483
  %mul318 = fmul float %div317, %310, !dbg !1484
  store float %mul318, float* %uz2, align 4, !dbg !1485
  %311 = load float, float* %x2, align 4, !dbg !1486
  %312 = load float, float* %r2, align 4, !dbg !1487
  %div319 = fdiv float %311, %312, !dbg !1488
  %313 = load float, float* %dp, align 4, !dbg !1489
  %314 = load float, float* %x1, align 4, !dbg !1490
  %mul320 = fmul float %313, %314, !dbg !1491
  %315 = load float, float* %r1, align 4, !dbg !1492
  %div321 = fdiv float %mul320, %315, !dbg !1493
  %sub322 = fsub float %div319, %div321, !dbg !1494
  %sub323 = fsub float -0.000000e+00, %sub322, !dbg !1495
  %316 = load float, float* %r11, align 4, !dbg !1496
  %div324 = fdiv float %sub323, %316, !dbg !1497
  %317 = load float, float* %dtheta, align 4, !dbg !1498
  %mul325 = fmul float %div324, %317, !dbg !1499
  store float %mul325, float* %ux1, align 4, !dbg !1500
  %318 = load float, float* %y2, align 4, !dbg !1501
  %319 = load float, float* %r2, align 4, !dbg !1502
  %div326 = fdiv float %318, %319, !dbg !1503
  %320 = load float, float* %dp, align 4, !dbg !1504
  %321 = load float, float* %y1, align 4, !dbg !1505
  %mul327 = fmul float %320, %321, !dbg !1506
  %322 = load float, float* %r1, align 4, !dbg !1507
  %div328 = fdiv float %mul327, %322, !dbg !1508
  %sub329 = fsub float %div326, %div328, !dbg !1509
  %sub330 = fsub float -0.000000e+00, %sub329, !dbg !1510
  %323 = load float, float* %r11, align 4, !dbg !1511
  %div331 = fdiv float %sub330, %323, !dbg !1512
  %324 = load float, float* %dtheta, align 4, !dbg !1513
  %mul332 = fmul float %div331, %324, !dbg !1514
  store float %mul332, float* %uy1, align 4, !dbg !1515
  %325 = load float, float* %z2, align 4, !dbg !1516
  %326 = load float, float* %r2, align 4, !dbg !1517
  %div333 = fdiv float %325, %326, !dbg !1518
  %327 = load float, float* %dp, align 4, !dbg !1519
  %328 = load float, float* %z1, align 4, !dbg !1520
  %mul334 = fmul float %327, %328, !dbg !1521
  %329 = load float, float* %r1, align 4, !dbg !1522
  %div335 = fdiv float %mul334, %329, !dbg !1523
  %sub336 = fsub float %div333, %div335, !dbg !1524
  %sub337 = fsub float -0.000000e+00, %sub336, !dbg !1525
  %330 = load float, float* %r11, align 4, !dbg !1526
  %div338 = fdiv float %sub337, %330, !dbg !1527
  %331 = load float, float* %dtheta, align 4, !dbg !1528
  %mul339 = fmul float %div338, %331, !dbg !1529
  store float %mul339, float* %uz1, align 4, !dbg !1530
  %332 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1531
  %active340 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %332, i32 0, i32 16, !dbg !1533
  %333 = load i8, i8* %active340, align 1, !dbg !1533
  %tobool341 = icmp ne i8 %333, 0, !dbg !1531
  br i1 %tobool341, label %if.then342, label %if.end352, !dbg !1534

if.then342:                                       ; preds = %if.end297
  %334 = load float, float* %ux1, align 4, !dbg !1535
  %conv343 = fpext float %334 to double, !dbg !1535
  %335 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1537
  %fx344 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %335, i32 0, i32 4, !dbg !1538
  %336 = load double, double* %fx344, align 8, !dbg !1539
  %add345 = fadd double %336, %conv343, !dbg !1539
  store double %add345, double* %fx344, align 8, !dbg !1539
  %337 = load float, float* %uy1, align 4, !dbg !1540
  %conv346 = fpext float %337 to double, !dbg !1540
  %338 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1541
  %fy347 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %338, i32 0, i32 5, !dbg !1542
  %339 = load double, double* %fy347, align 8, !dbg !1543
  %add348 = fadd double %339, %conv346, !dbg !1543
  store double %add348, double* %fy347, align 8, !dbg !1543
  %340 = load float, float* %uz1, align 4, !dbg !1544
  %conv349 = fpext float %340 to double, !dbg !1544
  %341 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1545
  %fz350 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %341, i32 0, i32 6, !dbg !1546
  %342 = load double, double* %fz350, align 8, !dbg !1547
  %add351 = fadd double %342, %conv349, !dbg !1547
  store double %add351, double* %fz350, align 8, !dbg !1547
  br label %if.end352, !dbg !1548

if.end352:                                        ; preds = %if.then342, %if.end297
  %343 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1549
  %active353 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %343, i32 0, i32 16, !dbg !1551
  %344 = load i8, i8* %active353, align 1, !dbg !1551
  %tobool354 = icmp ne i8 %344, 0, !dbg !1549
  br i1 %tobool354, label %if.then355, label %if.end371, !dbg !1552

if.then355:                                       ; preds = %if.end352
  %345 = load float, float* %ux1, align 4, !dbg !1553
  %sub356 = fsub float -0.000000e+00, %345, !dbg !1555
  %346 = load float, float* %ux2, align 4, !dbg !1556
  %sub357 = fsub float %sub356, %346, !dbg !1557
  %conv358 = fpext float %sub357 to double, !dbg !1555
  %347 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1558
  %fx359 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %347, i32 0, i32 4, !dbg !1559
  %348 = load double, double* %fx359, align 8, !dbg !1560
  %add360 = fadd double %348, %conv358, !dbg !1560
  store double %add360, double* %fx359, align 8, !dbg !1560
  %349 = load float, float* %uy1, align 4, !dbg !1561
  %sub361 = fsub float -0.000000e+00, %349, !dbg !1562
  %350 = load float, float* %uy2, align 4, !dbg !1563
  %sub362 = fsub float %sub361, %350, !dbg !1564
  %conv363 = fpext float %sub362 to double, !dbg !1562
  %351 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1565
  %fy364 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %351, i32 0, i32 5, !dbg !1566
  %352 = load double, double* %fy364, align 8, !dbg !1567
  %add365 = fadd double %352, %conv363, !dbg !1567
  store double %add365, double* %fy364, align 8, !dbg !1567
  %353 = load float, float* %uz1, align 4, !dbg !1568
  %sub366 = fsub float -0.000000e+00, %353, !dbg !1569
  %354 = load float, float* %uz2, align 4, !dbg !1570
  %sub367 = fsub float %sub366, %354, !dbg !1571
  %conv368 = fpext float %sub367 to double, !dbg !1569
  %355 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1572
  %fz369 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %355, i32 0, i32 6, !dbg !1573
  %356 = load double, double* %fz369, align 8, !dbg !1574
  %add370 = fadd double %356, %conv368, !dbg !1574
  store double %add370, double* %fz369, align 8, !dbg !1574
  br label %if.end371, !dbg !1575

if.end371:                                        ; preds = %if.then355, %if.end352
  %357 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1576
  %active372 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %357, i32 0, i32 16, !dbg !1578
  %358 = load i8, i8* %active372, align 1, !dbg !1578
  %tobool373 = icmp ne i8 %358, 0, !dbg !1576
  br i1 %tobool373, label %if.then374, label %if.end384, !dbg !1579

if.then374:                                       ; preds = %if.end371
  %359 = load float, float* %ux2, align 4, !dbg !1580
  %conv375 = fpext float %359 to double, !dbg !1580
  %360 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1582
  %fx376 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %360, i32 0, i32 4, !dbg !1583
  %361 = load double, double* %fx376, align 8, !dbg !1584
  %add377 = fadd double %361, %conv375, !dbg !1584
  store double %add377, double* %fx376, align 8, !dbg !1584
  %362 = load float, float* %uy2, align 4, !dbg !1585
  %conv378 = fpext float %362 to double, !dbg !1585
  %363 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1586
  %fy379 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %363, i32 0, i32 5, !dbg !1587
  %364 = load double, double* %fy379, align 8, !dbg !1588
  %add380 = fadd double %364, %conv378, !dbg !1588
  store double %add380, double* %fy379, align 8, !dbg !1588
  %365 = load float, float* %uz2, align 4, !dbg !1589
  %conv381 = fpext float %365 to double, !dbg !1589
  %366 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1590
  %fz382 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %366, i32 0, i32 6, !dbg !1591
  %367 = load double, double* %fz382, align 8, !dbg !1592
  %add383 = fadd double %367, %conv381, !dbg !1592
  store double %add383, double* %fz382, align 8, !dbg !1592
  br label %if.end384, !dbg !1593

if.end384:                                        ; preds = %if.then374, %if.end371
  br label %if.end385, !dbg !1594

if.end385:                                        ; preds = %if.end384, %if.end199
  br label %if.end386, !dbg !1595

if.end386:                                        ; preds = %if.end385, %lor.lhs.false117
  br label %SKIP_ANGLE, !dbg !1144

SKIP_ANGLE:                                       ; preds = %if.end386, %if.then198
  %368 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1596
  %369 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1598
  %next387 = getelementptr inbounds %struct.ABC, %struct.ABC* %369, i32 0, i32 10, !dbg !1599
  %370 = load i8*, i8** %next387, align 8, !dbg !1599
  %371 = bitcast i8* %370 to %struct.ABC*, !dbg !1598
  %cmp388 = icmp eq %struct.ABC* %368, %371, !dbg !1600
  br i1 %cmp388, label %if.then390, label %if.end391, !dbg !1601

if.then390:                                       ; preds = %SKIP_ANGLE
  br label %while.end393, !dbg !1602

if.end391:                                        ; preds = %SKIP_ANGLE
  %372 = load %struct.ABC*, %struct.ABC** %abcp, align 8, !dbg !1603
  %next392 = getelementptr inbounds %struct.ABC, %struct.ABC* %372, i32 0, i32 10, !dbg !1604
  %373 = load i8*, i8** %next392, align 8, !dbg !1604
  %374 = bitcast i8* %373 to %struct.ABC*, !dbg !1603
  store %struct.ABC* %374, %struct.ABC** %abcp, align 8, !dbg !1605
  br label %while.body103, !dbg !1120

while.end393:                                     ; preds = %if.then, %if.then3, %if.then390, %if.then106
  %375 = load i32, i32* %retval, !dbg !1606
  ret i32 %375, !dbg !1606
}

declare i32 @f_bond(...) #2

; Function Attrs: nounwind readnone
declare double @sin(double) #3

; Function Attrs: nounwind ssp uwtable
define void @get_abc(%struct.ATOM* %a1, %struct.ATOM** %bonded, i32 %mbond, i32* %inbond) #0 {
entry:
  %a1.addr = alloca %struct.ATOM*, align 8
  %bonded.addr = alloca %struct.ATOM**, align 8
  %mbond.addr = alloca i32, align 4
  %inbond.addr = alloca i32*, align 8
  %mine = alloca %struct.ABC*, align 8
  store %struct.ATOM* %a1, %struct.ATOM** %a1.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1.addr, metadata !1607, metadata !186), !dbg !1608
  store %struct.ATOM** %bonded, %struct.ATOM*** %bonded.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.ATOM*** %bonded.addr, metadata !1609, metadata !186), !dbg !1610
  store i32 %mbond, i32* %mbond.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %mbond.addr, metadata !1611, metadata !186), !dbg !1612
  store i32* %inbond, i32** %inbond.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %inbond.addr, metadata !1613, metadata !186), !dbg !1614
  call void @llvm.dbg.declare(metadata %struct.ABC** %mine, metadata !1615, metadata !186), !dbg !1616
  %0 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !1617
  store %struct.ABC* %0, %struct.ABC** %mine, align 8, !dbg !1618
  %1 = load i32*, i32** %inbond.addr, align 8, !dbg !1619
  store i32 0, i32* %1, align 4, !dbg !1620
  br label %while.body, !dbg !1621

while.body:                                       ; preds = %entry, %if.end18
  %2 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1622
  %cmp = icmp eq %struct.ABC* %2, null, !dbg !1625
  br i1 %cmp, label %if.then, label %if.end, !dbg !1626

if.then:                                          ; preds = %while.body
  br label %return, !dbg !1627

if.end:                                           ; preds = %while.body
  %3 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1629
  %atom1 = getelementptr inbounds %struct.ABC, %struct.ABC* %3, i32 0, i32 0, !dbg !1631
  %4 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !1631
  %5 = load %struct.ATOM*, %struct.ATOM** %a1.addr, align 8, !dbg !1632
  %cmp1 = icmp eq %struct.ATOM* %4, %5, !dbg !1633
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !1634

if.then2:                                         ; preds = %if.end
  %6 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1635
  %atom3 = getelementptr inbounds %struct.ABC, %struct.ABC* %6, i32 0, i32 2, !dbg !1637
  %7 = load %struct.ATOM*, %struct.ATOM** %atom3, align 8, !dbg !1637
  %8 = load i32*, i32** %inbond.addr, align 8, !dbg !1638
  %9 = load i32, i32* %8, align 4, !dbg !1639
  %inc = add nsw i32 %9, 1, !dbg !1639
  store i32 %inc, i32* %8, align 4, !dbg !1639
  %idxprom = sext i32 %9 to i64, !dbg !1640
  %10 = load %struct.ATOM**, %struct.ATOM*** %bonded.addr, align 8, !dbg !1640
  %arrayidx = getelementptr inbounds %struct.ATOM*, %struct.ATOM** %10, i64 %idxprom, !dbg !1640
  store %struct.ATOM* %7, %struct.ATOM** %arrayidx, align 8, !dbg !1641
  br label %if.end3, !dbg !1642

if.end3:                                          ; preds = %if.then2, %if.end
  %11 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1643
  %atom34 = getelementptr inbounds %struct.ABC, %struct.ABC* %11, i32 0, i32 2, !dbg !1645
  %12 = load %struct.ATOM*, %struct.ATOM** %atom34, align 8, !dbg !1645
  %13 = load %struct.ATOM*, %struct.ATOM** %a1.addr, align 8, !dbg !1646
  %cmp5 = icmp eq %struct.ATOM* %12, %13, !dbg !1647
  br i1 %cmp5, label %if.then6, label %if.end11, !dbg !1648

if.then6:                                         ; preds = %if.end3
  %14 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1649
  %atom17 = getelementptr inbounds %struct.ABC, %struct.ABC* %14, i32 0, i32 0, !dbg !1651
  %15 = load %struct.ATOM*, %struct.ATOM** %atom17, align 8, !dbg !1651
  %16 = load i32*, i32** %inbond.addr, align 8, !dbg !1652
  %17 = load i32, i32* %16, align 4, !dbg !1653
  %inc8 = add nsw i32 %17, 1, !dbg !1653
  store i32 %inc8, i32* %16, align 4, !dbg !1653
  %idxprom9 = sext i32 %17 to i64, !dbg !1654
  %18 = load %struct.ATOM**, %struct.ATOM*** %bonded.addr, align 8, !dbg !1654
  %arrayidx10 = getelementptr inbounds %struct.ATOM*, %struct.ATOM** %18, i64 %idxprom9, !dbg !1654
  store %struct.ATOM* %15, %struct.ATOM** %arrayidx10, align 8, !dbg !1655
  br label %if.end11, !dbg !1656

if.end11:                                         ; preds = %if.then6, %if.end3
  %19 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1657
  %20 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1659
  %next = getelementptr inbounds %struct.ABC, %struct.ABC* %20, i32 0, i32 10, !dbg !1660
  %21 = load i8*, i8** %next, align 8, !dbg !1660
  %22 = bitcast i8* %21 to %struct.ABC*, !dbg !1659
  %cmp12 = icmp eq %struct.ABC* %19, %22, !dbg !1661
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !1662

if.then13:                                        ; preds = %if.end11
  br label %return, !dbg !1663

if.end14:                                         ; preds = %if.end11
  %23 = load %struct.ABC*, %struct.ABC** %mine, align 8, !dbg !1664
  %next15 = getelementptr inbounds %struct.ABC, %struct.ABC* %23, i32 0, i32 10, !dbg !1665
  %24 = load i8*, i8** %next15, align 8, !dbg !1665
  %25 = bitcast i8* %24 to %struct.ABC*, !dbg !1664
  store %struct.ABC* %25, %struct.ABC** %mine, align 8, !dbg !1666
  %26 = load i32*, i32** %inbond.addr, align 8, !dbg !1667
  %27 = load i32, i32* %26, align 4, !dbg !1669
  %28 = load i32, i32* %mbond.addr, align 4, !dbg !1670
  %cmp16 = icmp eq i32 %27, %28, !dbg !1671
  br i1 %cmp16, label %if.then17, label %if.end18, !dbg !1672

if.then17:                                        ; preds = %if.end14
  br label %return, !dbg !1673

if.end18:                                         ; preds = %if.end14
  br label %while.body, !dbg !1621

return:                                           ; preds = %if.then17, %if.then13, %if.then
  ret void, !dbg !1674
}

; Function Attrs: nounwind ssp uwtable
define void @dump_abcs(%struct.__sFILE* %where) #0 {
entry:
  %where.addr = alloca %struct.__sFILE*, align 8
  %b = alloca %struct.ABC*, align 8
  %a1 = alloca %struct.ATOM*, align 8
  %a2 = alloca %struct.ATOM*, align 8
  %a3 = alloca %struct.ATOM*, align 8
  %rtodeg = alloca float, align 4
  store %struct.__sFILE* %where, %struct.__sFILE** %where.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.__sFILE** %where.addr, metadata !1675, metadata !186), !dbg !1676
  call void @llvm.dbg.declare(metadata %struct.ABC** %b, metadata !1677, metadata !186), !dbg !1678
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1, metadata !1679, metadata !186), !dbg !1680
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a2, metadata !1681, metadata !186), !dbg !1682
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a3, metadata !1683, metadata !186), !dbg !1684
  call void @llvm.dbg.declare(metadata float* %rtodeg, metadata !1685, metadata !186), !dbg !1686
  %0 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !1687
  store %struct.ABC* %0, %struct.ABC** %b, align 8, !dbg !1688
  %1 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1689
  %cmp = icmp eq %struct.ABC* %1, null, !dbg !1691
  br i1 %cmp, label %if.then, label %if.end, !dbg !1692

if.then:                                          ; preds = %entry
  br label %return, !dbg !1693

if.end:                                           ; preds = %entry
  %call = call double @acos(double -1.000000e+00) #1, !dbg !1694
  %div = fdiv double 1.800000e+02, %call, !dbg !1695
  %conv = fptrunc double %div to float, !dbg !1696
  store float %conv, float* %rtodeg, align 4, !dbg !1697
  br label %while.cond, !dbg !1698

while.cond:                                       ; preds = %if.end7, %if.end
  %2 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1699
  %next = getelementptr inbounds %struct.ABC, %struct.ABC* %2, i32 0, i32 10, !dbg !1700
  %3 = load i8*, i8** %next, align 8, !dbg !1700
  %4 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1701
  %5 = bitcast %struct.ABC* %4 to i8*, !dbg !1701
  %cmp1 = icmp ne i8* %3, %5, !dbg !1702
  br i1 %cmp1, label %while.body, label %while.end, !dbg !1698

while.body:                                       ; preds = %while.cond
  %6 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1703
  %next3 = getelementptr inbounds %struct.ABC, %struct.ABC* %6, i32 0, i32 10, !dbg !1706
  %7 = load i8*, i8** %next3, align 8, !dbg !1706
  %cmp4 = icmp eq i8* %7, null, !dbg !1707
  br i1 %cmp4, label %if.then6, label %if.end7, !dbg !1708

if.then6:                                         ; preds = %while.body
  br label %return, !dbg !1709

if.end7:                                          ; preds = %while.body
  %8 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1710
  %atom1 = getelementptr inbounds %struct.ABC, %struct.ABC* %8, i32 0, i32 0, !dbg !1711
  %9 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !1711
  store %struct.ATOM* %9, %struct.ATOM** %a1, align 8, !dbg !1712
  %10 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1713
  %atom2 = getelementptr inbounds %struct.ABC, %struct.ABC* %10, i32 0, i32 1, !dbg !1714
  %11 = load %struct.ATOM*, %struct.ATOM** %atom2, align 8, !dbg !1714
  store %struct.ATOM* %11, %struct.ATOM** %a2, align 8, !dbg !1715
  %12 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1716
  %atom3 = getelementptr inbounds %struct.ABC, %struct.ABC* %12, i32 0, i32 2, !dbg !1717
  %13 = load %struct.ATOM*, %struct.ATOM** %atom3, align 8, !dbg !1717
  store %struct.ATOM* %13, %struct.ATOM** %a3, align 8, !dbg !1718
  %14 = load %struct.__sFILE*, %struct.__sFILE** %where.addr, align 8, !dbg !1719
  %15 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1720
  %serial = getelementptr inbounds %struct.ATOM, %struct.ATOM* %15, i32 0, i32 8, !dbg !1721
  %16 = load i32, i32* %serial, align 4, !dbg !1721
  %17 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1722
  %serial8 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %17, i32 0, i32 8, !dbg !1723
  %18 = load i32, i32* %serial8, align 4, !dbg !1723
  %19 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1724
  %serial9 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %19, i32 0, i32 8, !dbg !1725
  %20 = load i32, i32* %serial9, align 4, !dbg !1725
  %21 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1726
  %theta = getelementptr inbounds %struct.ABC, %struct.ABC* %21, i32 0, i32 3, !dbg !1727
  %22 = load float, float* %theta, align 4, !dbg !1727
  %23 = load float, float* %rtodeg, align 4, !dbg !1728
  %mul = fmul float %22, %23, !dbg !1729
  %conv10 = fpext float %mul to double, !dbg !1726
  %24 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1730
  %thetazero = getelementptr inbounds %struct.ABC, %struct.ABC* %24, i32 0, i32 4, !dbg !1731
  %25 = load float, float* %thetazero, align 4, !dbg !1731
  %26 = load float, float* %rtodeg, align 4, !dbg !1732
  %mul11 = fmul float %25, %26, !dbg !1733
  %conv12 = fpext float %mul11 to double, !dbg !1730
  %27 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1734
  %dr = getelementptr inbounds %struct.ABC, %struct.ABC* %27, i32 0, i32 5, !dbg !1735
  %28 = load float, float* %dr, align 4, !dbg !1735
  %conv13 = fpext float %28 to double, !dbg !1734
  %29 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1736
  %dk1 = getelementptr inbounds %struct.ABC, %struct.ABC* %29, i32 0, i32 6, !dbg !1737
  %30 = load float, float* %dk1, align 4, !dbg !1737
  %conv14 = fpext float %30 to double, !dbg !1736
  %31 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1738
  %dk2 = getelementptr inbounds %struct.ABC, %struct.ABC* %31, i32 0, i32 7, !dbg !1739
  %32 = load float, float* %dk2, align 4, !dbg !1739
  %conv15 = fpext float %32 to double, !dbg !1738
  %call16 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %14, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str1, i32 0, i32 0), i32 %16, i32 %18, i32 %20, double %conv10, double %conv12, double %conv13, double %conv14, double %conv15), !dbg !1740
  %33 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1741
  %next17 = getelementptr inbounds %struct.ABC, %struct.ABC* %33, i32 0, i32 10, !dbg !1742
  %34 = load i8*, i8** %next17, align 8, !dbg !1742
  %35 = bitcast i8* %34 to %struct.ABC*, !dbg !1741
  store %struct.ABC* %35, %struct.ABC** %b, align 8, !dbg !1743
  br label %while.cond, !dbg !1698

while.end:                                        ; preds = %while.cond
  %36 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1744
  %next18 = getelementptr inbounds %struct.ABC, %struct.ABC* %36, i32 0, i32 10, !dbg !1746
  %37 = load i8*, i8** %next18, align 8, !dbg !1746
  %cmp19 = icmp eq i8* %37, null, !dbg !1747
  br i1 %cmp19, label %if.then21, label %if.end22, !dbg !1748

if.then21:                                        ; preds = %while.end
  br label %return, !dbg !1749

if.end22:                                         ; preds = %while.end
  %38 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1750
  %atom123 = getelementptr inbounds %struct.ABC, %struct.ABC* %38, i32 0, i32 0, !dbg !1751
  %39 = load %struct.ATOM*, %struct.ATOM** %atom123, align 8, !dbg !1751
  store %struct.ATOM* %39, %struct.ATOM** %a1, align 8, !dbg !1752
  %40 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1753
  %atom224 = getelementptr inbounds %struct.ABC, %struct.ABC* %40, i32 0, i32 1, !dbg !1754
  %41 = load %struct.ATOM*, %struct.ATOM** %atom224, align 8, !dbg !1754
  store %struct.ATOM* %41, %struct.ATOM** %a2, align 8, !dbg !1755
  %42 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1756
  %atom325 = getelementptr inbounds %struct.ABC, %struct.ABC* %42, i32 0, i32 2, !dbg !1757
  %43 = load %struct.ATOM*, %struct.ATOM** %atom325, align 8, !dbg !1757
  store %struct.ATOM* %43, %struct.ATOM** %a3, align 8, !dbg !1758
  %44 = load %struct.__sFILE*, %struct.__sFILE** %where.addr, align 8, !dbg !1759
  %45 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1760
  %serial26 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %45, i32 0, i32 8, !dbg !1761
  %46 = load i32, i32* %serial26, align 4, !dbg !1761
  %47 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1762
  %serial27 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %47, i32 0, i32 8, !dbg !1763
  %48 = load i32, i32* %serial27, align 4, !dbg !1763
  %49 = load %struct.ATOM*, %struct.ATOM** %a3, align 8, !dbg !1764
  %serial28 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %49, i32 0, i32 8, !dbg !1765
  %50 = load i32, i32* %serial28, align 4, !dbg !1765
  %51 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1766
  %theta29 = getelementptr inbounds %struct.ABC, %struct.ABC* %51, i32 0, i32 3, !dbg !1767
  %52 = load float, float* %theta29, align 4, !dbg !1767
  %53 = load float, float* %rtodeg, align 4, !dbg !1768
  %mul30 = fmul float %52, %53, !dbg !1769
  %conv31 = fpext float %mul30 to double, !dbg !1766
  %54 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1770
  %thetazero32 = getelementptr inbounds %struct.ABC, %struct.ABC* %54, i32 0, i32 4, !dbg !1771
  %55 = load float, float* %thetazero32, align 4, !dbg !1771
  %56 = load float, float* %rtodeg, align 4, !dbg !1772
  %mul33 = fmul float %55, %56, !dbg !1773
  %conv34 = fpext float %mul33 to double, !dbg !1770
  %57 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1774
  %dr35 = getelementptr inbounds %struct.ABC, %struct.ABC* %57, i32 0, i32 5, !dbg !1775
  %58 = load float, float* %dr35, align 4, !dbg !1775
  %conv36 = fpext float %58 to double, !dbg !1774
  %59 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1776
  %dk137 = getelementptr inbounds %struct.ABC, %struct.ABC* %59, i32 0, i32 6, !dbg !1777
  %60 = load float, float* %dk137, align 4, !dbg !1777
  %conv38 = fpext float %60 to double, !dbg !1776
  %61 = load %struct.ABC*, %struct.ABC** %b, align 8, !dbg !1778
  %dk239 = getelementptr inbounds %struct.ABC, %struct.ABC* %61, i32 0, i32 7, !dbg !1779
  %62 = load float, float* %dk239, align 4, !dbg !1779
  %conv40 = fpext float %62 to double, !dbg !1778
  %call41 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %44, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str2, i32 0, i32 0), i32 %46, i32 %48, i32 %50, double %conv31, double %conv34, double %conv36, double %conv38, double %conv40), !dbg !1780
  br label %return, !dbg !1781

return:                                           ; preds = %if.end22, %if.then21, %if.then6, %if.then
  ret void, !dbg !1781
}

declare i32 @fprintf(%struct.__sFILE*, i8*, ...) #2

; Function Attrs: nounwind ssp uwtable
define i32 @a_abc(float* %V, double, i32 %ilow, i32 %ihigh, %struct.__sFILE* %op) #0 {
entry:
  %retval = alloca i32, align 4
  %V.addr = alloca float*, align 8
  %lambda.addr = alloca float, align 4
  %ilow.addr = alloca i32, align 4
  %ihigh.addr = alloca i32, align 4
  %op.addr = alloca %struct.__sFILE*, align 8
  %bp = alloca %struct.BOND*, align 8
  %r = alloca float, align 4
  %x1 = alloca float, align 4
  %y1 = alloca float, align 4
  %z1 = alloca float, align 4
  %keff = alloca float, align 4
  %length_eff = alloca float, align 4
  %a1 = alloca %struct.ATOM*, align 8
  %a2 = alloca %struct.ATOM*, align 8
  %lambda = fptrunc double %0 to float
  store float* %V, float** %V.addr, align 8
  call void @llvm.dbg.declare(metadata float** %V.addr, metadata !1782, metadata !186), !dbg !1783
  store float %lambda, float* %lambda.addr, align 4
  call void @llvm.dbg.declare(metadata float* %lambda.addr, metadata !1784, metadata !186), !dbg !1785
  store i32 %ilow, i32* %ilow.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %ilow.addr, metadata !1786, metadata !186), !dbg !1787
  store i32 %ihigh, i32* %ihigh.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %ihigh.addr, metadata !1788, metadata !186), !dbg !1789
  store %struct.__sFILE* %op, %struct.__sFILE** %op.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.__sFILE** %op.addr, metadata !1790, metadata !186), !dbg !1791
  call void @llvm.dbg.declare(metadata %struct.BOND** %bp, metadata !1792, metadata !186), !dbg !1793
  call void @llvm.dbg.declare(metadata float* %r, metadata !1794, metadata !186), !dbg !1795
  call void @llvm.dbg.declare(metadata float* %x1, metadata !1796, metadata !186), !dbg !1797
  call void @llvm.dbg.declare(metadata float* %y1, metadata !1798, metadata !186), !dbg !1799
  call void @llvm.dbg.declare(metadata float* %z1, metadata !1800, metadata !186), !dbg !1801
  call void @llvm.dbg.declare(metadata float* %keff, metadata !1802, metadata !186), !dbg !1803
  call void @llvm.dbg.declare(metadata float* %length_eff, metadata !1804, metadata !186), !dbg !1805
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a1, metadata !1806, metadata !186), !dbg !1807
  call void @llvm.dbg.declare(metadata %struct.ATOM** %a2, metadata !1808, metadata !186), !dbg !1809
  %1 = load %struct.BOND*, %struct.BOND** @bond_first, align 8, !dbg !1810
  store %struct.BOND* %1, %struct.BOND** %bp, align 8, !dbg !1811
  %2 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1812
  %cmp = icmp eq %struct.BOND* %2, null, !dbg !1814
  br i1 %cmp, label %if.then, label %if.end, !dbg !1815

if.then:                                          ; preds = %entry
  store i32 1, i32* %retval, !dbg !1816
  br label %return, !dbg !1816

if.end:                                           ; preds = %entry
  %3 = load %struct.ABC*, %struct.ABC** @abc_first, align 8, !dbg !1817
  %cmp1 = icmp eq %struct.ABC* %3, null, !dbg !1819
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !1820

if.then2:                                         ; preds = %if.end
  store i32 1, i32* %retval, !dbg !1821
  br label %return, !dbg !1821

if.end3:                                          ; preds = %if.end
  %4 = load float, float* %lambda.addr, align 4, !dbg !1822
  %conv = fpext float %4 to double, !dbg !1822
  %call = call i32 @do_abc(double %conv), !dbg !1823
  br label %while.body, !dbg !1824

while.body:                                       ; preds = %if.end3, %if.end78
  %5 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1825
  %cmp4 = icmp eq %struct.BOND* %5, null, !dbg !1828
  br i1 %cmp4, label %if.then6, label %if.end7, !dbg !1829

if.then6:                                         ; preds = %while.body
  store i32 0, i32* %retval, !dbg !1830
  br label %return, !dbg !1830

if.end7:                                          ; preds = %while.body
  %6 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1831
  %atom1 = getelementptr inbounds %struct.BOND, %struct.BOND* %6, i32 0, i32 0, !dbg !1832
  %7 = load %struct.ATOM*, %struct.ATOM** %atom1, align 8, !dbg !1832
  store %struct.ATOM* %7, %struct.ATOM** %a1, align 8, !dbg !1833
  %8 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1834
  %atom2 = getelementptr inbounds %struct.BOND, %struct.BOND* %8, i32 0, i32 1, !dbg !1835
  %9 = load %struct.ATOM*, %struct.ATOM** %atom2, align 8, !dbg !1835
  store %struct.ATOM* %9, %struct.ATOM** %a2, align 8, !dbg !1836
  %10 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1837
  %serial = getelementptr inbounds %struct.ATOM, %struct.ATOM* %10, i32 0, i32 8, !dbg !1839
  %11 = load i32, i32* %serial, align 4, !dbg !1839
  %12 = load i32, i32* %ilow.addr, align 4, !dbg !1840
  %cmp8 = icmp sge i32 %11, %12, !dbg !1841
  br i1 %cmp8, label %land.lhs.true, label %lor.lhs.false, !dbg !1842

land.lhs.true:                                    ; preds = %if.end7
  %13 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1843
  %serial10 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %13, i32 0, i32 8, !dbg !1844
  %14 = load i32, i32* %serial10, align 4, !dbg !1844
  %15 = load i32, i32* %ihigh.addr, align 4, !dbg !1845
  %cmp11 = icmp sle i32 %14, %15, !dbg !1846
  br i1 %cmp11, label %if.then20, label %lor.lhs.false, !dbg !1847

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.end7
  %16 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1848
  %serial13 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %16, i32 0, i32 8, !dbg !1849
  %17 = load i32, i32* %serial13, align 4, !dbg !1849
  %18 = load i32, i32* %ilow.addr, align 4, !dbg !1850
  %cmp14 = icmp sge i32 %17, %18, !dbg !1851
  br i1 %cmp14, label %land.lhs.true16, label %if.end74, !dbg !1852

land.lhs.true16:                                  ; preds = %lor.lhs.false
  %19 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1853
  %serial17 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %19, i32 0, i32 8, !dbg !1854
  %20 = load i32, i32* %serial17, align 4, !dbg !1854
  %21 = load i32, i32* %ihigh.addr, align 4, !dbg !1855
  %cmp18 = icmp sle i32 %20, %21, !dbg !1856
  br i1 %cmp18, label %if.then20, label %if.end74, !dbg !1857

if.then20:                                        ; preds = %land.lhs.true16, %land.lhs.true
  %22 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1858
  %x = getelementptr inbounds %struct.ATOM, %struct.ATOM* %22, i32 0, i32 0, !dbg !1860
  %23 = load float, float* %x, align 4, !dbg !1860
  %24 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1861
  %x21 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %24, i32 0, i32 0, !dbg !1862
  %25 = load float, float* %x21, align 4, !dbg !1862
  %sub = fsub float %23, %25, !dbg !1863
  %26 = load float, float* %lambda.addr, align 4, !dbg !1864
  %27 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1865
  %dx = getelementptr inbounds %struct.ATOM, %struct.ATOM* %27, i32 0, i32 24, !dbg !1866
  %28 = load float, float* %dx, align 4, !dbg !1866
  %29 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1867
  %dx22 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %29, i32 0, i32 24, !dbg !1868
  %30 = load float, float* %dx22, align 4, !dbg !1868
  %sub23 = fsub float %28, %30, !dbg !1869
  %mul = fmul float %26, %sub23, !dbg !1870
  %add = fadd float %sub, %mul, !dbg !1871
  store float %add, float* %x1, align 4, !dbg !1872
  %31 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1873
  %y = getelementptr inbounds %struct.ATOM, %struct.ATOM* %31, i32 0, i32 1, !dbg !1874
  %32 = load float, float* %y, align 4, !dbg !1874
  %33 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1875
  %y24 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %33, i32 0, i32 1, !dbg !1876
  %34 = load float, float* %y24, align 4, !dbg !1876
  %sub25 = fsub float %32, %34, !dbg !1877
  %35 = load float, float* %lambda.addr, align 4, !dbg !1878
  %36 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1879
  %dy = getelementptr inbounds %struct.ATOM, %struct.ATOM* %36, i32 0, i32 25, !dbg !1880
  %37 = load float, float* %dy, align 4, !dbg !1880
  %38 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1881
  %dy26 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %38, i32 0, i32 25, !dbg !1882
  %39 = load float, float* %dy26, align 4, !dbg !1882
  %sub27 = fsub float %37, %39, !dbg !1883
  %mul28 = fmul float %35, %sub27, !dbg !1884
  %add29 = fadd float %sub25, %mul28, !dbg !1885
  store float %add29, float* %y1, align 4, !dbg !1886
  %40 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1887
  %z = getelementptr inbounds %struct.ATOM, %struct.ATOM* %40, i32 0, i32 2, !dbg !1888
  %41 = load float, float* %z, align 4, !dbg !1888
  %42 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1889
  %z30 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %42, i32 0, i32 2, !dbg !1890
  %43 = load float, float* %z30, align 4, !dbg !1890
  %sub31 = fsub float %41, %43, !dbg !1891
  %44 = load float, float* %lambda.addr, align 4, !dbg !1892
  %45 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1893
  %dz = getelementptr inbounds %struct.ATOM, %struct.ATOM* %45, i32 0, i32 26, !dbg !1894
  %46 = load float, float* %dz, align 4, !dbg !1894
  %47 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1895
  %dz32 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %47, i32 0, i32 26, !dbg !1896
  %48 = load float, float* %dz32, align 4, !dbg !1896
  %sub33 = fsub float %46, %48, !dbg !1897
  %mul34 = fmul float %44, %sub33, !dbg !1898
  %add35 = fadd float %sub31, %mul34, !dbg !1899
  store float %add35, float* %z1, align 4, !dbg !1900
  %49 = load float, float* %x1, align 4, !dbg !1901
  %50 = load float, float* %x1, align 4, !dbg !1902
  %mul36 = fmul float %49, %50, !dbg !1903
  %51 = load float, float* %y1, align 4, !dbg !1904
  %52 = load float, float* %y1, align 4, !dbg !1905
  %mul37 = fmul float %51, %52, !dbg !1906
  %add38 = fadd float %mul36, %mul37, !dbg !1907
  %53 = load float, float* %z1, align 4, !dbg !1908
  %54 = load float, float* %z1, align 4, !dbg !1909
  %mul39 = fmul float %53, %54, !dbg !1910
  %add40 = fadd float %add38, %mul39, !dbg !1911
  store float %add40, float* %r, align 4, !dbg !1912
  %55 = load float, float* %r, align 4, !dbg !1913
  %conv41 = fpext float %55 to double, !dbg !1913
  %call42 = call double @sqrt(double %conv41) #1, !dbg !1914
  %conv43 = fptrunc double %call42 to float, !dbg !1914
  store float %conv43, float* %r, align 4, !dbg !1915
  %56 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1916
  %ndiff = getelementptr inbounds %struct.BOND, %struct.BOND* %56, i32 0, i32 6, !dbg !1918
  %57 = load i32, i32* %ndiff, align 4, !dbg !1918
  %cmp44 = icmp eq i32 %57, 0, !dbg !1919
  br i1 %cmp44, label %if.then46, label %if.else, !dbg !1920

if.then46:                                        ; preds = %if.then20
  %58 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1921
  %k = getelementptr inbounds %struct.BOND, %struct.BOND* %58, i32 0, i32 3, !dbg !1923
  %59 = load float, float* %k, align 4, !dbg !1923
  store float %59, float* %keff, align 4, !dbg !1924
  %60 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1925
  %length = getelementptr inbounds %struct.BOND, %struct.BOND* %60, i32 0, i32 2, !dbg !1926
  %61 = load float, float* %length, align 4, !dbg !1926
  store float %61, float* %length_eff, align 4, !dbg !1927
  br label %if.end56, !dbg !1928

if.else:                                          ; preds = %if.then20
  %62 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1929
  %k47 = getelementptr inbounds %struct.BOND, %struct.BOND* %62, i32 0, i32 3, !dbg !1931
  %63 = load float, float* %k47, align 4, !dbg !1931
  %64 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1932
  %dk = getelementptr inbounds %struct.BOND, %struct.BOND* %64, i32 0, i32 5, !dbg !1933
  %65 = load float, float* %dk, align 4, !dbg !1933
  %66 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1934
  %ndiff48 = getelementptr inbounds %struct.BOND, %struct.BOND* %66, i32 0, i32 6, !dbg !1935
  %67 = load i32, i32* %ndiff48, align 4, !dbg !1935
  %conv49 = sitofp i32 %67 to float, !dbg !1934
  %div = fdiv float %65, %conv49, !dbg !1936
  %add50 = fadd float %63, %div, !dbg !1937
  store float %add50, float* %keff, align 4, !dbg !1938
  %68 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1939
  %length51 = getelementptr inbounds %struct.BOND, %struct.BOND* %68, i32 0, i32 2, !dbg !1940
  %69 = load float, float* %length51, align 4, !dbg !1940
  %70 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1941
  %dlength = getelementptr inbounds %struct.BOND, %struct.BOND* %70, i32 0, i32 4, !dbg !1942
  %71 = load float, float* %dlength, align 4, !dbg !1942
  %72 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1943
  %ndiff52 = getelementptr inbounds %struct.BOND, %struct.BOND* %72, i32 0, i32 6, !dbg !1944
  %73 = load i32, i32* %ndiff52, align 4, !dbg !1944
  %conv53 = sitofp i32 %73 to float, !dbg !1943
  %div54 = fdiv float %71, %conv53, !dbg !1945
  %add55 = fadd float %69, %div54, !dbg !1946
  store float %add55, float* %length_eff, align 4, !dbg !1947
  br label %if.end56

if.end56:                                         ; preds = %if.else, %if.then46
  %74 = load float, float* %keff, align 4, !dbg !1948
  %75 = load float, float* %r, align 4, !dbg !1949
  %76 = load float, float* %length_eff, align 4, !dbg !1950
  %sub57 = fsub float %75, %76, !dbg !1951
  %mul58 = fmul float %74, %sub57, !dbg !1952
  %77 = load float, float* %r, align 4, !dbg !1953
  %78 = load float, float* %length_eff, align 4, !dbg !1954
  %sub59 = fsub float %77, %78, !dbg !1955
  %mul60 = fmul float %mul58, %sub59, !dbg !1956
  %79 = load float*, float** %V.addr, align 8, !dbg !1957
  %80 = load float, float* %79, align 4, !dbg !1958
  %add61 = fadd float %80, %mul60, !dbg !1958
  store float %add61, float* %79, align 4, !dbg !1958
  %81 = load %struct.__sFILE*, %struct.__sFILE** %op.addr, align 8, !dbg !1959
  %82 = load %struct.ATOM*, %struct.ATOM** %a1, align 8, !dbg !1960
  %serial62 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %82, i32 0, i32 8, !dbg !1961
  %83 = load i32, i32* %serial62, align 4, !dbg !1961
  %84 = load %struct.ATOM*, %struct.ATOM** %a2, align 8, !dbg !1962
  %serial63 = getelementptr inbounds %struct.ATOM, %struct.ATOM* %84, i32 0, i32 8, !dbg !1963
  %85 = load i32, i32* %serial63, align 4, !dbg !1963
  %86 = load float, float* %keff, align 4, !dbg !1964
  %87 = load float, float* %r, align 4, !dbg !1965
  %88 = load float, float* %length_eff, align 4, !dbg !1966
  %sub64 = fsub float %87, %88, !dbg !1967
  %mul65 = fmul float %86, %sub64, !dbg !1968
  %89 = load float, float* %r, align 4, !dbg !1969
  %90 = load float, float* %length_eff, align 4, !dbg !1970
  %sub66 = fsub float %89, %90, !dbg !1971
  %mul67 = fmul float %mul65, %sub66, !dbg !1972
  %conv68 = fpext float %mul67 to double, !dbg !1964
  %91 = load float, float* %r, align 4, !dbg !1973
  %conv69 = fpext float %91 to double, !dbg !1973
  %92 = load float, float* %keff, align 4, !dbg !1974
  %conv70 = fpext float %92 to double, !dbg !1974
  %93 = load float, float* %r, align 4, !dbg !1975
  %94 = load float, float* %length_eff, align 4, !dbg !1976
  %sub71 = fsub float %93, %94, !dbg !1977
  %conv72 = fpext float %sub71 to double, !dbg !1975
  %call73 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %81, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str3, i32 0, i32 0), i32 %83, i32 %85, double %conv68, double %conv69, double %conv70, double %conv72), !dbg !1978
  br label %if.end74, !dbg !1979

if.end74:                                         ; preds = %if.end56, %land.lhs.true16, %lor.lhs.false
  %95 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1980
  %96 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1982
  %next = getelementptr inbounds %struct.BOND, %struct.BOND* %96, i32 0, i32 7, !dbg !1983
  %97 = load i8*, i8** %next, align 8, !dbg !1983
  %98 = bitcast i8* %97 to %struct.BOND*, !dbg !1982
  %cmp75 = icmp eq %struct.BOND* %95, %98, !dbg !1984
  br i1 %cmp75, label %if.then77, label %if.end78, !dbg !1985

if.then77:                                        ; preds = %if.end74
  store i32 1, i32* %retval, !dbg !1986
  br label %return, !dbg !1986

if.end78:                                         ; preds = %if.end74
  %99 = load %struct.BOND*, %struct.BOND** %bp, align 8, !dbg !1987
  %next79 = getelementptr inbounds %struct.BOND, %struct.BOND* %99, i32 0, i32 7, !dbg !1988
  %100 = load i8*, i8** %next79, align 8, !dbg !1988
  %101 = bitcast i8* %100 to %struct.BOND*, !dbg !1987
  store %struct.BOND* %101, %struct.BOND** %bp, align 8, !dbg !1989
  br label %while.body, !dbg !1824

return:                                           ; preds = %if.then77, %if.then6, %if.then2, %if.then
  %102 = load i32, i32* %retval, !dbg !1990
  ret i32 %102, !dbg !1990
}

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!181, !182, !183}
!llvm.ident = !{!184}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !5, globals: !163, imports: !2)
!1 = !MDFile(filename: "ammp-master/abc.c", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64, align: 64)
!5 = !{!6, !11, !15, !18, !19, !96, !160}
!6 = !MDSubprogram(name: "abc", scope: !1, file: !1, line: 82, type: !7, isLocal: false, isDefinition: true, scopeLine: 85, isOptimized: false, function: i32 (i32, i32, i32, double, double, double, double, double)* @abc, variables: !2)
!7 = !MDSubroutineType(types: !8)
!8 = !{!9, !9, !9, !9, !10, !10, !10, !10, !10}
!9 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!10 = !MDBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!11 = !MDSubprogram(name: "v_abc", scope: !1, file: !1, line: 130, type: !12, isLocal: false, isDefinition: true, scopeLine: 132, isOptimized: false, function: i32 (float*, double)* @v_abc, variables: !2)
!12 = !MDSubroutineType(types: !13)
!13 = !{!9, !14, !10}
!14 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64, align: 64)
!15 = !MDSubprogram(name: "do_abc", scope: !1, file: !1, line: 180, type: !16, isLocal: false, isDefinition: true, scopeLine: 182, isOptimized: false, function: i32 (double)* @do_abc, variables: !2)
!16 = !MDSubroutineType(types: !17)
!17 = !{!9, !10}
!18 = !MDSubprogram(name: "f_abc", scope: !1, file: !1, line: 257, type: !16, isLocal: false, isDefinition: true, scopeLine: 260, isOptimized: false, function: i32 (double)* @f_abc, variables: !2)
!19 = !MDSubprogram(name: "get_abc", scope: !1, file: !1, line: 415, type: !20, isLocal: false, isDefinition: true, scopeLine: 418, isOptimized: false, function: void (%struct.ATOM*, %struct.ATOM**, i32, i32*)* @get_abc, variables: !2)
!20 = !MDSubroutineType(types: !21)
!21 = !{null, !22, !94, !9, !95}
!22 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64, align: 64)
!23 = !MDDerivedType(tag: DW_TAG_typedef, name: "ATOM", file: !24, line: 97, baseType: !25)
!24 = !MDFile(filename: "ammp-master/ammp.h", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!25 = !MDCompositeType(tag: DW_TAG_structure_type, file: !24, line: 52, size: 32128, align: 64, elements: !26)
!26 = !{!27, !28, !29, !30, !31, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !46, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !87, !91, !93}
!27 = !MDDerivedType(tag: DW_TAG_member, name: "x", scope: !25, file: !24, line: 53, baseType: !10, size: 32, align: 32)
!28 = !MDDerivedType(tag: DW_TAG_member, name: "y", scope: !25, file: !24, line: 53, baseType: !10, size: 32, align: 32, offset: 32)
!29 = !MDDerivedType(tag: DW_TAG_member, name: "z", scope: !25, file: !24, line: 53, baseType: !10, size: 32, align: 32, offset: 64)
!30 = !MDDerivedType(tag: DW_TAG_member, name: "w", scope: !25, file: !24, line: 53, baseType: !10, size: 32, align: 32, offset: 96)
!31 = !MDDerivedType(tag: DW_TAG_member, name: "fx", scope: !25, file: !24, line: 54, baseType: !32, size: 64, align: 64, offset: 128)
!32 = !MDBasicType(name: "double", size: 64, align: 64, encoding: DW_ATE_float)
!33 = !MDDerivedType(tag: DW_TAG_member, name: "fy", scope: !25, file: !24, line: 54, baseType: !32, size: 64, align: 64, offset: 192)
!34 = !MDDerivedType(tag: DW_TAG_member, name: "fz", scope: !25, file: !24, line: 54, baseType: !32, size: 64, align: 64, offset: 256)
!35 = !MDDerivedType(tag: DW_TAG_member, name: "fw", scope: !25, file: !24, line: 54, baseType: !32, size: 64, align: 64, offset: 320)
!36 = !MDDerivedType(tag: DW_TAG_member, name: "serial", scope: !25, file: !24, line: 55, baseType: !9, size: 32, align: 32, offset: 384)
!37 = !MDDerivedType(tag: DW_TAG_member, name: "q", scope: !25, file: !24, line: 56, baseType: !10, size: 32, align: 32, offset: 416)
!38 = !MDDerivedType(tag: DW_TAG_member, name: "a", scope: !25, file: !24, line: 56, baseType: !10, size: 32, align: 32, offset: 448)
!39 = !MDDerivedType(tag: DW_TAG_member, name: "b", scope: !25, file: !24, line: 56, baseType: !10, size: 32, align: 32, offset: 480)
!40 = !MDDerivedType(tag: DW_TAG_member, name: "mass", scope: !25, file: !24, line: 56, baseType: !10, size: 32, align: 32, offset: 512)
!41 = !MDDerivedType(tag: DW_TAG_member, name: "na", scope: !25, file: !24, line: 57, baseType: !10, size: 32, align: 32, offset: 544)
!42 = !MDDerivedType(tag: DW_TAG_member, name: "rdebye", scope: !25, file: !24, line: 58, baseType: !10, size: 32, align: 32, offset: 576)
!43 = !MDDerivedType(tag: DW_TAG_member, name: "next", scope: !25, file: !24, line: 59, baseType: !4, size: 64, align: 64, offset: 640)
!44 = !MDDerivedType(tag: DW_TAG_member, name: "active", scope: !25, file: !24, line: 60, baseType: !45, size: 8, align: 8, offset: 704)
!45 = !MDBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!46 = !MDDerivedType(tag: DW_TAG_member, name: "name", scope: !25, file: !24, line: 61, baseType: !47, size: 72, align: 8, offset: 712)
!47 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !45, size: 72, align: 8, elements: !48)
!48 = !{!49}
!49 = !MDSubrange(count: 9)
!50 = !MDDerivedType(tag: DW_TAG_member, name: "chi", scope: !25, file: !24, line: 62, baseType: !10, size: 32, align: 32, offset: 800)
!51 = !MDDerivedType(tag: DW_TAG_member, name: "jaa", scope: !25, file: !24, line: 62, baseType: !10, size: 32, align: 32, offset: 832)
!52 = !MDDerivedType(tag: DW_TAG_member, name: "vx", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 864)
!53 = !MDDerivedType(tag: DW_TAG_member, name: "vy", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 896)
!54 = !MDDerivedType(tag: DW_TAG_member, name: "vz", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 928)
!55 = !MDDerivedType(tag: DW_TAG_member, name: "vw", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 960)
!56 = !MDDerivedType(tag: DW_TAG_member, name: "dx", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 992)
!57 = !MDDerivedType(tag: DW_TAG_member, name: "dy", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 1024)
!58 = !MDDerivedType(tag: DW_TAG_member, name: "dz", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 1056)
!59 = !MDDerivedType(tag: DW_TAG_member, name: "dw", scope: !25, file: !24, line: 63, baseType: !10, size: 32, align: 32, offset: 1088)
!60 = !MDDerivedType(tag: DW_TAG_member, name: "gx", scope: !25, file: !24, line: 64, baseType: !10, size: 32, align: 32, offset: 1120)
!61 = !MDDerivedType(tag: DW_TAG_member, name: "gy", scope: !25, file: !24, line: 64, baseType: !10, size: 32, align: 32, offset: 1152)
!62 = !MDDerivedType(tag: DW_TAG_member, name: "gz", scope: !25, file: !24, line: 64, baseType: !10, size: 32, align: 32, offset: 1184)
!63 = !MDDerivedType(tag: DW_TAG_member, name: "gw", scope: !25, file: !24, line: 64, baseType: !10, size: 32, align: 32, offset: 1216)
!64 = !MDDerivedType(tag: DW_TAG_member, name: "VP", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1248)
!65 = !MDDerivedType(tag: DW_TAG_member, name: "px", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1280)
!66 = !MDDerivedType(tag: DW_TAG_member, name: "py", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1312)
!67 = !MDDerivedType(tag: DW_TAG_member, name: "pz", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1344)
!68 = !MDDerivedType(tag: DW_TAG_member, name: "pw", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1376)
!69 = !MDDerivedType(tag: DW_TAG_member, name: "dpx", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1408)
!70 = !MDDerivedType(tag: DW_TAG_member, name: "dpy", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1440)
!71 = !MDDerivedType(tag: DW_TAG_member, name: "dpz", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1472)
!72 = !MDDerivedType(tag: DW_TAG_member, name: "dpw", scope: !25, file: !24, line: 65, baseType: !10, size: 32, align: 32, offset: 1504)
!73 = !MDDerivedType(tag: DW_TAG_member, name: "qxx", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1536)
!74 = !MDDerivedType(tag: DW_TAG_member, name: "qxy", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1568)
!75 = !MDDerivedType(tag: DW_TAG_member, name: "qxz", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1600)
!76 = !MDDerivedType(tag: DW_TAG_member, name: "qyy", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1632)
!77 = !MDDerivedType(tag: DW_TAG_member, name: "qyz", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1664)
!78 = !MDDerivedType(tag: DW_TAG_member, name: "qzz", scope: !25, file: !24, line: 68, baseType: !10, size: 32, align: 32, offset: 1696)
!79 = !MDDerivedType(tag: DW_TAG_member, name: "qxw", scope: !25, file: !24, line: 69, baseType: !10, size: 32, align: 32, offset: 1728)
!80 = !MDDerivedType(tag: DW_TAG_member, name: "qyw", scope: !25, file: !24, line: 69, baseType: !10, size: 32, align: 32, offset: 1760)
!81 = !MDDerivedType(tag: DW_TAG_member, name: "qzw", scope: !25, file: !24, line: 69, baseType: !10, size: 32, align: 32, offset: 1792)
!82 = !MDDerivedType(tag: DW_TAG_member, name: "qww", scope: !25, file: !24, line: 69, baseType: !10, size: 32, align: 32, offset: 1824)
!83 = !MDDerivedType(tag: DW_TAG_member, name: "close", scope: !25, file: !24, line: 86, baseType: !84, size: 25600, align: 64, offset: 1856)
!84 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !4, size: 25600, align: 64, elements: !85)
!85 = !{!86}
!86 = !MDSubrange(count: 400)
!87 = !MDDerivedType(tag: DW_TAG_member, name: "excluded", scope: !25, file: !24, line: 87, baseType: !88, size: 4096, align: 64, offset: 27456)
!88 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !4, size: 4096, align: 64, elements: !89)
!89 = !{!90}
!90 = !MDSubrange(count: 64)
!91 = !MDDerivedType(tag: DW_TAG_member, name: "exkind", scope: !25, file: !24, line: 88, baseType: !92, size: 512, align: 8, offset: 31552)
!92 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !45, size: 512, align: 8, elements: !89)
!93 = !MDDerivedType(tag: DW_TAG_member, name: "dontuse", scope: !25, file: !24, line: 96, baseType: !9, size: 32, align: 32, offset: 32064)
!94 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64, align: 64)
!95 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64, align: 64)
!96 = !MDSubprogram(name: "dump_abcs", scope: !1, file: !1, line: 447, type: !97, isLocal: false, isDefinition: true, scopeLine: 449, isOptimized: false, function: void (%struct.__sFILE*)* @dump_abcs, variables: !2)
!97 = !MDSubroutineType(types: !98)
!98 = !{null, !99}
!99 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64, align: 64)
!100 = !MDDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !101, line: 153, baseType: !102)
!101 = !MDFile(filename: "/usr/include/stdio.h", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!102 = !MDCompositeType(tag: DW_TAG_structure_type, name: "__sFILE", file: !101, line: 122, size: 1216, align: 64, elements: !103)
!103 = !{!104, !107, !108, !109, !111, !112, !117, !118, !119, !123, !128, !138, !144, !145, !148, !149, !153, !157, !158, !159}
!104 = !MDDerivedType(tag: DW_TAG_member, name: "_p", scope: !102, file: !101, line: 123, baseType: !105, size: 64, align: 64)
!105 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64, align: 64)
!106 = !MDBasicType(name: "unsigned char", size: 8, align: 8, encoding: DW_ATE_unsigned_char)
!107 = !MDDerivedType(tag: DW_TAG_member, name: "_r", scope: !102, file: !101, line: 124, baseType: !9, size: 32, align: 32, offset: 64)
!108 = !MDDerivedType(tag: DW_TAG_member, name: "_w", scope: !102, file: !101, line: 125, baseType: !9, size: 32, align: 32, offset: 96)
!109 = !MDDerivedType(tag: DW_TAG_member, name: "_flags", scope: !102, file: !101, line: 126, baseType: !110, size: 16, align: 16, offset: 128)
!110 = !MDBasicType(name: "short", size: 16, align: 16, encoding: DW_ATE_signed)
!111 = !MDDerivedType(tag: DW_TAG_member, name: "_file", scope: !102, file: !101, line: 127, baseType: !110, size: 16, align: 16, offset: 144)
!112 = !MDDerivedType(tag: DW_TAG_member, name: "_bf", scope: !102, file: !101, line: 128, baseType: !113, size: 128, align: 64, offset: 192)
!113 = !MDCompositeType(tag: DW_TAG_structure_type, name: "__sbuf", file: !101, line: 88, size: 128, align: 64, elements: !114)
!114 = !{!115, !116}
!115 = !MDDerivedType(tag: DW_TAG_member, name: "_base", scope: !113, file: !101, line: 89, baseType: !105, size: 64, align: 64)
!116 = !MDDerivedType(tag: DW_TAG_member, name: "_size", scope: !113, file: !101, line: 90, baseType: !9, size: 32, align: 32, offset: 64)
!117 = !MDDerivedType(tag: DW_TAG_member, name: "_lbfsize", scope: !102, file: !101, line: 129, baseType: !9, size: 32, align: 32, offset: 320)
!118 = !MDDerivedType(tag: DW_TAG_member, name: "_cookie", scope: !102, file: !101, line: 132, baseType: !4, size: 64, align: 64, offset: 384)
!119 = !MDDerivedType(tag: DW_TAG_member, name: "_close", scope: !102, file: !101, line: 133, baseType: !120, size: 64, align: 64, offset: 448)
!120 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64, align: 64)
!121 = !MDSubroutineType(types: !122)
!122 = !{!9, !4}
!123 = !MDDerivedType(tag: DW_TAG_member, name: "_read", scope: !102, file: !101, line: 134, baseType: !124, size: 64, align: 64, offset: 512)
!124 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64, align: 64)
!125 = !MDSubroutineType(types: !126)
!126 = !{!9, !4, !127, !9}
!127 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64, align: 64)
!128 = !MDDerivedType(tag: DW_TAG_member, name: "_seek", scope: !102, file: !101, line: 135, baseType: !129, size: 64, align: 64, offset: 576)
!129 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64, align: 64)
!130 = !MDSubroutineType(types: !131)
!131 = !{!132, !4, !132, !9}
!132 = !MDDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !101, line: 77, baseType: !133)
!133 = !MDDerivedType(tag: DW_TAG_typedef, name: "__darwin_off_t", file: !134, line: 71, baseType: !135)
!134 = !MDFile(filename: "/usr/include/sys/_types.h", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!135 = !MDDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !136, line: 46, baseType: !137)
!136 = !MDFile(filename: "/usr/include/i386/_types.h", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!137 = !MDBasicType(name: "long long int", size: 64, align: 64, encoding: DW_ATE_signed)
!138 = !MDDerivedType(tag: DW_TAG_member, name: "_write", scope: !102, file: !101, line: 136, baseType: !139, size: 64, align: 64, offset: 640)
!139 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64, align: 64)
!140 = !MDSubroutineType(types: !141)
!141 = !{!9, !4, !142, !9}
!142 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64, align: 64)
!143 = !MDDerivedType(tag: DW_TAG_const_type, baseType: !45)
!144 = !MDDerivedType(tag: DW_TAG_member, name: "_ub", scope: !102, file: !101, line: 139, baseType: !113, size: 128, align: 64, offset: 704)
!145 = !MDDerivedType(tag: DW_TAG_member, name: "_extra", scope: !102, file: !101, line: 140, baseType: !146, size: 64, align: 64, offset: 832)
!146 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64, align: 64)
!147 = !MDCompositeType(tag: DW_TAG_structure_type, name: "__sFILEX", file: !101, line: 94, flags: DIFlagFwdDecl)
!148 = !MDDerivedType(tag: DW_TAG_member, name: "_ur", scope: !102, file: !101, line: 141, baseType: !9, size: 32, align: 32, offset: 896)
!149 = !MDDerivedType(tag: DW_TAG_member, name: "_ubuf", scope: !102, file: !101, line: 144, baseType: !150, size: 24, align: 8, offset: 928)
!150 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !106, size: 24, align: 8, elements: !151)
!151 = !{!152}
!152 = !MDSubrange(count: 3)
!153 = !MDDerivedType(tag: DW_TAG_member, name: "_nbuf", scope: !102, file: !101, line: 145, baseType: !154, size: 8, align: 8, offset: 952)
!154 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !106, size: 8, align: 8, elements: !155)
!155 = !{!156}
!156 = !MDSubrange(count: 1)
!157 = !MDDerivedType(tag: DW_TAG_member, name: "_lb", scope: !102, file: !101, line: 148, baseType: !113, size: 128, align: 64, offset: 960)
!158 = !MDDerivedType(tag: DW_TAG_member, name: "_blksize", scope: !102, file: !101, line: 151, baseType: !9, size: 32, align: 32, offset: 1088)
!159 = !MDDerivedType(tag: DW_TAG_member, name: "_offset", scope: !102, file: !101, line: 152, baseType: !132, size: 64, align: 64, offset: 1152)
!160 = !MDSubprogram(name: "a_abc", scope: !1, file: !1, line: 478, type: !161, isLocal: false, isDefinition: true, scopeLine: 482, isOptimized: false, function: i32 (float*, double, i32, i32, %struct.__sFILE*)* @a_abc, variables: !2)
!161 = !MDSubroutineType(types: !162)
!162 = !{!9, !14, !10, !9, !9, !99}
!163 = !{!164, !180}
!164 = !MDGlobalVariable(name: "abc_first", scope: !0, file: !1, line: 73, type: !165, isLocal: false, isDefinition: true, variable: %struct.ABC** @abc_first)
!165 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 64, align: 64)
!166 = !MDDerivedType(tag: DW_TAG_typedef, name: "ABC", file: !1, line: 70, baseType: !167)
!167 = !MDCompositeType(tag: DW_TAG_structure_type, file: !1, line: 65, size: 576, align: 64, elements: !168)
!168 = !{!169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179}
!169 = !MDDerivedType(tag: DW_TAG_member, name: "atom1", scope: !167, file: !1, line: 66, baseType: !22, size: 64, align: 64)
!170 = !MDDerivedType(tag: DW_TAG_member, name: "atom2", scope: !167, file: !1, line: 66, baseType: !22, size: 64, align: 64, offset: 64)
!171 = !MDDerivedType(tag: DW_TAG_member, name: "atom3", scope: !167, file: !1, line: 66, baseType: !22, size: 64, align: 64, offset: 128)
!172 = !MDDerivedType(tag: DW_TAG_member, name: "theta", scope: !167, file: !1, line: 67, baseType: !10, size: 32, align: 32, offset: 192)
!173 = !MDDerivedType(tag: DW_TAG_member, name: "thetazero", scope: !167, file: !1, line: 67, baseType: !10, size: 32, align: 32, offset: 224)
!174 = !MDDerivedType(tag: DW_TAG_member, name: "dr", scope: !167, file: !1, line: 67, baseType: !10, size: 32, align: 32, offset: 256)
!175 = !MDDerivedType(tag: DW_TAG_member, name: "dk1", scope: !167, file: !1, line: 67, baseType: !10, size: 32, align: 32, offset: 288)
!176 = !MDDerivedType(tag: DW_TAG_member, name: "dk2", scope: !167, file: !1, line: 67, baseType: !10, size: 32, align: 32, offset: 320)
!177 = !MDDerivedType(tag: DW_TAG_member, name: "b1", scope: !167, file: !1, line: 68, baseType: !4, size: 64, align: 64, offset: 384)
!178 = !MDDerivedType(tag: DW_TAG_member, name: "b2", scope: !167, file: !1, line: 68, baseType: !4, size: 64, align: 64, offset: 448)
!179 = !MDDerivedType(tag: DW_TAG_member, name: "next", scope: !167, file: !1, line: 69, baseType: !4, size: 64, align: 64, offset: 512)
!180 = !MDGlobalVariable(name: "abc_last", scope: !0, file: !1, line: 74, type: !165, isLocal: false, isDefinition: true, variable: %struct.ABC** @abc_last)
!181 = !{i32 2, !"Dwarf Version", i32 2}
!182 = !{i32 2, !"Debug Info Version", i32 3}
!183 = !{i32 1, !"PIC Level", i32 2}
!184 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!185 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "p1", arg: 1, scope: !6, file: !1, line: 83, type: !9)
!186 = !MDExpression()
!187 = !MDLocation(line: 83, column: 5, scope: !6)
!188 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "p2", arg: 2, scope: !6, file: !1, line: 83, type: !9)
!189 = !MDLocation(line: 83, column: 8, scope: !6)
!190 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "p3", arg: 3, scope: !6, file: !1, line: 83, type: !9)
!191 = !MDLocation(line: 83, column: 11, scope: !6)
!192 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "theta", arg: 4, scope: !6, file: !1, line: 84, type: !10)
!193 = !MDLocation(line: 84, column: 7, scope: !6)
!194 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "thetazero", arg: 5, scope: !6, file: !1, line: 84, type: !10)
!195 = !MDLocation(line: 84, column: 14, scope: !6)
!196 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "dr", arg: 6, scope: !6, file: !1, line: 84, type: !10)
!197 = !MDLocation(line: 84, column: 24, scope: !6)
!198 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "dk1", arg: 7, scope: !6, file: !1, line: 84, type: !10)
!199 = !MDLocation(line: 84, column: 27, scope: !6)
!200 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "dk2", arg: 8, scope: !6, file: !1, line: 84, type: !10)
!201 = !MDLocation(line: 84, column: 31, scope: !6)
!202 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "new", scope: !6, file: !1, line: 86, type: !165)
!203 = !MDLocation(line: 86, column: 10, scope: !6)
!204 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ap1", scope: !6, file: !1, line: 87, type: !22)
!205 = !MDLocation(line: 87, column: 11, scope: !6)
!206 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ap2", scope: !6, file: !1, line: 87, type: !22)
!207 = !MDLocation(line: 87, column: 16, scope: !6)
!208 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ap3", scope: !6, file: !1, line: 87, type: !22)
!209 = !MDLocation(line: 87, column: 21, scope: !6)
!210 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "line", scope: !6, file: !1, line: 88, type: !211)
!211 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !45, size: 640, align: 8, elements: !212)
!212 = !{!213}
!213 = !MDSubrange(count: 80)
!214 = !MDLocation(line: 88, column: 10, scope: !6)
!215 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !6, file: !1, line: 89, type: !9)
!216 = !MDLocation(line: 89, column: 9, scope: !6)
!217 = !MDLocation(line: 91, column: 23, scope: !6)
!218 = !MDLocation(line: 91, column: 11, scope: !6)
!219 = !MDLocation(line: 91, column: 9, scope: !6)
!220 = !MDLocation(line: 92, column: 23, scope: !6)
!221 = !MDLocation(line: 92, column: 11, scope: !6)
!222 = !MDLocation(line: 92, column: 9, scope: !6)
!223 = !MDLocation(line: 93, column: 23, scope: !6)
!224 = !MDLocation(line: 93, column: 11, scope: !6)
!225 = !MDLocation(line: 93, column: 9, scope: !6)
!226 = !MDLocation(line: 94, column: 10, scope: !227)
!227 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 94, column: 9)
!228 = !MDLocation(line: 94, column: 14, scope: !227)
!229 = !MDLocation(line: 94, column: 23, scope: !227)
!230 = !MDLocation(line: 94, column: 27, scope: !227)
!231 = !MDLocation(line: 94, column: 31, scope: !227)
!232 = !MDLocation(line: 94, column: 40, scope: !227)
!233 = !MDLocation(line: 94, column: 44, scope: !227)
!234 = !MDLocation(line: 94, column: 47, scope: !227)
!235 = !MDLocation(line: 94, column: 9, scope: !6)
!236 = !MDLocation(line: 96, column: 9, scope: !237)
!237 = distinct !MDLexicalBlock(scope: !227, file: !1, line: 95, column: 5)
!238 = !MDLocation(line: 97, column: 18, scope: !237)
!239 = !MDLocation(line: 97, column: 9, scope: !237)
!240 = !MDLocation(line: 98, column: 9, scope: !237)
!241 = !MDLocation(line: 101, column: 17, scope: !242)
!242 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 101, column: 9)
!243 = !MDLocation(line: 101, column: 15, scope: !242)
!244 = !MDLocation(line: 101, column: 35, scope: !242)
!245 = !MDLocation(line: 101, column: 9, scope: !6)
!246 = !MDLocation(line: 103, column: 9, scope: !247)
!247 = distinct !MDLexicalBlock(scope: !242, file: !1, line: 102, column: 5)
!248 = !MDLocation(line: 106, column: 9, scope: !249)
!249 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 106, column: 9)
!250 = !MDLocation(line: 106, column: 19, scope: !249)
!251 = !MDLocation(line: 106, column: 9, scope: !6)
!252 = !MDLocation(line: 106, column: 40, scope: !249)
!253 = !MDLocation(line: 106, column: 38, scope: !249)
!254 = !MDLocation(line: 106, column: 28, scope: !249)
!255 = !MDLocation(line: 107, column: 9, scope: !256)
!256 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 107, column: 9)
!257 = !MDLocation(line: 107, column: 18, scope: !256)
!258 = !MDLocation(line: 107, column: 9, scope: !6)
!259 = !MDLocation(line: 107, column: 38, scope: !256)
!260 = !MDLocation(line: 107, column: 36, scope: !256)
!261 = !MDLocation(line: 107, column: 27, scope: !256)
!262 = !MDLocation(line: 108, column: 20, scope: !6)
!263 = !MDLocation(line: 108, column: 5, scope: !6)
!264 = !MDLocation(line: 108, column: 12, scope: !6)
!265 = !MDLocation(line: 108, column: 18, scope: !6)
!266 = !MDLocation(line: 109, column: 20, scope: !6)
!267 = !MDLocation(line: 109, column: 5, scope: !6)
!268 = !MDLocation(line: 109, column: 12, scope: !6)
!269 = !MDLocation(line: 109, column: 18, scope: !6)
!270 = !MDLocation(line: 110, column: 20, scope: !6)
!271 = !MDLocation(line: 110, column: 5, scope: !6)
!272 = !MDLocation(line: 110, column: 12, scope: !6)
!273 = !MDLocation(line: 110, column: 18, scope: !6)
!274 = !MDLocation(line: 111, column: 17, scope: !6)
!275 = !MDLocation(line: 111, column: 5, scope: !6)
!276 = !MDLocation(line: 111, column: 12, scope: !6)
!277 = !MDLocation(line: 111, column: 15, scope: !6)
!278 = !MDLocation(line: 112, column: 20, scope: !6)
!279 = !MDLocation(line: 112, column: 5, scope: !6)
!280 = !MDLocation(line: 112, column: 12, scope: !6)
!281 = !MDLocation(line: 112, column: 18, scope: !6)
!282 = !MDLocation(line: 113, column: 24, scope: !6)
!283 = !MDLocation(line: 113, column: 5, scope: !6)
!284 = !MDLocation(line: 113, column: 12, scope: !6)
!285 = !MDLocation(line: 113, column: 22, scope: !6)
!286 = !MDLocation(line: 114, column: 19, scope: !6)
!287 = !MDLocation(line: 114, column: 5, scope: !6)
!288 = !MDLocation(line: 114, column: 12, scope: !6)
!289 = !MDLocation(line: 114, column: 16, scope: !6)
!290 = !MDLocation(line: 115, column: 19, scope: !6)
!291 = !MDLocation(line: 115, column: 5, scope: !6)
!292 = !MDLocation(line: 115, column: 12, scope: !6)
!293 = !MDLocation(line: 115, column: 16, scope: !6)
!294 = !MDLocation(line: 116, column: 5, scope: !6)
!295 = !MDLocation(line: 116, column: 11, scope: !6)
!296 = !MDLocation(line: 116, column: 14, scope: !6)
!297 = !MDLocation(line: 116, column: 23, scope: !6)
!298 = !MDLocation(line: 116, column: 28, scope: !6)
!299 = !MDLocation(line: 116, column: 31, scope: !6)
!300 = !MDLocation(line: 117, column: 19, scope: !6)
!301 = !MDLocation(line: 117, column: 5, scope: !6)
!302 = !MDLocation(line: 117, column: 12, scope: !6)
!303 = !MDLocation(line: 117, column: 17, scope: !6)
!304 = !MDLocation(line: 118, column: 24, scope: !6)
!305 = !MDLocation(line: 118, column: 5, scope: !6)
!306 = !MDLocation(line: 118, column: 17, scope: !6)
!307 = !MDLocation(line: 118, column: 22, scope: !6)
!308 = !MDLocation(line: 119, column: 16, scope: !6)
!309 = !MDLocation(line: 119, column: 14, scope: !6)
!310 = !MDLocation(line: 120, column: 5, scope: !6)
!311 = !MDLocation(line: 121, column: 1, scope: !6)
!312 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "V", arg: 1, scope: !11, file: !1, line: 131, type: !14)
!313 = !MDLocation(line: 131, column: 8, scope: !11)
!314 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "lambda", arg: 2, scope: !11, file: !1, line: 131, type: !10)
!315 = !MDLocation(line: 131, column: 10, scope: !11)
!316 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "abcp", scope: !11, file: !1, line: 133, type: !165)
!317 = !MDLocation(line: 133, column: 10, scope: !11)
!318 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "bp", scope: !11, file: !1, line: 134, type: !319)
!319 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !320, size: 64, align: 64)
!320 = !MDDerivedType(tag: DW_TAG_typedef, name: "BOND", file: !1, line: 61, baseType: !321)
!321 = !MDCompositeType(tag: DW_TAG_structure_type, file: !1, line: 55, size: 384, align: 64, elements: !322)
!322 = !{!323, !324, !325, !326, !327, !328, !329, !330}
!323 = !MDDerivedType(tag: DW_TAG_member, name: "atom1", scope: !321, file: !1, line: 56, baseType: !22, size: 64, align: 64)
!324 = !MDDerivedType(tag: DW_TAG_member, name: "atom2", scope: !321, file: !1, line: 56, baseType: !22, size: 64, align: 64, offset: 64)
!325 = !MDDerivedType(tag: DW_TAG_member, name: "length", scope: !321, file: !1, line: 57, baseType: !10, size: 32, align: 32, offset: 128)
!326 = !MDDerivedType(tag: DW_TAG_member, name: "k", scope: !321, file: !1, line: 57, baseType: !10, size: 32, align: 32, offset: 160)
!327 = !MDDerivedType(tag: DW_TAG_member, name: "dlength", scope: !321, file: !1, line: 58, baseType: !10, size: 32, align: 32, offset: 192)
!328 = !MDDerivedType(tag: DW_TAG_member, name: "dk", scope: !321, file: !1, line: 58, baseType: !10, size: 32, align: 32, offset: 224)
!329 = !MDDerivedType(tag: DW_TAG_member, name: "ndiff", scope: !321, file: !1, line: 59, baseType: !9, size: 32, align: 32, offset: 256)
!330 = !MDDerivedType(tag: DW_TAG_member, name: "next", scope: !321, file: !1, line: 60, baseType: !4, size: 64, align: 64, offset: 320)
!331 = !MDLocation(line: 134, column: 11, scope: !11)
!332 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r", scope: !11, file: !1, line: 135, type: !10)
!333 = !MDLocation(line: 135, column: 11, scope: !11)
!334 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !11, file: !1, line: 135, type: !10)
!335 = !MDLocation(line: 135, column: 13, scope: !11)
!336 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y1", scope: !11, file: !1, line: 135, type: !10)
!337 = !MDLocation(line: 135, column: 16, scope: !11)
!338 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z1", scope: !11, file: !1, line: 135, type: !10)
!339 = !MDLocation(line: 135, column: 19, scope: !11)
!340 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "keff", scope: !11, file: !1, line: 136, type: !10)
!341 = !MDLocation(line: 136, column: 11, scope: !11)
!342 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "length_eff", scope: !11, file: !1, line: 136, type: !10)
!343 = !MDLocation(line: 136, column: 16, scope: !11)
!344 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a1", scope: !11, file: !1, line: 137, type: !22)
!345 = !MDLocation(line: 137, column: 11, scope: !11)
!346 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a2", scope: !11, file: !1, line: 137, type: !22)
!347 = !MDLocation(line: 137, column: 15, scope: !11)
!348 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a3", scope: !11, file: !1, line: 137, type: !22)
!349 = !MDLocation(line: 137, column: 19, scope: !11)
!350 = !MDLocation(line: 140, column: 12, scope: !11)
!351 = !MDLocation(line: 140, column: 10, scope: !11)
!352 = !MDLocation(line: 141, column: 9, scope: !353)
!353 = distinct !MDLexicalBlock(scope: !11, file: !1, line: 141, column: 9)
!354 = !MDLocation(line: 141, column: 14, scope: !353)
!355 = !MDLocation(line: 141, column: 9, scope: !11)
!356 = !MDLocation(line: 141, column: 40, scope: !357)
!357 = distinct !MDLexicalBlock(scope: !353, file: !1, line: 141, column: 23)
!358 = !MDLocation(line: 141, column: 42, scope: !357)
!359 = !MDLocation(line: 141, column: 32, scope: !357)
!360 = !MDLocation(line: 141, column: 25, scope: !357)
!361 = !MDLocation(line: 142, column: 10, scope: !11)
!362 = !MDLocation(line: 142, column: 8, scope: !11)
!363 = !MDLocation(line: 143, column: 9, scope: !364)
!364 = distinct !MDLexicalBlock(scope: !11, file: !1, line: 143, column: 9)
!365 = !MDLocation(line: 143, column: 12, scope: !364)
!366 = !MDLocation(line: 143, column: 9, scope: !11)
!367 = !MDLocation(line: 143, column: 22, scope: !364)
!368 = !MDLocation(line: 145, column: 13, scope: !11)
!369 = !MDLocation(line: 145, column: 5, scope: !11)
!370 = !MDLocation(line: 148, column: 5, scope: !11)
!371 = !MDLocation(line: 150, column: 12, scope: !372)
!372 = distinct !MDLexicalBlock(scope: !373, file: !1, line: 150, column: 12)
!373 = distinct !MDLexicalBlock(scope: !11, file: !1, line: 149, column: 5)
!374 = !MDLocation(line: 150, column: 15, scope: !372)
!375 = !MDLocation(line: 150, column: 12, scope: !373)
!376 = !MDLocation(line: 150, column: 24, scope: !372)
!377 = !MDLocation(line: 151, column: 14, scope: !373)
!378 = !MDLocation(line: 151, column: 18, scope: !373)
!379 = !MDLocation(line: 151, column: 12, scope: !373)
!380 = !MDLocation(line: 151, column: 30, scope: !373)
!381 = !MDLocation(line: 151, column: 34, scope: !373)
!382 = !MDLocation(line: 151, column: 28, scope: !373)
!383 = !MDLocation(line: 152, column: 13, scope: !384)
!384 = distinct !MDLexicalBlock(scope: !373, file: !1, line: 152, column: 13)
!385 = !MDLocation(line: 152, column: 17, scope: !384)
!386 = !MDLocation(line: 152, column: 24, scope: !384)
!387 = !MDLocation(line: 152, column: 27, scope: !384)
!388 = !MDLocation(line: 152, column: 31, scope: !384)
!389 = !MDLocation(line: 152, column: 13, scope: !373)
!390 = !MDLocation(line: 153, column: 19, scope: !391)
!391 = distinct !MDLexicalBlock(scope: !384, file: !1, line: 152, column: 40)
!392 = !MDLocation(line: 153, column: 23, scope: !391)
!393 = !MDLocation(line: 153, column: 26, scope: !391)
!394 = !MDLocation(line: 153, column: 30, scope: !391)
!395 = !MDLocation(line: 153, column: 25, scope: !391)
!396 = !MDLocation(line: 153, column: 33, scope: !391)
!397 = !MDLocation(line: 153, column: 41, scope: !391)
!398 = !MDLocation(line: 153, column: 45, scope: !391)
!399 = !MDLocation(line: 153, column: 48, scope: !391)
!400 = !MDLocation(line: 153, column: 52, scope: !391)
!401 = !MDLocation(line: 153, column: 47, scope: !391)
!402 = !MDLocation(line: 153, column: 39, scope: !391)
!403 = !MDLocation(line: 153, column: 32, scope: !391)
!404 = !MDLocation(line: 153, column: 16, scope: !391)
!405 = !MDLocation(line: 154, column: 19, scope: !391)
!406 = !MDLocation(line: 154, column: 23, scope: !391)
!407 = !MDLocation(line: 154, column: 26, scope: !391)
!408 = !MDLocation(line: 154, column: 30, scope: !391)
!409 = !MDLocation(line: 154, column: 25, scope: !391)
!410 = !MDLocation(line: 154, column: 33, scope: !391)
!411 = !MDLocation(line: 154, column: 41, scope: !391)
!412 = !MDLocation(line: 154, column: 45, scope: !391)
!413 = !MDLocation(line: 154, column: 48, scope: !391)
!414 = !MDLocation(line: 154, column: 52, scope: !391)
!415 = !MDLocation(line: 154, column: 47, scope: !391)
!416 = !MDLocation(line: 154, column: 39, scope: !391)
!417 = !MDLocation(line: 154, column: 32, scope: !391)
!418 = !MDLocation(line: 154, column: 16, scope: !391)
!419 = !MDLocation(line: 155, column: 19, scope: !391)
!420 = !MDLocation(line: 155, column: 23, scope: !391)
!421 = !MDLocation(line: 155, column: 26, scope: !391)
!422 = !MDLocation(line: 155, column: 30, scope: !391)
!423 = !MDLocation(line: 155, column: 25, scope: !391)
!424 = !MDLocation(line: 155, column: 33, scope: !391)
!425 = !MDLocation(line: 155, column: 41, scope: !391)
!426 = !MDLocation(line: 155, column: 45, scope: !391)
!427 = !MDLocation(line: 155, column: 48, scope: !391)
!428 = !MDLocation(line: 155, column: 52, scope: !391)
!429 = !MDLocation(line: 155, column: 47, scope: !391)
!430 = !MDLocation(line: 155, column: 39, scope: !391)
!431 = !MDLocation(line: 155, column: 32, scope: !391)
!432 = !MDLocation(line: 155, column: 16, scope: !391)
!433 = !MDLocation(line: 156, column: 17, scope: !391)
!434 = !MDLocation(line: 156, column: 20, scope: !391)
!435 = !MDLocation(line: 156, column: 19, scope: !391)
!436 = !MDLocation(line: 156, column: 24, scope: !391)
!437 = !MDLocation(line: 156, column: 27, scope: !391)
!438 = !MDLocation(line: 156, column: 26, scope: !391)
!439 = !MDLocation(line: 156, column: 22, scope: !391)
!440 = !MDLocation(line: 156, column: 32, scope: !391)
!441 = !MDLocation(line: 156, column: 35, scope: !391)
!442 = !MDLocation(line: 156, column: 34, scope: !391)
!443 = !MDLocation(line: 156, column: 30, scope: !391)
!444 = !MDLocation(line: 156, column: 15, scope: !391)
!445 = !MDLocation(line: 157, column: 17, scope: !446)
!446 = distinct !MDLexicalBlock(scope: !391, file: !1, line: 157, column: 17)
!447 = !MDLocation(line: 157, column: 21, scope: !446)
!448 = !MDLocation(line: 157, column: 27, scope: !446)
!449 = !MDLocation(line: 157, column: 17, scope: !391)
!450 = !MDLocation(line: 159, column: 24, scope: !451)
!451 = distinct !MDLexicalBlock(scope: !446, file: !1, line: 158, column: 13)
!452 = !MDLocation(line: 159, column: 28, scope: !451)
!453 = !MDLocation(line: 159, column: 32, scope: !451)
!454 = !MDLocation(line: 159, column: 36, scope: !451)
!455 = !MDLocation(line: 159, column: 39, scope: !451)
!456 = !MDLocation(line: 159, column: 43, scope: !451)
!457 = !MDLocation(line: 159, column: 38, scope: !451)
!458 = !MDLocation(line: 159, column: 30, scope: !451)
!459 = !MDLocation(line: 159, column: 22, scope: !451)
!460 = !MDLocation(line: 160, column: 30, scope: !451)
!461 = !MDLocation(line: 160, column: 34, scope: !451)
!462 = !MDLocation(line: 160, column: 43, scope: !451)
!463 = !MDLocation(line: 160, column: 47, scope: !451)
!464 = !MDLocation(line: 160, column: 55, scope: !451)
!465 = !MDLocation(line: 160, column: 59, scope: !451)
!466 = !MDLocation(line: 160, column: 54, scope: !451)
!467 = !MDLocation(line: 160, column: 41, scope: !451)
!468 = !MDLocation(line: 160, column: 28, scope: !451)
!469 = !MDLocation(line: 161, column: 13, scope: !451)
!470 = !MDLocation(line: 162, column: 24, scope: !471)
!471 = distinct !MDLexicalBlock(scope: !446, file: !1, line: 161, column: 18)
!472 = !MDLocation(line: 162, column: 28, scope: !471)
!473 = !MDLocation(line: 162, column: 22, scope: !471)
!474 = !MDLocation(line: 163, column: 30, scope: !471)
!475 = !MDLocation(line: 163, column: 34, scope: !471)
!476 = !MDLocation(line: 163, column: 28, scope: !471)
!477 = !MDLocation(line: 165, column: 22, scope: !391)
!478 = !MDLocation(line: 165, column: 17, scope: !391)
!479 = !MDLocation(line: 165, column: 15, scope: !391)
!480 = !MDLocation(line: 166, column: 17, scope: !391)
!481 = !MDLocation(line: 166, column: 21, scope: !391)
!482 = !MDLocation(line: 166, column: 19, scope: !391)
!483 = !MDLocation(line: 166, column: 15, scope: !391)
!484 = !MDLocation(line: 167, column: 19, scope: !391)
!485 = !MDLocation(line: 167, column: 24, scope: !391)
!486 = !MDLocation(line: 167, column: 23, scope: !391)
!487 = !MDLocation(line: 167, column: 26, scope: !391)
!488 = !MDLocation(line: 167, column: 25, scope: !391)
!489 = !MDLocation(line: 167, column: 14, scope: !391)
!490 = !MDLocation(line: 167, column: 16, scope: !391)
!491 = !MDLocation(line: 168, column: 9, scope: !391)
!492 = !MDLocation(line: 169, column: 13, scope: !493)
!493 = distinct !MDLexicalBlock(scope: !373, file: !1, line: 169, column: 13)
!494 = !MDLocation(line: 169, column: 19, scope: !493)
!495 = !MDLocation(line: 169, column: 23, scope: !493)
!496 = !MDLocation(line: 169, column: 16, scope: !493)
!497 = !MDLocation(line: 169, column: 13, scope: !373)
!498 = !MDLocation(line: 169, column: 30, scope: !493)
!499 = !MDLocation(line: 170, column: 14, scope: !373)
!500 = !MDLocation(line: 170, column: 18, scope: !373)
!501 = !MDLocation(line: 170, column: 12, scope: !373)
!502 = !MDLocation(line: 172, column: 1, scope: !11)
!503 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "lambda", arg: 1, scope: !15, file: !1, line: 181, type: !10)
!504 = !MDLocation(line: 181, column: 7, scope: !15)
!505 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "abcp", scope: !15, file: !1, line: 183, type: !165)
!506 = !MDLocation(line: 183, column: 10, scope: !15)
!507 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "bp", scope: !15, file: !1, line: 184, type: !319)
!508 = !MDLocation(line: 184, column: 11, scope: !15)
!509 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r", scope: !15, file: !1, line: 185, type: !10)
!510 = !MDLocation(line: 185, column: 11, scope: !15)
!511 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !15, file: !1, line: 185, type: !10)
!512 = !MDLocation(line: 185, column: 13, scope: !15)
!513 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y1", scope: !15, file: !1, line: 185, type: !10)
!514 = !MDLocation(line: 185, column: 16, scope: !15)
!515 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z1", scope: !15, file: !1, line: 185, type: !10)
!516 = !MDLocation(line: 185, column: 19, scope: !15)
!517 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x2", scope: !15, file: !1, line: 185, type: !10)
!518 = !MDLocation(line: 185, column: 22, scope: !15)
!519 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y2", scope: !15, file: !1, line: 185, type: !10)
!520 = !MDLocation(line: 185, column: 25, scope: !15)
!521 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z2", scope: !15, file: !1, line: 185, type: !10)
!522 = !MDLocation(line: 185, column: 28, scope: !15)
!523 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "dp", scope: !15, file: !1, line: 185, type: !10)
!524 = !MDLocation(line: 185, column: 31, scope: !15)
!525 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a1", scope: !15, file: !1, line: 186, type: !22)
!526 = !MDLocation(line: 186, column: 11, scope: !15)
!527 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a2", scope: !15, file: !1, line: 186, type: !22)
!528 = !MDLocation(line: 186, column: 15, scope: !15)
!529 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a3", scope: !15, file: !1, line: 186, type: !22)
!530 = !MDLocation(line: 186, column: 19, scope: !15)
!531 = !MDLocation(line: 190, column: 10, scope: !15)
!532 = !MDLocation(line: 190, column: 8, scope: !15)
!533 = !MDLocation(line: 192, column: 5, scope: !15)
!534 = !MDLocation(line: 194, column: 13, scope: !535)
!535 = distinct !MDLexicalBlock(scope: !536, file: !1, line: 194, column: 13)
!536 = distinct !MDLexicalBlock(scope: !15, file: !1, line: 193, column: 5)
!537 = !MDLocation(line: 194, column: 16, scope: !535)
!538 = !MDLocation(line: 194, column: 13, scope: !536)
!539 = !MDLocation(line: 194, column: 26, scope: !535)
!540 = !MDLocation(line: 195, column: 9, scope: !536)
!541 = !MDLocation(line: 195, column: 13, scope: !536)
!542 = !MDLocation(line: 195, column: 19, scope: !536)
!543 = !MDLocation(line: 196, column: 9, scope: !536)
!544 = !MDLocation(line: 196, column: 13, scope: !536)
!545 = !MDLocation(line: 196, column: 21, scope: !536)
!546 = !MDLocation(line: 197, column: 9, scope: !536)
!547 = !MDLocation(line: 197, column: 13, scope: !536)
!548 = !MDLocation(line: 197, column: 16, scope: !536)
!549 = !MDLocation(line: 198, column: 13, scope: !550)
!550 = distinct !MDLexicalBlock(scope: !536, file: !1, line: 198, column: 13)
!551 = !MDLocation(line: 198, column: 19, scope: !550)
!552 = !MDLocation(line: 198, column: 23, scope: !550)
!553 = !MDLocation(line: 198, column: 16, scope: !550)
!554 = !MDLocation(line: 198, column: 13, scope: !536)
!555 = !MDLocation(line: 198, column: 29, scope: !550)
!556 = !MDLocation(line: 199, column: 14, scope: !536)
!557 = !MDLocation(line: 199, column: 18, scope: !536)
!558 = !MDLocation(line: 199, column: 12, scope: !536)
!559 = !MDLocation(line: 202, column: 12, scope: !15)
!560 = !MDLocation(line: 202, column: 10, scope: !15)
!561 = !MDLocation(line: 203, column: 5, scope: !15)
!562 = !MDLocation(line: 205, column: 13, scope: !563)
!563 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 205, column: 13)
!564 = distinct !MDLexicalBlock(scope: !15, file: !1, line: 204, column: 5)
!565 = !MDLocation(line: 205, column: 18, scope: !563)
!566 = !MDLocation(line: 205, column: 13, scope: !564)
!567 = !MDLocation(line: 205, column: 28, scope: !563)
!568 = !MDLocation(line: 207, column: 13, scope: !569)
!569 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 207, column: 13)
!570 = !MDLocation(line: 207, column: 19, scope: !569)
!571 = !MDLocation(line: 207, column: 22, scope: !569)
!572 = !MDLocation(line: 207, column: 13, scope: !564)
!573 = !MDLocation(line: 208, column: 39, scope: !574)
!574 = distinct !MDLexicalBlock(scope: !569, file: !1, line: 208, column: 9)
!575 = !MDLocation(line: 208, column: 45, scope: !574)
!576 = !MDLocation(line: 208, column: 51, scope: !574)
!577 = !MDLocation(line: 208, column: 57, scope: !574)
!578 = !MDLocation(line: 208, column: 22, scope: !574)
!579 = !MDLocation(line: 208, column: 11, scope: !574)
!580 = !MDLocation(line: 208, column: 17, scope: !574)
!581 = !MDLocation(line: 208, column: 20, scope: !574)
!582 = !MDLocation(line: 209, column: 17, scope: !583)
!583 = distinct !MDLexicalBlock(scope: !574, file: !1, line: 209, column: 17)
!584 = !MDLocation(line: 209, column: 23, scope: !583)
!585 = !MDLocation(line: 209, column: 26, scope: !583)
!586 = !MDLocation(line: 209, column: 17, scope: !574)
!587 = !MDLocation(line: 209, column: 36, scope: !583)
!588 = !MDLocation(line: 209, column: 47, scope: !574)
!589 = !MDLocation(line: 210, column: 13, scope: !590)
!590 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 210, column: 13)
!591 = !MDLocation(line: 210, column: 19, scope: !590)
!592 = !MDLocation(line: 210, column: 22, scope: !590)
!593 = !MDLocation(line: 210, column: 13, scope: !564)
!594 = !MDLocation(line: 211, column: 39, scope: !595)
!595 = distinct !MDLexicalBlock(scope: !590, file: !1, line: 211, column: 9)
!596 = !MDLocation(line: 211, column: 45, scope: !595)
!597 = !MDLocation(line: 211, column: 51, scope: !595)
!598 = !MDLocation(line: 211, column: 57, scope: !595)
!599 = !MDLocation(line: 211, column: 22, scope: !595)
!600 = !MDLocation(line: 211, column: 11, scope: !595)
!601 = !MDLocation(line: 211, column: 17, scope: !595)
!602 = !MDLocation(line: 211, column: 20, scope: !595)
!603 = !MDLocation(line: 212, column: 17, scope: !604)
!604 = distinct !MDLexicalBlock(scope: !595, file: !1, line: 212, column: 17)
!605 = !MDLocation(line: 212, column: 23, scope: !604)
!606 = !MDLocation(line: 212, column: 26, scope: !604)
!607 = !MDLocation(line: 212, column: 17, scope: !595)
!608 = !MDLocation(line: 212, column: 36, scope: !604)
!609 = !MDLocation(line: 212, column: 46, scope: !595)
!610 = !MDLocation(line: 215, column: 14, scope: !564)
!611 = !MDLocation(line: 215, column: 20, scope: !564)
!612 = !MDLocation(line: 215, column: 12, scope: !564)
!613 = !MDLocation(line: 215, column: 32, scope: !564)
!614 = !MDLocation(line: 215, column: 38, scope: !564)
!615 = !MDLocation(line: 215, column: 30, scope: !564)
!616 = !MDLocation(line: 215, column: 50, scope: !564)
!617 = !MDLocation(line: 215, column: 56, scope: !564)
!618 = !MDLocation(line: 215, column: 48, scope: !564)
!619 = !MDLocation(line: 216, column: 15, scope: !564)
!620 = !MDLocation(line: 216, column: 19, scope: !564)
!621 = !MDLocation(line: 216, column: 22, scope: !564)
!622 = !MDLocation(line: 216, column: 26, scope: !564)
!623 = !MDLocation(line: 216, column: 21, scope: !564)
!624 = !MDLocation(line: 216, column: 29, scope: !564)
!625 = !MDLocation(line: 216, column: 37, scope: !564)
!626 = !MDLocation(line: 216, column: 41, scope: !564)
!627 = !MDLocation(line: 216, column: 44, scope: !564)
!628 = !MDLocation(line: 216, column: 48, scope: !564)
!629 = !MDLocation(line: 216, column: 43, scope: !564)
!630 = !MDLocation(line: 216, column: 35, scope: !564)
!631 = !MDLocation(line: 216, column: 28, scope: !564)
!632 = !MDLocation(line: 216, column: 12, scope: !564)
!633 = !MDLocation(line: 217, column: 15, scope: !564)
!634 = !MDLocation(line: 217, column: 19, scope: !564)
!635 = !MDLocation(line: 217, column: 22, scope: !564)
!636 = !MDLocation(line: 217, column: 26, scope: !564)
!637 = !MDLocation(line: 217, column: 21, scope: !564)
!638 = !MDLocation(line: 217, column: 29, scope: !564)
!639 = !MDLocation(line: 217, column: 37, scope: !564)
!640 = !MDLocation(line: 217, column: 41, scope: !564)
!641 = !MDLocation(line: 217, column: 44, scope: !564)
!642 = !MDLocation(line: 217, column: 48, scope: !564)
!643 = !MDLocation(line: 217, column: 43, scope: !564)
!644 = !MDLocation(line: 217, column: 35, scope: !564)
!645 = !MDLocation(line: 217, column: 28, scope: !564)
!646 = !MDLocation(line: 217, column: 12, scope: !564)
!647 = !MDLocation(line: 218, column: 15, scope: !564)
!648 = !MDLocation(line: 218, column: 19, scope: !564)
!649 = !MDLocation(line: 218, column: 22, scope: !564)
!650 = !MDLocation(line: 218, column: 26, scope: !564)
!651 = !MDLocation(line: 218, column: 21, scope: !564)
!652 = !MDLocation(line: 218, column: 29, scope: !564)
!653 = !MDLocation(line: 218, column: 37, scope: !564)
!654 = !MDLocation(line: 218, column: 41, scope: !564)
!655 = !MDLocation(line: 218, column: 44, scope: !564)
!656 = !MDLocation(line: 218, column: 48, scope: !564)
!657 = !MDLocation(line: 218, column: 43, scope: !564)
!658 = !MDLocation(line: 218, column: 35, scope: !564)
!659 = !MDLocation(line: 218, column: 28, scope: !564)
!660 = !MDLocation(line: 218, column: 12, scope: !564)
!661 = !MDLocation(line: 219, column: 15, scope: !564)
!662 = !MDLocation(line: 219, column: 19, scope: !564)
!663 = !MDLocation(line: 219, column: 22, scope: !564)
!664 = !MDLocation(line: 219, column: 26, scope: !564)
!665 = !MDLocation(line: 219, column: 21, scope: !564)
!666 = !MDLocation(line: 219, column: 29, scope: !564)
!667 = !MDLocation(line: 219, column: 37, scope: !564)
!668 = !MDLocation(line: 219, column: 41, scope: !564)
!669 = !MDLocation(line: 219, column: 44, scope: !564)
!670 = !MDLocation(line: 219, column: 48, scope: !564)
!671 = !MDLocation(line: 219, column: 43, scope: !564)
!672 = !MDLocation(line: 219, column: 35, scope: !564)
!673 = !MDLocation(line: 219, column: 28, scope: !564)
!674 = !MDLocation(line: 219, column: 12, scope: !564)
!675 = !MDLocation(line: 220, column: 15, scope: !564)
!676 = !MDLocation(line: 220, column: 19, scope: !564)
!677 = !MDLocation(line: 220, column: 22, scope: !564)
!678 = !MDLocation(line: 220, column: 26, scope: !564)
!679 = !MDLocation(line: 220, column: 21, scope: !564)
!680 = !MDLocation(line: 220, column: 29, scope: !564)
!681 = !MDLocation(line: 220, column: 37, scope: !564)
!682 = !MDLocation(line: 220, column: 41, scope: !564)
!683 = !MDLocation(line: 220, column: 44, scope: !564)
!684 = !MDLocation(line: 220, column: 48, scope: !564)
!685 = !MDLocation(line: 220, column: 43, scope: !564)
!686 = !MDLocation(line: 220, column: 35, scope: !564)
!687 = !MDLocation(line: 220, column: 28, scope: !564)
!688 = !MDLocation(line: 220, column: 12, scope: !564)
!689 = !MDLocation(line: 221, column: 15, scope: !564)
!690 = !MDLocation(line: 221, column: 19, scope: !564)
!691 = !MDLocation(line: 221, column: 22, scope: !564)
!692 = !MDLocation(line: 221, column: 26, scope: !564)
!693 = !MDLocation(line: 221, column: 21, scope: !564)
!694 = !MDLocation(line: 221, column: 29, scope: !564)
!695 = !MDLocation(line: 221, column: 37, scope: !564)
!696 = !MDLocation(line: 221, column: 41, scope: !564)
!697 = !MDLocation(line: 221, column: 44, scope: !564)
!698 = !MDLocation(line: 221, column: 48, scope: !564)
!699 = !MDLocation(line: 221, column: 43, scope: !564)
!700 = !MDLocation(line: 221, column: 35, scope: !564)
!701 = !MDLocation(line: 221, column: 28, scope: !564)
!702 = !MDLocation(line: 221, column: 12, scope: !564)
!703 = !MDLocation(line: 222, column: 14, scope: !564)
!704 = !MDLocation(line: 222, column: 17, scope: !564)
!705 = !MDLocation(line: 222, column: 16, scope: !564)
!706 = !MDLocation(line: 222, column: 20, scope: !564)
!707 = !MDLocation(line: 222, column: 23, scope: !564)
!708 = !MDLocation(line: 222, column: 22, scope: !564)
!709 = !MDLocation(line: 222, column: 19, scope: !564)
!710 = !MDLocation(line: 222, column: 26, scope: !564)
!711 = !MDLocation(line: 222, column: 29, scope: !564)
!712 = !MDLocation(line: 222, column: 28, scope: !564)
!713 = !MDLocation(line: 222, column: 25, scope: !564)
!714 = !MDLocation(line: 222, column: 12, scope: !564)
!715 = !MDLocation(line: 223, column: 16, scope: !564)
!716 = !MDLocation(line: 223, column: 19, scope: !564)
!717 = !MDLocation(line: 223, column: 18, scope: !564)
!718 = !MDLocation(line: 223, column: 22, scope: !564)
!719 = !MDLocation(line: 223, column: 25, scope: !564)
!720 = !MDLocation(line: 223, column: 24, scope: !564)
!721 = !MDLocation(line: 223, column: 21, scope: !564)
!722 = !MDLocation(line: 223, column: 28, scope: !564)
!723 = !MDLocation(line: 223, column: 31, scope: !564)
!724 = !MDLocation(line: 223, column: 30, scope: !564)
!725 = !MDLocation(line: 223, column: 27, scope: !564)
!726 = !MDLocation(line: 223, column: 36, scope: !564)
!727 = !MDLocation(line: 223, column: 39, scope: !564)
!728 = !MDLocation(line: 223, column: 38, scope: !564)
!729 = !MDLocation(line: 223, column: 42, scope: !564)
!730 = !MDLocation(line: 223, column: 45, scope: !564)
!731 = !MDLocation(line: 223, column: 44, scope: !564)
!732 = !MDLocation(line: 223, column: 41, scope: !564)
!733 = !MDLocation(line: 223, column: 48, scope: !564)
!734 = !MDLocation(line: 223, column: 51, scope: !564)
!735 = !MDLocation(line: 223, column: 50, scope: !564)
!736 = !MDLocation(line: 223, column: 47, scope: !564)
!737 = !MDLocation(line: 223, column: 34, scope: !564)
!738 = !MDLocation(line: 223, column: 11, scope: !564)
!739 = !MDLocation(line: 224, column: 18, scope: !564)
!740 = !MDLocation(line: 224, column: 13, scope: !564)
!741 = !MDLocation(line: 224, column: 11, scope: !564)
!742 = !MDLocation(line: 225, column: 14, scope: !564)
!743 = !MDLocation(line: 225, column: 17, scope: !564)
!744 = !MDLocation(line: 225, column: 16, scope: !564)
!745 = !MDLocation(line: 225, column: 12, scope: !564)
!746 = !MDLocation(line: 225, column: 25, scope: !747)
!747 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 225, column: 25)
!748 = !MDLocation(line: 225, column: 28, scope: !747)
!749 = !MDLocation(line: 225, column: 25, scope: !564)
!750 = !MDLocation(line: 225, column: 37, scope: !747)
!751 = !MDLocation(line: 225, column: 34, scope: !747)
!752 = !MDLocation(line: 225, column: 47, scope: !753)
!753 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 225, column: 47)
!754 = !MDLocation(line: 225, column: 50, scope: !753)
!755 = !MDLocation(line: 225, column: 47, scope: !564)
!756 = !MDLocation(line: 225, column: 60, scope: !753)
!757 = !MDLocation(line: 225, column: 57, scope: !753)
!758 = !MDLocation(line: 226, column: 19, scope: !564)
!759 = !MDLocation(line: 226, column: 14, scope: !564)
!760 = !MDLocation(line: 226, column: 12, scope: !564)
!761 = !MDLocation(line: 228, column: 13, scope: !564)
!762 = !MDLocation(line: 228, column: 18, scope: !564)
!763 = !MDLocation(line: 228, column: 24, scope: !564)
!764 = !MDLocation(line: 228, column: 16, scope: !564)
!765 = !MDLocation(line: 228, column: 11, scope: !564)
!766 = !MDLocation(line: 229, column: 13, scope: !564)
!767 = !MDLocation(line: 229, column: 18, scope: !564)
!768 = !MDLocation(line: 229, column: 24, scope: !564)
!769 = !MDLocation(line: 229, column: 36, scope: !564)
!770 = !MDLocation(line: 229, column: 34, scope: !564)
!771 = !MDLocation(line: 229, column: 14, scope: !564)
!772 = !MDLocation(line: 229, column: 11, scope: !564)
!773 = !MDLocation(line: 230, column: 14, scope: !564)
!774 = !MDLocation(line: 230, column: 20, scope: !564)
!775 = !MDLocation(line: 230, column: 12, scope: !564)
!776 = !MDLocation(line: 231, column: 9, scope: !564)
!777 = !MDLocation(line: 231, column: 13, scope: !564)
!778 = !MDLocation(line: 231, column: 19, scope: !564)
!779 = !MDLocation(line: 232, column: 24, scope: !564)
!780 = !MDLocation(line: 232, column: 30, scope: !564)
!781 = !MDLocation(line: 232, column: 33, scope: !564)
!782 = !MDLocation(line: 232, column: 32, scope: !564)
!783 = !MDLocation(line: 232, column: 9, scope: !564)
!784 = !MDLocation(line: 232, column: 13, scope: !564)
!785 = !MDLocation(line: 232, column: 21, scope: !564)
!786 = !MDLocation(line: 233, column: 19, scope: !564)
!787 = !MDLocation(line: 233, column: 25, scope: !564)
!788 = !MDLocation(line: 233, column: 29, scope: !564)
!789 = !MDLocation(line: 233, column: 28, scope: !564)
!790 = !MDLocation(line: 233, column: 9, scope: !564)
!791 = !MDLocation(line: 233, column: 13, scope: !564)
!792 = !MDLocation(line: 233, column: 16, scope: !564)
!793 = !MDLocation(line: 234, column: 14, scope: !564)
!794 = !MDLocation(line: 234, column: 20, scope: !564)
!795 = !MDLocation(line: 234, column: 12, scope: !564)
!796 = !MDLocation(line: 235, column: 9, scope: !564)
!797 = !MDLocation(line: 235, column: 13, scope: !564)
!798 = !MDLocation(line: 235, column: 19, scope: !564)
!799 = !MDLocation(line: 236, column: 24, scope: !564)
!800 = !MDLocation(line: 236, column: 30, scope: !564)
!801 = !MDLocation(line: 236, column: 33, scope: !564)
!802 = !MDLocation(line: 236, column: 32, scope: !564)
!803 = !MDLocation(line: 236, column: 9, scope: !564)
!804 = !MDLocation(line: 236, column: 13, scope: !564)
!805 = !MDLocation(line: 236, column: 21, scope: !564)
!806 = !MDLocation(line: 237, column: 19, scope: !564)
!807 = !MDLocation(line: 237, column: 25, scope: !564)
!808 = !MDLocation(line: 237, column: 29, scope: !564)
!809 = !MDLocation(line: 237, column: 28, scope: !564)
!810 = !MDLocation(line: 237, column: 9, scope: !564)
!811 = !MDLocation(line: 237, column: 13, scope: !564)
!812 = !MDLocation(line: 237, column: 16, scope: !564)
!813 = !MDLocation(line: 240, column: 13, scope: !814)
!814 = distinct !MDLexicalBlock(scope: !564, file: !1, line: 240, column: 13)
!815 = !MDLocation(line: 240, column: 21, scope: !814)
!816 = !MDLocation(line: 240, column: 27, scope: !814)
!817 = !MDLocation(line: 240, column: 18, scope: !814)
!818 = !MDLocation(line: 240, column: 13, scope: !564)
!819 = !MDLocation(line: 240, column: 33, scope: !814)
!820 = !MDLocation(line: 241, column: 16, scope: !564)
!821 = !MDLocation(line: 241, column: 22, scope: !564)
!822 = !MDLocation(line: 241, column: 14, scope: !564)
!823 = !MDLocation(line: 243, column: 1, scope: !15)
!824 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "lambda", arg: 1, scope: !18, file: !1, line: 258, type: !10)
!825 = !MDLocation(line: 258, column: 7, scope: !18)
!826 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "abcp", scope: !18, file: !1, line: 261, type: !165)
!827 = !MDLocation(line: 261, column: 10, scope: !18)
!828 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "bp", scope: !18, file: !1, line: 262, type: !319)
!829 = !MDLocation(line: 262, column: 11, scope: !18)
!830 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r", scope: !18, file: !1, line: 263, type: !10)
!831 = !MDLocation(line: 263, column: 11, scope: !18)
!832 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "k", scope: !18, file: !1, line: 263, type: !10)
!833 = !MDLocation(line: 263, column: 13, scope: !18)
!834 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ux1", scope: !18, file: !1, line: 263, type: !10)
!835 = !MDLocation(line: 263, column: 15, scope: !18)
!836 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "uy1", scope: !18, file: !1, line: 263, type: !10)
!837 = !MDLocation(line: 263, column: 19, scope: !18)
!838 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "uz1", scope: !18, file: !1, line: 263, type: !10)
!839 = !MDLocation(line: 263, column: 23, scope: !18)
!840 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ux2", scope: !18, file: !1, line: 263, type: !10)
!841 = !MDLocation(line: 263, column: 27, scope: !18)
!842 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "uy2", scope: !18, file: !1, line: 263, type: !10)
!843 = !MDLocation(line: 263, column: 31, scope: !18)
!844 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "uz2", scope: !18, file: !1, line: 263, type: !10)
!845 = !MDLocation(line: 263, column: 35, scope: !18)
!846 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "rb", scope: !18, file: !1, line: 264, type: !10)
!847 = !MDLocation(line: 264, column: 11, scope: !18)
!848 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ubx", scope: !18, file: !1, line: 264, type: !10)
!849 = !MDLocation(line: 264, column: 14, scope: !18)
!850 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "uby", scope: !18, file: !1, line: 264, type: !10)
!851 = !MDLocation(line: 264, column: 18, scope: !18)
!852 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ubz", scope: !18, file: !1, line: 264, type: !10)
!853 = !MDLocation(line: 264, column: 22, scope: !18)
!854 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a1", scope: !18, file: !1, line: 265, type: !22)
!855 = !MDLocation(line: 265, column: 11, scope: !18)
!856 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a2", scope: !18, file: !1, line: 265, type: !22)
!857 = !MDLocation(line: 265, column: 15, scope: !18)
!858 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a3", scope: !18, file: !1, line: 265, type: !22)
!859 = !MDLocation(line: 265, column: 19, scope: !18)
!860 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !18, file: !1, line: 266, type: !10)
!861 = !MDLocation(line: 266, column: 11, scope: !18)
!862 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y1", scope: !18, file: !1, line: 266, type: !10)
!863 = !MDLocation(line: 266, column: 14, scope: !18)
!864 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z1", scope: !18, file: !1, line: 266, type: !10)
!865 = !MDLocation(line: 266, column: 17, scope: !18)
!866 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x2", scope: !18, file: !1, line: 266, type: !10)
!867 = !MDLocation(line: 266, column: 20, scope: !18)
!868 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y2", scope: !18, file: !1, line: 266, type: !10)
!869 = !MDLocation(line: 266, column: 23, scope: !18)
!870 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z2", scope: !18, file: !1, line: 266, type: !10)
!871 = !MDLocation(line: 266, column: 26, scope: !18)
!872 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r1", scope: !18, file: !1, line: 267, type: !10)
!873 = !MDLocation(line: 267, column: 11, scope: !18)
!874 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r2", scope: !18, file: !1, line: 267, type: !10)
!875 = !MDLocation(line: 267, column: 14, scope: !18)
!876 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "dtheta", scope: !18, file: !1, line: 267, type: !10)
!877 = !MDLocation(line: 267, column: 17, scope: !18)
!878 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "dp", scope: !18, file: !1, line: 267, type: !10)
!879 = !MDLocation(line: 267, column: 24, scope: !18)
!880 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "drb", scope: !18, file: !1, line: 267, type: !10)
!881 = !MDLocation(line: 267, column: 27, scope: !18)
!882 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r11", scope: !18, file: !1, line: 268, type: !10)
!883 = !MDLocation(line: 268, column: 11, scope: !18)
!884 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r22", scope: !18, file: !1, line: 268, type: !10)
!885 = !MDLocation(line: 268, column: 15, scope: !18)
!886 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "sdth", scope: !18, file: !1, line: 268, type: !10)
!887 = !MDLocation(line: 268, column: 19, scope: !18)
!888 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "length_eff", scope: !18, file: !1, line: 269, type: !10)
!889 = !MDLocation(line: 269, column: 11, scope: !18)
!890 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "ddtheta", scope: !18, file: !1, line: 270, type: !10)
!891 = !MDLocation(line: 270, column: 11, scope: !18)
!892 = !MDLocation(line: 272, column: 12, scope: !18)
!893 = !MDLocation(line: 272, column: 10, scope: !18)
!894 = !MDLocation(line: 273, column: 9, scope: !895)
!895 = distinct !MDLexicalBlock(scope: !18, file: !1, line: 273, column: 9)
!896 = !MDLocation(line: 273, column: 14, scope: !895)
!897 = !MDLocation(line: 273, column: 9, scope: !18)
!898 = !MDLocation(line: 273, column: 40, scope: !899)
!899 = distinct !MDLexicalBlock(scope: !895, file: !1, line: 273, column: 23)
!900 = !MDLocation(line: 273, column: 32, scope: !899)
!901 = !MDLocation(line: 273, column: 25, scope: !899)
!902 = !MDLocation(line: 274, column: 10, scope: !18)
!903 = !MDLocation(line: 274, column: 8, scope: !18)
!904 = !MDLocation(line: 275, column: 9, scope: !905)
!905 = distinct !MDLexicalBlock(scope: !18, file: !1, line: 275, column: 9)
!906 = !MDLocation(line: 275, column: 12, scope: !905)
!907 = !MDLocation(line: 275, column: 9, scope: !18)
!908 = !MDLocation(line: 275, column: 22, scope: !905)
!909 = !MDLocation(line: 277, column: 13, scope: !18)
!910 = !MDLocation(line: 277, column: 5, scope: !18)
!911 = !MDLocation(line: 285, column: 5, scope: !18)
!912 = !MDLocation(line: 287, column: 13, scope: !913)
!913 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 287, column: 13)
!914 = distinct !MDLexicalBlock(scope: !18, file: !1, line: 286, column: 5)
!915 = !MDLocation(line: 287, column: 16, scope: !913)
!916 = !MDLocation(line: 287, column: 13, scope: !914)
!917 = !MDLocation(line: 287, column: 25, scope: !913)
!918 = !MDLocation(line: 288, column: 13, scope: !919)
!919 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 288, column: 13)
!920 = !MDLocation(line: 288, column: 17, scope: !919)
!921 = !MDLocation(line: 288, column: 23, scope: !919)
!922 = !MDLocation(line: 288, column: 13, scope: !914)
!923 = !MDLocation(line: 289, column: 17, scope: !924)
!924 = distinct !MDLexicalBlock(scope: !919, file: !1, line: 288, column: 29)
!925 = !MDLocation(line: 289, column: 21, scope: !924)
!926 = !MDLocation(line: 289, column: 15, scope: !924)
!927 = !MDLocation(line: 290, column: 26, scope: !924)
!928 = !MDLocation(line: 290, column: 30, scope: !924)
!929 = !MDLocation(line: 290, column: 24, scope: !924)
!930 = !MDLocation(line: 291, column: 9, scope: !924)
!931 = !MDLocation(line: 292, column: 17, scope: !932)
!932 = distinct !MDLexicalBlock(scope: !919, file: !1, line: 291, column: 14)
!933 = !MDLocation(line: 292, column: 21, scope: !932)
!934 = !MDLocation(line: 292, column: 25, scope: !932)
!935 = !MDLocation(line: 292, column: 29, scope: !932)
!936 = !MDLocation(line: 292, column: 32, scope: !932)
!937 = !MDLocation(line: 292, column: 36, scope: !932)
!938 = !MDLocation(line: 292, column: 31, scope: !932)
!939 = !MDLocation(line: 292, column: 23, scope: !932)
!940 = !MDLocation(line: 292, column: 15, scope: !932)
!941 = !MDLocation(line: 293, column: 26, scope: !932)
!942 = !MDLocation(line: 293, column: 30, scope: !932)
!943 = !MDLocation(line: 293, column: 38, scope: !932)
!944 = !MDLocation(line: 293, column: 42, scope: !932)
!945 = !MDLocation(line: 293, column: 50, scope: !932)
!946 = !MDLocation(line: 293, column: 54, scope: !932)
!947 = !MDLocation(line: 293, column: 49, scope: !932)
!948 = !MDLocation(line: 293, column: 36, scope: !932)
!949 = !MDLocation(line: 293, column: 24, scope: !932)
!950 = !MDLocation(line: 295, column: 14, scope: !914)
!951 = !MDLocation(line: 295, column: 18, scope: !914)
!952 = !MDLocation(line: 295, column: 12, scope: !914)
!953 = !MDLocation(line: 295, column: 30, scope: !914)
!954 = !MDLocation(line: 295, column: 34, scope: !914)
!955 = !MDLocation(line: 295, column: 28, scope: !914)
!956 = !MDLocation(line: 296, column: 13, scope: !957)
!957 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 296, column: 13)
!958 = !MDLocation(line: 296, column: 17, scope: !957)
!959 = !MDLocation(line: 296, column: 24, scope: !957)
!960 = !MDLocation(line: 296, column: 27, scope: !957)
!961 = !MDLocation(line: 296, column: 31, scope: !957)
!962 = !MDLocation(line: 296, column: 13, scope: !914)
!963 = !MDLocation(line: 297, column: 19, scope: !964)
!964 = distinct !MDLexicalBlock(scope: !957, file: !1, line: 296, column: 40)
!965 = !MDLocation(line: 297, column: 23, scope: !964)
!966 = !MDLocation(line: 297, column: 26, scope: !964)
!967 = !MDLocation(line: 297, column: 30, scope: !964)
!968 = !MDLocation(line: 297, column: 25, scope: !964)
!969 = !MDLocation(line: 297, column: 33, scope: !964)
!970 = !MDLocation(line: 297, column: 41, scope: !964)
!971 = !MDLocation(line: 297, column: 45, scope: !964)
!972 = !MDLocation(line: 297, column: 48, scope: !964)
!973 = !MDLocation(line: 297, column: 52, scope: !964)
!974 = !MDLocation(line: 297, column: 47, scope: !964)
!975 = !MDLocation(line: 297, column: 39, scope: !964)
!976 = !MDLocation(line: 297, column: 32, scope: !964)
!977 = !MDLocation(line: 297, column: 16, scope: !964)
!978 = !MDLocation(line: 298, column: 19, scope: !964)
!979 = !MDLocation(line: 298, column: 23, scope: !964)
!980 = !MDLocation(line: 298, column: 26, scope: !964)
!981 = !MDLocation(line: 298, column: 30, scope: !964)
!982 = !MDLocation(line: 298, column: 25, scope: !964)
!983 = !MDLocation(line: 298, column: 33, scope: !964)
!984 = !MDLocation(line: 298, column: 41, scope: !964)
!985 = !MDLocation(line: 298, column: 45, scope: !964)
!986 = !MDLocation(line: 298, column: 48, scope: !964)
!987 = !MDLocation(line: 298, column: 52, scope: !964)
!988 = !MDLocation(line: 298, column: 47, scope: !964)
!989 = !MDLocation(line: 298, column: 39, scope: !964)
!990 = !MDLocation(line: 298, column: 32, scope: !964)
!991 = !MDLocation(line: 298, column: 16, scope: !964)
!992 = !MDLocation(line: 299, column: 19, scope: !964)
!993 = !MDLocation(line: 299, column: 23, scope: !964)
!994 = !MDLocation(line: 299, column: 26, scope: !964)
!995 = !MDLocation(line: 299, column: 30, scope: !964)
!996 = !MDLocation(line: 299, column: 25, scope: !964)
!997 = !MDLocation(line: 299, column: 33, scope: !964)
!998 = !MDLocation(line: 299, column: 41, scope: !964)
!999 = !MDLocation(line: 299, column: 45, scope: !964)
!1000 = !MDLocation(line: 299, column: 48, scope: !964)
!1001 = !MDLocation(line: 299, column: 52, scope: !964)
!1002 = !MDLocation(line: 299, column: 47, scope: !964)
!1003 = !MDLocation(line: 299, column: 39, scope: !964)
!1004 = !MDLocation(line: 299, column: 32, scope: !964)
!1005 = !MDLocation(line: 299, column: 16, scope: !964)
!1006 = !MDLocation(line: 300, column: 18, scope: !964)
!1007 = !MDLocation(line: 300, column: 21, scope: !964)
!1008 = !MDLocation(line: 300, column: 20, scope: !964)
!1009 = !MDLocation(line: 300, column: 24, scope: !964)
!1010 = !MDLocation(line: 300, column: 27, scope: !964)
!1011 = !MDLocation(line: 300, column: 26, scope: !964)
!1012 = !MDLocation(line: 300, column: 23, scope: !964)
!1013 = !MDLocation(line: 300, column: 30, scope: !964)
!1014 = !MDLocation(line: 300, column: 33, scope: !964)
!1015 = !MDLocation(line: 300, column: 32, scope: !964)
!1016 = !MDLocation(line: 300, column: 29, scope: !964)
!1017 = !MDLocation(line: 300, column: 16, scope: !964)
!1018 = !MDLocation(line: 301, column: 17, scope: !1019)
!1019 = distinct !MDLexicalBlock(scope: !964, file: !1, line: 301, column: 17)
!1020 = !MDLocation(line: 301, column: 20, scope: !1019)
!1021 = !MDLocation(line: 301, column: 17, scope: !964)
!1022 = !MDLocation(line: 302, column: 18, scope: !1023)
!1023 = distinct !MDLexicalBlock(scope: !1019, file: !1, line: 302, column: 13)
!1024 = !MDLocation(line: 302, column: 27, scope: !1023)
!1025 = !MDLocation(line: 302, column: 37, scope: !1023)
!1026 = !MDLocation(line: 302, column: 47, scope: !1023)
!1027 = !MDLocation(line: 303, column: 13, scope: !1023)
!1028 = !MDLocation(line: 304, column: 27, scope: !1029)
!1029 = distinct !MDLexicalBlock(scope: !1019, file: !1, line: 303, column: 19)
!1030 = !MDLocation(line: 304, column: 22, scope: !1029)
!1031 = !MDLocation(line: 304, column: 20, scope: !1029)
!1032 = !MDLocation(line: 305, column: 23, scope: !1029)
!1033 = !MDLocation(line: 305, column: 26, scope: !1029)
!1034 = !MDLocation(line: 305, column: 25, scope: !1029)
!1035 = !MDLocation(line: 305, column: 21, scope: !1029)
!1036 = !MDLocation(line: 306, column: 23, scope: !1029)
!1037 = !MDLocation(line: 306, column: 26, scope: !1029)
!1038 = !MDLocation(line: 306, column: 25, scope: !1029)
!1039 = !MDLocation(line: 306, column: 21, scope: !1029)
!1040 = !MDLocation(line: 307, column: 23, scope: !1029)
!1041 = !MDLocation(line: 307, column: 26, scope: !1029)
!1042 = !MDLocation(line: 307, column: 25, scope: !1029)
!1043 = !MDLocation(line: 307, column: 21, scope: !1029)
!1044 = !MDLocation(line: 309, column: 22, scope: !964)
!1045 = !MDLocation(line: 309, column: 21, scope: !964)
!1046 = !MDLocation(line: 309, column: 25, scope: !964)
!1047 = !MDLocation(line: 309, column: 30, scope: !964)
!1048 = !MDLocation(line: 309, column: 28, scope: !964)
!1049 = !MDLocation(line: 309, column: 23, scope: !964)
!1050 = !MDLocation(line: 309, column: 42, scope: !964)
!1051 = !MDLocation(line: 309, column: 41, scope: !964)
!1052 = !MDLocation(line: 309, column: 17, scope: !964)
!1053 = !MDLocation(line: 310, column: 22, scope: !964)
!1054 = !MDLocation(line: 310, column: 21, scope: !964)
!1055 = !MDLocation(line: 310, column: 25, scope: !964)
!1056 = !MDLocation(line: 310, column: 30, scope: !964)
!1057 = !MDLocation(line: 310, column: 28, scope: !964)
!1058 = !MDLocation(line: 310, column: 23, scope: !964)
!1059 = !MDLocation(line: 310, column: 42, scope: !964)
!1060 = !MDLocation(line: 310, column: 41, scope: !964)
!1061 = !MDLocation(line: 310, column: 17, scope: !964)
!1062 = !MDLocation(line: 311, column: 22, scope: !964)
!1063 = !MDLocation(line: 311, column: 21, scope: !964)
!1064 = !MDLocation(line: 311, column: 25, scope: !964)
!1065 = !MDLocation(line: 311, column: 30, scope: !964)
!1066 = !MDLocation(line: 311, column: 28, scope: !964)
!1067 = !MDLocation(line: 311, column: 23, scope: !964)
!1068 = !MDLocation(line: 311, column: 42, scope: !964)
!1069 = !MDLocation(line: 311, column: 41, scope: !964)
!1070 = !MDLocation(line: 311, column: 17, scope: !964)
!1071 = !MDLocation(line: 313, column: 9, scope: !964)
!1072 = !MDLocation(line: 314, column: 13, scope: !1073)
!1073 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 314, column: 13)
!1074 = !MDLocation(line: 314, column: 17, scope: !1073)
!1075 = !MDLocation(line: 314, column: 13, scope: !914)
!1076 = !MDLocation(line: 315, column: 23, scope: !1077)
!1077 = distinct !MDLexicalBlock(scope: !1073, file: !1, line: 314, column: 24)
!1078 = !MDLocation(line: 315, column: 13, scope: !1077)
!1079 = !MDLocation(line: 315, column: 17, scope: !1077)
!1080 = !MDLocation(line: 315, column: 20, scope: !1077)
!1081 = !MDLocation(line: 316, column: 23, scope: !1077)
!1082 = !MDLocation(line: 316, column: 13, scope: !1077)
!1083 = !MDLocation(line: 316, column: 17, scope: !1077)
!1084 = !MDLocation(line: 316, column: 20, scope: !1077)
!1085 = !MDLocation(line: 317, column: 23, scope: !1077)
!1086 = !MDLocation(line: 317, column: 13, scope: !1077)
!1087 = !MDLocation(line: 317, column: 17, scope: !1077)
!1088 = !MDLocation(line: 317, column: 20, scope: !1077)
!1089 = !MDLocation(line: 318, column: 9, scope: !1077)
!1090 = !MDLocation(line: 320, column: 13, scope: !1091)
!1091 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 320, column: 13)
!1092 = !MDLocation(line: 320, column: 17, scope: !1091)
!1093 = !MDLocation(line: 320, column: 13, scope: !914)
!1094 = !MDLocation(line: 321, column: 23, scope: !1095)
!1095 = distinct !MDLexicalBlock(scope: !1091, file: !1, line: 320, column: 24)
!1096 = !MDLocation(line: 321, column: 13, scope: !1095)
!1097 = !MDLocation(line: 321, column: 17, scope: !1095)
!1098 = !MDLocation(line: 321, column: 20, scope: !1095)
!1099 = !MDLocation(line: 322, column: 23, scope: !1095)
!1100 = !MDLocation(line: 322, column: 13, scope: !1095)
!1101 = !MDLocation(line: 322, column: 17, scope: !1095)
!1102 = !MDLocation(line: 322, column: 20, scope: !1095)
!1103 = !MDLocation(line: 323, column: 23, scope: !1095)
!1104 = !MDLocation(line: 323, column: 13, scope: !1095)
!1105 = !MDLocation(line: 323, column: 17, scope: !1095)
!1106 = !MDLocation(line: 323, column: 20, scope: !1095)
!1107 = !MDLocation(line: 324, column: 9, scope: !1095)
!1108 = !MDLocation(line: 327, column: 13, scope: !1109)
!1109 = distinct !MDLexicalBlock(scope: !914, file: !1, line: 327, column: 13)
!1110 = !MDLocation(line: 327, column: 19, scope: !1109)
!1111 = !MDLocation(line: 327, column: 23, scope: !1109)
!1112 = !MDLocation(line: 327, column: 16, scope: !1109)
!1113 = !MDLocation(line: 327, column: 13, scope: !914)
!1114 = !MDLocation(line: 327, column: 30, scope: !1109)
!1115 = !MDLocation(line: 328, column: 14, scope: !914)
!1116 = !MDLocation(line: 328, column: 18, scope: !914)
!1117 = !MDLocation(line: 328, column: 12, scope: !914)
!1118 = !MDLocation(line: 331, column: 12, scope: !18)
!1119 = !MDLocation(line: 331, column: 10, scope: !18)
!1120 = !MDLocation(line: 332, column: 5, scope: !18)
!1121 = !MDLocation(line: 334, column: 13, scope: !1122)
!1122 = distinct !MDLexicalBlock(scope: !1123, file: !1, line: 334, column: 13)
!1123 = distinct !MDLexicalBlock(scope: !18, file: !1, line: 333, column: 5)
!1124 = !MDLocation(line: 334, column: 18, scope: !1122)
!1125 = !MDLocation(line: 334, column: 13, scope: !1123)
!1126 = !MDLocation(line: 334, column: 28, scope: !1122)
!1127 = !MDLocation(line: 335, column: 14, scope: !1123)
!1128 = !MDLocation(line: 335, column: 20, scope: !1123)
!1129 = !MDLocation(line: 335, column: 12, scope: !1123)
!1130 = !MDLocation(line: 335, column: 32, scope: !1123)
!1131 = !MDLocation(line: 335, column: 38, scope: !1123)
!1132 = !MDLocation(line: 335, column: 30, scope: !1123)
!1133 = !MDLocation(line: 335, column: 50, scope: !1123)
!1134 = !MDLocation(line: 335, column: 56, scope: !1123)
!1135 = !MDLocation(line: 335, column: 48, scope: !1123)
!1136 = !MDLocation(line: 337, column: 13, scope: !1137)
!1137 = distinct !MDLexicalBlock(scope: !1123, file: !1, line: 337, column: 13)
!1138 = !MDLocation(line: 337, column: 17, scope: !1137)
!1139 = !MDLocation(line: 337, column: 23, scope: !1137)
!1140 = !MDLocation(line: 337, column: 26, scope: !1137)
!1141 = !MDLocation(line: 337, column: 30, scope: !1137)
!1142 = !MDLocation(line: 337, column: 37, scope: !1137)
!1143 = !MDLocation(line: 337, column: 40, scope: !1137)
!1144 = !MDLocation(line: 337, column: 44, scope: !1137)
!1145 = !MDLocation(line: 337, column: 13, scope: !1123)
!1146 = !MDLocation(line: 339, column: 19, scope: !1147)
!1147 = distinct !MDLexicalBlock(scope: !1137, file: !1, line: 338, column: 9)
!1148 = !MDLocation(line: 339, column: 23, scope: !1147)
!1149 = !MDLocation(line: 339, column: 26, scope: !1147)
!1150 = !MDLocation(line: 339, column: 30, scope: !1147)
!1151 = !MDLocation(line: 339, column: 25, scope: !1147)
!1152 = !MDLocation(line: 339, column: 33, scope: !1147)
!1153 = !MDLocation(line: 339, column: 41, scope: !1147)
!1154 = !MDLocation(line: 339, column: 45, scope: !1147)
!1155 = !MDLocation(line: 339, column: 48, scope: !1147)
!1156 = !MDLocation(line: 339, column: 52, scope: !1147)
!1157 = !MDLocation(line: 339, column: 47, scope: !1147)
!1158 = !MDLocation(line: 339, column: 39, scope: !1147)
!1159 = !MDLocation(line: 339, column: 32, scope: !1147)
!1160 = !MDLocation(line: 339, column: 16, scope: !1147)
!1161 = !MDLocation(line: 340, column: 19, scope: !1147)
!1162 = !MDLocation(line: 340, column: 23, scope: !1147)
!1163 = !MDLocation(line: 340, column: 26, scope: !1147)
!1164 = !MDLocation(line: 340, column: 30, scope: !1147)
!1165 = !MDLocation(line: 340, column: 25, scope: !1147)
!1166 = !MDLocation(line: 340, column: 33, scope: !1147)
!1167 = !MDLocation(line: 340, column: 41, scope: !1147)
!1168 = !MDLocation(line: 340, column: 45, scope: !1147)
!1169 = !MDLocation(line: 340, column: 48, scope: !1147)
!1170 = !MDLocation(line: 340, column: 52, scope: !1147)
!1171 = !MDLocation(line: 340, column: 47, scope: !1147)
!1172 = !MDLocation(line: 340, column: 39, scope: !1147)
!1173 = !MDLocation(line: 340, column: 32, scope: !1147)
!1174 = !MDLocation(line: 340, column: 16, scope: !1147)
!1175 = !MDLocation(line: 341, column: 19, scope: !1147)
!1176 = !MDLocation(line: 341, column: 23, scope: !1147)
!1177 = !MDLocation(line: 341, column: 26, scope: !1147)
!1178 = !MDLocation(line: 341, column: 30, scope: !1147)
!1179 = !MDLocation(line: 341, column: 25, scope: !1147)
!1180 = !MDLocation(line: 341, column: 33, scope: !1147)
!1181 = !MDLocation(line: 341, column: 41, scope: !1147)
!1182 = !MDLocation(line: 341, column: 45, scope: !1147)
!1183 = !MDLocation(line: 341, column: 48, scope: !1147)
!1184 = !MDLocation(line: 341, column: 52, scope: !1147)
!1185 = !MDLocation(line: 341, column: 47, scope: !1147)
!1186 = !MDLocation(line: 341, column: 39, scope: !1147)
!1187 = !MDLocation(line: 341, column: 32, scope: !1147)
!1188 = !MDLocation(line: 341, column: 16, scope: !1147)
!1189 = !MDLocation(line: 342, column: 19, scope: !1147)
!1190 = !MDLocation(line: 342, column: 23, scope: !1147)
!1191 = !MDLocation(line: 342, column: 26, scope: !1147)
!1192 = !MDLocation(line: 342, column: 30, scope: !1147)
!1193 = !MDLocation(line: 342, column: 25, scope: !1147)
!1194 = !MDLocation(line: 342, column: 33, scope: !1147)
!1195 = !MDLocation(line: 342, column: 41, scope: !1147)
!1196 = !MDLocation(line: 342, column: 45, scope: !1147)
!1197 = !MDLocation(line: 342, column: 48, scope: !1147)
!1198 = !MDLocation(line: 342, column: 52, scope: !1147)
!1199 = !MDLocation(line: 342, column: 47, scope: !1147)
!1200 = !MDLocation(line: 342, column: 39, scope: !1147)
!1201 = !MDLocation(line: 342, column: 32, scope: !1147)
!1202 = !MDLocation(line: 342, column: 16, scope: !1147)
!1203 = !MDLocation(line: 343, column: 19, scope: !1147)
!1204 = !MDLocation(line: 343, column: 23, scope: !1147)
!1205 = !MDLocation(line: 343, column: 26, scope: !1147)
!1206 = !MDLocation(line: 343, column: 30, scope: !1147)
!1207 = !MDLocation(line: 343, column: 25, scope: !1147)
!1208 = !MDLocation(line: 343, column: 33, scope: !1147)
!1209 = !MDLocation(line: 343, column: 41, scope: !1147)
!1210 = !MDLocation(line: 343, column: 45, scope: !1147)
!1211 = !MDLocation(line: 343, column: 48, scope: !1147)
!1212 = !MDLocation(line: 343, column: 52, scope: !1147)
!1213 = !MDLocation(line: 343, column: 47, scope: !1147)
!1214 = !MDLocation(line: 343, column: 39, scope: !1147)
!1215 = !MDLocation(line: 343, column: 32, scope: !1147)
!1216 = !MDLocation(line: 343, column: 16, scope: !1147)
!1217 = !MDLocation(line: 344, column: 19, scope: !1147)
!1218 = !MDLocation(line: 344, column: 23, scope: !1147)
!1219 = !MDLocation(line: 344, column: 26, scope: !1147)
!1220 = !MDLocation(line: 344, column: 30, scope: !1147)
!1221 = !MDLocation(line: 344, column: 25, scope: !1147)
!1222 = !MDLocation(line: 344, column: 33, scope: !1147)
!1223 = !MDLocation(line: 344, column: 41, scope: !1147)
!1224 = !MDLocation(line: 344, column: 45, scope: !1147)
!1225 = !MDLocation(line: 344, column: 48, scope: !1147)
!1226 = !MDLocation(line: 344, column: 52, scope: !1147)
!1227 = !MDLocation(line: 344, column: 47, scope: !1147)
!1228 = !MDLocation(line: 344, column: 39, scope: !1147)
!1229 = !MDLocation(line: 344, column: 32, scope: !1147)
!1230 = !MDLocation(line: 344, column: 16, scope: !1147)
!1231 = !MDLocation(line: 346, column: 18, scope: !1147)
!1232 = !MDLocation(line: 346, column: 21, scope: !1147)
!1233 = !MDLocation(line: 346, column: 20, scope: !1147)
!1234 = !MDLocation(line: 346, column: 24, scope: !1147)
!1235 = !MDLocation(line: 346, column: 27, scope: !1147)
!1236 = !MDLocation(line: 346, column: 26, scope: !1147)
!1237 = !MDLocation(line: 346, column: 23, scope: !1147)
!1238 = !MDLocation(line: 346, column: 30, scope: !1147)
!1239 = !MDLocation(line: 346, column: 33, scope: !1147)
!1240 = !MDLocation(line: 346, column: 32, scope: !1147)
!1241 = !MDLocation(line: 346, column: 29, scope: !1147)
!1242 = !MDLocation(line: 346, column: 16, scope: !1147)
!1243 = !MDLocation(line: 347, column: 23, scope: !1147)
!1244 = !MDLocation(line: 347, column: 26, scope: !1147)
!1245 = !MDLocation(line: 347, column: 25, scope: !1147)
!1246 = !MDLocation(line: 347, column: 29, scope: !1147)
!1247 = !MDLocation(line: 347, column: 32, scope: !1147)
!1248 = !MDLocation(line: 347, column: 31, scope: !1147)
!1249 = !MDLocation(line: 347, column: 28, scope: !1147)
!1250 = !MDLocation(line: 347, column: 35, scope: !1147)
!1251 = !MDLocation(line: 347, column: 38, scope: !1147)
!1252 = !MDLocation(line: 347, column: 37, scope: !1147)
!1253 = !MDLocation(line: 347, column: 34, scope: !1147)
!1254 = !MDLocation(line: 347, column: 18, scope: !1147)
!1255 = !MDLocation(line: 347, column: 16, scope: !1147)
!1256 = !MDLocation(line: 348, column: 23, scope: !1147)
!1257 = !MDLocation(line: 348, column: 26, scope: !1147)
!1258 = !MDLocation(line: 348, column: 25, scope: !1147)
!1259 = !MDLocation(line: 348, column: 29, scope: !1147)
!1260 = !MDLocation(line: 348, column: 32, scope: !1147)
!1261 = !MDLocation(line: 348, column: 31, scope: !1147)
!1262 = !MDLocation(line: 348, column: 28, scope: !1147)
!1263 = !MDLocation(line: 348, column: 35, scope: !1147)
!1264 = !MDLocation(line: 348, column: 38, scope: !1147)
!1265 = !MDLocation(line: 348, column: 37, scope: !1147)
!1266 = !MDLocation(line: 348, column: 34, scope: !1147)
!1267 = !MDLocation(line: 348, column: 18, scope: !1147)
!1268 = !MDLocation(line: 348, column: 16, scope: !1147)
!1269 = !MDLocation(line: 349, column: 17, scope: !1270)
!1270 = distinct !MDLexicalBlock(scope: !1147, file: !1, line: 349, column: 17)
!1271 = !MDLocation(line: 349, column: 20, scope: !1270)
!1272 = !MDLocation(line: 349, column: 28, scope: !1270)
!1273 = !MDLocation(line: 349, column: 31, scope: !1270)
!1274 = !MDLocation(line: 349, column: 34, scope: !1270)
!1275 = !MDLocation(line: 349, column: 17, scope: !1147)
!1276 = !MDLocation(line: 349, column: 43, scope: !1270)
!1277 = !MDLocation(line: 350, column: 17, scope: !1147)
!1278 = !MDLocation(line: 350, column: 20, scope: !1147)
!1279 = !MDLocation(line: 350, column: 19, scope: !1147)
!1280 = !MDLocation(line: 350, column: 15, scope: !1147)
!1281 = !MDLocation(line: 351, column: 17, scope: !1282)
!1282 = distinct !MDLexicalBlock(scope: !1147, file: !1, line: 351, column: 17)
!1283 = !MDLocation(line: 351, column: 19, scope: !1282)
!1284 = !MDLocation(line: 351, column: 17, scope: !1147)
!1285 = !MDLocation(line: 353, column: 22, scope: !1286)
!1286 = distinct !MDLexicalBlock(scope: !1282, file: !1, line: 351, column: 27)
!1287 = !MDLocation(line: 353, column: 25, scope: !1286)
!1288 = !MDLocation(line: 353, column: 24, scope: !1286)
!1289 = !MDLocation(line: 353, column: 20, scope: !1286)
!1290 = !MDLocation(line: 353, column: 33, scope: !1291)
!1291 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 353, column: 33)
!1292 = !MDLocation(line: 353, column: 36, scope: !1291)
!1293 = !MDLocation(line: 353, column: 33, scope: !1286)
!1294 = !MDLocation(line: 353, column: 45, scope: !1291)
!1295 = !MDLocation(line: 353, column: 42, scope: !1291)
!1296 = !MDLocation(line: 353, column: 55, scope: !1297)
!1297 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 353, column: 55)
!1298 = !MDLocation(line: 353, column: 58, scope: !1297)
!1299 = !MDLocation(line: 353, column: 55, scope: !1286)
!1300 = !MDLocation(line: 353, column: 68, scope: !1297)
!1301 = !MDLocation(line: 353, column: 65, scope: !1297)
!1302 = !MDLocation(line: 354, column: 31, scope: !1286)
!1303 = !MDLocation(line: 354, column: 26, scope: !1286)
!1304 = !MDLocation(line: 354, column: 24, scope: !1286)
!1305 = !MDLocation(line: 355, column: 27, scope: !1286)
!1306 = !MDLocation(line: 355, column: 36, scope: !1286)
!1307 = !MDLocation(line: 355, column: 42, scope: !1286)
!1308 = !MDLocation(line: 355, column: 34, scope: !1286)
!1309 = !MDLocation(line: 355, column: 25, scope: !1286)
!1310 = !MDLocation(line: 356, column: 28, scope: !1286)
!1311 = !MDLocation(line: 356, column: 34, scope: !1286)
!1312 = !MDLocation(line: 356, column: 45, scope: !1286)
!1313 = !MDLocation(line: 356, column: 44, scope: !1286)
!1314 = !MDLocation(line: 356, column: 54, scope: !1286)
!1315 = !MDLocation(line: 356, column: 53, scope: !1286)
!1316 = !MDLocation(line: 356, column: 25, scope: !1286)
!1317 = !MDLocation(line: 357, column: 28, scope: !1286)
!1318 = !MDLocation(line: 357, column: 24, scope: !1286)
!1319 = !MDLocation(line: 357, column: 22, scope: !1286)
!1320 = !MDLocation(line: 357, column: 41, scope: !1321)
!1321 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 357, column: 41)
!1322 = !MDLocation(line: 357, column: 46, scope: !1321)
!1323 = !MDLocation(line: 357, column: 41, scope: !1286)
!1324 = !MDLocation(line: 357, column: 60, scope: !1321)
!1325 = !MDLocation(line: 357, column: 55, scope: !1321)
!1326 = !MDLocation(line: 358, column: 23, scope: !1286)
!1327 = !MDLocation(line: 358, column: 26, scope: !1286)
!1328 = !MDLocation(line: 358, column: 25, scope: !1286)
!1329 = !MDLocation(line: 358, column: 21, scope: !1286)
!1330 = !MDLocation(line: 358, column: 38, scope: !1286)
!1331 = !MDLocation(line: 358, column: 41, scope: !1286)
!1332 = !MDLocation(line: 358, column: 40, scope: !1286)
!1333 = !MDLocation(line: 358, column: 36, scope: !1286)
!1334 = !MDLocation(line: 359, column: 24, scope: !1286)
!1335 = !MDLocation(line: 360, column: 22, scope: !1286)
!1336 = !MDLocation(line: 360, column: 28, scope: !1286)
!1337 = !MDLocation(line: 360, column: 20, scope: !1286)
!1338 = !MDLocation(line: 361, column: 21, scope: !1339)
!1339 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 361, column: 21)
!1340 = !MDLocation(line: 361, column: 25, scope: !1339)
!1341 = !MDLocation(line: 361, column: 31, scope: !1339)
!1342 = !MDLocation(line: 361, column: 21, scope: !1286)
!1343 = !MDLocation(line: 362, column: 26, scope: !1344)
!1344 = distinct !MDLexicalBlock(scope: !1339, file: !1, line: 361, column: 36)
!1345 = !MDLocation(line: 362, column: 31, scope: !1344)
!1346 = !MDLocation(line: 362, column: 35, scope: !1344)
!1347 = !MDLocation(line: 362, column: 29, scope: !1344)
!1348 = !MDLocation(line: 362, column: 44, scope: !1344)
!1349 = !MDLocation(line: 362, column: 48, scope: !1344)
!1350 = !MDLocation(line: 362, column: 56, scope: !1344)
!1351 = !MDLocation(line: 362, column: 60, scope: !1344)
!1352 = !MDLocation(line: 362, column: 55, scope: !1344)
!1353 = !MDLocation(line: 362, column: 42, scope: !1344)
!1354 = !MDLocation(line: 362, column: 24, scope: !1344)
!1355 = !MDLocation(line: 363, column: 30, scope: !1344)
!1356 = !MDLocation(line: 363, column: 36, scope: !1344)
!1357 = !MDLocation(line: 363, column: 40, scope: !1344)
!1358 = !MDLocation(line: 363, column: 39, scope: !1344)
!1359 = !MDLocation(line: 363, column: 48, scope: !1344)
!1360 = !MDLocation(line: 363, column: 47, scope: !1344)
!1361 = !MDLocation(line: 363, column: 51, scope: !1344)
!1362 = !MDLocation(line: 363, column: 50, scope: !1344)
!1363 = !MDLocation(line: 363, column: 54, scope: !1344)
!1364 = !MDLocation(line: 363, column: 58, scope: !1344)
!1365 = !MDLocation(line: 363, column: 53, scope: !1344)
!1366 = !MDLocation(line: 363, column: 28, scope: !1344)
!1367 = !MDLocation(line: 364, column: 33, scope: !1344)
!1368 = !MDLocation(line: 364, column: 39, scope: !1344)
!1369 = !MDLocation(line: 364, column: 32, scope: !1344)
!1370 = !MDLocation(line: 364, column: 42, scope: !1344)
!1371 = !MDLocation(line: 364, column: 41, scope: !1344)
!1372 = !MDLocation(line: 364, column: 51, scope: !1344)
!1373 = !MDLocation(line: 364, column: 50, scope: !1344)
!1374 = !MDLocation(line: 364, column: 56, scope: !1344)
!1375 = !MDLocation(line: 364, column: 60, scope: !1344)
!1376 = !MDLocation(line: 364, column: 64, scope: !1344)
!1377 = !MDLocation(line: 364, column: 68, scope: !1344)
!1378 = !MDLocation(line: 364, column: 71, scope: !1344)
!1379 = !MDLocation(line: 364, column: 75, scope: !1344)
!1380 = !MDLocation(line: 364, column: 70, scope: !1344)
!1381 = !MDLocation(line: 364, column: 62, scope: !1344)
!1382 = !MDLocation(line: 364, column: 54, scope: !1344)
!1383 = !MDLocation(line: 364, column: 82, scope: !1344)
!1384 = !MDLocation(line: 364, column: 86, scope: !1344)
!1385 = !MDLocation(line: 364, column: 81, scope: !1344)
!1386 = !MDLocation(line: 364, column: 28, scope: !1344)
!1387 = !MDLocation(line: 365, column: 17, scope: !1344)
!1388 = !MDLocation(line: 366, column: 22, scope: !1286)
!1389 = !MDLocation(line: 366, column: 28, scope: !1286)
!1390 = !MDLocation(line: 366, column: 20, scope: !1286)
!1391 = !MDLocation(line: 367, column: 21, scope: !1392)
!1392 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 367, column: 21)
!1393 = !MDLocation(line: 367, column: 25, scope: !1392)
!1394 = !MDLocation(line: 367, column: 31, scope: !1392)
!1395 = !MDLocation(line: 367, column: 21, scope: !1286)
!1396 = !MDLocation(line: 368, column: 26, scope: !1397)
!1397 = distinct !MDLexicalBlock(scope: !1392, file: !1, line: 367, column: 36)
!1398 = !MDLocation(line: 368, column: 31, scope: !1397)
!1399 = !MDLocation(line: 368, column: 35, scope: !1397)
!1400 = !MDLocation(line: 368, column: 29, scope: !1397)
!1401 = !MDLocation(line: 368, column: 44, scope: !1397)
!1402 = !MDLocation(line: 368, column: 48, scope: !1397)
!1403 = !MDLocation(line: 368, column: 56, scope: !1397)
!1404 = !MDLocation(line: 368, column: 60, scope: !1397)
!1405 = !MDLocation(line: 368, column: 55, scope: !1397)
!1406 = !MDLocation(line: 368, column: 42, scope: !1397)
!1407 = !MDLocation(line: 368, column: 24, scope: !1397)
!1408 = !MDLocation(line: 369, column: 31, scope: !1397)
!1409 = !MDLocation(line: 369, column: 37, scope: !1397)
!1410 = !MDLocation(line: 369, column: 41, scope: !1397)
!1411 = !MDLocation(line: 369, column: 40, scope: !1397)
!1412 = !MDLocation(line: 369, column: 49, scope: !1397)
!1413 = !MDLocation(line: 369, column: 48, scope: !1397)
!1414 = !MDLocation(line: 369, column: 52, scope: !1397)
!1415 = !MDLocation(line: 369, column: 51, scope: !1397)
!1416 = !MDLocation(line: 369, column: 55, scope: !1397)
!1417 = !MDLocation(line: 369, column: 59, scope: !1397)
!1418 = !MDLocation(line: 369, column: 54, scope: !1397)
!1419 = !MDLocation(line: 369, column: 28, scope: !1397)
!1420 = !MDLocation(line: 370, column: 33, scope: !1397)
!1421 = !MDLocation(line: 370, column: 39, scope: !1397)
!1422 = !MDLocation(line: 370, column: 32, scope: !1397)
!1423 = !MDLocation(line: 370, column: 42, scope: !1397)
!1424 = !MDLocation(line: 370, column: 41, scope: !1397)
!1425 = !MDLocation(line: 370, column: 51, scope: !1397)
!1426 = !MDLocation(line: 370, column: 50, scope: !1397)
!1427 = !MDLocation(line: 370, column: 56, scope: !1397)
!1428 = !MDLocation(line: 370, column: 60, scope: !1397)
!1429 = !MDLocation(line: 370, column: 64, scope: !1397)
!1430 = !MDLocation(line: 370, column: 68, scope: !1397)
!1431 = !MDLocation(line: 370, column: 71, scope: !1397)
!1432 = !MDLocation(line: 370, column: 75, scope: !1397)
!1433 = !MDLocation(line: 370, column: 70, scope: !1397)
!1434 = !MDLocation(line: 370, column: 62, scope: !1397)
!1435 = !MDLocation(line: 370, column: 54, scope: !1397)
!1436 = !MDLocation(line: 370, column: 82, scope: !1397)
!1437 = !MDLocation(line: 370, column: 86, scope: !1397)
!1438 = !MDLocation(line: 370, column: 81, scope: !1397)
!1439 = !MDLocation(line: 370, column: 28, scope: !1397)
!1440 = !MDLocation(line: 371, column: 17, scope: !1397)
!1441 = !MDLocation(line: 374, column: 25, scope: !1286)
!1442 = !MDLocation(line: 374, column: 28, scope: !1286)
!1443 = !MDLocation(line: 374, column: 27, scope: !1286)
!1444 = !MDLocation(line: 374, column: 33, scope: !1286)
!1445 = !MDLocation(line: 374, column: 36, scope: !1286)
!1446 = !MDLocation(line: 374, column: 35, scope: !1286)
!1447 = !MDLocation(line: 374, column: 39, scope: !1286)
!1448 = !MDLocation(line: 374, column: 38, scope: !1286)
!1449 = !MDLocation(line: 374, column: 31, scope: !1286)
!1450 = !MDLocation(line: 374, column: 23, scope: !1286)
!1451 = !MDLocation(line: 374, column: 43, scope: !1286)
!1452 = !MDLocation(line: 374, column: 42, scope: !1286)
!1453 = !MDLocation(line: 374, column: 47, scope: !1286)
!1454 = !MDLocation(line: 374, column: 46, scope: !1286)
!1455 = !MDLocation(line: 374, column: 21, scope: !1286)
!1456 = !MDLocation(line: 375, column: 25, scope: !1286)
!1457 = !MDLocation(line: 375, column: 28, scope: !1286)
!1458 = !MDLocation(line: 375, column: 27, scope: !1286)
!1459 = !MDLocation(line: 375, column: 33, scope: !1286)
!1460 = !MDLocation(line: 375, column: 36, scope: !1286)
!1461 = !MDLocation(line: 375, column: 35, scope: !1286)
!1462 = !MDLocation(line: 375, column: 39, scope: !1286)
!1463 = !MDLocation(line: 375, column: 38, scope: !1286)
!1464 = !MDLocation(line: 375, column: 31, scope: !1286)
!1465 = !MDLocation(line: 375, column: 23, scope: !1286)
!1466 = !MDLocation(line: 375, column: 43, scope: !1286)
!1467 = !MDLocation(line: 375, column: 42, scope: !1286)
!1468 = !MDLocation(line: 375, column: 47, scope: !1286)
!1469 = !MDLocation(line: 375, column: 46, scope: !1286)
!1470 = !MDLocation(line: 375, column: 21, scope: !1286)
!1471 = !MDLocation(line: 376, column: 25, scope: !1286)
!1472 = !MDLocation(line: 376, column: 28, scope: !1286)
!1473 = !MDLocation(line: 376, column: 27, scope: !1286)
!1474 = !MDLocation(line: 376, column: 33, scope: !1286)
!1475 = !MDLocation(line: 376, column: 36, scope: !1286)
!1476 = !MDLocation(line: 376, column: 35, scope: !1286)
!1477 = !MDLocation(line: 376, column: 39, scope: !1286)
!1478 = !MDLocation(line: 376, column: 38, scope: !1286)
!1479 = !MDLocation(line: 376, column: 31, scope: !1286)
!1480 = !MDLocation(line: 376, column: 23, scope: !1286)
!1481 = !MDLocation(line: 376, column: 43, scope: !1286)
!1482 = !MDLocation(line: 376, column: 42, scope: !1286)
!1483 = !MDLocation(line: 376, column: 47, scope: !1286)
!1484 = !MDLocation(line: 376, column: 46, scope: !1286)
!1485 = !MDLocation(line: 376, column: 21, scope: !1286)
!1486 = !MDLocation(line: 377, column: 25, scope: !1286)
!1487 = !MDLocation(line: 377, column: 28, scope: !1286)
!1488 = !MDLocation(line: 377, column: 27, scope: !1286)
!1489 = !MDLocation(line: 377, column: 33, scope: !1286)
!1490 = !MDLocation(line: 377, column: 36, scope: !1286)
!1491 = !MDLocation(line: 377, column: 35, scope: !1286)
!1492 = !MDLocation(line: 377, column: 39, scope: !1286)
!1493 = !MDLocation(line: 377, column: 38, scope: !1286)
!1494 = !MDLocation(line: 377, column: 31, scope: !1286)
!1495 = !MDLocation(line: 377, column: 23, scope: !1286)
!1496 = !MDLocation(line: 377, column: 43, scope: !1286)
!1497 = !MDLocation(line: 377, column: 42, scope: !1286)
!1498 = !MDLocation(line: 377, column: 47, scope: !1286)
!1499 = !MDLocation(line: 377, column: 46, scope: !1286)
!1500 = !MDLocation(line: 377, column: 21, scope: !1286)
!1501 = !MDLocation(line: 378, column: 25, scope: !1286)
!1502 = !MDLocation(line: 378, column: 28, scope: !1286)
!1503 = !MDLocation(line: 378, column: 27, scope: !1286)
!1504 = !MDLocation(line: 378, column: 33, scope: !1286)
!1505 = !MDLocation(line: 378, column: 36, scope: !1286)
!1506 = !MDLocation(line: 378, column: 35, scope: !1286)
!1507 = !MDLocation(line: 378, column: 39, scope: !1286)
!1508 = !MDLocation(line: 378, column: 38, scope: !1286)
!1509 = !MDLocation(line: 378, column: 31, scope: !1286)
!1510 = !MDLocation(line: 378, column: 23, scope: !1286)
!1511 = !MDLocation(line: 378, column: 43, scope: !1286)
!1512 = !MDLocation(line: 378, column: 42, scope: !1286)
!1513 = !MDLocation(line: 378, column: 47, scope: !1286)
!1514 = !MDLocation(line: 378, column: 46, scope: !1286)
!1515 = !MDLocation(line: 378, column: 21, scope: !1286)
!1516 = !MDLocation(line: 379, column: 25, scope: !1286)
!1517 = !MDLocation(line: 379, column: 28, scope: !1286)
!1518 = !MDLocation(line: 379, column: 27, scope: !1286)
!1519 = !MDLocation(line: 379, column: 33, scope: !1286)
!1520 = !MDLocation(line: 379, column: 36, scope: !1286)
!1521 = !MDLocation(line: 379, column: 35, scope: !1286)
!1522 = !MDLocation(line: 379, column: 39, scope: !1286)
!1523 = !MDLocation(line: 379, column: 38, scope: !1286)
!1524 = !MDLocation(line: 379, column: 31, scope: !1286)
!1525 = !MDLocation(line: 379, column: 23, scope: !1286)
!1526 = !MDLocation(line: 379, column: 43, scope: !1286)
!1527 = !MDLocation(line: 379, column: 42, scope: !1286)
!1528 = !MDLocation(line: 379, column: 47, scope: !1286)
!1529 = !MDLocation(line: 379, column: 46, scope: !1286)
!1530 = !MDLocation(line: 379, column: 21, scope: !1286)
!1531 = !MDLocation(line: 380, column: 21, scope: !1532)
!1532 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 380, column: 21)
!1533 = !MDLocation(line: 380, column: 25, scope: !1532)
!1534 = !MDLocation(line: 380, column: 21, scope: !1286)
!1535 = !MDLocation(line: 382, column: 31, scope: !1536)
!1536 = distinct !MDLexicalBlock(scope: !1532, file: !1, line: 381, column: 17)
!1537 = !MDLocation(line: 382, column: 21, scope: !1536)
!1538 = !MDLocation(line: 382, column: 25, scope: !1536)
!1539 = !MDLocation(line: 382, column: 28, scope: !1536)
!1540 = !MDLocation(line: 383, column: 31, scope: !1536)
!1541 = !MDLocation(line: 383, column: 21, scope: !1536)
!1542 = !MDLocation(line: 383, column: 25, scope: !1536)
!1543 = !MDLocation(line: 383, column: 28, scope: !1536)
!1544 = !MDLocation(line: 384, column: 31, scope: !1536)
!1545 = !MDLocation(line: 384, column: 21, scope: !1536)
!1546 = !MDLocation(line: 384, column: 25, scope: !1536)
!1547 = !MDLocation(line: 384, column: 28, scope: !1536)
!1548 = !MDLocation(line: 385, column: 17, scope: !1536)
!1549 = !MDLocation(line: 387, column: 21, scope: !1550)
!1550 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 387, column: 21)
!1551 = !MDLocation(line: 387, column: 25, scope: !1550)
!1552 = !MDLocation(line: 387, column: 21, scope: !1286)
!1553 = !MDLocation(line: 389, column: 32, scope: !1554)
!1554 = distinct !MDLexicalBlock(scope: !1550, file: !1, line: 388, column: 17)
!1555 = !MDLocation(line: 389, column: 31, scope: !1554)
!1556 = !MDLocation(line: 389, column: 38, scope: !1554)
!1557 = !MDLocation(line: 389, column: 36, scope: !1554)
!1558 = !MDLocation(line: 389, column: 21, scope: !1554)
!1559 = !MDLocation(line: 389, column: 25, scope: !1554)
!1560 = !MDLocation(line: 389, column: 28, scope: !1554)
!1561 = !MDLocation(line: 390, column: 32, scope: !1554)
!1562 = !MDLocation(line: 390, column: 31, scope: !1554)
!1563 = !MDLocation(line: 390, column: 38, scope: !1554)
!1564 = !MDLocation(line: 390, column: 36, scope: !1554)
!1565 = !MDLocation(line: 390, column: 21, scope: !1554)
!1566 = !MDLocation(line: 390, column: 25, scope: !1554)
!1567 = !MDLocation(line: 390, column: 28, scope: !1554)
!1568 = !MDLocation(line: 391, column: 32, scope: !1554)
!1569 = !MDLocation(line: 391, column: 31, scope: !1554)
!1570 = !MDLocation(line: 391, column: 38, scope: !1554)
!1571 = !MDLocation(line: 391, column: 36, scope: !1554)
!1572 = !MDLocation(line: 391, column: 21, scope: !1554)
!1573 = !MDLocation(line: 391, column: 25, scope: !1554)
!1574 = !MDLocation(line: 391, column: 28, scope: !1554)
!1575 = !MDLocation(line: 392, column: 17, scope: !1554)
!1576 = !MDLocation(line: 394, column: 21, scope: !1577)
!1577 = distinct !MDLexicalBlock(scope: !1286, file: !1, line: 394, column: 21)
!1578 = !MDLocation(line: 394, column: 25, scope: !1577)
!1579 = !MDLocation(line: 394, column: 21, scope: !1286)
!1580 = !MDLocation(line: 396, column: 31, scope: !1581)
!1581 = distinct !MDLexicalBlock(scope: !1577, file: !1, line: 395, column: 17)
!1582 = !MDLocation(line: 396, column: 21, scope: !1581)
!1583 = !MDLocation(line: 396, column: 25, scope: !1581)
!1584 = !MDLocation(line: 396, column: 28, scope: !1581)
!1585 = !MDLocation(line: 397, column: 31, scope: !1581)
!1586 = !MDLocation(line: 397, column: 21, scope: !1581)
!1587 = !MDLocation(line: 397, column: 25, scope: !1581)
!1588 = !MDLocation(line: 397, column: 28, scope: !1581)
!1589 = !MDLocation(line: 398, column: 31, scope: !1581)
!1590 = !MDLocation(line: 398, column: 21, scope: !1581)
!1591 = !MDLocation(line: 398, column: 25, scope: !1581)
!1592 = !MDLocation(line: 398, column: 28, scope: !1581)
!1593 = !MDLocation(line: 399, column: 17, scope: !1581)
!1594 = !MDLocation(line: 400, column: 13, scope: !1286)
!1595 = !MDLocation(line: 401, column: 9, scope: !1147)
!1596 = !MDLocation(line: 404, column: 13, scope: !1597)
!1597 = distinct !MDLexicalBlock(scope: !1123, file: !1, line: 404, column: 13)
!1598 = !MDLocation(line: 404, column: 21, scope: !1597)
!1599 = !MDLocation(line: 404, column: 27, scope: !1597)
!1600 = !MDLocation(line: 404, column: 18, scope: !1597)
!1601 = !MDLocation(line: 404, column: 13, scope: !1123)
!1602 = !MDLocation(line: 404, column: 33, scope: !1597)
!1603 = !MDLocation(line: 405, column: 16, scope: !1123)
!1604 = !MDLocation(line: 405, column: 22, scope: !1123)
!1605 = !MDLocation(line: 405, column: 14, scope: !1123)
!1606 = !MDLocation(line: 411, column: 1, scope: !18)
!1607 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "a1", arg: 1, scope: !19, file: !1, line: 416, type: !22)
!1608 = !MDLocation(line: 416, column: 7, scope: !19)
!1609 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "bonded", arg: 2, scope: !19, file: !1, line: 416, type: !94)
!1610 = !MDLocation(line: 416, column: 12, scope: !19)
!1611 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "mbond", arg: 3, scope: !19, file: !1, line: 417, type: !9)
!1612 = !MDLocation(line: 417, column: 5, scope: !19)
!1613 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "inbond", arg: 4, scope: !19, file: !1, line: 417, type: !95)
!1614 = !MDLocation(line: 417, column: 12, scope: !19)
!1615 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "mine", scope: !19, file: !1, line: 419, type: !165)
!1616 = !MDLocation(line: 419, column: 10, scope: !19)
!1617 = !MDLocation(line: 420, column: 12, scope: !19)
!1618 = !MDLocation(line: 420, column: 10, scope: !19)
!1619 = !MDLocation(line: 421, column: 6, scope: !19)
!1620 = !MDLocation(line: 421, column: 13, scope: !19)
!1621 = !MDLocation(line: 422, column: 5, scope: !19)
!1622 = !MDLocation(line: 424, column: 14, scope: !1623)
!1623 = distinct !MDLexicalBlock(scope: !1624, file: !1, line: 424, column: 13)
!1624 = distinct !MDLexicalBlock(scope: !19, file: !1, line: 423, column: 5)
!1625 = !MDLocation(line: 424, column: 19, scope: !1623)
!1626 = !MDLocation(line: 424, column: 13, scope: !1624)
!1627 = !MDLocation(line: 426, column: 13, scope: !1628)
!1628 = distinct !MDLexicalBlock(scope: !1623, file: !1, line: 425, column: 9)
!1629 = !MDLocation(line: 428, column: 13, scope: !1630)
!1630 = distinct !MDLexicalBlock(scope: !1624, file: !1, line: 428, column: 13)
!1631 = !MDLocation(line: 428, column: 19, scope: !1630)
!1632 = !MDLocation(line: 428, column: 28, scope: !1630)
!1633 = !MDLocation(line: 428, column: 25, scope: !1630)
!1634 = !MDLocation(line: 428, column: 13, scope: !1624)
!1635 = !MDLocation(line: 430, column: 35, scope: !1636)
!1636 = distinct !MDLexicalBlock(scope: !1630, file: !1, line: 429, column: 9)
!1637 = !MDLocation(line: 430, column: 41, scope: !1636)
!1638 = !MDLocation(line: 430, column: 22, scope: !1636)
!1639 = !MDLocation(line: 430, column: 29, scope: !1636)
!1640 = !MDLocation(line: 430, column: 13, scope: !1636)
!1641 = !MDLocation(line: 430, column: 33, scope: !1636)
!1642 = !MDLocation(line: 431, column: 9, scope: !1636)
!1643 = !MDLocation(line: 432, column: 13, scope: !1644)
!1644 = distinct !MDLexicalBlock(scope: !1624, file: !1, line: 432, column: 13)
!1645 = !MDLocation(line: 432, column: 19, scope: !1644)
!1646 = !MDLocation(line: 432, column: 28, scope: !1644)
!1647 = !MDLocation(line: 432, column: 25, scope: !1644)
!1648 = !MDLocation(line: 432, column: 13, scope: !1624)
!1649 = !MDLocation(line: 434, column: 35, scope: !1650)
!1650 = distinct !MDLexicalBlock(scope: !1644, file: !1, line: 433, column: 9)
!1651 = !MDLocation(line: 434, column: 41, scope: !1650)
!1652 = !MDLocation(line: 434, column: 22, scope: !1650)
!1653 = !MDLocation(line: 434, column: 29, scope: !1650)
!1654 = !MDLocation(line: 434, column: 13, scope: !1650)
!1655 = !MDLocation(line: 434, column: 33, scope: !1650)
!1656 = !MDLocation(line: 435, column: 9, scope: !1650)
!1657 = !MDLocation(line: 436, column: 13, scope: !1658)
!1658 = distinct !MDLexicalBlock(scope: !1624, file: !1, line: 436, column: 13)
!1659 = !MDLocation(line: 436, column: 21, scope: !1658)
!1660 = !MDLocation(line: 436, column: 27, scope: !1658)
!1661 = !MDLocation(line: 436, column: 18, scope: !1658)
!1662 = !MDLocation(line: 436, column: 13, scope: !1624)
!1663 = !MDLocation(line: 436, column: 33, scope: !1658)
!1664 = !MDLocation(line: 437, column: 16, scope: !1624)
!1665 = !MDLocation(line: 437, column: 22, scope: !1624)
!1666 = !MDLocation(line: 437, column: 14, scope: !1624)
!1667 = !MDLocation(line: 438, column: 14, scope: !1668)
!1668 = distinct !MDLexicalBlock(scope: !1624, file: !1, line: 438, column: 13)
!1669 = !MDLocation(line: 438, column: 13, scope: !1668)
!1670 = !MDLocation(line: 438, column: 24, scope: !1668)
!1671 = !MDLocation(line: 438, column: 21, scope: !1668)
!1672 = !MDLocation(line: 438, column: 13, scope: !1624)
!1673 = !MDLocation(line: 438, column: 32, scope: !1668)
!1674 = !MDLocation(line: 440, column: 1, scope: !19)
!1675 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "where", arg: 1, scope: !96, file: !1, line: 448, type: !99)
!1676 = !MDLocation(line: 448, column: 7, scope: !96)
!1677 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "b", scope: !96, file: !1, line: 450, type: !165)
!1678 = !MDLocation(line: 450, column: 10, scope: !96)
!1679 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a1", scope: !96, file: !1, line: 451, type: !22)
!1680 = !MDLocation(line: 451, column: 11, scope: !96)
!1681 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a2", scope: !96, file: !1, line: 451, type: !22)
!1682 = !MDLocation(line: 451, column: 15, scope: !96)
!1683 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a3", scope: !96, file: !1, line: 451, type: !22)
!1684 = !MDLocation(line: 451, column: 19, scope: !96)
!1685 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "rtodeg", scope: !96, file: !1, line: 452, type: !10)
!1686 = !MDLocation(line: 452, column: 11, scope: !96)
!1687 = !MDLocation(line: 453, column: 9, scope: !96)
!1688 = !MDLocation(line: 453, column: 7, scope: !96)
!1689 = !MDLocation(line: 454, column: 9, scope: !1690)
!1690 = distinct !MDLexicalBlock(scope: !96, file: !1, line: 454, column: 9)
!1691 = !MDLocation(line: 454, column: 11, scope: !1690)
!1692 = !MDLocation(line: 454, column: 9, scope: !96)
!1693 = !MDLocation(line: 454, column: 21, scope: !1690)
!1694 = !MDLocation(line: 455, column: 19, scope: !96)
!1695 = !MDLocation(line: 455, column: 18, scope: !96)
!1696 = !MDLocation(line: 455, column: 14, scope: !96)
!1697 = !MDLocation(line: 455, column: 12, scope: !96)
!1698 = !MDLocation(line: 456, column: 5, scope: !96)
!1699 = !MDLocation(line: 456, column: 13, scope: !96)
!1700 = !MDLocation(line: 456, column: 16, scope: !96)
!1701 = !MDLocation(line: 456, column: 24, scope: !96)
!1702 = !MDLocation(line: 456, column: 21, scope: !96)
!1703 = !MDLocation(line: 458, column: 13, scope: !1704)
!1704 = distinct !MDLexicalBlock(scope: !1705, file: !1, line: 458, column: 13)
!1705 = distinct !MDLexicalBlock(scope: !96, file: !1, line: 457, column: 5)
!1706 = !MDLocation(line: 458, column: 16, scope: !1704)
!1707 = !MDLocation(line: 458, column: 21, scope: !1704)
!1708 = !MDLocation(line: 458, column: 13, scope: !1705)
!1709 = !MDLocation(line: 458, column: 30, scope: !1704)
!1710 = !MDLocation(line: 459, column: 14, scope: !1705)
!1711 = !MDLocation(line: 459, column: 17, scope: !1705)
!1712 = !MDLocation(line: 459, column: 12, scope: !1705)
!1713 = !MDLocation(line: 459, column: 29, scope: !1705)
!1714 = !MDLocation(line: 459, column: 32, scope: !1705)
!1715 = !MDLocation(line: 459, column: 27, scope: !1705)
!1716 = !MDLocation(line: 459, column: 43, scope: !1705)
!1717 = !MDLocation(line: 459, column: 46, scope: !1705)
!1718 = !MDLocation(line: 459, column: 41, scope: !1705)
!1719 = !MDLocation(line: 460, column: 18, scope: !1705)
!1720 = !MDLocation(line: 460, column: 59, scope: !1705)
!1721 = !MDLocation(line: 460, column: 63, scope: !1705)
!1722 = !MDLocation(line: 460, column: 70, scope: !1705)
!1723 = !MDLocation(line: 460, column: 74, scope: !1705)
!1724 = !MDLocation(line: 461, column: 18, scope: !1705)
!1725 = !MDLocation(line: 461, column: 23, scope: !1705)
!1726 = !MDLocation(line: 461, column: 30, scope: !1705)
!1727 = !MDLocation(line: 461, column: 33, scope: !1705)
!1728 = !MDLocation(line: 461, column: 39, scope: !1705)
!1729 = !MDLocation(line: 461, column: 38, scope: !1705)
!1730 = !MDLocation(line: 461, column: 46, scope: !1705)
!1731 = !MDLocation(line: 461, column: 49, scope: !1705)
!1732 = !MDLocation(line: 461, column: 59, scope: !1705)
!1733 = !MDLocation(line: 461, column: 58, scope: !1705)
!1734 = !MDLocation(line: 462, column: 18, scope: !1705)
!1735 = !MDLocation(line: 462, column: 21, scope: !1705)
!1736 = !MDLocation(line: 462, column: 25, scope: !1705)
!1737 = !MDLocation(line: 462, column: 28, scope: !1705)
!1738 = !MDLocation(line: 462, column: 33, scope: !1705)
!1739 = !MDLocation(line: 462, column: 36, scope: !1705)
!1740 = !MDLocation(line: 460, column: 9, scope: !1705)
!1741 = !MDLocation(line: 463, column: 13, scope: !1705)
!1742 = !MDLocation(line: 463, column: 16, scope: !1705)
!1743 = !MDLocation(line: 463, column: 11, scope: !1705)
!1744 = !MDLocation(line: 465, column: 9, scope: !1745)
!1745 = distinct !MDLexicalBlock(scope: !96, file: !1, line: 465, column: 9)
!1746 = !MDLocation(line: 465, column: 12, scope: !1745)
!1747 = !MDLocation(line: 465, column: 17, scope: !1745)
!1748 = !MDLocation(line: 465, column: 9, scope: !96)
!1749 = !MDLocation(line: 465, column: 26, scope: !1745)
!1750 = !MDLocation(line: 466, column: 10, scope: !96)
!1751 = !MDLocation(line: 466, column: 13, scope: !96)
!1752 = !MDLocation(line: 466, column: 8, scope: !96)
!1753 = !MDLocation(line: 466, column: 25, scope: !96)
!1754 = !MDLocation(line: 466, column: 28, scope: !96)
!1755 = !MDLocation(line: 466, column: 23, scope: !96)
!1756 = !MDLocation(line: 466, column: 39, scope: !96)
!1757 = !MDLocation(line: 466, column: 42, scope: !96)
!1758 = !MDLocation(line: 466, column: 37, scope: !96)
!1759 = !MDLocation(line: 467, column: 14, scope: !96)
!1760 = !MDLocation(line: 467, column: 54, scope: !96)
!1761 = !MDLocation(line: 467, column: 58, scope: !96)
!1762 = !MDLocation(line: 467, column: 65, scope: !96)
!1763 = !MDLocation(line: 467, column: 69, scope: !96)
!1764 = !MDLocation(line: 468, column: 14, scope: !96)
!1765 = !MDLocation(line: 468, column: 19, scope: !96)
!1766 = !MDLocation(line: 468, column: 26, scope: !96)
!1767 = !MDLocation(line: 468, column: 29, scope: !96)
!1768 = !MDLocation(line: 468, column: 35, scope: !96)
!1769 = !MDLocation(line: 468, column: 34, scope: !96)
!1770 = !MDLocation(line: 468, column: 42, scope: !96)
!1771 = !MDLocation(line: 468, column: 45, scope: !96)
!1772 = !MDLocation(line: 468, column: 55, scope: !96)
!1773 = !MDLocation(line: 468, column: 54, scope: !96)
!1774 = !MDLocation(line: 469, column: 14, scope: !96)
!1775 = !MDLocation(line: 469, column: 17, scope: !96)
!1776 = !MDLocation(line: 469, column: 21, scope: !96)
!1777 = !MDLocation(line: 469, column: 24, scope: !96)
!1778 = !MDLocation(line: 469, column: 29, scope: !96)
!1779 = !MDLocation(line: 469, column: 32, scope: !96)
!1780 = !MDLocation(line: 467, column: 5, scope: !96)
!1781 = !MDLocation(line: 470, column: 1, scope: !96)
!1782 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "V", arg: 1, scope: !160, file: !1, line: 479, type: !14)
!1783 = !MDLocation(line: 479, column: 8, scope: !160)
!1784 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "lambda", arg: 2, scope: !160, file: !1, line: 479, type: !10)
!1785 = !MDLocation(line: 479, column: 10, scope: !160)
!1786 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "ilow", arg: 3, scope: !160, file: !1, line: 480, type: !9)
!1787 = !MDLocation(line: 480, column: 5, scope: !160)
!1788 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "ihigh", arg: 4, scope: !160, file: !1, line: 480, type: !9)
!1789 = !MDLocation(line: 480, column: 10, scope: !160)
!1790 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "op", arg: 5, scope: !160, file: !1, line: 481, type: !99)
!1791 = !MDLocation(line: 481, column: 7, scope: !160)
!1792 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "bp", scope: !160, file: !1, line: 483, type: !319)
!1793 = !MDLocation(line: 483, column: 11, scope: !160)
!1794 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "r", scope: !160, file: !1, line: 484, type: !10)
!1795 = !MDLocation(line: 484, column: 11, scope: !160)
!1796 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !160, file: !1, line: 484, type: !10)
!1797 = !MDLocation(line: 484, column: 13, scope: !160)
!1798 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y1", scope: !160, file: !1, line: 484, type: !10)
!1799 = !MDLocation(line: 484, column: 16, scope: !160)
!1800 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "z1", scope: !160, file: !1, line: 484, type: !10)
!1801 = !MDLocation(line: 484, column: 19, scope: !160)
!1802 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "keff", scope: !160, file: !1, line: 485, type: !10)
!1803 = !MDLocation(line: 485, column: 11, scope: !160)
!1804 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "length_eff", scope: !160, file: !1, line: 485, type: !10)
!1805 = !MDLocation(line: 485, column: 16, scope: !160)
!1806 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a1", scope: !160, file: !1, line: 486, type: !22)
!1807 = !MDLocation(line: 486, column: 11, scope: !160)
!1808 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a2", scope: !160, file: !1, line: 486, type: !22)
!1809 = !MDLocation(line: 486, column: 15, scope: !160)
!1810 = !MDLocation(line: 489, column: 10, scope: !160)
!1811 = !MDLocation(line: 489, column: 8, scope: !160)
!1812 = !MDLocation(line: 490, column: 9, scope: !1813)
!1813 = distinct !MDLexicalBlock(scope: !160, file: !1, line: 490, column: 9)
!1814 = !MDLocation(line: 490, column: 12, scope: !1813)
!1815 = !MDLocation(line: 490, column: 9, scope: !160)
!1816 = !MDLocation(line: 490, column: 22, scope: !1813)
!1817 = !MDLocation(line: 491, column: 9, scope: !1818)
!1818 = distinct !MDLexicalBlock(scope: !160, file: !1, line: 491, column: 9)
!1819 = !MDLocation(line: 491, column: 19, scope: !1818)
!1820 = !MDLocation(line: 491, column: 9, scope: !160)
!1821 = !MDLocation(line: 491, column: 29, scope: !1818)
!1822 = !MDLocation(line: 493, column: 12, scope: !160)
!1823 = !MDLocation(line: 493, column: 5, scope: !160)
!1824 = !MDLocation(line: 494, column: 5, scope: !160)
!1825 = !MDLocation(line: 496, column: 13, scope: !1826)
!1826 = distinct !MDLexicalBlock(scope: !1827, file: !1, line: 496, column: 13)
!1827 = distinct !MDLexicalBlock(scope: !160, file: !1, line: 495, column: 5)
!1828 = !MDLocation(line: 496, column: 16, scope: !1826)
!1829 = !MDLocation(line: 496, column: 13, scope: !1827)
!1830 = !MDLocation(line: 496, column: 25, scope: !1826)
!1831 = !MDLocation(line: 497, column: 14, scope: !1827)
!1832 = !MDLocation(line: 497, column: 18, scope: !1827)
!1833 = !MDLocation(line: 497, column: 12, scope: !1827)
!1834 = !MDLocation(line: 497, column: 30, scope: !1827)
!1835 = !MDLocation(line: 497, column: 34, scope: !1827)
!1836 = !MDLocation(line: 497, column: 28, scope: !1827)
!1837 = !MDLocation(line: 498, column: 14, scope: !1838)
!1838 = distinct !MDLexicalBlock(scope: !1827, file: !1, line: 498, column: 13)
!1839 = !MDLocation(line: 498, column: 18, scope: !1838)
!1840 = !MDLocation(line: 498, column: 28, scope: !1838)
!1841 = !MDLocation(line: 498, column: 25, scope: !1838)
!1842 = !MDLocation(line: 498, column: 33, scope: !1838)
!1843 = !MDLocation(line: 498, column: 36, scope: !1838)
!1844 = !MDLocation(line: 498, column: 40, scope: !1838)
!1845 = !MDLocation(line: 498, column: 50, scope: !1838)
!1846 = !MDLocation(line: 498, column: 47, scope: !1838)
!1847 = !MDLocation(line: 499, column: 17, scope: !1838)
!1848 = !MDLocation(line: 499, column: 22, scope: !1838)
!1849 = !MDLocation(line: 499, column: 26, scope: !1838)
!1850 = !MDLocation(line: 499, column: 36, scope: !1838)
!1851 = !MDLocation(line: 499, column: 33, scope: !1838)
!1852 = !MDLocation(line: 499, column: 41, scope: !1838)
!1853 = !MDLocation(line: 499, column: 44, scope: !1838)
!1854 = !MDLocation(line: 499, column: 48, scope: !1838)
!1855 = !MDLocation(line: 499, column: 58, scope: !1838)
!1856 = !MDLocation(line: 499, column: 55, scope: !1838)
!1857 = !MDLocation(line: 498, column: 13, scope: !1827)
!1858 = !MDLocation(line: 501, column: 19, scope: !1859)
!1859 = distinct !MDLexicalBlock(scope: !1838, file: !1, line: 500, column: 9)
!1860 = !MDLocation(line: 501, column: 23, scope: !1859)
!1861 = !MDLocation(line: 501, column: 26, scope: !1859)
!1862 = !MDLocation(line: 501, column: 30, scope: !1859)
!1863 = !MDLocation(line: 501, column: 25, scope: !1859)
!1864 = !MDLocation(line: 501, column: 33, scope: !1859)
!1865 = !MDLocation(line: 501, column: 41, scope: !1859)
!1866 = !MDLocation(line: 501, column: 45, scope: !1859)
!1867 = !MDLocation(line: 501, column: 48, scope: !1859)
!1868 = !MDLocation(line: 501, column: 52, scope: !1859)
!1869 = !MDLocation(line: 501, column: 47, scope: !1859)
!1870 = !MDLocation(line: 501, column: 39, scope: !1859)
!1871 = !MDLocation(line: 501, column: 32, scope: !1859)
!1872 = !MDLocation(line: 501, column: 16, scope: !1859)
!1873 = !MDLocation(line: 502, column: 19, scope: !1859)
!1874 = !MDLocation(line: 502, column: 23, scope: !1859)
!1875 = !MDLocation(line: 502, column: 26, scope: !1859)
!1876 = !MDLocation(line: 502, column: 30, scope: !1859)
!1877 = !MDLocation(line: 502, column: 25, scope: !1859)
!1878 = !MDLocation(line: 502, column: 33, scope: !1859)
!1879 = !MDLocation(line: 502, column: 41, scope: !1859)
!1880 = !MDLocation(line: 502, column: 45, scope: !1859)
!1881 = !MDLocation(line: 502, column: 48, scope: !1859)
!1882 = !MDLocation(line: 502, column: 52, scope: !1859)
!1883 = !MDLocation(line: 502, column: 47, scope: !1859)
!1884 = !MDLocation(line: 502, column: 39, scope: !1859)
!1885 = !MDLocation(line: 502, column: 32, scope: !1859)
!1886 = !MDLocation(line: 502, column: 16, scope: !1859)
!1887 = !MDLocation(line: 503, column: 19, scope: !1859)
!1888 = !MDLocation(line: 503, column: 23, scope: !1859)
!1889 = !MDLocation(line: 503, column: 26, scope: !1859)
!1890 = !MDLocation(line: 503, column: 30, scope: !1859)
!1891 = !MDLocation(line: 503, column: 25, scope: !1859)
!1892 = !MDLocation(line: 503, column: 33, scope: !1859)
!1893 = !MDLocation(line: 503, column: 41, scope: !1859)
!1894 = !MDLocation(line: 503, column: 45, scope: !1859)
!1895 = !MDLocation(line: 503, column: 48, scope: !1859)
!1896 = !MDLocation(line: 503, column: 52, scope: !1859)
!1897 = !MDLocation(line: 503, column: 47, scope: !1859)
!1898 = !MDLocation(line: 503, column: 39, scope: !1859)
!1899 = !MDLocation(line: 503, column: 32, scope: !1859)
!1900 = !MDLocation(line: 503, column: 16, scope: !1859)
!1901 = !MDLocation(line: 505, column: 17, scope: !1859)
!1902 = !MDLocation(line: 505, column: 20, scope: !1859)
!1903 = !MDLocation(line: 505, column: 19, scope: !1859)
!1904 = !MDLocation(line: 505, column: 25, scope: !1859)
!1905 = !MDLocation(line: 505, column: 28, scope: !1859)
!1906 = !MDLocation(line: 505, column: 27, scope: !1859)
!1907 = !MDLocation(line: 505, column: 23, scope: !1859)
!1908 = !MDLocation(line: 505, column: 33, scope: !1859)
!1909 = !MDLocation(line: 505, column: 36, scope: !1859)
!1910 = !MDLocation(line: 505, column: 35, scope: !1859)
!1911 = !MDLocation(line: 505, column: 31, scope: !1859)
!1912 = !MDLocation(line: 505, column: 15, scope: !1859)
!1913 = !MDLocation(line: 506, column: 22, scope: !1859)
!1914 = !MDLocation(line: 506, column: 17, scope: !1859)
!1915 = !MDLocation(line: 506, column: 15, scope: !1859)
!1916 = !MDLocation(line: 507, column: 17, scope: !1917)
!1917 = distinct !MDLexicalBlock(scope: !1859, file: !1, line: 507, column: 17)
!1918 = !MDLocation(line: 507, column: 21, scope: !1917)
!1919 = !MDLocation(line: 507, column: 27, scope: !1917)
!1920 = !MDLocation(line: 507, column: 17, scope: !1859)
!1921 = !MDLocation(line: 509, column: 24, scope: !1922)
!1922 = distinct !MDLexicalBlock(scope: !1917, file: !1, line: 508, column: 13)
!1923 = !MDLocation(line: 509, column: 28, scope: !1922)
!1924 = !MDLocation(line: 509, column: 22, scope: !1922)
!1925 = !MDLocation(line: 510, column: 30, scope: !1922)
!1926 = !MDLocation(line: 510, column: 34, scope: !1922)
!1927 = !MDLocation(line: 510, column: 28, scope: !1922)
!1928 = !MDLocation(line: 511, column: 13, scope: !1922)
!1929 = !MDLocation(line: 512, column: 24, scope: !1930)
!1930 = distinct !MDLexicalBlock(scope: !1917, file: !1, line: 511, column: 20)
!1931 = !MDLocation(line: 512, column: 28, scope: !1930)
!1932 = !MDLocation(line: 512, column: 32, scope: !1930)
!1933 = !MDLocation(line: 512, column: 36, scope: !1930)
!1934 = !MDLocation(line: 512, column: 39, scope: !1930)
!1935 = !MDLocation(line: 512, column: 43, scope: !1930)
!1936 = !MDLocation(line: 512, column: 38, scope: !1930)
!1937 = !MDLocation(line: 512, column: 30, scope: !1930)
!1938 = !MDLocation(line: 512, column: 22, scope: !1930)
!1939 = !MDLocation(line: 513, column: 30, scope: !1930)
!1940 = !MDLocation(line: 513, column: 34, scope: !1930)
!1941 = !MDLocation(line: 513, column: 43, scope: !1930)
!1942 = !MDLocation(line: 513, column: 47, scope: !1930)
!1943 = !MDLocation(line: 513, column: 55, scope: !1930)
!1944 = !MDLocation(line: 513, column: 59, scope: !1930)
!1945 = !MDLocation(line: 513, column: 54, scope: !1930)
!1946 = !MDLocation(line: 513, column: 41, scope: !1930)
!1947 = !MDLocation(line: 513, column: 28, scope: !1930)
!1948 = !MDLocation(line: 515, column: 19, scope: !1859)
!1949 = !MDLocation(line: 515, column: 25, scope: !1859)
!1950 = !MDLocation(line: 515, column: 27, scope: !1859)
!1951 = !MDLocation(line: 515, column: 26, scope: !1859)
!1952 = !MDLocation(line: 515, column: 23, scope: !1859)
!1953 = !MDLocation(line: 515, column: 40, scope: !1859)
!1954 = !MDLocation(line: 515, column: 42, scope: !1859)
!1955 = !MDLocation(line: 515, column: 41, scope: !1859)
!1956 = !MDLocation(line: 515, column: 38, scope: !1859)
!1957 = !MDLocation(line: 515, column: 14, scope: !1859)
!1958 = !MDLocation(line: 515, column: 16, scope: !1859)
!1959 = !MDLocation(line: 517, column: 21, scope: !1859)
!1960 = !MDLocation(line: 518, column: 22, scope: !1859)
!1961 = !MDLocation(line: 518, column: 26, scope: !1859)
!1962 = !MDLocation(line: 518, column: 33, scope: !1859)
!1963 = !MDLocation(line: 518, column: 37, scope: !1859)
!1964 = !MDLocation(line: 518, column: 45, scope: !1859)
!1965 = !MDLocation(line: 518, column: 51, scope: !1859)
!1966 = !MDLocation(line: 518, column: 53, scope: !1859)
!1967 = !MDLocation(line: 518, column: 52, scope: !1859)
!1968 = !MDLocation(line: 518, column: 49, scope: !1859)
!1969 = !MDLocation(line: 518, column: 66, scope: !1859)
!1970 = !MDLocation(line: 518, column: 68, scope: !1859)
!1971 = !MDLocation(line: 518, column: 67, scope: !1859)
!1972 = !MDLocation(line: 518, column: 64, scope: !1859)
!1973 = !MDLocation(line: 519, column: 21, scope: !1859)
!1974 = !MDLocation(line: 519, column: 23, scope: !1859)
!1975 = !MDLocation(line: 519, column: 28, scope: !1859)
!1976 = !MDLocation(line: 519, column: 30, scope: !1859)
!1977 = !MDLocation(line: 519, column: 29, scope: !1859)
!1978 = !MDLocation(line: 517, column: 13, scope: !1859)
!1979 = !MDLocation(line: 520, column: 9, scope: !1859)
!1980 = !MDLocation(line: 521, column: 13, scope: !1981)
!1981 = distinct !MDLexicalBlock(scope: !1827, file: !1, line: 521, column: 13)
!1982 = !MDLocation(line: 521, column: 19, scope: !1981)
!1983 = !MDLocation(line: 521, column: 23, scope: !1981)
!1984 = !MDLocation(line: 521, column: 16, scope: !1981)
!1985 = !MDLocation(line: 521, column: 13, scope: !1827)
!1986 = !MDLocation(line: 521, column: 30, scope: !1981)
!1987 = !MDLocation(line: 522, column: 14, scope: !1827)
!1988 = !MDLocation(line: 522, column: 18, scope: !1827)
!1989 = !MDLocation(line: 522, column: 12, scope: !1827)
!1990 = !MDLocation(line: 524, column: 1, scope: !160)
