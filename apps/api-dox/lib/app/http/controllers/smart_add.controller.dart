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
    'The answer is A2UI v0.9 messages: a card per expense with a Save button.',
  )
  Future<Map<String, dynamic>> read(DoxRequest req, SmartAddText body) async {
    List<Map<String, Object?>> messages = await smartAdd.read(
      req.authUser,
      req.activeGroup,
      body,
    );
    return JsonResponse.ok(<String, dynamic>{'messages': messages});
  }

  @Summary('Save a smart add card')
  @Description(
    'The A2UI action of a tapped Save button. Its `context` is checked like '
    'POST /expenses. The answer is the A2UI update that marks it saved.',
  )
  Future<Map<String, dynamic>> action(
    DoxRequest req,
    SmartAddAction body,
  ) async {
    List<Map<String, Object?>> messages = await smartAdd.save(
      req.authUser,
      req.activeGroup,
      body,
    );
    return JsonResponse.ok(<String, dynamic>{'messages': messages});
  }
}
