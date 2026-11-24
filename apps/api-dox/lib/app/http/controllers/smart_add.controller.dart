import 'package:api_dox/app/dtos/smart_add/smart_add.dto.dart';
import 'package:api_dox/app/services/ai/smart_add.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Insights'])
class SmartAddController {
  SmartAddController(this.smartAdd);

  final SmartAddService smartAdd;

  @Summary('Read expenses from text')
  @Description(
    'Claude splits `text` (like "lunch 5000, taxi 3000") into expenses. '
    'Nothing is saved: each item has the keys of POST /expenses, and the '
    'app posts the ones the user keeps.',
  )
  Future<Map<String, dynamic>> read(DoxRequest req, SmartAddText body) async {
    List<Map<String, Object?>> items = await smartAdd.read(
      req.authUser,
      req.activeGroup,
      body,
    );
    return JsonResponse.ok(<String, dynamic>{'items': items});
  }
}
