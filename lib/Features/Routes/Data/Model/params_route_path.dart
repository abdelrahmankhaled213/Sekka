class ParamsRoutePath {

  final int start;
  final int end;

  ParamsRoutePath({required this.start, required this.end});

Map<String,dynamic> toJson(){

  return {
  'p_start_stop':start,
  'p_end_stop':end
  
  };

}
}