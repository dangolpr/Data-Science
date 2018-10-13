;;;;------------------------------------------------------------------------------------------------------------------------
;;;;                       	Analysis of Movies Using Different Parameters
;;;;------------------------------------------------------------------------------------------------------------------------
;;;;------------------------------------------------------------------------------------------------------------------------
#lang racket
(require csc151)
(require plot)
;#include <windows.h>
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;                                                         	SECTION A
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;IDENTIFIERS
;[add your own file route to movies.csv]
(define movies (read-csv-file "movies.csv"))
;(define movies (read-csv-file "C:/Users/Jin/Documents/CSC151/movies.csv")) ;Hannah
;(define movies (read-csv-file "/home/hwanghan/Desktop/movies.csv"))
;(define movies (read-csv-file "C:/Users/Haakon/Desktop/School/CSC_151-02_FUNCTIONAL_PROBLEM_SOLVING/movies.csv"))


;;; Procedure:
;;;   title
;;; Parameters:
;;;   movie, a list
;;; Purpose:
;;;   checks whether the third element in a list is a string,
;;;   and if it is it leaves it alone.  Otherwise, it turns it into a string.  
;;; Produces:
;;;   result, a list
(define title
  (lambda (movie)
	(if (string? (cadddr movie))
    	(cadddr movie)
    	(number->string (cadddr movie)))))
(define budget car)
(define summary (section list-ref <> 4))
(define get-country (section list-ref <> 5))
(define date (section list-ref <> 6))
(define revenue (section list-ref <> 7))
(define language caddr)
(define runtime (section list-ref <> 8))
(define rating (section list-ref <> 9))
(define date-place 6)
;;; Procedure:
;;;   every-other
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to return every second element of lst
;;; Produces:
;;;   result, a list
(define every-other
  (lambda (lst)
	(letrec ([kernel (lambda (lst pos len)
                   	(if (= pos len)
                       	null
                       	(if (odd? pos)
                           	(cons (car lst) (kernel (cdr lst) (+ 1 pos) len))
                           	(kernel (cdr lst) (+ 1 pos) len))))])
  	(kernel lst 0 (length lst)))))
