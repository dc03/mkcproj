#!/usr/bin/env -S bash --norc
mkc() {
    if [ -d $1 ]; then
        echo "Error: '$1' already exists"
        read -p "  Remove '$1' and make new directory? [y/N]: " delneeded
        if [[ ${delneeded} =~ ^[yY]$ ]]; then
            echo "Deleting '$1'"
            /usr/bin/rm -rf $1
            echo "Creating '$1'"
        elif [[ ${delneeded} =~ ^[nN]$ ]] || [[ ${delneeded} -eq "" ]]; then
            echo "  Directory exists, exiting."
            exit 1
        else
            echo "Error: Unrecognized option ${delneeded}"
            exit 1
        fi
    fi

    mkdir $1
    cd $1
    mkdir src
    touch src/main.$3
    echo "cmake_minimum_required(VERSION 3.10)
project($1 LANGUAGES $2)
set(CMAKE_$2_STANDARD $4)

add_executable($1 src/main.$3)" > CMakeLists.txt
    echo "---
AlignAfterOpenBracket: DontAlign
AlignConsecutiveMacros: true
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignEscapedNewlines: Right
AlignOperands: Align
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: false
AllowShortBlocksOnASingleLine: Empty
AllowShortCaseLabelsOnASingleLine: true
AllowShortFunctionsOnASingleLine: Inline
AllowShortIfStatementsOnASingleLine: Never
AllowShortLambdasOnASingleLine: All
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: 'Yes'
BinPackArguments: true
BinPackParameters: true
BreakBeforeBinaryOperators: None
BreakBeforeTernaryOperators: true
BreakConstructorInitializers: BeforeColon
BreakInheritanceList: BeforeColon
BreakStringLiterals: true
ColumnLimit: 120
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: true
Cpp11BracedListStyle: true
FixNamespaceComments: true
IncludeBlocks: Regroup
IndentCaseLabels: true
IndentPPDirectives: None
IndentWidth: 4
IndentWrappedFunctionNames: false
KeepEmptyLinesAtTheStartOfBlocks: false
Language: Cpp
NamespaceIndentation: None
PointerAlignment: Right
ReflowComments: true
SortIncludes: true
SortUsingDeclarations: true
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatements
SpaceBeforeRangeBasedForLoopColon: true
SpaceInEmptyParentheses: false
SpacesInCStyleCastParentheses: false
SpacesInContainerLiterals: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard: Auto

...
" > .clang-format
    mkdir build
    echo "build/" > .gitignore
    touch README.md
    git init
    git add .
    git commit -m "Initial commit"
}

read -p "Enter the name of the project : " projname
read -p "Enter the language [C/C++]    : " lang

if [[ ${lang} =~ ^(c|C)$ ]]; then
    read -p "Enter the C standard [89, 99, 11, 14, 18, 20]: " cstd
    if ! [[ ${cstd} =~ ^([89]9)|(1[148])|(20)$ ]]; then
        echo "Error: C standard needs to be one of 89, 99, 11, 14, 18, 20"
        exit 1
    fi
    mkc ${projname} "C" "c" ${cstd}
elif [[ ${lang} =~ ^([Cc](\+\+|[pP][pP]))$ ]]; then
    read -p "Enter the C++ standard [98, 03, 11, 14, 17, 20]: " cppstd
    if ! [[ ${cppstd} =~ ^((98)|(03)|(1[147])|(20))$ ]]; then
        echo "Error C++ standard needs to be one of 98, 03, 11, 14, 17, 20"
        exit 1
    fi
    mkc ${projname} "CXX" "cpp" ${cppstd}
else
    echo "Error: '${lang}' is not a recognized language"
    exit 1
fi
