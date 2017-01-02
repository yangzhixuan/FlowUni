; ModuleID = 'a.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define i32 @f(i32* %unrel, i32 %x) #0 {
entry:
  %retval = alloca i32, align 4
  %unrel.addr = alloca i32*, align 8
  %x.addr = alloca i32, align 4
  %c = alloca i8*, align 8
  %d = alloca i8*, align 8
  store i32* %unrel, i32** %unrel.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %unrel.addr, metadata !13, metadata !14), !dbg !15
  store i32 %x, i32* %x.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %x.addr, metadata !16, metadata !14), !dbg !17
  call void @llvm.dbg.declare(metadata i8** %c, metadata !18, metadata !14), !dbg !21
  %call = call i8* @malloc(i64 1), !dbg !22
  store i8* %call, i8** %c, align 8, !dbg !21
  %0 = load i32, i32* %x.addr, align 4, !dbg !23
  %cmp = icmp slt i32 %0, 5, !dbg !25
  br i1 %cmp, label %if.then, label %if.end, !dbg !26

if.then:                                          ; preds = %entry
  %1 = load i8*, i8** %c, align 8, !dbg !27
  store i8 0, i8* %1, align 1, !dbg !29
  %2 = load i8*, i8** %c, align 8, !dbg !30
  call void @free(i8* %2), !dbg !31
  store i32 2, i32* %retval, !dbg !32
  br label %return, !dbg !32

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata i8** %d, metadata !33, metadata !14), !dbg !34
  %call1 = call i8* @malloc(i64 1), !dbg !35
  store i8* %call1, i8** %d, align 8, !dbg !34
  %3 = load i32*, i32** %unrel.addr, align 8, !dbg !36
  %4 = bitcast i32* %3 to i8*, !dbg !36
  call void @free(i8* %4), !dbg !37
  store i32 0, i32* %retval, !dbg !38
  br label %return, !dbg !38

return:                                           ; preds = %if.end, %if.then
  %5 = load i32, i32* %retval, !dbg !39
  ret i32 %5, !dbg !39
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64) #2

declare void @free(i8*) #2

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "a.c", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDSubprogram(name: "f", scope: !1, file: !1, line: 2, type: !5, isLocal: false, isDefinition: true, scopeLine: 3, flags: DIFlagPrototyped, isOptimized: false, function: i32 (i32*, i32)* @f, variables: !2)
!5 = !MDSubroutineType(types: !6)
!6 = !{!7, !8, !7}
!7 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!8 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64, align: 64)
!9 = !{i32 2, !"Dwarf Version", i32 2}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"PIC Level", i32 2}
!12 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!13 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "unrel", arg: 1, scope: !4, file: !1, line: 2, type: !8)
!14 = !MDExpression()
!15 = !MDLocation(line: 2, column: 12, scope: !4)
!16 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "x", arg: 2, scope: !4, file: !1, line: 2, type: !7)
!17 = !MDLocation(line: 2, column: 23, scope: !4)
!18 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "c", scope: !4, file: !1, line: 4, type: !19)
!19 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64, align: 64)
!20 = !MDBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!21 = !MDLocation(line: 4, column: 11, scope: !4)
!22 = !MDLocation(line: 4, column: 15, scope: !4)
!23 = !MDLocation(line: 5, column: 8, scope: !24)
!24 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 5, column: 8)
!25 = !MDLocation(line: 5, column: 10, scope: !24)
!26 = !MDLocation(line: 5, column: 8, scope: !4)
!27 = !MDLocation(line: 6, column: 10, scope: !28)
!28 = distinct !MDLexicalBlock(scope: !24, file: !1, line: 5, column: 15)
!29 = !MDLocation(line: 6, column: 12, scope: !28)
!30 = !MDLocation(line: 7, column: 14, scope: !28)
!31 = !MDLocation(line: 7, column: 9, scope: !28)
!32 = !MDLocation(line: 8, column: 9, scope: !28)
!33 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "d", scope: !4, file: !1, line: 10, type: !19)
!34 = !MDLocation(line: 10, column: 11, scope: !4)
!35 = !MDLocation(line: 10, column: 15, scope: !4)
!36 = !MDLocation(line: 11, column: 10, scope: !4)
!37 = !MDLocation(line: 11, column: 5, scope: !4)
!38 = !MDLocation(line: 12, column: 5, scope: !4)
!39 = !MDLocation(line: 13, column: 1, scope: !4)
