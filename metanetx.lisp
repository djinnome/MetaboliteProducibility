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


(defun get-ncbi-gene (gene)
  (loop for dblink in (get-slot-values gene 'dblinks)
        if (fequal (car dblink)
                   'NCBI-GENE)
        return (cadr dblink)))

(defun ncbi-gene-to-accession-2 ()
  (loop for gene in (gcai '|Genes|)
        for ncbi-gene = (get-ncbi-gene gene)
        when ncbi-gene
        do (put-slot-value gene
                           'accession-2
                           (format nil "~A.1" ncbi-gene))))

(defun print-ncbi-gene-to-common (filename)
  (tofile filename
          (format t "NCBI	CommonName~%")
          (loop for gene in (gcai '|Genes|)
                for ncbi-gene = (get-slot-value gene 'accession-2)
                for common-name = (get-slot-value gene 'common-name)
                when (and ncbi-gene common-name)
                do (format t "~A	~A~%" ncbi-gene common-name))))
