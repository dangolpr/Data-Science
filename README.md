# Analyzing Movies Over Time: A Data Science Project

This is the repository that includes the code, written in Scheme for a class project where I and two other classmates designed a program that analyzed and made possible correlations between different aspects of movies from a movie database consisting of over 45,000 movies and also suggested five movies for a user to watch depending on their input of their other preferred movies

The goals of our project were two-fold. First, we wished to visualize differences in the movie industry within and across diverse demographics. Second, we desired to create two algorithms from which the user can receive movie recommendations. In terms of our comparisons, we examined the 1) popularity of different genres 2) runtimes 3) the relationship between revenue and ratings, and 4) the frequency of keywords in movie titles and movie overviews over time. For providing the user movie recommendations, we wrote two algorithms. The first algorithm recommends movies based on the user’s desired genre, minimum movie rating, and release date. The second algorithm recommends movies based on the similarity of the user’s inputted movie. 

The Data

We used “The Movies Dataset” downloaded from kaggle.com.[1]  This movie dataset has metadata for over 45,000 movies from different movie industries across the globe from the early 20th century to present day.  The original dataset consists of 24 columns (e.g. Budget, Genres, Title, etc.). Each row is one movie which includes the respective information from each column. Our dataset includes the following information for each movie: budget, genres, original language, original title, overview, production countries, release date, runtime, revenue, voter average ratings, and voter count. 
We filtered the data such that it meets certain basic criteria for our algorithms.  First, each movie must contain all of the information, so any movies with a length of less than the header list were filtered out immediately.  Each movie also needed to have a date that was a string greater than 7 characters and containing no dashes for the date changing algorithm.  Each movie needed to have at least 100 ratings to reduce bias in recommendations.  They also needed a real number for the budget, a non-empty string of genres, and a non-zero real runtime. 


The Algorithms

1)  Analyze differences in genre preference, runtime, and revenue within and between demographics (language and/or production country).
a)  Preference of different genres (bar graph)
i)  Compare # of movies of a single genre between languages 
    ·     Languages (x-axis), Frequency of movies (y-axis), one graph per genre
ii) Compare # of movies of different genres within a single language
     ·    Genre (x-axis), Frequency of movies (y-axis), one graph per language
iii) Same format in i and ii except using country of production as the 
     comparator instead of language 
b) Preference of runtime
	i) Compare # of movies between intervals of runtime within a single language
    ·     Runtime (x-axis), Frequency of movies (y-axis), one graph per language
ii) Compare average runtime of movies between languages
    ·     Languages (x-axis), Average runtime (y-axis)
iii) Same format in i and ii except using country of production as the   
     comparator instead of language 
c) Relationship between revenue and i) ratings ii) runtime 
i)  Compare revenue and ratings 
    ·    Ratings (x-axis), Revenue (y-axis), one graph per language
ii)  Compare revenue of a movie with its runtime
    ·    Runtime (x-axis), Revenue (y-axis), one graph per language
iii) Same format in i and ii except using country of production as the   
     comparator instead of language
d) Relationship between revenue and i) ratings ii) runtime across time 
    periods
i) Same format as in c.i) and c.ii) except each graph is by time period not 
   language or country of production
2) Examine the words used in movie title/descriptions to see the change in public identification of various concepts across time (release date). 
-The frequency of movies can be compared across language or country of  
             production to make a cross-cultural suggestion of identified concepts.
-Potential keywords of interest:
  ·       Sexuality (i.e. sex, gay, lesbian, - formerly taboo words)
  ·       Terrorist/Terrorism
i) Time (x-axis), Tally of movies with given word contained in title (y-axis), 
   one graph per language and/or country 
ii) Time (x-axis), Tally of movies with given word contained in overview (y-axis)
   one graph per language and/or country
3) Recommend movies based on the user’s input of genre, the number of movies they want recommended, minimum rating they’d want each of the movies to have, and the released date interval.
4) Recommend movies based on similarity with the user’s inputted movie. Similarity will be weighted from largest to smallest in the respective order: language, genre, rating, country of production, date, and runtime.    




Analysis
The following analyses are respectively associated with the algorithm descriptions above (e.g. 1Ai. in the Analysis section refers to 1Ai. in the Algorithms section).

1.A. Preference of Different Genres for Languages and Production Countries
i) Popular movie genres such as “Drama” and “Comedy” had more languages in the x-axis, whereas considerably less popular movie genres such as “Documentary” had far fewer languages in the x-axis. We can also say that the graphs also represented the taste of different demographics to some extent--for example the second greatest number of animated movies were in Japanese, whereas the second greatest number of romance movies were in French. 

ii) Across languages, ‘drama’ and ‘thriller’ were the most popular genres.

iii)  In the movie database, the majority of the movies had US, France, UK and Germany as production countries and thus, across all genres the aforementioned four countries had the tallest bar graphs. However, an insight into the preferences of people living in those countries could be obtained in the sense that we could see that Australia produced the fifth most number of Science Fiction movies while China produced the fifth most number of Action movies. Across countries, ‘drama’ was the most popular genre, usually followed by ‘thriller’.

