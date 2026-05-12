import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Error/failure.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/routes_repo.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Data/Model/fetch_params.dart';
import 'package:sekka/Features/Routes/Data/Model/params_route_path.dart';
import 'package:sekka/Features/Routes/Data/Model/params_search.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:sekka/Features/Routes/Ui/Widget/plan_your_route.dart';

class RoutesCubit extends Cubit<RoutesState> {
  final RoutesRepo routesRepo;

  RoutesCubit(this.routesRepo) : super(RoutesState());

  final TextEditingController selectedStartController = TextEditingController();
  final TextEditingController selectedEndController = TextEditingController();

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
      routesStateEnum: errorState,
      errorMessage: failure.message,
      isLoading: isLoading,
      isSearchLoading: isSearchLoading,
    ));
  }

  // ─── Reset search ───────────────────────────────────────────────────────────
  /// Clears search results AND resets pagination so fetchTransports
  /// always runs fresh when the sheet opens.
  void resetSearch() {
    emit(state.copyWith(
      searchResults: [],
      searchText: null,
      isSearchLoading: false,
      isLoading: false,
      // Reset pagination so re-opening sheet re-fetches page 0
      transports: [],
      offset: 0,
      hasMore: true,
      routesStateEnum: RoutesStateEnum.initial,
    ));
  }

  // ─── Swap ───────────────────────────────────────────────────────────────────

  void replaceMetroStations() {
    if (selectedStartController.text.isEmpty ||
        selectedEndController.text.isEmpty) {
      FlutterToastHelper.showToast(
        text: AppText.pleaseSelectStation,
        color: AppColor.error,
      );
      return;
    }

    final temp = selectedStartController.text;
    selectedStartController.text = selectedEndController.text;
    selectedEndController.text = temp;

    emit(state.copyWith(
      selectedTransportStart: state.selectedTransportEnd,
      selectedTransportEnd: state.selectedTransportStart,
      routesStateEnum: RoutesStateEnum.resetStartEnd,
    ));
  }

  // ─── Select start / end ─────────────────────────────────────────────────────

  void selectMetroStart(Transport transport) {
    selectedStartController.text = transport.name;
    emit(state.copyWith(
      selectedTransportStart: transport,
      routesStateEnum: RoutesStateEnum.selectingStart,
    ));
  }

  void selectMetroEnd(Transport transport) {
    selectedEndController.text = transport.name;
    emit(state.copyWith(
      selectedTransportEnd: transport,
      routesStateEnum: RoutesStateEnum.selectingEnd,
    ));
  }

  // ─── Get route path ─────────────────────────────────────────────────────────

  Future<void> getRoutePath() async {
    if (state.selectedTransportStart == null ||
        state.selectedTransportEnd == null) {
      FlutterToastHelper.showToast(
        text: AppText.pleaseSelectStation,
        color: AppColor.error,
      );
      return;
    }

    emit(state.copyWith(
      routesStateEnum: RoutesStateEnum.gettingRoutePathLoading,
      segments: [],
      steps: [],
    ));

    try {
      final params = ParamsRoutePath(
        start: state.selectedTransportStart!.id!,
        end: state.selectedTransportEnd!.id!,
      );

      final path = await routesRepo.fetchTransportsPath(params);
      final steps = _buildStepsFromApi(path);
      final segments = buildSegmentModel(steps);

      emit(state.copyWith(
        routesStateEnum: RoutesStateEnum.gettingRoutePathLoaded,
        path: path,
        steps: steps,
        segments: segments,
      ));
    } catch (e, stackTrace) {
      print(stackTrace);
      _emitErrorState(
        failure: _mapError(e),
        errorState: RoutesStateEnum.gettingRoutePathError,
      );
    }
  }

  List<StepModel> _buildStepsFromApi(List<Transport> data) {
    return data.map((e) {
      return StepModel(
        direction: e.directionName ?? '',
        stopName: e.name,
        type: e.type ?? TransportType.metro,
        routeName: e.routeName!,
      );
    }).toList();
  }

  // ─── Change transport type ──────────────────────────────────────────────────

  void changeTransportType(TransportSwitiching type) {
    selectedStartController.clear();
    selectedEndController.clear();
    emit(state.copyWith(
      selectedTransportSwitching: type,
      selectedTransportEnd: null,
      selectedTransportStart: null,
      routesStateEnum: RoutesStateEnum.resetStartEnd,
      transports: [],
      offset: 0,
      hasMore: true,
      isLoading: false,
      searchResults: [],
      searchText: null,
      segments: [],
      steps: [],
    ));
  }

  // ─── Fetch transports (paginated) ───────────────────────────────────────────

  Future<void> fetchTransports() async {
    if (!state.hasMore || state.isLoading) return;

    emit(state.copyWith(
      routesStateEnum: RoutesStateEnum.getRoutesLoading,
      isLoading: true,
    ));

    try {
      if (isClosed) return;

      const limit = 15;
      final offset = state.offset ?? 0;

      final params = ParamsOfFetchRoutes(
        limit: limit,
        offset: offset,
        type: state.selectedTransportSwitching?.title ?? TransportType.metro,
      );

      final data = await routesRepo.fetchTransports(params);

      final updatedList = [...?state.transports, ...data];

      emit(state.copyWith(
        routesStateEnum: RoutesStateEnum.getRoutesLoaded,
        transports: updatedList,
        offset: offset + data.length,
        hasMore: data.length == limit,
        isLoading: false,
      ));
    } catch (e, stackTrace) {
      print(stackTrace);
      _emitErrorState(
        failure: _mapError(e),
        errorState: RoutesStateEnum.getRoutesError,
        isLoading: false,
      );
    }
  }

  // ─── Search transports ──────────────────────────────────────────────────────

  Future<void> searchMetros({required String searchText}) async {
    if (searchText.isEmpty) {
      emit(state.copyWith(
        isSearchLoading: false,
        searchResults: [],
        searchText: null,
      ));
      return;
    }

    emit(state.copyWith(
      routesStateEnum: RoutesStateEnum.searchRoutesLoading,
      isSearchLoading: true,
      searchText: searchText,
      searchResults: [],
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
        searchResults: results,
      ));
    } catch (e, stackTrace) {
      print(stackTrace);
      _emitErrorState(
        failure: _mapError(e),
        errorState: RoutesStateEnum.searchRoutesError,
      );
    }
  }
}