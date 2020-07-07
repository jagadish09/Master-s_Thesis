(include-book "std/typed-lists/character-listp" :dir :system)
(include-book "std/lists/top" :dir :system)

(defun wa()
  #\a
  )

(defun wa-inv()
  #\b
  )

(defun wb()
  #\c
  )

(defun wb-inv()
  #\d
  )


(defthmd abcd-chars
  (and (characterp (wa))
       (characterp (wa-inv))
       (characterp (wb))
       (characterp (wb-inv)))
  )

(defun weak-wordp (w)
       (cond ((atom w) (equal w nil))
	     (t (and (or (equal (car w) (wa))
			 (equal (car w) (wa-inv))
			 (equal (car w) (wb))
			 (equal (car w) (wb-inv)))
		     (weak-wordp (cdr w))))))


(defun wordp(w letter)
  (cond ((atom w) (equal w nil))
	((equal letter (wa)) (let ((firstw (car w)) (restw (cdr w)))
			       (and (or (equal firstw (wa))
					(equal firstw (wb))
					(equal firstw (wb-inv)))
				    (wordp restw firstw))))
	((equal letter (wa-inv)) (let ((firstw (car w)) (restw (cdr w)))
				   (and (or (equal firstw (wa-inv))
					    (equal firstw (wb))
					    (equal firstw (wb-inv)))
					(wordp restw firstw))))

	((equal letter (wb)) (let ((firstw (car w)) (restw (cdr w)))
			       (and (or (equal firstw (wa))
					(equal firstw (wa-inv))
					(equal firstw (wb)))
				    (wordp restw firstw))))
	((equal letter (wb-inv)) (let ((firstw (car w)) (restw (cdr w)))
				   (and (or (equal firstw (wa))
					    (equal firstw (wa-inv))
					    (equal firstw (wb-inv)))
					(wordp restw firstw))))))


(defun a-wordp(w)
  (and (equal (car w) (wa))
       (wordp (cdr w) (wa))))

(defun b-wordp(w)
  (and (equal (car w) (wb))
       (wordp (cdr w) (wb))))

(defun a-inv-wordp(w)
  (and (equal (car w) (wa-inv))
       (wordp (cdr w) (wa-inv))))

(defun b-inv-wordp(w)
  (and (equal (car w) (wb-inv))
       (wordp (cdr w) (wb-inv))))

