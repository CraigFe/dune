open Stdune

module type Data = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
  val to_sexp : t -> Sexp.t
end

module type S = sig
  type input

  (** Type of memoized functions *)
  type 'a t

  (** [create name ?lifetime ouput_spec f] creates a memoized version
      of [f]. The result of [f] for a given input is cached, so that
      the second time [exec t x] is called, the previous result is
      re-used if possible.

      [exec t x] tracks what calls to other memoized function [f x]
      performs. When the result of such dependent call changes, [exec t
      x] will automatically recomputes [f x].

      Running the computation may raise [Memo.Cycle_error.E] if a cycle is
      detected.  *)
  val create
    :  string
    -> ?allow_cutoff:bool
    -> (module Data with type t = 'a)
    -> (input -> 'a Fiber.t)
    -> 'a t

  (** Execute a memoized function *)
  val exec : 'a t -> input -> 'a Fiber.t

  (** Check whether we already have a value for the given call *)
  val peek : 'a t -> input -> 'a option
  val peek_exn : 'a t -> input -> 'a

  (** After running a memoization function with a given name and
      input, it is possibly to query which dependencies that function
      used during execution by calling [get_deps] with the name and
      input used during execution. *)
  val get_deps : _ t -> input -> (string * Sexp.t) list option

  type stack_frame

  module Stack_frame : sig
    val instance_of : stack_frame -> of_:_ t -> bool
    val input : stack_frame -> input option
  end
end
