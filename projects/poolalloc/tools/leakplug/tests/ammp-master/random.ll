; ModuleID = 'ammp-master/random.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

@randf.buff = internal global [55 x float] zeroinitializer, align 16
@randf.ip = internal global i32 0, align 4
@randf.jp = internal global i32 0, align 4
@randf.kp = internal global i32 0, align 4
@randf.xva = internal global double 0.000000e+00, align 8
@.str = private unnamed_addr constant [5 x i8] c"seed\00", align 1

; Function Attrs: nounwind ssp uwtable
define float @randf() #0 {
entry:
  %i = alloca i32, align 4
  %seed = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !28, metadata !29), !dbg !30
  call void @llvm.dbg.declare(metadata i32* %seed, metadata !31, metadata !29), !dbg !32
  %0 = load i32, i32* @randf.ip, align 4, !dbg !33
  %cmp = icmp eq i32 %0, 0, !dbg !35
  br i1 %cmp, label %land.lhs.true, label %if.end31, !dbg !36

land.lhs.true:                                    ; preds = %entry
  %1 = load i32, i32* @randf.jp, align 4, !dbg !37
  %cmp1 = icmp eq i32 %1, 0, !dbg !38
  br i1 %cmp1, label %if.then, label %if.end31, !dbg !39

if.then:                                          ; preds = %land.lhs.true
  %call = call i32 (i8*, ...) bitcast (i32 (...)* @get_i_variable to i32 (i8*, ...)*)(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i32 0, i32 0)), !dbg !40
  store i32 %call, i32* %seed, align 4, !dbg !42
  store i32 0, i32* @randf.ip, align 4, !dbg !43
  br label %for.cond, !dbg !45

for.cond:                                         ; preds = %for.inc, %if.then
  %2 = load i32, i32* @randf.ip, align 4, !dbg !46
  %cmp2 = icmp slt i32 %2, 55, !dbg !48
  br i1 %cmp2, label %for.body, label %for.end, !dbg !49

for.body:                                         ; preds = %for.cond
  %3 = load i32, i32* %seed, align 4, !dbg !50
  %mul = mul nsw i32 %3, 2349, !dbg !52
  %add = add nsw i32 %mul, 14867, !dbg !53
  %rem = srem i32 %add, 32767, !dbg !54
  store i32 %rem, i32* %seed, align 4, !dbg !55
  %4 = load i32, i32* %seed, align 4, !dbg !56
  %conv = sitofp i32 %4 to float, !dbg !57
  %conv3 = fpext float %conv to double, !dbg !57
  %div = fdiv double %conv3, 3.276700e+04, !dbg !58
  %conv4 = fptrunc double %div to float, !dbg !57
  %5 = load i32, i32* @randf.ip, align 4, !dbg !59
  %idxprom = sext i32 %5 to i64, !dbg !60
  %arrayidx = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom, !dbg !60
  store float %conv4, float* %arrayidx, align 4, !dbg !61
  %6 = load i32, i32* @randf.ip, align 4, !dbg !62
  %idxprom5 = sext i32 %6 to i64, !dbg !64
  %arrayidx6 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom5, !dbg !64
  %7 = load float, float* %arrayidx6, align 4, !dbg !64
  %conv7 = fpext float %7 to double, !dbg !64
  %cmp8 = fcmp ogt double %conv7, 1.000000e+00, !dbg !65
  br i1 %cmp8, label %if.then10, label %if.end, !dbg !66

if.then10:                                        ; preds = %for.body
  %8 = load i32, i32* @randf.ip, align 4, !dbg !67
  %idxprom11 = sext i32 %8 to i64, !dbg !68
  %arrayidx12 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom11, !dbg !68
  %9 = load float, float* %arrayidx12, align 4, !dbg !68
  %conv13 = fpext float %9 to double, !dbg !68
  %sub = fsub double %conv13, 1.000000e+00, !dbg !69
  %conv14 = fptrunc double %sub to float, !dbg !68
  %10 = load i32, i32* @randf.ip, align 4, !dbg !70
  %idxprom15 = sext i32 %10 to i64, !dbg !71
  %arrayidx16 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom15, !dbg !71
  store float %conv14, float* %arrayidx16, align 4, !dbg !72
  br label %if.end, !dbg !71