(defthmd a-wordp-equivalent
  (implies (a-wordp a)
	   (and (not (a-inv-wordp a))
		(not (b-wordp a))
		(not (b-inv-wordp a))
		(not (equal a '()))))
  )

(defthmd b-wordp-equivalent
  (implies (b-wordp b)
	   (and (not (a-inv-wordp b))
		(not (a-wordp b))
		(not (b-inv-wordp b))
		(not (equal b '()))))
  )

(defthmd a-inv-wordp-equivalent
  (implies (a-inv-wordp a-inv)
	   (and (not (a-wordp a-inv))
		(not (b-wordp a-inv))
		(not (b-inv-wordp a-inv))
		(not (equal a-inv '()))))
  )

(defthmd b-inv-wordp-equivalent
  (implies (b-inv-wordp b-inv)
	   (and (not (b-wordp b-inv))
		(not (a-wordp b-inv))
		(not (a-inv-wordp b-inv))
		(not (equal b-inv '()))))
  )

(defun word-fix (w)
  (if (atom w)
      nil
    (let ((fixword (word-fix (cdr w))))
      (let ((w (cons (car w) fixword)))
	(cond ((equal fixword nil)
	       (list (car w)))
	      ((equal (car (cdr w)) (wa))
	       (if (equal (car w) (wa-inv))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wa-inv))
	       (if (equal (car w) (wa))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wb))
	       (if (equal (car w) (wb-inv))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wb-inv))
	       (if (equal (car w) (wb))
		   (cdr (cdr w))
		 w)))))))


(defun compose (x y)
  (word-fix (append x y))
  )

(defun reducedwordp (x)
  (or (a-wordp x)
      (a-inv-wordp x)
      (b-wordp x)
      (b-inv-wordp x)
      (equal x '()))
  )

(defthmd weak-wordp-equivalent
  (implies (weak-wordp x)
	   (reducedwordp (word-fix x))))

(encapsulate
 ()

 (local
  (defthm lemma
    (implies (or (a-wordp x)
		 (a-inv-wordp x)
		 (b-wordp x)
		 (b-inv-wordp x)
		 (equal x '()))
	     (weak-wordp x))))

 (defthm a-wordp=>weak-wordp
   (IMPLIES (a-wordp x)
	    (weak-wordp x)))

 (defthm b-wordp=>weak-wordp
   (IMPLIES (b-wordp x)
	    (weak-wordp x)))

 (defthm b-inv-wordp=>weak-wordp
   (IMPLIES (b-inv-wordp x)
	    (weak-wordp x)))

 (defthm a-inv-wordp=>weak-wordp
   (IMPLIES (a-inv-wordp x)
	    (weak-wordp x)))
 )

(encapsulate
 ()

 (local
  (defthm lemma
    (implies (or (a-wordp x)
		 (a-inv-wordp x)
		 (b-wordp x)
		 (b-inv-wordp x)
		 (equal x '()))
	     (equal (word-fix x) x))))

 (defthm word-fix=a-wordp
   (IMPLIES (a-wordp x)
	    (equal (word-fix x) x))
   )

 (defthm word-fix=a-inv-wordp
   (IMPLIES (a-inv-wordp x)
	    (equal (word-fix x) x))
   )

 (defthm word-fix=b-wordp
   (IMPLIES (b-wordp x)
	    (equal (word-fix x) x))
   )

 (defthm word-fix=b-inv-wordp
   (IMPLIES (b-inv-wordp x)
	    (equal (word-fix x) x))
   )
 )

(defthm prop-2.1-1
  (implies (and (a-wordp x)
		(equal y (compose '(#\b) x)))
	   (or (equal y '())
	       (a-wordp y)
	       (b-wordp y)
	       (b-inv-wordp y))))


(defthm prop-2.1-2
  (implies (and	(b-wordp x)
		(equal y (compose '(#\d) x)))
	   (or (equal y '())
	       (a-wordp y)
	       (b-wordp y)
	       (a-inv-wordp y))))


(encapsulate
 ()
 (local (include-book "std/lists/append" :dir :system))
 (local
  (defthm lemma
    (implies (reducedwordp x)
	     (weak-wordp x))
    )
  )

 (local
  (defthmd lemma1
    (implies (and (character-listp x)
 		  (characterp letter)
 		  (or (equal letter (wa))
 		      (equal letter (wb))
 		      (equal letter (wa-inv))
 		      (equal letter (wb-inv)))
 		  (wordp x letter))
 	     (or (equal x nil)
 		 (and (equal (car x) (wa)) (wordp (cdr x) (car x)))
 		 (and (equal (car x) (wa-inv)) (wordp (cdr x) (car x)))
 		 (and (equal (car x) (wb)) (wordp (cdr x) (car x)))
 		 (and (equal (car x) (wb-inv)) (wordp (cdr x) (car x))))
 	     )))

 (local
  (defthm lemma2
    (implies (and (character-listp x)
 		  (characterp letter)
		  (weak-wordp x)
 		  (or (equal letter (wa))
 		      (equal letter (wb))
 		      (equal letter (wa-inv))
 		      (equal letter (wb-inv)))
		  (endp x))
	     (wordp x letter))
    ))

  (local
  (defthm lemma3
    (implies (and (character-listp x)
 		  (characterp letter)
		  (weak-wordp x)
		  (not (endp x))
 		  (or (equal letter (wa))
 		      (equal letter (wb))
 		      (equal letter (wa-inv))
 		      (equal letter (wb-inv)))
		  (wordp (cdr x) letter))
	     (wordp x letter))
    ))
 

 ;; (local
 ;;  (defthm lemma3
 ;;    (implies (and (character-listp x)
 ;; 		  (character-listp y)
 ;; 		  (reducedwordp x)
 ;; 		  (reducedwordp y))
 ;; 	     (weak-wordp (append x y)))
 ;;    :hints (("Goal"
 ;; 	     :use ((:instance lemma (x x))
 ;; 		   (:instance lemma (x y))))


 ;; 	    ("Subgoal 16"
 ;; 	     :use ((:instance lemma1(x (cdr x)))
 ;; 		   (:instance lemma1(x (cdr y))))
 ;; 	     )
 ;; 	    ("Subgoal 16.12.1.1''"
 ;; 	     :induct t
 ;; 	     :use ((:instance lemma1 (x x4)))
 ;; 	     )
 ;; 	    )
 ;;    )
 ;;  )
 )


































































































(defthm coro-2.2-1
  (implies (and (reducedwordp x)
		(a-wordp w)
		(equal y (compose '(#\b) w)))
	   (or (equal y x)
	       (a-inv-wordp x)))

  :hints (("Goal"
	   :use ((:instance weak-wordp-equivalent)
		 (:instance prop-2.1-1))
	   ))
  )


















































(defun a-inv-wordp(w)
  (and (character-listp w)
       (let ((firstw (car w)) (restw (cdr w)))
	 (and (equal firstw (wa-inv))
	      (wordp restw (wa-inv))))))

(defun b-wordp(w)
  (and (character-listp w)
       (let ((firstw (car w)) (restw (cdr w)))
	 (and (equal firstw (wb))
	      (wordp restw (wb))))))

(defun b-inv-wordp(w)
  (and (character-listp w)
       (let ((firstw (car w)) (restw (cdr w)))
	 (and (equal firstw (wb-inv))
	      (wordp restw (wb-inv))))))


(defthmd a-wordp-equivalent
  (implies (and ;(character-listp a)
		(a-wordp a))
	   (and (not (a-inv-wordp a))
		(not (b-wordp a))
		(not (b-inv-wordp a))
		(not (equal a '()))))
  )



(defthmd a-wordp-equivalent-1
  (implies ;(and (character-listp a)
		(a-wordp a)
	   (and (not (a-inv-wordp a))
		(not (b-wordp a))
		(not (b-inv-wordp a))
		(not (equal a '()))))
  )


(defthmd b-wordp-equivalent
  (implies (and (character-listp b)
		(b-wordp b))
	   (and (not (a-inv-wordp b))
		(not (a-wordp b))
		(not (b-inv-wordp b))
		(not (equal b '()))))
  )

(defthmd a-inv-wordp-equivalent
  (implies (and (character-listp a-inv)
		(a-inv-wordp a-inv))
	   (and (not (a-wordp a-inv))
		(not (b-wordp a-inv))
		(not (b-inv-wordp a-inv))
		(not (equal a-inv '()))))
  )

(defthmd b-inv-wordp-equivalent
  (implies (and (character-listp b-inv)
		(b-inv-wordp b-inv))
	   (and (not (b-wordp b-inv))
		(not (a-wordp b-inv))
		(not (a-inv-wordp b-inv))
		(not (equal b-inv '()))))
  )


(defun word-fix (w)
  (if (atom w)
      nil
    (let ((fixword (word-fix (cdr w))))
      (let ((w (cons (car w) fixword)))
	(cond ((equal fixword nil)
	       (list (car w)))
	      ((equal (car (cdr w)) (wa))
	       (if (equal (car w) (wa-inv))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wa-inv))
	       (if (equal (car w) (wa))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wb))
	       (if (equal (car w) (wb-inv))
		   (cdr (cdr w))
		 w))
	      ((equal (car (cdr w)) (wb-inv))
	       (if (equal (car w) (wb))
		   (cdr (cdr w))
		 w)))))))


(defun compose (x y)
  (word-fix (append x y))
  )

(defthmd weak-wordp-equivalent-1
  (implies ;(and (character-listp x)
		(weak-wordp x)
	   (let ((word (word-fix x))) 
	     (or (a-wordp word)
		 (a-inv-wordp word)
		 (b-wordp word)
		 (b-inv-wordp word)
		 (equal word '()))))
  )

(defthmd character-listp-cdr-x
  (IMPLIES (character-listp x)
	   (character-listp (cdr x))))


(defthmd character-listp-word-fix
  (implies (and (character-listp x)
		(weak-wordp x))
	   (character-listp (word-fix x)))
  )

(encapsulate
 ()

 (local
  (defthm lemma
    (implies (and (character-listp x)
		  (or (a-wordp x)
		      (a-inv-wordp x)
		      (b-wordp x)
		      (b-inv-wordp x)
		      (equal x '())))
	     (weak-wordp x))))

 (defthm a-wordp=>weak-wordp
   (IMPLIES (and (character-listp x)
		 (a-wordp x))
	    (weak-wordp x)))

 (defthm b-wordp=>weak-wordp
   (IMPLIES (and (character-listp x)
		 (b-wordp x))
	    (weak-wordp x)))

 (defthm b-inv-wordp=>weak-wordp
   (IMPLIES (and (character-listp x)
		 (b-inv-wordp x))
	    (weak-wordp x)))

 (defthm a-inv-wordp=>weak-wordp
   (IMPLIES (and (character-listp x)
		 (a-inv-wordp x))
	    (weak-wordp x)))
 )

(encapsulate
 ()

 (local
  (defthm lemma
    (implies (and (character-listp x)
		  (or (a-wordp x)
		      (a-inv-wordp x)
		      (b-wordp x)
		      (b-inv-wordp x)
		      (equal x '())))
	     (equal (word-fix x) x))))


 (defthm word-fix=a-wordp
   (IMPLIES (and (character-listp x)
		 (a-wordp x))
	    (equal (word-fix x) x))
   )

 (defthm word-fix=a-inv-wordp
   (IMPLIES (and (character-listp x)
		 (a-inv-wordp x))
	    (equal (word-fix x) x))
   )

 (defthm word-fix=b-wordp
   (IMPLIES (and (character-listp x)
		 (b-wordp x))
	    (equal (word-fix x) x))
   )

 (defthm word-fix=b-inv-wordp
   (IMPLIES (and (character-listp x)
		 (b-inv-wordp x))
	    (equal (word-fix x) x))
   )
 )


(defthm prop-2.1-1
  (implies (and (character-listp x)
		(a-wordp x)
		(equal y (compose '(#\b) x)))
	   (or (equal y '())
	       (a-wordp y)
	       (b-wordp y)
	       (b-inv-wordp y))))


(defthm prop-2.1-2
  (implies (and (character-listp x)
		(b-wordp x)
		(equal y (compose '(#\d) x)))
	   (or (equal y '())
	       (a-wordp y)
	       (b-wordp y)
	       (a-inv-wordp y))))

(defthm coro-2.2-1
  

  )































(defthm word-fix=a-wordp-lemma6
  (IMPLIES (AND (character-listp x)
		(a-wordp x))
	   (and (equal (car x) (wa))
		(not (atom x)))))


(defthm word-fix=a-wordp-lemma7
  (IMPLIES (character-listp x)
	   (character-listp (cdr x))))

(defthm word-fix=a-wordp-lemma8
  (implies (and (character-listp x)
		(a-wordp x)
		(WORDP (CDR X) #\a))
	   (or (equal (cdr x) nil)
	       (equal (car (cdr x)) (wa))
	       (equal (car (cdr x)) (wb))
	       (equal (car (cdr x)) (wb-inv)))))

(defthm word-fix=a-wordp-lemma9
  (IMPLIES (and (character-listp x)
		(a-wordp x))
	   (weak-wordp x))

    :hints (("Subgoal *1/2.2"
	     :use (
		   (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
		   (:instance word-fix=a-wordp-lemma8)

		   )
	     ))
    )

(defthm word-fix=a-wordp-lemma8
  (equal

   (IMPLIES (AND (NOT (ATOM X))
              (WORD-FIX (CDR X))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WA)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WA-INV)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WB)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WB-INV)))
              (IMPLIES (AND (CHARACTER-LISTP (CDR X))
                            (A-WORDP (CDR X)))
                       (EQUAL (WORD-FIX (CDR X)) (CDR X))))
         (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
                  (EQUAL (WORD-FIX X) X)))

   (IMPLIES (AND (NOT (ATOM X))
              (WORD-FIX (CDR X))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WA)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WA-INV)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WB)))
              (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
                          (WB-INV)))
              (CHARACTER-LISTP (CDR X))
              (A-WORDP (CDR X))
	      (EQUAL (WORD-FIX (CDR X)) (CDR X)))
         (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
                  (EQUAL (WORD-FIX X) X)))
   )

  :hints (("Goal"
	   :use (
		 (:instance word-fix=a-wordp-lemma7))
	   :in-theory nil
		 ))

  )


(defthm word-fix=a-wordp
  (implies (and (character-listp x)
		(a-wordp x))
	   (equal (word-fix x) x))
  :hints (("Subgoal *1/11"
	   :use ((:instance word-fix=a-wordp-lemma6 (x (cdr x)))
		 (:instance word-fix=a-wordp-lemma7)
		 (:instance word-fix=a-wordp-lemma8)
		 )
	   :in-theory nil
	   )
	  ("Subgoal *1/10"
	   :use (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
	   )
	  ("Subgoal *1/8"
	   :use (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
	   )
	  ("Subgoal *1/5"
	   :use (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
	   )
	  ("Subgoal *1/4"
	   :use (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
	   )
	  ("Subgoal *1/2"
	   :use (:instance word-fix=a-wordp-lemma6 (x (cdr x)))
	   )
	  )
  )



































































(skip-proofs
 (defthm prop-2.1-1-lemma1

   (IMPLIES (AND (NOT (ATOM Y))
		 (WORD-FIX (CDR Y))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA)))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA-INV)))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WB)))
		 (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			(WB-INV))
		 (NOT (EQUAL (CAR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WB)))
		 (IMPLIES (AND (CHARACTER-LISTP X)
			       (A-WORDP X)
			       (EQUAL (CDR Y) (CONS (WA-INV) X)))
			  (LET ((WORD (WORD-FIX (CDR Y))))
			       (OR (EQUAL WORD NIL)
				   (A-WORDP WORD)
				   (B-WORDP WORD)
				   (B-INV-WORDP WORD)))))
	    (IMPLIES (AND (CHARACTER-LISTP X)
			  (A-WORDP X)
			  (EQUAL Y (CONS (WA-INV) X)))
		     (LET ((WORD (WORD-FIX Y)))
			  (OR (EQUAL WORD NIL)
			      (A-WORDP WORD)
			      (B-WORDP WORD)
			      (B-INV-WORDP WORD)))))))


(skip-proofs
 (defthm prop-2.1-1-lemma2
   (IMPLIES (AND (NOT (ATOM Y))
		 (WORD-FIX (CDR Y))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA)))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA-INV)))
		 (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			(WB))
		 (NOT (EQUAL (CAR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WB-INV)))
		 (IMPLIES (AND (CHARACTER-LISTP X)
			       (A-WORDP X)
			       (EQUAL (CDR Y) (CONS (WA-INV) X)))
			  (LET ((WORD (WORD-FIX (CDR Y))))
			       (OR (EQUAL WORD NIL)
				   (A-WORDP WORD)
				   (B-WORDP WORD)
				   (B-INV-WORDP WORD)))))
	    (IMPLIES (AND (CHARACTER-LISTP X)
			  (A-WORDP X)
			  (EQUAL Y (CONS (WA-INV) X)))
		     (LET ((WORD (WORD-FIX Y)))
			  (OR (EQUAL WORD NIL)
			      (A-WORDP WORD)
			      (B-WORDP WORD)
			      (B-INV-WORDP WORD)))))))

(skip-proofs
 (defthm prop-2.1-1-lemma3
   (IMPLIES (AND (NOT (ATOM Y))
		 (WORD-FIX (CDR Y))
		 (NOT (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA)))
		 (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			(WA-INV))
		 (NOT (EQUAL (CAR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			     (WA)))
		 (IMPLIES (AND (CHARACTER-LISTP X)
			       (A-WORDP X)
			       (EQUAL (CDR Y) (CONS (WA-INV) X)))
			  (LET ((WORD (WORD-FIX (CDR Y))))
			       (OR (EQUAL WORD NIL)
				   (A-WORDP WORD)
				   (B-WORDP WORD)
				   (B-INV-WORDP WORD)))))
	    (IMPLIES (AND (CHARACTER-LISTP X)
			  (A-WORDP X)
			  (EQUAL Y (CONS (WA-INV) X)))
		     (LET ((WORD (WORD-FIX Y)))
			  (OR (EQUAL WORD NIL)
			      (A-WORDP WORD)
			      (B-WORDP WORD)
			      (B-INV-WORDP WORD))))))
 )

(skip-proofs
 (defthm prop-2.1-1-lemma4
   (IMPLIES (AND (NOT (ATOM Y))
		 (WORD-FIX (CDR Y))
		 (EQUAL (CADR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			(WA))
		 (EQUAL (CAR (CONS (CAR Y) (WORD-FIX (CDR Y))))
			(WA-INV))
		 (IMPLIES (AND (CHARACTER-LISTP X)
			       (A-WORDP X)
			       (EQUAL (CDR Y) (CONS (WA-INV) X)))
			  (LET ((WORD (WORD-FIX (CDR Y))))
			       (OR (EQUAL WORD NIL)
				   (A-WORDP WORD)
				   (B-WORDP WORD)
				   (B-INV-WORDP WORD)))))
	    (IMPLIES (AND (CHARACTER-LISTP X)
			  (A-WORDP X)
			  (EQUAL Y (CONS (WA-INV) X)))
		     (LET ((WORD (WORD-FIX Y)))
			  (OR (EQUAL WORD NIL)
			      (A-WORDP WORD)
			      (B-WORDP WORD)
			      (B-INV-WORDP WORD)))))))


(skip-proofs
 (defthm prop-2.1-1-lemma5
   (IMPLIES (AND (NOT (ATOM Y))
		 (NOT (WORD-FIX (CDR Y)))
		 (IMPLIES (AND (CHARACTER-LISTP X)
			       (A-WORDP X)
			       (EQUAL (CDR Y) (CONS (WA-INV) X)))
			  (LET ((WORD (WORD-FIX (CDR Y))))
			       (OR (EQUAL WORD NIL)
				   (A-WORDP WORD)
				   (B-WORDP WORD)
				   (B-INV-WORDP WORD)))))
	    (IMPLIES (AND (CHARACTER-LISTP X)
			  (A-WORDP X)
			  (EQUAL Y (CONS (WA-INV) X)))
		     (LET ((WORD (WORD-FIX Y)))
			  (OR (EQUAL WORD NIL)
			      (A-WORDP WORD)
			      (B-WORDP WORD)
			      (B-INV-WORDP WORD)))))))
   

(skip-proofs
 (defthm prop-2.1-1-lemma6
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\c)
		 (CONS #\a (WORD-FIX (CDR X)))
		 (EQUAL (CAR (CONS #\a (WORD-FIX (CDR X))))
			#\a)
		 (CDR (CONS #\a (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CDR (CONS #\a (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))
   ))

(skip-proofs
 (defthm prop-2.1-1-lemma7
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\d)
		 (CONS #\a (WORD-FIX (CDR X)))
		 (EQUAL (CAR (CONS #\a (WORD-FIX (CDR X))))
			#\a)
		 (CDR (CONS #\a (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CDR (CONS #\a (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))))

(skip-proofs
 (defthm prop-2.1-1-lemma8
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\a)
		 (CONS #\a (WORD-FIX (CDR X)))
		 (EQUAL (CAR (CONS #\a (WORD-FIX (CDR X))))
			#\a)
		 (CDR (CONS #\a (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CDR (CONS #\a (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CDR (CONS #\a (WORD-FIX (CDR X))))))))

(skip-proofs
 (defthm prop-2.1-1-lemma9
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\b)
		 (CDR (WORD-FIX (CDR X)))
		 (EQUAL (CADR (WORD-FIX (CDR X))) #\c)
		 (CONS #\b (CDR (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CONS #\b (CDR (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))))

(skip-proofs
 (defthm prop-2.1-1-lemma10
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\b)
		 (CDR (WORD-FIX (CDR X)))
		 (EQUAL (CADR (WORD-FIX (CDR X))) #\b)
		 (CONS #\b (CDR (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CONS #\b (CDR (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))))

(skip-proofs
 (defthm prop-2.1-1-lemma11
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\b)
		 (CDR (WORD-FIX (CDR X)))
		 (EQUAL (CADR (WORD-FIX (CDR X))) #\d)
		 (CONS #\b (CDR (WORD-FIX (CDR X))))
		 (NOT (A-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))
		 (NOT (B-WORDP (CONS #\b (CDR (WORD-FIX (CDR X)))))))
	    (B-INV-WORDP (CONS #\b (CDR (WORD-FIX (CDR X))))))))

(skip-proofs
 (defthm prop-2.1-1-lemma12
   (IMPLIES (AND (CHARACTER-LISTP X)
		 (EQUAL (CAR X) #\a)
		 (WORDP (CDR X) #\a)
		 X (WORD-FIX (CDR X))
		 (EQUAL (CAR (WORD-FIX (CDR X))) #\b)
		 (CDR (WORD-FIX (CDR X)))
		 (EQUAL (CADR (WORD-FIX (CDR X))) #\a)
		 (CDDR (WORD-FIX (CDR X)))
		 (NOT (A-WORDP (CDDR (WORD-FIX (CDR X)))))
		 (NOT (B-WORDP (CDDR (WORD-FIX (CDR X))))))
	    (B-INV-WORDP (CDDR (WORD-FIX (CDR X)))))))



 (defthm prop-2.1-1-lemma13
   (b-wordp '(#\b))
   )


(defthm prop-2.1-1
  (implies (and (character-listp x)
		(a-wordp x)
		(equal y (compose '(#\b) x)))
	   (or (equal y '())
	       (a-wordp y)
	       (b-wordp y)
	       (b-inv-wordp y)))

  :hints (("Subgoal 20"
	   :use (:instance prop-2.1-1-lemma6)
	   )

	  ("Subgoal 17"
	   :use (:instance prop-2.1-1-lemma7)
	   )

	  ("Subgoal 11"
	   :use (:instance prop-2.1-1-lemma8)
	   )

	  ("Subgoal 9"
	   :use (:instance prop-2.1-1-lemma9)
	   )
	  ("Subgoal 8"
	   :use (:instance prop-2.1-1-lemma10)
	   )
	  ("Subgoal 7"
	   :use (:instance prop-2.1-1-lemma11)
	   )
	  ("Subgoal 6"
	   :use (:instance prop-2.1-1-lemma12)
	   )
	  )
  )

  :hints (("Subgoal 20"
	   :use (:instance prop-2.1-1-lemma1)
	   )

	  ("Subgoal *1/8"
	   :use (:instance prop-2.1-1-lemma2)
	   )

	  ("Subgoal *1/6"
	   :use (:instance prop-2.1-1-lemma3)
	   )

	  ("Subgoal *1/3"
	   :use (:instance prop-2.1-1-lemma4)
	   )

	  ("Subgoal *1/2"
	   :use (:instance prop-2.1-1-lemma5)
	   )

	  
	  )
  )

(defthm corollary-2.2-1
  (implies (and (stringp x)
		(wordp x)
		(stringp y)
		(awordp y)
		(stringp z)
		(bwordp z)
		(NOT (equal (WA) (WB)))
		(NOT (equal (WA) (WC)))
		(NOT (equal (WA) (WD)))
		(NOT (equal (WB) (WC)))
		(NOT (equal (WB) (WD)))
		(NOT (equal (WC) (WD)))
		(NOT (equal (WA) (WI)))
		(NOT (equal (WB) (WI)))
		(NOT (equal (WC) (WI)))
		(NOT (equal (WD) (WI)))
		(= (length (wa)) 1))
	   
	   (or (equal x (string-append (wb) y))
	       (equal x z)))

  :hints (("Goal"
	   :use ((:instance length-strings)
		 (:instance identity-rules)
		 (:instance prop-2.1)
		 )
	   ))
  
  )





;; (defthmd character-listp-cdr-x
;;   (IMPLIES (character-listp x)
;; 	   (character-listp (cdr x))))


;; (defthmd character-listp-word-fix
;;   (implies (and (character-listp x)
;; 		(weak-wordp x))
;; 	   (character-listp (word-fix x)))
;;   )

;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma1
;;    (IMPLIES (AND (NOT (ATOM X))
;;               (WORD-FIX (CDR X))
;;               (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;;                           (WA)))
;;               (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;;                           (WA-INV)))
;;               (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;;                           (WB)))
;;               (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;;                           (WB-INV)))
;;               (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;;                             (A-WORDP (CDR X)))
;;                        (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;;          (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;;                   (EQUAL (WORD-FIX X) X)))))


;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma2
;;    (IMPLIES (AND (NOT (ATOM X))
;; 		 (WORD-FIX (CDR X))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA)))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA-INV)))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WB)))
;; 		 (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			(WB-INV))
;; 		 (NOT (EQUAL (CAR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WB)))
;; 		 (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;; 			       (A-WORDP (CDR X)))
;; 			  (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;; 	    (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;; 		     (EQUAL (WORD-FIX X) X)))))


;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma3
;;    (IMPLIES (AND (NOT (ATOM X))
;; 		 (WORD-FIX (CDR X))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA)))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA-INV)))
;; 		 (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			(WB))
;; 		 (NOT (EQUAL (CAR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WB-INV)))
;; 		 (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;; 			       (A-WORDP (CDR X)))
;; 			  (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;; 	    (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;; 		     (EQUAL (WORD-FIX X) X)))))


;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma4
;;    (IMPLIES (AND (NOT (ATOM X))
;; 		 (WORD-FIX (CDR X))
;; 		 (NOT (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA)))
;; 		 (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			(WA-INV))
;; 		 (EQUAL (CAR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			(WA))
;; 		 (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;; 			       (A-WORDP (CDR X)))
;; 			  (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;; 	    (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;; 		     (EQUAL (WORD-FIX X) X)))))



;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma5
;;    (IMPLIES (AND (NOT (ATOM X))
;; 		 (WORD-FIX (CDR X))
;; 		 (EQUAL (CADR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			(WA))
;; 		 (NOT (EQUAL (CAR (CONS (CAR X) (WORD-FIX (CDR X))))
;; 			     (WA-INV)))
;; 		 (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;; 			       (A-WORDP (CDR X)))
;; 			  (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;; 	    (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;; 		     (EQUAL (WORD-FIX X) X)))))



 ;; (local
 ;;  (defthmd lemma1
 ;;    (implies (and (character-listp x)
 ;; 		  (characterp letter)
 ;; 		  (or (equal letter (wa))
 ;; 		      (equal letter (wb))
 ;; 		      (equal letter (wa-inv))
 ;; 		      (equal letter (wb-inv)))
 ;; 		  (wordp x letter))
 ;; 	     (or (equal x nil)
 ;; 		 (and (equal (car x) (wa)) (wordp (cdr x) (car x)))
 ;; 		 (and (equal (car x) (wa-inv)) (wordp (cdr x) (car x)))
 ;; 		 (and (equal (car x) (wb)) (wordp (cdr x) (car x)))
 ;; 		 (and (equal (car x) (wb-inv)) (wordp (cdr x) (car x))))
 ;; 	     )))

 ;; (local
 ;;  (defthm lemma2
 ;;    (implies (and (character-listp x)
 ;; 		  (a-wordp x))
 ;; 	     (and (WORDP (CDR X) #\a)
 ;; 		  (or (equal (cdr x) nil)
 ;; 		      (and (equal (car (cdr x)) (wa)) (wordp (cddr x) (car (cdr x))))
 ;; 		      (and (equal (car (cdr x)) (wb)) (wordp (cddr x) (car (cdr x))))
 ;; 		      (and (equal (car (cdr x)) (wb-inv)) (wordp (cddr x) (car (cdr x)))))))

 ;;    :hints (("Goal"
 ;; 	     :use (:instance lemma1 (x (cdr x)))
 ;; 	     ))
 ;;    ))

 ;; (local
 ;;  (defthm lemma3
 ;;    (implies (and (character-listp x)
 ;; 		  (a-wordp x))
 ;; 	     (equal (car x) (wa)))))

 
 ;; (local
 ;;  (defthm lemma4
 ;;    (implies (and (character-listp (cdr x))
 ;; 		  (a-wordp (cdr x))
 ;; 		  (equal (car x) (wa)))
 ;; 	     (a-wordp x))))


 ;; (local
 ;;  (defthm lemma5
 ;;    (implies (and (character-listp (cdr x))
 ;; 		  (a-wordp (cdr x))
 ;; 		  (equal (car x) (wa)))
 ;; 	     (character-listp x))))


 ;; (local
 ;;  (defthm lemma6
 ;;    (implies (and (character-listp (cdr x))
 ;; 		  (weak-wordp (cdr x))
 ;; 		  (equal (car x) (wa)))
 ;; 	     (weak-wordp x))))

 ;; (local
 ;;  (defthm lemma7
 ;;    (implies (character-listp x)
 ;; 	     (character-listp (cdr x)))
 ;;    )
 ;;  )

 ;; (local
 ;;  (defthm lemma8
 ;;    (implies (and (character-listp x)
 ;; 		  (a-wordp x)
 ;; 		  (not (atom (cdr x))))
 ;; 	     (or (a-wordp (cdr x))
 ;; 		 (a-inv-wordp (cdr x))
 ;; 		 (b-wordp (cdr x))
 ;; 		 (b-inv-wordp (cdr x))))))


 ;; (local
 ;;  (defthm lemma10
 ;;    (IMPLIES (AND (character-listp x)
 ;; 		  (NOT (ATOM X))
 ;; 		  (OR (EQUAL (CAR X) (WA))
 ;; 		      (EQUAL (CAR X) (WA-INV))
 ;; 		      (EQUAL (CAR X) (WB))
 ;; 		      (EQUAL (CAR X) (WB-INV)))
 ;; 		  (IMPLIES (AND (CHARACTER-LISTP (CDR X))
 ;; 				(A-WORDP (CDR X)))
 ;; 			   (WEAK-WORDP (CDR X))))
 ;; 	     (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
 ;; 		      (WEAK-WORDP X)))
 ;;    :hints (("Goal"
 ;; 	     :use ((:instance lemma3 (x x))
 ;; 		   (:instance lemma4 (x x))
 ;; 		   (:instance lemma5 (x x))
 ;; 		   (:instance lemma6 (x x))
 ;; 		   (:instance lemma7 (x x))
 ;; 		   (:instance lemma8 (x x))
 ;; 		   (:instance lemma9 (x x)))
 ;; 	     :in-theory nil
 ;; 	     ))
 ;;    )
 ;;  )




;; (defthmd  prop-2.1-1-lemma1
;;   (implies (and (character-listp x)
;; 		(wordp x #\a))
;; 	   (or (equal x nil)
;; 	       (equal (car x) (wa))
;; 	       (equal (car x) (wb))
;; 	       (equal (car x) (wb-inv))))
;;   )

;; (defthmd  prop-2.1-1-lemma2
;;   (implies (and (character-listp x)
;; 		(wordp x #\b))
;; 	   (or (equal x nil)
;; 	       (equal (car x) (wa-inv))
;; 	       (equal (car x) (wb))
;; 	       (equal (car x) (wb-inv))))
;;   )

;; (defthmd  prop-2.1-1-lemma3
;;   (implies (and (character-listp x)
;; 		(wordp x #\c))
;; 	   (or (equal x nil)
;; 	       (equal (car x) (wa-inv))
;; 	       (equal (car x) (wa))
;; 	       (equal (car x) (wb))))
;;   )

;; (defthmd  prop-2.1-1-lemma4
;;   (implies (and (character-listp x)
;; 		(wordp x #\d))
;; 	   (or (equal x nil)
;; 	       (equal (car x) (wb-inv))
;; 	       (equal (car x) (wa))
;; 	       (equal (car x) (wa-inv))))
;;   )


;; (defthm prop-2.1-1-lemma5
;;   (implies (and (character-listp x)
;; 		(a-wordp x))
;; 	   (equal (word-fix x) x))
;;   :hints (("Goal"
;; 	   :use ((:instance prop-2.1-1-lemma1)
;; 		 (:instance prop-2.1-1-lemma2)
;; 		 (:instance prop-2.1-1-lemma3)
;; 		 (:instance prop-2.1-1-lemma4))
;; 	   ))
;;   )

;; (defthm prop-2.1-1-lemma2
;;   (implies (and (character-listp x)
;; 		(weak-wordp x)
;; 		(NOT (EQUAL (CAR (WORD-FIX X)) #\a))
;; 		(NOT (EQUAL (CAR (WORD-FIX X)) #\b))
;; 		(NOT (EQUAL (CAR (WORD-FIX X)) #\c))
;; 		(NOT (EQUAL (CAR (WORD-FIX X)) #\d)))
;; 	   (equal (word-fix x) nil)))




 ;; (local
 ;;  (defthm lemma4
 ;;    (implies (and (character-listp x)
 ;; 		  (weak-wordp x)
 ;; 		  (character-listp y)
 ;; 		  (equal y '(#\a)))
 ;; 	     (weak-wordp (append y x)))))
   
 ;; (local
 ;;  (defthm lemma5
 ;;    (implies (and (not (atom x))
 ;; 		  (implies (and (character-listp (cdr x))
 ;; 				(a-wordp (cdr x)))
 ;; 			   (weak-wordp (cdr x))))
 ;; 	     (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
 ;; 		      (WEAK-WORDP X)))
 ;;    :hints (("Goal"
 ;; 	     :use ((:instance lemma3 (x (cdr x)) (y '((car x))))
 ;; 		   (:instance lemma4 (x (cdr x)) (y '((car x)))))
 ;; 	     ))))



;; (skip-proofs
;;  (defthm word-fix=a-wordp-lemma6
;;    (IMPLIES (AND (NOT (ATOM X))
;; 		 (NOT (WORD-FIX (CDR X)))
;; 		 (IMPLIES (AND (CHARACTER-LISTP (CDR X))
;; 			       (A-WORDP (CDR X)))
;; 			  (EQUAL (WORD-FIX (CDR X)) (CDR X))))
;; 	    (IMPLIES (AND (CHARACTER-LISTP X) (A-WORDP X))
;; 		     (EQUAL (WORD-FIX X) X)))))

;; (defun word-fix (w)
;;   (if (atom w)
;;       nil
;;     (let ((fixword (word-fix (cdr w))))
;;       (if (equal fixword nil)
;; 	  (list (car w))
;; 	(let ((w (cons (car w) fixword)))
;; 	  (cond ((equal (car (cdr w)) (wa))
;; 		 (if (equal (car w) (wa-inv))
;; 		     (cdr (cdr w))
;; 		   w))
;; 		((equal (car (cdr w)) (wa-inv))
;; 		 (if (equal (car w) (wa))
;; 		     (cdr (cdr w))
;; 		   w))
;; 		((equal (car (cdr w)) (wb))
;; 		 (if (equal (car w) (wb-inv))
;; 		     (cdr (cdr w))
;; 		   w))
;; 		((equal (car (cdr w)) (wb-inv))
;; 		 (if (equal (car w) (wb))
;; 		     (cdr (cdr w))
;; 		   w))
;; 		))))))


;; (defun wordp(w letter)
;;   (cond ((atom w) (equal w nil))
;; 	((equal letter (wa)) (let ((firstw (car w)) (restw (cdr w)))
;; 			       (or (and (equal firstw (wa))
;; 					(wordp restw firstw))
;; 				   (and (equal firstw (wb))
;; 					(wordp restw firstw))
;; 				   (and (equal firstw (wb-inv))
;; 					(wordp restw firstw)))))
;; 	((equal letter (wa-inv)) (let ((firstw (car w)) (restw (cdr w)))
;; 				   (or (and (equal firstw (wa-inv))
;; 					    (wordp restw firstw))
;; 				       (and (equal firstw (wb))
;; 					    (wordp restw firstw))
;; 				       (and (equal firstw (wb-inv))
;; 					    (wordp restw firstw)))))
;; 	((equal letter (wb)) (let ((firstw (car w)) (restw (cdr w)))
;; 			       (or (and (equal firstw (wa))
;; 					(wordp restw firstw))
;; 				   (and (equal firstw (wa-inv))
;; 					(wordp restw firstw))
;; 				   (and (equal firstw (wb))
;; 					(wordp restw firstw)))))
;; 	((equal letter (wb-inv)) (let ((firstw (car w)) (restw (cdr w)))
;; 				   (or (and (equal firstw (wa))
;; 					    (wordp restw firstw))
;; 				       (and (equal firstw (wa-inv))
;; 					    (wordp restw firstw))
;; 				       (and (equal firstw (wb-inv))
;; 					    (wordp restw firstw)))))))


  ;; (defun word-fix (w)
  ;;   (let ((l (word-fix (cdr w))))
  ;;     (if (character-listp l)
  ;; 	  (cond ((equal (car l) (wa)) (if (equal (car w) (wa-inv))
  ;; 					  nil
  ;; 					(cons (car w) l)))
  ;; 		((equal (car l) (wa-inv)) (if (equal (car w) (wa))
  ;; 					      nil
  ;; 					    (cons (car w) l)))
  ;; 		((equal (car l) (wb)) (if (equal (car w) (wb-inv))
  ;; 					  nil
  ;; 					(cons (car w) l)))
  ;; 		((equal (car l) (wb-inv)) (if (equal (car w) (wb))
  ;; 					      nil
  ;; 					    (cons (car w) l)))
  ;; 		)
  ;; 	nil
  ;; 	)
  ;;     )
  ;;   )

 




;; (defthm bwordp-equivalent
;;   (implies (and (stringp b)
;; 		(bwordp b)
;; 		(NOT (equal (WA) (WA-INV)))
;; 		(NOT (equal (WA) (WB)))
;; 		(NOT (equal (WA) (WB-INV)))
;; 		(NOT (equal (WA-INV) (WB)))
;; 		(NOT (equal (WA-INV) (WB-INV)))
;; 		(NOT (equal (WB) (WB-INV)))
;; 		(NOT (equal (WA) (WI)))
;; 		(NOT (equal (WA-INV) (WI)))
;; 		(NOT (equal (WB) (WI)))
;; 		(NOT (equal (WB-INV) (WI)))
;; 		(= (length (wa)) 1))
;; 	   (and (not (awordp b))
;; 		(not (cwordp b))
;; 		(not (dwordp b))
;; 		(not (equal b (wi)))))
		
;;     :hints (("Goal"
;; 	   :use ((:instance length-strings)
;; 		 (:instance identity-rules)
;; 		 )
;; 	   ))
;;     )

;; (defthm cwordp-equivalent
;;   (implies (and (stringp c)
;; 		(cwordp c)
;; 		(NOT (equal (WA) (WA-INV)))
;; 		(NOT (equal (WA) (WB)))
;; 		(NOT (equal (WA) (WB-INV)))
;; 		(NOT (equal (WA-INV) (WB)))
;; 		(NOT (equal (WA-INV) (WB-INV)))
;; 		(NOT (equal (WB) (WB-INV)))
;; 		(NOT (equal (WA) (WI)))
;; 		(NOT (equal (WA-INV) (WI)))
;; 		(NOT (equal (WB) (WI)))
;; 		(NOT (equal (WB-INV) (WI)))
;; 		(= (length (wa)) 1))
;; 	   (and (not (awordp c))
;; 		(not (bwordp c))
;; 		(not (dwordp c))
;; 		(not (equal c (wi)))))
		
;;     :hints (("Goal"
;; 	   :use ((:instance length-strings)
;; 		 (:instance identity-rules)
;; 		 )
;; 	   ))
;;     )

;; (defthm dwordp-equivalent
;;   (implies (and (stringp d)
;; 		(dwordp d)
;; 		(NOT (equal (WA) (WA-INV)))
;; 		(NOT (equal (WA) (WB)))
;; 		(NOT (equal (WA) (WB-INV)))
;; 		(NOT (equal (WA-INV) (WB)))
;; 		(NOT (equal (WA-INV) (WB-INV)))
;; 		(NOT (equal (WB) (WB-INV)))
;; 		(NOT (equal (WA) (WI)))
;; 		(NOT (equal (WA-INV) (WI)))
;; 		(NOT (equal (WB) (WI)))
;; 		(NOT (equal (WB-INV) (WI)))
;; 		(= (length (wa)) 1))
;; 	   (and (not (awordp d))
;; 		(not (bwordp d))
;; 		(not (cwordp d))
;; 		(not (equal d (wi)))))
		
;;     :hints (("Goal"
;; 	   :use ((:instance length-strings)
;; 		 (:instance identity-rules)
;; 		 )
;; 	   ))
;;     )

   
;;   ;;  (character-listp x)
;;   ;;  (>= (length x) 0)
;;   ;;  (if (= (length x) 0)
;;   ;;      (equal x '())
;;   ;;    (let ((firstw (car x)) (restc (cdr x)))
;;   ;;      (and (or (equal firstw (wa))
;;   ;; 		(equal firstw (wa-inv))
;;   ;; 		(equal firstw (wb))
;;   ;; 		(equal firstw (wb-inv)))
;;   ;; 	    (wordp restc)))))
;;   ;; )

