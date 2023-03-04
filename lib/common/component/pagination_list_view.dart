import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/model/model_with_id.dart';
import 'package:nosepack/common/provider/pagination_provider.dart';
import 'package:nosepack/common/utils/pagination_utils.dart';

import '../../product/view/product_screen.dart';
import '../model/cursor_pagination_model.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

// stf :: listener
class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView(
      {Key? key, required this.provider, required this.itemBuilder})
      : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
        controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading) {
      // real / pure loading.

      // if (data.length == 0) {
      // 항상 불러오고 있다는 걸 뜻하는 건 아님.
      // 에러가 났을 수도 있고..
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(forceRefetch: true);
              },
              child: Text("RE"))
        ],
      );
    }

    final cp = state as CursorPagination<T>;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                    child: cp is CursorPaginationFetchingMore
                        ? CircularProgressIndicator()
                        : Text("No more DATA")),
              );
            }

            final pItem = cp.data[index];

            return widget.itemBuilder(context, index, pItem);
          },
          // item sai sai
          separatorBuilder: (_, index) {
            return const SizedBox(
              height: 16.0,
            );
          },
        ));
  }
}
