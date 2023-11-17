// Task 3i

db.credits.aggregate([
    // TODO: Write your query here
    {
        $unwind: {path:"$cast",preserveNullAndEmptyArrays:false}
    },  
    {
        $project:{
            "_id":0,
            "movieId":1,
            "cast":1
        }
    },
    {
        $match:{
            "cast.id":7624
        }
    },
    {
        $lookup:{
            from: "movies_metadata",
            localField: "movieId",
            foreignField: "movieId",// with the "movieId" in movies_metadata
            as: "movie"
        }
    },
    {
        $project:{
            title:{$first:"$movie.title"},
            release_date:{$first:"$movie.release_date"},
            character:"$cast.character"
        }
    },
    {$sort:{release_date:-1}},

]);