if.end:                                           ; preds = %if.then10, %for.body
  %11 = load i32, i32* @randf.ip, align 4, !dbg !73
  %idxprom17 = sext i32 %11 to i64, !dbg !75
  %arrayidx18 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom17, !dbg !75
  %12 = load float, float* %arrayidx18, align 4, !dbg !75
  %conv19 = fpext float %12 to double, !dbg !75
  %cmp20 = fcmp olt double %conv19, 0.000000e+00, !dbg !76
  br i1 %cmp20, label %if.then22, label %if.end30, !dbg !77

if.then22:                                        ; preds = %if.end
  %13 = load i32, i32* @randf.ip, align 4, !dbg !78
  %idxprom23 = sext i32 %13 to i64, !dbg !79
  %arrayidx24 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom23, !dbg !79
  %14 = load float, float* %arrayidx24, align 4, !dbg !79
  %conv25 = fpext float %14 to double, !dbg !79
  %add26 = fadd double %conv25, 1.000000e+00, !dbg !80
  %conv27 = fptrunc double %add26 to float, !dbg !79
  %15 = load i32, i32* @randf.ip, align 4, !dbg !81
  %idxprom28 = sext i32 %15 to i64, !dbg !82
  %arrayidx29 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom28, !dbg !82
  store float %conv27, float* %arrayidx29, align 4, !dbg !83
  br label %if.end30, !dbg !82

if.end30:                                         ; preds = %if.then22, %if.end
  br label %for.inc, !dbg !84

for.inc:                                          ; preds = %if.end30
  %16 = load i32, i32* @randf.ip, align 4, !dbg !85
  %inc = add nsw i32 %16, 1, !dbg !85
  store i32 %inc, i32* @randf.ip, align 4, !dbg !85
  br label %for.cond, !dbg !86

for.end:                                          ; preds = %for.cond
  store i32 23, i32* @randf.ip, align 4, !dbg !87
  store i32 54, i32* @randf.jp, align 4, !dbg !88
  store i32 0, i32* @randf.kp, align 4, !dbg !89
  br label %if.end31, !dbg !90

if.end31:                                         ; preds = %for.end, %land.lhs.true, %entry
  %17 = load i32, i32* @randf.kp, align 4, !dbg !91
  store i32 %17, i32* %i, align 4, !dbg !92
  %18 = load i32, i32* @randf.jp, align 4, !dbg !93
  %idxprom32 = sext i32 %18 to i64, !dbg !94
  %arrayidx33 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom32, !dbg !94
  %19 = load float, float* %arrayidx33, align 4, !dbg !94
  %20 = load i32, i32* @randf.ip, align 4, !dbg !95
  %idxprom34 = sext i32 %20 to i64, !dbg !96
  %arrayidx35 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom34, !dbg !96
  %21 = load float, float* %arrayidx35, align 4, !dbg !96
  %add36 = fadd float %19, %21, !dbg !97
  %conv37 = fpext float %add36 to double, !dbg !94
  store double %conv37, double* @randf.xva, align 8, !dbg !98
  %22 = load double, double* @randf.xva, align 8, !dbg !99
  %cmp38 = fcmp ogt double %22, 1.000000e+00, !dbg !101
  br i1 %cmp38, label %if.then40, label %if.end42, !dbg !102

if.then40:                                        ; preds = %if.end31
  %23 = load double, double* @randf.xva, align 8, !dbg !103
  %sub41 = fsub double %23, 1.000000e+00, !dbg !104
  store double %sub41, double* @randf.xva, align 8, !dbg !105
  br label %if.end42, !dbg !106

if.end42:                                         ; preds = %if.then40, %if.end31
  %24 = load double, double* @randf.xva, align 8, !dbg !107
  %conv43 = fptrunc double %24 to float, !dbg !107
  %25 = load i32, i32* @randf.kp, align 4, !dbg !108
  %idxprom44 = sext i32 %25 to i64, !dbg !109
  %arrayidx45 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom44, !dbg !109
  store float %conv43, float* %arrayidx45, align 4, !dbg !110
  %26 = load i32, i32* @randf.kp, align 4, !dbg !111
  %add46 = add nsw i32 %26, 1, !dbg !112
  %rem47 = srem i32 %add46, 55, !dbg !113
  store i32 %rem47, i32* @randf.kp, align 4, !dbg !114
  %27 = load i32, i32* @randf.ip, align 4, !dbg !115
  %add48 = add nsw i32 %27, 1, !dbg !116
  %rem49 = srem i32 %add48, 55, !dbg !117
  store i32 %rem49, i32* @randf.ip, align 4, !dbg !118
  %28 = load i32, i32* @randf.jp, align 4, !dbg !119
  %add50 = add nsw i32 %28, 1, !dbg !120
  %rem51 = srem i32 %add50, 55, !dbg !121
  store i32 %rem51, i32* @randf.jp, align 4, !dbg !122
  %29 = load i32, i32* %i, align 4, !dbg !123
  %idxprom52 = sext i32 %29 to i64, !dbg !124
  %arrayidx53 = getelementptr inbounds [55 x float], [55 x float]* @randf.buff, i32 0, i64 %idxprom52, !dbg !124
  %30 = load float, float* %arrayidx53, align 4, !dbg !124
  ret float %30, !dbg !125
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @get_i_variable(...) #2

