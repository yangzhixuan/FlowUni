; ModuleID = 'scope.c'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define void @foo() #0 {
entry:
  %X = alloca i32, align 4
  %Y = alloca i32, align 4
  %Z = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %X, metadata !11, metadata !13), !dbg !14
  store i32 21, i32* %X, align 4, !dbg !14
  call void @llvm.dbg.declare(metadata i32* %Y, metadata !15, metadata !13), !dbg !16
  store i32 22, i32* %Y, align 4, !dbg !16
  call void @llvm.dbg.declare(metadata i32* %Z, metadata !17, metadata !13), !dbg !19
  store i32 23, i32* %Z, align 4, !dbg !19
  %0 = load i32, i32* %X, align 4, !dbg !20
  store i32 %0, i32* %Z, align 4, !dbg !21
  %1 = load i32, i32* %Y, align 4, !dbg !22
  store i32 %1, i32* %X, align 4, !dbg !23
  ret void, !dbg !24
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!7, !8, !9}
!llvm.ident = !{!10}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "scope.c", directory: "/Users/yangzx/llvm-dsa/lib/Transforms/World/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDSubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !5, isLocal: false, isDefinition: true, scopeLine: 1, isOptimized: false, function: void ()* @foo, variables: !2)
!5 = !MDSubroutineType(types: !6)
!6 = !{null}
!7 = !{i32 2, !"Dwarf Version", i32 2}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"PIC Level", i32 2}
!10 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!11 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "X", scope: !4, file: !1, line: 2, type: !12)
!12 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!13 = !MDExpression()
!14 = !MDLocation(line: 2, column: 7, scope: !4)
!15 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "Y", scope: !4, file: !1, line: 3, type: !12)
!16 = !MDLocation(line: 3, column: 7, scope: !4)
!17 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "Z", scope: !18, file: !1, line: 5, type: !12)
!18 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 4, column: 3)
!19 = !MDLocation(line: 5, column: 9, scope: !18)
!20 = !MDLocation(line: 6, column: 9, scope: !18)
!21 = !MDLocation(line: 6, column: 7, scope: !18)
!22 = !MDLocation(line: 8, column: 7, scope: !4)
!23 = !MDLocation(line: 8, column: 5, scope: !4)
!24 = !MDLocation(line: 9, column: 1, scope: !4)
