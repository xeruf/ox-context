;; Custom exporter for ConTeXt
;; Copyright (C) 2021 Jason Ross
;; Author: Jason Ross <jasonross1024 at gmail dot com>

;; This is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

(require 'cl-lib)
(require 'ox-latex)
(org-export-define-derived-backend
    'context 'latex
  :menu-entry
  '(?C "Export to ConTeXt"
       ((?c "As ConTeXt file" org-context-export-to-context)
        (?C "As ConTeXt buffer" org-context-export-as-context)
        (?p "As PDF file" org-context-export-to-pdf)
        (?o "As PDF file and open"
            (lambda (a s v b)
              (if a (org-context-export-to-pdf t s v b)
                (org-open-file (org-context-export-to-pdf s v b)))))))
 :filters-alist '((:filter-options . org-context-math-block-options-filter)
                  (:filter-paragraph . org-context-clean-invalid-line-breaks)
                  (:filter-parse-tree org-context-math-block-tree-filter
                                      ;;org-context-matrices-tree-filter
                                      ;; org-context-image-link-filter
                                      )
                  (:filter-verse-block . org-context-clean-invalid-line-breaks))
 :options-alist '((:context-float-default-placement nil nil org-context-float-default-placement)
                  (:context-format-headline-function nil nil org-context-format-headline-function)
                  (:context-header "CONTEXT_HEADER" nil nil newline)
                  (:context-image-default-scale nil nil org-context-image-default-scale)
                  (:context-image-default-height nil nil org-context-image-default-height)
                  (:context-image-default-width nil nil org-context-image-default-width)
                  (:context-image-default-option nil nil org-context-image-default-option)
                  (:context-snippet "CONTEXT_SNIPPET" nil nil split)
                  (:context-snippets nil nil org-context-snippets-alist)
                  (:context-preset "CONTEXT_PRESET" nil org-context-default-preset t)
                  (:context-number-equations nil "numeq" org-context-number-equations)
                  (:context-presets nil nil org-context-presets-alist)
                  (:context-header-extra "CONTEXT_HEADER_EXTRA" nil nil newline)
                  (:context-highlighted-langs nil nil org-context-highlighted-langs)
                  (:context-text-markup-alist nil nil org-context-text-markup-alist)
                  (:context-export-quotes-alist nil nil org-context-export-quotes-alist)
                  (:description "DESCRIPTION" nil nil parse)
                  (:keywords "KEYWORDS" nil nil parse)
                  (:subtitle "SUBTITLE" nil nil parse)
                  (:date "DATE" nil "\\currentdate" parse)
                  (:from-address "FROM_ADDRESS" nil org-context-from-address newline)
                  (:phone-number "PHONE_NUMBER" nil org-context-phone-number)
                  (:url "URL" nil org-context-url)
                  (:from-logo "FROM_LOGO" nil org-context-from-logo)
                  (:to-address "TO_ADDRESS" nil nil newline)
                  (:place "PLACE" nil org-context-place)
                  (:location "LOCATION" nil org-context-location)
                  (:subject "SUBJECT" nil nil parse)
                  (:opening "OPENING" nil org-context-opening parse)
                  (:closing "CLOSING" nil org-context-closing parse)
                  (:signature "SIGNATURE" nil org-context-closing parse)
                  (:with-backaddress nil "backaddress" org-context-use-backaddress)
                  (:with-email nil "email" org-context-use-email)
                  (:with-foldmarks nil "foldmarks" org-context-use-foldmarks)
                  (:with-phone nil "phone" org-context-use-phone)
                  (:with-url nil "url" org-context-use-url)
                  (:with-from-logo nil "from-logo" org-context-use-from-logo)
                  (:with-place nil "place" org-context-use-place))
 :translate-alist '((bold . org-context-bold)
                    (center-block . org-context-center-block)
                    (code . org-context-code)
                    (entity . org-context-entity)
                    (example-block . org-context-example-block)
                    (export-block . org-context-export-block)
                    (fixed-width . org-context-fixed-width)
                    ;;(footnote-definition . org-context-footnote-definition)
                    (footnote-reference . org-context-footnote-reference)
                    (headline . org-context-headline)
                    (horizontal-rule . org-context-horizontal-rule)
                    (inline-src-block . org-context-inline-src-block)
                    (italic . org-context-italic)
                    (item . org-context-item)
                    (latex-environment . org-context-latex-environment)
                    (latex-fragment . org-context-latex-fragment)
                    (line-break . org-context-line-break)
                    (link . org-context-link)
                    (paragraph . org-context-paragraph)
                    (plain-list . org-context-plain-list)
                    (plain-text . org-context-plain-text)
                    (planning . org-context-planning)
                    (quote-block . org-context-quote-block)
                    (src-block . org-context-src-block)
                    (special-block . org-context-special-block)
                    (strike-through . org-context-strike-through)
                    (subscript . org-context-subscript)
                    (superscript . org-context-superscript)
                    (table . org-context-table)
                    (table-cell . org-context-table-cell)
                    (table-row . org-context-table-row)
                    ;;(target . org-context-target)
                    (template . org-context-template)
                    ;;(timestamp . org-context-timestamp)
                    (underline . org-context-underline)
                    (verbatim . org-context-verbatim)
                    (verse-block . org-context-verse-block)
                    ;;;; Pseudo objects and elements.
                    (latex-math-block . org-context-math-block)
                    ;;(latex-matrices . org-context-matrices)
                    ))