; Function Attrs: nounwind ssp uwtable
define float @randg() #0 {
entry:
  %x1 = alloca float, align 4
  %x2 = alloca float, align 4
  %norm = alloca float, align 4
  call void @llvm.dbg.declare(metadata float* %x1, metadata !126, metadata !29), !dbg !127
  call void @llvm.dbg.declare(metadata float* %x2, metadata !128, metadata !29), !dbg !129
  call void @llvm.dbg.declare(metadata float* %norm, metadata !130, metadata !29), !dbg !131
  store float 2.000000e+00, float* %norm, align 4, !dbg !132
  br label %while.cond, !dbg !133

while.cond:                                       ; preds = %while.body, %entry
  %0 = load float, float* %norm, align 4, !dbg !134
  %conv = fpext float %0 to double, !dbg !134
  %cmp = fcmp ogt double %conv, 1.000000e+00, !dbg !135
  br i1 %cmp, label %while.body, label %while.end, !dbg !133

while.body:                                       ; preds = %while.cond
  %call = call float @randf(), !dbg !136
  %conv2 = fpext float %call to double, !dbg !136
  %mul = fmul double 2.000000e+00, %conv2, !dbg !138
  %sub = fsub double %mul, 1.000000e+00, !dbg !139
  %conv3 = fptrunc double %sub to float, !dbg !140
  store float %conv3, float* %x1, align 4, !dbg !141
  %call4 = call float @randf(), !dbg !142
  %conv5 = fpext float %call4 to double, !dbg !142
  %mul6 = fmul double 2.000000e+00, %conv5, !dbg !143
  %sub7 = fsub double %mul6, 1.000000e+00, !dbg !144
  %conv8 = fptrunc double %sub7 to float, !dbg !145
  store float %conv8, float* %x2, align 4, !dbg !146
  %1 = load float, float* %x1, align 4, !dbg !147
  %2 = load float, float* %x1, align 4, !dbg !148
  %mul9 = fmul float %1, %2, !dbg !149
  %3 = load float, float* %x2, align 4, !dbg !150
  %4 = load float, float* %x2, align 4, !dbg !151
  %mul10 = fmul float %3, %4, !dbg !152
  %add = fadd float %mul9, %mul10, !dbg !153
  store float %add, float* %norm, align 4, !dbg !154
  br label %while.cond, !dbg !133

while.end:                                        ; preds = %while.cond
  %5 = load float, float* %norm, align 4, !dbg !155
  %conv11 = fpext float %5 to double, !dbg !155
  %cmp12 = fcmp olt double %conv11, 1.000000e-09, !dbg !157
  br i1 %cmp12, label %if.then, label %if.end, !dbg !158

if.then:                                          ; preds = %while.end
  store float 0x3E112E0BE0000000, float* %norm, align 4, !dbg !159
  br label %if.end, !dbg !160

if.end:                                           ; preds = %if.then, %while.end
  %6 = load float, float* %x1, align 4, !dbg !161
  %conv14 = fpext float %6 to double, !dbg !161
  %7 = load float, float* %norm, align 4, !dbg !162
  %conv15 = fpext float %7 to double, !dbg !162
  %call16 = call double @log(double %conv15) #1, !dbg !163
  %mul17 = fmul double -2.000000e+00, %call16, !dbg !164
  %8 = load float, float* %norm, align 4, !dbg !165
  %conv18 = fpext float %8 to double, !dbg !165
  %div = fdiv double %mul17, %conv18, !dbg !166
  %call19 = call double @sqrt(double %div) #1, !dbg !167
  %mul20 = fmul double %conv14, %call19, !dbg !168
  %conv21 = fptrunc double %mul20 to float, !dbg !161
  ret float %conv21, !dbg !169
}

