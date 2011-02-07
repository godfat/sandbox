
(defun fib (n)
  (if (< n 2)
      n
      (+ (fib (- n 1))
         (fib (- n 2)))))

(loop for i from 0 to 34 do (format t "n=~d => ~d~%" i (fib i)))
