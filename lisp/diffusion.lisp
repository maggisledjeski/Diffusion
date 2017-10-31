#!/usr/bin/sbcl --script

(defvar A)

(setf A(make-array'(10 10 10)))

;sets the initial value for A to 0
(dotimes (i 10)
    (dotimes (j 10)
        (dotimes (k 10)
            (setf (aref A i j k)(list i '_ j' _ k'= 0))
;            (setf (aref A i j k)(list i 'x j' x k'=(* i j k)))
        )
    )
)
;sets the initial value
(setf (aref A 0 0 0)'100)

;prints the mutli array
(dotimes (i 10)
    (dotimes (j 10)
        (dotimes (k 10)
            (print (aref A i j k))
;            (write-line "string") ;\n affect after write-line
        )
    )
)