; Function Attrs: nounwind readnone
declare double @sqrt(double) #3

; Function Attrs: nounwind readnone
declare double @log(double) #3

; Function Attrs: nounwind ssp uwtable
define void @rand3(float* %x, float* %y, float* %z) #0 {
entry:
  %x.addr = alloca float*, align 8
  %y.addr = alloca float*, align 8
  %z.addr = alloca float*, align 8
  %alpha = alloca float, align 4
  %norm = alloca float, align 4
  %x1 = alloca float, align 4
  %x2 = alloca float, align 4
  store float* %x, float** %x.addr, align 8
  call void @llvm.dbg.declare(metadata float** %x.addr, metadata !170, metadata !29), !dbg !171
  store float* %y, float** %y.addr, align 8
  call void @llvm.dbg.declare(metadata float** %y.addr, metadata !172, metadata !29), !dbg !173
  store float* %z, float** %z.addr, align 8
  call void @llvm.dbg.declare(metadata float** %z.addr, metadata !174, metadata !29), !dbg !175
  call void @llvm.dbg.declare(metadata float* %alpha, metadata !176, metadata !29), !dbg !177
  call void @llvm.dbg.declare(metadata float* %norm, metadata !178, metadata !29), !dbg !179
  call void @llvm.dbg.declare(metadata float* %x1, metadata !180, metadata !29), !dbg !181
  call void @llvm.dbg.declare(metadata float* %x2, metadata !182, metadata !29), !dbg !183
  store float 2.000000e+00, float* %norm, align 4, !dbg !184
  br label %while.cond, !dbg !185

while.cond:                                       ; preds = %while.body, %entry
  %0 = load float, float* %norm, align 4, !dbg !186
  %conv = fpext float %0 to double, !dbg !186
  %cmp = fcmp ogt double %conv, 1.000000e+00, !dbg !187
  br i1 %cmp, label %while.body, label %while.end, !dbg !185

while.body:                                       ; preds = %while.cond
  %call = call float @randf(), !dbg !188
  %conv2 = fpext float %call to double, !dbg !188
  %mul = fmul double 2.000000e+00, %conv2, !dbg !190
  %sub = fsub double %mul, 1.000000e+00, !dbg !191
  %conv3 = fptrunc double %sub to float, !dbg !192
  store float %conv3, float* %x1, align 4, !dbg !193
  %call4 = call float @randf(), !dbg !194
  %conv5 = fpext float %call4 to double, !dbg !194
  %mul6 = fmul double 2.000000e+00, %conv5, !dbg !195
  %sub7 = fsub double %mul6, 1.000000e+00, !dbg !196
  %conv8 = fptrunc double %sub7 to float, !dbg !197
  store float %conv8, float* %x2, align 4, !dbg !198
  %1 = load float, float* %x1, align 4, !dbg !199
  %2 = load float, float* %x1, align 4, !dbg !200
  %mul9 = fmul float %1, %2, !dbg !201
  %3 = load float, float* %x2, align 4, !dbg !202
  %4 = load float, float* %x2, align 4, !dbg !203
  %mul10 = fmul float %3, %4, !dbg !204
  %add = fadd float %mul9, %mul10, !dbg !205
  store float %add, float* %norm, align 4, !dbg !206
  br label %while.cond, !dbg !185

while.end:                                        ; preds = %while.cond
  %5 = load float, float* %x1, align 4, !dbg !207
  %6 = load float*, float** %x.addr, align 8, !dbg !208
  store float %5, float* %6, align 4, !dbg !209
  %7 = load float, float* %x2, align 4, !dbg !210
  %8 = load float*, float** %y.addr, align 8, !dbg !211
  store float %7, float* %8, align 4, !dbg !212
  %9 = load float, float* %norm, align 4, !dbg !213
  %conv11 = fpext float %9 to double, !dbg !213
  %sub12 = fsub double 1.000000e+00, %conv11, !dbg !214
  %call13 = call double @sqrt(double %sub12) #1, !dbg !215
  %conv14 = fptrunc double %call13 to float, !dbg !215
  store float %conv14, float* %norm, align 4, !dbg !216
  %10 = load float, float* %norm, align 4, !dbg !217
  %11 = load float*, float** %z.addr, align 8, !dbg !218
  store float %10, float* %11, align 4, !dbg !219
  %call15 = call float @randf(), !dbg !220
  %conv16 = fpext float %call15 to double, !dbg !220
  %cmp17 = fcmp olt double %conv16, 5.000000e-01, !dbg !222
  br i1 %cmp17, label %if.then, label %if.end, !dbg !223

