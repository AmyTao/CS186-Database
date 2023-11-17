// Task 0 (Building your first query)

db.ratings.aggregate([
    // TODO: Write your query here
    {$match:{timestamp:{$gte:838857600,$lt:849398400}}},
    {
        $group:{
            _id:"$movieId",
            min_rating:{$min:"$rating"},
            max_rating:{$max:"$rating"},
            count:{$sum:1}//be ranamed
        }
    },
    {$sort: {count:-1,_id:1}},
    {$limit: 10},
    {
        $lookup:{
            from: "movies_metadata",
            localField: "_id",// match our _id
            foreignField: "movieId",// with the "movieId" in movies_metadata
            as: "movies" // Put matching rows into the field "movies"

        }
    },
    {
        $project:{
            _id: 0,//drop
            title:{$first: "$movies.title"},
            num_ratings:"$count", //rename
            max_rating:1,
            min_rating:1
        }
    }

]);
