// Task 2ii

db.movies_metadata.aggregate([
    {
      $project: {
        _id: 0,
        tagline: {$split: ["$tagline", " "]}
      }
    },
    {
      $unwind: {path:"$tagline",preserveNullAndEmptyArrays:false}
    },
    {
      $project: {
        tagline: {
            $trim: {input: { $toLower: "$tagline" },chars: " .,?!"}
        }
      }
    },
    {
      $match: {
        $expr: {
          $gte: [{ $strLenCP: "$tagline" }, 4]
        }
      }
    },
    {
      $group: {
        _id: "$tagline",
        count: { $sum: 1 }
      }
    },
    {$sort: { count: -1 }},
    {$limit: 20}
  ]);
  