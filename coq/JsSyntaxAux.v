Set Implicit Arguments.
Require Import LibLogic LibHeap.
Require Export JsSyntax. 
Implicit Type l : object_loc.


(**************************************************************)
(** ** Smart constructors for objects *)

(** Builds an object with all optional fields to None *)

Definition object_create vproto sclass bextens P :=
  {| object_proto_ := vproto;
     object_class_ := sclass;
     object_extensible_ := bextens;
     object_properties_ := P;
     object_prim_value_ := None;
     object_construct_ := None;
     object_call_ := None;
     object_has_instance_ := None;
     object_scope_ := None;
     object_formal_parameters_ := None;
     object_code_ := None;
     object_target_function_ := None; 
     object_bound_this_ := None; 
     object_bound_args_ := None; 
     object_parameter_map_ := None |}.

(** Modifies the property field of an object. *)

Definition object_with_properties O properties :=
  match O with 
  | object_intro x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 =>
    object_intro x1 x2 x3 properties x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15  
  end.

(** Modifies the primitive value field of an object *)

Definition object_with_primitive_value O v :=
  match O with 
  | object_intro x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 =>
    object_intro x1 x2 x3 x4 (Some v) x6 x7 x8 x9 x10 x11 x12 x13 x14 x15  
  end.

(** Modifies the construct, call and has_instance fields of an object *)

Definition object_with_invokation O constr call has_instance :=
  match O with 
  | object_intro x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 =>
    object_intro x1 x2 x3 x4 x5 constr call has_instance x9 x10 x11 x12 x13 x14 x15  
  end.

(** Modifies the other parameters of an object *)

Definition object_with_details O scope params code target boundthis boundargs paramsmap :=
  match O with 
  | object_intro x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 =>
    object_intro x1 x2 x3 x4 x5 x6 x7 x8 scope params code target boundthis boundargs paramsmap
  end.


(**************************************************************)
(** ** Type [builtin] *)

(** Inhabitant *)

Global Instance builtin_inhab : Inhab builtin.
Proof. apply (prove_Inhab builtin_global). Qed.

(** Boolean comparison 

Definition object_loc_compare bl1 bl2 :=
  match bl1, bl2 with
  | builtin_global, builtin_global => true
  | builtin_range_error, builtin_range_error => true
  | builtin_ref_error, builtin_ref_error => true
  | builtin_syntax_error, builtin_syntax_error => true
  | builtin_type_error, builtin_type_error => true
  | _, _ => false
  end.
*)

(** Decidable comparison *)

Global Instance builtin_comparable : Comparable builtin.
Proof.
  apply make_comparable. introv.
  destruct x; destruct y;
    ((applys decidable_make false;
    rewrite eqb_neq; auto; discriminate) ||
    (applys decidable_make true;
    rewrite eqb_self; auto; fail) ||
    idtac).
  destruct m; destruct m0.
    applys decidable_make true.
    rewrite* eqb_self.
Qed.


(**************************************************************)
(** ** Type [object_loc] *)

(** Inhabitant *)

Global Instance object_loc_inhab : Inhab object_loc.
Proof. apply (prove_Inhab (object_loc_normal 0%nat)). Qed.

(** Boolean comparison *)

Definition object_loc_compare l1 l2 :=
  match l1, l2 with
  | object_loc_normal ln1, object_loc_normal ln2 => decide (ln1 = ln2)
  | object_loc_builtin bl1,  object_loc_builtin bl2 => decide (bl1 = bl2)
  | _, _ => false
  end.

(** Decidable comparison *)

Global Instance object_loc_comparable : Comparable object_loc.
Proof.
  applys (comparable_beq object_loc_compare). intros x y.
  destruct x; destruct y; simpl; rew_refl; iff;
   tryfalse; auto; try congruence.
Qed.


(**************************************************************)
(** ** Type [prim] *)

(** Inhabitant *)

Global Instance prim_inhab : Inhab prim.
Proof. apply (prove_Inhab prim_undef). Qed.

(** Boolean comparison *)

Definition prim_compare w1 w2 :=
  match w1, w2 with
  | prim_undef, prim_undef => true
  | prim_null, prim_null => true
  | prim_bool b1, prim_bool b2 => decide (b1 = b2)
  | prim_number n1, prim_number n2 => decide (n1 = n2)
  | prim_string s1, prim_string s2 => decide (s1 = s2)
  | _, _ => false
  end.

(** Decidable comparison *)

Global Instance prim_comparable : Comparable prim.
Proof.
  applys (comparable_beq prim_compare). intros x y.
  destruct x; destruct y; simpl; rew_refl; iff;
   tryfalse; auto; try congruence.
Qed.


(**************************************************************)
(** ** Type [value] *)

(** Inhabitant *)

Global Instance value_inhab : Inhab value.
Proof. apply (prove_Inhab (value_prim arbitrary)). Qed.

(** Boolean comparison *)

Definition value_compare v1 v2 :=
  match v1, v2 with
  | value_prim w1, value_prim w2 => decide (w1 = w2)
  | value_object l1, value_object l2 => decide (l1 = l2)
  | _, _ => false
  end.

(** Decidable comparison *)

Global Instance value_comparable : Comparable value.
Proof.
  applys (comparable_beq value_compare). intros x y.
  destruct x; destruct y; simpl; rew_refl; iff;
   tryfalse; auto; try congruence.
Qed.

(**************************************************************)
(** ** Type [mutability] *)

(** Inhabitant *)

Global Instance mutability_inhab : Inhab mutability.
Proof. apply (prove_Inhab mutability_deletable). Qed.


(**************************************************************)
(** ** Type [ref] *)

Global Instance ref_inhab : Inhab ref.
Proof. 
  (* apply (prove_Inhab (reference_intro )).
  ---TODO
  *) skip. 
Qed.


(**************************************************************)
(** ** Type [ref] *)

(** Inhabitants **)

Global Instance env_record_inhab : Inhab env_record.
Proof. apply (prove_Inhab (env_record_decl Heap.empty)). Qed.


(**************************************************************)
(** ** Type [state] *)

(** Inhabitants **)

Global Instance state_inhab : Inhab state.
Admitted.


(**************************************************************)
(** ** Type [prop_descriptor] *)

(** Inhabitants **)

Global Instance prop_descriptor_inhab : Inhab prop_descriptor.
Proof. apply (prove_Inhab prop_descriptor_undef). Qed.


(**************************************************************)
(** ** Type [object] *)

(** Inhabitants **)

Global Instance object_inhab : Inhab object.
Proof.
  apply (prove_Inhab (object_create arbitrary arbitrary arbitrary arbitrary)).
Qed.

(**************************************************************)
(** TODO: complete this file *)

