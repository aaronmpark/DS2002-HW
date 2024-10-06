
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

uri = "mongodb+srv://aaronprk2004:1uRGtfRfR5GVVyyo@cluster0.g5ymo.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = MongoClient(uri, server_api=ServerApi('1'))

try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)


db = client['sample_mflix']
collection = db['movies']

action_movie = collection.find_one({"genres": "Action"})
movies_after_2000 = collection.find({"year": {"$gt": 2000}}).limit(5)
high_rated_movies = collection.find({"imdb.rating": {"$gt": 8.5}}).limit(5)
action_adventure_movies = collection.find({"genres": {"$all": ["Action",
"Adventure"]}}).limit(5)

sorted_comedy_movies = collection.find({"genres": "Comedy"}).sort("imdb.rating", -
1).limit(5)
sorted_drama_movies = collection.find({"genres": "Drama"}).sort("year", 1).limit(5)



avg_rating_by_genre = collection.aggregate([
 {"$unwind": "$genres"},
 {"$group": {"_id": "$genres", "avg_rating": {"$avg": "$imdb.rating"}}},
 {"$sort": {"avg_rating": -1}},
 {"$limit": 5}
])
top_directors = collection.aggregate([
 {"$group": {"_id": "$directors", "avg_rating": {"$avg": "$imdb.rating"}}},
 {"$sort": {"avg_rating": -1}},
 {"$limit": 5}
])
movies_per_year = collection.aggregate([
 {"$group": {"_id": "$year", "total_movies": {"$sum": 1}}},
 {"$sort": {"_id": 1}}
])

collection.update_one({"title": "The Godfather"}, {"$set": {"imdb.rating": 9.5}})
collection.update_many({"genres": "Horror", "imdb.rating": {"$exists": False}}, {"$set":
{"imdb.rating": 6.0}})
collection.delete_many({"year": {"$lt": 1950}})

# Create a text index on the title field
collection.create_index([("title", "text")])
# Find movies with 'love' in the title
love_movies = collection.find({"$text": {"$search": "love"}})
# Text search across title and plot, sorted by IMDb rating
collection.create_index([("title", "text"), ("plot", "text")])
war_movies = collection.find({"$text": {"$search": "war"}}).sort("imdb.rating", -
1).limit(5)


action_high_rated_movies = collection.find({"genres": "Action", "imdb.rating": {"$gt":
8}}).sort("year", -1)
nolan_movies = collection.find({"directors": "Christopher Nolan", "imdb.rating": {"$gt":
8}}).sort("imdb.rating", -1).limit(3)