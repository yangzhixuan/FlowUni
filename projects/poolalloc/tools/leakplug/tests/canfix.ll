; ModuleID = 'canfix.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define void @f(i8* %b, i32 %c) #0 {
entry:
  %b.addr = alloca i8*, align 8
  %c.addr = alloca i32, align 4
  %a = alloca i8*, align 8
  store i8* %b, i8** %b.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %b.addr, metadata !14, metadata !15), !dbg !16
  store i32 %c, i32* %c.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %c.addr, metadata !17, metadata !15), !dbg !18
  call void @llvm.dbg.declare(metadata i8** %a, metadata !19, metadata !15), !dbg !20
  %call = call i8* @malloc(i64 1), !dbg !21
  store i8* %call, i8** %a, align 8, !dbg !20
  %call1 = call i8* @malloc(i64 2), !dbg !22
  store i8* %call1, i8** %a, align 8, !dbg !23
  %0 = load i8*, i8** %b.addr, align 8, !dbg !24
  %1 = load i8*, i8** %a, align 8, !dbg !26
  %cmp = icmp eq i8* %0, %1, !dbg !27
  br i1 %cmp, label %if.then, label %if.end, !dbg !28

if.then:                                          ; preds = %entry
  br label %return, !dbg !29

if.end:                                           ; preds = %entry
  %2 = load i8*, i8** %a, align 8, !dbg !31
  store i8* %2, i8** %b.addr, align 8, !dbg !32
  %3 = load i8*, i8** %b.addr, align 8, !dbg !33
  call void @free(i8* %3), !dbg !34
  br label %return, !dbg !35

return:                                           ; preds = %if.end, %if.then
  ret void, !dbg !36
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64) #2

declare void @free(i8*) #2

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "canfix.c", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDSubprogram(name: "f", scope: !1, file: !1, line: 3, type: !5, isLocal: false, isDefinition: true, scopeLine: 3, flags: DIFlagPrototyped, isOptimized: false, function: void (i8*, i32)* @f, variables: !2)
!5 = !MDSubroutineType(types: !6)
!6 = !{null, !7, !9}
!7 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64, align: 64)
!8 = !MDBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!9 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!10 = !{i32 2, !"Dwarf Version", i32 2}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"PIC Level", i32 2}
!13 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!14 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "b", arg: 1, scope: !4, file: !1, line: 3, type: !7)
!15 = !MDExpression()
!16 = !MDLocation(line: 3, column: 15, scope: !4)
!17 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "c", arg: 2, scope: !4, file: !1, line: 3, type: !9)
!18 = !MDLocation(line: 3, column: 22, scope: !4)
!19 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a", scope: !4, file: !1, line: 4, type: !7)
!20 = !MDLocation(line: 4, column: 11, scope: !4)
!21 = !MDLocation(line: 4, column: 15, scope: !4)
!22 = !MDLocation(line: 5, column: 9, scope: !4)
!23 = !MDLocation(line: 5, column: 7, scope: !4)
!24 = !MDLocation(line: 6, column: 8, scope: !25)
!25 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 6, column: 8)
!26 = !MDLocation(line: 6, column: 13, scope: !25)
!27 = !MDLocation(line: 6, column: 10, scope: !25)
!28 = !MDLocation(line: 6, column: 8, scope: !4)
!29 = !MDLocation(line: 7, column: 9, scope: !30)
!30 = distinct !MDLexicalBlock(scope: !25, file: !1, line: 6, column: 16)
!31 = !MDLocation(line: 9, column: 9, scope: !4)
!32 = !MDLocation(line: 9, column: 7, scope: !4)
!33 = !MDLocation(line: 10, column: 10, scope: !4)
!34 = !MDLocation(line: 10, column: 5, scope: !4)
!35 = !MDLocation(line: 11, column: 5, scope: !4)
!36 = !MDLocation(line: 12, column: 1, scope: !4)
