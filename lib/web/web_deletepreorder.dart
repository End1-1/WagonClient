import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

class WebDeletePreorder extends WebParent {

  WebDeletePreorder(int id) :
        super(sprintf("/app/mobile/preorder/%d", [id]), HttpMethod.DELE) ;

}