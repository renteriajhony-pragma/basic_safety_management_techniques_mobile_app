import 'package:flutter_dotenv/flutter_dotenv.dart';

void loadTestEnv() {
  dotenv.loadFromString(envString: '''
JWT_SECRET=test-secret-for-unit-tests
JWT_EXPIRATION_MINUTES=60
''');
}
