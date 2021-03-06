(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: clflags.ml 12511 2012-05-30 13:29:48Z lefessan $ *)

(* Command-line parameters *)

let objfiles = ref ([] : string list)   (* .cmo and .cma files *)
and ccobjs = ref ([] : string list)     (* .o, .a, .so and -cclib -lxxx *)
and dllibs = ref ([] : string list)     (* .so and -dllib -lxxx *)

let compile_only = ref false            (* -c *)
and output_name = ref (None : string option) (* -o *)
and include_dirs = ref ([] : string list)(* -I *)
and no_std_include = ref false          (* -nostdlib *)
and print_types = ref false             (* -i *)
and make_archive = ref false            (* -a *)
and debug = ref false                   (* -g *)
and fast = ref false                    (* -unsafe *)
and link_everything = ref false         (* -linkall *)
and custom_runtime = ref false          (* -custom *)
and output_c_object = ref false         (* -output-obj *)
and ccopts = ref ([] : string list)     (* -ccopt *)
and classic = ref false                 (* -nolabels *)
and nopervasives = ref false            (* -nopervasives *)
and preprocessor = ref(None : string option) (* -pp *)
let annotations = ref false             (* -annot *)
let binary_annotations = ref false      (* -annot *)
and use_threads = ref false             (* -thread *)
and use_vmthreads = ref false           (* -vmthread *)
and noassert = ref false                (* -noassert *)
and verbose = ref false                 (* -verbose *)
and noprompt = ref false                (* -noprompt *)
and nopromptcont = ref false            (* -nopromptcont *)
and init_file = ref (None : string option)   (* -init *)
and use_prims = ref ""                  (* -use-prims ... *)
and use_runtime = ref ""                (* -use-runtime ... *)
and principal = ref false               (* -principal *)
and real_paths = ref false              (* -real-paths *)
and recursive_types = ref false         (* -rectypes *)
and strict_sequence = ref false         (* -strict-sequence *)
and applicative_functors = ref true     (* -no-app-funct *)
and make_runtime = ref false            (* -make-runtime *)
and gprofile = ref false                (* -p *)
and c_compiler = ref (None: string option) (* -cc *)
and no_auto_link = ref false            (* -noautolink *)
and dllpaths = ref ([] : string list)   (* -dllpath *)
and make_package = ref false            (* -pack *)
and for_package = ref (None: string option) (* -for-pack *)
and error_size = ref 500                (* -error-size *)
let dump_parsetree = ref false          (* -dparsetree *)
and dump_rawlambda = ref false          (* -drawlambda *)
and dump_lambda = ref false             (* -dlambda *)
and dump_clambda = ref false            (* -dclambda *)
and dump_instr = ref false              (* -dinstr *)

let keep_asm_file = ref false           (* -S *)
let optimize_for_speed = ref true       (* -compact *)

and dump_cmm = ref false                (* -dcmm *)
let dump_selection = ref false          (* -dsel *)
let dump_live = ref false               (* -dlive *)
let dump_spill = ref false              (* -dspill *)
let dump_split = ref false              (* -dsplit *)
let dump_interf = ref false             (* -dinterf *)
let dump_prefer = ref false             (* -dprefer *)
let dump_regalloc = ref false           (* -dalloc *)
let dump_reload = ref false             (* -dreload *)
let dump_scheduling = ref false         (* -dscheduling *)
let dump_linear = ref false             (* -dlinear *)
let keep_startup_file = ref false       (* -dstartup *)
let dump_combine = ref false            (* -dcombine *)

let native_code = ref false             (* set to true under ocamlopt *)
let inline_threshold = ref 10

let dont_write_files = ref false        (* set to true under ocamldoc *)

let std_include_flag prefix =
  if !no_std_include then ""
  else (prefix ^ (Filename.quote Config.standard_library))
;;

let std_include_dir () =
  if !no_std_include then [] else [Config.standard_library]
;;

let shared = ref false (* -shared *)
let dlcode = ref true (* not -nodynlink *)

let runtime_variant = ref "";;     (* -runtime-variant *)

type snapshot = (unit -> unit) list

let snapshot =
  let save_ref r =
    let v = !r in
    fun () -> r := v
  in
  let bools = [
    compile_only; no_std_include; print_types; make_archive; debug; fast;
    link_everything; custom_runtime; output_c_object; classic; nopervasives;
    annotations; binary_annotations; use_threads; use_vmthreads; noassert;
    verbose; noprompt; nopromptcont; principal; real_paths; recursive_types;
    strict_sequence; applicative_functors; make_runtime; gprofile;
    no_auto_link; make_package; dump_parsetree; dump_rawlambda; dump_lambda;
    dump_clambda; dump_instr; keep_asm_file; optimize_for_speed; dump_cmm;
    dump_selection; dump_live; dump_spill; dump_split; dump_interf;
    dump_prefer; dump_regalloc; dump_reload; dump_scheduling; dump_linear;
    keep_startup_file; dump_combine; native_code; dont_write_files; shared;
    dlcode 
  ] in
  fun () ->
    save_ref inline_threshold :: 
    save_ref output_name :: 
    save_ref dllpaths :: 
    save_ref objfiles :: 
    save_ref ccobjs :: 
    save_ref dllibs :: 
    save_ref include_dirs :: 
    save_ref ccopts :: 
    save_ref preprocessor :: 
    save_ref init_file :: 
    save_ref use_prims :: 
    save_ref use_runtime :: 
    save_ref runtime_variant :: 
    save_ref c_compiler :: 
    save_ref for_package :: 
    save_ref error_size :: 
    List.map save_ref bools

let restore snapshot = List.iter (fun x -> x ()) snapshot

