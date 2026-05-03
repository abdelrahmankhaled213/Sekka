import 'package:equatable/equatable.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Ui/Widget/plan_your_route.dart';

enum RoutesStateEnum {
  
  initial,
  getRoutesLoading,
  getRoutesLoaded,
  getRoutesError,
  searchRoutesLoading,
  searchRoutesLoaded,
  searchRoutesError,
  selectingStart,
  selectingEnd,
  replacingStations,
  gettingRoutePathLoading,
  gettingRoutePathLoaded,
  gettingRoutePathError,
  resetStartEnd

}

 class RoutesState extends Equatable {

     final TransportSwitiching? selectedTransportSwitching;
     final RoutesStateEnum routesStateEnum;
     final String? errorMessage;
     final List<Transport>? transports;
     final List<SegmentModel>segments;
     final int? offset;
     final bool hasMore;
     final bool isLoading;
     final List<Transport> searchResults;
     final bool? isSearchLoading;
     final String? searchText;
     final Transport? selectedTransportStart;
     final Transport? selectedTransportEnd;
    final List<Transport>? path;
    final List<StepModel> steps ;
    
    const RoutesState({
     this.selectedTransportSwitching,
     this.steps = const [],
     this.segments = const [],
     this.path,
     this.isLoading=false,
     this.routesStateEnum = RoutesStateEnum.initial,
     this.errorMessage,
     this.transports,
     this.offset=0,
     this.hasMore=true,
     this.searchResults = const [],
     this.isSearchLoading=false, 
     this.searchText,
     this.selectedTransportStart,
     this.selectedTransportEnd
  
  });

  RoutesState copyWith({
    TransportSwitiching? selectedTransportSwitching,
    List<StepModel>? steps,
    Transport? selectedTransportStart,
    RoutesStateEnum? routesStateEnum,
    String? errorMessage,
    List<Transport>? transports,
    int? offset,
    bool? hasMore,
    bool? isLoading,
    List<Transport>? searchResults,
     bool? isSearchLoading,
     String? searchText,
    Transport? selectedTransportEnd,
    List<Transport>? path,
    List<SegmentModel>? segments
  }) {
    return RoutesState(
      selectedTransportSwitching: selectedTransportSwitching ?? this.selectedTransportSwitching,
      steps: steps ?? this.steps,
      segments: segments ?? this.segments,
      path: path ?? this.path,
      selectedTransportStart: selectedTransportStart ?? this.selectedTransportStart,
      selectedTransportEnd: selectedTransportEnd ?? this.selectedTransportEnd,
      isLoading: isLoading ?? this.isLoading,
      routesStateEnum: routesStateEnum ?? this.routesStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
      transports:   transports ?? this.transports,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      searchResults: searchResults ?? this.searchResults,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      searchText: searchText ?? this.searchText,

    );
}

  @override

  List<Object?> get props => [steps,routesStateEnum
  , errorMessage, transports, offset, hasMore, isLoading
  ,searchResults, isSearchLoading,searchText, selectedTransportStart
  , selectedTransportEnd,path,segments,selectedTransportSwitching,];

}