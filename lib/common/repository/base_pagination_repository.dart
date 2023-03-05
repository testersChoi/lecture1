// 자체적으로는 쓰지 않음., = no need to body 인터페이스
import 'package:nosepack/common/model/model_with_id.dart';
import 'package:nosepack/common/model/pagination_params.dart';
import 'package:retrofit/retrofit.dart';

import '../model/cursor_pagination_model.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
