(setq doom-theme 'doom-gruvbox)

(xterm-mouse-mode 1)
(beacon-mode 1)
(global-auto-revert-mode 1)
(whitespace-mode -1)
(display-time-mode 1)
(display-battery-mode 1)
(global-subword-mode 1)
(global-auto-revert-mode 1)
(evil-snipe-override-mode 1)
(ivy-posframe-mode 1)
(save-place-mode 1)
(centered-window-mode 0) ;; I Have my emacs in the perfect layout, centered on the screen in the w, but if you wish to start with it, set it.
(global-hide-mode-line-mode 1) ;;hides modeline, is toggleable if needed
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(setq doom-font (font-spec :family "JetBrains Mono" :size 12)
      doom-big-font (font-spec :family "JetBrains Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "CMU Serif" :size 12)
      )

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)
  '(font-lock-variable-name-face :slant italic)
  )

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(setq global-auto-revert-non-file-buffers t
      hscroll-margin 1
      scroll-margin 5
      scroll-preserve-screen-position t
      auto-save-default t
      company-idle-delay 0
      company-minimum-prefix-length 2
      evil-vsplit-window-right t
      evil-split-window-below t
      evil-ex-substitute-global t
      evil-move-cursor-back nil
      evil-kill-on-visual-paste nil
      display-line-numbers-type 'relative
      which-key-idle-delay 0.2
      undo-limit 80000000
      delete-by-moving-to-trash t
      trash-directory "~/Trash/" ;; all files deleted by dired are moved to trash
      browse-url-generic-program "brave-browser"
      mouse-wheel-scroll-amount '(1 ((shift) . 1)) ;; one line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      mouse-wheel-follow-mouse 't ;; scroll window under mouse
      scroll-step 1
      minimap-window-location 'right
      doom-modeline-height 15
      doom-modeline-bar-width 5
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t ;; adds folder icon next to persp name
      +zen-text-scale 1.2
      evil-snipe-scope 'visible
      evil-snipe-auto-scroll t
      evil-snipe-repeat-keys t
      right-fringe-width 10
      evil-insert-state-cursor '(box "#83a598") ;; alternative '((bar . 5) #color)
      evil-normal-state-cursor '(box "#ebdbb2")
      +global-word-wrap-mode t
      rainbow-mode t
      TeX-source-correlate-start-server t
      terminal-here-linux-terminal-command '("alacritty")
      )

;; everything emacs-level-related uses the space prefix key
;; this also involves not using emacs terminals, if you happen to need a terminal, pop open the system one.
;; never use splits/workspaces, use the windowmanager for that.
(map! :leader
      :desc "dired home" "d" 'dired-jump

      (:prefix ("w" . "window")
       :desc "delete other windows" "O" 'delete-other-windows
       :desc "window undo" "z" 'winner-undo
       :desc "window undo" "Z" 'winner-redo
       :desc "fullscreen" "F" 'toggle-frame-fullscreen
       )

      (:prefix ("o" . "open")
       :desc "eww" "e" 'eww
       :desc "browser bookmarks" "b" (lambda () (interactive) (browser-bookmark-select))
       :desc "show in desktop" "s" 'virus-show-in-desktop
       :desc "open terminal here" "x" 'terminal-here
       )

      (:prefix ("t" . "toggle")
       :desc "line numbers" "l" 'doom/toggle-line-numbers
       :desc "cursor line highlight global" "H" 'global-hl-line-mode
       :desc "truncate lines" "t" 'toggle-truncate-lines
       :desc "transparency" "T" 'toggle-transparency
       :desc "minimap-mode" "m" 'minimap-mode
       :desc "mixed pitch font" "F" 'mixed-pitch-mode
       :desc "Completion preview" "C" 'global-company-mode
       :desc "Load new theme" "e" 'counsel-load-theme
       :desc "Line spacing" "S" 'toggle-line-spacing
       :desc "center window mode" "W" 'centered-window-mode
       :desc "modeline" "M" 'global-hide-mode-line-mode
       )

      (:prefix ("c" ."code")
               (:prefix ("h" . "Help info from Clippy")
                :desc "Clippy describes function under point" "f" 'clippy-describe-function
                :desc "Clippy describes variable under point" "v" 'clippy-describe-variable
                )
               )

      (:prefix ("f" . "file")
       :desc "fuzzy find" "F" (lambda () (interactive) (counsel-fzf))
       :desc "find" "f" 'counsel-find-file
       )

      (:prefix ("b" . "buffer")
       :desc "save" "s" 'basic-save-buffer
       :desc "switch" "b" '+ivy/switch-buffer
       :desc "kill" "d" 'kill-current-buffer
       :desc "save & kill" "c" 'doom/save-and-kill-buffer
       )
      )

;; add keybinds to localleader when in specific mode
(map! :map org-mode-map
      :after org
      :localleader
      (:prefix ("c" . "clock")
       :desc "set fixed timer" "s" 'org-timer-set-timer
       :desc "pause-or-continue" "p" 'org-timer-pause-or-continue
       :desc "timer start" "S" 'org-timer-start
       :desc "timer stop" "P" 'org-timer-stop
       )
      :desc "header numbers" "N" 'org-num-mode
      )

(map! :map dired-mode-map
      :after dired
      :localleader
      "l" 'dired-downcase
      "u" 'dired-upcase
      "." 'dired-mark-extension
      "/" 'dired-mark-directories
      "d" 'epa-dired-do-decrypt
      "e" 'epa-dired-do-encrypt
      "f" 'dired-do-find-regexp-and-replace
      "r" 'dired-do-rename-regexp
      "m" 'dired-mark-files-regexp
      "h" 'dired-omit-mode
      "d" 'virus-show-in-desktop
      )
;;;; virus hotkeys

(defun virus-dired-sort ()
  "Sort dired dir listing in different ways.
Prompt for a choice."
  (interactive)
  (let (xsortBy xarg)
    (setq xsortBy (completing-read "Sort by:" '( "date" "size" "name" )))
    (cond
     ((equal xsortBy "name") (setq xarg "-Al "))
     ((equal xsortBy "date") (setq xarg "-Al -t"))
     ((equal xsortBy "size") (setq xarg "-Al -S"))
     ((equal xsortBy "dir") (setq xarg "-Al --group-directories-first"))
     (t (error "logic error 09535" )))
    (dired-sort-other xarg )))

(defun virus-select-line ()
  "Select current line. If region is active, extend selection downward by line."
  (interactive)
  (if (evil-visual-line)
      (evil-next-line)
    (evil-visual-line)
    ))

(defun virus-next-match ()
  (interactive)
  (evil-ex-search-next)
  (evil-scroll-line-to-center nil)
  )

(defun virus-previous-match ()
  (interactive)
  (evil-ex-search-previous)
  (evil-scroll-line-to-center nil)
  )

(defun virus-page-up ()
  (interactive)
  (evil-scroll-page-up 1)
  (evil-scroll-line-to-center nil)
  )

(defun virus-page-down ()
  (interactive)
  (evil-scroll-page-down 1)
  (evil-scroll-line-to-center nil)
  )

(defun virus-change-word ()
  "change word at point."
  (interactive)
  (let* ((p (point))
         (beg (+ p   (skip-syntax-backward "w")))
         (end (+ beg (skip-syntax-forward  "w"))))
    (kill-region beg end))
  (evil-insert nil)
  )

(defun virus-show-in-desktop ()
  "Show current file in desktop."
  (interactive)
  (let (($path (if (buffer-file-name) (buffer-file-name) default-directory)))
    (cond
     ((string-equal system-type "windows-nt")
      (shell-command (format "PowerShell -Command Start-Process Explorer -FilePath %s" (shell-quote-argument default-directory)))
      )
     ((string-equal system-type "darwin")
      (if (eq major-mode 'dired-mode)
          (let (($files (dired-get-marked-files )))
            (if (eq (length $files) 0)
                (shell-command (concat "open " (shell-quote-argument (expand-file-name default-directory ))))
              (shell-command (concat "open -R " (shell-quote-argument (car (dired-get-marked-files )))))))
        (shell-command
         (concat "open -R " (shell-quote-argument $path)))))

     ((string-equal system-type "gnu/linux")
      (let (
            (process-connection-type nil)
            (openFileProgram (if (file-exists-p "/usr/bin/gvfs-open")
                                 "/usr/bin/gvfs-open"
                               "/usr/bin/xdg-open")))
        (start-process "" nil openFileProgram (shell-quote-argument $path)))
      ))))

;; very minor adjustments. I am very against changeing the basic commands. Remain bare bones and minimalist do not add bloat ontop of what is already there.
(evil-define-key nil evil-normal-state-map
  (kbd "*") 'evil-record-macro
  (kbd "D") 'evil-delete-whole-line
  (kbd "C") 'evil-change-whole-line
  (kbd "U") 'evil-redo
  (kbd "s") 'virus-change-word
  (kbd "q") 'evilem-motion-find-char ;; mnemonic: "query"
  (kbd "Q") 'evilem-motion-find-char-backward ;; mnemonic: "query"
  (kbd "g x") 'evil-exchange
  (kbd "C-u") 'virus-page-up
  (kbd "C-d") 'virus-page-down
  (kbd "g d") '+lookup/definition
  (kbd "g D") '+lookup/references
  (kbd "g b") 'beginning-of-buffer
  (kbd "g B") 'end-of-buffer
  (kbd "g k") 'beginning-of-defun
  (kbd "g j") 'end-of-defun
  (kbd "g o") 'evil-jump-backward
  (kbd "g O") 'evil-jump-forward
  (kbd "g t") '+lookup/type-definition
  (kbd "g a") '+default/diagnostics
  (kbd "g C") '+ivy/compile
  (kbd "g e") '+eval/buffer-or-region
  (kbd "g E") '+eval:replace-region
  (kbd "g i") 'evil-jump-item
  (kbd "g I") '+lookup/implementations
  (kbd "g l") '+lookup/documentation
  (kbd "g r") 'query-replace
  (kbd "g R") 'query-replace-regexp
  (kbd "g z") 'evil-scroll-line-to-center
  (kbd "g f") '+format/region-or-buffer
  (kbd "g Q") 'evil-fill-and-move
  )

;; very minor adjustments
(evil-define-key nil evil-visual-state-map
  (kbd "*") 'evil-record-macro
  (kbd "D") 'evil-delete-whole-line
  (kbd "C") 'evil-change-whole-line
  (kbd "U") 'evil-redo
  (kbd "s") 'virus-change-word
  (kbd "q") 'evilem-motion-find-char ;; mnemonic: "query"
  (kbd "Q") 'evilem-motion-find-char-backward ;; mnemonic: "query"
  (kbd "g x") 'evil-exchange
  (kbd "C-u") 'virus-page-up
  (kbd "C-d") 'virus-page-down
  (kbd "g d") '+lookup/definition
  (kbd "g D") '+lookup/references
  (kbd "g b") 'beginning-of-buffer
  (kbd "g B") 'end-of-buffer
  (kbd "g k") 'beginning-of-defun
  (kbd "g j") 'end-of-defun
  (kbd "g o") 'evil-jump-backward
  (kbd "g O") 'evil-jump-forward
  (kbd "g t") '+lookup/type-definition
  (kbd "g a") '+default/diagnostics
  (kbd "g C") '+ivy/compile
  (kbd "g e") '+eval/buffer-or-region
  (kbd "g E") '+eval:replace-region
  (kbd "g i") 'evil-jump-item
  (kbd "g I") '+lookup/implementations
  (kbd "g l") '+lookup/documentation
  (kbd "g r") 'query-replace
  (kbd "g R") 'query-replace-regexp
  (kbd "g z") 'evil-scroll-line-to-center
  (kbd "g f") '+format/region-or-buffer
  (kbd "g Q") 'evil-fill-and-move
  )

;; very minor adjustments
(evil-define-key nil evil-motion-state-map
  (kbd "*") 'evil-record-macro
  (kbd "D") 'evil-delete-whole-line
  (kbd "C") 'evil-change-whole-line
  (kbd "U") 'evil-redo
  (kbd "s") 'virus-change-word
  (kbd "q") 'evilem-motion-find-char ;; mnemonic: "query"
  (kbd "Q") 'evilem-motion-find-char-backward ;; mnemonic: "query"
  (kbd "g x") 'evil-exchange
  (kbd "C-u") 'virus-page-up
  (kbd "C-d") 'virus-page-down
  (kbd "g d") '+lookup/definition
  (kbd "g D") '+lookup/references
  (kbd "g b") 'beginning-of-buffer
  (kbd "g B") 'end-of-buffer
  (kbd "g k") 'beginning-of-defun
  (kbd "g j") 'end-of-defun
  (kbd "g o") 'evil-jump-backward
  (kbd "g O") 'evil-jump-forward
  (kbd "g t") '+lookup/type-definition
  (kbd "g a") '+default/diagnostics
  (kbd "g C") '+ivy/compile
  (kbd "g e") '+eval/buffer-or-region
  (kbd "g E") '+eval:replace-region
  (kbd "g i") 'evil-jump-item
  (kbd "g I") '+lookup/implementations
  (kbd "g l") '+lookup/documentation
  (kbd "g r") 'query-replace
  (kbd "g R") 'query-replace-regexp
  (kbd "g z") 'evil-scroll-line-to-center
  (kbd "g f") '+format/region-or-buffer
  (kbd "g Q") 'evil-fill-and-move
  )

(with-eval-after-load 'evil-org
  (evil-define-key '(normal visual motion) evil-org-mode-map
  (kbd "*") 'evil-record-macro
  (kbd "D") 'evil-delete-whole-line
  (kbd "C") 'evil-change-whole-line
  (kbd "U") 'evil-redo
  (kbd "s") 'virus-change-word
  (kbd "q") 'evilem-motion-find-char ;; mnemonic: "query"
  (kbd "Q") 'evilem-motion-find-char-backward ;; mnemonic: "query"
  (kbd "g x") 'evil-exchange
  (kbd "C-u") 'virus-page-up
  (kbd "C-d") 'virus-page-down
  (kbd "g d") '+lookup/definition
  (kbd "g D") '+lookup/references
  (kbd "g b") 'beginning-of-buffer
  (kbd "g B") 'end-of-buffer
  (kbd "g k") 'beginning-of-defun
  (kbd "g j") 'end-of-defun
  (kbd "g o") 'evil-jump-backward
  (kbd "g O") 'evil-jump-forward
  (kbd "g t") '+lookup/type-definition
  (kbd "g a") '+default/diagnostics
  (kbd "g C") '+ivy/compile
  (kbd "g e") '+eval/buffer-or-region
  (kbd "g E") '+eval:replace-region
  (kbd "g i") 'evil-jump-item
  (kbd "g I") '+lookup/implementations
  (kbd "g l") '+lookup/documentation
  (kbd "g r") 'query-replace
  (kbd "g R") 'query-replace-regexp
  (kbd "g z") 'evil-scroll-line-to-center
  (kbd "g f") '+format/region-or-buffer
  (kbd "g Q") 'evil-fill-and-move
    )
  )

(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map
    (kbd "j") 'evil-next-line
    (kbd "k") 'evil-previous-line
    (kbd "M-RET") 'dired-display-file
    (kbd "h") 'dired-up-directory
    (kbd "DEL") 'dired-up-directory
    (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
    (kbd "RET") 'dired-open-file ; use dired-find-file instead of dired-open.
    (kbd "m") 'dired-mark
    (kbd "t") 'dired-toggle-marks
    (kbd "M") 'dired-unmark
    (kbd "c") 'dired-do-copy
    (kbd "r") 'dired-do-rename
    (kbd "d") 'dired-do-delete
    (kbd "f") 'dired-create-empty-file
    (kbd "+") 'dired-create-directory
    (kbd "x") 'dired-do-chmod
    (kbd "w") 'dired-do-chown
    (kbd "p") 'dired-do-print
    (kbd "r") 'dired-do-rename
    (kbd "T") 'dired-do-touch
    (kbd "y") 'dired-copy-filenamecopy-filename-as-kill ;; copies filename to kill ring.
    (kbd "z") 'dired-do-compress
    (kbd ".") 'dired-omit-mode
    (kbd "s") 'virus-dired-sort ;; change sort criteria
    )
  )

(evil-define-key 'normal peep-dired-mode-map
  (kbd "k") 'peep-dired-prev-file
  (kbd "j") 'peep-dired-next-file)

(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; dired omit hides dotfiles etc
(setq dired-omit-files
      (rx (or (seq bol (? ".") "#")             ;; emacs autosave files
              (seq bol "." (not (any ".")))     ;; dot-files
              (seq "~" eol)                     ;; backup-files
              (seq bol "CVS" eol)               ;; CVS dirs
              )))

;; With dired-open plugin, you can launch external programs for certain extensions, follow the linux philosophy of having one program do one thing well. Additionally, emacs is total assshit at anything other than hanling text. --> graphical stuff is done externally --> more minimal and keeps emacs bloat free. Make sure to have these programs installed and their dependencies (zathura: zathura-pdf-mupdf) and make sure to have my config files for these programs, so the keybindings are consitent.
(setq dired-open-extensions '(
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")
                              ("mp3" . "mpv")
                              ("gif" . "ristretto")
                              ("jpeg" . "ristretto")
                              ("jpg" . "ristretto")
                              ("png" . "ristretto")
                              ("pdf" . "zathura")
                              ("epub" . "zathura")
                              ))

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

(use-package! calfw)
(use-package! calfw-org)
(use-package all-the-icons
  :if (display-graphic-p))


(use-package emojify
  :hook (after-init . global-emojify-mode))

(defun dt/insert-todays-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%A, %B %d, %Y")
                 ((equal prefix '(4)) "%m-%d-%Y")
                 ((equal prefix '(16)) "%Y-%m-%d"))))
    (insert (format-time-string format))))

(require 'calendar)
(defun insert-any-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

(setq ivy-posframe-display-functions-alist
      '((swiper                     . ivy-posframe-display-at-point)
        (complete-symbol            . ivy-posframe-display-at-point)
        (counsel-M-x                . ivy-display-function-fallback)
        (counsel-esh-history        . ivy-posframe-display-at-window-center)
        (counsel-describe-function  . ivy-display-function-fallback)
        (counsel-describe-variable  . ivy-display-function-fallback)
        (counsel-find-file          . ivy-display-function-fallback)
        (counsel-recentf            . ivy-display-function-fallback)
        (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
        (dmenu                      . ivy-posframe-display-at-frame-top-center)
        (nil                        . ivy-posframe-display))
      ivy-posframe-height-alist
      '((swiper . 20)
        (dmenu . 20)
        (t . 10)))

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(after! org
  (evil-org-mode nil)
  (setq org-directory "~/Org"
        org-archive-location "~/Archive/Org/archive.org::"
        org-agenda-files '("~/Org")
        org-hide-emphasis-markers t
        org-log-done 'time
        org-table-convert-region-max-lines 20000
        org-emphasis-alist
        '(("*" (bold))
          ("/" italic)
          ("_" underline)
          ("=" redd)
          ("~" code)
          ("+" (:strike-through t)))

        org-superstar-headline-bullets-list '("◉" "●" "○" "◈" "◆" "◇" )
        org-superstar-prettify-item-bullets t
        org-superstar-item-bullet-alist '((?- . ?•) (?+ . ?❭)) ; changes +/- symbols in item lists
  org-list-demote-modify-bullet '(("+" . "-") ("1." . "a.") ("-" . "+"))
  org-hide-leading-stars t
  org-use-property-inheritance t
  org-priority-highest ?A
  org-priority-lowest ?
  org-fontify-quote-and-verse-blocks t
  org-priority-faces
  '((?A . 'all-the-icons-red)
    (?B . 'all-the-icons-orange)
    (?C . 'all-the-icons-yellow)
    (?D . 'all-the-icons-green)
    (?E . 'all-the-icons-blue))
  org-log-repeat 'time
  org-startup-with-inline-images t
  org-pretty-entities t
  org-pretty-entities-include-sub-superscripts t
  org-startup-indented t
  org-list-allow-alphabetical t
  org-tags-column 0
  org-fold-catch-invisible-edits 'show-and-error
  org-log-done 'time
  org-log-into-drawer 'LOGBOOK
  org-clock-into-drawer t
  org-modules '(ol-habit)
  org-export-headline-levels 5
  org-num-max-level 2
  org-clock-persist 'history
  org-refile-use-outline-path 'file
  org-refile-allow-creating-parent-nodes 'confirm
  org-use-sub-superscripts '{}
  org-clock-mode-line-total 'current
  org-agenda-skip-scheduled-if-done t
  org-agenda-skip-deadline-if-done t
  org-agenda-include-deadlines t
  org-agenda-block-separator nil
  org-agenda-tags-column 0
  org-agenda-compact-blocks t
  org-habit-show-habits-only-for-today t
  org-agenda-show-future-repeats nil
  org-agenda-deadline-faces
  '((1.0 . error)
    (1.0 . org-warning)
    (0.5 . org-upcoming-deadline)
    (0.0 . org-upcoming-distant-deadline))
  org-habit-show-habits t
  )
(setq org-ellipsis "▼")
)

(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 7)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":DAILY:"))))
        ))

;; Tags specify what kind of activity class the item is. TODO is not included, since it is a class with its own states of itself.
(setq org-tag-alist '(("EVENT" . ?e)
                      ("OUTSTANDING" . ?o)
                      ("HABIT" . ?h)
                      ("PROJECT" . ?p)
                      ("WRITE" . ?w)
                      ("READ" . ?r)
                      ("STUDY" . ?s)
                      )
      )

;; Sequence for TASKS
;; TODO means it's an item that needs addressing
;; PROG means is beeing worked on and maybe needs to wait on something else to finish
;; DELEGATED means someone else is doing it and I need to follow up with them
;; ASSIGNED means someone else has full, autonomous responsibility for it
;; CANCELLED means it's no longer necessary to finish
;; OPT: optional means can be done after most important stuff is finished/may becom obsolete
;; DONE means it's complete
(setq org-todo-keywords '((type
                           "TODO(t)"
                           "PROG(i)"
                           "OPT(o)"
                           "REVIEW(r)"
                           "|"
                           "DONE(d!)"
                           "CANC(C@)"
                           "DELEGATED(D@)"
                           "ASSIGNED(a@)"
                           )
                          )
      )

;; org capture templates
;; create templates for each of your projects, in my case: university, personal and work
;; agenda capture template is to capture all appointments centrally in your calendar.
;; journal is for whatever, thoughts n co
(setq org-capture-templates
      '(
        ("t" "TODO @personal"
         entry (file+headline "~/Org/personal_todo.org" "CURRENT")
         "* TODO %? \n"
         :empty-lines 1
         )

        ("e" "EVENT @personal"
         entry (file+headline "~/Org/personal_agenda.org" "EVENTS")
         "* %? :EVENT: \nSCHEDULED: %^T \nLOCATION: \nMATERIAL:"
         :empty-lines 1
         )

        ("j" "JOURNAL @personal"
         entry (file+datetree "~/Org/journal/personal_journal.org")
         "* %?"
         :empty-lines 1
         )

        ("g" "JOURNAL Goals @personal"
         entry (file+datetree "~/Org/journal/personal_journal.org")
         "* Daily Goals \n - %?"
         :empty-lines 1
         )

        ("r" "JOURNAL Reflection @personal"
         entry (file+datetree "~/Org/journal/personal_journal.org")
         "* Reflection \n(Mindset, Methods, Goals, Descisions, Actions)\n%?"
         :empty-lines 1
         )

        ("n" "NOTE @personal"
         entry (file "~/Org/notes/personal_notes.org")
         "* %?\n%U"
         :empty-lines 1
         )

        ("T" "TODO @study"
         entry (file+headline "~/Org/study_todo.org" "NOW")
         "* TODO %?\n"
         :empty-lines 1
         )

        ("E" "EVENT @study"
         entry (file+headline "~/Org/study_agenda.org" "EVENTS")
         "* %? :EVENT: \nSCHEDULED: %^T\nLOCATION: \nMATERIAL:"
         :empty-lines 1
         )

        ("N" "NOTE @study"
         entry (file "~/Org/notes/study_notes.org")
         "* %? \n%U"
         :empty-lines 1
         )

        ("L" "LOG @study"
         table-line (file "~/Org/logs/study_log.org")
         "|%U|%?|"
         :prepend t
         )

        ("d" "TODO @work"
         entry (file+headline "~/Org/work_todo.org" "CURRENT")
         "* TODO %?\n"
         :empty-lines 1
         )

        ("v" "EVENT @work"
         entry (file+headline "~/Org/work_agenda.org" "EVENTS")
         "* %? :EVENT: \nSCHEDULED: %^T \nLOCATION: \nMATERIAL:"
         :empty-lines 1
         )

        ("w" "NOTE @work"
         entry (file "~/Org/notes/work_notes.org")
         "* %? \n%U"
         :empty-lines 1
         )
        )
      )


