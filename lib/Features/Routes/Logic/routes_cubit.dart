import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Error/failure.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/routes_repo.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Data/Model/fetch_params.dart';
import 'package:sekka/Features/Routes/Data/Model/params_route_path.dart';
import 'package:sekka/Features/Routes/Data/Model/params_search.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:sekka/Features/Routes/Ui/Widget/plan_your_route.dart';

class RoutesCubit extends Cubit<RoutesState> {
  final RoutesRepo            routesRepo;
  final TripHistoryRepository tripHistoryRepo;

  RoutesCubit(this.routesRepo, this.tripHistoryRepo) : super(RoutesState());

  final TextEditingController selectedStartController = TextEditingController();
  final TextEditingController selectedEndController   = TextEditingController();

  @override
  Future<void> close() {
    selectedStartController.dispose();
    selectedEndController.dispose();
    return super.close();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Failure _mapError(Object error) => ErrorHandler.handleError(error);

  void _emitErrorState({
    required Failure failure,
    required RoutesStateEnum errorState,
    bool isLoading = false,
    bool isSearchLoading = false,
  }) {
    emit(state.copyWith(
      routesStateEnum:  errorState,
      errorMessage:     failure.message,
      isLoading:        isLoading,
      isSearchLoading:  isSearchLoading,
    ));
  }

  // ─── Reset search ──────────────────────────────────────────────────────────

  void resetSearch() {
    emit(state.copyWith(
      searchResults:   [],
      searchText:      null,
      isSearchLoading: false,
      isLoading:       false,
      transports:      [],
      offset:          0,
      hasMore:         true,
      routesStateEnum: RoutesStateEnum.initial,
    ));
  }

  // ─── Swap stations ─────────────────────────────────────────────────────────

  void replaceMetroStations() {
    if (selectedStartController.text.isEmpty ||
        selectedEndController.text.isEmpty) {
      FlutterToastHelper.showToast(
        text:  "Please select both start and end stations before swapping",
        color: AppColor.error,
      );
      return;
    }

    final temp                   = selectedStartController.text;
    selectedStartController.text = selectedEndController.text;
    selectedEndController.text   = temp;

    emit(state.copyWith(
      selectedTransportStart: state.selectedTransportEnd,
      selectedTransportEnd:   state.selectedTransportStart,
      routesStateEnum:        RoutesStateEnum.resetStartEnd,
    ));
  }

  // ─── Select stations ───────────────────────────────────────────────────────

  void selectMetroStart(Transport transport) {
    selectedStartController.text = transport.name;
    emit(state.copyWith(
      selectedTransportStart: transport,
      routesStateEnum:        RoutesStateEnum.selectingStart,
    ));
  }

  void selectMetroEnd(Transport transport) {
    selectedEndController.text = transport.name;
    emit(state.copyWith(
      selectedTransportEnd: transport,
      routesStateEnum:      RoutesStateEnum.selectingEnd,
    ));
  }

  // ─── Get route path ────────────────────────────────────────────────────────

  Future<void> getRoutePath() async {
    if (selectedStartController.text.isEmpty ||
        selectedEndController.text.isEmpty) {
      FlutterToastHelper.showToast(
        text:  AppText.pleaseSelectStation,
        color: AppColor.error,
      );
      return;
    }

    if (selectedStartController.text == selectedEndController.text) {
      FlutterToastHelper.showToast(
        text:  "You can't select the same station for both start and end",
        color: AppColor.error,
      );
      return;
    }

    emit(state.copyWith(
      routesStateEnum: RoutesStateEnum.gettingRoutePathLoading,
      segments:        [],
      steps:           [],
    ));

    try {
      final rawSegments = await routesRepo.fetchTransportsPath(
        ParamsRoutePath(
          start: state.selectedTransportStart!.id!,
          end:   state.selectedTransportEnd!.id!,
        ),
      );

      final segments = parseSegments(rawSegments);

      for (var segment in segments) {
        debugPrint('Segment: ${segment.boardingStop} to ${segment.alightingStop}');
        debugPrint('  Line: ${segment.lineName}, Direction: ${segment.direction}, Type: ${segment.type}');
      }

      emit(state.copyWith(
        routesStateEnum: RoutesStateEnum.gettingRoutePathLoaded,
        segments:        segments,
        steps:           [],
        path:            [],
      ));

      // ── Save to trips_history ────────────────────────────────────────────
      _saveTripHistory(segments);

    } catch (e, stackTrace) {
      debugPrint('RoutesCubit getRoutePath error: $e');
      debugPrint('StackTrace: $stackTrace');
      _emitErrorState(
        failure:    _mapError(e),
        errorState: RoutesStateEnum.gettingRoutePathError,
      );
    }
  }

  void _saveTripHistory(List<SegmentModel> segments) {
    if (segments.isEmpty) return;

    final fromStation = segments.first.boardingStop;
    final toStation   = segments.last.alightingStop;
    final mode        = segments.first.type.name; // metro / bus / monorail

    final trip = TripHistoryModel(
      fromStation: fromStation,
      toStation:   toStation,
      dateTime:    DateTime.now().toIso8601String(),
      mode:        mode,
    );

    // Fire-and-forget — don't block the UI
    tripHistoryRepo.createTrip(trip).catchError(
          (e) => debugPrint('RoutesCubit _saveTripHistory error: $e'),
    );
  }

  // ─── Change transport type ─────────────────────────────────────────────────

  void changeTransportType(TransportSwitiching type) {
    selectedStartController.clear();
    selectedEndController.clear();
    emit(state.copyWith(
      selectedTransportSwitching: type,
      selectedTransportEnd:       null,
      selectedTransportStart:     null,
      routesStateEnum:            RoutesStateEnum.resetStartEnd,
      transports:                 [],
      offset:                     0,
      hasMore:                    true,
      isLoading:                  false,
      searchResults:              [],
      searchText:                 null,
      segments:                   [],
      steps:                      [],
    ));
  }

  // ─── Fetch transports (paginated) ──────────────────────────────────────────

  Future<void> fetchTransports() async {
    if (!state.hasMore || state.isLoading) return;

    emit(state.copyWith(
      routesStateEnum: RoutesStateEnum.getRoutesLoading,
      isLoading:       true,
    ));

    try {
      if (isClosed) return;

      const limit  = 15;
      final offset = state.offset ?? 0;

      final params = ParamsOfFetchRoutes(
        limit:  limit,
        offset: offset,
        type:   state.selectedTransportSwitching?.title ?? TransportType.metro,
      );

      final data        = await routesRepo.fetchTransports(params);
      final updatedList = [...?state.transports, ...data];

      emit(state.copyWith(
        routesStateEnum: RoutesStateEnum.getRoutesLoaded,
        transports:      updatedList,
        offset:          offset + data.length,
        hasMore:         data.length == limit,
        isLoading:       false,
      ));
    } catch (e, stackTrace) {
      debugPrint('RoutesCubit fetchTransports error: $e');
      debugPrint('StackTrace: $stackTrace');
      _emitErrorState(
        failure:    _mapError(e),
        errorState: RoutesStateEnum.getRoutesError,
        isLoading:  false,
      );
    }
  }

  // ─── Search transports ─────────────────────────────────────────────────────

  Future<void> searchMetros({required String searchText}) async {
    if (searchText.isEmpty) {
      emit(state.copyWith(
        isSearchLoading: false,
        searchResults:   [],
        searchText:      null,
      ));
      return;
    }

    emit(state.copyWith(
      isSearchLoading: true,
      routesStateEnum: RoutesStateEnum.searchRoutesLoading,
      searchText:      searchText,
      searchResults:   [],
    ));

    try {
      final params = ParamsOfFetchRoutesWithSearch(
        selectedTransportType:
        state.selectedTransportSwitching?.title ?? TransportType.metro,
        searchQuery: searchText,
      );

      final results = await routesRepo.fetchTransportsFilter(params);

      emit(state.copyWith(
        routesStateEnum: RoutesStateEnum.searchRoutesLoaded,
        isSearchLoading: false,
        searchResults:   results,
      ));
    } catch (e, stackTrace) {
      debugPrint('RoutesCubit searchRoutes error: $e');
      debugPrint('StackTrace: $stackTrace');
      _emitErrorState(
        failure:    _mapError(e),
        errorState: RoutesStateEnum.searchRoutesError,
      );
    }
  }
}
