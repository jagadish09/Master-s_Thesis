
(include-book "workshops/2003/cowles-gamboa-van-baalen_matrix/support/matalg" :dir :system)
(include-book "nonstd/nsa/sqrt" :dir :system)
(include-book "groups")



(defun id-rotation ()
  '((:header :dimensions (3 3)
	     :maximum-length 10)
    ((0 . 0) . 1)
    ((0 . 1) . 0)
    ((0 . 2) . 0)
    ((1 . 0) . 0)
    ((1 . 1) . 1)
    ((1 . 2) . 0)
    ((2 . 0) . 0)
    ((2 . 1) . 0)
    ((2 . 2) . 1) 
    )
  )

(defun a-rotation (x)
  `((:header :dimensions (3 3)
	     :maximum-length 10)
    ((0 . 0) . 1)
    ((0 . 1) . 0)
    ((0 . 2) . 0)
    ((1 . 0) . 0)
    ((1 . 1) . 1/3)
    ((1 . 2) . ,(* -2/3 x) )
    ((2 . 0) . 0)
    ((2 . 1) . ,(* 2/3 x) )
    ((2 . 2) . 1/3)
    )
  )

(defun a-inv-rotation (x)
  `((:header :dimensions (3 3)
	     :maximum-length 10)
    ((0 . 0) . 1)
    ((0 . 1) . 0)
    ((0 . 2) . 0)
    ((1 . 0) . 0)
    ((1 . 1) . 1/3)
    ((1 . 2) . ,(* 2/3 x) )
    ((2 . 0) . 0)
    ((2 . 1) . ,(* -2/3 x) )
    ((2 . 2) . 1/3) 
    )
  )

(defun b-rotation (x)
  `((:header :dimensions (3 3)
	     :maximum-length 10)
    ((0 . 0) . 1/3)
    ((0 . 1) . ,(* -2/3 x) )
    ((0 . 2) . 0)
    ((1 . 0) . ,(* 2/3 x) )
    ((1 . 1) . 1/3)
    ((1 . 2) . 0)
    ((2 . 0) . 0)
    ((2 . 1) . 0)
    ((2 . 2) . 1)    
    )
  )

(defun b-inv-rotation (x)
  `((:header :dimensions (3 3)
	     :maximum-length 10)
    ((0 . 0) . 1/3)
    ((0 . 1) . ,(* 2/3 x) )
    ((0 . 2) . 0)
    ((1 . 0) . ,(* -2/3 x) )
    ((1 . 1) . 1/3)
    ((1 . 2) . 0)
    ((2 . 0) . 0)
    ((2 . 1) . 0)
    ((2 . 2) . 1)
    )
  )

(defun point-p ()
  '((:header :dimensions (3 1)
	     :maximum-length 15)
    ((0 . 0) . 0)
    ((1 . 0) . 1)
    ((2 . 0) . 0)
    
    )
  )



(local (include-book "arithmetic-5/top" :dir :system))

(local
 (defthm compress21-lemma
   (equal (compress21 name l n i j default)
	  (if (zp (- i n)) nil
	    (append (compress211 name l n 0 j default)
		    (compress21 name l (+ n 1) i j default))))
   :hints (("Goal"
	    :in-theory (enable compress21 compress211)
	    ))		 
   )
 )

(local
 (defthm m-=-row-1-lemma
   (equal (m-=-row-1 m1 m2 m n)
	  (if (zp m)
	      (m-=-row m1 m2 0 n)
	    (and (m-=-row m1 m2 m n)
		 (m-=-row-1 m1 m2 (- m 1) n))))
   )
 )