;;; Procedure:
;;;   get-genres
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to extract a list of genres from a string that is the 2nd element of lst
;;; Produces:
;;;   result, a list
(define get-genres
  (lambda (lst)
	(letrec ([kernel (lambda (str last pos)
                   	(if (= (string-length str) pos)
                       	(list (substring str last pos))
                       	(if (equal? (string-ref str pos) #\,)
                           	(append (list (substring str last pos)) (kernel str pos (+ pos 1)))
                           	(kernel str last (+ pos 1)))))]
         	[genres (substring (cadr lst) 1 (- (string-length (cadr lst)) 1))])
  	(every-other (kernel genres 0 0)))))
;;; Procedure:
;;;   get-genres
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to extract a list of countries from a string that is the 6th element of lst
;;; Produces:
;;;   result, a list
(define get-production-countries
  (lambda (lst)
	(letrec ([kernel (lambda (str last pos)
                   	(if (= (string-length str) pos)
                       	(list (substring str last pos))
                       	(if (equal? (string-ref str pos) #\,)
                           	(append (list (substring str last pos)) (kernel str pos (+ pos 1)))
                           	(kernel str last (+ pos 1)))))]
         	[genres (substring (list-ref lst 5) 1 (- (string-length (list-ref lst 5)) 1))])
  	(every-other (kernel genres 0 0)))))
;;; Procedure:
;;;   get-movie
;;; Parameters:
;;;   n, a positive integer
;;; Purpose:
;;;   to return the nth element of movievec
;;; Produces:
;;;   movie, a list
(define get-movie
  (lambda (n)
	(vector-ref movievec n)))
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;STRING->NUMBER
;;; Procedure:
;;;   char->int
;;; Parameters:
;;;   char, a character
;;; Purpose:
;;;   to return the integer that a character represents
;;; Produces:
;;;   n, an integer
(define char->int
  (lambda (char)
	(- (char->integer char) 48)))
;;; Procedure:
;;;   string->number-(n)
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   to turn parts of str into a number
;;; Produces:
;;;   n, an integer
(define string->number-1 ;converts the month "(M)M"->(M)M
  (lambda (str)
	(if (equal? (string-ref str 1) #\/)
    	(char->int (string-ref str 0))
    	(+ (* (char->int (string-ref str 0)) 10) (char->int (string-ref str 1))))))

(define string->number-2 ;converts the day "(D)D"->(D)D
  (lambda (str)
	(if (equal? (string-ref str 1) #\/)
    	(if (equal? (string-ref str 3) #\/)
        	(char->int (string-ref str 2))
        	(+ (* (char->int (string-ref str 2)) 10) (char->int (string-ref str 3))))
    	(if (equal? (string-ref str 4) #\/)
        	(char->int (string-ref str 3))
        	(+ (* (char->int (string-ref str 3)) 10) (char->int (string-ref str 4)))))))

(define string->number-3 ;converts the year "YYYY"->YYYY
  (lambda (str)
	(+ (* 1000 (char->int (string-ref str (- (string-length str) 4))))
   	(* 100 (char->int (string-ref str (- (string-length str) 3))))
   	(* 10 (char->int (string-ref str (- (string-length str) 2))))
   	(* 1 (char->int (string-ref str (- (string-length str) 1)))))))

(define string->number-4 ;converts any number "X...XX"->X...XX
  (lambda (str)
	(if (= 0 (string-length str))
    	0
    	(+ (* (expt 10 (- (string-length str) 1)) (char->int (string-ref str 0)))
       	(string->number-4 (substring str 1))))))
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;DATES
(define datevec (vector 0 31 29 31 30 31 30 31 31 30 31 30))
;;; Procedure:
;;;   days-before
;;; Parameters:
;;;   vec, a vector
;;; Purpose:
;;;   to make each element of vec the sum of the original elements that preceded it
;;; Produces:
;;;   [NO]
(define days-before
  (lambda (vec)
	(letrec
    	([kernel
      	(lambda (vec pos)
        	(when (< pos (vector-length vec))
          	(vector-set! vec pos (+ (vector-ref vec pos) (vector-ref vec (- pos 1))))
          	(kernel vec (+ pos 1))))])
  	(kernel vec 1))))

(days-before datevec)
;;; Procedure:
;;;   date->years
;;; Parameters:
;;;   date, a string
;;; Purpose:
;;;   to turn a string of the form (M)M/(D)D/YYYY into a fraction
;;; Produces:
;;;   years, an exact real number
(define date->years
  (lambda (date)
	(+ (/ (+ (vector-ref datevec (- (string->number-1 date) 1))
         	(string->number-2 date))
      	366)
   	(string->number-3 date))))
;;; Procedure:
;;;   contains-no-dashes
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   to determine if str contains dashes
;;; Produces:
;;;   bool, a boolean
(define contains-no-dashes?
  (lambda (str)
	(or (zero? (string-length str))
    	(and (not (equal? (string-ref str 0) #\-))
         	(contains-no-dashes? (substring str 1))))))

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

;INCLUDE SOME
;;; Procedure:
;;;   is-in
;;; Parameters:
;;;   x, a value
;;;   lst, a list
;;; Purpose:
;;;   to determine if x is an element of lst
;;; Produces:
;;;   bool, a boolean
(define is-in
  (lambda (x lst)
	(and (not (null? lst))
     	(or (equal? x (car lst))
         	(is-in x (cdr lst))))))
(define includes (list 2 3 7 8 9 13 14 15 16 22 23))
;;; Procedure:
;;;   include-some
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to include only certain elements of lst, those with indices of the list includes
;;; Produces:
;;;   result, a list
(define include-some
  (lambda (lst)
	(letrec ([kernel (lambda (lst pos accept)
                   	(if (null? lst)
                       	null
                       	(if (is-in pos accept)
                           	(cons (car lst) (kernel (cdr lst) (+ 1 pos) accept))
                           	(kernel (cdr lst) (+ 1 pos) accept))))])
  	(kernel lst 0 includes))))

(define movies0 (map include-some movies))
;GOOD?
;;; Procedure:
;;;   rated->num
;;; Parameters:
;;;   str
;;; Purpose:
;;;   to turn a string of arbitrary length into the number it represents
;;; Produces:
;;;   n, a number
(define rated->num
  (lambda (str)
	(string->number-4 (substring str 0 (- (string-length str) 1)))))
;;; Procedure:
;;;   good?
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to determine if lst meets several conditions
;;; Produces:
;;;   bool, a boolean
(define good?
  (lambda (lst)
	(and (= (length lst) (length (car movies0)))
     	(let ([date (list-ref lst date-place)]
           	[budget (car lst)]
           	[run (runtime lst)])
       	(and
        	(string? date)
        	(< 7 (string-length date))
        	(contains-no-dashes? date)
        	(<= 100 (rated->num (list-ref lst 10)))
        	(real? budget)
        	(< 0 budget)
        	(real? run)
        	(< 0 run)
        	(< 3 (string-length (cadr lst))))))))

(define movies1 (filter good? movies0))

;LIST->VECTOR
(define movievec (list->vector movies1))
;;; Procedure:
;;;   date-change
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to change the date in string form into the date in fraction form
;;; Produces:
;;;   result, a list
(define date-change
  (lambda (lst)
	(append (take lst date-place) (list (date->years (list-ref lst date-place))) (drop lst (+ date-place 1)))))

;;; Procedure:
;;;   date-change-vec
;;; Parameters:
;;;   vec, a vector
;;;   pos, a positive integer
;;; Purpose:
;;;   to apply date-change to each element in vec greater than or equal to pos
;;; Produces:
;;;   [NO]
(define date-change-vec
  (lambda (vec pos)
	(when (not (>= pos (vector-length vec)))
  	(vector-set! vec pos (date-change (vector-ref vec pos)))
  	(date-change-vec vec (+ 1 pos)))))

(date-change-vec movievec 0)

;;; Procedure:
;;;   release-date-get
;;; Parameters:
;;;   n, an integer
;;; Purpose:
;;;   to find the release date of the nth movie in movievec
;;; Produces:
;;;   n, a number
(define release-date-get
  (o (section list-ref <> date-place)(section vector-ref movievec <>)))


;VECTOR with CHANGED DATE -> LIST with CHANGED DATE
(define movies2 (vector->list movievec))
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;movies1 is the list form
;movievec is the vector form
;movies2 is the list form of the vector movievec
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;                                                          	SECTION B
; 1)  Analyze differences in genre preference, runtime, and revenue within and between ;demographics (language and/or production country).1)  Analyze differences in genre ;preference, runtime, and revenue within and between demographics (language and/or ;production country).
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


;;;;;;;A. Preference of different genres

;;; i)
;;;Procedure
;;; genre?
;;;Parameters
;;; genre, a string
;;;Purpose
;;; to filter movies with genre
;;;Produces
;;; result, a list

(define genre? ; allows users to select the genre they want
  (lambda (genre)
	(let* ([capitalize (string-titlecase genre)])
  	(cond [(not (string? genre))
         	"The genre should be a string"]
        	[(not (string-contains? (reduce string-append possible-genres) capitalize))
         	"Invalid Genre"]
        	[else
         	(filter (o (section string-contains? <> capitalize)
                    	cadr)
                 	movies1)]))))
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final  Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; genre-popularity-lang
;;;Parameters
;;; genre, a string
;;;Purpose
;;; to find the number of genre movies across different languages
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; [no additional]
;;; Postconditions
;;; if genre is a string that does not equal any of the genres in the database, result = “invalid genre”
;;; *the height of the column is dependent on the number of movies across the genres
;;; *x-axis represents the different languages, y-axis represents the frequency of the movies with genre

(define genre-popularity-lang; number of [genre] movies across languages
  (lambda (genre)
	(let* ([capitalize (string-titlecase genre)])
  	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
         	"Invalid Genre"
       	(plot (discrete-histogram
                	(tally-all (map language (genre? genre))))
               	#:width 1500
               	#:title (string-append "No. of" " " genre " " "movies")
               	#:x-label "Languages"
               	#:y-label "Frequency of Movies")))))
;------------------------------------------------------------------------------------------------------------------------------
; ii)
;;;Procedure
;;; language?
;;;Parameters
;;; lang, a string
;;;Purpose
;;; to filter the movies that are in lang
;;;Produces
;;; result, a list
(define language?
  (lambda (lang)
  	(cond [(not (string? lang))
         	"The genre should be a string"]
        	[else
         	(filter (o (section string-contains? <> lang)
                    	language)
                 	movies1)])))

;;;Procedure
;;; make-genre-or-country-good
;;;Parameters
;;; str, a string
;;;Purpose
;;; to output only the genre or the country and remove unnecessary words
;;;Produces
;;; result, a string
(define make-genre-or-country-good
 (lambda (str)
   (substring str 11 (- (string-length str) 2))))
;;; Procedure:
;;;   elements-not-in
;;; Parameters:
;;;   lst1, a list
;;;   lst2, a list
;;; Purpose:
;;;   to return only the elements of lst1 that are not in lst2
;;; Produces:
;;;   result, a list
(define elements-not-in
  (lambda (lst1 lst2)
	(if (null? lst1)
    	null
    	(if (is-in (car lst1) lst2)
        	(elements-not-in (cdr lst1) lst2)
        	(cons (car lst1) (elements-not-in (cdr lst1) lst2))))))
;;; Procedure:
;;;   potential-languages
;;; Parameters:
;;;   [NONE]
;;; Purpose:
;;;   to find every language that is mentioned in movievec
;;; Produces:
;;;   result, a list
(define potential-languages
  (lambda ()
	(letrec ([kernel (lambda (pos)
                   	(if (= pos (vector-length movievec))
                       	null
                     	(let* ([language (language (get-movie pos))]
                            	[lst (kernel (+ 1 pos))])
                      	 
                       	(append (elements-not-in (list language) lst) lst))))])
  	(kernel 0))))

(define possible-languages (potential-languages))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;;Procedure
;;; genres-lang
;;;Parameters
;;; lang, a string
;;;Purpose
;;; to find the frequency of lang movies with different genres
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; lang exists in (potential-languages)
;;; Postconditions
;;; if lang is a string that does not equal any of the languages in the database, result = “invalid language”
;;; *the height of the column is dependent on the number of lang movies across the genres
;;; *x-axis represents the different genres, y-axis represents the frequency of lang movies with genre

(define genres-lang
  (lambda (lang)
 	(if (not (string-contains? (reduce string-append possible-languages) lang))
         	"Invalid Language"
       	(plot (discrete-histogram
                	(tally-all (map make-genre-or-country-good (reduce append (map get-genres (language? lang))))))
               	#:width 1500
               	#:title (string-append "" lang " " )
               	#:x-label "Genres"
               	#:y-label "Frequency of Movies"))))
;-------------------------------------------------------------------------------------------------------------------------------
; iii)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;;Procedure
;;; genre-countries
;;;Parameters
;;; genre, a string
;;;Purpose
;;; to find the frequency of genre movies produced in different countries
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; [no additional]
;;; Postconditions
;;; if genre is a string that does not equal any of the languages in the database, result = “invalid genre”
;;; *the height of the column is dependent on the number of genre movies across countries
;;; *x-axis represents the different production countries, y-axis represents the frequency of movies with genre produced in respective countries

(define genre-countries
  (lambda (genre)
  	(let* ([capitalize (string-titlecase genre)])
  	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
         	"Invalid Genre"
       	(plot (discrete-histogram
                	(tally-all (map make-genre-or-country-good
                           	(reduce append
                                   	(map get-production-countries (genre? genre))))))
       	#:width 1500
               	#:title (string-append genre " " "movies across countries")
               	#:x-label "Production Countries"
               	#:y-label "Frequency of Movies")))))

;;;Procedure
;;; country?
;;;Parameters
;;; country, a string
;;;Purpose
;;; to filter the movies that were produced in country
;;;Produces
;;; result, a list
    
(define country? ; allows users to select the country they want
  (lambda (country)
  	(cond [(not (string? country))
         	"The genre should be a string"]
        	[else
         	(filter (o (section string-contains? <> country)
                    	get-country)
                 	movies1)])))
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; country-genres
;;;Parameters
;;; nation, a string
;;;Purpose
;;; to find the frequency of genre movies produced in nation
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; nation exists in (potential-countries)
;;; Postconditions
;;; *the height of the column is dependent on the number of movies across the genres produced in the nation
;;; *x-axis represents the different genres, y-axis represents the frequency of movies of different genres produced in nation

(define country-genres; frequency of diff. genres of movies produced in [nation]
  (lambda (nation)
 (let* ([capitalize (string-titlecase nation)])
  	(if (not (string-contains? (reduce string-append possible-countries) capitalize))
         	"Invalid Country"
       	(plot (discrete-histogram
                	(tally-all (map make-genre-or-country-good (reduce append (map get-genres (country? nation))))))
            	#:width 1500
               	#:title (string-append "" nation " " )
               	#:x-label "Genres"
               	#:y-label "Frequency of Movies")))))

;--------------------------------------------------------------------------------------------------------------------------
;;;;;;;B. Preference of runtime
;----------------------------------------------------------------------------------------------------------------------



;;; Procedure:
;;;   filter-date
;;; Parameters:
;;;   t1, a positive real number
;;;   t2, a positive real number
;;;   lst, a list of lists
;;; Purpose:
;;;   takes all the lists within the date t1 and t2
;;; Produces:
;;;   result, a list of lists with
;;;  date >= t1 and date <= t2
;;;  t1 >= 1900, t2 < 2018
(define filter-date
  (lambda (t1 t2 lst)
	(filter
    	(conjoin
     	(o (section >= <> t1) date)
     	(o (section <= <> t2) date))
           	lst)))
;------------------------------------------------------------------------------------------------------------------------------
; i)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;; Procedure:
;;;   runtime-lang
;;; Parameters:
;;;   lang, a string
;;;   interval, a positive integer
;;; Purpose:
;;;   to graph the number of lang movies that have length contained in boxes of interval width
;;; Produces:
;;;   plot, a plot
;;; Preconditions
;;;   lang exists in (potential-languages)
;;; Postconditions
;;;   *the height of the column is dependent on the number of movies across the runtimes produced for lang
;;;   *x-axis represents the runtime boxes, y-axis represents the frequency of movies
(define runtime-lang
  (lambda (lang interval)
	(plot (discrete-histogram
       	(tally-all (map (section box <> interval 0) (sort (map runtime (filter (o (section string-contains? <> lang) language) movies1)) <))))
      	#:width 1500
      	#:title (string-append " # of movies between intervals of runtime in" " " lang " " "movies" )
      	#:x-label "Runtime (minutes)"
      	#:y-label "No. of Movies")))
;;; Procedure:
;;;   box
;;; Parameters:
;;;   num, a number
;;;   interval, a number
;;;   current-box, a number
;;; Purpose:
;;;   to return a string that represents the box starting at current-box and interval wide in which num is contained
;;; Produces:
;;;   str, a string
(define box
  (lambda (num interval current-box)
	(if (< num (+ interval current-box))
    	(string-append (number->string current-box) "-" (number->string (+ current-box interval)))
    	(box num interval (+ interval current-box)))))
;;; Procedure:
;;;   average-runtime
;;; Parameters:
;;;   lang, a string
;;; Purpose:
;;;   to return a list containing lang as the first element and the average runtime for movies of that language as the second
;;; Produces:
;;;   result, a list
(define average-runtime
  (lambda (lang)
	(list lang (average (map runtime (filter (o (section string-contains? <> lang) language) movies1))))))
;;; Procedure:
;;;   average
;;; Parameters:
;;;   lst, a list
;;; Purpose:
;;;   to return the average of lst
;;; Produces:
;;;   n, a number
(define average
  (lambda (lst)
	(/ (apply + lst) (length lst))))
;-------------------------------------------------------------------------------------------------------------------------------
; ii)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;; Procedure:
;;;  runtime-across-languages
;;; Parameters:
;;;   [NONE]
;;; Purpose:
;;;   to plot the average runtime of movies in all languages
;;; Produces:
;;;   plot, a plot
;;; Preconditions
;;;   [NO ADDITIONAL]
;;; Postconditions
;;;   *the height of the column is the average runtime for movies of that language
;;;   *x-axis represents the language, y-axis represents the runtime
(define runtime-across-languages
  (lambda ()
	(plot (discrete-histogram
       	(map average-runtime (potential-languages)))
      	#:width 1500
      	#:title "Average Runtime of Movies Between Languages"
      	#:x-label "Languages"
      	#:y-label "Average Runtime (minutes)")))


;-------------------------------------------------------------------------------------------------------------------------------
; iiI)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;; Procedure:
;;;   runtime-country
;;; Parameters:
;;;   country, a string
;;;   interval, an integer
;;; Purpose:
;;;   to graph the number of movies produced in country that have length contained in boxes of interval width
;;; Produces:
;;;   plot, a plot
;;; Preconditions
;;;   country exists in (potential-countries)
;;; Postconditions
;;;   *the height of the column is dependent on the number of movies across the runtimes produced in country
;;;   *x-axis represents the runtime boxes, y-axis represents the frequency of movies
(define runtime-country
  (lambda (country interval)
	(plot (discrete-histogram
       	(tally-all
        	(map (section box <> interval 0)
             	(sort
              	(map runtime (filter (o (section string-contains? <> country)
                                      	(section reduce string-append <>) get-production-countries) movies1)) <))))
      	#:width 1500
      	#:title (string-append "Average Runtime of Movies In" " " country)
      	#:x-label "Runtimes (minutes)"
      	#:y-label "No. of Movies")))

;;; Procedure:
;;;   average-runtime-2
;;; Parameters:
;;;   lang, a string (lang is the production country)
;;; Purpose:
;;;   to return a list containing lang as the first element and the average runtime for movies of that production country as the second
;;; Produces:
;;;   result, a list
(define average-runtime-2
  (lambda (lang)
	(list lang (average (map runtime (filter (o (section string-contains? <> lang) (section reduce string-append <>) get-production-countries) movies1))))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Actual Procedure |||
;;;;;;;; ------------------------------------
;;; Procedure:
;;;  runtime-across-countries
;;; Parameters:
;;;   [NONE]
;;; Purpose:
;;;   to plot the average runtime of movies in all production countries
;;; Produces:
;;;   plot, a plot
;;; Preconditions
;;;   [NO ADDITIONAL]
;;; Postconditions
;;;   *the height of the column is the average runtime for movies produced in that country
;;;   *x-axis represents the country, y-axis represents the runtime
(define runtime-across-countries
  (lambda ()
	(plot (discrete-histogram
       	(map average-runtime-2 (map make-genre-or-country-good (potential-countries))))
      	#:width 1500
#:title  "Average Runtime of Movies in Countries"
      	#:x-label "Countries"
      	#:y-label "Runtime (minutes)")))
;;; Procedure:
;;;   potential-countries
;;; Parameters:
;;;   [NONE]
;;; Purpose:
;;;   to find every country that is mentioned in movievec
;;; Produces:
;;;   result, a list
(define potential-countries
  (lambda ()
	(letrec ([kernel (lambda (pos)
                   	(if (= pos (vector-length movievec))
                       	null
                     	(let* ([countries (get-production-countries (get-movie pos))]
                            	[lst (kernel (+ 1 pos))])
                      	 
                       	(append (elements-not-in countries lst) lst))))])
  	(kernel 0))))
;--------------------------------------------------------------------------------------------------------------------------
;;;;;;;C. Relationship between revenue and i) ratings ii) runtime
;----------------------------------------------------------------------------------------------------------------------

;;;Procedure
;;; ratingss>?
;;;Parameters
;;; rating1, an integer
;;; rating2, an integer
;;;Purpose
;;; to sort the ratings from greatest to lowest
;;;Produces
;;; result, a list

(define ratingss>? ; sorts the ratings from greatest to lowest
  (lambda (rating1 rating2)
	(> (car rating1) (car rating2))))
;-------------------------------------------------------------------------------------------------------------------------------
; i)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; revenue-ratings
;;;Parameters
;;; lang, a string
;;;Purpose
;;; to compare ratings and revenue of movies in lang language
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; lang exists in (potential-languages)
;;; Postconditions
;;; *the ratings are ordered from highest (left) to lowest (right)
;;; *x-axis represents the different ratings, y-axis represents the revenue earned by the movies with the respective ratings

(define revenue-ratings; compares ratings and revenue of [lang] movies
  (lambda (lang)
  (if (not (string-contains? (reduce string-append possible-languages) lang))
         	"Invalid Language"
       	(plot (discrete-histogram
                	(sort (map list (map rating (language? lang)) (map revenue (language? lang)))
                	ratingss>?))
               	#:width 1500
   	#:title (string-append "Ratings and Revenue in" " " lang )
               	#:x-label "Ratings"
               	#:y-label "Revenue"))))

;-------------------------------------------------------------------------------------------------------------------------------
; ii)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; revenue-runtime
;;;Parameters
;;; lang, a string
;;;Purpose
;;; to compare runtime and revenue of movies in lang language
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; lang exists in (potential-languages)
;;; Postconditions
;;; *the runtimes are ordered from longest (left) to shortest (right)
;;; *x-axis represents the different runtimes in minutes, y-axis represents the revenue earned by the movies with the respective runtimes

(define revenue-runtime
  (lambda (lang)
  (if (not (string-contains? (reduce string-append possible-languages) lang))
         	"Invalid Language"
       	(plot (discrete-histogram
                	(sort (map list (map runtime (language? lang)) (map revenue (language? lang)))
                	ratingss>?))
       	#:width 1500
               	#:title (string-append "Runtime and Revenue in" " " lang )
               	#:x-label "Runtime (minutes)"
               	#:y-label "Revenue"))))

;-------------------------------------------------------------------------------------------------------------------------------
; iii)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; revenue-ratings-country
;;;Parameters
;;; country, a string
;;;Purpose
;;; to compare ratings and revenue of movies produced in country
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; country exists in (potential-countries)
;;; Postconditions
;;; *the ratings are ordered from highest (left) to lowest (right)
;;; *x-axis represents the different ratings, y-axis represents the revenue earned by the movies with the respective ratings

(define possible-countries (map make-genre-or-country-good (potential-countries)))

(define revenue-ratings-country
  (lambda (country)
	(let* ([capitalize (string-titlecase country)])
  	(if (not (string-contains? (reduce string-append possible-countries) capitalize))
         	"Invalid Country"
	(plot (discrete-histogram
       	(sort (map list (map rating (country? country)) (map revenue (country? country)))
             	ratingss>?))
	#:width 1500
      	#:title (string-append "Ratings and Revenue in" " " country )
      	#:x-label "Ratings"
      	#:y-label "Revenue")))))

;;;Procedure
;;; revenue-runtime-country
;;;Parameters
;;; country, a string
;;;Purpose
;;; to compare runtime and revenue of movies produced in country
;;;Produces
;;; result, a histogram
;;;Preconditions
;;; country exists in (potential-countries)
;;; Postconditions
;;; *the runtimes are ordered from longest (left) to shortest (right)
;;; *x-axis represents the different runtimes in minutes, y-axis represents the revenue earned by the movies with the respective runtimes

(define revenue-runtime-country
  (lambda (country)
  	(let* ([capitalize (string-titlecase country)])
  	(if (not (string-contains? (reduce string-append possible-countries) capitalize))
         	"Invalid Country"
	(plot (discrete-histogram
       	(sort (map list (map runtime (country? country)) (map revenue (country? country)))
             	ratingss>?))
      	#:width 1500
      	#:title (string-append "Runtime and Revenue in" " " country )
      	#:x-label "Runtime (minutes)"
      	#:y-label "Revenue")))))
;--------------------------------------------------------------------------------------------------------------------------
;;;;;;;D. Ratings and Revenue Across Time
;-------------------------------------------------------------------------------------------------------------------------------
; i)
;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   time-revenue-ratings
;;; Parameters:
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces a graph of movie revenue as a function of ratings between time 1 (t1) to time 2 (t2)
;;; Produces:
;;;   result, a graph
;;; Preconditions:
;;;   t1 < t2
;;;   t1 >= 1900, t2 < 2018
;;; Postconditions:
;;;   result, a graph where x-axis = revenue, y-axis = ratings 
;;;   between t1 and t2

(define time-revenue-ratings; compares ratings and revenue of [lang] movies
  (lambda (t1 t2)
           (plot (lines
                    (sort (map list (map revenue (filter-date t1 t2 movies2)) (map rating (filter-date t1 t2 movies2)))
                    ratingss>?))
                   #:title (string-append "Revenue and Ratings Between"
                                          " " (number->string t1)" ""and" " "  (number->string t2))
                   #:x-label "Revenue"
                   #:y-label "Ratings")))

;-------------------------------------------------------------------------------------------------------------------------------
; ii)
;;;;;;;; -----------------------------------
;;;;;;;; |||| Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   time-runtime-revenue
;;; Parameters:
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces a graph of movie runtime as a function of revenue between time 1 (t1) and time 2 ;;;  (t2)
;;; Produces:
;;;   result, a graph
;;; Preconditions:
;;;   t1 < t2
;;;  t1 => 1900, t2 < 2018
;;; Postconditions:
;;;  result, a graph where x-axis = runtime, y-axis =  revenue
;;;  between t1 and t2

(define time-runtime-revenue; compares ratings and revenue of [lang] movies
  (lambda (t1 t2)
       	(plot (lines
                	(sort (map list (map runtime (filter-date t1 t2 movies2)) (map revenue (filter-date t1 t2 movies2)))
                	ratingss>?))
             	#:title (string-append "Runtime & Revenue Across Time between " (number->string t1) " and " (number->string t2))
               	#:x-label "Runtime"
               	#:y-label "Revenue")))

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

;                                                          	SECTION C
;2) Examine the words used in movie title/summaries to see the change in public  ;identification of various concepts across time (release date).

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;;; Procedure:
;;;   countword-lang-summary-time
;;; Parameters:
;;;   lang, a string
;;;   str, a string
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces the total number of movies between time period 1 (t1) to time 2 (t2)
;;;   and with the inputted language
;;; Produces:
;;;   total, a positive value indicating the total
;;;   number of movies in the filtered list

(define countword-lang-summary-time ;counts freq of movies with language and string-contained in the movie summary from year (t1) to year (t2)
  (lambda (lang str t1 t2) ;language, string, from time 1 (year), to time 2 (year)
	(length
 	(filter-date t1 t2
               	(filter
                	(conjoin
                        	(o (section equal? <> lang) language)
                        	(o (section string-contains? <> str) summary))
                       	movies2)))))

;;; Procedure:
;;;   make-points-time
;;; Parameters:
;;;   lang, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   produces a tally of times that str, string appears for each
;;;   interval, int of time in the given language, lang
;;; Produces:
;;;   * result, a list of lists '((list x1a x2a)(list x1b x2b))
;;;   where x1a = year, x2a = # of times str appears, and
;;;   x1b = year + int
(define make-points-time ;produces a list of lists with the date (year) and freq of words
  (lambda (lang str int) ;language, string, interval # of years (e.g. 1, 5, 10)
	(let kernel ([mov-lst-so-far null];the movies so far that are correct
             	[t1-i 1900] ;time1 initial
             	[t2-i (+ 1900 int)] ;time2, equal to time1 initial + interval
             	[yr-lst-so-far null]) ;the year
  	(if (>= t2-i 2018)
      	(map list (reverse yr-lst-so-far) (reverse mov-lst-so-far))
      	(kernel (cons (countword-lang-summary-time lang str t1-i t2-i) mov-lst-so-far)
              	(+ int t1-i) ;intervals of x years
              	(+ int t2-i)
              	(cons t1-i yr-lst-so-far))))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   lang-time-wordfreq
;;; Parameters:
;;;   lang, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   makes a graph of the number of times str, string appears
;;;   in movies with the given lang, language
;;; Produces:
;;;   result, a graph
;;; Preconditions:
;;;   lang exists in (potential-languages)
;;; Postconditions:
;;;   * lang-time-wordfreq graph, a graph where
;;; 	x-axis = time, y-axis = word frequency
;;;   * points plotted are grouped based on the int, interval inputted in which
;;; 	they fall
(define lang-time-wordfreq
  (lambda (lang str int) 
  (plot (lines (make-points-time lang str int)) 
      #:title (string-append "Word freq over time in" " " lang " " "Movie Summaries")
      #:x-label "Time"
      #:y-label (string-append "Freq. of" " " "'"str "'" " " "in Summary")
      #:y-min 0)))


;-------------------------------------------------------------------------------------------------------------------------------      	 
;;;\\\\\\\PROCEDURE FOR ‘WORD IN COUNTRY-SUMMARY-TIME’\\\\\\\\\

;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces the total number of movies in the movie summary
;;;   between the time period (t1 and t2) and with the inputted nation
;;; Produces:
;;;   total, a positive value indicating the total
;;;   number of movies in the filtered list which has a
;;;   summary that matches the parameter inputs

(define countword-lang-summary-country ;counts freq of movies with language and string-contained in the movie summary from year (t1) to year (t2)
  (lambda (nation str t1 t2)
	(length
 	(filter-date t1 t2
       	(filter
          	(conjoin
           	(o (section string-contains? <> nation) get-country)
           	(o (section string-contains? <> str) summary))
                       	movies2)))))

;;; Procedure:
;;;   make-points-time-summary-country
;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   produces a tally of times that str appears for each
;;;   interval, int of time in the given nation
;;; Produces:
;;;   result, a list of lists '((list x1a x2a)(list x1b x2b))
;;;   where x1a = year, x2a = # of times str appear, and
;;;     	x1b = year + int

(define make-points-time-summary-country ;produces a list of lists with the date (year) and freq of words
  (lambda (nation str int) ;language, string, interval # of years (e.g. 1, 5, 10)
	(let kernel ([mov-lst-so-far null];the movies so far that are correct
             	[t1-i 1900] ;time1 initial
             	[t2-i (+ 1900 int)] ;time2, equal to time1 initial + interval
             	[yr-lst-so-far null]) ;the year
  	(if (>= t2-i 2018)
       	(map list (reverse yr-lst-so-far) (reverse mov-lst-so-far))
       	(kernel (cons (countword-lang-summary-country nation str t1-i t2-i) mov-lst-so-far)
              	(+ int t1-i) ;intervals of x years
              	(+ int t2-i)
              	(cons t1-i yr-lst-so-far))))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   country-time-wordfreq-summary
;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   makes a graph of the number of times str (string) appears
;;;   in the movie summary of movies with the given nation (production country)
;;; Produces:
;;;	result, a graph
;;; Preconditions:
;;;   nation exists in (potential-countries)
;;; Postconditions:
;;;   * country-time-wordfreq-summary graph, a graph where
;;; 	x-axis = time, y-axis = word frequency
;;;   * points plotted are grouped based on the int, interval inputted in which
;;; 	they fall
(define country-time-wordfreq-summary 
  (lambda (nation str int) 
  (plot (lines (make-points-time-summary-country nation str int)) 
      #:title (string-append "Word Freq. Over Time in" " " nation " ""Movie Summaries")
      #:x-label "Time"
      #:y-label (string-append "Freq. of" " " "'"str "'" " " "in Summary")
      #:y-min 0)))

;-------------------------------------------------------------------------------------------------------------------------------
;;;\\\\\\\PROCEDURE FOR WORD IN LANG-TITLE-TIME\\\\\\\\\

;;; Procedure:
;;;   countword-lang-title-time
;;; Parameters:
;;;   lang, a string
;;;   str, a string
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces the total number of movies found in the
;;;   title between the time period (t1 and t2)
;;;   and with the inputted language, lang
;;; Produces:
;;;   result, total count of frequency of movies in language lang and string-contained in the movie
;;; summary from year (t1) to year (t2)
(define countword-lang-title-time
  (lambda (lang str t1 t2)
	(length
 	(filter-date t1 t2
              	(filter
               	(conjoin
                	(o (section equal? <> lang) language)
                	(o (section string-contains? <> str) title))
               	movies2)))))


;;; Procedure:
;;;   make-points-time-title
;;; Parameters:
;;;   lang, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   produces a tally of times that str appears for each
;;;   interval, int of time in the given language, lang
;;; Produces:
;;;   result, a list of lists '((list x1a x2a)(list x1b x2b))
;;;   where x1a = year, x2a = # of times str appear, and
;;;     	x1b = year + int
(define make-points-time-title
  (lambda (lang str int)
	(let kernel ([mov-lst-so-far null]
             	[t1-i 1900] ;time1 initial
             	[t2-i (+ 1900 int)] ;time2, equal to time1 initial + interval
             	[yr-lst-so-far null]) ;the year
  	(if (>= t2-i 2018)
      	(map list (reverse yr-lst-so-far) (reverse mov-lst-so-far))
      	(kernel (cons (countword-lang-title-time lang str t1-i t2-i) mov-lst-so-far)
              	(+ int t1-i) ;intervals of x years
              	(+ int t2-i)
              	(cons t1-i yr-lst-so-far))))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   lang-time-wordfreq-title
;;; Parameters:
;;;   lang, a language
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   makes a graph of the number of times str, string appears
;;;   with the given lang, language 
;;; Produces:
;;;   result, a graph
;;; Preconditions:
;;;   lang exists in (potential-languages)
;;; Postconditions:
;;;   * lang-time-wordfreq-title graph, a graph where
;;; 	x-axis = time, y-axis = word frequency
;;;   * points plotted are grouped based on the int, interval inputted in which
;;; 	they fall
(define lang-time-wordfreq-title 
  (lambda (lang str int) 
  (plot (lines (make-points-time-title lang str int)) 
      #:title  (string-append "Word Freq. Over Time in" " " lang " ""Movie Titles")
      #:x-label "Time"
      #:y-label (string-append "Freq. of the" str "in Title")
      #:y-min 0)))

;-------------------------------------------------------------------------------------------------------------------------------
;;;\\\\\\\PROC FOR WORD IN COUNTRY-TITLE-TIME\\\\\\\\\

;;; Procedure:
;;;   countword-country-title-time
;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   t1, a positive real number
;;;   t2, a positive real number
;;; Purpose:
;;;   produces the total number of movies found in the
;;;   title between the time period (t1 and t2)
;;;   and with the inputted nation
;;; Produces:
;;;   total, a positive value indicating the total
;;;   number of movies that fit the given parameters
(define countword-country-title-time
  (lambda (nation str t1 t2)
	(length
 	(filter-date t1 t2
               	(filter
                 	(conjoin
                  	(o (section string-contains? <> str) title)
                  	(o (section string-contains? <> nation) get-country))  	 
                       	movies2)))))

;;; Procedure:
;;;   make-points-time-title-nation
;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   produces a tally of times that str appears for each
;;;   interval, int of time in the given language, lang
;;; Produces:
;;;   result, a list of lists '((list x1a x2a)(list x1b x2b))
;;;   where x1a = year, x2a = # of times str appear, and
;;;     	x1b = year + int
(define make-points-time-title-nation
  (lambda (nation str int)
	(let kernel ([mov-lst-so-far null];the movies so far that are correct
             	[t1-i 1900] ;time1 initial
             	[t2-i (+ 1900 int)] ;time2, equal to time1 initial + interval
             	[yr-lst-so-far null]) ;the year
  	(if (>= t2-i 2018)
      	(map list (reverse yr-lst-so-far) (reverse mov-lst-so-far))
      	(kernel (cons (countword-country-title-time nation str t1-i t2-i) mov-lst-so-far)
              	(+ int t1-i) ;intervals of x years
              	(+ int t2-i)
              	(cons t1-i yr-lst-so-far))))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------

;;; Procedure:
;;;   nation-time-wordfreq-title
;;; Parameters:
;;;   nation, a string
;;;   str, a string
;;;   int, a positive integer
;;; Purpose:
;;;   makes a graph of the number of times str, string appears
;;;   with the given nation (production country)
;;; Produces:
;;;   result, a graph
;;; Preconditions:
;;;   nation exists in (potential-countries)
;;; Postconditions:
;;;   *nation-time-wordfreq-title graph, a graph where
;;; 	x-axis = time, y-axis = word frequency
;;;   * points plotted are grouped based on the int, interval inputted in which
;;; 	they fall
(define nation-time-wordfreq-title 
  (lambda (nation str int) 
  (plot (lines (make-points-time-title-nation nation str int)) 
      #:title (string-append "Word Freq. Over Time in" " " nation " ""Movie Titles")
      #:x-label "Time"
      #:y-label (string-append "Freq. of " ""str" ""in Title")
      #:y-min 0)))

;-----------------------------------------------------------------------------------------------------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

;                                                          	SECTION D
;3) Recommend movies based on the user’s input of genre, the number of movies they ;want recommended, minimum rating they’d want each of the movies to have, and the ;released date interval.

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;;; Procedure:
;;;   all-genres
;;; Parameters:
;;;   [NONE]
;;; Purpose:
;;;   to find every genre that is mentioned in movievec
;;; Produces:
;;;   result, a list
(define all-genres
  (lambda ()
	(letrec ([kernel (lambda (pos)
                   	(if (= pos (vector-length movievec))
                       	null
                     	(let* ([genres (get-genres (get-movie pos))]
                            	[lst (kernel (+ 1 pos))])
                      	 
                       	(append (elements-not-in genres lst) lst))))])
  	(kernel 0))))
                          	 
(define possible-genres (map make-genre-or-country-good (all-genres)))

;;;Procedure
;;; genre-date?
;;;Parameters
;;; genre, a string
;;; d1, a string that represents the start of the preferred date interval
;;; d2, a string that represents the end of the preferred date interval
;;;Purpose
;;; to filter movies with a certain genre
;;;Produces
;;; result, a list

(define genre-date? ; allows users to select the genre they want
  (lambda (genre d1 d2)
	(let* ([capitalize (string-titlecase genre)])
  	(cond [(not (string? genre))
         	"The genre should be a string"]
        	[(not (string-contains? (reduce string-append possible-genres) capitalize))
         	"Invalid Genre"]
        	[else
         	(filter (o (section string-contains? <> capitalize)
                    	cadr)
                 	(filter-date d1 d2 (map date-change movies1)))]))))

;;;Procedure
;;; movies-with-lang
;;;Parameters
;;; genre, a string
;;; lang, a string
;;; d1, a string that represents the start of the preferred date interval
;;; d2, a string that represents the end of the preferred date interval
;;;Purpose
;;; to filter movies with a certain genre, language and date interval
;;;Produces
;;; result, a list

(define movies-with-lang
  (lambda (genre lang d1 d2)
	(let* ([capitalize (string-titlecase genre)])
	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
    	"Invalid Genre"
	(filter (o (section equal? <> lang)
           	caddr)
        	(genre-date? genre d1 d2))))))

;;;Procedure
;;; min-rating
;;;Parameters
;;; genre, a string
;;; lang, a string
;;; given-rating, a positive integer
;;; d1, a string that represents the start of the preferred date interval
;;; d2, a string that represents the end of the preferred date interval
;;;Purpose
;;; to filter movies with a minimum of given-rating and a minimum of 100 vote counts
;;;Produces
;;; result, a list

(define min-rating
  (lambda (genre lang given-rating d1 d2)
	(let* ([capitalize (string-titlecase genre)])
	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
    	"Invalid Genre"
	(filter
                 	(o (section > <> given-rating)
                    	rating)
        	(movies-with-lang genre lang d1 d2))))))

;;;Procedure
;;; ratings-with-genre
;;;Parameters
;;; genre, a string
;;; lang, a string
;;; given-rating, a positive integer
;;; d1, a string that represents the start of the preferred date interval
;;; d2, a string that represents the end of the preferred date interval
;;;Purpose
;;; to output a nested list with movies and their corresponding ratings
;;;Produces
;;; result, a list

(define ratings-with-genre ; outputs a nested list with movies and their corresponding ratings
  (lambda (genre lang given-rating d1 d2)
	(let* ([capitalize (string-titlecase genre)])
	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
    	"Invalid Genre"
	(let* ([preference (min-rating genre lang given-rating d1 d2)])
  	(map list
       	(map (section list-ref <> 3) preference)
       	(map rating preference)
       	(map (section list-ref <> 4) preference)))))))

;;;Procedure
;;; ratings>?
;;;Parameters
;;; rating1, an integer
;;; rating2, an integer
;;;Purpose
;;; sorts the ratings from greatest to smallest
;;;Produces
;;; result, a list

(define ratings>? ; sorts the ratings from greatest to lowest
  (lambda (rating1 rating2)
	(> (cadr rating1) (cadr rating2))))

;;;;;;;; -----------------------------------
;;;;;;;; ||||  Final Procedure |||
;;;;;;;; ------------------------------------
;;;Procedure
;;; movie-recommender
;;;Parameters
;;; genre, a string
;;; lang, a string
;;; rating, a positive integer
;;; date-initial, a positive four digit integer
;;; date-final, a positive four digit integer
;;; num, a positive integer
;;;Purpose
;;; to recommend num number of lang movies with genre,  a minimum of rating score, and a ;;;date interval from date-initial to date-final
;;;Produces
;;; result, a list of lists
;;; Preconditions
;;; genre exists in (potential-genres)
;;; lang exists in (potential-languages)
;;; date-initial >= 1900, date-final < 2018
;;; Postconditions
;;; the number of lists inside the list = num
;;; each nested list includes the names of the movie and its overview
;;; if not enough data match the parameters, result = "Not enough movies meet your criteria. ;;;You could try changing some of your parameters"


(define movie-recommender
  (lambda (genre lang rating date-initial date-final num)
  	(cond [(not (string? genre))
         	"the genre should be a string"]
        	[else
         	(let* ([capitalize (string-titlecase genre)])
	(if (not (string-contains? (reduce string-append possible-genres) capitalize))
    	"Invalid Genre"
        	(let* ([sorted (sort (ratings-with-genre genre lang rating date-initial date-final) ratings>?)])
          	(cond
        	[( > num (length sorted))
         	"Not enough movies meet your criteria. You could try changing some of your parameters"]
        	[else
         	(take sorted num)]))))])))

;-----------------------------------------------------------------------------------------------------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;                                                          	SECTION E
;4) Recommend movies based on similarity with the user’s inputted movie. Similarity will be weighted from largest to smallest in the respective order: language, genre(s), rating, country of production, date, and runtime
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

(define genre-mult 1000)
(define country-mult 200)
(define language-mult 9500)
(define date-mult 500)
(define runtime-mult 100)
(define rating-mult 500)
;;; Procedure:
;;;   score-similarity
;;; Parameters:
;;;   lst1, a list
;;;   lst2, a list
;;; Purpose:
;;;   to generate a number representing how similar lst1 and lst2 are
;;; Produces:
;;;   score, a number
(define score-similarity
  (lambda (lst1 lst2)
	(+ (genre-score (get-genres lst1) (get-genres lst2))
   	(language-score (language lst1) (language lst2))
   	(country-score (get-production-countries lst1) (get-production-countries lst2))
   	(date-score (date lst1) (date lst2))
   	(runtime-score (runtime lst1) (runtime lst2))
   	(rating-score (rating lst1) (rating lst2)))))

(define genre-score
  (lambda (lst1 lst2)
	(* genre-mult (number-of-similarities lst1 lst2))))

(define country-score
  (lambda (lst1 lst2)
	(* country-mult (number-of-similarities lst1 lst2))))

(define language-score
  (lambda (str1 str2)
	(* language-mult (if (equal? str1 str2)
                     	1
                     	0))))

(define date-score
  (lambda (num1 num2)
	(if (<= (- num1 num2) 1)
    	date-mult
    	(/ date-mult (abs (- num1 num2))))))

(define runtime-score
  (lambda (num1 num2)
	(if (= num1 num2)
    	runtime-mult
    	(/ runtime-mult (abs (- num1 num2))))))

(define rating-score
  (lambda (num1 num2)
	(* rating-mult (- num1 num2))))
;;; Procedure:
;;;   number-of-similarities
;;; Parameters:
;;;   lst1, a list
;;;   lst2, a list
;;; Purpose:
;;;   to find the number of elements in common between lst1 and lst2
;;; Produces:
;;;   num, a number
(define number-of-similarities
  (lambda (lst1 lst2)
	(if (null? lst1)
    	0
    	(if (is-in (car lst1) lst2)
        	(+ 1 (number-of-similarities (cdr lst1) lst2))
        	(number-of-similarities (cdr lst1) lst2)))))
;;; Procedure:
;;;   suggest-movies
;;; Parameters:
;;;   str, a string
;;;   x, an integer
;;; Purpose:
;;;   to return the top x movies that are similar to the movie titled str
;;; Produces:
;;;   result, a list
(define suggest-movies
  (lambda (str x)
	(let ([exists (movie-exists? str)])
  	(if exists
      	(let* ([titles (map title (make-list-of-high-scores (get-movie exists) 0 0))]
            	[titles (reverse titles)])
        	(if (< (length titles) x)
            	titles
            	(take titles x)))
      	(error "This movie is not in the database.  Please try again")))))
;;; Procedure:
;;;   make-list-of-high-scores
;;; Parameters:
;;;   movie, a list
;;;   current-high, a number
;;;   pos, an integer
;;; Purpose:
;;;   to find movies in movievec that have a similarity score higher than current-high
;;; Produces:
;;;   result, a list
(define make-list-of-high-scores
  (lambda (movie current-high pos)
	(let ([score (if (equal? movie (get-movie pos))
                 	0
                 	(score-similarity movie (get-movie pos)))])
  	(if (= pos (- (vector-length movievec) 1))
      	null
      	(if (> score current-high)
          	(cons (get-movie pos) (make-list-of-high-scores movie score (+ 1 pos)))
          	(make-list-of-high-scores movie current-high (+ 1 pos)))))))
;;; Procedure:
;;;   movie-exists
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   to find the position of the movie titled str in movievec
;;; Produces:
;;;   result, #f if the movie doesn’t exist and an integer if it does
(define movie-exists?
  (lambda (str)
	(letrec ([kernel (lambda (str pos)
                   	(and (not (= pos (vector-length movievec)))
                        	(if (equal? (title (get-movie pos)) str)
                            	pos
                            	(kernel str (+ pos 1)))))])
  	(kernel str 0))))
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