if.then:                                          ; preds = %while.end
  %12 = load float, float* %norm, align 4, !dbg !224
  %sub19 = fsub float -0.000000e+00, %12, !dbg !225
  %13 = load float*, float** %z.addr, align 8, !dbg !226
  store float %sub19, float* %13, align 4, !dbg !227
  br label %if.end, !dbg !228

if.end:                                           ; preds = %if.then, %while.end
  ret void, !dbg !229
}

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!24, !25, !26}
!llvm.ident = !{!27}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !5, globals: !13, imports: !2)
!1 = !MDFile(filename: "ammp-master/random.c", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!5 = !{!6, !8, !9}
!6 = !MDSubprogram(name: "randf", scope: !1, file: !1, line: 20, type: !7, isLocal: false, isDefinition: true, scopeLine: 21, isOptimized: false, function: float ()* @randf, variables: !2)
!7 = !MDSubroutineType(types: !3)
!8 = !MDSubprogram(name: "randg", scope: !1, file: !1, line: 57, type: !7, isLocal: false, isDefinition: true, scopeLine: 58, isOptimized: false, function: float ()* @randg, variables: !2)
!9 = !MDSubprogram(name: "rand3", scope: !1, file: !1, line: 79, type: !10, isLocal: false, isDefinition: true, scopeLine: 81, isOptimized: false, function: void (float*, float*, float*)* @rand3, variables: !2)
!10 = !MDSubroutineType(types: !11)
!11 = !{null, !12, !12, !12}
!12 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64, align: 64)
!13 = !{!14, !18, !20, !21, !22}
!14 = !MDGlobalVariable(name: "buff", scope: !6, file: !1, line: 22, type: !15, isLocal: true, isDefinition: true, variable: [55 x float]* @randf.buff)
!15 = !MDCompositeType(tag: DW_TAG_array_type, baseType: !4, size: 1760, align: 32, elements: !16)
!16 = !{!17}
!17 = !MDSubrange(count: 55)
!18 = !MDGlobalVariable(name: "ip", scope: !6, file: !1, line: 23, type: !19, isLocal: true, isDefinition: true, variable: i32* @randf.ip)
!19 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!20 = !MDGlobalVariable(name: "jp", scope: !6, file: !1, line: 23, type: !19, isLocal: true, isDefinition: true, variable: i32* @randf.jp)
!21 = !MDGlobalVariable(name: "kp", scope: !6, file: !1, line: 23, type: !19, isLocal: true, isDefinition: true, variable: i32* @randf.kp)
!22 = !MDGlobalVariable(name: "xva", scope: !6, file: !1, line: 25, type: !23, isLocal: true, isDefinition: true, variable: double* @randf.xva)
!23 = !MDBasicType(name: "double", size: 64, align: 64, encoding: DW_ATE_float)
!24 = !{i32 2, !"Dwarf Version", i32 2}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"PIC Level", i32 2}
!27 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!28 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !6, file: !1, line: 24, type: !19)
!29 = !MDExpression()
!30 = !MDLocation(line: 24, column: 9, scope: !6)
!31 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "seed", scope: !6, file: !1, line: 24, type: !19)
!32 = !MDLocation(line: 24, column: 11, scope: !6)
!33 = !MDLocation(line: 26, column: 9, scope: !34)
!34 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 26, column: 9)
!35 = !MDLocation(line: 26, column: 12, scope: !34)
!36 = !MDLocation(line: 26, column: 17, scope: !34)
!37 = !MDLocation(line: 26, column: 20, scope: !34)
!38 = !MDLocation(line: 26, column: 23, scope: !34)
!39 = !MDLocation(line: 26, column: 9, scope: !6)
!40 = !MDLocation(line: 29, column: 16, scope: !41)
!41 = distinct !MDLexicalBlock(scope: !34, file: !1, line: 27, column: 5)
!42 = !MDLocation(line: 29, column: 14, scope: !41)
!43 = !MDLocation(line: 31, column: 16, scope: !44)
!44 = distinct !MDLexicalBlock(scope: !41, file: !1, line: 31, column: 9)
!45 = !MDLocation(line: 31, column: 14, scope: !44)
!46 = !MDLocation(line: 31, column: 20, scope: !47)
!47 = distinct !MDLexicalBlock(scope: !44, file: !1, line: 31, column: 9)
!48 = !MDLocation(line: 31, column: 23, scope: !47)
!49 = !MDLocation(line: 31, column: 9, scope: !44)
!50 = !MDLocation(line: 32, column: 19, scope: !51)
!51 = distinct !MDLexicalBlock(scope: !47, file: !1, line: 32, column: 9)
!52 = !MDLocation(line: 32, column: 23, scope: !51)
!53 = !MDLocation(line: 32, column: 28, scope: !51)
!54 = !MDLocation(line: 32, column: 35, scope: !51)
!55 = !MDLocation(line: 32, column: 16, scope: !51)
!56 = !MDLocation(line: 33, column: 31, scope: !51)
!57 = !MDLocation(line: 33, column: 24, scope: !51)
!58 = !MDLocation(line: 33, column: 35, scope: !51)
!59 = !MDLocation(line: 33, column: 18, scope: !51)
!60 = !MDLocation(line: 33, column: 13, scope: !51)
!61 = !MDLocation(line: 33, column: 22, scope: !51)
!62 = !MDLocation(line: 34, column: 22, scope: !63)
!63 = distinct !MDLexicalBlock(scope: !51, file: !1, line: 34, column: 17)
!64 = !MDLocation(line: 34, column: 17, scope: !63)
!65 = !MDLocation(line: 34, column: 26, scope: !63)
!66 = !MDLocation(line: 34, column: 17, scope: !51)
!67 = !MDLocation(line: 34, column: 48, scope: !63)
!68 = !MDLocation(line: 34, column: 43, scope: !63)
!69 = !MDLocation(line: 34, column: 51, scope: !63)
!70 = !MDLocation(line: 34, column: 37, scope: !63)
!71 = !MDLocation(line: 34, column: 32, scope: !63)
!72 = !MDLocation(line: 34, column: 41, scope: !63)
!73 = !MDLocation(line: 35, column: 22, scope: !74)
!74 = distinct !MDLexicalBlock(scope: !51, file: !1, line: 35, column: 17)
!75 = !MDLocation(line: 35, column: 17, scope: !74)
!76 = !MDLocation(line: 35, column: 26, scope: !74)
!77 = !MDLocation(line: 35, column: 17, scope: !51)
!78 = !MDLocation(line: 35, column: 48, scope: !74)
!79 = !MDLocation(line: 35, column: 43, scope: !74)
!80 = !MDLocation(line: 35, column: 51, scope: !74)
!81 = !MDLocation(line: 35, column: 37, scope: !74)
!82 = !MDLocation(line: 35, column: 32, scope: !74)
!83 = !MDLocation(line: 35, column: 41, scope: !74)
!84 = !MDLocation(line: 36, column: 9, scope: !51)
!85 = !MDLocation(line: 31, column: 31, scope: !47)
!86 = !MDLocation(line: 31, column: 9, scope: !47)
!87 = !MDLocation(line: 37, column: 12, scope: !41)
!88 = !MDLocation(line: 37, column: 20, scope: !41)
!89 = !MDLocation(line: 37, column: 28, scope: !41)
!90 = !MDLocation(line: 38, column: 5, scope: !41)
!91 = !MDLocation(line: 39, column: 9, scope: !6)
!92 = !MDLocation(line: 39, column: 7, scope: !6)
!93 = !MDLocation(line: 40, column: 16, scope: !6)
!94 = !MDLocation(line: 40, column: 11, scope: !6)
!95 = !MDLocation(line: 40, column: 25, scope: !6)
!96 = !MDLocation(line: 40, column: 20, scope: !6)
!97 = !MDLocation(line: 40, column: 19, scope: !6)
!98 = !MDLocation(line: 40, column: 9, scope: !6)
!99 = !MDLocation(line: 43, column: 9, scope: !100)
!100 = distinct !MDLexicalBlock(scope: !6, file: !1, line: 43, column: 9)
!101 = !MDLocation(line: 43, column: 13, scope: !100)
!102 = !MDLocation(line: 43, column: 9, scope: !6)
!103 = !MDLocation(line: 43, column: 25, scope: !100)
!104 = !MDLocation(line: 43, column: 29, scope: !100)
!105 = !MDLocation(line: 43, column: 23, scope: !100)
!106 = !MDLocation(line: 43, column: 19, scope: !100)
!107 = !MDLocation(line: 44, column: 16, scope: !6)
!108 = !MDLocation(line: 44, column: 10, scope: !6)
!109 = !MDLocation(line: 44, column: 5, scope: !6)
!110 = !MDLocation(line: 44, column: 14, scope: !6)
!111 = !MDLocation(line: 45, column: 11, scope: !6)
!112 = !MDLocation(line: 45, column: 13, scope: !6)
!113 = !MDLocation(line: 45, column: 16, scope: !6)
!114 = !MDLocation(line: 45, column: 8, scope: !6)
!115 = !MDLocation(line: 46, column: 11, scope: !6)
!116 = !MDLocation(line: 46, column: 13, scope: !6)
!117 = !MDLocation(line: 46, column: 16, scope: !6)
!118 = !MDLocation(line: 46, column: 8, scope: !6)
!119 = !MDLocation(line: 47, column: 11, scope: !6)
!120 = !MDLocation(line: 47, column: 13, scope: !6)
!121 = !MDLocation(line: 47, column: 16, scope: !6)
!122 = !MDLocation(line: 47, column: 8, scope: !6)
!123 = !MDLocation(line: 48, column: 17, scope: !6)
!124 = !MDLocation(line: 48, column: 12, scope: !6)
!125 = !MDLocation(line: 48, column: 5, scope: !6)
!126 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !8, file: !1, line: 60, type: !4)
!127 = !MDLocation(line: 60, column: 11, scope: !8)
!128 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x2", scope: !8, file: !1, line: 60, type: !4)
!129 = !MDLocation(line: 60, column: 14, scope: !8)
!130 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "norm", scope: !8, file: !1, line: 60, type: !4)
!131 = !MDLocation(line: 60, column: 17, scope: !8)
!132 = !MDLocation(line: 62, column: 10, scope: !8)
!133 = !MDLocation(line: 63, column: 5, scope: !8)
!134 = !MDLocation(line: 63, column: 12, scope: !8)
!135 = !MDLocation(line: 63, column: 17, scope: !8)
!136 = !MDLocation(line: 65, column: 17, scope: !137)
!137 = distinct !MDLexicalBlock(scope: !8, file: !1, line: 64, column: 5)
!138 = !MDLocation(line: 65, column: 16, scope: !137)
!139 = !MDLocation(line: 65, column: 24, scope: !137)
!140 = !MDLocation(line: 65, column: 14, scope: !137)
!141 = !MDLocation(line: 65, column: 12, scope: !137)
!142 = !MDLocation(line: 65, column: 36, scope: !137)
!143 = !MDLocation(line: 65, column: 35, scope: !137)
!144 = !MDLocation(line: 65, column: 43, scope: !137)
!145 = !MDLocation(line: 65, column: 33, scope: !137)
!146 = !MDLocation(line: 65, column: 31, scope: !137)
!147 = !MDLocation(line: 66, column: 16, scope: !137)
!148 = !MDLocation(line: 66, column: 19, scope: !137)
!149 = !MDLocation(line: 66, column: 18, scope: !137)
!150 = !MDLocation(line: 66, column: 24, scope: !137)
!151 = !MDLocation(line: 66, column: 27, scope: !137)
!152 = !MDLocation(line: 66, column: 26, scope: !137)
!153 = !MDLocation(line: 66, column: 22, scope: !137)
!154 = !MDLocation(line: 66, column: 14, scope: !137)
!155 = !MDLocation(line: 69, column: 9, scope: !156)
!156 = distinct !MDLexicalBlock(scope: !8, file: !1, line: 69, column: 9)
!157 = !MDLocation(line: 69, column: 14, scope: !156)
!158 = !MDLocation(line: 69, column: 9, scope: !8)
!159 = !MDLocation(line: 69, column: 28, scope: !156)
!160 = !MDLocation(line: 69, column: 23, scope: !156)
!161 = !MDLocation(line: 70, column: 12, scope: !8)
!162 = !MDLocation(line: 70, column: 29, scope: !8)
!163 = !MDLocation(line: 70, column: 25, scope: !8)
!164 = !MDLocation(line: 70, column: 24, scope: !8)
!165 = !MDLocation(line: 70, column: 35, scope: !8)
!166 = !MDLocation(line: 70, column: 34, scope: !8)
!167 = !MDLocation(line: 70, column: 15, scope: !8)
!168 = !MDLocation(line: 70, column: 14, scope: !8)
!169 = !MDLocation(line: 70, column: 5, scope: !8)
!170 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "x", arg: 1, scope: !9, file: !1, line: 80, type: !12)
!171 = !MDLocation(line: 80, column: 8, scope: !9)
!172 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "y", arg: 2, scope: !9, file: !1, line: 80, type: !12)
!173 = !MDLocation(line: 80, column: 11, scope: !9)
!174 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "z", arg: 3, scope: !9, file: !1, line: 80, type: !12)
!175 = !MDLocation(line: 80, column: 14, scope: !9)
!176 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "alpha", scope: !9, file: !1, line: 83, type: !4)
!177 = !MDLocation(line: 83, column: 11, scope: !9)
!178 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "norm", scope: !9, file: !1, line: 83, type: !4)
!179 = !MDLocation(line: 83, column: 17, scope: !9)
!180 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x1", scope: !9, file: !1, line: 83, type: !4)
!181 = !MDLocation(line: 83, column: 22, scope: !9)
!182 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "x2", scope: !9, file: !1, line: 83, type: !4)
!183 = !MDLocation(line: 83, column: 25, scope: !9)
!184 = !MDLocation(line: 84, column: 10, scope: !9)
!185 = !MDLocation(line: 85, column: 5, scope: !9)
!186 = !MDLocation(line: 85, column: 12, scope: !9)
!187 = !MDLocation(line: 85, column: 17, scope: !9)
!188 = !MDLocation(line: 87, column: 17, scope: !189)
!189 = distinct !MDLexicalBlock(scope: !9, file: !1, line: 86, column: 5)
!190 = !MDLocation(line: 87, column: 16, scope: !189)
!191 = !MDLocation(line: 87, column: 24, scope: !189)
!192 = !MDLocation(line: 87, column: 14, scope: !189)
!193 = !MDLocation(line: 87, column: 12, scope: !189)
!194 = !MDLocation(line: 87, column: 36, scope: !189)
!195 = !MDLocation(line: 87, column: 35, scope: !189)
!196 = !MDLocation(line: 87, column: 43, scope: !189)
!197 = !MDLocation(line: 87, column: 33, scope: !189)
!198 = !MDLocation(line: 87, column: 31, scope: !189)
!199 = !MDLocation(line: 88, column: 16, scope: !189)
!200 = !MDLocation(line: 88, column: 19, scope: !189)
!201 = !MDLocation(line: 88, column: 18, scope: !189)
!202 = !MDLocation(line: 88, column: 24, scope: !189)
!203 = !MDLocation(line: 88, column: 27, scope: !189)
!204 = !MDLocation(line: 88, column: 26, scope: !189)
!205 = !MDLocation(line: 88, column: 22, scope: !189)
!206 = !MDLocation(line: 88, column: 14, scope: !189)
!207 = !MDLocation(line: 95, column: 10, scope: !9)
!208 = !MDLocation(line: 95, column: 6, scope: !9)
!209 = !MDLocation(line: 95, column: 8, scope: !9)
!210 = !MDLocation(line: 95, column: 19, scope: !9)
!211 = !MDLocation(line: 95, column: 15, scope: !9)
!212 = !MDLocation(line: 95, column: 17, scope: !9)
!213 = !MDLocation(line: 96, column: 20, scope: !9)
!214 = !MDLocation(line: 96, column: 19, scope: !9)
!215 = !MDLocation(line: 96, column: 12, scope: !9)
!216 = !MDLocation(line: 96, column: 10, scope: !9)
!217 = !MDLocation(line: 97, column: 10, scope: !9)
!218 = !MDLocation(line: 97, column: 6, scope: !9)
!219 = !MDLocation(line: 97, column: 8, scope: !9)
!220 = !MDLocation(line: 98, column: 9, scope: !221)
!221 = distinct !MDLexicalBlock(scope: !9, file: !1, line: 98, column: 9)
!222 = !MDLocation(line: 98, column: 17, scope: !221)
!223 = !MDLocation(line: 98, column: 9, scope: !9)
!224 = !MDLocation(line: 98, column: 30, scope: !221)
!225 = !MDLocation(line: 98, column: 29, scope: !221)
!226 = !MDLocation(line: 98, column: 25, scope: !221)
!227 = !MDLocation(line: 98, column: 27, scope: !221)
!228 = !MDLocation(line: 98, column: 24, scope: !221)
!229 = !MDLocation(line: 99, column: 1, scope: !9)