1.B. Preference of Runtime
i) Most languages have approximately normally distributed curves, which is what one would expect of this type of distribution.  

ii) Most languages have an average runtime of about 110 minutes, which seems reasonable, especially for movies produced in the United States.

iii) For movie runtime, similar trends can be seen for countries, although with some exceptions.  Some countries have very high values for average runtime, which might be surprising for audiences in the United States   For example, the average runtime in Costa Rica is over 150 minutes, whereas the average runtime in most countries is around 110-115 minutes.

1.C Relationship Between Revenue and i) Ratings ii) Runtime Across Language and Country
	i) Across languages, instead of movies with high ratings, movies with mediocre ratings (specifically in between 7.2 to 7.5) seemed to garner the highest revenues. This suggests that the average movie audience tend to watch average movies more.

ii) Across languages, it seems that on average people prefer movies with a runtime between 140 to 150 minutes. These movies garner much higher revenue on average than movies with a very long or very short runtime.

iii) Like in i), movies with a rating of around 7 seemed to gain the most revenue across different production countries. However, when it comes to runtime, increased cultural differences in terms of preferred runtime can be seen across countries. For example, in  countries like the US and India, movies exceeding 140 minutes accrue greater revenue overall. In contrast, in countries like Korea and Russia, greater revenue comes from movies that are under 140 minutes.


1.D Relationship Between Revenue and i.) Ratings ii.) Runtime from 1900-2017
i. The relationship between revenue and ratings over time
From movies taken between 1900 and 2017 in our movie dataset, we can see that there is a general trend of the greater the rating the greater the revenue of the movie. The association between higher revenue and higher ratings would suggest that highly rated movies are more likely to produce a greater amount of income than movies rated poorly. We can see that the rating for movies surpassing a revenue of $1,000,000,000 starts to average out to an approximate rating a little above 7 out of 10. Another insight into the relationship between revenue and ratings that we can see is the wider the range of ratings the smaller the revenue of the movie. In other words, the greater the revenue the more likely the movie will be rated highly, as stated before. However, there are also a large number of movies that do not produce as much revenue but are rated highly. 

ii. The relationship between revenue and runtime over time 
From movies between 1900 and 2017 in our dataset we see that movie revenue is generally greatest around 2 hours for runtime. After more than 2.5 hours the revenue tends to decrease, with few exceptions. There is a range from 1 to 3.3 hours for movies that make equal to or more than $500,000,000.

2. Keywords and their public identification in movie titles and overviews over time
We can see the change in public identification of various concepts across time (release date) when looking at the frequency of that concept noted in movie titles and movie summaries. Furthermore, we suggest that the frequency of movies can be compared across language or country to make a cross-cultural analysis of the identified concepts. In order to examine these keywords, we implemented algorithms which create graphs with the tally of movies (y-axis) that contain the keyword in the movie title or summary as a function of time (x-axis) for the inputted language or country of production. 
 The keywords of interest that we had in mind are words denoting sexuality (e.g. sex, gay, lesbian) and terrorism (e.g. terrorist, terrorism). Regarding words relating to sexuality, we expected that their frequency would be highest only in the late 2000’s and near nonexistent before the year 2000. As for words regarding terrorism, we expected that these keywords would only appear in movies produced in the United States after 2001 (post-9/11). 
For words denoting sexuality in movie summaries of the English language, we found an overall increase in the frequency of these words in the English language after the late 1960’s and especially so in the late 1990’s. The word “sex” appears after 1960 and increase into the 2000’s, while the word “sexy” appears in the mid-1990’s and increases into the 2000’s. Similarly, the word “gay” starts to appear in the late 1990’s. However, the frequency of the word “gay” only appears in the English language. The word “lesbian” only appears twice in English movie summaries after the late 1990’s. The low frequency of words detracts from any suggestions we can make regarding words relating to sexuality in English movies. As for English movie titles, there were no occurrences of the words “sex,” “gay,” or “lesbian.”
If we make a country-comparison of sex-related words, we find an interesting trend. For Chinese, Japanese, and Korean produced movies in the movie summaries there are no occurrences of any word denoting sex that we have mentioned in our analysis. In contrast, in France, and especially so in the U.S., these words are prevalent in movie summaries from the late 1900’s and increasing into the 2000’s. The absence of sex-related words in East Asian countries may reflect the generally more conservative culture which does not as openly identify these sex-related concepts compared to Western countries such as the U.S. and France. However, our finding of more movies denoting sex in Western countries than East Asian may also be due to our smaller sample size of movies not produced in the U.S. 
For words denoting terrorism, we found that movies with the word “terrorism” or “terrorist”  in the movie summary appear in the late 1990’s and peak into the 2000’s for movies produced in the U.S. For movies that were not produced in the U.S., such as Japan, India, and Romania for instance, there were no movies listed with the word terrorism in the movie summaries. France had one occurrence of the word “terrorism” in movie summaries and less than four for “terrorist.” The greater number of occurrences of terrorism-related words in U.S. produced movies compared to other countries suggests that the prevalence of the concept of terrorism, particular to the U.S., has indeed influenced the U.S. movie industry. As for movie titles, “terrorism” and “terrorist” do not appear in any movie titles under the English language or movies with the U.S. as the country of production.
From cross-examining across movies’ language and country of production, we can see that the frequency of words denoting sexuality and terrorism may demonstrate changes in people’s public identification of these concepts. Increasing from the late 1900’s into the 2000’s, word frequency denoting sex in the English language and the U.S. has increased over time, and terrorism has also increased in movie summaries for U.S. produced movies. Thus, both the greater identification over time with the concept of sex/sexuality in English and sex/sexuality and terrorism in the U.S. is observable with changes in the movie industry. However, we cannot make strong conclusions of our findings as well as specific keywords relating to these concepts due to our small sample size. 



