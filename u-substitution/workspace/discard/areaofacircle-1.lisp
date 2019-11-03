(local (include-book "/users/jagadishbapanapally/Documents/AreaofACircle/areaofacircle"))
(local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/nonstd/workshops/2011/reid-gamboa-differentiator/support/sin-cos-minimal"))
(local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/nonstd/integrals/make-partition"))

(defun f-sine (x)
  (if (realp x)
      (acl2-sine x)
    0)
  )

(defun f2-x (x)
  (if (realp x)
      (* 2 x)
    0)
  )

(defun f2-range() (interval (- (* 2 (fi-dom-variable))) (* 2 (fi-dom-variable))))

(local
 (defthm-std standard-f2-range
   (standardp (f2-range))))

(local
 (defthm-std standard-f2-range-left-endpoint
   (standardp (interval-left-endpoint (f2-range)))))

(local
 (defthm-std standard-f2-range-right-endpoint
   (standardp (interval-right-endpoint (f2-range)))))

  

(local
 (defthm lemma-15
   (implies (and (realp x)
		 (< x y))
	    (< (* 2 x) (* 2 y))
	    )
   ))

(local
 (defthm lemma-16
   (implies (realp x)
	    (realp (- x))
   )
 ))

;; (local
;;  (defthm lemma-17
;;    (consp (cons a b))
;;    )
;;  )

(local
 (defthm lemma-17
   (and (realp (car (f2-range)))
	(= (car (f2-range)) (- (* 2 (fi-dom-variable))))
	)
   :hints (("Goal"
	    :use ((:instance f2-range))
	     :in-theory (enable interval)
	    ))
   )
 )

(local
 (defthm lemma-18
   (and (realp (cdr (f2-range)))
	(= (cdr (f2-range)) (* 2 (fi-dom-variable))))
   :hints (("Goal"
	    :use ((:instance f2-range))
	     :in-theory (enable interval)
	    ))
   )
 )

(defthm intervalp-f2-range
  (interval-p (f2-range))
  :hints ((
	   "Goal"
	   :use ((:instance intervalp-fi-domain)
		 (:instance lemma-15 (x (- (fi-dom-variable)))
			    (y (fi-dom-variable))
			    )
		 (:instance fi-dom-var-def)
		 (:instance lemma-16 (x (fi-dom-variable)))
		 (:instance interval-p(interval (f2-range)))
		 (:instance f2-range)
		 (:instance weak-interval-p (interval (f2-range)))
		 (:instance interval-left-inclusive-p (interval (f2-range)))
		 (:instance interval-right-inclusive-p (interval (f2-range)))
		 (:instance interval-right-endpoint (interval (f2-range)))
		 (:instance interval-left-endpoint (interval (f2-range)))
		 (:instance interval (a (- (* 2 (fi-dom-variable)))) (b (* 2 (fi-dom-variable))))
		 ;(:instance lemma-17 (a (- (* 2 (fi-dom-variable)))) (b (* 2 (fi-dom-variable))))
		 (:instance lemma-17)
		 (:instance lemma-18)
		 )
	   :in-theory nil
	   
	   ))
  )

(defthm f2-range-real
  (implies (inside-interval-p x (f2-range))
	   (realp x)))

(defthm f2-range-non-trivial
  (or (null (interval-left-endpoint (f2-range)))
      (null (interval-right-endpoint (f2-range)))
      (< (interval-left-endpoint (f2-range))
	 (interval-right-endpoint (f2-range))))
  :hints (("Goal"
	   :use ((:instance lemma-15 (x (- (fi-dom-variable)))
			    (y (fi-dom-variable))
			    )
		 (:instance fi-domain-non-trivial)
		 (:instance fi-dom-var-def)
		 (:instance lemma-16 (x (fi-dom-variable)))
		 )
	   
	   ))
  )


(defthm f-sine-real
  (realp (f-sine x))
  :rule-classes (:rewrite :type-prescription))

(defthm f2-x--real
  (realp (f2-x x))
  :rule-classes (:rewrite :type-prescription))

;; The range of fn2 is inside the domain of fn1

(local
 (defthm lemma-19
   (and (realp (cdr (fi-domain)))
	(= (cdr (fi-domain)) (fi-dom-variable))
	(realp (car (fi-domain)))
	(= (car (fi-domain)) (- (fi-dom-variable))))
   
   :hints (("Goal"
	    :use ((:instance fi-domain))
	     :in-theory (enable interval)
	    ))
   )
 )

(local
 (defthm lemma-20
   (implies (inside-interval-p x (fi-domain))
	    (and (>= (f2-x x) (-  (* 2 (fi-dom-variable))))
		 (<= (f2-x x) (* 2 (fi-dom-variable))))
	    )
   :hints (("Goal"
	    :use ((:instance fi-domain-real)
		  ;(:instance interval)
		  ;(:instance inside-interval-p)
		  (:instance fi-domain)
		 ; (:instance lemma-16 (x (fi-dom-variable)))
		  (:instance interval-p(interval (fi-domain)))
		 ; (:instance f2-range)
		  (:instance weak-interval-p (interval (fi-domain)))
		  (:instance interval-left-inclusive-p (interval (fi-domain)))
		  (:instance interval-right-inclusive-p (interval (fi-domain)))
		  (:instance interval-right-endpoint (interval (fi-domain)))
		  (:instance interval-left-endpoint (interval (fi-domain)))
		  (:instance interval (a (- (fi-dom-variable))) (b (fi-dom-variable)))
		  (:instance intervalp-fi-domain)
		  (:instance lemma-19)
		  (:instance f2-x)
		  (:instance inside-interval-p
			     (x x)
			     (interval (fi-domain))
			     )
		  )
	    :in-theory nil
	    ))
   )
 )

(defthm f2-range-in-domain-of-f-sine
  (implies (inside-interval-p x (fi-domain))
	   (inside-interval-p (f2-x x) (f2-range)))
  :hints (("Goal"
	   :use ((:instance lemma-20)
		 (:instance inside-interval-p
			    (x x)
			    (interval (fi-domain)))
		 (:instance inside-interval-p
			    (x (f2-x x))
			    (interval (f2-range)))
		 (:instance f2-x--real)
		 (:instance lemma-17)
		 (:instance lemma-18)
		 (:instance lemma-19)
		 (:instance fi-domain)
		 (:instance fi-domain-real)
		 (:instance interval-p (interval (fi-domain)))
		 (:instance weak-interval-p (interval (fi-domain)))
		 (:instance interval-left-inclusive-p (interval (fi-domain)))
		 (:instance interval-right-inclusive-p (interval (fi-domain)))
		 (:instance interval-right-endpoint (interval (fi-domain)))
		 (:instance interval-left-endpoint (interval (fi-domain)))
		 (:instance interval (a (- (fi-dom-variable))) (b (fi-dom-variable)))
		 (:instance intervalp-fi-domain)
		 (:instance interval-p(interval (f2-range)))
		 (:instance f2-range)
		 (:instance weak-interval-p (interval (f2-range)))
		 (:instance interval-left-inclusive-p (interval (f2-range)))
		 (:instance interval-right-inclusive-p (interval (f2-range)))
		 (:instance interval-right-endpoint (interval (f2-range)))
		 (:instance interval-left-endpoint (interval (f2-range)))
		 (:instance interval (a (- (* 2 (fi-dom-variable)))) (b (* 2 (fi-dom-variable))))
		 )
	   :in-theory nil
	   ))
  )

(defthm-std f-sine-std
  (implies (standardp x)
	   (standardp (f-sine x)))
  )

(local (defthm-std acl2-cosine-std
	 (implies (standardp x)
		  (standardp (acl2-cosine x)))	 
	 ))

(encapsulate
 ()
 (local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/nonstd/workshops/2011/reid-gamboa-differentiator/support/sin-cos-minimal"))
 (defthm f-sine-differentiable
   (implies (and (standardp x)
		 (inside-interval-p x (f2-range))
		 (inside-interval-p y1 (f2-range))
		 (inside-interval-p y2 (f2-range))
		 (i-close x y1) (not (= x y1))
		 (i-close x y2) (not (= x y2))
		 )
	    (and (i-limited (/ (- (f-sine x) (f-sine y1)) (- x y1)))
		 (i-close (/ (- (f-sine x) (f-sine y1)) (- x y1))
			  (/ (- (f-sine x) (f-sine y2)) (- x y2)))
		 ))
   :hints (("Goal"
	    :use ((:instance f2-range-real)
		  (:instance f2-range-real(x y1))
		  (:instance f2-range-real(x y2))
		  (:instance acl2-sine-derivative(x x)
			     (y y1))
		  (:instance standards-are-limited-forward (x (acl2-cosine x)))
					; (:instance i-large-uminus (x (acl2-cosine x)))
		  (:instance i-close-limited-2
			     (y (acl2-cosine x))
			     (x (/ (- (f-sine x) (f-sine y1)) (- x y1))))
		  (:instance acl2-sine)
		  (:instance acl2-cosine)
		  (:instance f-sine-std)
		  (:instance f-sine)
		  (:instance f-sine (x y1))
		  (:instance f-sine (x y2))
		  (:instance acl2-cosine-std)
		  (:instance acl2-sine-derivative(x x)
			     (y y2))
		  (:instance i-close-transitive
			     (x (/ (- (f-sine x) (f-sine y1)) (- x y1)))
			     (y (acl2-cosine x))
			     (z (/ (- (f-sine x) (f-sine y2)) (- x y2)))
			     )
		  (:instance i-close-symmetric
			     (x (/ (- (f-sine x) (f-sine y2)) (- x y2)))
			     (y (acl2-cosine x))
			     )
		  )
	    :in-theory nil
	    ))
   
   )
 )

(local
 (defthm lemma-23
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (not (= x y)))
	    (not (= (- x y) 0))
	    )
   )
 )

(encapsulate
 nil

 (local (in-theory nil))
 (local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/arithmetic-5/top" :dir :system))
 (local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/nonstd/nsa/nsa"))

 (local (defthm f2-x-def
	  (implies (realp x)
		   (equal (f2-x x) (* 2 x)))
	  :hints (("Goal"
		   :use (:instance f2-x (x x))
		   ))
	  ))
 (local
  (defthm lemma-21
    (equal (- (* 2 x)  (* 2 y)) (* 2 (- x y)))
    )
  )

 (local
  (defthm f2-x-diff-lemma
    (implies (and (realp x)
		  (realp y1)
		  (not (= (- x y1) 0)))
	     (equal (/ (- (f2-x x) (f2-x y1)) (- x y1)) (/ (* 2 (- x y1)) (- x y1))))
    :hints (("Goal"
	     :use (
		   (:instance F2-X-def(x x))
		   (:instance f2-x (x y1))
		   (:instance lemma-21
			      (x x)
			      (y y1)
			      )
		   )
	     :in-theory nil
	     ))

    ))

 (local
  (defthm lemma-22
    (implies (and (acl2-numberp x)
		  (not (= x 0)))
	     (equal (/ (* 2 x) x) 2)
	     )
    )
  )

 (local 
 (defthm f2-x-differentiable-lemma
   (implies (and (standardp x)
		 (inside-interval-p x (fi-domain))
		 (inside-interval-p y1 (fi-domain))
		 (i-close x y1) (not (= x y1))
		 (not (= (- x y1) 0))
		 )
	    (equal (/ (- (f2-x x) (f2-x y1)) (- x y1)) 2)
	    )
   :hints (("Goal"
	    :use (
		  (:instance f2-x-diff-lemma)
		  (:instance fi-domain-real (x y1))
		  (:instance fi-domain-real (x x))
		  (:instance lemma-22 (x (- x y1)))
		  )
	    :in-theory nil
	    )
	   )
   )
 )

 (defthm f2-x-differentiable
   (implies (and (standardp x)
		 (inside-interval-p x (fi-domain))
		 (inside-interval-p y1 (fi-domain))
		 (inside-interval-p y2 (fi-domain))
		 (i-close x y1) (not (= x y1))
		 (i-close x y2) (not (= x y2)))
	    (and  (i-limited (/ (- (f2-x x) (f2-x y1)) (- x y1)))
		  (i-close (/ (- (f2-x x) (f2-x y1)) (- x y1))
			   (/ (- (f2-x x) (f2-x y2)) (- x y2)))))
 :hints (("Goal"
	  :use (
		(:instance f2-x-differentiable-lemma
			   (x x)
			   (y1 y1))
		(:instance f2-x-differentiable-lemma
			   (x x)
			   (y1 y2))
		(:instance lemma-23
			   (x x)
			   (y y1))
		(:instance lemma-23
			   (x x)
			   (y y2))
		(:instance fi-domain-real (x y1))
		(:instance fi-domain-real (x x))
		(:instance fi-domain-real (x y2))
		(:instance standard-numberp-integers-to-100000000
			   (x 2))
		(:instance standards-are-limited-forward (x 2))
		(:instance i-close-reflexive (x 2))
		)
	  ))
 )

)


;(local (in-theory nil))

(encapsulate

 ( ((differential-f-sine * *) => *) )
 
 (local (in-theory nil))
 (local
  (defun differential-f-sine (x eps)
    (/ (- (f-sine (+ x eps)) (f-sine x)) eps)))

 (defthm differential-f-sine-definition
   (implies (and (inside-interval-p x (f2-range))
                 (inside-interval-p (+ x eps) (f2-range)))
            (equal (differential-f-sine x eps)
                   (/ (- (f-sine (+ x eps)) (f-sine x)) eps))))
 
 )

(defthm realp-differential-f-sine
  (implies (and (inside-interval-p x (f2-range))
		(inside-interval-p (+ x eps) (f2-range))
		(realp eps))
	   (realp (differential-f-sine x eps)))
  :hints (("Goal"
	   :use (:functional-instance realp-differential-cr-fn1
				      (differential-cr-fn1 differential-f-sine)
				      (cr-fn1 f-sine)
				      (cr-fn2-range f2-range)
				      (cr-fn2-domain fi-domain)
				      (cr-fn2 f2-x))
	   :in-theory (disable fi-dom-var-def)
	   )
	  ("Subgoal 1"
	   :use (:instance intervalp-fi-domain)
	   )
	  ("Subgoal 2"
	   :use (:instance intervalp-f2-range)
	   )
	  
	  ("Subgoal 3"
	   :use (:instance fi-domain-real) 
	   )
	  ("Subgoal 4"
	   :use (:instance f2-range-real) 
	   )
	  ("Subgoal 5"
	   :use (:instance fi-domain-non-trivial) 
	   )
	  ("Subgoal 6"
	   :use (:instance f2-range-non-trivial) 
	   )
	  ("Subgoal 7"
	   :use (:instance f2-range-in-domain-of-f-sine) 
	   )
	  ("Subgoal 8"
	   :use (:instance f-sine-differentiable) 
	   )
	  ("Subgoal 10"
	   :use (:instance differential-f-sine-definition) 
	   )
	  ("Subgoal 9"
	   :use (:instance f2-x-differentiable) 
	   )
	  )

  )

(defthm differential-f-sine-limited
  (implies (and (standardp x)
		(inside-interval-p x (f2-range))
		(inside-interval-p (+ x eps) (f2-range))
		(i-small eps))
	   (i-limited (differential-f-sine x eps)))
  :hints (("Goal"
	   :use (:functional-instance differential-cr-fn1-limited
				      (differential-cr-fn1 differential-f-sine)
				      (cr-fn1 f-sine)
				      (cr-fn2-range f2-range)
				      (cr-fn2-domain fi-domain)
				      (cr-fn2 f2-x)))))

(in-theory (disable differential-f-sine-definition))

(encapsulate

 ( ((derivative-f-sine *) => *) )
 ;(local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/arithmetic-5/top" :dir :system))

 ;; (local
 ;;  (defthm differential-f-sine-limited-1
 ;;    (implies (and (standardp x)
 ;; 		  (inside-interval-p x (f2-range))
 ;; 		  (inside-interval-p (+ x (/ (i-large-integer))) (f2-range)))
 ;; 	     (i-limited (differential-f-sine x (/ (i-large-integer) ))))
 ;;    :hints (("Goal"
 ;; 	     :use ((:instance differential-f-sine-limited
 ;; 			     (x x)
 ;; 			     (eps (/ i-large-integer)))
 ;; 		   (:instance i-large-integer-is-large)
 ;; 		   (:instance i-large (x (i-large-integer)))
 ;; 		   )
 ;; 	     ))
 ;;    )
 ;;  )

 ;; ;(local (include-book "/Users/jagadishbapanapally/Documents/acl2-8.2/acl2-sources/books/arithmetic-5/top" :dir :system))
 ;; (local
 ;;  (defthm differential-f-sine-limited-2
 ;;    (implies (and (standardp x)
 ;; 		  (inside-interval-p x (f2-range))
 ;; 		  (inside-interval-p (+ x (- (/ (i-large-integer)))) (f2-range)))
 ;; 	     (i-limited (differential-f-sine x (- (/ i-large-integer)))))
 ;;    :hints (("Goal"
 ;; 	     :use ((:instance differential-f-sine-limited
 ;; 			     (x x)
 ;; 			     (eps (- (/ i-large-integer))))
 ;; 		   ;(:instance i-large-integer-is-large)
 ;; 		   (:instance i-large (x (- (i-large-integer))))
 ;; 		   ;(:instance i-large-uminus (x (i-large-integer)))
 ;; 		   )
 ;; 	     :in-theory nil
 ;; 	     ))
 ;;    )
 ;;  )

 (local
  (defun-std derivative-f-sine (x)
    (if (inside-interval-p x (f2-range))
        (if (inside-interval-p (+ x (/ (i-large-integer))) (f2-range))
            (standard-part (differential-f-sine x (/ (i-large-integer))))
	  (if (inside-interval-p (- x (/ (i-large-integer))) (f2-range))
	      (standard-part (differential-f-sine x (- (/ (i-large-integer)))))
            'error))
      'error)))

 (defthm derivative-f-sine-definition
   (implies (and (inside-interval-p x (f2-range))
                 (standardp x))
            (equal (derivative-f-sine x)
                   (if (inside-interval-p (+ x (/ (i-large-integer))) (f2-range))
                       (standard-part (differential-f-sine x (/ (i-large-integer))))
                     (if (inside-interval-p (- x (/ (i-large-integer))) (f2-range))
                         (standard-part (differential-f-sine x (- (/ (i-large-integer)))))
                       'error))))

   :hints (("Goal"
	    :use (:functional-instance derivative-cr-fn1-definition
				       (differential-cr-fn1 differential-f-sine)
				       (cr-fn1 f-sine)
				       (cr-fn2-range f2-range)
				       (cr-fn2-domain fi-domain)
				       (derivative-cr-fn1 derivative-f-sine)
				       (cr-fn2 f2-x)))))


 )

(encapsulate

 ( ((differential-cr-f2 * *) => *) )

 (local
  (defun differential-cr-f2 (x eps)
    (/ (- (f2-x (+ x eps)) (f2-x x)) eps)))

 (defthm differential-cr-f2-definition
   (implies (and (inside-interval-p x (fi-domain))
                 (inside-interval-p (+ x eps) (fi-domain)))
            (equal (differential-cr-f2 x eps)
                   (/ (- (f2-x (+ x eps)) (f2-x x)) eps)))))


(defthm realp-differential-cr-f2
  (implies (and (inside-interval-p x (fi-domain))
		(inside-interval-p (+ x eps) (fi-domain))
		(realp eps))
	   (realp (differential-cr-f2 x eps)))
  :hints (("Goal"
	   :use (:functional-instance realp-differential-cr-fn2
				      (differential-cr-fn2 differential-cr-f2)
				      (cr-fn1 f-sine)
				      (cr-fn2-range f2-range)
				      (cr-fn2-domain fi-domain)
				      (derivative-cr-fn1 derivative-f-sine)
				      (cr-fn2 f2-x))
	   )
	  ))

(defthm differential-cr-f2-limited
  (implies (and (standardp x)
		(inside-interval-p x (fi-domain))
		(inside-interval-p (+ x eps) (fi-domain))
		(i-small eps))
	   (i-limited (differential-cr-f2 x eps)))
  :hints (("Goal"
	   :use (:functional-instance differential-cr-fn2-limited
				      (differential-cr-fn2 differential-cr-f2)
				      (cr-fn1 f-sine)
				      (cr-fn2-range f2-range)
				      (cr-fn2-domain fi-domain)
				      (derivative-cr-fn1 derivative-f-sine)
				      (cr-fn2 f2-x))
	   )
	  ))


(in-theory (disable differential-cr-f2-definition))

(encapsulate
 ( ((derivative-cr-f2 *) => *) )

 (local
  (defun-std derivative-cr-f2 (x)
    (if (inside-interval-p x (fi-domain))
        (if (inside-interval-p (+ x (/ (i-large-integer))) (fi-domain))
            (standard-part (differential-cr-f2 x (/ (i-large-integer))))
	  (if (inside-interval-p (- x (/ (i-large-integer))) (fi-domain))
	      (standard-part (differential-cr-f2 x (- (/ (i-large-integer)))))
            'error))
      'error)))

 (defthm derivative-cr-f2-definition
   (implies (and (inside-interval-p x (fi-domain))
                 (standardp x))
            (equal (derivative-cr-f2 x)
                   (if (inside-interval-p (+ x (/ (i-large-integer))) (fi-domain))
                       (standard-part (differential-cr-f2 x (/ (i-large-integer))))
                     (if (inside-interval-p (- x (/ (i-large-integer))) (fi-domain))
                         (standard-part (differential-cr-f2 x (- (/ (i-large-integer)))))
                       'error)))))
 )


(encapsulate
 ( ((f-sine-o-f2 *) => *) )

 (local
  (defun f-sine-o-f2 (x)
    (f-sine (f2-x x))))

 (defthm f-sine-o-f2-definition
   (implies (inside-interval-p x (fi-domain))
            (equal (f-sine-o-f2 x)
                   (f-sine (f2-x x)))))
 )

(encapsulate
 ( ((differential-f-sine-o-f2 * *) => *) )

 (local
  (defun differential-f-sine-o-f2 (x eps)
    (if (equal (f2-x (+ x eps)) (f2-x x))
        0
      (* (differential-f-sine (f2-x x) (- (f2-x (+ x eps)) (f2-x x)))
	 (differential-cr-f2 x eps)))))

 (defthm differential-f-sine-o-f2-definition
   (implies (and (inside-interval-p x (fi-domain))
                 (inside-interval-p (+ x eps) (fi-domain)))
            (equal (differential-f-sine-o-f2 x eps)
                   (if (equal (f2-x (+ x eps)) (f2-x x))
                       0
                     (* (differential-f-sine (f2-x x) (- (f2-x (+ x eps)) (f2-x x)))
                        (differential-cr-f2 x eps))))))
 )

(encapsulate
 ( ((derivative-f-sine-o-f2 *) => *) )

 (local
  (defun derivative-f-sine-o-f2 (x)
    (* (derivative-f-sine (f2-x x))
       (derivative-cr-f2 x))))

 (defthm derivative-f-sine-o-f2-definition
   (implies (inside-interval-p x (fi-domain))
            (equal (derivative-f-sine-o-f2 x)
                   (* (derivative-f-sine (f2-x x))
                      (derivative-cr-f2 x)))))
 )


(defthm differential-f-sine-o-f2-close
   (implies (and (inside-interval-p x (fi-domain))
		 (standardp x)
		 (realp eps) (i-small eps) (not (= eps 0))
		 (inside-interval-p (+ x eps) (fi-domain))
		 (syntaxp (not (equal eps (/ (i-large-integer))))))
	    (equal (standard-part (differential-f-sine-o-f2 x eps))
		   (derivative-f-sine-o-f2 x)))
   :hints (("Goal"
	    :use (:functional-instance differential-cr-fn1-o-fn2-close
				       (derivative-cr-fn1-o-fn2 derivative-f-sine-o-f2)
				       (differential-cr-fn1-o-fn2 differential-f-sine-o-f2)
				       (cr-fn1-o-fn2 f-sine-o-f2)
				       (cr-fn2-domain fi-domain)
				       (derivative-cr-fn2 derivative-cr-f2)
				       (differential-cr-fn2 differential-cr-f2)
				       (derivative-cr-fn1 derivative-f-sine)
				       (differential-cr-fn1 differential-f-sine)
				       (cr-fn1 f-sine)
				       (cr-fn2 f2-x)
				       (cr-fn2-range f2-range)
				       )


	    )))

(defthm differential-f-sine-std-equals
  (implies (and
	    (standardp x)
	    (inside-interval-p x (f2-range))
	    (inside-interval-p (+ x eps) (f2-range))
	    (i-small eps)
	    (not (= eps 0)))
	   (equal (standard-part (differential-f-sine x eps)) (acl2-cosine x))
	   )
  :hints(("Goal"
	  :use ((:instance acl2-sine-derivative
			   (x x)
			   (y (+ x eps)))

		(:instance f2-range-real)
		(:instance f2-range-real(x (+ x eps)))
		(:instance i-close (x x)
			   (y (+ x eps))
			   )
		(:instance differential-f-sine-definition)
		)
	  :in-theory (enable nsa-theory)
	  ))
  )

(defthm differential-cr-f2-equals
  (implies (and (standardp x)
		(i-small eps)
		(not (= eps 0))
		(inside-interval-p x (fi-domain))
		(inside-interval-p (+ x eps) (fi-domain)))
	   (equal (differential-cr-f2 x eps) 2)
	   )
  :hints (("Goal"
	   :use (:instance differential-cr-f2-definition)
	   ))
  )

(local
 (defthmd x-in-interval-implies-x+-eps-in-interval-1
   (implies (and (realp x)
		 (standardp x)
		 (realp x1)
		 (standardp x1)
		 (< x1 x)
		 (realp eps)
		 (i-small eps))
	    (< x1
	       (+ x eps)))
   :hints (("Goal"
	    :use ((:instance standard-part-<-2
			     (x x1)
			     (y (+ x eps))))
	    :in-theory (enable nsa-theory)

	    ))))

(local
 (defthmd x-in-interval-implies-x+-eps-in-interval-2
   (implies (and (realp x)
		 (standardp x)
		 (realp x2)
		 (standardp x2)
		 (< x x2)
		 (realp eps)
		 (i-small eps))
	    (< (+ x eps)
	       x2))
   :hints (("Goal"
	    :use ((:instance standard-part-<-2
			     (x (+ x eps))
			     (y x2)))
	    :in-theory (enable nsa-theory)
	    ))))

(local
 (defthm x-in-trivial-interval
   (implies (and (realp x)
		 (interval-p interval)
		 (not (realp (interval-left-endpoint interval)))
		 (not (realp (interval-right-endpoint interval))))
	    (inside-interval-p x interval))
   :hints (("Goal"
	    :in-theory (enable interval-definition-theory)))
   ))

(local
 (defthm x-in-left-trivial-interval
   (implies (and (realp x)
		 (interval-p interval)
		 (not (realp (interval-left-endpoint interval)))
		 (inside-interval-p y interval)
		 (< x y))
	    (inside-interval-p x interval))
   :hints (("Goal"
	    :in-theory (enable interval-definition-theory)))
   ))

(local
 (defthm x-in-right-trivial-interval
   (implies (and (realp x)
		 (interval-p interval)
		 (not (realp (interval-right-endpoint interval)))
		 (inside-interval-p y interval)
		 (> x y))
	    (inside-interval-p x interval))
   :hints (("Goal"
	    :in-theory (enable interval-definition-theory)))
   ))

(local
 (defthm nil-not-in-interval
   (implies (and (not x)
		 (interval-p interval))
	    (not (inside-interval-p x interval)))
   :hints (("Goal"
	    :in-theory (enable interval-definition-theory)))
   ))

;(skip-proofs
 (local
  (defthm x-in-interval-implies-x+-eps-in-interval-f2-range
    (implies (and (inside-interval-p x (f2-range))
		  (standardp x)
		  (realp eps)
		  (i-small eps)
		  (< 0 eps))
	     (or (inside-interval-p (+ x eps) (f2-range))
		 (inside-interval-p (- x eps) (f2-range))))
    :hints (("Goal"
	     :use (
		   (:instance f2-range-non-trivial)
		   (:instance x-in-interval-implies-x+-eps-in-interval-1
			      (x x)
			      (eps eps)
			      (x1 (interval-left-endpoint (f2-range))))
		   (:instance x-in-interval-implies-x+-eps-in-interval-1
			      (x x)
			      (eps (- eps))
			      (x1 (interval-left-endpoint (f2-range))))
		   (:instance x-in-interval-implies-x+-eps-in-interval-2
			      (x x)
			      (eps eps)
			      (x2 (interval-right-endpoint (f2-range))))
		   (:instance x-in-interval-implies-x+-eps-in-interval-2
			      (x x)
			      (eps (- eps))
			      (x2 (interval-right-endpoint (f2-range))))
		   (:instance lemma-17)
		   (:instance lemma-18)
		   (:instance intervalp-f2-range)
		   (:instance f2-range-real)
		   (:instance standard-f2-range)
		   (:instance standard-f2-range-left-endpoint)
		   (:instance standard-f2-range-right-endpoint)
		   (:instance i-small (x (- eps)))
		   (:instance fi-dom-var-def)
		   )
	     )
	    ("Subgoal 9"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 7"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 6"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 5"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 4"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 3"
	     :in-theory (enable interval-definition-theory))
	    ("Subgoal 1"
	     :in-theory (enable interval-definition-theory))
	    )
    ))

(defthm derivative-f-sine-equals
  (implies (and (inside-interval-p x (f2-range))
		(standardp x)
		)
	   (equal (derivative-f-sine x) (acl2-cosine x))
	   )
  :hints (("Goal"
	   :use (
		 (:instance derivative-f-sine-definition)
		 (:instance x-in-interval-implies-x+-eps-in-interval-f2-range
			    (x x)
			    (eps (/ (i-large-integer))))
		 (:instance differential-f-sine-std-equals
			    (x x)
			    (eps (/ (i-large-integer))))
		 (:instance differential-f-sine-std-equals
			    (x x)
			    (eps (- (/ (i-large-integer)))))
		 )
	   ))
)



;(skip-proofs
 (local
  (defthm x-in-interval-implies-x+-eps-in-interval-fi-dom
    (implies (and (inside-interval-p x (fi-domain))
		  (standardp x)
		  (realp eps)
		  (i-small eps)
		  (< 0 eps))
    (or (inside-interval-p (+ x eps) (fi-domain))
	(inside-interval-p (- x eps) (fi-domain))))
  :hints (("Goal"
	   :use (
		 (:instance fi-domain-non-trivial)
		 (:instance x-in-interval-implies-x+-eps-in-interval-1
			    (x x)
			    (eps eps)
			    (x1 (interval-left-endpoint (fi-domain))))
		 (:instance x-in-interval-implies-x+-eps-in-interval-1
			    (x x)
			    (eps (- eps))
			    (x1 (interval-left-endpoint (fi-domain))))
		 (:instance x-in-interval-implies-x+-eps-in-interval-2
			    (x x)
			    (eps eps)
			    (x2 (interval-right-endpoint (fi-domain))))
		 (:instance x-in-interval-implies-x+-eps-in-interval-2
			    (x x)
			    (eps (- eps))
			    (x2 (interval-right-endpoint (fi-domain))))
		 (:instance lemma-17)
		 (:instance lemma-18)
		 (:instance intervalp-fi-domain)
		 (:instance fi-domain-real)
		 (:instance fi-dom-var-def)
		 )
	   )
	  ("Subgoal 9"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 7"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 6"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 5"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 4"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 3"
	   :in-theory (enable interval-definition-theory))
	  ("Subgoal 1"
	   :in-theory (enable interval-definition-theory))
	  )
  )
  )

(defthm derivative-cr-f2-equals
  (implies (and (inside-interval-p x (fi-domain))
		(standardp x)
		)
	   (equal (derivative-cr-f2 x) 2)
	   )
  :hints (("Goal"
	   :use (
		 (:instance derivative-cr-f2-definition)
		 (:instance x-in-interval-implies-x+-eps-in-interval-fi-dom
			    (x x)
			    (eps (/ (i-large-integer))))
		 (:instance differential-cr-f2-equals
			    (x x)
			    (eps (/ (i-large-integer))))
		 (:instance differential-cr-f2-equals
			    (x x)
			    (eps (- (/ (i-large-integer)))))
		 )
	   ))
)


(defthm differential-f-sine-o-f2-close-1
   (implies (and (inside-interval-p x (fi-domain))
		 (standardp x)
		 (realp eps) (i-small eps) (not (= eps 0))
		 (inside-interval-p (+ x eps) (fi-domain)))
	    (equal (standard-part (differential-f-sine-o-f2 x eps))
		   (* 2 (acl2-cosine (* 2 x)))))
   :hints (("Goal"
	    :use (
		  (:instance differential-f-sine-o-f2-close)
		  (:instance derivative-cr-f2-equals)
		  (:instance derivative-f-sine-equals(x (f2-x x)))
		  (:instance derivative-f-sine-o-f2-definition)
		  (:instance f2-range-in-domain-of-f-sine)
		  )
	    ))
   )

;; (defthm realp-differential-cr-fn1-o-fn2
;;   (implies (and (inside-interval-p x (cr-fn2-domain))
;; 		(inside-interval-p (+ x eps) (cr-fn2-domain))
;; 		(realp eps))
;; 	   (realp (differential-cr-fn1-o-fn2 x eps)))
;;   :hints (("Goal"
;; 	   :by (:functional-instance realp-differential-rdfn
;; 				     (differential-rdfn differential-cr-fn1-o-fn2)
;;                                      (rdfn (lambda (x) (realfix (cr-fn1-o-fn2 x))))
;; 				     (rdfn-domain cr-fn2-domain))
;; 	   :in-theory (enable differential-cr-fn1-definition
;;                               differential-cr-fn2-definition)
;; 	   )
;; 	  ("Goal'"
;; 	   :use ((:instance expand-differential-cr-fn1-o-fn2)))
;; 	  ))

;; (defthm expand-differential-cr-fn1-o-fn2
;;   (implies (and (inside-interval-p x (cr-fn2-domain))
;; 		(inside-interval-p (+ x eps) (cr-fn2-domain)))
;; 	   (equal (differential-cr-fn1-o-fn2 x eps)
;; 		  (/ (- (cr-fn1-o-fn2 (+ x eps)) (cr-fn1-o-fn2 x)) eps)))
;;   :hints (("Goal"
;; 	   :in-theory '(lemma-2-usub-8
;; 			differential-cr-fn1-o-fn2-definition
;; 			differential-cr-fn2-definition
;; 			inverse-of-+
;; 			associativity-of-*)
;; 	   ))
;;   :rule-classes nil)

;; (encapsulate
;;  nil
;;  (local (in-theory nil))

(local
 (defthm lemma-24
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (= (standard-part x) y))
	    (i-close x y)
	    )
   :hints (("Goal"
	    :in-theory (enable nsa-theory)
	    ))
   )
 )

(defthm differential-f-sine-o-f2-derivative
  (implies (and (inside-interval-p x (fi-domain))
		(standardp x)
		(realp eps) (i-small eps) (not (= eps 0))
		(inside-interval-p (+ x eps) (fi-domain)))
	   (i-close  (/ (- (acl2-sine (* 2 (+ x eps))) (acl2-sine (* 2 x))) eps) (* 2 (acl2-cosine (* 2 x)))))
  :hints (
	  ("Goal"
	   :use ((:instance differential-f-sine-o-f2-close-1)
		 )
	   
	   :in-theory (disable differential-f-sine-o-f2-definition fi-domain f-sine-o-f2-definition COSINE-2X)
	   )
	  ("Goal'"
	   :use (:functional-instance realp-differential-cr-fn1-o-fn2
				      (derivative-cr-fn1-o-fn2 derivative-f-sine-o-f2)
				      (differential-cr-fn1-o-fn2 differential-f-sine-o-f2)
				      (cr-fn1-o-fn2 f-sine-o-f2)
				      (cr-fn2-domain fi-domain)
				      (derivative-cr-fn2 derivative-cr-f2)
				      (differential-cr-fn2 differential-cr-f2)
				      (derivative-cr-fn1 derivative-f-sine)
				      (differential-cr-fn1 differential-f-sine)
				      (cr-fn1 f-sine)
				      (cr-fn2 f2-x)
				      (cr-fn2-range f2-range))
	   :in-theory (disable differential-f-sine-o-f2-definition fi-domain f-sine-o-f2-definition COSINE-2X)
	   )
	  ("Goal''"
	   :use (
		 (:instance lemma-24
		 	    (x (differential-f-sine-o-f2 x eps))
		 	    (y (* 2 (acl2-cosine (* 2 x)))))
		 )
	   :in-theory (disable differential-f-sine-o-f2-definition fi-domain f-sine-o-f2-definition COSINE-2X)
	   )
	  ("Goal'''"
	   :use (:functional-instance expand-differential-cr-fn1-o-fn2
				      (derivative-cr-fn1-o-fn2 derivative-f-sine-o-f2)
				      (differential-cr-fn1-o-fn2 differential-f-sine-o-f2)
				      (cr-fn1-o-fn2 f-sine-o-f2)
				      (cr-fn2-domain fi-domain)
				      (derivative-cr-fn2 derivative-cr-f2)
				      (differential-cr-fn2 differential-cr-f2)
				      (derivative-cr-fn1 derivative-f-sine)
				      (differential-cr-fn1 differential-f-sine)
				      (cr-fn1 f-sine)
				      (cr-fn2 f2-x)
				      (cr-fn2-range f2-range))
	   :in-theory nil
	   )
	  ("Subgoal 1"
	   :use (:instance f-sine-o-f2-definition)
	   )
	  ("Goal'4'"
	   :use ((:instance f-sine-o-f2-definition(x x) )
		 (:instance f-sine-o-f2-definition(x (+ x eps)))
		 (:instance f-sine (x (f2-x (+ x eps))))
		 (:instance f2-x (x (+ x eps)))
		 (:instance f-sine (x (f2-x x)))
		 (:instance f2-x (x x))
		 (:instance f2-range-in-domain-of-f-sine (x x))
		 (:instance f2-range-in-domain-of-f-sine (x (+ x eps)))
		 (:instance f2-range-real)
		 (:instance fi-domain-real)
		 )
	   )
	  ("Subgoal 2"
	   :use ((:instance f-sine-o-f2-definition(x x) )
		 (:instance f-sine-o-f2-definition(x (+ x eps)))
		 (:instance f-sine (x (f2-x (+ x eps))))
		 (:instance f2-x (x (+ x eps)))
		 (:instance f-sine (x (f2-x x)))
		 (:instance f2-x (x x))
		 (:instance f2-range-in-domain-of-f-sine (x x))
		 (:instance f2-range-in-domain-of-f-sine (x (+ x eps)))
		 (:instance f2-range-real)
		 (:instance fi-domain-real)
		 ))

	  )
  )


(defthm differential-f-sine-o-f2-derivative-1
  (implies (and (inside-interval-p x (fi-domain))
		(standardp x)
		(i-close x x1)
		(not (= x x1))
		(inside-interval-p x1 (fi-domain)))
	   (i-close  (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)) (* 2 (acl2-cosine (* 2 x)))))
  :hints (("Goal"
	   :use (:instance differential-f-sine-o-f2-derivative
			   (x x)
			   (eps (- x1 x))
			   )
	   :in-theory (enable nsa-theory)
	   ))
  )

(local
 (defthm lemma-25
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (not (= y 0))
		 (= x y))
	    (i-close (/ (* 2 x) y) 2)
	    )
   
   )
 )

(local
 (defthm lemma-26
   (implies (and (acl2-numberp x)
		 (acl2-numberp y))
	    (= (* 2 (- x y)) (- (* 2 x) (* 2 y) ))
	    )
   )
 )

(local
 (defthm lemma-27
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (not (= x y)))
	    (not (= (- x y) 0))
	    )
   
   )
 )




(defthm differential-f2-x
  (implies (and (inside-interval-p x (fi-domain))
		(standardp x)
		(i-close x x1)
		(not (= x x1))
		(inside-interval-p x1 (fi-domain)))
	   (i-close (/ (- (* 2 x) (* 2 x1)) (- x x1)) 2))
  :hints (("Goal"
	   :use ((:instance i-close-reflexive (x 2))
		 (:instance fi-domain-real (x x))
		 (:instance fi-domain-real (x x1))
		 (:instance lemma-25 (x (- x x1))
			    (y (- x x1))
			    )
		 (:instance lemma-26 (x x)
			    (y x1)
			    )
		 (:instance lemma-27 (x x)
			    (y x1)
			    )
		 )
	   :in-theory nil
	   ))
  )

(defun fi-domain-1() (interval 0 (* 1/2 (acl2-pi))))

(defthm-std fi-domain-1-standard
  (standardp (fi-domain)))

(defthm fi-domain-1-real
  (implies (inside-interval-p x (fi-domain-1))
	   (realp x))
  )

(defthm fi-domain-1-non-trivial
  (or (null (interval-left-endpoint (fi-domain-1)))
      (null (interval-right-endpoint (fi-domain-1)))
      (< (interval-left-endpoint (fi-domain-1))
	 (interval-right-endpoint (fi-domain-1))))
  )

(defthm intervalp-fi-domain-1
  (interval-p (fi-domain-1)))

(local
 (defthm lemma-1
   (and (>= 0 (- (fi-dom-variable)))
	(inside-interval-p (* 1/2 (acl2-pi)) (fi-domain))
	)
   :hints (("Goal"
	    :use ((:instance pi-between-2-4)
		  (:instance fi-dom-var-def))
	    :in-theory (enable interval-definition-theory)
    	    ))
   ))

(local
 (defthm lemma-2
   (implies (and (realp x)
		 (<= 0 x)
		 (<= x 5))
	    (inside-interval-p x (fi-domain)))
   :hints (("Goal"
	    :use ((:instance pi-between-2-4)
		  (:instance fi-dom-var-def))
	    :in-theory (enable interval-definition-theory)
	    ))
   )
 )

(local
 (defthm lemma-3
   (implies (and (realp x)
		 (<= 0 x)
		 (<= x (* 1/2 (acl2-pi))))
	    (inside-interval-p x (fi-domain)))
   :hints (("Goal"
	    :use ((:instance pi-between-2-4)
		  (:instance fi-dom-var-def)
		  (:instance lemma-1)
		  (:instance lemma-2))
	    :in-theory (enable interval-definition-theory)
	    ))
   )
 )

(local
 (defthm lemma-4
   (implies (inside-interval-p x (fi-domain-1))
	    (inside-interval-p x (fi-domain)))
   :hints (("Goal"
	    :use ((:instance pi-between-2-4)
		  (:instance fi-dom-var-def)
		  (:instance lemma-3))
	    :in-theory (enable interval-definition-theory)
	    ))))

(local
 (defthm lemma-5
   (implies (inside-interval-p x (fi-domain-1))
	    (>= (acl2-cosine x) 0))
   :hints (("Goal"
	    :use ((:instance acl2-pi-type-prescription)
		  (:instance cosine-positive-in-0-pi/2)
		  (:instance cosine-pi/2)
		  (:instance acl2-cos-0-=-1))
	    :in-theory (enable interval-definition-theory)
	    ))))
	    

(local
 (defthm lemma-6
   (implies (inside-interval-p x (fi-domain-1))
	    (equal (circle-sub-prime x) (*  (* (rad) (acl2-cosine x)) (* (rad) (acl2-cosine x)))))
   :hints (("Goal"
	    :use ((:instance circle-sub-prime-equals)
		  (:instance lemma-4)
		  (:instance cosine-positive-in-0-pi/2)
		  (:instance cosine-pi/2)
		  (:instance acl2-cos-0-=-1)
		  (:instance lemma-5))
	    :in-theory (enable interval-definition-theory)
	    ))))

(defun rcdfn-prime-f (x)
    (if (inside-interval-p x (fi-domain-1))
        (circle-sub-prime x)
      0)
    )

(defthm rcdfn-prime-f-equals
  (implies (inside-interval-p x (fi-domain-1))
	   (equal (rcdfn-prime-f x) (* (rad) (rad) (acl2-cosine x) (acl2-cosine x))))
  :hints (("Goal"
	   :use (:instance lemma-6)
	   ))
  )

(defun rcdfn-f (x)
    (if (realp x)
	(* (rad) (rad) (/ 4) (* (+ (acl2-sine (* 2 x)) (* 2 x))))
      0)
  )

(defthm rcdfn-f-real
  (realp (rcdfn-f x))
  )

(defthm rcdfn-prime-f-real
  (realp (rcdfn-prime-f x))
  )

(defthm-std rcdfn-prime-f-std
  (implies (standardp x)
	   (standardp (rcdfn-prime-f x)))
  )

(defthm-std rcdfn-f-std
  (implies (standardp x)
	   (standardp (rcdfn-f x)))
  )

(local
 (defthm lemma-28
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (i-small (- x y)))
	    (i-close x y))
   :hints (("Goal"
	    :in-theory (enable nsa-theory)
	    ))
   )
 )

(local
 (defthm lemma-29
   (implies (and (acl2-numberp x)
		 (acl2-numberp y)
		 (acl2-numberp z)
		 (i-limited z)
		 (i-close x y))
	    (i-close (* x z) (* y z)))
   :hints (("Goal"
	    :use (
		  (:instance i-close (x x) (y y))
		  (:instance small*limited->small (x (- x y)) (y z))
		  (:instance lemma-28 (x (* x z)) (y (* y z)))
		  )
	    ))
   )
 )

(local
 (defthm lemma-30
   (implies (and (acl2-numberp a)
		 (acl2-numberp b)
		 (acl2-numberp c)
		 (acl2-numberp d))
	    (equal (+ (- a b) (- c d))
		   (- (+ a c) (+ b d)))
	     )
   )
 )

(local
 (defthm lemma-31
   (implies (and (acl2-numberp a)
		 (acl2-numberp b)
		 (acl2-numberp c))
	    (equal (+ (/ a c) (/ b c))
		   (/ (+ a b) c))
	    )
   )
 )

(in-theory (disable rcdfn-prime-f))

(defthm rcdfn-prime-f-is-derivative
  (implies (and (standardp x)
		(inside-interval-p x (fi-domain-1))
		(inside-interval-p x1 (fi-domain-1))
		(i-close x x1) (not (= x x1)))
	   (i-close (/ (- (rcdfn-f x) (rcdfn-f x1)) (- x x1))
		    (rcdfn-prime-f x)))
  :hints (("Goal"
	   :use ((:instance differential-f-sine-o-f2-derivative-1)
		 (:instance rcdfn-prime-f-equals)
		 (:instance lemma-4)
		 (:instance lemma-4 (x x1))
		 (:instance differential-f2-x)
		 (:instance i-close
			    (x  (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)))
			    (y (* 2 (acl2-cosine (* 2 x))))
			    )
		 (:instance i-close
			    (x (/ (- (* 2 x) (* 2 x1)) (- x x1)))
			    (y 2)
			    )
		 (:instance i-small-plus
			    (x (- (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)) (* 2 (acl2-cosine (* 2 x)))))
			    (y (- (/ (- (* 2 x) (* 2 x1)) (- x x1)) 2))
			    )
		 (:instance lemma-30
			    (a (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)))
			    (b (* 2 (acl2-cosine (* 2 x))))
			    (c (/ (- (* 2 x) (* 2 x1)) (- x x1)))
			    (d 2)
			    )
		 (:instance lemma-28
			    (x (+ (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)) (/ (- (* 2 x) (* 2 x1)) (- x x1))))
			    (y (+ (* 2 (acl2-cosine (* 2 x))) 2))
			    )
		 (:instance lemma-31
		 	    (a (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))))
		 	    (b (/ (- (* 2 x) (* 2 x1))))
		 	    (c (- x x1))
		 	    )
		 (:instance standards-are-limited-forward (x (rad)))
		 (:instance rad-def)
		 (:instance i-limited-times (x (rad)) (y (rad)))
		 (:instance i-limited-times (x (* (rad) (rad))) (y (/ 4)))
		 (:instance lemma-29
			    (x (+ (/ (- (acl2-sine (* 2 x)) (acl2-sine (* 2 x1))) (- x x1)) (/ (- (* 2 x) (* 2 x1)) (- x x1))))
			    (y (+ (* 2 (acl2-cosine (* 2 x))) 2))
			    (z (* (rad) (rad) (/ 4)))
			    )
		 (:instance cosine-2x)
		 (:instance cos**2->1-sin**2)
		 (:instance rcdfn-prime-f (x x))
		 (:instance rcdfn-f (x x))
		 (:instance rcdfn-f (x x1))
		 )
	   ))
  )

(defthm rcdfn-prime-f-continuous
  (implies (and (standardp x)
		(inside-interval-p x (fi-domain-1))
		(i-close x x1)
		(inside-interval-p x1 (fi-domain-1)))
	   (i-close (rcdfn-prime-f x)
		    (rcdfn-prime-f x1)))
  :hints (("Goal"
	   :use ((:instance cosine-continuous
			    (x x)
			    (y y))
		 (:instance rcdfn-prime-f-equals)
		 (:instance lemma-4)
		 (:instance lemma-4 (x x1))
		 (:instance rad-def)
		 (:instance standards-are-limited-forward(x (rad)))
		 (:instance lemma-29
			    (x (acl2-cosine x))
			    (y (acl2-cosine x1))
			    (z (rad)))
		 (:instance square-is-continuous
			    (x1 (* (rad) (acl2-cosine x)))
			    (x2 (* (rad) (acl2-cosine x1))))
		 )
	   ))
  )


(defun map-rcdfn-prime-f (p)
  (if (consp p)
      (cons (rcdfn-prime-f (car p))
	    (map-rcdfn-prime-f (cdr p)))
    nil))

(defun riemann-rcdfn-prime-f (p)
  (dotprod (deltas p)
	   (map-rcdfn-prime-f (cdr p))))


(encapsulate
 nil

 (local
  (defthm limited-riemann-rcdfn-prime-f-small-partition
    (implies (and (realp a) (standardp a)
		  (realp b) (standardp b)
		  (inside-interval-p a (fi-domain-1))
		  (inside-interval-p b (fi-domain-1))
		  (< a b))
	     (i-limited (riemann-rcdfn-prime-f (make-small-partition a b))))
    :hints (("Goal"
	     :by (:functional-instance limited-riemann-rcfn-small-partition
				       (rcfn-domain fi-domain-1)
				       (rcfn rcdfn-prime-f)
				       (map-rcfn map-rcdfn-prime-f)
				       (riemann-rcfn riemann-rcdfn-prime-f))
	     )
	    ("Subgoal 2"
	     :use ((:instance rcdfn-prime-f-real)))
	    ("Subgoal 3"
	     :use (:instance rcdfn-prime-f-continuous
			     (x x)
			     (x1 y))
	     )

	    ("Subgoal 2"
	     :use ((:instance intervalp-fi-domain-1)
		   (:instance fi-domain-1-non-trivial)
		   (:instance fi-dom-var-def)
		   (:instance fi-domain-1-standard)
		   (:instance fi-domain-1)
		   )
	     :in-theory (enable interval-definition-theory)
	     )
	    ("Subgoal 1"
	     :use ((:instance intervalp-fi-domain-1))
	     )

	    )))

 (local (in-theory (disable riemann-rcdfn-prime-f)))



 (defun-std strict-int-rcdfn-prime-f (a b)
   (if (and (realp a)
	    (realp b)
	    (inside-interval-p a (fi-domain-1))
	    (inside-interval-p b (fi-domain-1))
	    (< a b))
       (standard-part (riemann-rcdfn-prime-f (make-small-partition a b)))
     0))
 )

(defun int-rcdfn-prime-f (a b)
  (if (<= a b)
      (strict-int-rcdfn-prime-f a b)
    (- (strict-int-rcdfn-prime-f b a))))

(defthm circle-area-ftc-2
  (implies (and (inside-interval-p a (fi-domain-1))
		(inside-interval-p b (fi-domain-1)))
	   (equal (int-rcdfn-prime-f a b)
		  (- (rcdfn-f b)
		     (rcdfn-f a))))
  :hints (("Goal"
	   :use (:functional-instance ftc-2
				      (rcdfn rcdfn-f)
				      (rcdfn-prime rcdfn-prime-f)
				      (map-rcdfn-prime map-rcdfn-prime-f)
				      (riemann-rcdfn-prime riemann-rcdfn-prime-f)
				      (rcdfn-domain fi-domain-1)
				      (int-rcdfn-prime int-rcdfn-prime-f)
				      (strict-int-rcdfn-prime strict-int-rcdfn-prime-f)
				      )
	   )
	  ("Subgoal 8"
	   :use (:instance rcdfn-prime-f-continuous)
	   )
	  ("Subgoal 7"
	   :use (:instance rcdfn-prime-f-is-derivative)
	   )
	  ("Subgoal 6"
	   :use ((:instance intervalp-fi-domain-1)
		 (:instance fi-domain-1-non-trivial)
		 (:instance fi-dom-var-def)
		 (:instance fi-domain-1-standard)
		 (:instance fi-domain-1)
		 )
	   :in-theory (enable interval-definition-theory)
	   )
	  ("Subgoal 5"
	   :use ((:instance intervalp-fi-domain-1))
	   )
	  )
  )

(defthm lemma-0-inside
  (inside-interval-p 0 (fi-domain-1))
  :hints (("Goal"
	   :use ((:instance fi-domain-1))
	   :in-theory (enable interval-definition-theory)
	     ))
  )

(defthm lemma-1/2-pi-inside
  (inside-interval-p (* 1/2 (acl2-pi)) (fi-domain-1))
  :hints (("Goal"
	   :use ((:instance fi-domain-1)
		 )
	   :in-theory (enable interval-definition-theory)
	     ))
  )

(defthm circle-area
  (equal (* 4 (int-rcdfn-prime-f 0 (* 1/2 (acl2-pi)))) (* (rad) (rad) (acl2-pi)))
  :hints (("Goal"
	   :use ((:instance circle-area-ftc-2 (a 0)
			    (b (* 1/2 (acl2-pi))))
		 (:instance lemma-0-inside)
		 (:instance lemma-1/2-pi-inside)
		 )
	   ))
  )

(in-theory (enable rcdfn-prime-f))


(defthm lemma-32
  (implies (inside-interval-p x (fi-domain-1))
	   (equal (rcdfn-prime-f x) (circle-sub-prime x)))
  :hints (("Goal"
	   :use ((:instance rcdfn-prime-f))
	   )))


(defthm lemma-33
  (implies (and (partitionp p)
		(>= (car p) 0)
		(<= (last p) (* 1/2 (acl2-pi))))
	   (equal (map-rcdfn-prime-f p) (map-circle-sub-prime p)))
  :hints (("Goal"
	   :use (:instance lemma-32)
	   :in-theory (enable interval-definition-theory)
	   ))
  )

(defthm lemma-33
(implies (partitionp p)
;		(= (car p) 0)
;		(= (cdr p (* 1/2 (acl2-pi)))))
	   (= (riemann-rcdfn-prime-f (make-small-partition 0 (* 1/2 (acl2-pi))))
	      (riemann-circle-sub-prime (make-small-partition 0 (* 1/2 (acl2-pi)))))
	   :hints (("Goal"
		    :use (:instance lemma-32)
		    :in-theory (enable interval-definition-theory)
		    ))


  )

