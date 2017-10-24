#!/usr/bin/sbcl --script

(defvar A)

(setf A(make-array'(5 5 5)))

(dotimes (i 5)
    (dotimes (j 5)
        (dotimes (k 5)
            (setf (aref A i j k)(list i '_ j' _ k'= 0))
;            (setf (aref A i j k)(list i 'x j' x k'=(* i j k)))
        )
    )
)
(dotimes (i 5)
    (dotimes (j 5)
        (dotimes (k 5)
            (print (aref A i j k))
;            (write-line "string") ;\n affect after write-line
        )
    )
)