(defgroup org-export-context nil
  "Options for exporting to ConTeXt."
  :tag "Org ConTeXt"
  :group 'org-export)

(defcustom org-context-closing ""
  "Letter's closing, as a string.
This option can also be set with the CLOSING keyword."
  :group 'org-export-context
  :type 'string)

(defconst org-context-export-quotes-alist
  '((primary-opening . "\\quotation{")
    (primary-closing . "}")
    (secondary-opening . "\\quote{")
    (secondary-closing . "}")
    (apostrophe . "'")))

(defcustom org-context-float-default-placement "left"
  "Default placement for floats."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-from-address ""
  "Sender's address, as a string.
This option can also be set with one or more FROM_ADDRESS
keywords."
  :group 'org-export-context
  :type 'string)

(defcustom org-context-from-logo ""
  "Commands for inserting the sender's logo, e. g., \\externalfigure[logo.pdf].
This option can also be set with the FROM_LOGO keyword."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-highlighted-langs
  '((metapost "mp"))
  "Alist mapping languages to their counterpart in
ConTeXt. ConTeXt only supports a couple of languages
out-of-the-box so this is a short list."
  :group 'org-export-context
  :type '(repeat
          (list
           (symbol :tag "Major mode      ")
           (symbol :tag "ConTeXt language"))))

(defcustom org-context-image-default-height ""
  "Default height for images."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-image-default-option ""
  "Default option for images."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-image-default-scale ""
  "Default scale for images.
Scale overrides width and height."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-image-default-width ""
  "Default width for images."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-location ""
  "Sender's extension field, as a string.

This option can also be set with the LOCATION keyword. "
  :group 'org-export-context
  :type 'string)

(defcustom org-context-logfiles-extensions
  '("aux" "bcf" "blg" "fdb_latexmk" "fls" "figlist" "idx" "log" "nav" "out"
    "ptc" "run.xml" "snm" "toc" "vrb" "xdv" "tuc")
  "The list of file extensions to consider as ConTeXt logfiles.
The logfiles will be removed if `org-context-remove-logfiles' is
non-nil."
  :group 'org-export-context
  :type '(repeat (string :tag "Extension")))

(defcustom org-context-number-equations nil
  "Non-nil means insert a \\placeformula line before all formulas
to allow numbering."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-opening ""
  "Letter's opening, as a string.

This option can also be set with the OPENING keyword."
  :group 'org-export-context
  :type 'string)

(defcustom org-context-pdf-process
  '("context %f")
  "Commands to process a ConTeXt file to a PDF file.

This is a list of strings, each of them will be given to the
shell as a command.  %f in the command will be replaced by the
relative file name, %F by the absolute file name, %b by the file
base name (i.e. without directory and extension parts), %o by the
base directory of the file, %O by the absolute file name of the
output file, %context is the ConTeXt compiler (see
`org-context-compiler').

Alternatively, this may be a Lisp function that does the
processing, so you could use this to apply the machinery of
AUCTeX or the Emacs LaTeX mode.  This function should accept the
file name as its single argument."
  :group 'org-export-pdf
  :type '(repeat (string :tag "Command")))

(defcustom org-context-phone-number ""
  "Sender's phone number, as a string.
This option can also be set with the PHONE_NUMBER keyword."
  :group 'org-export-context
  :type 'string)

(defcustom org-context-place ""
  "Place from which the letter is sent, as a string.
This option can also be set with the PLACE keyword."
  :group 'org-export-context
  :type 'string)

(defcustom org-context-presets-alist
  '(("empty"
     :preamble nil
     :starttext nil
     :stoptext nil)
    ("article"
     :preamble
     ("\\setupwhitespace[big]"
      "layout-article"
      "description-article"
      "quote-article"
      "verse-article"
      "table-article"
      "title-article"
      "sectioning-article"
      "page-numbering-article"))
    ("report"
     :preamble
     ("\\setupwhitespace[big]"
      "layout-article"
      "description-article"
      "quote-article"
      "verse-article"
      "table-article"
      "title-report"
      "headlines-report"
      "page-numbering-article"))
    ("letter"
     :preamble
     ("\\setupwhitespace[big]
\\usemodule[letter]
\\setupletter[
  fromname={\\documentvariable{metadata:author}},
  fromaddress={\\documentvariable{letter:fromaddress}},
  subject={\\documentvariable{metadata:subject}},
  closing={\\documentvariable{letter:closing}},
  signature={\\documentvariable{letter:signature}},
  toname={\\documentvariable{letter:toname}},
  toaddress={\\documentvariable{letter:toaddress}},
  backaddress={\\documentvariable{letter:fromaddress}},
  opening={\\documentvariable{letter:opening}},
  fromphone={\\documentvariable{metadata:phonenumber}},
  fromurl={\\documentvariable{metadata:url}}]")
     :starttext ("\\startletter")
     :stoptext ("\\stopletter")))
  ;; TODO update doc
  "Alist of ConTeXt preamble presets.
if #+CONTEXT_PRESET is set in the buffer, use its value and the
associated information. Structure is
  (preset-name
   preset-data
   snippet-name...)

Overview
--------

First, the preset data will be inserted into the preamble as-is.
Then, each snippet name you provide will be looked up and the corresponding
snippet will be inserted.

The preset data
---------------

The PRESET-DATA is the data that will be inserted into the ConTeXt file
verbatim. This should include anything specific for this preset that
isn't reused by other presets.

The snippet names
-----------------

The snippet names are references to snippets in
`org-context-presets-alist'. You can use as many snippets as you
like, including zero.
"
  :group 'org-export-context
  :type '(repeat
          (list (string :tag "ConTeXt Preset Name")
                (string :tag "ConTeXt Preset Data")
                (repeat :tag "Snippets"
                        (string :tag "Snippet")))))

(defcustom org-context-remove-logfiles t
  "Non-nil means remove the logfiles produced by PDF production.
By default, logfiles are files with these extensions: .aux, .idx,
.log, .out, .toc, .nav, .snm and .vrb.  To define the set of
logfiles to remove, set `org-context-logfiles-extensions'."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-signature ""
  "Signature, as a string.
This option can also be set with the SIGNATURE keyword."
  :group 'org-export-context
  :type 'string)

(defcustom org-context-snippets-alist
  '(;; Margin setup for article style
    ("layout-article" . "\\setuplayout[
   backspace=103pt,
   topspace=92pt,
   header=12pt,
   headerdistance=25pt,
   width=middle,
   height=middle]")
    ;; US letter paper
    ("paper-letter" . "\\setuppapersize[letter]")
    ;; LaTeX-style tables
    ("table-article" . "\\setupxtable
  [align=center,
   leftframe=off,
   rightframe=off,
   topframe=off,
   bottomframe=off,
   loffset=1em,
   roffset=1em,
   stretch=on]
\\setupxtable
  [OrgTableHeader]
  [toffset=1ex,
   foregroundstyle=bold,
   bottomframe=on]")
    ;; Indented quote blocks
    ("quote-article" . "\\defineblank[QuoteSkip][1ex]
\\setupstartstop
  [OrgBlockQuote]
  [style=slanted,
   before={\\blank[QuoteSkip]
      \\setupnarrower[left=1em, right=1em]
      \\startnarrower[left, right]
      \\noindent},
   after={\\stopnarrower
      \\blank[QuoteSkip]
      \\indenting[next]}]")
    ;; Indented verse blocks with spaces preserved
    ("verse-article" . "\\defineblank[VerseSkip][1ex]
\\setuplines
  [OrgVerse]
  [before={\\blank[VerseSkip]
      \\setupnarrower[left=1em, right=1em]
      \\startnarrower[left, right]},
   after={\\stopnarrower
      \\blank[VerseSkip]},
   space=on]")
    ;; LaTeX-style descriptions
    ("description-article" . "\\setupdescription
  [OrgDesc]
  [headstyle=bold,
   style=normal,
   align=flushleft,
   alternative=hanging,
   width=broad,
   margin=1cm]")
    ;; LaTeX article style title setup
    ("title-article" . "\\setuphead[title][align=middle]
\\define\\OrgMakeTitle{%
  \\startalignment[center]
   \\blank[force,2*big]
   \\title{\\documentvariable{metadata:title}}
   \\doifnot{\\documentvariable{metadata:subtitle}}{}{
     \\blank[force,1*big]
     \\tfa \\documentvariable{metadata:subtitle}}
   \\doifelse{\\documentvariable{metadata:author}}{}{
   \\blank[3*medium]
   {\\tfa \\documentvariable{metadata:email}}
   }{
      \\blank[3*medium]
      {\\tfa \\documentvariable{metadata:author}}
   }
   \\blank[2*medium]
   {\\tfa \\documentvariable{metadata:date}}
   \\blank[3*medium]
  \\stopalignment}")
    ;; LaTeX report style title setup
    ("title-report" . "\\setuphead[title][align=middle]
\\define\\OrgMakeTitle{%
  \\startstandardmakeup[page=yes]
  \\startalignment[center]
   \\blank[force,2*big]
    \\title{\\documentvariable{metadata:title}}
   \\doifnot{\\documentvariable{metadata:subtitle}}{}{
     \\blank[force,1*big]
     \\tfa \\documentvariable{metadata:subtitle}}
   \\doifelse{\\documentvariable{metadata:author}}{}{
   \\blank[3*medium]
   {\\tfa \\documentvariable{metadata:email}}
   }{
      \\blank[3*medium]
      {\\tfa \\documentvariable{metadata:author}}
   }
   \\blank[2*medium]
   {\\tfa \\documentvariable{metadata:date}}
   \\blank[3*medium]
  \\stopalignment
  \\stopstandardmakeup}")
    ;; Report title setuphead
    ;; LaTeX Report-style Headlines
    ("headlines-report" . "\\definehead[subsubsubsection][subsubsection]
\\definehead[subsubsection][subsection]
\\definehead[subsection][section]
\\definehead[section][chapter]
\\definehead[subsubsubsubsubject][subsubsubsubject]
\\definehead[subsubsubsubject][subsubsubject]
\\definehead[subsubsubject][subsubject]
\\definehead[subsubject][subject]
\\definehead[subject][title]
\\setuphead
  [subject,section]
  [before={\\startstandardmakeup[
        headerstate=normal, footerstate=normal, pagestate=start]},
    after={\\stopstandardmakeup}]")
    ;; A simple message
    ("hello" . "% Hello, World!")
    ;; Title on same page as body
    ("sectioning-article" . "\\setupsectionblock[frontpart][page=no]
\\setupsectionblock[bodypart][page=no]")
    ("page-numbering-article" . "\\setuppagenumbering[location=footer,middle]"))
  "Alist of snippet names and associated text. These snippets will be
inserted into the document preamble when calling `org-context-make-template'.
These snippets are also available for use in presets.
See also `:context-presets'"
  :group 'org-export-context
  :type `(repeat
          (cons
           (string :tag "Snippet Name")
           (string :tag "Snippet Value"))))

(defcustom org-context-text-markup-alist
  '((bold ."\\bold{%s}")
    (code . "\\type{%s}")
    (fixed-width . "\\startOrgFixed\n%s\n\\stopOrgFixed")
    (italic . "\\italic{%s}")
    (paragraph . "\n\\startOrgParagraph\n%s\n\\stopOrgParagraph")
    (property-drawer . "\n\startOrgPropertyDrawer\n%s\n\\stopOrgPropertyDrawer")
    (protectedtexttt . "\\type{%s}")
    (quotation . "\\startOrgBlockQuote\n%s\n\\stopOrgBlockQuote")
    (strike-through . "\\inframed[frame=off]{\\overstrike{%s}}")
    (subscript . "\\low{%s}")
    (superscript . "\\high{%s}")
    (underline . "\\underbar{%s}")
    (verbatim . "\\type{%s}")
    (verb . "\\type{%s}")
    (verse . "\\startOrgVerse\n%s\n\\stopOrgVerse"))
  "Alist of ConTeXt expressions to convert text markup."
  :group 'org-export-context
  :version "26.1"
  :package-version '(Org . "8.3")
  :type 'alist
  :options
  '(bold
    code
    fixed-width
    italic
    paragraph
    property-drawer
    protectedtexttt
    quotation
    strike-through
    subscript
    superscript
    underline
    verbatim
    verb
    verse))

(defcustom org-context-url ""
  "Sender's URL, e. g., the URL of her homepage.
This option can also be set with the URL keyword."
  :group 'org-export-context
  :type 'string
  :safe #'stringp)

(defcustom org-context-use-backaddress nil
  "Non-nil prints return address in line above to address.
This option can also be set with the OPTIONS keyword, e.g.:
\"backaddress:t\"."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-use-email nil
  "Non-nil prints sender's email address.
This option can also be set with the OPTIONS keyword, e.g.:
\"email:t\"."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-use-foldmarks t
  "Configure appearance of folding marks.

When t, activate default folding marks.  When nil, do not insert
folding marks at all. "
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-use-from-logo nil
  "Non-nil prints sender's FROM_LOGO.
This option can also be set with the OPTIONS keyword, e.g.:
\"from-logo:t\"."
  :group 'org-export-context
  :type 'boolean
  :safe #'booleanp)

(defcustom org-context-use-phone nil
  "Non-nil prints sender's phone number.
This option can also be set with the OPTIONS keyword, e.g.:
\"phone:t\"."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-use-place t
  "Non-nil prints the letter's place next to the date.
This option can also be set with the OPTIONS keyword, e.g.:
\"place:nil\"."
  :group 'org-export-context
  :type 'boolean)

(defcustom org-context-use-url nil
  "Non-nil prints sender's URL.
This option can also be set with the OPTIONS keyword, e.g.:
\"url:t\"."
  :group 'org-export-context
  :type 'boolean
  :safe #'booleanp)

;;; Filters
(defun org-context-math-block-options-filter (info _backend)
  ;; Annotating because I'm a big dummy.
  ;; Assign to INFO the result of iterating over '(:author :date :title)
  (dolist (prop '(:author :date :title) info)
    ;; Dumb comment
    ;; Info is a plist. Prop is one of :author :date :title
    ;; For each of those values, set its key in INFO to the results of
    ;; org-context--wrap-latex-math-block on its old value
    (plist-put info prop
               (org-context--wrap-latex-math-block (plist-get info prop) info))))

(defun org-context-clean-invalid-line-breaks (data _backend _info)
  (replace-regexp-in-string
   "\\(\\\\stop[A-Za-z0-9*]+\\|^\\)[ \t]*\\\\\\\\[ \t]*$"
   "\\1"
   data))

(defun org-context-math-block-tree-filter (tree _backend info)
  (org-context--wrap-latex-math-block tree info))

;; (defun org-context-matrices-tree-filter (tree _backend info)
;;   (org-context--wrap-latex-matrices tree info))

;; (defun org-context-image-link-filter (data _backend info)
;;   (org-export-insert-image-links data info org-context-inline-image-rules))


;;;; Pseudo Object: LaTeX Math Block

;; `latex-math-block' objects have the following property:
;; `:post-blank'.

(defun org-context--wrap-latex-math-block (data info)
  "Merge continuous math objects in a pseudo-object container.
DATA is a parse tree or a secondary string. INFO is a plist
containing export options. Modify DATA by side-effect and return it."
  (let
      ((valid-object-p
        ;; Non-nill when OBJECT can be added to a latex math block
        (lambda (object)
          (pcase (org-element-type object)
            (`entity (org-element-property :latex-math-p object))
            (`latex-fragment
             (let
                 ((value (org-element-property :value object)))
               (or (string-prefix-p "\\(" value)
                   (string-match-p "\\`\\$[^$]" value))))))))
    (org-element-map
     data
     '(entity latex-fragment)
     (lambda (object)
       (when
           (and
            (not
             (eq
              (org-element-type
               (org-element-property :parent object))
              'latex-math-block))
            (funcall valid-object-p object))
         (let
             ((math-block (list 'latex-math-block nil))
              (next-elements (org-export-get-next-element object info t))
              (last object))
           ;; Wrap MATH-BLOCK around OBJECT in DATA.
           (org-element-insert-before math-block object)
           (org-element-extract-element object)
           (org-element-adopt-elements math-block object)
           (when (zerop (or (org-element-property :post-blank object) 0))
             ;; MATH-BLOCK swallows consecutive math objects.
             (catch 'exit
               (dolist (next next-elements)
                 (unless (funcall valid-object-p next) (throw 'exit nil))
                 (org-element-extract-element next)
                 (org-element-adopt-elements math-block next)
                 ;; Eschew the case: \beta$x$ -> \(\betax\)
                 (org-element-put-property last :post-blank 1)
                 (setq last next)
                 (when (> (or (org-element-property :post-blank next) 0) 0)
                   (throw 'exit nil)))))
           (org-element-put-property
            math-block :post-blank (org-element-property :post-blank last)))))
     info nil '(latex-latex-math-block) t)
    data))

(defun org-context--list-metadata (info)
  "Create a format-spec for document meta-data.
INFO is a plist used as a communication channel."
  (list
    (cons "metadata:author" (org-export-data (plist-get info :author) info))
    (cons "metadata:title" (org-export-data (plist-get info :title) info))
    (cons "metadata:email" (org-export-data (plist-get info :email) info))
    (cons "metadata:subtitle" (org-export-data (plist-get info :subtitle) info))
    (cons "metadata:keywords" (org-export-data (org-context--wrap-latex-math-block
                                                (plist-get info :keywords) info)
                                               info))
    (cons "metadata:description" (org-export-data (org-latex--wrap-latex-math-block
                                                   (plist-get info :description) info)
                                                  info))
    (cons "metadata:creator" (plist-get info :creator))
    (cons "metadata:language" (plist-get info :language))
    (cons "Lang" (capitalize (plist-get info :language)))
    (cons "metadata:date" (org-export-data (org-export-get-date info) info))
    (cons "letter:fromaddress" (org-export-data (plist-get info :from-address) info))
    (cons "metadata:phonenumber" (org-export-data (plist-get info :phone-number) info))
    (cons "metadata:url" (org-export-data (plist-get info :url) info))
    (cons "letter:toaddress" (org-export-data (plist-get info :to-address) info))
    (cons "location" (org-export-data (plist-get info :place) info))
    (cons "letter:location" (org-export-data (plist-get info :location) info))
    (cons "metadata:subject" (org-export-data (plist-get info :subject) info))
    (cons "letter:opening" (org-export-data (plist-get info :opening) info))
    (cons "letter:closing" (org-export-data (plist-get info :closing) info))
    (cons "letter:signature" (org-export-data (plist-get info :signature) info))))

(defun org-context--get-snippet-text (info snippet-names)
  "Returns snippets given a list of snippet names.
SNIPPET_NAMES is a list of snippet names to look up.
INFO is a plist used as a communication channel."
  (mapcar
   (lambda (snippet-name)
     (cdr (assoc
           snippet-name
           (plist-get info :context-snippets))))
   snippet-names))

(defun org-context-template (contents info)
  "Return complete document string after ConTeXt conversion.
CONTENTS is the transcoded contents string. INFO is a plist
holding the export options."
  (let* ((time-stamp (plist-get info :time-stamp-file))
         (header-lines (list (plist-get info :context-header)))
         (with-toc (plist-get info :with-toc))
         (with-section-numbers (plist-get info :section-numbers))
         (metadata (org-context--list-metadata info))
         (header-extra-lines (list (plist-get info :context-header-extra)))
         (preset-name (plist-get info :context-preset))
         (preset-data (cdr (assoc preset-name (plist-get info :context-presets))))
         (preset-header-data (plist-get preset-data :preamble))
         (preset-header-string (car preset-header-data))
         (preset-header-snippets
          (org-context--get-snippet-text info (cdr preset-header-data)))
         (starttext-extra-lines (list (plist-get info :context-starttext)))
         (preset-starttext-data (plist-get preset-data :starttext))
         (preset-starttext-string (car preset-starttext-data))
         (preset-starttext-snippets
          (org-context--get-snippet-text info preset-starttext-data))
         (stoptext-extra-lines (list (plist-get info :context-stoptext)))
         (preset-stoptext-data (plist-get preset-data :stoptext))
         (preset-stoptext-string (car preset-stoptext-data))
         (preset-stoptext-snippets
          (org-context--get-snippet-text info preset-stoptext-data))
         (user-snippets (plist-get info :context-snippet))
         )
    (concat
   (and time-stamp
        (format-time-string "%% Created %Y-%m-%d %a %H:%M\n"))
   "
%===============================================================================
% From CONTEXT_HEADER
%===============================================================================
"
   (mapconcat #'org-element-normalize-string
              header-lines
              "")

   "
%===============================================================================
% Table of Contents Configuration
%===============================================================================
"
   (when (and with-toc (not with-section-numbers))
     "% Add internal numbering to unnumbered sections so they can be included in TOC
\\setuphead[subject]
          [incrementnumber=yes,
            number=no]
\\setuphead[subsubject]
          [incrementnumber=yes,
            number=no]
\\setuphead[subsubsubject]
          [incrementnumber=yes,
            number=no]
\\setuphead[subsubsubsubject]
          [incrementnumber=yes,
            number=no]
")
   (cond
    ((eq with-section-numbers 1) "\\setupcombinedlist[content][list={section, subject}]\n")
    ((eq with-section-numbers 2) "\\setupcombinedlist[content][list={subsection, subsubject}]\n")
    ((eq with-section-numbers 3) "\\setupcombinedlist[content][list={subsubsection, subsubsubject}]\n")
    ((eq with-section-numbers 4) "\\setupcombinedlist[content][list={subsubsubsection, subsubsubsubject}]\n")
    (t "\\setupcombinedlist[content][list={section, subject}]\n"))
   "
%===============================================================================
% Document Metadata
%===============================================================================
"
   (format "\\setupdocument[%s]\n"
           (org-context--format-arguments metadata))
   (format "\\language[%s]" (cdr (assoc "metadata:language" metadata)))
   "
%===============================================================================
% Define Environments and Commands
%===============================================================================

% Turn on interaction to make links work
\\setupinteraction[state=start]
% LaTeX-style descriptive enumerations
\\definedescription[OrgDesc]
% blockquote environment
\\definestartstop[OrgBlockQuote]
% Create the example environment
\\definetyping[OrgExample]
% Create the fixed width environment
\\definestartstop[OrgFixed]
% Create the inline source environment
\\definetyping[OrgInlineSrc]
% Create the block source environment
\\definetyping[OrgBlkSrc]
% Create the table header style
\\definextable[OrgTableHeader]
% Create the title page style
\\definestartstop[OrgTitlePage]
% Create a verse style
\\definelines[OrgVerse]
% Create a property drawer style
\\definestartstop[OrgPropertyDrawer]
% Create a paragraph style
\\definestartstop[OrgParagraph]
% Create a body style
\\definestartstop[OrgBody]
% Create an empty title command to be overridden by user
\\define\\OrgMakeTitle{}
% Create a TOC header command
\\define\\OrgTitleContents{%
  {\\tfc Contents}
}

\\unprotect
% Define a basic planning command
% Override this with user code to customize timestamp appearance
\\def\\OrgPlanning#1[#2]{%
  \\getparameters
    [OrgPlanning]
    [ClosedString=,
     ClosedTime=,
     DeadlineString=,
     DeadlineTime=,
     ScheduledString=,
     ScheduledTime=,
     #2]
  \\OrgPlanningClosedString
  \\OrgPlanningClosedTime
  \\OrgPlanningDeadlineString
  \\OrgPlanningDeadlineTime
  \\OrgPlanningScheduledString
  \\OrgPlanningScheduledTime
}
% Define a basic headline command
% Override this with user code to customize headline appearance
\\def\\OrgHeadline#1[#2]{%
  \\getparameters
    [OrgHeadline]
    [Todo=,
     TodoType=,
     Priority=,
     Text=,
     Tags=,
     #2]
  \\doifnot{\\OrgHeadlineTodo}{}{{\\tfc\\ss\\OrgHeadlineTodo\\quad}}
  \\doifnot{\\OrgHeadlineTodo}{}{{\\sl \\OrgHeadlinePriority\\quad}}
  \\OrgHeadlineText
  \\doifnot{\\OrgHeadlineTags}{}{{\\tt \\tfx \\OrgHeadlineTags\\quad}}
}
\\protect

%===============================================================================
% Preset Commands
%===============================================================================
"
   (concat preset-header-string "\n"
           (mapconcat 'identity preset-header-snippets "\n"))
   "
%===============================================================================
% Snippet Commands
%===============================================================================
"
   (mapconcat 'identity
              user-snippets
              "\n")
   "
%===============================================================================
% Commands from CONTEXT_HEADER_EXTRA
%===============================================================================
"
   (mapconcat #'org-element-normalize-string
              header-extra-lines
              "\n\n")
   "
%===============================================================================
% Document Body
%===============================================================================
\\starttext
\\placebookmarks
\\startfrontmatter
\\startOrgTitlePage
\\OrgMakeTitle"
   (when
       (plist-get info :with-toc)
     "\\OrgTitleContents
\\placecontent\n")
   "\\stopOrgTitlePage
\\stopfrontmatter
\\startbodymatter
\\startOrgBody\n"

   (concat preset-starttext-string "\n"
           (mapconcat 'identity preset-starttext-snippets "\n"))

   contents

   (concat preset-stoptext-string "\n"
           (mapconcat 'identity preset-stoptext-snippets "\n"))

   "\n\\stopOrgBody
\\stopbodymatter
\\stoptext\n")))

;;; Internal functions

(defun org-context-format-headline-default-function
    (todo todo-type priority text tags _info)
  "Default format function for a headline.
See `org-context-format-headline-function' for details."
  (concat
   "\\OrgHeadline
  ["
   (when todo (format "Todo={%s}," todo))
   (when todo-type (format "TodoType={%s}," todo-type))
   (when priority (format "Priority={%s}," priority))
   (when text (format "Text={%s}," text))
   (when tags (format "Tags={%s}," (mapconcat #'org-latex--protect-text tags ":")))
   "]"))

(defun org-context--format-arguments (arguments)
  "Formats ARGUMENTS into a ConTeXt argument string.
ARGUMENTS is an alist of string, string pairs. For instance,
given '((\"key1\" . \"val1\") (\"key2\" . \"val2\")) returns
\"[key1=val1, key2=val2] or similar."
  (mapconcat
   (lambda (kv)
     (let ((key (car kv))
           (val (cdr kv)))
       (format "%s={%s}" key val)))
   (seq-filter (lambda (s) (org-string-nw-p (cdr s))) arguments)
   ",\n"))

(defun org-context--wrap-label (element output info)
  "Wrap label associated to ELEMENT around OUTPUT, if appropriate.
INFO is the current export state, as a plist.  This function
should not be used for floats.  See
`org-context--caption/label-string'."
  (if (not (and (org-string-nw-p output) (org-element-property :name element)))
      output
    (concat (format "\\pagereference[%s]"
                    (org-context--label element info))
            output)))

(defun org-context--caption/label-string (element info)
  "Return caption and label ConTeXt string for ELEMENT.

INFO is a plist holding contextual information.  If there's no
caption nor label, return the empty string.

For non-floats, see `org-context--wrap-label'."
  ;; TODO This whole function needs a lot of work.
  (let* ((label (org-context--label element info nil t))
	 (main (org-export-get-caption element))
	 (attr (or (org-export-read-attribute :attr_context element)
          (org-export-read-attribute :attr_latex element)))
	 (type (org-element-type element))
	 (nonfloat (or (and (plist-member attr :float)
			    (not (plist-get attr :float))
			    main)
		       (and (eq type 'src-block)
			    (not (plist-get attr :float))
			    (null (plist-get info :latex-listings)))))
	 (short (org-export-get-caption element t))
	 (caption-from-attr-latex (plist-get attr :caption)))
    (cond
     ((org-string-nw-p caption-from-attr-latex)
      (concat caption-from-attr-latex "\n"))
     ((and (not main) (equal label "")) "")
     ((not main) label)
     ;; Option caption format with short name.
     (t(org-export-data main info)))))

(defun org-context--text-markup (text markup info)
  "Format TEXT depending on MARKUP text markup.
INFO is a plist used as a communication channel. See
`org-context-text-markup-alist' for details"
  ;; TODO Handle special cases like the LaTeX backend
  (let ((fmt (cdr (assq markup (plist-get info :context-text-markup-alist)))))
    (cl-case fmt
      ;; No format string: Return raw text.
      ((nil) text)
      (verb
       (format "\\type{%s}" text))
      (t (format fmt text)))))

(defun org-context--label (datum info &optional force full)
  "Return an appropriate label for DATUM.
DATUM is an element or a `target' type object.  INFO is the
current export state, as a plist.

Return nil if element DATUM has no NAME or VALUE affiliated
keyword or no CUSTOM_ID property, unless FORCE is non-nil.  In
this case always return a unique label.

Eventually, if FULL is non-nil, wrap label within \"\\label{}\"."
  (let* ((type (org-element-type datum))
	 (user-label
	  (org-element-property
	   (cl-case type
	     ((headline inlinetask) :CUSTOM_ID)
	     (target :value)
	     (otherwise :name))
	   datum))
	 (label
	  (and (or user-label force)
	       (if (and user-label (plist-get info :latex-prefer-user-labels))
		   user-label
		 (concat (pcase type
			   (`headline "sec:")
			   (`table "tab:")
			   (`latex-environment
			    (and (string-match-p
				  org-latex-math-environments-re
				  (org-element-property :value datum))
				 "eq:"))
			   (`latex-matrices "eq:")
			   (`paragraph
			    (and (org-element-property :caption datum)
				 "fig:"))
			   (_ nil))
			 (org-export-get-reference datum info))))))
    (cond ((not full) label)
	  (label (format "\\pagereference[%s]%s"
			 label
			 (if (eq type 'target) "" "\n")))
	  (t ""))))

(defun org-context--inline-image (link info)
  "Return the ConTeXt code for an inline image.
LINK is the link pointing to the inline image. INFO is a plist
used as a communication channel."
  ;; TODO handle svg graphics with built-in converter
  (let* ((parent (org-export-get-parent-element link))
         (path (let ((raw-path (org-element-property :path link)))
                 (if (not (file-name-absolute-p raw-path)) raw-path
                   (expand-file-name raw-path))))
         (filetype (file-name-extension path))
         ;; OK to use the latex function here
         (caption-above-p (org-latex--caption-above-p link info))
         (attr-latex (org-export-read-attribute :attr_latex parent))
         (attr-context (org-export-read-attribute :attr_context parent))
         ;; Context takes precedence over latex
         (attr (or attr-context attr-latex))
         (caption (org-context--caption/label-string parent info))
         (float (let ((float (plist-get attr :float)))
                  (cond ((string= float "wrap") 'wrap)
                        ((string= float "sideways") 'sideways)
                        ((string= float "multicolumn") 'multicolumn)
                        ((and (plist-member attr :float) (not float)) 'nonfloat)
                        ((or float
                             (org-element-property :caption parent)
                             (org-string-nw-p (plist-get attr :caption)))
                         'figure)
                        (t 'nonfloat))))
         ;; TODO convert from LaTeX placement options to ConTeXt placement options
         (placement (plist-get attr-context :placement))
         (center
          (cond
           ;; If this is an image link, do not center
           ((eq 'link (org-element-type (org-export-get-parent link))) nil)
           ((plist-member attr :center) (plist-get attr :center))
           ;; TODO: Do we need an option for this or can we just have it
           ;; be in CONTEXT_HEADER_EXTRA?
           (t (plist-get info :latex-images-centered))))
         ;; TODO: Figure out what this is about
         (comment-include (if (plist-get attr :comment-include) "%" ""))
         ;; It is possible to specify the scale or width and height in
         ;; the ATTR_LATEX line, and also via default variables.
         (scale (cond ((eq float 'wrap) "")
                      ((plist-get attr :scale))
                      ;; TODO: Can we eliminate this option with
                      ;; CONTEXT_HEADER_EXTRA?
                      (t (plist-get info :context-image-default-scale))))
         (width (cond ((org-string-nw-p scale) "")
                      ((plist-get attr :width))
                      ((plist-get attr :height) "")
                      ;; TODO Is this a reasonable size? Shouldn't this
                      ;; be configurable?
                      ((eq float 'wrap) "0.48\\textwidth")
                      ;; TODO Can we eliminate this option with
                      ;; CONTEXT_HEADER_EXTRA?
                      (t (plist-get info :context-image-default-width))))
         (height (cond ((org-string-nw-p scale) "")
                       ((plist-get attr :height))
                       ((or (plist-get attr :width)
                            (memq float '(figure wrap))) "")
                       ;; TODO Can we eliminate this option with
                       ;; CONTEXT_HEADER_EXTRA?
                       (t (plist-get info :context-image-default-height))))
         ;; TODO format options compatible with ConTeXt
         (options (let ((opt (or (plist-get attr :options)
                                 (plist-get info :context-image-default-option))))
                    ;; Strip braces
                    (if (not (string-match "\\`\\[\\(.*\\)\\]\\'" opt)) opt
                      (match-string 1 opt))))
         image-code
         options-list)
    ;; We can't handle tikz and pgf so don't even try
    (when (not (member filetype '("tikz" "pgf")))
      ;; Add scale, or width and height to options
      (if (org-string-nw-p scale)
          ;; TODO check scale format
          (setq options-list (add-to-list 'options-list (cons "scale" scale)))
        (when (org-string-nw-p width)
          (setq options-list (add-to-list 'options-list (cons "maxwidth" width))))
        (when (org-string-nw-p height)
          (setq options-list (add-to-list 'options-list (cons "maxheight" height)))))
      (let ((search-option (org-element-property :search-option link)))
        ;; TODO
        )
      (setq image-code
            (format "\\externalfigure[%s][%s]"
                    path
                    (concat
                     (when (org-string-nw-p options) (format "%s,\n" options))
                     (org-context--format-arguments options-list))))
      (let (env-options
            location-options)
        (when (and center (not (plist-member attr :float)))
          (add-to-list 'location-options "middle"))
        (pcase float
          (`wrap (add-to-list
                  'location-options
                  (or placement (plist-get info :context-float-default-placement))))
          (`sideways (progn (add-to-list 'location-options "90")
                            (add-to-list 'location-options "page")))
          ;; TODO I don't know if this even works in LaTeX
          ;;(`multicolumn "orgmulticolumnfigure")
          ;; TODO What do we do with figure?
          (_ (when placement (add-to-list 'location-options placement))))
        (if (not (eq float 'sideways))
            (add-to-list 'location-options "here"))
        (add-to-list 'env-options
                     (cons "location" (mapconcat 'identity location-options ",")))
        (when (org-string-nw-p caption)
          (add-to-list 'env-options (cons "title" caption)))
        (format
         "\\startplacefigure[%s]
%s
\\stopplacefigure"
         (org-context--format-arguments env-options)
         ;; TODO include comments
         ;; TODO allow caption placement
         image-code)))))

(defun org-context--org-table (table contents info)
  "Return appropriate ConTeXt code for an Org table.

TABLE is the table type element to transcode.  CONTENTS is its
contents, as a string.  INFO is a plist used as a communication
channel.

This function assumes TABLE has `org' as its `:type' property and
`table' as its `:mode' attribute."
  ;; TODO
  (concat
   "\\startplacetable\n\\startxtable\n"
   contents
   "\n\\stopxtable\n\\stopplacetable\n"))

;;; Transcode Functions

;;;; Bold

(defun org-context-bold (_bold contents info)
  "Transcode BOLD from Org to ConTeXt.
CONTENTS is the text with bold markup. INFO is a plist holding
contextual information."
  (org-context--text-markup contents 'bold info))

(defun org-context-center-block (center-block contents info)
  "Transcode a CENTER-BLOCK element from Org to ConTeXt.
CONTENTS holds the contents of the center block.  INFO is a plist
holding contextual information."
  (org-context--wrap-label
   center-block (format "\\startalignment[middle]\n%s\\stopalignment" contents) info))

(defun org-context-code (code contents info)
  "Transcode CODE from Org to ConTeXt"
  (org-context--text-markup (org-element-property :value code) 'code info))

(defun org-context-drawer (drawer contents info)
  "Transcode a DRAWER element from Org to ConTeXt.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information."
  (let* ((name (org-element-property :drawer-name drawer))
         (output (funcall (plist-get info :context-format-drawer-function)
                          name contents)))
    (org-context--wrap-label drawer output info)))

(defun org-context-dynamic-block (dynamic-block contents info)
  "Transcode a DYNAMIC-BLOCK element from Org to LaTeX.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information.  See `org-export-data'."
  (org-context--wrap-label dynamic-block contents info))

(defun org-context-entity (entity _contennts info)
  "Transcode an ENTITY object from Org to ConTeXt.
CONTENTS are the definition itself. INFO is a plist
holding contextual information."
  (org-element-property :context entity))

(defun org-context-example-block (example-block _contennts info)
  "Transcode an EXAMPLE-BLOCK element from Org to ConTeXt.
CONTENTS is nil. INFO is a plist holding contextual information."
  (when (org-string-nw-p (org-element-property :value example-block))
    (org-context--wrap-label
     example-block
     (format "\\startOrgExample\n%s\\stopOrgExample"
             (org-export-format-code-default example-block info))
     info)))

(defun org-context-export-block (export-block _contents _info)
  "Transcode a EXPORT-BLOCK element from Org to ConTeXt.
CONTENTS is nil. INFO is a plist holding contextual information."
  (when (member (org-element-property :type export-block) '("CONTEXT" "TEX"))
    (org-remove-indentation (org-element-property :value export-block))))

(defun org-context-fixed-width (fixed-width _contents info)
  "Transcode a FIXED-WDITH element from Org to LaTeX.
CONTENTS is nil. INFO is a plist holding contextual information."
  (org-context--wrap-label
   fixed-width
   (org-context--text-markup
    (org-remove-indentation
     (org-element-property :value fixed-width))
    'fixed-width
    info)
   info))

(defun org-context-link (link desc info)
  "Transcode a LINK object from Org to ConTeXt.

DESC is the description part of the link, or the empty string.
INFO is a plist holding contextual information. See
`org-export-data'."
  (let* ((type (org-element-property :type link))
         (raw-path (org-element-property :path link))
         (desc (and (not (string= desc "")) desc))
         (imagep (org-export-inline-image-p
                  link
                  (plist-get info :latex-inline-image-rules)))
         (path (org-latex--protect-text
                (pcase type
                  ((or "http" "https" "ftp" "mailto" "doi")
                   (concat type ":" raw-path))
                  ("file"
                   (org-export-file-uri raw-path))
                  (_
                   raw-path)))))
    (cond
     ;; Link type is handled by a special function.
     ((org-export-custom-protocol-maybe link desc 'latex info))
     ;; Image file.
     (imagep (org-context--inline-image link info))
     ;; Radio link: Transcode target's contents and use them as link's
     ;; description.
     ((string= type "radio")
      (let ((destination (org-export-resolve-radio-link link info)))
        (if (not destination)
            desc
          (format "\\about{%s}[%s]"
                  desc
                  (org-export-get-reference destination info)))))
     ;; Links pointing to a headline: Find destination and build
     ;; appropriate referencing command.
     ((member type '("custom-id" "fuzzy" "id"))
      (let ((destination
             (if (string= type "fuzzy")
                 (org-export-resolve-fuzzy-link link info 'latex-matrices)
               (org-export-resolve-id-link link info))))
        (cl-case (org-element-type destination)
          ;; Id link points to an external file
          (plain-text
           (if desc
               (format "\\goto{%s}[url(%s)]" desc destination)
             (format "\\goto{\\hyphenatedurl{%s}}[url(%s)]" destination destination)))
          ;; Fuzzy link points nowhere
          ((nil)
           (format "\\hyphenatedurl{%s}" (org-element-property :raw-link link)))
          ;; LINK points to a headline.  If headlines are numbered
          ;; and the link has no description, display headline's
          ;; number.  Otherwise, display description or headline's
          ;; title.
          (headline
           (let ((label (org-context--label destination info t)))
             (if (and (not desc)
                      (org-export-numbered-headline-p destination info))
                 (format "\\about[%s]" label)
               (format "\\goto{%s}[%s]"
                       (or desc
                           (org-export-data
                            (org-element-property :title destination) info)
                           label)
                       label))))
          (otherwise
           (let ((ref (org-context--label destination info t)))
             (if (not desc)
                 (format "\\about[%s]" ref)
               (format "\\goto{%s}[%s]" desc ref)))))))
     ;; Coderef: replace link with the reference name or the
     ;; equivalent line number.
     ((string= type "coderef")
      (format (org-export-get-coderef-format path desc)
              ;; Resolve with RAW-PATH since PATH could be tainted
              ;; with `org-context--protect-text' call above.
              (org-export-resolve-coderef raw-path info)))
     ;; External link with a description part.
     ((and path desc) (format "\\goto{%s}[url(%s)]" desc path))
     ;; External link without a description part.
     (path (format "\\goto{\\hyphenatedurl{%s}}[url(%s)]" path path))
     ;; No path, only description.  Try to do something useful.
     (t (format "\\hyphenatedurl{%s}" desc)))))

(defun org-context-footnote-reference (footnote-reference _contents info)
  "Transcode a FOOTNOTE-REFERENCE element from Org to ConTeXt.
CONTENTS is nil.  INFO is a plist holding contextual information."
  ;; TODO Handle the case where the first appearance of a footnote
  ;; is inside of another footnote. This could possibly be solved
  ;; by using \footnotetext. This could also be a problem with
  ;; my ConTeXt version
  (let* ((label (org-element-property :label footnote-reference))
         (footnote-definition
          (org-export-get-footnote-definition footnote-reference info))
         (reference-label (org-latex--label footnote-definition info t))
         (contents (org-trim (org-export-data footnote-definition info))))
    (cond
     ;; Footnote has already been defined
     ((not (org-export-footnote-first-reference-p footnote-reference info))
      (format "\\note[%s]" reference-label))
     ;; Otherwise create it
     (t (format "\\footnote[%s]{%s}" reference-label contents)))))

(defun org-context-headline (headline contents info)
  "Transcodes a HEADLINE element from Org to ConTeXt."
  (let* ((level (org-export-get-relative-level headline info))
         (numberedp (org-export-numbered-headline-p headline info))
         (text (org-export-data (org-element-property :title headline) info))
         (todo
          (and (plist-get info :with-todo-keywords)
               (let ((todo (org-element-property :todo-keyword headline)))
                 (and todo (org-export-data todo info)))))
         (todo-type (and todo (org-element-property :todo-type headline)))
         (tags (and (plist-get info :with-tags)
                    (org-export-get-tags headline info)))
         (priority (and (plist-get info :with-priority)
                        (org-element-property :priority headline)))
         (full-text (funcall (plist-get info :context-format-headline-function)
                             todo todo-type priority text tags info))
         (headertemplate
          (concat
           "\\"
           (apply 'concat (make-list (+ level (- 1)) "sub"))
           (if numberedp "section" "subject")))
         (headline-label (org-context--label headline info t )))
    (concat
     headertemplate
     (format
      "[reference={%s},\n  title={%s},\n  list={%s},\n  marking={%s},\n bookmark={%s}]"
      headline-label
      full-text
      text
      text
      text)
     "\n"
     contents)))

(defun org-context-horizontal-rule (horizontal-rule _contents info)
  "Transcode a HORIZONTAL-RULE object from Org to ConTeXt.
CONTENTS is nil. INFO is a plist holding contextual information."
  (let ((attr (org-export-read-attribute :attr_latex horizontal-rule))
        (prev (org-export-get-previous-element horizontal-rule info)))
    (concat
     ;; Make sure the rule doesn't start at the end of the current
     ;; line
     (when (and prev
                (let ((prev-blank (org-element-property :post-blank prev)))
                  (or (not prev-blank) (zerop prev-blank))))
       "\n")
     (org-context--wrap-label
      horizontal-rule
      "\\textrule"
      info))))

(defun org-context-inline-src-block (inline-src-block _contents info)
  "Transcode an INLINE-SRC-BLOCK element from Org to ConTeXt.
CONTENTS holds the contents of the item. INFO is a plist holding
contextual information."
  (let ((code (org-element-property :value inline-src-block)))
    (let* ((org-lang (org-element-propery :language inline-src-block))
           (lang (or (cadr
                      (assq (intern org-lang)
                            (plist-get info :context-highlighted-langs)))
                     (downcase org-lang))))
      (format "\\startOrgInlineSrc[option=%s] %s \\stopOrgInlineSrc " lang code))))

(defun org-context-italic (_italic contents info)
  "Transcode ITALIC from Org to ConTeXt"
  (org-context--text-markup contents 'italic info))

(defun org-context-item (item contents info)
  "Transcode and ITEM element from Org to ConTeXt"
  (let ((tag (let ((tag (org-element-property :tag item)))
               (and tag (org-export-data tag info)))))
    (if (eq
         (org-element-property :type (org-export-get-parent item))
         'descriptive)
        (format "\\startOrgDesc{%s} %s\n\\stopOrgDesc" tag (org-trim contents))
      (format "\\item %s" (org-trim contents)))))

(defun org-context--latex-environment-name (latex-environment)
  "Return the NAME of LATEX-ENVIRONMENT.

The TYPE is determined from the actual latex environment."
  (let* ((latex-begin-re "\\\\begin{\\([A-Za-z0-9*]+\\)}")
         (value (org-remove-indentation
                 (org-element-property :value latex-environment)))
         (env (or (and (string-match latex-begin-re value)
                       (match-string 1 value))
                  "")))
    env))

(defun org-context--latex-environment-contents (latex-environment)
  "Returns the CONTENTS of LATEX-ENVIRONMENT."
  (let* ((latex-env-re "\\\\begin{\\([A-Za-z0-9*]+\\)}\\(\\(?:.*\n\\)*\\)\\\\end{\\1}")
         (value (org-remove-indentation
                 (org-element-property :value latex-environment)))
         (match (string-match latex-env-re value))
         (env-contents (match-string 2 value)))
    env-contents))

(defun org-context--transcode-align (align-environment)
  "Transcode an ALIGN-ENVIRONMENT from org to ConTeXt.
CONTENTS is nil. INFO is a plist holding contextual information."
  (concat
   "\\startalign\n\\NC "
   (replace-regexp-in-string
    "\\\\\\\\" "\\\\NR\n\\\\NC "
    (replace-regexp-in-string "[^\\]&" " \\\\NC " align-environment))
   "\\stopalign\n"))

(defun org-context-latex-environment (latex-environment _contents info)
  "Transcode a LATEX-ENVIRONMENT element from Org to ConTeXt.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (when (plist-get info :with-latex)
    (let* ((value (org-remove-indentation
                   (org-element-property :value latex-environment)))
           (environment-name (org-context--latex-environment-name latex-environment))
           (environment-contents
            (org-context--latex-environment-contents
             latex-environment))
           (numberedp
            (not (string-match "\\*$" environment-name)))
           (type (org-latex--environment-type latex-environment))
           (caption (if (eq type 'math)
                        (org-latex--label latex-environment info nil t)
                      (org-latex--caption/label-string latex-environment info)))
           (caption-above-p
            (memq type (append (plist-get info :latex-caption-above) '(math)))))
      ;; TODO 'table 'src-block
      (pcase type
        ('math
         ;; TODO equaton eqnarray math displaymath
         ;; gather multline flalign alignat
         ;; xalginat xxalignat
         ;; subequations brequn
         ;; dmath dseries dgroup darray
         ;; empheq
         (concat
          (when numberedp "\\placeformula\n")
          "\\startformula\n"
          (pcase environment-name
            ("align" (org-context--transcode-align environment-contents))
            ("align*" (org-context--transcode-align environment-contents))
            (_ environment-contents))
          "\\stopformula"))
        (_ value)))))

(defun org-context-latex-fragment (latex-fragment _contents info)
  "Transcode a LATEX-FRAGMENT object from Org to ConTeXt.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (let ((value (org-element-property :value latex-fragment)))
    ;; Trim math markers since the fragment is enclosed within
    ;; a latex-math-block object anyway.
    (cond ((string-match-p "\\`\\$[^$]" value) (substring value 1 -1))
          ((string-prefix-p "\\(" value) (substring value 2 -2))
          ((or
            (string-prefix-p "\\[" value)
            (string-prefix-p "$$" value))
           (concat
            (when (plist-get info :context-number-equations)
              "\\placeformula\n")
            (format "\\startformula\n%s\n\\stopformula"
                    (substring value 2 -2)))
           )
          (t value))))

(defun org-context-line-break (_line-break _contents _info)
  "Transcode a LINE-BREAK object from Org to LaTeX.
CONTENTS is nil.  INFO is a plist holding contextual information."
  "\\crlf\n")

(defun org-context-paragraph (_paragraph contents info)
  "Transcode a PARAGRAPH element from Org to LaTeX.
CONTENTS is the contents of the paragraph, as a string.  INFO is
the plist used as a communication channel."
  (org-context--text-markup contents 'paragraph info))

(defun org-context-plain-list (plain-list contents info)
  "Transcode a PLAIN-LIST element from Org to ContTeXt.
CONTENTS is the contents of the list. INFO is a plist holding
contextual information."
  (let* ((type (org-element-property :type plain-list))
         (attr (org-export-read-attribute :attr_latex plain-list))
         (env (plist-get attr :environment))
         (open-command
          (cond ((eq type 'ordered) "\\startitemize[n]\n")
                ((eq type 'descriptive) "")
                (t "\\startitemize\n")))
         (close-command
          (if (eq type 'descriptive)
              ""
            "\\stopitemize")))
    (org-context--wrap-label
     plain-list
     (concat
      open-command
      contents
      close-command)
     info)))

(defun org-context--format-quote (text info original)
  "Wraps quoted text in `\\quote{}' constructs. ConTeXt provides
facilities for multilingual quoting so no need to reimplement"
  (let ((quote-status
         (copy-sequence (org-export--smart-quote-status (or original text) info))))
    (replace-regexp-in-string
     "['\"]"
     (lambda (match)
       (cdr (assq (pop quote-status)
                  (plist-get info :context-export-quotes-alist)))
)
     text nil t)))

(defun org-context-plain-text (text info)
  "Transcode a TEXT string from Org to ConTeXt.
TEXT is the string to transcode.  INFO is a plist holding
contextual information."
  (let* ((specialp (plist-get info :with-special-strings))
	 (output
	  ;; Turn LaTeX into \LaTeX{} and TeX into \TeX{}.
	  (let ((case-fold-search nil))
	    (replace-regexp-in-string
	     "\\<\\(?:\\(?:La\\)?TeX\\)\\|\\(?:ConTeXt\\)\\>" "\\\\\\&{}"
	     ;; Protect ^, ~, %, #, &, $, _, { and }.  Also protect \.
	     ;; However, if special strings are used, be careful not
	     ;; to protect "\" in "\-" constructs.
	     (replace-regexp-in-string
	      (concat "[%$#&{}_~^]\\|\\\\" (and specialp "\\([^-]\\|$\\)"))
	      (lambda (m)
		(cl-case (string-to-char m)
		  (?\\ "$\\\\backslash$\\1")
		  (?~ "\\\\textasciitilde{}")
		  (?^ "\\\\^{}")
		  (t "\\\\\\&")))
	      text)))))
    (when (plist-get info :with-smart-quotes)
      (setq output (org-context--format-quote output info text)))
    ;; Convert special strings.
    (when specialp
      (setq output (replace-regexp-in-string "\\.\\.\\." "\\\\ldots{}" output)))
    ;; Handle break preservation if required.
    (when (plist-get info :preserve-breaks)
      (setq output (replace-regexp-in-string
		    "\\(?:[ \t]*\\\\\\\\\\)?[ \t]*\n" "\\\\\n" output nil t)))
    ;; Return value.
    output))

(defun org-context-planning (planning _contents info)
  "Transcode a PLANNING element from Org to ConTeXt.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (let ((closed (org-element-property :closed planning))
        (deadline (org-element-property :deadline planning))
        (scheduled (org-element-property :scheduled planning)))
    (concat "\\OrgPlanning["
            (when closed
              (concat
               (format "\nClosedString={%s}," org-closed-string)
               (format "\nClosedTime={%s}," (org-timestamp-translate closed))))
            (when deadline
              (concat
               (format "\nDeadlineString={%s}," org-deadline-string)
               (format "\nDeadlineTime={%s}," (org-timestamp-translate deadline))))
            (when scheduled
              (concat
               (format "\nScheduledString={%s}," org-scheduled-string)
               (format "\nScheduledTime={%s}," (org-timestamp-translate scheduled))))
            "]")))

(defun org-context-property-drawer (_property-drawer contents _info)
  "Transcode a PROPERTY-DRAWER element from Org to LaTeX.
CONTENTS holds the contents of the drawer.  INFO is a plist
holding contextual information."
  (and (org-string-nw-p contents)
       (org-context--text-markup contents 'property-drawer info)))

(defun org-context-math-block (_math-block contents _info)
  "Transcode a MATH-BLOCK object from Org to ConTeXt.
CONTENTS is a string.  INFO is a plist used as a communication
channel."
  (when (org-string-nw-p contents)
    (format "\\m{%s}" (org-trim contents))))

(defun org-context-quote-block (quote-block contents info)
  "Transcodes a QUOTE-BLOCK element from Org to ConTeXt."
  (org-context--wrap-label
   quote-block (org-context--text-markup contents 'quotation info) info))

(defun org-context-strike-through (_strike-through contents info)
  "Transcode STRIKE_THROUGH from Org to ConTeXt"
  (org-context--text-markup contents 'strike-through info))

(defun org-context-subscript (_subscript contents info)
  "Transcode a SUBSCRIPT from Org to ConTeXt"
  (org-context--text-markup contents 'subscript info))

(defun org-context-superscript (_superscript contents info)
  "Transcode a SUPERSCRIPT from Org to ConTeXt"
  (org-context--text-markup contents 'superscript info))

(defun org-context-special-block (special-block contents info)
  "Transcode a SPECIAL-BLOCK element from Org to ConTeXt.
CONTENTS holds the contents of the block. INFO is a plist
holding contextual information."
  (let ((type (org-element-property :type special-block))
        (opt (org-export-read-attribute :attr_latex special-block :options))
        (caption (org-context--caption/label-string special-block info))
        (caption-above-p (org-latex--caption-above-p special-block info)))
    (concat (format "\\start%s[%s]\n" type (or opt ""))
            (and caption-above-p caption)
            contents
            (and (not caption-above-p) caption)
            (format "\\stop%s" type))))

(defun org-context-src-block (src-block _contents info)
  "Transcode a SRC-BLOCK element from Org to LaTeX.
CONTENTS holds the contents of the item. INFO is a plist holding
contextual information."
  (when (org-string-nw-p (org-element-property :value src-block))
    (let* ((org-lang (org-element-property :language src-block))
           (lang (or (cadr (assq (intern org-lang)
                                 (plist-get info :context-highlighted-langs)))
                     (downcase org-lang))))
      (cond
       ((not lang) (format "\\startOrgBlkSrc\n%s\\stopOrgBlkSrc"
                           (org-export-format-code-default src-block info)))
       (t (format "\\startOrgBlkSrc[option=%s]\n%s\\stopOrgBlkSrc"
                  lang
                  (org-export-format-code-default src-block info)))))))

(defun org-context-table (table contents info)
  "Transcode a TABLE element from Org to ConTeXt.
CONTENTS is the contents of the table. INFO is a plist holding
contextual information."
  (org-context--org-table table contents info))

(defun org-context-table-cell (table-cell contents info)
  "Transcode a TABLE-CELL from Org to ConTeXt.
CONTENTS is the cell contents. INFO is a plist used as
a communication channel."
  (concat
   "\\startxcell "
   ;; TODO
   contents
   " \\stopxcell\n"))

(defun org-context-table-row (table-row contents info)
  "Transcode a TABLE-ROW element from Org to ConTeXt.
CONTENTS is the contents of the row.  INFO is a plist used as
a communication channel."
  (let ((firstrowp (not (org-export-get-previous-element table-row info)))
        (wrappedcontents (concat "\\startxrow\n" contents "\\stopxrow")))
    (if firstrowp
        (concat "\\startxtablehead[OrgTableHeader]\n" wrappedcontents "\n\\stopxtablehead")
      wrappedcontents)))

(defun org-context-underline (_underline contents info)
  "Transcode UNDERLINE from Org to ConTeXt"
  (org-context--text-markup contents 'underline info))

(defun org-context-verbatim (verbatim _contents info)
  "Transcode a VERBATIM object from Org to ConTeXt"
  (org-context--text-markup
   (org-element-property :value verbatim) 'verbatim info))

(defun org-context-verse-block (verse-block contents info)
  "Transcode a VERSE-BLOCK element from Org to ConTeXt.
CONTENTS is verse block contents.  INFO is a plist holding
contextual information."
  (org-context--wrap-label
   verse-block
   (org-context--text-markup contents 'verse info)
   info))

;;;###autoload
(defun org-context-export-as-context
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as a ConTeXt buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\starttext\" and \"\\stoptext\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Export is done in a buffer named \"*Org CONTEXT Export*\", which
will be displayed when `org-export-show-temporary-export-buffer'
is non-nil."
  (interactive)
  (org-export-to-buffer 'context "*Org CONTEXT Export*"
    async subtreep visible-only body-only ext-plist (lambda () (ConTeXt-mode))))

;;;###autoload
(defun org-context-export-to-context
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a ConTeXt file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\starttext\" and \"\\stoptext\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings."
  (interactive)
  (let ((file (org-export-output-file-name ".mkiv" subtreep)))
    (org-export-to-file 'context file
      async subtreep visible-only body-only ext-plist)))

(defun org-context-export-to-pdf
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to ConTeXt then process through to PDF.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\starttext\" and \"\\stoptext\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Return PDF file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".mkiv" subtreep)))
    (org-export-to-file 'context outfile
      async subtreep visible-only body-only ext-plist
      (lambda (file) (org-context-compile file)))))

(defun org-context-compile (texfile &optional snippet)
  "Compile a ConTeXt file.

TEXFILE is the name of the file being compiled.  Processing is
done through the command specified in `org-context-pdf-process',
which see.  Output is redirected to \"*Org PDF ConTeXt Output*\"
buffer.

When optional argument SNIPPET is non-nil, TEXFILE is a temporary
file used to preview a LaTeX snippet.  In this case, do not
create a log buffer and do not remove log files.

Return PDF file name or raise an error if it couldn't be
produced."
  (unless snippet (message "Processing ConTeXt file %s..." texfile))
  (let* (;; TODO bibtex compiler options?
         (process org-context-pdf-process)
         ;; TODO bibtex spec?
         (log-buf-name "*Org PDF ConTeXt Output*")
         (log-buf (and (not snippet) (get-buffer-create log-buf-name)))
         (outfile (org-compile-file texfile process "pdf"
                                    (format "See %S for details" log-buf-name)
                                    log-buf )))
    (unless snippet
      (when org-context-remove-logfiles
        (mapc #'delete-file
              (directory-files
               (file-name-directory outfile)
               t
               (concat (regexp-quote (file-name-base outfile))
                       "\\(?:\\.[0-9]+\\)?\\."
                       (regexp-opt org-context-logfiles-extensions))
               t)))
      ;; LaTeX warnings should be close enough to ConTeXt warnings
      (let ((warnings (org-latex--collect-warnings log-buf)))
        (message (concat "PDF file produced"
                         (cond
                          ((eq warnings 'error) " with errors.")
                          (warnings (concat " with warnings: " warnings))
                          (t "."))))))
    ;; Return output file name.
    outfile))

(provide 'ox-context)
