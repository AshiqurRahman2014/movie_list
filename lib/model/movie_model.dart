const String tableMovie='tbl_movie';
const String tblMovieColId='id';
const String tblMovieColName='name';
const String tblMovieColTitle='title';
const String tblMovieColImage='image';
const String tblMovieColDes='description';
const String tblMovieColBudget='budget';
const String tblMovieColType='type';
const String tblMovieColRelease='release_date';

class MovieModel{
  int? id;
  String name;
  String image;
  String description;
  int budget;
  String type;
  String release_date;

  MovieModel(
      {this.id,
        required this.name,
        required this.image,
        required this.description,
        required this.budget,
        required this.type,
        required this.release_date,
      });

  Map<String,dynamic> toMap(){
    final map=<String,dynamic>{
      tblMovieColName:name,
      tblMovieColDes:description,
      tblMovieColImage:image,
      tblMovieColBudget:budget,
      tblMovieColType:type,
      tblMovieColRelease:release_date,
    };
    if(id!=null){
      map[tblMovieColId]=id;
    }
    return map;
  }

  factory MovieModel.fromMap(Map<String,dynamic> map) => MovieModel(
    id: map[tblMovieColId],
    name: map[tblMovieColName],
    image: map[tblMovieColImage],
    description: map[tblMovieColDes],
    budget: map[tblMovieColBudget],
    type: map[tblMovieColType],
    release_date: map[tblMovieColRelease],);

}