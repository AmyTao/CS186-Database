// Task 2iii

db.movies_metadata.aggregate([
    // TODO: Write your query here
    {
        $project: {
          budget: {
            $cond: {
              if: {
                $or: [
                  { $eq: ["$budget", false] },
                  { $eq: ["$budget", null] },
                  { $eq: ["$budget", ""] },
                  { $eq: ["$budget", undefined] },
                ],
              },
              then: "unknown",
              else: {
                $switch:{ 
                  branches:[
                    {
                      case: { $isNumber: "$budget" },
                      then: { $round: ["$budget", -7] },
                    },
                    {
                      case: {
                        $isNumber: {
                            $toInt: {$trim: { input: "$budget", chars: "USD$ " }},
                        }},
                      then: {$round: [{$toInt: {$trim: { input: "$budget", chars: "USD$ " }}},-7]}
                }]
                }
              }
              }
          }
        }
      },
      {
        $group:{
              _id: "$budget",
              count: {$sum: 1 }
        }
      },
      {
        $project:{
          _id:0,
          budget:"$_id",
          count:1,
        }
      },
      {$sort: { budget: 1 }}

    
]);    