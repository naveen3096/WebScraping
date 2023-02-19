import requests
from bs4 import BeautifulSoup
import pandas as pd

url = 'https://www.imdb.com/chart/top/'

response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

movies = soup.select('tbody.lister-list tr')


all_movies = []

for i in range(0,len(movies)):
    movie = movies[i]
    rank = i+1
    title = movie.select_one('td.titleColumn a').get_text().strip()
    year = movie.select_one('td.titleColumn span.secondaryInfo').get_text().strip()
    rating = movie.select_one('td.posterColumn span[name="ir"]').attrs.get('data-value')
    crew = movie.select_one('td.titleColumn a').attrs.get('title')
    users_rating =  movie.select_one('td.posterColumn span[name="nv"]').attrs.get('data-value')
    all_movies.append([rank, title, year, rating, crew, users_rating])
    print(all_movies)
    #print(f"{rank}. {title} {year} {rating} {crew}")


df = pd.DataFrame(all_movies,columns=['Rank', 'Title', 'Year', 'IMDB Rating', 'Crew','Users Rating'])
df.to_excel('movies.xlsx',index=False)