Algorithms #3 and #4 are algorithms that recommend movies to the user. We could not draw much analysis from them, thus we have provided output examples below.

3. Movie Recommender

Examples:
;> (movie-recommender "Crime" "fr" 7 1920 1970 1)
;'(("Bande à part" 7.5 "Two crooks with a fondness for old Hollywood B-movies convince a languages student to help them commit a robbery."))

;>(movie-recommender "Action" "en" 7 1920 1990 1)
;'(("The Empire Strikes Back"
;   8.2
;   "The epic saga continues as Luke Skywalker, in hopes of defeating the evil Galactic ;Empire, learns the ways of the Jedi from aging master Yoda. But Darth Vader is more ;determined than ever to capture Luke. Meanwhile, rebel leader Princess Leia, cocky Han ;Solo, Chewbacca, and droids C-3PO and R2-D2 are thrown into various stages of capture, ;betrayal and despair."))

4. Similarity Recommendations
Examples:
> (suggest-movies "Star Wars" 2)
'("Dragonball Evolution" "Starship Troopers 2: Hero of the Federation")

> (suggest-movies "8 femmes" 2)
'("Arsène Lupin" "Les Rivières pourpres")


Instructions for Running the Code

The user needs to first put their own path to the movies database in the define movies section.
1. Lists of genres, countries, and languages that are acceptable can be found by checking the value of possible-genres, possible-countries, and possible-languages, respectively.
2. (genre-popularity-lang genre) requires an acceptable genre and shows the number of movies of the selected genre across different languages.
3. (genres-lang lang) requires an acceptable language and shows the number of movies of the selected language across different genres.
4. (genre-countries genre) requires an acceptable genre and shows the number of movies of the selected genre across different countries.
5. (country-genres nation) requires an acceptable country and shows the number of movies of the selected country across different genres.
6. (runtime-lang lang interval) requires an acceptable language and a reasonable box width, like 1, 5, or 10 and shows the number of movies of the selected language that have runtimes that fall into boxes of the chosen width.
7. (runtime-across-languages) can just be used.
8. (runtime-country country interval) requires an acceptable country and a reasonable box width, like 1, 5, or 10 and shows the number of movies of the selected country that have runtimes that fall into boxes of the chosen width.
9. (runtime-across-countries) can just be used.
10. (revenue-ratings lang) requires an acceptable language and graphs revenue vs. ratings for the selected language.
11. (revenue-runtime lang) requires an acceptable language and graphs revenue vs. runtime for the selected language.
12. (revenue-ratings-country country) requires an acceptable country and graphs revenue vs. ratings for the selected country.
13. (revenue-runtime-country country) requires an acceptable country and graphs revenue vs. runtime for the selected country.
14. (time-revenue-ratings t1 t2) requires t1<t2 and graphs revenue vs. ratings for the selected time period.
15. (time-runtime-revenue t1 t2) requires t1<t2 and graphs runtime vs. revenue for the selected time period.
16. (lang-time-wordfreq lang str int) requires an acceptable language, the string to be checked, and a reasonable box width, like 1, 5, or 10, and shows the frequency of the string in the overview of movies of the selected language in chunks of time that are int wide from 1900-2017.
17. (country-time-wordfreq-summary nation str int) requires an acceptable country, the string to be checked, and a reasonable box width, like 1, 5, or 10, and shows the frequency of the string in the overview of movies produced in the selected country in chunks of time that are int wide from 1900-2017.
18. (lang-time-wordfreq-title lang str int) requires an acceptable language, the string to be checked, and a reasonable box width, like 1, 5, or 10, and shows the frequency of the string in the title of movies of the selected language in chunks of time that are int wide from 1900-2017.
19. (nation-time-wordfreq-title nation str int) requires an acceptable country, the string to be checked, and a reasonable box width, like 1, 5, or 10, and shows the frequency of the string in the title of movies produced in the selected country in chunks of time that are int wide from 1900-2017.
20. (movie-recommender genre lang rating date-initial date-final num) requires an acceptable genre, and acceptable language, a rating between 0 and 10, an initial date past 1900, a final date before 2018, and a positive number of movies.  It will then recommend num movies that have genre genre, language lang, a rating above rating, and were released between date-initial and date-final.
21. (suggest-movies str x) requires str to be a movie in the dataset and a positive integer.  If a movie titled str is in the dataset it will return up to x movies that most resemble the movie titled str.  