(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Org/roam/"))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;;comment out the colors if you use another theme and want to use the respective colors
;; font is specified, so that if in
(custom-set-faces!
  '(org-todo                :weight extra-bold :height 1.0 :slant italic :foreground "#cc241d")
  '(org-checkbox            :weight extra-bold :height 1.0 :slant normal :foreground "#98971a")
  '(org-priority            :weight extra-bold :height 1.0 :slant italic :foreground "#fe8019")
  '(org-special-keyword     :weight normal     :height 1.0 :slant italic :foreground "#7c6f62")
  '(org-drawer              :weight normal     :height 1.0 :slant italic :foreground "#7c6f62")
  '(org-tag                 :weight normal     :height 1.0 :slant italic :Foreground "#7c6f62")
  '(org-date                :weight normal     :height 1.0 :slant italic :foreground "#b8bb26")
  '(org-document-title      :weight ultra-bold :height 1.7 :slant normal :foreground "#cc241d")
  '(outline-1               :weight extra-bold :height 1.4 :slant normal :foreground "#458588")
  '(outline-2               :weight bold       :height 1.3 :slant normal :foreground "#98971a")
  '(outline-3               :weight bold       :height 1.2 :slant normal :foreground "#d79921")
  '(outline-4               :weight semi-bold  :height 1.1 :slant normal :foreground "#8ec07c")
  '(outline-5               :weight semi-bold  :height 1.1 :slant normal :foreground "#fe8019")
  '(outline-6               :weight semi-bold  :height 1.1 :slant normal :foreground "#83a598")
  '(outline-8               :weight semi-bold  :height 1.1 :slant normal :foreground "#d3869b")
  '(outline-9               :weight semi-bold  :height 1.1 :slant normal :foreground "#d79921")

  '(markdown-header-face    :weight extra-bold :height 1.7 :slant normal :foreground "#cc241d")
  '(markdown-header-face-1  :weight extra-bold :height 1.7 :slant normal :foreground "#458588")
  '(markdown-header-face-2  :weight bold       :height 1.5 :slant normal :foreground "#98971a")
  '(markdown-header-face-3  :weight bold       :height 1.3 :slant normal :foreground "#d79921")
  '(markdown-header-face-4  :weight semi-bold  :height 1.1 :slant normal :foreground "#8ec07c")
  '(markdown-header-face-5  :weight semi-bold  :height 1.0 :slant normal :foreground "#fe8019")
  '(markdown-header-face-6  :weight semi-bold  :height 1.0 :slant normal :foreground "#83a598")
  '(markdown-header-face-7  :weight semi-bold  :height 1.0 :slant normal :foreground "#d3869b")
  '(markdown-header-face-8  :weight semi-bold  :height 1.0 :slant normal :foreground "#d79921")
  )

(use-package ox-man)
(use-package ox-gemini)

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

;; i prefer reading in zahtura but emacs is also fine
(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (map! :map nov-mode-map
        :n "RET" #'nov-scroll-up)
  (defun doom-modeline-segment--nov-info ()
    (concat
     " "
     (propertize
      (cdr (assoc 'creator nov-metadata))
      'face 'doom-modeline-project-parent-dir)
     " "
     (cdr (assoc 'title nov-metadata))
     " "
     (propertize
      (format "%d/%d"
              (1+ nov-documents-index)
              (length nov-documents))
      'face 'doom-modeline-info)))

  (advice-add 'nov-render-title :override #'ignore)

  (defun +nov-mode-setup ()
    (face-remap-add-relative 'variable-pitch
                             :family "CMU Serif"
                             :height 1.7
                             :width 'semi-expanded)
    (face-remap-add-relative 'default :height 1.5)
    (setq-local line-spacing 0.8
                next-screen-context-lines 4
                shr-use-colors nil)
    (require 'visual-fill-column nil t)
    (setq-local nov-text-width 120)
    (hl-line-mode -1)
    (setq-local visual-fill-column-center-text t
                visual-fill-column-width 121)
    (visual-fill-column-mode 1)

    (add-to-list '+lookup-definition-functions #'+lookup/dictionary-definition)

    (setq-local mode-line-format
                `((:eval
                   (doom-modeline-segment--workspace-name))
                  (:eval
                   (doom-modeline-segment--window-number))
                  (:eval
                   (doom-modeline-segment--nov-info))
                  ,(propertize
                    " %P "
                    'face 'doom-modeline-buffer-minor-mode)
                  ,(propertize
                    " "
                    'face (if (doom-modeline--active) 'mode-line 'mode-line-inactive)
                    'display `((space
                                :align-to
                                (- (+ right right-fringe right-margin)
                                   ,(* (let ((width (doom-modeline--font-width)))
                                         (or (and (= width 1) 1)
                                             (/ width (frame-char-width) 1.0)))
                                       (string-width
                                        (format-mode-line (cons "" '(:eval (doom-modeline-segment--major-mode))))))))))
                  (:eval (doom-modeline-segment--major-mode)))))

  (add-hook 'nov-mode-hook #'+nov-mode-setup)
  )

(use-package! org-super-agenda
  :commands org-super-agenda-mode)
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 6)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Assignments"
                           :tag "Assignment"
                           :order 10)
                          (:name "Issues"
                           :tag "Issue"
                           :order 12)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Research"
                           :tag "Research"
                           :order 15)
                          (:name "To read"
                           :tag "Read"
                           :order 30)
                          (:name "Waiting"
                           :todo "WAITING"
                           :order 20)
                          (:name "University"
                           :tag "uni"
                           :order 32)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))


;; fuck dashboards.
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(add-hook! '+doom-dashboard-functions :append
  (setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))
  )
