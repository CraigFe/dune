  $ echo "(lang dune 2.8)" > dune-project
  $ mkdir lib
  $ touch lib.opam file lib/lib.ml
  $ cat >lib/dune <<EOF
  > (library (name lib) (public_name lib))
  > (copy_files (files ../file))
  > EOF

  $ dune build
  Internal error, please report upstream including the contents of _build/log.
  Description:
    ("dependency cycle that does not involve any files",
    { frames =
        [ ("eval-pred",
          { dir = In_build_dir "default"; predicate = { id = Glob "file" } })
        ; ("dir-contents-get0", ("default", "default/lib"))
        ; ("stanzas-to-entries", "default")
        ; ("<unnamed>", ())
        ; ("<unnamed>", ())
        ; ("<unnamed>", ())
        ; ("<unnamed>", ())
        ; ("load-dir", In_build_dir "default")
        ; ("eval-pred",
          { dir = In_build_dir "default"; predicate = { id = Glob "file" } })
        ]
    })
  Raised at Stdune__Code_error.raise in file
    "otherlibs/stdune-unstable/code_error.ml", line 9, characters 30-62
  Called from Stdune__Exn_with_backtrace.map in file
    "otherlibs/stdune-unstable/exn_with_backtrace.ml", line 25, characters
    40-45
  Called from Dune_engine__Build_system.process_exn_and_reraise in file
    "src/dune_engine/build_system.ml", line 1967, characters 4-180
  Called from Fiber.Execution_context.forward_exn_with_bt in file
    "src/fiber/fiber.ml", line 140, characters 10-17
  
  I must not crash.  Uncertainty is the mind-killer. Exceptions are the
  little-death that brings total obliteration.  I will fully express my cases. 
  Execution will pass over me and through me.  And when it has gone past, I
  will unwind the stack along its path.  Where the cases are handled there will
  be nothing.  Only I will remain.
  [1]
