// Task 3ii

db.credits.aggregate([
    // TODO: Write your query here
    {
        $match:{
            crew:{$elemMatch:{
                "id":5655,
                "job":"Director"
            }}
        }
    },
    {
        $unwind: {path:"$cast",preserveNullAndEmptyArrays:false},
    }, 
    {
        $group:{
            _id:{id:"$cast.id",name:"$cast.name"},
            count:{$sum:1},//be ranamed

        }
    },
    // {
    //     $unwind: {path:"$cast"}
    // }, 
    {
        $project:{
            _id:0,
            count:1,
            id:"$_id.id",
            name:"$_id.name"

        }
    },
    {$sort:{count:-1,id:1}},
    {$limit:5}

]);