(local
 (defthm m-=-row-lemma
   (equal (m-=-row m1 m2 m n)
	  (if (zp n)
	      (equal (fix (aref2 '$arg1 M1 m 0))
		     (fix (aref2 '$arg2 M2 m 0)))
	    (and (equal (fix (aref2 '$arg1 M1 m n))
			(fix (aref2 '$arg2 M2 m n)))
		 (m-=-row M1 M2 m (- n 1)))))
   )
 )


(defthmd funs-lemmas-1
  (and (m-= (m-* (id-rotation) (a-rotation x)) (a-rotation x))
       (m-= (m-* (id-rotation) (a-inv-rotation x)) (a-inv-rotation x))
       (m-= (m-* (id-rotation) (b-rotation x)) (b-rotation x))
       (m-= (m-* (id-rotation) (b-inv-rotation x)) (b-inv-rotation x))
       (m-= (m-* (a-rotation x) (id-rotation)) (a-rotation x))
       (m-= (m-* (a-inv-rotation x) (id-rotation)) (a-inv-rotation x))
       (m-= (m-* (b-rotation x) (id-rotation)) (b-rotation x))
       (m-= (m-* (b-inv-rotation x) (id-rotation)) (b-inv-rotation x))
       )
  :hints (("Goal"
	   :in-theory (enable 
		       alist2p array2p aset2 aref2 compress2 header
		       dimensions maximum-length default
		       matrixp compress21
		       m-=
		       m-0
		       m-1
		       m-trans
		       m-unary--
		       s-*
		       m-binary-+
		       m-binary-*
		       m-/
		       m-singularp
		       M-BINARY-*-ROW-1
		       m-=-row-1
		       m-=-row)
	   )
	  )
  )

(defthmd array2p-funs
  (implies (symbolp y)
	   (and (array2p y (id-rotation))
		(array2p y (a-rotation x))
		(array2p y (a-inv-rotation x))
		(array2p y (b-rotation x))
		(array2p y (b-inv-rotation x))
		(array2p y (point-p))
		(equal (first (dimensions y (id-rotation))) 3)
		(equal (second (dimensions y (id-rotation))) 3)
		(equal (first (dimensions y (a-rotation x))) 3)
		(equal (second (dimensions y (a-rotation x))) 3)
		(equal (first (dimensions y (a-inv-rotation x))) 3)
		(equal (second (dimensions y (a-inv-rotation x))) 3)
		(equal (first (dimensions y (b-rotation x))) 3)
		(equal (second (dimensions y (b-rotation x))) 3)
		(equal (first (dimensions y (b-inv-rotation x))) 3)
		(equal (second (dimensions y (b-inv-rotation x))) 3)
		(equal (first (dimensions y (point-p))) 3)
		(equal (second (dimensions y (point-p))) 1)
		)
	   )
  :hints (("Goal"
	   :in-theory (enable array2p dimensions header maximum-length)
	   ))
  )

(defthmd
  dimensions-array2p-m-*
  (implies (and (array2p name M1)
		(array2p name M2)
		(equal (first (dimensions name M1)) 3)
		(equal (second (dimensions name M1)) 3)
		(equal (first (dimensions name M2)) 3)
		(equal (second (dimensions name M2)) 3))
	   (equal (dimensions name (m-* M1 M2))
		  (list (first (dimensions name M1))
			(second (dimensions name M2)))))
  )

(defthmd
  dimensions-array2p-m-*-1
  (implies (and (array2p name M1)
		(array2p name M2)
		(equal (first (dimensions name M1)) 3)
		(equal (second (dimensions name M1)) 3)
		(equal (first (dimensions name M2)) 3)
		(equal (second (dimensions name M2)) 1))
	   (equal (dimensions name (m-* M1 M2))
		  (list (first (dimensions name M1))
			(second (dimensions name M2)))))
  )


(defun rotation (w x)
  (cond ((atom w) (id-rotation))
	((equal (car w) (wa)) (m-* (a-rotation x) (rotation (cdr w) x)))
	((equal (car w) (wa-inv)) (m-* (a-inv-rotation x) (rotation (cdr w) x)))
	((equal (car w) (wb)) (m-* (b-rotation x) (rotation (cdr w) x)))
	((equal (car w) (wb-inv)) (m-* (b-inv-rotation x) (rotation (cdr w) x)))
	)
  )

(defthmd rotation-=
  (implies (and (reducedwordp w)
		(not (atom w)))	   
	   (cond 
	    ((equal (car w) (wa)) (equal (rotation w x) (m-* (a-rotation x) (rotation (cdr w) x))))
	    ((equal (car w) (wa-inv)) (equal (rotation w x) (m-* (a-inv-rotation x) (rotation (cdr w) x))))
	    ((equal (car w) (wb)) (equal (rotation w x) (m-* (b-rotation x) (rotation (cdr w) x))))
	    ((equal (car w) (wb-inv)) (equal (rotation w x) (m-* (b-inv-rotation x) (rotation (cdr w) x))))
	    )
	   ))

(defthmd rotation-props-ind-case-0
  (IMPLIES
   (AND (NOT (ATOM W))
	(IMPLIES (AND (REDUCEDWORDP (CDR W))
		      (SYMBOLP NAME))
		 (AND (ARRAY2P NAME (ROTATION (CDR W) X))
		      (EQUAL (CAR (DIMENSIONS NAME (ROTATION (CDR W) X)))
			     3)
		      (EQUAL (CADR (DIMENSIONS NAME (ROTATION (CDR W) X)))
			     3))))
   (IMPLIES (AND (REDUCEDWORDP W)
		 (SYMBOLP NAME))
	    (ARRAY2P NAME (ROTATION W X))
	    ))
  :hints (("Goal"
	   :use (
		 (:instance rotation-= (w w) (x x))
		 (:instance reduced-cdr (x w))
		 )
	   :in-theory nil
	   )
	  ("Subgoal 4"
	   :use ((:instance array2p-m-*
			    (name name)
			    (m2 (rotation (cdr w) x))
			    (m1 (a-rotation x)))
		 (:instance array2p-funs (y name) (x x))
		 )
	   )
	  ("Subgoal 3"
	   :use ((:instance array2p-m-*
			    (name name)
			    (m2 (rotation (cdr w) x))
			    (m1 (a-inv-rotation x)))
		 (:instance array2p-funs (y name) (x x))
		 )
	   )
	  ("Subgoal 2"
	   :use ((:instance array2p-m-*
			    (name name)
			    (m2 (rotation (cdr w) x))
			    (m1 (b-rotation x)))
		 (:instance array2p-funs (y name) (x x))
		 )
	   )
	  ("Subgoal 1"
	   :use ((:instance array2p-m-*
			    (name name)
			    (m2 (rotation (cdr w) x))
			    (m1 (b-inv-rotation x)))
		 (:instance array2p-funs (y name) (x x))
		 )
	   )
	  
	  )
  )


(defthmd rotation-props-ind-case-1
  (IMPLIES
   (AND (NOT (ATOM W))
	(IMPLIES (AND (REDUCEDWORDP (CDR W))
		      (SYMBOLP NAME))
		 (AND (ARRAY2P NAME (ROTATION (CDR W) X))
		      (EQUAL (CAR (DIMENSIONS NAME (ROTATION (CDR W) X)))
			     3)
		      (EQUAL (CADR (DIMENSIONS NAME (ROTATION (CDR W) X)))
			     3))))
   (IMPLIES (AND (REDUCEDWORDP W)
		 (SYMBOLP NAME))
	    (and 
	     (EQUAL (CAR (DIMENSIONS NAME (ROTATION W X)))
		    3)
	     (EQUAL (CADR (DIMENSIONS NAME (ROTATION W X)))
		    3)
	     )))
  :hints (("Goal"
	   :use (
		 (:instance rotation-= (w w) (x x))
		 (:instance reduced-cdr (x w))
		 )
	   :in-theory nil
	   )
	  ("Subgoal 8"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (a-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 7"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (a-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 6"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (a-inv-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 5"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (a-inv-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 4"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (b-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 3"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (b-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 2"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (b-inv-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )
	  ("Subgoal 1"
	   :use ((:instance dimensions-array2p-m-*
			    (m1 (b-inv-rotation x))
			    (m2 (rotation (cdr w) x)))
		 (:instance array2p-funs (y name) (x x)))
	   )

	  )
  )

(defthmd rotation-props
  (implies (and (reducedwordp w)
		(symbolp name))
	   (and (array2p name (rotation w x))
		(equal (first (dimensions name (rotation w x))) 3)
		(equal (second (dimensions name (rotation w x))) 3))
	   )
  :hints (("Subgoal *1/5"
	   :use ((:instance rotation-props-ind-case-0)
		 (:instance rotation-props-ind-case-1))
	   )
	  ("Subgoal *1/4"
	   :use ((:instance rotation-props-ind-case-0)
		 (:instance rotation-props-ind-case-1))
	   )
	  ("Subgoal *1/3"
	   :use ((:instance rotation-props-ind-case-0)
		 (:instance rotation-props-ind-case-1))
	   )
	  ("Subgoal *1/2"
	   :use ((:instance rotation-props-ind-case-0)
		 (:instance rotation-props-ind-case-1))
	   )
	  ("Subgoal *1/1"
	   :in-theory (enable dimensions header maximum-length)
	   )
	  )
  )


(defthmd m-*-rotation-point-dim
  (implies (and (reducedwordp w)
		(symbolp name))
	   (and (array2p name (m-* (rotation w x) (point-p)))
		(equal (first (dimensions name (m-* (rotation w x) (point-p)))) 3)
		(equal (second (dimensions name (m-* (rotation w x) (point-p)))) 1))
	   )
  :hints (("Goal"
	   :use ((:instance rotation-props (w w) (x x) (name name))
		 (:instance dimensions-array2p-m-*-1
			    (m1 (rotation w x))
			    (m2 (point-p))
			    (name name))
		 (:instance array2p-funs
			    (y name))
		 )
	   :in-theory (disable rotation)
	   ))
  )

(defun int-point (a i j n x)
  (cond ((and (equal i 0) (equal j 0)) (* (/ (aref2 '$arg1 a i j) x) (expt 3 n)))
	((and (equal i 2) (equal j 0)) (* (/ (aref2 '$arg1 a i j) x) (expt 3 n)))
	((and (equal i 1) (equal j 0)) (* (aref2 '$arg1 a i j) (expt 3 n)))
	(t nil))
  )


(defthmd rotation-values-ind-case-lemma1-1
  (implies (and (symbolp name)
		(acl2-numberp (aref2 name m1 0 0))
		(acl2-numberp (aref2 name m1 1 0))
		(acl2-numberp (aref2 name m1 2 0)))
	   (and (acl2-numberp (aref2 '$arg1 m1 0 0))
		(acl2-numberp (aref2 '$arg1 m1 1 0))
		(acl2-numberp (aref2 '$arg1 m1 2 0))
		(acl2-numberp (aref2 '$arg2 m1 0 0))
		(acl2-numberp (aref2 '$arg2 m1 1 0))
		(acl2-numberp (aref2 '$arg2 m1 2 0)))
	   
	   )
  :hints (("Goal"
	   :in-theory (enable aref2 default header)
	   ))

  )

(defthmd rotation-values-ind-case-lemma1
  (implies (and (symbolp name)
		(acl2-numberp (aref2 name m1 0 0))
		(acl2-numberp (aref2 name m1 1 0))
		(acl2-numberp (aref2 name m1 2 0))
		(acl2-numberp x)
		(array2p name m1)
		(equal (first (dimensions name m1)) 3)
		(equal (second (dimensions name m1)) 1))
	   (and (equal (aref2 name (m-* (a-rotation x) m1) 0 0) (aref2 name m1 0 0))
		(equal (aref2 name (m-* (a-rotation x) m1) 1 0) (/ (- (aref2 name m1 1 0) (* 2 x (aref2 name m1 2 0))) 3))
		(equal (aref2 name (m-* (a-rotation x) m1) 2 0) (/ (+ (* 2 x (aref2 name m1 1 0)) (aref2 name m1 2 0)) 3))
		(equal (aref2 name (m-* (a-inv-rotation x) m1) 0 0) (aref2 name m1 0 0))
		(equal (aref2 name (m-* (a-inv-rotation x) m1) 1 0) (/ (+ (aref2 name m1 1 0) (* 2 x (aref2 name m1 2 0))) 3))
		(equal (aref2 name (m-* (a-inv-rotation x) m1) 2 0) (/ (- (aref2 name m1 2 0) (* 2 x (aref2 name m1 1 0))) 3))
		(equal (aref2 name (m-* (b-rotation x) m1) 0 0) (/ (- (aref2 name m1 0 0) (* 2 x (aref2 name m1 1 0))) 3))
		(equal (aref2 name (m-* (b-rotation x) m1) 1 0) (/ (+ (aref2 name m1 1 0) (* 2 x (aref2 name m1 0 0))) 3))
		(equal (aref2 name (m-* (b-rotation x) m1) 2 0) (aref2 name m1 2 0))
		(equal (aref2 name (m-* (b-inv-rotation x) m1) 0 0) (/ (+ (aref2 name m1 0 0) (* 2 x (aref2 name m1 1 0))) 3))
		(equal (aref2 name (m-* (b-inv-rotation x) m1) 1 0) (/ (- (aref2 name m1 1 0) (* 2 x (aref2 name m1 0 0))) 3))
		(equal (aref2 name (m-* (b-inv-rotation x) m1) 2 0) (aref2 name m1 2 0)))
	   )
  :hints (("Goal"
	   :use (
		 (:instance array2p-funs (y name))
		 (:instance array2p-alist2p (name name) (l m1))
		 (:instance array2p-alist2p (name name) (l (a-rotation x)))
		 (:instance array2p-alist2p (name name) (l (a-inv-rotation x)))
		 (:instance array2p-alist2p (name name) (l (b-rotation x)))
		 (:instance array2p-alist2p (name name) (l (b-inv-rotation x)))
		 (:instance rotation-values-ind-case-lemma1-1)
		 )
	   :in-theory (enable aref2 default header)
	   ))
  )


(encapsulate
 ()

 (local
  (defthmd acl2-nump-rot-ind
    (IMPLIES (AND (NOT (ATOM W))
		  (IMPLIES (AND (ACL2-NUMBERP X)
				(symbolp name)
				(REDUCEDWORDP (CDR W)))
			   (and (ACL2-NUMBERP (aref2 name (M-* (ROTATION (CDR W) X) (POINT-P)) 0 0))
				(ACL2-NUMBERP (aref2 name (M-* (ROTATION (CDR W) X) (POINT-P)) 1 0))
				(ACL2-NUMBERP (aref2 name (M-* (ROTATION (CDR W) X) (POINT-P)) 2 0)))))
	     (IMPLIES (AND (ACL2-NUMBERP X) (REDUCEDWORDP W) (symbolp name))
		      (and (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 0 0))
			   (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 1 0))
			   (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 2 0)))))
    :hints (("Goal"
	     :use (
		   (:instance m-*-rotation-point-dim (w (cdr w)) (name name))
		   (:instance rotation-= (w w))
		   (:instance associativity-of-m-*
			      (m1 (a-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (a-inv-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (b-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (b-inv-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))

		   (:instance rotation-values-ind-case-lemma1
			      (m1 (M-* (ROTATION (CDR W) X) (POINT-P)))
			      (name name)
			      (x x)
			      )
		   
		   )
	     :do-not-induct t
	     
	     ))
    
    )
  )
 

 (defthmd acl2-nump-rot
   (implies (and (acl2-numberp x)
		 (symbolp name)
		 (reducedwordp w))
	    (and (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 0 0))
		 (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 1 0))
		 (ACL2-NUMBERP (aref2 name (M-* (ROTATION w X) (POINT-P)) 2 0))))
   
   :hints (("Subgoal *1/5"
	    :use (:instance acl2-nump-rot-ind)
	    )
	   ("Subgoal *1/4"
	    :use (:instance acl2-nump-rot-ind)
	    )
	   ("Subgoal *1/3"
	    :use (:instance acl2-nump-rot-ind)
	    )
	   ("Subgoal *1/2"
	    :use (:instance acl2-nump-rot-ind)
	    )
	   ("Subgoal *1/1"
	    :in-theory (enable reducedwordp rotation aref2)
	    )
	   
	   )
   )
 )

					;(encapsulate
					;()

;; (local
;;  (defthmd lemma-0
;;    (implies (and (integerp x)
;; 		  (integerp y))
;; 	     (integerp (+ x y)))
;;    )
;;  )

;; (local
;;  (defthmd lemma-1
;;    (implies (integerp n)
;; 	     (equal (* (expt 3 (- n 1)) 3) (expt 3 n)))
;; 	;	  (equal (expt 3 (- n 1)) (/ (expt 3 n) 3))
;; 	;	  (equal (expt 3 n) (* (expt 3 (- n 1)) 3))))
;;    )
;;  )

;; (local
;;  (defthmd lemma-2
;;    (implies (integerp x)
;; 	     (integerp (* x 3)))
;;    )
;;  )

;; (local
;;  (defthmd lemma-3
;;    (implies (integerp n)
;; 	     (equal (/ (expt 3 n) 3) (expt 3 (- n 1))))    
;;    )
;;  )

;; (local
;;  (defthmd lemma-4
;;    (implies (integerp x)
;; 	     (integerp (* x 4)))
;;    )
;;  )

(encapsulate
 ()

 (local
  (skip-proofs
   (defthmd lemma-0
     (implies (and (acl2-numberp a)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ a x) (expt 3 (- n 1)))))
	      (integerp (* (/ a x) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-1
     (implies (and (acl2-numberp b)
		   (acl2-numberp c)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* b (expt 3 (- n 1))))
		   (integerp (* (/ c x) (expt 3 (- n 1)))))
	      (integerp (* (/ (- b (* 2 x c)) 3) (expt 3 n)))
	      )
     )
   )
  )


 (local
  (skip-proofs
   (defthmd lemma-2
     (implies (and (acl2-numberp b)
		   (acl2-numberp c)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* b (expt 3 (- n 1))))
		   (integerp (* (/ c x) (expt 3 (- n 1)))))
	      (integerp (* (/ (/ (+ (* 2 x b) c) 3) x) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-3
     (implies (and (acl2-numberp b)
		   (acl2-numberp c)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* b (expt 3 (- n 1))))
		   (integerp (* (/ c x) (expt 3 (- n 1)))))
	      (integerp (* (/ (+ b (* 2 x c)) 3) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-4
     (implies (and (acl2-numberp b)
		   (acl2-numberp c)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* b (expt 3 (- n 1))))
		   (integerp (* (/ c x) (expt 3 (- n 1)))))
	      (integerp (* (/ (/ (- c (* 2 x b)) 3) x) (expt 3 n)))
	      )
     )
   )
  )


 (local
  (skip-proofs
   (defthmd lemma-5
     (implies (and (acl2-numberp a)
		   (acl2-numberp b)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ a x) (expt 3 (- n 1))))
		   (integerp (* b (expt 3 (- n 1)))))
	      (integerp (* (/ (/ (- a (* 2 x b)) 3) x) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-6
     (implies (and (acl2-numberp a)
		   (acl2-numberp b)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ a x) (expt 3 (- n 1))))
		   (integerp (* b (expt 3 (- n 1)))))
	      (integerp (* (/ (+ b (* 2 x a)) 3) (expt 3 n)))
	      )
     )
   )
  )


 (local
  (skip-proofs
   (defthmd lemma-7
     (implies (and (acl2-numberp c)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ c x) (expt 3 (- n 1)))))
	      (integerp (* (/ c x) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-8
     (implies (and (acl2-numberp a)
		   (acl2-numberp b)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ a x) (expt 3 (- n 1))))
		   (integerp (* b (expt 3 (- n 1)))))
	      (integerp (* (/ (/ (+ a (* 2 x b)) 3) x) (expt 3 n)))
	      )
     )
   )
  )

 (local
  (skip-proofs
   (defthmd lemma-9
     (implies (and (acl2-numberp a)
		   (acl2-numberp b)
		   (equal x (acl2-sqrt 2))
		   (integerp n)
		   (>= n 0)
		   (integerp (* (/ a x) (expt 3 (- n 1))))
		   (integerp (* b (expt 3 (- n 1)))))
	      (integerp (* (/ (- b (* 2 x a)) 3) (expt 3 n)))
	      )
     )
   )
  )
 

 (defthmd lemma-int
   (implies (and (acl2-numberp a)
		 (acl2-numberp b)
		 (acl2-numberp c)
		 (equal x (acl2-sqrt 2))
		 (integerp n)
		 (>= n 0)
		 (integerp (* (/ a x) (expt 3 (- n 1))))
		 (integerp (* b (expt 3 (- n 1))))
		 (integerp (* (/ c x) (expt 3 (- n 1))))
		 )
	    (and (integerp (* (/ a x) (expt 3 n)))
		 (integerp (* (/ (- b (* 2 x c)) 3) (expt 3 n)))
		 (integerp (* (/ (/ (+ (* 2 x b) c) 3) x) (expt 3 n)))
		 (integerp (* (/ (+ b (* 2 x c)) 3) (expt 3 n)))
		 (integerp (* (/ (/ (- c (* 2 x b)) 3) x) (expt 3 n)))
		 (integerp (* (/ (/ (- a (* 2 x b)) 3) x) (expt 3 n)))
		 (integerp (* (/ (+ b (* 2 x a)) 3) (expt 3 n)))
		 (integerp (* (/ c x) (expt 3 n)))
		 (integerp (* (/ (/ (+ a (* 2 x b)) 3) x) (expt 3 n)))
		 (integerp (* (/ (- b (* 2 x a)) 3) (expt 3 n)))
		 ))
   :hints (("Goal"
	    :use ((:instance lemma-0)
		  (:instance lemma-1)
		  (:instance lemma-2)
		  (:instance lemma-3)
		  (:instance lemma-4)
		  (:instance lemma-5)
		  (:instance lemma-6)
		  (:instance lemma-7)
		  (:instance lemma-8)
		  (:instance lemma-9)
		  )
	    :in-theory nil
	    ))
   )
 )


(defthmd sqrt-2-lemmas
  (and (acl2-numberp (acl2-sqrt 2))
       (i-limited (acl2-sqrt 2))
       (realp (acl2-sqrt 2))
       (> (acl2-sqrt 2) 1)
       (not (equal (acl2-sqrt 2) 0)))
  :hints (("Goal"
	   :in-theory (disable acl2-sqrt)
	   ))
  )

(defthmd word-len-lemma
  (implies (reducedwordp w)
	   (and (integerp (len w))
		(>= (len w) 0)
		(if (consp w)
		    (and (equal (- (len w) 1) (len (cdr w)))
			 (equal (len (cdr w)) (- (len w) 1)))
		  0)
		)
	   )
  )

(encapsulate
 ()

 (local
  (defthm rotation-values-ind-case
    (IMPLIES
     (AND (CONSP W)
	  (IMPLIES (AND (REDUCEDWORDP (CDR W))
			(EQUAL X (ACL2-SQRT 2)))
		   (AND (INTEGERP (INT-POINT (M-* (ROTATION (CDR W) X) (POINT-P))
					     0 0 (LEN (CDR W))
					     X))
			(INTEGERP (INT-POINT (M-* (ROTATION (CDR W) X) (POINT-P))
					     1 0 (LEN (CDR W))
					     X))
			(INTEGERP (INT-POINT (M-* (ROTATION (CDR W) X) (POINT-P))
					     2 0 (LEN (CDR W))
					     X)))))
     (IMPLIES (AND (REDUCEDWORDP W)
		   (EQUAL X (ACL2-SQRT 2)))
	      (AND (INTEGERP (INT-POINT (M-* (ROTATION W X) (POINT-P))
					0 0 (LEN W)
					X))
		   (INTEGERP (INT-POINT (M-* (ROTATION W X) (POINT-P))
					1 0 (LEN W)
					X))
		   (INTEGERP (INT-POINT (M-* (ROTATION W X) (POINT-P))
					2 0 (LEN W)
					X)))))
    :hints (("Goal"
	     :cases ((EQUAL (CAR W) (WA))
		     (EQUAL (CAR W) (WA-inv))
		     (EQUAL (CAR W) (WB))
		     (EQUAL (CAR W) (WB-inv))
		     )
	     :use (
		   (:instance word-len-lemma (w w))
		   (:instance sqrt-2-lemmas)
		   (:instance reduced-cdr (x w))
		   (:instance rotation-= (w w) (x x))
		   (:instance associativity-of-m-*
			      (m1 (a-inv-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (b-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (b-inv-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance associativity-of-m-*
			      (m1 (a-rotation x))
			      (m2 (rotation (cdr w) x))
			      (m3 (point-p)))
		   (:instance word-len-lemma (w w))
		   (:instance reduced-cdr (x w))
		   (:instance acl2-nump-rot (x x) (name '$arg1) (w (cdr w)))
		   (:instance m-*-rotation-point-dim (w (cdr w)) (name '$arg1))
		   (:instance rotation-values-ind-case-lemma1
			      (name '$arg1)
			      (x x)
			      (m1 (M-* (ROTATION (CDR W) X) (POINT-P)))
			      )
		   (:instance lemma-int
			      (x x)
			      (n (len w))
			      (a (aref2 '$arg1 (M-* (ROTATION (CDR W) X) (POINT-P)) 0 0))
			      (b (aref2 '$arg1 (M-* (ROTATION (CDR W) X) (POINT-P)) 1 0))
			      (c (aref2 '$arg1 (M-* (ROTATION (CDR W) X) (POINT-P)) 2 0)))
		   (:instance int-point
			      (a (M-* (ROTATION w (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 0)
			      (j 0)
			      (n (len w))
			      (x x))
		   (:instance int-point
			      (a (M-* (ROTATION w (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 1)
			      (j 0)
			      (n (len w))
			      (x x))
		   (:instance int-point
			      (a (M-* (ROTATION w (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 2)
			      (j 0)
			      (n (len w))
			      (x x))
		   (:instance int-point
			      (a (M-* (ROTATION (cdr w) (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 0)
			      (j 0)
			      (n (len (cdr w)))
			      (x x))
		   (:instance int-point
			      (a (M-* (ROTATION (cdr w) (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 1)
			      (j 0)
			      (n (len (cdr w)))
			      (x x))
		   (:instance int-point
			      (a (M-* (ROTATION (cdr w) (ACL2-SQRT 2))
				      (POINT-P)))
			      (i 2)
			      (j 0)
			      (n (len (cdr w)))
			      (x x))
		   )
	     :in-theory nil
	     :do-not-induct t
	     )
	    )
    )
  )

 (defthmd rotation-values
   (implies (and (reducedwordp w)
		 (equal x (acl2-sqrt 2)))
	    (and (integerp (int-point (m-* (rotation w x) (point-p)) 0 0 (len w) x))
		 (integerp (int-point (m-* (rotation w x) (point-p)) 1 0 (len w) x))
		 (integerp (int-point (m-* (rotation w x) (point-p)) 2 0 (len w) x))
		 )
	    )
   :hints (("Subgoal *1/1"
	    :use ((:instance rotation-values-ind-case))
	    :in-theory (disable acl2-sqrt)
	    ))
   )
 )




;; (defthm a-rotation-equiv
;;   (equal (a-rotation x)
;; 	 `((:header :dimensions (3 3)
;; 		    :maximum-length 10)
;; 	   ((0 . 0) . 1)
;; 	   ((0 . 1) . 0)
;; 	   ((0 . 2) . 0)
;; 	   ((1 . 0) . 0)
;; 	   ((1 . 1) . 1/3)
;; 	   ((1 . 2) . ,(* -2/3 x) )
;; 	   ((2 . 0) . 0)
;; 	   ((2 . 1) . ,(* 2/3 x) )
;; 	   ((2 . 2) . 1/3)
;; 	   )
;; 	 )

;;   )

;; (defthm a-inv-rotation-equiv
;;   (equal (a-inv-rotation x)
;; 	 `((:header :dimensions (3 3)
;; 		    :maximum-length 10)
;; 	   ((0 . 0) . 1)
;; 	   ((0 . 1) . 0)
;; 	   ((0 . 2) . 0)
;; 	   ((1 . 0) . 0)
;; 	   ((1 . 1) . 1/3)
;; 	   ((1 . 2) . ,(* 2/3 x) )
;; 	   ((2 . 0) . 0)
;; 	   ((2 . 1) . ,(* -2/3 x) )
;; 	   ((2 . 2) . 1/3) 
;; 	   )
;; 	 )

;;   )

;; (defthm b-rotation-equiv
;;   (equal (b-rotation x)
;; 	 `((:header :dimensions (3 3)
;; 		    :maximum-length 10)
;; 	   ((0 . 0) . 1/3)
;; 	   ((0 . 1) . ,(* -2/3 x) )
;; 	   ((0 . 2) . 0)
;; 	   ((1 . 0) . ,(* 2/3 x) )
;; 	   ((1 . 1) . 1/3)
;; 	   ((1 . 2) . 0)
;; 	   ((2 . 0) . 0)
;; 	   ((2 . 1) . 0)
;; 	   ((2 . 2) . 1)    
;; 	   )
;; 	 )

;;   )

;; (defthm b-inv-rotation-equiv
;;   (equal (b-inv-rotation x)
;; 	 `((:header :dimensions (3 3)
;; 		    :maximum-length 10)
;; 	   ((0 . 0) . 1/3)
;; 	   ((0 . 1) . ,(* 2/3 x) )
;; 	   ((0 . 2) . 0)
;; 	   ((1 . 0) . ,(* -2/3 x) )
;; 	   ((1 . 1) . 1/3)
;; 	   ((1 . 2) . 0)
;; 	   ((2 . 0) . 0)
;; 	   ((2 . 1) . 0)
;; 	   ((2 . 2) . 1)
;; 	   )
;; 	 )

;;   )

;; )


;; (defthm array2p-funs
;;   (implies (symbolp x)
;; 	   (and (array2p x (id-rotation))
;; 		(array2p x (a-rotation))
;; 		(array2p x (a-inv-rotation))
;; 		(array2p x (b-rotation))
;; 		(array2p x (b-inv-rotation))
;; 		(array2p x (point-p))
;; 		)
;; 	   )
;;   :hints (("Goal"
;; 	   :in-theory (enable array2p)
;; 	   ))
;;   )







;; (defthm acl2-numberp-sqrt-2
;;   (and (acl2-numberp (acl2-sqrt 2))
;;        (i-limited (acl2-sqrt 2))
;;        (acl2-numberp (* -2/3 (acl2-sqrt 2)))
;;        (realp (* -2/3 (acl2-sqrt 2)))
;;        (realp (* 2/3 (acl2-sqrt 2)))
;;        (realp (acl2-sqrt 2))
;;        (equal (* (acl2-sqrt 2) (acl2-sqrt 2)) 2)
;;        (> (acl2-sqrt 2) 1)
;;        (equal (/ (acl2-sqrt 2) (acl2-sqrt 2)) 1)
;;        (equal (/ 0 (acl2-sqrt 2)) 0)
;;        (not (equal (acl2-sqrt 2) 0)))
;;   )


;; (defun compress21 (name l n i j default)
;;   (declare (xargs :guard (and (array2p name l)
;;                               (integerp n)
;;                               (integerp i)
;;                               (integerp j)
;;                               (<= n i)
;;                               (<= 0 j))
;;                   :measure (nfix (- i n))))

;;   (cond ((zp (- i n)) nil)
;;         (t (append (compress211 name l n 0 j default)
;;                    (compress21 name l (+ n 1) i j default)))))


;; (defthm compress213


;;   (encapsulate
;;    ()
;;    (local (include-book "arithmetic-5/top" :dir :system))

;;    (local
;;     (defthm compress21-lemma
;;       (implies (and (syntaxp (natp i))
;; 		    (syntaxp (natp n))
;; 		    )
;; 	       (equal (compress21 name l n i j default)
;; 		      (if (zp (- i n)) nil
;; 			(append (compress211 name l n 0 j default)
;; 				(compress21 name l (+ n 1) i j default)))))
;;       :hints (("Goal"
;; 	       :in-theory (enable compress21 compress211)
;; 	       ))		 
;;       )

;;     (defthm compress213
;;       )


;;     (local
;;      (defthm lemma1
;;        (implies (acl2-numberp x)
;; 		(equal  (COMPRESS21 '$ARG2
;; 				    (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						     :MAXIMUM-LENGTH 10)
;; 					   '((0 . 0) . 1)
;; 					   '((0 . 1) . 0)
;; 					   '((0 . 2) . 0)
;; 					   '((1 . 0) . 0)
;; 					   '((1 . 1) . 1/3)
;; 					   (CONS '(1 . 2) (* -2/3 x))
;; 					   '((2 . 0) . 0)
;; 					   (CONS '(2 . 1) (* 2/3 x))
;; 					   '(((2 . 2) . 1/3)))
;; 				    0 3 3 NIL)

;; 			`(((0 . 0) . 1)
;; 			  ((0 . 1) . 0)
;; 			  ((0 . 2) . 0)
;; 			  ((1 . 0) . 0)
;; 			  ((1 . 1) . 1/3)
;; 			  ((1 . 2) . ,(* -2/3 x) )
;; 			  ((2 . 0) . 0)
;; 			  ((2 . 1) . ,(* 2/3 x) )
;; 			  ((2 . 2) . 1/3)))
;; 		)
;;        :hints (("Goal"
;; 		:in-theory (enable compress21 compress211)
;; 		))

;;        )
;;      )


;;     )

;;    (local (in-theory (disable acl2-sqrt)))
;;    (defthmd funs-lemmas-1
;;      (m-= (m-* (id-rotation) (a-rotation x)) (a-rotation x))
;;      :hints (("Goal"
;; 	      :in-theory (enable 
;; 			  alist2p array2p aset2 aref2 compress2 header
;; 			  dimensions maximum-length default
;; 			  matrixp compress21
;; 			  m-=
;; 			  m-0
;; 			  m-1
;; 			  m-trans
;; 			  m-unary--
;; 			  s-*
;; 			  m-binary-+
;; 			  m-binary-*
;; 			  m-/
;; 			  m-singularp
;; 			  M-BINARY-*-ROW-1
;; 			  m-=-row-1)
;; 	      )
;; 	     ;; ("Subgoal 2.3"
;; 	     ;;  :use (:definition compress21)
;; 	     ;;  )
;; 	     )
;;      )
;;    )


;;   :hints (("Goal"
;; 	   :use ((:instance acl2-numberp-sqrt-2)
;; 		 )
;; 	   :in-theory (enable m-* alist2p m-= dimensions header compress2 default compress21)
;; 	   )

;; 	  ("Subgoal 3"
;; 	   :use ((:instance array2p-funs (x '$arg1))
;; 		 (:instance array2p-funs (x '$arg2))
;; 		 (:instance COMPRESS21
;; 			    (name '$ARG2)
;; 			    (l (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						:MAXIMUM-LENGTH 15)
;; 				      '((0 . 0) . 1)
;; 				      '((0 . 1) . 0)
;; 				      '((0 . 2) . 0)
;; 				      '((1 . 0) . 0)
;; 				      '((1 . 1) . 1/3)
;; 				      (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 				      '((2 . 0) . 0)
;; 				      (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 				      '(((2 . 2) . 1/3))))
;; 			    (n 0)
;; 			    (i 3)
;; 			    (j 3)
;; 			    (default NIL)
;; 			    ))
;; 					; :in-theory (enable compress2 compress21 alistp header dimensions maximum-length default)
;; 	   )

;; 	  ("Subgoal 2"
;; 	   :use ((:instance acl2-numberp-sqrt-2)
;; 		 (:instance COMPRESS21
;; 			    (name '$ARG2)
;; 			    (l (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						:MAXIMUM-LENGTH 15)
;; 				      '((0 . 0) . 1)
;; 				      '((0 . 1) . 0)
;; 				      '((0 . 2) . 0)
;; 				      '((1 . 0) . 0)
;; 				      '((1 . 1) . 1/3)
;; 				      (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 				      '((2 . 0) . 0)
;; 				      (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 				      '(((2 . 2) . 1/3))))
;; 			    (n 0)
;; 			    (i 3)
;; 			    (j 3)
;; 			    (default NIL)
;; 			    )

;; 		 (:instance COMPRESS21
;; 			    (name '$ARG1)
;; 			    (l (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						:MAXIMUM-LENGTH 10
;; 						:DEFAULT 0
;; 						:NAME MATRIX-PRODUCT)
;; 				      '((2 . 2) . 1/3)
;; 				      (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 				      '((2 . 0) . 0)
;; 				      (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 				      '(((1 . 1) . 1/3)
;; 					((1 . 0) . 0)
;; 					((0 . 2) . 0)
;; 					((0 . 1) . 0)
;; 					((0 . 0) . 1))))
;; 			    (n 0)
;; 			    (i 3)
;; 			    (j 3)
;; 			    (default 0))

;; 		 (:instance m-=-row-1
;; 			    (m1 (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						 :MAXIMUM-LENGTH 10
;; 						 :DEFAULT 0
;; 						 :NAME MATRIX-PRODUCT)
;; 				       '((0 . 0) . 1)
;; 				       '((1 . 1) . 1/3)
;; 				       (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 				       (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 				       '(((2 . 2) . 1/3))))
;; 			    (m2            (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 							    :MAXIMUM-LENGTH 15)
;; 						  '((0 . 0) . 1)
;; 						  '((0 . 1) . 0)
;; 						  '((0 . 2) . 0)
;; 						  '((1 . 0) . 0)
;; 						  '((1 . 1) . 1/3)
;; 						  (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 						  '((2 . 0) . 0)
;; 						  (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 						  '(((2 . 2) . 1/3))))
;; 			    (m 2)
;; 			    (n 2))

;; 		 )
;; 	   :in-theory (enable aref2 compress21 m-= default header)

;; 	   )

;; 	  ("Subgoal 1"

;; 	   :use (
;; 		 (:instance COMPRESS21
;; 			    (name '$ARG2)
;; 			    (l (LIST* '(:HEADER :DIMENSIONS (3 3)
;; 						:MAXIMUM-LENGTH 15)
;; 				      '((0 . 0) . 1)
;; 				      '((0 . 1) . 0)
;; 				      '((0 . 2) . 0)
;; 				      '((1 . 0) . 0)
;; 				      '((1 . 1) . 1/3)
;; 				      (CONS '(1 . 2) (* -2/3 (ACL2-SQRT 2)))
;; 				      '((2 . 0) . 0)
;; 				      (CONS '(2 . 1) (* 2/3 (ACL2-SQRT 2)))
;; 				      '(((2 . 2) . 1/3))))
;; 			    (n 0)
;; 			    (i 3)
;; 			    (j 3)
;; 			    (default NIL)
;; 			    )
;; 		 )

;; 	   :in-theory (enable compress21)
;; 	   )	   
;; 	  )
;;   )
;; )








;; (defthm rotation-implies-lemma
;;   (equal (/ (aref2 '$arg1
;; 		   '((:HEADER :DIMENSIONS (3 1)
;; 			      :MAXIMUM-LENGTH 4
;; 			      :DEFAULT 0
;; 			      :NAME MATRIX-PRODUCT)
;; 		     ((2 . 0) . 0)
;; 		     ((1 . 0) . 1)
;; 		     ((0 . 0) . 0))
;; 		   0 0) (acl2-sqrt 2))
;; 	 0)

;;   )

;; (defthm rotation-implies-lemma2
;;   (equal (INT-POINT '((:HEADER :DIMENSIONS (3 1)
;; 			       :MAXIMUM-LENGTH 4
;; 			       :DEFAULT 0
;; 			       :NAME MATRIX-PRODUCT)
;; 		      ((2 . 0) . 0)
;; 		      ((1 . 0) . 1)
;; 		      ((0 . 0) . 0))
;; 		    0 0 0)
;; 	 0)

;;   :hints (("Goal"
;; 	   :use ((:instance rotation-implies-lemma)
;; 		 (:instance int-point
;; 			    (x '((:HEADER :DIMENSIONS (3 1)
;; 					  :MAXIMUM-LENGTH 4
;; 					  :DEFAULT 0
;; 					  :NAME MATRIX-PRODUCT)
;; 				 ((2 . 0) . 0)
;; 				 ((1 . 0) . 1)
;; 				 ((0 . 0) . 0)))
;; 			    (i 0)
;; 			    (j 0)
;; 			    (n 0)
;; 			    ))
;; 	   :in-theory nil

;; 	   ))

;;   )

;; (encapsulate
;;  ()
;;  (local (include-book "arithmetic-5/top" :dir :system))


;; 					;(integerp (int-point (m-* (rotation w) (point-p)) 0 0 (len w)))
;; 					;(integerp (int-point (m-* (rotation w) (point-p)) 0 0 (len w)))))

;;  :hints (
;; 	 ("Goal"
;; 					; :use ((:instance acl2-numberp-sqrt-2)
;; 					;	  (:instance rotation-implies-lemma)
;; 					;	  (:instance rotation-implies-lemma2)
;; 					;)
;; 					;:in-theory nil
;; 	  )
;; 	 ("Subgoal 9"
;; 	  :use (;(:instance acl2-numberp-sqrt-2)
;; 		(:instance rotation-implies-lemma2)
;; 		)
;; 	  :in-theory nil
;; 	  )

;; 	 )
;;  )
;; )

;; ("Subgoal *1/2"
;;  :use ((:instance acl2-numberp-sqrt-2)
;;        (:instance int-point
;; 		  (x '((:HEADER :DIMENSIONS (3 1)
;; 				:MAXIMUM-LENGTH 4
;; 				:DEFAULT 0
;; 				:NAME MATRIX-PRODUCT)
;; 		       ((2 . 0) . 0)
;; 		       ((1 . 0) . 1)
;; 		       ((0 . 0) . 0)))
;; 		  (i 0)
;; 		  (j 0)
;; 		  (n 0)

;; 		  )
;;        )
;;  )
;; )
;; )
;; )

;; (:instance int-point
;; 	   (x '((:HEADER :DIMENSIONS (3 1)
;; 			 :MAXIMUM-LENGTH 4
;; 			 :DEFAULT 0
;; 			 :NAME MATRIX-PRODUCT)
;; 		((2 . 0) . 0)
;; 		((1 . 0) . 1)
;; 		((0 . 0) . 0)))
;; 	   (i 0)
;; 	   (j 0)
;; 	   (n 0))
;; )
;; :in-theory (enable aref2 int-point m-*)
;; ))

;; )














;; ;; (defthmd acl2-numberp-2-1
;; ;;   (acl2-numberp (aref2 'delta (a-rotation) 1 2))
;; ;;   )

;; 					;(in-theory (disable a-rotation))

;; (encapsulate
;;  ()

;; 					;(local (in-theory (disable aref2)))

;;  (defthmd funs-lemmas-1
;;    (m-= (m-* (id-rotation) (a-rotation)) (a-rotation))
;;    )
;;  :hints (("Goal"
;; 	  :use ((:instance acl2-numberp-sqrt-2))
;; 	  ))
;;  )
;; :hints (("Goal"
;; 	 :use ((:instance acl2-numberp-sqrt-2))
;; 	 :in-theory (disable a-rotation id-rotation)
;; 	 )
;; 	("Subgoal 3"
;; 	 :in-theory (enable m-binary-*-row-1 dot compress21 )
;; 	 )
;; 	)
;; )
;; )
;; (m-= (m-* (id-rotation) (a-rotation)) (a-rotation)))
;; :hints (("Goal"
;; 	 :use ((:instance acl2-numberp-sqrt-2))
;; 	 :in-theory (enable array2p m-= m-* M-BINARY-*-ROW-1 M-BINARY-*-ROW dot compress2 aref2 header alist2p dimensions compress21 alistp default)
;; 	 ))
;; )
;; )
;; (m-= (m-* (id-rotation) (a-inv-rotation)) (a-inv-rotation))
;; (m-= (m-* (id-rotation) (b-rotation)) (b-rotation))
;; (m-= (m-* (id-rotation) (b-inv-rotation)) (b-inv-rotation))
;; (m-= (m-* (a-rotation) (id-rotation)) (a-rotation))
;; (m-= (m-* (a-inv-rotation) (id-rotation)) (a-inv-rotation))
;; (m-= (m-* (b-rotation) (id-rotation)) (b-rotation))
;; (m-= (m-* (b-inv-rotation) (id-rotation)) (b-inv-rotation))
;; )

;; :hints (("Goal"
;; 	 :use ((:instance acl2-numberp-sqrt-2)
;; 	       (:instance aref2-rots (x '$arg1))
;; 	       (:instance aref2-rots (x '$arg))
;; 	       (:instance aref2-rots (x '$arg2)))
;; 	 :in-theory (enable array2p m-= m-* M-BINARY-*-ROW-1 M-BINARY-*-ROW compress2)
;; 	 ))
;; )
;; )



;; ("Subgoal 8"
;;  :use (:instance acl2-numberp-sqrt-2)
;;  :in-theory (enable array2p m-= m-* aref2  M-BINARY-*-ROW-1 M-BINARY-*-ROW alistp dimensions compress2 assoc-keyword alist2p)
;;  )
;; ("Subgoal 7"
;;  :use (:instance acl2-numberp-sqrt-2)
;;  :in-theory (enable array2p m-= m-* aref2  M-BINARY-*-ROW-1 M-BINARY-*-ROW alistp dimensions compress2 assoc-keyword alist2p)
;;  )

;; ("Subgoal 16"
;;  :use ((:instance acl2-numberp-sqrt-2)
;;        (:instance acl2-numberp-sqrt-2-2))
;;  :in-theory (enable array2p m-= m-* aref2  M-BINARY-*-ROW-1 M-BINARY-*-ROW alistp dimensions compress2 assoc-keyword alist2p)
;;  )

;; )
;; )
;; (m-= (m-* (a-inv-rotation) (a-rotation)) (id-rotation))
;; (m-= (m-* (a-rotation) (a-inv-rotation)) (id-rotation))
;; (m-= (m-* (b-rotation) (b-inv-rotation)) (id-rotation))
;; (m-= (m-* (b-inv-rotation) (b-rotation)) (id-rotation))
;; )
;; :hints (("Goal"
;; 	 :use (:instance acl2-numberp-sqrt-2)
;; 	 :in-theory (enable array2p m-= m-* aref2  M-BINARY-*-ROW-1 M-BINARY-*-ROW alistp dimensions compress2 assoc-keyword alist2p)
;; 	 )

;; 	)

;; )

;; (defthmd fix-lemma
;;   (equal (+ 1/9 (fix (

;; 		      )

;; 		     (defthmd funs-lemma1
;; 		       (m-= (m-* (a-rotation) (a-inv-rotation)) (id-rotation))
;; 		       :hints (("Goal"
;; 				:use (:instance acl2-numberp-sqrt-2)
;; 				:in-theory (disable acl2-sqrt)
;; 				))
;; 		       )


;; 		     (defthm rotation-implies
;; 		       (implies (reducedwordp w)
;; 				(and (integerp (* (/ (aref2 'delta (m-* (rotation w) (point-p)) 0 0) (acl2-sqrt 2)) (expt 3 (len w))))
;; 				     (integerp (* (aref2 'delta (m-* (rotation w) (point-p)) 1 0) (expt 3 (len w))))
;; 				     (integerp (* (/ (aref2 'delta (m-* (rotation w) (point-p)) 2 0) (acl2-sqrt 2)) (expt 3 (len w))))
;; 				     )
;; 				)
;; 		       )


;; 		     (defthm lemma1
;; 		       (implies (i-limited x)
;; 				(acl2-numberp x))
;; 		       )







;; (defthmd acl2-numberp-sqrt-2-1
;;   (acl2-numberp (* -2/3 (acl2-sqrt 2)))
;;   )

;; (defthm aref2-rots
;;   (implies (symbolp x)
;; 	   (and (equal (aref2 x (a-rotation) 0 0) 1)
;; 		(equal (aref2 x (a-rotation) 0 1) 0)
;; 		(equal (aref2 x (a-rotation) 0 2) 0)
;; 		(equal (aref2 x (a-rotation) 1 0) 0)
;; 		(equal (aref2 x (a-rotation) 1 1) 1/3)
;; 		(equal (aref2 x (a-rotation) 2 0) 0)
;; 		(equal (aref2 x (a-rotation) 2 2) 1/3)
;; 		(equal (aref2 x (a-inv-rotation) 0 0) 1)
;; 		(equal (aref2 x (a-inv-rotation) 0 1) 0)
;; 		(equal (aref2 x (a-inv-rotation) 0 2) 0)
;; 		(equal (aref2 x (a-inv-rotation) 1 0) 0)
;; 		(equal (aref2 x (a-inv-rotation) 1 1) 1/3)
;; 		(equal (aref2 x (a-inv-rotation) 2 0) 0)
;; 		(equal (aref2 x (a-inv-rotation) 2 2) 1/3)


;; 		(equal (aref2 x (b-rotation) 0 0) 1/3)
;; 		(equal (aref2 x (b-rotation) 0 2) 0)
;; 		(equal (aref2 x (b-rotation) 1 1) 1/3)
;; 		(equal (aref2 x (b-rotation) 1 2) 0)
;; 		(equal (aref2 x (b-rotation) 2 0) 0)
;; 		(equal (aref2 x (b-rotation) 2 1) 0)
;; 		(equal (aref2 x (b-rotation) 2 2) 1)

;; 		(equal (aref2 x (b-inv-rotation) 0 0) 1/3)
;; 		(equal (aref2 x (b-inv-rotation) 0 2) 0)
;; 		(equal (aref2 x (b-inv-rotation) 1 1) 1/3)
;; 		(equal (aref2 x (b-inv-rotation) 1 2) 0)
;; 		(equal (aref2 x (b-inv-rotation) 2 0) 0)
;; 		(equal (aref2 x (b-inv-rotation) 2 1) 0)
;; 		(equal (aref2 x (b-inv-rotation) 2 2) 1)

;; 		(equal (aref2 x (a-rotation) 1 2) (* -2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (a-rotation) 2 1) (* 2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (a-inv-rotation) 1 2) (* 2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (a-inv-rotation) 2 1) (* -2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (b-rotation) 0 1) (* -2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (b-rotation) 1 0) (* 2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (b-inv-rotation) 0 1) (* 2/3 (acl2-sqrt 2)))
;; 		(equal (aref2 x (b-inv-rotation) 1 0) (* -2/3 (acl2-sqrt 2)))
;; 		))
;;   :hints (("Goal"
;; 	   :use (:instance acl2-numberp-sqrt-2)
;; 	   :in-theory (enable array2p aref2)
;; 	   ))
;;   )


;;  (and (or (eq key :header)
;;                            (and (consp key)
;;                                 (let ((i1 (car key))
;;                                       (j1 (cdr key)))
;;                                   (and (integerp i1)
;;                                        (integerp j1)
;;                                        (integerp i)
;;                                        (integerp j)
;;                                        (>= i1 0)
;;                                        (< i1 i)
;;                                        (>= j1 0)
;;                                        (< j1 j))))))

;; (and (consp (caar (cdr (defarray))))
;;                                 (let ((i1 (car (caar (cdr (defarray)))))
;;                                       (j1 (cdr (caar (cdr (defarray))))))
;;                                   (and (integerp i1)
;;                                        (integerp j1)
;;                                        (integerp 3)
;;                                        (integerp 3)
;;                                        (>= i1 0)
;;                                        (< i1 3)
;;                                        (>= j1 0)
;;                                        (< j1 3))))


;; (defun bounded-integer-alistp2 (l i j)
;;   (declare (xargs :guard t))
;;   (cond ((atom l) (null l))
;;         (t (and (consp (car l))
;;                 (let ((key (caar l)))
;;                   (and (or (eq key :header)
;;                            (and (consp key)
;;                                 (let ((i1 (car key))
;;                                       (j1 (cdr key)))
;;                                   (and (integerp i1)
;;                                        (integerp j1)
;;                                        (integerp i)
;;                                        (integerp j)
;;                                        (>= i1 0)
;;                                        (< i1 i)
;;                                        (>= j1 0)
;;                                        (< j1 j)))))))
;;                 (bounded-integer-alistp2 (cdr l) i j))




