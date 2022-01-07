(deftheme work
  "Created 2019-10-25.")

(custom-theme-set-variables
 'work
 '(ansi-color-faces-vector [default default default italic underline success warning error])
 '(ansi-color-names-vector ["#21242b" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF" "#bbc2cf"])
 '(custom-safe-themes (quote ("428754d8f3ed6449c1078ed5b4335f4949dc2ad54ed9de43c56ea9b803375c23" "0fe9f7a04e7a00ad99ecacc875c8ccb4153204e29d3e57e9669691e6ed8340ce" "423435c7b0e6c0942f16519fa9e17793da940184a50201a4d932eafe4c94c92d" "332e009a832c4d18d92b3a9440671873187ca5b73c2a42fbd4fc67ecf0379b8c" "e7666261f46e2f4f42fd1f9aa1875bdb81d17cc7a121533cad3e0d724f12faf2" "5e0b63e0373472b2e1cf1ebcc27058a683166ab544ef701a6e7f2a9f33a23726" "2d1fe7c9007a5b76cea4395b0fc664d0c1cfd34bb4f1860300347cdad67fb2f9" "70ed3a0f434c63206a23012d9cdfbe6c6d4bb4685ad64154f37f3c15c10f3b90" "f2b83b9388b1a57f6286153130ee704243870d40ae9ec931d0a1798a5a916e76" "1728dfd9560bff76a7dc6c3f61e9f4d3e6ef9d017a83a841c117bd9bebe18613" "2a3ffb7775b2fe3643b179f2046493891b0d1153e57ec74bbe69580b951699ca" "071f5702a5445970105be9456a48423a87b8b9cfa4b1f76d15699b29123fb7d8" "f951343d4bbe5a90dba0f058de8317ca58a6822faa65d8463b0e751a07ec887c" "0713580a6845e8075113a70275b3421333cfe7079e48228c52300606fa5ce73b" "f30aded97e67a487d30f38a1ac48eddb49fdb06ac01ebeaff39439997cbdd869" "a2286409934b11f2f3b7d89b1eaebb965fd63bc1e0be1c159c02e396afb893c8" "ab9456aaeab81ba46a815c00930345ada223e1e7c7ab839659b382b52437b9ea" default)))
 '(highlight-indent-guides-method (quote fill))
 '(org-agenda-files (quote ("/home/gaowei/ORG/src/actions.org" "/home/gaowei/ORG/src/algorithms.org" "/home/gaowei/ORG/src/algorithms_exaples.org" "/home/gaowei/ORG/src/data_science.org" "/home/gaowei/ORG/src/draft.org" "/home/gaowei/ORG/src/flask.org" "/home/gaowei/ORG/src/inbox.org" "/home/gaowei/ORG/src/language_lisp.org" "/home/gaowei/ORG/src/mathematics.org" "/home/gaowei/ORG/src/odiary.org" "/home/gaowei/ORG/src/os.org" "/home/gaowei/ORG/src/processes.org" "/home/gaowei/ORG/src/reference.org" "/home/gaowei/ORG/src/sdiary.org" "/home/gaowei/ORG/src/start.org" "/home/gaowei/ORG/src/text.processing.emacs.org" "/home/gaowei/ORG/src/tickler.org" "/home/gaowei/ORG/src/words.org" "~/Accounting/ledger.bean")))
 '(org-file-apps (quote ((directory . emacs) (auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . default) ("\\.pdf\\'" . default) ("\\.md\\'" . emacs))))
 '(python-shell-completion-native-disabled-interpreters (quote ("pypy" "ipython" "jupyter")))
 '(safe-local-variable-values (quote ((eval progn (pp-buffer) (indent-buffer))))))

(provide-theme 'work)
