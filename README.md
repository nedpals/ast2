# ast2

ast2 is a rewrite of some of V's [compiler modules](https://github.com/vlang/v/tree/master/vlib/v) (parser, checker, and etc.). It aims to simplify both in terms of the codebase and the architecture (in a way) and to further improve the developer experience and maximize its use for third-party tools outside the V compiler.

## what's the problem
One of the goals of the V compiler is to reduce the parsing to compilation times. Thus, most of the functionalities that should be done in multiple stages are being crammed to three components: scanner, parser, and checker. Duplicate attribute checking and type name checking are some of the examples that I can think of that illustrates this.

With this design in mind, it is impossible to skip some of the steps in situations where it is deemed unnecessary. Plus, in some use cases such as for IDE, a predictable, reusable, and memory-efficient would be suitable enough for a "partial" AST.

## what's the plan?
My plan is to solve dependency analysis / sharing, create a new data structure for a partial AST, and move any existing AST node types and parser checks to the "checker" instead.

Prior to this, the process looks like this:

```

Scanner ---> Parser ---> Checker
       Tokens       AST

```

The goal of ast2 is to be like this:

```

Scanner ---> Parser -------> Checker ------>
      Tokens      Partial AST   "Polished" / Full AST

```

This means any additional semantic checks previously done inside the parser are now handled by the checker which can now output a fully-polished AST.

### (c) 2022 Ned Palacios