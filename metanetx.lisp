(defun genes-of-compound (cpd)
  (remove-duplicates (loop for rxn in (reactions-of-compound cpd)
        append (genes-of-reaction rxn)) :test #'fequal))

(defun compounds-of-gene-from-list (gene cpdlist)
  (intersection cpdlist (compounds-of-gene gene) :test #'fequal))

(defun compounds-of-gene (gene)
  (remove-duplicates (loop for rxn in (reactions-of-gene gene)
                           append (substrates-of-reaction rxn)) :test #'fequal))

(defun genes-of-compounds (cpd-list)
  (remove-duplicates
   (loop for cpd in cpd-list
         when (coercible-to-frame-p cpd)
         append (genes-of-compound cpd))
   :test #'fequal))

(defun get-common-name (frame)
  (get-slot-value frame 'common-name))

(defun print-udn-cpds-of-gene (filename udn-cpds-of-genes)
  (tofile filename
(format t "Gene	Compounds	Compound Names~%")
(loop for (gene cpd-list) in udn-cpds-of-genes
      do (format t "~A	~{~A~^,~}	~{~A~^,~}~%"
                 (get-slot-value gene 'common-name)
                 (mapcar #'get-frame-name cpd-list)
                 (mapcar #'get-common-name cpd-list)))))
