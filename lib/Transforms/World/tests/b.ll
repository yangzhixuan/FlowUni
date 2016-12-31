; ModuleID = 'b.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define i32 @f(i32* %f, i32 %x) #0 {
entry:
  call void @llvm.dbg.value(metadata i32* %f, i64 0, metadata !13, metadata !14), !dbg !15
  call void @llvm.dbg.value(metadata i32 %x, i64 0, metadata !16, metadata !14), !dbg !17
  %cmp = icmp slt i32 %x, 5, !dbg !18
  br i1 %cmp, label %if.then, label %if.else, !dbg !20

if.then:                                          ; preds = %entry
  %call = call i8* @malloc(i64 1), !dbg !21
  call void @llvm.dbg.value(metadata i8* %call, i64 0, metadata !23, metadata !14), !dbg !26
  br label %if.end, !dbg !27

if.else:                                          ; preds = %entry
  %call1 = call i8* @malloc(i64 1), !dbg !28
  call void @llvm.dbg.value(metadata i8* %call1, i64 0, metadata !23, metadata !14), !dbg !26
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi i8* [ %call, %if.then ], [ %call1, %if.else ]
  store i8 0, i8* %c.0, align 1, !dbg !30
  %cmp2 = icmp slt i32 %x, 5, !dbg !31
  br i1 %cmp2, label %if.then3, label %if.end4, !dbg !33

if.then3:                                         ; preds = %if.end
  store i8 1, i8* %c.0, align 1, !dbg !34
  %add = add nsw i32 %x, %x, !dbg !36
  br label %return, !dbg !37

if.end4:                                          ; preds = %if.end
  %0 = load i8, i8* %c.0, align 1, !dbg !38
  %conv = sext i8 %0 to i32, !dbg !38
  %add5 = add nsw i32 %conv, %x, !dbg !39
  %conv6 = trunc i32 %add5 to i8, !dbg !38
  store i8 %conv6, i8* %c.0, align 1, !dbg !40
  %1 = load i8, i8* %c.0, align 1, !dbg !41
  %conv7 = sext i8 %1 to i32, !dbg !41
  %add8 = add nsw i32 %conv7, %x, !dbg !42
  call void @llvm.dbg.value(metadata i32 %add8, i64 0, metadata !43, metadata !14), !dbg !44
  call void @free(i8* %c.0), !dbg !45
  br label %return, !dbg !46

return:                                           ; preds = %if.end4, %if.then3
  %retval.0 = phi i32 [ %add, %if.then3 ], [ %add8, %if.end4 ]
  ret i32 %retval.0, !dbg !47
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
!1 = !MDFile(filename: "b.c", directory: "/Users/yangzx/llvm-dsa/lib/Transforms/World/tests")
!2 = !{}
!3 = !{!4}
!4 = !MDSubprogram(name: "f", scope: !1, file: !1, line: 3, type: !5, isLocal: false, isDefinition: true, scopeLine: 4, flags: DIFlagPrototyped, isOptimized: false, function: i32 (i32*, i32)* @f, variables: !2)
!5 = !MDSubroutineType(types: !6)
!6 = !{!7, !8, !7}
!7 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!8 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64, align: 64)
!9 = !{i32 2, !"Dwarf Version", i32 2}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"PIC Level", i32 2}
!12 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!13 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "f", arg: 1, scope: !4, file: !1, line: 3, type: !8)
!14 = !MDExpression()
!15 = !MDLocation(line: 3, column: 12, scope: !4)
!16 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "x", arg: 2, scope: !4, file: !1, line: 3, type: !7)
!17 = !MDLocation(line: 3, column: 19, scope: !4)
!18 = !MDLocation(line: 7, column: 10, scope: !19)
!19 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 7, column: 8)
!20 = !MDLocation(line: 7, column: 8, scope: !4)
!21 = !MDLocation(line: 8, column: 13, scope: !22)
!22 = distinct !MDLexicalBlock(scope: !19, file: !1, line: 7, column: 15)
!23 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "c", scope: !4, file: !1, line: 5, type: !24)
!24 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64, align: 64)
!25 = !MDBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!26 = !MDLocation(line: 5, column: 11, scope: !4)
!27 = !MDLocation(line: 9, column: 5, scope: !22)
!28 = !MDLocation(line: 10, column: 13, scope: !29)
!29 = distinct !MDLexicalBlock(scope: !19, file: !1, line: 9, column: 12)
!30 = !MDLocation(line: 12, column: 8, scope: !4)
!31 = !MDLocation(line: 13, column: 10, scope: !32)
!32 = distinct !MDLexicalBlock(scope: !4, file: !1, line: 13, column: 8)
!33 = !MDLocation(line: 13, column: 8, scope: !4)
!34 = !MDLocation(line: 14, column: 12, scope: !35)
!35 = distinct !MDLexicalBlock(scope: !32, file: !1, line: 13, column: 15)
!36 = !MDLocation(line: 15, column: 18, scope: !35)
!37 = !MDLocation(line: 15, column: 9, scope: !35)
!38 = !MDLocation(line: 17, column: 10, scope: !4)
!39 = !MDLocation(line: 17, column: 13, scope: !4)
!40 = !MDLocation(line: 17, column: 8, scope: !4)
!41 = !MDLocation(line: 18, column: 13, scope: !4)
!42 = !MDLocation(line: 18, column: 16, scope: !4)
!43 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "y", scope: !4, file: !1, line: 18, type: !7)
!44 = !MDLocation(line: 18, column: 9, scope: !4)
!45 = !MDLocation(line: 19, column: 5, scope: !4)
!46 = !MDLocation(line: 20, column: 5, scope: !4)
!47 = !MDLocation(line: 21, column: 1, scope: !4)
