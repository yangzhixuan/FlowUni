; ModuleID = 'a.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define i32 @f(i32* %unrel, i32 %x) #0 {
entry:
  call void @llvm.dbg.value(metadata i32* %unrel, i64 0, metadata !13, metadata !14), !dbg !15
  call void @llvm.dbg.value(metadata i32 %x, i64 0, metadata !16, metadata !14), !dbg !17
  %call = call i8* @malloc(i64 1), !dbg !18
  call void @llvm.dbg.value(metadata i8* %call, i64 0, metadata !19, metadata !14), !dbg !22
  %cmp = icmp slt i32 %x, 5, !dbg !23
  br i1 %cmp, label %if.then, label %if.end, !dbg !25

if.then:                                          ; preds = %entry
  store i8 0, i8* %call, align 1, !dbg !26
  call void @free(i8* %call), !dbg !28
  br label %return, !dbg !29

if.end:                                           ; preds = %entry
  %call1 = call i8* @malloc(i64 1), !dbg !30
  call void @llvm.dbg.value(metadata i8* %call1, i64 0, metadata !31, metadata !14), !dbg !32
  %0 = bitcast i32* %unrel to i8*, !dbg !33
  call void @free(i8* %0), !dbg !34
  br label %return, !dbg !35

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ 2, %if.then ], [ 0, %if.end ]
  ret i32 %retval.0, !dbg !36
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64) #2

declare void @free(i8*) #2

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "a.c", directory: "/Users/yangzx/llvm-dsa/lib/Transforms/World/tests")
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
!18 = !MDLocation(line: 4, column: 15, scope: !4)
!19 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "c", scope: !4, file: !1, line: 4, type: !20)
!20 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64, align: 64)
!21 = !MDBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!22 = !MDLocation(line: 4, column: 11, scope: !4)
!23 = !MDLocation(line: 5, column: 10, scope: !24)
!24 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 5, column: 8)
!25 = !MDLocation(line: 5, column: 8, scope: !4)
!26 = !MDLocation(line: 6, column: 12, scope: !27)
!27 = distinct !MDLexicalBlock(scope: !24, file: !1, line: 5, column: 15)
!28 = !MDLocation(line: 7, column: 9, scope: !27)
!29 = !MDLocation(line: 8, column: 9, scope: !27)
!30 = !MDLocation(line: 10, column: 15, scope: !4)
!31 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "d", scope: !4, file: !1, line: 10, type: !20)
!32 = !MDLocation(line: 10, column: 11, scope: !4)
!33 = !MDLocation(line: 11, column: 10, scope: !4)
!34 = !MDLocation(line: 11, column: 5, scope: !4)
!35 = !MDLocation(line: 12, column: 5, scope: !4)
!36 = !MDLocation(line: 13, column: 1, scope: !4)
